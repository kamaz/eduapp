# SQL Standards

These conventions keep our SQLite/D1 and PostgreSQL schemas consistent, portable, and easy to reason about.

## Identifiers

- Case: lower_snake_case for all identifiers (schemas, tables, columns, indexes, constraints, views, functions).
- Quoting: avoid quoted identifiers; rely on lowercase unquoted names.
- Reserved words: do not use SQL reserved keywords as identifiers.

## Tables

- Naming: plural nouns (users, children, assets, curriculum_topics).
- Joins/associations:
  - Semantic association: domain-specific name (child_access, task_set_template_items).
  - Generic many-to-many: <left>\_<right> in alphabetical order (only if truly generic).
- Append-only/event tables: suffix with `_events` (progress_events).
- Historical snapshots (if needed): suffix with `_history`.

## Columns

- Primary key: `id` (TEXT ULID/UUID) on every table.
- Foreign keys: `<referenced_table_singular>_id` (user_id, child_id, topic_id).
- Asset references: Always name the FK column `asset_id` when referencing `assets` (consistent across tables like lesson_templates, task_templates, task_set_template_items, consent_policies).
- Booleans: `is_<predicate>`; INTEGER 0/1 in SQLite; BOOLEAN in Postgres.
- Timestamps: `created_at`, `updated_at` epoch ms (INTEGER in SQLite, BIGINT in Postgres); soft-delete `deleted_at` where needed.
- JSON: `<name>_json` (TEXT in SQLite; JSONB in Postgres).
- Enums/status: `status` TEXT, optionally guarded by CHECK constraints; avoid engine-specific enums in base schema.

## Keys, Indexes, Constraints

- Unique constraints: `ux_<table>_<col1>[_<col2>...]`.
- Non-unique indexes: `idx_<table>_<col1>[_<col2>...]`.
- Foreign keys: `fk_<table>_<col>__<ref_table>` (optional naming; implicit FKs acceptable in migrations).
- Checks: `ck_<table>_<shortname>`.
- Partial/filtered indexes:
  - PostgreSQL: allowed and encouraged where appropriate (e.g., nullable idempotency keys).
  - SQLite/D1: supported for simple predicates; confirm D1 runtime support; otherwise enforce in app logic.

## Relationships & Deletes

- Always enforce FK constraints.
- On delete:
  - Child-owned rows: `ON DELETE CASCADE` (progress, attempts, profile_items).
  - Optional references: `ON DELETE SET NULL` (created_by_user_id, optional lesson_template_id).
  - Primary relationships that must not be orphaned: `ON DELETE RESTRICT`.

## Date/Time Strategy (epoch ms)

- Store UTC epoch milliseconds in integer columns for all timestamps (`*_at`).
  - Type: INTEGER in SQLite/D1; BIGINT in Postgres.
  - Rationale:
    - Cross‑engine portability (SQLite lacks a native timestamptz type).
    - Natural interop with JS/TypeScript (`Date.now()` emits ms).
    - Timezone‑neutral storage; simple numeric indexing and ordering.
- Conversions (convenience):
  - Postgres: `to_timestamp(created_at/1000.0)` → `timestamptz` in queries.
  - SQLite: `datetime(created_at/1000, 'unixepoch')` → ISO text.
- Seeding (avoid overflow):
  - Postgres: use interval math, then convert, e.g. `(EXTRACT(EPOCH FROM NOW() - INTERVAL '1 day')*1000)::bigint`.
  - Avoid subtracting large integer literals like `EXTRACT(EPOCH)*1000 - 86400000*60` (can overflow 32‑bit ints).
  - SQLite: `strftime('%s','now')*1000` or `strftime('%s','now','-1 day')*1000`.

## Views & Materialized Views

- Views: `v_<domain>_<name>` (v_progress_overview). Keep column names aligned with base tables.
- Materialized views (Postgres only): `mv_<domain>_<name>`. Document refresh policy.

## Functions / Procedures (Postgres)

- Prefer app-layer logic. Keep SQL functions minimal and side-effect free.
- Functions: `fn_<domain>_<name>()`; Procedures: `sp_<domain>_<name>()`.
- Avoid features not available in SQLite/D1 in baseline schema scripts.

## IDs & Data Types

- IDs: TEXT ULID (preferred) or UUID as TEXT across both engines.
- Timestamps: epoch ms INTEGER/BIGINT.
- JSON: TEXT (SQLite) / JSONB (Postgres).
- Numerics: INTEGER/REAL (SQLite) / INTEGER/DOUBLE PRECISION (Postgres).

## Migrations

