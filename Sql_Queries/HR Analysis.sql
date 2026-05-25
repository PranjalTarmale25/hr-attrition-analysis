-- DROP TABLE IF EXISTS hr_data;
DROP TABLE IF EXISTS hr_data;
-- Create a new cleaned and transformed HR dataset table.
CREATE TABLE hr_data AS
SELECT
	Employee_ID,
    Employee_Name,
    Age,
     -- Categorize employees into age groups
    CASE 
        WHEN Age BETWEEN 20 AND 30 THEN '20-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE 'Other'
    END AS Age_Group,
    Years_of_Service,
     -- Categorize employees based on experience
    CASE 
        WHEN Years_of_Service BETWEEN 0 AND 2 THEN '0-2 Years'
        WHEN Years_of_Service >= 3 AND Years_of_Service <= 5 THEN '3-5 Years'
        WHEN Years_of_Service > 5 AND Years_of_Service <= 10 THEN '5-10 Years'
        WHEN Years_of_Service > 10 AND Years_of_Service <= 15 THEN '10-15 Years'
        ELSE '15+ Years'
    END AS Experience_Category,
      -- Standardize position names
    CASE 
        WHEN Position IN ('DataAnalyst', 'Analyst') THEN 'Data Analyst'
        WHEN Position IN ('AccountExecutive', 'AccountExec.', 'Account Exec.') THEN 'Account Executive'
        ELSE Position 
    END AS Position,
     -- Convert Gender values into short format
    CASE 
        WHEN Gender = 'Female' THEN 'F'
        WHEN Gender = 'Male' THEN 'M'
        ELSE Gender 
    END AS Gender,
    Department,	
    Salary,	
     -- Categorize salary into income groups
    CASE 
        WHEN Salary BETWEEN 0 AND 100000 THEN '0-1 Lac'
        WHEN Salary BETWEEN 100001 AND 1000000 THEN '1-10 Lacs'
        WHEN Salary BETWEEN 1000001 AND 2000000 THEN '10-20 Lacs'
        WHEN Salary BETWEEN 2000001 AND 3000000 THEN '20-30 Lacs'
        WHEN Salary BETWEEN 3000001 AND 4000000 THEN '30-40 Lacs'
        WHEN Salary BETWEEN 4000001 AND 5000000 THEN '40-50 Lacs'
        WHEN Salary BETWEEN 5000001 AND 6000000 THEN '50-60 Lacs'
        WHEN Salary BETWEEN 6000001 AND 7000000 THEN '60-70 Lacs'
        WHEN Salary BETWEEN 7000001 AND 8000000 THEN '70-80 Lacs'
        WHEN Salary BETWEEN 8000001 AND 9000000 THEN '80-90 Lacs'
        WHEN Salary >= 9000001 THEN '90 Lacs-1 Cr'
        ELSE 'Above 1 Cr'
    END AS Income_Group,
    Performance_Rating,
    Work_Hours,
	Attrition,
	Promotion,
	Training_Hours,
     -- Categorize training hours
    CASE 
        WHEN Training_Hours BETWEEN 0 AND 10 THEN '0-10 Hours'
        WHEN Training_Hours BETWEEN 11 AND 20 THEN '11-20 Hours'
        WHEN Training_Hours BETWEEN 21 AND 30 THEN '21-30 Hours'
        WHEN Training_Hours BETWEEN 31 AND 40 THEN '31-40 Hours'
        ELSE '40+ Hours'
    END AS Training_Hours_Category,
	Satisfaction_Score,
	Education_Level,
	Employee_Engagement_Score,
	Absenteeism,
     -- Categorize absenteeism days
    CASE 
        WHEN Absenteeism BETWEEN 0 AND 5 THEN '0-5 Days'
        WHEN Absenteeism BETWEEN 6 AND 10 THEN '6-10 Days'
        WHEN Absenteeism BETWEEN 11 AND 15 THEN '11-15 Days'
        ELSE '15+ Days'
    END AS Absenteeism_Category,
	Distance_from_Work,
    -- Categorize employee travel distance
    CASE 
        WHEN Distance_from_Work BETWEEN 0 AND 10 THEN '0-10 kms'
        WHEN Distance_from_Work BETWEEN 11 AND 20 THEN '11-20 kms'
        WHEN Distance_from_Work BETWEEN 21 AND 30 THEN '21-30 kms'
        WHEN Distance_from_Work BETWEEN 31 AND 40 THEN '31-40 kms'
        ELSE '40+ kms'
    END AS Distance_from_Work_Category,
     -- Calculate overall employee satisfaction score
	JobSatisfaction_PeerRelationship,
	JobSatisfaction_WorkLifeBalance,
	JobSatisfaction_Compensation,
	JobSatisfaction_Management,
	JobSatisfaction_JobSecurity,
    (JobSatisfaction_PeerRelationship + 
	JobSatisfaction_WorkLifeBalance +
	JobSatisfaction_Compensation +
	JobSatisfaction_Management + 
	JobSatisfaction_JobSecurity) /5*100 AS Employee_Satisfaction_Score,
	EmployeeBenefit_HealthInsurance,
	EmployeeBenefit_PaidLeave,
	EmployeeBenefit_RetirementPlan,
	EmployeeBenefit_GymMembership,
	EmployeeBenefit_ChildCare,
    (EmployeeBenefit_HealthInsurance +
	EmployeeBenefit_PaidLeave +
	EmployeeBenefit_RetirementPlan +
	EmployeeBenefit_GymMembership +
	EmployeeBenefit_ChildCare)/5*100 AS EmployeeBenefitScore
