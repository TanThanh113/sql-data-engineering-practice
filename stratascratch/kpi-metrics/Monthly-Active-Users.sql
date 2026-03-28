-- Problem: Monthly Active Users

-- Description:
-- Count number of unique active users per account in January 2021

SELECT 
    account_id,
    COUNT(DISTINCT user_id) AS count_user
FROM sf_events
WHERE record_date BETWEEN '2021-01-01' AND '2021-01-31'
GROUP BY account_id;

-- Explanation:
-- 1. WHERE clause to filter the data only for January 2021
-- 2. GROUP BY account_id to aggregate data per account
-- 3. COUNT DISTINCT user_id to get unique users
