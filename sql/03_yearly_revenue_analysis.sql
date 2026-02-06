-- =====================================================
-- Year-over-Year Revenue Decline Analysis
-- =====================================================

WITH yearly_revenue AS (
    SELECT
        branch,
        EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) AS year,
        SUM(total) AS revenue
    FROM walmart
    GROUP BY branch, year
)
SELECT
    y22.branch,
    y22.revenue AS revenue_2022,
    y23.revenue AS revenue_2023,
    ROUND(
        (y22.revenue - y23.revenue)
        / NULLIF(y22.revenue, 0) * 100,
        2
    ) AS revenue_decline_pct
FROM yearly_revenue y22
JOIN yearly_revenue y23
    ON y22.branch = y23.branch
WHERE y22.year = 2022
  AND y23.year = 2023
  AND y22.revenue > y23.revenue
ORDER BY revenue_decline_pct DESC
LIMIT 5;
