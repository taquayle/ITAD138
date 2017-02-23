SELECT invoice_number, invoice_date, invoice_total
		FROM invoices
	WHERE invoice_total <= 
	(SELECT AVG(invoice_total) FROM invoices);

SELECT AVG(invoice_total) FROM invoices;

SELECT invoice_number, invoice_date, invoice_total
		FROM invoices;

SELECT invoice_number, invoice_date, invoice_total
		FROM invoices
WHERE vendor_id IN (SELECT vendor_id FROM vendors 
					WHERE vendor_state = 'CA')
ORDER BY invoice_date;


SELECT vendor_id, vendor_name, vendor_state
		FROM vendors
WHERE vendor_id NOT IN 
		(SELECT DISTINCT vendor_id FROM invoices);

SELECT vendor_name, invoice_number, invoice_total
FROM invoices i 
	JOIN vendors v ON i.vendor_id = v.vendor_id
	WHERE invoice_total > ALL 
		(SELECT invoice_total FROM invoices 
								WHERE vendor_id = 34);

SELECT vendor_name, invoice_number, invoice_total
FROM invoices i 
	JOIN vendors v ON i.vendor_id = v.vendor_id
	WHERE invoice_total >  
		(SELECT MAX(invoice_total) FROM invoices 
								WHERE vendor_id = 34);


SELECT invoice_total FROM invoices 
								WHERE vendor_id = 34;


SELECT vendor_name, invoice_number, invoice_total
FROM vendors 
	JOIN invoices ON invoices.invoice_id = vendors.vendor_id
	WHERE invoice_total < SOME  
		(SELECT invoice_total FROM invoices 
								WHERE vendor_id = 115);


-- Correlated Subquery
-- Get each invoice amount that is higher than the
-- vendor's average invoice amount
SELECT vendor_id, invoice_number, invoice_total
	FROM invoices i
	WHERE invoice_total >
		(SELECT AVG(invoice_total) 
			FROM invoices 
			WHERE vendor_id = i.vendor_id)
ORDER BY vendor_id, invoice_total;




