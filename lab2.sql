/*
1. Create a view that contains isbn and title of all the books in the database. Then
query it to list all the titles and isbns. Then delete (drop) the new view. Why
might this view be nice to have?
*/
CREATE VIEW isbnview AS 
SELECT isbn, title
FROM books
NATURAL JOIN editions;

DROP VIEW isbnview;
/*
Views are nice to have because they always show up to date data. 
This view is good to have because it shows all the books in the database. 

2. Try to insert into editions a new tuple ('5555', 12345, 1, 59, '2012-12-02'). Explain
what happened.
*/

INSERT INTO editions
VALUES ('5555', 12345, 1, 59, '2012-12-02');

/*
Output: 
ERROR:  insert or update on table "editions" violates foreign key constraint "editions_book_id_fkey"
DETAIL:  Key (book_id)=(12345) is not present in table "books".

This is because there is a foreign key constraint between books and editions. 
As the bookid 12345 doesent exist in books, this edition cant be added. 

*/

/*
3. Try to insert into editions a new tuple only setting its isbn='5555'. Explain what
happened.
*/

INSERT INTO editions
VALUES ('5555');

/*
Output
ERROR:  new row for relation "editions" violates check constraint "integrity"

This is because there is a check constraint for the columns of editions, 
probably stating that book_id cam not be null. 

*/

/*
4. 
Try to first insert a book with (book_id, title) of (12345, 'How I Insert') then
One into editions as in 2. Show that this worked by making an appropriate query of the
database. Why do we not need an author or subject?
*/

# Insertion

INSERT INTO books(book_id, title)
VALUES (12345, 'How I Insert');

INSERT INTO editions
VALUES ('5555', 12345, 1, 59, '2012-12-02');

# Check
SELECT * 
FROM books 
NATURAL JOIN editions
WHERE book_id = 12345;

/*
# Explanation
We dont need an author or subject because they are not keys (hence they do not affect
a relation with another table) and they do not have a constraint saying they cant be null. 

*/

/*
5. Update the new book by setting the subject to ‘Mystery’.
*/


UPDATE books
SET subject_id = (
	SELECT subject_id
	FROM subjects
	WHERE subject = 'Mystery'
	)
WHERE book_id = 12345;

6. 

DELETE FROM books
WHERE book_id = 12345;

/*
#Output
ERROR:  update or delete on table "books" violates foreign key constraint "editions_book_id_fkey" on table "editions"
DETAIL:  Key (book_id)=(12345) is still referenced from table "editions".

This is because there is a default foreign key relation between books and editions. We cant delete just one. 
*/

/* 
7. Delete both new tuples from step 4 and query the database to confirm.
*/

#Deletion
DELETE FROM editions
WHERE book_id = 12345;

DELETE FROM books
WHERE book_id = 12345;


# Check

SELECT * 
FROM books 
WHERE book_id = 12345;

#Output
/*
 book_id | title | author_id | subject_id 
---------+-------+-----------+------------
(0 rows)
*/

/*
8. Now insert a book with (book_id, title, subject_id ) of (12345, 'How I Insert', 3443).
Explain what happened.

*/

INSERT INTO books(book_id, title, subject_id)
VALUES (12345, 'How I Insert', 3443);

/*
#Output
ERROR:  insert or update on table "books" violates foreign key constraint "books_subject_id_fkey"
DETAIL:  Key (subject_id)=(3443) is not present in table "subjects".

Since there is no subject with id 3443 and subject_id is a foreign key within books, it is not possible to add the book. 
*/

/*
9. Create a constraint, called ‘hasSubject’ that forces the subject_id to not be NULL
and to match one in the subjects table. (HINT you might want to look at chap.
6.1.6 on testing NULL). Show that you can still insert a book with no author_id
but not without a subject_id. Now remove the new constraint and any added
books.
*/


ALTER TABLE books 
ADD CONSTRAINT "hasSubject" CHECK (subject_id NOTNULL);


# Check 1

INSERT INTO books(book_id, title)
VALUES (12345, 'How I Insert');

# Output 1
#ERROR:  new row for relation "books" violates check constraint "hasSubject"



# Check 2

INSERT INTO books(book_id, title, subject_id)
VALUES (12345, 'How I Insert', 10);

# Output 2
INSERT 0 1

# Remove constraint
ALTER TABLE books
DROP CONSTRAINT "hasSubject";

#3.1

DROP FUNCTION decstock() CASCADE;

CREATE FUNCTION decstock() RETURNS trigger AS $decstock$
	BEGIN
		IF (SELECT stock FROM stock WHERE stock.isbn = NEW.isbn) = 0
			THEN RAISE exception 'There is no stock to ship';
		END IF;
		
		UPDATE stock
			SET stock = (SELECT stock FROM stock WHERE stock.isbn = NEW.isbn) -1
			WHERE stock.isbn = NEW.isbn;
		RETURN NEW;
	END;

$decstock$ LANGUAGE plpgsql;


CREATE TRIGGER decstock
	BEFORE INSERT OR UPDATE ON shipments
	FOR EACH ROW EXECUTE PROCEDURE decstock();

# Input
INSERT INTO shipments
VALUES(2000, 860, '0394900014', '2012-12-07');
# Out
#ERROR:  There is no stock to ship


# Input
INSERT INTO shipments
VALUES(2001, 860, '044100590X', '2012-12-07');
# Output
INSERT 0 1

#Input
SELECT * FROM shipments WHERE shipment_id > 1999;

/*
#Output
 shipment_id | customer_id |    isbn    |       ship_date        
-------------+-------------+------------+------------------------
        2001 |         860 | 044100590X | 2012-12-07 00:00:00+01
*/

DELETE FROM shipments WHERE shipment_id > 1999;
UPDATE stock SET stock = 89 WHERE isbn = '044100590X';
DROP FUNCTION decstock() CASCADE;


