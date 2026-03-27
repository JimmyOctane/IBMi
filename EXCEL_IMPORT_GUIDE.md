# Excel to IBM i DB2 Import Guide

## Overview
This guide explains how to import 2 specific fields from an Excel spreadsheet into an IBM i DB2 table using Python.

## Your Excel File
- **Location**: C:\JimmyOctane\IBMi\DG 2025 Q4.xlsx
- **Tab**: First tab (tab 1)
- **Fields**: 2 specific columns you need to import

## Files Created
1. **import_excel_to_db2.py** - Python script that reads Excel and imports to DB2
2. **create_import_table.sql** - SQL to create the target table
3. **run_excel_import.sh** - Shell script to run on IBM i
4. **QCLSRC/RUNXLSIMP.CLLE** - CL program to call from IBM i

## Step-by-Step Instructions

### Step 1: Identify Your Excel Columns
1. Open your Excel file: DG 2025 Q4.xlsx
2. Look at the first tab
3. Note the column names or positions (A=0, B=1, C=2, etc.) of the 2 fields you need

### Step 2: Customize the Python Script
Edit **import_excel_to_db2.py** and update these variables:

`python
# Excel configuration
SHEET_NAME = 0  # Keep as 0 for first sheet, or use 'SheetName'
FIELD1_COLUMN = 'ColumnName1'  # Or use 0 for column A, 1 for B, etc.
FIELD2_COLUMN = 'ColumnName2'  # Or use 1 for column B, 2 for C, etc.

# Database configuration
DB_LIBRARY = 'YOURLIB'     # Your IBM i library
DB_TABLE = 'YOURTABLE'     # Your table name
DB_FIELD1 = 'FIELD1'       # First field name in DB2
DB_FIELD2 = 'FIELD2'       # Second field name in DB2

# Connection info
DB_SYSTEM = 'your_system'  # IBM i system name or IP
DB_USER = 'your_user'      # Your user ID
DB_PASSWORD = 'your_pwd'   # Your password
`

### Step 3: Create the DB2 Table
Edit **create_import_table.sql** and customize:

`sql
CREATE TABLE YOURLIB.YOURTABLE (
    ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    FIELD1 VARCHAR(100) NOT NULL,  -- Adjust type/length
    FIELD2 VARCHAR(100) NOT NULL,  -- Adjust type/length
    CREATED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
`

Run the SQL on IBM i using ACS Run SQL Scripts or:
`
RUNSQLSTM SRCFILE(YOURLIB/QSQLSRC) SRCMBR(CREATETBL)
`

### Step 4: Install Required Python Packages on IBM i
SSH to IBM i and run:

`ash
# Install pandas for Excel reading
pip3 install pandas openpyxl

# Install pyodbc for DB2 connection
pip3 install pyodbc
`

### Step 5: Upload Files to IBM i
Transfer these files to IBM i:

1. **import_excel_to_db2.py** → /home/jflanary/import_excel_to_db2.py
2. **run_excel_import.sh** → /home/jflanary/run_excel_import.sh

Make the shell script executable:
`ash
chmod +x /home/jflanary/run_excel_import.sh
`

### Step 6: Test the Python Script
SSH to IBM i and test:

`ash
cd /home/jflanary
python3 import_excel_to_db2.py
`

Check output:
`ash
cat /tmp/excel_import_output.txt
cat /tmp/excel_import_error.txt
`

### Step 7: Compile the CL Program (Optional)
If you want to run from IBM i command line:

`
CRTBNDCL PGM(YOURLIB/RUNXLSIMP) 
         SRCFILE(YOURLIB/QCLSRC) 
         SRCMBR(RUNXLSIMP)
`

Then run:
`
CALL YOURLIB/RUNXLSIMP
`

## Alternative: Simple CSV Approach

If Python is too complex, you can use a simpler CSV approach:

### Option A: Excel → CSV → SQL
1. In Excel, delete all columns except the 2 you need
2. Save As → CSV format
3. Upload CSV to IFS: /home/jflanary/import_data.csv
4. Use SQL to load:

`sql
CREATE TABLE YOURLIB.TEMP_IMPORT (
    FIELD1 VARCHAR(100),
    FIELD2 VARCHAR(100)
);

-- Load from CSV
CALL QSYS2.IFS_READ(
    PATH_NAME => '/home/jflanary/import_data.csv',
    LINE => ?
);
`

### Option B: Use IBM i Access Client Solutions (ACS)
1. Open ACS
2. Go to Data Transfer → From PC
3. Select your Excel file
4. Map the 2 columns to your DB2 table
5. Click Transfer

## Troubleshooting

### Python not found
`ash
yum install python3 python3-pip
`

### pandas not installed
`ash
pip3 install pandas openpyxl
`

### pyodbc connection error
- Verify IBM i Access ODBC Driver is installed
- Check system name, user, password
- Verify library exists

### Permission denied
`ash
chmod +x /home/jflanary/run_excel_import.sh
`

### Excel file not found
- Verify the file path in the Python script
- Make sure the file is accessible from where Python runs

## Data Type Reference

Common data types for your fields:

| Excel Data | DB2 Type | Example |
|------------|----------|---------|
| Text | VARCHAR(n) | VARCHAR(100) |
| Number | INTEGER | INTEGER |
| Decimal | DECIMAL(p,s) | DECIMAL(15,2) |
| Date | DATE | DATE |
| Yes/No | CHAR(1) | CHAR(1) |

## Support

For questions or issues:
1. Check /tmp/excel_import_output.txt for execution log
2. Check /tmp/excel_import_error.txt for errors
3. Review Python script configuration
4. Verify DB2 table structure matches data

## Quick Reference

**Run from IBM i command line:**
`
CALL YOURLIB/RUNXLSIMP
`

**Run from SSH:**
`ash
/home/jflanary/run_excel_import.sh
`

**Check results:**
`sql
SELECT * FROM YOURLIB.YOURTABLE;
`
