/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct
      T.[Team]
	  ,tt.TeamID
	  , tt.TournamentID
	  , C.Club
	  ,cc.ClubID
	  , cc.SportID
  FROM [Sport].[dbo].[Teams] T
  join [Sport].[dbo].Clubs C
  on T.ClubId = C.ClubID
  join [SportDB].[sport].Clubs cc
	on c.Club = cc.Club
join SportDB.sport.Teams tt
on T.Team =tt.Team
join Sport.dbo.dbCamp_MatchesList ml
	on cc.SportID = ml.SportID
	and (cc.Club = ml.AwayClub or cc.Club = ml.HomeClub)
--order by tt.TeamID