/* ITAD 138 - Assignment 07 */

/* Tyler Quayle - SIN: 950416426 */
use ap;
/* Question 1 */

DROP VIEW IF EXISTS open_items;

CREATE VIEW open_items AS 
SELECT ve.vendor_name,
	iv.invoice_number,
	iv.invoice_total,
	(iv.invoice_total - iv.payment_total - iv.credit_total)  AS "balance_due"
	

FROM vendors AS ve
	LEFT JOIN invoices AS iv
		ON ve.vendor_id = iv.vendor_id

WHERE (iv.invoice_total - iv.payment_total - iv.credit_total)  > 0

ORDER BY vendor_name;

SELECT * FROM open_items;

/* Question 2 */

DROP VIEW IF EXISTS open_items_summary;

CREATE VIEW open_items_summary AS
SELECT vendors.vendor_name, 
	COUNT(payment_total) AS 'open_item_count',
	SUM(invoice_total-payment_total - credit_total) AS 'open_item_total'
	FROM invoices 
		JOIN vendors 
			ON vendors.vendor_id = invoices.vendor_id  
	
	WHERE (invoices.invoice_total - invoices.payment_total - invoices.credit_total) > 0
	GROUP BY invoices.vendor_id
	ORDER BY open_item_total DESC;


SELECT * FROM open_items_summary;

/* Question 3 */

SELECT CONCAT(ve.vendor_contact_first_name, ' ', ve.vendor_contact_last_name) AS 'contact name',
		SUM(iv.invoice_total - iv.payment_total - iv.credit_total) AS 'Balance_due'
	FROM invoices AS iv
		JOIN vendors AS ve
			ON ve.vendor_id = iv.vendor_id  

	WHERE (iv.invoice_total - iv.payment_total - iv.credit_total) > 0
	
GROUP BY ve.vendor_id
ORDER BY ve.vendor_contact_last_name DESC;

/* Question 4 */

DELIMITER $$
DROP FUNCTION IF EXISTS get_contact_first$$
DROP FUNCTION IF EXISTS get_contact_last$$


CREATE FUNCTION get_contact_first
(
   vendor_invoice_id INT
)
RETURNS VARCHAR (50)
BEGIN
  DECLARE contact_firstName VARCHAR(50);
  
  SELECT first_name
  INTO contact_firstName
  FROM vendor_contacts
  WHERE vendor_id = (SELECT vendor_id FROM invoices WHERE invoice_id = vendor_invoice_id);
  
  RETURN contact_firstName;
END$$

CREATE FUNCTION get_contact_last
(
   vendor_invoice_id INT
)
RETURNS VARCHAR (50)
BEGIN
  DECLARE contact_lastName VARCHAR(50);
  
  SELECT last_name
  INTO contact_lastName
  FROM vendor_contacts
  WHERE vendor_id = (SELECT vendor_id FROM invoices WHERE invoice_id = vendor_invoice_id);
  
  RETURN contact_lastName;
END$$

DELIMITER ;

/* Question 5 */

SELECT CONCAT(get_contact_first(invoice_id), ' ', get_contact_last(invoice_id)) AS 'contact name',
		SUM(invoice_total - payment_total - credit_total) AS 'Balance_due'
	FROM invoices

	WHERE (invoice_total - payment_total - credit_total) > 0
GROUP BY vendor_id;

/* Question 6 */

USE om;

DELIMITER ++

DROP FUNCTION IF EXISTS get_recent++

CREATE FUNCTION get_recent
(
	cus_first_name VARCHAR (50),
	cus_last_name VARCHAR (50)
)
RETURNS DATE
BEGIN
  DECLARE recent_order_date DATE;
  
  SELECT MAX(order_date)
  INTO recent_order_date
  FROM orders
  WHERE customer_id = 	(SELECT customer_id 
						FROM customers 
						WHERE customer_first_name = cus_first_name 
						AND customer_last_name = cus_last_name);
  
  RETURN recent_order_date;
END++

DELIMITER ;

/* Question 7 */

SELECT CONCAT(customer_first_name, ' ', customer_last_name) AS 'customer_name', 
		get_recent(customer_first_name, customer_last_name) AS 'recent_order_date'
FROM customers
ORDER BY recent_order_date DESC

