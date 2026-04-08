**FREE
//==============================================================================
// Program: ARPCDRAWD
// Purpose: Display Payroll Draw Dates from ARPCDRAWD table
//==============================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIO);

// Display File
Dcl-F ARPCDRAWD WorkStn Sfile(SUB01:SCRRN) IndDs(Indicators) Infds(INFDS) UsrOpn;

// File Information Data Structure
Dcl-Ds INFDS Qualified;
  choice    Char(1) Pos(369);
  cLocation Char(2) Pos(370);
  curRec    Int(5:0) Pos(378);
End-Ds;

// Command Key Constants
Dcl-C LeaveProgram Const(x'33');  // F3
Dcl-C Refresh      Const(x'35');  // F5
Dcl-C Previous     Const(x'3C');  // F12

// Indicator Data Structure
Dcl-Ds Indicators;
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

// Data structure array for batch fetching
Dcl-Ds PayrollDateDS Dim(1000) Qualified;
  drawDate      Date;       // Payroll Draw Date
  ppBegin       Date;       // Payroll Begin Date
  ppEnd         Date;       // Payroll End Date
End-Ds;

// Work fields
Dcl-S SCRRN Packed(4:0);
Dcl-S Done Ind Inz(*Off);
Dcl-S TotalRecords Int(10) Inz(0);
Dcl-S CurrentIndex Int(10) Inz(0);
Dcl-S i Int(10) Inz(0);

// Main processing
Open ARPCDRAWD;

// Set SQL options
Exec SQL Set Option Commit=*None, DatFmt=*ISO, ClosqlCsr=*EndMod;

// Initialize display fields
USERID = PSDS.UserId;
C1TITLE = 'Payroll Draw Date Maintenance';
C1DISPLAY = 'Display Mode';
C1FORMAT = 'ARPCDRAWD';

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
  EndSl;
EndDo;

Close ARPCDRAWD;
*InLR = *On;
Return;

//==============================================================================
// LoadAllRecords - Load all records from database into array
//==============================================================================
Dcl-Proc LoadAllRecords;
  
  // SQL cursor to fetch all records
  Exec SQL Declare C1 Scroll Cursor For
    Select DRAWDATE, PPBEGIN, PPEND
    From ARPCDRAWD
    Order By DRAWDATE
    For Read Only;
  
  Exec SQL Open C1;
  
  // Fetch all records into array
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
  SflDspCtl = *On;
  Write SUB01CTL;
  SflClr = *Off;
  
  SCRRN = 0;
  
  // Load records from array into subfile
  For i = 1 To TotalRecords;
    SCRRN += 1;
    S1OPT = ' ';
    S1DRAW = %Char(PayrollDateDS(i).drawDate);
    S1BEGIN = %Char(PayrollDateDS(i).ppBegin);
    S1END = %Char(PayrollDateDS(i).ppEnd);
    Write SUB01;
  EndFor;
  
  // Set end of subfile
  If SCRRN = 0;
    SflDsp = *Off;
  Else;
    SflDsp = *On;
    SflEnd = *On;
  EndIf;
  
End-Proc;

//==============================================================================
// DisplaySubfile - Display the subfile control record
//==============================================================================
Dcl-Proc DisplaySubfile;
  
  // Display subfile control and footer
  Exfmt SUB01CTL;
  Write FOOTER;
  
End-Proc;
