**FREE
//==============================================================================
// Program: LOADCSVTOT - Load Customer Totals from CSV
// Description: Reads CSV file from IFS and loads into CUSTOMER_TOTALS table
// File Location: /home/NEUCO/*.csv
// Format: Customer Number,total$
//==============================================================================

ctl-opt dftactgrp(*no) actgrp(*new) option(*nodebugio:*srcstmt)
        bnddir('QC2LE');

//==============================================================================
// Prototypes
//==============================================================================
dcl-pr fopen pointer extproc('_C_IFS_fopen');
  *n pointer value options(*string);  // filename
  *n pointer value options(*string);  // mode
end-pr;

dcl-pr fgets pointer extproc('_C_IFS_fgets');
  *n pointer value;                   // buffer
  *n int(10) value;                   // buffer size
  *n pointer value;                   // file pointer
end-pr;

dcl-pr fclose int(10) extproc('_C_IFS_fclose');
  *n pointer value;                   // file pointer
end-pr;

dcl-pr feof int(10) extproc('_C_IFS_feof');
  *n pointer value;                   // file pointer
end-pr;

//==============================================================================
// Variables
//==============================================================================
dcl-s filePath varchar(256) inz('/home/NEUCO/customer_totals.csv');
dcl-s filePtr pointer;
dcl-s buffer char(1024);
dcl-s line varchar(1024);
dcl-s custNbr packed(11:0);
dcl-s totalAmt packed(15:2);
dcl-s commaPos int(10);
dcl-s custStr varchar(50);
dcl-s amtStr varchar(50);
dcl-s recordCount int(10) inz(0);
dcl-s errorCount int(10) inz(0);
dcl-s isFirstLine ind inz(*on);

//==============================================================================
// Main Processing
//==============================================================================

// Open the CSV file
filePtr = fopen(%trim(filePath): 'r');

if filePtr = *null;
  snd-msg *info 'Unable to open file: ' + %trim(filePath)
    %target(*pgmbdy:1);
  *inlr = *on;
  return;
endif;

snd-msg *info 'Processing file: ' + %trim(filePath)
  %target(*pgmbdy:1);

// Clear existing data (optional - remove if you want to append)
exec sql DELETE FROM JAMIEDEV.CUSTOMER_TOTALS;

// Read file line by line
dow feof(filePtr) = 0;
  
  clear buffer;
  
  if fgets(%addr(buffer): %size(buffer): filePtr) <> *null;
    
    line = %trim(buffer);
    
    // Skip header line
    if isFirstLine;
      isFirstLine = *off;
      iter;
    endif;
    
    // Skip empty lines
    if line = '';
      iter;
    endif;
    
    // Parse CSV line: Customer Number,total$
    commaPos = %scan(',': line);
    
    if commaPos > 0;
      
      custStr = %subst(line: 1: commaPos - 1);
      amtStr = %subst(line: commaPos + 1);
      
      // Convert to numeric values
      monitor;
        custNbr = %dec(%trim(custStr): 11: 0);
        totalAmt = %dec(%trim(amtStr): 15: 2);
        
        // Insert into table
        exec sql
          INSERT INTO JAMIEDEV.CUSTOMER_TOTALS
            (CUST_NBR, TOTAL_AMT)
          VALUES
            (:custNbr, :totalAmt);
        
        if sqlcode = 0;
          recordCount += 1;
        else;
          errorCount += 1;
          snd-msg *info 'SQL Error for customer ' + %trim(custStr) +
            ': SQLCODE=' + %char(sqlcode)
            %target(*pgmbdy:1);
        endif;
        
      on-error;
        errorCount += 1;
        snd-msg *info 'Parse error on line: ' + %trim(line)
          %target(*pgmbdy:1);
      endmon;
      
    endif;
    
  endif;
  
enddo;

// Close the file
fclose(filePtr);

// Send completion message
snd-msg *info 'Processing complete. Records loaded: ' + %char(recordCount) +
  ', Errors: ' + %char(errorCount)
  %target(*pgmbdy:1);

*inlr = *on;
return;
