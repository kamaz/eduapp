# Next Steps (MVP)

1. Define DO interface (messages, flush policy, idempotency keys)
2. D1 schema (users, children, curriculum, tasks, attempts, progress, scheduled_lessons, assets, jobs, subscriptions)
3. R2 presigned upload and OCR stub wiring
4. Generation job contract in Worker; store outputs in R2; metadata in D1; HMAC callback `/jobs/callback/generation`
5. Minimal client flow: onboarding → create child → session start → attempt → flush → parent dashboard reads D1

## Testing

- Contract tests for Worker endpoints and auth guards
- DO flows: attempt buffering, flush, idempotency, generation orchestration
- Unit tests for schema/mappers/guards/prompt builders (no PII)
