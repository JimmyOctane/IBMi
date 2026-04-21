**FREE
//==============================================================================
// Program: ARPCDRW01
// Purpose: Display Payroll Draw Dates from ARPCDRAWD table
//==============================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIO);

// Display File
Dcl-F ARDCDRW01 WorkStn Sfile(SUB01:SCRRN) IndDs(Indicators) Infds(INFDS) UsrOpn;

// File Information Data Structure
Dcl-Ds INFDS Qualified;
  choice    Char(1) Pos(369);
  cLocation Char(2) Pos(370);
  curRec    Int(5:0) Pos(378);
End-Ds;

// Command Key Constants
Dcl-C LeaveProgram Const(x'33');  // F3
Dcl-C Refresh      Const(x'35');  // F5
Dcl-C AddRecord    Const(x'36');  // F6
Dcl-C Generate     Const(x'39');  // F9
Dcl-C Previous     Const(x'3C');  // F12

// Indicator Data Structure
Dcl-Ds Indicators;
  IndDrawErr    Ind Pos(25);  // Draw date error - reverse image
  IndBeginErr   Ind Pos(26);  // Begin date error - reverse image
  IndEndErr     Ind Pos(27);  // End date error - reverse image
  SflClr        Ind Pos(30);
  SflDsp        Ind Pos(31);
  SflDspCtl     Ind Pos(32);
  SflEnd        Ind Pos(33);
End-Ds;

// Program Status Data Structure (PSDS)
Dcl-Ds PSDS Psds Qualified;
  PgmName       Char(10)    Pos(1);
  UserId        Char(10)    Pos(254);
End-Ds;

// API Error Data Structure
Dcl-Ds ApiError;
  AeBytPro Int(10:0) Inz(%Size(ApiError));
  AeBytAvl Int(10:0) Inz;
  AeMsgId Char(7);
  someField Char(1);
  AeMsgDta Char(128);
End-Ds;

// Message File Variables
Dcl-S messagecsc Int(10:0) Inz;
Dcl-S messageData Char(80) Inz;
Dcl-S messagekey Char(4) Inz;
Dcl-S messageLen Int(10:0) Inz;
Dcl-S messageFile Char(20) Inz('ECMMSGF   *LIBL     ');
Dcl-S messageid Char(7) Inz;
Dcl-S screenError Ind Inz;

// Window Message Subfile Variables
Dcl-S WINMSGKEY Char(4) Inz;
Dcl-S WINPGMQ Char(10) Inz;

// Cursor Position Variables
Dcl-S CSRROW Int(5) Inz(0);
Dcl-S CSRCOL Int(5) Inz(0);

// Prototypes for Message APIs
Dcl-Pr $clearmsg ExtPgm('QMHRMVPM');
  messageq_ Char(276) Const;
  CallStack_ Int(10:0) Const;
  Messagekey_ Char(4) Const;
  messagermv_ Char(10) Const;
  ErrorCode_ Like(apierror);
End-Pr;

Dcl-Pr $sendmsg ExtPgm('QMHSNDPM');
  MessageID_ Char(7) Const;
  QualMsgF_ Char(20) Const;
  MsgData_ Char(256) Const;
  MsgDtaLen_ Int(10:0) Const;
  MsgType_ Char(10) Const;
  CallStkEnt_ Char(10) Const;
  CallStkCnt_ Int(10:0) Const;
  Messagekey_ Char(4);
  ErrorCode_ Like(apierror);
End-Pr;

// Data structure array for batch fetching from ARPCDRAWD
Dcl-Ds PayrollDateDS Dim(1000) Qualified;
  drawDate      Char(10);   // Payroll Draw Date (DRAWDATE)
  ppBegin       Char(10);   // Payroll Begin Date (PPBEGIN)
  ppEnd         Char(10);   // Payroll End Date (PPEND)
  dayOfWeek     Char(9);    // Day of week name
End-Ds;

