/* Question Set 1 - Easy */

-- Q1. Who is the senior most employee based on job title? 

SELECT * 
FROM employee
ORDER BY levels DESC
LIMIT 1;


-- Q2. Which countries have the most Invoices?

SELECT billing_country, COUNT(*) AS most_invoices
FROM invoice
GROUP BY billing_country
ORDER BY 2 DESC;


-- Q3. What are top 3 values of total invoice?

SELECT total AS total_invoice
FROM invoice
ORDER BY total DESC
LIMIT 3;


-- Q4. Which city has the best customers? 
-- A. We would like to throw a promotional Music Festival in the city we made the most money. 
-- B. Write a query that returns one city that has the highest sum of invoice totals. 
-- C. Return both the city name & sum of all invoice totals.

SELECT billing_city, SUM(total) AS invoice_totals
FROM invoice
GROUP BY billing_city
ORDER BY 2 DESC
LIMIT 1;


-- Q5. Who is the best customer? 
-- A. The customer who has spent the most money will be declared the best customer. 
-- B. Write a query that returns the person who has spent the most money.

SELECT cu.customer_id, cu.first_name, cu.last_name, SUM(iv.total) AS total_purcahse
FROM customer AS cu
JOIN invoice AS iv 
ON cu.customer_id = iv.customer_id
GROUP BY cu.customer_id
ORDER BY total_purcahse DESC
LIMIT 1;
