# Database Schema

Database: `food_delivery_analysis` (MySQL 8.0+).

- `customers` (1) to many `orders`
- `restaurants` (1) to many `orders`
- `delivery_partners` (1) to many `orders`; partner ID can be NULL when not assigned
- `orders` (1) to many `order_items`
- `orders` (1) to many `payments`; multiple attempts are permitted

`order_amount` is the food subtotal before discount and delivery fee. `discount_amount` is subtracted from subtotal; `delivery_fee` is added separately. Completed order value is `order_amount - discount_amount + delivery_fee`, for completed orders only. `item_price` is per-unit price and line value is `quantity * item_price`. Payment rows represent attempts; only `SUCCESS` attempts count toward successful payment amount. No cost, commission, tax, refund, or payout data exists, so profit and platform net revenue cannot be calculated.
