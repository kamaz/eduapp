SET search_path=public;

select * from public.curriculum_subjects;
select * from public.curriculum_topics;

-- Lesson templates and tasks
select * from public.lesson_templates;
select * from public.task_templates;
select * from public.task_templates where lesson_template_id = 'lt_eng_y5_vgp_speech_direct_reported';
select * from public.task_set_template_items;
select * from public.task_set_template_items where task_template_id in (
  'tt_eng_y5_vgp_punctuate_direct_speech',
  'tt_eng_y5_vgp_direct_to_reported',
  'tt_eng_y5_vgp_reported_to_direct'
);

-- Curriculum
select * from public.curriculum_subjects;
select * from public.curriculum_topics where id = 'ctop_eng_y5_vgp';

-- Template lessons and tasks
select * from public.lesson_templates where id = 'lt_eng_y5_vgp_speech_direct_reported';
select * from public.task_set_templates where lesson_template_id = 'lt_eng_y5_vgp_speech_direct_reported';
select * from public.task_templates where set_template_id = 'tst_eng_y5_vgp_speech';
select * from public.task_item_templates where task_template_id in (
  'tt_eng_y5_vgp_punctuate_direct_speech',
  'tt_eng_y5_vgp_direct_to_reported',
  'tt_eng_y5_vgp_reported_to_direct'
);

-- Subscription plans
select * from public.subscription_plans;

-- Consents
select * from public.consent_policies;

-- Assets
select * from public.assets;

-- Users
select * from public.users;

-- User subscriptions
select * from public.subscription_plans;
select * from public.user_subscriptions where user_id = 'usr_fam_b_p1';

-- Consents
select * from public.consent_policies;
select * from public.user_consents;
select * from public.user_consents where user_id = 'usr_fam_b_p1';

-- Child
select * from public.users where id = 'usr_fam_b_p1';
select * from public.child_access where user_id = 'usr_fam_b_p1';
select * from public.child_access where child_id = 'ch_fam_b_c1';
select * from public.children where id = 'ch_fam_b_c1';
select * from public.child_profile where child_id = 'ch_fam_b_c1';
select * from public.child_profile_items where profile_id = 'cprof_fam_b_c1';
select * from public.child_profile_items where profile_id = 'cprof_fam_b_c1_child_voice';
select * from public.access_requests where target_child_id = 'ch_fam_b_c1';
select * from public.child_observations;

-- Instances
select * from public.lesson_instances where id = 'li_fam_b_c1_eng_y5_vgp_speech_1';
select * from public.task_set_instances where id = 'tsi_fam_b_c1_eng_y5_vgp_speech';
select * from public.task_set_instances;
select * from public.task_instances where task_set_instance_id = 'tsi_fam_b_c1_eng_y5_vgp_speech';
select * from public.task_item_instances where task_instance_id in (
  'ti_fam_b_c1_eng_y5_vgp_punctuate',
  'ti_fam_b_c1_eng_y5_vgp_direct_to_reported',
  'ti_fam_b_c1_eng_y5_vgp_reported_to_direct'
);
