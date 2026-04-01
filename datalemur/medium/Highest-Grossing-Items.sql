-- Problem: Highest-Grossing Items

-- Description:
-- Identify the top 2 highest-grossing products within each category in the year 2022.
-- Output the category, product, and total spend.

WITH Rank_product AS (
  SELECT
    category,
    product,
    SUM(spend) AS total_spend,
    RANK() OVER(
      PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS rnk
  FROM product_spend
  WHERE transaction_date >= '2022-01-01' 
    AND transaction_date < '2023-01-01'
  GROUP BY category, product
)
SELECT
  category,
  product,
  total_spend
FROM Rank_product
WHERE rnk <= 2

/*-- Explanation:
-- 1. Filter the dataset strictly for the year 2022 using the WHERE clause. 
      Using < '2023-01-01' ensures all timestamps on December 31st are safely included without performance loss.

-- 2. GROUP BY category and product to calculate the total_spend (SUM) for each 
      unique item.

-- 3. Use the RANK() window function to assign a sequential rank to products. 
      PARTITION BY category ensures the ranking restarts for each category, and ORDER 
      BY SUM(spend) DESC ranks them from highest to lowest revenue.

-- 4. Store this aggregated and ranked dataset in a CTE named Rank_product.

-- 5. In the main query, filter the results using WHERE rnk <= 2 to isolate only 
      the top 2 highest-grossing products per category.*/
