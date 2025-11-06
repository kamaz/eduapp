-- Seed: English Year 1 (KS1) for PostgreSQL
SET search_path=eduapp,public;

-- subject
INSERT INTO curriculum_subjects (id, country_code, key, title, created_at, updated_at)
VALUES ('csub_english_uk', 'UK', 'english', 'English', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- topics (Y1)
INSERT INTO curriculum_topics (id, subject, subject_id, code, title, description, grade_band, recommended_age_min, recommended_age_max, created_at, updated_at) VALUES
('ctop_eng_y1_r_wr', 'english', 'csub_english_uk', 'ENG.Y1.R.WR', 'Reading — Word Reading (Y1)', 'Apply phonic knowledge and speedy decoding of unfamiliar words; read common exception words.', 'KS1', 5, 7, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ctop_eng_y1_r_comp', 'english', 'csub_english_uk', 'ENG.Y1.R.COMP', 'Reading — Comprehension (Y1)', 'Develop pleasure in reading; understand both the books they can read and those they listen to.', 'KS1', 5, 7, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ctop_eng_y1_w_tr', 'english', 'csub_english_uk', 'ENG.Y1.W.TR', 'Writing — Transcription (Y1)', 'Spell words using phonics; learn to write letters and words legibly.', 'KS1', 5, 7, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ctop_eng_y1_w_comp', 'english', 'csub_english_uk', 'ENG.Y1.W.COMP', 'Writing — Composition (Y1)', 'Write sentences by saying out loud what they are going to write; sequence sentences; re-read to check it makes sense.', 'KS1', 5, 7, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ctop_eng_y1_vgp', 'english', 'csub_english_uk', 'ENG.Y1.VGP', 'Vocabulary, Grammar and Punctuation (Y1)', 'Leave spaces between words; join clauses with and; begin to punctuate sentences using a capital letter and a full stop.', 'KS1', 5, 7, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- lesson templates
INSERT INTO lesson_templates (id, topic_id, title, overview_asset_id, style, difficulty, status, created_by, created_by_user_id, created_at, updated_at) VALUES
('lt_eng_y1_r_wr_1', 'ctop_eng_y1_r_wr', 'Y1 Word Reading — Phonics practice', NULL, 'story', 1, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('lt_eng_y1_r_comp_1', 'ctop_eng_y1_r_comp', 'Y1 Reading Comp — Stories & talk', NULL, 'visual', 1, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- task templates
INSERT INTO task_templates (id, topic_id, lesson_template_id, title, style, difficulty, variable_schema_json, rubric_json, definition_asset_id, created_by, created_by_user_id, status, created_at, updated_at) VALUES
('tt_eng_y1_r_wr_cvc', 'ctop_eng_y1_r_wr', 'lt_eng_y1_r_wr_1', 'Read CVC words', 'visual', 1, '{"pattern":"CVC"}', NULL, NULL, 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('tt_eng_y1_r_comp_seq', 'ctop_eng_y1_r_comp', 'lt_eng_y1_r_comp_1', 'Sequence story pictures', 'story', 1, '{"pictures":3}', NULL, NULL, 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;
