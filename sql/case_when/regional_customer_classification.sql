/*

Thought process:
    I wanted to understand how each customer is performing
    within their own region, rather than comparing everyone
    globally.

Logic:
    1. First, I calculated total sales per customer in each region.
    2. Then, I calculated the average customer performance per region
       using a window function.
    3. Finally, I compared each customer against their regional average
       to classify them.

Classification:
    - Above average → strong contributor in that region
    - Below average → weaker contributor
    - At average → balanced performance

Why this approach:
    This gives a fair comparison since customer behavior
    varies across regions, and regional benchmarking is more meaningful
    than global comparison.
/* Customer classification within region */ */

WITH sum_sales_per_region AS (
    SELECT
        SUM(sales) AS total_sales,
        region,
        customer_name
    FROM Sample_Superstore
    GROUP BY region, customer_name
),

avg_sales AS (
    SELECT
        customer_name,
        total_sales,
        region,
        AVG(total_sales) OVER (
            PARTITION BY region
        ) AS regional_avg
    FROM sum_sales_per_region
),

customer_classification AS (
    SELECT
        *,
        CASE
            WHEN total_sales > regional_avg THEN 'above average'
            WHEN total_sales < regional_avg THEN 'below average'
            ELSE 'at average'
        END AS customer_classification
    FROM avg_sales
)

SELECT *
FROM customer_classification;
