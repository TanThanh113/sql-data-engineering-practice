-- Problem: Odd and Even Measurements

-- Description:
-- Calculate the sum of odd-numbered and even-numbered measurements separately for each day.
-- The output includes the measurement day, the sum of odd measurements, and the 
--  sum of even measurements, sorted chronologically.

WITH Rank_time AS (
  SELECT 
    measurement_value,
    measurement_time::DATE AS measurement_day,
    ROW_NUMBER() OVER(
    PARTITION BY measurement_time::DATE
    ORDER BY measurement_time) as rnk
  FROM measurements
)
SELECT 
  measurement_day,
  SUM(measurement_value) FILTER (WHERE rnk % 2 != 0) AS odd_sum,
  SUM(measurement_value) FILTER (WHERE rnk % 2 = 0) AS even_sum
FROM Rank_time
GROUP BY measurement_day

/*
-- Explanation:
-- 1. Use a CTE (Rank_time) to extract the date portion from the timestamp using ::DATE.

-- 2. Use ROW_NUMBER() to assign a sequential rank to each measurement. 

-- 3. PARTITION BY measurement_time::DATE ensures the ranking restarts perfectly 
      at the beginning of each new day.

-- 4. ORDER BY measurement_time ASC ensures the rank strictly follows the chronological 
      order of measurements within that day.

-- 5. In the main query, use PostgreSQL's highly efficient FILTER clause to separate 
      the aggregations.

-- 6. Filter by (rnk % 2 != 0) for the odd_sum and (rnk % 2 = 0) for the even_sum.

-- 7. Finally, GROUP BY the measurement_day and ORDER BY it ascendingly to present a 
      clean, chronological report.
*/
