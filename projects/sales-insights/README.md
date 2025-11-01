# Sales Insights

This project showcases a Power BI report based on AdventureWorks2022 data, with a custom star schema built in SQL Server and analytical dashboards developed using DAX.

---

## Project Structure

| Path                          | Description                                      |
|-------------------------------|--------------------------------------------------|
| `sql/create_views_star_schema.sql` | SQL script to create star schema views in SQL Server |
| `powerbi/Sales Insights.pbix`     | Power BI report file with embedded data         |
| `powerbi/Sales_Overview_Dashboard.png` | Screenshot of the sales performance dashboard   |
| `powerbi/Product_ABC_Analysis_Dashboard.png` | Screenshot of the ABC analysis dashboard       |
| `README.md`                    | Project-specific documentation                   |

---

## Report Pages Overview

### Sales Performance Dashboard

- KPIs: Revenue, Orders, Discounts
- Revenue distribution by Customer Type 
- Monthly revenue trend (last selected year only)
- Geographic breakdown (map)
- Year slicer for filtering

![Sales Overview](./powerbi/Sales_Overview_Dashboard.png)

### Product ABC Analysis Dashboard

- ABC product category slicer (DAX-based)
- Top-Selling products by category
- Revenue breakdown by Product Type
- Product Subcategory dynamic table
- Top Sales Persons

![Product ABC](./powerbi/Product_ABC_Analysis_Dashboard.png)

---

## How to Open an interactive Dashboard

1. Install [Power BI Desktop](https://powerbi.microsoft.com/en-us/desktop/)
2. Download and open .pbix file: `powerbi/Sales Insights.pbix`
3. All necessary data is embedded - no SQL Server connection required

---

## Tools Used

- Microsoft SQL Server 2022 (T-SQL views)
- Power BI Desktop 
- DAX for KPIs, ABC logic, and time filtering

---
