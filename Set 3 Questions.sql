/* Question Set 3 - Advance */

-- Q1. Find how much amount spent by each customer on artists? 
-- Write a query to return customer name, artist name and total spent.

WITH best_selling_artist AS (
	SELECT ar.artist_id AS artist_id, ar.name AS artist_name, SUM(il.unit_price*il.quantity) AS total_sales
	FROM invoice_line AS il
	JOIN track AS tr ON il.track_id = tr.track_id
	JOIN album AS ab ON tr.album_id = ab.album_id
	JOIN artist AS ar ON ab.artist_id = ar.artist_id
	GROUP BY ar.artist_id
	ORDER BY 3 DESC LIMIT 1
)
SELECT cu.customer_id, cu.first_name, cu.last_name, bsa.artist_name AS artist_name, SUM(il.unit_price * il.quantity) AS amount_spent
FROM invoice AS iv
JOIN customer AS cu ON iv.customer_id = cu.customer_id
JOIN invoice_line AS il ON iv.invoice_id = il.invoice_id
JOIN track AS tr ON il.track_id = tr.track_id
JOIN album AS ab ON tr.album_id = ab.album_id
JOIN best_selling_artist AS bsa ON ab.artist_id = bsa.artist_id
GROUP BY cu.customer_id, bsa.artist_name;


-- Q2: We want to find out the most popular music Genre for each country. 
-- A. We determine the most popular genre as the genre with the highest amount of purchases. 
-- B. Write a query that returns each country along with the top Genre. 
-- C. For countries where the maximum number of purchases is shared return all Genres.

WITH popular_genre AS (
	SELECT cu.country, COUNT(il.quantity) AS total_purchases, gr.name AS top_genre, gr.genre_id,
		ROW_NUMBER() OVER(
			PARTITION BY cu.country ORDER BY COUNT(il.quantity) DESC
		) AS row_num
	FROM customer AS cu
	JOIN invoice AS iv ON cu.customer_id = iv.customer_id
	JOIN invoice_line AS IL ON iv.invoice_id = il.invoice_id
	JOIN track AS tr ON il.track_id = tr.track_id
	JOIN genre AS gr ON tr.genre_id = gr.genre_id
	GROUP BY cu.country, gr.name, gr.genre_id
	ORDER BY 1 ASC, 2 DESC
)
SELECT country, top_genre, total_purchases
FROM popular_genre 
WHERE row_num = 1;


-- Q3: Write a query that determines the customer that has spent the most on music for each country. 
-- A. Write a query that returns the country along with the top customer and how much they spent. 
-- B. For countries where the top amount spent is shared, provide all customers who spent this amount.

WITH customer_with_country AS (
	SELECT cu.country, cu.customer_id, cu.first_name, cu.last_name, SUM(iv.total) AS total_spending,
		ROW_NUMBER() OVER(
			PARTITION BY cu.country ORDER BY SUM(iv.total) DESC
		) AS row_num
	FROM invoice AS iv
	JOIN customer AS cu ON iv.customer_id = cu.customer_id
	GROUP BY cu.country, cu.customer_id, cu.first_name, cu.last_name
	ORDER BY cu.country, total_spending DESC
)
SELECT country, customer_id, first_name, last_name, total_spending
FROM customer_with_country
WHERE row_num = 1;