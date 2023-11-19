SELECT *
FROM Transactions

--In the Transactions table, there is a Sort Code field which contains dashes. We need to remove these so just have a 6 digit string 
UPDATE Transactions
SET SortCode = LEFT(REPLACE(SortCode, '-', ''), 6)

--Use the SWIFT Bank Code lookup table to bring in additional information about the SWIFT code and Check Digits of the receiving bank account
SELECT *
FROM SwiftCodes s
join Transactions t
on s.bank = t.bank


----Add a field for the Country Code
ALTER TABLE Transactions
ADD CountryID CHAR(2);

UPDATE Transactions
SET CountryID = 'GB';

--Create the IBAN as above
ALTER TABLE Transactions
ADD IBAN NVARCHAR(34);

UPDATE Transactions 
SET IBAN = CONCAT(
    CountryID, 
    CheckDigits, 
    SWIFTCode, 
    SortCode,
	Account_Number)
FROM Transactions t
JOIN SwiftCodes s ON s.bank = t.bank;


