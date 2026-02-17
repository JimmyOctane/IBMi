# XMLORDAUD Single Record Logging - Changes Summary

## Overview
Modified program [`NEUXMLR.SQLRPGLE`](QRPGLESRC/neuxmlr.sqlrpgle:1) to write **only ONE audit record per transaction** instead of multiple records for each operation.

## Changes Made

### 1. Table Structure - [`XMLORDAUD.SQL`](QDDSSRC/XMLORDAUD.SQL:1)

**Old Structure:**
- Multiple records per transaction (one for each operation)
- Fields: AUDACTION, TABLENAME, FIELDNAME, REMARKS, STATUS

**New Structure:**
- Single record per transaction with comprehensive summary
- New fields:
  - `HEADER_COUNT` - Number of header records processed (0 or 1)
  - `DETAIL_COUNT` - Number of detail line items successfully processed
  - `DETAIL_ERRORS` - Number of detail line items that failed
  - `ERROR_STAGE` - Where error occurred (PARSE, HEADER, CURSOR, DETAIL)
  - `SQLCODE` - SQL error code if applicable
  - `SQLSTATE` - SQL state if applicable
  - `MESSAGE` - Comprehensive success or error message (500 chars)

**Removed fields:**
- `AUDACTION` - No longer needed (status is S or E)
- `TABLENAME` - Not needed for summary
- `FIELDNAME` - Not needed for summary

### 2. Program Logic - [`NEUXMLR.SQLRPGLE`](QRPGLESRC/neuxmlr.sqlrpgle:1)

**Key Changes:**

#### New Variables (lines 130-148):
```rpgle
dcl-s itemErrorCount int(10) inz(0);    // Track failed line items
dcl-s errorStage varchar(20);            // Track where error occurred
dcl-s headerCount int(10) inz(0);        // Track header success
dcl-s errorMessage varchar(500);         // Expanded message size
```

#### Error Handling Pattern:
Instead of writing audit records immediately, errors are tracked and written once:

**Parse Error (line ~440):**
- Sets `errorStage = 'PARSE'`
- Writes single audit record
- Returns immediately

**Header Insert Error (line ~565):**
- Sets `errorStage = 'HEADER'`
- Writes single audit record
- Returns immediately

**Cursor Error (line ~649):**
- Sets `errorStage = 'CURSOR'`
- Writes single audit record
- Returns immediately

**Detail Line Errors (line ~690):**
- Increments `itemErrorCount`
- Continues processing other lines
- First error message captured

**Success Path (line ~710):**
- Writes single comprehensive audit record
- Includes all counts and success message

### 3. Audit Record Format

**Success Record:**
```sql
STATUS: 'S'
HEADER_COUNT: 1
DETAIL_COUNT: <number of successful lines>
DETAIL_ERRORS: <number of failed lines>
ERROR_STAGE: null
MESSAGE: 'Successfully processed order XXX with N line items'
```

**Error Record:**
```sql
STATUS: 'E'
HEADER_COUNT: 0 or 1 (depending on stage)
DETAIL_COUNT: <number processed before error>
DETAIL_ERRORS: <number of failed lines>
ERROR_STAGE: 'PARSE', 'HEADER', 'CURSOR', or 'DETAIL'
SQLCODE: <error code>
SQLSTATE: <SQL state>
MESSAGE: <detailed error description>
```

## Benefits

1. **Reduced Database I/O** - One insert instead of 5-20+ inserts per transaction
2. **Cleaner Audit Trail** - One record per order is easier to query and analyze
3. **Better Performance** - Fewer database operations
4. **Comprehensive Summary** - All metrics in one place
5. **Easier Reporting** - Simple queries to get success/failure counts

## Migration Notes

### To Apply Changes:

1. **Recreate XMLORDAUD table:**
   ```sql
   DROP TABLE JAMIEDEV.XMLORDAUD;
   -- Then run QDDSSRC/XMLORDAUD.SQL
   ```

2. **Recompile program:**
   ```
   CRTSQLRPGI OBJ(JAMIEDEV/NEUXMLR) 
              SRCFILE(JAMIEDEV/QRPGLESRC) 
              SRCMBR(NEUXMLR)
              COMMIT(*NONE)
              DBGVIEW(*SOURCE)
   ```

### Sample Queries:

**View all transactions:**
```sql
SELECT ORDERNBR, STATUS, HEADER_COUNT, DETAIL_COUNT, DETAIL_ERRORS, 
       ERROR_STAGE, MESSAGE, AUDTSTAMP
FROM JAMIEDEV.XMLORDAUD
ORDER BY AUDTSTAMP DESC;
```

**Count successes vs errors:**
```sql
SELECT STATUS, COUNT(*) as COUNT
FROM JAMIEDEV.XMLORDAUD
GROUP BY STATUS;
```

**Find errors by stage:**
```sql
SELECT ERROR_STAGE, COUNT(*) as COUNT
FROM JAMIEDEV.XMLORDAUD
WHERE STATUS = 'E'
GROUP BY ERROR_STAGE;
```

**Total line items processed:**
```sql
SELECT SUM(DETAIL_COUNT) as TOTAL_LINES_PROCESSED,
       SUM(DETAIL_ERRORS) as TOTAL_ERRORS
FROM JAMIEDEV.XMLORDAUD;
```

## Testing Recommendations

1. Test successful order processing
2. Test XML parse errors (malformed XML)
3. Test header insert errors (duplicate order number)
4. Test detail line errors (invalid data)
5. Verify only ONE record written per transaction
6. Verify counts are accurate

## Files Modified

- [`QDDSSRC/XMLORDAUD.SQL`](QDDSSRC/XMLORDAUD.SQL:1) - Table definition
- [`QRPGLESRC/neuxmlr.sqlrpgle`](QRPGLESRC/neuxmlr.sqlrpgle:1) - Main program logic
