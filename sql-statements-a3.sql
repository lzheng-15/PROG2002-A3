--  create DONATION table
CREATE TABLE DONATION (
    DONATION_ID INT AUTO_INCREMENT PRIMARY KEY,
    DATE DATE NOT NULL,
    AMOUNT DECIMAL(10, 2) NOT NULL,
    GIVER VARCHAR(255) NOT NULL,
    FUNDRAISER_ID INT NOT NULL,
    FOREIGN KEY (FUNDRAISER_ID) REFERENCES fundraiser(FUNDRAISER_ID)
);

-- add 5 more records into FUNDRAISER table
INSERT INTO `fundraiser` VALUES 
(6, 'Phoenix Studios', 'Flames of Eternity', 300000.00, 75000.00, 'Tokyo', 1, 1, 'img/flames-of-eternity.jpg'),
(7, 'Neon Games', 'Galactic Conquest', 700000.00, 200000.00, 'Berlin', 1, 4, 'img/galactic-conquest.jpg'),
(8, 'Arcadia Interactive', 'Mystic Realms', 450000.00, 120000.00, 'London', 1, 3, 'img/mystic-realms.jpg'),
(9, 'Ironclad Developers', 'Warriors of Valhalla', 900000.00, 300000.00, 'Oslo', 1, 2, 'img/warriors-of-valhalla.jpg'),
(10, 'Silverlight Games', 'Empire Builder', 550000.00, 180000.00, 'Los Angeles', 1, 5, 'img/empire-builder.jpg');

-- add 20 records into DONATION table
INSERT INTO DONATION (DATE, AMOUNT, GIVER, FUNDRAISER_ID) VALUES
('2024-01-01', 100.00, 'John Doe', 1),
('2024-01-02', 50.00, 'Jane Smith', 1),
('2024-01-03', 75.00, 'Bob Johnson', 2),
('2024-01-04', 150.00, 'Alice Green', 2),
('2024-01-05', 200.00, 'Chris White', 3),
('2024-01-06', 300.00, 'David Black', 3),
('2024-01-07', 250.00, 'Emma Brown', 4),
('2024-01-08', 125.00, 'Oliver Grey', 4),
('2024-01-09', 175.00, 'Sophia Blue', 5),
('2024-01-10', 400.00, 'Liam Red', 5),
('2024-01-11', 100.00, 'Isabella Green', 6),
('2024-01-12', 50.00, 'Elijah Black', 6),
('2024-01-13', 75.00, 'Mason Brown', 7),
('2024-01-14', 150.00, 'Ava White', 7),
('2024-01-15', 200.00, 'Mia Johnson', 8),
('2024-01-16', 300.00, 'Noah Davis', 8),
('2024-01-17', 250.00, 'James Thompson', 9),
('2024-01-18', 125.00, 'Lucas Walker', 9),
('2024-01-19', 175.00, 'Ethan Harris', 10),
('2024-01-20', 400.00, 'Amelia King', 10);
