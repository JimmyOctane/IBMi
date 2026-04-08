-- ============================================================================
-- Table: ARPCDRAWH (Payroll Draw Date Header)
-- Purpose: Single header record for active payroll draw dates with effectivity
-- Note: Only one active record should exist at a time
-- ============================================================================

-- Drop table if it exists
-- DROP TABLE ARPCDRAWH;

CREATE TABLE ARPCDRAWH (
  -- Primary Key - Always 1 for single active record
  DRAWID       INTEGER NOT NULL DEFAULT 1,
  
  -- Effectivity Dates
  EFFBEGIN     DATE NOT NULL,
  EFFEND       DATE NOT NULL,
  
  -- Description
  DRAWDESC     VARCHAR(50) NOT NULL DEFAULT '',
  
  -- Audit Fields - User Added
  ADDUSER      CHAR(10) NOT NULL DEFAULT USER,
  ADDDATE      DATE NOT NULL DEFAULT CURRENT_DATE,
  ADDTIME      TIME NOT NULL DEFAULT CURRENT_TIME,
  ADDTSTAMP    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Audit Fields - User Changed
  CHGUSER      CHAR(10) NOT NULL DEFAULT USER,
  CHGDATE      DATE NOT NULL DEFAULT CURRENT_DATE,
  CHGTIME      TIME NOT NULL DEFAULT CURRENT_TIME,
  CHGTSTAMP    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Primary Key Constraint
  CONSTRAINT ARPCDRAWH_PK PRIMARY KEY (DRAWID),
  
  -- Ensure only one record exists
  CONSTRAINT ARPCDRAWH_CK1 CHECK (DRAWID = 1)
);

-- Add labels/text descriptions
LABEL ON TABLE ARPCDRAWH IS 'Payroll Draw Date Header';

LABEL ON COLUMN ARPCDRAWH (
  DRAWID       IS 'Draw ID',
  EFFBEGIN     IS 'Effective Begin Date',
  EFFEND       IS 'Effective End Date',
  DRAWDESC     IS 'Description',
  ADDUSER      IS 'User Added',
  ADDDATE      IS 'Date Added',
  ADDTIME      IS 'Time Added',
  ADDTSTAMP    IS 'Timestamp Added',
  CHGUSER      IS 'User Changed',
  CHGDATE      IS 'Date Changed',
  CHGTIME      IS 'Time Changed',
  CHGTSTAMP    IS 'Timestamp Changed'
);

-- Create index on effectivity dates for performance
CREATE INDEX ARPCDRAWH_X1 ON ARPCDRAWH (EFFBEGIN, EFFEND);

-- ============================================================================
-- Table: ARPCDRAWD (Payroll Draw Date Detail) - Updated
-- Purpose: Detail table for individual payroll dates within a draw group
-- ============================================================================

-- Drop existing table if needed
-- DROP TABLE ARPCDRAWD;

CREATE TABLE ARPCDRAWD (
  -- Foreign Key to Header
  DRAWID       INTEGER NOT NULL,
  
  -- Payroll Dates (existing fields)
  DRAWDATE     DATE NOT NULL,
  PPBEGIN      DATE NOT NULL,
  PPEND        DATE NOT NULL,
  
  -- Audit Fields - User Added
  ADDUSER      CHAR(10) NOT NULL DEFAULT USER,
  ADDDATE      DATE NOT NULL DEFAULT CURRENT_DATE,
  ADDTIME      TIME NOT NULL DEFAULT CURRENT_TIME,
  ADDTSTAMP    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Audit Fields - User Changed
  CHGUSER      CHAR(10) NOT NULL DEFAULT USER,
  CHGDATE      DATE NOT NULL DEFAULT CURRENT_DATE,
  CHGTIME      TIME NOT NULL DEFAULT CURRENT_TIME,
  CHGTSTAMP    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Primary Key Constraint
  CONSTRAINT ARPCDRAWD_PK PRIMARY KEY (DRAWID, DRAWDATE),
  
  -- Foreign Key Constraint
  CONSTRAINT ARPCDRAWD_FK1 FOREIGN KEY (DRAWID) 
    REFERENCES ARPCDRAWH (DRAWID) ON DELETE CASCADE
);

-- Add labels/text descriptions
LABEL ON TABLE ARPCDRAWD IS 'Payroll Draw Date Detail';

LABEL ON COLUMN ARPCDRAWD (
  DRAWID       IS 'Draw ID',
  DRAWDATE     IS 'Payroll Draw Date',
  PPBEGIN      IS 'Payroll Begin Date',
  PPEND        IS 'Payroll End Date',
  ADDUSER      IS 'User Added',
  ADDDATE      IS 'Date Added',
  ADDTIME      IS 'Time Added',
  ADDTSTAMP    IS 'Timestamp Added',
  CHGUSER      IS 'User Changed',
  CHGDATE      IS 'Date Changed',
  CHGTIME      IS 'Time Changed',
  CHGTSTAMP    IS 'Timestamp Changed'
);

-- Create index on draw date for performance
CREATE INDEX ARPCDRAWD_X1 ON ARPCDRAWD (DRAWDATE);

-- ============================================================================
-- Sample Data Insert
-- ============================================================================

-- Insert sample header record
-- INSERT INTO ARPCDRAWH (EFFBEGIN, EFFEND, DRAWDESC)
-- VALUES ('2026-01-01', '2026-12-31', '2026 Payroll Draw Dates');

-- Insert sample detail records (using the generated DRAWID from above)
-- INSERT INTO ARPCDRAWD (DRAWID, DRAWDATE, PPBEGIN, PPEND)
-- VALUES 
--   (1, '2026-01-15', '2026-01-01', '2026-01-15'),
--   (1, '2026-01-31', '2026-01-16', '2026-01-31'),
--   (1, '2026-02-15', '2026-02-01', '2026-02-15');
