/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct
      T.[Team]
	--  , TT.TournamentName
	  , RR.TournamentID
	  , NULL [ParentTeamID]
  FROM [Sport].[dbo].[Teams] T
  join [Sport].[dbo].Matches M
  on T.TeamID = M.AwayParticipant or T.TeamID = M.HomeParticipant
  join [Sport].[dbo].Tournaments TT
  on M.TournamentID =TT.TournamentID
  join (SELECT  row_number() over(order by (select 0)) TournamentID, tab.SportID, tab.TournamentName
from
      (select distinct T.[TournamentName] [TournamentName]
	  , S.SportID
  FROM [Sport].[dbo].[Tournaments] T
  join [Sport].[dbo].Matches M
  on T.TournamentID = M.TournamentID
   join [Sport].[dbo].Sports S
  on M.SportID = S.SportID) as tab) RR
  on TT.TournamentName = RR.TournamentName