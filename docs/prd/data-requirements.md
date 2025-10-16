# 📚 Data Requirements

## High-level summary

- Short-lived, real-time, session & streaming data → store in Durable Objects (per-child / per-session DOs). Examples: stroke deltas, live presence, attempt buffers, job locks, ephemeral review drafts.
- Canonical, queryable, long-term data → store in Cloudflare D1. Examples: user accounts, canonical child profiles, curriculum graph, finalized attempts, progress snapshots, scheduled lessons, job/audit logs, subscriptions, assets metadata.
- Large binary assets → store in Cloudflare R2 (images, PDFs, stroke blobs). D1/DO store references/IDs.
- Embeddings & semantic retrieval → store in Cloudflare Vectorize (embeddings + metadata pointing to topic/lesson IDs).
- Auth / Identity → Firebase Auth (tokens only). D1 stores firebase_uid mapping.
- AI orchestration → LangChain svc uses Vectorize + returns task JSON / printable HTML; Worker persists results.

## What to store (by category & location)

### Identity & Accounts

- Where: D1 (canonical users) + Firebase Auth (auth tokens)
- What: user_id, firebase_uid, email, display_name, role, created_at, last_login, settings_json
- Purpose: login, account management, billing mapping

### Child Profiles & Onboarding

- Where: D1 (children) as canonical; per-child DO caches sessionProfile
- What: child_id, parent_user_id, display_name/alias, DOB (optional), preferences_json (interests, learning_style), consent flags (wearable/third-party), onboarding timestamps
- Purpose: personalize content, seed AI, UI personalization
- Displayed to: parent dashboard, child UI (limited view)

### Curriculum & Topics

- Where: D1 (curriculum_topics, lessons, tasks) + Vectorize (snippets)
- What: subject, topic_id, title, code (UK ref), description, prerequisites, task templates, difficulty
- Purpose: map generated exercises to curriculum; power discovery & retrieval

### Generated Lessons & Tasks (definitions)

- Where: D1 (lesson/task metadata), R2 for PDF assets, Vectorize for example snippets
- What: task_id, prompt, expected_answer_json, style, difficulty, asset_r2_url, created_by (ai/user)
- Purpose: present lessons, grade attempts, schedule

### Attempts & Attempts Buffering

- Where: DO (attemptBuffer) → flush to D1 (attempts) + R2 assets for stroke blobs
- What (buffer): attempt draft, stroke delta ref, preliminary score, client device info, timestamp
- What (persisted): attempt_id, child_id, task_id, user_answer_json, score, presentation_score, correct flag, timestamp
- Purpose: progress calculation, historical reporting, parental feedback
- Displayed to: parent dashboard, tutor view (later)

### Progress & Mastery Snapshots

- Where: D1 (progress) — computed snapshots; DO caches working values for active sessions
- What: topic_id, mastery (0..1), attempts_count, last_practiced_at, history_json
- Purpose: curriculum map, scheduling decisions
- Displayed to: parent dashboard, scheduling engine

### Live Session State & Stroke Streams

- Where: DO (per-child DO instance)
- What: connected clients, stroke deltas buffer, currentTaskId, session metadata, live presence, draft comments
- Persistence pattern: compact periodic snapshot → R2 + DO meta pointer → D1 asset reference
- Purpose: live review, instant feedback, replay, collaborative sessions
- Displayed to: parent/tutor live view, child preview

### Assets & Media

- Where: R2 (actual blobs), D1 (assets) for metadata, DO for transient references
- What: r2_url, type (scan/pdf/stroke_blob), ocr_text (optional), created_at, owned_by_child_id
- Purpose: re-ingest scanned worksheets, printable delivery, archival

### Embeddings & Semantic Metadata

- Where: Cloudflare Vectorize (+ metadata in D1 referencing vector IDs)
- What: embedding vectors, source text snippet ID, topic_id, content_type, created_at, model_version
- Purpose: semantic retrieval for LangChain to generate contextually relevant exercises

### Scheduled Lessons & Job Metadata

- Where: D1 (scheduled_lessons, jobs)
- What: scheduled_for, status, source, job_payload, result_meta, audit logs
- Purpose: cron/scheduling, monitoring, retries, idempotency

### Billing & Subscription

- Where: D1 (subscriptions) + Stripe (truth)
- What: stripe_customer_id, plan, status, billing dates
- Purpose: enforce paid features, reporting

## What to process (compute & transforms)

On ingestion

- OCR on uploaded images → extract text (LangChain/OCR), write OCR summary to assets.meta_json in D1.
- Create embeddings from generated or ingested text → upsert to Vectorize (LangChain svc).

In DO (real-time)

- Compute immediate presentation_score heuristics for strokes (density, spacing) and quick answer checks.
- Buffer attempts and strokes; compute quick feedback (correct/incorrect hint).

