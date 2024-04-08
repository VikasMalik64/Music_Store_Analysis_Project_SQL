/* Question Set 2 - Moderate */

-- Q1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.

SELECT cu.email, cu.first_name, cu.last_name
FROM customer AS cu
JOIN invoice AS iv ON cu.customer_id = iv.customer_id
JOIN invoice_line as il ON iv.invoice_id = il.invoice_id
WHERE il.track_id IN(
					SELECT tr.track_id
					from track AS tr
					JOIN genre AS gr ON tr.genre_id = gr.genre_id
					where gr.name = 'Rock'
)
ORDER BY cu.email;


-- Q2. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.

SELECT ar.artist_id, ar.name, COUNT(ar.artist_id) AS number_of_songs
FROM artist AS ar
JOIN album AS ab ON ar.artist_id = ab.artist_id
JOIN track AS tr ON tr.album_id = ab.album_id
JOIN genre AS ge ON ge.genre_id = tr.genre_id
WHERE ge.name LIKE 'Rock'
GROUP BY ar.artist_id
ORDER BY 3 DESC
LIMIT 10;


-- Q3. Return all the track names that have a song length longer than the average song length. 
-- A. Return the Name and Milliseconds for each track. 
-- B. Order by the song length with the longest songs listed first.

SELECT name, milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_song_length
	FROM track
)
ORDER BY milliseconds DESC;

