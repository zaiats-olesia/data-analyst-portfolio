/*
New Companies

Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy: 

Founder -> Lead Manager -> Senior Manager -> Manager -> Employee

Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.

Note:
The tables may contain duplicate records.
The company_code is string, so the sorting should not be numeric. For example, if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2.

*/

SELECT c.company_code,
       c.founder,
       COUNT(DISTINCT e.lead_manager_code) as leads,
       COUNT(DISTINCT e.senior_manager_code) as seniors,
       COUNT(DISTINCT e.manager_code) as managers,
       COUNT(DISTINCT e.employee_code) as employers
FROM Employee e
INNER JOIN Company c on c.company_code = e.company_code
GROUP BY c.company_code, c.founder
ORDER BY c.company_code ASC;