use [SportDB]
go

IF OBJECT_ID ( 'dbo.AddSomeMatch', 'P' ) IS NOT NULL   ---ADD or Change Sport
    DROP PROCEDURE dbo.AddSomeMatch;  
GO
create procedure dbo.AddSomeMatch 
as
   declare @TeamID int
   declare @SportArenaId int
	DECLARE @TwoClubs TABLE
	(
	  ClubID int
	)

	;with Teams(TeamID, Team)
	as
	(
		select distinct TC.TeamID, T.Team 
		from sport.TeamsClubs TC 
			join sport.Teams  T on TC.TeamID = T.TeamID 
	)
	,sroptTeam (TeamID, Team, rnum)
	as
	(
		select  Tm.TeamID, Tm.Team, newid()  rn 
		from Teams Tm
	)
	  select top(1) @TeamID = TeamID
	from sroptTeam
	order by rnum  

		--select @TeamID
		----------------------------------
	;with Club(ClubID, rowN)
	as
	(
		select TC.ClubID, newid()  rn
		from sport.TeamsClubs TC 
		where TC.TeamID = @TeamID
	)
	insert into @TwoClubs
		select top(2) C.ClubID from Club C order by rowN

		--select * from @TwoClubs
-----------------------------------
	;with Arena(ArenaID, rowN)
	as
	(
		select A.SportArenaID, newid()  rn
		from location.SportArens A 
	)
		select top(1) @SportArenaId =  A.ArenaID from Arena A order by rowN

		--select @SportArenaId

		declare  @date datetime = DATEADD(s,90, getdate())
		 declare  @Club1 int = (select top(1) * from @TwoClubs )
		delete from @TwoClubs where ClubID = @Club1
		declare  @Club2 int = (select top(1) * from @TwoClubs )

		exec sport.UpsertMatch default, @date, @Club1, @Club2, @TeamID, @SportArenaId

		;with CountGroups(GroupE, CountE)
		as
		(
			select E.EventGroup, 1./count(EventGroup) from finance.Events E group by E.EventGroup 
		)
		insert into finance.Conditions (SportEventID, EventID, Chance, IsTrue, AvaliableTo, DateOfCreating)
		select @@IDENTITY, E.EventID, CG.CountE, null, DATEADD(s,-10, @date), getdate()  from finance.Events E 
			join CountGroups CG on CG.GroupE = E.EventGroup
go

exec dbo.AddSomeMatch