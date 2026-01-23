            //****************************************************************************
            //* Program:      SNDTRFS - Transfer CSV Generation Service Module
            //* Description:  NOMAIN service program for generating CSV files of
            //*               transfer data to IFS
            //* Copyright:    East Coast Metals
            //* Author:       JJF
            //* Created:      012325
            //****************************************************************************

            // Control Options
            Ctl-Opt NoMain;                         // Service program (no main)
            Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
            Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
            Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
            Ctl-Opt Copyright('East Coast Metals - Transfer CSV Generation');

            // SQL Communication Area
            exec sql include sqlca;

            /copy qrpglesrc,SNDTRFS_CP

            // Generate Transfer CSV procedure
            dcl-proc generateTransferCSV export;
              dcl-pi *n int(10);
                parmDate char(10) options(*nopass);
                csvPath varchar(100) options(*nopass);
                branchArray packed(3:0) dim(100) options(*nopass);
                tableName varchar(100) options(*nopass);
                includeHeaders char(1) options(*nopass);
              end-pi;

              // Field Definitions
              dcl-s csvString varchar(32000) inz;
              dcl-c CR const(x'0d');
              dcl-c CRLF const(x'0d25');
              dcl-s i int(10) inz;
              dcl-s maxItemLines packed(5: 0) inz(500);
              dcl-s rowcount int(10) inz;
              dcl-s totalRows int(10) inz;
              dcl-s CSVIFSPath varchar(100) inz('/tmp/transfer_data.csv');
              dcl-s csvLine varchar(500) inz;
              dcl-s currentTime time inz;
              dcl-s filterDate char(10) inz;
              dcl-s isValidDate ind inz;
              dcl-s branchInList varchar(1000) inz;
              dcl-s delimiter char(1) inz;
              dcl-s timestampedName varchar(150) inz;
              dcl-s dotPosition int(10) inz;
              dcl-c endOfDay const(t'00.00.00');
              dcl-c startOfDay const(t'07.00.00');
              dcl-c TAB const(x'09');

              // Cursor result set structure
              dcl-ds c1 qualified dim(500);
                TransferID char(10);
                InvoiceLineNumber char(1);
                ItemNumber char(15);
                Supplier char(1);
                ShipPoint char(1);
                SendingBranch char(3);
                TransferQty1 char(15);
                TransferQty2 char(15);
                ReceivedDate char(10);
                ShippedDate char(10);
                ItemUnitOfMeasure char(1);
                CatchWeight char(1);
                ItemUnitPrice char(1);
                ItemNetPrice char(1);
                ReceivingBranch char(3);
                CustomAttribute2 char(1);
                CustomAttribute3 char(1);
                CustomAttribute4 char(1);
                CustomAttribute5 char(1);
                CustomAttribute6 char(1);
                CustomAttribute7 char(1);
                CustomAttribute8 char(1);
                CustomAttribute9 char(1);
                CustomAttribute10 char(1);
                CustomAttribute11 char(1);
                CustomAttribute12 char(1);
                CustomAttribute13 char(1);
                CustomAttribute14 char(1);
                CustomAttribute15 char(1);
                DemandType char(1);
                CalcLostSales char(1);
              end-ds;

              exec sql set option commit=*none, datfmt=*iso, closqlcsr=*endmod;

              // Override default path if provided
              if %parms() >= 2 and %trim(csvPath) <> '';
                CSVIFSPath = csvPath;
              endif;
              
              // Determine delimiter based on file extension and add timestamp
              if %parms() >= 4 and %trim(tableName) <> '';
                // Find the dot position for extension
                dotPosition = %scanr('.' : %trim(tableName));
                
                if dotPosition > 0;
                  // Insert timestamp before extension
                  timestampedName = %subst(%trim(tableName) : 1 : dotPosition - 1) +
                                  %char(%timestamp()) +
                                  %subst(%trim(tableName) : dotPosition);
                else;
                  // No extension found, just append timestamp
                  timestampedName = %trim(tableName) + %char(%timestamp());
                endif;
                
                // Update CSVIFSPath with timestamped name
                CSVIFSPath = timestampedName;
                
                if %scan('.csv' : %trim(tableName)) > 0;
                  delimiter = ',';
                elseif %scan('.txt' : %trim(tableName)) > 0;
                  delimiter = TAB;
                else;
                  delimiter = ',';  // Default to comma
                endif;
              else;
                delimiter = ',';  // Default to comma
              endif;

              // Determine the filter date based on parameter and time logic
              if %parms() >= 1 and %trim(parmDate) <> '';
                // Validate the passed date
                monitor;
                    test(de) *iso parmDate;
                    isValidDate = *on;
                on-error;
                    isValidDate = *off;
                endmon;
                
                if isValidDate;
                    filterDate = parmDate;
                else;
                    filterDate = %char(%date());  // Use current date if invalid
                endif;
              else;
                // No date parameter passed - use time logic (adjust for dev data)
                currentTime = %time();
                if currentTime >= endOfDay and currentTime <= startOfDay;
                    // Between midnight and 7am - use previous day
                    // (1 month back for dev)
                    filterDate = %char(%date() - %days(31));
                else;
                    // After 7am - use current date (1 month back for dev)
                    filterDate = %char(%date() - %days(30));
                endif;
              endif;

              // Build branch list for IN clause
              if %parms() >= 3;
                branchInList = '';
                for i = 1 to %elem(branchArray);
                  if branchArray(i) > 0;
                    if branchInList <> '';
                      branchInList += ',';
                    endif;
                    branchInList += %char(branchArray(i));
                  endif;
                endfor;
                if branchInList = '';
                  return -2;  // Error: No valid branches provided
                endif;
              else;
                return -3;  // Error: Branch array required
              endif;

              exec sql
                declare C1 scroll cursor for
                select * from(
                Select
                rh.ivno26 as "Transfer ID",
                'Ô' as "Invoice Line Number",
                rd.ivno07 as "Item Number",
                'Ô' as "Supplier",
                'Ô' as "Ship Point",
                trh.IVNO52 as "Sending Branch",
                rd.ivqy26 as "Transfer Quantity",
                rd.ivqy26 as "Transfer Quantity",
                date(digits(rh.IVCC21)  ||  digits(rh.IVYR21) || '-' ||
                digits(rh.IVMO21) || '-' || digits(rh.IVDY21) )
                as "Transfer Received Date",
                date(digits(trh.IVCC27)  ||  digits(trh.IVYR27) || '-' ||
                digits(trh.IVMO27) || '-' || digits(trh.IVDY27) )
                as "Transfer Shipped Date",
                'Ô' as "Item Unit of measure",
                'Ô' as "Catch Weight",
                'Ô' as "Item unit price",
                'Ô' as "Item Net price",
                trh.IVNO53 as "Receiving Branch",
                'Ô' as "Custom Attribute 2",
                'Ô' as "Custom Attribute 3",
                'Ô' as "Custom Attribute 4",
                'Ô' as "Custom Attribute 5",
                'Ô' as "Custom Attribute 6",
                'Ô' as "Custom Attribute 7",
                'Ô' as "Custom Attribute 8",
                'Ô' as "Custom Attribute 9",
                'Ô' as "Custom Attribute 10",
                'Ô' as "Custom Attribute 11",
                'Ô' as "Custom Attribute 12",
                'Ô' as "Custom Attribute 13",
                'Ô' as "Custom Attribute 14",
                'Ô' as "Custom Attribute 15",
                'D' as "DemandType",
                'Y' as "CalculateLostSales"
                from ivptrl rd
                join ivptth trh
                on trh.ivno26 = rd.ivno26
                inner join ivptrh rh
                on rd.ivno26=rh.ivno26
                join IVPMSTR im
                on im.ivno07 = rd.ivno07
                where trh.IVNO52 in (select element from
                table(systools.split(:branchInList, ','))) and
                trh.IVCD70  = 'C' and
                date(digits(rh.IVCC21)  ||  digits(rh.IVYR21) || '-' ||
                     digits(rh.IVMO21) || '-' ||
                     digits(rh.IVDY21)) = date(:filterDate)
                ) subquery
                for read only;

              monitor;
                exec sql open C1;

                // Initialize CSV with optional header
                if %parms() >= 5 and %upper(%trim(includeHeaders)) = 'Y';
                  csvString =
                    'Transfer ID' +delimiter+ 'Invoice Line Number' +
                    delimiter+ 'Item Number' +delimiter+ 'Supplier' +
                    delimiter+ 'Ship Point' +delimiter+ 'Sending Branch' +
                    delimiter+ 'Transfer Quantity' +delimiter+
                    'Transfer Quantity' +delimiter+
                    'Transfer Received Date' +delimiter+
                    'Transfer Shipped Date' +delimiter+
                    'Item Unit of measure' +delimiter+ 'Catch Weight' +
                    delimiter+ 'Item unit price' +delimiter+
                    'Item Net price' +delimiter+ 'Receiving Branch' +
                    delimiter+ 'Custom Attribute 2' +delimiter+
                    'Custom Attribute 3' +delimiter+ 'Custom Attribute 4' +
                    delimiter+ 'Custom Attribute 5' +delimiter+
                    'Custom Attribute 6' +delimiter+ 'Custom Attribute 7' +
                    delimiter+ 'Custom Attribute 8' +delimiter+
                    'Custom Attribute 9' +delimiter+ 'Custom Attribute 10' +
                    delimiter+ 'Custom Attribute 11' +delimiter+
                    'Custom Attribute 12' +delimiter+ 'Custom Attribute 13' +
                    delimiter+ 'Custom Attribute 14' +delimiter+
                    'Custom Attribute 15' +delimiter+ 'DemandType' +
                    delimiter+ 'CalculateLostSales' + CRLF;
                else;
                  csvString = '';  // No header if not requested
                endif;

                exec sql fetch first from C1 for :maxItemLines rows into :C1;
                exec sql get diagnostics :rowCount = ROW_COUNT;

                dow rowCount <> 0;
                for i = 1 to rowCount;
                    // Build CSV line with proper formatting
                    csvLine = %char(%int(%trim(c1(i).TransferID))) +delimiter+
                            %trim(c1(i).InvoiceLineNumber) +delimiter+
                            %trim(c1(i).ItemNumber) +delimiter+
                            %trim(c1(i).Supplier) +delimiter+
                            %trim(c1(i).ShipPoint) +delimiter+
                            %trim(c1(i).SendingBranch) +delimiter+
                            %trim(c1(i).TransferQty1) +delimiter+
                            %trim(c1(i).TransferQty2) +delimiter+
                            %trim(c1(i).ReceivedDate) +delimiter+
                            %trim(c1(i).ShippedDate) +delimiter+
                            %trim(c1(i).ItemUnitOfMeasure) +delimiter+
                            %trim(c1(i).CatchWeight) +delimiter+
                            %trim(c1(i).ItemUnitPrice) +delimiter+
                            %trim(c1(i).ItemNetPrice) +delimiter+
                            %trim(c1(i).ReceivingBranch) +delimiter+
                            %trim(c1(i).CustomAttribute2) +delimiter+
                            %trim(c1(i).CustomAttribute3) +delimiter+
                            %trim(c1(i).CustomAttribute4) +delimiter+
                            %trim(c1(i).CustomAttribute5) +delimiter+
                            %trim(c1(i).CustomAttribute6) +delimiter+
                            %trim(c1(i).CustomAttribute7) +delimiter+
                            %trim(c1(i).CustomAttribute8) +delimiter+
                            %trim(c1(i).CustomAttribute9) +delimiter+
                            %trim(c1(i).CustomAttribute10) +delimiter+
                            %trim(c1(i).CustomAttribute11) +delimiter+
                            %trim(c1(i).CustomAttribute12) +delimiter+
                            %trim(c1(i).CustomAttribute13) +delimiter+
                            %trim(c1(i).CustomAttribute14) +delimiter+
                            %trim(c1(i).CustomAttribute15) +delimiter+
                            %trim(c1(i).DemandType) +delimiter+
                            %trim(c1(i).CalcLostSales) + CRLF;
                    
                    csvString += csvLine;
                    totalRows += 1;
                endfor;
                exec sql
                fetch next from C1 for :maxItemLines rows into :C1;
                exec sql get diagnostics :rowCount = ROW_COUNT;
                enddo;
                exec sql close C1;

                // Write CSV data to IFS file
                exec sql
                  CALL QSYS2.IFS_WRITE(:CSVIFSPath,
                                       :csvString,
                                       FILE_CCSID => 1208,
                                       OVERWRITE => 'REPLACE');

                // Return total number of records processed
                return totalRows;

              on-error;
                // Close cursor if still open
                monitor;
                  exec sql close C1;
                on-error;
                  // Ignore errors closing cursor
                endmon;
                return -1; // Return error indicator
              endmon;

            end-proc;