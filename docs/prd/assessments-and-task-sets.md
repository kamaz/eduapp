# 🧪 Assessments & Task Sets (Post‑MVP)

## Purpose

Model exams, mini quizzes, and multi‑step sequences using a single, flexible grouping abstraction that supports:

- Reuse via templates, per‑child personalisation via instances
- Set‑level time limits, optional per‑item limits, pass thresholds
- Ordering, simple dependencies, and value propagation across items
- Cohesive grading/reporting across a set

## Concepts

- Templates vs Instances:
  - Task Set Templates define composition, ordering, and timing.
  - Task Set Instances are created per child; they materialize concrete Task Instances and runtime state.
- Task Set: a named collection (exam|quiz|sequence) with optional time limits and pass thresholds.
- Set Item: an ordered entry in the set; can define per‑item limits, weights, and dependencies.
- Attempt Context: attempts carry optional `task_set_instance_id` and `task_set_instance_item_id` to capture when a task was completed as part of a set.

## Entities (D1)

- `task_set_templates`
  - Fields: `id`, `lesson_template_id?`, `type` (exam|quiz|sequence), `title`, `description`, `time_limit_ms?`, `passing_score?`, `status`, `created_by`, `created_by_user_id?`, `created_at`, `updated_at`
- `task_templates`
  - Fields: `id`, `set_template_id?`, `title`, `style`, `difficulty`, `time_limit_ms?`, `depends_on_id?`, `order_id?`, `asset_id?`, `created_by`, `created_by_user_id?`, `status`, `created_at`, `updated_at`
- `task_item_templates`
  - Fields: `id`, `task_template_id`, `order_id?`, `points?`, `time_limit_ms?`, `depends_on_id?`, `asset_id?`, `question_json?`, `config_json?`, `answer_json?`, `created_at`
- `task_set_instances`
  - Fields: `id`, `set_template_id?`, `child_id`, `type`, `title?`, `description?`, `time_limit_ms?`, `passing_score?`, `status`, `created_by_user_id?`, `started_at?`, `completed_at?`, `created_at`, `updated_at`
- `task_set_instance_items`
  - Fields: `id`, `set_instance_id`, `task_instance_id`, `order_index`, `points?`, `item_time_limit_ms?`, `depends_on_id?`, `question_json?`, `config_json?`, `answer_json?`, `created_at`
- `attempts` (extension)
  - Adds: `task_set_instance_id?`, `task_set_instance_item_id?`

## Use Cases

- Exams: `type=exam` with `time_limit_ms`, optional `passing_score`, ordered tasks; report/export at the set instance level.
- Mini Quizzes: `type=quiz`, usually shorter and may be untimed.
- Sequences: `type=sequence` with item dependencies; items may embed lightweight `question_json` + `config_json` and `answer_json` when not referencing a separate task template.

## Out of Scope (for MVP)

- Set‑level scheduling (covered by Learning Plans & Scheduling post‑MVP).
- Class‑level exam management (teacher cohort dashboards).

## Notes

- This model complements Lessons/Tasks: lessons still provide explanations; task set templates group related tasks; task templates are assessable units with typed solutions; task item templates carry the per‑item question/config/answer JSON; sets add composition, timing, and ordering.
- Linkage: task set templates belong to a lesson template; set instances can link to the personalised lesson instances active for the child.
- For safety and privacy, normal auth and tenant isolation apply; group attempts inherit the same checks as standalone tasks.

## API shape (post‑MVP sketch)

- Templates
  - POST /task-set-templates — create (type, items, constraints)
  - GET /task-set-templates/:id — read
  - PATCH /task-set-templates/:id — update
- Instances
  - POST /task-set-instances — create for child (from template or ad‑hoc)
  - POST /task-set-instances/:id/start — start timing
  - POST /task-set-instances/:id/complete — finish, compute pass/fail
  - GET /task-set-instances?child_id= — list
