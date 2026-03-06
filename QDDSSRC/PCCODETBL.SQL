-- =====================================================================
-- Table: PCCODETBL - Promotional Code Table
-- Purpose: Stores promotional codes with discount rules and conditions
-- Author: System Generated
-- Date: 2026-03-05
-- =====================================================================

CREATE TABLE PCCODETBL (
  -- Primary Key
  PCCODE        CHAR(15)      NOT NULL PRIMARY KEY,
  
  -- Description
  DESCRIPTION   CHAR(50)      NOT NULL DEFAULT '',
  
  -- Status and Type Flags
  STATUS        CHAR(1)       NOT NULL DEFAULT 'A',
  APPLTYPE      CHAR(1)       NOT NULL DEFAULT '',
  CODETYPE      CHAR(10)      NOT NULL DEFAULT '',
  CREATELINE    CHAR(1)       NOT NULL DEFAULT 'N',
  STACKABLE     CHAR(1)       NOT NULL DEFAULT 'N',
  
  -- Effectivity Date Range
  EFFDATE       DATE          DEFAULT NULL,
  EXPDATE       DATE          DEFAULT NULL,
  
  -- Usage Limits
  MAXUSES       DECIMAL(9,0)  DEFAULT NULL,
  USEDCOUNT     DECIMAL(9,0)  NOT NULL DEFAULT 0,
  MAXUSECUST    DECIMAL(3,0)  DEFAULT NULL,
  
  -- Minimum Requirements
  MINORDERAMT   DECIMAL(11,2) DEFAULT NULL,
  MINQTY        DECIMAL(9,2)  DEFAULT NULL,
  
  -- Discount Rules
  DISCPCT       DECIMAL(4,2)  NOT NULL DEFAULT 0.00,
  DISCAMT       DECIMAL(11,2) DEFAULT NULL,
  QTYSELL       DECIMAL(9,2)  NOT NULL DEFAULT 0.00,
  QTYFREE       DECIMAL(9,2)  NOT NULL DEFAULT 0.00,
  
  -- Restrictions
  CUSTLIST      CHAR(10)      DEFAULT NULL,
  ITEMLIST      CHAR(10)      DEFAULT NULL,
  CATEGORYLIST  CHAR(10)      DEFAULT NULL,
  BRANCHLIST    CHAR(10)      DEFAULT NULL,
  EXCLUDEITEMS  CHAR(10)      DEFAULT NULL,
  
  -- Priority and Combination
  PRIORITY      DECIMAL(3,0)  NOT NULL DEFAULT 0,
  COMBINEMAX    DECIMAL(3,0)  DEFAULT NULL,
  
  -- Audit Fields
  CREATEUSER    CHAR(10)      NOT NULL DEFAULT USER,
  CREATEDATE    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UPDATEUSER    CHAR(10)      NOT NULL DEFAULT USER,
  UPDATEDATE    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================================
-- Column Descriptions
-- =====================================================================

LABEL ON COLUMN PCCODETBL.PCCODE IS 'Promotional Code';
LABEL ON COLUMN PCCODETBL.DESCRIPTION IS 'Code Description';
LABEL ON COLUMN PCCODETBL.STATUS IS 'Status (A=Active, I=Inactive, D=Deleted)';
LABEL ON COLUMN PCCODETBL.APPLTYPE IS 'Application Type (I=Item, O=Order)';
LABEL ON COLUMN PCCODETBL.CODETYPE IS 'Code Type (TERMS, PROMO, etc.)';
LABEL ON COLUMN PCCODETBL.CREATELINE IS 'Create Order Line (Y/N)';
LABEL ON COLUMN PCCODETBL.STACKABLE IS 'Stackable with Other Codes (Y/N)';
LABEL ON COLUMN PCCODETBL.EFFDATE IS 'Effective Date';
LABEL ON COLUMN PCCODETBL.EXPDATE IS 'Expiration Date';
LABEL ON COLUMN PCCODETBL.MAXUSES IS 'Maximum Total Uses';
LABEL ON COLUMN PCCODETBL.USEDCOUNT IS 'Current Use Count';
LABEL ON COLUMN PCCODETBL.MAXUSECUST IS 'Max Uses Per Customer';
LABEL ON COLUMN PCCODETBL.MINORDERAMT IS 'Minimum Order Amount';
LABEL ON COLUMN PCCODETBL.MINQTY IS 'Minimum Quantity';
LABEL ON COLUMN PCCODETBL.DISCPCT IS 'Discount Percentage';
LABEL ON COLUMN PCCODETBL.DISCAMT IS 'Discount Fixed Amount';
LABEL ON COLUMN PCCODETBL.QTYSELL IS 'Quantity to Sell';
LABEL ON COLUMN PCCODETBL.QTYFREE IS 'Quantity for Free';
LABEL ON COLUMN PCCODETBL.CUSTLIST IS 'Customer List Name';
LABEL ON COLUMN PCCODETBL.ITEMLIST IS 'Item List Name';
LABEL ON COLUMN PCCODETBL.CATEGORYLIST IS 'Category List Name';
LABEL ON COLUMN PCCODETBL.BRANCHLIST IS 'Branch List Name';
LABEL ON COLUMN PCCODETBL.EXCLUDEITEMS IS 'Exclude Items List';
LABEL ON COLUMN PCCODETBL.PRIORITY IS 'Application Priority';
LABEL ON COLUMN PCCODETBL.COMBINEMAX IS 'Max Codes to Combine';
LABEL ON COLUMN PCCODETBL.CREATEUSER IS 'Created By User';
LABEL ON COLUMN PCCODETBL.CREATEDATE IS 'Created Date/Time';
LABEL ON COLUMN PCCODETBL.UPDATEUSER IS 'Updated By User';
LABEL ON COLUMN PCCODETBL.UPDATEDATE IS 'Updated Date/Time';

LABEL ON TABLE PCCODETBL IS 'Promotional Code Table';

-- =====================================================================
-- Indexes
-- =====================================================================

-- Index for active codes by type and date range
CREATE INDEX PCCODETBL_X1 ON PCCODETBL (
  STATUS,
  CODETYPE,
  EFFDATE,
  EXPDATE
);

-- Index for code type lookup
CREATE INDEX PCCODETBL_X2 ON PCCODETBL (
  CODETYPE,
  PCCODE
);

-- Index for priority ordering
CREATE INDEX PCCODETBL_X3 ON PCCODETBL (
  PRIORITY DESC,
  PCCODE
);

