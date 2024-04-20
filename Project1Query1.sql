-- Select all columns from 'Credit_card_transaction_flow' table and order by the 7th column
SELECT * 
FROM Project1..Credit_card_transaction_flow ORDER BY 7;;

-- Add a new column 'Federal_funds_rate' to the 'Credit_card_transaction_flow' table
ALTER TABLE Project1..Credit_card_transaction_flow
ADD Federal_funds_rate DECIMAL(18, 10);

-- (Ignore command) Dropped previous exsiting column "Federal_funds_rate DECIMAL(8, 0)" from Credit_card_transaction_flow to change DECIMAL(8, 0) to DECIMAL(18, 10)
ALTER TABLE Project1..Credit_card_transaction_flow
DROP COLUMN Federal_funds_rate;

-- Update the 'Federal_funds_rate' column in 'Credit_card_transaction_flow' with values from 'Federal_funds_effective_rate' in 'Federal_funds_rate' table where 'Federal_funds_rate' is NULL
UPDATE Project1..Credit_card_transaction_flow
SET Federal_funds_rate = t2.Federal_funds_effective_rate
FROM Project1..Credit_card_transaction_flow AS t1
JOIN Project1..Federal_funds_rate AS t2 ON t1.Date = t2.Observation_date
WHERE t1.Federal_funds_rate IS NULL;

-- Create new table "FFR_and_spending"
CREATE TABLE  Project1..FFR_and_spending (
    Full_name NVARCHAR(50),
    Gender NVARCHAR(50),
    Birthdate DATE,
	Transaction_date DATE,
    Transaction_amount DECIMAL(18, 10),
    Category NVARCHAR(50),
    Federal_funds_rate DECIMAL(18, 10)
);

-- Insert data into 'FFR_and_spending' table from 'Credit_card_transaction_flow'
INSERT INTO Project1..FFR_and_spending (Full_name, Gender, Birthdate, Transaction_date, Transaction_amount, Category, Federal_funds_rate)
SELECT CONCAT(Name, ' ', Surname) AS Full_name, Gender, BIrthdate, Date, Transaction_Amount, Category, Federal_funds_rate FROM Project1..Credit_card_transaction_flow;


-- Alter the data type of the 'Transaction_amount' column in 'FFR_and_spending' table to MONEY
ALTER TABLE Project1..FFR_and_spending
ALTER COLUMN Transaction_amount MONEY;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Select all columns from 'FFR_and_spending' table
SELECT * 
FROM Project1..FFR_and_spending;


-- Select the sum of transaction amounts grouped by gender from 'FFR_and_spending' table and order by gender
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

-- Select total transaction amount grouped by gender from 'Credit_card_transaction_flow' table
SELECT Gender, SUM(Transaction_amount) AS Total_amount
FROM Project1..Credit_card_transaction_flow
GROUP BY Gender;

-- Select average transaction amount by category from 'Credit_card_transaction_flow' table
SELECT Category, ROUND(AVG(Transaction_amount), 2) AS Avg_amount
FROM Project1..Credit_card_transaction_flow
GROUP BY Category;

-- Select total transaction amount grouped by year and month from 'Credit_card_transaction_flow' table
SELECT YEAR(date) AS Year, MONTH(date) AS Month, SUM(Transaction_amount) AS Total_amount
FROM Project1..Credit_card_transaction_flow
GROUP BY YEAR(date), MONTH(date)
ORDER BY Year, Month;

-- Select total transaction amount grouped by year, month, and month name from 'Credit_card_transaction_flow' table
SELECT YEAR(Date) AS Year, MONTH(date) AS Month_number, DATENAME(MONTH, Date) AS Month, SUM(Transaction_amount) AS Total_amount
FROM Project1..Credit_card_transaction_flow
GROUP BY YEAR(Date), DATENAME(MONTH, Date), MONTH(date)
ORDER BY Year, Month_number;

-- Select total debt and round it to 2 decimal places from 'Debt' table
SELECT Timeframe, ROUND(Total_trillions, 2) AS Total_debt
FROM Project1..Debt;

-- Select debt proportions and round them to 2 decimal places from 'Debt' table
SELECT Timeframe,
       ROUND(Mortgage_trillions / Total_trillions, 2) AS Mortgage_proportion,
       ROUND(HE_Revolving_trillions / Total_trillions, 2) AS HE_Revolving_proportion,
       ROUND(Auto_Loan_trillions / Total_trillions, 2) AS Auto_loans_proportion,
       ROUND(Credit_Card_trillions / Total_trillions, 2) AS Credit_card_proportion,
       ROUND(Student_Loan_trillions / Total_trillions, 2) AS Student_loan_proportion,
       ROUND(Other_trillions / Total_trillions, 2) AS Other_debt_proportion
FROM Project1..Debt;

-- Select delinquency rates and round them to 2 decimal places from 'Delinquency_rates' table
SELECT Time_Period,
       ROUND(Charge_off_rate_on_all_loans, 2) AS Charge_off_rate_on_all_loans,
       ROUND(Charge_off_rate_on_credit_card_loans, 2) AS Charge_off_rate_on_credit_card_loans,
       ROUND(Charge_off_rate_on_consumer_loans, 2) AS Charge_off_rate_on_consumer_loans
FROM Project1..Delinquency_rates;

-- Select Federal funds rate from 'Federal_funds_rate' table
SELECT Observation_date, Federal_funds_effective_rate
FROM Project1..Federal_funds_rate;