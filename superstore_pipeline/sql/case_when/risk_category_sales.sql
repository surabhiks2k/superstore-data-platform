/*Thought process:
    I wanted to understand how total sales are distributed
    based on discount levels, since discount directly
    impacts revenue quality and risk.

Logic:
    I grouped sales into three simple categories:
    - High risk: heavily discounted sales (> 30%)
    - Medium risk: moderately discounted sales (15%–30%)
    - Safe: low discount sales (< 15%)

    Then I summed sales in each category to see
    where most revenue is coming from.

Why this approach:
    This helps identify whether the business is relying
    more on high-discount (riskier) sales or stable pricing.
==================================================
/* Total sales by risk category */*/

SELECT
    SUM(
        CASE
            WHEN discount > 0.30 THEN sales
            ELSE 0
        END
    ) AS high_risk_category,

    SUM(
        CASE
            WHEN discount >= 0.15
            AND discount <= 0.30 THEN sales
            ELSE 0
        END
    ) AS medium_risk_category,

    SUM(
        CASE
            WHEN discount < 0.15 THEN sales
            ELSE 0
        END
    ) AS safe,

    SUM(sales) AS total_sales

FROM Sample_Superstore;
