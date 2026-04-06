-- ============================================================
-- noshowpenalty_migration.sql
-- Adds: technician_penalty_log table for the 3-strike
--       progressive no-show penalty system.
-- Run once against dailyfixer_main after
-- booking_features_migration.sql has been applied.
-- ============================================================

CREATE TABLE IF NOT EXISTS `technician_penalty_log` (
  `penalty_id`    INT          NOT NULL AUTO_INCREMENT,
  `technician_id` INT          NOT NULL,
  `no_show_id`    INT          NOT NULL            COMMENT 'FK to booking_no_shows',
  `penalty_level` TINYINT      NOT NULL            COMMENT '1=warning, 2=listing suppressed, 3=suspended',
  `issued_at`     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at`    TIMESTAMP    NULL     DEFAULT NULL COMMENT 'NULL means indefinite (level 3)',
  `lifted_by`     INT          NULL     DEFAULT NULL COMMENT 'admin user_id who lifted this penalty',
  `lifted_at`     TIMESTAMP    NULL     DEFAULT NULL,
  `notes`         TEXT,
  PRIMARY KEY (`penalty_id`),
  KEY `idx_tpl_tech` (`technician_id`),
  KEY `idx_tpl_noshow` (`no_show_id`),
  CONSTRAINT `fk_tpl_ns`   FOREIGN KEY (`no_show_id`)    REFERENCES `booking_no_shows` (`no_show_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tpl_tech` FOREIGN KEY (`technician_id`) REFERENCES `users` (`user_id`)               ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
