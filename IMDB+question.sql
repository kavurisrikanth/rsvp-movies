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
7997	14662	3867	15615	25735	7997
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
-- Country
-- Worldwide Gross Income
-- Languages
-- Production Company
*/

-- Query not working
-- select 
-- 	(case 
-- 		when (SELECT COUNT(*) FROM movie WHERE title IS NULL) <> 0 then 'Title' 
-- 		when (SELECT COUNT(*) FROM movie WHERE year IS NULL) <> 0 then 'Year' 
-- 		when (SELECT COUNT(*) FROM movie WHERE date_published IS NULL) <> 0 then 'Date Published' 
-- 		when (SELECT COUNT(*) FROM movie WHERE duration IS NULL) <> 0 then 'Duration' 
-- 		when (SELECT COUNT(*) FROM movie WHERE country IS NULL) <> 0 then 'Country' 
-- 		when (SELECT COUNT(*) FROM movie WHERE worlwide_gross_income IS NULL) <> 0 then 'Worldwide Gross Income' 
-- 		when (SELECT COUNT(*) FROM movie WHERE languages IS NULL) <> 0 then 'Languages' 
-- 		when (SELECT COUNT(*) FROM movie WHERE production_company IS NULL) <> 0 then 'Production Company' 
-- 	end) as Null_Columns;

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
2017	3052
2018	2944
2019	2001
*/

SELECT MONTH(date_published) AS month_num, COUNT(*) AS number_of_movies FROM movie GROUP BY month_num ORDER BY number_of_movies desc;

/*
3	824
9	809
1	804
10	801
4	680
8	678
2	640
11	625
5	625
6	580
7	493
12	438

Most movies are produced in March
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(*) AS movies_count FROM movie WHERE year = 2019 AND (country LIKE '%India%' OR country LIKE '%USA%');

/*
1059
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT genre FROM genre GROUP BY genre ORDER BY genre;

/*
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
Drama	4285
Comedy	2412
Thriller	1484
Action	1289
Horror	1208
Romance	906
Crime	813
Adventure	591
Mystery	555
Sci-Fi	375
Fantasy	342
Family	302
Others	100

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
GROUP BY genre;

/*
Drama	106.7746
Fantasy	105.1404
Thriller	101.5761
Comedy	102.6227
Horror	92.7243
Family	100.9669
Romance	109.5342
Adventure	101.8714
Action	112.8829
Sci-Fi	97.9413
Crime	107.0517
Mystery	101.8000
Others	100.1600

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
	SELECT g.genre AS genre, count(m.id) AS movie_count, ROW_NUMBER() OVER (ORDER BY count(m.id) DESC) AS genre_rank 
    FROM movie m INNER JOIN genre g ON m.id = g.movie_id 
    GROUP BY genre
) 
SELECT * FROM genre_ranks WHERE genre = 'Thriller';

/*
Thriller	1484	3

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
1.0	10.0	100	725138	1	10
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

SELECT m.title, r.avg_rating, ROW_NUMBER() OVER (ORDER BY r.avg_rating DESC) AS movie_rank FROM movie m INNER JOIN ratings r ON m.id = r.movie_id LIMIT 10;

/*
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
7	2257
6	1975
8	1030
5	985
4	479
9	429
10	346
3	283
2	119
1	94

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
Dream Warrior Pictures	3	1
National Theatre Live	3	2

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
GROUP BY genre;

/*
The Blue Elephant 2			8.8	Drama
The Blue Elephant 2			8.8	Horror
The Blue Elephant 2			8.8	Mystery
The Irishman				8.7	Crime
Theeran Adhigaaram Ondru	8.3	Action
Theeran Adhigaaram Ondru	8.3	Thriller
The King and I				8.2	Romance

Some movies have more than 1 genre
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
select count(*) as num_movies 
from movie m inner join ratings r on m.id = r.movie_id 
where m.date_published BETWEEN '2018-04-01' AND '2019-04-01' and r.median_rating = 8;

/*
361

There were 361 such movies
*/

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

