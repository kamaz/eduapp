-- Seed: Example lesson and task instances for Bella (Family B, child ch_fam_b_c1)
set search_path=eduapp,public;

-- Lesson instance for Direct & Reported Speech lesson
INSERT INTO lesson_instances (id, lesson_template_id, child_id, title, style, difficulty, personalization_params_json, created_by_user_id, status, created_at, updated_at)
VALUES ('li_fam_b_c1_eng_y5_vgp_speech_1', 'lt_eng_y5_vgp_speech_direct_reported', 'ch_fam_b_c1', 'Acting out direct and reported speech', 'visual', 3, '{"profile_source":"parent+child","interests":["funny_stories","silly_word_games","acting_out_stories"],"notes":"Build on love of reading aloud and acting out characters. Keep activities short, with chances to perform dialogue before writing it."}', 'usr_fam_b_p1', 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Task instances derived from the lesson
INSERT INTO task_instances (id, task_template_id, topic_id, lesson_instance_id, child_id, role, example_root_task_instance_id, title, style, difficulty, asset_id, answer_type, expected_answer_json, solution_asset_id, created_by, created_by_user_id, status, created_at, updated_at)
VALUES
('ti_fam_b_c1_eng_y5_vgp_punctuate', 'tt_eng_y5_vgp_punctuate_direct_speech', 'ctop_eng_y5_vgp', 'li_fam_b_c1_eng_y5_vgp_speech_1', 'ch_fam_b_c1', 'practice', NULL, 'Punctuate direct speech with inverted commas', 'visual', 3, 'ast_eng_y5_vgp_speech_sheet_jpg', 'written', '{"focus":"punctuation","hints":["Start and end direct speech with inverted commas.","Keep the reporting clause outside the speech marks."]}', NULL, 'system', 'usr_fam_b_p1', 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ti_fam_b_c1_eng_y5_vgp_direct_to_reported', 'tt_eng_y5_vgp_direct_to_reported', 'ctop_eng_y5_vgp', 'li_fam_b_c1_eng_y5_vgp_speech_1', 'ch_fam_b_c1', 'practice', NULL, 'Rewrite direct speech as reported speech', 'story', 3, 'ast_eng_y5_vgp_speech_sheet_jpg', 'written', '{"focus":"direct_to_reported","hints":["Drop the quotation marks.","Shift pronouns and tense where needed."]}', NULL, 'system', 'usr_fam_b_p1', 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ti_fam_b_c1_eng_y5_vgp_reported_to_direct', 'tt_eng_y5_vgp_reported_to_direct', 'ctop_eng_y5_vgp', 'li_fam_b_c1_eng_y5_vgp_speech_1', 'ch_fam_b_c1', 'practice', NULL, 'Rewrite reported speech as direct speech', 'visual', 3, 'ast_eng_y5_vgp_speech_sheet_jpg', 'written', '{"focus":"reported_to_direct","hints":["Rebuild the spoken sentence with inverted commas.","Keep the reporting clause clear."]}', NULL, 'system', 'usr_fam_b_p1', 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Task set instance representing the worksheet for Bella
INSERT INTO task_set_instances (id, set_template_id, child_id, type, title, description, time_limit_ms, passing_score, status, created_by_user_id, started_at, completed_at, created_at, updated_at)
VALUES ('tsi_fam_b_c1_eng_y5_vgp_speech', 'tst_eng_y5_vgp_speech', 'ch_fam_b_c1', 'quiz', 'Bella — Speech Worksheet (Direct & Reported)', 'Mixed set of items converting between direct and reported speech, tuned for reading aloud and short written answers.', NULL, 0.7, 'completed', 'usr_fam_b_p1', EXTRACT(EPOCH FROM NOW() - INTERVAL '10 minutes')*1000, EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW() - INTERVAL '10 minutes')*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Link the lesson instance to the task set instance
INSERT INTO task_set_instance_lessons (id, set_instance_id, lesson_instance_id, created_at)
VALUES ('tsil_fam_b_c1_eng_y5_vgp_speech_1', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'li_fam_b_c1_eng_y5_vgp_speech_1', EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Task set instance items (map a subset of template items to Bella's task instances)
INSERT INTO task_set_instance_items (id, set_instance_id, task_instance_id, order_index, points, item_time_limit_ms, depends_on_id, question_json, config_json, answer_json, created_at)
VALUES
('tsii_fam_b_c1_eng_y5_vgp_s1_a', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'ti_fam_b_c1_eng_y5_vgp_reported_to_direct', 1, 1, NULL, NULL, '{"template_item_id":"titem_eng_y5_vgp_s1_c"}', '{"mode":"guided"}', '{"expected":"\"I want to go swimming,\" said Priti."}', EXTRACT(EPOCH FROM NOW())*1000),
('tsii_fam_b_c1_eng_y5_vgp_s1_b', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'ti_fam_b_c1_eng_y5_vgp_reported_to_direct', 2, 1, NULL, NULL, '{"template_item_id":"titem_eng_y5_vgp_s1_b"}', '{"mode":"guided"}', '{"expected":"\"Have you forgotten your bus fare?\" they asked Dinah."}', EXTRACT(EPOCH FROM NOW())*1000),
('tsii_fam_b_c1_eng_y5_vgp_s2_a', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'ti_fam_b_c1_eng_y5_vgp_direct_to_reported', 3, 1, NULL, NULL, '{"template_item_id":"titem_eng_y5_vgp_s2_a"}', '{"mode":"independent"}', '{"expected":"The nurse asked Mr Smith how he was feeling and wished him good morning."}', EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Attempts for Bella on these tasks
INSERT INTO attempts (id, child_id, task_instance_id, task_set_instance_id, task_set_instance_item_id, attempt_client_id, source, answer_asset_id, strokes_asset_id, score, presentation_score, correct, summary_json, duration_ms, created_at)
VALUES
('att_fam_b_c1_eng_y5_vgp_1', 'ch_fam_b_c1', 'ti_fam_b_c1_eng_y5_vgp_reported_to_direct', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'tsii_fam_b_c1_eng_y5_vgp_s1_a', 'cli_fam_b_c1_vgp_1', 'worksheet', NULL, NULL, 0.9, 0.8, true, '{"notes":"Needed one prompt about pronouns; punctuation correct.","feedback_for_parent":"Great job reading the sentence aloud first, then writing it. Next time, let Bella try one on her own before giving a hint."}', 180000, EXTRACT(EPOCH FROM NOW() - INTERVAL '8 minutes')*1000),
('att_fam_b_c1_eng_y5_vgp_2', 'ch_fam_b_c1', 'ti_fam_b_c1_eng_y5_vgp_reported_to_direct', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'tsii_fam_b_c1_eng_y5_vgp_s1_b', 'cli_fam_b_c1_vgp_2', 'worksheet', NULL, NULL, 0.7, 0.8, true, '{"notes":"Minor tense slip fixed after reading aloud.","feedback_for_parent":"When Bella hesitates, invite her to say the sentence in her own words first, then write it."}', 210000, EXTRACT(EPOCH FROM NOW() - INTERVAL '6 minutes')*1000),
('att_fam_b_c1_eng_y5_vgp_3', 'ch_fam_b_c1', 'ti_fam_b_c1_eng_y5_vgp_direct_to_reported', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'tsii_fam_b_c1_eng_y5_vgp_s2_a', 'cli_fam_b_c1_vgp_3', 'worksheet', NULL, NULL, 0.6, 0.9, false, '{"notes":"Forgot to remove quotation marks on first try; corrected after prompt.","feedback_for_parent":"Highlight how reported speech usually removes the speech marks and shifts pronouns; practise with one extra example later today."}', 240000, EXTRACT(EPOCH FROM NOW() - INTERVAL '4 minutes')*1000)
ON CONFLICT (id) DO NOTHING;

-- Progress snapshot for Bella on the Y5 VGP topic
INSERT INTO progress (id, child_id, topic_id, mastery, attempts_count, last_practiced_at, history_json, created_at, updated_at)
VALUES ('prog_fam_b_c1_eng_y5_vgp', 'ch_fam_b_c1', 'ctop_eng_y5_vgp', 0.65, 3, EXTRACT(EPOCH FROM NOW())*1000, '{"recent_attempts":["att_fam_b_c1_eng_y5_vgp_1","att_fam_b_c1_eng_y5_vgp_2","att_fam_b_c1_eng_y5_vgp_3"],"notes":"Strong engagement when tasks involve reading aloud and acting out dialogue. Avoid long silent worksheets; keep activities short and interactive."}', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;
