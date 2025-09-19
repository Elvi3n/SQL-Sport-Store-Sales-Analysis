-- Part-to-whole Analysis
-- Which categories contributed the most to overall sales
-- Insight might be to focus on expending other categories to avoid being reliant on one category
WITH category_sales AS
(
	SELECT 
		category,
		sum(sales_amount) as total_sales
	FROM gold.fact_sales as s
	LEFT JOIN gold.dim_products as p
		ON p.product_key = s.product_key
	group by category
)
SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER() as overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT)/SUM(total_sales) OVER())*100, 2), '%') as perc_of_total
FROM category_sales
ORDER BY total_sales DESC;