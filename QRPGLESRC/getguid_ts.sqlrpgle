            // Control Options
            Ctl-Opt DftActGrp(*No) ActGrp(*New);
            Ctl-Opt Option(*SrcStmt:*NoDebugIO);
            Ctl-Opt ExtBinInt(*Yes);
            Ctl-Opt DecEdit('0,');
            Ctl-Opt BndDir('ECBIND');
            Ctl-Opt Copyright('East Coast Metals - GETGUID Test');

            //*************************************************************
            // GETGUID_TS - Test Program for GETGUID Service Program
            //
            // Purpose: Tests the ReturnGUID procedure by generating
            //          multiple GUIDs and displaying them to verify
            //          correct functionality
            //
            // Author: East Coast Metals Development Team
            // Date: 2026-03-03
            //
            // Usage: Call this program to test the GETGUID service
            //        program. Results are displayed via DSPLY.
            //
            //*************************************************************

            // Copy member for GETGUID prototype
            /Copy qcpysrc,GETGUID_CP

            // Standalone Variables
            Dcl-S testGuid Char(36);
            Dcl-S counter Int(5);
            Dcl-S displayMsg Char(52);

            // Main processing
            Dsply 'Starting GETGUID Test Program';
            Dsply '================================';
            Dsply ' ';

            // Test 1: Generate a single GUID
            Dsply 'Test 1: Generate Single GUID';
            testGuid = ReturnGUID();
            displayMsg = 'GUID: ' + testGuid;
            Dsply displayMsg;
            Dsply ' ';

            // Test 2: Generate multiple GUIDs
            Dsply 'Test 2: Generate 5 GUIDs';
            For counter = 1 To 5;
              testGuid = ReturnGUID();
              displayMsg = 'GUID ' + %Char(counter) + ': ' + testGuid;
              Dsply displayMsg;
            EndFor;
            Dsply ' ';

            // Test 3: Verify GUID format
            Dsply 'Test 3: Verify GUID Format';
            testGuid = ReturnGUID();
            displayMsg = 'Generated: ' + testGuid;
            Dsply displayMsg;

            If %Subst(testGuid:9:1) = '-' And
               %Subst(testGuid:14:1) = '-' And
               %Subst(testGuid:19:1) = '-' And
               %Subst(testGuid:24:1) = '-';
              Dsply 'Format Check: PASSED - Dashes correct';
            Else;
              Dsply 'Format Check: FAILED - Invalid dash positions';
            EndIf;

            If %Len(%Trim(testGuid)) = 36;
              Dsply 'Length Check: PASSED - 36 characters';
            Else;
              displayMsg = 'Length Check: FAILED - ' +
                           %Char(%Len(%Trim(testGuid))) + ' chars';
              Dsply displayMsg;
            EndIf;

            Dsply ' ';
            Dsply '================================';
            Dsply 'GETGUID Test Program Complete';
            Dsply 'Review DSPLY messages above';

            *InLR = *On;
            Return;
