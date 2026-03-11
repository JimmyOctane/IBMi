**FREE
//===========================================================================
// Program: READCUSTP
// Description: Read BECCUSTP table using primary key GUID
//              Uses EXTNAME to automatically match table structure
//===========================================================================
// Modification Log:
// Date       User  Description
// 2026-03-10 JF    Initial creation - Read by GUID primary key
//===========================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIo);

// Entry parameters
Dcl-PI *N;
  pGUID Char(36) Const;
End-PI;

// Externally defined data structure for BECCUSTP record
// This automatically includes all fields from the table
Dcl-DS BeccustpDS ExtName('BECCUSTP') Qualified End-DS;

// Variables
Dcl-S RecordFound Ind Inz(*Off);
Dcl-S wGUID Char(36);

// Main Processing
*InLR = *On;

// Store passed GUID
wGUID = pGUID;

// Read record from BECCUSTP using primary key GUID
ReadCustomerByGUID(wGUID);

// Display results
If RecordFound;
  Dsply ('Record found for GUID: ' + %Trim(wGUID));
  Dsply ('Account ID: ' + %Trim(BeccustpDS.ACCTID));
  Dsply ('Customer Legal: ' + %Trim(BeccustpDS.CUSTLEGAL));
  Dsply ('Customer DBA: ' + %Trim(BeccustpDS.CUSTDBA));
  Dsply ('City: ' + %Trim(BeccustpDS.CITY));
  Dsply ('State: ' + %Trim(BeccustpDS.STATE));
  Dsply ('Status: ' + BeccustpDS.STATUS);
Else;
  Dsply ('No record found for GUID: ' + %Trim(wGUID));
EndIf;

Return;

//===========================================================================
// Procedure: ReadCustomerByGUID
// Description: Read BECCUSTP record using unique GUID primary key
//===========================================================================
Dcl-Proc ReadCustomerByGUID;
  Dcl-PI *N;
    pGUID Char(36) Const;
  End-PI;

  // Read record by GUID (primary key - unique)
  Exec SQL
    SELECT *
    INTO :BeccustpDS
    FROM BECCUSTP
    WHERE GUID = :pGUID;

  // Check if record was found
  If SQLCODE = 0;
    RecordFound = *On;
  ElseIf SQLCODE = 100;
    // No record found
    RecordFound = *Off;
  Else;
    // SQL error occurred
    RecordFound = *Off;
    Dsply ('SQL Error: ' + %Char(SQLCODE));
    Dsply ('SQL State: ' + SQLSTATE);
  EndIf;

End-Proc;
