/*
1. Import the dataset and do usual exploratory analysis steps like checking the 
structure & characteristics of the dataset: 

1. Data type of all columns in the "customers" table. 
2. Get the time range between which the orders were placed. 
3. Count the total Cities & States from where customers ordered during the given period.
*/

-- Data type of all columns in 'customers'
SELECT 
TABLE_NAME,
COLUMN_NAME,
DATA_TYPE,
CHARACTER_MAXIMUM_LENGTH
ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customers'


-- Get the time range between which the orders were placed

SELECT MIN(order_purchase_timestamp) AS Start_time,
MAX(order_purchase_timestamp) AS End_time
FROM targetdata.orders



-- Count the total Cities & States from where customers ordered during the given period

SELECT 
COUNT(DISTINCT customer_city) total_city,
COUNT(DISTINCT customer_state) AS total_states
FROM targetdata.customers c
JOIN targetdata.orders o
ON o.customer_id = c.customer_id


/*
2. In-depth Exploration: 

1. Is there a growing trend in the no. of orders placed over the past years? 
2. Can we see some kind of monthly seasonality in terms of the no. of orders being placed? 
3. During what time of the day, do the Brazilian customers mostly place 
their orders? (Dawn, Morning, Afternoon or Night) 
? 0-6 hrs : Dawn 
? 7-12 hrs : Mornings 
? 13-18 hrs : Afternoon 
? 19-23 hrs : Night 

*/

-- Is there a growing trend in the no. of orders placed over the past years?
-- YOY% 

WITH CTE AS (
    SELECT
        YEAR(order_purchase_timestamp) AS year_of_purchase,
        COUNT(DISTINCT order_id) AS total_orders,
        LAG(COUNT(DISTINCT order_id)) OVER(ORDER BY YEAR(order_purchase_timestamp)
        ) AS py_total_orders
    FROM targetdata.orders
    GROUP BY YEAR(order_purchase_timestamp)
)
SELECT
    *,
    CAST(
        CAST(
            ((total_orders - py_total_orders) * 100.0) / py_total_orders
            AS DECIMAL(10,2)
        ) AS NVARCHAR(20)
    ) + '%' AS Diff
FROM CTE;




-- Can we see some kind of monthly seasonality in terms of the no. of orders being placed? 

SELECT
	MONTH(order_purchase_timestamp) AS months,
	DATENAME(MONTH,order_purchase_timestamp) AS month_name,
	COUNT(order_id) AS total_orders
FROM targetdata.orders
GROUP BY MONTH(order_purchase_timestamp),
		 DATENAME(MONTH,order_purchase_timestamp)
ORDER BY total_orders DESC


-- August, May, and July are the months with the highest No. of Orders placed.




/*
During what time of the day, do the Brazilian customers mostly place 
their orders? (Dawn, Morning, Afternoon or Night) 
? 0-6 hrs : Dawn 
? 7-12 hrs : Mornings 
? 13-18 hrs : Afternoon 
? 19-23 hrs : Night
*/

-- TO see which period of a day is generating more orders

WITH CTE AS (SELECT
		FORMAT(order_purchase_timestamp,'HH') AS hour_,
		CASE WHEN FORMAT(order_purchase_timestamp,'HH') BETWEEN 0 AND 6 THEN 'Dawn'
			 WHEN FORMAT(order_purchase_timestamp,'HH') BETWEEN 7 AND 12 THEN 'Morning'
			 WHEN FORMAT(order_purchase_timestamp,'HH') BETWEEN 13 AND 18 THEN 'Afternoon'
			 ELSE 'Night'
		END AS day_period,
			COUNT(DISTINCT order_id) AS total_orders
		FROM targetdata.orders
		GROUP BY FORMAT(order_purchase_timestamp,'HH')
		)

SELECT 
day_period,
SUM(total_orders) AS total_orders
FROM CTE
GROUP BY day_period
ORDER BY total_orders DESC


-- No. of Orders at afternoons and evenings are the highest
-- No. of Orders at Nights and Mornings are Moderate
-- During dawn least orders get placed




-- To see exactly which hour is contributing more

SELECT
	FORMAT(order_purchase_timestamp,'HH') AS hour_,
	COUNT(DISTINCT order_id) AS total_orders
