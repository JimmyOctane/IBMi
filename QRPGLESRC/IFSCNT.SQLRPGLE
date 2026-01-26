Z            //****************************************************************************
            //* Program:      IFSCNT - IFS Table Record Count Service Module
            //* Description:  NOMAIN service program for counting records in IFS tables
            //*               using SQL to query external tables located in the IFS.
            //*               Supports generic table names using wildcards (*).
            //*
            //* Parameters:   directory - IFS directory path containing the table(s)
            //*               tableName - Name of the table file (supports * wildcard)
            //*
            //* Returns:      Number of records in matching table(s) (positive integer)
            //*               -1: General error (SQL error or file access issue)
            //*               -2: No matching tables found
            //*               -3: Invalid parameters
            //*               -4: Multiple files found (returns count from first match)
            //*
            //* Features:     - Dynamic SQL execution for external tables
            //*               - IFS path handling with wildcard support
            //*               - Error handling with specific return codes
            //*
            //* Copyright:    East Coast Metals
            //* Author:       JJF
            //* Created:      012325
            //****************************************************************************

            // Control Options
            Ctl-Opt NoMain;                         // Service program (no main)
            Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
            Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
            Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
            Ctl-Opt Copyright('East Coast Metals - IFS Table Record Count');

            // SQL Communication Area
            exec sql include sqlca;

            /copy qrpglesrc,IFSCNT_CP

            // Get IFS Table Record Count procedure
            dcl-proc getIFSTableCount export;
              dcl-pi *n int(10);
                directory varchar(256);
                tableName varchar(128);
              end-pi;

              // Field Definitions - Variables
              dcl-s actualFileName varchar(512) inz;
              dcl-s directory2 varchar(256) inz;
              dcl-s fileCount int(10) inz;
              dcl-s fileName varchar(128) inz;
              dcl-s fullPath varchar(512) inz;
              dcl-s recordCount int(10) inz;
              dcl-s searchPattern varchar(128) inz;
              dcl-s sqlStatement varchar(2000) inz;

              exec sql set option commit=*none, datfmt=*iso, closqlcsr=*endmod;

              // Validate input parameters
              if %trim(directory) = '' or %trim(tableName) = '';
                return -3;  // Error: Invalid parameters
              endif;

              directory2 = %trim(directory);
              fileName = %trim(tableName);

              // Check if wildcards are used
              if %scan('*' : fileName) > 0;
                // Handle wildcard search
                searchPattern = %xlate('*' : '%' : fileName);  // Convert * to SQL %
                
                // Find first matching file
                sqlStatement = 'SELECT OBJECT_NAME FROM TABLE(QSYS2.IFS_OBJECT_STATISTICS(' +
                              '''' + %trim(directory2) + ''', ''*ALLDIR'')) ' +
                              'WHERE OBJECT_TYPE = ''*STMF'' AND ' +
                              'UPPER(OBJECT_NAME) LIKE UPPER(''' + %trim(searchPattern) + ''') ' +
                              'ORDER BY OBJECT_NAME FETCH FIRST 1 ROW ONLY';

                monitor;
                  exec sql prepare fileStmt from :sqlStatement;
                  exec sql execute fileStmt into :actualFileName;
                  exec sql drop statement fileStmt;

                  if actualFileName = '';
                    return -2;  // No matching files found
                  endif;

                  // Build full path with actual filename
                  fullPath = %trim(directory2);
                  if %subst(fullPath : %len(%trim(fullPath)) : 1) <> '/';
                    fullPath += '/';
                  endif;
                  fullPath += %trim(actualFileName);

                on-error;
                  monitor;
                    exec sql drop statement fileStmt;
                  on-error;
                    // Ignore errors dropping statement
                  endmon;
                  return -2;  // No matching files found
                endmon;
              else;
                // No wildcards - direct file access
                fullPath = %trim(directory2);
                if %subst(fullPath : %len(%trim(fullPath)) : 1) <> '/';
                  fullPath += '/';
                endif;
                fullPath += %trim(fileName);
              endif;

              // Build dynamic SQL statement to count records
              sqlStatement = 'SELECT COUNT(*) FROM TABLE(QSYS2.IFS_READ(''' +
                            %trim(fullPath) + ''', ''*FIRST'')) AS T';

              monitor;
                // Execute the count query
                exec sql prepare countStmt from :sqlStatement;
                exec sql execute countStmt into :recordCount;
                exec sql drop statement countStmt;

                // Return the record count
                return recordCount;

              on-error;
                // Handle SQL errors
                monitor;
                  exec sql drop statement countStmt;
                on-error;
                  // Ignore errors dropping statement
                endmon;

                // Check if it's a file not found error
                if sqlcode = -204 or sqlcode = -551;
                  return -2;  // Table not found or inaccessible
                else;
                  return -1;  // General error
                endif;
              endmon;

            end-proc;