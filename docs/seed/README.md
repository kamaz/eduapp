# Seed Data

Test data for curriculum content and demo families. Seeds target our schema in `docs/schema`.

Contents

- `sqllite/subscriptions.sql` — Subscription plans (SQLite/D1)
- `sqllite/consents.sql` — Consent policies and assets (SQLite/D1)
- `sqllite/families.sql` — Four demo families with users, children, access, subscriptions, and user consents (SQLite/D1)
- `sqllite/english-year-1.sql` — Year 1 English (SQLite/D1)
- `sqllite/english-year-5.sql` — Year 5 English (SQLite/D1)
- `plsql/subscriptions.sql` — Subscription plans (PostgreSQL)
- `plsql/consents.sql` — Consent policies and assets (PostgreSQL)
- `plsql/families.sql` — Four demo families with users, children, access, subscriptions, and user consents (PostgreSQL)
- `plsql/english-year-1.sql` — Year 1 English (PostgreSQL)
- `plsql/english-year-5.sql` — Year 5 English (PostgreSQL)

How to apply

- SQLite/D1 (dev):
  - `sqlite3 app.db < docs/schema/sqllite/schema.sql`
  - `sqlite3 app.db < docs/seed/sqllite/subscriptions.sql`
  - `sqlite3 app.db < docs/seed/sqllite/consents.sql`
  - `sqlite3 app.db < docs/seed/sqllite/families.sql`
  - `sqlite3 app.db < docs/seed/sqllite/english-year-1.sql`
  - `sqlite3 app.db < docs/seed/sqllite/english-year-5.sql`
  - D1 example: `wrangler d1 execute <DB_NAME> --local --file=docs/seed/sqllite/families.sql`

- PostgreSQL (Supabase devtool):
  - Start: `pnpm --filter @eduapp/supabase-emulator dev`
  - Import schema: `pnpm --filter @eduapp/supabase-emulator db:import`
  - Seed plans: `psql 'postgresql://postgres:postgres@127.0.0.1:54322/postgres' -f docs/seed/plsql/subscriptions.sql`
  - Seed consent policies: `psql 'postgresql://postgres:postgres@127.0.0.1:54322/postgres' -f docs/seed/plsql/consents.sql`
  - Seed families: `psql 'postgresql://postgres:postgres@127.0.0.1:54322/postgres' -f docs/seed/plsql/families.sql`
  - Seed Year 1: `psql 'postgresql://postgres:postgres@127.0.0.1:54322/postgres' -f docs/seed/plsql/english-year-1.sql`
  - Seed Year 5: `psql 'postgresql://postgres:postgres@127.0.0.1:54322/postgres' -f docs/seed/plsql/english-year-5.sql`

Notes

- IDs are stable, human‑readable, lowercase snake*case (e.g., `usr_fam_a_parent`, `ch_fam_d_c3`). Split multi-part tokens with `*`(e.g.,`famA`→`fam_a`).
- Families include:
  - Family A: single parent + 1 child on paid plan (`plan_basic_monthly`).
  - Family B: two parents + 2 children on free plan (`plan_free`).
  - Family C: two parents + two grandparents + 1 child on paid family plan (`plan_family_monthly`).
  - Family D: two parents + 3 children on free plan (`plan_free`).
- Consents follow the model: versioned `consent_policies` and per‑user `user_consents`; no consent flags on `children`.

Personalised lesson/set/task seeds

- Do not “personalise” by prefixing titles with a child name (e.g., `Bella — …`). Titles should remain template‑style; personalisation lives in content and config.
- When seeding instances for a known child (e.g., Bella in Family B), derive context from `child_profile` / `child_profile_items`:
  - Copy `learning_style` and key interest tags into `lesson_instances.personalization_params_json`.
  - Reflect sensitivities (e.g., `bright_screens_evening`) in notes or delivery hints, not in PII‑like text.
- For `lesson_instances`:
  - Use neutral titles drawn from the lesson template or curriculum (no names).
  - Set `personalization_params_json` to include at least: `profile_source`, `learning_style`, `interests` (array), and a short `notes` string explaining how the lesson should adapt.
- For `task_set_instances`:
  - Keep `title` generic but descriptive of the skill (e.g., “Direct and reported speech — read‑aloud practice set”).
  - Use `description` to explain how the set is tuned to the child profile (e.g., read‑aloud first, short items, chances to act out characters).
  - Provide a sensible `time_limit_ms` for the whole set where appropriate (e.g., 15–20 minutes for a worksheet‑like set).
- For `task_instances`:
  - Treat them as task‑level wrappers: reuse template titles, roles, and styles; do not embed child names.
  - Keep answers and question structure on `task_item_templates` / `task_item_instances`; `task_instances` only link to assets and optional explanation (`solution_asset_id`).
- For `task_item_instances`:
  - Always populate `question_json`, `config_json`, and `answer_json` in seeds that are meant to demonstrate end‑to‑end flows.
  - Use `question_json` to specialise the prompt for the child’s profile (e.g., “Read this sentence aloud with expression, then rewrite it…” plus a `personalisation` block with `learning_style` and key `interests`).
  - Use `config_json` to capture behaviour such as `mode` (guided/independent), `delivery` (read_aloud_first/read_aloud_then_write), timeouts, and `max_attempts`.
  - Set `item_time_limit_ms` where meaningful so that timing behaviour can be exercised in tests/dev flows.
  - Keep `answer_json` to the canonical expected answer; do not leak PII or free‑form commentary here.
