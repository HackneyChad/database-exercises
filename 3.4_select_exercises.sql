USE albums_db
;

DESCRIBE albums
;
	/*
    # Field, Type, Null, Key, Default, Extra
	id, int(10) unsigned, NO, PRI, , auto_increment
	artist, varchar(240), YES, , , 
	name, varchar(240), NO, , , 
	release_date, int(11), YES, , , 
	sales, float, YES, , , 
	genre, varchar(240), YES, , , 
	*/

SELECT name
FROM albums
WHERE artist = 'Pink Floyd'
;
	/*
    # name
	The Dark Side of the Moon
	The Wall
	*/


SELECT release_date
FROM albums
WHERE name = 'Sgt. Pepper''s Lonely Hearts Club Band'
;
	/*
    # release_date
	1967
	*/

SELECT genre
FROM albums
WHERE artist = 'Nirvana'
;
	/*
    # genre
	Grunge, Alternative rock
	*/

SELECT sales
	,artist
	,name
FROM albums
WHERE sales < 20
ORDER by sales DESC
;
	/*
    sales, artist, name
    19.6	Bruce Springsteen	Born in the U.S.A.
	19.4	Madonna	The Immaculate Collection
	19.3	Michael Jackson	Bad
	19.3	Celine Dion	Let's Talk About Love
	18.1	James Horner	Titanic: Music from the Motion Picture
	17.9	Various artists	Dirty Dancing
	17.7	Dire Straits	Brothers in Arms
	17.6	Pink Floyd	The Wall
	16.7	Nirvana	Nevermind
	16.3	Michael Jackson	Dangerous
	14.4	Various artists	Grease: The Original Soundtrack from the Motion Picture
	14.4	The Beatles	Abbey Road
	13.1	The Beatles	Sgt. Pepper's Lonely Hearts Club Band
	*/


SELECT sales
	,artist
	,name
    ,genre
FROM albums
WHERE sales < 20
ORDER by sales DESC
;
	/*
    sales, artist, name, genre
	19.6	Bruce Springsteen	Born in the U.S.A.	Rock
	19.4	Madonna	The Immaculate Collection	Pop, Dance
	19.3	Michael Jackson	Bad	Pop, Funk, Rock
	19.3	Celine Dion	Let's Talk About Love	Pop, Soft rock
	18.1	James Horner	Titanic: Music from the Motion Picture	Soundtrack
	17.9	Various artists	Dirty Dancing	Pop, Rock, R&B
	17.7	Dire Straits	Brothers in Arms	Rock, Pop
	17.6	Pink Floyd	The Wall	Progressive rock
	16.7	Nirvana	Nevermind	Grunge, Alternative rock
	16.3	Michael Jackson	Dangerous	Rock, Funk, Pop
	14.4	Various artists	Grease: The Original Soundtrack from the Motion Picture	Soundtrack
	14.4	The Beatles	Abbey Road	Rock
	13.1	The Beatles	Sgt. Pepper's Lonely Hearts Club Band	Rock
	*/

SELECT sales
	,artist
	,name
    ,genre
FROM albums
WHERE sales < 20 AND genre like '%progressive%' OR genre like '%hard%'
ORDER by sales DESC
;
	/*
    Why no results from previous query with genre of "Progressive rock" or "Hard rock"?
    This does generate a result of Progressive Rock.  See immediately below:
    sales, artist, name, genre
    17.6	Pink Floyd	The Wall	Progressive rock
    */

-- Assignment questions:
-- Use the albums_db database.
-- Explore the structure of the albums table.
-- Write queries to find the following information.
-- The name of all albums by Pink Floyd
-- The year Sgt. Pepper's Lonely Hearts Club Band was released
-- The genre for the album Nevermind
-- Which albums were released in the 1990s
-- Which albums had less than 20 million certified sales
-- All the albums with a genre of "Rock".
-- Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"?

-- Additional work from slack channel:
	/*
    Write a query that shows all the information in the `help_topic` table
    in the `mysql` database.  How could you write a query to search
    for a specific help topic?
    */

/* First, "select all" to view table contents.  Decide the topic you want to view. */
SELECT *
FROM mysql.help_topic
;

/* Then, drop that topic ID number into another query (inside WHERE statement) to select specific topic. */
SELECT *
FROM mysql.help_topic
WHERE help_topic_id = 1
;


/* Take a look at the information in the salaries table in the employees database.
 What do you notice? */

USE employees
;

SELECT *
FROM salaries
;

/*
There are multiple records for the same employees, as the employee has been promoted. Each promotion
is also listed with "from" & "to" date fields. These records' "from/to" dates sort chronologically
against one another as the employee was promoted.
*/


/*
Explore the `sakila` database.  - Done
What do you think this database represents?  - It appears to be info from a film repository, like a Netflix, or Blockbuster, etc.
What kind of company might be using this database?  - Netflix, Amazon Prime, Blockbuster, Hollywood Video
*/

USE sakila
;

SHOW TABLES
FROM sakila
;

/* write a query that shows all the columns from the `actors` table */
SHOW COLUMNS
FROM actor
;

/* write a query that only shows the last name of the actors from the `actors` table */
SELECT DISTINCT last_name
FROM actor
ORDER BY last_name ASC
;

/* Write a query that displays the title, description, rating, movie length
columns from the `films` table for films that last 3 hours or longer. */
SELECT length
	,title
	,description
    ,rating
FROM film
WHERE length >= 180
ORDER BY length ASC
	,title ASC
;

/* Select the payment id, amount, and payment date columns from the payments
table for payments made on or after 05/27/2005. */

SELECT payment_id
	,amount
    ,payment_date
FROM payment
WHERE payment_date >= "2005-05-27"
ORDER BY payment_date ASC
;


/*  - Select the primary key, amount, and payment date columns from the payment
table for payments made on 05/27/2005. */

DESCRIBE payment
;
/* payment_id field is the Primary Key field. */
use sakila;
SELECT payment_id
	,amount
	,payment_date
FROM payment
WHERE payment_date BETWEEN "2005-05-27" AND "2005-05-28"
ORDER BY payment_date ASC
;


USE fruits_db;
SELECT * FROM fruits;

