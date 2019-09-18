DESCRIBE actor;

SHOW COLUMNS FROM actor;

-- 1. Right click on actor table, Copy to Clipboard => Select All Statement, Remove unwanted row

-- 2. Create a user variable for column names replacing the unwanted one and then prepare a SQL statement
SELECT @col_names := REPLACE(group_concat(COLUMN_NAME), 'first_name', '') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'actor' AND TABLE_SCHEMA = 'sakila';
SET @sql := CONCAT('SELECT ', @col_names, ' FROM actor');
SELECT @sql;
PREPARE stmt1 FROM @sql; 
EXECUTE stmt1;

-- 3. Create a temporary table, drop the unwanted column, then SELECT from temp table
CREATE temporary table temp_table SELECT * FROM actor WHERE actor_id = 10;
ALTER TABLE temp_table DROP first_name;
SELECT * FROM temp_table;
DROP TABLE temp_table;

