-----ZADANIE 1-----
--Wykorzystuj¹c wyra¿enie CTE zbuduj zapytanie, które znajdzie informacje na temat stawki 
--pracownika oraz jego danych, a nastêpnie zapisze je do tabeli tymczasowej 
--TempEmployeeInfo. Rozwi¹¿ w oparciu o AdventureWorks.USE AdventureWorks2019;
-- First CTE table Paracownik with the field ID,PersonType and Imie_i_Nazwisko
WITH Pracownik (ID,PersonType,Imie_i_Nazwisko ) AS
(SELECT 
BusinessEntityID,
PersonType,
LastName + ' ' + FirstName
FROM Person.Person),
-- Second CTE table Staa with the fields ID and stawka

Staa(ID,stawka)AS
(SELECT
BusinessEntityID,
Rate
FROM HumanResources.EmployeePayHistory
),
-- Third CTE table Personal_Inf with the fields Stanowisko,Birthday and BusinessEntityID
Personal_Inf (Stanowisko,Birthday,BusinessEntityID) AS (
    SELECT 
  		JobTitle,
		BirthDate,
  		BusinessEntityID
    FROM HumanResources.Employee)
	--WHERE BusinessEntityID IS NOT NULL),
SELECT Pracownik.PersonType,Pracownik.Imie_i_Nazwisko,Staa.stawka,Personal_Inf.Stanowisko,Personal_Inf.Birthday
FROM Pracownik LEFT OUTER JOIN Staa
ON Pracownik.ID = Staa.ID
LEFT OUTER JOIN Personal_Inf
        ON Personal_Inf.BusinessEntityID = Staa.ID 
WHERE stawka IS NOT NULL
ORDER BY Imie_i_Nazwisko


-----ZADANIE 2---
--Uzyskaj informacje na temat przychodów ze sprzeda¿y wed³ug firmy i kontaktu (za pomoc¹ 
--CTE i bazy AdventureWorksL). Wynik powinien wygl¹daæ nastêpuj¹co:
USE AdventureWorksLT2019;
WITH CompanyC (CompanyContact,ID)
AS 
(SELECT CompanyName + ' (' + FirstName + ' ' + LastName + ')',
CustomerID
FROM SalesLT.Customer 
),
C_Revenue (Revenue, CustomerID)
AS
(SELECT
		TotalDue,
		CustomerID
	FROM SalesLT.SalesOrderHeader
)
SELECT CompanyC.CompanyContact,C_Revenue.Revenue
FROM CompanyC JOIN C_Revenue
ON C_Revenue.CustomerID = CompanyC.ID
ORDER BY CompanyContact

--SELECT *
--FROM SalesLT.Customer
--ORDER BY CompanyName

-----ZADANIE 3-----
--Napisz zapytanie, które zwróci wartoœæ sprzeda¿y dla poszczególnych kategorii produktów.
--Wykorzystaj CTE i bazê AdventureWorksLT.
USE AdventureWorksLT2019;
WITH Kategoria(Category,ID)AS
(SELECT 
Name,
ProductCategoryID
FROM SalesLT.ProductCategory),
Cena (SalesValue,SaID)AS
(SELECT 
LineTotal,
ProductID
FROM SalesLT.SalesOrderDetail)

SELECT Kategoria.Category, CAST(SUM(cena.SalesValue) AS money) AS SalesValue
FROM Kategoria INNER JOIN SalesLT.Product
ON Kategoria.ID = SalesLT.Product.ProductCategoryID
INNER JOIN Cena ON SalesLT.Product.ProductID= Cena.SaID
GROUP BY Kategoria.Category


-------------------------
SELECT *
FROM SalesLT.SalesOrderDetail
SalesOrderDetail.ProductID

SELECT *
FROM SalesLT.Product
SalesLT.Product.ProductID
SalesLT.Product.ProductCategoryID

SELECT *
FROM SalesLT.ProductCategory
SalesLT.ProductCategory.ProductCategoryID