-- ============================================================================
-- SQL DDL to Create Table for Excel Import
-- ============================================================================
-- This script creates a table to hold the 2 fields imported from Excel
-- 
-- CUSTOMIZE:
-- - Library name (YOURLIB)
-- - Table name (YOURTABLE)
-- - Field names (FIELD1, FIELD2)
-- - Data types and lengths
-- ============================================================================

-- Drop table if it exists (optional - comment out if you want to keep existing data)
-- DROP TABLE YOURLIB.YOURTABLE;

-- Create the table
CREATE TABLE YOURLIB.YOURTABLE (
    -- Primary key (optional - add if needed)
    ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (
        START WITH 1 
        INCREMENT BY 1 
        NO CACHE
    ),
    
    -- Field 1 - Customize the name and data type
    FIELD1 VARCHAR(100) NOT NULL,
    
    -- Field 2 - Customize the name and data type
    FIELD2 VARCHAR(100) NOT NULL,
    
    -- Audit fields (optional but recommended)
    CREATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CREATED_USER VARCHAR(10) DEFAULT USER,
    
    -- Primary key constraint (optional)
    CONSTRAINT YOURTABLE_PK PRIMARY KEY (ID)
);

-- Add labels for documentation (optional)
LABEL ON TABLE YOURLIB.YOURTABLE IS 'Excel Import Data';
LABEL ON COLUMN YOURLIB.YOURTABLE (
    ID IS 'Record ID',
    FIELD1 IS 'First Field Description',
    FIELD2 IS 'Second Field Description',
    CREATED_DATE IS 'Date Record Created',
    CREATED_USER IS 'User Who Created Record'
);

-- Grant permissions (adjust as needed)
GRANT ALL ON YOURLIB.YOURTABLE TO PUBLIC;

-- ============================================================================
-- COMMON DATA TYPE EXAMPLES
-- ============================================================================
-- Use these as reference when customizing your fields:
--
-- Text/String:
--   VARCHAR(length)      - Variable length string (most common)
--   CHAR(length)         - Fixed length string
--   CLOB                 - Large text (up to 2GB)
--
-- Numbers:
--   INTEGER              - Whole numbers (-2,147,483,648 to 2,147,483,647)
--   BIGINT               - Large whole numbers
--   DECIMAL(p,s)         - Decimal numbers (p=precision, s=scale)
--   NUMERIC(p,s)         - Same as DECIMAL
--   DOUBLE               - Floating point
--
-- Date/Time:
--   DATE                 - Date only (YYYY-MM-DD)
--   TIME                 - Time only (HH:MM:SS)
--   TIMESTAMP            - Date and time
--
-- Other:
--   BLOB                 - Binary data
--   BOOLEAN              - True/False (or use CHAR(1) with 'Y'/'N')
--
-- ============================================================================
-- EXAMPLE VARIATIONS
-- ============================================================================

-- Example 1: Customer Number and Name
/*
CREATE TABLE YOURLIB.CUSTOMER_IMPORT (
    CUST_NBR INTEGER NOT NULL,
    CUST_NAME VARCHAR(100) NOT NULL,
    CREATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/

-- Example 2: Order Number and Date
/*
CREATE TABLE YOURLIB.ORDER_IMPORT (
    ORDER_NBR VARCHAR(20) NOT NULL,
    ORDER_DATE DATE NOT NULL,
    CREATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/

-- Example 3: Item Code and Price
/*
CREATE TABLE YOURLIB.ITEM_IMPORT (
    ITEM_CODE VARCHAR(30) NOT NULL,
    ITEM_PRICE DECIMAL(15,2) NOT NULL,
    CREATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/

-- Example 4: Simple two-field table (no extras)
/*
CREATE TABLE YOURLIB.SIMPLE_IMPORT (
    FIELD1 VARCHAR(100),
    FIELD2 VARCHAR(100)
);
*/
