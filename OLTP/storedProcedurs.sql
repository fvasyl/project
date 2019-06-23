use [SportDB]
go


IF OBJECT_ID ( 'location.UpsertCountry', 'P' ) IS NOT NULL   ---ADD or Change Sport
    DROP PROCEDURE location.UpsertCountry;  
GO
create procedure location.UpsertCountry 
	@CountryCode  nchar(3) = null, 
	@CountryEnglishName nvarchar(max) = null
as
	begin try
		set nocount, xact_abort on

		if not exists (select top (1)* from location.Countries C where C.CountryCode = @CountryCode)
			insert into location.Countries(CountryCode, CountryEnglishName)
			values (@CountryCode, @CountryEnglishName)
		else
		   update location.Countries
		   set location.Countries.CountryEnglishName = @CountryEnglishName
		   where location.Countries.CountryCode = @CountryCode;

	end try
	begin catch
		throw
	end catch
go
--------------------------------------------------

IF OBJECT_ID ( 'location.UpsertCity', 'P' ) IS NOT NULL   ---ADD or Change Sport
    DROP PROCEDURE location.UpsertCity;  
GO
create procedure location.UpsertCity 
	@CityID int = null, 
	@CityName nvarchar(max) = null, 
	@CountryCode  nchar(3) = null
as
	if not exists(select top (1) C.CountryCode from location.Countries C where C.CountryCode = @CountryCode)
		throw 50000, 'country doesnt exist', 1

	begin try
		set nocount, xact_abort on

		if isnull(@CityID,'') = ''
			insert into location.Cities(CityName, CountryCode)
			values (@CityName, @CountryCode)
		else
		   update location.Cities
		   set location.Cities.CityName = @CityName,
				location.Cities.CountryCode = @CountryCode
		   where location.Cities.CityID = @CityID;

	end try
	begin catch
		throw
	end catch
go
--------------------------------------------------

IF OBJECT_ID ( 'location.UpsertSportArena', 'P' ) IS NOT NULL   ---ADD or Change Sport
    DROP PROCEDURE location.UpsertSportArena;  
GO
create procedure location.UpsertSportArena 
	@SportArenaID int = null, 
	@AmountOfSits int = null, 
	@CityID  int = null, 
	@ArenaName nvarchar(max) = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@SportArenaID,'') = ''
			insert into location.SportArens(AmountOfSits, CityID, ArenaName)
			values (@AmountOfSits, @CityID, @ArenaName)
		else
		   update location.SportArens
		   set location.SportArens.AmountOfSits = @AmountOfSits,
				location.SportArens.ArenaName = @CityID,
				location.SportArens.CityID = @ArenaName
		   where location.SportArens.SportArenaID = @SportArenaID;

	end try
	begin catch
		throw
	end catch
go
--------------------------------------------------

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
	@ParentTeamID int = null,
	@TeamInformation  nvarchar(max) = null, 
	@TournamentID int = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@Team,'') = '' or
			isnull(@TournamentID,'') = ''
			throw 50000, 'Invalid parameters', 1

		if isnull(@TeamID,'') = ''
			insert into sport.Teams(Team, ParentTeamID, TeamInformation, TournamentID)
			values (@Team, @ParentTeamID, @TeamInformation, @TournamentID)
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
	@CustomerEmail nvarchar(25) = null, 
	@CustomerGroupID int = null,
	@CountryCode nchar(3) = null,
	@PasswordHash varchar(128) =  NULL,
	@PasswordSalt varchar(10) = NULL
as
	begin try
		set nocount, xact_abort on

		if isnull(@CustomerGroupID,'') = ''  or
			isnull(@PasswordHash,'') = '' or
			isnull(@PasswordSalt,'') = ''
				throw 50000, 'Invalid parameters', 1

		if isnull(@CustomerID,'') = ''
		begin
			insert into finance.Customers(CustomerLogin, CustomerEmail, CustomerGroupID, CountryCode)
			values (@CustomerLogin, @CustomerEmail, @CustomerGroupID, @CountryCode) --CustomerPassword
			insert into finance.CustomersPasswords(CustomerID, PasswordHash, PasswordSalt)
			values (@@identity, @PasswordHash, @PasswordSalt)
		end
		else
		begin
		   update finance.Customers
		   set finance.Customers.CustomerLogin = @CustomerLogin,
				finance.Customers.CountryCode = @CountryCode,
				finance.Customers.CustomerEmail = @CustomerEmail,
				finance.Customers.CustomerGroupID = @CustomerGroupID
		   where finance.Customers.CustomerID = @CustomerID;

		   update finance.CustomersPasswords
		   set finance.CustomersPasswords.PasswordHash = @PasswordHash,
				finance.CustomersPasswords.PasswordSalt = @PasswordSalt
		   where finance.CustomersPasswords.CustomerID = @CustomerID;

		end
	end try
	begin catch
		throw
	end catch
