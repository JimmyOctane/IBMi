        //==============================================================================
        //  Program:      AVATAXLOAD - AvaTax CSV Data Loader
        //  Description:  Reads CSV file using QSYS2.IFS_READ and loads into AVATAX
        //  File Path:    /home/jflanary/AVATAX.csv (adjust as needed)
        //  Author:       Generated
        //  Created:      2026-03-13
        //==============================================================================

     // Control Options
     Ctl-Opt Option(*SrcStmt:*NoDebugIO);
     Ctl-Opt ExtBinInt(*Yes);
     Ctl-Opt bnddir('ECBIND');
     Ctl-Opt DecEdit('0,');
     Ctl-Opt Copyright('East Coast Metals - BECTRAN SFTP');
     Ctl-Opt DftActGrp(*No);

     // SQL Communication Area
     Exec SQL Include SQLCA;

     // Working Variables
     Dcl-S recordCount    Int(10) Inz(0);
     Dcl-S errorCount     Int(10) Inz(0);
     Dcl-S skipHeader     Ind Inz(*On);
     
     // Field variables for parsed CSV
     Dcl-S inputLine      Varchar(500);
     Dcl-S usageDate      Char(10);
     Dcl-S docRegions     Char(2);
     Dcl-S documentCode   Char(40);
     Dcl-S transDate      Date;

     // -----------------------------------------------------------------------
     // Main Processing
     // -----------------------------------------------------------------------
     *InLR = *On;

     // Set SQL options
     Exec SQL Set Option Commit = *None, DatFmt = *ISO, Closqlcsr = *EndMod;

     // Optional: Clear the table before loading
            // Uncomment the following lines if you want to clear existing data
            // Exec SQL Delete From AVATAX;
            // If SQLCODE < 0;
            //   Dsply ('Error clearing table: ' + %Char(SQLCODE));
            //   Return;
            // EndIf;
            // Dsply ('Table cleared successfully');

     // Declare cursor to read IFS file
     Exec SQL
       Declare C1 Cursor For
       Select Line
       From Table(QSYS2.IFS_READ(PATH_NAME => '/home/jflanary/AVATAX.csv'));

     // Open cursor
     Exec SQL Open C1;
     If SQLCODE < 0;
       Dsply ('Error opening cursor: ' + %Char(SQLCODE));
       Return;
     EndIf;
     Dsply ('File opened successfully');

     // Read and process each line
     DoW SQLCODE = 0;
       Exec SQL Fetch Next From C1 Into :inputLine;
       
       If SQLCODE = 0;
         // Skip header row
         If skipHeader;
           skipHeader = *Off;
           Iter;
         EndIf;

         // Parse CSV line
         parseCSVLine(inputLine);

         // Convert date from MM/DD/YYYY to DATE format
         Monitor;
           transDate = convertToDate(usageDate);
         On-Error;
           errorCount += 1;
           Iter;
         EndMon;

         // Insert into AVATAX table
         Exec SQL
           Insert Into AVATAX (TRANSDATE, REGION, ID)
           Values (:transDate, :docRegions, :documentCode);

         If SQLCODE < 0;
           errorCount += 1;
           // Optionally log the error
           // Dsply ('Insert error: ' + %Char(SQLCODE) + ' Line: ' + inputLine);
         Else;
           recordCount += 1;
           // Display progress every 10000 records
           If %Rem(recordCount : 10000) = 0;
             Dsply ('Processed: ' + %Char(recordCount) + ' records');
           EndIf;
         EndIf;
       EndIf;
     EndDo;

     // Close cursor
     Exec SQL Close C1;

     // Display final statistics
     Dsply ('=====================================');
     Dsply ('Load complete!');
     Dsply ('Records loaded: ' + %Char(recordCount));
     Dsply ('Errors: ' + %Char(errorCount));
     Dsply ('=====================================');

     Return;

     // -----------------------------------------------------------------------
     // Procedure: parseCSVLine
     // Parse a CSV line with 3 fields: USAGE_DATE,DOC_REGIONS,DOCUMENT_CODE
     // -----------------------------------------------------------------------
     Dcl-Proc parseCSVLine;
     Dcl-Pi *N;
       line Varchar(500) Const;
     End-Pi;

     Dcl-S pos1 Int(10);
     Dcl-S pos2 Int(10);

     // Clear variables
     usageDate = '';
     docRegions = '';
     documentCode = '';

     // Find first comma (after USAGE_DATE)
     pos1 = %Scan(',' : line);
     If pos1 > 0;
       usageDate = %Trim(%Subst(line : 1 : pos1 - 1));
       
       // Find second comma (after DOC_REGIONS)
       pos2 = %Scan(',' : line : pos1 + 1);
       If pos2 > 0;
         docRegions = %Trim(%Subst(line : pos1 + 1 : pos2 - pos1 - 1));
         documentCode = %Trim(%Subst(line : pos2 + 1));
       Else;
         // Only two fields found
         docRegions = %Trim(%Subst(line : pos1 + 1));
       EndIf;
     EndIf;

     End-Proc;

     // -----------------------------------------------------------------------
     // Procedure: convertToDate
     // Convert MM/DD/YYYY string to DATE
     // -----------------------------------------------------------------------
     Dcl-Proc convertToDate;
     Dcl-Pi *N Date;
       dateStr Char(10) Const;
     End-Pi;

     Dcl-S month Char(2);
     Dcl-S day Char(2);
     Dcl-S year Char(4);
     Dcl-S isoDate Char(10);
     Dcl-S resultDate Date;

     // Parse MM/DD/YYYY
     month = %Subst(dateStr : 1 : 2);
     day = %Subst(dateStr : 4 : 2);
     year = %Subst(dateStr : 7 : 4);

     // Build ISO format: YYYY-MM-DD
     isoDate = year + '-' + month + '-' + day;

     // Convert to DATE
     resultDate = %Date(isoDate : *ISO);

     Return resultDate;

     End-Proc;
