-- =====================================================
-- Core Business Analysis
-- =====================================================

-- Q1: Payment method usage and quantity sold
SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_quantity_sold
FROM walmart
GROUP BY payment_method;

-- =====================================================
-- Customer Rating Analysis
-- =====================================================

-- Q2: Highest-rated category per branch
WITH category_rating AS (
    SELECT
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER (
            PARTITION BY branch
            ORDER BY AVG(rating) DESC
        ) AS rank
    FROM walmart
    GROUP BY branch, category
)
SELECT
    branch,
    category,
    avg_rating
FROM category_rating
WHERE rank = 1;


----  Time-Based Analysis


-- Q3: Busiest day per branch
WITH sales_dates AS (
    SELECT
        branch,
        TO_DATE(date, 'DD/MM/YY') AS sale_date
    FROM walmart
)
SELECT
    branch,
    TO_CHAR(sale_date, 'Day') AS day_name,
    COUNT(*) AS transactions
FROM sales_dates
GROUP BY branch, day_name
QUALIFY
    RANK() OVER (
        PARTITION BY branch
        ORDER BY COUNT(*) DESC
    ) = 1;


---- Profitability Analysis ----

---- Assumption: profit_margin is stored as percentage ----


SELECT
    category,
    SUM(total) AS total_revenue,
    SUM(total * profit_margin / 100) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;



---- Payment Behavior Analysis ----


-- Q7: Most common payment method per branch
WITH payment_rank AS (
    SELECT
        branch,
        payment_method,
        COUNT(*) AS transactions,
        RANK() OVER (
            PARTITION BY branch
            ORDER BY COUNT(*) DESC
        ) AS rank
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT
    branch,
    payment_method,
    transactions
FROM payment_rank
WHERE rank = 1;



---- Sales Shift Analysis ----


SELECT
    branch,
    CASE
        WHEN EXTRACT(HOUR FROM time::time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM time::time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS day_shift,
    COUNT(*) AS total_invoices
FROM walmart
GROUP BY branch, day_shift
ORDER BY branch, total_invoices DESC;



