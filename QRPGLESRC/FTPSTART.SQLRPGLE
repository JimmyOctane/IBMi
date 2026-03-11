**FREE
//===========================================================================
// Program: FTPSTART
// Description: Start FTP connection using runIBMCommand
//              Based on RCVBECTRAN lines 78-79
//===========================================================================
// Modification Log:
// Date       User  Description
// 2026-03-09 JF    Initial creation - Execute AFSTRFTP command
//===========================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIo)
        BndDir('ECBIND');

// Copy member for runIBMCommand
/COPY qcpysrc,RUNCMND_CP

// Copy member for sendEmail
/COPY qcpysrc,SDEMAIL_CP

// Variables
Dcl-S RemoteLocation Char(10) Inz('BECTRAN');
Dcl-S ProdTest Char(10);
Dcl-S Q Char(1) Inz('''');
Dcl-S FileName Varchar(200);
Dcl-S FileCount Int(10) Inz(0);
Dcl-S MsgText Char(52);
Dcl-S EmailErrorMessage Char(80);
Dcl-S ErrorOccurred Ind Inz(*Off);
Dcl-S ErrorMessage Char(200);

// Procedure prototypes
Dcl-PR SendErrorEmail;
  ErrorMsg Char(200) Const;
End-PR;

// Main Processing
*InLR = *On;

// Create table in QTEMP
Exec SQL
  CREATE OR REPLACE TABLE QTEMP.BECTRANP (
    STRING CHAR(200)
  );

// Retrieve production/test indicator
Exec SQL
  SELECT CHAR(QGPL.PRODTEST)
  INTO :ProdTest
  FROM SYSIBM.SYSDUMMY1;

// If not production, use test location
If ProdTest <> 'PROD';
  RemoteLocation = 'BECTRANT';
EndIf;

// Build and execute AFSTRFTP command (line 78 from RCVBECTRAN)
Monitor;
  commandString = 'AFSTRFTP SVRDFN(' + %Trim(RemoteLocation) + ')';
  OutErrorDS = runIBMCommand(commandString);
  
  MsgText = 'FTP Start: ' + %Trim(RemoteLocation);
  Dsply MsgText;
On-Error;
  ErrorMessage = 'Error starting FTP connection to '
                 + %Trim(RemoteLocation);
  SendErrorEmail(ErrorMessage);
  Return;
EndMon;

// Change to remote directory (line 85 from RCVBECTRAN)
Monitor;
  commandString = 'AFCHDIR DIRECT(' + Q
                  + '/TN2026021289684xml/inb/wip' + Q + ')';
  OutErrorDS = runIBMCommand(commandString);
  
  MsgText = 'Changed to remote directory';
  Dsply MsgText;
On-Error;
  ErrorMessage = 'Error changing to remote directory';
  SendErrorEmail(ErrorMessage);
  Return;
EndMon;

// List files in remote directory to QTEMP table
Monitor;
  commandString = 'AFLIST OUTPUT(*DBF) OBJECTS(*FILES) SORT(*NAME) '
                  + 'VIEW(*SHORT) TODBF(QTEMP/BECTRANP)';
  OutErrorDS = runIBMCommand(commandString);
  
  MsgText = 'Files listed to QTEMP/BECTRANP';
  Dsply MsgText;
On-Error;
  ErrorMessage = 'Error listing remote directory files';
  SendErrorEmail(ErrorMessage);
  Return;
EndMon;

// Read through the BECTRANP table and process each file
Exec SQL
  DECLARE C1 CURSOR FOR
    SELECT TRIM(STRING)
    FROM QTEMP.BECTRANP
    WHERE STRING IS NOT NULL
      AND STRING <> ''
    ORDER BY STRING;

Exec SQL
  OPEN C1;

Exec SQL
  FETCH C1 INTO :FileName;

Dow SQLCODE = 0;
  FileCount += 1;
  
  // Display the filename being processed
  If %Len(%Trim(FileName)) > 45;
    MsgText = 'File: ' + %Subst(%Trim(FileName):1:45);
  Else;
    MsgText = 'File: ' + %Trim(FileName);
  EndIf;
  Dsply MsgText;
  
  // Download file from SFTP to IFS
  Monitor;
    commandString = 'AFGETIFS RMTPATH(' + Q
                    + '/TN2026021289684xml/inb/wip/'
                    + %Trim(FileName) + Q + ') IFSPATH(' + Q
                    + '/home/bectran/' + %Trim(FileName) + Q + ')';
    OutErrorDS = runIBMCommand(commandString);
    
    If %Len(%Trim(FileName)) > 40;
      MsgText = 'Downloaded: ' + %Subst(%Trim(FileName):1:40);
    Else;
      MsgText = 'Downloaded: ' + %Trim(FileName);
    EndIf;
    Dsply MsgText;
  On-Error;
    ErrorMessage = 'Error downloading file: ' + %Trim(FileName);
    SendErrorEmail(ErrorMessage);
  EndMon;
  
  Exec SQL
    FETCH C1 INTO :FileName;
EndDo;

Exec SQL
  CLOSE C1;

MsgText = 'Total files: ' + %Char(FileCount);
Dsply MsgText;

// End FTP connection
commandString = 'AFENDFTP';
OutErrorDS = runIBMCommand(commandString);

MsgText = 'FTP connection ended';
Dsply MsgText;

Return;

//===========================================================================
// Procedure: SendErrorEmail
// Description: Send error notification email to IT department
//===========================================================================
Dcl-Proc SendErrorEmail;
  Dcl-PI *N;
    ErrorMsg Char(200) Const;
  End-PI;
  
  // Set email subject and body
  emailList.Subject = 'FTPSTART Error - Bectran FTP Process';
  emailList.Note = 'An error occurred in FTPSTART program: '
                   + %Trim(ErrorMsg);
  
  // Email ID for the body
  emailList.bodyID = 1;
  
  // Send to IT department
  emailList.address(1) = 'ITDEPT@ecmdi.com';
  emailList.type(1) = 'P';
  
  // Send the email
  Reset EmailErrorMessage;
  EmailErrorMessage = sendEmail(EmailList);
  
  // Log that email was sent
  MsgText = 'Error email sent to IT';
  Dsply MsgText;
  
End-Proc;
