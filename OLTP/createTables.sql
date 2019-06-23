use [SportDB]
go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [location].[Countries](
	[CountryCode] [nchar](3) NOT NULL,
	[CountryEnglishName] [nvarchar](max) NULL,
	[ModifiedDate] [datetime]  default (getDate()),
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--ALTER TABLE [location].[Countries] ADD  CONSTRAINT [DF_Countries_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
--GO
----------------------------------------------

CREATE TABLE [location].[Cities](
	[CityID] [int] NOT NULL IDENTITY(1,1),
	[CountryCode] [nchar](3) NULL,
	[CityName] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] not null,
 CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [location].[Cities]  WITH CHECK ADD  CONSTRAINT [FK_Cities_Countries] FOREIGN KEY([CountryCode])
REFERENCES [location].[Countries] ([CountryCode])
GO

ALTER TABLE [location].[Cities] CHECK CONSTRAINT [FK_Cities_Countries]
GO

ALTER TABLE [location].[Cities] ADD  CONSTRAINT [DF_Cities_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
----------------------------------------------

CREATE TABLE [location].[SportArens](
	[SportArenaID] [int] NOT NULL IDENTITY(1,1),
	[AmountOfSits] [int] NULL,
	[CityID] [int] NULL,
	[ArenaName] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] not null,
 CONSTRAINT [PK_SportArens] PRIMARY KEY CLUSTERED 
(
	[SportArenaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [location].[SportArens]  WITH CHECK ADD  CONSTRAINT [FK_SportArens_Cities] FOREIGN KEY([CityID])
REFERENCES [location].[Cities] ([CityID])
GO

ALTER TABLE [location].[SportArens] CHECK CONSTRAINT [FK_SportArens_Cities]
GO

ALTER TABLE [location].[SportArens] ADD  CONSTRAINT [DF_SportArens_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
----------------------------------------------

CREATE TABLE [sport].[Sports](
	[SportID] [int] NOT NULL IDENTITY(1,1),
	[Sport] [nvarchar](max) NULL,
	[SportInformation][nvarchar](max) NULL,
	[SportType] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] default (getDate()),
 CONSTRAINT [PK_Sports] PRIMARY KEY CLUSTERED 
(
	[SportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

--ALTER TABLE [sport].[Sports] ADD  CONSTRAINT [DF_Sports_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
--GO

-------------------------
CREATE TABLE [sport].[Tournaments](
	[TournamentID] [int] NOT NULL IDENTITY(1,1),
	[TournamentName] [nvarchar](max) NULL,
	[TournamentInformation][nvarchar](max) NULL,
	[SportID] [int] NOT NULL,
	[ModifiedDate] [datetime] not null,
 CONSTRAINT [PK_Tournaments] PRIMARY KEY CLUSTERED 
(
	[TournamentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [sport].[Tournaments]  WITH CHECK ADD  CONSTRAINT [FK_Tournament_Sport] FOREIGN KEY([SportID])
REFERENCES [sport].[Sports] ([SportID])
GO

ALTER TABLE [sport].[Tournaments] CHECK CONSTRAINT [FK_Tournament_Sport]
GO

ALTER TABLE [sport].[Tournaments] ADD  CONSTRAINT [DF_Tournaments_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
-------------------------
CREATE TABLE [sport].[Clubs](
	[ClubID] [int] NOT NULL IDENTITY(1,1),
	[Club] [nvarchar](450) NULL,
	[ClubInformation] [nvarchar](max) NULL,
	[CouchFullName] [nvarchar](150) NULL,
	[SportID] [int] NOT NULL,
	[ModifiedDate] [datetime] not null,
 CONSTRAINT [PK_Clubs] PRIMARY KEY CLUSTERED 
(
	[ClubID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [sport].[Clubs]  WITH CHECK ADD  CONSTRAINT [FK_Clubs_Sport] FOREIGN KEY([SportID])
REFERENCES [sport].[Sports] ([SportID])
GO

ALTER TABLE [sport].[Clubs] CHECK CONSTRAINT [FK_Clubs_Sport]
GO

ALTER TABLE [sport].[Clubs] ADD  CONSTRAINT [DF_Clubs_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

-------------------------
CREATE TABLE [sport].[Teams](
	[TeamID] [int] NOT NULL IDENTITY(1,1),
	[Team] [nvarchar](450) NULL,
	[ParentTeamID] [int] NULL,
	[TeamInformation] [nvarchar](max) NULL,
	[TournamentID] [int] NOT NULL,
	[ModifiedDate] [datetime] default (getDate()),
 CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED 
(
	[TeamID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [sport].[Teams]  WITH CHECK ADD  CONSTRAINT [FK_Team_Tournament] FOREIGN KEY([TournamentID])
REFERENCES [sport].[Tournaments] ([TournamentID])
GO

ALTER TABLE [sport].[Teams] CHECK CONSTRAINT [FK_Team_Tournament]
GO

ALTER TABLE [sport].[Teams]  WITH CHECK ADD  CONSTRAINT [FK_Team_Team] FOREIGN KEY([ParentTeamID])
REFERENCES [sport].[Teams] ([TeamID])
GO

ALTER TABLE [sport].[Teams] CHECK CONSTRAINT [FK_Team_Team]
GO

--ALTER TABLE [sport].[Teams] ADD  CONSTRAINT [DF_Teams_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
--GO

----------------------------
CREATE TABLE [sport].[TeamsClubs](
	[TeamID] [int] NOT NULL,
	[ClubID] [int] NOT NULL,
	primary key ([TeamID], [ClubID]))
GO

ALTER TABLE [sport].[TeamsClubs]  WITH CHECK ADD  CONSTRAINT [FK_Team] FOREIGN KEY([TeamID])
REFERENCES [sport].[Teams] ([TeamID])
GO

ALTER TABLE [sport].[TeamsClubs] CHECK CONSTRAINT [FK_Team]
GO

ALTER TABLE [sport].[TeamsClubs]  WITH CHECK ADD  CONSTRAINT [FK_Club] FOREIGN KEY([ClubID])
REFERENCES [sport].[Clubs] ([ClubID])
GO

ALTER TABLE [sport].[TeamsClubs] CHECK CONSTRAINT [FK_Club]
GO

----------------------------
CREATE TABLE [sport].[Matches](
	[MatchID] [int] NOT NULL IDENTITY(1,1),
	[DateMatch] [datetime] NOT NULL,
	[HomeParticipant] [int] NOT NULL,
	[AwayParticipant] [int] NOT NULL,
	[TeamID] [int] NULL,
	[SportArenaID] [int] NULL,
	[ModifiedDate] [datetime] default (getDate()),
 CONSTRAINT [PK_Matches] PRIMARY KEY CLUSTERED 
(
	[MatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [sport].[Matches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Teams] FOREIGN KEY([TeamID])
REFERENCES [sport].[Teams] ([TeamID])
GO

ALTER TABLE [sport].[Matches] CHECK CONSTRAINT [FK_Matches_Teams]
GO

ALTER TABLE [sport].[Matches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Club1] FOREIGN KEY([HomeParticipant])
REFERENCES [sport].[Clubs] ([ClubID])
GO

ALTER TABLE [sport].[Matches] CHECK CONSTRAINT [FK_Matches_Club1]
GO

ALTER TABLE [sport].[Matches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Club2] FOREIGN KEY([AwayParticipant])
REFERENCES [sport].[Clubs] ([ClubID])
GO

ALTER TABLE [sport].[Matches] CHECK CONSTRAINT [FK_Matches_Club2]
GO

ALTER TABLE [sport].[Matches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_SportArens] FOREIGN KEY([SportArenaID])
REFERENCES [location].[SportArens] ([SportArenaID])
GO

ALTER TABLE [sport].[Matches] CHECK CONSTRAINT [FK_Matches_SportArens]
GO

----------------------------
CREATE TABLE [finance].[CustomersGroups](
	[CustomerGroupID] [int] NOT NULL  IDENTITY(1,1),
	[CustomerGroup] [nvarchar](450) NULL,
	[CustomerGroupCommissionAddStake] [float] NULL,
	[CustomerGroupCommissionEditStake] [float] NULL,
	[CustomerGroupCommissionDeleteStake] [float] NULL,
	[ModifiedDate] [datetime] default (getDate()),
 CONSTRAINT [PK_CustomersGroups] PRIMARY KEY CLUSTERED 
(
	[CustomerGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

----------------------------
CREATE TABLE [finance].[Customers](
	[CustomerID] [int] NOT NULL IDENTITY(1,1),
	[CustomerLogin] [nvarchar](50) NOT NULL,
	[CustomerEmail] [nvarchar](50) NOT NULL,
	[SendMails] [bit] NULL DEFAULT(0),
	[CustomerGroupID] [int] NOT NULL,
	[CountryCode] [nchar](3) NuLL,
	[ModifiedDate] [datetime] default (getDate()),
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [finance].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_CustomersGroups] FOREIGN KEY([CustomerGroupID])
REFERENCES [finance].[CustomersGroups] ([CustomerGroupID])
GO

ALTER TABLE [finance].[Customers] CHECK CONSTRAINT [FK_Customers_CustomersGroups]
GO

ALTER TABLE [finance].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Countries] FOREIGN KEY([CountryCode])
REFERENCES [location].[Countries] ([CountryCode])
GO

ALTER TABLE [finance].[Customers] CHECK CONSTRAINT [FK_Customers_Countries]
GO

ALTER TABLE [finance].[Customers] ADD CONSTRAINT UC_Customer UNIQUE ([CustomerLogin])
go

--ALTER TABLE [finance].[Customers] ADD  CONSTRAINT [DF_Customer_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
--GO

---------------------------------

CREATE TABLE [finance].[CustomersPasswords](
	[CustomerID] [int] NOT NULL,
	[PasswordHash] [varchar](128) NOT NULL,
	[PasswordSalt] [varchar](10) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] default (getDate()),
 CONSTRAINT [PK_Password_BusinessEntityID] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [finance].[CustomersPasswords] ADD  CONSTRAINT [DF_Password_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

--ALTER TABLE [finance].[CustomersPasswords] ADD  CONSTRAINT [DF_Password_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
--GO

ALTER TABLE [finance].[CustomersPasswords]  WITH CHECK ADD  CONSTRAINT [FK_Password_Person_BusinessEntityID] FOREIGN KEY([CustomerID])
REFERENCES [finance].[Customers] ([CustomerID])
GO

ALTER TABLE [finance].[CustomersPasswords] CHECK CONSTRAINT [FK_Password_Person_BusinessEntityID]
GO
------------------------------
CREATE TABLE [finance].[Events](

--maybe will add [winnerID] [int] NULL,
	[EventID] [int] NOT NULL IDENTITY(1,1),
	[Event] [nvarchar](15) NOT NULL,
	[SportID] [int] Null,
	[EventGroup] [int] null,
	[ModifiedDate] [datetime] default (getDate()),
 CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--ALTER TABLE [finance].[Events] ADD  CONSTRAINT [DF_Events_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
--GO

ALTER TABLE [finance].[Events] WITH CHECK ADD  CONSTRAINT [FK_Events_Sport] FOREIGN KEY([SportID])
REFERENCES [sport].[Sports] ([SportID])
GO

ALTER TABLE [finance].[Events] CHECK CONSTRAINT [FK_Events_Sport]
GO

----------------------------
CREATE TABLE [finance].[Conditions](
	[ConditionID] [int] NOT NULL IDENTITY(1,1),
	[SportEventID] [int] NOT NULL,
	[EventID] [int] NOT NULL,
	[Chance] [float] NOT NULL,
	[IsTrue] [bit] NULL,
	[AvaliableTo] [datetime] NOT NULL,
	[DateOfCreating] [datetime] default (getDate()),
 CONSTRAINT [PK_Conditions] PRIMARY KEY CLUSTERED 
(
	[ConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [finance].[Conditions]  WITH CHECK ADD  CONSTRAINT [FK_Conditions_Matches] FOREIGN KEY([SportEventID])
REFERENCES [sport].[Matches]([MatchID])
GO

ALTER TABLE [finance].[Conditions] CHECK CONSTRAINT [FK_Conditions_Matches]
GO

ALTER TABLE [finance].[Conditions] WITH CHECK ADD  CONSTRAINT [FK_Conditions_Events] FOREIGN KEY([EventID])
REFERENCES [finance].[Events]([EventID])
GO

ALTER TABLE [finance].[Conditions] CHECK CONSTRAINT [FK_Conditions_Events]
GO

-------------------------------
CREATE TABLE [finance].[Currencies](
	[CurrencyCode] nchar(3) not null,
	[CurrencyName] [nvarchar] (50) Null,
 CONSTRAINT [PK_Currencies] PRIMARY KEY CLUSTERED 
(
	[CurrencyCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-----------------------------------------------

CREATE TABLE [finance].[CurrenciesRates](
	[CurrencyRateID] [int] NOT NULL IDENTITY(1,1),
	[CurrencyCode] nchar(3) not null,
	[CurrencyDollar] [float] NOT NULL,
	[CurrencyDollarBay] [float] NULL,
	[CurrencyDollarSell] [float] NULL,
	[Date] [datetime] default (getDate()),
 CONSTRAINT [PK_CurrenciesRates] PRIMARY KEY CLUSTERED 
(
	[CurrencyRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [finance].[CurrenciesRates] WITH CHECK ADD  CONSTRAINT [FK_CurrenciesRates_Currencies] FOREIGN KEY([CurrencyCode])
REFERENCES [finance].[Currencies]([CurrencyCode])
GO

ALTER TABLE [finance].[CurrenciesRates] CHECK CONSTRAINT [FK_CurrenciesRates_Currencies]
GO

----------------------------
CREATE TABLE [finance].[Stakes](
	[StakeID] [int] NOT NULL IDENTITY(1,1),
	[Stake] [money] NOT NULL,
	[CurrencyCode] nchar(3) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ConditionID] [int] NOT NULL,
	[Chance] [float] NOT NULL,
	[Status] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Stakes] PRIMARY KEY CLUSTERED 
(
	[StakeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [finance].[Stakes] WITH CHECK ADD  CONSTRAINT [FK_Stakes_Currencies] FOREIGN KEY([CurrencyCode])
REFERENCES [finance].[Currencies]([CurrencyCode])
GO

ALTER TABLE [finance].[Stakes] CHECK CONSTRAINT [FK_Stakes_Currencies]
GO

ALTER TABLE [finance].[Stakes] WITH CHECK ADD  CONSTRAINT [FK_Stakes_Customers] FOREIGN KEY([CustomerID])
REFERENCES [finance].[Customers]([CustomerID])
GO

ALTER TABLE [finance].[Stakes] CHECK CONSTRAINT [FK_Stakes_Customers]
GO

ALTER TABLE [finance].[Stakes] WITH CHECK ADD  CONSTRAINT [FK_Stakes_Conditions] FOREIGN KEY([ConditionID])
REFERENCES [finance].[Conditions]([ConditionID])
GO

ALTER TABLE [finance].[Stakes] CHECK CONSTRAINT [FK_Stakes_Conditions]
GO

----------------------------
CREATE TABLE [sport].[MatchesResults](
	[MatchID] [int] NOT NULL,
	[EventID] [int] NOT NULL,
	[IsTrue] [bit] NULL,
	Primary key ([MatchID], [EventID])
 )
GO

ALTER TABLE [sport].[MatchesResults]  WITH CHECK ADD  CONSTRAINT [FK_MatchesResults_Match] FOREIGN KEY([MatchID])
REFERENCES [sport].[Matches] ([MatchID])
GO

ALTER TABLE [sport].[MatchesResults] CHECK CONSTRAINT [FK_MatchesResults_Match]
GO

ALTER TABLE [sport].[MatchesResults]  WITH CHECK ADD  CONSTRAINT [FK_MatchesResults_Consolations] FOREIGN KEY([EventID])
REFERENCES [finance].[Events] ([EventID])
GO

ALTER TABLE [sport].[MatchesResults] CHECK CONSTRAINT [FK_MatchesResults_Consolations]
GO
-----------------------------------

CREATE TABLE [finance].[Taxes](
	[TaxID] [int] NOT NULL IDENTITY(1,1),
	[Tax] nvarchar(50) NOT NULL,
	[TaxRate] [float] NOT NULL,
	[CountryCode] nchar(3) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Taxes] PRIMARY KEY CLUSTERED 
(
	[TaxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [finance].[Taxes]  WITH CHECK ADD  CONSTRAINT [FK_Taxes_Countries] FOREIGN KEY([CountryCode])
REFERENCES [location].[Countries] ([CountryCode])
GO

ALTER TABLE [finance].[Taxes] CHECK CONSTRAINT [FK_Taxes_Countries]
GO

ALTER TABLE [finance].[Taxes] ADD  CONSTRAINT [DF_Taxes_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

----------------------------
CREATE TABLE [finance].[CustomersFinanceOperations](
	[FinanceOperationID] [int] NOT NULL IDENTITY(1,1),
	[CustomerID] [int] NOT NULL,
	[FinanceOperationTyp] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[AmountCommission] [money] NOT NULL,
	[AmountTax] [money] NOT NULL,
	[FinalAmount] [money] NOT NULL,
	[CurrencyCode] nchar(3) NOT NULL,
	[StakeID] [int] null,
	[OperationDate] [datetime] not null,
 CONSTRAINT [PK_CustomersFinanceOperations] PRIMARY KEY CLUSTERED 
(
	[FinanceOperationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [finance].[CustomersFinanceOperations]  WITH CHECK ADD  CONSTRAINT [FK_CustomersFinanceOperations_Customers] FOREIGN KEY([CustomerID])
REFERENCES [finance].[Customers] ([CustomerID])
GO

ALTER TABLE [finance].[CustomersFinanceOperations] CHECK CONSTRAINT [FK_CustomersFinanceOperations_Customers]
GO

ALTER TABLE [finance].[CustomersFinanceOperations]  WITH CHECK ADD  CONSTRAINT [FK_CustomersFinanceOperations_Currencies] FOREIGN KEY([CurrencyCode])
REFERENCES [finance].[Currencies] ([CurrencyCode])
GO

ALTER TABLE [finance].[CustomersFinanceOperations] CHECK CONSTRAINT [FK_CustomersFinanceOperations_Currencies]
GO

ALTER TABLE [finance].[CustomersFinanceOperations]  WITH CHECK ADD  CONSTRAINT [FK_CustomersFinanceOperations_Stakes] FOREIGN KEY([StakeID])
REFERENCES [finance].[Stakes] ([StakeID])
GO

ALTER TABLE [finance].[CustomersFinanceOperations] CHECK CONSTRAINT [FK_CustomersFinanceOperations_Stakes]
GO

----------------------------------------------
/*
CREATE TABLE [finance].[InsideFinanceOperations](
	[FinanceOperationID] [int] NOT NULL IDENTITY(1,1),
	[CustomerOperationID] [int] NOT NULL,
	[FinanceOperationTyp] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[OperationDate] [datetime] not null,
 CONSTRAINT [PK_InsideFinanceOperations] PRIMARY KEY CLUSTERED 
(
	[FinanceOperationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [finance].[InsideFinanceOperations]  WITH CHECK ADD  CONSTRAINT [FK_InsideFinanceOperations_Currencies] FOREIGN KEY([CurrencyID])
REFERENCES [finance].[Currencies] ([CurrencyID])
GO

ALTER TABLE [finance].[InsideFinanceOperations] CHECK CONSTRAINT [FK_InsideFinanceOperations_Currencies]
GO

ALTER TABLE [finance].[InsideFinanceOperations]  WITH CHECK ADD  CONSTRAINT [FK_InsideFinanceOperations_CustomerOperations] FOREIGN KEY([CustomerOperationID])
REFERENCES [finance].[CustomersFinanceOperations] ([FinanceOperationID])
GO

ALTER TABLE [finance].[InsideFinanceOperations] CHECK CONSTRAINT [FK_InsideFinanceOperations_CustomerOperations]
GO
*/
----------------------------------------------

create view finance.CustomersBalanceView   --- view  for ballance
with schemabinding
as 
select 
	  CFO.CustomerID CustomerID,
	sum(CFO.FinalAmount) as Balance,
	max(CFO.CurrencyCode) AS CurrencyCode,
	count_big(*) as Row_Count
from finance.CustomersFinanceOperations CFO 
group by CFO.CustomerID, CFO.CurrencyCode
go

---------------------------------------------
create view finance.LastCurrencyCourse  --- view last course for each currency to dollar
with schemabinding
as 
	with MaxDate (CurrencyCode, Date)
	as
	(
		select C.CurrencyCode CurrencyCode, max(C.Date) Date
		from finance.CurrenciesRates C
		group by C.CurrencyCode
	)
	select C.CurrencyCode, C.CurrencyDollar, C.CurrencyDollarBay, C.CurrencyDollarSell
	from finance.CurrenciesRates C
		join MaxDate MD on MD.CurrencyCode = C.CurrencyCode
	where C.Date = MD.Date
go

----------------------------------------
create view finance.ConditionStakesSumView   --- view for sum for all Conditions 
with schemabinding
as 
	with  lastCurrencyDate(CurrencyCode, Date)
as
(
	select C.CurrencyCode, max(C.Date)
	from finance.CurrenciesRates C
	group by C.CurrencyCode
)
,lastCurrencyRate(CurrencyCode, CurrencyDollar)
as
(
	select C.CurrencyCode, C.CurrencyDollar
	from finance.CurrenciesRates C
		join lastCurrencyDate LCD on LCD.CurrencyCode = C.CurrencyCode
	where C.Date = LCD.Date
)
select 
		E.SportEventID, E.ConditionID, isnull(sum(S.Stake), 0)*isnull(max(C.CurrencyDollar), 1) as ConditionSum
	from finance.Conditions E
		left join finance.Stakes S on S.ConditionID = E.ConditionID
		left join lastCurrencyRate C on C.CurrencyCode = S.CurrencyCode 
	where E.IsTrue is null 
		and isnull(S.Status, 1) =  1 
	group by E.ConditionID, E.SportEventID
go


IF EXISTS (SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'sport.AfterInsertTrigger')
               AND [type] = 'TR')
BEGIN
      DROP TRIGGER sport.AfterInsertTrigger;
END
go

CREATE TRIGGER sport.AfterInsertTrigger
ON sport.MatchesResults
AFTER INSERT
AS
		;with getEvent (EventID, EventGroup, MatchID, isTrue)
		as
		(
			select E1.EventID, E1.EventGroup, I.MatchID, 0 from finance.Events E1 
				join inserted I on  E1.EventID = I.EventID and I.IsTrue = 1 
		)
		--insert into sport.MatchesResults (MatchID, EventID, IsTrue)
		, results(MatchID, EventID, isTrue)
		as
		(
			select gE.MatchID, E.EventID, gE.isTrue
			from finance.Events E join getEvent gE
				on  E.EventGroup = gE.EventGroup 
			union   (select * from inserted )
		)
		insert into sport.MatchesResults (MatchID, EventID, IsTrue)
		select R.MatchID, R.EventID, min(R.isTrue) from results R
		group by R.EventID, MatchID
		having max(R.isTrue) = 0	
GO


IF EXISTS (SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'sport.CheckConditions')
               AND [type] = 'TR')
BEGIN
      DROP TRIGGER sport.CheckConditions;
END
go
CREATE TRIGGER sport.CheckConditions
ON sport.MatchesResults
AFTER INSERT
AS
	update C
		set C.IsTrue = 1
		from  finance.Conditions C
			inner join inserted MR
				on C.SportEventID = MR.MatchID and C.EventID = MR.EventID
		where MR.IsTrue = 1

		update C
		set C.IsTrue = 0
		from  finance.Conditions C
			inner join inserted MR
				on C.SportEventID = MR.MatchID and C.EventID = MR.EventID
		where MR.IsTrue = 0		
GO

IF EXISTS (SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'finance.CheckStakes')
               AND [type] = 'TR')
BEGIN
      DROP TRIGGER finance.CheckStakes;
END
go
CREATE TRIGGER finance.CheckStakes
ON finance.Conditions
AFTER UPDATE
AS
		insert into [finance].[CustomersFinanceOperations] (CustomerID, FinanceOperationTyp, Amount, AmountCommission, AmountTax,  FinalAmount, CurrencyCode,StakeID, OperationDate)
		select S.CustomerID, 1, S.Stake/(1 - C.Chance), 0, 0, S.Stake/(1 - C.Chance), S.CurrencyCode,S.StakeID, getdate() 
		from finance.Stakes S 
			join inserted C on C.ConditionID = S.ConditionID 
		where C.IsTrue = 1 and S.Status = 1

		update S
		set S.Status = 2
		from  finance.Stakes S
			inner join inserted C
				on C.ConditionID = S.ConditionID
		where S.Status = 1 and C.IsTrue is not null
GO



