-- ============================================================================
-- Table:       JACK - ZIP Code Data Table
-- Description: Stores ZIP code information from CSV file
-- Created:     2026-01-15
-- ============================================================================

CREATE OR REPLACE TABLE JACK (
  ZIP              CHAR(10)     NOT NULL,
  TYPE             CHAR(20),
  PRIMARY_CITY     CHAR(100),
  ACCEPTABLE_CITIES CHAR(200),
  STATE            CHAR(10),
  LATITUDE         DECIMAL(8,2),
  LONGITUDE        DECIMAL(8,2),
  COUNTRY          CHAR(10),
  PRIMARY KEY (ZIP)
);

LABEL ON TABLE JACK IS 'ZIP Code Data';
LABEL ON COLUMN JACK.ZIP IS 'ZIP Code';
LABEL ON COLUMN JACK.TYPE IS 'Type';
LABEL ON COLUMN JACK.PRIMARY_CITY IS 'Primary City';
LABEL ON COLUMN JACK.ACCEPTABLE_CITIES IS 'Acceptable Cities';
LABEL ON COLUMN JACK.STATE IS 'State';
LABEL ON COLUMN JACK.LATITUDE IS 'Latitude';
LABEL ON COLUMN JACK.LONGITUDE IS 'Longitude';
LABEL ON COLUMN JACK.COUNTRY IS 'Country';
