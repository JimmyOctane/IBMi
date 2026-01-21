      //******************************************************************************
      // GETITEM_CP - Copy Member for GETITEM Service Program
      //
      // Purpose: Contains data structure definitions and prototypes for the
      //          GETITEM inventory item retrieval service program
      //
      // Author: System Generated
      // Date: 2026-01-21
      // Version: 1.0
      //
      //******************************************************************************

      // Open Purchase Order structure
      dcl-ds openPO_t qualified template;
        Status char(1);                              // PO Status
        ETADate date;                                // Expected arrival date
        PONumber packed(7:0);                        // Purchase order number
        POLine packed(3:0);                          // PO line number
        Quantity packed(11:2);                       // Order quantity
      end-ds;

      // Main return data structure for item information
      dcl-ds returnItemDS qualified template;
        Company char(2);                             // Company code
        Branch char(3);                              // Branch/Location code
        Section char(3);                             // Item section code
        Group char(3);                               // Item group code
        Category char(3);                            // Item category code
        Product packed(15:5);                        // Product identifier
        Description char(30);                        // Item description
        OnHand packed(11:2);                         // On-hand quantity
        WACUnitCost packed(11:4);                    // Weighted average cost
        ExtWACCost packed(13:2);                     // Extended WAC cost
        MarketCost packed(11:4);                     // Market cost per unit
        ExtMarketCost packed(13:2);                  // Extended market cost
        ReplacementCost packed(11:4);                // Replacement cost per unit
        ExtReplacementCost packed(13:2);             // Extended replacement cost
        SubstituteCode char(1);                      // Item substitute code
        AssociatedCode char(1);                      // Associated item code
        ComponentCode char(1);                       // Item component code
        DeleteCode char(1);                          // Item delete code
        ChangedCode char(1);                         // Item changed code
        StockingUOM char(3);                         // Stocking unit of measure
        ItemWeight packed(9:4);                      // Inventory item weight
        LockedCode char(1);                          // Item locked for update
        ManufacturerNumber char(30);                 // Manufacturer number
        Month1Sales packed(11:2);                    // Last month sales
        Month2Sales packed(11:2);                    // 2 months ago sales
        Month3Sales packed(11:2);                    // 3 months ago sales
        Last3MonthsSales packed(11:2);               // Total last 3 months sales
        Last3MonthsReturns packed(11:2);             // Total last 3 months returns
        Last3MonthsAvg packed(11:2);                 // Average monthly sales
        PrevYearSales packed(11:2);                  // Previous year sales
        PrevYearReturns packed(11:2);                // Previous year returns
        PrevYearAvg packed(11:2);                    // Previous year monthly avg
        POCount packed(3:0);                         // Number of open POs
        OpenPOs likeds(openPO_t) dim(50);            // Open purchase orders array
        Found ind;                                   // Record found indicator
      end-ds;

      // Procedure prototype for GETITEM
      dcl-pr GETITEM likeds(returnItemDS) export;
        inItem packed(15:5) const;                   // Item number input
        inBranch packed(15:5) const;                 // Branch number input
      end-pr;