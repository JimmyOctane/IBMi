# CSV to DB2 Table Loader - SQL Method

## Overview
This solution reads a CSV file directly from the IFS at `/home/NEUCO` and loads the data into a DB2 table using SQL's built-in [`QSYS2.IFS_READ_UTF8()`](https://www.ibm.com/docs/en/i/7.5?topic=services-ifs-read-read-ifs-file) table function.

## Components Created

### 1. Table Definition: [`CUSTOMER_TOTALS.SQL`](QDDSSRC/CUSTOMER_TOTALS.SQL:1)
- **Table**: `JAMIEDEV.CUSTOMER_TOTALS`
- **Columns**:
  - `CUST_NBR` - Customer Number (DECIMAL 11,0)
  - `TOTAL_AMT` - Total Amount (DECIMAL 15,2)
  - `LOAD_DATE` - Load Timestamp (auto-populated)

### 2. SQL Scripts (Choose One)

#### Option A: [`LOAD_CSV_SIMPLE.SQL`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:1) - Direct SQL Script
- Pure SQL script that can be run directly
- Uses [`QSYS2.IFS_READ_UTF8()`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:19) to read CSV from IFS
- Parses CSV format: `Customer Number,total$`
- Skips header row automatically
- Includes verification queries

#### Option B: [`LOADCSVSQL.SQLRPGLE`](QRPGLESRC/LOADCSVSQL.SQLRPGLE:1) - SQLRPGLE Program
- Wraps the SQL logic in an SQLRPGLE program
- Uses SQL [`IFS_READ_UTF8()`](QRPGLESRC/LOADCSVSQL.SQLRPGLE:47) table function
- Provides progress messages and error handling
- Can be called from CL programs or job schedulers

### 3. CL Compile/Run Program: [`LOADCSVSQL.CLLE`](QCLSRC/LOADCSVSQL.CLLE:1)
- Compiles the SQLRPGLE program
- Executes the load process

## Usage Instructions

### Method 1: Run SQL Script Directly (Recommended)

Use ACS Run SQL Scripts or RUNSQLSTM:

```
RUNSQLSTM SRCSTMF('/home/NEUCO/LOAD_CSV_SIMPLE.SQL') COMMIT(*NONE)
```

Or copy the SQL from [`LOAD_CSV_SIMPLE.SQL`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:1) and run in ACS Run SQL Scripts.

### Method 2: Compile and Run SQLRPGLE Program

From an IBM i command line:
```
CRTBNDCL PGM(JAMIEDEV/LOADCSVSQL) SRCFILE(JIMMYOCTANE/QCLSRC) SRCMBR(LOADCSVSQL)
CALL JAMIEDEV/LOADCSVSQL
```

Or compile manually:
```
CRTSQLRPGI OBJ(JAMIEDEV/LOADCSVSQL) SRCFILE(JIMMYOCTANE/QRPGLESRC) SRCMBR(LOADCSVSQL) COMMIT(*NONE) DBGVIEW(*SOURCE)
CALL JAMIEDEV/LOADCSVSQL
```

### Step 1: Place your CSV file
Ensure your CSV file is at: `/home/NEUCO/customer_totals.csv`

If your file has a different name, update the path in:
- [`LOAD_CSV_SIMPLE.SQL`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:21) line 21, or
- [`LOADCSVSQL.SQLRPGLE`](QRPGLESRC/LOADCSVSQL.SQLRPGLE:14) line 14

### Step 2: Verify Results
```sql
SELECT * FROM JAMIEDEV.CUSTOMER_TOTALS ORDER BY CUST_NBR;
```

## Features

- **Pure SQL Solution**: Uses DB2 for i's native [`QSYS2.IFS_READ_UTF8()`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:19) function
- **Automatic Header Skip**: Ignores the first line (header row)
- **No External Dependencies**: No need for C runtime functions or Python
- **Simple Parsing**: Uses [`SUBSTR()`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:22) and [`LOCATE()`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:22) for CSV parsing
- **Data Refresh**: Clears table before loading (can be modified to append)
- **Timestamp Tracking**: Automatically records when each row was loaded

## How It Works

The SQL uses the [`QSYS2.IFS_READ_UTF8()`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:19) table function which:
1. Reads the CSV file line by line from the IFS
2. Returns each line with a line number
3. The [`INSERT`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:18) statement parses each line:
   - Uses [`LOCATE(',')`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:22) to find the comma
   - Uses [`SUBSTR()`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:22) to extract customer number and amount
   - Casts values to appropriate data types
4. Filters out header row and empty lines

## Customization Options

### To Append Instead of Replace
Remove or comment out the DELETE statement in:
- [`LOAD_CSV_SIMPLE.SQL`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:15) line 15, or
- [`LOADCSVSQL.SQLRPGLE`](QRPGLESRC/LOADCSVSQL.SQLRPGLE:35) line 35

### To Handle Different CSV Formats
Modify the parsing logic in the [`SELECT`](QDDSSRC/LOAD_CSV_SIMPLE.SQL:22) statement to match your CSV structure.

### To Process Multiple Files
Modify the script to loop through multiple files or use wildcards with additional logic.
