import pandas as pd
import numpy as np
import dataset
import datetime
import sqlalchemy as sql

# linking to the old database using sqlalchemy

db = sql.create_engine('postgresql://postgres@localhost:5432/dw_database_assignment')

# import previous tables

employees_info = pd.read_sql_table('employees_info', db)
customers = pd.read_sql_table('customers', db)
offices = pd.read_sql_table('offices', db)
products = pd.read_sql_table('products', db)
product_orders = pd.read_sql_table('product_orders', db)
item_orders = pd.read_sql_table('item_orders', db)

# create new measures table joining facts including date info

measures = item_orders.join(product_orders.set_index('order_number'), on='order_number').join(
    products.set_index('product_code')[['buy_price', 'quantity_in_stock', '_m_s_r_p']], on='product_code').join(
    employees_info.set_index('employee_number')['office_code'], on='employee_number').join(
    customers.set_index('customer_number'), on='customer_number').join(date_dim.set_index('date'),
    on='order_date').drop(columns='order_date').rename(columns={'date_id': 'order_date'})

# creating new columns on the measures table

measures['revenue'] = measures['quantity_ordered'] * measures['price_each']
measures['expenses'] = measures['quantity_ordered'] * measures['buy_price']
measures['profit'] = measures['revenue'] - measures['expenses']
measures['profit_margin'] = measures['profit'] / (measures['quantity_ordered'] * measures['price_each'])

# creating a date dimension data frame

date_dim = pd.DataFrame(product_orders['order_date'].append(product_orders['required_date']).append(
    product_orders['shipped_date']).drop_duplicates())\

# set index and column name

date_dim.rename(columns={0: 'date'})
date_dim['date_id'] = date_dim.index

date_dim['dayofweek'] = date_dim['date'].dt.dayofweek
date_dim['day'] = date_dim['date'].dt.day
date_dim['month'] = date_dim['date'].dt.month
date_dim['quarter'] = date_dim['date'].dt.quarter
date_dim['year'] = date_dim['date'].dt.year

# connecting the datasets to the database

db = dataset.connect('postgresql://postgres@localhost:5432/dw_database_assignment_two')

# renaming each table in the database

offi_dim = db['offices_dim']
empl_dim = db['employees_dim']
cust_dim = db['customers_dim']
prod_dim = db['products_tim']
prod_orde_dim = db['product_orders_dim']
item_orde_dim = db['item_orders_dim']
date_dim = db['date_dim']
meas_dim = db['measures']

# inserting datasets

offi_dim.insert_many(offices.to_dict('records'))
empl_dim.insert_many(employees_info.to_dict('records'))
cust_dim.insert_many(customers.to_dict('records'))
prod_dim.insert_many(products.to_dict('records'))
prod_orde_dim.insert_many(product_orders.to_dict('records'))
item_orde_dim.insert_many(item_orders.to_dict('records'))
date_dim.insert_many(date_dim.to_dict('records'))
meas_dim.insert_many(measures.to_dict('records'))


