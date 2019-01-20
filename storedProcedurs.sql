use [SportDB]
go

IF OBJECT_ID ( 'sport.UpsertSport', 'P' ) IS NOT NULL   ---ADD or Change Sport
    DROP PROCEDURE sport.UpsertSport;  
GO
create procedure sport.UpsertSport 
	@SportID int = null, 
	@Sport nvarchar(max) = null, 
	@SportInformation  nvarchar(max) = null, 
	@SportType nvarchar(max) = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@Sport,'') = ''
			throw 50000, 'Invalid parameter', 1

		if isnull(@SportID,'') = ''
			insert into sport.Sports (Sport, SportInformation, SportType)
			values (@Sport, @SportInformation, @SportType)
		else
		   update sport.Sports
		   set sport.Sports.Sport = @Sport,
				sport.Sports.SportInformation = @SportInformation,
				sport.Sports.SportType = @SportType
		   where sport.Sports.SportID = @SportID;

	end try
	begin catch
		throw
	end catch
go
--------------------------------------------------

IF OBJECT_ID ( 'sport.UpsertTournament', 'P' ) IS NOT NULL   ---- ADD or Change Tournament
    DROP PROCEDURE sport.UpsertTournament;  
GO
create procedure sport.UpsertTournament 
	@TournamentID int = null, 
	@TournamentName nvarchar(max) = null, 
	@TournamentInformation  nvarchar(max) = null, 
	@SportID nvarchar(max) = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@TournamentName,'') = '' or
			isnull(@SportID,'') = ''
			throw 50000, 'Invalid parameters', 1

		if isnull(@TournamentID,'') = ''
			insert into sport.Tournaments(TournamentName, TournamentInformation, SportID)
			values (@TournamentName, @TournamentInformation, @SportID)
		else
		   update sport.Tournaments
		   set sport.Tournaments.TournamentName = @TournamentName,
				sport.Tournaments.SportID = @SportID,
				sport.Tournaments.TournamentInformation = @TournamentInformation
		   where sport.Tournaments.TournamentID = @TournamentID;

	end try
	begin catch
		throw
	end catch
go
-------------------------------------


IF OBJECT_ID ( 'sport.UpsertClub', 'P' ) IS NOT NULL   ---- ADD or Change Club
    DROP PROCEDURE sport.UpsertClub;  
GO
create procedure sport.UpsertClub 
	@ClubID int = null, 
	@Club nvarchar(450) = null, 
	@ClubInformation  nvarchar(max) = null, 
	@CouchFullName nvarchar(150) = null, 
	@SportID int = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@Club,'') = '' or
			isnull(@SportID,'') = ''
			throw 50000, 'Invalid parameters', 1

		if isnull(@ClubID,'') = ''
			insert into sport.Clubs(Club, ClubInformation, CouchFullName, SportID)
			values (@Club, @ClubInformation, @CouchFullName, @SportID)
		else
		   update sport.Clubs
		   set sport.Clubs.Club = @Club,
				sport.Clubs.ClubInformation = @ClubInformation,
				sport.Clubs.CouchFullName = @CouchFullName,
				sport.Clubs.SportID = @SportID
		   where sport.Clubs.ClubID = @ClubID;

	end try
	begin catch
		throw
	end catch
go
--------------------------------------

IF OBJECT_ID ( 'sport.UpsertTeam', 'P' ) IS NOT NULL   ---- ADD or Change Team
    DROP PROCEDURE sport.UpsertTeam;  
GO
create procedure sport.UpsertTeam 
	@TeamID int = null, 
	@Team nvarchar(450) = null, 
	@TeamInformation  nvarchar(max) = null, 
	@TournamentID int = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@Team,'') = '' or
			isnull(@TournamentID,'') = ''
			throw 50000, 'Invalid parameters', 1

		if isnull(@TeamID,'') = ''
			insert into sport.Teams(Team, TeamInformation, TournamentID)
			values (@Team, @TeamInformation, @TournamentID)
		else
		   update sport.Teams
		   set sport.Teams.Team = @Team,
				sport.Teams.TeamInformation = @TeamInformation,
				sport.Teams.TournamentID = @TournamentID
		   where sport.Teams.TeamID = @TeamID;

	end try
	begin catch
		throw
	end catch
