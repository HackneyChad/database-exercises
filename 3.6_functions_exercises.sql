/*
-- Copy the order by exercise and save it as 3.6_functions_exercises.sql.
-- done

-- Update your queries for employees whose names start and end with 'E'.
-- Use concat() to combine their first and last name together as a single column named full_name.

-- Convert the names produced in your last query to all uppercase.

-- For your query of employees born on Christmas and hired in the 90s, use datediff()
-- to find how many days they have been working at the company.
-- (Hint: You will also need to use NOW() or CURDATE())

-- Find the smallest and largest salary from the salaries table.

-- Use your knowledge of built in SQL functions to generate a username for all of the employees.
A username should be all lowercase, and consist of the first character of the employees first name,
the first 4 characters of the employees last name, an underscore, the month the employee was born,
and the last two digits of the year that they were born.
Below is an example of what the first 10 rows will look like:

+------------+------------+-----------+------------+
| username   | first_name | last_name | birth_date |
+------------+------------+-----------+------------+
| gface_0953 | Georgi     | Facello   | 1953-09-02 |
| bsimm_0664 | Bezalel    | Simmel    | 1964-06-02 |
| pbamf_1259 | Parto      | Bamford   | 1959-12-03 |
*/


USE employees;
DESCRIBE employees;

SELECT *
FROM employees
LIMIT 10
;

-- Update your queries for employees whose names start and end with 'E'.
-- Use concat() to combine their first and last name together as a single column named full_name.
SELECT emp_no
	,birth_date
    ,CONCAT(
		first_name
		,' '
		,last_name
        )
        AS 'full_name'
    ,gender
    ,hire_date
FROM employees
WHERE last_name LIKE 'e%'
	AND last_name LIKE '%e'
ORDER by emp_no ASC
;
-- 899 rows returned


-- Convert the names produced in your last query to all uppercase.
SELECT emp_no
	,birth_date
    ,UPPER(CONCAT(
		first_name
        ,' '
        ,last_name
		))
        AS 'full_name'
    ,gender
    ,hire_date
FROM employees
WHERE last_name LIKE 'e%'
	AND last_name LIKE '%e'
ORDER by emp_no ASC
;
-- 899 rows returned


-- For your query of employees born on Christmas and hired in the 90s,
-- use datediff() to find how many days they have been working at the company.
-- (Hint: You will also need to use NOW() or CURDATE())
SELECT *
	,DATEDIFF(NOW(), hire_date) AS 'days_working_for_company'
    ,ROUND(DATEDIFF(NOW(), hire_date)/365.25, 1) AS 'years_working_for_company'
FROM employees
WHERE (
	-- hire_date BETWEEN '1990-01-01' AND '1999-12-31' -- 362 rows returned
	hire_date LIKE '199%'  -- 362 rows returned
    AND birth_date LIKE '%-12-25'
    )
ORDER BY hire_date ASC
-- cannot order by any new alias fields that I created.  Must be one of the fields from the table.
LIMIT 10
;
-- 362 rows returned


-- Find the smallest and largest salary from the salaries table.
SELECT MAX(salary) AS 'largest_salary'
	,MIN(salary) AS 'smallest_salary'
FROM salaries
;


/*
Use your knowledge of built in SQL functions to generate a username for all of the employees.
A username should be all lowercase, and consist of the first character of the employees first name,
the first 4 characters of the employees last name, an underscore, the month the employee was born,
and the last two digits of the year that they were born.
Below is an example of what the first 10 rows will look like:

+------------+------------+-----------+------------+
| username   | first_name | last_name | birth_date |
+------------+------------+-----------+------------+
| gface_0953 | Georgi     | Facello   | 1953-09-02 |
| bsimm_0664 | Bezalel    | Simmel    | 1964-06-02 |
*/

SELECT LOWER(CONCAT(
	SUBSTR(first_name,1,1)
	,SUBSTR(last_name,1,4)
    ,'_'
    ,SUBSTR(birth_date,6,2)
    ,SUBSTR(birth_date,3,2)
    )) AS 'emp_user_name'
    ,first_name
    ,last_name
    ,birth_date
FROM employees
LIMIT 10
;
