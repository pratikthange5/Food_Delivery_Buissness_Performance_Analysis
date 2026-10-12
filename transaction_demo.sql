-- Isolated transaction demonstration; does not alter analytical tables.
USE food_delivery_analysis;
CREATE TABLE IF NOT EXISTS transaction_demo (demo_id INT PRIMARY KEY,note VARCHAR(100) NOT NULL) ENGINE=InnoDB;

START TRANSACTION;
INSERT INTO transaction_demo(demo_id,note) VALUES(1,'Temporary row for ROLLBACK demonstration');
SELECT * FROM transaction_demo WHERE demo_id=1;
ROLLBACK;
SELECT * FROM transaction_demo WHERE demo_id=1; -- expected: no rows

-- Optional COMMIT demo (uncomment to run):
-- START TRANSACTION;
-- INSERT INTO transaction_demo(demo_id,note) VALUES(2,'Committed demonstration row');
-- COMMIT;
-- SELECT * FROM transaction_demo WHERE demo_id=2;
-- DELETE FROM transaction_demo WHERE demo_id=2;

-- ACID: Atomicity (all or nothing), Consistency (valid constraints),
-- Isolation (concurrent transactions separated by isolation rules),
-- Durability (committed changes persist). Depends on InnoDB/configuration.
