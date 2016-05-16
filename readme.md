##Execute with CiviCRM Database


UPDATE civicrm_contact INNER JOIN civicrm_contact AS c2 ON civicrm_contact.id = c2.id SET civicrm_contact.sort_name = CONCAT( 'Anonymous', ', ', c2.id ) WHERE civicrm_contact.id = c2.id;

UPDATE civicrm_contact INNER JOIN civicrm_contact AS c2 ON civicrm_contact.id = c2.id SET civicrm_contact.display_name = CONCAT( c2.id, ' ', 'Anonymous' ) WHERE civicrm_contact.id = c2.id;

UPDATE civicrm_contact INNER JOIN civicrm_contact AS c2 ON civicrm_contact.id = c2.id SET civicrm_contact.last_name = 'Anonymous' WHERE civicrm_contact.id = c2.id;

UPDATE civicrm_contact INNER JOIN civicrm_contact AS c2 ON civicrm_contact.id = c2.id SET civicrm_contact.first_name = c2.id WHERE civicrm_contact.id = c2.id;

UPDATE civicrm_contact SET birth_date = STR_TO_DATE('01,1,1999','%d,%m,%Y');

UPDATE civicrm_address SET street_address = 'Anonymous', supplemental_address_1 = 'Anonymous', postal_code = 'Anonymous';

UPDATE civicrm_address SET postal_code = null,postal_code_suffix = null,geo_code_1 = null,geo_code_2 = null;

UPDATE civicrm_contact SET email_greeting_display = 'Dear Anonymous', addressee_display = 'Anonymous , Anonymous';

UPDATE civicrm_contact SET postal_greeting_display = 'Dear Anonymous', addressee_display = 'Anonymous , Anonymous';
UPDATE civicrm_email INNER JOIN civicrm_email AS e2 ON civicrm_email.id = e2.id SET civicrm_email.email = CONCAT( e2.id ,'@','example.com' ) WHERE civicrm_email.id = e2.id;
UPDATE civicrm_phone SET phone = md5(phone);
UPDATE civicrm_note SET note = md5(note), subject = md5(subject);
UPDATE `civicrm_payment_processor` cpp SET cpp.`user_name` = 'anonymised', cpp.`password` = 'anonymised', cpp.`signature` = 'anonymised' WHERE cpp.`user_name` NOT LIKE '%dummy%';

##Execute with Drupal Database

UPDATE users
INNER JOIN users AS e2 ON users.uid = e2.uid
SET users.mail = CONCAT( e2.uid ,'@','example.com' ), users.init = CONCAT( e2.uid ,'@','example.com' )
WHERE users.uid = e2.uid;
UPDATE users AS e1
INNER JOIN users AS e2 
ON e1.uid = e2.uid 
SET e1.name = CONCAT('Anonymous', e2.uid)
WHERE e1.uid != 0 AND
      e1.uid NOT IN (SELECT DISTINCT uid FROM users_roles ur LEFT JOIN role r ON ur.rid = r.rid WHERE r.name = 'administrator');
 
-- delete BAM source, profile, destination and schedules 

DELETE FROM  backup_migrate_destinations;
DELETE FROM  backup_migrate_profiles;
DELETE FROM  backup_migrate_schedules;
DELETE FROM  backup_migrate_sources;

-- Disable BAM
UPDATE system SET status='0' WHERE name='backup_migrate';
