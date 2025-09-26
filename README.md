# SQL-Sales-Data-Analytics

A comprehensive collection of SQL scripts for data exploration, analytics, and reporting. This repository demonstrates how to query and analyze sales data in a relational database using best practices in SQL.


The queries in this project showcase practical applications such as:

  - Exploring database schema and metadata

  - Generating key business metrics (sales, revenue, customer counts)

  - Analyzing time-based trends and seasonality

  - Building cumulative and running totals

  - Customer/product segmentation and performance analysis

  - Preparing data for reporting and dashboards
    

This repository is designed as a portfolio project to demonstrate SQL proficiency, problem-solving ability, and a clear workflow for real-world analytics.

## Repository Structure

```
SQL-Sales-Data-Analytics/
├── datasets/            
├── scripts/             # Scripts for exploring schema, tables, and columns
├── LICENSE
└── README.md            
```

## Example Analyses

- Monthly Sales Performance → Track revenue growth trends by month.

- Cumulative Sales → Running total of sales by year.

- Customer Segmentation → Identify top customers by revenue contribution.

- Product Performance → Rank products by sales volume and revenue.

*Product Segment Analysis*
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
<img width="198" height="110" alt="image" src="https://github.com/user-attachments/assets/7d40b23d-e00c-4e6d-94bf-133c3eb23ead" />


## Skills Demonstrated

- SQL fundamentals: SELECT, JOIN, GROUP BY, HAVING

- Advanced SQL: CTEs, Window Functions, Subqueries

- Performance considerations: indexing, filtering, grouping

- Translating business questions into analytical queries

## License

MIT License (free to use with attribution).
