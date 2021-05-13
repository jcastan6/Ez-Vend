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
  `accountId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accountId` (`accountId`),
  CONSTRAINT `clients_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: employees
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `accountId` int(11) DEFAULT NULL,
  `employeeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accountId` (`accountId`),
  KEY `employeeId` (`employeeId`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`employeeId`) REFERENCES `maintenances` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: machinetypes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `machinetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `typeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `typeId` (`typeId`),
  CONSTRAINT `machinetypes_ibfk_1` FOREIGN KEY (`typeId`) REFERENCES `vendingmachines` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 5 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenances
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenances` (
  `id` int(11) NOT NULL,
  `daysCount` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `maintenanceTaskId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `vendingMachineId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `maintenanceTaskId` (`maintenanceTaskId`),
  KEY `vendingMachineId` (`vendingMachineId`),
  CONSTRAINT `maintenances_ibfk_1` FOREIGN KEY (`maintenanceTaskId`) REFERENCES `maintenancetasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `maintenances_ibfk_2` FOREIGN KEY (`vendingMachineId`) REFERENCES `vendingmachines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenancetasks
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenancetasks` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `task` varchar(255) DEFAULT NULL,
  `recurring` tinyint(1) DEFAULT NULL,
  `reminderCount` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `machineTypeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `machineTypeId` (`machineTypeId`),
  CONSTRAINT `maintenancetasks_ibfk_1` FOREIGN KEY (`machineTypeId`) REFERENCES `machinetypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: routes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `machines` varchar(255) DEFAULT '[]',
  `employees` varchar(255) DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: vendingmachines
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vendingmachines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serialNo` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `model` varchar(255) DEFAULT NULL,
  `accountId` int(11) DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accountId` (`accountId`),
  KEY `clientId` (`clientId`),
  CONSTRAINT `vendingmachines_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vendingmachines_ibfk_2` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: accounts
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: administrators
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: clients
# ------------------------------------------------------------

INSERT INTO
  `clients` (
    `id`,
    `name`,
    `location`,
    `createdAt`,
    `updatedAt`,
    `accountId`
  )
VALUES
  (
    1,
    'Coca-Cola',
    NULL,
    '2021-05-13 22:44:22',
    '2021-05-13 22:44:22',
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employees
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: machinetypes
# ------------------------------------------------------------

INSERT INTO
  `machinetypes` (`id`, `type`, `createdAt`, `updatedAt`, `typeId`)
VALUES
  (
    1,
    'Cafe',
    '2021-05-13 22:50:03',
    '2021-05-13 22:50:03',
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenances
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancetasks
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: routes
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vendingmachines
# ------------------------------------------------------------


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
