ALTER TABLE `guide_comments`
    ADD COLUMN `reply` TEXT NULL AFTER `comment`,
    ADD COLUMN `reply_at` TIMESTAMP NULL AFTER `reply`;
