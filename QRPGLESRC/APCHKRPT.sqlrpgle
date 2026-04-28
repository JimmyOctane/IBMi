**FREE
//==============================================================================
// Program: APCHKRPT
// Description: Extract outstanding checks and populate table in HD1100PD
// Author: Generated
// Date: 2026-04-23
//==============================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIO) BndDir('ECBIND');

// Display file
Dcl-F APCHKRPTD WorkStn Infds(Infds);

// Copy member for sendEmail
/COPY qcpysrc,SDEMAIL_CP

// Program Status Data Structure
Dcl-Ds Psds Psds Qualified;
  PgmName *Proc;
End-Ds;

// Information Data Structure
Dcl-Ds Infds Qualified;
  FunctionKey Char(1) Pos(369);
End-Ds;

// API Error Data Structure
Dcl-Ds ApiError;
  AeBytPro Int(10:0) Inz(%Size(ApiError));
  AeBytAvl Int(10:0) Inz;
  AeMsgId Char(7);
  someField Char(1);
  AeMsgDta Char(128);
End-Ds;

// Prototypes
Dcl-Pr SendMsg ExtPgm('QMHSNDPM');
  MessageID Char(7) Const;
  QualMsgF Char(20) Const;
  MsgData Char(256) Const;
  MsgDtaLen Int(10:0) Const;
  MsgType Char(10) Const;
  CallStkEnt Char(10) Const;
  CallStkCnt Int(10:0) Const;
  MessageKey Char(4);
  ErrorCode Like(ApiError);
End-Pr;

Dcl-Pr RemoveMsg ExtPgm('QMHRMVPM');
  MessageQ Char(276) Const;
  CallStack Int(10:0) Const;
  MessageKey Char(4) Const;
  MessageRmv Char(10) Const;
  ErrorCode Like(ApiError);
End-Pr;

// Declare variables
Dcl-S RowCount      Int(10);
Dcl-S CutoffDate    Packed(8:0);
Dcl-S WorkDate      Date;
Dcl-S LastDayPrevMonth Packed(8:0);
Dcl-S IfsPath       Varchar(256);
Dcl-S FileName      Varchar(50);
Dcl-S YearNum       Zoned(4:0);
Dcl-S MonthNum      Zoned(2:0);
Dcl-S Result        Varchar(1000);
Dcl-S Company       Packed(3:0);
Dcl-S DefaultCompany Packed(3:0);
Dcl-S InputDate     Packed(6:0);
Dcl-S MsgKey        Char(4);
Dcl-S ErrorId       Char(7);
Dcl-S EmailAddress  Varchar(100);
Dcl-S EmailErrorMessage Char(80);

// SQL communication area
Exec SQL
  Include SQLCA;

// Main processing
Main();
*INLR = *On;

