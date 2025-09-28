-- SQL Project - Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022



SELECT *
FROM layoffs;

-- Data Cleaning usually invloves:
-- 1. Remove Duplicates
-- 2. Standarized the data
-- 3. Null or Blank Values
-- 4. Remove any columns 


-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens
create table layoffs_staging
like layoffs;

select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;



-- 1. Removing Duplicates if any


-- We need to really look at every single row to be accurate
-- these are our real duplicates 

with duplicate_cte as
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_nums
from layoffs_staging
)
select *
from duplicate_cte
where row_nums > 1;

select *
from layoffs_staging;



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_nums` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_nums
from layoffs_staging;

select *
from layoffs_staging2
where row_nums>1;


-- now that we have this we can delete rows were row_num is greater than 1

delete
from layoffs_staging2
where row_nums>1;


-- Standarizing Data

SELECT *
FROM layoffs_staging2;

-- looking at the location and industry it looks like we have some faulty, null and empty rows

SELECT DISTINCT company
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT *
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET location = "Dusseldorf"
WHERE company = "Springlane" AND country = "Germany";


SELECT DISTINCT industry
FROM layoffs_staging2;

-- Noticed the Crypto has multiple different variations. We need to standardize that
UPDATE layoffs_staging2
SET industry = "Crypto"
WHERE industry LIKE "Crypto%";


select DISTINCT country
from layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = "United States"
WHERE country LIKE "United States%";

select `date`
from layoffs_staging2
order by 1;

-- we can use str to date to update this field
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

-- now we can convert the data type properly
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_staging2;


-- Null and Blank Values


SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL or industry = '';

SELECT *
FROM layoffs_staging2;

-- we should set the blanks to nulls since those are typically easier to work with
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Bally's has null and has only single row so i populated it by searhing up on the internet
UPDATE layoffs_staging2
SET industry = 'Casino-Entertainment'
WHERE company LIKE "Bally's Interactive";


-- it looks like airbnb is a travel, but this one just isn't populated.
-- I'm sure it's the same for the others. What we can do is
-- write a query that if there is another row with the same company name, it will update it to the non-null industry values
-- makes it easy so if there were thousands we wouldn't have to manually check them all

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- now we need to populate those nulls if possible
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;



-- Removing Unncessary Columns and Rows

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP row_nums;


SELECT *
FROM layoffs_staging2;







