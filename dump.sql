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
) ENGINE = InnoDB AUTO_INCREMENT = 6 DEFAULT CHARSET = latin1;

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
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

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
) ENGINE = InnoDB AUTO_INCREMENT = 117 DEFAULT CHARSET = latin1;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: employeeRoutes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `employeeRoutes` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `routeId` int(11) NOT NULL,
  `employeeId` int(11) NOT NULL,
  PRIMARY KEY (`routeId`, `employeeId`),
  KEY `employeeId` (`employeeId`),
  CONSTRAINT `employeeRoutes_ibfk_1` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employeeRoutes_ibfk_2` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: employeeTasks
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `employeeTasks` (
  `priority` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `routeId` int(11) NOT NULL,
  `maintenanceTaskId` int(11) NOT NULL,
  PRIMARY KEY (`routeId`, `maintenanceTaskId`),
  KEY `maintenanceTaskId` (`maintenanceTaskId`),
  CONSTRAINT `employeeTasks_ibfk_1` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employeeTasks_ibfk_2` FOREIGN KEY (`maintenanceTaskId`) REFERENCES `maintenanceTasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

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
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`machineTypeId`) REFERENCES `machineTypes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 9 DEFAULT CHARSET = latin1;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: machineTypes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `machineTypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 5 DEFAULT CHARSET = latin1;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenanceHistories
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenanceHistories` (
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
  CONSTRAINT `maintenanceHistories_ibfk_1` FOREIGN KEY (`maintenanceId`) REFERENCES `maintenanceTasks` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `maintenanceHistories_ibfk_2` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `maintenanceHistories_ibfk_3` FOREIGN KEY (`vendingMachineId`) REFERENCES `vendingMachines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 13 DEFAULT CHARSET = latin1;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: maintenanceTasks
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `maintenanceTasks` (
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
  CONSTRAINT `maintenanceTasks_ibfk_1` FOREIGN KEY (`employeesId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `maintenanceTasks_ibfk_2` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `maintenanceTasks_ibfk_3` FOREIGN KEY (`vendingMachineId`) REFERENCES `vendingMachines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 22 DEFAULT CHARSET = latin1;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: routes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 8 DEFAULT CHARSET = latin1;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: secrets
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `secrets` (
  `password` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`password`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: vendingMachines
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vendingMachines` (
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
  CONSTRAINT `vendingMachines_ibfk_1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `vendingMachines_ibfk_2` FOREIGN KEY (`typeId`) REFERENCES `machineTypes` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 839 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: accounts
# ------------------------------------------------------------

INSERT INTO
  `accounts` (
    `id`,
    `username`,
    `password`,
    `createdAt`,
    `updatedAt`
  )
VALUES
  (
    1,
    'josecastanon',
    '$2b$10$h0lgqG0dudl/VBLWRc3Hge5VrQGABgnkZUxg/n2SdXUq52GnNh09i',
    '2021-09-27 05:15:58',
    '2021-09-27 05:15:58'
  );
INSERT INTO
  `accounts` (
    `id`,
    `username`,
    `password`,
    `createdAt`,
    `updatedAt`
  )
VALUES
  (
    2,
    'Gerardo reynoso',
    '$2b$10$y5xD7nLxl47Glk1JLNNUn.FlJy0A8Vai2qs4NMvVEHWX0vGDkcTMW',
    '2021-09-27 16:13:18',
    '2021-09-27 16:13:18'
  );
INSERT INTO
  `accounts` (
    `id`,
    `username`,
    `password`,
    `createdAt`,
    `updatedAt`
  )
VALUES
  (
    3,
    'fernando castanon',
    '$2b$10$AMgxsWfOBEHigTeXbFnbBuHsS/E3UTEpS7yUafEpCzhpF4Ug3FrM6',
    '2021-09-27 16:55:03',
    '2021-09-27 16:55:03'
  );
INSERT INTO
  `accounts` (
    `id`,
    `username`,
    `password`,
    `createdAt`,
    `updatedAt`
  )
VALUES
  (
    4,
    'sistemas',
    '$2b$10$rQwJfnj2FR3KEn7oQmF64u64BoH8llzK3WpkWU50ayUHSQHlLezRi',
    '2021-09-27 18:04:23',
    '2021-09-27 18:04:23'
  );
INSERT INTO
  `accounts` (
    `id`,
    `username`,
    `password`,
    `createdAt`,
    `updatedAt`
  )
VALUES
  (
    5,
    'fernandocy',
    '$2b$10$iIOHhezL9dsGJ41ck6JTtexURcZbkaG.e3YU0ppnZXK5WARce6eXu',
    '2021-09-28 23:32:39',
    '2021-09-28 23:32:39'
  );

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
    5,
    'ADAMANT',
    NULL,
    '2021-09-27 18:17:13',
    '2021-09-27 18:17:13'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    6,
    'AG INDUSTRIAS',
    NULL,
    '2021-09-27 18:17:46',
    '2021-09-27 18:17:46'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    7,
    'ALIAN PLASTIC',
    NULL,
    '2021-09-27 18:18:03',
    '2021-09-27 18:18:03'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    8,
    'ALUMINIOS ',
    NULL,
    '2021-09-27 18:18:08',
    '2021-09-27 18:18:08'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    9,
    'ALUMINIOS FLORIDO ',
    NULL,
    '2021-09-27 18:18:15',
    '2021-09-27 18:18:15'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    10,
    'ALUMINIOS HORNO ',
    NULL,
    '2021-09-27 18:18:23',
    '2021-09-27 18:18:23'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    11,
    'ALUMINIOS ll ',
    NULL,
    '2021-09-27 18:18:31',
    '2021-09-27 18:18:31'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    12,
    'AMEX',
    NULL,
    '2021-09-27 18:18:34',
    '2021-09-27 18:18:34'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    13,
    'AMS PLASTICS ',
    NULL,
    '2021-09-27 18:18:41',
    '2021-09-27 18:18:41'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    14,
    'APTIV',
    NULL,
    '2021-09-27 18:18:44',
    '2021-09-27 18:18:44'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    15,
    'ARCOSA',
    NULL,
    '2021-09-27 18:18:48',
    '2021-09-27 18:18:48'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    16,
    'ARRK',
    NULL,
    '2021-09-27 18:18:51',
    '2021-09-27 18:18:51'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    17,
    'ARTESANIAS',
    NULL,
    '2021-09-27 18:19:03',
    '2021-09-27 18:19:03'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    18,
    'AUTOLIV',
    NULL,
    '2021-09-27 18:19:10',
    '2021-09-27 18:19:10'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    19,
    'AVERY DENISON',
    NULL,
    '2021-09-27 18:19:19',
    '2021-09-27 18:19:19'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    20,
    'BASAL',
    NULL,
    '2021-09-27 18:19:24',
    '2021-09-27 18:19:24'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    21,
    'BELDEN',
    NULL,
    '2021-09-27 18:19:27',
    '2021-09-27 18:19:27'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    22,
    'BIOTIX',
    NULL,
    '2021-09-27 18:19:32',
    '2021-09-27 18:19:32'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    23,
    'BLOCK MEDICAL ',
    NULL,
    '2021-09-27 18:19:39',
    '2021-09-27 18:19:39'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    24,
    'BOSE',
    NULL,
    '2021-09-27 18:19:44',
    '2021-09-27 18:19:44'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    25,
    'BOURNS',
    NULL,
    '2021-09-27 18:19:47',
    '2021-09-27 18:19:47'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    26,
    'BRADY',
    NULL,
    '2021-09-27 18:19:52',
    '2021-09-27 18:19:52'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    28,
    'CALL CENTER INTEGON ',
    NULL,
    '2021-09-27 18:51:00',
    '2021-09-27 18:51:00'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    29,
    'CALL CENTER SIGUE ',
    NULL,
    '2021-09-27 18:51:14',
    '2021-09-27 18:51:14'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    30,
    'CARL ZEISS',
    NULL,
    '2021-09-27 18:51:32',
    '2021-09-27 18:51:32'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    31,
    'CARROCERIAS',
    NULL,
    '2021-09-27 18:51:41',
    '2021-09-27 18:51:41'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    32,
    'CETYS',
    NULL,
    '2021-09-27 18:51:45',
    '2021-09-27 18:51:45'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    33,
    'CHIYODA',
    NULL,
    '2021-09-27 18:51:50',
    '2021-09-27 18:51:50'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    34,
    'CJ TECH',
    NULL,
    '2021-09-27 18:51:54',
    '2021-09-27 18:51:54'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    35,
    'CLEARPAC',
    NULL,
    '2021-09-27 18:52:00',
    '2021-09-27 18:52:00'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    36,
    'CONSULADO AMERICANO',
    NULL,
    '2021-09-27 18:52:06',
    '2021-09-27 18:52:06'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    37,
    'COVIDIEN',
    NULL,
    '2021-09-27 18:52:13',
    '2021-09-27 18:52:13'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    38,
    'DAMANT',
    NULL,
    '2021-09-27 18:52:22',
    '2021-09-27 18:52:22'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    39,
    'DELA ',
    NULL,
    '2021-09-27 18:52:30',
    '2021-09-27 18:52:30'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    40,
    'DIAMOND ELECTRONICS',
    NULL,
    '2021-09-27 18:52:39',
    '2021-09-27 18:52:39'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    41,
    'DUCAMEX',
    NULL,
    '2021-09-27 18:52:43',
    '2021-09-27 18:52:43'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    42,
    'EATON ELECTRICAL',
    NULL,
    '2021-09-27 18:52:50',
    '2021-09-27 18:52:50'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    43,
    'ESTERLINE',
    NULL,
    '2021-09-27 18:52:58',
    '2021-09-27 18:52:58'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    44,
    'EXHIBIDORES',
    NULL,
    '2021-09-27 18:53:27',
    '2021-09-27 18:53:27'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    45,
    'GM MANUFACTURING',
    NULL,
    '2021-09-27 18:53:36',
    '2021-09-27 18:53:36'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    46,
    'GRUMA',
    NULL,
    '2021-09-27 18:53:40',
    '2021-09-27 18:53:40'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    47,
    'HOSPITAL GENERAL ',
    NULL,
    '2021-09-27 18:53:48',
    '2021-09-27 18:53:48'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    48,
    'HUNTER',
    NULL,
    '2021-09-27 18:53:51',
    '2021-09-27 18:53:51'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    49,
    'HYSON LA MESA',
    NULL,
    '2021-09-27 18:54:00',
    '2021-09-27 18:54:00'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    50,
    'HYSON LAGO',
    NULL,
    '2021-09-27 18:54:05',
    '2021-09-27 18:54:05'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    51,
    'HYSON MATRIZ',
    NULL,
    '2021-09-27 18:54:11',
    '2021-09-27 18:54:11'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    52,
    'HYSON OTAY',
    NULL,
    '2021-09-27 18:54:16',
    '2021-09-27 18:54:16'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    53,
    'INDUSTRIAS LA MESA',
    NULL,
    '2021-09-27 18:54:25',
    '2021-09-27 18:54:25'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    54,
    'INDUSTRIAS SECO ',
    NULL,
    '2021-09-27 18:54:31',
    '2021-09-27 18:54:31'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    55,
    'INSTITUTO TECNOLOGICO ',
    NULL,
    '2021-09-27 18:54:41',
    '2021-09-27 18:54:41'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    56,
    'INZI DISPLAY',
    NULL,
    '2021-09-27 18:54:47',
    '2021-09-27 18:54:47'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    57,
    'JACUZZI',
    NULL,
    '2021-09-27 18:54:51',
    '2021-09-27 18:54:51'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    58,
    'JAE',
    NULL,
    '2021-09-27 18:54:55',
    '2021-09-27 18:54:55'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    59,
    'KATOLEC',
    NULL,
    '2021-09-27 18:54:59',
    '2021-09-27 18:54:59'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    60,
    'KYOCERA',
    NULL,
    '2021-09-27 18:55:09',
    '2021-09-27 18:55:09'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    61,
    'LEACH INT',
    NULL,
    '2021-09-27 18:55:20',
    '2021-09-27 18:55:20'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    62,
    'LOGINAM',
    NULL,
    '2021-09-27 18:55:49',
    '2021-09-27 18:55:49'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    63,
    'MANEJO DE ENSAMBLES ',
    NULL,
    '2021-09-27 18:56:01',
    '2021-09-27 18:56:01'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    64,
    'MARRIOT',
    NULL,
    '2021-09-27 18:56:11',
    '2021-09-27 18:56:11'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    65,
    'MAXXON',
    NULL,
    '2021-09-27 18:58:37',
    '2021-09-27 18:58:37'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    66,
    'SILGAN',
    NULL,
    '2021-09-27 18:58:54',
    '2021-09-27 18:58:54'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    67,
    'MEDIMEXICO ',
    NULL,
    '2021-09-27 18:59:04',
    '2021-09-27 18:59:04'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    68,
    'MEDPLAST',
    NULL,
    '2021-09-27 18:59:12',
    '2021-09-27 18:59:12'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    69,
    'MEDTRONIC',
    NULL,
    '2021-09-27 18:59:23',
    '2021-09-27 18:59:23'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    70,
    'MOBEL CREATIV',
    NULL,
    '2021-09-27 18:59:31',
    '2021-09-27 18:59:31'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    71,
    'MULTIWING',
    NULL,
    '2021-09-27 18:59:38',
    '2021-09-27 18:59:38'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    72,
    'NEST INDUSTRIES',
    NULL,
    '2021-09-27 18:59:45',
    '2021-09-27 18:59:45'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    73,
    'ONTEX',
    NULL,
    '2021-09-27 18:59:49',
    '2021-09-27 18:59:49'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    74,
    'OPA VESTA',
    NULL,
    '2021-09-27 18:59:56',
    '2021-09-27 18:59:56'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    75,
    'OSSUR',
    NULL,
    '2021-09-27 19:00:00',
    '2021-09-27 19:00:00'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    76,
    'PANAMERICANO',
    NULL,
    '2021-09-27 19:00:07',
    '2021-09-27 19:00:07'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    77,
    'PANASONIC',
    NULL,
    '2021-09-27 19:00:13',
    '2021-09-27 19:00:13'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    78,
    'PCM RECLUTADORA',
    NULL,
    '2021-09-27 19:00:48',
    '2021-09-27 19:00:48'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    79,
    'PENINSULA CALL CENTER',
    NULL,
    '2021-09-27 19:00:58',
    '2021-09-27 19:00:58'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    80,
    'PHILIPS',
    NULL,
    '2021-09-27 19:01:05',
    '2021-09-27 19:01:05'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    81,
    'PLANTRONICS',
    NULL,
    '2021-09-27 19:01:10',
    '2021-09-27 19:01:10'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    82,
    'PLASTICOS AMC ',
    NULL,
    '2021-09-27 19:01:19',
    '2021-09-27 19:01:19'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    83,
    'PLATINADORA BAJA',
    NULL,
    '2021-09-27 19:01:50',
    '2021-09-27 19:01:50'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    84,
    'POSEY',
    NULL,
    '2021-09-27 19:01:54',
    '2021-09-27 19:01:54'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    85,
    'PRINTFUL',
    NULL,
    '2021-09-27 19:02:00',
    '2021-09-27 19:02:00'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    86,
    'RB MOTORS',
    NULL,
    '2021-09-27 19:02:07',
    '2021-09-27 19:02:07'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    87,
    'RECTIFICADORES',
    NULL,
    '2021-09-27 19:02:15',
    '2021-09-27 19:02:15'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    88,
    'RESIDENCIAL PIEDRAS NEGRAS',
    NULL,
    '2021-09-27 19:02:25',
    '2021-09-27 19:02:25'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    89,
    'ROCK WEST ',
    NULL,
    '2021-09-27 19:02:32',
    '2021-09-27 19:02:32'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    90,
    'SCHNEIDER ELECTRIC',
    NULL,
    '2021-09-27 19:02:42',
    '2021-09-27 19:02:42'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    91,
    'SINTEC',
    NULL,
    '2021-09-27 19:02:46',
    '2021-09-27 19:02:46'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    92,
    'SMITH ELECTRIC',
    NULL,
    '2021-09-27 19:02:56',
    '2021-09-27 19:02:56'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    93,
    'SMK',
    NULL,
    '2021-09-27 19:03:02',
    '2021-09-27 19:03:02'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    94,
    'SMURFIT KAPPA',
    NULL,
    '2021-09-27 19:03:13',
    '2021-09-27 19:03:13'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    95,
    'SNAIDER',
    NULL,
    '2021-09-27 19:03:17',
    '2021-09-27 19:03:17'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    96,
    'SONNEN',
    NULL,
    '2021-09-27 19:03:22',
    '2021-09-27 19:03:22'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    97,
    'SUNBANK',
    NULL,
    '2021-09-27 19:03:26',
    '2021-09-27 19:03:26'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    98,
    'SUNRISE',
    NULL,
    '2021-09-27 19:03:31',
    '2021-09-27 19:03:31'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    99,
    'SURGICAL SPECIALTIES',
    NULL,
    '2021-09-27 19:04:02',
    '2021-09-27 19:04:02'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    100,
    'TCL MOKA ',
    NULL,
    '2021-09-27 19:04:10',
    '2021-09-27 19:04:10'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    101,
    'TELVISTA CAMPESTRE',
    NULL,
    '2021-09-27 19:04:20',
    '2021-09-27 19:04:20'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    102,
    'TERMOFISHER',
    NULL,
    '2021-09-27 19:04:27',
    '2021-09-27 19:04:27'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    103,
    'TERMOFISHER',
    NULL,
    '2021-09-27 19:04:40',
    '2021-09-27 19:04:40'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    104,
    'THOMSON INDUSTRIES',
    NULL,
    '2021-09-27 19:04:53',
    '2021-09-27 19:04:53'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    105,
    'TOYOTA',
    NULL,
    '2021-09-27 19:05:01',
    '2021-09-27 19:05:01'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    106,
    'TURBOTECH',
    NULL,
    '2021-09-27 19:05:07',
    '2021-09-27 19:05:07'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    107,
    'UNIVERSIDAD DURANGO',
    NULL,
    '2021-09-27 19:05:15',
    '2021-09-27 19:05:15'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    108,
    'VIA CORPORATIVO ',
    NULL,
    '2021-09-27 19:05:23',
    '2021-09-27 19:05:23'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    109,
    'VOLEX',
    NULL,
    '2021-09-27 19:05:31',
    '2021-09-27 19:05:31'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    110,
    'HUNTER PLANTA 1',
    NULL,
    '2021-09-28 23:54:54',
    '2021-09-28 23:54:54'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    111,
    'HUNTER PLANTA 2',
    NULL,
    '2021-09-28 23:55:12',
    '2021-09-28 23:55:12'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    112,
    'HUNTER PLANTA 3',
    NULL,
    '2021-09-28 23:55:24',
    '2021-09-28 23:55:24'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    113,
    'MEDTRONIC PLANTA 1',
    NULL,
    '2021-09-28 23:55:30',
    '2021-09-28 23:55:30'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    114,
    'MEDTRONIC PLANTA 2',
    NULL,
    '2021-09-28 23:55:39',
    '2021-09-28 23:55:39'
  );
INSERT INTO
  `clients` (`id`, `name`, `location`, `createdAt`, `updatedAt`)
VALUES
  (
    115,
    'MEDTRONIC PLANTA 3',
    NULL,
    '2021-09-28 23:55:51',
    '2021-09-28 23:55:51'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeeRoutes
# ------------------------------------------------------------

INSERT INTO
  `employeeRoutes` (`createdAt`, `updatedAt`, `routeId`, `employeeId`)
VALUES
  ('2021-09-29 01:02:31', '2021-09-29 01:02:31', 7, 5);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employeeTasks
# ------------------------------------------------------------

INSERT INTO
  `employeeTasks` (
    `priority`,
    `createdAt`,
    `updatedAt`,
    `routeId`,
    `maintenanceTaskId`
  )
VALUES
  (
    0,
    '2021-09-29 01:02:31',
    '2021-09-29 01:02:31',
    7,
    21
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: employees
# ------------------------------------------------------------

INSERT INTO
  `employees` (
    `id`,
    `username`,
    `name`,
    `isTechnician`,
    `createdAt`,
    `updatedAt`,
    `machineTypeId`,
    `routeId`
  )
VALUES
  (
    4,
    'newuser',
    'Jose Castañon',
    0,
    '2021-09-27 15:12:36',
    '2021-09-28 23:42:20',
    NULL,
    NULL
  );
INSERT INTO
  `employees` (
    `id`,
    `username`,
    `name`,
    `isTechnician`,
    `createdAt`,
    `updatedAt`,
    `machineTypeId`,
    `routeId`
  )
VALUES
  (
    5,
    'joselopez',
    'Jose Lopez',
    0,
    '2021-09-27 16:33:54',
    '2021-09-29 01:02:31',
    NULL,
    7
  );
INSERT INTO
  `employees` (
    `id`,
    `username`,
    `name`,
    `isTechnician`,
    `createdAt`,
    `updatedAt`,
    `machineTypeId`,
    `routeId`
  )
VALUES
  (
    6,
    'julioespinoza',
    'JULIO ESPINOZA ',
    0,
    '2021-09-29 00:06:41',
    '2021-09-29 01:02:31',
    NULL,
    NULL
  );
INSERT INTO
  `employees` (
    `id`,
    `username`,
    `name`,
    `isTechnician`,
    `createdAt`,
    `updatedAt`,
    `machineTypeId`,
    `routeId`
  )
VALUES
  (
    7,
    'rubengarcia',
    'RUBEN GARCIA',
    0,
    '2021-09-29 00:06:57',
    '2021-09-29 00:06:57',
    NULL,
    NULL
  );
INSERT INTO
  `employees` (
    `id`,
    `username`,
    `name`,
    `isTechnician`,
    `createdAt`,
    `updatedAt`,
    `machineTypeId`,
    `routeId`
  )
VALUES
  (
    8,
    'andresespinoza',
    'Andres Espinoza',
    0,
    '2021-09-29 00:51:18',
    '2021-09-29 00:51:18',
    NULL,
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: machineTypes
# ------------------------------------------------------------

INSERT INTO
  `machineTypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    1,
    'Comida',
    '2021-09-27 05:19:57',
    '2021-09-27 05:19:57'
  );
INSERT INTO
  `machineTypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    2,
    'Cafe',
    '2021-09-27 16:24:48',
    '2021-09-27 16:24:48'
  );
INSERT INTO
  `machineTypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    3,
    'Soderas',
    '2021-09-27 16:24:56',
    '2021-09-27 16:24:56'
  );