//==============================================================================
// Main procedure
//==============================================================================
Dcl-Proc Main;

  // Get user's email address
  Monitor;
    GetUserEmail();
  On-Error;
    // If email lookup fails, continue anyway
  EndMon;
  
  // Get default company for current user
  Monitor;
    GetDefaultCompany();
  On-Error;
    // If company lookup fails, default to 0
    Company = 0;
  EndMon;
  
  // Calculate last day of previous month as default date
  Monitor;
    WorkDate = %Date();  // Current date
    YearNum = %Subdt(WorkDate:*Years);
    MonthNum = %Subdt(WorkDate:*Months);
    
    // Build first day of current month
    WorkDate = %Date(YearNum * 10000 + MonthNum * 100 + 1 : *ISO);
    
    // Subtract 1 day to get last day of previous month
    WorkDate = WorkDate - %Days(1);
    
    // Convert to 6,0 format (MMDDYY)
    LastDayPrevMonth = %Dec(%Char(WorkDate:*ISO0):8:0);
    InputDate = %Dec(%Char(WorkDate:*MDY0):6:0);
  On-Error;
    // If date calculation fails, use a default
    InputDate = 123124; // 12/31/24
  EndMon;
  
  // Display screen to get parameters
  If Not PromptUser();
    Return; // User pressed F3 or F12
  EndIf;
  
  // Convert MMDDYY to CCYYMMDD
  CutoffDate = ConvertDate(InputDate);

  // Drop table if it exists
  Exec SQL
    Drop Table HD1100PD.APCHKRPT;
  
  // Create the table to store results
  Exec SQL
    Create Table HD1100PD.APCHKRPT (
      CHECK_NUM     Decimal(7, 0) Not Null,
      CHECK_DATE    Integer       Not Null,
      VENDOR_NUM    Decimal(6, 0) Not Null,
      VENDOR_NAME   Char(30)      Not Null,
      AMOUNT        Decimal(11, 2) Not Null
    );

  If SQLCODE < 0 And SQLCODE <> -601;  // Ignore "already exists" error
    Return;
  EndIf;

  // Insert data from the query
  Exec SQL
    Insert Into HD1100PD.APCHKRPT
    (CHECK_NUM, CHECK_DATE, VENDOR_NUM, VENDOR_NAME, AMOUNT)
    
    Select Check_Num, CheckDate, Vendor_Num, Name, Amount
    From (
      Select
        APNO14 As Check_Num,
        a.APNO01 As Vendor_Num,
        APNM02 As Name,
        APCD27 As CheckType,
        APAM11 As Amount,
        
        Case
          When apmo08 Between 1 And 12
           And apdy08 Between 1 And 31
           And apyr08 Between 0 And 99
          Then Int(Date(apcc08 Concat Digits(apyr08) Concat '-' 
                        Concat Digits(apmo08) Concat '-' 
                        Concat Digits(apdy08)))
          Else 0
        End As CheckDate,
        
        Case
          When apmo13 Between 1 And 12
           And apdy13 Between 1 And 31
           And apyr13 Between 0 And 99
          Then Int(Date(apcc13 Concat Digits(apyr13) Concat '-' 
                        Concat Digits(apmo13) Concat '-' 
                        Concat Digits(apdy13)))
          Else 0
        End As VoidDate,
        
        Case
          When apmo09 Between 1 And 12
           And apdy09 Between 1 And 31
           And apyr09 Between 0 And 99
          Then Int(Date(apcc09 Concat Digits(apyr09) Concat '-' 
                        Concat Digits(apmo09) Concat '-' 
                        Concat Digits(apdy09)))
          Else 0
        End As ClearDate
        
      From APPHCK a
      Join APPMVEN b On a.APNO01 = b.APNO01
      Where APCD27 <> 'A'
    ) As SubQuery
    
    Where
      (CheckDate <= :CutoffDate
       And VoidDate > :CutoffDate
       And ClearDate <= VoidDate
       And CheckType <> 'A')
      
      Or (CheckDate <= :CutoffDate
          And ClearDate > :CutoffDate
          And CheckType <> 'A')
      
      Or (CheckDate <= :CutoffDate
          And VoidDate = 0
          And ClearDate = 0
          And CheckType <> 'A')
    
    Order By Check_Num;

  If SQLCODE < 0;
    Return;
  EndIf;

  // Get row count
  Exec SQL
    Select Count(*) Into :RowCount
    From HD1100PD.APCHKRPT;

  // Export to Excel file in IFS (no extension - added by function)
  FileName = 'APCHKRPT_' + %Char(CutoffDate);
  IfsPath = '/tmp/' + %Trim(FileName);

  // Create Excel spreadsheet using SYSTOOLS
  Exec SQL
    Values SYSTOOLS.GENERATE_SPREADSHEET(
      PATH_NAME => :IfsPath,
      SPREADSHEET_QUERY => 'SELECT * FROM HD1100PD.APCHKRPT',
      SPREADSHEET_TYPE => 'xlsx',
      COLUMN_HEADINGS => 'COLUMN'
    ) Into :Result;

 // Excel file created (or error occurred)
 // Send email with attachment
 SendReportEmail();

End-Proc;

//==============================================================================
// Send report email with Excel attachment
//==============================================================================
Dcl-Proc SendReportEmail;
 
 // Set email subject and body
 emailList.Subject = 'AP Check Report - ' + %Char(CutoffDate);
 emailList.Note = 'Attached is the AP Check Report for cutoff date: '
                  + %Char(CutoffDate) + '. Total records: ' + %Char(RowCount);
 

