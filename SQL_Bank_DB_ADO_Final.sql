create database BankingDB

use BankingDB

create table tbl_Customers
(
CustomerID int identity(1000,1) primary key,
CustomerName varchar(100) not null,
CustomerEmail varchar(100) unique not null,
CustomerMobile varchar(10) not null,
CustomerGender varchar(100) check(CustomerGender in('Male','Female')) not null,
CustomerPassword varchar(100) not null
)



create table tbl_Accounts
(
AccountID int identity(10000,1) primary key,
CustomerID int foreign key references tbl_Customers(CustomerID) not null,
AccountBalance int not null,
AccountType varchar(100) not null,
AccountOpeningDate date not null
)
select * from tbl_Accounts


create table tbl_Transactions
(
TransactionID int identity(100000,1) primary key,
AccountID int foreign key references tbl_Accounts(AccountID)not null,
Amount int check(Amount>0) not null,
TransactionType varchar(100) not null,
TransactionDate date not null
)


select * from tbl_Transactions

alter proc p_addCustomer(@name varchar(100),@email varchar(100),@mobile varchar(100),@gender varchar(100),@password varchar(100))
as
begin
insert into tbl_Customers values(@name,@email,@mobile,@gender,@password)
return @@identity
end

alter proc p_addAccount(@cid int,@balance int,@type varchar)
as
begin
insert into tbl_Accounts values(@cid,@balance,@type,GETDATE())
return @@identity
end

alter proc p_addTransaction(@aid int,@amount int,@type varchar(100))
as
begin
insert into tbl_Transactions values(@aid,@amount,@type,GETDATE())
return @@identity
end

alter proc p_login(@id int,@psw varchar(100))
as
begin
declare @ch int
select @ch=COUNT(*) from tbl_Customers where CustomerID=@id and CustomerPassword=@psw
return @ch
end

alter proc p_getName(@id int)
as
begin
select CustomerName from tbl_Customers where CustomerID=@id;
end

create proc p_ShowTransactions(@id int)
as
begin
select * from tbl_Transactions where AccountID=@id
end

create proc p_getAccID(@id int)
as
begin
declare @count int
select AccountID,CustomerID from tbl_Accounts where CustomerID=@id
end

create proc p_GetCustomer(@id int)
as
begin
select CustomerID,CustomerName from tbl_Customers where CustomerID=@id
end


create proc p_GetAcc(@cid int)
as
begin
select * from tbl_Accounts where AccountID=@cid
end

select * from tbl_Customers