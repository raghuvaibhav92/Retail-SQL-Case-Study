-- ============================================================
--          RETAIL ANALYTICS CASE STUDY
-- ============================================================


-- ------------------------------------------------------------
-- SECTION 1: product_inventory — Analysis & Data Cleaning
-- ------------------------------------------------------------

-- Query 1: Retrieve all data from product_inventory
SELECT * FROM product_inventory;
-- Output: 200 row(s) returned


-- Query 2: Rename BOM-corrupted column to productid
ALTER TABLE product_inventory
    RENAME COLUMN ï»¿ProductID TO productid;
-- Output: 0 row(s) affected


-- Query 3: Duplicate check
SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY productid, productname, category, stocklevel, price
        ORDER BY productid
    ) AS duplicate_check
FROM product_inventory;
-- Output: 200 row(s) returned


-- Query 4: Null / blank check — productid
SELECT * FROM product_inventory
WHERE productid IS NULL
   OR TRIM(productid) = '';
-- Output: 0 row(s) returned


-- Query 5: Null / blank check — ProductName
SELECT * FROM product_inventory
WHERE ProductName IS NULL
   OR TRIM(ProductName) = '';
-- Output: 0 row(s) returned


-- Query 6: Null / blank check — Category
SELECT * FROM product_inventory
WHERE Category IS NULL
   OR TRIM(Category) = '';
-- Output: 0 row(s) returned


-- Query 7: Null / blank check — StockLevel
SELECT * FROM product_inventory
WHERE StockLevel IS NULL
   OR TRIM(StockLevel) = '';
-- Output: 0 row(s) returned


-- Query 8: Null / blank check — Price
SELECT * FROM product_inventory
WHERE Price IS NULL
   OR TRIM(Price) = '';
-- Output: 0 row(s) returned


-- Query 9: Outlier check on Price column
SELECT MIN(price), MAX(price) FROM product_inventory;
-- Output: 1 row(s) returned (valid price range 10–99; no outliers present)


-- ------------------------------------------------------------
-- SECTION 2: customer_profile — Analysis & Data Cleaning
-- ------------------------------------------------------------

-- Query 10: Retrieve all data from customer_profile
SELECT * FROM customer_profile;
-- Output: 1000 row(s) returned


-- Query 11: Rename BOM-corrupted column to customerid
ALTER TABLE customer_profile
    RENAME COLUMN ï»¿CustomerID TO customerid;
-- Output: 0 row(s) affected


-- Query 12: Null / blank check — customerid
SELECT * FROM customer_profile
WHERE customerid IS NULL
   OR TRIM(customerid) = '';
-- Output: 0 row(s) returned


-- Query 13: Null / blank check — Age
SELECT * FROM customer_profile
WHERE Age IS NULL
   OR TRIM(Age) = '';
-- Output: 0 row(s) returned


-- Query 14: Null / blank check — Gender
SELECT * FROM customer_profile
WHERE Gender IS NULL
   OR TRIM(Gender) = '';
-- Output: 0 row(s) returned


-- Query 15: Null / blank check — Location
SELECT * FROM customer_profile
WHERE Location IS NULL
   OR TRIM(Location) = '';
-- Output: 13 row(s) returned (blank values present)


-- Query 16: Find mode of Location to use for imputation
SELECT Location, COUNT(*) AS cnt
FROM customer_profile
WHERE TRIM(Location) <> ''
GROUP BY Location
ORDER BY cnt DESC
LIMIT 1;
-- Output: 1 row(s) returned


-- Query 17: Impute blank Location values with mode ('West')
SET sql_safe_updates = 0;
UPDATE customer_profile
SET Location = 'West'
WHERE Location = '';
-- Output: 13 row(s) affected


-- Query 18: Verify Location imputation
SELECT * FROM customer_profile
WHERE Location IS NULL
   OR TRIM(Location) = '';
-- Output: 0 row(s) returned


-- Query 19: Outlier check on Age column
SELECT MIN(Age), MAX(Age) FROM customer_profile;
-- Output: 1 row(s) returned


-- Query 20: Fix outlier Age value (131 → 69)
SET sql_safe_updates = 0;
UPDATE customer_profile
SET Age = 69
WHERE Age = 131;
-- Output: 1 row(s) affected


-- Query 21: Inspect JoinDate before type conversion
SELECT joinDate FROM customer_profile;
-- Output: 1000 row(s) returned


-- Query 22: Convert JoinDate from text (DD/MM/YY) to DATE
UPDATE customer_profile
SET JoinDate = STR_TO_DATE(JoinDate, '%d/%m/%y')
WHERE JoinDate REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{1,2}$';
-- Output: 1000 row(s) affected


-- Query 23: Verify JoinDate conversion
SELECT JoinDate FROM customer_profile;
-- Output: 1000 row(s) returned


-- Query 24: Change JoinDate column datatype to DATE
ALTER TABLE customer_profile
    MODIFY COLUMN JoinDate DATE;
-- Output: 1000 row(s) affected


-- ------------------------------------------------------------
-- SECTION 3: sales_transaction — Analysis & Data Cleaning
-- ------------------------------------------------------------

