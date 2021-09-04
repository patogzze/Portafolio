-- Bringing all the data

Select *
From PortfolioProject.dbo.nash_housing

-- I am going to convert the data type of the column Saledate.

Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.nash_housing

Update nash_housing
SET SaleDate = CONVERT(Date,SaleDate)


-- Some data in the ParcellID and PropertyAddress columns are duplicated, with this query I am going to solve it.


Select *
From PortfolioProject.dbo.nash_housing
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.nash_housing a
JOIN PortfolioProject.dbo.nash_housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.nash_housing a
JOIN PortfolioProject.dbo.nash_housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Addres, city and state are in the same column. Im going to break out this data into individual columns. 


Select *
From PortfolioProject.dbo.nash_housing


Select OwnerAddress
From PortfolioProject.dbo.nash_housing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.nash_housing


ALTER TABLE nash_housing
Add OwnerseparatedAddress Nvarchar(255);


Update nash_housing
SET OwnerseparatedAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE nash_housing
Add OwnerseparatedCity Nvarchar(255);


Update nash_housing
SET OwnerseparatedCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE nash_housing
Add OwnerseparatedState Nvarchar(255);


Update nash_housing
SET OwnerseparatedState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


-- In the column SoldAsVacant I have 4 diferent options, so I am going to change Y and N to Yes and No.


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.nash_housing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.nash_housing


Update nash_housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- I am going to remove duplicates (I usually only use 'delete' when I create a presentation but not with the real information)

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.nash_housing

)
Delete
From RowNumCTE
Where row_num > 1

-- I will delete columns that I will not use

ALTER TABLE PortfolioProject.dbo.nash_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
