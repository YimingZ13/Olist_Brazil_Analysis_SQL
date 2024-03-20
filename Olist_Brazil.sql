use brazilian_e_commerce;

SET SQL_SAFE_UPDATES = 0;

-- check the tables
SELECT *
FROM orders;

SELECT  *
FROM customers;

SELECT *
FROM sellers;

SELECT *
FROM geolocation;

SELECT *
FROM order_items;

SELECT *
FROM payments;

SELECT *
FROM products;

SELECT *
FROM product_category_name_translation;

SELECT *
FROM reviews;




-- product_category_name_transaction could be redundent, it only contains the translation of the names
-- update the product_category_name to the english translations in the products table
UPDATE products p
JOIN product_category_name_translation pcn
ON p.product_category_name = pcn.product_category_name
SET p.product_category_name = pcn.product_category_name_english;


-- check if there are any product names not been translated
SELECT DISTINCT(p.product_category_name) 
FROM products p
LEFT JOIN product_category_name_translation pcn
ON p.product_category_name = pcn.product_category_name_english
WHERE pcn.product_category_name_english IS NULL;


-- 'portateis_cozinha_e_preparadores_de_alimentos' and 'la_cuisin' are not in the table, thus not updated
-- 'pc_gamer' also does not make sense 
-- change them manually
UPDATE products
SET product_category_name = 'portable kitchen and food preparation devices'
WHERE product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos';

UPDATE products
SET product_category_name = 'kitchen'
WHERE product_category_name = 'la_cuisine';

UPDATE products
SET product_category_name = 'gaming_pc'
WHERE product_category_name = 'pc_gamer';


