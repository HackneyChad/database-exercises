USE join_example_db;
SHOW TABLES;
DESCRIBE roles;
DESCRIBE users;

SELECT * FROM roles;
-- 4 rows returned ('four roles')

SELECT * FROM users;
-- 6 rows returned ('six users')

SELECT *
FROM users
JOIN roles
	ON users.id = roles.id
;
-- 4 rows returned, includes NO rows containing NULLs.

/* Below:  left join from users to roles, results in six rows, to include all the users, 
even if they have no defined role_id or is null.  Reversing the users/roles table locations
in this query (swap left vs right) results in only four rows (looks similar to query above), and excludes the nulls
that are present in the users table. */

SELECT *
FROM users
LEFT JOIN roles
	ON users.id = roles.id
;
-- 6 rows returned, including rows containing NULLs.

SELECT *
FROM roles
LEFT JOIN users
	ON users.id = roles.id
;
-- 4 rows returned, includes NO rows containing NULLs.

SELECT *
FROM roles
RIGHT JOIN users
	ON users.id = roles.id
;
-- 6 rows returned, including rows containing NULLs.
-- RIGHT JOIN FROM roles TO users generates the same results as LEFT JOIN FROM users TO roles.


/* Aggregate functions like COUNT can be used with JOIN queries.
Use COUNT and the appropriate JOIN type to get a list of roles
along with the number of users that has the role.
Hint: You will also need to use GROUP BY in the query. */

SELECT roles.name AS roles_name
 	,roles.id AS roles_id
    ,users.role_id AS users_role_id
	,COUNT(users.role_id) AS user_ct_by_role
FROM roles
LEFT JOIN users
	ON roles.id = users.role_id
GROUP BY roles.name, roles.id, users.role_id
ORDER BY roles.id
;
-- 4 rows returned

/* ===========================================================================*/

/* Using the example in the Associative Table Joins section as a guide,
write a query that shows each department along with the name of
the current manager for that department. */

USE employees;
SHOW TABLES;
DESCRIBE departments;
DESCRIBE dept_manager;

SELECT * FROM departments;
-- 9 rows returned ('9 departments')

SELECT * FROM dept_manager;
-- 24 rows returned ('24 managers')

SELECT d.dept_name
	,CONCAT(e.first_name, ' ',e.last_name) AS mgr_name
FROM employees e
JOIN dept_manager dm
	ON e.emp_no = dm.emp_no
JOIN departments d
	ON dm.dept_no = d.dept_no
WHERE dm.to_date > NOW()
ORDER BY d.dept_name ASC
;
-- 9 rows returned


/* ===========================================================================*/

/* Find the name of all departments currently managed by women. */

SELECT d.dept_name
	,CONCAT(e.first_name, ' ',e.last_name) AS mgr_name
FROM employees e
JOIN dept_manager dm
	ON e.emp_no = dm.emp_no
JOIN departments d
	ON dm.dept_no = d.dept_no
WHERE dm.to_date > NOW()
	AND e.gender = 'F'
ORDER BY d.dept_name ASC
;
-- 4 rows returned


/* ===========================================================================*/

/* Find the current titles of employees currently working in the Customer Service department. */

SELECT t.title
	,COUNT(t.title) AS 'title_ct'
FROM titles t
JOIN dept_emp de
	ON t.emp_no = de.emp_no
JOIN departments d
	ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Customer Service'
	AND t.to_date > NOW()
	AND de.to_date > NOW()
GROUP BY t.title
;
-- 7 rows returned


/* ===========================================================================*/

/* Find the current salary of all current managers. */

SELECT d.dept_name AS 'Department_Name'
	,CONCAT(first_name, ' ',last_name) AS 'Manager_Name'
    ,s.salary AS 'Current_Salary'
FROM employees e
JOIN dept_manager dm
	ON e.emp_no = dm.emp_no
JOIN departments d
	ON dm.dept_no = d.dept_no
JOIN salaries s
	ON dm.emp_no = s.emp_no
WHERE dm.to_date > NOW()
	AND s.to_date > NOW()
ORDER BY Department_Name ASC, Manager_Name ASC
;
-- 9 rows returned


/* ===========================================================================*/

/* Find the number of employees in each department. */

SELECT de.dept_no
	,d.dept_name
	,COUNT(de.emp_no)
FROM dept_emp de
JOIN departments d
	ON de.dept_no = d.dept_no
WHERE de.to_date > NOW()  -- this grabs only current employees
GROUP BY de.dept_no, d.dept_name
ORDER BY de.dept_no
;
-- 9 rows returned

/* ===========================================================================*/

/* Which department has the highest average salary? */

SELECT d.dept_name
    ,AVG(s.salary) AS average_salary
FROM salaries s
JOIN dept_emp de
	ON s.emp_no = de.emp_no
JOIN departments d
	ON de.dept_no = d.dept_no
