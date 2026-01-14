            //==============================================================================
            //  Program:      ZIPEXPAND - Expand ZIP Codes by Acceptable Cities
            //  Description:  Reads ECZIPCODE and creates duplicate records for each
            //                acceptable city, replacing PRIMARY_CITY with each city
            //  Author:       Generated
            //  Created:      2026-01-14
            //==============================================================================

            Ctl-Opt DftActGrp(*No) ActGrp(*New);
            Ctl-Opt Option(*SrcStmt:*NoDebugIO);

            // SQL Communication Area
            Exec SQL Include SQLCA;

            // Working Variables
            Dcl-S recordCount    Int(10) Inz(0);
            Dcl-S insertCount    Int(10) Inz(0);
            Dcl-S errorCount     Int(10) Inz(0);
            Dcl-S totalRecords   Int(10) Inz(0);
            
            // Field variables from ECZIPCODE
            Dcl-S zip              Char(5);
            Dcl-S type             Char(10);
            Dcl-S primaryCity      Char(50);
            Dcl-S acceptableCities Char(500);
            Dcl-S state            Char(2);
            Dcl-S latitude         Packed(8:2);
            Dcl-S longitude        Packed(8:2);
            Dcl-S country          Char(2);

            // -----------------------------------------------------------------------
            // Main Processing
            // -----------------------------------------------------------------------
            *InLR = *On;

            // Set SQL options
            Exec SQL Set Option Commit = *None,
               DatFmt = *ISO, Closqlcsr = *EndMod;

            Dsply ('Starting ZIP Code Expansion...');

            // Declare cursor to read ECZIPCODE records with acceptable cities
            Exec SQL
              Declare C1 Scroll Cursor For
              Select ZIP, TYPE, PRIMARY_CITY, ACCEPTABLE_CITIES,
                     STATE, LATITUDE, LONGITUDE, COUNTRY
              From ECZIPCODE
              Where TRIM(ACCEPTABLE_CITIES) <> ''
              For Read Only;

            // Open cursor
            Exec SQL Open C1;
            If SQLCODE < 0;
              Dsply ('Error opening cursor: ' + %Char(SQLCODE));
              Return;
            EndIf;

            // Get count of records in cursor
            Exec SQL Get Diagnostics :totalRecords = ROW_COUNT;
            Dsply ('Total records to process: ' + %Char(totalRecords));

            // Read and process each record
            DoW SQLCODE = 0;
            Exec SQL Fetch Next From C1 
                Into :zip, :type, :primaryCity, :acceptableCities,
                    :state, :latitude, :longitude, :country;
            
            If SQLCODE = 0;
                recordCount += 1;
                
                // Process acceptable cities for this ZIP
                processAcceptableCities(zip : type : acceptableCities :
                                        state : latitude : longitude : country);
                
                If %Rem(recordCount : 100) = 0;
                Dsply (%Char(recordCount) + ' records processed...');
                EndIf;
            EndIf;
            EndDo;

            // Close cursor
            Exec SQL Close C1;

            // Display summary
            Dsply ('=====================================');
            Dsply ('ZIP Code Expansion Complete');
            Dsply ('Records Processed: ' + %Char(recordCount));
            Dsply ('New Records Created: ' + %Char(insertCount));
            Dsply ('Errors: ' + %Char(errorCount));
            Dsply ('=====================================');

            Return;

            // -----------------------------------------------------------------------
            // Procedure: processAcceptableCities
            // -----------------------------------------------------------------------
            Dcl-Proc processAcceptableCities;
            Dcl-PI *N;
                pZip       Char(5)      Const;
                pType      Char(10)     Const;
                pCities    Char(500)    Const;
                pState     Char(2)      Const;
                pLatitude  Packed(8:2)  Const;
                pLongitude Packed(8:2)  Const;
                pCountry   Char(2)      Const;
            End-PI;

            Dcl-S cityList    Varchar(500);
            Dcl-S cityName    Varchar(50);
            Dcl-S commaPos    Int(10);

            cityList = %Trim(pCities);

            // Loop through comma-separated cities
            DoW %Scan(',': cityList) > 0;
                commaPos = %Scan(',': cityList);
                cityName = %Upper(%Trim(%Subst(cityList : 1 : commaPos - 1)));

                // Insert record with this city as primary
                If cityName <> '';
                insertCityRecord(pZip : pType : cityName :
                                pState : pLatitude : pLongitude : pCountry);
                EndIf;

                // Remove processed city from list
                cityList = %Trim(%Subst(cityList : commaPos + 1));
            EndDo;

            // Handle last city (or only city if no commas left)
            If cityList <> '';
                cityName = %Upper(%Trim(cityList));
                If cityName <> '';
                insertCityRecord(pZip : pType : cityName :
                                pState : pLatitude : pLongitude : pCountry);
                EndIf;
            EndIf;

            End-Proc;

            // -----------------------------------------------------------------------
            // Procedure: insertCityRecord
            // -----------------------------------------------------------------------
            Dcl-Proc insertCityRecord;
            Dcl-PI *N;
                pZip       Char(5)      Const;
                pType      Char(10)     Const;
                pCity      Varchar(50)  Const;
                pState     Char(2)      Const;
                pLatitude  Packed(8:2)  Const;
                pLongitude Packed(8:2)  Const;
                pCountry   Char(2)      Const;
            End-PI;

            Exec SQL
                Insert Into ECZIPCODE (
                ZIP, TYPE, PRIMARY_CITY, ACCEPTABLE_CITIES,
                STATE, LATITUDE, LONGITUDE, COUNTRY
                ) Values (
                :pZip,
                :pType,
                :pCity,
                '',
                :pState,
                :pLatitude,
                :pLongitude,
                :pCountry
                );

            If SQLCODE = 0;
                insertCount += 1;
            ElseIf SQLCODE = -803;  // Duplicate key - already exists
                // Ignore duplicate key errors
            Else;
                errorCount += 1;
                If errorCount <= 10;
                Dsply ('Error inserting ZIP: ' + %Trim(pZip));
                EndIf;
            EndIf;

            End-Proc;
