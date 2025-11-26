import { createMiddleware } from 'hono/factory'
import { logger } from '~/lib'

export const logMiddleware = createMiddleware(async (c, next) => {
  const childLogger = logger.child(
    {
      requestPath: c.req.path,
      requestMethod: c.req.method,
      traceId: c.var.traceparent,
    },
    // TODO: enable dynamic log level
    // { level: c.env.LOG_LEVEL },
    { level: 'debug' },
  )
  try {
    console.log('log middleware started')
    childLogger.debug('executing log middleware')
    c.set('log', childLogger)
    c.var.log.debug('moving out of log middleware')
    await next()
  } catch (err) {
    c.var.log.error({ err }, 'failed to create context logger')
    // replace with global error
    throw new Error('Server Error')
  } finally {
    childLogger.debug('completing log middleware')
  }
})
