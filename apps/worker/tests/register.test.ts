import { randomUUID } from 'crypto'
import { describe, expect, test } from './test'
import {
  createExecutionContext,
  env,
  waitOnExecutionContext,
  type ProvidedEnv,
  SELF,
} from 'cloudflare:test'
import { createUserAndGetToken } from './user'

const fetchRegister = async (body: unknown, headers?: HeadersInit) => {
  const ctx = createExecutionContext()
  const res = await SELF.fetch(
    new Request('http://example.com/api/user/register', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...headers,
      },
      body: JSON.stringify(body),
    }),
    env as ProvidedEnv,
    ctx,
  )
  await waitOnExecutionContext(ctx)
  return res
}

const makeAuthHeader = async () => {
  const email = `kamil+${randomUUID()}@gmail.com`
  const token = await createUserAndGetToken(email)
  return { Authorization: `Bearer ${token}`, email }
}

describe('POST /register (cloudflare:test)', () => {
  test('creates a user and returns 201 on first registration', async () => {
    const auth = await makeAuthHeader()
    const res = await fetchRegister(
      {
        idempotencyKey: 'key-1',
        consent: { groupKey: 'privacy', version: 'v1' },
        profile: { locale: 'en-GB', displayName: 'Parent Example' },
      },
      { Authorization: auth.Authorization },
    )

    expect(res.status).toBe(201)
    const body = await res.json()
    expect(body.user_id).toBeDefined()
    expect(body.email).toBe(auth.email)
    expect(body.consent).toEqual({ groupKey: 'privacy', version: 'v1' })
  })

  test('returns 401 when auth header is missing', async () => {
    const res = await fetchRegister({
      idempotencyKey: 'key-3',
      consent: { groupKey: 'privacy', version: 'v1' },
    })
    expect(res.status).toBe(401)
  })

  test('returns 400 for invalid payload', async () => {
    const auth = await makeAuthHeader()
    const res = await fetchRegister({}, { Authorization: auth.Authorization })
    expect(res.status).toBe(400)
  })
})
