# Retail SQL Case Study 📊

## 📌 Project Overview
This project is an end-to-end **SQL-based retail analytics case study** focused on cleaning, transforming, 
and analyzing retail data to generate meaningful business insights.  
The analysis simulates real-world retail scenarios involving products, customers, 
and sales transactions using **MySQL**.

The project demonstrates practical SQL skills such as data cleaning, handling inconsistencies, 
and performing analytical 
queries to support business decision-making.

---

## 🗂️ Datasets Used
The case study is based on three relational tables:

### 1. Product Inventory
- ProductID  
- ProductName  
- Category  
- StockLevel  
- Price  

### 2. Customer Profile
- CustomerID  
- Age  
- Gender  
- Location  
- JoinDate  

### 3. Sales Transaction
- TransactionID  
- CustomerID  
- ProductID  
- QuantityPurchased  
- TransactionDate  
- Price  

---

## 🧹 Data Cleaning & Preparation
The following data quality issues were identified and resolved using SQL:

- Renamed incorrectly formatted column names
- Checked and handled duplicate records
- Identified and fixed null, blank, and invalid values
- Imputed missing customer locations using the mode
- Corrected outliers in:
  - Customer age
  - Product pricing
- Converted text-based date columns to proper DATE format
- Removed duplicate sales transactions

These steps ensured the data was consistent, accurate, and analysis-ready.

---

## 📈 Business Questions Answered
The analysis answers key business and analytical questions such as:

- What are the total units sold and total revenue per product?
- Which customers purchase most frequently?
- Which product categories generate the highest sales?
- What are the top-performing and least-performing products?
- How do sales trend over time (daily and monthly)?
- What is the month-on-month sales growth?
- Who are the high-value customers?
- Which customers are low-frequency buyers?
- Which customers show repeat purchase behavior?
- How loyal are customers based on first and last purchase dates?
- How can customers be segmented based on purchase quantity?

---

## 🧠 Key Insights
- A small group of customers contributes significantly to total revenue
- Certain product categories consistently outperform others
- Pricing and data-entry errors can heavily impact revenue analysis if not corrected
- The majority of customers fall into low or medium purchase segments
- Clear sales trends and seasonality patterns are observable over time
- Customer segmentation enables targeted marketing strategies

---

## 🛠️ Tools & Technologies
- **MySQL**
- SQL (DDL, DML, Joins, CTEs, Window Functions)
- Data Cleaning & Exploratory Data Analysis (EDA)

---

## 📂 Repository Structure
```text
Retail-SQL-Case-Study/
│
├── Case Study@retail analytics.sql   # Complete SQL script
├── README.md                         # Project documentation