FROM hr_analytics_dataset_adviti
WHERE Position != 'Intern'
;

SELECT *
FROM hr_data
WHERE Position IN ('CEO', 'COO')
;


-- Display complete cleaned HR dataset
SELECT *
FROM hr_data;
-- --WHERE Position IN ('CEO', 'COO');

-- Count total employees for each position
SELECT Position, Count(*)
FROM hr_analytics_dataset_adviti
GROUP BY Position;
-

-- Find difference between employee age and years of service- 
 SELECT Employee_Name, Position, 
Salary, Age, Years_of_Service, Age - Years_of_Service AS Diff
 FROM hr_analytics_dataset_adviti;

-- Hypothesis: Whether an Intern was hired or not
SELECT Employee_Name, Age, COUNT(*) AS Total
FROM hr_data
GROUP BY Employee_Name, Age
HAVING COUNT(*) > 1;
-- Conclusion: We can remove the interns data.
-- SUMMARY
SELECT Attrition, COUNT(Employee_ID) AS Total_Attrition
FROM hr_data
GROUP BY Attrition;
 

 -- --Department-wise, position-wise, and gender-wise attrition analysis
SELECT
    Department,
    Position,
    Gender,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS 'No',
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'Yes',
    COUNT(Employee_ID) AS 'Grand Total'
FROM
    hr_data
GROUP BY
    Department,
    Position,
    Gender
ORDER BY
    Department,
    Position,
    Gender;
-- ---- Attrition analysis by Income Group and Gender

SELECT 
	COUNT(Employee_ID) AS Total_Employees, 
    COUNT(CASE WHEN Attrition = 'Yes' THEN 1 ELSE NULL END) AS Attrition_count,
    ROUND(COUNT(CASE WHEN Attrition = 'Yes' THEN 1 ELSE NULL END)/COUNT(Employee_ID)*100,2) AS Attrition_rate,
    COUNT(CASE WHEN Attrition = 'No' THEN 1 ELSE NULL END) AS Total_Active_Employees,
    FORMAT(AVG(Salary),2) AS AvgSalary,
    ROUND(AVG(Employee_Satisfaction_Score))  AS AvgEmployeeSatisfactionScore
FROM hr_data;

