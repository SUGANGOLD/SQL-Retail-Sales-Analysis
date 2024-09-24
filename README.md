
# SQL Retail Sales Analysis

## Project Overview

This project involves analyzing retail sales data using SQL. The database contains transactional data that includes customer demographics, product categories, sales amounts, and other related attributes. The project consists of data cleaning, exploration, and analysis of key business metrics to derive actionable insights.

## Prerequisites

- SQL Database (e.g., MySQL, PostgreSQL)
- SQL Client or IDE (e.g., MySQL Workbench, pgAdmin, DBeaver)

## Steps

### 1. Database and Table Setup

Create the `Retail_Sales_Analysis` database and the `retail_sales` table:

```sql
CREATE DATABASE Retail_Sales_Analysis;

USE Retail_Sales_Analysis;

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
```

### 2. Data Cleaning

Check for and remove any rows where critical fields have NULL values:

```sql
-- Select rows with NULL values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Delete rows with NULL values
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;
```

### 3. Data Exploration

Perform basic data exploration to understand the dataset:

- **Total Sales Count**:
  
    ```sql
    SELECT COUNT(*) AS total_sales FROM retail_sales;
    ```

- **Unique Customers**:
  
    ```sql
    SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
    ```

- **Unique Categories**:
  
    ```sql
    SELECT DISTINCT category FROM retail_sales;
    ```

### 4. Business Questions and Analysis

Here are some key business questions answered using SQL queries:

- **Q1: Retrieve all sales on '2022-11-05'**:
  
    ```sql
    SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
    ```

- **Q2: Retrieve transactions for 'Clothing' where quantity sold is more than 10 in November 2022**:
  
    ```sql
    SELECT * FROM retail_sales
    WHERE category = 'Clothing'
        AND date_format(sale_date, '%Y-%m') = '2022-11'
        AND quantity > 10;
    ```

- **Q3: Calculate total sales for each category**:
  
    ```sql
    SELECT category, SUM(total_sale) AS net_sales, COUNT(*) AS total_orders
    FROM retail_sales
    GROUP BY category;
    ```

- **Q4: Find the average age of customers who purchased from the 'Beauty' category**:
  
    ```sql
    SELECT ROUND(AVG(age), 2) AS avg_age
    FROM retail_sales
    WHERE category = 'Beauty';
    ```

- **Q5: Retrieve transactions where total sales exceed 1000**:
  
    ```sql
    SELECT * FROM retail_sales WHERE total_sale > 1000;
    ```

- **Q6: Total number of transactions made by each gender in each category**:
  
    ```sql
    SELECT category, gender, COUNT(transactions_id) AS total_transactions
    FROM retail_sales
    GROUP BY category, gender;
    ```

- **Q7: Find the best-selling month of each year**:
  
    ```sql
    WITH ranked_sales AS (
        SELECT YEAR(sale_date) AS year, MONTH(sale_date) AS month,
               AVG(total_sale) AS avg_sale,
               RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_sales
        FROM retail_sales
        GROUP BY year, month
    )
    SELECT * FROM ranked_sales WHERE rank_sales = 1;
    ```

- **Q8: Top 5 customers by total sales**:
  
    ```sql
    SELECT customer_id, SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY customer_id
    ORDER BY total_sales DESC
    LIMIT 5;
    ```

- **Q9: Number of unique customers for each category**:
  
    ```sql
    SELECT category, COUNT(DISTINCT customer_id) AS cnt_unique_cs
    FROM retail_sales
    GROUP BY category;
    ```

- **Q10: Count of orders per shift (Morning, Afternoon, Evening)**:
  
    ```sql
    WITH hourly_sale AS (
        SELECT *,
            CASE
                WHEN HOUR(sale_time) < 12 THEN 'Morning'
                WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
                ELSE 'Evening'
            END AS shift
        FROM retail_sales
    )
    SELECT shift, COUNT(*) AS total_orders
    FROM hourly_sale
    GROUP BY shift;
    ```

### Conclusion

This project demonstrates how to clean, explore, and analyze retail sales data using SQL. The queries focus on answering key business questions, such as identifying high-value customers, understanding category performance, and analyzing sales trends over time.
