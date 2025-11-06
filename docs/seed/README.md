# Seed Data

Test data derived from the UK National Curriculum (English) for Year 1 (KS1) and Year 5 (KS2). Seeds target our schema in `docs/schema`.

Contents

- `sqllite/english-year-1.sql` — SQLite/D1 inserts for Year 1 English
- `sqllite/english-year-5.sql` — SQLite/D1 inserts for Year 5 English
- `plsql/english-year-1.sql` — PostgreSQL inserts for Year 1 English
- `plsql/english-year-5.sql` — PostgreSQL inserts for Year 5 English

How to apply

- SQLite/D1 (dev):
  - `sqlite3 app.db < docs/schema/sqllite/schema.sql`
  - `sqlite3 app.db < docs/seed/sqllite/english-year-1.sql`
  - `sqlite3 app.db < docs/seed/sqllite/english-year-5.sql`
  - D1 example: `wrangler d1 execute <DB_NAME> --local --file=docs/seed/sqllite/english-year-1.sql`

- PostgreSQL (Supabase devtool):
  - Start: `pnpm --filter @eduapp/supabase-emulator dev`
  - Import schema: `pnpm --filter @eduapp/supabase-emulator db:import`
  - Seed Year 1: `psql 'postgresql://postgres:postgres@127.0.0.1:54322/postgres' -f docs/seed/plsql/english-year-1.sql`
  - Seed Year 5: `psql 'postgresql://postgres:postgres@127.0.0.1:54322/postgres' -f docs/seed/plsql/english-year-5.sql`

Notes

- IDs are stable, human‑readable strings (e.g., `sub_english_uk`, `topic_eng_y1_r_wr`).
- Grade bands: KS1 for Year 1; KS2 for Year 5. Recommended ages reflect Y1 ≈ 5–7, Y5 ≈ 9–11.
- Topics reflect programme strands (reading word/comprehension, writing transcription/composition, and VGP) based on: `docs/national-curriculum/uk/current/english/PRIMARY_national_curriculum_-_English_220714.pdf`.
