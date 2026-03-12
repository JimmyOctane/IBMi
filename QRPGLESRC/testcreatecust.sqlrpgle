**FREE
//===========================================================================
// Program: TESTCREATECUST
// Description: Simple test program for CREATECUST service program
//
// Purpose:
//   Test the CREATECUST service program by calling it with a GUID from
//   BECCUSTP
//
// Usage:
//   1. Find a GUID from BECCUSTP table that needs processing
//   2. Call this program: CALL TESTCREATECUST
//   3. Check results in AR tables and BECCUSTP status
//===========================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIo)
        BndDir('ECBIND');

// Copy member for CreateCustomer procedure prototype
/COPY qcpysrc,CREATECUST_CP

// Variables
Dcl-S testGUID Char(36);
Dcl-S custName Char(50);
Dcl-S custStatus Char(1);

// Main processing
Exec SQL
  SELECT GUID, CUSTNAME, CUSTSTATUS
  INTO :testGUID, :custName, :custStatus
  FROM BECCUSTP
  WHERE CUSTSTATUS = ' '  // Find unprocessed record
  FETCH FIRST 1 ROW ONLY;

If SQLCODE = 0;
  Dsply ('Testing with GUID: ' + %Trim(testGUID));
  Dsply ('Customer Name: ' + %Trim(custName));
  
  // Call CREATECUST
  CreateCustomer(testGUID);
  
  // Check result
  Exec SQL
    SELECT CUSTSTATUS
    INTO :custStatus
    FROM BECCUSTP
    WHERE GUID = :testGUID;
  
  If SQLCODE = 0;
    Select;
      When custStatus = ' ';
        Dsply 'SUCCESS: Customer created successfully';
      When custStatus = 'X';
        Dsply 'DUPLICATE: Customer already exists';
      When custStatus = 'E';
        Dsply 'ERROR: Customer creation failed';
      Other;
        Dsply ('Status: ' + custStatus);
    EndSl;
  Else;
    Dsply ('SQL Error checking status: ' + %Char(SQLCODE));
  EndIf;
Else;
  Dsply ('No unprocessed records found in BECCUSTP');
  Dsply ('SQL Code: ' + %Char(SQLCODE));
EndIf;

*INLR = *On;
Return;
