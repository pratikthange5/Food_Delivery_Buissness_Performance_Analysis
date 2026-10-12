INSERT INTO customers (customer_id, customer_name, city, registration_date) VALUES
(1,'Aarav Sharma','Pune','2025-11-12'),(2,'Priya Patil','Pune','2025-12-02'),
(3,'Rohan Deshmukh','Mumbai','2026-01-10'),(4,'Sneha Kulkarni','Pune','2026-01-18'),
(5,'Aditya Joshi','Nashik','2026-02-05'),(6,'Neha Shah','Mumbai','2026-02-21'),
(7,'Om Jadhav','Pimpri-Chinchwad','2026-03-03'),(8,'Isha Mehta','Pune','2026-03-15'),
(9,'Kunal Pawar','Nashik','2026-04-09'),(10,'Ananya Rao','Mumbai','2026-04-20');

INSERT INTO restaurants (restaurant_id, restaurant_name, city, cuisine_type) VALUES
(1,'Spice Route Kitchen','Pune','Indian'),(2,'Wok Express','Pune','Chinese'),
(3,'Green Bowl Cafe','Mumbai','Healthy'),(4,'Pizza Corner','Nashik','Italian'),
(5,'Dosa House','Pimpri-Chinchwad','South Indian');

INSERT INTO delivery_partners (delivery_partner_id, partner_name, city, joining_date) VALUES
(1,'Vikram More','Pune','2025-10-01'),(2,'Sahil Khan','Pune','2025-12-15'),
(3,'Meera Pawar','Mumbai','2026-01-05'),(4,'Rahul Shinde','Nashik','2026-02-11'),
(5,'Pooja Nair','Pimpri-Chinchwad','2026-03-01');

-- order_amount is the food subtotal before discounts and delivery fees.
INSERT INTO orders (order_id,customer_id,restaurant_id,delivery_partner_id,order_date,order_status,order_amount,delivery_fee,discount_amount,delivery_time_minutes) VALUES
(1001,1,1,1,'2026-01-05 12:15:00','Completed',300.00,30.00,20.00,32),
(1002,2,2,2,'2026-01-08 19:10:00','Completed',450.00,25.00,50.00,48),
(1003,3,3,3,'2026-01-12 13:05:00','Completed',280.00,35.00,0.00,27),
(1004,1,5,5,'2026-02-02 09:30:00','Completed',220.00,20.00,10.00,41),
(1005,4,1,1,'2026-02-10 20:00:00','Cancelled',520.00,30.00,40.00,NULL),
(1006,5,4,4,'2026-02-17 18:45:00','Completed',600.00,40.00,60.00,55),
(1007,6,3,3,'2026-03-04 12:25:00','Completed',350.00,30.00,25.00,38),
(1008,7,5,5,'2026-03-11 08:50:00','Pending',180.00,20.00,0.00,NULL),
(1009,8,2,2,'2026-04-06 19:20:00','Completed',400.00,25.00,30.00,46),
(1010,9,4,4,'2026-05-14 20:10:00','Completed',700.00,45.00,70.00,62),
(1011,10,1,1,'2026-06-18 13:40:00','Completed',320.00,30.00,20.00,35),
(1012,2,2,2,'2026-07-22 19:05:00','Completed',500.00,25.00,50.00,44);

-- Two item rows per order; quantity * item_price adds up to order_amount.
INSERT INTO order_items (order_item_id,order_id,item_name,quantity,item_price) VALUES
(1,1001,'Paneer Tikka',2,120.00),(2,1001,'Butter Naan',3,20.00),
(3,1002,'Veg Hakka Noodles',2,150.00),(4,1002,'Spring Rolls',3,50.00),
(5,1003,'Quinoa Salad',2,100.00),(6,1003,'Fresh Lime Juice',2,40.00),
(7,1004,'Masala Dosa',2,80.00),(8,1004,'Filter Coffee',2,30.00),
(9,1005,'Paneer Butter Masala',2,200.00),(10,1005,'Jeera Rice',2,60.00),
(11,1006,'Margherita Pizza',2,250.00),(12,1006,'Garlic Bread',2,50.00),
(13,1007,'Protein Bowl',2,140.00),(14,1007,'Fruit Smoothie',1,70.00),
(15,1008,'Idli Plate',2,60.00),(16,1008,'Medu Vada',2,30.00),
(17,1009,'Chilli Paneer',2,140.00),(18,1009,'Fried Rice',2,60.00),
(19,1010,'Farmhouse Pizza',2,300.00),(20,1010,'Pasta Alfredo',1,100.00),
(21,1011,'Veg Thali',2,120.00),(22,1011,'Gulab Jamun',2,40.00),
(23,1012,'Schezwan Noodles',2,180.00),(24,1012,'Manchurian',2,70.00);

-- Multiple attempts for orders 1002 and 1010 demonstrate failed then successful payment.
INSERT INTO payments (payment_id,order_id,payment_method,payment_amount,payment_status,payment_date) VALUES
(5001,1001,'UPI',310.00,'SUCCESS','2026-01-05 12:16:00'),
(5002,1002,'Card',425.00,'FAILED','2026-01-08 19:11:00'),
(5003,1002,'UPI',425.00,'SUCCESS','2026-01-08 19:13:00'),
(5004,1003,'Wallet',315.00,'SUCCESS','2026-01-12 13:06:00'),
(5005,1004,'Cash',230.00,'SUCCESS','2026-02-02 09:31:00'),
(5006,1005,'UPI',510.00,'FAILED','2026-02-10 20:01:00'),
(5007,1006,'Card',580.00,'SUCCESS','2026-02-17 18:46:00'),
(5008,1007,'UPI',355.00,'SUCCESS','2026-03-04 12:26:00'),
(5009,1008,'Wallet',200.00,'PENDING','2026-03-11 08:51:00'),
(5010,1009,'UPI',395.00,'SUCCESS','2026-04-06 19:21:00'),
(5011,1010,'Card',675.00,'FAILED','2026-05-14 20:11:00'),
(5012,1010,'Card',675.00,'SUCCESS','2026-05-14 20:13:00'),
(5013,1011,'Cash',330.00,'SUCCESS','2026-06-18 13:41:00'),
(5014,1012,'Net Banking',475.00,'SUCCESS','2026-07-22 19:06:00');

-- Expected row counts: customers 10, restaurants 5, delivery_partners 5,
-- orders 12, order_items 24, payments 14.
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'restaurants', COUNT(*) FROM restaurants
UNION ALL SELECT 'delivery_partners', COUNT(*) FROM delivery_partners
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments;
