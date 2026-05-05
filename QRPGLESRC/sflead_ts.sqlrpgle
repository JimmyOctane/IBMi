**FREE

Ctl-Opt ActGrp(*New) BndDir('RXSBND':'SFBND') DecEdit('0.')  Main(T_SFTEST)
  Text('Salesforce API Add Lead');

/COPY QRPGLECPY,RXSCB

Dcl-C CLIENT_ID '3MVG90d5QAcjgQDNloaXfHx_fP8ffvRrP5QHcNvVEXe6CGpqMn5tgsrZzH5uRf95fnD2_fnbkvKC8_7mZ3l
Dcl-C SANDBOX_USERNAME 'bectran@ecmdi.com.ecstage';
Dcl-C PRIVATE_KEY_FILE '/home/salesForce/salesforcePKDevelopment.key';
Dcl-C SANDBOX_URL 'https://test.salesforce.com';
Dcl-C EXPIRATION 3600;

Dcl-C AUTH_LOG_FILE '/tmp/salesforce_auth.txt';
Dcl-C LOG_FILE '/tmp/salesforce.txt';


Dcl-S gBearerToken Like(RXS_Var4Kv_t);

Dcl-S gSuccess Like(RXS_Var1Kv_t);
Dcl-S gID Like(RXS_Var1Kv_t);

Dcl-Proc T_SFTEST;
  Dcl-Pi *N;
  End-Pi;

  Dcl-Ds RootDS LikeDS(RXS_JsonStructureDS_t);

  Dcl-S RequestJson Like(RXS_Var64Kv_t);
  Dcl-S ResponseJson Like(RXS_Var64Kv_t);

  Dcl-Ds CreateJsonDS LikeDS(RXS_CreateJsonDS_t);
  Dcl-Ds TransmitDS LikeDS(RXS_TransmitDS_t);
  Dcl-Ds ParseJsonDS LikeDS(RXS_ParseJsonDS_t);

  Dcl-S AuthRequest Like(RXS_Var32Kv_t);
  Dcl-S AuthResponseJson Like(RXS_Var32Kv_t);
  Dcl-S JWT Like(RXS_Var8Kv_t);

  exsr authenticate;
  exsr compose;
  exsr transmit;
  exsr parse;

  return;

  begsr authenticate;

    JWT = GenerateJWT( CLIENT_ID : SANDBOX_USERNAME : SANDBOX_URL : EXPIRATION : PRIVATE_KEY_FILE );

    AuthRequest = 'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=' + JWT;

    RXS_ResetDS( TransmitDS : RXS_DS_TYPE_TRANSMIT );
    TransmitDS.URI = SANDBOX_URL + '/services/oauth2/token';
    TransmitDS.HTTPMethod = RXS_HTTP_METHOD_POST;
    TransmitDS.HeaderContentType = 'application/x-www-form-urlencoded';

    TransmitDS.LogFile = AUTH_LOG_FILE;

    AuthResponseJson = RXS_Transmit( AuthRequest : TransmitDS );

    RXS_ResetDS( ParseJsonDS : RXS_DS_TYPE_PARSEJSON );
    ParseJsonDS.Handler = %PAddr( Auth_Handler );
    RXS_ParseJson( AuthResponseJson : ParseJsonDS );

    if gBearerToken = *Blanks;
      SND-MSG 'ERROR: failed to get bearer token';
      SND-MSG AuthRequest;
      SND-MSG AuthResponseJson;
      return;
    endif;
  endsr;

  begsr compose;
    RXS_ResetDS( CreateJsonDS : RXS_DS_TYPE_CREATEJSON );
    CreateJsonDS.JsonStructureType = RXS_JSON_STRUCTURE_OBJECT;
    CreateJsonDS.TrimVariables = RXS_YES;
    RootDS = RXS_CreateJson( CreateJsonDS );

    RXS_ComposeJsonString( 'FirstName' : 'Bectran' : RootDS );
    RXS_ComposeJsonString( 'LastName' : 'Test' : RootDS );
    RXS_ComposeJsonString( 'Company' : 'Bectran Test Company (KATO)' : RootDS );
    RXS_ComposeJsonString( 'Email' : 'bectran@example.com' : RootDS );
    RXS_ComposeJsonString( 'Phone' : '1234567890' : RootDS );
    RXS_ComposeJsonString( 'Title' : 'President' : RootDS );
    RXS_ComposeJsonString( 'Street' : '22 Wendys Blvd Apt 3' : RootDS );
    RXS_ComposeJsonString( 'City' : 'Skokie' : RootDS );
    RXS_ComposeJsonString( 'State' : 'IL' : RootDS );
    RXS_ComposeJsonString( 'PostalCode' : '60005' : RootDS );
    RXS_ComposeJsonString( 'Country' : 'United States' : RootDS );
    RXS_ComposeJsonString( 'LeadSource' : 'ONLINE-APPLICATION' : RootDS );
    RXS_ComposeJsonString( 'Status' : 'Open' : RootDS );
    RXS_ComposeJsonString( 'Industry' : 'Add-On Replacement' : RootDS );
    RXS_ComposeJsonString( 'Type__c' : 'INC' : RootDS );
    RXS_ComposeJsonString( 'External_GUID__c' : 'DE00A004-D6A6-1AEF-848C-0004AC1DCCD6' : RootDS );

    RXS_ComposeJsonNumber( 'Number_of_Years_In_Business__c' : '24' : RootDS );

    RXS_ComposeJsonBoolean( 'Applying_to_credit__c' : RXS_JSON_TRUE : RootDS );

    RequestJson = RXS_GetJsonString( CreateJsonDS );
  endsr;

  begsr transmit;
    RXS_ResetDS( TransmitDS : RXS_DS_TYPE_TRANSMIT );

    TransmitDS.URI = 'https://eastcoastmetal--ecstage.sandbox.my.salesforce.com/services/data/v62.0/
    TransmitDS.HTTPMethod = RXS_HTTP_METHOD_POST;
    TransmitDS.HeaderContentType = 'application/json';

    TransmitDS.HeaderAuthScheme = RXS_HTTP_AUTH_SCHEME_BEARER;
    TransmitDS.HeaderAuthCredentials = gBearerToken;

    TransmitDS.SSLVerifyHost = RXS_NO;
    TransmitDS.SSLVerifyPeer = RXS_NO;

    TransmitDS.LogFile = LOG_FILE;

    ResponseJson = RXS_Transmit( RequestJson : TransmitDS );
  endsr;

  begsr parse;
    RXS_ResetDS( ParseJsonDS : RXS_DS_TYPE_PARSEJSON );
    ParseJsonDS.Handler = %PAddr( Salesforce_Handler );

    RXS_ParseJson( ResponseJson : ParseJsonDS );
  endsr;

