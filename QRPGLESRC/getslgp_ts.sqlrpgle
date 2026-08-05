**FREE
// ------------------------------------------------------------------------
// N PROGRAM NAME - GETSLSGP_TS
// ------------------------------------------------------------------------
// P COPYRIGHT East Coast Metals
// ------------------------------------------------------------------------
// D Test program for GETSLSGP service program
// ------------------------------------------------------------------------
// S PURPOSE:
// S   Calls GetSlsGP with hard-coded test values and displays the
// S   returned gross sales and gross profit.
// S
// S SPECIAL NOTES:
// S   Change the test values below before compiling/running.
// S
// M ----------------------------------------------------------------------
// M TASK       DATE   ID  DESCRIPTION
// M ---------- ------ --- ------------------------------------------------
// V JJF   3163 072826 JJF created program
// M ----------------------------------------------------------------------

ctl-opt dftactgrp(*No) bnddir('ECBIND') option(*srcstmt: *nodebugio);

/COPY qcpysrc,GETSLGP_CP

// -----------------------------------------------------------------------
//  Test values - adjust as needed
// -----------------------------------------------------------------------
dcl-c TEST_COMPANY   1;          // company number
dcl-c TEST_SALESID   '096';      // 3-char salesperson ID
dcl-c TEST_FROMDATE  d'2026-06-01';
dcl-c TEST_TODATE    d'2026-06-30';

// -----------------------------------------------------------------------
//  Working variables
// -----------------------------------------------------------------------
dcl-ds myResult likeds(salesGP_ds);
dcl-s  dsplyMsg  char(52);

*inlr = *on;

// Call the service program procedure
myResult = GetGrossProfitBySalesperson(TEST_COMPANY : TEST_SALESID :
                                       TEST_FROMDATE : TEST_TODATE);

// Display results
dsplyMsg = 'SqlCode : ' + %char(myResult.SqlCode);
dsply dsplyMsg;

dsplyMsg = 'Gross Sales  : ' + %char(myResult.GrossSales);
dsply dsplyMsg;

dsplyMsg = 'Gross Profit : ' + %char(myResult.GrossProfit);
dsply dsplyMsg;

