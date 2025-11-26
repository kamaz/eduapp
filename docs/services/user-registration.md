# User Registration Service

## High-level overview

- Purpose: create or hydrate a parent (or tutor/teacher) user record after Firebase sign-up and bind it to tenant context before any child onboarding begins.
- Entry points: mobile app (parent-led) calls Worker API `POST /register` with Firebase ID token; all requests carry idempotency keys and are rate limited.
- Identity & authz: verify Firebase ID token on every call; map `firebase_uid` to `users.id`; ensure email is trusted only from the token; enforce tenant isolation on all later reads/writes.
- Data stores: Supabase Postgres (interim) for canonical user row and consents (`users`, `user_consents`, `consent_policies`, optional `access_requests` hydration) with RLS scoped to user; no DO involvement; no R2 usage. Keep schema aligned to D1 for later migration.
- Consents & privacy: require current consent policy group/version; store receipt in `user_consents`; never log PII (no emails/names in logs).
- Idempotency & resilience: deduplicate on `idempotency_key` + `firebase_uid`; upsert user if called again; structured, sanitized errors.

## Sequence: parent registers

```mermaid
sequenceDiagram
    participant ParentMobile as Mobile app (Parent)
    participant Firebase as Firebase Auth
    participant Worker as Worker API (Cloudflare)
    participant Supabase as Supabase Postgres (interim)

    ParentMobile->>Firebase: Email/password or SSO sign-up
    Firebase-->>ParentMobile: ID token
    ParentMobile->>Worker: POST /register (idempotency key, consent version, profile fields like locale/display name)
    Worker->>Firebase: Verify ID token
    Firebase-->>Worker: Token claims (firebase_uid, email, email_verified)
    Worker->>Supabase: Upsert user (firebase_uid, email, locale, timestamps) using service key; RLS ensures tenant isolation on reads
    Worker->>Supabase: Insert user_consents (policy group/version, source=registration) if not present
    opt Pending invites
        Worker->>Supabase: Resolve any `access_requests` targeting this email and attach to user
    end
    Worker-->>ParentMobile: 201 Created or 200 OK (user_id, consent receipt, tenant context)
```

### Post-conditions

- User exists in Supabase Postgres tied to Firebase identity; consent recorded for current policy version.
- Any pending invites or access requests keyed by email are connected to the new user.
- Subsequent calls are idempotent (no duplicate users), RLS-protected, and ready for child onboarding and primary-parent flow.
