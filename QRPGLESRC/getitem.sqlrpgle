      // Control Options
         Ctl-Opt NoMain;                         // Service program (no main)
         Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
         Ctl-Opt BndDir('QC2LE');                // Bind to C runtime library
         Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
         Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
         Ctl-Opt Copyright('East Coast Metals - Return Item Information');

      //******************************************************************************
      // GETITEM - Inventory Item Data Retrieval Service Program
      //
      // Purpose: Retrieves comprehensive inventory item data including costs and
      //          quantities by joining Item Master, Item Status, and Branch tables
      //
      // Parameters:
      //   Item   - Item/Product number (IVNO07) - up to 30 characters
      //   Branch - Branch/Location number (IVNO10) - 3 characters
      //
      // Returns: GETITEM_DS data structure containing:
      //   - Basic item information (company, branch, section, group, category)
      //   - Product details (identifier, description)
      //   - Quantities and costs (on-hand, WAC unit cost, market cost, replacement cost)
      //   - Calculated extended costs (extended WAC, market, replacement)
      //   - Item attributes (substitute, associated, component, delete, changed codes)
      //   - Physical properties (stocking UOM, item weight, manufacturer number)
      //   - Status information (item locked status)
      //   - Sales metrics (monthly sales for last 3 months, returns, averages)
      //   - Previous year comparison data (sales, returns, monthly average)
      //   - Open purchase order array (status, ETA date, PO number, line, quantity)
      //   - Found indicator (true if record exists, false if not found)
      //
      // Tables Used:
      //   IVPMSBR - Item Status by Branch (primary - contains quantities and WAC)
      //   IVPMSTR - Item Master (product information and unit costs)
      //   ARPMBCH - Branch Master (branch/location validation)
      //   OEPTOLY - Order Entry Transaction History (sales and returns data)
      //   POPTOH - Purchase Order Header (PO status and dates)
      //   POPTOL - Purchase Order Line (item details and quantities)
      //
      // Author: [Your Name]
      // Date: [Current Date]
      // Version: 1.3
      //
      // Modification History:
      //   Date       Author        Description
      //   ---------- ------------- ----------------------------------------------
      //   [Date]     [Your Name]   Initial implementation
      //   2026-01-21 Enhancement   Added date-filtered sales analytics using OEPTOLY
      //                           - Monthly sales data for last 3 months (OEQY03)
      //                           - Returns tracking with 3-month rolling window
      //                           - Previous year comparison metrics
      //                           - Enhanced date range calculations
      //                           Added open purchase orders using POPTOH/POPTOL
      //                           - Array of open POs with status, ETA, and quantities
      //                           - Cursor-based processing with named constant limit
      //                           Added additional IVPMSTR fields for enhanced data
      //                           - Item codes (substitute, associated, component, etc.)
      //                           - Physical properties (UOM, weight, manufacturer)
      //                           - Status indicators (locked, delete, changed codes)
      //                           Code quality improvements
      //                           - Named constants for all magic numbers
      //                           - Safe division operations with zero protection
      //                           - Fixed SQL syntax errors and line length compliance
      //
      //******************************************************************************

      // Copy members for data structures and prototypes
      /copy qrpglesrc,GETITEM_CP

      //************************************************************
      // GETITEM - External Procedure
      //************************************************************
       dcl-proc GETITEM export;

       // Named constants
       dcl-c MAX_PO_RECORDS const(50);         // Maximum PO records to return
       dcl-c MONTHS_FOR_ANALYSIS const(3);     // Number of months for sales analysis
       dcl-c PREV_YEAR_MONTHS const(2);        // Previous year analysis period

       dcl-pi GETITEM likeds(returnItemDS) export;
         inItem packed(15:5) const;                    // IVNO07 - Item number
         inBranch packed(15:5) const;                  // IVNO10 - Branch number
       end-pi;

        // Local variables
        dcl-s currentDate date;
        dcl-s threeMonthsAgo date;
        dcl-s prevYearStart date;
        dcl-s prevYearEnd date;
        dcl-s salesCount packed(11:2);
        dcl-s returnsCount packed(11:2);
        dcl-s month1Sales packed(11:2);
        dcl-s month2Sales packed(11:2);
        dcl-s month3Sales packed(11:2);
        dcl-s month1Start date;
        dcl-s month2Start date;
        dcl-s month3Start date;
        dcl-s oeDate date;
        dcl-s poIndex packed(3:0);
        dcl-ds currentPO likeds(openPO_t);
        dcl-ds returnItemDS likeds(returnItemDS) template;
        dcl-s company char(2);
        dcl-s branch char(3);
        dcl-s section char(3);

        // Initialize return structure
        clear returnItemDS;
        returnItemDS.Found = *off;

        // Set current date and calculate date ranges
        currentDate = %date();
        threeMonthsAgo = currentDate - %months(MONTHS_FOR_ANALYSIS);
        prevYearStart = currentDate - %years(1) - %months(1);
        prevYearEnd = currentDate - %years(1) + %months(1);

        // Calculate monthly date ranges for last 3 months
        month1Start = currentDate - %months(1);      // Last month start
        month2Start = currentDate - %months(2);      // 2 months ago start
        month3Start = currentDate - %months(MONTHS_FOR_ANALYSIS);

        // Input parameter validation
        if inItem = 0;
          // Invalid item - return empty result
          return returnItemDS;
        endif;

        // Check if branch is 0 - use IVPMSTR only (no branch-specific data)
        if inBranch = 0;
          // Query IVPMSTR only for item master data
          exec sql
            declare getitem_master_cursor cursor for
            select ' ',                               // Company (empty)
                   ' ',                               // Branch (empty)
                   b.IVCD17,                          // Section
                   b.IVCD18,                          // Group
                   b.IVCD19,                          // Category
                   b.IVNO04,                          // Product
                   b.IVDN01,                          // Description
                   coalesce(sum(s.IVQY01), 0),        // OnHand (sum all branches)
                   0,                                 // WACUnitCost (0 - no branch)
                   0,                                 // ExtWACCost (0 - no branch)
                   b.IVAM05,                          // MarketCost
                   coalesce(sum(s.IVQY01) * b.IVAM05, 0), // ExtMarketCost
                   b.IVAM34,                          // ReplacementCost
                   coalesce(sum(s.IVQY01) * b.IVAM34, 0), // ExtReplacementCost
                   b.IVCD22,                          // SubstituteCode
                   b.IVCD23,                          // AssociatedCode
                   b.IVCD24,                          // ComponentCode
                   b.IVCD25,                          // DeleteCode
                   b.IVCD26,                          // ChangedCode
                   b.IVDN20,                          // StockingUOM
                   b.IVWT01,                          // ItemWeight
                   b.IVCD61,                          // LockedCode
                   char(b.IVNO93)                     // ManufacturerNumber
            from IVPMSTR b
            left join IVPMSBR s on b.IVNO07 = s.IVNO07
            where b.IVNO07 = :inItem
            group by b.IVCD17, b.IVCD18, b.IVCD19, b.IVNO04, b.IVDN01,
                     b.IVAM05, b.IVAM34, b.IVCD22, b.IVCD23, b.IVCD24,
                     b.IVCD25, b.IVCD26, b.IVDN20, b.IVWT01, b.IVCD61,
                     b.IVNO93
            for read only;

          // Open cursor for master data only
          exec sql open getitem_master_cursor;

          // Check for SQL errors on open
          if SQLCODE <> 0;
            exec sql close getitem_master_cursor;
            return returnItemDS;
          endif;

          // Fetch the master record
          exec sql
            fetch getitem_master_cursor into
              :returnItemDS.Company,
              :returnItemDS.Branch,
              :returnItemDS.Section,
              :returnItemDS.Group,
              :returnItemDS.Category,
              :returnItemDS.Product,
              :returnItemDS.Description,
              :returnItemDS.OnHand,
              :returnItemDS.WACUnitCost,
              :returnItemDS.ExtWACCost,
              :returnItemDS.MarketCost,
              :returnItemDS.ExtMarketCost,
              :returnItemDS.ReplacementCost,
              :returnItemDS.ExtReplacementCost,
              :returnItemDS.SubstituteCode,
              :returnItemDS.AssociatedCode,
              :returnItemDS.ComponentCode,
              :returnItemDS.DeleteCode,
              :returnItemDS.ChangedCode,
              :returnItemDS.StockingUOM,
              :returnItemDS.ItemWeight,
              :returnItemDS.LockedCode,
              :returnItemDS.ManufacturerNumber;

          // Check fetch results
          if SQLCODE = 0;
            returnItemDS.Found = *on;
          elseif SQLCODE = 100;
            returnItemDS.Found = *off;
          else;
            returnItemDS.Found = *off;
          endif;

          // Close cursor and get sales data for master-only query
          exec sql close getitem_master_cursor;

          // Set sales data to zero for branch = 0 case
          returnItemDS.Month1Sales = 0;
          returnItemDS.Month2Sales = 0;
          returnItemDS.Month3Sales = 0;
          returnItemDS.Last3MonthsSales = 0;
          returnItemDS.Last3MonthsReturns = 0;
          returnItemDS.Last3MonthsAvg = 0;
          returnItemDS.PrevYearSales = 0;
          returnItemDS.PrevYearReturns = 0;
          returnItemDS.PrevYearAvg = 0;
          returnItemDS.POCount = 0;
          clear returnItemDS.OpenPOs;

          return returnItemDS;
        endif;

        // Branch is not 0 - use full join with IVPMSBR and ARPMBCH
        exec sql
          declare getitem_cursor cursor for
          select c.GLNO01,                            // Company
                 c.IVNO10,                            // Branch
                 b.IVCD17,                            // Section
                 b.IVCD18,                            // Group
                 b.IVCD19,                            // Category
                 b.IVNO04,                            // Product
                 b.IVDN01,                            // Description
                 c.IVQY01,                            // OnHand
                 c.IVAMW6,                            // WACUnitCost
                 (c.IVQY01 * c.IVAMW6),               // ExtWACCost
                 b.IVAM05,                            // MarketCost
                 (b.IVAM05 * c.IVQY01),               // ExtMarketCost
                 b.IVAM34,                            // ReplacementCost
                 (b.IVAM34 * c.IVQY01),               // ExtReplacementCost
                 b.IVCD22,                            // SubstituteCode
                 b.IVCD23,                            // AssociatedCode
                 b.IVCD24,                            // ComponentCode
                 b.IVCD25,                            // DeleteCode
                 b.IVCD26,                            // ChangedCode
                 b.IVDN20,                            // StockingUOM
                 b.IVWT01,                            // ItemWeight
                 b.IVCD61,                            // LockedCode
                 char(b.IVNO93)                       // ManufacturerNumber
          from IVPMSBR c
               inner join IVPMSTR b on b.IVNO07 = c.IVNO07
               inner join ARPMBCH a on c.IVNO10 = a.ARNO16
          where c.IVNO07 = :inItem
            and c.IVNO10 = :inBranch
          order by c.GLNO01, c.IVNO10, b.IVCD17, b.IVCD18, b.IVCD19,
                   b.IVNO04
          for read only;

        // Open cursor
        exec sql open getitem_cursor;

        // Check for SQL errors on open
        if SQLCODE <> 0;
          // SQL error occurred
          exec sql close getitem_cursor;
          return returnItemDS;
        endif;

        // Fetch the first (and expected only) record
        exec sql
          fetch getitem_cursor into
            :returnItemDS.Company,
            :returnItemDS.Branch,
            :returnItemDS.Section,
            :returnItemDS.Group,
            :returnItemDS.Category,
            :returnItemDS.Product,
            :returnItemDS.Description,
            :returnItemDS.OnHand,
            :returnItemDS.WACUnitCost,
            :returnItemDS.ExtWACCost,
            :returnItemDS.MarketCost,
            :returnItemDS.ExtMarketCost,
            :returnItemDS.ReplacementCost,
            :returnItemDS.ExtReplacementCost,
            :returnItemDS.SubstituteCode,
            :returnItemDS.AssociatedCode,
            :returnItemDS.ComponentCode,
            :returnItemDS.DeleteCode,
            :returnItemDS.ChangedCode,
            :returnItemDS.StockingUOM,
            :returnItemDS.ItemWeight,
            :returnItemDS.LockedCode,
            :returnItemDS.ManufacturerNumber;

        // Check fetch results
        if SQLCODE = 0;
          // Record found successfully
          returnItemDS.Found = *on;
        elseif SQLCODE = 100;
          // No data found - this is normal, not an error
          returnItemDS.Found = *off;
        else;
          // Other SQL error
          returnItemDS.Found = *off;
        endif;

        // Close cursor
        exec sql close getitem_cursor;

        // Calculate sales data for last 3 months using single SQL with CASE
        // Using OECC08 (Century), OEYR08 (Year), OEMO08 (Month) for dates
        exec sql
          declare sales_cursor cursor for
          select OEQY03,
                 date(varchar(OECC08) concat varchar(OEYR08) concat '-' concat
                      right('0' concat varchar(OEMO08), 2)
                      concat '-01') as oeDate
          from OEPTOLY
          where IVNO07 = :inItem
            and OENO16 = :inBranch
            and OEQY03 > 0
            and date(varchar(OECC08) concat varchar(OEYR08) concat '-'
                     concat right('0' concat varchar(OEMO08), 2)
                     concat '-01') >= :month3Start
            and date(varchar(OECC08) concat varchar(OEYR08) concat '-'
                     concat right('0' concat varchar(OEMO08), 2)
                     concat '-01') < :currentDate;

        // Initialize monthly totals
        returnItemDS.Month1Sales = 0;
        returnItemDS.Month2Sales = 0;
        returnItemDS.Month3Sales = 0;

        // Open cursor and process records
        exec sql open sales_cursor;

        exec sql
          fetch sales_cursor into :salesCount, :oeDate;

        dow SQLCODE = 0;
          if oeDate >= month1Start and oeDate < currentDate;
            returnItemDS.Month1Sales += salesCount;
          elseif oeDate >= month2Start and oeDate < month1Start;
            returnItemDS.Month2Sales += salesCount;
          elseif oeDate >= month3Start and oeDate < month2Start;
            returnItemDS.Month3Sales += salesCount;
          endif;

          exec sql
            fetch sales_cursor into :salesCount, :oeDate;
        enddo;

        exec sql close sales_cursor;

        // Total last 3 months sales
        returnItemDS.Last3MonthsSales = returnItemDS.Month1Sales +
                                        returnItemDS.Month2Sales +
                                        returnItemDS.Month3Sales;

        // Get returns for this item/branch with 3-month date filter
        exec sql
          select coalesce(sum(abs(OEQY03)), 0) into :returnsCount
          from OEPTOLY
          where IVNO07 = :inItem
            and OENO16 = :inBranch
            and OEQY03 < 0
            and date(varchar(OECC08) concat varchar(OEYR08) concat '-'
                     concat right('0' concat varchar(OEMO08), 2)
                     concat '-01') >= :threeMonthsAgo
            and date(varchar(OECC08) concat varchar(OEYR08) concat '-'
                     concat right('0' concat varchar(OEMO08), 2)
                     concat '-01') < :currentDate;

        returnItemDS.Last3MonthsReturns = returnsCount;

        // Calculate average of the 3 monthly totals (safe division)
        if MONTHS_FOR_ANALYSIS > 0;
          returnItemDS.Last3MonthsAvg = returnItemDS.Last3MonthsSales
                                        / MONTHS_FOR_ANALYSIS;
        else;
          returnItemDS.Last3MonthsAvg = 0;
        endif;

        // Get previous year sales data with date filter
        exec sql
          select coalesce(sum(OEQY03), 0) into :salesCount
          from OEPTOLY
          where IVNO07 = :inItem
            and OENO16 = :inBranch
            and OEQY03 > 0
            and date(varchar(OECC08) concat varchar(OEYR08) concat '-'
                     concat right('0' concat varchar(OEMO08), 2)
                     concat '-01') >= :prevYearStart
            and date(varchar(OECC08) concat varchar(OEYR08) concat '-'
                     concat right('0' concat varchar(OEMO08), 2)
                     concat '-01') <= :prevYearEnd;

        returnItemDS.PrevYearSales = salesCount;

        // Get previous year returns data with date filter
        exec sql
          select coalesce(sum(abs(OEQY03)), 0) into :returnsCount
          from OEPTOLY
          where IVNO07 = :inItem
            and OENO16 = :inBranch
            and OEQY03 < 0
            and date(varchar(OECC08) concat varchar(OEYR08) concat '-'
                     concat right('0' concat varchar(OEMO08), 2)
                     concat '-01') >= :prevYearStart
            and date(varchar(OECC08) concat varchar(OEYR08) concat '-'
                     concat right('0' concat varchar(OEMO08), 2)
                     concat '-01') <= :prevYearEnd;

        returnItemDS.PrevYearReturns = returnsCount;

        // Calculate previous year monthly average (safe division)
        if PREV_YEAR_MONTHS > 0;
          returnItemDS.PrevYearAvg = returnItemDS.PrevYearSales
                                     / PREV_YEAR_MONTHS;
        else;
          returnItemDS.PrevYearAvg = 0;
        endif;

        // Get open purchase orders for this item/branch
        returnItemDS.POCount = 0;
        poIndex = 0;

        exec sql
          declare po_cursor cursor for
          select hdr.pocd20,
                 date(digits(hdr.pocc14) || digits(hdr.poyr14) || '-' ||
                      digits(hdr.pomo14) || '-' || digits(hdr.pody14)),
                 dtl.PONO01, dtl.pono05, dtl.poqy01
          from POPTOH hdr
          join POPTOL dtl on hdr.PONO01 = dtl.PONO01
          where dtl.ivno07 = :inItem
            and hdr.PONO02 = :inBranch
            and hdr.pocd20 <> 'C' and dtl.poqy01 <> dtl.poqy03
          order by date(digits(hdr.pocc14) || digits(hdr.poyr14) || '-'
                        || digits(hdr.pomo14) || '-' || digits(hdr.pody14)) asc;

        exec sql open po_cursor;

        exec sql
          fetch po_cursor into :currentPO.Status, :currentPO.ETADate,
                               :currentPO.PONumber, :currentPO.POLine,
                               :currentPO.Quantity;

        dow SQLCODE = 0 and poIndex < MAX_PO_RECORDS;
          poIndex += 1;
          returnItemDS.OpenPOs(poIndex) = currentPO;
          returnItemDS.POCount = poIndex;

          exec sql
            fetch po_cursor into :currentPO.Status, :currentPO.ETADate,
                                 :currentPO.PONumber, :currentPO.POLine,
                                 :currentPO.Quantity;
        enddo;

        exec sql close po_cursor;

        // Return the result
        return returnItemDS;

       end-proc GETITEM;

