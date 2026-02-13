# Commission Matrix Display Program

## Overview
This program displays commission rates from the ARPCOMMTX table based on Plan Number, Division, and Section parameters.

## Files Created

### 1. Display File: [`ARPCOMM1.DSPF`](QDDSSRC/ARPCOMM1.DSPF)
**Location:** QDDSSRC/ARPCOMM1.DSPF

Screen layout showing:
- Input parameters (Plan, Division, Section) at the top
- Subfile displaying commission rates with columns:
  - Sales Low/High ranges
  - Profit percentage Low/High ranges
  - Commission Rate
  - Option field for user selection

**Features:**
- F3=Exit, F5=Refresh, F12=Cancel
- F17=Top, F18=Bottom for subfile navigation
- Option 5 for detail display

### 2. RPG Program: [`arpcomm1.sqlrpgle`](QRPGLESRC/arpcomm1.sqlrpgle)
**Location:** QRPGLESRC/arpcomm1.sqlrpgle

**Parameters:**
- Plan Number (3,0 packed decimal)
- Division (3 characters)
- Section (3 characters)

**Features:**
- Parameter validation
- SQL cursor to fetch commission matrix data
- Subfile loading and display
- Option processing (5=Display Details)
- Error handling

### 3. CL Wrapper: [`ARPCOMM1C.CLLE`](QCLSRC/ARPCOMM1C.CLLE)
**Location:** QCLSRC/ARPCOMM1C.CLLE

Wrapper program to validate parameters before calling the display program.

### 4. Template: [`ARPCOMTMP.RPGLEINC`](QRPGCOPY/ARPCOMTMP.RPGLEINC)
**Location:** QRPGCOPY/ARPCOMTMP.RPGLEINC

Data structure templates for commission matrix data (for future use).

## Compilation Instructions

### Step 1: Create Display File
```
CRTDSPF FILE(YOURLIB/ARPCOMM1) SRCFILE(YOURLIB/QDDSSRC) RSTDSP(*YES)
```

### Step 2: Create RPG Program
```
CRTSQLRPGI OBJ(YOURLIB/ARPCOMM1) +
           SRCFILE(YOURLIB/QRPGLESRC) +
           SRCMBR(ARPCOMM1) +
           COMMIT(*NONE) +
           DBGVIEW(*SOURCE) +
           REPLACE(*YES) +
           COMPILEOPT('DBGVIEW(*ALL)')
```

### Step 3: Create CL Program
```
CRTBNDCL PGM(YOURLIB/ARPCOMM1C) +
         SRCFILE(YOURLIB/QCLSRC) +
         SRCMBR(ARPCOMM1C) +
         DBGVIEW(*SOURCE) +
         REPLACE(*YES)
```

## Usage Examples

### Example 1: Display Plan 3, ECM Division, SUP Section
```
CALL ARPCOMM1C PARM(3 'ECM' 'SUP')
```

Expected output: 3 rows showing profit bands 0-13.9%, 14-17.9%, 18-99.9%

### Example 2: Display Plan 3, WES Division, SUP Section
```
CALL ARPCOMM1C PARM(3 'WES' 'SUP')
```

Expected output: Many rows showing detailed sales tiers and profit bands

### Example 3: Display Plan 4, ECM Division, AMX Section
```
CALL ARPCOMM1C PARM(4 'ECM' 'AMX')
```

Expected output: 3 rows with profit bands and lower commission rates

## Database Requirements

### Required Table: ARPCOMMTX

Expected column names (adjust program if different):
- `PLAN_NO` - Plan number
- `COMPANY_NO` - Company number (defaults to 1)
- `DIVISION` - Division code
- `SECTION` - Section code
- `SALES_LOW` - Minimum sales amount
- `SALES_HIGH` - Maximum sales amount
- `PROFIT_LOW` - Minimum profit percentage
- `PROFIT_HIGH` - Maximum profit percentage
- `COMM_RATE` - Commission rate percentage

## Screen Layout

```
ARPCOMM1              Commission Matrix Display            02/13/26
                                                            13:45:00

Plan Number . . . 3   Division  . . . ECM   Section . . . SUP

Type options, press Enter.
   5=Display Details
Sales Low      Sales High      Prof Low  Prof High  Comm Rate  Opt
         1        9999999          0.00       13.9       9.00
         1        9999999         14.00       17.9      10.00
         1        9999999         18.00       99.9      12.00




F3=Exit   F5=Refresh   F12=Cancel
F17=Top   F18=Bottom
```

## Troubleshooting

### Issue: "File ARPCOMMTX not found"
**Solution:** Verify the table exists and is accessible. Check library list.

### Issue: "No records displayed"
**Solution:** 
- Verify parameters match data in ARPCOMMTX table
- Check that COMPANY_NO = 1 (hardcoded in program)
- Verify data exists for the Plan/Division/Section combination

### Issue: "Level check on display file"
**Solution:** Recompile both the display file and the RPG program

## Customization Options

### 1. Change Company Number Filter
In [`arpcomm1.sqlrpgle`](QRPGLESRC/arpcomm1.sqlrpgle:117), modify:
```rpgle
AND COMPANY_NO = 1
```

### 2. Add More Subfile Options
Modify the [`ProcessOptions()`](QRPGLESRC/arpcomm1.sqlrpgle:204) procedure to handle additional option values.

### 3. Change Sort Order
In [`LoadSubfile()`](QRPGLESRC/arpcomm1.sqlrpgle:121), modify the ORDER BY clause:
```sql
ORDER BY SALES_LOW, PROFIT_LOW
```

### 4. Display Company Number
Add COMPANY_NO to the screen header and fetch it from the database.

## Future Enhancements

1. **Detail Window** - Implement the [`DisplayDetails()`](QRPGLESRC/arpcomm1.sqlrpgle:234) procedure with a popup window
2. **Search Function** - Add ability to search for specific profit/sales ranges
3. **Export Function** - Add option to export data to CSV or PDF
4. **Multiple Company Support** - Add company parameter
5. **Commission Calculator** - Add fields to calculate actual commission based on entered sales/profit values