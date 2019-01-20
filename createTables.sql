use [SportDB]
go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [sport].[Sports](
	[SportID] [int] NOT NULL IDENTITY(1,1),
	[Sport] [nvarchar](max) NULL,
	[SportInformation][nvarchar](max) NULL,
	[SportType] [nvarchar](max) NULL,
 CONSTRAINT [PK_Sports] PRIMARY KEY CLUSTERED 
(
	[SportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


-------------------------
CREATE TABLE [sport].[Tournaments](
	[TournamentID] [int] NOT NULL IDENTITY(1,1),
	[TournamentName] [nvarchar](max) NULL,
	[TournamentInformation][nvarchar](max) NULL,
	[SportID] [int] NOT NULL,
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

-------------------------
CREATE TABLE [sport].[Clubs](
	[ClubID] [int] NOT NULL IDENTITY(1,1),
	[Club] [nvarchar](450) NULL,
	[ClubInformation] [nvarchar](max) NULL,
	[CouchFullName] [nvarchar](150) NULL,
	[SportID] [int] NOT NULL,
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


-------------------------
CREATE TABLE [sport].[Teams](
	[TeamID] [int] NOT NULL IDENTITY(1,1),
	[Team] [nvarchar](450) NULL,
	[TeamInformation] [nvarchar](max) NULL,
	[TournamentID] [int] NOT NULL,
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

----------------------------
CREATE TABLE [finance].[CustomersGroups](
	[CustomerGroupID] [int] NOT NULL  IDENTITY(1,1),
	[CustomerGroup] [nvarchar](450) NULL,
	[CustomerGroupCommissionAddStake] [float] NULL,
	[CustomerGroupCommissionEditStake] [float] NULL,
	[CustomerGroupCommissionDeleteStake] [float] NULL,
 CONSTRAINT [PK_CustomersGroups] PRIMARY KEY CLUSTERED 
(
	[CustomerGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

----------------------------
CREATE TABLE [finance].[Customers](
	[CustomerID] [int] NOT NULL IDENTITY(1,1),
	[CustomerLogin] [nvarchar](15) NOT NULL,
	[CustomerPassword] [nvarchar](15) NOT NULL,
	[CustomerEmail] [nvarchar](25) NOT NULL,
	[SendMails] [bit] NULL DEFAULT(0),
	[CustomerGroupID] [int] NOT NULL,
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


------------------------------
CREATE TABLE [finance].[Considerations](

--maybe will add [winnerID] [int] NULL,
	[ConsiderationID] [int] NOT NULL IDENTITY(1,1),
	[Consideration] [nvarchar](15) NOT NULL,
 CONSTRAINT [PK_Considerations] PRIMARY KEY CLUSTERED 
(
	[ConsiderationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

----------------------------
CREATE TABLE [finance].[Events](
	[EventID] [int] NOT NULL IDENTITY(1,1),
	[SportEventID] [int] NOT NULL,
	[ConsiderationID] [int] NOT NULL,
	[Chance] [float] NOT NULL,
	[IsTrue] [bit] NULL,
	[IsAvaliable] [bit] NULL,
 CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [finance].[Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_Matches] FOREIGN KEY([SportEventID])
REFERENCES [sport].[Matches]([MatchID])
GO

ALTER TABLE [finance].[Events] CHECK CONSTRAINT [FK_Events_Matches]
GO

ALTER TABLE [finance].[Events] WITH CHECK ADD  CONSTRAINT [FK_Events_Considerations] FOREIGN KEY([ConsiderationID])
REFERENCES [finance].[Considerations]([ConsiderationID])
GO

ALTER TABLE [finance].[Events] CHECK CONSTRAINT [FK_Events_Considerations]
GO

-------------------------------
CREATE TABLE [finance].[Currencies](
	[CurrencyID] [int] NOT NULL IDENTITY(1,1),
	[CurrencyDollar] [float] NOT NULL,
	[CurrencyDollarBay] [float] NULL,
	[CurrencyDollarSell] [float] NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Currencies] PRIMARY KEY CLUSTERED 
(
	[CurrencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

----------------------------
CREATE TABLE [finance].[Stakes](
	[StakeID] [int] NOT NULL IDENTITY(1,1),
	[Stake] [money] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[EventID] [int] NOT NULL,
	[Chance] [float] NOT NULL,
	[Status] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Stakes] PRIMARY KEY CLUSTERED 
(
	[StakeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [finance].[Stakes] WITH CHECK ADD  CONSTRAINT [FK_Stakes_Currencies] FOREIGN KEY([CurrencyID])
REFERENCES [finance].[Currencies]([CurrencyID])
GO

ALTER TABLE [finance].[Stakes] CHECK CONSTRAINT [FK_Stakes_Currencies]
GO

ALTER TABLE [finance].[Stakes] WITH CHECK ADD  CONSTRAINT [FK_Stakes_Customers] FOREIGN KEY([CustomerID])
REFERENCES [finance].[Customers]([CustomerID])
GO

ALTER TABLE [finance].[Stakes] CHECK CONSTRAINT [FK_Stakes_Customers]
GO

ALTER TABLE [finance].[Stakes] WITH CHECK ADD  CONSTRAINT [FK_Stakes_Events] FOREIGN KEY([EventID])
REFERENCES [finance].[Events]([EventID])
GO

ALTER TABLE [finance].[Stakes] CHECK CONSTRAINT [FK_Stakes_Events]
GO

----------------------------
CREATE TABLE [finance].[CustomersFinanceOperations](
	[FinanceOperationID] [int] NOT NULL IDENTITY(1,1),
	[CustomerID] [int] NOT NULL,
	[FinanceOperationTyp] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[AmountWithTax] [money] NOT NULL,
	[CurrencyID] [int] NOT NULL,
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

ALTER TABLE [finance].[CustomersFinanceOperations]  WITH CHECK ADD  CONSTRAINT [FK_CustomersFinanceOperations_Currencies] FOREIGN KEY([CurrencyID])
REFERENCES [finance].[Currencies] ([CurrencyID])
GO

ALTER TABLE [finance].[CustomersFinanceOperations] CHECK CONSTRAINT [FK_CustomersFinanceOperations_Currencies]
GO

----------------------------
CREATE TABLE [sport].[MatchesResults](
	[MatchID] [int] NOT NULL,
	[ConsiderationID] [int] NOT NULL,
	[IsTrue] [bit] NULL,
	Primary key ([MatchID], [ConsiderationID])
 )
GO

ALTER TABLE [sport].[MatchesResults]  WITH CHECK ADD  CONSTRAINT [FK_MatchesResults_Match] FOREIGN KEY([MatchID])
REFERENCES [sport].[Matches] ([MatchID])
GO

ALTER TABLE [sport].[MatchesResults] CHECK CONSTRAINT [FK_MatchesResults_Match]
GO

ALTER TABLE [sport].[MatchesResults]  WITH CHECK ADD  CONSTRAINT [FK_MatchesResults_Consolations] FOREIGN KEY([ConsiderationID])
REFERENCES [finance].[Considerations] ([ConsiderationID])
GO

ALTER TABLE [sport].[MatchesResults] CHECK CONSTRAINT [FK_MatchesResults_Consolations]
GO
----------------------------------------------


create view finance.CustomersBalanceView   --- view  for ballance
with schemabinding
as 
select 
	  CFO.CustomerID CustomerID,
	sum(CFO.AmountWithTax) as Balance,
	max(CFO.CurrencyID) AS CurrencyID,
	count_big(*) as Row_Count
from finance.CustomersFinanceOperations CFO 
group by CFO.CustomerID, CFO.CurrencyID
go


create view finance.EventStakesSumView   --- view for sum for all events 
with schemabinding
as 
	with  lastCurrencyDate(CurrencyID, Date)
as
(
	select C.CurrencyID, max(C.Date)
	from finance.Currencies C
	group by C.CurrencyID
)
,lastCurrencyRate(currencyID, CurrencyDollar)
as
(
	select C.CurrencyID, C.CurrencyDollar
	from finance.Currencies C
		join lastCurrencyDate LCD on LCD.CurrencyID = C.CurrencyID
	where C.Date = LCD.Date
)
select 
		 E.EventID, isnull(sum(S.Stake), 0)*isnull(max(C.CurrencyDollar), 1) as EventSum
	from finance.Events E
		left join finance.Stakes S on S.EventID = E.EventID
		left join lastCurrencyRate C on C.CurrencyID = S.CurrencyID 
	where E.IsTrue is null 
		and isnull(S.Status, 1) =  1 
	group by E.EventID
go

