**FREE
//===========================================================================
// Program: WRITMCUSX
// Description: Read BECCUSTP by GUID, then write to ARPMCUS with checking
//              Uses EXTNAME to automatically match table structures
//===========================================================================
// Modification Log:
// Date       User  Description
// 2026-03-09 JF    Initial creation - All 129 fields from ARPMCUS
// 2026-03-10 JF    Added BECCUSTP read as first process
// 2026-03-11 JF    Changed table name from ARPMCUSX to ARPMCUS
//===========================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIo)
        BndDir('ECBIND');

// Copy member for sendEmail
/COPY qcpysrc,SDEMAIL_CP

// Prototype for ARR5006 - Get Next Customer Number
Dcl-PR getNextCustomerNumber ExtPgm('ARR5006');
  pCustomerNumber Packed(6:0);
  pType Char(2);
  pValid Char(1);
End-PR;

// Entry parameters
Dcl-PI *N;
  pGUID Char(36) Const;
End-PI;

// Data structure for BECCUSTP record - automatically matches table
Dcl-DS BeccustpDS ExtName('BECCUSTP') Qualified End-DS;

// Data structure for ARPMCUSX record - automatically matches table
Dcl-DS CustomerDS ExtName('ARPMCUS') Qualified End-DS;

// Variables
Dcl-S BeccustpFound Ind Inz(*Off);
Dcl-S RecordExists Ind Inz(*Off);
Dcl-S RecordsInserted Int(10) Inz(0);
Dcl-S RecordsSkipped Int(10) Inz(0);
Dcl-S wGUID Char(36);

// Main Processing
*InLR = *On;

// Store passed GUID
wGUID = pGUID;

// STEP 1: Read BECCUSTP record by GUID (first process)
ReadBeccustpByGUID(wGUID);

// Check if BECCUSTP record was found
If BeccustpFound;
  Dsply ('BECCUSTP record found for GUID: ' + %Trim(wGUID));
  Dsply ('Account ID: ' + %Trim(BeccustpDS.ACCTID));
  Dsply ('Customer Legal: ' + %Trim(BeccustpDS.CUSTLEGAL));
  Dsply ('Customer DBA: ' + %Trim(BeccustpDS.CUSTDBA));
  
  // STEP 2: Insert the record into ARPMCUS (mapping done inside procedure)
  InsertCustomer(BeccustpDS);
  
  // Display summary
  Dsply ('Records inserted: ' + %Char(RecordsInserted));
  Dsply ('Records skipped: ' + %Char(RecordsSkipped));
Else;
  Dsply ('No BECCUSTP record found for GUID: ' + %Trim(wGUID));
EndIf;

Return;

