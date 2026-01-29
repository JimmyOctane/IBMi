     F*------------------------------------------------------------------*
     F*N PROGRAM NAME - PERZIP                                          *
     F*------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                    *
     F*------------------------------------------------------------------*
     F*D address validation using PERZIP                                *
     F*------------------------------------------------------------------*
     F*S PURPOSE:                                                        *
     F*S    Per Zip Address Validation                                  *
     F*S                                                                 *
     F*S SPECIAL NOTES:                                                 *
     F*S                                                                 *
     F*M ----------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                              *
     F*M ---------- ------ --- -----------------------------------------*
     F*V JJF   3182 010826 JJF created program                          *
     F*M ----------------------------------------------------------------*
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
            end-ds;
