-- Q01 Overall order summary and rates
SELECT COUNT(*) total_orders,
 SUM(order_status='Completed') completed_orders,
 SUM(order_status='Cancelled') cancelled_orders,
 SUM(order_status='Pending') pending_orders,
 ROUND(100.0*SUM(order_status='Completed')/COUNT(*),2) completion_rate_pct,
 ROUND(100.0*SUM(order_status='Cancelled')/COUNT(*),2) cancellation_rate_pct
FROM orders;

-- Q02 Status distribution
SELECT order_status, COUNT(*) order_count,
 ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM orders),2) share_pct
FROM orders GROUP BY order_status ORDER BY order_count DESC;

-- Q03 Monthly order volume
SELECT DATE_FORMAT(order_date,'%Y-%m') order_month, COUNT(*) total_orders
FROM orders GROUP BY DATE_FORMAT(order_date,'%Y-%m') ORDER BY order_month;

-- Q04 Monthly completed order value: subtotal - discount + delivery fee
SELECT DATE_FORMAT(order_date,'%Y-%m') order_month, COUNT(*) completed_orders,
 ROUND(SUM(order_amount-discount_amount+delivery_fee),2) completed_order_value
FROM orders WHERE order_status='Completed'
GROUP BY DATE_FORMAT(order_date,'%Y-%m') ORDER BY order_month;

-- Q05 Average completed order value per completed order
SELECT ROUND(AVG(order_amount-discount_amount+delivery_fee),2) avg_completed_order_value
FROM orders WHERE order_status='Completed';

-- Q06 Most active customers
SELECT c.customer_id,c.customer_name,COUNT(*) total_orders
FROM customers c JOIN orders o ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name ORDER BY total_orders DESC,c.customer_id LIMIT 10;

-- Q07 Repeat customers (at least two orders of any status)
WITH customer_counts AS (SELECT customer_id,COUNT(*) order_count FROM orders GROUP BY customer_id)
SELECT COUNT(*) repeat_customers FROM customer_counts WHERE order_count>=2;

-- Q08 Top customers by completed order value
SELECT c.customer_id,c.customer_name,
 ROUND(SUM(o.order_amount-o.discount_amount+o.delivery_fee),2) completed_order_value
FROM customers c JOIN orders o ON o.customer_id=c.customer_id
WHERE o.order_status='Completed' GROUP BY c.customer_id,c.customer_name
ORDER BY completed_order_value DESC LIMIT 10;

-- Q09 Top restaurants by completed order volume
SELECT r.restaurant_id,r.restaurant_name,COUNT(*) completed_orders
FROM restaurants r JOIN orders o ON o.restaurant_id=r.restaurant_id
WHERE o.order_status='Completed' GROUP BY r.restaurant_id,r.restaurant_name
ORDER BY completed_orders DESC,r.restaurant_id LIMIT 10;

-- Q10 Cuisine performance
SELECT r.cuisine_type,COUNT(*) completed_orders,
 ROUND(SUM(o.order_amount-o.discount_amount+o.delivery_fee),2) completed_order_value
FROM restaurants r JOIN orders o ON o.restaurant_id=r.restaurant_id
WHERE o.order_status='Completed' GROUP BY r.cuisine_type ORDER BY completed_order_value DESC;

-- Q11 Popular food items by units sold
SELECT item_name,SUM(quantity) units_sold,COUNT(DISTINCT order_id) orders_containing_item
FROM order_items GROUP BY item_name ORDER BY units_sold DESC,item_name LIMIT 10;

-- Q12 Average, fastest and slowest completed delivery
SELECT ROUND(AVG(delivery_time_minutes),2) avg_delivery_minutes,
 MIN(delivery_time_minutes) fastest_minutes,MAX(delivery_time_minutes) slowest_minutes
FROM orders WHERE order_status='Completed';

-- Q13 Late deliveries: strictly more than 45 minutes among completed orders
SELECT COUNT(*) completed_orders,SUM(delivery_time_minutes>45) late_orders,
 ROUND(100.0*SUM(delivery_time_minutes>45)/COUNT(*),2) late_delivery_rate_pct
FROM orders WHERE order_status='Completed';

-- Q14 Delivery partner comparison; partners with zero completed orders remain visible
SELECT d.delivery_partner_id,d.partner_name,COUNT(o.order_id) completed_orders,
 ROUND(AVG(o.delivery_time_minutes),2) avg_delivery_minutes,
 SUM(o.delivery_time_minutes>45) late_orders
FROM delivery_partners d LEFT JOIN orders o
 ON o.delivery_partner_id=d.delivery_partner_id AND o.order_status='Completed'
GROUP BY d.delivery_partner_id,d.partner_name ORDER BY completed_orders DESC,d.delivery_partner_id;

-- Q15 Payment methods and success attempts
SELECT payment_method,COUNT(*) payment_attempts,SUM(payment_status='SUCCESS') successful_attempts
FROM payments GROUP BY payment_method ORDER BY payment_attempts DESC;

