CREATE OR REPLACE VIEW vw_walmart_clean AS
SELECT
    invoice_id,
    branch,
    city,
    category,
    payment_method,
    quantity,
    unit_price,
    rating,
    profit_margin,
    total AS revenue,

    -- Date handling
    TO_DATE(date, 'DD/MM/YY') AS sale_date,
    DATE_TRUNC('month', TO_DATE(date, 'DD/MM/YY')) AS month,
    EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) AS year,

    -- Time handling
    EXTRACT(HOUR FROM time::time) AS sale_hour,

    -- Profit calculation
    total * profit_margin / 100 AS profit
FROM walmart;

SELECT * FROM vw_walmart_clean LIMIT 10;
