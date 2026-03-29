-- Problem: Unfinished Parts

-- Description:
-- Identify the parts and their corresponding assembly steps that 
-- have not yet been finished.

SELECT 
    part, 
    assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;

/*
-- Explanation:
-- 1. SELECT part and assembly_step to retrieve the required information.

-- 2. WHERE clause with 'finish_date IS NULL' filters the dataset to only 
      include rows where the task is incomplete (missing a finish date).
*/
