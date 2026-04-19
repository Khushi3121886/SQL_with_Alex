DROP DATABASE IF EXISTS `Parks_and_Recreation`;
CREATE DATABASE `Parks_and_Recreation`;
USE `Parks_and_Recreation`;






CREATE TABLE employee_demographics (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (employee_id)
);

CREATE TABLE employee_salary (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT
);


INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1,'Leslie', 'Knope', 44, 'Female','1979-09-25'),
(3,'Tom', 'Haverford', 36, 'Male', '1987-03-04'),
(4, 'April', 'Ludgate', 29, 'Female', '1994-03-27'),
(5, 'Jerry', 'Gergich', 61, 'Male', '1962-08-28'),
(6, 'Donna', 'Meagle', 46, 'Female', '1977-07-30'),
(7, 'Ann', 'Perkins', 35, 'Female', '1988-12-01'),
(8, 'Chris', 'Traeger', 43, 'Male', '1980-11-11'),
(9, 'Ben', 'Wyatt', 38, 'Male', '1985-07-26'),
(10, 'Andy', 'Dwyer', 34, 'Male', '1989-03-25'),
(11, 'Mark', 'Brendanawicz', 40, 'Male', '1983-06-14'),
(12, 'Craig', 'Middlebrooks', 37, 'Male', '1986-07-27');


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000,1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000,1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000,1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000,1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000,1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000,1),
(7, 'Ann', 'Perkins', 'Nurse', 55000,4),
(8, 'Chris', 'Traeger', 'City Manager', 90000,3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000,6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner and Musician', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3),
(12, 'Craig', 'Middlebrooks', 'Parks Director', 65000,1);



CREATE TABLE parks_departments (
  department_id INT NOT NULL AUTO_INCREMENT,
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (department_id)
);

INSERT INTO parks_departments (department_name)
VALUES
('Parks and Recreation'),
('Animal Control'),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');

SELECT *
FROM employee_demographics;

SELECT first_name, last_name, birth_date
FROM employee_demographics;

SELECT * 
FROM employee_demographics
WHERE 
birth_date > "1985-01-01"
AND gender = "Female";

-- string funtions
SELECT *
FROM
employee_demographics;

SELECT LENGTH('shreyas');
SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;

-- TRIM
SELECT TRIM("    sky      ");
SELECT RTRIM("    sky      ");
SELECT LTRIM("    sky      ");

SELECT first_name,
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(birth_date, 6, 2) as birth_month
FROM
employee_demographics;

SELECT REPLACE(first_name, 'a', 'z')
FROM
employee_demographics;

SELECT LOCATE("x", "Alex");

SELECT first_name, LOCATE("an", first_name)
FROM
employee_demographics;

-- day 3
use parks_and_recreation;
SELECT first_name, last_name,
CONCAT(first_name, " ", last_name) as full_name
from employee_demographics;

-- case statements
-- pay increase and bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- finance = 10% bonus
select * from employee_salary;
SELECT employee_id, first_name, last_name, salary,
CASE 
    WHEN salary < 50000 THEN salary + (0.5 * salary)
    WHEN salary > 50000 THEN salary * 1.07 
END AS new_salary,
CASE
    WHEN dept_id = 6 THEN salary * 0.10
END AS bonus
FROM employee_salary;

-- subquery
SELECT * FROM employee_demographics
WHERE employee_id IN(SELECT employee_id
					 FROM employee_salary
                     WHERE dept_id = 1);

SELECT first_name, salary,
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary;

-- SUBQUERY IN FROM 
SELECT AVG(max_age) FROM
(SELECT gender, AVG(age), MAX(age) as max_age, COUNT(age)
FROM employee_demographics
GROUP BY gender) AS agg_table  ;

-- day 3
-- window functions
SELECT gender, avg(salary)
FROM employee_demographics as dem
Join employee_salary as sal
ON dem.employee_id = sal.employee_id
group by gender;  

-- rolling total
SELECT gender, salary, dem.first_name, dem.last_name,
sum(salary) over(partition by gender order by dem.employee_id) as rolling_total
from employee_demographics dem
JOIN employee_salary sal  
on dem.employee_id = sal.employee_id;      

-- row number, rank, dense rank
SELECT dem.employee_id, dem.first_name, dem.last_name, gender,salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) as row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) as rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) as dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;
-- CTE's
WITH cte_example as
(
SELECT gender, max(salary) AS max_sal, min(salary) as min_sal, avg(salary) as avg_sal
from employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id
group by gender
)
SELECT AVG(avg_sal)
FROM cte_example;

SELECT AVG(avg_sal) from(
SELECT gender, max(salary) AS max_sal, min(salary) as min_sal, avg(salary) as avg_sal
from employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id
group by gender
) as subquery_ex;
-- complex cte
with cte_example as
(
select employee_id, birth_date, gender
from employee_demographics
where birth_date > "1985-01-01"
),
cte_example2 as
(
select employee_id, salary
from employee_salary
where salary > 50000
)
select * 
from cte_example
join cte_example2
on cte_example.employee_id = cte_example2.employee_id;

-- temporary table
CREATE TEMPORARY TABLE Temp_table
(first_name varchar(50),
last_name varchar(50),
fav_movie varchar(100)
);

select * from temp_table;
INSERT INTO temp_table
values("Khushi", "Srinivas", "Shreyas");

CREATE TEMPORARY TABLE salary_over_50k
SELECT * 
FROM employee_salary
where salary >= 50000;

select * from salary_over_50k;

-- stored procedure
DELIMITER $$
create procedure employee_salary_new(SP_employee_id INT)
BEGIN
select salary
from employee_salary
where employee_id = SP_employee_id;
END $$
DELIMITER ;
CALL employee_salary_new(1)

