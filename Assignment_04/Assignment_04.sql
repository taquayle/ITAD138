/* ITAD 138 - Assignment 04*/

/* Tyler Quayle - SIN: 950416426 */

/* Question 1 */

USE world;

SELECT DISTINCT(Continent), 
	count(name)
FROM country
GROUP BY Continent;

/* Question 2 */

SELECT co.Continent, 
	co.Region, 
	count(ci.Name) AS "city_count",
	sum(ci.Population) AS "sum_population"
FROM country AS co
JOIN city AS ci
	ON ci.CountryCode = co.Code 

WHERE co.Continent = 'Oceania'
GROUP BY Region;

/* Question 3 */

SELECT co.Name as 'country', 
       ci.name as 'City',
       MAX(ci.Population) AS 'population'
FROM country AS co
JOIN city AS ci
	ON ci.CountryCode = co.Code
GROUP BY co.Name
ORDER BY ci.Population DESC;

/* Question 4 */

SELECT DISTINCT(co.Name) as 'country_name', 
	co.Population as 'country_population',
	sum(ci.Population) AS 'city_population',
	ROUND((sum(ci.Population)/co.Population)*100) AS 'city_population_percent'
FROM country AS co
JOIN city AS ci
	ON ci.CountryCode = co.Code
WHERE co.Continent = 'Europe'
GROUP BY co.Name
HAVING ROUND((sum(ci.Population)/co.Population)*100) > 30
ORDER BY ROUND((sum(ci.Population)/co.Population)*100) DESC;

/* Question 5 */

SELECT Name AS 'country_name', 
	Region AS 'Region',
	Population
	FROM country AS co
WHERE Population < (SELECT Population FROM Country WHERE Name = 'Anguilla') 
	AND Population > 0
ORDER BY Population, Region, Name;

/* Question 6 */

USE om;

SELECT title,
	artist,
	unit_price
FROM items
WHERE unit_price = (SELECT unit_price FROM items WHERE title = 'Umami In Concert')
ORDER BY title;
