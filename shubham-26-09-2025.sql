show databases;

create database vs280 ;

use vs280;

create table person(
    driver_id varchar(20),
    name varchar(30),
    address varchar(30),
    primary key(driver_id)
);

desc person;

create table car(
   reg_num varchar(20),
   model varchar(30),
   year int,
   primary key(reg_num)
);

create table accident(
    report_num int,
    accident_date date,
    location varchar(30),
    primary key(report_num)
    );
    
create table owns(
    driver_id varchar(20),
    reg_num varchar(10),
    primary key(driver_id,reg_num),
    foreign key(driver_id) references person(driver_id),
    foreign key(reg_num) references car(reg_num)
);
     
create table participated(
    driver_id varchar(10), 
    reg_num varchar(10),
    report_num int,
    damage_amount int, 
    primary key(driver_id, reg_num, report_num), 
    foreign key(driver_id) references person(driver_id),
    foreign key(reg_num) references car(reg_num),
    foreign key(report_num) references accident(report_num)
);

insert into person values ('A01','Richard','Srinivas Nagar');
insert into person values ('A02','Pradeep','Rajinagar');
insert into person values ('A03','Saith','Ashoknagar');
insert into person values ('A04','Venu','N.R.Colony');
insert into person values ('A05','John','Hanumanthnagar');

select * from person;

insert into car values ('KA052253','Indica',1909);
insert into car values ('KA021213','Lancer',1212);
insert into car values ('IH891989','toyato',2091);
insert into car values ('IU279837','honda',9092);
insert into car values ('ER233423','maruti',2321);

select * from car;

insert into accident values 
(11,'2003-01-01','Mysore Road'),
(12,'2004-02-02','South end circle'),
(13,'2003-01-21','Bull temple Road'),
(14,'2003-01-01','Mysore Road'),
(15,'2003-01-01','Mysore Road');

select * from accident;

insert into owns values 
('A01','KA052253'),
('A02','KA021213'),
('A03','IH891989'),
('A04','IU279837'),
('A05','ER233423');

select * from owns;

insert into participated values
('A01','KA052253',11,15000),
('A02','KA021213',12,20000),
('A03','IH891989',13,25000),
('A04','IU279837',14,30000),
('A05','ER233423',15,35000);

select accident_date , location
from accident;

select name,damage_amount
from person,participated
where person.driver_id=participated.driver_id and participated.damage_amount >=25000;

select name, model
from person, car, owns
where owns.driver_id = person.driver_id and owns.reg_num = car.reg_num;

select accident_date, location, name, damage_amount
from accident,person,participated
where accident.report_num = participated.report_num and person.driver_id = participated.driver_id;

select name,count(*)
from person,participated
where person.driver_id = participated.driver_id
group by participated.driver_id
having count(*) >1;

select model
from car 
where reg_num not in (select reg_num from participated);


select *
from accident
where accident-date>=all(select accident_date from accident);

select avg(damage_amount)
from participated;

update participated 
set damage_amount = 25000
where driver_id = 'A01';
select *
from participated;

select name
from person,participated 
where person.driver_id = participated.driver_id and participated.damage_amount >= all(select damage_amount from participated);

select c.model, SUM(p.damage_amount) as
total_damage
from car c, participated p 
WHERE c.reg_num = p.reg_num
group by c.model
having sum(p.damage_amount > 20000);

create view accident_summry as 
select 
    a.report_num,
    a.accident_date,
    a.location,
    count(p.driver_id) as participant_count,
    sum(p.damage_amount) as total_damage
    from accident a
    join participated p on a.report_num=p.report_num
    group by a.report_num,accident_date,location;
    
select * from accident_summry;


    