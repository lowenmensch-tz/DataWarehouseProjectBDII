/*
    @author kenneth.cruz@unah.hn
    @version 0.0.1
    @date 11/12/2021
*/

-- --------------------------------------------------------
--                  --- SQL: ETL ---
-- --------------------------------------------------------

-- Dimensión: Rentas
SELECT
    RENTAL.RENTAL_ID AS rental_id, 
    RENTAL.RENTAL_DATE AS rental_date, 
    FILM.RENTAL_DURATION AS rental_duration,
    CASE 
        WHEN  DATEDIFF(DAY, DATEADD(DAY, FILM.RENTAL_DURATION,  RENTAL.RENTAL_DATE), SYSDATETIME()) > 0  THEN DATEDIFF(DAY, DATEADD(DAY, FILM.RENTAL_DURATION,  RENTAL.RENTAL_DATE), SYSDATETIME())
        ELSE 0
    END AS days_late
FROM 
    RENTAL 
INNER JOIN 
	INVENTORY ON RENTAL.INVENTORY_ID = INVENTORY.INVENTORY_ID
INNER JOIN 
	FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
;


-- Dimensión: Payment
SELECT 
    PAYMENT_ID AS payment_id, 
    AMOUNT AS amount
FROM 
    PAYMENT
;


-- Dimensión: Address
SELECT 
    ADDRESS.ADDRESS_ID AS address_id, 
    CITY.CITY AS city_name, 
    COUNTRY.COUNTRY AS country_name
FROM
    ADDRESS
INNER JOIN 
    CITY ON ADDRESS.CITY_ID = CITY.CITY_ID
INNER JOIN 
    COUNTRY ON CITY.COUNTRY_ID = COUNTRY.COUNTRY_ID
;


-- Dimensión: Tiempo   
    -- 
SELECT 
    PAYMENT.PAYMENT_ID AS time_id, 
    CONVERT(DATE, PAYMENT.PAYMENT_DATE) AS date,
    DATEPART(YEAR, PAYMENT.PAYMENT_DATE) AS year,
    DATEPART(MONTH, PAYMENT.PAYMENT_DATE) AS month,
    DATEPART(WEEK, PAYMENT.PAYMENT_DATE) AS day, 
    CASE 
        WHEN DATEPART(MONTH, PAYMENT.PAYMENT_DATE)/2 > 6 THEN 2 
        ELSE 1 
    END AS semester, 
    DATEPART(QUARTER, PAYMENT.PAYMENT_DATE) AS trimester, 
    DATENAME(WEEKDAY, PAYMENT.PAYMENT_DATE) AS day_of_week
-- ) AS week
FROM 
    PAYMENT
;


-- Hechos: Clientes
SELECT 
    --PAYMENT.PAYMENT_ID AS customer_id,
    CUSTOMER.CUSTOMER_ID AS customer_id,
    RENTAL.RENTAL_ID AS rental_id, 
    PAYMENT.PAYMENT_ID AS payment_id, 
    ADDRESS.ADDRESS_ID AS address_id, 
    PAYMENT.PAYMENT_ID AS time_id, 
    CONCAT(CUSTOMER.FIRST_NAME, ' ', CUSTOMER.LAST_NAME) AS name 
FROM 
    CUSTOMER
INNER JOIN 
    PAYMENT ON CUSTOMER.CUSTOMER_ID = PAYMENT.CUSTOMER_ID
INNER JOIN 
    RENTAL ON  PAYMENT.RENTAL_ID = RENTAL.RENTAL_ID
INNER JOIN 
    ADDRESS ON CUSTOMER.ADDRESS_ID = ADDRESS.ADDRESS_ID
;