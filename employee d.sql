create database emp_details;
use emp_details;

create table Dept (
 deptno int,
    dname varchar(30),
    dloc varchar(30),
    primary key(deptno)
);

create table project (
 pno int,
    pname varchar(30),
    ploc varchar(30),
    primary key(pno)
);

create table employee (
 empno int,
    ename varchar(30),
 mgr_no int,
    hiredate date,
    sal decimal(10,2),
    deptno int,
    primary key(empno),
    foreign key(deptno) references dept(deptno)
);

create table incentives (
 empno int,
    incentive_date date,
    incentive_amount decimal(8,2),
    foreign key(empno) references employee(empno),
    primary key(empno, incentive_date)
);

create table assigned_to (
 empno int,
    pno int,
    job_role varchar(30),
    foreign key(empno) references employee(empno),
    foreign key(pno) references project(pno),
    primary key(empno,pno)
);

insert into dept values
(10, 'HR', 'Bengaluru'),
(20, 'IT', 'Hyderabad'),
(30, 'Finance', 'Mysuru'),
(40, 'Marketing', 'Chennai'),
(50, 'HR', 'Delhi'),
(60, 'Finance', 'Pune');

select * from dept;

insert into project values
(201,'roll','Bengaluru'),
(202,'model','Hyderabad'),
(203,'thP','Mysuru'),
(204,'Campaign','Chennai'),
(205,'SI','Delhi'),
(206,'Logs','Pune');

select * from project;

insert into employee values
(1001,'Arjun',1005,'2020-01-10',50000,10),
(1002,'Meena',1005,'2021-03-15',55000,20),
(1003,'Ravi',1002,'2019-07-22',60000,30),
(1004,'Sneha',1003,'2022-11-11',48000,40),
(1005,'Kiran',NULL,'2018-05-03',75000,50),
(1006,'Asha',1002,'2023-02-20',47000,60);

select * from employee;

insert into incentives values
(1001,'2023-12-01',5000),
(1002,'2024-02-10',4000),
(1003,'2024-03-05',3000),
(1005,'2023-06-15',7000),
(1006,'2023-04-09',2000),
(1001,'2024-07-18',2500);

select * from incentives;

insert into assigned_to values
(1001,201,'Analyst'),
(1002,202,'Developer'),
(1003,203,'Manager'),
(1004,204,'Designer'),
(1005,205,'Lead'),
(1006,206,'Coordinator');

select e.empno
from assigned_to a
inner join employee e on a.empno = e.empno
inner join project p on a.pno = p.pno
where p.ploc in ('Bengaluru','Hyderabad','Mysuru'); 

select e.empno
from employee e
where not exists (select 1
     from incentives i
              where i.empno = e.empno);

select e.ename,e.empno,d.dname,a.job_role,d.dloc,p.ploc
from employee e
join dept d on e.deptno = d.deptno
join assigned_to a on e.empno = a.empno
join project p on a.pno = p.pno
where d.dloc = p.ploc;

SELECT E2.ENAME AS Manager
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON E1.MGR_NO = E2.EMPNO
GROUP BY E2.ENAME
HAVING COUNT(E1.EMPNO) = (
    SELECT MAX(emp_count)
    FROM (
        SELECT COUNT(E1.EMPNO) AS emp_count
        FROM EMPLOYEE E1
        JOIN EMPLOYEE E2 ON E1.MGR_NO = E2.EMPNO
        GROUP BY E2.ENAME
    ) AS sub
);

select m.ename,m.sal,avg(e.sal)
from employee e
join employee m on e.mgr_no = m.empno
group by m.ename,m.sal
having m.sal > avg(e.sal);

SELECT DISTINCT E2.ENAME AS SecondTopManager, E2.DEPTNO
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON E1.EMPNO = E2.MGR_NO
WHERE E1.MGR_NO IS NULL;

SELECT *
FROM EMPLOYEE E
JOIN INCENTIVES I ON E.EMPNO = I.EMPNO
WHERE I.INCENTIVE_DATE BETWEEN '2019-01-01' AND '2019-01-31'
AND I.INCENTIVE_AMOUNT = (
    SELECT DISTINCT INCENTIVE_AMOUNT
    FROM INCENTIVES
    WHERE INCENTIVE_DATE BETWEEN '2019-01-01' AND '2019-01-31'
    ORDER BY INCENTIVE_AMOUNT DESC
    LIMIT 1 OFFSET 1
);

SELECT E.ENAME
FROM EMPLOYEE E
JOIN EMPLOYEE M ON E.MGR_NO = M.EMPNO
WHERE E.DEPTNO = M.DEPTNO;

select e.ename as Employee, d.dname as Department, d.dloc as Departmentlocation
from employee e 
join dept d on e.deptno = d.deptno;

insert into employee values 
(1009,'shub',1002,'2022-03-07',30000,20);

select e.ename
from employee e 
where e.empno not in (select empno 
                    from assigned_to);
 
 select p.pname, count(*)
 from project p 
 join assigned_to a on p.pno= a.pno
 group by p.pname;
 
 select d.dname, avg(e.sal), max(e.sal)
 from dept d
 join employee e on e.deptno = d.deptno
 group by d.dname;
                    
select e.ename, sum(i.incentive_amount)
from employee e
join incentives i on e.empno = i.empno
group by e.ename;
                    
select e.ename, p.pname
from employee e
join assigned_to a on e.empno = a.empno
join project p on p.pno = a.pno
where p.pname = 'Campaign';

select d.dname
from dept d
where d.deptno not in (select e.deptno
                         from employee e);

select m.ename, count(*) as num_reports
from employee e
join employee m on e.mgr_no = m.empno
group by m.ename;

insert into assigned_to values
(1009,206,'Assistant'),
(1009,204,'Assistant');

select e.ename 
from employee e
where (select count(pno)
        from assigned_to a 
        where e.empno = a.empno
        group by empno)>1;
