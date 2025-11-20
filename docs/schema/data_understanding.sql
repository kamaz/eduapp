select * from eduapp.curriculum_subjects;
select * from eduapp.curriculum_topics;

-- this can have multiple assets as parents/editors import
-- also some templates will be created by parents which means they will be only visible for their children
-- also you can have tutor which create their own list of the lessons which they can share with children / but also then they can remove them
-- it feels that we can have multiple lesson templates which are related to the same subject from different resources, we have to be able to attributes them to the same group e.g. we can have four different sources, books explaining the same subject e.g. direct and reported speech
select * from eduapp.lesson_templates; 
select * from eduapp.task_set_templates;
select * from eduapp.task_templates;
select * from eduapp.task_item_templates;
select * from eduapp.task_templates where set_template_id = 'tst_eng_y5_vgp_speech';
select * from eduapp.task_item_templates where task_template_id in ('tt_eng_y5_vgp_punctuate_direct_speech', 'tt_eng_y5_vgp_direct_to_reported', 'tt_eng_y5_vgp_reported_to_direct');


-- curriculum
select * from eduapp.curriculum_subjects;
select * from eduapp.curriculum_topics where id = 'ctop_eng_y5_vgp';
select * from eduapp.lesson_templates where id = 'lt_eng_y5_vgp_speech_direct_reported'; 
select * from eduapp.task_set_templates where lesson_template_id = 'lt_eng_y5_vgp_speech_direct_reported';
select * from eduapp.task_templates where set_template_id = 'tst_eng_y5_vgp_speech';
select * from eduapp.task_item_templates where task_template_id in ('tt_eng_y5_vgp_punctuate_direct_speech', 'tt_eng_y5_vgp_direct_to_reported', 'tt_eng_y5_vgp_reported_to_direct');

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

-- now we have to focus on instance and attempts 
-- seed
-- - `title` don't prefix with child name but instead create a personalised title based on the their profile and interest already defined in seed data
-- schema
-- - missing reference to the template from which this was created 
-- - not sure we need asset_id as that is going to be on the template
select * from eduapp.lesson_instances where id = 'li_fam_b_c1_eng_y5_vgp_speech_1';

select * from eduapp.task_set_instance_lessons where lesson_instance_id = 'li_fam_b_c1_eng_y5_vgp_speech_1';

-- schema:
-- - not sure why do we need expected_answer_json ?
-- - not sure why do we have solution_asset_id
select * from eduapp.task_instances;

-- seed
-- title shouldn't be prefixed with child name but just a title from the template 
-- `description` would be actually personalised to child age and profile and what they like and don't like instead of copy of the text from template 
select * from eduapp.task_set_instances;



select * from eduapp.task_set_instance_items;

-- Can you describe relation between lesson_instances, task_set_instance_lessons, task_instances, task_set_instances and task_set_instance_items. It doesn't feel is correct. 


-- application can ask what happened in child life and create tasks related to that for example child eat in Wagamma and create sentences related to that 

-- when we craete something ideally we would save prompt with all the values so we can understand what when wrong 



-- TODO: new feature which will allow to child create test sentences for child so they can understand the work and then ask them to create new sentences using that word
-- TODO: new feature help child to find root word 
-- TODO: new feature help child to define word class
