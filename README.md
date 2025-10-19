# EduApp Monorepo

This is a Turborepo + pnpm monorepo for EduApp.

## Structure

- apps/mobile — Expo app (child + parent)
- apps/worker — Cloudflare Worker API and AI orchestration
- packages/\* — shared types, utils, schema, ui, config
- devtools/\* — local developer tools (e.g., Firebase Emulator)

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

- Follow AGENTS.md for data rules, security, and testing.
- Avoid PII in logs/prompts; validate inputs; enforce auth on API routes.
- Module system: ESM-only across the repo. Prefer `.mjs` for config files at the root.
- Git hooks: Pre-commit runs staged ESLint/Prettier (lint-staged) and then `pnpm check` for full validation. Install hooks with `pnpm install` (runs `prepare`). To bypass in emergencies, use `--no-verify` (not recommended).

## Devtools: Firebase Auth Emulator

- Location: `devtools/firebase-emulator`
- Start: `pnpm -w dev:emulators` (or `pnpm --filter @eduapp/firebase-emulator dev`)
- UI: `http://127.0.0.1:4000`
- Seed demo users: `pnpm --filter @eduapp/firebase-emulator seed`
- Worker validation: ensure `FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099` when validating tokens in dev.

## Migration note (LangChain consolidation)

- The standalone LangChain service has been removed from the architecture. Generation now runs inside the Worker with Durable Objects orchestration.
- Callback route renamed to `POST /jobs/callback/generation` (HMAC-signed). If you previously targeted `/jobs/callback/langchain`, update your clients/webhooks.
