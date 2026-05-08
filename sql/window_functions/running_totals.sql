/*Thought process:
    I wanted to understand how sales accumulate over time
    and how different categories contribute to total sales.

Logic:
    1. First query:
        - Calculated running total of sales to understand
          cumulative business growth over time.

    2. Second query:
        - Calculated running total within each category
          to compare category-wise growth patterns.

    3. Third query:
        - Calculated percentage contribution of each
          sub-category to total sales.

Why this approach:
    Running totals help track growth trends, while
    contribution percentage helps identify which segments
    are driving overall business performance. */
/* Q10: Running total of sales by order date */

SELECT
    order_id,
    customer_name,
    order_date,
    sales,
    SUM(sales) OVER (
        ORDER BY order_id, order_date
    ) AS running_total
FROM Sample_Superstore;

/* Q11: Running total of sales per category */

SELECT
    category,
    order_date,
    sales,
    SUM(sales) OVER (
        PARTITION BY category
        ORDER BY order_id, order_date
    ) AS running_total
FROM Sample_Superstore;

/* Q12: Percentage contribution by sub-category */

SELECT
    sub_category,
    SUM(SUM(sales)) OVER () AS total_sales,
    SUM(sales) AS sales_per_sub_category,
    SUM(sales) / SUM(SUM(sales)) OVER () * 100 AS sales_percentage
FROM Sample_Superstore
GROUP BY sub_category;
