# Mermaid ERD Guidelines

These conventions ensure diagrams render reliably and stay informative.

## Syntax Conventions

- Use `erDiagram` blocks.
- Annotate columns with: `PK`, `FK`, `UK` where applicable.
- Use double quotes around descriptions and single quotes inside examples.
  - Example: `string settings_json "Account prefs JSON. Example: {'locale':'en-GB'}"`
- Avoid Mermaid comments (%%) inside entity blocks to prevent rendering issues.
- Keep field descriptions concise; prefer one line per field.

## Relationship Notation

- `||--||` for 1:1, `||--o{` for 1:N (left side one, right side many).
- Label relationships with short verbs or nouns.

## Composite Constraints

- Mermaid ERD does not support composite unique keys inline; document them in the PRD and in field descriptions.
  - Example note: `int version "Monotonic version per profile (unique per profile)"`

## Domain Split

- Split large ERDs by domain for readability: onboarding, tasks/lessons, progress.
- Duplicate shared entities minimally to keep each diagram self-contained.

## Field Types & Timestamps

- Prefer `TEXT` (string) identifiers using ULIDs for portability.
- Use epoch milliseconds for `created_at`/`updated_at` and name them consistently across tables.
