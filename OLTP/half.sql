USE [SportDB]
GO
DELETE FROM [finance].[Stakes]
 
GO

DELETE FROM [finance].[Conditions]
 
GO
DELETE FROM [sport].[MatchesResults]

DELETE FROM [sport].[Matches]

GO

declare  @date datetime = DATEADD(s,250, getdate())
exec sport.UpsertMatch default, @date, 2, 1, null
select * from sport.Matches
go

declare  @date datetime = DATEADD(s,250, getdate())
exec sport.UpsertMatch default, @date, 2, 1, null
select * from sport.Matches
go

exec finance.UpsertCondition default, 1, 1, 0.5, null
exec finance.UpsertCondition default, 1, 2, 0.1, null
exec finance.UpsertCondition default, 1, 3, 0.4, null
exec finance.UpsertCondition default, 1, 4, 0.5, null
exec finance.UpsertCondition default, 1, 5, 0.5, null

exec finance.UpsertCondition default, 2, 1, 0.3, null
exec finance.UpsertCondition default, 2, 2, 0.3, null
exec finance.UpsertCondition default, 2, 3, 0.4, null
exec finance.UpsertCondition default, 2, 4, 0.6, null
exec finance.UpsertCondition default, 2, 5, 0.4, null
go


insert into Sport.MatchesResults (MatchID, EventID, IsTrue)
	values  (1,3, 1),	(2,2, 1), (1,5, 1),	(2, 4, 1)


select * from sport.MatchesResults

select * from finance.Conditions