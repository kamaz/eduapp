-- SQLite schema generated from docs/erd/erd.mmd (D1-compatible)
-- Conventions
-- - TEXT identifiers (ULID/UUID)
-- - INTEGER epoch ms for timestamps
-- - JSON stored as TEXT (use JSON functions if available)
-- - Booleans as INTEGER (0/1)

PRAGMA foreign_keys = ON;

-- USERS
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  firebase_uid TEXT UNIQUE,
  email TEXT UNIQUE,
  display_name TEXT,
  billing_customer_id TEXT,
  settings_json TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- CHILDREN
CREATE TABLE IF NOT EXISTS children (
  id TEXT PRIMARY KEY,
  alias TEXT,
  given_name TEXT,
  family_name TEXT,
  preferred_name TEXT,
  short_name TEXT,
  nickname TEXT,
  email TEXT UNIQUE,
  avatar_asset_id TEXT,
  locale TEXT,
  dob INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER
);

-- ASSETS
CREATE TABLE IF NOT EXISTS assets (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  r2_bucket TEXT NOT NULL,
  r2_key TEXT NOT NULL,
  mime_type TEXT,
  size_bytes INTEGER,
  checksum_sha256 TEXT,
  created_at INTEGER NOT NULL
);

-- CHILD ACCESS MEMBERSHIPS
CREATE TABLE IF NOT EXISTS child_access (
  id TEXT PRIMARY KEY,
  child_id TEXT NOT NULL REFERENCES children(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  persona_role TEXT NOT NULL,
  access_level TEXT NOT NULL CHECK (access_level IN ('parent','teacher','tutor','family')),
  is_primary_parent INTEGER DEFAULT 0,
  invited_by_user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
  revoked_at INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(child_id, user_id)
);
CREATE INDEX IF NOT EXISTS idx_child_access_child ON child_access(child_id);
CREATE INDEX IF NOT EXISTS idx_child_access_user ON child_access(user_id);

-- ACCESS REQUESTS
CREATE TABLE IF NOT EXISTS access_requests (
  id TEXT PRIMARY KEY,
  requester_user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  target_parent_user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
  target_child_id TEXT REFERENCES children(id) ON DELETE SET NULL,
  target_parent_email TEXT,
  desired_persona_role TEXT NOT NULL,
  desired_access_level TEXT NOT NULL CHECK (desired_access_level IN ('parent','teacher','tutor','family')),
  status TEXT NOT NULL,
  token TEXT UNIQUE,
  expires_at INTEGER,
  message TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  acted_at INTEGER,
  acted_by_user_id TEXT REFERENCES users(id) ON DELETE SET NULL
);

-- CONSENT POLICIES & USER CONSENTS (simplified; audit handled separately)
CREATE TABLE IF NOT EXISTS consent_policies (
  id TEXT PRIMARY KEY,
  group_key TEXT NOT NULL,
  version INTEGER NOT NULL,
  title TEXT,
  locale TEXT,
  asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  status TEXT NOT NULL,
  effective_at INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(group_key, version)
);

CREATE TABLE IF NOT EXISTS user_consents (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  policy_id TEXT NOT NULL REFERENCES consent_policies(id) ON DELETE CASCADE,
  group_key TEXT NOT NULL,
  version INTEGER NOT NULL,
  accepted_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(user_id, group_key)
);

-- CHILD PROFILE
CREATE TABLE IF NOT EXISTS child_profile (
  id TEXT PRIMARY KEY,
  child_id TEXT NOT NULL REFERENCES children(id) ON DELETE CASCADE,
  created_by_user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  updated_by_user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
  authored_by_child INTEGER DEFAULT 0,
  persona_role TEXT NOT NULL,
  status TEXT NOT NULL,
  learning_style TEXT,
  profile_summary TEXT,
  sensitivities TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(child_id, created_by_user_id, status)
);

CREATE TABLE IF NOT EXISTS child_profile_items (
  id TEXT PRIMARY KEY,
  profile_id TEXT NOT NULL REFERENCES child_profile(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  value TEXT NOT NULL,
  created_at INTEGER NOT NULL
);

-- CHILD OBSERVATIONS
CREATE TABLE IF NOT EXISTS child_observations (
  id TEXT PRIMARY KEY,
  child_id TEXT NOT NULL REFERENCES children(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  note_type TEXT NOT NULL,
  body TEXT,
  status TEXT NOT NULL,
  superseded_by_observation_id TEXT REFERENCES child_observations(id) ON DELETE SET NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_child_obs_child ON child_observations(child_id);

-- SUBSCRIPTIONS
CREATE TABLE IF NOT EXISTS subscription_plans (
  id TEXT PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  title TEXT,
  description TEXT,
  interval TEXT NOT NULL,
  interval_count INTEGER NOT NULL DEFAULT 1,
  currency TEXT NOT NULL,
  amount_cents INTEGER NOT NULL,
  trial_days INTEGER,
  features_json TEXT,
  provider_product_id TEXT,
  provider_price_id TEXT,
  status TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS user_subscriptions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  provider TEXT NOT NULL,
  provider_customer_id TEXT,
  provider_subscription_id TEXT UNIQUE,
  plan_id TEXT REFERENCES subscription_plans(id) ON DELETE SET NULL,
  status TEXT NOT NULL,
  current_period_end INTEGER,
  cancel_at_period_end INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- CURRICULUM
CREATE TABLE IF NOT EXISTS curriculum_subjects (
  id TEXT PRIMARY KEY,
  country_code TEXT,
  key TEXT UNIQUE,
  title TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS curriculum_topics (
  id TEXT PRIMARY KEY,
  subject TEXT,
  subject_id TEXT REFERENCES curriculum_subjects(id) ON DELETE SET NULL,
  code TEXT,
  title TEXT,
  description TEXT,
  grade_band TEXT,
  recommended_age_min INTEGER,
  recommended_age_max INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_curr_topics_subject ON curriculum_topics(subject);

CREATE TABLE IF NOT EXISTS curriculum_prereqs (
  id TEXT PRIMARY KEY,
  from_topic_id TEXT NOT NULL REFERENCES curriculum_topics(id) ON DELETE CASCADE,
  to_topic_id TEXT NOT NULL REFERENCES curriculum_topics(id) ON DELETE CASCADE,
  created_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_curr_prereq_from ON curriculum_prereqs(from_topic_id);
CREATE INDEX IF NOT EXISTS idx_curr_prereq_to ON curriculum_prereqs(to_topic_id);

-- LESSONS & TASKS
CREATE TABLE IF NOT EXISTS lesson_templates (
  id TEXT PRIMARY KEY,
  topic_id TEXT REFERENCES curriculum_topics(id) ON DELETE SET NULL,
  title TEXT,
  asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  overview_json TEXT,
  style TEXT,
  difficulty INTEGER,
  time_limit_ms INTEGER,
  order_id INTEGER,
  status TEXT,
  created_by TEXT,
  created_by_user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS lesson_instances (
  id TEXT PRIMARY KEY,
  lesson_template_id TEXT REFERENCES lesson_templates(id) ON DELETE SET NULL,
  child_id TEXT REFERENCES children(id) ON DELETE CASCADE,
  title TEXT,
  asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  style TEXT,
  difficulty INTEGER,
  personalization_params_json TEXT,
  created_by_user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
  status TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS task_templates (
  id TEXT PRIMARY KEY,
  topic_id TEXT REFERENCES curriculum_topics(id) ON DELETE SET NULL,
  lesson_template_id TEXT REFERENCES lesson_templates(id) ON DELETE SET NULL,
  title TEXT,
  style TEXT,
  difficulty INTEGER,
  time_limit_ms INTEGER,
  depends_on_id TEXT REFERENCES task_templates(id) ON DELETE SET NULL,
  order_id INTEGER,
  asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  created_by TEXT,
  created_by_user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
  status TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS task_instances (
  id TEXT PRIMARY KEY,
  task_template_id TEXT REFERENCES task_templates(id) ON DELETE SET NULL,
  topic_id TEXT REFERENCES curriculum_topics(id) ON DELETE SET NULL,
  lesson_instance_id TEXT REFERENCES lesson_instances(id) ON DELETE SET NULL,
  child_id TEXT REFERENCES children(id) ON DELETE CASCADE,
  role TEXT,
  example_root_task_instance_id TEXT REFERENCES task_instances(id) ON DELETE SET NULL,
  title TEXT,
  style TEXT,
  difficulty INTEGER,
  asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  answer_type TEXT,
  expected_answer_json TEXT,
  solution_asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  created_by TEXT,
  created_by_user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
  status TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- TASK SETS
CREATE TABLE IF NOT EXISTS task_set_templates (
  id TEXT PRIMARY KEY,
  topic_id TEXT REFERENCES curriculum_topics(id) ON DELETE SET NULL,
  type TEXT,
  title TEXT,
  description TEXT,
  time_limit_ms INTEGER,
  passing_score REAL,
  status TEXT,
  created_by TEXT,
  created_by_user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS task_set_template_items (
  id TEXT PRIMARY KEY,
  set_template_id TEXT NOT NULL REFERENCES task_set_templates(id) ON DELETE CASCADE,
  task_template_id TEXT NOT NULL REFERENCES task_templates(id) ON DELETE CASCADE,
  order_id INTEGER,
  points INTEGER,
  time_limit_ms INTEGER,
  depends_on_id TEXT REFERENCES task_set_template_items(id) ON DELETE SET NULL,
  asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  question_json TEXT,
  config_json TEXT,
  answer_json TEXT,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS task_set_instances (
  id TEXT PRIMARY KEY,
  set_template_id TEXT REFERENCES task_set_templates(id) ON DELETE SET NULL,
  child_id TEXT NOT NULL REFERENCES children(id) ON DELETE CASCADE,
  type TEXT,
  title TEXT,
  description TEXT,
  time_limit_ms INTEGER,
  passing_score REAL,
  status TEXT,
  created_by_user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
  started_at INTEGER,
  completed_at INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS task_set_instance_items (
  id TEXT PRIMARY KEY,
  set_instance_id TEXT NOT NULL REFERENCES task_set_instances(id) ON DELETE CASCADE,
  task_instance_id TEXT NOT NULL REFERENCES task_instances(id) ON DELETE CASCADE,
  order_index INTEGER,
  points INTEGER,
  item_time_limit_ms INTEGER,
  depends_on_id TEXT REFERENCES task_set_instance_items(id) ON DELETE SET NULL,
  question_json TEXT,
  config_json TEXT,
  answer_json TEXT,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS task_set_template_lessons (
  id TEXT PRIMARY KEY,
  set_template_id TEXT NOT NULL REFERENCES task_set_templates(id) ON DELETE CASCADE,
  lesson_template_id TEXT NOT NULL REFERENCES lesson_templates(id) ON DELETE CASCADE,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS task_set_instance_lessons (
  id TEXT PRIMARY KEY,
  set_instance_id TEXT NOT NULL REFERENCES task_set_instances(id) ON DELETE CASCADE,
  lesson_instance_id TEXT NOT NULL REFERENCES lesson_instances(id) ON DELETE CASCADE,
  created_at INTEGER NOT NULL
);

-- ATTEMPTS (after instances)
CREATE TABLE IF NOT EXISTS attempts (
  id TEXT PRIMARY KEY,
  child_id TEXT NOT NULL REFERENCES children(id) ON DELETE CASCADE,
  task_instance_id TEXT NOT NULL REFERENCES task_instances(id) ON DELETE CASCADE,
  task_set_instance_id TEXT REFERENCES task_set_instances(id) ON DELETE SET NULL,
  task_set_instance_item_id TEXT REFERENCES task_set_instance_items(id) ON DELETE SET NULL,
  attempt_client_id TEXT,
  source TEXT,
  answer_asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  strokes_asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  score REAL,
  presentation_score REAL,
  correct INTEGER,
  summary_json TEXT,
  duration_ms INTEGER,
  created_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_attempts_child ON attempts(child_id);

-- PROGRESS & EVENTS
CREATE TABLE IF NOT EXISTS progress (
  id TEXT PRIMARY KEY,
  child_id TEXT NOT NULL REFERENCES children(id) ON DELETE CASCADE,
  topic_id TEXT NOT NULL REFERENCES curriculum_topics(id) ON DELETE CASCADE,
  mastery REAL,
  attempts_count INTEGER,
  last_practiced_at INTEGER,
  history_json TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_progress_child ON progress(child_id);

CREATE TABLE IF NOT EXISTS progress_events (
  id TEXT PRIMARY KEY,
  child_id TEXT NOT NULL REFERENCES children(id) ON DELETE CASCADE,
  topic_id TEXT NOT NULL REFERENCES curriculum_topics(id) ON DELETE CASCADE,
  attempt_id TEXT REFERENCES attempts(id) ON DELETE SET NULL,
  reason TEXT NOT NULL,
  delta_mastery REAL,
  mastery_after REAL,
  created_at INTEGER NOT NULL
);

-- GENERATION & JOBS
CREATE TABLE IF NOT EXISTS generation_requests (
  id TEXT PRIMARY KEY,
  requested_by_user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  target_child_id TEXT REFERENCES children(id) ON DELETE SET NULL,
  source TEXT NOT NULL,
  intent TEXT NOT NULL,
  notes TEXT,
  idempotency_key TEXT,
  status TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  completed_at INTEGER
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_gen_req_idem ON generation_requests(idempotency_key) WHERE idempotency_key IS NOT NULL;

CREATE TABLE IF NOT EXISTS jobs (
  id TEXT PRIMARY KEY,
  request_id TEXT REFERENCES generation_requests(id) ON DELETE CASCADE,
  child_id TEXT REFERENCES children(id) ON DELETE SET NULL,
  kind TEXT NOT NULL,
  status TEXT NOT NULL,
  idempotency_key TEXT,
  run_at INTEGER,
  attempts INTEGER,
  input_asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  output_asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  error_asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  error_code TEXT,
  error_message_redacted TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_jobs_idem ON jobs(idempotency_key) WHERE idempotency_key IS NOT NULL;

CREATE TABLE IF NOT EXISTS job_steps (
  id TEXT PRIMARY KEY,
  job_id TEXT NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  step_kind TEXT NOT NULL,
  status TEXT NOT NULL,
  input_asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  output_asset_id TEXT REFERENCES assets(id) ON DELETE SET NULL,
  error_code TEXT,
  error_message_redacted TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
