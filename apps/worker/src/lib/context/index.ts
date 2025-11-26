import { Context } from 'hono'
import { Logger } from 'pino'
import type { UserTokenIdentity } from '~/middleware/firebase-auth'

export type AppBindings = {
  Bindings: Env
  Variables: {
    identity: UserTokenIdentity
    log: Logger
  }
}
export type AppContext = Context<AppBindings>
