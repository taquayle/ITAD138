/* ITAD 138 - Assignment 02 Part 03*/

/* Tyler Quayle - SIN: 950416426 */

SELECT Name, 
	LifeExpectancy
FROM Country
WHERE LEFT(Name, 1) IN ('A', 'D', 'F') 
	AND LifeExpectancy IS NOT NULL
ORDER BY Name
