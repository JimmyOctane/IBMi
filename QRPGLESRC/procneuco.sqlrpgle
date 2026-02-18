            // Control Options
                Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
                Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
                Ctl-Opt bnddir('ECBIND');
                Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
                Ctl-Opt Copyright('East Coast Metals - PROCNEUCO Program');

            // Program interface - optional delay parameter
            dcl-pi *n;
              delaySeconds packed(15:5) options(*nopass);
            end-pi;

            //******************************************************************************
            // PROCNEUCO - Process Neuco XML Documents (Continuous Mode)
            //
            // Purpose: Continuously monitors /home/neuco/ folder, processes XML documents
            //          one at a time using NEUCOXML service program, and archives them
            //          after successful processing
            //
            // Processing Flow:
            //   1. Scan /home/neuco/ directory for files (configurable delay)
            //   2. Loop through each file found
            //   3. Build full IFS path for each file
            //   4. Call NEUCOXML to process the XML document
            //   5. If successful, call ARCHIVEIFS to move file to archive subfolder
            //   6. Track success/failure counts for processing and archiving
            //   7. Display processing summary
            //   8. Sleep specified seconds and repeat
            //
            // Parameters:
            //   delaySeconds (DECIMAL 15,5) - Optional, *NOPASS
            //                                 Seconds to wait between scans
            //                                 Default: 180 (3 minutes)
            //                                 If passed: Uses specified value
            //
            // Dependencies:
            //   - LISTIFS service program (for listing IFS files)
            //   - NEUCOXML service program (for processing XML documents)
            //   - ARCHIVEIFS service program (for archiving processed documents)
            //   - sleep() C function (for delay between scans)
            //
            // Usage: CALL PROCNEUCO
            //        CALL PROCNEUCO PARM(60.00000)  /* 1 minute delay */
            //        CALL PROCNEUCO PARM(300.00000) /* 5 minute delay */
            //        Program runs continuously until manually ended
            //        Results are displayed via DSPLY statements
            //        To stop: Use ENDJOB or end from WRKACTJOB
            //
            // Author: Roo Code
            // Date: 2026-02-17
            // Version: 2.0
            //
            // Modification History:
            //   Date       Author        Description
            //   ---------- ------------- ----------------------------------------------
            //   2026-02-17 Roo Code      Initial implementation v1.0
            //                           - List files in /home/neuco/
            //                           - Process each XML document
            //                           - Track and display results
            //   2026-02-17 Roo Code      Enhanced to v2.0
            //                           - Added continuous loop with configurable delay
            //                           - Added optional delay parameter (default 3 min)
            //                           - Added ARCHIVEIFS call after successful processing
            //                           - Added archive success/error tracking
            //                           - Fixed VARCHAR display issues
            //                           - Fixed DSPLY length restrictions
            //
            //******************************************************************************

            // Copy members for service program prototypes
            /copy qcpysrc,LISTIFS_CP
            /copy qcpysrc,NEUXMLR_CP
            /copy qcpysrc,ARCHIFS_CP

            // Field Definitions - Variables
            dcl-s neucoPath varchar(1000) inz('/home/neuco/');
            dcl-s subtreeOption ind inz(*off);
            dcl-s fullPath char(300) inz;
            dcl-s fileName char(100) inz;
            dcl-s i packed(5:0) inz;
            dcl-s processResult ind inz;
            dcl-s successCount int(10) inz(0);
            dcl-s errorCount int(10) inz(0);
            dcl-s archiveCount int(10) inz(0);
            dcl-s archiveErrorCount int(10) inz(0);
            dcl-s displayMsg char(52) inz;
            dcl-s sleepSeconds int(10) inz(180);
            
            // Prototype for sleep function
            dcl-pr sleep int(10) extproc('sleep');
              seconds uns(10) value;
            end-pr;

            // Data structures
            dcl-ds fileListDS likeds(returnIFSDocumentsDS);
            dcl-ds archiveResult likeds(returnArchiveDS);

            // Check if delay parameter was passed
            if %parms() >= 1;
              sleepSeconds = %int(delaySeconds);
              displayMsg = 'Using delay: ' + %char(sleepSeconds) + ' sec';
              dsply displayMsg;
            else;
              dsply 'Using default delay: 180 sec (3 min)';
            endif;

            // Main processing - continuous loop
            dsply 'Starting PROCNEUCO - Neuco XML Processor';
            dsply 'Continuous mode';
            dsply '======================================';
            dsply ' ';
            
            // Continuous processing loop
            dow *on;
                // Reset counters for this iteration
                successCount = 0;
                errorCount = 0;
                archiveCount = 0;
                archiveErrorCount = 0;

                // Step 1: Get list of files in /home/neuco/ directory
                displayMsg = 'Scanning: ' + %trim(neucoPath);
                dsply displayMsg;
                fileListDS = LISTIFS(neucoPath : subtreeOption);

                // Check if directory was found and accessible
                if not fileListDS.Found;
                    dsply 'ERROR: Cannot access /home/neuco/';
                    displayMsg = 'Retry in ' + %char(sleepSeconds) + ' sec...';
                    dsply displayMsg;
                    sleep(sleepSeconds);
                    iter;
                endif;

                // Display file count
                displayMsg = 'Files found: ' + %char(fileListDS.FileCount);
                dsply displayMsg;

                // Check if any files exist
                if fileListDS.FileCount = 0;
                    dsply 'No files to process';
                    displayMsg = 'Wait ' + %char(sleepSeconds) + ' sec...';
                    dsply displayMsg;
                    dsply ' ';
                    sleep(sleepSeconds);
                    iter;
                endif;

                dsply ' ';
                dsply 'Beginning file processing...';
                dsply '----------------------------';

                // Step 2: Loop through each file and process
                for i = 1 to fileListDS.FileCount;
                // Extract filename to CHAR variable to avoid VARCHAR prefix issues
                fileName = fileListDS.FileNames(i);
                
                // Build full IFS path
                fullPath =  %trim(fileName);

                // Display current file being processed
                displayMsg = 'Processing file ' + %char(i) + ' of ' +
                            %char(fileListDS.FileCount);
                dsply displayMsg;
                displayMsg = 'File: ' + %trim(fileName);
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
                    dsply '  (Not archived - processing error)';
                endif;

                dsply ' ';
            endfor;

                // Step 3: Display processing summary
                dsply '======================================';
                dsply 'Processing Summary';
                dsply '----------------------------';
                displayMsg = 'Total files found: ' +
                             %char(fileListDS.FileCount);
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
                dsply 'Iteration complete';
                dsply 'Check XMLORDAUD for detailed audit logs';
                dsply ' ';
                displayMsg = 'Waiting ' + %char(sleepSeconds) + ' sec...';
                dsply displayMsg;
                dsply '======================================';
                dsply ' ';
                
                // Sleep for specified seconds before next iteration
                sleep(sleepSeconds);
            enddo;

            *inlr = *on;
