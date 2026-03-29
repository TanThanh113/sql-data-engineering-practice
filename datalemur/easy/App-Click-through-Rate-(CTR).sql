-- Problem: App Click-through Rate (CTR)

-- Description:
-- calculate the click-through rate (CTR) for the app in 2022 
-- and round the results to 2 decimal places.

SELECT 
  app_id,
  ROUND(100.0 *
    COUNT(1) FILTER (WHERE event_type = 'click') / 
    COUNT(1) FILTER (WHERE event_type = 'impression'), 2) AS ctr
FROM events
WHERE timestamp >= '2022-01-01'
  AND timestamp <= '2022-12-31'
GROUP BY app_id

/*
-- Explanation:
-- 1. WHERE to filter timestamps in 2022
      
-- 2. Use GROUP to group columns by app_id

-- 3. COUNT is combined with FILTER, with the condition event_type = 'click'; 
      if satisfied, it will add 1, similarly for 'impression'.
      
-- 4. ROUND is used to calculate the CTR ratio according to the formula 
      (100.0 * Number of clicks / Number of impressions).
*/
