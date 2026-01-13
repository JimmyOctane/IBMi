     H DFTACTGRP(*No) BNDDIR('ECBIND') OPTION(*SRCSTMT: *NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - PERZIP_TS                                            *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                          *
     F*------------------------------------------------------------------------*
     F*D Test Program for PERZIP Address Validation                           *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                             *
     F*S    Test the PERZIP address validation service program                *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                       *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                    *
     F*M ---------- ------ --- -----------------------------------------------*
     F*V JJF   3182 012626 JJF created test program                           *
     F*M ----------------------------------------------------------------------*

        // PERZIP Address Validation Test Program
        
     /COPY qrpglesrc,PERZIP_CP

        dcl-s resultDS likeds(AddressParmDS);

        *inlr = *on;

        // Initialize test data
        reset addressParmDS;
        addressParmDS.inCity = 'STREATOR';
        addressParmDS.inState = 'IL';
        addressParmDS.inzip = '61364';
        addressParmDS.returncase = 'U';
        addressParmDS.maxadressLength = '30';
        addressParmDS.addressType = 'S';

        // Call the validation service
        resultDS = validateAddress(addressParmDS);

        // Display results
        dsply ('Input City: ' + %trim(addressParmDS.inCity));
        dsply ('Input State: ' + %trim(addressParmDS.inState));
        dsply ('Input ZIP: ' + %trim(addressParmDS.inzip));
        dsply ('---Results---');
        dsply ('Output City: ' + %trim(resultDS.outCity));
        dsply ('Output State: ' + %trim(resultDS.outState));
        dsply ('Output ZIP: ' + %trim(resultDS.outZip));
        dsply ('Error Code: ' + %trim(resultDS.errorCode));
        
        if resultDS.errorCode <> *blanks;
           dsply ('Error Msg: ' + %trim(resultDS.errorMessage));
        endif;

        return;
