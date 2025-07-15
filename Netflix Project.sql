CREATE DATABASE Netflix;

USE Netflix;

-- Creating Table 

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(6),
    type         VARCHAR(10),  
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

SELECT * FROM netflix
LIMIT 100;

-- Total number of records
SELECT COUNT(*) AS Total_content FROM netflix;

-- Checking the typesof content 

SELECT
	DISTINCT type
FROM 
	netflix;


-- 15 Business Problems

-- 1. Count the Number of Movies vs TV Shows

SELECT type, COUNT (*) AS Total_content
FROM netflix
GROUP BY type;

-- 2. Find the Most Common Rating for Movies and TV Shows
WITH common_rating AS 
(

	SELECT 
		type, 
		rating, 
		count(*) as total_rating,
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC ) AS ranking
	FROM netflix
	GROUP BY type,rating
	
)

SELECT 	
	type, 
	rating 	 
FROM common_rating
WHERE ranking  = 1;

-- 3. List All Movies Released in a Specific Year (e.g., 2020)
 SELECT 
 	* 
 FROM netflix
 WHERE
 	type = 'Movie' 
	AND
	release_year = 2020;
 
-- 4. Find the Top 5 Countries with the Most Content on Netflix
SELECT 
	UNNEST(STRING_TO_ARRAY (country,',')) AS new_country,
	COUNT(*)
FROM netflix
GROUP BY new_country 
ORDER BY COUNT(*) DESC
LIMIT 5; 

-- 5. Identify the Longest Movie

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix);

-- 6. Find Content Added in the Last 5 Years

SELECT
	*
FROM
	netflix
WHERE
	To_DATE(date_added,'Month DD,YYYY') = CURRENT_DATE - INTERVAL '5 years'
	
-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT 
	*
FROM 
	netflix
WHERE 
	director like '%Rajiv Chilaka%';

-- 8. List All TV Shows with More Than 5 Season

SELECT 
		*
FROM 
		netflix	
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration,' ',1):: NUMERIC > 5;

-- 9. Count the Number of Content Items in Each Genre

SELECT 
	
	UNNEST(STRING_TO_ARRAY (listed_in,',')) As Genre,
	COUNT(show_id)
FROM 
	netflix
GROUP BY 
	Genre
ORDER BY 
	COUNT(show_id) DESC;

-- 10. Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg. release

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) AS year,
	COUNT (*) AS yearly_content,
	ROUND(COUNT(*) :: NUMERIC /(SELECT COUNT(*)FROM netflix WHERE country = 'India') :: NUMERIC *100,2)AS Avg_content_per_year

FROM netflix
WHERE country = 'India'
GROUP BY 1;

-- 11. List All Movies that are Documentaries

SELECT 
	*
FROM 
	netflix
WHERE 
	listed_in LIKE '%Documentaries';

-- 12.  Find All Content Without a Director
SELECT * 
FROM 
	netflix 
WHERE director IS NULL;

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT 
	*
FROM 
	netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND 
	release_year >  EXTRACT (YEAR FROM CURRENT_DATE) - 10 ;
	
-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India


SELECT
		
		UNNEST (STRING_TO_ARRAY(casts,',')) AS actor,
		COUNT(*) as total_content
FROM 
		netflix
WHERE 
	country ILIKE '%India%'
GROUP BY 
	1 
ORDER BY 
	2 DESC
LIMIT 10;

'''
	Categorize the content based on the presence of keyword 'Kill' and 'Violence' in the description
	field . label the content containing these key words as 'Bad' and all other content as 'Good'.
	Count how amny item fall into each category.

'''
SELECT 
	COUNT(show_id),
	CASE
	WHEN description ILIKE 'kill' OR description ILIKE 'violence' THEN 'BAD'

	ELSE 'GOOD'
	END category
from netflix
GROUP BY 2;




























