
/*
==================================================
File: profit_category_distribution.sql

Thought process:
    I wanted to understand how products are distributed
    based on their profit performance, instead of just
    looking at total profit.

Logic:
    I calculated profit percentage (profit vs sales) and
    grouped products into three simple categories:
    - Profit: strong positive margin (> 20%)
    - Acceptable: low positive margin (0%–20%)
    - Loss: negative margin (< 0%)

    Then I counted how many products fall into each group.

Why this approach:
    This helps quickly understand product portfolio health
    and whether most products are actually profitable or not.

/* Count products by profit category */ */

SELECT
    COUNT(
        CASE
            WHEN ((profit / NULLIF(sales, 0)) * 100) > 20 THEN 1
        END
    ) AS profit,

    COUNT(
        CASE
            WHEN ((profit / NULLIF(sales, 0)) * 100) > 0
            AND ((profit / NULLIF(sales, 0)) * 100) <= 20 THEN 1
        END
    ) AS acceptable,

    COUNT(
        CASE
            WHEN ((profit / NULLIF(sales, 0)) * 100) < 0 THEN 1
        END
    ) AS loss

FROM Sample_Superstore;
