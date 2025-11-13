-- Seed: Demo Families (SQLite)
PRAGMA foreign_keys = ON;

-- Helper timestamps (inline via strftime)

INSERT OR IGNORE INTO users (id, firebase_uid, email, display_name, billing_customer_id, settings_json, created_at, updated_at) VALUES
('usr_fam_a_parent', 'fb_fam_a_parent', 'parentA@example.com', 'Parent A', 'cus_fam_a', NULL, strftime('%s','now')*1000, strftime('%s','now')*1000);

-- Avatar assets
INSERT OR IGNORE INTO assets (id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at) VALUES
('ast_avatar_fam_a_c1', 'avatar', 'avatars', 'seed/fam_a_c1.png', 'image/png', NULL, NULL, strftime('%s','now')*1000);

INSERT OR IGNORE INTO children (id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob, created_at, updated_at) VALUES
('ch_fam_a_child1', 'littleA', 'Alex', 'Alpha', 'Alex', 'Alex', 'Lex', 'ch_fam_a_child1@internal.local', 'ast_avatar_fam_a_c1', 'en-GB', strftime('%s','2016-05-01')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO child_access (id, child_id, user_id, persona_role, access_level, is_primary_parent, invited_by_user_id, revoked_at, created_at, updated_at) VALUES
('cacc_fam_a_pa_c1', 'ch_fam_a_child1', 'usr_fam_a_parent', 'parent', 'parent', 1, NULL, NULL, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO user_subscriptions (id, user_id, provider, provider_customer_id, provider_subscription_id, plan_id, status, current_period_end, cancel_at_period_end, created_at, updated_at) VALUES
('subs_fam_a', 'usr_fam_a_parent', 'stripe', 'cus_fam_a', 'sub_fam_a_basic', 'plan_basic_monthly', 'active', (strftime('%s','now','+30 days')*1000), 0, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO user_consents (id, user_id, policy_id, group_key, version, accepted_at, created_at, updated_at) VALUES
('ucon_fam_a_parent_tos', 'usr_fam_a_parent', 'cpol_tos_v2', 'terms_of_service', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ucon_fam_a_parent_priv', 'usr_fam_a_parent', 'cpol_privacy_v2', 'privacy_policy', 2, strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO users (id, firebase_uid, email, display_name, created_at, updated_at) VALUES
('usr_fam_b_p1', 'fb_fam_b_p1', 'p1B@example.com', 'P1 B', strftime('%s','now')*1000, strftime('%s','now')*1000),
('usr_fam_b_p2', 'fb_fam_b_p2', 'p2B@example.com', 'P2 B', strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO assets (id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at) VALUES
('ast_avatar_fam_b_c1', 'avatar', 'avatars', 'seed/fam_b_c1.png', 'image/png', NULL, NULL, strftime('%s','now')*1000),
('ast_avatar_fam_b_c2', 'avatar', 'avatars', 'seed/fam_b_c2.png', 'image/png', NULL, NULL, strftime('%s','now')*1000);

INSERT OR IGNORE INTO children (id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob, created_at, updated_at) VALUES
('ch_fam_b_c1', 'bee1', 'Bella', 'Beta', 'Bella', 'Bella', 'Bell', 'ch_fam_b_c1@internal.local', 'ast_avatar_fam_b_c1', 'en-GB', strftime('%s','2015-09-01')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ch_fam_b_c2', 'bee2', 'Ben', 'Beta', 'Ben', 'Ben', 'Benny', 'ch_fam_b_c2@internal.local', 'ast_avatar_fam_b_c2', 'en-GB', strftime('%s','2018-03-01')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000);

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

INSERT OR IGNORE INTO users (id, firebase_uid, email, display_name, created_at, updated_at) VALUES
('usr_fam_c_p1', 'fb_fam_c_p1', 'p1C@example.com', 'P1 C', strftime('%s','now')*1000, strftime('%s','now')*1000),
('usr_fam_c_p2', 'fb_fam_c_p2', 'p2C@example.com', 'P2 C', strftime('%s','now')*1000, strftime('%s','now')*1000),
('usr_fam_c_gp1', 'fb_fam_c_gp1', 'gp1C@example.com', 'GP1 C', strftime('%s','now')*1000, strftime('%s','now')*1000),
('usr_fam_c_gp2', 'fb_fam_c_gp2', 'gp2C@example.com', 'GP2 C', strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO assets (id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at) VALUES
('ast_avatar_fam_c_c1', 'avatar', 'avatars', 'seed/fam_c_c1.png', 'image/png', NULL, NULL, strftime('%s','now')*1000);

INSERT OR IGNORE INTO children (id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob, created_at, updated_at) VALUES
('ch_fam_c_c1', 'charlie', 'Chris', 'Gamma', 'Chris', 'Chris', 'CJ', 'ch_fam_c_c1@internal.local', 'ast_avatar_fam_c_c1', 'en-GB', strftime('%s','2014-07-01')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000);

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

INSERT OR IGNORE INTO users (id, firebase_uid, email, display_name, created_at, updated_at) VALUES
('usr_fam_d_p1', 'fb_fam_d_p1', 'p1D@example.com', 'P1 D', strftime('%s','now')*1000, strftime('%s','now')*1000),
('usr_fam_d_p2', 'fb_fam_d_p2', 'p2D@example.com', 'P2 D', strftime('%s','now')*1000, strftime('%s','now')*1000);

INSERT OR IGNORE INTO assets (id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at) VALUES
('ast_avatar_fam_d_c1', 'avatar', 'avatars', 'seed/fam_d_c1.png', 'image/png', NULL, NULL, strftime('%s','now')*1000),
('ast_avatar_fam_d_c2', 'avatar', 'avatars', 'seed/fam_d_c2.png', 'image/png', NULL, NULL, strftime('%s','now')*1000),
('ast_avatar_fam_d_c3', 'avatar', 'avatars', 'seed/fam_d_c3.png', 'image/png', NULL, NULL, strftime('%s','now')*1000);

INSERT OR IGNORE INTO children (id, alias, given_name, family_name, preferred_name, short_name, nickname, email, avatar_asset_id, locale, dob, created_at, updated_at) VALUES
('ch_fam_d_c1', 'delta1', 'Dina', 'Delta', 'Dina', 'Dina', 'Dee', 'ch_fam_d_c1@internal.local', 'ast_avatar_fam_d_c1', 'en-GB', strftime('%s','2013-02-01')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ch_fam_d_c2', 'delta2', 'Dan', 'Delta', 'Dan', 'Dan', 'Danny', 'ch_fam_d_c2@internal.local', 'ast_avatar_fam_d_c2', 'en-GB', strftime('%s','2016-06-01')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000),
('ch_fam_d_c3', 'delta3', 'Daisy', 'Delta', 'Daisy', 'Daisy', 'Day', 'ch_fam_d_c3@internal.local', 'ast_avatar_fam_d_c3', 'en-GB', strftime('%s','2019-11-01')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000);

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

-- Additional: Access Requests, Child Profiles, Observations

-- Access requests
INSERT OR IGNORE INTO access_requests (id, requester_user_id, target_parent_user_id, target_child_id, target_parent_email, desired_persona_role, desired_access_level, status, token, expires_at, message, created_at, updated_at, acted_at, acted_by_user_id) VALUES
('areq_fam_b_p2_to_p1', 'usr_fam_b_p2', 'usr_fam_b_p1', 'ch_fam_b_c1', 'p1B@example.com', 'parent', 'parent', 'approved', 'tok_ar_fam_b_p2', strftime('%s','now','+7 days')*1000, 'Request access to child c1', strftime('%s','now')*1000, strftime('%s','now')*1000, strftime('%s','now')*1000, 'usr_fam_b_p1'),
('areq_fam_c_gp2_to_p1', 'usr_fam_c_gp2', 'usr_fam_c_p1', 'ch_fam_c_c1', 'p1C@example.com', 'grandparent', 'family', 'pending', 'tok_ar_fam_c_gp2', strftime('%s','now','+7 days')*1000, 'Grandparent access request to child c1', strftime('%s','now')*1000, strftime('%s','now')*1000, NULL, NULL);

-- Child profiles (created by primary parent)
INSERT OR IGNORE INTO child_profile (id, child_id, created_by_user_id, updated_by_user_id, authored_by_child, persona_role, status, learning_style, profile_summary, sensitivities, created_at, updated_at) VALUES
('cprof_fam_a_c1', 'ch_fam_a_child1', 'usr_fam_a_parent', 'usr_fam_a_parent', 0, 'parent', 'active', 'visual', 'Curious and enjoys puzzles.', 'loud_sounds', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cprof_fam_b_c1', 'ch_fam_b_c1', 'usr_fam_b_p1', 'usr_fam_b_p1', 0, 'parent', 'active', 'auditory', 'Loves reading aloud.', 'bright_lights', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cprof_fam_b_c2', 'ch_fam_b_c2', 'usr_fam_b_p1', 'usr_fam_b_p1', 0, 'parent', 'active', 'kinesthetic', 'Enjoys hands-on activities.', 'none', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cprof_fam_c_c1', 'ch_fam_c_c1', 'usr_fam_c_p1', 'usr_fam_c_p1', 0, 'parent', 'active', 'visual', 'Strong interest in art.', 'none', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cprof_fam_d_c1', 'ch_fam_d_c1', 'usr_fam_d_p1', 'usr_fam_d_p1', 0, 'parent', 'active', 'auditory', 'Great storyteller.', 'none', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cprof_fam_d_c2', 'ch_fam_d_c2', 'usr_fam_d_p1', 'usr_fam_d_p1', 0, 'parent', 'active', 'visual', 'Enjoys drawing.', 'none', strftime('%s','now')*1000, strftime('%s','now')*1000),
('cprof_fam_d_c3', 'ch_fam_d_c3', 'usr_fam_d_p1', 'usr_fam_d_p1', 0, 'parent', 'active', 'kinesthetic', 'Likes building blocks.', 'none', strftime('%s','now')*1000, strftime('%s','now')*1000);

-- Child profile items
INSERT OR IGNORE INTO child_profile_items (id, profile_id, type, value, created_at) VALUES
('cprofitem_fam_a_c1_interest1', 'cprof_fam_a_c1', 'interest', 'puzzles', strftime('%s','now')*1000),
('cprofitem_fam_b_c1_book1', 'cprof_fam_b_c1', 'book', 'The Gruffalo', strftime('%s','now')*1000),
('cprofitem_fam_b_c2_game1', 'cprof_fam_b_c2', 'game', 'LEGO', strftime('%s','now')*1000),
('cprofitem_fam_c_c1_movie1', 'cprof_fam_c_c1', 'movie', 'Coco', strftime('%s','now')*1000),
('cprofitem_fam_d_c3_interest1', 'cprof_fam_d_c3', 'interest', 'animals', strftime('%s','now')*1000);

-- Child observations
INSERT OR IGNORE INTO child_observations (id, child_id, user_id, note_type, body, status, superseded_by_observation_id, created_at, updated_at) VALUES
('cobs_fam_a_c1_1', 'ch_fam_a_child1', 'usr_fam_a_parent', 'observation', 'Enjoyed today\'s reading task.', 'active', NULL, strftime('%s','now')*1000, strftime('%s','now')*1000),
('cobs_fam_b_c1_1', 'ch_fam_b_c1', 'usr_fam_b_p1', 'observation', 'Did well with phonics.', 'active', NULL, strftime('%s','now')*1000, strftime('%s','now')*1000),
('cobs_fam_b_c2_1', 'ch_fam_b_c2', 'usr_fam_b_p1', 'observation', 'Struggled with focus after 20 minutes.', 'active', NULL, strftime('%s','now')*1000, strftime('%s','now')*1000),
('cobs_fam_c_c1_1', 'ch_fam_c_c1', 'usr_fam_c_p1', 'observation', 'Loved the art worksheet.', 'active', NULL, strftime('%s','now')*1000, strftime('%s','now')*1000),
('cobs_fam_d_c1_1', 'ch_fam_d_c1', 'usr_fam_d_p1', 'observation', 'Great progress with numbers.', 'active', NULL, strftime('%s','now')*1000, strftime('%s','now')*1000);
