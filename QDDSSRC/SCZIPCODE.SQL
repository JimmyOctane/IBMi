-- ============================================================================
-- Table: SCZIPCODE - US ZIP Code Reference Data
-- Description: Stores ZIP code information including city, state, and coordinates
-- Created: 2026-01-15
-- ============================================================================

-- Drop table if it exists
DROP TABLE IF EXISTS SCZIPCODE;

-- Create the SCZIPCODE table
CREATE TABLE SCZIPCODE (
    ZIP              CHAR(5)        NOT NULL,
    TYPE             CHAR(10)       NOT NULL DEFAULT '',
    PRIMARY_CITY     CHAR(50)       NOT NULL DEFAULT '',
    ACCEPTABLE_CITIES CHAR(500)     NOT NULL DEFAULT '',
    STATE            CHAR(2)        NOT NULL DEFAULT '',
    LATITUDE         DECIMAL(8,2)   NOT NULL DEFAULT 0,
    LONGITUDE        DECIMAL(8,2)   NOT NULL DEFAULT 0,
    COUNTRY          CHAR(2)        NOT NULL DEFAULT '',
    CREATED_DATE     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED_DATE     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Primary key constraint
    CONSTRAINT SCZIPCODE_PK PRIMARY KEY (ZIP, PRIMARY_CITY)
);

-- Label the table and columns
LABEL ON TABLE SCZIPCODE IS 'US ZIP Code Reference Data';

LABEL ON COLUMN SCZIPCODE (
    ZIP              IS 'ZIP Code',
    TYPE             IS 'ZIP Type (STANDARD, PO BOX, UNIQUE)',
    PRIMARY_CITY     IS 'Primary City Name',
    ACCEPTABLE_CITIES IS 'Acceptable City Names',
    STATE            IS 'State Code',
    LATITUDE         IS 'Latitude Coordinate',
    LONGITUDE        IS 'Longitude Coordinate',
    COUNTRY          IS 'Country Code',
    CREATED_DATE     IS 'Record Created Date',
    UPDATED_DATE     IS 'Record Updated Date'
);

-- Grant access (adjust schema/authorization as needed)
GRANT SELECT, INSERT, UPDATE, DELETE ON SCZIPCODE TO PUBLIC;