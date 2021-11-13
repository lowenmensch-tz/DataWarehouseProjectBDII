

USE sakila;

--
-- Clientes
-- 

-- Top 10 clientes con mayores rentas

SELECT 
	CONCAT(CUSTOMER.first_name, ' ', CUSTOMER.last_name) AS 'Nombre completo', 
	CountCustomerRent.countCustomer AS 'Total Rentas'
FROM
	CUSTOMER
INNER JOIN 
(
SELECT 
	TOP 10
	customer_id,
	COUNT(customer_id) AS countCustomer
FROM 
	RENTAL
GROUP BY 
	customer_id
ORDER BY 
	COUNT(customer_id) DESC
) AS CountCustomerRent ON CUSTOMER.customer_id = CountCustomerRent.customer_id
;


-- Clientes con DVD vencidos
SELECT 
	CONCAT(CUSTOMER.first_name, ' ', CUSTOMER.last_name) AS customer,
	CUSTOMER.email,
	ADDRESS.phone, 
	FILM.title, 
FROM 
	RENTAL
INNER JOIN 
	CUSTOMER ON RENTAL.customer_id = CUSTOMER.customer_id
INNER JOIN 
	ADDRESS ON customer.address_id = ADDRESS.address_id
INNER JOIN 
	inventory ON RENTAL.inventory_id = inventory.inventory_id
INNER JOIN 
	FILM ON inventory.film_id = FILM.film_id
WHERE 
	RENTAL.return_date IS NULL
	AND SYSDATETIME() > DATEADD(DAY, FILM.rental_duration,  RENTAL.RENTAL_DATE)
ORDER BY 
	FILM.title
;


-- Pagos mensuales para el top 10 clientes (por mes) para el a�o 2005
SELECT 
	CONCAT(CUSTOMER.first_name, ' ', CUSTOMER.last_name) AS 'Nombre completo', 
	CountCustomerRent.countCustomer AS 'Total Rentas'
FROM
	CUSTOMER
INNER JOIN 
(
SELECT 
	FORMAT(rental_date, 'MM') AS Month,
	customer_id,
	COUNT(FORMAT(rental_date, 'MM')) AS countCustomer
FROM 
	RENTAL
WHERE 
	FORMAT(rental_date, 'yy') = '05'
GROUP BY 
	FORMAT(rental_date, 'MM'), 
--ORDER BY 
--	countCustomer DESC
) AS CountCustomerRent ON CUSTOMER.customer_id = CountCustomerRent.customer_id
;

SELECT * FROM RENTAL;


-- Promedio de mora (saldo pendiente) entre los clientes


----------------------------------------------------

--
-- Productividad de los empleados
--

-- Top 10 de vendedores


SELECT 
	CONCAT(STAFF.first_name, ' ', STAFF.last_name) AS 'Nombre completo', 
	CountCustomerRent.countCustomer AS 'Total Rentas'
FROM
	STAFF
INNER JOIN 
(
SELECT 
	TOP 10
	staff_id,
	COUNT(staff_id) AS countCustomer
FROM 
	RENTAL
GROUP BY 
	staff_id
ORDER BY 
	COUNT(staff_id) DESC
) AS CountCustomerRent ON STAFF.staff_id = CountCustomerRent.staff_id
;


-- Mes del a�o en el que hay mayores rentas

SELECT 
	FORMAT(rental_date, 'MM') AS Mes, 
	COUNT(*) AS 'Cantidad de Rentas'
FROM 
	RENTAL
GROUP BY 
	FORMAT(rental_date, 'MM')
ORDER BY 
	COUNT(*) DESC
;

----------------------------------------------------


--
-- Precio medio de venta
--

SELECT 
	COUNT(*)/(
				SELECT 
					SUM(amount)
				FROM
					PAYMENT
			)
FROM
	PAYMENT
;


-- Articulos vendidos por mes para el 2005
SELECT 
	FORMAT(payment_date, 'MM') AS Mes,
	COUNT(*) Cantidad, 
	SUM(amount) AS 'Monto total vendido', 
	SUM(amount)/COUNT(*) AS 'Precio medio ventas'
FROM
	PAYMENT
WHERE
	FORMAT(payment_date, 'yy') = '05'
GROUP BY 
	FORMAT(payment_date, 'MM')
;


----------------------------------------------------



--
-- Ventas
--

