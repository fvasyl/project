/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [HomeClub]
      ,DATEADD(m, 5, [DateMatch]) [DateMatch]
	  -- DATEADD(n, 5, Getdate()) [DateMatch]
      ,[AwayClub]
      ,[Sport]
      ,[TournamentName]
  FROM [Sport].[dbo].[dbCamp_MatchesList]