# MavenPizza

Several of the datasets contained duplicated entries, errors, and formatting inconsistencies. Cleaning the data ensures accuracy during further data analysis.

Data was queried from multiple tables within the Maven's Pizzas database to evalute the store's sales trends over the course
of one year. Measures included quantity of orders, quantity of pizzas ordered, revenue, quantity of type of pizzas, and price per order.
These measures were used to determine popular days of the week, peak and lull hours, sales per quarter, and most and least popular pizzas.
Knowing this information is useful to the stakeholders for making decsions about potential changes to the hours/days of operation 
and pizza type availability.

An interactive dashboard was created to present the data to stakeholders and help them make informed decsions about their business.

Files
---
| File Name  | Description |
| ------------- | ------------- |
| pizza_types.xlsx | Spreadsheet describing the name and ingredients included on each pizza available at the restaurant. This dataset did not require cleaning.  |
| PizzasRAW.xlsx | Spreadhseet describing the price for each pizza at every size available (small, medium, large). This is the raw dataset before cleaning. |
| PizzaOrdersRAW.xlsx | Spreadsheet showing all order id's and when each order was placed. This is the raw dataset before cleaning.  |
| PizzaOrderDetailsRAW.xlsx | Spreadsheet describing the pizzas and quantity ordered for each order id. This is the raw dataset before cleaning |
| PizzasCleaning.sql  | SQL script containing all steps involved to clean the dataset provided by the PizzasRAW.xlxs file.  |
| PizzaOrdersCleaning.sql  | SQL script containing all steps involved to clean the dataset provided by the PizzaOrdersRAW.xlxs file.  |
| PizzaOrderDetailsCleaning.sql  | SQL script containing all steps involved to clean the dataset provided by the PizzaOrderDetailsRAW.xlxs file.  |
| PizzaProject.sql  | SQL script containing all queries used to find the measures necessary for analysis. |
| PizzaSales.pbix  | Interactive dashboard visualizing the restaurant's pizza sales. |


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
