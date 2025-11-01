/*
15 Days of Learning SQL

Julia conducted a 15 days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least  submission each day (starting on the first day of the contest), and find the hacker_id and name of the hacker who made maximum number of submissions each day. If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.

*/

;WITH grouped AS (SELECT s.submission_date,
                          s.hacker_id,
                          h.name,
                          COUNT(1) as submission_cnt
                  FROM Submissions s 
                  INNER JOIN Hackers h on s.hacker_id = h.hacker_id 
                  GROUP BY submission_date, s.hacker_id, h.name), 
      counted AS(SELECT submission_date,
                        date_counter = 1 + DATEDIFF(DAY, (SELECT MIN(submission_date) FROM submissions), submission_date),
                        COUNT(submission_date) OVER (PARTITION BY hacker_id ORDER BY submission_date 
                                                          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS counter, 
                        ROW_NUMBER() OVER (PARTITION BY submission_date ORDER BY submission_cnt DESC, hacker_id ASC) AS RN, 
                        hacker_id,
                        name 
                 FROM grouped) 
SELECT submission_date,
       SUM(CASE WHEN date_counter = counter THEN 1 ELSE 0 END) as everyday_check, 
       MAX(CASE WHEN RN = 1 THEN hacker_id ELSE -1 END) as most_submission_hacker_id, 
       MAX(CASE WHEN RN = 1 THEN name ELSE '' END) as most_submission_hacker_name  
FROM counted 
GROUP BY submission_date
ORDER BY submission_date 
