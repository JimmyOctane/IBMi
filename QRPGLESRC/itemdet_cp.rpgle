     F*------------------------------------------------------------------*
     F*N PROGRAM NAME - ITEMDET                                         *
     F*------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                    *
     F*------------------------------------------------------------------*
     F*D Item detail information retrieval service                      *
     F*------------------------------------------------------------------*
     F*S PURPOSE:                                                        *
     F*S    Item Detail Information Service                             *
     F*S                                                                 *
     F*S SPECIAL NOTES:                                                 *
     F*S                                                                 *
     F*M ----------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                              *
     F*M ---------- ------ --- -----------------------------------------*
     F*V JJF   3182 012026 JJF created program                          *
     F*M ----------------------------------------------------------------*
        // Item Detail Information Service
        dcl-pr getItemDetails likeds(ItemDetailDS);
         pItemDS likeds(ItemDetailDS) const;
        end-pr;

            dcl-ds ItemDetailDS qualified;
             // Input parameters
             inItemNumber       char(15);    // Input item number
             inBranch           char(3);     // Input branch code
             
             // Item Master Information (IVPMSTR)
             outItemNumber      char(15);    // Item number
             outItemDesc        char(30);    // Item description
             outItemType        char(10);    // Item type
             outUnitOfMeasure   char(3);     // Unit of measure
             outItemClass       char(10);    // Item class
             outStatus          char(1);     // Item status
             outListPrice       packed(11:2); // List price
             outCost            packed(11:2); // Item cost
             outWeight          packed(9:3);  // Item weight
             outCreateDate      date;         // Item creation date
             outLastUpdateDate  date;         // Last update date
             
             // Branch Item Information (IVPMSBR)
             outBranchCode      char(3);     // Branch code
             outOnHandQty       packed(11:3); // On hand quantity
             outCommittedQty    packed(11:3); // Committed quantity
             outAvailableQty    packed(11:3); // Available quantity
             outReorderPoint    packed(11:3); // Reorder point
             outReorderQty      packed(11:3); // Reorder quantity
             outLastReceiptDate date;         // Last receipt date
             outLastIssueDate   date;         // Last issue date
             outBranchStatus    char(1);     // Branch status
             
             // Sales History Information (OEPTOLY)
             outSales30Days     packed(11:2); // Sales last 30 days
             outSales60Days     packed(11:2); // Sales last 60 days
             outSales90Days     packed(11:2); // Sales last 90 days
             outQtySold30Days   packed(11:3); // Qty sold last 30 days
             outQtySold60Days   packed(11:3); // Qty sold last 60 days
             outQtySold90Days   packed(11:3); // Qty sold last 90 days
             outAvgSalePrice30  packed(11:2); // Avg sale price 30 days
             outAvgSalePrice60  packed(11:2); // Avg sale price 60 days
             outAvgSalePrice90  packed(11:2); // Avg sale price 90 days
             outLastSaleDate    date;         // Last sale date
             
             // Control and Error Information
             errorCode          char(3);     // Error code
             errorMessage       char(80);    // Error message
             recordsFound       char(1);     // Records found flag
            end-ds;