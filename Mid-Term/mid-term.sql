/* QUESTION 1 */

SELECT productName AS 'Car Name',
	productScale as 'Scale',
	productDescription AS 'Description'

FROM products

WHERE productScale != '1:18'
AND productLine = 'Vintage Cars'
ORDER BY productName;

/* QUESTION 2 */

SELECT off.Country,
	off.City,
	emp.firstName,
	emp.lastName,
	emp.email

FROM offices AS off
JOIN employees AS emp
	ON emp.officeCode = off.Officecode



WHERE emp.jobTitle = 'Sales Rep'
ORDER BY off.Country DESC, off.City ASC;

/* QUESTION 3 */

SELECT cus.customerName,
	cus.country,
	ord.status,
	pro.productName,
	det.quantityOrdered

FROM customers AS cus
JOIN orders AS ord
	ON ord.customerNumber = cus.customerNumber
JOIN orderDetails AS det
	ON det.orderNumber = ord.Ordernumber
JOIN products AS pro
	ON pro.productCode = det.productCode

WHERE cus.country != 'USA'
	AND ord.status != 'Shipped' 
	AND ord.status != 'Resolved'
ORDER BY cus.customerName;

/* QUESTION 4 */

SELECT DISTINCT cus.customerName,
	(SELECT
		COUNT(*)
	FROM
		orders
	WHERE
		orders.customerNumber = cus.customerNumber) AS 'orderCount'

	
FROM customers AS cus
INNER JOIN orders as ord
	on ord.customerNumber = cus.customerNumber

WHERE LEFT(cus.customerName, 1) IN ('D', 'E', 'M') 

ORDER BY orderCount DESC;

/* QUESTION 5 */
	
SELECT cus.customerName, 
	cus.country,
	round(sum(pay.amount), 2) as 'totalPaid'

FROM customers AS cus
LEFT JOIN payments AS pay
	ON pay.customerNumber = cus.customerNumber

WHERE (cus.Country = 'Denmark' OR cus.Country = 'Switzerland')

GROUP BY cus.customerNumber
	

