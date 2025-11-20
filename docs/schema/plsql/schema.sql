-- PostgreSQL schema generated from docs/erd/erd.mmd
-- Conventions
-- - TEXT identifiers (ULIDs/UUIDs)
-- - BIGINT epoch ms for timestamps
-- - JSONB for JSON columns
-- - BOOLEAN for flags

create schema if not exists eduapp;
set search_path=eduapp,public;

-- USERS
create table if not exists users (
  id text primary key,
  firebase_uid text unique,
  email text unique,
  display_name text,
  billing_customer_id text,
  settings_json jsonb,
  created_at bigint not null,
  updated_at bigint not null
);

-- CHILDREN
create table if not exists children (
  id text primary key,
  alias text,
  given_name text,
  family_name text,
  preferred_name text,
  short_name text,
  nickname text,
  email text unique,
  avatar_asset_id text,
  locale text,
  dob bigint,
  created_at bigint not null,
  updated_at bigint not null,
  deleted_at bigint
);

-- ASSETS
create table if not exists assets (
  id text primary key,
  type text not null,
  r2_bucket text not null,
  r2_key text not null,
  mime_type text,
  size_bytes bigint,
  checksum_sha256 text,
  created_at bigint not null
);

-- CHILD ACCESS MEMBERSHIPS
create table if not exists child_access (
  id text primary key,
  child_id text not null references children(id) on delete cascade,
  user_id text not null references users(id) on delete cascade,
  persona_role text not null,
  access_level text not null check (access_level in ('parent','teacher','tutor','family')),
  is_primary_parent boolean default false,
  invited_by_user_id text references users(id) on delete set null,
  revoked_at bigint,
  created_at bigint not null,
  updated_at bigint not null,
  unique(child_id, user_id)
);
create index if not exists idx_child_access_child on child_access(child_id);
create index if not exists idx_child_access_user on child_access(user_id);

-- ACCESS REQUESTS
create table if not exists access_requests (
  id text primary key,
  requester_user_id text not null references users(id) on delete cascade,
  target_parent_user_id text references users(id) on delete set null,
  target_parent_email text,
  target_child_id text references children(id) on delete set null,
  desired_persona_role text not null,
  desired_access_level text not null check (desired_access_level in ('parent','teacher','tutor','family')),
  status text not null,
  token text unique,
  expires_at bigint,
  message text,
  created_at bigint not null,
  updated_at bigint not null,
  acted_at bigint,
  acted_by_user_id text references users(id) on delete set null
);

-- CONSENT POLICIES & USER CONSENTS (simplified; audit handled separately)
create table if not exists consent_policies (
  id text primary key,
  group_key text not null,
  version integer not null,
  title text,
  locale text,
  asset_id text references assets(id) on delete set null,
  status text not null,
  effective_at bigint,
  created_at bigint not null,
  updated_at bigint not null,
  unique(group_key, version)
);

create table if not exists user_consents (
  id text primary key,
  user_id text not null references users(id) on delete cascade,
  policy_id text not null references consent_policies(id) on delete cascade,
  group_key text not null,
  version integer not null,
  accepted_at bigint not null,
  created_at bigint not null,
  updated_at bigint not null,
  unique(user_id, group_key)
);

-- CHILD PROFILE
create table if not exists child_profile (
  id text primary key,
  child_id text not null references children(id) on delete cascade,
  created_by_user_id text not null references users(id) on delete cascade,
  updated_by_user_id text references users(id) on delete set null,
  authored_by_child boolean default false,
  persona_role text not null,
  status text not null,
  learning_style text,
  profile_summary text,
  sensitivities text,
   profile_summary_tags_json jsonb,
   sensitivities_tags_json jsonb,
  created_at bigint not null,
  updated_at bigint not null,
  unique(child_id, created_by_user_id, status)
);

create table if not exists child_profile_items (
  id text primary key,
  profile_id text not null references child_profile(id) on delete cascade,
  type text not null,
  value text not null,
  description text,
  preference text check (preference in ('like','dislike','neutral')),
  tags_json jsonb,
  resource_url text,
  created_at bigint not null
);

-- CHILD OBSERVATIONS
create table if not exists child_observations (
  id text primary key,
  child_id text not null references children(id) on delete cascade,
  user_id text not null references users(id) on delete cascade,
  note_type text not null,
  body text,
  status text not null,
  superseded_by_observation_id text references child_observations(id) on delete set null,
  created_at bigint not null,
  updated_at bigint not null
);
create index if not exists idx_child_obs_child on child_observations(child_id);

