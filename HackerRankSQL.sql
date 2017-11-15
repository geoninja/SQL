/* HACKER RANK SQL PRACTICE */



/* TABLE: STATION (WEATHER OBSERVATION STATION 4) */
/* 1. Let N be the number of CITY entries in STATION, and let N' be the number of distinct CITY names in STATION; query the value of N - N' from STATION. In other words, find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table. */

-- SELECT (TOTAL - UNIQ) AS DIFF
-- FROM (SELECT COUNT(CITY) AS TOTAL,
--         (SELECT COUNT(DISTINCT CITY) FROM STATION) AS UNIQ
--             FROM STATION) S;

SELECT COUNT(*) - COUNT(DISTINCT CITY)
FROM STATION;

/* #RETURNS 13 */



/* TABLE: STATION (WEATHER OBSERVATION STATION 5) */
/* 2. Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically. */

-- (SELECT CITY, CHAR_LENGTH(CITY)
-- FROM STATION
-- WHERE CHAR_LENGTH(CITY) = (SELECT MIN(CHAR_LENGTH(CITY)) FROM STATION)
-- ORDER BY CITY ASC LIMIT 1)
-- UNION
-- (SELECT CITY, CHAR_LENGTH(CITY)
-- FROM STATION
-- WHERE CHAR_LENGTH(CITY) = (SELECT MAX(CHAR_LENGTH(CITY)) FROM STATION)
-- ORDER BY CITY ASC LIMIT 1);

(SELECT CITY,
     (CHAR_LENGTH(CITY)) AS LEN
FROM STATION
ORDER BY  LEN, CITY ASC LIMIT 1)
UNION
(SELECT CITY,
     (CHAR_LENGTH(CITY)) AS LEN
FROM STATION
ORDER BY  LEN DESC, CITY ASC LIMIT 1);

/* #RETURNS
Amo 3
Marine On Saint Croix 21 */



/* TABLE: STATION (WEATHER OBSERVATION STATION 6) */
/* 3. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates. */

SELECT DISTINCT CITY
FROM STATION
WHERE SUBSTRING(CITY, 1, 1) IN ('A', 'E', 'I', 'O', 'U');



/* TABLE: STATION (WEATHER OBSERVATION STATION 8) */
/* 4. Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates. */

SELECT DISTINCT CITY
FROM STATION
WHERE SUBSTRING(CITY, 1, 1) IN ('A', 'E', 'I', 'O', 'U')
AND SUBSTRING(CITY, -1, 1) IN ('A', 'E', 'I', 'O', 'U');



/* TABLE: STUDENTS (Higher than 75 Marks) */
/* 5. Query the Name of any student in STUDENTS who scored higher than 75 Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID. */

SELECT NAME
FROM STUDENTS
WHERE MARKS > 75
ORDER BY SUBSTRING(NAME, -3), ID ASC;



/* TABLE: TRIANGLES (Type of Triangles) */
/* 6. Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:

Not A Triangle: The given values of A, B, and C don't form a triangle.
Equilateral: It's a triangle with  sides of equal length.
Isosceles: It's a triangle with  sides of equal length.
Scalene: It's a triangle with  sides of differing lengths.
*/

SELECT *,
    CASE
    WHEN NOT((A + B) > C
        AND (B + C) > A
        AND (A + C) > B) THEN
    'Not A Triangle'
    WHEN (A = B
        AND B = C) THEN
    'Equilateral'
    WHEN (A = B
        OR B = C
        OR A = C) THEN
    'Isosceles'
    ELSE 'Scalene'
    END AS TYPE_OF_TRIANGLE
FROM TRIANGLES;



/* TABLE: OCCUPATIONS (The Pads) */
/* 7. PADS - Generate the following two result sets:

Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses).
For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).

Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format:
There are total [occupation_count] [occupation]s. */

(SELECT CONCAT(NAME,
     '(', SUBSTRING(OCCUPATION, 1, 1), ')')
FROM OCCUPATIONS
ORDER BY  NAME ASC LIMIT 100)
UNION
(SELECT CONCAT('There are total ', COUNT(OCCUPATION), ' ', LOWER(OCCUPATION), 's.')
FROM OCCUPATIONS
GROUP BY  OCCUPATION
ORDER BY  COUNT(OCCUPATION), OCCUPATION ASC LIMIT 4);



