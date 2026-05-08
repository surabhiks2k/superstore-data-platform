/*Thought process:
    I wanted to understand how each product category
    is performing from  a sales perspective

Logic:
     I calculated total profit per category
       and ranked them to identify the top performer.

Why this approach:
    This helps to get a clearer
    business view of category performance.
/* Category by sales */*/

WITH category_sales AS (
    SELECT
        ROUND(SUM(sales), 2) AS total_sales,
        category
    FROM Sample_Superstore
    GROUP BY category
)
SELECT *
FROM category_sales
WHERE total_sales > 800000;

/* Top performing category by profit */

WITH category_sales AS (
    SELECT
        SUM(profit) AS total_profit,
        category
    FROM Sample_Superstore
    GROUP BY category
),
ranked_categories AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY total_profit DESC
        ) AS rn
    FROM category_sales
)
SELECT
    category,
    total_profit,
    rn AS rank
FROM ranked_categories
WHERE rn = 1;
