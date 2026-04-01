-- Problem: Tweets' Rolling Averages

-- Description:
-- Calculate the 3-day rolling average of tweets for each user.
-- The output should include the user_id, tweet_date, and rolling average rounded to 2 decimal places.

SELECT 
  user_id,
  tweet_date,
  ROUND(
    AVG(tweet_count) OVER(
      PARTITION BY user_id 
      ORDER BY tweet_date ASC 
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_avg_3d
FROM tweets;
/*
-- Explanation:
-- 1. We use the AVG() window function to calculate the moving average directly.

-- 2. PARTITION BY user_id ensures the rolling average is calculated independently for each user.

-- 3. ORDER BY tweet_date ASC sorts the tweets chronologically so the moving window 
      flows correctly over time.

-- 4. The framing clause "ROWS BETWEEN 2 PRECEDING AND CURRENT ROW" creates a 
      dynamic 3-day window (the current day plus the two previous days). 
      Note: SQL automatically handles the edge cases (day 1 and day 2) where 2 
      preceding rows don't exist yet.
-- 5. Finally, ROUND(..., 2) formats the output to two decimal places.
*/
