-- Exploratory Data Analysis

Select * 
From layoffs_staging2; 

-- 1 
Select Max(total_laid_off), Max(percentage_laid_off)
From layoffs_staging2;

Select * 
From layoffs_staging2
Where percentage_laid_off = 1
Order By Funds_raised_millions Desc;

Select company, Sum(total_laid_off)
From layoffs_staging2
Group By Company
Order By 2 Desc;

Select Min(`date`), Max(`date`)
From layoffs_staging2;


Select industry, Sum(total_laid_off)
From layoffs_staging2
Group By industry
Order By 2 Desc;

Select substr(`date`,1,7) AS `MONTH` ,Sum(Total_laid_off)
From layoffs_staging2
Where substr(`date`,1,7) is not NUll
Group By `Month`
Order By 1 Asc;

With Rolling_total as 
(
Select substr(`date`,1,7) AS `Month`, Sum(Total_laid_off) as total_off
From layoffs_staging2
Where substr(`date`,1,7) is not NUll
Group By `Month`
Order By 1 Asc
)
Select `Month`, total_off,
Sum(Total_off) over (order by `Month`) as rolling_total
From Rolling_total;


With Company_Year (company, years, total_laid_off) as 
( 
Select Company, Year(`date`), Sum(Total_laid_off)
From layoffs_staging2
Group By Company, Year(`date`) 
), Company_Year_Rank as  
(Select * ,
Dense_Rank() Over (partition by Years Order By total_laid_off desc) as ranking
From Company_Year
Where Years is not Null
)
Select * 
From Company_Year_Rank
Where Ranking <= 5;