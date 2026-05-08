/*
==================================================
File: aggregation_queries.sql
Purpose:
    This file contains SQL queries focused on
    data aggregation and summarization techniques
    using GROUP BY, HAVING, and aggregate functions.

Concepts Covered:
    - GROUP BY
    - HAVING clause
    - COUNT, SUM, AVG
    - Data summarization
    - Duplicate detection
    - Business-level aggregations

==================================================
*/


SELECT
    COUNT(o.order_id),
    o.customer_id
FROM orders o
GROUP BY o.customer_id;

/* Customers whose total order > 500 */

SELECT
    COUNT(*) AS total_order,
    c.id AS customer_id,
    SUM(o.amount) AS total_amount,
    c.name AS customer_name
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.id
GROUP BY c.id, c.name
HAVING SUM(o.amount) > 500;

/* Find duplicate customers (if any) */

SELECT
    COUNT(*),
    id,
    name
FROM customers
GROUP BY id, name
HAVING COUNT(*) > 1;

/* Countries with multiple customers */

SELECT
    COUNT(*),
    country
FROM customers
GROUP BY country
HAVING COUNT(id) > 1;

/* Get total amount per customer */

SELECT
    COALESCE(SUM(orders.amount), 0),
    customers.name
FROM customers
LEFT JOIN orders
    ON orders.customer_id = customers.id
GROUP BY customers.name;
