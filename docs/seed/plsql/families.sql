-- Seed: Demo Families (PostgreSQL)
-- Dependencies: subscription_plans, consent_policies must be seeded first.
SET search_path=eduapp,public;
-- FAMILY A: Single parent + 1 child, paid (basic_monthly)
INSERT INTO users (id, firebase_uid, email, display_name, billing_customer_id, settings_json, created_at, updated_at)
VALUES ('usr_fam_a_parent', 'fb_fam_a_parent', 'parentA@example.com', 'Parent A', 'cus_fam_a', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- Avatar for Family A child
INSERT INTO assets (id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at)
VALUES ('ast_avatar_fam_a_c1', 'avatar', 'avatars', 'seed/fam_a_c1.png', 'image/png', NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO children (id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob, created_at, updated_at)
VALUES ('ch_fam_a_child1', 'littleA', 'Alex', 'Alpha', 'Alex', 'Alex', 'Lex', 'ch_fam_a_child1@internal.local', 'ast_avatar_fam_a_c1', 'en-GB', (EXTRACT(EPOCH FROM TIMESTAMP '2016-05-01')*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO child_access (id, child_id, user_id, persona_role, access_level, is_primary_parent, invited_by_user_id, revoked_at, created_at, updated_at)
VALUES ('cacc_fam_a_pa_c1', 'ch_fam_a_child1', 'usr_fam_a_parent', 'parent', 'parent', true, NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO user_subscriptions (id, user_id, provider, provider_customer_id, provider_subscription_id, plan_id, status, current_period_end, cancel_at_period_end, created_at, updated_at)
VALUES ('subs_fam_a', 'usr_fam_a_parent', 'stripe', 'cus_fam_a', 'sub_fam_a_basic', 'plan_basic_monthly', 'active', (EXTRACT(EPOCH FROM NOW() + INTERVAL '30 days')*1000)::bigint, false, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- Consents (ToS v2 and Privacy v2) for parent
INSERT INTO user_consents (id, user_id, policy_id, group_key, version, accepted_at, created_at, updated_at) VALUES
('ucon_fam_a_parent_tos', 'usr_fam_a_parent', 'cpol_tos_v2', 'terms_of_service', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_a_parent_priv', 'usr_fam_a_parent', 'cpol_privacy_v2', 'privacy_policy', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- FAMILY B: Two parents + 2 children, free plan
INSERT INTO users (id, firebase_uid, email, display_name, billing_customer_id, settings_json, created_at, updated_at)
VALUES ('usr_fam_b_p1', 'fb_fam_b_p1', 'p1B@example.com', 'P1 B', NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;
INSERT INTO users (id, firebase_uid, email, display_name, billing_customer_id, settings_json, created_at, updated_at)
VALUES ('usr_fam_b_p2', 'fb_fam_b_p2', 'p2B@example.com', 'P2 B', NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- Avatars for Family B children
INSERT INTO assets (id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at) VALUES
('ast_avatar_fam_b_c1', 'avatar', 'avatars', 'seed/fam_b_c1.png', 'image/png', NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ast_avatar_fam_b_c2', 'avatar', 'avatars', 'seed/fam_b_c2.png', 'image/png', NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO children (id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob, created_at, updated_at) VALUES
('ch_fam_b_c1', 'bee1', 'Bella', 'Beta', 'Bella', 'Bella', 'Bell', 'ch_fam_b_c1@internal.local', 'ast_avatar_fam_b_c1', 'en-GB', (EXTRACT(EPOCH FROM TIMESTAMP '2016-09-01')*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ch_fam_b_c2', 'bee2', 'Ben', 'Beta', 'Ben', 'Ben', 'Benny', 'ch_fam_b_c2@internal.local', 'ast_avatar_fam_b_c2', 'en-GB', (EXTRACT(EPOCH FROM TIMESTAMP '2018-03-01')*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO child_access (id, child_id, user_id, persona_role, access_level, is_primary_parent, invited_by_user_id, revoked_at, created_at, updated_at) VALUES
('cacc_fam_b_p1_c1', 'ch_fam_b_c1', 'usr_fam_b_p1', 'parent', 'parent', true, NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_b_p1_c2', 'ch_fam_b_c2', 'usr_fam_b_p1', 'parent', 'parent', true, NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_b_p2_c1', 'ch_fam_b_c1', 'usr_fam_b_p2', 'parent', 'parent', false, 'usr_fam_b_p1', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_b_p2_c2', 'ch_fam_b_c2', 'usr_fam_b_p2', 'parent', 'parent', false, 'usr_fam_b_p1', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO user_subscriptions (id, user_id, provider, provider_customer_id, provider_subscription_id, plan_id, status, current_period_end, cancel_at_period_end, created_at, updated_at) VALUES
('subs_fam_b', 'usr_fam_b_p1', 'stripe', 'cus_fam_b', 'sub_fam_b_free', 'plan_free', 'active', (EXTRACT(EPOCH FROM NOW() + INTERVAL '365 days')*1000)::bigint, false, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO user_consents (id, user_id, policy_id, group_key, version, accepted_at, created_at, updated_at) VALUES
('ucon_fam_b_p1_tos', 'usr_fam_b_p1', 'cpol_tos_v2', 'terms_of_service', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_b_p1_priv', 'usr_fam_b_p1', 'cpol_privacy_v2', 'privacy_policy', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_b_p2_tos', 'usr_fam_b_p2', 'cpol_tos_v2', 'terms_of_service', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_b_p2_priv', 'usr_fam_b_p2', 'cpol_privacy_v2', 'privacy_policy', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- FAMILY C: Two parents + two grandparents + 1 child, paid (family_monthly)
INSERT INTO users (id, firebase_uid, email, display_name, created_at, updated_at)
VALUES ('usr_fam_c_p1', 'fb_fam_c_p1', 'p1C@example.com', 'P1 C', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;
INSERT INTO users (id, firebase_uid, email, display_name, created_at, updated_at)
VALUES ('usr_fam_c_p2', 'fb_fam_c_p2', 'p2C@example.com', 'P2 C', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;
INSERT INTO users (id, firebase_uid, email, display_name, created_at, updated_at)
VALUES ('usr_fam_c_gp1', 'fb_fam_c_gp1', 'gp1C@example.com', 'GP1 C', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;
INSERT INTO users (id, firebase_uid, email, display_name, created_at, updated_at)
VALUES ('usr_fam_c_gp2', 'fb_fam_c_gp2', 'gp2C@example.com', 'GP2 C', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- Avatar for Family C child
INSERT INTO assets (id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at)
VALUES ('ast_avatar_fam_c_c1', 'avatar', 'avatars', 'seed/fam_c_c1.png', 'image/png', NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO children (id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob, created_at, updated_at)
VALUES ('ch_fam_c_c1', 'charlie', 'Chris', 'Gamma', 'Chris', 'Chris', 'CJ', 'ch_fam_c_c1@internal.local', 'ast_avatar_fam_c_c1', 'en-GB', (EXTRACT(EPOCH FROM TIMESTAMP '2014-07-01')*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO child_access (id, child_id, user_id, persona_role, access_level, is_primary_parent, invited_by_user_id, created_at, updated_at) VALUES
('cacc_fam_c_p1_c1', 'ch_fam_c_c1', 'usr_fam_c_p1', 'parent', 'parent', true, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_c_p2_c1', 'ch_fam_c_c1', 'usr_fam_c_p2', 'parent', 'parent', false, 'usr_fam_c_p1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_c_gp1_c1', 'ch_fam_c_c1', 'usr_fam_c_gp1', 'grandparent', 'family', false, 'usr_fam_c_p1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_c_gp2_c1', 'ch_fam_c_c1', 'usr_fam_c_gp2', 'grandparent', 'family', false, 'usr_fam_c_p1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO user_subscriptions (id, user_id, provider, provider_customer_id, provider_subscription_id, plan_id, status, current_period_end, cancel_at_period_end, created_at, updated_at)
VALUES ('subs_fam_c', 'usr_fam_c_p1', 'stripe', 'cus_fam_c', 'sub_fam_c_family', 'plan_family_monthly', 'active', (EXTRACT(EPOCH FROM NOW() + INTERVAL '30 days')*1000)::bigint, false, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO user_consents (id, user_id, policy_id, group_key, version, accepted_at, created_at, updated_at) VALUES
('ucon_fam_c_p1_tos', 'usr_fam_c_p1', 'cpol_tos_v2', 'terms_of_service', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_c_p1_priv', 'usr_fam_c_p1', 'cpol_privacy_v2', 'privacy_policy', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_c_p2_tos', 'usr_fam_c_p2', 'cpol_tos_v2', 'terms_of_service', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_c_p2_priv', 'usr_fam_c_p2', 'cpol_privacy_v2', 'privacy_policy', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_c_gp1_tos', 'usr_fam_c_gp1', 'cpol_tos_v2', 'terms_of_service', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_c_gp1_priv', 'usr_fam_c_gp1', 'cpol_privacy_v2', 'privacy_policy', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_c_gp2_tos', 'usr_fam_c_gp2', 'cpol_tos_v2', 'terms_of_service', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_c_gp2_priv', 'usr_fam_c_gp2', 'cpol_privacy_v2', 'privacy_policy', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- FAMILY D: Two parents + 3 children, free plan
INSERT INTO users (id, firebase_uid, email, display_name, created_at, updated_at)
VALUES ('usr_fam_d_p1', 'fb_fam_d_p1', 'p1D@example.com', 'P1 D', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;
INSERT INTO users (id, firebase_uid, email, display_name, created_at, updated_at)
VALUES ('usr_fam_d_p2', 'fb_fam_d_p2', 'p2D@example.com', 'P2 D', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- Avatars for Family D children
INSERT INTO assets (id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at) VALUES
('ast_avatar_fam_d_c1', 'avatar', 'avatars', 'seed/fam_d_c1.png', 'image/png', NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ast_avatar_fam_d_c2', 'avatar', 'avatars', 'seed/fam_d_c2.png', 'image/png', NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ast_avatar_fam_d_c3', 'avatar', 'avatars', 'seed/fam_d_c3.png', 'image/png', NULL, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO children (id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob, created_at, updated_at) VALUES
('ch_fam_d_c1', 'delta1', 'Dina', 'Delta', 'Dina', 'Dina', 'Dee', 'ch_fam_d_c1@internal.local', 'ast_avatar_fam_d_c1', 'en-GB', (EXTRACT(EPOCH FROM TIMESTAMP '2013-02-01')*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ch_fam_d_c2', 'delta2', 'Dan', 'Delta', 'Dan', 'Dan', 'Danny', 'ch_fam_d_c2@internal.local', 'ast_avatar_fam_d_c2', 'en-GB', (EXTRACT(EPOCH FROM TIMESTAMP '2016-06-01')*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ch_fam_d_c3', 'delta3', 'Daisy', 'Delta', 'Daisy', 'Daisy', 'Day', 'ch_fam_d_c3@internal.local', 'ast_avatar_fam_d_c3', 'en-GB', (EXTRACT(EPOCH FROM TIMESTAMP '2019-11-01')*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO child_access (id, child_id, user_id, persona_role, access_level, is_primary_parent, invited_by_user_id, created_at, updated_at) VALUES
('cacc_fam_d_p1_c1', 'ch_fam_d_c1', 'usr_fam_d_p1', 'parent', 'parent', true, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_d_p1_c2', 'ch_fam_d_c2', 'usr_fam_d_p1', 'parent', 'parent', true, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_d_p1_c3', 'ch_fam_d_c3', 'usr_fam_d_p1', 'parent', 'parent', true, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_d_p2_c1', 'ch_fam_d_c1', 'usr_fam_d_p2', 'parent', 'parent', false, 'usr_fam_d_p1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_d_p2_c2', 'ch_fam_d_c2', 'usr_fam_d_p2', 'parent', 'parent', false, 'usr_fam_d_p1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cacc_fam_d_p2_c3', 'ch_fam_d_c3', 'usr_fam_d_p2', 'parent', 'parent', false, 'usr_fam_d_p1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO user_subscriptions (id, user_id, provider, provider_customer_id, provider_subscription_id, plan_id, status, current_period_end, cancel_at_period_end, created_at, updated_at)
VALUES ('subs_fam_d', 'usr_fam_d_p1', 'stripe', 'cus_fam_d', 'sub_fam_d_free', 'plan_free', 'active', (EXTRACT(EPOCH FROM NOW() + INTERVAL '365 days')*1000)::bigint, false, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO user_consents (id, user_id, policy_id, group_key, version, accepted_at, created_at, updated_at) VALUES
('ucon_fam_d_p1_tos', 'usr_fam_d_p1', 'cpol_tos_v2', 'terms_of_service', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_d_p1_priv', 'usr_fam_d_p1', 'cpol_privacy_v2', 'privacy_policy', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_d_p2_tos', 'usr_fam_d_p2', 'cpol_tos_v2', 'terms_of_service', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ucon_fam_d_p2_priv', 'usr_fam_d_p2', 'cpol_privacy_v2', 'privacy_policy', 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- Access requests
INSERT INTO access_requests (id, requester_user_id, target_parent_user_id, target_child_id, target_parent_email, desired_persona_role, desired_access_level, status, token, expires_at, message, created_at, updated_at, acted_at, acted_by_user_id) VALUES
('areq_fam_b_p2_to_p1', 'usr_fam_b_p2', 'usr_fam_b_p1', 'ch_fam_b_c1', 'p1B@example.com', 'parent', 'parent', 'approved', 'tok_ar_fam_b_p2', (EXTRACT(EPOCH FROM NOW() + INTERVAL '7 days')*1000)::bigint, 'Request access to child c1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, 'usr_fam_b_p1')
ON CONFLICT (id) DO NOTHING;
INSERT INTO access_requests (id, requester_user_id, target_parent_user_id, target_child_id, target_parent_email, desired_persona_role, desired_access_level, status, token, expires_at, message, created_at, updated_at, acted_at, acted_by_user_id) VALUES
('areq_fam_c_gp2_to_p1', 'usr_fam_c_gp2', 'usr_fam_c_p1', 'ch_fam_c_c1', 'p1C@example.com', 'grandparent', 'family', 'pending', 'tok_ar_fam_c_gp2', (EXTRACT(EPOCH FROM NOW() + INTERVAL '7 days')*1000)::bigint, 'Grandparent access request to child c1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, NULL, NULL)
ON CONFLICT (id) DO NOTHING;

-- Child profiles (created by primary parent)
INSERT INTO child_profile (id, child_id, created_by_user_id, updated_by_user_id, authored_by_child, persona_role, status, learning_style, profile_summary, sensitivities, profile_summary_tags_json, sensitivities_tags_json, created_at, updated_at) VALUES
('cprof_fam_a_c1', 'ch_fam_a_child1', 'usr_fam_a_parent', 'usr_fam_a_parent', false, 'parent', 'active', 'visual', 'Curious, enjoys solving step-by-step puzzles and explaining how they worked. Tends to stay engaged when activities mix pictures with short bits of text.', 'Sensitive to loud sounds in busy environments.', '["visual","puzzles","step_by_step"]'::jsonb, '["loud_sounds"]'::jsonb, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_b_c1', 'ch_fam_b_c1', 'usr_fam_b_p1', 'usr_fam_b_p1', false, 'parent', 'active', 'auditory', 'Loves reading stories aloud and listening to audiobooks. Often asks to re-read favourite chapters and enjoys acting out characters with voices.', 'Bright screens in the evening can make it harder to wind down.', '["auditory","stories_aloud","audiobooks"]'::jsonb, '["bright_screens_evening"]'::jsonb, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_b_c2', 'ch_fam_b_c2', 'usr_fam_b_p1', 'usr_fam_b_p1', false, 'parent', 'active', 'kinesthetic', 'Very active and focused when tasks involve moving pieces or building things. Prefers short, hands-on activities over long written exercises.', 'Finds it uncomfortable to sit still for long periods without a break.', '["kinesthetic","hands_on","short_activities"]'::jsonb, '["long_sitting"]'::jsonb, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_c_c1', 'ch_fam_c_c1', 'usr_fam_c_p1', 'usr_fam_c_p1', false, 'parent', 'active', 'visual', 'Strong interest in drawing and colour. Stays motivated when tasks include space to sketch or label pictures.', 'Can feel overwhelmed if given too many instructions at once.', '["visual","art","drawing"]'::jsonb, '["too_many_instructions"]'::jsonb, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_d_c1', 'ch_fam_d_c1', 'usr_fam_d_p1', 'usr_fam_d_p1', false, 'parent', 'active', 'auditory', 'Great storyteller who enjoys explaining ideas out loud before writing. Responds well to gentle prompts and open-ended questions.', 'Struggles to concentrate when there is a lot of background noise.', '["auditory","storytelling","verbal_explanation"]'::jsonb, '["background_noise"]'::jsonb, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_d_c2', 'ch_fam_d_c2', 'usr_fam_d_p1', 'usr_fam_d_p1', false, 'parent', 'active', 'visual', 'Enjoys drawing and matching pictures to words. Benefits from seeing complete examples before trying tasks independently.', 'Gets frustrated if rushed to finish quickly without thinking time.', '["visual","examples","matching_pictures"]'::jsonb, '["being_rushed"]'::jsonb, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_d_c3', 'ch_fam_d_c3', 'usr_fam_d_p1', 'usr_fam_d_p1', false, 'parent', 'active', 'kinesthetic', 'Likes building blocks and turning learning into games. Stays positive with quick feedback and chances to try again.', 'Finds long quiet tasks tiring without short active breaks.', '["kinesthetic","games","building"]'::jsonb, '["long_quiet_tasks"]'::jsonb, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
-- Example profiles authored from the child perspective (under supervision)
('cprof_fam_a_c1_child_voice', 'ch_fam_a_child1', 'usr_fam_a_parent', 'usr_fam_a_parent', true, 'parent', 'draft', 'visual', 'I like working things out step by step and seeing pictures that show me what is happening.', 'I do not like it when it is very noisy or when I have to rush and skip steps.', '["visual","step_by_step","pictures"]'::jsonb, '["noise","rushing"]'::jsonb, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_b_c1_child_voice', 'ch_fam_b_c1', 'usr_fam_b_p1', 'usr_fam_b_p1', true, 'parent', 'draft', 'auditory', 'I like reading funny stories out loud and playing word games where I can make up silly sentences.', 'I do not like when work feels like a test and I only get told what I did wrong.', '["auditory","funny_stories","word_games"]'::jsonb, '["test_like_tasks","negative_feedback_only"]'::jsonb, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_b_c2_child_voice', 'ch_fam_b_c2', 'usr_fam_b_p1', 'usr_fam_b_p1', true, 'parent', 'draft', 'kinesthetic', 'I like moving around, building things, and using blocks to show my answers.', 'I do not like sitting still for a long time just writing on the page.', '["kinesthetic","building","moving_around"]'::jsonb, '["long_writing","long_sitting"]'::jsonb, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- Child profile items (what works well and what does not)
INSERT INTO child_profile_items (id, profile_id, type, value, description, preference, tags_json, resource_url, created_at) VALUES
('cprofitem_fam_a_c1_interest1', 'cprof_fam_a_c1', 'interest', 'Puzzles and logic games', 'Enjoys jigsaw puzzles, number patterns, and code-breaking style tasks where there is a clear goal to reach.', 'like', '["puzzles","logic","games"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_a_c1_activity_dislike1', 'cprof_fam_a_c1', 'activity', 'Long timed quizzes', 'Finds long timed quizzes stressful and tends to rush, leading to mistakes.', 'dislike', '["quiz","timed","stressful"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_a_c1_child_voice_activity1', 'cprof_fam_a_c1_child_voice', 'activity', 'Picture step-by-step tasks', 'I like activities where I can look at each picture and tell what happens next in order.', 'like', '["pictures","step_by_step","story_sequence"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_a_c1_child_voice_activity2', 'cprof_fam_a_c1_child_voice', 'activity', 'Quiet puzzle time', 'I like it when I can focus on a puzzle in a quiet place without lots of noise.', 'like', '["quiet","puzzles","focus"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c1_book1', 'cprof_fam_b_c1', 'book', 'The Gruffalo', 'Frequently chooses this book at bedtime and enjoys predicting what will happen on the next page.', 'like', '["book","bedtime","favourite"]'::jsonb, 'https://en.wikipedia.org/wiki/The_Gruffalo', (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c1_book2', 'cprof_fam_b_c1', 'book', 'Funny poetry collection', 'Enjoys short, funny poems that can be read aloud with different voices.', 'like', '["book","poetry","humour"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c1_movie1', 'cprof_fam_b_c1', 'movie', 'Animated animal film', 'Likes light-hearted animated films with talking animals and clear storylines.', 'like', '["movie","animated","animals"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c1_activity_pos1', 'cprof_fam_b_c1', 'activity', 'Acting out stories', 'Enjoys acting out scenes from stories with simple props and voices.', 'like', '["role_play","stories","acting"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c1_activity_neg1', 'cprof_fam_b_c1', 'activity', 'Long silent reading tests', 'Finds it hard to stay motivated in long silent reading tests without any discussion.', 'dislike', '["tests","silent_reading","long_tasks"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c1_activity_neg2', 'cprof_fam_b_c1', 'activity', 'Tiny print passages', 'Struggles when the text is very small or crowded on the page.', 'dislike', '["tiny_print","visual_load"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c1_child_voice_game1', 'cprof_fam_b_c1_child_voice', 'game', 'Silly word games', 'I like making up silly rhymes or nonsense sentences and reading them in funny voices.', 'like', '["game","words","rhymes"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c1_child_voice_activity1', 'cprof_fam_b_c1_child_voice', 'activity', 'Reading aloud to someone', 'I like reading stories out loud to someone who listens and laughs with me.', 'like', '["reading_aloud","audience","stories"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c1_child_voice_activity2', 'cprof_fam_b_c1_child_voice', 'activity', 'Surprise test pages', 'I do not like when new pages suddenly feel like a test with lots of hard questions.', 'dislike', '["tests","surprise","hard_questions"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c2_game1', 'cprof_fam_b_c2', 'game', 'LEGO build challenges', 'Stays focused when asked to build specific shapes or scenes related to the current topic.', 'like', '["lego","building","challenges"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c2_activity_dislike1', 'cprof_fam_b_c2', 'activity', 'Copying sentences from the board', 'Loses interest quickly when asked to repeatedly copy text without interaction or movement.', 'dislike', '["copying","board","low_engagement"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c2_child_voice_activity1', 'cprof_fam_b_c2_child_voice', 'activity', 'Build then write', 'I like when I can build the answer with blocks first and then write it down afterwards.', 'like', '["build_first","then_write","blocks"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c2_child_voice_activity2', 'cprof_fam_b_c2_child_voice', 'activity', 'Long quiet writing time', 'I do not like long quiet writing time without any chance to move.', 'dislike', '["long_writing","little_movement"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_c_c1_movie1', 'cprof_fam_c_c1', 'movie', 'Coco', 'Talks about the colours and music after watching and enjoys drawing characters from the film.', 'like', '["movie","music","colourful"]'::jsonb, 'https://en.wikipedia.org/wiki/Coco_(2017_film)', (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_d_c3_interest1', 'cprof_fam_d_c3', 'interest', 'Animals and nature walks', 'Enjoys activities that involve animals, nature facts, or outdoor scavenger hunts linked to learning topics.', 'like', '["animals","nature","outdoors"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_d_c3_activity_dislike1', 'cprof_fam_d_c3', 'activity', 'Large unstructured worksheets', 'Feels lost when given very large worksheets without clear steps or small goals.', 'dislike', '["worksheets","unstructured","overwhelming"]'::jsonb, NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- Child observations (richer notes + AI feedback for parents)
INSERT INTO child_observations (id, child_id, user_id, note_type, body, status, superseded_by_observation_id, created_at, updated_at) VALUES
('cobs_fam_a_c1_1', 'ch_fam_a_child1', 'usr_fam_a_parent', 'observation', 'Parent note: Alex stayed engaged with today''s reading puzzle when we broke the story into short sections and used the pictures to guess what might happen next.', 'active', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_a_c1_ai_1', 'ch_fam_a_child1', 'usr_fam_a_parent', 'ai_feedback', 'AI feedback for parent: Alex showed strong understanding when matching pictures to short sentences but needed more time on unfamiliar words. Try re-reading the same story tomorrow and ask Alex to explain tricky words in their own words, then link them to a quick drawing or gesture.', 'active', 'cobs_fam_a_c1_1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_b_c1_1', 'ch_fam_b_c1', 'usr_fam_b_p1', 'observation', 'Parent note: Really enjoyed reading aloud and acting out characters. Needed a reminder to slow down on longer words.', 'active', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_b_c1_ai_1', 'ch_fam_b_c1', 'usr_fam_b_p1', 'ai_feedback', 'AI feedback for parent: Reading accuracy improved when Bella read shorter sections and paused to summarise. Next time, invite her to record herself reading a favourite paragraph, then listen back together and highlight one word to practise.', 'active', 'cobs_fam_b_c1_1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_b_c2_1', 'ch_fam_b_c2', 'usr_fam_b_p1', 'observation', 'Parent note: Started the maths worksheet with good focus but found it hard to stay seated after about 20 minutes. A short movement break helped.', 'active', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_b_c2_ai_1', 'ch_fam_b_c2', 'usr_fam_b_p1', 'ai_feedback', 'AI feedback for parent: Ben stays engaged when activities alternate between writing and moving pieces. For the next session, try using physical objects (e.g. blocks or counters) for the first few questions, then gradually transition to written problems.', 'active', 'cobs_fam_b_c2_1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_c_c1_1', 'ch_fam_c_c1', 'usr_fam_c_p1', 'observation', 'Parent note: Loved the art worksheet and spent extra time colouring and adding small details to the drawings.', 'active', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_c_c1_ai_1', 'ch_fam_c_c1', 'usr_fam_c_p1', 'ai_feedback', 'AI feedback for parent: This child responds well when tasks allow for creativity. To deepen learning, ask them to label their drawings with key words from the lesson and explain each one in a short sentence.', 'active', 'cobs_fam_c_c1_1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_d_c1_1', 'ch_fam_d_c1', 'usr_fam_d_p1', 'observation', 'Parent note: Showed great progress with numbers when allowed to talk through each step of the problem out loud first.', 'active', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_d_c1_ai_1', 'ch_fam_d_c1', 'usr_fam_d_p1', 'ai_feedback', 'AI feedback for parent: Dina benefits from explaining her thinking verbally. For the next activity, encourage her to use simple sentence starters like "First I..." and "Then I..." while solving, and write down one of her explanations together afterwards.', 'active', 'cobs_fam_d_c1_1', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;
