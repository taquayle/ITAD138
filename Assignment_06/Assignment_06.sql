/* ITAD 138 - Assignment 06 */

/* Tyler Quayle - SIN: 950416426 */


/* Question B */

-- DROP TABLE vendors_copy;

CREATE TABLE vendors_copy AS 
SELECT *
FROM vendors;

SELECT * FROM vendors_copy;

/* Question D */

-- DROP TABLE general_ledger_accounts_table_copy;

/*	USING LIKE STATMENT DIDN'T NEED TO USE THE INFORMATION TAB TO MAKE THEM EQUAL 
	AS YOU DIDN'T SPECIFIY HOW WE DID THIS QUESTION, ONLY SUGGESTED */
CREATE TABLE general_ledger_accounts_table_copy LIKE general_ledger_accounts; 

SELECT * FROM general_ledger_accounts_table_copy; /* TO SHOW IT'S BLANK */

INSERT INTO general_ledger_accounts_table_copy SELECT * FROM general_ledger_accounts;

SELECT * FROM general_ledger_accounts_table_copy; /* TO SHOW IT'S NOW FULL */

/* Question E */

SHOW CREATE TABLE invoices;

/* Question F */

-- DROP TABLE invoices_exactcopy;

CREATE TABLE `invoices_exactcopy` (
  `invoice_id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_id` int(11) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `invoice_date` date NOT NULL,
  `invoice_total` decimal(9,2) NOT NULL,
  `payment_total` decimal(9,2) NOT NULL DEFAULT '0.00',
  `credit_total` decimal(9,2) NOT NULL DEFAULT '0.00',
  `terms_id` int(11) NOT NULL,
  `invoice_due_date` date NOT NULL,
  `payment_date` date DEFAULT NULL,
  PRIMARY KEY (`invoice_id`),
  KEY `invoices_fk_vendors` (`vendor_id`),
  KEY `invoices_fk_terms` (`terms_id`),
  KEY `invoices_invoice_date_ix` (`invoice_date`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=latin1;

/* Question G */

INSERT INTO invoices_exactcopy SELECT * FROM invoices;

SELECT * FROM invoices_exactcopy;

/* Question H */

UPDATE invoices_exactcopy SET invoice_date = ((SELECT MAX(invoice_date) FROM INVOICES) - 1) WHERE vendor_id = 123;

SELECT vendor_id, invoice_date FROM invoices_exactcopy WHERE vendor_id = 123;


