# Firebase Emulator (Devtools)

Local Firebase Auth Emulator used for development. This aligns with the PRD: identity via Firebase Auth; tokens are validated in the Worker and mapped to D1.

## What this provides

- Auth Emulator on `127.0.0.1:9099`
- Emulator UI on `http://127.0.0.1:4000`
- Optional seeding for demo users

## Commands

- `pnpm dev` or `pnpm start` — start emulators (Auth + UI)
- `pnpm seed` — create demo users in the Auth emulator
- `pnpm clean` — reset emulator data directory

## Usage

1. From repo root: `pnpm -w dev:emulators` or within this package `pnpm dev`.
2. Visit Emulator UI at `http://127.0.0.1:4000`.
3. Seed demo users: `pnpm seed`.

## Environment

The Worker should validate ID tokens issued by the Auth emulator when `FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099` is set in its environment. The mobile client uses `useEmulator()` (RN Firebase) or equivalent SDK config in dev builds.

## Notes

- Data is stored under `./emulator-data` and exported on exit.
- No PII beyond demo placeholders. Do not use real emails in development.
- This package is ESM-only and uses `pnpm` scripts. Typescript is included for seeding convenience.
