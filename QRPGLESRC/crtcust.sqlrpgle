
        //===========================================================================
        // Program: CRTCUST
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
        //      - 'S' = Successfully processed
        //      - Blank = Not processed
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
        //   - SQL errors during insert trigger error email to ARDept@ecmdi.com
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
$A      //   - House account sales id assignment: Only happens if the customer that's
$A      //   - copied has a sales id that's linked to a closed branch. Use FoundBranch
$A      //   - the customer's branch to find the House sales id.
        //
        //===========================================================================
        // TASK       DATE   ID  DESCRIPTION                                        *
        // ---------- ------ --- ---------------------------------------------------*
$A      // 4063       072226 TAK Insert price level record into ARPCSCMT
        // -------------------------------------------------------------------------*


        Ctl-Opt NoMain;
        Ctl-Opt Option(*SrcStmt:*NoDebugIo);
        Ctl-Opt BndDir('ECBIND');

        // Copy member for procedure prototype
        /COPY qcpysrc,CRTCUST_CP

        // Copy member for sendEmail
        /COPY qcpysrc,SDEMAIL_CP

        // Copy member for address validation
        /COPY qcpysrc,PERZIP_CP

$A      // Copy member for get house account
$A      /COPY qcpysrc,GETHSAC_CP

        // Prototype for ARR5006 - Get Next Customer Number
        Dcl-PR getNextCustomerNumber ExtPgm('ARR5006');
        pCustomerNumber Packed(6:0);
        pType Char(2);
        pValid Char(1);
        End-PR;

        // Data structure for BECCUSTP record - automatically matches table
        Dcl-DS BeccustpDS ExtName('BECCUSTP') Qualified End-DS;

        // Data structure for BECCREDP record - automatically matches table
        Dcl-DS BeccredpDS ExtName('BECCREDP') Qualified End-DS;

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

        // Data structure for ARPMCUA record - automatically matches table
        Dcl-DS ArpmcuaDS ExtName('ARPMCUA') Qualified End-DS;

$A      // Data structure for ARPCSCMT record - automatically matches table
$A      Dcl-DS ArpcscmtDS ExtName('ARPCSCMT') Qualified End-DS;

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
        ARID05 Char(3);          // Cust Credit Representative
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
        ARFL55 Char(1);          // Print Invoice on Monday
        ARFL56 Char(1);          // Print Invoice on Tuesday
        ARFL57 Char(1);          // Print Invoice on Wednesday
        ARFL58 Char(1);          // Print Invoice on Thursday
        ARFL59 Char(1);          // Print Invoice on Friday
        ARFL60 Char(1);          // Print Invoice on Saturday
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

        // Data structure for passing ARPMCUA data
        Dcl-DS ArpmcuaDataDS Qualified;
        ARNO01 Packed(6:0);      // Customer Number
        OPCD34 Char(1);          // Add-on Record Status
        OPNM26 Char(10);         // Job Name
        OPID11 Char(10);         // Job User Name
        OPNO68 Packed(6:0);      // Job Number
        OPCD31 Char(1);          // Add-on Definition Type
        OPNM25 Char(10);         // Add-on Field Name
        OPTX20 Char(70);         // Add-on Field Value
        OPTX21 Char(45);         // Add-on Field Value Description
        OPFL22 Char(1);          // Add-on Primary Value
        OPNM06 Char(10);         // User ID Of Maintenance
        OPMO04 Packed(2:0);      // Last Maintained Month
        OPDY04 Packed(2:0);      // Last Maintained Day
        OPCC04 Packed(2:0);      // Last Maintained Century
        OPYR04 Packed(2:0);      // Last Maintained Year
        End-DS;

$A      // Data structure for passing ARPCSCMT data
$A      Dcl-DS ArpcscmtDataDS Qualified;
$A      ARNO01 Packed(6:0);      // Customer Number
$A      COMMNT Char(60);         // Comment
$A      PRCLV1 Char(1);          // Equipment price level
$A      PRCLV2 Char(1);          // Supplies price level
$A      PRCLV3 Char(1);          // Parts price level
$A      PRCLV4 Char(1);          // Tools price level
$A      PRCLV5 Char(1);          // Commodities price level
$A      EPDSLS Char(3);          // Equipment sales id
$A      CHGFRT Char(1);          // Charge Freight
$A      GCCUST Packed(9:0);      // Goodcare Cust#
$A      CNTPRO Packed(8:0);      // Honeywell Pro#
$A      GMDY01 Packed(2:0);      // Goodman NDA Day
$A      GMCC01 Packed(2:0);      // Goodman NDA Century
$A      GMYR01 Packed(2:0);      // Goodman NDA Year
$A      GMMO01 Packed(2:0);      // Goodman NDA Month
$A      GMNDAS Packed(7:0);      // Goodman NDA LY Sales
$A      ECMO01 Packed(2:0);      // Last review month
$A      ECDY01 Packed(2:0);      // Last review day
$A      ECCC01 Packed(2:0);      // Last review century
$A      ECYR01 Packed(2:0);      // Last review Year
$A      CMCD07 Char(1);          // Send COD to BillTrust
$A      FRAUDRVW Char(1);        // Fraud Review Y/N
$A      REVIEWUSER Char(10);     // Reviewed by user
$A      CMFL19     Char(1);      // Print Cr/Dr inv memos only
$A      End-DS;

        // Variables
        Dcl-S BeccustpFound Ind Inz(*Off);
        Dcl-S BeccredpFound Ind Inz(*Off);
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

        //===========================================================================
        //              EXPORTED PROCEDURE IMPLEMENTATION
        //===========================================================================

        Dcl-Proc CreateCustomer Export;
        Dcl-PI *N;
          pGUID Char(36) Const;
        End-PI;

        // Store passed GUID
        wGUID = pGUID;

        // STEP 1: Read BECCUSTP record by GUID (first process)
        ReadBeccustpByGUID(wGUID);

        // STEP 1a: Read BECCREDP record by GUID
        ReadBeccredpByGUID(wGUID);

        // Initialize system settings
        InitializeSystemSettings();

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

        // STEP 2: Insert the record into ARPMCUS (mapping done inside procedure)
        InsertCustomer(BeccustpDS);

        // STEP 3: Insert into ARPHBAL if customer was inserted
        If RecordsInserted > 0;
            InsertArphbal(ArphbalDataDS);

            // STEP 4: Update/Insert into ARPMBAL
            InsertArpmbal(ArpmbalDataDS);

            // STEP 5: Insert into ARPMCON
            InsertArpmcon(ArpmconDataDS);

            // STEP 6: Insert into ARPMFRQ
            InsertArpmfrq(ArpmfrqDataDS);

            // STEP 7: Insert into OPPMEMA (if email exists)
            //If %Trim(BeccustpDS.CNTEMAIL) <> *Blanks;
            InsertOppmema(OppmeraDataDS);
            //EndIf;

            // STEP 8: Write audit record to ARPTCSA
            WriteAuditRecord(ArpmbalDataDS);

            // STEP 9: Write customer addon to ARPMCUA
            InsertArpmcua(ArpmcuaDataDS);