SELECT 
	Attrition, 
    FORMAT(AVG(Salary),2) AS AvgSalary,
    ROUND(AVG(Performance_Rating)) AS AvgPerformanceRating,
    ROUND(AVG(Work_Hours)) AS AvgWorkHours,
    ROUND(AVG(Training_Hours)) AS AvgTrainingHours,
    ROUND(AVG(Employee_Satisfaction_Score))  AS AvgEmployerSatisfactionScore,
    ROUND(AVG(Employee_Engagement_Score))  AS AvgEmployeeEngagementScore,
    ROUND(AVG(Absenteeism))  AS AvgAbsenteeism,
    ROUND(AVG(Distance_from_Work))  AS AvgDistanceFromWork,
    ROUND(AVG(Employee_Satisfaction_Score))  AS AvgEmployeeSatisfactionScore,
    ROUND(AVG(EmployeeBenefitScore))  AS AvgEmployeeBenefitScore    
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY Attrition

UNION ALL

SELECT 
	Attrition, 
    FORMAT(AVG(Salary),2) AS AvgSalary,
    ROUND(AVG(Performance_Rating)) AS AvgPerformanceRating,
    ROUND(AVG(Work_Hours)) AS AvgWorkHours,
    ROUND(AVG(Training_Hours)) AS AvgTrainingHours,
    ROUND(AVG(Employee_Satisfaction_Score))  AS AvgEmployerSatisfactionScore,
    ROUND(AVG(Employee_Engagement_Score))  AS AvgEmployeeEngagementScore,
    ROUND(AVG(Absenteeism))  AS AvgAbsenteeism,
    ROUND(AVG(Distance_from_Work))  AS AvgDistanceFromWork,
    ROUND(AVG(Employee_Satisfaction_Score))  AS AvgEmployeeSatisfactionScore,
    ROUND(AVG(EmployeeBenefitScore))  AS AvgEmployeeBenefitScore    
FROM hr_data
WHERE Attrition = 'No'
GROUP BY Attrition;


-- PROMOTION
 
-- department
SELECT 
	Position,
    COUNT(Employee_ID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*))*100) AS "Attrition Yes %",
    ROUND((SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(*))*100) AS "Attrition No %"
FROM hr_data
GROUP BY Position
;
-- Gender
SELECT 
	Gender,
    COUNT(Employee_ID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*))*100) AS "Attrition Yes %",
    ROUND((SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(*))*100) AS "Attrition No %"
FROM hr_data
GROUP BY Gender
;

SELECT 
    COUNT(*) AS TotalEmployees,
    FORMAT(AVG(Salary),2) AS AvgSalary,
    ROUND(AVG(Performance_Rating)) AS AvgPerformanceRating,
    ROUND(AVG(Work_Hours)) AS AvgWorkHours,
    ROUND(AVG(Training_Hours)) AS AvgTrainingHours,
    ROUND(AVG(Employee_Satisfaction_Score))  AS AvgEmployerSatisfactionScore,
    ROUND(AVG(Employee_Engagement_Score))  AS AvgEmployeeEngagementScore,
    ROUND(AVG(Absenteeism))  AS AvgAbsenteeism,
    ROUND(AVG(Distance_from_Work))  AS AvgDistanceFromWork,
    ROUND(AVG(Employee_Satisfaction_Score))  AS AvgEmployeeSatisfactionScore,
    ROUND(AVG(EmployeeBenefitScore))  AS AvgEmployeeBenefitScore    
FROM hr_data
;
-- Department-wise, position-wise, and gender-wise attrition analysis
SELECT
    Department,
    Position,
    Gender,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS 'No',
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'Yes',
    COUNT(Employee_ID) AS 'Grand Total'
FROM
    hr_data
GROUP BY
    Department,
    Position,
    Gender
ORDER BY
    Department,
    Position,
    Gender;
