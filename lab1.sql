
/*Part 1.

1. Who wrote ”The Shining”?
Answer: King, Stephen*/

SELECT last_name, first_name 
FROM authors 
Where author_id = (SELECT author_id 
FROM books 
WHERE title='The Shining');


/* 2. Which titles are written by Paulette Bourgeois?
Answer: Franklin in the Dark */

SELECT title 
FROM books
NATURAL JOIN authors
WHERE last_name = 'Bourgeois'
AND first_name = 'Paulette';


/*3. Who bought books about “Horror”?
Answer: Morrill, Royce
Jackson, Annie
Holloway, Adam
Black, Jean
King, Jenny
Anderson, Jonathan
Gould, Ed
Becker, Owen
Brown, Chuck

customers --> shipments --> isbn --> editions --> books --> subjects*/

SELECT first_name, last_name
FROM customers 
NATURAL JOIN shipments
NATURAL JOIN editions
NATURAL JOIN books
NATURAL JOIN subjects
WHERE subject = 'Horror';


/*4. Which book has the largest stock?
Answer: Dune*/

SELECT title
FROM books
NATURAL JOIN editions
NATURAL JOIN stock
WHERE stock = (
	SELECT MAX(stock) 
	FROM stock);


/*5. How much money has Booktown collected for the books about Science Fiction?
They collect the retail price of each book shiped.
Answer: 137.80 */

SELECT SUM(retail_price)
FROM stock
NATURAL JOIN editions
NATURAL JOIN books
NATURAL JOIN subjects
WHERE subject = 'Science Fiction';


/* 6. Which books have been sold to only two people?
Note that some people buy more than one copy and some books appear as
several editions.
Answer: Dune
Little Women
The Velveteen Rabbit
2001: A Space Odyssey */

SELECT title
FROM books
NATURAL JOIN ( 
	SELECT book_id 
	FROM (
		SELECT *
		FROM editions 
		NATURAL JOIN ( 
			SELECT customer_id, isbn 
			FROM shipments
			GROUP BY customer_id, isbn) AS bought_editions) 
	AS bought_bookids
	GROUP BY book_id
	HAVING COUNT(book_id) = 2) AS bought_titles_twice; 

#Slå ihop 
#Plocka ut customer_id och isbn från shipments.
#Gruppera
#Plocka endast ut de vars bokid förekommer 2 ggr. 

 /* 7. Which publisher has sold the most to Booktown?
Note that all shipped books were sold at ‘cost’ to as well as all the books in the
stock.
Answer: Ace Books, 4566.00 */


SELECT name, MAX(totsum)
FROM(
	SELECT name, SUM(total) as totsum
	FROM (
		SELECT name, cost*(count+stock) AS total
		FROM (
			SELECT cost, book_id,name, COUNT(book_id), stock
			FROM publishers 
			NATURAL JOIN editions
			NATURAL JOIN shipments
			NATURAL JOIN stock
			GROUP BY cost, book_id, name, stock) as foo) as loo
		GROUP BY name) as maxpub
	GROUP BY name, totsum
	ORDER BY totsum DESC
	LIMIT 1;

/*
8. How much money has Booktown earned (so far)? (Explain to the teacher how
you reason about the incomes and costs of Booktown)
Answer: 136.15 or -12789.85, depending on how the stock is treated

Totala intäkter - Totala utgifter
Totala utgifter: Ges av förra uppgiten
*/

#Totala intäkter: 999.15
#Totala utgifter 13789.00

SELECT total_income-total_expenses as total_result
	FROM (
	SELECT SUM(cost*(count+stock)) AS total_expenses, SUM(retail_price*count) as total_income
		FROM (
			SELECT cost, COUNT(book_id), stock, retail_price
			FROM publishers 
			NATURAL JOIN editions
			NATURAL JOIN shipments
			NATURAL JOIN stock
			GROUP BY cost, book_id, name, stock, retail_price
			) AS foo
		) AS result;


/*
9. Which customers have bought books about at least three different subjects?
Answer: Jackson, Annie
*/
SELECT first_name, last_name
FROM customers
NATURAL JOIN(
	SELECT subject_id, customer_id
	FROM shipments
	NATURAL JOIN editions
	NATURAL JOIN books
	NATURAL JOIN subjects
	GROUP BY subject_id, customer_id
	HAVING (COUNT(customer_id)>2)) as foo;

/*
10. Which subjects have not sold any books?
Answer: Mystery
Business
Religion
Cooking
Poetry
History
Romance
Entertainment
Science
*/

SELECT subject
FROM subjects
WHERE subject_id NOT IN(
	SELECT subject_id
	FROM subjects
	NATURAL JOIN(
		SELECT subject_id, shipment_id
		FROM shipments
		NATURAL JOIN editions
		NATURAL JOIN books
		NATURAL JOIN subjects
		GROUP BY subject_id, shipment_id) as foo
);

/*
OUTPUT
    subject    
---------------
 Business
 Cooking
 Entertainment
 History
 Mystery
 Poetry
 Religion
 Romance
 Science
(9 rows)
*/

