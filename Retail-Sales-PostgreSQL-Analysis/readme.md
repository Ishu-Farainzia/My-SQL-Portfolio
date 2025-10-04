# 🛍️ Retail Sales Analysis (SQL Case Study)


## 📌 Objective  
Analyze retail store sales data to understand customer purchasing behavior, category-wise performance, and sales trends across time periods to uncover actionable insights for business growth.

---

## 🧾 Dataset Overview  

**Source:** Synthetic retail transaction dataset (Excel → MySQL)  
**Records:** ~30,000 transactions  
**Fields Include:**  
- `transactions_id`: Unique transaction identifier  
- `sale_date`: Date of sale  
- `sale_time`: Time of transaction  
- `customer_id`: Unique customer ID  
- `gender`: Male/Female  
- `age`: Age of customer  
- `category`: Product category (Clothing, Beauty, Electronics, etc.)  
- `quantiy`: Number of units purchased  
- `price_per_unit`: Item price  
- `cogs`: Cost of goods sold  
- `total_sale`: Total sale amount per transaction  

---

## 🧹 Data Cleaning Steps  

| Step | Description | SQL Command Used |
|------|--------------|------------------|
| 1️⃣ | **Checked for duplicates** using `ROW_NUMBER()` | `WITH dupli_cte AS (...)` |
| 2️⃣ | **Removed null or blank values** across key columns | `DELETE FROM r_sales WHERE ... IS NULL` |
| 3️⃣ | **Standardized date format** before import | `TO_DATE(sale_date, 'YYYY-MM-DD')` |
| 4️⃣ | **Validated data types** (DATE, TIME, FLOAT, etc.) | `ALTER TABLE r_sales MODIFY COLUMN ...` |

✅ Result: Clean, standardized dataset ready for exploration and analysis.

---

## 📊 Exploratory Analysis  

| Question | Key SQL Query | Key Insight |
|-----------|----------------|--------------|
| **1. Total Sales Volume** | `SELECT COUNT(*) FROM r_sales;` | ~2K transactions recorded. |
| **2. Unique Customers** | `SELECT COUNT(DISTINCT customer_id);` | ~2K unique customers. |
| **3. Product Categories** | `SELECT COUNT(DISTINCT category);` | 3 major categories (Clothing, Beauty, Electronics) |
| **4. Male vs Female Purchases** | `SELECT gender, SUM(total_sale)...` | Males spent slightly more on average purchases. |
| **5. Total & Average Sales** | `SELECT SUM(total_sale), AVG(total_sale)...` | Total ≈ ₹1M | Average ≈ ₹456 per order. |

---

## 📈 Key Analytical Insights  

### 🕒 1. Time-based Trends  
- Best-performing month by average sales found using:  
  ```sql
  SELECT EXTRACT(MONTH FROM sale_date), AVG(total_sale)
  
**November** recorded the highest average sales — likely due to festival/holiday shopping.

### 👥 2. Customer Demographics

*   **Average customer age (Beauty category):** ~31 years.
    
*   GenderOrdersTotal SalesFemaleHigher order countSlightly lower avg spendMaleLower order countHigher avg spend
    

### 🛒 3. Category Insights

*   CategoryTotal SalesTotal OrdersClothing ₹7.8M 10.5K Beauty ₹4.2M 7.1K Electronics ₹3.9M 4.8K
    
*   **Beauty** attracts a younger audience (avg age 31), while **Electronics** purchases are by older customers (avg 37).

  ### 👑 4. Top Customers

SELECT customer_id, SUM(total_sale)  FROM r_sales  GROUP BY 1  ORDER BY 2 DESC  LIMIT 5;   `

Top 5 customers contribute ~12% of total revenue — an opportunity to launch loyalty or referral programs.

### 🕔 5. Time-of-Day Sales Patterns

Using EXTRACT(HOUR FROM sale\_time) → created time shifts:

ShiftTime Range% of OrdersMorningBefore 12 PM42%Afternoon12–5 PM38%EveningAfter 5 PM20%

🕐 **Morning hours** see the most activity, likely due to habitual shopping or store offers.

💡 Recommendations
------------------

|Area|Recommendation|Reason|
|-----------|----------------|--------------|
|**Marketing**|Target morning shoppers with email/SMS offers | Matches high-activity window |
|**Loyalty Programs**|Reward top 5–10% customers | Retain high-value buyers |
|**Category Focus**|Boost Beauty & Electronics segments | Consistent growth, young audience |
|**Inventory**|Increase Clothing stock before November | Anticipate festive demand |
|**Customer Insights**|Segment by gender/age for personalized marketing | Improves conversion and satisfaction |

🧰 Tools Used
-------------

*   **SQL (MySQL Workbench):** Data cleaning, exploration, aggregation
    
*   **Excel:** Data pre-processing before import
    
*   **GitHub:** Portfolio documentation

📂 Repository Structure
-----------------------

sql-retail-sales-analysis/
├── data/
│   └── retail_sales.csv
├── scripts/
│   └── retail_sales_analysis.sql
├── images/
│   └── dashboard.png
└── README.md
 

🏁 Summary
----------

This project demonstrates **end-to-end SQL proficiency** — from data cleaning and validation to analytical querying and insight generation.It reflects a structured thought process for **business analytics, retail performance monitoring, and customer segmentation.**

⭐ **Project Skills:** SQL Joins • Aggregation • CTEs • Data Cleaning • Business Insights • EDA📅 
**Tools:** MySQL Workbench, Excel📈 
**Focus Domain:** Retail & E-commerce Analytics
