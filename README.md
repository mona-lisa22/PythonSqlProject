# Data cleaning and Transformation using Pandas

This project automates the process of importing retail data from a CSV file into a MySQL database. It handles data cleaning, transformation, and efficient insertion to prepare the data for analysis

**Read Data** : 
The script opens a file (CSV) that has information about orders, like products, prices, discounts, and dates.

**Data Cleaning and Transformation** :
Checks if all important data is there.
Fixes any missing or wrong values (e.g., filling blanks).
Simplifies column names to make them easier to work with (like replacing spaces with underscores). 

**Calculate Extra Information**:
Figures out how much discount was given on each product. 
Calculates the final price (after discount). 
Finds out the profit 

**Prepare for Database**: Removes unnecessary details. Ensures the data is in the right order to match the database table. 

**Save to Database**: Connects to a MySQL database . 
Inserts all the cleaned-up and calculated data into the database.

**Technologies** 
- > Python (Pandas Library for data cleaning and transformation) 
- > MySQL (communication between Python and MySQL)
