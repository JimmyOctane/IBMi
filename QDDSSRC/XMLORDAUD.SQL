  /* ================================================================ */
  /* Script to recreate XMLORDAUD table with new structure           */
  /* Run this before recompiling NEUXMLR program                     */
  /* ================================================================ */

  /* Drop existing table */
  DROP TABLE JAMIEDEV.XMLORDAUD;

  /* Create new table with updated structure */
  CREATE TABLE JAMIEDEV.XMLORDAUD (
    /* Primary key */
    AUDITID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (
      START WITH 1 INCREMENT BY 1
      NO CYCLE NO ORDER
    ),

    /* Order number for reference */
    ORDERNBR VARCHAR(40),

    /* Transmission ID from XML */
    TRANSMSNID VARCHAR(50),

    /* User name */
    USERNAME VARCHAR(10),

    /* Timestamp when processing started */
    AUDTSTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    /* Program name */
    PROGRAMNM VARCHAR(10),

    /* Full IFS document path including filename */
    IFSDOCUMENTPATH VARCHAR(1000),

    /* Overall processing status: S=Success, E=Error */
    STATUS CHAR(1) NOT NULL,

    /* Number of header records processed (0 or 1) */
    HEADER_COUNT INTEGER DEFAULT 0,

    /* Number of detail line items processed successfully */
    DETAIL_COUNT INTEGER DEFAULT 0,

    /* Number of detail line items that failed */
    DETAIL_ERRORS INTEGER DEFAULT 0,

    /* Error stage (where error occurred): PARSE, HEADER, CURSOR, DETAIL, null if success */
    ERROR_STAGE VARCHAR(20),

    /* SQL error code if applicable */
    ERR_SQLCODE INTEGER,

    /* SQL state if applicable */
    ERR_SQLSTATE CHAR(5),

    /* Detailed error or success message */
    MESSAGE VARCHAR(500)
  );

  LABEL ON TABLE JAMIEDEV.XMLORDAUD IS 'XML Order Processing Audit Log';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.AUDITID IS 'Audit ID';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.ORDERNBR IS 'Order Number';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.TRANSMSNID IS 'Transmission ID';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.USERNAME IS 'User Name';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.AUDTSTAMP IS 'Audit Timestamp';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.PROGRAMNM IS 'Program Name';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.IFSDOCUMENTPATH IS 'Full IFS Document Path';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.STATUS IS 'Status (S=Success/E=Error)';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.HEADER_COUNT IS 'Header Records Processed';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.DETAIL_COUNT IS 'Detail Lines Processed';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.DETAIL_ERRORS IS 'Detail Lines Failed';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.ERROR_STAGE IS 'Error Stage';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.ERR_SQLCODE IS 'SQL Error Code';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.ERR_SQLSTATE IS 'SQL State';
  LABEL ON COLUMN JAMIEDEV.XMLORDAUD.MESSAGE IS 'Processing Message';
