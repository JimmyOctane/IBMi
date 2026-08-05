**FREE

//===========================================================================
// Program: CRTCUST_TS
// Description: Simple Test Program for CREATECUST Service Program
//
// Purpose:
//   Test the CreateCustomer procedure with a hardcoded GUID
//
// Processing:
//   1. Hardcode GUID: 9D005004-98A9-1AEF-848C-0004AC1DCCD6
//   2. Call CreateCustomer procedure
//   3. Display completion message
//
// Notes:
//   - This is a simple test harness for the CREATECUST service program
//   - The GUID is hardcoded for testing purposes
//===========================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*Caller);
Ctl-Opt Option(*SrcStmt:*NoDebugIo);
Ctl-Opt BndDir('ECBIND');

// Copy member for CreateCustomer procedure prototype
/COPY QCPYSRC,CRTCUST_CP

// Main procedure
Dcl-S TestGUID Char(36) Inz('A4AC7004-EE2A-1AF0-848C-0004AC1DCCD6');

// Display test start
Dsply ('CRTCUST_TS - Test Program Starting');
Dsply ('Testing GUID:');
Dsply TestGUID;

// Call CreateCustomer with hardcoded GUID
CreateCustomer(TestGUID);

// Display test completion
Dsply ('CRTCUST_TS - Test Program Complete');

*INLR = *On;
Return;

