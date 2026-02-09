      // Control Options
         Ctl-Opt Option(*SrcStmt:*NoDebugIO);       // Source statements in debug
         Ctl-Opt BndDir('QC2LE');                   // Bind to C runtime library
         Ctl-Opt ExtBinInt(*Yes);                   // Use binary integers
         Ctl-Opt DecEdit('0,');                     // Decimal editing with comma
         Ctl-Opt Copyright('East Coast Metals - LISTIFS Test Program');

      //******************************************************************************
      // TESTLIFS2 - Test Program for LISTIFS External Procedure
      //
      // Purpose: Test the LISTIFS external procedure with various directory paths
      //          and options. This is a standard RPG program compiled with CRTSQLRPGI
      //
      // Author: System Generated
      // Date: 2026-02-09
      // Version: 1.0
      //
      // Test Cases:
      //   1. Non-recursive scan of /tmp directory
      //   2. Recursive scan of /tmp directory
      //   3. Test with invalid path
      //   4. Test with empty path
      //   5. Test root directory scan
      //   6. Compare recursive vs non-recursive counts
      //
      // Compile: CRTSQLRPGI PGM(MYLIB/TESTLIFS2) SRCFILE(MYLIB/QRPGLESRC)
      //******************************************************************************

      // SQL Communication Area
      exec sql include sqlca;

      // Copy members for data structures and prototypes
      /copy qcpysrc,LISTIFS_CP

      // Main program variables
      dcl-ds result likeds(returnIFSDocumentsDS);
      dcl-s i packed(5:0);
      dcl-s testPath varchar(50);

      // Program start indicator
      *inlr = *off;

      // Display program header
      dsply 'LISTIFS External Procedure Test Starting...';
      dsply ' ';

      //------------------------------------------------------------
      // Test 1: Non-recursive scan of /tmp directory
      //------------------------------------------------------------
      dsply 'Test 1: Non-recursive scan of /tmp';
      testPath = '/tmp';
      result = LISTIFS(testPath : *off);
      
      if result.Found = *on;
        dsply ('Files found: ' + %trim(%char(result.FileCount)));
        for i = 1 to result.FileCount;
          if i <= 10; // Display first 10 files only
            dsply ('  ' + %trim(result.FileNames(i).FileName));
          endif;
        endfor;
        if result.FileCount > 10;
          dsply ('  ... and more files');
        endif;
      else;
        dsply 'Error: No files found or path invalid';
      endif;
      dsply ' ';

      //------------------------------------------------------------
      // Test 2: Recursive scan of /tmp directory
      //------------------------------------------------------------
      dsply 'Test 2: Recursive scan of /tmp';
      testPath = '/tmp';
      result = LISTIFS(testPath : *on);
      
      if result.Found = *on;
        dsply ('Files found (recursive): ' + %trim(%char(result.FileCount)));
        for i = 1 to result.FileCount;
          if i <= 10; // Display first 10 files only
            dsply ('  ' + %trim(result.FileNames(i).FileName));
          endif;
        endfor;
        if result.FileCount > 10;
          dsply ('  ... and more files');
        endif;
      else;
        dsply 'Error: No files found or path invalid';
      endif;
      dsply ' ';

      //------------------------------------------------------------
      // Test 3: Test with invalid path
      //------------------------------------------------------------
      dsply 'Test 3: Invalid path test';
      testPath = '/invalid/path/does/not/exist';
      result = LISTIFS(testPath : *off);
      
      if result.Found = *on;
        dsply 'Unexpected success - Files found';
      else;
        dsply 'Expected result: Invalid path handled correctly';
      endif;
      dsply ' ';

      //------------------------------------------------------------
      // Test 4: Test with empty path
      //------------------------------------------------------------
      dsply 'Test 4: Empty path test';
      testPath = '';
      result = LISTIFS(testPath : *off);
      
      if result.Found = *on;
        dsply 'Unexpected success - Files found';
      else;
        dsply 'Expected result: Empty path handled correctly';
      endif;
      dsply ' ';

      //------------------------------------------------------------
      // Test 5: Non-recursive scan of root IFS directory
      //------------------------------------------------------------
      dsply 'Test 5: Non-recursive scan of /';
      testPath = '/';
      result = LISTIFS(testPath : *off);
      
      if result.Found = *on;
        dsply ('Root files found: ' + %trim(%char(result.FileCount)));
        for i = 1 to result.FileCount;
          if i <= 5; // Display first 5 files only
            dsply ('  ' + %trim(result.FileNames(i).FileName));
          endif;
        endfor;
        if result.FileCount > 5;
          dsply ('  ... and more files');
        endif;
      else;
        dsply 'No files found in root directory';
      endif;
      dsply ' ';

      //------------------------------------------------------------
      // Test 6: Compare recursive vs non-recursive counts
      //------------------------------------------------------------
      dsply 'Test 6: Comparing recursive vs non-recursive';
      testPath = '/tmp';
      
      // Non-recursive count
      result = LISTIFS(testPath : *off);
      if result.Found = *on;
        dsply ('Non-recursive count: ' + %trim(%char(result.FileCount)));
      else;
        dsply 'Non-recursive: No files found';
      endif;
      
      // Recursive count
      result = LISTIFS(testPath : *on);
      if result.Found = *on;
        dsply ('Recursive count: ' + %trim(%char(result.FileCount)));
      else;
        dsply 'Recursive: No files found';
      endif;
      dsply ' ';

      //------------------------------------------------------------
      // Test 7: Test QSYS2 library path
      //------------------------------------------------------------
      dsply 'Test 7: QSYS2 library scan';
      testPath = '/QSYS.LIB/QSYS2.LIB';
      result = LISTIFS(testPath : *off);
      
      if result.Found = *on;
        dsply ('QSYS2 objects found: ' + %trim(%char(result.FileCount)));
        for i = 1 to result.FileCount;
          if i <= 5; // Display first 5 objects only
            dsply ('  ' + %trim(result.FileNames(i).FileName));
          endif;
        endfor;
        if result.FileCount > 5;
          dsply ('  ... and more objects');
        endif;
      else;
        dsply 'No objects found in QSYS2.LIB';
      endif;
      dsply ' ';

      dsply 'LISTIFS External Procedure Test Complete';

      *inlr = *on;