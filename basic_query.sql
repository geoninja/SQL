/* SQL WORKSHOP 3/15/2015 */
/* Database: sakila-db */

-- SELECT * FROM Album LIMIT 10;

/* What are the Genres in the database? */
SELECT * 
FROM Genre;


-- SELECT GenreId, Name 
-- FROM Genre;


-- SELECT State 
-- FROM Customer;


/* What are the customer names that are from California? */
SELECT FirstName, LastName 
FROM Customer 
WHERE State = 'CA';


-- SELECT *
-- FROM films
-- WHERE state = 'CA' OR state = 'WA' OR state = 'OR';
/* same as: WHERE state IN ('CA', 'WA', 'OR') */


/* How many songs are longer than 10 minutes? */
SELECT COUNT(TrackId) FROM Track WHERE Milliseconds > 10 * 60 * 1000;
-- SELECT * FROM Track WHERE Milliseconds > 600000;


/* How many invoices were there in January 2010? */
SELECT COUNT(InvoiceId) FROM Invoice WHERE InvoiceDate BETWEEN date('2010-01-01') AND date('2010-01-31');


/* How many tracks have NULL Genre? */
SELECT COUNT(TrackId) FROM Track WHERE GenreId IS NULL;


/* How many distinct album titles are there? */
SELECT COUNT (DISTINCT Title) FROM Album;


/* How many distinct album IDs? */
SELECT COUNT(DISTINCT AlbumId) FROM Album;


/* What are the 5 longest songs? */
SELECT Name FROM Track ORDER BY Milliseconds DESC LIMIT 5;


/* R.E.M. has collaborated with a couple artists, can you find which artists they’ve collaborated with? */
SELECT Name FROM Artist WHERE Name LIKE 'R%';


/* How many ‘Love’ songs are there? */
SELECT COUNT(Name) FROM Track WHERE Name LIKE '%LOVE%' OR Name LIKE '%loving%';


--CREATE TABLE NewTable (id INTEGER PRIMARY KEY, Address TEXT, Name TEXT); 
-- INSERT INTO NewTable (id, Address, Name)
-- VALUES (1, '100 Oak St', 'Mary');


-- CREATE TABLE RBands AS SELECT * FROM Artist WHERE Name LIKE 'R%'; 
-- DROP TABLE RBands;


/* MULTIPLE JOINS */

-- SELECT Artist.Name, COUNT(*) FROM Track JOIN Album ON Track.AlbumId = Album.AlbumId
-- JOIN Artist ON Album.ArtistId = Artist.ArtistId
-- LIMIT 10;

/* How many tracks are in the Rock genre? (1297) */
SELECT COUNT(*) FROM Track JOIN Genre ON Track.GenreId = Genre.GenreId WHERE Genre.Name = 'Rock';

/* How many tracks are performed by REM? (41) */
SELECT Artist.Name, COUNT(*) FROM Track JOIN Album ON Track.AlbumId = Album.AlbumId 
JOIN Artist ON Album.ArtistId = Artist.ArtistId WHERE Artist.Name = 'R.E.M.'; 

/* How many tracks are performed by REM with other artists? (52) */
SELECT Artist.Name, COUNT(*) FROM Track JOIN Album ON Track.AlbumId = Album.AlbumId 
JOIN Artist ON Album.ArtistId = Artist.ArtistId WHERE Artist.Name LIKE 'R.%' AND Artist.Name != 'R.E.M';

/* There are no Albums in collaboration with KRRS One */
SELECT Artist.Name FROM Album JOIN Artist ON Album.ArtistId = Artist.ArtistId WHERE Artist.Name LIKE'R.%';


/* What was the sales total for January 2010? (52.62) */
SELECT SUM(Total) FROM Invoice WHERE InvoiceDate BETWEEN date('2010-01-01') AND date('2010-01-31');

/* What is the average length of a song by REM? (4.04 min) */
SELECT Artist.Name, AVG(Milliseconds)/60000 AS Minutes FROM Artist JOIN Album ON Album.ArtistId = Artist.ArtistId 
JOIN Track ON Album.AlbumId = Track.AlbumId WHERE Artist.Name LIKE '%R.E.M.%';


/* GROUP BY EXAMPLE */
SELECT ArtistId, COUNT(*)
FROM Album
GROUP BY ArtistId
ORDER BY COUNT(*) DESC
LIMIT 10;

/* Which artists have the most tracks? */
SELECT Artist.Name, COUNT(*) 
FROM Track JOIN Album ON Track.AlbumId = Album.AlbumId 
JOIN Artist ON Album.ArtistId = Artist.ArtistId 
GROUP BY Artist.Name 
ORDER BY COUNT(*) DESC LIMIT 10;

/* What is the artist and the album name for the album with the longest playing time? */
SELECT Artist.Name, Album.Title, SUM(Track.Milliseconds)/60000 AS TotalTime 
FROM Track JOIN Album ON Track.AlbumId = Album.AlbumId 
JOIN Artist ON Album.ArtistId = Artist.ArtistId 
GROUP BY Artist.Name, Album.Title 
ORDER BY TotalTime DESC LIMIT 10;














