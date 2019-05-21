USE employees;

/*Query 1*/
SELECT DeptF, (SalF/SalM) AS 'FemaleSalaryRatio'
FROM
	(SELECT D.dept_name AS 'DeptM', AVG(S.salary) AS 'SalM' 
	FROM salaries S  
	JOIN employees E ON S.emp_no=E.emp_no 
	JOIN dept_emp DE ON E.emp_no=DE.emp_no 
	JOIN departments D ON DE.dept_no=D.dept_no
	WHERE E.gender='M'
	GROUP BY D.dept_name) AS T1
,
	(SELECT D2.dept_name AS 'DeptF', AVG(S2.salary) AS 'SalF' 
	FROM salaries S2 
	JOIN employees E2 ON S2.emp_no=E2.emp_no 
	JOIN dept_emp DE2 ON E2.emp_no=DE2.emp_no 
	JOIN departments D2 ON DE2.dept_no=D2.dept_no
	WHERE E2.gender='F'
	GROUP BY D2.dept_name) AS T2
WHERE DeptM=DeptF
ORDER BY FemaleSalaryRatio DESC;


/*Query 2*/


SELECT D.dept_name, E.first_name, E.last_name, DM.from_date, DM.to_date, (DM.to_date - DM.from_date) AS 'Tenure'
FROM dept_manager DM 
JOIN employees E ON DM.emp_no = E.emp_no
JOIN departments D ON D.dept_no=DM.dept_no
GROUP BY D.dept_name
ORDER BY (DM.to_date - DM.from_date) DESC;


/*Query 3*/
(SELECT avg(s.salary) as "Avg Salary and Employee Count by Decade [1950-1970]"
FROM salaries s, employees e
WHERE s.emp_no = e.emp_no AND e.birth_date between "1950-01-01" and "1960-01-01"
GROUP BY 
)
union all
(SELECT avg(s.salary) 
FROM salaries s, employees e
WHERE s.emp_no = e.emp_no AND e.birth_date between "1960-01-02" and "1970-01-01"
)
union all
(SELECT count(e.emp_no) as "test"
FROM employees e
WHERE e.birth_date between "1950-01-02" and "1960-01-01"
)
union all
(SELECT count(e.emp_no) 
FROM employees e
WHERE e.birth_date between "1960-01-02" and "1970-01-01"
);

/* Query 4*/
SELECT DISTINCT e.first_name, e.last_name
FROM employees as e, salaries as s, dept_manager as d
WHERE e.gender = 'F' AND e.birth_date < '1990-01-01' AND e.emp_no = s.emp_no AND s.salary > 80000 AND e.emp_no = d.emp_no;




/* Query 5a one degree of separation */
SELECT e1.dept_no
FROM dept_emp e1
JOIN dept_emp e2
ON e1.dept_no = e2.dept_no
WHERE e1.emp_no = '10001' AND e2.emp_no = '10006'
AND e1.from_date<=e2.from_date
AND e1.to_date>=e2.to_date;
	

/* Query 5b 2 degrees of separation */
SELECT e1.dept_no, e3.dept_no
FROM dept_emp e1
JOIN dept_emp e2
ON e1.dept_no = e2.dept_no
JOIN dept_emp e3
ON e2.dept_no = e3.dept_no
WHERE e1.emp_no = 10003 AND e3.emp_no = 10009
AND e1.emp_no != e2.emp_no
AND e1.from_date<=e2.from_date
AND e1.to_date>=e2.to_date
AND e2.from_date<=e3.from_date
AND e2.to_date>=e3.to_date;

