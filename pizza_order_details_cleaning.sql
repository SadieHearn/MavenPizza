/******************************************************************************************************************************************
TITLE: Pizza Order Details Data Cleaning
AUTHOR: Sadie Hearn
DESCRIPTION: This script focuses on cleaning the data from the pizzas_raw table.
Skills Used- aggregate functions, window functions, updating columns, altering columns, CTE 

******************************************************************************************************************************************/
-------------------------------------------------------------------------------------------------------------------------------------------
/*
Create a copy of the table to preserve the raw data
Data cleaning will take place in the new table

*/

select *
into
	pizza_order_details
from
	pizza_order_details_raw
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Look at the available data to determine what needs to be cleaned

*/

--Look over the table as a whole
select *
from 
	pizza_order_details
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Duplication Check
A primary key was not assigned so check for duplicated order_details_id's
Check for duplications with different order_details_id's

*/

--Check for duplicated order_details_id's
select
	order_details_id
	, count(*) as duplicates
from
	pizza_order_details
group by
	order_details_id
having
	count(*) > 1
;
--No duplications

--Check for duplicated data with different order_details_id
with data_dupes as(
select
	*
	, row_number() over(partition by
								order_id
								, pizza_id
								, quantity
						order by 
							order_details_id) as duplicate_number
from 
	pizza_order_details
)

select *
from data_dupes
where duplicate_number > 1
;
--No duplications found

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Assign order_details_id as the primary key for this table

*/

alter table
	pizza_order_details
alter column
	order_details_id float not null
;

alter table
	pizza_order_details
add primary key
	(order_details_id)
;