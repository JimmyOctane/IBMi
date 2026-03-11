            // Control Options
                Ctl-Opt Option(*SrcStmt:*NoDebugIO);
                Ctl-Opt ExtBinInt(*Yes);
                Ctl-Opt bnddir('ECBIND');
                Ctl-Opt DecEdit('0,');
                Ctl-Opt Copyright('East Coast Metals - BECTRAN SFTP');
                Ctl-Opt DftActGrp(*No);

            //************************************************************
            // BECTRAN - SFTP Customer Credit Application Data
            //           Integration
            //
            // Purpose: Retrieves customer credit application data
            //  from BECTRAN via SFTP and processes it into the IBM i
            //  (MINCRON) ERP system to create and maintain customer
            //  records
            //
            // Process Overview:
            //  1. Connect to BECTRAN SFTP server
            //  2. Download customer credit application XML files
            //  3. Parse XML data containing customer information
            //  4. Validate and transform data for MINCRON ERP
            //  5. Create/update customer records in IBM i database
            //  6. Archive processed XML files
            //
            // Data Flow:
            //  BECTRAN (Cloud) -> SFTP -> IBM i IFS -> Parse XML
            //  -> MINCRON ERP Tables -> Archive XML
            //
            // Author: East Coast Metals Development Team
            // Date: 2026-03-05
            // Version: 1.1
            //
            // Modification History:
            //  Date       Author        Description
            //  ---------- ------------- ----------------------------
            //  2026-03-05 ECM Dev Team  Initial implementation
            //                          - SFTP integration BECTRAN
            //                          - XML parsing for credit apps
            //                          - Customer creation MINCRON
            //  2026-03-06 ECM Dev Team  Enhanced processing logic
            //                          - Two-pass file processing
            //                          - CUS files before CRD files
            //                          - Generate GUID for orphan CRD
            //                          - Added audit fields (CRTTS/UPDTS)
            //                          - Added CURRENT_USER tracking
            //                          - Added CUSTCRTBY/CUSTCRTTS
            //  2026-03-09 ECM Dev Team  Added archive functionality
            //                          - Integrated ARCHIVEIFS module
            //                          - Auto-archive processed XMLs
            //                          - Preserve audit trail
            //
            //************************************************************

            // Copy member for LISTIFS data structures
            /copy qcpysrc,LISTIFS_CP

            // Copy member for GETGUID procedure prototype
            /copy qcpysrc,GETGUID_CP

            // Copy member for ARCHIVEIFS procedure prototype
            /copy qcpysrc,ARCHIFS_CP

            // Copy member for runIBMCommand
            /copy qcpysrc,RUNCMND_CP

            // Copy member for sendEmail
            /copy qcpysrc,SDEMAIL_CP

            // Prototype for sleep API
            dcl-pr sleep uns(10) extproc('sleep');
              seconds uns(10) value;
            end-pr;

            // Entry parameters
            dcl-pi *n;
              pSleepSeconds packed(15:5) const options(*nopass:*omit);
            end-pi;

            // Field Definitions - Variables
            dcl-s testPath char(300) inz;
            dcl-s subtreeOption ind inz(*off);
            dcl-s i packed(5:0) inz;
            dcl-s sleepSeconds packed(15:5) inz(600);
            dcl-s continueLoop ind inz(*on);
            dcl-ds returnIFSFolderListDS likeds(returnIFSDocumentsDS);

            // Determine sleep interval
            if %parms >= 1 and %addr(pSleepSeconds) <> *null;
              sleepSeconds = pSleepSeconds;
            endif;

            // Main processing loop
            dow continueLoop;

              // Download files from BECTRAN SFTP site to IFS
              DownloadBectranFiles();

              // Test 1: Valid directory with potential files
              testPath = '/home/bectran';
              returnIFSFolderListDS =
               LISTIFS(%trim(testPath):subtreeOption);

              if returnIFSFolderListDS.Found;

                  // Process files in two passes to ensure CUS records
                  // are created before CRD records that reference them
                  if returnIFSFolderListDS.FileCount > 0;

                  // PASS 1: Process all CUS (Customer) files first
                  for i = 1 to returnIFSFolderListDS.FileCount;
                      if %scan('CUS':
                       %upper(returnIFSFolderListDS.FileNames(i)))>0;
                          // Process customer file
                          ProcessCustomerXML(
                           %trim(returnIFSFolderListDS.FileNames(i)));
                      endif;
                  endfor;

                  // PASS 2: Process all CRED (Credit Decision) files
                  for i = 1 to returnIFSFolderListDS.FileCount;
                      if %scan('CRED':
                       %upper(returnIFSFolderListDS.FileNames(i)))>0;
                          // Process credit decision file
                          ProcessCreditXML(
                           %trim(returnIFSFolderListDS.FileNames(i)));
                      endif;
                  endfor;

                  else;
                  endif;
              else;
              endif;

              // Sleep before next iteration
              callp(e) sleep(sleepSeconds);

            enddo;

            // Test Summary
            *inlr = *on;

            //********************************************************
            // ProcessCustomerXML - Process BECTRAN Customer XML
            //
            // Purpose: Reads and parses customer XML file from
            //  BECTRAN, extracting customer data and preparing it
            //  for insertion into MINCRON ERP
            //
            // Parameters:
            //  pFilePath - Full IFS path to the customer XML file
            //
            // Returns: None (displays results via DSPLY)
            //********************************************************
            dcl-proc ProcessCustomerXML;
              dcl-pi *n;
                pFilePath varchar(300) const;
              end-pi;

              // Local variables
              dcl-s custCount int(10) inz(0);
              dcl-s rowCount int(10) inz(0);
              dcl-s maxRows int(10) inz(1000);
              dcl-s i int(10) inz(0);
              dcl-s wGUID char(36);
              dcl-ds archiveResult likeds(returnArchiveDS);


              // Customer data structure array
              dcl-ds c1 dim(1000) qualified inz;
                account_id varchar(50);
                transaction_id varchar(50);
                addressLineOne varchar(100);
                addressLineTwo varchar(100);
                annualSalesRange varchar(50);
                bectranCustomerId varchar(50);
                city varchar(50);
                contactPersonFirstName varchar(50);
                contactPersonLastName varchar(50);
                contactPersonPhone varchar(30);
                contactPersonTitle varchar(100);
                countryId varchar(10);
                customerDbaName varchar(100);
                customerLegalName varchar(100);
                dateCreatedInBectran varchar(20);
                dunsNumber varchar(20);
                fax varchar(30);
                businessEmail varchar(100);
                federalTaxId varchar(20);
                numOfEmployee varchar(50);
                phone varchar(30);
                state varchar(10);
                stateOfIncorporation varchar(10);
                styleOfBusiness varchar(100);
                typeOfBusiness varchar(50);
                yearEstablished varchar(10);
                zipCode varchar(20);
                contactPersonEmail varchar(100);
                requestId varchar(50);
                requestSource varchar(50);
                amountRequested packed(15:2);
                termRequestedCode varchar(50);
                termRequestedDescription varchar(100);
                plannedPurchase varchar(50);
                requestDate varchar(20);
                requestFormType varchar(50);
                purchaseOrderRequired varchar(10);
                accountNumExist varchar(10);
                clientAccountId varchar(50);
                orderPending varchar(10);
                orderPendingAmount packed(15:2);
                styleOfBusinessBectranCode varchar(50);
                styleOfBusinessClientCode varchar(50);
                styleOfBusinessDescription varchar(100);
                typeOfBusinessBectranCode varchar(50);
                typeOfBusinessClientCode varchar(50);
                typeOfBusinessDescription varchar(100);
                annualSalesBectranCode varchar(50);
                annualSalesClientCode varchar(50);
                annualSalesDescription varchar(100);
                numOfEmployeeBectranCode varchar(50);
                numOfEmployeeClientCode varchar(50);
                numOfEmployeeDescription varchar(100);
              end-ds;

              // Single row data structure for SQL operations
              dcl-ds c1Row likeds(c1);

              // Declare cursor and fetch data
              exec sql
                declare custCursor scroll cursor for
                WITH xml_data AS (
                  SELECT XMLPARSE(DOCUMENT
                    REGEXP_REPLACE(
                      LISTAGG(Line, ''), '<\?xml[^>]*\?>',
                      '', 1, 0, 'i')) AS doc
                  FROM TABLE(
                   QSYS2.IFS_READ(PATH_NAME => TRIM(:pFilePath)))
                )
                SELECT X.account_id, X.transaction_id, X.addressLineOne,
                       X.addressLineTwo, X.annualSalesRange,
                       X.bectranCustomerId, X.city,
                       X.contactPersonFirstName, X.contactPersonLastName,
                       X.contactPersonPhone, X.contactPersonTitle,
                       X.countryId, X.customerDbaName, X.customerLegalName,
                       X.dateCreatedInBectran, X.dunsNumber, X.fax,
                       X.businessEmail, X.federalTaxId, X.numOfEmployee,
                       X.phone, X.state, X.stateOfIncorporation,
                       X.styleOfBusiness, X.typeOfBusiness,
                       X.yearEstablished, X.zipCode, X.contactPersonEmail,
                       X.requestId, X.requestSource, X.amountRequested,
                       X.termRequestedCode, X.termRequestedDescription,
                       X.plannedPurchase, X.requestDate, X.requestFormType,
                       X.purchaseOrderRequired, X.accountNumExist,
                       X.clientAccountId, X.orderPending,
                       X.orderPendingAmount, X.styleOfBusinessBectranCode,
                       X.styleOfBusinessClientCode,
                       X.styleOfBusinessDescription,
                       X.typeOfBusinessBectranCode,
                       X.typeOfBusinessClientCode,
                       X.typeOfBusinessDescription, X.annualSalesBectranCode,
                       X.annualSalesClientCode, X.annualSalesDescription,
                       X.numOfEmployeeBectranCode, X.numOfEmployeeClientCode,
                       X.numOfEmployeeDescription
                FROM xml_data,
                XMLTABLE (
                  XMLNAMESPACES(
                    DEFAULT 'http://www.bectran.com/'),
                  '$doc/inbound-customer-data/customer'
                  PASSING xml_data.doc AS "doc"
                COLUMNS
                  account_id VARCHAR(50)
                   PATH '@account-id',
                  transaction_id VARCHAR(50)
                   PATH '@transaction-id',
                  addressLineOne VARCHAR(100)
                    PATH 'basic-info/addressLineOne',
                  addressLineTwo VARCHAR(100)
                    PATH 'basic-info/addressLineTwo',
                  annualSalesRange VARCHAR(50)
                    PATH 'basic-info/annualSalesRange',
                  bectranCustomerId VARCHAR(50)
                    PATH 'basic-info/bectranCustomerId',
                  city VARCHAR(50) PATH 'basic-info/city',
                  contactPersonFirstName VARCHAR(50)
                   PATH 'basic-info/contactPersonFirstName',
                  contactPersonLastName VARCHAR(50)
                   PATH 'basic-info/contactPersonLastName',
                  contactPersonPhone VARCHAR(30)
                   PATH 'basic-info/contactPersonPhone',
                  contactPersonTitle VARCHAR(100)
                   PATH 'basic-info/contactPersonTitle',
                  countryId VARCHAR(10)
                    PATH 'basic-info/countryId',
                  customerDbaName VARCHAR(100)
                    PATH 'basic-info/customerDbaName',
                  customerLegalName VARCHAR(100)
                    PATH 'basic-info/customerLegalName',
                  dateCreatedInBectran VARCHAR(20)
                   PATH 'basic-info/dateCreatedInBectran',
                  dunsNumber VARCHAR(20)
                    PATH 'basic-info/dunsNumber',
                  fax VARCHAR(30)
                    PATH 'basic-info/fax',
                  businessEmail VARCHAR(100)
                    PATH 'basic-info/businessEmail',
                  federalTaxId VARCHAR(20)
                    PATH 'basic-info/federalTaxId',
                  numOfEmployee VARCHAR(50)
                    PATH 'basic-info/numOfEmployee',
                  phone VARCHAR(30)
                    PATH 'basic-info/phone',
                  state VARCHAR(10) PATH 'basic-info/state',
                  stateOfIncorporation VARCHAR(10)
                   PATH 'basic-info/stateOfIncorporation',
                  styleOfBusiness VARCHAR(100)
                    PATH 'basic-info/styleOfBusiness',
                  typeOfBusiness VARCHAR(50)
                    PATH 'basic-info/typeOfBusiness',
                  yearEstablished VARCHAR(10)
                    PATH 'basic-info/yearEstablished',
                  zipCode VARCHAR(20) PATH 'basic-info/zipCode',
                  contactPersonEmail VARCHAR(100)
                   PATH 'basic-info/contactPersonEmail',
                  requestId VARCHAR(50)
                    PATH 'credit-request-info/requestId',
                  requestSource VARCHAR(50)
                    PATH 'credit-request-info/requestSource',
                  amountRequested DECIMAL(15,2)
                   PATH 'credit-request-info/amountRequested',
                  termRequestedCode VARCHAR(50)
                   PATH 'credit-request-info/termRequestedCode',
                  termRequestedDescription VARCHAR(100)
                    PATH
                     'credit-request-info/termRequestedDescription',
                  plannedPurchase VARCHAR(50)
                   PATH 'credit-request-info/plannedPurchase',
                  requestDate VARCHAR(20)
                    PATH 'credit-request-info/requestDate',
                  requestFormType VARCHAR(50)
                    PATH 'credit-request-info/requestFormType',
                  purchaseOrderRequired VARCHAR(10)
                    PATH 'credit-request-info/purchaseOrderRequired',
                  accountNumExist VARCHAR(10)
                   PATH 'credit-request-info/accountNumExist',
                  clientAccountId VARCHAR(50)
                   PATH 'credit-request-info/clientAccountId',
                  orderPending VARCHAR(10)
                    PATH 'credit-request-info/orderPending',
                  orderPendingAmount DECIMAL(15,2)
                   PATH 'credit-request-info/orderPendingAmount',
                  styleOfBusinessBectranCode VARCHAR(50) PATH
                  'customer-profile-detail/styleOfBusiness/bectranInternalCode',
                  styleOfBusinessClientCode VARCHAR(50) PATH
                  'customer-profile-detail/styleOfBusiness/clientInternalCode',
                  styleOfBusinessDescription VARCHAR(100) PATH
                  'customer-profile-detail/styleOfBusiness/description',
                  typeOfBusinessBectranCode VARCHAR(50) PATH
                  'customer-profile-detail/typeOfBusiness/bectranInternalCode',
                  typeOfBusinessClientCode VARCHAR(50) PATH
                  'customer-profile-detail/typeOfBusiness/clientInternalCode',
                  typeOfBusinessDescription VARCHAR(100) PATH
                  'customer-profile-detail/typeOfBusiness/description',
                  annualSalesBectranCode VARCHAR(50) PATH
                  'customer-profile-detail/annualSales/bectranInternalCode',
                  annualSalesClientCode VARCHAR(50) PATH
                  'customer-profile-detail/annualSales/clientInternalCode',
                  annualSalesDescription VARCHAR(100) PATH
                  'customer-profile-detail/annualSales/description',
                  numOfEmployeeBectranCode VARCHAR(50) PATH
                  'customer-profile-detail/numOfEmployee/bectranInternalCode',
                  numOfEmployeeClientCode VARCHAR(50) PATH
                  'customer-profile-detail/numOfEmployee/clientInternalCode',
                  numOfEmployeeDescription VARCHAR(100) PATH
                  'customer-profile-detail/numOfEmployee/description'
                ) AS X
                for read only;

              exec sql open custCursor;
              exec sql
               fetch first from custCursor for :maxRows rows
                into :c1;
              exec sql get diagnostics :rowCount = ROW_COUNT;
              exec sql close custCursor;

              // Process each customer record
              for i = 1 to rowCount;
                custCount += 1;
                wGUID = ReturnGUID();
                // Copy array element to scalar for SQL
                c1Row = c1(i);
                // Insert customer data into BECCUSTP table
                exec sql
                  INSERT INTO BECCUSTP (
                     GUID, ACCTID, TRANID, ADDR1, ADDR2,
                     CITY, STATE, ZIPCODE, COUNTRYID,
                     ANSALRNG, ANSALBEC, ANSALCLI, ANSALDSC,
                     NUMEMP, NUMEMPBEC, NUMEMPCLI, NUMEMPDSC,
                     BECCUSTID, BECCRTDT, CNTFNAME, CNTLNAME,
                     CNTPHONE, CNTTITLE, CNTEMAIL, CUSTDBA,
                     CUSTLEGAL, DUNSNUMBER, FAX, BUSEMAIL,
                     FEDTAXID, PHONE, STINCORP, YRESTAB,
                     STYLEBIZ, STYBIZBEC, STYBIZCLI, STYBIZDSC,
                     TYPEBIZ, TYPBIZBEC, TYPBIZCLI, TYPBIZDSC,
                     REQUESTID, REQSRC, AMTREQ, TERMREQCD,
                     TERMREQDS, PLANPURCH, REQDATE, REQFRMTYP,
                     POREQ, ACNUMEXST, CLIACCTID, ORDPEND,
                     ORDPNDAMT, STATUS, CUSTCRTBY, CUSTCRTTS,
                     CRTTS, UPDTS
                   ) VALUES (
                     :wGUID, :c1Row.account_id,
                     CAST(:c1Row.transaction_id AS INTEGER),
                     :c1Row.addressLineOne, :c1Row.addressLineTwo,
                     :c1Row.city, :c1Row.state, :c1Row.zipCode,
                     :c1Row.countryId, :c1Row.annualSalesRange,
                     :c1Row.annualSalesBectranCode,
                     :c1Row.annualSalesClientCode,
                     :c1Row.annualSalesDescription,
                     :c1Row.numOfEmployee,
                     :c1Row.numOfEmployeeBectranCode,
                     :c1Row.numOfEmployeeClientCode,
                     :c1Row.numOfEmployeeDescription,
                     :c1Row.bectranCustomerId,
                     CASE WHEN :c1Row.dateCreatedInBectran <> ''
                      THEN DATE(:c1Row.dateCreatedInBectran)
                      ELSE NULL END,
                     :c1Row.contactPersonFirstName,
                     :c1Row.contactPersonLastName,
                     :c1Row.contactPersonPhone,
                     :c1Row.contactPersonTitle,
                     :c1Row.contactPersonEmail,
                     :c1Row.customerDbaName,
                     :c1Row.customerLegalName, :c1Row.dunsNumber,
                     :c1Row.fax, :c1Row.businessEmail,
                     :c1Row.federalTaxId, :c1Row.phone,
                     :c1Row.stateOfIncorporation,
                     CASE WHEN :c1Row.yearEstablished <> ''
                      THEN CAST(:c1Row.yearEstablished AS INTEGER)
                      ELSE NULL END,
                     :c1Row.styleOfBusiness,
                     :c1Row.styleOfBusinessBectranCode,
                     :c1Row.styleOfBusinessClientCode,
                     :c1Row.styleOfBusinessDescription,
                     :c1Row.typeOfBusiness,
                     :c1Row.typeOfBusinessBectranCode,
                     :c1Row.typeOfBusinessClientCode,
                     :c1Row.typeOfBusinessDescription,
                     CASE WHEN :c1Row.requestId <> ''
                      THEN CAST(:c1Row.requestId AS INTEGER)
                      ELSE NULL END,
                     :c1Row.requestSource, :c1Row.amountRequested,
                     :c1Row.termRequestedCode,
                     :c1Row.termRequestedDescription,
                     :c1Row.plannedPurchase,
                     CASE WHEN :c1Row.requestDate <> ''
                      THEN DATE(:c1Row.requestDate)
                      ELSE NULL END,
                     :c1Row.requestFormType,
                     :c1Row.purchaseOrderRequired,
                     :c1Row.accountNumExist, :c1Row.clientAccountId,
                     :c1Row.orderPending, :c1Row.orderPendingAmount,
                     ' ', CURRENT_USER, CURRENT_TIMESTAMP,
                     CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
                   );
                // Check for SQL errors
                if SQLCODE <> 0;
                  // Log error - could add to error table
                  // For now, continue processing records
                endif;

              endfor;

              // Archive the processed XML file
              archiveResult = ARCHIVEIFS(pFilePath);
              // Note: Archive errors are non-fatal, processing continues
              // Could add logging here if needed

            end-proc;

            //********************************************************
            // ProcessCreditXML - Process BECTRAN Credit Decision
            //
            // Purpose: Reads and parses credit decision XML file
            //  from BECTRAN, extracting credit decision data and
            //  preparing it for insertion into MINCRON ERP
            //
            // Parameters:
            //  pFilePath - Full IFS path to credit decision XML
            //
            // Returns: None
            //********************************************************
            dcl-proc ProcessCreditXML;
              dcl-pi *n;
                pFilePath varchar(300) const;
              end-pi;

              // Local variables
              dcl-s credCount int(10) inz(0);
              dcl-s rowCount int(10) inz(0);
              dcl-s maxRows int(10) inz(1000);
              dcl-s i int(10) inz(0);
              dcl-s wGUID char(36) inz;
              dcl-ds archiveResult likeds(returnArchiveDS);

              // Credit decision data structure array
              dcl-ds c2 dim(1000) qualified inz;
                account_id varchar(50);
                amountRequested varchar(20);
                approvedLimit varchar(20);
                clientAccountId varchar(50);
                creditTerm varchar(100);
                creditTermCode varchar(50);
                riskRating varchar(20);
                riskRatingClass varchar(20);
                rawScore varchar(20);
                transactionId varchar(50);
                creditDecision varchar(50);
                decisionDate varchar(20);
                nextReviewDate varchar(20);
                requestId varchar(50);
                requestSource varchar(50);
                requestAmountRequested varchar(20);
                termRequestedCode varchar(50);
                termRequestedDescription varchar(100);
                plannedPurchase varchar(50);
                requestDate varchar(20);
                requestFormType varchar(50);
                purchaseOrderRequired varchar(10);
                accountNumExist varchar(10);
                requestClientAccountId varchar(50);
                orderPending varchar(10);
                orderPendingAmount varchar(20);
                addressLineOne varchar(100);
                addressLineTwo varchar(100);
                annualSalesRange varchar(50);
                bectranCustomerId varchar(50);
                city varchar(50);
                contactPersonFirstName varchar(50);
                contactPersonLastName varchar(50);
                contactPersonPhone varchar(30);
                contactPersonTitle varchar(100);
                countryId varchar(10);
                customerDbaName varchar(100);
                customerLegalName varchar(100);
                dateCreatedInBectran varchar(20);
                dunsNumber varchar(20);
                fax varchar(30);
                federalTaxId varchar(20);
                numOfEmployee varchar(50);
                phone varchar(30);
                state varchar(10);
                stateOfIncorporation varchar(10);
                styleOfBusiness varchar(100);
                typeOfBusiness varchar(50);
                yearEstablished varchar(10);
                zipCode varchar(20);
                contactPersonEmail varchar(100);
                personalGuaranteeCode varchar(50);
                personalGuaranteeDesc varchar(200);
                personalGuaranteeValue varchar(10);
                personalGuaranteeDataType varchar(50);
              end-ds;

              // Scalar for SQL operations
              dcl-ds c2Row likeds(c2) inz;

              // Declare cursor and fetch data
              exec sql
                declare credCursor scroll cursor for
                WITH xml_data AS (
                  SELECT XMLPARSE(DOCUMENT
                    REGEXP_REPLACE(
                      LISTAGG(Line, ''), '<\?xml[^>]*\?>',
                      '', 1, 0, 'i')) AS doc
                  FROM TABLE(
                   QSYS2.IFS_READ(PATH_NAME => TRIM(:pFilePath)))
                )
                SELECT X.account_id, X.amountRequested, X.approvedLimit,
                      X.clientAccountId, X.creditTerm, X.creditTermCode,
                      X.riskRating, X.riskRatingClass, X.rawScore,
                      X.transactionId, X.creditDecision, X.decisionDate,
                      X.nextReviewDate, X.requestId, X.requestSource,
                      X.requestAmountRequested, X.termRequestedCode,
                      X.termRequestedDescription, X.plannedPurchase,
                      X.requestDate, X.requestFormType,
                      X.purchaseOrderRequired, X.accountNumExist,
                      X.requestClientAccountId, X.orderPending,
                      X.orderPendingAmount, X.addressLineOne,
                      X.addressLineTwo, X.annualSalesRange,
                      X.bectranCustomerId, X.city,
                      X.contactPersonFirstName, X.contactPersonLastName,
                      X.contactPersonPhone, X.contactPersonTitle,
                      X.countryId, X.customerDbaName, X.customerLegalName,
                      X.dateCreatedInBectran, X.dunsNumber, X.fax,
                      X.federalTaxId, X.numOfEmployee, X.phone, X.state,
                      X.stateOfIncorporation, X.styleOfBusiness,
                      X.typeOfBusiness, X.yearEstablished, X.zipCode,
                      X.contactPersonEmail, X.personalGuaranteeCode,
                      X.personalGuaranteeDesc, X.personalGuaranteeValue,
                      X.personalGuaranteeDataType
                FROM xml_data,
                XMLTABLE (
                  XMLNAMESPACES(
                   DEFAULT 'http://www.bectran.com/'),
                  '$doc/customer-data/customer'
                  PASSING xml_data.doc AS "doc"
                COLUMNS
                  account_id VARCHAR(50) PATH '@account-id',
                  amountRequested VARCHAR(20)
                   PATH 'credit-decision-info/amountRequested',
                  approvedLimit VARCHAR(20)
                    PATH 'credit-decision-info/approvedLimit',
                  clientAccountId VARCHAR(50)
                   PATH 'credit-decision-info/clientAccountId',
                  creditTerm VARCHAR(100)
                    PATH 'credit-decision-info/creditTerm',
                  creditTermCode VARCHAR(50)
                    PATH 'credit-decision-info/creditTermCode',
                  riskRating VARCHAR(20)
                    PATH 'credit-decision-info/riskRating',
                  riskRatingClass VARCHAR(20)
                   PATH 'credit-decision-info/riskRatingClass',
                  rawScore VARCHAR(20)
                    PATH 'credit-decision-info/rawScore',
                  transactionId VARCHAR(50)
                   PATH 'credit-decision-info/transactionId',
                  creditDecision VARCHAR(50)
                   PATH 'credit-decision-info/creditDecision',
                  decisionDate VARCHAR(20)
                    PATH 'credit-decision-info/decisionDate',
                  nextReviewDate VARCHAR(20)
                   PATH 'credit-decision-info/nextReviewDate',
                  requestId VARCHAR(50)
                    PATH 'credit-request-info/requestId',
                  requestSource VARCHAR(50)
                    PATH 'credit-request-info/requestSource',
                  requestAmountRequested VARCHAR(20)
                   PATH 'credit-request-info/amountRequested',
                  termRequestedCode VARCHAR(50)
                   PATH 'credit-request-info/termRequestedCode',
                  termRequestedDescription VARCHAR(100)
                   PATH
                    'credit-request-info/termRequestedDescription',
                  plannedPurchase VARCHAR(50)
                   PATH 'credit-request-info/plannedPurchase',
                  requestDate VARCHAR(20)
                    PATH 'credit-request-info/requestDate',
                  requestFormType VARCHAR(50)
                    PATH 'credit-request-info/requestFormType',
                  purchaseOrderRequired VARCHAR(10)
                   PATH
                    'credit-request-info/purchaseOrderRequired',
                  accountNumExist VARCHAR(10)
                   PATH 'credit-request-info/accountNumExist',
                  requestClientAccountId VARCHAR(50)
                   PATH 'credit-request-info/clientAccountId',
                  orderPending VARCHAR(10)
                    PATH 'credit-request-info/orderPending',
                  orderPendingAmount VARCHAR(20)
                   PATH 'credit-request-info/orderPendingAmount',
                  addressLineOne VARCHAR(100)
                   PATH 'customer-basic-info/addressLineOne',
                  addressLineTwo VARCHAR(100)
                   PATH 'customer-basic-info/addressLineTwo',
                  annualSalesRange VARCHAR(50)
                   PATH 'customer-basic-info/annualSalesRange',
                  bectranCustomerId VARCHAR(50)
                   PATH 'customer-basic-info/bectranCustomerId',
                  city VARCHAR(50)
                    PATH 'customer-basic-info/city',
                  contactPersonFirstName VARCHAR(50)
                   PATH
                    'customer-basic-info/contactPersonFirstName',
                  contactPersonLastName VARCHAR(50)
                   PATH
                    'customer-basic-info/contactPersonLastName',
                  contactPersonPhone VARCHAR(30)
                   PATH 'customer-basic-info/contactPersonPhone',
                  contactPersonTitle VARCHAR(100)
                   PATH 'customer-basic-info/contactPersonTitle',
                  countryId VARCHAR(10)
                    PATH 'customer-basic-info/countryId',
                  customerDbaName VARCHAR(100)
                   PATH 'customer-basic-info/customerDbaName',
                  customerLegalName VARCHAR(100)
                   PATH 'customer-basic-info/customerLegalName',
                  dateCreatedInBectran VARCHAR(20)
                   PATH
                    'customer-basic-info/dateCreatedInBectran',
                  dunsNumber VARCHAR(20)
                    PATH 'customer-basic-info/dunsNumber',
                  fax VARCHAR(30)
                    PATH 'customer-basic-info/fax',
                  federalTaxId VARCHAR(20)
                    PATH 'customer-basic-info/federalTaxId',
                  numOfEmployee VARCHAR(50)
                   PATH 'customer-basic-info/numOfEmployee',
                  phone VARCHAR(30)
                    PATH 'customer-basic-info/phone',
                  state VARCHAR(10)
                    PATH 'customer-basic-info/state',
                  stateOfIncorporation VARCHAR(10)
                   PATH
                    'customer-basic-info/stateOfIncorporation',
                  styleOfBusiness VARCHAR(100)
                   PATH 'customer-basic-info/styleOfBusiness',
                  typeOfBusiness VARCHAR(50)
                    PATH 'customer-basic-info/typeOfBusiness',
                  yearEstablished VARCHAR(10)
                   PATH 'customer-basic-info/yearEstablished',
                  zipCode VARCHAR(20)
                    PATH 'customer-basic-info/zipCode',
                  contactPersonEmail VARCHAR(100)
                   PATH 'customer-basic-info/contactPersonEmail',
                  personalGuaranteeCode VARCHAR(50)
                    PATH 'additional-Info/entry/internal-code',
                  personalGuaranteeDesc VARCHAR(200)
                    PATH 'additional-Info/entry/description',
                  personalGuaranteeValue VARCHAR(10)
                    PATH 'additional-Info/entry/value',
                  personalGuaranteeDataType VARCHAR(50)
                    PATH 'additional-Info/entry/data-type'
                ) AS X
                for read only;

              exec sql open credCursor;
              exec sql
               fetch first from credCursor for :maxRows rows
                into :c2;
              exec sql get diagnostics :rowCount = ROW_COUNT;
              exec sql close credCursor;

              // Process each credit decision record
              for i = 1 to rowCount;
                credCount += 1;
                // Copy array element to scalar for SQL
                c2Row = c2(i);
                // Retrieve GUID from BECCUSTP using account_id
                exec sql
                  SELECT GUID INTO :wGUID
                  FROM BECCUSTP
                  WHERE ACCTID = :c2Row.account_id
                  FETCH FIRST 1 ROW ONLY;
                // Check if GUID was found
                if SQLCODE <> 0;
                  // No matching customer record found, generate new GUID
                  wGUID = ReturnGUID();
                endif;
                // Insert credit decision data into BECCREDP table
                exec sql
                  INSERT INTO BECCREDP (
                     GUID, ACCTID, TRANID, AMTREQ, APPRLMT, CLIACCTID,
                     CRDTERM, CRDTRMCD, RSKRATE, RSKCLASS, RAWSCORE,
                     CRDDEC, DECDATE, NXTREVDT, REQID, REQSRC, REQAMTREQ,
                     TERMREQCD, TERMREQDS, PLANPURCH, REQDATE, REQFRMTYP,
                     POREQ, ACNUMEXST, REQCLIACCT, ORDPEND, ORDPNDAMT,
                     ADDR1, ADDR2, ANSALRNG, BECCUSTID, CITY, CNTFNAME,
                     CNTLNAME, CNTPHONE, CNTTITLE, COUNTRYID, CUSTDBA,
                     CUSTLEGAL, BECCRTDT, DUNSNUMBER, FAX, FEDTAXID,
                     NUMEMP, PHONE, STATE, STINCORP, STYLEBIZ, TYPEBIZ,
                     YRESTAB, ZIPCODE, CNTEMAIL, PGUARCD, PGUARDSC,
                     PGUARVAL, PGUARTYPE, STATUS, CUSTCRTBY, CUSTCRTTS,
                     CRTTS, UPDTS
                   ) VALUES (
                     :wGUID, :c2Row.account_id, :c2Row.transactionId,
                     CASE WHEN :c2Row.amountRequested <> ''
                      THEN CAST(:c2Row.amountRequested AS DECIMAL(15,2))
                      ELSE NULL END,
                     CASE WHEN :c2Row.approvedLimit <> ''
                      THEN CAST(:c2Row.approvedLimit AS DECIMAL(15,2))
                      ELSE NULL END,
                     :c2Row.clientAccountId, :c2Row.creditTerm,
                     :c2Row.creditTermCode, :c2Row.riskRating,
                     :c2Row.riskRatingClass,
                     CASE WHEN :c2Row.rawScore <> ''
                      THEN CAST(:c2Row.rawScore AS DECIMAL(10,2))
                      ELSE NULL END,
                     :c2Row.creditDecision,
                     CASE WHEN :c2Row.decisionDate <> ''
                      THEN DATE(:c2Row.decisionDate)
                      ELSE NULL END,
                     CASE WHEN :c2Row.nextReviewDate <> ''
                      THEN DATE(:c2Row.nextReviewDate)
                      ELSE NULL END,
                     :c2Row.requestId, :c2Row.requestSource,
                     CASE WHEN :c2Row.requestAmountRequested <> ''
                      THEN CAST(:c2Row.requestAmountRequested
                       AS DECIMAL(15,2))
                      ELSE NULL END,
                     :c2Row.termRequestedCode,
                     :c2Row.termRequestedDescription,
                     :c2Row.plannedPurchase,
                     CASE WHEN :c2Row.requestDate <> ''
                      THEN DATE(:c2Row.requestDate)
                      ELSE NULL END,
                     :c2Row.requestFormType,
                     :c2Row.purchaseOrderRequired,
                     :c2Row.accountNumExist,
                     :c2Row.requestClientAccountId, :c2Row.orderPending,
                     CASE WHEN :c2Row.orderPendingAmount <> ''
                      THEN CAST(:c2Row.orderPendingAmount
                       AS DECIMAL(15,2))
                      ELSE NULL END,
                     :c2Row.addressLineOne, :c2Row.addressLineTwo,
                     :c2Row.annualSalesRange, :c2Row.bectranCustomerId,
                     :c2Row.city, :c2Row.contactPersonFirstName,
                     :c2Row.contactPersonLastName,
                     :c2Row.contactPersonPhone, :c2Row.contactPersonTitle,
                     :c2Row.countryId, :c2Row.customerDbaName,
                     :c2Row.customerLegalName,
                     CASE WHEN :c2Row.dateCreatedInBectran <> ''
                      THEN DATE(:c2Row.dateCreatedInBectran)
                      ELSE NULL END,
                     :c2Row.dunsNumber, :c2Row.fax, :c2Row.federalTaxId,
                     :c2Row.numOfEmployee, :c2Row.phone, :c2Row.state,
                     :c2Row.stateOfIncorporation, :c2Row.styleOfBusiness,
                     :c2Row.typeOfBusiness,
                     CASE WHEN :c2Row.yearEstablished <> ''
                      THEN CAST(:c2Row.yearEstablished AS INTEGER)
                      ELSE NULL END,
                     :c2Row.zipCode, :c2Row.contactPersonEmail,
                     :c2Row.personalGuaranteeCode,
                     :c2Row.personalGuaranteeDesc,
                     :c2Row.personalGuaranteeValue,
                     :c2Row.personalGuaranteeDataType, ' ',
                     CURRENT_USER, CURRENT_TIMESTAMP,
                     CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
                   );
                // Check for SQL errors
                if SQLCODE <> 0;
                  // Log error - could add to error table
                  // For now, continue processing records
                endif;

              endfor;

              // Archive the processed XML file
              archiveResult = ARCHIVEIFS(pFilePath);
              // Note: Archive errors are non-fatal, processing continues
              // Could add logging here if needed

            end-proc;

            //********************************************************
            // DownloadBectranFiles - Download files from BECTRAN SFTP
            //
            // Purpose: Connects to BECTRAN SFTP server, lists files,
            //  and downloads them to the IFS /home/bectran directory
            //
            // Parameters: None
            //
            // Returns: None
            //********************************************************
            dcl-proc DownloadBectranFiles;

              // Local variables
              dcl-s RemoteLocation char(10) inz('BECTRAN');
              dcl-s ProdTest char(10);
              dcl-s Q char(1) inz('''');
              dcl-s FileName varchar(200);
              dcl-s FileCount int(10) inz(0);
              dcl-s MsgText char(52);
              dcl-s ErrorMessage char(200);

              // Create table in QTEMP
              exec sql
                create or replace table qtemp.bectranp (
                  string char(200)
                );

              // Retrieve production/test indicator
              exec sql
                select char(qgpl.prodtest)
                into :ProdTest
                from sysibm.sysdummy1;

              // If not production, use test location
              if ProdTest <> 'PROD';
                RemoteLocation = 'BECTRANT';
              endif;

              // Build and execute AFSTRFTP command
              monitor;
                commandString = 'AFSTRFTP SVRDFN('
                                + %trim(RemoteLocation) + ')';
                OutErrorDS = runIBMCommand(commandString);

                MsgText = 'FTP Start: ' + %trim(RemoteLocation);
                dsply MsgText;
              on-error;
                ErrorMessage = 'Error starting FTP connection to '
                               + %trim(RemoteLocation);
                SendErrorEmail(ErrorMessage);
                return;
              endmon;

              // Change to remote directory
              monitor;
                commandString = 'AFCHDIR DIRECT(' + Q
                                + '/TN2026021289684xml/inb/wip' + Q + ')';
                OutErrorDS = runIBMCommand(commandString);

                MsgText = 'Changed to remote directory';
                dsply MsgText;
              on-error;
                ErrorMessage = 'Error changing to remote directory';
                SendErrorEmail(ErrorMessage);
                return;
              endmon;

              // List files in remote directory to QTEMP table
              monitor;
                commandString = 'AFLIST OUTPUT(*DBF) OBJECTS(*FILES) '
                                + 'SORT(*NAME) VIEW(*SHORT) '
                                + 'TODBF(QTEMP/BECTRANP)';
                OutErrorDS = runIBMCommand(commandString);

                MsgText = 'Files listed to QTEMP/BECTRANP';
                dsply MsgText;
              on-error;
                ErrorMessage = 'Error listing remote directory files';
                SendErrorEmail(ErrorMessage);
                return;
              endmon;

              // Read through the BECTRANP table and download each file
              exec sql
                declare c1 cursor for
                  select trim(string)
                  from qtemp.bectranp
                  where string is not null
                    and string <> ''
                  order by string;

              exec sql
                open c1;

              exec sql
                fetch c1 into :FileName;

              dow sqlcode = 0;
                FileCount += 1;

                // Display the filename being processed
                if %len(%trim(FileName)) > 45;
                  MsgText = 'File: ' + %subst(%trim(FileName):1:45);
                else;
                  MsgText = 'File: ' + %trim(FileName);
                endif;
                dsply MsgText;

                // Download file from SFTP to IFS
                monitor;
                  commandString = 'AFGETIFS RMTPATH(' + Q
                                  + '/TN2026021289684xml/inb/wip/'
                                  + %trim(FileName) + Q + ') IFSPATH(' + Q
                                  + '/home/bectran/' + %trim(FileName)
                                  + Q + ')';
                  OutErrorDS = runIBMCommand(commandString);

                  if %len(%trim(FileName)) > 40;
                    MsgText = 'Downloaded: '
                              + %subst(%trim(FileName):1:40);
                  else;
                    MsgText = 'Downloaded: ' + %trim(FileName);
                  endif;
                  dsply MsgText;
                on-error;
                  ErrorMessage = 'Error downloading file: '
                                 + %trim(FileName);
                  SendErrorEmail(ErrorMessage);
                endmon;

                exec sql
                  fetch c1 into :FileName;
              enddo;

              exec sql
                close c1;

              MsgText = 'Total files: ' + %char(FileCount);
              dsply MsgText;

              // End FTP connection
              commandString = 'AFENDFTP';
              OutErrorDS = runIBMCommand(commandString);

              MsgText = 'FTP connection ended';
              dsply MsgText;

            end-proc;

            //********************************************************
            // SendErrorEmail - Send error notification email
            //
            // Purpose: Sends error notification email to IT department
            //
            // Parameters:
            //  ErrorMsg - Error message to include in email
            //
            // Returns: None
            //********************************************************
            dcl-proc SendErrorEmail;
              dcl-pi *n;
                ErrorMsg char(200) const;
              end-pi;

              // Local variables
              dcl-s EmailErrorMessage char(80);
              dcl-s MsgText char(52);

              // Set email subject and body
              emailList.Subject = 'BECTRAN Error - FTP Process';
              emailList.Note = 'An error occurred in BECTRAN program: '
                               + %trim(ErrorMsg);

              // Email ID for the body
              emailList.bodyID = 1;

              // Send to IT department
              emailList.address(1) = 'ITDEPT@ecmdi.com';
              emailList.type(1) = 'P';

              // Send the email
              reset EmailErrorMessage;
              EmailErrorMessage = sendEmail(EmailList);

              // Log that email was sent
              MsgText = 'Error email sent to IT';
              dsply MsgText;

            end-proc;







