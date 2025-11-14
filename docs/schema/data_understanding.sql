select * from eduapp.curriculum_subjects;
select * from eduapp.curriculum_topics;

-- this can have multiple assets as parents/editors import
-- also some templates will be created by parents which means they will be only visible for their children
-- also you can have tutor which create their own list of the lessons which they can share with children / but also then they can remove them
-- it feels that we can have multiple lesson templates which are related to the same subject from different resources, we have to be able to attributes them to the same group e.g. we can have four different sources, books explaining the same subject e.g. direct and reported speech
select * from eduapp.lesson_templates; 
select * from eduapp.task_templates;
select * from eduapp.task_templates where lesson_template_id = 'lt_eng_y5_vgp_speech_direct_reported';
select * from eduapp.task_set_template_items; 
select * from eduapp.task_set_template_items where task_template_id in ('tt_eng_y5_vgp_punctuate_direct_speech', 'tt_eng_y5_vgp_direct_to_reported', 'tt_eng_y5_vgp_reported_to_direct')


-- curriculum
select * from eduapp.curriculum_subjects;
select * from eduapp.curriculum_topics where id = 'ctop_eng_y5_vgp';
select * from eduapp.lesson_templates where id = 'lt_eng_y5_vgp_speech_direct_reported'; 
select * from eduapp.task_templates where lesson_template_id = 'lt_eng_y5_vgp_speech_direct_reported';
select * from eduapp.task_set_template_items where task_template_id in ('tt_eng_y5_vgp_punctuate_direct_speech', 'tt_eng_y5_vgp_direct_to_reported', 'tt_eng_y5_vgp_reported_to_direct')

-- subscription plans
select * from eduapp.subscription_plans;

-- consents
select * from eduapp.consent_policies;

-- assets 
select * from eduapp.assets;


-- schema
-- - addresses ? maybe
select * from eduapp.users;

-- subscription plan
select * from eduapp.subscription_plans;

-- schema changes:
-- - align naming to the `user_consents` to be `user_subscriptions`
select * from eduapp.user_subscriptions where user_id = 'usr_fam_b_p1';

-- consents
select * from eduapp.consent_policies;
select * from eduapp.user_consents;
select * from eduapp.user_consents where user_id = 'usr_fam_b_p1';

-- child
select * from eduapp.users where id = 'usr_fam_b_p1';

-- access level can't be `owner` that has to be parent 
select * from eduapp.child_access where user_id = 'usr_fam_b_p1';
-- view from child / parent perspective to know who has access to child / profile and their progress
select * from eduapp.child_access where child_id = 'ch_fam_b_c1';
select * from eduapp.children where id = 'ch_fam_b_c1';
select * from eduapp.child_profile where child_id = 'ch_fam_b_c1';
select * from eduapp.child_profile_items where profile_id = 'cprof_fam_b_c1';
select * from eduapp.child_profile_items where profile_id = 'cprof_fam_b_c1_child_voice';
-- request can be done by user or can be made by parent to add to user
select * from eduapp.access_requests where target_child_id = 'ch_fam_b_c1'; 

-- they have to be more descriptive 
select * from eduapp.child_observations;
