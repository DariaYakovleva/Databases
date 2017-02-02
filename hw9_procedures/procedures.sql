DROP DATABASE airline3;
CREATE DATABASE airline3;

DROP TABLE planes CASCADE;
DROP TABLE flights CASCADE;
DROP TABLE seats CASCADE;

CREATE TABLE IF NOT EXISTS planes (
	plane_id int PRIMARY KEY,
	capacity int not null
);

CREATE TABLE IF NOT EXISTS flights (
	flight_id SERIAL PRIMARY KEY,
	flight_num int,
	flight_time timestamp without time zone,
	plane_id int not null REFERENCES planes (plane_id) ON DELETE CASCADE ON UPDATE CASCADE,
	end_sales int not null
);

CREATE TABLE IF NOT EXISTS seats (
	flight_id int REFERENCES flights (flight_id) ON DELETE CASCADE ON UPDATE CASCADE,
	seat_no int not null,
	status int not null, --  1 -- reserved, 2 -- bought
	reserved_time timestamp without time zone,
	PRIMARY KEY(flight_id, seat_no)
);

INSERT INTO planes (plane_id, capacity)
	VALUES (1, 100),
		   (2, 120),
		   (3, 50);

INSERT INTO flights (flight_num, flight_time, plane_id, end_sales)
	VALUES (1, timestamp '2016-11-28 20:38:40', 1, 0),
		   (2, timestamp '2016-11-29 19:38:40', 2, 0),
		   (3, timestamp '2016-12-01 01:38:20', 1, 0),
		   (4, timestamp '2016-12-14 03:38:40', 2, 0),
		   (5, timestamp '2016-12-16 13:38:10', 2, 0);

INSERT INTO seats (flight_id, seat_no, status, reserved_time)
	VALUES (1, 1, 1, timestamp '2016-11-28 13:38:10'),
		   (1, 2, 2, timestamp '2016-11-28 10:38:10'),
		   (1, 3, 1, timestamp '2016-11-27 13:38:10'),
		   (2, 2, 2, timestamp '2016-11-26 13:38:10'),
		   (2, 5, 1, timestamp '2016-11-29 13:38:10');
		   
SELECT * FROM flights;
SELECT * FROM seats;


-- 1. FreeSeats(FlightId) — список мест, доступных для продажи и бронирования. 
DROP FUNCTION free_seats(fid int);
CREATE OR REPLACE FUNCTION free_seats(fid int) RETURNS TABLE(seat int) AS $$
	DECLARE
		cap int;
	BEGIN
    	cap := (SELECT capacity FROM planes WHERE plane_id = (
	    	SELECT plane_id FROM flights WHERE flight_id = fid));

	    RETURN QUERY (SELECT * FROM generate_series(1, cap) AS X WHERE X NOT IN 
    		(SELECT seat_no FROM seats WHERE flight_id = fid));

    END;
$$ LANGUAGE plpgsql;

SELECT * FROM free_seats(1);
SELECT * FROM free_seats(2);

-- 2. Reserve(FlightId, SeatNo) — пытается забронировать место. 
-- Возвращает истину, если удалось и ложь — в противном случае. 
DROP FUNCTION reserve(fid int, snum int);
CREATE OR REPLACE FUNCTION reserve(fid int, snum int) RETURNS BOOLEAN AS $$
    BEGIN
	   	INSERT INTO seats (flight_id, seat_no, status, reserved_time)
				VALUES (fid, snum, 1, now());
		RETURN FOUND;
    END;
$$ LANGUAGE plpgsql;

SELECT reserve(1, 1);


-- 3. ExtendReservation(FlightId, SeatNo) — пытается продлить бронь места. 
-- Возвращает истину, если удалось и ложь — в противном случае. 

DROP FUNCTION extend_reservation(fid int, snum int);
CREATE OR REPLACE FUNCTION extend_reservation(fid int, snum int) RETURNS BOOLEAN AS $$
    BEGIN
		UPDATE seats SET reserved_time = now() WHERE flight_id = fid AND seat_no = snum;
	    RETURN FOUND;
    END;
$$ LANGUAGE plpgsql;

SELECT extend_reservation(1, 1);


--4.BuyFree(FlightId, SeatNo) — пытается купить свободное место. 
--Возвращает истину, если удалось и ложь — в противном случае. 

DROP FUNCTION buy_free(fid int, snum int);
CREATE OR REPLACE FUNCTION buy_free(fid int, snum int) RETURNS BOOLEAN AS $$
    BEGIN
		INSERT INTO seats (flight_id, seat_no, status, reserved_time)
			VALUES (fid, snum, 2, now());
		RETURN FOUND;		    	
    END;
$$ LANGUAGE plpgsql;

SELECT buy_free(1, 1);

-- 5. BuyReserved(FlightId, SeatNo) — пытается выкупить забронированное место. 
-- Возвращает истину, если удалось и ложь — в противном случае. 
DROP FUNCTION buy_reserved(fid int, snum int);
CREATE OR REPLACE FUNCTION buy_reserved(fid int, snum int) RETURNS BOOLEAN AS $$
    BEGIN
		UPDATE seats SET status = 2 WHERE flight_id = fid AND seat_no = snum;
	    RETURN FOUND;
    END;
$$ LANGUAGE plpgsql;

SELECT buy_reserved(1, 1);

-- 6.FlightStatistics() — возвращает статистику по рейсам: 
-- возможность бронирования и покупки, число свободных, забронированных и проданных мест. 
DROP FUNCTION flight_statistics();
CREATE OR REPLACE FUNCTION flight_statistics() RETURNS TABLE(fid int, fnum int, 
	reserve boolean, buy boolean, frees int, reserveds int, boughts int) AS $$
	DECLARE
		cap int;
	BEGIN
	    RETURN QUERY (SELECT  FROM generate_series(1, cap) AS X WHERE X NOT IN 
    		(SELECT seat_no FROM seats WHERE flight_id = fid));

    END;
$$ LANGUAGE plpgsql;

SELECT * FROM flight_statistics();

