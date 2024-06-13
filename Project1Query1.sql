-- Select all columns from 'Credit_card_transaction_flow' table and order by the 7th column (assumed to be Date or another relevant column)
SELECT * 
FROM Project1..Credit_card_transaction_flow 
ORDER BY 7;

-- Add a new column 'Federal_funds_rate' to the 'Credit_card_transaction_flow' table to store federal funds rate values
ALTER TABLE Project1..Credit_card_transaction_flow
ADD Federal_funds_rate DECIMAL(18, 10);

-- Drop the existing 'Federal_funds_rate' column from 'Credit_card_transaction_flow' to change its data type
ALTER TABLE Project1..Credit_card_transaction_flow
DROP COLUMN Federal_funds_rate;

-- Update the 'Federal_funds_rate' column in 'Credit_card_transaction_flow' with values from 'Federal_funds_effective_rate' in 'Federal_funds_rate' table where 'Federal_funds_rate' is NULL
UPDATE Project1..Credit_card_transaction_flow
SET Federal_funds_rate = t2.Federal_funds_effective_rate
FROM Project1..Credit_card_transaction_flow AS t1
JOIN Project1..Federal_funds_rate AS t2 
    ON t1.Date = t2.Observation_date
WHERE t1.Federal_funds_rate IS NULL;

-- Create a new table 'FFR_and_spending' to store detailed transaction data along with federal funds rate
CREATE TABLE  Project1..FFR_and_spending (
    Full_name NVARCHAR(50),
    Gender NVARCHAR(50),
    Birthdate DATE,
    Transaction_date DATE,
    Transaction_amount DECIMAL(18, 10),
    Category NVARCHAR(50),
    Federal_funds_rate DECIMAL(18, 10)
);

-- Insert data into 'FFR_and_spending' table from 'Credit_card_transaction_flow' table, concatenating first and last names
INSERT INTO Project1..FFR_and_spending (Full_name, Gender, Birthdate, Transaction_date, Transaction_amount, Category, Federal_funds_rate)
SELECT CONCAT(Name, ' ', Surname) AS Full_name, Gender, Birthdate, Date, Transaction_Amount, Category, Federal_funds_rate 
FROM Project1..Credit_card_transaction_flow;

-- Alter the data type of the 'Transaction_amount' column in 'FFR_and_spending' table to MONEY for better financial calculations
ALTER TABLE Project1..FFR_and_spending
ALTER COLUMN Transaction_amount MONEY;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Select all columns from 'FFR_and_spending' table for review
SELECT * 
FROM Project1..FFR_and_spending;

-- Select the sum of transaction amounts grouped by gender from 'FFR_and_spending' table, showing totals for each gender category
SELECT
    CASE 
        WHEN Gender = 'M' THEN 'M'
        WHEN Gender = 'F' THEN 'F'
        ELSE 'NA'
    END AS Gender,
    SUM(CASE WHEN Gender = 'M' THEN Transaction_amount ELSE 0 END) AS Male_Total,
    SUM(CASE WHEN Gender = 'F' THEN Transaction_amount ELSE 0 END) AS Female_Total,
    SUM(CASE WHEN Gender = 'NA' THEN Transaction_amount ELSE 0 END) AS NA_Total
FROM 
    Project1..FFR_and_spending
GROUP BY 
    CASE 
        WHEN Gender = 'M' THEN 'M'
        WHEN Gender = 'F' THEN 'F'
        ELSE 'NA'
    END
ORDER BY 1;

-- Calculate the percentage of transaction amounts by gender from 'FFR_and_spending' table
SELECT
    Gender,
    Male_Total,
    CAST(Male_Total * 100.0 / SUM(Male_Total + Female_Total + NA_Total) OVER () AS DECIMAL(10, 2)) AS Male_Percentage,
    Female_Total,
    CAST(Female_Total * 100.0 / SUM(Male_Total + Female_Total + NA_Total) OVER () AS DECIMAL(10, 2)) AS Female_Percentage,
    NA_Total,
    CAST(NA_Total * 100.0 / SUM(Male_Total + Female_Total + NA_Total) OVER () AS DECIMAL(10, 2)) AS NA_Percentage
