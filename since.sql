-- phpMyAdmin SQL Dump
-- SinceRPG Database
-- Prepared for XAMPP Local Installation
-- Database: `since`

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `since`
--
CREATE DATABASE IF NOT EXISTS `since` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `since`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `uid` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `status` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `transaction_id` text NOT NULL,
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-14mili`
--

CREATE TABLE `since-14mili` (
  `uid` bigint(20) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-admins`
--

CREATE TABLE `since-admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `serial` text NOT NULL,
  `nick` varchar(255) NOT NULL,
  `level` tinyint(1) NOT NULL,
  `actived` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `added` timestamp NOT NULL DEFAULT current_timestamp(),
  `uid` bigint(20) NOT NULL,
  `reporty` bigint(20) NOT NULL DEFAULT 0,
  `stats` text NOT NULL DEFAULT '',
  KEY `uid` (`uid`),
  KEY `level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-atms-logs`
--

CREATE TABLE `since-atms-logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `uid` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `icon` varchar(255) NOT NULL,
  `color` varchar(255) NOT NULL,
  `text` varchar(255) NOT NULL,
  `amount` bigint(20) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  KEY `uid` (`uid`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-ban`
--

CREATE TABLE `since-ban` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `serial` text NOT NULL,
  `reason` text NOT NULL,
  `time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  `type` int(11) NOT NULL,
  `admin` text NOT NULL DEFAULT '0',
  `admin_name` text NOT NULL DEFAULT '0',
  `admin_serial` text NOT NULL DEFAULT '0',
  `sid` int(11) NOT NULL DEFAULT 0,
  `ipAdress` varchar(255) NOT NULL DEFAULT '',
  KEY `sid` (`sid`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-bronie`
--

CREATE TABLE `since-bronie` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL,
  `weapon` int(11) NOT NULL,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-carsRobbery`
--

CREATE TABLE `since-carsRobbery` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `model` int(11) NOT NULL,
  `slot` int(11) NOT NULL,
  `onMap` int(11) NOT NULL,
  `inGarage` int(11) NOT NULL,
  `state` int(11) NOT NULL DEFAULT 1,
  `data` text NOT NULL DEFAULT '[[]]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-casino`
--

CREATE TABLE `since-casino` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `sid` int(11) NOT NULL,
  `zetony` bigint(11) NOT NULL DEFAULT 0,
  KEY `sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-clothes`
--

CREATE TABLE `since-clothes` (
  `ids` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `uid` int(11) NOT NULL,
  `texture` text NOT NULL,
  `model` text NOT NULL,
  `name` text NOT NULL,
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-cryto-records`
--

CREATE TABLE `since-cryto-records` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `data` varchar(50) NOT NULL,
  `price` int(11) NOT NULL,
  KEY `date` (`date`),
  KEY `data` (`data`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-dailySaver`
--

CREATE TABLE `since-dailySaver` (
  `uid` bigint(20) NOT NULL PRIMARY KEY,
  `data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-discord`
--

CREATE TABLE `since-discord` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `serial` varchar(255) NOT NULL,
  `discordID` varchar(255) NOT NULL,
  `notifications` int(11) NOT NULL DEFAULT 1,
  KEY `serial` (`serial`),
  KEY `discordID` (`discordID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-drift`
--

CREATE TABLE `since-drift` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `uid` bigint(20) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `drift` bigint(20) NOT NULL,
  KEY `uid` (`uid`),
  KEY `drift` (`drift`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-exchange`
--

CREATE TABLE `since-exchange` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL,
  `itemName` text NOT NULL,
  `data` text NOT NULL,
  `category` text NOT NULL,
  `price` bigint(20) NOT NULL,
  `special` int(11) NOT NULL,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-factions`
--

CREATE TABLE `since-factions` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `uid` bigint(20) NOT NULL,
  `faction` int(11) NOT NULL,
  `rank` int(11) NOT NULL,
  `duty` int(11) NOT NULL DEFAULT 0,
  KEY `uid` (`uid`),
  KEY `faction` (`faction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-farm`
--

CREATE TABLE `since-farm` (
  `uid` bigint(20) NOT NULL PRIMARY KEY,
  `water` int(11) NOT NULL,
  `nasiona` int(11) NOT NULL,
  `nawozy` int(11) NOT NULL,
  `data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-gift`
--

CREATE TABLE `since-gift` (
  `uid` bigint(20) NOT NULL PRIMARY KEY,
  `data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-houses`
--

CREATE TABLE `since-houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` int(11) NOT NULL,
  `position` text NOT NULL,
  `interior` int(11) NOT NULL,
  `items` text NOT NULL,
  `locked` int(11) NOT NULL DEFAULT 1,
  `price` int(11) NOT NULL,
  `members` text NOT NULL DEFAULT '[]',
  `houseType` int(11) NOT NULL DEFAULT 0,
  `chestItems` text NOT NULL DEFAULT '[]',
  `balance` bigint(20) NOT NULL DEFAULT 0,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-importExport`
--

CREATE TABLE `since-importExport` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL,
  `model` int(11) NOT NULL,
  `time` datetime NOT NULL DEFAULT current_timestamp(),
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-items`
--

CREATE TABLE `since-items` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL,
  `itemName` text NOT NULL,
  `data` text NOT NULL,
  `slotType` int(11) NOT NULL,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-jail`
--

CREATE TABLE `since-jail` (
  `uid` bigint(20) NOT NULL PRIMARY KEY,
  `time` int(11) NOT NULL,
  `admin` text NOT NULL,
  `reason` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-jobs`
--

CREATE TABLE `since-jobs` (
  `uid` bigint(20) NOT NULL PRIMARY KEY,
  `job` int(11) NOT NULL,
  KEY `job` (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-killstop`
--

CREATE TABLE `since-killstop` (
  `uid` bigint(20) NOT NULL,
  `data` text NOT NULL,
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-listy`
--

CREATE TABLE `since-listy` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `sender` bigint(20) NOT NULL,
  `receiver` bigint(20) NOT NULL,
  `title` text NOT NULL,
  `content` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `isRead` int(11) NOT NULL DEFAULT 0,
  KEY `sender` (`sender`),
  KEY `receiver` (`receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-lottery`
--

CREATE TABLE `since-lottery` (
  `uid` bigint(20) NOT NULL,
  `number` int(11) NOT NULL,
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-mandates`
--

CREATE TABLE `since-mandates` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `uid` bigint(20) NOT NULL,
  `reason` text NOT NULL,
  `price` bigint(20) NOT NULL,
  `officer` text NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `paid` int(11) NOT NULL DEFAULT 0,
  KEY `uid` (`uid`),
  KEY `paid` (`paid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-mdt`
--

CREATE TABLE `since-mdt` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `uid` bigint(20) NOT NULL,
  `title` text NOT NULL,
  `content` text NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `officer` text NOT NULL,
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-newyear`
--

CREATE TABLE `since-newyear` (
  `uid` bigint(20) NOT NULL PRIMARY KEY,
  `time` int(11) NOT NULL,
  `points` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-orgs`
--

CREATE TABLE `since-orgs` (
  `uid` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL,
  `name` text NOT NULL,
  `tag` text NOT NULL,
  `color` text NOT NULL,
  `members` text NOT NULL DEFAULT '[]',
  `bank` bigint(20) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `exp` bigint(20) NOT NULL DEFAULT 0,
  `spawn` text NOT NULL DEFAULT '',
  `ranks` text NOT NULL DEFAULT '[]',
  `vehicles` text NOT NULL DEFAULT '[]',
  `parking` text NOT NULL DEFAULT '',
  `skin` int(11) NOT NULL DEFAULT 0,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-orgs-logs`
--

CREATE TABLE `since-orgs-logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `org` int(11) NOT NULL,
  `text` text NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  KEY `org` (`org`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-orgs-vehicles`
--

CREATE TABLE `since-orgs-vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `org` int(11) NOT NULL,
  `model` int(11) NOT NULL,
  `position` text NOT NULL,
  `rotation` int(11) NOT NULL DEFAULT 0,
  `color` text NOT NULL DEFAULT '[255,255,255]',
  `upgrades` text NOT NULL DEFAULT '[]',
  `paintjob` int(11) NOT NULL DEFAULT 3,
  `plate` text NOT NULL DEFAULT '',
  `hp` int(11) NOT NULL DEFAULT 1000,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `locked` int(11) NOT NULL DEFAULT 1,
  KEY `org` (`org`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-players-records`
--

CREATE TABLE `since-players-records` (
  `uid` bigint(20) NOT NULL PRIMARY KEY,
  `data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-policeParking`
--

CREATE TABLE `since-policeParking` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL,
  `reason` text NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `price` bigint(20) NOT NULL,
  `officer` text NOT NULL,
  `vehicleModel` int(11) NOT NULL,
  `vehicleID` int(11) NOT NULL,
  `paid` int(11) NOT NULL DEFAULT 0,
  KEY `owner` (`owner`),
  KEY `paid` (`paid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-prices`
--

CREATE TABLE `since-prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `itemName` varchar(100) NOT NULL,
  `price` int(11) NOT NULL,
  UNIQUE KEY `itemName` (`itemName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-punishments`
--

CREATE TABLE `since-punishments` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `uid` bigint(20) NOT NULL,
  `type` varchar(50) NOT NULL,
  `reason` text NOT NULL,
  `admin` text NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `time` int(11) NOT NULL DEFAULT 0,
  KEY `uid` (`uid`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-salony`
--

CREATE TABLE `since-salony` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL,
  `name` text NOT NULL,
  `position` text NOT NULL,
  `balance` bigint(20) NOT NULL DEFAULT 0,
  `vehicles` text NOT NULL DEFAULT '[]',
  `members` text NOT NULL DEFAULT '[]',
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-stereo`
--

CREATE TABLE `since-stereo` (
  `uid` bigint(20) NOT NULL PRIMARY KEY,
  `url` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-users`
--

CREATE TABLE `since-users` (
  `uid` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `login` varchar(100) NOT NULL,
  `nick` varchar(50) NOT NULL,
  `password` varchar(32) NOT NULL,
  `serial` varchar(100) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `money` bigint(20) NOT NULL DEFAULT 5000,
  `skin` int(11) NOT NULL DEFAULT 0,
  `bankMoney` bigint(20) NOT NULL DEFAULT 0,
  `registerDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `playedTime` int(11) NOT NULL DEFAULT 0,
  `premium` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `srp` int(11) NOT NULL DEFAULT 0,
  `inventory` text NOT NULL DEFAULT '[]',
  `licenses` text NOT NULL DEFAULT '[]',
  `avatar` varchar(255) NOT NULL DEFAULT '',
  `lastPos` text NOT NULL DEFAULT '0, 0, 0, 0, 0',
  `kod` varchar(255) NOT NULL DEFAULT 'needToChange',
  `shaders` text NOT NULL DEFAULT '[]',
  `daily_date` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `daily_count` bigint(20) NOT NULL DEFAULT 0,
  `daily_selected` int(11) NOT NULL DEFAULT 0,
  `daily_info` varchar(255) NOT NULL DEFAULT '',
  `friends` text NOT NULL DEFAULT '[]',
  `jobStats` text NOT NULL DEFAULT '[]',
  `skinsBought` text NOT NULL DEFAULT '[]',
  `coal` int(11) NOT NULL DEFAULT 0,
  `premiumPoints` bigint(20) NOT NULL DEFAULT 0,
  `data` text NOT NULL DEFAULT '[]',
  `calender` text NOT NULL DEFAULT '[]',
  `factionTime` bigint(20) NOT NULL DEFAULT 0,
  `fat` int(11) NOT NULL DEFAULT 0,
  `miesnie` int(11) NOT NULL DEFAULT 0,
  `clothes` text NOT NULL DEFAULT 'brak',
  `changenick` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `topHours` bigint(20) NOT NULL DEFAULT 0,
  `promocode` varchar(255) NOT NULL DEFAULT '',
  `usingPromocode` int(11) NOT NULL DEFAULT 0,
  `promocodeCount` int(11) NOT NULL DEFAULT 0,
  `codeReward_1` int(11) NOT NULL DEFAULT 0,
  `codeReward_2` int(11) NOT NULL DEFAULT 0,
  `codeReward_3` int(11) NOT NULL DEFAULT 0,
  `wPLN` bigint(20) NOT NULL DEFAULT 0,
  `dailyQuestDate` date NOT NULL DEFAULT '1970-01-01',
  `dailyQuestDays` int(11) NOT NULL DEFAULT 0,
  `dailyQuestStats` text DEFAULT NULL,
  `visualRank` varchar(255) NOT NULL DEFAULT '',
  `eventState` int(11) NOT NULL DEFAULT 1,
  `eventData` text NOT NULL DEFAULT '[]',
  `collectingEventStats` text DEFAULT NULL,
  UNIQUE KEY `login` (`login`),
  UNIQUE KEY `serial` (`serial`),
  KEY `nick` (`nick`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-vehicles`
--

CREATE TABLE `since-vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL,
  `model` int(11) NOT NULL,
  `position` text NOT NULL DEFAULT '0,0,0',
  `rotation` int(11) NOT NULL DEFAULT 0,
  `color` text NOT NULL DEFAULT '[255,255,255,255,255,255]',
  `upgrades` text NOT NULL DEFAULT '[]',
  `paintjob` int(11) NOT NULL DEFAULT 3,
  `plate` varchar(20) NOT NULL DEFAULT '',
  `hp` int(11) NOT NULL DEFAULT 1000,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `locked` int(11) NOT NULL DEFAULT 1,
  `variant` text NOT NULL DEFAULT '[255,255]',
  `handling` int(11) NOT NULL DEFAULT 0,
  `wheels` int(11) NOT NULL DEFAULT 0,
  `neon` text NOT NULL DEFAULT '[]',
  `interior` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0,
  `mileage` bigint(20) NOT NULL DEFAULT 0,
  KEY `owner` (`owner`),
  KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-vouchers`
--

CREATE TABLE `since-vouchers` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `code` varchar(50) NOT NULL,
  `type` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  `used` int(11) NOT NULL DEFAULT 0,
  `usedBy` bigint(20) NOT NULL DEFAULT 0,
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-weed`
--

CREATE TABLE `since-weed` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL,
  `stage` int(11) NOT NULL DEFAULT 0,
  `water` int(11) NOT NULL DEFAULT 0,
  `fertilizer` int(11) NOT NULL DEFAULT 0,
  `spotID` int(11) NOT NULL,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-weed-plants`
--

CREATE TABLE `since-weed-plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL,
  `quality` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-weed-spots`
--

CREATE TABLE `since-weed-spots` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `owner` bigint(20) NOT NULL DEFAULT 0,
  `position` text NOT NULL,
  `locked` int(11) NOT NULL DEFAULT 0,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-znajdzki`
--

CREATE TABLE `since-znajdzki` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `position` text NOT NULL,
  `name` varchar(100) NOT NULL,
  `found` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-zones`
--

CREATE TABLE `since-zones` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(100) NOT NULL,
  `owner` bigint(20) NOT NULL DEFAULT 0,
  `position` text NOT NULL,
  `size` text NOT NULL,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since-zonesNew`
--

CREATE TABLE `since-zonesNew` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(100) NOT NULL,
  `owner` bigint(20) NOT NULL DEFAULT 0,
  `data` text NOT NULL DEFAULT '[]',
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since_active-payments`
--

CREATE TABLE `since_active-payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `uid` bigint(20) NOT NULL,
  `amount` int(11) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `transaction_id` varchar(255) NOT NULL,
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `since_promocodes`
--

CREATE TABLE `since_promocodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `code` varchar(50) NOT NULL,
  `reward` text NOT NULL,
  `uses` int(11) NOT NULL DEFAULT 0,
  `maxUses` int(11) NOT NULL DEFAULT 1,
  `active` int(11) NOT NULL DEFAULT 1,
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Inserting owner account data
--

INSERT INTO `since-users` (
  `uid`, `login`, `nick`, `password`, `serial`, `ip`, 
  `money`, `bankMoney`, `skin`, `premium`, `srp`, 
  `premiumPoints`, `playedTime`, `topHours`,
  `licenses`, `inventory`, `data`, `jobStats`,
  `skinsBought`, `friends`, `shaders`, `calender`,
  `lastPos`, `avatar`, `kod`, `daily_date`, `daily_count`, 
  `daily_selected`, `daily_info`, `coal`, `fat`, `miesnie`,
  `clothes`, `changenick`, `promocode`, `usingPromocode`,
  `promocodeCount`, `codeReward_1`, `codeReward_2`, `codeReward_3`,
  `wPLN`, `dailyQuestDate`, `dailyQuestDays`, `dailyQuestStats`,
  `visualRank`, `eventState`, `eventData`, `collectingEventStats`
) VALUES (
  1, 'Wlasciciel', 'Wlasciciel', MD5('SinceRPG_Owner_2026_SecurePassword!'), 
  'OWNER_SERIAL_PLACEHOLDER', '127.0.0.1',
  999999999, 999999999, 0, DATE_ADD(NOW(), INTERVAL 10 YEAR), 999999999,
  999999999, 999999999, 999999999,
  '[["prawo_jazdy_a",1],["prawo_jazdy_b",1],["prawo_jazdy_c",1],["prawo_jazdy_motor",1],["prawo_jazdy_lodz",1],["prawo_jazdy_samolot",1],["licencja_broni",1],["licencja_pilota",1],["licencja_lowca",1]]',
  '[]', '[]', '[]', '[]', '[]', '[]', '[]',
  '1544.38, -1630.74, 13.38, 0, 0', '', 'needToChange', NOW(), 0,
  0, '', 0, 0, 0,
  'brak', NOW(), '', 0,
  0, 0, 0, 0,
  0, NOW(), 0, NULL,
  'Owner', 1, '[]', NULL
);

-- Owner Admin Entry
INSERT INTO `since-admins` (`serial`, `nick`, `level`, `actived`, `added`, `uid`, `reporty`, `stats`) 
VALUES ('OWNER_SERIAL_PLACEHOLDER', 'Wlasciciel', 10, NOW(), NOW(), 1, 0, '[]');

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
