**FREE
//==============================================================================
// Program: RUNPYUSD - Run Python USD to CAD Exchange Rate Script
// Description: Executes Python script to fetch USD to CAD exchange rate
//              and displays the results
// Author: Generated
// Date: 2026-03-04
//==============================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIO);

// Prototypes for system APIs
Dcl-PR Qp0zLprintf Int(10) ExtProc('Qp0zLprintf');
  *N Pointer Value Options(*String);
End-PR;

Dcl-PR QCMDEXC ExtPgm('QCMDEXC');
  *N Char(3000) Options(*VarSize);
  *N Packed(15:5);
End-PR;

// Variables
Dcl-S qshCmd Char(3000);
Dcl-S cmdLen Packed(15:5);
Dcl-S outputFile Char(256) Inz('/tmp/usd_cad_output.txt');
Dcl-S testCmd Char(3000);

// SQL Variables for reading output
Dcl-S outputLine Varchar(500);
Dcl-S lineCount Int(10);
Dcl-S fileExists Char(1);

//==============================================================================
// Main Processing
//==============================================================================

// Display header
Qp0zLprintf('========================================');
Qp0zLprintf('USD to CAD Exchange Rate Fetcher');
Qp0zLprintf('========================================');
Qp0zLprintf(' ');

// First, test if we can write to the output file
Qp0zLprintf('Testing output file access...');
testCmd = 'QSH CMD(''echo "Test output" > /tmp/usd_cad_output.txt'')';
cmdLen = %Len(%TrimR(testCmd));

Monitor;
  QCMDEXC(testCmd: cmdLen);
  Qp0zLprintf('Output file test successful.');
On-Error;
  Qp0zLprintf('ERROR: Cannot write to output file.');
EndMon;

Qp0zLprintf(' ');
Qp0zLprintf('Executing Python script...');

// Build QSH command
qshCmd = 'QSH CMD(''/home/jflanary/run_python_usd.sh'')';
cmdLen = %Len(%TrimR(qshCmd));

// Execute the command
Monitor;
  QCMDEXC(qshCmd: cmdLen);
  Qp0zLprintf('Shell script executed.');
On-Error;
  Qp0zLprintf('ERROR: Failed to execute shell script.');
  Qp0zLprintf('Make sure /home/jflanary/run_python_usd.sh exists');
  Qp0zLprintf('and is executable (chmod +x)');
EndMon;

Qp0zLprintf(' ');
Qp0zLprintf('========================================');
Qp0zLprintf('Output from Python script:');
Qp0zLprintf('========================================');

// Check if output file exists using SQL
Exec SQL
  SELECT CASE WHEN COUNT(*) > 0 THEN 'Y' ELSE 'N' END
  INTO :fileExists
  FROM TABLE(QSYS2.IFS_OBJECT_STATISTICS(
    START_PATH_NAME => '/tmp',
    OBJECT_NAME => 'usd_cad_output.txt'
  ));

If fileExists = 'N';
  Qp0zLprintf('ERROR: Output file was not created.');
  Qp0zLprintf('The shell script may not have executed properly.');
  *InLR = *On;
  Return;
EndIf;

Qp0zLprintf('Output file found. Reading contents...');
Qp0zLprintf(' ');

// Read and display the output file
Exec SQL
  DECLARE output_cursor CURSOR FOR
  SELECT line
  FROM TABLE(QSYS2.IFS_READ(
    PATH_NAME => :outputFile,
    END_OF_LINE => 'LF'
  ));

Exec SQL OPEN output_cursor;

lineCount = 0;

Dou 1=0;
  Exec SQL FETCH NEXT FROM output_cursor INTO :outputLine;
  
  If SQLCODE <> 0;
    Leave;
  EndIf;
  
  lineCount += 1;
  Qp0zLprintf(%Trim(outputLine));
EndDo;

Exec SQL CLOSE output_cursor;

If lineCount = 0;
  Qp0zLprintf('Output file is empty.');
  Qp0zLprintf(' ');
  Qp0zLprintf('Troubleshooting steps:');
  Qp0zLprintf('1. Check Python: which python3');
  Qp0zLprintf('2. Install if needed: yum install python3');
  Qp0zLprintf('3. Install requests: pip3 install requests');
  Qp0zLprintf('4. Test manually: /home/jflanary/run_python_usd.sh');
  Qp0zLprintf('5. Check output: cat /tmp/usd_cad_output.txt');
Else;
  Qp0zLprintf(' ');
  Qp0zLprintf('Total lines read: ' + %Char(lineCount));
EndIf;

Qp0zLprintf(' ');
Qp0zLprintf('========================================');
Qp0zLprintf('Program completed.');
Qp0zLprintf('========================================');

*InLR = *On;
Return;
