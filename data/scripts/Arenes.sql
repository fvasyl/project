/****** Script for SelectTopNRows command from SSMS  ******/
;with aaa([CityName], [ArenaName])
as
(
	SELECT  distinct
		  A.[City] [CityName]
		  , (cast(A.[City] as nvarchar) + ' city Arena') [ArenaName]
		 

	  FROM [AdventureWorks2017].[Person].[Address] A
) 
select A.* 
	, C.CityID
	, ((ABS(CHECKSUM(NEWID()) % 10)+6 )*1500+(ABS(CHECKSUM(NEWID()) % 10 )+1)*100) [AmountOfSits]
 from aaa A
  join SportDB.location.Cities C
  on C.CityName COLLATE DATABASE_DEFAULT= A.[CityName] COLLATE DATABASE_DEFAULT