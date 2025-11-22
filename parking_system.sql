CREATE DATABASE parkingSlot_DB

--ParkingSlot
CREATE TABLE ParkingSlot (
    slot_id INT PRIMARY KEY,
    slot_number VARCHAR(10) UNIQUE,
    status VARCHAR(10) CHECK (status IN ('FREE', 'OCCUPIED'))
);

--Vehicle
CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY,
    vehicle_number VARCHAR(15) UNIQUE,
    owner_name VARCHAR(50)
);

--EntryLog
CREATE TABLE EntryLog (
    entry_id INT PRIMARY KEY,
    vehicle_id INT,
    slot_id INT,
    entry_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    FOREIGN KEY (slot_id) REFERENCES ParkingSlot(slot_id)
);

--ExitLog
CREATE TABLE ExitLog (
    exit_id INT PRIMARY KEY,
    entry_id INT UNIQUE,
    exit_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (entry_id) REFERENCES EntryLog(entry_id)
);

--Billing
CREATE TABLE Billing (
    bill_id INT PRIMARY KEY,
    exit_id INT UNIQUE,
    total_hours INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (exit_id) REFERENCES ExitLog(exit_id)
);

INSERT INTO ParkingSlot VALUES
(1, 'S1', 'FREE'),
(2, 'S2', 'FREE'),
(3, 'S3', 'FREE');

INSERT INTO Vehicle VALUES
(101, 'UP14 AB1234', 'Rohit'),
(102, 'DL05 CD9876', 'Amit'),
(103, 'MP17 EF5621', 'Suman');

--A vehicle enters (EntryLog)
INSERT INTO EntryLog VALUES (1, 101, 1, SYSDATETIME());
UPDATE ParkingSlot SET status='OCCUPIED' WHERE slot_id = 1;

--Vehicle exits
INSERT INTO ExitLog VALUES (1, 1, SYSDATETIME());
UPDATE ParkingSlot SET status='FREE' WHERE slot_id = 1;

--Billing (simple calculation)
INSERT INTO Billing VALUES (1, 1, 2, 40.00);   -- Example

--Parking History
SELECT E.entry_id, V.vehicle_number, P.slot_number, E.entry_time
FROM EntryLog E
JOIN Vehicle V ON E.vehicle_id = V.vehicle_id
JOIN ParkingSlot P ON E.slot_id = P.slot_id;

--Show all entries even if exit not done
SELECT E.entry_id, V.vehicle_number, X.exit_time
FROM EntryLog E
JOIN Vehicle V ON E.vehicle_id = V.vehicle_id
LEFT JOIN ExitLog X ON E.entry_id = X.entry_id;

--rare but as per syllabus
SELECT V.owner_name, E.entry_id
FROM Vehicle V
RIGHT JOIN EntryLog E ON V.vehicle_id = E.vehicle_id;

SELECT vehicle_number
FROM Vehicle
WHERE vehicle_id IN (SELECT vehicle_id FROM EntryLog);

--VIEW
CREATE VIEW ParkingStatus AS
SELECT slot_number, status FROM ParkingSlot;

--TRANSACTIONS (COMMIT / ROLLBACK)
BEGIN TRANSACTION;

UPDATE ParkingSlot SET status = 'OCCUPIED' WHERE slot_id = 2;

-- Agar sab kuch sahi ho:
COMMIT;

-- Agar koi dikkat ho jaaye toh:
ROLLBACK;




