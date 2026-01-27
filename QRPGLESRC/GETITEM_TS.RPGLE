//****************************************************************************
//* Program:      GETITEM_TS - Test Program for GETITEM External Procedure
//* Description:  Test program to validate the GETITEM external procedure
//*               functionality. Tests item retrieval with various scenarios
//*               including valid/invalid item numbers and branch combinations.
//*
//* Parameters:   None (standalone test program)
//*
//* Returns:      Display messages showing test results
//*
//* Procedures:   GETITEM - External procedure for item data retrieval
//*
//* Features:     - Valid item and branch testing
//*               - Zero branch (master data only) testing
//*               - Invalid item number validation
//*               - Open purchase order display
//*               - Test result reporting
//*
//* Copyright:    East Coast Metals
//* Author:       System Generated
//* Created:      012626
//* Modified:     012626 - Initial test program creation
//****************************************************************************

// Control Options - Required for service program prototype usage
Ctl-Opt Main(main) DftActGrp(*NO) ActGrp(*NEW);
Ctl-Opt Option(*SrcStmt:*NoDebugIO);
Ctl-Opt BndDir('ECBIND');

// Copy member for data structures and prototypes
/copy qrpglesrc,GETITEM_CP

// Main procedure
dcl-proc main;
  // Test variables
  dcl-s testItem packed(15:5);
  dcl-s testBranch packed(15:5);
  dcl-s i packed(3:0);
  dcl-ds result likeds(returnItemDS);

  // Test 1: Valid item and branch
  testItem = 12345;
  testBranch = 100;
  
  dsply ('Testing GETITEM with Item: ' + %char(testItem));
  dsply ('Branch: ' + %char(testBranch));
  
  result = GETITEM(testItem : testBranch);
  
  if result.Found;
    dsply ('Test 1 PASSED - Item found');
    dsply ('Company: ' + result.Company);
    dsply ('Description: ' + result.Description);
    dsply ('OnHand: ' + %char(result.OnHand));
    dsply ('WAC Cost: ' + %char(result.WACUnitCost));
  else;
    dsply ('Test 1 - Item not found (may be expected)');
  endif;
  
  // Test 2: Zero branch (master data only)
  testItem = 12345;
  testBranch = 0;
  
  dsply ('Testing GETITEM with Item: ' + %char(testItem) + 
         ' Branch: 0 (master only)');
  
  result = GETITEM(testItem : testBranch);
  
  if result.Found;
    dsply ('Test 2 PASSED - Master item found');
    dsply ('Description: ' + result.Description);
    dsply ('OnHand: ' + %char(result.OnHand));
  else;
    dsply ('Test 2 - Master item not found');
  endif;
  
  // Test 3: Invalid item
  testItem = 0;
  testBranch = 100;
  
  dsply ('Testing GETITEM with Item: 0 (invalid)');
  
  result = GETITEM(testItem : testBranch);
  
  if not result.Found;
    dsply ('Test 3 PASSED - Invalid item correctly rejected');
  else;
    dsply ('Test 3 FAILED - Invalid item should not be found');
  endif;
  
  // Test 4: Display open PO information if any
  if result.POCount > 0;
    dsply ('Open POs found: ' + %char(result.POCount));
    for i = 1 to result.POCount;
      dsply ('PO: ' + %char(result.OpenPOs(i).PONumber));
      dsply ('Status: ' + result.OpenPOs(i).Status);
      dsply ('Qty: ' + %char(result.OpenPOs(i).Quantity));
    endfor;
  endif;
  
  dsply ('GETITEM testing completed');
  
end-proc;