// Work fields
Dcl-S SCRRN Packed(4:0);
Dcl-S Done Ind Inz(*Off);
Dcl-S TotalRecords Int(10) Inz(0);
Dcl-S CurrentIndex Int(10) Inz(0);
Dcl-S i Int(10) Inz(0);
Dcl-S FILTERYEAR Packed(4:0);

// Main processing
Open ARDCDRW01;

// Set SQL options
Exec SQL Set Option Commit=*None, DatFmt=*ISO, ClosqlCsr=*EndMod;

// Initialize display fields
USERID = PSDS.UserId;
C1TITLE = 'Payroll Draw Date Maintenance';
C1DISPLAY = 'Change Mode';
C1FORMAT = 'ARPCDRW01';

// Initialize filter year to current year
Exec SQL
  Set :FILTERYEAR = Year(Current Date);

// Load all records into array
LoadAllRecords();

// Load records into subfile
LoadSubfile();

Dow Not Done;
  DisplaySubfile();

  // Check for function keys
  Select;
    When INFDS.choice = LeaveProgram;  // F3
      Done = *On;
    When INFDS.choice = Previous;      // F12
      Done = *On;
    When INFDS.choice = Refresh;       // F5
      LoadAllRecords();
      LoadSubfile();
    When INFDS.choice = AddRecord;     // F6
      AddNewRecord();
      LoadAllRecords();
      LoadSubfile();
    When INFDS.choice = Generate;      // F9
      GenerateYearDates();
      LoadAllRecords();
      LoadSubfile();
    Other;
      // Process subfile options (option 2 = change)
      ProcessOptions();
      // Reload based on changed filter year or after updates
      LoadAllRecords();
      LoadSubfile();
  EndSl;
EndDo;

Close ARDCDRW01;
*InLR = *On;
Return;

//==============================================================================
// LoadAllRecords - Load all records from ARPCDRAWD table into array
//==============================================================================
Dcl-Proc LoadAllRecords;

  // SQL cursor to fetch records from ARPCDRAWD filtered by year
  // Include records where either DRAWDATE or PPBEGIN is in the selected year
  Exec SQL Declare C1 Scroll Cursor For
    Select DRAWDATE, PPBEGIN, PPEND,
           Upper(DayName(Date(DRAWDATE)))
    From ARPCDRAWD
    Where Year(Date(PPBEGIN)) = :FILTERYEAR
    Order By DRAWDATE
    For Read Only;

  Exec SQL Open C1;

  // Fetch all records into array (up to 1000 rows)
  Exec SQL
    Fetch Next From C1 For 1000 Rows
    Into :PayrollDateDS;
  Exec SQL Get Diagnostics :TotalRecords = ROW_COUNT;

  Exec SQL Close C1;

  // Reset current index
  CurrentIndex = 0;

End-Proc;

//==============================================================================
// LoadSubfile - Load records from array into subfile
//==============================================================================
Dcl-Proc LoadSubfile;

  // Clear subfile
  SflClr = *On;
  SflDsp = *Off;
  SflDspCtl = *On;
  SCRRN = 0;
  Write SUB01CTL;
  SflClr = *Off;

  // Load records from array into subfile
  For i = 1 To TotalRecords;
    SCRRN += 1;
    S1OPT = ' ';
    // Convert ISO dates to numeric MMDDYY format for display
    S1DRAW = %Dec(%Char(%Date(PayrollDateDS(i).drawDate:*ISO):*MDY0):6:0);
    S1DOW = PayrollDateDS(i).dayOfWeek;
    S1BEGIN = %Dec(%Char(%Date(PayrollDateDS(i).ppBegin:*ISO):*MDY0):6:0);
    S1END = %Dec(%Char(%Date(PayrollDateDS(i).ppEnd:*ISO):*MDY0):6:0);
    Write SUB01;
  EndFor;

  // Set display indicators and position to first record
  If SCRRN > 0;
    SflDsp = *On;
    SflEnd = *On;
    SCRRN = 1;  // Position cursor to first record
    WHERE = 1;  // Reset cursor position field
  EndIf;

