-- =====================================================================
-- Table: PCBRNLST - Promotional Code Branch List
-- Purpose: Defines which branches are included/excluded for promo codes
-- Author: System Generated
-- Date: 2026-03-05
-- =====================================================================

CREATE TABLE PCBRNLST (
  -- Primary Key
  LISTNAME      CHAR(10)      NOT NULL,
  BRANCH        DECIMAL(3,0)  NOT NULL,
  
  -- Include/Exclude Flag
  INCLEXCL      CHAR(1)       NOT NULL DEFAULT 'I',
  
  -- Audit Fields
  CREATEUSER    CHAR(10)      NOT NULL DEFAULT USER,
  CREATEDATE    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Primary Key Constraint
  PRIMARY KEY (LISTNAME, BRANCH)
);

-- =====================================================================
-- Column Descriptions
-- =====================================================================

LABEL ON COLUMN PCBRNLST.LISTNAME IS 'List Name';
LABEL ON COLUMN PCBRNLST.BRANCH IS 'Branch Code';
LABEL ON COLUMN PCBRNLST.INCLEXCL IS 'Include/Exclude (I=Include, E=Exclude)';
LABEL ON COLUMN PCBRNLST.CREATEUSER IS 'Created By User';
LABEL ON COLUMN PCBRNLST.CREATEDATE IS 'Created Date/Time';

LABEL ON TABLE PCBRNLST IS 'Promotional Code Branch List';

-- =====================================================================
-- Indexes
-- =====================================================================

CREATE INDEX PCBRNLST_X1 ON PCBRNLST (
  BRANCH,
  LISTNAME
);

