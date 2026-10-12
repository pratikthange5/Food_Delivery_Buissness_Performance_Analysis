# Food Delivery Business Performance Analysis Using SQL

**Created by:** Pratik Thange

## Project Overview
A SQL portfolio project that analyzes food delivery operations, customer activity, restaurant performance, delivery duration, and payment status using a relational database and manually inserted sample data.

## Technologies
- MySQL 8.0+
- MySQL Workbench
- SQL

## Database Schema

| Table | Records |
|---|---:|
| Customers | 10 |
| Restaurants | 5 |
| Delivery Partners | 5 |
| Orders | 12 |
| Order Items | 24 |
| Payments | 14 |

## Key Business Analyses
- Order status and completion rates
- Revenue and average order value
- Customer ordering activity
- Restaurant performance
- Delivery duration and late deliveries
- Payment status and successful payment amounts

## SQL Concepts Covered
- Filtering, sorting, and `CASE` statements
- Aggregate functions, `GROUP BY`, and `HAVING`
- Joins and subqueries
- CTEs and window functions
- Date functions and NULL handling
- Views, indexes, and `EXPLAIN`
- Transactions and stored procedures

## Project Files and Execution Order

Run the following SQL files in MySQL Workbench in this order:

1. `create_database_tables.sql`
2. `data_insertion.sql`
3. `validate_data.sql`
4. `business_analysis.sql`
5. `views_indexes.sql`
6. `transaction_demo.sql`
7. `stored_procedure.sql`

## Key Contributions
- Designed a relational database with six interconnected tables.
- Manually inserted sample records to represent food delivery operations.
- Developed SQL queries to analyze orders, revenue, customers, restaurants, delivery performance, and payments.
- Implemented data validation, views, indexes, transaction demonstrations, and a stored procedure.

## Limitations
The project uses a small sample dataset for learning and demonstration. Profit and platform net revenue cannot be calculated without cost and commission data.