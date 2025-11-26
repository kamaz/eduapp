-- Seed: Consent Policies (PostgreSQL)
SET search_path=public;

-- Assets for policy documents
INSERT INTO assets (id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at) VALUES
('ast_policy_tos_v1', 'policy', 'docs', 'policies/terms-of-service-v1.md', 'text/markdown', NULL, NULL, EXTRACT(EPOCH FROM NOW())*1000),
('ast_policy_tos_v2', 'policy', 'docs', 'policies/terms-of-service-v2.md', 'text/markdown', NULL, NULL, EXTRACT(EPOCH FROM NOW())*1000),
('ast_policy_priv_v1', 'policy', 'docs', 'policies/privacy-policy-v1.md', 'text/markdown', NULL, NULL, EXTRACT(EPOCH FROM NOW())*1000),
('ast_policy_priv_v2', 'policy', 'docs', 'policies/privacy-policy-v2.md', 'text/markdown', NULL, NULL, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Multiple versions per group (latest active)
INSERT INTO consent_policies (id, group_key, version, title, locale, asset_id, status, effective_at, created_at, updated_at) VALUES
('cpol_tos_v1', 'terms_of_service', 1, 'Terms of Service v1', 'en-GB', 'ast_policy_tos_v1', 'archived', (EXTRACT(EPOCH FROM NOW() - INTERVAL '60 days')*1000)::bigint, (EXTRACT(EPOCH FROM NOW() - INTERVAL '60 days')*1000)::bigint, (EXTRACT(EPOCH FROM NOW() - INTERVAL '59 days')*1000)::bigint),
('cpol_tos_v2', 'terms_of_service', 2, 'Terms of Service v2', 'en-GB', 'ast_policy_tos_v2', 'active', (EXTRACT(EPOCH FROM NOW() - INTERVAL '1 day')*1000)::bigint, (EXTRACT(EPOCH FROM NOW() - INTERVAL '1 day')*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint),
('cpol_privacy_v1', 'privacy_policy', 1, 'Privacy Policy v1', 'en-GB', 'ast_policy_priv_v1', 'archived', (EXTRACT(EPOCH FROM NOW() - INTERVAL '60 days')*1000)::bigint, (EXTRACT(EPOCH FROM NOW() - INTERVAL '60 days')*1000)::bigint, (EXTRACT(EPOCH FROM NOW() - INTERVAL '59 days')*1000)::bigint),
('cpol_privacy_v2', 'privacy_policy', 2, 'Privacy Policy v2', 'en-GB', 'ast_policy_priv_v2', 'active', (EXTRACT(EPOCH FROM NOW() - INTERVAL '1 day')*1000)::bigint, (EXTRACT(EPOCH FROM NOW() - INTERVAL '1 day')*1000)::bigint, (EXTRACT(EPOCH FROM NOW())*1000)::bigint)
ON CONFLICT (id) DO NOTHING;
