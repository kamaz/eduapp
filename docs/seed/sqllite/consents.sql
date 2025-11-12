-- Seed: Consent Policies (SQLite)
PRAGMA foreign_keys = ON;

-- Assets for policy documents
INSERT OR IGNORE INTO assets (id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at) VALUES
('ast_policy_tos_v1', 'policy', 'docs', 'policies/terms-of-service-v1.md', 'text/markdown', NULL, NULL, strftime('%s','now')*1000),
('ast_policy_tos_v2', 'policy', 'docs', 'policies/terms-of-service-v2.md', 'text/markdown', NULL, NULL, strftime('%s','now')*1000),
('ast_policy_priv_v1', 'policy', 'docs', 'policies/privacy-policy-v1.md', 'text/markdown', NULL, NULL, strftime('%s','now')*1000),
('ast_policy_priv_v2', 'policy', 'docs', 'policies/privacy-policy-v2.md', 'text/markdown', NULL, NULL, strftime('%s','now')*1000);

-- Multiple versions per group (latest active)
INSERT OR IGNORE INTO consent_policies (id, group_key, version, title, locale, asset_id, status, effective_at, created_at, updated_at) VALUES
('cpol_tos_v1', 'terms_of_service', 1, 'Terms of Service v1', 'en-GB', 'ast_policy_tos_v1', 'archived', (strftime('%s','now')-86400*60)*1000, (strftime('%s','now')-86400*60)*1000, (strftime('%s','now')-86400*59)*1000),
('cpol_tos_v2', 'terms_of_service', 2, 'Terms of Service v2', 'en-GB', 'ast_policy_tos_v2', 'active', (strftime('%s','now')-86400*1)*1000, (strftime('%s','now')-86400*1)*1000, strftime('%s','now')*1000),
('cpol_privacy_v1', 'privacy_policy', 1, 'Privacy Policy v1', 'en-GB', 'ast_policy_priv_v1', 'archived', (strftime('%s','now')-86400*60)*1000, (strftime('%s','now')-86400*60)*1000, (strftime('%s','now')-86400*59)*1000),
('cpol_privacy_v2', 'privacy_policy', 2, 'Privacy Policy v2', 'en-GB', 'ast_policy_priv_v2', 'active', (strftime('%s','now')-86400*1)*1000, (strftime('%s','now')-86400*1)*1000, strftime('%s','now')*1000);
