-- Problem: Active User Retention
-- Description:
-- Calculate the number of monthly active users (MAUs) for July 2022.
-- An active user is defined as a user who has performed an action in both the current month (July) and the previous month (June).

-- ==========================================
-- SOLUTION 1: (GROUP BY & HAVING)
-- ==========================================

WITH filter_month AS (
  SELECT 
    user_id
  FROM user_actions
  WHERE event_date >= '2022-06-01' 
    AND event_date < '2022-08-01'
  GROUP BY 
    user_id
  HAVING COUNT(DISTINCT EXTRACT(MONTH FROM event_date)) = 2
)

SELECT 
  7 AS month,
  COUNT(user_id) AS monthly_active_users
FROM filter_month;

-- Explanation for Solution 1:
-- 1. Isolate the dataset to only include events from June and July using the WHERE clause.
-- 2. GROUP BY user_id to evaluate each user's activity log independently.
-- 3. The HAVING clause acts as a strict filter: it counts the distinct months of activity for each user. Only users who were active in exactly 2 distinct months 
--    (which can only be June and July based on our WHERE clause) will survive this filter.
-- 4. Finally, count the remaining users and hardcode '7' as the month for the output.

-- ==========================================
-- SOLUTION 2: (LAG Window Function)
-- ==========================================

WITH classify AS (
  SELECT
    user_id,
    EXTRACT(MONTH FROM event_date) AS months,
    LAG(EXTRACT(MONTH FROM event_date)) OVER(
      PARTITION BY user_id 
      ORDER BY EXTRACT(MONTH FROM event_date) ASC
    ) AS prev_month
  FROM user_actions
  WHERE event_date >= '2022-06-01' 
    AND event_date < '2022-08-01'
)

SELECT 
  months,
  COUNT(DISTINCT user_id) AS monthly_active_users
FROM classify
WHERE months = 7 
  AND prev_month = 6
GROUP BY 
  months;

-- Explanation for Solution 2:
-- 1. Filter the dataset for June and July events to reduce processing load.
-- 2. Extract the active month from the timestamp.
-- 3. Use the LAG() window function to look back at the previous active month for each user. PARTITION BY user_id ensures we don't mix up different users, 
--    and ORDER BY months ASC aligns the timeline.
-- 4. In the main query, explicitly filter for the transition boundary: WHERE the current row is month 7 AND its previous logged month is 6.
-- 5. Use COUNT(DISTINCT user_id) to calculate the final MAU metric, preventing any accidental overcounting if a user has multiple transition rows.
