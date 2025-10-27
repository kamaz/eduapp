# 🚀 Core MVP Features (3-Month Build Target)

## 👧 For Children

### ✨ Smart Onboarding Experience

Guided introduction where the child (with parent support) answers playful questions about:

- Interests (books, games, animals, hobbies, heroes, etc.)
- Preferred ways to learn (stories, visuals, puzzles, experiments)
- Mood and motivation (what makes learning “fun”)

Child-friendly visuals and voice interaction to make onboarding engaging.

### AI-Personalised Exercises

- Tasks automatically reflect the child’s interests (e.g., “LEGO fractions,” “football grammar examples”).
- Exercises mapped to UK National Curriculum for Maths & English (Key Stage 1–2).

### Interactive & Paper Modes

- Complete tasks digitally or via printable worksheets.
- Parents can take a photo of written answers for assessment and feedback.

### Positive Reinforcement

- Encouraging animations, badges, and verbal praise (“You’re improving so fast!”).
- Child-facing feedback focuses on progress, not just correctness.

## 👨‍👩‍👧 For Parents

### Parent Onboarding

- Parents provide structured context about the child:
- Learning challenges or preferences.
- Reading habits and media interests.
- Any wellbeing or attention factors (e.g., struggles with focus or fine motor skills).
- Optionally, add simple daily info like sleep, energy, or meal notes to refine context.

### Curriculum Map View

- Clear visual mapping of all exercises to UK curriculum topics.
- Shows coverage, progress, and skill mastery (e.g., “Fractions 60% complete”).

### AI Activity Generator

Parents can upload a school worksheet or choose a topic, and the system:

- Creates new personalised examples.
- Suggests different explanation styles (story, analogy, visual).

### Performance Summary

Tracks completed activities, learning gaps, and progress trends.

### Print & Upload Support

- Generate printable worksheets.
- Upload photos for OCR-based auto-assessment.

### Wellbeing & Routine Support

- Gentle reminders for breaks, hydration, and rest balance.

### Child Primary Parent & Sharing

- Only a Parent can create a Child profile.
- The Parent who creates the Child becomes the Primary (initial parent) for that Child.
- The Primary can:
  - Share the Child with other Parents (grant or revoke management for them).
  - Share the Child with Tutors, Teachers, and Family members (viewer or contributor access).
- Non-primary Parents cannot remove the Primary, and cannot change other Parents’ management rights.
- Any Parent (Primary or invited Parent) may share with Tutors/Teachers/Family (viewer/contributor) unless the Primary restricts this in settings.
- The Primary can revoke management rights from other Parents and revoke access for any non-parent persona at any time.
- All shares are auditable; invitations are idempotent by target user and child.

## System & AI

### UK National Curriculum Graph

Structured map linking learning goals, age expectations, and progression paths.

### AI Personalisation Layer

Combines onboarding inputs (interests, parent data, behaviour patterns) with performance metrics to adapt exercises.

### OCR & Handwriting Recognition (Light MVP)

Detects answers and basic markings for correctness tracking.

### Privacy by Design

Child data encrypted, locally stored when possible, and parent-owned.

### Analytics & Feedback Loop

Tracks engagement, learning gains, and parental satisfaction for iteration.

### 🧠 AI Personalisation Layer

- Builds and continuously updates a unique learner profile per child based on:
  - Onboarding inputs (interests, habits, learning style).
  - Parent observations and engagement metrics.
  - Curriculum progress and performance data.
- Generates AI-personalised exercises and customised printable worksheets aligned to the UK National Curriculum.
- Suggests different explanation styles (story, visual, practical examples) to suit the learner’s preference.

### 📘 Curriculum, Subjects, Lessons, and Tasks

- Curriculum Graph (UK-first), normalized:
  - Subjects → Topics (with KS band and recommended age range) → Lesson Templates/Instances → Task Templates/Instances.
  - Topics include normalized prerequisites (graph traversal and indexing supported).
- Lessons use a template → instance pattern:
  - Lesson Templates (explanations/notes, style, difficulty) are canonical per topic.
  - Lesson Instances are personalised per child (can vary characters, context, tone) and store the parameters used.
- Tasks use a template → instance pattern:
  - Task Templates define variable schema and rubric; can be created from uploads (photos/PDFs) or authored.
  - Task Instances are personalised per child/session with `role` and typed solutions.
  - `role`: example | practice | assessment; practice items reference their example instance.
  - `answer_type` and `expected_answer_json` capture the canonical solution; optional `solution_explanation_asset_id` links to worked steps.
- Parents can upload photos/worksheets or paste examples; the system extracts a Task Template and can generate personalised Tasks for a specific child from that template.
- Enables easy search and auto‑tagging of uploaded materials.
- Supports curriculum versioning for regional or future expansions (e.g., Polish curriculum phase 2).
- Includes admin interface (phase 2) for adding or updating learning materials.

