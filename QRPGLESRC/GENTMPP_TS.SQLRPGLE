      //****************************************************************************
      //* Program:      GENTMPP_TS - Test Program for GENTMPP Service Program
      //* Description:  Test program to validate the GENTMPP (Generate Temporary
      //*               Product ID) service program functionality.
      //*
      //* Parameters:   None (standalone test program)
      //*
      //* Returns:      Display messages showing test results
      //*
      //* Copyright:    East Coast Metals
      //* Author:       System Generated
      //* Created:      022326
      //* Modified:     022326 - Initial test program creation
      //****************************************************************************

      // Control Options
       Ctl-Opt Option(*SrcStmt:*NoDebugIO);
       Ctl-Opt BndDir('ECBIND');

      // Copy member for data structures and prototypes
       /copy QCPYSRC,gentmpp_cp

      // Test variables
       dcl-ds input likeds(GENTMPPInput_t);
       dcl-ds result likeds(GENTMPPReturn_t);
       dcl-s msg char(52);

      // Main program logic
       msg = '========================================';
       dsply msg;
       msg = 'GENTMPP Test Program - EQP Category';
       dsply msg;
       msg = '========================================';
       dsply msg;
       msg = '';
       dsply msg;

      // Test: EQP (Equipment) category
       msg = 'Testing Category: EQP (Equipment)';
       dsply msg;

       clear input;
       input.Category = 'EQP';

       result = generateTemporaryProduct(input);

       if result.Success;
         msg = 'PASSED - Product ID: ' + result.ProductID;
         dsply msg;
       else;
         msg = 'FAILED - Error: ' + result.ErrorMessage;
         dsply msg;
       endif;

       msg = '';
       dsply msg;
       msg = '========================================';
       dsply msg;
       msg = 'GENTMPP Testing Completed';
       dsply msg;
       msg = '========================================';
       dsply msg;

       *inlr = *on;