- Files: `0001_init.sql`, `0002_<feature>.sql` (monotonic).
- Forward-only by default (fits D1). Keep SQLite and Postgres schemas semantically aligned; put Postgres-only enhancements in `docs/schema/plsql`.

## Tenancy & Isolation

- Tenant boundary enforced by `child_id` and parent membership (child_access). All multi-tenant queries must filter by authorized child scope.

## Examples (in repo)

- Tables: users, children, child_access, access_requests, curriculum_subjects, curriculum_topics, lesson_templates, lesson_instances, task_templates, task_instances, task_set_templates, task_set_template_items, attempts, progress, progress_events, assets, jobs, job_steps, generation_requests, user_subscriptions.
- Indexes: idx_children_primary_parent, idx_attempts_child, ux_gen_req_idem, ux_jobs_idem.

## Style & Formatting

- Uppercase SQL keywords; one column per line; consistent ON DELETE.

## String Literals & Escaping

- General
  - Always use single quotes for SQL string literals.
  - Do not rely on backslash escapes; prefer engine‑standard quoting.

- Apostrophes / single quotes inside strings
  - PostgreSQL: escape a single quote by doubling it: `Don''t forget your book.`
  - SQLite/D1: same rule applies; double the single quote: `Don''t forget your book.`

- JSON strings inside SQL
  - When embedding JSON in SQL, keep JSON double quotes and escape only the SQL layer (single quotes) by doubling as above.
    - Example (Postgres): `'{"focus":"modal_verbs","sentences":6}'` is valid; the JSON quotes remain `"…"` while the SQL literal is wrapped in `'…'`.
  - PostgreSQL only: for large/complex JSON, prefer dollar‑quoted strings to avoid heavy escaping:
    - `config_json = $$ { "focus": "modal_verbs", "sentences": 6 } $$`
  - SQLite/D1: dollar‑quoting is not supported; continue to wrap in single quotes and double embedded single quotes as needed.

- Practical tips for seeds/migrations
  - For sentences with quotes (e.g., direct speech), double any single quotes: `'\'No'' scribble today\''` is wrong; use `'''No scribble today'''` carefully or rephrase with JSON wrapped in single quotes.
  - Prefer storing longer free‑text in dedicated TEXT columns (e.g., `overview_text`) instead of asset indirection when the data is structured.
  - Consider loading very large text from external files via CLI tooling (psql `\copy`, SQLite `.read`) when readability suffers.

## ID Prefixes

Use short, unambiguous prefixes with ULIDs/UUIDs for readability and debugging (generated in the application layer).

| Table                     | ID Prefix | Example        |
| ------------------------- | --------- | -------------- |
| users                     | usr\_     | usr_01HABC...  |
| children                  | ch\_      | ch_01HABC...   |
| assets                    | ast\_     | ast_01HABC...  |
| child_access              | cacc\_    | cacc_01HABC... |
| access_requests           | areq\_    | areq_01HABC... |
| consent_policies          | cpol\_    | cpol_01HABC... |
| user_consents             | ucon\_    | ucon_01HABC... |
| child_profile             | cpro\_    | cpro_01HABC... |
| child_profile_items       | cpri\_    | cpri_01HABC... |
| child_observations        | cob\_     | cob_01HABC...  |
| user_subscriptions        | subs\_    | subs_01HABC... |
| curriculum_subjects       | csub\_    | csub_01HABC... |
| curriculum_topics         | ctop\_    | ctop_01HABC... |
| curriculum_prereqs        | cprq\_    | cprq_01HABC... |
| lesson_templates          | lt\_      | lt_01HABC...   |
| lesson_instances          | li\_      | li_01HABC...   |
| task_templates            | tt\_      | tt_01HABC...   |
| task_instances            | ti\_      | ti_01HABC...   |
| task_set_templates        | tst\_     | tst_01HABC...  |
| task_set_template_items   | tsti\_    | tsti_01HABC... |
| task_set_instances        | tsi\_     | tsi_01HABC...  |
| task_set_instance_items   | tsii\_    | tsii_01HABC... |
| task_set_template_lessons | tstl\_    | tstl_01HABC... |
| task_set_instance_lessons | tsil\_    | tsil_01HABC... |
| attempts                  | att\_     | att_01HABC...  |
| progress                  | prog\_    | prog_01HABC... |
| progress_events           | pe\_      | pe_01HABC...   |
| generation_requests       | grq\_     | grq_01HABC...  |
| jobs                      | job\_     | job_01HABC...  |
| job_steps                 | js\_      | js_01HABC...   |
