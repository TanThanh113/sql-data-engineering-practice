-- Problem: Median Search Frequency (Google SQL Interview Question)

-- Description:
-- Google's search team wants to find the median number of searches a person made last year.
-- However, the data is given in a frequency table (searches and num_users).
-- Write a query to report the median of searches made by a user. Round the median to one decimal point.

WITH sort_data as(
  SELECT 
    searches,
    num_users,
    SUM(num_users) OVER(ORDER BY searches) as accum_sum,
    SUM(num_users) OVER() AS total
  FROM search_frequency
)
SELECT 
  ROUND(AVG(searches),1) AS median
FROM sort_data
WHERE total/2.0 BETWEEN (accum_sum - num_users) AND accum_sum

-- EXPLANATION: How the "Math Magic" Works

-- 1. CTE 'sort_data': We calculate a running total ('accum_sum'). 
--    If row 1 has 2 users, its accum_sum is 2 (users #1, #2). 
--    If row 2 has 2 users, its accum_sum is 4 (users #3, #4).
--    The expression (accum_sum - num_users) conceptually represents the "starting user ID" for that bucket.
--
-- 2. The Condition "total / 2.0": This finds the exact middle point. We use 2.0 (float) to handle decimal midpoints.
-- 
-- 3. The BETWEEN Magic (Inclusive bounds):
--    - ODD TOTAL (e.g., 5 users): Midpoint is 2.5. Only ONE row will have a range [start, end] that encompasses 2.5. AVG() simply returns that row's searches.
--    - EVEN TOTAL (e.g., 4 users): Midpoint is 2.0. 
--      Row 1 covers users [0 to 2]. 
--      Row 2 covers users [2 to 4]. 
--      Because BETWEEN is inclusive, the value 2.0 matches BOTH Row 1 and Row 2! 
--      The main query then automatically takes the AVG(searches) of these two rows, perfectly satisfying the mathematical definition of an even-set median.
