# SQL-Sales-Data-Analytics

## Project Goal

Investigate the sales performance of a Sport store by generating key business metrics of sales items in order to surface recommendations on selling strategies. Some examples included 

  - Time-based trends and seasonality

  - Building cumulative and running totals

  - Customer/product segmentation and performance analysis

  - Preparing data for reporting and dashboards
    

## Database Structure

The dataset consisted of three tables, including information of products, sales, and customers.

<img width="1123" height="433" alt="image" src="https://github.com/user-attachments/assets/330b60e7-366f-4445-a86b-3da844a4439d" />

## Repository Structure

```
SQL-Sales-Data-Analytics/
├── datasets/            
├── scripts/             # Scripts for exploring schema, tables, and columns
├── results/
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


## Insights Summary

- **Product Diversification** - The business shows heavy reliance on bike-related items, which presents both strengths and risks. If the biking market slows down or becomes saturated, revenue growth will be directly impacted

	- **Recommendation:** The business should consider exploring complementary categories that already align with existing customer interests, such as clothings and accessories. This approach will reduce reliance on one category while building resilience and long-term growth potential.
  
- **New Customers Dominated** - Over 60% of customers spent less than $5,000 and have been with the business for less than 12 months. While it shows success in attracting new customers, it also highlights a lack of long term retention and customer lifetime value. Causing the risks a revolving door effect, where customer purchase once and fail to retrun.

	- **Recommendation:** Introduce loyalty programs to incentivize repeat purchases or implement personalized marketing campaigns that target customers based on purchase history.

## License

MIT License (free to use with attribution).
