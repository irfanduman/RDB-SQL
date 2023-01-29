USE [SampleRetail]

--1.  By using view get the average sales by staffs and years using the AVG() aggregate function.
​
SELECT YEAR(O.order_date), S.staff_id, AVG(I.quantity) AS avg_of_years
FROM sale.orders O
JOIN sale.staff S 
	ON O.staff_id = S.staff_id
JOIN sale.order_item I
	ON O.order_id = I.order_id
GROUP BY YEAR(O.order_date), S.staff_id;
​
--2. Select the annual amount of product produced according to brands (use window functions).

create or alter view amount_of_product
as
select p.brand_id, i.product_id, YEAR(o.order_date) as [year], SUM(i.quantity) as amount_of_product  
from sale.order_item i
left join sale.orders o on i.order_id=o.order_id
left join product.product p on i.product_id=p.product_id
GROUP BY p.brand_id, i.product_id, YEAR(o.order_date);

--3. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---

SELECT city, COUNT(customer_id) AS number_of_customers
FROM sale.customer
WHERE state = 'CA'
GROUP BY city
HAVING COUNT(customer_id) > 5
ORDER BY number_of_customers DESC;

--4.Find the customers who placed at least two orders per year.

SELECT
    customer_id,
    YEAR (order_date),
    COUNT (order_id) order_count
FROM
    sales.orders
GROUP BY
    customer_id,
    YEAR (order_date)
HAVING
    COUNT (order_id) >= 2
ORDER BY
    customer_id;



/*5. Find the total amount of each order which are placed in 2018. Then categorize them according to limits stated below.
(You can use case statements here)

    If the total amount of order    
        less then 500 then "very low"
        between 500 - 1000 then "low"
        between 1000 - 5000 then "medium"
        between 5000 - 10000 then "high"
        more then 10000 then "very high" 
*/

SELECT    
    o.order_id, 
    SUM(quantity * list_price) order_value,
    CASE
        WHEN SUM(quantity * list_price) <= 500 
            THEN 'Very Low'
        WHEN SUM(quantity * list_price) > 500 AND 
            SUM(quantity * list_price) <= 1000 
            THEN 'Low'
        WHEN SUM(quantity * list_price) > 1000 AND 
            SUM(quantity * list_price) <= 5000 
            THEN 'Medium'
        WHEN SUM(quantity * list_price) > 5000 AND 
            SUM(quantity * list_price) <= 10000 
            THEN 'High'
        WHEN SUM(quantity * list_price) > 10000 
            THEN 'Very High'
    END order_priority
FROM    
    sales.orders o
INNER JOIN sales.order_items i ON i.order_id = o.order_id
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    o.order_id;




--6. By using Exists Statement find all customers who have placed more than two orders

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    EXISTS (
        SELECT
            COUNT (*)
        FROM
            sales.orders o
        WHERE
            customer_id = c.customer_id
        GROUP BY
            customer_id
        HAVING
            COUNT (*) > 2
    )
ORDER BY
    first_name,
    last_name;


--7. Show all the products and their list price, that were sold with more than two units in a sales order

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    product_id = ANY (
        SELECT
            product_id
        FROM
            sales.order_items
        WHERE
            quantity >= 2
    )
ORDER BY
    product_name;


/*
  8. Show the total count of orders per product for all times. 
  (Every product will be shown in one line and the total order count will be shown besides it) 
*/

SELECT
    product_name,
    count(distinct order_id) aa
	FROM
    production.products p
left JOIN sales.order_items o ON o.product_id = p.product_id
group by
product_name
ORDER BY
    aa;


--9. Find the products whose list prices are more than the average list price of products of all brands:

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > ALL (
        SELECT
            AVG (list_price) avg_list_price
        FROM
            production.products
        GROUP BY
            brand_id
    )
ORDER BY
    list_price;


