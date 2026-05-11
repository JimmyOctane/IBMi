**FREE
//==============================================================================
// Program: LOADCSVSQL - Load Customer Totals from CSV using SQL
// Description: Uses SQL to read CSV file from IFS and load into table
// File Location: /home/NEUCO/*.csv
// Format: Customer Number,total$
//==============================================================================

ctl-opt dftactgrp(*no) actgrp(*new) option(*nodebugio:*srcstmt);

//==============================================================================
// Variables
//==============================================================================
dcl-s filePath varchar(256) inz('/home/NEUCO/customer_totals.csv');
dcl-s recordCount int(10) inz(0);
dcl-s sqlState char(5);
dcl-s msgText varchar(256);

//==============================================================================
// Main Processing
//==============================================================================

// Create table if it doesn't exist
exec sql
  CREATE TABLE JAMIEDEV.CUSTOMER_TOTALS (
    CUST_NBR DECIMAL(11, 0) NOT NULL,
    TOTAL_AMT DECIMAL(15, 2) NOT NULL,
    LOAD_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (CUST_NBR)
  );

if sqlcode <> 0 and sqlcode <> -601; // -601 = table already exists
  msgText = 'Error creating table: SQLCODE=' + %char(sqlcode);
  snd-msg *info %trim(msgText) %target(*pgmbdy:1);
endif;

// Clear existing data
exec sql DELETE FROM JAMIEDEV.CUSTOMER_TOTALS;

snd-msg *info 'Processing file: ' + %trim(filePath)
  %target(*pgmbdy:1);

// Load data directly from CSV using SQL
exec sql
  INSERT INTO JAMIEDEV.CUSTOMER_TOTALS (CUST_NBR, TOTAL_AMT)
  SELECT 
    CAST(TRIM(SUBSTR(LINE, 1, LOCATE(',', LINE) - 1)) AS DECIMAL(11, 0)),
    CAST(TRIM(SUBSTR(LINE, LOCATE(',', LINE) + 1)) AS DECIMAL(15, 2))
  FROM TABLE(
    QSYS2.IFS_READ_UTF8(PATH_NAME => :filePath)
  ) AS IFS_DATA
  WHERE LINE_NUMBER > 1
    AND TRIM(LINE) <> ''
    AND LOCATE(',', LINE) > 0;

if sqlcode = 0;
  
  // Get count of records loaded
  exec sql
    SELECT COUNT(*) INTO :recordCount
    FROM JAMIEDEV.CUSTOMER_TOTALS;
  
  msgText = 'Successfully loaded ' + %char(recordCount) + ' records';
  snd-msg *info %trim(msgText) %target(*pgmbdy:1);
  
else;
  
  msgText = 'Error loading data: SQLCODE=' + %char(sqlcode);
  snd-msg *info %trim(msgText) %target(*pgmbdy:1);
  
endif;

*inlr = *on;
return;
