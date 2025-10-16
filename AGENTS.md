## Purpose

- Give agents and contributors concise, actionable guidance grounded in the PRD.
- Define priorities, constraints, and conventions to keep work aligned and safe.

## Scope & Precedence

- Scope: Entire repository (root-level). Applies to all code and docs.
- Precedence: Direct user/developer instructions > AGENTS.md > other docs.

## Product Summary (from PRD)

- Goal: Personalised learning for children with AI-generated activities aligned to the UK National Curriculum; shared insights for parents, tutors, teachers.
- MVP Personas: Child, Parent (core). Tutors/Teachers later.
- Core: Tablet-first child experience; parents use mobile; shared cloud back-end; printable worksheets with scan/assess flow.

## Architecture (target)

- Apps
  - Mobile (React Native + Expo): child + parent client.
  - Edge API (Cloudflare Workers / TypeScript): monolith API, auth, upload URLs, job orchestration, generation pipeline (no separate LangChain service).
- Data & Infra
  - D1: canonical relational data (users, children, curriculum, tasks, attempts, progress, jobs, assets metadata, subscriptions).
  - Durable Objects (DO): ephemeral session state, WebSockets, buffering (strokes/attempts), locks; also used for generation orchestration.
  - R2: binary assets (images, PDFs, stroke blobs).
  - Vectorize: embeddings for retrieval.
  - Firebase Auth: identity tokens only (mapped in D1).
- Payments & Notifications: Stripe, Postmark/Resend.

## Repository Structure (expected)

- apps/mobile — Expo app
- apps/worker — Cloudflare Workers API (TypeScript) including generation pipeline
- packages/\* — shared types, utils, schema, config
- docs/prd — product docs (split per section)

## Languages, Tooling & Versions

- TypeScript everywhere (strict). Node 18+.
- React Native + Expo (latest stable SDK compatible with RN Skia).
- Package manager: pnpm. Monorepo: Turborepo.
- Tests: vitest for TS packages/services; Detox/E2E optional later.

## Data Rules (must)

- Canonical writes/read models live in D1; DO is ephemeral and flushes to D1/R2.
- Assets go to R2; D1 stores metadata/links; DO only references.
- Embeddings in Vectorize must not include child-identifying text.
- Use cursor pagination; add indexes noted in PRD (children.parent_user_id, attempts.child_id, etc.).

## Security & Privacy (must)

- Validate Firebase ID tokens on every API call; enforce tenant isolation by parent_user_id/child_id.
- DO WebSocket sessions use short-lived signed tokens; reject unsigned/expired.
- PII minimisation: use child alias; DOB optional; no sensitive data in logs/prompts.
- Rate limit generation, uploads, and auth endpoints; add idempotency keys for attempt submissions.
- Stripe via Checkout; never store card data; validate webhooks.
- Use signed, short-lived R2 URLs; validate MIME and size on uploads.

## API & Contracts (MVP slice)

- Client → Worker
  - POST /auth/verify (token) → user_id
  - POST /children, GET /children/:id (with progress)
  - POST /assets/upload-url, POST /assets/notify
  - POST /tasks/generate (enqueue)
  - GET /lessons/scheduled?child_id=
  - WebSocket via DO: attempt.create, stroke.delta, flush.request
- Worker (internal generation pipeline)
  - Generation orchestrated via DO; outputs stored in R2; metadata in D1.
  - Callback: POST /jobs/callback/generation (HMAC-signed)
- DO ↔ Worker
  - /persist/attempts, /persist/strokes (idempotent)

## MVP Implementation Priorities (from PRD Next Steps)

1. Define DO interface (messages, flush policy, idempotency keys).
2. D1 schema (users, children, curriculum, tasks, attempts, progress, scheduled_lessons, assets, jobs, subscriptions).
3. R2 presigned upload and OCR stub wiring.
4. Generation job contract in Worker; store outputs in R2, metadata in D1.
5. Minimal client flow: onboarding → create child → session start → attempt → flush → parent dashboard reads D1.

## Coding Conventions

- Naming: kebab-case for files, camelCase for vars, PascalCase for types/components.
- Modules: keep functions pure; side effects isolated (API, DO handlers).
- Module system: ESM only across the repo. Use `export`/`import` syntax. Configs that need JS should be `.mjs` (or `.js` under a package with `"type": "module"`). Do not use CommonJS (`require`, `module.exports`).
- Errors: never throw raw; use typed error helpers; sanitize messages.
- Logging: no PII; use IDs; log levels structured (debug/info/warn/error).
- Config: .env.\* or Wrangler secrets; never commit secrets.

## Testing Guidance

- Unit: vitest for pure logic (schema, mappers, guards, prompts builders).
- API: contract tests for key endpoints and auth guards.
- DO: simulate message flows (attempt buffering, flush, idempotency, generation orchestration).
- Snapshots: stable for schema/contract JSON where helpful.

## Definition of Done (feature)

- AuthZ/AuthN enforced; inputs validated (Zod/JSON Schema).
- Unit/API tests for happy + key error paths.
- Logs redact PII; feature behind flag if experimental.
- Docs updated (README in app/service + API notes if changed).

## Performance & Cost

- Keep DO buffers bounded; flush on timer and size thresholds.
- Batch DB writes; prefer prepared statements/transactions.
- Add quotas for LLM usage; emit usage metrics per job.

## UX Notes (MVP)

- Child: simple progress indicator, positive reinforcement; avoid raw scores.
- Parent: curriculum map, recent attempts, suggested next steps; printable flow prominent.

## How to Run (target local workflow)

- Mobile: pnpm -w dev:mobile (Expo dev client)
- Worker: pnpm -w dev:worker (wrangler dev)
- Shared packages build: pnpm -w build
- Clean: pnpm clean (removes all node_modules across workspaces, dist folders, and .turbo cache; run pnpm install afterwards)

## PR Checklist

- Does code follow data rules (D1 canonical, R2 assets, no PII in logs/prompts)?
- Are auth checks and tenant isolation present on every path?
- Are inputs validated and outputs typed?
- Are idempotency keys and rate limits applied where needed?
- Are tests and docs updated?
- Pre-commit: Husky + lint-staged must pass (ESLint/Prettier) before commit.

## References

- docs/prd/README.md — PRD TOC
- docs/prd/problem-identification/README.md
- docs/prd/target-audience/README.md
- docs/prd/platform-strategy/README.md
- docs/prd/core-mvp-features/README.md
- docs/prd/technology-stack/README.md
- docs/prd/data-requirements/README.md
- docs/prd/security-plan/README.md
- docs/prd/next-steps.md
