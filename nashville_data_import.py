# import data from excel file to nashville_db

import pandas as pd
import mysql.connector

# load the dataset into pandas pd
df = pd.read_excel('./dataset/Nashville Housing Data for Data Cleaning.xlsx')
print(df.info())
# we get the columns and their datatypes it will be helpful while creating the table

# establish connection to mysql db:
connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='password',
    database='nashville_db'
)
cursor = connection.cursor()
