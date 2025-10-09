-- Netflix Analysis Project

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
	(
	show_id			VARCHAR(10),
	show_type		VARCHAR(10),			
	title			VARCHAR(155),
	director		VARCHAR(255),
	show_cast		VARCHAR(800),
	country			VARCHAR(150),
	date_added		VARCHAR(50),
	release_year	INT,
	rating			VARCHAR(10),
	duration		VARCHAR(15),
	listed_in		VARCHAR(100),
	description		VARCHAR(250)
	);



-- STEP 1:  Quick Profiling

SELECT * FROM netflix;

SELECT COUNT(*) Total_rows FROM netflix;

-- Distinct types

SElECT DISTINCT show_type FROM netflix;
SElECT DISTINCT rating FROM netflix;

-- Count by TYPE

SELECT show_type, COUNT(*) FROM netflix GROUP BY 1;

-- Top 5 countries with most title

SELECT country, COUNT(*)
FROM netflix
WHERE country IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- STEP 2: Data Cleaning and Data completness
-- Checking for missing VALUES

SELECT 
  COUNT(*) FILTER (WHERE director IS NULL) AS missing_director,
  COUNT(*) FILTER (WHERE country IS NULL) AS missing_country,
  COUNT(*) FILTER (WHERE date_added IS NULL) AS missing_date,
  COUNT(*) FILTER (WHERE rating IS NULL) AS missing_rating
FROM netflix;

-- Handling missing values

UPDATE netflix
SET country = COALESCE(NULLIF(TRIM(country), ''), 'Unknown'),
	director = COALESCE(NULLIF(TRIM(director), ''), 'Not Provided'),
	rating = COALESCE(NULLIF(TRIM(rating), ''), 'UnRated'),
	show_cast = COALESCE(NULLIF(TRIM(show_cast), ''), 'Not Provided');

SELECT * FROM netflix WHERE show_cast = 'Not Provided';


-- Fix case incosistencies

SELECT  DISTINCT show_type FROM netflix;

UPDATE netflix
SET show_type = INITCAP(show_type);  -- Converts 'movie' → 'Movie'


-- STEP 3: Add usefull calculated COLUMNS

-- Standardize Duration Field

SELECT * FROM netflix;

ALTER TABLE netflix ADD COLUMN duration_value INT;
ALTER TABLE netflix ADD COLUMN duration_unit VARCHAR(20);

UPDATE netflix
SET duration_value = CAST(split_part(duration, ' ', 1) AS INT),
	duration_unit = split_part(duration, ' ', 2);















