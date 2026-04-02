-- Problem: Y-on-Y Growth Rate

-- Description:
-- Calculate the year-over-year growth rate for the total spend of each product.
-- Output the year, product_id, current year's spend, previous year's spend, and 
--  the YoY growth rate.

WITH Rank_product AS(
  SELECT 
    EXTRACT(YEAR FROM transaction_date) AS year,
    product_id,
    SUM(spend) AS curr_year_spend,
    LAG(SUM(spend)) OVER(
      PARTITION BY product_id 
      ORDER BY EXTRACT(YEAR FROM transaction_date)) 
      AS prev_year_spend
  FROM user_transactions
  GROUP BY 
    EXTRACT(YEAR FROM transaction_date),
    product_id
)
SELECT 
  year,
  product_id,
  curr_year_spend,
  prev_year_spend,
  ROUND((100.0 *
    (curr_year_spend - prev_year_spend) / prev_year_spend),2) 
    AS yoy_rate
FROM Rank_product;

/*
-- Explanation:
-- 1. Use a CTE (Rank_product) to aggregate the raw transactions. GROUP BY year 
      and product_id to get the total SUM(spend) for each product annually (curr_year_spend).

-- 2. Within the same CTE, utilize the LAG() window function. PARTITION BY product_id 
      isolates the data per product, and ORDER BY year ASC ensures we look back exactly one row to fetch the 'prev_year_spend'.

-- 3. In the main query, calculate the Year-over-Year growth formula: 
      (Current - Previous) / Previous.

-- 4. Multiply by 100.0 to safely cast the integers to float, avoiding integer 
      division errors. Finally, ROUND() the percentage to 2 decimal places.

-- 5. ORDER BY product_id and year to present a clean, tracking-friendly report.
*/
