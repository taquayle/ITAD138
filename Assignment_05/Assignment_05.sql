/* ITAD 138 - Assignment 05*/

/* Tyler Quayle - SIN: 950416426 */

USE world;

/* Question 1 */

SELECT 
		name,
		region,
		SurfaceArea
FROM country

WHERE Code IN (SELECT CountryCode FROM countrylanguage WHERE Language = 'Dutch' AND isOfficial = 't')
ORDER BY name;

/* Question 2 */

SELECT 
		co.name AS 'country',
		c1.name AS 'city', 
		c1.population AS 'city_population'

FROM  city as c1
	JOIN country as co
		ON c1.countrycode = co.code

WHERE c1.population > 	(SELECT 
								AVG(c2.population) 
						FROM city AS c2  
						WHERE c1.countryCode = c2.countrycode 
						GROUP BY CountryCode) 

AND co.Region = 'Western Europe'

ORDER BY co.Name, c1.Name;

/* Question 3 */

SELECT 
	region,
	Name,
	Population

FROM country 

WHERE code NOT IN (SELECT countryCode FROM countryLanguage)

ORDER BY Name;

/* Question 4 */

SELECT 
		name,
		continent,
		SurfaceArea
FROM Country

WHERE SurfaceArea < (SELECT SurfaceArea FROM country WHERE name = 'Andorra')

ORDER BY SurfaceArea ASC;

/* Question 5 */

SELECT
		co.name,
		la.Language
FROM country AS co
	JOIN countrylanguage AS la
		ON co.Code = la.CountryCode
WHERE la.Language IN 	(SELECT 
								Language 
						FROM countryLanguage 
						WHERE CountryCode =	(SELECT 
													code 
											FROM country 
											WHERE name = 'Belgium') 
						AND isOfficial = 't')
AND la.isOfficial = 't'

ORDER BY Language, co.Name;

/* Question 6 */

SELECT 
		name AS 'French-Speaking African Countries'
FROM country

WHERE code IN (SELECT CountryCode FROM countryLanguage WHERE Language = 'French' AND isOfficial = 't')
AND continent = 'Africa'

ORDER BY name;

USE om;

/* Question 7 */

SELECT 
		customer_first_name,
		customer_last_name,
		(SELECT SUM(order_qty) 
		FROM order_details
		JOIN orders
		ON order_details.order_id = orders.order_id
		WHERE orders.customer_id = customers.customer_id
		GROUP BY customer_id) as num_items_purchased
FROM customers

WHERE (SELECT SUM(order_qty) 
		FROM order_details
		JOIN orders
		ON order_details.order_id = orders.order_id
		WHERE orders.customer_id = customers.customer_id
		GROUP BY customer_id) > 5;

/* Question 8 */

SELECT concat(Customer_First_name, ' ' ,customer_last_name) AS 'customer_name',
	   orders.Order_date

FROM customers
	JOIN orders
		on orders.customer_id = customers.customer_id

WHERE orders.order_date IN (SELECT MAX(order_date) FROM orders GROUP BY customer_id)
ORDER BY orders.order_date DESC