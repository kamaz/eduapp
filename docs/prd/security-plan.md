# 🔐 Security Plan — Education App (MVP) — Draft v1

## Security goals (high level)

- Protect children’s personal data and parental account data.
- Ensure confidentiality, integrity, and availability of learning data and assets.
- Provide parental control & explicit consent for any data collection.
- Secure AI/third-party integrations and payment flows.
- Maintain auditability and rapid incident handling.

### Threat model (top risks)

- Unauthorized access to child profiles, attempts, or PII (data breach).
- Account takeover (parent account compromised).
- Unauthorized manipulation of progress/attempt records (fraud).
- Exfiltration of scanned worksheets, stroke data, or generated assets.
- Abuse of AI endpoints causing data leakage of other children’s data.
- Malicious client input (image payloads, prompt injection).
- Denial of Service or resource exhaustion (LLM cost spikes).
- Regulatory non-compliance (COPPA, GDPR-K).
- Third-party risk (Stripe, Firebase, LLM provider, Vectorize).

### Authentication & Access Control

Design

- Auth provider: Firebase Auth (client). Worker validates Firebase ID tokens on every request.
- Role model: parent, child (no direct auth), tutor/teacher (later), admin.
- Mapping: D1 stores firebase_uid → user_id mapping. All D1 reads/writes filter by parent_user_id.

Controls

- Token validation: Workers validate JWT signatures & exp; reject tokens with missing claims.
- Least privilege: APIs enforce authorization (owner-only access to children). No cross-tenant reads.
- Short-lived session tokens for DO WebSocket sessions issued by Worker (signed, TTL).
- Admin access: MFA required for admin accounts; admin actions audited.
- Password rules / MFA: Encourage/require strong passwords; support MFA for parents (recommendation).

### Network & Transport Security

- TLS everywhere: HTTPS/TLS enforced for all client ↔ Worker and Worker ↔ LangChain/third-party communications.
- Hardened endpoints: Rate limits, API keys, and request validation on all endpoints.
- Private secrets: All service keys kept in CI secrets and Cloudflare KV where appropriate; never checked into repo.
- Service-to-service auth: HMAC-signed callbacks (LangChain → Worker), mutual TLS or API keys for internal calls.

### Data protection (storage & processing)

At-rest

- R2: object storage encrypted at rest by Cloudflare. Use signed URLs with short TTL for access to assets.
- D1: uses Cloudflare encryption. Minimise PII stored; store alias instead of full names where feasible.
- Vectorize: treat as sensitive — only store curriculum/embedding metadata; avoid storing direct child-identifying text in vector payloads.
- DO state: DO holds ephemeral sensitive data; flush to D1/R2 quickly; ensure DO persisted state inherits Cloudflare protections.

In transit

- TLS for all endpoints; validate certs for external APIs.

Sensitive fields & minimisation

- Store minimal PII (alias, DOB optional). Keep email only in users.
- Wearable/health data stored only with explicit parental consent; flag in D1 preferences_json.
- For audits, avoid logging raw images or stroke blobs; log references/IDs only.

### Durable Objects & Live Data Controls

- Auth handshake: Worker issues signed session token (short TTL) for DO WebSocket join; DO rejects unsigned sessions.
- Session isolation: DO instances keyed by child:<child_id> to isolate per-child state.
- Buffer limits: cap strokeBuffer and attemptBuffer size to prevent memory exhaustion. If buffer near capacity, persist chunk to R2 and continue.
- Flush integrity: attempts flushed to D1 must be idempotent (use client-generated attempt_client_id) to avoid duplication on retries.
- Audit sync: DO should log flush events to jobs table in D1 (or to R2) for traceability.

### API & Input Validation

- Strict schema validation for all endpoints (e.g., JSON Schema / Zod) to prevent injection attacks.
- Image handling: validate image MIME types and size limits; process images in trusted worker environment; scan for malware if necessary.
- Prompt safety: sanitize any user-provided text before sending to LLM. Separate child-specific data and avoid placing other children’s PII in prompts.
- Rate limiting: per-user and global quotas on generation requests to prevent LLM abuse and cost spikes.

### AI & LLM-specific controls

- No PII in prompts: scrub or tokenise direct identifiers before sending to LLMs; use child_alias only and avoid explicit PII.
- Prompt injection defense: apply guardrails and structured prompt templates; isolate user content into data fields, not raw prompt concatenation.
- Logging & retention: log model usage metadata (model, tokens, cost) but never store full prompts with sensitive PII in logs. Store prompt hashes for audit.
- Content filtering: run LLM outputs through a simple filter to catch unsafe suggestions (e.g., medical/legal advice) and replace with safe guidance or “ask a professional”.
- Quota controls: implement spending caps and alerting for LLM usage.

### Payment & Billing security

