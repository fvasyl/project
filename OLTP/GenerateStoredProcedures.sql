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


IF OBJECT_ID ( 'dbo.AddSomeResult', 'P' ) IS NOT NULL   ---ADD or Change Currency 
    DROP PROCEDURE dbo.AddSomeResult;  
GO
create procedure dbo.AddSomeResult 
as

	DECLARE @Condition TABLE
	(
	   SportEventID int,
	   EventID int,
	   EventGroup int,
	   rowN uniqueidentifier
	)

	;with Conditions(SportEventID, EventID,EventGroup, rowN)
	as
	(
		select C.SportEventID, C.EventID,E.EventGroup,  newid()
		from finance.Conditions C
			join finance.Events E on C.EventID = E.EventID
		where C.IsTrue is null and C.AvaliableTo <= Getdate() 
	)
	insert into @Condition
		select C.SportEventID, C.EventID, C.EventGroup, C.rowN from Conditions C

	;with GetMathesGroups(MatchID, GroupID, rn)
	as
	(
		select C.SportEventID, C.EventGroup, min(C.rowN)
		from @Condition C
		group by C.EventGroup, C.SportEventID 
	)
	insert into Sport.MatchesResults (MatchID, EventID, IsTrue)
	select B.SportEventID, B.EventID, 1
	from @Condition B
		join GetMathesGroups GMG on GMG.rn = B.rowN

go


; with Customers (CustomerID, CountryCode)
	as
	(
		select C.CustomerID, C.CountryCode from finance.Customers C
	),
	Amounts (CustomerID, AmountCommission, AmountTax, FinalAmount)
	as
	(
		select C.CustomerID, 0, T.TaxRate*1000, 1000-T.TaxRate*1000
		from Customers C
			join finance.Taxes T on C.CountryCode = T.CountryCode
	)
	insert into finance.CustomersFinanceOperations (CustomerID, FinanceOperationTyp, Amount, AmountCommission, AmountTax, FinalAmount, CurrencyCode, OperationDate)
		select A.CustomerID, 1, 1000, A.AmountCommission, A.AmountTax, A.FinalAmount, 'USD', getdate() from Amounts A

		--------------------------------------------------------------

IF OBJECT_ID ( 'dbo.AddSomeStake', 'P' ) IS NOT NULL   ---ADD or Change Currency 
    DROP PROCEDURE dbo.AddSomeStake;  
GO
create procedure dbo.AddSomeStake 
as

	declare @CustomerID int
	declare @Amount money
	declare @ConditionID int
	declare @CurrencyCode nvarchar(3) = 'USD'

	;with Customer(CustomerID, nn)
	as
	(
		select C.CustomerID,  newid() nn
		from finance.Customers C
	)
	select top(1)  @CustomerID =  C.CustomerID from Customer C order by C.nn 
	select @CustomerID

	;with Conditions(ConditionID, rowN)
	as
	(
		select C.ConditionID,  newid()
		from finance.Conditions C
		where C.IsTrue is null and C.AvaliableTo > Getdate() 
	)
	select top(1) @ConditionID = C.ConditionID from Conditions C order by C.rowN
	select @ConditionID

	set @Amount =  (ABS(CHECKSUM(NEWID()) % 30) + 10)/4.

	exec finance.AddStake @Amount, @CurrencyCode, @CustomerID, @ConditionID, 0;

go

exec dbo.AddSomeStake
exec dbo.AddSomeMatch
exec dbo.AddSomeResult