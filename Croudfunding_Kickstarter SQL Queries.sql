use croudfunding_kickstarter;
SHOW DATABASES;
SHOW TABLES FROM croudfunding_kickstarter;
DESCRIBE croudfunding_kickstarter.projects;

# Croudfunding Kickstarter KPI's
-- 1.Total Number of Projects Based on Outcome 
SELECT 
    State, COUNT(*) AS Total_Projects
FROM
    croudfunding_kickstarter.projects
GROUP BY State
ORDER BY total_projects DESC;

-- 2.Total Number of Projects Based on Locations
SELECT 
    Country, COUNT(*) AS Total_Projects
FROM
    croudfunding_kickstarter.projects
GROUP BY Country
ORDER BY Total_projects DESC;

-- 3.Total Number of Projects Based on Category
SELECT c.Name, COUNT(p.ProjectID) AS Total_Projects
FROM croudfunding_kickstarter.projects p
JOIN croudfunding_kickstarter.category c ON p.category_id = c.id
GROUP BY c.name
ORDER BY Total_Projects DESC;

-- 4. Total Number of Projects By Year,Quarter And Month
SELECT  
    YEAR(FROM_UNIXTIME(created_at)) AS Year,
    QUARTER(FROM_UNIXTIME(created_at)) AS Quarter,
    MONTHNAME(FROM_UNIXTIME(created_at)) AS Month,
    MONTH(FROM_UNIXTIME(created_at)) AS Month_num,
    COUNT(*) AS Total_Projects
FROM  
    croudfunding_kickstarter.projects
GROUP BY  
    YEAR(FROM_UNIXTIME(created_at)), 
    QUARTER(FROM_UNIXTIME(created_at)), 
    MONTHNAME(FROM_UNIXTIME(created_at)), 
    MONTH(FROM_UNIXTIME(created_at))
ORDER BY  
    year DESC, 
    quarter ASC, 
    month_num ASC;
    
-- 5.Total Number of Projects By Amount Raised
SELECT  
    name AS Project_Name,
    State,
    (goal * static_usd_rate) AS Amount_Raised
FROM  
    croudfunding_kickstarter.projects
WHERE  
    State = 'successful'
ORDER BY  
    amount_raised DESC;

-- 6.Total Number of Successful Projects By Backers
SELECT 
    name AS Project_Name,
    State,
    Backers_Count
FROM 
    croudfunding_kickstarter.projects
WHERE 
    State = 'successful'
ORDER BY 
    Backers_Count DESC;
    
-- 7. Category Wise Average Number of Days for Successful Projects
    SELECT
    c.name AS Category,
    AVG(DATEDIFF(FROM_UNIXTIME(p.deadline), FROM_UNIXTIME(p.created_at))) AS Avg_Project_Duration_Days
FROM
    croudfunding_kickstarter.projects p
JOIN
    croudfunding_kickstarter.category c ON p.category_id = c.id
WHERE
    p.state = 'successful'
GROUP BY
    c.name
ORDER BY
    avg_project_duration_days DESC;


-- 8.Average Number of Days for Successful Projects
SELECT
    AVG(DATEDIFF(FROM_UNIXTIME(deadline), FROM_UNIXTIME(created_at))) AS avg_project_duration_days
FROM
    croudfunding_kickstarter.projects
WHERE
    state = 'successful';

-- 9.Percentage of Successful Projects Overall
SELECT  
    (SUM(state = 'successful') * 100 / COUNT(*)) AS success_percentage
FROM  
    croudfunding_kickstarter.projects;
    
-- 10.Percentage of Successful Projects by Category
SELECT  
    c.name AS Category_Name,
    COUNT(p.ProjectID) AS Total_Projects,
    SUM(p.state = 'successful') AS Successful_Projects,
    (SUM(p.state = 'successful') * 100.0 / COUNT(p.ProjectID)) AS Success_Percentage
FROM  
    croudfunding_kickstarter.projects p
JOIN  
    croudfunding_kickstarter.category c 
    ON p.category_id = c.id
GROUP BY  
    c.name
ORDER BY  
    success_percentage DESC;
    
-- 11.Percentage of Successful Projects by Goal Range
SELECT  
    CASE  
        WHEN (goal * static_usd_rate) < 5000 THEN '< 5000'
        WHEN (goal * static_usd_rate) BETWEEN 5000 AND 20000 THEN '5000 to 20000'
        WHEN (goal * static_usd_rate) BETWEEN 20000 AND 50000 THEN '20000 to 50000'
        WHEN (goal * static_usd_rate) BETWEEN 50000 AND 100000 THEN '50000 to 100000'
        ELSE 'Greater than 100000'
    END AS Goal_Range,
    COUNT(ProjectID) AS Total_Projects,
    SUM(state = 'successful') AS Successful_Projects,
    (SUM(state = 'successful') * 100.0 / COUNT(ProjectID)) AS Success_Percentage
FROM  
    croudfunding_kickstarter.projects
GROUP BY  
    goal_range
ORDER BY  
    success_percentage DESC;

    





