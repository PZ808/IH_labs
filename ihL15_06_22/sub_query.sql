/* Get the customers that borrowed more than the average amount of all the customers */
USE bank;
SELECT 
    account_id, SUM(amount) AS borrowed_amt
FROM
    loan
GROUP BY account_id
HAVING borrowed_amt > (SELECT 
        AVG(amount)
    FROM
        loan);
/* 
Get for each account, the total amount transferred, destination bank and destination account, which are above 10K
*/
SELECT 
    account_id,
    SUM(amount) total_amt_transferred,
    bank_to,
    account_to
FROM
    bank.order
GROUP BY account_id , bank_to , account_to
HAVING total_amt_transferred > 10000;

SELECT 
    *
FROM
    (SELECT 
        account_id,
            SUM(amount) total_amt_transferred,
            bank_to,
            account_to
    FROM
        bank.order
    GROUP BY account_id , bank_to , account_to) AS sub
WHERE
    sub.total_amt_transferred > 10000;

/* Which transactions of bank.trans are in the list (In this query we are trying to find the
k_symbols based on the average amount from the table order. 
The average amount should be more than 3000) */
SELECT 
    k_symbol, ROUND(AVG(amount), 2) AS average
FROM
    bank.order
WHERE
    k_symbol NOT IN ('' , ' ')
GROUP BY k_symbol
HAVING average > 3000;

SELECT 
    *
FROM
    bank.trans
WHERE
    k_symbol IN (SELECT 
            k_symbol
        FROM
            (SELECT 
                AVG(amount) AS Average, k_symbol
            FROM
                bank.order
            WHERE
                k_symbol NOT IN ('' , ' ')
            GROUP BY k_symbol
            HAVING Average > 3000) AS filtered_ksymbols);

### Re-writing with WITH
WITH filtered_ksymbols as
(select k_symbol from 
    (select avg(amount) as Average, k_symbol from bank.order
    where k_symbol not in ('',' ')
    group by k_symbol
    having Average > 3000) as p
)
SELECT * from bank.trans
where k_symbol in (select k_symbol from filtered_ksymbols);
/*
*
* LABS 
*
*/
use sakila;
SELECT 
    film_id, COUNT(film_id) AS num_files
FROM
    inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback impossible')
GROUP BY film_id;
/* 
    List all films whose length is longer than the average of all the films.
*/
USE sakila;
SELECT 
    film_id, title, length
FROM
    film
GROUP BY film_id , film_id
HAVING length > (SELECT 
        AVG(length)
    FROM
        film);
/*
Use subqueries to display all actors who appear in the film Alone Trip.
*/
SELECT 
    a.first_name, a.last_name
FROM
    actor AS a
        JOIN
    film_actor AS fa USING (actor_id)
WHERE
    fa.film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Alone Trip')
GROUP BY a.actor_id , fa.film_id;
    
    
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id as f
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));   
/* 
Sales have been lagging among young families, and you wish to target all family movies for a promotion.
 Identify all movies categorized as family films.
 */
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));
 
/*  WHERE  address_id IN (
(SELECT address_id FROM address WHERE city_id IN 
*/ 
 
SELECT 
    title
FROM
    film
        JOIN
    film_category USING (film_id)
WHERE
    category_id IN (SELECT 
            category_id
        FROM
            category
        WHERE
            name = 'Family');
    
/* Get name and email from customers from Canada using subqueries.
 Do the same with joins. Note that to create a join, you will have to identify the 
correct tables with their primary keys and foreign keys, that will help you get the relevant information.
*/
SELECT 
    c.first_name, c.last_name, c.email
FROM
    customer AS c
        JOIN
    address USING (address_id)
        JOIN
    city USING (city_id)
WHERE
    country_id IN (SELECT 
            country_id
        FROM
            country
        WHERE
            country = 'Canada');

SELECT 
    first_name, last_name, email
FROM
    customer