with movie_ratings as (select r.total_votes, m.country from movie m inner join ratings r on m.id = r.movie_id) 
select 
	(select count(*) from movie_ratings where country like '%Germany%') as german_movies_votes, 
    (select count(*) from movie_ratings where country like '%Italy%') as italian_movies_votes;

/*
German	Italian
380		202

Yes
*/

-- Answer is Yes

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

select n.name, count(dm.movie_id) movie_count 
from 
	director_mapping dm inner join names n on dm.name_id = n.id 
where dm.movie_id in (
	select g.movie_id from genre g inner join ratings r on g.movie_id = r.movie_id where g.genre in
	(
		select genre from (
			select g.genre as genre, row_number() over (order by count(g.movie_id) desc) as genre_rank 
			from genre g inner join ratings r on g.movie_id = r.movie_id 
			where r.avg_rating > 8 
			group by g.genre 
			limit 3
		) as top_3_genres
	) AND r.avg_rating > 8
)
group by n.name 
order by movie_count desc;

/*
Marianne Elliott	2
Joe Russo			2
Anthony Russo		2
James Mangold		2
*/

-- select m.title from movie m where m.id in (
-- 	select movie_id from director_mapping where name_id in (
-- 		select id from names where name = 'James Mangold'
-- 	)
-- );

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

with top_actors as (
	select name_id, count(rm.movie_id) as movie_count 
	from ratings r inner join role_mapping rm on r.movie_id = rm.movie_id where r.median_rating >= 8 group by name_id order by movie_count desc
)
select n.name, movie_count 
from names n 
inner join top_actors ta on n.id = ta.name_id 
limit 2;

