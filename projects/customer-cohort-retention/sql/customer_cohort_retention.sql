WITH CustomerFirstOrder AS (
    SELECT
        CustomerID,
        MIN(CONVERT(date, OrderDate)) AS FirstOrderDate,
        FORMAT(MIN(OrderDate), 'yyyy-MM') AS CohortMonth
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
    HAVING MIN(CONVERT(date, OrderDate)) >= '2013-05-01'
),
CustomerCohorts AS (
    SELECT
        cfo.CustomerID,
        cfo.CohortMonth,
        DATEDIFF(month, cfo.FirstOrderDate, CONVERT(date, so.OrderDate)) AS MonthIndex
    FROM CustomerFirstOrder cfo
    INNER JOIN Sales.SalesOrderHeader so ON cfo.CustomerID = so.CustomerID
),
CohortSummary AS (
    SELECT
        CohortMonth,
        MonthIndex,
        COUNT(DISTINCT CustomerID) AS CustomersActive
    FROM CustomerCohorts
    GROUP BY CohortMonth, MonthIndex
),
CohortSizes AS (
    SELECT
        CohortMonth,
        COUNT(DISTINCT CustomerID) AS CohortSize
    FROM CustomerFirstOrder
    GROUP BY CohortMonth
)
SELECT
    cs.CohortMonth,
    cs.MonthIndex,
    ROUND(CAST(cs.CustomersActive AS FLOAT) * 100 / csz.CohortSize, 3) AS RetentionRate
FROM CohortSummary cs
INNER JOIN CohortSizes csz ON cs.CohortMonth = csz.CohortMonth
ORDER BY cs.CohortMonth, cs.MonthIndex;
