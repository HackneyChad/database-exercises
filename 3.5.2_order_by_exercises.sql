-- Create a new file named 3.5.2_order_by_exercises.sql and copy in the contents of your exercise
-- from the previous lesson.
-- done

USE employees;
DESCRIBE employees;

SELECT *
FROM employees
LIMIT 25
;

-- Modify your first query to order by first name.
-- The first result should be Irena Reutenauer and the last result should be Vidya Simmen.
-- correct

SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER by first_name ASC -- last_name ASC
;
-- 709 rows returned - correct

-- Update the query to order by first name and then last name.
-- The first result should now be Irena Acton and the last should be Vidya Zweizig.
-- correct

SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER by first_name ASC, last_name ASC
;
-- 709 rows returned - correct

-- Change the order by clause so that you order by last name before first name.
-- Your first result should still be Irena Acton but now the last result should be Maya Zyda.
-- correct

SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER by last_name ASC, first_name ASC
;
-- 709 rows returned - correct


-- Update your queries for employees with 'E' in their last name to sort the results by their employee number.
-- Your results should not change!
-- correct

SELECT *
FROM employees
WHERE last_name LIKE 'e%'
ORDER by emp_no ASC
;
-- 7,330 rows returned - correct

SELECT *
FROM employees
WHERE last_name LIKE 'e%'
	OR last_name LIKE '%e'
ORDER by emp_no ASC
;
-- 30,723 rows returned - correct


-- Now reverse the sort order for both queries.
-- correct

SELECT *
FROM employees
WHERE last_name LIKE 'e%'
ORDER by emp_no DESC
;
-- 7,330 rows returned - correct

SELECT *
FROM employees
WHERE last_name LIKE 'e%'
	OR last_name LIKE '%e'
ORDER by emp_no DESC
;
-- 30,723 rows returned - correct


-- Change the query for employees hired in the 90s and born on Christmas such that the first result
-- is the oldest employee who was hired last. It should be Khun Bernini.
-- correct

SELECT *
FROM employees
WHERE (
	-- hire_date BETWEEN '1990-01-01' AND '1999-12-31' -- 362
	hire_date LIKE '199%'  -- 362
    AND birth_date LIKE '%-12-25'
    )
ORDER BY birth_date ASC, hire_date DESC
;
-- 362 rows returned - correct




