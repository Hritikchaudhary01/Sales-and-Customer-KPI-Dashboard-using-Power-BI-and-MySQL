CREATE DATABASE IF NOT EXISTS sales_kpi_dashboard;
USE sales_kpi_dashboard;

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    unit_price DECIMAL(10,2),
    cost_price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    region VARCHAR(20),
    sales_rep VARCHAR(50),
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    sales_amount DECIMAL(12,2),
    discount DECIMAL(5,2),
    profit DECIMAL(12,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


select * from customers;
select * from products;
select * from orders;
select * from order_details;


USE sales_kpi_dashboard;

CREATE OR REPLACE VIEW vw_sales_kpi_base AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.region,
    o.sales_rep,
    o.order_status,
    c.customer_name,
    c.gender,
    c.city,
    c.state,
    c.country,
    c.signup_date,
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.unit_price,
    p.cost_price,
    od.order_detail_id,
    od.quantity,
    od.sales_amount,
    od.discount,
    od.profit
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;


CREATE OR REPLACE VIEW vw_sales_summary AS
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales_amount) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales_amount)) * 100, 2) AS profit_margin_pct,
    SUM(quantity) AS total_quantity_sold
FROM vw_sales_kpi_base
GROUP BY DATE_FORMAT(order_date, '%Y-%m');

CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT
    customer_id,
    customer_name,
    gender,
    city,
    state,
    country,
    signup_date,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(quantity) AS total_quantity_sold
FROM vw_sales_kpi_base
GROUP BY
    customer_id, customer_name, gender, city, state, country, signup_date;
    
    CREATE OR REPLACE VIEW vw_product_summary AS
SELECT
    product_id,
    product_name,
    category,
    subcategory,
    ROUND(MAX(unit_price), 2) AS unit_price,
    ROUND(MAX(cost_price), 2) AS cost_price,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM vw_sales_kpi_base
GROUP BY
    product_id, product_name, category, subcategory;
    
    CREATE OR REPLACE VIEW vw_region_summary AS
SELECT
    region,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(quantity) AS total_quantity_sold
FROM vw_sales_kpi_base
GROUP BY region;


--Total sales
select round(sum(sales_amount),2) as total_sales from  vw_sales_kpi_base;


--TOTAL ORDERS
select sum( distinct order_id) as total_orders from vw_sales_kpi_base;

-----Average Order Value
SELECT ROUND(SUM(sales_amount)/count(distinct order_id),2) as Average_Order_Value from vw_sales_kpi_base;

select round(sum(profit),2) as total_profit from vw_sales_kpi_base;


SELECT ROUND((SUM(profit) / SUM(sales_amount)) * 100, 2) AS profit_margin_pct
FROM vw_sales_kpi_base;

select count(distinct customer_id) as total_customers  from vw_sales_kpi_base;

SELECT COUNT(DISTINCT customer_id) AS new_customers
FROM vw_customer_summary
WHERE signup_date BETWEEN '2025-01-01' AND '2025-12-31';

SELECT COUNT(*) AS repeat_customers
FROM vw_customer_summary
WHERE total_orders > 1;

SELECT ROUND(
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
2) AS repeat_customer_rate_pct
FROM vw_customer_summary;

SELECT ROUND(SUM(total_sales) / COUNT(*), 2) AS sales_per_customer
FROM vw_customer_summary;

SELECT ROUND(SUM(profit) / COUNT(DISTINCT order_id), 2) AS profit_per_order
FROM vw_sales_kpi_base;

SELECT ROUND(SUM(total_profit) / COUNT(*), 2) AS profit_per_customer
FROM vw_customer_summary;

SELECT SUM(quantity) AS total_quantity_sold
FROM vw_sales_kpi_base;

SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 2) AS avg_qty_per_order
FROM vw_sales_kpi_base;

SELECT ROUND(SUM((sales_amount / (1 - discount)) * discount), 2) AS total_discount_amount
FROM vw_sales_kpi_base
WHERE discount < 1;

SELECT ROUND(
    SUM((sales_amount / (1 - discount)) * discount) * 100 / SUM(sales_amount / (1 - discount)),
2) AS discount_pct
FROM vw_sales_kpi_base
WHERE discount < 1;

SELECT product_name, total_sales
FROM vw_product_summary
ORDER BY total_sales DESC
LIMIT 1;

SELECT category, ROUND(SUM(total_sales), 2) AS total_sales
FROM vw_product_summary
GROUP BY category
ORDER BY total_sales DESC
LIMIT 1;

SELECT region, total_sales
FROM vw_region_summary
ORDER BY total_sales DESC
LIMIT 1;

SELECT ROUND(
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0
    / COUNT(DISTINCT order_id),
2) AS cancelled_orders_pct
FROM vw_sales_kpi_base;

SELECT ROUND(
    SUM(CASE WHEN order_status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
2) AS completed_orders_pct
FROM orders;

SELECT ROUND(
    SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
2) AS pending_orders_pct
FROM orders;

SELECT *
FROM vw_sales_summary
ORDER BY month;







