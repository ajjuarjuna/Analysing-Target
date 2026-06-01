# End-to-End SQL E-Commerce Data Analysis Project: Target Brazil (MSSQL Server)

## 📌 Project Overview
This project focuses on performing an **end-to-end data analysis** on a real-world e-commerce dataset containing **100,000+ orders** from **Target** (operational dataset based in Brazil) from **2016 to 2018**. 

The main objective of this project is to explore the data, extract deep analytical insights, and deliver actionable business recommendations to help Target optimize its operations, logistics, pricing strategy, payment management, and overall customer experience[cite: 1].

Unlike cloud environments, this entire project is built, managed, and queried locally using **Microsoft SQL Server (MSSQL) / SQL Server Management Studio (SSMS)**, showcasing optimized local database setup and data ingestion techniques.

---

## 📊 Database Schema & Dataset Structure
The dataset comprises **8 relational tables** linked via primary and foreign keys[cite: 1]:
1. `customers`: Details about customers (IDs, unique IDs, zip codes, city, state)[cite: 1].
2. `geolocation`: Spatial details (zip prefixes, latitude, longitude, city, state)[cite: 1].
3. `order_items`: Line-level items in orders (product ID, seller ID, price, freight/shipping value)[cite: 1].
4. `payments`: Payment metadata (type, sequence, installments, total value)[cite: 1].
5. `orders`: Order life cycle milestones (statuses, purchase times, approval times, delivery dates)[cite: 1].
6. `products`: Specifications of products sold (category name, description/name lengths, weight, dimensions)[cite: 1].
7. `sellers`: Registered seller locations and IDs[cite: 1].
8. `order_reviews`: Customer satisfaction data (review scores, timestamps, text)[cite: 1].

---

## 🎯 Business Problems Addressed & SQL Implementations

### 1. Exploratory Data Analysis (EDA)
* **Objective:** Establish the database schema, verify structural characteristics, and determine the temporal range of the dataset[cite: 1].
* **Key Finding:** The transaction history spans from **September 4, 2016, to October 17, 2018**[cite: 1].

### 2. In-Depth Orders & Seasonality Analysis
* **Objective:** Identify growing historical purchase trends, peak shopping hours, and monthly seasonality[cite: 1].
* **Key Finding:** **August** and **May** emerge as the peak performing months with the maximum volumes of orders[cite: 1]. Purchase frequency heavily spikes during the **afternoon and morning windows**[cite: 1].

### 3. Regional Evolution of E-Commerce
* **Objective:** Map customer geographic distribution across Brazil and analyze growth metrics by state[cite: 1].
* **Key Finding:** High demand clustering in primary economic zones, heavily dominated by states like **São Paulo (SP)** and **Rio de Janeiro (RJ)**[cite: 1].

### 4. Economic Impact & Revenue Dynamics
* **Objective:** Track financial movement, calculate Year-over-Year (YoY) revenue variations (Jan–Aug comparison for 2017 vs. 2018), and measure the ratio of item values vs. freight overheads[cite: 1].
* **Key Finding:** Comparing the identical January–August periods, Target's total order expenditure witnessed an explosive **growth rate of 136.98% from 2017 to 2018**[cite: 1].

### 5. Logistics, Shipping Costs & Delivery Performance
* **Objective:** Measure logistical efficiency by calculating actual delivery timelines (customer delivery date minus purchase date) and comparing actual performance vs. estimated delivery SLA dates[cite: 1].
* **Key Finding:** Revealed widespread regional discrepancies. Certain core states consistently beat delivery timelines, while peripheral regions suffer from high shipping friction and steeper freight charges[cite: 1].

### 6. Payment Behavior Insights
* **Objective:** Dissect month-on-month preferences across payment types (Credit Card, UPI/Boleto, Vouchers, etc.) and analyze consumer behavior surrounding installment usage[cite: 1].
* **Key Finding:** Single-installment plans dominate transactional volume, though installment schedules are heavily used to sustain high-ticket cart conversions[cite: 1].

---

## 🛠️ Tech Stack & Advanced SQL Techniques
* **Database Engine:** Microsoft SQL Server (MSSQL)
* **Interface Tool:** SQL Server Management Studio (SSMS)
* **Data Ingestion Tool:** `BULK INSERT` (T-SQL Engine)
* **SQL Mastery Demonstrated:**
  * **Window Functions:** Advanced calculations using functions like `LEAD()` over specific order groups[cite: 1].
  * **Date Manipulation:** Utilization of `DATEPART()`, `DATENAME()`, and `DATEDIFF()` to slice temporal metrics seamlessly.
  * **CTEs (Common Table Expressions):** Implemented for cleaner, human-readable, multi-step subqueries[cite: 1].
  * **Aggregations & Analytical Filtering:** Advanced multi-table `INNER JOIN` operations combined with strict conditional evaluation (`GROUP BY`, `HAVING`, `WHERE`)[cite: 1].

---

## 📈 Key Actionable Insights & Recommendations
* **Logistics Optimization:** Re-engineer partnerships and warehouse distribution nodes in high-freight, slow-delivery states to eliminate customer churn[cite: 1].
* **Ad Scheduling:** Concentrate performance marketing budgets and promotional alerts within the high-conversion **mid-day and afternoon windows**[cite: 1].
* **Inventory Readiness:** Elevate safety stock levels and onboarding of top sellers prior to the historical **May and August seasonal spikes**[cite: 1].

---

## 📁 Project Replication: Database Setup & Bulk Ingestion

To recreate this database locally, run the scripts in your SQL Server instance using the following blueprint:

### 1. Create the Database & Tables
Run your custom DDL scripts to set up the database and define individual tables with correct datatypes (`VARCHAR`, `INT`, `DATETIME2`, `DECIMAL`, etc.).

### 2. Ingest the Data via Bulk Insert
Use the highly efficient T-SQL `BULK INSERT` method to quickly load the massive raw CSV files directly into your tables from your local directory:

```sql
BULK INSERT target_ecommerce.dbo.orders
FROM 'C:\YourFilePath\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