End-Proc;

Dcl-Proc Salesforce_Handler;
  Dcl-Pi *N Ind ExtProc(*DclCase);
    pType Int(5) Const;
    pPath Like(RXS_Var64Kv_t) Const;
    pIndex Uns(10) Const;
    pData Pointer Const;
    pDataLen Uns(10) Const;
  End-Pi;

  select;

    when pPath = '/'
     and pType = RXS_JSON_OBJECT;

    when pPath = '/id'
     and pType = RXS_JSON_STRING;
      gID = RXS_STR( pData : pDataLen );

    when pPath = '/success'
     and pType = RXS_JSON_STRING;
      gSuccess = RXS_STR( pData : pDataLen );

    when pPath = '/errors[*]'
     and pType = RXS_JSON_ARRAY;

     // TODO Not sure how to handle parsing errors

    when pPath = '/errors[*]'
     and pType = RXS_JSON_ARRAY_END;

    when pPath = '/'
     and pType = RXS_JSON_OBJECT_END;

  endsl;

  return RXS_JSON_CONTINUE_PARSING;
End-Proc;

Dcl-Proc Auth_Handler;
  Dcl-Pi *N Ind;
    pType Int(5) Const;
    pPath Like(RXS_Var64Kv_t) Const;
    pIndex Uns(10) Const;
    pData Pointer Const;
    pDataLen Uns(10) Const;
  End-Pi;

  select;

    when pPath = '/'
     and pType = RXS_JSON_OBJECT;
      reset gBearerToken;

    when pPath = '/access_token'
     and pType = RXS_JSON_STRING;
      gBearerToken = RXS_STR( pData : pDataLen );

    when pPath = '/scope'
     and pType = RXS_JSON_STRING;

    when pPath = '/instance_url'
     and pType = RXS_JSON_STRING;

    when pPath = '/id'
     and pType = RXS_JSON_STRING;

    when pPath = '/token_type'
     and pType = RXS_JSON_STRING;

  endsl;

  return RXS_JSON_CONTINUE_PARSING;
End-Proc;




Dcl-Proc GenerateJWT;
  Dcl-Pi *N Like(RXS_Var8Kv_t);
    pClientID VarChar(128) Const Options(*Trim);
    pSandboxUsername VarChar(128) Const Options(*Trim);
    pSandboxUrl VarChar(128) Const Options(*Trim);
    pExp Int(10) Const;
    pPrivateKeyFile Like(RXS_Var1Kv_t) Const Options(*Trim);
  End-Pi;

  /COPY QRPGLECPY,JWT_CP

  Dcl-Ds JWTDS LikeDS(JWT_StructureDS_t);

  Dcl-S JWT Like(RXS_Var8Kv_t);

  Dcl-S Expiry Int(10);

  JWT_Initialize( JWTDS );

  JWT_SetAlgorithm( JWT_ALGORITHM_RSA_SHA256
                  : pPrivateKeyFile
                  : JWTDS );

  JWT_AddClaimString( 'iss' : pClientID : JWTDS );
  JWT_AddClaimString( 'sub' : pSandboxUsername : JWTDS );
  JWT_AddClaimString( 'aud' : pSandboxUrl : JWTDS );

  // Get expiration time
  Expiry = JWT_GetEpochTime( pExp );

  JWT_AddClaimNumber( 'exp' : %Char(Expiry) : JWTDS );

  JWT = JWT_ToString( JWTDS );

  return JWT;
End-Proc;
