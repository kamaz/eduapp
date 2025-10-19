// Placeholder for Zod schemas (no PII in prompts/logs per AGENTS.md)
export interface ApiResponse<T> {
  ok: boolean
  data?: T
  error?: { code: string; message: string }
}
