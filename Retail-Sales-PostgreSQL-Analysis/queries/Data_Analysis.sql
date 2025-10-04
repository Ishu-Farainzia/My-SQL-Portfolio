-- Data Exploration

SELECT * FROM r_sales;

-- How many sales we have?
SELECT COUNT(*)
FROM r_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id)
FROM r_sales;

-- How many unique categories?
SELECT COUNT(DISTINCT category)
FROM r_sales;

-- Total and average sales?
SELECT SUM(total_sale) FROM r_sales;

-- Total Quantity
SELECT SUM(quantiy)
FROM r_sales;

-- Male vs Female purchases
SELECT gender, SUM(total_sale)
FROM r_sales
GROUP BY gender;


-- Data Analysis and Findings

-- 1. Sales data on '2022-11-05'?

SELECT *
FROM r_sales
WHERE sale_date = '2022-11-05';

-- 2. Sales data for "Clothing" category where quantity sold > 3 made on Nov-2022.

SELECT *
FROM r_sales
WHERE category = 'Clothing'
AND	TO_CHAR(sale_date, 'YYYY-mm') = '2022-11'
AND quantiy >= 3;

-- 3. Total sales for each Category

SELECT category, SUM(total_sale) total_sales, COUNT(*) total_orders
FROM r_sales
GROUP BY 1;

-- 4. Average age of customers of "beauty" category

SELECT category, ROUND(AVG(age),0) avg_age 
FROM r_sales
WHERE category = 'Beauty'
GROUP BY category;

-- 5. sales data where total_sales > 1000.

SELECT *
FROM r_sales
WHERE total_sale > 1000;

-- 6. total number of Transactions made by each gender in each category.

SELECT category, gender, COUNT(*) total_trans
FROM r_sales
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- 7. Calculate the avg sales by each month, best selling 

SELECT * FROM (
SELECT 
	EXTRACT(YEAR FROM sale_date) AS YEAR,
	EXTRACT(MONTH FROM sale_date) AS MONTH,
	AVG(total_sale) avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM r_sales
GROUP BY 1,2) as t1
WHERE rank = 1;

-- 8. top 5 customers based on the hightest sales

SELECT customer_id, SUM(total_sale)
FROM r_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 9. Number of unique customers who purchased from each categories.

SELECT category, COUNT(DISTINCT customer_id)
FROM r_sales
GROUP BY 1;

-- 10. Create each shift and number of orders.

WITH shift_cte AS(

SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Moring'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END AS shift
FROM r_sales

)
SELECT shift, COUNT(*)
FROM shift_cte
GROUP BY shift;

-- End

















