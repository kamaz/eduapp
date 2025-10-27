# 📐 Templates vs Instances

This document defines what “templates” and “instances” are across Lessons, Tasks, and Task Sets, why we need both, and how they are used.

## Why this split exists

- Reuse and authoring: Adults (or AI) create canonical materials once as templates (with variables and rubric where appropriate).
- Personalisation: The system materialises child‑specific instances from templates using the active profile, preferences, and progress.
- Audit and reproducibility: Instances snapshot the parameters used for personalisation to explain and reproduce outcomes.
- Iteration: When a child struggles, we can generate alternate instances of the same template (e.g., different character, analogy, or representation) without mutating the template.

## Lesson Templates and Instances

- Lesson Template
  - Purpose: canonical explanation of a topic; holds overview asset (notes/explanations), style, and difficulty guidance.
  - Scope: topic‑level; reusable across children.
  - Created by: AI or user (parent/tutor/teacher) via authoring or ingestion.
  - Links: may include references to associated Task Templates.

- Lesson Instance
  - Purpose: a personalised lesson for a specific child (e.g., different character, theme, or tone), derived from a template.
  - Scope: child‑level; can have multiple instances if a child needs alternative explanations.
  - Stores: personalisation parameters snapshot (what variables/prompts were used), and an optional personalised overview asset.
  - Links: the child’s Task Instances can attach to the Lesson Instance used in the session.

## Task Templates and Instances

- Task Template
  - Purpose: defines the variable schema (e.g., a,b with constraints), rubric, and “what kind of problem this is”.
  - Source: created by upload + OCR/extract (e.g., parent photo or book page) or user/AI authoring.
  - Links: optionally associated to a Lesson Template; appears in Task Set Templates.

- Task Instance
  - Purpose: a concrete exercise materialised for a child/session from a Task Template.
  - Role: example | practice | assessment
    - Example: worked solution (step‑by‑step) demonstrating how to solve the pattern.
    - Practice: similar problem(s) to test understanding; may reference the example instance.
    - Assessment: summative item used in quizzes/exams.
  - Solution: typed by `answer_type` with `expected_answer_json`; optional `solution_explanation_asset_id` for step‑by‑steps.
  - Links: may reference `example_root_task_instance_id` for “jump back to example”.

## Task Set Templates and Instances (Exams, Quizzes, Sequences)

- Task Set Template
  - Purpose: defines a reusable composition of tasks (exam|quiz|sequence) with ordering, optional time limits, and pass thresholds.
  - Items: ordered entries that reference Task Templates, with optional per‑item time limit, points, and simple dependencies.
  - Dependencies/Propagation: encode that an item can depend on a prior item and optionally “carry” a value (numeric/text/expression) forward.
  - Links: can be linked to one or more Lesson Templates that provide coverage.

- Task Set Instance
  - Purpose: a child‑specific realisation of a set; materialises Task Instances, tracks timing and status (draft|running|completed|canceled).
  - Items: ordered entries bound to Task Instances.
  - Attempts: when a child answers within a set context, attempts record `task_set_instance_id` and `task_set_instance_item_id`.
  - Links: can be linked to the Lesson Instances provided to the child during the set.

## Typical flows

1. Parent uploads a worksheet → OCR/extract → Task Template created → Personalise into Task Instances for the child → Attempt recorded on instances.
2. Explain then practice → Lesson Template → Lesson Instance → Example Task Instance (worked) → Practice Task Instances that reference the example.
3. Exam/Quiz → Task Set Template → Task Set Instance for the child → Items materialise Task Instances in order → Attempts recorded with set context.

## Storage summary (D1)

- Templates: lesson_templates, task_templates, task_set_templates (+ task_set_template_items, links to lesson_templates)
- Instances: lesson_instances, task_instances, task_set_instances (+ task_set_instance_items, links to lesson_instances)
- Attempts: reference task_instance_id; optionally reference task_set_instance_id and task_set_instance_item_id when answered in a set.
