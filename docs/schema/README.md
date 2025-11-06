# Database Schemas

This folder contains generated database schemas aligned to the combined ERD (`docs/erd/erd.mmd`).

Structure

- `sqllite/schema.sql` — SQLite/D1-compatible schema (TEXT ids, INTEGER timestamps, JSON as TEXT, booleans as 0/1)
- `plsql/schema.sql` — PostgreSQL-compatible schema (TEXT ids, BIGINT timestamps, JSONB, BOOLEAN)

Usage

- SQLite (local):
  - `sqlite3 app.db < docs/schema/sqllite/schema.sql`
- Cloudflare D1 (development):
  - Convert this file into Wrangler D1 migrations or apply via `wrangler d1 execute`.
  - Example: `wrangler d1 execute <DB_NAME> --local --file=docs/schema/sqllite/schema.sql`

- PostgreSQL:
  - `psql -d yourdb -f docs/schema/plsql/schema.sql`

Notes

- The schema is generated from `docs/erd/erd.mmd` and adheres to PRD data rules:
  - Canonical relational data in D1
  - Assets referenced by id (R2)
  - No PII in logs/prompts; use child alias where possible
  - Cursor pagination and suggested indexes per PRD

Regeneration

- If the ERDs change, re-generate the combined ERD:
  - `pnpm erd:combine`
- Then update or re-export this schema file accordingly.

References

- SQL Standards: `docs/best-practice/sql-standards.md`
