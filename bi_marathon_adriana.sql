create database bi_marathon_adriana;
use bi_marathon_adriana;
-- Creating  temp table to load our CSV file
create table temp_table;
(

    category 
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
   ,now_hhomeworkStress	int
   ,now_homeworkHours	int
   ,familyrelationships	int
   ,friendrelationships int
   
)