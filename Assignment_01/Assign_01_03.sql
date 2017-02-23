-- Tyler Quayle - Assignment 01, Part 03. 1/13/2014
-- 3.(10 pts.) Display the number of countries in the countries table

-- Count number of rows of Table Country in DB World
-- where name != NULL, renamed output for personal ease
SELECT Count(NAME) AS 'Number of Countries' FROM Country