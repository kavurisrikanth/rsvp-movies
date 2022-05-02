USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- movie
-- genre
-- director_mapping
-- role_mapping
-- names
-- ratings
SELECT 
	(SELECT COUNT(*) FROM movie) AS movies_count,
    (SELECT COUNT(*) FROM genre) AS genres_count,
    (SELECT COUNT(*) FROM director_mapping) AS director_count,
    (SELECT COUNT(*) FROM role_mapping) AS role_count,
    (SELECT COUNT(*) FROM names) AS name_count,
    (SELECT COUNT(*) FROM ratings) AS rating_count;

/*
movies_count	genres_count	director_count	role_count	name_count	rating_count
7997			14662			3867			15615		25735		7997
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- title
-- year
-- date_published
-- duration
-- country
-- worlwide_gross_income
-- languages
-- production_company
SELECT 
	(SELECT COUNT(*) FROM movie WHERE title IS NULL) AS null_title_count,
    (SELECT COUNT(*) FROM movie WHERE year IS NULL) AS null_year_count,
    (SELECT COUNT(*) FROM movie WHERE date_published IS NULL) AS null_date_count,
    (SELECT COUNT(*) FROM movie WHERE duration IS NULL) AS null_duration_count,
    (SELECT COUNT(*) FROM movie WHERE country IS NULL) AS null_country_count,
    (SELECT COUNT(*) FROM movie WHERE worlwide_gross_income IS NULL) AS null_gross_count,
    (SELECT COUNT(*) FROM movie WHERE languages IS NULL) AS null_languages_count,
    (SELECT COUNT(*) FROM movie WHERE production_company IS NULL) AS null_production_count;

/*
null_title_count	null_year_count		null_date_count		null_duration_count		null_country_count	null_gross_count	null_languages_count	null_production_count
	0					0					0					0						20					3724				194						528
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year AS Year, COUNT(*) AS number_of_movies FROM movie GROUP BY year;

/*
Year	number_of_movies
2017	3052
2018	2944
2019	2001
*/

SELECT MONTH(date_published) AS month_num, COUNT(*) AS number_of_movies FROM movie GROUP BY month_num ORDER BY number_of_movies desc;

/*
month_num	number_of_movies
3			824
9			809
1			804
10			801
4			680
8			678
2			640
11			625
5			625
6			580
7			493
12			438

Most movies are produced in March
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(*) AS movies_count FROM movie WHERE year = 2019 AND (country LIKE '%India%' OR country LIKE '%USA%');

/*
movies_count
1059
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT genre FROM genre GROUP BY genre ORDER BY genre;

/*
genre

Action
Adventure
Comedy
Crime
Drama
Family
Fantasy
Horror
Mystery
Others
Romance
Sci-Fi
Thriller
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
    g.genre AS genre, COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
ORDER BY movie_count DESC;

/*
genre		movie_count
Drama		4285
Comedy		2412
Thriller	1484
Action		1289
Horror		1208
Romance		906
Crime		813
Adventure	591
Mystery		555
Sci-Fi		375
Fantasy		342
Family		302
Others		100

Most movies produced are of genre Drama, Comedy, Thriller
*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(*) AS num_movies
FROM (SELECT movie_id 
	FROM
        genre
    GROUP BY movie_id
    HAVING COUNT(genre) = 1) AS single_genre_movies;
/*
num_movies
3289
*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    g.genre AS genre, AVG(duration) AS average_duration
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre 
order by average_duration desc;

/*
genre		average_duration
Drama		106.7746
Fantasy		105.1404
Thriller	101.5761
Comedy		102.6227
Horror		92.7243
Family		100.9669
Romance		109.5342
Adventure	101.8714
Action		112.8829
Sci-Fi		97.9413
Crime		107.0517
Mystery		101.8000
Others		100.1600

Drama movies are mostly of length 106 minutes on average
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_ranks AS (
	SELECT 
		g.genre AS genre, 
        count(g.movie_id) AS movie_count, 
        ROW_NUMBER() OVER (ORDER BY count(g.movie_id) DESC) AS genre_rank 
    FROM 
		genre g 
    GROUP BY genre
) 
SELECT * FROM genre_ranks WHERE genre = 'Thriller';

/*
genre		movie_count		genre_rank
Thriller	1484			3

With 1484 movies produced, Thriller movies' rank is 3
*/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;

