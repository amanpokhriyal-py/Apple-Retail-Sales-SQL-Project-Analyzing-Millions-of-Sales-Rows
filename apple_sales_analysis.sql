-- Apple Sales Project - 1M rows sales datasets



-- Improving Query Performance

-- et - 64.ms
-- pt - 0.15ms
-- et after index 5-10 ms

EXPLAIN ANALYZE
SELECT * FROM sales
WHERE product_id ='P-44';

CREATE INDEX sales_product_id ON sales(product_id);


-- et - 58.ms
-- pt - 0.069ms
-- et after index 2 ms

EXPLAIN ANALYZE
SELECT * FROM sales
WHERE store_id ='ST-31'

CREATE INDEX sales_store_id ON sales(store_id);
CREATE INDEX sales_sale_date ON sales(sale_date);



-- Business Problems

-- Q1. Find the number of stores in each country.

select * from stores;

SELECT 
	Country,
	COUNT(store_id) AS total_stores
FROM stores
GROUP BY Country
ORDER BY 2 desc ;


-- Q2. Calculate the total number of units sold by each store.


SELECT * FROM sales;

SELECT store_id,
	   SUM(quantity) AS total_quantity_sold
FROM sales
GROUP BY store_id
ORDER BY 2 desc;


-- Q3. Identify how many sales occurred in December 2023.


SELECT 
	COUNT(sale_id) as total_sale 
FROM sales
WHERE TO_CHAR(sale_date, 'MM-YYYY') = '12-2023'  


-- Q4. Determine how many stores have never had a warranty claim filed.

SELECT COUNT(*) FROM stores
WHERE store_id NOT IN (
						SELECT 
							DISTINCT store_id
						FROM sales as s
						RIGHT JOIN warranty as w
						ON s.sale_id = w.sale_id
						);


-- Q5. Calculate the percentage of warranty claims marked as "Warranty Void".


SELECT * FROM warranty;

SELECT 
	ROUND
		(COUNT(claim_id)/
						(SELECT COUNT(*) FROM warranty)::numeric 
		* 100, 
	2)as warranty_void_percentage
FROM warranty
WHERE repair_status = 'Warranty Void';


-- Q6. Identify which store had the highest total units sold in the last year.

SELECT 
	s.store_id,
	st.store_name,
	SUM(s.quantity)
FROM sales as s
JOIN stores as st
ON s.store_id = st.store_id
WHERE sale_date >= (CURRENT_DATE - INTERVAL '1 year')
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1
	   

-- Q7. Count the number of unique products sold in the last year.

SELECT 
	COUNT(DISTINCT product_id)
FROM sales
WHERE sale_date >= (CURRENT_DATE - INTERVAL '1 year')


-- Q8. Find the average price of products in each category.

SELECT c.category_name,AVG(p.price) AS Average_Price
FROM products p
JOIN category c
ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY 2 DESC;

SELECT * FROM products


-- Q9. How many warranty claims were filed in 2020?


SELECT 
		count(*) 
FROM warranty
WHERE EXTRACT(YEAR FROM claim_date) = 2020 ;


-- Q10. For each store, identify the best-selling day based on highest quantity sold.

SELECT  * 
FROM
(
	SELECT 
		store_id,
		TO_CHAR(sale_date, 'Day') as day_name,
		SUM(quantity) as total_unit_sold,
		RANK() OVER(PARTITION BY store_id ORDER BY SUM(quantity) DESC) as rank
	FROM sales
	GROUP BY 1, 2
) as t1
WHERE rank = 1


-- Q11. Identify the least selling product in each country for each year based on total units sold.



WITH product_rank
AS
(
SELECT 
	st.country,
	p.product_name,
	SUM(s.quantity) as total_qty_sold,
	RANK() OVER(PARTITION BY st.country ORDER BY SUM(s.quantity)) as rank
FROM sales as s
JOIN 
stores as st
ON s.store_id = st.store_id
JOIN
products as p
ON s.product_id = p.product_id
GROUP BY 1, 2
)
SELECT 
* 
FROM product_rank
WHERE rank = 1


