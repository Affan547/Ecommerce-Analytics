-- ===============================
-- E-Commerce SQL Analysis Project
-- ===============================

-- 1. Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- 2. Total Revenue
SELECT ROUND(SUM(payment_value),2) AS total_revenue
FROM order_payments;

-- 3. Monthly Revenue Trend
SELECT DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS month,
       ROUND(SUM(p.payment_value),2) AS revenue
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

-- 4. Top States by Orders
SELECT c.customer_state,
       COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC
LIMIT 10;

-- 5. Payment Distribution
SELECT payment_type,
       COUNT(*) AS count,
       ROUND(SUM(payment_value),2) AS total_value
FROM order_payments
GROUP BY payment_type;

-- 6. Top Categories by Revenue
SELECT ct.product_category_name_english,
       ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation ct 
ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY revenue DESC
LIMIT 10;

-- 7. Delivery Performance
SELECT 
    ROUND(AVG(delivery_delay_days),2) AS avg_delay,
    ROUND(AVG(on_time_delivery)*100,2) AS on_time_delivery_percentage
FROM orders;

-- 8. Repeat Customers
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT customer_unique_id
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY customer_unique_id
    HAVING COUNT(o.order_id) > 1
) AS repeat_table;