//===========================================================================
// Procedure: InsertCustomer
// Description: Takes BeccustpDS, maps fields to CustomerDS, then checks
//              if record exists using progressive matching and inserts
//===========================================================================
Dcl-Proc InsertCustomer;
  Dcl-PI *N;
    pBeccustp LikeDS(BeccustpDS) Const;
  End-PI;

  // Local variables
  Dcl-S ExistingCustNo Packed(6:0);
  Dcl-S FoundRecord Ind;
  Dcl-DS LocalCustomerDS LikeDS(CustomerDS);
  Dcl-S newCustomerNumber Packed(6:0) Inz(0);
  Dcl-S TypeField Char(2);
  Dcl-S ValidField Char(1);

  // Get next customer number from ARR5006
  newCustomerNumber = 0;
  TypeField = *Blanks;
  ValidField = *Blanks;
  getNextCustomerNumber(newCustomerNumber: TypeField: ValidField);
  
  LocalCustomerDS.ARNO01 = newCustomerNumber;  // Customer Number from ARR5006
  LocalCustomerDS.ARNM01 = %Upper(%Trim(pBeccustp.CUSTLEGAL));  // Customer Legal Name
  LocalCustomerDS.ARNM03 = %Upper(%Trim(pBeccustp.CUSTCRTBY));  // User ID
  LocalCustomerDS.ARNM05 = %Upper(%Trim(pBeccustp.CUSTDBA));    // DBA/Sort Name
  
  // Map mailing address
  LocalCustomerDS.ARAD01 = %Upper(%Trim(pBeccustp.ADDR1));      // Mailing Address 1
  LocalCustomerDS.ARAD02 = %Upper(%Trim(pBeccustp.ADDR2));      // Mailing Address 2
  LocalCustomerDS.ARCY01 = %Upper(%Trim(pBeccustp.CITY));       // Mailing City
  LocalCustomerDS.ARST01 = %Upper(%Trim(pBeccustp.STATE));      // Mailing State
  LocalCustomerDS.ARZP15 = %Trim(pBeccustp.ZIPCODE);    // Mailing Zip

  // Progressive duplicate check:
  // 1. Match on Zip, State, City (case-insensitive)
  // 2. Then check address lines (skip line 1 if it's business name)
  // 3. Check address 2 and 3 for actual street address match
  Exec SQL
    SELECT ARNO01
    INTO :ExistingCustNo :FoundRecord
    FROM ARPMCUS
    WHERE UPPER(ARZP15) = UPPER(:LocalCustomerDS.ARZP15)
      AND UPPER(ARST01) = UPPER(:LocalCustomerDS.ARST01)
      AND UPPER(ARCY01) = UPPER(:LocalCustomerDS.ARCY01)
      AND (
        UPPER(ARAD02) = UPPER(:LocalCustomerDS.ARAD02)
        OR UPPER(ARAD03) = UPPER(:LocalCustomerDS.ARAD03)
      )
    FETCH FIRST 1 ROW ONLY;

  If FoundRecord = *Off;
    // No match found, insert new record
    Exec SQL
      INSERT INTO ARPMCUS
      VALUES (:LocalCustomerDS);

    If SQLCODE = 0;
      RecordsInserted += 1;
      Dsply ('Record inserted: ' + %Char(LocalCustomerDS.ARNO01));
    Else;
      // Call error handling procedure
      HandleInsertError(LocalCustomerDS: SQLCODE: SQLSTATE);
    EndIf;
  Else;
    // Duplicate found, skip insert
    RecordExists = *On;
    RecordsSkipped += 1;
    // Call duplicate handling procedure
    HandleDuplicateCustomer(ExistingCustNo: LocalCustomerDS);
  EndIf;

End-Proc;

//===========================================================================
// Procedure: ReadBeccustpByGUID
// Description: Read BECCUSTP record using unique GUID primary key
//===========================================================================
Dcl-Proc ReadBeccustpByGUID;
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
    BeccustpFound = *On;
  ElseIf SQLCODE = 100;
    // No record found
    BeccustpFound = *Off;
  Else;
    // SQL error occurred
    BeccustpFound = *Off;
    Dsply ('SQL Error reading BECCUSTP: ' + %Char(SQLCODE));
    Dsply ('SQL State: ' + SQLSTATE);
  EndIf;

End-Proc;

//===========================================================================
// Procedure: HandleInsertError
// Description: Handle SQL errors during customer insert
//===========================================================================
Dcl-Proc HandleInsertError;
  Dcl-PI *N;
    pCustomer LikeDS(CustomerDS) Const;
    pSQLCode Int(10) Const;
    pSQLState Char(5) Const;
  End-PI;

  // Log error details
  Dsply ('Error inserting customer: ' + %Char(pCustomer.ARNO01));
  Dsply ('SQL Code: ' + %Char(pSQLCode));
  Dsply ('SQL State: ' + pSQLState);
  Dsply ('Customer Legal: ' + %Trim(pCustomer.ARNM01));
  Dsply ('City/State/Zip: ' + %Trim(pCustomer.ARCY01) + ', '
         + %Trim(pCustomer.ARST01) + ' ' + %Trim(pCustomer.ARZP15));

  // Send error notification email
  SendErrorEmail('Error inserting customer: ' + %Char(pCustomer.ARNO01)
                 + ' SQL Code: ' + %Char(pSQLCode)
                 + ' SQL State: ' + pSQLState);

  // Update BECCUSTP status to 'E' for Error
  Exec SQL
    UPDATE BECCUSTP
    SET STATUS = 'E',
        UPDTS = CURRENT_TIMESTAMP
    WHERE GUID = :wGUID;