INSERT INTO
  `machineTypes` (`id`, `type`, `createdAt`, `updatedAt`)
VALUES
  (
    4,
    'Snack',
    '2021-09-27 16:25:01',
    '2021-09-27 16:25:01'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenanceHistories
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: maintenanceTasks
# ------------------------------------------------------------

INSERT INTO
  `maintenanceTasks` (
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
    'Panel Congelado',
    1,
    1,
    0,
    0,
    NULL,
    '2021-09-28 23:41:09',
    '2021-09-28 23:43:57',
    NULL,
    NULL,
    NULL,
    683
  );
INSERT INTO
  `maintenanceTasks` (
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
    'CALIBRADO DE GRUPO CAFÉ ',
    0,
    0,
    0,
    1,
    0,
    '2021-09-29 00:09:52',
    '2021-09-29 00:12:04',
    NULL,
    NULL,
    NULL,
    681
  );
INSERT INTO
  `maintenanceTasks` (
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
    18,
    'LIMPIEZA',
    0,
    0,
    0,
    0,
    1,
    '2021-09-29 00:11:30',
    '2021-09-29 00:11:30',
    NULL,
    NULL,
    NULL,
    681
  );
INSERT INTO
  `maintenanceTasks` (
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
    19,
    'FUMIGACIÓN ',
    0,
    0,
    0,
    0,
    1,
    '2021-09-29 00:11:46',
    '2021-09-29 00:11:46',
    NULL,
    NULL,
    NULL,
    681
  );
INSERT INTO
  `maintenanceTasks` (
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
    'limpiar refrigeracion',
    0,
    0,
    0,
    1,
    0,
    '2021-09-29 01:00:30',
    '2021-09-29 01:01:50',
    NULL,
    NULL,
    NULL,
    721
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: routes
# ------------------------------------------------------------

INSERT INTO
  `routes` (`id`, `createdAt`, `updatedAt`, `name`)
VALUES
  (
    7,
    '2021-09-29 00:09:01',
    '2021-09-29 00:09:01',
    'RUTA 2000'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: secrets
# ------------------------------------------------------------

INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$/qaBl8mqubWz/pn98iUp8O8ycfkmt51bgoY9uI6qp2wZLTLK0WEoy',
    '2021-09-27 17:39:34',
    '2021-09-27 17:39:34'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$/QI8mO0ARhg6eHI2FUuU5uVfxUpw.EnCCTuPVGix.CjuDAvCzrk5O',
    '2021-09-27 17:44:52',
    '2021-09-27 17:44:52'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$7TKthgxGs7zd6UpJdsLIP.2TyLh7e1UvvIDv7VfpT6tF3Y1WkXcdi',
    '2021-09-27 21:01:15',
    '2021-09-27 21:01:15'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$9tXciOA3Ws.qaZjB55Jwje9.0XL0Lw0JNYI47lWUN/ax.QDFywdXm',
    '2021-09-27 17:43:12',
    '2021-09-27 17:43:12'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$aoh2e584YXNlIYVCRJxxi.4Vt1MIqVQ/03/JBYaoAM4HG7gKNGTlm',
    '2021-09-28 19:31:41',
    '2021-09-28 19:31:41'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$d.ci0CJtd7OJf5qNacfL7.Fen6FtxMf5pCE9Qy/dIdZhV5LMER5va',
    '2021-09-27 16:43:41',
    '2021-09-27 16:43:41'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$fGCf6OoSpixMxXQDPlb26Oit8wmib76xllzEWi4aHTorE87wwsvvm',
    '2021-09-27 20:49:38',
    '2021-09-27 20:49:38'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$hMlrlL5TPremldDo9Gcdy.lkUa2Tx3nXAu9JH/wVnedgb5wCCHao6',
    '2021-09-28 19:38:40',
    '2021-09-28 19:38:40'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$JUbXBh4tAti8StB5qo8Rgu9uvj6hXyXRxi5TupDpz6fM5XbKf2aJu',
    '2021-09-27 17:56:19',
    '2021-09-27 17:56:19'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$kCKKqYX.Sy9nOI3IHoMo6uiqTz8v5LMDYxZdn6bYq4TV8eV2NrjT.',
    '2021-09-27 17:32:31',
    '2021-09-27 17:32:31'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$moxD8UWszCtVwc6FL8Ye4uMPB3BxWm2baKUVwr/aEWbutBubp6YDu',
    '2021-09-27 17:49:16',
    '2021-09-27 17:49:16'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$SJGv.hgQ4AuawtFTctr7eOTxI3CpXkm9gbnvHTXIV.5h7PaBC0eTi',
    '2021-09-27 16:11:39',
    '2021-09-27 16:11:39'
  );
INSERT INTO
  `secrets` (`password`, `createdAt`, `updatedAt`)
VALUES
  (
    '$2b$10$wOveoi77ciAVL8HIqx.Cnuj0m3V3PLu71whlAoolcrh/ei9Y1Ker6',
    '2021-09-27 17:31:13',
    '2021-09-27 17:31:13'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vendingMachines
# ------------------------------------------------------------

INSERT INTO
  `vendingMachines` (
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
    554,
    100,
    NULL,
    '2021-09-27 21:10:28',
    '2021-09-27 21:10:28',
    'Vendo\r',
    37,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    555,
    102,
    NULL,
    '2021-09-27 21:10:28',
    '2021-09-27 21:10:28',
    'Vendo\r',
    73,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    556,
    106,
    NULL,
    '2021-09-27 21:10:28',
    '2021-09-27 21:10:28',
    'Vendo\r',
    10,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    557,
    107,
    NULL,
    '2021-09-27 21:10:28',
    '2021-09-27 21:10:28',
    'Vendo\r',
    106,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    558,
    108,
    NULL,
    '2021-09-27 21:10:28',
    '2021-09-27 21:11:27',
    'Vendo\r',
    50,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    559,
    110,
    NULL,
    '2021-09-27 21:10:28',
    '2021-09-27 21:10:28',
    'Vendo\r',
    NULL,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    560,
    112,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    77,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    561,
    114,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    NULL,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    562,
    115,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    63,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    563,
    117,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    19,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    564,
    118,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    19,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    565,
    119,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    49,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    566,
    120,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    NULL,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    567,
    121,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    15,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    568,
    126,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    37,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    569,
    127,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    8,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    570,
    130,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    76,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    571,
    134,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    52,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    572,
    137,
    NULL,
    '2021-09-27 21:10:29',
    '2021-09-27 21:10:29',
    'Vendo\r',
    44,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    573,
    140,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    106,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    574,
    145,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    14,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    575,
    150,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    102,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    576,
    155,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    94,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    577,
    156,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    90,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    578,
    160,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    26,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    579,
    161,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    36,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    580,
    162,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    36,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    581,
    163,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    36,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    582,
    164,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    12,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    583,
    165,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    8,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    584,
    168,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    NULL,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    585,
    169,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:30',
    'Vendo\r',
    NULL,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    586,
    171,
    NULL,
    '2021-09-27 21:10:30',
    '2021-09-27 21:10:31',
    'Vendo\r',
    76,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    587,
    173,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'Vendo\r',
    97,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    588,
    174,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'Vendo\r',
    54,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    589,
    175,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'Vendo\r',
    30,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    590,
    176,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'Vendo\r',
    51,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    591,
    177,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'Vendo\r',
    90,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    592,
    178,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'Vendo\r',
    84,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    593,
    179,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'AMS\r',
    95,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    594,
    180,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'AMS\r',
    43,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    595,
    181,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'AMS\r',
    NULL,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    596,
    200,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'AMS\r',
    73,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    597,
    2001,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'AMS\r',
    90,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    598,
    2002,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'AMS\r',
    38,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    599,
    2003,
    NULL,
    '2021-09-27 21:10:31',
    '2021-09-27 21:10:31',
    'AMS\r',
    9,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    600,
    2004,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    601,
    2005,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    602,
    2006,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    43,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    603,
    2007,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    108,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    604,
    2008,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    605,
    201,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    101,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    606,
    202,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    106,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    607,
    204,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    608,
    205,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    41,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    609,
    206,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    610,
    207,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    611,
    208,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    54,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    612,
    209,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    613,
    210,
    NULL,
    '2021-09-27 21:10:32',
    '2021-09-27 21:10:32',
    'AMS\r',
    48,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    614,
    212,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    615,
    213,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    23,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    616,
    214,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    48,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    617,
    217,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    26,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    618,
    218,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    619,
    219,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    107,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    620,
    222,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    52,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    621,
    223,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    622,
    224,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    106,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    623,
    225,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    37,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    624,
    226,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    625,
    227,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    626,
    228,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:33',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    627,
    229,
    NULL,
    '2021-09-27 21:10:33',
    '2021-09-27 21:10:34',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    628,
    230,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    102,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    629,
    231,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    80,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    630,
    232,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    49,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    631,
    233,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    16,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    632,
    235,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    37,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    633,
    238,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    67,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    634,
    239,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    17,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    635,
    240,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    636,
    241,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    637,
    242,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    47,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    638,
    243,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    639,
    245,
    NULL,
    '2021-09-27 21:10:34',
    '2021-09-27 21:10:34',
    'AMS\r',
    30,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    640,
    248,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    19,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    641,
    249,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    19,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    642,
    250,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    36,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    643,
    251,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    36,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    644,
    252,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    12,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    645,
    254,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    48,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    646,
    262,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    21,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    647,
    264,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    17,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    648,
    265,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    649,
    266,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    94,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    650,
    268,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    651,
    269,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:35',
    'AMS\r',
    76,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    652,
    270,
    NULL,
    '2021-09-27 21:10:35',
    '2021-09-27 21:10:36',
    'AMS\r',
    46,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    653,
    271,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    654,
    272,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    8,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    655,
    273,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    14,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    656,
    274,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    657,
    275,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    97,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    658,
    276,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    84,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    659,
    277,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    660,
    278,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    86,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    661,
    279,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    95,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    662,
    280,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    32,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    663,
    281,
    NULL,
    '2021-09-27 21:10:36',
    '2021-09-27 21:10:36',
    'AMS\r',
    32,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    664,
    282,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    32,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    665,
    283,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    28,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    666,
    284,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    88,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    667,
    285,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    30,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    668,
    286,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    73,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    669,
    288,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    20,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    670,
    289,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    671,
    290,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    672,
    291,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    51,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    673,
    292,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    30,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    674,
    293,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    84,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    675,
    294,
    NULL,
    '2021-09-27 21:10:37',
    '2021-09-27 21:10:37',
    'AMS\r',
    NULL,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    676,
    295,
    NULL,
    '2021-09-27 21:10:38',
    '2021-09-27 21:10:38',
    'AMS\r',
    74,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    677,
    296,
    NULL,
    '2021-09-27 21:10:38',
    '2021-09-27 21:10:38',
    'AMS\r',
    90,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    678,
    297,
    NULL,
    '2021-09-27 21:10:38',
    '2021-09-27 21:10:38',
    'AMS\r',
    5,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    679,
    299,
    NULL,
    '2021-09-27 21:10:38',
    '2021-09-27 21:10:38',
    'AMS\r',
    65,
    4
  );
INSERT INTO
  `vendingMachines` (
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
    680,
    301,
    NULL,
    '2021-09-27 21:10:38',
    '2021-09-27 21:10:38',
    'Vendo\r',
    80,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    681,
    319,
    NULL,
    '2021-09-27 21:10:38',
    '2021-09-27 21:10:38',
    'Opera\r',
    46,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    682,
    320,
    '',
    '2021-09-27 21:10:38',
    '2021-09-28 23:51:35',
    'SOLISTA',
    25,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    683,
    321,
    NULL,
    '2021-09-27 21:10:38',
    '2021-09-27 21:10:38',
    'Opera\r',
    58,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    684,
    322,
    NULL,
    '2021-09-27 21:10:38',
    '2021-09-28 23:52:55',
    'SOLISTA',
    69,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    685,
    323,
    NULL,
    '2021-09-27 21:10:38',
    '2021-09-28 23:53:36',
    'Opera\r',
    57,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    686,
    324,
    NULL,
    '2021-09-27 21:10:38',
    '2021-09-28 23:53:53',
    'Opera\r',
    34,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    687,
    326,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-28 23:54:10',
    'Opera\r',
    25,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    688,
    327,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-27 21:10:39',
    'Opera\r',
    97,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    689,
    328,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-27 21:10:39',
    'Opera\r',
    48,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    690,
    329,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-27 21:10:39',
    'Opera\r',
    48,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    691,
    330,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-27 21:10:39',
    'Opera\r',
    65,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    692,
    331,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-27 21:10:39',
    'Opera\r',
    73,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    693,
    332,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-28 23:57:21',
    'Opera\r',
    18,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    694,
    333,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-28 23:58:18',
    'Opera\r',
    113,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    695,
    334,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-28 23:59:22',
    'Opera\r',
    71,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    696,
    335,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-28 23:59:37',
    'Opera\r',
    111,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    697,
    336,
    NULL,
    '2021-09-27 21:10:39',
    '2021-09-27 21:10:39',
    'Opera\r',
    86,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    698,
    337,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-27 21:10:40',
    'Opera\r',
    99,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    699,
    338,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-27 21:10:40',
    'Opera\r',
    26,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    700,
    339,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-27 21:10:40',
    'Opera\r',
    42,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    701,
    340,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-29 00:00:13',
    'Opera\r',
    98,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    702,
    341,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-27 21:10:40',
    'Opera\r',
    29,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    703,
    342,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-27 21:10:40',
    'Opera\r',
    48,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    704,
    343,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-27 21:10:40',
    'Opera\r',
    37,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    705,
    344,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-27 21:10:40',
    'Opera\r',
    102,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    706,
    346,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-27 21:10:40',
    'Opera\r',
    NULL,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    707,
    347,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-27 21:10:40',
    'Opera\r',
    NULL,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    708,
    348,
    NULL,
    '2021-09-27 21:10:40',
    '2021-09-27 21:10:41',
    'Opera\r',
    101,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    709,
    349,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'Opera\r',
    NULL,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    710,
    350,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'Opera\r',
    43,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    711,
    351,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'Opera\r',
    105,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    712,
    352,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'Opera\r',
    105,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    713,
    353,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'Opera\r',
    NULL,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    714,
    354,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'Opera\r',
    74,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    715,
    355,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'Opera\r',
    80,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    716,
    356,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'Opera\r',
    109,
    2
  );
INSERT INTO
  `vendingMachines` (
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
    717,
    400,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    718,
    4001,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'AMS\r',
    78,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    719,
    401,
    NULL,
    '2021-09-27 21:10:41',
    '2021-09-27 21:10:41',
    'AMS\r',
    55,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    720,
    402,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:42',
    'AMS\r',
    24,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    721,
    403,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:42',
    'AMS\r',
    80,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    722,
    404,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:42',
    'AMS\r',
    50,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    723,
    405,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:42',
    'AMS\r',
    52,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    724,
    406,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:42',
    'AMS\r',
    48,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    725,
    407,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:42',
    'AMS\r',
    41,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    726,
    408,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:42',
    'AMS\r',
    49,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    727,
    409,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:42',
    'AMS\r',
    48,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    728,
    410,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:42',
    'AMS\r',
    40,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    729,
    411,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:42',
    'AMS\r',
    67,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    730,
    412,
    NULL,
    '2021-09-27 21:10:42',
    '2021-09-27 21:10:43',
    'AMS\r',
    21,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    731,
    413,
    NULL,
    '2021-09-27 21:10:43',
    '2021-09-27 21:10:43',
    'AMS\r',
    8,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    732,
    414,
    NULL,
    '2021-09-27 21:10:43',
    '2021-09-27 21:10:43',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    733,
    415,
    NULL,
    '2021-09-27 21:10:43',
    '2021-09-27 21:10:43',
    'AMS\r',
    60,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    734,
    416,
    NULL,
    '2021-09-27 21:10:43',
    '2021-09-27 21:10:43',
    'AMS\r',
    54,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    735,
    417,
    NULL,
    '2021-09-27 21:10:43',
    '2021-09-27 21:10:43',
    'AMS\r',
    102,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    736,
    418,
    NULL,
    '2021-09-27 21:10:43',
    '2021-09-27 21:10:43',
    'AMS\r',
    65,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    737,
    419,
    NULL,
    '2021-09-27 21:10:43',
    '2021-09-27 21:10:43',
    'AMS\r',
    26,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    738,
    420,
    NULL,
    '2021-09-27 21:10:43',
    '2021-09-27 21:10:43',
    'AMS\r',
    23,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    739,
    421,
    NULL,
    '2021-09-27 21:10:43',
    '2021-09-27 21:10:43',
    'AMS\r',
    9,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    740,
    422,
    NULL,
    '2021-09-27 21:10:43',
    '2021-09-27 21:10:44',
    'AMS\r',
    33,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    741,
    423,
    NULL,
    '2021-09-27 21:10:44',
    '2021-09-27 21:10:44',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    742,
    425,
    NULL,
    '2021-09-27 21:10:44',
    '2021-09-27 21:10:44',
    'AMS\r',
    61,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    743,
    426,
    NULL,
    '2021-09-27 21:10:44',
    '2021-09-27 21:10:44',
    'AMS\r',
    87,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    744,
    427,
    NULL,
    '2021-09-27 21:10:44',
    '2021-09-27 21:10:44',
    'AMS\r',
    91,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    745,
    428,
    NULL,
    '2021-09-27 21:10:44',
    '2021-09-27 21:10:44',
    'AMS\r',
    19,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    746,
    429,
    NULL,
    '2021-09-27 21:10:44',
    '2021-09-27 21:10:44',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    747,
    430,
    NULL,
    '2021-09-27 21:10:44',
    '2021-09-27 21:10:44',
    'AMS\r',
    81,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    748,
    431,
    NULL,
    '2021-09-27 21:10:44',
    '2021-09-27 21:10:44',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    749,
    432,
    NULL,
    '2021-09-27 21:10:44',
    '2021-09-27 21:10:44',
    'AMS\r',
    70,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    750,
    433,
    NULL,
    '2021-09-27 21:10:44',
    '2021-09-27 21:10:44',
    'AMS\r',
    17,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    751,
    434,
    NULL,
    '2021-09-27 21:10:45',
    '2021-09-27 21:10:45',
    'AMS\r',
    26,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    752,
    435,
    NULL,
    '2021-09-27 21:10:45',
    '2021-09-27 21:10:45',
    'AMS\r',
    77,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    753,
    436,
    NULL,
    '2021-09-27 21:10:45',
    '2021-09-27 21:10:45',
    'AMS\r',
    8,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    754,
    437,
    NULL,
    '2021-09-27 21:10:45',
    '2021-09-27 21:10:45',
    'AMS\r',
    47,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    755,
    438,
    NULL,
    '2021-09-27 21:10:45',
    '2021-09-27 21:10:45',
    'AMS\r',
    47,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    756,
    439,
    NULL,
    '2021-09-27 21:10:45',
    '2021-09-27 21:10:45',
    'AMS\r',
    54,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    757,
    440,
    NULL,
    '2021-09-27 21:10:45',
    '2021-09-27 21:10:45',
    'AMS\r',
    48,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    758,
    441,
    NULL,
    '2021-09-27 21:10:45',
    '2021-09-27 21:10:45',
    'AMS\r',
    62,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    759,
    442,
    NULL,
    '2021-09-27 21:10:45',
    '2021-09-27 21:10:45',
    'AMS\r',
    105,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    760,
    443,
    NULL,
    '2021-09-27 21:10:45',
    '2021-09-27 21:10:46',
    'AMS\r',
    84,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    761,
    444,
    NULL,
    '2021-09-27 21:10:46',
    '2021-09-27 21:10:46',
    'AMS\r',
    105,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    762,
    445,
    NULL,
    '2021-09-27 21:10:46',
    '2021-09-27 21:10:46',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    763,
    446,
    NULL,
    '2021-09-27 21:10:46',
    '2021-09-27 21:10:46',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    764,
    447,
    NULL,
    '2021-09-27 21:10:46',
    '2021-09-27 21:10:46',
    'AMS\r',
    55,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    765,
    448,
    NULL,
    '2021-09-27 21:10:46',
    '2021-09-27 21:10:46',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    766,
    449,
    NULL,
    '2021-09-27 21:10:46',
    '2021-09-27 21:10:46',
    'AMS\r',
    45,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    767,
    450,
    NULL,
    '2021-09-27 21:10:46',
    '2021-09-27 21:10:46',
    'AMS\r',
    86,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    768,
    451,
    NULL,
    '2021-09-27 21:10:46',
    '2021-09-27 21:10:46',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    769,
    452,
    NULL,
    '2021-09-27 21:10:46',
    '2021-09-27 21:10:46',
    'AMS\r',
    91,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    770,
    453,
    NULL,
    '2021-09-27 21:10:46',
    '2021-09-27 21:10:46',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    771,
    454,
    NULL,
    '2021-09-27 21:10:47',
    '2021-09-27 21:10:47',
    'AMS\r',
    37,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    772,
    455,
    NULL,
    '2021-09-27 21:10:47',
    '2021-09-27 21:10:47',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    773,
    456,
    NULL,
    '2021-09-27 21:10:47',
    '2021-09-27 21:10:47',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    774,
    457,
    NULL,
    '2021-09-27 21:10:47',
    '2021-09-27 21:10:47',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    775,
    458,
    NULL,
    '2021-09-27 21:10:47',
    '2021-09-27 21:10:47',
    'AMS\r',
    17,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    776,
    459,
    NULL,
    '2021-09-27 21:10:47',
    '2021-09-27 21:10:47',
    'AMS\r',
    48,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    777,
    460,
    NULL,
    '2021-09-27 21:10:47',
    '2021-09-27 21:10:47',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    778,
    461,
    NULL,
    '2021-09-27 21:10:47',
    '2021-09-27 21:10:47',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    779,
    462,
    NULL,
    '2021-09-27 21:10:47',
    '2021-09-27 21:10:47',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    780,
    463,
    NULL,
    '2021-09-27 21:10:47',
    '2021-09-27 21:10:48',
    'AMS\r',
    10,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    781,
    464,
    NULL,
    '2021-09-27 21:10:48',
    '2021-09-27 21:10:48',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    782,
    465,
    NULL,
    '2021-09-27 21:10:48',
    '2021-09-27 21:10:48',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    783,
    466,
    NULL,
    '2021-09-27 21:10:48',
    '2021-09-27 21:10:48',
    'AMS\r',
    84,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    784,
    467,
    NULL,
    '2021-09-27 21:10:48',
    '2021-09-27 21:10:48',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    785,
    468,
    NULL,
    '2021-09-27 21:10:48',
    '2021-09-27 21:10:48',
    'AMS\r',
    46,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    786,
    469,
    NULL,
    '2021-09-27 21:10:48',
    '2021-09-27 21:10:48',
    'AMS\r',
    94,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    787,
    470,
    NULL,
    '2021-09-27 21:10:48',
    '2021-09-27 21:10:48',
    'AMS\r',
    76,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    788,
    471,
    NULL,
    '2021-09-27 21:10:48',
    '2021-09-27 21:10:48',
    'AMS\r',
    63,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    789,
    472,
    NULL,
    '2021-09-27 21:10:48',
    '2021-09-27 21:10:48',
    'AMS\r',
    13,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    790,
    473,
    NULL,
    '2021-09-27 21:10:49',
    '2021-09-27 21:10:49',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    791,
    474,
    NULL,
    '2021-09-27 21:10:49',
    '2021-09-27 21:10:49',
    'AMS\r',
    83,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    792,
    475,
    NULL,
    '2021-09-27 21:10:49',
    '2021-09-27 21:10:49',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    793,
    476,
    NULL,
    '2021-09-27 21:10:49',
    '2021-09-27 21:10:49',
    'AMS\r',
    73,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    794,
    477,
    NULL,
    '2021-09-27 21:10:49',
    '2021-09-27 21:10:49',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    795,
    478,
    NULL,
    '2021-09-27 21:10:49',
    '2021-09-27 21:10:49',
    'AMS\r',
    22,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    796,
    479,
    NULL,
    '2021-09-27 21:10:49',
    '2021-09-27 21:10:49',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    797,
    480,
    NULL,
    '2021-09-27 21:10:49',
    '2021-09-27 21:10:49',
    'AMS\r',
    6,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    798,
    481,
    NULL,
    '2021-09-27 21:10:49',
    '2021-09-27 21:10:49',
    'AMS\r',
    97,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    799,
    482,
    NULL,
    '2021-09-27 21:10:49',
    '2021-09-27 21:10:49',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    800,
    483,
    NULL,
    '2021-09-27 21:10:50',
    '2021-09-27 21:10:50',
    'AMS\r',
    14,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    801,
    484,
    NULL,
    '2021-09-27 21:10:50',
    '2021-09-27 21:10:50',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    802,
    485,
    NULL,
    '2021-09-27 21:10:50',
    '2021-09-27 21:10:50',
    'AMS\r',
    94,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    803,
    486,
    NULL,
    '2021-09-27 21:10:50',
    '2021-09-27 21:10:50',
    'AMS\r',
    99,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    804,
    487,
    NULL,
    '2021-09-27 21:10:50',
    '2021-09-27 21:10:50',
    'AMS\r',
    79,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    805,
    488,
    NULL,
    '2021-09-27 21:10:50',
    '2021-09-27 21:10:50',
    'AMS\r',
    32,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    806,
    489,
    NULL,
    '2021-09-27 21:10:50',
    '2021-09-27 21:10:50',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    807,
    491,
    NULL,
    '2021-09-27 21:10:50',
    '2021-09-27 21:10:50',
    'AMS\r',
    42,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    808,
    492,
    NULL,
    '2021-09-27 21:10:50',
    '2021-09-27 21:10:50',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    809,
    493,
    NULL,
    '2021-09-27 21:10:50',
    '2021-09-27 21:10:51',
    'AMS\r',
    35,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    810,
    494,
    NULL,
    '2021-09-27 21:10:51',
    '2021-09-27 21:10:51',
    'AMS\r',
    29,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    811,
    495,
    NULL,
    '2021-09-27 21:10:51',
    '2021-09-27 21:10:51',
    'AMS\r',
    22,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    812,
    496,
    NULL,
    '2021-09-27 21:10:51',
    '2021-09-27 21:10:51',
    'AMS\r',
    6,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    813,
    498,
    NULL,
    '2021-09-27 21:10:51',
    '2021-09-27 21:10:51',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    814,
    499,
    NULL,
    '2021-09-27 21:10:51',
    '2021-09-27 21:10:51',
    'AMS\r',
    43,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    815,
    500,
    NULL,
    '2021-09-27 21:10:51',
    '2021-09-27 21:10:51',
    'AMS\r',
    73,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    816,
    501,
    NULL,
    '2021-09-27 21:10:51',
    '2021-09-27 21:10:51',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    817,
    502,
    NULL,
    '2021-09-27 21:10:51',
    '2021-09-27 21:10:51',
    'AMS\r',
    105,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    818,
    503,
    NULL,
    '2021-09-27 21:10:51',
    '2021-09-27 21:10:52',
    'AMS\r',
    107,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    819,
    504,
    NULL,
    '2021-09-27 21:10:52',
    '2021-09-27 21:10:52',
    'AMS\r',
    65,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    820,
    505,
    NULL,
    '2021-09-27 21:10:52',
    '2021-09-27 21:10:52',
    'Vendo\r',
    17,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    821,
    506,
    NULL,
    '2021-09-27 21:10:52',
    '2021-09-27 21:10:52',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    822,
    508,
    NULL,
    '2021-09-27 21:10:52',
    '2021-09-27 21:10:52',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    823,
    511,
    NULL,
    '2021-09-27 21:10:52',
    '2021-09-27 21:10:52',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    824,
    513,
    NULL,
    '2021-09-27 21:10:52',
    '2021-09-27 21:10:52',
    'Vendo \r',
    46,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    825,
    514,
    NULL,
    '2021-09-27 21:10:52',
    '2021-09-27 21:10:52',
    'AMS\r',
    59,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    826,
    523,
    NULL,
    '2021-09-27 21:10:52',
    '2021-09-27 21:10:52',
    'Vendo\r',
    12,
    3
  );
INSERT INTO
  `vendingMachines` (
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
    827,
    524,
    NULL,
    '2021-09-27 21:10:52',
    '2021-09-27 21:10:52',
    'AMS\r',
    94,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    828,
    525,
    NULL,
    '2021-09-27 21:10:53',
    '2021-09-27 21:10:53',
    'AMS\r',
    38,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    829,
    526,
    NULL,
    '2021-09-27 21:10:53',
    '2021-09-27 21:10:53',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    830,
    527,
    NULL,
    '2021-09-27 21:10:53',
    '2021-09-27 21:10:53',
    'AMS\r',
    16,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    831,
    528,
    NULL,
    '2021-09-27 21:10:53',
    '2021-09-27 21:10:53',
    'AMS\r',
    19,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    832,
    529,
    NULL,
    '2021-09-27 21:10:53',
    '2021-09-27 21:10:53',
    'AMS\r',
    23,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    833,
    530,
    NULL,
    '2021-09-27 21:10:53',
    '2021-09-27 21:10:53',
    'AMS\r',
    85,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    834,
    532,
    NULL,
    '2021-09-27 21:10:53',
    '2021-09-27 21:10:53',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    835,
    533,
    NULL,
    '2021-09-27 21:10:53',
    '2021-09-27 21:10:53',
    'AMS\r',
    84,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    836,
    534,
    NULL,
    '2021-09-27 21:10:53',
    '2021-09-27 21:10:53',
    'AMS\r',
    NULL,
    1
  );
INSERT INTO
  `vendingMachines` (
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
    838,
    2222,
    '',
    '2021-09-29 12:16:19',
    '2021-09-29 12:16:19',
    '',
    NULL,
    1
  );

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
