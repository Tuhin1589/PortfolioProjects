Select * 
from NashvilleHousing

-- Standarizing the date format

Select SaleDate,CONVERT(date,saledate)
from NashvilleHousing

Update	NashvilleHousing
SET SaleDate=CONVERT(date,saledate)

ALTER TABLE	NashvilleHousing
add SaleDateConverted date;

Update	NashvilleHousing
SET SaleDateConverted=CONVERT(date,saledate)

Select SaleDateConverted,CONVERT(date,saledate)
from NashvilleHousing

--Populating Property address

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.propertyaddress,b.PropertyAddress)
from NashvilleHousing as a
Join NashvilleHousing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
--order by ParcelID

update a
SET a.PropertyAddress=ISNULL(a.propertyaddress,b.PropertyAddress)
from NashvilleHousing as a
Join NashvilleHousing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Select * 
from NashvilleHousing

-- Breaking out address into individual columns

select PropertyAddress,
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as City
from [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE	NashvilleHousing
add Address Nvarchar(255)

ALTER TABLE	NashvilleHousing
add City varchar(255)

Update	NashvilleHousing
SET Address= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Update	NashvilleHousing
SET City= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

Select * 
from NashvilleHousing

exec sp_rename 'NashvilleHousing.address','PropertySplitAddress','Column'
exec sp_rename 'NashvilleHousing.city','PropertySplitCity','Column'

Select OwnerAddress
from NashvilleHousing

Select 
PARSENAME(Replace(ownerAddress,',','.'),3),
PARSENAME(Replace(ownerAddress,',','.'),2),
PARSENAME(Replace(ownerAddress,',','.'),1)
from NashvilleHousing

ALTER TABLE	NashvilleHousing
add OwnerSplitAddress nvarchar(255)

ALTER TABLE	NashvilleHousing
add OwnerSplitCity varchar(255)

ALTER TABLE	NashvilleHousing
add OwnerSplitState varchar(255)

Update	NashvilleHousing
SET OwnerSplitAddress= PARSENAME(Replace(ownerAddress,',','.'),3)

Update	NashvilleHousing
SET OwnerSplitCity= PARSENAME(Replace(ownerAddress,',','.'),2)

Update	NashvilleHousing
SET OwnerSplitState= PARSENAME(Replace(ownerAddress,',','.'),1)

-- Changing Y and N to Yes and No in SoldAsVacant

Select Distinct(SoldAsVacant),count(SoldAsVacant)
from NashvilleHousing
Group By SoldAsVacant
Order by 2

Select SoldasVacant,
Case
When SoldAsVacant='Y' then 'Yes'
When SoldAsVacant='N' then 'No'
Else SoldAsVacant
End
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant= Case
When SoldAsVacant='Y' then 'Yes'
When SoldAsVacant='N' then 'No'
Else SoldAsVacant
End

-- Remove Duplicates

with RowNumCTE as
(
Select *,
ROW_NUMBER()over(Partition by 
	ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	Order By
	UniqueID
	) as row_num

from NashvilleHousing
--Order by ParcelID
)

Select * 
from RowNumCTE
Where row_num>1

-- delete Columns

Select * 
from NashvilleHousing

Alter table NashvilleHousing
Drop column PropertyAddress,SaleDate,OwnerAddress,TaxDistrict

