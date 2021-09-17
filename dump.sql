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
) ENGINE = InnoDB AUTO_INCREMENT = 6 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: machineroutes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `machineroutes` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `routeId` int(11) NOT NULL,
  `vendingMachineId` int(11) NOT NULL,
  PRIMARY KEY (`routeId`, `vendingMachineId`),
  KEY `vendingMachineId` (`vendingMachineId`),
  CONSTRAINT `machineroutes_ibfk_1` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `machineroutes_ibfk_2` FOREIGN KEY (`vendingMachineId`) REFERENCES `vendingmachines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
) ENGINE = InnoDB AUTO_INCREMENT = 9 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenancelogs
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenancelogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `daysCount` int(11) DEFAULT '0',
  `pastDue` tinyint(1) DEFAULT '0',
  `reminderAt` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `employeesId` int(11) DEFAULT NULL,
  `maintenanceTaskId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `vendingMachineId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employeesId` (`employeesId`),
  KEY `maintenanceTaskId` (`maintenanceTaskId`),
  KEY `vendingMachineId` (`vendingMachineId`),
  CONSTRAINT `maintenancelogs_ibfk_1` FOREIGN KEY (`employeesId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `maintenancelogs_ibfk_2` FOREIGN KEY (`maintenanceTaskId`) REFERENCES `maintenancetasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `maintenancelogs_ibfk_3` FOREIGN KEY (`vendingMachineId`) REFERENCES `vendingmachines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 6 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenancereports
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenancereports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task` varchar(255) NOT NULL,
  `priority` int(11) DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `employeeId` int(11) DEFAULT NULL,
  `vendingMachineId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employeeId` (`employeeId`),
  KEY `vendingMachineId` (`vendingMachineId`),
  CONSTRAINT `maintenancereports_ibfk_1` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `maintenancereports_ibfk_2` FOREIGN KEY (`vendingMachineId`) REFERENCES `vendingmachines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) NOT NULL,
  `days` varchar(255) DEFAULT '[]',
  `machines` varchar(255) DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 20 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
    'Philips',
    NULL,
    '2021-05-20 20:33:24',
    '2021-05-20 20:33:24'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    4,
    'Autoliv',
    NULL,
    '2021-05-20 20:33:41',
    '2021-05-20 20:33:41'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    5,
    'Covidien',
    NULL,
    '2021-05-20 20:33:49',
    '2021-05-20 20:33:49'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeeroutes
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employees
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: machineroutes
# ------------------------------------------------------------

INSERT INTO
  `machineroutes` (
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  ('2021-05-20 21:39:11', '2021-05-20 21:39:11', 13, 1);
INSERT INTO
  `machineroutes` (
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  ('2021-05-20 21:39:11', '2021-05-20 21:39:11', 13, 2);
INSERT INTO
  `machineroutes` (
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  ('2021-05-20 23:50:17', '2021-05-20 23:50:17', 19, 1);
INSERT INTO
  `machineroutes` (
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `vendingMachineId`
  )
VALUES
  ('2021-05-20 23:50:17', '2021-05-20 23:50:17', 19, 3);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: machinetypes
# ------------------------------------------------------------

INSERT INTO
  `machinetypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    1,
    'Cafe',
    '2021-05-20 20:33:11',
    '2021-05-20 20:33:11'
  );
INSERT INTO
  `machinetypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    2,
    'Soda',
    '2021-05-20 20:33:13',
    '2021-05-20 20:33:13'
  );
INSERT INTO
  `machinetypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    3,
    'Snack',
    '2021-05-20 20:33:15',
    '2021-05-20 20:33:15'
  );
INSERT INTO
  `machinetypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    4,
    'Comida',
    '2021-05-20 23:46:11',
    '2021-05-20 23:46:11'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancelogs
# ------------------------------------------------------------

INSERT INTO
  `maintenancelogs` (
    `id`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `maintenanceTaskId`,
    `vendingMachineId`
  )
VALUES
  (
    4,
    0,
    0,
    4,
    '2021-09-16 06:58:10',
    '2021-09-16 06:58:10',
    NULL,
    'e2aaa850-4604-4dce-a150-ea7fc871bcf4',
    1
  );
INSERT INTO
  `maintenancelogs` (
    `id`,
    `daysCount`,
    `pastDue`,
    `reminderAt`,
    `createdAt`,
    `updatedAt`,
    `employeesId`,
    `maintenanceTaskId`,
    `vendingMachineId`
  )
VALUES
  (
    5,
    0,
    0,
    4,
    '2021-09-16 06:58:10',
    '2021-09-16 06:58:10',
    NULL,
    'e2aaa850-4604-4dce-a150-ea7fc871bcf4',
    3
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancereports
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenancetasks
# ------------------------------------------------------------

INSERT INTO
  `maintenancetasks` (
    `id`,
    `task`,
    `recurring`,
    `reminderCount`,
    `createdAt`,
    `updatedAt`,
    `machineTypeId`
  )
VALUES
  (
    'e2aaa850-4604-4dce-a150-ea7fc871bcf4',
    'Limpiar x',
    0,
    4,
    '2021-09-16 06:58:10',
    '2021-09-16 06:58:10',
    1
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: routes
# ------------------------------------------------------------

INSERT INTO
  `routes` (
    `id`,
    `createdAt`,
    `updatedAt`,
    `name`,
    `days`,
    `machines`
  )
VALUES
  (
    13,
    '2021-05-20 21:39:11',
    '2021-09-15 06:18:30',
    'route 3',
    '\"\\\"[]\\\"\"',
    '[]'
  );
INSERT INTO
  `routes` (
    `id`,
    `createdAt`,
    `updatedAt`,
    `name`,
    `days`,
    `machines`
  )
VALUES
  (
    19,
    '2021-05-20 23:50:17',
    '2021-05-20 23:50:17',
    'Ruta Pacifico',
    '[]',
    '[]'
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
    666,
    '',
    '2021-05-20 20:34:03',
    '2021-09-17 03:11:29',
    'sretfg',
    4,
    2
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
    123,
    '',
    '2021-05-20 20:34:13',
    '2021-05-20 20:34:13',
    '',
    NULL,
    3
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
    3,
    403,
    '666',
    '2021-05-20 23:47:08',
    '2021-05-20 23:47:18',
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
