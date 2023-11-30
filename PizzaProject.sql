/******************************************************************************************************************************************
TITLE: Maven Pizza Sales Analysis
AUTHOR: Sadie Hearn
DESCRIPTION: Query data from multiple tables within the database for Maven's Pizzas to evalute the store's sales trends over the course
of one year. Measures include quantity of orders, quantity of pizzas ordered, revenue, quantity of type of pizzas, and price per order.
These measures will help determine popular days of the week, peak and lull hours, sales per quarter, and most and least popular pizzas.
Knowing this information will be useful to the stakeholders for making decsions about potential changes to the hours/days of operation 
and pizza type availability. 
Skills Used- aggregate functions, window functions, temp table, CTE's, joins, views

******************************************************************************************************************************************/
-------------------------------------------------------------------------------------------------------------------------------------------
/*
Measuring by date will be useful to view average daily sales, sales by day of the week, and sales by quarter. Since the date will be used
to peform all of these calculations, a temp table will be created, which may be referenced multiple times per session.

*/

drop table if exists #sales_by_date --Prevents creation of multiple tables of the same name if script is run multiple times in a session

--Create temp table to calculate the number of orders, pizzas sold, and revenue for each date
create table #sales_by_date (
	date date
	, weekday varchar(50)
	, month varchar (50)
	, quarter int
	, order_quantity int
	, pizza_quantity int
	, revenue float
);
	
insert into #sales_by_date
select
	ord.date
	, datename(weekday, ord.date)
	, datename(month, ord.date)
	, datename(quarter, ord.date)
	, count(distinct(ord.order_id))
	, sum(det.quantity)
	, sum(piz.price * det.quantity)
from
	pizza_order_details as det
		join pizza_orders as ord
			on det.order_id = ord.order_id
		join pizzas	as piz
			on det.pizza_id = piz.pizza_id
group by
	ord.date
;

--Daily averages for the year
select
	avg(order_quantity) as avg_orders_daily
	, avg(pizza_quantity) as avg_pizza_quantity_daily
	, round(avg(revenue),2) as avg_revenue_daily
from
	#sales_by_date
;

--Averages by day of the week
select
	weekday
	, avg(order_quantity) as avg_orders
	, avg(pizza_quantity) as avg_pizza_quantity
	, round(avg(revenue),2) as avg_revenue
from
	#sales_by_date
group by
	weekday
order by
	case
		when weekday = 'Monday' then 1
		when weekday = 'Tuesday' then 2
		when weekday = 'Wednesday' then 3
		when weekday = 'Thursday' then 4
		when weekday = 'Friday' then 5
		when weekday = 'Saturday' then 6
		when weekday = 'Sunday' then 7
	end
;

--Total sales for each quarter
select
	quarter
	, sum(order_quantity) as total_orders
	, sum(pizza_quantity) as total_pizzas
	, round(sum(revenue),2) as total_revenue
from
	#sales_by_date
group by
	quarter
order by
	quarter
;

-------------------------------------------------------------------------------------------------------------------------------------------------
/*
Similar to calculating by date,  quantity of orders, quantity of pizzas ordered and revenue for each hour of the day will be used to 
determine the store's peak and lull hours. A CTE will be created so a subsequent query may be used to calculate the averages of each of 
these measures.

*/

--Create CTE to calculate the number of orders, pizzas sold, and revenue for each hour of each date
with sales_by_hour as(
select
	ord.date
	, concat(substring(ord.time, 1, 2), ':00') as timestamp_hour
	, count(distinct(ord.order_id)) as order_quantity
	, sum(det.quantity) as pizza_quantity
	, sum(piz.price * det.quantity) as revenue
from
	pizza_order_details as det
		join pizza_orders as ord
			on det.order_id = ord.order_id
		join pizzas	as piz
			on det.pizza_id = piz.pizza_id
group by
	ord.date
	, substring(ord.time, 1, 2)
)

--Averages by hour of the day
select
	timestamp_hour
	, avg(order_quantity) as avg_orders
	, round(avg(pizza_quantity), 0) as avg_pizza_quantity
	, round(avg(revenue),2) as avg_revenue
from
	sales_by_hour
group by
	timestamp_hour
order by
	timestamp_hour
;

