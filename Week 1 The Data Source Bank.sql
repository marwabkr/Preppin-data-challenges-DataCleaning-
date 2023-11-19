SELECT *
FROM PD_2023_Wk
----Split the Transaction Code to extract the letters at the start of the transaction code
SELECT 
    PARSENAME(REPLACE(transaction_code, '-', '.'), 4) AS Part1
FROM PD_2023_Wk;
----Rename the new field with the Bank code 'Bank' 
ALTER TABLE PD_2023_Wk
ADD bank NVARCHAR(255);

UPDATE PD_2023_Wk
SET bank = PARSENAME(REPLACE(transaction_code, '-', '.'), 4);

----Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values
ALTER TABLE PD_2023_Wk
ADD UpdatedOnlineOrInPerson VARCHAR(50);

UPDATE PD_2023_Wk
SET UpdatedOnlineOrInPerson =
CASE 
WHEN Online_or_In_Person = 1 THEN 'Online'
WHEN Online_or_In_Person = 2 THEN 'In-Person' END 

----Change the date to be the day of the week 
SELECT DATENAME(WEEKDAY, Transaction_Date) AS WeekDay
FROM PD_2023_Wk;

ALTER TABLE PD_2023_Wk
ADD WeekDay VARCHAR(50);

UPDATE PD_2023_Wk
SET WeekDay =DATENAME(WEEKDAY, Transaction_Date)

----Total Values of Transactions by each bank
SELECT SUM(Value) AS Total,bank
FROM PD_2023_Wk
group by bank
order by total desc
----Total Values by Bank, Day of the Week and Type of Transaction
SELECT SUM(Value) AS Total,bank,WeekDay,UpdatedOnlineOrInPerson
FROM PD_2023_Wk
group by bank,WeekDay,UpdatedOnlineOrInPerson
order by total desc
----Total Values by Bank and Customer Code
SELECT SUM(Value) AS Total,bank,Customer_Code
FROM PD_2023_Wk
group by bank,Customer_Code
order by total desc