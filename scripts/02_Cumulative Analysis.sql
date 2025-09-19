-- Cumulative analysis
-- Calculate the total sales per month and the running total of sales over time by each year
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