/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      T.[Team]
	  , C.Club
  FROM [Sport].[dbo].[Teams] T
  join [Sport].[dbo].Clubs C
  on T.ClubId = C.ClubID