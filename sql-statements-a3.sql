CREATE DATABASE crowdfunding_db;
USE crowdfunding_db;

CREATE TABLE `category` (
  `CATEGORY_ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`CATEGORY_ID`)
);

INSERT INTO `category` VALUES (1,'Action'),(2,'Adventure'),(3,'RPG'),(4,'Strategy'),(5,'Simulation');

CREATE TABLE `fundraiser` (
  `FUNDRAISER_ID` int NOT NULL AUTO_INCREMENT,
  `ORGANIZER` varchar(255) NOT NULL,
  `CAPTION` varchar(255) NOT NULL,
  `TARGET_FUNDING` decimal(10,2) NOT NULL,
  `CURRENT_FUNDING` decimal(10,2) DEFAULT '0.00',
  `CITY` varchar(100) NOT NULL,
  `ACTIVE` tinyint(1) DEFAULT '1',
  `CATEGORY_ID` int NOT NULL,
  `image` varchar(255) DEFAULT 'img/placeholder.jpg',
  PRIMARY KEY (`FUNDRAISER_ID`),
  KEY `CATEGORY_ID` (`CATEGORY_ID`),
  CONSTRAINT `fundraiser_ibfk_1` FOREIGN KEY (`CATEGORY_ID`) REFERENCES `category` (`CATEGORY_ID`)
);

INSERT INTO `fundraiser` VALUES (1,'Blackmass Studios','The Shunned',100000.00,25000.00,'Brisbane',1,1,'img/the-shunned.jpg'),(2,'Tech Innovators','Iron Dominion',500000.00,300000.00,'San Francisco',1,4,'img/iron-dominion.jpg'),(3,'Pixel Games Studio','Pixel Kingdom',600000.00,25000.00,'Seattle',1,3,'img/pixel-kingdom.jpg'),(4,'NASA','Star Wanderer',900000.00,100000.00,'Houston',1,2,'img/star-wanderer.jpg'),(5,'Rogue Studios','Cyber Dungeon',800000.00,50000.00,'Chicago',1,1,'img/cyber-dungeon.jpg');

CREATE TABLE `pledges` (
  `PLEDGE_ID` int NOT NULL,
  `USER_ID` int DEFAULT NULL,
  `PROJECT_ID` int DEFAULT NULL,
  `AMOUNT` decimal(10,2) NOT NULL,
  `PLEDGE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PLEDGE_ID`),
  KEY `USER_ID` (`USER_ID`),
  KEY `PROJECT_ID` (`PROJECT_ID`),
  CONSTRAINT `pledges_ibfk_1` FOREIGN KEY (`USER_ID`) REFERENCES `users` (`USER_ID`),
  CONSTRAINT `pledges_ibfk_2` FOREIGN KEY (`PROJECT_ID`) REFERENCES `projects` (`PROJECT_ID`)
);

INSERT INTO `pledges` VALUES (5,1,1,100.00,'2024-09-02 10:55:50'),(6,2,2,150.00,'2024-09-02 10:55:50'),(7,3,3,200.00,'2024-09-10 09:10:25'),(8,4,4,50.00,'2024-09-11 12:25:30'),(9,5,1,75.00,'2024-09-12 11:15:45');

CREATE TABLE `projects` (
  `PROJECT_ID` int NOT NULL,
  `USER_ID` int DEFAULT NULL,
  `TITLE` varchar(255) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `TARGET_FUNDING` decimal(10,2) NOT NULL,
  `CURRENT_FUNDING` decimal(10,2) DEFAULT '0.00',
  `START_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `END_DATE` timestamp NULL DEFAULT NULL,
  `ACTIVE` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`PROJECT_ID`)
);

INSERT INTO `projects` VALUES (1,1,'The Shunned','An open-world survival game...',750000.00,0.00,'2024-09-02 10:42:25','2026-12-30 13:00:00',1),(2,2,'DominionAge','A medieval RTS game...',450000.00,0.00,'2024-09-02 10:42:25','2026-12-29 13:00:00',1),(3,3,'Star Wanderer','A sci-fi exploration game...',900000.00,100000.00,'2024-09-10 10:50:30','2027-01-15 12:00:00',1),(4,4,'Pixel Kingdom','A retro-inspired RPG...',600000.00,25000.00,'2024-09-11 08:30:45','2026-11-30 15:00:00',1),(5,5,'Cyber Dungeon','A roguelike action game...',800000.00,50000.00,'2024-09-12 09:45:50','2027-06-25 14:30:00',1);

CREATE TABLE `rewards` (
  `REWARD_ID` int NOT NULL,
  `PROJECT_ID` int DEFAULT NULL,
  `REWARD_DESCRIPTION` text NOT NULL,
  `PLEDGE_AMOUNT` decimal(10,2) NOT NULL
);

INSERT INTO `rewards` VALUES (25,1,'Exclusive Viking armor set',50.00),(26,1,'Digital Art Book and Soundtrack',100.00),(27,3,'Star Wanderer Poster',75.00),(28,4,'Pixel Art Print',30.00),(29,5,'Cyber Dungeon Soundtrack',40.00);

CREATE TABLE `users` (
  `USER_ID` int NOT NULL,
  `USERNAME` varchar(100) NOT NULL,
  `EMAIL` varchar(255) NOT NULL,
  `PASSWORD_HASH` varchar(255) NOT NULL,
  `JOIN_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`USER_ID`)
);

INSERT INTO `users` VALUES (1,'game_dev_Stu','s.marley.14@student.scu.edu.au','hashed_password_1','2024-09-02 06:29:49'),(2,'game_dev_nehnehemia','nehnehemia@scu.edu.au.com','hashed_password_2','2024-09-02 06:29:49'),(3,'star_explorer','star.explorer@gmail.com','hashed_password_3','2024-09-10 07:15:35'),(4,'pixel_king','pixelking@mail.com','hashed_password_4','2024-09-11 08:00:00'),(5,'cyber_rogue','cyber.rogue@mail.com','hashed_password_5','2024-09-12 09:00:25');

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
