DROP TABLE invoice_copy;

CREATE TABLE invoice_copy AS 
SELECT *
FROM invoices;

DESCRIBE invoice_copy;


SELECT * FROM invoice_copy;

INSERT INTO invoices
(invoice_date)

VALUES
(CURDATE());

SELECT * FROM invoices;