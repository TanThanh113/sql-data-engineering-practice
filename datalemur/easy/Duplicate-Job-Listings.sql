-- Problem: Duplicate Job Listings

-- Description:
-- Find the number of companies that have posted duplicate job listings 
-- (same company, title, and description).
 
WITH job_duplicate AS (
  SELECT company_id, 
        title, 
        description,
        COUNT(job_id) AS duplicate
  FROM job_listings
  GROUP BY company_id, title, description
)
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM job_duplicate
WHERE duplicate > 1
 /*
 Explanation:
-- 1. Use a CTE (job_duplicate) to group listings by company_id, title 
      and description.
      
-- 2. Use COUNT(job_id) to count how many times each specific job posting appears.

-- 3. In the main query, use WHERE duplicate > 1 to filter and keep only the duplicated jobs.

-- 4. Use COUNT(DISTINCT company_id) to calculate the unique number of companies 
      that have these duplicate postings.
 */
