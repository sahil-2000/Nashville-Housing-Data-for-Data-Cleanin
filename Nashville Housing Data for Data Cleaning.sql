use [portfolioProject]
select * from portfolioProject.dbo.Sheet1$

-- standardise date format

select SaleDate , convert(date,SaleDate)
from portfolioProject.dbo.Sheet1$

ALter table [dbo].[nashville_housing]
add SalesDateConverted date;

update portfolioProject.dbo.Sheet1$
set SalesDateConverted= convert(date,SaleDate)

select SalesDateConverted from portfolioProject.dbo.Sheet1$


--------------------------------------------------------------------------------------------------------------------------
-- populate property address data

select PropertyAddress 
from portfolioProject.dbo.Sheet1$
where PropertyAddress is null

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from  [dbo].[nashville_housing] a
join [dbo].[nashville_housing] b
on a.ParcelID=b.ParcelID
and a.UniqueID!=b.UniqueID

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[nashville_housing] a
JOIN [dbo].[nashville_housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
FROM [dbo].[nashville_housing]

ALter table [dbo].[nashville_housing]
add PropertySplitAddress nvarchar(255);

update [dbo].[nashville_housing]
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALter table [dbo].[nashville_housing]
add PropertySplitcity nvarchar(255);

update [dbo].[nashville_housing]
set PropertySplitcity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
select * from [dbo].[nashville_housing]



-- Easier way to do the above task

Select OwnerAddress
From [dbo].[nashville_housing]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [dbo].[nashville_housing]



ALTER TABLE [dbo].[nashville_housing]
Add OwnerSplitAddress Nvarchar(255);

Update [dbo].[nashville_housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [dbo].[nashville_housing]
Add OwnerSplitCity Nvarchar(255);

Update [dbo].[nashville_housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [dbo].[nashville_housing]
Add OwnerSplitState Nvarchar(255);

Update [dbo].[nashville_housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT SoldAsVacant ,
CASE WHEN SoldAsVacant ='Y' THEN 'Yes'
	 WHEN SoldAsVacant ='N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From [dbo].[nashville_housing]

UPDATE [dbo].[nashville_housing]
SET SoldAsVacant =CASE WHEN SoldAsVacant ='Y' THEN 'Yes'
	 WHEN SoldAsVacant ='N' THEN 'No'
	 ELSE SoldAsVacant
	 END


Select distinct(SoldAsVacant),count(SoldAsVacant)
From [dbo].[nashville_housing]
group by SoldAsVacant









---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [dbo].[nashville_housing]


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate