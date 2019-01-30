use [SportDBWH]
go

CREATE TABLE [dbo].[Location](
	[LocationID] [int] NOT NULL IDENTITY(1,1),
	[LocationKey] [int] NOT NULL,
	[City] [nvarchar](max) NULL,
	[Country][nvarchar](max) NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

------------------------------------

CREATE TABLE [dbo].[Arens](
	[ArenaID] [int] NOT NULL IDENTITY(1,1),
	[ArenaKey] [int] NOT NULL,
	[ArenaName] [nvarchar](max) NULL,
	[LocationID][nvarchar](max) NULL,
	[DateOfLoading] datetime  not null,
 CONSTRAINT [PK_Arens] PRIMARY KEY CLUSTERED 
(
	[ArenaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [sport].[Tournaments]  WITH CHECK ADD  CONSTRAINT [FK_Tournament_Sport] FOREIGN KEY([SportID])
REFERENCES [sport].[Sports] ([SportID])
GO

ALTER TABLE [sport].[Tournaments] CHECK CONSTRAINT [FK_Tournament_Sport]
GO
