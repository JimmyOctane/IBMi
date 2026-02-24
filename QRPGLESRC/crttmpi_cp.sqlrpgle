        //*******************************************************************
        // CRTTMPI_CP - Copy Member for CRTTMPI Service Program
        //
        // Purpose: Contains data structure definitions and prototypes
        //          for the CRTTMPI (Create Temporary Item) service program
        //
        // Author: System Generated
        // Date: 2026-02-23
        // Version: 2.0
        //
        //*******************************************************************

        // Input parameters structure for creating temporary item
        dcl-ds crttmpiInput_t qualified template;
            ItemNumber        char(17);              // IVNO04 - Item number
            Description       char(48);              // IVDN01 - Description
            VendorNumber      packed(6:0);           // APNO01 - Vendor number
            Section           char(3);               // IVCD17 - Section (opt)
            Group             char(3);               // IVCD18 - Group (opt)
            Category          char(3);               // IVCD19 - Category (opt)
            ShipBranch        packed(3:0);           // IVNO10 - Ship branch
        end-ds;

        // Return data structure for CRTTMPI
        dcl-ds crttmpiReturn_t qualified template;
            NewItemNumber     packed(6:0);           // New IVNO07 created
            Success           ind;                   // Success indicator
            ErrorMessage      char(50);              // Error message
        end-ds;

        // Procedure prototype for CRTTMPI
        dcl-pr CRTTMPI likeds(crttmpiReturn_t);
            input likeds(crttmpiInput_t) const;
        end-pr;


