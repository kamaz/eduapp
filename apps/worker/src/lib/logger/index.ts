import { pino } from 'pino'

const logger = pino({
  msgPrefix: 'message',
  errorKey: 'err',
  timestamp: pino.stdTimeFunctions.isoTime,
  base: undefined,
  serializers: {
    err: pino.stdSerializers.err,
  },
  // FIXME: why worker use blowser configuration?
  // I had to configure serialiable to true to be able to see the error
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
})

export { logger }