-- Cu�les son las regiones con mayores ventas
	-- Direcci�n de los establecimientos
SELECT 
	CONCAT(STAFF.first_name, ' ', STAFF.last_name) AS Encargado,
	COUNTRY.country AS Country, 
	CITY.city AS City, 
	ADDRESS.address AS Address, 
	ADDRESS.address2 AS Address2, 
	TotAmount.TotAmount AS 'Monto Total ventas'
FROM 
	STAFF
INNER JOIN 
	STORE ON STAFF.staff_id = STORE.manager_staff_id
INNER JOIN 
	 ADDRESS ON STORE.address_id = ADDRESS.address_id 
INNER JOIN 
	 CITY ON ADDRESS.city_id = CITY.city_id 
INNER JOIN 
	 COUNTRY ON CITY.country_id = COUNTRY.country_id 
INNER JOIN	
	(
	-- Monto total de ventas por tienda
	SELECT 
		INVENTORY.store_id AS store_id,
		SUM(PAYMENT.amount) TotAmount
	FROM
		INVENTORY 
	INNER JOIN 
		RENTAL ON INVENTORY.inventory_id = RENTAL.inventory_id
	INNER JOIN 
		PAYMENT ON RENTAL.rental_id = PAYMENT.rental_id
	GROUP BY 
		INVENTORY.store_id
	) AS TotAmount ON  STORE.store_id = TotAmount.store_id
;


-- N�mero de alquileres de cada tienda por mes
-- A traves del tiempo (meses)
SELECT 
	INVENTORY.store_id AS store_id,
	FORMAT(RENTAL.rental_date, 'yy') AS Year,
	FORMAT(RENTAL.rental_date, 'MM') AS Month,
	COUNT(PAYMENT.amount) TotAmount
FROM
	INVENTORY 
INNER JOIN 
	RENTAL ON INVENTORY.inventory_id = RENTAL.inventory_id
INNER JOIN 
	PAYMENT ON RENTAL.rental_id = PAYMENT.rental_id
GROUP BY 
	FORMAT(RENTAL.rental_date, 'yy'), FORMAT(RENTAL.rental_date, 'MM'), INVENTORY.store_id 
;

-- Total pel�culas rentadas por categor�as

SELECT	
	CATEGORY.name AS name, 
	COUNT_CATEGORY.Count_category AS Count_category
FROM 
	CATEGORY
INNER JOIN 
(
	SELECT 
		CATEGORY.category_id AS category_id,
		COUNT(CATEGORY.category_id) AS Count_category
	FROM
		CATEGORY
	INNER JOIN 
		FILM_CATEGORY ON CATEGORY.category_id = FILM_CATEGORY.category_id 
	INNER JOIN 
		INVENTORY ON FILM_CATEGORY.film_id = INVENTORY.film_id 
	INNER JOIN 
			RENTAL ON INVENTORY.inventory_id = RENTAL.inventory_id
	INNER JOIN 
			PAYMENT ON RENTAL.rental_id = PAYMENT.rental_id
	GROUP BY 
		CATEGORY.category_id 
) AS COUNT_CATEGORY ON CATEGORY.category_id  = COUNT_CATEGORY.category_id 
ORDER BY 
	name
;

-- Ventas en base a los productos


-- Ca�da de las ventas a lo largo de los a�os

----------------------------------------------------

--
-- Productos
--

-- Nombres de las pel�cula m�s rentada


SELECT 
	FILM.title AS 'Pel�cula', 
	FILM.rating AS 'Calificaci�n', 
	COUNT_RENTAL.CountRental AS 'Cantidad Rentas'
FROM 
	FILM
INNER JOIN 
	(
		-- Cantidad de DVD en inventario
		SELECT 
			INVENTORY.film_id AS film_id, 
			COUNT(INVENTORY.film_id) AS CountRental
		FROM 
			RENTAL
		INNER JOIN 
			INVENTORY ON RENTAL.inventory_id = INVENTORY.inventory_id 
		GROUP BY 
			INVENTORY.film_id 
	) AS COUNT_RENTAL ON FILM.film_id = COUNT_RENTAL.film_id
ORDER BY 
	COUNT_RENTAL.CountRental DESC
;


-- Actor m�s cotizado entre las peliculas rentadas


-- Categor�a de pel�culas con mayores rentas

SELECT * FROM FILM;


SELECT * FROM INVENTORY;
----------------------------------------------------