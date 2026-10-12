USE food_delivery_analysis;

CREATE VIEW vw_monthly_completed_order_value AS
SELECT DATE_FORMAT(order_date,'%Y-%m') order_month,COUNT(*) completed_orders,
 ROUND(SUM(order_amount-discount_amount+delivery_fee),2) completed_order_value,
 ROUND(AVG(order_amount-discount_amount+delivery_fee),2) avg_completed_order_value
FROM orders WHERE order_status='Completed' GROUP BY DATE_FORMAT(order_date,'%Y-%m');

SELECT * FROM vw_monthly_completed_order_value ORDER BY order_month;

-- Primary keys are indexed automatically. InnoDB requires suitable indexes for FK columns.
-- These additional indexes are examples; use EXPLAIN and representative data to evaluate them.
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_orders_status_date ON orders(order_status,order_date);
CREATE INDEX idx_orders_customer_date ON orders(customer_id,order_date);
CREATE INDEX idx_items_order_id ON order_items(order_id);
CREATE INDEX idx_payments_order_status ON payments(order_id,payment_status);

EXPLAIN SELECT order_id,order_date,order_status FROM orders
WHERE order_status='Completed' AND order_date>='2026-04-01' AND order_date<'2026-05-01';
