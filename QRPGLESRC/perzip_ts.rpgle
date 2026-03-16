     H DFTACTGRP(*No) BNDDIR('ECBIND') OPTION(*SRCSTMT: *NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - PERZIP                                                 *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D run address validation process                                        *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    run  address validation process                                    *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3182 011226 JJF created program                                 *
     F*M ----------------------------------------------------------------------*

        // PERZIP  - run a command
            dcl-s someReturnField char(80) inz;

         /COPY qcpysrc,PERZIP_CP


         // run command
        // Initialize test data
        reset addressParmDS;
        addressParmDS.inAddress1 = 'GREENVILLE MEMORIAL HOSPITAL';
        addressParmDS.inAddress2 = 'GATE 1 701 GROVE RD';
        addressParmDS.inAddress3 = 'SUITE 114 BMB158';
        addressParmDS.inCity = 'GREENVILLE';
        addressParmDS.inState = 'SC';
        addressParmDS.inzip = '29605';
        addressParmDS.returncase = 'U';
        addressParmDS.maxAddressLength = 30;
        addressParmDS.runFullAddressCheck = 'Y';
        addressParmDS.addressType = 'S';
        // ------------------------------------------------------------
        // Address Type Reference
        //   M = Mailing Address
        //       - Used for correspondence only
        //       - Can be PO Box or non-physical location
        //       - Not guaranteed to be deliverable for shipments
        //
        //   S = Street / Shipping Address
        //       - Must be a physical, serviceable location
        //       - Required for deliveries and geocoding
        //       - Used for street-level match indicators (E/S/P/Z/N/U)
        // ------------------------------------------------------------

         // Call the validation service
         addressParmDS = validateAddress(addressParmDS);


         *inlr = *on;
