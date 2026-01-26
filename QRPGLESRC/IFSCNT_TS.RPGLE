      //****************************************************************************
      //* Program:      IFSCNT_TS - Test Program for IFS Table Record Count
      //* Description:  Test program for IFSCNT service module procedures
      //* Copyright:    East Coast Metals
      //* Author:       JJF
      //* Created:      012325
      //****************************************************************************

      // Control Options
      Ctl-Opt DftActGrp(*No) BndDir('ECBIND');
      Ctl-Opt Option(*SrcStmt:*NoDebugIO);

      // Copy member for procedure prototypes
      /copy qrpglesrc,IFSCNT_CP

      // Variable declarations
      dcl-s resultCount int(10);
      dcl-s testDirectory varchar(256);
      dcl-s testTableName varchar(128);
      dcl-s msg char(50);

      // Test 1: Call with wildcard pattern
      testDirectory = '/home/jflanary';
      testTableName = 'test_branch*';
      msg = 'Test 1: ' + %trim(testTableName);
      dsply msg;
      resultCount = getIFSTableCount(testDirectory : testTableName);
      msg = 'Records: ' + %char(resultCount);
      dsply msg;
      
      // Test 2: Call with specific file name
      testDirectory = '/tmp';
      testTableName = 'transfer_data.csv';
      msg = 'Test 2: ' + %trim(testTableName);
      dsply msg;
      resultCount = getIFSTableCount(testDirectory : testTableName);
      msg = 'Records: ' + %char(resultCount);
      dsply msg;
      
      // Test 3: Call with wildcard in middle
      testDirectory = '/home/jflanary';
      testTableName = 'test_*2026*.txt';
      msg = 'Test 3: ' + %trim(testTableName);
      dsply msg;
      resultCount = getIFSTableCount(testDirectory : testTableName);
      msg = 'Records: ' + %char(resultCount);
      dsply msg;
      
      // Test 4: Call with non-existent pattern
      testDirectory = '/tmp';
      testTableName = 'nonexistent*.csv';
      msg = 'Test 4: ' + %trim(testTableName);
      dsply msg;
      resultCount = getIFSTableCount(testDirectory : testTableName);
      msg = 'Records: ' + %char(resultCount);
      dsply msg;
      
      // Test 5: Call with empty parameters
      testDirectory = '';
      testTableName = '';
      msg = 'Test 5: Empty params';
      dsply msg;
      resultCount = getIFSTableCount(testDirectory : testTableName);
      msg = 'Records: ' + %char(resultCount);
      dsply msg;

      msg = 'Tests done';
      dsply msg;

      *inlr = *on;