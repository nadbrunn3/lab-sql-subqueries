# Lab | SQL Subqueries 3.03

USE sakila;


-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

SELECT i.film_id, COUNT(i.inventory_id)
FROM sakila.inventory i
WHERE i.film_id = 
		(SELECT film_id
		FROM sakila.film
		WHERE title = 'Hunchback Impossible')
GROUP BY i.film_id;


-- 2. List all films whose length is longer than the average of all the films.


SELECT title
FROM sakila.film
WHERE length > 
		(SELECT round(AVG(length),2)
		FROM sakila.film);
        
-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

SELECT CONCAT(a.first_name, ' ', a.last_name)
FROM sakila.actor a
JOIN sakila.film_actor fa
ON a.actor_id = fa.actor_id
WHERE fa.film_id = 
		(SELECT f.film_id
		FROM sakila.film f
		WHERE f.title = 'Alone Trip');

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT f.title 
FROM sakila.film f
	JOIN sakila.film_category fc
	ON f.film_id = fc.film_id
	JOIN sakila.category c
	ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT CONCAT(c.first_name, ' ', c.last_name), c.email
FROM sakila.customer c
	JOIN sakila.address a
	ON c.address_id = a.address_id
	JOIN sakila.city ci 
	ON a.city_id = ci.city_id
	JOIN sakila.country co
	ON ci.country_id = co.country_id
WHERE co.country = 'Canada';



SELECT CONCAT(c.first_name, ' ', c.last_name), c.email
FROM sakila.customer c
WHERE address_id = ANY (

		SELECT a.address_id
		FROM sakila.address a
		WHERE a.city_id = ANY (
        
		SELECT ci.city_id
		FROM sakila.country co
		JOIN sakila.city ci
		ON co.country_id = ci.country_id
		WHERE co.country = "Canada")                
		);


-- 6. Which are films starred by the most prolific actor? 


SELECT f.title
FROM sakila.film f
JOIN sakila.film_actor fa
ON f.film_id = fa.film_id
WHERE fa.actor_id = (

		SELECT fa.actor_id
		FROM sakila.film_actor fa
        GROUP BY fa.actor_id
		ORDER BY COUNT(fa.film_id) DESC
		LIMIT 1);


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT f.title 
FROM sakila.film f
JOIN sakila.inventory i
ON f.film_id = i.film_id
WHERE i.inventory_id =  ANY (

	SELECT r.inventory_id
	FROM sakila.rental r
	WHERE r.customer_id = (

			SELECT c.customer_id
			FROM sakila.customer c
			JOIN sakila.payment p
			ON c.customer_id = p.customer_id
			GROUP BY c.customer_id
			ORDER BY SUM(p.amount) DESC
			LIMIT 1));


-- 8. Customers who spent more than the average payments.

SELECT CONCAT(c.first_name, ' ', c.last_name) as customer, ROUND(AVG(p.amount), 2) avg
FROM sakila.customer c
JOIN sakila.payment p 
ON c.customer_id = p.customer_id
GROUP BY customer
HAVING avg > (
		SELECT ROUND(AVG(p.amount), 2) 
		FROM sakila.payment p);







