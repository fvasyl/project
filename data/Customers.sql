/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  P.[BusinessEntityID]
     , P.[PersonType]
      ,isnull([FirstName]+[MiddleName]+[LastName], ABS(CHECKSUM(NEWID()))) [CustomerLogin]
	  , Pp.PasswordHash PasswordHash 
	  , Pp.PasswordSalt PasswordSalt 
	  , EA.EmailAddress [CustomerEmail]
	  , ABS(CHECKSUM(NEWID()))%2 [SendMails]
	  ,  ABS(CHECKSUM(NEWID()))%3 +1 [CustomerGroupID]
	  , SP.CountryRegionCode CountryCode
  FROM [AdventureWorks2017].[Person].[Person] P
  join [AdventureWorks2017].[Person].Password Pp
  on P.BusinessEntityID = Pp.BusinessEntityID
  join [AdventureWorks2017].[Person].EmailAddress EA 
  on P.BusinessEntityID = EA.BusinessEntityID
  join [AdventureWorks2017].[Person].BusinessEntityAddress BEA
  on  P.BusinessEntityID = BEA.BusinessEntityID
  join [AdventureWorks2017].[Person].Address A
  on A.AddressID = BEA.AddressID
  join [AdventureWorks2017].[Person].StateProvince SP
  on SP.StateProvinceID = A.StateProvinceID