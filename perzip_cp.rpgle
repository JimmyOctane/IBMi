     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - PERZIP                                                 *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D address validation using PERZIP                                       *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    Per Zip Address Validation                                         *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3182 010826 JJF created program                                 *
     F*M ----------------------------------------------------------------------*
        // PERZIP - Per Zip Address Validation
        dcl-pr validateAddress char(2000);
        end-pr;

            dcl-ds AddressParmDS qualified;
             inAdressname       char(30);   // Input address name
             inAddress1         char(30);   // Input address line 1
             inAddress2         char(30);   // Input address line 2
             inAddress3         char(30);   // Input address line 3
             inCity             char(25);   // Input city
             inState            char(2);    // Input state
             inzip              char(10);   // Input zip
             outAddress1        char(30);   // Output address line 1
             outAddress2        char(30);   // Output address line 2
             outAddress3        char(30);   // Output address line 3
             outCity            char(25);   // Output city
             outState           char(2);    // Output state
             outZip             char(10);   // Output zip
             returncase         char(1);    // Address case
             errorCode          char(3);    // Error code
             errorMessage       char(80);   // Error message
             maxadressLength    char(2);    // Max address length
             addressType        char(1);    // Address type (M/S)
            end-ds;

