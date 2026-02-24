      // Control Options
      Ctl-Opt NoMain;                      // Service program
      Ctl-Opt Option(*SrcStmt:*NoDebugIO); // Source statements
      Ctl-Opt DatFmt(*ISO);                // ISO date format

      //*******************************************************************
      // GENTMPID - Generate Temporary Product ID Service Program
      //
      // Purpose: Generates a 15-character temporary product identifier
      //          Format: CCC###-CCC-MMDDYY
      //          Example: PTS001-021-022326
      //
      // Parameters:
      //   input - gentmpidInput_t structure containing:
      //     Category       - 3-char category code (PDF, REG, PTS, etc.)
      //     SequenceNumber - Sequence number (default: 1)
      //   Note: Company/Branch is retrieved from TBPMTBL using current user
      //
      // Returns: gentmpidReturn_t structure containing:
      //   ProductID    - Generated 15-character product ID
      //   Success      - Success indicator
      //   ErrorMessage - Error message if failed
      //
      // Format Breakdown:
      //   Positions 1-3:   Category code (e.g., 'PTS')
      //   Positions 4-6:   Sequence number with leading zeros (e.g., '001')
      //   Position 7:      Dash separator ('-')
      //   Positions 8-10:  Company code (e.g., '021')
      //   Position 11:     Dash separator ('-')
      //   Positions 12-17: Date in MMDDYY format (e.g., '022326')
      //
      // Author: System Generated
      // Date: 2026-02-23
      // Version: 1.0
      //
      //*******************************************************************

      // Copy members for data structures and prototypes
      /copy qcpysrc,GENTMPID_CP

      //*********************************************************
      // GENTMPID - External Procedure
      //*********************************************************
       dcl-proc GENTMPID export;

       dcl-pi GENTMPID likeds(gentmpidReturn_t);
         input likeds(gentmpidInput_t) const;
       end-pi;

       // Named constants
       dcl-c DEFAULT_BRANCH '021';

       // Local variables
       dcl-s productID char(15);
       dcl-s sequenceStr char(3);
       dcl-s dateStr char(6);
       dcl-s myMonth packed(2:0);
       dcl-s myDay packed(2:0);
       dcl-s myYear packed(2:0);
       dcl-s branchCode char(3);
       dcl-s categoryCode char(3);
       dcl-s currentUser char(10);
       dcl-s nextSequence packed(3:0);
       dcl-ds returnData likeds(gentmpidReturn_t);

       // System Data Structure (SDS) to get current user
       dcl-ds ProgramStatus psds qualified;
         ProgramName     char(10)    pos(1);
         UserName        char(10)    pos(254);
         JobName         char(10)    pos(244);
         JobNumber       char(6)     pos(264);
       end-ds;

       // Initialize return structure
       clear returnData;
       returnData.Success = *off;
       returnData.ProductID = '';
       returnData.ErrorMessage = '';

       // Get category code (convert to uppercase)
       categoryCode = %upper(input.Category);

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

       // Format date as MMDDYY
       dateStr = %char(myMonth:'02') +
                 %char(myDay:'02') +
                 %char(myYear:'02');

       // Get next sequence number for today
       // Sequence restarts at 001 each day
       // Format: CCC###-BBB-MMDDYY (look for records ending with today's date)
       if input.SequenceNumber <= 0;
         // Auto-generate sequence number
         nextSequence = 0;
         exec sql
           SELECT COALESCE(MAX(CAST(SUBSTR(IVNO04, 4, 3) AS INTEGER)), 0) + 1
             INTO :nextSequence
             FROM IVPMSTR
            WHERE SUBSTR(IVNO04, 12, 6) = :dateStr
              AND SUBSTR(IVNO04, 1, 3) = :categoryCode
              AND LENGTH(TRIM(IVNO04)) = 17;

         // If SQL failed or returned null, default to 1
         if SQLCODE <> 0 or nextSequence <= 0;
           sequenceStr = '001';
         else;
           sequenceStr = %char(nextSequence:'03');
         endif;
       else;
         // Use provided sequence number
         sequenceStr = %char(input.SequenceNumber:'03');
       endif;

       // Build product ID: CCC###-CCC-MMDDYY
       productID = categoryCode +
                   sequenceStr +
                   '-' +
                   branchCode +
                   '-' +
                   dateStr;

       // Set return values
       returnData.Success = *on;
       returnData.ProductID = productID;
       returnData.ErrorMessage = '';

       return returnData;

       end-proc GENTMPID;

