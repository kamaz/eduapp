import { describe, expect, it } from 'vitest'
import { Task } from '../src/types'

describe('worker types', () => {
  it('validates Task schema', () => {
    const now = new Date().toISOString()
    const parsed = Task.parse({
      name: 'Example Task',
      slug: 'example-task',
      description: 'desc',
      due_date: now,
    })
    expect(parsed.completed).toBe(false)
    expect(parsed.due_date).toBeTypeOf('string')
  })

  it('rejects invalid Task', () => {
    // missing required fields
    // @ts-expect-error runtime validation
    expect(() => Task.parse({})).toThrow()
  })
})
