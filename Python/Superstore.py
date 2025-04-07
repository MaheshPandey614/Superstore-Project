import os
import pandas as pd
import urllib
from sqlalchemy import create_engine
from dotenv import load_dotenv

# Load environment variables
load_dotenv("C:/GitHub/Superstore/superstore.env")

# Retrieve values
host = os.getenv("SERVER")
database = os.getenv("DATABASE")
user = os.getenv("USER")
password = os.getenv("PASSWORD")

# Create connection string for SQL Server
params = urllib.parse.quote_plus(
    f"Driver={{ODBC Driver 17 for SQL Server}};"
    f"Server={host};"
    f"Database={database};"
    f"UID={user};"
    f"PWD={password};"
    "Encrypt=yes;"
    "TrustServerCertificate=no;"
    "Connection Timeout=30;"
)

# SQLAlchemy engine
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# Query data
df = pd.read_sql("SELECT * FROM orders", engine)
print(df.head())


query = """SELECT
    o.Order_ID,
    o.Order_Date,
    o.Ship_Date,
    o.Ship_Mode,
    c.Customer_ID,
    c.Customer_Name,
    c.Segment,
    c.Region,
    c.Country,
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Sub_Category,
    od.Quantity,
    od.Sales,
    od.Discount,
    od.Profit
FROM dbo.Orders o
JOIN dbo.Customers c ON o.Customer_ID = c.Customer_ID
JOIN dbo.Order_Details od ON o.Order_ID = od.Order_ID
JOIN dbo.Products p ON od.Product_ID = p.Product_ID
"""
df_full = pd.read_sql(query, engine)


# Structure and nulls
print(df_full.info())
print("\nMissing values:")
print(df_full.isnull().sum())

# Basic stats
print("\nDescriptive statistics:")
print(df_full.describe(include='all'))


sales_by_category = df_full.groupby("Category")["Sales"].sum().sort_values(ascending=False)

# Plot
import seaborn as sns
import matplotlib.pyplot as plt

sns.barplot(x=sales_by_category.values, y=sales_by_category.index)
plt.title("Total Sales by Category")
plt.xlabel("Sales")
plt.ylabel("Category")
plt.tight_layout()
plt.show()


profit_by_region = df_full.groupby("Region")["Profit"].sum().sort_values()

sns.barplot(x=profit_by_region.values, y=profit_by_region.index)
plt.title("Profit by Region")
plt.xlabel("Profit")
plt.ylabel("Region")
plt.tight_layout()
plt.show()


df_full["Order_Date"] = pd.to_datetime(df_full["Order_Date"])

monthly_sales = df_full.groupby(df_full["Order_Date"].dt.to_period("M"))["Sales"].sum()
monthly_sales.index = monthly_sales.index.to_timestamp()

monthly_sales.plot(figsize=(12, 6), title="Monthly Sales Trend", marker='o')
plt.xlabel("Month")
plt.ylabel("Total Sales")
plt.grid(True)
plt.tight_layout()
plt.show()


sns.scatterplot(data=df_full, x="Discount", y="Profit", hue="Category")
plt.title("Discount vs Profit by Category")
plt.grid(True)
plt.tight_layout()
plt.show()


