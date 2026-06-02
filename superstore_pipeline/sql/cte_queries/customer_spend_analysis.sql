/*==================================================
File: above_average_customer_spend.sql

Thought process:
    I wanted to identify customers who are spending
    more than the average customer in the dataset.

Logic:
    1. First, I calculated total spend per customer.
    2. Then, I calculated the overall average customer spend.
    3. Finally, I filtered customers whose spend is
       higher than this average.

Alternative approach:
    I also explored a window function approach to
    calculate average spend directly within the same dataset,
    which avoids an extra CTE.

Why this approach:
    This helps identify high-value customers who contribute
    more than the typical customer, useful for segmentation
    and targeting.
==================================================
/* Q3: Customers above average spend */*/

WITH customer_spend_details AS (
    SELECT
        customer_name,
        SUM(sales) AS total_spend
    FROM Sample_Superstore
    GROUP BY customer_name
),
avg_spend_details AS (
    SELECT
        AVG(total_spend) AS average_spend
    FROM customer_spend_details
)
SELECT *
FROM customer_spend_details c
CROSS JOIN avg_spend_details a
WHERE c.total_spend > a.average_spend;

/* Alternative approach */

WITH customer_spend_details AS (
    SELECT
        customer_name,
        SUM(sales) AS total_spend,
        AVG(SUM(sales)) OVER () AS avg_spend
    FROM Sample_Superstore
    GROUP BY customer_name
)
SELECT *
FROM customer_spend_details
WHERE total_spend > avg_spend;
