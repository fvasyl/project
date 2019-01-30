/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
      A.[City] [CityName]
	  , (cast(A.[City] as nvarchar) + ' city Arena') [ArenaName]
	  , ((ABS(CHECKSUM(NEWID()) % 10)+6 )*1500+(ABS(CHECKSUM(NEWID()) % 10 )+1)*100) [AmountOfSits]

  FROM [AdventureWorks2017].[Person].[Address] A