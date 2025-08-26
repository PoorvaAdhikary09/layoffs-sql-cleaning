-- Exploratory Data Analysis (EDA) ---------------------------------------

-- Preview the dataset after cleaning
select * from layoffs_staging2;

-- Find the maximum layoffs and maximum layoff percentage
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

-- Companies with 100% workforce laid off (sorted by size of layoffs)
select * from layoffs_staging2
where percentage_laid_off=1 
order by total_laid_off desc;

-- Companies with 100% layoffs (sorted by funds raised)
select * from layoffs_staging2
where percentage_laid_off=1 
order by funds_raised_millions desc;

-- Total layoffs by company (top companies at the top)
select company,sum(total_laid_off)
from layoffs_staging2
group by company order by 2 desc;

-- Time span of the dataset (earliest and latest dates)
select min(`date`),max(`date`)
from layoffs_staging2;

-- Total layoffs by industry
select industry,sum(total_laid_off)
from layoffs_staging2
group by industry order by 2 desc;

-- Total layoffs by country
select country,sum(total_laid_off)
from layoffs_staging2
group by country order by 2 desc;

-- Yearly layoffs trend
select year(`date`),sum(total_laid_off)
from layoffs_staging2
group by year(`date`) order by 1 desc;

-- Monthly layoffs trend
select substring(`date`,1,7) as `month`,
sum(total_laid_off) 
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month` order by 1;

-- Rolling total of layoffs month by month
with rolling_total as (
    select substring(`date`,1,7) as `month`,
    sum(total_laid_off) as total_off 
    from layoffs_staging2
    where substring(`date`,1,7) is not null
    group by `month` order by 1
)
select `month`, total_off, 
       sum(total_off) over(order by `month`) as rolling_total 
from rolling_total;

-- Top 5 companies per year with the most layoffs
with yearly_layoff (company,years,total_laid_off) as(
    select company,year(`date`) as `year`,
    sum(total_laid_off)
    from layoffs_staging2
    group by company,year(`date`)
), Company_year_rank as (
    select *, dense_rank() over(partition by years 
                                order by total_laid_off desc) as ranking
    from yearly_layoff
    where years is not null
)
select * from Company_year_rank
where ranking<=5;
