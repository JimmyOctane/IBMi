       // ------------------------------------------------------------------
       // PROGRAM NAME - PERZIP
       // ------------------------------------------------------------------
       // COPYRIGHT East Coast Metals
       // ------------------------------------------------------------------
       // address validation using PERZIP
       // ------------------------------------------------------------------
       // PURPOSE:
       //    Per Zip Address Validation
       //
       // SPECIAL NOTES:
       //
       // ----------------------------------------------------------------
       // PER/ZIP4 ERROR CODE DESCRIPTIONS:
       // ----------------------------------------------------------------
       // ADR - insufficient address information
       // ALT - address changed from alternate to base
       // ANS - address not on street
       // BNC - PO Box not found in city (finance number)
       // BNR - Box missing or not found in RR/HC (default taken)
       // DBE - USPS database exception (firm required to make match)
       // DBX - US Postal Service database has expired
       // DPV - Delivery Point Validation failed
       // EWS - Early Warning System (EWS) match
       // LLK - address changed by LACSLink processing
       // LLN - insufficient last line (city, state, ZIP) information
       // MLT - multiple addresses found
       // NDA - nondelivery address
       // PGM - program error
       // PWX - Password has expired
       // RNF - RR/HC number not found in city (finance number)
       // SIZ - Address cannot be abbreviated to given length
       // SLK - address changed by SuiteLink processing
       // SNF - street not found in city (finance number)
       // STR - street name not found
       // XST - ZIP+4 database member missing for state
       // ----------------------------------------------------------------
       // ----------------------------------------------------------------
       // TASK       DATE   ID  DESCRIPTION
       // ---------- ------ --- -----------------------------------------
       // JJF   3182 010826 JJF created program
       // ----------------------------------------------------------------
        // Address Validation Service
        dcl-pr validateAddress likeds(AddressParmDS);
         pAddressDS likeds(AddressParmDS) const;
        end-pr;

            dcl-ds AddressParmDS qualified;
             inAddressname      char(30);   // Input name
             inAddress1         char(30);   // Input addr 1
             inAddress2         char(30);   // Input addr 2
             inAddress3         char(30);   // Input addr 3
             inCity             char(25);   // Input city
             inState            char(2);    // Input state
             inzip              char(10);   // Input zip
             outAddress1        char(30);   // Output addr 1
             outAddress2        char(30);   // Output addr 2
             outAddress3        char(30);   // Output addr 3
             outCity            char(25);   // Output city
             outState           char(2);    // Output state
             outZip             char(10);   // Output zip
             returncase         char(1);    // Address case
             errorCode          char(3);    // Error code
             errorMessage       char(80);   // Error message
             maxaddressLength   zoned(2: 0); // Max addr len
             addressType        char(1);    // Addr type M/S
             runFullAddressCheck char(1);   // Y=full check, N=basic
            end-ds;
