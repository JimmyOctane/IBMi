            // Control Options
                Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
                Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
                Ctl-Opt bnddir('ECBIND');
                Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
                Ctl-Opt Copyright('East Coast Metals - NEUORDPRC Program');
    
                //******************************************************************************
                // NEUORDPRC - Neuco Order Processing Batch Program
                //
                // Purpose: Automated batch processor for Neuco XML order documents stored in
                //          the IFS. Scans the /home/neuco/ directory, processes each XML file
                //          to extract order data into database tables, and archives successfully
                //          processed files with comprehensive error tracking and reporting.
                //
                // Processing Flow:
                //   1. Scan /home/neuco/ directory using LISTIFS service program
                //   2. Validate directory accessibility and file count
                //   3. For each XML file found:
                //      a. Build full IFS path
                //      b. Process XML using NEUCOXML service program
                //      c. Parse order header, detail, and line item data
                //      d. Insert records into XMLORDHDR, XMLORDDTL, XMLORDAUD tables
                //      e. Archive successfully processed files using ARCHIVEIFS
                //   4. Display comprehensive processing summary with statistics
                //
                // Dependencies:
                //   - LISTIFS service program (IFS directory listing)
                //   - NEUCOXML service program (XML parsing and database insertion)
                //   - ARCHIVEIFS service program (file archival with timestamp)
                //
                // Database Tables:
                //   - XMLORDHDR (Order header data)
                //   - XMLORDDTL (Order detail/line items)
                //   - XMLORDAUD (Processing audit trail)
                //
                // Usage: CALL NEUORDPRC
                //        Processing status and results displayed via DSPLY statements
                //        Check XMLORDAUD table for detailed audit logs and error messages
                //
                // Author: Roo Code
                // Date: 2026-02-17
                // Version: 1.0
                //
                // Modification History:
                //   Date       Author        Description
                //   ---------- ------------- ----------------------------------------------
                //   2026-02-17 Roo Code      Initial implementation
                //                           - IFS directory scanning
                //                           - XML order document processing
                //                           - Automatic file archival
                //                           - Processing statistics tracking
                //
                //******************************************************************************

            // Copy members for service program prototypes
            /copy qcpysrc,LISTIFS_CP
            /copy qcpysrc,NEUXMLR_CP
            /copy qcpysrc,ARCHIFS_CP

            // Field Definitions - Variables
            dcl-s neucoPath varchar(1000) inz('/home/neuco/');
            dcl-s subtreeOption ind inz(*off);
            dcl-s fullPath varchar(1000) inz;
            dcl-s i packed(5:0) inz;
            dcl-s processResult ind inz;
            dcl-s successCount int(10) inz(0);
            dcl-s errorCount int(10) inz(0);
            dcl-s archiveCount int(10) inz(0);
            dcl-s archiveErrorCount int(10) inz(0);
            dcl-s displayMsg varchar(100) inz;

            // Data structures
            dcl-ds fileListDS likeds(returnIFSDocumentsDS);
            dcl-ds archiveResult likeds(returnArchiveDS);

            // Main processing
            dsply 'Starting PROCNEUCO - Neuco XML Processor';
            dsply '=========================================';
            dsply ' ';

            // Step 1: Get list of files in /home/neuco/ directory
            dsply ('Scanning directory: ' + %trim(neucoPath));
            fileListDS = LISTIFS(neucoPath : subtreeOption);

            // Check if directory was found and accessible
            if not fileListDS.Found;
                dsply 'ERROR: Cannot access /home/neuco/ directory';
                dsply 'Processing aborted';
                *inlr = *on;
                return;
            endif;

            // Display file count
            displayMsg = 'Files found: ' + %char(fileListDS.FileCount);
            dsply displayMsg;

            // Check if any files exist
            if fileListDS.FileCount = 0;
                dsply 'No files to process';
                dsply 'Processing complete';
                *inlr = *on;
                return;
            endif;

            dsply ' ';
            dsply 'Beginning file processing...';
            dsply '----------------------------';

            // Step 2: Loop through each file and process
            for i = 1 to fileListDS.FileCount;
                // Build full IFS path
                fullPath = %trim(neucoPath) + %trim(fileListDS.FileNames(i));

                // Display current file being processed
                displayMsg = 'Processing file ' + %char(i) + ' of ' +
                            %char(fileListDS.FileCount);
                dsply displayMsg;
                displayMsg = 'File: ' + %trim(fileListDS.FileNames(i));
                dsply displayMsg;

                // Call NEUCOXML to process the document
                processResult = NEUCOXML(fullPath);

                // Track results
                if processResult;
                    successCount += 1;
                    dsply '  Processing: SUCCESS';

                    // Archive the processed file
                    dsply '  Archiving file...';
                    archiveResult = ARCHIVEIFS(fullPath);

                    if archiveResult.Success;
                        archiveCount += 1;
                        dsply '  Archive: SUCCESS';
                        if archiveResult.ArchiveFolderCreated;
                            dsply '    (Archive folder created)';
                        endif;
                    else;
                        archiveErrorCount += 1;
                        dsply '  Archive: ERROR';
                        displayMsg = '    ' + %trim(archiveResult.ErrorMessage);
                        dsply displayMsg;
                    endif;
                else;
                    errorCount += 1;
                    dsply '  Processing: ERROR';
                    dsply '  (File not archived due to processing error)';
                endif;

                dsply ' ';
            endfor;

            // Step 3: Display processing summary
            dsply '=========================================';
            dsply 'Processing Summary';
            dsply '----------------------------';
            displayMsg = 'Total files found: ' + %char(fileListDS.FileCount);
            dsply displayMsg;
            dsply ' ';
            displayMsg = 'XML Processing Results:';
            dsply displayMsg;
            displayMsg = '  Successful: ' + %char(successCount);
            dsply displayMsg;
            displayMsg = '  Errors: ' + %char(errorCount);
            dsply displayMsg;
            dsply ' ';
            displayMsg = 'Archive Results:';
            dsply displayMsg;
            displayMsg = '  Archived: ' + %char(archiveCount);
            dsply displayMsg;
            displayMsg = '  Archive Errors: ' + %char(archiveErrorCount);
            dsply displayMsg;
            dsply ' ';
            dsply 'PROCNEUCO Complete';
            dsply 'Check XMLORDAUD table for detailed audit logs';

            *inlr = *on;