$A          // STEP10: Write customer pricing level record
$A          InsertArpcscmt(ArpcscmtDataDS);

        EndIf;

        // Display summary
        Dsply ('Records inserted: ' + %Char(RecordsInserted));
        Dsply ('Records skipped: ' + %Char(RecordsSkipped));
        Else;
        Dsply ('No BECCUSTP found for GUID:');
        Dsply %Trim(wGUID);
        If BeccredpFound;

            // STEP 2: Update the customer with credit app
            UpdateCustomer(BeccredpDS);
        EndIf;
        EndIf;

        End-Proc CreateCustomer;

        //===========================================================================
        //              INTERNAL PROCEDURES
        //===========================================================================

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
        Dcl-S MatchingCustNo Packed(6:0);
        Dcl-S FoundCreditRep Char(3);
        Dcl-S FoundSalesmanId Char(3);
        Dcl-S FoundBranch Packed(3:0);
$A      Dcl-S useHouseAcct Char(1) Inz;
$A      Dcl-S validSalesId Char(1) Inz;

        Dcl-S wARZP15 Char(5);

        // Clear the global CustomerDS
        Clear CustomerDS;

        // Map customer data BEFORE getting customer number
        CustomerDS.ARNM01 = %Upper(%Trim(pBeccustp.CUSTLEGAL));  // Customer Legal Name
        CustomerDS.ARNM03 = %Upper(%Trim(pBeccustp.CUSTCRTBY));  // User ID
        CustomerDS.ARNM05 = %Upper(%Trim(pBeccustp.CUSTDBA));    // DBA/Sort Name

        // Map phone number from CNTPHONE to area code, prefix, and number
        ParsePhoneNumber(pBeccustp.CNTPHONE);

        // Map mailing address
        // ARAD01 is reserved for DBA/business name info
        // Primary street address goes in ARAD02, secondary in ARAD03
        // CustomerDS.ARAD01 = %Upper(%Trim(pBeccustp.CUSTDBA)); // DBA/Business Name in Address 1
        CustomerDS.ARAD02 = %Upper(%Trim(pBeccustp.ADDR1));      // Primary Street Address
        CustomerDS.ARAD03 = %Upper(%Trim(pBeccustp.ADDR2));      // Secondary Address Line
        CustomerDS.ARCY01 = %Upper(%Trim(pBeccustp.CITY));       // Mailing City
        CustomerDS.ARST01 = %Upper(%Trim(pBeccustp.STATE));      // Mailing State
        CustomerDS.ARZP15 = %Trim(pBeccustp.ZIPCODE);            // Mailing Zip

        // Validate address using PERZIP service
        ValidateCustomerAddress();

        // Validate sort name for Hydros customers BEFORE duplicate check
        ValidateSortName(CustomerDS.ARNM05);

        // If sort name validation failed, skip insert
        If Not SortNameValid;
            RecordsSkipped += 1;
            Dsply ('Sort name validation failed: ' + %Trim(CustomerDS.ARNM05));
            Return;
        EndIf;

        // Progressive duplicate check:
        // 1. Match on Zip, State, City (case-insensitive)
        // 2. Then check address lines for actual street address match
        Exec SQL
            SELECT ARNO01
            INTO :ExistingCustNo
            FROM ARPMCUS
            WHERE UPPER(ARZP15) = UPPER(:CustomerDS.ARZP15)
            AND UPPER(ARST01) = UPPER(:CustomerDS.ARST01)
            AND UPPER(ARCY01) = UPPER(:CustomerDS.ARCY01)
            AND (
                //UPPER(ARAD01) = UPPER(:CustomerDS.ARAD01)
                UPPER(ARAD02) = UPPER(:CustomerDS.ARAD02)
                OR UPPER(ARNM01) = UPPER(:CustomerDS.ARNM01)
            )
            FETCH FIRST 1 ROW ONLY;

        If SQLCODE = 0;
            // Duplicate found, skip insert
            RecordExists = *On;
            RecordsSkipped += 1;
            // Call duplicate handling procedure
            HandleDuplicateCustomer(ExistingCustNo: CustomerDS);
            Return;
        EndIf;

        // No duplicate found - NOW get next customer number from ARR5006
        newCustomerNumber = 0;
        TypeField = *Blanks;
        ValidField = *Blanks;
        getNextCustomerNumber(newCustomerNumber: TypeField: ValidField);

        CustomerDS.ARNO01 = newCustomerNumber;  // Customer Number from ARR5006

        If %Trim(BeccustpDS.CNTEMAIL) <> *Blanks;
          CustomerDS.ARFL50 = 'E';                               // Consolidated Fax/Email
          CustomerDS.ARFL72 = 'N';                               // Fax/Email Sales Order
          CustomerDS.ARCDE7 = '3';                               // Invoice Print Type
        Else;
          CustomerDS.ARFL50 = 'N';                               // Consolidated Fax/Email
          CustomerDS.ARFL72 = 'N';                               // Fax/Email Sales Order
          CustomerDS.ARCDE7 = '1';                               // Invoice Print Type
        Endif;
        CustomerDS.ARFL01 = 'Y';                                 // Backorder Allowed
        CustomerDS.ARFL02 = 'Y';                                 // PO Required
        CustomerDS.ARFL04 = '3';                                 // Print Statement Flag
        CustomerDS.ARFL05 = 'Y';                                 // Job name required
        CustomerDS.ARFL08 = 'Y';                                 // Delivery Charge Flag
        CustomerDS.ARFL29 = 'N';                                 // Bill To Enterprise
        CustomerDS.ARFL48 = 'N';                                 // Consolidated Printing
        CustomerDS.ARFL88 = 'Y';                                 // Print Total on Pick Ticket
        CustomerDS.ARFL89 = 'N';                                 // Print Total on Pick Ticket Lock
        CustomerDS.ARFL91 = 'N';                                 // Prohibit Price Overrides
        CustomerDS.ARFL93 = 'N';                                 // Prohibit Price Overrides Lock
        CustomerDS.ARNO05 = 1;                                   // Number of Invoice Copies
        CustomerDS.ARCD04 = 2222222;                             // Customer Tax Jurisdiction Code
        CustomerDS.ARCD21 = 'R';                                 // Charge/Cash
        CustomerDS.ARCD22 = 'O';                                 // Open Item Code
        CustomerDS.ARCD29 = 'O';                                 // Statement Print Code
        CustomerDS.ARCD30 = 2222222;                             // Cust Tax Jurisdiction Cde pickup
        CustomerDS.ARCDB7 = 'Y';                                 // Print Prices
        CustomerDS.ARCDB8 = 'Y';                                 // Print Net Prices
        CustomerDS.ARCDF9 = '01';                                // Terms Code
