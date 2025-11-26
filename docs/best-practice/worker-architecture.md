# Worker Application Guidelines

The worker is a monolith today. Organise it by domain to keep endpoints, services, and shared code predictable as it grows.

## Domains

- Each domain gets its own folder: `src/<domain>/`.
- Inside a domain:
  - `endpoint/`: HTTP contracts and handlers.
    - `model.ts`: Zod schemas for the endpoint request/response. Export inferred types; avoid hand-written types.
    - `<endpoint>.ts`: the handler (`endpoint`) that uses the schemas and assumes middleware (auth/log) already ran.
  - `service/`: business logic and data access.
    - `model.ts`: Zod schemas for service params/results; export inferred `Params`/`Result` types.
    - `<service>.ts`: implementation; import env directly and fail fast when missing. Avoid technology names in service names (e.g., `createRegistrationService` instead of `createSupabaseRegistrationService`).
  - `index.ts` (optional): barrel to re-export domain pieces.

Example (current `user` domain):

- `src/user/endpoint/model.ts`: Zod schemas for registration request/response.
- `src/user/endpoint/register.ts`: `endpoint` that validates the payload, reads `identity` from middleware, and calls the service.
- `src/user/service/model.ts`: Zod schemas for `RegistrationParams`/`RegistrationResult`.
- `src/user/service/register.ts`: registration service that talks to Supabase via a client and validates inputs/outputs with the service schemas.

## Endpoints

- Use Zod schemas for `{Name}Request`/`{Name}Response` in `endpoint/model.ts`.
- Export a single `endpoint` function per route file; register routes in `src/index.ts`. No per-endpoint `app.use` blocks.
- Trust upstream middleware to attach identity/loggers; don’t decode auth inside the endpoint.

## Services

- Schema-first: `Params`/`Result` come from Zod in `service/model.ts`.
- Implementations live in `service/<name>.ts`; create them directly (no factory options or injected `now`).
- Avoid embedding vendor names in service names/factories; keep names domain-driven.

## Middleware

- Lives in `src/middleware/`. Handles cross-cutting concerns (auth, logging, tracing).
- Registered once in `src/index.ts` so all routes share the same pipeline.
- Middleware should enrich context (e.g., set identity, logger) for endpoints to consume. Current examples: `firebase-auth` sets `identity`; `log` attaches a pino logger.

## Libs

- `src/lib/` is for shared helpers/utilities (logging setup, feature flags, pure helpers).
- Keep `lib` code side-effect free where possible and avoid domain leakage; domain-specific logic stays in the domain’s service layer.
