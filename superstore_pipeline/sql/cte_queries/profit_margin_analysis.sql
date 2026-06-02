/*Thought process:
    I wanted to find which sub-categories are actually
    performing well in terms of profitability, not just sales.

Logic:
    1. First, I calculated total profit and total sales
       for each sub-category.
    2. Then, I derived profit margin using profit vs sales.
    3. Finally, I ranked sub-categories based on profit margin
       to identify the top performers.

Why this approach:
    This gives a clearer picture of efficiency, because a
    high-sales category is not always the most profitable one*/
/* Q1: Top 3 sub-categories by profit margin */

WITH sub_category_profit_sales AS (
    SELECT
        SUM(profit) AS total_profit,
        SUM(sales) AS total_sales,
        sub_category
    FROM Sample_Superstore
    GROUP BY sub_category
),
profit_margin_per AS (
    SELECT
        *,
        (total_profit / NULLIF(total_sales, 0)) * 100 AS profit_margin_per
    FROM sub_category_profit_sales
),
rank_by_profit_per AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            ORDER BY profit_margin_per DESC
        ) AS rn
    FROM profit_margin_per
)
SELECT *
FROM rank_by_profit_per
WHERE rn <= 3;