-- Attrition analysis by Income Group and Gender
SELECT
  Income_Group,
  SUM(CASE WHEN Gender = 'F' AND Attrition = 'No' THEN 1 ELSE 0 END) AS 'F_No',
  SUM(CASE WHEN Gender = 'F' AND Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'F_Yes',
  SUM(CASE WHEN Gender = 'M' AND Attrition = 'No' THEN 1 ELSE 0 END) AS 'M_No',
  SUM(CASE WHEN Gender = 'M' AND Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'M_Yes',
  COUNT(Employee_ID) AS 'Grand Total'
FROM
  hr_data
GROUP BY
  Income_Group
;
-- Age group Attrition
SELECT 
	Age_Group,
    COUNT(Employee_ID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*))*100) AS "Attrition Yes %",
    ROUND((SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(*))*100) AS "Attrition No %"
FROM hr_data
GROUP BY Age_Group
;
-- ---
-- --Analyze whether education level affects employee experience and attrition.
SELECT
    Education_Level,
    Years_of_Service,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Retained_Employees,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END )* 100) / COUNT(*),2)  AS "Attrition_CountYes %",
    ROUND((SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)*100)  / COUNT(*),2)  AS "Retained_Employees%"
FROM hr_data 
GROUP BY Education_Level, Years_of_Service
ORDER BY Education_Level, Years_of_Service;

-- Avg salary by department,Use Department Average as Market Salary
select department,
Round(avg(salary),2) as Market_Salary
from hr_data
group by Department;

-- compare employee salary with department average.
WITH cte as (
select department,
[position], salary,
ROUND(avg(Cast(salary As Decimal(10,2))) over(partition by department, [position]),2) As Market_Salary
from hr_data
)
select *,
salary - Market_Salary as salary_difference
from cte;
-- --“Check attrition distribution across all the categorical variables.”
SELECT 
    gender,
    department,
    position,
    education_level,
    Promotion,
    income_group,
     COUNT(*) AS total_employees,
   sum(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
   sum(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100) / COUNT(*), 2) AS "Attrition Yes %",
    ROUND((SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) * 100) / COUNT(*), 2) AS "Attrition No %"
   FROM hr_data
GROUP BY 
    gender,
    department,
    position,
    education_level,
    Promotion,
    income_group;
    
    -- Department Analysis with Gender
    SELECT 
    Gender,
    Department,
    COUNT(*) AS Total,
     SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attrition_yes,
    ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS Attrition_Rate
FROM hr_data
GROUP BY Gender, Department;


SELECT 
    Income_Group ,
    Promotion,
    COUNT(*) AS Total,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS Attrition_Rate
FROM hr_data
GROUP BY Income_Group, Promotion; 

-- Interaction Analysis Between Variables
SELECT 
    Income_Group,
	JobSatisfaction_WorkLifeBalance ,
    COUNT(*) AS Total_Employees,
    ROUND((sum(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100)/ count(*),2) AS Attrition_yes
FROM hr_data
GROUP BY Income_Group,
 JobSatisfaction_WorkLifeBalance;
 
-- Income_Group VS Performance_rating
select 
Income_Group,
Performance_Rating,
ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100)/ count(*),2)AS 'Attrition_yes%',
ROUND((SUM(CASE WHEN Attrition = 'NO' THEN 1 ELSE 0 END) * 100)/ count(*),2)AS 'Attrition_No%'
from hr_data
GROUP BY Income_Group,Performance_Rating;