/*
min_avg_rating	max_avg_rating	min_total_votes		max_total_votes		min_median_rating	max_median_rating
1.0					10.0			100					725138				1					10
*/

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT 
	m.title, 
    r.avg_rating, 
    ROW_NUMBER() OVER (ORDER BY r.avg_rating DESC) AS movie_rank 
FROM movie m INNER JOIN ratings r ON m.id = r.movie_id 
LIMIT 10;

/*
title							avg_rating	movie_rank
Kirket								10.0	1
Love in Kilnerry					10.0	2
Gini Helida Kathe					9.8		3
Runam								9.7		4
Fan									9.6		5
Android Kunjappan Version 	5.25	9.6		6
Yeh Suhaagraat Impossible			9.5		7
Safe								9.5		8
The Brighton Miracle				9.5		9
Shibu								9.4		10
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY movie_count DESC;

/*
median_rating	movie_count
7				2257
6				1975
8				1030
5				985
4				479
9				429
10				346
3				283
2				119
1				94

Most movies have a median rating of 7, 6, and 8
*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    production_company, 
    COUNT(movie_id) AS movie_count,
    ROW_NUMBER() OVER (
		ORDER BY COUNT(movie_id) DESC
    ) as prod_company_rank
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE production_company IS NOT NULL AND r.avg_rating > 8
GROUP BY production_company;

/*
production_company		movie_count		prod_company_rank
Dream Warrior Pictures		3				1
National Theatre Live		3				2
Lietuvos Kinostudija		2				3
...

Dream Warrior Pictures or National Theater Live
*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre AS genre, COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    country LIKE '%USA%' 
		AND year = 2017
        AND MONTH(date_published) = 3
        AND r.total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

/*
genre	movie_count
Drama		24
Comedy		9
Action		8
Thriller	8
Sci-Fi		7
Crime		6
Horror		6
Mystery		4
Romance		4
Fantasy		3
Adventure	3
Family		1

Movies with high number of votes are Drama, Comedt, and Action
*/

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.title AS title,
    r.avg_rating AS avg_rating,
    g.genre AS genre
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    avg_rating > 8 AND title LIKE 'The%'
order by avg_rating desc;

/*
title								avg_rating	genre
The Brighton Miracle					9.5		Drama
The Colour of Darkness					9.1		Drama
The Blue Elephant 2						8.8		Drama
The Blue Elephant 2						8.8		Horror
The Blue Elephant 2						8.8		Mystery
The Irishman							8.7		Crime
The Irishman							8.7		Drama
The Mystery of Godliness: The Sequel	8.5		Drama
The Gambinos							8.4		Crime
The Gambinos							8.4		Drama
Theeran Adhigaaram Ondru				8.3		Action
Theeran Adhigaaram Ondru				8.3		Crime
Theeran Adhigaaram Ondru				8.3		Thriller
The King and I							8.2		Drama
The King and I							8.2		Romance

Some movies have more than 1 genre
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
    COUNT(*) AS num_movies
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND r.median_rating = 8;

/*
num_movies
361

There were 361 such movies
*/

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH movie_ratings AS (SELECT r.total_votes, m.country FROM movie m INNER JOIN ratings r ON m.id = r.movie_id) 
SELECT 
	(SELECT sum(total_votes) FROM movie_ratings WHERE country LIKE '%Germany%') AS german_movies_votes, 
    (SELECT sum(total_votes) FROM movie_ratings WHERE country LIKE '%Italy%') AS italian_movies_votes;
    
/*
german_movies_votes		italian_movies_votes
	2026223						703024
*/
    
