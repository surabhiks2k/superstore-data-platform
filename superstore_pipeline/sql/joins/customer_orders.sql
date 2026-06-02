  /*  Thought process:
    I wanted to understand the relationship between customers
    and their orders, and also identify customers with no orders.

Logic:
    1. First, I looked at raw customer and order tables separately
       to understand the data structure.
    2. Then, I joined customers with orders to map spending behavior.
    3. I used INNER JOIN to see only matching records.
    4. I used LEFT JOIN to include all customers and check
       who has no orders.

Why this approach:
    This helps in understanding customer activity,
    revenue linkage, and identifying inactive customers.*/
SELECT *
FROM orders;

SELECT *
FROM customers;

SELECT
    c.name,
    o.amount
FROM customers c
INNER JOIN orders o
    ON c.id = o.customer_id;

SELECT *
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id;

SELECT *
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
WHERE customer_id IS NULL;

SELECT
    customers.name,
    orders.order_id,
    orders.amount
FROM customers
INNER JOIN orders
    ON customers.id = orders.customer_id;

SELECT
    c.name,
    c.id
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
WHERE o.order_id IS NULL;
