**FREE
ctl-opt option(*srcstmt: *nodebugio) dftactgrp(*no);

//------------------------------------------------------------------------
// PROGRAM NAME - MORECUSTR
//------------------------------------------------------------------------
// WRITE ARPHBAL RECORDS
//------------------------------------------------------------------------
// PURPOSE:
//    This program writes records to the ARPHBAL table.
//    Logic extracted from ARR5015 and modernized to free format.
//------------------------------------------------------------------------

dcl-f ARPHBAL disk(*ext) usage(*output);
dcl-f TBLMTBL1 disk(*ext) keyed usage(*input);

// Date structures
dcl-ds statementPeriod;
  armo82 packed(2:0);
  arcc82 packed(2:0);
  aryr82 packed(2:0);
  dstmpr packed(6:0) pos(1);
end-ds;

dcl-ds currentDate;
  month packed(2:0);
  day packed(2:0);
  cen packed(2:0);
  year packed(2:0);
  date packed(8:0) pos(1);
end-ds;

dcl-ds statementDate;
  stdate char(16);
  dsdate packed(8:0) pos(1);
  lstmdt packed(8:0) pos(9);
end-ds;

dcl-ds accountingDate;
  acdate char(12);
  acdt1 packed(6:0) pos(1);
  acdt2 packed(6:0) pos(7);
end-ds;

// Parameters
dcl-pi *n;
  arno01 packed(6:0);  // Customer number
  arno15 packed(3:0);  // Company number
  arno16 packed(3:0);  // Branch number
  arid01 char(3);      // Salesperson ID
  arid05 char(3);      // Secondary salesperson ID
  arfl14 char(1);      // Service charge flag
  credit char(1);      // Credit type
  fl03 char(1);        // Hold flag
  fl76 char(1);        // Credit hold lock
  am01 packed(9:2);    // Credit limit amount
end-pi;

// Standalone variables
dcl-s tbno01 char(4);
dcl-s tbno02 char(9);
dcl-s tbno03 char(30);
dcl-s stdte char(16);
dcl-s found ind;

// Main processing
month = %dec(%subdt(%date():*months));
day = %dec(%subdt(%date():*days));
year = %dec(%subdt(%date():*years)) - 2000;
cen = %dec(%subdt(%date():*years)) / 100;

retrieveDates();
dstmpr = acdt2;
clearAmounts();
write ARFHBAL;

*inlr = *on;
return;

//------------------------------------------------------------------------
// Retrieve AR dates from table files
//------------------------------------------------------------------------
dcl-proc retrieveDates;
  
  stdate = *zeros;
  acdate = *zeros;
  
  // Get accounting period from AR09 table
  tbno01 = 'AR09';
  tbno02 = *blanks;
  %subst(tbno02:1:%len(%char(arno15))) = %char(arno15);
  
  chain (tbno01:tbno02) TBFMTBL;
  if %found(TBLMTBL1);
    acdate = tbno03;
  endif;
  
  // Get statement date from AR11 table
  tbno01 = 'AR11';
  tbno02 = *blanks;
  %subst(tbno02:1:%len(%char(arno15))) = %char(arno15);
  %subst(tbno02:4:6) = 'DATA  ';
  
  chain (tbno01:tbno02) TBFMTBL;
  if %found(TBLMTBL1);
    stdte = tbno03;
    stdate = stdte;
  endif;
  
end-proc;

//------------------------------------------------------------------------
// Clear all amount fields in balance record
//------------------------------------------------------------------------
dcl-proc clearAmounts;
  
  arbl02 = 0;
  arbl11 = 0;
  arbl12 = 0;
  arbl15 = 0;
  arbl50 = 0;
  arbl51 = 0;
  arbl52 = 0;
  arbl53 = 0;
  arbl54 = 0;
  arbl55 = 0;
  arbl56 = 0;
  arbl57 = 0;
  arbl58 = 0;
  arbl75 = 0;
  arbl61 = 0;
  arbl62 = 0;
  aram04 = 0;
  aram05 = 0;
  aram07 = 0;
  aram08 = 0;
  aram09 = 0;
  aram16 = 0;
  aram17 = 0;
  aram18 = 0;
  aram19 = 0;
  aram20 = 0;
  aram21 = 0;
  aram22 = 0;
  aram23 = 0;
  arcn01 = 0;
  ardy03 = 0;
  ardy04 = 0;
  ardy11 = 0;
  ardy16 = 0;
  armo03 = 0;
  armo04 = 0;
  armo11 = 0;
  armo16 = 0;
  arcc03 = 0;
  aryr03 = 0;
  arcc04 = 0;
  aryr04 = 0;
  arcc11 = 0;
  aryr11 = 0;
  arcc16 = 0;
  aryr16 = 0;
  arno03 = 0;
  
end-proc;
