/*
==================================================
File: customer_value_classification.sql

Thought process:
    I wanted to understand how each customer is performing
    compared to overall sales behavior.

    Instead of manually calculating averages separately,
    I used a window function to compare each record
    directly with the overall average.

Logic:
    - If sales is above overall average → HIGH value
    - If equal → Medium value
    - If below → Low value

Why this approach:
    This makes the classification simple, scalable,
    and avoids extra subqueries or temporary tables.
==================================================
*/
SELECT
    product_name,
    customer_id,
    customer_name,
    sales,
    CASE
        WHEN sales > AVG(sales) OVER () THEN 'HIGH Value '
        WHEN sales = AVG(sales) OVER () THEN 'Medium value '
        ELSE 'Low value '
    END AS customer_category
FROM Sample_Superstore;
