
-- Creating tables Customers, Orders, Products, Order Details to creat e a relational database replacing the long datatable SuperstoreData

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID VARCHAR(50) PRIMARY KEY,
    Customer_Name NVARCHAR(255),
    Segment NVARCHAR(50),
    Country NVARCHAR(100),
    City NVARCHAR(100),
    State NVARCHAR(100),
    Region NVARCHAR(50),
    Postal_Code NVARCHAR(20)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID VARCHAR(50) PRIMARY KEY,
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode NVARCHAR(50),
    Customer_ID VARCHAR(50),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);


DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    Product_ID VARCHAR(50) PRIMARY KEY,
    Product_Name NVARCHAR(500),
    Category NVARCHAR(50),
    Sub_Category NVARCHAR(50)
);

DROP TABLE IF EXISTS Order_Details;
CREATE TABLE Order_Details (
    Order_ID VARCHAR(50),
    Product_ID VARCHAR(50),
    Quantity INT,
    Sales DECIMAL(12,2),
    Discount DECIMAL(5,2),
    Profit DECIMAL(12,2),
    PRIMARY KEY (Order_ID, Product_ID),  -- Composite Primary Key
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

