import { Logger } from 'pino'
import { getTokenUser1 } from './user'

export type RequestOptions = {
  apiKey?: string
  body?: string | Record<string, unknown>
  token?: string
  trace?: string
  log?: Logger
}

export async function authHeader(options?: RequestOptions): Promise<Record<string, string>> {
  let token: string | undefined = await getTokenUser1()
  if (options && 'token' in options) {
    token = options.token
  }
  let header: Record<string, string> = {}
  if (token) {
    header = { authorization: `Bearer ${token}` }
  }
  if (options?.apiKey) {
    token = options.apiKey
    header = { 'x-api-key': token }
  }
  return header
}