-- Q16 Payment attempts and successful amounts by status
SELECT payment_status,COUNT(*) attempts,ROUND(SUM(payment_amount),2) recorded_attempt_amount,
 ROUND(SUM(CASE WHEN payment_status='SUCCESS' THEN payment_amount ELSE 0 END),2) successful_attempt_amount
FROM payments GROUP BY payment_status ORDER BY attempts DESC;

-- Q17 Customers with no orders
SELECT c.customer_id,c.customer_name FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id=c.customer_id)
ORDER BY c.customer_id;

-- Q18 Restaurants with no completed orders
SELECT r.restaurant_id,r.restaurant_name FROM restaurants r
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.restaurant_id=r.restaurant_id AND o.order_status='Completed')
ORDER BY r.restaurant_id;

-- Q19 Orders containing more than two item lines
SELECT o.order_id,COUNT(*) item_lines,SUM(i.quantity) total_units
FROM orders o JOIN order_items i ON i.order_id=o.order_id
GROUP BY o.order_id HAVING COUNT(*)>2 ORDER BY o.order_id;

-- Q20 Month-over-month completed order value change
WITH monthly AS (
 SELECT DATE_FORMAT(order_date,'%Y-%m') order_month,
 SUM(order_amount-discount_amount+delivery_fee) completed_value
 FROM orders WHERE order_status='Completed' GROUP BY DATE_FORMAT(order_date,'%Y-%m')
), compared AS (
 SELECT order_month,completed_value,LAG(completed_value) OVER(ORDER BY order_month) previous_value FROM monthly
)
SELECT order_month,ROUND(completed_value,2) completed_order_value,ROUND(previous_value,2) previous_month_value,
 ROUND(completed_value-previous_value,2) change_amount,
 ROUND(100.0*(completed_value-previous_value)/NULLIF(previous_value,0),2) change_pct
FROM compared ORDER BY order_month;

-- Q21 Customer rankings by completed order value
WITH customer_value AS (
 SELECT c.customer_id,c.customer_name,SUM(o.order_amount-o.discount_amount+o.delivery_fee) completed_value
 FROM customers c JOIN orders o ON o.customer_id=c.customer_id
 WHERE o.order_status='Completed' GROUP BY c.customer_id,c.customer_name
)
SELECT customer_id,customer_name,ROUND(completed_value,2) completed_order_value,
 ROW_NUMBER() OVER(ORDER BY completed_value DESC,customer_id) row_num,
 RANK() OVER(ORDER BY completed_value DESC) customer_rank,
 DENSE_RANK() OVER(ORDER BY completed_value DESC) dense_rank_value
FROM customer_value ORDER BY completed_order_value DESC,customer_id LIMIT 20;

-- Q22 Restaurant rankings within city by completed order count
WITH restaurant_counts AS (
 SELECT r.restaurant_id,r.restaurant_name,r.city,COUNT(o.order_id) completed_orders
 FROM restaurants r LEFT JOIN orders o ON o.restaurant_id=r.restaurant_id AND o.order_status='Completed'
 GROUP BY r.restaurant_id,r.restaurant_name,r.city
)
SELECT restaurant_id,restaurant_name,city,completed_orders,
 DENSE_RANK() OVER(PARTITION BY city ORDER BY completed_orders DESC) city_rank
FROM restaurant_counts ORDER BY city,city_rank,restaurant_name;

-- Q23 Cumulative monthly completed order value
WITH monthly AS (
 SELECT DATE_FORMAT(order_date,'%Y-%m') order_month,
 SUM(order_amount-discount_amount+delivery_fee) completed_value
 FROM orders WHERE order_status='Completed' GROUP BY DATE_FORMAT(order_date,'%Y-%m')
)
SELECT order_month,ROUND(completed_value,2) monthly_value,
 ROUND(SUM(completed_value) OVER(ORDER BY order_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) running_total
FROM monthly ORDER BY order_month;

-- Q24 Customer base and customers without orders
SELECT COUNT(*) total_customers,SUM(x.customer_id IS NULL) customers_without_orders
FROM customers c LEFT JOIN (SELECT DISTINCT customer_id FROM orders) x ON x.customer_id=c.customer_id;

-- Q25 Order status vs payment summary. Aggregate payments to one row per order first.
WITH payment_summary AS (
 SELECT order_id,COUNT(*) payment_attempts,SUM(payment_status='SUCCESS') successful_attempts,
 SUM(CASE WHEN payment_status='SUCCESS' THEN payment_amount ELSE 0 END) successful_amount
 FROM payments GROUP BY order_id
)
SELECT o.order_status,COUNT(*) order_count,SUM(COALESCE(p.payment_attempts,0)) payment_attempts,
 SUM(COALESCE(p.successful_attempts,0)) successful_attempts,
 ROUND(SUM(COALESCE(p.successful_amount,0)),2) successful_payment_amount
FROM orders o LEFT JOIN payment_summary p ON p.order_id=o.order_id
