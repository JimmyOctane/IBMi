-- ============================================================================
-- Find Duplicate Order Numbers in OEPTOTX Table
-- ============================================================================
-- Table: OEPTOTX
-- Field: OENO86 (Transaction Number) - Packed(7:4)
-- 
-- This query identifies order numbers that appear more than once in the table
-- ============================================================================

-- Query 1: List duplicate order numbers with count
SELECT 
    OENO86 AS ORDER_NUMBER,
    COUNT(*) AS DUPLICATE_COUNT
FROM OEPTOTX
GROUP BY OENO86
HAVING COUNT(*) > 1
ORDER BY DUPLICATE_COUNT DESC, OENO86;

-- Query 2: Show all records for duplicate order numbers
SELECT 
    T.*
FROM OEPTOTX T
WHERE OENO86 IN (
    SELECT OENO86
    FROM OEPTOTX
    GROUP BY OENO86
    HAVING COUNT(*) > 1
)
ORDER BY OENO86;

-- Query 3: Detailed duplicate analysis with row numbers
SELECT 
    OENO86 AS ORDER_NUMBER,
    COUNT(*) AS TOTAL_DUPLICATES,
    MIN(RRN(T)) AS FIRST_RRN,
    MAX(RRN(T)) AS LAST_RRN
FROM OEPTOTX T
GROUP BY OENO86
HAVING COUNT(*) > 1
ORDER BY TOTAL_DUPLICATES DESC;

-- Query 4: Find exact duplicate records (if other fields are also duplicated)
SELECT 
    OENO86,
    COUNT(*) AS DUPLICATE_COUNT
FROM OEPTOTX
GROUP BY OENO86
HAVING COUNT(*) > 1;
