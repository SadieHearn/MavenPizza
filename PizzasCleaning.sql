/******************************************************************************************************************************************
TITLE: Pizzas Data Cleaning
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
	pizzas
from
	PizzasRAW
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Look at the available data to determine what needs to be cleaned

*/

--Look over the table as a whole
select *
from 
	pizzas
;

--Some records share values in the pizza_type_id field. Group by the pizza_type_id to check for format inconsistencies
select
	pizza_type_id
from
	pizzas
group by
	pizza_type_id
;

--Some records share values in the size field. Group by the size to check for format inconsistencies
select
	size
from
	pizzas
group by
	size
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
The values in the pizza_id field have inconsistent underscore placement

*/

--Add underscores wherever there are spaces
select
	pizza_id
	, replace(pizza_id, ' ', '_') as updated_pizza_id
from
	pizzas
;

--Apply the changes to the table
update
	pizzas
set
	pizza_id = replace(pizza_id, ' ', '_')
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
The values in the price field are not all of the same precision
The object explorer shows this field is the data type float
Since these are monetary values they should show 2 decimal places

*/

--Change the price field to the data type decimal with 2 decimal points
select
	price
	, convert(decimal(5, 2), price) as updated_price
from
	pizzas
;

--Apply the changes to the table
alter table
	pizzas
alter column 
	price decimal(5, 2)
;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Duplication Check
A primary key was not assigned so check for duplicated order_id's
Check for duplications with different order_id's

*/

--Check for duplicated pizza_id's
select
	pizza_id
	, count(*) as duplicates
from
	pizzas
group by
	pizza_id
having count(*) > 1
;
--No duplicated pizza_id's

--Check for duplicated data with different order_id
with data_dupes as(
select
	*
	, row_number() over(partition by
								pizza_type_id
								, size
								, price
						order by 
							pizza_id) as duplicate_number
from 
	pizzas
)

select *
from data_dupes
where duplicate_number > 1
;
--No duplications found

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Assign pizza_id as the primary key for this table

*/

alter table
	pizzas
alter column
	pizza_id nvarchar(255) not null
;

alter table
	pizzas
add primary key
	(pizza_id)
;
