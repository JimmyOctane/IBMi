-- ============================================================================
-- Script: ALTER_ECZIPCODE.SQL - Remove ACCEPTABLE_CITIES column
-- Description: Alters ECZIPCODE table to drop the ACCEPTABLE_CITIES column
-- Created: 2026-01-14
-- ============================================================================

-- Remove the ACCEPTABLE_CITIES column from ECZIPCODE table
ALTER TABLE ECZIPCODE
DROP COLUMN ACCEPTABLE_CITIES;
