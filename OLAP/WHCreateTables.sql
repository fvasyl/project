use [SportDBWH]
go


CREATE TABLE [dbo].[DimLocations](
	[LocationID] [int] NOT NULL,
	[City] [nvarchar](max) NULL,
	[CountryCode][nvarchar](3) NULL,
	[Country][nvarchar](max) NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

--------------------
CREATE TABLE [dbo].[DimCountries](
	[CountryCode] [nvarchar](3) NOT NULL,
	[CountryEnglishName] [nvarchar](max) NULL,
	[DateOfLoading] datetime  not null,
	 
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
-------------------------

CREATE TABLE [dbo].[DimSports](
	[SportID] [int] NOT NULL  ,
	[Sport] [nvarchar](max) NULL,
	[SportType] [nvarchar](max) NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Sports] PRIMARY KEY CLUSTERED 
(
	[SportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
--------------------------------------------

CREATE TABLE [dbo].[DimTournaments](
	[TournamentID] [int] NOT NULL  ,
	[TournamentName] [nvarchar](max) NULL,
	--[SportID] [int] NOT NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Tournaments] PRIMARY KEY CLUSTERED 
(
	[TournamentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-----------------------------------------------------

CREATE TABLE [dbo].[DimClubs](
	[ClubID] [int] NOT NULL,
	[Club] [nvarchar](450) NULL,
	[CouchFullName] [nvarchar](150) NULL,
--	[SportID] [int] NOT NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Clubs] PRIMARY KEY CLUSTERED 
(
	[ClubID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

------------------------------------------

CREATE TABLE [dbo].[DimTeams](
	[TeamID] [int] NOT NULL,
	[Team] [nvarchar](450) NULL,
	[ParentTeamID] [int] NULL,
	--[TournamentID] [int] NOT NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED 
(
	[TeamID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DimTeams]  WITH CHECK ADD  CONSTRAINT [FK_Team_Team] FOREIGN KEY([ParentTeamID])
REFERENCES [dbo].[DimTeams] ([TeamID])
GO

ALTER TABLE [dbo].[DimTeams] CHECK CONSTRAINT [FK_Team_Team]
GO

----------------------------------------

CREATE TABLE [dbo].[DimArens](
	[ArenaID] [int] NOT NULL  ,
	[ArenaName] [nvarchar](max) NULL,
	[AmountOfSits] [int] NULL,
	[LocationID][int] NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Arens] PRIMARY KEY CLUSTERED 
(
	[ArenaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[DimArens]  WITH CHECK ADD  CONSTRAINT [FK_Arens_Locations] FOREIGN KEY([LocationID])
REFERENCES [dbo].[DimLocations] ([LocationID])
GO

ALTER TABLE [dbo].[DimArens] CHECK CONSTRAINT [FK_Arens_Locations]
GO
-----------------------------------------------

CREATE TABLE [dbo].[FactMatches](
	[MatchID] [int] NOT NULL  ,
	[DateMatch] [datetime] NOT NULL,
	[HomeParticipant] [int] NOT NULL,
	[AwayParticipant] [int] NOT NULL,
	[TeamID] [int] NULL,
	[ArenaID] [int] NULL,
	[SportID] [int] NULL,
	[TournamentID] [int] NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Matches] PRIMARY KEY CLUSTERED 
(
	[MatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FactMatches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Teams] FOREIGN KEY([TeamID])
REFERENCES [dbo].[DimTeams] ([TeamID])
GO

ALTER TABLE [dbo].[FactMatches] CHECK CONSTRAINT [FK_Matches_Teams]
GO

ALTER TABLE [dbo].[FactMatches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Club1] FOREIGN KEY([HomeParticipant])
REFERENCES [dbo].[DimClubs] ([ClubID])
GO

ALTER TABLE [dbo].[FactMatches] CHECK CONSTRAINT [FK_Matches_Club1]
GO

ALTER TABLE [dbo].[FactMatches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Club2] FOREIGN KEY([AwayParticipant])
REFERENCES [dbo].[DimClubs] ([ClubID])
GO

ALTER TABLE [dbo].[FactMatches] CHECK CONSTRAINT [FK_Matches_Club2]
GO

ALTER TABLE [dbo].[FactMatches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_SportArens] FOREIGN KEY([ArenaID])
REFERENCES [dbo].[DimArens] ([ArenaID])
GO

ALTER TABLE [dbo].[FactMatches] CHECK CONSTRAINT [FK_Matches_SportArens]
GO

ALTER TABLE [dbo].[FactMatches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Sports] FOREIGN KEY([SportID])
REFERENCES [dbo].[DimSports] ([SportID])
GO

ALTER TABLE [dbo].[FactMatches] CHECK CONSTRAINT [FK_Matches_Sports]
GO

ALTER TABLE [dbo].[FactMatches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Tournaments] FOREIGN KEY([TournamentID])
REFERENCES [dbo].[DimTournaments] ([TournamentID])
GO

ALTER TABLE [dbo].[FactMatches] CHECK CONSTRAINT [FK_Matches_Tournaments]
GO

----------------------------------------

CREATE TABLE [dbo].[DimEvents](

--maybe will add [winnerID] [int] NULL,
	[EventID] [int] NOT NULL  ,
	[Event] [nvarchar](15) NOT NULL,
	[SportID] [int] Null,
	[EventGroup] [int] null,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DimEvents] WITH CHECK ADD  CONSTRAINT [FK_Events_Sport] FOREIGN KEY([SportID])
REFERENCES [dbo].[DimSports] ([SportID])
GO

ALTER TABLE [dbo].[DimEvents] CHECK CONSTRAINT [FK_Events_Sport]
GO

---------------------------------------------

CREATE TABLE [dbo].[DimConditions](
	[ConditionID] [int] NOT NULL,
	[SportEventID] [int] NOT NULL,
	[EventID] [int] NOT NULL,
	[Chance] [float] NOT NULL,
	[IsTrue] [bit] NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Conditions] PRIMARY KEY CLUSTERED 
(
	[ConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DimConditions]  WITH CHECK ADD  CONSTRAINT [FK_Conditions_Matches] FOREIGN KEY([SportEventID])
REFERENCES [dbo].[FactMatches]([MatchID])
GO

ALTER TABLE [dbo].[DimConditions] CHECK CONSTRAINT [FK_Conditions_Matches]
GO

ALTER TABLE [dbo].[DimConditions] WITH CHECK ADD  CONSTRAINT [FK_Conditions_Events] FOREIGN KEY([EventID])
REFERENCES [dbo].[DimEvents]([EventID])
GO

ALTER TABLE [dbo].[DimConditions] CHECK CONSTRAINT [FK_Conditions_Events]
GO

-------------------------------------------

CREATE TABLE [dbo].[DimCustomersGroups](
	[CustomerGroupID] [int] NOT NULL   ,
	[CustomerGroup] [nvarchar](450) NULL,
	[CustomerGroupCommissionAddStake] [float] NULL,
	[CustomerGroupCommissionEditStake] [float] NULL,
	[CustomerGroupCommissionDeleteStake] [float] NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_CustomersGroups] PRIMARY KEY CLUSTERED 
(
	[CustomerGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
---------------------------------------------

CREATE TABLE [dbo].[DimCustomers](
	[CustomerID] [int] NOT NULL  ,
	[CustomerLogin] [nvarchar](50) NOT NULL,
	[CustomerEmail] [nvarchar](50) NOT NULL,
	[SendMails] [bit] NULL DEFAULT(0),
	[CustomerGroupID] [int] NOT NULL,
	[CountryCode] [nvarchar] (3) NuLL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DimCustomers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_CustomersGroups] FOREIGN KEY([CustomerGroupID])
REFERENCES [dbo].[DimCustomersGroups] ([CustomerGroupID])
GO

ALTER TABLE [dbo].[DimCustomers] CHECK CONSTRAINT [FK_Customers_CustomersGroups]
GO

ALTER TABLE [dbo].[DimCustomers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Countries] FOREIGN KEY([CountryCode])
REFERENCES [dbo].[DimCountries] ([CountryCode])
GO

ALTER TABLE [dbo].[DimCustomers] CHECK CONSTRAINT [FK_Customers_Countries]
GO

---------------------------------------------------

CREATE TABLE [dbo].[DimTaxes](
	[TaxID] [int] NOT NULL  ,
	[Tax] nvarchar(50) NOT NULL,
	[TaxRate] [float] NOT NULL,
	[CountryCode] [nvarchar](3) NOT NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Taxes] PRIMARY KEY CLUSTERED 
(
	[TaxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DimTaxes]  WITH CHECK ADD  CONSTRAINT [FK_Taxes_Countries] FOREIGN KEY([CountryCode])
REFERENCES [dbo].[DimCountries] ([CountryCode])
GO

ALTER TABLE [dbo].[DimTaxes] CHECK CONSTRAINT [FK_Taxes_Countries]
GO

----------------------------------------

CREATE TABLE [dbo].[DimCurrencies](
	[CurrencyCode] nchar(3) not null,
	[CurrencyName] [nvarchar] (50) Null,
 CONSTRAINT [PK_Currencies] PRIMARY KEY CLUSTERED 
(
	[CurrencyCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
---------------------------------------------

CREATE TABLE [dbo].[DimCurrenciesRates](
	[CurrencyRateID] [int] NOT NULL  ,
	[CurrencyCode] nchar(3) not null,
	[CurrencyDollar] [float] NOT NULL,
	[CurrencyDollarBay] [float] NULL,
	[CurrencyDollarSell] [float] NULL,
	[Date] [datetime] not null,
 CONSTRAINT [PK_CurrenciesRates] PRIMARY KEY CLUSTERED 
(
	[CurrencyRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DimCurrenciesRates] WITH CHECK ADD  CONSTRAINT [FK_CurrenciesRates_Currencies] FOREIGN KEY([CurrencyCode])
REFERENCES [dbo].[DimCurrencies]([CurrencyCode])
GO

ALTER TABLE [dbo].[DimCurrenciesRates] CHECK CONSTRAINT [FK_CurrenciesRates_Currencies]
GO

--------------------------------------------

CREATE TABLE [dbo]. [FactStakes](
	[StakeID] [int] NOT NULL  ,
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

ALTER TABLE [dbo]. [FactStakes] WITH CHECK ADD  CONSTRAINT [FK_Stakes_Currencies] FOREIGN KEY([CurrencyCode])
REFERENCES [dbo].[DimCurrencies]([CurrencyCode])
GO

ALTER TABLE [dbo]. [FactStakes] CHECK CONSTRAINT [FK_Stakes_Currencies]
GO

ALTER TABLE [dbo]. [FactStakes] WITH CHECK ADD  CONSTRAINT [FK_Stakes_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[DimCustomers]([CustomerID])
GO

ALTER TABLE [dbo]. [FactStakes] CHECK CONSTRAINT [FK_Stakes_Customers]
GO

ALTER TABLE [dbo]. [FactStakes] WITH CHECK ADD  CONSTRAINT [FK_Stakes_Conditions] FOREIGN KEY([ConditionID])
REFERENCES [dbo].[DimConditions]([ConditionID])
GO

ALTER TABLE [dbo]. [FactStakes] CHECK CONSTRAINT [FK_Stakes_Conditions]
GO

----------------------------------------

CREATE TABLE [dbo].[FactCustomersFinanceOperations](
	[FinanceOperationID] [int] NOT NULL,
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

ALTER TABLE [dbo].[FactCustomersFinanceOperations]  WITH CHECK ADD  CONSTRAINT [FK_CustomersFinanceOperations_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[DimCustomers] ([CustomerID])
GO

ALTER TABLE [dbo].[FactCustomersFinanceOperations] CHECK CONSTRAINT [FK_CustomersFinanceOperations_Customers]
GO

ALTER TABLE [dbo].[FactCustomersFinanceOperations]  WITH CHECK ADD  CONSTRAINT [FK_CustomersFinanceOperations_Currencies] FOREIGN KEY([CurrencyCode])
REFERENCES [dbo].[DimCurrencies] ([CurrencyCode])
GO

ALTER TABLE [dbo].[FactCustomersFinanceOperations] CHECK CONSTRAINT [FK_CustomersFinanceOperations_Currencies]
GO

ALTER TABLE [dbo].[FactCustomersFinanceOperations]  WITH CHECK ADD  CONSTRAINT [FK_CustomersFinanceOperations_Stakes] FOREIGN KEY([StakeID])
REFERENCES [dbo].[FactStakes] ([StakeID])
GO

ALTER TABLE [dbo].[FactCustomersFinanceOperations] CHECK CONSTRAINT [FK_CustomersFinanceOperations_Stakes]
GO

----------------------------------------

CREATE TABLE [dbo].[FactMatchesResults](
	[MatchID] [int] NOT NULL,
	[EventID] [int] NOT NULL,
	[IsTrue] [bit] NULL,
	Primary key ([MatchID], [EventID])
 )
GO

ALTER TABLE [dbo].[FactMatchesResults]  WITH CHECK ADD  CONSTRAINT [FK_MatchesResults_Match] FOREIGN KEY([MatchID])
REFERENCES [dbo].[FactMatches] ([MatchID])
GO

ALTER TABLE [dbo].[FactMatchesResults] CHECK CONSTRAINT [FK_MatchesResults_Match]
GO

ALTER TABLE [dbo].[FactMatchesResults]  WITH CHECK ADD  CONSTRAINT [FK_MatchesResults_Consolations] FOREIGN KEY([EventID])
REFERENCES [dbo].[DimEvents] ([EventID])
GO

ALTER TABLE [dbo].[FactMatchesResults] CHECK CONSTRAINT [FK_MatchesResults_Consolations]
GO

