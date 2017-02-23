/* ITAD 138 - Assignment 03*/

/* Tyler Quayle - SIN: 950416426 */

/* Question 1 */
use world;

SELECT city.Name as 'city_name',
	city.population as 'population',
	country.Name as 'country_name'
FROM city 
JOIN country
ON city.CountryCode = country.Code
ORDER BY population DESC
LIMIT 5;

/* Question 2 */

SELECT ci.Name AS 'city_name',
	co.Name AS 'country_name',
	la.language

FROM city AS ci
LEFT JOIN country AS co
ON co.Code = ci.CountryCode
LEFT JOIN countrylanguage AS la
ON la.CountryCode = ci.CountryCode

WHERE (la.Language = 'Khmer' OR la.Language = 'Tamil')
AND la.IsOfficial = 'T' 

ORDER BY co.Name, ci.Name;

/* Question 3 */

SELECT co.Name,
	co.region,
	co.SurfaceArea,
	la.language

FROM country AS co
LEFT JOIN countrylanguage AS la
ON la.CountryCode = co.Code

WHERE la.Language IS NULL

ORDER BY co.Name;

/* Question 4 */

USE om;	

SELECT  ord.order_date,
	it.title,
	CONCAT(cu.customer_first_name, " ",cu.customer_last_name) as 'customer_name'

FROM orders AS ord
JOIN order_details AS det
	ON ord.order_id = det.order_id
JOIN items AS it
	on it.item_id = det.item_id
JOIN customers AS cu
	ON	cu.customer_id = ord.customer_id

WHERE YEAR(ord.order_date) = '2010'
ORDER BY ord.order_date, it.title;

/* Question 5 */

SELECT ord.order_id,
	CONCAT(cu.customer_address, " ", cu.customer_city, " ", cu.customer_state, ", ", cu.customer_zip) as 'address',
	ord.order_date,
	ord.shipped_date

FROM orders AS ord
JOIN customers AS cu
	ON	cu.customer_id = ord.customer_id

ORDER BY ord.order_date DESC;

/* Question 6 */

(SELECT ord.order_id,
	CONCAT(cu.customer_address, " ", cu.customer_city, " ", cu.customer_state, ", ", cu.customer_zip) as 'address',
	ord.order_date,
	COALESCE(ord.shipped_date, CURDATE()) as 'Shipped'

FROM orders AS ord
JOIN customers AS cu
	ON	cu.customer_id = ord.customer_id
WHERE ord.shipped_date IS NOT NULL)

UNION

(SELECT ord.order_id,
	CONCAT(cu.customer_address, " ", cu.customer_city, " ", cu.customer_state, ", ", cu.customer_zip) as 'address',
	ord.order_date,
	COALESCE(ord.shipped_date, CURDATE()) as 'Shipped'

FROM orders AS ord
JOIN customers AS cu
	ON	cu.customer_id = ord.customer_id
WHERE ord.shipped_date IS NULL)

ORDER BY order_date DESC
/* What the hell took almost 3 years to ship? */





