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

         // Handle empty fields between commas (e.g., ',,' becomes ', ,')
         inputLine = %ScanRpl(',,' : ', ,' : inputLine);

         // Parse CSV line
         parseCSVLine(inputLine);

         // Validate ZIP code (must have data)
         If %Trim(zip) = '';
           Iter;
         EndIf;

         // Uppercase all inputs
         zip = %Upper(%Trim(zip));
         type = %Upper(%Trim(type));
         primaryCity = %Upper(%Trim(primaryCity));
         acceptableCities = %Upper(%Trim(acceptableCities));
         state = %Upper(%Trim(state));
         country = %Upper(%Trim(country));

         // Convert latitude/longitude to numeric
         Monitor;
           latitudeNum = %Dec(%Trim(latitude) : 8 : 2);
           longitudeNum = %Dec(%Trim(longitude) : 8 : 2);
         On-Error;
           latitudeNum = 0;
           longitudeNum = 0;
         EndMon;

         // Insert primary record
         insertRecord(zip : type : primaryCity : acceptableCities :
                     state : latitudeNum : longitudeNum : country);
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
    // Procedure: insertRecord - Insert a ZIP code record
    // -----------------------------------------------------------------------
    Dcl-Proc insertRecord;
      Dcl-PI *N;
        pZip              Char(10)     Const;
        pType             Char(20)     Const;
        pPrimaryCity      Char(100)    Const;
        pAcceptableCities Char(200)    Const;
        pState            Char(10)     Const;
        pLatitude         Packed(8:2)  Const;
        pLongitude        Packed(8:2)  Const;
        pCountry          Char(10)     Const;
      End-PI;

      Exec SQL
        Insert Into ECZIPCODE (
          ZIP, TYPE, PRIMARY_CITY, ACCEPTABLE_CITIES,
          STATE, LATITUDE, LONGITUDE, COUNTRY
        ) Values (
          :pZip,
          :pType,
          :pPrimaryCity,
          :pAcceptableCities,
          :pState,
          :pLatitude,
          :pLongitude,
          :pCountry
        );

      If SQLCODE = 0;
        recordCount += 1;
        If %Rem(recordCount : 1000) = 0;
          Dsply (%Char(recordCount) + ' records processed...');
        EndIf;
      Else;
        errorCount += 1;
        If errorCount <= 10;  // Only display first 10 errors
          Dsply ('Error inserting ZIP: ' + %Trim(pZip));
          Dsply ('City: ' + %Trim(pPrimaryCity));
          Dsply ('SQLCODE: ' + %Char(SQLCODE));
        EndIf;
      EndIf;

    End-Proc;

    // -----------------------------------------------------------------------
    // Procedure: parseAcceptableCities - Parse acceptable cities and insert
    // -----------------------------------------------------------------------
    Dcl-Proc parseAcceptableCities;
      Dcl-PI *N;
        pZip       Char(10)     Const;
        pType      Char(20)     Const;
        pCities    Char(200)    Const;
        pState     Char(10)     Const;
        pLatitude  Packed(8:2)  Const;
        pLongitude Packed(8:2)  Const;
        pCountry   Char(10)     Const;
      End-PI;

      Dcl-S cityList    Varchar(200);
      Dcl-S cityName    Varchar(100);
      Dcl-S commaPos    Int(10);

      cityList = %Trim(pCities);

      // Loop through comma-separated cities
      DoW %Scan(',': cityList) > 0;
        commaPos = %Scan(',': cityList);
        cityName = %Trim(%Subst(cityList : 1 : commaPos - 1));

        // Insert record with this city as primary
        If cityName <> '';
          insertRecord(pZip : pType : cityName : pCities :
                      pState : pLatitude : pLongitude : pCountry);
        EndIf;

        // Remove processed city from list
        cityList = %Trim(%Subst(cityList : commaPos + 1));
      EndDo;

      // Handle last city (or only city if no commas left)
      If cityList <> '';
        cityName = %Trim(cityList);
        If cityName <> '';
          insertRecord(pZip : pType : cityName : pCities :
                      pState : pLatitude : pLongitude : pCountry);
        EndIf;
      EndIf;

    End-Proc;

    // -----------------------------------------------------------------------
    // Procedure: parseCSVLine - Parse CSV line handling quoted fields
    // -----------------------------------------------------------------------
     Dcl-Proc parseCSVLine;
       Dcl-PI *N;
         line Varchar(1000) Const;
       End-PI;

       Dcl-S position   Int(10);
       Dcl-S fieldStart Int(10);
       Dcl-S fieldEnd   Int(10);
       Dcl-S counter    Int(10) Inz(0);
       Dcl-S inQuotes   Ind Inz(*Off);
       Dcl-S lineLen    Int(10);
       Dcl-S fieldValue Varchar(500);
       Dcl-S char       Char(1);

       // Clear all fields
       zip = '';
       type = '';
       primaryCity = '';
       acceptableCities = '';
       state = '';
       latitude = '';
       longitude = '';
       country = '';

       lineLen = %Len(line);
       position = 1;
       fieldStart = 1;
       
       // Parse each character
       DoW position <= lineLen;
         char = %Subst(line : position : 1);
         
         // Toggle quote state
         If char = '"';
           inQuotes = Not inQuotes;
         EndIf;
         
         // Check for field delimiter (comma outside quotes) or end of line
         If (char = ',' And Not inQuotes);
           // Field ends before the comma
           fieldEnd = position - 1;
           
           // Extract field value
           If fieldEnd >= fieldStart;
             fieldValue = %Subst(line : fieldStart : fieldEnd - fieldStart + 1);
           Else;
             fieldValue = '';
           EndIf;
           
           // Remove surrounding quotes and trim
           If %Len(fieldValue) >= 2;
             If %Subst(fieldValue : 1 : 1) = '"' And
                %Subst(fieldValue : %Len(fieldValue) : 1) = '"';
               fieldValue = %Subst(fieldValue : 2 : %Len(fieldValue) - 2);
             EndIf;
           EndIf;
           fieldValue = %Trim(fieldValue);
           
           // Assign to appropriate field
           counter += 1;
           Select;
             When counter = 1;
               zip = fieldValue;
             When counter = 2;
               type = fieldValue;
             When counter = 3;
               primaryCity = fieldValue;
             When counter = 4;
               acceptableCities = fieldValue;
             When counter = 5;
               state = fieldValue;
             When counter = 6;
               latitude = fieldValue;
             When counter = 7;
               longitude = fieldValue;
             When counter = 8;
               country = fieldValue;
           EndSl;
           
           // Move to next field
           fieldStart = position + 1;
         EndIf;
         
         position += 1;
       EndDo;
       
       // Process final field (after last comma or entire line if no commas)
       If fieldStart <= lineLen;
         fieldValue = %Subst(line : fieldStart : lineLen - fieldStart + 1);
         
         // Remove surrounding quotes and trim
         If %Len(fieldValue) >= 2;
           If %Subst(fieldValue : 1 : 1) = '"' And
              %Subst(fieldValue : %Len(fieldValue) : 1) = '"';
             fieldValue = %Subst(fieldValue : 2 : %Len(fieldValue) - 2);
           EndIf;
         EndIf;
         fieldValue = %Trim(fieldValue);
         
         // Assign to appropriate field
         counter += 1;
         Select;
           When counter = 1;
             zip = fieldValue;
           When counter = 2;
             type = fieldValue;
           When counter = 3;
             primaryCity = fieldValue;
           When counter = 4;
             acceptableCities = fieldValue;
           When counter = 5;
             state = fieldValue;
           When counter = 6;
             latitude = fieldValue;
           When counter = 7;
             longitude = fieldValue;
           When counter = 8;
             country = fieldValue;
         EndSl;
       EndIf;

     End-Proc;