End-Proc;

//==============================================================================
// DisplaySubfile - Display the subfile control record
//==============================================================================
Dcl-Proc DisplaySubfile;

  // Clear any previous messages
  If screenError = *Off;
    $clearmsg('*' : 0 : '' : '*ALL' : ApiError);
  EndIf;

  // Set program queue for message subfile
  PGMQ = PSDS.PgmName;

  // Write message control and footer before displaying subfile
  Write MSGCTL;
  Write FOOTER;
  Exfmt SUB01CTL;

  // Reset screen error flag and clear messages after display
  Reset screenError;
  $clearmsg('*' : 0 : '' : '*ALL' : ApiError);

End-Proc;

//==============================================================================
// ProcessOptions - Process subfile options
//==============================================================================
Dcl-Proc ProcessOptions;
  Dcl-S oldDrawDate Char(10);

  // Read through subfile to find changed records
  SCRRN = 0;

  Dow SCRRN < TotalRecords;
    SCRRN += 1;

    // Read subfile record
    Chain SCRRN SUB01;

    If %Found(ARDCDRW01);
      // Check if option 2 was entered (Change)
      If S1OPT = '2';
        // Save the original draw date (key field)
        oldDrawDate = PayrollDateDS(SCRRN).drawDate;

        // Call Maintenance procedure to handle date editing
        Maintenance(oldDrawDate : SCRRN);

        // Clear the option field
        S1OPT = ' ';
        Update SUB01;
      EndIf;
    EndIf;
  EndDo;

End-Proc;

