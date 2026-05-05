**FREE

Ctl-Opt NoMain BndDir('RXSBND') ExtBinInt(*Yes) DecEdit('0.') Option(*NoDebugIO)
  Text('JWT APIs');

//--------------------------------------------------------------------------------------------------
// Copybooks
//--------------------------------------------------------------------------------------------------
/COPY QRPGLECPY,RXSCB

/COPY QRPGLECPY,JWT_CP

//--------------------------------------------------------------------------------------------------
// Exported Subprocedures
//--------------------------------------------------------------------------------------------------

Dcl-Proc JWT_Initialize Export;
  Dcl-Pi *N;
    pJWT LikeDS(JWT_StructureDS_t);
  End-Pi;

  Dcl-Ds JWT LikeDS(JWT_StructureDS_t) Inz(*LikeDS);

  reset JWT;

  RXS_ResetDS( JWT.HeaderCreateDS : RXS_DS_TYPE_CREATEJSON );
  JWT.HeaderCreateDS.OutputCCSID = RXS_CCSID_UTF8;
  JWT.HeaderCreateDS.JsonStructureType = RXS_JSON_STRUCTURE_OBJECT;
  JWT.HeaderCreateDS.Prettify = RXS_NO;
  JWT.HeaderCreateDS.TrimVariables = RXS_YES;
  JWT.HeaderRootDS = RXS_CreateJson( JWT.HeaderCreateDS );

  RXS_ResetDS( JWT.PayloadCreateDS : RXS_DS_TYPE_CREATEJSON );
  JWT.PayloadCreateDS.OutputCCSID = RXS_CCSID_UTF8;
  JWT.PayloadCreateDS.JsonStructureType = RXS_JSON_STRUCTURE_OBJECT;
  JWT.HeaderCreateDS.Prettify = RXS_NO;
  JWT.HeaderCreateDS.TrimVariables = RXS_YES;
  JWT.PayloadRootDS = RXS_CreateJson( JWT.PayloadCreateDS );

  pJWT = JWT;

  return;
End-Proc;


Dcl-Proc JWT_SetAlgorithm Export;
  Dcl-Pi *N;
    pAlgorithm VarChar(10) Const Options(*Trim);
    pSecret Like(RXS_Var1Kv_t) Const Options(*Trim);
    pJWT LikeDS(JWT_StructureDS_t);
  End-Pi;

  Dcl-Ds ErrorDS LikeDS(RXS_CatchThrowErrorDS_t);

  select;
    when pAlgorithm = JWT_ALGORITHM_HMAC_SHA256;
      // Expecting a secret key in pSecret
      pJWT.Algorithm = JWT_ALGORITHM_HMAC_SHA256;
      pJWT.Secret = pSecret;

    when pAlgorithm = JWT_ALGORITHM_RSA_SHA256;
      // Expect an IFS file path in pSecret
      pJWT.Algorithm = JWT_ALGORITHM_RSA_SHA256;
      pJWT.Secret = pSecret;

    other;
      RXS_ResetDS( ErrorDS : RXS_DS_TYPE_CATCHTHROWERROR );
      ErrorDS.MessageId = 'RXS9898';
      ErrorDS.MessageFile = 'RXSMSGF';
      ErrorDS.MessageType = RXS_MESSAGE_TYPE_ESCAPE;
      ErrorDS.MessageData = 'JWT_SetAlgorithm: Invalid JWT Algorithm';
      ErrorDS.ThrowToCaller = RXS_YES;
      RXS_Throw( ErrorDS );
      return;
  endsl;

  return;
End-Proc;



// Add string value as claim to JWT payload
Dcl-Proc JWT_AddClaimString Export;
  Dcl-Pi *N;
    pName VarChar(50) Const Options(*Trim);
    pValue VarChar(512) Const Options(*Trim);
    pJWT LikeDS(JWT_StructureDS_t);
  End-Pi;

  RXS_ComposeJsonString( pName : pValue : pJWT.PayloadRootDS );

  return;
End-Proc;


