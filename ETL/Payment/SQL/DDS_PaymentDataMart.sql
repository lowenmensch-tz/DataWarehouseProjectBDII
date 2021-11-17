/*
    @author kenneth.cruz@unah.hn
    @version 0.0.1
    @date 11/15/2021
*/


-- Data Mart: Películas
CREATE TABLE DIM_FILM(
    FILM_ID INT PRIMARY KEY, 
    TITLE VARCHAR(255)
);


-- Dimensión: Tiendas
CREATE TABLE DIM_STORE(
    STORE_ID INT PRIMARY KEY, 
    MANAGER_NAME VARCHAR(90),
    CITY VARCHAR(50),
    COUNTRY VARCHAR(50)
);


-- Dimensión: Categorías
CREATE TABLE DIM_CATEGORY(
    CATEGORY_ID INT PRIMARY KEY, 
    NAME VARCHAR(25)
);


-- Dimensión: Películas - Categorías
CREATE TABLE DIM_FILM_CATEGORY(
    FILM_ID INT PRIMARY KEY, 
    CATEGORY_ID INT , 
);


-- Dimensión: Tiempo
-- Esta dimensión está basada en el tiempo de la tabla RENTAL
CREATE TABLE DIM_TIME(
    TIME_ID INT PRIMARY KEY, 
    DATE DATETIME, 
    YEAR INT, 
    MONTH INT, 
    DAY INT, 
    TRIMESTER INT, 
    SEMESTER INT
);


-- Hechos: Pagos
CREATE TABLE FACT_PAYMENT(
    PAYMENT_ID INT PRIMARY KEY,
    FILM_ID INT, 
    STORE_ID INT, 
    CATEGORY_ID INT, 
    FILM_CATEGORY INT, 
    TIME_ID INT,
    PAYMENT_DATE DATETIME,
    AMOUNT DECIMAL(7,2), 

    FOREIGN KEY (FILM_ID) REFERENCES DIM_FILM(FILM_ID) ON DELETE CASCADE,
    FOREIGN KEY (STORE_ID) REFERENCES DIM_STORE(STORE_ID) ON DELETE CASCADE,
    FOREIGN KEY (CATEGORY_ID) REFERENCES DIM_CATEGORY(CATEGORY_ID) ON DELETE CASCADE,
    FOREIGN KEY (FILM_CATEGORY) REFERENCES DIM_FILM_CATEGORY(FILM_ID) ON DELETE CASCADE,
    FOREIGN KEY (TIME_ID) REFERENCES DIM_TIME(TIME_ID) ON DELETE CASCADE
);



-- --------------------------------------------------------
--                  --- Eliminar Tablas ---
-- --------------------------------------------------------

DROP TABLE IF EXISTS FACT_PAYMENT;
DROP TABLE IF EXISTS DIM_FILM;
DROP TABLE IF EXISTS DIM_STORE;
DROP TABLE IF EXISTS DIM_CATEGORY;
DROP TABLE IF EXISTS DIM_FILM_CATEGORY;
DROP TABLE IF EXISTS DIM_TIME;

/*
    job_data_mart_customer
    cargar_dimensiones
    transformation_dim_customer
    transformation_fact_
*/


-- --------------------------------------------------------
--                  --- Eliminar DATOS ---
-- --------------------------------------------------------

DELETE FROM FACT_PAYMENT;
DELETE FROM DIM_FILM;
DELETE FROM DIM_STORE;
DELETE FROM DIM_CATEGORY;
DELETE FROM DIM_FILM_CATEGORY;
DELETE FROM DIM_TIME;


-- job_data_mart_cliente