FROM targetdata.orders
GROUP BY FORMAT(order_purchase_timestamp,'HH')
ORDER BY total_orders DESC


-- Top 5 most ordering hours: 16,11,14,13,15



/*
3. Evolution of E-commerce orders in the Brazil region: 

1. Get the month on month no. of orders placed in each state. 
2. How are the customers distributed across all the states? 
*/


-- Get the month on month no. of orders placed in each state

SELECT
	FORMAT(o.order_purchase_timestamp,'yyyy-MM') AS months,
	c.customer_state AS customer_state,
	COUNT(DISTINCT o.order_id) AS total_orders
FROM targetdata.orders o
JOIN targetdata.customers c
ON o.customer_id = c.customer_id
GROUP BY FORMAT(order_purchase_timestamp,'yyyy-MM'),
		 c.customer_state
ORDER BY months



-- How are the customers distributed across all the states

SELECT 
	customer_state,
	COUNT(customer_id) AS total_customers
FROM targetdata.customers
GROUP BY customer_state



/*
4. Impact on Economy: Analyze the money movement by e-commerce by looking 
at order prices, freight and others. 
1. Get the % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only). 
You can use the "payment_value" column in the payments table to get the cost of orders. 
2. Calculate the Total & Average value of order price for each state. 
3. Calculate the Total & Average value of order freight for each state. 
*/

                           





-- Get the % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only)

-- I used sum of price and freight value as the cost from order_items

-- check whether the table contains duplicate rows

SELECT 
    order_id,
    order_item_id,
    COUNT(*) AS row_count
FROM targetdata.order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;




WITH CTE AS (SELECT 
				FORMAT(o.order_purchase_timestamp,'yyyy') AS years,
				FORMAT(o.order_purchase_timestamp,'MM') AS months,
				oi.Price,
				oi.freight_value,
				oi.price + oi.freight_value AS Cost
			FROM targetdata.order_items oi JOIN targetdata.orders o
			ON oi.order_id = o.order_id)

,CTE2 AS (	SELECT 
				years,
				SUM(cost) AS total_cost,
				LAG(SUM(cost)) OVER(ORDER BY years) AS py_total_cost
			FROM CTE
			WHERE months BETWEEN 1 AND 8
			GROUP BY years)

SELECT *,
	CAST(
		CAST(
				((total_cost - py_total_cost)/py_total_cost)*100 
		AS DECIMAL(10,2)) 
	AS NVARCHAR)
	+ '%' AS percentage_diff
FROM CTE2
WHERE years IN (2017,2018)


-- 139.42% Increase in cost in 2018 as compared to 2017





-- Using payment_values from payments

WITH CTE AS (	SELECT 
						YEAR(o.order_purchase_timestamp) AS years,
						MONTH(o.order_purchase_timestamp) AS months,
						p.payment_value
				FROM targetdata.orders o 
				LEFT JOIN targetdata.payments p
				ON o.order_id = p.order_id
				WHERE	MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
						AND YEAR(o.order_purchase_timestamp) IN (2017,2018) )


,CTE2 AS (	SELECT 
			years,
			SUM(payment_value) AS total_cost,
			LAG(SUM(payment_value)) OVER(ORDER BY years) AS py_total_cost,
			CAST(
				CAST(
				((SUM(payment_value) - LAG(SUM(payment_value)) OVER(ORDER BY years))/
					LAG(SUM(payment_value)) OVER(ORDER BY years))*100 
					AS DECIMAL(10,2)
					) AS NVARCHAR) 
				+ '%'AS percentage_diff
			FROM CTE
			GROUP BY years)

SELECT 
	total_cost AS cost_2018_,
	py_total_cost AS cost_2017,
	percentage_diff
FROM CTE2
WHERE years = 2018





-- Calculate the Total & Average value of order price for each state
-- Calculate the Total & Average value of order freight for each state


WITH CTE AS (	SELECT 
					c.customer_state,
					oi.price,
					oi.freight_value
				FROM targetdata.orders o 
				JOIN targetdata.order_items oi
				ON o.order_id = oi.order_id
				JOIN targetdata.customers c
				ON o.customer_id = c.customer_id)