// Add numeric value as claim to JWT payload
Dcl-Proc JWT_AddClaimNumber Export;
  Dcl-Pi *N;
    pName VarChar(50) Const Options(*Trim);
    pValue VarChar(32) Const Options(*Trim);
    pJWT LikeDS(JWT_StructureDS_t);
  End-Pi;

  RXS_ComposeJsonNumber( pName : pValue : pJWT.PayloadRootDS );

  return;
End-Proc;


// Add boolean value as claim to JWT payload
Dcl-Proc JWT_AddClaimBoolean Export;
  Dcl-Pi *N;
    pName VarChar(50) Const Options(*Trim);
    pValue Ind Const;
    pJWT LikeDS(JWT_StructureDS_t);
  End-Pi;

  RXS_ComposeJsonBoolean( pName : pValue : pJWT.PayloadRootDS );

  return;
End-Proc;


// Add null value as claim to JWT payload
Dcl-Proc JWT_AddClaimNull Export;
  Dcl-Pi *N;
    pName VarChar(50) Const Options(*Trim);
    pJWT LikeDS(JWT_StructureDS_t);
  End-Pi;

  RXS_ComposeJsonNull( pName : pJWT.PayloadRootDS );

  return;
End-Proc;


// Retrieve JWT token
Dcl-Proc JWT_ToString Export;
  Dcl-Pi *N Like(RXS_Var8Kv_t);
    pJWT LikeDS(JWT_StructureDS_t);
  End-Pi;

  Dcl-Ds ErrorDS LikeDS(RXS_CatchThrowErrorDS_t);

  Dcl-Ds HMACDS LikeDS(RXS_HMACDS_t);
  Dcl-Ds Base64UrlDS LikeDS(RXS_ConvertBase64UrlDS_t);

  Dcl-S HMACBin Char(32);

  Dcl-S Header Like(RXS_Var1Kv_t);
  Dcl-S Payload Like(RXS_Var1Kv_t);
  Dcl-S HeaderPayload Like(RXS_Var4Kv_t);

  Dcl-S PrivateKey Like(RXS_Var8Kv_t);

  Dcl-S JWTSignatureRaw Like(RXS_Var4Kv_t);
  Dcl-S JWTSignatureB64 Like(RXS_Var4Kv_t);
  Dcl-S Token Like(RXS_Var8Kv_t);

  if pJWT.Algorithm = *Blanks;
    RXS_ResetDS( ErrorDS : RXS_DS_TYPE_CATCHTHROWERROR );
    ErrorDS.MessageId = 'RXS9898';
    ErrorDS.MessageFile = 'RXSMSGF';
    ErrorDS.MessageType = RXS_MESSAGE_TYPE_ESCAPE;
    ErrorDS.MessageData = 'JWT_ToString: Invalid JWT Algorithm';
    ErrorDS.ThrowToCaller = RXS_YES;
    RXS_Throw( ErrorDS );
    return '';
  endif;

  if pJWT.Secret = *Blanks;
    RXS_ResetDS( ErrorDS : RXS_DS_TYPE_CATCHTHROWERROR );
    ErrorDS.MessageId = 'RXS9898';
    ErrorDS.MessageFile = 'RXSMSGF';
    ErrorDS.MessageType = RXS_MESSAGE_TYPE_ESCAPE;
    ErrorDS.MessageData = 'JWT_ToString: No Secret Provided';
    ErrorDS.ThrowToCaller = RXS_YES;
    RXS_Throw( ErrorDS );
    return '';
  endif;

  // Build and retrieve header
  RXS_ComposeJsonString( 'alg' : pJWT.Algorithm : pJWT.HeaderRootDS );
  RXS_ComposeJsonString( 'typ' : JWT_TOKEN_TYPE_JWT : pJWT.HeaderRootDS );
  Header = GetEncodedHeader( pJWT );

  // Payload should already have been built by now, just need to get the string
  Payload = GetEncodedPayload( pJWT );

  HeaderPayload = Header + JWT_SEPARATOR + Payload;

  select;
    when pJWT.Algorithm = JWT_ALGORITHM_HMAC_SHA256;
      // Sign with RXS_HMAC
      RXS_ResetDS( HMACDS : RXS_DS_TYPE_HMAC );
      HMACDS.Algorithm = RXS_HMAC_SHA256;
      HMACDS.ReturnAsChar = RXS_NO;
      HMACBin = RXS_HMAC( HeaderPayload : pJWT.Secret : HMACDS );

      RXS_ResetDS( Base64UrlDS : RXS_DS_TYPE_CONVERTBASE64URL );
      Base64UrlDS.EncodeDecode = RXS_ENCODE;
      JWTSignatureB64 = RXS_Convert( HMACBin : Base64UrlDS );

    when pJWT.Algorithm = JWT_ALGORITHM_RSA_SHA256;
      PrivateKey = GetPrivateKeyDER( pJWT.Secret );

      if PrivateKey = *Blanks;
        RXS_ResetDS( ErrorDS : RXS_DS_TYPE_CATCHTHROWERROR );
        ErrorDS.MessageId = 'RXS9898';
        ErrorDS.MessageFile = 'RXSMSGF';
        ErrorDS.MessageType = RXS_MESSAGE_TYPE_ESCAPE;
        ErrorDS.MessageData = 'JWT_ToString: Failed to decode private key';
        ErrorDS.ThrowToCaller = RXS_YES;
        RXS_Throw( ErrorDS );
      endif;

      JWTSignatureRaw = RS256SignWithDER( HeaderPayload : PrivateKey );

      if JWTSignatureRaw = *Blanks;
        RXS_ResetDS( ErrorDS : RXS_DS_TYPE_CATCHTHROWERROR );
        ErrorDS.MessageId = 'RXS9898';
        ErrorDS.MessageFile = 'RXSMSGF';
        ErrorDS.MessageType = RXS_MESSAGE_TYPE_ESCAPE;
        ErrorDS.MessageData = 'JWT_ToString: Failed to sign header+payload';
        ErrorDS.ThrowToCaller = RXS_YES;
        RXS_Throw( ErrorDS );
        return '';
      endif;

      RXS_ResetDS( Base64UrlDS : RXS_DS_TYPE_CONVERTBASE64URL );
      Base64UrlDS.EncodeDecode = RXS_ENCODE;
      JWTSignatureB64 = RXS_Convert( JWTSignatureRaw : Base64UrlDS );

    other;
      RXS_ResetDS( ErrorDS : RXS_DS_TYPE_CATCHTHROWERROR );
      ErrorDS.MessageId = 'RXS9898';
      ErrorDS.MessageFile = 'RXSMSGF';
      ErrorDS.MessageType = RXS_MESSAGE_TYPE_ESCAPE;
      ErrorDS.MessageData = 'JWT_ToString: Invalid JWT Algorithm';
      ErrorDS.ThrowToCaller = RXS_YES;
      RXS_Throw( ErrorDS );
      return '';
  endsl;

  Token = HeaderPayload + JWT_SEPARATOR + JWTSignatureB64;

  return Token;
