CREATE DATABASE nashville_db;

USE nashville_db;

-- Database Schema:
-- step 1: We have excel file. Let's import data from dataset to the nashville_db
-- We'll use the MySQL workbench for this (need to convert Excel --> csv text file) -- Easy
-- Use Python to automate INSERT INTO TABLE query for each record -- Moderate (Let's use this)
-- Apache Spark: Create a JOB to Extract data from excel file into the nashville_db table -- Big Data

-- Create table as per the data info from df in python script
-- There are some null values in the dataset. Let's add default NULL to avoid errors

CREATE TABLE nashville(
    UniqueID INT NOT NULL,
    ParcelID VARCHAR(255) NOT NULL,
    LandUse VARCHAR(255),
    PropertyAddress VARCHAR(255) DEFAULT NULL,
    SaleDate DATE,
    SalePrice INT,
    LegalReference VARCHAR(255),
    SoldAsVacant VARCHAR(255),
    OwnerName VARCHAR(255) DEFAULT NULL,
    OwnerAddress VARCHAR(255) DEFAULT NULL,
    Acreage FLOAT DEFAULT NULL,
    TaxDistrict VARCHAR(255) DEFAULT NULL,
    LandValue INT DEFAULT NULL,
    BuildingValue INT DEFAULT NULL,
    TotalValue INT DEFAULT NULL,
    YearBuilt INT DEFAULT NULL,
    Bedrooms INT DEFAULT NULL,
    FullBath INT DEFAULT NULL,
    HalfBath INT DEFAULT NULL
);

-- Better way: create table in python script after all modifications of dataset and dynamically program dtypes.

