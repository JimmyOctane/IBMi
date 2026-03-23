**********************************************************************
* Program: PDFMONITOR
* Purpose: Monitor PDFOUTQ data queue and convert spool files to PDF
*
* Description:
*   This program continuously monitors the PDFOUTQ data queue for
*   spool file notifications. When a spool file is added to the
*   PDFOUTQ output queue, the data queue receives a message with
*   the spool file information. This program then converts the
*   spool file to PDF format and saves it to the IFS.
*
* Data Queue Format:
*   The data queue entry contains spool file information:
*   - Job Name (10)
*   - User Name (10)
*   - Job Number (6)
*   - Spool File Name (10)
*   - Spool File Number (4 packed)
*
* Processing:
*   1. Wait for data queue entry (infinite wait)
*   2. Parse spool file information from data queue
*   3. Build PDF file name with timestamp
*   4. Convert spool file to PDF using CPYSPLF
*   5. Log success/failure
*   6. Repeat
*
* Author: Roo Code
* Date: 2026-03-19
**********************************************************************

ctl-opt dftactgrp(*no) actgrp(*new);
ctl-opt option(*srcstmt:*nodebugio) datfmt(*iso);
ctl-opt bnddir('QC2LE');

// Data Queue API
dcl-pr QRCVDTAQ extpgm('QRCVDTAQ');
  dtaqName char(10) const;
  dtaqLib char(10) const;
  dataLen packed(5:0);
  dataBuffer char(1024);
  waitTime packed(5:0) const;
end-pr;

// Send Program Message API
dcl-pr QMHSNDPM extpgm('QMHSNDPM');
  msgId char(7) const;
  msgFile char(20) const;
  msgData char(1024) const;
  msgDataLen int(10) const;
  msgType char(10) const;
  callStack char(10) const;
  callStackCnt int(10) const;
  msgKey char(4);
  errorCode char(256);
end-pr;

// Data Queue Entry Structure
dcl-ds dtaqEntry qualified;
  jobName char(10);
  userName char(10);
  jobNumber char(6);
  splName char(10);
  splNumber packed(4:0);
end-ds;

// Variables
dcl-s dataLen packed(5:0) inz(30);
dcl-s waitTime packed(5:0) inz(-1);  // Infinite wait
dcl-s pdfPath varchar(256);
dcl-s pdfFileName varchar(100);
dcl-s ifsFolder varchar(200) inz('/home/pdfoutq');
dcl-s timestamp char(26);
dcl-s msgKey char(4);
dcl-s errorCode char(256) inz(*allx'00');
dcl-s displayMsg varchar(200);
dcl-s sqlStmt varchar(1000);
dcl-s rowCount int(10);

// Main Processing Loop
dsply 'PDFMONITOR Started - Monitoring PDFOUTQ data queue';
dsply 'Press F3/Attn to end program';
dsply ' ';

dow '1';
  // Clear data queue entry
  clear dtaqEntry;

  // Wait for data queue entry
  QRCVDTAQ('PDFOUTQ':'*LIBL':dataLen:dtaqEntry:waitTime);

  // Check if data was received
  if dataLen > 0;
    // Build timestamp for unique filename
    timestamp = %char(%timestamp());
    timestamp = %scanrpl('-':'':timestamp);
    timestamp = %scanrpl('.':'':timestamp);
    timestamp = %scanrpl(':':'':timestamp);
    timestamp = %scanrpl(' ':'_':timestamp);

    // Build PDF filename
    pdfFileName = %trim(dtaqEntry.splName) + '_' +
                  %trim(dtaqEntry.jobName) + '_' +
                  %trim(dtaqEntry.jobNumber) + '_' +
                  %char(dtaqEntry.splNumber) + '_' +
                  %trim(timestamp) + '.pdf';

    // Build full IFS path
    pdfPath = %trim(ifsFolder) + '/' + %trim(pdfFileName);

    // Display processing message
    displayMsg = 'Processing: ' + %trim(dtaqEntry.splName) +
                 ' Job: ' + %trim(dtaqEntry.jobName) + '/' +
                 %trim(dtaqEntry.userName) + '/' +
                 %trim(dtaqEntry.jobNumber);
    dsply displayMsg;

    // Convert spool file to PDF using CPYSPLF
    monitor;
      sqlStmt = 'CALL QSYS2.QCMDEXC(''CPYSPLF FILE(' +
                %trim(dtaqEntry.splName) + ') +
                TOFILE(*TOSTMF) +
                JOB(' + %trim(dtaqEntry.jobNumber) + '/' +
                %trim(dtaqEntry.userName) + '/' +
                %trim(dtaqEntry.jobName) + ') +
                SPLNBR(' + %char(dtaqEntry.splNumber) + ') +
                TOSTMF(''''' + %trim(pdfPath) + ''''') +
                WSCST(*PDF)'')';

      exec sql execute immediate :sqlStmt;

      if sqlcode = 0;
        displayMsg = '  SUCCESS: PDF created at ' + %trim(pdfPath);
        dsply displayMsg;

        // Log success to joblog
        QMHSNDPM('CPF9898':'QCPFMSG   *LIBL':
                 'PDF created: ' + %trim(pdfPath):
                 %len(%trim('PDF created: ' + %trim(pdfPath))):
                 '*INFO':'*PGMBDY':1:msgKey:errorCode);
      else;
        displayMsg = '  ERROR: SQLCODE=' + %char(sqlcode);
        dsply displayMsg;

        // Log error to joblog
        QMHSNDPM('CPF9898':'QCPFMSG   *LIBL':
                 'PDF conversion failed for ' + %trim(dtaqEntry.splName) +
                 ' SQLCODE: ' + %char(sqlcode):
                 %len(%trim('PDF conversion failed for ' +
                 %trim(dtaqEntry.splName) + ' SQLCODE: ' + %char(sqlcode))):
                 '*DIAG':'*PGMBDY':1:msgKey:errorCode);
      endif;

    on-error;
      displayMsg = '  ERROR: Exception during conversion';
      dsply displayMsg;

      // Log error to joblog
      QMHSNDPM('CPF9898':'QCPFMSG   *LIBL':
               'PDF conversion exception for ' + %trim(dtaqEntry.splName):
               %len(%trim('PDF conversion exception for ' +
               %trim(dtaqEntry.splName))):
               '*DIAG':'*PGMBDY':1:msgKey:errorCode);
    endmon;

    dsply ' ';
  endif;
enddo;

*inlr = *on;