End-Proc;


Dcl-Proc JWT_GetEpochTime Export;
  Dcl-Pi *N Int(10);
    pOffset Int(10) Const Options(*Omit:*NoPass);
  End-Pi;

  Dcl-Pr c_time Int(10) ExtProc('time') End-Pr;

  Dcl-S ExpTime Int(10);

  ExpTime = c_time();
  if %Parms() > 0;
    if %Addr( pOffset ) <> *Null;
      ExpTime += pOffset;
    endif;
  endif;

  return ExpTime;
End-Proc;

//--------------------------------------------------------------------------------------------------
// Internal Subprocedures
//--------------------------------------------------------------------------------------------------

Dcl-Proc GetEncodedHeader;
  Dcl-Pi *N Like(RXS_Var1Kv_t);
    pJWT LikeDS(JWT_StructureDS_t);
  End-Pi;

  Dcl-Ds Base64UrlDS LikeDS(RXS_ConvertBase64UrlDS_t);

  Dcl-S HeaderJson Like(RXS_Var1Kv_t);
  Dcl-S Encoded Like(RXS_Var1Kv_t);

  HeaderJson = RXS_GetJsonString( pJWT.HeaderCreateDS );

  RXS_ResetDS( Base64UrlDS : RXS_DS_TYPE_CONVERTBASE64URL );
  Base64UrlDS.EncodeDecode = RXS_ENCODE;
  Encoded = RXS_Convert( HeaderJson : Base64UrlDS );

  return Encoded;
