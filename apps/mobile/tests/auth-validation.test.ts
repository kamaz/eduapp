import { describe, expect, it } from 'vitest'
import { validateEmail, validatePassword } from '../auth/validators'

describe('auth validators', () => {
  it('validates email format', () => {
    expect(validateEmail('')).toBeTruthy()
    expect(validateEmail('not-an-email')).toBeTruthy()
    expect(validateEmail('user@example.com')).toBeNull()
  })

  it('validates password min length', () => {
    expect(validatePassword('')).toBeTruthy()
    expect(validatePassword('123')).toBeTruthy()
    expect(validatePassword('123456')).toBeNull()
  })
})
