-- ============================================================================
-- Simpler approach: Load Customer Totals from IFS CSV using SQL
-- File Location: /home/NEUCO/*.csv
-- Format: Customer Number,total$
-- ============================================================================

-- Step 1: Create the target table if it doesn't exist
CREATE TABLE JAMIEDEV.CUSTOMER_TOTALS (
    CUST_NBR DECIMAL(11, 0) NOT NULL,
    TOTAL_AMT DECIMAL(15, 2) NOT NULL,
    LOAD_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (CUST_NBR)
);

-- Step 2: Clear existing data (optional - remove if you want to append)
DELETE FROM JAMIEDEV.CUSTOMER_TOTALS;

-- Step 3: Load data directly from CSV file on IFS
-- This reads the CSV and parses each line
INSERT INTO JAMIEDEV.CUSTOMER_TOTALS (CUST_NBR, TOTAL_AMT)
SELECT 
    CAST(TRIM(SUBSTR(LINE, 1, LOCATE(',', LINE) - 1)) AS DECIMAL(11, 0)) AS CUST_NBR,
    CAST(TRIM(SUBSTR(LINE, LOCATE(',', LINE) + 1)) AS DECIMAL(15, 2)) AS TOTAL_AMT
FROM TABLE(
    QSYS2.IFS_READ_UTF8(
        PATH_NAME => '/home/NEUCO/customer_totals.csv'
    )
) AS IFS_DATA
WHERE LINE_NUMBER > 1           -- Skip header row
  AND TRIM(LINE) <> ''          -- Skip empty lines
  AND LOCATE(',', LINE) > 0;    -- Ensure comma exists

-- Step 4: Verify the load
SELECT 
    COUNT(*) AS RECORDS_LOADED,
    MIN(CUST_NBR) AS MIN_CUSTOMER,
    MAX(CUST_NBR) AS MAX_CUSTOMER,
    SUM(TOTAL_AMT) AS TOTAL_AMOUNT
FROM JAMIEDEV.CUSTOMER_TOTALS;

-- Step 5: View the data
SELECT * FROM JAMIEDEV.CUSTOMER_TOTALS
ORDER BY CUST_NBR;
