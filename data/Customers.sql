/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  P.[BusinessEntityID]
     , min(P.[PersonType])
      ,min(isnull([FirstName]+[MiddleName]+[LastName], ABS(CHECKSUM(NEWID())))) [CustomerLogin]
	  ,min( Pp.PasswordHash) PasswordHash 
	  ,min( Pp.PasswordSalt) PasswordSalt 
	  ,min( Pp.rowguid) rowguid
	  ,min( EA.EmailAddress) [CustomerEmail]
	  ,min( ABS(CHECKSUM(NEWID()))%2) [SendMails]
	  ,min(  ABS(CHECKSUM(NEWID()))%3 +1) [CustomerGroupID]
	  ,min( SP.CountryRegionCode) CountryCode
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
  group by P.BusinessEntityID