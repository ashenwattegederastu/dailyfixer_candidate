-- Soft delete archive table for user accounts
-- Stores a snapshot of basic user data at the time of account deletion.
-- No foreign keys — intentionally standalone so records survive even if the users row is cleaned up later.

CREATE TABLE IF NOT EXISTS `deleted_users` (
  `id`           INT          NOT NULL AUTO_INCREMENT,
  `user_id`      INT          NOT NULL,
  `first_name`   VARCHAR(50)  DEFAULT NULL,
  `last_name`    VARCHAR(50)  DEFAULT NULL,
  `username`     VARCHAR(50)  DEFAULT NULL,
  `email`        VARCHAR(100) DEFAULT NULL,
  `phone_number` VARCHAR(20)  DEFAULT NULL,
  `city`         VARCHAR(50)  DEFAULT NULL,
  `role`         VARCHAR(20)  DEFAULT NULL,
  `deleted_at`   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