$A      CustomerDS.ARCD59 = 'Y';                                 // Warranty fee

        // Get Guarantor and market type
        tbno01 = 'BCTR';
        tbno03 = %Trim(%Upper(pBeccustp.STYBIZBEC));
            Exec SQL
            SELECT tbnO02 INTO :customerds.arcd02
            FROM TBPMTBL
            WHERE tbno01 = :tbno01
                AND tbno03 = :tbno03;
        If BeccredpFound and beccredpds.PGUARVAL <> *blanks;
          CustomerDS.ARCD03 = %Subst(beccredpds.PGUARVAL:1:1);     // Guarantee Y/N
        else;
          CustomerDS.ARCD03 = 'N';                                 // Guarantee Y/N
        Endif;

        // Date Account Opened
        CustomerDS.ARCC02 = %Dec(%Subst(%Char(%Date()):1:2):2:0);  // Century Account History
        CustomerDS.ARYR02 = %Dec(%Subst(%Char(%Date()):3:2):2:0);  // Year Account Opened
        CustomerDS.ARMO02 = %Dec(%Subst(%Char(%Date()):6:2):2:0);  // Month Account Opened
        CustomerDS.ARDY02 = %Dec(%Subst(%Char(%Date()):9:2):2:0);  // Day Account Opened

        // Date Customer History Starts
        CustomerDS.ARCC14 = %Dec(%Subst(%Char(%Date()):1:2):2:0);  // Century Account History
        CustomerDS.ARYR14 = %Dec(%Subst(%Char(%Date()):3:2):2:0);  // Year Account History
        CustomerDS.ARMO14 = %Dec(%Subst(%Char(%Date()):6:2):2:0);  // Month Account History
        CustomerDS.ARDY14 = %Dec(%Subst(%Char(%Date()):9:2):2:0);  // Day Account History

        // Populate ArphbalDataDS for later use
        Clear ArphbalDataDS;
        ArphbalDataDS.ARNO01 = newCustomerNumber;                // Customer Number
        ArphbalDataDS.ARNM05 = CustomerDS.ARNM05;                // Customer Sort Name
        ArphbalDataDS.ARNO16 = 98;                               // Branch Number (default)
        ArphbalDataDS.ARNO15 = 1;                                // Company Number (default)
        ArphbalDataDS.ARNO82 = 0;                                // Enterprise Number (default)

        // Find credit rep and salesman by looking up existing customer in same location
        // First find ARNO01 in ARPMCUS with matching city/state/zip (not closed)
        // Then get ARID05 and ARID01 from ARPMBAL using that customer number

        Clear MatchingCustNo;
        Clear FoundCreditRep;
        Clear FoundSalesmanId;
        wARZP15 = %subst(CustomerDS.ARZP15:1:5);

        Exec SQL
            SELECT ARNO01
            INTO :MatchingCustNo
            FROM ARPMCUS
            WHERE ARFL10 <> 'C'
            AND ARST02 = :CustomerDS.ARST01
            AND substr(ARZP16,1,5) = :wARZP15
            order by arno01 desc
            FETCH FIRST 1 ROW ONLY;

        If SQLCODE = 0;
            // Found matching customer, now get credit rep and salesman from ARPMBAL
   $A     //Exec SQL
   $A     //    SELECT ARID05, ARID01, ARNO16
   $A     //    INTO :FoundCreditRep, :FoundSalesmanId, :FoundBranch
   $A     //    FROM ARPMBAL
   $A     //    WHERE ARNO01 = :MatchingCustNo
   $A     //    FETCH FIRST 1 ROW ONLY;

$A          // Based on existing customer found
$A          // Ignore branch if closed or not operational
$A          // Don't select consignment branch
$A          Exec SQL
$A           WITH ConsignmentRange AS
$A              (
$A                  SELECT INT(SUBSTR(TBNO03,1,3)) AS LowBranch,
$A                          INT(SUBSTR(TBNO03,5,3)) AS HighBranch
$A                      FROM TBPMTBL
$A                  WHERE TBNO01 = 'CONS'
$A                      AND TBNO02 = 'RANGE'
$A              )
$A              SELECT A.ARID05,
$A                      A.ARID01,
$A                      A.ARNO16
$A                  INTO :FoundCreditRep,
$A                      :FoundSalesmanId,
$A                      :FoundBranch
$A                  FROM ARPMBAL A
$A                      JOIN ARPMBCH B
$A                          ON B.ARNO16 = A.ARNO16
$A                        JOIN ARPMSLS S
$A                           ON S.ARNO16 = A.ARNO16
$A                      JOIN ConsignmentRange C
$A                          ON 1 = 1
$A                  WHERE A.ARNO01 = :MatchingCustNo
$A                  AND B.ARFL16 = ' '
$A                  AND B.ARFL23 = 'Y'
$A                  AND INT(A.ARNO16) NOT BETWEEN
$A                      C.LowBranch AND C.HighBranch
$A                  FETCH FIRST 1 ROW ONLY;

            If SQLCODE = 0;

                If %Trim(FoundCreditRep) <> *Blanks;
                    ArphbalDataDS.ARID05 = FoundCreditRep;
                    ArphbalDataDS.ARNO16 = FoundBranch;
                    Dsply ('Credit rep found: ' + %Trim(FoundCreditRep));

                Else;
                    ArphbalDataDS.ARID05 = *Blanks;
                    ArphbalDataDS.ARNO16 = 98;
                EndIf;

                If %Trim(FoundSalesmanId) <> *Blanks;

$A                // Use branch house acct sales id or get copied customer
$A                // sales id
$A                Exec Sql
$A                 Select substr(tbno03,1,1) into :useHouseAcct
$A                  from TBPMTBL
$A                  where tbno01 = 'SLSH'
$A                  and tbno02 = 'BECTRAN';

$A                If useHouseAcct = 'N';
$A                  // Verify the sales id is part of an active branch
$A                  // If not, set branch = House Acct Sales Id
$A                  validSalesId = *Blanks;
$A                  Exec Sql
$A                   select '1' into :validSalesId
$A                   from ARPMSLS A
$A                   join ARPMBCH B
$A                   on a.arno16 = b.arno16
$A                   where a.arid01 = :FoundSalesmanId
$A                   and B.ARFL16 = ' '
$A                   and B.ARFL23 = 'Y';

$A                  // Valid sales id found at open branch
$A                  If validSalesId = '1';
$A                   ArphbalDataDS.ARID01 = FoundSalesmanId;
$A                   ArphbalDataDS.ARNO16 = FoundBranch;
                     Dsply ('Salesman ID found: ' + %Trim(FoundSalesmanId));
$A                  Else;
$A                   // Assign house acct sales id from customer branch if
$A                   // copied customer sales id belongs to a closed branch
$A                   //houseAcct = GetBranchHouseAcct(prBranch);
$A                   getHouseAcctSlsId(FoundBranch);
$A                  Endif;
$A                Else;
$A                  getHouseAcctSlsId(FoundBranch);
$A                Endif;
                Else;
                    ArphbalDataDS.ARID01 = *Blanks;
$A                  ArphbalDataDS.ARNO16 = 98;
                EndIf;
            Else;
$A              ArphbalDataDS.ARID05 = *Blanks;
                ArphbalDataDS.ARID01 = *Blanks;
