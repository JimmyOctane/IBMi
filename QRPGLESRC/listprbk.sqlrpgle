**FREE
//==============================================================================
// Program: LISTPRBK
// Purpose: Display and manage price book item exclusions
//==============================================================================
        // Description:
        //   This program displays items from IVPMSTR/IVPMSBR for a given company,
        //   branch, and customer combination. Users can mark items to be excluded
        //   from the price book by selecting option 1 (Omit) or option 4 (Remove Omit).
        //
        //   Excluded items are stored in the LISTPRBKP table with status 'X'.
        //   Items already marked as excluded display '*OMIT' in red on the screen.
        //
        //   The program uses page-at-a-time loading to handle large datasets
        //   efficiently, loading additional records as the user pages down.
        //
        // Parameters:
        //   1. incompany  (15:5) - Company number, converted to 3:0
        //   2. inBranch   (15:5) - Branch number, converted to 3:0
        //   3. incustomer (15:5) - Customer number, converted to 6:0
        //
        // Tables Used:
        //   IVPMSTR  - Item master file
        //   IVPMSBR  - Item branch file
        //   LISTPRBKP - Price book exclusions (output)
        //==============================================================================

        Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIO);

        // Display File
        Dcl-F LISTPRBKD WorkStn Sfile(SUB01:SCRRN)
              IndDs(Indicators) Infds(INFDS) UsrOpn;

        // File Information Data Structure
        Dcl-Ds INFDS Qualified;
          choice    Char(1) Pos(369);
          cLocation Char(2) Pos(370);
          curRec    Int(5:0) Pos(378);
        End-Ds;

        // Command Key Constants
        Dcl-C LeaveProgram Const(x'33');  // F3
        Dcl-C OmitAll      Const(x'37');  // F7
        Dcl-C RemoveAll    Const(x'38');  // F8
        Dcl-C ToggleView   Const(x'39');  // F9
        Dcl-C Previous     Const(x'3C');  // F12
        Dcl-C Refresh      Const(x'35');  // F5
        Dcl-C PageDownKey  Const(x'F5');  // Page Down
        Dcl-C PageUpKey    Const(x'F4');  // Page Up

        // Indicator Data Structure
        Dcl-Ds Indicators;
          SflClr        Ind Pos(30);
          SflDsp        Ind Pos(31);
          SflDspCtl     Ind Pos(32);
          SflEnd        Ind Pos(33);
          PosItemChg    Ind Pos(50);
          PosProdChg    Ind Pos(51);
          PosDescChg    Ind Pos(52);
          PosSectChg    Ind Pos(53);
          PosGrpChg     Ind Pos(54);
          PosCatChg     Ind Pos(55);
          ShowAllMode   Ind Pos(60);  // *On = Show All, *Off = Excluded Only
          SflNxtChg     Ind Pos(99);
        End-Ds;

        // Program Status Data Structure (PSDS) - Information Data Structure
        Dcl-Ds PSDS Psds Qualified;
          PgmName       Char(10)    Pos(1);      // Program name
          PgmStatus     Zoned(5:0)  Pos(11);     // Program status code
          PrevStatus    Zoned(5:0)  Pos(16);     // Previous status
          LineNumber    Char(8)     Pos(21);     // Source line number
          Routine       Char(8)     Pos(29);     // Routine name
          Parms         Zoned(3:0)  Pos(37);     // Number of parameters
          ExcpType      Char(3)     Pos(40);     // Exception type
          ExcpNum       Zoned(4:0)  Pos(43);     // Exception number
          PgmLib        Char(10)    Pos(81);     // Program library
          ExcpData      Char(80)    Pos(91);     // Exception data
          ExcpId        Char(4)     Pos(171);    // Exception Id
          Date          Char(8)     Pos(191);    // Date (YYYYMMDD)
          Year          Zoned(2:0)  Pos(199);    // Year (YY)
          LastFile      Char(8)     Pos(201);    // Last file used
          LastFileInfo  Char(35)    Pos(209);    // File info
          JobName       Char(10)    Pos(244);    // Job name
          UserId        Char(10)    Pos(254);    // User ID
          JobNumber     Zoned(6:0)  Pos(264);    // Job number
          JobDate       Zoned(6:0)  Pos(270);    // Job date (YYMMDD)
          RunDate       Zoned(6:0)  Pos(276);    // Run date (YYMMDD)
          RunTime       Zoned(6:0)  Pos(282);    // Run time (HHMMSS)
          CompileDate   Char(6)     Pos(288);    // Compile date
          CompileTime   Char(6)     Pos(294);    // Compile time
          CompileLevel  Char(4)     Pos(300);    // Compiler level
          SrcFile       Char(10)    Pos(304);    // Source file
          SrcLib        Char(10)    Pos(314);    // Source library
          SrcMember     Char(10)    Pos(324);    // Source member
          ProcName      Char(256)   Pos(334);    // Procedure name
          ModuleName    Char(10)    Pos(590);    // Module name
          ModuleLib     Char(10)    Pos(600);    // Module library
          ActGrpName    Char(10)    Pos(610);    // Activation group
          ActGrpNum     Zoned(10:0) Pos(620);    // Activation group number
          AgLevel       Zoned(8:0)  Pos(630);    // AG level
        End-Ds;

        // File definitions - data structure array for batch fetching
        Dcl-Ds PriceBookItemDS Dim(10000) Qualified;
          item        Packed(6:0);   // Item number (IVNO07)
          product     Char(15);      // Product code (IVNO04)
          description Char(30);      // Item description (IVDN01) - max 30 for LISTPRBKP
          section     Char(3);       // Purchasing Section Code (IVCD17)
          group       Char(3);       // Purchasing Group Code (IVCD18)
          category    Char(3);       // Purchasing Category Code (IVCD19)
        End-Ds;

        // Single row data structure for processing
        Dcl-Ds PriceBookItemRow LikeDs(PriceBookItemDS);

        // Parameters - Company, Branch, Customer (in order)
        Dcl-Pi *N;
          incompany     Packed(15:5);
          inBranch      Packed(15:5);
          incustomer    Packed(15:5);
        End-Pi;

        // Work fields
        Dcl-S RecordCount Packed(7:0) Inz(0);
        Dcl-S BranchNumber Packed(3:0);
        Dcl-S CustomerNumber Packed(6:0);
        Dcl-S CompanyNumber Packed(3:0);
        Dcl-S BranchItemCount Int(10) Inz(0);
        Dcl-S TotalRecords Int(10) Inz(0);
        Dcl-S CurrentIndex Int(10) Inz(0);
        Dcl-S CurrentItem Packed(6:0);
        Dcl-S i Int(10) Inz(0);
        Dcl-S IsOmitted Int(10) Inz(0);
        Dcl-S ProcessOption Char(1);
        Dcl-S PageSize Int(10) Inz(12);

        // Initialize parameters
        // Company (parameter 1) - required, numeric 15:5, move to 3:0
        CompanyNumber = incompany;

        // Branch (parameter 2) - required, numeric 15:5, move to 3:0
        BranchNumber = inBranch;

        // Customer (parameter 3) - required, numeric 15:5, move to 6:0
        CustomerNumber = incustomer;

        // Open display file
        Open LISTPRBKD;

        // Set SQL options for auto-commit mode
        Exec SQL Set Option Commit=*None, DatFmt=*ISO, ClosqlCsr=*EndMod;

        // Initialize display fields
        COMPANY = CompanyNumber;
        BRANCH = BranchNumber;
        CUSTOMER = CustomerNumber;
        USERID = PSDS.UserId;
        DSPCOMP = CompanyNumber;
        DSPBRNCH = BranchNumber;
        DSPCUST = CustomerNumber;
        DSPUSER = PSDS.UserId;
        C1TITLE = 'Include/Omit Items for Price Book';

        // Initialize positioning fields to blanks
        POSITEM = ' ';
        POSPROD = ' ';
        POSDESC = ' ';
        POSSECT = ' ';
        POSGRP = ' ';
        POSCAT = ' ';

        // Initialize view mode to show all items
        ShowAllMode = *On;

        // Clear subfile
        SflClr = *On;
        SflDspCtl = *On;
        Write SUB01CTL;
        SflClr = *Off;
        SCRRN = 0;

        // Load all records into array
        LoadAllRecords();

        // Load first page into subfile
        LoadSubfilePage();

        // Display and process subfile
        DisplayAndProcess();

        // Close display file
        Close LISTPRBKD;
        *InLR = *On;
        Return;

    //==============================================================================
    // Subprocedure: LoadAllRecords
    // Purpose: Load all records from database into array
    //==============================================================================
    Dcl-Proc LoadAllRecords;

      // SQL cursor to fetch all records
      Exec SQL Declare C1 Scroll Cursor For
        Select Distinct I.IVNO07,    // Item number
              I.IVNO04,              // Our Product Number
              I.IVDN01,              // Item description
              COALESCE(I.IVCD17, ' '),  // Purchasing Section Code
              COALESCE(I.IVCD18, ' '),  // Purchasing Group Code
              COALESCE(I.IVCD19, ' ')   // Purchasing Category Code
        From IVPMSTR I
        Join IVPMSBR B On I.IVNO07 = B.IVNO07
                      And B.IVNO10 = :BranchNumber
                      And B.GLNO01 = :CompanyNumber
        Where I.IVCDC8 = ' '
          And I.IVCD25 <> 'D'
          And Upper(I.IVDN01) Not Like '%DO NOT USE%'
          And (TRIM(:POSITEM) = '' Or
               CHAR(I.IVNO07) Like TRIM(:POSITEM) Concat '%')
          And (TRIM(:POSPROD) = '' Or COALESCE(I.IVNO04, '') Like TRIM(:POSPROD) Concat '%')
          And (TRIM(:POSDESC) = '' Or I.IVDN01 Like '%' Concat TRIM(:POSDESC) Concat '%')
          And (TRIM(:POSSECT) = '' Or COALESCE(I.IVCD17, '') Like TRIM(:POSSECT) Concat '%')
          And (TRIM(:POSGRP) = '' Or COALESCE(I.IVCD18, '') Like TRIM(:POSGRP) Concat '%')
          And (TRIM(:POSCAT) = '' Or COALESCE(I.IVCD19, '') Like TRIM(:POSCAT) Concat '%')
          And (:ShowAllMode = '1' Or
               Exists (Select 1 From LISTPRBKP P
                       Where P.COMPANY = :CompanyNumber
                         And P.BRANCH = :BranchNumber
                         And P.CUSTOMER = :CustomerNumber
                         And P.ITEM = I.IVNO07
                         And P.USERID = :PSDS.UserId))
        Order By 4, 5, 6
        For Read Only;

      Exec SQL Open C1;

      // Fetch all records into array
      Exec SQL
        Fetch Next From C1 For 10000 Rows
        Into :PriceBookItemDS;
      Exec SQL Get Diagnostics :TotalRecords = ROW_COUNT;

      Exec SQL Close C1;

      // Reset current index
      CurrentIndex = 0;

    End-Proc;

    //==============================================================================
    // Subprocedure: LoadSubfilePage
    // Purpose: Load next page of records from array into subfile
    //==============================================================================
    Dcl-Proc LoadSubfilePage;

      Dcl-S RecordsLoaded Int(10) Inz(0);
      Dcl-S MaxToLoad Int(10) Inz(0);

      // Load one page of records (14 records)
      MaxToLoad = PageSize;

      // Load records from array
      RecordsLoaded = 0;
      SCRRN = 0;
      DoW RecordsLoaded < MaxToLoad And CurrentIndex < TotalRecords;
        CurrentIndex += 1;
        CurrentItem = PriceBookItemDS(CurrentIndex).item;

        // Check if item is omitted
        Exec SQL
          Select Count(*)
          Into :IsOmitted
          From LISTPRBKP
          Where COMPANY = :CompanyNumber
            And BRANCH = :BranchNumber
            And CUSTOMER = :CustomerNumber
            And ITEM = :CurrentItem
            And USERID = :PSDS.UserId;

        // Load subfile record
        SCRRN += 1;
        S1OPT = ' ';
        S1ITEM = %EditC(CurrentItem:'X');
        S1PROD = PriceBookItemDS(CurrentIndex).product;
        S1DESC = PriceBookItemDS(CurrentIndex).description;
        S1SECT = PriceBookItemDS(CurrentIndex).section;
        S1GRP = PriceBookItemDS(CurrentIndex).group;
        S1CAT = PriceBookItemDS(CurrentIndex).category;
        If IsOmitted > 0;
          S1OMIT = '*OMIT';
        Else;
          S1OMIT = ' ';
        EndIf;
        Write SUB01;

        RecordsLoaded += 1;
      EndDo;

      // If no records loaded, write one dummy record to avoid subfile error
      If SCRRN = 0;
        SCRRN = 1;
        S1OPT = ' ';
        S1ITEM = ' ';
        S1PROD = ' ';
        S1DESC = 'No records found';
        S1SECT = ' ';
        S1GRP = ' ';
        S1CAT = ' ';
        S1OMIT = ' ';
        Write SUB01;
      EndIf;

      // Set end indicator if we've loaded all records
      If CurrentIndex >= TotalRecords;
        SflEnd = *On;
      EndIf;

    End-Proc;

    //==============================================================================
    // Subprocedure: DisplayAndProcess
    // Purpose: Display subfile and process user input
    //==============================================================================
    Dcl-Proc DisplayAndProcess;

      Dow *On;
        // Display subfile
        SflDsp = *On;
        SflDspCtl = *On;
        Write FOOTER;
        Exfmt SUB01CTL;

        // Process function keys FIRST (before positioning changes)
        Select;
          // F3/F12 pressed - leave program
          When INFDS.Choice = LeaveProgram Or
               INFDS.Choice = Previous;
            Leave;

          // F7 - Omit All (only if positioning filters are active)
          When INFDS.Choice = OmitAll;
            If HasPositioningFilters();
              // Reset positioning change indicators first
              PosItemChg = *Off;
              PosProdChg = *Off;
              PosDescChg = *Off;
              PosSectChg = *Off;
              PosGrpChg = *Off;
              PosCatChg = *Off;
              // Perform bulk omit operation on all filtered items
              OmitAllFiltered();
              // Reload subfile to show updated status
              CurrentIndex = 0;
              SflEnd = *Off;
              SflClr = *On;
              SflDspCtl = *On;
              Write SUB01CTL;
              SflClr = *Off;
              LoadAllRecords();
              LoadSubfilePage();
              // Don't clear debug message after F7
              Iter;
            EndIf;

          // F8 - Remove All Omits (only if positioning filters are active)
          When INFDS.Choice = RemoveAll;
            If HasPositioningFilters();
              // Reset positioning change indicators first
              PosItemChg = *Off;
              PosProdChg = *Off;
              PosDescChg = *Off;
              PosSectChg = *Off;
              PosGrpChg = *Off;
              PosCatChg = *Off;
              // Perform bulk remove operation on all filtered items
              RemoveAllFiltered();
              // Reload subfile to show updated status
              CurrentIndex = 0;
              SflEnd = *Off;
              SflClr = *On;
              SflDspCtl = *On;
              Write SUB01CTL;
              SflClr = *Off;
              LoadAllRecords();
              LoadSubfilePage();
            EndIf;

          // Check if any positioning field changed (but not if F7/F8 was pressed)
          When PosItemChg Or PosProdChg Or PosDescChg Or
               PosSectChg Or PosGrpChg Or PosCatChg;
            // Reset change indicators
            PosItemChg = *Off;
            PosProdChg = *Off;
            PosDescChg = *Off;
            PosSectChg = *Off;
            PosGrpChg = *Off;
            PosCatChg = *Off;
            // Reload data with new positioning
            CurrentIndex = 0;
            SflEnd = *Off;
            SflClr = *On;
            SflDspCtl = *On;
            Write SUB01CTL;
            SflClr = *Off;
            SCRRN = 0;
            LoadAllRecords();
            LoadSubfilePage();
            Iter;  // Skip to next iteration

          // F9 - Toggle between Show All and Excluded Only
          When INFDS.Choice = ToggleView;
            // Toggle the view mode
            ShowAllMode = Not ShowAllMode;
            // Reload data with new filter
            CurrentIndex = 0;
            SflEnd = *Off;
            SflClr = *On;
            SflDspCtl = *On;
            Write SUB01CTL;
            SflClr = *Off;
            LoadAllRecords();
            LoadSubfilePage();

          // Page Down
          When INFDS.Choice = PageDownKey;
            If Not SflEnd;
              // Clear subfile and load next page
              SflClr = *On;
              SflDspCtl = *On;
              Write SUB01CTL;
              SflClr = *Off;
              LoadSubfilePage();
            EndIf;

          // Page Up
          When INFDS.Choice = PageUpKey;
            If CurrentIndex > PageSize;
              // Move back two pages
              CurrentIndex -= (PageSize * 2);
              If CurrentIndex < 0;
                CurrentIndex = 0;
              EndIf;
              SflEnd = *Off;
              // Clear subfile and load previous page
              SflClr = *On;
              SflDspCtl = *On;
              Write SUB01CTL;
              SflClr = *Off;
              LoadSubfilePage();
            EndIf;

          // Enter key or other - process options
          Other;
            ProcessOptions();

        EndSl;

      EndDo;

    End-Proc;

    //==============================================================================
    // Subprocedure: ProcessOptions
    // Purpose: Process user-selected options from subfile
    //==============================================================================
    Dcl-Proc ProcessOptions;

      Dcl-S CurrentRRN Int(10) Inz(0);
      Dcl-S HasOption1 Ind Inz(*Off);
      Dcl-S HasOption4 Ind Inz(*Off);

      // Read changed records
      ReadC SUB01;
      DoW Not %Eof(LISTPRBKD);

        // Process option
        If S1OPT <> ' ';
          ProcessOption = S1OPT;

          Select;
            // Option 1 = Omit (add exclusion)
            When ProcessOption = '1';
              HasOption1 = *On;
              Exec SQL
                Insert Into LISTPRBKP
                  (ITEM, PRODUCT, SECTION, GRPCODE, CATEGORY, DESCRIPTION,
                  CUSTOMER, COMPANY, BRANCH, STATUS, USERID)
                Values
                  (CAST(:S1ITEM AS DECIMAL(6,0)), :S1PROD, :S1SECT,
                  :S1GRP, :S1CAT, :S1DESC, :CustomerNumber,
                  :CompanyNumber, :BranchNumber, 'X', :PSDS.UserId);

              // Check if insert was successful or already exists
              If SQLCODE = 0 Or SQLCODE = -803;  // 0=success, -803=duplicate key
                S1OMIT = '*OMIT';
                S1OPT = ' ';
                Update SUB01;
              EndIf;

            // Option 4 = Remove Omit (delete exclusion)
            When ProcessOption = '4';
              HasOption4 = *On;
              Exec SQL
                Delete From LISTPRBKP
                Where COMPANY = :CompanyNumber
                  And BRANCH = :BranchNumber
                  And CUSTOMER = :CustomerNumber
                  And ITEM = CAST(:S1ITEM AS DECIMAL(6,0))
                  And USERID = :PSDS.UserId;

              // Check if delete was successful
              If SQLCODE = 0;
                S1OMIT = ' ';
                S1OPT = ' ';
                Update SUB01;
              EndIf;

            // Invalid option
            Other;
              S1OPT = ' ';
              Update SUB01;

          EndSl;
        EndIf;

        // Read next changed record
        ReadC SUB01;
      EndDo;

      // Note: Individual options (1 and 4) are processed above for specific items only.
      // F7 and F8 function keys handle bulk operations for all filtered items.
      // No bulk operation should occur here when processing individual options.

    End-Proc;

    //==============================================================================
    // Subprocedure: SetAllOptions
    // Purpose: Set option field on all visible subfile records
    //==============================================================================
    Dcl-Proc SetAllOptions;
      Dcl-Pi *N;
        OptionValue Char(1) Const;
      End-Pi;

      Dcl-S RRN Int(10) Inz(0);
      Dcl-S SavedSCRRN Int(10) Inz(0);

      // Save current SCRRN value
      SavedSCRRN = SCRRN;

      // Loop through all subfile records and set option
      For RRN = 1 To SavedSCRRN;
        Chain RRN SUB01;
        If %Found(LISTPRBKD);
          S1OPT = OptionValue;
          Update SUB01;
        EndIf;
      EndFor;

      // Restore SCRRN
      SCRRN = SavedSCRRN;

    End-Proc;

    //==============================================================================
    // Subprocedure: HasPositioningFilters
    // Purpose: Check if any positioning filters are active
    //==============================================================================
    Dcl-Proc HasPositioningFilters;
      Dcl-Pi *N Ind End-Pi;

      // Return true if any positioning field has a value
      If %Trim(POSITEM) <> '' Or
         %Trim(POSPROD) <> '' Or
         %Trim(POSDESC) <> '' Or
         %Trim(POSSECT) <> '' Or
         %Trim(POSGRP) <> '' Or
         %Trim(POSCAT) <> '';
        Return *On;
      Else;
        Return *Off;
      EndIf;

    End-Proc;

    //==============================================================================
    // Subprocedure: OmitAllFiltered
    // Purpose: Omit all items matching current positioning filters
    //==============================================================================
    Dcl-Proc OmitAllFiltered;

      Dcl-S RowsInserted Int(10) Inz(0);
      Dcl-S DeleteCode Int(10);

      // Loop through the PriceBookItemDS array and insert each item
      // The array is already filtered by LoadAllRecords()
      
      For i = 1 To TotalRecords;
        // Move array values to scalar variables for SQL
        PriceBookItemRow = PriceBookItemDS(i);
        
        // First delete if exists
        Exec SQL
          Delete From LISTPRBKP
          Where COMPANY = :CompanyNumber
            And BRANCH = :BranchNumber
            And CUSTOMER = :CustomerNumber
            And ITEM = :PriceBookItemRow.item
            And USERID = :PSDS.UserId;
        
        DeleteCode = SQLCODE;  // Save delete result
        
        // Then insert the record
        Exec SQL
          Insert Into LISTPRBKP
            (ITEM, PRODUCT, SECTION, GRPCODE, CATEGORY, DESCRIPTION,
             CUSTOMER, COMPANY, BRANCH, STATUS, USERID)
          Values
            (:PriceBookItemRow.item,
             :PriceBookItemRow.product,
             :PriceBookItemRow.section,
             :PriceBookItemRow.group,
             :PriceBookItemRow.category,
             :PriceBookItemRow.description,
             :CustomerNumber,
             :CompanyNumber,
             :BranchNumber,
             'X',
             :PSDS.UserId);
        
        // Check INSERT result (SQLCODE 0 = success)
        If SQLCODE = 0;
          RowsInserted += 1;
        Else;
          // Stop on first INSERT error
          Leave;
        EndIf;
      EndFor;

    End-Proc;

    //==============================================================================
    // Subprocedure: RemoveAllFiltered
    // Purpose: Remove all omits for items matching current positioning filters
    //==============================================================================
    Dcl-Proc RemoveAllFiltered;

      Dcl-S RowsDeleted Int(10) Inz(0);

      // Loop through the PriceBookItemDS array and delete each item
      // The array is already filtered by LoadAllRecords()
      For i = 1 To TotalRecords;
        // Move array values to scalar variables for SQL
        PriceBookItemRow = PriceBookItemDS(i);
        
        Exec SQL
          Delete From LISTPRBKP
          Where COMPANY = :CompanyNumber
            And BRANCH = :BranchNumber
            And CUSTOMER = :CustomerNumber
            And ITEM = :PriceBookItemRow.item
            And USERID = :PSDS.UserId;
        
        If SQLCODE = 0;
          RowsDeleted += 1;
        EndIf;
      EndFor;

    End-Proc;
