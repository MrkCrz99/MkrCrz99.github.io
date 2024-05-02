-- Select all columns from 'Federal_funds_rate' table
SELECT * FROM Project1..Federal_funds_rate;

-- Select all columns from 'Credit_card_transaction_flow' table and order by the 7th column
SELECT * FROM Project1..Credit_card_transaction_flow ORDER BY 7;

-- Select all columns from 'Debt' table and order by the 1st column
SELECT * FROM Project1..Debt Order BY 1;

-- Select all columns from 'Delinquency_rates' table
SELECT * FROM Project1..Delinquency_rates;

-- Add a new column 'quarter_column' to the 'Credit_card_transaction_flow' table
ALTER TABLE Project1..Credit_card_transaction_flow
ADD quarter_column VARCHAR(6);

-- Update the 'quarter_column' based on date conditions
UPDATE Project1..Credit_card_transaction_flow
SET quarter_column = 
    CASE 
        WHEN Date >= '2023-01-01' AND Date <= '2023-03-31' THEN '2023Q1'
        WHEN Date >= '2023-04-01' AND Date <= '2023-06-30' THEN '2023Q2'
        WHEN Date >= '2023-07-01' AND Date <= '2023-09-30' THEN '2023Q3'
        WHEN Date >= '2023-10-01' AND Date <= '2023-12-31' THEN '2023Q4'
        ELSE NULL -- Add an else condition if needed
    END;

-- Select data from 'Delinquency_rates' and 'Debt' tables where Time_Period and Timeframe match
SELECT *
FROM PROJECT1..Delinquency_rates AS Dr
JOIN PROJECT1..Debt AS Dt
ON Dr.Time_Period = Dt.Timeframe;

-- Trim leading and trailing spaces from the 'Timeframe' column in 'Debt' table
UPDATE Project1..Debt
SET Timeframe = LTRIM(RTRIM(Timeframe));

-- Select Time_Period and its character count from 'Delinquency_rates' table
SELECT Time_Period, LEN(Time_Period) AS character_count
FROM Project1..Delinquency_rates;

-- Remove ':' character from 'Timeframe' column in 'Debt' table
UPDATE Project1..Debt
SET Timeframe = REPLACE(Timeframe, ':', '');

-- Select Timeframe and its character count from 'Debt' table
SELECT Timeframe, LEN(Timeframe) AS character_count
FROM Project1..Debt;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Select columns from multiple tables and join conditions
SELECT Observation_date, Federal_funds_effective_rate, CONCAT( Name, ' ', Surname) AS Full_name, Gender, Birthdate, Transaction_Amount, Merchant_Name, Category, Time_Period, Charge_off_rate_on_all_loans, Charge_off_rate_on_loans_to_finance_agricultural_production, Charge_off_rate_on_business_loans, Charge_off_rate_on_loans_secured_by_real_estate, Charge_off_rate_on_consumer_loans, Charge_off_rate_on_single_family_residential_mortgages, Charge_off_rate_on_lease_financing_receivables, Charge_off_rate_on_credit_card_loans, Charge_off_rate_on_other_consumer_loans, Charge_off_rate_on_commercial_real_estate_loans_excluding_farmland, Charge_off_rate_on_farmland_loans, Mortgage_trillions, HE_Revolving_trillions, Auto_Loan_trillions, Credit_Card_trillions, Student_Loan_trillions, Total_trillions
FROM PROJECT1..Federal_funds_rate AS FFR
JOIN PROJECT1..Credit_card_transaction_flow AS CT
ON FFR.Observation_date = CT.Date 
JOIN PROJECT1..Delinquency_rates AS DR
ON CT.quarter_column = DR.Time_Period
JOIN PROJECT1..Debt AS Dt
ON DR.Time_Period = Dt.Timeframe
ORDER BY 1;