-------------------------------------------------------------------------------------------------------------------------------------------------
/*
To determine the popularity of each type of pizza, I'll calculate the number of each type of pizza ordered for each month and rank them
from most to least ordered. Again, a CTE will be used to rank the pizza types then to pull the most and least popular pizzas for each month.

*/

--Create CTE to find the number of each tpye of pizza ordered each month and rank from most to least popular
with pizza_types_by_month as(
select
	datename(month, ord.date) as month
	, piz.pizza_type_id
	, sum(det.quantity) as quantity_ordered
	, rank() over (partition by datename(month, ord.date) order by sum(det.quantity) desc) as ranked_type
			--The window function rank (as opposed to dense_rank) is used so the pizzas ranked first and last for each month will be
			--ranked 1st and 32nd, respectively
from
	pizza_order_details as det
		join pizza_orders as ord
			on det.order_id = ord.order_id
		join pizzas	as piz
			on det.pizza_id = piz.pizza_id
group by
	datename(month, ord.date)
	, piz.pizza_type_id
)

--Return the most and least popular pizzas for each month
select
	*
from pizza_types_by_month
where
	ranked_type = 1
	or ranked_type = 32
order by
	case
		when month = 'January' then 1
		when month = 'February' then 2
		when month = 'March' then 3
		when month = 'April' then 4
		when month = 'May' then 5
		when month = 'June' then 6
		when month = 'July' then 7
		when month = 'August' then 8
		when month = 'September' then 9
		when month = 'October' then 10
		when month = 'November' then 11
		when month = 'December' then 12
	end
;

-------------------------------------------------------------------------------------------------------------------------------------------------
/*
Another CTE will be used to find the price of each order placed and then the average price of a single order for the year.

*/

--Create CTE to find the total price for each order placed
with order_prices as(
select
	det.order_id
	, sum(piz.price * det.quantity) as order_price
from 
	pizza_order_details as det
		join pizzas as piz
			on det.pizza_id = piz.pizza_id
group by
	det.order_id
)

--Find the average order price for the year
select
	round(avg(order_price), 2) as average_order_price
from
	order_prices
;

-------------------------------------------------------------------------------------------------------------------------------------------------
/*
Power BI will be used to visualize and create a dashboard of the data. Views will be created of the temp table and CTEs used in this script
to easily visualize the desired measures.

*/



--Sales by Date
create view sales_by_date as(
select
	ord.date
	, datename(weekday, ord.date) as weekday
	, datename(month, ord.date) as month
	, datename(quarter, ord.date) as quarter
	, count(distinct(ord.order_id)) as order_quantity
	, sum(det.quantity) as pizza_quantity
	, sum(piz.price * det.quantity) as revenue
from
	pizza_order_details as det
		join pizza_orders as ord
			on det.order_id = ord.order_id
		join pizzas	as piz
			on det.pizza_id = piz.pizza_id
group by
	ord.date
);

--Sales by Hour
create view sales_by_hour as(
select
	ord.date
	, concat(substring(ord.time, 1, 2), ':00') as timestamp_hour
	, count(distinct(ord.order_id)) as order_quantity
	, sum(det.quantity) as pizza_quantity
	, sum(piz.price * det.quantity) as revenue
from
	pizza_order_details as det
		join pizza_orders as ord
			on det.order_id = ord.order_id
		join pizzas	as piz
			on det.pizza_id = piz.pizza_id
group by
	ord.date
	, substring(ord.time, 1, 2)
);

--Ranked Pizza Popularity by Month
create view pizza_types_by_month as(
select
	datename(month, ord.date) as month
	, piz.pizza_type_id
	, sum(det.quantity) as quantity_ordered
	, rank() over (partition by datename(month, ord.date) order by sum(det.quantity) desc) as ranked_type
from
	pizza_order_details as det
		join pizza_orders as ord
			on det.order_id = ord.order_id
		join pizzas	as piz
			on det.pizza_id = piz.pizza_id
group by
	datename(month, ord.date)
	, piz.pizza_type_id
);

--Price for Each Order
create view order_prices as(
select
	det.order_id
	, sum(piz.price * det.quantity) as order_price
from 
	pizza_order_details as det
		join pizzas as piz
			on det.pizza_id = piz.pizza_id
group by
	det.order_id
);

