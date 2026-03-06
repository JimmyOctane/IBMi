-- =====================================================================
-- Table: PCCATLST - Promotional Code Category List
-- Purpose: Defines which categories are included/excluded for promo codes
--          Categories are defined by Category, Section, and Group (all 3 chars)
-- Author: System Generated
-- Date: 2026-03-05
-- =====================================================================

CREATE TABLE PCCATLST (
  -- Primary Key
  LISTNAME      CHAR(10)      NOT NULL,
  CATEGORY      CHAR(3)       NOT NULL,
  SECTION       CHAR(3)       NOT NULL,
  GROUPCODE     CHAR(3)       NOT NULL,
  
  -- Include/Exclude Flag
  INCLEXCL      CHAR(1)       NOT NULL DEFAULT 'I',
  
  -- Audit Fields
  CREATEUSER    CHAR(10)      NOT NULL DEFAULT USER,
  CREATEDATE    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Primary Key Constraint
  PRIMARY KEY (LISTNAME, CATEGORY, SECTION, GROUPCODE)
);

-- =====================================================================
-- Column Descriptions
-- =====================================================================

LABEL ON COLUMN PCCATLST.LISTNAME IS 'List Name';
LABEL ON COLUMN PCCATLST.CATEGORY IS 'Category Code';
LABEL ON COLUMN PCCATLST.SECTION IS 'Section Code';
LABEL ON COLUMN PCCATLST.GROUPCODE IS 'Group Code';
LABEL ON COLUMN PCCATLST.INCLEXCL IS 'Include/Exclude (I=Include, E=Exclude)';
LABEL ON COLUMN PCCATLST.CREATEUSER IS 'Created By User';
LABEL ON COLUMN PCCATLST.CREATEDATE IS 'Created Date/Time';

LABEL ON TABLE PCCATLST IS 'Promotional Code Category List';

-- =====================================================================
-- Indexes
-- =====================================================================

CREATE INDEX PCCATLST_X1 ON PCCATLST (
  CATEGORY,
  SECTION,
  GROUPCODE,
  LISTNAME
);

CREATE INDEX PCCATLST_X2 ON PCCATLST (
  LISTNAME,
  INCLEXCL
);

