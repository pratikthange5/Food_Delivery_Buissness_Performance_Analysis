USE food_delivery_analysis;
DROP PROCEDURE IF EXISTS sp_monthly_order_report;
DELIMITER //
CREATE PROCEDURE sp_monthly_order_report(IN p_start_date DATE, IN p_end_date DATE)
BEGIN
  SELECT DATE_FORMAT(order_date,'%Y-%m') order_month,COUNT(*) completed_orders,
         ROUND(SUM(order_amount-discount_amount+delivery_fee),2) completed_order_value
  FROM orders
  WHERE order_status='Completed'
    AND order_date>=p_start_date
    AND order_date<DATE_ADD(p_end_date,INTERVAL 1 DAY)
  GROUP BY DATE_FORMAT(order_date,'%Y-%m') ORDER BY order_month;
END //
DELIMITER ;

CALL sp_monthly_order_report('2026-01-01','2026-08-31');
