-- Performance Analysis
/* Analyze the yearly performance of products by comparing each product's sales to both its 
average sales performance and the previous year's sales */

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
	-- YOY analysis --
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