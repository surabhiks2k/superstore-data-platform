/* hought process:
    I wanted to solve different ranking and top-N problems
    across products, customers, regions, and categories

Logic:
    1. First query:
        - Identified top 3 products per category based on sales

    2. Second query:
        - Found the most recent order per customer using ordering logic

    3. Third query:
        - Tried to detect duplicate orders using ROW_NUMBER

    4. Fourth query:
        - Ranked customers based on total spend using different ranking methods

    5. Fifth query:
        - Identified second highest performing region by sales

    6. Sixth query:
        - Ranked sub-categories within each category by profit

Why this approach:
    Ranking helps compare entities within a group and is useful
    for prioritization, anomaly detection, and business decision-making.
/* Q1: Find top 3 products per category by sales */ */

SELECT *
FROM (
    SELECT
        product_name,
        category,
        sales,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY sales DESC
        ) AS rank
    FROM Sample_Superstore
) AS rn
WHERE rank <= 3;

/* Q2: Find the most recent order per customer */

SELECT *
FROM (
    SELECT
        customer_id,
        customer_name,
        order_id,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS recent_order
    FROM Sample_Superstore
) AS rn
WHERE recent_order = 1;

/* Q3: Find duplicate orders using ROW_NUMBER() */

SELECT *
FROM (
    SELECT
        order_id,
        order_date,
        customer_id,
        customer_name,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY order_date DESC
        ) AS row_num
    FROM Sample_Superstore
) AS rn
WHERE row_num = 1;

/* Q4: Rank customers by total spend */

SELECT
    total_sales,
    customer_name,
    RANK() OVER (ORDER BY total_sales DESC) AS rank,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS row_num,
    DENSE_RANK() OVER (ORDER BY total_sales DESC) AS dense_rank
FROM (
    SELECT
        customer_name,
        SUM(sales) AS total_sales
    FROM Sample_Superstore
    GROUP BY customer_name
) t;

/* Q5: Find the second highest sales per region */

SELECT *
FROM (
    SELECT
        region,
        total_sales,
        RANK() OVER (ORDER BY total_sales DESC) AS rank
    FROM (
        SELECT
            region,
            SUM(sales) AS total_sales
        FROM Sample_Superstore
        GROUP BY region
    ) t
) t2
WHERE t2.rank = 2;

/* Q6: Rank sub-categories by total profit within each category */

SELECT
    category,
    sub_category,
    total_profit,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY total_profit DESC
    ) AS rank
FROM (
    SELECT
        category,
        sub_category,
        SUM(profit) AS total_profit
    FROM Sample_Superstore
    GROUP BY category, sub_category
) t;
