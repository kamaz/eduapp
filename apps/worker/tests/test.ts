import { isLocal } from './env'
import { test as baseTest, describe, beforeAll, expect } from 'vitest'
import { randomUUID } from 'crypto'
import { Logger, pino } from 'pino'

interface APIFixtures {
  trace: string
  log: Logger
}

export const test = baseTest.extend<APIFixtures>({
  // eslint-disable-next-line no-empty-pattern
  log: async ({}, use) => {
    let logLevel = process.env.TEST_LOG_LEVEL ?? 'debug'
    if (isLocal()) {
      const { env } = await import('cloudflare:test')
      logLevel = env.TEST_LOG_LEVEL ?? logLevel
    }
    const log = pino({
      msgPrefix: 'message',
      errorKey: 'err',
      timestamp: pino.stdTimeFunctions.isoTime,
      base: undefined,
      serializers: {
        err: pino.stdSerializers.err,
      },
      formatters: {
        level(label) {
          return { level: label }
        },
      },
      browser: {
        asObject: true,
        serialize: true,
        formatters: {
          level(label) {
            return { level: label }
          },
        },
        write: (o) => console.log(JSON.stringify(o)),
      },
    }).child(
      {
        app: 'test',
      },
      {
        level: logLevel,
      },
    )
    // use the fixture value
    await use(log)
  },

  trace: async ({ log }, use) => {
    const trace = randomUUID().toString()
    log.info({ trace }, 'created trace for test')

    // use the fixture value
    await use(trace)
  },
})

function traceFromResponse(response: Response): string {
  // TODO: not sure if traceparent is correct response
  return response.headers.get('traceparent') as string
}

export { describe, beforeAll, expect, traceFromResponse }
