-- Starting with Row Counts of all the 4 tables

SELECT 'Customers' AS Table_Name, COUNT(*) AS Row_Count FROM Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Order_Details', COUNT(*) FROM Order_Details;


-- Order Details Statsistical Summary

SELECT 
    COUNT(*) AS Total_Orders,
    MIN(Sales) AS Min_Sale,
    MAX(Sales) AS Max_Sale,
    AVG(Sales) AS Avg_Sale,
    MIN(Profit) AS Min_Profit,
    MAX(Profit) AS Max_Profit,
    AVG(Profit) AS Avg_Profit
FROM Order_Details;


-- Customer Analysis

-- Top 10 Customer by total spoend

SELECT TOP 10 c.Customer_Name, SUM(od.Sales) AS Total_Spend
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Order_Details od ON o.Order_ID = od.Order_ID
GROUP BY c.Customer_Name
ORDER BY Total_Spend DESC;

-- Tope 10 products by quantity

SELECT TOP 10 p.Product_Name, SUM(od.Quantity) AS Total_Quantity_Sold
FROM Products p
JOIN Order_Details od ON p.Product_ID = od.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Quantity_Sold DESC;


-- Total revenue by customer segments

SELECT c.Segment, SUM(od.Sales) AS Total_Revenue
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Order_Details od ON o.Order_ID = od.Order_ID  -- Corrected Join
GROUP BY c.Segment
ORDER BY Total_Revenue DESC;


-- Category wise sales & profits

SELECT p.Category, SUM(od.Sales) AS Total_Sales, SUM(od.Profit) AS Total_Profit
FROM Products p
JOIN Order_Details od ON p.Product_ID = od.Product_ID
GROUP BY p.Category
ORDER BY Total_Sales DESC;

-- Monthly Sales Trend

SELECT 
    FORMAT(o.Order_Date, 'MMM yyyy') AS Month, -- Corrected for SQL Server
    SUM(od.Sales) AS Total_Sales
FROM Orders o
JOIN Order_Details od ON o.Order_ID = od.Order_ID
GROUP BY FORMAT(o.Order_Date, 'MMM yyyy')
ORDER BY Month;


-- Yearly Sales growth % 

SELECT 
    YEAR(o.Order_Date) AS Year,
    SUM(od.Sales) AS Total_Sales,
    LAG(SUM(od.Sales)) OVER (ORDER BY YEAR(o.Order_Date)) AS Previous_Year_Sales,
    ((SUM(od.Sales) - LAG(SUM(od.Sales)) OVER (ORDER BY YEAR(o.Order_Date))) / 
     LAG(SUM(od.Sales)) OVER (ORDER BY YEAR(o.Order_Date))) * 100 AS Growth_Percentage
FROM Orders o
JOIN Order_Details od ON o.Order_ID = od.Order_ID
GROUP BY YEAR(o.Order_Date);

