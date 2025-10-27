# 🗓️ Learning Plans & Scheduling (Post‑MVP)

## Purpose

Enable adults and the system to create structured learning plans that help a child:

- Achieve a target level (e.g., KS2 topic mastery by term end)
- Prepare for a specific exam or assessment window
- Maintain healthy pacing with balanced workload and wellbeing in mind

This is a post‑MVP capability. The MVP focuses on generation, attempts, and progress; planning and time‑bound scheduling arrive afterwards.

## Scope

- Plans link goals → curriculum topics → concrete tasks over time.
- Plans can be authored or adjusted by Parents (initially) and later Tutors/Teachers.
- The system recommends plan items based on current mastery, gaps, and preferences.
- Plans show up as a child’s upcoming work queue and a calendar/timeline view for adults.

## Personas & Responsibilities

- Parent (post‑MVP initial owner): create goals ("Ready for Year‑3 fractions by July"), review weekly schedule, approve suggestions.
- Tutor/Teacher (later phases): assign homework blocks, align with classroom goals, monitor adherence.
- System: suggests next plan items, adjusts pacing from progress and engagement.

## Key Concepts

- Goal: target outcome with timeframe (e.g., exam date, level target) and success criteria (topic coverage, mastery threshold).
- Milestones: intermediate checkpoints (e.g., half‑term targets) with optional assessments.
- Plan Items: scheduled windows linking a `child` to a `topic` and optionally a `task`; can be suggested or manual.
- Status: `planned|completed|skipped|moved` with audit who/when changed.

## Experience Summary

- Adults define a goal and timeframe; the system proposes a weekly cadence across topics sized to the child’s current mastery and preferences.
- Adults can accept, move, or remove suggested items.
- The child sees an approachable "what’s next" queue; no heavy calendar UI.

## Data Notes (Post‑MVP)

- Introduce planning entities in D1 after MVP stabilization. A minimal path is to extend `scheduled_lessons` for plan items and add goal/milestone tables:
  - `learning_goals` (child, goal_type: level|exam, target_window, success_criteria, created_by, timestamps)
  - `learning_milestones` (goal_id, title, target_date, optional assessment ref)
  - `scheduled_lessons` (plan items) used as time‑bound entries referencing `child_id`, `topic_id`, optional `task_id`, window start, status, source, audit fields
- API (post‑MVP): list/manage goals; list upcoming plan items; accept/adjust suggestions; mark complete.
- AuthZ: same child membership model; tenant isolation by child.

## Out of Scope for MVP

- Calendar UI, recurring rules, bulk moves, and class‑level planning.
- Teacher dashboards with multi‑child cohort planners.

## Dependencies

- Progress snapshots (MVP) to inform plan suggestions.
- Curriculum graph (MVP) for prerequisite‑aware pacing.

## Success Signals (post‑MVP)

- Parents/tutors report clearer path to targets.
- Increased completion and mastery in planned topics by deadline.
