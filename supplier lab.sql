create database sup;
use sup;

CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(20)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost int,
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);

INSERT INTO Supplier VALUES
(1, 'Acme Widget Suppliers', 'Kolkata'),
(2, 'Best Supplies', 'pune'),
(3, 'Tech Parts Co', 'Mumbai');

INSERT INTO Parts VALUES
(101, 'Bolt', 'Blue'),
(102, 'Nut', 'Black'),
(103, 'Screw', 'Green'),
(104, 'Washer', 'Red');

INSERT INTO Catalog VALUES
(1, 101, 20),
(1, 102, 25),
(2, 101, 22),
(2, 103, 30),
(3, 104, 15),
(3, 101, 28),
(1 , 103 , 27),
(1,104,18);

SELECT DISTINCT p.pname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid;

SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE NOT EXISTS (
        SELECT c.pid
        FROM Catalog c
        WHERE c.pid = p.pid AND c.sid = s.sid
    )
);


SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.color = 'Red' AND NOT EXISTS (
        SELECT *
        FROM Catalog c
        WHERE c.sid = s.sid AND c.pid = p.pid
    )
);


SELECT p.pname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid
JOIN Supplier s ON s.sid = c.sid
WHERE s.sname = 'Acme Widget Suppliers'
AND p.pid NOT IN (
    SELECT c2.pid
    FROM Catalog c2
    JOIN Supplier s2 ON s2.sid = c2.sid
    WHERE s2.sname <> 'Acme Widget Suppliers'
);


SELECT DISTINCT c.sid
FROM Catalog c
JOIN (
    SELECT pid, AVG(cost) AS avg_cost
    FROM Catalog
    GROUP BY pid
) AS avg_table
ON c.pid = avg_table.pid
WHERE c.cost > avg_table.avg_cost;


SELECT p.pname, s.sname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid
JOIN Supplier s ON s.sid = c.sid
WHERE c.cost = (
    SELECT MAX(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = p.pid
);