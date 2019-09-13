USE sakila;

-- Return all the actors and categories for one film
-- One query
SELECT *
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN film_category fc ON fc.film_id = fa.film_id
WHERE f.film_id = 10;
SHOW STATUS LIKE 'Last_Query_Cost';

-- Multiple queries
SELECT *
FROM film
WHERE film_id = 10;
SHOW STATUS LIKE 'Last_Query_Cost';

SELECT * 
FROM film_actor
WHERE film_id = 10;
SHOW STATUS LIKE 'Last_Query_Cost';

SELECT *
FROM film_category
WHERE film_id = 10;
SHOW STATUS LIKE 'Last_Query_Cost';

-- Complex Query = 10.799000
-- Multiple Queries = 2.39900 + 2.39900 + 2.39900 = 7.197000 

-- Remember that things like connection to the MySQL server 
-- and finding the best execution path must happen for every query

-- Return all the inventory for one film from stores with their address
-- One query
SELECT *
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN store s ON s.store_id = i.store_id
INNER JOIN address a ON a.address_id = s.address_id
WHERE f.film_id = 10;
SHOW STATUS LIKE 'Last_Query_Cost';

-- Multiple queries
SELECT *
FROM film
WHERE film_id = 10;
SHOW STATUS LIKE 'Last_Query_Cost';

SELECT *
FROM inventory
WHERE film_id = 10;
SHOW STATUS LIKE 'Last_Query_Cost';

SELECT *
FROM store
WHERE store_id in (1, 2);
SHOW STATUS LIKE 'Last_Query_Cost';

SELECT *
FROM address
WHERE store_id in (1, 2);
SHOW STATUS LIKE 'Last_Query_Cost';

-- Complex Query = 6.199000
-- Multiple Queries = 2.399000 + 2.399000 + 2.399000 = 7.197000


-- With Indexes
 
-- Retrieve all columns of the table film where length is less than 80 min

SELECT *
FROM film
WHERE length < 80;
SHOW STATUS LIKE 'Last_Query_Cost';

EXPLAIN SELECT *
FROM film
WHERE length < 80;


ALTER TABLE film
ADD KEY idx_length (length);

EXPLAIN SELECT *
FROM film
WHERE length < 80;


EXPLAIN SELECT *
FROM film
WHERE length < 61;

EXPAIN SELECT *
FROM film
WHERE length >= 61 AND length <= 79;


SELECT *
FROM film
WHERE length < 80;
SHOW STATUS LIKE 'Last_Query_Cost';

SELECT *
FROM film
WHERE length < 61;
SHOW STATUS LIKE 'Last_Query_Cost';

SELECT *
FROM film
WHERE length >= 61 AND length <= 79;
SHOW STATUS LIKE 'Last_Query_Cost';

ALTER TABLE film
DROP KEY idx_length;
