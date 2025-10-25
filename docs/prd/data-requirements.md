# 📚 Data Requirements

## High-level summary

- Short-lived, real-time, session & streaming data → store in Durable Objects (per-child / per-session DOs). Examples: stroke deltas, live presence, attempt buffers, job locks, ephemeral review drafts.
- Canonical, queryable, long-term data → store in Cloudflare D1. Examples: user accounts, canonical child profiles, curriculum graph, finalized attempts, progress snapshots, scheduled lessons, job/audit logs, subscriptions, assets metadata.
- Large binary assets → store in Cloudflare R2 (images, PDFs, stroke blobs). D1/DO store references/IDs.
- Embeddings & semantic retrieval → store in Cloudflare Vectorize (embeddings + metadata pointing to topic/lesson IDs).
- Auth / Identity → Firebase Auth (tokens only). D1 stores firebase_uid mapping.
- AI orchestration → Workers monolith uses Vectorize + orchestrates generation; persists results to D1/R2.

## What to store (by category & location)

### Identity & Accounts

- Where: D1 (canonical users) + Firebase Auth (auth tokens)
- What: user_id, firebase_uid, email, display_name, role, created_at, last_login, settings_json
- Purpose: login, account management, billing mapping

### Child Identity & Onboarding

- Where: D1 (`children` canonical identity) + D1 (`child_profile`, `child_profile_items`, `child_observations`); DO caches transient session state.
- Children (identity): id, primary_parent_user_id, alias (pseudonymous), given_name (optional), family_name (optional), preferred_name (optional), short_name, nickname, internal email (routing only), avatar_asset_id (FK assets), locale (optional), DOB fields, timestamps.
- Child Profile (structured per-user perspective): one active profile per (child_id, user_id).
  - `child_profile`: id, child_id, created_by_user_id, updated_by_user_id (nullable), authored_by_child (boolean), persona_role (parent|tutor|teacher|family), status (active|archived), learning_style, profile_summary, sensitivities, timestamps.
  - `child_profile_items`: id, profile_id, type (interest|book|movie|game), value, created_at.
- Observations (time series): `child_observations`: id, child_id, user_id, note_type, body, status (active|superseded|archived), superseded_by_observation_id (nullable), timestamps.
- Purpose: richer AI personalization using multiple persona inputs without overwriting; auditability of who provided what.
- Displayed to: parent dashboard, tutor/teacher views (as applicable), child UI (curated subset).

### Child Primary & Sharing Model

- Where: D1 (children, child_access)
- What: child_access rows define which users can access a child and at what permission level
  - child_id, user_id, persona_role (parent|tutor|teacher|family), access_level (viewer|contributor|manager), is_primary_parent (boolean), created_at
  - Constraints:
    - Exactly one Primary per child: children.primary_parent_user_id references users.id
    - Unique membership per (child_id, user_id)
    - Only Primary can: invite/remove Parents, grant/revoke Parent management (manager) rights
    - Parents (Primary or invited) can: invite/remove Tutors, Teachers, Family (viewer/contributor), unless Primary restricts
    - No one can remove the Primary; Primary can revoke any other membership
  - Audit: store inviter_user_id, revoked_at for revoked memberships (optional follow-up)
  - Idempotency: dedupe invitations by (child_id, target_user_id, persona_role)

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
- Purpose: semantic retrieval for generation to produce contextually relevant exercises

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

- OCR on uploaded images → extract text (OCR), write OCR summary to assets.meta_json in D1.
- Create embeddings from generated or ingested text → upsert to Vectorize (Worker pipeline).

In DO (real-time)

- Compute immediate presentation_score heuristics for strokes (density, spacing) and quick answer checks.
- Buffer attempts and strokes; compute quick feedback (correct/incorrect hint).

Batch / Cron

- Periodic mastery recomputation per child/topic using attempts in D1 → update progress.
- Schedule lesson generation jobs for children with gaps or low practice rates.
- Re-index or re-embed content if embedding model changes.

AI

- Generation pipeline uses curriculum snippets (Vectorize) + child preferences + progress snapshot to generate tasks and printable HTML/PDF.

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
- Consents are stored as audited events in `consent_records` (user_id ↔ child_id ↔ consent_type). Each event has action (granted|revoked), policy version, optional scope/reason, and timestamp. Evaluate latest effective consent per (user, child, type) before processing data. No consent fields are stored directly on `children`.
- Retention policy:
- Active data: retained while account active.
- Inactivity: after 12 months, archive to R2 snapshot + mark for deletion; notify parent.
- Deletion: on parent request, remove D1 rows, delete R2 blobs, remove Vectorize entries associated to child (or anonymize).
- Export: provide parent export (JSON + zipped assets) endpoint.
- Regulatory: plan for COPPA & GDPR-K: parental consent recorded, no direct child account creation without parent consent.

