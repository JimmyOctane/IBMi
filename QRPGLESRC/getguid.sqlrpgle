    **FREE
    // Control Options
    Ctl-Opt NoMain;
    Ctl-Opt Option(*SrcStmt:*NoDebugIO);
    Ctl-Opt ExtBinInt(*Yes);
    Ctl-Opt DecEdit('0,');
    Ctl-Opt Copyright('East Coast Metals - Generate GUID');

    //******************************************************************************
    // GETGUID - Generate Unique Identifier Service Program
    //
    // Purpose: Returns a unique GUID (Globally Unique Identifier) in standard
    //          format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
    //
    // Author: Jamie Flanary
    // Date: 10/31/17
    //
    // Returns: 36-character GUID string
    //
    //******************************************************************************

    // -------------------- Data Structures --------------------
    Dcl-Ds genuuid_ds Qualified;
      BytesProv Int(10) Inz(%Size(genuuid_ds));
      BytesAvail Int(10) Inz(0);
      Reserved Char(8) Inz(*AllX'00');
      RtnUUID Char(36);
    End-Ds;

    Dcl-Ds guidstd;
      Guidpart1 Char(8) Pos(1);
      dash1 Char(1) Pos(9) Inz('-');
      Guidpart2 Char(4) Pos(10);
      dash2 Char(1) Pos(14) Inz('-');
      Guidpart3 Char(4) Pos(15);
      dash3 Char(1) Pos(19) Inz('-');
      Guidpart4 Char(4) Pos(20);
      dash4 Char(1) Pos(24) Inz('-');
      Guidpart5 Char(12) Pos(25);
    End-Ds;

    // ------------------ Standalone Variables -----------------
    Dcl-S workguid Char(36);
    
    //==============================================================
    //   PROTOTYPES
    //--------------------------------------------------------------

    /Copy qcpysrc,GETGUID_CP

    Dcl-PR Chr2Hex ExtProc('cvthc');
      Tgt Char(65534) Options(*VarSize);
      Src Char(32767) Options(*VarSize);
      TgtLen Int(10) Value;
    End-PR;

    Dcl-PR GenUUID ExtProc('_GENUUID');
      genuuidds LikeDs(genuuid_ds);
    End-PR;

    //==============================================================
    //              PROCEDURE IMPLEMENTATION
    //--------------------------------------------------------------

    Dcl-Proc ReturnGUID Export;
      Dcl-PI *N Char(36);
      End-PI;

      GenUUID(genuuid_ds);
      Chr2hex(workGUID: genuuid_ds.RtnUUID: 36);
      
      // Convert from '94E0E001EF8319CAB8640004AC1436034040'
      // to '94E0E001-EF83-19CA-B864-0004AC143603'
      Guidpart1 = %Subst(workGUID: 1: 8);
      Guidpart2 = %Subst(workGUID: 9: 4);
      Guidpart3 = %Subst(workGUID: 13: 4);
      Guidpart4 = %Subst(workGUID: 17: 4);
      Guidpart5 = %Subst(workGUID: 21: 12);

      WorkGUID = guidstd;
      Return workguid;

    End-Proc ReturnGUID;