FROM (
    SELECT
        CASE 
            WHEN Gender = 'M' THEN 'M'
            WHEN Gender = 'F' THEN 'F'
            ELSE 'NA'
        END AS Gender,
        SUM(CASE WHEN Gender = 'M' THEN Transaction_amount ELSE 0 END) AS Male_Total,
        SUM(CASE WHEN Gender = 'F' THEN Transaction_amount ELSE 0 END) AS Female_Total,
        SUM(CASE WHEN Gender = 'NA' THEN Transaction_amount ELSE 0 END) AS NA_Total
    FROM 
        Project1..FFR_and_spending
    GROUP BY 
        CASE 
            WHEN Gender = 'M' THEN 'M'
            WHEN Gender = 'F' THEN 'F'
            ELSE 'NA'
        END
) AS T
ORDER BY 1;

-- Select total transaction amount grouped by gender from 'Credit_card_transaction_flow' table to analyze spending by gender
SELECT Gender, SUM(Transaction_amount) AS Total_amount
FROM Project1..Credit_card_transaction_flow
GROUP BY Gender;

-- Select average transaction amount by category from 'Credit_card_transaction_flow' table for category-wise spending analysis
SELECT Category, ROUND(AVG(Transaction_amount), 2) AS Avg_amount
FROM Project1..Credit_card_transaction_flow
GROUP BY Category;

-- Select total transaction amount grouped by year and month from 'Credit_card_transaction_flow' table to analyze monthly spending trends
SELECT YEAR(date) AS Year, MONTH(date) AS Month, SUM(Transaction_amount) AS Total_amount
FROM Project1..Credit_card_transaction_flow
GROUP BY YEAR(date), MONTH(date)
ORDER BY Year, Month;

-- Select total transaction amount grouped by year, month, and month name from 'Credit_card_transaction_flow' table to get a clearer view of monthly spending
SELECT YEAR(Date) AS Year, MONTH(date) AS Month_number, DATENAME(MONTH, Date) AS Month, SUM(Transaction_amount) AS Total_amount
FROM Project1..Credit_card_transaction_flow
GROUP BY YEAR(Date), DATENAME(MONTH, Date), MONTH(date)
ORDER BY Year, Month_number;

-- Select total debt and round it to 2 decimal places from 'Debt' table to get an overview of total debt
SELECT Timeframe, ROUND(Total_trillions, 2) AS Total_debt
FROM Project1..Debt;

-- Select debt proportions and round them to 2 decimal places from 'Debt' table to understand the composition of total debt
SELECT Timeframe,
       ROUND(Mortgage_trillions / Total_trillions, 2) AS Mortgage_proportion,
       ROUND(HE_Revolving_trillions / Total_trillions, 2) AS HE_Revolving_proportion,
       ROUND(Auto_Loan_trillions / Total_trillions, 2) AS Auto_loans_proportion,
       ROUND(Credit_Card_trillions / Total_trillions, 2) AS Credit_card_proportion,
       ROUND(Student_Loan_trillions / Total_trillions, 2) AS Student_loan_proportion,
       ROUND(Other_trillions / Total_trillions, 2) AS Other_debt_proportion
FROM Project1..Debt;

-- Select delinquency rates and round them to 2 decimal places from 'Delinquency_rates' table to understand loan performance
SELECT Time_Period,
       ROUND(Charge_off_rate_on_all_loans, 2) AS Charge_off_rate_on_all_loans,
       ROUND(Charge_off_rate_on_credit_card_loans, 2) AS Charge_off_rate_on_credit_card_loans,
       ROUND(Charge_off_rate_on_consumer_loans, 2) AS Charge_off_rate_on_consumer_loans
FROM Project1..Delinquency_rates;

-- Select Federal funds rate from 'Federal_funds_rate' table to analyze the federal funds effective rates
SELECT Observation_date, Federal_funds_effective_rate
FROM Project1..Federal_funds_rate;

--------------------------------------------------------------------------------------------------------------------------------------

