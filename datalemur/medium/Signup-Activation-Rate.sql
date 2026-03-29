-- Problem: Signup Activation Rate

-- Description:
-- Calculate the activation rate for activated emails.

SELECT ROUND((1.0 * COUNT(t.email_id) 
      / COUNT(DISTINCT e.email_id)),2) AS confirm_rate
FROM emails AS e
LEFT JOIN texts AS t 
  ON e.email_id = t.email_id
  AND t.signup_action = 'Confirmed'
  
  /*
-- Explanation:
-- 1. Use LEFT JOIN to merge the emails table (denoted as e) and the texts table 
    (denoted as t) with the condition e.email_id = t.email_id and only retrieve 
    emails containing the word "confirmed".
      
-- 2. Use COUNT to calculate the total number of activated emails and the total
      number of emails, then divide the two totals.
      
-- 3. Multiply by 1.0 to convert to decimal.

-- 4. Use ROUND to round to the second decimal place.
*/
