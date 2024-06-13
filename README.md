# MkrCrz99.github.io

Project Title: Exploring Financial Trends and Consumer Behavior

1. Introduction:

I aimed to analyze financial data to understand trends in transaction behavior, debt distribution, and delinquency rates throughout 2023, considering the federal funds rate. By utilizing SQL queries and Power BI visualization, my analysis provided insights into critical aspects of the financial landscape, facilitating strategic planning and decision-making.

2. SQL Queries:

Query 1: Data Preparation and Transformation

Selecting and Ordering Data: I retrieved all columns from the 'Credit_card_transaction_flow' table and ordered them by the 7th column.

Adding a New Column: I added a new column called 'Federal_funds_rate' to the 'Credit_card_transaction_flow' table to store federal funds rates.

Updating Column Values: I updated the 'Federal_funds_rate' column in the 'Credit_card_transaction_flow' table with values from the 'Federal_funds_effective_rate' table where the 'Federal_funds_rate' was null.

Creating a New Table: I created a new table named 'FFR_and_spending' to store data from the 'Credit_card_transaction_flow' table along with additional fields.

Inserting Data: I inserted data into the 'FFR_and_spending' table from the 'Credit_card_transaction_flow' table after transforming and combining relevant columns.

Altering Data Types: I altered the data type of the 'Transaction_amount' column in the 'FFR_and_spending' table to the MONEY data type for better representation.

Query 2: Data Integration and Analysis

Data Retrieval and Joins: I retrieved data from multiple tables, including 'Federal_funds_rate', 'Credit_card_transaction_flow', 'Delinquency_rates', and 'Debt', and joined them based on common attributes.

Data Cleaning and Transformation: I performed various data cleaning operations, such as adding a new column 'quarter_column' to the 'Credit_card_transaction_flow' table based on date conditions, trimming leading and trailing spaces, and removing special characters from the 'Timeframe' column in the 'Debt' table.

Analytical Queries: I calculated total transaction amounts by gender, average transaction amounts by category, total debt amounts, debt proportions, and delinquency rates.

Visualization Preparation: The processed data was then ready to be visualized in Power BI for further analysis and insights generation.

Overall, the SQL queries I wrote enabled data preparation, integration, and analysis, laying the foundation for insightful visualization and interpretation of financial trends and consumer behavior. The process involved addressing various challenges related to data quality and consistency, as well as implementing advanced techniques such as dynamic column creation and data type conversions. If I had more time, I would have explored advanced analytics techniques and further enhanced the visualization to provide deeper insights into the data.

3. Analysis Highlights:

Transaction Analysis:
Examined transaction amounts by gender and merchant category.
Investigated monthly transaction trends over time.

Debt Analysis:
Analyzed total debt trends and proportions of different debt types.
Explored delinquency rates across various loan categories.

Interest Rate Analysis:
Tracked trends in the federal funds rate over time in relation to delinquency rates, average spending, and average debt.

4. PowerBI Visualization:

I created a Power BI dashboard to visually represent the insights derived from the SQL queries. The dashboard included interactive charts and graphs to showcase transaction trends, debt distribution, and delinquency rates.

When comparing the average transaction rate data and federal funds rate, there was no clear correlation between the two. This can be associated with the limited amount of data used. However, the queries used can still be applied in further analysis. A more appropriate dataset should contain a larger range of years and a randomized set of transaction data from the targeted population.

An analysis was performed to compare transaction amounts between genders, as well as categories. There's a small indication that females spent more than males in general transactions, but the discrepancy is not large enough to draw a definitive conclusion. However, there is a clear indication that the largest contributor to total transactions was travel-related expenses while restaurant-related spending was the smallest contributor.

5. Conclusions:

The project provided valuable insights into financial trends and consumer behavior. By leveraging SQL queries and Power BI visualization, my analysis shed light on critical aspects of the financial landscape, paving the way for further exploration and strategic planning.

The data did not indicate a significant change in transaction amounts over time, but it did show notable variations across merchant categories.
A significant portion of debt was attributed to mortgage debt, with higher delinquency rates among credit card and consumer loans.
Observed fluctuations in the federal funds rate in relation to average total charge-off rates, which could indicate an inability to pay off loans with higher interest rates.

6. Challenges:

Data cleaning and preprocessing posed challenges due to inconsistencies and missing values in the datasets, necessitating meticulous validation and verification processes. Query optimization was required to handle large volumes of data efficiently, ensuring timely and accurate analysis. Ensuring data accuracy and integrity required thorough validation and verification processes.

7. Cool Techniques:

Utilizing CASE statements and aggregation functions in SQL queries enabled the derivation of meaningful insights from the data, facilitating deeper analysis. Dynamic filters and slicers in Power BI empowered interactive exploration of the data, enhancing user engagement and understanding. Integration with other tools in Power BI by combining SQL Server was useful for advanced analytics.

8. Future Work:

Further analysis could delve into specific loan categories to understand underlying factors contributing to delinquency rates, providing actionable insights for risk management. Incorporating external economic indicators, such as unemployment rates or GDP growth, could enrich the analysis, offering a more holistic view of financial trends and their drivers. Exploring predictive modeling techniques, such as machine learning algorithms, could help forecast future transaction patterns and debt trends, supporting proactive decision-making and risk mitigation strategies.

Overall, my project showcased the power of data-driven analysis in uncovering valuable insights into financial trends and consumer behavior, laying the groundwork for future exploration and innovation.

Sources:

Federal Funds Effective Rate: St. Louis Fed (https://fred.stlouisfed.org/series/DFF)

Charge-Off and Delinquency Rates on Loans and Leases at Commercial Banks: Federal Reserve (https://www.federalreserve.gov/releases/chargeoff/delallsa.htm)

Household Debt and Credit Report: New York Fed (https://www.newyorkfed.org/microeconomics/hhdc)

Comprehensive Credit Card Transactions Dataset: Kaggle (https://www.kaggle.com/datasets/rajatsurana979/comprehensive-credit-card-transactions-dataset?select=credit_card_transaction_flow.csv)
