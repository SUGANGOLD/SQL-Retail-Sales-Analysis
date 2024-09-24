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
	quantiy INT,    
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- Data Cleaning
SELECT * 
	FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration

-- 1. How many sales we have?
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- 2. How many uniuque customers we have?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- 2. How many uniuque category we have?
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing'
-- and the quantity sold is more then 10 in the month of Nov 2022

SELECT *
FROM retail_sales 
WHERE 
	category = 'Clothing'
	AND
	date_format(sale_date, '%Y-%m') = '2022-11'
	AND
	quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total sales) for each category.

SELECT 
	category,
	SUM(total_sale) AS net_sales,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased iteam from the 'Beauty' Category

SELECT
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales 
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total sales is greater then 1000.

SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6  Write a SQL query to find the total number of transactions (transactions_id) made by 
-- each gender in each category.

SELECT 
	category,
	gender,
	COUNT(transactions_id) AS total_tranactions
FROM retail_sales
GROUP BY 
	category, gender
ORDER BY 1;

-- Q.7  Write a SQL query to calculate the average sales for each month. find out best selling month in each year.

WITH ranked_sales AS (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_sales
    FROM retail_sales
    GROUP BY year, month
)
SELECT *
FROM ranked_sales
WHERE rank_sales = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Moring <= 12, Afternoon Between 12&17, Evening > 17)

WITH hourly_sale AS
(
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