$A              ArphbalDataDS.ARNO16 = 98;
            EndIf;
        Else;
            // No matching customer found, default to blanks
            ArphbalDataDS.ARID05 = *Blanks;
            ArphbalDataDS.ARID01 = *Blanks;
            ArphbalDataDS.ARNO16 = 98;
        EndIf;

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
        ArpmbalDataDS.ARNO16 = ArphbalDataDS.ARNO16;             // Branch Number (default)
        ArpmbalDataDS.ARNO01 = newCustomerNumber;                // Customer Number
        ArpmbalDataDS.ARNO15 = 1;                                // Company Number (default)
        ArpmbalDataDS.ARFL03 = *Blanks;                          // Credit Hold Flag (default)
        ArpmbalDataDS.ARFL14 = 'Y';                              // Finance Charge Flag (default)
        ArpmbalDataDS.ARID01 = ArphbalDataDS.ARID01;             // Salesman Initials
        ArpmbalDataDS.ARID05 = ArphbalDataDS.ARID05;             // Credit Rep Initials

        // Get credit limit from BECCREDP if found
        // If BeccredpFound;
            // ArpmbalDataDS.ARAM01 = BeccredpDS.APPRLMT;           // Credit Limit from BECCREDP
            // Dsply ('Credit limit from BECCREDP: ' + %Char(BeccredpDS.APPRLMT));
            // If BeccredpDS.APPRLMT =0;
            //   CustomerDS.ARCD21 = 'C';                          // Charge/Cash
            //   ArpmbalDataDS.ARAM01 = 1;                         // Credit Limit
            // Call Zero Credit Limit handling procedure
            // HandleZeroLimitCustomer(newCustomerNumber: CustomerDS);
            //EndIf;
        //Else;
            ArpmbalDataDS.ARAM01 = 1;                            // Credit Limit Amount (default)
            CustomerDS.ARCD21 = 'C';                             // Charge/Cash
        //EndIf;

        ArpmbalDataDS.ARFL76 = 'N';                              // Lock Flag (set to 'N')
        ArpmbalDataDS.ARID08 = *Blanks;                          // Customer Service Rep (default)

        // Populate ArpmconDataDS for later use
        Clear ArpmconDataDS;
        ArpmconDataDS.ARNO01 = newCustomerNumber;                // Customer Number
        If %Trim(pBeccustp.CNTFNAME) <> *blanks or
           %Trim(pBeccustp.CNTLNAME) <> *Blanks;
            ArpmconDataDS.ARNM02 = %Trim(pBeccustp.CNTFNAME) + ' ' +
            %Trim(pBeccustp.CNTLNAME);
        Else;
        ArpmconDataDS.ARNM02 = *Blanks;                          // Customer Contact Name (default)
        Endif;
        ArpmconDataDS.ARDN01 = %Upper(%Trim(pBeccustp.CNTTITLE));// Customer Contact Title (default)
        ArpmconDataDS.ARNO12 = CustomerDS.ARNO07;                // Telephone Area Code (default)
        ArpmconDataDS.ARNO13 = CustomerDS.ARNO08;                // Telephone Prefix (default)
        ArpmconDataDS.ARNO14 = CustomerDS.ARNO09;                // Telephone Number (default)

        // Set current date for last update fields
        ArpmconDataDS.ARMO09 = %Dec(%Subst(%Char(%Date()):5:2):2:0);  // Month
        ArpmconDataDS.ARDY09 = %Dec(%Subst(%Char(%Date()):7:2):2:0);  // Day
        ArpmconDataDS.ARCC09 = %Dec(%Subst(%Char(%Date()):1:2):2:0);  // Century
        ArpmconDataDS.ARYR09 = %Dec(%Subst(%Char(%Date()):3:2):2:0);  // Year

        ArpmconDataDS.ARNM03 = %Upper(%Trim(pBeccustp.CUSTCRTBY)); // User Id
        ArpmconDataDS.ARNOD9 = 1;                                // Contact Control

        // Populate ArpmfrqDataDS for later use
        Clear ArpmfrqDataDS;
        ArpmfrqDataDS.ARNO01 = newCustomerNumber;                // Customer Number
        ArpmfrqDataDS.ARFL52 = 'D';                              // Print Invoice Weekly (default)
        ArpmfrqDataDS.ARFL54 = 'X';                              // Print Invoice on Sunday
        ArpmfrqDataDS.ARFL55 = 'X';                              // Print Invoice on Monday
        ArpmfrqDataDS.ARFL56 = 'X';                              // Print Invoice on Tuesday
        ArpmfrqDataDS.ARFL57 = 'X';                              // Print Invoice on Wednesday
        ArpmfrqDataDS.ARFL58 = 'X';                              // Print Invoice on Thursday
        ArpmfrqDataDS.ARFL59 = 'X';                              // Print Invoice on Friday
        ArpmfrqDataDS.ARFL60 = 'X';                              // Print Invoice on Saturday

        // Populate OppmeraDataDS for later use
        Clear OppmeraDataDS;
        OppmeraDataDS.OPNO17 = newCustomerNumber;                // Email Address Control Number
        OppmeraDataDS.OPCD14 = '01';                             // Email Address Type (BU = Busines
        OppmeraDataDS.OPAD01 = %Trim(pBeccustp.CNTEMAIL);        // Email Address (Business Email)
        OppmeraDataDS.OPNM13 = *Blanks;

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

        OppmeraDataDS.ARNOD9 = 1;                                // Contact Control Number (default)

        // Populate ArpmcuaDataDS for later use
        Clear ArpmcuaDataDS;
        ArpmcuaDataDS.ARNO01 = newCustomerNumber;                // Customer Number
        ArpmcuaDataDS.OPCD34 = 'A';                              // Record Status
        ArpmcuaDataDS.OPCD31 = 'U';                              // Definition Type
        ArpmcuaDataDS.OPNM25 = 'BECCUSTID';                      // Field Name
        ArpmcuaDataDS.OPTX20 = pBeccustp.acctid;                 // Account ID

        // Set current date for last update fields
        ArpmcuaDataDS.OPMO04 = %Dec(%Subst(%Char(%Date()):6:2):2:0);  // Month
        ArpmcuaDataDS.OPDY04 = %Dec(%Subst(%Char(%Date()):9:2):2:0);  // Day
        ArpmcuaDataDS.OPCC04 = %Dec(%Subst(%Char(%Date()):1:2):2:0);  // Century
        ArpmcuaDataDS.OPYR04 = %Dec(%Subst(%Char(%Date()):3:2):2:0);  // Year

        ArpmcuaDataDS.OPNM06 = %Upper(%Trim(pBeccustp.CUSTCRTBY)); // User Id

