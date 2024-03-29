/****** Script for SelectTopNRows command from SSMS  ******/
;with firstT([HomeClub], dateT, [AwayClub], [Sport], AwayTeam, SportID)
as
(
	SELECT distinct
		  ml.[HomeClub]
		  ,DATEADD(m, 5, ml.[DateMatch]) [DateMatch]
		  -- DATEADD(n, 5, Getdate()) [DateMatch]
		  ,ml.[AwayClub]
		  ,ml.[Sport]
		  ,ml.AwayTeam
		  ,ml.SportID
	  FROM [Sport].[dbo].[dbCamp_MatchesList] ml
) select distinct
	 FT.dateT
	, FT.AwayClub
	, C.ClubID ClubIDA
	, FT.HomeClub
	, CC.ClubID ClubIDH
	, FT.AwayTeam
	, tt.TeamID
	, FT.SportID
	, ABS(CHECKSUM(NEWID()) % 580)+1 [SportArenaID]
 from firstT FT 
   join  SportDB.sport.Teams tt
  on tt.Team = FT.AwayTeam 
  join SportDB.sport.Tournaments ttt
  on tt.TournamentID =  ttt.TournamentID
  join SportDB.sport.Clubs C
   on FT.AwayClub = C.Club and  FT.SportID = C.SportID
  join SportDB.sport.Clubs CC
  on FT.HomeClub = CC.Club and  FT.SportID = CC.SportID
where  FT.SportID = ttt.SportID