-- Q12. Calculate how many warranty claims were filed within 180 days of a product sale.


SELECT 
	COUNT(*)
FROM warranty as w
LEFT JOIN 
sales as s
ON s.sale_id = w.sale_id
WHERE 
	w.claim_date - sale_date <= 180


-- Q13. Determine how many warranty claims were filed for products launched in the last two years.

SELECT 
    p.product_name,
    COUNT(w.claim_id) AS total_claims
FROM warranty AS w
RIGHT JOIN sales AS s
    ON w.sale_id = s.sale_id
JOIN products AS p
    ON p.product_id = s.product_id
WHERE p.launch_date >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY p.product_name
HAVING COUNT(w.claim_id) > 0;

-- Q14. List the months in the last three years where sales exceeded 5,000 units in the USA.

SELECT 
	TO_CHAR(sale_date, 'MM-YYYY') as month,
	SUM(s.quantity) as total_unit_sold
FROM sales as s
JOIN 
stores as st
ON s.store_id = st.store_id
WHERE 
	st.country = 'USA'
	AND
	s.sale_date >= CURRENT_DATE - INTERVAL '3 year'
GROUP BY 1
HAVING SUM(s.quantity) > 5000



-- Q15. Identify the product category with the most warranty claims filed in the last two years.


SELECT 
	c.category_name,
	COUNT(w.claim_id) as total_claims
FROM warranty as w
LEFT JOIN
sales as s
ON w.sale_id = s.sale_id
JOIN products as p
ON p.product_id = s.product_id
JOIN 
category as c
ON c.category_id = p.category_id
WHERE 
	w.claim_date >= CURRENT_DATE - INTERVAL '2 year'
GROUP BY 1


-- Q16. Determine the percentage chance of receiving warranty claims after each purchase for each country.

SELECT 
	country,
	total_unit_sold,
	total_claim,
	COALESCE(total_claim::numeric/total_unit_sold::numeric * 100, 0)
	as risk
FROM
(SELECT 
	st.country,
	SUM(s.quantity) as total_unit_sold,
	COUNT(w.claim_id) as total_claim
FROM sales as s
JOIN stores as st
ON s.store_id = st.store_id
LEFT JOIN 
warranty as w
ON w.sale_id = s.sale_id
GROUP BY 1) t1
ORDER BY 4 DESC



-- Q17. Analyze the year-by-year growth ratio for each store.

WITH yearly_sales
AS
(
	SELECT 
		s.store_id,
		st.store_name,
		EXTRACT(YEAR FROM sale_date) as year,
		SUM(s.quantity * p.price) as total_sale
	FROM sales as s
	JOIN
	products as p
	ON s.product_id = p.product_id
	JOIN stores as st
	ON st.store_id = s.store_id
	GROUP BY 1, 2, 3
	ORDER BY 2, 3 
),
growth_ratio
AS
(
SELECT 
	store_name,
	year,
	LAG(total_sale, 1) OVER(PARTITION BY store_name ORDER BY year) as last_year_sale,
	total_sale as current_year_sale
FROM yearly_sales
)

SELECT 
	store_name,
	year,
	last_year_sale,
	current_year_sale,
	ROUND(
			(current_year_sale - last_year_sale)::numeric/
							last_year_sale::numeric * 100
	,3) as growth_ratio
FROM growth_ratio
WHERE 
	last_year_sale IS NOT NULL
	AND 
	YEAR <> EXTRACT(YEAR FROM CURRENT_DATE)



-- Q18. Calculate the correlation between 
-- product price and warranty claims for products sold in the last five years, segmented by price range.

SELECT 
	
	CASE
		WHEN p.price < 500 THEN 'Less Expenses Product'
		WHEN p.price BETWEEN 500 AND 1000 THEN 'Mid Range Product'
		ELSE 'Expensive Product'
	END as price_segment,
	COUNT(w.claim_id) as total_Claim
FROM warranty as w
LEFT JOIN
sales as s
ON w.sale_id = s.sale_id
JOIN 
products as p
ON p.product_id = s.product_id
WHERE claim_date >= CURRENT_DATE - INTERVAL '5 year'
GROUP BY 1
