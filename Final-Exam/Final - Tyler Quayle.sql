/* Tyler Quayle */
/* ITAD 138 - Final */

/* Question 1 */

SELECT * 
FROM customers
WHERE city IN (SELECT city FROM customers WHERE customerName = 'Vitachrome Inc.')
ORDER BY customerNumber ASC;

/* Question 2 */

SELECT 
	cus.customerNumber,
	cus.customerName,
	cus.phone,
	DATE_FORMAT(pay.paymentDate, '%M %d %Y') AS 'payment_date',
	pay.amount
FROM customers AS cus
	JOIN payments AS pay
		ON cus.customerNumber = pay.customerNumber

WHERE MONTH(pay.paymentDate) = 6
AND YEAR(pay.paymentDate) = 2004 

GROUP BY cus.customerNumber
ORDER BY pay.paymentDate;

/* Question 3 */

DELIMITER $$
DROP FUNCTION IF EXISTS get_employeeCount$$

CREATE FUNCTION get_employeeCount
(
	empNum INT
)
RETURNS INT
BEGIN
  DECLARE customerCount INT(11);
  
  SELECT Count(customerNumber)
  INTO customerCount
  FROM customers
  WHERE salesRepEmployeeNumber = 	(SELECT  employeeNumber
						FROM  employees
						WHERE employeeNumber = empNum);
  
  RETURN customerCount;
END$$

DELIMITER ;

SELECT 
	emp.employeeNumber,
		emp.firstName,
		emp.lastName,
	get_employeeCount(emp.employeeNumber) AS 'num_of_customers'
FROM employees AS emp
WHERE get_employeeCount(emp.employeeNumber) > 6
ORDER BY num_of_customers DESC;

/* Question 4 */
DROP VIEW IF EXISTS train_orders;

CREATE VIEW train_orders AS
SELECT 
	orderNumber, 
	orderDate, 
	shippedDate,
	customerNumber
FROM orders
WHERE orderNumber IN 
	(SELECT orderNumber 
	FROM orderdetails
	WHERE productCode IN
		(SELECT productCode 
		FROM products
		WHERE productLine = 'Trains'))
AND YEAR(orderDate) = 2003
ORDER BY orderNumber;

SELECT * FROM train_orders;

/* Question 5 */

DELIMITER //
DROP PROCEDURE IF EXISTS direct_subordinates//

CREATE PROCEDURE direct_subordinates
(
  IN  empManagerFirstName   VARCHAR(50),
  IN  empManagerLastName  VARCHAR(50)
)
BEGIN
	SELECT *
	FROM employees 
	WHERE reportsTo IN 	(SELECT employeeNumber
						FROM employees
						WHERE firstName = empManagerFirstName
						AND lastName = empManagerLastName)
	ORDER BY employeeNumber DESC;

  
END//
DELIMITER ;

CALL direct_subordinates('Mary', 'Patterson');

/* Question 6 */

DELIMITER $$
DROP FUNCTION IF EXISTS get_orders_total$$


CREATE FUNCTION get_orders_total
(
   cusNumber INT
)
RETURNS DOUBLE
BEGIN
  DECLARE totalAmount DOUBLE;
  
  SELECT SUM(amount)
  INTO totalAmount
  FROM payments
  WHERE customerNumber = cusNumber;

  RETURN totalAmount;
END$$

DELIMITER ;

SELECT 
	customerNumber,
	customerName,
	get_orders_total(customerNumber) AS 'Orders Total'
FROM customers
WHERE customerNumber = 103;

/* Question 7 */

DELIMITER $$

DROP PROCEDURE IF EXISTS delete_order$$

CREATE PROCEDURE delete_order
(
  IN  ordNumber INT
)

BEGIN 
	DELETE FROM orders
	WHERE orderNumber = ordNumber;

	DELETE FROM orderDetails
	WHERE orderNumber = ordNumber;

END$$
DELIMITER ;

SELECT * FROM orders;

SELECT * 
	FROM orders 
		JOIN orderDetails
			ON orders.orderNumber = orderDetails.OrderNumber
WHERE orders.orderNumber = 10100;

CALL delete_order(10100);

SELECT * 
	FROM orders 
		JOIN orderDetails
			ON orders.orderNumber = orderDetails.OrderNumber
WHERE orders.orderNumber = 10100;

/* Question 8 */

DELIMITER $$

DROP PROCEDURE IF EXISTS add_rep$$

CREATE PROCEDURE add_rep
(
	IN  empNumber INT(11),
	IN 	empLastName VARCHAR(50),
	IN 	empFirstName VARCHAR(50),
	IN 	empExt VARCHAR(10),
	IN	empEmail VARCHAR(100),
	IN 	empOfficeCode VARCHAR(10),
	IN	empReportsTo INT(11),
	IN 	empTitle VARCHAR(50)
)

BEGIN 
	REPLACE INTO employees
	SET employeeNumber = empNumber, 
	lastName = empLastName, 
	firstName = empFirstName,
	extension = empExt,
	email = empEmail,
	officeCode = empOfficeCode,
	reportsTo = empReportsTo,
	jobTitle = empTitle;
END$$
DELIMITER ;

SELECT * FROM employees WHERE employeeNumber = '1342';

CALL add_rep(1342, 'Sam', 'Smith', 'x105', 'samsmith@classicmodelcars.com', '3', 1143, 'salesRep');

SELECT * FROM employees WHERE employeeNumber = '1342';