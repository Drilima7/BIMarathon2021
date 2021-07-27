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
/* Creating a new column for the student's nationality. Using the majority of my date. Case when country is US we will then have them as americans in our new nationality colunm.
 For the next one when country is GB then we will have them as British in our new Nationality column.*/

        
		select *,
        CASE WHEN country = 'US'  THEN 'AMERICANS'
        ELSE 'OTHER' END AS Nationality
        from dim_address
        
        ;
        
        select *,
        CASE WHEN country = 'GB' THEN 'British'
        ELSE 'OTHER' END AS Nationality
        from dim_address
	
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