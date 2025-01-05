CREATE DATABASE RetailDB;
USE RetailDB;

CREATE TABLE RetailOrders (
Order_Id INT PRIMARY KEY AUTO_INCREMENT,
    Order_Date DATE,
    Ship_Mode VARCHAR(50),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Id VARCHAR(50),
    Quantity INT,
    Discount FLOAT,
    Sales_Price FLOAT,
    Profit FLOAT
);
-- ALTER TABLE RetailOrders ADD Order_Id INT PRIMARY KEY AUTO_INCREMENT;



use retaildb

Select * from RetailOrders;
desc RetailOrders;
select count(RetailOrders) from RetailOrders;
-- Questions
-- 1) top 10 higest reveue generating products
select product_id,round(sum(sales_price),3) as sales from RetailOrders 
group by product_id
order by sales_price desc limit 10;

-- 2) top 5 highest selling products in each region

SELECT 
    r.Region, 
    r.Product_Id, 
    SUM(r.Quantity) AS total_quantity,
    ROW_NUMBER() OVER (PARTITION BY r.Region ORDER BY SUM(r.Quantity) DESC) AS row_num
FROM RetailOrders r
GROUP BY r.Region, r.Product_Id
ORDER BY total_quantity DESC
LIMIT 5;

-- Are there any products being sold at a loss?
SELECT ProductName, SUM(SalesPrice - CostPrice) AS NetProfit
FROM SalesData
GROUP BY ProductName
HAVING NetProfit < 0;

-- How many unique products are sold in each region
SELECT Region, COUNT(DISTINCT ProductName) AS UniqueProducts
FROM SalesData
GROUP BY Region;

-- Which products have no sales recorded
SELECT ProductName
FROM Products
WHERE ProductName NOT IN (SELECT DISTINCT ProductName FROM SalesData);
-- Which products have a total sales price above the average
WITH AverageSales AS (
    SELECT AVG(SalesPrice * Quantity) AS AvgTotalSales FROM SalesData
)
SELECT ProductName, SUM(SalesPrice * Quantity) AS TotalSales
FROM SalesData, AverageSales
GROUP BY ProductName
HAVING TotalSales > AvgTotalSales;

 -- List all products sold below the average quantit
 WITH AverageQuantity AS (SELECT AVG(Quantity) AS AvgQuantity
    FROM SalesData)
SELECT ProductName, SUM(Quantity) AS TotalQuantity
FROM SalesData, AverageQuantity
GROUP BY ProductName
HAVING TotalQuantity < AvgQuantity;

-- Which cities generated the highest total revenue
SELECT City, SUM(SalesPrice * Quantity) AS TotalRevenue
FROM SalesData
GROUP BY City ORDER BY TotalRevenue DESC
LIMIT 10;
