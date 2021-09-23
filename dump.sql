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
  `email` varchar(45) NOT NULL,
  `businessName` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `businessName` (`businessName`)
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
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
  `name` varchar(255) NOT NULL,
  `isTechnician` tinyint(1) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `machineTypeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `machineTypeId` (`machineTypeId`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`machineTypeId`) REFERENCES `machinetypes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenancehistories
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenancehistories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: routes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: accounts
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `businessName` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `businessName` (`businessName`)
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
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
  `name` varchar(255) NOT NULL,
  `isTechnician` tinyint(1) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `machineTypeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `machineTypeId` (`machineTypeId`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`machineTypeId`) REFERENCES `machinetypes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenancehistories
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenancehistories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: routes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# ------------------------------------------------------------
# DATA DUMP FOR TABLE: accounts
# ------------------------------------------------------------

# DATA DUMP FOR TABLE: accounts
# ------------------------------------------------------------

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: accounts
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `businessName` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `businessName` (`businessName`)
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
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
  `name` varchar(255) NOT NULL,
  `isTechnician` tinyint(1) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `machineTypeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `machineTypeId` (`machineTypeId`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`machineTypeId`) REFERENCES `machinetypes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenancehistories
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenancehistories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: routes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;



# ------------------------------------------------------------
# DATA DUMP FOR TABLE: administrators
# ------------------------------------------------------------

# ------------------------------------------------------------
# ------------------------------------------------------------
# DATA DUMP FOR TABLE: administrators
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: accounts
# DATA DUMP FOR TABLE: clients
# ------------------------------------------------------------

# ------------------------------------------------------------

# ------------------------------------------------------------

# DATA DUMP FOR TABLE: clients
# ------------------------------------------------------------

INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    2,
    'Brady',
    NULL,
    '2021-09-23 08:33:38',
    '2021-09-23 08:33:38'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeeroutes
# ------------------------------------------------------------

INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    2,
    'Brady',
    NULL,
    '2021-09-23 08:33:38',
    '2021-09-23 08:33:38'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeeroutes
# ------------------------------------------------------------

INSERT INTO
  `employeeroutes` (`createdAt`, `updatedAt`, `routeId`, `employeeId`)
VALUES
  ('2021-09-23 08:39:44', '2021-09-23 08:39:44', 1, 1);
INSERT INTO
  `employeeroutes` (`createdAt`, `updatedAt`, `routeId`, `employeeId`)
VALUES
  ('2021-09-23 08:39:44', '2021-09-23 08:39:44', 1, 1);

# ------------------------------------------------------------

# DATA DUMP FOR TABLE: employees
# ------------------------------------------------------------
# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employees

# ------------------------------------------------------------

INSERT INTO
  `employees` (
    `id`,
    `name`,
    `isTechnician`,
    `createdAt`,
    `updatedAt`,
    `machineTypeId`
  )
VALUES
  (
    1,
    'Jose Castañon',
    0,
    '2021-09-23 05:57:49',
    '2021-09-23 05:57:49',
    NULL
  );
INSERT INTO
  `employees` (
    `id`,
    `name`,
    `isTechnician`,
    `createdAt`,
    `updatedAt`,
    `machineTypeId`
  )
VALUES
  (
    1,
    'Jose Castañon',
    0,
    '2021-09-23 05:57:49',
    '2021-09-23 05:57:49',
    NULL
  );

# ------------------------------------------------------------


# DATA DUMP FOR TABLE: employeetasks
# ------------------------------------------------------------
# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeetasks

# ------------------------------------------------------------

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: administrators
# ------------------------------------------------------------

INSERT INTO
  `employeetasks` (
    `priority`,
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `maintenanceTaskId`
  )
VALUES
  (
    1,
    '2021-09-23 08:39:44',
    '2021-09-23 08:39:44',
    1,
    1
  );
INSERT INTO
  `employeetasks` (
    `priority`,
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `maintenanceTaskId`
  )
VALUES
  (
    1,
    '2021-09-23 08:39:44',
    '2021-09-23 08:39:44',
    1,
    1
  );
INSERT INTO
  `employeetasks` (
    `priority`,
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `maintenanceTaskId`
  )
VALUES
  (
    2,
    '2021-09-23 08:39:44',
    '2021-09-23 08:39:44',
    1,
    2
  );
INSERT INTO
  `employeetasks` (
    `priority`,
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `maintenanceTaskId`
  )
VALUES
  (
    0,
    '2021-09-23 08:39:44',
    '2021-09-23 08:39:44',
    1,
    3
  );
INSERT INTO
  `employeetasks` (
    `priority`,
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `maintenanceTaskId`
  )
VALUES
  (
    2,
    '2021-09-23 08:39:44',
    '2021-09-23 08:39:44',
    1,
    2
  );

