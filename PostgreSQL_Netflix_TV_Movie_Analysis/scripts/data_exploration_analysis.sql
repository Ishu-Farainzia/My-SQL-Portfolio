-- Data Exploration (EDA)

-- Business style questions:


-- 1. What’s the ratio of Movies vs TV Shows in Netflix’s library?

SELECT show_type, COUNT(*) FROM netflix GROUP BY 1;


-- 2. Which countries produce the most content on Netflix?

SELECT country, COUNT(*) 
FROM netflix
WHERE country IS NOT NULL
GROUP BY country, show_type
ORDER BY 2 DESC
LIMIT 10;

-- 3. How has Netflix’s content addition trended over the years?

SELECT release_year, COUNT(*) 
FROM netflix
GROUP BY 1
ORDER BY 1;	

-- 4. Who are the top 10 most frequent directors?

SELECT director, COUNT(*)
FROM netflix
WHERE director <> 'Not Provided'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- 5. What are the most common genres (listed_in)?

SELECT * FROM netflix;

SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) genre,
		COUNT(*)
FROM netflix
GROUP BY genre
ORDER BY 2 DESC
LIMIT 10;


-- 6. Find the Most Common Rating for Movies and TV Shows

SELECT
	show_type, 
	rating
FROM 
(
	SELECT 
		show_type, 
		rating, 
		COUNT(*),
		RANK() OVER(PARTITION BY show_type ORDER BY COUNT(*) DESC) ranking
	FROM netflix
	GROUP BY 1, 2
) as t1
WHERE ranking = 1;


-- 7.  List All Movies Released in a Specific Year (e.g., 2020)

SELECT * 
FROM netflix
WHERE show_type = 'Movie' AND release_year = 2020;


-- 8. Find the Top 5 Countries with the Most Content on Netflix

SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) country, COUNT(*)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT country FROM netflix;


-- 9. Identify the Longest Movie

SELECT * FROM netflix;

SELECT show_type, title, duration_value
FROM netflix
WHERE duration_value IS NOT NULL
ORDER BY duration_value DESC
LIMIT 1;


-- 10. Find Content Added in the Last 10 Years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAl '10 year';


-- 11. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT *
FROM
(
	SELECT *, TRIM(UNNEST(STRING_TO_ARRAY(director, ','))) n_director
	FROM netflix
) as t1
WHERE n_director LIKE '%Rajiv Chilaka%';


-- 12. List All TV Shows with More Than 5 Seasons

SELECT * 
FROM netflix
WHERE show_type = 'Tv Show' AND duration_value > 5;


-- 13. Count the Number of Content Items in Each Genre

SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) listed_in_new, COUNT(*)
FROM netflix
GROUP BY 1;


-- 14. Find each year and the average numbers of content release in India on netflix and return top 5 year with highest avg content release!.

SELECT * FROM netflix;

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) years,
	country,
	ROUND(COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::NUMERIC * 100,2) as avg_contents
FROM netflix
WHERE country LIKE '%India%'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 5;


-- 15. List All Movies that are Documentaries

SELECT *
FROM
(
	SELECT *, TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) as listed_in_fix
	FROM netflix
)
WHERE 
	show_type = 'Movie' 
AND listed_in_fix LIKE '%Docu%';


-- 16. Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director = 'Not Provided';


-- 17. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT show_type, COUNT(*)
FROM netflix
WHERE show_cast LIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10
GROUP BY 1;

-- 18. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT TRIM(UNNEST(STRING_TO_ARRAY(show_cast, ','))) actor, COUNT(*)
FROM netflix
WHERE country LIKE '%India%' AND show_type = 'Movie'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- 19. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT * FROM netflix; 

SELECT category, COUNT(*)
FROM
(
	SElECT 
		CASE 
			WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
			ELSE 'Good'
		END AS category
	FROM netflix
) AS category_content
GROUP BY category;












