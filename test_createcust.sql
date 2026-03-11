-- ============================================================================
-- Simple Test Script for CREATECUST
-- ============================================================================
-- This script helps you test the CREATECUST program manually
--
-- Step 1: Find an unprocessed customer record
-- ============================================================================

-- Find unprocessed customers (CUSTSTATUS = blank)
SELECT GUID, CUSTNAME, CUSTEMAIL, CUSTCITY, CUSTSTATE, CUSTSTATUS
FROM BECCUSTP
WHERE CUSTSTATUS = ' '
ORDER BY CUSTCRTDT DESC
FETCH FIRST 10 ROWS ONLY;

-- ============================================================================
-- Step 2: Call CREATECUST with a specific GUID
-- ============================================================================
-- Replace 'YOUR-GUID-HERE' with an actual GUID from the query above

-- Example call (uncomment and replace GUID):
-- CALL JAMIEDEV.CREATECUST('12345678-1234-1234-1234-123456789012');

-- ============================================================================
-- Step 3: Verify the results
-- ============================================================================

-- Check the status after processing (replace GUID)
-- SELECT GUID, CUSTNAME, CUSTSTATUS, CUSTSTATUSMSG
-- FROM BECCUSTP
-- WHERE GUID = '12345678-1234-1234-1234-123456789012';

-- Status codes:
--   ' ' (blank) = Successfully processed
--   'X' = Excluded (duplicate found)
--   'E' = Error (validation or insert failed)

-- ============================================================================
-- Step 4: Check if customer was created in AR tables
-- ============================================================================

-- Find the customer number that was created (replace customer name)
-- SELECT ARNO01, ARNM01, ARNM05, ARAD01, ARAD02, ARCY01, ARST01, ARZP01
-- FROM ARPMCUS
-- WHERE ARNM01 LIKE '%CUSTOMER NAME%'
-- ORDER BY ARNO01 DESC
-- FETCH FIRST 5 ROWS ONLY;

-- ============================================================================
-- Alternative: Test with the TESTCREATECUST program
-- ============================================================================
-- On IBM i command line, run:
--   CALL JAMIEDEV/TESTCREATECUST
--
-- This will automatically:
--   1. Find an unprocessed record
--   2. Call CREATECUST
--   3. Display the results
