export function validateEmail(email: string): string | null {
  const value = (email || '').trim()
  if (!value) return 'Email is required'
  // Simple RFC 5322-friendly check for practical purposes
  const ok = /.+@.+\..+/.test(value)
  return ok ? null : 'Enter a valid email address'
}

export function validatePassword(password: string): string | null {
  const value = password || ''
  if (!value) return 'Password is required'
  if (value.length < 6) return 'Use at least 6 characters'
  return null
}