$A      // Populate ArpcscmtDataDS for later use
$A      Clear ArpcscmtDataDS;
$A      ArpcscmtDataDS.ARNO01     = newCustomerNumber;               // Customer Number
$A      ArpcscmtDataDS.COMMNT     = *Blanks;                         // Comment (default blank)
$A      ArpcscmtDataDS.PRCLV1     = '4';                             // Equipment price level
$A      ArpcscmtDataDS.PRCLV2     = '4';                             // Supplies price level
$A      ArpcscmtDataDS.PRCLV3     = '4';                             // Parts price level
$A      ArpcscmtDataDS.PRCLV4     = '4';                             // Tools price level
$A      ArpcscmtDataDS.PRCLV5     = '4';                             // Commodities price level
$A      ArpcscmtDataDS.EPDSLS     = *Blanks;                         // Equipment sales id
$A      ArpcscmtDataDS.CHGFRT     = 'Y';                             // Charge Freight
$A      ArpcscmtDataDS.GCCUST     = *Zeros;                          // Goodcare Cust#
$A      ArpcscmtDataDS.CNTPRO     = *Zeros;                          // Honeywell Pro#
$A      ArpcscmtDataDS.GMDY01     = *Zeros;                          // Goodman NDA Day
$A      ArpcscmtDataDS.GMCC01     = *Zeros;                          // Goodman NDA Century
$A      ArpcscmtDataDS.GMYR01     = *Zeros;                          // Goodman NDA Year
$A      ArpcscmtDataDS.GMMO01     = *Zeros;                          // Goodman NDA Month
$A      ArpcscmtDataDS.GMNDAS     = *Zeros;                          // Goodman NDA LY Sales
$A      ArpcscmtDataDS.ECMO01     = *Zeros;                          // Last review month
$A      ArpcscmtDataDS.ECDY01     = *Zeros;                          // Last review day
$A      ArpcscmtDataDS.ECCC01     = *Zeros;                          // Last review century
$A      ArpcscmtDataDS.ECYR01     = *Zeros;                          // Last review Year
$A      ArpcscmtDataDS.CMCD07     = *Blanks;                         // Send COD to BillTrust
$A      ArpcscmtDataDS.FRAUDRVW   = *Blanks;                         // Fraud Review Y/N
$A      ArpcscmtDataDS.REVIEWUSER = *Blanks;                         // Reviewed by user
$A      ArpcscmtDataDS.CMFL19     = *Blanks;                         // Print Cr/Dr inv memos only

        // Insert new record (duplicate check already done above)
        Exec SQL
            INSERT INTO ARPMCUS
            VALUES (:CustomerDS);

        If SQLCODE = 0;
            RecordsInserted += 1;
            Dsply ('Record inserted: ' + %Char(CustomerDS.ARNO01));

            // Update BECCUSTP status to 'S' for Processed Successfully
            Exec SQL
                UPDATE BECCUSTP
                SET STATUS = 'S',
                    UPDTS = CURRENT_TIMESTAMP
                WHERE GUID = :wGUID;

            // Update BECCREDP status to 'S' if found
            Exec SQL
                UPDATE BECCREDP
                SET STATUS = 'S',
                    UPDTS = CURRENT_TIMESTAMP
                WHERE GUID = :wGUID;

        Else;
            // Call error handling procedure
            HandleInsertError(CustomerDS: SQLCODE: SQLSTATE);
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
            WHERE GUID = :pGUID
            and status = ' ';

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
            LogError('':pGUID: '': 'ReadBeccustpByGUID':
                    'BECCUSTP record not found');
        EndIf;

        End-Proc;

        //===========================================================================
        // Procedure: ReadBeccredpByGUID
        // Description: Read BECCREDP record using GUID matching BECCUSTP
        //===========================================================================
        Dcl-Proc ReadBeccredpByGUID;
        Dcl-PI *N;
            pGUID Char(36) Const;
        End-PI;

        // Read record by GUID (matches BECCUSTP GUID)
        Exec SQL
            SELECT *
            INTO :BeccredpDS
            FROM BECCREDP
            WHERE GUID = :pGUID
            and status = ' ';

        // Check if record was found
        If SQLCODE = 0;
            BeccredpFound = *On;
            Dsply ('BECCREDP found for GUID');
        ElseIf SQLCODE = 100;
            // No record found
            BeccredpFound = *Off;
            Dsply ('No BECCREDP found for GUID');
        Else;
            // SQL error occurred
            BeccredpFound = *Off;
            Dsply ('SQL Error reading BECCREDP: ' + %Char(SQLCODE));
            Dsply ('SQL State: ' + SQLSTATE);
            LogError('':pGUID: '': 'ReadBeccredpByGUID':
                    'BECCREDP record not found');
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

        // Update BECCREDP status to 'E' for Error
        Exec SQL
            UPDATE BECCREDP
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

        // Update BECCREDP status to 'X' for Exclude (duplicate)
        Exec SQL
            UPDATE BECCREDP
            SET STATUS = 'X',
                CLIACCTID = :pExistingCustNo,
                UPDTS = CURRENT_TIMESTAMP
            WHERE GUID = :wGUID;

        End-Proc;

        //===========================================================================
        // Procedure: HandleZeroLimitCustomer
        // Description: Handle new customer with zero credit limit
        //===========================================================================
        Dcl-Proc HandleZeroLimitCustomer;
        Dcl-PI *N;
            pNewCustNo Packed(6:0) Const;
            pCustomer LikeDS(CustomerDS) Const;
        End-PI;

        // Log duplicate details
        Dsply ('New customer: ' + %Char(pNewCustNo));
        Dsply ('Location:');
        Dsply (%Trim(pCustomer.ARCY01) + ', ' + %Trim(pCustomer.ARST01)
                + ' ' + %Trim(pCustomer.ARZP15));
        Dsply ('Customer Legal:');
        Dsply %Trim(pCustomer.ARNM01);

        // Send duplicate notification email
        SendZeroLimitEmail(pNewCustNo: pCustomer);

        // Update BECCUSTP status to 'X' for Exclude (duplicate)
        Exec SQL
            UPDATE BECCUSTP
            SET STATUS = 'X',
                CLIACCTID = :pNewCustNo,
                UPDTS = CURRENT_TIMESTAMP
            WHERE GUID = :wGUID;

        // Update BECCREDP status to 'X' for Exclude (duplicate)
        Exec SQL
            UPDATE BECCREDP
            SET STATUS = 'X',
                CLIACCTID = :pNewCustNo,
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
        emailList.Subject = 'CRTCUST Error - Customer Insert Failed';
        emailList.Note = 'An error occurred in CRTCUST program: '
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
        // Procedure: InsertArpmbal
        // Description: Update or Insert record into ARPMBAL table
        //===========================================================================
        Dcl-Proc InsertArpmbal;
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
            LocalArpmbalDS.ARID05 = pArpmbalData.ARID05;   // Credit Rep initials
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
        LocalArpmfrqDS.ARFL55 = pArpmfrqData.ARFL55;   // Print Invoice on Monday
        LocalArpmfrqDS.ARFL56 = pArpmfrqData.ARFL56;   // Print Invoice on Tuesday
        LocalArpmfrqDS.ARFL57 = pArpmfrqData.ARFL57;   // Print Invoice on Wednesday
        LocalArpmfrqDS.ARFL58 = pArpmfrqData.ARFL58;   // Print Invoice on Thursday
        LocalArpmfrqDS.ARFL59 = pArpmfrqData.ARFL59;   // Print Invoice on Friday
        LocalArpmfrqDS.ARFL60 = pArpmfrqData.ARFL60;   // Print Invoice on Saturday

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

        // Map fields from OppmeraDataDS to OPPMEMA
        If  BeccustpDS.INVEMAIL <> *blanks;                // Invoice Address
            LocalOppmeraDS.OPAD01 = BeccustpDS.INVEMAIL;   // Invoice Address
        EndIf;
        LocalOppmeraDS.OPNM13 = *blank;                    // Email Contact Name
        LocalOppmeraDS.ARNOD9 = *zeros;                    // Contact Control Number

        // Insert email for invoice statements into OPPMEMA
        Exec SQL
            INSERT INTO OPPMEMA
            VALUES (:LocalOppmeraDS);

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
        // Procedure: InsertArpmcua
        // Description: Insert record into ARPMCUA table
        //===========================================================================
        Dcl-Proc InsertArpmcua;
        Dcl-PI *N;
            pArpmcuaData LikeDS(ArpmcuaDataDS) Const;
        End-PI;

        // Local data structure for ARPMCUA
        Dcl-DS LocalArpmcuaDS LikeDS(ArpmcuaDS);

        // Clear the data structure
        Clear LocalArpmcuaDS;

        // Map fields from ArpmcuaDataDS to ARPMCUA
        LocalArpmcuaDS.ARNO01 = pArpmcuaData.ARNO01;   // Customer Number
        LocalArpmcuaDS.OPCD34 = pArpmcuaData.OPCD34;   // Record Status
        LocalArpmcuaDS.OPCD31 = pArpmcuaData.OPCD31;   // Definition Type
        LocalArpmcuaDS.OPNM25 = pArpmcuaData.OPNM25;   // Field Name
        LocalArpmcuaDS.OPTX20 = pArpmcuaData.OPTX20;   // Account ID
        LocalArpmcuaDS.OPMO04 = pArpmcuaData.OPMO04;   // Month Of Last Update
        LocalArpmcuaDS.OPDY04 = pArpmcuaData.OPDY04;   // Day Of Last Update
        LocalArpmcuaDS.OPCC04 = pArpmcuaData.OPCC04;   // Century Of Last Update
        LocalArpmcuaDS.OPYR04 = pArpmcuaData.OPYR04;   // Year Of Last Update
        LocalArpmcuaDS.OPNM06 = pArpmcuaData.OPNM06;   // User Id Of Maintenance

        // Insert into ARPMCUA
        Exec SQL
            INSERT INTO ARPMCUA
            VALUES (:LocalArpmcuaDS);

        If SQLCODE = 0;
            Dsply ('ARPMCUA inserted: ' + %Char(pArpmcuaData.ARNO01));
        Else;
            Dsply ('Error inserting ARPMCUA: ' + %Char(SQLCODE));
            Dsply ('SQL State: ' + SQLSTATE);
        EndIf;
        End-Proc;

