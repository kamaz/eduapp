# EduApp Monorepo

This is a Turborepo + pnpm monorepo for EduApp.

## Structure

- apps/mobile — Expo app (child + parent)
- apps/worker — Cloudflare Worker API and AI orchestration
- packages/\* — shared types, utils, schema, config
- devtools/\* — local developer tools (e.g., Firebase Emulator)
- docs/schema — database schemas (SQLite/D1, PostgreSQL)

## Requirements

- Node 22+
- pnpm 10+
- ESM-only modules: use `export`/`import`. JS configs must be `.mjs` or live in packages with `"type": "module"`. Avoid CommonJS (`require`, `module.exports`).

## Commands

- `pnpm dev` — run all dev servers (parallel)
- `pnpm dev:mobile` — mobile app via Expo
- `pnpm dev:worker` — worker via Wrangler
- `pnpm dev:emulators` — start local dev emulators (Firebase Auth)
- `pnpm build` — build all packages/apps
- `pnpm check` — run format check, lint, and tests
- `pnpm check:fix` — run auto-fixes for format and lint
- `pnpm check:format` — Prettier check across the repo
- `pnpm check:format:fix` — Prettier write across the repo
- `pnpm check:lint` — ESLint across workspaces
- `pnpm check:lint:fix` — ESLint with auto-fix across workspaces
- `pnpm check:test` — run tests across workspaces
- `pnpm lint` — legacy alias used by Turbo tasks
- `pnpm lint:fix` — legacy alias used by Turbo tasks
- `pnpm clean` — remove all `node_modules` (workspace-wide), `dist` folders, and `.turbo` cache
- `pnpm erd:combine` — generate single ERD (`docs/erd/erd.mmd`) from domain ERDs

## Clean

- Command: `pnpm clean`
- Effect:
  - Recursively deletes all `node_modules` folders across the monorepo
  - Deletes all `dist` build output directories
  - Clears Turborepo cache directory `.turbo`
- When to use:
  - Resolving dependency/linking issues
  - Clearing build artifacts before a fresh install/build
- After running:
  - Reinstall dependencies with `pnpm install`
  - Optionally rebuild with `pnpm build`

## Notes

- Follow [AGENTS.md](AGENTS.md) for data rules, security, and testing.
- Mermaid ERDs: follow [Mermaid ERD Best Practices](docs/best-practice/mermaid-erd-guidelines.md) for syntax, PK/FK/UK markers, and quoting style. Domain ERDs live under `docs/erd/erd-*.mmd`; generate the combined ERD with `pnpm erd:combine`. SQLite/D1 schema lives at `docs/schema/sqllite/schema.sql`. PostgreSQL schema lives at `docs/schema/plsql/schema.sql`.
- Avoid PII in logs/prompts; validate inputs; enforce auth on API routes.
- Module system: ESM-only across the repo. Prefer `.mjs` for config files at the root.
- Git hooks: Pre-commit runs staged ESLint/Prettier (lint-staged) and then `pnpm check` for full validation. Install hooks with `pnpm install` (runs `prepare`). To bypass in emergencies, use `--no-verify` (not recommended).

## Devtools: Firebase Auth Emulator

- Location: `devtools/firebase-emulator`
- Start: `pnpm -w dev:emulators` (or `pnpm --filter @eduapp/firebase-emulator dev`)
- UI: `http://127.0.0.1:4000`
- Seed demo users: `pnpm --filter @eduapp/firebase-emulator seed`
- Worker validation: ensure `FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099` when validating tokens in dev.

## Devtools: Supabase (Local Postgres)

- Location: `devtools/supabase`
- Start: `pnpm --filter @eduapp/supabase-emulator dev`
- Import schema: `pnpm --filter @eduapp/supabase-emulator db:import`
- Reset schema: `pnpm --filter @eduapp/supabase-emulator db:reset` (drops `eduapp` schema)
- Stop: `pnpm --filter @eduapp/supabase-emulator stop`
- Status: `pnpm --filter @eduapp/supabase-emulator status`
- Default DB URL: `postgresql://postgres:postgres@127.0.0.1:54322/postgres`

## Sample Data

- Seeds derived from UK National Curriculum (English) for Year 1 and Year 5.
- Location: `docs/seed` (SQLite/D1 and PostgreSQL variants).
- Apply (SQLite example):
  - `sqlite3 app.db < docs/schema/sqllite/schema.sql`
  - `sqlite3 app.db < docs/seed/sqllite/english-year-1.sql`
- Apply (Postgres example):
  - `psql 'postgresql://postgres:postgres@127.0.0.1:54322/postgres' -f docs/seed/plsql/english-year-1.sql`

## Migration note (Generation consolidation)

- The standalone generation service has been removed. Generation now runs inside the Worker with Durable Objects orchestration.
- No external callbacks are required for generation; status is persisted in D1 (GENERATION_REQUESTS/JOBS/JOB_STEPS).
