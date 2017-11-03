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

INSERT INTO shipments
VALUES(2000, 860, '0394900014', '2012-12-07');


INSERT INTO shipments
VALUES(2001, 860, '044100590X', '2012-12-07');


SELECT * FROM shipments WHERE shipment_id > 1999;
