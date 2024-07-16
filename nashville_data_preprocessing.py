# handle null values
import pandas as pd
import numpy as np

# read excel file
df = pd.read_excel('./dataset/Nashville Housing Data for Data Cleaning.xlsx')

print(df.info())
print(df.head())
print(df.isnull().sum())

# handle nulls:
categorical_columns = [column for column in df.columns if df[column].dtype == object]
numerical_columns = [column for column in df.columns if df[column].dtype == np.float64]

print(categorical_columns)
for cat_col in categorical_columns:
    df[cat_col].replace(to_replace=np.nan, value='NULL', inplace=True)

for num_col in numerical_columns:
    df[num_col].replace(to_replace=np.nan, value=0, inplace=True)

# check for any nulls ? Success --> No nulls remaining ---> proceed to SQL Data Cleaning
print(df.info())
