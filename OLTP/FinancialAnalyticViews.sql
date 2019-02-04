use [SportDB]
go

create view finance.TotalProfitReport 
with schemabinding
as 
	select sum(CFO.AmountCommission) profit, month(CFO.OperationDate) MonthOfYear, year(CFO.OperationDate) [Year]  from finance.CustomersFinanceOperations CFO
	group by year(CFO.OperationDate),  month(CFO.OperationDate)
go

----------------------------------------------------

create view finance.ProfitPerUser
with schemabinding
as 
	select C.CustomerID, C.CustomerLogin, sum(CFO.AmountCommission) profit
	from finance.CustomersFinanceOperations CFO
		join finance.Customers C
			on C.CustomerID = CFO.CustomerID
	group by C.CustomerID, C.CustomerLogin
go
------------------------------------------------

create view finance.ProfitPerUsersGroup
with schemabinding
as 
	select CG.CustomerGroup CustomerGroup, sum(CFO.AmountCommission) profit
	from finance.CustomersFinanceOperations CFO
		join finance.Customers C
			on C.CustomerID = CFO.CustomerID
		join finance.CustomersGroups CG
			on CG.CustomerGroupID = C.CustomerGroupID
	group by CG.CustomerGroup
go

------------------------------------------------

create view finance.ProfitPerUsersGroup
with schemabinding
as 
	select CG.CustomerGroup CustomerGroup, sum(CFO.AmountCommission) profit
	from finance.CustomersFinanceOperations CFO
		join sport.
	group by CG.CustomerGroup
go

---------------------------------
create view finance.TaxAmount
with schemabinding
as 
	select sum(CFO.AmountTax) TaxAmount, month(CFO.OperationDate) MonthOfYear, year(CFO.OperationDate) [Year]  from finance.CustomersFinanceOperations CFO
		group by year(CFO.OperationDate),  month(CFO.OperationDate)
go