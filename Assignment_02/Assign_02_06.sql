/* ITAD 138 - Assignment 02 Part 06*/

/* Tyler Quayle - SIN: 950416426 */

SELECT title,
	artist,
	DATE_FORMAT(released, '%b-%Y') AS 'Release Date',
	label
FROM album
WHERE label = 'Columbia'
	AND released > '1970 - 01 - 01'