//==============================================================================
// Maintenance - Handle date maintenance window for editing payroll dates
//==============================================================================
Dcl-Proc Maintenance;
  Dcl-Pi *N;
    pOldDrawDate Char(10);
    pScreenRec Packed(4:0);
  End-Pi;

  Dcl-S windowDone Ind;
  Dcl-S drawDateISO Char(10);
  Dcl-S beginDateISO Char(10);
  Dcl-S endDateISO Char(10);
  Dcl-S drawDateNum Packed(6:0);
  Dcl-S beginDateNum Packed(6:0);
  Dcl-S endDateNum Packed(6:0);
  Dcl-S tempDayOfWeek Char(9);

  // Display window for editing dates
  windowDone = *Off;

  // Load current values into window fields ONCE (convert ISO to numeric MMDDYY)
  drawDateNum = %Dec(%Char(%Date(PayrollDateDS(pScreenRec).drawDate:*ISO):*MDY0):6:0);
  beginDateNum = %Dec(%Char(%Date(PayrollDateDS(pScreenRec).ppBegin:*ISO):*MDY0):6:0);
  endDateNum = %Dec(%Char(%Date(PayrollDateDS(pScreenRec).ppEnd:*ISO):*MDY0):6:0);

  WDRAW = drawDateNum;
  WBEGIN = beginDateNum;
  WEND = endDateNum;

  // Write window border once before loop
  Write WINBORDER;

  Dow Not windowDone;
    // Clear any previous window messages and indicators before display
    $clearmsg('*' : 0 : '' : '*ALL' : ApiError);
    IndDrawErr = *Off;
    IndBeginErr = *Off;
    IndEndErr = *Off;

    // Set program queue for window message subfile
    WINPGMQ = PSDS.PgmName;

    // Write window message control and display the window
    Write WINMSGCTL;
    Exfmt EDITWIN;

    // Reset screen error flag after user input
    screenError = *Off;
    *in25 = *off;
    *in26 = *off;
    *in27 = *off;

    // Check for F3 or F12 (Cancel)
    If INFDS.choice = LeaveProgram Or INFDS.choice = Previous;  // F3 or F12
      windowDone = *On;
    Else;
      // Validate dates using TEST(DE) operation code directly on numeric fields
      Test(DE) *MDY WDRAW;
      If %Error();
        // Invalid draw date - send error message
        screenError = *On;
        *in25 = *on;
        IndDrawErr = *On;
        CSRROW = 3;
        CSRCOL = 14;
        messageid = 'DRW0001';
        messagedata = '';
        messageLen = 0;
        SendMessage();
      Else;
        Test(DE) *MDY WBEGIN;
        If %Error();
          // Invalid begin date - send error message
          screenError = *On;
          *in26 = *on;
          IndBeginErr = *On;
          CSRROW = 5;
          CSRCOL = 14;
          messageid = 'DRW0002';
          messagedata = '';
          messageLen = 0;
          SendMessage();
        Else;
          Test(DE) *MDY WEND;
          If %Error();
            // Invalid end date - send error message
            screenError = *On;
            *in27 = *on;
            IndEndErr = *On;
            CSRROW = 7;
            CSRCOL = 14;
            messageid = 'DRW0003';
            messagedata = '';
            messageLen = 0;
            SendMessage();
          EndIf;
        EndIf;
      EndIf;

      // Only proceed if all dates are valid
      If Not screenError;
        // All dates are valid - convert numeric MMDDYY fields to ISO format
        // Use Monitor to catch invalid dates like 2/35/27
        Monitor;
          drawDateISO = %Char(%Date(WDRAW:*MDY):*ISO);
          beginDateISO = %Char(%Date(WBEGIN:*MDY):*ISO);
          endDateISO = %Char(%Date(WEND:*MDY):*ISO);
        On-Error;
          // Date conversion failed - invalid date (e.g., 2/35/27)
          screenError = *On;
          IndDrawErr = *On;  // Highlight first field by default
          CSRROW = 3;
          CSRCOL = 14;
          messageid = 'GEN0010';
          messagedata = *blanks;
          messageLen = %Len(%Trim(messagedata));
          SendMessage();
        EndMon;

        // Only proceed if conversion was successful
        If Not screenError;
          // Validate dates before updating
          If ValidateDates(drawDateISO:beginDateISO:endDateISO);
          // Update the record in the database with ISO dates
          Exec SQL
            Update ARPCDRAWD
            Set DRAWDATE = :drawDateISO,
                PPBEGIN = :beginDateISO,
                PPEND = :endDateISO
            Where DRAWDATE = :pOldDrawDate;

          If SQLCODE = 0;
            // Update successful - update array with ISO dates
            PayrollDateDS(pScreenRec).drawDate = drawDateISO;
            PayrollDateDS(pScreenRec).ppBegin = beginDateISO;
            PayrollDateDS(pScreenRec).ppEnd = endDateISO;

            // Update day of week using temporary variable
            Exec SQL
              Set :tempDayOfWeek =
                Upper(DayName(Date(:drawDateISO)));
            PayrollDateDS(pScreenRec).dayOfWeek = tempDayOfWeek;

            // Success - stay in window, user must press F3/F12 to exit
          Else;
            // SQL error - send error message
            screenError = *On;
            messageid = 'GEN0010';
            messagedata = *blanks;
            messageLen = %Len(%Trim(messagedata));
            SendMessage();
          EndIf;
          Else;
            // Validation failed - error message already sent by ValidateDates
          EndIf;
        EndIf;
      EndIf;
    EndIf;
  EndDo;

End-Proc;