### 🖨️ Printable Worksheet Generator

- Converts AI-created or parent-uploaded exercises into printable PDF sheets.
- Includes QR code or ID for quick scanning/uploading back into the system.
- Handles automatic mapping of completed worksheets to child progress tracking.
- Optimised for both home printing and tablet stylus use.

### 👋 User Onboarding & Registration

- Guided, gamified onboarding flow for children.
- Parent onboarding captures contextual data (child’s interests, habits, learning support needs).
- Multi-role account system (Child, Parent, Tutor, Teacher) — MVP activates only Child + Parent roles.
- Simple email-based sign-up/login (social or Apple/Google sign-in optional later).

### 💳 Subscription & Payment Module

- Enables freemium-to-premium model:
  - Free plan → limited topics or weekly tasks.
  - Paid plan → full curriculum access, adaptive AI feedback, printable tracking.
- Secure payment handling through Stripe or Paddle integration.
- Parent dashboard for subscription management (plan type, renewal, invoices).

### ✉️ Email & Notification Services

- Transactional emails: registration confirmation, password reset, subscription receipts.
- Progress and reminder notifications:
  - Child progress summaries.
  - Suggested next exercises.
  - Gentle reminders for wellbeing breaks.
- Event-based notification rules (e.g., “new worksheet available” or “review ready”).

### 📨 Access Requests (Non‑Primary Personas)

- Any non‑primary persona (Tutor, Teacher, Family, or another Parent) can initiate a request to the Primary Parent to gain access to a Child.
- If the Primary Parent already has an account: send an in‑app notification and an email with accept/decline links.
- If the Primary Parent is not yet on the system (pre‑onboarding case): send an email with a secure invite link and instructions to create an account and enroll their Child.
- The Primary Parent remains in full control: only the Primary can create the Child and approve role + access level.
- On acceptance:
  - Parent role → invited as Parent with viewer/contributor, and optionally manager (Primary decides; non‑primary Parents can never remove the Primary).
  - Tutor/Teacher/Family roles → invited with viewer or contributor (manager not applicable).
  - System creates or updates `child_access` accordingly.

### 🔐 Data & Security

- GDPR-compliant design with explicit parental consent for child data.
- Secure token-based authentication and encrypted storage.
- Child data fully exportable and erasable on request.
- Analytics anonymised to support iterative improvement without exposing private data.

### 🧩 Integration Layer

- Image Upload → OCR → Answer Validation Pipeline.
- Future integrations:
  - Smartwatch health data (wellbeing insights).
  - School/tutor dashboards.
  - External learning content providers.

### 🧠 AI & Data Foundation

- Curriculum Knowledge Graph: Ontology connecting topics, difficulty, and prerequisites.
- Child Learning Model: Dynamic learner representation combining:
  - Knowledge state.
  - Engagement metrics.
  - Preference profile.
- Activity Recommendation Engine: AI model that suggests next best tasks based on performance, mood, and engagement history.
- Feedback Loop: Continuous refinement using parent input and child outcomes.

## 🧩 Stretch Goals (If Capacity Allows)

### Voice Interaction

Read-aloud questions and verbal encouragement for younger learners.

### Parental Reflection Log

Parents can add notes (“More focused today”, “Loved the LEGO example”).

### Wellbeing Insights

Integrate smartwatch or sensor data for rest, heart rate, and energy indicators.

### Offline Support

Capture learning data from printed worksheets offline.

## 📈 Post-MVP Expansion Path

| Phase          | Focus          | Key Additions                                                |
| -------------- | -------------- | ------------------------------------------------------------ |
| MVP (3 months) | Parent + Child | AI onboarding, curriculum mapping, printable & digital tasks |
| Phase 2        | Tutors         | Multi-child dashboards, homework review                      |
| Phase 3        | Teachers       | Classroom feedback, progress analytics                       |
| Phase 4        | Wellbeing      | Smartwatch and physical activity integration                 |
| Phase 5        | Ecosystem      | Shared profiles, peer comparisons, AI career guidance        |

## 🎯 MVP Success Criteria

| Goal                                                      | Metric                                              |
| --------------------------------------------------------- | --------------------------------------------------- |
| Parents successfully create curriculum-aligned activities | ≥80% correct mapping rate                           |
| AI onboarding successfully personalises examples          | ≥70% of children show higher engagement             |
| Worksheets printed and scanned for tracking               | ≥60% of users use print mode                        |
| Parents report better understanding of child progress     | ≥4.2/5 satisfaction                                 |
| System adapts difficulty effectively                      | ≥70% of activities completed with improvement trend |
