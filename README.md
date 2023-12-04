# MavenPizza

Several of the datasets contained duplicated entries, errors, and formatting inconsistencies. Cleaning the data ensures accuracy during further data analysis.

Data was queried from multiple tables within the Maven's Pizzas database to evalute the store's sales trends over the course
of one year. Measures included quantity of orders, quantity of pizzas ordered, revenue, quantity of type of pizzas, and price per order.
These measures were used to determine popular days of the week, peak and lull hours, sales per quarter, and most and least popular pizzas.
Knowing this information is useful to the stakeholders for making decsions about potential changes to the hours/days of operation 
and pizza type availability.

An interactive dashboard was created to present the data to stakeholders and help them make informed decisions about their business.

Files
---
| File Name  | Description |
| ------------- | ------------- |
| pizza_types.xlsx | Spreadsheet describing the name and ingredients included on each pizza available at the restaurant. This dataset did not require cleaning.  |
| pizzas_RAW.xlsx | Spreadhseet describing the price for each pizza at every size available (small, medium, large). This is the raw dataset before cleaning. |
| pizza_orders_RAW.xlsx | Spreadsheet showing all order id's and when each order was placed. This is the raw dataset before cleaning.  |
| pizza_order_oetails_RAW.xlsx | Spreadsheet describing the pizzas and quantity ordered for each order id. This is the raw dataset before cleaning |
| pizzas_cleaning.sql  | SQL script containing all steps involved to clean the dataset provided by the PizzasRAW.xlxs file.  |
| pizza_orders_cleaning.sql  | SQL script containing all steps involved to clean the dataset provided by the PizzaOrdersRAW.xlxs file.  |
| pizza_order_details_cleaning.sql  | SQL script containing all steps involved to clean the dataset provided by the PizzaOrderDetailsRAW.xlxs file.  |
| pizza_project.sql  | SQL script containing all queries used to find the measures necessary for analysis. |
| pizza_sales.pbix  | Interactive dashboard visualizing the restaurant's pizza sales. |

Software
---
Microsoft SQL Server: Clean and query the data

Microsoft Power BI: Visualize the data and create a dashboard

Data Sources
---
Original Data Source: https://mavenanalytics.io/data-playground

Dirty Data: https://anniesanalytics-datasets.carrd.co/

Author
---
Sadie Hearn

Email: sadie.ae.hearn@gmail.com

LinkedIn: linkedin.com/in/sadiehearn
