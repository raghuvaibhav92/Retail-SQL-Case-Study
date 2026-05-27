-- analyzing and data cleaning of product_inventory table
query1:-- retreiving data of product_inventory 
select * from product_inventory;
Actionoutput:200 row(s) returned
query2:-- CHANGING THE NAME OF COLUMN
alter table product_inventory
rename column ï»¿ProductID to productid;
Actionoutput:0 row(s) affected Records: 0  Duplicates: 0  Warnings: 0
query3:-- DUPLICATE CHECK
select *,
row_number() over(partition by productid,productname,category,stocklevel,price order by productid)
as duplicate_check from product_inventory;
Actionoutput:200 row(s) returned
query4:-- checking null values , blank and spaces for each column
select * from product_inventory
where productid is null
or trim(productid)='';
Actionoutput:0 row(s) returned
query5:select * from product_inventory
where ProductName is null
or trim(ProductName)='';
Actionoutput:0 row(s) returned
query6:select * from product_inventory
where Category is null
or trim(Category)='';
Actionoutput:0 row(s) returned
query7:select * from product_inventory
where StockLevel is null
or trim(StockLevel)='';
Actionoutput:0 row(s) returned
query8:select * from product_inventory
where Price is null
or trim(Price)='';
Actionoutput:0 row(s) returned
query9:finding outlier in price column if exist
select min(price),max(price) from product_inventory;
Actionoutput:1 row(s) returned(it has valid price range between 10 and 99,hence no outliers are present)
-- analyzing and data cleaning of customer_profile table
query10:-- retrieving data from customer_profile table
select * from customer_profile;
Actionoutput:1000 row(s) returned
query11:-- renaming to customerid
alter table customer_profile
rename column ï»¿CustomerID to customerid;
Actionoutput:0 row(s) affected Records: 0  Duplicates: 0  Warnings: 0
query12:-- checking null,blank and spaces in customer_profile table
 select * from customer_profile
 where customerid is null
 or trim(customerid)='';
 Actionoutput:0 row(s) returned
 query13:select * from customer_profile
 where Age is null
 or trim(Age)='';
 Actionoutput:0 row(s) returned
query14:select * from customer_profile
 where Gender is null
 or trim(Gender)='';
 Actionoutput:0 row(s) returned
 query15:select * from customer_profile
 where Location is null
 or trim(Location)='';
 Actionoutput:13 row(s) returned(here blank values are present)
 query16 -- Imputing blank values using mode
 SELECT Location, COUNT(*) AS cnt
FROM customer_profile
WHERE TRIM(Location) <> ''
GROUP BY Location
ORDER BY cnt DESC
LIMIT 1;
Actionoutput:1 row(s) returned
query17:-- updating blanks by imputing them with 'West'
set sql_safe_updates=0;
update customer_profile
set Location='West'
where Location='';
Actionoutput:13 row(s) affected Rows matched: 13  Changed: 13  Warnings: 0
query18:-- verify the updation
select * from customer_profile
 where Location is null
 or trim(Location)='';
 Actionoutput:0 row(s) returned
 query19:-- handling the outliers in age column
select min(Age),max(Age) from customer_profile;
Actionoutput:1 row(s) returned
query20:set sql_safe_updates=0;
update customer_profile
set Age=69
where Age=131;
Actionoutput:1 row(s) affected Rows matched: 1  Changed: 1  Warnings: 0
query21:-- changing the datatype of JoinDate column from text to date
select joinDate from customer_profile;
Actionoutput:1000 row(s) returned
query22:update customer_profile
set JoinDate=str_to_date(JoinDate,'%d/%m/%y')
where JoinDate regexp '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{1,2}$';
Actionoutput:1000 row(s) affected Rows matched: 1000  Changed: 1000  Warnings: 0
query23:--verify
select JoinDate from customer_profile;
Actionoutput:1000 row(s) returned
query24:alter table customer_profile
modify column JoinDate date;
Actionoutput:1000 row(s) affected Records: 1000  Duplicates: 0  Warnings: 0
-- analyzing and data cleaning of sales_transaction table
query25:select * from sales_transaction;
Actionoutput:2000 row(s) returned
query26:-- renaming column to transactionid
 alter table sales_transaction
 rename column ï»¿TransactionID to transactionid;
 Actionoutput:0 row(s) affected Records: 0  Duplicates: 0  Warnings: 0
 query27:-- checking duplicates
 select *,
 row_number() over(partition by transactionid,customerid,productid,quantitypurchased,transactiondate,price order by transactionid)
 as duplicates;
 Actionoutput:5002 row(s) returned
 query28:-- verifying the duplicates
 select transactionid
 from sales_transaction
 group by transactionid
 having count(transactionid)>1;
 Actionoutput:2 row(s) returned
