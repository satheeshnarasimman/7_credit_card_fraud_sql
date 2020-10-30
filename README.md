## week7_sql_project

In this project, potential fraudulent transactions are analyzed over a period of 1 year for 25 different people, using Structured Query Language (SQL) and Pandas. 
Then a time series transaction graph is plotted for customers 2 and 18 to understand the usage patterns. Additionally, outliers for customer 25 are detected using a box plot. Furthermore, the outliers in the dataset is determined using standard deviation and inter-quartile range

## Technologies and Libraries
- Python
- Pandas
- SQL
- calendar
- plotly express as px
- hvplot
- sqlalchemy
- create_engine
- Numpy
- random

## Tools used
- Github
- Gitbash
- Jupyter Lab
- Postgres
- Microsoft CSV
- Quick Database Diagram (DBD)
- Operating System: Windows-10, 64-Bit

## Data given
- Cardholder name and ID
- Credit card number and corresponsing cardholder ID
- Merchant ID, Merchant name and merchant category ID
- Merchant category name
- Historical transaction amount, transaction ID

## Notebooks/ Images created
- Visual data analysis
- Challenge
- Entity Relationship Diagram (ERD)

## Metrics calculated
- The transactions between 7 AM- 9 AM for all the customers for the entire year, sorted by the highest amount.
- The count of transactions less than 2 USD for all the customers.
- The count of transactions less than 2 USD, sorted by the top 5 merchants.
- The time record of transactions for customers 2, 18 and 25, sorted by the highest.
- Mean amount spent by each customer in the year
- Standard deviation of the transactions per customer for the year
- Outliers using standard deviation
- Outliers using Interquartile range

## Plots created
- Time series of transactions for customers 2 and 18 (Line plot)
- Combined plot overlaid for customers 2 and 18
- Box plot of transaction amount for the months from Jan- Jun for customer 25

## High-level summary
### Data Modeling
- Five tables are created in accordance with the csv file column names. The relationships between the tables are defined through the primary key and foreign key. The ID's are set as the primary key and the related columns among the tables are set as the foreign key.
- An ERD is generated using the Quick DBD tool. From the ERD, it could be seen that almost all the tables are interconnected.
- An SQL schema is automatically generated by the Quick DBD, upon exporting the data as Postgresql.

### Data Engineering
- Using the database model as a blueprint, a database schema is created in Postgresql to analyze the data. Minor changes in the column datatype are made and the constrains defined in the Quick DBD are not changed.
- The CSV files are imported in Postgresql
- The name of the matching columns among the CSV tables are altered and made consistent throughout all the tables, for convenient referencing and analysis.

### Data Analysis
- All the tables are merged with one after the other by left join, through column/s that is/are common between 2 tables.
- The metrics calculated are outlined above

### SQL Views
- Money spent by each customer with a specific merchant, sorted by the highest
- Each instance of money spent by each customer.
- The transactions between 7 AM- 9 AM for all the customers for the entire year, sorted by the highest amount.
- The count of transactions less than 2 USD for all the customers.
- The count of transactions less than 2 USD, sorted by the top 5 merchants.
- The time record of transactions for customers 2, 18, sorted by the highest.
- The transactions during the first half of the year for customer 25

### Visual Data analysis
- A connection to the Postgres server is established to retrieve the query.
- The time record of transactions for customers 2, 18 is converted to a Pandas Dataframe.
- A hvplot of the time series of transactions the pertinent customers are created separately.
- Both the plots are overlaid to understand the spending pattern and potential fraud.
- The time record of transactions from Jan to Jun 2018 for customer 25 is converted to a Pandas Dataframe.
- A plotly express box plot is created for each of the months from Jan- Jun 2018 to detect outliers.

### Challenge
- Mean amount spent by each customer in the year 2018 is computed.
- Standard deviation of the transactions per customer is determined.
- The lower and upper limits for the outliers are set
- A random seed generator of 1 is set to generate univariate observations.
- The univariate mean and std deviation is calculated.
- The maximum standard deviation is 2 levels.
- Outliers are determined based on the values in univariate observations.
- The 25th and 75th quartiles are calculated and the interquartile range.
- The maximum standard deviation is 2 levels.
- Just like the std deviation method, outliers are determined based on the values in univariate observations.

## Interpretations and results
#### Grouping the transaction of each customer

The transactions of each customer have been grouped by the card holder's id and sorted by the highest amount of money they spent with a specific merchant.

#### Is there a potential sign of fraudulent transactions between 7 AM and 9 AM?

The data has been sorted by the highest transaction. Yes, for the given timeframe, the top 10 transactions are way above the rest of them. These outliers indicate convincing signs of fraud. The card holder ID '1' has been the worst hit with 3 extravagant purchases; followed by ID '16' with 2 swipes appearing in the top 10.

#### Is there an evidence that a credit card has been hacked, from the count of transactions less than 2 USD?

From my experience, it is extremely rare to encounter transactions less than 2 USD. I would argue that if the count of small transactions is greater than 3 per year, then there is a reason for suspicion.

From the data analysis, for all the card holder's id's except 3 and 9, their credit card information has been compromised in the form of a micro-fraud.

#### What are the top 5 merchants prone to being hacked?

From the analysis, the top 5 merchants prone to being hacked are:

- 141: Wood-Ramirez
- 145: Hood-Philips
- 048: Baker Inc
- 149: Clark and Sons
- 114: Greene-Wood

#### Interpretation of the consumption patterns for the customer Id's 2 and 18

From the 3 graphs above, the greatest value of transaction for customer ID 2 has not even exceeded 20 USD, while for the customer ID 18, the curve swings to extreme highs and lows. For the latter, given the graph scale, the curve is mostly flat for the year. However, there have been 7 lavish purchases (greater than 1000 USD), indicating that they are most likely fraudulent.

#### Interpretation of box plot over the first half of the year for customer 25

For the months of Jan, Mar, Apr and May, there is one outlier that is very far away from the rest of the data points, while for the month of Jun there are 2 anomalous usages. From these outliers, it could be concluded that those transactions are unauthorized. There are 2 outliers quite close to the rest of the data for Apr, which can be ignored.

#### Identifying outliers using standard deviation and Interquartile range

These methods do not provide outliers upto 2 standard deviations or 95 percent of the data.

## Contributors
Satheesh Narasimman

## People who helped
- Khaled Karman, Bootcamp personal tutor
- Tee, Bootcamp classmate

## References
- https://machinelearningmastery.com/how-to-use-statistics-to-identify-outliers-in-data/

- https://www.kdnuggets.com/2017/02/removing-outliers-standard-deviation-python.html

- https://datatofish.com/replace-values-pandas-dataframe/

- https://www.geeksforgeeks.org/box-plot-using-plotly-in-python/

- https://plotly.com/python/px-arguments/

- https://www.postgresql.org/docs/8.0/functions-datetime.html

- https://mode.com/blog/postgres-sql-date-functions/

- https://popsql.com/learn-sql/postgresql/how-to-group-by-time-in-postgresql

- https://kb.objectrocket.com/postgresql/using-the-date_trunc-function-in-postgresql-1171
