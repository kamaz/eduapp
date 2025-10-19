import type { Context } from 'hono'
import { z } from 'zod'

export type AppContext = Context<{ Bindings: Env }>

export const Task = z.object({
  name: z.string(),
  slug: z.string(),
  description: z.string().optional(),
  completed: z.boolean().default(false),
  // ISO 8601 datetime string
  due_date: z.string().datetime(),
})