-- SUBSCRIPTIONS
create table if not exists subscription_plans (
  id text primary key,
  key text unique not null,
  title text,
  description text,
  interval text not null,
  interval_count integer not null default 1,
  currency text not null,
  amount_cents integer not null,
  trial_days integer,
  features_json jsonb,
  provider_product_id text,
  provider_price_id text,
  status text not null,
  created_at bigint not null,
  updated_at bigint not null
);

create table if not exists user_subscriptions (
  id text primary key,
  user_id text not null references users(id) on delete cascade,
  provider text not null,
  provider_customer_id text,
  provider_subscription_id text unique,
  plan_id text references subscription_plans(id) on delete set null,
  status text not null,
  current_period_end bigint,
  cancel_at_period_end boolean default false,
  created_at bigint not null,
  updated_at bigint not null
);

-- CURRICULUM
create table if not exists curriculum_subjects (
  id text primary key,
  country_code text,
  key text unique,
  title text,
  created_at bigint not null,
  updated_at bigint not null
);

create table if not exists curriculum_topics (
  id text primary key,
  subject text,
  subject_id text references curriculum_subjects(id) on delete set null,
  code text,
  title text,
  description text,
  grade_band text,
  recommended_age_min integer,
  recommended_age_max integer,
  created_at bigint not null,
  updated_at bigint not null
);
create index if not exists idx_curr_topics_subject on curriculum_topics(subject);

create table if not exists curriculum_prereqs (
  id text primary key,
  from_topic_id text not null references curriculum_topics(id) on delete cascade,
  to_topic_id text not null references curriculum_topics(id) on delete cascade,
  created_at bigint not null
);
create index if not exists idx_curr_prereq_from on curriculum_prereqs(from_topic_id);
create index if not exists idx_curr_prereq_to on curriculum_prereqs(to_topic_id);

-- LESSONS & TASKS
create table if not exists lesson_templates (
  id text primary key,
  topic_id text references curriculum_topics(id) on delete set null,
  title text,
  asset_id text references assets(id) on delete set null,
  overview_json jsonb,
  style text,
  difficulty integer,
  time_limit_ms integer,
  order_id integer,
  status text,
  created_by text,
  created_by_user_id text references users(id) on delete set null,
  created_at bigint not null,
  updated_at bigint not null
);

create table if not exists lesson_instances (
  id text primary key,
  lesson_template_id text references lesson_templates(id) on delete set null,
  child_id text references children(id) on delete cascade,
  title text,
  style text,
  difficulty integer,
  personalization_params_json jsonb,
  created_by_user_id text references users(id) on delete set null,
  status text,
  created_at bigint not null,
  updated_at bigint not null
);

-- TASK SET TEMPLATES (belong to lessons)
create table if not exists task_set_templates (
  id text primary key,
  lesson_template_id text references lesson_templates(id) on delete set null,
  type text,
  title text,
  description text,
  time_limit_ms integer,
  passing_score double precision,
  status text,
  created_by text,
  created_by_user_id text references users(id) on delete set null,
  created_at bigint not null,
  updated_at bigint not null
);

-- TASK TEMPLATES (belong to a task set)
create table if not exists task_templates (
  id text primary key,
  set_template_id text references task_set_templates(id) on delete set null,
  title text,
  style text,
  difficulty integer,
  time_limit_ms integer,
  depends_on_id text references task_templates(id) on delete set null,
  order_id integer,
  asset_id text references assets(id) on delete set null,
  created_by text,
  created_by_user_id text references users(id) on delete set null,
  status text,
  created_at bigint not null,
  updated_at bigint not null
);

-- TASK INSTANCES (belong to a lesson instance and child)
create table if not exists task_instances (
  id text primary key,
  task_template_id text references task_templates(id) on delete set null,
  topic_id text references curriculum_topics(id) on delete set null,
  lesson_instance_id text references lesson_instances(id) on delete set null,
  child_id text references children(id) on delete cascade,
  role text,
  example_root_task_instance_id text references task_instances(id) on delete set null,
  title text,
  style text,
  difficulty integer,
  asset_id text references assets(id) on delete set null,
  answer_type text,
  expected_answer_json jsonb,
  solution_asset_id text references assets(id) on delete set null,
  created_by text,
  created_by_user_id text references users(id) on delete set null,
  status text,
  created_at bigint not null,
  updated_at bigint not null
);

