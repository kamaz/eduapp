Schema package

Purpose

- Canonical D1 SQL migrations for core entities (users, children, curriculum, tasks, attempts, progress, lessons, assets, jobs, subscriptions, idempotency, sharing).
- TypeScript row types for strict typing across Workers and DOs.

Files

- sql/0001_init.sql — initial D1 schema per PRD rules.
- sql/0002_partition_do.sql — D1↔DO partitioning: move heavy payloads to Assets and add sharing tables.
- src/types.ts — TypeScript row types (PascalCase), epoch ms timestamps.
- src/index.ts — exports ApiResponse helper and types.

Notes

- IDs are TEXT (ULID/UUID). Timestamps are epoch ms (INTEGER).
- Foreign keys are enforced; deletes cascade where appropriate.
- No PII beyond minimal: child alias, optional DOB; avoid storing sensitive data in logs/prompts.
- Durable Objects (DO) hold live session state and attempt buffers; D1 stores queryable metadata only.
- Heavy payloads (strokes, answers, prompts/definitions, job IO) are stored as R2-backed `assets`, referenced from D1 by ID.
- Idempotency keys and indexes support rate-limited endpoints and flush semantics.

Usage

- Apply migrations via Wrangler D1 migrations referencing sql/\*.sql.
- Import types from @eduapp/schema for compile-time safety.

Partitioning summary

- Tasks: add `definition_asset_id` to point at full task definition (JSON/PDF) in R2.
- Attempts: add `answer_asset_id`, `strokes_asset_id`, and a small `summary_json` for querying; avoid large `outcome_json`.
- Jobs: add `input_asset_id`, `output_asset_id`, `error_asset_id`; keep JSON columns as small meta only.
- Sharing: add `child_access` (active memberships) and `access_requests` (invitations/approvals) to enable multi-person live interactions.
