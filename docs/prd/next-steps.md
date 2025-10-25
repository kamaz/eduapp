# Next Steps (MVP)

1. Define DO interface (messages, flush policy, idempotency keys)
2. D1 schema (users, children, child_access [with is_primary_parent], access_requests, child_profile, child_profile_items, child_observations, consent_records, curriculum, tasks, attempts, progress, scheduled_lessons, assets, jobs, subscriptions)
3. R2 presigned upload and OCR stub wiring
4. Generation job contract in Worker; store outputs in R2; metadata in D1; HMAC callback `/jobs/callback/generation`
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
