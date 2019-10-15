DROP DATABASE dw_database_assignment_two;
CREATE DATABASE dw_database_assignment_two;
\c dw_database_assignment_two;

CREATE TABLE offices_dim (
office_code INTEGER PRIMARY KEY,
city VARCHAR,
state VARCHAR,
country VARCHAR,
office_location VARCHAR
);

CREATE TABLE employees_info_dim (
employee_number INTEGER PRIMARY KEY,
last_name VARCHAR,
first_name VARCHAR,
reports_to VARCHAR,
job_title VARCHAR,
office_code INTEGER REFERENCES offices_dim(office_code)
);

CREATE TABLE customers_dim (
customer_number INTEGER PRIMARY KEY,
customer_name VARCHAR,
contact_last_name VARCHAR,
contact_first_name VARCHAR,
city VARCHAR,
state VARCHAR,
country VARCHAR,
customer_location VARCHAR
);

CREATE TABLE products_dim (
product_code VARCHAR PRIMARY KEY,
product_line VARCHAR,
product_name VARCHAR,
product_scale VARCHAR,
product_vendor VARCHAR,
product_description VARCHAR,
html_description VARCHAR
);

CREATE TABLE product_orders_dim (
order_number INTEGER PRIMARY KEY,
customer_number INTEGER REFERENCES customers_dim(customer_number),
order_date DATE,
required_date DATE,
shipped_date DATE,
status VARCHAR
);

CREATE TABLE item_orders_dim (
product_code VARCHAR REFERENCES products_dim(product_code),
order_number INTEGER,
order_line_number INTEGER,
sales_rep_employee_number INTEGER
);

CREATE TABLE date_dim (
date_id INTEGER PRIMARY KEY,
date DATE,
dayofweek INTEGER,
day INTEGER,
month INTEGER,
quarter INTEGER,
year INTEGER
);

--creating measures/fact table

CREATE TABLE measures (
quantity_in_stock INTEGER,
quantity_ordered INTEGER,
buy_price MONEY,
_m_s_r_p MONEY,
price_each MONEY,
revenue MONEY,
cost MONEY,
profit MONEY,
profit_margin FLOAT,
credit_limit INTEGER,
order_number INTEGER REFERENCES product_orders_dim(order_number),
product_code VARCHAR REFERENCES products_dim(product_code),
customer_number INTEGER REFERENCES customers_dim(customer_number),
office_code INTEGER REFERENCES offices_dim(office_code),
order_date INTEGER REFERENCES date_dim(date_id),
required_date INTEGER REFERENCES date_dim(date_id),
shipped_date INTEGER REFERENCES date_dim(date_id),
sales_rep_employee_number INTEGER REFERENCES employees_info_dim(employee_number)
);
