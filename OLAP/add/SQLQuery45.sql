if object_id('tempdb..#Conditions') is not null
    drop table #Conditions

create table #Conditions (
	
	[ConditionID] [int] ,
	[SportEventID] [int],
	[EventID] [int] ,
	[Chance] [float] ,
	[IsTrue] [bit] ,
	[AvaliableTo] [datetime],
	---[ConditionGroup] [int] null,
)

insert into #Conditions ( [ConditionID], [SportEventID], [EventID], [Chance], [IsTrue], [CountryCode],  [ModifiedDate])
select  S.ConditionID, S.[ConditionLogin], S.[ConditionEmail], S.[SendMails], S.[ConditionGroupID], S.CountryCode, S.ModifiedDate  from SportDB.finance.Conditions S
	where S.ModifiedDate > (
								select ISNULL(MAX( CONVERT(datetime, DC.ValidFrom)),'2000-01-01 00:00:00.000') 
								from SportDBWH.dbo.DimConditions DC
							)

insert into SportDBWH.dbo.DimConditions 
(
	 [ConditionKey]
	, [ConditionLogin]
	, [ConditionEmail]
	, [SendMails]
	, [ConditionGroupID]
	, [CountryCode]
	, [ValidFrom]
	, [ValidTo]
)
select 
	 [ConditionID]
	, [ConditionLogin]
	, [ConditionEmail]
	, [SendMails]
	, [ConditionGroupID]
	, [CountryCode]
	, getdate()
	, NULL
from
(
	MERGE SportDBWH.dbo.DimConditions emp
	USING #Conditions ute
	ON [emp].[ConditionKey] = [ute].[ConditionID]
	WHEN NOT MATCHED THEN
	INSERT ( [ConditionKey], [ConditionLogin], [ConditionEmail], [SendMails], [ConditionGroupID], [CountryCode],  [ValidFrom])
	VALUES ( [ute].[ConditionID], [ute].[ConditionLogin], [ute].[ConditionEmail], [ute].[SendMails], [ute].[ConditionGroupID], [ute].[CountryCode], [ute].[ModifiedDate])
	WHEN MATCHED AND [ValidTo] IS NULL THEN
	  UPDATE
	  SET [emp].[ValidTo] = getdate()
	OUTPUT $Action MergeAction, 
		ute.[ConditionID] as [ConditionID],
		ute.[ConditionLogin] as [ConditionLogin],
		ute.[ConditionEmail] as [ConditionEmail],
		ute.[SendMails] as [SendMails],
		ute.[ConditionGroupID] as [ConditionGroupID],
		ute.[CountryCode] as [CountryCode]
) MergeOutput
	WHERE -- we'll filter using a where clause
          MergeAction = 'Update';

if object_id('tempdb..#Conditions') is not null
    drop table #Conditions

	select * from #Conditions
	select * from SportDBWH.dbo.DimConditions