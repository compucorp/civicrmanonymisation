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

-- Update Field Data Table values.
DELIMITER $$
DROP PROCEDURE IF EXISTS update_field_data$$
CREATE PROCEDURE update_field_data ()
BEGIN
 DECLARE finished INTEGER DEFAULT 0;
 DECLARE field_name_value varchar(100) DEFAULT "";
 DECLARE prefixed_field_name varchar(100) DEFAULT "";
 DECLARE field_data_column_name varchar(100) DEFAULT "";

 -- declare cursor for field data tables of type text and field name that contains field_data_* as prefixed.
 DECLARE field_cursor CURSOR FOR
 SELECT field_name FROM field_config where type IN ('text', 'text_long') AND (field_name LIKE 'field_%' OR field_name = 'comment_body');

 -- declare NOT FOUND handler
 DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finished = 1;

 OPEN field_cursor;
 get_field_list: LOOP
 FETCH field_cursor INTO field_name_value;

 IF finished = 1 THEN
 LEAVE get_field_list;
 END IF;

 -- Prepare statement and Update field data values.
 SET prefixed_field_name = CONCAT('field_data_', field_name_value);
 SET field_data_column_name = CONCAT(field_name_value, '_value');

 SET @field_update_stmt = CONCAT('UPDATE ', prefixed_field_name , ' SET ', field_data_column_name , ' = "Anonymous"');
 PREPARE stmt1 FROM @field_update_stmt;
 EXECUTE stmt1;
 DEALLOCATE PREPARE stmt1;

 -- Prepare statement and Update field revision values.
 SET prefixed_field_name = CONCAT('field_revision_', field_name_value);

 SET @field_update_stmt = CONCAT('UPDATE ', prefixed_field_name , ' SET ', field_data_column_name , ' = "Anonymous"');
 PREPARE stmt1 FROM @field_update_stmt;
 EXECUTE stmt1;
 DEALLOCATE PREPARE stmt1;

 END LOOP get_field_list;
 CLOSE field_cursor;
END$$
DELIMITER ;

-- Update Field Data Table values - for fields of type 'long text with summary'.
DELIMITER $$
DROP PROCEDURE IF EXISTS update_field_data_with_summary$$
CREATE PROCEDURE update_field_data_with_summary ()
BEGIN
 DECLARE finished INTEGER DEFAULT 0;
 DECLARE field_name_value varchar(100) DEFAULT "";
 DECLARE prefixed_field_name varchar(100) DEFAULT "";
 DECLARE field_data_column_name varchar(100) DEFAULT "";
 DECLARE field_summary_column_name varchar(100) DEFAULT "";

 -- declare cursor for field data tables of type text and field name that contains field_data_* as prefixed.
 DECLARE field_cursor CURSOR FOR
 SELECT field_name FROM field_config where type = 'text_with_summary' AND (field_name LIKE 'field_%' OR field_name = 'body');

 -- declare NOT FOUND handler
 DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finished = 1;

 OPEN field_cursor;
 get_field_list: LOOP
 FETCH field_cursor INTO field_name_value;

 IF finished = 1 THEN
 LEAVE get_field_list;
 END IF;

 -- Prepare statement and Update field data values.
 SET prefixed_field_name = CONCAT('field_data_', field_name_value);
 SET field_data_column_name = CONCAT(field_name_value, '_value');
 SET field_summary_column_name = CONCAT(field_name_value, '_summary');

 SET @field_update_stmt = CONCAT('UPDATE ', prefixed_field_name , ' SET ', field_data_column_name , ' = "Anonymous", ', field_summary_column_name , ' = "Anonymous"');
 PREPARE stmt1 FROM @field_update_stmt;
 EXECUTE stmt1;
 DEALLOCATE PREPARE stmt1;

 -- Prepare statement and Update field revision values.
 SET prefixed_field_name = CONCAT('field_revision_', field_name_value);

 SET @field_update_stmt = CONCAT('UPDATE ', prefixed_field_name , ' SET ', field_data_column_name , ' = "Anonymous", ', field_summary_column_name , ' = "Anonymous"');
 PREPARE stmt1 FROM @field_update_stmt;
 EXECUTE stmt1;
 DEALLOCATE PREPARE stmt1;

 END LOOP get_field_list;
 CLOSE field_cursor;
END$$
DELIMITER ;

-- Call field update procedure.
CALL update_field_data();
CALL update_field_data_with_summary();
