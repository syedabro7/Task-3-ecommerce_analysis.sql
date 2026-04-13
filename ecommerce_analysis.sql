-- ============================================================
--  TASK 3: SQL FOR DATA ANALYSIS
--  Tool   : MySQL
--  Dataset: Ecommerce_SQL_Database (built from scratch below)
-- ============================================================


-- ─────────────────────────────────────────
-- SECTION 1 : DATABASE & TABLE SETUP
-- ─────────────────────────────────────────

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE,
    city          VARCHAR(100),
    joined_date   DATE
);

-- Products table
CREATE TABLE IF NOT EXISTS products (
    product_id    INT PRIMARY KEY AUTO_INCREMENT,
    product_name  VARCHAR(150) NOT NULL,
    category      VARCHAR(100),
    price         DECIMAL(10,2) NOT NULL
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT,
    order_date    DATE,
    status        VARCHAR(50),           -- 'completed', 'pending', 'cancelled'
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items table  (one order can have many items)
CREATE TABLE IF NOT EXISTS order_items (
    item_id       INT PRIMARY KEY AUTO_INCREMENT,
    order_id      INT,
    product_id    INT,
    quantity      INT,
    unit_price    DECIMAL(10,2),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- ─────────────────────────────────────────
-- SECTION 2 : SAMPLE DATA
-- ─────────────────────────────────────────

INSERT INTO customers (name, email, city, joined_date) VALUES
('Aarav Sharma',   'aarav@email.com',   'Hyderabad', '2022-01-15'),
('Priya Nair',     'priya@email.com',   'Mumbai',    '2022-03-22'),
('Rohan Mehta',    'rohan@email.com',   'Delhi',     '2022-05-10'),
('Sneha Reddy',    'sneha@email.com',   'Hyderabad', '2022-07-08'),
('Karan Patel',    'karan@email.com',   'Bangalore', '2023-01-19'),
('Divya Iyer',     'divya@email.com',   'Chennai',   '2023-03-05'),
('Vikram Singh',   'vikram@email.com',  'Pune',      '2023-06-11'),
('Ananya Joshi',   'ananya@email.com',  'Kolkata',   '2023-09-30'),
('Nikhil Gupta',   'nikhil@email.com',  'Jaipur',    '2024-01-02'),
('Meera Pillai',   'meera@email.com',   'Kochi',     '2024-02-14');

INSERT INTO products (product_name, category, price) VALUES
('Laptop Pro 15',       'Electronics',   75000.00),
('Wireless Headphones', 'Electronics',    3500.00),
('Running Shoes',       'Footwear',       4200.00),
('Yoga Mat',            'Fitness',         899.00),
('Smartwatch X1',       'Electronics',   12999.00),
('Formal Shirt',        'Clothing',       1299.00),
('Backpack 40L',        'Accessories',    2499.00),
('Coffee Maker',        'Appliances',     5999.00),
('Desk Lamp LED',       'Appliances',      799.00),
('Novel: The Alchemist','Books',           350.00);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1,  '2024-01-05', 'completed'),
(2,  '2024-01-10', 'completed'),
(3,  '2024-01-15', 'pending'),
(4,  '2024-02-01', 'completed'),
(5,  '2024-02-14', 'completed'),
(6,  '2024-02-20', 'cancelled'),
(7,  '2024-03-01', 'completed'),
(8,  '2024-03-10', 'pending'),
(1,  '2024-03-15', 'completed'),  -- customer 1 orders again
(2,  '2024-03-20', 'completed'),  -- customer 2 orders again
(9,  '2024-04-01', 'completed'),
(10, '2024-04-05', 'cancelled'),
(3,  '2024-04-10', 'completed'),
(5,  '2024-04-18', 'completed');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,  1, 1, 75000.00),   -- Laptop
(1,  2, 1,  3500.00),   -- Headphones
(2,  3, 2,  4200.00),   -- Running Shoes x2
(2,  4, 1,   899.00),   -- Yoga Mat
(3,  5, 1, 12999.00),   -- Smartwatch
(4,  6, 3,  1299.00),   -- Formal Shirt x3
(4,  7, 1,  2499.00),   -- Backpack
(5,  8, 1,  5999.00),   -- Coffee Maker
(5,  9, 2,   799.00),   -- Desk Lamp x2
(6,  10,5,   350.00),   -- Books x5 (order was cancelled)
(7,  1, 1, 75000.00),   -- Laptop
(8,  2, 2,  3500.00),   -- Headphones x2
(9,  5, 1, 12999.00),   -- Smartwatch
(9,  9, 1,   799.00),   -- Desk Lamp
(10, 3, 1,  4200.00),   -- Running Shoes
(10, 6, 2,  1299.00),   -- Formal Shirt x2
(11, 7, 1,  2499.00),   -- Backpack
(11, 8, 1,  5999.00),   -- Coffee Maker
(12, 1, 1, 75000.00),   -- Laptop (cancelled)
(13, 2, 1,  3500.00),   -- Headphones
(13, 4, 2,   899.00),   -- Yoga Mat x2
(14, 5, 1, 12999.00),   -- Smartwatch
(14, 10,3,   350.00);   -- Books x3


