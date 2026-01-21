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
        Status            char(1);                     // PO Status Code (pocd20)
        ETADate          date;                        // Expected arrival date
        PONumber         packed(7:0);                 // PO Number (pono01)
        POLine           packed(3:0);                 // PO Line (pono05)
        Quantity         packed(11:2);                // Quantity ordered (poqy01)
      end-ds;

      // Main return data structure for item information
      dcl-ds returnItemDS qualified;
        Company           char(2);                    // c.GLNO01 - Company code
        Branch            char(3);                    // c.IVNO10 - Branch number
        Section           char(2);                    // b.IVCD17 - Product section
        Group             char(2);                    // b.IVCD18 - Product group
        Category          char(2);                    // b.IVCD19 - Product category
        Product           char(30);                   // b.IVNO04 - Product identifier
        Description       char(30);                   // b.IVDN01 - Product description
        OnHand            packed(11:2);               // c.IVQY01 - Quantity on hand
        WACUnitCost       packed(11:2);               // c.IVAMW6 - WAC per unit
        ExtWACCost        packed(13:2);               // Calculated: OnHand * WACUnitCost
        MarketCost        packed(11:2);               // b.IVAM05 - Market cost per unit
        ExtMarketCost     packed(13:2);               // Calculated: MarketCost * OnHand
        ReplacementCost   packed(11:2);               // b.IVAM34 - Replacement cost per unit
        ExtReplacementCost packed(13:2);              // Calculated: ReplacementCost * OnHand
        // Sales data - Last 3 months (individual buckets)
        Month1Sales       packed(11:2);               // Most recent month sales
        Month2Sales       packed(11:2);               // 2nd month back sales
        Month3Sales       packed(11:2);               // 3rd month back sales
        Last3MonthsSales  packed(11:2);               // Total sales qty last 3 months
        Last3MonthsReturns packed(11:2);              // Total returns qty last 3 months
        Last3MonthsAvg    packed(11:2);               // Average monthly sales last 3 months
        // Sales data - Previous year same period
        PrevYearSales     packed(11:2);               // Sales qty prev year same period
        PrevYearReturns   packed(11:2);               // Returns qty prev year same period
        PrevYearAvg       packed(11:2);               // Average monthly sales prev year
        // Open Purchase Orders Array
        OpenPOs           likeds(openPO_t) dim(50);   // Array of open POs
        POCount           packed(3:0);                // Number of open POs found
        Found             ind;                        // Record found indicator
      end-ds;

      // Procedure prototype for GETITEM
      dcl-pr GETITEM likeds(returnItemDS) export;
        inItem packed(15:5) const;                   // Item number input
        inBranch packed(15:5) const;                 // Branch number input
      end-pr;