go
------------------------------------------

IF OBJECT_ID ( 'sport.AddClubToTeam', 'P' ) IS NOT NULL   ---- ADD club to Team
    DROP PROCEDURE sport.AddClubToTeam;  
GO
create procedure sport.AddClubToTeam 
	@TeamID int = null, 
	@ClubID int = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@TeamID,'') = '' or
			isnull(@ClubID,'') = ''
			throw 50000, 'Invalid parameters', 1

		insert into sport.TeamsClubs(TeamID, ClubID)
		values (@TeamID, @ClubID)

	end try
	begin catch
		throw
	end catch
go
-------------------------------------

IF OBJECT_ID ( 'sport.UpsertMatch', 'P' ) IS NOT NULL   ---ADD or Change Match
    DROP PROCEDURE sport.UpsertMatch;  
GO
create procedure sport.UpsertMatch 

	@MatchID int = null, 
	@DateMatch datetime = null,
	@HomeParticipant int = null,
	@AwayParticipant int = null, 
	@TeamID int = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@DateMatch,'') = '' or
			isnull(@HomeParticipant,'') = ''  or
			isnull(@AwayParticipant,'') = '' 
			throw 50000, 'Invalid parameters', 1

		if isnull(@MatchID,'') = ''
			insert into sport.Matches(DateMatch, HomeParticipant, AwayParticipant, TeamID)
			values (@DateMatch, @HomeParticipant, @AwayParticipant, @TeamID)
		else
		   update sport.Matches
		   set sport.Matches.DateMatch = @DateMatch,
				sport.Matches.HomeParticipant = @HomeParticipant,
				sport.Matches.AwayParticipant = @AwayParticipant,
				sport.Matches.TeamID = @TeamID
		   where sport.Matches.MatchID = @MatchID;

	end try
	begin catch
		throw
	end catch
go
--------------------------------------------------


IF OBJECT_ID ( 'finance.UpsertCustomerGroup', 'P' ) IS NOT NULL   ---ADD or Change CustomersGroups
    DROP PROCEDURE finance.UpsertCustomerGroup;  
GO
create procedure finance.UpsertCustomerGroup 

	@CustomerGroupID int = null, 
	@CustomerGroup nvarchar(450) = null,
	@CustomerGroupCommissionAddStake float = 0,
	@CustomerGroupCommissionEditStake float = 0, 
	@CustomerGroupCommissionDeleteStake float = 0
as
	begin try
		set nocount, xact_abort on

		if isnull(@CustomerGroupID,'') = ''
			insert into finance.CustomersGroups(CustomerGroup, CustomerGroupCommissionAddStake, CustomerGroupCommissionEditStake, CustomerGroupCommissionDeleteStake)
			values (@CustomerGroup, @CustomerGroupCommissionAddStake, @CustomerGroupCommissionEditStake, @CustomerGroupCommissionDeleteStake)
		else
		   update finance.CustomersGroups
		   set finance.CustomersGroups.CustomerGroup = @CustomerGroup,
				finance.CustomersGroups.CustomerGroupCommissionAddStake = @CustomerGroupCommissionAddStake,
				finance.CustomersGroups.CustomerGroupCommissionEditStake = @CustomerGroupCommissionEditStake,
				finance.CustomersGroups.CustomerGroupCommissionDeleteStake = @CustomerGroupCommissionDeleteStake
		   where finance.CustomersGroups.CustomerGroupID = @CustomerGroupID;

	end try
	begin catch
		throw
	end catch
go
---------------------------------------

IF OBJECT_ID ( 'finance.UpsertCustomer', 'P' ) IS NOT NULL   ---ADD or Change Customer
    DROP PROCEDURE finance.UpsertCustomer;  
