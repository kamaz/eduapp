# Best Practices — Schema, ERDs, and Onboarding Data

This directory captures conventions and patterns to keep these practices consistent acrossapplication.

## TL;DR Principles

- Keep ERDs human-readable and renderable in Mermaid; annotate columns with PK/FK/UK and concise descriptions.

## Source of Truth

- ERDs under `docs/erd/*.mmd` reflect current intent.
- PRD sections under `docs/prd/*` must be updated alongside diagram changes.
- When changing schema intent, update both the ERD(s) and PRD before writing migrations.
