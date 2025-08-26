-- Data Cleaning --

-- Switch to the working database
use world_layoffs;

-- Preview the raw data in the original table
select * from layoffs;

-- Create a staging table to work on data cleaning.
-- This ensures the raw data is preserved for backup and reference.
Create table layoffs_staging
like layoffs;

-- Verify the structure of the staging table
select * from layoffs_staging;

-- Populate the staging table with all rows from the raw table
insert layoffs_staging 
 select * from layoffs;

-- =========================================================
-- DATA CLEANING STEPS OVERVIEW:
-- 1. Check for duplicates and remove any
-- 2. Standardize data and fix errors
-- 3. Handle null values appropriately
-- 4. Remove unnecessary columns and rows
-- =========================================================

-- 1. CHECK FOR DUPLICATES

-- Use ROW_NUMBER() to assign a unique sequence to duplicate rows
select * , row_number() over(
partition by company,industry,total_laid_off,percentage_laid_off,`date`) as row_num
from layoffs_staging;

-- More precise duplicate check by considering all key columns
with duplicate_cte as
(
select * , row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
select * from duplicate_cte 
where row_num > 1; -- Only shows duplicates

-- Create a second staging table with an extra column (row_num) 
-- to track duplicate records 
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

-- Insert all rows from layoffs_staging into layoffs_staging2,
-- while generating row numbers to identify duplicates
insert layoffs_staging2
select * , row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging ;

-- Check which rows have duplicates (row_num > 1)
select * from layoffs_staging2 where row_num>1;

-- Temporarily disable safe update mode to allow deleting rows without keys
SET SQL_SAFE_UPDATES = 0;

-- Delete duplicate rows (row_num > 1) to retain only unique records
delete from layoffs_staging2 where row_num>1;

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

-- Verify the cleaned dataset in layoffs_staging2
select * from layoffs_staging2;

-- =========================================================
-- 2. STANDARDIZING DATA
-- =========================================================

-- Preview the company column to spot leading/trailing spaces
select company
from layoffs_staging2;

-- Remove leading/trailing whitespace from company names
SET SQL_SAFE_UPDATES = 0;
update layoffs_staging2
set company=trim(company);
SET SQL_SAFE_UPDATES = 1;

-- Check for inconsistent industry names (example: 'crypto', 'CryptoCurrency', etc.)
select * 
from layoffs_staging2 where industry like 'crypto%';

-- Standardize all "crypto%" variations into a single value: 'Crypto'
SET SQL_SAFE_UPDATES = 0;
update layoffs_staging2
set industry='Crypto' where industry like 'crypto%';
SET SQL_SAFE_UPDATES = 1;

-- Preview countries in alphabetical order to spot inconsistencies
select * 
from layoffs_staging2 order by country;

-- Standardize country names (example: fix 'United States.' → 'United States')
SET SQL_SAFE_UPDATES = 0;
update layoffs_staging2
set country='United States' where country = 'United States.';
SET SQL_SAFE_UPDATES = 1;

-- Preview the date column by converting text → date format
select `date`,str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2;

-- Update the date column to proper DATE format values
SET SQL_SAFE_UPDATES = 0;
update layoffs_staging2
set `date`= str_to_date(`date`,'%m/%d/%Y');
SET SQL_SAFE_UPDATES = 1;

-- Verify updated date values
select * from layoffs_staging2;

-- Change column datatype from TEXT → DATE for proper storage & calculations
Alter table layoffs_staging2
modify column `date` DATE;

-- =========================================================
-- Handling NULL or Empty Values in Industry
-- =========================================================

-- Check rows with NULL or empty string values in industry
select * from layoffs_staging2 
where industry is null or industry='';

-- Check specific companies with missing industry values
select * from layoffs_staging2 
where company in ('Airbnb','Bally%','Carvana','Juul');

-- Convert empty strings in industry → NULL for consistency
set SQL_SAFE_UPDATES=0;
update layoffs_staging2
set industry = NULL 
where industry = '';

-- Manually fill NULL industry values based on company knowledge
update layoffs_staging2
set industry = 'Travel'
where industry is null and company = 'Airbnb';

update layoffs_staging2
set industry = 'Transportation'
where industry is null and company = 'Carvana';

update layoffs_staging2
set industry = 'Consumer'
where industry is null and company = 'Juul';

set SQL_SAFE_UPDATES=1;

-- =========================================================
-- 3. LOOK AT NULL VALUES (Other Columns)
-- =========================================================
-- The columns total_laid_off, percentage_laid_off, and funds_raised_millions
-- contain NULL values, but these are left untouched intentionally.
-- Keeping NULLs is helpful for EDA (exploratory data analysis),
-- as it distinguishes missing information from 0.

-- =========================================================
-- 4. REMOVE UNNECESSARY COLUMNS AND ROWS
-- =========================================================

-- Check rows where both total_laid_off and percentage_laid_off are NULL.
-- These rows do not provide useful information, so they can be safely removed.
select * from layoffs_staging2
where total_laid_off is NULL 
and 
percentage_laid_off is NULL;

-- Delete rows with no layoff information (both columns NULL)
set SQL_SAFE_UPDATES=0;
delete from layoffs_staging2
where total_laid_off is NULL 
and 
percentage_laid_off is NULL;
set SQL_SAFE_UPDATES=1;

-- Verify dataset after deletion
select * from layoffs_staging2;

-- Remove the row_num column (only used for duplicate detection earlier).
-- This column is no longer required in the cleaned table.
set SQL_SAFE_UPDATES=0;
Alter table layoffs_staging2
drop column row_num;
set SQL_SAFE_UPDATES=1;

-- =========================================================
-- FINAL CLEANED TABLE
-- =========================================================
-- At this stage, the data is deduplicated, standardized, 
-- nulls handled, and unnecessary columns/rows removed.
select * from layoffs_staging2;