End-Proc;


Dcl-Proc GetEncodedPayload;
  Dcl-Pi *N Like(RXS_Var1Kv_t);
    pJWT LikeDS(JWT_StructureDS_t);
  End-Pi;

  Dcl-Ds Base64UrlDS LikeDS(RXS_ConvertBase64UrlDS_t);

  Dcl-S PayloadJson Like(RXS_Var1Kv_t);
  Dcl-S Encoded Like(RXS_Var1Kv_t);

  PayloadJson = RXS_GetJsonString( pJWT.PayloadCreateDS );

  RXS_ResetDS( Base64UrlDS : RXS_DS_TYPE_CONVERTBASE64URL );
  Base64UrlDS.EncodeDecode = RXS_ENCODE;
  Encoded = RXS_Convert( PayloadJson : Base64UrlDS );

  return Encoded;
End-Proc;


Dcl-Proc GetPrivateKeyDER;
  Dcl-Pi *N Like(RXS_Var8Kv_t) ExtProc(*DclCase);
    pFilepath Like(RXS_Var1Kv_t) Const Options(*Trim);
  End-Pi;

  Dcl-S PrivateKey Like(RXS_Var8Kv_t);
  Dcl-S DecodedKey Like(RXS_Var8Kv_t);

  Dcl-Ds GetStmfDS LikeDS(RXS_GetStmfDS_t);
  Dcl-Ds Base64DS LikeDS(RXS_ConvertBase64DS_t);

  Dcl-C PEM_HEADER '-----BEGIN PRIVATE KEY-----';
  Dcl-C PEM_FOOTER '-----END PRIVATE KEY-----';
  Dcl-C EBCDIC_CR x'0D';
  Dcl-C EBCDIC_LF x'25';

  RXS_ResetDS( GetStmfDS : RXS_DS_TYPE_GETSTMF );
  GetStmfDS.Stmf = pFilepath;
  GetStmfDS.ToCCSID = RXS_CCSID_JOB;
  PrivateKey = RXS_GetStmf( GetStmfDS );

  if PrivateKey = *Blanks;
    return '';
  endif;

  // strip PEM headers, footers, and line controls
  PrivateKey = %ScanRpl( EBCDIC_CR : '' : PrivateKey );
  PrivateKey = %ScanRpl( EBCDIC_LF : '' : PrivateKey );
  PrivateKey = %ScanRpl( PEM_HEADER : '' : PrivateKey );
  PrivateKey = %ScanRpl( PEM_FOOTER : '' : PrivateKey );

  RXS_ResetDS( Base64DS : RXS_DS_TYPE_CONVERTBASE64 );
  Base64DS.EncodeDecode = RXS_DECODE;
  DecodedKey = RXS_Convert( PrivateKey : Base64DS );

  return DecodedKey;
End-Proc;


