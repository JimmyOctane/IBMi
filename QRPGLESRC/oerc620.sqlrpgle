       //-------------------------------------------------------------------
       // Program Name - OERC620
       //
¢A     //  Work With Sales Orders
       //
       //-------------------------------------------------------------------
       // TASK       DATE   ID  DESCRIPTION
       //---------- ------ --- ---------------------------------------------
       // 5008      111021 CLP Initial program
¢A     // 5019      020122 CLP -On the initial prompt position curstor on
¢A     //                       order nbr
¢A     //                      -Added selection on tickets printed or not
¢A     //                      -Added selection on picking status
¢A     //                      -Added option 8 to display promised date
¢A     //                       change history
¢B     // 7306      051022 CLP -Corrected the highlighting of the customer
¢B     //                       nbr when missing for job and PO nbr search
¢B     //                      -Replace base PO search pgm OER2055 that
¢B     //                       offers PO list for open and closed orders
¢B     //                       with a new pgm that only offers PO list for
¢B     //                       open orders
¢B     //                      -Added logic here to check password for void
¢B     //                      -If no customer POs for F4 prompt, display a
¢B     //                       message and bypass the prompt
¢C     // 5042      072222 CLP Allow ship br selection without a sell br
¢C     //                      selection
¢D     // 9300      091522 APB DO NOT ALLOW VOID IF PICKING IN PROGRESS
¢E     // 5083      122023 CLP -Issue an error if attempting to maintain an
¢E     //                       an order that is on problem/pricing hold
¢E     //                      -Issue an error if attempting to maintain a
¢E     //                       quote
¢F     // 5084      010524 CLP Removed ¢E changes
¢G     // 5101      061424 CLP Added enrollment logic for direct ship orders
¢H     // CP005186  063026 CLP Added 3rd line on S1 fold for prob/pric hold
¢H     //                       info or anything else needed
¢I     // JJF       073126 JJF Added Ord Status selection for Invoiced orders
¢I     //                       (D1STSI) on the prompt screen. When D1STSI is
¢I     //                       not blank, subfile and related lookups
¢I     //                       (void-check, customer PO count, PO prompt)
¢I     //                       are sourced from OEPTOHY instead of OEPTOH.
¢I     //                       Added Opts(2) compile-time array entry
¢I     //                       ('5=Inquiry') and display logic so only the
¢I     //                       Inquiry option is shown on the C1Opts help
¢I     //                       line when viewing invoiced orders.
       //-------------------------------------------------------------------


       Ctl-Opt option(*srcstmt:*nodebugio) Debug(*yes);
       //-------------------------------------------------------------------
       // Indicators

       // Ind   Function/Description
       // ---   ------------------------------------------------------------
       //  KC   F3=Exit
       //  KD   F4=Prompt
       //  KE   F5=Refresh
       //  KL   F12=Previous

       // 51-74 Screen field errors

       // 75   Display branch in SFL

       // 81   Subfile row Red (orders are on problem/pricing hold)
       // 82   Subfile row Pink (ship branch <> sell branch)
       // 89   Subfile unfolded
       // 90   Display subfile
       // 91   Display subfile control
       // 92   Display 'More...' for multiple subfile pages
       // 96   Delete subfile records

       //-------------------------------------------------------------------

       //== Display File/Primary File ======================================
       Dcl-f OEDC620 workstn infds(@INFWS)
¢A                                         sfile(OEFC620S1:RRN1)
¢A                                         sfile(OEFC620S2:RRN2);
       //-------------------------------------------------------------------

       //== Data Structures ================================================

       // Program Status Information Data Structure
       Dcl-Ds @INFPS ExtName('@INFPS') PSDS End-Ds;

       // Work Station Information Data Structure
       Dcl-Ds @INFWS ExtName('@INFWS') End-Ds;

¢A     // Order data structure
       Dcl-Ds dsCmrOu_1 Qualified Inz;
           oeno01       char(7);
           arnm01       char(30);
           oeno08       packed(3:0);
           oeno16       packed(3:0);
           oemo03       packed(2:0);
           oedy03       packed(2:0);
           oecc03       packed(2:0);
           oeyr03       packed(2:0);
           oemo07       packed(2:0);
           oedy07       packed(2:0);
           oecc07       packed(2:0);
           oeyr07       packed(2:0);
           orddte       char(8);
           prmdte       char(8);
           oecd01       char(1);
           oecd03       char(1);
           oecd08       char(1);
           oecd04       char(1);
¢A         fflsts       char(1);
           arcdc6       char(2);
           oeno07       char(22);
           oeno06       char(7);
           oenm02       char(15);
           oecd65       char(1);
           oecd65c      char(1);
           oecd38       char(1);
           oefl04       char(1);
           oefl05       char(1);
           oecn02       packed(2:0);
       End-Ds;

¢H     Dcl-Ds dsSHPTMTR ExtName('SHPTMTR') Qualified Inz End-Ds;

¢A     // Promise date history data structure
¢A     Dcl-Ds dsCmrOu_2 Qualified Inz;
¢A         oenm18       char(30);
¢A         prmdte       char(8);
¢A         chgdte       char(8);
¢A         chgtme       char(8);
¢A     End-Ds;

       Dcl-Ds LDA Dtaara(*LDA);
          LDAOrder      Char(7);
          LDAPgm        Char(10);
       End-Ds;

       // CCYY Year
       Dcl-Ds dsCCYY Inz;
           CCYY      Zoned(4:0);
            CCYY_CC  Zoned(2:0) Overlay(CCYY:1);
            CCYY_YY  Zoned(2:0) Overlay(CCYY:3);
       End-Ds;

       // Order Date
       Dcl-Ds dsOEDT03 Inz;
           OEDT03    Char(8);
            OECC03   Zoned(2:0) Overlay(OEDT03:5);
            OEYR03   Zoned(2:0) Overlay(OEDT03:7);
            OEMO03   Zoned(2:0) Overlay(OEDT03:1);
            OEDY03   Zoned(2:0) Overlay(OEDT03:3);
       End-Ds;

       // Promise Date
       Dcl-Ds dsOEDT07 Inz;
           OEDT07    Char(8);
            OECC07   Zoned(2:0) Overlay(OEDT07:5);
            OEYR07   Zoned(2:0) Overlay(OEDT07:7);
            OEMO07   Zoned(2:0) Overlay(OEDT07:1);
            OEDY07   Zoned(2:0) Overlay(OEDT07:3);
       End-Ds;

       // TF - TIDS branch and company
       Dcl-Ds *N Inz;
         TF_TbNo03  Char(30);
           TidsBr   Zoned(3:0) Overlay(TF_TbNo03);
           Cmpany   Zoned(3:0) Overlay(TF_TbNo03:*next);
       End-Ds;

       // Customer selections
       Dcl-Ds dsSel Occurs(900) Inz;
           CusNbr   Zoned(6:0);
           CusNme   Char(30);
           CusAdr   Char(30);
       End-Ds;

       // Message field parameters to display messages
       Dcl-Ds *N;
           prMsgParms  Char(157);
            MsgData    Char(100)  Overlay(prMsgParms);
             Parm2     Char(10)   Overlay(MsgData);
             Parm3     Char(10)   Overlay(MsgData:*next);
             Parm4     Char(10)   Overlay(MsgData:*next);
             Parm5     Char(10)   Overlay(MsgData:*next);
             Parm6     Char(10)   Overlay(MsgData:*next);
             Parm7     Char(10)   Overlay(MsgData:*next);
             Parm8     Char(10)   Overlay(MsgData:*next);
             Parm9     Char(10)   Overlay(MsgData:*next);
             Parm10    Char(10)   Overlay(MsgData:*next);
             Parm11    Char(10)   Overlay(MsgData:*next);
            MsgID      Char(7)    Overlay(prMsgParms:*next);
            MsgQueue   Char(10)   Overlay(prMsgParms:*next);
            MsgFile    Char(10)   Overlay(prMsgParms:*next);
            ToPgmQueue Char(10)   Overlay(prMsgParms:*next);
            MsgType    Char(10)   Overlay(prMsgParms:*next);
            ReplyMsg   Char(10)   Overlay(prMsgParms:*next);
       End-Ds;

       // Arrays and Tables ================================================

   ¢A  //Dcl-s Opts        Char(50)  Dim(1)  ctdata;
¢A     Dcl-s Opts        Char(65)  Dim(2)  ctdata;


       // Work Fields ======================================================

       Dcl-s @Count        Packed(7:0);
       Dcl-s AlwEnt        Char(1) inz('Y');
       Dcl-s And           Char(4);
¢G     Dcl-s AuthDirShp    Char(1) Inz('N');
¢G     Dcl-s AuthPrcHld    Char(1) Inz('N');
¢G     Dcl-s AuthprbHld    Char(1) Inz('N');
¢G     Dcl-s AuthQuote     Char(1) Inz('N');
       Dcl-s AuthUpd       Char(1) Inz('N');
       Dcl-s AuthVoid      Char(1) Inz('N');
       Dcl-s AuthReview    Char(1) Inz('N');
       Dcl-s Comma         Char(1);
       Dcl-s Date          Zoned(8:0);

       Dcl-s Day           Zoned(2:0);

       Dcl-s Days          Zoned(5:0);
       Dcl-s Display       Char(1) inz('Y');
       Dcl-s ErrS1         Packed(4:0);
¢B     Dcl-s FromPgm       Char(10) Inz('VOID ORD');
       Dcl-s S1Fold        Char(1);
       Dcl-s JobN          Char(6);
       Dcl-s JobT          Char(6);
       Dcl-s JobName       Char(10);
       Dcl-s JobUser       Char(10);
¢B     Dcl-s LastPWTime    Zoned(6:0);
       Dcl-s LastRRN1      Packed(4:0);
¢A     Dcl-s LastRRN2      Packed(4:0);
¢A     Dcl-s LstS2Pdte     Char(8);
       Dcl-s Month         Zoned(2:0);
       Dcl-s Ndx           Packed(3:0);
       Dcl-s Or            Char(3);
       Dcl-s OrderBy       VarChar(32000) inz;
       Dcl-s EntFr6        Char(6);
       Dcl-s EntFr8        Char(8);
       Dcl-s EntFrDate     Char(8);
       Dcl-s myFileName    varchar(10);
