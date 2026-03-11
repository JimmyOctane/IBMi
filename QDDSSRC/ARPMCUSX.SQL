-- ============================================================================
-- Table: ARPMCUSX
-- Description: Customer Master Extended Table
-- ============================================================================
-- Modification History:
-- Date       User  Description
-- 2026-03-09 JF    Initial creation
-- ============================================================================

CREATE OR REPLACE TABLE ARPMCUSX (
    CUSTID     CHAR(10)     NOT NULL,
    CUSTNAME   CHAR(50)     NOT NULL,
    EMAIL      CHAR(100),
    CREATEDATE DATE          NOT NULL DEFAULT CURRENT_DATE,
    
    -- Primary Key
    CONSTRAINT ARPMCUSX_PK PRIMARY KEY (CUSTID)
);

-- Add table text description
LABEL ON TABLE ARPMCUSX IS 'Customer Master Extended';

-- Add column text descriptions
LABEL ON COLUMN ARPMCUSX (
    CUSTID     IS 'Customer ID',
    CUSTNAME   IS 'Customer Name',
    EMAIL      IS 'Email Address',
    CREATEDATE IS 'Record Creation Date'
);

-- Create index on customer name for faster searches
CREATE INDEX ARPMCUSX_NAME ON ARPMCUSX (CUSTNAME);

-- Create index on email for faster searches
CREATE INDEX ARPMCUSX_EMAIL ON ARPMCUSX (EMAIL);
