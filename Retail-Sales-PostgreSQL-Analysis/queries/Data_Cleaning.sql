-- Create Database

CREATE DATABASE sql-retail_sales_analysis

-- Create table

Create table r_sales(
transactions_id		INT PRIMARY KEY,
sale_date			DATE,
sale_time			TIME,
customer_id			INT,
gender				VARCHAR(15),
age					INT,
category			VARCHAR(15),
quantiy				INT,
price_per_unit		FLOAT,
cogs				FLOAT,
total_sale			FLOAT
);


-- Data Cleaning

-- 1. Check the dataset
-- 2. Null or blank values
-- 3. Standarize data


Select * From r_sales;

Select COUNT(DISTINCT customer_id) From r_sales;

-- Removing Duplicates

WITH dupli_cte AS(
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantiy,price_per_unit,cogs
						,total_sale) as row_num
FROM r_sales
)
SELECT *
FROM dupli_cte
WHERE row_num > 1; -- There are no duplicates in the dataset.



-- Null or Blank Values

Select *
From r_sales
Where 
	transactions_id IS NULL
OR	sale_date IS NULL
OR 	sale_time IS NULL
OR 	gender IS NULL
OR 	category IS NULL
OR 	quantiy IS NULL
OR	cogs IS NULL
OR 	total_sale IS NULL;

---

DELETE FROM r_sales
WHERE
transactions_id IS NULL
OR	sale_date IS NULL
OR 	sale_time IS NULL
OR 	gender IS NULL
OR 	category IS NULL
OR 	quantiy IS NULL
OR	cogs IS NULL
OR 	total_sale IS NULL;

SELECT * FROM r_sales;



-- Standarize data

-- the date format of a date columns in the data has already been standarized in excel file before importing to postgresql database
-- but i am writing the query to change the date from string and update the column into date format anyway

UPDATE r_sales
SET sale_date = TO_DATE(sale_date, "YYYY-MM-DD"); -- this would convert the string value to date value

-- now converting the date date type seamlessly

ALTER TABLE r_sales
MODIFY COLUMN sale_date DATE;










































