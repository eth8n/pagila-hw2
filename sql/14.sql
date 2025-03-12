/*
 * Create a report that shows the total revenue per month and year.
 *
 * HINT:
 * This query is very similar to the previous problem,
 * but requires an additional JOIN.
 */

SELECT 
    CASE WHEN EXTRACT(YEAR FROM r.rental_date) IS NULL THEN NULL 
         ELSE EXTRACT(YEAR FROM r.rental_date)::int 
    END AS "Year",
    CASE WHEN EXTRACT(MONTH FROM r.rental_date) IS NULL THEN NULL 
         ELSE EXTRACT(MONTH FROM r.rental_date)::int 
    END AS "Month",
    SUM(p.amount) AS "Total Revenue"
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY ROLLUP(EXTRACT(YEAR FROM r.rental_date), EXTRACT(MONTH FROM r.rental_date))
ORDER BY "Year", "Month";
