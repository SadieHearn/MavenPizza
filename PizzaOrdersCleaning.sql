/******************************************************************************************************************************************
TITLE: Pizza Orders Data Cleaning
AUTHOR: Sadie Villarrubia
DESCRIPTION: This script focuses on cleaning the data from the pizza_orders_raw table.
Skills Used- aggregate functions, window functions, updating columns, altering columns, CTE 

******************************************************************************************************************************************/
-------------------------------------------------------------------------------------------------------------------------------------------
/*
Create a copy of the table to preserve the raw data
Data cleaning will take place in the new table

*/

select 
	*
into
	pizza_orders
from
	pizza_orders_raw
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Look at the available data to determine what needs to be cleaned

*/

--Look over the table as a whole 
select
	*
from
	pizza_orders
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Some of the order_id records contain unwanted leading 'AA' or '_'

*/

--Trim the excess characters
select 
	order_id
	,  trim('AA_' from order_id) as updated_order_id
from
	pizza_orders
;

--Apply changes to the table
update
	pizza_orders
set
	order_id = trim('AA_' from order_id)
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
The order_id field is the data type nvarchar, which makes ordering the records by order_id challenging

*/

--Change the order_id field to the data type int
select
	order_id
	, convert(int, order_id) as updated_data_type
from
	pizza_orders
;

--Apply the changes to the table
alter table
	pizza_orders
alter column
	order_id int
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Change date format so it only shows the date without the default time 00:00:00

*/

select
	date
	, convert(date, date) as updated_column
from
	pizza_orders
;

--Apply the changes to the table
alter table
	pizza_orders
alter column
	date date
;
-------------------------------------------------------------------------------------------------------------------------------------------
/*
Change replace . with : in the time column

*/

select
	time
	, replace(time, '.', ':') as updated_column
from
	pizza_orders
;

--Apply the changes to the table
update
	pizza_orders
set
	time = replace(time, '.', ':')
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Duplication Check
A primary key was not assigned so check for duplicated order_id's
Check for duplications with different order_id's

*/

--Check for duplicated order_id's
select
	order_id
	, count(*) as duplicates
from
	pizza_orders
group by
	order_id
having
	count(*) > 1
order by
	order_id
;
--There are many duplicated order id's
--Check if the duplications occur across all fields or if different data was assigned the same id
with id_dupes as(
select
	*
	, row_number() over(partition by
								order_id
						order by 
							date desc
							, time) as duplicate_number
from 
	pizza_orders
)

--select *
--from
--	id_dupes
--;

--Some of the duplications occur across all fields while others added NULL values to the same order_id
--In this case, all instances of duplicated order_id may be deleted
--Apply deletions
delete
from
	id_dupes
where
	duplicate_number > 1
;

--Check for duplicated data with different order_id's
with data_dupes as(
select
	*
	, row_number() over(partition by
								date
								, time
						order by 
							order_id) as duplicate_number
from 
	pizza_orders
)

select 
	*
from data_dupes
where duplicate_number > 1
;
--No duplications found

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Assign order_id as the primary key for this table

*/

alter table
	pizza_orders
alter column
	order_id int not null
;

alter table
	pizza_orders
add primary key
	(order_id)
;	