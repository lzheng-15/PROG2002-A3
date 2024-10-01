-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: smarle14_crowdfunding_db
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `CATEGORY_ID` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`CATEGORY_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Action'),(2,'Adventure'),(3,'RPG'),(4,'Strategy'),(5,'Simulation');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fundraiser`
--

DROP TABLE IF EXISTS `fundraiser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fundraiser`
--

LOCK TABLES `fundraiser` WRITE;
/*!40000 ALTER TABLE `fundraiser` DISABLE KEYS */;
INSERT INTO `fundraiser` VALUES (1,'Blackmass Studios','The Shunned',100000.00,25000.00,'Brisbane',1,1,'img/the-shunned.jpg'),(2,'Tech Innovators','Iron Dominion',500000.00,300000.00,'San Francisco',1,4,'img/iron-dominion.jpg'),(3,'Pixel Games Studio','Pixel Kingdom',600000.00,25000.00,'Seattle',1,3,'img/pixel-kingdom.jpg'),(4,'NASA','Star Wanderer',900000.00,100000.00,'Houston',1,2,'img/star-wanderer.jpg'),(5,'Rogue Studios','Cyber Dungeon',800000.00,50000.00,'Chicago',1,1,'img/cyber-dungeon.jpg');
/*!40000 ALTER TABLE `fundraiser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pledges`
--

DROP TABLE IF EXISTS `pledges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pledges`
--

LOCK TABLES `pledges` WRITE;
/*!40000 ALTER TABLE `pledges` DISABLE KEYS */;
INSERT INTO `pledges` VALUES (5,1,1,100.00,'2024-09-02 10:55:50'),(6,2,2,150.00,'2024-09-02 10:55:50'),(7,3,3,200.00,'2024-09-10 09:10:25'),(8,4,4,50.00,'2024-09-11 12:25:30'),(9,5,1,75.00,'2024-09-12 11:15:45');
/*!40000 ALTER TABLE `pledges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,1,'The Shunned','An open-world survival game...',750000.00,0.00,'2024-09-02 10:42:25','2026-12-30 13:00:00',1),(2,2,'DominionAge','A medieval RTS game...',450000.00,0.00,'2024-09-02 10:42:25','2026-12-29 13:00:00',1),(3,3,'Star Wanderer','A sci-fi exploration game...',900000.00,100000.00,'2024-09-10 10:50:30','2027-01-15 12:00:00',1),(4,4,'Pixel Kingdom','A retro-inspired RPG...',600000.00,25000.00,'2024-09-11 08:30:45','2026-11-30 15:00:00',1),(5,5,'Cyber Dungeon','A roguelike action game...',800000.00,50000.00,'2024-09-12 09:45:50','2027-06-25 14:30:00',1);
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rewards`
--

DROP TABLE IF EXISTS `rewards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rewards` (
  `REWARD_ID` int NOT NULL,
  `PROJECT_ID` int DEFAULT NULL,
  `REWARD_DESCRIPTION` text NOT NULL,
  `PLEDGE_AMOUNT` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rewards`
--

LOCK TABLES `rewards` WRITE;
/*!40000 ALTER TABLE `rewards` DISABLE KEYS */;
INSERT INTO `rewards` VALUES (25,1,'Exclusive Viking armor set',50.00),(26,1,'Digital Art Book and Soundtrack',100.00),(27,3,'Star Wanderer Poster',75.00),(28,4,'Pixel Art Print',30.00),(29,5,'Cyber Dungeon Soundtrack',40.00);
/*!40000 ALTER TABLE `rewards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `USER_ID` int NOT NULL,
  `USERNAME` varchar(100) NOT NULL,
  `EMAIL` varchar(255) NOT NULL,
  `PASSWORD_HASH` varchar(255) NOT NULL,
  `JOIN_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'game_dev_Stu','s.marley.14@student.scu.edu.au','hashed_password_1','2024-09-02 06:29:49'),(2,'game_dev_nehnehemia','nehnehemia@scu.edu.au.com','hashed_password_2','2024-09-02 06:29:49'),(3,'star_explorer','star.explorer@gmail.com','hashed_password_3','2024-09-10 07:15:35'),(4,'pixel_king','pixelking@mail.com','hashed_password_4','2024-09-11 08:00:00'),(5,'cyber_rogue','cyber.rogue@mail.com','hashed_password_5','2024-09-12 09:00:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-23 21:05:51
