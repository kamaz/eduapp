# Next Steps

## Technical Short next-steps (practical checklist)

1. Create Cloudflare account & provision Workers, D1, R2, Vectorize, KV, Durable Objects.
2. Set up Firebase Auth (enable email sign-in) and publish keys.
3. Scaffold monorepo (Expo mobile, Workers, LangChain svc, shared-types).
4. Provision Stripe + test keys, Postmark/Resend for emails.
5. Implement onboarding flow client → Worker → D1 and Firebase token verification.
6. Build LangChain stub /generate-exercise via simple prompt + Vectorize retrieval.
7. Implement presigned R2 upload flow, OCR pipeline, and minimal printable PDF pipeline.
8. Add Cron Trigger + Worker cron endpoint stub and Durable Object lock.
9. Run pilot with 10–20 families, collect feedback & iterate.

### Implementation & rollout priorities (next actions)

1. Define DO interface: messages (stroke.delta, attempt.create, flush.request, session.join). I can draft this next.
2. Implement D1 schema: create canonical tables for users, children, curriculum, tasks, attempts, progress, scheduled_lessons, assets, jobs.
3. Implement DO flush strategy (time/buffer thresholds + idempotent persist).
4. Integrate R2 upload flow and OCR stub.
5. LangChain job contract for generation; store resulting assets in R2 and metadata in D1.
6. Build minimal client flows: onboarding → create child → session start → attempt → flush → parent dashboard reads D1.

### Offer: I can produce these artifacts next (pick one or more)

• A compact Durable Object interface spec (message schema for WebSocket & Worker calls).
• A revised D1 schema SQL reflecting DO-managed buffering and no raw strokes columns.
• Pseudocode for DO flush logic (timers, batching, retry/backoff, idempotency).
• API OpenAPI (YAML) for the endpoints listed (MVP subset).
