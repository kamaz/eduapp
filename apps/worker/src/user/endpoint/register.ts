import { registrationRequestSchema } from './model'
import { createRegistrationService } from '../service'
import type { AppContext } from '~/lib'

export const register = async (c: AppContext) => {
  const parsedBody = registrationRequestSchema.safeParse(await c.req.json().catch(() => null))
  if (!parsedBody.success) {
    return c.json({ error: 'invalid_request', details: parsedBody.error.flatten() }, 400)
  }

  const claims = c.get('identity')
  if (!claims) {
    return c.json({ error: 'unauthorized', message: 'Missing firebase claims' }, 401)
  }

  try {
    const registrationService = createRegistrationService(c.env)
    const result = await registrationService.register({
      firebaseUid: claims.id,
      email: claims.email,
      emailVerified: claims.emailVerified ?? false,
      idempotencyKey: parsedBody.data.idempotencyKey,
      consent: parsedBody.data.consent,
      profile: parsedBody.data.profile,
      now: new Date(),
    })
    const status = result.created ? 201 : 200
    return c.json(
      {
        user_id: result.userId,
        email: result.email,
        consent: result.consent,
      },
      status,
    )
  } catch (err) {
    c.var.log.error({ err: err }, 'failed to persist user')
    return c.json({ error: 'registration_failed' }, 500)
  }
}
