        //==============================================================================
        // Program: ARPCOMM1
        // Description: Display Commission Matrix rates based on Plan, Division, Section
        // Author: Generated
        // Date: 2026-02-13
        //==============================================================================

        CTL-OPT DFTACTGRP(*NO) ACTGRP(*NEW) OPTION(*NODEBUGIO) DATFMT(*ISO);

        // Display file
        DCL-F ARDMTR WORKSTN SFILE(CMMSFL:RRN) INDDS(Indicators);

        // Data structures
        DCL-DS Indicators;
        F3              IND POS(3);
        F5              IND POS(5);
        F12             IND POS(12);
        SflClr          IND POS(30);
        SflDsp          IND POS(31);
        SflDspCtl       IND POS(32);
        SflEnd          IND POS(33);
        END-DS;

        // Program parameters
        DCL-PI *N;
        pPlanNo     PACKED(2:0);
        pDivision   CHAR(3);
        pSection    CHAR(3);
        END-PI;

        // Global variables
        DCL-S RRN           PACKED(4:0);
        DCL-S ValidInput    IND INZ(*OFF);
        DCL-S RecCount      PACKED(5:0);
        DCL-S FirstTime     IND INZ(*ON);

        // Main processing
        Main();
        *INLR = *ON;
        RETURN;

        //==============================================================================
        // Main procedure
        //==============================================================================
        DCL-PROC Main;

        // Initialize display
        PLANNO = pPlanNo;
        DIVISN = pDivision;
        SECTN = pSection;
        C1TITLE = 'Commission Matrix Display';

        // Validate input parameters
        IF ValidateParameters();
            LoadSubfile();
            DisplayScreen();
        ELSE;
            // Invalid parameters - exit
            RETURN;
        ENDIF;

        END-PROC;

        //==============================================================================
        // Validate input parameters
        //==============================================================================
        DCL-PROC ValidateParameters;
        DCL-PI *N IND END-PI;

        DCL-S Valid IND INZ(*ON);

        // Check Plan Number
        IF pPlanNo <= 0;
            Valid = *OFF;
        ENDIF;

        // Check Division
        IF %TRIM(pDivision) = '';
            Valid = *OFF;
        ENDIF;

        // Check Section
        IF %TRIM(pSection) = '';
            Valid = *OFF;
        ENDIF;

        RETURN Valid;

        END-PROC;

        //==============================================================================
        // Load subfile with commission matrix data
        //==============================================================================
        DCL-PROC LoadSubfile;

        // Clear subfile
        RRN = 0;
        SflClr = *ON;
        SflDspCtl = *ON;
        WRITE CMMCTL;
        SflClr = *OFF;

        RecCount = 0;

        // SQL cursor to fetch commission rates
        EXEC SQL DECLARE C1 CURSOR FOR
            SELECT CAST(SALES_LOW AS DECIMAL(7,0)),
                CAST(SALES_HIGH AS DECIMAL(7,0)),
                CAST(PROFIT_LOW AS DECIMAL(3,1)),
                CAST(PROFIT_HIGH AS DECIMAL(3,1)),
                CAST(COMM_RATE AS DECIMAL(4,2))
            FROM ARPCOMMTX
            WHERE PLAN_NO = :pPlanNo
            AND COMPANY_NO = 1
            AND DIVISION = :pDivision
            AND SECTION = :pSection
            ORDER BY SALES_LOW, PROFIT_LOW;

        EXEC SQL OPEN C1;

        IF SQLCODE < 0;
            // Error opening cursor
            SflDsp = *OFF;
            SflDspCtl = *ON;
            RETURN;
        ENDIF;

        DOW SQLCODE = 0;
            EXEC SQL FETCH C1 INTO :SALELO, :SALEHI, :PROFLO, :PROFHI, :COMMRT;

            IF SQLCODE = 0;
            RRN += 1;
            RecCount += 1;
            WRITE CMMSFL;
            ENDIF;
        ENDDO;

        EXEC SQL CLOSE C1;

        // Set subfile display indicators
        IF RRN > 0;
            SflDsp = *ON;
            SflDspCtl = *ON;
            SflEnd = *ON;
        ELSE;
            SflDsp = *OFF;
            SflDspCtl = *ON;
        ENDIF;

        END-PROC;

        //==============================================================================
        // Display screen and handle user interaction
        //==============================================================================
        DCL-PROC DisplayScreen;

        DOW NOT F3 AND NOT F12;

            // Write the window format first if first time
            IF FirstTime;
            WRITE FMT1;
            FirstTime = *OFF;
            ENDIF;

            EXFMT CMMCTL;

            SELECT;
            // Exit
            WHEN F3;
                LEAVE;

            // Cancel
            WHEN F12;
                LEAVE;

            // Refresh
            WHEN F5;
                LoadSubfile();

            // Default - just redisplay
            OTHER;
                ;

            ENDSL;

        ENDDO;

        END-PROC;
