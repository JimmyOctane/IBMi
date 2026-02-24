      //*******************************************************************
      // GENTMPID_CP - Copy Member for GENTMPID Service Program
      //
      // Purpose: Contains data structure definitions and prototypes
      //          for the GENTMPID (Generate Temporary Product ID)
      //          service program
      //
      // Author: System Generated
      // Date: 2026-02-23
      // Version: 1.0
      //
      // Valid Category Codes:
      //   PDF - Pipe, Duct and Fittings
      //   REG - Registers, Grills
      //   PTS - Parts (all equipment: Goodman, Amana, Nordyne, etc.)
      //   EQP - Equipment (all brands)
      //   STL - Steel sheets, rolls and coils
      //   FIL - Filters
      //   TOO - Tools
      //   ACC - Access doors
      //   FIR - Fire and Radiation dampers
      //   EAC - Equipment Accessories (pads, thermostats, etc.)
      //   INS - Insulation (OC and JM wrap, liner, etc.)
      //   FLX - Flex
      //   RFG - Roofing Products
      //   MSC - Miscellaneous
      //
      //*******************************************************************

      // Input parameters structure for generating temporary product ID
      dcl-ds gentmpidInput_t qualified template;
        Category          char(3);               // Category code
        SequenceNumber    packed(3:0);           // Sequence number
      end-ds;

      // Return data structure for GENTMPID
      dcl-ds gentmpidReturn_t qualified template;
        ProductID         char(15);              // Generated product ID
        Success           ind;                   // Success indicator
        ErrorMessage      char(50);              // Error message
      end-ds;

      // Procedure prototype for GENTMPID
      dcl-pr GENTMPID likeds(gentmpidReturn_t);
        input likeds(gentmpidInput_t) const;
      end-pr;

