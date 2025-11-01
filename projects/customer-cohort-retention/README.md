# Customer Cohort Retention

This project analyzes customer retention behavior using cohort analysis based on first purchase date.  
Cohorts and retention rates are calculated using SQL (AdventureWorks2022), with results visualized as a heatmap in Excel.

---

## Project Structure

| Path                                       | Description                                                  |
|--------------------------------------------|--------------------------------------------------------------|
| `sql/customer_cohort_retention.sql`        | SQL script to calculate customer cohorts and retention rates |
| `excel/CustomerCohortRetention.xlsx`       | Excel file with pivot table and heatmap visualization        |
| `excel/cohort_heatmap.png`                 | Screenshot of the retention heatmap                          |
| `README.md`                                | Project-specific documentation                               |

---

## Overview

The SQL query [`customer_cohort_retention.sql`](./sql/customer_cohort_retention.sql) computes customer cohorts and retention rates using order history from the AdventureWorks2022 database.

The resulting data was exported and visualized in Excel.  
You can explore the final pivot-based heatmap in the file [`CustomerCohortRetention.xlsx`](./excel/CustomerCohortRetention.xlsx), which highlights retention trends across monthly cohorts.

The heatmap picture:
![Retention Heatmap](./excel/cohort_heatmap.png)

---

## Notes

- Analysis limited to the period: **July 2013 - June 2014**, due to stable and high customer volume.
- Source table: `Sales.SalesOrderHeader`
- Retention is calculated as:  
  `Active customers in month N / Total customers in cohort`

---