WITH movie_ratings AS (SELECT r.total_votes, m.languages FROM movie m INNER JOIN ratings r ON m.id = r.movie_id) 
SELECT 
	(SELECT sum(total_votes) FROM movie_ratings WHERE languages LIKE '%German%') AS german_movies_votes, 
    (SELECT sum(total_votes) FROM movie_ratings WHERE languages LIKE '%Italian%') AS italian_movies_votes;

/*
german_movies_votes		italian_movies_votes
	4421525					2559540

Yes
*/

-- Answer is Yes comparing countries or languages

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:
-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	(SELECT COUNT(*) FROM names WHERE name IS NULL) AS null_name_count,
    (SELECT COUNT(*) FROM names WHERE height IS NULL) AS null_height_count,
    (SELECT COUNT(*) FROM names WHERE date_of_birth IS NULL) AS null_dob_count,
    (SELECT COUNT(*) FROM names WHERE known_for_movies IS NULL) AS null_known_for_movies_count;

/*
name	height	dob		known
0		17335	13431	15226

There are many obscure actors, but all have names.
*/

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Get top 3 genres

SELECT n.name,
       count(dm.movie_id) movie_count
FROM director_mapping dm
INNER JOIN NAMES n ON dm.name_id = n.id
WHERE dm.movie_id IN
    (SELECT g.movie_id
     FROM genre g
     INNER JOIN ratings r ON g.movie_id = r.movie_id
     WHERE g.genre IN
         (SELECT genre
          FROM
            (SELECT g.genre AS genre,
                    row_number() OVER (
                                       ORDER BY count(g.movie_id) DESC) AS genre_rank
             FROM genre g
             INNER JOIN ratings r ON g.movie_id = r.movie_id
             WHERE r.avg_rating > 8
             GROUP BY g.genre
             LIMIT 3) AS top_3_genres)
       AND r.avg_rating > 8 )
GROUP BY n.name
ORDER BY movie_count DESC,
         name;

/*
name			movie_count
Anthony Russo		2
James Mangold		2
Joe Russo			2
Marianne Elliott	2
*/

-- Test queries to verify query result
-- select m.title from movie m where m.id in (
-- 	select movie_id from director_mapping where name_id in (
-- 		select id from names where name = 'James Mangold'
-- 	)
-- );

-- select * 
-- from names n 
-- 	inner join director_mapping dm on n.id = dm.name_id 
-- 	inner join movie m on m.id = dm.movie_id
-- where n.name = 'James Mangold';

-- select m.title from movie m where m.id in (
-- 	select movie_id from director_mapping where name_id in (
-- 		select id from names where name = 'Anthony Russo'
-- 	)
-- );

-- select m.title from movie m where m.id in (
-- 	select movie_id from director_mapping where name_id in (
-- 		select id from names where name = 'Joe Russo'
-- 	)
-- );

-- select m.title from movie m where m.id in (
-- 	select movie_id from director_mapping where name_id in (
-- 		select id from names where name = 'Marianne Elliott'
-- 	)
-- );

-- select * from movie where title like '%Wolverine%';

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name,
       count(rm.movie_id) AS movie_count
FROM ratings r
INNER JOIN role_mapping rm ON r.movie_id = rm.movie_id
INNER JOIN NAMES n ON n.id = rm.name_id
WHERE r.median_rating >= 8
GROUP BY name_id
ORDER BY movie_count DESC
LIMIT 2;

