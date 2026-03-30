-- Problem: Average Review Ratings

-- Description:
-- Calculate the average star rating for each product, grouped by month.
-- The output is rounded to two decimal places and sorted chronologically by 
--  month, then by product ID.

SELECT 
  EXTRACT (MONTH FROM submit_date) AS mth,
  product_id AS product,
  ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY mth, product_id
ORDER BY mth, product_id;

/*
-- Explanation:
-- 1. Use EXTRACT(MONTH FROM submit_date) to isolate the month from the timestamp.

-- 2. Use AVG(stars) to calculate the mean rating, and ROUND(..., 2) to format 
      it to two decimal places.
      
-- 3. GROUP BY the extracted month and product_id to aggregate the data into 
      specific product-month buckets.
      
-- 4. ORDER BY mth, product to sort the final output chronologically, and 
      sequentially by product ID for any given month.
*/
