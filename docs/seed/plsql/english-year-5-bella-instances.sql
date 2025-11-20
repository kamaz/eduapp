-- Seed: Example lesson and task instances for Bella (Family B, child ch_fam_b_c1)
set search_path=eduapp,public;

-- Lesson instance for Direct & Reported Speech lesson
INSERT INTO lesson_instances (id, lesson_template_id, child_id, title, style, difficulty, personalization_params_json, created_by_user_id, status, created_at, updated_at)
VALUES ('li_fam_b_c1_eng_y5_vgp_speech_1', 'lt_eng_y5_vgp_speech_direct_reported', 'ch_fam_b_c1', 'Acting out direct and reported speech', 'visual', 3,
        '{"profile_source":"parent+child","learning_style":"auditory","interests":["funny_stories","silly_word_games","acting_out_stories"],"tags":["stories_aloud","audiobooks"],"sensitivities":["bright_screens_evening"],"notes":"Build on love of reading aloud and acting out characters. Keep activities short, with chances to perform dialogue before writing it, and avoid bright screens late in the evening."}',
        'usr_fam_b_p1', 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Task set instance representing the worksheet for Bella
INSERT INTO task_set_instances (id, set_template_id, lesson_instance_id, child_id, type, title, description, time_limit_ms, passing_score, status, created_by_user_id, started_at, completed_at, created_at, updated_at)
VALUES ('tsi_fam_b_c1_eng_y5_vgp_speech', 'tst_eng_y5_vgp_speech', 'li_fam_b_c1_eng_y5_vgp_speech_1', 'ch_fam_b_c1', 'quiz',
        'Direct and reported speech — read‑aloud practice set',
        'Personalised set of direct and reported speech items designed for a child who enjoys reading stories aloud and acting out characters. Items are short, can be performed with voices, and then rewritten as sentences.',
        20*60*1000, 0.7, 'completed', 'usr_fam_b_p1',
        EXTRACT(EPOCH FROM NOW() - INTERVAL '10 minutes')*1000, EXTRACT(EPOCH FROM NOW())*1000,
        EXTRACT(EPOCH FROM NOW() - INTERVAL '10 minutes')*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Task instances derived from the task set
INSERT INTO task_instances (id, task_template_id, task_set_instance_id, child_id, role, title, style, difficulty, asset_id, solution_asset_id, created_by, created_by_user_id, status, created_at, updated_at)
VALUES
('ti_fam_b_c1_eng_y5_vgp_punctuate', 'tt_eng_y5_vgp_punctuate_direct_speech', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'ch_fam_b_c1', 'practice', 'Punctuate direct speech with inverted commas', 'visual', 3, 'ast_eng_y5_vgp_speech_sheet_jpg', NULL, 'system', 'usr_fam_b_p1', 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ti_fam_b_c1_eng_y5_vgp_direct_to_reported', 'tt_eng_y5_vgp_direct_to_reported', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'ch_fam_b_c1', 'practice', 'Rewrite direct speech as reported speech', 'story', 3, 'ast_eng_y5_vgp_speech_sheet_jpg', NULL, 'system', 'usr_fam_b_p1', 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000),
('ti_fam_b_c1_eng_y5_vgp_reported_to_direct', 'tt_eng_y5_vgp_reported_to_direct', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'ch_fam_b_c1', 'practice', 'Rewrite reported speech as direct speech', 'visual', 3, 'ast_eng_y5_vgp_speech_sheet_jpg', NULL, 'system', 'usr_fam_b_p1', 'active', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Task item instances personalised using Bella's profile (auditory, enjoys funny stories and acting out dialogue)
INSERT INTO task_item_instances (id, task_instance_id, task_item_template_id, order_index, points, item_time_limit_ms, depends_on_id, question_json, config_json, answer_json, created_at)
VALUES
('tii_fam_b_c1_eng_y5_vgp_s1_a',
 'ti_fam_b_c1_eng_y5_vgp_reported_to_direct',
 'titem_eng_y5_vgp_s1_c',
 1, 1, 4*60*1000, NULL,
 '{"prompt":"Read this sentence aloud with expression, then rewrite it as direct speech.","text":"Priti said that she wanted to go swimming.","personalisation":{"learning_style":"auditory","interests":["funny_stories","acting_out_stories"]}}',
 '{"mode":"guided","delivery":"read_aloud_first","max_attempts":2}',
 '{"expected":"\"I want to go swimming,\" said Priti."}',
 EXTRACT(EPOCH FROM NOW())*1000),
('tii_fam_b_c1_eng_y5_vgp_s1_b',
 'ti_fam_b_c1_eng_y5_vgp_reported_to_direct',
 'titem_eng_y5_vgp_s1_b',
 2, 1, 4*60*1000, NULL,
 '{"prompt":"Say the question out loud, then rewrite it as direct speech with the correct punctuation.","text":"They asked Dinah if she had forgotten her bus fare.","personalisation":{"learning_style":"auditory","interests":["word_games","funny_stories"]}}',
 '{"mode":"guided","delivery":"read_aloud_then_write","max_attempts":2}',
 '{"expected":"\"Have you forgotten your bus fare?\" they asked Dinah."}',
 EXTRACT(EPOCH FROM NOW())*1000),
('tii_fam_b_c1_eng_y5_vgp_s2_a',
 'ti_fam_b_c1_eng_y5_vgp_direct_to_reported',
 'titem_eng_y5_vgp_s2_a',
 3, 1, 5*60*1000, NULL,
 '{"prompt":"Act out the nurse''s line, then rewrite it as reported speech in one clear sentence.","text":"\"Good morning, Mr Smith, and how are you feeling?\" asked the nurse.","personalisation":{"learning_style":"auditory","interests":["stories_aloud"]}}',
 '{"mode":"independent","delivery":"read_aloud_then_write","max_attempts":1}',
 '{"expected":"The nurse asked Mr Smith how he was feeling and wished him good morning."}',
 EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;

-- Attempts for Bella on these tasks
INSERT INTO attempts (id, child_id, task_instance_id, task_set_instance_id, task_item_instance_id, attempt_client_id, source, answer_asset_id, strokes_asset_id, score, presentation_score, correct, summary_json, duration_ms, created_at)
VALUES
('att_fam_b_c1_eng_y5_vgp_1', 'ch_fam_b_c1', 'ti_fam_b_c1_eng_y5_vgp_reported_to_direct', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'tii_fam_b_c1_eng_y5_vgp_s1_a', 'cli_fam_b_c1_vgp_1', 'worksheet', NULL, NULL, 0.9, 0.8, true, '{"notes":"Needed one prompt about pronouns; punctuation correct.","feedback_for_parent":"Great job reading the sentence aloud first, then writing it. Next time, let Bella try one on her own before giving a hint."}', 180000, EXTRACT(EPOCH FROM NOW() - INTERVAL '8 minutes')*1000),
('att_fam_b_c1_eng_y5_vgp_2', 'ch_fam_b_c1', 'ti_fam_b_c1_eng_y5_vgp_reported_to_direct', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'tii_fam_b_c1_eng_y5_vgp_s1_b', 'cli_fam_b_c1_vgp_2', 'worksheet', NULL, NULL, 0.7, 0.8, true, '{"notes":"Minor tense slip fixed after reading aloud.","feedback_for_parent":"When Bella hesitates, invite her to say the sentence in her own words first, then write it."}', 210000, EXTRACT(EPOCH FROM NOW() - INTERVAL '6 minutes')*1000),
('att_fam_b_c1_eng_y5_vgp_3', 'ch_fam_b_c1', 'ti_fam_b_c1_eng_y5_vgp_direct_to_reported', 'tsi_fam_b_c1_eng_y5_vgp_speech', 'tii_fam_b_c1_eng_y5_vgp_s2_a', 'cli_fam_b_c1_vgp_3', 'worksheet', NULL, NULL, 0.6, 0.9, false, '{"notes":"Forgot to remove quotation marks on first try; corrected after prompt.","feedback_for_parent":"Highlight how reported speech usually removes the speech marks and shifts pronouns; practise with one extra example later today."}', 240000, EXTRACT(EPOCH FROM NOW() - INTERVAL '4 minutes')*1000)
ON CONFLICT (id) DO NOTHING;

-- Progress snapshot for Bella on the Y5 VGP topic
INSERT INTO progress (id, child_id, topic_id, mastery, attempts_count, last_practiced_at, history_json, created_at, updated_at)
VALUES ('prog_fam_b_c1_eng_y5_vgp', 'ch_fam_b_c1', 'ctop_eng_y5_vgp', 0.65, 3, EXTRACT(EPOCH FROM NOW())*1000, '{"recent_attempts":["att_fam_b_c1_eng_y5_vgp_1","att_fam_b_c1_eng_y5_vgp_2","att_fam_b_c1_eng_y5_vgp_3"],"notes":"Strong engagement when tasks involve reading aloud and acting out dialogue. Avoid long silent worksheets; keep activities short and interactive."}', EXTRACT(EPOCH FROM NOW())*1000, EXTRACT(EPOCH FROM NOW())*1000)
ON CONFLICT (id) DO NOTHING;
