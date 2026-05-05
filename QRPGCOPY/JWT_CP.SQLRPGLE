**FREE
//==============================================================================
//   JWT_CP - Copy Member for JWT Service Program
//
//   Purpose: Contains constants, data structures, and prototypes for JWT
//            (JSON Web Token) generation and validation
//
//   Author: System Generated
//   Date: 2026-05-04
//   Version: 1.0
//
//   Dependencies: RXSCB (RXS copybook for JSON/HTTP operations)
//==============================================================================

//------------------------------------------------------------------------------
// JWT Algorithm Constants
//------------------------------------------------------------------------------
Dcl-C JWT_ALGORITHM_HMAC_SHA256 'HS256';
Dcl-C JWT_ALGORITHM_RSA_SHA256 'RS256';
Dcl-C JWT_SEPARATOR '.';

//------------------------------------------------------------------------------
// JWT Data Structure
//------------------------------------------------------------------------------
Dcl-Ds JWT_StructureDS_t Qualified Template;
  Algorithm Like(RXS_Var1Kv_t);
  Secret Like(RXS_Var8Kv_t);
  HeaderCreateDS LikeDS(RXS_CreateJsonDS_t);
  HeaderRootDS LikeDS(RXS_JsonDS_t);
  PayloadCreateDS LikeDS(RXS_CreateJsonDS_t);
  PayloadRootDS LikeDS(RXS_JsonDS_t);
End-Ds;

//------------------------------------------------------------------------------
// JWT Procedure Prototypes
//------------------------------------------------------------------------------

// Initialize JWT structure
Dcl-Pr JWT_Initialize ExtProc('JWT_Initialize');
  pJWT LikeDS(JWT_StructureDS_t);
End-Pr;

// Set JWT algorithm (HS256 or RS256)
Dcl-Pr JWT_SetAlgorithm ExtProc('JWT_SetAlgorithm');
  pAlgorithm VarChar(10) Const Options(*Trim);
  pSecret Like(RXS_Var1Kv_t) Const Options(*Trim);
  pJWT LikeDS(JWT_StructureDS_t);
End-Pr;

// Add string claim to JWT payload
Dcl-Pr JWT_AddClaimString ExtProc('JWT_AddClaimString');
  pName VarChar(50) Const Options(*Trim);
  pValue VarChar(512) Const Options(*Trim);
  pJWT LikeDS(JWT_StructureDS_t);
End-Pr;

// Add numeric claim to JWT payload
Dcl-Pr JWT_AddClaimNumber ExtProc('JWT_AddClaimNumber');
  pName VarChar(50) Const Options(*Trim);
  pValue VarChar(32) Const Options(*Trim);
  pJWT LikeDS(JWT_StructureDS_t);
End-Pr;

// Add boolean claim to JWT payload
Dcl-Pr JWT_AddClaimBoolean ExtProc('JWT_AddClaimBoolean');
  pName VarChar(50) Const Options(*Trim);
  pValue Ind Const;
  pJWT LikeDS(JWT_StructureDS_t);
End-Pr;

// Add null claim to JWT payload
Dcl-Pr JWT_AddClaimNull ExtProc('JWT_AddClaimNull');
  pName VarChar(50) Const Options(*Trim);
  pJWT LikeDS(JWT_StructureDS_t);
End-Pr;

// Generate JWT token string
Dcl-Pr JWT_ToString Like(RXS_Var8Kv_t) ExtProc('JWT_ToString');
  pJWT LikeDS(JWT_StructureDS_t);
End-Pr;

// Get current epoch time with optional offset
Dcl-Pr JWT_GetEpochTime Int(10) ExtProc('JWT_GetEpochTime');
  pOffset Int(10) Const Options(*Omit:*NoPass);
End-Pr;
