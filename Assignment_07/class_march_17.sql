-- Examples taken from Murach's MySQL

-- The syntax of the CREATE VIEW statement
-- CREATE [OR REPLACE] VIEW view_name 
--  [(column_alias_1[, column_alias_2]...)]
--  AS
--    select_statement
--  [WITH [CHECK OPTION] [CONSTRAINT constraint_name]]
use ap;
SELECT * FROM vendors;
-- A CREATE VIEW statement
CREATE VIEW vendors_min AS
  SELECT vendor_name, vendor_state, vendor_phone
  FROM vendors;
-- ----------------------
-- A SELECT statement that uses the view
SELECT * FROM vendors_min
WHERE vendor_state = 'CA'
ORDER BY vendor_name;
-- ----------------
-- An UPDATE statement that uses the view to update the base table
UPDATE vendors_min
SET vendor_phone = '(800) 555-3941'
WHERE vendor_name = 'Register of Copyrights';
-- A statement that drops a view
-- DROP VIEW vendors_min;
-- A view of vendors that have invoices
CREATE VIEW vendors_phone_list AS
  SELECT vendor_name, vendor_contact_last_name, 
         vendor_contact_first_name, vendor_phone
  FROM vendors
  WHERE vendor_id IN
     (SELECT DISTINCT vendor_id FROM invoices);
-- A view that uses a join
CREATE OR REPLACE VIEW vendor_invoices AS
  SELECT vendor_name, invoice_number, invoice_date,
         invoice_total 
  FROM vendors JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id;
-- A view that uses a LIMIT clause
CREATE OR REPLACE VIEW top5_invoice_totals AS
  SELECT vendor_id, invoice_total
  FROM invoices
  ORDER BY invoice_total DESC
  LIMIT 5;
-- A view that names all of its columns in the CREATE VIEW clause
CREATE OR REPLACE VIEW invoices_outstanding
  (invoice_number, invoice_date, invoice_total,
   balance_due)
AS
  SELECT invoice_number, invoice_date, invoice_total,
         invoice_total - payment_total - credit_total
  FROM invoices
  WHERE invoice_total - payment_total - credit_total > 0;
-- A view that names just the calculated column in its SELECT clause
CREATE OR REPLACE VIEW invoices_outstanding AS
  SELECT invoice_number, invoice_date, invoice_total,
         invoice_total - payment_total - credit_total
         AS balance_due
  FROM invoices
  WHERE invoice_total - payment_total - credit_total > 0;
-- A view that summarizes invoices by vendor
CREATE OR REPLACE VIEW invoice_summary AS
  SELECT vendor_name, 
    COUNT(*) AS invoice_count, 
    SUM(invoice_total) AS invoice_total_sum
  FROM vendors JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
  GROUP BY vendor_name;
-- A statement that creates a view
CREATE VIEW vendors_sw AS
SELECT *
FROM vendors
WHERE vendor_state IN ('CA','AZ','NV','NM');
-- A statement that replaces the view with a new view
CREATE OR REPLACE VIEW vendors_sw AS
SELECT *
FROM vendors
WHERE vendor_state IN ('CA','AZ','NV','NM','UT','CO');
-- A statement that drops the view
DROP VIEW vendors_sw;

-- ..............
-- Procedures
-- A script that creates and calls a stored procedure
USE ap;

DROP PROCEDURE IF EXISTS test;

-- Change statement delimiter to double front slash
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE sum_balance_due_var DECIMAL(9, 2);

  SELECT SUM(invoice_total - payment_total - credit_total)
  INTO sum_balance_due_var
  FROM invoices 
  WHERE vendor_id = 10;
IF sum_balance_due_var > 0 THEN
    SELECT CONCAT('Balance due: $', sum_balance_due_var)
        AS warning;
  ELSE
    SELECT 'Balance paid in full' AS message;
  END IF;  
END//

DELIMITER ;
-- A stored procedure that uses variables
USE ap;
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE max_invoice_total  DECIMAL(9,2);
  DECLARE min_invoice_total  DECIMAL(9,2);
  DECLARE percent_difference DECIMAL(9,4);
  DECLARE count_invoice_id   INT;
  DECLARE vendor_id_var      INT;
  
  SET vendor_id_var = 12;

  SELECT MAX(invoice_total), MIN(invoice_total),
         COUNT(invoice_id)
  INTO max_invoice_total, min_invoice_total,
       count_invoice_id
  FROM invoices WHERE vendor_id = vendor_id_var;
  SET percent_difference =
     (max_invoice_total - min_invoice_total) / 
     min_invoice_total * 100;
  
  SELECT CONCAT('$', max_invoice_total)
         AS 'Maximum invoice', 
         CONCAT('$', min_invoice_total)
         AS 'Minimum invoice', 
         CONCAT('%', ROUND(percent_difference, 2))
         AS 'Percent difference',
         count_invoice_id AS 'Number of invoices';
END//


-- Change statement delimiter to semicolon 
DELIMITER ;

CALL test();

