-- Problem: Card Launch Success

-- Description:
-- Find the launch month (the very first month) for each credit card and its 
--  corresponding issued amount.
-- Sort the final result by the issued amount in descending order.

WITH Rank_month AS (
  SELECT
    card_name,
    issued_amount,
    RANK() OVER(
    PARTITION BY card_name 
    ORDER BY issue_year, issue_month) AS rnk
    FROM monthly_cards_issued
)
SELECT 
  card_name,
  issued_amount
FROM Rank_month
WHERE rnk =  1
ORDER BY issued_amount DESC;

/*
-- Explanation:
-- 1. Use a CTE (Rank_month) to assign a chronological rank to each card's 
      issuance months.

-- 2. RANK() OVER(...) partitions the dataset by card_name and sorts it by 
      issue_year and issue_month. The earliest month receives rank 1.

-- 3. In the main query, filter strictly for rnk = 1 to isolate the exact launch 
      month (the first month) for each card.

-- 4. Finally, ORDER BY issued_amount DESC to rank the cards based on their launch 
      month performance, from highest to lowest.
*/
