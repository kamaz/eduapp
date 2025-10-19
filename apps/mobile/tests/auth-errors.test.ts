import { describe, expect, it } from 'vitest'
import { mapAuthError } from '../auth/auth-errors'

describe('auth error mapping', () => {
  it('maps known codes to friendly messages', () => {
    expect(mapAuthError({ code: 'auth/invalid-email' })).toMatch(/valid email/i)
    expect(mapAuthError({ code: 'auth/user-not-found' })).toMatch(/no account/i)
    expect(mapAuthError({ code: 'auth/wrong-password' })).toMatch(/incorrect password/i)
    expect(mapAuthError({ code: 'auth/email-already-in-use' })).toMatch(/already in use/i)
  })

  it('returns fallback for unknown errors', () => {
    expect(mapAuthError({ code: 'auth/unknown' })).toBe('Something went wrong')
  })
})
