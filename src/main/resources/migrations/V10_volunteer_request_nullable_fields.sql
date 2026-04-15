-- V10: Make experience_years nullable in volunteer_requests
-- Reason: experience_years field removed from registration form (redundant with skill_level)

ALTER TABLE `volunteer_requests`
  MODIFY COLUMN `experience_years` enum('0-1','1-3','3-5','5+') DEFAULT NULL;
