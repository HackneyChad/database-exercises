-- view the structure of the employees table - done

-- Use the employees database - done
	USE employees;

-- List all the tables in the database - done
	SHOW TABLES;
    /* 'current_dept_emp'
	'departments'
	'dept_emp'
	'dept_emp_latest_date'
	'dept_manager'
	'employees'
	'salaries'
	'titles'
	*/

-- Explore the employees table.
	DESCRIBE employees;

-- What different data types are present on this table?
	-- int(11),
	-- date,
	-- varchar(14),
	-- varchar(16),
	-- enum('M','F')

-- Which table(s) do you think contain a numeric type column?
	-- 'salaries' table, or anyplace employee number listed

-- Which table(s) do you think contain a string type column?
	-- nearly all tables contain a string field

-- Which table(s) do you think contain a date type column?
	-- salaries, and almost all the others

-- What is the relationship between the employees and the departments tables?
	/* They are linked by the dept_emp table, which lists department IDs and employee IDs, per employee. */

-- Show the SQL that created the dept_manager table.
	SHOW CREATE TABLE dept_manager;
    
	/* CREATE TABLE `dept_manager` (
	`emp_no` int(11) NOT NULL,
	`dept_no` char(4) NOT NULL,
	`from_date` date NOT NULL,
	`to_date` date NOT NULL,
	PRIMARY KEY (`emp_no`,`dept_no`),
	KEY `dept_no` (`dept_no`),
	CONSTRAINT `dept_manager_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) ON DELETE CASCADE,
	CONSTRAINT `dept_manager_ibfk_2` FOREIGN KEY (`dept_no`) REFERENCES `departments` (`dept_no`) ON DELETE CASCADE
	) ENGINE=InnoDB DEFAULT CHARSET=latin1
	*/