- Stripe for subscriptions: redirect/host checkout pages when possible (Stripe Checkout) to minimise PCI scope.
- Webhook validation: validate Stripe webhooks (signing secret) and reconcile against D1 records.
- Minimal storage: do not store card details; store only stripe_customer_id and subscription_id.

### Logging, monitoring & auditability

- Audit logs: write jobs and key admin events to D1; store security-relevant events in an append-only log with timestamps (or use external log service).
- Error monitoring: Sentry for server and client; Cloudflare Analytics for edge metrics.
- Alerting: alerts for failed DO flush rates, repeated auth failures, high LLM spend, or R2 failures.
- Retention: keep security logs for at least 90 days; longer if required by policy.

### Backups & disaster recovery

- D1 backups: daily export snapshots to R2 (SQL dump or JSON). Keep rolling 30 days (initially).
- R2 assets: periodic replication policy / maintain index in D1 to correlate assets. For critical assets, keep checksum metadata.
- Vectorize: maintain backups of original text + embedding metadata in R2/D1 to allow reindexing.
- Recovery drills: schedule quarterly restore tests for D1 + R2 to validate backup integrity.

### Privacy, consent & regulatory

- Parental consent: required during onboarding; store consent record (timestamp, scope) in D1 children.preferences_json.
- COPPA: treat children under 13 as minors — require parental approval for account, prevent direct child signup, limit third-party data sharing.
- GDPR: fulfil rights — data access, export, correction, deletion. Provide automated export endpoint for parents. Log deletion actions.
- Data minimisation: default opt-out for telemetry/wearable data; explicit opt-in for sensitive telemetry.
- Data retention policy: archive after 12 months inactivity; deletion on request within legal SLA (e.g., 30 days).

### Third-party risk management

- Vendor list: Firebase (Auth), Cloudflare (Workers, D1, R2, Vectorize), LangChain + LLM provider (OpenAI), Stripe, Postmark/Resend, Google Vision (OCR) or Tesseract fallback.
- Controls: maintain vendor inventory, SLAs, data processing agreements (DPA), and ensure LLM provider DPA covers use of child-related data (if using for embeddings or prompts).
- Minimum data sharing: send minimal, non-identifiable data to vendors when possible.

### Secure development & QA practices

- Code reviews: mandatory pull requests + PR reviews for server code. Security owner sign-off for changes touching auth/data flows.
- Static analysis: run linters and SAST where possible (e.g., ESLint + TypeScript strict modes).
- Dependency monitoring: automated scanning for vulnerabilities (Dependabot/GitHub).
- Secrets management: no secrets in source; rely on CI secret store & Cloudflare KV.
- Pen testing: schedule pen-test prior to wider pilot; include client & server surface.

### Incident response & playbook (summary)

    1.	Detection / Triage: alert from monitoring (Sentry / Cloudflare) triggers on-call.
    2.	Containment: revoke API keys / rotate affected tokens; scale DO throttle; disable LLM calls if cost spike.
    3.	Eradication & Recovery: patch vulnerability; restore from backups if needed; replay critical jobs.
    4.	Notification: notify affected parents per policy and regulatory requirements (72-hour GDPR window for breaches).
    5.	Post-incident: root cause analysis, update controls, update runbooks.

Create a short incident response doc with contacts, escalation, and template notification messages.

### Privacy & Security documentation to produce (recommended)

- Data Protection Impact Assessment (DPIA) for COPPA/GDPR.
- Parental consent & privacy policy pages (clear UX copy).
- Incident Response Playbook (contact list, triage steps).
- Vendor DPA and security checklist.
- Access Control policy (who can access production D1/R2/Vectorize/Cloudflare console).
- Developer Security Handbook (secrets, PR rules, QA).

### Initial security checklist (practical tasks)

- Enforce HTTPS and strict TLS for all endpoints.
- Implement Firebase token validation in Workers.
- Issue signed short-lived DO session tokens via Worker.
- Enforce input schema validation on all endpoints.
- Cap DO buffers & implement flush-to-D1 logic with idempotency keys.
- Configure Cloudflare KV/Secrets & remove any local dev secrets.
- Implement presigned R2 upload with content type/size limits.
- Setup Stripe Checkout + webhook validation.
- Setup Sentry + Cloudflare Analytics + alerting for high-cost LLM usage.
- Implement parental consent capture & storage during onboarding.
- Create DPA with LLM provider & email provider (if required).
- Plan pen-test at end of MVP dev cycle.

### Quick templates & examples (to hand to engineers)

- HMAC callback verification: LangChain → Worker callbacks must include X-Signature header (HMAC-SHA256 of payload using shared secret). Worker verifies before processing.
- Idempotency header: clients include X-Idempotency-Key for attempt submissions; Worker/D1 enforces uniqueness.
- Session token: Worker returns do_session_token = HMAC(user_id|child_id|exp) for DO join; DO verifies signature and expiry.
