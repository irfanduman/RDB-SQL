--- SQL BRIEF OVERVIEW


-- GROUP BY

--- GROUP BY FUNCTION
--- returns only one result per group of data
-- always follows the WHERE clause
-- always precedes ORDER BY
-- 
-- group by > selecti kapsamalı. selectte olan groupby da olmalı. ama GB'da fazlası da olabilir

-- Write a query that returns the number of products priced over $1000 by brands

SELECT brand_id as my_brands, COUNT(product_id) as expensive_products
        FROM product.product 
        WHERE list_price > 1000 
        GROUP BY brand_id
        ORDER BY expensive_products DESC;


-- ALIAS : Find the state where "yandex" is used the most? (with number of users)

SELECT state as highest_state, COUNT(*) as most_yandex_users
FROM sale.customer
WHERE email LIKE '%@yandex%'
GROUP BY state


-- alias kullanımı:


-- JOIN
/*
A JOIN clause is used to combine two or more tables into a single table. 
This process is carried out based on a related column between tables.

There are basically five types of JOINs: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN and CROSS JOIN. 
As a special case, a table can join to itself and this type is called SELF JOIN:

(INNER) JOIN: Returns the common records in both tables.
LEFT JOIN: Returns all records from the left table and matching records from the right table.
RIGHT JOIN: Returns all records from the right table and matching records from the left table.
FULL OUTER JOIN: Returns all records of both left and right tables.
(left, right and full outer join are together called as Outer Join in some sources)
CROSS JOIN: Returns the Cartesian product of records in joined tables.
SELF JOIN: A join of a table to itself.*/

-- make a list of products showing the product id, product name, category ID and category name

SELECT p.product_id, p.product_name, c.*
FROM product.product p  
JOIN product.category c 
ON p.category_id = c.category_id;

-- soru metnini/task iyi anlamak: all, corresponding to, for each...

-- product.product 520 records. product.category 16 records. Ama result tableda 13 records var.
SELECT DISTINCT category_id FROM product.category;
SELECT DISTINCT category_id FROM product.product;


-- With a right join: (If we had a right join(below) it would be 523 rows. last three are null. That means there are not
-- any products with the category id 2-3 and 12 in the product.product table)

SELECT  p.product_id, p.product_name, c.*
FROM product.product p  
RIGHT JOIN product.category c 
ON p.category_id = c.category_id;

-- left join:
SELECT  p.product_id, p.product_name, c.*
FROM product.product p  
LEFT JOIN product.category c 
ON p.category_id = c.category_id;

-- full join
SELECT  p.product_id, p.product_name, c.*
FROM product.product p  
FULL JOIN product.category c 
ON p.category_id = c.category_id;


-- ek bilgi: eger tüm fieldları almak istersek join edilen tabloların isimlerine * ekleriz. örn: SELECT table_1.*, table_2.*

SELECT  p.product_id, p.product_name, c.*
FROM product.product p  
FULL JOIN product.category c 
ON p.category_id = c.category_id;

-- sadece null olanları nasıl buluruz: 

SELECT  p.product_id, p.product_name, c.*
FROM product.product p  
RIGHT JOIN product.category c 
ON p.category_id = c.category_id
WHERE p.product_id IS NULL;



-- SUBQUERY_CTEs

/*
A subquery is a SELECT statement that is nested within another statement. The subquery is also called 
the inner query or nested query. A subquery may be used in:
- SELECT clause
- FROM clause
- WHERE clause

There are some rules when using subquery:

- A subquery must be enclosed in parentheses.
- An ORDER BY clause is not allowed to use in a subquery.
- The BETWEEN operator can't be used with a subquery. But you can use BETWEEN within the subquery.
*/