
/*
==================================================
File: product_profit_and_risk_analysis.sql

Thought process:
    I wanted to understand how products are performing
    not just from profit alone, but also considering
    discount impact and overall business contribution.

Logic:
    1. First, I classified products into profit categories
       based on profit percentage (profit vs sales).

    2. Then, I added a risk view based on discount levels
       to understand pricing pressure.

    3. Finally, I created a simple scoring model combining
       sales, quantity, discount, and profit to rank products.

Why this approach:
    This gives a more complete view of product performance
    instead of looking at profit in isolation.
    It helps identify both revenue drivers and risky products.
==================================================
*/
SELECT
    category,
    COUNT(CASE WHEN profit > 0 THEN 1 END) AS profitable,
    COUNT(CASE WHEN profit < 0 THEN 0 END) AS loss
FROM Sample_Superstore
GROUP BY category;

/* Profit category, discount risk and product score */

SELECT
    product_name,
    category,
    discount,
    profit,
    sales,
    quantity,
    CASE
        WHEN ((profit / NULLIF(sales, 0)) * 100) > 20 THEN 'profit'
        WHEN ((profit / NULLIF(sales, 0)) * 100) > 0 THEN 'Break even'
        ELSE 'Loss'
    END AS profit_category,

    CASE
        WHEN discount > 0.30 THEN 'high_risk'
        WHEN discount >= 0.15 THEN 'medium_risk'
        ELSE 'safe'
    END AS discount_risk,

    CASE WHEN sales > 5000 THEN 30 ELSE 0 END +
    CASE WHEN quantity > 10 THEN 25 ELSE 0 END +
    CASE WHEN discount < 0.15 THEN 25 ELSE 0 END +
    CASE WHEN profit > 200 THEN 20 ELSE 0 END AS product_score

FROM Sample_Superstore;
