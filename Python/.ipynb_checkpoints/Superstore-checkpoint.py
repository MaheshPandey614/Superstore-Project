
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from plotnine import ggplot, aes, geom_bar, geom_point, geom_line, labs, theme_minimal
from plotnine import *
from dotenv import load_dotenv
import os
import mysql.connector
from statsmodels.tsa.holtwinters import ExponentialSmoothing
import folium
from folium.plugins import HeatMap
import pyodbc


load_dotenv("C:/GitHub/Superstore/superstore.env")



# Retrieve credentials from .env file
SQL_SERVER = os.getenv("SERVER")
SQL_DATABASE = os.getenv("DATABASE")
SQL_USERNAME = os.getenv("USERNAME")
SQL_PASSWORD = os.getenv("PASSWORD")

# Define ODBC connection string for Azure SQL
conn_str = f"""
    DRIVER={{ODBC Driver 17 for SQL Server}};
    SERVER={SQL_SERVER};
    DATABASE={SQL_DATABASE};
    UID={SQL_USERNAME};
    PWD={SQL_PASSWORD};
    TrustServerCertificate=yes;
"""

try:
    # Establish connection
    conn = pyodbc.connect(conn_str)
    
    # Read SQL query into DataFrame
    query = "SELECT * FROM Superstore;"
    df = pd.read_sql(query, conn)

finally:
    conn.close()


df.head()