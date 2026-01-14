

            //****************************************************************************
            //* Program:      ZIPEXPAND - Expand ZIP Codes by Acceptable Cities
            //* Description:  Reads ECZIPCODE and creates duplicate records for each
            //*               acceptable city, replacing PRIMARY_CITY with each city
            //* Author:       Generated
            //* Created:      2026-01-14
            //****************************************************************************

            Ctl-Opt DftActGrp(*No) ActGrp(*New);
            Ctl-Opt Option(*SrcStmt:*NoDebugIO);

            // SQL Communication Area
            Exec SQL Include SQLCA;

            // Working Variables
            dcl-s i              int(10) inz(0);
            dcl-s maxItemLines   packed(5:0) inz(10000);
            dcl-s rowCount       int(10) inz(0);
            dcl-s recordCount    int(10) inz(0);
            dcl-s insertCount    int(10) inz(0);
            dcl-s errorCount     int(10) inz(0);

            // Data structure array for bulk fetch
            dcl-ds zipDS qualified dim(10000);
              zip              char(5);
              type             char(10);
              primaryCity      char(50);
              acceptableCities char(500);
              state            char(2);
              latitude         packed(8:2);
              longitude        packed(8:2);
              country          char(2);
            end-ds;

            // -----------------------------------------------------------------------
            // Main Processing
            // -----------------------------------------------------------------------
            *InLR = *On;

            // Set SQL options
            exec SQL set option commit = *None,
               datfmt = *ISO, closqlcsr = *EndMod;

            dsply ('Starting ZIP Code Expansion...');

            // Declare cursor to read ECZIPCODE records with acceptable cities
            exec SQL
              declare C1 scroll cursor for
              select ZIP, TYPE, PRIMARY_CITY, ACCEPTABLE_CITIES,
                     STATE, LATITUDE, LONGITUDE, COUNTRY
              from ECZIPCODE
              where TRIM(ACCEPTABLE_CITIES) <> ''
              for read only;

            // Open cursor
            exec SQL open C1;
            if SQLCODE < 0;
              dsply ('Error opening cursor: ' + %char(SQLCODE));
              return;
            endif;

            // Fetch first batch
            exec SQL fetch first from C1
              for :maxItemLines rows into :zipDS;
            exec SQL get diagnostics :rowCount = ROW_COUNT;

            dsply ('Total records fetched: ' + %char(rowCount));

            // Process batches
            dow rowCount <> 0;
              for i = 1 to rowCount;
                recordCount += 1;

                // Process acceptable cities for this ZIP
                processAcceptableCities(
                  zipDS(i).zip :
                  zipDS(i).type :
                  zipDS(i).acceptableCities :
                  zipDS(i).state :
                  zipDS(i).latitude :
                  zipDS(i).longitude :
                  zipDS(i).country
                );

                if %rem(recordCount : 100) = 0;
                  dsply (%char(recordCount) + ' records processed...');
                endif;
              endfor;

              // Fetch next batch
              exec SQL fetch next from C1
                for :maxItemLines rows into :zipDS;
              exec SQL get diagnostics :rowCount = ROW_COUNT;
            enddo;

            // Close cursor
            exec SQL close C1;

            // Display summary
            dsply ('=====================================');
            dsply ('ZIP Code Expansion Complete');
            dsply ('Records Processed: ' + %char(recordCount));
            dsply ('New Records Created: ' + %char(insertCount));
            dsply ('Errors: ' + %char(errorCount));
            dsply ('=====================================');

            return;

            // -----------------------------------------------------------------------
            // Procedure: processAcceptableCities
            // -----------------------------------------------------------------------
            dcl-proc processAcceptableCities;
              dcl-pi *n;
                pZip       char(5)      const;
                pType      char(10)     const;
                pCities    char(500)    const;
                pState     char(2)      const;
                pLatitude  packed(8:2)  const;
                pLongitude packed(8:2)  const;
                pCountry   char(2)      const;
              end-pi;

              dcl-s cityList    varchar(500);
              dcl-s cityName    varchar(50);
              dcl-s commaPos    int(10);

              cityList = %trim(pCities);

              // Loop through comma-separated cities
              dow %scan(',': cityList) > 0;
                commaPos = %scan(',': cityList);
                cityName = %upper(%trim(%subst(cityList : 1 : commaPos - 1)));

                // Insert record with this city as primary
                if cityName <> '';
                  insertCityRecord(pZip : pType : cityName :
                                  pState : pLatitude : pLongitude : pCountry);
                endif;

                // Remove processed city from list
                cityList = %trim(%subst(cityList : commaPos + 1));
              enddo;

              // Handle last city (or only city if no commas left)
              if cityList <> '';
                cityName = %upper(%trim(cityList));
                if cityName <> '';
                  insertCityRecord(pZip : pType : cityName :
                                  pState : pLatitude : pLongitude : pCountry);
                endif;
              endif;

            end-proc;

            // -----------------------------------------------------------------------
            // Procedure: insertCityRecord
            // -----------------------------------------------------------------------
            dcl-proc insertCityRecord;
              dcl-pi *n;
                pZip       char(5)      const;
                pType      char(10)     const;
                pCity      varchar(50)  const;
                pState     char(2)      const;
                pLatitude  packed(8:2)  const;
                pLongitude packed(8:2)  const;
                pCountry   char(2)      const;
              end-pi;

              exec SQL
                insert into ECZIPCODE (
                  ZIP, TYPE, PRIMARY_CITY, ACCEPTABLE_CITIES,
                  STATE, LATITUDE, LONGITUDE, COUNTRY
                ) values (
                  :pZip,
                  :pType,
                  :pCity,
                  '',
                  :pState,
                  :pLatitude,
                  :pLongitude,
                  :pCountry
                );

              if SQLCODE = 0;
                insertCount += 1;
              elseif SQLCODE = -803;  // Duplicate key - already exists
                // Ignore duplicate key errors
              else;
                errorCount += 1;
                if errorCount <= 10;
                  dsply ('Error inserting ZIP: ' + %trim(pZip));
                endif;
              endif;

            end-proc;
