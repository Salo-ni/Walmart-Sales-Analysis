
---- Data Quality Checks ----


-- Total records
SELECT COUNT(*) AS total_records
FROM walmart;

-- Unique branches
SELECT COUNT(DISTINCT branch) AS total_branches
FROM walmart;

-- Minimum quantity sold
SELECT MIN(quantity) AS min_quantity
FROM walmart;