query29:/*deleting the duplicates by creating a distinct new table from previous table 
and then dropping the previous table*/
 create table vaibhav as
 select distinct * from sales_transaction;
 Actionoutput:5000 row(s) affected Records: 5000  Duplicates: 0  Warnings: 0
 query30: drop table sales_transaction;
 Actionoutput:0 row(s) affected
query31:alter table vaibhav
 rename sales_transaction;
 Actionoutput:0 row(s) affected
query32:select * from sales_transaction;
Actionoutput:2000 row(s) returned
query33:-- checking null,blank and spaces in sales_transaction
 select * from sales_transaction
 where transactionid is null
 or trim(transactionid)='';
 Actionoutput:0 row(s) returned
query34:select * from sales_transaction
 where CustomerID is null
 or trim(CustomerID)='';
 Actionoutput:0 row(s) returned
query35:select * from sales_transaction
 where ProductID is null
 or trim(ProductID)='';
 Actionoutput:0 row(s) returned
 query36:select * from sales_transaction
 where QuantityPurchased is null
 or trim(QuantityPurchased)='';
 Actionoutput:0 row(s) returned
query37:select * from sales_transaction
 where TransactionDate is null
 or trim(TransactionDate)='';
 Actionoutput:0 row(s) returned
query38:select * from sales_transaction
 where Price is null
 or trim(Price)='';
 Actionoutput:0 row(s) returned
query39:-- checking for outliers if exist in sales_transaction table
 select min(QuantityPurchased),max(QuantityPurchased)  -- range from 1to4 shows normal behaviour unless business rule fix the value 
 from sales_transaction;
 Actionoutput:1 row(s) returned
 query40:select min(Price),max(Price) -- 9312 is significantly high value
 from sales_transaction;
 Actionoutput:1 row(s) returned
 query41:--finding the root cause
 select c.customerid,c.JoinDate,p.ProductName,p.Price,s.ProductID,s.QuantityPurchased,s.Price
 from customer_profile c inner join sales_transaction s
 on c.customerid=s.CustomerID inner join product_inventory p
 on p.productid=s.ProductID
 order by s.Price desc;
 Actionoutput:2000 row(s) returned
query42:-- updating value from 9312 to 93.12
set sql_safe_updates=0;
 update sales_transaction
 set Price=93.12
 where Price=9312;
 Actionoutput:20 row(s) affected Rows matched: 20  Changed: 20  Warnings: 0
 query43:-- veryfying the changes
  select ProductID,Price
 from sales_transaction
 order by Price desc;
 Actionoutput:2000 row(s) returned
query44:-- changing datatype from text to date of TransactionDate column
update sales_transaction
 set TransactionDate=str_to_date(TransactionDate,'%d/%m/%y')
 where TransactionDate regexp'^[0-9]{1,2}/[0-9]{1,2}/[0-9]{1,2}$';
 Actionoutput:5000 row(s) affected Rows matched: 5000  Changed: 5000  Warnings: 0
query45:select TransactionDate from sales_transaction;
Actionoutput:2000 row(s) returned
query46:alter table sales_transaction
 modify column TransactionDate date;
 Actionoutput:5000 row(s) affected Records: 5000  Duplicates: 0  Warnings: 0
query47:                                 /*INSIGHTS*/
 -- summarize the total sales and quantities sold per product by the company.
 select ProductID,sum(QuantityPurchased) as TotalUnitsSold,
 sum(QuantityPurchased*Price) as TotalSales
 from sales_transaction
 group by ProductID
 order by TotalSales desc;
 Actionoutput:200 row(s) returned
query48:-- count the number of transactions per customer to understand purchase frequency.
 select CustomerID,count(*) as NumberOfTransactions
 from sales_transaction
 group by CustomerID
 order by NumberOfTransactions desc;
 Actionoutput:989 row(s) returned
 query49:/*Evaluating the performance of the product categories based on the total sales 
 which help us understand the product categories which needs to be promoted in the marketing campaigns*/
 select p.Category,sum(s.QuantityPurchased) as TotalUnitsSold,
 sum(s.QuantityPurchased*s.Price) as TotalSales
 from sales_transaction s inner join product_inventory p
 on p.productid=s.ProductID
 group by p.Category
 order by TotalSales desc;
 Actionoutput:4 row(s) returned
 query50:--  top 10 products with the highest total sales revenue from the sales transactions
