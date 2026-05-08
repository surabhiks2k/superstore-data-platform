/*Thought process:
    I wanted to understand which category performs best
    in each region, since performance can vary across regions.

Logic:
    1. First, I calculated total sales for each
       region and category combination.
    2. Then, I ranked categories within each region
       based on sales performance.
    3. Finally, I picked the top category per region.

Why this approach:
    This helps identify region-specific strengths,
    instead of assuming one category performs uniformly
    across all regions.*/
/* Q2: Sales per region and top category */

WITH sales_per_region AS (
    SELECT
        region,
        category,
        SUM(sales) AS total_sales
    FROM Sample_Superstore
    GROUP BY region, category
),
rank_per_region AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY region
            ORDER BY total_sales DESC
        ) AS rank
    FROM sales_per_region
)
SELECT *
FROM rank_per_region
WHERE rank = 1;
