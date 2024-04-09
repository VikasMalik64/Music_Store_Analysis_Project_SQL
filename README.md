# Music Store Data Analysis 🎵

This project's primary objective is to conduct a thorough analysis of music store data using SQL. The overarching goal of this project is to extract valuable insights and address a multitude of inquiries related to the music store's functioning through the application of SQL queries to the dataset.

## Introduction

The "Music Store Data Analysis" project offers a comprehensive analysis of the music store's data to facilitate better decision-making, identify trends, and understand customer behavior. By leveraging SQL queries and data exploration, this project provides valuable answers to optimize inventory management, target marketing campaigns, and make informed business decisions.

## Tech Stack Used

![postgresql](https://github.com/VikasMalik64/Images/blob/6d3c58b28c9ace3846d807cd4430cd275937be8c/Music%20Store%20SQL/postgresql-logo-svgrepo-com.png)

PostgreSQL and pgAdmin4

## Skills showcased in this Project

- Use of SELECT and WHERE statements along with LIMIT and ORDER BY 
- Use of Aggreagte Functions such as SUM, COUNT
- Use of GROUP BY and JOINS
- Use of WINDOW Functions and Common Table Expression(CTE)
  
## Dataset

The dataset for this project has 11 tables: Employee, Customer, Invoice, InvoiceLine, Track, MediaType, Genre, Album, Artist, PlaylistTrack, and Playlist, as well as their associations.

<img width="594" alt="schema_diagram" src="https://github.com/VikasMalik64/Music_Store_Analysis_Project_SQL/blob/ee8903c76a127881a4bf9ddb2eea1a2050011b3f/schema_diagram.png">

## Questions and Answers

<ins>_Set 1 Questions - Easy_</ins>

➥

-- Q1. Who is the senior most employee based on job title?
```sql
SELECT * 
FROM employee
ORDER BY levels DESC
LIMIT 1;
```

Output :

![O1](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set1/Output_1.jpg)


➥

-- Q2. Which countries have the most Invoices?
```sql
SELECT billing_country, COUNT(*) AS most_invoices
FROM invoice
GROUP BY billing_country
ORDER BY 2 DESC;
```

Output :

![O2](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set1/Output_2.jpg)

➥

-- Q3. What are top 3 values of total invoice?
```sql
SELECT total AS total_invoice
FROM invoice
ORDER BY total DESC
LIMIT 3;
```

Output :

![O3](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set1/Output_3.jpg)

➥

-- Q4. Which city has the best customers? 
- A. We would like to throw a promotional Music Festival in the city we made the most money. 
- B. Write a query that returns one city that has the highest sum of invoice totals. 
- C. Return both the city name & sum of all invoice totals.
```sql
SELECT billing_city, SUM(total) AS invoice_totals
FROM invoice
GROUP BY billing_city
ORDER BY 2 DESC
LIMIT 1;
```

Output :

![O4](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set1/Output_4.jpg)

 ➥
 
-- Q5. Who is the best customer? 
- A. The customer who has spent the most money will be declared the best customer. 
- B. Write a query that returns the person who has spent the most money.
```sql
SELECT cu.customer_id, cu.first_name, cu.last_name, SUM(iv.total) AS total_purcahse
FROM customer AS cu
JOIN invoice AS iv 
ON cu.customer_id = iv.customer_id
GROUP BY cu.customer_id
ORDER BY total_purcahse DESC
LIMIT 1;
```

Output :

![O5](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set1/Output_5.jpg)



<ins>_Set 2 Question - Moderate_</ins>

➥

-- Q1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A.
```sql
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
```

Output :

![O6](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set2/Output_6.jpg)

➥

-- Q2. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands.
```sql
SELECT ar.artist_id, ar.name, COUNT(ar.artist_id) AS number_of_songs
FROM artist AS ar
JOIN album AS ab ON ar.artist_id = ab.artist_id
JOIN track AS tr ON tr.album_id = ab.album_id
JOIN genre AS ge ON ge.genre_id = tr.genre_id
WHERE ge.name LIKE 'Rock'
GROUP BY ar.artist_id
ORDER BY 3 DESC
LIMIT 10;
```

Output :

![O7](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set2/Output_7.jpg)

➥

-- Q3. Return all the track names that have a song length longer than the average song length. 
- A. Return the Name and Milliseconds for each track. 
- B. Order by the song length with the longest songs listed first.
```sql
SELECT name, milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_song_length
	FROM track
)
ORDER BY milliseconds DESC;
```

Output :

![O8](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set2/Output_8.jpg)



<ins>_Set 3 Questions - Advance_</ins>

➥

-- Q1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent.
```sql
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
```

Output :

![O9](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set3/Output_9.jpg)

➥

-- Q2: We want to find out the most popular music Genre for each country. 
- A. We determine the most popular genre as the genre with the highest amount of purchases. 
- B. Write a query that returns each country along with the top Genre. 
- C. For countries where the maximum number of purchases is shared return all Genres.
```sql
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
```

Output :

![O10](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set3/Output_10.jpg)

➥

-- Q3: Write a query that determines the customer that has spent the most on music for each country. 
- A. Write a query that returns the country along with the top customer and how much they spent. 
- B. For countries where the top amount spent is shared, provide all customers who spent this amount.
```sql
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
```

Output :

![O11](https://github.com/VikasMalik64/Images/blob/43b2b521f3aed4f33b7df533478dee299e1355e5/Music%20Store%20SQL/Q_Set3/Output_11.jpg)

# Key Findings

_Identifying Valuable Clients_: Identifying Valuable Clients: Through a thorough analysis of customer purchase records and spending habits, we've pinpointed our most valuable clients based on their lifetime contribution and purchase frequency. This valuable data can be harnessed to craft tailored marketing initiatives, loyalty programs, and exclusive promotions aimed at deepening connections and preserving these cherished customer relationships.

_Country-Based Revenue Insights_: By consolidating sales data and examining customer locations, we've identified the countries that generate the highest revenue for our digital music store. This valuable insight allows us to direct our marketing campaigns, localization efforts, and customer support resources towards these specific regions, ensuring we tap into their full revenue potential.

_Identifying Preferred Music Genres_: Through an analysis of customer preferences and purchasing behaviors, we've pinpointed the most favored music genres within our customer community. This valuable data serves as a guide for our content curation strategy, promotional initiatives, and collaborations with artists from these genres, allowing us to effectively meet customer demands and preferences.

## End

Thank you for your interest and time. Feel free to give your valuable suggestions and connect with me on https://www.linkedin.com/in/vikasmalik64/
