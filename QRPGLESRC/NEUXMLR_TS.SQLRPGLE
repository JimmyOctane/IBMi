//****************************************************************************
//* Program:      NEUXMLR_TS - Test Program for NEUCOXML External Procedure
//* Description:  Test program to validate the NEUCOXML external procedure
//*               functionality. Tests XML order file processing from IFS.
//*
//* Parameters:   None (standalone test program)
//*
//* Returns:      Completion message via QMHSNDPM
//*
//* Procedures:   NEUCOXML - External procedure for XML order processing
//*
//* Features:     - Valid XML file processing
//*               - Invalid file path handling
//*               - Error indicator validation
//*               - Test result reporting via message
//*
//* Copyright:    East Coast Metals
//* Author:       Roo Code
//* Created:      2026-02-16
//* Modified:     2026-02-16 - Initial test program creation
//****************************************************************************

// Control Options - Required for service program prototype usage
Ctl-Opt Main(main) DftActGrp(*NO) ActGrp(*NEW);
Ctl-Opt Option(*SrcStmt:*NoDebugIO);
Ctl-Opt BndDir('ECBIND');

// Copy member for prototype
/copy qrpglesrc,NEUXMLR_CP

// Main procedure
dcl-proc main;
  // Test variables
  dcl-s testFilePath varchar(1000);
  dcl-s errorInd ind;
  dcl-s testCount int(3) inz(0);
  dcl-s passCount int(3) inz(0);
  dcl-s msgText varchar(200);

  // Test 1: Valid XML file path
  // NOTE: Update this path to point to an actual XML file in your IFS
  testCount += 1;
  testFilePath = '/home/NEUCO/orders/test_order.xml';

  errorInd = NEUCOXML(testFilePath);

  if not errorInd;
    passCount += 1;
  endif;

  // Test 2: Invalid file path
  testCount += 1;
  testFilePath = '/invalid/path/nonexistent.xml';

  errorInd = NEUCOXML(testFilePath);

  if errorInd;
    passCount += 1;
  endif;

  // Test 3: Empty file path
  testCount += 1;
  testFilePath = '';

  errorInd = NEUCOXML(testFilePath);

  if errorInd;
    passCount += 1;
  endif;

  // Send completion message
  msgText = 'NEUCOXML Tests: ' + %char(passCount) + '/' +
            %char(testCount) + ' passed. Check XMLORDAUD for details.';

  sndpgmmsg('CPF9898': 'QCPFMSG   *LIBL': msgText: 200:
            '*INFO': '*PGMBDY': 1: *blank: *blank);

end-proc;
