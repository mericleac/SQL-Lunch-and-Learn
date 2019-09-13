USE sakila;

-- SubQuery (IN)
SELECT *
FROM film f
WHERE f.film_id IN (
    SELECT i.film_id
    FROM inventory i
    WHERE inventory_id < 555
);

EXPLAIN SELECT *
FROM film f
WHERE f.film_id IN (
    SELECT i.film_id
    FROM inventory i
    WHERE inventory_id < 555
);
SHOW STATUS LIKE 'Last_Query_Cost';

-- EXISTS
-- IN compares all records fetched from the inner query,
-- while exists returns true or false stopping at the first match
SELECT *
FROM film f
WHERE EXISTS (
    SELECT i.film_id
    FROM inventory i
    WHERE inventory_id < 555
    AND i.film_id = f.film_id
);

EXPLAIN SELECT *
FROM film f
WHERE EXISTS (
    SELECT i.film_id
    FROM inventory i
    WHERE inventory_id < 555
    AND i.film_id = f.film_id
);
SHOW STATUS LIKE 'Last_Query_Cost';

-- JOIN 
SELECT DISTINCT f.*
FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
WHERE inventory_id < 555;

EXPLAIN SELECT DISTINCT f.*
FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
WHERE inventory_id < 555;
SHOW STATUS LIKE 'Last_Query_Cost';


-- Testing different queries with stored proceedures
CREATE TABLE `filmcopy` (
    `film_id` smallint(5) unsigned NOT NULL,
    `title` varchar(255) NOT NULL,
    `description` text,
    `release_year` year(4) DEFAULT NULL,
    `language_id` tinyint(3) unsigned NOT NULL,
    `original_language_id` tinyint(3) unsigned DEFAULT NULL,
    `rental_duration` tinyint(3) unsigned NOT NULL DEFAULT '3',
    `rental_rate` decimal(4, 2) NOT NULL DEFAULT '4.99',
    `length` smallint(5) unsigned DEFAULT NULL,
    `replacement_cost` decimal(5, 2) NOT NULL DEFAULT '19.99',
    `rating` enum('G', 'PG', 'PG-13', 'R', 'NC-17') DEFAULT 'G',
    `special_features` set('Trailers', 'Commentaries', 'Deleted Scenes', 'Behind the Scenes') DEFAULT NULL,
    `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

delimiter //
CREATE PROCEDURE SubQuery(p1 INT)
BEGIN
    label1: LOOP
        SET p1 = p1 - 1;
        IF p1 > 0 THEN
            INSERT INTO `sakila`.`filmcopy`
            (`film_id`,
            `title`,
            `description`,
            `release_year`,
            `language_id`,
            `original_language_id`,
            `rental_duration`,
            `rental_rate`,
            `length`,
            `replacement_cost`,
            `rating`,
            `special_features`,
            `last_update`)
            SELECT *
            FROM film f
            WHERE f.film_id IN (
                SELECT i.film_id
                FROM inventory i
                WHERE inventory_id < 555
            );
			ITERATE label1;
		END IF;
		LEAVE label1;
	END LOOP label1;
END//
delimiter ;

delimiter //
CREATE PROCEDURE ExistsQuery(p1 INT)
BEGIN
    label1: LOOP
        SET p1 = p1 - 1;
        IF p1 > 0 THEN
            INSERT INTO `sakila`.`filmcopy`
            (`film_id`,
            `title`,
            `description`,
            `release_year`,
            `language_id`,
            `original_language_id`,
            `rental_duration`,
            `rental_rate`,
            `length`,
            `replacement_cost`,
            `rating`,
            `special_features`,
            `last_update`)
            SELECT *
            FROM film f
            WHERE EXISTS (
                SELECT i.film_id
                FROM inventory i
                WHERE inventory_id < 555
                AND i.film_id = f.film_id
            );
        ITERATE label1;
    END IF;
    LEAVE label1;
END LOOP label1;
END//
delimiter ;

delimiter //
CREATE PROCEDURE JoinQuery(p1 INT)
BEGIN
    label1: LOOP
        SET p1 = p1 - 1;
        IF p1 > 0 THEN
            INSERT INTO `sakila`.`filmcopy`
            (`film_id`,
            `title`,
            `description`,
            `release_year`,
            `language_id`,
            `original_language_id`,
            `rental_duration`,
            `rental_rate`,
            `length`,
            `replacement_cost`,
            `rating`,
            `special_features`,
            `last_update`)
            SELECT DISTINCT f.*
            FROM film f
            INNER JOIN inventory i ON i.film_id = f.film_id
            WHERE inventory_id < 555;
        ITERATE label1;
    END IF;
    LEAVE label1;
END LOOP label1;
END//
delimiter ;

-- Test query loops
CALL SubQuery(1000);
TRUNCATE TABLE `sakila`.`filmcopy`;

CALL ExistsQuery(1000);
TRUNCATE TABLE `sakila`.`filmcopy`;

CALL JoinQuery(1000);
TRUNCATE TABLE `sakila`.`filmcopy`;

-- Clean up
DROP PROCEDURE SubQuery;
DROP PROCEDURE ExistsQuery;
DROP PROCEDURE JoinQuery;
DROP TABLE `sakila`.`filmcopy`;
