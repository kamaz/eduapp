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
INSERT INTO lesson_templates (id, topic_id, title, asset_id, overview_json, style, difficulty, time_limit_ms, order_id, status, created_by, created_by_user_id, created_at, updated_at) VALUES
('lt_eng_y5_r_comp_1', 'ctop_eng_y5_r_comp', 'Y5 Reading Comp — Themes & conventions', NULL, NULL, 'story', 3, NULL, 1, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('lt_eng_y5_w_comp_1', 'ctop_eng_y5_w_comp', 'Y5 Writing Comp — Audience & purpose', NULL, NULL, 'visual', 3, NULL, 1, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- task templates
INSERT INTO task_templates (id, topic_id, lesson_template_id, title, style, difficulty, time_limit_ms, depends_on_id, order_id, asset_id, created_by, created_by_user_id, status, created_at, updated_at) VALUES
('tt_eng_y5_r_comp_themes', 'ctop_eng_y5_r_comp', 'lt_eng_y5_r_comp_1', 'Identify themes across chapters', 'story', 3, NULL, NULL, NULL, NULL, 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('tt_eng_y5_w_comp_plan', 'ctop_eng_y5_w_comp', 'lt_eng_y5_w_comp_1', 'Plan persuasive letter', 'visual', 3, NULL, NULL, NULL, NULL, 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- assets referencing existing PDFs in docs (for demo linking)
INSERT INTO assets (id, owner_child_id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at)
VALUES
('ast_eng_appendix2_vgp_pdf', NULL, 'pdf', 'docs', 'national-curriculum/uk/current/english/English_Appendix_2_-_Vocabulary_grammar_and_punctuation.pdf', 'application/pdf', NULL, NULL, EXTRACT(EPOCH FROM NOW())*1000),
('ast_eng_glossary_pdf', NULL, 'pdf', 'docs', 'national-curriculum/uk/current/english/English_Glossary.pdf', 'application/pdf', NULL, NULL, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- lesson template for Vocabulary, Grammar and Punctuation (Y5)
INSERT INTO lesson_templates (id, topic_id, title, asset_id, overview_json, style, difficulty, time_limit_ms, order_id, status, created_by, created_by_user_id, created_at, updated_at)
VALUES ('lt_eng_y5_vgp_1', 'ctop_eng_y5_vgp', 'Y5 VGP — Relative clauses and modal verbs', 'ast_eng_appendix2_vgp_pdf', NULL, 'visual', 3, NULL, 1, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- task templates for VGP (Y5)
INSERT INTO task_templates (id, topic_id, lesson_template_id, title, style, difficulty, time_limit_ms, depends_on_id, order_id, asset_id, created_by, created_by_user_id, status, created_at, updated_at) VALUES
('tt_eng_y5_vgp_relative_clauses', 'ctop_eng_y5_vgp', 'lt_eng_y5_vgp_1', 'Recognise and use relative clauses', 'visual', 3, NULL, NULL, 1, 'ast_eng_appendix2_vgp_pdf', 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('tt_eng_y5_vgp_modal_verbs', 'ctop_eng_y5_vgp', 'lt_eng_y5_vgp_1', 'Use modal verbs to indicate possibility', 'story', 3, NULL, NULL, 1, 'ast_eng_glossary_pdf', 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- OPTIONAL: attach the scanned lesson sheet image as an asset
-- Place the JPEG at docs/seed/seed-assets/speech-grammar-lesson-template.jpeg (or adjust r2_key below)
INSERT INTO assets (id, owner_child_id, type, r2_bucket, r2_key, mime_type, size_bytes, checksum_sha256, created_at)
VALUES ('ast_eng_y5_vgp_speech_sheet_jpg', NULL, 'image', 'docs', 'seed-assets/speech-grammar-lesson-template.jpeg', 'image/jpeg', NULL, NULL, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Lesson template based on the Speech worksheet (Direct vs Reported speech)
INSERT INTO lesson_templates (id, topic_id, title, asset_id, overview_json, style, difficulty, time_limit_ms, order_id, status, created_by, created_by_user_id, created_at, updated_at)
VALUES ('lt_eng_y5_vgp_speech_direct_reported', 'ctop_eng_y5_vgp', 'Y5 VGP — Direct and Reported Speech', 'ast_eng_y5_vgp_speech_sheet_jpg', '{"text":"There are two types of written speech: direct speech and reported speech. Direct speech is what a character actually says. Reported speech tells what a character said. Quick tip: Direct speech needs inverted commas (quotation marks)."}', 'visual', 3, NULL, 1, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Task templates derived from the sheet
INSERT INTO task_templates (id, topic_id, lesson_template_id, title, style, difficulty, time_limit_ms, depends_on_id, order_id, asset_id, created_by, created_by_user_id, status, created_at, updated_at) VALUES
('tt_eng_y5_vgp_punctuate_direct_speech', 'ctop_eng_y5_vgp', 'lt_eng_y5_vgp_speech_direct_reported', 'Punctuate direct speech with inverted commas', 'visual', 3, NULL, NULL, 1, 'ast_eng_y5_vgp_speech_sheet_jpg', 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('tt_eng_y5_vgp_direct_to_reported', 'ctop_eng_y5_vgp', 'lt_eng_y5_vgp_speech_direct_reported', 'Rewrite direct speech as reported speech', 'story', 3, NULL, NULL, 1, 'ast_eng_y5_vgp_speech_sheet_jpg', 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('tt_eng_y5_vgp_reported_to_direct', 'ctop_eng_y5_vgp', 'lt_eng_y5_vgp_speech_direct_reported', 'Rewrite reported speech as direct speech with correct punctuation', 'visual', 3, NULL, NULL, 1, 'ast_eng_y5_vgp_speech_sheet_jpg', 'user', NULL, 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- OCR text assets references removed in favor of inline overview_json in insert above

-- Task set template representing the worksheet with two sections (1 and 2)
INSERT INTO task_set_templates (id, topic_id, type, title, description, time_limit_ms, passing_score, status, created_by, created_by_user_id, created_at, updated_at)
VALUES ('tst_eng_y5_vgp_speech', 'ctop_eng_y5_vgp', 'quiz', 'Speech Worksheet — Direct & Reported', 'Section 1: reported→direct; Section 2: direct→reported', NULL, NULL, 'active', 'user', NULL, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Link the set to the lesson
INSERT INTO task_set_template_lessons (id, set_template_id, lesson_template_id, created_at)
VALUES ('tstl_eng_y5_vgp_speech_1', 'tst_eng_y5_vgp_speech', 'lt_eng_y5_vgp_speech_direct_reported', EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Section 1 (reported → direct): items a–d
INSERT INTO task_set_template_items (id, set_template_id, task_template_id, order_id, points, time_limit_ms, depends_on_id, asset_id, question_json, config_json, answer_json, created_at) VALUES
('tsti_eng_y5_vgp_s1_a', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_reported_to_direct', 1, NULL, NULL, NULL, NULL, '{"prompt":"Rewrite as direct speech","text":"Mum said that she couldn''t come to the concert because she was working."}', '{"transform":"reported_to_direct"}', '{"expected":"\"I can''t come to the concert because I''m working,\" said Mum."}', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s1_b', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_reported_to_direct', 2, NULL, NULL, NULL, NULL, '{"prompt":"Rewrite as direct speech","text":"They asked Dinah if she had forgotten her bus fare."}', '{"transform":"reported_to_direct"}', '{"expected":"\"Have you forgotten your bus fare?\" they asked Dinah."}', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s1_c', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_reported_to_direct', 3, NULL, NULL, NULL, NULL, '{"prompt":"Rewrite as direct speech","text":"Priti said that she wanted to go swimming."}', '{"transform":"reported_to_direct"}', '{"expected":"\"I want to go swimming,\" said Priti."}', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s1_d', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_reported_to_direct', 4, NULL, NULL, NULL, NULL, '{"prompt":"Rewrite as direct speech","text":"Mum told Belinda that she had to hurry up or she would be late."}', '{"transform":"reported_to_direct"}', '{"expected":"\"Hurry up or you''ll be late,\" Mum told Belinda."}', EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Section 2 (direct → reported): items a–d
INSERT INTO task_set_template_items (id, set_template_id, task_template_id, order_id, points, time_limit_ms, depends_on_id, asset_id, question_json, config_json, answer_json, created_at) VALUES
('tsti_eng_y5_vgp_s2_a', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_direct_to_reported', 5, NULL, NULL, NULL, NULL, '{"prompt":"Rewrite as reported speech","text":"\"Good morning, Mr Smith, and how are you feeling?\" asked the nurse."}', '{"transform":"direct_to_reported"}', '{"expected":"The nurse asked Mr Smith how he was feeling and wished him good morning."}', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s2_b', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_direct_to_reported', 6, NULL, NULL, NULL, NULL, '{"prompt":"Rewrite as reported speech","text":"\"Don''t forget to brush your teeth before you go to bed,\" Dad reminded me."}', '{"transform":"direct_to_reported"}', '{"expected":"Dad reminded me not to forget to brush my teeth before I went to bed."}', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s2_c', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_direct_to_reported', 7, NULL, NULL, NULL, NULL, '{"prompt":"Rewrite as reported speech","text":"\"Shh! Try to be quieter, or you''ll wake the baby,\" Mum whispered to me."}', '{"transform":"direct_to_reported"}', '{"expected":"Mum whispered to me to be quieter or I would wake the baby."}', EXTRACT(EPOCH FROM NOW())*1000),
('tsti_eng_y5_vgp_s2_d', 'tst_eng_y5_vgp_speech', 'tt_eng_y5_vgp_direct_to_reported', 8, NULL, NULL, NULL, NULL, '{"prompt":"Rewrite as reported speech","text":"\"No scribble today, I only want to see your best writing,\" the teacher said."}', '{"transform":"direct_to_reported"}', '{"expected":"The teacher said that there was to be no scribbling today and that they only wanted to see our best writing."}', EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;