Dcl-Proc RS256SignWithDER;
  Dcl-Pi *N Like(RXS_Var4Kv_t);
    pHeaderPayload Like(RXS_Var4Kv_t) Const Options(*Trim);
    pDERKey Like(RXS_Var8Kv_t) Const;
  End-Pi;

  Dcl-Ds ErrorDS LikeDS(RXS_CatchThrowErrorDS_t);

  // Calculate Signature API Prototype
  Dcl-Pr Qc3CalculateSignature ExtProc('Qc3CalculateSignature');
    pData Pointer Options(*String) Value;
    pDataLen Int(10) Const;
    pDataFormat Char(8) Const;
    pAlgorithm Pointer Options(*String) Value;
    pAlgFormat Char(8) Const;
    pKeyDesc Pointer Options(*String) Value;
    pKeyDescFmt Char(8) Const;
    pCryptSrvProv Char(1) Const;
    pCryptDevName Char(10) Options(*Omit) Const;
    pSignature Pointer Value;
    pSignatureSize Int(10) Const;
    pSignatureLen Int(10);
    pQUSEC Pointer Value;
  End-Pr;

  Dcl-C CSP_ANY '0';

  Dcl-C PUBLIC_KEY_CIPHER_RSA 50;
  Dcl-C PKA_FORMAT_PKCS1_01 '1';
  Dcl-C HASH_ALG_SHA_256 3;
  Dcl-C KEY_TYPE_RSA 51;
  Dcl-C KEY_FORMAT_BER '1';

  Dcl-C FORMAT_DATA0100 'DATA0100';

  Dcl-C FORMAT_ALGD0400 'ALGD0400';
  Dcl-Ds ALGD0400_DS_t Qualified Template Inz;
    PublicKeyCipherAlgorithm Int(10);
    PKABlockFormat Char(1);
    *N Char(3) Inz(*Allx'00');
    SigningHashAlgorithm Int(10);
  End-Ds;

  Dcl-C FORMAT_KEYD0200 'KEYD0200';
  Dcl-Ds KEYD0200_DS_t Qualified Template Inz;
    KeyType Int(10);
    KeyLength Int(10);
    KeyFormat Char(1);
    *N Char(3) Inz(*Allx'00');
    KeyString Char(16384) Inz(*Allx'00');
  End-Ds;

  Dcl-Ds QUSEC_t Inz Qualified Template;
    ErrBytesProv Int(10) Inz(%Size(QUSEC_t));
    ErrBytesAvail Int(10);
    ErrMsgID Char(7);
    *N Char(1);
    ErrMsgDta Char(512);
  End-Ds;

  Dcl-Ds ConvCCSIDDS LikeDS(RXS_ConvertCCSIDDS_t);

  Dcl-S HeaderPayloadUTF8 Like(RXS_Var4Kv_t);

  Dcl-Ds ALGD0400 LikeDS(ALGD0400_DS_t) Inz(*LikeDS);
  Dcl-Ds KEYD0200 LikeDS(KEYD0200_DS_t) Inz(*LikeDS);
  Dcl-Ds QUSEC LikeDS(QUSEC_t) Inz(*LikeDS);

  Dcl-S SignatureBuffer Char(4096);
  Dcl-S SignatureBufferLen Int(10);

  reset ALGD0400;
  ALGD0400.PublicKeyCipherAlgorithm = PUBLIC_KEY_CIPHER_RSA;
  ALGD0400.PKABlockFormat = PKA_FORMAT_PKCS1_01;
  ALGD0400.SigningHashAlgorithm = HASH_ALG_SHA_256;

  reset KEYD0200;
  KEYD0200.KeyType = KEY_TYPE_RSA;
  KEYD0200.KeyFormat = KEY_FORMAT_BER;
  KEYD0200.KeyString = pDERKey;
  KEYD0200.KeyLength = %Len(pDERKey);

  RXS_ResetDS( ConvCCSIDDS : RXS_DS_TYPE_CONVERTCCSID );
  ConvCCSIDDS.From = RXS_CCSID_JOB;
  ConvCCSIDDS.To = RXS_CCSID_UTF8;
  HeaderPayloadUTF8 = RXS_Convert( pHeaderPayload : ConvCCSIDDS );

  reset QUSEC;
  Qc3CalculateSignature( %Addr( HeaderPayloadUTF8 : *DATA )
                       : %Len(HeaderPayloadUTF8)
                       : FORMAT_DATA0100
                       : %Addr( ALGD0400 )
                       : FORMAT_ALGD0400
                       : %Addr( KEYD0200 )
                       : FORMAT_KEYD0200
                       : CSP_ANY
                       : *Omit
                       : %Addr(SignatureBuffer)
                       : %Size(SignatureBuffer)
                       : SignatureBufferLen
                       : %Addr(QUSEC) );

  if QUSEC.ErrBytesAvail > 0;
    RXS_ResetDS( ErrorDS : RXS_DS_TYPE_CATCHTHROWERROR );
    ErrorDS.MessageId = 'RXS9898';
    ErrorDS.MessageFile = 'RXSMSGF';
    ErrorDS.MessageType = RXS_MESSAGE_TYPE_ESCAPE;
    ErrorDS.MessageData = 'RS256SignWithDER: ' + %Trim(QUSEC.ErrMsgID) + ' ' + %Trim(QUSEC.ErrMsgDta
    ErrorDS.ThrowToCaller = RXS_YES;
    RXS_Throw( ErrorDS );
    return '';
  endif;

  return %SubSt( SignatureBuffer : 1 : SignatureBufferLen );
End-Proc;