WHERE de.to_date > NOW()
	AND s.to_date > NOW()
GROUP BY d.dept_name
ORDER BY AVG(s.salary) DESC
LIMIT 1
;
-- 1 rows returned


/* ===========================================================================*/

/* Who is the highest paid employee in the Marketing department? */

SELECT e.first_name
	,e.last_name
FROM employees e
JOIN dept_emp de
	ON e.emp_no = de.emp_no
JOIN departments d
	ON de.dept_no = d.dept_no
JOIN salaries s
	ON e.emp_no = s.emp_no
WHERE d.dept_name = 'Marketing'
	AND de.to_date > NOW()
	AND s.to_date > NOW()
ORDER BY s.salary DESC
LIMIT 1
;
-- 1 row returned


/* ===========================================================================*/

/* Which current department manager has the highest salary? */

SELECT e.first_name
	,e.last_name
    ,s.salary
    ,d.dept_name
FROM employees e
JOIN dept_manager dm
	ON e.emp_no = dm.emp_no
JOIN departments d
	ON dm.dept_no = d.dept_no
JOIN salaries s
	ON dm.emp_no = s.emp_no
WHERE dm.to_date > NOW()
	AND s.to_date > NOW()
ORDER BY salary DESC
LIMIT 1
;
-- 1 rows returned


/* ===========================================================================*/

/* Bonus Find the names of all current employees,
their department name, and their current manager's name. */

SELECT CONCAT(e.first_name, ' ',e.last_name) AS employee_name
    ,d.dept_name 
   	,CONCAT(e2.first_name, ' ',e2.last_name) AS manager_name
FROM employees e
JOIN dept_emp de
	ON e.emp_no = de.emp_no
JOIN departments d
   	ON de.dept_no = d.dept_no
JOIN dept_manager dm
 	ON d.dept_no = dm.dept_no
JOIN employees e2
  	ON dm.emp_no = e2.emp_no
WHERE de.to_date > NOW()
  	AND dm.to_date > NOW()
ORDER BY dept_name
LIMIT 500
;


SELECT CONCAT(e.first_name, ' ',e.last_name) AS employee_name
    ,d.dept_name 
   	,CONCAT(e2.first_name, ' ',e2.last_name) AS manager_name
    ,s.salary
FROM salaries s
JOIN employees e
	ON e.emp_no = s.emp_no
JOIN dept_emp de
	ON e.emp_no = de.emp_no
JOIN departments d
   	ON de.dept_no = d.dept_no
JOIN dept_manager dm
 	ON d.dept_no = dm.dept_no
JOIN employees e2
  	ON dm.emp_no = e2.emp_no
WHERE de.to_date > NOW()
  	AND dm.to_date > NOW()
ORDER BY dept_name
LIMIT 1
;


/* ===========================================================================*/

/*
start with select all employees from employees table
then add on the dept_emp, via emp_no
then add on the departments, via dept_no
now add on the managers, via dept_no
now filter out historical on where filter
 */

SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee_name
	,d.dept_name
	,CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM employees e
JOIN dept_emp de
	ON e.emp_no = de.emp_no
JOIN departments d
	ON de.dept_no = d.dept_no
JOIN dept_manager dm
	ON d.dept_no = dm.dept_no
JOIN employees m
	ON m.emp_no = dm.emp_no
WHERE de.to_date > NOW()
	AND dm.to_date > NOW()
LIMIT 15
;


/* ===========================================================================*/
/* Bonus Find the highest paid employee in each department. */


	SELECT e.first_name
		,e.last_name
		,s.salary
		,d.dept_name
	FROM employees e
	JOIN dept_emp de
		ON e.emp_no = de.emp_no
	JOIN departments d
		ON de.dept_no = d.dept_no
	JOIN salaries s
		ON e.emp_no = s.emp_no
	WHERE d.dept_name = 'Customer Service'
		AND de.to_date > NOW()
		AND s.to_date > NOW()
	ORDER BY s.salary DESC
	LIMIT 1
UNION ALL
	SELECT e.first_name
		,e.last_name
		,s.salary
		,d.dept_name
	FROM employees e
	JOIN dept_emp de
		ON e.emp_no = de.emp_no
	JOIN departments d
		ON de.dept_no = d.dept_no
	JOIN salaries s
		ON e.emp_no = s.emp_no
	WHERE d.dept_name = 'Development'
		AND de.to_date > NOW()
		AND s.to_date > NOW()
	ORDER BY s.salary DESC
	LIMIT 1;


/* ===========================================================================*/

/* example of subquery, grabbing manager emp_no's from dept_manager table,
and then using them in an IN clause in a WHERE statement,
to grab those person's f/l names and b-dates from employees table. */

SELECT e.first_name, e.last_name, e.birth_date
FROM employees e
WHERE e.emp_no IN (
    SELECT dm.emp_no
    FROM dept_manager dm )
LIMIT 10;


