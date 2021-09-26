/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

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
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    2,
    'este cliente',
    NULL,
    '2021-09-25 23:48:05',
    '2021-09-25 23:48:05'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeeroutes
# ------------------------------------------------------------

INSERT INTO
  `employeeroutes` (`createdAt`, `updatedAt`, `routeId`, `employeeId`)
VALUES
  ('2021-09-26 05:58:50', '2021-09-26 05:58:50', 3, 1);

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
    `machineTypeId`,
    `routeId`
  )
VALUES
  (
    1,
    'Jose Castañon',
    0,
    '2021-09-25 19:32:39',
    '2021-09-26 05:59:28',
    NULL,
    3
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeetasks
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
    3,
    '2021-09-26 05:59:28',
    '2021-09-26 05:59:28',
    3,
    15
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
    '2021-09-26 05:59:28',
    '2021-09-26 05:59:28',
    3,
    17
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
    '2021-09-26 05:59:28',
    '2021-09-26 05:59:28',
    3,
    20
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
    '2021-09-26 05:59:28',
    '2021-09-26 05:59:28',
    3,
    21
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: machinetypes
# ------------------------------------------------------------

INSERT INTO
  `machinetypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    1,
    'Comida',
    '2021-09-25 07:02:30',
    '2021-09-25 07:02:30'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancehistories
# ------------------------------------------------------------

INSERT INTO
  `maintenancehistories` (
    `id`,
    `createdAt`,
    `updatedAt`,
    `image`,
    `notes`,
    `maintenanceId`,
    `employeeId`,
    `vendingMachineId`
  )
VALUES
  (
    9,
    '2021-09-25 20:39:04',
    '2021-09-25 20:39:04',
    'https://storage.googleapis.com/ezvend/ttr.png',
    'aja',
    15,
    1,
    1
  );

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
    `image`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    15,
    'Limpiar x',
    0,
    0,
    0,
    1,
    0,
    '2021-09-25 20:37:57',
    '2021-09-26 05:59:14',
    NULL,
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
    `image`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    16,
    'Limpiar xasd',
    0,
    0,
    0,
    0,
    4,
    '2021-09-25 20:38:01',
    '2021-09-25 23:53:52',
    NULL,
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
    `image`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    17,
    'otra cosa',
    0,
    0,
    7,
    1,
    6,
    '2021-09-25 20:38:06',
    '2021-09-26 05:59:18',
    NULL,
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
    `image`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    20,
    'se rompio esto',
    1,
    0,
    0,
    0,
    NULL,
    '2021-09-26 04:12:29',
    '2021-09-26 04:12:29',
    'https://storage.googleapis.com/ezvend/DH2ohzjX.png',
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
    `image`,
    `employeesId`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  (
    21,
    'Panel Congelado',
    1,
    0,
    0,
    0,
    NULL,
    '2021-09-26 04:40:53',
    '2021-09-26 04:40:53',
    'https://storage.googleapis.com/ezvend/16326312241821653126543443159725.jpg',
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
    3,
    '2021-09-25 23:49:03',
    '2021-09-25 23:49:37',
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
    '2021-09-25 07:02:40',
    '2021-09-26 02:55:28',
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
  `routeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `machineTypeId` (`machineTypeId`),
  KEY `routeId` (`routeId`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`machineTypeId`) REFERENCES `machinetypes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE
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
) ENGINE = InnoDB AUTO_INCREMENT = 11 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB AUTO_INCREMENT = 22 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: routes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

