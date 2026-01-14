**==============================================================================
**  Program:      ZIPLOAD - ZIP Code Data Loader from IFS CSV
**  Description:  Reads CSV file using QSYS2.IFS_READ and loads into ECZIPCODE
**  File Path:    /home/jflanary/zipcode.csv
**  Author:       Generated
**  Created:      2026-01-14
**==============================================================================

     Ctl-Opt DftActGrp(*No) ActGrp(*New);
     Ctl-Opt Option(*SrcStmt:*NoDebugIO);

     // SQL Communication Area
     Exec SQL Include SQLCA;

     // Working Variables
     Dcl-S recordCount    Int(10) Inz(0);
     Dcl-S errorCount     Int(10) Inz(0);
     Dcl-S skipHeader     Ind Inz(*On);
     Dcl-S latitudeNum    Packed(8:2);
     Dcl-S longitudeNum   Packed(8:2);
     
     // Field variables for parsed CSV
     Dcl-S inputLine        Varchar(1000);
     Dcl-S zip              Char(10);
     Dcl-S type             Char(20);
     Dcl-S primaryCity      Char(100);
     Dcl-S acceptableCities Char(200);
     Dcl-S state            Char(10);
     Dcl-S latitude         Char(20);
     Dcl-S longitude        Char(20);
     Dcl-S country          Char(10);

     // -----------------------------------------------------------------------
     // Main Processing
     // -----------------------------------------------------------------------
     *InLR = *On;

     // Set SQL options
     Exec SQL Set Option Commit = *None, DatFmt = *ISO, Closqlcsr = *EndMod;

     // Clear the table (optional - remove if you want to append)
     Exec SQL Delete From ECZIPCODE;
     If SQLCODE < 0;
       Dsply ('Error clearing table: ' + %Char(SQLCODE));
       Return;
     EndIf;
     Dsply ('Table cleared successfully');

     // Declare cursor to read IFS file
     Exec SQL
       Declare C1 Cursor For
       Select Line
       From Table(QSYS2.IFS_READ(PATH_NAME => '/home/jflanary/zipcode.csv'));

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

         // Validate ZIP code (must have data)
         If %Trim(zip) = '';
           Iter;
         EndIf;

         // Convert latitude/longitude to numeric
         Monitor;
           latitudeNum = %Dec(%Trim(latitude) : 8 : 2);
           longitudeNum = %Dec(%Trim(longitude) : 8 : 2);
         On-Error;
           latitudeNum = 0;
           longitudeNum = 0;
         EndMon;

         // Insert record into database
         Exec SQL
           Insert Into ECZIPCODE (
             ZIP, TYPE, PRIMARY_CITY, ACCEPTABLE_CITIES,
             STATE, LATITUDE, LONGITUDE, COUNTRY
           ) Values (
             :zip,
             :type,
             :primaryCity,
             :acceptableCities,
             :state,
             :latitudeNum,
             :longitudeNum,
             :country
           );

         If SQLCODE = 0;
           recordCount += 1;
           If %Rem(recordCount : 1000) = 0;
             Dsply (%Char(recordCount) + ' records processed...');
           EndIf;
         Else;
           errorCount += 1;
           If errorCount <= 10;  // Only display first 10 errors
             Dsply ('Error inserting ZIP ' + %Trim(zip) + 
                    ': ' + %Char(SQLCODE));
           EndIf;
         EndIf;
       EndIf;
     EndDo;

     // Close cursor
     Exec SQL Close C1;

     // Display summary
     Dsply ('=====================================');
     Dsply ('ZIP Code Load Complete');
     Dsply ('Records Inserted: ' + %Char(recordCount));
     Dsply ('Errors: ' + %Char(errorCount));
     Dsply ('=====================================');

     Return;

     // -----------------------------------------------------------------------
     // Procedure: parseCSVLine - Parse comma-delimited CSV line
     // -----------------------------------------------------------------------
     Dcl-Proc parseCSVLine;
       Dcl-PI *N;
         line Varchar(1000) Const;
       End-PI;

       Dcl-S pos       Int(10);
       Dcl-S fieldNum  Int(10) Inz(1);
       Dcl-S startPos  Int(10) Inz(1);
       Dcl-S fieldVal  Varchar(500);
       Dcl-S lineLen   Int(10);

       // Clear all fields
       zip = '';
       type = '';
       primaryCity = '';
       acceptableCities = '';
       state = '';
       latitude = '';
       longitude = '';
       country = '';

       lineLen = %Len(%Trim(line));
       
       // Parse each field separated by comma
       For pos = 1 To lineLen;
         If %Subst(line : pos : 1) = ',' Or pos = lineLen;
           // Extract field value
           If pos = lineLen And %Subst(line : pos : 1) <> ',';
             fieldVal = %Subst(line : startPos : pos - startPos + 1);
           Else;
             fieldVal = %Subst(line : startPos : pos - startPos);
           EndIf;

           // Assign to appropriate field
           Select;
             When fieldNum = 1;
               zip = %Trim(fieldVal);
             When fieldNum = 2;
               type = %Trim(fieldVal);
             When fieldNum = 3;
               primaryCity = %Trim(fieldVal);
             When fieldNum = 4;
               acceptableCities = %Trim(fieldVal);
             When fieldNum = 5;
               state = %Trim(fieldVal);
             When fieldNum = 6;
               latitude = %Trim(fieldVal);
             When fieldNum = 7;
               longitude = %Trim(fieldVal);
             When fieldNum = 8;
               country = %Trim(fieldVal);
           EndSl;

           fieldNum += 1;
           startPos = pos + 1;
         EndIf;
       EndFor;

     End-Proc;
