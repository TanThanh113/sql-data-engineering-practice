-- Problem: Active Users Per Platform

-- Description:
-- Count number of unique users per platform

SELECT platform,
      COUNT(DISTINCT user_id) AS num_user
FROM user_sessions
GROUP BY platform;

-- Explanation:
-- 1. GROUP BY platform to aggregate per platform
-- 2. COUNT DISTINCT user_id to get unique users
