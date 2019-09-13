SELECT *
FROM actor a, film_actor fa, film f
WHERE a.first_name = "ED"
AND f.rating = "G";

/*
SELECT *
FROM actor a, film_actor fa, film f
WHERE a.first_name = "ED"
AND a.actor_id = fa.actor_id
AND fa.film_id = f.film_id
AND f.rating = "G"; -- This could also be on line 9, the optimzer will still execute it with the Key Lookup on the film table
*/
