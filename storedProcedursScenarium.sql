use [SportDB]
go

/*
	[FinanceOperationID] [int] NOT NULL IDENTITY(1,1),
	[CustomerID] [int] NOT NULL,
	[FinanceOperationTyp] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[AmountWithTax] [money] NOT NULL,
	[CurrencyID] [int] NOT NULL,
*/


IF OBJECT_ID ( 'finance.UpsertCustomerFinanceOperation', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.UpsertCustomerFinanceOperation;  
GO
create procedure finance.UpsertCustomerFinanceOperation
		@FinanceOperationID int = null,
		@CustomerID int = null, 
		@FinanceOperationTyp int = null,
		@Amount money = null,
		@AmountWithTax money = null,
		@CurrencyID int = null
as
begin try
	set nocount, xact_abort on

	if isnull(@CustomerID,'') = '' or
		isnull(@FinanceOperationTyp,'') = '' or
		isnull(@Amount, 0) = 0 or
		isnull(@AmountWithTax, 0) = 0 or
		isnull(@CurrencyID, 0) = 0 
		throw 50000, 'Invalid parameter', 1



	if (isnull(@FinanceOperationID,'') = '' and 
			@FinanceOperationTyp = 2 and
			(exists(select top (1) * 
					from  finance.CustomersBalanceView BV
					where (BV.CustomerID = @CustomerID and BV.CurrencyID = @CurrencyID and  BV.Balance - @AmountWithTax < 0)))) 
	throw 50000, 'don`t have enough money in this currency', 1
	else if (isnull(@FinanceOperationID,'') <> '' and 
		 @FinanceOperationTyp = 2 and
		 (exists(select top (1) * 
					from  finance.CustomersBalanceView BV
					where (BV.CustomerID = @CustomerID and BV.CurrencyID = @CurrencyID and  BV.Balance - @AmountWithTax + 
						(select FC.AmountWithTax 
						from finance.CustomersFinanceOperations FC 
						where FC.FinanceOperationID = @FinanceOperationID) < 0)))) 
	throw 50000, 'don`t have enough money in this currency', 1

	begin tran

		if  @FinanceOperationTyp = 2
		begin
			set @Amount = 0 - @Amount
			set @AmountWithTax = 0 - @AmountWithTax
		end

		if isnull(@FinanceOperationID,'') = ''
			insert into [finance].[CustomersFinanceOperations] (CustomerID, FinanceOperationTyp, Amount, AmountWithTax, CurrencyID, OperationDate)
			values (@CustomerID, @FinanceOperationTyp, @Amount, @AmountWithTax, @CurrencyID, getdate());
		else
			update [finance].[CustomersFinanceOperations]
			set [finance].[CustomersFinanceOperations].CustomerID = @CustomerID,
				[finance].[CustomersFinanceOperations].FinanceOperationTyp = @FinanceOperationTyp,
				[finance].[CustomersFinanceOperations].Amount = @Amount,
				[finance].[CustomersFinanceOperations].AmountWithTax = @AmountWithTax,
				[finance].[CustomersFinanceOperations].CurrencyID = @CurrencyID,
				[finance].[CustomersFinanceOperations].OperationDate = getDate()
			where [finance].[CustomersFinanceOperations].FinanceOperationID = @FinanceOperationID

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go
---------------------------------

/*
[StakeID] [int] NOT NULL IDENTITY(1,1),
	[Stake] [money] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[EventID] [int] NOT NULL,
	[Chance] [float] NOT NULL,
	[Status] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
*/
IF OBJECT_ID ( 'finance.AddStake', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.AddStake;  
GO
create procedure finance.AddStake
		@Stake money = null,
		@CurrencyID int = null, 
		@CustomerID int = null,
		@EventID int = null,
		@Chance float = null
as
begin try
	set nocount, xact_abort on

	if isnull(@Stake,0) = 0 or
		isnull(@CurrencyID,'') = '' or
		isnull(@CustomerID, 0) = 0 or
		isnull(@EventID, 0) = 0 
		throw 50000, 'Invalid parameters', 1

	if	(exists(select top (1) * 
				from  finance.CustomersBalanceView BV join finance.Customers C
					on BV.CustomerID = C.CustomerID
				join finance.CustomersGroups CG
					on C.CustomerGroupID = CG.CustomerGroupID
				where (BV.CustomerID = @CustomerID and BV.CurrencyID = @CurrencyID and  BV.Balance - @Stake*(1 + CG.CustomerGroupCommissionAddStake) < 0))) 
	throw 50000, 'don`t have enough money in this currency', 1

	if (exists(select top(1) * from finance.Events E where E.EventID = @EventID and E.IsAvaliable = 0))
		throw 50000, 'this event is not avaliable', 1

	declare @CustomerGroupCommissionAddStake float = (select top(1) CG.CustomerGroupCommissionAddStake
													from  finance.CustomersBalanceView BV 
														join finance.Customers C
															on BV.CustomerID = C.CustomerID
														join finance.CustomersGroups CG
															on C.CustomerGroupID = CG.CustomerGroupID
					 								where C.CustomerID = @CustomerID)

	declare @StakeRate money = @Stake * (1 + @CustomerGroupCommissionAddStake)

	begin tran

			insert into [finance].[Stakes] (Stake, CurrencyID, CustomerID, EventID, Chance, Status, Date)
			values (@Stake, @CurrencyID, @CustomerID, @EventID, @Chance, 1, GETDATE());

			exec finance.UpsertCustomerFinanceOperation default, @CustomerID, 2, @Stake, @StakeRate, @CurrencyID

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go
-------------------------------------

IF OBJECT_ID ( 'finance.ChangeStake', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.ChangeStake;  
GO
create procedure finance.ChangeStake
		@StakeID int = null,
		@Stake money = null,
		@EventID int = null,
		@Chance float = 0
as
begin try
	set nocount, xact_abort on

	if  isnull(@StakeID,0) = 0 or
		isnull((select top(1) S.Stake from finance.Stakes S where S.StakeID = @StakeID),0) = 0 or
		isnull(@Stake,0) = 0 or
		isnull(@EventID, 0) = 0 
		throw 50000, 'Invalid parameters', 1

	declare @chash money = (select S.Stake from finance.Stakes S where S.StakeID = @StakeID),
			@CurrencyID int = (select S.CurrencyID from finance.Stakes S where S.StakeID = @StakeID), 
			@CustomerID int = (select S.CustomerID from finance.Stakes S where S.StakeID = @StakeID)

	if	(exists(select top (1) * 
				from  finance.CustomersBalanceView BV join finance.CustomersGroups CG
					on BV.CustomerID = CG.CustomerGroupID
				where (BV.CustomerID = @CustomerID and BV.CurrencyID = @CurrencyID and  BV.Balance - @Stake*(1 + CG.CustomerGroupCommissionEditStake) + @chash < 0))) 
	throw 50000, 'don`t have enough money in this currency', 1

	if (exists(select top(1) * from finance.Events E where E.EventID = @EventID and E.IsAvaliable = 0))
		throw 50000, 'you cannot change stake whith this event', 1


	declare @CustomerGroupCommissionEditStake float = (select top(1) CG.CustomerGroupCommissionEditStake
													from  finance.CustomersBalanceView BV 
														join finance.Customers C
															on BV.CustomerID = C.CustomerID
														join finance.CustomersGroups CG
															on C.CustomerGroupID = CG.CustomerGroupID
					 								where C.CustomerID = @CustomerID)

	declare @StakeRate money = @Stake * (1 + @CustomerGroupCommissionEditStake)

	begin tran

			update [finance].[Stakes] 
			set Stake = @Stake, 
			EventID = @EventID, 
			Chance = @Chance, 
			Date =  GETDATE()
			where [finance].[Stakes].StakeID =  @StakeID;

			exec finance.UpsertCustomerFinanceOperation default, @CustomerID, 1, @chash, @chash, @CurrencyID
			exec finance.UpsertCustomerFinanceOperation default, @CustomerID, 2, @Stake, @StakeRate, @CurrencyID

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go
-------------------------------------


IF OBJECT_ID ( 'finance.DeleteStake', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.DeleteStake;  
GO
create procedure finance.DeleteStake
		@StakeID int = null
as
begin try
	set nocount, xact_abort on

	if  isnull(@StakeID,0) = 0 or
		isnull((select top(1) S.Stake from finance.Stakes S where S.StakeID = @StakeID), 0) = 0
		throw 50000, 'Invalid parameter', 1

	if (exists(select top(1) * 
				from finance.Events E 
					join finance.Stakes S on S.EventID = E.EventID 
				where S.StakeID = @StakeID and E.IsAvaliable = 0))
		throw 50000, 'this event is not avaliable', 1

	declare @chash money = (select S.Stake from finance.Stakes S where S.StakeID = @StakeID),
		@CurrencyID int = (select S.CurrencyID from finance.Stakes S where S.StakeID = @StakeID), 
		@CustomerID int = (select S.CustomerID from finance.Stakes S where S.StakeID = @StakeID)

	declare @CustomerGroupCommissionDeleteStake float = (select top(1) CG.CustomerGroupCommissionDeleteStake
													from  finance.CustomersBalanceView BV 
														join finance.Customers C
															on BV.CustomerID = C.CustomerID
														join finance.CustomersGroups CG
															on C.CustomerGroupID = CG.CustomerGroupID
					 								where C.CustomerID = @CustomerID)

	declare @StakeRate money = @chash * (1 - @CustomerGroupCommissionDeleteStake)

	begin tran

		delete from  [finance].[Stakes] 
		where finance.Stakes.StakeID = @StakeID
		
		exec finance.UpsertCustomerFinanceOperation default, @CustomerID, 1, @chash, @StakeRate, @CurrencyID
	
	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go
------------------------------------

IF OBJECT_ID ( 'finance.cangeChance', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.cangeChance;  
GO
create procedure finance.cangeChance
as
begin try
	set nocount, xact_abort on

	declare @CountByEventByConciderationType int = 3

	declare @Sume  money = (select sum(E.EventSum)+30 from finance.EventStakesSumView E)

	begin tran

		update finance.Events 
		set Chance = (ESS.EventSum + 10) / @Sume
		from finance.Events E
			inner join finance.EventStakesSumView ESS
				on E.EventID = ESS.EventID

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go


/*
[EventID] [int] NOT NULL IDENTITY(1,1),
	[SportEventID] [int] NOT NULL,
	[ConsiderationID] [int] NOT NULL,
	[Chance] [float] NOT NULL,
	[IsTrue] [bit] NULL,

*/

IF OBJECT_ID ( 'finance.ChackStakes', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.ChackStakes;  
GO
create procedure finance.ChackStakes
as
begin try
	set nocount, xact_abort on

	begin tran
		
		insert into [finance].[CustomersFinanceOperations] (CustomerID, FinanceOperationTyp, Amount, AmountWithTax, CurrencyID, OperationDate)
		select S.CustomerID, 1, S.Stake/(1 - E.Chance), S.Stake/(1 - E.Chance), S.CurrencyID, getdate() 
		from finance.Stakes S 
			join finance.Events E on E.EventID = S.EventID 
		where E.IsTrue = 1 and S.Status = 1

		update S
		set S.Status = 2
		from  finance.Stakes S
			inner join finance.Events E
				on E.EventID = S.EventID
		where S.Status = 1 and E.IsTrue is not null

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go
----------------------------------

IF OBJECT_ID ( 'sport.UpsertMatcheResult', 'P' ) IS NOT NULL   ---ADD or Change MatcheResult  
    DROP PROCEDURE sport.UpsertMatcheResult;  
GO
create procedure sport.UpsertMatcheResult 

	@MatchID int = null, 
	@ConsiderationID int = null,
	@IsTrue bit = null
as
	begin try
		set nocount, xact_abort on

		if  isnull(@ConsiderationID,'') = '' or
			isnull(@MatchID,'') = ''
			throw 50000, 'Invalid parameters', 1

		insert into sport.MatchesResults(MatchID, ConsiderationID, IsTrue)
		values (@MatchID, @ConsiderationID, @IsTrue)

	end try
	begin catch
		throw
	end catch
go
--------------------------------------------

IF OBJECT_ID ( 'finance.ChackEvents', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.ChackEvents;  
GO
create procedure finance.ChackEvents
as
begin try
	set nocount, xact_abort on

	begin tran

		update E
		set E.IsTrue = 1
		from  finance.Events E
			inner join sport.MatchesResults MR
				on E.SportEventID = MR.MatchID and E.ConsiderationID = MR.ConsiderationID
		where MR.IsTrue = 1

		update E
		set E.IsTrue = 0
		from  finance.Events E
			inner join sport.MatchesResults MR
				on E.SportEventID = MR.MatchID and E.ConsiderationID = MR.ConsiderationID
		where MR.IsTrue = 0

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go
----------------------------------