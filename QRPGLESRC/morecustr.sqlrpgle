**FREE
// Program: MORECUSTR
// Description: Write ARPHBAL records
// Purpose: This program writes records to the ARPHBAL table.
//          Logic extracted from ARR5015.

ctl-opt option(*srcstmt: *nodebugio) dftactgrp(*no);

dcl-f ARPHBAL disk(*ext) usage(*output);

// Date conversion data structure
dcl-ds *n;
  ARMO82 packed(2:0) pos(1);
  ARCC82 packed(2:0) pos(3);
  ARYR82 packed(2:0) pos(5);
  DSTMPR packed(6:0) pos(1);
end-ds;

// Date components data structure
dcl-ds *n inz;
  MONTH packed(2:0) pos(1);
  DAY packed(2:0) pos(3);
  CEN packed(2:0) pos(5);
  YEAR packed(2:0) pos(7);
  DATE packed(8:0) pos(1);
end-ds;

// Statement date data structure
dcl-ds *n;
  STDATE char(16) pos(1);
  DSDATE packed(8:0) pos(1);
  LSTMDT packed(8:0) pos(9);
end-ds;

// Account date data structure
dcl-ds *n;
  ACDATE char(12) pos(1);
  ACDT1 packed(6:0) pos(1);
  ACDT2 packed(6:0) pos(7);
end-ds;

// Parameters
dcl-pi *n;
  ARNO01 packed(6:0);
  ARNO15 packed(3:0);
  ARNO16 packed(3:0);
  ARID01 char(3);
  ARID05 char(3);
  ARFL14 char(1);
  CREDIT char(1);
  AM01 packed(9:2);
end-pi;

// Key list fields
dcl-s TBNO01 char(4);
dcl-s TBNO02 char(9);
dcl-s TBNO03 char(16);

// Work fields
dcl-s STDTE char(16);

// Indicators
dcl-s *IN49 ind;

// Main processing
MONTH = UMONTH;
DAY = UDAY;
YEAR = UYEAR;
%subst(CEN:1:2) = %subst(*YEAR:1:2);

GetTableDates();
DSTMPR = ACDT2;
exsr CLRAMT;
write ARFHBAL;

*inlr = *on;
return;

// Subroutine: CLRAMT
begsr CLRAMT;
  clear ARFHBAL;
endsr;

//=====================================================================
// Procedure: GetTableDates
// Purpose: Retrieve date information from TBFMTBL table
//=====================================================================
dcl-proc GetTableDates;
  dcl-s tableData char(30);
  
  STDATE = *zeros;
  ACDATE = *zeros;
  
  // Get AR09 table entry
  tableData = GetTableData('AR09': %char(ARNO15));
  if tableData <> *blanks;
    ACDATE = %subst(tableData:1:12);
  endif;
  
  // Get AR11 table entry with 'DATA  ' suffix
  tableData = GetTableData('AR11': %trimr(%char(ARNO15)) + 'DATA  ');
  if tableData <> *blanks;
    STDATE = %subst(tableData:1:16);
  endif;
end-proc;

//=====================================================================
// Procedure: GetTableData
// Purpose: Generic procedure to retrieve data from TBPMTBL using SQL
// Returns: Table data (TBNO03) or blanks if not found
//=====================================================================
dcl-proc GetTableData;
  dcl-pi *n char(30);
    pTableId char(4) const;
    pTableKey char(9) const;
  end-pi;
  
  dcl-s tableData char(30);
  
  exec sql
    SELECT TBNO03
    INTO :tableData
    FROM TBPMTBL
    WHERE TBNO01 = :pTableId
      AND TBNO02 = :pTableKey;
  
  if sqlcode = 0;
    return tableData;
  else;
    return *blanks;
  endif;
end-proc;
