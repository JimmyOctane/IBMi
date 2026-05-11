
        Ctl-Opt NoMain BndDir('RXSBND':'ECBIND') ExtBinInt(*Yes) DecEdit('0.')
        Option(*NoDebugIO) Text('AFS APIs');
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - AFSTOKN                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D AFS_GetLoginToken                                                     *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    AFS_GetLoginToken                                                  *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3163 100825 JJF created program                                 *
     F*M ----------------------------------------------------------------------*


         /COPY QRPGLECPY,RXSCB

            Dcl-Proc AFS_GetLoginToken Export;
             Dcl-Pi *N char(4096);
              pUniqueID Packed(15:0) Const;
              pConfigDS LikeDS(AFS_ConfigDS_2) Const;
             End-Pi;

         /COPY qcpysrc,AFSTOKN_CP

            //***********************************************************/
            // Main Procedure                                           */
            //***********************************************************/
            Dcl-S gLoginToken Like(RXS_Var4Kv_t);
            Dcl-S gUniqueID Packed(15:0);
            dcl-s myTimeStamp timeStamp inz;
            dcl-s myToken varchar(300)inz;
            dcl-s mySQLToken varchar(300)inz;
            dcl-s pPath Like(RXS_Var64Kv_t);
            dcl-s RequestJson Like(RXS_Var1Kv_t);
            dcl-s ResponseJson Like(RXS_Var4Kv_t);

            dcl-ds CreateJsonDS LikeDS(RXS_CreateJsonDS_t);
            dcl-ds ParseJsonDS LikeDS(RXS_ParseJsonDS_t);
            dcl-ds RootDS LikeDS(RXS_JsonStructureDS_t);
            dcl-ds TransmitDS LikeDS(RXS_TransmitDS_t);

            dcl-c AFS_TRUE   *On;
            dcl-c AFS_FALSE  *Off;

            dcl-c AFS_INSTRUCTION_TYPE_DELIVERY 'DELIVERY';
            dcl-c AFS_INSTRUCTION_TYPE_PICKUP 'PICKUP';

            // how old is this token?
            reset myTimeStamp;
            reset myToken;
            exec sql
             select LASTUPDTE, TOKEN
              into : myTimeStamp,:myToken
              from AFSTOKEN;

            if %diff(%timeStamp:myTimeStamp:*Hours) > 6;
             monitor;
              exsr compose;
              exsr transmit;
              exsr parse;
              // update timestamp and Token here
              mySQLToken = ResponseJson;
              exec sql delete from AFSTOKEN;
              exec sql
              insert into AFSTOKEN
              (LASTUPDTE, TOKEN)
              values(current_timestamp , :mySQLToken);
             on-error;
             endmon;
            else;

              ResponseJson = myToken;
            endif;

            return ResponseJson;

            // ----------------------------------
            begsr compose;

             RXS_ResetDS( CreateJsonDS : RXS_DS_TYPE_CREATEJSON );
             CreateJsonDS.JsonStructureType = RXS_JSON_STRUCTURE_OBJECT;
             CreateJsonDS.TrimVariables = RXS_YES;
             RootDS = RXS_CreateJson( CreateJsonDS );

             RXS_ComposeJsonString('username':pConfigDS.Username:RootDS);
             RXS_ComposeJsonString('password':pConfigDS.Password:RootDS);

             RequestJson = RXS_GetJsonString( CreateJsonDS );
            endsr;

            // ----------------------------------

            begsr transmit;
             RXS_ResetDS( TransmitDS : RXS_DS_TYPE_TRANSMIT );

             TransmitDS.URI = %TrimR( pConfigDS.BaseAPIPath : ' /' ) +
               '/security/login';

             TransmitDS.HTTPMethod = RXS_HTTP_METHOD_POST;

             TransmitDS.SSLVerifyPeer = RXS_NO;
             TransmitDS.SSLVerifyHost = RXS_NO;

             TransmitDS.HeaderContentType = 'application/json';

             if pConfigDS.CreateLogFile;
              TransmitDS.LogFile = %TrimR( pConfigDS.LogPath : ' /' )
              + '/afs_getlogintoken_' + %Char(pUniqueID) + '.txt';
             endif;

             ResponseJson = RXS_Transmit( RequestJSON : TransmitDS );
            endsr;

            // ----------------------------------

            begsr parse;

             RXS_ResetDS( ParseJsonDS : RXS_DS_TYPE_PARSEJSON );
             ParseJsonDS.Handler = %PAddr( Login_JsonHandler );

             RXS_ParseJson( ResponseJson : ParseJsonDS );

             // {"token":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImVhc3RfY29hc
             // 3RfbWV0YWxfZGlzdHJpYnV0b3JzX2xsYyIsImhhc0FwaUFjY2VzcyI6dHJ1Z
             // SwianRpIjoiMzI3Y2Q0MzUtOWVjNC00YmQzLTlmNDQtMzE1ODg5YWY5YjE0I
             // iwiaWF0IjoxNzYxMDY4NDk4LCJleHAiOjE3NjExMTE2OTh9.X-dKlJ09Qonk
             // SJei7Ci59l2WpCn0OSiG0YTNGq_BjIY"}
             //

             responseJson = %scanRpl('{"token":"':'':responseJson);
             responseJson = %scanRpl('"}':'':responseJson);

           endsr;

           End-Proc;

            // ----------------------------------
           Dcl-Proc Login_JsonHandler;
            Dcl-Pi *N Ind;
             pType Int(5) Const;
             pPath Like(RXS_Var64Kv_t) Const;
             pIndex Uns(10) Const;
             pData Pointer Const;
             pDataLen Uns(10) Const;
            End-Pi;

            Dcl-S gLoginToken Like(RXS_Var4Kv_t);

           select;

           when pPath = '/token'
            and pType = RXS_JSON_STRING;
            gLoginToken = RXS_STR( pData : pDataLen );

           endsl;

           return RXS_JSON_CONTINUE_PARSING;
           End-Proc;

