-- Problem: Data Science Skills

-- Description:
-- Find candidates who are proficient in all three required skills: Python, Tableau, and PostgreSQL.
-- The output should list the candidate IDs in ascending order.

SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BYcandidate_id
HAVING COUNT(DISTINCT skill) = 3
ORDER BY candidate_id;

/*
-- Explanation:
-- 1. Use the WHERE ... IN clause to filter the dataset strictly for the three target skills. 

-- 2. GROUP BY candidate_id to aggregate the skills per candidate.

-- 3. Use HAVING COUNT(skill) = 3 to ensure we only keep candidates who possess exactly all 3 required skills.

-- 4. ORDER BY candidate_id to sort the final output in ascending order.
*/
