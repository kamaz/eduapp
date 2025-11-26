const host = process.env.BASE_URL ?? 'http://example.com'
//
// FIXME: correct
// @ts-expect-error remove once vitest is configure
export const isLocal = (): boolean => import.meta.env.DEV && host === 'http://example.com'

export const isRemote = (): boolean => !isLocal()

export const getHost = (): string => host
