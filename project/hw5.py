9.3.1: Ask the user for the maximum price and minimum values of speed, 
RAM, hard disk, screen and screen size. Find all the laptops that satisfy 
these requirements. Print their specs. 

a. 

EXEC SQL BEGIN DECLARE SECTION;
	int price, speed, ram, hd, screen
EXEC SQL END DECLARE SECTION;

""" print request that variables be entered and read response into variables."""

EXEC SQL SELECT model, speed, ram, hd, screen, price, maker FROM Laptop NATURAL JOIN Product WHERE price < :price AND speed > :speed 
AND ram > :ram AND hd > :hd AND screen > :screen;



c. 

EXEC SQL BEGIN DECLARE SECTION; 
	int price
EXEC SQL END DECLARE SECTION;

"Print request variable be entered and read response to variable price. "

EXEC SQL SELECT TOP 1 * FROM Laptop ORDER BY ABS(price - :price)


9.3.2 
a

CREATE VIEW firepowerView AS 
SELECT class,(numGuns*bore*bore) AS firepower
FROM Classes;

SELECT TOP 1 * 
FROM firepowerView
ORDER BY firepower


9.4.3 


a. Take as arguments a new class name, type, country, number of guns, bore and displacement. 

EXEC SQL BEGIN DECLARE SECTION; 
	CHAR name[20], type[20], country[20], displacement[20]
	int numGuns, bore
EXEC SQL END DECLARE SECTION;


CREATE PROCEDURE addclass(
	IN name CHAR(20), 
	IN type CHAR(20), 
	IN country CHAR(20),
	IN displacement CHAR(20),
	IN numGuns INT, 
	IN bore INT
)
INSERT INTO Classes VALUES name, type, country, numGuns, bore, displacement;
INSERT INTO Ships VALUES 'Newship', name, NULL;


b. 
CREATE FUNCTION get_firepower RETURNS firepower(
	IN name CHAR(20)
	RETURN (SELECT (numGuns*bore*bore) AS firepower FROM Classes WHERE name = name)
);



