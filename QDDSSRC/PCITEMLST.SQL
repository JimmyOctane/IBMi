-- =====================================================================
-- Table: PCITEMLST - Promotional Code Item List
-- Purpose: Defines which items are included/excluded for promo codes
-- Author: System Generated
-- Date: 2026-03-05
-- =====================================================================

CREATE TABLE PCITEMLST (
  -- Primary Key
  LISTNAME      CHAR(10)      NOT NULL,
  ITEMNO        DECIMAL(6,0)  DEFAULT NULL,
  PRODUCTNO     CHAR(15)      DEFAULT NULL,
  
  -- Include/Exclude Flag
  INCLEXCL      CHAR(1)       NOT NULL DEFAULT 'I',
  
  -- Audit Fields
  CREATEUSER    CHAR(10)      NOT NULL DEFAULT USER,
  CREATEDATE    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Primary Key Constraint
  PRIMARY KEY (LISTNAME, ITEMNO, PRODUCTNO)
);

-- =====================================================================
-- Column Descriptions
-- =====================================================================

LABEL ON COLUMN PCITEMLST.LISTNAME IS 'List Name';
LABEL ON COLUMN PCITEMLST.ITEMNO IS 'Item Number (IVNO07)';
LABEL ON COLUMN PCITEMLST.PRODUCTNO IS 'Product Number (IVNO04)';
LABEL ON COLUMN PCITEMLST.INCLEXCL IS 'Include/Exclude (I=Include, E=Exclude)';
LABEL ON COLUMN PCITEMLST.CREATEUSER IS 'Created By User';
LABEL ON COLUMN PCITEMLST.CREATEDATE IS 'Created Date/Time';

LABEL ON TABLE PCITEMLST IS 'Promotional Code Item List';

-- =====================================================================
-- Indexes
-- =====================================================================

CREATE INDEX PCITEMLST_X1 ON PCITEMLST (
  ITEMNO,
  LISTNAME
);

CREATE INDEX PCITEMLST_X2 ON PCITEMLST (
  PRODUCTNO,
  LISTNAME
);

