-- Seed: Demo Families (PostgreSQL)
-- Dependencies: subscription_plans, consent_policies must be seeded first.
SET search_path=eduapp,public;
-- FAMILY A: Single parent + 1 child, paid (basic_monthly)
INSERT INTO users (id, firebase_uid, email, display_name, billing_customer_id, settings_json, created_at, updated_at)
VALUES ('usr_fam_a_parent', 'fb_fam_a_parent', 'parentA@example.com', 'Parent A', 'cus_fam_a', NULL, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;

INSERT INTO children (id, primary_parent_user_id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob_year, dob_month, created_at, updated_at)
VALUES ('ch_fam_a_child1', 'usr_fam_a_parent', 'littleA', 'Alex', 'Alpha', 'Alex', 'Alex', 'Lex', NULL, NULL, 'en-GB', 2016, 5, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
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

INSERT INTO children (id, primary_parent_user_id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob_year, dob_month, created_at, updated_at) VALUES
('ch_fam_b_c1', 'usr_fam_b_p1', 'bee1', 'Bella', 'Beta', 'Bella', 'Bella', NULL, NULL, NULL, 'en-GB', 2015, 9, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ch_fam_b_c2', 'usr_fam_b_p1', 'bee2', 'Ben', 'Beta', 'Ben', 'Ben', NULL, NULL, NULL, 'en-GB', 2018, 3, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
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

INSERT INTO children (id, primary_parent_user_id, alias, given_name, family_name, preferred_name, short_name, locale, dob_year, dob_month, created_at, updated_at)
VALUES ('ch_fam_c_c1', 'usr_fam_c_p1', 'charlie', 'Chris', 'Gamma', 'Chris', 'Chris', 'en-GB', 2014, 7, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
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

INSERT INTO children (id, primary_parent_user_id, alias, given_name, family_name, preferred_name, short_name, locale, dob_year, dob_month, created_at, updated_at) VALUES
('ch_fam_d_c1', 'usr_fam_d_p1', 'delta1', 'Dina', 'Delta', 'Dina', 'Dina', 'en-GB', 2013, 2, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ch_fam_d_c2', 'usr_fam_d_p1', 'delta2', 'Dan', 'Delta', 'Dan', 'Dan', 'en-GB', 2016, 6, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('ch_fam_d_c3', 'usr_fam_d_p1', 'delta3', 'Daisy', 'Delta', 'Daisy', 'Daisy', 'en-GB', 2019, 11, (EXTRACT(EPOCH FROM NOW())*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
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
