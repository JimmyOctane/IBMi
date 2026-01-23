      //****************************************************************************
      //* Program:      SNDTRFS_TS - Test Program for Transfer CSV Generation
      //* Description:  Test program for SNDTRFS service module procedures
      //* Copyright:    East Coast Metals
      //* Author:       JJF
      //* Created:      012325
      //****************************************************************************

      // Control Options
      Ctl-Opt DftActGrp(*No) BndDir('ECBIND');
      Ctl-Opt Option(*SrcStmt:*NoDebugIO);

      // Copy member for procedure prototypes
      /copy qrpglesrc,SNDTRFS_CP

      // Variable declarations
      dcl-s resultCount int(10);
      dcl-s testDate char(10);
      dcl-s csvPath varchar(100);
      dcl-s tableName varchar(100);
      dcl-s includeHeaders char(1);
      dcl-s msg char(50);
      dcl-s branches packed(3:0) dim(100);

      // Initialize branch array with branch 96
      branches(1) = 96;

      // Test 1: Call with no parameters and branch array
      msg = 'Test 1: No parms';
      dsply msg;
      testDate = '';
      csvPath = '';
      tableName = '';
      includeHeaders = 'Y';
      resultCount = generateTransferCSV(testDate : csvPath : branches : tableName :
                                       includeHeaders);
      msg = 'Records: ' + %char(resultCount);
      dsply msg;
      
      // Test 2: Call with specific date and branch array (CSV format)
      testDate = '2024-12-23';
      msg = 'Test 2: ' + testDate + ' CSV';
      dsply msg;
      csvPath = '';
      tableName = 'transfer_data.csv';
      includeHeaders = 'Y';
      resultCount = generateTransferCSV(testDate : csvPath : branches : tableName :
                                       includeHeaders);
      msg = 'Records: ' + %char(resultCount);
      dsply msg;
      
      // Test 3: Call with date, custom path and branch array (TXT format)
      testDate = '2024-12-23';
      csvPath = '/tmp/test_transfer.txt';
      tableName = 'transfer_data.txt';
      msg = 'Test 3: ' + testDate + ' TXT';
      dsply msg;
      includeHeaders = 'N';
      resultCount = generateTransferCSV(testDate : csvPath : branches : tableName :
                                       includeHeaders);
      msg = 'Records: ' + %char(resultCount);
      dsply msg;
      
      // Test 4: Call with invalid date and branch array
      testDate = '20241223';
      msg = 'Test 4: ' + testDate;
      dsply msg;
      csvPath = '';
      tableName = 'invalid_test.csv';
      includeHeaders = 'Y';
      resultCount = generateTransferCSV(testDate : csvPath : branches : tableName :
                                       includeHeaders);
      msg = 'Records: ' + %char(resultCount);
      dsply msg;
      
      // Test 5: Call with date, path, and branch array (CSV)
      testDate = '2024-12-23';
      csvPath = '/tmp/test_branch.csv';
      tableName = 'test_branch.csv';
      msg = 'Test 5: ' + testDate + ' CSV';
      dsply msg;
      includeHeaders = 'Y';
      resultCount = generateTransferCSV(testDate : csvPath : branches : tableName :
                                       includeHeaders);
      msg = 'Records: ' + %char(resultCount);
      dsply msg;

      msg = 'Tests done';
      dsply msg;

      *inlr = *on;