$A      //===========================================================================
$A      // Procedure: InsertArpcscmt
$A      // Description: Insert record into ARPCSCMT table
$A      //===========================================================================
$A      Dcl-Proc InsertArpcscmt;
$A      Dcl-PI *N;
$A          pArpcscmtData LikeDS(ArpcscmtDataDS) Const;
$A      End-PI;

$A      // Local data structure for ARPCSCMT
$A      Dcl-DS LocalArpcscmtDS LikeDS(ArpcscmtDS);

$A      // Clear the data structure
$A      Clear LocalArpcscmtDS;

$A      // Map fields from ArpcscmtDataDS to ARPCSCMT
$A      LocalArpcscmtDS.ARNO01     = pArpcscmtData.ARNO01;      // Customer Number
$A      LocalArpcscmtDS.COMMNT     = pArpcscmtData.COMMNT;      // Comment
$A      LocalArpcscmtDS.PRCLV1     = pArpcscmtData.PRCLV1;      // Equipment price level
$A      LocalArpcscmtDS.PRCLV2     = pArpcscmtData.PRCLV2;      // Supplies price level
$A      LocalArpcscmtDS.PRCLV3     = pArpcscmtData.PRCLV3;      // Parts price level
$A      LocalArpcscmtDS.PRCLV4     = pArpcscmtData.PRCLV4;      // Tools price level
$A      LocalArpcscmtDS.PRCLV5     = pArpcscmtData.PRCLV5;      // Commodities price level
$A      LocalArpcscmtDS.EPDSLS     = pArpcscmtData.EPDSLS;      // Equipment sales id
$A      LocalArpcscmtDS.CHGFRT     = pArpcscmtData.CHGFRT;      // Charge Freight
$A      LocalArpcscmtDS.GCCUST     = pArpcscmtData.GCCUST;      // Goodcare Cust#
$A      LocalArpcscmtDS.CNTPRO     = pArpcscmtData.CNTPRO;      // Honeywell Pro#
$A      LocalArpcscmtDS.GMDY01     = pArpcscmtData.GMDY01;      // Goodman NDA Day
$A      LocalArpcscmtDS.GMCC01     = pArpcscmtData.GMCC01;      // Goodman NDA Century
$A      LocalArpcscmtDS.GMYR01     = pArpcscmtData.GMYR01;      // Goodman NDA Year
$A      LocalArpcscmtDS.GMMO01     = pArpcscmtData.GMMO01;      // Goodman NDA Month
$A      LocalArpcscmtDS.GMNDAS     = pArpcscmtData.GMNDAS;      // Goodman NDA LY Sales
$A      LocalArpcscmtDS.ECMO01     = pArpcscmtData.ECMO01;      // Last review month
$A      LocalArpcscmtDS.ECDY01     = pArpcscmtData.ECDY01;      // Last review day
$A      LocalArpcscmtDS.ECCC01     = pArpcscmtData.ECCC01;      // Last review century
$A      LocalArpcscmtDS.ECYR01     = pArpcscmtData.ECYR01;      // Last review Year
$A      LocalArpcscmtDS.CMCD07     = pArpcscmtData.CMCD07;      // Send COD to BillTrust
$A      LocalArpcscmtDS.FRAUDRVW   = pArpcscmtData.FRAUDRVW;    // Fraud Review Y/N
$A      LocalArpcscmtDS.REVIEWUSER = pArpcscmtData.REVIEWUSER;  // Reviewed by user
$A      LocalArpcscmtDS.CMFL19     = pArpcscmtData.CMFL19;      // Print Cr/Dr inv memos only

$A      // Insert into ARPCSCMT
$A      // REVIEWDATE *loval is hardcoded ('0001-01-01')
$A      Exec SQL
$A          INSERT INTO ARPCSCMT (
$A              ARNO01, COMMNT, PRCLV1, PRCLV2, PRCLV3, PRCLV4, PRCLV5,
$A              EPDSLS, CHGFRT, GCCUST, CNTPRO,
$A              GMDY01, GMCC01, GMYR01, GMMO01, GMNDAS,
$A              ECMO01, ECDY01, ECCC01, ECYR01,
$A              CMCD07, FRAUDRVW, REVIEWDATE, REVIEWUSER, CMFL19)
$A          VALUES (
$A              :LocalArpcscmtDS.ARNO01, :LocalArpcscmtDS.COMMNT,
$A              :LocalArpcscmtDS.PRCLV1, :LocalArpcscmtDS.PRCLV2,
$A              :LocalArpcscmtDS.PRCLV3, :LocalArpcscmtDS.PRCLV4,
$A              :LocalArpcscmtDS.PRCLV5, :LocalArpcscmtDS.EPDSLS,
$A              :LocalArpcscmtDS.CHGFRT, :LocalArpcscmtDS.GCCUST,
$A              :LocalArpcscmtDS.CNTPRO,
$A              :LocalArpcscmtDS.GMDY01, :LocalArpcscmtDS.GMCC01,
$A              :LocalArpcscmtDS.GMYR01, :LocalArpcscmtDS.GMMO01,
$A              :LocalArpcscmtDS.GMNDAS,
$A              :LocalArpcscmtDS.ECMO01, :LocalArpcscmtDS.ECDY01,
$A              :LocalArpcscmtDS.ECCC01, :LocalArpcscmtDS.ECYR01,
$A              :LocalArpcscmtDS.CMCD07, :LocalArpcscmtDS.FRAUDRVW,
$A              DATE('0001-01-01'),
$A              :LocalArpcscmtDS.REVIEWUSER, :LocalArpcscmtDS.CMFL19);

