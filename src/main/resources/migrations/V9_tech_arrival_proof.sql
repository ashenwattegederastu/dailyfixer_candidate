-- ─────────────────────────────────────────────────────────────────────────────
-- V9: Technician Arrival Proof for Client No-Show Penalties
--
-- Adds tech_proof_path column so the technician must upload an arrival photo
-- (e.g. photo of the door / location) when marking a client as not home.
-- This proof is visible to the client on their Active Bookings page.
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE `client_no_show_penalties`
  ADD COLUMN `tech_proof_path` VARCHAR(500) DEFAULT NULL
    COMMENT 'Technician arrival proof photo (required when marking client not home)'
    AFTER `status`;
