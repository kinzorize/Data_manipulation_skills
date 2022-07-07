SELECT  first_name, last_name FROM customer
WHERE first_name LIKE  'E%' AND address_id < 500
ORDER BY customer_id DESC
LIMIT 1;
==========================================
SELECT * FROM customer
FULL OUTER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE customer.customer_id IS null OR
payment.payment_id IS null;
==============================================
SELECT address.district, customer.email FROM address
INNER JOIN customer
ON address.address_id = customer.address_id
WHERE address.district = 'California'
===========================================
SELECT first_name, last_name, title FROM actor
LEFT JOIN film_actor ON actor.actor_id = film_actor.actor_id
LEFT JOIN film ON film.film_id = film_actor.film_id
WHERE first_name = 'Nick' AND last_name = 'Wahlberg'
================================================
SELECT title, first_name, last_name from actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN film
ON film_actor.film_id = film.film_id 
WHERE first_name = 'Nick' AND
last_name = 'Wahlberg'
=================================================
SELECT EXTRACT(YEAR FROM payment_date) FROM payment
=================================================
SELECT DISTINCT(TO_CHAR(payment_date, 'MONTH')) 
FROM payment
=================================================
SELECT COUNT(*) FROM payment
WHERE (TRIM(TO_CHAR(payment_date, 'Day'))) = 'Monday'
===============================================
SELECT COUNT(*) FROM payment
WHERE EXTRACT(DOW FROM payment_date) = 1;
DOW means days of week
================================================
SELECT first_name || ' ' || last_name FROM customer
===============================================
SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
===============================================
SELECT film_id, title FROM film
WHERE film_id IN
(SELECT inventory.film_id FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30')
ORDER BY film_id
========================================================
SELECT first_name, last_name
FROM customer AS c
WHERE EXISTS
(SELECT * FROM payment as p
WHERE p.customer_id = c.customer_id AND amount > 11)
==================================================
SELECT first_name, last_name
FROM customer AS c
WHERE NOT EXISTS
(SELECT * FROM payment as p
WHERE p.customer_id = c.customer_id AND amount > 11)
=========================================================
# Self-join
SELECT f1.title, f2.title, f1.length
FROM film AS f1
INNER JOIN film AS f2 ON
f1.film_id != f2.film_id
AND f1.length = f2.length
=================================================
SELECT facid, name, membercost, monthlymaintenance 
FROM cd.facilities 
WHERE membercost > 0 AND membercost < (monthlymaintenance/50.0)
======================================
SELECT *
FROM cd.facilities 
WHERE name LIKE '%Tennis%'
===============================
SELECT * FROM cd.facilities 
WHERE facid = 1 OR facid = 5
========================
SELECT * FROM cd.facilities 
WHERE facid IN (1,5)
======================
SELECT memid, surname, firstname, joindate 
FROM cd.members
WHERE joindate >= '2012-09-01'
===================================
SELECT DISTINCT(surname) FROM cd.members
ORDER BY surname ASC
LIMIT 10;
=====================================
SELECT joindate FROM cd.members
ORDER BY joindate DESC
LIMIT 1;
===============================
SELECT facid,  SUM(slots) AS total_slots
FROM cd.bookings
WHERE starttime >= '2012-09-01' AND starttime <= '2012-09-30'
GROUP BY facid
ORDER BY SUM(slots)
==================================
SELECT facid,  SUM(slots) AS total_slots
FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) > 1000
ORDER BY facid
===================================
SELECT cd.bookings.starttime , cd.facilities.name
FROM cd.facilities
INNER JOIN cd.bookings ON 
cd.facilities.facid = cd.bookings.facid
WHERE cd.facilities.facid IN (0,1)
AND cd.bookings.starttime >= '2012-09-21'
AND cd.bookings.starttime < '2012-09-22'
ORDER BY cd.bookings.starttime
==========================================
SELECT cd.members.firstname, cd.members.surname, cd.bookings.starttime 
FROM cd.members
INNER JOIN cd.bookings
ON cd.members.memid = cd.bookings.memid
WHERE cd.members.firstname = 'David' AND cd.members.surname = 'Farrell'
==============================================================
CREATE TABLE account(
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(250) UNIQUE NOT NULL,
    created_on TIMESTAMP NOT NULL,
    last_login TIMESTAMP
)
===========================================
CREATE TABLE job(
    job_id SERIAL PRIMARY KEY,
    job_name VARCHAR(200) UNIQUE NOT NULL
)
============================================
CREATE TABLE account_job(
    user_id INTEGER REFERENCES account(user_id),
    job_id INTEGER REFERENCES job(job_id),
    hire_date TIMESTAMP
)
==============================================
INSERT INTO account(username,password,email,created_on)
VALUES
('Kingsley','password','kingsley@aol.com',CURRENT_TIMESTAMP)
==============================================
INSERT INTO job(job_name)
VALUES
('Customer care')
==============================
INSERT INTO account_job(user_id,job_id,hire_date)
VALUES
(1,1,CURRENT_TIMESTAMP)
================================================
UPDATE account
SET last_login = CURRENT_TIMESTAMP
=================================================
UPDATE account
SET last_login = created_on
=======================================
UPDATE account_job
SET hire_date = account.created_on
FROM account
WHERE account_job.user_id = account.user_id
=======================================
DELETE FROM account 
WHERE user_id = 3
RETURNING user_id,username,password,email,created_on
==============================================
CREATE TABLE information(
    info_id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    person VARCHAR(50) NOT NULL UNIQUE
)
===============================================
ALTER TABLE information 
RENAME TO help_desk
============================
ALTER TABLE help_desk
RENAME COLUMN person TO people
================================
ALTER TABLE help_desk
RENAME COLUMN person TO people
==================================
ALTER TABLE help_desk
ALTER COLUMN people SET NOT NULL
==============================
ALTER TABLE help_desk
ALTER COLUMN people DROP NOT NULL
================================
ALTER TABLE help_desk 
DROP COLUMN people
========================
CREATE TABLE employees(
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE CHECK (birthdate > '1900-01-01'),
    hire_date DATE CHECK (hire_date > birthdate),
    salary INTEGER CHECK (salary > 0)
    
)
===================================
INSERT INTO employees(
    first_name,
    last_name,
    birthdate,
    hire_date,
    salary
)
VALUES
('Kingsley',
 'Elijah',
 '1985-09-12',
 '2022-09-12',
 2500
 
)
=============================================
SELECT customer_id,
CASE
    WHEN (customer_id <= 100) THEN 'Premium'
    WHEN (customer_id BETWEEN 100 AND 200) THEN 'Plus'
    ELSE 'Normal'
