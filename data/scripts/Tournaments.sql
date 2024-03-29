/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  row_number() over(order by (select 0)) TournamentID, tab.SportID, tab.TournamentName
from
      (select distinct T.[TournamentName] [TournamentName]
	  , S.SportID
  FROM [Sport].[dbo].[Tournaments] T
  join [Sport].[dbo].Matches M
  on T.TournamentID = M.TournamentID
   join [Sport].[dbo].Sports S
  on M.SportID = S.SportID) as tab
