-- Problem: Maximize Prime Item Inventory

-- Description:
-- Amazon wants to maximize the number of items it can stock in a 500,000 square 
--  feet warehouse.
-- Priority is given to 'prime_eligible' items. The remaining space is then used 
--  for 'not_prime' items.
-- Calculate the total number of items for each item_type that can be stocked
--  safely without sorting risks.

WITH all_prime AS (
  SELECT 
    SUM(square_footage) AS prime_sum,
    COUNT(item_id) AS prime_count
  FROM inventory
  WHERE item_type = 'prime_eligible'
),

all_non_prime AS (
  SELECT 
    SUM(square_footage) AS non_prime_sum,
    COUNT(item_id) AS non_prime_count
  FROM inventory
  WHERE item_type = 'not_prime'
)

SELECT 
  'prime_eligible' AS item_type,
  FLOOR(500000 / prime_sum) * prime_count AS item_count
FROM all_prime

UNION ALL

SELECT 
  'not_prime' AS item_type,
  FLOOR((500000 - FLOOR(500000 / prime_sum) * prime_sum) 
        / non_prime_sum) * non_prime_count AS item_count
FROM all_prime, all_non_prime;

/*-- Explanation:
-- 1. Create two independent CTEs (all_prime and all_non_prime) to aggregate 
      the total square footage and item count for each category. This decoupling ensures 
      data integrity.

-- 2. In the first SELECT, calculate how many full batches of prime items fit into 
      the 500,000 sq ft limit using FLOOR(), then multiply by the number of items per batch.

-- 3. Use UNION ALL to append the results of the non-prime calculation to the final output.

-- 4. In the second SELECT, perform a cross-join (FROM all_prime, all_non_prime) 
      to safely access the 'prime_sum' variable.

-- 5. Subtract the total area consumed by prime items from 500,000 to find the 
      remaining square footage.

-- 6. Finally, divide the remaining space by 'non_prime_sum', use FLOOR() to ensure 
      only complete batches are added, and multiply by the non-prime item count.
*/
