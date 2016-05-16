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