go
---------------------------------------

IF OBJECT_ID ( 'finance.UpsertEvent', 'P' ) IS NOT NULL   ---ADD or Change Event
    DROP PROCEDURE finance.UpsertEvent;  
GO
create procedure finance.UpsertEvent 

	@EventID int = null, 
	@Event nvarchar(15) = null,
	@SportID int = Null,
	@EventGroup int = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@Event,'') = '' 
			throw 50000, 'Invalid parameters', 1

		if isnull(@EventID,'') = ''
			insert into finance.Events(Event, SportID, EventGroup)
			values (@Event, @SportID, @EventGroup)
		else
		   update finance.Events
		   set finance.Events.Event = @Event,
		   finance.Events.SportID = @SportID,
		   finance.Events.EventGroup = @SportID
		   where finance.Events.EventID = @EventGroup
	end try
	begin catch
		throw
	end catch
go

----------------------------------


IF OBJECT_ID ( 'finance.UpsertCondition', 'P' ) IS NOT NULL   ---ADD or Change Condition
    DROP PROCEDURE finance.UpsertCondition;  
GO
create procedure finance.UpsertCondition 

	@ConditionID int = null, 
	@SportEventID int = null,
	@EventID int = null, 
	@Chance float = 0,
	@IsTrue bit = null
	--, @ConditionGroup int = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@SportEventID,'') = '' or
			isnull(@EventID,'') = ''  
			throw 50000, 'Invalid parameters', 1

		if exists(select top (1) * from finance.Conditions C where C.SportEventID = @SportEventID and C.EventID = @EventID )
			throw 50000, 'condition already exists', 1

		declare @AvaliableTo datetime = DATEADD(s, -10,(select M.DateMatch from sport.Matches M Where M.MatchID = @SportEventID))

		set @Chance = 1 - @Chance

		if isnull(@ConditionID,'') = ''
			insert into finance.Conditions(SportEventID, EventID, Chance, IsTrue, AvaliableTo)--, ConditionGroup)
			values (@SportEventID, @EventID, @Chance, @IsTrue, @AvaliableTo)--, @ConditionGroup)
		else
		   update finance.Conditions
		   set finance.Conditions.SportEventID = @SportEventID,
				finance.Conditions.EventID = @EventID,
				finance.Conditions.Chance = @Chance,
				finance.Conditions.IsTrue = @IsTrue,
				finance.Conditions.AvaliableTo = @AvaliableTo
				--, finance.Conditions.ConditionGroup = @ConditionGroup
		   where finance.Conditions.ConditionID = @ConditionID;

	end try
	begin catch
		throw
	end catch
go
---------------------------------


IF OBJECT_ID ( 'finance.AddCurrency', 'P' ) IS NOT NULL   ---ADD or Change Currency 
    DROP PROCEDURE finance.AddCurrency;  
GO
create procedure finance.AddCurrency 

	@CurrencyCode nchar(3) = null,
	@CurrencyName nvarchar(50) = null
as
	begin try
		set nocount, xact_abort on

		if not exists(select top(1) * from finance.Currencies C where C.CurrencyCode = @CurrencyCode)
			insert into finance.Currencies(CurrencyCode, CurrencyName)
			values (@CurrencyCode, @CurrencyName)
		else
		   update finance.Currencies
		   set finance.Currencies.CurrencyName = @CurrencyName
		   where finance.Currencies.CurrencyCode = @CurrencyCode;

	end try
	begin catch
		throw
	end catch
go

---------------------------------
IF OBJECT_ID ( 'finance.UpsertCurrencyRate', 'P' ) IS NOT NULL   ---ADD or Change Currency 
    DROP PROCEDURE finance.UpsertCurrencyRate;  
GO
create procedure finance.UpsertCurrencyRate 

	@CurrencyCode nchar(3) = null,
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

		if isnull(@CurrencyCode,'') = '' or
			not exists(select top(1) * from finance.Currencies C where C.CurrencyCode = @CurrencyCode)
			throw 50000, 'Invalid parameters', 1
		else
		   insert into finance.CurrenciesRates(CurrencyCode, CurrencyDollar, CurrencyDollarBay, CurrencyDollarSell, Date)
			values (@CurrencyCode, @CurrencyDollar, @CurrencyDollarBay, @CurrencyDollarSell, @Date)

	end try
	begin catch
		throw
	end catch
go
---------------------------------