/*
Exercises
	Exercise Goals

-- Use the GROUP BY clause to create more complex queries
-- Create a new file named 3.7_group_by_exercises.sql

In your script, use DISTINCT to find the unique titles in the titles table.
Your results should look like:

Senior Engineer
Staff
Engineer
Senior Staff
Assistant Engineer
Technique Leader
Manager
*/

USE employees_db;
SHOW TABLES;
DESCRIBE titles;


SELECT DISTINCT title
FROM titles;

-- or

SELECT title
FROM titles
GROUP BY title;


/*
Find your query for employees whose last names start and end with 'E'.
Update the query find just the unique last names that start and end with 'E' using GROUP BY.
The results should be:

Eldridge
Erbe
Erde
Erie
Etalle
*/

SELECT last_name
FROM employees
WHERE last_name LIKE 'e%e'
GROUP BY last_name
;


/*
Update your previous query to now find unique combinations of first and last name
where the last name starts and ends with 'E'. You should get 846 rows.
*/
SELECT DISTINCT first_name
	,last_name
    ,COUNT(*)
FROM employees
WHERE last_name LIKE 'e%e'
GROUP BY first_name, last_name
;
-- 846 rows returned


/*
Find the unique last names with a 'q' but not 'qu'.  Your results should be:
Chleq
Lindqvist
Qiwen
*/

SELECT DISTINCT last_name
FROM employees
WHERE (
 	last_name LIKE '%q%'
 	AND last_name NOT LIKE '%qu%'
     )
GROUP BY last_name
;


/*
INSTEAD OF ANSWERING THIS ITEM IMMEDIATELY BELOW, SEE ZACH'S QUESTION IN THE SLACK CHANNEL:
-- Add a COUNT() to your results and use ORDER BY to make it easier to find employees whose
unusual name is shared with others.

For exercise number 6, ignore the current wording, instead answer this question:
> Which (across all employees) name is the most common, the least common?
Find this for both first name, last name, and the combination of the two.
*/

-- LAST NAME - most common
SELECT DISTINCT last_name
	,COUNT(*)
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC
LIMIT 1
;
-- Baba, 226

-- LAST NAME - least common
SELECT DISTINCT last_name
	,COUNT(*)
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) ASC
LIMIT 1
;
-- Sadowsky, 145

-- FIRST NAME - most common
SELECT DISTINCT first_name
	,COUNT(*)
FROM employees
GROUP BY first_name
ORDER BY COUNT(first_name) DESC
LIMIT 1
;
-- Shahab, 295

-- FIRST NAME - least common
SELECT DISTINCT first_name
	,COUNT(*)
FROM employees
GROUP BY first_name
ORDER BY COUNT(*) ASC
LIMIT 1
;
-- Lech, 185

-- LAST/FIRST NAME combo - most common
SELECT CONCAT(last_name, ', ',first_name) AS last_first_combo
	,COUNT(*) AS name_count
FROM employees
GROUP BY CONCAT(last_name, ', ',first_name)
ORDER BY COUNT(*) DESC
LIMIT 1
;
-- Baalen, Rosalyn, 5

-- LAST/FIRST NAME combo - least common
SELECT CONCAT(last_name, ', ',first_name) AS last_first_combo
	,COUNT(*) AS name_count
FROM employees
GROUP BY CONCAT(last_name, ', ',first_name)
ORDER BY COUNT(*) ASC
LIMIT 1
;
-- Aamodt, Abdelkader, 1


/*
Update your query for 'Irena', 'Vidya', or 'Maya'.
Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names.
Your results should be:
441 M
268 F
*/

SELECT gender
    ,COUNT(gender) AS gender_count
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
GROUP BY gender
;
-- M 441
-- F 268


/*
Recall the query the generated usernames for the employees from the last lesson.
Are there any duplicate usernames?

Bonus: how many duplicate usernames are there?
*/

SELECT LOWER(CONCAT(
	SUBSTR(first_name,1,1)
		,SUBSTR(last_name,1,4)
		,'_'
		,SUBSTR(birth_date,6,2)
		,SUBSTR(birth_date,3,2)
		)) AS user_name
    ,COUNT(*) AS user_name_ct
FROM employees
GROUP BY user_name
ORDER BY user_name_ct DESC
;



