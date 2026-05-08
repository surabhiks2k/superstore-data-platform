/*Thought process:
    I wanted to analyze sales behavior at a more detailed level —
    combining ranking, cumulative sales, and trend comparison
    within categories and customers.

Logic:
    1. First query:
        - Ranked products within each category based on sales
        - Calculated running total of sales over time
        - Compared each sale with the previous one using LAG

    2. Second query:
        - Compared monthly customer spending
        - Identified customers whose spending increased month-over-month

    3. Third query:
        - Found top-performing product in each sub-category
        - Based on total profit per product

Why this approach:
    This helps understand not just totals, but also trends,
    momentum, and relative performance within groups.
 Q13: Category level ranking and running totals */

SELECT
    category,
    product_name,
    order_id,
    order_date,
    sales,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY sales DESC
    ) AS rank,
    SUM(sales) OVER (
        PARTITION BY category
        ORDER BY order_date, order_id
    ) AS running_total,
    LAG(sales) OVER (
        PARTITION BY category
        ORDER BY order_date, order_id
    ) AS previous_sales
FROM Sample_Superstore;

/* Q14: Customers with higher current month spend */

SELECT *
FROM (
    SELECT
        customer_id,
        customer_name,
        current_month_sales,
        LAG(current_month_sales) OVER (
            PARTITION BY customer_id
            ORDER BY month
        ) AS previous_month_sales
    FROM (
        SELECT
            customer_id,
            customer_name,
            SUM(sales) AS current_month_sales,
            strftime(
                '%Y-%m',
                substr(order_date, 7, 4) || '-' ||
                substr(order_date, 1, 2) || '-' ||
                substr(order_date, 4, 2)
            ) AS month
        FROM Sample_Superstore
        GROUP BY customer_id, customer_name, month
    ) t
) final
WHERE final.current_month_sales > final.previous_month_sales;

/* Q15: Top product per sub-category by profit */

SELECT
    sub_category,
    product_name,
    total_profit
FROM (
    SELECT
        sub_category,
        product_name,
        total_profit,
        ROW_NUMBER() OVER (
            PARTITION BY sub_category
            ORDER BY total_profit DESC
        ) AS rn
    FROM (
        SELECT
            sub_category,
            product_name,
            SUM(profit) AS total_profit
        FROM Sample_Superstore
        GROUP BY sub_category, product_name
    ) t
) final
WHERE final.rn = 1;
