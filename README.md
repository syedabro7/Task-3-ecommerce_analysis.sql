# Task 3: SQL for Data Analysis 🗄️

## 📌 Objective
Use SQL queries to extract and analyze data from an Ecommerce database using MySQL.

---

## 🛠️ Tools Used
- MySQL 8.0
- MySQL Command Line Client

---

## 🗂️ Dataset
Custom Ecommerce SQL Database built from scratch with 4 tables:

| Table | Description |
|---|---|
| `customers` | Customer details — name, email, city, join date |
| `products` | Product catalog — name, category, price |
| `orders` | Order records — customer, date, status |
| `order_items` | Line items per order — product, quantity, price |

**Sample Data:** 10 customers, 10 products, 14 orders, 23 order items across cities like Hyderabad, Mumbai, Delhi, Bangalore.

---

## 📁 Files
| File | Description |
|---|---|
| `ecommerce_analysis.sql` | All SQL queries — schema, data, analysis |
| `output.txt` | Full query output results from MySQL CLI |

---

## ✅ Concepts Covered

### 1. SELECT, WHERE, ORDER BY, GROUP BY
- Filter customers by city
- Sort orders by date
- Group revenue by category

### 2. JOINs
- **INNER JOIN** — customers who placed orders
- **LEFT JOIN** — all customers including those with no orders
- **RIGHT JOIN** — all orders with customer details
- **Multi-table JOIN** — full order details across all 4 tables

### 3. Aggregate Functions
- `SUM()` — total revenue per category
- `AVG()` — average order value per customer
- `COUNT()` — number of orders per city

### 4. HAVING Clause
- Filter categories with revenue above ₹50,000
- Find customers with more than 1 order

### 5. Subqueries
- Customers who spent more than average
- Products never ordered (NOT IN subquery)
- Most expensive product per category (correlated subquery)

### 6. Views
- `vw_customer_summary` — total orders and revenue per customer
- `vw_product_performance` — units sold and revenue per product
- `vw_monthly_revenue` — month-wise revenue trend

### 7. NULL Handling
- `COALESCE()` — replace NULL city with 'Unknown'
- `IFNULL()` — show 0 for customers with no spending
- `IS NULL` — find customers with no orders

### 8. Indexes for Optimization
- Indexes on foreign keys (customer_id, order_id, product_id)
- Indexes on filter columns (status, order_date, city, category)
- `EXPLAIN` used to verify index usage

---

## 📊 Key Insights from Analysis

- 🏆 **Top Customer:** Aarav Sharma — ₹92,298 total spent
- 🛍️ **Top Category:** Electronics — ₹1,82,998 revenue
- 📦 **Best Product:** Laptop Pro 15 — ₹1,50,000 revenue
- 🏙️ **Top City:** Hyderabad — ₹98,694 city revenue
- 💰 **ARPU (Avg Revenue Per User):** Calculated using SUM/COUNT

---

## 💡 Interview Questions Answered

1. **WHERE vs HAVING** — WHERE filters rows before grouping; HAVING filters after aggregation
2. **Types of Joins** — INNER, LEFT, RIGHT, multi-table
3. **Average Revenue Per User** — `SUM(revenue) / COUNT(DISTINCT customer_id)`
4. **Subqueries** — Queries nested inside another query (scalar, derived, correlated)
5. **Query Optimization** — Indexes on JOIN keys and WHERE columns + EXPLAIN
6. **Views** — Virtual tables based on saved SELECT queries
7. **NULL Handling** — COALESCE, IFNULL, IS NULL, IS NOT NULL

---

## 🚀 How to Run

```bash
# Option 1: MySQL CLI
mysql -u root -p
source C:/path/to/ecommerce_analysis.sql

# Option 2: MySQL Workbench
# File → Open SQL Script → Run (Ctrl+Shift+Enter)
```

---

*Internship Task 3 — Data Analyst Internship | Elevate Labs*
