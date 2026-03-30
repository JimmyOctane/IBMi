**==================================================================**
**     READXLSX - SQL Stored Procedure Wrapper                     **
**==================================================================**
**  Alternative callable interface using SQL                        **
**==================================================================**

CREATE OR REPLACE PROCEDURE READ_XLSX_IFS(
  IN XLSX_PATH VARCHAR(256),
  IN TARGET_LIBRARY VARCHAR(10),
  IN TARGET_TABLE VARCHAR(10),
  IN SHEET_NAME VARCHAR(10) DEFAULT '0',
  IN START_ROW VARCHAR(5) DEFAULT '0'
)
LANGUAGE SQL
SPECIFIC READ_XLSX_IFS
MODIFIES SQL DATA
BEGIN
  DECLARE CMD VARCHAR(1000);
  DECLARE PYTHON_PATH VARCHAR(256) DEFAULT '/home/jflanary/read_xlsx_callable.py';
  
  -- Build command to execute Python script
  SET CMD = 'QSH CMD(''python3 ' || PYTHON_PATH || ' "' 
    || XLSX_PATH || '" "' 
    || UPPER(TARGET_LIBRARY) || '" "' 
    || UPPER(TARGET_TABLE) || '" "' 
    || SHEET_NAME || '" "' 
    || START_ROW || '"'')';
  
  -- Execute the command
  CALL QSYS2.QCMDEXC(CMD);
END;

-- Grant execute permission
GRANT EXECUTE ON PROCEDURE READ_XLSX_IFS TO PUBLIC;

**==================================================================**
**  Usage Examples:                                                 **
**==================================================================**

-- Basic usage (first sheet, first row)
CALL READ_XLSX_IFS(
  '/home/data/sales.xlsx',
  'MYLIB',
  'SALESTBL'
);

-- Specify sheet and starting row
CALL READ_XLSX_IFS(
  '/home/data/inventory.xlsx',
  'INVLIB',
  'INVTBL',
  '0',      -- First sheet (0-based index)
  '1'       -- Start at row 1 (skip header)
);

-- Use named sheet
CALL READ_XLSX_IFS(
  '/home/data/report.xlsx',
  'RPTLIB',
  'RPTTBL',
  'Summary',  -- Sheet name
  '0'
);

-- From RPG using embedded SQL
exec sql CALL READ_XLSX_IFS(
  :xlsxPath,
  :library,
  :table,
  :sheet,
  :startRow
);

**==================================================================**
**  Query to check if procedure exists:                             **
**==================================================================**

SELECT ROUTINE_SCHEMA, ROUTINE_NAME, ROUTINE_TYPE
FROM QSYS2.SYSROUTINES
WHERE ROUTINE_NAME = 'READ_XLSX_IFS';
