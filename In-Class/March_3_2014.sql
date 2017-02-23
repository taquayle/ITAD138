/* Question 1 */
SELECT vendor_name
FROM vendors
WHERE vendor_id IN (SELECT vendor_id FROM invoices)
ORDER BY vendor_name;

/* Question 2 */
SELECT 
	account_number,
	account_description
FROM general_ledger_accounts
WHERE account_number NOT IN (SELECT account_number FROM invoice_line_items);

/* Question 3 */
SELECT vendor_id,
	MAX(invoice_total - payment_total) as 'unpaid'
FROM invoices
GROUP BY vendor_id
HAVING MAX(invoice_total - payment_total) > 0;

/* Question 4 */

/* Question 5 */
SELECT
	vendors.vendor_name,
	invoices.invoice_number,
	invoices.invoice_date,
	invoices.invoice_total

FROM invoices
JOIN vendors	ON	invoices.vendor_id = vendors.vendor_id
WHERE (SELECT min(invoice_date)
		FROM invoices)
GROUP BY invoices.vendor_id
