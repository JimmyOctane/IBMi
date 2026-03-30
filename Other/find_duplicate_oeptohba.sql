-- ============================================================================
-- Find Duplicate Order Numbers in OEPTOHBA Table
-- ============================================================================
-- Table: OEPTOHBA
-- Field: OENO01 (Order Number)
-- 
-- This query identifies order numbers that appear more than once in the table
-- ============================================================================

-- Query 1: List duplicate order numbers with count
SELECT 
    OENO01 AS ORDER_NUMBER,
    COUNT(*) AS DUPLICATE_COUNT
FROM OEPTOHBA
GROUP BY OENO01
HAVING COUNT(*) > 1
ORDER BY DUPLICATE_COUNT DESC, OENO01;

-- Query 2: Show all records for duplicate order numbers
SELECT 
    T.*
FROM OEPTOHBA T
WHERE OENO01 IN (
    SELECT OENO01
    FROM OEPTOHBA
    GROUP BY OENO01
    HAVING COUNT(*) > 1
)
ORDER BY OENO01;

-- Query 3: Detailed duplicate analysis with row numbers
SELECT 
    OENO01 AS ORDER_NUMBER,
    COUNT(*) AS TOTAL_DUPLICATES,
    MIN(RRN(T)) AS FIRST_RRN,
    MAX(RRN(T)) AS LAST_RRN
FROM OEPTOHBA T
GROUP BY OENO01
HAVING COUNT(*) > 1
ORDER BY TOTAL_DUPLICATES DESC;

-- Query 4: Summary statistics
SELECT 
    COUNT(DISTINCT OENO01) AS UNIQUE_ORDERS,
    COUNT(*) AS TOTAL_RECORDS,
    COUNT(*) - COUNT(DISTINCT OENO01) AS DUPLICATE_RECORDS
FROM OEPTOHBA;
