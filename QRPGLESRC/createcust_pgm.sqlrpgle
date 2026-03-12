**FREE
//===========================================================================
// Program: CREATECUST (Wrapper Program)
// Description: Wrapper program for CREATECUST service program
//
// Purpose:
//   Provides backward compatibility by calling the CreateCustomer procedure
//   from the CREATECUST service program
//
// Input:
//   - pGUID: 36-character GUID identifying the BECCUSTP record to process
//===========================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIo)
        BndDir('ECBIND');

// Copy member for CreateCustomer procedure prototype
/COPY qcpysrc,CREATECUST_CP

// Entry parameters
Dcl-PI *N;
  pGUID Char(36) Const;
End-PI;

// Call the service program procedure
CreateCustomer(pGUID);

*INLR = *On;
Return;
