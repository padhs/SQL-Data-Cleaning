CREATE DATABASE nashville_db;

USE nashville_db;

-- Database Schema:
-- step 1: We have excel file. Let's import data from dataset to the nashville_db
-- We'll use the MySQL workbench for this (need to convert Excel --> csv text file) -- Easy
-- Use Python to automate INSERT INTO TABLE query for each record -- Moderate (Let's use this)
-- Apache Spark: Create a JOB to Extract data from excel file into the nashville_db table -- Big Data

-- Create table as per the data info from df in python script

CREATE TABLE nashville(
    UniqueID INT,
    ParcelID VARCHAR(255),
    LandUse VARCHAR(255),
    PropertyAddress VARCHAR(255),
    SaleDate DATE,
    SalePrice INT,
    LegalReference VARCHAR(255),
    SoldAsVacant VARCHAR(255),
    OwnerName VARCHAR(255),
    OwnerAddress VARCHAR(255),
    Acreage FLOAT,
    TaxDistrict VARCHAR(255),
    LandValue FLOAT,
    BuildingValue FLOAT,
    TotalValue FLOAT,
    YearBuilt FLOAT,
    Bedrooms FLOAT,
    FullBath FLOAT,
    HalfBath FLOAT
)