/*
Mammootty	8
Mohanlal	5
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

select m.production_company, sum(r.total_votes) as vote_count, dense_rank() over (order by r.total_votes desc) 
from movie m inner join ratings r on m.id = r.movie_id 
group by m.production_company;

/*
Marvel Studios	2656967	1
Syncopy			487517	2
New Line Cinema	599440	3
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

with actor_ranks as (
	select 
		rm.name_id, 
		sum(r.total_votes) as total_votes, 
		count(rm.movie_id) as movie_count, 
		round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes), 2) as actor_avg_rating, 
		dense_rank() over (order by round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes), 2) desc) as actor_rank 
	from role_mapping rm 
		inner join ratings r on rm.movie_id = r.movie_id 
		inner join movie m on m.id = r.movie_id 
	where m.country like '%India%'
	group by rm.name_id 
	having movie_count >= 5 
	order by actor_rank, total_votes desc
)
select n.name, ar.total_votes, ar.movie_count, ar.actor_avg_rating, ar.actor_rank 
from names n inner join actor_ranks ar on n.id = ar.name_id;

/*
Vijay Sethupathi	23114	5	8.42	1
Fahadh Faasil		13557	5	7.99	2
Yogi Babu			8500	11	7.83	3
Taapsee Pannu		18895	5	7.70	4
Joju George			3926	5	7.58	5
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

with actor_ranks as (
	select 
		rm.name_id, 
		sum(r.total_votes) as total_votes, 
		count(rm.movie_id) as movie_count, 
		round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes), 2) as actress_avg_rating, 
		dense_rank() over (order by round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes), 2) desc) as actress_rank 
	from role_mapping rm 
		inner join ratings r on rm.movie_id = r.movie_id 
		inner join movie m on m.id = r.movie_id 
	where m.country like '%India%' and m.languages like '%Hindi%' and rm.category = 'actress' 
	group by rm.name_id 
	having movie_count >= 3 
	order by actress_rank, total_votes desc
)
select n.name, ar.total_votes, ar.movie_count, ar.actress_avg_rating, ar.actress_rank 
from names n inner join actor_ranks ar on n.id = ar.name_id;

/*
Taapsee Pannu	18061	3	7.74	1
Kriti Sanon		21967	3	7.05	2
Divya Dutta		8579	3	6.88	3
Shraddha Kapoor	26779	3	6.63	4
Kriti Kharbanda	2549	3	4.80	5
Sonakshi Sinha	4025	4	4.18	6
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

select m.title, r.avg_rating, (case when avg_rating > 8 then 'Superhit' when avg_rating > 7 then 'Hit' when avg_rating > 5 then 'One-time-watch' else 'Flop' end) as success_level 
from genre g 
	inner join ratings r on g.movie_id = r.movie_id 
    inner join movie m on m.id = g.movie_id 
where g.genre = 'Thriller' 
group by success_level, title 
order by avg_rating desc;


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

select 
	g.genre,
    round(avg(duration), 2) as avg_duration,
    round(sum(avg(duration)) over (order by genre rows unbounded preceding), 2) as running_total_duration,
    round(avg(avg(duration)) over (order by genre rows unbounded preceding), 2) as moving_avg_duration
from movie m inner join genre g on m.id = g.movie_id 
group by g.genre;

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
Thriller	101.58	1341.05	103.16
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

with ranks as (
	select genre, m.year, title as movie_name, worlwide_gross_income, dense_rank() over (partition by m.year order by worlwide_gross_income desc) as movie_rank 
	from genre g inner join movie m on g.movie_id = m.id 
	where g.genre in (
		select genre from (
			select g.genre as genre, row_number() over (order by count(g.movie_id) desc) as genre_rank 
			from genre g inner join ratings r on g.movie_id = r.movie_id 
			group by g.genre 
			limit 3
		) as top_3_genres
	)
)
select * from ranks where movie_rank <= 5;



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

with multilinguals as (
	select id, production_company from movie m where production_company is not null and m.languages regexp '^[a-zA-Z]+,[ ]?[a-zA-Z]+.*$'
)
select production_company, count(movie_id) as movie_count, dense_rank() over (order by count(movie_id) desc) as prod_comp_rank 
from multilinguals m inner join ratings r on m.id = r.movie_id 
where median_rating >= 8
group by production_company 
limit 2;


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

with top_drama as (
	select rm.name_id, sum(total_votes) as total_votes, count(rm.movie_id) as movie_count, avg_rating as actress_avg_rating, dense_rank() over (order by count(rm.movie_id) desc) as actress_rank 
	from genre g 
		inner join ratings r on g.movie_id = r.movie_id 
		inner join role_mapping rm on rm.movie_id = g.movie_id 
	where genre = 'Drama' and rm.category = 'actress' 
	group by rm.name_id 
	having avg_rating > 8
)
select n.name, total_votes, movie_count, actress_avg_rating, actress_rank 
from top_drama td inner join names n on td.name_id = n.id;


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

with movie_dates as 
(
	select 
		dm.name_id as director_id, 
        date_published,
        lead(date_published, 1) over (partition by dm.name_id order by date_published) as next_movie_by_dir
	from 
		movie m inner join director_mapping dm on m.id = dm.movie_id 
	group by movie_id, director_id, date_published
),
movie_date_diffs as (
	select 
		*, 
		datediff(next_movie_by_dir, date_published) as movie_diff
    from movie_dates 
    where next_movie_by_dir is not null
),
avg_movie_diff as (
	select 
		director_id, 
        round(avg(movie_diff), 2) as avg_inter_movie_days
    from movie_date_diffs 
    group by director_id
)
select 
	director_id,
    n.name as director_name,
    count(dm.movie_id) as num_movies,
    avg_inter_movie_days,
    round(avg(avg_rating), 2) as avg_rating,
    total_votes,
    min(avg_rating) as min_rating,
    max(avg_rating) as max_rating,
    sum(duration) as total_duration,
    dense_rank() over (order by count(dm.movie_id) desc)
from 
	avg_movie_diff md 
		inner join director_mapping dm on dm.name_id = md.director_id 
        inner join movie m on dm.movie_id = m.id 
        inner join ratings r on r.movie_id = dm.movie_id 
        inner join names n on dm.name_id = n.id 
group by director_id 
limit 9;
