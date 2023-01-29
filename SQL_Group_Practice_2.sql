
create table department
(
	dept_id		int ,
	dept_name	varchar(50) PRIMARY KEY,
	location	varchar(100)
);
insert into department values (1, 'Admin', 'Bangalore');
insert into department values (2, 'HR', 'Bangalore');
insert into department values (3, 'IT', 'Bangalore');
insert into department values (4, 'Finance', 'Mumbai');
insert into department values (5, 'Marketing', 'Bangalore');
insert into department values (6, 'Sales', 'Mumbai');


CREATE TABLE EMPLOYEE
(
    EMP_ID      INT PRIMARY KEY,
    EMP_NAME    VARCHAR(50) NOT NULL,
    DEPT_NAME   VARCHAR(50) NOT NULL,
    SALARY      INT,
    constraint fk_emp foreign key(dept_name) references department(dept_name)
);
insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);


CREATE TABLE employee_history
(
    emp_id      INT PRIMARY KEY,
    emp_name    VARCHAR(50) NOT NULL,
    dept_name   VARCHAR(50),
    salary      INT,
    location    VARCHAR(100),
    constraint fk_emp_hist_01 foreign key(dept_name) references department(dept_name),
    constraint fk_emp_hist_02 foreign key(emp_id) references employee(emp_id)
);

create table sales
(
	store_id  		int,
	store_name  	varchar(50),
	product_name	varchar(50),
	quantity		int,
	price	     	int
);
insert into sales values
(1, 'Apple Store 1','iPhone 13 Pro', 1, 1000),
(1, 'Apple Store 1','MacBook pro 14', 3, 6000),
(1, 'Apple Store 1','AirPods Pro', 2, 500),
(2, 'Apple Store 2','iPhone 13 Pro', 2, 2000),
(3, 'Apple Store 3','iPhone 12 Pro', 1, 750),
(3, 'Apple Store 3','MacBook pro 14', 1, 2000),
(3, 'Apple Store 3','MacBook Air', 4, 4400),
(3, 'Apple Store 3','iPhone 13', 2, 1800),
(3, 'Apple Store 3','AirPods Pro', 3, 750),
(4, 'Apple Store 4','iPhone 12 Pro', 2, 1500),
(4, 'Apple Store 4','MacBook pro 16', 1, 3500);


select * from employee;
select * from department;
select * from employee_history;
select * from sales;


-- TYPES OF SUBQUERY
--------------------------------------------------------------------------------
/* < SCALAR-Single Row SUBQUERY > */
-- it returns exactly 1 row and 1 column

-- /* QUESTION: Find the employees who's salary is more than the average salary earned by all employees. */

-- 1. SQ olarak kullanman gereken query: avg_salary
SELECt AVG(SALARY)
FROM dbo.EMPLOYEE

-- 2. ana Q'ninn icine filtre olarak yerlestirelim
SELECT EMP_NAME, SALARY
        FROM dbo.EMPLOYEE
        WHERE salary > 
        (SELECt AVG(SALARY)
        FROM dbo.EMPLOYEE)

-- Ornek: Analizimi nasıl daha iyi hale getiririm:
-- JOIN ile FROM'da kullanarak avg_salary ile aradaki farki gosterelim:
SELECT e.EMP_NAME, e.SALARY, avg_sal.sal, 
        e.SALARY - avg_sal.sal as salary_diff
FROM dbo.EMPLOYEE e 
JOIN  ( 
        SELECt AVG(SALARY) as sal
        FROM dbo.EMPLOYEE) as avg_sal
ON e.SALARY > avg_sal.sal 

/* < MULTIPLE ROW SUBQUERY > */
-- returns multiple column, multiple row or one column with multiple rows

-- Single column, multiple row subquery

/* QUESTION: Find department who do not have any employees */

SELECT DISTINCT dept_name FROM EMPLOYEE
SELECT DISTINCT dept_name FROM dbo.department

-- 1. solution with subquery
SELECT DISTINCT dept_name FROM dbo.department
WHERE dept_name NOT IN
(SELECT DISTINCT dept_name FROM EMPLOYEE)

-- 2. solution with set operators
SELECT DISTINCT dept_name FROM dbo.department
EXCEPT
SELECT DISTINCT dept_name FROM EMPLOYEE

-- 3. solution with left join
SELECT d.dept_name
FROM dbo.department d 
LEFT JOIN EMPLOYEE e 
ON e.DEPT_NAME = d.dept_name
WHERE e.dept_name IS NULL 


-- 4. solution with cte
WITH cte AS (
SELECT DISTINCT dept_name 
        FROM EMPLOYEE)
SELECT DISTINCT d.dept_name as dept_without_employees 
        FROM cte
       RIGHT JOIN dbo.department d 
        ON cte.DEPT_NAME = d.dept_name
        WHERE cte.DEPT_NAME IS NULL;

/* QUESTION: Find the employees who earn the highest salary in each department. */

-- 1. squery  -- Azure calismadi... 
/*
SELECT emp_name, dept_name, salary
FROM dbo.employee
WHERE (dept_name, salary) IN (
 SELECT dept_name, MAX(salary)
  FROM dbo.employee
  GROUP BY dept_name
 );
 */

-- 2. CTE 
WITH dept_max_salary AS
(SELECT dept_name, MAX(salary) as max_salary
FROM EMPLOYEE e 
GROUP BY e.dept_name)
SELECT e.EMP_NAME, e.DEPT_NAME, e.SALARY
FROM employee e 
JOIN dept_max_salary
ON e.DEPT_NAME = dept_max_salary.DEPT_NAME AND e.SALARY = dept_max_salary.max_salary

-- 3. SELF JOIN

SELECT e1.emp_name, e1.dept_name, e1.salary
FROM employee e1
JOIN (
    SELECT dept_name, MAX(salary) AS max_salary
    FROM employee
    GROUP BY dept_name
) e2
ON e1.dept_name = e2.dept_name AND e1.salary = e2.max_salary;

/* QUESTION: Find the employees in each department who earn more than the average salary in that department. */


-- solution with self join
SELECT e1.emp_name, e1.dept_name, e1.salary
FROM employee e1
JOIN (
    SELECT dept_name, AVG(salary) AS avg_salary
    FROM employee
    GROUP BY dept_name
) e2
ON e1.dept_name = e2.dept_name AND e1.salary > e2.avg_salary;

-- corr subquery

SELECT *
    FROM dbo.EMPLOYEE e1
    WHERE SALARY >
            (
            SELECT AVG(SALARY)
            FROM dbo.EMPLOYEE e2
            WHERE e1.DEPT_NAME = e2.DEPT_NAME
            );

/* < Using Subquery in HAVING clause > */
/* QUESTION: Find the stores who have sold more units than the average units sold by all stores. */

SELECT store_name, SUM(quantity) Items_sold
    FROM sales
    GROUP BY store_name
    HAVING SUM(quantity) > (
                            SELECT AVG(quantity) 
                            FROM sales
                            );