GO
create procedure finance.UpsertCustomer 

	@CustomerID int = null, 
	@CustomerLogin nvarchar(15) = null,
	@CustomerPassword nvarchar(15) = null,
	@CustomerEmail nvarchar(25) = null, 
	@CustomerGroupID int = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@CustomerGroupID,'') = '' 
			throw 50000, 'Invalid parameters', 1

		if isnull(@CustomerID,'') = ''
			insert into finance.Customers(CustomerLogin, CustomerPassword, CustomerEmail, CustomerGroupID)
			values (@CustomerLogin, @CustomerPassword, @CustomerEmail, @CustomerGroupID)
		else
		   update finance.Customers
		   set finance.Customers.CustomerLogin = @CustomerLogin,
				finance.Customers.CustomerPassword = @CustomerPassword,
				finance.Customers.CustomerEmail = @CustomerEmail,
				finance.Customers.CustomerGroupID = @CustomerGroupID
		   where finance.Customers.CustomerID = @CustomerID;

	end try
	begin catch
		throw
	end catch
go
---------------------------------------

IF OBJECT_ID ( 'finance.UpsertConsideration', 'P' ) IS NOT NULL   ---ADD or Change Consideration
    DROP PROCEDURE finance.UpsertConsideration;  
GO
create procedure finance.UpsertConsideration 

	@ConsiderationID int = null, 
	@Consideration nvarchar(15) = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@Consideration,'') = '' 
			throw 50000, 'Invalid parameters', 1

		if isnull(@ConsiderationID,'') = ''
			insert into finance.Considerations(Consideration)
			values (@Consideration)
		else
		   update finance.Considerations
		   set finance.Considerations.Consideration = @Consideration
		   where finance.Considerations.ConsiderationID = @ConsiderationID;

	end try
	begin catch
		throw
	end catch
go

----------------------------------


IF OBJECT_ID ( 'finance.UpsertEvent', 'P' ) IS NOT NULL   ---ADD or Change Event
    DROP PROCEDURE finance.UpsertEvent;  
GO
create procedure finance.UpsertEvent 

	@EventID int = null, 
	@SportEventID int = null,
	@ConsiderationID int = null, 
	@Chance float = 0,
	@IsTrue bit = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@SportEventID,'') = '' or
			isnull(@ConsiderationID,'') = ''
			throw 50000, 'Invalid parameters', 1

		if isnull(@EventID,'') = ''
			insert into finance.Events(SportEventID, ConsiderationID, Chance, IsTrue)
			values (@SportEventID, @ConsiderationID, @Chance, @IsTrue)
		else
		   update finance.Events
		   set finance.Events.SportEventID = @SportEventID,
				finance.Events.ConsiderationID = @ConsiderationID,
				finance.Events.Chance = @Chance,
				finance.Events.IsTrue = @IsTrue
		   where finance.Events.EventID = @EventID;

	end try
	begin catch
		throw
	end catch
go
---------------------------------


IF OBJECT_ID ( 'finance.UpsertCurrency', 'P' ) IS NOT NULL   ---ADD or Change Currency 
    DROP PROCEDURE finance.UpsertCurrency;  
GO
create procedure finance.UpsertCurrency 

	@CurrencyID int = null, 
	@CurrencyDollar float = null,
	@CurrencyDollarBay float = null, 
	@CurrencyDollarSell float = null,
	@Date datetime = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@CurrencyDollar,'') = '' 
			throw 50000, 'Invalid parameters', 1

		if isnull(@Date,'') = ''
			set @Date = GETDATE()

		if isnull(@CurrencyID,'') = ''
			insert into finance.Currencies(CurrencyDollar, CurrencyDollarBay, CurrencyDollarSell, Date)
			values (@CurrencyDollar, @CurrencyDollarBay, @CurrencyDollarSell, @Date)
		else
		   update finance.Currencies
		   set finance.Currencies.CurrencyDollar = @CurrencyDollar,
				finance.Currencies.CurrencyDollarBay = @CurrencyDollarBay,
				finance.Currencies.CurrencyDollarSell = @CurrencyDollarSell,
				finance.Currencies.Date = @Date
		   where finance.Currencies.CurrencyID = @CurrencyID;

	end try
	begin catch
		throw
	end catch
go
---------------------------------