DROP PROCEDURE IF EXISTS test;
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE first_invoice_due_date DATE;

  SELECT MIN(invoice_due_date)
  INTO first_invoice_due_date
  FROM invoices
  WHERE invoice_total - payment_total - credit_total > 0;

  IF first_invoice_due_date < NOW() THEN
    SELECT  'Outstanding invoices overdue!';
  ELSE
	IF first_invoice_due_date = NOW() THEN
		SELECT 'Outstanding iinvoicesinvoice_idnvoices are due today!';
	ELSE
		SELECT 'No invoices are overdue.';
	END IF;
  END IF;
END//
-- Change statement delimiter to semicolon 
DELIMITER ;

CALL test();

-- A stored procedure that displays a message
DROP PROCEDURE IF EXISTS test;
DELIMITER //


CREATE PROCEDURE test()
BEGIN
  SELECT 'This is a test.' AS message;
END//

DELIMITER ;
CALL test();

-- The syntax for declaring a variable
-- DECLARE variable_name data_type [DEFAULT literal_value];
-- The syntax for setting a variable 
-- to a literal value or an expression
-- SET variable_name = literal_value_or_expression;
-- The syntax for setting a variable 
-- to a selected value
-- SELECT column_1[, column_2]...
-- INTO variable_name_1[, variable_name_2]...

-- A stored procedure that uses variables
DROP PROCEDURE IF EXISTS test;
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE max_invoice_total  DECIMAL(9,2);
  DECLARE min_invoice_total  DECIMAL(9,2);
  DECLARE percent_difference DECIMAL(9,4);
  DECLARE count_invoice_id   INT;
  DECLARE vendor_id_var      INT;
  
  SET vendor_id_var = 95;

  SELECT MAX(invoice_total), MIN(invoice_total),
         COUNT(invoice_id)
  INTO max_invoice_total, min_invoice_total,
       count_invoice_id
  FROM invoices WHERE vendor_id = vendor_id_var;
  SET percent_difference =
     (max_invoice_total - min_invoice_total) / 
     min_invoice_total * 100;
  
  SELECT CONCAT('$', max_invoice_total)
         AS 'Maximum invoice', 
         CONCAT('$', min_invoice_total)
         AS 'Minimum invoice', 
         CONCAT('%', ROUND(percent_difference, 2))
         AS 'Percent difference',
         count_invoice_id AS 'Number of invoices';
END//

DELIMITER ;
CALL test();

-- The syntax of the IF statement
-- IF boolean_expression THEN
--   statement_1;
--   [statement_2;]...
-- [ELSEIF boolean_expression THEN
--   statement_1;
--   [statement_2;]...]...
-- [ELSE
--   statement_1;
--   [statement_2;]...]
-- END IF;
-- Note
-- •	You can also code parentheses around the Boolean expressions in an IF statement.
-- A stored procedure that uses an IF statement
DROP PROCEDURE IF EXISTS test;
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE first_invoice_due_date DATE;

  SELECT MIN(invoice_due_date)
  INTO first_invoice_due_date
  FROM invoices
  WHERE invoice_total - payment_total - credit_total > 0;

  IF first_invoice_due_date < NOW() THEN
    SELECT 'Outstanding invoices overdue!';
  ELSEIF first_invoice_due_date = NOW() THEN
    SELECT 'Outstanding invoices are due today!';
  ELSE
    SELECT 'No invoices are overdue.';
  END IF;
END//
DELIMITER ;
CALL test();

-- The syntax of the simple CASE statement
-- CASE expression
--   WHEN expression_value_1 THEN 
--    statement_1;
--     [statement_2;]...
--   [WHEN expression_value_2 THEN 
--     statement_1;
--     [statement_2;]...]...
--   [ELSE
--     statement_1;
--     [statement_2;]...]
-- END CASE;

-- A stored procedure that uses a simple CASE statement
DROP PROCEDURE IF EXISTS test;
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE terms_id_var INT;

  SELECT terms_id INTO terms_id_var 
  FROM invoices WHERE invoice_id = 4;

  CASE terms_id_var
    WHEN 1 THEN 
      SELECT 'Net due 10 days' AS Terms;
    WHEN 2 THEN 
      SELECT 'Net due 20 days' AS Terms;      
    WHEN 3 THEN 
      SELECT 'Net due 30 days' AS Terms;      
    ELSE
      SELECT 'Net due more than 30 days' AS Terms;
  END CASE;
END//
DELIMITER ;
CALL test();

/* The syntax of a searched CASE statement
CASE
  WHEN boolean_expression THEN 
    statement_1;
    [statement_2;]...
  [WHEN boolean_expression THEN 
    statement_1;
    [statement_2;]...]...
  [ELSE
    statement_1;
    [statement_2;]...]
END CASE;
*/
/* The syntax of the WHILE loop
WHILE boolean_expression DO
  statement_1;
  [statement_2;]...
END WHILE;
*/
-- A stored procedure that uses a WHILE loop
DROP PROCEDURE IF EXISTS test;
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE s VARCHAR(400) DEFAULT '';

  WHILE i < 4 DO
    SET s = CONCAT(s, 'i=', i, ' | ');
    SET i = i + 1;
  END WHILE;

  SELECT s AS message;

