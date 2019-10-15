--- Get the top 3 product types that have proven most profitable

SELECT product_line
	FROM products_dim
	JOIN measures
	ON measures.product_code = products_dim.product_code
	GROUP BY products_dim.product_line
	ORDER BY SUM(measures.profit) DESC
	LIMIT(3);

--- Get the top 3 products by most items sold

SELECT product_code, sum(quantity_ordered)
    FROM measures
    JOIN item_orders_dim
    ON item_orders_dim.product_code = measures.product_code
    GROUP BY product_code
    ORDER BY SUM(quantity_ordered) DESC
    LIMIT(3);

--- Get the top 3 products by items sold per country of customer for: USA, Spain, Belgium

(SELECT products_dim.product_name, customers_dim.country
	FROM products_dim
	JOIN measures
	ON measures.product_code = products_dim.product_code
	JOIN customers_dim
	ON customers_dim.customer_number = measures.customer_number
	WHERE country = 'USA'
	GROUP BY product_name, country
	ORDER BY SUM(quantity_ordered) DESC
	LIMIT(3))
UNION ALL
(SELECT products_dim.product_name, customers_dim.country
	FROM products_dim
	JOIN measures
	ON measures.product_code = products_dim.product_code
	JOIN customers_dim
	ON customers_dim.customer_number = measures.customer_number
	WHERE country = 'Spain'
	GROUP BY product_name, country
	ORDER BY SUM(quantity_ordered) DESC
	LIMIT(3))
UNION ALL
(SELECT products_dim.product_name, customers_dim.country
	FROM products_dim
	JOIN measures
	ON measures.product_code = products_dim.product_code
	JOIN customers_dim
	ON customers_dim.customer_number = measures.customer_number
	WHERE country = 'Belgium'
	GROUP BY product_name, country
	ORDER BY SUM(quantity_ordered) DESC
	LIMIT(3));

--- Get the most profitable day of the week

SELECT dayofweek
	FROM date_dim
	JOIN measures
	ON measures.order_date = date_dim.date_id
	GROUP BY dayofweek
	ORDER BY SUM(profits) DESC
	LIMIT(1);

--- Get the top 3 city-quarters with the highest average profit margin in their sales


--- List the employees who have sold more goods (in $ amount) than the average employee.


--- List all the orders where the sales amount in the order is in the top 10% of all order sales amounts (BONUS: Add the employee number)
