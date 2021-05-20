-- --------------------------------------------------------
-- Hôte :                        localhost
-- Version du serveur:           5.7.24 - MySQL Community Server (GPL)
-- SE du serveur:                Win64
-- HeidiSQL Version:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Listage de la structure de la base pour driftv
CREATE DATABASE IF NOT EXISTS `driftv` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `driftv`;

-- Listage de la structure de la table driftv. players
CREATE TABLE IF NOT EXISTS `players` (
  `pUniqueID` int(11) NOT NULL AUTO_INCREMENT,
  `money` int(11) NOT NULL DEFAULT '0',
  `license` varchar(255) NOT NULL DEFAULT '0',
  `driftPoint` int(11) NOT NULL DEFAULT '0',
  `exp` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `cars` text NOT NULL,
  `succes` text NOT NULL,
  `crew` varchar(255) NOT NULL DEFAULT '0',
  `crewOwner` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pUniqueID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Les données exportées n'étaient pas sélectionnées.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
