        Ctl-Opt NoMain BndDir('RXSBND':'ECBIND') ExtBinInt(*Yes) DecEdit('0.')
        Option(*NoDebugIO) Text('AFS APIs');
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - AFSGDTL                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D AFS - Get Shipment Details on AFS                                     *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*M JF003180   110626 JJF [     ] USE DECIMAL FIELDS FOR NUMERIC VALUES   *
     F*M ----------------------------------------------------------------------*

       /COPY QRPGLECPY,RXSCB
       /COPY QCPYSRC,AFSTOKN_CP
       /COPY QCPYSRC,AFSGDTL_CP
       /COPY QCPYSRC,AFSUQID_CP

       Dcl-S AFS_UniqueID_t Packed(15:0) Template;
       Dcl-S gUniqueID Like(AFS_UniqueID_t);
       Dcl-S gLoginToken Like(RXS_Var4Kv_t);
       Dcl-S gShipmentID Char(10);



       dcl-s AFS_API_BASE_PATH varchar(100) inz;
       // IFS path where log files will be generated
       dcl-c AFS_LOG_PATH '/tmp';
       dcl-s AFS_USERNAME varchar(100) inz;
       dcl-s AFS_PASSWORD varchar(100) inz;
       dcl-s AFS_CLIENT_ID varchar(100) inz;
       dcl-s AFS_CLIENT_SECRET varchar(100) inz;
       dcl-s emailAddress varchar(50) inz;
       dcl-s oepmgtky1 char(3) inz;
       dcl-s oepmgtky2 char(2) inz;
       dcl-s oepmgtky3 char(1) inz;
       dcl-s pruserid char(10) inz;
       dcl-s prUserEmail char(45) inz;
       dcl-s prodTest char(10) inz;

       Dcl-S UniqueID Packed(15:0);
       Dcl-Ds ConfigDS LikeDS(AFS_ConfigDS_5) Inz(*LikeDS);

       Dcl-Ds GetUniqueIDds Qualified Inz;
        Username VarChar(128);
        Password VarChar(128);
        BaseAPIPath Like(RXS_Var1Kv_t);
        LogPath Like(RXS_Var1Kv_t);
        CreateLogFile Ind Inz(*Off);
       End-Ds;

       // Retrieve UserID
       dcl-pr ECC9996 EXTPGM('ECC9996');
        p_UserID  Char(10);
       end-pr;

       // Retrieve User Email
       dcl-pr ECC9997 EXTPGM('ECC9997');
        p_UserID    Char(10);
        p_UserEmail Char(45);
       end-pr;


      //***********************************************************/
      // Main Procedure                                           */
      //***********************************************************/
       Dcl-Proc AFS_GetShipmentDetails Export;

        Dcl-Pi *N Ind;
        pUniqueID packed(15:0);
        pShipmentID Char(10) Const;
        End-Pi;

        Dcl-Ds TransmitDS LikeDS(RXS_TransmitDS_t);

        Dcl-Ds ParseJsonDS LikeDS(RXS_ParseJsonDS_t);

        Dcl-S ResponseJson Like(RXS_Var64Kv_t);

        monitor;
        exsr init;
        exsr transmit;
        exsr parse;
        exsr cleanup;

        on-error;
        exsr cleanup;
        return *Off;
        endmon;

        return *On;

        //---------------------------------------------//
        //                                             //
        //---------------------------------------------//

        begsr init;

        reset gUniqueID;
        reset gLoginToken;

        // pull in production or test dataarea
        reset prodTest;
        exec sql
         select data_area_value
         into :prodTest
         from qsys2.data_area_info
          WHERE data_area_name = 'PRODTEST' and
          data_area_library = 'QGPL';

        ECC9996 (prUserId);
        ECC9997 (prUserId:prUserEmail);

        // set keys to grab credentials and URL's
        reset oepmgtky1;
        oepmgtky1 = 'AFS';
        oepmgtky2 = '02';
        reset oepmgtky3;
        if prodTest = 'TEST';
        oepmgtKy3 = 'T';
        emailAddress = prUserEmail;
        else;
        oepmgtKy3 = 'P';
        emailAddress = 'itdept@ecmdi.com';
        endif;

        // TODO Retrieve values
        // user name and password
         exec sql
         select MG03US, MG03PW
         into :AFS_USERNAME , :AFS_PASSWORD
         from OEPMGT03
         where MG03CH = :oepmgtky1 and
               MG03VS = :oepmgtky2 and
               MG03EV = :oepmgtky3;

        // Grab the URL
        reset AFS_API_BASE_PATH;
        exec sql
        select MG06LS
        into :AFS_API_BASE_PATH
        from OEPMGT06
        where MG06CH = :oepmgtky1 and
              MG06VS = :oepmgtky2 and
              MG06EV = :oepmgtky3;

        // NOTE: THIS API REQUIRES CLIENT_ID AND CLIENT_SECRET
        //  IN ADDITION TO USERNAME/PASSWORD
        // client ID Client Secret
        oepmgtky2 = '02';
        exec sql
        select MG03US, MG03PW
        into :AFS_CLIENT_ID, :AFS_CLIENT_SECRET
        from OEPMGT03
        where MG03CH = :oepmgtky1 and
              MG03VS = :oepmgtky2 and
              MG03EV = :oepmgtky3;

        reset ConfigDS;
        ConfigDS.Username = AFS_USERNAME;
        ConfigDS.Password = AFS_PASSWORD;
        ConfigDS.BaseAPIPath = AFS_API_BASE_PATH;
        ConfigDS.LogPath = AFS_LOG_PATH;
        ConfigDS.CreateLogFile = *On;
        ConfigDS.ClientID = AFS_CLIENT_ID;
        ConfigDS.ClientSecret = AFS_CLIENT_SECRET;

        // grab unique ID
        UniqueID = AFS_GetUniqueID();
        pUniqueID = UniqueID;
        gUniqueID = UniqueID;

        gShipmentID = pShipmentID;

        if gShipmentID = *Blanks;
          RXS_JobLog( 'ERROR: No shipment ID provided' );
          exsr cleanup;
          return *Off;
        endif;

        // get login token
        GetUniqueIDds.Username = AFS_USERNAME;
        GetUniqueIDds.Password = AFS_PASSWORD;
        GetUniqueIDds.BaseAPIPath = AFS_API_BASE_PATH;
        GetUniqueIDds.LogPath = AFS_LOG_PATH;
        GetUniqueIDds.CreateLogFile = *on;

        gLoginToken = %Trim( AFS_GetLoginToken(gUniqueID:GetUniqueIDds) );


        endsr;

        //*************************************
        // Call API and receive data back
        //*************************************
        begsr transmit;
          RXS_ResetDS( TransmitDS : RXS_DS_TYPE_TRANSMIT );

          TransmitDS.URI=%TrimR(ConfigDS.BaseAPIPath:' /')
                        +'/shipments/'
                        +%Trim(gShipmentID);

          TransmitDS.HTTPMethod = RXS_HTTP_METHOD_GET;

          TransmitDS.SSLVerifyPeer = RXS_NO;
          TransmitDS.SSLVerifyHost = RXS_NO;

          TransmitDS.HeaderAuthScheme = RXS_HTTP_AUTH_SCHEME_BEARER;
          TransmitDS.HeaderAuthCredentials = gLoginToken;

          TransmitDS.HeaderContentType = 'application/json';

          TransmitDS.CustomHeaderName(1) = 'client_id';
          TransmitDS.CustomHeaderValue(1) = %Trim(ConfigDS.ClientID);
          TransmitDS.CustomHeaderName(2) = 'client_secret';
          TransmitDS.CustomHeaderValue(2) = %Trim(ConfigDS.ClientSecret);

          if ConfigDS.CreateLogFile;
            //TransmitDS.LogFile = %TrimR( pConfigDS.LogPath : ' /' )
            //     + '/afs_getdetails_' + %Char(pUniqueID) + '.txt';
            TransmitDS.LogFile = %TrimR( ConfigDS.LogPath : ' /' )
                + '/afs_getdetails_' + %Char(gUniqueID) + '.txt';
          endif;

          ResponseJson = RXS_Transmit( *Omit : TransmitDS );
        endsr;

        begsr parse;
          RXS_ResetDS( ParseJsonDS : RXS_DS_TYPE_PARSEJSON );
          ParseJsonDS.Handler = %PAddr( GetShipmentDetails_JsonHandler );

          RXS_ParseJson( ResponseJson : ParseJsonDS );
        endsr;

        begsr parseError;
          RXS_ResetDS( ParseJsonDS : RXS_DS_TYPE_PARSEJSON );
          ParseJsonDS.Handler = %PAddr( Error_JsonHandler );

          RXS_ParseJson( ResponseJson : ParseJsonDS );
        endsr;

        begsr cleanup;
        endsr;

       End-Proc;


       Dcl-Proc GetShipmentDetails_JsonHandler;
         Dcl-Pi *N Ind;
           pType Int(5) Const;
           pPath Like(RXS_Var64Kv_t) Const;
           pIndex Uns(10) Const;
           pData Pointer Const;
           pDataLen Uns(10) Const;
         End-Pi;

        Dcl-F AFSDRSP Disk Usage(*Output) Keyed
         UsrOpn Qualified Alias Static;
        Dcl-F AFSDRSPAS Disk Usage(*Output) Keyed
         UsrOpn Qualified Alias Static;
        Dcl-F AFSDRSPCN Disk Usage(*Output) Keyed
         UsrOpn Qualified Alias Static;
        Dcl-F AFSDRSPET Disk Usage(*Output) Keyed
         UsrOpn Qualified Alias Static;
        Dcl-F AFSDRSPPC Disk Usage(*Output) Keyed
         UsrOpn Qualified Alias Static;
        Dcl-F AFSDRSPRF Disk Usage(*Output) Keyed
         UsrOpn Qualified Alias Static;
        Dcl-F AFSDRSPST Disk Usage(*Output) Keyed
         UsrOpn Qualified Alias Static;

        Dcl-Ds RSP LikeRec(AFSDRSP.RAFSDRSP:*All) Static Inz;
        Dcl-Ds RSPAS LikeRec(AFSDRSPAS.RAFSDRSPAS:*All) Static Inz;
        Dcl-Ds RSPCN LikeRec(AFSDRSPCN.RAFSDRSPCN:*All) Static Inz;
        Dcl-Ds RSPET LikeRec(AFSDRSPET.RAFSDRSPET:*All) Static Inz;
        Dcl-Ds RSPPC LikeRec(AFSDRSPPC.RAFSDRSPPC:*All) Static Inz;
        Dcl-Ds RSPRF LikeRec(AFSDRSPRF.RAFSDRSPRF:*All) Static Inz;
        Dcl-Ds RSPST LikeRec(AFSDRSPST.RAFSDRSPST:*All) Static Inz;

        Dcl-S ParsedData Like(RXS_Var1Kv_t);

        monitor;

        if pType = RXS_JSON_STRING and pData <> *Null;
          ParsedData = RXS_STR( pData : pDataLen );
        endif;

        select;

          when pPath = '/data'
           and pType = RXS_JSON_OBJECT;
            reset RSP;
            RSP.UniqueID = gUniqueID;
            RSP.ResponseTimestamp = %Timestamp();

            if not %Open(AFSDRSP);
              open AFSDRSP;
            endif;

          when pPath = '/data/id'
           and pType = RXS_JSON_STRING;
            RSP.ShipmentID = ParsedData;

          when pPath = '/data/scac'
           and pType = RXS_JSON_STRING;
            RSP.CarrierSCAC = ParsedData;

          when pPath = '/data/carrierName'
           and pType = RXS_JSON_STRING;
            RSP.CarrierName = ParsedData;

          when pPath = '/data/status'
           and pType = RXS_JSON_STRING;
            RSP.Status = ParsedData;

          when pPath = '/data/entityType'
           and pType = RXS_JSON_STRING;
            RSP.EntityType = ParsedData;

          when pPath = '/data/origCity'
           and pType = RXS_JSON_STRING;
            RSP.OriginCity = ParsedData;

          when pPath = '/data/origStateAbbr'
           and pType = RXS_JSON_STRING;
            RSP.OriginState = ParsedData;

          when pPath = '/data/origZip'
           and pType = RXS_JSON_STRING;
            RSP.OriginPostalCode = ParsedData;

          when pPath = '/data/origCountry'
           and pType = RXS_JSON_STRING;
            RSP.OriginCountry = ParsedData;

          when pPath = '/data/origAddress1'
           and pType = RXS_JSON_STRING;
            RSP.OriginAddress1 = ParsedData;

          when pPath = '/data/origCompany'
           and pType = RXS_JSON_STRING;
            RSP.OriginCompany = ParsedData;

          when pPath = '/data/destCity'
           and pType = RXS_JSON_STRING;
            RSP.DestinationCity = ParsedData;

          when pPath = '/data/destStateAbbr'
           and pType = RXS_JSON_STRING;
            RSP.DestinationState = ParsedData;

          when pPath = '/data/destZip'
           and pType = RXS_JSON_STRING;
            RSP.DestinationPostalCode = ParsedData;

          when pPath = '/data/destCountry'
           and pType = RXS_JSON_STRING;
            RSP.DestinationCountry = ParsedData;

          when pPath = '/data/destAddress1'
           and pType = RXS_JSON_STRING;
            RSP.DestinationAddress1 = ParsedData;

          when pPath = '/data/destCompany'
           and pType = RXS_JSON_STRING;
            RSP.DestinationCompany = ParsedData;

          when pPath = '/data/estDeliveryDate'
           and pType = RXS_JSON_STRING;
            RSP.EstDeliveryDate = ParsedData;

          when pPath = '/data/estPickupDate'
           and pType = RXS_JSON_STRING;
            RSP.EstPickupDate = ParsedData;

          when pPath = '/data/proNumber'
           and pType = RXS_JSON_STRING;
            RSP.ProNumber = ParsedData;

          when pPath = '/data/totalWeight'
           and pType = RXS_JSON_STRING;
            monitor;
              RSP.TotalWeight = %Dec( ParsedData : 15 : 2 );
            on-error;
              RSP.TotalWeight = 0;
            endmon;

          when pPath = '/data/revenue'
           and pType = RXS_JSON_STRING;
            monitor;
              RSP.Revenue = %Dec( ParsedData : 15 : 2 );
            on-error;
              RSP.Revenue = 0;
            endmon;

          when pPath = '/data/stopsCount'
           and pType = RXS_JSON_STRING;
            monitor;
              RSP.StopsCount = %Dec( ParsedData : 5 : 0 );
            on-error;
              RSP.StopsCount = 0;
            endmon;

          when pPath = '/data/transitDays'
           and pType = RXS_JSON_STRING;
            monitor;
              RSP.TransitDays = %Dec( ParsedData : 5 : 0 );
            on-error;
              RSP.TransitDays = 0;
            endmon;

          when pPath = '/data/serviceTypeDesc'
           and pType = RXS_JSON_STRING;
            RSP.ServiceTypeDesc = ParsedData;

          when pPath = '/data/deliveryDate'
           and pType = RXS_JSON_STRING;
            RSP.DeliveryDate = ParsedData;

          when pPath = '/data/pickupDate'
           and pType = RXS_JSON_STRING;
            RSP.PickupDate = ParsedData;

          when pPath = '/data/originalCreatedDate'
           and pType = RXS_JSON_STRING;
            RSP.OriginalCreatedDate = ParsedData;

          when pPath = '/data/userId'
           and pType = RXS_JSON_STRING;
            RSP.UserID = ParsedData;

          when pPath = '/data/userName'
           and pType = RXS_JSON_STRING;
            RSP.UserName = ParsedData;

          when pPath = '/data/accountId'
           and pType = RXS_JSON_STRING;
            RSP.AccountID = ParsedData;

          when pPath = '/data/accountName'
           and pType = RXS_JSON_STRING;
            RSP.AccountName = ParsedData;

          when pPath = '/data/totalCube'
           and pType = RXS_JSON_STRING;
            monitor;
              RSP.TotalCube = %Dec( ParsedData : 15 : 2 );
            on-error;
              RSP.TotalCube = 0;
            endmon;

          when pPath = '/data/createdDateTime'
           and pType = RXS_JSON_STRING;
            RSP.CreatedDateTime = ParsedData;

          when pPath = '/data/isDeleted'
           and pType = RXS_JSON_STRING;
            if ParsedData = 'true';
              RSP.IsDeleted = *On;
            elseif ParsedData = 'false';
              RSP.IsDeleted = *Off;
            endif;

          when pPath = '/data/totalCost'
           and pType = RXS_JSON_STRING;
            monitor;
              RSP.TotalCost = %Dec( ParsedData : 15 : 2 );
            on-error;
              RSP.TotalCost = 0;
            endmon;

          when pPath = '/data/carrierId'
           and pType = RXS_JSON_STRING;
            RSP.CarrierID = ParsedData;

          when pPath = '/data/serviceTypeId'
           and pType = RXS_JSON_STRING;
            RSP.ServiceTypeID = ParsedData;

          when pPath = '/data/serviceIncidents'
           and pType = RXS_JSON_STRING;
            RSP.ServiceIncidents = ParsedData;

          when pPath = '/data/isMerged'
           and pType = RXS_JSON_STRING;
            if ParsedData = 'true';
              RSP.IsMerged = *On;
            elseif ParsedData = 'false';
              RSP.IsMerged = *Off;
            endif;

          when pPath = '/data/isMerged'
           and pType = RXS_JSON_STRING;
            RSP.PublicComments = ParsedData;

          when pPath = '/data/freightChargesTermDesc'
           and pType = RXS_JSON_STRING;
            RSP.FreightChargesTermDesc = ParsedData;

          when pPath = '/data/freightChargesTermId'
           and pType = RXS_JSON_STRING;
            RSP.FreightChargesTermID = ParsedData;

          when pPath = '/data/billCompany'
           and pType = RXS_JSON_STRING;
            RSP.BillCompany = ParsedData;

          when pPath = '/data/billContact'
           and pType = RXS_JSON_STRING;
            RSP.BillContactName = ParsedData;

          when pPath = '/data/billEmail'
           and pType = RXS_JSON_STRING;
            RSP.BillEmail = ParsedData;

          when pPath = '/data/billAddress1'
           and pType = RXS_JSON_STRING;
            RSP.BillAddress1 = ParsedData;

          when pPath = '/data/billCity'
           and pType = RXS_JSON_STRING;
            RSP.BillCity = ParsedData;

          when pPath = '/data/billState'
           and pType = RXS_JSON_STRING;
            RSP.BillState = ParsedData;

          when pPath = '/data/billPostalCode'
           and pType = RXS_JSON_STRING;
            RSP.BillPostalCode = ParsedData;

          when pPath = '/data/billPhone'
           and pType = RXS_JSON_STRING;
            RSP.BillPhone = ParsedData;

          when pPath = '/data/billCountry'
           and pType = RXS_JSON_STRING;
            RSP.BillCountry = ParsedData;

          when pPath = '/data/notifications'
           and pType = RXS_JSON_STRING;
            RSP.Notifications = ParsedData;

          when pPath = '/data/currency'
           and pType = RXS_JSON_STRING;
            RSP.Currency = ParsedData;

          when pPath = '/data/pieces[*]'
           and pType = RXS_JSON_ARRAY;

           if not %Open(AFSDRSPPC);
             open AFSDRSPPC;
           endif;

          when pPath = '/data/pieces[*]'
           and pType = RXS_JSON_OBJECT;
            reset RSPPC;
            RSPPC.UniqueID = RSP.UniqueID;
            RSPPC.ShipmentID = RSP.ShipmentID;

          when pPath = '/data/pieces[*]/id'
           and pType = RXS_JSON_STRING;
            monitor;
              RSPPC.PieceID = %Int( ParsedData );
            on-error;
              // TODO error
              RSPPC.PieceID = 0;
            endmon;

          when pPath = '/data/pieces[*]/pieces'
           and pType = RXS_JSON_STRING;
            RSPPC.Pieces = ParsedData;

          when pPath = '/data/pieces[*]/height'
           and pType = RXS_JSON_STRING;
            RSPPC.Height = ParsedData;

          when pPath = '/data/pieces[*]/width'
           and pType = RXS_JSON_STRING;
            RSPPC.Width = ParsedData;

          when pPath = '/data/pieces[*]/length'
           and pType = RXS_JSON_STRING;
            RSPPC.Length = ParsedData;

          when pPath = '/data/pieces[*]/weight'
           and pType = RXS_JSON_STRING;
            RSPPC.Weight = ParsedData;

          when pPath = '/data/pieces[*]/freightClass'
           and pType = RXS_JSON_STRING;
            RSPPC.FreightClass = ParsedData;

          when pPath = '/data/pieces[*]/nmfc'
           and pType = RXS_JSON_STRING;
            RSPPC.NMFC = ParsedData;

          when pPath = '/data/pieces[*]/nmfcSub'
           and pType = RXS_JSON_STRING;
            RSPPC.NMFCSUB = ParsedData;

          when pPath = '/data/pieces[*]/description'
           and pType = RXS_JSON_STRING;
            RSPPC.Description = ParsedData;

          when pPath = '/data/pieces[*]/cube'
           and pType = RXS_JSON_STRING;
            RSPPC.Cube = ParsedData;

          when pPath = '/data/pieces[*]/containerId'
           and pType = RXS_JSON_STRING;
            RSPPC.ContainerID = ParsedData;

          when pPath = '/data/pieces[*]/isHazmat'
           and pType = RXS_JSON_STRING;
            if ParsedData = 'true';
              RSPPC.IsHazmat = *On;
            elseif ParsedData = 'false';
              RSPPC.IsHazmat = *Off;
            endif;

          when pPath = '/data/pieces[*]/hazmatCode'
           and pType = RXS_JSON_STRING;
            RSPPC.HazmatCode = ParsedData;

          when pPath = '/data/pieces[*]/hazmatClassCode'
           and pType = RXS_JSON_STRING;
            RSPPC.HazmatClassCode = ParsedData;

          when pPath = '/data/pieces[*]/hazmatPackingGroup'
           and pType = RXS_JSON_STRING;
            RSPPC.HazmatPackingGroup = ParsedData;

          when pPath = '/data/pieces[*]/handlingUnits'
           and pType = RXS_JSON_STRING;
            RSPPC.HandlingUnits = ParsedData;

          when pPath = '/data/pieces[*]/productListId'
           and pType = RXS_JSON_STRING;
            RSPPC.ProductListID = ParsedData;

       //   when pPath = '/data/pieces[*]/references[*]'
       //    and pType = RXS_JSON_ARRAY;
       //
       //   when pPath = '/data/pieces[*]/references[*]'
       //    and pType = RXS_JSON_ARRAY_END;

          when pPath = '/data/pieces[*]'
           and pType = RXS_JSON_OBJECT_END;
            write AFSDRSPPC.RAFSDRSPPC RSPPC;

          when pPath = '/data/pieces[*]'
           and pType = RXS_JSON_ARRAY_END;
            if %Open(AFSDRSPPC);
              close(E) AFSDRSPPC;
            endif;

          when pPath = '/data/additionalServices[*]'
           and pType = RXS_JSON_ARRAY;
            if not %Open(AFSDRSPAS);
              open AFSDRSPAS;
            endif;

          when pPath = '/data/additionalServices[*]'
           and pType = RXS_JSON_OBJECT;
            reset RSPAS;
            RSPAS.UniqueID = RSP.UniqueID;
            RSPAS.ShipmentID = RSP.ShipmentID;

          when pPath = '/data/additionalServices[*]/id'
           and pType = RXS_JSON_STRING;
            monitor;
              RSPAS.AdditionalServiceID = %Int( ParsedData );
            on-error;
              // TODO error
              RSPAS.AdditionalServiceID = 0;
            endmon;

          when pPath = '/data/additionalServices[*]/stopId'
           and pType = RXS_JSON_STRING;
            RSPAS.StopID = ParsedData;

          when pPath = '/data/additionalServices[*]/contractId'
           and pType = RXS_JSON_STRING;
            RSPAS.AdditionalServiceContractID = ParsedData;

          when pPath = '/data/additionalServices[*]/rateType'
           and pType = RXS_JSON_STRING;
            RSPAS.RateType = ParsedData;

          when pPath = '/data/additionalServices[*]/accChargeId'
           and pType = RXS_JSON_STRING;
            RSPAS.AccChargeID = ParsedData;

          when pPath = '/data/additionalServices[*]/description'
           and pType = RXS_JSON_STRING;
            RSPAS.Description = ParsedData;

          when pPath = '/data/additionalServices[*]/charge'
           and pType = RXS_JSON_STRING;
            monitor;
              RSPAS.Charge = %Dec( ParsedData : 9 : 2 );
            on-error;
              RSPAS.Charge = 0;
            endmon;

          when pPath = '/data/additionalServices[*]/modifier'
           and pType = RXS_JSON_STRING;
            RSPAS.Modifier = ParsedData;

          when pPath = '/data/additionalServices[*]/sellCharge'
           and pType = RXS_JSON_STRING;
            monitor;
              RSPAS.SellCharge = %Dec( ParsedData : 9 : 2 );
            on-error;
              RSPAS.SellCharge = 0;
            endmon;

          when pPath = '/data/additionalServices[*]/serviceLevel'
           and pType = RXS_JSON_STRING;
            RSPAS.ServiceLevel = ParsedData;

          when pPath = '/data/additionalServices[*]/createdBy'
           and pType = RXS_JSON_STRING;
            RSPAS.CreatedBy = ParsedData;

          when pPath = '/data/additionalServices[*]/createdDateTime'
           and pType = RXS_JSON_STRING;
            RSPAS.CreatedDateTime = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/id'
           and pType = RXS_JSON_STRING;
            RSPAS.ContractID = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrierId'
           and pType = RXS_JSON_STRING;
            RSPAS.CarrierId = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/description'
           and pType = RXS_JSON_STRING;
            RSPAS.ContractDescription = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/contractType'
           and pType = RXS_JSON_STRING;
            RSPAS.ContractType = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/id'
           and pType = RXS_JSON_STRING;
            RSPAS.ContractCarrierID = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/name'
           and pType = RXS_JSON_STRING;
            RSPAS.ContractCarrierName = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/scac'
           and pType = RXS_JSON_STRING;
            RSPAS.ContractCarrierSCAC = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/mapId'
           and pType = RXS_JSON_STRING;
            RSPAS.ContractCarrierMapID = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/email'
           and pType = RXS_JSON_STRING;
            RSPAS.ContractCarrierEmail = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'equipmentTypes[*]'
           and pType = RXS_JSON_ARRAY;
            if not %Open(AFSDRSPET);
              open AFSDRSPET;
            endif;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'equipmentTypes[*]'
           and pType = RXS_JSON_OBJECT;
            reset RSPET;
            RSPET.UniqueID = RSPAS.UniqueID;
            RSPET.ShipmentID = RSPAS.ShipmentID;
            RSPET.AdditionalServiceID = RSPAS.AdditionalServiceID;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'equipmentTypes[*]/id'
           and pType = RXS_JSON_STRING;
            monitor;
              RSPET.EquipmentTypeID = %Int( ParsedData );
            on-error;
              // TODO error
              RSPET.EquipmentTypeID = 0;
            endmon;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'equipmentTypes[*]/carrierId'
           and pType = RXS_JSON_STRING;
            RSPET.CarrierID = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'equipmentTypes[*]/equipment/id'
           and pType = RXS_JSON_STRING;
            RSPET.EquipmentID = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'equipmentTypes[*]/equipment/description'
           and pType = RXS_JSON_STRING;
            RSPET.Description = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'equipmentTypes[*]/equipment'
           and pType = RXS_JSON_OBJECT_END;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'equipmentTypes[*]'
           and pType = RXS_JSON_OBJECT_END;
            write AFSDRSPET.RAFSDRSPET RSPET;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'equipmentTypes[*]'
           and pType = RXS_JSON_ARRAY_END;
            if %Open(AFSDRSPET);
              close(E) AFSDRSPET;
            endif;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'contacts[*]'
           and pType = RXS_JSON_ARRAY;
            if not %Open(AFSDRSPCN);
              open AFSDRSPCN;
            endif;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'contacts[*]'
           and pType = RXS_JSON_OBJECT;
            reset RSPCN;
            RSPCN.UniqueID = RSPAS.UniqueID;
            RSPCN.ShipmentID = RSPAS.ShipmentID;
            RSPCN.AdditionalServiceID = RSPAS.AdditionalServiceID;

            // No contact ID provided by AFS, just going to use array index
            RSPCN.ContactID = pIndex;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'contacts[*]/carrierId'
           and pType = RXS_JSON_STRING;
            RSPCN.ContactCarrierID = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'contacts[*]/contactName'
           and pType = RXS_JSON_STRING;
            RSPCN.ContactName = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'contacts[*]/contactPhone'
           and pType = RXS_JSON_STRING;
            RSPCN.ContactPhone = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'contacts[*]/email'
           and pType = RXS_JSON_STRING;
            RSPCN.ContactEmail = ParsedData;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'contacts[*]'
           and pType = RXS_JSON_OBJECT_END;
            write AFSDRSPCN.RAFSDRSPCN RSPCN;

          when pPath = '/data/additionalServices[*]/contract/carrier/'
                     + 'contacts[*]'
           and pType = RXS_JSON_ARRAY_END;
            if %Open(AFSDRSPCN);
              close(E) AFSDRSPCN;
            endif;

          when pPath = '/data/additionalServices[*]/contract/carrier'
           and pType = RXS_JSON_OBJECT_END;

          when pPath = '/data/additionalServices[*]/contract'
           and pType = RXS_JSON_OBJECT_END;

          when pPath = '/data/additionalServices[*]'
           and pType = RXS_JSON_OBJECT_END;
            write AFSDRSPAS.RAFSDRSPAS RSPAS;

          when pPath = '/data/additionalServices[*]'
           and pType = RXS_JSON_ARRAY_END;
            if %Open(AFSDRSPAS);
              close(E) AFSDRSPAS;
            endif;

          when pPath = '/data/references[*]'
           and pType = RXS_JSON_ARRAY;
            if not %Open(AFSDRSPRF);
              open AFSDRSPRF;
            endif;

          when pPath = '/data/references[*]'
           and pType = RXS_JSON_OBJECT;
            reset RSPRF;
            RSPRF.UniqueID = RSP.UniqueID;
            RSPRF.ShipmentID = RSP.ShipmentID;

            // No reference ID provided by AFS, just going to use array index
            RSPRF.ReferenceID = pIndex;

          when pPath = '/data/references[*]/typeId'
           and pType = RXS_JSON_STRING;
             RSPRF.TypeID = ParsedData;

          when pPath = '/data/references[*]/description'
           and pType = RXS_JSON_STRING;
            RSPRF.Description = ParsedData;

          when pPath = '/data/references[*]/value'
           and pType = RXS_JSON_STRING;
            RSPRF.Value = ParsedData;

          when pPath = '/data/references[*]/createdDateTime'
           and pType = RXS_JSON_STRING;
            RSPRF.CreatedDateTime = ParsedData;

          when pPath = '/data/references[*]/createdBy'
           and pType = RXS_JSON_STRING;
            RSPRF.CreatedBy = ParsedData;

          when pPath = '/data/references[*]'
           and pType = RXS_JSON_OBJECT_END;
            write AFSDRSPRF.RAFSDRSPRF RSPRF;

          when pPath = '/data/references[*]'
           and pType = RXS_JSON_ARRAY_END;
            if %Open(AFSDRSPRF);
              close(E) AFSDRSPRF;
            endif;

          when pPath = '/data/stops[*]'
           and pType = RXS_JSON_ARRAY;
            if not %Open(AFSDRSPST);
              open AFSDRSPST;
            endif;

          when pPath = '/data/stops[*]'
           and pType = RXS_JSON_OBJECT;
            reset RSPST;
            RSPST.UniqueID = RSP.UniqueID;
            RSPST.ShipmentID = RSP.ShipmentID;

          when pPath = '/data/stops[*]/id'
           and pType = RXS_JSON_STRING;
            monitor;
              RSPST.StopID = %Int( ParsedData );
            on-error;
              // TODO error
              RSPST.StopID = 0;
            endmon;

          when pPath = '/data/stops[*]/companyName'
           and pType = RXS_JSON_STRING;
            RSPST.Name = ParsedData;

          when pPath = '/data/stops[*]/address1'
           and pType = RXS_JSON_STRING;
            RSPST.Address1 = ParsedData;

          when pPath = '/data/stops[*]/city'
           and pType = RXS_JSON_STRING;
            RSPST.City = ParsedData;

          when pPath = '/data/stops[*]/state'
           and pType = RXS_JSON_STRING;
            RSPST.State = ParsedData;

          when pPath = '/data/stops[*]/country'
           and pType = RXS_JSON_STRING;
            RSPST.Country = ParsedData;

          when pPath = '/data/stops[*]/postalCode'
           and pType = RXS_JSON_STRING;
            RSPST.PostalCode = ParsedData;

          when pPath = '/data/stops[*]/contactName'
           and pType = RXS_JSON_STRING;
            RSPST.ContactName = ParsedData;

          when pPath = '/data/stops[*]/contactPhone'
           and pType = RXS_JSON_STRING;
            RSPST.ContactPhone = ParsedData;

          when pPath = '/data/stops[*]/contactFax'
           and pType = RXS_JSON_STRING;
            RSPST.ContactFax = ParsedData;

          when pPath = '/data/stops[*]/contactEmail'
           and pType = RXS_JSON_STRING;
            RSPST.ContactEmail = ParsedData;

          when pPath = '/data/stops[*]/sequence'
           and pType = RXS_JSON_STRING;
            RSPST.SeqNumber = ParsedData;

          when pPath = '/data/stops[*]/openTime'
           and pType = RXS_JSON_STRING;
            RSPST.OpenTime = ParsedData;

          when pPath = '/data/stops[*]/closeTime'
           and pType = RXS_JSON_STRING;
            RSPST.CloseTime = ParsedData;

          when pPath = '/data/stops[*]'
           and pType = RXS_JSON_OBJECT_END;
            write AFSDRSPST.RAFSDRSPST RSPST;

          when pPath = '/data/stops[*]'
           and pType = RXS_JSON_ARRAY_END;
            if %Open(AFSDRSPST);
              close(E) AFSDRSPST;
            endif;

          when pPath = '/data'
           and pType = RXS_JSON_OBJECT_END;
            write AFSDRSP.RAFSDRSP RSP;

          when pPath = '/'
           and pType = RXS_JSON_OBJECT_END;
            if %Open(AFSDRSP);
              close(E) AFSDRSP;
            endif;

        endsl;

        return RXS_JSON_CONTINUE_PARSING;

       on-error;
        if %Open(AFSDRSP);
         close(E) AFSDRSP;
        endif;

        if %Open(AFSDRSPST);
          close(E) AFSDRSPST;
        endif;
        return RXS_JSON_STOP_PARSING;
       endmon;

       End-Proc;


       Dcl-Proc Error_JsonHandler;
         Dcl-Pi *N Ind;
           pType Int(5) Const;
           pPath Like(RXS_Var64Kv_t) Const;
           pIndex Uns(10) Const;
           pData Pointer Const;
           pDataLen Uns(10) Const;
         End-Pi;

        Dcl-F AFSERR Disk Usage(*Output) Keyed
         UsrOpn Qualified Alias Static;

        Dcl-Ds ERR LikeRec(AFSERR.RAFSERR:*All) Static Inz;

       monitor;

        select;

          when pPath = '/'
           and pType = RXS_JSON_OBJECT;
            reset ERR;
            ERR.UniqueID = gUniqueID;
            ERR.ResponseTimestamp = %Timestamp();

            if not %Open(AFSERR);
              open AFSERR;
            endif;

          when pPath = '/errorDescription'
           and pType = RXS_JSON_STRING;
            ERR.ErrorDescription = RXS_STR( pData : pDataLen );

          when pPath = '/errorCode'
           and pType = RXS_JSON_STRING;
            ERR.ErrorCode = RXS_STR( pData : pDataLen );

          when pPath = '/errorType'
           and pType = RXS_JSON_STRING;
            ERR.ErrorType = RXS_STR( pData : pDataLen );
            // This seems to be null more often than not,
            //  so handling it as an empty field
            if ERR.ErrorType = 'null';
              reset ERR.ErrorType;
            endif;

          when pPath = '/endPoint'
           and pType = RXS_JSON_STRING;
            ERR.Endpoint = RXS_STR( pData : pDataLen );

          when pPath = '/transactionId'
           and pType = RXS_JSON_STRING;
            ERR.TransactionID = RXS_STR( pData : pDataLen );

          when pPath = '/timeStamp'
           and pType = RXS_JSON_STRING;
            ERR.ServerTimestamp = RXS_STR( pData : pDataLen );

          when pPath = '/'
           and pType = RXS_JSON_OBJECT_END;
            write AFSERR.RAFSERR ERR;

        endsl;

        return RXS_JSON_CONTINUE_PARSING;

       on-error;
        if %Open(AFSERR);
          close(E) AFSERR;
        endif;
        return RXS_JSON_STOP_PARSING;
       endmon;
       End-Proc;
