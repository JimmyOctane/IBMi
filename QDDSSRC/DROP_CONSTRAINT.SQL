-- ============================================================================
-- Script: DROP_CONSTRAINT.SQL - Drop and recreate primary key constraint
-- Description: Drops the existing primary key constraint on ECZIPCODE
--              and optionally recreates it with a different definition
-- Created: 2026-01-14
-- ============================================================================

-- Drop the existing primary key constraint
ALTER TABLE ECZIPCODE
DROP CONSTRAINT ECZIPCODE_PK;

-- Optionally recreate with new definition (ZIP and PRIMARY_CITY)
-- ALTER TABLE ECZIPCODE
-- ADD CONSTRAINT ECZIPCODE_PK PRIMARY KEY (ZIP, PRIMARY_CITY);

-- Or recreate with just ZIP
-- ALTER TABLE ECZIPCODE
-- ADD CONSTRAINT ECZIPCODE_PK PRIMARY KEY (ZIP);
