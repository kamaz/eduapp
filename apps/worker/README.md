# Worker Service

Cloudflare Worker monolith providing API, auth, uploads, job orchestration, and the generation pipeline (no separate LangChain service).

## Endpoints (MVP)

- POST `/auth/verify` — validate Firebase ID token → `{ user_id }`
- POST `/children` — create child under parent
- GET `/children/:id` — fetch child + progress
- POST `/assets/upload-url` — presigned R2 URL for uploads
- POST `/assets/notify` — notify of completed upload
- POST `/tasks/generate` — enqueue generation job, returns `{ job_id }`
- GET `/lessons/scheduled?child_id=` — list scheduled lessons
- WebSocket (DO)
  - `attempt.create`, `stroke.delta`, `flush.request`
- Callback (HMAC)
  - POST `/jobs/callback/generation` — generation completion callback (HMAC-signed)

## Bindings

- D1 (primary relational store)
- Durable Objects (session state, buffering, locks, generation orchestration)
- R2 (assets, PDFs, stroke blobs)
- Vectorize (embeddings)
- Secrets: Firebase project params, HMAC secret, LLM provider keys

## Running Locally

- `pnpm dev:worker` — runs `wrangler dev`
- Configure `apps/worker/wrangler.toml` and set secrets via `wrangler secret put`.

## Notes

- Enforce AuthZ/AuthN on every path; tenant isolation by `parent_user_id`/`child_id`.
- Rate limit generation, upload, and auth endpoints; apply idempotency keys on attempt submission.
- Store outputs in R2; record metadata in D1; embeddings must exclude child-identifying text.
