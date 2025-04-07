
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