/* TABLE: OCCUPATIONS (Occupations) */
/* 8. Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.
Note: Print NULL when there are no more names corresponding to an occupation. */

CREATE TABLE occupations (
  id INT(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) DEFAULT NULL,
  occupation VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id)
);
INSERT INTO occupations VALUES
(1, 'Ashley', 'Professor'),
(2, 'Samantha', 'Actor'),
(3, 'Julia', 'Doctor'),
(4, 'Britney', 'Professor'),
(5, 'Maria', 'Professor'),
(6, 'Meera', 'Professor'),
(7, 'Priya', 'Doctor'),
(8, 'Priyanka', 'Professor'),
(9, 'Jennifer', 'Actor'),
(10, 'Ketty', 'Actor'),
(11,'Belvet', 'Professor'),
(12, 'Naomi', 'Professor'),
(13, 'Jane', 'Singer'),
(14, 'Jenny', 'Singer'),
(15, 'Kristeen', 'Singer'),
(16, 'Christeen', 'Singer'),
(17, 'Eve', 'Actor'),
(18, 'Aamina', 'Doctor');


/* SOLUTION!!! */
SELECT
  MAX(IF(OCCUPATION = 'Doctor', NAME, NULL)) AS DOCTOR,
  MAX(IF(OCCUPATION = 'Professor', NAME, NULL)) AS PROFESSOR, /* MIN instead of MAX also works */
  MAX(IF(OCCUPATION = 'Singer', NAME, NULL)) AS SINGER,
  MAX(IF(OCCUPATION = 'Actor', NAME, NULL)) AS ACTOR
FROM
    (SELECT a.OCCUPATION,
         a.NAME,
         COUNT(*) AS ROW_NUMBER
    FROM OCCUPATIONS a
    JOIN OCCUPATIONS b
        ON a.OCCUPATION = b.OCCUPATION
            AND a.NAME >= b.NAME
    GROUP BY  a.NAME ) t
GROUP BY  ROW_NUMBER;

/* I got ideas from here: http://buysql.com/mysql/14-how-to-automate-pivot-tables.html
and here: http://stackoverflow.com/questions/1895110/row-number-in-mysql?noredirect=1&lq=1
/*


/* ANOTHER SOLUTION (to improve) from HackerRank: */
set @r1=0, @r2=0, @r3=0, @r4=0;
SELECT
  MIN(Doctor),
  MIN(Professor),
  MIN(Singer),
  MIN(Actor)
FROM
  (SELECT
    CASE
    WHEN Occupation='Doctor' THEN (@r1:=@r1+1)
    WHEN Occupation='Professor' THEN (@r2:=@r2+1)
    WHEN Occupation='Singer' THEN (@r3:=@r3+1)
    WHEN Occupation='Actor' THEN (@r4:=@r4+1)
    END AS RowNumber,
    CASE
    WHEN Occupation='Doctor' THEN Name
    END AS Doctor,
    CASE
    WHEN Occupation='Professor' THEN Name
    END AS Professor,
    CASE
    WHEN Occupation='Singer' THEN Name
    END AS Singer,
    CASE
    WHEN Occupation='Actor' THEN Name
    END AS Actor
FROM OCCUPATIONS
ORDER BY  Name ) Temp
GROUP BY  RowNumber;


/* sample code: */
SELECT t.*, @rownum := @rownum + 1 AS row_number
FROM OCCUPATIONS AS t,
(SELECT @rownum := 0) r
group by t.name;



/* TABLE: BST (BINARY TREE NODES) */
/* 9. You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N. Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:

Root: If node is root node.
Leaf: If node is leaf node.
Inner: If node is neither root nor leaf node.
*/

SELECT N,
  CASE
    WHEN P IS NULL THEN "Root"
    WHEN N IN (SELECT P FROM BST) THEN "Inner"
    ELSE "Leaf"
  END
FROM BST
ORDER BY N;


/* Another solution, less efficient */
-- SET @root = (SELECT N FROM BST WHERE P IS NULL);
-- SELECT N,
--   CASE
--     WHEN P IS NULL THEN "Root"
--     WHEN P = @root
--       OR P IN
--       (SELECT N FROM BST WHERE P = @root) THEN "Inner"
--     ELSE "Leaf"
--   END
-- FROM BST
-- ORDER BY N;


