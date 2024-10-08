-- Query for Slide 1:

WITH T1 AS (
SELECT 
	f.title,
	cat.name AS category
FROM film f
JOIN film_category f_c 
ON f_c.film_id = f.film_id
JOIN category cat
ON cat.category_id = f_c.category_id
JOIN inventory inv
ON inv.film_id = f.film_id
JOIN rental ren
ON ren.inventory_id = inv.inventory_id
	)

SELECT 
	t1.title, 
	t1.category,
	COUNT(*) AS rental_count
FROM T1
WHERE t1.category in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1,2
ORDER BY 2,1;

-- Query for Slide 2:

WITH T1 AS (
SELECT 
	f.title, 
	cat.name AS category,
	f.rental_duration,
	NTILE(4) OVER 
	(ORDER BY f.rental_duration) AS rental_quartile
FROM film f
JOIN film_category f_c
ON f_c.film_id = f.film_id
JOIN category cat
ON cat.category_id = f_c.category_id
WHERE cat.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
	)

SELECT 
	category,
	rental_quartile,
	COUNT(*) AS movies_per_quartile
FROM T1
GROUP BY 1,2
ORDER BY 1,2;

-- Query for Slide 3:

SELECT 
	DATE_PART('month',r.rental_date) AS rental_month,
	DATE_PART('year',r.rental_date) AS rental_year,
	s.store_id,
	COUNT(*)
FROM rental r
JOIN staff s
ON s.staff_id = r.staff_id
GROUP BY 1,2,3
ORDER BY 4 DESC;

-- Query for Slide 4:

WITH top_customers AS ( 
    SELECT
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(p.amount) AS total_amount
    FROM customer c
    JOIN payment p
    ON p.customer_id = c.customer_id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
)

SELECT 
	DATE_TRUNC('month', payment_date),
	CONCAT(c.first_name, ' ', c.last_name) AS full_name,
	COUNT(*) AS pay_countpermon,
	SUM(p.amount) AS pay_amount
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
WHERE CONCAT(c.first_name, ' ', c.last_name) IN (SELECT customer_name FROM top_customers)
GROUP BY 1, 2
ORDER BY 2, 1;