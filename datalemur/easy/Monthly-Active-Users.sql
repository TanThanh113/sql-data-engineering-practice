-- Problem: Monthly Active Users

-- Description:
-- Find pages with no likes.

SELECT page_id
FROM pages AS p
WHERE p.page_id NOT IN (
      SELECT DISTINCT pl.page_id
      FROM page_likes AS pl
    )
ORDER BY page_id ASC;

/*
-- Explanation:
-- 1. Use a subquery to create a temporary table containing the page_id values 
      from the page_likes table.
      
-- 2. Use NOT IN to discard the values just created from the temporary table.

-- 3. Use ORDER to sort by page_id.
*/
