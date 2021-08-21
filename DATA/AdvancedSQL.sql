-- Module 3

-- finding duplicates - Cleaning

select *
from dim_address;

Insert into dim_address(country)
values ('FR'), ('RS');

Select
      country 
	, COUNT(*) AS CNT
    FROM dim_address
    GROUP BY country
    HAVING COUNT(*)>1;

select *
from dim_address;

delete from dim_address
where address_id in (32,33); 

-- Case When 
/* Creating a new column for the student's nationality. Case when country is US we will then have them as americans in our new nationality colunm.
 For the next one when country is GB then we will have them as British in our new Nationality column.*/

        
		select *,
        CASE WHEN country = 'US'  THEN 'AMERICANS'
        WHEN country = 'GB' THEN 'British'
        ELSE 'other' END AS Nationality
        FROM dim_address
        
        ;
        
        -- COALESCE 
	
    /*COALESCE N/A for the null states presented in my database.*/
        
          SELECT 
			country,
            coalesce(state, 'N/A') as state
            FROM dim_address
            ;
        
        
        -- NULLIFF 
        
      /* From my student table I am selecting category, age and the gender of my students. I am using the query nullif for student's gender. 
		Nullif the gender is male. All the results will return as NULL for the male students. */
        
        SELECT 
            category,
            age,
            nullif(gender, 'male') AS gender
            FROM dim_student
            ;

-- GREATEST 

   /* I am showing below the students with homework stress level 3 or greater before the pandemic and we can see if their stress level increased or 
   decreased with the pandemic. We will visualize the student id, how was their environment(virtual or physical school) before pandemic and now. 
   With that information we can see how the change of the enviromment affetected their stress level.*/

  
SELECT 
	student_id,
	before_environment,
    greatest(3, before_homeworkStress ) as before_homeworkStress,
    before_environment,
    now_homeworkStress
	FROM fact_table;
   
       
/* I am showing below only the students who are facing a high level of stress with the pandemic. 
So I am asking for student id, the type of enviromnent (virtual or physical school). 
Homework stress at least 5 (what is the higer level on my dataset).*/
   
 

		SELECT 
              student_id,
              now_environment,
              least(5, now_homeworkStress ) as now_homeworkStress 
              FROM fact_table
              
              ;
              
ALTER table fact_table rename column now_hhomeworkStress to now_homeworkStress ;              

 ALTER table temp_table rename column now_hhomeworkStress to now_homeworkStress ;
 
 /* I am using the distinct state to know all states from my address table.*/

 Select 
       distinct state
       from dim_address;
       
-- Modulo 4 - CTE
 
 /* Showing the avg of homework hours by male students before the pandemic */ 
 
 WITH CTE_1 as (
 SELECT DISTINCT student_id
 FROM dim_student
 WHERE gender IN ("male")
 
 )
 ,CTE_2 as (
 SELECT avg(before_homeworkhours ) as before_pandemicHours
 FROM fact_table
 WHERE before_homeworkHours between 3 and 5
 

 
 )
 SELECT student_id
	    ,before_homeworkhours
 FROM fact_table
 WHERE student_id in (SELECT DISTINCT student_id from CTE_1)
       AND before_homeworkhours >= (SELECT before_pandemicHours FROM CTE_2)
       
       ;
 
 -- RECURSIVE CTES
 
 -- PIVOTING DATA W/ CASE WHEN
 /* Showing pivoting data when student with stress between 4 and 5 and spend more than 5 hours on homework = stressed */
 SELECT 
	 fact_id
     ,student_id
     ,address_id
     ,before_environment
     ,now_environment
     ,sum(CASE WHEN now_homeworkStress in (4, 5) then student_id end) as "Homework_cases" 
     ,sum(case when now_classworkStress in (4,5) then student_id end) as "Claswork_cases"
     from fact_table
     Group by fact_id,student_id, address_id, before_environment, now_environment

	
     
;     
     

 
 Select 
        before_environment as be,
        now_environment as ne,
        before_homeworkStress,
        now_homeworkStress
        From fact_table
        WHERE before_homeworkStress > now_homeworkStress
        order by 1 
        
        ;
 

 -- WINDOW FUNCTION
 
 /* Showing the rank of student and their enviromnent by homework 
 hours during the pandemic */ 

 SELECT
       student_id
	   ,now_environment
       ,row_number() OVER (ORDER BY now_homeworkHours)
       ,rank() over (order by now_homeworkHours)
       ,dense_rank() over (order by now_homeworkHours)
FROM fact_table;
      
 
 
  -- CALCULATION RUNNING TOTALS - running the total of homework hours before pandemic 
            SELECT 
                 country,
                 SUM(before_homeworkHours) OVER (PARTITION BY country) AS beforePand_homework
                 FROM fact_table f
                 JOIN dim_address da ON da.address_id = f.address_id 
                 GROUP BY COUNTRY
                 
                 ;
                 
		SELECT 
			  gender,
			  SUM(now_homeworkStress) OVER (PARTITION BY gender) AS male_stress
			  FROM fact_table f
			  JOIN dim_student ds ON ds.student_id = f.student_id 
			  GROUP BY gender;
                 


SELECT before_homeworkHours
FROM fact_table;
 

       
	    
