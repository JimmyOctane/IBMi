      //****************************************************************************
      //* Program:      CRTTMPI_TS - Test Program for CRTTMPI Service Program
      //* Description:  Test program to validate the CRTTMPI (Create Temporary
      //*               Item) service program functionality.
      //*
      //* Parameters:   None (standalone test program)
      //*
      //* Returns:      Display messages showing test results
      //*
      //* Copyright:    East Coast Metals
      //* Author:       System Generated
      //* Created:      022426
      //* Modified:     022426 - Initial test program creation
      //****************************************************************************

      // Control Options
       Ctl-Opt Option(*SrcStmt:*NoDebugIO);
       Ctl-Opt BndDir('ECBIND');

      // Copy member for data structures and prototypes
       /copy QCPYSRC,CRTTMPI_CP

      // Test variables
       dcl-ds input likeds(crttmpiInput_t);
       dcl-ds result likeds(crttmpiReturn_t);
       dcl-s msg char(52);

      // Main program logic
       msg = '========================================';
       dsply msg;
       msg = 'CRTTMPI Test Program - EQP Category';
       dsply msg;
       msg = '========================================';
       dsply msg;
       msg = '';
       dsply msg;

      // Test: Create temporary item with auto-generated product ID
       msg = 'Test 1: Auto-generate Product ID (EQP)';
       dsply msg;

       clear input;
       input.ItemNumber = '';  // Leave blank to auto-generate
       input.Description = 'Test Equipment Item';
       input.VendorNumber = 12345;
       input.Category = 'EQP';
       input.Section = 'TST';
       input.Group = 'TST';
       input.ShipBranch = 21;

       result = CreateTemporaryItem(input);

       if result.Success;
         msg = 'PASSED - Item#: ' + %char(result.NewItemNumber);
         dsply msg;
       else;
         msg = 'FAILED - Error: ' + result.ErrorMessage;
         dsply msg;
       endif;

       msg = '';
       dsply msg;

      // Test: Create temporary item with provided product ID
       msg = 'Test 2: Provided Product ID';
       dsply msg;

       clear input;
       input.ItemNumber = 'TEST-ITEM-001';
       input.Description = 'Test Item with Manual ID';
       input.VendorNumber = 12345;
       input.Category = 'PTS';
       input.Section = 'TST';
       input.Group = 'TST';
       input.ShipBranch = 21;

       result = CreateTemporaryItem(input);

       if result.Success;
         msg = 'PASSED - Item#: ' + %char(result.NewItemNumber);
         dsply msg;
       else;
         msg = 'FAILED - Error: ' + result.ErrorMessage;
         dsply msg;
       endif;

       msg = '';
       dsply msg;
       msg = '========================================';
       dsply msg;
       msg = 'CRTTMPI Testing Completed';
       dsply msg;
       msg = '========================================';
       dsply msg;

       *inlr = *on;
