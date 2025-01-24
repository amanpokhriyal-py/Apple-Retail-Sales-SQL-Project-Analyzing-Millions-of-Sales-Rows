# Apple-Retail-Sales-SQL-Project-Analyzing-Millions-of-Sales-Rows
![5_New_Apple_Store_on_the_Singapore_-Waterfront](https://github.com/user-attachments/assets/f8953655-ba07-45c4-8b3a-92c0247cde7a)


## Overview

This project involves analyzing millions of rows of sales data for Apple retail stores to derive actionable insights, optimize queries, and improve data performance using SQL. The dataset is designed to simulate a realistic sales environment, encompassing stores, products, categories, sales, and warranty claims.

## The project includes:
1. Data schema design and table creation.
2. Exploratory Data Analysis (EDA).
3. Query optimizations using indexing to enhance performance.
4. Solving key business problems through SQL queries.

## Key Features 
* Database Schema: A well-structured relational database comprising five tables: stores, products, categories, sales, and warranty.
* Performance Optimization: Created indexes on frequently queried columns, improving query execution time significantly for large datasets.
* Business Problem Analysis: Tackles real-world business scenarios like sales trends, warranty claims analysis, and product performance.
* Advanced Querying: Includes window functions, subqueries, Common Table Expressions (CTEs), and aggregate functions.

## Database Schema

![erd](https://github.com/user-attachments/assets/f37eaa63-e720-49ff-a321-384829ba4b56)


The project uses five main tables:

1. **stores**: Contains information about Apple retail stores.
   - `store_id`: Unique identifier for each store.
   - `store_name`: Name of the store.
   - `city`: City where the store is located.
   - `country`: Country of the store.

2. **category**: Holds product category information.
   - `category_id`: Unique identifier for each product category.
   - `category_name`: Name of the category.

3. **products**: Details about Apple products.
   - `product_id`: Unique identifier for each product.
   - `product_name`: Name of the product.
   - `category_id`: References the category table.
   - `launch_date`: Date when the product was launched.
   - `price`: Price of the product.

4. **sales**: Stores sales transactions.
   - `sale_id`: Unique identifier for each sale.
   - `sale_date`: Date of the sale.
   - `store_id`: References the store table.
   - `product_id`: References the product table.
   - `quantity`: Number of units sold.

5. **warranty**: Contains information about warranty claims.
   - `claim_id`: Unique identifier for each warranty claim.
   - `claim_date`: Date the claim was made.
   - `sale_id`: References the sales table.
   - `repair_status`: Status of the warranty claim (e.g., Paid Repaired, Warranty Void).

## Performance Optimization
To handle millions of rows and ensure high performance, indexes were created on the following columns:

1. `sales(product_id)`: Improved query execution time for product-based sales analysis.
2. `sales(store_id)`: Enhanced performance when filtering sales by store.
3. `sales(sale_date)`: Accelerated date-based queries for identifying trends and seasonal patterns.
4. `sales(quantity)`: Boosted queries requiring analysis of sales volume thresholds.


## Business Problems Solved
Here are some of the key questions and insights derived:

1. Find the number of stores in each country.
2. Calculate the total number of units sold by each store.
3. Identify how many sales occurred in December 2023.
4. Determine how many stores have never had a warranty claim filed.
5. Calculate the percentage of warranty claims marked as "Warranty Void".
6. Identify which store had the highest total units sold in the last year.
7. Count the number of unique products sold in the last year.
8. Find the average price of products in each category.
9. How many warranty claims were filed in 2020?
10. For each store, identify the best-selling day based on highest quantity sold.
11. Identify the least selling product in each country for each year based on total units sold.
12. Calculate how many warranty claims were filed within 180 days of a product sale.
13. Determine how many warranty claims were filed for products launched in the last two years.
14. List the months in the last three years where sales exceeded 5,000 units in the USA.
15. Identify the product category with the most warranty claims filed in the last two years.
16. Determine the percentage chance of receiving warranty claims after each purchase for each country.
17. Analyze the year-by-year growth ratio for each store.
18. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.

## Conclusion
This project highlights my ability to handle complex SQL queries and provides solutions to real-world business problems in the context of a Sales analysis of a store like Apple store. The approach taken here demonstrates a structured problem-solving methodology, data manipulation skills, and the ability to derive actionable insights from data.

