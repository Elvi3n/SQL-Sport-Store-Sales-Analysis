# Query Results

**01 Performance Over Time**

Find the total sales, total customers, and quantity by months of each year

```
SELECT
	DATETRUNC(MONTH, order_date) as order_date,
	SUM(sales_amount) as total_sales,
	COUNT(distinct customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date);	
```

<img width="337" height="382" alt="image" src="https://github.com/user-attachments/assets/b23c5ba4-271a-49ee-84f8-8fdebc392d02" />



**02 Cumulative Analysis**

Calculate the total sales per month and the running total of sales over time by each year

```
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (
		PARTITION BY DATEPART(YEAR, order_date)
		ORDER BY order_date
	) as running_total_sales,
	AVG(avg_price) OVER (
		PARTITION BY DATEPART(YEAR, order_date)
		ORDER BY order_date
	) AS moving_avg_price
FROM
(
SELECT 
	DATETRUNC(MONTH, order_date) AS Order_date,
	SUM(sales_amount) AS Total_Sales,
	AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
) t;
```

<img width="383" height="307" alt="image" src="https://github.com/user-attachments/assets/ee5cd451-77a1-4d97-9ba2-83a49e262ff3" />



**03 Performance Analysis**

Analyze the yearly performance of products by comparing each product's sales to both its average sales performance and the previous year's sales

```
WITH yearly_product_sales as
(
	SELECT 
		YEAR(order_date) AS order_year,
		product_name,
		SUM(sales_amount) AS current_sales
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p
		ON p.product_key = s.product_key
	WHERE order_date IS NOT NULL
	GROUP BY 
		YEAR(order_date),
		product_name
)
SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) as avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) as avg_diff,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END AS avg_change,
	-- YoY analysis --
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) as PY_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS PY_diff,
	CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END AS PY_change
FROM yearly_product_sales
ORDER BY 
	product_name,
	order_year;
```

<img width="680" height="305" alt="image" src="https://github.com/user-attachments/assets/54ce9e75-2a9a-4509-9169-be79c0998e42" />



**04 Part-to-Whole Analysis**

Which categories contributed the most to overall sales

```
WITH subcategory_sales AS
(
	SELECT 
		subcategory,
		sum(sales_amount) as total_sales
	FROM gold.fact_sales as s
	LEFT JOIN gold.dim_products as p
		ON p.product_key = s.product_key
	group by subcategory
)
SELECT 
	subcategory,
	total_sales,
	SUM(total_sales) OVER() as overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT)/SUM(total_sales) OVER())*100, 2), '%') as perc_of_total
FROM subcategory_sales
ORDER BY total_sales DESC;
```

<img width="360" height="344" alt="image" src="https://github.com/user-attachments/assets/1eeac04a-91c4-41c0-afc5-dceec8bf4b43" />



**05 Data Segmentation**

Segment products into cost ranges and count how many products fall into each segment

```
WITH product_segments AS 
(
	SELECT 
		product_key,
		product_name,
		cost,
		CASE 
			WHEN cost < 100
				THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 
				THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000
				THEN '500-1000'
			ELSE 'Above 1000'
		END as cost_range
	FROM gold.dim_products
) 
SELECT 
	cost_range,
	count(product_key) as product_count
FROM product_segments
GROUP BY cost_range
ORDER BY product_count DESC;
```

<img width="193" height="99" alt="image" src="https://github.com/user-attachments/assets/0cdd5a48-4137-41d8-8701-da59428c3686" />

**06 Customer Segmentation**

Group customers into segments based on their spending behavior

- VIP - at leaset 12 months of history and spending more then 5000
- Regular - at least 12 months of history but spending 5000 or less
- New - lifespan less then 12 months
	
Find the total number of customers by groups

```
WITH customer_spending AS 
(
	SELECT 
		c.customer_key,
		SUM(s.sales_amount) AS total_sales,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_customers AS c
		ON c.customer_key = s.customer_key
	GROUP BY c.customer_key
)
SELECT
customer_segment,
COUNT(customer_key) AS total_customers
	FROM (
	SELECT 
		customer_key,
		total_sales,
		lifespan,
		CASE WHEN lifespan >= 12 AND total_sales > 5000
			THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000
			THEN 'Regular'
		ELSE 'New'
		END AS customer_segment
FROM customer_spending) AS t
GROUP BY customer_segment
ORDER BY total_customers DESC;
```

<img width="231" height="79" alt="image" src="https://github.com/user-attachments/assets/02f93e7a-1293-406a-89d1-dc8d4a2baea8" />
