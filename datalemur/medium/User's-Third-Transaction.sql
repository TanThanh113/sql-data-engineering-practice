-- Problem: User's Third Transaction

-- Description:
-- Find the 3rd transaction for every user. Output the user_id, spend, and 
--  transaction_date.

WiTH Rank_user AS (
  SELECT 
    user_id,
    spend, 
    transaction_date,
    ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rnk
    FROM transactions
)
SELECT 
    user_id,
    spend, 
    transaction_date
FROM Rank_user
WHERE rnk = 3;

/*
-- Explanation:
-- 1. Use a CTE (Rank_user) with the ROW_NUMBER() window function to assign a 
      sequential rank to each user's transactions.

-- 2. PARTITION BY user_id ensures that the ranking mechanism restarts from 1 
      for every unique user.

-- 3. ORDER BY transaction_date ASC guarantees the chronological order of transactions.

-- 4. In the main query, filter strictly for rnk = 3 to isolate exactly the third 
      transaction made by each user.
*/
