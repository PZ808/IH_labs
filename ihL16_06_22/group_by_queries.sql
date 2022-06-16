use sakila;
/*
In the table actor, what last names are not repeated? 
For example if you would sort the data in the table actor by last_name, 
you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. 
These three actors have the same last name. So we do not want to include this last name in our output. 
Last name "Astaire" is present only one time with actor "Angelina Astaire", 
hence we would want this in our output list. */

SELECT 
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) < 2
ORDER BY last_name;

/* Which last names appear more than once? We would use the
 same logic as in the previous question but this time we want to include the last
 names of the actors where the last name was present more than once */

SELECT 
    SUM(a.counts)
FROM
    (SELECT 
        last_name, COUNT(last_name) AS counts
    FROM
        actor
    GROUP BY last_name
    HAVING counts > 1) AS a
GROUP BY a.last_name
;
/* Using the rental table, find out how many rentals were processed by each employee. */
SELECT 
    s.first_name,
    s.last_name,
    COUNT(r.rental_id) AS num_rentals,
    staff_id
FROM
    staff AS s
        JOIN
    rental AS r USING (staff_id)
GROUP BY staff_id
ORDER BY num_rentals DESC;

/* Using the film table, find out how many films there are of each rating. */
SELECT 
    COUNT(DISTINCT title) AS num_titles, rating
FROM
    film
GROUP BY rating
ORDER BY rating;
/* What is the mean length of the film for each rating type. 
Round off the average lengths to two decimal places */
SELECT 
    ROUND(AVG(length), 2) AS avg_length, rating
FROM
    film
GROUP BY rating
ORDER BY avg_length;

/* Which kind of movies (rating) have a mean duration of more than two hours? */
SELECT 
    ROUND(AVG(length), 2) AS avg_length, rating
FROM
    film
GROUP BY rating
HAVING avg_length > 120
ORDER BY avg_length;