select ProductID,sum(QuantityPurchased*Price) as TotalRevenue
from sales_transaction
group by ProductID
order by TotalRevenue desc
limit 10;
Actionoutput:10 row(s) returned
query51:/*finding the ten products with the least amount of units sold from the sales transactions, 
provided that at least one unit was sold for those products*/
select ProductID,sum(QuantityPurchased) as TotalUnitsSold
from sales_transaction  
group by ProductID
having sum(QuantityPurchased)>1
order by TotalUnitsSold
limit 10;
Actionoutput:10 row(s) returned
query52:-- Identifying the sales trend to understand the revenue pattern of the company.
select Transactiondate as DATETRANS,count(*) as Transaction_count,
sum(QuantityPurchased) as TotalUnitsSold,round(sum(QuantityPurchased*Price),2) as TotalSales
from sales_transaction
group by TransactionDate
order by TransactionDate desc;
Actionoutput:209 row(s) returned
query53:/*month on month growth rate of sales of the company which will help 
understand the growth trend of the company*/
with cte as(
    select month(TransactionDate) as month,
    round(sum(QuantityPurchased*Price),2) as total_sales
    from sales_transaction
    group by month(TransactionDate)
)
select *,
lag(total_sales,1,null) over(order by month )
as previous_month_sales,
ROUND(((total_sales - LAG(total_sales) 
OVER (ORDER BY month)) / LAG(total_sales) 
OVER (ORDER BY month)) * 100, 2) AS mom_growth_percentage
from cte;
Actionoutput:7 row(s) returned
query54:/*Finding the number of transaction along with the total amount spent by each customer which are on the higher side 
and will help us understand the customers who are the high frequency purchase customers in the company*/
select CustomerID,count(*) as NumberOfTransactions,sum(QuantityPurchased*Price) as TotalSpent
from sales_transaction
group by CustomerID
having count(*)>10 and TotalSpent>1000
order by TotalSpent desc;
Actionoutput:18 row(s) returned
query55:/*describes the number of transaction along with the total amount spent by each customer, 
which will help us understand the customers who are occasional customers 
or have low purchase frequency in the company*/
select CustomerID,count(*) as NumberOfTransactions,sum(QuantityPurchased*Price) as TotalSpent
from Sales_transaction
group by CustomerID
having count(*)<=2
order by NumberOfTransactions asc,TotalSpent desc;
Actionoutput:130 row(s) returned
query56:/*describes the total number of purchases made by each customer against each productID 
to understand the repeat customers in the company*/
select CustomerID,ProductID,count(*) as TimesPurchased
from Sales_transaction
group by CustomerID,ProductID
having count(*)>1
order by  TimesPurchased desc;
Action:70 row(s) returned
query57:/*Describing the duration between the first and the last purchase of the customer 
in that particular company to understand the loyalty of the customer*/
select CustomerID,min(TransactionDate) as FirstPurchase,max(TransactionDate) as LastPurchase,
datediff(max(Transactiondate),min(TransactionDate)) as DaysbetweenPurchases
from sales_transaction
group by CustomerID
having DaysbetweenPurchases>0
order by DaysbetweenPurchases desc;
Actionoutput:950 row(s) returned
query58:/*customer segmentation based on the total quantity of products they have purchased.
 Also, counting the number of customers in each segment 
 which will help us target a particular segment for marketing*/
 with customer_segment as (
    select 
        c.Customerid,
        case
            WHEN sum(s.QuantityPurchased) between 1 and 10 then 'Low'
            WHEN SUM(s.QuantityPurchased) between 11 and 30 then 'Med'
            ELSE 'High'
        END AS CustomerSegment
    FROM customer_profile c
    INNER JOIN sales_transaction s
        ON c.CustomerID = s.CustomerID
    GROUP BY c.CustomerID
)
SELECT 
    CustomerSegment,
    COUNT(*) as num_cust
FROM customer_segment
GROUP BY CustomerSegment
order by CustomerSegment;
Actionoutput:3 row(s) returned










 
 























