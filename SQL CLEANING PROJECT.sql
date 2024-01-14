select *
from dbo.NashvillHousing ;

--change date format 
select sale_date2
from dbo.NashvillHousing ;

select saleDate,CONVERT (DATE,saleDate) AS sale_date2
from dbo.NashvillHousing ;


alter table dbo.NashvillHousing 
add sale_date2 date ;

update dbo.NashvillHousing 
set sale_date2  = CONVERT (DATE,saleDate)  ;

--populate the nulls in propertyAdress
select A.[UniqueID ] ,A.ParcelID , B.ParcelID ,A.PropertyAddress,B.PropertyAddress ,ISNULL (A.PropertyAddress,B.PropertyAddress)
from dbo.NashvillHousing A
JOIN dbo.NashvillHousing B
on a.ParcelID = b.ParcelID
and A.[UniqueID ]<> b.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress =ISNULL (A.PropertyAddress,B.PropertyAddress)
from dbo.NashvillHousing A
JOIN dbo.NashvillHousing B
on a.ParcelID = b.ParcelID
and A.[UniqueID ]<> b.[UniqueID ]
WHERE A.PropertyAddress IS NULL

 --breaking the propertyAdress adress,city sparate columns

 select PropertyAddress
 from dbo.NashvillHousing;


 select PropertyAddress,
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
 substring (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len (PropertyAddress) ) as city
 from dbo.NashvillHousing;

  alter table  dbo.NashvillHousing
  add propertyAddress_address varchar (255)
   update dbo.NashvillHousing
   set propertyAddress_address =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

     alter table  dbo.NashvillHousing
  add propertyAddress_city varchar (255);

    update dbo.NashvillHousing
   set propertyAddress_city =substring (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len (PropertyAddress) );

    select*
 from dbo.NashvillHousing;
  
 select OwnerAddress
 from dbo.NashvillHousing;

 select OwnerAddress,
 PARSENAME(REPLACE (OwnerAddress,',','.'),3) AS OWNER_ADDRESS_adress,
 PARSENAME(REPLACE (OwnerAddress,',','.'),2) AS OWNER_ADDRESS_city,
 PARSENAME(REPLACE (OwnerAddress,',','.'),1) AS OWNER_ADDRESS_state
 from dbo.NashvillHousing;
  
  alter table dbo.NashvillHousing
  add OWNER_ADDRESS_adress varchar (255) ;
   update dbo.NashvillHousing
   set OWNER_ADDRESS_adress =PARSENAME(REPLACE (OwnerAddress,',','.'),3);

   alter table dbo.NashvillHousing
  add OWNER_ADDRESS_city varchar (255) ;
   update dbo.NashvillHousing
   set OWNER_ADDRESS_city = PARSENAME(REPLACE (OwnerAddress,',','.'),2)

      alter table dbo.NashvillHousing
  add OWNER_ADDRESS_state varchar (255);
     update dbo.NashvillHousing
   set OWNER_ADDRESS_state = PARSENAME(REPLACE (OwnerAddress,',','.'),1)

   --change y and n to yes and no in soldesVacant 
   select SoldAsVacant
   from dbo.NashvillHousing

   select  distinct (SoldAsVacant)
   from dbo.NashvillHousing;

    select SoldAsVacant ,
	case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant= 'N' then 'No'
	ELSE SoldAsVacant
	END 
   from dbo.NashvillHousing ;

    UPDATE dbo.NashvillHousing
	SET SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant= 'N' then 'No'
	ELSE SoldAsVacant
	END ;


	--REMOVE DUPLICATS
WITH  ROW_NUM_CTE AS 
(
SELECT *,
	ROW_NUMBER () OVER (PARTITION BY PARCELID,PROPERTYADDRESS,SALEPRICE,SALEDATE,LEGALREFERENCE ORDER BY UNIQUEID )  AS ROW_NUM

	FROM dbo.NashvillHousing )
	--DELETE AFTER DELETE WE USE SELECTE * AGAIN TO CHECK DUPLICATS
	SELECT *
	FROM ROW_NUM_CTE
	 WHERE ROW_NUM > 1

	 --REMOVE UNUSFUL COLUMNS

	 ALTER TABLE dbo.NashvillHousing
	 DROP COLUMN OWNERADDRESS,
	 TAXDISTRICT,
	 PROPERTYADDRESS ;
	 SELECT *
	 FROM dbo.NashvillHousing ;
	 ALTER TABLE dbo.NashvillHousing
	 DROP COLUMN SALEDATE ;

