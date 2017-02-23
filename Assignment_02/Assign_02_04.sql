/* ITAD 138 - Assignment 02 Part 04*/

/* Tyler Quayle - SIN: 950416426 */

SELECT Region,
	CONCAT(Name, ' (',LocalName, ')') AS 'Country Name and Local Name',
	LocalName,
	Continent,
	Population
FROM country
WHERE Population < 100000
	AND Region != 'Antarctica'
ORDER BY Region, name