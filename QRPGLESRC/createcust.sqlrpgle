
        //===========================================================================
        // Program: WRITMCUSX
        // Description: Customer Master Creation from BECCUSTP to AR System
        //
        // Purpose:
        //   This program reads customer data from the BECCUSTP (Bectran Customer)
        //   table and creates corresponding records in the AR (Accounts Receivable)
        //   system. It performs comprehensive validation, duplicate checking, and
        //   creates all necessary related records across multiple AR tables.
        //
        // Input:
        //   - pGUID: 36-character GUID identifying the BECCUSTP record to process
        //
        // Processing Flow:
        //   1. Read BECCUSTP record by GUID
        //   2. Initialize system settings (Intellichief, AvaTax, ECMS, etc.)
        //   3. Get next available customer number from ARR5006
        //   4. Validate sort name for Hydros customers against TBLMTBL4
        //   5. Check for duplicate customers using progressive matching:
        //      - Match on Zip, State, City (case-insensitive)
        //      - Check address lines for actual street address match
        //   6. If no duplicate found, insert records into:
        //      - ARPMCUS  (Customer Master)
        //      - ARPHBAL  (Customer Historical Balance)
        //      - ARPMBAL  (Customer Master Balance)
        //      - ARPMCON  (Customer Contact)
        //      - ARPMFRQ  (Customer Print Frequency)
        //      - OPPMEMA  (Customer Email Address) - if email exists
        //      - ARPTCSA  (Customer Audit Trail)
        //   7. Update BECCUSTP status:
        //      - 'X' = Excluded (duplicate found)
        //      - 'E' = Error (validation failed or insert error)
        //      - Blank = Successfully processed
        //
        // Tables Updated:
        //   - ARPMCUS  - Customer Master (129 fields)
        //   - ARPHBAL  - Customer Historical Balance
        //   - ARPMBAL  - Customer Master Balance
        //   - ARPMCON  - Customer Contact Information
        //   - ARPMFRQ  - Customer Print Frequency (format ARFMFRQ)
        //   - OPPMEMA  - Customer Email Address (format OPFMEMA)
        //   - ARPTCSA  - Customer Audit Trail
        //   - BECCUSTP - Status updates
        //
        // Tables Read:
        //   - BECCUSTP - Bectran Customer data (source)
        //   - TBFMTBL  - System configuration tables
        //   - TBLMTBL4 - Multi-level table file (Hydros validation)
        //
        // External Programs Called:
        //   - ARR5006  - Get Next Customer Number
        //   - sendEmail - Email notification for errors/duplicates
        //
        // Error Handling:
        //   - SQL errors during insert trigger error email to ITDept@ecmdi.com
        //   - Duplicate customers trigger notification email
        //   - Sort name validation failures update BECCUSTP status to 'E'
        //   - All errors are logged via DSPLY statements
        //
        // Notes:
        //   - Uses EXTNAME to automatically match table structures
        //   - All field mapping done using data structures
        //   - Progressive duplicate checking prevents duplicate customer creation
        //   - Hydros customers require sort name validation against TBLMTBL4
        //   - Email records only created if business email exists in BECCUSTP
        //
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

        // Data structure for ARPHBAL record - automatically matches table
        Dcl-DS ArphbalDS ExtName('ARPHBAL') Qualified End-DS;

        // Data structure for ARPMBAL record - automatically matches table
        Dcl-DS ArpmbalDS ExtName('ARPMBAL') Qualified End-DS;

        // Data structure for ARPMCON record - automatically matches table
        Dcl-DS ArpmconDS ExtName('ARPMCON') Qualified End-DS;

        // Data structure for ARPTCSA record - automatically matches table
        Dcl-DS ArptcsaDS ExtName('ARPTCSA') Qualified End-DS;

        // Data structure for ARPMFRQ record - automatically matches table
        Dcl-DS ArpmfrqDS ExtName('ARPMFRQ') Qualified End-DS;

        // Data structure for OPPMEMA record - automatically matches table
        Dcl-DS OppmeraDS ExtName('OPPMEMA') Qualified End-DS;

        // Data structure for TBFMTBL/TBLMTBL4 table lookups
        Dcl-DS TblmtblDS Qualified;
        tbno01 Char(4);
        tbno02 Char(9);
        tbno03 Char(30);
        End-DS;

        // Data structure for passing ARPHBAL data
        Dcl-DS ArphbalDataDS Qualified;
        ARNO16 Packed(3:0);      // Branch Number
        ARNO01 Packed(6:0);      // Customer Number
        ARNO15 Packed(3:0);      // Company Number
        ARNM05 Char(20);         // Customer Sort Name
        ARNO82 Packed(6:0);      // Enterprise Number
        ARID05 Char(3);          // Cust Credit Representative
        ARID01 Char(3);          // Salesman Initials Id
        ARMO15 Packed(2:0);      // Customer Last Statement Month
        ARDY15 Packed(2:0);      // Customer Last Statement Day
        ARCC15 Packed(2:0);      // Customer Last Statement Century
        ARYR15 Packed(2:0);      // Customer Last Statement Year
        ARCD51 Packed(2:0);      // Transaction Code
        ARMO82 Packed(2:0);      // Statement Period Month
        ARCC82 Packed(2:0);      // Statement Period Century
        ARYR82 Packed(2:0);      // Statement Period Year
        End-DS;

        // Data structure for passing ARPMBAL data
        Dcl-DS ArpmbalDataDS Qualified;
        ARNO16 Packed(3:0);      // Branch Number
        ARNO01 Packed(6:0);      // Customer Number
        ARNO15 Packed(3:0);      // Company Number
        ARFL03 Char(1);          // Credit Hold Flag
        ARFL14 Char(1);          // Finance Charge Flag
        ARID01 Char(3);          // Salesman Initials Id
        ARAM01 Packed(9:2);      // Credit Limit Amount
        ARFL76 Char(1);          // Lock Flag for Customer Credit
        ARID08 Char(10);         // Customer Service Representative
        End-DS;

        // Data structure for passing ARPMCON data
        Dcl-DS ArpmconDataDS Qualified;
        ARNO01 Packed(6:0);      // Customer Number
        ARNM02 Char(30);         // Customer Contact Name
        ARDN01 Char(20);         // Customer Contact Title Description
        ARNO12 Packed(3:0);      // Customer Contact Telephone Area Code
        ARNO13 Packed(3:0);      // Customer Contact Telephone Prefix
        ARNO14 Packed(4:0);      // Customer Contact Telephone Number
        ARMO09 Packed(2:0);      // Month Of Last Update
        ARDY09 Packed(2:0);      // Day Of Last Update
        ARCC09 Packed(2:0);      // Century Of Last Update
        ARYR09 Packed(2:0);      // Year Of Last Update
        ARNM03 Char(10);         // User Id Of Maintenance
        ARNOD9 Packed(5:0);      // Customer Contact Control
        End-DS;

        // Data structure for passing ARPMFRQ data
        Dcl-DS ArpmfrqDataDS Qualified;
        ARNO01 Packed(6:0);      // Customer Number
        ARFL52 Char(1);          // Print Invoice Weekly for
        ARFL54 Char(1);          // Print Invoice on Sunday
        End-DS;

        // Data structure for passing OPPMEMA data
        Dcl-DS OppmeraDataDS Qualified;
        OPNO17 Packed(6:0);      // Email Address Control Number
        OPCD14 Char(2);          // Email Address Type
        OPAD01 Char(45);         // Email Address
        OPNM13 Char(30);         // Email Contact Name
        OPNM06 Char(10);         // User Id Of Maintenance
        OPMO04 Packed(2:0);      // Last Maintained Month
        OPDY04 Packed(2:0);      // Last Maintained Day
        OPCC04 Packed(2:0);      // Last Maintained Century
        OPYR04 Packed(2:0);      // Last Maintained Year
        ARNOD9 Packed(5:0);      // Contact Control Number
        End-DS;

        // Variables
        Dcl-S BeccustpFound Ind Inz(*Off);
        Dcl-S RecordExists Ind Inz(*Off);
        Dcl-S RecordsInserted Int(10) Inz(0);
        Dcl-S RecordsSkipped Int(10) Inz(0);
        Dcl-S wGUID Char(36);
        Dcl-S DsplyMsg Char(52);  // Variable for DSPLY messages

        // Sort name validation variables
        Dcl-S Hydros_Prfx Char(6) Inz('HYDROS');
        Dcl-S Hydros_Flg Char(1);
        Dcl-S srtnm_Hydros Varchar(50);
        Dcl-S SvSrtName Char(20);
        Dcl-S tbno01 Char(4);
        Dcl-S tbno02 Char(8);
        Dcl-S tbno03 Char(20);
        Dcl-S SortNameValid Ind Inz(*On);

        // System configuration variables
        Dcl-S icsys Char(1) Inz('N');           // Intellichief system flag
        Dcl-S err01 Char(1) Inz('0');           // Error flag
        Dcl-S wEcms Char(10);                   // ECMS setting
        Dcl-S CertCapture Char(1) Inz('N');     // CertCapture flag
        Dcl-S TAXS_CNTRLS Char(30);             // AvaTax controls
        Dcl-S TAXS_JURIS Char(20);              // AvaTax jurisdiction
        Dcl-S TAXS_JURIS_N Packed(20:0);        // AvaTax jurisdiction numeric
        Dcl-S BNKINFAUTH Char(1);               // Bank info authorization

        // Main Processing
        *InLR = *On;

        // Store passed GUID
        wGUID = pGUID;

        // STEP 1: Read BECCUSTP record by GUID (first process)
        ReadBeccustpByGUID(wGUID);

        // Check if BECCUSTP record was found
        If BeccustpFound;
        Dsply ('BECCUSTP found for GUID:');
        Dsply %Trim(wGUID);
        Dsply ('Acct ID: ' + %Trim(BeccustpDS.ACCTID));
        Dsply ('Cust Legal:');
        DsplyMsg = %Trim(BeccustpDS.CUSTLEGAL);
        Dsply DsplyMsg;
        Dsply ('Cust DBA:');
        DsplyMsg = %Trim(BeccustpDS.CUSTDBA);
        Dsply DsplyMsg;

        // Initialize system settings
        InitializeSystemSettings();

        // STEP 2: Insert the record into ARPMCUS (mapping done inside procedure)
        InsertCustomer(BeccustpDS);

        // STEP 3: Insert into ARPHBAL if customer was inserted
        If RecordsInserted > 0;
            InsertArphbal(ArphbalDataDS);

            // STEP 4: Update/Insert into ARPMBAL
            UpsertArpmbal(ArpmbalDataDS);

            // STEP 5: Insert into ARPMCON
            InsertArpmcon(ArpmconDataDS);

            // STEP 6: Insert into ARPMFRQ
            InsertArpmfrq(ArpmfrqDataDS);

            // STEP 7: Insert into OPPMEMA (if email exists)
            If %Trim(BeccustpDS.BUSEMAIL) <> *Blanks;
            InsertOppmema(OppmeraDataDS);
            EndIf;

            // STEP 8: Write audit record to ARPTCSA
            WriteAuditRecord(ArpmbalDataDS);
        EndIf;

        // Display summary
        Dsply ('Records inserted: ' + %Char(RecordsInserted));
        Dsply ('Records skipped: ' + %Char(RecordsSkipped));
        Else;
        Dsply ('No BECCUSTP found for GUID:');
        Dsply %Trim(wGUID);
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
        Dcl-S FoundRecord Int(5);
        Dcl-S newCustomerNumber Packed(6:0) Inz(0);
        Dcl-S TypeField Char(2);
        Dcl-S ValidField Char(1);

        // Clear the global CustomerDS
        Clear CustomerDS;

        // Get next customer number from ARR5006
        newCustomerNumber = 0;
        TypeField = *Blanks;
        ValidField = *Blanks;
        getNextCustomerNumber(newCustomerNumber: TypeField: ValidField);

        CustomerDS.ARNO01 = newCustomerNumber;  // Customer Number from ARR5006
        CustomerDS.ARNM01 = %Upper(%Trim(pBeccustp.CUSTLEGAL));  // Customer Legal Name
        CustomerDS.ARNM03 = %Upper(%Trim(pBeccustp.CUSTCRTBY));  // User ID
        CustomerDS.ARNM05 = %Upper(%Trim(pBeccustp.CUSTDBA));    // DBA/Sort Name

        // Map mailing address
        CustomerDS.ARAD01 = %Upper(%Trim(pBeccustp.ADDR1));      // Mailing Address 1
        CustomerDS.ARAD02 = %Upper(%Trim(pBeccustp.ADDR2));      // Mailing Address 2
        CustomerDS.ARCY01 = %Upper(%Trim(pBeccustp.CITY));       // Mailing City
        CustomerDS.ARST01 = %Upper(%Trim(pBeccustp.STATE));      // Mailing State
        CustomerDS.ARZP15 = %Trim(pBeccustp.ZIPCODE);    // Mailing Zip

        // Populate ArphbalDataDS for later use
        Clear ArphbalDataDS;
        ArphbalDataDS.ARNO01 = newCustomerNumber;                // Customer Number
        ArphbalDataDS.ARNM05 = CustomerDS.ARNM05;                // Customer Sort Name
        ArphbalDataDS.ARNO16 = 0;                                // Branch Number (default)
        ArphbalDataDS.ARNO15 = 0;                                // Company Number (default)
        ArphbalDataDS.ARNO82 = 0;                                // Enterprise Number (default)

        // Map from BECCUSTP if available, otherwise default to blanks
        If %Trim(pBeccustp.CUSTCRTBY) <> *Blanks;
            ArphbalDataDS.ARID05 =
            %Subst(%Upper(%Trim(pBeccustp.CUSTCRTBY)):1:3);  // Credit Rep
        Else;
            ArphbalDataDS.ARID05 = *Blanks;
        EndIf;

        ArphbalDataDS.ARID01 = *Blanks;                          // Salesman Id (default)

        // Set statement date fields to current date
        ArphbalDataDS.ARMO15 = %Dec(%Subst(%Char(%Date()):6:2):2:0);  // Statement Month
        ArphbalDataDS.ARDY15 = %Dec(%Subst(%Char(%Date()):9:2):2:0);  // Statement Day
        ArphbalDataDS.ARCC15 = %Dec(%Subst(%Char(%Date()):1:2):2:0);  // Statement Century
        ArphbalDataDS.ARYR15 = %Dec(%Subst(%Char(%Date()):3:2):2:0);  // Statement Year

        // Set transaction code and statement period
        ArphbalDataDS.ARCD51 = 11;                               // Transaction Code (11 = new custo
        ArphbalDataDS.ARMO82 = %Dec(%Subst(%Char(%Date()):6:2):2:0);  // Period Month
        ArphbalDataDS.ARCC82 = %Dec(%Subst(%Char(%Date()):1:2):2:0);  // Period Century
        ArphbalDataDS.ARYR82 = %Dec(%Subst(%Char(%Date()):3:2):2:0);  // Period Year

        // Populate ArpmbalDataDS for later use
        Clear ArpmbalDataDS;
        ArpmbalDataDS.ARNO16 = 0;                                // Branch Number (default)
        ArpmbalDataDS.ARNO01 = newCustomerNumber;                // Customer Number
        ArpmbalDataDS.ARNO15 = 0;                                // Company Number (default)
        ArpmbalDataDS.ARFL03 = *Blanks;                          // Credit Hold Flag (default)
        ArpmbalDataDS.ARFL14 = *Blanks;                          // Finance Charge Flag (default)
        ArpmbalDataDS.ARID01 = *Blanks;                          // Salesman Initials (default)
        ArpmbalDataDS.ARAM01 = 0;                                // Credit Limit Amount (default)
        ArpmbalDataDS.ARFL76 = 'N';                              // Lock Flag (set to 'N')
        ArpmbalDataDS.ARID08 = *Blanks;                          // Customer Service Rep (default)

        // Populate ArpmconDataDS for later use
        Clear ArpmconDataDS;
        ArpmconDataDS.ARNO01 = newCustomerNumber;                // Customer Number
        ArpmconDataDS.ARNM02 = *Blanks;                          // Customer Contact Name (default)
        ArpmconDataDS.ARDN01 = *Blanks;                          // Customer Contact Title (default)
        ArpmconDataDS.ARNO12 = 0;                                // Telephone Area Code (default)
        ArpmconDataDS.ARNO13 = 0;                                // Telephone Prefix (default)
        ArpmconDataDS.ARNO14 = 0;                                // Telephone Number (default)

        // Set current date for last update fields
        ArpmconDataDS.ARMO09 = %Dec(%Subst(%Char(%Date()):5:2):2:0);  // Month
        ArpmconDataDS.ARDY09 = %Dec(%Subst(%Char(%Date()):7:2):2:0);  // Day
        ArpmconDataDS.ARCC09 = %Dec(%Subst(%Char(%Date()):1:2):2:0);  // Century
        ArpmconDataDS.ARYR09 = %Dec(%Subst(%Char(%Date()):3:2):2:0);  // Year

        ArpmconDataDS.ARNM03 = %Upper(%Trim(pBeccustp.CUSTCRTBY)); // User Id
        ArpmconDataDS.ARNOD9 = 0;                                // Contact Control (default)

        // Populate ArpmfrqDataDS for later use
        Clear ArpmfrqDataDS;
        ArpmfrqDataDS.ARNO01 = newCustomerNumber;                // Customer Number
        ArpmfrqDataDS.ARFL52 = *Blanks;                          // Print Invoice Weekly (default)
        ArpmfrqDataDS.ARFL54 = *Blanks;                          // Print Invoice on Sunday (default

        // Populate OppmeraDataDS for later use
        Clear OppmeraDataDS;
        OppmeraDataDS.OPNO17 = newCustomerNumber;                // Email Address Control Number
        OppmeraDataDS.OPCD14 = 'BU';                             // Email Address Type (BU = Busines
        OppmeraDataDS.OPAD01 = %Trim(pBeccustp.BUSEMAIL);        // Email Address (Business Email)

        // Use contact name from BECCUSTP if available
        If %Trim(pBeccustp.CNTFNAME) <>
         *Blanks Or %Trim(pBeccustp.CNTLNAME) <> *Blanks;
            OppmeraDataDS.OPNM13 = %Trim(pBeccustp.CNTFNAME) + ' ' +
            %Trim(pBeccustp.CNTLNAME);
        Else;
            OppmeraDataDS.OPNM13 = *Blanks;
        EndIf;

        OppmeraDataDS.OPNM06 = %Upper(%Trim(pBeccustp.CUSTCRTBY)); // User Id

        // Set current date for last maintained fields
        OppmeraDataDS.OPMO04 = %Dec(%Subst(%Char(%Date()):6:2):2:0);  // Month
        OppmeraDataDS.OPDY04 = %Dec(%Subst(%Char(%Date()):9:2):2:0);  // Day
        OppmeraDataDS.OPCC04 = %Dec(%Subst(%Char(%Date()):1:2):2:0);  // Century
        OppmeraDataDS.OPYR04 = %Dec(%Subst(%Char(%Date()):3:2):2:0);  // Year

        OppmeraDataDS.ARNOD9 = 0;                                // Contact Control Number (default)

        // Validate sort name for Hydros customers
        ValidateSortName(CustomerDS.ARNM05);

        // If sort name validation failed, skip insert
        If Not SortNameValid;
            RecordsSkipped += 1;
            Dsply ('Sort name validation failed: ' + %Trim(CustomerDS.ARNM05));
            Return;
        EndIf;

        // Progressive duplicate check:
        // 1. Match on Zip, State, City (case-insensitive)
        // 2. Then check address lines (skip line 1 if it's business name)
        // 3. Check address 2 and 3 for actual street address match
        Exec SQL
            SELECT ARNO01
            INTO :ExistingCustNo :FoundRecord
            FROM ARPMCUS
            WHERE UPPER(ARZP15) = UPPER(:CustomerDS.ARZP15)
            AND UPPER(ARST01) = UPPER(:CustomerDS.ARST01)
            AND UPPER(ARCY01) = UPPER(:CustomerDS.ARCY01)
            AND (
                UPPER(ARAD02) = UPPER(:CustomerDS.ARAD02)
                OR UPPER(ARAD03) = UPPER(:CustomerDS.ARAD03)
            )
            FETCH FIRST 1 ROW ONLY;

        If FoundRecord < 0;
            // No match found, insert new record
            Exec SQL
            INSERT INTO ARPMCUS
            VALUES (:CustomerDS);

            If SQLCODE = 0;
            RecordsInserted += 1;
            Dsply ('Record inserted: ' + %Char(CustomerDS.ARNO01));
            Else;
            // Call error handling procedure
            HandleInsertError(CustomerDS: SQLCODE: SQLSTATE);
            EndIf;
        Else;
            // Duplicate found, skip insert
            RecordExists = *On;
            RecordsSkipped += 1;
            // Call duplicate handling procedure
            HandleDuplicateCustomer(ExistingCustNo: CustomerDS);
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
        Dsply ('Customer Legal:');
        Dsply %Trim(pCustomer.ARNM01);
        Dsply ('City/State/Zip:');
        Dsply (%Trim(pCustomer.ARCY01) + ', ' + %Trim(pCustomer.ARST01)
                + ' ' + %Trim(pCustomer.ARZP15));

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
        Dsply ('Location:');
        Dsply (%Trim(pCustomer.ARCY01) + ', ' + %Trim(pCustomer.ARST01)
                + ' ' + %Trim(pCustomer.ARZP15));
        Dsply ('Customer Legal:');
        Dsply %Trim(pCustomer.ARNM01);

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
            Dsply ('Email error:');
            DsplyMsg = %Trim(EmailErrorMessage);
            Dsply DsplyMsg;
        Else;
            Dsply ('Error notification email sent');
        EndIf;

        End-Proc;

        //===========================================================================
        // Procedure: InsertArphbal
        // Description: Insert record into ARPHBAL table with data from ArphbalDataDS
        //===========================================================================
        Dcl-Proc InsertArphbal;
        Dcl-PI *N;
            pArphbalData LikeDS(ArphbalDataDS) Const;
        End-PI;

        // Local data structure for ARPHBAL
        Dcl-DS LocalArphbalDS LikeDS(ArphbalDS);

        // Clear the data structure
        Clear LocalArphbalDS;

        // Map fields from ArphbalDataDS to ARPHBAL
        LocalArphbalDS.ARNO16 = pArphbalData.ARNO16;   // Branch Number
        LocalArphbalDS.ARNO01 = pArphbalData.ARNO01;   // Customer Number
        LocalArphbalDS.ARNO15 = pArphbalData.ARNO15;   // Company Number
        LocalArphbalDS.ARNM05 = pArphbalData.ARNM05;   // Customer Sort Name
        LocalArphbalDS.ARNO82 = pArphbalData.ARNO82;   // Enterprise Number
        LocalArphbalDS.ARID05 = pArphbalData.ARID05;   // Cust Credit Representative
        LocalArphbalDS.ARID01 = pArphbalData.ARID01;   // Salesman Initials Id
        LocalArphbalDS.ARMO15 = pArphbalData.ARMO15;   // Customer Last Statement Month
        LocalArphbalDS.ARDY15 = pArphbalData.ARDY15;   // Customer Last Statement Day
        LocalArphbalDS.ARCC15 = pArphbalData.ARCC15;   // Customer Last Statement Century
        LocalArphbalDS.ARYR15 = pArphbalData.ARYR15;   // Customer Last Statement Year
        LocalArphbalDS.ARCD51 = pArphbalData.ARCD51;   // Transaction Code
        LocalArphbalDS.ARMO82 = pArphbalData.ARMO82;   // Statement Period Month
        LocalArphbalDS.ARCC82 = pArphbalData.ARCC82;   // Statement Period Century
        LocalArphbalDS.ARYR82 = pArphbalData.ARYR82;   // Statement Period Year

        // Insert into ARPHBAL
        Exec SQL
            INSERT INTO ARPHBAL
            VALUES (:LocalArphbalDS);

        If SQLCODE = 0;
            Dsply ('ARPHBAL inserted: ' + %Char(pArphbalData.ARNO01));
        Else;
            Dsply ('Error inserting ARPHBAL: ' + %Char(SQLCODE));
            Dsply ('SQL State: ' + SQLSTATE);
        EndIf;

        End-Proc;

        //===========================================================================
        // Procedure: UpsertArpmbal
        // Description: Update or Insert record into ARPMBAL table
        //===========================================================================
        Dcl-Proc UpsertArpmbal;
        Dcl-PI *N;
            pArpmbalData LikeDS(ArpmbalDataDS) Const;
        End-PI;

        // Local data structure for ARPMBAL
        Dcl-DS LocalArpmbalDS LikeDS(ArpmbalDS);
        Dcl-S RecordExists Int(5);

        // Check if record already exists
        Exec SQL
            SELECT 1
            INTO :RecordExists
            FROM ARPMBAL
            WHERE ARNO16 = :pArpmbalData.ARNO16
            AND ARNO01 = :pArpmbalData.ARNO01
            AND ARNO15 = :pArpmbalData.ARNO15;

        If SQLCODE = 0;
            // Record exists, perform UPDATE
            Exec SQL
            UPDATE ARPMBAL
            SET ARFL03 = :pArpmbalData.ARFL03,
                ARFL14 = :pArpmbalData.ARFL14,
                ARID01 = :pArpmbalData.ARID01,
                ARAM01 = :pArpmbalData.ARAM01,
                ARFL76 = :pArpmbalData.ARFL76,
                ARID08 = :pArpmbalData.ARID08
            WHERE ARNO16 = :pArpmbalData.ARNO16
                AND ARNO01 = :pArpmbalData.ARNO01
                AND ARNO15 = :pArpmbalData.ARNO15;

            If SQLCODE = 0;
            Dsply ('ARPMBAL updated: ' + %Char(pArpmbalData.ARNO01));
            Else;
            Dsply ('Error updating ARPMBAL: ' + %Char(SQLCODE));
            Dsply ('SQL State: ' + SQLSTATE);
            EndIf;
        Else;
            // Record does not exist, perform INSERT
            Clear LocalArpmbalDS;

            // Map fields from ArpmbalDataDS to ARPMBAL
            LocalArpmbalDS.ARNO16 = pArpmbalData.ARNO16;   // Branch Number
            LocalArpmbalDS.ARNO01 = pArpmbalData.ARNO01;   // Customer Number
            LocalArpmbalDS.ARNO15 = pArpmbalData.ARNO15;   // Company Number
            LocalArpmbalDS.ARFL03 = pArpmbalData.ARFL03;   // Credit Hold Flag
            LocalArpmbalDS.ARFL14 = pArpmbalData.ARFL14;   // Finance Charge Flag
            LocalArpmbalDS.ARID01 = pArpmbalData.ARID01;   // Salesman Initials Id
            LocalArpmbalDS.ARAM01 = pArpmbalData.ARAM01;   // Credit Limit Amount
            LocalArpmbalDS.ARFL76 = pArpmbalData.ARFL76;   // Lock Flag
            LocalArpmbalDS.ARID08 = pArpmbalData.ARID08;   // Customer Service Rep

            Exec SQL
            INSERT INTO ARPMBAL
            VALUES (:LocalArpmbalDS);

            If SQLCODE = 0;
            Dsply ('ARPMBAL inserted: ' + %Char(pArpmbalData.ARNO01));
            Else;
            Dsply ('Error inserting ARPMBAL: ' + %Char(SQLCODE));
            Dsply ('SQL State: ' + SQLSTATE);
            EndIf;
        EndIf;
        End-Proc;

        //===========================================================================
        // Procedure: InsertArpmcon
        // Description: Insert record into ARPMCON table
        //===========================================================================
        Dcl-Proc InsertArpmcon;
        Dcl-PI *N;
            pArpmconData LikeDS(ArpmconDataDS) Const;
        End-PI;

        // Local data structure for ARPMCON
        Dcl-DS LocalArpmconDS LikeDS(ArpmconDS);

        // Clear the data structure
        Clear LocalArpmconDS;

        // Map fields from ArpmconDataDS to ARPMCON
        LocalArpmconDS.ARNO01 = pArpmconData.ARNO01;   // Customer Number
        LocalArpmconDS.ARNM02 = pArpmconData.ARNM02;   // Customer Contact Name
        LocalArpmconDS.ARDN01 = pArpmconData.ARDN01;   // Customer Contact Title
        LocalArpmconDS.ARNO12 = pArpmconData.ARNO12;   // Telephone Area Code
        LocalArpmconDS.ARNO13 = pArpmconData.ARNO13;   // Telephone Prefix
        LocalArpmconDS.ARNO14 = pArpmconData.ARNO14;   // Telephone Number
        LocalArpmconDS.ARMO09 = pArpmconData.ARMO09;   // Month Of Last Update
        LocalArpmconDS.ARDY09 = pArpmconData.ARDY09;   // Day Of Last Update
        LocalArpmconDS.ARCC09 = pArpmconData.ARCC09;   // Century Of Last Update
        LocalArpmconDS.ARYR09 = pArpmconData.ARYR09;   // Year Of Last Update
        LocalArpmconDS.ARNM03 = pArpmconData.ARNM03;   // User Id Of Maintenance
        LocalArpmconDS.ARNOD9 = pArpmconData.ARNOD9;   // Customer Contact Control

        // Insert into ARPMCON
        Exec SQL
            INSERT INTO ARPMCON
            VALUES (:LocalArpmconDS);

        If SQLCODE = 0;
            Dsply ('ARPMCON inserted: ' + %Char(pArpmconData.ARNO01));
        Else;
            Dsply ('Error inserting ARPMCON: ' + %Char(SQLCODE));
            Dsply ('SQL State: ' + SQLSTATE);
        EndIf;
        End-Proc;

        //===========================================================================
        // Procedure: InsertArpmfrq
        // Description: Insert record into ARPMFRQ table (format ARFMFRQ)
        //===========================================================================
        Dcl-Proc InsertArpmfrq;
        Dcl-PI *N;
            pArpmfrqData LikeDS(ArpmfrqDataDS) Const;
        End-PI;

        // Local data structure for ARPMFRQ
        Dcl-DS LocalArpmfrqDS LikeDS(ArpmfrqDS);

        // Clear the data structure
        Clear LocalArpmfrqDS;

        // Map fields from ArpmfrqDataDS to ARPMFRQ
        LocalArpmfrqDS.ARNO01 = pArpmfrqData.ARNO01;   // Customer Number
        LocalArpmfrqDS.ARFL52 = pArpmfrqData.ARFL52;   // Print Invoice Weekly for
        LocalArpmfrqDS.ARFL54 = pArpmfrqData.ARFL54;   // Print Invoice on Sunday

        // Insert into ARPMFRQ
        Exec SQL
            INSERT INTO ARPMFRQ
            VALUES (:LocalArpmfrqDS);

        If SQLCODE = 0;
            Dsply ('ARPMFRQ inserted: ' + %Char(pArpmfrqData.ARNO01));
        Else;
            Dsply ('Error inserting ARPMFRQ: ' + %Char(SQLCODE));
            Dsply ('SQL State: ' + SQLSTATE);
        EndIf;
        End-Proc;

        //===========================================================================
        // Procedure: InsertOppmema
        // Description: Insert record into OPPMEMA table (format OPFMEMA)
        //===========================================================================
        Dcl-Proc InsertOppmema;
        Dcl-PI *N;
            pOppmeraData LikeDS(OppmeraDataDS) Const;
        End-PI;

        // Local data structure for OPPMEMA
        Dcl-DS LocalOppmeraDS LikeDS(OppmeraDS);

        // Clear the data structure
        Clear LocalOppmeraDS;

        // Map fields from OppmeraDataDS to OPPMEMA
        LocalOppmeraDS.OPNO17 = pOppmeraData.OPNO17;   // Email Address Control Number
        LocalOppmeraDS.OPCD14 = pOppmeraData.OPCD14;   // Email Address Type
        LocalOppmeraDS.OPAD01 = pOppmeraData.OPAD01;   // Email Address
        LocalOppmeraDS.OPNM13 = pOppmeraData.OPNM13;   // Email Contact Name
        LocalOppmeraDS.OPNM06 = pOppmeraData.OPNM06;   // User Id Of Maintenance
        LocalOppmeraDS.OPMO04 = pOppmeraData.OPMO04;   // Last Maintained Month
        LocalOppmeraDS.OPDY04 = pOppmeraData.OPDY04;   // Last Maintained Day
        LocalOppmeraDS.OPCC04 = pOppmeraData.OPCC04;   // Last Maintained Century
        LocalOppmeraDS.OPYR04 = pOppmeraData.OPYR04;   // Last Maintained Year
        LocalOppmeraDS.ARNOD9 = pOppmeraData.ARNOD9;   // Contact Control Number

        // Insert into OPPMEMA
        Exec SQL
            INSERT INTO OPPMEMA
            VALUES (:LocalOppmeraDS);

        If SQLCODE = 0;
            Dsply ('OPPMEMA inserted: ' + %Char(pOppmeraData.OPNO17));
        Else;
            Dsply ('Error inserting OPPMEMA: ' + %Char(SQLCODE));
            Dsply ('SQL State: ' + SQLSTATE);
        EndIf;
        End-Proc;

        //===========================================================================
        // Procedure: WriteAuditRecord
        // Description: Write audit record to ARPTCSA table for new customer
        //===========================================================================
        Dcl-Proc WriteAuditRecord;
        Dcl-PI *N;
            pArpmbalData LikeDS(ArpmbalDataDS) Const;
        End-PI;

        // Local data structure for ARPTCSA
        Dcl-DS LocalArptcsaDS LikeDS(ArptcsaDS);
        Dcl-S CurrentTime Time;
        Dcl-S CurrentDate Date;

        // Clear the data structure
        Clear LocalArptcsaDS;

        // Get current date and time
        CurrentDate = %Date();
        CurrentTime = %Time();

        // Populate audit record fields
        LocalArptcsaDS.ARNO01 = pArpmbalData.ARNO01;   // Customer Number
        LocalArptcsaDS.ARNO16 = pArpmbalData.ARNO16;   // Branch Number
        LocalArptcsaDS.ARNO15 = pArpmbalData.ARNO15;   // Company Number

        // Audit fields
        LocalArptcsaDS.ARCD23 = 'A';                   // 'A' = After (new customer add)
        LocalArptcsaDS.ARNM03 = %Trim(wGUID);          // User/GUID
        // LocalArptcsaDS.ARTM01 = CurrentTime;           // Update Time - field type mismatch

        // Date fields
        LocalArptcsaDS.ARMO09 = %Dec(%Subst(%Char(CurrentDate):6:2):2:0);  // Month
        LocalArptcsaDS.ARDY09 = %Dec(%Subst(%Char(CurrentDate):9:2):2:0);  // Day
        LocalArptcsaDS.ARCC09 = %Dec(%Subst(%Char(CurrentDate):1:2):2:0);  // Century
        LocalArptcsaDS.ARYR09 = %Dec(%Subst(%Char(CurrentDate):3:2):2:0);  // Year

        // Balance fields from ARPMBAL - commented out if not in ARPTCSA
        // LocalArptcsaDS.CAAM01 = pArpmbalData.ARAM01;   // Credit Limit
        // LocalArptcsaDS.CAFL03 = pArpmbalData.ARFL03;   // Credit Hold Flag
        // LocalArptcsaDS.CAFL76 = pArpmbalData.ARFL76;   // Lock Flag
        // LocalArptcsaDS.CAID05 = pArpmbalData.ARID01;   // Salesman ID

        // Insert into ARPTCSA
        Exec SQL
            INSERT INTO ARPTCSA
            VALUES (:LocalArptcsaDS);

        If SQLCODE = 0;
            Dsply ('ARPTCSA audit written: ' + %Char(pArpmbalData.ARNO01));
        Else;
            Dsply ('Error writing ARPTCSA audit: ' + %Char(SQLCODE));
            Dsply ('SQL State: ' + SQLSTATE);
        EndIf;

        End-Proc;

        //===========================================================================
        // Procedure: InitializeSystemSettings
        // Description: Initialize system settings from table files (TBFMTBL/TBLMTBL4)
        //              Based on initialization logic from ARR5015
        //===========================================================================
        Dcl-Proc InitializeSystemSettings;
        Dcl-S RecordFound Int(5);


        // Check whether Intellichief is used
        err01 = '0';
        Clear TblmtblDS;
        TblmtblDS.tbno01 = 'IMAG';
        TblmtblDS.tbno02 = 'ICSYS';

        Exec SQL
            SELECT tbno03 INTO :TblmtblDS.tbno03 :RecordFound
            FROM TBFMTBL
            WHERE tbno01 = :TblmtblDS.tbno01
            AND tbno02 = :TblmtblDS.tbno02
            FETCH FIRST 1 ROW ONLY;

        If RecordFound < 0;
            icsys = 'N';
        Else;
            icsys = %Subst(TblmtblDS.tbno03:1:1);
        EndIf;

        // Note: OPC9805 call and webfaced check omitted - not applicable for batch

        // Retrieve tax settings for AvaTax interface - address controls
        Clear TblmtblDS;
        TblmtblDS.tbno01 = 'TAXS';
        TblmtblDS.tbno02 = 'CONTROLS';

        Exec SQL
            SELECT tbno03 INTO :TblmtblDS.tbno03 :RecordFound
            FROM TBFMTBL
            WHERE tbno01 = :TblmtblDS.tbno01
            AND tbno02 = :TblmtblDS.tbno02
            FETCH FIRST 1 ROW ONLY;

        If RecordFound < 0;
            Clear TAXS_CNTRLS;
        Else;
            TAXS_CNTRLS = TblmtblDS.tbno03;
        EndIf;

        // Retrieve tax settings for AvaTax interface - default tax jurisdiction
        Clear TblmtblDS;
        TblmtblDS.tbno01 = 'TAXS';
        TblmtblDS.tbno02 = 'JURIS';

        Exec SQL
            SELECT tbno03 INTO :TblmtblDS.tbno03 :RecordFound
            FROM TBFMTBL
            WHERE tbno01 = :TblmtblDS.tbno01
            AND tbno02 = :TblmtblDS.tbno02
            FETCH FIRST 1 ROW ONLY;

        If RecordFound < 0;
            Clear TAXS_JURIS_N;
        Else;
            TAXS_JURIS = TblmtblDS.tbno03;
            TAXS_JURIS_N = %Dec(TAXS_JURIS:20:0);
        EndIf;

        // Retrieve setting for ECMS
        Clear wEcms;
        Clear TblmtblDS;
        TblmtblDS.tbno01 = 'TAXS';
        TblmtblDS.tbno02 = 'ECMS';

        Exec SQL
            SELECT tbno03 INTO :TblmtblDS.tbno03 :RecordFound
            FROM TBFMTBL
            WHERE tbno01 = :TblmtblDS.tbno01
            AND tbno02 = :TblmtblDS.tbno02
            FETCH FIRST 1 ROW ONLY;

        If RecordFound >= 0;
            wEcms = %Trim(TblmtblDS.tbno03);
        EndIf;

        // Check if using CertCapture
        // Note: OPR0400 call omitted - would need to be implemented separately
        CertCapture = 'N';

        // Retrieve user enrollment for bank information
        // Note: OPR8220 call omitted - would need to be implemented separately
        Clear BNKINFAUTH;

        Dsply ('System settings initialized');
        Dsply ('Intellichief: ' + icsys);
        Dsply ('ECMS: ' + %Trim(wEcms));

        End-Proc;

        //===========================================================================
        // Procedure: ValidateSortName
        // Description: Validate sort name for Hydros customers against TBLMTBL4
        //===========================================================================
        Dcl-Proc ValidateSortName;
        Dcl-PI *N;
            pSortName Char(20) Const;
        End-PI;

        // Reset validation flag to valid
        SortNameValid = *On;

        // Initialize variables
        Hydros_Flg = 'N';
        Clear tbno03;
        tbno01 = 'CLTY';
        tbno02 = 'SORTNAME';

        // Check if sort name has Hydros prefix
        If %Subst(pSortName:1:6) = Hydros_Prfx;
            // Set up LIKE parameter to check table file for Hydros customer
            srtnm_Hydros = %TrimR(pSortName) + '%';

            // Check to see if Sort Name is set up in table file
            Exec SQL
            SELECT 'Y', tbno03 INTO :Hydros_Flg, :tbno03
            FROM TBLMTBL4
            WHERE tbno01 = :tbno01
                AND tbno02 = :tbno02
                AND tbno03 LIKE :srtnm_Hydros
            WITH NC;

            // If the sortname has a 'HYDROS' prefix and not found in TB, set error
            If Hydros_Flg <> 'Y';
            SortNameValid = *Off;
            Dsply ('Hydros name not in TBLMTBL4: ' + %Trim(pSortName));

            // Update BECCUSTP status to 'E' for Error
            Exec SQL
                UPDATE BECCUSTP
                SET STATUS = 'E',
                    UPDTS = CURRENT_TIMESTAMP
                WHERE GUID = :wGUID;
            Else;
            // Valid Hydros customer found
            Hydros_Flg = 'Y';
            SvSrtName = pSortName;
            Dsply ('Valid Hydros name found: ' + %Trim(pSortName));
            EndIf;
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
            Dsply ('Email error:');
            DsplyMsg = %Trim(EmailErrorMessage);
            Dsply DsplyMsg;
        Else;
            Dsply ('Duplicate notification email sent');
        EndIf;

        End-Proc;



