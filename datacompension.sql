---create working table---
SELECT *  INTO test_compen
	FROM responses
 


-------------------------DATA CLEANING--------------------------
---Check Duplicates---
WITH check_duplicates as (

SELECT 
	current_role, level, years_of_experience, industry,
	ROW_NUMBER() OVER (PARTITION BY timestamp, current_role, level, years_of_experience, industry,
				gender, tech_stack, gross_salary_pm, benefits, work_setup, employer_type,
				other_role, other_tech_stack
	ORDER BY current_role) as row_num
FROM responses

)

SELECT
	*
FROM
	check_duplicates
WHERE row_num > 1

----------------------------------------------------------
UPDATE responses
SET Level = 'Mid-Level'
WHERE Level = 'Mid-Level  eg Data Analyst'

UPDATE responses
SET Level = 'Junior'
WHERE Level = 'Junior  eg Junior Data Analyst'

UPDATE responses
SET Level = 'Senior'
WHERE Level = 'Senior Level  eg Senior Data Analyst'

UPDATE responses
SET Level = 'Manager'
WHERE Level = 'Manager eg Manager of Analytics'




-------Check and update values for consistency--------
UPDATE responses
SET industry = 'Banking'
WHERE industry ='Bank'


UPDATE responses
SET industry = 'Fintech'
WHERE industry = 'Finetech' OR industry = 'Fintech and IT'

UPDATE responses
SET industry = 'Finance'
WHERE industry = 'Financial ' OR industry = 'Finance - Pensions'

UPDATE responses
SET industry = 'Health'
WHERE industry = 'Healtg' 

UPDATE responses
SET industry = 'Government '
WHERE industry = 'Government- taxation '

UPDATE responses
SET industry = 'Insurance'
WHERE industry = 'Insurance broker ' 

UPDATE responses
SET industry = 'Manufacturing '
WHERE industry = 'Manufacturing (FMCG)'

UPDATE responses
SET industry = 'Marketing  '
WHERE industry = 'Market research '

UPDATE responses
SET industry = 'Non-profit   '
WHERE industry = 'Non Profit' OR industry = 'Non Profit Organization'

UPDATE responses
SET industry = 'Retail '
WHERE industry = 'Wholesale and Retail ' OR industry = 'Production and Retail '


UPDATE responses
SET industry = 'Consulting '
WHERE industry = 'Consultancy '

UPDATE responses
SET industry = 'Telecommunications'
WHERE industry = 'Telco' OR industry = 'Technology and Telecommunications '


UPDATE responses
SET industry = 'Conservation'
WHERE industry = 'Environment Conservancy '


UPDATE responses
SET industry = 'Energy '
WHERE industry = 'Power' OR industry = 'Solar ' OR industry = 'Sustainable energy  ' 

UPDATE responses
SET industry = 'Non-profit   '
WHERE industry = 'AID' OR industry = 'NGO ' 


UPDATE responses
SET industry = 'Education'
WHERE industry = 'School' OR industry = 'Edtech' 


UPDATE responses
SET industry = 'Tech'
	WHERE industry = 'Artificial Intelligence' OR industry = 'Analytics->I work for a company in Europe not Kenya' 
	OR industry = 'machine learning ' OR industry = 'People and Technology ' OR industry = 'SAAS(Foodtech)'


UPDATE responses
SET industry = 'Consumer'
WHERE industry = 'Consumer tech and media' OR industry = 'Fast Moving Consumer Goods' 

UPDATE responses
SET industry = 'Research'
WHERE industry = 'Research/Education' 

UPDATE responses
SET industry = 'Finance'
WHERE industry = 'Pension Administration ' OR industry = 'Professional Services (Accounting)'
OR industry = 'Taxation'


UPDATE responses
SET industry = 'Other'
WHERE industry in ('Still searching', 'Personal',  'None', 'Nill', 'Nil', 'N/A')


UPDATE responses
SET industry = 'Transport'
WHERE industry = 'Automotive Industry' OR industry = 'eMOBILITY'



select distinct(industry) from responses
---------------------------------------------------------------------------------------
UPDATE responses
SET work_setup = 'Hybrid'
WHERE work_setup LIKE 'hybrid%'




--------------nulls--------------------
select distinct(industry ), current_role, level, gross_salary_pm
from responses
where gross_salary_pm IS NULL




------------Find industry average salary to use to populate salary depending on levels
SELECT DISTINCT(res1.industry), ROUND(AVG(res2.gross_salary_pm), 0) as average_salary , res1.level, res1.current_role
FROM responses res1
	JOIN responses res2
	ON res1. industry = res2.industry AND res1.level = res2.level AND res1.current_role = res2.current_role
	WHERE res1.level = res2.level AND res1.current_role = res2.current_role AND res1.industry = res2.industry 
		AND res1.gross_salary_pm IS NULL AND res2.gross_salary_pm IS NOT NULL
	GROUP BY res1.industry, res1.level, res1.current_role





----------------------------------------------------------------------------------------------------------------

select distinct(tech_stack) from responses

----AVERAGE SALARY BY ROLE
SELECT current_role, ROUND(AVG(gross_salary_pm),0) as average_salary
	FROM responses
GROUP BY current_role
ORDER BY average_salary 


-----AVERAGE SALARY BY LEVEL
SELECT level, ROUND(AVG(gross_salary_pm),0) as average_salary
	FROM responses
GROUP BY level
ORDER BY average_salary 

-----AVERAGE SALARY BY indusry
SELECT industry, ROUND(AVG(gross_salary_pm),0) as average_salary
	FROM responses
GROUP BY industry
ORDER BY average_salary DESC


-----Men vs Women Average Salary------------
SELECT gender, ROUND(AVG(gross_salary_pm),0) as average_salary
	FROM responses
GROUP BY gender
ORDER BY average_salary DESC


-----AVERAGE SALARY BY employer type
SELECT employer_type, ROUND(AVG(gross_salary_pm),0) as average_salary
	FROM responses
GROUP BY employer_type
ORDER BY average_salary DESC


-----AVERAGE SALARY BY work_setup
SELECT work_setup, ROUND(AVG(gross_salary_pm),0) as average_salary
	FROM responses
GROUP BY work_setup
ORDER BY average_salary DESC




select distinct(other_tech_stack) from responses
delete FROM responses
where other_tech_stack is null


