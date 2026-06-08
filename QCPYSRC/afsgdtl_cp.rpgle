     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - AFSGDTL_CP                                             *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D AFS - Get Shipment Details on AFS                                     *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S                                                                       *
     F*S SPECIAL NOTES: This is copy Book for adding to ease adding to program *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*M ----------------------------------------------------------------------*
        // Get Shipment Details
        dcl-pr  AFS_GetShipmentDetails ind;
         pUniqueID packed(15:0);
         pShipmentID Char(10) Const;
         //pConfigDS LikeDS(AFS_ConfigDS_5) Const;
        end-pr;

            Dcl-Ds AFS_ConfigDS_5 Qualified Template Inz;
              Username VarChar(128);
              Password VarChar(128);
              BaseAPIPath Like(RXS_Var1Kv_t);
              LogPath Like(RXS_Var1Kv_t);
              CreateLogFile Ind Inz(*Off);
              ClientID VarChar(128);
              ClientSecret VarChar(128);
            End-Ds;