SELECT 
	customer_state,
	SUM(price) AS total_price,
	AVG(price) AS avg_price,
	SUM(freight_value) AS total_freight_value,
	AVG(freight_value) AS avg_freight_value
FROM CTE
GROUP BY customer_state




/*
5. Analysis based on sales, freight and delivery time. 
1. Find the no. of days taken to deliver each order from the order’s 
purchase date as delivery time. 
Also, calculate the difference (in days) between the estimated & actual 
delivery date of an order. 
*/



SELECT
	order_id,
	order_purchase_timestamp,
	order_delivered_customer_date,
	DATEDIFF(DAY,order_purchase_timestamp,ISNULL(order_delivered_customer_date,order_purchase_timestamp)) 
	AS Days_taken_to_deliver,                    -- delivery date - order purchase date
	DATEDIFF(DAY,ISNULL(order_delivered_customer_date,order_estimated_delivery_date),order_estimated_delivery_date)
	AS Days_diff_est_date_delivery_date          -- estimated - actual delivery date
FROM targetdata.orders





/*
2. Find out the top 5 states with the highest & lowest average freight 
value. 
3. Find out the top 5 states with the highest & lowest average delivery 
time. 
4. Find out the top 5 states where the order delivery is really fast as 
compared to the estimated date of delivery. 
You can use the difference between the averages of actual & estimated 
delivery date to figure out how fast the delivery was for each state. 
*/


-- Top 5 states with highest avg freight_value

SELECT TOP 5
	c.customer_state,
	AVG(oi.freight_value) AS avg_freight_value
FROM targetdata.order_items oi 
JOIN targetdata.orders o
ON o.order_id = oi.order_id
JOIN targetdata.customers c
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY avg_freight_value DESC



-- Top 5 states with lowest avg freight_value

SELECT TOP 5
	c.customer_state,
	AVG(oi.freight_value) AS avg_freight_value
FROM targetdata.order_items oi 
JOIN targetdata.orders o
ON o.order_id = oi.order_id
JOIN targetdata.customers c
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY avg_freight_value




-- Top 5 states with highest avg delivery time by days

SELECT TOP 5
	c.customer_state,
	AVG(DATEDIFF(DAY,o.order_purchase_timestamp,ISNULL(o.order_delivered_customer_date,o.order_purchase_timestamp)))
	AS days_taken_to_deliver
FROM targetdata.orders o
JOIN targetdata.customers c
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY days_taken_to_deliver DESC



-- Top 5 states with lowest avg delivery time by days

SELECT TOP 5
	c.customer_state,
	AVG(DATEDIFF(DAY,o.order_purchase_timestamp,ISNULL(o.order_delivered_customer_date,o.order_purchase_timestamp)))
	AS days_taken_to_deliver
FROM targetdata.orders o
JOIN targetdata.customers c
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY days_taken_to_deliver



-- Top 5 states where the order delivery is really fast as compared to the estimated date of delivery


SELECT TOP 5
	c.customer_state,
	AVG(DATEDIFF(DAY,ISNULL(o.order_delivered_customer_date,o.order_estimated_delivery_date),o.order_estimated_delivery_date))
	AS days_diff_est_date_delivery_date
FROM targetdata.orders o
JOIN targetdata.customers c
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY days_diff_est_date_delivery_date DESC






/*
6. Analysis based on the payments: 
1. Find the month on month no. of orders placed using different payment 
types. 
2. Find the no. of orders placed on the basis of the payment installments 
that have been paid.
*/


-- Find the month on month no. of orders placed using different payment types

SELECT  
	FORMAT(o.order_purchase_timestamp,'yyyy-MM') AS months,
	p.payment_type,
	COUNT(DISTINCT o.order_id) AS total_orders
FROM targetdata.orders o
JOIN targetdata.payments p
ON o.order_id = p.order_id
GROUP BY FORMAT(o.order_purchase_timestamp,'yyyy-MM'),
		p.payment_type
ORDER BY FORMAT(o.order_purchase_timestamp,'yyyy-MM')



-- Find the no. of orders placed on the basis of the payment installments that have been paid

SELECT  
	payment_installments,
	COUNT(DISTINCT order_id) AS total_orders
FROM targetdata.payments p
GROUP BY payment_installments
ORDER BY payment_installments
