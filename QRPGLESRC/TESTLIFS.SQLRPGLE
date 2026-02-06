      // Control Options
         Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
         Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
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
      // Version: 1.0
      //
      //******************************************************************************

      // Copy member for LISTIFS data structures and prototype
      /copy qrpglesrc,LISTIFS_CP

      // Field Definitions - Variables
      dcl-s testPath varchar(50) inz;
      dcl-s i packed(5:0) inz;
      dcl-s displayMsg varchar(132) inz;
      dcl-ds result likeds(returnListDS);

      // Main processing
      dsply 'Starting LISTIFS Test Program';
      dsply '================================';

      // Test 1: Valid directory with potential files
      dsply ' ';
      dsply 'Test 1: Testing /tmp directory';
      testPath = '/tmp';
      result = LISTIFS(testPath);
      
      if result.Found;
        displayMsg = 'SUCCESS: Found=' + %char(result.Found) + 
                    ' FileCount=' + %char(result.FileCount);
        dsply displayMsg;
        
        // Display first few files found (max 10 for readability)
        if result.FileCount > 0;
          for i = 1 to %min(result.FileCount : 10);
            displayMsg = 'File ' + %char(i) + ': ' + 
                        %trim(result.FileNames(i));
            dsply displayMsg;
          endfor;
          
          if result.FileCount > 10;
            displayMsg = '... and ' + %char(result.FileCount - 10) + ' more files';
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
      result = LISTIFS(testPath);
      
      if result.Found;
        displayMsg = 'SUCCESS: Found=' + %char(result.Found) + 
                    ' FileCount=' + %char(result.FileCount);
        dsply displayMsg;
        
        // Display first few files/directories found
        if result.FileCount > 0;
          for i = 1 to %min(result.FileCount : 5);
            displayMsg = 'Item ' + %char(i) + ': ' + 
                        %trim(result.FileNames(i));
            dsply displayMsg;
          endfor;
        endif;
      else;
        dsply 'FAILED: Could not access /home directory';
      endif;

      // Test 3: Invalid directory
      dsply ' ';
      dsply 'Test 3: Testing invalid directory';
      testPath = '/nonexistent/invalid/path';
      result = LISTIFS(testPath);
      
      if result.Found;
        displayMsg = 'UNEXPECTED: Invalid path returned Found=true, FileCount=' + 
                    %char(result.FileCount);
        dsply displayMsg;
      else;
        dsply 'SUCCESS: Invalid path correctly returned Found=false';
      endif;

      // Test 4: Empty path
      dsply ' ';
      dsply 'Test 4: Testing empty path';
      testPath = '';
      result = LISTIFS(testPath);
      
      if result.Found;
        displayMsg = 'UNEXPECTED: Empty path returned Found=true, FileCount=' + 
                    %char(result.FileCount);
        dsply displayMsg;
      else;
        dsply 'SUCCESS: Empty path correctly returned Found=false';
      endif;

      // Test 5: QSys library (should have many stream files)
      dsply ' ';
      dsply 'Test 5: Testing /QSYS.LIB directory';
      testPath = '/QSYS.LIB';
      result = LISTIFS(testPath);
      
      if result.Found;
        displayMsg = 'SUCCESS: Found=' + %char(result.Found) + 
                    ' FileCount=' + %char(result.FileCount);
        dsply displayMsg;
        
        // Display first few items found
        if result.FileCount > 0;
          for i = 1 to %min(result.FileCount : 3);
            displayMsg = 'Library ' + %char(i) + ': ' + 
                        %trim(result.FileNames(i));
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