CREATE TABLE IF NOT EXISTS `vn_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `money` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `metadata` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `position` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `time_create` int DEFAULT '0',
  `time_logout` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;