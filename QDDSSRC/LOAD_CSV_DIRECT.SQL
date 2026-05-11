-- ============================================================================
-- Load Customer Totals from IFS CSV using SQL
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
INSERT INTO JAMIEDEV.CUSTOMER_TOTALS (CUST_NBR, TOTAL_AMT)
SELECT 
    CAST(CUSTOMER_NUMBER AS DECIMAL(11, 0)) AS CUST_NBR,
    CAST(TOTAL_AMOUNT AS DECIMAL(15, 2)) AS TOTAL_AMT
FROM TABLE(
    QSYS2.IFS_READ_UTF8(
        PATH_NAME => '/home/NEUCO/customer_totals.csv',
        END_OF_LINE => 'LF'
    )
) AS IFS_DATA
CROSS APPLY TABLE(
    SYSTOOLS.SPLIT(IFS_DATA.LINE, ',')
) AS CSV_SPLIT
WHERE IFS_DATA.LINE_NUMBER > 1  -- Skip header row
  AND IFS_DATA.LINE <> ''        -- Skip empty lines
GROUP BY IFS_DATA.LINE_NUMBER, IFS_DATA.LINE
HAVING COUNT(*) = 2              -- Ensure we have exactly 2 columns
WITH NC;

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