$A      If SQLCODE = 0;
$A          Dsply ('ARPCSCMT inserted: ' + %Char(pArpcscmtData.ARNO01));
$A      Else;
$A          Dsply ('Error inserting ARPCSCMT: ' + %Char(SQLCODE));
$A          Dsply ('SQL State: ' + SQLSTATE);
$A      EndIf;
$A      End-Proc;

        //===========================================================================
        // Procedure: UpdateCustomer
        // Description: Update Customer with credit record
        //===========================================================================
        Dcl-Proc UpdateCustomer;
        Dcl-PI *N;
            pBeccredp LikeDS(BeccredpDS) Const;
        End-PI;

        // Local variables
        Dcl-S FoundRecord Int(5);
        Dcl-S pCustomerNumber Packed(6:0) Inz(0);
        Dcl-S pCustomerName   Char(30);

        If pBeccredp.CRDDEC = 'Declined';
        // Check if customer exists
        Exec SQL
            SELECT arno01
            INTO :pCustomerNumber
            FROM ARPMCUA
            WHERE OPNM25 = 'BECCUSTID'
            AND OPTX20 = :pBeccredp.acctid;

        If SQLCODE = 0;
        // Record exists, find customer number
        Exec SQL
            SELECT *
            INTO :CustomerDS
            FROM ARPMCUS
            WHERE ARNO01 = :pCustomerNumber;

        If SQLCODE = 0;
        // Send customer credit declined notification email
        SendDeclinedEmail(pCustomerNumber: CustomerDS);

        EndIf;
        EndIf;
        EndIf;

        // Update BECCREDP status to 'S'
        Exec SQL
            UPDATE BECCREDP
            SET STATUS = 'S',
                UPDTS = CURRENT_TIMESTAMP
            WHERE GUID = :wGUID;

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
            // Only convert to numeric if TAXS_JURIS is not blank
            If %Trim(TAXS_JURIS) <> *Blanks;
                TAXS_JURIS_N = %Dec(TAXS_JURIS:20:0);
            Else;
                Clear TAXS_JURIS_N;
            EndIf;
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

            // Update BECCREDP status to 'E' for Error
            Exec SQL
                UPDATE BECCREDP
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
        emailList.Subject = 'CRTCUST - Duplicate Customer Detected';
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

        //===========================================================================
        // Procedure: SendZeroLimitEmail
        // Description: Send zero limit customer notification email
        //===========================================================================
        Dcl-Proc SendZeroLimitEmail;
        Dcl-PI *N;
            pNewCustNo Packed(6:0) Const;
            pCustomer LikeDS(CustomerDS) Const;
        End-PI;

        // Local variables
        Dcl-S EmailErrorMessage Char(80);
        Dcl-S ZeroLimitMsg Char(500);

        // Build detailed message
        ZeroLimitMsg = 'New cod customer created from Bectran ' +
          'with zero dollar limit. ' +
          'New Customer #: ' + %Char(pNewCustNo) + ' | ' +
          'Customer Legal: ' + %Trim(pCustomer.ARNM01) + ' | ' +
          'Location: ' + %Trim(pCustomer.ARCY01) + ', ' +
          %Trim(pCustomer.ARST01) + ' ' + %Trim(pCustomer.ARZP15);

        // Set email subject and body
        emailList.Subject = 'BECTRAN - COD Customer Created ';
        emailList.Note = ZeroLimitMsg;

        // Email ID for the body
        emailList.bodyID = 1;

        // Send to IT department
        emailList.address(1) = 'ARDept@ecmdi.com';
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
            Dsply ('New COD Customer notification email sent');
        EndIf;

        End-Proc;

        //===========================================================================
        // Procedure: SendDeclinedEmail
        // Description: Send credit declined notification email
        //===========================================================================
        Dcl-Proc SendDeclinedEmail;
        Dcl-PI *N;
            pNewCustNo Packed(6:0) Const;
            pCustomer LikeDS(CustomerDS) Const;
        End-PI;

        // Local variables
        Dcl-S EmailErrorMessage Char(80);
        Dcl-S DeclinedMsg Char(500);

        // Build detailed message
        DeclinedMsg = 'Bectran declined credit to the following customer: ' +
          'New Customer #: ' + %Char(pNewCustNo) + ' | ' +
          'Customer Legal: ' + %Trim(pCustomer.ARNM01) + ' | ' +
          'Location: ' + %Trim(pCustomer.ARCY01) + ', ' +
          %Trim(pCustomer.ARST01) + ' ' + %Trim(pCustomer.ARZP15);

        // Set email subject and body
        emailList.Subject = 'BECTRAN - COD Customer Declined Credit';
        emailList.Note = DeclinedMsg;

        // Email ID for the body
        emailList.bodyID = 1;

        // Send to IT department
        emailList.address(1) = 'ARDept@ecmdi.com';
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
            Dsply ('Customer declined credit notification email sent');
        EndIf;

        End-Proc;

        //===========================================================================
        // Procedure: ValidateCustomerAddress
        // Description: Validate customer address using PERZIP service
        //===========================================================================
        Dcl-Proc ValidateCustomerAddress;

        // Local address validation data structure
        Dcl-DS addressValidationDS LikeDS(AddressParmDS);

        // Initialize address validation parameters
        Reset addressValidationDS;
        //addressValidationDS.inAddress1 = %Trim(CustomerDS.ARAD01);
        addressValidationDS.inAddress1 = ' ';
        addressValidationDS.inAddress2 = %Trim(CustomerDS.ARAD02);
        addressValidationDS.inAddress3 = %Trim(CustomerDS.ARAD03);
        addressValidationDS.inCity = %Trim(CustomerDS.ARCY01);
        addressValidationDS.inState = %Trim(CustomerDS.ARST01);
        addressValidationDS.inzip = %Trim(CustomerDS.ARZP15);
        addressValidationDS.returncase = 'U';              // Return uppercase
        addressValidationDS.maxAddressLength = 30;         // Max 30 characters
        addressValidationDS.runFullAddressCheck = 'Y';     // Run full validation
        addressValidationDS.addressType = 'S';             // Street/Shipping address

        // Call the validation service
        addressValidationDS = validateAddress(addressValidationDS);

        // Check for validation errors
        If %Trim(addressValidationDS.errorCode) <> *Blanks;
            Dsply ('Address validation warning: ' +
                   %Trim(addressValidationDS.errorCode));
            DsplyMsg = %Trim(addressValidationDS.errorMessage);
            Dsply DsplyMsg;

            // Log the error but don't fail - use original address
            // Common error codes: ADR, STR, SNF, MLT, etc.
        Else;
            // Address validated successfully - update with standardized address
            //CustomerDS.ARAD01 = %Upper(%Trim(addressValidationDS.outAddress1));
            //CustomerDS.ARAD02 = %Upper(%Trim(addressValidationDS.outAddress2));
            //CustomerDS.ARAD03 = %Upper(%Trim(addressValidationDS.outAddress3));
            CustomerDS.ARAD02 = %Upper(%Trim(addressValidationDS.outAddress1));
            CustomerDS.ARAD03 = %Upper(%Trim(addressValidationDS.outAddress2));
            CustomerDS.ARCY01 = %Upper(%Trim(addressValidationDS.outCity));
            CustomerDS.ARST01 = %Upper(%Trim(addressValidationDS.outState));
            CustomerDS.ARZP15 = %Trim(addressValidationDS.outZip);

            // Duplicate Mailing Address to Shipping Address
            CustomerDS.ARAD04 = CustomerDS.ARAD02;
            CustomerDS.ARAD05 = CustomerDS.ARAD03;
            CustomerDS.ARCY02 = CustomerDS.ARCY01;
            CustomerDS.ARST02 = CustomerDS.ARST01;
            CustomerDS.ARZP16 = %Trim(addressValidationDS.outZip);

            Dsply ('Address validated and standardized');
        EndIf;
        End-Proc;

        //===========================================================================
        // Procedure: ParsePhoneNumber
        // Description: Parse phone number from BECCUSTP.CNTPHONE and populate
        //              ARPMCUS fields ARNO07 (area code), ARNO08 (prefix), ARNO09 (number)
        //===========================================================================
        Dcl-Proc ParsePhoneNumber;
        Dcl-PI *N;
            pPhoneNumber Varchar(50) Const;
        End-PI;

        // Local variables
        Dcl-S CleanPhone Varchar(50);
        Dcl-S PhoneDigits Char(20);
        Dcl-S DigitCount Int(5);
        Dcl-S i Int(5);
        Dcl-S CurrentChar Char(1);
        Dcl-S wPhone12 Char(12);

        // Initialize fields to zero
        CustomerDS.ARNO07 = 0;  // Area Code
        CustomerDS.ARNO08 = 0;  // Prefix
        CustomerDS.ARNO09 = 0;  // Number

        // Check if phone number is blank
        If %Trim(pPhoneNumber) = *Blanks;
            Return;
        EndIf;

        // Extract only digits from phone number
        Clear PhoneDigits;
        DigitCount = 0;

        For i = 1 to %Len(%Trim(pPhoneNumber));
            CurrentChar = %Subst(pPhoneNumber:i:1);
            If CurrentChar >= '0' and CurrentChar <= '9';
                DigitCount += 1;
                If DigitCount <= 20;
                    %Subst(PhoneDigits:DigitCount:1) = CurrentChar;
                EndIf;
            EndIf;
        EndFor;

        // Parse based on number of digits found
        Select;
            // 10 digits: (AAA) PPP-NNNN
            When DigitCount = 10;
                CustomerDS.ARNO07 = %Dec(%Subst(PhoneDigits:1:3):3:0);  // Area Code
                CustomerDS.ARNO08 = %Dec(%Subst(PhoneDigits:4:3):3:0);  // Prefix
                CustomerDS.ARNO09 = %Dec(%Subst(PhoneDigits:7:4):4:0);  // Number
                Dsply ('Phone parsed (10 digits): ' +
                       %Char(CustomerDS.ARNO07) + '-' +
                       %Char(CustomerDS.ARNO08) + '-' +
                       %Char(CustomerDS.ARNO09));

            // 7 digits: PPP-NNNN (no area code)
            When DigitCount = 7;
                CustomerDS.ARNO07 = 0;                                   // No Area Code
                CustomerDS.ARNO08 = %Dec(%Subst(PhoneDigits:1:3):3:0);  // Prefix
                CustomerDS.ARNO09 = %Dec(%Subst(PhoneDigits:4:4):4:0);  // Number
                Dsply ('Phone parsed (7 digits): ' +
                       %Char(CustomerDS.ARNO08) + '-' +
                       %Char(CustomerDS.ARNO09));

            // 11 digits: 1-AAA-PPP-NNNN (strip leading 1)
            When DigitCount = 11 and %Subst(PhoneDigits:1:1) = '1';
                CustomerDS.ARNO07 = %Dec(%Subst(PhoneDigits:2:3):3:0);  // Area Code
                CustomerDS.ARNO08 = %Dec(%Subst(PhoneDigits:5:3):3:0);  // Prefix
                CustomerDS.ARNO09 = %Dec(%Subst(PhoneDigits:8:4):4:0);  // Number
                Dsply ('Phone parsed (11 digits): ' +
                       %Char(CustomerDS.ARNO07) + '-' +
                       %Char(CustomerDS.ARNO08) + '-' +
                       %Char(CustomerDS.ARNO09));

            When DigitCount > 10;
                CustomerDS.ARNO07 = %Dec(%Subst(PhoneDigits:1:3):3:0);  // Area Code
                CustomerDS.ARNO08 = %Dec(%Subst(PhoneDigits:4:3):3:0);  // Prefix
                CustomerDS.ARNO09 = %Dec(%Subst(PhoneDigits:7:4):4:0);  // Number
                Dsply ('Phone parsed (10 digits): ' +
                       %Char(CustomerDS.ARNO07) + '-' +
                       %Char(CustomerDS.ARNO08) + '-' +
                       %Char(CustomerDS.ARNO09));

            // Invalid format - log warning
            Other;
                //Dsply ('Invalid phone format: ' + %Trim(pPhoneNumber));
                wPhone12 = %Subst(pPhoneNumber:1:15);
                Dsply ('Invalid phone format: ' + wPhone12);
                Dsply ('Digit count: ' + %Char(DigitCount));
        EndSl;

        End-Proc;

