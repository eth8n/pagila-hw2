/*
 * Compute the total revenue for each film.
 * The output should include another new column "revenue percent" that shows the percent of total revenue that comes from the current film and all previous films.
 * That is, the "revenue percent" column is 100*"total revenue"/sum(revenue)
 *
 * HINT:
 * The `to_char` function can be used to achieve the correct formatting of your percentage.
 * See: <https://www.postgresql.org/docs/current/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE>
 */

WITH film_revenue AS (
  SELECT
    f.title,
    COALESCE(SUM(p.amount), 0.00) AS revenue
  FROM film f
  LEFT JOIN inventory i ON f.film_id = i.film_id
  LEFT JOIN rental r ON i.inventory_id = r.inventory_id
  LEFT JOIN payment p ON r.rental_id = p.rental_id
  GROUP BY f.title
)
SELECT
  RANK() OVER (ORDER BY revenue DESC) AS rank,
  title,
  revenue,
  SUM(revenue) OVER (ORDER BY revenue DESC RANGE UNBOUNDED PRECEDING) AS "total revenue",
  CASE
    WHEN ROUND(100*(SUM(revenue) OVER (ORDER BY revenue DESC RANGE UNBOUNDED PRECEDING))/(SELECT SUM(revenue) FROM film_revenue), 2) = 100
    THEN '100.00'
    ELSE TO_CHAR(ROUND(100*(SUM(revenue) OVER (ORDER BY revenue DESC RANGE UNBOUNDED PRECEDING))/(SELECT SUM(revenue) FROM film_revenue), 2), 'FM00.00')
  END AS "percent revenue"
FROM film_revenue
ORDER BY revenue DESC, title;