END//
DELIMITER ;
CALL test();
/*
A REPEAT loop
REPEAT
  SET s = CONCAT(s, 'i=', i, ' | ');
  SET i = i + 1;
UNTIL i = 4
END REPEAT;
*/

/* The syntax for declaring parameters
[IN|OUT|INOUT] parameter_name data_type
*/
-- A stored procedure that uses parameters
DROP PROCEDURE IF EXISTS update_invoices_credit_total;

DELIMITER //
CREATE PROCEDURE update_invoices_credit_total
(
  IN  invoice_id_param    INT,
  IN  credit_total_param  DECIMAL(9,2), 
  OUT update_count        INT
)
BEGIN
  DECLARE sql_error TINYINT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;
  UPDATE invoices
  SET credit_total = credit_total_param
  WHERE invoice_id = invoice_id_param;
  
  IF sql_error = FALSE THEN
    SET update_count = 1;
    COMMIT;
  ELSE
    SET update_count = 0;
    ROLLBACK;
  END IF;
END//
DELIMITER ;
-- A script that calls the stored procedure
CALL update_invoices_credit_total(56, 200, @row_count);
SELECT CONCAT('row_count: ', @row_count) AS update_count;

-- A procedure that provides a default parameter value
DROP PROCEDURE IF EXISTS update_invoices_credit_total;
DELIMITER //

CREATE PROCEDURE update_invoices_credit_total
(
  invoice_id_param     INT,
  credit_total_param   DECIMAL(9,2)
)
BEGIN
  DECLARE sql_error TINYINT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;
    
  -- Set default values for NULL values
  IF credit_total_param IS NULL THEN
    SET credit_total_param = 100;
  END IF;
  START TRANSACTION;
  
  UPDATE invoices
  SET credit_total = credit_total_param
  WHERE invoice_id = invoice_id_param;
  
  IF sql_error = FALSE THEN
    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
END//
DELIMITER ;
-- A statement that calls the stored procedure
CALL update_invoices_credit_total(56, 200);
-- Another statement that calls the stored procedure
CALL update_invoices_credit_total(56, NULL);

/* The syntax for setting a user variable
SET @variable_name = expression
*/
-- Two procedures that use the same variable
DELIMITER //

CREATE PROCEDURE set_global_count
(
  count_var INT
)
BEGIN
  SET @count = count_var;  
END//

CREATE PROCEDURE increment_global_count()
BEGIN
  SET @count = @count + 1;
END//
DELIMITER ;
-- Two statements that call these stored procedures
CALL set_global_count(100);
CALL increment_global_count();

-- -----------------------------------------------
-- ------------------------------------------------
/* The syntax of the CREATE FUNCTION statement
CREATE FUNCTION function_name
(
    [parameter_name_1 data_type]
    [, parameter_name_2 data_type]...
)
RETURNS data_type
sql_block
*/
-- A function that returns a vendor ID
DELIMITER //

CREATE FUNCTION get_vendor_id
(
   vendor_name_param VARCHAR(50)
)
RETURNS INT
BEGIN
  DECLARE vendor_id_var INT;
  
  SELECT vendor_id
  INTO vendor_id_var
  FROM vendors
  WHERE vendor_name = vendor_name_param;
  
  RETURN(vendor_id_var);
END//

DELIMITER ;
-- A SELECT statement that uses the function
SELECT invoice_number, invoice_total
FROM invoices
WHERE vendor_id = get_vendor_id('IBM');

-- A function that calculates balance due
DELIMITER //

CREATE FUNCTION get_balance_due
(
   invoice_id_param INT
)
RETURNS DECIMAL(9,2)
BEGIN
  DECLARE balance_due_var DECIMAL(9,2);
  
  SELECT invoice_total - payment_total - credit_total
  INTO balance_due_var
  FROM invoices
  WHERE invoice_id = invoice_id_param;
  
  RETURN balance_due_var;
END//
DELIMITER ;
-- A statement that calls the function
SELECT vendor_id, invoice_number, 
       get_balance_due(invoice_id) AS balance_due 
FROM invoices
WHERE vendor_id = 37;

/* The syntax of the DROP FUNCTION statement
DROP FUNCTION [IF EXISTS] function_name
*/
-- A statement that creates a function
DELIMITER //

CREATE FUNCTION get_sum_balance_due
(
   vendor_id_param INT
)
RETURNS DECIMAL(9,2)
BEGIN
  DECLARE sum_balance_due_var DECIMAL(9,2);
  
  SELECT SUM(get_balance_due(invoice_id))
  INTO sum_balance_due_var 
  FROM invoices
  WHERE vendor_id = vendor_id_param;
  
  RETURN sum_balance_due_var;
END//
DELIMITER ;
-- A statement that calls the function
SELECT vendor_id, invoice_number, 
       get_balance_due(invoice_id) AS balance_due, 
       get_sum_balance_due(vendor_id) AS sum_balance_due
FROM invoices
WHERE vendor_id = 37;
-- A statement that drops the function
DROP FUNCTION get_sum_balance_due;
-- A statement that drops the function only if it exists
DROP FUNCTION IF EXISTS get_sum_balance_due;