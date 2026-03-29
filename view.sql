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