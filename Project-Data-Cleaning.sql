SELECT *
FROM layoffs;


-- Remove Duplicates 
-- Standardise the data 
-- Null values or blank values 
-- Remove any unwanted columns 

CREATE TABLE layoffs_staging 
LIKE layoffs;

SELECT * 
FROM layoffS_staging;

INSERT layoffS_staging
SELECT * 
FROM layoffs; 


SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, industry, total_laid_off, percentage_laid_off, date 
    ORDER BY company) AS row_num 
FROM layoffs_staging;


-- Identifying duplicates using window functions 
WITH duplicate_CTE AS 
(SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions 
    ORDER BY company) AS row_num 
FROM layoffs_staging
)
SELECT *
FROM duplicate_CTE
WHERE row_num > 1;


-- Using delete to delete duplicate columns
WITH duplicate_CTE AS 
(SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions 
    ORDER BY company) AS row_num 
FROM layoffs_staging
)
DELETE
FROM duplicate_CTE
WHERE row_num > 1;

-- 
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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Checking contents of the new table created 
SELECT * 
FROM layoffs_staging2; 

-- Inserting data into the newly created table 

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions 
    ORDER BY company) AS row_num 
FROM layoffs_staging; 

SELECT *
FROM layoffs_staging2 
WHERE row_num = 2;


DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2; 

-- Standardasing data 
-- Now removing the extra columns to fasten query time, and get rid of extra space 
SELECT company, TRIM(company)	 	
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';


UPDATE layoffs_staging2 
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE COUNTRY LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
WHERE COUNTRY LIKE 'United States%'
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States';

SELECT date
FROM 
layoffs_staging2;

SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y') 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y'); 

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''; 

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';


SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
    AND t1.location = t2.location
    WHERE (t1.industry IS NULL OR t1.industry = '')
    AND t2.industry IS NOT NULL;
    
    UPDATE layoffs_staging2 t1
    JOIN layoffs_staging2 t2
    ON t1.company = t2.company 
    SET t1.industry = t2.industry
	WHERE (t1.industry IS NULL)
    AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_Staging2;

ALTER TABLE layoffs_Staging2
DROP COLUMN row_num;

















