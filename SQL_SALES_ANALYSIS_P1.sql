DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time	TIME,
		customer_id	INT,
		gender VARCHAR (20),
		age	INT,
		category VARCHAR (15),	
		quantiy	INT,
		price_per_unit	FLOAT,
		cogs FLOAT,
		total_sale FLOAT

);

-- Data Collection -- 

SELECT * FROM retail_sales;

SELECT * FROM retail_sales
LIMIT 10

SELECT COUNT (*) FROM retail_sales

-- DATA CEANING -- 

-- First method to check Null Values
SELECT COUNT (*) FROM retail_sales
WHERE transactions_id IS NULL

SELECT COUNT (*) FROM retail_sales
WHERE sale_time IS NULL


-- Second Method to see in a Single string.


SELECT * FROM retail_sales WHERE 
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


DELETE FROM retail_sales WHERE 
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

-- DATA EXPLORATION --

-- How many total Records we have 
SELECT COUNT (*) as total_records FROM retail_sales

-- How many Unique Customers we have 
SELECT COUNT (DISTINCT customer_id) as Unique_Customers FROM retail_sales

-- How many Unique Categories  we have 
SELECT DISTINCT category as Unique_categories FROM retail_sales


-- Data Analysis & Business Problems --

-- 	Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
-- 	Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
-- 	Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
--	Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
--	Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
--	Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--	Q.7 Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.
--	Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
--	Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
--	Q.10 Write a SQL query to create each shift and number of orders (Example: Morning ≤ 12, Afternoon 12–17, Evening > 17).




-- 	Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.-- 	Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';


-- 	Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.

-- sum of quantity where category is clothing

SELECT category, SUM(quantiy) FROM retail_sales
	WHERE category = 'Clothing'
	GROUP BY 1

-- Data where category is clothing in November 2022

SELECT * FROM retail_sales
	WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	GROUP BY 1

-- Share all rows where category is clothing, quantity is more than 4 in november 2022.

SELECT * FROM retail_sales
	WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND 
	quantiy >= 4

-- 2nd Method

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND sale_date >= DATE '2022-11-01'
  AND sale_date <  DATE '2022-12-01'
  AND quantiy >= 4;


-- 	Q.3 Write a SQL query to calculate the total sales (total_sale) for each category along with the quantity


SELECT category,SUM(quantiy), SUM(total_sale), COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

--	Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


--	Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.


SELECT * FROM retail_sales;
WHERE total_sale >= 1000;


--	Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.


SELECT 
	category, gender, 
		COUNT (*) AS total_trans 
		FROM retail_sales 
		GROUP BY category, gender
		ORDER BY 1

--	Q.7 Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.


SELECT year,
		month, 
		avg_sale
FROM
(
SELECT 
	EXTRACT (YEAR FROM sale_date) as year,
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK () OVER (PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 3 DESC
) as t1

WHERE RANK = 1


--	Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id,
	SUM(total_sale) as total_sales 
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


--	Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category


--	Q.10 Write a SQL query to create each shift and number of orders (Example: Morning ≤ 12, Afternoon 12–17, Evening > 17).
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT (HOUR FROM sale_time)< 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END as shift
	FROM retail_sales
)

SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

-- SELECT EXTRACT (HOUR FROM CURRENT_TIME) -- (Extract right now time)

-- Project END --
