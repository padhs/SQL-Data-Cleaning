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
-- Solution1: Copy value in OwnerAddress and remove the trailing substring. Then populate PropertyAddress

SELECT nashville.ParcelID, nashville.PropertyAddress
FROM nashville
WHERE PropertyAddress IS NULL;
-- solution2: check if there is more than 1 record for ParcelID. Check if it has PropertyAddress. Populate.

SELECT nashville.ParcelID, PropertyAddress
FROM nashville
WHERE ParcelID = '025 07 0 031.00';
-- This confirms, for the same value of ParcelID, there may be >1 records and they could have PropertyAddress mentioned.
-- Later we can check if they're same with OwnerAddress

SELECT original_table.ParcelID,
       original_table.PropertyAddress,
       new_table.ParcelID,
       new_table.PropertyAddress,
       IFNULL(original_table.PropertyAddress, new_table.PropertyAddress) as populated_table
FROM nashville as original_table
JOIN nashville as new_table ON original_table.ParcelID = new_table.ParcelID
AND original_table.UniqueID <> new_table.UniqueID
WHERE original_table.PropertyAddress IS NULL;

UPDATE nashville as original_table
JOIN nashville as new_table ON original_table.ParcelID = new_table.ParcelID
AND original_table.UniqueID <> new_table.UniqueID
SET original_table.PropertyAddress = IFNULL(original_table.PropertyAddress, new_table.PropertyAddress)
WHERE original_table.PropertyAddress IS NULL;
-- success. There are no more null values in PropertyAddress.

-- Address splitting into individual columns: (delimiter: ',')
SELECT nashville.PropertyAddress
FROM nashville;

SELECT SUBSTRING_INDEX(nashville.PropertyAddress, ',', 1) as area,
       SUBSTRING_INDEX(nashville.PropertyAddress, ',', -1) as city,
       PropertyAddress
FROM nashville;

ALTER TABLE nashville
ADD Area VARCHAR(255) DEFAULT NULL,
ADD City VARCHAR(255) DEFAULT NULL;

UPDATE nashville
SET Area = SUBSTRING_INDEX(nashville.PropertyAddress, ',', 1);

UPDATE nashville
SET nashville.City = SUBSTRING_INDEX(nashville.PropertyAddress, ',', -1);

SELECT nashville.Area, nashville.City, nashville.PropertyAddress
FROM nashville;

-- change Area & City column position:
ALTER TABLE nashville
MODIFY COLUMN City VARCHAR(255) AFTER LandUse;

ALTER TABLE nashville
MODIFY COLUMN Area VARCHAR(255) AFTER LandUse;

SELECT *
FROM nashville;

SELECT COUNT( Area = SUBSTRING_INDEX(nashville.OwnerAddress, ',', 1))
FROM nashville;
-- confirms that OwnerAddress <> PropertyAddress
-- we can also split area & city address for OwnerAddress


-- Reformat SoldAsVacant to Yes/No ==> Change Y to Yes & No to N
SELECT nashville.SoldAsVacant
FROM nashville;

SELECT COUNT(*)
FROM nashville
WHERE nashville.SoldAsVacant = 'Y';
-- Y & N are low in count. Change them to Yes & No respectively
SELECT DISTINCT(nashville.SoldAsVacant), COUNT(nashville.SoldAsVacant)
From nashville
GROUP By SoldAsVacant
ORDER BY 2; -- Shows the least values on top

Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From nashville; -- success. Y/N changed to Yes/No

UPDATE nashville
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
                        WHEN SoldAsVacant = 'N' THEN 'No'
                        ELSE SoldAsVacant
                        END;


-- Removing duplicates:
WITH RowNumCTE as (
    SELECT *, ROW_NUMBER() over (
        PARTITION BY nashville.ParcelID,
            nashville.PropertyAddress,
            nashville.SaleDate,
            nashville.SalePrice,
            nashville.LegalReference
        ORDER BY nashville.UniqueID) as row_num
    FROM nashville
)
SELECT *
    FROM RowNumCTE
    WHERE row_num > 1
    ORDER BY PropertyAddress;


-- Delete Unused Columns:
ALTER TABLE nashville
    DROP COLUMN OwnerAddress,
    DROP COLUMN TaxDistrict,
    DROP COLUMN SaleDate,
    DROP COLUMN PropertyAddress;