$A      //===========================================================================
$A      // Procedure: getHouseAcctSlsId
$A      // Description: Use customer branch to get house sales id
$A      //===========================================================================
$A      Dcl-Proc getHouseAcctSlsId;
$A      Dcl-PI *N;
$A          pFoundBranch packed(3:0) Const;
$A      End-PI;

$A       Dcl-S HouseAcct    Char(3) Inz;
$A       Dcl-S prBranch Char(3) Inz;

$A        prBranch = %Editc(pFoundBranch:'X');
$A        HouseAcct = GetBranchHouseAcct(prBranch);

$A        If HouseAcct <> *Blanks;
$A           ArphbalDataDS.ARID01 = HouseAcct;
$A           ArphbalDataDS.ARNO16 = pFoundBranch;
$A        Else;
$A           ArphbalDataDS.ARID01 = *Blanks;
$A           ArphbalDataDS.ARNO16 = 98;
$A         Endif;

$A      End-Proc;

            //********************************************************
            // LogError - Log SQL errors to BECERRLG table
            //
            // Purpose: Logs SQL errors with GUID, Account ID, and
            //  error details to the BECERRLG error logging table
            //
            // Parameters:
            //  pGUID - GUID of the record being processed
            //  pAcctID - Account ID of the record
            //  pProcName - Name of the procedure where error occurred
            //  pErrMsg - Custom error message
            //
            // Returns: None
            //********************************************************
            dcl-proc LogError;
              dcl-pi *n;
                pFilePath  char(300) const;
                pGUID char(36) const;
                pAcctID varchar(50) const;
                pProcName varchar(50) const;
                pErrMsg varchar(500) const;
              end-pi;

              // Local variables
              dcl-s wSQLCODE int(10);
              dcl-s wSQLSTATE char(5);

              // Capture current SQL error state
              wSQLCODE = SQLCODE;
              wSQLSTATE = SQLSTATE;

              // Insert error record into log table
              exec sql
                INSERT INTO BECERRLG (
                  FILEPATH, GUID, ACCTID, ERRPROC, ERRMSG,
                  SQLCODE, SQLSTATE
                ) VALUES (
                  :pFilePath, :pGUID, :pAcctID, :pProcName, :pErrMsg,
                  :wSQLCODE, :wSQLSTATE
                );

              // Note: If logging fails, we silently continue
              // to avoid cascading errors

            end-proc;

