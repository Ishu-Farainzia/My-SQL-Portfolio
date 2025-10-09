# 🎬 Netflix Data Analysis using SQL (PostgreSQL)

## 📖 Project Overview
This project explores Netflix’s global catalog using **PostgreSQL**.  
It involves data cleaning, transformation, and insightful SQL analysis to answer real-world business questions — such as content trends, top directors, popular genres, and country contributions.

---

## 🧰 Tools & Technologies
- **Database**: PostgreSQL  
- **Language**: SQL  
- **Concepts Used**: Data Cleaning, Aggregation, String Manipulation, Date Functions, CTEs, Window Functions

---

## 🗂️ Dataset Description
The dataset contains details of movies and TV shows available on Netflix.

| Column | Description |
|:--|:--|
| `show_id` | Unique identifier for each title |
| `show_type` | Type (Movie or TV Show) |
| `title` | Title of the show |
| `director` | Director(s) |
| `show_cast` | Cast members |
| `country` | Production country |
| `date_added` | Date added to Netflix |
| `release_year` | Year of release |
| `rating` | Content rating (PG, TV-MA, etc.) |
| `duration` | Duration in minutes/seasons |
| `listed_in` | Category or genre |
| `description` | Short summary |

---

## 🧹 Step 1: Data Profiling
Basic dataset exploration.

```sql
SELECT COUNT(*) FROM netflix;
SELECT DISTINCT show_type FROM netflix;
SELECT DISTINCT rating FROM netflix;
SELECT show_type, COUNT(*) FROM netflix GROUP BY 1;
SELECT country, COUNT(*) FROM netflix GROUP BY 1 ORDER BY 2 DESC LIMIT 5;
```

## 🧼 Step 2: Data Cleaning
Handling missing values and case inconsistencies.

```sql
UPDATE netflix
SET country = COALESCE(NULLIF(TRIM(country), ''), 'Unknown'),
    director = COALESCE(NULLIF(TRIM(director), ''), 'Not Provided'),
    rating = COALESCE(NULLIF(TRIM(rating), ''), 'UnRated'),
    show_cast = COALESCE(NULLIF(TRIM(show_cast), ''), 'Not Provided');

UPDATE netflix
SET show_type = INITCAP(show_type); -- 'movie' → 'Movie'
```

## 🧮 Step 3: Feature Engineering
Splitting the duration column for numeric and unit-based analysis.

```sql

ALTER TABLE netflix ADD COLUMN duration_value INT;
ALTER TABLE netflix ADD COLUMN duration_unit VARCHAR(20);

UPDATE netflix
SET duration_value = CAST(split_part(duration, ' ', 1) AS INT),
    duration_unit = split_part(duration, ' ', 2);
```

## 📊 Step 4: Exploratory Data Analysis (19 Business Queries)
**🎥 1. Movies vs TV Shows**
```sql

SELECT show_type, COUNT(*) FROM netflix GROUP BY 1;
🌍 2. Top 10 Content-Producing Countries
sql
Copy code
SELECT country, COUNT(*) 
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;
```
**📈 3. Content Release Trend Over the Years**
```sql

SELECT release_year, COUNT(*) 
FROM netflix
GROUP BY 1
ORDER BY 1;
```

**🎬 4. Top 10 Most Frequent Directors**
```sql

SELECT director, COUNT(*) 
FROM netflix
WHERE director <> 'Not Provided'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

**🎭 5. Most Common Genres**
```sql

SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) genre, COUNT(*)
FROM netflix
GROUP BY genre
ORDER BY 2 DESC
LIMIT 10;
```

**⭐ 6. Most Common Rating by Type**
```sql
SELECT show_type, rating
FROM (
  SELECT show_type, rating, COUNT(*),
         RANK() OVER(PARTITION BY show_type ORDER BY COUNT(*) DESC) r
  FROM netflix
  GROUP BY 1, 2
) t
WHERE r = 1;
```

**📅 7. All Movies Released in 2020**
```sql