-- Query 25: Retrieve all data from sales_transaction
SELECT * FROM sales_transaction;
-- Output: 2000 row(s) returned


-- Query 26: Rename BOM-corrupted column to transactionid
ALTER TABLE sales_transaction
    RENAME COLUMN ï»¿TransactionID TO transactionid;
-- Output: 0 row(s) affected


-- Query 27: Duplicate check
SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY transactionid, customerid, productid,
                     quantitypurchased, transactiondate, price
        ORDER BY transactionid
    ) AS duplicates
FROM sales_transaction;
-- Output: 5002 row(s) returned


-- Query 28: Verify duplicate transaction IDs
SELECT transactionid
FROM sales_transaction
GROUP BY transactionid
HAVING COUNT(transactionid) > 1;
-- Output: 2 row(s) returned


-- Query 29: Create deduplicated table (distinct rows only)
CREATE TABLE vaibhav AS
    SELECT DISTINCT * FROM sales_transaction;
-- Output: 5000 row(s) affected


-- Query 30: Drop original table with duplicates
DROP TABLE sales_transaction;
-- Output: 0 row(s) affected


-- Query 31: Rename deduplicated table back to sales_transaction
ALTER TABLE vaibhav
    RENAME sales_transaction;
-- Output: 0 row(s) affected


-- Query 32: Confirm deduplication
SELECT * FROM sales_transaction;
-- Output: 2000 row(s) returned


-- Query 33: Null / blank check — transactionid
SELECT * FROM sales_transaction
WHERE transactionid IS NULL
   OR TRIM(transactionid) = '';
-- Output: 0 row(s) returned


-- Query 34: Null / blank check — CustomerID
SELECT * FROM sales_transaction
WHERE CustomerID IS NULL
   OR TRIM(CustomerID) = '';
-- Output: 0 row(s) returned


-- Query 35: Null / blank check — ProductID
SELECT * FROM sales_transaction
WHERE ProductID IS NULL
   OR TRIM(ProductID) = '';
-- Output: 0 row(s) returned


-- Query 36: Null / blank check — QuantityPurchased
SELECT * FROM sales_transaction
WHERE QuantityPurchased IS NULL
   OR TRIM(QuantityPurchased) = '';
-- Output: 0 row(s) returned


-- Query 37: Null / blank check — TransactionDate
SELECT * FROM sales_transaction
WHERE TransactionDate IS NULL
   OR TRIM(TransactionDate) = '';
-- Output: 0 row(s) returned


-- Query 38: Null / blank check — Price
SELECT * FROM sales_transaction
WHERE Price IS NULL
   OR TRIM(Price) = '';
-- Output: 0 row(s) returned


-- Query 39: Outlier check — QuantityPurchased
SELECT MIN(QuantityPurchased), MAX(QuantityPurchased)
FROM sales_transaction;
-- Output: 1 row(s) returned (range 1–4; normal behaviour)


-- Query 40: Outlier check — Price
SELECT MIN(Price), MAX(Price)
FROM sales_transaction;
-- Output: 1 row(s) returned (9312 is significantly high — investigate)


-- Query 41: Root-cause analysis for the Price outlier via joined tables
SELECT
    c.customerid,
    c.JoinDate,
    p.ProductName,
    p.Price           AS catalog_price,
    s.ProductID,
    s.QuantityPurchased,
    s.Price           AS transaction_price
FROM customer_profile c
    INNER JOIN sales_transaction s  ON c.customerid  = s.CustomerID
    INNER JOIN product_inventory  p ON p.productid   = s.ProductID
ORDER BY s.Price DESC;
-- Output: 2000 row(s) returned


-- Query 42: Fix data-entry error — 9312 → 93.12
SET sql_safe_updates = 0;
UPDATE sales_transaction
SET Price = 93.12
WHERE Price = 9312;
-- Output: 20 row(s) affected


-- Query 43: Verify Price correction
SELECT ProductID, Price
FROM sales_transaction
ORDER BY Price DESC;
-- Output: 2000 row(s) returned


-- Query 44: Convert TransactionDate from text (DD/MM/YY) to DATE
UPDATE sales_transaction
SET TransactionDate = STR_TO_DATE(TransactionDate, '%d/%m/%y')
WHERE TransactionDate REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{1,2}$';
-- Output: 5000 row(s) affected


-- Query 45: Verify TransactionDate conversion
SELECT TransactionDate FROM sales_transaction;
-- Output: 2000 row(s) returned


-- Query 46: Change TransactionDate column datatype to DATE
ALTER TABLE sales_transaction
    MODIFY COLUMN TransactionDate DATE;
-- Output: 5000 row(s) affected


-- ============================================================
--                        INSIGHTS
-- ============================================================

-- Query 47: Total sales and units sold per product
SELECT
    ProductID,
    SUM(QuantityPurchased)            AS TotalUnitsSold,
    SUM(QuantityPurchased * Price)    AS TotalSales
FROM sales_transaction
GROUP BY ProductID
ORDER BY TotalSales DESC;
-- Output: 200 row(s) returned


