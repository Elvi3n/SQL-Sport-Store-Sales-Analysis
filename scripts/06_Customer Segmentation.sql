/*
Group customers into segments based on their spending behavior
	- VIP - at leaset 12 months of history and spending more then 5000
	- Regular - at least 12 months of history but spending 5000 or less
	- New - lifespan less then 12 months
Find the total number of customers by groups
*/

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