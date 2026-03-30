-- Problem: Compressed Mode

-- Description:
-- Find the mode (most frequent value) of the item_count from a compressed frequency table.
-- If there are multiple modes (ties), return all of them sorted in ascending order.

ELECT item_count AS mode 
FROM items_per_order
WHERE order_occurrences = (
  SELECT MAX(order_occurrences)
  FROM items_per_order
)
ORDER BY item_count

/*
-- Explanation:
-- 1. The dataset is a frequency table, meaning the counts are already provided 
      in the 'order_occurrences' column.

-- 2. Use a subquery in the WHERE clause: (SELECT MAX(order_occurrences) FROM items_per_order) 
      to dynamically find the highest absolute frequency in the entire table.

-- 3. The main query evaluates each row and only keeps the 'item_count' where its 
      occurrence perfectly matches that maximum value.

-- 4. This subquery approach safely handles ties, ensuring all modes are returned 
      if multiple items share the same highest frequency.

-- 5. Finally, ORDER BY item_count ASC sorts the output as requested.
*/
