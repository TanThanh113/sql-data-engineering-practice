-- Problem: Server Utilization Time

-- Description:
-- Calculate the total time that the fleet of servers was running.
-- The output should be the total uptime in full days. 
-- A server might start and stop multiple times.
WITH create_next_day AS (
  SELECT 
    server_id,
    session_status,
    status_time,
    LEAD(status_time) OVER(
      PARTITION BY server_id 
      ORDER BY status_time
    ) AS next_time
  FROM server_utilization
)
SELECT
  FLOOR(SUM(EXTRACT(EPOCH FROM (next_time - status_time))) / 86400) AS total_uptime_days
FROM create_next_day
WHERE 
  session_status = 'start'
  AND next_time IS NOT NULL;

/*
-- EXPLANATION:
-- 1. CTE 'create_next_day': Uses the LEAD() window function to fetch the 'stop' 
      time and append it directly to the same row as the 'start' time.

-- 2. Window Framing: PARTITION BY server_id ensures we only match start/stop times 
      for the exact same server. ORDER BY status_time ASC aligns the chronological events.

-- 3. Filtering: In the main query, we filter ONLY for the 'start' rows. We also 
      add "next_time IS NOT NULL" to safely exclude any ongoing sessions that haven't stopped yet.

-- 4. Mathematical Logic for Uptime:
--    a. (next_time - status_time) calculates the time difference as an Interval.
--    b. EXTRACT(EPOCH FROM ...) is a highly robust PostgreSQL feature that converts this interval strictly into total seconds.
--    c. We divide by 86400 (24 hours * 60 minutes * 60 seconds) to convert the seconds into days.
--    d. Finally, we SUM the days and use FLOOR() to round down to the nearest full day, exactly as requested by the problem.
*/