¢B     Dcl-s PassCheck     Char(1);
       Dcl-s PrmFr6        Char(6);
       Dcl-s PrmFr8        Char(8);
       Dcl-s PrmFrDate     Char(8);
       Dcl-s prAppl        Char(2);
¢G     Dcl-s prCde         Char(4);
¢G     Dcl-s prId          Packed(4:0) Inz;
¢G     Dcl-s prUsrVal      Char(10);
¢G     Dcl-s prValFrm      Char(1);
¢G     Dcl-s prRtnCod      Char(1);
       Dcl-s prAuth        Char(1);
       Dcl-s prCompany     Packed(3:0) Inz;
       Dcl-s prCust        Char(6);
       Dcl-s prJob         Char(7);
       Dcl-s prStat        Char(1);
       Dcl-s prPO          Char(22);
       Dcl-s prCustNo      Packed(6:0) Inz;
       Dcl-s prRtnCde      Packed(1:0) Inz;
       Dcl-s prSlsId       Char(3);
       Dcl-s prSlsNm       Char(20);
       Dcl-s prLvl         Char(2);
       Dcl-s prOpt         Char(2);
       Dcl-s prOrder       Char(7);
       Dcl-s prProg        Char(10);
       Dcl-s prScreen      Char(10) Inz('OEFC620D');
       Dcl-s prUser        Char(10);
       Dcl-s prPgmNam      Char(10);
       Dcl-s prBranch      Char(3);
       Dcl-s prBrNo        Packed(3:0) Inz;
       Dcl-s prErrcd       Char(2);
       Dcl-s prJobN        Char(6);
       Dcl-s prJobT        Char(6);
       Dcl-s prPrgNam      Char(10);
       Dcl-s prACT#        Char(1);
       Dcl-s prC@LOC#      Char(6);
       Dcl-s prCFLD#       Char(10);
       Dcl-s prCRCD#       Char(10);
       Dcl-s prVALUE#      Char(9);
       Dcl-s prTxTyp       Char(1);
       Dcl-s prScBran      Packed(3:0) Inz;
       Dcl-s prShpCd       Char(2);
       Dcl-s prSpMtd       Char(1);
       Dcl-s prSCDN01      Char(15);
       Dcl-s ReloadS1      Char(1) Inz('Y');
       Dcl-s RetCod        Packed(1:0) Inz;
       Dcl-s RRN1          Packed(4:0);
¢A     Dcl-s RRN2          Packed(4:0);
       Dcl-s Selectn       Char(32000) inz;
       Dcl-s Screen2Dsp    Char(2);
       Dcl-s Shipping      Char(1);
       Dcl-s StsFrDate     Char(8);
       Dcl-s StsToDate     Char(8);
       Dcl-s S1Bottom      Packed(4:0);
¢A     Dcl-s S2Bottom      Packed(4:0);
       Dcl-s TabCod        Char(4);
       Dcl-s TabDsc        Char(30);
       Dcl-s TabEnt        Char(9);
