use [SportDB]
go

--валюта
exec finance.AddCurrency 'USD', 'USA dollar'
exec finance.AddCurrency 'EUR', 'Euro'
--select * from finance.Currencies
go

exec finance.UpsertCurrencyRate  'USD', 1, 1, 1, default
go
exec finance.UpsertCurrencyRate  'USD', 1, 1, 1, default
exec finance.UpsertCurrencyRate  'EUR', 1, 1, 1, default
--select * from finance.CurrenciesRates
go

--група користувачів
exec finance.UpsertCustomerGroup default, 'New Clients', 0.03, 0.05, 0.1;
exec finance.UpsertCustomerGroup default, 'Normal Clients', 0.05, 0.05, 0.09;
exec finance.UpsertCustomerGroup default, 'Old Clients', 0.04, 0.05, 0.08;
exec finance.UpsertCustomerGroup default, 'Golden Clients', 0.03, 0.03, 0.07;
select * from finance.CustomersGroups
--користувач
exec location.UpsertCountry 'UA', 'Ukraine' 
--select * from location.Countries
go

insert into finance.Taxes (Tax, TaxRate, CountryCode)
	values('tak treba', 0.005, 'UA')

select * from finance.Taxes
go

exec finance.UpsertCustomer default, 'aa1', 'my@mail', 1, 'UA', 'hash', 'salt'
--select * from finance.Customers
--select * from finance.CustomersPasswords
go

select * from finance.CustomersBalanceView
go
--кілька фін операцій
exec finance.PutCustomerMoney 1, 9.5, 'USD' ---rename !!!!!!!
exec finance.PutCustomerMoney  1, 100, 'USD'
exec finance.PutCustomerMoney 1, 45, 'EUR'
exec finance.PushCustomerMoney 1, 19.2, 'EUR'

select * from finance.CustomersBalanceView
select * from finance.CustomersFinanceOperations
go
--вид спорту
exec sport.UpsertSport default, 'football', null, 'nonolimpic'
--select * from sport.Sports
go
--турнір
exec sport.UpsertTournament default, '1 liga', null, 1
--select * from sport.Tournaments
go
--дві команди
exec sport.UpsertClub default, 'dynamo', null, 'xy@', 1
exec sport.UpsertClub default, 'miner', null, 'xy@1', 1
--select * from sport.Clubs
go
--ліга
exec sport.UpsertTeam default, 'sezon2018/2019', null,null, 1
--select * from sport.Teams
go
--3 результи
exec finance.UpsertEvent default, 'first win', null, 1
exec finance.UpsertEvent default, 'second win', null, 1
exec finance.UpsertEvent default, 'nobody win', null, 1
exec finance.UpsertEvent default, 'first not win', null, 2
exec finance.UpsertEvent default, 'second not win', null, 2
--select * from finance.Events
go

--матч
declare  @date datetime = DATEADD(s,250, getdate())
exec sport.UpsertMatch default, @date, 2, 1, null
select * from sport.Matches
go

declare  @date datetime = DATEADD(s,250, getdate())
exec sport.UpsertMatch default, @date, 2, 1, null
select * from sport.Matches
go
--три події
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
select * from finance.Conditions
go
--
select * from finance.CustomersBalanceView
select * from finance.CustomersFinanceOperations
go
--дві ставки 
/*
exec finance.AddStake 7, 'USD', 1, 1, 0;
exec finance.AddStake 5, 'USD', 1, 2, 0;
exec finance.AddStake 7, 'USD', 1, 4, 0;
exec finance.AddStake 5, 'USD', 1, 5, 0;

exec finance.AddStake 10, 'USD', 1, 6, 0;
exec finance.AddStake 4, 'USD', 1, 7, 0;
exec finance.AddStake 8, 'USD', 1, 9, 0;
exec finance.AddStake 8, 'USD', 1, 10, 0;
*/
select * from finance.ConditionStakesSumView
select * from finance.CustomersBalanceView
select * from finance.CustomersFinanceOperations
select * from finance.Stakes
select * from finance.Conditions
go

--exec finance.cangeChance;
select * from finance.ConditionStakesSumView
select * from finance.Conditions

--truncate table finance.