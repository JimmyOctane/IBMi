-- =====================================================================
-- Table: PCCUSTLST - Promotional Code Customer List
-- Purpose: Defines which customers are included/excluded for promo codes
-- Author: System Generated
-- Date: 2026-03-05
-- =====================================================================

CREATE TABLE PCCUSTLST (
  -- Primary Key
  LISTNAME      CHAR(10)      NOT NULL,
  CUSTNO        DECIMAL(7,0)  NOT NULL,
  
  -- Include/Exclude Flag
  INCLEXCL      CHAR(1)       NOT NULL DEFAULT 'I',
  
  -- Audit Fields
  CREATEUSER    CHAR(10)      NOT NULL DEFAULT USER,
  CREATEDATE    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Primary Key Constraint
  PRIMARY KEY (LISTNAME, CUSTNO)
);

-- =====================================================================
-- Column Descriptions
-- =====================================================================

LABEL ON COLUMN PCCUSTLST.LISTNAME IS 'List Name';
LABEL ON COLUMN PCCUSTLST.CUSTNO IS 'Customer Number';
LABEL ON COLUMN PCCUSTLST.INCLEXCL IS 'Include/Exclude (I=Include, E=Exclude)';
LABEL ON COLUMN PCCUSTLST.CREATEUSER IS 'Created By User';
LABEL ON COLUMN PCCUSTLST.CREATEDATE IS 'Created Date/Time';

LABEL ON TABLE PCCUSTLST IS 'Promotional Code Customer List';

-- =====================================================================
-- Indexes
-- =====================================================================

CREATE INDEX PCCUSTLST_X1 ON PCCUSTLST (
  CUSTNO,
  LISTNAME
);