INSERT INTO
  `employeetasks` (
    `priority`,
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `maintenanceTaskId`
  )
VALUES
  (
    0,
    '2021-09-23 08:39:44',
    '2021-09-23 08:39:44',
    1,
    3
  );
# ------------------------------------------------------------

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: machinetypes
# DATA DUMP FOR TABLE: machinetypes
# ------------------------------------------------------------
# ------------------------------------------------------------



# ------------------------------------------------------------
INSERT INTO
  `machinetypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    1,
    'Comida',
    '2021-09-23 05:57:46',
    '2021-09-23 05:57:46'
  );
# DATA DUMP FOR TABLE: clients

# ------------------------------------------------------------
# ------------------------------------------------------------

# DATA DUMP FOR TABLE: maintenancehistories
# ------------------------------------------------------------

INSERT INTO
  `machinetypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    1,
    'Comida',
    '2021-09-23 05:57:46',
    '2021-09-23 05:57:46'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    2,
    'Brady',
    NULL,
    '2021-09-23 08:33:38',
    '2021-09-23 08:33:38'
  );


# ------------------------------------------------------------
# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeeroutes
# DATA DUMP FOR TABLE: maintenancehistories
# ------------------------------------------------------------
# ------------------------------------------------------------



INSERT INTO
  `employeeroutes` (`createdAt`, `updatedAt`, `routeId`, `employeeId`)
VALUES
  ('2021-09-23 08:39:44', '2021-09-23 08:39:44', 1, 1);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employees
# ------------------------------------------------------------


# ------------------------------------------------------------
# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancetasks
# DATA DUMP FOR TABLE: maintenancetasks
# ------------------------------------------------------------
# ------------------------------------------------------------


INSERT INTO
  `maintenancetasks` (
    `id`,
    `task`,
    `emergency`,
    `completed`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    1,
    'hacer algo',
    0,
    0,
    1,
    1,
    4,
    '2021-09-23 05:58:08',
    '2021-09-23 05:59:58',
    NULL,
    1,
    1
  );
INSERT INTO
  `maintenancetasks` (
    `id`,
    `task`,
    `emergency`,
    `completed`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    2,
    'otra cosa',
    0,
    0,
    1,
    1,
    14,
    '2021-09-23 06:19:45',
    '2021-09-23 06:19:45',
    NULL,
    NULL,
    1
  );
INSERT INTO
  `maintenancetasks` (
    `id`,
    `task`,
    `emergency`,
    `completed`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    3,
    'se rompio esto',
    1,
    0,
    0,
    0,
    NULL,
    '2021-09-23 07:56:12',
    '2021-09-23 07:56:12',
    NULL,
    NULL,
    1
  );
INSERT INTO
  `maintenancetasks` (
    `id`,
    `task`,
    `emergency`,
    `completed`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    1,
    'hacer algo',
    0,
    0,
    1,
    1,
    4,
    '2021-09-23 05:58:08',
    '2021-09-23 05:59:58',
    NULL,
    1,
    1
  );

INSERT INTO
  `maintenancetasks` (
    `id`,
    `task`,
    `emergency`,
    `completed`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    2,
    'otra cosa',
    0,
    0,
    1,
    1,
    14,
    '2021-09-23 06:19:45',
    '2021-09-23 06:19:45',
    NULL,
    NULL,
    1
  );
# ------------------------------------------------------------
INSERT INTO
  `maintenancetasks` (
    `id`,
    `task`,
    `emergency`,
    `completed`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    3,
    'se rompio esto',
    1,
    0,
    0,
    0,
    NULL,
    '2021-09-23 07:56:12',
    '2021-09-23 07:56:12',
    NULL,
    NULL,
    1
  );
# DATA DUMP FOR TABLE: routes

# ------------------------------------------------------------
# ------------------------------------------------------------

# DATA DUMP FOR TABLE: routes
# ------------------------------------------------------------

INSERT INTO
  `employees` (
    `id`,
    `name`,
    `isTechnician`,
    `createdAt`,
    `updatedAt`,
    `machineTypeId`
  )
VALUES
  (
    1,
    'Jose Castañon',
    0,
    '2021-09-23 05:57:49',
    '2021-09-23 05:57:49',
    NULL
  );
INSERT INTO
  `routes` (`id`, `createdAt`, `updatedAt`, `name`)
VALUES
  (
    1,
    '2021-09-23 05:59:58',
    '2021-09-23 07:46:33',
    'asd'
  );

# ------------------------------------------------------------

# DATA DUMP FOR TABLE: employeetasks
# ------------------------------------------------------------
# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vendingmachines

# ------------------------------------------------------------

INSERT INTO
  `routes` (`id`, `createdAt`, `updatedAt`, `name`)
