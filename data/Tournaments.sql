/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct
      T.[TournamentName] [TournamentName]
	  , S.Sport
  FROM [Sport].[dbo].[Tournaments] T
  join [Sport].[dbo].Matches M
  on T.TournamentID = M.TournamentID
   join [Sport].[dbo].Sports S
  on M.SportID = S.SportID
