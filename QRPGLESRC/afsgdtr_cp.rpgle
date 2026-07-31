     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - AFSGDTR_CP                                             *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D AFS - Get Shipment Details by Ref Number on AFS                       *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S                                                                       *
     F*S SPECIAL NOTES: This is copy Book for adding to ease adding to program *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*M ----------------------------------------------------------------------*
        // Get Shipment Details by Ref Number
        dcl-pr  AFS_GetShipmentDetailsByReference char(8000);
         pRefNumber Char(20) Const;
        end-pr;

        dcl-ds AFS_ReturnDS qualified;
         uniqueID zoned(15:0);
         unique_Character char(15) overlay(uniqueID);
         return_error char(1) inz('0');
        end-ds;



