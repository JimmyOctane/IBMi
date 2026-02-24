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
        // Purpose: Generates a 16-character temporary product identifier
        //          Format: CCC###-CCCMMDDYY
        //          Example: PTS001-021022326
        //
        // Parameters:
        //   input - GENTMPPInput_t structure containing:
        //     Category - 3-char category code (PDF, REG, PTS, etc.)
        //     Company  - 5-char company code
        //   Note: Sequence number is auto-generated (restarts daily)
        //
        // Returns: GENTMPPReturn_t structure containing:
        //   ProductID    - Generated 15-character product ID
        //   Success      - Success indicator
        //   ErrorMessage - Error message if failed
        //
        // Format Breakdown:
        //   Positions 1-3:   Category code (e.g., 'PTS')
        //   Positions 4-6:   Auto-generated sequence number (e.g., '001')
        //   Position 7:      Dash separator ('-')
        //   Positions 8-10:  Company code (e.g., '021')
        //   Positions 11-16: Date in MMDDYY format (e.g., '022326')
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
        // GENTMPP - External Procedure
        //*********************************************************
         dcl-proc GENTMPP export;
  
         dcl-pi *n likeds(GENTMPPReturn_t);
           pInput likeds(GENTMPPInput_t) const;
         end-pi;

        // Named constants
        dcl-c DEFAULT_BRANCH '021';

        // Local variables
        dcl-s productID char(16);
        dcl-s sequenceStr char(3);
        dcl-s dateStr char(6);
        dcl-s myMonth packed(2:0);
        dcl-s myDay packed(2:0);
        dcl-s myYear packed(2:0);
        dcl-s companyCode char(5);
        dcl-s categoryCode char(3);
        dcl-s nextSequence packed(3:0);
        dcl-ds returnData likeds(GENTMPPReturn_t);

        // Initialize return structure
        clear returnData;
        returnData.Success = *off;
        returnData.ProductID = '';
        returnData.ErrorMessage = '';

        // Get category code (convert to uppercase)
        categoryCode = %upper(pInput.Category);

        // Get company code from input parameter
        companyCode = pInput.Company;

        // Get current date components
        myMonth = %dec(%subdt(%date():*MONTHS));
        myDay = %dec(%subdt(%date():*DAYS));
        myYear = %dec(%subdt(%date():*YEARS)) - 2000;

        // Format date as MMDDYY
        dateStr = %editc(myMonth:'X') +
                  %editc(myDay:'X') +
                  %editc(myYear:'X');

        // Get next sequence number for today
        // Sequence restarts at 001 each day
        // Format: CCC###-CCCMMDDYY (look for records ending with today's date)
        nextSequence = 0;
        exec sql
          SELECT COALESCE(MAX(CAST(SUBSTR(IVNO04, 4, 3) AS INTEGER)), 0) + 1
            INTO :nextSequence
            FROM IVPMSTR
           WHERE SUBSTR(IVNO04, 11, 6) = :dateStr
             AND SUBSTR(IVNO04, 1, 3) = :categoryCode
             AND LENGTH(TRIM(IVNO04)) = 16;
 
        // If SQL failed or returned null, default to 1
        if SQLCODE <> 0 or nextSequence <= 0;
          sequenceStr = '001';
        else;
          sequenceStr = %editc(nextSequence:'X');
        endif;

        // Build product ID: CCC###-CCCMMDDYY
        productID = categoryCode +
                    sequenceStr +
                    '-' +
                    companyCode +
                    dateStr;

        // Set return values
        returnData.Success = *on;
        returnData.ProductID = productID;
        returnData.ErrorMessage = '';

        return returnData;

        end-proc GENTMPP;


