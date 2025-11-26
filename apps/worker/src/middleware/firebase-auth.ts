import type { Context } from 'hono'
import { createMiddleware } from 'hono/factory'
import * as jwt from 'jsonwebtoken'
import { isLocal } from '~/lib'
import { z } from 'zod'

export const UserTokenIdentitySchema = z.object({
  type: z.literal('user_token'),
  id: z.string(),
  email: z.string(),
  emailVerified: z.boolean(),
})

export type UserTokenIdentity = z.infer<typeof UserTokenIdentitySchema>
export function getHeaderValue(c: Context): string | undefined {
  return c.req.header('authorization')
}

// FIXME: change to use access token
// https://auth0.com/blog/id-token-access-token-what-is-the-difference/
/**
 * Middleware to validate Firebase JWT tokens
 * @param options Firebase project configuration
 */
export const firebaseAuth = createMiddleware(async (c, next) => {
  c.var.log.debug('executing firebase auth middleware')
  // Get the Authorization header
  const authHeader = getHeaderValue(c)

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    c.var.log.error({ authHeader }, 'invalid bearer token')

    return c.json({ error: 'Unauthorized: No token provided' }, 401)
  }

  // Extract the token
  const token = authHeader.split(' ')[1]
  c.var.log.debug({ token }, 'got token from header')

  try {
    const identity = await decodeToken(c, token)

    // FIXME: this is replacement for user
    c.set('identity', identity)

    // FIXME: inject user to the logger
    c.var.log.debug('moving out of firebase auth middleware')
    await next()
  } catch (err) {
    c.var.log.error({ err }, 'token validation error')
    // throw new AuthenticationException("Invalid token format");
    throw new Error('Invalid token format')
  } finally {
    c.var.log.debug('completed firebase auth middleware')
  }
})

async function decodeToken(c: Context, token: string): Promise<UserTokenIdentity> {
  const decodeBase64 = (value: string) => {
    if (typeof atob === 'function') return atob(value)
    return Buffer.from(value, 'base64').toString('utf8')
  }

  // Allow base64 JSON tokens for local/dev to simplify tests.
  if (isLocal(c)) {
    const maybeBase64 = token.includes('.') ? token.split('.')[1] : token
    try {
      const payload = JSON.parse(decodeBase64(maybeBase64))
      return {
        type: 'user_token',
        id: (payload.uid as string) ?? (payload.sub as string) ?? 'local-user',
        email: (payload.email as string) ?? 'local@example.com',
        emailVerified: Boolean(payload.email_verified ?? payload.emailVerified),
      }
    } catch {
      // fall through to standard decode for unexpected shapes
    }
  }

  const decodedToken = jwt.decode(token, { complete: true })

  if (!decodedToken) {
    c.var.log.error({ decodedToken }, 'invalid decoded token')
    throw new Error('Invalid token format')
  }

  c.var.log.debug('starting to verify token')
  const kid = decodedToken.header.kid

  if (!kid) {
    c.var.log.debug({ kid }, 'missing key id for token')
    throw new Error('Invalid token format')
  }

  // Fetch Google's public keys
  const googlePublicKeys = await fetchGooglePublicKeys()
  const publicKey = googlePublicKeys[kid]

  if (!publicKey) {
    c.var.log.error({ publicKey }, 'invalid public key')
    throw new Error('Invalid token format')
  }

  jwt.verify(token, publicKey, {
    algorithms: ['RS256'],
    issuer: `https://securetoken.google.com/${c.env.FIREBASE_PROJECT_ID}`,
    // @ts-expect-error payload is loosely typed; audience comes from token.
    audience: decodedToken.payload.aud,
  })

  return {
    type: 'user_token',
    // @ts-expect-error uid/sub from token payload
    id: decodedToken.payload.uid || decodedToken.payload.sub,
    // @ts-expect-error email from token payload
    email: decodedToken.payload.email,
    // @ts-expect-error email_verified from token payload
    emailVerified: decodedToken.payload.email_verified,
  }
}

/**
 * Fetches Google's public keys used to verify Firebase tokens
 */
async function fetchGooglePublicKeys(): Promise<Record<string, string>> {
  // Use cache if available
  const jwksURL =
    'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'
  const cachedKeys = await caches.default.match(jwksURL)

  if (cachedKeys) {
    const keys = await cachedKeys.json()
    return keys as Record<string, string>
  }

  // Fetch fresh keys
  const response = await fetch(jwksURL)

  // Get cache control header to set TTL
  const cacheControl = response.headers.get('Cache-Control')
  let ttl = 3600 // Default: 1 hour

  if (cacheControl) {
    const maxAgeParts = cacheControl.match(/max-age=(\d+)/)
    if (maxAgeParts && maxAgeParts[1]) {
      ttl = parseInt(maxAgeParts[1], 10)
    }
  }

  const keys = await response.json()

  // Cache the keys
  const cache = new Response(JSON.stringify(keys), {
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': `public, max-age=${ttl}`,
    },
  })

  await caches.default.put(jwksURL, cache)

  return keys as Record<string, string>
}