-- Select all columns from 'Federal_funds_rate' table to review all data
SELECT * 
FROM Project1..Federal_funds_rate;

-- Select all columns from 'Credit_card_transaction_flow' table and order by the 7th column (assumed to be Date or another relevant column)
SELECT * 
FROM Project1..Credit_card_transaction_flow 
ORDER BY 7;

-- Select all columns from 'Debt' table and order by the 1st column (Timeframe)
SELECT * 
FROM Project1..Debt 
ORDER BY 1;

-- Select all columns from 'Delinquency_rates' table to review all data
SELECT * 
FROM Project1..Delinquency_rates;

-- Add a new column 'quarter_column' to the 'Credit_card_transaction_flow' table to store quarter information
ALTER TABLE Project1..Credit_card_transaction_flow
ADD quarter_column VARCHAR(6);

-- Update the 'quarter_column' based on date conditions to categorize transactions by quarter
UPDATE Project1..Credit_card_transaction_flow
SET quarter_column = 
    CASE 
        WHEN Date >= '2023-01-01' AND Date <= '2023-03-31' THEN '2023Q1'
        WHEN Date >= '2023-04-01' AND Date <= '2023-06-30' THEN '2023Q2'
        WHEN Date >= '2023-07-01' AND Date <= '2023-09-30' THEN '2023Q3'
        WHEN Date >= '2023-10-01' AND Date <= '2023-12-31' THEN '2023Q4'
        ELSE NULL -- Handle dates outside of the specified ranges
    END;

-- Select data from 'Delinquency_rates' and 'Debt' tables where Time_Period and Timeframe match for correlation analysis
SELECT *
FROM Project1..Delinquency_rates AS Dr
JOIN Project1..Debt AS Dt
ON Dr.Time_Period = Dt.Timeframe;

-- Trim leading and trailing spaces from the 'Timeframe' column in 'Debt' table to ensure data consistency
UPDATE Project1..Debt
SET Timeframe = LTRIM(RTRIM(Timeframe));

-- Select Time_Period and its character count from 'Delinquency_rates' table to check for data consistency
SELECT Time_Period, LEN(Time_Period) AS character_count
FROM Project1..Delinquency_rates;

-- Remove ':' character from 'Timeframe' column in 'Debt' table to ensure data consistency
UPDATE Project1..Debt
SET Timeframe = REPLACE(Timeframe, ':', '');

-- Select Timeframe and its character count from 'Debt' table to verify changes
SELECT Timeframe, LEN(Timeframe) AS character_count
FROM Project1..Debt;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Select columns from multiple tables and join on matching conditions to analyze detailed financial data
SELECT Observation_date, Federal_funds_effective_rate, 
       CONCAT(Name, ' ', Surname) AS Full_name, 
       Gender, Birthdate, Transaction_Amount, Merchant_Name, Category, 
       Time_Period, Charge_off_rate_on_all_loans, 
       Charge_off_rate_on_loans_to_finance_agricultural_production, 
       Charge_off_rate_on_business_loans, 
       Charge_off_rate_on_loans_secured_by_real_estate, 
       Charge_off_rate_on_consumer_loans, 
       Charge_off_rate_on_single_family_residential_mortgages, 
       Charge_off_rate_on_lease_financing_receivables, 
       Charge_off_rate_on_credit_card_loans, 
       Charge_off_rate_on_other_consumer_loans, 
       Charge_off_rate_on_commercial_real_estate_loans_excluding_farmland, 
       Charge_off_rate_on_farmland_loans, 
       Mortgage_trillions, HE_Revolving_trillions, Auto_Loan_trillions, 
       Credit_Card_trillions, Student_Loan_trillions, Total_trillions
FROM Project1..Federal_funds_rate AS FFR
JOIN Project1..Credit_card_transaction_flow AS CT
    ON FFR.Observation_date = CT.Date 
JOIN Project1..Delinquency_rates AS DR
    ON CT.quarter_column = DR.Time_Period
JOIN Project1..Debt AS Dt
    ON DR.Time_Period = Dt.Timeframe
ORDER BY 1;
