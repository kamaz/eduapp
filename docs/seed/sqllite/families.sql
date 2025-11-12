-- Seed: Demo Families (SQLite)
PRAGMA foreign_keys = ON;

-- Helper timestamps (inline via strftime)

-- FAMILY A: Single parent + 1 child, paid (basic_monthly)
INSERT OR IGNORE INTO users (id, firebase_uid, email, display_name, billing_customer_id, settings_json, created_at, updated_at) VALUES
('usr_fam_a_parent', 'fb_fam_a_parent', 'parentA@example.com', 'Parent A', 'cus_fam_a', NULL, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO children (id, primary_parent_user_id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob_year, dob_month, created_at, updated_at) VALUES
('ch_fam_a_child1', 'usr_fam_a_parent', 'littleA', 'Alex', 'Alpha', 'Alex', 'Alex', 'Lex', NULL, NULL, 'en-GB', 2016, 5, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO child_access (id, child_id, user_id, persona_role, access_level, is_primary_parent, invited_by_user_id, revoked_at, created_at, updated_at) VALUES
('cacc_fam_a_pa_c1', 'ch_fam_a_child1', 'usr_fam_a_parent', 'parent', 'parent', 1, NULL, NULL, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO user_subscriptions (id, user_id, provider, provider_customer_id, provider_subscription_id, plan_id, status, current_period_end, cancel_at_period_end, created_at, updated_at) VALUES
('subs_fam_a', 'usr_fam_a_parent', 'stripe', 'cus_fam_a', 'sub_fam_a_basic', 'plan_basic_monthly', 'active', (strftime('%s','now','+30 days')*1000), 0, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO user_consents (id, user_id, policy_id, group_key, version, accepted_at, created_at, updated_at) VALUES
('ucon_fam_a_parent_tos', 'usr_fam_a_parent', 'cpol_tos_v2', 'terms_of_service', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_a_parent_priv', 'usr_fam_a_parent', 'cpol_privacy_v2', 'privacy_policy', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000);

-- FAMILY B: Two parents + 2 children, free plan
INSERT OR IGNORE INTO users (id, firebase_uid, email, display_name, created_at, updated_at) VALUES
('usr_fam_b_p1', 'fb_fam_b_p1', 'p1B@example.com', 'P1 B', strftime('%s','now')*1000, strftime('%s','now')*1000),
('usr_fam_b_p2', 'fb_fam_b_p2', 'p2B@example.com', 'P2 B', strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO children (id, primary_parent_user_id, alias, given_name, family_name, preferred_name, short_name, locale, dob_year, dob_month, created_at, updated_at) VALUES
('ch_fam_b_c1', 'usr_fam_b_p1', 'bee1', 'Bella', 'Beta', 'Bella', 'Bella', 'en-GB', 2015, 9, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ch_fam_b_c2', 'usr_fam_b_p1', 'bee2', 'Ben', 'Beta', 'Ben', 'Ben', 'en-GB', 2018, 3, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO child_access (id, child_id, user_id, persona_role, access_level, is_primary_parent, invited_by_user_id, created_at, updated_at) VALUES
('cacc_fam_b_p1_c1', 'ch_fam_b_c1', 'usr_fam_b_p1', 'parent', 'parent', 1, NULL, strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_b_p1_c2', 'ch_fam_b_c2', 'usr_fam_b_p1', 'parent', 'parent', 1, NULL, strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_b_p2_c1', 'ch_fam_b_c1', 'usr_fam_b_p2', 'parent', 'parent', 0, 'usr_fam_b_p1', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_b_p2_c2', 'ch_fam_b_c2', 'usr_fam_b_p2', 'parent', 'parent', 0, 'usr_fam_b_p1', strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO user_subscriptions (id, user_id, provider, provider_customer_id, provider_subscription_id, plan_id, status, current_period_end, cancel_at_period_end, created_at, updated_at) VALUES
('subs_fam_b', 'usr_fam_b_p1', 'stripe', 'cus_fam_b', 'sub_fam_b_free', 'plan_free', 'active', (strftime('%s','now','+365 days')*1000), 0, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO user_consents (id, user_id, policy_id, group_key, version, accepted_at, created_at, updated_at) VALUES
('ucon_fam_b_p1_tos', 'usr_fam_b_p1', 'cpol_tos_v2', 'terms_of_service', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_b_p1_priv', 'usr_fam_b_p1', 'cpol_privacy_v2', 'privacy_policy', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_b_p2_tos', 'usr_fam_b_p2', 'cpol_tos_v2', 'terms_of_service', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_b_p2_priv', 'usr_fam_b_p2', 'cpol_privacy_v2', 'privacy_policy', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000);

-- FAMILY C: Two parents + two grandparents + 1 child, paid (family_monthly)
INSERT OR IGNORE INTO users (id, firebase_uid, email, display_name, created_at, updated_at) VALUES
('usr_fam_c_p1', 'fb_fam_c_p1', 'p1C@example.com', 'P1 C', strftime('%s','now')*1000, strftime('%s','now')*1000),
('usr_fam_c_p2', 'fb_fam_c_p2', 'p2C@example.com', 'P2 C', strftime('%s','now')*1000, strftime('%s','now')*1000),
('usr_fam_c_gp1', 'fb_fam_c_gp1', 'gp1C@example.com', 'GP1 C', strftime('%s','now')*1000, strftime('%s','now')*1000),
('usr_fam_c_gp2', 'fb_fam_c_gp2', 'gp2C@example.com', 'GP2 C', strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO children (id, primary_parent_user_id, alias, given_name, family_name, preferred_name, short_name, locale, dob_year, dob_month, created_at, updated_at) VALUES
('ch_fam_c_c1', 'usr_fam_c_p1', 'charlie', 'Chris', 'Gamma', 'Chris', 'Chris', 'en-GB', 2014, 7, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO child_access (id, child_id, user_id, persona_role, access_level, is_primary_parent, invited_by_user_id, created_at, updated_at) VALUES
('cacc_fam_c_p1_c1', 'ch_fam_c_c1', 'usr_fam_c_p1', 'parent', 'parent', 1, NULL, strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_c_p2_c1', 'ch_fam_c_c1', 'usr_fam_c_p2', 'parent', 'parent', 0, 'usr_fam_c_p1', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_c_gp1_c1', 'ch_fam_c_c1', 'usr_fam_c_gp1', 'grandparent', 'family', 0, 'usr_fam_c_p1', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_c_gp2_c1', 'ch_fam_c_c1', 'usr_fam_c_gp2', 'grandparent', 'family', 0, 'usr_fam_c_p1', strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO user_subscriptions (id, user_id, provider, provider_customer_id, provider_subscription_id, plan_id, status, current_period_end, cancel_at_period_end, created_at, updated_at) VALUES
('subs_fam_c', 'usr_fam_c_p1', 'stripe', 'cus_fam_c', 'sub_fam_c_family', 'plan_family_monthly', 'active', (strftime('%s','now','+30 days')*1000), 0, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO user_consents (id, user_id, policy_id, group_key, version, accepted_at, created_at, updated_at) VALUES
('ucon_fam_c_p1_tos', 'usr_fam_c_p1', 'cpol_tos_v2', 'terms_of_service', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_c_p1_priv', 'usr_fam_c_p1', 'cpol_privacy_v2', 'privacy_policy', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_c_p2_tos', 'usr_fam_c_p2', 'cpol_tos_v2', 'terms_of_service', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_c_p2_priv', 'usr_fam_c_p2', 'cpol_privacy_v2', 'privacy_policy', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_c_gp1_tos', 'usr_fam_c_gp1', 'cpol_tos_v2', 'terms_of_service', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_c_gp1_priv', 'usr_fam_c_gp1', 'cpol_privacy_v2', 'privacy_policy', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_c_gp2_tos', 'usr_fam_c_gp2', 'cpol_tos_v2', 'terms_of_service', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_c_gp2_priv', 'usr_fam_c_gp2', 'cpol_privacy_v2', 'privacy_policy', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000);

-- FAMILY D: Two parents + 3 children, free plan
INSERT OR IGNORE INTO users (id, firebase_uid, email, display_name, created_at, updated_at) VALUES
('usr_fam_d_p1', 'fb_fam_d_p1', 'p1D@example.com', 'P1 D', strftime('%s','now')*1000, strftime('%s','now')*1000),
('usr_fam_d_p2', 'fb_fam_d_p2', 'p2D@example.com', 'P2 D', strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO children (id, primary_parent_user_id, alias, given_name, family_name, preferred_name, short_name, locale, dob_year, dob_month, created_at, updated_at) VALUES
('ch_fam_d_c1', 'usr_fam_d_p1', 'delta1', 'Dina', 'Delta', 'Dina', 'Dina', 'en-GB', 2013, 2, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ch_fam_d_c2', 'usr_fam_d_p1', 'delta2', 'Dan', 'Delta', 'Dan', 'Dan', 'en-GB', 2016, 6, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ch_fam_d_c3', 'usr_fam_d_p1', 'delta3', 'Daisy', 'Delta', 'Daisy', 'Daisy', 'en-GB', 2019, 11, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO child_access (id, child_id, user_id, persona_role, access_level, is_primary_parent, invited_by_user_id, created_at, updated_at) VALUES
('cacc_fam_d_p1_c1', 'ch_fam_d_c1', 'usr_fam_d_p1', 'parent', 'parent', 1, NULL, strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_d_p1_c2', 'ch_fam_d_c2', 'usr_fam_d_p1', 'parent', 'parent', 1, NULL, strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_d_p1_c3', 'ch_fam_d_c3', 'usr_fam_d_p1', 'parent', 'parent', 1, NULL, strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_d_p2_c1', 'ch_fam_d_c1', 'usr_fam_d_p2', 'parent', 'parent', 0, 'usr_fam_d_p1', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_d_p2_c2', 'ch_fam_d_c2', 'usr_fam_d_p2', 'parent', 'parent', 0, 'usr_fam_d_p1', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cacc_fam_d_p2_c3', 'ch_fam_d_c3', 'usr_fam_d_p2', 'parent', 'parent', 0, 'usr_fam_d_p1', strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO user_subscriptions (id, user_id, provider, provider_customer_id, provider_subscription_id, plan_id, status, current_period_end, cancel_at_period_end, created_at, updated_at) VALUES
('subs_fam_d', 'usr_fam_d_p1', 'stripe', 'cus_fam_d', 'sub_fam_d_free', 'plan_free', 'active', (strftime('%s','now','+365 days')*1000), 0, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO user_consents (id, user_id, policy_id, group_key, version, accepted_at, created_at, updated_at) VALUES
('ucon_fam_d_p1_tos', 'usr_fam_d_p1', 'cpol_tos_v2', 'terms_of_service', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_d_p1_priv', 'usr_fam_d_p1', 'cpol_privacy_v2', 'privacy_policy', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_d_p2_tos', 'usr_fam_d_p2', 'cpol_tos_v2', 'terms_of_service', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_d_p2_priv', 'usr_fam_d_p2', 'cpol_privacy_v2', 'privacy_policy', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000);