WHERE
    address_id IN ((SELECT 
            address_id
        FROM
            address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    city
                WHERE
                    country_id IN (SELECT 
                            country_id
                        FROM
                            country
                        WHERE
                            country = 'Canada'))));

/* 
Which are films starred by the most prolific actor? 
Most prolific actor is defined as the actor that has acted in the most number of films. 
First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
*/ 

SELECT 
    title
FROM
    film
WHERE
    film_id IN ((SELECT film_id FROM film_actor WHERE 
    actor_id IN (SELECT actor_id FROM actor WHERE
	actor_id = (SELECT  sub.actor_id FROM
					(SELECT  COUNT(film_id) AS num_films, actor_id
                            FROM
                                film_actor
                            GROUP BY actor_id
                            ORDER BY num_films DESC
                            LIMIT 1) AS sub))));

SELECT  sub.actor_id FROM
    (SELECT 
        COUNT(film_id) AS num_films, actor_id
    FROM
        film_actor
    GROUP BY actor_id
    ORDER BY num_films DESC
    LIMIT 1) AS sub;

/*
 Films rented by most profitable customer. You can use the customer table and payment table to find the most 
 profitable customer ie the customer that has made the largest sum of payments
 */
 -- Most profitable customer
SELECT first_name, last_name, SUM(amount) as total_paid, customer_id
FROM payment
 JOIN  customer USING (customer_id)
GROUP BY customer_id	
ORDER BY total_paid desc;
--
--
--
 -- Most profitable customer
SELECT customer_id, SUM(amount) as total_paid
FROM payment 
GROUP BY customer_id
ORDER BY total_paid DESC LIMIT 1;
 -- Most profitable customer_id
SELECT customer_id
FROM customer 
WHERE  
customer_id = 
(SELECT  sub.customer_id FROM
(SELECT customer_id, SUM(amount) as total_paid
FROM payment 
GROUP BY customer_id
ORDER BY total_paid DESC LIMIT 1) as sub);
-- full query
select title from film 
where film_id in
(select film_id from inventory where inventory_id in
(SELECT inventory_id from rental where customer_id in
(SELECT customer_id
FROM customer 
WHERE  
customer_id = 
(SELECT  sub.customer_id FROM
(SELECT customer_id, SUM(amount) as total_paid
FROM payment 
GROUP BY customer_id
ORDER BY total_paid DESC LIMIT 1) as sub))));

/* 
Customers who spent more than the average payments 
(this refers to the average of all amount spent per each customer).
*/
-- get average of all amount per customer 

SELECT 
	customer_id, AVG(amount) as avg_amount
FROM 
	payment
GROUP BY customer_id;

WITH hp AS (
SELECT 
	customer_id, AVG(amount) as avg_amount
FROM 
	payment
GROUP BY customer_id)
SELECT  c.first_name, c.last_name, p.amount, hp.avg_amount
FROM hp 
JOIN (customer as c) USING(customer_id)
JOIN (payment as p) USING(customer_id)
HAVING p.amount > hp.avg_amount
ORDER BY c.first_name;


WITH hp AS (
SELECT 
	customer_id, SUM(amount) as total_amt
FROM 
	payment
GROUP BY customer_id)
SELECT c.first_name, c.last_name, hp.total_amt 
FROM hp 
JOIN (customer as c) USING(customer_id)
JOIN (payment as p) USING(customer_id)
WHERE  hp.total_amt > (SELECT AVG(hp.total_amt) from hp)
ORDER BY c.first_name;


/* FINAL ANSWER */
WITH hp AS (
SELECT 
	customer_id, SUM(amount) as total_amt
FROM 
	payment
GROUP BY customer_id)
SELECT  distinct(hp.customer_id), c.first_name, c.last_name, hp.total_amt
FROM hp 
JOIN (customer as c) USING(customer_id)
JOIN (payment as p) USING(customer_id)
WHERE  hp.total_amt > (SELECT AVG(hp.total_amt) from hp) -- group by hp.customer_id)
ORDER BY c.first_name;



