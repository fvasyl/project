/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [CurrencyCode]
      ,[Name] [CurrencyName]
	  , 1 [CurrencyDollar]
	  , 0.95 [CurrencyDollarBay]
	  , 1.05 [CurrencyDollarSell]
  FROM [AdventureWorks2017].[Sales].[Currency]