# Sales-and-Customer-KPI-Dashboard-using-Power-BI-and-MySQL


## Project Overview
This project focuses on building a **Sales and Customer KPI Dashboard** using **MySQL** and **Power BI**.  
The dataset was first loaded into MySQL, SQL views were created for analysis, and then those views were connected to Power BI to build an interactive dashboard.

The dashboard helps track:
- monthly sales performance
- monthly profit trend
- region-wise sales analysis
- customer-level insights

---

## Tech Stack
- **Database:** MySQL
- **Database Tool:** MySQL Workbench
- **Visualization Tool:** Power BI
- **Language:** SQL
- **Data Format:** CSV

---

## Project Workflow
1. Created/imported dataset files in CSV format
2. Loaded the dataset into **MySQL Workbench**
3. Created required tables in MySQL
4. Built SQL **views** for simplified reporting
5. Connected MySQL views to **Power BI**
6. Designed dashboard visuals using Power BI

---

## Dataset Files
The project uses the following dataset files:

- `customers.csv`
- `products.csv`
- `orders.csv`
- `order_details.csv`

These files were imported into MySQL and used to create the reporting model.

---

## Database Schema
The project contains the following main tables:

### 1. customers
Stores customer-related information:
- customer_id
- customer_name
- gender
- city
- state
- country
- signup_date

### 2. products
Stores product details:
- product_id
- product_name
- category
- subcategory
- unit_price
- cost_price

### 3. orders
Stores order-level details:
- order_id
- customer_id
- order_date
- region
- sales_rep
- order_status

### 4. order_details
Stores transaction-level sales details:
- order_detail_id
- order_id
- product_id
- quantity
- sales_amount
- discount
- profit

---

## SQL Views Used
To simplify reporting and dashboard building, the following SQL views were created:

### 1. `vw_sales_kpi_base`
A base joined view combining:
- customers
- products
- orders
- order_details

### 2. `vw_sales_summary`
Used for:
- monthly sales trend
- monthly profit trend
- average order value
- profit margin

### 3. `vw_customer_summary`
Used for:
- customer-level sales insights
- top customers
- total orders per customer
- total profit per customer

### 4. `vw_product_summary`
Used for:
- product-level performance
- top-selling products
- category analysis

### 5. `vw_region_summary`
Used for:
- region-wise sales analysis
- region-wise profit analysis
- customer distribution by region

---

## Dashboard Features
The Power BI dashboard currently includes:

- **Monthly Sales Trend**
- **Monthly Profit Trend**
- **Sales by Region**
- **Customer Table View**

The dashboard was built directly using MySQL views for a simpler and cleaner reporting flow.

---

## KPIs Considered
This project is based on the following key business metrics:

- Total Sales
- Total Orders
- Average Order Value
- Total Profit
- Profit Margin %
- Total Customers
- Repeat Customers
- Sales by Region
- Profit by Region
- Monthly Sales Trend
- Monthly Profit Trend

---

## Steps to Run This Project

### 1. Import dataset into MySQL
Load the CSV files into MySQL Workbench.

### 2. Create database and tables
Run the schema SQL file to create all required tables.

### 3. Create SQL views
Run the SQL view scripts to create:
- `vw_sales_kpi_base`
- `vw_sales_summary`
- `vw_customer_summary`
- `vw_product_summary`
- `vw_region_summary`

### 4. Connect MySQL to Power BI
In Power BI:
- Go to **Get Data**
- Select **MySQL Database**
- Enter server and database details
- Load the created SQL views

### 5. Build dashboard visuals
Use the imported views to build charts, tables, and KPI cards.

---

## Sample Dashboard Visuals
The dashboard contains:
- line chart for monthly sales
- line chart for monthly profit
- bar chart for sales by region
- customer summary table

---

## Key Learnings
Through this project, I learned:
- how to import CSV data into MySQL
- how to create SQL views for reporting
- how to connect MySQL with Power BI
- how to design a business dashboard
- how to analyze sales and customer KPIs

---

## Project Outcome
This project demonstrates how SQL and Power BI can be combined to build a useful business intelligence solution for sales and customer performance analysis.

It can be extended further by adding:
- KPI cards
- top product analysis
- category analysis
- customer segmentation
- interactive slicers and filters

---

## Future Improvements
Possible future enhancements:
- add KPI cards at the top of the dashboard
- add Top 10 Products visual
- add Customer Segmentation analysis
- add dynamic slicers for region, product category, and date
- improve dashboard formatting and theming

---

## Author
** Hritik Chaudhary**


- view creation script

---
