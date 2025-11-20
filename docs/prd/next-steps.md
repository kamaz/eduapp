# Next Steps (MVP)

1. Define DO interface (messages, flush policy, idempotency keys)
2. D1 schema (users, children, child_access [with is_primary_parent], access_requests, child_profile, child_profile_items, child_observations, consent_records, curriculum_subjects, curriculum_topics, curriculum_prereqs, lesson_templates, lesson_instances, task_templates, task_instances, attempts, progress, assets, generation_requests, request_assets, jobs, job_steps, subscriptions)
3. R2 presigned upload and OCR stub wiring
4. Generation & ingestion pipeline in Worker; store outputs in R2; metadata in D1 (GENERATION_REQUESTS/JOBS/JOB_STEPS); no external callbacks
   - Uploads (photos/PDFs) → OCR/extract → Task Template creation → optional personalisation into Tasks for a specific child/session.
5. Minimal client flow: onboarding → create child (Primary) → share child (parent/tutor/teacher/family) → session start → attempt → flush → parent dashboard reads D1
6. Local dev: Firebase Auth Emulator wired for token validation

### Primary Parent & Sharing (MVP Must)

- Add `child_access` table and enforcement in Worker guards. Include `is_primary_parent` boolean.
- Endpoints: POST/PATCH/DELETE `/children/:id/share` with role + access_level semantics.
- Only Primary can invite/remove Parents and grant/revoke management; Parents can invite/remove Tutors/Teachers/Family unless restricted.
- Update DO session issuance to check membership for the joining user on the target child.

### Onboarding Profiles (MVP)

- Add `child_profile` (one active profile per child+user), `child_profile_items` (interests/media per profile), and `child_observations` (time-series notes).
- Capture authored_by_child flag on profile when content is entered by the child under supervision.
- Merge active profiles at request time for AI personalization (dedupe tags, sanitize text; no child-identifying text to Vectorize).

### Consent Events (MVP)

- Add `consent_records` for audited parental consent events per (user, child, type) with action (granted|revoked), version, scope, reason, timestamp.
- Evaluate latest effective consent before processing child data.

### Access Requests (MVP Beta)

- Add `access_requests` table with status machine and secure token.
- Endpoints:
  - POST /access-requests (requester) — create request by target_parent_user_id or target_parent_email with desired role/level
  - POST /access-requests/:id/accept (primary) — accept, select/create child, assign access level
  - POST /access-requests/:id/decline (primary) — decline
  - GET list endpoints for requester inbox and parent inbox
- Email templates and delivery via Postmark/Resend with short‑lived tokens.
- Rate limits and abuse monitoring metrics; audit logs for request lifecycle.

## Testing

- Contract tests for Worker endpoints and auth guards
- DO flows: attempt buffering, flush, idempotency, generation orchestration
- Unit tests for schema/mappers/guards/prompt builders (no PII)
- Access control tests: primary-only mutations, parent vs tutor permissions, non-primary cannot remove primary, idempotent invites
- Access request tests: per‑requester rate limits, token acceptance, parent‑only child creation, membership grant on accept, email fallback for unknown parent

## Post‑MVP: Learning Plans & Scheduling

- Introduce goal‑oriented planning (see Learning Plans & Scheduling PRD) to support level targets and exam readiness timelines.
- Add `scheduled_lessons` (plan items) and goal/milestone entities:
  - `learning_goals`, `learning_milestones`, and extend `scheduled_lessons` with audit fields (e.g., created_by_user_id, completed_at/canceled_at).
- API (examples):
  - GET /plans?child_id= — list goals and milestones
  - GET /lessons/scheduled?child_id= — list upcoming plan items
  - POST /plans — create goal; PATCH /plans/:id — adjust; POST /lessons/scheduled — add manual item (optional)
- AuthZ: same child membership checks; tenant isolation by child.
- Scheduling UI for adults; child sees a simplified "what’s next" queue.

## Post‑MVP: Assessments & Task Sets

- Introduce generic grouping for timed exams, mini quizzes, and multi‑step sequences using templates → instances.
- Entities:
  - Templates: `task_set_templates`, `task_templates`, and `task_item_templates` (ordered, optional per‑item time limit, points, dependencies, propagation)
  - Instances: `task_set_instances` and `task_item_instances` (child‑specific realisations)
- Attempts include optional `task_set_instance_id` and `task_item_instance_id` to record context.
- UI/UX:
  - Exams: timed collections with pass thresholds.
  - Quizzes: short, untimed or lightly timed checks.
  - Sequences: ordered tasks where intermediate answers can feed the next step, guiding learners to a final solution.

## API outline (MVP scope for templates/instances)

- Upload → Template
  - POST /assets/upload-url → presigned URL (R2)
  - POST /assets/notify → metadata + enqueue OCR/extract → create Task Template
- Personalise → Instances
  - POST /lesson-instances — from lesson_template_id for child (stores personalisation params)
  - POST /task-instances — from task_template_id for child/session (role, links to example instance if applicable)
- Attempts
  - POST /attempts — always references `task_instance_id`; may include `task_set_instance_id`/`task_set_instance_item_id` when in a set context
