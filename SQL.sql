Question 1.)
SELECT
   name,
   COUNT (rentals) rental_count 
FROM
   (
      SELECT
         f.title,
         c.name,
         r.rental_id rentals 
      FROM
         film_category fc 
         JOIN
            category c 
            ON c.category_id = fc.category_id 
         JOIN
            film f 
            ON f.film_id = fc.film_id 
         JOIN
            inventory i 
            ON i.film_id = f.film_id 
         JOIN
            rental r 
            ON r.inventory_id = i.inventory_id 
      WHERE
         c.name IN 
         (
            'Animation',
            'Children',
            'Classics',
            'Comedy',
            'Family',
            'Music'
         )
   )
   t1 
GROUP BY
   1 
ORDER BY
   2


Question 2)

WITH t1 AS
(
   SELECT
      c.name,
      NTILE (4) OVER (PARTITION BY rental_duration 
   ORDER BY
      f.rental_duration) AS standard_quartile 
   FROM
      film_category fc 
      JOIN
         category c 
         ON c.category_id = fc.category_id 
      JOIN
         film f 
         ON f.film_id = fc.film_id 
   WHERE
      c.name IN 
      (
         'Animation',
         'Children',
         'Classics',
         'Comedy',
         'Family',
         'Music'
      )
)
SELECT
   name,
   standard_quartile,
   COUNT (*) 
FROM
   t1 
GROUP BY
   1,
   2 
ORDER BY
   1,
   2;



Question 3)
SELECT
   DATE_PART('year', r.rental_date) AS rental_year,
   staff.store_id,
   COUNT (r.rental_id) count_rentals 
FROM
   rental r 
   JOIN
      staff 
      ON staff.staff_id = r.staff_id 
   JOIN
      store s 
      ON s.store_id = staff.store_id 
GROUP BY
   2,
   1 
ORDER BY
   3 DESC


Question 4)
WITH t1 AS 
(
   SELECT
      c.customer_id,
      CONCAT(c.first_name, ' ', c.last_name) fullname,
      sum(amount) pay_amount 
   FROM
      payment p 
      JOIN
         customer c 
         ON p.customer_id = c.customer_id 
   GROUP BY
      1,
      2 
   ORDER BY
      3 DESC LIMIT 10
)
SELECT
   TO_CHAR (date_trunc('month', p.payment_date), 'MM/YYYY') pay_mon,
   t1.fullname,
   COUNT(p.payment_date) pay_countpermon,
   SUM (p.amount) pay_amount 
FROM
   payment p 
   JOIN
      t1 
      ON t1.customer_id = p.customer_id 
GROUP BY
   1,
   2 
ORDER BY
   2