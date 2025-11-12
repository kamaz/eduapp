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
