# Supabase (Devtools)

Local Supabase stack (Postgres + services) for development. Use it to run a Postgres-compatible database locally, import our schema, and iterate quickly.

Defaults

- DB URL: `postgresql://postgres:postgres@127.0.0.1:54322/postgres`
- Requires: Docker, Supabase CLI (`npm i -g supabase`)

Commands

- `pnpm dev` or `pnpm start` — start Supabase local stack
- `pnpm stop` — stop Supabase local stack
- `pnpm status` — show connection info (ports, URLs)
- `pnpm db:import` — apply Postgres schema from `docs/schema/plsql/schema.sql` to local DB
- `pnpm db:clear` — drop the `eduapp` schema (destructive)
- `pnpm db:reset` — clear then import schema (destructive)
- `pnpm clean` — stop services and prune leftover Docker volumes (destructive)

Typical workflow

1. Start services

```sh
pnpm dev
```

2. Import schema

```sh
pnpm db:import
# or force a clean reset
pnpm db:reset
```

3. Connect (psql)

```sh
psql 'postgresql://postgres:postgres@127.0.0.1:54322/postgres'
```

Notes

- The import/reset scripts assume the default local DB URL; if you customize ports or credentials, run `pnpm status` and substitute the URL in your commands.
- The schema file is generated from the combined ERD (`docs/erd/erd.mmd`). See `docs/schema/README.md` for details.
- Do not store real PII in development databases.
