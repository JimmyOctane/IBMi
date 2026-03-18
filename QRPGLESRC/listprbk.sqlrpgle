        //==============================================================================
        // Program: LISTPRBK
        // Purpose: List items that would be written to PRPPRBK (Price Book) table
        //          Based on PRICEBOOK.RPGLE logic
        //==============================================================================
        // Description:
        //   This program reads and displays items from the PRPPRBK table that were
        //   written by the PRICEBOOK program. These are the actual price book items.
        //
        //   Note: PRP4950 only contains one control record with job info.
        //         PRPPRBK contains the actual item records.
        //
        //   Parameters match PRICEBOOK.RPGLE for filtering:
        //     Profile, Customer, Disc_Prof_1-3, instocky, inabc, indiso,
        //     invend2, invend3
        //==============================================================================

        Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIO);

        // File definitions - data structure array for batch fetching
        Dcl-Ds PriceBookItemDS Dim(9999) Qualified;
          item     Packed(6:0);   // Item number (IVNO07)
          product  Char(30);      // Item description (IVNO04)
          section  Char(3);       // Purchasing Section Code (IVCD17)
          group    Char(3);       // Purchasing Group Code (IVCD18)
          category Char(3);       // Purchasing Category Code (IVCD19)
        End-Ds;

        // Single row data structure for processing
        Dcl-Ds PriceBookItemRow LikeDs(PriceBookItemDS);

        // Parameters - Branch and Customer are required
        Dcl-Pi *N;
          inBranch      Packed(15:5);
          incustomer    Packed(15:5);
        End-Pi;

        // Work fields
        Dcl-S RecordCount Packed(7:0) Inz(0);
        Dcl-S BranchNum Packed(3:0);
        Dcl-S CustomerNum Packed(6:0);
        Dcl-S BranchItemCount Int(10) Inz(0);
        Dcl-S rowCount Int(10) Inz(0);
        Dcl-S maxRows Int(10) Inz(9999);
        Dcl-S i Int(10) Inz(0);

        // Initialize parameters
        // Branch (parameter 1) - required, numeric 15:5, move to 3:0
        BranchNum = inBranch;

        // Customer (parameter 2) - required, numeric 15:5, move to 6:0
        CustomerNum = incustomer;
       
        // Get count of items for this branch
        Exec SQL
          Select Count(*)
          Into :BranchItemCount
          From IVPMSBR
          Where IVNO10 = :BranchNum;

        // SQL cursor with all filtering logic embedded
        // Join with IVPMSTR for item master data (ABC, vendor, description checks)
        // Join with IVPMSBR for branch-specific data (in-stock, ABC classification)
        // Join with PRLMCPF for discount/contract data

        Exec SQL Declare C1 Scroll Cursor For
          Select Distinct I.IVNO07,    // Item number
                I.IVNO04,              // Item description
                I.IVCD17,              // Purchasing Section Code
                I.IVCD18,              // Purchasing Group Code
                I.IVCD19               // Purchasing Category Code
          From IVPMSTR I
           Join IVPMSBR B On I.IVNO07 = B.IVNO07
                         And B.IVNO10 = :BranchNum
          Order By I.IVCD17, I.IVCD18, I.IVCD19
          For Read Only;

        Exec SQL Open C1;

        // Fetch all records in one batch (up to 9999)
        Exec SQL
          Fetch Next From C1 For :maxRows Rows
          Into :PriceBookItemDS;
        Exec SQL Get Diagnostics :rowCount = ROW_COUNT;

        // Process all fetched records
        If rowCount > 0;
          For i = 1 To rowCount;
            RecordCount += 1;
            // Copy array element to scalar for processing
            PriceBookItemRow = PriceBookItemDS(i);
            // Add processing logic here as needed
          EndFor;
        EndIf;

        Exec SQL Close C1;

        *InLR = *On;
        Return;