VALUES
  (
    1,
    '2021-09-23 05:59:58',
    '2021-09-23 07:46:33',
    'asd'
  );
INSERT INTO
  `employeetasks` (
    `priority`,
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `maintenanceTaskId`
  )
VALUES
  (
    1,
    '2021-09-23 08:39:44',
    '2021-09-23 08:39:44',
    1,
    1
  );
INSERT INTO
  `employeetasks` (
    `priority`,
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `maintenanceTaskId`
  )
VALUES
  (
    2,
    '2021-09-23 08:39:44',
    '2021-09-23 08:39:44',
    1,
    2
  );
INSERT INTO
  `employeetasks` (
    `priority`,
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `maintenanceTaskId`
  )
VALUES
  (
    0,
    '2021-09-23 08:39:44',
    '2021-09-23 08:39:44',
    1,
    3
  );


# ------------------------------------------------------------
# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vendingmachines
# DATA DUMP FOR TABLE: machinetypes
# ------------------------------------------------------------
# ------------------------------------------------------------


INSERT INTO
  `vendingmachines` (
    `id`,
    `machineNo`,
    `serialNo`,
    `createdAt`,
    `updatedAt`,
    `model`,
    `clientId`,
    `typeId`
  )
VALUES
  (
    1,
    124,
    '',
    '2021-09-23 05:57:59',
    '2021-09-23 08:34:03',
    '',
    2,
    1
  );
INSERT INTO
  `vendingmachines` (
    `id`,
    `machineNo`,
    `serialNo`,
    `createdAt`,
    `updatedAt`,
    `model`,
    `clientId`,
    `typeId`
  )
VALUES
  (
    1,
    124,
    '',
    '2021-09-23 05:57:59',
    '2021-09-23 08:34:03',
    '',
    2,
    1
  );
INSERT INTO
  `vendingmachines` (
    `id`,
    `machineNo`,
    `serialNo`,
    `createdAt`,
    `updatedAt`,
    `model`,
    `clientId`,
    `typeId`
  )
VALUES
  (
    2,
    8764,
    '',
    '2021-09-23 08:43:55',
    '2021-09-23 08:43:55',
    '',
    2,
    1
  );

INSERT INTO
  `machinetypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    1,
    'Comida',
    '2021-09-23 05:57:46',
    '2021-09-23 05:57:46'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancehistories
INSERT INTO
  `vendingmachines` (
    `id`,
    `machineNo`,
    `serialNo`,
    `createdAt`,
    `updatedAt`,
    `model`,
    `clientId`,
    `typeId`
  )
VALUES
  (
    2,
    8764,
    '',
    '2021-09-23 08:43:55',
    '2021-09-23 08:43:55',
    '',
    2,
    1
  );
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

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancetasks
# ------------------------------------------------------------

INSERT INTO
  `maintenancetasks` (
    `id`,
    `task`,
    `emergency`,
    `completed`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    1,
    'hacer algo',
    0,
    0,
    1,
    1,
    4,
    '2021-09-23 05:58:08',
    '2021-09-23 05:59:58',
    NULL,
    1,
    1
  );
INSERT INTO
  `maintenancetasks` (
    `id`,
    `task`,
    `emergency`,
    `completed`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    2,
    'otra cosa',
    0,
    0,
    1,
    1,
    14,
    '2021-09-23 06:19:45',
    '2021-09-23 06:19:45',
    NULL,
    NULL,
    1
  );
INSERT INTO
  `maintenancetasks` (
    `id`,
    `task`,
    `emergency`,
    `completed`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    3,
    'se rompio esto',
    1,
    0,
    0,
    0,
    NULL,
    '2021-09-23 07:56:12',
    '2021-09-23 07:56:12',
    NULL,
    NULL,
    1
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: routes
# ------------------------------------------------------------

INSERT INTO
  `routes` (`id`, `createdAt`, `updatedAt`, `name`)
VALUES
  (
    1,
    '2021-09-23 05:59:58',
    '2021-09-23 07:46:33',
    'asd'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vendingmachines
# ------------------------------------------------------------

INSERT INTO
  `vendingmachines` (
    `id`,
    `machineNo`,
    `serialNo`,
    `createdAt`,
    `updatedAt`,
    `model`,
    `clientId`,
    `typeId`
  )
VALUES
  (
    1,
    124,
    '',
    '2021-09-23 05:57:59',
    '2021-09-23 08:34:03',
    '',
    2,
    1
  );
INSERT INTO
  `vendingmachines` (
    `id`,
    `machineNo`,
    `serialNo`,
    `createdAt`,
    `updatedAt`,
    `model`,
    `clientId`,
    `typeId`
  )
VALUES
  (
    2,
    8764,
    '',
    '2021-09-23 08:43:55',
    '2021-09-23 08:43:55',
    '',
    2,
    1
  );

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
