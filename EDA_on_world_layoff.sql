-- 	EXPLORATORY DATA ANALYSIS

SELECT * 
FROM layoffs_staging_2
WHERE percentage_laid_off =1
ORDER BY funds_raised_millions DESC;

SELECT company, sum(total_laid_off)
FROM layoffs_staging_2
GROUP BY company
ORDER BY 2 DESC;

SELECT SUBSTRING(`DATE`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging_2
WHERE SUBSTRING(`DATE`, 1, 7)  IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_total AS
(SELECT SUBSTRING(`DATE`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging_2
WHERE SUBSTRING(`DATE`, 1, 7)  IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC)
SELECT `month`, total_off, sum(total_off) over(order by `month`) as rolling_sum
from Rolling_total;

SELECT company, year(`date`), sum(total_laid_off)
from layoffs_staging_2
group by company, year(`date`)
order by 3 desc;

-- ranking based on layoffs
WITH company_year(company, `year`, total) AS
(SELECT company, year(`date`), sum(total_laid_off)
from layoffs_staging_2
group by company, year(`date`)
order by 3 desc), company_year_rank as 
(SELECT *, dense_rank() over(partition by `year` order by total desc) as dense_rank_num
FROM company_year
WHERE `YEAR` IS NOT NULL)
SELECT * 
from company_year_rank
WHERE dense_rank_num <= 5;

