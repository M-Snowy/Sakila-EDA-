-- CHANDOO ADVANCED SQL

SELECT * FROM sakila.film;
-------------------------------------------------------------------------------------
-- 1. All films with PG-13 films with rental rate of 2.99 or lower
SELECT *
FROM sakila.film
WHERE rating LIKE "PG-13" AND rental_rate <= 2.99
Order by rental_rate;

-----------------------------------------------------------------------------------
-- 2. All films that have deleted scenes
SELECT *
FROM sakila.film
WHERE special_features LIKE "%Deleted Scenes%";

--------------------------------------------------------------------------------
-- 3. All active customers
SELECT *
FROM sakila.customer
WHERE active = 1;

---------------------------------------------------------------------------------------------------------------------
-- 4. Names of customers who rented a movie on 26th July 2005
SELECT c.customer_id, concat(c.first_name,' ', c.last_name) AS Name,r.rental_id, r.rental_date
FROM sakila.customer c
JOIN sakila.rental r
WHERE date(r.rental_date) like "2005-07-26";

---------------------------------------------------------------------------------------------------
-- 5. Distinct names of customers who rented a movie on 26th July 2005
SELECT distinct(c.customer_id), concat(first_name,' ', last_name) AS Name,  rental_date
FROM sakila.customer c
JOIN sakila.rental r
WHERE date(r.rental_date) like "2005-07-26";

--------------------------------------------------------------------------------------------
-- 6. How many rentals we do on each day?
SELECT date(rental_date),count(*)
FROM sakila.rental
GROUP BY date(rental_date);

----------------------------------------------------------------------------------------
-- 7. All Sci-fi films in our catalogue
SELECT f.title, c.name
FROM sakila.category c
JOIN sakila.film_category cf
On c.category_id = cf.category_id
JOIN sakila.film f
ON cf.film_id = f.film_id
WHERE c.name like "Sci-Fi";

----------------------------------------------------------------------------------------------
-- 8. Customers and how many movies they rented from us so far?
SELECT last_name,first_name,count(rental_id) as Num_Rented
FROM sakila.customer c
JOIN sakila.rental r
ON c.customer_id = r.customer_id
group by first_name, last_name
ORDER BY count(rental_id);

-------------------------------------------------------------------------------------------------
-- 9. Which movies should we discontinue from our catalogue (less than 2 lifetime rentals)
WITH low_rentals AS (
		SELECT i.film_id, count(*)
        FROM sakila.rental r
        JOIN sakila.inventory i
        ON r.inventory_id = i.inventory_id
        GROUP BY i.film_id
        HAVING count(*) <= 5
        )
SELECT l.film_id, f.title
FROM low_rentals l
JOIN film f
ON l.film_id = f.film_id;

------------------------------------------------------------------------------------------
-- 10. Which movies are not returned yet?
SELECT r.rental_date, r.customer_id, i.film_id, f.title, r.return_date
FROM sakila.rental r 
JOIN sakila.inventory i 
ON r.inventory_id = i.inventory_id
JOIN sakila.film f
ON f.film_id = i.film_id
WHERE r.return_date IS NULL
ORDER BY f.title;