emailList.Subject = 'Outstanding check listing';             
emailList.Note =                                               
 'Please see attached document for report';       
                      
// Email ID for the body
 emailList.bodyID = 1;
 
 // Send to user's email address
 emailList.address(1) = %Trim(EmailAddress);
 emailList.type(1) = 'P';
 
 // Attach the Excel file (add .xlsx extension)
 emailList.AttachmentName(1) = %Trim(IfsPath) + '.xlsx';
 
 // Send the email
 Reset EmailErrorMessage;
 EmailErrorMessage = sendEmail(EmailList);
 
 // Log result (optional)
 If EmailErrorMessage <> *Blanks;
   // Email error occurred - could add error handling here
 EndIf;
 
End-Proc;

//==============================================================================
// Get user's email address
//==============================================================================
Dcl-Proc GetUserEmail;
  
  EmailAddress = 'itdept@ecmdi.com'; // Default
  
  Monitor;
    Exec SQL
      Select shad50
      Into :EmailAddress
      From shpmuse
      Where shuser = current_user;
    
    If SQLCODE <> 0 Or %Len(%Trim(EmailAddress)) = 0;
      EmailAddress = 'itdept@ecmdi.com'; // Default if not found
    EndIf;
  On-Error;
    // If SQL fails, keep default
    EmailAddress = 'itdept@ecmdi.com';
  EndMon;
  
End-Proc;

//==============================================================================
// Get default company for current user
//==============================================================================
Dcl-Proc GetDefaultCompany;
  
  DefaultCompany = 0;
  Company = 0; // Default
  
  Monitor;
    Exec SQL
      Select digits(dec(substr(tbno03,4,3),3,0))
      Into :DefaultCompany
      From hd1100pd.TBPMTBL
      Where TBNO01 = 'TIDS' and TBNO02 = current_user;
    
    If SQLCODE = 0;
      Company = DefaultCompany;
    Else;
      Company = 0; // Default to 0 if not found
    EndIf;
  On-Error;
    // If SQL fails, keep default
    Company = 0;
  EndMon;
  
End-Proc;

//==============================================================================
// Prompt user for parameters
//==============================================================================
Dcl-Proc PromptUser;
  Dcl-Pi *N Ind End-Pi;
  
  Dcl-S ValidInput Ind Inz(*Off);
  Dcl-S ScreenError Ind Inz(*Off);
  
  // Initialize screen fields
  COMPANY = Company;
  CUTDATE = InputDate;
  
  DoU ValidInput;
    // Clear error indicators
    *In25 = *Off;
    *In26 = *Off;
    *In03 = *Off;
    
    // Clear any previous messages if no errors
    If ScreenError = *Off;
      ClearMessages();
    EndIf;
    
    // Set program queue for message subfile
    PGMQ = PSDS.PgmName;
    
    // Display screen
    Write MSGCTL;
    Exfmt APCHKRPTF;
    
    // Check for exit (F3=03, F12=12)
    If %Shtdn() Or *In03 Or *In12;
      Return *Off;
    EndIf;
    
    // Reset screen error flag
    Reset ScreenError;
    
    // Validate company
    If COMPANY <= 0;
      *In25 = *On;
      ErrorId = 'GEN0076';
      SendErrorMsg(ErrorId);
      ScreenError = *On;
      Iter;
    EndIf;
    
    // Validate company exists in GLPMHDR
    If Not ValidateCompany(COMPANY);
      *In25 = *On;
      ErrorId = 'GEN0076';
      SendErrorMsg(ErrorId);
      ScreenError = *On;
      Iter;
    EndIf;
    
    // Validate date (basic check - must be 6 digits)
    If CUTDATE <= 0 Or CUTDATE > 123199;
      *In81 = *On;
      *In26 = *On;
      ErrorId = 'GEN0010';
      SendErrorMsg(ErrorId);
      ScreenError = *On;
      Iter;
    EndIf;
    
    // Additional date validation
    If Not ValidateDate(CUTDATE);
      *In81 = *On;
      *In26 = *On;
      ErrorId = 'GEN0010';
      SendErrorMsg(ErrorId);
      ScreenError = *On;
      Iter;
    EndIf;
    
    ValidInput = *On;
  EndDo;
  
  // Save values
  Company = COMPANY;
  InputDate = CUTDATE;
  
  Return *On;
  