Batch / Cron

- Periodic mastery recomputation per child/topic using attempts in D1 → update progress.
- Schedule lesson generation jobs for children with gaps or low practice rates.
- Re-index or re-embed content if embedding model changes.

AI

- LangChain uses curriculum snippets (Vectorize) + child preferences + progress snapshot to generate tasks and printable HTML/PDF.

Sync

- DO → Worker flushes buffered attempts/strokes to D1/R2 on interval or on session end.

## What to display (by persona)

Child

- Short progress indicator (level/badges), today’s tasks, live feedback, encourage messages; no raw backend details.

Parent

- Curriculum map with mastery per topic, scheduled lessons, recent attempts with scores & presentation notes, suggested activities/outings, subscription status.

Tutor (later)

- Student history, pending homework, scheduled lessons, notes from parents.

Teacher (later)

- Class-level aggregates (when integrated), suggested interventions.

## DO ↔ D1 sync rules & patterns

- Write-first to DO for fast UX: client writes strokes/attempts to DO; DO acknowledges instantly.
- Flush policy (typical):
- Time-based flush (e.g., every 30–60s) OR buffer-size-based flush (e.g., every 10 attempts).
- On session end or network reconnect flush immediately.
- On flush: DO bundles attempts/strokes → Worker persists to D1 (attempts), R2 (stroke blob) and returns persisted IDs. DO then marks buffer entries as persisted.
- Idempotency: use attempt_client_id (uuid) and job_id in payloads to dedupe writes when retries occur.
- Consistency: D1 is canonical; DOs must rehydrate from D1 on creation/restart (read last progress + last persisted assets).
- Failure handling: If DO → Worker persist fails, do exponential backoff, write job entry in D1 jobs to retry. Keep DO buffer bounded to prevent unbounded memory growth — if full, persist directly to R2 with temporary flag and return soft error to client.

## Retention, privacy & consent

- Minimal PII: store only necessary identifiers. Keep display_name as alias; limit DOB to month/year or optional.
- Consent flags: required for wearable data, third-party content sharing, or tutor sharing. Stored in children.preferences_json.
- Retention policy:
- Active data: retained while account active.
- Inactivity: after 12 months, archive to R2 snapshot + mark for deletion; notify parent.
- Deletion: on parent request, remove D1 rows, delete R2 blobs, remove Vectorize entries associated to child (or anonymize).
- Export: provide parent export (JSON + zipped assets) endpoint.
- Regulatory: plan for COPPA & GDPR-K: parental consent recorded, no direct child account creation without parent consent.

## Indexing & performance guidance (D1 & Vectorize)

- D1 indexes: children.parent_user_id, attempts.child_id, progress.child_id, scheduled_lessons.child_id, curriculum_topics.subject.
- Pagination: always use cursor-based pagination for lists.
- Vectorize usage: store snippet metadata linking to topic_id and source_type. Keep vector length moderate (embed short sentences).
- DO sizing: flush often; store minimal in-memory footprint; archive stroke blobs to R2.

## Auditing, monitoring & telemetry

- Capture: job runs, failed flushes, DO buffer overflows, OCR errors, LLM cost per job, attempts per child, daily active children.
- Tables/logs: jobs table in D1 for audit (status, payload, errors), attempts final rows, assets metadata for audits.
- Alerts: persistent DO flush failures, job failure rates above threshold, LLM error spikes.

## API & contract surface (summary, DO-aware)

Client → Worker

- POST /auth/verify (token) → returns user_id
- POST /children → create child (writes to D1)
- GET /children/:id → read child + progress (D1)
- POST /assets/upload-url → returns presigned R2 URL (Worker)
- POST /assets/notify → Worker stores metadata in D1 and enqueues OCR (if required)
- POST /tasks/generate → Worker enqueues LangChain generation job
- GET /lessons/scheduled?child_id= → D1 read
- POST /attempts → prefer via DO (WebSocket) message: attempt.create OR HTTP fallback to Worker (which writes to DO buffer)

DO ↔ Worker

- POST /persist/attempts → Worker persists buffered attempts to D1
- POST /persist/strokes → Worker stores stroke blob to R2 and writes assets row in D1

Worker ↔ LangChain

- POST /langchain/generate → returns lesson + asset payload (LangChain writes to R2 or returns asset HTML)
- LangChain calls Worker callback /jobs/callback/langchain on completion (HMAC-signed)

## Security / access control considerations

- Authenticate all client connections with Firebase ID tokens. Worker validates and maps to user_id.
- For DO WebSocket join, Worker issues short-lived signed session token for DO to validate.
- Access checks: all D1 reads/writes filter by parent_user_id or child_owner (never return data outside parent scope).
- Enforce rate limits and quotas (per-child and per-parent) to avoid abuse.