## Indexing & performance guidance (D1 & Vectorize)

- D1 indexes: children.primary_parent_user_id, child_access.child_id, child_access.user_id,
  access_requests.requester_user_id, access_requests.target_parent_user_id, access_requests.target_parent_email, access_requests.token,
  attempts.child_id, progress.child_id, scheduled_lessons.child_id, curriculum_topics.subject.
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
- POST /children → create child (Primary only; writes to D1)
- GET /children/:id → read child + progress (D1)
- POST /children/:id/share → invite user to access child (roles: parent/tutor/teacher/family; levels: viewer|contributor|manager)
- PATCH /children/:id/share/:membership_id → update access level (Primary limits for parent management)
- DELETE /children/:id/share/:membership_id → revoke access (cannot remove Primary; only Primary can remove Parents)
- POST /assets/upload-url → returns presigned R2 URL (Worker)
- POST /assets/notify → Worker stores metadata in D1 and enqueues OCR (if required)
- POST /generation/requests → Worker creates GENERATION_REQUEST (idempotent) and enqueues internal job
- GET /lessons/scheduled?child_id= → D1 read
- POST /attempts → prefer via DO (WebSocket) message: attempt.create OR HTTP fallback to Worker (which writes to DO buffer)

Access Requests

- POST /access-requests → create non‑primary → primary request
  - Body: target_parent_user_id OR target_parent_email; desired_persona_role; desired_access_level; optional message (sanitized)
  - AuthZ: requester must be authenticated; rate‑limited per requester; idempotent by (requester, target)
- POST /access-requests/:id/accept → Primary accepts, selects/creates Child, assigns access level (manager only for Parent role)
- POST /access-requests/:id/decline → Primary declines
- GET /access-requests (requester) → list own sent requests (filter by status)
- GET /access-requests (parent) → list incoming requests (pending)

DO ↔ Worker

- POST /persist/attempts → Worker persists buffered attempts to D1
- POST /persist/strokes → Worker stores stroke blob to R2 and writes assets row in D1

Generation pipeline (internal in Workers)

- DO orchestrates steps: ocr → extract → map → generate_tasks → schedule_lesson → persist
- Status exposed via D1 rows (GENERATION_REQUESTS/JOBS/JOB_STEPS); no external callbacks required

## Security / access control considerations

- Authenticate all client connections with Firebase ID tokens. Worker validates and maps to user_id.
- For DO WebSocket join, Worker issues short-lived signed session token for DO to validate.
- Access checks:
  - Tenant boundary anchored to children.primary_parent_user_id.
  - Per-request authorization via child_access membership: must have appropriate access_level for operation.
  - Only Primary can grant/revoke Parent management and invite/remove Parents; Parents can share with Tutor/Teacher/Family unless restricted.
- Enforce rate limits and quotas (per-child and per-parent) to avoid abuse.

### Access Requests (Non‑Primary Personas)

- Where: D1 (`access_requests`) + Email provider (Postmark/Resend) for delivery.
- Purpose: allow non‑primary personas (Tutor/Teacher/Family/Parent) to request access from the Primary Parent.
- What: request_id, requester_user_id, target_parent_user_id (nullable if unknown), target_parent_email,
  desired_persona_role (parent|tutor|teacher|family), desired_access_level (viewer|contributor|manager),
  status (pending|accepted|declined|expired|canceled), token (secure random), expires_at,
  message (optional, sanitized), created_at, updated_at, acted_at, acted_by_user_id.
- Constraints & behavior:
  - If `target_parent_user_id` is known: create in‑app notification and send email.
  - If only `target_parent_email` is provided: send email with a secure invite link to onboard and accept.
- Only the Primary Parent may accept; only a Parent can create the Child during acceptance.
- On acceptance: Primary selects an existing Child or creates a new Child, then the system grants `child_access` according to Primary’s choice:
  - Parent role → viewer/contributor; manager optional and settable only by Primary.
  - Tutor/Teacher/Family → viewer or contributor (no manager).
  - Idempotency: dedupe by (requester_user_id, target_parent_email, desired_persona_role, status='pending')
    OR (requester_user_id, target_parent_user_id, desired_persona_role, status='pending').
  - Rate limits: per‑requester daily cap and domain throttling to prevent abuse.
  - Audit: store acted_by_user_id, acted_at, and email delivery metadata (separate log or provider id).
