/*
    @author kenneth.cruz@unah.hn
    @version 0.0.1
    @date 11/12/2021
*/

-- --------------------------------------------------------
--              --- Data Mart: Clientes---
-- --------------------------------------------------------

-- database name: OLAP_SAKILA_CUSTOMER
-- USE OLAP_SAKILA_CUSTOMER

-- Dimensión: Rentas
CREATE TABLE DIM_RENTAL(
    RENTAL_ID INT PRIMARY KEY, 
    RENTAL_DATE DATETIME, 
    RENTAL_DURATION INT,
    DAYS_LATE INT
);


-- Dimensión: Payment
CREATE TABLE DIM_PAYMENT(
    PAYMENT_ID INT PRIMARY KEY, 
    AMOUNT DECIMAL(5, 2)
);


-- Dimensión: Address
CREATE TABLE DIM_ADDRESS(
    ADDRESS_ID INT PRIMARY KEY, 
    CITY VARCHAR(50),
    COUNTRY VARCHAR(50)
);


-- Dimensión: Tiempo   Pagos mensuales 
CREATE TABLE DIM_TIME(  
    TIME_ID INT PRIMARY KEY, 
    DATE DATETIME, 
    YEAR INT, 
    MONTH INT, 
    DAY INT, 
    TRIMESTER INT, 
    SEMESTER INT, 
    DAY_OF_WEEK VARCHAR(10) 
);


-- Hechos: Clientes
CREATE TABLE FACT_CUSTOMER(
    CUSTOMER_ID INT PRIMARY KEY, 
    RENTAL_ID INT,
    PAYMENT_ID INT,
    ADDRESS_ID INT,
    TIME_ID INT, 
    NAME VARCHAR(90), 

    FOREIGN KEY (RENTAL_ID) REFERENCES DIM_RENTAL(RENTAL_ID) ON DELETE CASCADE, 
    FOREIGN KEY (PAYMENT_ID) REFERENCES DIM_PAYMENT(PAYMENT_ID) ON DELETE CASCADE,
    FOREIGN KEY (ADDRESS_ID) REFERENCES DIM_ADDRESS(ADDRESS_ID) ON DELETE CASCADE,
    FOREIGN KEY (TIME_ID) REFERENCES DIM_TIME(TIME_ID) ON DELETE CASCADE
);



-- --------------------------------------------------------
--                  --- Eliminar Tablas ---
-- --------------------------------------------------------

DROP TABLE FACT_CUSTOMER;
DROP TABLE DIM_RENTAL;
DROP TABLE DIM_PAYMENT;
DROP TABLE DIM_ADDRESS;
DROP TABLE DIM_TIME;

/*
    job_data_mart_customer
    cargar_dimensiones
    transformation_dim_customer
    transformation_fact_
*/


-- --------------------------------------------------------
--                  --- Eliminar DATOS ---
-- --------------------------------------------------------

DELETE FROM FACT_CUSTOMER;
DELETE FROM DIM_RENTAL;
DELETE FROM DIM_PAYMENT;
DELETE FROM DIM_ADDRESS;
DELETE FROM DIM_TIME;