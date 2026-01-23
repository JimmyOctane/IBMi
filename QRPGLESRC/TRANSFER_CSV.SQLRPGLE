**FREE
ctl-opt option(*srcstmt:*nodebugio) debug(*yes) dftactgrp(*no);

//*------------------------------------------------------------------------*
//*N PROGRAM NAME - TRANSFER_CSV                                          *
//*------------------------------------------------------------------------*
//*P                                                                       *
//*------------------------------------------------------------------------*
//*D         Generate CSV file for transfer data using service program     *
//*------------------------------------------------------------------------*
//*S PURPOSE: Main program to call transfer CSV generation service         *
//*S                                                                       *
//*S SPECIAL NOTES:                                                        *
//*S                                                                       *
//*M ----------------------------------------------------------------------*
//*M TASK       DATE   ID  DESCRIPTION                                     *
//*M ---------- ------ --- ------------------------------------------------*
//*V JJF   3060 012325 JJF Created program using service program           *
//*M ----------------------------------------------------------------------*

// Program Info SDS
dcl-ds pgmInfo psds;
  pgmName char(10) pos(1);
  parms packed(3: 0) pos(37);
  msgData char(80) pos(91);
  msgId char(4) pos(171);
  jobName char(10) pos(244);
  user char(10) pos(254);
  jobNumber zoned(6: 0) pos(264);
end-ds;

// Copy member for service program prototypes
/copy qrpglesrc,SNDTRFS_CP

// Field Definitions
dcl-s recordCount int(10) inz;
dcl-s returnCode int(10) inz;

// Entry parameter list prototype and declaration
dcl-pr Main extpgm('TRANSFER_CSV');
  parmDate char(8) options(*nopass);
  csvPath varchar(100) options(*nopass);
end-pr;

// Main procedure interface
dcl-pi Main;
  parmDate char(8) options(*nopass);
  csvPath varchar(100) options(*nopass);
end-pi;

*inlr = *on;

// Call the service program procedure
select;
  when %parms() >= 2;
    returnCode = generateTransferCSV(parmDate : csvPath);
  when %parms() >= 1;
    returnCode = generateTransferCSV(parmDate);
  other;
    returnCode = generateTransferCSV();
endsl;

// Handle return code
if returnCode >= 0;
  // Success - returnCode contains number of records processed
  recordCount = returnCode;
else;
  // Error occurred
  // Could add error logging or messaging here
endif;
