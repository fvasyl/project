/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct
      T.[Team]
	  , TT.TournamentName
	  , NULL [ParentTeamID]
  FROM [Sport].[dbo].[Teams] T
  join [Sport].[dbo].Matches M
  on T.TeamID = M.AwayParticipant or T.TeamID = M.HomeParticipant
  join [Sport].[dbo].Tournaments TT
  on M.TournamentID =TT.TournamentID