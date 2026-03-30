-- Problem: Average Post Hiatus (Part 1)

-- Description:
-- Calculate the number of days between the first and last post for each user.
-- Only include users who have published at least 2 posts.

SELECT 
  user_id,
  EXTRACT(DAY FROM (MAX(post_date) - MIN(post_date))) AS days_between
FROM posts
WHERE EXTRACT (YEAR FROM post_date) = '2021'
GROUP BY user_id
HAVING COUNT(post_id) > 1

/*
-- Explanation:
-- 1. GROUP BY user_id to aggregate the posting data for each individual user.

-- 2. WHERE to filter post_dates in 2021.

-- 3. Use the HAVING clause with COUNT(post_id) > 1 to filter out users who have 
      only posted once.
      
-- 4. Calculate the time interval by subtracting the first post date (MIN) from 
      the latest post date (MAX).
      
-- 5. Use EXTRACT(DAY FROM ...) to convert the resulting time interval into a 
      standard integer representing the number of days.
*/
