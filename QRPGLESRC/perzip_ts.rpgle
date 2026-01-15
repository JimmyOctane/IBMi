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

         /COPY qrpglesrc,PERZIP_CP


         // run command
        // Initialize test data
        reset addressParmDS;
        addressParmDS.inCity = 'STREATOR';
        addressParmDS.inState = 'IL';
        addressParmDS.inzip = '61364';
        addressParmDS.returncase = 'U';
        addressParmDS.maxadressLength = '30';
        addressParmDS.addressType = 'S';
      // Call the validation service
        addressParmDS = validateAddress(addressParmDS);


         *inlr = *on;
