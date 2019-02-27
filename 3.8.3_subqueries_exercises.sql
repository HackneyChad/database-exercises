-- 3.8.3_subqueries_exercises.sql

/*
Sub-queries, also called nested queries, refers to having more than one query expression in a query.

Using Sub-queries:
Sub-queries are helpful when we want to find if a value is within a subset of acceptable values.

A nested query follows this syntax:
	SELECT column_a, column_b, column_c
	FROM table_a
	WHERE column_a IN (
		SELECT column_a
		FROM table_b
		WHERE column_b = true
		);

From our employees database, we can use this example query to find all the department managers names and birth dates:

SELECT first_name, last_name, birth_date
FROM employees
WHERE emp_no IN (
    SELECT emp_no
    FROM dept_manager
)
LIMIT 10;
That query should return the following result:
+------------+--------------+------------+
| first_name | last_name    | birth_date |
+------------+--------------+------------+
| Margareta  | Markovitch   | 1956-09-12 |
| Vishwani   | Minakawa     | 1963-06-21 |
| Ebru       | Alpin        | 1959-10-28 |
| Isamu      | Legleitner   | 1957-03-28 | ...etc

*/

/* ===========================================================================*/
/* EXERCISES

1. Find all the employees with the same hire date as employee 101010 using a sub-query
s/b 69 Rows */

SELECT emp_no
	,CONCAT(last_name, ' ',first_name) AS full_name
    ,hire_date
FROM employees
WHERE hire_date = (
	SELECT hire_date
	FROM employees
	WHERE emp_no = '101010'
    )
ORDER BY full_name
;
-- 69 rows returned - correct


/* ===========================================================================*/
/*
2. Find all the titles held by all employees with the first name Aamod.
s/b 314 total titles, 6 unique titles */

SELECT title
FROM titles
WHERE emp_no IN (
	SELECT emp_no
	FROM employees
	WHERE first_name = 'Aamod'
    )
;
-- 314 rows returned (314 total titles) - correct

-- how many distinct titles?

SELECT DISTINCT title
FROM titles
WHERE title IN (
	SELECT title
	FROM titles
	WHERE emp_no IN (
		SELECT emp_no
		FROM employees
		WHERE first_name = 'Aamod'
		)
	)
;
-- 6 rows returned (6 distinct titles) - correct

/* ===========================================================================*/
/* 3. How many people in the "employees" table are no longer working for the company?
s/b 59,900  */

SELECT emp_no
FROM employees
WHERE emp_no NOT IN (
	SELECT emp_no
	FROM salaries
	WHERE to_date > NOW()
	)
    ;
    -- 59900 rows returned - correct


/* ===========================================================================*/
/*
4. Find all the current department managers that are female. */

SELECT emp_no
	,first_name
    ,last_name
FROM employees
WHERE gender = 'F'
	AND emp_no IN (
		SELECT emp_no
		FROM dept_manager
        WHERE to_date > NOW()
		)
;
	
/* ===========================================================================*/
/*
5. Find all the employees that currently have a higher than average salary.
s/b 154543 rows in total. */

SELECT e.first_name
    ,e.last_name
    ,s.salary
FROM employees e
JOIN salaries s  -- this join enables me to bring the actual salary into the final result set.
	ON e.emp_no = s.emp_no
WHERE s.salary > (
			SELECT AVG(salary)
			FROM salaries
			) -- this subquery FIRST finds the average salary among the CURRENT salaries.
		AND to_date > NOW() /* this condition says to only consider the current salaries in this table,
        not historical salaries */
ORDER BY s.salary desc
;

-- 154543 rows returned - correct
	
/* ===========================================================================*/

/*
-- 6.  How many current salaries are within 1 standard deviation of the highest salary?
(Hint: you can use a built in function to calculate the standard deviation.)
What percentage of all salaries is this?  (s/b 78 salaries)
*/

SELECT COUNT(*) / (SELECT COUNT(*) FROM salaries WHERE to_date >NOW())
-- this second piece of logic above creates the percentage of all current salaries
/* the logic immediately below would select only those specific fields to present,
not as counts or percentages. */
-- SELECT e.first_name
--  ,e.last_name
--  ,s.salary
FROM employees e
JOIN salaries s
	ON e.emp_no = s.emp_no
WHERE salary >=
 	(
    (SELECT MAX(salary)
    FROM salaries)
    -
    (SELECT STDDEV(salary)
    FROM salaries)
    )
	AND to_date > NOW()
ORDER BY salary DESC
;
-- 78 rows returned - correct




/* BONUS
Find all the department names that currently have female managers.

+-----------------+
| dept_name       |
+-----------------+
| Development     |
| Finance         |  */


SELECT dept_name
FROM departments
WHERE dept_no IN (
	SELECT dept_no
    FROM dept_manager
    WHERE emp_no IN (
		SELECT emp_no
        FROM employees
        WHERE gender = 'F'
        )
		AND to_date >NOW()
	)
    ;


-- Find the first and last name of the employee with the highest salary.

SELECT emp_no
FROM salaries
WHERE emp_no = (
	SELECT emp_no
    FROM salaries
    WHERE salary = (
		SELECT MAX(salary)
		FROM salaries
		)
;

-- or, see below

SELECT first_name, last_name
FROM employees
WHERE emp_no = (
	SELECT emp_no
	FROM salaries
	ORDER BY salary DESC
	LIMIT 1
	)
;

-- Find the department name that the employee with the highest salary works in.

SELECT dept_name
FROM departments
WHERE dept_no = (
	SELECT dept_no
	FROM dept_emp
	WHERE emp_no = (
		SELECT emp_no
		FROM employees
		WHERE emp_no = (
			SELECT emp_no
			FROM salaries
			ORDER BY salary DESC
			LIMIT 1
            )
		)
	)
;
-- 1 row returned.  correct