-- change all cell without a value to NULL
UPDATE orders
SET order_id = NULLIF(order_id, ''),
    customer_id = NULLIF(customer_id, ''),
    order_status = NULLIF(order_status, ''),
    order_purchase_timestamp = NULLIF(order_purchase_timestamp, ''),
    order_approved_at = NULLIF(order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(order_delivered_customer_date, ''),
    order_estimated_delivery_date = NULLIF(order_estimated_delivery_date, '');

UPDATE order_items
SET order_id = NULLIF(order_id, ''),
    order_item_id = NULLIF(order_item_id, ''),
    product_id = NULLIF(product_id, ''),
    seller_id = NULLIF(seller_id, ''),
    shipping_limit_date = NULLIF(shipping_limit_date, ''),
    price = NULLIF(price, ''),
    freight_value = NULLIF(freight_value, '');
    
UPDATE products
SET product_id = NULLIF(product_id, ''),
    product_category_name = NULLIF(product_category_name, ''),
    product_name_lenght = NULLIF(product_name_lenght, ''),
    product_description_lenght = NULLIF(product_description_lenght, ''),
    product_photos_qty = NULLIF(product_photos_qty, ''),
    product_weight_g = NULLIF(product_weight_g, ''),
    product_length_cm = NULLIF(product_length_cm, ''),
    product_height_cm = NULLIF(product_height_cm, ''),
    product_width_cm = NULLIF(product_width_cm, '');
    
UPDATE payments
SET order_id = NULLIF(order_id, ''),
    payment_sequential = NULLIF(payment_sequential, ''),
    payment_type = NULLIF(payment_type, ''),
    payment_installments = NULLIF(payment_installments, ''),
    payment_value = NULLIF(payment_value, '');
    
UPDATE customers
SET customer_id = NULLIF(customer_id, ''),
    customer_unique_id = NULLIF(customer_unique_id, ''),
    customer_zip_code_prefix = NULLIF(customer_zip_code_prefix, ''),
    customer_city = NULLIF(customer_city, ''),
    customer_state = NULLIF(customer_state, '');
    
UPDATE sellers
SET seller_id = NULLIF(seller_id, ''),
    seller_zip_code_prefix = NULLIF(seller_zip_code_prefix, ''),
    seller_city = NULLIF(seller_city, ''),
    seller_state = NULLIF(seller_state, '');
    
UPDATE geolocation
SET geolocation_zip_code_prefix = NULLIF(geolocation_zip_code_prefix, ''),
    geolocation_lat = NULLIF(geolocation_lat, ''),
    geolocation_lng = NULLIF(geolocation_lng, ''),
    geolocation_city = NULLIF(geolocation_city, ''),
    geolocation_state = NULLIF(geolocation_state, '');
    
UPDATE reviews
SET review_id = NULLIF(review_id, ''),
	order_id = NULLIF(order_id, ''),
	review_score = NULLIF(review_score, ''),
	review_creation_date = NULLIF(review_creation_date, ''),
	review_answer_timestamp = NULLIF(review_answer_timestamp, '');


-- convert columns to correct data type
ALTER TABLE orders 
    MODIFY COLUMN order_id VARCHAR(255), 
    MODIFY COLUMN customer_id VARCHAR(255),
    MODIFY COLUMN order_status VARCHAR(25),
    MODIFY COLUMN order_purchase_timestamp DATETIME,
    MODIFY COLUMN order_approved_at DATETIME, 
    MODIFY COLUMN order_delivered_carrier_date DATETIME, 
    MODIFY COLUMN order_delivered_customer_date DATETIME, 
    MODIFY COLUMN order_estimated_delivery_date DATETIME;

ALTER TABLE order_items 
    MODIFY COLUMN order_id VARCHAR(255), 
    MODIFY COLUMN order_item_id INT,
    MODIFY COLUMN seller_id VARCHAR(255),
    MODIFY COLUMN shipping_limit_date DATETIME;

ALTER TABLE products 
    MODIFY COLUMN product_id VARCHAR(255), 
    MODIFY COLUMN product_category_name VARCHAR(255);
    
ALTER TABLE payments 
    MODIFY COLUMN order_id VARCHAR(255), 
    MODIFY COLUMN payment_type VARCHAR(25);

ALTER TABLE customers 
    MODIFY COLUMN customer_id VARCHAR(255), 
    MODIFY COLUMN customer_unique_id VARCHAR(255),
    MODIFY COLUMN customer_zip_code_prefix VARCHAR(5),
    MODIFY COLUMN customer_city VARCHAR(50),
    MODIFY COLUMN customer_state VARCHAR(2);
    
ALTER TABLE sellers 
    MODIFY COLUMN seller_id VARCHAR(255), 
    MODIFY COLUMN seller_zip_code_prefix VARCHAR(5),
    MODIFY COLUMN seller_city VARCHAR(50),
    MODIFY COLUMN seller_state VARCHAR(2);
    
ALTER TABLE reviews 
    MODIFY COLUMN review_id VARCHAR(255), 
    MODIFY COLUMN order_id VARCHAR(255),
    MODIFY COLUMN review_creation_date DATETIME, 
    MODIFY COLUMN review_answer_timestamp DATETIME;


-- check different the order status
SELECT 
	order_status,
	COUNT(*)
FROM orders
GROUP BY order_status;

-- get the number of null delivery date for each order status
SELECT 
	order_status,
    COUNT(*)
FROM orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status;
-- there are some orders have null delivery date even though their status are set to be fulfilled, 
-- I will omit orders that are canceled, unavailable and have null delivery date for the following analysis
WITH CTE AS(
	SELECT *
	FROM orders
	WHERE 
		order_status <> 'canceled'
		AND order_delivered_customer_date IS NOT NULL
)
SELECT DISTINCT order_status
FROM valid_orders;
-- now we are only dealing with orders that are been delivered/completed

-- create a view for valid orders
CREATE VIEW valid_orders AS
SELECT *
FROM orders
WHERE 
	order_status <> 'canceled'
	AND order_delivered_customer_date IS NOT NULL;

SELECT *
FROM valid_orders;


-- Data Analysis

-- How many orders were placed on Olist, how has it changed over the years? Is there a seasonality?
-- yearly total number of orders
SELECT
	YEAR(order_purchase_timestamp) AS year,
    COUNT(*) AS number_of_orders
FROM valid_orders
GROUP BY 1
ORDER BY 1;

-- quarterly number of orders each year
SELECT
	YEAR(order_purchase_timestamp) AS year,
    QUARTER(order_purchase_timestamp) AS quarter,
	COUNT(*) AS number_of_orders
FROM valid_orders
GROUP BY 1,2
ORDER BY 1,2;

-- monthly number of orders each year
SELECT
	YEAR(order_purchase_timestamp) AS year,
    MONTH(order_purchase_timestamp) AS month,
	COUNT(*) AS number_of_orders
FROM valid_orders
GROUP BY 1,2
ORDER BY 1,2;


-- What's the total revenue generated on Olist, how does it change over time?
SELECT ROUND(SUM(p.payment_value),2) AS total_revenue
FROM payments p
JOIN valid_orders o
ON p.order_id = o.order_id;

-- yearly revenue
SELECT 
	YEAR(o.order_purchase_timestamp) AS year,
	ROUND(SUM(p.payment_value),2) AS total_revenue
FROM payments p
JOIN valid_orders o
ON p.order_id = o.order_id
GROUP BY 1
ORDER BY 1;

-- monthly revenue for each year
SELECT 
	YEAR(o.order_purchase_timestamp) AS year,
	MONTH(o.order_purchase_timestamp) AS month,
	ROUND(SUM(p.payment_value),2) AS total_revenue
FROM payments p
JOIN valid_orders o
ON p.order_id = o.order_id
GROUP BY 1,2
ORDER BY 1,2;

-- quarterly revenue for each year
SELECT 
	YEAR(o.order_purchase_timestamp) AS year,
	QUARTER(o.order_purchase_timestamp) AS quarter,
	ROUND(SUM(p.payment_value),2) AS total_revenue
FROM payments p
JOIN valid_orders o
ON p.order_id = o.order_id
GROUP BY 1,2
ORDER BY 1,2;


-- What are the successful categories on Olist, by year, month, and quarter?
WITH order_counts AS (
	SELECT
		p.product_category_name,
		COUNT(o.order_id) AS number_of_orders
	FROM valid_orders o
	JOIN order_items oi
	ON o.order_id = oi.order_id
	JOIN products p
	ON oi.product_id = p.product_id
	GROUP BY 1
),
total_orders AS (
	SELECT
		COUNT(*) AS total_order_items
	FROM order_items oi
    JOIN valid_orders o
    ON oi.order_id = o.order_id      -- a customer would buy multiples items under the same product, this CTE is to get the total number of products ordered 
)
SELECT
	oc.product_category_name,
    oc.number_of_orders,
    ROUND(100.0 * oc.number_of_orders / t.total_order_items, 2) AS percentage_of_total_orders
FROM order_counts oc
CROSS JOIN total_orders t;

-- most popular categories by year
 WITH yearly_order_counts AS (
	SELECT
		YEAR(o.order_purchase_timestamp) AS order_year,
		p.product_category_name,
		COUNT(o.order_id) AS number_of_orders
	FROM valid_orders o
	JOIN order_items oi
	ON o.order_id = oi.order_id
	JOIN products p
	ON oi.product_id = p.product_id
	GROUP BY 1,2
)
SELECT
	yoc.order_year,
	yoc.product_category_name,
    yoc.number_of_orders,
	RANK() OVER(ORDER BY yoc.number_of_orders DESC) AS rnk
FROM yearly_order_counts yoc
ORDER BY 1 DESC, rnk;

-- most popular categories by month
WITH monthly_order_counts AS(
	SELECT 
		MONTH(o.order_purchase_timestamp) AS order_month,
		p.product_category_name,
		COUNT(o.order_id) AS number_of_orders
	FROM valid_orders o
	JOIN order_items oi
	ON o.order_id = oi.order_id
	JOIN products p
	ON oi.product_id = p.product_id
	GROUP BY 1,2
) 
SELECT
	moc.order_month,
    moc.product_category_name,
    moc.number_of_orders,
	RANK() OVER(ORDER BY moc.number_of_orders DESC) AS rnk
FROM monthly_order_counts moc
ORDER BY 1, rnk;

-- most popular categories by quarter
WITH quarterly_order_counts AS(
	SELECT 
		QUARTER(o.order_purchase_timestamp) AS order_quarter,
		p.product_category_name,
		COUNT(o.order_id) AS number_of_orders
	FROM valid_orders o
	JOIN order_items oi
	ON o.order_id = oi.order_id
	JOIN products p
	ON oi.product_id = p.product_id
	GROUP BY 1,2
) 
SELECT
	qoc.order_quarter,
    qoc.product_category_name,
    qoc.number_of_orders,
	RANK() OVER(ORDER BY qoc.number_of_orders DESC) AS rnk
FROM quarterly_order_counts qoc
ORDER BY 1, rnk;


-- Which city, state generates the most revenue for Olist? How actively the population in different areas is placing orders?
-- most profitable city, state
SELECT
	s.seller_city,
    ROUND(SUM(p.payment_value),2) AS total_revenue
FROM valid_orders o 
JOIN payments p
ON o.order_id = p.order_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN sellers s
ON oi.seller_id = s.seller_id
GROUP BY 1
ORDER BY 2 DESC;

SELECT
	s.seller_state,
    ROUND(SUM(p.payment_value),2) AS total_revenue
FROM valid_orders o 
JOIN payments p
ON o.order_id = p.order_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN sellers s
ON oi.seller_id = s.seller_id
GROUP BY 1
ORDER BY 2 DESC;


-- What are the most popular categories by city, state?
-- most popular categories by city
WITH category_rankings AS (
	SELECT 
		c.customer_city,
        p.product_category_name,
        COUNT(*) AS number_of_orders,
        RANK() OVER(PARTITION BY c.customer_city ORDER BY  COUNT(*) DESC) AS rnk
    FROM valid_orders o
	JOIN customers c
	ON o.customer_id = c.customer_id
	JOIN order_items oi
	ON o.order_id = oi.order_id
	JOIN products p
	ON oi.product_id = p.product_id
    GROUP BY 1,2
)
SELECT
	cr.customer_city,
    cr.product_category_name,
    cr.number_of_orders
FROM category_rankings cr
WHERE cr.rnk=1
ORDER BY 3 DESC;

-- most popular categories by state
WITH category_rankings AS (
	SELECT 
		c.customer_state,
        p.product_category_name,
        COUNT(*) AS number_of_orders,
        RANK() OVER(PARTITION BY c.customer_state ORDER BY  COUNT(*) DESC) AS rnk
    FROM valid_orders o
	JOIN customers c
	ON o.customer_id = c.customer_id
	JOIN order_items oi
	ON o.order_id = oi.order_id
	JOIN products p
	ON oi.product_id = p.product_id
    GROUP BY 1,2
)
SELECT
	cr.customer_state,
    cr.product_category_name,
    cr.number_of_orders
FROM category_rankings cr
WHERE cr.rnk=1
ORDER BY 3 DESC;


-- What is the AOV and CPO of Olist? How does this vary by categories and payment method?
WITH revenue AS (
    SELECT 
        o.order_id,
        SUM(p.payment_value) AS total_revenue
    FROM valid_orders o
    JOIN payments p ON o.order_id = p.order_id
    GROUP BY o.order_id
),
cost AS (
    SELECT
        o.order_id,
        SUM(oi.price + oi.freight_value) AS total_cost
    FROM valid_orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
),
combined AS (
    SELECT
        o.order_id,
        COALESCE(r.total_revenue, 0) AS total_revenue,
        COALESCE(c.total_cost, 0) AS total_cost
    FROM valid_orders o
    JOIN revenue r ON o.order_id = r.order_id
    JOIN cost c ON o.order_id = c.order_id
)
SELECT
    ROUND(SUM(total_revenue) / COUNT(order_id), 2) AS APO,
    ROUND(SUM(total_cost) / COUNT(order_id), 2) AS CPO,
    ROUND(SUM(total_revenue) / COUNT(order_id), 2) - ROUND(SUM(total_cost) / COUNT(order_id), 2) AS average_profit_margin
FROM combined;

-- APO,CPO by categories
WITH revenue_cost AS (
    SELECT
        p.product_category_name,
        SUM(oi.price + oi.freight_value) AS total_cost,
        SUM(py.payment_value) AS total_revenue,
        COUNT(o.order_id) AS number_of_orders
    FROM valid_orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN payments py ON o.order_id = py.order_id
    GROUP BY p.product_category_name
)
SELECT
    product_category_name,
    ROUND(total_revenue / number_of_orders, 2) AS APO,
    ROUND(total_cost / number_of_orders, 2) AS CPO,
    ROUND((total_revenue / number_of_orders)-(total_cost / number_of_orders), 2) AS average_profit_margin
FROM revenue_cost
ORDER BY 4 DESC;

-- APO,CPO by payment types
WITH revenue_cost AS (
    SELECT
        p.payment_type,
        SUM(oi.price + oi.freight_value) AS total_cost,
        SUM(p.payment_value) AS total_revenue,
        COUNT(o.order_id) AS number_of_orders
    FROM valid_orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN payments p ON o.order_id = p.order_id
    GROUP BY 1
)
SELECT
    payment_type,
    ROUND(total_revenue / number_of_orders, 2) AS APO,
    ROUND(total_cost / number_of_orders, 2) AS CPO,
    ROUND((total_revenue / number_of_orders)-(total_cost / number_of_orders), 2) AS average_profit_margin
FROM revenue_cost
ORDER BY 4 DESC;
-- would be beneficial to have the payment processig costs in the dataset to further analyze the profit margin, in order to help assessing the cost-effectiveness of each payment method
-- if certain payment types that are preferred by customers or lead to higher APOs are underperforming due to technical issues or user interface problems, these insights can guide improvements to the checkout process, potentially increasing overall sales and customer satisfaction.


-- Who are the frequent shoppers on Olist? How many of them are there? How does this number change over time?
-- frequent shoppers are defined by who placed an order within one month window
WITH previous_order AS (
	SELECT 
		c.customer_unique_id,
		o.order_purchase_timestamp,
		LAG(o.order_purchase_timestamp,1) OVER(
			PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS previous_order_date
	FROM valid_orders o
	JOIN customers c
	ON o.customer_id = c.customer_id
),
active_customers AS (
	SELECT
		customer_unique_id,
        DATEDIFF(MAX(order_purchase_timestamp), MAX(previous_order_date)) AS days_between_orders
    FROM previous_order
	GROUP BY customer_unique_id
    HAVING DATEDIFF(MAX(order_purchase_timestamp), MAX(previous_order_date)) <= 30
		AND DATEDIFF(MAX(order_purchase_timestamp), MAX(previous_order_date)) IS NOT NULL
	
)
SELECT 
	customer_unique_id
FROM active_customers;
-- there are 1397 frequent shoppers

-- number of frequent shoppers over time
WITH previous_order AS (
	SELECT 
		c.customer_unique_id,
		o.order_purchase_timestamp,
		LAG(o.order_purchase_timestamp,1) OVER(
			PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS previous_order_date
	FROM valid_orders o
	JOIN customers c
	ON o.customer_id = c.customer_id
),
active_customers AS (
	SELECT
		customer_unique_id,
        YEAR(order_purchase_timestamp) AS year,
        Quarter(order_purchase_timestamp) AS quarter,
        MONTH(order_purchase_timestamp) AS month
    FROM previous_order
	GROUP BY 1,2,3,4
    HAVING DATEDIFF(MAX(order_purchase_timestamp), MAX(previous_order_date)) <= 30
		AND DATEDIFF(MAX(order_purchase_timestamp), MAX(previous_order_date)) IS NOT NULL
	
)
SELECT 
    year,
    quarter,
    month,
    COUNT(customer_unique_id) AS number_frequent_shoppers
FROM active_customers
GROUP BY 1,2,3
ORDER BY 1,2,3;


-- Which customers have the highest CLTV?
-- CLTV = Average Purchase Value × Purchase Frequency × Customer Lifespan
WITH customer_metrics AS (
	SELECT
		c.customer_unique_id,
		ROUND(AVG(p.payment_value), 2) AS average_purchase_value,
        ROUND(COUNT(*) / COUNT(DISTINCT customer_unique_id), 2) AS purchase_frequency,
        ROUND(DATEDIFF(MAX(o.order_purchase_timestamp), MIN(o.order_purchase_timestamp)) / 365, 2) AS customer_lifespan
	FROM valid_orders o
	JOIN payments p
	ON o.order_id = p.order_id
	JOIN customers c
	ON o.customer_id = c.customer_id
	GROUP BY c.customer_unique_id
)
SELECT
	customer_unique_id,
    average_purchase_value,
    purchase_frequency,
    customer_lifespan,
    ROUND(average_purchase_value * purchase_frequency * customer_lifespan, 2) AS CLTV
FROM customer_metrics
ORDER BY 5 DESC;

 
 -- What is the customer retention rate (CRR) by geolocaitons?
 WITH return_customers AS (
	SELECT
		c.customer_unique_id,
        COUNT(c.customer_id) AS number_of_purchases
    FROM valid_orders o
    JOIN customers c
    ON o.customer_id = c.customer_id
    GROUP BY 1
    HAVING COUNT(c.customer_unique_id) > 1
),
 return_customers_city AS (
	SELECT 
		c.customer_city,
		COUNT(rc.customer_unique_id) AS number_of_return_customers
	FROM return_customers rc
	JOIN customers c
	ON rc.customer_unique_id = c.customer_unique_id
	GROUP BY 1
),
total_customers_city AS (
	SELECT
		customer_city,
		COUNT(customer_unique_id) AS total_number_customers
	FROM customers
    GROUP BY 1)
SELECT
	rcc.customer_city,
    rcc.number_of_return_customers,
    ROUND(100 *  rcc.number_of_return_customers / tcc.total_number_customers, 2) AS CRR
FROM return_customers_city rcc
JOIN total_customers_city tcc
ON rcc.customer_city = tcc.customer_city
ORDER BY 2 DESC;
    
    
WITH return_customers AS (
	SELECT
		c.customer_unique_id,
        COUNT(c.customer_id) AS number_of_purchases
    FROM valid_orders o
    JOIN customers c
    ON o.customer_id = c.customer_id
    GROUP BY 1
    HAVING COUNT(c.customer_unique_id) > 1
),
 return_customers_state AS (
	SELECT 
		c.customer_state,
		COUNT(rc.customer_unique_id) AS number_of_return_customers
	FROM return_customers rc
	JOIN customers c
	ON rc.customer_unique_id = c.customer_unique_id
	GROUP BY 1
),
total_customers_state AS (
	SELECT
		customer_state,
		COUNT(customer_unique_id) AS total_number_customers
	FROM customers
    GROUP BY 1)
SELECT
	rcs.customer_state,
    rcS.number_of_return_customers,
    ROUND(100 *  rcs.number_of_return_customers / tcs.total_number_customers, 2) AS CRR
FROM return_customers_state rcs
JOIN total_customers_state tcs
ON rcs.customer_state = tcs.customer_state
ORDER BY 2 DESC;
 
 
-- What is the review distribution on Olist, how does this impact sales performance?
SELECT
	review_score,
    COUNT(*) AS number_of_reviews,
    ROUND(100 * COUNT(*) / tr.total_reviews, 2) AS percentage
FROM reviews
CROSS JOIN (
	SELECT 
		COUNT(*) AS total_reviews
	FROM reviews) tr
GROUP BY 1, total_reviews
ORDER BY 1;

-- sales for different review score
SELECT
	r.review_score,
    COUNT(*) AS number_of_orders,
    ROUND(100 * COUNT(*) / tor.total_orders, 2) AS percentage_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(100 * SUM(p.payment_value) / tp.total_pv, 2) AS percentage_revenue
FROM valid_orders o
JOIN reviews r 
ON o.order_id = r.order_id
JOIN payments p
ON o.order_id = p.order_id
CROSS JOIN (
	SELECT 
		COUNT(*) AS total_orders
	FROM valid_orders) tor
CROSS JOIN (
	SELECT 
		SUM(payment_value) AS total_pv
	FROM payments) tp
GROUP BY 1, total_orders, total_pv
ORDER BY 1;


-- What is the average review score for each category? How does it impact sales performance?
SELECT
	p.product_category_name,
    COUNT(p.product_id) AS number_of_orders,
    ROUND(AVG(review_score), 2) AS average_review_score
FROM valid_orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
JOIN reviews r
ON o.order_id = r.order_id
GROUP BY 1
ORDER BY 3 DESC;


-- What is the average delivery time? How does this vary for each city, state?
SELECT 
	AVG(TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS average_delivery_time
FROM valid_orders o;
-- on average, Olist delivers the orders around 12 days

-- average delivery time for each city,state
SELECT
	c.customer_city,
    ROUND(AVG(TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date)), 2) AS average_delivery_time
FROM valid_orders o
JOIN customers c 
ON o.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2 DESC;

SELECT
	c.customer_state,
    ROUND(AVG(TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date)), 2) AS average_delivery_time
FROM valid_orders o
JOIN customers c 
ON o.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2 DESC;


-- Who are the most successful sellers? How are they distributed? 
SELECT
	oi.seller_id,
    COUNT(oi.seller_id) AS number_of_orders
FROM valid_orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY 1
ORDER BY 2 DESC; 




