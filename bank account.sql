create database Bankvs280;
use Bankvs280;

create table Branch (
  branch_name varchar(15),
  branch_city varchar(15),
  assets real,
  primary key (branch_name)
  );
  
  alter table Branch
  modify column branch_name varchar(30);
  
  create table Bankaccount (
  account int,
  branch_name varchar(30),
  balance real,
  primary key(account),
  foreign key(branch_name) references Branch(branch_name)
  );
  
  create table BankCustomer(
  customer_name varchar(20),
  customer_street varchar (20),
  customer_city varchar(20),
  primary key (customer_name)
  );
  
  create table Depositer (
  customer_name varchar(20),
  account int,
  primary key(customer_name,account),
  foreign key(customer_name) references BankCustomer (customer_name),
  foreign key(account) references BankAccount (account)
  );
  
  create table loan (
  loan_number int,
  branch_name varchar(15),
  amount real,
  primary key(loan_number),
  foreign key(branch_name) references Branch (branch_name)
  );
  
   alter table loan
  modify column branch_name varchar(30);
  
  insert into Branch values
  ('SBI_Chamrajpet','Banglore',500000),
  ('SBI_ResidencyRoad','Banglore',100000),
  ('SBI_ShivajiRoad','bombay',20000),
  ('SBI_PrliamentRoad','Delhi',10000),
  ('SBI_Jantar mantar','Delhi',20000);
  select * from Branch;
  
  insert into BankAccount values
  (1,'SBI_Chamrajpet',2000),
  (2,'SBI_ResidencyRoad',5000),
  (3,'SBI_ShivajiRoad',6000),
  (4,'SBI_PrliamentRoad',9000),
  (5,'SBI_Jantar mantar',8000),
  (6,'SBI_ShivajiRoad',4000),
  (7,'SBI_ResidencyRoad',4000),
  (8,'SBI_PrliamentRoad',3000),
  (9,'SBI_ResidencyRoad',5000),
  (10,'SBI_Jantar mantar',2000);
  
  select * from BankAccount;
  
insert into BankCustomer values
('Avinash','Bull Temple','Bangalore'),
('Dinesh','Bannergatta','Bangalore'),
('Mohan','National College','Bangalore'),
('Nikhil','Akbar Road','Delhi'),
('Ravi','Prithviraj Road','Delhi');

select * from BankCustomer;

insert into Depositer values
('Avinash',1),
('Dinesh',2),
('Nikhil',4),
('Ravi',5),
('Avinash',7),
('Nikhil',8),
('Dinesh',9),
('Nikhil',10);

select * from Depositer;

insert into loan values
(1,'SBI_Chamrajpet',1000),
(2,'SBI_ResidencyRoad',2000),
(3,'SBI_ShivajiRoad',3000),
(4,'SBI_PrliamentRoad',4000),
(5,'SBI_Jantar mantar',5000);

select * from Loan;

select branch_name, assets as assets_in_lakhs
from Branch;

select d.customer_name, a.branch_name, count(*)
from depositer d, BankAccount a
where d.account = a.account
group by d.customer_name, a.branch_name
having count(*)>=2;

create view TotalLoans as
select branch_name, sum(amount)
from loan
group by branch_name;

select * from TotalLoans;

