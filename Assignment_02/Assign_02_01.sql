/* ITAD 138 - Assignment 02 Part 01*/

/* Tyler Quayle - SIN: 950416426 */

SELECT Name as 'City Name', 
       CountryCode as 'Country Code', 
       population as 'Population'
FROM city 
WHERE population = (SELECT MAX(population) FROM City)