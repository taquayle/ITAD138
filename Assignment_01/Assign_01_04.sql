-- Tyler Quayle - Assignment 01, Part 04. 1/13/2014
-- 4.(10 pts.) Display the number of countries in the cities table

-- Count number of rows of Table City in DB World
-- where name != NULL, renamed output for personal ease
SELECT Count(NAME) AS 'Number of Cities' FROM City