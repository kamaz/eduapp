-- Seed: English Year 5 (KS2) for PostgreSQL
SET search_path=eduapp,public;

-- subject
INSERT INTO curriculum_subjects (id, country_code, key, title, created_at, updated_at)
VALUES ('csub_english_uk', 'UK', 'english', 'English', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- topics (Y5)
INSERT INTO curriculum_topics (id, subject, subject_id, code, title, description, grade_band, recommended_age_min, recommended_age_max, created_at, updated_at) VALUES
('ctop_eng_y5_r_wr', 'english', 'csub_english_uk', 'ENG.Y5.R.WR', 'Reading — Word Reading (Y5)', 'Read age‑appropriate books with confidence; apply knowledge of root words, prefixes and suffixes.', 'KS2', 9, 11, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ctop_eng_y5_r_comp', 'english', 'csub_english_uk', 'ENG.Y5.R.COMP', 'Reading — Comprehension (Y5)', 'Increasing familiarity with a wide range of books; identify and discuss themes and conventions.', 'KS2', 9, 11, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ctop_eng_y5_w_tr', 'english', 'csub_english_uk', 'ENG.Y5.W.TR', 'Writing — Transcription (Y5)', 'Spell words with silent letters; use knowledge of morphology and etymology.', 'KS2', 9, 11, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ctop_eng_y5_w_comp', 'english', 'csub_english_uk', 'ENG.Y5.W.COMP', 'Writing — Composition (Y5)', 'Plan writing by identifying the audience and purpose; draft and evaluate the effectiveness of their own and others’ writing.', 'KS2', 9, 11, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ctop_eng_y5_vgp', 'english', 'csub_english_uk', 'ENG.Y5.VGP', 'Vocabulary, Grammar and Punctuation (Y5)', 'Use relative clauses, different verb forms; punctuate bullet points consistently.', 'KS2', 9, 11, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- lesson templates
INSERT INTO lesson_templates (id, topic_id, title, overview_asset_id, style, difficulty, status, created_by, created_by_user_id, created_at, updated_at) VALUES
('lt_eng_y5_r_comp_1', 'ctop_eng_y5_r_comp', 'Y5 Reading Comp — Themes & conventions', NULL, 'story', 3, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('lt_eng_y5_w_comp_1', 'ctop_eng_y5_w_comp', 'Y5 Writing Comp — Audience & purpose', NULL, 'visual', 3, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- task templates
INSERT INTO task_templates (id, topic_id, lesson_template_id, title, style, difficulty, variable_schema_json, rubric_json, definition_asset_id, created_by, created_by_user_id, status, created_at, updated_at) VALUES
('tt_eng_y5_r_comp_themes', 'ctop_eng_y5_r_comp', 'lt_eng_y5_r_comp_1', 'Identify themes across chapters', 'story', 3, '{"chapters":2}', NULL, NULL, 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('tt_eng_y5_w_comp_plan', 'ctop_eng_y5_w_comp', 'lt_eng_y5_w_comp_1', 'Plan persuasive letter', 'visual', 3, '{"audience":"headteacher"}', NULL, NULL, 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- assets referencing existing PDFs in docs (for demo linking)
INSERT INTO assets (id, owner_child_id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at)
VALUES
('ast_eng_appendix2_vgp_pdf', NULL, 'pdf', 'docs', 'national-curriculum/uk/current/english/English_Appendix_2_-_Vocabulary_grammar_and_punctuation.pdf', 'application/pdf', NULL, NULL, EXTRACT(EPOCH FROM NOW())*1000),
('ast_eng_glossary_pdf', NULL, 'pdf', 'docs', 'national-curriculum/uk/current/english/English_Glossary.pdf', 'application/pdf', NULL, NULL, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- lesson template for Vocabulary, Grammar and Punctuation (Y5)
INSERT INTO lesson_templates (id, topic_id, title, overview_asset_id, style, difficulty, status, created_by, created_by_user_id, created_at, updated_at)
VALUES ('lt_eng_y5_vgp_1', 'ctop_eng_y5_vgp', 'Y5 VGP — Relative clauses and modal verbs', 'ast_eng_appendix2_vgp_pdf', 'visual', 3, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- task templates for VGP (Y5)
INSERT INTO task_templates (id, topic_id, lesson_template_id, title, style, difficulty, variable_schema_json, rubric_json, definition_asset_id, created_by, created_by_user_id, status, created_at, updated_at) VALUES
('tt_eng_y5_vgp_relative_clauses', 'ctop_eng_y5_vgp', 'lt_eng_y5_vgp_1', 'Recognise and use relative clauses', 'visual', 3, '{"focus":"relative_clauses","examples":5}', NULL, 'ast_eng_appendix2_vgp_pdf', 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('tt_eng_y5_vgp_modal_verbs', 'ctop_eng_y5_vgp', 'lt_eng_y5_vgp_1', 'Use modal verbs to indicate possibility', 'story', 3, '{"focus":"modal_verbs","sentences":6}', NULL, 'ast_eng_glossary_pdf', 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- OPTIONAL: attach the scanned lesson sheet image as an asset
-- Place the JPEG at docs/seed/seed-assets/speech-grammar-lesson-template.jpeg (or adjust r2_key below)
INSERT INTO assets (id, owner_child_id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at)
VALUES ('ast_eng_y5_vgp_speech_sheet_jpg', NULL, 'image', 'docs', 'seed-assets/speech-grammar-lesson-template.jpeg', 'image/jpeg', NULL, NULL, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Lesson template based on the Speech worksheet (Direct vs Reported speech)
INSERT INTO lesson_templates (id, topic_id, title, overview_asset_id, style, difficulty, status, created_by, created_by_user_id, created_at, updated_at)
VALUES ('lt_eng_y5_vgp_speech_direct_reported', 'ctop_eng_y5_vgp', 'Y5 VGP — Direct and Reported Speech', 'ast_eng_y5_vgp_speech_sheet_jpg', 'visual', 3, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Task templates derived from the sheet
INSERT INTO task_templates (id, topic_id, lesson_template_id, title, style, difficulty, variable_schema_json, rubric_json, definition_asset_id, created_by, created_by_user_id, status, created_at, updated_at) VALUES
('tt_eng_y5_vgp_punctuate_direct_speech', 'ctop_eng_y5_vgp', 'lt_eng_y5_vgp_speech_direct_reported', 'Punctuate direct speech with inverted commas', 'visual', 3, '{"items":6,"include_reporting_clause":true}', NULL, 'ast_eng_y5_vgp_speech_sheet_jpg', 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('tt_eng_y5_vgp_direct_to_reported', 'ctop_eng_y5_vgp', 'lt_eng_y5_vgp_speech_direct_reported', 'Rewrite direct speech as reported speech', 'story', 3, '{"items":6}', NULL, 'ast_eng_y5_vgp_speech_sheet_jpg', 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('tt_eng_y5_vgp_reported_to_direct', 'ctop_eng_y5_vgp', 'lt_eng_y5_vgp_speech_direct_reported', 'Rewrite reported speech as direct speech with correct punctuation', 'visual', 3, '{"items":6}', NULL, 'ast_eng_y5_vgp_speech_sheet_jpg', 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- OCR text assets (overview and items JSON), place files under docs/seed/seed-assets
-- Store OCR overview text directly in DB
UPDATE lesson_templates
SET overview_text = 'There are two types of written speech: direct speech and reported speech. Direct speech is what a character actually says. Reported speech tells what a character said. Quick tip: Direct speech needs inverted commas (quotation marks).'
WHERE id = 'lt_eng_y5_vgp_speech_direct_reported';

-- Task set template representing the worksheet with two sections (1 and 2)
INSERT INTO task_set_templates (id, topic_id, type, title, description, time_limit_ms, passing_score, status, created_by, created_by_user_id, created_at, updated_at)
VALUES ('tst_eng_y5_vgp_speech', 'ctop_eng_y5_vgp', 'quiz', 'Speech Worksheet — Direct & Reported', 'Section 1: reported→direct; Section 2: direct→reported', NULL, NULL, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Link the set to the lesson
INSERT INTO task_set_template_lessons (id, set_template_id, lesson_template_id, created_at)
VALUES ('tstl_eng_y5_vgp_speech_1', 'tst_eng_y5_vgp_speech', 'lt_eng_y5_vgp_speech_direct_reported', EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Section 1 (reported → direct): items a–d
INSERT INTO task_set_template_items (id, set_template_id, task_template_id, order_index, points, item_time_limit_ms, depends_on_item_id, propagation_mode, propagation_label, created_at) VALUES
('tsti_eng_y5_vgp_s1_a', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_reported_to_direct', 0, NULL, NULL, NULL, NULL, 'sec1_a', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s1_b', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_reported_to_direct', 1, NULL, NULL, NULL, NULL, 'sec1_b', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s1_c', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_reported_to_direct', 2, NULL, NULL, NULL, NULL, 'sec1_c', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s1_d', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_reported_to_direct', 3, NULL, NULL, NULL, NULL, 'sec1_d', EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Section 2 (direct → reported): items a–d
INSERT INTO task_set_template_items (id, set_template_id, task_template_id, order_index, points, item_time_limit_ms, depends_on_item_id, propagation_mode, propagation_label, created_at) VALUES
('tsti_eng_y5_vgp_s2_a', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_direct_to_reported', 4, NULL, NULL, NULL, NULL, 'sec2_a', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s2_b', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_direct_to_reported', 5, NULL, NULL, NULL, NULL, 'sec2_b', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s2_c', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_direct_to_reported', 6, NULL, NULL, NULL, NULL, 'sec2_c', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s2_d', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_direct_to_reported', 7, NULL, NULL, NULL, NULL, 'sec2_d', EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;
-- Store item sentences (structured) directly in DB on template items
UPDATE task_set_template_items SET parameters_json = '{"original_sentence":"Mum said that she couldn''t come to the concert because she was working."}' WHERE id = 'tsti_eng_y5_vgp_s1_a';
UPDATE task_set_template_items SET parameters_json = '{"original_sentence":"They asked Dinah if she had forgotten her bus fare."}' WHERE id = 'tsti_eng_y5_vgp_s1_b';
UPDATE task_set_template_items SET parameters_json = '{"original_sentence":"Priti said that she wanted to go swimming."}' WHERE id = 'tsti_eng_y5_vgp_s1_c';
UPDATE task_set_template_items SET parameters_json = '{"original_sentence":"Mum told Belinda that she had to hurry up or she would be late."}' WHERE id = 'tsti_eng_y5_vgp_s1_d';

UPDATE task_set_template_items SET parameters_json = '{"original_sentence":"\"Good morning, Mr Smith, and how are you feeling?\" asked the nurse."}' WHERE id = 'tsti_eng_y5_vgp_s2_a';
UPDATE task_set_template_items SET parameters_json = '{"original_sentence":"\"Don''t forget to brush your teeth before you go to bed,\" Dad reminded me."}' WHERE id = 'tsti_eng_y5_vgp_s2_b';
UPDATE task_set_template_items SET parameters_json = '{"original_sentence":"\"Shh! Try to be quieter, or you''ll wake the baby,\" Mum whispered to me."}' WHERE id = 'tsti_eng_y5_vgp_s2_c';
UPDATE task_set_template_items SET parameters_json = '{"original_sentence":"\"No scribble today, I only want to see your best writing,\" the teacher said."}' WHERE id = 'tsti_eng_y5_vgp_s2_d';
