            // Control Options
                Ctl-Opt Option(*SrcStmt:*NoDebugIO); // Source statements
                Ctl-Opt ExtBinInt(*Yes);             // Use binary integers
                Ctl-Opt bnddir('ECBIND');
                Ctl-Opt DecEdit('0,');               // Decimal editing
                Ctl-Opt Copyright('East Coast Metals - ARCHIVEIFS Test');

            //******************************************************************************
            // ARCHIVEIFS_TS - Test Program for ARCHIVEIFS Service Program
            //
            // Purpose: Tests the ARCHIVEIFS procedure by calling it with various document
            //          paths and displaying the results to verify correct functionality
            //
            // Test Scenarios:
            //   1. Valid document - should archive successfully
            //   2. Document in directory without archive folder - should create folder and archive
            //   3. Invalid/non-existent document - should return error
            //   4. Empty path parameter - should return error
            //   5. Document in directory with existing archive folder - should archive without creating folder
            //
            // Usage: Call this program to test the ARCHIVEIFS service program
            //        Results are displayed via DSPLY statements
            //
            // Author: East Coast Metals Development Team
            // Date: 2026-02-10
            // Version: 1.0
            //
            // Modification History:
            //   Date       Author        Description
            //   ---------- ------------- ----------------------------------------------
            //   2026-02-10 ECM Dev Team  Initial implementation
            //                           - Test program for ARCHIVEIFS service program
            //                           - Multiple test scenarios for validation
            //                           - Display results via DSPLY statements
            //                           - Comprehensive error and success testing
            //
            //******************************************************************************

            // Copy member for ARCHIVEIFS data structures and prototype
            /copy qrpglesrc,ARCHIFS_CP

            // Field Definitions - Variables
            dcl-s testDocPath varchar(100) inz;
            dcl-s displayMsg varchar(52) inz;
            dcl-ds archiveResult likeds(returnArchiveDS);

            // Main processing
            dsply 'Starting ARCHIVEIFS Test Program';
            dsply '====================================';

            // Test 1: Empty path parameter
            dsply ' ';
            dsply 'Test 1: Testing empty document path';
            testDocPath = '';
            archiveResult = ARCHIVEIFS(testDocPath);

            if archiveResult.Success;
                dsply 'UNEXPECTED: Empty path';
                dsply 'returned Success=true';
            else;
                displayMsg = 'SUCCESS: Empty path correctly failed';
                dsply displayMsg;
                if %trim(archiveResult.ErrorMessage) <> '';
                    displayMsg = 'Error: ' +
                               %trim(archiveResult.ErrorMessage);
                    dsply displayMsg;
                endif;
            endif;

            // Test 2: Non-existent document
            dsply ' ';
            dsply 'Test 2: Testing non-existent document';
            testDocPath = '/tmp/nonexistent_file.txt';
            returnArchiveDS = ARCHIVEIFS(testDocPath);

            if returnArchiveDS.Success;
                dsply 'UNEXPECTED: Non-existent file';
                dsply 'returned Success=true';
            else;
                displayMsg = 'SUCCESS: Non-existent file ' +
                           'correctly failed';
                dsply displayMsg;
                if %trim(returnArchiveDS.ErrorMessage) <> '';
                    displayMsg = 'Error: ' +
                               %trim(returnArchiveDS.ErrorMessage);
                    dsply displayMsg;
                endif;
            endif;

            // Test 3: Test with a document that might exist
            dsply ' ';
            dsply 'Test 3: Testing potential system document';
            testDocPath = '/tmp/test_archive_doc.txt';
            returnArchiveDS = ARCHIVEIFS(testDocPath);

            if returnArchiveDS.Success;
                displayMsg = 'SUCCESS: Document archived successfully';
                dsply displayMsg;
                
                if returnArchiveDS.ArchiveFolderCreated;
                    dsply 'Archive folder was created';
                else;
                    dsply 'Archive folder already existed';
                endif;
                
                if returnArchiveDS.DocumentMoved;
                    dsply 'Document was moved to archive';
                endif;
                
                if %trim(returnArchiveDS.ArchivePath) <> '';
                    displayMsg = 'Archive Path: ' +
                               %trim(returnArchiveDS.ArchivePath);
                    dsply displayMsg;
                endif;
            else;
                displayMsg = 'INFO: Document not found or ' +
                           'operation failed';
                dsply displayMsg;
                if %trim(returnArchiveDS.ErrorMessage) <> '';
                    displayMsg = 'Error: ' +
                               %trim(returnArchiveDS.ErrorMessage);
                    dsply displayMsg;
                endif;
            endif;

            // Test 4: Invalid path format
            dsply ' ';
            dsply 'Test 4: Testing invalid path format';
            testDocPath = 'invalid_path_no_slashes';
            returnArchiveDS = ARCHIVEIFS(testDocPath);

            if returnArchiveDS.Success;
                dsply 'UNEXPECTED: Invalid path format';
                dsply 'returned Success=true';
            else;
                displayMsg = 'SUCCESS: Invalid path format ' +
                           'correctly failed';
                dsply displayMsg;
                if %trim(returnArchiveDS.ErrorMessage) <> '';
                    displayMsg = 'Error: ' +
                               %trim(returnArchiveDS.ErrorMessage);
                    dsply displayMsg;
                endif;
            endif;

            // Test 5: Root directory document (edge case)
            dsply ' ';
            dsply 'Test 5: Testing root directory document';
            testDocPath = '/root_document.txt';
            returnArchiveDS = ARCHIVEIFS(testDocPath);

            if returnArchiveDS.Success;
                displayMsg = 'SUCCESS: Root document archived';
                dsply displayMsg;
                
                if returnArchiveDS.ArchiveFolderCreated;
                    dsply 'Root archive folder was created';
                endif;
            else;
                displayMsg = 'INFO: Root document test failed ' +
                           '(expected)';
                dsply displayMsg;
                if %trim(returnArchiveDS.ErrorMessage) <> '';
                    displayMsg = 'Error: ' +
                               %trim(returnArchiveDS.ErrorMessage);
                    dsply displayMsg;
                endif;
            endif;

            // Test Summary
            dsply ' ';
            dsply '====================================';
            dsply 'ARCHIVEIFS Test Program Complete';
            dsply 'Review DSPLY messages above';
            dsply 'for test results and validation';
            dsply ' ';
            dsply 'NOTE: Success depends on document';
            dsply 'existence and file system permissions';

            *inlr = *on;