End-Proc;

//==============================================================================
// Validate date in MMDDYY format
//==============================================================================
Dcl-Proc ValidateDate;
  Dcl-Pi *N Ind;
    DateMMDDYY Packed(6:0);
  End-Pi;
  
  Dcl-S MM Packed(2:0);
  Dcl-S DD Packed(2:0);
  Dcl-S YY Packed(2:0);
  
  // Extract month, day, year
  MM = %Div(DateMMDDYY:10000);
  DD = %Div(%Rem(DateMMDDYY:10000):100);
  YY = %Rem(DateMMDDYY:100);
  
  // Validate month
  If MM < 1 Or MM > 12;
    Return *Off;
  EndIf;
  
  // Validate day (simple check)
  If DD < 1 Or DD > 31;
    Return *Off;
  EndIf;
  
  Return *On;
  
End-Proc;

//==============================================================================
// Convert MMDDYY to CCYYMMDD
//==============================================================================
Dcl-Proc ConvertDate;
  Dcl-Pi *N Packed(8:0);
    DateMMDDYY Packed(6:0);
  End-Pi;
  
  Dcl-S MM Packed(2:0);
  Dcl-S DD Packed(2:0);
  Dcl-S YY Packed(2:0);
  Dcl-S CCYY Packed(4:0);
  Dcl-S ResultDate Packed(8:0);
  
  // Extract month, day, year
  MM = %Div(DateMMDDYY:10000);
  DD = %Div(%Rem(DateMMDDYY:10000):100);
  YY = %Rem(DateMMDDYY:100);
  
  // Convert 2-digit year to 4-digit year
  // Assume 00-49 = 2000-2049, 50-99 = 1950-1999
  If YY <= 49;
    CCYY = 2000 + YY;
  Else;
    CCYY = 1900 + YY;
  EndIf;
  
  // Build CCYYMMDD
  ResultDate = (CCYY * 10000) + (MM * 100) + DD;
  
  Return ResultDate;
  
End-Proc;

//==============================================================================
// Validate company exists in GLPMHDR
//==============================================================================
Dcl-Proc ValidateCompany;
  Dcl-Pi *N Ind;
    CompanyNum Packed(3:0);
  End-Pi;
  
  Dcl-S CompanyExists Packed(3:0);
  
  CompanyExists = 0;
  
  Exec SQL
    Select GLNO01
    Into :CompanyExists
    From GLPMHDR
    Where GLNO01 = :CompanyNum;
  
  If SQLCODE = 0;
    Return *On;  // Company exists
  Else;
    Return *Off; // Company not found
  EndIf;
  
End-Proc;

//==============================================================================
// Clear messages from message subfile
//==============================================================================
Dcl-Proc ClearMessages;
  
  // Remove all messages from program message queue
  RemoveMsg(PSDS.PgmName : *Zero : *Blanks : '*ALL' : APIError);
  
End-Proc;

//==============================================================================
// Send error message to message subfile
//==============================================================================
Dcl-Proc SendErrorMsg;
  Dcl-Pi *N;
    MsgId Char(7);
  End-Pi;
  
  Dcl-S MsgData Char(256);
  Dcl-S MsgFile Char(20);
  Dcl-S LocalMsgKey Char(4);
  
  // Initialize values
  MsgData = *Blanks;
  MsgFile = 'ECMMSGF   *LIBL   ';
  LocalMsgKey = *Blanks;
  
  // Send info message to program message queue for display in subfile
  SendMsg(MsgId : MsgFile : MsgData : 0 : '*INFO' : Psds.PgmName : 2 :
          LocalMsgKey : APIError);
  
End-Proc;