¢B     Dcl-s ThisPWTime    Zoned(6:0);
¢B     Dcl-s TimeDiff      Packed(6:0);
       Dcl-s TrnNbr        Packed(7:0);
       Dcl-s Today         Date(*iso);
       Dcl-s Valid         Char(1);
       Dcl-s Where         VarChar(32000) inz;
       Dcl-s WrkDte        Char(8);
       Dcl-s WrkSql        Char(3200) inz;
       Dcl-s WrkSql2       Char(1024) inz;

       Dcl-c C_And ' and';
       Dcl-c C_Apos '''';
       Dcl-c C_Asterisk ' *';
       Dcl-c C_ClsPrnth ')';
       Dcl-c C_Comma ',';
       Dcl-c C_GrEqual '>=';
       Dcl-c C_Equal '=';
       Dcl-c C_LtEqual '<=';
       Dcl-c C_OpnPrnth '(';
       Dcl-c C_Or ' or';
       Dcl-c C_OrderBy ' Order by ';
       Dcl-c C_Union ' Union';
       Dcl-c C_Where ' Where ';

       // Define Prototypes ================================================

       // Help text
       Dcl-Pr HTR0010 EXTPGM('HTR0010');
              p_Prog   Char(10);
              p_Screen Char(10);
       End-pr;

       // Clear message subfile
       Dcl-Pr RMVMSGS EXTPGM('RMVMSGS') End-pr;

       // Add messages to message subfile
       Dcl-Pr SNDMSGS EXTPGM('SNDMSGS');
              p_MsgParms  Char(157);
       End-pr;

       // Retrieve TF entries
       Dcl-Pr TBR0101 EXTPGM('TBR0101');
              p_TabDsc  Char(30);
       End-pr;

       // Customer Search
       Dcl-Pr ARR4516 EXTPGM('ARR4516');
              p_dsSel    like(dsSel);
              p_RetCod   Packed(1:0);
              p_AlwEnt   Char(1);
       End-pr;

       // Sales ID Prompt
       Dcl-Pr ARR5410 EXTPGM('ARR5410');
              p_SlsId      Char(3);
              p_Company    Packed(3:0);
              p_BrNo       Packed(3:0);
              p_SlsNm      Char(20);
              p_RtnCde     Packed(1:0);
       End-pr;

       // Branch Prompt
       Dcl-Pr ARR5620 EXTPGM('ARR5620');
              p_Branch     Char(3);
              p_C@LOC#     Char(6);
              p_CRCD#      Char(10);
              p_CFLD#      Char(10);
       End-pr;

       // Job nbr Prompt
       Dcl-Pr ARR5720 EXTPGM('ARR5720');
              p_Cust       Char(6);
              p_Job        Char(7);
              p_C@LOC#     Char(6);
              p_CRCD#      Char(10);
              p_CFLD#      Char(10);
              p_Stat       Char(1);
       End-pr;

       // Customer PO Prompt
   ¢B  //Dcl-Pr OER2055 EXTPGM('OER2055');
   ¢B  //       p_PO         Char(22);
   ¢B  //       p_CustNo     Packed(6:0);
   ¢B  //       p_RtnCde     Packed(1:0);
   ¢B  //End-pr;
¢B     Dcl-Pr OERC033 EXTPGM('OERC033');
¢B            p_CustNo     Packed(6:0);
¢B            p_Br         Packed(3:0);
¢B            p_PO         Char(22);
¢B     End-pr;

       // Ship Code Prompt
       Dcl-Pr OER3110 EXTPGM('OER3110');
              p_TxTyp      Char(1);
              p_ScBran     Packed(3:0);
              p_SpMtd      Char(1);
              p_ShpCd      Char(2);
              p_SCDN01     Char(15);
       End-pr;

¢B     // Password Verification
¢B     Dcl-Pr OPRC0300 EXTPGM('OPRC0300');
¢B            p_PassCheck  Char(1);
¢B            p_FromPgm    Char(10);
¢B     End-pr;

       // Check option authority
       Dcl-Pr OPR0026 EXTPGM('OPR0026');
              p_User  Char(10);
              p_Appl  Char(2);
              p_Lvl   Char(2);
              p_Opt   Char(2);
              p_Auth  Char(1);
       End-pr;

¢G     // Check enrollment authority
¢G     Dcl-Pr OPR8220 EXTPGM('OPR8220');
¢G            p_User   Char(10);
¢G            p_Appl   Char(2);
¢G            p_Cde    Char(4);
¢G            p_Id     Packed(4:0);
¢G            p_UsrVal Char(10);
¢G            p_ValFrm Char(1);
¢G            p_RtnCod Char(1);
¢G     End-pr;

¢A     // Maintain sales order
       Dcl-Pr OECC5006 EXTPGM('OECC5006');
              p_PgmNam   Char(10);
              p_Order    Char(7);
       End-pr;

       // Void sales order
       Dcl-Pr OER2700 EXTPGM('OER2700');
              p_Order    Char(7);
       End-pr;

       // Display sales order
       Dcl-Pr OER6070 EXTPGM('OER6070');
              p_Company  Packed(3:0);
              p_Order    Char(7);
       End-pr;

       // Ship Method Prompt
       Dcl-Pr TBR0060 EXTPGM('TBR0060');
              p_VALUE#     Char(9);
              p_ACT#       Char(1);
              p_C@LOC#     Char(6);
              p_CRCD#      Char(10);
              p_CFLD#      Char(10);
       End-pr;

      **************************************************************************

       // Continue processing until Screen2Dsp is cleared ======================

       Dou Screen2Dsp = *blanks;

         // Display screen formats =============================================

         Select;
           When Screen2Dsp = 'D1';
             Exsr srDsplyD1;
           When Screen2Dsp = 'C1';
             Exsr srDsplyC1;
         Endsl;

       Enddo;

       // Exit the program =====================================================

       *inLR = *on;

       // Initialization =======================================================

       Begsr *inzsr;

         TBR0101 (TabDsc);

         If TabDsc <> *blanks;
           TF_TbNo03 = TabDsc;
         Else;
           *inLR = *on;
           Return;
         Endif;

         // Initialize order prompt format
         Exsr srLoadD1;

         // Message handling defaults
         PgmMsgQ = '*';
         MsgFile = 'ECMMSGF';
         ToPgmQueue = '*PRV';
         MsgType = '*INFO';
         ReplyMsg = '*PGMQ';
         MsgQueue = '*TOPGMQ';
         RMVMSGS ();

         Today = %date();

         JobUser = PSUSNM;
         JobName = PSJBNM;
         Date = %dec(%date());
         Month = %subdt(%date():*M);
         Day = %subdt(%date():*D);
         CCYY = %dec(%subdt(%date():*Y));

¢A       // Check user security for sales order maintenance
         prUser = JobUser;
         prAppl = 'OE';
         prLvl  = '01';
         prOpt  = '05';
         prAuth = ' ';
         OPR0026 (prUser:prAppl:prLvl:prOpt:prAuth);
           AuthUpd = prAuth;

¢G       // Check user security for quotes
¢G       prUser = JobUser;
¢G       prAppl = 'OE';
¢G       prLvl  = '01';
¢G       prOpt  = '06';
¢G       prAuth = ' ';
¢G       OPR0026 (prUser:prAppl:prLvl:prOpt:prAuth);
¢G         AuthQuote = prAuth;

         // Check user security for review orders
         prUser = JobUser;
         prAppl = 'OE';
         prLvl  = '01';
         prOpt  = '02';
         prAuth = ' ';
         OPR0026 (prUser:prAppl:prLvl:prOpt:prAuth);
           AuthReview = prAuth;

¢G       // Check user security for orders on pricing hold
¢G       prUser = JobUser;
¢G       prAppl = 'OE';
¢G       prLvl  = '02';
¢G       prOpt  = '02';
¢G       prAuth = ' ';
¢G       OPR0026 (prUser:prAppl:prLvl:prOpt:prAuth);
¢G         AuthPrcHld = prAuth;

¢G       // Check user security for orders on problem hold
¢G       prUser = JobUser;
¢G       prAppl = 'OE';
¢G       prLvl  = '02';
¢G       prOpt  = '03';
¢G       prAuth = ' ';
¢G       OPR0026 (prUser:prAppl:prLvl:prOpt:prAuth);
¢G         AuthPrbHld = prAuth;

         // Check user security for void function
         prUser = JobUser;
         prAppl = 'OE';
         prLvl  = '02';
         prOpt  = '07';
         prAuth = ' ';
         OPR0026 (prUser:prAppl:prLvl:prOpt:prAuth);
           AuthVoid = prAuth;

¢G       // Check user authority to update direct ship orders
¢G       prUser = JobUser;
¢G       prAppl = 'OE';
¢G       prCde  = 'USID';
¢G       prId   = 8;
¢G       prUsrVal = ' ';
¢G       prValFrm = ' ';
¢G       prRtnCod = ' ';
¢G       OPR8220 (prUser:prAppl:prCde:prId:prUsrVal:prValFrm:prRtnCod);
¢G       If prRtnCod = '0';
¢G         AuthDirShp = prUsrVal;
¢G       Endif;

         // Delete the temporary table
           Exec SQL
             Drop table qtemp/TmpOrders;

¢A       // Create a temporary list of sales orders to be handled
           Exec SQL
             Create table qtemp/TmpOrders as
              (Select h.oeno01,c.arnm01,h.oeno08,h.oeno16,
                h.oemo03,h.oedy03,h.oecc03,h.oeyr03,
                h.oemo07,h.oedy07,h.oecc07,h.oeyr07,
                '        ' as oedt03,'        ' as oedt07,
¢A              h.oecd01,h.oecd03,h.oecd08,h.oecd04,p.fflsts,h.arcdc6,
¢A              h.oeno07,h.oeno06,h.oenm02,h.oecd65,s.oecd65c,h.oecd38,
                h.oefl04,h.oefl05,h.oecn02
               From OEPTOH h inner join ARPMCUS c on h.arno01=c.arno01
¢A              left join OEPCTOH s on h.oeno01=s.oeno01
¢A              left join OEPFFL01 p on h.oeno01=p.oeno01)
             Definition only;

       Endsr;

       // BldOrder by Subroutine ===============================================

       Begsr srBldOrderBy;

         // Build out the order by portion of the SQL based on prompt values
         Clear OrderBy;
         Clear Comma;

         // If selection on region, order by sell branch
         If D1Regn <> *blanks;
           OrderBy = %trimr(OrderBy) + %trim(Comma) + 'oeno08';
         Comma = C_Comma;
         Endif;

         // Always add order by promised date and order date
         OrderBy = %trimr(OrderBy) + %trimr(Comma)
         + 'case oemo07 when 0 '
         + 'then '
         + 'digits(oecc03)||digits(oeyr03)||digits(oemo03)||digits(oedy03) '
         + 'else '
         + 'digits(oecc07)||digits(oeyr07)||digits(oemo07)||digits(oedy07) '
         + 'end';
         Comma = C_Comma;

       Endsr;

       // BldWhere Subroutine ==================================================

       Begsr srBldWhere;

         // Build out the where portion of the SQL based on parameter values
         Clear Where;
         Clear And;
         Clear Or;

         // Add order nbr
         If D1No01 <> *blanks;
           Where = %trimr(Where) + %trimr(And) + ' h.oeno01' +
                   C_Equal + C_Apos + D1No01 + C_Apos;
           And = C_And;
           Or = C_Or;
         Else;

           // Add region
           If D1Regn <> *blanks;
             Where = %trimr(Where) + %trimr(And) + ' b.glcd42' +
                     C_Equal + C_Apos + D1Regn + C_Apos;
             And = C_And;
             Or = C_Or;
           Else;

   ¢C        // Add sell branch
   ¢C        //If D1No08 <> *zeros;
   ¢C        //  Where = %trimr(Where) + %trimr(And) + ' (h.oeno08' +
   ¢C        //          C_Equal + %trim(%char(D1No08));
   ¢C        //  And = C_And;
   ¢C        //  Or = C_Or;
   ¢C        //Endif;
   ¢C
   ¢C        // Add ship branch if specified
   ¢C        //If D1No16 <> *zeros;
   ¢C        //  Where = %trimr(Where) + ' and h.oeno16' +
   ¢C        //          C_Equal + %trim(%char(D1No16)) + ')';
   ¢C        //  And = C_And;
   ¢C        //  Or = C_Or;
   ¢C        //Endif;
   ¢C
   ¢C        // If only sell branch seleted include ship branch if equal to sell branch
   ¢C        //If D1No08 <> *zeros and D1No16 = *zeros;
   ¢C        //  Where = %trimr(Where) + ' or h.oeno16' +
   ¢C        //          C_Equal + %trim(%char(D1No08)) + ')';
   ¢C        //  And = C_And;
   ¢C        //  Or = C_Or;
   ¢C        //Endif;

¢C           // If only sell branch selected include ship branch if equal to sell branch
¢C           If D1No08 <> *zeros and D1No16 = *zeros;
¢C             Where = %trimr(Where) + %trimr(And) + ' (h.oeno08' +
¢C                     C_Equal + %trim(%char(D1No08)) + ' or h.oeno16' +
¢C                     C_Equal + %trim(%char(D1No08)) + ')';
¢C             And = C_And;
¢C             Or = C_Or;
¢C           Endif;
¢C
¢C           // If only ship branch selected
¢C           If D1No16 <> *zeros;
¢C             Where = %trimr(Where) + %trimr(And) + ' h.oeno16' +
¢C                     C_Equal + %trim(%char(D1No16));
¢C             And = C_And;
¢C             Or = C_Or;
¢C           Endif;
¢C
¢C           // If sell branch and ship branch selected
¢C           If D1No08 <> *zeros and D1No16 <> *zeros;
¢C             Where = %trimr(Where) + %trimr(And) + ' (h.oeno08' +
¢C                     C_Equal + %trim(%char(D1No08)) +
¢C                     ' and h.oeno16' + C_Equal + %trim(%char(D1No16)) + ')';
¢C             And = C_And;
¢C             Or = C_Or;
¢C           Endif;

           Endif;

           // Add customer
           If D1Cust <> *zeros;
             Where = %trimr(Where) + %trimr(And) + ' h.arno01' +
                     C_Equal + %char(D1Cust);
             And = C_And;
             Or = C_Or;
           Endif;

           // Add job nbr
           If D1No06 <> *blanks;
             Where = %trimr(Where) + %trimr(And) + ' h.oeno06' +
                     C_Equal + C_Apos + D1No06 + C_Apos;
             And = C_And;
             Or = C_Or;
           Endif;

           // Add job name
           If D1Nm02 <> *blanks;
             Where = %trimr(Where) + %trimr(And) + ' h.oenm02' +
                     C_Equal + C_Apos + D1Nm02 + C_Apos;
             And = C_And;
             Or = C_Or;
           Endif;

           // Add customer PO
           If D1No07 <> *blanks;
             Where = %trimr(Where) + %trimr(And) + ' h.oeno07' +
                     C_Equal + C_Apos + D1No07 + C_Apos;
             And = C_And;
             Or = C_Or;
           Endif;

           // Add entered by
           If D1Id01 <> *blanks;
             Where = %trimr(Where) + %trimr(And) + ' h.oeid01' +
                     C_Equal + C_Apos + D1Id01 + C_Apos;
             And = C_And;
             Or = C_Or;
           Endif;

           // Add sales id
           If D1Id02 <> *blanks;
             Where = %trimr(Where) + %trimr(And) + ' h.oeid02' +
                     C_Equal + C_Apos + D1Id02 + C_Apos;
             And = C_And;
             Or = C_Or;
           Endif;

           // From entered date
           If D1EntFr <> *blanks;
             EntFrDate = %char(%date(EntFr6:*mdy0):*iso0);
             Where = %trimr(Where) + %trimr(And) + ' '
              + 'digits(h.oecc03)||digits(h.oeyr03)||digits(h.oemo03)||'
              + 'digits(h.oedy03) >= '
              + C_Apos + EntFrDate + C_Apos;
             And = C_And;
             Or = C_Or;
             Endif;

             // From promise date
             If D1PrmFr <> *blanks;
               PrmFrDate = %char(%date(PrmFr6:*mdy0):*iso0);
               Where = %trimr(Where) + %trimr(And) + ' '
                + 'digits(h.oecc07)||digits(h.oeyr07)||digits(h.oemo07)||'
                + 'digits(h.oedy07) >= '
                + C_Apos + PrmFrDate + C_Apos;
               And = C_And;
               Or = C_Or;
               Endif;

             // Add ship method
             If D1Cd01 <> *blanks;
               Where = %trimr(Where) + %trimr(And) + ' h.oecd01' +
                       C_Equal + C_Apos + %char(D1Cd01) + C_Apos;
               And = C_And;
               Or = C_Or;
             Endif;

           // Add ship type
           If D1CdC6 <> *blanks;
             Where = %trimr(Where) + %trimr(And) + ' h.arcdc6' +
                     C_Equal + C_Apos + %char(D1CdC6) + C_Apos;
             And = C_And;
             Or = C_Or;
           Endif;

           // Add order type(s)
           Clear Comma;
           If D1TypO <> *blanks or D1TypC <> *blanks or
              D1TypD <> *blanks or D1TypQ <> *blanks;
               Where = %trimr(Where) + %trimr(And) + ' h.oecd08 in (';

             If D1TypO <> *blanks;                                             //Order
               Where = %trimr(Where) + %trim(Comma) + C_Apos + 'O' + C_Apos;
               Comma = C_Comma;
             Endif;
             If D1TypC <> *blanks;                                             //Credit memo
               Where = %trimr(Where) + %trim(Comma) + C_Apos + 'C' + C_Apos;
               Comma = C_Comma;
             Endif;
             If D1TypD <> *blanks;                                             //Debit memo
               Where = %trimr(Where) + %trim(Comma) + C_Apos + 'D' + C_Apos;
               Comma = C_Comma;
             Endif;
             If D1TypQ <> *blanks;                                             //Quote
               Where = %trimr(Where) + %trim(Comma) + C_Apos + 'Q' + C_Apos;
               Comma = C_Comma;
             Endif;

               Where = %trimr(Where) + ')';
               And = C_And;
               Or = C_Or;
             Endif;

           // Add order status(s)
           Clear Comma;

           If D1StsO <> *blanks or D1StsK <> *blanks or
              D1StsN <> *blanks or D1StsR <> *blanks;

              Where = %trimr(Where) + %trimr(And) + ' h.oecd04 in (';


            If D1StsO <> *blanks;                                             //Open
              Where = %trimr(Where) + %trim(Comma) + C_Apos + 'O' + C_Apos;
              Comma = C_Comma;
            Endif;
            If D1StsK <> *blanks;                                             //Reserved
              Where = %trimr(Where) + %trim(Comma) + C_Apos + 'K' + C_Apos;
              Comma = C_Comma;
            Endif;
            If D1StsN <> *blanks;                                             //Pending
              Where = %trimr(Where) + %trim(Comma) + C_Apos + 'N' + C_Apos;
              Comma = C_Comma;
            Endif;
            If D1StsR <> *blanks;                                            //Reviewed
              Where = %trimr(Where) + %trim(Comma) + C_Apos + 'R' + C_Apos;
              Comma = C_Comma;
            Endif;

            Where = %trimr(Where) + ')';
            And = C_And;
            Or = C_Or;
          Endif;


           // Add pricing hold and problem hold if both selected
           If D1Fl05 <> *blanks and D1Fl04 <> *blanks;
             Where = %trimr(Where) + %trimr(And) + ' (h.oefl05' +
                     C_Equal + C_Apos + 'Y' + C_Apos + ' or h.oefl04' +
                     C_Equal + C_Apos + 'Y' + C_Apos + ')';
             And = C_And;
             Or = C_Or;
           Else;

             // Add pricing hold only
             If D1Fl05 <> *blanks;
               Where = %trimr(Where) + %trimr(And) + ' h.oefl05' +
                       C_Equal + C_Apos + 'Y' + C_Apos;
               And = C_And;
               Or = C_Or;
             Endif;

             // Add problem hold only
             If D1Fl04 <> *blanks;
               Where = %trimr(Where) + %trimr(And) + ' h.oefl04' +
                       C_Equal + C_Apos + 'Y' + C_Apos;
               And = C_And;
               Or = C_Or;
             Endif;

¢A           // Printed tickets only
¢A           If D1Prntd = 'Y';
¢A             Where = %trimr(Where) + %trimr(And) + ' h.oecn02>0';
¢A             And = C_And;
¢A             Or = C_Or;
¢A           Endif;
¢A
¢A           // Not printed tickets only
¢A           If D1Prntd = 'N';
¢A             Where = %trimr(Where) + %trimr(And) + ' h.oecn02=0';
¢A             And = C_And;
¢A             Or = C_Or;
¢A           Endif;
¢A
¢A           // Include picking status IP and POD only
¢A           If D1IncIP <> *blanks and D1IncPOD <> *blanks;
¢A             Where = %trimr(Where) + %trimr(And) + ' p.fflsts in (' +
¢A                     C_Apos + 'I' + C_Apos + C_Comma +
¢A                     C_Apos + 'P' + C_Apos + ')';
¢A             And = C_And;
¢A             Or = C_Or;
¢A           Endif;
¢A
¢A           // Include picking status IP only
¢A           If D1IncIP <> *blanks and D1IncPOD = *blanks;
¢A             Where = %trimr(Where) + %trimr(And) + ' p.fflsts' +
¢A                     C_Equal + C_Apos + 'I' + C_Apos;
¢A             And = C_And;
¢A             Or = C_Or;
¢A           Endif;
¢A
¢A           // Include picking status POD only
¢A           If D1IncPOD <> *blanks and D1IncIP = *blanks;
¢A             Where = %trimr(Where) + %trimr(And) + ' p.fflsts' +
¢A                     C_Equal + C_Apos + 'P' + C_Apos;
¢A             And = C_And;
¢A             Or = C_Or;
¢A           Endif;
¢A
¢A           // Exclude picking status IP and POD
¢A           If D1ExcIP <> *blanks and D1ExcPOD <> *blanks;
¢A             Where = %trimr(Where) + %trimr(And) + ' p.fflsts not in (' +
¢A                     C_Apos + 'I' + C_Apos + C_Comma +
¢A                     C_Apos + 'P' + C_Apos + ')';
¢A             And = C_And;
¢A             Or = C_Or;
¢A           Endif;
¢A
¢A           // Exclude picking status IP
¢A           If D1ExcIP <> *blanks and D1ExcPOD = *blanks;
¢A             Where = %trimr(Where) + %trimr(And) + ' p.fflsts<>' +
¢A                     C_Apos + 'I' + C_Apos;
¢A             And = C_And;
¢A             Or = C_Or;
¢A           Endif;
¢A
¢A           // Exclude picking status POD
¢A           If D1ExcPOD <> *blanks and D1ExcIP = *blanks;
¢A             Where = %trimr(Where) + %trimr(And) + ' p.fflsts<>' +
¢A                     C_Apos + 'P' + C_Apos;
¢A             And = C_And;
¢A             Or = C_Or;
¢A           Endif;
           Endif;

         Endif;                                                                //D1No01 <> *blanks

       Endsr;

       // Display selections format (OEFC620C1) ================================
       Begsr srDsplyC1;

         // Load the subfile
         If ReloadS1 = 'Y';
           Exsr srLoadS1;
           ReloadS1 = 'N';
         Endif;

         // If nothing selected, return to the prompt
         If RRN1 = 0;
           Screen2Dsp = 'D1';
           ReloadS1 = 'Y';

           // No records found for display
           MsgData = *blanks;
           MsgID = 'ECM0020';
           SNDMSGS (prMsgParms);
         Endif;

         // Display initial options for display
         If D1STSI <> *blanks;
           C1Opts = Opts(2);
         Else;
           C1Opts = %subst(Opts(1):4);
         Endif;


         // Default to subfile folded format
         *in89 = *off;

¢A       // Display selected sales order subfile format
         Dow Screen2DSP = 'C1';

           // If errors exist, position to first subfile error
           If ErrS1 > 0;
             S1Bottom = ErrS1;
           Endif;

¢A         // Display sales order selections
           *in89 = S1Fold;
           *in90 = *on;
           *in91 = *on;
           *in92 = *on;
           Write SFCMSG;
           Write OEFC620K1;
           Exfmt OEFC620C1;
           *in90 = *off;
           *in91 = *off;
           *in92 = *off;

           // Capture subfile rrn coming in in order to maintain position
           If WSLRRN > *zeros;
             S1Bottom = WSLRRN;
           Endif;

           // Clear message subfile
           RMVMSGS ();

           // Clear error message indicators
           For Ndx = 51 to 70;
             Clear *in(Ndx);
           Endfor;
           Clear ErrS1;

           // If a function key was pressed, execute function requested
           Select;

           // F1=Help
           When *in25 = *on;
             prProg = PsPgnm;
             HTR0010 (prProg:prScreen);
             Leave;

           // F3=Exit
           When *inKC = *on;
             Clear Screen2Dsp;
             Leave;

           // F5=Refresh
           When *inKE = *on;
             Screen2Dsp = 'C1';
             ReloadS1 = 'Y';
             Leave;

           // F12=Previous
           When *inKL = *on;
             Screen2Dsp = 'D1';
             ReloadS1 = 'Y';
   ¢A        //*in50 = *on;                                  //position on sell branch

             // Clear message subfile
             RMVMSGS ();

             // Clear error message indicators
             For Ndx = 51 to 70;
               Clear *in(Ndx);
             Endfor;
             Leave;

           // F20=Fold/Unfold
           When *inKV = *on;
             If S1Fold = *on;
               S1Fold = *off;  // Unfold
             Else;
               S1Fold = *on;   // Fold
             Endif;
             Leave;

           // If no function key was pressed...
           Other;

             // Validate data entered
             Exsr srValidate;

             // If valid, process options
             If Valid = 'Y';
               For RRN1 = 1 to LastRRN1;
                 Chain RRN1 OEFC620S1;
                 *in81 = S1IN81;
                 *in82 = S1IN82;

                 If S1Opt <> *blanks;

                   // Load order nbr and pgm name in LDA
                   LDAOrder = %char(S1No01);
                   LDAPgm = 'OERC620   ';
                   Out LDA;

                   Select;
                     When S1Opt = '2' and S1Cd08 = 'Q';              // Maintain Quotes
                       prPgmNam = 'OER2098';
                       prOrder = S1No01;
                       OECC5006 (prPgmNam:prOrder);
                       ReloadS1 = 'Y';

                     When S1Opt = '2' and S1Cd04 = 'P';              // Maintain Pending
                       prPgmNam = 'OER2090';
                       prOrder = S1No01;
                       OECC5006 (prPgmNam:prOrder);
                       ReloadS1 = 'Y';

                     When S1Opt = '2' and S1Cd04 = 'K';              // Maintain Reserved
                       prPgmNam = 'OER2095';
                       prOrder = S1No01;
                       OECC5006 (prPgmNam:prOrder);
                       ReloadS1 = 'Y';

                     When S1Opt = '2' and S1Fl04 = 'Y';              // Maintain Problem Hold
                       prPgmNam = 'OER2070';
                       prOrder = S1No01;
                       OECC5006 (prPgmNam:prOrder);
                       ReloadS1 = 'Y';

                     When S1Opt = '2' and S1Fl05 = 'Y';              // Maintain Pricing Hold
                       prPgmNam = 'OER2060';
                       prOrder = S1No01;
                       OECC5006 (prPgmNam:prOrder);
                       ReloadS1 = 'Y';

                     When S1Opt = '2'; // Maintain
                       prPgmNam = 'OER2080';
                       prOrder = S1No01;
                       OECC5006 (prPgmNam:prOrder);
                       ReloadS1 = 'Y';

                     When S1Opt = '3'; // Void

¢B                     // Check to see if we need to prompt for password
¢B                     If LastPwTime = *zeros;
¢B                       LastPWTime = %dec(%time());
¢B                     Endif;
¢B                     ThisPWTime = %dec(%time());
¢B                     TimeDiff = ThisPWTime - LastPWTime;
¢B                     If TimeDiff > 100;
¢B                       PassCheck = 'N';
¢B                       Clear LastPWTime;
¢B                     Else;
¢B                       ThisPWTime = LastPWTime;
¢B                     Endif;

¢D                     // Check if order is being picked
¢D                     Exec Sql
¢D                       Select count(*) into :@Count
¢D                       From OEPFFL01
¢D                       Where OENO01=:S1No01 and FFLSTS = 'I';

¢D                     iF @count > 0;
¢D                       MsgData = *blanks;
¢D                       Parm2 = S1No01;
¢D                       MsgID = 'ORD0015';
¢D                       SNDMSGS (prMsgParms);
¢D                     Else;
¢D
¢B                     // Check password
¢B                     If PassCheck <> 'Y';
¢B                       Exsr srPwdChk;
¢B                     Endif;

¢B                     // If password issue, display error and do not void
¢B                     If PassCheck <> 'Y';
¢B                       MsgData = *blanks;
¢B                       Parm2 = S1No01;
¢B                       MsgID = 'ORD0014';
¢B                       SNDMSGS (prMsgParms);
¢B                     Else;
¢B
¢B                       // Process the void
                         prOrder = S1No01;
¢A                       OER2700 (prOrder);

                         // Check to see if the order was voided
                         If D1STSI <> *blanks;
                           Exec Sql
                             Select count(*) into :@Count
                             From OEPTOHY
                             Where OENO01=:S1No01;
                         Else;
                           Exec Sql
                             Select count(*) into :@Count
                             From OEPTOH
                             Where OENO01=:S1No01;
                         Endif;



                         // If the order was voided, reload the subfile
                         If @Count = 0;
                           ReloadS1 = 'Y';
                         Endif;
¢B                     Endif;
¢D                     Endif;

                     When S1Opt = '5'; // Inquiry
                       prCompany = Cmpany;
                       prOrder = S1No01;
                       OER6070 (prCompany:prOrder);

                     When S1Opt = '6';                               // Review
                       //prPgmNam = 'OERC620';
                       prPgmNam = 'OER2050';
                       prOrder = S1No01;
                       OECC5006 (prPgmNam:prOrder);
                       ReloadS1 = 'Y';

                   Endsl;

                   // Clear subfile option and move on to next record
                   Clear S1Opt;
                   Update OEFC620S1;

                 Endif;

               Endfor;

               // Reload the subfile after all options have been processed
               If ReloadS1 = 'Y';
                 Exsr srLoadS1;
                 ReloadS1 = 'N';
               Endif;

               // If nothing to display, return to the prompt
               If RRN1 = 0;
                 Screen2Dsp = 'D1';
                 ReloadS1 = 'Y';

                 // No records found for display
                 MsgData = *blanks;
                 MsgID = 'ECM0020';
                 SNDMSGS (prMsgParms);
               Endif;

             Endif;

           Endsl;

         Enddo;

       Endsr;

¢A     // Display promise date history (OEFC620C2) =============================
¢A     Begsr srDsplyC2;
¢A
¢A       // Load the subfile
¢A         Exsr srLoadS2;
¢A
¢A         // If nothing to display, return to the prompt
¢A         If RRN2 < 2;
¢A           Screen2Dsp = 'C1';
¢A
¢A           // No records found for display
¢A           MsgData = *blanks;
¢A           MsgID = 'ECM0020';
¢A           SNDMSGS (prMsgParms);
¢A         Else;
¢A           Screen2Dsp = 'C2';
¢A
¢A           // Clear message subfile
¢A           RMVMSGS ();
¢A         Endif;
¢A
¢A       // Display history of promised date changes
¢A       Dow Screen2DSP = 'C2';
¢A
¢A         // Display subfile
¢A         *in90 = *on;
¢A         *in91 = *on;
¢A         *in92 = *on;
¢A         Write SFCMSG;
¢A         Write OEFC620K2;
¢A         Exfmt OEFC620C2;
¢A         *in90 = *off;
¢A         *in91 = *off;
¢A         *in92 = *off;
¢A
¢A         // Capture subfile rrn coming in in order to maintain position
¢A         If WSLRRN > *zeros;
¢A           S2Bottom = WSLRRN;
¢A         Endif;
¢A
¢A         // If a function key was pressed, execute function requested
¢A         Select;
¢A
¢A         // F12=Previous
¢A         When *inKL = *on;
¢A           Screen2Dsp = 'C1';
¢A
¢A           // Clear message subfile
¢A           RMVMSGS ();
¢A
¢A           // Clear error message indicators
¢A           For Ndx = 51 to 70;
¢A             Clear *in(Ndx);
¢A           Endfor;
¢A           Leave;
¢A
¢A         Endsl;
¢A
¢A       Enddo;
¢A
¢A     Endsr;

       // Prompt for selections (OEFC620D1) ====================================

       Begsr srDsplyD1;

         // Display selection format

         Dow Screen2DSP = 'D1';

           // If errors exist, do not default cursor position
   ¢A      //If Valid = 'N';
   ¢A      //  *in50 = *off;
   ¢A      //Endif;

           *in90 = *on;
           *in91 = *on;
           *in92 = *on;
           Write SFCMSG;
           Exfmt OEFC620D1;
           *in90 = *off;
           *in91 = *off;
           *in92 = *off;

           // Clear message subfile
           RMVMSGS ();

           // Clear error message indicators
           For Ndx = 51 to 70;
             Clear *in(Ndx);
           Endfor;

           // If a function key was pressed, execute the function
           Select;

             // F3=Exit
             When *inKC;
               Clear Screen2Dsp;
               Leave;

             // F1=Help
             When *in25 = *on;
               prProg = PsPgnm;
               HTR0010 (prProg:prScreen);
               Leave;

             // F4=Prompt
             When *inKD;
               Exsr srPrompt;

             // F5=Refresh
             When *inKE;
               Exsr srLoadD1;
               Leave;

             // If no function key was pressed...
             Other;

   ¢C          // Default TIDS branch if order/customer/sls ID/Ent by not selected
   ¢C          //If D1No08 = *zeros and D1No01 = *blanks and
¢C             // Default TIDS brif ship br/order/customer/sls ID/Ent by not selected
¢C             If D1No08 = *zeros and D1No16 = *zeros and D1No01 = *blanks and
                 D1Cust = *zeros and D1Id01 = *blanks and D1Id02 = *blanks;
                 D1No08 = TIDSbr;
               Endif;

               // Validate data entered
               Exsr srValidate;

               // If data is valid, continue to display records selected
               If Valid = 'Y';
                 Screen2Dsp = 'C1';

                 // Default to subfile folded format
                 S1Fold = *on;
               Endif;

             Endsl;

           Enddo;

       Endsr;

       // Load order selection prompt ==========================================

       Begsr srLoadD1;

         // Clear prompt format
         Clear OEFC620D1;

         // Default TIDS branch
         D1No08 = TIDSbr;

         // Initialize program variables
         Screen2Dsp = 'D1';

         // Position cursor on sell branch
   ¢A    //*in50 = *on;
         Clear Valid;

       Endsr;

       // Load order selection subfile =========================================

       Begsr srLoadS1;

          // Clear subfile
          *in96 = *on;
          Write OEFC620C1;
          *in96 = *off;
          Clear RRN1;

          // Clear the temporary list
            Exec SQL
              Delete from qtemp/TmpOrders;

          // When D1StsI is not blank, use OEPTOHY table instead of OEPTOH
          If D1StsI <> *blanks;
           myFileName =  'OEPTOHY';
          else;
           myFileName =  'OEPTOH';
          endif;

                              // Load subfile records
          Selectn = 'Select h.oeno01,c.arnm01,h.oeno08,h.oeno16,'
                  + 'h.oemo03,h.oedy03,h.oecc03,h.oeyr03,'
                  + 'h.oemo07,h.oedy07,h.oecc07,h.oeyr07,'
                  + 'digits(h.oemo03)||' + C_Apos + '/' + C_Apos + '||'
                  + 'digits(h.oedy03)||' + C_Apos + '/' + C_Apos + '||'
                  + 'digits(h.oeyr03),'
                  + 'digits(h.oemo07)||' + C_Apos + '/' + C_Apos + '||'
                  + 'digits(h.oedy07)||' + C_Apos + '/' + C_Apos + '||'
                  + 'digits(h.oeyr07),'
                  + 'h.oecd01,h.oecd03,h.oecd08,h.oecd04,'
¢A                + 'case when p.fflsts is null then '
¢A                + C_Apos + ' ' +  C_Apos + ' else p.fflsts end,'
                  + 'h.arcdc6,h.oeno07,h.oeno06,h.oenm02,h.oecd65,'
                  + 'case when s.oecd65c is null then '
¢A                + C_Apos + ' ' +  C_Apos + ' else s.oecd65c end,'
¢A                + 'h.oecd38,h.oefl04,h.oefl05,h.oecn02'
                  + ' From ' + %trim(myFileName)
                  + ' h inner join ARPMCUS c on h.arno01=c.arno01'
                  + ' inner join ARPMBCH b on h.oeno08=b.arno16'
¢A                + ' Left join OEPCTOH s on h.oeno01=s.oeno01'
¢A                + ' Left join OEPFFL01 p on h.oeno01=p.oeno01';


          // Start with selections
          WrkSQL = %trimr(Selectn);


          // Build out where clause
          Exsr srBldWhere;

          // Add where clause
          If Where <> *blanks;
             WrkSql = %trimr(WrkSql) + C_Where + %trimr(Where);
          Endif;

         // Isloate positions beyond 1024 in SQL stmt for visibiliy
         WrkSql2 = %subst(WrkSql:1025);

         // Make the selection clause an insert function
         WrkSql = 'Insert into qtemp/TmpOrders (' + %trimr(WrkSql) + ')';

         Exec SQL
           Execute Immediate :WrkSql;

          // Sort the temporary order table for display
          WrkSql = 'Select * from qtemp/TmpOrders ';

          // Build out order by clause
          Exsr srBldOrderBy;

          // Add order by clause
          If OrderBy <> *blanks;
           WrkSql = %trimr(WrkSql) + C_OrderBy + %trimr(OrderBy);
          Endif;

         Exec Sql Declare CmrOu_1 Cursor For MainSelect_1;

         Exec Sql Prepare MainSelect_1 from :WrkSql;

         Exec Sql
           Open CmrOu_1;

           Exec Sql
             FETCH Next From CmrOu_1 into :dsCmrOu_1;

             DoW  SqlCod <> 100;

               // Clear subfile record and prepare to write
               Clear OEFC620S1;

               S1No01 = dsCmrOu_1.oeno01;                //Order nbr
               S1No08 = dsCmrOu_1.oeno08;                //Sell branch
               If dsCmrOu_1.oeno16 = dsCmrOu_1.oeno08;
                 Clear S1No16;
               Else;
                 S1No16 = dsCmrOu_1.oeno16;              //Ship branch
               Endif;
               S1ODte = dsCmrOu_1.OrdDte;                //Order entered date
               If dsCmrOu_1.prmdte <> '00/00/00';
                 S1PDte = %subst(dsCmrOu_1.PrmDte:1:5);  //Order promise date
               Else;
                 Clear dsCmrOu_1.prmdte;
               Endif;
               OeMo03 = dsCmrOu_1.oemo03;         //Order month
               OeDy03 = dsCmrOu_1.oedy03;         //Order day
               OeCC03 = dsCmrOu_1.oecc03;         //Order century
               OeYr03 = dsCmrOu_1.oeyr03;         //Order year
               OeMo07 = dsCmrOu_1.oemo07;         //Order promise month
               OeDy07 = dsCmrOu_1.oedy07;         //Order promise day
               OeCC07 = dsCmrOu_1.oecc07;         //Order promise century
               OeYr07 = dsCmrOu_1.oeyr07;         //Order promise year
               S1Cd01 = dsCmrOu_1.oecd01;         //Ship method
               S1Cd03 = dsCmrOu_1.oecd03;         //Cash or Charge
               S1Cd08 = dsCmrOu_1.oecd08;         //Order type
               Select;
                 When dsCmrOu_1.oecd04 = 'N';     //Pending
                   S1Cd04 = 'P';
                 Other;
                   S1Cd04 = dsCmrOu_1.oecd04;     //Order status
               Endsl;
¢A             S1Lsts = dsCmrOu_1.fflsts;         //Picking status
¢A             If S1Lsts = 'N';
¢A               Clear S1Lsts;
¢A             Endif;
¢A             S1Sts = S1Cd04 + S1Lsts;           //Order status + picking status
               S1CdC6 = dsCmrOu_1.arcdc6;         //Ship type
               S1No07 = dsCmrOu_1.oeno07;         //Customer PO nbr
               S1No06 = dsCmrOu_1.oeno06;         //Job nbr
               S1Nm02 = dsCmrOu_1.oenm02;         //Job name
               S1Nm01 = dsCmrOu_1.arnm01;         //Customer name
               Select;
                 When dsCmrOu_1.oecd65c = 'C';
                   S1Cd65 = dsCmrOu_1.oecd65c;    //Ship complete no BOs
                 When dsCmrOu_1.oecd65 <> 'N';
                   S1Cd65 = dsCmrOu_1.oecd65;     //Ship complete
               Endsl;
               S1Cd38 = dsCmrOu_1.oecd38;         //Credit hold
               S1Fl04 = dsCmrOu_1.oefl04;         //Problem hold
               S1Fl05 = dsCmrOu_1.oefl05;         //Pricing hold
               If dsCmrOu_1.oecn02 > 0;           //Pick ticket print count
                 S1Prntd = 'Y';                   //Picket ticket printed
               Else;
                 S1Prntd = ' ';                   //Picket ticket not printed
               Endif;

               // Use order date if promise date is not present
               If dsCmrOu_1.prmdte = *blanks;
                 WrkDte = dsCmrOu_1.OrdDte;       //Order date
               Else;
                 WrkDte = dsCmrOu_1.prmdte;       //Promise date
               Endif;

               // Add red based on problem/pricing hold flags
               If S1Fl04='Y' or S1Fl05='Y';
                 *in81 = '1';  //red
               Else;
                 *in81 = '0';
               Endif;

               // Add pink if ship branch <> sell branch
               If dsCmrOu_1.oeno16 <> dsCmrOu_1.oeno08;
                 *in82 = '1';  //pink
               Else;
                 *in82 = '0';
               Endif;

¢H             // If order on prb/prc hold, retrieve error message
¢H             If dsCmrOu_1.oefl04 = 'Y' or dsCmrOu_1.oefl05 = 'Y';
¢H
¢H               Clear dsSHPTMTR;
¢H               Eval *in83 = *off;
¢H               Exec Sql
¢H                 Select * into :dsSHPTMTR
¢H                 From SHPTMTR
¢H                 Where LOGTRNTP = 'SO' and LOGFUNC='ON HOLD'
¢H                  and LOGTRNO=:S1No01
¢H                 Order by LOGYR,LOGMO,LOGDY desc
¢H                 Fetch first row only;
¢H
¢H               If dsSHPTMTR.LOGTRNTX <> ' ';
¢H                 If dsSHPTMTR.LOGPGMNM = 'OER2505';
¢H                   dsSHPTMTR.LOGID = 'SO Edit';
¢H                 Endif;

¢H                 S1Msg = %subst(dsSHPTMTR.LOGTRNTX:1:51) + ' '
¢H                  + %trim(dsSHPTMTR.LOGID) + ' '
¢H                  + %char(dsSHPTMTR.LOGMO) + '/'
¢H                  + %char(dsSHPTMTR.LOGDY) + '/'
¢H                  + %char(dsSHPTMTR.LOGYR);
¢H                 Eval *in83 = *on;
¢H               Endif;
¢H             Endif;

               // If too many records to display, let them know
               If RRN1>=9998;
                 Clear MsgData;
                 MsgID = 'GEN9999';
                 SNDMSGS (prMsgParms);
                 Leave;
               Endif;

               // Write subfile record
               RRN1 += 1;
                 S1In81 = *in81;
                 S1In82 = *in82;
               Write OEFC620S1;

               Exec Sql
                 FETCH Next From CmrOu_1 into :dsCmrOu_1;

             EndDo;

           Exec SQL
             Close CmrOu_1;

           LastRRN1 = RRN1;
           S1Bottom = 1;

       Endsr;

¢A     // Load promised date history subfile ===================================
¢A
¢A     Begsr srLoadS2;
¢A
¢A        // Clear subfile
¢A        *in96 = *on;
¢A        Write OEFC620C2;
¢A        *in96 = *off;
¢A        Clear RRN2;
¢A        Clear LstS2PDte;
¢A
¢A        // Load subfile records
¢A        Selectn = 'Select oenm18,'
¢A                + 'digits(h.oemo07)||' + C_Apos + '/' + C_Apos + '||'
¢A                + 'digits(h.oedy07)||' + C_Apos + '/' + C_Apos + '||'
¢A                + 'digits(h.oeyr07),'
¢A                + 'digits(h.oemo30)||' + C_Apos + '/' + C_Apos + '||'
¢A                + 'digits(h.oedy30)||' + C_Apos + '/' + C_Apos + '||'
¢A                + 'digits(h.oeyr30),'
¢A                + 'substr(digits(h.oetm11),1,2)||'
¢A                + C_Apos + ':' + C_Apos + '||'
¢A                + 'substr(digits(h.oetm11),3,2)||'
¢A                + C_Apos + ':' + C_Apos + '||'
¢A                + 'substr(digits(h.oetm11),5,2)'
¢A                + ' From OEPTOHBA h'
¢A                + ' Where oeno01=' + C_Apos + S1No01 + C_Apos
¢A                + ' Order by rrn(h)';
¢A
¢A        // Start with selections
¢A        WrkSQL = %trimr(Selectn);
¢A
¢A       Exec Sql Declare CmrOu_2 Cursor For MainSelect_2;
¢A
¢A       Exec Sql Prepare MainSelect_2 from :WrkSql;
¢A
¢A       Exec Sql
¢A         Open CmrOu_2;
¢A
¢A         Exec Sql
¢A           FETCH Next From CmrOu_2 into :dsCmrOu_2;
¢A
¢A           DoW  SqlCod <> 100;
¢A
¢A             // Clear subfile record and prepare to write
¢A             Clear OEFC620S2;
¢A
¢A             S2PDte = dsCmrOu_2.PrmDte;                //Promise date
¢A             S2Nm18 = dsCmrOu_2.Oenm18;                //Maintained by
¢A             S2CDte = dsCmrOu_2.ChgDte;                //Changed date
¢A             S2CTme = dsCmrOu_2.ChgTme;                //Changed time
¢A
¢A             // Only display records where the promise date was changed
¢A             //If LstS2PDte = *blanks;
¢A               //LstS2PDte = S2PDte;
¢A             //Endif;
¢A
¢A             // Only display records where the promise date was changed
¢A             If S2PDte = LstS2PDte;
¢A               Exec Sql
¢A                 FETCH Next From CmrOu_2 into :dsCmrOu_2;
¢A               Iter;
¢A             Else;
¢A               LstS2PDte = S2PDte;
¢A             Endif;
¢A
¢A             // If too many records to display, let them know
¢A             If RRN2>=9998;
¢A               Clear MsgData;
¢A               MsgID = 'GEN9999';
¢A               SNDMSGS (prMsgParms);
¢A               Leave;
¢A             Endif;
¢A
¢A             // Write subfile record
¢A             RRN2 += 1;
¢A             Write OEFC620S2;
¢A
¢A             Exec Sql
¢A               FETCH Next From CmrOu_2 into :dsCmrOu_2;
¢A
¢A           EndDo;
¢A
¢A         Exec SQL
¢A           Close CmrOu_2;
¢A
¢A         LastRRN2 = RRN2;
¢A         S2Bottom = 1;
¢A
¢A     Endsr;

       // Execute prompt =======================================================

       Begsr srPrompt;

         Select;
           // Prompt for sell branch
           When @fld = 'D1NO08';
             Clear prBranch;
             prC@LOC# = *blanks;
             prCRCD#  = @Rcd;
             prCFLD#  = @Fld;
             ARR5620 (prBranch:prC@Loc#:prCRcd#:prCFld#);

             If prBranch <> *blanks;
               D1No08 = %dec(%trim(prBranch):3:0);
             Endif;

           // Prompt for ship branch
           When @fld = 'D1NO16';
             Clear prBranch;
             prC@LOC# = *blanks;
             prCRCD#  = @Rcd;
             prCFLD#  = @Fld;
             ARR5620 (prBranch:prC@Loc#:prCRcd#:prCFld#);

             If prBranch <> *blanks;
               D1No16 = %dec(%trim(prBranch):3:0);
             Endif;

           // Prompt for Customer
           When @fld = 'D1CUST';
             Clear dsSel;
             ARR4516 (dsSel:RetCod:AlwEnt);
             %occur(dsSel) = 1;
             If RetCod = 0;
               D1Cust = CusNbr;
             Endif;

           // Prompt for customer job nbr
           When @fld = 'D1NO06';

             // Customer is required to prompt for job nbr
             If D1Cust = *zeros;
               Valid = 'N';
   ¢B          //*in54 = *on;
¢B             *in55 = *on;
               MsgData = *blanks;
               MsgID = 'ORD0008';
               SNDMSGS (prMsgParms);
             Else;
               prCust = %char(D1Cust);
               Clear prJob;
               prStat = 'I';
               ARR5720 (prCust:prJob:prC@LOC#:prCRCD#:prCFLD#:prStat);

               If prJob <> *blanks;
                 D1No06 = prJob;
               Endif;
             Endif;

           // Prompt for customer PO
           When @fld = 'D1NO07';

             // Customer is required to prompt for PO
             If D1Cust = *zeros;
               Valid = 'N';
   ¢B          //*in54 = *on;
¢B             *in55 = *on;
               MsgData = *blanks;
               MsgID = 'ORD0009';
               SNDMSGS (prMsgParms);
             Else;
¢B             // Check to see if there are any customer POs for customer
¢B             If D1No08 = 0;
                 If D1STSI <> *blanks;

                   Exec Sql
                     Select count(*) into :@Count
                     From OEPTOHY
                     Where ARNO01=:D1Cust and OENO07<>' ';
                 Else;
¢B                 Exec Sql
¢B                   Select count(*) into :@Count
¢B                   From OEPTOH
¢B                   Where ARNO01=:D1Cust and OENO07<>' ';
                 Endif;
¢B             Else;
                 If D1STSI <> *blanks;
                   Exec Sql
                     Select count(*) into :@Count
                     From OEPTOHY
                     Where ARNO01=:D1Cust and OENO07<>' ' and OENO08=:D1No08;
                 Else;

¢B                 Exec Sql
¢B                   Select count(*) into :@Count
¢B                   From OEPTOH
¢B                   Where ARNO01=:D1Cust and OENO07<>' ' and OENO08=:D1No08;
                 Endif;
¢B             Endif;

¢B
¢B             // If there is nothing to display, issue a msg
¢B             If @Count = 0;
¢B               MsgData = *blanks;
¢B               MsgID = 'ECM0020';
¢B               SNDMSGS (prMsgParms);
¢B             Else;
                 prCustNo = D1Cust;
¢B               prBrNo = D1No08;
                 Clear prPO;
   ¢B            //Clear prRtnCde;
   ¢B            //OER2055 (prPO:prCustNo:prRtnCde);
¢B               OERC033 (prCustNo:prBrNo:prPO);

                 If prPO <> *blanks;
                   D1No07 = prPO;
                 Endif;
¢B             Endif;
             Endif;

           // Prompt for sales ID
           When @fld = 'D1ID02';
             Clear prSlsId;
             Clear prCompany;
             Clear prBrNo;
             Clear prSlsNm;
             Clear prRtnCde;
             ARR5410 (prSlsId:prCompany:prBrNo:prSlsNm:prRtnCde);

             If prSlsId <> *blanks;
               D1Id02 = prSlsId;
             Endif;

           // Ship Method search
           When @fld='D1CD01';

             prVALUE# = *blanks;
             prACT#   = *zeros;
             prC@LOC# = *blanks;
             prCRCD#  = 'OEC2020G  ';
             prCFLD#  = 'OECD01';
             TBR0060 (prValue#:prAct#:prC@LOC#:prCRCD#:prCFLD#);

             If prValue# <> *blanks;
               D1CD01 = prValue#;
             Endif;

           // Ship Code search
           When @fld='D1CDC6';

             prTxTyp  = 'S';
             prScBran = D1No16;
             prSpMtd  = D1Cd01;
             prShpCd  = *blanks;
             prSCDN01 = *blanks;
             OER3110 (prTxTyp:prScBran:prSpMtd:prShpCd:prSCDN01);

             If prShpCd <> *blanks;
               D1CDC6 = prShpCd;
               D1CD01 = prSpMtd;
             Endif;

         Endsl;

       Endsr;

¢B     // Password check for void process ======================================
¢B
¢B     Begsr srPwdChk;
¢B
¢B       FromPgm = 'VOID ORD';
¢B       OPRC0300 (PassCheck:FromPgm);
¢B
¢B     Endsr;

       // Validate entry data ==================================================

       Begsr srValidate;

         // Initialize validation variables
         Valid = 'Y';

         Select;

           // Validate prompt selections
           When Screen2Dsp = 'D1';

             // Validate order nbr
             If D1No01 <> *blanks;

               Exec Sql
                 Select count(*) into :@Count
                 From OEPTOH
                 Where oeno01=:D1No01;

               // Invalid order
               If @Count = 0;
                 Valid = 'N';
                 *in51 = *on;
                 MsgData = *blanks;
                 MsgID = 'ORD0007';
                 SNDMSGS (prMsgParms);
               Endif;
             Else;

               // Validate region
               If D1Regn <> *blanks;

                 Exec Sql
                   Select count(*) into :@Count
                   From ARPMBCH
                   Where glcd42=:D1Regn;

                 // Invalid sell branch
                 If @Count = 0;
                   Valid = 'N';
                   *in52 = *on;
                   MsgData = *blanks;
                   MsgID = 'GEN0021';
                   SNDMSGS (prMsgParms);
                 Endif;
               Endif;

               // Validate sell branch nbr
               If D1No08 <> *zeros;

                 Exec Sql
                   Select count(*) into :@Count
                   From ARPMBCH
                   Where arno16=:D1No08;

                 // Invalid sell branch
                 If @Count = 0;
                   Valid = 'N';
                   *in53 = *on;
                   MsgData = *blanks;
                   MsgID = 'GEN0012';
                   SNDMSGS (prMsgParms);
                 Endif;
               Endif;

               // Validate ship branch nbr
               If D1No16 <> *zeros;

                 Exec Sql
                   Select count(*) into :@Count
                   From ARPMBCH
                   Where arno16=:D1No16;

                 // Invalid ship branch
                 If @Count = 0;
                   Valid = 'N';
                   *in54 = *on;
                   MsgData = *blanks;
                   MsgID = 'GEN0012';
                   SNDMSGS (prMsgParms);
                 Endif;
               Endif;

               // Validate customer nbr
               If D1Cust <> *zeros;

                 Exec Sql
                   Select count(*) into :@Count
                   From ARPMCUS
                   Where arno01=:D1Cust;

                 // Invalid customer nbr
                 If @Count = 0;
                   Valid = 'N';
                   *in55 = *on;
                   MsgData = *blanks;
                   MsgID = 'GEN0013';
                   SNDMSGS (prMsgParms);
                 Endif;
               Else;

                 // Customer required if job nbr is selected
                 If D1No06 <> *blanks;
                   Valid = 'N';
                   *in55 = *on;
                   MsgData = *blanks;
                   MsgID = 'ORD0008';
                   SNDMSGS (prMsgParms);
                 Endif;
               Endif;

               // Validate customer job nbr
               If D1Cust <> *zeros and D1No06 <> *blanks;

                 Exec Sql
                   Select count(*) into :@Count
                   From ARPMJBM
                   Where arno01=:D1Cust and arno06=:D1No06;

                 // Invalid customer job nbr
                 If @Count = 0;
                   Valid = 'N';
                   *in56 = *on;
                   MsgData = *blanks;
                   MsgID = 'ORD0011';
                   SNDMSGS (prMsgParms);
                 Endif;
               Endif;

               // Validate from entered date
               If D1EntFr <> *blanks;
                 If %len(%trim(D1EntFr))=6;
                   EntFr6 = %trim(D1EntFr);
                   Test(DE) *mdy0 EntFr6;
                 Else;
                   Test(DE) *mdy/ D1EntFr;
                   If not %error;
                     EntFr6 = %char(%date(D1EntFr:*mdy/):*mdy0);
                   Endif;
                 Endif;

                 // Invalid entered after date
                 If %error;
                   Valid = 'N';
                   *in57 = *on;
                   MsgData = *blanks;
                   MsgID = 'GEN0010';
                   SNDMSGS (prMsgParms);
                 Else;
                   D1EntFr = %char(%date(EntFr6:*mdy0):*mdy/);
                 Endif;
               Endif;

               // Validate sales ID
               If D1Id02 <> *blanks;

                 Exec Sql
                   Select count(*) into :@Count
                   From ARPMSLS
                   Where arid01=:D1Id02;

                 // Invalid sales ID
                 If @Count = 0;
                   Valid = 'N';
                   *in59 = *on;
                   MsgData = *blanks;
                   MsgID = 'ORD0012';
                   SNDMSGS (prMsgParms);
                 Endif;
               Endif;

               // Validate promised after date
               If D1PrmFr <> *blanks;
                 If %len(%trim(D1PrmFr))=6;
                   PrmFr6 = %trim(D1PrmFr);
                   Test(DE) *mdy0 PrmFr6;
                 Else;
                   Test(DE) *mdy/ D1PrmFr;
                   If not %error;
                     PrmFr6 = %char(%date(D1PrmFr:*mdy/):*mdy0);
                   Endif;
                 Endif;

                 // Invalid from promised date
                 If %error;
                   Valid = 'N';
                   *in60 = *on;
                   MsgData = *blanks;
                   MsgID = 'GEN0010';
                   SNDMSGS (prMsgParms);
                 Else;
                   D1PrmFr = %char(%date(PrmFr6:*mdy0):*mdy/);
                 Endif;
               Endif;

               // Validate ship method is required if ship type is entered
               If D1Cd01 = *blanks and D1CdC6 <> *blanks;
                 Valid = 'N';
                 *in61 = *on;
                 MsgData = *blanks;
                 MsgID = 'ECM0022';
                 SNDMSGS (prMsgParms);
               Endif;

               // Validate ship method
               If D1Cd01 <> *blanks and D1CdC6 = *blanks;

                 Exec Sql
                   Select count(*) into :@Count
                   From OEPMSCD
                   Where oecd01=:D1Cd01;

                 // Invalid ship method
                 If @Count = 0;
                   Valid = 'N';
                   *in62 = *on;
                   MsgData = *blanks;
                   MsgID = 'GEN0016';
                   SNDMSGS (prMsgParms);
                 Endif;
               Endif;

               // Validate ship method and type
               If D1Cd01 <> *blanks and D1CdC6 <> *blanks;

                 Exec Sql
                   Select count(*) into :@Count
                   From OEPMSCD
                   Where oecd01=:D1Cd01 and oecd95=:D1CdC6;

                 // Invalid ship method and type
                 If @Count = 0;
                   Valid = 'N';
                   *in61 = *on;
                   *in62 = *on;
                   MsgData = *blanks;
                   MsgID = 'GEN0018';
                   SNDMSGS (prMsgParms);
                 Endif;
               Endif;

¢A             // Validate printed tickets
¢A             If D1Prntd <> *blanks and D1Prntd <> 'Y' and D1Prntd <> 'N';
¢A               Valid = 'N';
¢A               *in63 = *on;
¢A               MsgData = *blanks;
¢A               MsgID = 'ORD0013';
¢A               SNDMSGS (prMsgParms);
¢A             Endif;

           Endif;

         // Validate subfile entries
         When Screen2Dsp = 'C1';
           If LastRRN1 <> *zeros;
             For RRN1 = 1 to LastRRN1;
               Chain RRN1 OEFC620S1;
               *in81 = S1IN81;
               *in82 = S1IN82;

               // Clear subfile error message indicators (51-70)
               For Ndx = 51 to 70;
                 Clear *in(Ndx);
               Endfor;

               // If entries exist, validate the subfile record
               If S1Opt <> *blanks;

                 Select;

¢A                 // Check authority for sales order maintenance
                   When S1Opt = '2';

                     // Not authorized to option
                     If AuthUpd <> 'Y';
                       Valid = 'N';
                       *in51 = *on;
                       MsgData = *blanks;
                       MsgID = 'GEN0019';
                       SNDMSGS (prMsgParms);
                     Endif;

¢G                   // Not authorized to option
¢G                   If S1Cd01 = 'D' and AuthDirShp <> 'Y';
¢G                     Valid = 'N';
¢G                     *in51 = *on;
¢G                     MsgData = *blanks;
¢G                     MsgID = 'GEN0056';
¢G                     SNDMSGS (prMsgParms);
¢G                   Endif;

¢G                   // Not authorized to order on pricing hold
¢G                   If S1Fl05 = 'Y' and AuthPrcHld <> 'Y';
¢G                     Valid = 'N';
¢G                     *in51 = *on;
¢G                     MsgData = *blanks;
¢G                     MsgID = 'GEN0057';
¢G                     SNDMSGS (prMsgParms);
¢G                   Endif;

¢G                   // Not authorized to order on problem hold
¢G                   If S1Fl04 = 'Y' and AuthPrbHld <> 'Y';
¢G                     Valid = 'N';
¢G                     *in51 = *on;
¢G                     MsgData = *blanks;
¢G                     MsgID = 'GEN0058';
¢G                     SNDMSGS (prMsgParms);
¢G                   Endif;

¢G                   // Not authorized to maintain quotes
¢G                   If S1Cd08 = 'Q' and AuthQuote <> 'Y';
¢G                     Valid = 'N';
¢G                     *in51 = *on;
¢G                     MsgData = *blanks;
¢G                     MsgID = 'GEN0059';
¢G                     SNDMSGS (prMsgParms);
¢G                   Endif;

                     // If invoiced, not eligible to maintain
                     If S1Cd04 = 'I';                                          // Invoiced
                         Valid = 'N';
                         *in51 = *on;
                         MsgData = *blanks;
                         Parm2 = S1No01;
                         MsgID = 'ORD0006';
                         SNDMSGS (prMsgParms);
                       Endif;

                     // If on credit hold, not eligible to maintain
                     If S1Cd38 = 'Y';                                          // Credit hold
                         Valid = 'N';
                         *in51 = *on;
                         MsgData = *blanks;
                         Parm2 = S1No01;
                         MsgID = 'ORD0010';
                         SNDMSGS (prMsgParms);
                       Endif;

                   // Check authority for void
                   When S1Opt = '3';

                     // Not authorized to option
                     If AuthVoid <> 'Y';
                         Valid = 'N';
                         *in51 = *on;
                         MsgData = *blanks;
                         MsgID = 'GEN0019';
                         SNDMSGS (prMsgParms);
                     Else;

                       // Not authorized to void orders in other branches
                       If S1no08 <> TidsBr and S1no16 <> TidsBr;
                           Valid = 'N';
                           *in51 = *on;
                           MsgData = *blanks;
                           Parm2 = %char(%editc(S1No08:'X'));
                           MsgID = 'GEN0020';
                           SNDMSGS (prMsgParms);
                       Endif;
                     Endif;

                       // If invoiced, not eligible to void
                       If S1cd04 = 'I';                                        // Invoiced
                           Valid = 'N';
                           *in51 = *on;
                           MsgData = *blanks;
                           Parm2 = S1No01;
                           MsgID = 'ORD0006';
                           SNDMSGS (prMsgParms);
                         Endif;

                   // Inquiry
                   When S1Opt = '5';

                   // Check authority for review
                   When S1Opt = '6';

                     // Not authorized to option
                     If AuthReview <> 'Y';
                         Valid = 'N';
                         *in51 = *on;
                         MsgData = *blanks;
                         MsgID = 'GEN0019';
                         SNDMSGS (prMsgParms);
                     Else;

                       // If invoiced, not eligible for review
                       If S1cd04 = 'I';                                        // Invoiced
                           Valid = 'N';
                           *in51 = *on;
                           MsgData = *blanks;
                           Parm2 = S1No01;
                           MsgID = 'ORD0006';
                           SNDMSGS (prMsgParms);
                         Endif;

                       // Quote cannot be reviewed
                       If S1cd08 = 'Q';                                        // Quote
                           Valid = 'N';
                           *in51 = *on;
                           MsgData = *blanks;
                           Parm2 = S1No01;
                           MsgID = 'ORD0001';
                           SNDMSGS (prMsgParms);
                         Endif;

                       // If on credit hold, not eligible to review
                       If S1Cd38 = 'Y';                                        // Credit hold
                           Valid = 'N';
                           *in51 = *on;
                           MsgData = *blanks;
                           Parm2 = S1No01;
                           MsgID = 'ORD0010';
                           SNDMSGS (prMsgParms);
                         Endif;

                       // Order not eligible for review, problem hold
                       If S1Fl04 = 'Y';
                           Valid = 'N';
                           *in51 = *on;
                           MsgData = *blanks;
                           Parm2 = S1No01;
                           MsgID = 'ORD0003';
                           SNDMSGS (prMsgParms);
                         Endif;

                       // Order not eligible for review, pricing hold
                       If S1Fl05 = 'Y';
                           Valid = 'N';
                           *in51 = *on;
                           MsgData = *blanks;
                           Parm2 = S1No01;
                           MsgID = 'ORD0002';
                           SNDMSGS (prMsgParms);
                         Endif;

                       // Order not eligible for review, status is reserved
                       If S1Cd04 = 'K';                                        // Reserved
                           Valid = 'N';
                           *in51 = *on;
                           MsgData = *blanks;
                           Parm2 = S1No01;
                           MsgID = 'ORD0004';
                           SNDMSGS (prMsgParms);
                         Endif;

                       // Order not eligible for review, status is pending
                       If S1Cd04 = 'P';                                        // Pending
                           Valid = 'N';
                           *in51 = *on;
                           MsgData = *blanks;
                           Parm2 = S1No01;
                           MsgID = 'ORD0005';
                           SNDMSGS (prMsgParms);
                         Endif;
                       Endif;

¢A                 // Display promised date history
¢A                 When S1Opt = '8';
¢A                   Exsr srDsplyC2;   

                   // Option is invalid
                   Other;
                     Valid = 'N';
                     *in51 = *on;
                     Clear MsgData;
                     MsgID = 'GEN0014';
                     SNDMSGS (prMsgParms);
                     If ErrS1 = 0;
                       ErrS1 = RRN1;
                     Endif;
                 Endsl;

               Endif;

               Update OEFC620S1;

             Endfor;
           EndIf;
         EndSl;

       Endsr;
      *------------------- TABLE FILE CHANGE AREA -----------------------------*
¢A    * Added 8=Prm Date Chgs to Opts(1)
¢I    * Added Opts(2) for Invoiced orders (Inquiry only)
      *------------------------------------------------------------------------*
** Opts - Display file option text
C1-Opt: 2=Maintain  3=Void  5=Inquiry  6=Review  8=Prm Date Chgs
C1-Opt: 5=Inquiry
