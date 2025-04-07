
-- Inserting data into Customers table

WITH UniqueCustomers AS (
    SELECT Customer_ID, Customer_Name, Segment, Country, City, State, Region, Postal_Code,
           ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Customer_Name) AS rn
    FROM SuperstoreData
)
INSERT INTO Customers (Customer_ID, Customer_Name, Segment, Country, City, State, Region, Postal_Code)
SELECT Customer_ID, Customer_Name, Segment, Country, City, State, Region, Postal_Code
FROM UniqueCustomers
WHERE rn = 1; -- Only keep one row per Customer_ID

-- Inserting data into Products table

WITH UniqueProducts AS (
    SELECT Product_ID, Product_Name, Category, Sub_Category,
           ROW_NUMBER() OVER (PARTITION BY Product_ID ORDER BY Product_Name) AS rn
    FROM SuperstoreData
)
INSERT INTO Products (Product_ID, Product_Name, Category, Sub_Category)
SELECT Product_ID, Product_Name, Category, Sub_Category
FROM UniqueProducts
WHERE rn = 1  -- Keeps only one row per Product_ID

-- Inserting data into Orders table


WITH UniqueOrders AS (
    SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID,
           ROW_NUMBER() OVER (PARTITION BY Order_ID ORDER BY Order_Date) AS rn
    FROM SuperstoreData
)
INSERT INTO Orders (Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID)
SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID
FROM UniqueOrders
WHERE rn = 1  -- Ensures only one row per Order_ID
AND Customer_ID IN (SELECT Customer_ID FROM Customers)  -- Ensures valid Customer_IDs


-- Inserting data into Order Details table

WITH UniqueOrderDetails AS (
    SELECT Order_ID, Product_ID, Quantity, Sales, Discount, Profit,
           ROW_NUMBER() OVER (PARTITION BY Order_ID, Product_ID ORDER BY Sales DESC) AS rn
    FROM SuperstoreData
)
INSERT INTO Order_Details (Order_ID, Product_ID, Quantity, Sales, Discount, Profit)
SELECT Order_ID, Product_ID, Quantity, Sales, Discount, Profit
FROM UniqueOrderDetails
WHERE rn = 1  -- Keeps one row per (Order_ID, Product_ID)
AND Order_ID IN (SELECT Order_ID FROM Orders)  -- Ensures valid Order_IDs
AND Product_ID IN (SELECT Product_ID FROM Products)  -- Ensures valid Product_IDs
AND NOT EXISTS (
    SELECT 1 FROM Order_Details od
    WHERE od.Order_ID = UniqueOrderDetails.Order_ID 
    AND od.Product_ID = UniqueOrderDetails.Product_ID
);  -- Prevents inserting duplicate (Order_ID, Product_ID) pairs