-- TASK ITEM TEMPLATES (belong to a task template)
create table if not exists task_item_templates (
  id text primary key,
  task_template_id text not null references task_templates(id) on delete cascade,
  order_id integer,
  points integer,
  time_limit_ms integer,
  depends_on_id text references task_item_templates(id) on delete set null,
  asset_id text references assets(id) on delete set null,
  question_json jsonb,
  config_json jsonb,
  answer_json jsonb,
  created_at bigint not null
);

create table if not exists task_set_instances (
  id text primary key,
  set_template_id text references task_set_templates(id) on delete set null,
  child_id text not null references children(id) on delete cascade,
  type text,
  title text,
  description text,
  time_limit_ms integer,
  passing_score double precision,
  status text,
  created_by_user_id text references users(id) on delete set null,
  started_at bigint,
  completed_at bigint,
  created_at bigint not null,
  updated_at bigint not null
);

create table if not exists task_set_instance_items (
  id text primary key,
  set_instance_id text not null references task_set_instances(id) on delete cascade,
  task_instance_id text not null references task_instances(id) on delete cascade,
  order_index integer,
  points integer,
  item_time_limit_ms integer,
  depends_on_id text references task_set_instance_items(id) on delete set null,
  question_json jsonb,
  config_json jsonb,
  answer_json jsonb,
  created_at bigint not null
);

create table if not exists task_set_instance_lessons (
  id text primary key,
  set_instance_id text not null references task_set_instances(id) on delete cascade,
  lesson_instance_id text not null references lesson_instances(id) on delete cascade,
  created_at bigint not null
);

-- ATTEMPTS (after instances)
create table if not exists attempts (
  id text primary key,
  child_id text not null references children(id) on delete cascade,
  task_instance_id text not null references task_instances(id) on delete cascade,
  task_set_instance_id text references task_set_instances(id) on delete set null,
  task_set_instance_item_id text references task_set_instance_items(id) on delete set null,
  attempt_client_id text,
  source text,
  answer_asset_id text references assets(id) on delete set null,
  strokes_asset_id text references assets(id) on delete set null,
  score double precision,
  presentation_score double precision,
  correct boolean,
  summary_json jsonb,
  duration_ms integer,
  created_at bigint not null
);
create index if not exists idx_attempts_child on attempts(child_id);

-- PROGRESS & EVENTS
create table if not exists progress (
  id text primary key,
  child_id text not null references children(id) on delete cascade,
  topic_id text not null references curriculum_topics(id) on delete cascade,
  mastery double precision,
  attempts_count integer,
  last_practiced_at bigint,
  history_json jsonb,
  created_at bigint not null,
  updated_at bigint not null
);
create index if not exists idx_progress_child on progress(child_id);

create table if not exists progress_events (
  id text primary key,
  child_id text not null references children(id) on delete cascade,
  topic_id text not null references curriculum_topics(id) on delete cascade,
  attempt_id text references attempts(id) on delete set null,
  reason text not null,
  delta_mastery double precision,
  mastery_after double precision,
  created_at bigint not null
);

-- GENERATION & JOBS
create table if not exists generation_requests (
  id text primary key,
  requested_by_user_id text not null references users(id) on delete cascade,
  target_child_id text references children(id) on delete set null,
  source text not null,
  intent text not null,
  notes text,
  idempotency_key text,
  status text not null,
  created_at bigint not null,
  updated_at bigint not null,
  completed_at bigint
);
create unique index if not exists ux_gen_req_idem on generation_requests(idempotency_key) where idempotency_key is not null;

create table if not exists jobs (
  id text primary key,
  request_id text references generation_requests(id) on delete cascade,
  child_id text references children(id) on delete set null,
  kind text not null,
  status text not null,
  idempotency_key text,
  run_at bigint,
  attempts integer,
  input_asset_id text references assets(id) on delete set null,
  output_asset_id text references assets(id) on delete set null,
  error_asset_id text references assets(id) on delete set null,
  error_code text,
  error_message_redacted text,
  created_at bigint not null,
  updated_at bigint not null
);
create unique index if not exists ux_jobs_idem on jobs(idempotency_key) where idempotency_key is not null;

create table if not exists job_steps (
  id text primary key,
  job_id text not null references jobs(id) on delete cascade,
  step_kind text not null,
  status text not null,
  input_asset_id text references assets(id) on delete set null,
  output_asset_id text references assets(id) on delete set null,
  error_code text,
  error_message_redacted text,
  created_at bigint not null,
  updated_at bigint not null
);

-- Helpful enums (optional): consider CREATE TYPEs for status/kind fields in production
