            // Control Options
                Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
                Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
                Ctl-Opt bnddir('ECBIND');
                Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
                Ctl-Opt Copyright('East Coast Metals - LISTIFS Test Program');

            //******************************************************************************
            // TESTLIFS - Test Program for LISTIFS Service Program
            //
            // Purpose: Tests the LISTIFS procedure by calling it with various IFS directory
            //          paths and displaying the results to verify correct functionality
            //
            // Test Scenarios:
            //   1. Valid directory with files - should return file list
            //   2. Empty directory - should return Found=true, FileCount=0
            //   3. Invalid/non-existent directory - should return Found=false
            //   4. Empty path parameter - should return Found=false
            //
            // Usage: Call this program to test the LISTIFS service program
            //        Results are displayed via DSPLY statements
            //
            // Author: East Coast Metals Development Team
            // Date: 2026-02-05
            // Version: 1.1
            //
            // Modification History:
            //   Date       Author        Description
            //   ---------- ------------- ----------------------------------------------
            //   2026-02-05 ECM Dev Team  Initial implementation
            //                           - Test program for LISTIFS service program
            //                           - Multiple test scenarios for validation
            //                           - Display results via DSPLY statements
            //   2026-02-09 ECM Dev Team  Added subtree parameter support
            //                           - Updated all LISTIFS calls with subtreeOption parameter
            //                           - Fixed data structure reference (returnListDS -> returnIFSDocumentsDS)
            //                           - Enhanced test program for new procedure signature
            //
            //******************************************************************************

            // Copy member for LISTIFS data structures and prototype
            /copy qcpysrc,LISTIFS_CP

            // Field Definitions - Variables
            dcl-s testPath varchar(50) inz;
            dcl-s subtreeOption ind inz(*off);
            dcl-s i packed(5:0) inz;
            dcl-s displayMsg varchar(30) inz;
            dcl-ds returnIFSFolderListDS likeds(returnIFSDocumentsDS);

            // Main processing
            dsply 'Starting LISTIFS Test Program';
            dsply '================================';

            // Test 1: Valid directory with potential files
            dsply ' ';
            dsply 'Test 1: Testing /tmp directory';
            testPath = '/tmp';
            returnIFSFolderListDS = LISTIFS(testPath:subtreeOption);

            if returnIFSFolderListDS.Found;
                displayMsg = 'SUCCESS: Found=' +
                %char(returnIFSFolderListDS.Found) +
                            ' FileCount=' +
                            %char(returnIFSFolderListDS.FileCount);
                dsply displayMsg;

                // Display first few files found (max 10 for readability)
                if returnIFSFolderListDS.FileCount > 0;
                for i = 1 to %min(returnIFSFolderListDS.FileCount : 10);
                    displayMsg = 'File ' + %char(i) + ': ' +
                          %trim(returnIFSFolderListDS.FileNames(i));
                    dsply displayMsg;
                endfor;

                if returnIFSFolderListDS.FileCount > 10;
                    displayMsg = '... and ' +
                    %char(returnIFSFolderListDS.FileCount - 10) +
                    ' more files';
                    dsply displayMsg;
                endif;
                else;
                dsply 'Directory is empty';
                endif;
            else;
                dsply 'FAILED: Could not access /tmp directory';
            endif;

            // Test 2: Home directory
            dsply ' ';
            dsply 'Test 2: Testing /home directory';
            testPath = '/home';
            returnIFSFolderListDS = LISTIFS(testPath:subtreeOption);

            if returnIFSFolderListDS.Found;
                displayMsg =
                'SUCCESS: Found=' + %char(returnIFSFolderListDS.Found) +
                  ' FileCount=' + %char(returnIFSFolderListDS.FileCount);
                dsply displayMsg;

                // Display first few files/directories found
                if returnIFSFolderListDS.FileCount > 0;
                for i = 1 to %min(returnIFSFolderListDS.FileCount : 5);
                    displayMsg = 'Item ' + %char(i) + ': ' +
                                %trim(returnIFSFolderListDS.FileNames(i));
                    dsply displayMsg;
                endfor;
                endif;
            else;
                dsply
                'FAILED: Could not access /home directory';
            endif;

            // Test 3: Invalid directory
            dsply ' ';
            dsply 'Test 3: Testing invalid directory';
            testPath = '/nonexistent/invalid/path';
            returnIFSFolderListDS = LISTIFS(testPath:subtreeOption);

            if returnIFSFolderListDS.Found;
                displayMsg =
                'UNEXPECTED: Invalid path returned Found=true, FileCount=' +
                            %char(returnIFSFolderListDS.FileCount);
                dsply displayMsg;
            else;
                dsply
                'SUCCESS: Invalid path correctly returned Found=false';
            endif;

            // Test 4: Empty path
            dsply ' ';
            dsply 'Test 4: Testing empty path';
            testPath = '';
            returnIFSFolderListDS = LISTIFS(testPath:subtreeOption);

            if returnIFSFolderListDS.Found;
                displayMsg =
                'UNEXPECTED: Empty path returned Found=true, FileCount=' +
                            %char(returnIFSFolderListDS.FileCount);
                dsply displayMsg;
            else;
                dsply 'SUCCESS: Empty path correctly returned Found=false';
            endif;

            // Test 5: QSys library (should have many stream files)
            dsply ' ';
            dsply 'Test 5: Testing /QSYS.LIB directory';
            testPath = '/QSYS.LIB';
            returnIFSFolderListDS = LISTIFS(testPath:subtreeOption);

            if returnIFSFolderListDS.Found;
                displayMsg = 'SUCCESS: Found=' +
                %char(returnIFSFolderListDS.Found) +
                            ' FileCount=' +
                            %char(returnIFSFolderListDS.FileCount);
                dsply displayMsg;

                // Display first few items found
                if returnIFSFolderListDS.FileCount > 0;
                for i = 1 to %min(returnIFSFolderListDS.FileCount : 3);
                    displayMsg = 'Library ' + %char(i) + ': ' +
                                %trim(returnIFSFolderListDS.FileNames(i));
                    dsply displayMsg;
                endfor;
                endif;
            else;
                dsply 'FAILED: Could not access /QSYS.LIB directory';
            endif;

            // Test Summary
            dsply ' ';
            dsply '================================';
            dsply 'LISTIFS Test Program Complete';
            dsply 'Review DSPLY messages above';
            dsply 'for test results and validation';

            *inlr = *on;