-- ─────────────────────────────────────────
-- SECTION 3 : BASIC SELECT, WHERE, ORDER BY
-- ─────────────────────────────────────────

-- Q1: All customers from Hyderabad
SELECT *
FROM customers
WHERE city = 'Hyderabad'
ORDER BY name ASC;

-- Q2: All completed orders sorted by date (most recent first)
SELECT order_id, customer_id, order_date, status
FROM orders
WHERE status = 'completed'
ORDER BY order_date DESC;

-- Q3: Products under ₹5000 sorted by price ascending
SELECT product_name, category, price
FROM products
WHERE price < 5000
ORDER BY price ASC;


-- ─────────────────────────────────────────
-- SECTION 4 : GROUP BY + AGGREGATE FUNCTIONS
-- ─────────────────────────────────────────

-- Q4: Total revenue per product category (only completed orders)
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    COUNT(DISTINCT oi.order_id)      AS total_orders
FROM order_items oi
JOIN orders   o ON oi.order_id   = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Q5: Average order value per customer
SELECT
    c.customer_id,
    c.name,
    COUNT(DISTINCT o.order_id)                  AS total_orders,
    ROUND(AVG(oi.quantity * oi.unit_price), 2)  AS avg_order_value
FROM customers c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.name
ORDER BY avg_order_value DESC;

-- Q6: Number of orders per city
SELECT
    c.city,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_orders DESC;


-- ─────────────────────────────────────────
-- SECTION 5 : HAVING CLAUSE
-- (Interview Q1: WHERE vs HAVING)
-- WHERE filters rows BEFORE grouping
-- HAVING filters groups AFTER aggregation
-- ─────────────────────────────────────────

-- Q7: Categories with total revenue > ₹50,000
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
JOIN orders   o ON oi.order_id   = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'completed'         -- ← WHERE: filters rows first
GROUP BY p.category
HAVING total_revenue > 50000         -- ← HAVING: filters after grouping
ORDER BY total_revenue DESC;

-- Q8: Customers who placed more than 1 order
SELECT
    c.name,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING order_count > 1;


-- ─────────────────────────────────────────
-- SECTION 6 : JOINS
-- (Interview Q2: Types of Joins)
-- ─────────────────────────────────────────

-- INNER JOIN: Only customers who have placed at least one order
SELECT
    c.name,
    c.city,
    o.order_id,
    o.order_date,
    o.status
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date;

-- LEFT JOIN: All customers including those with NO orders
SELECT
    c.name,
    c.city,
    o.order_id,
    o.status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.name;

-- RIGHT JOIN: All orders including those whose customer data might be missing
SELECT
    c.name,
    o.order_id,
    o.order_date,
    o.status
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date;

-- Multi-table JOIN: Full order details (customer + order + items + product)
SELECT
    c.name                             AS customer_name,
    c.city,
    o.order_id,
    o.order_date,
    o.status,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price)      AS line_total
FROM customers   c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN products    p  ON oi.product_id = p.product_id
ORDER BY o.order_date, c.name;


-- ─────────────────────────────────────────
-- SECTION 7 : AVERAGE REVENUE PER USER (ARPU)
-- (Interview Q3)
-- ARPU = Total Revenue / Total Unique Customers
-- ─────────────────────────────────────────

SELECT
    ROUND(
        SUM(oi.quantity * oi.unit_price) /
        COUNT(DISTINCT o.customer_id),
    2) AS avg_revenue_per_user
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed';

-- ARPU broken down per customer (revenue each customer generated)
SELECT
    c.customer_id,
    c.name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
FROM customers   c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;


-- ─────────────────────────────────────────
-- SECTION 8 : SUBQUERIES
-- (Interview Q4)
-- A query nested inside another query
-- ─────────────────────────────────────────

-- Q9: Customers who spent MORE than the average customer spending
SELECT
    c.name,
    total_spent
FROM (
    -- Inner subquery: calculate each customer's total spend
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.customer_id
) AS customer_spending
JOIN customers c ON c.customer_id = customer_spending.customer_id
WHERE total_spent > (
    -- Scalar subquery: overall average spend
    SELECT AVG(spend)
    FROM (
        SELECT SUM(oi2.quantity * oi2.unit_price) AS spend
        FROM orders o2
        JOIN order_items oi2 ON o2.order_id = oi2.order_id
        WHERE o2.status = 'completed'
        GROUP BY o2.customer_id
    ) AS avg_calc
)
ORDER BY total_spent DESC;

