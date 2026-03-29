-- Problem: Laptop vs. Mobile Viewership

-- Description:
-- Calculate the total number of views for laptops and mobile devices. 
-- Mobile devices are defined as tablets and phones.

SELECT
  COUNT(1) FILTER (WHERE device_type = 'laptop') AS laptop_views,
  COUNT(1) FILTER (WHERE device_type IN ('tablet', 'phone')) AS mobile_views
FROM viewership;

/*
-- Explanation:
-- 1. Use COUNT(1) with the FILTER clause to efficiently count rows based on 
      specific conditions in a single pass.
      
-- 2. The first column filters specifically for 'laptop' devices.

-- 3. The second column groups 'tablet' and 'phone' together using the 
      IN operator to represent total mobile views.
*/
