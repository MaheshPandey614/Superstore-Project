--Veryfying dataschema

EXEC sp_help 'Customers';
EXEC sp_help 'Orders';     
EXEC sp_help 'Products';    
EXEC sp_help 'Order_Details'; 


-- Creating Indexex for faster customer lookups
CREATE INDEX idx_CustomerID ON Customers (Customer_ID);

-- Creating Indexex for faster order retrieval
CREATE INDEX idx_OrderID ON Orders (Order_ID);

-- Creating Indexex for faster product searches
CREATE INDEX idx_ProductID ON Products (Product_ID);


-- Total Revenue by year


SELECT YEAR(Order_Date) AS OrderYear, SUM(Sales) AS TotalRevenue
FROM Orders o
JOIN Order_Details od ON o.Order_ID = od.Order_ID
GROUP BY YEAR(Order_Date)
ORDER BY OrderYear;

-- Lifetime Value of Customer

SELECT c.Customer_Name, SUM(od.Sales) AS LifetimeValue
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Order_Details od ON o.Order_ID = od.Order_ID
GROUP BY c.Customer_Name
ORDER BY LifetimeValue DESC;

