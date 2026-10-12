USE food_delivery_analysis;
/*What are we checking?
- Expected row counts in all six tables.
- Missing customer, restaurant, or delivery-partner references.
- Invalid order amounts, discounts, or delivery times.
- Completed orders with missing delivery details.
- Whether order-item totals match the recorded order amount.*/

-- Row counts
SELECT 'customers' table_name, COUNT(*) row_count FROM customers
UNION ALL SELECT 'restaurants',COUNT(*) FROM restaurants
UNION ALL SELECT 'delivery_partners',COUNT(*) FROM delivery_partners
UNION ALL SELECT 'orders',COUNT(*) FROM orders
UNION ALL SELECT 'order_items',COUNT(*) FROM order_items
UNION ALL SELECT 'payments',COUNT(*) FROM payments;

-- Foreign-key orphan checks: each should return zero.
SELECT COUNT(*) orphan_customer_orders FROM orders o LEFT JOIN customers c ON c.customer_id=o.customer_id WHERE c.customer_id IS NULL;
SELECT COUNT(*) orphan_restaurant_orders FROM orders o LEFT JOIN restaurants r ON r.restaurant_id=o.restaurant_id WHERE r.restaurant_id IS NULL;
SELECT COUNT(*) orphan_partner_orders FROM orders o LEFT JOIN delivery_partners d ON d.delivery_partner_id=o.delivery_partner_id WHERE o.delivery_partner_id IS NOT NULL AND d.delivery_partner_id IS NULL;
SELECT COUNT(*) orphan_items FROM order_items i LEFT JOIN orders o ON o.order_id=i.order_id WHERE o.order_id IS NULL;
SELECT COUNT(*) orphan_payments FROM payments p LEFT JOIN orders o ON o.order_id=p.order_id WHERE o.order_id IS NULL;

-- Invalid business values: each should return zero.
SELECT COUNT(*) invalid_order_amounts FROM orders WHERE order_amount<0 OR delivery_fee<0 OR discount_amount<0 OR discount_amount>order_amount;
SELECT COUNT(*) invalid_item_values FROM order_items WHERE quantity<=0 OR item_price<0;
SELECT COUNT(*) invalid_payment_values FROM payments WHERE payment_amount<0;
SELECT COUNT(*) completed_missing_delivery FROM orders WHERE order_status='Completed' AND (delivery_partner_id IS NULL OR delivery_time_minutes IS NULL);

-- Item subtotal reconciliation: should return zero rows.
SELECT o.order_id, o.order_amount, SUM(i.quantity*i.item_price) item_subtotal
FROM orders o JOIN order_items i ON i.order_id=o.order_id
GROUP BY o.order_id,o.order_amount
HAVING ABS(o.order_amount-SUM(i.quantity*i.item_price))>0.01;

-- Distributions for review
SELECT order_status, COUNT(*) order_count FROM orders GROUP BY order_status;
SELECT payment_status, COUNT(*) payment_attempts FROM payments GROUP BY payment_status;
