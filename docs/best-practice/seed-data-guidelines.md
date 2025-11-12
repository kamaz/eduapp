# Seed Data Guidelines

Conventions for seed identifiers and demo data to keep things consistent and testable.

- Identifiers: use lowercase snake_case for all IDs/keys in seeds.
  - Prefer `usr_fam_a_parent` over `usr_famA_parent`.
  - Prefer `fb_fam_b_p1` over `fb_famB_p1`.
- Foreign keys: prefix with origin for clarity.
  - Use `policy_id` (user_consents → consent_policies.id).
  - Table name mirrors origin when scoping to user: `user_consents`, `user_subscriptions`.
- Children data:
  - Do not store `primary_parent_user_id` on `children`; relationships live in `child_access`.
  - Store date of birth as a single epoch‑ms field `dob` (UTC midnight), not split into year/month/day.
  - Always include `nickname`, `email` (internal routing), and `avatar_asset_id` in demo seeds.
- Stability: keep IDs stable across iterations so tests and verification scripts remain valid.
- Privacy: avoid PII; use pseudonymous names and emails that do not correspond to real users.
- Scope: demo family subscriptions attach to the primary parent; consents are per-user for ToS and Privacy v2.
- Order of import (PostgreSQL): schema → curriculum → subscription plans → consent policies → demo families.

Access levels

- `child_access.access_level` must be one of: `parent`, `teacher`, `tutor`, `family`.
- Do not use `owner` or `member` — ownership is not a concept here.
- Mapping guidance:
  - If `persona_role` = `parent`, use `access_level` = `parent`.
  - If `persona_role` = `grandparent` or other family relation, use `access_level` = `family`.
  - Teachers and tutors map 1:1 to `teacher` and `tutor`.

Apply order

- Use Supabase devtools to reset/import:
  - `pnpm --filter @eduapp/supabase-emulator db:reset`
