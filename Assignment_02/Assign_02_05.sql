/* ITAD 138 - Assignment 02 Part 05*/

/* Tyler Quayle - SIN: 950416426 */

SELECT track_number, 
	title, 
	floor(duration/60) AS 'Duration in min',
	duration AS 'Duration in sec'
FROM Track 
WHERE album_id = 13