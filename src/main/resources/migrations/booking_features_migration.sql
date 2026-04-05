-- ============================================================
-- booking_features_migration.sql
-- Adds: reschedule requests, no-show tracking, daily limits,
--       booking notifications, and extended booking statuses.
-- Run this once against the dailyfixer_main database.
-- ============================================================

-- 1. Extend the bookings status enum
ALTER TABLE bookings
  MODIFY COLUMN status ENUM(
    'REQUESTED',
    'ACCEPTED',
    'REJECTED',
    'CANCELLED',
    'IN_PROGRESS',
    'TECHNICIAN_COMPLETED',
    'FULLY_COMPLETED',
    'NO_SHOW',
    'RESCHEDULE_PENDING',
    'AUTO_REJECTED'
  ) NOT NULL DEFAULT 'REQUESTED';

-- 2. Reschedule requests table
CREATE TABLE IF NOT EXISTS booking_reschedule_requests (
  reschedule_id  INT          NOT NULL AUTO_INCREMENT,
  booking_id     INT          NOT NULL,
  requested_by   INT          NOT NULL,
  new_date       DATE         NOT NULL,
  new_time       TIME         NOT NULL,
  reason         TEXT,
  status         ENUM('PENDING','ACCEPTED','REJECTED') NOT NULL DEFAULT 'PENDING',
  responded_at   TIMESTAMP    NULL,
  created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (reschedule_id),
  KEY idx_rr_booking (booking_id),
  KEY idx_rr_status  (status),
  CONSTRAINT fk_rr_booking  FOREIGN KEY (booking_id)   REFERENCES bookings(booking_id) ON DELETE CASCADE,
  CONSTRAINT fk_rr_requester FOREIGN KEY (requested_by) REFERENCES users(user_id)      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 3. No-show incident log
CREATE TABLE IF NOT EXISTS booking_no_shows (
  no_show_id    INT      NOT NULL AUTO_INCREMENT,
  booking_id    INT      NOT NULL,
  technician_id INT      NOT NULL,
  scheduled_at  DATETIME NOT NULL,
  detected_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  notes         TEXT,
  PRIMARY KEY (no_show_id),
  UNIQUE KEY uq_ns_booking (booking_id),
  KEY idx_ns_tech (technician_id),
  CONSTRAINT fk_ns_booking FOREIGN KEY (booking_id)    REFERENCES bookings(booking_id) ON DELETE CASCADE,
  CONSTRAINT fk_ns_tech    FOREIGN KEY (technician_id) REFERENCES users(user_id)       ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 4. Per-technician daily booking limit
CREATE TABLE IF NOT EXISTS technician_daily_limits (
  limit_id             INT NOT NULL AUTO_INCREMENT,
  technician_id        INT NOT NULL,
  max_bookings_per_day INT NOT NULL DEFAULT 5,
  created_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (limit_id),
  UNIQUE KEY uq_tdl_tech (technician_id),
  CONSTRAINT fk_tdl_tech FOREIGN KEY (technician_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 5. In-app booking notifications
CREATE TABLE IF NOT EXISTS booking_notifications (
  notification_id INT          NOT NULL AUTO_INCREMENT,
  user_id         INT          NOT NULL,
  booking_id      INT          NOT NULL,
  message         VARCHAR(500) NOT NULL,
  is_read         TINYINT(1)   NOT NULL DEFAULT 0,
  created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (notification_id),
  KEY idx_bn_user    (user_id),
  KEY idx_bn_booking (booking_id),
  KEY idx_bn_read    (is_read),
  CONSTRAINT fk_bn_user    FOREIGN KEY (user_id)    REFERENCES users(user_id)    ON DELETE CASCADE,
  CONSTRAINT fk_bn_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
