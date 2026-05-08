/* Thought process:
    I wanted to analyze how sales and customer behavior
    change over time instead of just looking at static totals.

Logic:
    1. First query:
        - Aggregated sales by month
        - Compared each month with the previous month
        - Calculated growth in absolute and percentage terms

    2. Second query:
        - Identified months where sales dropped compared to
          the previous month to detect negative trends

    3. Third query:
        - Compared each customer’s current order with their
          previous order using LAG to understand spending pattern

Why this approach:
    This helps in tracking trends, detecting declines early,
    and understanding customer purchasing behavior over time.

Q7: Compare each month's sales to previous month */

SELECT
    month,
    total_sales,
    prev_sales,
    (total_sales - prev_sales) AS growth,
    ROUND(
        (total_sales - prev_sales) * 100.0 / prev_sales,
        2
    ) AS growth_per
FROM (
    SELECT
        month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY month) AS prev_sales
    FROM (
        SELECT
            strftime(
                '%Y-%m',
                substr(order_date, 7, 4) || '-' ||
                substr(order_date, 1, 2) || '-' ||
                substr(order_date, 4, 2)
            ) AS month,
            SUM(sales) AS total_sales
        FROM Sample_Superstore
        GROUP BY month
    ) t1
) t2;

/* Q8: Find months where sales dropped compared to previous month */

SELECT
    month,
    total_sales,
    prev_sales,
    (total_sales - prev_sales) AS drop_amount,
    ((total_sales - prev_sales) / prev_sales) * 100 AS drop_amount_per
FROM (
    SELECT
        month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY month) AS prev_sales
    FROM (
        SELECT
            strftime(
                '%Y-%m',
                substr(order_date, 7, 4) || '-' ||
                substr(order_date, 1, 2) || '-' ||
                substr(order_date, 4, 2)
            ) AS month,
            SUM(sales) AS total_sales
        FROM Sample_Superstore
        GROUP BY month
    ) t1
) t2
WHERE prev_sales IS NOT NULL
    AND total_sales < prev_sales;

/* Q9: Previous order amount for same customer */

SELECT
    sales AS current_sales,
    order_id,
    customer_name,
    order_date,
    LAG(sales) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS prev_amount
FROM Sample_Superstore
ORDER BY order_id, order_date;
