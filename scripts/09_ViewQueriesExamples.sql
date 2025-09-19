USE DataWarehouseAnalytics;
GO

SELECT 
	age_group,
	COUNT(customer_number) AS total_customers,
	SUM(total_sales) AS total_sales
FROM gold.report_customers
GROUP BY age_group