//==============================================================================
// GenerateYearDates - Generate payroll dates for the filtered year
//==============================================================================
Dcl-Proc GenerateYearDates;
  Dcl-S lastDrawDate Date;
  Dcl-S lastDrawDateISO Char(10);
  Dcl-S lastEndDateISO Char(10);
  Dcl-S newDrawDate Date;
  Dcl-S newBeginDate Date;
  Dcl-S newEndDate Date;
  Dcl-S drawDateISO Char(10);

  Dcl-S beginDateISO Char(10);

  Dcl-S endDateISO Char(10);

  Dcl-S recordsAdded Int(10) Inz(0);
  Dcl-S existingCount Int(10) Inz(0);
  Dcl-S dayOfWeek Int(5) Inz(0);

  // Check if any records exist for the filtered year
  Exec SQL
    Select Count(*)
    Into :existingCount
    From ARPCDRAWD
    Where Year(Date(PPBEGIN)) = :FILTERYEAR;

  If existingCount > 0;
    // Records already exist for this year - don't generate
    Return;
  EndIf;

  // Get the last draw date and end date from the previous year
  Exec SQL
    Select Max(DRAWDATE), Max(PPEND)
    Into :lastDrawDateISO, :lastEndDateISO
    From ARPCDRAWD
    Where Year(Date(PPBEGIN)) < :FILTERYEAR;

  If SQLCODE <> 0 Or lastDrawDateISO = '';
    // No previous records found - cannot generate
    Return;
  EndIf;

  lastDrawDate = %Date(lastDrawDateISO:*ISO);

  // Draw dates are every 14 days - start with last draw date + 14
  newDrawDate = lastDrawDate + %Days(14);

  // Generate bi-weekly pay periods for the year
  Dow %Subdt(newDrawDate:*Years) <= FILTERYEAR;
    // Calculate end date: 5 days before draw date (Sunday)
    newEndDate = newDrawDate - %Days(5);

    // Calculate begin date: 13 days before end date (Monday)
    newBeginDate = newEndDate - %Days(13);

    // Verify begin date is a Monday using SQL DAYOFWEEK (2=Monday)
    beginDateISO = %Char(newBeginDate:*ISO);
    Exec SQL
      Set :dayOfWeek = DAYOFWEEK(Date(:beginDateISO));

    // If not Monday, adjust to the previous Monday
    Dow dayOfWeek <> 2;
      newBeginDate -= %Days(1);
      beginDateISO = %Char(newBeginDate:*ISO);
      Exec SQL
        Set :dayOfWeek = DAYOFWEEK(Date(:beginDateISO));
    EndDo;

    // Convert to ISO format
    drawDateISO = %Char(newDrawDate:*ISO);
    beginDateISO = %Char(newBeginDate:*ISO);
    endDateISO = %Char(newEndDate:*ISO);

    // Insert the record
    Exec SQL
      Insert Into ARPCDRAWD (DRAWDATE, PPBEGIN, PPEND)
      Values (:drawDateISO, :beginDateISO, :endDateISO);

    If SQLCODE = 0;
      recordsAdded += 1;
    EndIf;

    // Move to next draw date (14 days later)
    newDrawDate += %Days(14);
  EndDo;

End-Proc;

