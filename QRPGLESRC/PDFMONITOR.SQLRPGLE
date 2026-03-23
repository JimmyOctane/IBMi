**FREE
//********************************************************
// Program: PDFMONITOR
// Purpose: Monitor PDFOUTQ data queue and convert
//          spool files to PDF
//
// Description:
//   This program continuously monitors the PDFOUTQ
//   data queue for spool file notifications. When a
//   spool file is added to the PDFOUTQ output queue,
//   the data queue receives a message with the spool
//   file information. This program then converts the
//   spool file to PDF format and saves it to the IFS.
//
// Data Queue Format:
//   The data queue entry contains spool file info:
//   - Job Name (10)
//   - User Name (10)
//   - Job Number (6)
//   - Spool File Name (10)
//   - Spool File Number (4 packed)
//
// Processing:
//   1. Wait for data queue entry (infinite wait)
//   2. Parse spool file information from data queue
//   3. Build PDF file name with timestamp
//   4. Convert spool file to PDF using CPYSPLF
//   5. Log success/failure
//   6. Repeat
//
// Author: Roo Code
// Date: 2026-03-19
//********************************************************

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


// Data Queue Entry Structure
// IBM i output queue data queue format (120 bytes)
dcl-ds dtaqEntry qualified based(dtaqPtr);
  entryType char(10);      // *SPOOL
  seqType char(2);         // 01
  jobName char(10);        // Job name
  userName char(10);       // User name
  jobNumber char(6);       // Job number
  splName char(10);        // Spool file name
  splNumber int(10);       // Spool file number (binary)
  outqName char(10);       // Output queue name
  outqLib char(10);        // Output queue library
  formType char(10);       // Form type
  userData char(10);       // User data
  status char(10);         // Status
  pages int(10);           // Number of pages
  copiesLeft int(10);      // Copies left to print
  priority char(2);        // Priority
  filler char(38);         // Reserved/filler
end-ds;

// Variables
dcl-s dataLen packed(5:0) inz(120);
dcl-s waitTime packed(5:0) inz(30);  // 30 second wait
dcl-s dtaqBuffer char(1024);
dcl-s dtaqPtr pointer;
dcl-s pdfPath varchar(256);
dcl-s pdfFileName varchar(100);
dcl-s ifsFolder varchar(200) inz('/home/pdfoutq');
dcl-s timestamp char(26);
dcl-s usrEmail varchar(100);
dcl-s toUser char(10);

/COPY qcpysrc,RUNCMND_CP

// Main Processing Loop

dow '1';
  // Clear buffer
  clear dtaqBuffer;

  // Wait for data queue entry
  QRCVDTAQ('PDFOUTQ':'*LIBL':dataLen:dtaqBuffer:
           waitTime);

  // Check if data was received
  if dataLen > 0;
    // Point to buffer for data structure overlay
    dtaqPtr = %addr(dtaqBuffer);
    // Build timestamp for unique filename
    // Format: YYYYMMDD_HHMMSS
    timestamp = %char(%timestamp());
    timestamp = %subst(timestamp:1:4) +
                %subst(timestamp:6:2) +
                %subst(timestamp:9:2) + '_' +
                %subst(timestamp:12:2) +
                %subst(timestamp:15:2) +
                %subst(timestamp:18:2);

    // Build descriptive PDF filename
    // Format: SPLFILENAME_USER_YYYYMMDD_HHMMSS.pdf
    // Remove all spaces from field values
    pdfFileName = %trimr(dtaqEntry.splName) + '_' +
                  %trimr(dtaqEntry.userName) + '_' +
                  %trim(timestamp) + '.pdf';

    // Build full IFS path
    pdfPath = %trim(ifsFolder) + '/' + %trim(pdfFileName);

    // Get email address for user
    // Check if USRDTA field contains a valid user profile
    toUser = '';
    
    if %trim(dtaqEntry.userData) <> '';
      // Validate that userData is an actual user profile
      exec sql
        select authorization_name
        into :toUser
        from qsys2.user_info
        where authorization_name = :dtaqEntry.userData;
      
      // If not a valid user profile, use job user instead
      if sqlcode <> 0;
        toUser = dtaqEntry.userName;
      endif;
    else;
      // USRDTA is blank, use job user
      toUser = dtaqEntry.userName;
    endif;

    // Get email address from SHPMUSE
    exec sql
      select trim(shad50)
      into :usrEmail
      from shpmuse
      where shuser = :toUser;

    // If not found, default to IT department email
    if sqlcode <> 0;
      usrEmail = 'ITdept@ecmdi.com';
    else;
      // Just trim the email address
      usrEmail = %trim(usrEmail);
      
      // Validate email has @ sign, if not use default
      if %scan('@':usrEmail) = 0 or usrEmail = '';
        usrEmail = 'ITdept@ecmdi.com';
      endif;
    endif;

    // Convert spool file to PDF using CPYSPLF
    monitor;
      commandString = 'CPYSPLF FILE(' +
                      %trim(dtaqEntry.splName) + ') +
                      TOFILE(*TOSTMF) +
                      JOB(' + %trim(dtaqEntry.jobNumber) + '/' +
                      %trim(dtaqEntry.userName) + '/' +
                      %trim(dtaqEntry.jobName) + ') +
                      SPLNBR(' + %char(dtaqEntry.splNumber) + ') +
                      TOSTMF(''' + %trim(pdfPath) + ''') +
                      WSCST(*PDF)';

      OutErrorDS = runIBMCommand(commandString);

      // If PDF conversion successful, send email
      // Check if command executed without error
      if %trim(OutErrorDS) = '';
        // Send email using SNDSMTPEMM command
        commandString = 'SNDSMTPEMM +
                         RCP((''' + %trim(usrEmail) + ''')) +
                         SUBJECT(''Spool File: ' +
                         %trim(dtaqEntry.splName) + ''') +
                         NOTE(''Attached is your spool file ' +
                         %trim(dtaqEntry.splName) + ' from job ' +
                         %trim(dtaqEntry.jobName) + '/' +
                         %trim(dtaqEntry.userName) + '/' +
                         %trim(dtaqEntry.jobNumber) + ''') +
                         ATTACH((''' + %trim(pdfPath) + '''))';

        OutErrorDS = runIBMCommand(commandString);

        // Check if email was sent successfully
        if %trim(OutErrorDS) = '';
          // Delete spool file after successful email
          commandString = 'DLTSPLF FILE(' +
                          %trim(dtaqEntry.splName) + ') +
                          JOB(' + %trim(dtaqEntry.jobNumber) + '/' +
                          %trim(dtaqEntry.userName) + '/' +
                          %trim(dtaqEntry.jobName) + ') +
                          SPLNBR(' + %char(dtaqEntry.splNumber) + ')';

          OutErrorDS = runIBMCommand(commandString);
        endif;
      endif;

    on-error;
      // Error occurred during conversion
    endmon;

  endif;
enddo;

*inlr = *on;
