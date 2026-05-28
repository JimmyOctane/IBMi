          ctl-opt option(*srcstmt:*nodebugio) datfmt(*iso);
          ctl-opt bnddir('ECBIND');

          //-----------------------------------------------------------
          // Data Structures
          //-----------------------------------------------------------
          //-----------------------------------------------------------
          // Local Variables
          //-----------------------------------------------------------

          // Counter for line items
          dcl-s itemNumber packed(6:0) inz(0);
          Dcl-S productUrl Varchar(500);
          //-----------------------------------------------------------
          // Query 1: Extract Order Header Information from XML
          //-----------------------------------------------------------

          *inlr = *on;

            // Example 1: Call procedure with a specific item number
          itemNumber = 5853;

          Exec Sql
            CALL jamiedev.GET_PRODUCT_URL(:itemNumber, :productUrl);