/* Yet another solution, also less efficient, using idea similar to: WHEN N IN (SELECT P FROM BST), i.e.
while there are values of N = P after each iteration, then node is "Inner" type */

-- SELECT N,
--     IF(P IS NULL,'Root',
--        IF((SELECT COUNT(*) FROM BST WHERE P = B.N)>0,'Inner','Leaf'))
-- FROM BST AS B
-- ORDER BY N;



/* 10. "NEW COMPANIES": Amber's conglomerate corporation just acquired some new companies. Each of the companies follows an hierarchy.

Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.

Note:
The tables may contain duplicate records.
The company_code is string, so the sorting should not be numeric. For example, if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2. */

/*Work in progress */

SELECT COMPANY_CODE, COUNT(*) FROM EMPLOYEE
GROUP BY COMPANY_CODE;

SELECT COUNT(DISTINCT COMPANY_CODE) FROM EMPLOYEE #100 COMPANIES, 1992 EMPLOYEES


SELECT C.COMPANY_CODE, C.FOUNDER, L.LEAD_MANAGER_CODE, S.SENIOR_MANAGER_CODE,
	M.MANAGER_CODE, E.EMPLOYEE_CODE, COUNT(*)
FROM COMPANY C
JOIN LEAD_MANAGER L
ON C.COMPANY_CODE = L.COMPANY_CODE
JOIN SENIOR_MANAGER S
ON S.COMPANY_CODE = L.COMPANY_CODE AND S.LEAD_MANAGER_CODE = L.LEAD_MANAGER_CODE
JOIN MANAGER M
ON M.COMPANY_CODE = S.COMPANY_CODE AND M.LEAD_MANAGER_CODE = S.LEAD_MANAGER_CODE
                                   AND M.SENIOR_MANAGER_CODE = S.SENIOR_MANAGER_CODE
JOIN EMPLOYEE E
ON E.COMPANY_CODE = M.COMPANY_CODE AND E.LEAD_MANAGER_CODE = M.LEAD_MANAGER_CODE
                                   AND E.SENIOR_MANAGER_CODE = M.SENIOR_MANAGER_CODE
                                   AND E.MANAGER_CODE = M.MANAGER_CODE

GROUP BY COMPANY_CODE;





SELECT C.COMPANY_CODE, C.FOUNDER, L.LEAD_MANAGER_CODE, S.SENIOR_MANAGER_CODE, M.MANAGER_CODE, E.EMPLOYEE_CODE
FROM COMPANY C
JOIN LEAD_MANAGER L
ON C.COMPANY_CODE = L.COMPANY_CODE
JOIN SENIOR_MANAGER S
ON S.COMPANY_CODE = L.COMPANY_CODE
JOIN MANAGER M
ON M.COMPANY_CODE = S.COMPANY_CODE
JOIN EMPLOYEE E
ON E.COMPANY_CODE = M.COMPANY_CODE
GROUP BY C.COMPANY_CODE, C.FOUNDER, L.LEAD_MANAGER_CODE, S.SENIOR_MANAGER_CODE, M.MANAGER_CODE, E.EMPLOYEE_CODE;



SELECT C.COMPANY_CODE, C.FOUNDER, COUNT(L.LEAD_MANAGER_CODE),
	   COUNT(S.SENIOR_MANAGER_CODE), COUNT(M.MANAGER_CODE), COUNT(E.EMPLOYEE_CODE)
FROM COMPANY C
JOIN...












/* MySQL Documentation Notes */

/* Note: in MySQL, GROUP BY automatically sorts by that key, but this is not guaranteedacross RDMS:
http://stackoverflow.com/questions/28149876
does-group-by-automatically-guarantee-order-by
"An efficient implementation of group by would perform the group-ing by sorting the data internally. That's why some RDBMS return sorted output when group-ing. Yet, the SQL specs don't mandate that behavior, so unless explicitly documented by the RDBMS vendor I wouldn't bet on it to work (tomorrow). OTOH, if the RDBMS implicitly does a sort it might also be smart enough to then optimize (away) the redundant order by". */


