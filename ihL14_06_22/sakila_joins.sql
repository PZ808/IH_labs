use sakila;
/* 
   Q1: Which actor has appeared in the most films?
*/
SELECT 
    a.first_name, a.last_name, COUNT(b.film_id) AS total_films
FROM
    actor AS a
		INNER JOIN
    film_actor AS b ON (a.actor_id = b.actor_id)
GROUP BY a.actor_id
ORDER BY total_films DESC
LIMIT 5;
/*
Q2: Most active customer (the customer that has rented the most number of films)
*/
SELECT 
    a.first_name,
    a.last_name,
    COUNT(rental_id) AS total_rentals
FROM
    customer AS a
        INNER JOIN
    rental AS b ON (a.customer_id = b.customer_id)
GROUP BY a.first_name , a.last_name
ORDER BY total_rentals DESC
limit 5;
/* 
 Q3: List number of films per category
*/
SELECT 
    a.name AS cat, COUNT(film_id) AS total_films
FROM
    category AS a
        INNER JOIN
    film_category AS b ON (a.category_id = b.category_id)
GROUP BY cat
ORDER BY total_films asc;
/*
 Q4: Display the first and last names, as well as the address, of each staff member.
*/
SELECT
    a.first_name, a.last_name, b.address
FROM
    staff AS a
        INNER JOIN
    address AS b ON (a.address_id = b.address_id)
LIMIT 2;
/*
Q5: Display the total amount rung up by each staff member in August of 2005.
*/
SELECT 
    payment_date
FROM
    payment
LIMIT 10;

SELECT 
    a.first_name AS firstname,
    a.last_name AS lastname,
    SUM(b.amount) AS total_rungup
FROM
    staff AS a
        INNER JOIN
    payment AS b USING (staff_id)
WHERE
    b.payment_date LIKE '2005-08-%'
GROUP BY firstname , lastname
ORDER BY total_rungup
LIMIT 2;
/*
Q5: List each film and the number of actors who are listed for that film
*/
SELECT 
	a.title as title,
    count(b.actor_id) as num_actors
FROM 
	film as a
		INNER JOIN 
        film_actor as b using (film_id)
GROUP BY 
	title
ORDER BY 
	num_actors DESC;
/*
Using the tables payment and customer and the JOIN command, 
list the total paid by each customer. List the customers alphabetically by last name.
*/	
SELECT 
    a.first_name AS name,
    a.last_name AS lastname,
    SUM(b.amount) AS total_paid
FROM
    customer AS a
        INNER JOIN
    payment AS b USING (customer_id)
GROUP BY a.first_name , a.last_name
ORDER BY a.last_name
LIMIT 10;
/* 
Optional: Which is the most rented film? 
The answer is Bucket Brotherhood This query might require using more than one join statement. Give it a try.
*/
SELECT 
    f.title AS title, COUNT(r.rental_id) AS total_rentals
FROM
    rental AS r
        INNER JOIN
    (inventory AS i) USING (inventory_id)
        INNER JOIN
    (film AS f) USING (film_id)
GROUP BY  title
ORDER BY total_rentals DESC
LIMIT 1;
/* 
Q_op_a: Write a query to display for each store its store ID, city, and country.
*/
SELECT 
	s.store_id, ct.city, cntry.country
FROM
	store as s 
        INNER JOIN 
	(address as a) using (address_id)
		INNER JOIN
	(city as ct) using (city_id)
		INNER JOIN
	(country as cntry) using (country_id);
/*
Q_op_b: Write a query to display how much business, in dollars, each store brought in.
*/
SELECT 
	s.store_id as id, SUM(p.amount)
FROM
	store as s 
        INNER JOIN 
	customer on (s.store_id = customer.store_id)
	INNER JOIN
	(payment as p) on (customer.customer_id = p.customer_id)
 GROUP BY id;
 /* 
  Q_op_c: What is the average running time(length) of films by category?
  */
SELECT 
    cat.name AS cat, ROUND(AVG(f.length), 0)
FROM
    category AS cat
        INNER JOIN
    film_category AS fcat USING (category_id)
        INNER JOIN
    film AS f USING (film_id)
GROUP BY cat;
/* 
 Q_op_d: Which film categories are longest(length)? (Hint: You can rely on question 3 output.)
  */
SELECT 
    cat.name AS cat, ROUND(AVG(f.length), 0) AS len
FROM
    category AS cat
        INNER JOIN
    film_category AS fcat USING (category_id)
        INNER JOIN
    film AS f USING (film_id)
GROUP BY cat
ORDER BY len DESC;
/* 
Q_op_e: Display the most frequently(number of times) rented movies in descending order.
*/
SELECT 
	f.title as title, COUNT(rental_id) as num_rentals
FROM
	film as f
		INNER JOIN 
	inventory as i USING(film_id)
		INNER JOIN
	rental as r USING(inventory_id)
GROUP BY title
ORDER BY num_rentals DESC;
/* 
Q_op_f: List the top five genres in gross revenue in descending order.
*/
SELECT 
    c.name AS genre, SUM(p.amount) AS amount
FROM
    category AS c
        INNER JOIN
    film_category AS fcat USING (category_id)
        INNER JOIN
    film AS f USING (film_id)
        INNER JOIN
    inventory AS inv USING (film_id)
        INNER JOIN
    rental AS r USING (inventory_id)
        INNER JOIN
    payment AS p USING (rental_id)
GROUP BY genre
ORDER BY amount DESC;
/*
Q_op_g: Is "Academy Dinosaur" available for rent from Store 1?
*/    
SELECT 
     f.title AS title, COUNT(s.store_id) AS num_copies
FROM
    store AS s
        INNER JOIN
    inventory USING (store_id)
        INNER JOIN
    film AS f USING (film_id)
WHERE
    f.title = 'Academy Dinosaur' AND s.store_id = 1
GROUP BY 
	title
    
    
    
	
