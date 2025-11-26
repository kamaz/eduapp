import { Context } from 'hono'

export function isLocal(c: Context): boolean {
  return c.env.ENVIRONMENT === 'local'
}
