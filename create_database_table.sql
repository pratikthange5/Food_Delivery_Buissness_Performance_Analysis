CREATE DATABASE IF NOT EXISTS food_delivery_analysis;
USE food_delivery_analysis;
CREATE TABLE IF NOT EXISTS customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  city VARCHAR(60) NOT NULL,
  registration_date DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS restaurants (
  restaurant_id INT PRIMARY KEY,
  restaurant_name VARCHAR(120) NOT NULL,
  city VARCHAR(60) NOT NULL,
  cuisine_type VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS delivery_partners (
  delivery_partner_id INT PRIMARY KEY,
  partner_name VARCHAR(100) NOT NULL,
  city VARCHAR(60) NOT NULL,
  joining_date DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
  order_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  restaurant_id INT NOT NULL,
  delivery_partner_id INT NULL,
  order_date DATETIME NOT NULL,
  order_status ENUM('Completed','Cancelled','Pending') NOT NULL,
  order_amount DECIMAL(10,2) NOT NULL,
  delivery_fee DECIMAL(7,2) NOT NULL DEFAULT 0.00,
  discount_amount DECIMAL(7,2) NOT NULL DEFAULT 0.00,
  delivery_time_minutes SMALLINT NULL,
  CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT fk_orders_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
  CONSTRAINT fk_orders_partner FOREIGN KEY (delivery_partner_id) REFERENCES delivery_partners(delivery_partner_id),
  CONSTRAINT chk_order_amount CHECK (order_amount >= 0),
  CONSTRAINT chk_delivery_fee CHECK (delivery_fee >= 0),
  CONSTRAINT chk_discount_amount CHECK (discount_amount >= 0 AND discount_amount <= order_amount),
  CONSTRAINT chk_delivery_time CHECK (delivery_time_minutes IS NULL OR delivery_time_minutes > 0),
  CONSTRAINT chk_completed_delivery CHECK (order_status <> 'Completed' OR
    (delivery_partner_id IS NOT NULL AND delivery_time_minutes IS NOT NULL))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS order_items (
  order_item_id INT PRIMARY KEY,
  order_id INT NOT NULL,
  item_name VARCHAR(100) NOT NULL,
  quantity SMALLINT NOT NULL,
  item_price DECIMAL(8,2) NOT NULL,
  CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT chk_item_quantity CHECK (quantity > 0),
  CONSTRAINT chk_item_price CHECK (item_price >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS payments (
  payment_id INT PRIMARY KEY,
  order_id INT NOT NULL,
  payment_method ENUM('UPI','Card','Cash','Wallet','Net Banking') NOT NULL,
  payment_amount DECIMAL(10,2) NOT NULL,
  payment_status ENUM('SUCCESS','FAILED','PENDING') NOT NULL,
  payment_date DATETIME NULL,
  CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT chk_payment_amount CHECK (payment_amount >= 0)
) ENGINE=InnoDB;

-- One order can have multiple payment attempts. Each attempt has its own payment_id.
