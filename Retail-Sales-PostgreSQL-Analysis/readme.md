# 🛍️ Retail Sales Analysis (SQL + Excel)

## 📘 Project Overview
The **Retail Sales Analysis** project demonstrates an end-to-end data analytics workflow using **MySQL** and **Excel**.  
The goal was to analyze retail transactions, perform cleaning, validation, and exploratory analysis to uncover trends across customers, products, and time periods.

This project highlights **SQL proficiency**, **data-driven problem solving**, and **structured business analytics**.

---

## 🎯 Objectives
- Import and clean sales data in **MySQL Workbench**.  
- Validate, standardize, and preprocess raw data.  
- Conduct descriptive and exploratory data analysis using SQL.  
- Identify customer patterns and category performance.  
- Prepare structured results for visualization and documentation.

---

## 🧱 Dataset Description
**Dataset:** `retail_sales.csv`  
**Source:** Simulated dataset for learning and analysis.

| Column | Description |
|---------|-------------|
| `transactions_id` | Unique transaction ID |
| `sale_date` | Date of transaction |
| `sale_time` | Time of transaction |
| `customer_id` | Unique customer ID |
| `gender` | Gender of the customer |
| `age` | Customer age |
| `category` | Product category (Clothing, Beauty, Electronics, etc.) |
| `quantiy` | Units sold |
| `price_per_unit` | Price per unit |
| `cogs` | Cost of goods sold |
| `total_sale` | Total sales amount per transaction |

---

## ⚙️ Tools & Technologies
- **MySQL Workbench** – Querying, analysis, and data cleaning  
- **Microsoft Excel** – Initial data formatting and quality checks  
- **GitHub** – Project documentation and portfolio publishing  

---

## 🔧 Project Workflow

### 1. Data Loading
```sql
-- Create Database
CREATE DATABASE sql_retail_sales_analysis;

-- Create Table
CREATE TABLE r_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

## 2. Data Cleaning
**Checking Dataset**
```sql

SELECT * FROM r_sales;
SELECT COUNT(DISTINCT customer_id) FROM r_sales;
Removing Duplicates
sql
Copy code
WITH dupli_cte AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantiy, price_per_unit, cogs, total_sale
        ) AS row_num
    FROM r_sales
)
SELECT *
FROM dupli_cte
WHERE row_num > 1; -- No duplicates found
```

**Handling Null or Blank Values**
```sql

SELECT *
FROM r_sales
WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

DELETE FROM r_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

**Standardizing Date Format**
```sql

UPDATE r_sales
SET sale_date = TO_DATE(sale_date, 'YYYY-MM-DD');

ALTER TABLE r_sales
MODIFY COLUMN sale_date DATE;
```

## 3. Data Exploration
**General Overview**
```sql

SELECT COUNT(*) AS total_sales FROM r_sales;
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM r_sales;
SELECT COUNT(DISTINCT category) AS total_categories FROM r_sales;
SELECT SUM(total_sale) AS total_revenue FROM r_sales;
SELECT SUM(quantiy) AS total_quantity FROM r_sales;
```
**Gender-Based Sales**
```sql

SELECT gender, SUM(total_sale) AS total_sales
FROM r_sales
GROUP BY gender;
```

## 4. Data Analysis & Queries
1️⃣ Sales on a Specific Date
```sql

SELECT *
FROM r_sales
WHERE sale_date = '2022-11-05';
```

**2️⃣ Clothing Category Sales (Nov 2022, Quantity > 3)**
```sql

SELECT *
FROM r_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantiy >= 3;
```

**3️⃣ Total Sales by Category**
```sql

SELECT category, SUM(total_sale) AS total_sales, COUNT(*) AS total_orders
FROM r_sales
GROUP BY category;
```

**4️⃣ Average Age by Category**
```sql

SELECT category, ROUND(AVG(age), 0) AS avg_age
FROM r_sales
WHERE category = 'Beauty'
GROUP BY category;
```

**5️⃣ High-Value Transactions**
```sql

SELECT *
FROM r_sales
WHERE total_sale > 1000;
```

**6️⃣ Gender-wise Transactions by Category**
```sql

SELECT category, gender, COUNT(*) AS total_trans
FROM r_sales
GROUP BY category, gender
ORDER BY category, total_trans DESC;
```

**7️⃣ Monthly Average Sales (Best Month)**
```sql

SELECT *
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date)
                     ORDER BY AVG(total_sale) DESC) AS rank
    FROM r_sales
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;
```

**8️⃣ Top 5 Customers by Total Sales**
```sql

SELECT customer_id, SUM(total_sale) AS total_spent
FROM r_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;
```

**9️⃣ Unique Customers per Category**
```sql

SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM r_sales
GROUP BY category;
```

**🔟 Sales by Time-of-Day (Shift Analysis)**
```sql

WITH shift_cte AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM r_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM shift_cte
GROUP BY shift;
```

## 📂 Repository Structure

sql-retail-sales-analysis/
sql-retail-sales-analysis/
│
├── data/
│ └── retail_sales.csv
│
├── queries/
│ └── retail_sales_analysis.sql
│
└── README.md

## 📄 Deliverables
**Cleaned dataset**: retail_sales.csv

**SQL script**: retail_sales_analysis.sql

README project documentation


## 🧠 Skills Demonstrated
- **SQL Querying & Aggregation**
- **Data Cleaning and Standardization**
- **Exploratory Data Analysis (EDA)**
- **Business Reporting using SQL**
- **GitHub Documentation & Version Control**

## 📈 Domain
**Retail & E-commerce Analytics**
**Focus**: Customer behavior, product performance, and business KPIs.

## 🏁 Conclusion
This project showcases an end-to-end Data Analytics workflow using SQL and Excel — from cleaning and validation to analysis and structured reporting.
It reflects the analytical mindset and technical capability required for real-world business analysis and decision support.



---
