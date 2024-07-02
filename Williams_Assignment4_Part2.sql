/*
    Name: Tiffany Williams
    DTSC660: Data and Database Managment with SQL
    Module 6
    Assignment 4- PART 2
*/

--------------------------------------------------------------------------------
/*				                 Query 1            		  		          */
--------------------------------------------------------------------------------

SELECT c.cust_ID, d.account_number, b.loan_number
FROM customer c
JOIN depositor d ON c.cust_ID = d.cust_ID
JOIN borrower b ON c.cust_ID = b.cust_ID;

--------------------------------------------------------------------------------
/*				                  Query 2           		  		          */
--------------------------------------------------------------------------------

SELECT c.cust_ID, c.customer_city, b.branch_city, b.branch_name, a.account_number
FROM customer c
JOIN depositor d ON c.cust_ID = d.cust_ID
JOIN account a ON d.account_number = a.account_number
JOIN branch b ON a.branch_name = b.branch_name
WHERE c.customer_city = b.branch_city;

--------------------------------------------------------------------------------
/*				                  Query 3           		  		          */
--------------------------------------------------------------------------------
SELECT c.cust_ID, c.customer_name
FROM customer c
WHERE c.cust_ID IN (
SELECT b.cust_ID
FROM borrower b
WHERE b.cust_ID NOT IN (
SELECT d.cust_ID
FROM depositor d)
);      
--------------------------------------------------------------------------------
/*				                  Query 4           		  		          */
--------------------------------------------------------------------------------

SELECT c.cust_ID, c.customer_name
FROM customer c
WHERE c.customer_street = (
  SELECT customer_street
  FROM customer
  WHERE cust_ID = '12345'
) AND c.customer_city = (
  SELECT customer_city
  FROM customer
  WHERE cust_ID = '12345'
);

--------------------------------------------------------------------------------
/*				                  Query 5           		  		          */
--------------------------------------------------------------------------------

SELECT DISTINCT b.branch_name
FROM branch b
JOIN account a ON b.branch_name = a.branch_name
JOIN depositor d ON a.account_number = d.account_number
JOIN customer c ON d.cust_ID = c.cust_ID
WHERE c.customer_city = 'Harrison';
    
--------------------------------------------------------------------------------
/*				                  Query 6           		  		          */
--------------------------------------------------------------------------------

SELECT c.cust_ID, c.customer_name
FROM customer c
WHERE NOT EXISTS (
SELECT b.branch_name
  FROM branch b
  WHERE b.branch_city = 'Brooklyn' AND NOT EXISTS (
    SELECT a.account_number
    FROM account a
    WHERE a.branch_name = b.branch_name AND NOT EXISTS (
      SELECT d.account_number
      FROM depositor d
      WHERE d.cust_ID = c.cust_ID AND d.account_number = a.account_number)
  )
);

--------------------------------------------------------------------------------
/*				                  Query 7           		  		          */
--------------------------------------------------------------------------------

SELECT l.loan_number, c.customer_name, l.branch_name
FROM loan l
JOIN borrower b ON l.loan_number = b.loan_number
JOIN customer c ON b.cust_ID = c.cust_ID
WHERE b.loan_number IN (
  SELECT l.loan_number
  FROM loan l
  JOIN borrower b ON l.loan_number = b.loan_number
  WHERE l.branch_name = 'Yonkahs Bankahs'
  GROUP BY l.loan_number
  HAVING CAST(l.amount AS numeric) > (
    SELECT AVG(CAST(amount AS numeric))
    FROM loan
    WHERE branch_name = 'Yonkahs Bankahs'
  )
);

  

  