-- Query 48: Transaction count per customer (purchase frequency)
SELECT
    CustomerID,
    COUNT(*) AS NumberOfTransactions
FROM sales_transaction
GROUP BY CustomerID
ORDER BY NumberOfTransactions DESC;
-- Output: 989 row(s) returned


-- Query 49: Category performance by total sales
-- (identifies categories to prioritise in marketing campaigns)
SELECT
    p.Category,
    SUM(s.QuantityPurchased)            AS TotalUnitsSold,
    SUM(s.QuantityPurchased * s.Price)  AS TotalSales
FROM sales_transaction s
    INNER JOIN product_inventory p ON p.productid = s.ProductID
GROUP BY p.Category
ORDER BY TotalSales DESC;
-- Output: 4 row(s) returned


-- Query 50: Top 10 products by total revenue
SELECT
    ProductID,
    SUM(QuantityPurchased * Price) AS TotalRevenue
FROM sales_transaction
GROUP BY ProductID
ORDER BY TotalRevenue DESC
LIMIT 10;
-- Output: 10 row(s) returned


-- Query 51: Bottom 10 products by units sold (min 1 unit sold)
SELECT
    ProductID,
    SUM(QuantityPurchased) AS TotalUnitsSold
FROM sales_transaction
GROUP BY ProductID
HAVING SUM(QuantityPurchased) > 1
ORDER BY TotalUnitsSold ASC
LIMIT 10;
-- Output: 10 row(s) returned


-- Query 52: Daily sales trend (revenue pattern over time)
SELECT
    TransactionDate                           AS DateOfTransaction,
    COUNT(*)                                  AS TransactionCount,
    SUM(QuantityPurchased)                    AS TotalUnitsSold,
    ROUND(SUM(QuantityPurchased * Price), 2)  AS TotalSales
FROM sales_transaction
GROUP BY TransactionDate
ORDER BY TransactionDate DESC;
-- Output: 209 row(s) returned


-- Query 53: Month-on-month sales growth rate
WITH cte AS (
    SELECT
        MONTH(TransactionDate)                    AS month,
        ROUND(SUM(QuantityPurchased * Price), 2)  AS total_sales
    FROM sales_transaction
    GROUP BY MONTH(TransactionDate)
)
SELECT
    *,
    LAG(total_sales, 1, NULL) OVER (ORDER BY month) AS previous_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month))
        / LAG(total_sales) OVER (ORDER BY month) * 100,
        2
    ) AS mom_growth_percentage
FROM cte;
-- Output: 7 row(s) returned


-- Query 54: High-frequency, high-spend customers (>10 transactions AND >$1000 spent)
SELECT
    CustomerID,
    COUNT(*)                       AS NumberOfTransactions,
    SUM(QuantityPurchased * Price) AS TotalSpent
FROM sales_transaction
GROUP BY CustomerID
HAVING COUNT(*) > 10
   AND TotalSpent > 1000
ORDER BY TotalSpent DESC;
-- Output: 18 row(s) returned


-- Query 55: Low-frequency customers (≤2 transactions — occasional buyers)
SELECT
    CustomerID,
    COUNT(*)                       AS NumberOfTransactions,
    SUM(QuantityPurchased * Price) AS TotalSpent
FROM sales_transaction
GROUP BY CustomerID
HAVING COUNT(*) <= 2
ORDER BY NumberOfTransactions ASC, TotalSpent DESC;
-- Output: 130 row(s) returned


-- Query 56: Repeat purchases — customers who bought the same product more than once
SELECT
    CustomerID,
    ProductID,
    COUNT(*) AS TimesPurchased
FROM sales_transaction
GROUP BY CustomerID, ProductID
HAVING COUNT(*) > 1
ORDER BY TimesPurchased DESC;
-- Output: 70 row(s) returned


-- Query 57: Customer loyalty — days between first and last purchase
SELECT
    CustomerID,
    MIN(TransactionDate)                                   AS FirstPurchase,
    MAX(TransactionDate)                                   AS LastPurchase,
    DATEDIFF(MAX(TransactionDate), MIN(TransactionDate))   AS DaysBetweenPurchases
FROM sales_transaction
GROUP BY CustomerID
HAVING DaysBetweenPurchases > 0
ORDER BY DaysBetweenPurchases DESC;
-- Output: 950 row(s) returned


-- Query 58: Customer segmentation by total units purchased
-- (Low: 1–10 units | Med: 11–30 units | High: 31+ units)
WITH customer_segment AS (
    SELECT
        c.CustomerID,
        CASE
            WHEN SUM(s.QuantityPurchased) BETWEEN 1  AND 10 THEN 'Low'
            WHEN SUM(s.QuantityPurchased) BETWEEN 11 AND 30 THEN 'Med'
            ELSE 'High'
        END AS CustomerSegment
    FROM customer_profile c
        INNER JOIN sales_transaction s ON c.CustomerID = s.CustomerID
    GROUP BY c.CustomerID
)
SELECT
    CustomerSegment,
    COUNT(*) AS num_cust
FROM customer_segment
GROUP BY CustomerSegment
ORDER BY CustomerSegment;
-- Output: 3 row(s) returned
