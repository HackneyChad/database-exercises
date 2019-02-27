USE ada_663;


/* ===================================================================================== */
-- 1.  Using the example from the lesson, re-create the employees_with_departments table.

DROP TABLE employees_with_departments;

/* instead simply pull over salaries, employees, dept_emp and departments
and then perform the joins inside my db space... create one master table to do the joins
and then do the math on that table also.
*/

-- 	CREATE TABLE ada_663.salaries AS
-- 	SELECT *
-- 	FROM employees.salaries;
-- 	-- 2844047 row(s) affected

-- 	USE employees;
-- 	SELECT COUNT(*)
-- 	FROM salaries;
-- 	-- 2844047 rows returned

-- 	CREATE TABLE ada_663.employees AS
-- 	SELECT *
-- 	FROM employees.employees;
-- 	-- 300024 row(s) affected

-- 	USE employees;
-- 	SELECT COUNT(*)
-- 	FROM employees;
-- 	-- 300024 rows returned

-- 	CREATE TABLE ada_663.dept_emp AS
-- 	SELECT *
-- 	FROM employees.dept_emp;
-- 	-- 331603 row(s) affected

-- 	USE employees;
-- 	SELECT COUNT(*)
-- 	FROM dept_emp;
-- 	-- 331603 rows returned

-- 	CREATE TABLE ada_663.departments AS
-- 	SELECT *
-- 	FROM employees.departments;
-- 	-- 9 row(s) affected

-- 	USE employees;
-- 	SELECT COUNT(*)
-- 	FROM departments;
-- 	-- 9 rows returned

-- 	-- all data tables copied to my db.
-- 	-- now create the temp table here in my db.
-- 	-- now perform the joins inside my db space... create one master table to do the joins
-- 	-- then do the math on that table also.



USE ada_663;
DROP TABLE employees_with_departments;

CREATE TABLE ada_663.employees_with_departments AS
SELECT e.emp_no
	,e.first_name
    ,e.last_name
    ,CONCAT(e.first_name, ' ',e.last_name) AS full_name
    ,de.dept_no
    ,d.dept_name
    ,s.salary
FROM employees e
	JOIN dept_emp de USING(emp_no)
 	JOIN departments d USING(dept_no)
   	JOIN salaries s USING(emp_no)
;
-- 3142095 rows returned - correct
-- now have a single table containing employee info, department info and salary info

/* ===================================================================================== */
/* 1.a. Add a column named full_name to this table.  It should be a VARCHAR whose length
is the sum of the lengths of the first name and last name columns. */

ALTER TABLE ada_663.employees_with_departments ADD full_name VARCHAR(40);
-- 0 rows returned, 1 field added - correct


/* ===================================================================================== */
/* 1.b. Update the table so that full name column contains the correct data. */

UPDATE employees_with_departments SET full_name = CONCAT(first_name, ' ',last_name)
;
-- 0 rows returned, 1 field updated - correct

USE ada_663;
SELECT *
FROM employees_with_departments
LIMIT 25;
-- check, correct


/* ===================================================================================== */
/* 1.c. Remove the first_name and last_name columns from the table. */

ALTER TABLE employees_with_departments DROP COLUMN first_name
;
-- 0 rows returned, 1 field dropped - correct


ALTER TABLE employees_with_departments DROP COLUMN last_name
;
-- 0 rows returned, 1 field dropped - correct

USE ada_663;
SELECT *
FROM employees_with_departments
LIMIT 25;
-- check, correct

/* ===================================================================================== */
/* 1.d. What is another way you could have ended up with this same table? */

-- do not know another way


/* ===================================================================================== */
/* 2. Create a temporary table based on the payments table from the sakila database.
Write the SQL necessary to transform the amount column such that it is stored as an integer
represening the number of cents of the payment. For example, 1.99 should become 199.
*/

USE ada_663;

DROP TABLE sakila_temp_table;

CREATE TEMPORARY TABLE sakila_temp_table AS
	SELECT payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update
    FROM sakila.payment
    LIMIT 100
;
-- 100 records returned - correct

SELECT *
FROM sakila_temp_table;

ALTER TABLE sakila_temp_table ADD amount4 INT;
-- 0 records returned, 1 field added

UPDATE sakila_temp_table SET amount4 = amount*100;
-- 100 records returned, 1 field populated - correct

ALTER TABLE sakila_temp_table DROP COLUMN amount
;
-- 0 rows returned, 1 field dropped - correct

select *
FROM sakila_temp_table;


/* ===================================================================================== */
/* 3.  Find out how the average pay in each department compares to the overall average pay.
In order to make the comparison easier, you should use the Z-score for salaries.
In terms of salary, what is the best department to work for?  The worst?
+--------------------+-----------------+
| dept_name          | salary_z_score  | 
+--------------------+-----------------+
| Customer Service   | -0.065641701345 | 
| Development        | -0.060466339473 | 
| Finance            | 0.090924841177  | 
| Human Resources    | -0.112346685678 | 
| Marketing          | 0.111739523864  | */


