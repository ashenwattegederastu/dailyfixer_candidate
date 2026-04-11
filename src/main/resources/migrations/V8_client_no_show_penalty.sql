-- ─────────────────────────────────────────────────────────────────────────────
-- V8: Client No-Show Penalty System
--
-- Adds:
--   1. CLIENT_NO_SHOW value to bookings.status enum
--   2. client_no_show_penalties table
--   3. Upload directory placeholder note
--
-- Flow:
--   Technician marks "Client Not Home" → booking status = CLIENT_NO_SHOW
--   → client_no_show_penalties row created (PENDING)
--   → Client uploads payment proof → status = PROOF_UPLOADED
--   → Technician confirms paid → status = CONFIRMED_PAID  (resolved)
--   → Technician marks not paid OR 48-hr timeout → status = ADMIN_REVIEW
--   → Admin marks paid → status = RESOLVED
--   → Admin suspends client for fraud → status = FRAUD_SUSPENDED
-- ─────────────────────────────────────────────────────────────────────────────

-- 1. Extend bookings.status enum
ALTER TABLE `bookings`
  MODIFY COLUMN `status`
    ENUM(
      'REQUESTED','ACCEPTED','REJECTED','CANCELLED',
      'IN_PROGRESS','TECHNICIAN_COMPLETED','FULLY_COMPLETED',
      'NO_SHOW','RESCHEDULE_PENDING','AUTO_REJECTED',
      'CLIENT_NO_SHOW'
    ) NOT NULL DEFAULT 'REQUESTED';

-- 2. Client no-show penalty table
CREATE TABLE IF NOT EXISTS `client_no_show_penalties` (
  `penalty_id`        INT           NOT NULL AUTO_INCREMENT,
  `booking_id`        INT           NOT NULL,
  `client_id`         INT           NOT NULL,
  `technician_id`     INT           NOT NULL,
  `amount`            DECIMAL(10,2) NOT NULL DEFAULT 2500.00,
  `status`            ENUM(
                        'PENDING',
                        'PROOF_UPLOADED',
                        'CONFIRMED_PAID',
                        'ADMIN_REVIEW',
                        'RESOLVED',
                        'FRAUD_SUSPENDED'
                      ) NOT NULL DEFAULT 'PENDING',
  `proof_path`        VARCHAR(500)  DEFAULT NULL,
  `proof_uploaded_at` TIMESTAMP     NULL DEFAULT NULL,
  `tech_action`       ENUM('CONFIRMED_PAID','MARKED_NOT_PAID') DEFAULT NULL,
  `tech_action_at`    TIMESTAMP     NULL DEFAULT NULL,
  `admin_action`      ENUM('MARK_PAID','SUSPEND_CLIENT')       DEFAULT NULL,
  `admin_action_at`   TIMESTAMP     NULL DEFAULT NULL,
  `admin_id`          INT           DEFAULT NULL,
  `created_at`        TIMESTAMP     NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`penalty_id`),
  UNIQUE KEY `uq_cnsp_booking` (`booking_id`),
  KEY `idx_cnsp_client`     (`client_id`),
  KEY `idx_cnsp_technician` (`technician_id`),
  KEY `idx_cnsp_status`     (`status`),
  CONSTRAINT `fk_cnsp_booking`    FOREIGN KEY (`booking_id`)    REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cnsp_client`     FOREIGN KEY (`client_id`)     REFERENCES `users`    (`user_id`)    ON DELETE CASCADE,
  CONSTRAINT `fk_cnsp_technician` FOREIGN KEY (`technician_id`) REFERENCES `users`    (`user_id`)    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
