import { flags, runtime } from '../src/index'
import { describe, expect, it } from 'vitest'

describe('config', () => {
  it('has expected defaults', () => {
    expect(flags.experimental.newFlows).toBe(false)
    expect(runtime.worker.requestTimeoutMs).toBeGreaterThan(0)
  })
})
