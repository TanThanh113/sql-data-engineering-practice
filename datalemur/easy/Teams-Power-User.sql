-- Problem: Teams Power User

-- Description:
-- Identify the top 2 users who sent the highest number of messages in August 2022.

SELECT 
  sender_id,
  COUNT(message_id) AS message_count
FROM messages 
WHERE sent_date >= '2022-08-01' AND sent_date < '2022-09-01'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2

/*
- Explanation:
-- 1. Filter the dataset strictly for August 2022 using the WHERE clause. 
      (Using < '2022-09-01' ensures all timestamps on August 31st are included).
      
-- 2. GROUP BY sender_id to aggregate the data for each individual sender.


-- 3. COUNT(message_id) calculates the total number of messages sent by each user.

-- 4. ORDER BY message_count DESC sorts the aggregated results from highest to lowest.

-- 5. LIMIT 2 restricts the final output to only show the top 2 most active users.
*/
