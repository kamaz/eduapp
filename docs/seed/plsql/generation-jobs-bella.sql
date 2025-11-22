-- Seed: Example generation request and jobs for Bella (Family B, Y5 VGP speech worksheet)
set search_path=eduapp,public;

-- Generation request submitted by Bella's parent to create a personalised speech worksheet
INSERT INTO generation_requests (id, requested_by_user_id, target_child_id, source, intent, notes, idempotency_key, status, created_at, updated_at, completed_at)
VALUES (
  'grq_fam_b_c1_eng_y5_vgp_speech_1',
  'usr_fam_b_p1',
  'ch_fam_b_c1',
  'app_prompt',
  'create_tasks',
  'Create a personalised direct and reported speech practice set for Bella, using her profile (auditory, loves funny stories and acting out dialogue) and the Y5 VGP curriculum objectives.',
  'idem_fam_b_c1_eng_y5_vgp_speech_1',
  'completed',
  EXTRACT(EPOCH FROM NOW() - INTERVAL '20 minutes')*1000,
  EXTRACT(EPOCH FROM NOW())*1000,
  EXTRACT(EPOCH FROM NOW() - INTERVAL '10 minutes')*1000
)
ON CONFLICT (id) DO NOTHING;

-- Generation job representing the main task-set generation flow
INSERT INTO jobs (id, request_id, child_id, kind, status, idempotency_key, run_at, attempts, input_asset_id, output_asset_id, error_asset_id, error_code, error_message_redacted, created_at, updated_at)
VALUES (
  'job_fam_b_c1_eng_y5_vgp_speech_gen',
  'grq_fam_b_c1_eng_y5_vgp_speech_1',
  'ch_fam_b_c1',
  'generation',
  'succeeded',
  'jobidem_fam_b_c1_eng_y5_vgp_speech_gen',
  EXTRACT(EPOCH FROM NOW() - INTERVAL '18 minutes')*1000,
  1,
  'ast_eng_y5_vgp_speech_sheet_jpg',  -- source worksheet asset from English Y5 seeds
  NULL,
  NULL,
  NULL,
  NULL,
  EXTRACT(EPOCH FROM NOW() - INTERVAL '18 minutes')*1000,
  EXTRACT(EPOCH FROM NOW() - INTERVAL '10 minutes')*1000
)
ON CONFLICT (id) DO NOTHING;

-- Job steps showing OCR/extract + task generation pipeline
INSERT INTO job_steps (id, job_id, step_kind, status, input_asset_id, output_asset_id, error_code, error_message_redacted, created_at, updated_at)
VALUES
  (
    'js_fam_b_c1_eng_y5_vgp_speech_ocr',
    'job_fam_b_c1_eng_y5_vgp_speech_gen',
    'ocr',
    'succeeded',
    'ast_eng_y5_vgp_speech_sheet_jpg',
    NULL,
    NULL,
    NULL,
    EXTRACT(EPOCH FROM NOW() - INTERVAL '18 minutes')*1000,
    EXTRACT(EPOCH FROM NOW() - INTERVAL '17 minutes')*1000
  ),
  (
    'js_fam_b_c1_eng_y5_vgp_speech_generate_tasks',
    'job_fam_b_c1_eng_y5_vgp_speech_gen',
    'generate_tasks',
    'succeeded',
    NULL,
    NULL,
    NULL,
    NULL,
    EXTRACT(EPOCH FROM NOW() - INTERVAL '17 minutes')*1000,
    EXTRACT(EPOCH FROM NOW() - INTERVAL '12 minutes')*1000
  ),
  (
    'js_fam_b_c1_eng_y5_vgp_speech_schedule_lesson',
    'job_fam_b_c1_eng_y5_vgp_speech_gen',
    'schedule_lesson',
    'succeeded',
    NULL,
    NULL,
    NULL,
    NULL,
    EXTRACT(EPOCH FROM NOW() - INTERVAL '12 minutes')*1000,
    EXTRACT(EPOCH FROM NOW() - INTERVAL '10 minutes')*1000
  )
ON CONFLICT (id) DO NOTHING;

