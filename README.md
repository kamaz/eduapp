# EduApp Monorepo

This is a Turborepo + pnpm monorepo for EduApp.

## Structure

- apps/mobile — Expo app (child + parent)
- apps/worker — Cloudflare Worker API and AI orchestration
- packages/* — shared types, utils, schema, ui, config

## Requirements

- Node 22+
- pnpm 10+

## Commands

- `pnpm dev` — run all dev servers (parallel)
- `pnpm dev:mobile` — mobile app via Expo
- `pnpm dev:worker` — worker via Wrangler
- `pnpm build` — build all packages/apps

## Notes

- Follow AGENTS.md for data rules, security, and testing.
- Avoid PII in logs/prompts; validate inputs; enforce auth on API routes.

## Migration note (LangChain consolidation)

- The standalone LangChain service has been removed from the architecture. Generation now runs inside the Worker with Durable Objects orchestration.
- Callback route renamed to `POST /jobs/callback/generation` (HMAC-signed). If you previously targeted `/jobs/callback/langchain`, update your clients/webhooks.