USE ada_663;

# 1. get aggregates in a temp table
CREATE TABLE salary_agg AS
	SELECT AVG(salary) AS avg_salary, STDDEV(salary) AS stddev_salary
    FROM employees.salaries
    WHERE to_date >NOW()
;

#2. get z from the join on employees, dept_emp,
#with hard coded avgs and stddevs from temp table above.
SELECT de.emp_no, s.salary, ((s.salary-72012)/17310) AS z_salary
FROM employees.salaries s
JOIN employees.dept_emp de
	ON s.emp_no = de.emp_no
WHERE s.to_date >NOW()
;

#3. get dept added in from departments table
SELECT d.dept_name, de.emp_no, s.salary, ((s.salary-72012)/17310) AS z_salary
FROM employees.salaries s
JOIN employees.dept_emp de
	ON s.emp_no = de.emp_no
JOIN employees.departments d
	ON de.dept_no = d.dept_no
WHERE s.to_date >NOW()
;

#4. get avg z by dept by wrapping the above query into a subquery.
SELECT a.dept_name, AVG(a.z_salary) AS avg_z_salary
FROM (
	SELECT d.dept_name, de.emp_no, s.salary, ((s.salary-72012)/17310) AS z_salary
	FROM salaries s
	JOIN employees.dept_emp de
		ON s.emp_no = de.emp_no
	JOIN departments d
		ON de.dept_no = d.dept_no
	WHERE s.to_date >NOW()
    ) a
GROUP BY a.dept_name
ORDER BY avg_z_salary DESC
;


# final version 1, create temp table
CREATE TEMPORARY salary_agg AS
SELECT AVG(salary) AS avg_salary, STDDEV(salary) AS stddev_salary
FROM employees.salaries
WHERE to_date >NOW()
;

SELECT a.dept_name, AVG(a.z_salary) AS avg_z_salary
FROM (
	SELECT d.dept_name, de.emp_no, s.salary, ((s.salary-72012)/17310) AS z_salary
	FROM employees.salaries s
	JOIN employees.dept_emp de
		ON s.emp_no = de.emp_no
	JOIN employees.departments d
		ON de.dept_no = d.dept_no
	WHERE s.to_date >NOW()
    ) a
GROUP BY a.dept_name
ORDER BY avg_z_salary DESC
;

# final version 2, SELECT * FROM agg temp table;
USE ada_663;

CREATE TEMPORARY TABLE salary_agg AS
SELECT AVG(salary) AS avg_salary, STDDEV(salary) AS stddev_salary
FROM employees.salaries
WHERE to_date >NOW()
;

SELECT a.dept_name, AVG(z_salary) AS avg_z_salary
FROM (
	SELECT d.dept_name, de.emp_no, s.salary, ((s.salary-a.avg_salary)/a.stddev_salary) AS z_salary
	FROM employees.salaries s
    JOIN salary_agg a
	JOIN employees.dept_emp de
		ON s.emp_no = de.emp_no
	JOIN employees.departments d
		ON de.dept_no = d.dept_no
	WHERE s.to_date >NOW()
    ) a
GROUP BY a.dept_name
ORDER BY avg_z_salary DESC
;


/* ======================================================== 
4.  What is the average salary for an employee based on 
the number of years they have been with the company?
Express your answer in terms of the Z-score of salary.  */



USE ada_663;

CREATE TEMPORARY TABLE salary_agg_4 AS
SELECT AVG(salary) AS avg_salary, STDDEV(salary) AS stddev_salary
FROM employees.salaries
WHERE to_date >NOW()
;

SELECT  years_with_company
        ,AVG(z_salary) AS avg_z_salary
FROM (
	SELECT -- d.dept_name,
    	-- MAX(de.to_date) AS a.years_with_company
        DATEDIFF((MAX(de.to_date)), (MIN(de.from_date))) AS years_with_company
        ,de.emp_no, s.salary, ((s.salary-a.avg_salary)/a.stddev_salary) AS z_salary
	FROM employees.salaries s
    JOIN salary_agg_4 a
	JOIN employees.dept_emp de
		ON s.emp_no = de.emp_no        
-- 	JOIN employees.departments d
-- 		ON de.dept_no = d.dept_no
	WHERE s.to_date >NOW()
    GROUP BY years_with_company
    ) a
-- GROUP BY a.years_with_company
-- ORDER BY a.years_with_company ASC
;

In aggregated query without GROUP BY,
expression #2 of SELECT list contains nonaggregated column 'employees.de.emp_no';
this is incompatible with sql_mode=only_full_group_by
at line 5


