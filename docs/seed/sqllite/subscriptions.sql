-- Seed: Subscription Plans (SQLite)
PRAGMA foreign_keys = ON;

INSERT OR IGNORE INTO subscription_plans (id, key, title, description, interval, interval_count, currency, amount_cents, trial_days, features_json, provider_product_id, provider_price_id, status, created_at, updated_at) VALUES
('plan_free', 'free', 'Free', 'Free tier with limited features', 'month', 1, 'GBP', 0, NULL, '{"max_children":1,"ai_quota":100}', NULL, NULL, 'active', strftime('%s','now')*1000, strftime('%s','now')*1000),
('plan_basic_monthly', 'basic_monthly', 'Basic — Monthly', 'Monthly plan for individuals', 'month', 1, 'GBP', 499, 7, '{"max_children":1,"ai_quota":500}', NULL, NULL, 'active', strftime('%s','now')*1000, strftime('%s','now')*1000),
('plan_family_monthly', 'family_monthly', 'Family — Monthly', 'Monthly plan for families', 'month', 1, 'GBP', 999, 7, '{"max_children":4,"ai_quota":2000}', NULL, NULL, 'active', strftime('%s','now')*1000, strftime('%s','now')*1000);

