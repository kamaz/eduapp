type FirebaseLikeError = { code?: string; message?: string }

const FRIENDLY: Record<string, string> = {
  'auth/invalid-email': 'Enter a valid email address.',
  'auth/user-not-found': 'No account found for this email.',
  'auth/wrong-password': 'Incorrect password. Please try again.',
  'auth/too-many-requests': 'Too many attempts. Please try later.',
  'auth/email-already-in-use': 'Email already in use. Try signing in.',
  'auth/weak-password': 'Password is too weak. Use at least 6 characters.',
  'auth/network-request-failed': 'Network error. Check your connection.',
}

export function mapAuthError(err: unknown, fallback = 'Something went wrong') {
  const e = (err || {}) as FirebaseLikeError
  const code = e.code || ''
  if (code && FRIENDLY[code]) return FRIENDLY[code]
  return fallback
}
