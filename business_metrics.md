# Business Metric Definitions

- **Total orders:** all rows in `orders`, irrespective of status.
- **Completed/cancelled/pending orders:** counts filtered by `order_status`.
- **Completion rate:** completed orders / all orders × 100.
- **Cancellation rate:** cancelled orders / all orders × 100.
- **Completed order value:** sum of subtotal minus discount plus delivery fee for completed orders.
- **Average completed order value:** completed order value divided by completed order count.
- **Recorded payment amount:** sum of payment attempt amounts, regardless of outcome; not revenue.
- **Successful payment amount:** sum of attempts marked `SUCCESS`; not necessarily identical to completed order value.
- **Repeat customer:** customer with at least two orders, any status unless explicitly filtered.
- **Average delivery time:** average duration for completed orders.
- **Late delivery:** strictly more than 45 minutes among completed orders.
- **Popular item:** rank by `SUM(quantity)`; ties can occur.
- **Restaurant/cuisine performance:** completed order volume and/or completed order value.
- **Profit:** not calculable without cost/commission data.

**Double-counting warning:** an order with multiple item rows and multiple payment attempts can multiply joined rows. Aggregate detail tables to one row per order before joining them to `orders` for financial summaries.