SELECT * FROM netflix
WHERE show_type = 'Movie' AND release_year = 2020;
```

**🏆 8. Top 5 Countries with Most Content**
```sql

SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) country, COUNT(*)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**⏱️ 9. Longest Movie**
```sql

SELECT title, duration_value
FROM netflix
WHERE duration_value IS NOT NULL
ORDER BY duration_value DESC
LIMIT 1;
```

***⌛ 10. Content Added in Last 10 Years**
```sql

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 year';
```

**🎞️ 11. All Content by Director ‘Rajiv Chilaka’**
```sql

SELECT *
FROM (
  SELECT *, TRIM(UNNEST(STRING_TO_ARRAY(director, ','))) n_director
  FROM netflix
) t
WHERE n_director LIKE '%Rajiv Chilaka%';
```

**📺 12. TV Shows with More Than 5 Seasons**
```sql

SELECT * 
FROM netflix
WHERE show_type = 'Tv Show' AND duration_value > 5;
```

**🎬 13. Count of Content per Genre**
```sql

SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) genre, COUNT(*)
FROM netflix
GROUP BY genre;
```
**🇮🇳 14. Top 5 Years with Highest Average Content (India)**
```sql

SELECT 
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
  ROUND(COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM netflix WHERE country LIKE '%India%') * 100, 2) AS avg_content
FROM netflix
WHERE country LIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**📚 15. All Documentary Movies**
```sql

SELECT *
FROM (
  SELECT *, TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) genre
  FROM netflix
)
WHERE show_type = 'Movie' AND genre LIKE '%Docu%';
```

**🚫 16. Content Without Director**
```sql

SELECT * FROM netflix WHERE director = 'Not Provided';
```

**🧑‍🎤 17. Movies Featuring Salman Khan in Last 10 Years**
```sql

SELECT show_type, COUNT(*)
FROM netflix
WHERE show_cast LIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10
GROUP BY 1;
```

**🎭 18. Top 10 Indian Actors by Movie Appearances**
```sql

SELECT TRIM(UNNEST(STRING_TO_ARRAY(show_cast, ','))) actor, COUNT(*)
FROM netflix
WHERE country LIKE '%India%' AND show_type = 'Movie'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

**🔪 19. Categorizing Content by Keywords (‘Kill’, ‘Violence’)**
```sql

SELECT category, COUNT(*)
FROM (
  SELECT CASE 
           WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
           ELSE 'Good'
         END AS category
  FROM netflix
) c
GROUP BY category;
```

📈 #Step 5: Key Insights
=
1 Movies vs TV Shows	Netflix has significantly more movies than shows.
2	Top Countries	The U.S., India, and U.K. dominate content production.
3	Trend	Content grew rapidly after 2015.
4	Directors	Rajiv Chilaka among top frequent directors.
5	Genres	Drama, Comedy, and Documentary dominate genres.
6	Ratings	“TV-MA” and “TV-14” are the most common.
9	Longest Movie	Identified longest movie by duration.
14	Indian Content	Peak years show high percentage growth.
18	Top Indian Actors	Frequent collaborations in Indian movies.
19	Keyword Analysis	About 10–15% of titles include violent themes.

##🧠 Learnings
=
- Strong understanding of data cleaning with SQL
- Text processing using UNNEST() and STRING_TO_ARRAY()
- Date handling using TO_DATE() and INTERVAL
- Ranking and window analysis with RANK() OVER()
- Real-world data storytelling using SQL


##📂 Project Structure
=
📁 Netflix_SQL_Analysis/
│
├── 📄 netflix_analysis.sql        # Full SQL code
├── 📊 netflix_dataset.csv         # Raw dataset (if included)
├── 🧾 README.md                   # Documentation (this file)

#👨‍💻 Author
**Ishu Verma**
📍 Data Analyst | SQL | Excel |
