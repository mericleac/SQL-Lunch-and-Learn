SHOW indexes FROM actor;

SELECT * FROM actor WHERE last_name = "WILLIAMS";

INSERT INTO actor (first_name, last_name, last_update)
VALUES ("MANDY", "MERICLE", NOW());

CREATE INDEX idx_actor_last_name ON actor (last_name);

SELECT * FROM actor WHERE last_name = "WILLIAMS";

INSERT INTO actor (first_name, last_name, last_update)
VALUES ("MIKE", "OLSON", NOW());

DROP INDEX idx_actor_last_name ON actor;
