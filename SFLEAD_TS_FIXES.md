# SFLEAD_TS.SQLRPGLE Compilation Error Fixes

## Status Update

✅ **FIXED**: Line 1168 - String constant '3MVG90d5' issue resolved
✅ **FIXED**: JWT_CP file created in QRPGCOPY/JWT_CP.SQLRPGLE
❌ **REMAINING**: Line 1268 - String constant 'https://' not delimited

## Current Errors

1. **SQL0010 at line 1268**: String constant beginning 'https://' not delimited
2. **SQL1002 at line 1378**: Member JWT_CP file QRPGLECPY in *LIBL for /COPY not found

## Root Causes and Solutions

### 1. String Delimiter Issues (Lines 1168 & 1267)

**Problem**: In RPG/SQLRPGLE, string constants must be properly delimited with single quotes ('). The error suggests that strings containing '3MVG90d5' (likely a Salesforce Consumer Key) and 'https://' (a URL) are not properly quoted or the quotes are broken across lines.

**Common Causes**:
- String is too long and split across multiple lines without proper continuation
- Missing closing quote
- Quote character inside the string not properly escaped

**Solution**:
```rpgle
// WRONG - String too long, breaks at line end
dcl-c CLIENT_ID '3MVG90d5...very_long_string_that_continues...

// CORRECT - Use + for concatenation across lines
dcl-c CLIENT_ID '3MVG90d5LoooongPartOne' +
                'ContinuedPartTwo' +
                'FinalPart';

// OR use a variable with proper length
dcl-s clientId varchar(500) inz('3MVG90d5...full_string...');

// For URLs with https://
dcl-c AUTH_URL 'https://login.salesforce.com/services/oauth2/token';
```

**Specific Fixes Needed**:

**Line ~1168** - Check for:
```rpgle
// Find something like this (BROKEN):
clientId = '3MVG90d5...
           ...rest_of_string;

// Fix to:
clientId = '3MVG90d5...' +
           '...rest_of_string';
```

**Line ~1267** - Check for:
```rpgle
// Find something like this (BROKEN):
authUrl = 'https://login.salesforce.com/services/oauth2/token
          ...more;

// Fix to:
authUrl = 'https://login.salesforce.com/services/oauth2/token';
// OR if it's longer:
authUrl = 'https://login.salesforce.com/' +
          'services/oauth2/token';
```

### 2. Missing JWT_CP Copy File (Line 1377)

**Problem**: The program is trying to include `/COPY JWT_CP` but the file doesn't exist in QRPGLECPY library.

**Solution Options**:

**Option A**: Create the JWT_CP copy file if it's needed
```rpgle
// Create JAMIEDEV/QRPGLECPY(JWT_CP) with JWT-related prototypes
// Example content:
**FREE
// JWT Token Generation Prototypes
dcl-pr generateJWT varchar(5000);
  clientId varchar(500) const;
  privateKey varchar(5000) const;
  username varchar(100) const;
end-pr;
```

**Option B**: Remove the /COPY if not needed
```rpgle
// If line 1377 has:
/COPY JWT_CP

// And it's not actually used, simply remove or comment it out:
// /COPY JWT_CP
```

**Option C**: Use correct library/file reference
```rpgle
// If JWT_CP exists in a different library:
/COPY JAMIEDEV/QRPGLECPY,JWT_CP
// OR
/COPY QRPGCOPY,JWT_CP
```

## Step-by-Step Fix Instructions for Remaining Errors

### Fix 1: Line 1268 - String Constant 'https://' Not Delimited

**Problem**: Position 22 indicates the error is at character 22 of line 1268. This typically means:
- A string literal is missing its closing quote
- A string is broken across lines without proper concatenation
- Special characters in the URL are causing parsing issues

**Action Required**:
1. Open SFLEAD_TS.SQLRPGLE in JAMIEDEV/QRPGLESRC
2. Navigate to line 1268
3. Look for a URL string starting with 'https://'
4. Check if the string has both opening (') and closing (') quotes
5. If the URL is long and wraps to the next line, use concatenation:

```rpgle
// WRONG - String breaks across lines
authUrl = 'https://login.salesforce.com/services/oauth2/token
          more_text';

// CORRECT - Use + for concatenation
authUrl = 'https://login.salesforce.com/services/oauth2/token' +
          'more_text';

// OR - Keep it on one line if possible
authUrl = 'https://login.salesforce.com/services/oauth2/token';
```

**Common Patterns to Look For**:
```rpgle
// Pattern 1: Missing closing quote
dcl-c AUTH_URL 'https://login.salesforce.com;  // WRONG - missing '

// Pattern 2: Line break in string
dcl-c AUTH_URL 'https://login.salesforce.com/
                services/oauth2/token';  // WRONG

// Pattern 3: Correct single-line
dcl-c AUTH_URL 'https://login.salesforce.com/services/oauth2/token';

// Pattern 4: Correct multi-line with concatenation
dcl-c AUTH_URL 'https://login.salesforce.com/' +
               'services/oauth2/token';
```

### Fix 2: Line 1378 - JWT_CP File Not Found

**Problem**: The `/COPY QRPGLECPY,JWT_CP` statement cannot find the JWT_CP member.

**Solution**: I've created JWT_CP.SQLRPGLE in your local QRPGCOPY directory. You need to:

1. **Upload JWT_CP to IBM i**:
   ```
   - Copy the file from: c:/JimmyOctane/IBMi/QRPGCOPY/JWT_CP.SQLRPGLE
   - Upload to IBM i library: JAMIEDEV/QRPGLECPY(JWT_CP)
   ```

2. **Or change the /COPY statement** in SFLEAD_TS.SQLRPGLE at line 1378:
   ```rpgle
   // Change from:
   /COPY QRPGLECPY,JWT_CP
   
   // To:
   /COPY QRPGCOPY,JWT_CP
   ```

3. **Verify the file exists** on IBM i:
   ```sql
   SELECT * FROM TABLE(QSYS2.OBJECT_STATISTICS(
     OBJECT_SCHEMA => 'JAMIEDEV',
     OBJECT_NAME => 'QRPGLECPY',
     OBJECT_TYPE => 'FILE'
   ));
   ```

### Quick Fix Summary

**For Line 1268 (https:// error)**:
- Find line 1268 in SFLEAD_TS.SQLRPGLE
- Locate the string at position 22 (character 22 of that line)
- Add closing quote or fix concatenation

**For Line 1378 (JWT_CP error)**:
- Upload QRPGCOPY/JWT_CP.SQLRPGLE to IBM i as JAMIEDEV/QRPGLECPY(JWT_CP)
- OR change `/COPY QRPGLECPY,JWT_CP` to `/COPY QRPGCOPY,JWT_CP`

### After Fixes, Recompile

```
CRTSQLRPGI OBJ(JAMIEDEV/SFLEAD_TS) +
           SRCFILE(JAMIEDEV/QRPGLESRC) +
           SRCMBR(SFLEAD_TS) +
           COMMIT(*NONE) +
           DBGVIEW(*SOURCE)
```

## Example: Typical Salesforce JWT Authentication Code

Here's how the corrected code might look:

```rpgle
**FREE
ctl-opt dftactgrp(*no) actgrp(*new);

// Salesforce OAuth Constants
dcl-c CLIENT_ID '3MVG90d5FyVlXVOZ9k5YQZ...' +
                'rest_of_very_long_client_id';

dcl-c AUTH_ENDPOINT 'https://login.salesforce.com' +
                    '/services/oauth2/token';

dcl-c PRIVATE_KEY '-----BEGIN RSA PRIVATE KEY-----' +
                  'MIIEpAIBAAKCAQEA...' +
                  '-----END RSA PRIVATE KEY-----';

// JWT Copy file (if needed)
/COPY QRPGCOPY,JWT_CP

// Rest of program...
```

## Verification

After making fixes, compile with:
```
CRTSQLRPGI OBJ(JAMIEDEV/SFLEAD_TS) SRCFILE(JAMIEDEV/QRPGLESRC) +
           SRCMBR(SFLEAD_TS) COMMIT(*NONE) DBGVIEW(*SOURCE)
```

The compilation should complete without SQL0010 or SQL1002 errors.
