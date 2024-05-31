-- Data Cleaning

Create Database world_layoffs;
Use world_layoffs; 

Select * from Layoffs;

-- 1 Delete any Duplicates 

Create Table layoffs_staging
Like layoffs;

Insert layoffs_staging
Select * From 
layoffs;

Select * From layoffs_staging;

With Duplicate_CTE AS
(
Select *,
Row_Number() Over ( Partition By company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,
funds_raised_millions ) as Row_Num 
From layoffs_staging
)
Select * 
From Duplicate_CTE 
Where Row_Num > 1;

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
  `Row_Num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select * From layoffs_Staging2
Where Row_num >1 ;

Insert Into layoffs_Staging2
Select *,
Row_Number() Over ( Partition By company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,
funds_raised_millions ) as Row_Num 
From layoffs_staging;

Delete 
From layoffs_Staging2
Where Row_num >1 ;


Select * From layoffs_Staging2
Where Row_num >1 ;

Select * from layoffs_staging2; # A new Table with unique values

-- 2 Standardizing Data
Select
	Company, Trim(Company)
From layoffs_staging2;   

Update layoffs_staging2
Set Company = Trim(Company);

Select 
	Distinct(Industry)
From Layoffs_staging2;


Update Layoffs_staging2 
Set Industry = 'crypto'
Where Industry Like 'crypto%';

Select
	Distinct(Country), Trim(Trailing '.' From Country)
From layoffs_staging2
Order BY 1;

Update Layoffs_staging2 
Set Country = Trim(Trailing '.' from Country)
Where Country Like 'United Sates%';

Select 
	`date`
From layoffs_staging2;    

Update Layoffs_staging2
Set `date` = Str_to_date(`date`, '%m/%d/%Y');

Alter Table layoffs_staging2 
Modify Column `date` Date;

Select * 
From layoffs_staging2
Where Company = 'Airbnb';

Select * 
From layoffs_staging2
Where Industry is NULL or Industry = '';

Select t1.industry, t2.industry
From layoffs_staging2 as t1
Join layoffs_staging2 as t2 
	On t1.company = t2.company
Where (t1.industry is Null Or t1.industry = '')
And t2.industry is not null;


Update layoffs_staging2
Set Industry = null
Where Industry = '';


Update layoffs_staging2 as t1 
Join layoffs_staging2 as t2 
	On t1.company = t2.company
Set t1.industry = t2.industry
Where t1.industry is Null
And t2.industry is not null;


Select * 
From Layoffs_staging2
Where total_laid_off is null 
And percentage_laid_off is null;

Delete
From Layoffs_staging2
Where total_laid_off is null 
And percentage_laid_off is null;

Select * From Layoffs_staging2;

Alter Table layoffs_staging2 
Drop Column Row_Num;