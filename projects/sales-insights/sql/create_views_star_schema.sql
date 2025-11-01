-- Uncomment if Schema not exists
/*
CREATE SCHEMA SalesInsights
GO
*/

-- Creating Sales Order Details fact
CREATE OR ALTER view SalesInsights.fct_SalesOrderDetails  AS (
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    soh.CustomerID,
    soh.SalesPersonID,
    sod.ProductID,
    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    sod.LineTotal AS Revenue,
    sod.OrderQty * sod.UnitPrice * sod.UnitPriceDiscount AS DiscountAmount
FROM 
    Sales.SalesOrderHeader AS soh
INNER JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
WHERE soh.[Status] = 5 --completed orders
)
GO

-- Creating Customer Dimension
CREATE OR ALTER view SalesInsights.dim_Customer AS (
SELECT 
    c.CustomerID,
    CASE WHEN c.StoreID IS NULL THEN 'Person'
         WHEN c.StoreID IS NOT NULL THEN 'Store' END AS CustomerType,
    t.[Group] AS TerritoryGroup,
    t.CountryRegionCode AS TerritoryCountry,
    t.[Name] AS TerritoryName,
    CASE WHEN c.PersonID IS NOT NULL THEN CONCAT(p.FirstName, ' ', p.LastName) 
         ELSE 'Unknown' END AS PersonName,
    COALESCE(s.[Name], 'Unknown') AS StoreName
FROM 
    Sales.Customer c
INNER JOIN 
    Sales.SalesTerritory t ON t.TerritoryID = c.TerritoryID 
LEFT JOIN 
    Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN 
    Sales.Store s ON c.StoreID = s.BusinessEntityID
)
GO

-- Creating Product Dimension
CREATE OR ALTER view SalesInsights.dim_Product AS (
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    COALESCE(p.Color,'Unknown') as Color,
    COALESCE(ps.[Name], 'Unknown') AS Subcategory,
    COALESCE(pc.[Name], 'Unknown') AS Category
FROM 
    Production.Product p
LEFT JOIN 
    Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN 
    Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
)
GO

-- Creating SalesPerson Dimension
CREATE OR ALTER view SalesInsights.dim_SalesPerson AS (
SELECT sp.BusinessEntityID as SalesPersonID,
       e.JobTitle, 
       e.Gender,
       e.MaritalStatus,
       DATEDIFF(year, BirthDate, HireDate) AS HiredAge,
       REPLACE(e.LoginID, 'adventure-works\', '') AS SelesPersonCode
FROM Sales.SalesPerson sp
INNER JOIN 
    HumanResources.Employee e ON e.BusinessEntityID = sp.BusinessEntityID
) 
GO

-- Creating Date Dimension 
WITH EdgeDates AS (
    SELECT  MIN(OrderDate) as minDate,
            MAX(OrderDate) as maxDate
    FROM Sales.SalesOrderHeader),
DateSeries AS (
    SELECT minDate as DateValue FROM EdgeDates
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateSeries
    WHERE DateValue <= (SELECT maxDate as DateValue FROM EdgeDates)
)
SELECT 
    DateValue,
    YEAR(DateValue) AS Year,
    MONTH(DateValue) AS Month,
    DATENAME(MONTH, DateValue) AS MonthName,
    DATEPART(QUARTER, DateValue) AS Quarter,
    DATENAME(WEEKDAY, DateValue) AS WeekdayName,
    DATEPART(WEEKDAY, DateValue) AS WeekdayNumber
INTO SalesInsights.dim_Date
FROM DateSeries
OPTION (MAXRECURSION 0) 
GO