-- Q10: Products that have NEVER been ordered
SELECT product_name, category, price
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id FROM order_items
);

-- Q11: Most expensive product in each category (correlated subquery)
SELECT product_name, category, price
FROM products p1
WHERE price = (
    SELECT MAX(price)
    FROM products p2
    WHERE p2.category = p1.category
)
ORDER BY category;


-- ─────────────────────────────────────────
-- SECTION 9 : VIEWS
-- (Interview Q6)
-- A saved virtual table based on a SELECT query
-- ─────────────────────────────────────────

-- View 1: Customer order summary
CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT
    c.customer_id,
    c.name                                          AS customer_name,
    c.city,
    COUNT(DISTINCT o.order_id)                      AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)      AS total_revenue,
    ROUND(AVG(oi.quantity * oi.unit_price), 2)      AS avg_order_value
FROM customers   c
LEFT JOIN orders      o  ON c.customer_id = o.customer_id AND o.status = 'completed'
LEFT JOIN order_items oi ON o.order_id    = oi.order_id
GROUP BY c.customer_id, c.name, c.city;

-- View 2: Product performance view
CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.price                                         AS list_price,
    COALESCE(SUM(oi.quantity), 0)                   AS units_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0)   AS total_revenue
FROM products    p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders      o  ON oi.order_id  = o.order_id AND o.status = 'completed'
GROUP BY p.product_id, p.product_name, p.category, p.price;

-- View 3: Monthly revenue trend
CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m')          AS month,
    COUNT(DISTINCT o.order_id)                  AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS monthly_revenue
FROM orders      o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- Query the views
SELECT * FROM vw_customer_summary     ORDER BY total_revenue DESC;
SELECT * FROM vw_product_performance  ORDER BY total_revenue DESC;
SELECT * FROM vw_monthly_revenue;


-- ─────────────────────────────────────────
-- SECTION 10 : NULL HANDLING
-- (Interview Q7)
-- ─────────────────────────────────────────

-- COALESCE: Return first non-null value
SELECT
    customer_id,
    name,
    COALESCE(city, 'Unknown City') AS city
FROM customers;

-- IFNULL: Replace NULL with a default
SELECT
    c.name,
    IFNULL(SUM(oi.quantity * oi.unit_price), 0) AS total_spent
FROM customers   c
LEFT JOIN orders      o  ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id    = oi.order_id
GROUP BY c.customer_id, c.name;

-- IS NULL: Find customers with no orders
SELECT c.name, c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- IS NOT NULL: Orders that have a valid date
SELECT order_id, order_date, status
FROM orders
WHERE order_date IS NOT NULL;


-- ─────────────────────────────────────────
-- SECTION 11 : INDEXES FOR OPTIMIZATION
-- (Interview Q5)
-- ─────────────────────────────────────────

-- Index on foreign keys (speeds up JOINs)
CREATE INDEX IF NOT EXISTS idx_orders_customer   ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_items_order       ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_items_product     ON order_items(product_id);

-- Index on frequently filtered columns
CREATE INDEX IF NOT EXISTS idx_orders_status     ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_date       ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_customers_city    ON customers(city);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);

-- EXPLAIN: See query execution plan to verify index usage
EXPLAIN
SELECT c.name, SUM(oi.quantity * oi.unit_price) AS revenue
FROM customers   c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.name;


-- ─────────────────────────────────────────
-- SECTION 12 : BONUS ANALYSIS QUERIES
-- ─────────────────────────────────────────

-- Top 3 best-selling products by revenue
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity)                    AS units_sold,
    SUM(oi.quantity * oi.unit_price)    AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders   o ON oi.order_id   = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 3;

-- Cancellation rate per customer
SELECT
    c.name,
    COUNT(o.order_id)                                              AS total_orders,
    SUM(CASE WHEN o.status = 'cancelled' THEN 1 ELSE 0 END)       AS cancelled_orders,
    ROUND(
        SUM(CASE WHEN o.status = 'cancelled' THEN 1 ELSE 0 END) * 100.0
        / COUNT(o.order_id),
    1)                                                             AS cancellation_rate_pct
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY cancellation_rate_pct DESC;

-- Revenue by city
SELECT
    c.city,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS city_revenue,
    COUNT(DISTINCT c.customer_id)               AS customers
FROM customers   c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
WHERE o.status = 'completed'
GROUP BY c.city
ORDER BY city_revenue DESC;

-- ============================================================
-- END OF FILE
-- ============================================================