/*### EXISTS function provides a simple way to find intersection between tables (INTERSECT operator from relational model). If we have table1 and table2, both having id and value columns, the intersection could be calculated like this: */

SELECT * FROM table1
  WHERE EXISTS
  (SELECT * FROM table2
      WHERE table1.id=table2.id
      AND table1.value=table2.value)


/* ### A CORRELATED SUBQUERY is a subquery that contains a reference to a table that also appears in the outer query. For example: */

SELECT *
FROM t1
WHERE column1 = ANY
  (SELECT column1
    FROM t2
    WHERE t2.column2 = t1.column2);

/* Scoping rule: MySQL evaluates from inside to outside.

For certain cases, a correlated subquery is optimized. For example:

val IN (SELECT key_val FROM tbl_name WHERE correlated_condition)

Otherwise, they are inefficient and likely to be slow. Rewriting the query as a join
might improve performance.
*/


/* ### A DERIVED TABLE is a subquery in a SELECT statement FROM clause.
Suppose that you want to know the average of a set of sums for a grouped table.
This does not work: */

SELECT AVG(SUM(column1)) FROM t1 GROUP BY column1;

/* However, this query provides the desired information: */

SELECT AVG(sum_column1)
  FROM (SELECT SUM(column1) AS sum_column1
        FROM t1 GROUP BY column1) AS t1;


/* ### REWRITING SUBQUERIES AS JOINS:
On some occasions, it is not only possible to rewrite a query without a subquery, but it can be more efficient to make use of some of these techniques rather than to use subqueries. One of these is the IN() construct. For example, this query: */

SELECT * FROM t1 WHERE id IN (SELECT id FROM t2);

/* Can be rewritten as: */

SELECT DISTINCT t1.* FROM t1, t2 WHERE t1.id=t2.id;


/* The queries: */

SELECT * FROM t1 WHERE id NOT IN (SELECT id FROM t2);
SELECT * FROM t1 WHERE NOT EXISTS (SELECT id FROM t2 WHERE t1.id=t2.id);

/* Can be rewritten as: */

SELECT table1.*
  FROM table1 LEFT JOIN table2 ON table1.id=table2.id
  WHERE table2.id IS NULL;

/* A LEFT [OUTER] JOIN can be faster than an equivalent subquery because the server might be able to optimize it better_a fact that is not specific to MySQL Server alone. */


/* ### Task: For each article, find the dealer or dealers with the most expensive price. This problem can be solved with a subquery like this one: */

SELECT article, dealer, price
FROM   shop s1
WHERE  price=(SELECT MAX(s2.price)
              FROM shop s2
              WHERE s1.article = s2.article);

+---------+--------+-------+
| article | dealer | price |
+---------+--------+-------+
|    0001 | B      |  3.99 |
|    0002 | A      | 10.99 |
|    0003 | C      |  1.69 |
|    0004 | D      | 19.95 |
+---------+--------+-------+
/* The preceding example uses a correlated subquery, which can be inefficient.
Other possibilities for solving the problem are to use an uncorrelated subquery in the FROM clause or a LEFT JOIN. */

/* Uncorrelated subquery: */

SELECT s1.article, dealer, s1.price
FROM shop s1
JOIN (
  SELECT article, MAX(price) AS price
  FROM shop
  GROUP BY article) AS s2
  ON s1.article = s2.article AND s1.price = s2.price;


/* LEFT JOIN: */

SELECT s1.article, s1.dealer, s1.price
FROM shop s1
LEFT JOIN shop s2 ON s1.article = s2.article AND s1.price < s2.price
WHERE s2.article IS NULL;

/* The LEFT JOIN works on the basis that when s1.price is at its maximum value, there is no s2.price with a greater value and the s2 rows values will be NULL. */


/* ### USER DEFINED VARIABLES: */
/* For example, to find the articles with the highest and lowest price you can do this: */

mysql> SELECT @min_price:=MIN(price),@max_price:=MAX(price) FROM shop;
mysql> SELECT * FROM shop WHERE price=@min_price OR price=@max_price;
+---------+--------+-------+
| article | dealer | price |
+---------+--------+-------+
|    0003 | D      |  1.25 |
|    0004 | D      | 19.95 |
+---------+--------+-------+


/* REVIEW:
data types
9.2.1 Optimizing SELECT Statements
/*









