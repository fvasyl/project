use [SportDB]
go

/*
	[FinanceOperationID] [int] NOT NULL IDENTITY(1,1),
	[CustomerID] [int] NOT NULL,
	[FinanceOperationTyp] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[AmountWithTax] [money] NOT NULL,
	[CurrencyCode] [int] NOT NULL,
*/


IF OBJECT_ID ( 'finance.UpsertCustomerFinanceOperation', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.UpsertCustomerFinanceOperation;  
GO
create procedure finance.UpsertCustomerFinanceOperation
		@FinanceOperationID int = null,
		@CustomerID int = null, 
		@FinanceOperationTyp int = null,
		@Amount money = null,
		@AmountCommission money = null,
		@AmountTax money = null,
		@FinalAmount money = null,
		@CurrencyCode nchar(3) = null,
		@StakeID int = null
as
begin try
	set nocount, xact_abort on

	if isnull(@CustomerID,'') = '' or
		isnull(@FinanceOperationTyp,'') = '' or
		isnull(@Amount, '') = '' or
		@AmountCommission is null or
		@AmountTax is null or
		isnull(@FinalAmount, '') = '' or
		isnull(@CurrencyCode, '') = '' 
		throw 50000, 'Invalid parameter', 1


	if (isnull(@FinanceOperationID,'') = '' and 
			@FinanceOperationTyp = 2 and
			(exists(select top (1) * 
					from  finance.CustomersBalanceView BV
					where (BV.CustomerID = @CustomerID and BV.CurrencyCode = @CurrencyCode and  BV.Balance - @FinalAmount < 0)))) 
	throw 50000, 'don`t have enough money in this currency', 1
	else if (isnull(@FinanceOperationID,'') <> '' and 
		 @FinanceOperationTyp = 2 and
		 (exists(select top (1) * 
					from  finance.CustomersBalanceView BV
					where (BV.CustomerID = @CustomerID and BV.CurrencyCode = @CurrencyCode and  BV.Balance - @FinalAmount + 
						(select FC.FinalAmount 
						from finance.CustomersFinanceOperations FC 
						where FC.FinanceOperationID = @FinanceOperationID) < 0)))) 
	throw 50000, 'don`t have enough money in this currency', 1

	begin tran

		if  @FinanceOperationTyp = 2
		begin
			set @Amount = 0 - @Amount
			set @FinalAmount = 0 - @FinalAmount
		end

		if isnull(@FinanceOperationID,'') = ''
			insert into [finance].[CustomersFinanceOperations] (CustomerID, FinanceOperationTyp, Amount, AmountCommission, AmountTax, FinalAmount, CurrencyCode, StakeID, OperationDate)
			values (@CustomerID, @FinanceOperationTyp, @Amount,@AmountCommission, @AmountTax, @FinalAmount, @CurrencyCode, @StakeID, getdate());
		else
			update [finance].[CustomersFinanceOperations]
			set [finance].[CustomersFinanceOperations].CustomerID = @CustomerID,
				[finance].[CustomersFinanceOperations].FinanceOperationTyp = @FinanceOperationTyp,
				[finance].[CustomersFinanceOperations].Amount = @Amount,
				[finance].[CustomersFinanceOperations].AmountCommission = @AmountCommission,
				[finance].[CustomersFinanceOperations].AmountTax = @AmountTax,
				[finance].[CustomersFinanceOperations].FinalAmount = FinalAmount,
				[finance].[CustomersFinanceOperations].CurrencyCode = @CurrencyCode,
				[finance].[CustomersFinanceOperations].StakeID = @StakeID,
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
IF OBJECT_ID ( 'finance.PutCustomerMoney', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.PutCustomerMoney;  
GO
create procedure finance.PutCustomerMoney
		@CustomerID int = null, 
		@Amount money = null,
		@CurrencyCode nchar(3) = null
as
begin try
	set nocount, xact_abort on

	if isnull(@CustomerID,'') = '' or
		isnull(@Amount, '') = '' or
		isnull(@CurrencyCode, '') = '' 
		throw 50000, 'Invalid parameter', 1

	begin tran

		declare @AmountTax money = (select top (1) T.TaxRate
							  from finance.Taxes T 
							  where T.CountryCode = (select C.CountryCode from finance.Customers C where C.CustomerID = @CustomerID)) * @Amount

		declare @AmountCommission money = 0
		declare @FinalAmount money = @Amount - @AmountTax - @AmountCommission
		
		exec finance.UpsertCustomerFinanceOperation default, @CustomerID, 1, @Amount, @AmountCommission, @AmountTax, @FinalAmount, @CurrencyCode, null

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go

---------------------------------
IF OBJECT_ID ( 'finance.PushCustomerMoney', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.PushCustomerMoney;  
GO
create procedure finance.PushCustomerMoney
		@CustomerID int = null, 
		@Amount money = null,
		@CurrencyCode nchar(3) = null
as
begin try
	set nocount, xact_abort on

	if isnull(@CustomerID,'') = '' or
		isnull(@Amount, '') = '' or
		isnull(@CurrencyCode, '') = '' 
		throw 50000, 'Invalid parameter', 1

	begin tran

		declare @AmountTax money = (select top (1) T.TaxRate
							  from finance.Taxes T 
							  where T.CountryCode = (select C.CountryCode from finance.Customers C where C.CustomerID = @CustomerID)) * @Amount

		declare @AmountCommission money = 0
		declare @FinalAmount money = @Amount + @AmountTax + @AmountCommission
		
		exec finance.UpsertCustomerFinanceOperation default, @CustomerID, 2, @Amount, @AmountCommission, @AmountTax, @FinalAmount, @CurrencyCode, null

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go
-------------------------------
/*
[StakeID] [int] NOT NULL IDENTITY(1,1),
	[Stake] [money] NOT NULL,
	[CurrencyCode] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ConditionID] [int] NOT NULL,
	[Chance] [float] NOT NULL,
	[Status] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
*/
IF OBJECT_ID ( 'finance.AddStake', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.AddStake;  
GO
create procedure finance.AddStake
		@Stake money = null,
		@CurrencyCode nchar(3) = null, 
		@CustomerID int = null,
		@ConditionID int = null,
		@Chance float = null
as
begin try
	set nocount, xact_abort on

	if isnull(@Stake,0) = 0 or
		isnull(@CurrencyCode,'') = '' or
		isnull(@CustomerID, 0) = 0 or
		isnull(@ConditionID, 0) = 0 
		throw 50000, 'Invalid parameters', 1

	if	(exists(select top (1) * 
				from  finance.CustomersBalanceView BV join finance.Customers C
					on BV.CustomerID = C.CustomerID
				join finance.CustomersGroups CG
					on C.CustomerGroupID = CG.CustomerGroupID
				where (BV.CustomerID = @CustomerID and BV.CurrencyCode = @CurrencyCode and  BV.Balance - @Stake*(1 + CG.CustomerGroupCommissionAddStake) < 0))) 
	throw 50000, 'don`t have enough money in this currency', 1

	if exists(select top(1) * from finance.Conditions C where C.ConditionID = @ConditionID and getdate()>= C.AvaliableTo)
		throw 50000, 'this Condition is not avaliable', 1

	declare @CustomerGroupCommissionAddStake float = (select top(1) CG.CustomerGroupCommissionAddStake
													from  finance.CustomersBalanceView BV 
														join finance.Customers C
															on BV.CustomerID = C.CustomerID
														join finance.CustomersGroups CG
															on C.CustomerGroupID = CG.CustomerGroupID
					 								where C.CustomerID = @CustomerID)

	declare @StakeCommission money = @Stake *  @CustomerGroupCommissionAddStake
	declare @StakeTax money = 0                                                  -- change if there is tax for add stake
	declare @StakeFinal money = @StakeTax + @Stake + @StakeCommission

	begin tran

			insert into [finance].[Stakes] (Stake, CurrencyCode, CustomerID, ConditionID, Chance, Status, Date)
			values (@Stake, @CurrencyCode, @CustomerID, @ConditionID, @Chance, 1, GETDATE());

			exec finance.UpsertCustomerFinanceOperation default, @CustomerID, 2, @Stake, @StakeCommission, @StakeTax, @StakeFinal, @CurrencyCode, @@identity

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
		@ConditionID int = null,
		@Chance float = null
as
begin try
	set nocount, xact_abort on

	if  isnull(@StakeID,0) = 0 or
		isnull((select top(1) S.Stake from finance.Stakes S where S.StakeID = @StakeID),0) = 0 or
		isnull(@Stake,0) = 0 or
		isnull(@ConditionID, 0) = 0 or
		isnull((select top(1) C.ConditionID from finance.Conditions C where C.ConditionID = @ConditionID),0) = 0 
		throw 50000, 'Invalid parameters', 1

	declare @chash money = (select S.Stake from finance.Stakes S where S.StakeID = @StakeID),
			@CurrencyCode nchar(3) = (select S.CurrencyCode from finance.Stakes S where S.StakeID = @StakeID), 
			@CustomerID int = (select S.CustomerID from finance.Stakes S where S.StakeID = @StakeID)

	if	(exists(select top (1) * 
				from  finance.CustomersBalanceView BV join finance.CustomersGroups CG
					on BV.CustomerID = CG.CustomerGroupID
				where (BV.CustomerID = @CustomerID and BV.CurrencyCode = @CurrencyCode and  BV.Balance - @Stake*(1 + CG.CustomerGroupCommissionEditStake) + @chash < 0))) 
	throw 50000, 'don`t have enough money in this currency', 1

	if (exists(select top(1) * from finance.Conditions C where C.ConditionID = @ConditionID and getdate()>= C.AvaliableTo))
		throw 50000, 'you cannot change stake whith this Condition', 1


	declare @CustomerGroupCommissionEditStake float = (select top(1) CG.CustomerGroupCommissionEditStake
													from  finance.CustomersBalanceView BV 
														join finance.Customers C
															on BV.CustomerID = C.CustomerID
														join finance.CustomersGroups CG
															on C.CustomerGroupID = CG.CustomerGroupID
					 								where C.CustomerID = @CustomerID)

	declare @StakeCommission money = @Stake *  @CustomerGroupCommissionEditStake
	declare @StakeTax money = 0                                                  -- change if there is tax for add stake
	declare @StakeFinal money = @StakeTax + @Stake + @StakeCommission


	begin tran

			update [finance].[Stakes] 
			set Stake = @Stake, 
			ConditionID = @ConditionID, 
			Chance = @Chance, 
			Date =  GETDATE()
			where [finance].[Stakes].StakeID =  @StakeID;

			exec finance.UpsertCustomerFinanceOperation default, @CustomerID, 1, @chash, 0,  0,  @chash, @CurrencyCode
			exec finance.UpsertCustomerFinanceOperation default, @CustomerID, 2, @Stake, @StakeCommission, @StakeTax, @StakeFinal, @CurrencyCode

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
				from finance.Conditions C 
					join finance.Stakes S on S.ConditionID = C.ConditionID 
				where S.StakeID = @StakeID and getdate()>= C.AvaliableTo))
		throw 50000, 'this Condition is not avaliable', 1

	declare @chash money = (select S.Stake from finance.Stakes S where S.StakeID = @StakeID),
		@CurrencyCode nvarchar(3) = (select S.CurrencyCode from finance.Stakes S where S.StakeID = @StakeID), 
		@CustomerID int = (select S.CustomerID from finance.Stakes S where S.StakeID = @StakeID)

	declare @CustomerGroupCommissionDeleteStake float = (select top(1) CG.CustomerGroupCommissionDeleteStake
													from  finance.CustomersBalanceView BV 
														join finance.Customers C
															on BV.CustomerID = C.CustomerID
														join finance.CustomersGroups CG
															on C.CustomerGroupID = CG.CustomerGroupID
					 								where C.CustomerID = @CustomerID)

	declare @StakeCommission money = @chash *  @CustomerGroupCommissionDeleteStake
	declare @StakeTax money = 0                                                  -- change if there is a tax for add stake
	declare @StakeFinal money = @chash - @StakeCommission - @StakeTax

	begin tran

		delete from  [finance].[Stakes] 
		where finance.Stakes.StakeID = @StakeID
		
		exec finance.UpsertCustomerFinanceOperation default, @CustomerID, 1, @chash, @StakeCommission, @StakeTax, @StakeFinal, @CurrencyCode
	
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

	begin tran

		;with ConditionsSumes (SportEventID, EventGroup, Sume)
		as
		(
			select C.SportEventID, E.EventGroup, isnull(sum(CSS.ConditionSum), 0)+10 as Sume
			from finance.Conditions C
				 join finance.ConditionStakesSumView CSS
					on C.ConditionID = CSS.ConditionID
			     join finance.Events E
					on E.EventID = C.EventID
				--join ConditionsGroupsCount CGC
				--	on CGC.EventGroup = E.EventGroup
			group by C.SportEventID, E.EventGroup
		)
		update finance.Conditions 
		set  Chance = 1 - (isnull(CSS.ConditionSum, 0) + 10 * (1 - C.Chance)) / CS.Sume
		--select CS.SportEventID, C.ConditionID, CSS.ConditionSum, CS.Sume,  1-(isnull(CSS.ConditionSum, 0) + 10 * C.Chance) / CS.Sume
		from finance.Conditions C
			 join finance.Events E
				on E.EventID = C.EventID
			 join ConditionsSumes CS
				on CS.EventGroup = E.EventGroup
			  join finance.ConditionStakesSumView CSS
				on CSS.ConditionID = C.ConditionID	
		where C.SportEventID = CS.SportEventID 

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go


/*
[ConditionID] [int] NOT NULL IDENTITY(1,1),
	[SportConditionID] [int] NOT NULL,
	[EventID] [int] NOT NULL,
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
		
		insert into [finance].[CustomersFinanceOperations] (CustomerID, FinanceOperationTyp, Amount, AmountCommission, AmountTax,  FinalAmount, CurrencyCode, OperationDate)
		select S.CustomerID, 1, S.Stake/(1 - C.Chance), 0, 0, S.Stake/(1 - C.Chance), S.CurrencyCode, getdate() 
		from finance.Stakes S 
			join finance.Conditions C on C.ConditionID = S.ConditionID 
		where C.IsTrue = 1 and S.Status = 1

		update S
		set S.Status = 2
		from  finance.Stakes S
			inner join finance.Conditions C
				on C.ConditionID = S.ConditionID
		where S.Status = 1 and C.IsTrue is not null

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
	@EventID int = null,
	@IsTrue bit = null
as
	begin try
		set nocount, xact_abort on

		if  isnull(@EventID,'') = '' or
			isnull(@MatchID,'') = ''
			throw 50000, 'Invalid parameters', 1

		insert into sport.MatchesResults(MatchID, EventID, IsTrue)
		values (@MatchID, @EventID, @IsTrue)

	end try
	begin catch
		throw
	end catch
go
--------------------------------------------

IF OBJECT_ID ( 'finance.ChackConditions', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.ChackConditions;  
GO
create procedure finance.ChackConditions
as
begin try
	set nocount, xact_abort on

	begin tran

		update C
		set C.IsTrue = 1
		from  finance.Conditions C
			inner join sport.MatchesResults MR
				on C.SportEventID = MR.MatchID and C.EventID = MR.EventID
		where MR.IsTrue = 1

		update C
		set C.IsTrue = 0
		from  finance.Conditions C
			inner join sport.MatchesResults MR
				on C.SportEventID = MR.MatchID and C.EventID = MR.EventID
		where MR.IsTrue = 0

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go
-------------------------------------
-------------------------------------
/*
IF OBJECT_ID ( 'finance.AddMatchConciderations', 'P' ) IS NOT NULL   ---ADD or Change Match
    DROP PROCEDURE finance.AddMatchConciderations;  
GO
create procedure finance.AddMatchConciderations 

	@MatchID int = null, 
	@SportID int = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@DateMatch,'') = '' or
			isnull(@HomeParticipant,'') = ''  or
			isnull(@AwayParticipant,'') = '' 
			throw 50000, 'Invalid parameters', 1

		if isnull(@MatchID,'') = ''
			insert into sport.Matches(DateMatch, HomeParticipant, AwayParticipant, TeamID)
			values (@DateMatch, @HomeParticipant, @AwayParticipant, @TeamID)
		else
		   update sport.Matches
		   set sport.Matches.DateMatch = @DateMatch,
				sport.Matches.HomeParticipant = @HomeParticipant,
				sport.Matches.AwayParticipant = @AwayParticipant,
				sport.Matches.TeamID = @TeamID
		   where sport.Matches.MatchID = @MatchID;

	end try
	begin catch
		throw
	end catch
go*/
-------------------------------------

IF OBJECT_ID ( 'sport.UpsertMatch', 'P' ) IS NOT NULL   ---ADD or Change Match
    DROP PROCEDURE sport.UpsertMatch;  
GO
create procedure sport.UpsertMatch 

	@MatchID int = null, 
	@DateMatch datetime = null,
	@HomeParticipant int = null,
	@AwayParticipant int = null, 
	@TeamID int = null,
	@ArenaID int = null
as
	begin try
		set nocount, xact_abort on

		if isnull(@DateMatch,'') = '' or
			isnull(@HomeParticipant,'') = ''  or
			isnull(@ArenaID,'') = ''  or
			isnull(@AwayParticipant,'') = '' 
			throw 50000, 'Invalid parameters', 1

		if isnull(@MatchID,'') = ''
			insert into sport.Matches(DateMatch, HomeParticipant, AwayParticipant,SportArenaID, TeamID)
			values (@DateMatch, @HomeParticipant, @AwayParticipant, @ArenaID, @TeamID)
		else
		   update sport.Matches
		   set sport.Matches.DateMatch = @DateMatch,
				sport.Matches.HomeParticipant = @HomeParticipant,
				sport.Matches.AwayParticipant = @AwayParticipant,
				sport.Matches.SportArenaID = @ArenaID,
				sport.Matches.TeamID = @TeamID
		   where sport.Matches.MatchID = @MatchID;

	end try
	begin catch
		throw
	end catch
go
----------------------------------
/*
IF OBJECT_ID ( 'finance.ChackConditionsAccessibility', 'P' ) IS NOT NULL   
    DROP PROCEDURE finance.ChackConditionsAccessibility;  
GO
create procedure finance.ChackConditionsAccessibility
as
begin try
	set nocount, xact_abort on

	begin tran

		update C
		set C.IsAvaliable = 0
		from  finance.Conditions C
			inner join sport.Matches M
				on C.SportEventID = M.MatchID
		where DATEADD(s, 45, M.DateMatch) <= getdate()

	commit

end try
begin catch
	if xact_state() <> 0
		rollback
	;throw
end catch
go*/
----------------------------------
