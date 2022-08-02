Select *
From PortfolioProject..DataAnalystSalaries

---------------------------------------------------------------------------------------

--Finding out salary differences since 2020 in US

Select work_year, job_title, salary_in_usd, company_location
From PortfolioProject..DataAnalystSalaries
Where (job_title = 'Data Analyst') and company_location = 'US'

--------------------------------------------------------------------------------------------

--Finding the average salary of 2022 (each xp lvl)

Select  work_year, job_title, AVG(salary_in_usd) as "AVG_US_Salary", experience_level, company_location
From PortfolioProject..DataAnalystSalaries
Where (job_title = 'Data Analyst') and (company_location = 'US') and work_year = '2022'
Group by job_title, company_location, work_year, experience_level

------------------------------------------------------------------------------------------------------

--Finding the top earning contries for data analyst in 2022

Select  work_year, job_title, MAX(salary_in_usd) as "MAX_Salary", company_location
From PortfolioProject..DataAnalystSalaries
Where (job_title = 'Data Analyst') and (work_year = '2022')
Group by job_title, company_location, work_year


