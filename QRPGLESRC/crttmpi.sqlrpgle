        // Control Options
         Ctl-Opt NoMain;                         // Service program (no main)
         Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
         Ctl-Opt BndDir('QC2LE');                // Bind to C runtime library
         Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
         Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
         Ctl-Opt Copyright('East Coast Metals - Return Item Information');


      //*******************************************************************
      // CRTTMPI - Create Temporary Item Service Program
      //
      // Purpose: Creates a verified temporary item in inventory
      //
      // Parameters:
      //   input - crttmpiInput_t structure containing:
      //     ItemNumber    - Product identifier (IVNO04)
      //     Description   - Item description (IVDN01)
      //     VendorNumber  - Vendor/supplier number (APNO01)
      //     Section       - Product section (IVCD17) - optional
      //     Group         - Product group (IVCD18) - optional
      //     Category      - Product category (IVCD19) - optional
      //     ShipBranch    - Shipping branch (IVNO10)
      //
      // Returns: crttmpiReturn_t structure containing:
      //   NewItemNumber - The new IVNO07 created
      //   Success       - Success indicator
      //   ErrorMessage  - Error message if failed
      //
      // Tables Used:
      //   IVPMSTR - Item Master (output)
      //   IVPMUOM - Item Unit of Measure (output)
      //   IVPMRNS - Item RNS (output)
      //   IVLMWHC4 - Warehouse (input/update)
      //
      // Author: System Generated
      // Date: 2026-02-23
      // Version: 2.0
      //
      // Modification History:
      //   Date       Author      Description
      //   ---------- ----------- ----------------------------------------
      //   2026-02-23 Conversion  Converted to NOMAIN service program
      //
      //*******************************************************************

      // Copy members for data structures and prototypes
      /copy qcpysrc,CRTTMPI_CP
      /copy qcpysrc,GENTMPP_CP


       // Program Status Data Structure (PSDS)
       dcl-ds ProgramStatus psds qualified;
         ProgramName     char(10)    pos(1);
         StatusCode      char(5)     pos(21);
         ProcedureName   char(10)    pos(31);
         ExceptionType   char(2)     pos(40);
         ExceptionNumber char(4)     pos(43);
         JobName         char(10)    pos(244);
         UserName        char(10)    pos(254);
         JobNumber       char(6)     pos(264);
       end-ds;

      //*********************************************************
      // CRTTMPI - External Procedure
      //*********************************************************
      // CreateTemporaryItem - External Procedure
      //*********************************************************
       dcl-proc CreateTemporaryItem export;

       dcl-pi CreateTemporaryItem likeds(crttmpiReturn_t);
         input likeds(crttmpiInput_t) const;
       end-pi;

       // External procedure prototypes
       dcl-pr GetItem extpgm('IVR9310');
         itemNum packed(6:0);
       end-pr;


       // Named constants
       dcl-c DFT_UOM 'EA';
       dcl-c DFT_FCT 1;

       // Local variables
       dcl-s itemNumber packed(6:0);
       dcl-s myItemNumber packed(6:0);
       dcl-s w_ivcd08 char(1);
       dcl-s myMonth packed(2:0);
       dcl-s myDay packed(2:0);
       dcl-s myYear packed(2:0);
       dcl-s myCentury packed(2:0);
       dcl-s sqlProductNumber char(17);
       dcl-s sqlDescription char(48);
       dcl-s sqlVendorNumber packed(6:0);
       dcl-s sqlShipBranch packed(3:0);
       dcl-s sqlSection char(3);
       dcl-s sqlGroup char(3);
       dcl-s sqlCategory char(3);
       dcl-s sqlPurchCode char(1);
       dcl-s sqlUOM char(2);
       dcl-s sqlFactor packed(14:9);
       dcl-s sqlPgmName char(10);
       dcl-s wrhsExists ind;
       dcl-ds returnData likeds(crttmpiReturn_t);
       dcl-ds gentmppInput likeds(GENTMPPInput_t);
       dcl-ds gentmppResult likeds(GENTMPPReturn_t);
       dcl-ds pdata2_ds;
         pdata2 char(256) pos(1);
         itm# packed(6:0) pos(1);
       end-ds;

       // Initialize return structure
       clear returnData;
       returnData.Success = *off;
       returnData.NewItemNumber = 0;
       returnData.ErrorMessage = '';

       // Get current date components
       myMonth = %dec(%subdt(%date():*MONTHS));
       myDay = %dec(%subdt(%date():*DAYS));
       myYear = %dec(%subdt(%date():*YEARS)) - 2000;
       myCentury = 20;

       // Validate input
       if input.Description = '';
         returnData.ErrorMessage = 'Description required';
         return returnData;
       endif;
       
       // Validate Category if ItemNumber is blank (needed for generation)
       if input.ItemNumber = '' and input.Category = '';
         returnData.ErrorMessage = 'Category required when ItemNumber is blank';
         return returnData;
       endif;

       // Get next item number
       itemNumber = 0;
       dow itemNumber = 0;
         callp GetItem(itemNumber);  // Retrieve next item number
       enddo;

       if itemNumber <> 0;
         // Generate temporary product ID if not provided
         if input.ItemNumber = '';
           clear gentmppInput;
           gentmppInput.Category = input.Category;
           
           gentmppResult = generateTemporaryProduct(gentmppInput);
           
           if gentmppResult.Success;
             sqlProductNumber = gentmppResult.ProductID;
           else;
             returnData.Success = *off;
             returnData.ErrorMessage = 'Error generating product ID';
             return returnData;
           endif;
         else;
           sqlProductNumber = input.ItemNumber;
         endif;
         
         // Copy input to SQL variables
         sqlDescription = input.Description;
         sqlVendorNumber = input.VendorNumber;
         sqlShipBranch = input.ShipBranch;
         sqlUOM = DFT_UOM;
         sqlFactor = DFT_FCT;
         sqlPgmName = ProgramStatus.ProgramName;

         // Set section/group/category
         if input.Section <> ' ';
           sqlSection = input.Section;
           sqlGroup = input.Group;
           sqlCategory = input.Category;
           sqlPurchCode = 'Y';
         else;
           sqlSection = ' ';
           sqlGroup = ' ';
           sqlCategory = ' ';
           sqlPurchCode = 'N';
         endif;

         // Insert into IVPMSTR (Item Master)
         exec sql
           INSERT INTO IVPMSTR
             (IVNO07, IVNO04, IVNO05, IVCDC8, IVCD21, IVCD22,
              IVCD23, IVCD24, IVCD27, IVCD31, IVCD32, IVCD17,
              IVCD18, IVCD19, IVCD36, IVCD56, IVDN01, IVDN20,
              IVCDIN, IVNM01, IVMO01, IVDY01, IVCC01, IVYR01)
           VALUES
             (:itemNumber, :sqlProductNumber, :sqlVendorNumber,
              'V', 'Y', 'N', 'N', 'N', 'N', 'N', :sqlPurchCode,
              :sqlSection, :sqlGroup, :sqlCategory, 'N', 'N',
              :sqlDescription, :sqlUOM, 'Y',
              :sqlPgmName, :myMonth, :myDay,
              :myCentury, :myYear);

         if SQLCODE < 0;
           returnData.Success = *off;
           returnData.ErrorMessage = 'Error inserting item master';
           return returnData;
         endif;

         // Insert Pricing UOM
         exec sql
           INSERT INTO IVPMUOM
             (IVNO07, IVQY12, IVDN21, IVCD08, IVCD91, IVNO69)
           VALUES
             (:itemNumber, :sqlFactor, :sqlUOM, 'P', 'Y', 1);

         // Insert Purchasing UOM
         exec sql
           INSERT INTO IVPMUOM
             (IVNO07, IVQY12, IVDN21, IVCD08, IVCD91, IVNO69)
           VALUES
             (:itemNumber, :sqlFactor, :sqlUOM, 'B', 'Y', 1);

         // Insert Order entry UOM
         exec sql
           INSERT INTO IVPMUOM
             (IVNO07, IVQY12, IVDN21, IVCD08, IVCD91, IVNO69)
           VALUES
             (:itemNumber, :sqlFactor, :sqlUOM, 'O', 'Y', 1);

         // Check if warehouse record exists for this item
         wrhsExists = *off;
         exec sql
           SELECT '1' INTO :wrhsExists
           FROM IVLMWHC4
           WHERE IVNO07 = :itemNumber
             AND IVCD08 = 'S'
           FETCH FIRST 1 ROW ONLY;

         // Warehouse record check (SendWM call removed)
         // if SQLCODE = 100 or not wrhsExists;
         //   // Previously sent WM message here
         // endif;

         // Insert into IVPMRNS (Item RNS)
         exec sql
           INSERT INTO IVPMRNS
             (IVNO07, IVNO10, IVMO04, IVDY04, IVCC04, IVYR04)
           VALUES
             (:itemNumber, :sqlShipBranch, :myMonth, :myDay,
              :myCentury, :myYear);

         // Success - set return values
         returnData.Success = *on;
         returnData.NewItemNumber = itemNumber;
         returnData.ErrorMessage = '';
       else;
         returnData.Success = *off;
         returnData.NewItemNumber = 0;
         returnData.ErrorMessage = 'Error processing product ' +
                                   input.ItemNumber;
       endif;

       return returnData;

       end-proc CreateTemporaryItem;