-- Do age groups behave differently in departments?
select Age,
Department,
Round((sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2)AS 'Attrition_yes%',
Round((sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2)AS 'Attrition_No'
From hr_data
group by Age, Department;

-- Does overtime + salary level increase attrition?
select 
Work_Hours,
-- Department,
Income_Group,
Round((sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2)AS 'Attrition_yes%',
Round((sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2)AS 'Attrition_No'
From hr_data
group by Work_Hours, Income_Group;

-- Does job satisfaction + overtime affect attrition?
select 
SatisfactionScore,
Work_Hours,
Round((sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2)AS 'Attrition_yes%',
Round((sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2)AS 'Attrition_No'
From hr_data
group by SatisfactionScore,Work_Hours;

-- Check whether employees staying too long without promotion leave more.
select
Experience_Category,
    Promotion,
    Position,
count(*) AS Total_Employee,
Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%'
From hr_data
group by Experience_Category,
    Promotion,
     Position;
     
     -- Check whether salary growth aligns with experience.
     select
     Experience_Category,
     Income_Group,
     Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%'
From hr_data
group by  Experience_Category,
     Income_Group;
     
     -- Understand whether employees taking more training are more likely to leave.
    select
    Training_Hours_Category,
    Performance_Rating,
    Promotion,
    Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%'
From hr_data
group by Training_Hours_Category,
    Performance_Rating,
    Promotion;
    
    -- Employee Retriement plan vs Age Group
    select
    EmployeeBenefit_RetirementPlan,
    Age_Group,
     Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%'
From hr_data
group by EmployeeBenefit_RetirementPlan,
    Age_Group;
    
    -- Employee Benefits vs Distance from Office
    select
    EmployeeBenefitScore,
    Distance_from_Work,
	sum(Case When Attrition = 'Yes' Then 1 Else 0 End) As 'AttritionYes',
	sum(Case When Attrition = 'No' Then 1 Else 0 End) As 'AttritionNO',
    Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%',
    Round((Sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionNo%'
    from hr_data
    group by
    EmployeeBenefitScore,
    Distance_from_Work;
    
    -- Working Hours vs Promotion vs Salary
     select
   Work_Hours,
    Promotion,
    Income_Group,
	-- sum(Case When Attrition = 'Yes' Then 1 Else 0 End) As 'AttritionYes',
	-- sum(Case When Attrition = 'No' Then 1 Else 0 End) As 'AttritionNO',
    Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%',
    Round((Sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionNo%'
    from hr_data
    group by
    Work_Hours,Promotion,
     Income_Group;
     
-- peer realtionship vs engagement hold on
select
JobSatisfaction_PeerRelationship,
Employee_Engagement_Score,
count(*) AS Total_Employee,
 Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%',
Round((Sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionNo%'
from hr_data
group by 
JobSatisfaction_PeerRelationship,
Employee_Engagement_Score;

-- Job Satisfaction / Job Security vs Attrition
select
JobSatisfaction_Management,
 JobSatisfaction_JobSecurity,
Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%',
Round((Sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionNo%'
from hr_data
group by 
JobSatisfaction_Management,
JobSatisfaction_JobSecurity;

-- Training Hours vs Performance Rating
select
Training_Hours_Category,
Performance_Rating,
 -- avg(Performance_Rating) as avgPerformance_Rating,
Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%',
Round((Sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionNo%'
from hr_data 
group by
 Training_Hours_Category,
 Performance_Rating
;
 

-- Check whether experienced employees perform better.-- hold this anlysis
select
Experience_Category,
Performance_Rating,
-- count(Attrition),
Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%',
Round((Sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionNo%'
from hr_data 
group by 
Experience_Category,
Performance_Rating;
 

 -- Training hour vs promotion
 select
 Training_Hours_Category,
 Promotion,
 Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%',
Round((Sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionNo%'
from hr_data 
group by
Training_Hours_Category,
 Promotion;
 
 -- Training Hours vs Employee Engagement
 select
 Training_Hours_Category,
 Employee_Engagement_Score,
 Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%',
Round((Sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionNo%'
from hr_data 
group by
Training_Hours_Category,
 Employee_Engagement_Score;
 
 
 -- Training Analysis  vs working hiurs
  select
 Training_Hours_Category,
 Work_Hours,
 Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%',
Round((Sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionNo%'
from hr_data 
group by
Training_Hours_Category,
 Work_Hours;
 
 -- Department-wise Training Analysis
  select
 Training_Hours_Category,
 Department,
 Round((Sum(Case When Attrition = 'Yes' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionYes%',
Round((Sum(Case When Attrition = 'No' Then 1 Else 0 End)* 100) / Count(*),2) As 'AttritionNo%'
from hr_data 
group by
Training_Hours_Category,
 Department;
 
 
 
 
 
 
 