//==============================================================================
// AddNewRecord - Add a new payroll date record
//==============================================================================
Dcl-Proc AddNewRecord;
  Dcl-S windowDone Ind;
  Dcl-S drawDateISO Char(10);

  Dcl-S beginDateISO Char(10);

  Dcl-S endDateISO Char(10);

  Dcl-S tempDayOfWeek Char(9);
  Dcl-S tempDateChar Char(10);
  Dcl-S tempDateNum Packed(6:0);

  windowDone = *Off;

  // Initialize fields to zeros
  WDRAW = 0;
  WBEGIN = 0;
  WEND = 0;

  // Write window border once before loop
  Write WINBORDER;

  Dow Not windowDone;
    // Clear any previous window messages and indicators before display
    $clearmsg('*' : 0 : '' : '*ALL' : ApiError);
    IndDrawErr = *Off;
    IndBeginErr = *Off;
    IndEndErr = *Off;

    // Set program queue for window message subfile
    WINPGMQ = PSDS.PgmName;

    // Write window message control and display the window
    Write WINMSGCTL;
    Exfmt EDITWIN;

    // Reset screen error flag after user input
    screenError = *Off;
    *in25 = *off;
    *in26 = *off;
    *in27 = *off;

    // Check for F3 or F12 (Cancel)
    If INFDS.choice = LeaveProgram Or INFDS.choice = Previous;  // F3 or F12
      windowDone = *On;
    Else;
      // Validate dates using TEST(DE) operation code directly on numeric fields
      Test(DE) *MDY WDRAW;
      If %Error();
        // Invalid draw date - send error message
        screenError = *On;
        *in25 = *on;
        IndDrawErr = *On;
        CSRROW = 3;
        CSRCOL = 14;
        messageid = 'DRW0001';
        messagedata = '';
        messageLen = 0;
        SendMessage();
      Else;
        Test(DE) *MDY WBEGIN;
        If %Error();
          // Invalid begin date - send error message
          screenError = *On;
          *in26 = *on;
          IndBeginErr = *On;
          CSRROW = 5;
          CSRCOL = 14;
          messageid = 'DRW0002';
          messagedata = '';
          messageLen = 0;
          SendMessage();
        Else;
          Test(DE) *MDY WEND;
          If %Error();
            // Invalid end date - send error message
            screenError = *On;
            *in27 = *on;
            IndEndErr = *On;
            CSRROW = 7;
            CSRCOL = 14;
            messageid = 'DRW0003';
            messagedata = '';
            messageLen = 0;
            SendMessage();
          EndIf;
        EndIf;
      EndIf;

      // Only proceed if all dates are valid
      If Not screenError;
        // All dates are valid - convert numeric MMDDYY fields to ISO format
        // Use Monitor to catch invalid dates like 2/35/27
        Monitor;
          drawDateISO = %Char(%Date(WDRAW:*MDY):*ISO);
          beginDateISO = %Char(%Date(WBEGIN:*MDY):*ISO);
          endDateISO = %Char(%Date(WEND:*MDY):*ISO);
        On-Error;
          // Date conversion failed - invalid date (e.g., 2/35/27)
          screenError = *On;
          IndDrawErr = *On;  // Highlight first field by default
          CSRROW = 3;
          CSRCOL = 14;
          messageid = 'GEN0010';
          messagedata = *blanks;
          messageLen = %Len(%Trim(messagedata));
          SendMessage();
        EndMon;

        // Only proceed if conversion was successful
        If Not screenError;
          // Validate dates before inserting
          If ValidateDates(drawDateISO:beginDateISO:endDateISO);
          // Insert the new record into the database
          Exec SQL
            Insert Into ARPCDRAWD (DRAWDATE, PPBEGIN, PPEND)
            Values (:drawDateISO, :beginDateISO, :endDateISO);

            If SQLCODE = 0;
              // Insert successful - stay in window, user must press F3/F12 to exit
            Else;
              // SQL error - send error message
              screenError = *On;
              messageid = 'GEN0010';
              messagedata = *blanks;
              messageLen = %Len(%Trim(messagedata));
              SendMessage();
            EndIf;
          Else;
            // Validation failed - error message already sent by ValidateDates
          EndIf;
        EndIf;
      EndIf;
    EndIf;
  EndDo;

End-Proc;

