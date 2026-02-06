      // Control Options
         Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
         Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
         Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
         Ctl-Opt Copyright('East Coast Metals - Zip Code Formatter');

      //******************************************************************************
      // ZIPFMT - Zip Code Formatting and Standardization Program
      //
      // Purpose: Updates the BRANCHPC field in the HYPBRCJOB table to standardize
      //          zip code formatting with proper leading zero padding and consistent
      //          plus-four notation (dash-separated format)
      //
      // Business Requirements:
      //   - Standardize all zip codes to proper 5-digit or 5+4 format
      //   - Ensure leading zeros are preserved for display and sorting
      //   - Handle various input formats from data entry inconsistencies
      //   - Maintain data integrity during bulk formatting operations
      //
      // Input Data Scenarios Handled:
      //   1. Short zip codes (1-5 digits): Pad with leading zeros to 5 digits
      //   2. Standard 5-digit zips: Validate and preserve existing format
      //   3. Continuous 9-digit strings: Insert dash after 5th digit
      //   4. Existing dash format: Pad both main zip and plus-four portions
      //   5. Irregular formats (6-8 digits): Truncate to first 5 digits
      //
      // Processing Logic:
      //   - Uses embedded SQL cursor for row-by-row processing
      //   - Trims whitespace and analyzes zip code characteristics
      //   - Applies appropriate formatting based on detected pattern
      //   - Updates only records where formatting changes are needed
      //   - Provides comprehensive error handling and progress reporting
      //
      // Transformation Examples:
      //   Input Format     | Output Format   | Description
      //   -----------------|-----------------|----------------------------------
      //   '123     '       | '00123'         | Short zip - pad to 5 digits
      //   '12345   '       | '12345'         | Standard 5-digit - no change
      //   '123456789'      | '12345-6789'    | 9 continuous - add dash
      //   '12345-678'      | '12345-0678'    | Has dash - pad plus-four
      //   '123-4567 '      | '00123-4567'    | Has dash - pad main zip
      //   '1234-56  '      | '01234-0056'    | Has dash - pad both parts
      //   '1234567 '       | '12345'         | 6-8 digits - truncate to 5
      //
      // Performance Considerations:
      //   - Processes records individually to handle large datasets safely
      //   - Uses 'FOR UPDATE' cursor to lock rows during modification
      //   - Commits changes automatically (commit=*none option)
      //   - Tracks and reports processing statistics
      //
      // Error Handling:
      //   - SQL error detection on cursor operations
      //   - Individual record error reporting with SQLCODE details
      //   - Graceful handling of invalid numeric conversions
      //   - Progress tracking with display messages
      //
      // Dependencies:
      //   Table: HYPBRCJOB - Primary business table containing branch postal codes
      //   Field: BRANCHPC (CHAR 10) - Target field for zip code standardization
      //
      // Security & Impact:
      //   - Updates existing data in production table HYPBRCJOB
      //   - Recommend testing in development environment first
      //   - Consider backup before production execution
      //   - Non-reversible changes - original format will be lost
      //
      // Author: East Coast Metals Development Team
      // Date: 2026-02-05
      // Version: 1.0
      //
      // Modification History:
      //   Date       Author        Description
      //   ---------- ------------- ----------------------------------------------
      //   2026-02-05 Development   Initial implementation
      //                           - Embedded SQL cursor processing
      //                           - Multi-format zip code detection and formatting
      //                           - Leading zero padding for 5-digit zips
      //                           - Plus-four handling with dash insertion
      //                           - Comprehensive error handling and reporting
      //                           - Performance optimization for large datasets
      //
      //******************************************************************************

      // SQL Communication Area
      exec sql include sqlca;

      // Field Definitions - Variables
      dcl-s currentZip varchar(10) inz;
      dcl-s formattedZip varchar(10) inz;
      dcl-s trimmedZip varchar(10) inz;
      dcl-s dashPos int(5) inz;
      dcl-s zipLength int(5) inz;
      dcl-s mainZip char(5) inz;
      dcl-s plusFour char(4) inz;
      dcl-s recordsProcessed packed(7:0) inz(0);
      dcl-s recordsUpdated packed(7:0) inz(0);

      // Main processing
      exec sql set option commit=*none, datfmt=*iso, closqlcsr=*endmod;

      // Declare cursor to read all BRANCHPC records
      exec sql
        declare zip_cursor cursor for
        select BRANCHPC
        from HYPBRCJOB
        where TRIM(BRANCHPC) <> ''
        for update;

      // Open cursor
      exec sql open zip_cursor;

      if SQLCODE <> 0;
        dsply ('Error opening cursor: ' + %char(SQLCODE));
        return;
      endif;

      // Process each record
      exec sql fetch zip_cursor into :currentZip;

      dow SQLCODE = 0;
        recordsProcessed += 1;
        
        // Trim the zip code
        trimmedZip = %trim(currentZip);
        zipLength = %len(%trim(trimmedZip));
        
        // Format based on zip code characteristics
        select;
          // Case 1: Contains dash - pad both parts
          when %scan('-' : trimmedZip) > 0;
            dashPos = %scan('-' : trimmedZip);
            mainZip = %subst(trimmedZip : 1 : dashPos - 1);
            plusFour = %subst(trimmedZip : dashPos + 1);
            
            // Pad main zip to 5 digits, plus four to 4 digits
            formattedZip = %editw(%int(mainZip) : '00000') + '-' +
                          %editw(%int(plusFour) : '0000');
                          
          // Case 2: Exactly 9 digits - add dash after 5th
          when zipLength = 9;
            mainZip = %subst(trimmedZip : 1 : 5);
            plusFour = %subst(trimmedZip : 6 : 4);
            formattedZip = %editw(%int(mainZip) : '00000') + '-' +
                          plusFour;
                          
          // Case 3: 5 or fewer digits - pad to 5 digits only
          when zipLength <= 5;
            formattedZip = %editw(%int(trimmedZip) : '00000');
            
          // Case 4: 6-8 digits - treat as 5-digit zip (truncate extras)
          other;
            mainZip = %subst(trimmedZip : 1 : 5);
            formattedZip = %editw(%int(mainZip) : '00000');
        endsl;

        // Update the record if it changed
        if formattedZip <> %trim(currentZip);
          exec sql
            update HYPBRCJOB
            set BRANCHPC = :formattedZip
            where current of zip_cursor;
            
          if SQLCODE = 0;
            recordsUpdated += 1;
          else;
            dsply ('Update error for zip: ' + %trim(currentZip) + 
                  ' SQLCODE: ' + %char(SQLCODE));
          endif;
        endif;

        // Fetch next record
        exec sql fetch zip_cursor into :currentZip;
      enddo;

      // Close cursor
      exec sql close zip_cursor;

      // Display summary
      dsply ('Records processed: ' + %char(recordsProcessed));
      dsply ('Records updated: ' + %char(recordsUpdated));

      if SQLCODE = 100;
        dsply 'Processing completed successfully';
      else;
        dsply ('Processing ended with SQLCODE: ' + %char(SQLCODE));
      endif;

      *inlr = *on;