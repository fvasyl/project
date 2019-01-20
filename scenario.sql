use [SportDB]
go

--валюта
exec finance.UpsertCurrency default, 1, 1, 1, default
exec finance.UpsertCurrency default, 1, 1, 1, default
select * from finance.Currencies
go

--група користувачів
exec finance.UpsertCustomerGroup default, 'aa', 0.05, 0.07, 0.1;
--користувач
exec finance.UpsertCustomer default, 'aa', 'bb', 'cc', 1

select * from finance.CustomersBalanceView
go
--кілька фін операцій
exec finance.UpsertCustomerFinanceOperation default, 1, 1, 10.5, 10.5, 1
exec finance.UpsertCustomerFinanceOperation default, 1, 1, 9.5, 9.5, 1
exec finance.UpsertCustomerFinanceOperation default, 1, 1, 10.5, 10.5, 2
exec finance.UpsertCustomerFinanceOperation default, 1, 2, 4.5, 4.5, 1

select * from finance.CustomersBalanceView
select * from finance.CustomersFinanceOperations
go
--вид спорту
exec sport.UpsertSport default, 'football', null, 'nonolimpic'
select * from sport.Sports
go
--турнір
exec sport.UpsertTournament default, '1 liga', null, 1
select * from sport.Tournaments
go
--дві команди
exec sport.UpsertClub default, 'dynamo', null, 'xy@', 1
exec sport.UpsertClub default, 'miner', null, 'xy@1', 1
select * from sport.Clubs
go
--ліга
exec sport.UpsertTeam default, 'sezon2018/2019', null, 1
select * from sport.Teams
go
--матч
exec sport.UpsertMatch default, '2019-01-25 01:58:43.903', 2, 1, null
select * from sport.Matches
go
--3 результи
exec finance.UpsertConsideration default, 'first win'
exec finance.UpsertConsideration default, 'second win'
exec finance.UpsertConsideration default, 'nobody win'
select * from finance.Considerations
go
--три події
exec finance.UpsertEvent default, 1, 1, 0.5, null, 1
exec finance.UpsertEvent default, 1, 2, 0.1, null, 1
exec finance.UpsertEvent default, 1, 3, 0.4, null, 1
select * from finance.Events
go
--
select * from finance.CustomersBalanceView
select * from finance.CustomersFinanceOperations
go
--дві ставки
exec finance.AddStake 7, 1, 1, 1, 1;
select * from finance.EventStakesSumView
select * from finance.CustomersBalanceView
select * from finance.CustomersFinanceOperations
select * from finance.Events
go

exec finance.cangeChance;
exec finance.AddStake 5, 1, 1, 3, 0;
select * from finance.EventStakesSumView
select * from finance.CustomersBalanceView
select * from finance.CustomersFinanceOperations
select * from finance.Events
go

exec finance.cangeChance;
select * from finance.Stakes
select * from finance.CustomersBalanceView
select * from finance.CustomersFinanceOperations
select * from finance.Events
go

insert into Sport.MatchesResults (MatchID, ConsiderationID, IsTrue)
	values (1, 1, 0), (1, 2, 0), (1, 3, 1)		

select * from sport.MatchesResults

update finance.Events
	set IsAvaliable = 0
exec finance.AddStake 0.5, 1, 1, 3, 0;
exec finance.ChangeStake 1, 1, 2, 0;
exec finance.DeleteStake 1;

select * from finance.Events
go

exec finance.ChackEvents

exec finance.ChackStakes
go

select * from finance.Stakes
select * from finance.CustomersBalanceView
select * from finance.CustomersFinanceOperations
go