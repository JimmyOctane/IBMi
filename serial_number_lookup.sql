-- SQL to check existence of serial number in IVPTSRL table
-- Field: IVNOA0 (CHAR 30)  
-- Logic: Check 8-digit serial first, if found use it, else check 7-digit

-- The issue is likely that IVNOA0 contains trailing spaces or different data
-- Let's debug and fix this step by step

-- First, let's see what's actually in the table for this serial number
SELECT 
    'K059767%' as search_serial,
    IVNOA0,
    LENGTH(IVNOA0) as field_length,
    LENGTH(TRIM(IVNOA0)) as trimmed_length,
    CASE WHEN TRIM(IVNOA0) = 'K059767%' THEN 'EXACT_MATCH_8' ELSE 'NO_MATCH_8' END as match_8,
    CASE WHEN TRIM(IVNOA0) = 'K059767' THEN 'EXACT_MATCH_7' ELSE 'NO_MATCH_7' END as match_7,
    CASE WHEN IVNOA0 LIKE 'K059767%' THEN 'LIKE_MATCH' ELSE 'NO_LIKE_MATCH' END as like_match
FROM IVPTSRL 
WHERE IVNOA0 LIKE 'K059767%'
ORDER BY IVNOA0;
