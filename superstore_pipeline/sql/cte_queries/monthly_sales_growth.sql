/*Thought process:
    I wanted to understand how sales are changing month over month,
    rather than just looking at total sales.

Logic:
    1. First, I aggregated sales at a monthly level by extracting
       the month from the order date.
    2. Then, I used a window function (LAG) to bring in
       the previous month’s sales.
    3. Finally, I calculated absolute and percentage growth
       between current and previous month.

Why this approach:
    This helps track business trends over time and quickly
    identify whether sales are improving or declining.*/
    /* Monthly sales + previous month comparison */

WITH monthly_sales AS (
    SELECT
        SUM(sales) AS total_sales,
        strftime(
            '%Y-%m',
            substr(order_date, 7, 4) || '-' ||
            substr(order_date, 1, 2) || '-' ||
            substr(order_date, 4, 2)
        ) AS month
    FROM Sample_Superstore
    GROUP BY month
),
previous_month_sales AS (
    SELECT
        *,
        LAG(total_sales) OVER (
            ORDER BY month
        ) AS previous_sales
    FROM monthly_sales
)
SELECT
    month,
    total_sales AS current_month,
    previous_sales AS previous_month,
    (total_sales - previous_sales) AS growth,
    (total_sales - previous_sales) / previous_sales * 100 AS growth_per
FROM previous_month_sales;
