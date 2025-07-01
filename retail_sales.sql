-- SQL Retail Sales Analysis
CREATE DATABASE Retail_Sales_Analysis;

USE  Retail_Sales_Analysis;

-- Create Table
CREATE TABLE retail_sales(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	 INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,    
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- 1.Data Cleaning 

-- Inspect rows with NULL values
SELECT * 
FROM retail_sales
WHERE 
    transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    category IS NULL OR
    quantity IS NULL OR  
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;

-- Delete rows with NULL values
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    category IS NULL OR
    quantity IS NULL OR 
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;
    
    -- Find duplicates
SELECT transactions_id, COUNT(*) 
FROM retail_sales
GROUP BY transactions_id
HAVING COUNT(*) > 1;

-- Check gender values
SELECT DISTINCT gender FROM retail_sales;

-- 2.Data Exploration

-- View Sample Records
SELECT * 
FROM retail_sales
LIMIT 10;

-- Total number of rows
SELECT COUNT(*) AS total_rows 
FROM retail_sales;

-- Column names and types (for MySQL)
SHOW COLUMNS FROM retail_sales;

--  Date Range of Sales
SELECT 
    MIN(sale_date) AS first_sale_date,
    MAX(sale_date) AS last_sale_date
FROM retail_sales;

-- 1. Total number of sales
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- 2. Total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

--  3. Unique categories
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Questions

--  Q1: Sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

--  Q2: 'Clothing' category sales with quantity >= 4 in Nov 2022
SELECT *
FROM retail_sales 
WHERE 
    category = 'Clothing'
    AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND quantity >= 4;

-- Q3: Total sales and orders per category
SELECT 
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4: Average age of customers in 'Beauty' category
SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales 
WHERE category = 'Beauty';

-- Q5: Transactions with total sales > 1000
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- Q6: Total transactions per gender and category
SELECT 
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7: Best-selling month in each year (based on average sales)
WITH ranked_sales AS (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_sales
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT *
FROM ranked_sales
WHERE rank_sales = 1;

-- Q8: Top 5 customers based on total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9: Unique customers per category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q10: Order count by shift (Morning, Afternoon, Evening)
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- End of Project

