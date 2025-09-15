create database projecttttt;
use projecttttt;

SELECT * FROM Airline;

ALTER TABLE Airline
DROP COLUMN `Airport Continent`,
DROP COLUMN `Airport Country Code`;

SELECT *
FROM Airline
WHERE 
    `First Name` IS NULL OR
    `Last Name` IS NULL OR
    Gender IS NULL OR
    Age IS NULL OR
    Nationality IS NULL OR
    `Airport Name` IS NULL OR
    `Country Name` IS NULL OR
    `Continents` IS NULL OR
    `Arrival Airport` IS NULL OR
    `Departure Date` IS NULL OR
    `Flight Status` IS NULL OR
    `Pilot Name` IS NULL;

DESCRIBE Airline;

DROP TABLE IF EXISTS Passengers;
CREATE TABLE Passengers(Passenger_ID INT AUTO_INCREMENT PRIMARY KEY) AS
SELECT DISTINCT
    CONCAT(`First Name`, ' ', `Last Name`) AS Passenger_Name,
    Gender,
    Age,
    Nationality,
    `Airport Name` AS Airport_Name
FROM Airline;

ALTER TABLE Passengers
ADD COLUMN Number_of_Flights INT DEFAULT 0;
UPDATE Passengers
SET Number_of_Flights = ROUND(RAND() * 8 + 2);

ALTER TABLE Passengers
ADD COLUMN Travel_Class VARCHAR(20);
UPDATE Passengers
SET Travel_Class = 
    CASE 
        WHEN Passenger_ID % 3 = 0 THEN 'Economy'
        WHEN Passenger_ID % 3 = 1 THEN 'Business'
        ELSE 'First'
    END;

ALTER TABLE Passengers
ADD COLUMN Ticket_Price DECIMAL(10,2);
UPDATE Passengers
SET Ticket_Price = 
    CASE 
        WHEN Travel_Class = 'Economy' THEN 1000.00
        WHEN Travel_Class = 'Business' THEN 1500.00
        WHEN Travel_Class = 'First' THEN 2000.00
        ELSE 1200.00
    END;

SELECT * FROM Passengers;

-- TABLE Airport
DROP TABLE IF EXISTS Airport;
CREATE TABLE Airport(Airport_ID INT AUTO_INCREMENT PRIMARY KEY) AS
SELECT DISTINCT
    `Airport Name` AS Airport_Name,
    `Country Name` AS Country_Name,
    `Arrival Airport` AS Arrival_Airport,
    Continents
FROM Airline;

ALTER TABLE Airport
ADD COLUMN Total_Revenue DECIMAL(12,2);

UPDATE Airport ar
SET Total_Revenue = (
    SELECT SUM(p.Ticket_Price * p.Number_of_Flights)
    FROM Passengers p
    WHERE p.Airport_Name = ar.Airport_Name
);

SELECT * FROM Airport;

DROP TABLE IF EXISTS Flight_Status;
--  TABLE Flight_Status
CREATE TABLE Flight_Status(FlightStatus_ID INT AUTO_INCREMENT PRIMARY KEY) AS
SELECT DISTINCT `Flight Status` AS Flight_Status
FROM Airline;

ALTER TABLE Flight_Status
ADD COLUMN Total_Number INT DEFAULT 0;

UPDATE Flight_Status fs
JOIN (
    SELECT `Flight Status` AS Flight_Status, COUNT(*) AS Status_Count
    FROM Airline
    GROUP BY `Flight Status`
) AS counts ON fs.Flight_Status = counts.Flight_Status
SET fs.Total_Number = counts.Status_Count;

SELECT * FROM Flight_Status;

DROP TABLE IF EXISTS Pilot;
-- TABLE Pilot
CREATE TABLE Pilot(Pilot_ID INT AUTO_INCREMENT PRIMARY KEY) AS
SELECT DISTINCT `Pilot Name` AS Pilot_Name
FROM Airline;

ALTER TABLE Pilot
ADD COLUMN Salary DECIMAL(10,2);

UPDATE pilot
SET salary = ROUND(RAND() * 5000 + 10000, 2);

SELECT * FROM Pilot;