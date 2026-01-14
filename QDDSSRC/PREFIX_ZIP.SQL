-- ============================================================================
-- Script: PREFIX_ZIP.SQL - Pad ZIP codes with leading zeros
-- Description: Updates ECZIPCODE table to pad ZIP codes with leading zeros
--              to ensure all ZIP codes are 5 characters long
-- Created: 2026-01-14
-- ============================================================================

-- Update ZIP codes to pad with leading zeros to make them 5 characters
UPDATE ECZIPCODE
SET ZIP = RIGHT('00000' || TRIM(ZIP), 5)
WHERE LENGTH(TRIM(ZIP)) < 5;

-- Display count of updated records
SELECT 'Records Updated: ' || CHAR(COUNT(*)) AS MESSAGE
FROM ECZIPCODE
WHERE LENGTH(TRIM(ZIP)) < 5;