//==============================================================================
// ValidateDates - Validate date fields
//==============================================================================
Dcl-Proc ValidateDates;
  Dcl-Pi *N Ind;
    pDrawDate Char(10) Const;
    pBeginDate Char(10) Const;
    pEndDate Char(10) Const;
  End-Pi;

  Dcl-S drawDate Date;
  Dcl-S beginDate Date;
  Dcl-S endDate Date;
  Dcl-S isValid Ind Inz(*On);
  Dcl-S dayOfWeek Int(5) Inz(0);

  // Validate Draw Date
  Monitor;
    drawDate = %Date(pDrawDate:*ISO);
  On-Error;
    isValid = *Off;
    screenError = *On;
    messageid = 'DRW0001';
    messagedata = '';
    messageLen = 0;
    SendMessage();
    Return isValid;
  EndMon;

  // Validate Begin Date
  Monitor;
    beginDate = %Date(pBeginDate:*ISO);
  On-Error;
    isValid = *Off;
    screenError = *On;
    messageid = 'DRW0002';
    messagedata = '';
    messageLen = 0;
    SendMessage();
    Return isValid;
  EndMon;

  // Validate End Date
  Monitor;
    endDate = %Date(pEndDate:*ISO);
  On-Error;
    isValid = *Off;
    screenError = *On;
    messageid = 'DRW0003';
    messagedata = '';
    messageLen = 0;
    SendMessage();
    Return isValid;
  EndMon;

  // Validate that Begin Date is before or equal to End Date
  If beginDate > endDate;
    isValid = *Off;
    screenError = *On;
    messageid = 'DRW0002';
    messagedata = '';
    messageLen = 0;
    SendMessage();
    Return isValid;
  EndIf;

  // Validate that Begin Date is a Monday using SQL DAYOFWEEK (2=Monday)
  Exec SQL
    Set :dayOfWeek = DAYOFWEEK(Date(:pBeginDate));

  If dayOfWeek <> 2;
    isValid = *Off;
    screenError = *On;
    messageid = 'CPF9999';
    messagedata = 'Begin date must be a Monday unless it is a holiday';
    messageLen = %Len(%Trim(messagedata));
    SendMessage();
    Return isValid;
  EndIf;

  // Validate that Draw Date is within or after the pay period
  If drawDate < beginDate;
    isValid = *Off;
    screenError = *On;
    messageid = 'DRW0001';
    messagedata = '';
    messageLen = 0;
    SendMessage();
    Return isValid;
  EndIf;

  Return isValid;

End-Proc;