/*
name		movie_count
Mammootty		8
Mohanlal		5
*/


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
       sum(r.total_votes) AS vote_count,
       dense_rank() OVER (
                          ORDER BY sum(r.total_votes) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY m.production_company
LIMIT 3;

/*
production_company		vote_count	prod_comp_rank
Marvel Studios			2656967			1
Twentieth Century Fox	2411163			2
Warner Bros.			2396057			3
*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Get actors with movies in India

WITH actor_ranks AS
  (SELECT rm.name_id,
          sum(r.total_votes) AS total_votes,
          count(rm.movie_id) AS movie_count,
          round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes), 2) AS actor_avg_rating,
          dense_rank() OVER (
                             ORDER BY round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes), 2) DESC) AS actor_rank
   FROM role_mapping rm
   INNER JOIN ratings r ON rm.movie_id = r.movie_id
   INNER JOIN movie m ON m.id = r.movie_id
   WHERE m.country like '%India%'
     AND rm.category = 'actor'
   GROUP BY rm.name_id
   HAVING movie_count >= 5
   ORDER BY actor_rank,
            total_votes DESC)
SELECT n.name,
       ar.total_votes,
       ar.movie_count,
       ar.actor_avg_rating,
       ar.actor_rank
FROM NAMES n
INNER JOIN actor_ranks ar ON n.id = ar.name_id;

/*
name_id				total_votes		movie_count		actor_avg_rating	actor_rank
Vijay Sethupathi	23114				5				8.42				1
Fahadh Faasil		13557				5				7.99				2
Yogi Babu			8500				11				7.83				3
Joju George			3926				5				7.58				4
Ammy Virk			2504				6				7.55				5
...
*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_ranks AS
  (SELECT rm.name_id,
          sum(r.total_votes) AS total_votes,
          count(rm.movie_id) AS movie_count,
          round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes), 2) AS actress_avg_rating,
          dense_rank() OVER (
                             ORDER BY round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes), 2) DESC) AS actress_rank
   FROM role_mapping rm
   INNER JOIN ratings r ON rm.movie_id = r.movie_id
   INNER JOIN movie m ON m.id = r.movie_id
   WHERE m.country like '%India%'
     AND m.languages like '%Hindi%'
     AND rm.category = 'actress'
   GROUP BY rm.name_id
   HAVING movie_count >= 3
   ORDER BY actress_rank,
            total_votes DESC)
SELECT n.name,
       ar.total_votes,
       ar.movie_count,
       ar.actress_avg_rating,
       ar.actress_rank
FROM NAMES n
INNER JOIN actor_ranks ar ON n.id = ar.name_id;

/*
name			total_votes		movie_count		actress_avg_rating	actress_rank
Taapsee Pannu	18061				3				7.74				1
Kriti Sanon		21967				3				7.05				2
Divya Dutta		8579				3				6.88				3
Shraddha Kapoor	26779				3				6.63				4
Kriti Kharbanda	2549				3				4.80				5
Sonakshi Sinha	4025				4				4.18				6
*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,
       r.avg_rating,
       (CASE
            WHEN avg_rating > 8 THEN 'Superhit'
            WHEN avg_rating > 7 THEN 'Hit'
            WHEN avg_rating > 5 THEN 'One-time-watch'
            ELSE 'Flop'
        END) AS success_level
FROM genre g
INNER JOIN ratings r ON g.movie_id = r.movie_id
INNER JOIN movie m ON m.id = g.movie_id
WHERE g.genre = 'Thriller'
GROUP BY success_level,
         title
ORDER BY avg_rating DESC;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT g.genre,
       round(avg(duration), 2) AS avg_duration,
       round(sum(avg(duration)) OVER (ORDER BY genre ROWS UNBOUNDED preceding), 2) AS running_total_duration,
       round(avg(avg(duration)) OVER (ORDER BY genre ROWS UNBOUNDED preceding), 2) AS moving_avg_duration
FROM movie m
INNER JOIN genre g ON m.id = g.movie_id
GROUP BY g.genre;

/*
Genre		avg_duration	running_total_duration	moving_avg_duration
Action		112.88			112.88					112.88
Adventure	101.87			214.75					107.38
Comedy		102.62			317.38					105.79
Crime		107.05			424.43					106.11
Drama		106.77			531.20					106.24
Family		100.97			632.17					105.36
Fantasy		105.14			737.31					105.33
Horror		92.72			830.03					103.75
Mystery		101.80			931.83					103.54
Others		100.16			1031.99					103.20
Romance		109.53			1141.53					103.78
Sci-Fi		97.94			1239.47					103.29
Thriller	101.58			1341.05					103.16
*/

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Convert all incomes to $, since some are in INR.
-- Also, convert incomes from varchar to unsigned int
SELECT id,
       worlwide_gross_income AS wgi,
       CASE
           WHEN locate('$', worlwide_gross_income) > 0 THEN convert(substring_index(worlwide_gross_income, ' ', -1), UNSIGNED INTEGER)
           WHEN locate('INR', worlwide_gross_income) > 0 THEN round(convert(substring_index(worlwide_gross_income, ' ', -1), UNSIGNED INTEGER) / 70, 2)
           ELSE -1
       END AS wgi_amount
FROM movie
WHERE worlwide_gross_income IS NOT NULL;

-- Get movies from converted income amounts
WITH converted_incomes AS
  (SELECT id,
          YEAR,
          title,
          worlwide_gross_income AS wgi,
          CASE
              WHEN locate('$', worlwide_gross_income) > 0 THEN convert(substring_index(worlwide_gross_income, ' ', -1), UNSIGNED INTEGER)
              WHEN locate('INR', worlwide_gross_income) > 0 THEN round(convert(substring_index(worlwide_gross_income, ' ', -1), UNSIGNED INTEGER) / 70, 2)
              ELSE -1
          END AS wgi_amount
   FROM movie
   WHERE worlwide_gross_income IS NOT NULL ),
     ranks AS
  (SELECT genre,
          YEAR,
          title AS movie_name,
          wgi_amount AS worldwide_gross_in_usd,
          dense_rank() OVER (PARTITION BY YEAR
                             ORDER BY wgi_amount DESC) AS movie_rank
   FROM genre g
   INNER JOIN converted_incomes ci ON g.movie_id = ci.id
   WHERE g.genre in
       (SELECT genre
        FROM
          (SELECT g.genre AS genre,
                  row_number() OVER (
                                     ORDER BY count(g.movie_id) DESC) AS genre_rank
           FROM genre g
           INNER JOIN ratings r ON g.movie_id = r.movie_id
           GROUP BY g.genre
           LIMIT 3) AS top_3_genres) )
SELECT *
FROM ranks
WHERE movie_rank <= 5;

/*
Top 3 genres are: Drama, Comedy, Thriller
*/

/*
genre		year	movie_name						worldwide_gross_in_usd	movie_rank
Thriller	2017	The Fate of the Furious			1236005118.00			1
Comedy		2017	Despicable Me 3					1034799409.00			2
Comedy		2017	Jumanji: Welcome to the Jungle	962102237.00			3
Drama		2017	Zhan lang II					870325439.00			4
Thriller	2017	Zhan lang II					870325439.00			4
Comedy		2017	Guardians of the Galaxy Vol. 2	863756051.00			5
Drama		2018	Bohemian Rhapsody				903655259.00			1
Thriller	2018	Venom							856085151.00			2
Thriller	2018	Mission: Impossible - Fallout	791115104.00			3
Comedy		2018	Deadpool 2						785046920.00			4
Comedy		2018	Ant-Man and the Wasp			622674139.00			5
Drama		2019	Avengers: Endgame				2797800564.00			1
Drama		2019	The Lion King					1655156910.00			2
Comedy		2019	Toy Story 4						1073168585.00			3
Drama		2019	Joker							995064593.00			4
Thriller	2019	Joker							995064593.00			4
Thriller	2019	Ne Zha zhi mo tong jiang shi	700547754.00			5
*/

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
       count(movie_id) AS movie_count,
       dense_rank() OVER (ORDER BY count(movie_id) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE production_company IS NOT NULL
  AND median_rating >= 8
  AND m.languages regexp '^[a-zA-Z]+,[ ]?[a-zA-Z]+.*$'
GROUP BY production_company 
LIMIT 2;

/*
production_company		movie_count		prod_comp_rank
	Star Cinema				7				1
Twentieth Century Fox		4				2
*/

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT n.name,
       sum(total_votes) AS total_votes,
       count(rm.movie_id) AS movie_count,
       avg_rating AS actress_avg_rating,
       dense_rank() OVER (
                          ORDER BY count(rm.movie_id) DESC) AS actress_rank
FROM genre g
INNER JOIN ratings r ON g.movie_id = r.movie_id
INNER JOIN role_mapping rm ON rm.movie_id = g.movie_id
INNER JOIN NAMES n ON rm.name_id = n.id
WHERE genre = 'Drama'
  AND rm.category = 'actress'
  AND avg_rating > 8
GROUP BY n.name
LIMIT 3;

/*
	name			 total_votes		movie_count		actress_avg_rating		actress_rank
Parvathy Thiruvothu		4974				2				8.3						1
Susan Brown				656					2				8.9						1
Amanda Lawrence			656					2				8.9						1
*/

-- Test queries to check correctness
/*
-- How many Drama movies has Teresa Palmer acted in?
select * from names where name = 'Teresa Palmer';

select * 
from movie m inner join genre g on m.id = g.movie_id 
	inner join role_mapping rm on rm.movie_id = m.id 
    inner join names n on n.id = rm.name_id 
    inner join ratings r on r.movie_id = m.id 
where n.name = 'Teresa Palmer' and g.genre = 'Drama' and r.avg_rating > 8;
*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH movie_dates AS
  (SELECT dm.name_id AS director_id,
          date_published,
          lead(date_published) OVER (PARTITION BY dm.name_id
                                     ORDER BY date_published) AS next_movie_by_dir
   FROM movie m
   INNER JOIN director_mapping dm ON m.id = dm.movie_id
   GROUP BY movie_id,
            director_id,
            date_published),
     movie_date_diffs AS
  (SELECT *,
          datediff(next_movie_by_dir, date_published) AS movie_diff
   FROM movie_dates
   WHERE next_movie_by_dir IS NOT NULL ),
     avg_movie_diff AS
  (SELECT director_id,
          round(avg(movie_diff), 2) AS avg_inter_movie_days
   FROM movie_date_diffs
   GROUP BY director_id)
SELECT director_id,
       n.name AS director_name,
       count(dm.movie_id) AS num_movies,
       avg_inter_movie_days,
       round(avg(avg_rating), 2) AS avg_rating,
       sum(total_votes) AS total_votes,
       min(avg_rating) AS min_rating,
       max(avg_rating) AS max_rating,
       sum(duration) AS total_duration,
       dense_rank() OVER (
                          ORDER BY count(dm.movie_id) DESC) AS director_rank
FROM avg_movie_diff md
INNER JOIN director_mapping dm ON dm.name_id = md.director_id
INNER JOIN movie m ON dm.movie_id = m.id
INNER JOIN ratings r ON r.movie_id = dm.movie_id
INNER JOIN NAMES n ON dm.name_id = n.id
GROUP BY director_id
ORDER BY num_movies DESC,
         director_name
LIMIT 9;

/*
director_id		director_name		num_movies	avg_inter_movie_days	avg_rating	total_votes	min_rating	max_rating	total_duration	director_rank
nm1777967		A.L. Vijay				5			176.75					5.42		1754		3.7			6.9			613				1
nm2096009		Andrew Jones			5			190.75					3.02		1989		2.7			3.2			432				1
nm0831321		Chris Stokes			4			198.33					4.33		3664		4.0			4.6			352				2
nm0425364		Jesse V. Johnson		4			299.00					5.45		14778		4.2			6.5			383				2
nm2691863		Justin Price			4			315.00					4.50		5343		3.0			5.8			346				2
nm6356309		Özgür Bakar				4			112.00					3.75		1092		3.1			4.9			374				2
nm0515005		Sam Liu					4			260.33					6.23		28557		5.8			6.7			312				2
nm0814469		Sion Sono				4			331.00					6.03		2972		5.4			6.4			502				2
nm0001752		Steven Soderbergh		4			254.33					6.48		171684		6.2			7.0			401				2
*/
