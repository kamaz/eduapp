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
('ch_fam_b_c1', 'bee1', 'Bella', 'Beta', 'Bella', 'Bella', 'Bell', 'ch_fam_b_c1@internal.local', 'ast_avatar_fam_b_c1', 'en-GB', (EXTRACT(EPOCH FROM TIMESTAMP '2015-09-01')*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
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
INSERT INTO child_profile (id, child_id, created_by_user_id, updated_by_user_id, authored_by_child, persona_role, status, learning_style, profile_summary, sensitivities, created_at, updated_at) VALUES
('cprof_fam_a_c1', 'ch_fam_a_child1', 'usr_fam_a_parent', 'usr_fam_a_parent', false, 'parent', 'active', 'visual', 'Curious and enjoys puzzles.', 'loud_sounds', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_b_c1', 'ch_fam_b_c1', 'usr_fam_b_p1', 'usr_fam_b_p1', false, 'parent', 'active', 'auditory', 'Loves reading aloud.', 'bright_lights', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_b_c2', 'ch_fam_b_c2', 'usr_fam_b_p1', 'usr_fam_b_p1', false, 'parent', 'active', 'kinesthetic', 'Enjoys hands-on activities.', 'none', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_c_c1', 'ch_fam_c_c1', 'usr_fam_c_p1', 'usr_fam_c_p1', false, 'parent', 'active', 'visual', 'Strong interest in art.', 'none', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_d_c1', 'ch_fam_d_c1', 'usr_fam_d_p1', 'usr_fam_d_p1', false, 'parent', 'active', 'auditory', 'Great storyteller.', 'none', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_d_c2', 'ch_fam_d_c2', 'usr_fam_d_p1', 'usr_fam_d_p1', false, 'parent', 'active', 'visual', 'Enjoys drawing.', 'none', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprof_fam_d_c3', 'ch_fam_d_c3', 'usr_fam_d_p1', 'usr_fam_d_p1', false, 'parent', 'active', 'kinesthetic', 'Likes building blocks.', 'none', (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- Child profile items
INSERT INTO child_profile_items (id, profile_id, type, value, created_at) VALUES
('cprofitem_fam_a_c1_interest1', 'cprof_fam_a_c1', 'interest', 'puzzles', (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c1_book1', 'cprof_fam_b_c1', 'book', 'The Gruffalo', (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_b_c2_game1', 'cprof_fam_b_c2', 'game', 'LEGO', (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_c_c1_movie1', 'cprof_fam_c_c1', 'movie', 'Coco', (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cprofitem_fam_d_c3_interest1', 'cprof_fam_d_c3', 'interest', 'animals', (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

-- Child observations
INSERT INTO child_observations (id, child_id, user_id, note_type, body, status, superseded_by_observation_id, created_at, updated_at) VALUES
('cobs_fam_a_c1_1', 'ch_fam_a_child1', 'usr_fam_a_parent', 'observation', 'Enjoyed today''s reading task.', 'active', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_b_c1_1', 'ch_fam_b_c1', 'usr_fam_b_p1', 'observation', 'Did well with phonics.', 'active', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_b_c2_1', 'ch_fam_b_c2', 'usr_fam_b_p1', 'observation', 'Struggled with focus after 20 minutes.', 'active', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_c_c1_1', 'ch_fam_c_c1', 'usr_fam_c_p1', 'observation', 'Loved the art worksheet.', 'active', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cobs_fam_d_c1_1', 'ch_fam_d_c1', 'usr_fam_d_p1', 'observation', 'Great progress with numbers.', 'active', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;
