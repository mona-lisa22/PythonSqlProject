import pandas as pd
import mysql.connector

# Load the data
df = pd.read_csv(
    r"C:\Users\monalisa\Desktop\New folder\excel_files\Retail orders.csv",
    na_values=["Not Available", "unknown"])

# Data Cleaning and Transformation
print(df['Ship Mode'].unique()) #to find unique values in shipMode
df.columns = df.columns.str.replace(' ', '_')  # Replace spaces in column names
#new column
df['Discount'] = df['List_Price'] * df['Discount_Percent'] / 100
df['Sales_Price'] = df['List_Price'] - df['Discount']
df['Profit'] = df['Sales_Price'] - df['cost_price']
print(df.head(20).to_string())

# Parse Order_Date and ensure it's in the correct format
#df["Order_Date"] = pd.to_datetime(df["Order_Date"], format="%d/%m/%Y", errors="coerce")
#df['Order_Date'] = df['Order_Date'].dt.strftime('%Y-%m-%d')  # Format for MySQL

# Drop rows with invalid dates or missing important values
df = df.dropna(subset=['Ship_Mode'])
#print(df.head(20).to_string())
# Drop unnecessary columns
df.drop(columns=['Discount_Percent', 'cost_price', 'List_Price'], inplace=True)


# Align columns with the MySQL table schema
df = df[['Order_Date', 'Ship_Mode', 'Segment', 'Country', 'City', 'State', 'Postal_Code',
         'Region', 'Category', 'Sub_Category', 'Product_Id', 'Quantity', 'Discount',
         'Sales_Price', 'Profit']]

# MySQL Connection

connection = mysql.connector.connect(
        host='localhost',
        user='root',
        password='root',
        database='RetailDB'
    )
cur = connection.cursor()

# INSERT query
insert_query = """
        INSERT INTO RetailOrders (
            Order_Date, Ship_Mode, Segment, Country, City, State, Postal_Code, Region, 
            Category, Sub_Category, Product_Id, Quantity, Discount, Sales_Price, Profit
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
    """

# Convert DataFrame to list of tuples for batch insert
addtovalue = df.to_records(index=False).tolist()

# Batch insert into MySQL
cur.executemany(insert_query, addtovalue)
connection.commit()
print(f"{cur.rowcount} records inserted successfully!")

cur.close()

connection.close()