//==============================================================================
// EditDateWindow - Handle edit window display and validation
// Parameters: pDrawDate, pBeginDate, pEndDate (in/out)
//             pOldDrawDate (for updates, blank for adds)
// Returns: *On if saved, *Off if cancelled
//==============================================================================
Dcl-Proc EditDateWindow;
  Dcl-Pi *N Ind;
    pDrawDate Char(10);
    pBeginDate Char(10);
    pEndDate Char(10);
    pOldDrawDate Char(10) Const Options(*NoPass);
  End-Pi;

  Dcl-S windowDone Ind Inz(*Off);
  Dcl-S drawDateISO Char(10);
  Dcl-S beginDateISO Char(10);
  Dcl-S endDateISO Char(10);
  Dcl-S drawDateNum Packed(6:0);
  Dcl-S beginDateNum Packed(6:0);
  Dcl-S endDateNum Packed(6:0);
  Dcl-S isUpdate Ind;
  Dcl-S oldDrawDate Char(10);
  Dcl-S tempDayOfWeek Char(9);
  Dcl-S savedSuccessfully Ind Inz(*Off);

  // Determine if this is an update or add
  isUpdate = (%Parms() >= 4 And pOldDrawDate <> '');
  If isUpdate;
    oldDrawDate = pOldDrawDate;
  EndIf;

  // Convert ISO dates to numeric MMDDYY for display
  If pDrawDate <> '';
    drawDateNum = %Dec(%Char(%Date(pDrawDate:*ISO):*MDY0):6:0);
    beginDateNum = %Dec(%Char(%Date(pBeginDate:*ISO):*MDY0):6:0);
    endDateNum = %Dec(%Char(%Date(pEndDate:*ISO):*MDY0):6:0);
  Else;
    drawDateNum = 0;
    beginDateNum = 0;
    endDateNum = 0;
  EndIf;

  WDRAW = drawDateNum;
  WBEGIN = beginDateNum;
  WEND = endDateNum;

  // Write window border once before loop
  Write WINBORDER;

  Dow Not windowDone;
    // Clear any previous window messages and indicators before display
    $clearmsg('*' : 0 : '' : '*ALL' : ApiError);
    IndDrawErr = *Off;
    IndBeginErr = *Off;
    IndEndErr = *Off;

    // Set program queue for window message subfile
    WINPGMQ = PSDS.PgmName;

    // Write window message control and display the window
    Write WINMSGCTL;
    Exfmt EDITWIN;

    // Reset screen error flag after user input
    screenError = *Off;
    *in25 = *off;
    *in26 = *off;
    *in27 = *off;

    // Check for F3 or F12 (Cancel)
    If INFDS.choice = LeaveProgram Or INFDS.choice = Previous;
      windowDone = *On;
      savedSuccessfully = *Off;
    Else;
      // Validate dates using TEST(DE) operation code
      Test(DE) *MDY WDRAW;
      If %Error();
        screenError = *On;
        *in25 = *on;
        IndDrawErr = *On;
        CSRROW = 3;
        CSRCOL = 14;
        messageid = 'DRW0001';
        messagedata = '';
        messageLen = 0;
        SendMessage();
      Else;
        Test(DE) *MDY WBEGIN;
        If %Error();
          screenError = *On;
          *in26 = *on;
          IndBeginErr = *On;
          CSRROW = 5;
          CSRCOL = 14;
          messageid = 'DRW0002';
          messagedata = '';
          messageLen = 0;
          SendMessage();
        Else;
          Test(DE) *MDY WEND;
          If %Error();
            screenError = *On;
            *in27 = *on;
            IndEndErr = *On;
            CSRROW = 7;
            CSRCOL = 14;
            messageid = 'DRW0003';
            messagedata = '';
            messageLen = 0;
            SendMessage();
          EndIf;
        EndIf;
      EndIf;

      // Only proceed if all dates are valid
      If Not screenError;
        // Convert numeric MMDDYY fields to ISO format
        Monitor;
          drawDateISO = %Char(%Date(WDRAW:*MDY):*ISO);
          beginDateISO = %Char(%Date(WBEGIN:*MDY):*ISO);
          endDateISO = %Char(%Date(WEND:*MDY):*ISO);
        On-Error;
          screenError = *On;
          IndDrawErr = *On;
          CSRROW = 3;
          CSRCOL = 14;
          messageid = 'GEN0010';
          messagedata = 'Invalid date entered';
          messageLen = %Len(%Trim(messagedata));
          SendMessage();
        EndMon;

        // Only proceed if conversion was successful
        If Not screenError;
          // Validate dates before saving
          If ValidateDates(drawDateISO:beginDateISO:endDateISO);
            // Save to database
            If isUpdate;
              // Update existing record
              Exec SQL
                Update ARPCDRAWD
                Set DRAWDATE = :drawDateISO,
                    PPBEGIN = :beginDateISO,
                    PPEND = :endDateISO
                Where DRAWDATE = :oldDrawDate;
            Else;
              // Insert new record
              Exec SQL
                Insert Into ARPCDRAWD (DRAWDATE, PPBEGIN, PPEND)
                Values (:drawDateISO, :beginDateISO, :endDateISO);
            EndIf;

            If SQLCODE = 0;
              // Save successful - return values
              pDrawDate = drawDateISO;
              pBeginDate = beginDateISO;
              pEndDate = endDateISO;
              savedSuccessfully = *On;
              // Stay in window - user must press F3/F12 to exit
            Else;
              // SQL error
              screenError = *On;
              messageid = 'GEN0010';
              If isUpdate;
                messagedata = 'Database update failed - SQLCODE: ' + %Char(SQLCODE);
              Else;
                messagedata = 'Database insert failed - SQLCODE: ' + %Char(SQLCODE);
              EndIf;
              messageLen = %Len(%Trim(messagedata));
              SendMessage();
            EndIf;
          EndIf;
        EndIf;
      EndIf;
    EndIf;
  EndDo;

  Return savedSuccessfully;

End-Proc;

//==============================================================================
// SendMessage - Send program message to message subfile
//==============================================================================
Dcl-Proc SendMessage;

  messageFile = 'ECMMSGF   *LIBL     ';
  $sendmsg(messageID :
           messageFile :
           messagedata :
           messageLen :
           '*DIAG' :
           PSDS.PgmName :
           messagecsc :
           messagekey :
           ApiError);

End-Proc;

