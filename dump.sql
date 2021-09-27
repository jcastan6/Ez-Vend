/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: accounts
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: administrators
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `administrators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employeeId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `employeeId` (`employeeId`),
  CONSTRAINT `administrators_ibfk_1` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: clients
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: employeeroutes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `employeeroutes` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `routeId` int(11) NOT NULL,
  `employeeId` int(11) NOT NULL,
  PRIMARY KEY (`routeId`, `employeeId`),
  KEY `employeeId` (`employeeId`),
  CONSTRAINT `employeeroutes_ibfk_1` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employeeroutes_ibfk_2` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: employees
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `isTechnician` tinyint(1) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `machineTypeId` int(11) DEFAULT NULL,
  `routeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `machineTypeId` (`machineTypeId`),
  KEY `routeId` (`routeId`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`machineTypeId`) REFERENCES `machinetypes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: employeetasks
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `employeetasks` (
  `priority` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `routeId` int(11) NOT NULL,
  `maintenanceTaskId` int(11) NOT NULL,
  PRIMARY KEY (`routeId`, `maintenanceTaskId`),
  KEY `maintenanceTaskId` (`maintenanceTaskId`),
  CONSTRAINT `employeetasks_ibfk_1` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employeetasks_ibfk_2` FOREIGN KEY (`maintenanceTaskId`) REFERENCES `maintenancetasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: machinetypes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `machinetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenancehistories
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenancehistories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `maintenanceId` int(11) DEFAULT NULL,
  `employeeId` int(11) DEFAULT NULL,
  `vendingMachineId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `maintenanceId` (`maintenanceId`),
  KEY `employeeId` (`employeeId`),
  KEY `vendingMachineId` (`vendingMachineId`),
  CONSTRAINT `maintenancehistories_ibfk_1` FOREIGN KEY (`maintenanceId`) REFERENCES `maintenancetasks` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `maintenancehistories_ibfk_2` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `maintenancehistories_ibfk_3` FOREIGN KEY (`vendingMachineId`) REFERENCES `vendingmachines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenancetasks
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenancetasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task` varchar(255) DEFAULT NULL,
  `emergency` tinyint(1) DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  `daysCount` int(11) DEFAULT '0',
  `pastDue` tinyint(1) DEFAULT '0',
  `reminderAt` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(255) DEFAULT NULL,
  `employeesId` int(11) DEFAULT NULL,
  `routeId` int(11) DEFAULT NULL,
  `vendingMachineId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employeesId` (`employeesId`),
  KEY `routeId` (`routeId`),
  KEY `vendingMachineId` (`vendingMachineId`),
  CONSTRAINT `maintenancetasks_ibfk_1` FOREIGN KEY (`employeesId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `maintenancetasks_ibfk_2` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `maintenancetasks_ibfk_3` FOREIGN KEY (`vendingMachineId`) REFERENCES `vendingmachines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: routes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: secrets
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `secrets` (
  `password` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`password`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: vendingmachines
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vendingmachines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `machineNo` int(11) DEFAULT NULL,
  `serialNo` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `model` varchar(255) DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `typeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `clientId` (`clientId`),
  KEY `typeId` (`typeId`),
  CONSTRAINT `vendingmachines_ibfk_1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `vendingmachines_ibfk_2` FOREIGN KEY (`typeId`) REFERENCES `machinetypes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: accounts
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: administrators
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `administrators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employeeId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `employeeId` (`employeeId`),
  CONSTRAINT `administrators_ibfk_1` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: clients
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: employeeroutes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `employeeroutes` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `routeId` int(11) NOT NULL,
  `employeeId` int(11) NOT NULL,
  PRIMARY KEY (`routeId`, `employeeId`),
  KEY `employeeId` (`employeeId`),
  CONSTRAINT `employeeroutes_ibfk_1` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employeeroutes_ibfk_2` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: employees
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `isTechnician` tinyint(1) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `machineTypeId` int(11) DEFAULT NULL,
  `routeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `machineTypeId` (`machineTypeId`),
  KEY `routeId` (`routeId`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`machineTypeId`) REFERENCES `machinetypes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: employeetasks
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `employeetasks` (
  `priority` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `routeId` int(11) NOT NULL,
  `maintenanceTaskId` int(11) NOT NULL,
  PRIMARY KEY (`routeId`, `maintenanceTaskId`),
  KEY `maintenanceTaskId` (`maintenanceTaskId`),
  CONSTRAINT `employeetasks_ibfk_1` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employeetasks_ibfk_2` FOREIGN KEY (`maintenanceTaskId`) REFERENCES `maintenancetasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: machinetypes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `machinetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenancehistories
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenancehistories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `maintenanceId` int(11) DEFAULT NULL,
  `employeeId` int(11) DEFAULT NULL,
  `vendingMachineId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `maintenanceId` (`maintenanceId`),
  KEY `employeeId` (`employeeId`),
  KEY `vendingMachineId` (`vendingMachineId`),
  CONSTRAINT `maintenancehistories_ibfk_1` FOREIGN KEY (`maintenanceId`) REFERENCES `maintenancetasks` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `maintenancehistories_ibfk_2` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `maintenancehistories_ibfk_3` FOREIGN KEY (`vendingMachineId`) REFERENCES `vendingmachines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenancetasks
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenancetasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task` varchar(255) DEFAULT NULL,
  `emergency` tinyint(1) DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  `daysCount` int(11) DEFAULT '0',
  `pastDue` tinyint(1) DEFAULT '0',
  `reminderAt` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(255) DEFAULT NULL,
  `employeesId` int(11) DEFAULT NULL,
  `routeId` int(11) DEFAULT NULL,
  `vendingMachineId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employeesId` (`employeesId`),
  KEY `routeId` (`routeId`),
  KEY `vendingMachineId` (`vendingMachineId`),
  CONSTRAINT `maintenancetasks_ibfk_1` FOREIGN KEY (`employeesId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `maintenancetasks_ibfk_2` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `maintenancetasks_ibfk_3` FOREIGN KEY (`vendingMachineId`) REFERENCES `vendingmachines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: routes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: secrets
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `secrets` (
  `password` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`password`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: vendingmachines
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vendingmachines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `machineNo` int(11) DEFAULT NULL,
  `serialNo` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `model` varchar(255) DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `typeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `clientId` (`clientId`),
  KEY `typeId` (`typeId`),
  CONSTRAINT `vendingmachines_ibfk_1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `vendingmachines_ibfk_2` FOREIGN KEY (`typeId`) REFERENCES `machinetypes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: accounts
# ------------------------------------------------------------

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: accounts
# ------------------------------------------------------------


# ------------------------------------------------------------

# DATA DUMP FOR TABLE: administrators
# ------------------------------------------------------------

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: administrators
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: clients

# ------------------------------------------------------------
# ------------------------------------------------------------

# DATA DUMP FOR TABLE: clients

# ------------------------------------------------------------
# ------------------------------------------------------------

# DATA DUMP FOR TABLE: employeeroutes

# ------------------------------------------------------------
# ------------------------------------------------------------

# DATA DUMP FOR TABLE: employeeroutes
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employees
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeetasks
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employees
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: machinetypes
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeetasks
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancehistories
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: machinetypes
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancetasks
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancehistories
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancetasks
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: routes
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: routes
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: secrets
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: secrets
# ------------------------------------------------------------

INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$0hYDLY.VRD7VRNYbvfZSpObO.LTACLu1hb7UyB5kSiVpZySMIoLm.',
    '2021-09-27 03:07:31',
    '2021-09-27 03:07:31'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$2m8hZiLVS8BQdfQXOrpMzeTmr9H.inFOxYGLNML26yjyJlJ7LXOzS',
    '2021-09-27 03:55:36',
    '2021-09-27 03:55:36'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$2w98GhErDNL67WO4ZL39RuWFxhy25eGoKqIFFQCZSGjakqhXXmRU2',
    '2021-09-27 03:57:27',
    '2021-09-27 03:57:27'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$6H6m.hUN8hX8EE7bXsChF.MnNhOTj8cs3jx8Wpove8isFyFq1SUpm',
    '2021-09-27 04:03:02',
    '2021-09-27 04:03:02'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$7mMjtaJ7FGiakDW3Aj0CNus8EQBX6B.blh/auVUG54vmNOfTpF1lK',
    '2021-09-27 03:52:36',
    '2021-09-27 03:52:36'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$8Qt4d2cAJgs1TdyDfv3aj.Z6YB.SbdaLCiEIDo3j.kIBxlyQe.wzu',
    '2021-09-27 03:56:55',
    '2021-09-27 03:56:55'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$91siA0C0o4mle1VBzeHL6OlcmTZmgAlZO7iJAjeOigJQ6NGg5JibK',
    '2021-09-27 04:01:32',
    '2021-09-27 04:01:32'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$94qBQWzfg8qBHxJboakJJeXnmeBYcvA/E0QwuMR4UYd/fn/lVquc.',
    '2021-09-27 03:11:21',
    '2021-09-27 03:11:21'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$aD85Itzb8QgdTrC.LnUwA.OL6KSzThhN9Pzte7ll3yV4cmcAUxZUK',
    '2021-09-27 03:49:32',
    '2021-09-27 03:49:32'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$aPWCUbrjlqymqNPuRIC9kekXOPq7Zu2wsOGThZbw52addcc55w4ha',
    '2021-09-27 02:29:08',
    '2021-09-27 02:29:08'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$B0GwBXHjWE7aRUCFSdT8eujBfDItDXyvwX64UESo0H6Hn66Nb7GRC',
    '2021-09-27 03:55:11',
    '2021-09-27 03:55:11'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$C0uLEyV0bXcZnMu43VXcreh8VA4DavWa5ge5pU1L2ZkI5w.4pJJs6',
    '2021-09-27 03:59:43',
    '2021-09-27 03:59:43'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$CV.zVaN8uZUSorbxTq8kCuYJiWsupj6JV5CNpneFPJcShyNAwpEfi',
    '2021-09-27 03:58:24',
    '2021-09-27 03:58:24'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$dB8FMZ5O06.8DqPSqxtR5OmVzG.WnYIvIlnCLnt2g67L6nPAlBYCy',
    '2021-09-27 03:57:06',
    '2021-09-27 03:57:06'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$DvRnQiXRJMi16j3/xo6XA.edh99WCZx3KBBxlJB2smcjDviab/nSq',
    '2021-09-27 04:00:24',
    '2021-09-27 04:00:24'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$eB09JbW6tOGHNnnl0qx8FunhC0dPwH3ensvuTUJs7J31R001uhAWG',
    '2021-09-27 02:28:43',
    '2021-09-27 02:28:43'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$foZ5EoGWfaeYJBaFgv4wdOrnTGpI.KCX8f/ww9somYfLL1cb.Vgha',
    '2021-09-27 03:32:28',
    '2021-09-27 03:32:28'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$fZA3M1SpryFr7RiIdhy.meuWJdpeGryLNrqyQ2G/ZRHQ0FYCIzVi2',
    '2021-09-27 03:30:19',
    '2021-09-27 03:30:19'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$IGw.QJy/ZIE..lqmZ.ab0uZgjtZjG0UxMBk3AQK8cl0xGLlbVjfAS',
    '2021-09-27 03:31:46',
    '2021-09-27 03:31:46'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$KxvrSOy6DGzBN0b4GNRNxu0UmVIn0y/777BxS2yONoc0DWs9ZBvFa',
    '2021-09-27 04:00:15',
    '2021-09-27 04:00:15'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$lYSV0BzSjJQbJXYDDBuLReihXx0OrCmjhYnUwcrjjCYF/X0s2jLNC',
    '2021-09-27 03:28:13',
    '2021-09-27 03:28:13'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$MeRrD5sCKT5OSJetOSGbJ.VTmfRX74.tqiZr3WgI77vyplKkef.E.',
    '2021-09-27 03:56:47',
    '2021-09-27 03:56:47'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$mkpvf7fUmHnZpeoT.b./k.YK9WA9hABNwbvC.M2tZ5qFZZ4Gl36vC',
    '2021-09-27 02:24:35',
    '2021-09-27 02:24:35'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$mPiqAqKP9/8xX87j.V2tG.Hj9hXGLqleH4NQ8QGG0OBqheLTjfPWu',
    '2021-09-27 03:51:54',
    '2021-09-27 03:51:54'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$ms2T035WjtJMRnN0MEAGC.psftWg4i6cWJolXnXD0p9tgeSykAIrC',
    '2021-09-27 04:14:52',
    '2021-09-27 04:14:52'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$MtmEQMm3tNdPg7iCWCo0QOXsktUMcc5hk6N4sQ4JVS6d3Zq5zTrmS',
    '2021-09-27 03:51:38',
    '2021-09-27 03:51:38'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$MZ0ik/mko3wiUeWXWsGrRuBgjYnuIo2I/1ZeD0F/Bkr86TVEU5whu',
    '2021-09-27 02:28:52',
    '2021-09-27 02:28:52'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$P2rHPNAcBPrqwES43nCXJ.TYMNrC5ANCj1Gai7qPSoBuQWac0RtpG',
    '2021-09-27 03:08:04',
    '2021-09-27 03:08:04'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$pnkHULpr/DzgG/nt6EFahuTj8FPjN4mzPYjzM3gYiHt24Pz08HhvC',
    '2021-09-27 03:08:13',
    '2021-09-27 03:08:13'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$qR5UNcEX4gYDIxT/VtY4le43YTmeR8j9auQx.uAgO/yS3PIqqFJVW',
    '2021-09-27 02:25:05',
    '2021-09-27 02:25:05'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$qSQHZTapW0OZfdNWrSr6Oe4NqY0VowcTxQTMTE.1s0v/8tbviaGv.',
    '2021-09-27 03:58:36',
    '2021-09-27 03:58:36'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$s5BAYuD28fpBArNeeIWJWu3GnovHfteL9oedQ.EUxaqFexd7imJre',
    '2021-09-27 02:28:20',
    '2021-09-27 02:28:20'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$Sh0JiVmsmv4bTMNNiOyjmuw.si9V/uHjNWBfc6gT9n.P2Fdgn9n5m',
    '2021-09-27 03:51:22',
    '2021-09-27 03:51:22'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$t9s20UwLhF5PJ2x1nnBOeenuxqavm.oiz54/icam7wtpWsamoyyxK',
    '2021-09-27 03:05:51',
    '2021-09-27 03:05:51'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$uilQtFhttEN3EFiF/D9azeQtY/gsXG4hFfVVRt1GVM8oHvs0/qmN2',
    '2021-09-27 03:56:09',
    '2021-09-27 03:56:09'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$uN8u1rQ0o4syCn.8.LCbreWIfO.XPtFXc7PxAHSzx6oNwaeRzJ5B2',
    '2021-09-27 03:58:40',
    '2021-09-27 03:58:40'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$UrYlmFcT6WAVS0wBbboQouNjxNqH8HdPg90zY6JtGZiAvN7EZaiZK',
    '2021-09-27 03:11:27',
    '2021-09-27 03:11:27'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$uVaEOB4lKhGHDtUsE.a2wuYUaYQY.Ia07pFRJkvUw25PtCwZ77beG',
    '2021-09-27 03:55:39',
    '2021-09-27 03:55:39'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$v3e15M1vdhUjywtXNVwR0urqS.XO7jZBVEYoQ6bgqGFpUkpUROIOa',
    '2021-09-27 02:24:25',
    '2021-09-27 02:24:25'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$viWA8hFNnTB8StnYnE3uWuo4dmoq9C7cEp9ny0T8lwC4/plSconJS',
    '2021-09-27 03:57:42',
    '2021-09-27 03:57:42'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$Xd7NZ1dp8lTq886cewPAnuFpvirwlUbYrIaUssVx6pTxiQtc/4qmK',
    '2021-09-27 04:00:57',
    '2021-09-27 04:00:57'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$xWWbdb7qIgskRj3rhyMF8OO5ixIe/gBRnBcu8i6DCGtf1HyE8mK92',
    '2021-09-27 03:13:14',
    '2021-09-27 03:13:14'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$yFF3.SeSQVcAq6IUVKUq..R0F9l36TbqkdikphJUaZvbmeeNUgJCG',
    '2021-09-27 03:52:15',
    '2021-09-27 03:52:15'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$Z73G9WDHp.3gE6BNyP4PDu5lH1kRfnN/yAVVwD3gEBRMMds2XxbMK',
    '2021-09-27 03:30:42',
    '2021-09-27 03:30:42'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vendingmachines
# ------------------------------------------------------------

INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$0hYDLY.VRD7VRNYbvfZSpObO.LTACLu1hb7UyB5kSiVpZySMIoLm.',
    '2021-09-27 03:07:31',
    '2021-09-27 03:07:31'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$2m8hZiLVS8BQdfQXOrpMzeTmr9H.inFOxYGLNML26yjyJlJ7LXOzS',
    '2021-09-27 03:55:36',
    '2021-09-27 03:55:36'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$2w98GhErDNL67WO4ZL39RuWFxhy25eGoKqIFFQCZSGjakqhXXmRU2',
    '2021-09-27 03:57:27',
    '2021-09-27 03:57:27'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$6H6m.hUN8hX8EE7bXsChF.MnNhOTj8cs3jx8Wpove8isFyFq1SUpm',
    '2021-09-27 04:03:02',
    '2021-09-27 04:03:02'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$7mMjtaJ7FGiakDW3Aj0CNus8EQBX6B.blh/auVUG54vmNOfTpF1lK',
    '2021-09-27 03:52:36',
    '2021-09-27 03:52:36'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$8Qt4d2cAJgs1TdyDfv3aj.Z6YB.SbdaLCiEIDo3j.kIBxlyQe.wzu',
    '2021-09-27 03:56:55',
    '2021-09-27 03:56:55'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$91siA0C0o4mle1VBzeHL6OlcmTZmgAlZO7iJAjeOigJQ6NGg5JibK',
    '2021-09-27 04:01:32',
    '2021-09-27 04:01:32'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$94qBQWzfg8qBHxJboakJJeXnmeBYcvA/E0QwuMR4UYd/fn/lVquc.',
    '2021-09-27 03:11:21',
    '2021-09-27 03:11:21'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$aD85Itzb8QgdTrC.LnUwA.OL6KSzThhN9Pzte7ll3yV4cmcAUxZUK',
    '2021-09-27 03:49:32',
    '2021-09-27 03:49:32'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$aPWCUbrjlqymqNPuRIC9kekXOPq7Zu2wsOGThZbw52addcc55w4ha',
    '2021-09-27 02:29:08',
    '2021-09-27 02:29:08'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$B0GwBXHjWE7aRUCFSdT8eujBfDItDXyvwX64UESo0H6Hn66Nb7GRC',
    '2021-09-27 03:55:11',
    '2021-09-27 03:55:11'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$C0uLEyV0bXcZnMu43VXcreh8VA4DavWa5ge5pU1L2ZkI5w.4pJJs6',
    '2021-09-27 03:59:43',
    '2021-09-27 03:59:43'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$CV.zVaN8uZUSorbxTq8kCuYJiWsupj6JV5CNpneFPJcShyNAwpEfi',
    '2021-09-27 03:58:24',
    '2021-09-27 03:58:24'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$dB8FMZ5O06.8DqPSqxtR5OmVzG.WnYIvIlnCLnt2g67L6nPAlBYCy',
    '2021-09-27 03:57:06',
    '2021-09-27 03:57:06'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$DvRnQiXRJMi16j3/xo6XA.edh99WCZx3KBBxlJB2smcjDviab/nSq',
    '2021-09-27 04:00:24',
    '2021-09-27 04:00:24'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$eB09JbW6tOGHNnnl0qx8FunhC0dPwH3ensvuTUJs7J31R001uhAWG',
    '2021-09-27 02:28:43',
    '2021-09-27 02:28:43'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$foZ5EoGWfaeYJBaFgv4wdOrnTGpI.KCX8f/ww9somYfLL1cb.Vgha',
    '2021-09-27 03:32:28',
    '2021-09-27 03:32:28'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$fZA3M1SpryFr7RiIdhy.meuWJdpeGryLNrqyQ2G/ZRHQ0FYCIzVi2',
    '2021-09-27 03:30:19',
    '2021-09-27 03:30:19'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$IGw.QJy/ZIE..lqmZ.ab0uZgjtZjG0UxMBk3AQK8cl0xGLlbVjfAS',
    '2021-09-27 03:31:46',
    '2021-09-27 03:31:46'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$KxvrSOy6DGzBN0b4GNRNxu0UmVIn0y/777BxS2yONoc0DWs9ZBvFa',
    '2021-09-27 04:00:15',
    '2021-09-27 04:00:15'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$lYSV0BzSjJQbJXYDDBuLReihXx0OrCmjhYnUwcrjjCYF/X0s2jLNC',
    '2021-09-27 03:28:13',
    '2021-09-27 03:28:13'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$MeRrD5sCKT5OSJetOSGbJ.VTmfRX74.tqiZr3WgI77vyplKkef.E.',
    '2021-09-27 03:56:47',
    '2021-09-27 03:56:47'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$mkpvf7fUmHnZpeoT.b./k.YK9WA9hABNwbvC.M2tZ5qFZZ4Gl36vC',
    '2021-09-27 02:24:35',
    '2021-09-27 02:24:35'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$mPiqAqKP9/8xX87j.V2tG.Hj9hXGLqleH4NQ8QGG0OBqheLTjfPWu',
    '2021-09-27 03:51:54',
    '2021-09-27 03:51:54'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$ms2T035WjtJMRnN0MEAGC.psftWg4i6cWJolXnXD0p9tgeSykAIrC',
    '2021-09-27 04:14:52',
    '2021-09-27 04:14:52'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$MtmEQMm3tNdPg7iCWCo0QOXsktUMcc5hk6N4sQ4JVS6d3Zq5zTrmS',
    '2021-09-27 03:51:38',
    '2021-09-27 03:51:38'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$MZ0ik/mko3wiUeWXWsGrRuBgjYnuIo2I/1ZeD0F/Bkr86TVEU5whu',
    '2021-09-27 02:28:52',
    '2021-09-27 02:28:52'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$P2rHPNAcBPrqwES43nCXJ.TYMNrC5ANCj1Gai7qPSoBuQWac0RtpG',
    '2021-09-27 03:08:04',
    '2021-09-27 03:08:04'
  );

INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$pnkHULpr/DzgG/nt6EFahuTj8FPjN4mzPYjzM3gYiHt24Pz08HhvC',
    '2021-09-27 03:08:13',
    '2021-09-27 03:08:13'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$qR5UNcEX4gYDIxT/VtY4le43YTmeR8j9auQx.uAgO/yS3PIqqFJVW',
    '2021-09-27 02:25:05',
    '2021-09-27 02:25:05'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$qSQHZTapW0OZfdNWrSr6Oe4NqY0VowcTxQTMTE.1s0v/8tbviaGv.',
    '2021-09-27 03:58:36',
    '2021-09-27 03:58:36'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$s5BAYuD28fpBArNeeIWJWu3GnovHfteL9oedQ.EUxaqFexd7imJre',
    '2021-09-27 02:28:20',
    '2021-09-27 02:28:20'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$Sh0JiVmsmv4bTMNNiOyjmuw.si9V/uHjNWBfc6gT9n.P2Fdgn9n5m',
    '2021-09-27 03:51:22',
    '2021-09-27 03:51:22'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$t9s20UwLhF5PJ2x1nnBOeenuxqavm.oiz54/icam7wtpWsamoyyxK',
    '2021-09-27 03:05:51',
    '2021-09-27 03:05:51'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$uilQtFhttEN3EFiF/D9azeQtY/gsXG4hFfVVRt1GVM8oHvs0/qmN2',
    '2021-09-27 03:56:09',
    '2021-09-27 03:56:09'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$uN8u1rQ0o4syCn.8.LCbreWIfO.XPtFXc7PxAHSzx6oNwaeRzJ5B2',
    '2021-09-27 03:58:40',
    '2021-09-27 03:58:40'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$UrYlmFcT6WAVS0wBbboQouNjxNqH8HdPg90zY6JtGZiAvN7EZaiZK',
    '2021-09-27 03:11:27',
    '2021-09-27 03:11:27'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$uVaEOB4lKhGHDtUsE.a2wuYUaYQY.Ia07pFRJkvUw25PtCwZ77beG',
    '2021-09-27 03:55:39',
    '2021-09-27 03:55:39'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$v3e15M1vdhUjywtXNVwR0urqS.XO7jZBVEYoQ6bgqGFpUkpUROIOa',
    '2021-09-27 02:24:25',
    '2021-09-27 02:24:25'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$viWA8hFNnTB8StnYnE3uWuo4dmoq9C7cEp9ny0T8lwC4/plSconJS',
    '2021-09-27 03:57:42',
    '2021-09-27 03:57:42'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$Xd7NZ1dp8lTq886cewPAnuFpvirwlUbYrIaUssVx6pTxiQtc/4qmK',
    '2021-09-27 04:00:57',
    '2021-09-27 04:00:57'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$xWWbdb7qIgskRj3rhyMF8OO5ixIe/gBRnBcu8i6DCGtf1HyE8mK92',
    '2021-09-27 03:13:14',
    '2021-09-27 03:13:14'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$yFF3.SeSQVcAq6IUVKUq..R0F9l36TbqkdikphJUaZvbmeeNUgJCG',
    '2021-09-27 03:52:15',
    '2021-09-27 03:52:15'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$Z73G9WDHp.3gE6BNyP4PDu5lH1kRfnN/yAVVwD3gEBRMMds2XxbMK',
    '2021-09-27 03:30:42',
    '2021-09-27 03:30:42'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vendingmachines
# ------------------------------------------------------------

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
