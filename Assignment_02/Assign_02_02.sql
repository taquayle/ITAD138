/* ITAD 138 - Assignment 02 Part 02*/

/* Tyler Quayle - SIN: 950416426 */

SELECT CountryCode as 'Code of Country',
	language as 'Not Official Langauge',
	Percentage as 'Percentage of Population Speaking the Language'
FROM CountryLanguage
WHERE language = 'English' 
	AND Percentage > 0.0 
	AND Percentage < 50.0
	AND isOfficial = 'F'
ORDER BY Percentage
	