End-Proc;

//===========================================================================
// Procedure: HandleDuplicateCustomer
// Description: Handle duplicate customer found in ARPMCUS
//===========================================================================
Dcl-Proc HandleDuplicateCustomer;
  Dcl-PI *N;
    pExistingCustNo Packed(6:0) Const;
    pCustomer LikeDS(CustomerDS) Const;
  End-PI;

  // Log duplicate details
  Dsply ('Duplicate customer found: ' + %Char(pExistingCustNo));
  Dsply ('Location: ' + %Trim(pCustomer.ARCY01) + ', '
         + %Trim(pCustomer.ARST01) + ' ' + %Trim(pCustomer.ARZP15));
  Dsply ('Customer Legal: ' + %Trim(pCustomer.ARNM01));

  // Send duplicate notification email
  SendDuplicateEmail(pExistingCustNo: pCustomer);

  // Update BECCUSTP status to 'X' for Exclude (duplicate)
  Exec SQL
    UPDATE BECCUSTP
    SET STATUS = 'X',
        CLIACCTID = :pExistingCustNo,
        UPDTS = CURRENT_TIMESTAMP
    WHERE GUID = :wGUID;

End-Proc;

//===========================================================================
// Procedure: SendErrorEmail
// Description: Send error notification email to IT department
//===========================================================================
Dcl-Proc SendErrorEmail;
  Dcl-PI *N;
    pErrorMsg Char(200) Const;
  End-PI;

  // Local variables
  Dcl-S EmailErrorMessage Char(80);

  // Set email subject and body
  emailList.Subject = 'WRITMCUSX Error - Customer Insert Failed';
  emailList.Note = 'An error occurred in WRITMCUSX program: '
                   + %Trim(pErrorMsg);

  // Email ID for the body
  emailList.bodyID = 1;

  // Send to IT department
  emailList.address(1) = 'ITDept@ecmdi.com';
  emailList.type(1) = 'P';

  // Send the email
  Reset EmailErrorMessage;
  EmailErrorMessage = sendEmail(EmailList);

  // Log that email was sent
  If EmailErrorMessage <> *Blanks;
    Dsply ('Email error: ' + %Trim(EmailErrorMessage));
  Else;
    Dsply ('Error notification email sent');
  EndIf;

End-Proc;

//===========================================================================
// Procedure: SendDuplicateEmail
// Description: Send duplicate customer notification email
//===========================================================================
Dcl-Proc SendDuplicateEmail;
  Dcl-PI *N;
    pExistingCustNo Packed(6:0) Const;
    pCustomer LikeDS(CustomerDS) Const;
  End-PI;

  // Local variables
  Dcl-S EmailErrorMessage Char(80);
  Dcl-S DuplicateMsg Char(500);

  // Build detailed message
  DuplicateMsg = 'Duplicate customer found. ' +
                 'Existing Customer #: ' + %Char(pExistingCustNo) + ' | ' +
                 'Customer Legal: ' + %Trim(pCustomer.ARNM01) + ' | ' +
                 'Location: ' + %Trim(pCustomer.ARCY01) + ', ' +
                 %Trim(pCustomer.ARST01) + ' ' + %Trim(pCustomer.ARZP15);

  // Set email subject and body
  emailList.Subject = 'WRITMCUSX - Duplicate Customer Detected';
  emailList.Note = DuplicateMsg;

  // Email ID for the body
  emailList.bodyID = 1;

  // Send to IT department
  emailList.address(1) = 'ITDept@ecmdi.com';
  emailList.type(1) = 'P';

  // Send the email
  Reset EmailErrorMessage;
  EmailErrorMessage = sendEmail(EmailList);

  // Log that email was sent
  If EmailErrorMessage <> *Blanks;
    Dsply ('Email error: ' + %Trim(EmailErrorMessage));
  Else;
    Dsply ('Duplicate notification email sent');
  EndIf;

End-Proc;