END
FROM customer
======================================
SELECT customer_id,
CASE
    WHEN (customer_id <= 100) THEN 'Premium'
    WHEN (customer_id BETWEEN 100 AND 200) THEN 'Plus'
    ELSE 'Normal'
END AS customer_class
FROM customer
=================================================
SELECT customer_id,
CASE customer_id
    WHEN 2 THEN 'Winner'
    WHEN 5 THEN 'Second Place'
    ELSE 'Normal'
END AS raffle_results
FROM customer
==============================
SELECT rental_rate,
CASE rental_rate 
    WHEN 0.99 THEN 1
    ELSE 0
END
FROM film
============================
SELECT 
SUM(CASE rental_rate 
    WHEN 0.99 THEN 1
    ELSE 0
END) AS number_of_bargain
FROM film
================================
SELECT 
SUM(CASE rental_rate 
    WHEN 0.99 THEN 1
    ELSE 0
END) AS bargain,
SUM(CASE rental_rate
    WHEN 2.99 THEN 1
    ELSE 0
END) AS regular,
SUM(CASE rental_rate
    WHEN 4.99 THEN 1
    ELSE 0
END) AS Premium
FROM film
==============================
SELECT 
SUM(CASE rating
     WHEN 'R' THEN 1
     ELSE 0
END) AS r_rating,
SUM(CASE rating
     WHEN 'PG' THEN 1
     ELSE 0
END) AS pg_rating,
SUM(CASE rating
     WHEN 'PG-13' THEN 1
     ELSE 0
END) AS pg13_rating
FROM film
===========================
SELECT CAST('5' AS INTEGER) AS new_int
============================
# CAST FOR POSTGRESSQL
SELECT '10':: INTEGER
===============================
SELECT CHAR_LENGTH(CAST(inventory_id AS VARCHAR)) FROM rental
==============================
SELECT (
    SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END)/
    SUM(CASE WHEN department = 'B' THEN 1 ELSE 0 END)
) AS department_ratio
FROM deptS
======================================================
DELETE FROM deptS
WHERE department = 'B'
=======================
SELECT (
    SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END)/
    NULLIF(SUM(CASE WHEN department = 'B' THEN 1 ELSE 0 END),0)
) AS department_ratio
FROM deptS
===================================================
CREATE VIEW customer_info AS
SELECT first_name, last_name, address FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
============================================
SELECT * FROM customer_info
===============================
CREATE OR REPLACE VIEW customer_info AS
SELECT first_name, last_name, address, district FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
==================================================
DROP VIEW IF EXISTS customer_info
===================================
ALTER VIEW customer_info RENAME TO c_info
===================================



