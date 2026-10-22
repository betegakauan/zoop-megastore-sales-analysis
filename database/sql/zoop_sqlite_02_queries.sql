-- 1. Top 5 products by revenue
SELECT
    product_id,
    product,
    category,
    SUM(quantity)                        AS units_sold,
    COUNT(*)                             AS number_of_sales,
    ROUND(SUM(sale_value * quantity), 2) AS revenue
FROM sales
GROUP BY product_id, product, category
ORDER BY revenue DESC
LIMIT 5;

-- 2. Top 5 customers by total spend
SELECT
    c.customer_id,
    c.customer_name,
    c.state,
    CASE WHEN c.subscription_plan = 'Yes' THEN 'ZOOP Prime' ELSE 'Non-subscriber' END AS plan,
    COUNT(s.sale_id)                         AS number_of_purchases,
    ROUND(SUM(s.sale_value * s.quantity), 2) AS total_spent
FROM customers AS c
INNER JOIN sales AS s ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.state, c.subscription_plan
ORDER BY total_spent DESC
LIMIT 5;

-- 3. Average revenue per customer: ZOOP Prime vs non-subscribers
SELECT
    CASE WHEN c.subscription_plan = 'Yes' THEN 'ZOOP Prime' ELSE 'Non-subscriber' END AS plan,
    COUNT(*)                     AS buying_customers,
    ROUND(SUM(t.revenue), 2)     AS total_revenue,
    ROUND(AVG(t.revenue), 2)     AS avg_revenue_per_customer
FROM customers AS c
INNER JOIN (
    SELECT customer_id, SUM(sale_value * quantity) AS revenue
    FROM sales
    GROUP BY customer_id
) AS t ON t.customer_id = c.customer_id
GROUP BY c.subscription_plan
ORDER BY avg_revenue_per_customer DESC;
