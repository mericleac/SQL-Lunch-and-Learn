USE sakila;

-- Retrieve film_id and length of the film where length is less than 50 mins and 100 mins

SELECT *
FROM film;

-- Unindexed SELECT query
SELECT *
FROM film
WHERE length < 50;

EXPLAIN SELECT *
FROM film
WHERE length < 50;

-- Add index to film and EXPLAIN again
ALTER TABLE film
ADD KEY idx_length (length);

-- MySQL will not use index if result set is larger
SELECT *
FROM film
WHERE length < 100;

EXPLAIN SELECT *
FROM film
WHERE length < 100;

-- We can fix this by limiting the returned columns
SELECT film_id, length
FROM film
WHERE length < 100;

EXPLAIN SELECT film_id, length
FROM film
WHERE length < 100;

ALTER TABLE film
DROP KEY idx_length; 
