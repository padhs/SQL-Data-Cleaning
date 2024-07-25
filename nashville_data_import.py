# import data from excel file to nashville_db
import time
import pandas as pd
import mysql.connector
import numpy as np


# load the dataset into pandas pd
df = pd.read_excel('./dataset/Nashville Housing Data for Data Cleaning.xlsx')
print(df.info())
# we get the columns and their datatypes it will be helpful while creating the table

# handling nulls:
'''
categorical_columns = [column for column in df.columns if df[column].dtype == object]
numerical_columns = [column for column in df.columns if df[column].dtype == np.float64]

print(categorical_columns)
for cat_col in categorical_columns:
    df[cat_col].replace(to_replace=np.nan, value=None, inplace=True)

for num_col in numerical_columns:
    df[num_col].replace(to_replace=np.nan, value=None, inplace=True)
'''

# handling nulls:
for with_nulls in df.columns:
    df[with_nulls].replace(to_replace=np.nan, value=None, inplace=True)

# check for any nulls ? Success --> No nulls remaining ---> proceed to SQL Data Cleaning
df.convert_dtypes()
print(df.info())

# establish connection to mysql db:

connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='password',
    database='nashville_db'
)
cursor = connection.cursor()

# Insert data into table from excel:
'''
We can import data into the table using one by one iteration from the dataset or insert data
in batches to improve performance. We'll do this. We'll need to convert the dataframe into list of tuples
'''
# convert df to [tuple]
data = [tuple(row) for row in df.itertuples(index=False, name=None)]
batch_size = 2000

start_time = time.time()
for start in range(0, len(data), batch_size):
    end = start + batch_size
    batch = data[start:end]
    insert_query = """
    INSERT INTO nashville (UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant,
                           OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, 
                           Bedrooms, FullBath, HalfBath)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    cursor.executemany(insert_query, batch)
    connection.commit()
# error: Some values have NaN. MySQL can't handle NaN values. So we need to handle those values before importing data.

# close the connection
cursor.close()
connection.close()

end_time = time.time()
print(f"Time Taken: {end_time - start_time} seconds")
# Check in MySQL workbench if data was successfully imported

'''
Cool. We have successfully migrated data from excel file to MySQL db.
'''