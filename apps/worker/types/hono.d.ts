declare module 'hono' {
  interface ContextVariableMap {
    user: {
      uid: string
      email?: string
      emailVerified?: boolean
    }
  }
}
