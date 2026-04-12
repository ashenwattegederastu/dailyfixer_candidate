-- ============================================================
-- Technician Verification Migration
-- Adds pending-review flow for technician registration
-- (mirrors driver_requests pattern)
-- ============================================================

-- 1. technician_requests: one row per applicant
CREATE TABLE IF NOT EXISTS `technician_requests` (
  `request_id`           INT          NOT NULL AUTO_INCREMENT,
  `first_name`           VARCHAR(50)  NOT NULL,
  `last_name`            VARCHAR(50)  NOT NULL,
  `username`             VARCHAR(50)  NOT NULL,
  `email`                VARCHAR(100) NOT NULL,
  `phone`                VARCHAR(20)  DEFAULT NULL,
  `password_hash`        VARCHAR(255) NOT NULL,
  `city`                 VARCHAR(50)  DEFAULT NULL,
  `profile_picture_path` VARCHAR(255) NOT NULL,

  -- At least one of these must be true
  `has_qualifications`   TINYINT(1)   NOT NULL DEFAULT 0,
  `has_experience`       TINYINT(1)   NOT NULL DEFAULT 0,

  -- Workplace experience fields (optional block)
  `experience_company`   VARCHAR(150) DEFAULT NULL,
  `experience_role`      VARCHAR(100) DEFAULT NULL,
  `experience_years`     INT          DEFAULT NULL,
  `emp_id_card_path`     VARCHAR(255) DEFAULT NULL,
  `emp_id_card_name`     VARCHAR(100) DEFAULT NULL,

  `status`               ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
  `rejection_reason`     TEXT         DEFAULT NULL,
  `submitted_date`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_date`        TIMESTAMP    NULL DEFAULT NULL,
  `reviewed_by`          INT          DEFAULT NULL,

  PRIMARY KEY (`request_id`),
  UNIQUE KEY `uq_tr_username` (`username`),
  UNIQUE KEY `uq_tr_email`    (`email`),
  KEY `idx_tr_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2. technician_request_files: variable-count uploads per request
--    file_type: QUALIFICATION (pdf or image, up to 3)
--               WORK_PROOF   (image only, up to 5, optional)
CREATE TABLE IF NOT EXISTS `technician_request_files` (
  `file_id`           INT          NOT NULL AUTO_INCREMENT,
  `request_id`        INT          NOT NULL,
  `file_type`         ENUM('QUALIFICATION','WORK_PROOF') NOT NULL,
  `file_path`         VARCHAR(255) NOT NULL,
  `original_filename` VARCHAR(255) DEFAULT NULL,
  `uploaded_at`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`file_id`),
  KEY `idx_trf_request` (`request_id`),
  CONSTRAINT `fk_trf_request` FOREIGN KEY (`request_id`)
    REFERENCES `technician_requests` (`request_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
