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

-- Data cleaning checklist:

-- standardize date formats
-- populate property address data
-- break out address into city, state, etc.
-- There are Yes, No, Y, N change to either Yes/No or Y/N format
-- Remove duplicates
-- Delete unused columns

-- handling missing data: numerical: mean, mode, median || categorical: Random Sampling --> Better do this using Python.

-- Eyeballing data
SELECT *
FROM nashville;

-- standardize date formats: (Format: YYYY-MM-DD)
-- They're already in the format we want. No need to change. No nulls
SELECT nashville.UniqueID, nashville.SaleDate
FROM nashville
WHERE SaleDate IS NULL;

-- populate PropertyAddress:
SELECT nashville.UniqueID, nashville.PropertyAddress, nashville.OwnerName, nashville.OwnerAddress
FROM nashville
WHERE PropertyAddress IS NULL; -- COUNT: 29

-- nulls in PropertyAddress: ==> should show 29 ==> success
SELECT COUNT(*)
FROM nashville
WHERE PropertyAddress IS NULL;

SELECT nashville.OwnerAddress, nashville.PropertyAddress
FROM nashville
WHERE PropertyAddress IS NULL;
-- observation: OwnerAddress & PropertyAddress is same only OwnerAddress has ', TN' trailing substring.
-- Solution: Copy value in OwnerAddress and remove the trailing substring. Then populate PropertyAddresster
