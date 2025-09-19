-- Analyze performance over time
-- Find the total sales, total customers, and quantity by months of each year
SELECT
	DATETRUNC(MONTH, order_date) as order_date,
	SUM(sales_amount) as total_sales,
	COUNT(distinct customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date);