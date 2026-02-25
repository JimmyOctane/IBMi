       // Control Options
         Ctl-Opt NoMain;                         // Service program (no main)
         Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
         Ctl-Opt BndDir('QC2LE');                // Bind to C runtime library
         Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
         Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
         Ctl-Opt Copyright('East Coast Metals - Return Item Information');


        //*******************************************************************

        //*******************************************************************
        // GENTMPP - Generate Temporary Product ID Service Program
        //
        // Purpose: Generates a 15-character temporary product identifier
        //          Format: CCC##-BBBMMDDYY
        //          Example: PTS01-021022326
        //
        // Parameters:
        //   input - GENTMPPInput_t structure containing:
        //     Category - 3-char category code (PDF, REG, PTS, etc.)
        //   Note: Branch is retrieved from TBPMTBL using current user
        //   Note: Sequence number is auto-generated (restarts daily)
        //         01-99 (numeric), then A0-A9, B0-B9...Z0-Z9 (alphanumeric)
        //
        // Returns: GENTMPPReturn_t structure containing:
        //   ProductID    - Generated 15-character product ID
        //   Success      - Success indicator
        //   ErrorMessage - Error message if failed
        //
        // Format Breakdown:
        //   Positions 1-3:   Category code (e.g., 'PTS')
        //   Positions 4-5:   Auto-generated sequence number (e.g., '01')
        //   Position 6:      Dash separator ('-')
        //   Positions 7-9:   Branch code (e.g., '021')
        //   Positions 10-15: Date in MMDDYY format (e.g., '022326')
        //
        // Author: System Generated
        // Date: 2026-02-23
        // Version: 1.0
        //
        //*******************************************************************

        // Copy members for data structures and prototypes
        /copy QCPYSRC,gentmpp_cp

        // System Data Structure (SDS) to get current user
        dcl-ds ProgramStatus psds qualified;
          ProgramName     char(10)    pos(1);
          UserName        char(10)    pos(254);
          JobName         char(10)    pos(244);
          JobNumber       char(6)     pos(264);
        end-ds;

       //*********************************************************
       // generateTemporaryProduct - External Procedure
       //*********************************************************
       dcl-proc generateTemporaryProduct export;

       dcl-pi *n likeds(GENTMPPReturn_t);
         pInput likeds(GENTMPPInput_t) const;
       end-pi;

       // Named constants
       dcl-c DEFAULT_BRANCH '021';
       dcl-c LETTERS 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

       // Local variables
       dcl-s productID char(15);
       dcl-s sequenceStart char(2);
       dcl-s dateStr char(6);
       dcl-s myMonth packed(2:0);
       dcl-s myDay packed(2:0);
       dcl-s myYear packed(2:0);
       dcl-s branchCode char(3);
       dcl-s categoryCode char(3);
       dcl-s currentUser char(10);
       dcl-s nextSequence packed(3:0);
       dcl-s tempStr char(10);
       dcl-s letterIndex packed(3:0);
       dcl-s numberPart packed(2:0);
       dcl-ds returnData likeds(GENTMPPReturn_t);

       // Initialize return structure
       clear returnData;
       returnData.Success = *off;
       returnData.ProductID = '';
       returnData.ErrorMessage = '';

       // Get category code (convert to uppercase)
       categoryCode = %upper(pInput.Category);

       // Get current user from SDS
       currentUser = ProgramStatus.UserName;

       // Retrieve branch from TBPMTBL table
       branchCode = DEFAULT_BRANCH;  // Default value
       exec sql
         SELECT substr(TBNO03,1,3)
           INTO :branchCode
           FROM TBPMTBL
           WHERE TBNO01 = 'TIDS'
             AND TBNO02 = :currentUser
           FETCH FIRST 1 ROW ONLY;

       // If SQL failed or no row found, use default
       if SQLCODE <> 0;
         branchCode = DEFAULT_BRANCH;
       endif;

       // Get current date components
       myMonth = %dec(%subdt(%date():*MONTHS));
       myDay = %dec(%subdt(%date():*DAYS));
       myYear = %dec(%subdt(%date():*YEARS)) - 2000;

       // Format date as MMDDYY with leading zeros using %char
       tempStr = %char(myMonth);
       if myMonth < 10;
         dateStr = '0' + %trim(tempStr);
       else;
         dateStr = %trim(tempStr);
       endif;

       tempStr = %char(myDay);
       if myDay < 10;
         dateStr = %trim(dateStr) + '0' + %trim(tempStr);
       else;
         dateStr = %trim(dateStr) + %trim(tempStr);
       endif;

       tempStr = %char(myYear);
       if myYear < 10;
         dateStr = %trim(dateStr) + '0' + %trim(tempStr);
       else;
         dateStr = %trim(dateStr) + %trim(tempStr);
       endif;

       // Get next sequence number for today
       // Sequence restarts at 01 each day per category and branch
       // Format: CCC##-BBBMMDDYY (look for records ending with today's date)
       // Need to find max sequence considering both numeric (01-99) and alphanumeric (A0-Z9)
       nextSequence = 0;
       exec sql
         SELECT COALESCE(MAX(
           CASE
             WHEN SUBSTR(IVNO04, 4, 1) BETWEEN '0' AND '9'
             THEN CAST(SUBSTR(IVNO04, 4, 2) AS INTEGER)
             ELSE ((ASCII(SUBSTR(IVNO04, 4, 1)) - 65) * 10) +
                  CAST(SUBSTR(IVNO04, 5, 1) AS INTEGER) + 100
           END
         ), 0) + 1
           INTO :nextSequence
           FROM IVPMSTR
          WHERE SUBSTR(IVNO04, 10, 6) = :dateStr
            AND SUBSTR(IVNO04, 1, 3) = :categoryCode
            AND SUBSTR(IVNO04, 7, 3) = :branchCode
            AND LENGTH(TRIM(IVNO04)) = 15;

       // If SQL failed or returned null, default to 1
       if SQLCODE <> 0 or nextSequence <= 0;
         sequenceStart = '01';
       else;
         // Format sequence: 01-99 numeric, then A0-A9, B0-B9...Z0-Z9
         if nextSequence <= 99;
           // Numeric sequence (01-99)
           tempStr = %char(nextSequence);
           if nextSequence < 10;
             sequenceStart = '0' + %trim(tempStr);
           else;
             sequenceStart = %trim(tempStr);
           endif;
         else;
           // Alphanumeric sequence (A0-Z9)
           // Calculate letter (A-Z) and number (0-9)
           letterIndex = %div(nextSequence - 100:10) + 1;
           numberPart = %rem(nextSequence - 100:10);
           tempStr = %char(numberPart);
           sequenceStart = %subst(LETTERS:letterIndex:1) + %trim(tempStr);
         endif;
       endif;

       // Build product ID: CCC##-BBBMMDDYY
       productID = categoryCode +
                   sequenceStart +
                   '-' +
                   branchCode +
                   dateStr;

       // Set return values
       returnData.Success = *on;
       returnData.ProductID = productID;
       returnData.ErrorMessage = '';

       return returnData;

       end-proc generateTemporaryProduct;


