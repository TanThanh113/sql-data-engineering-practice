-- Problem: Pharmacy Analytics (Part 2)

-- Description:
-- Identify the manufacturers associated with the drugs that resulted in losses.
-- Calculate the total number of loss-making drugs and the total absolute loss 
--  for each manufacturer.

SELECT 
  manufacturer, 
  COUNT(drug) AS drug_count,
  SUM(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC;

/*
-- Explanation:
-- 1. Use the WHERE clause (total_sales < cogs) to filter only the drugs that resulted 
      in a financial loss.
      
-- 2. GROUP BY manufacturer to aggregate the data for each specific manufacturer.

-- 3. COUNT(drug) calculates the total number of loss-making drugs per manufacturer.

-- 4. SUM(cogs - total_sales) calculates the absolute total loss amount.

-- 5. ORDER BY total_loss DESC sorts the final output to display the manufacturers with 
      the highest financial losses at the top.
*/
