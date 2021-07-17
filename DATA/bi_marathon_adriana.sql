create database bi_marathon_adriana;
use bi_marathon_adriana;
-- Creating  temp table to load our CSV file
create table temp_table
(

    category varchar (255)
   ,country	varchar (255)
   ,state varchar (10)	
   ,age	int
   ,gender varchar (255)
   ,before_environment	varchar (255)
   ,before_classworkStress int
   ,before_homeworkStress int
   ,before_homeworkHours int
   ,now_environment	varchar (255)
   ,now_classworkStress	int
   ,now_homeworkStress	int
   ,now_homeworkHours	int
   ,familyrelationships	int
   ,friendrelationships int
   
)
;

select * 
from temp_table
;

-- create #1 dimension student_table 

create table dim_student(
     student_id int not null auto_increment
     ,category varchar (255)
     ,age int
     ,gender varchar (255)
     , primary key (student_id) 
     )
;
-- create #2 dimension address_table 

create table dim_address (
	  address_id int not null auto_increment
	 ,country varchar (10)
     ,state varchar (10)
     , primary key (address_id) 
)
;

-- create #3 dimension MetricDescription

create table dim_MetricDescription (
     metricname int not null auto_increment
	,metric_name varchar (255)
	, primary key (metricname)

)
;

-- create fact table

create table Fact_table (

	   fact_metric int not null auto_increment
      ,student_id int 
      ,address_id int 
      ,metric_name_id int
      ,metric int
      ,primary key(fact_metric)
	  ,FOREIGN KEY (student_id) REFERENCES dim_student (student_id) ON DELETE SET NULL
      ,FOREIGN KEY (address_id) REFERENCES dim_address (address_id) ON DELETE SET NULL
      ,FOREIGN KEY (metric_name_id) REFERENCES dim_MetricDescription (metric_name_id) ON DELETE SET NULL
      
      

)
;

drop table fact_table; 

;
-- uploading student table

INSERT IGNORE INTO dim_student (category, age, gender)
SELECT DISTINCT category, age, gender FROM temp_table
;

select*
from dim_student;

-- uploading address table

INSERT IGNORE INTO dim_address (country, state)
SELECT DISTINCT country, state FROM temp_table
;

select*
from dim_address;
 
 -- uploading MetricDescription table
 
INSERT INTO dim_MetricDescription (metric_name)
VALUES 
         ('before_environment'), 
         ('before_classworkStress'), 
         ('before_homeworkStress'),
         ('before_homeworkHours'),
         ('now_environment'),
         ('now_classworkStress'),
         ('now_homeworkStress'),
         ('now_homeworkHours'),
         ('familyrelationship'),
         ('friendrelationships');

select*
from dim_MetricDescription;


-- uploading fact table

INSERT IGNORE INTO fact_table (student_id, address_id, metric_name_id, metric) 
SELECT distinct
    ds.student_id
   ,da.address_id
   ,dm.metric_name_id
   ,t.metric
   FROM temp_table t
   JOIN dim_student ds ON ds.category = t.category
   JOIN dim_address da ON da.state = t.state 
   JOIN dim_MetricDescription dm ON dm.metric_name = t.metric_name
   
   ;

   
   
   select *
   from dim_MetricDescription;
   
   ALTER table dim_MetricDescription rename column metricname to metric_name_id ;
   
   
   DELETE FROM dim_MetricDescription
   where metric_name_id in (1,5);
  
    
  select *
   from dim_MetricDescription;

drop table fact_table;

drop table dim_MetricDescription;

Create table fact_table(

        fact_id int not null auto_increment 
       ,student_id int
       ,address_id int
       ,before_environment	varchar (255)
       ,before_classworkStress int
	   ,before_homeworkStress int
       ,before_homeworkHours int
       ,now_environment	varchar (255)
       ,now_classworkStress	int
       ,now_homeworkStress	int
       ,now_homeworkHours	int
       ,familyrelationships	int
       ,friendrelationships int
       ,primary key (fact_id)
	   ,FOREIGN KEY (student_id) REFERENCES dim_student (student_id) ON DELETE SET NULL
       ,FOREIGN KEY (address_id) REFERENCES dim_address (address_id) ON DELETE SET NULL
       
       )
       ;
       
       select*
       from fact_table;
       
INSERT INTO fact_table (student_id, address_id, before_environment, before_classworkStress, before_homeworkStress,before_homeworkHours, now_environment, now_classworkStress, now_hhomeworkStress, now_homeworkHours,familyrelationships, friendrelationships)
SELECT distinct
	  ds.Student_id
     ,da.address_id
     ,t.before_environment
	 ,t.before_classworkStress
	 ,t.before_homeworkStress
	 ,t.before_homeworkHours
     ,t.now_environment
	 ,t.now_classworkStress
	 ,t.now_hhomeworkStress
	 ,t.now_homeworkHours
	 ,t.familyrelationships
	 ,t.friendrelationships  
     From temp_table t
     JOIN dim_student ds ON ds.category = t.category
     JOIN dim_address da ON da.state = t.state
     
     ;
       
	select*
    from fact_table;
    
select ds.category, da.state, f.before_environment
from fact_table f
join dim_address da on f.address_id = da.address_id
join dim_student ds on ds.student_id = f.student_id
where ds.gender = 'male'

;

select ds.category, da.state, f.before_environment
from fact_table f
join dim_address da on f.address_id = da.address_id
join dim_student ds on ds.student_id = f.student_id
where ds.gender = 'female'
;

select ds.category, da.state, f.before_environment
from fact_table f
join dim_address da on f.address_id = da.address_id
join dim_student ds on ds.student_id = f.student_id
where ds.age = '17'

;

select ds.category, da.state, f.before_environment
from fact_table f
join dim_address da on f.address_id = da.address_id
join dim_student ds on ds.student_id = f.student_id
where ds.age = '20'