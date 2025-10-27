# 🧰 Technology Stack

## Layered Architecture Diagram

```text
                ┌────────────────────────────────────────────┐
                │               FRONTEND (App)               │
                │────────────────────────────────────────────│
                │ React Native (Expo)                        │
                │ React Native Paper & Skia (Canvas, UI)     │
                │ Firebase Auth (Client Auth)                │
                │ WebSocket Client (Realtime Tasks)          │
                │ Local Cache / Offline Mode                 │
                └──────────────────────┬─────────────────────┘
                                       │
                                       │ HTTPS / WebSocket
                                       ▼
                ┌────────────────────────────────────────────┐
                │            EDGE API (Backend)              │
                │────────────────────────────────────────────│
                │ Cloudflare Workers (TypeScript API Layer)  │
                │ Durable Objects (WS sessions, locks)       │
                │ Cron Triggers (Background Jobs)            │
                │ Presigned Upload URLs (R2)                 │
                │ Auth Validation (Firebase Tokens)          │
                └──────────────────────┬─────────────────────┘
                                       │
                ┌──────────────────────┴──────────────────────┐
                │      AI & ORCHESTRATION (Within Workers)    │
                │─────────────────────────────────────────────│
                │ Generation pipeline (Durable Objects)        │
                │ Prompt templates & lesson/task generation    │
                │ Curriculum embeddings via Vectorize          │
                │ Personalisation logic                        │
                └─────────────────────────────────────────────┘
                               │
                         Embeddings/API
                               │
                ┌──────────────┴──────────────┴──────────────┐
                │         DATA & STORAGE LAYER               │
                │────────────────────────────────────────────│
                │ Cloudflare D1 (Structured Data)            │
                │ Cloudflare Vectorize (Vector Store)        │
                │ Cloudflare R2 (Images, PDFs, uploads)      │
                │ Firebase Auth (Identity only)              │
                └────────────────────────────────────────────┘

        Background & Ops:
        - Cloudflare Cron Triggers → Worker Jobs → DO coordination
        - Durable Objects manage live sessions & real-time updates
        - Monorepo with CI/CD, feature flags, and environment mgmt
```

#### Short rationale (one-liners)

- React Native + Expo: single codebase for iOS/Android tablets + phones; fast iteration.
- RN Skia + RN Paper: high-performance stylus/canvas capture + consistent UI primitives.
- Cloudflare Workers (monolith): low-latency edge API, proxied LLM orchestration, central logic without microservices complexity.
- D1: serverless relational store close to Workers for curriculum and progress.
- R2: low-cost, S3-compatible storage for uploaded images and printable PDFs.
- Cloudflare Vectorize: edge-native vector search for semantic retrieval.
- Workers monolith: orchestrates generation/ingestion without a separate LangChain service; DOs coordinate steps and state.
- Firestore: delegated auth (Firebase Auth), Workers validate tokens — keeps identity simple.
- Durable Objects + WebSocket: live review, preview and lightweight coordination (locks, small queues).
- Cron Triggers: scheduled background jobs to refresh profiles and recommend learning plans (lesson scheduling arrives post‑MVP).

### Main data flows

1. Onboarding: RN app → Worker → verify Firebase token → create child + authored profile in D1

### Client / Frontend

- React Native app with Expo for fast iteration.
- Skia canvas for handwriting, drawing, and interactive exercises.
- Local-first caching with background syncs.

### Edge / API (Monolith)

- Cloudflare Workers as TypeScript API.
- Durable Objects for session state, WebSocket, and buffer handling.
- Cron Triggers for periodic jobs.

### AI Orchestration

- Cloudflare Workers monolith orchestrates generation and ingestion using Durable Objects for multi-step flows.
- Uses Vectorize for embeddings and retrieval.
- OCR/ingestion pipeline can convert uploaded worksheets/photos into Task Templates; templates are then personalised into Tasks for a specific child/session.
- Lesson/Task templates materialise as child‑specific instances with parameters snapshotted for auditability and reproducibility.

### Data & Storage

- D1 for relational data (users, children, progress, etc.).
- R2 for assets (images, PDFs, stroke blobs).
- Vectorize for embeddings.

### Media & OCR / PDF

- OCR via Google Vision or gemini flash model.
- PDFs via puppeteer-core or pdf-lib.

### Payments & Notifications

- Stripe for billing; Postmark/Resend for emails.

### Realtime & Jobs

- WebSockets via Durable Objects; cron-triggered Workers jobs.

### Observability, Testing & CI/CD

- Repo / monorepo: pnpm + Turborepo (with pnpm workspaces). Structure: `/apps/mobile`, `/apps/worker`, `/packages/*`.
- Version control & CI: GitHub + GitHub Actions for lint, vitest, build, deploy.
- Monitoring & errors: Cloudflare Analytics + Sentry (Workers + RN app).
- Feature flags: Durable Objects or lightweight JSON in KV for MVP toggles.
- E2E testing: Playwright (if web later) or Detox for RN if needed.

### Dev / Hosting & Deployment

- Workers: Cloudflare Workers via Wrangler + GitHub Actions.
- CI/CD pipeline: GH Actions build → tests → deploy Workers (wrangler).
- Local dev: Expo dev client for RN; wrangler dev for Workers.

### Security, Privacy & Compliance

- Parental consent: explicit during onboarding, stored as audited events in D1 (`consent_records`); no PII stored without effective consent.
- Data encryption: R2 at rest + TLS in transit. D1 encrypted at rest as per Cloudflare.
- Auth validation: Workers verify Firebase ID tokens on each request.
- Export & deletion: parents can export or delete child identity and profiles (D1 + R2 assets) via API.
- Compliance posture: plan for GDPR-K / COPPA considerations (consent, limited retention, parental control).

### Recommended Libraries / Versions (practical)

- React Native & Expo: latest stable RN + Expo SDK (use Expo SDK 48+ depending on release).
- React Native Skia: @shopify/react-native-skia (match RN/Expo compatibility).
- LLM client: Workers-compatible HTTP client or Workers AI.
- Workers: TypeScript target compatible with Wrangler2.
- Cloud SDKs: Cloudflare Workers SDK, Cloudflare Vectorize client, R2 SDK helpers.
- OCR: Google gemini flash model or Google Cloud Vision client.
- PDF: puppeteer-core + chrome-aws-lambda if using serverless, or pdf-lib for programmatic generation.

### Trade-offs & rationale (short)

- Monolith Workers keeps operations simple and low-friction early; Durable Objects handle needed stateful pieces (websockets, locks, orchestration).
- Cloudflare-first stack (D1 / R2 / Vectorize) reduces network latency and vendor sprawl; Vectorize gives edge vector search.
- Firestore for auth centralises identity with a mature provider; D1 remains canonical for learning data to avoid coupling.
- Google Vision OCR gives best accuracy out of the box — faster to pilot; Tesseract is cheaper but less accurate (fallback).

### Minimal infra & services to provision (MVP)

- Cloudflare account with: Workers, Durable Objects, D1, R2, Vectorize, KV, Cron Triggers.
- Firebase project (Auth only).
- (No separate LangChain service to provision.)
- Stripe account + webhook endpoints.
- Google Cloud project.
- GitHub repo + Actions, Turborepo/pnpm.
- Sentry & Postmark/Resend accounts.

### Local Emulators (Development)

- Firebase Auth Emulator is provided in `devtools/firebase-emulator`.
- Start via `pnpm -w dev:emulators`; UI at `http://127.0.0.1:4000`.
- Workers validate emulator-issued ID tokens when `FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099` is set.
