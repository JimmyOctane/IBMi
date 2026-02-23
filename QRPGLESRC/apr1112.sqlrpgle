     H OPTION(*SRCSTMT : *NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - APR1112                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D UPDATE A/P INVOICE                                                    *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    THIS PROGRAM IS USED FOR UPDATING INVOICES.  CERTAIN UPDATING      *
     F*S    IS AVAILABLE ONLY WHEN INVOICES ARE ELIGIBLE ACCORDING TO THE      *
     F*S    STAGE THEY ARE IN. EX.(BEFOR/AFTER APPROVAL)                       *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S   Important: When changing this program, you must also             *
     F*S               review APR1053, APR1111 for possible changes.         *
     F*S   Important: When changing code in this program, PLEASE add        *
     F*S               or change comments that describe the process          *
     F*S               being changed.                                        *
     F*S               A lot of effort went into putting in comments         *
     F*S               to describe the program processes.  This was          *
     F*S               done to help others when putting in updates or        *
     F*S               adding enhancements.                                  *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
DD   F*U 1550000212 060705 140 AP INV JOB LOT DETAIL ENTRY TOTALS              *
DG   F*U 8000009837 020106 140 CHANGES TO REL 11.0 FOR ILE                     *
DH   F*U 1090000316 030606 140 AP INV MAINT AND DATE SHIP REQUIRED             *
DI   F*U 1090000329 031706 070 PAYMENT TYPE CONVERSION CHANGE                  *
DJ   F*U 8000009877 040706 070 DATA BASE CHANGES FOR INV BALANCING             *
DK   F*U 0970000225 052406 248 SESSION OR DEV ERR MATCHED PO SCRN              *
DL   F*E 8000009886 063006 248 Vendor Consigned Inventory                      *
DM   F*U 1350000387 083006 140 PRE-NOTE INV DEFAULTS BACK TO ACH               *
DN   F*E 8000009886 063006 248 Vendor Consigned Inventory                      *
DO   F*U 0970000272 051707 070 INV ENTRY & MULT GL SCRNS INCONSIST             *
DP   F*U 0420000922 101607 070 A/P WRONG COMPANY ERRORS                        *
DQ   F*U 1650000358 121207 914 INCREASE AP SALES TAX FIELD                     *
DR   F*E 8000010294 011708 915 EXPAND FREIGHT AMOUNT FIELDS                    *
DS   F*E 8000010207 022808 168 RECEIVING NOTES TO A/P ENHANCEMENT              *
DT   F*E 8000010289 031108 019 3RD PARTY FREIGHT                               *
DU   F*E 8000010162 041808 914 MINCRONIZE RGA FOR NEXT RELEASE                 *
DW   F*E 8000010414 081808 070 PREVENT FREIGHT MATCHING ON DIRECTS             *
DX   F*U 1430000407 092308 094 INTELLCHIEF CHANGES
DZ   F*U 1110000544 092409 001 Correct erroneous message
D0   F*U 1290000308 100109 171 I/C RE-INDEX CALLED TOO LATE
D1   F*U 0100004996 120309 070 F16 SELECT MATCH LINES NOT WORKING              *
D2   F*U 1430000466 021910 070 ALT VENDOR NOT USED ON PROMPTS                  *
D3   F*U 1220001364 052510 248 A/P Prepaid Sys MSG Not Resetting               *
D4   F*E 9000000141 072110 183 WW DESIGN ENH - COMPLEX OVERLAYS               *
D5   F*E 9000000144 122210 183 CORRECT MSGFLD FROM DISPLAYING ON WRONG SCREEN  *
EA   F*E 9000000139 011711 078 Display align left field on prompt (qqf job)    *
EB   F*E 9000000141 072110 183 MYHD CHANGES - 'RI' ISSUE WITH FIELDS           *
EC   F*U 8000010995 040111 070 CHECKBOX NOT DISPLAY                            *
ED   F*U 1550000265 050311 070 DEBIT MEMO & PROGRESSIVE BILLING                *
EE   F*U 0920000181 050411 002 ALNLFT displayed when not MyHD.                 *
EF   F*U 1550000333 051211 070 ACH INFO MISSING CHANGE INV TO ACH              *
EG   F*U 1730000112 070811 002 Change AUTOAP if PCTL# is not 0.                *
EH   F*U 0100005632 062712 070 REF NUMBER SAME AS INVOICE NUMBER               *
EI   F*E 8000011528 053013 915 SHIP DATE ON DIRECT A/P INVOICE                 *
EJ   F*U 0100005683 082113 070 DEBIT MEMO PAYMENT TYPE BLANK                   *
EK   F*E 1290000340 120913 248 MATCH A/P CREDIT MEMOS TO REBATES               *
EL   F*E 8000011586 080613 915 INTELLICHIEF LICENSE KEY CHECK                  *
EM   F*E 1290000355 061814 248 MATCH REBATES BY COMPANY                        *
EN   F*E 1290000353 021116 248 WAR V3 SPECIAL BUY                              *
EO   F*U 8000011267 022916 200 Add F17 for SmartDistributor                    *
EP   F*E 1290000378 121216 070 WAR V3.5 CHG RCVD DATE TO A/P DATE              *
ER   F*E 1290000481 011018 248 INCREASE SIZE OF A/P FIELDS
ES   F*U 8000012805 022118 070 CHECK FOR DISCOUNT EXCEEDED                     *
ET   F*E 8000012822 031918 070 REMOVE MULTI GL ZERO ENTRIES IN A/P             *
EU   F*U 8000012972 070918 070 A/P INVOICE MULTI G/L ENTRY ISSUE               *
EV   F*E 8000013267 032819 171 EZ AP Interface to A/P System                   *
EX   F*U 0970000818 071019 070 ACH BANK MISSING ON DEBIT MEMOS                 *
EY   F*U 0970000872 111419 070 USER FORCED TO F4 PROMPT FOR VN BNK             *
EZ   F*E 1400000425 090820 007 1099 FLAG ON AP INVOICE                         *
E0   F*E 1290000663 110921 070 A/P PAYMENT RUN CHANGES                         *
E1   F*E 8000014048 102422 171 EZ AP Allow Expense Invoices                    *
E2   F*E 1710001165 032423 097 use master default payment format info          *
E3   F*U 1980000112 092823 275 Correct ref invoice check box                   *
E4   F*E 8000014216 102323 171 ezAP Document server info config                *
FA   F*E 1710001282 022624 035 ENLARGE ARRAYS                                  *
¢A   F*E KSB   1493 041702 KSB GMC/AMN VENDOR USE DIFF VR REC ACCT#            *
¢B   F*E KSB   5213 070208 KSB allow match qty of negative line                *
¢D   F*U KSB   5909 051503 KSB change GMC Dup invoice checking                 *
¢e   F*U KSB   5934 073113 KSB disallow PO# if direct and not tagged           *
¢F   F*U VLG   2055 091123 VLG Added logic to check for customer deposit refund*
¢F   F*U                       GL account and create check notes automatically.*
¢F   F*U                       Also included logic to delete check notes if gl *
¢F   F*U                       account is changed from deposit refund.         *
¢G   F*U VLG   2057 091923 VLG Remove hardcoded GMC duplicate invoice checking *
¢G   F*U                       and implement new logic repurposing the 'N' flg *
¢G   F*U                       to include dup checking with invoice date.      *
¢G   F*U CLP   2057 112423 CLP Remove dead code for legibility                 *
¢H   F*U VLG   2066 011624 VLG Fix discount error not recalculating when amount*
¢H   F*U                       changed to a credit invoice.                    *
¢I   F*U VLG   2069 021224 VLG Add logic to skip the bank screen but add a PF  *
¢I   F*U                       key to allow access to the screen.              *
¢J   F*U VLG   2074 031924 VLG Add logic to retrieve default bank information  *
¢J   F*U                       from table file APBK based on company/vendor    *
¢K   F*U VLG   2082 052124 VLG Fix default bank retreival issue                *
¢L   F*U CLP   5138 032025 CLP Avoid recalculating disc amt for EDI invoices   *
¢M   F*U JJF   3187 021825 JJF Added new header specifications to allow compile in RDOi *
     F*M ----------------------------------------------------------------------*
EK   FPOLTRBM1  UF A E           K DISK    USROPN PREFIX(RB_)
EK   FPOLWRBM1  UF A E           K DISK    USROPN PREFIX(RB_)
     FPOLTOH1   IF   E           K DISK
DD   FPOLTOL1   UF   E           K DISK
     FPOLTRH1   UF   E           K DISK
DT   FPOLTRHC   UF   E           K DISK    RENAME(POFTRH:POFTRHC)
DT   FPOLTRHD   UF   E           K DISK    RENAME(POFTRH:POFTRHD)
     FPOLTVRH1  UF   E           K DISK
     FPOLTVRO1  UF   E           K DISK
     FPOLTVRL1  UF   E           K DISK
     FAPLTINM1  UF A E           K DISK
     F                                     RENAME(APFTINM:APFTINM1)
     FAPLTINM9  UF   E           K DISK
     F                                     RENAME(APFTINM:APFTINM9)
     FAPLWMTH1  UF A E           K DISK
     FAPLWMTH3  IF   E           K DISK
     F                                     RENAME(APFWMTH:APFWMTH3)
     FAPLWMTH4  UF   E           K DISK
     F                                     RENAME(APFWMTH:APFWMTH4)
     FAPLWMTH5  UF   E           K DISK
     F                                     RENAME(APFWMTH:APFWMTH5)
     FAPLWMTH6  IF   E           K DISK
     F                                     RENAME(APFWMTH:APFWMTH6)
     FPOLTRD1   UF   E           K DISK
     F                                     RENAME(POFTRD:POFTRD1)
     FGLLMGRP2  IF   E           K DISK
     FTBLMTBL1  IF   E           K DISK
     FAPLMRSN1  IF   E           K DISK
     FGLLMSTR8  IF   E           K DISK
   DPF*ARLMBCH1  IF   E           K DISK
DP   FARLMBCH4  IF   E           K DISK
     FAPLTNT1   IF   E           K DISK
     FAPLMVGL1  IF   E           K DISK
     FAPLMVEN4  IF   E           K DISK
     F                                     RENAME(APFMVEN:APFMVEN4)
     FAPLMVAD1  IF   E           K DISK
     FAPLMVEN1  UF   E           K DISK
     F                                     RENAME(APFMVEN:APFMVEN1)
DT   FAPLMVEA1  IF   E           K DISK
     FAPLWINH2  IF   E           K DISK
     F                                     RENAME(APFWINH:APFWINH2)
     FAPLWINH5  IF   E           K DISK
     F                                     RENAME(APFWINH:APFWINH5)
     FAPLTINHE  IF   E           K DISK
     F                                     RENAME(APFTINH:APFTINHE)
     FAPLTINH0  IF   E           K DISK
     F                                     RENAME(APFTINH:APFTINH0)
     FAPLTINH6  IF   E           K DISK
     F                                     RENAME(APFTINH:APFTINH6)
¢d ¢GF*APLTINH6Z IF   E           K DISK
¢G   FAPLTINH6Z IF   E           K DISK    PREFIX(TZ_)
¢d   F                                     RENAME(APFTINH:APFTINH6Z)
¢G   FAPLWINH6Z IF   E           K DISK    PREFIX(WZ_)
¢G   F                                     RENAME(APFWINH:APFWINH6Z)
     FAPLTINH1  UF   E           K DISK
     F                                     RENAME(APFTINH:APFTINH1)
     FAPLWINHR  IF   E           K DISK
     F                                     RENAME(APFTINH:APFTINHR)
     F                                     RENAME(APFWINH:APFWINHR)
     FAPLTINO1  UF A E           K DISK
     FAPLTINP1  UF A E           K DISK
     FAPLTINN1  UF A E           K DISK
     FAPLTING1  UF A E           K DISK
     FAPLTINI1  UF A E           K DISK
     F                                     RENAME(APFTINI:APFTINI1)
     FAPLTINI3  IF   E           K DISK
     F                                     RENAME(APFTINI:APFTINI3)
     FAPLMBNK2  IF   E           K DISK
     FAPLMBNK1  IF   E           K DISK
     F                                     RENAME(APFMBNK:APFMBNK1)
     FOPLMSEC1  IF   E           K DISK
     FAPD1112   CF   E             WORKSTN
     F                                     INFDS(FIL1DS)
     F                                     SFILE(APS1112B:RNB)
     F                                     SFILE(APS1112E:RNE)
     F                                     SFILE(APS1112H:RNH)
     F                                     SFILE(APS1112I:RNI)
     F                                     SFILE(APS1112J:RNJ)
     F                                     SFILE(APS1112N:RNN)
     F                                     SFILE(APS1112O:RNO)
     F                                     SFILE(APS1112P:RNP)
     F                                     SFILE(APS1112Q:RNQ)
     F                                     SFILE(APS1112S:RNS)
     F                                     SFILE(APS112S2:RNS2)
     F                                     SFILE(APS112S3:RNS3)
     F                                     SFILE(APS1112T:RRNT)
      *------------------------------------------------------------------------*
   DGD*NOT             S             75    DIM(20)
DG FAD*NTE             S             75    DIM(20)
   FAD*CKN             S             75    DIM(20)
FA   D NTE             S             75    DIM(98)
FA   D CKN             S             75    DIM(98)
     D ARY             S              1    DIM(102) CTDATA PERRCD(51)
   DTD*STS             S             17    DIM(6) CTDATA PERRCD(1)
DT   D STS             S             17    DIM(12) CTDATA PERRCD(1)
   DLD*EMS             S             78    DIM(124) CTDATA PERRCD(1)
DL DTD*EMS             S             78    DIM(125) CTDATA PERRCD(1)
DT DUD*EMS             S             78    DIM(132) CTDATA PERRCD(1)
DU   D EMS             S             78    DIM(133) CTDATA PERRCD(1)
   DKD*UMS             S             78    DIM(35) CTDATA PERRCD(1)             MESSAGES
DK DPD*UMS             S             78    DIM(36) CTDATA PERRCD(1)             MESSAGES
DP   D UMS             S             78    DIM(39) CTDATA PERRCD(1)             MESSAGES
     D HDG             S             32    DIM(5) CTDATA PERRCD(1)
     D SEC             S              3  0 DIM(999)
     D VNB             S              7  0 DIM(999)
     D VCB             S              7  0 DIM(999)
     D VNA             S              7  0 DIM(999)
     D VCA             S              7  0 DIM(999)
     D VNT             S              1    DIM(14)
     D APN             S              1    DIM(77)
     D FMS             S             17    DIM(2) CTDATA PERRCD(1)
¢e   D CMS             S             78    DIM(1) CTDATA PERRCD(1)
ER   DINVN             S                   LIKE(APNO11)
ER   DIVAMT            S                   LIKE(APAM04)
EA EED*svIn34          s               n
DX    /INCLUDE QCPYSRC,HDYPROTO
EL    /include QCPYSRC,MNYPROTO
     D                SDS
     D  PROG                   1      8
D4   D  QQF                  244    246
     D  DSPERR                91    160
     D  USRNM                254    263
     D FIL1DS          DS
     D  SCREEN               261    268
     D  C@LOC                370    371B 0
     D  SCRRN                378    379B 0
     D ADDON           DS                  INZ
     D  IMAGE                 10     10
     D LDADTA          DS
     D  PBTH                   1      7  0
     D  PVND                   8     13  0
   ERD* PINV                  14     25
     D  PTYP                  26     28
     D  CKCO                 101    103  0
     D  CKBANK               104    105  0
     D  CKRUN                106    110  0
     D  CKCHK                111    117  0
     D  CKCTL                118    124  0
     D  CKTYP                125    127
ER   D  PINV                 150    171
     D                 DS                  INZ
     D  APMO04                 1      2  0
     D  APDY04                 3      4  0
     D  APYR04                 5      6  0
     D  INVDAT                 1      6  0
     D                 DS                  INZ
     D  APCC08                 1      2  0
     D  APYR08                 3      4  0
     D  APMO08                 5      6  0
     D  APDY08                 7      8  0
     D  CHKDTX                 1      8  0
     D                 DS                  INZ
     D  AXMO04                 1      2  0
     D  AXDY04                 3      4  0
     D  AXYR04                 5      6  0
     D  INVDTN                 1      6  0
     D                 DS                  INZ
     D  AXMO06                 1      2  0
     D  AXDY06                 3      4  0
     D  AXYR06                 5      6  0
     D  DUEDTN                 1      6  0
     D                 DS                  INZ
     D  POMO06                 1      2  0
     D  PODY06                 3      4  0
     D  POYR06                 5      6  0
     D  PDUDTE                 1      6  0
     D  POCC06                 7      8  0
     D                 DS                  INZ
     D  INVMO                  1      2  0
     D  INVDY                  3      4  0
     D  INVYR                  5      6  0
     D  INVDTC                 1      6  0
     D  INVCC                  7      8  0
     D                 DS                  INZ
     D  DSHMO                  1      2  0
     D  DSHDY                  3      4  0
     D  DSHYR                  5      6  0
     D  DSHDTC                 1      6  0
     D  DSHCC                  7      8  0
     D                 DS                  INZ
     D  PPMO                   1      2  0
     D  PPDY                   3      4  0
     D  PPYR                   5      6  0
     D  PPDAT                  1      6  0
     D  PPCC                   7      8  0
     D                 DS                  INZ
     D  RECMO                  1      2  0
     D  RECDY                  3      4  0
     D  RECYR                  5      6  0
     D  RECDTC                 1      6  0
     D  RECCC                  7      8  0
     D                 DS                  INZ
     D  DUEMO                  1      2  0
     D  DUEDY                  3      4  0
     D  DUEYR                  5      6  0
     D  DUEDTC                 1      6  0
     D  DUECC                  7      8  0
     D                 DS                  INZ
     D  DSCMO                  1      2  0
     D  DSCDY                  3      4  0
     D  DSCYR                  5      6  0
     D  DSCDTC                 1      6  0
     D  DSCCC                  7      8  0
     D                 DS                  INZ
     D  ACTMOC                 1      2  0
     D  ACTYRC                 3      4  0
     D  ACTDTC                 1      4  0
     D  ACTCCC                 5      6  0
     D                 DS                  INZ
     D  CHKMO                  1      2  0
     D  CHKDY                  3      4  0
     D  CHKYR                  5      6  0
     D  CHKDTC                 1      6  0
     D  CHKCC                  7      8  0
     D                 DS                  INZ
     D  VNNO06                 1      3  0
     D  VNNO02                 4      5  0
     D  VNNO03                 6      9  0
     D  VNNO04                10     12  0
     D  VNGLNO                 1     12  0
     D                 DS                  INZ
     D  GLNO06                 1      3  0
     D  GLNO02                 4      5  0
     D  GLNO03                 6      9  0
     D  GLNO04                10     12  0
     D  GLNO                   1     12  0
     D                 DS                  INZ
     D  GNO06C                 1      3  0
     D  GNO02C                 4      5  0
     D  GNO03C                 6      9  0
     D  GNO04C                10     12  0
     D  GLNOC                  1     12  0
     D  GLNOC2                 4     12  0
¢F   D  GLMNSUB                6     12  0
     D                 DS                  INZ
     D  GXNO06                 1      3  0
     D  GXNO02                 4      5  0
     D  GXNO03                 6      9  0
     D  GXNO04                10     12  0
     D  GLNOR                  1     12  0
     D                 DS                  INZ
     D  GNO06J                 1      3  0
     D  GNO02J                 4      5  0
     D  GNO03J                 6      9  0
     D  GNO04J                10     12  0
     D  GLNOJ                  1     12  0
     D  GLNOJ2                 4     12  0
     D                 DS                  INZ
     D  GLNO36                 1      3  0
     D  GLNO32                 4      5  0
     D  GLNO33                 6      9  0
     D  GLNO34                10     12  0
     D  GRPGL                  1     12  0
     D                 DS                  INZ
     D  AINO36                 1      3  0
     D  AINO32                 4      5  0
     D  AINO33                 6      9  0
     D  AINO34                10     12  0
     D  AIPGL                  1     12  0
     D  AIPGL2                 4     12  0
DT   D                 DS                  INZ
DT   D  AINO36_F               1      3  0
DT   D  AINO32_F               4      5  0
DT   D  AINO33_F               6      9  0
DT   D  AINO34_F              10     12  0
DT   D  AIPGL_F                1     12  0
DT   D  AIPGL2_F               4     12  0
EK   D                 DS                  INZ
EK   D  RBNO36                 1      3  0
EK   D  RBNO32                 4      5  0
EK   D  RBNO33                 6      9  0
EK   D  RBNO34                10     12  0
EK   D  RBDGL                  1     12  0
EK   D  RBDGL2                 4     12  0
EN   D                 DS                  INZ
EN   D  RBNO36_S               1      3  0
EN   D  RBNO32_S               4      5  0
EN   D  RBNO33_S               6      9  0
EN   D  RBNO34_S              10     12  0
EN   D  RBDGL_S                1     12  0
EN   D  RBDGL2_S               4     12  0
     D                 DS                  INZ
     D  VRNO36                 1      3  0
     D  VRNO32                 4      5  0
     D  VRNO33                 6      9  0
     D  VRNO34                10     12  0
     D  VRRGL                  1     12  0
     D  VRRGL2                 4     12  0
     D TBAP03          DS                  INZ
     D  TBMEDP                 1      1
     D  TBEXPS                 2      2
     D                 DS                  INZ
     D  CDDATE                 1      6  0
     D  APMOCD                 1      2  0
     D  APCCCD                 3      4  0
     D  APYRCD                 5      6  0
     D  APCCYR                 3      6  0
     D                 DS                  INZ
     D  DATYP                  1      1  0
     D  DATE2                  2      3  0
     D  DATE4                  4      7  0
     D  DATE6                  8     13  0
     D  DATE8                 14     21  0
     D  DACEN                 22     23  0
     D  DS2000                 1     23  0
     D                 DS
     D  TABTRM                 1     30
     D  T1INDY                 1      2  0
     D  T1DUDY                 3      4  0
     D  T1INCR                 5      5  0
     D  TRM1                   1      5
     D  T2INDY                 7      8  0
     D  T2DUDY                 9     10  0
     D  T2INCR                11     11  0
     D  TRM2                   7     11
     D  T3INDY                13     14  0
     D  T3DUDY                15     16  0
     D  T3INCR                17     17  0
     D  TRM3                  13     17
     D  T4INDY                19     20  0
     D  T4DUDY                21     22  0
     D  T4INCR                23     23  0
     D  TRM4                  19     23
     D  T5INDY                25     26  0
     D  T5DUDY                27     28  0
     D  T5INCR                29     29  0
     D  TRM5                  25     29
     D PAYS            DS                  OCCURS(20) INZ
   ERD* AM12D                  1      9  2
ER   D  AM12D                              LIKE(APAM12)
     D  PAYMOD                10     11  0
     D  PAYDYD                12     13  0
     D  PAYYRD                14     15  0
   ERD* AM16D                 16     24  2
ER   D  AM16D                              LIKE(APAM16)
   DRD* AM18D                 25     30  2
DR ERD* AM18D                 25     32  2
ER   D  AM18D                              LIKE(APAM18)
   DQD* AM17D                 31     36  2
   DQD* AM19D                 37     43  2
   DQD* AM27D                 44     49  2
   DQD* PAYCCD                50     51  0
   DQD* AM37D                 52     57  2
DQ DRD* AM17D                 31     37  2
DQ DRD* AM19D                 38     44  2
DQ DRD* AM27D                 45     50  2
DQ DRD* PAYCCD                51     52  0
DQ DRD* AM37D                 53     58  2
DR ERD* AM17D                 33     39  2
ER   D  AM17D                              LIKE(APAM17)
DR ERD* AM19D                 40     46  2
ER   D  AM19D                              LIKE(APAM19)
DR ERD* AM27D                 47     52  2
ER   D  AM27D                              LIKE(APAM27)
DR   D  PAYCCD                53     54  0
DR ERD* AM37D                 55     60  2
ER   D  AM37D                              LIKE(APAM37)
     D                 DS                  INZ
     D  PAYDTI                 1      6  0
     D  PAYMO                  1      2  0
     D  PAYDY                  3      4  0
     D  PAYYR                  5      6  0
     D  PAYCC                  7      8  0
     D  PAYDT2                 1      8  0
     D                 DS                  INZ
     D  CRAPMO                 1      2  0
     D  CRAPCC                 3      4  0
     D  CRAPYR                 5      6  0
     D  CRAPCY                 3      6  0
     D                 DS                  INZ
     D  CRPDCC                 1      2  0
     D  CRPDYR                 3      4  0
     D  CRPDMO                 5      6  0
     D  CURPRD                 1      6  0
     D                 DS                  INZ
     D  DUEMOM                 1      2  0
     D  DUEDYM                 3      4  0
     D  DUEYRM                 5      6  0
     D  DUEDTM                 1      6  0
     D  DUECCM                 7      8  0
     D                 DS                  INZ
     D  CLCMO                  1      2  0
     D  CLCDY                  3      4  0
     D  CLCYR                  5      6  0
     D  CLCDT                  1      6  0
     D                 DS                  INZ
     D  CMPCC1                 1      2  0
     D  CMPYR1                 3      4  0
     D  CMPMO1                 5      6  0
     D  CMPPD1                 1      6  0
     D  CMPDY1                 7      8  0
     D  CMPDT1                 1      8  0
     D                 DS                  INZ
     D  CMPCC2                 1      2  0
     D  CMPYR2                 3      4  0
     D  CMPMO2                 5      6  0
     D  CMPPD2                 1      6  0
     D  CMPDY2                 7      8  0
     D  CMPDT2                 1      8  0
     D                 DS                  INZ
     D  CMPCC3                 1      2  0
     D  CMPYR3                 3      4  0
     D  CMPMO3                 5      6  0
     D  CMPDY3                 7      8  0
     D  CMPDT3                 1      8  0
     D                 DS
   ERD* IVAMT                  1      9  2
   ERD* INVA                   1      9
     D HXNORM          C                   CONST(X'20')
     D HXRI            C                   CONST(X'21')
     D HXND            C                   CONST(X'27')
     D                 DS                  INZ
     D  NO06P                  1      3  0
     D  NO02P                  4      5  0
     D  NO03P                  6      9  0
     D  NO04P                 10     12  0
     D  GLNOP                  1     12  0
     D  GLNOP2                 4     12  0
     D                 DS                  INZ
     D  NO06S2                 1      3  0
     D  NO02S2                 4      5  0
     D  NO03S2                 6      9  0
     D  NO04S2                10     12  0
     D  GLNOS2                 1     12  0
     D                 DS                  INZ
     D  NO06S3                 1      3  0
     D  NO02S3                 4      5  0
     D  NO03S3                 6      9  0
     D  NO04S3                10     12  0
     D  GLNOS3                 1     12  0
     D RSNDS           DS                  INZ
     D  DSPRSN                 1      1
     D  REQRSN                 2      2
     D PM0810        E DS                  EXTNAME(OPPW810)
DT    *------------------------------------------
DT    * Data being passed for freight matching...
DT    *------------------------------------------
DT   D F_DATA          DS           256
DT   D  F_CO                               LIKE(PONO22)
DT   D  F_VEND                             LIKE(APNO01)
DT   D  F_PO                               LIKE(PONO01)
DT   D  F_RCVR                             LIKE(PONO19)
DT   D  F_BR                               LIKE(PONO22)
DT   D  F_INV                              LIKE(APNO11)
DT   D  F_CTL                              LIKE(APNO63)
DT   D  VARCDE_F                      1
DT ERD* F_FRTAMT                           LIKE(POAM97) INZ(0)
ER   D  F_FRTAMT                           LIKE(APAM13) INZ(0)
DT   D  F_INDCDE                      1
DT   D  F_FRTONL                      1
DT   D  F_FKEY                        1
DT    *----------------------
DT    * Stand alone fields...
DT    *----------------------
DT   D pretcd          s              1
DT   D pactcd          s              2
DT   D pfunky          s              2
DT   D pdata           s            256
EK   D rbTrnType       s                   like(RB_POCD80) inz('CR')
ET   D amt0Wrn         S               N   INZ(*OFF)
ET   D amt0Found       S               N   INZ(*OFF)
E0   D PMTRUN          S               N   INZ(*OFF)
E0   D I_MODE          S              1    INZ('I')
E0   D O_YN            S              1
EK    *-------------------------------------
EK    * Data being passed to/from APR1088...
EK    *-------------------------------------
EK   D pData1088       DS           256
EK   d  r_trnTyp                      2    inz
EK   d  r_vnd#                        6  0 inz
EK   d  r_ctl#                        7  0 inz
EK ERd* r_inv#                       12    inz
ER   d  r_inv#                             like(APNO11) inz
EK   d  r_varc                        1    inz
EK ERd* r_tranamt                     9  2 inz
ER   d  r_tranamt                    11  2 inz
EK   d  r_indcde                      1    inz
EK   d  r_frtonl                      1    inz
EK   d  r_fkey                        1    inz
EM   d  cmp#1088                      3  0 inz
EK    *-------------------------------------
EK    * Data being passed to/from APR1087...
EK    *-------------------------------------
EK   d pData1087       ds           256
EK   d  trnTyp1087                    2    inz
EK   d  vnd#1087                      6  0 inz
EK   d  ctl#1087                      7  0 inz
EM   d  cmp#1087                      3  0 inz
¢J    *--------------------------
¢J    * Bank Master Lookup    ...
¢J    *--------------------------
¢J   D BnkMst          DS             6
¢J   D  BnkCo                         3
¢K   D  BnkTyp                        3
EB ECD*Apnt01sv        s                   like(Apnt01) inz
EB ECD*Stsnotsv        s                   like(Stsnot) inz
EB ECD*Vndnotsv        s                   like(Vndnot) inz
EB ECD*Refnotsv        s                   like(Refnot) inz
EL    *
EL   d p1300App        s             10    inz('DII')
EL   d p1300Bypass     s              1    inz('N')
EL    *
ES   D wrkDisAmt1      S                   LIKE(APAM04)
ES   D wrkDisAmt2      S                   LIKE(APAM04)
¢F   D glDepRef        S              7  0 INZ(2350011)
¢F   D cknotfnd        S              1n   INZ('1')
      *------------------------------------------------------------------------*
DJ   IPOFTRD1
DJ   I              IVNON1                      I1NON1
     IAPFMVEN4
     I              APCD25                      CD25M
     I              APPC01                      PC01M
     I              APPC40                      PC40M
     I              APNO25                      NO25M
     I              GLNO01                      NO01M
     I              GLNO02                      VNNO02
     I              GLNO03                      VNNO03
     I              GLNO04                      VNNO04
     I              GLNO06                      VNNO06
     I              APCD59                      CD59M
     I              APCD66                      CD66M
     I              APNO52                      NO52M
     I              APNO53                      NO53M
     I              APCD73                      CD73M
     IAPFMVEN1
     I              APCD25                      CD25F
     I              APPC01                      PC01F
     I              APPC40                      PC40F
     I              APNO25                      NO25F
     I              GLNO01                      NO01F
     I              GLNO02                      NO02F
     I              GLNO03                      NO03F
     I              GLNO04                      NO04F
     I              GLNO06                      NO06F
     I              APCD59                      CD59F
     I              APCD66                      CD66F
     I              APNO52                      NO52F
     I              APNO53                      NO53F
     I              APCD73                      CD73F
     IAPFTINP
     I              APNO13                      PNO13
     IAPFWINH2
     I              APAD04                      AXAD04
     I              APAD05                      AXAD05
     I              APAD06                      AXAD06
     I              APAM04                      AXAM04
     I              APAM05                      AXAM05
     I              APAM40                      AXAM40
     I              APAM06                      AXAM06
     I              APAM13                      AXAM13
     I              APAM14                      AXAM14
     I              APAM26                      AXAM26
     I              APCD04                      AXCD04
     I              APCD09                      AXCD09
     I              APCD10                      AXCD10
     I              APCD12                      AXCD12
     I              APCD16                      AXCD16
     I              APCD21                      AXCD21
     I              APCD22                      AXCD22
     I              APCD25                      AXCD25
     I              APCD26                      AXCD26
     I              APCD29                      AXCD29
     I              APCD43                      AXCD43
     I              APCY02                      AXCY02
     I              APDY01                      AXDY01
     I              APDY04                      AXDY04
     I              APDY05                      AXDY05
     I              APDY06                      AXDY06
     I              APDY08                      AXDY08
     I              APDY11                      AXDY11
     I              APDY14                      AXDY14
     I              APFL01                      AXFL01
     I              APMO01                      AXMO01
     I              APMO04                      AXMO04
     I              APMO05                      AXMO05
     I              APMO06                      AXMO06
     I              APMO08                      AXMO08
     I              APMO11                      AXMO11
     I              APMO12                      AXMO12
     I              APMO14                      AXMO14
     I              APNM04                      AXNM04
     I              APNO01                      AXNO01
     I              APNO11                      AXNO11
     I              APNO13                      AXNO13
     I              APNO14                      AXNO14
     I              APNO15                      AXNO15
     I              APNO16                      AXNO16
     I              APNO17                      AXNO17
     I              APNO20                      AXNO20
     I              APNO21                      AXNO21
     I              APNO25                      AXNO25
     I              APNO26                      AXNO26
     I              APNO35                      AXNO35
     I              APNO38                      AXNO38
     I              APPC01                      AXPC01
     I              APPC40                      AXPC40
     I              APST02                      AXST02
     I              APYR01                      AXYR01
     I              APYR04                      AXYR04
     I              APYR05                      AXYR05
     I              APYR06                      AXYR06
     I              APYR08                      AXYR08
     I              APYR11                      AXYR11
     I              APYR12                      AXYR12
     I              APYR14                      AXYR14
     I              APCC01                      AXCC01
     I              APCC04                      AXCC04
     I              APCC05                      AXCC05
     I              APCC06                      AXCC06
     I              APCC08                      AXCC08
     I              APCC11                      AXCC11
     I              APCC12                      AXCC12
     I              APCC14                      AXCC14
     I              APZP08                      AXZP08
     I              GLNO02                      GXNO02
     I              GLNO03                      GXNO03
     I              GLNO04                      GXNO04
     I              GLNO06                      GXNO06
     I              APNO39                      AXNO39
     I              APCD53                      AXCD53
     I              APTL03                      AXTL03
     I              APCD45                      AXCD45
     I              APCD46                      AXCD46
     I              APCD67                      AXCD67
     I              APCD68                      AXCD68
     I              APNO53                      AXNO53
     I              APCD60                      AXCD60
     I              APDY21                      AXDY21
     I              APMO21                      AXMO21
     I              APCC21                      AXCC21
     I              APYR21                      AXYR21
     I              APCD72                      AXCD72
     I              APMO22                      AXMO22
     I              APDY22                      AXDY22
     I              APCC22                      AXCC22
     I              APYR22                      AXYR22
DL   I              APFL09                      AXFL09
DT   I              APFL13                      AXFL13
DT   I              APCD79                      AXCD79
ED   I              APCD57                      AXCD57
     IAPFTINI3
     I              APNO01                      IMNO01
     I              APNO11                      IMNO11
     I              APNO20                      IMNO20
     I              APNO47                      IMNO47
EV   I              APDN12                      IMDN12
E4   I              APDN13                      IMDN13
     IAPFTINH6
     I              APAD04                      AXAD04
     I              APAD05                      AXAD05
     I              APAD06                      AXAD06
     I              APAM04                      AXAM04
     I              APAM05                      AXAM05
     I              APAM40                      AXAM40
     I              APAM06                      AXAM06
     I              APAM13                      AXAM13
     I              APAM14                      AXAM14
     I              APAM26                      AXAM26
     I              APCD04                      AXCD04
     I              APCD09                      AXCD09
     I              APCD10                      AXCD10
     I              APCD11                      AXCD11
     I              APCD12                      AXCD12
     I              APCD16                      AXCD16
     I              APCD17                      AXCD17
     I              APCD21                      AXCD21
     I              APCD22                      AXCD22
     I              APCD25                      AXCD25
     I              APCD26                      AXCD26
     I              APCD29                      AXCD29
     I              APCD33                      AXCD33
     I              APCD43                      AXCD43
     I              APCY02                      AXCY02
     I              APDY01                      AXDY01
     I              APDY04                      AXDY04
     I              APDY05                      AXDY05
     I              APDY06                      AXDY06
     I              APDY08                      AXDY08
     I              APDY11                      AXDY11
     I              APDY14                      AXDY14
     I              APDY15                      AXDY15
     I              APFL01                      AXFL01
     I              APMO01                      AXMO01
     I              APMO04                      AXMO04
     I              APMO05                      AXMO05
     I              APMO06                      AXMO06
     I              APMO08                      AXMO08
     I              APMO11                      AXMO11
     I              APMO12                      AXMO12
     I              APMO14                      AXMO14
     I              APMO15                      AXMO15
     I              APNM02                      AXNM02
     I              APNM04                      AXNM04
     I              APNO01                      AXNO01
     I              APNO11                      AXNO11
     I              APNO13                      AXNO13
     I              APNO14                      AXNO14
     I              APNO15                      AXNO15
     I              APNO16                      AXNO16
     I              APNO17                      AXNO17
     I              APNO20                      AXNO20
     I              APNO21                      AXNO21
     I              APNO25                      AXNO25
     I              APNO26                      AXNO26
     I              APNO35                      AXNO35
     I              APNO38                      AXNO38
     I              APPC01                      AXPC01
     I              APPC40                      AXPC40
     I              APST02                      AXST02
     I              APYR01                      AXYR01
     I              APYR04                      AXYR04
     I              APYR05                      AXYR05
     I              APYR06                      AXYR06
     I              APYR08                      AXYR08
     I              APYR11                      AXYR11
     I              APYR12                      AXYR12
     I              APYR14                      AXYR14
     I              APYR15                      AXYR15
     I              APCC01                      AXCC01
     I              APCC04                      AXCC04
     I              APCC05                      AXCC05
     I              APCC06                      AXCC06
     I              APCC08                      AXCC08
     I              APCC11                      AXCC11
     I              APCC12                      AXCC12
     I              APCC14                      AXCC14
     I              APCC15                      AXCC15
     I              APZP08                      AXZP08
     I              GLNO02                      GXNO02
     I              GLNO03                      GXNO03
     I              GLNO04                      GXNO04
     I              GLNO06                      GXNO06
     I              APNO39                      AXNO39
     I              APCD53                      AXCD53
     I              APTL03                      AXTL03
     I              APCD45                      AXCD45
     I              APCD46                      AXCD46
     I              APCD63                      AXCD63
     I              APCD67                      AXCD67
     I              APCD68                      AXCD68
     I              APNO53                      AXNO53
     I              APCD60                      AXCD60
     I              APDY21                      AXDY21
     I              APMO21                      AXMO21
     I              APCC21                      AXCC21
     I              APYR21                      AXYR21
     I              APCD72                      AXCD72
     I              APMO22                      AXMO22
     I              APDY22                      AXDY22
     I              APCC22                      AXCC22
     I              APYR22                      AXYR22
DL   I              APFL09                      AXFL09
DT   I              APFL13                      AXFL13
DT   I              APCD79                      AXCD79
ED   I              APCD57                      AXCD57
EK   I              APFL14                      AXFL14
     IAPFWINH5
     I              APAD04                      AXAD04
     I              APAD05                      AXAD05
     I              APAD06                      AXAD06
     I              APAM04                      AXAM04
     I              APAM05                      AXAM05
     I              APAM40                      AXAM40
     I              APAM06                      AXAM06
     I              APAM13                      AXAM13
     I              APAM14                      AXAM14
     I              APAM26                      AXAM26
     I              APCD04                      AXCD04
     I              APCD09                      AXCD09
     I              APCD10                      AXCD10
     I              APCD12                      AXCD12
     I              APCD16                      AXCD16
     I              APCD21                      AXCD21
     I              APCD22                      AXCD22
     I              APCD25                      AXCD25
     I              APCD26                      AXCD26
     I              APCD29                      AXCD29
     I              APCD43                      AXCD43
     I              APCY02                      AXCY02
     I              APDY01                      AXDY01
     I              APDY04                      AXDY04
     I              APDY05                      AXDY05
     I              APDY06                      AXDY06
     I              APDY08                      AXDY08
     I              APDY11                      AXDY11
     I              APDY14                      AXDY14
     I              APFL01                      AXFL01
     I              APMO01                      AXMO01
     I              APMO04                      AXMO04
     I              APMO05                      AXMO05
     I              APMO06                      AXMO06
     I              APMO08                      AXMO08
     I              APMO11                      AXMO11
     I              APMO12                      AXMO12
     I              APMO14                      AXMO14
     I              APNM04                      AXNM04
     I              APNO01                      AXNO01
     I              APNO11                      AXNO11
     I              APNO13                      AXNO13
     I              APNO14                      AXNO14
     I              APNO15                      AXNO15
     I              APNO16                      AXNO16
     I              APNO17                      AXNO17
     I              APNO20                      AXNO20
     I              APNO21                      AXNO21
     I              APNO25                      AXNO25
     I              APNO26                      AXNO26
     I              APNO35                      AXNO35
     I              APNO38                      AXNO38
     I              APPC01                      AXPC01
     I              APPC40                      AXPC40
     I              APST02                      AXST02
     I              APYR01                      AXYR01
     I              APYR04                      AXYR04
     I              APYR05                      AXYR05
     I              APYR06                      AXYR06
     I              APYR08                      AXYR08
     I              APYR11                      AXYR11
     I              APYR12                      AXYR12
     I              APYR14                      AXYR14
     I              APCC01                      AXCC01
     I              APCC04                      AXCC04
     I              APCC05                      AXCC05
     I              APCC06                      AXCC06
     I              APCC08                      AXCC08
     I              APCC11                      AXCC11
     I              APCC12                      AXCC12
     I              APCC14                      AXCC14
     I              APZP08                      AXZP08
     I              GLNO02                      GXNO02
     I              GLNO03                      GXNO03
     I              GLNO04                      GXNO04
     I              GLNO06                      GXNO06
     I              APNO39                      AXNO39
     I              APCD53                      AXCD53
     I              APTL03                      AXTL03
     I              APCD45                      AXCD45
     I              APCD46                      AXCD46
     I              APCD67                      AXCD67
     I              APCD68                      AXCD68
     I              APNO53                      AXNO53
     I              APCD60                      AXCD60
     I              APDY21                      AXDY21
     I              APMO21                      AXMO21
     I              APCC21                      AXCC21
     I              APYR21                      AXYR21
     I              APCD72                      AXCD72
     I              APMO22                      AXMO22
     I              APDY22                      AXDY22
     I              APCC22                      AXCC22
     I              APYR22                      AXYR22
DL   I              APFL09                      AXFL09
DT   I              APFL13                      AXFL13
DT   I              APCD79                      AXCD79
ED   I              APCD57                      AXCD57
     IAPFTINH0
     I              APAD04                      AXAD04
     I              APAD05                      AXAD05
     I              APAD06                      AXAD06
     I              APAM04                      AXAM04
     I              APAM05                      AXAM05
     I              APAM40                      AXAM40
     I              APAM06                      AXAM06
     I              APAM13                      AXAM13
     I              APAM14                      AXAM14
     I              APAM26                      AXAM26
     I              APCD04                      AXCD04
     I              APCD09                      AXCD09
     I              APCD10                      AXCD10
     I              APCD11                      AXCD11
     I              APCD12                      AXCD12
     I              APCD16                      AXCD16
     I              APCD17                      AXCD17
     I              APCD21                      AXCD21
     I              APCD22                      AXCD22
     I              APCD25                      AXCD25
     I              APCD26                      AXCD26
     I              APCD29                      AXCD29
     I              APCD33                      AXCD33
     I              APCD43                      AXCD43
     I              APCY02                      AXCY02
     I              APDY01                      AXDY01
     I              APDY04                      AXDY04
     I              APDY05                      AXDY05
     I              APDY06                      AXDY06
     I              APDY08                      AXDY08
     I              APDY11                      AXDY11
     I              APDY14                      AXDY14
     I              APDY15                      AXDY15
     I              APFL01                      AXFL01
     I              APMO01                      AXMO01
     I              APMO04                      AXMO04
     I              APMO05                      AXMO05
     I              APMO06                      AXMO06
     I              APMO08                      AXMO08
     I              APMO11                      AXMO11
     I              APMO12                      AXMO12
     I              APMO14                      AXMO14
     I              APMO15                      AXMO15
     I              APNM02                      AXNM02
     I              APNM04                      AXNM04
     I              APNO01                      AXNO01
     I              APNO11                      AXNO11
     I              APNO13                      AXNO13
     I              APNO14                      AXNO14
     I              APNO15                      AXNO15
     I              APNO16                      AXNO16
     I              APNO17                      AXNO17
     I              APNO20                      AXNO20
     I              APNO21                      AXNO21
     I              APNO25                      AXNO25
     I              APNO26                      AXNO26
     I              APNO35                      AXNO35
     I              APNO38                      AXNO38
     I              APPC01                      AXPC01
     I              APPC40                      AXPC40
     I              APST02                      AXST02
     I              APYR01                      AXYR01
     I              APYR04                      AXYR04
     I              APYR05                      AXYR05
     I              APYR06                      AXYR06
     I              APYR08                      AXYR08
     I              APYR11                      AXYR11
     I              APYR12                      AXYR12
     I              APYR14                      AXYR14
     I              APYR15                      AXYR15
     I              APCC01                      AXCC01
     I              APCC04                      AXCC04
     I              APCC05                      AXCC05
     I              APCC06                      AXCC06
     I              APCC08                      AXCC08
     I              APCC11                      AXCC11
     I              APCC12                      AXCC12
     I              APCC14                      AXCC14
     I              APCC15                      AXCC15
     I              APZP08                      AXZP08
     I              GLNO02                      GXNO02
     I              GLNO03                      GXNO03
     I              GLNO04                      GXNO04
     I              GLNO06                      GXNO06
     I              APNO39                      AXNO39
     I              APCD53                      AXCD53
     I              APTL03                      AXTL03
     I              APCD45                      AXCD45
     I              APCD46                      AXCD46
     I              APCD63                      AXCD63
     I              APCD67                      AXCD67
     I              APCD68                      AXCD68
     I              APNO53                      AXNO53
     I              APCD60                      AXCD60
     I              APDY21                      AXDY21
     I              APMO21                      AXMO21
     I              APCC21                      AXCC21
     I              APYR21                      AXYR21
     I              APCD72                      AXCD72
     I              APMO22                      AXMO22
     I              APDY22                      AXDY22
     I              APCC22                      AXCC22
     I              APYR22                      AXYR22
DL   I              APFL09                      AXFL09
DT   I              APFL13                      AXFL13
DT   I              APCD79                      AXCD79
ED   I              APCD57                      AXCD57
      *
     IAPFTINHR
     I              APAD04                      A$AD04
     I              APAD05                      A$AD05
     I              APAD06                      A$AD06
     I              APAM04                      A$AM04
     I              APAM05                      A$AM05
     I              APAM40                      A$AM40
     I              APAM06                      A$AM06
     I              APAM13                      A$AM13
     I              APAM14                      A$AM14
     I              APAM26                      A$AM26
     I              APCD04                      A$CD04
     I              APCD09                      A$CD09
     I              APCD10                      A$CD10
     I              APCD11                      A$CD11
     I              APCD12                      A$CD12
     I              APCD16                      A$CD16
     I              APCD17                      A$CD17
     I              APCD21                      A$CD21
     I              APCD22                      A$CD22
     I              APCD25                      A$CD25
     I              APCD26                      A$CD26
     I              APCD29                      A$CD29
     I              APCD33                      A$CD33
     I              APCD43                      A$CD43
     I              APCY02                      A$CY02
     I              APDY01                      A$DY01
     I              APDY04                      A$DY04
     I              APDY05                      A$DY05
     I              APDY06                      A$DY06
     I              APDY08                      A$DY08
     I              APDY11                      A$DY11
     I              APDY14                      A$DY14
     I              APDY15                      A$DY15
     I              APFL01                      A$FL01
     I              APMO01                      A$MO01
     I              APMO04                      A$MO04
     I              APMO05                      A$MO05
     I              APMO06                      A$MO06
     I              APMO08                      A$MO08
     I              APMO11                      A$MO11
     I              APMO12                      A$MO12
     I              APMO14                      A$MO14
     I              APMO15                      A$MO15
     I              APNM02                      A$NM02
     I              APNM04                      A$NM04
     I              APNO01                      A$NO01
     I              APNO11                      A$NO11
     I              APNO13                      A$NO13
     I              APNO14                      A$NO14
     I              APNO15                      A$NO15
     I              APNO16                      A$NO16
     I              APNO17                      A$NO17
     I              APNO20                      A$NO20
     I              APNO21                      A$NO21
     I              APNO25                      A$NO25
     I              APNO26                      A$NO26
     I              APNO35                      A$NO35
     I              APNO38                      A$NO38
     I              APPC01                      A$PC01
     I              APPC40                      A$PC40
     I              APST02                      A$ST02
     I              APYR01                      A$YR01
     I              APYR04                      A$YR04
     I              APYR05                      A$YR05
     I              APYR06                      A$YR06
     I              APYR08                      A$YR08
     I              APYR11                      A$YR11
     I              APYR12                      A$YR12
     I              APYR14                      A$YR14
     I              APYR15                      A$YR15
     I              APCC01                      A$CC01
     I              APCC04                      A$CC04
     I              APCC05                      A$CC05
     I              APCC06                      A$CC06
     I              APCC08                      A$CC08
     I              APCC11                      A$CC11
     I              APCC12                      A$CC12
     I              APCC14                      A$CC14
     I              APCC15                      A$CC15
     I              APZP08                      A$ZP08
     I              GLNO02                      G$NO02
     I              GLNO03                      G$NO03
     I              GLNO04                      G$NO04
     I              GLNO06                      G$NO06
     I              APNO39                      A$NO39
     I              APCD53                      A$CD53
     I              APTL03                      A$TL03
     I              APCD45                      AXCD45
     I              APCD46                      AXCD46
     I              APCD63                      AXCD63
     I              APCD67                      AXCD67
     I              APCD68                      AXCD68
     I              APNO53                      AXNO53
     I              APCD60                      AXCD60
     I              APDY21                      AXDY21
     I              APMO21                      AXMO21
     I              APCC21                      AXCC21
     I              APYR21                      AXYR21
     I              APCD72                      AXCD72
     I              APMO22                      AXMO22
     I              APDY22                      AXDY22
     I              APCC22                      AXCC22
     I              APYR22                      AXYR22
DL   I              APFL09                      AXFL09
DT   I              APFL13                      AXFL13
DT   I              APCD79                      AXCD79
ED   I              APCD57                      AXCD57
     IAPFWINHR
     I              APAD04                      A$AD04
     I              APAD05                      A$AD05
     I              APAD06                      A$AD06
     I              APAM04                      A$AM04
     I              APAM05                      A$AM05
     I              APAM40                      A$AM40
     I              APAM06                      A$AM06
     I              APAM13                      A$AM13
     I              APAM14                      A$AM14
     I              APAM26                      A$AM26
     I              APCD04                      A$CD04
     I              APCD09                      A$CD09
     I              APCD10                      A$CD10
     I              APCD12                      A$CD12
     I              APCD16                      A$CD16
     I              APCD21                      A$CD21
     I              APCD22                      A$CD22
     I              APCD25                      A$CD25
     I              APCD26                      A$CD26
     I              APCD29                      A$CD29
     I              APCD43                      A$CD43
     I              APCY02                      A$CY02
     I              APDY01                      A$DY01
     I              APDY04                      A$DY04
     I              APDY05                      A$DY05
     I              APDY06                      A$DY06
     I              APDY08                      A$DY08
     I              APDY11                      A$DY11
     I              APDY14                      A$DY14
     I              APFL01                      A$FL01
     I              APMO01                      A$MO01
     I              APMO04                      A$MO04
     I              APMO05                      A$MO05
     I              APMO06                      A$MO06
     I              APMO08                      A$MO08
     I              APMO11                      A$MO11
     I              APMO12                      A$MO12
     I              APMO14                      A$MO14
     I              APNM04                      A$NM04
     I              APNO01                      A$NO01
     I              APNO11                      A$NO11
     I              APNO13                      A$NO13
     I              APNO14                      A$NO14
     I              APNO15                      A$NO15
     I              APNO16                      A$NO16
     I              APNO17                      A$NO17
     I              APNO20                      A$NO20
     I              APNO21                      A$NO21
     I              APNO25                      A$NO25
     I              APNO26                      A$NO26
     I              APNO35                      A$NO35
     I              APNO38                      A$NO38
     I              APPC01                      A$PC01
     I              APPC40                      A$PC40
     I              APST02                      A$ST02
     I              APYR01                      A$YR01
     I              APYR04                      A$YR04
     I              APYR05                      A$YR05
     I              APYR06                      A$YR06
     I              APYR08                      A$YR08
     I              APYR11                      A$YR11
     I              APYR12                      A$YR12
     I              APYR14                      A$YR14
     I              APCC01                      A$CC01
     I              APCC04                      A$CC04
     I              APCC05                      A$CC05
     I              APCC06                      A$CC06
     I              APCC08                      A$CC08
     I              APCC11                      A$CC11
     I              APCC12                      A$CC12
     I              APCC14                      A$CC14
     I              APZP08                      A$ZP08
     I              GLNO02                      G$NO02
     I              GLNO03                      G$NO03
     I              GLNO04                      G$NO04
     I              GLNO06                      G$NO06
     I              APNO39                      A$NO39
     I              APCD53                      A$CD53
     I              APTL03                      A$TL03
     I              APCD45                      AXCD45
     I              APCD46                      AXCD46
     I              APCD67                      AXCD67
     I              APCD68                      AXCD68
     I              APNO53                      AXNO53
     I              APCD60                      AXCD60
     I              APDY21                      AXDY21
     I              APMO21                      AXMO21
     I              APCC21                      AXCC21
     I              APYR21                      AXYR21
     I              APCD72                      AXCD72
     I              APMO22                      AXMO22
     I              APDY22                      AXDY22
     I              APCC22                      AXCC22
     I              APYR22                      AXYR22
DL   I              APFL09                      AXFL09
DT   I              APFL13                      AXFL13
DT   I              APCD79                      AXCD79
ED   I              APCD57                      AXCD57
      *
     IAPFMBNK
     I              APNO15                      BKNO15
     I              APNO13                      BKNO13
     I              APMO01                      BKMO01
     I              APDY01                      BKDY01
     I              APYR01                      BKYR01
     I              APCC01                      BKCC01
     I              APNM04                      BKNM04
     I              OPFC01                      BKFC01
     IAPFMBNK1
     I              APNO15                      BKNO15
     I              APNO13                      BKNO13
     I              APMO01                      BKMO01
     I              APDY01                      BKDY01
     I              APYR01                      BKYR01
     I              APCC01                      BKCC01
     I              APNM04                      BKNM04
     I              OPFC01                      BKFC01
     IAPFTINM1
     I              APNO01                      MPNO01
     I              APNO11                      MPNO11
     I              APNO20                      MPNO20
     I              PONO01                      MONO01
     I              PONO05                      MONO05
     I              PONO19                      MONO19
     I              PONO27                      MONO27
     I              PONO32                      MONO32
     I              POCD53                      MOCD53
     I              APCD62                      MOCD62
     IAPFTINM9
     I              APNO01                      MPNO01
     I              APNO11                      MPNO11
     I              APNO20                      MPNO20
     I              PONO01                      MONO01
     I              PONO05                      MONO05
     I              PONO19                      MONO19
     I              PONO27                      MONO27
     I              PONO32                      MONO32
     I              POCD53                      MOCD53
     I              APCD62                      MOCD62
     IPOFTVRH
     I              PONO01                      NO01PO
DT   IPOFTRHC
DT   I              APNO01                      XXVEND
DT   IPOFTRHD
DT   I              APNO01                      XXVEND
      *------------------------------------------------------------------------*
      *  SECTION 0         FIRST CYCLE
      *
      * STEP 1.  DECLARE PARAMETER LISTS
      * STEP 2.  DECLARE KEY LISTS
      * STEP 3.  FIELD DEFINITIONS
      * STEP 4.  INITIALIZATIONS AND RESETS
      *------------------------------------------------------------------------*
      * STEP 1.  DECLARE PARAMETER LISTS
      *------------------------------------------------------------------------*
     C     *ENTRY        PLIST
     C                   PARM                    PCTL#
     C     HELP          PLIST
     C                   PARM                    PROG
     C                   PARM                    SCREEN
     C     INQKEY        PLIST
     C                   PARM                    PONBR             7
     C                   PARM                    CODE01            1
     C     JULKEY        PLIST
     C                   PARM                    PDATE             6 0
     C                   PARM                    PJULI             5 0
     C     PLUDR         PLIST
     C                   PARM                    ZZFUNC            1
     C                   PARM                    ZZDATE            7 0
     C                   PARM                    ZZDAYS            5 0
     C                   PARM                    ZZDIFF            7 0
     C     PL0145        PLIST
     C                   PARM                    POVEN             6
     C                   PARM                    INVVEN            6
     C                   PARM                    ASSOC             1
      *
     C     PL8220        PLIST                                                  GET USR AUTH
     C                   PARM                    USER             10
     C                   PARM                    APP               2
     C                   PARM                    CDE               4
     C                   PARM                    ID                4 0
     C                   PARM                    USRVAL           10
     C                   PARM                    VALFRM            1
     C                   PARM                    RTNCOD            1
     C     PL0025        PLIST
     C                   PARM                    TBNO01
     C                   PARM                    TBNO02
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM                    TBNO03
     C                   PARM                    MODE
     C     PL0126        PLIST
   D2C*                  PARM                    NO01C
D2   C                   PARM                    VND_KEY
     C                   PARM                    NO53C             2
     C                   PARM                    MODE              1
     C                   PARM                    BKDESC           30
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL0131        PLIST
   D2C*                  PARM                    NO01C
D2   C                   PARM                    VND_KEY
     C                   PARM                    CD60C             5
     C                   PARM                    MODE
     C                   PARM                    TXDESC           30
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL9505        PLIST
     C                   PARM                    VNDCUS            1
     C                   PARM                    CUSNBR            6
     C                   PARM                    TRPNID           15
     C                   PARM                    VENBRN            3
     C                   PARM                    DOCTYP            3
     C                   PARM                    SUBTYP            1
     C                   PARM                    RCVSTS            1
     C                   PARM                    EDITYP            1
     C     PL0060        PLIST
     C                   PARM                    VALUE#           30
     C                   PARM                    ACT#              1
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL0140        PLIST
     C                   PARM                    PONO01
     C                   PARM                    NOTTYP            1
     C                   PARM                    APNO01
     C                   PARM                    DSPF3             1
DS   C     PL0141        PLIST
DS   C                   PARM                    PONO01
DS   C                   PARM                    PONO19
DS   C                   PARM                    MODECDE           1
DS   C                   PARM                    MORI              1
     C     PL1020        PLIST
     C                   PARM                    TBNO01
     C                   PARM                    TBCODE            1
     C                   PARM                    RETRY             1
     C                   PARM                    RSPN              1
     C     PL1068        PLIST
     C                   PARM                    DLTPO
     C                   PARM                    DLTRCV
     C     PL1070        PLIST
     C                   PARM                    CHGPO#            7
     C                   PARM                    CHGVEN            6
     C                   PARM                    NO11C
     C                   PARM                    NO20C
     C     PL1072        PLIST
     C                   PARM                    VNDRTN
     C                   PARM                    NO01C
     C                   PARM                    NO20C
     C     PL1080        PLIST
DP   C                   PARM                    PMICO
     C                   PARM                    POVEND
     C                   PARM                    PO#
     C                   PARM                    RCV#
     C                   PARM                    APBR#C
     C                   PARM                    NO20C
     C                   PARM                    DIRECT            1
     C                   PARM                    FRTONL            1
     C                   PARM                    SELLIN            1
     C                   PARM                    EXIT              1
     C     PL1081        PLIST
DP   C                   PARM                    PMICO
     C                   PARM                    NO01C
     C                   PARM                    PO#
     C                   PARM                    RCV#
     C                   PARM                    APBR#C
     C                   PARM                    NO11C
     C                   PARM                    NO20C
     C                   PARM                    VARCDE            1
     C                   PARM                    APAM04
     C                   PARM                    INDCDE            1
     C                   PARM                    DIRECT
     C                   PARM                    FRTONL
     C                   PARM                    FKEY              1
     C     PL1082        PLIST
     C                   PARM                    NO01C
     C                   PARM                    PO#
     C                   PARM                    RCV#
     C                   PARM                    NO20C
DT    *
DT   C     PL1085        plist
DT   C                   parm                    pretcd
DT   C                   parm                    pactcd
DT   C                   parm                    pfunky
DT   C                   parm                    pdata
DT    *
DT   C     PL1086        plist
DT   C                   parm                    pretcd
DT   C                   parm                    pactcd
DT   C                   parm                    pfunky
DT   C                   parm                    pdata
     C     PL1090        PLIST
DP   C                   PARM                    PMICO
     C                   PARM                    POVEND
     C                   PARM                    VNDRTN
     C                   PARM                    APBR#C
     C                   PARM                    NO20C
     C                   PARM                    SELLIN
     C                   PARM                    EXIT
     C     PL1091        PLIST
DP   C                   PARM                    PMICO
     C                   PARM                    NO01C
     C                   PARM                    VNDRTN
     C                   PARM                    APBR#C
     C                   PARM                    NO11C
     C                   PARM                    NO20C
     C                   PARM                    VARCDE
     C                   PARM                    APAM04
     C                   PARM                    INDCDE
     C                   PARM                    INVTYP            3
     C                   PARM                    FKEY
     C     PL1092        PLIST
     C                   PARM                    NO01C
     C                   PARM                    OCRTN
     C                   PARM                    NO20C
     C                   PARM                    EXIT
     C     PL2000        PLIST
     C                   PARM                    PM2000           23 0
     C     PL2021        PLIST
     C                   PARM                    GNO01             3
     C                   PARM                    GNO06             3
     C                   PARM                    GNO02             2
     C                   PARM                    GNO03             4
     C                   PARM                    GNO04             3
     C                   PARM                    GDN03            25
     C                   PARM                    RTCOD             1
     C     PL2071        PLIST
     C                   PARM                    PCTLNO
     C                   PARM                    PFILE             1
     C                   PARM                    PEDIT             1
     C                   PARM                    PERRCD            1
     C     PL4015        PLIST
     C                   PARM                    NO01C
     C     RLOCK         PLIST
     C                   PARM                    DSPERR
     C                   PARM                    DSPF1             1            DISPLAY RETRY
     C                   PARM                    DSPF2             1            SCREEN RESPONSE
     C     PL1066        PLIST
     C                   PARM                    INVCO
     C                   PARM                    INVBR
     C                   PARM                    VNDN
     C                   PARM                    PON
     C                   PARM                    RCVN
     C                   PARM                    INVN
     C                   PARM                    INVDT
     C                   PARM                    CNTN
     C                   PARM                    VARCDE
   ERC*                  PARM                    INVA
ER   C                   PARM                    IVAMT
     C                   PARM                    SVAM04
     C                   PARM                    CC
     C                   PARM                    INDCDE
     C                   PARM                    FRTONL
     C                   PARM                    ACTION            1
     C                   PARM                    EXIT
     C     PL4290        PLIST
     C                   PARM                    PONO27
     C     PL5000        PLIST
     C                   PARM                    SELCDE
     C                   PARM                    SELDES
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
      *
     C     PL0400        PLIST
     C                   PARM                    PMIAPL            2
     C                   PARM                    PMOYN             1
     C     PL5908        PLIST
     C                   PARM                    TRANS#            7
     C                   PARM                    TYPE              2
     C                   PARM                    TRNLIN            3
     C     PL0810        PLIST
     C                   PARM                    PM0810
EK    *
EK   C     STDPL         plist
EK   C                   parm                    pretcd
EK   C                   parm                    pactcd
EK   C                   parm                    pfunky
EK   C                   parm                    pdata
EL    *
EL   C     pl1300        plist
EL   C                   parm                    p1300App
EL   C                   parm                    p1300Bypass
EL    *
E0   C     PL7115        PLIST
E0   C                   PARM                    I_MODE
E0   C                   PARM                    APNO01
E0   C                   PARM                    APNO20
E0   C                   PARM                    O_YN
E0    *
E0   C     PL2500        PLIST
E0   C                   PARM                    PGMNAM2          10
E0   C                   PARM                    RCCALL            1
¢J   C     TB0040        PLIST
¢J   C                   PARM                    TBNO01
¢J   C                   PARM                    TBNO02
¢J   C                   PARM                    TBNO03
      *------------------------------------------------------------------------*
      * STEP 2.  DECLARE KEY LISTS
      *------------------------------------------------------------------------*
     C     ADDKEY        KLIST
     C                   KFLD                    KVEN
     C                   KFLD                    KCOD
     C     APNKY1        KLIST
     C                   KFLD                    NO01C
     C                   KFLD                    CD07              1
   DPC*    BRKEY         KLIST
   DPC*                  KFLD                    APCO#F
   DPC*                  KFLD                    APBR#C
     C     GLKEYC        KLIST
     C                   KFLD                    APCO#F
     C                   KFLD                    GNO06C
     C                   KFLD                    GNO02C
     C                   KFLD                    GNO03C
     C                   KFLD                    GNO04C
     C     GLKEYJ        KLIST
     C                   KFLD                    APCO#F
     C                   KFLD                    GNO06J
     C                   KFLD                    GNO02J
     C                   KFLD                    GNO03J
     C                   KFLD                    GNO04J
     C     GLKEYP        KLIST
     C                   KFLD                    APCO#F
     C                   KFLD                    NO06P
     C                   KFLD                    NO02P
     C                   KFLD                    NO03P
     C                   KFLD                    NO04P
     C     GRPKY         KLIST
     C                   KFLD                    PSTGRP
     C                   KFLD                    PSTTYP
     C     INMKY1        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    MHNO19
     C                   KFLD                    MHNO05
     C     INM9K1        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    MHNO27
     C                   KFLD                    MHNO32
     C                   KFLD                    MHCD53
     C     INM9K2        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    SAVRTN
     C     INM9K3        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    MONO27
     C                   KFLD                    MONO32
     C                   KFLD                    MOCD53
     C     INOKY7        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    PONO27
     C                   KFLD                    POCD53
     C     KEYINV        KLIST
     C                   KFLD                    KVEN
     C                   KFLD                    KINV
¢d   C     KEYINVZ       KLIST
¢d   C                   KFLD                    KVEN
¢d   C                   KFLD                    KINV
¢d   C                   KFLD                    kmth              2 0
¢d   C                   KFLD                    kyear             2 0
     C     MTHKY2        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    MONO01
     C                   KFLD                    MONO19
     C                   KFLD                    MONO05
     C     MTHKY4        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    NO27S3
     C                   KFLD                    CD53S3
     C     MTH5K1        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    MONO27
     C                   KFLD                    MONO32
     C                   KFLD                    MOCD53
     C     MTH5K2        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    NO27S3
     C                   KFLD                    PONO32
     C                   KFLD                    CD53S3
     C     MTH5K3        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    PONO27
     C                   KFLD                    PONO32
     C                   KFLD                    POCD53
     C     TABKEY        KLIST
     C                   KFLD                    TBNO01
     C                   KFLD                    TBNO02
     C     TRDKEY        KLIST
     C                   KFLD                    MHNO19
     C                   KFLD                    MHNO05
     C     TRDKY2        KLIST
     C                   KFLD                    MONO19
     C                   KFLD                    MONO05
     C     VRLKEY        KLIST
     C                   KFLD                    MHNO27
     C                   KFLD                    MHNO32
     C     VRLKY2        KLIST
     C                   KFLD                    MONO27
     C                   KFLD                    MONO32
     C     VROKEY        KLIST
     C                   KFLD                    MHNO27
     C                   KFLD                    MHCD53
     C     VROKY2        KLIST
     C                   KFLD                    MONO27
     C                   KFLD                    MOCD53
     C     VROKY3        KLIST
     C                   KFLD                    NO27P
     C                   KFLD                    CD53P
     C     INM1K2        KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    SAVRCV
     C     NOTKY         KLIST
     C                   KFLD                    NO20C
     C                   KFLD                    CD65
DT    *
DT   C     VEA1KY        KLIST
DT   C                   KFLD                    APNO01
DT   C                   KFLD                    OPCD34
DT   C                   KFLD                    OPNM25
DT   C                   KFLD                    OPCD31
EK    *
EK   C     K_WRBM1       KLIST
EK   C                   KFLD                    rbTrnType
EK   C                   KFLD                    no20c
      *------------------------------------------------------------------------*
      * STEP 3.  FIELD DEFINITIONS
      *------------------------------------------------------------------------*
     C     *DTAARA       DEFINE    *LDA          LDADTA
      *
     C     *LIKE         DEFINE    PONO01        ORGPO
     C     *LIKE         DEFINE    PONO19        ORGRCV
     C     *LIKE         DEFINE    APCD45        ORGDIR
     C     *LIKE         DEFINE    APCD45        ORGFRT
     C     *LIKE         DEFINE    APFL01        ORGSKP
DT   C     *LIKE         DEFINE    APFL13        ORG_MATCH_FRT
     C     *LIKE         DEFINE    PONO01        LSTPO
     C     *LIKE         DEFINE    PONO19        LSTRCV
     C     *LIKE         DEFINE    APCD45        LSTDIR
     C     *LIKE         DEFINE    APCD45        LSTFRT
     C     *LIKE         DEFINE    APFL01        LSTSKP
DT   C     *LIKE         DEFINE    APFL13        LST_MATCH_FRT
     C     *LIKE         DEFINE    PONO27        LSTRTN
     C     *LIKE         DEFINE    PONO01        DLTPO
     C     *LIKE         DEFINE    PONO19        DLTRCV
     C     *LIKE         DEFINE    APCD08        KCOD
     C     *LIKE         DEFINE    APNO11        KINV
     C     *LIKE         DEFINE    APNO01        KVEN
     C     *LIKE         DEFINE    APNO20        NO20C
     C     *LIKE         DEFINE    APAM06        PAYTOT
     C     *LIKE         DEFINE    APAM04        GRSTOT
     C     *LIKE         DEFINE    APAM13        FRTTOT
     C     *LIKE         DEFINE    APAM14        TAXTOT
     C     *LIKE         DEFINE    APAM05        DSCTOT
     C     *LIKE         DEFINE    APTL03        OTCTOT
     C     *LIKE         DEFINE    APAM16        PYAM16
     C     *LIKE         DEFINE    APAM16        RMN16
     C     *LIKE         DEFINE    APAM17        PYAM17
     C     *LIKE         DEFINE    APAM17        RMN17
     C     *LIKE         DEFINE    APAM18        PYAM18
     C     *LIKE         DEFINE    APAM18        RMN18
     C     *LIKE         DEFINE    APAM37        PYAM37
     C     *LIKE         DEFINE    APAM37        RMN37
     C     *LIKE         DEFINE    APAM19        PYAM19
     C     *LIKE         DEFINE    APAM19        RMN19
     C     *LIKE         DEFINE    APAM27        PYAM27
     C     *LIKE         DEFINE    APAM27        RMN27
     C     *LIKE         DEFINE    APAD04        HAD04
     C     *LIKE         DEFINE    APAD05        HAD05
     C     *LIKE         DEFINE    APAD06        HAD06
     C     *LIKE         DEFINE    APCY02        HCY02
     C     *LIKE         DEFINE    APST02        HST02
     C     *LIKE         DEFINE    APZP08        HZP08
     C     *LIKE         DEFINE    APCD33        APRVIT
     C     *LIKE         DEFINE    APNO01        SVEN
     C     *LIKE         DEFINE    APNO11        SVNO11
¢G   C     *LIKE         DEFINE    APMO04        SVINVMO
¢G   C     *LIKE         DEFINE    APYR04        SVINVYR
     C     *LIKE         DEFINE    ALLOK         SECOK
     C     *LIKE         DEFINE    APNO26        SAVREF
     C     *LIKE         DEFINE    RNN           LSTRNN
     C     *LIKE         DEFINE    GLCD48        PSTGRP
     C     *LIKE         DEFINE    GLCD49        PSTTYP
     C     *LIKE         DEFINE    GLCD50        AIPSUM
DT   C     *LIKE         DEFINE    GLCD50        AIPSUM_F
EK   C     *LIKE         DEFINE    GLCD50        AIPSUM_R
     C     *LIKE         DEFINE    APNO13        BANKNO
     C     *LIKE         DEFINE    PONO01        SAVPO#
     C     *LIKE         DEFINE    PONO19        SAVRCV
     C     *LIKE         DEFINE    RNJ           SRNJ
     C     *LIKE         DEFINE    RNO           SRNO
     C     *LIKE         DEFINE    CROW          ROW
     C     *LIKE         DEFINE    CCOL          COL
     C     *LIKE         DEFINE    CRCD          CRCD#
     C     *LIKE         DEFINE    CFLD          CFLD#
     C     *LIKE         DEFINE    APAM04        SVAM04
     C     *LIKE         DEFINE    APQY03        STKQTY
     C     *LIKE         DEFINE    POQYPF        $PRFCT
     C     *LIKE         DEFINE    APQY03        $STQTY
     C     *LIKE         DEFINE    POAMU7        $PRCST
     C     *LIKE         DEFINE    APCD09        SVCD09
     C     *LIKE         DEFINE    APMO14        SVMO14
     C     *LIKE         DEFINE    APDY14        SVDY14
     C     *LIKE         DEFINE    APCC14        SVCC14
     C     *LIKE         DEFINE    APYR14        SVYR14
     C     *LIKE         DEFINE    INVDTC        SVINVD
EP   C     *LIKE         DEFINE    INVDTC        INVDTC_SV
     C     *LIKE         DEFINE    APAM31        OCVAR
     C     *LIKE         DEFINE    PONO27        OCRTN
     C     *LIKE         DEFINE    GLCD50        VRRSUM
     C     *LIKE         DEFINE    PONO27        SAVRTN
     C     *LIKE         DEFINE    RNP           SRNP
     C     *LIKE         DEFINE    RNQ           SRNQ
     C     *LIKE         DEFINE    POCD53        OCTYPE
     C     *LIKE         DEFINE    APNO01        POVEND
     C     *LIKE         DEFINE    *IN03         SVIN03
     C     *LIKE         DEFINE    PONO27        ENTRTN
     C     *LIKE         DEFINE    APTL03        LDTL03
     C     *LIKE         DEFINE    ALLOK         DFIFLG
     C     *LIKE         DEFINE    APNO20        PCTL#
     C     *LIKE         DEFINE    APCD57        SELCDE
     C     *LIKE         DEFINE    APDN07        SELDES
     C     *LIKE         DEFINE    APNO20        PCTLNO
     C     *LIKE         DEFINE    GLNOC         SVGLNO
¢F   C     *LIKE         DEFINE    GLMNSUB       SVGLMNSUB
     C     *LIKE         DEFINE    APCD65        CD65
     C     *LIKE         DEFINE    *IN56         SVIN56
     C     *LIKE         DEFINE    *IN57         SVIN57
     C     *LIKE         DEFINE    *IN58         SVIN58
     C     *LIKE         DEFINE    *IN59         SVIN59
     C     *LIKE         DEFINE    APCD67        TYPVEN
     C     *LIKE         DEFINE    CD59M         CD59A
     C     *LIKE         DEFINE    CD66M         CD66A
     C     *LIKE         DEFINE    NO52M         NO52A
     C     *LIKE         DEFINE    NO53M         NO53A
     C     *LIKE         DEFINE    CD25M         CD25A
     C     *LIKE         DEFINE    CD68          SVCD68
     C     *LIKE         DEFINE    NO53          SVNO53
     C     *LIKE         DEFINE    CD60          SVCD60
     C     *LIKE         DEFINE    PPDAT         SVPDAT
     C     *LIKE         DEFINE    PPCC          SVPPCC
     C     *LIKE         DEFINE    CARFM2        CRARPD
DP   C     *LIKE         DEFINE    APNO15        PMICO
D2   C     *LIKE         DEFINE    APNO01        VND_KEY
ED   C     *LIKE         DEFINE    APNO26        ORG_REF
ED   C     *LIKE         DEFINE    APNO39        ORG_REFCTL
ED   C     *LIKE         DEFINE    APAM04        ORG_APAM04
EV   C     *LIKE         DEFINE    APDN12        DN12
E4   C     *LIKE         DEFINE    APDN13        DN13
      *------------------------------------------------------------------------*
      * STEP 4.  INITIALIZATIONS AND RESETS
      *------------------------------------------------------------------------*
      *
DX    * Check whether using Intellichief is used.
DX   C                   MOVE      '0'           ERR01             1
DX   C                   MOVE      *BLANKS       TBNO01
DX   C                   MOVEL     'IMAG'        TBNO01
DX   C                   MOVE      *BLANKS       TBNO02
DX   C                   MOVEL     'ICSYS'       TBNO02
DX   C     TABKEY        CHAIN     TBFMTBL                            40
DX   C     *IN40         IFEQ      *OFF
DX   C                   MOVEL     TBNO03        ICSYS             1
DX   C                   ELSE
DX   C                   MOVE      'N'           ICSYS
DX   C                   ENDIF
DX   C     ICSYS         IFEQ      'Y'
DX   C                   CALL      'OPC9805'
DX   C                   PARM                    ERR01             1
DX   C                   ENDIF
EV    * Check if using EZ AP, only if not using ICSYS.
EV   C                   eval      ezApSys =  'N'
EV   C                   if        icSys <> 'Y'
EV    * Check whether EZ AP is used or not.
EV   C                   eval      tbno01 = 'IMAG'
EV   C                   eval      tbno02 = 'EZAP'
EV   C     tabkey        chain     tbfmTbl
EV   C                   if        %found
EV   C                   movel     tbno03        ezApSys           1
EV   C                   endif
EV   C                   endif
EV    *
DX   C     ICSYS         IFEQ      'Y'
DX   C     ERR01         ANDEQ     '0'
DX   C                   MOVE      *ON           *IN55
DX   C                   ELSE
DX   C                   MOVE      *OFF          *IN55
DX   C                   ENDIF
DX    *
DI    * See if EDI is being used...
DI   C                   clear                   onedi             1
DI   C                   move      'EDI '        tbno01
DI   C                   clear                   tbno02
DI   C                   movel     'EDI '        tbno02
DI   C                   move      'Y'           tbno02
DI   C     tabkey        setll     tbfmtbl                                40
DI   C                   if        *in40 = *on
DI   C                   eval      onedi = 'Y'
DI   C                   endif
      * CHECK WHETHER W/H MANAGEMENT SYSTEM IS INSTALLED OR NOT.
     C                   MOVE      '03'          PMIAPL
     C                   CALL      'OPR0400'     PL0400
     C     PMOYN         IFEQ      'Y'
     C                   MOVE      'Y'           WHMYES            1
     C                   ELSE
     C                   MOVE      'N'           WHMYES
     C                   ENDIF
      *
      * See if user is authorized to change P/O vendor...
     C                   CLEAR                   CPOAUT
     C                   MOVEL     USRNM         USER
     C                   Z-ADD     1             ID
     C                   MOVE      'AP'          APP
     C                   MOVE      'APM '        CDE
     C                   MOVE      *BLANKS       USRVAL
     C                   MOVE      *BLANKS       VALFRM
     C                   MOVE      *BLANKS       RTNCOD
     C                   CALL      'OPR8220'     PL8220
     C     RTNCOD        IFEQ      '0'
     C                   MOVEL     USRVAL        CPOAUT            1
     C                   ENDIF
      * RETRIEVE THE USER'S SECURITY PROFILE
     C                   MOVE      'UIDS'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     USRNM         TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        SECPRF            7            SECURITY PROFIL
     C                   ENDIF
      * RETRIEVE THE COMPANIES THAT THE USER IS AUTHORIZED TO
     C                   Z-ADD     0             @X                3 0
     C     SECPRF        CHAIN     OPFMSEC                            40
     C     *IN40         DOWEQ     *OFF
     C     OPNO02        IFEQ      0
     C                   MOVE      'Y'           ALLOK             1            ALL CO'S OK
     C                   SETON                                        50        ALL CO'S OK
     C                   ELSE
     C                   ADD       1             @X                             ARRAY INDEX
     C                   MOVE      OPNO02        SEC(@X)
     C                   ENDIF
     C     SECPRF        READE     OPFMSEC                                40
     C                   ENDDO
      * RETREIVE ACCRUED INVENTORY PAYABLES G/L ACCOUNT
     C                   MOVE      'DEFAULT'     PSTGRP
     C                   MOVE      '210'         PSTTYP
     C     GRPKY         CHAIN     GLFMGRP                            40
     C     *IN40         IFEQ      *OFF
     C                   Z-ADD     GRPGL         AIPGL
     C                   MOVE      GLCD50        AIPSUM
     C                   ENDIF
DT    * RETREIVE ACCRUED FREIGHT PAYABLES G/L ACCOUNT
DT   C                   MOVE      'DEFAULT'     PSTGRP
DT   C                   MOVE      '730'         PSTTYP
DT   C     GRPKY         CHAIN     GLFMGRP                            40
DT   C     *IN40         IFEQ      *OFF
DT   C                   Z-ADD     GRPGL         AIPGL_F
DT   C                   MOVE      GLCD50        AIPSUM_F
DT   C                   ENDIF
EK    * RETREIVE REBATES DUE PAYABLES G/L ACCOUNT
EK   C                   MOVE      'DEFAULT'     PSTGRP
EK   C                   MOVE      '756'         PSTTYP
EK   C     GRPKY         CHAIN     GLFMGRP                            40
EK   C     *IN40         IFEQ      *OFF
EK   C                   Z-ADD     GRPGL         RBDGL
EK   C                   MOVE      GLCD50        AIPSUM_R
EK   C                   ENDIF
EN    * RETREIVE SPECIAL REBATES DUE PAYABLES G/L ACCOUNT
EN   C                   MOVE      'DEFAULT'     PSTGRP
EN   C                   MOVE      '780'         PSTTYP
EN   C     GRPKY         CHAIN     GLFMGRP                            40
EN   C     *IN40         IFEQ      *OFF
EN   C                   Z-ADD     GRPGL         RBDGL_S
EN   C                   ENDIF
      * RETREIVE VENDOR RETURN RECEIVABLE G/L ACCOUNT
     C                   MOVE      '490'         PSTTYP
     C     GRPKY         CHAIN     GLFMGRP                            40
     C     *IN40         IFEQ      *OFF
     C                   Z-ADD     GRPGL         VRRGL
     C                   MOVE      GLCD50        VRRSUM
     C                   ENDIF
      * DETERMINE IF TERMS SELECTION IS TO BE DISPLAYED
     C                   MOVE      'N'           SHOTRM
     C                   MOVE      'AP09'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'TERMS'       TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        SHOTRM            1
     C                   ENDIF
      * GET JOBQ FOR A/P APPROVAL
     C                   MOVE      *BLANKS       JOBQ             10
     C                   MOVE      'AP05'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'JOBQ'        TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        JOBQ             10
     C     JOBQ          IFNE      *BLANKS
     C                   Z-ADD     69            JQ                3 0          INDEX
     C                   MOVEA     JOBQ          ARY(JQ)
     C                   ENDIF
     C                   ENDIF
      * SEE IF A/P IMAGE IS BEING USED
DX    * IF INTELLICHIEF IS NOT BEING USED
     C                   CLEAR                   IMGCTL
DX   C     ICSYS         IFNE      'Y'
DX   C                   MOVE      *OFF          *IN64
     C                   MOVE      'ADON'        TBNO01
     C                   CLEAR                   TBNO02
     C                   MOVEL     'ADDON'       TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        ADDON
      * SEE IF A/P IMAGE CONTROL NUMBER SHOULD BE DISPLAYED/EDITED
     C     IMAGE         IFEQ      'Y'
     C                   MOVE      'IMAG'        TBNO01
     C                   CLEAR                   TBNO02
     C                   MOVEL     'DISPLAY'     TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        IMGCTL            1
     C                   ENDIF
     C                   ENDIF
      * SEE IF A/P IMAGE CONTROL NUMBER SHOULD BE REQUIRED
     C     IMGCTL        IFEQ      'Y'
     C                   MOVE      'IMAG'        TBNO01
     C                   CLEAR                   TBNO02
     C                   MOVEL     'APREQ'       TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        IMGREQ            1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
DX   C                   ELSE
DX   C                   MOVE      *OFF          *IN72
EV   C                   if        ezApSys <> 'Y'
DX   C                   MOVE      *ON           *IN64
EV   C                   endif
DX   C                   ENDIF
      * SET INITIAL FIELD VALUES
     C     *YEAR         SUB       1             MIN1              4 0
     C     *YEAR         ADD       1             PUS1              4 0
     C     PCTL#         IFNE      0
     C                   Z-ADD     PCTL#         HCTL
     C                   GOTO      BYPSEL
     C                   ENDIF
      *------------------------------------------------------------------------*
      * SECTION 1         INVOICE NUMBER PROMPT
      *
      * STEP 1.  CLEAR PROMPT SCREEN
      * STEP 2.  DISPLAY PROMPT SCREEN
      * STEP 3.  EDIT PROMPT SCREEN
      *------------------------------------------------------------------------*
      * STEP 1.  CLEAR PROMPT SCREEN
      *------------------------------------------------------------------------*
     C     DSPZ          TAG
     C                   MOVE      *BLANKS       NO11A
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *BLANKS       MSGFLD
      *------------------------------------------------------------------------*
      * STEP 2.  DISPLAY PROMPT SCREEN
      *------------------------------------------------------------------------*
     C     DSPA          TAG
EA EEC*                  eval      svIn34 = *in34
EA   C                   if        qqf = 'QQF'
EA   C                   eval      *in34 = *on
EE   C                   else
EE   C                   eval      *in34 = *off
EA   C                   endif
     C                   EXFMT     APF1112A
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVE      *OFF          *IN80
     C                   MOVE      ' '           DFIFLG
EA EEC*                  eval      *in34 = svIn34
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPA
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         CABEQ     *ON           ENDPGM
      *------------------------------------------------------------------------*
      * STEP 3.  EDIT PROMPT SCREEN
      *------------------------------------------------------------------------*
      * NO INVOICE NUMBER ENTERED
     C     NO11A         CABEQ     *BLANKS       DSPA
      * INVOICE NUMBER NOT FOUND
     C     NO11A         CHAIN     APLTINHE                           40
     C     *IN40         IFEQ      *ON
     C                   MOVE      *ON           *IN80
     C                   MOVEA     EMS(82)       MSGFLD
     C                   GOTO      DSPA
     C                   ENDIF
   DDC*                  Z-ADD     APAM04        SVAM04
   DDC*                  MOVE      'M'           ACTION
      *------------------------------------------------------------------------*
      * SECTION 2         INVOICE SELECTION
      *
      * STEP 1.  CLEAR SUBFILE
      * STEP 2.  LOAD SUBFILE
      * STEP 3.  DISPLAY SUBFILE
      * STEP 4.  READ SUBFILE
      * STEP 5.  DELETE SUBFILE
      *------------------------------------------------------------------------*
      * STEP 1.  CLEAR SUBFILE
      *------------------------------------------------------------------------*
     C                   Z-ADD     0             RNB
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVE      *ON           *IN73
     C                   WRITE     APC1112B
     C                   MOVE      *OFF          *IN73
      *------------------------------------------------------------------------*
      * STEP 2.  LOAD SUBFILE
      *------------------------------------------------------------------------*
     C     *IN40         DOWEQ     *OFF
      * DETERMINE IF AUTHORIZED TO COMPANY
     C                   MOVE      'N'           SECOK
     C     ALLOK         IFEQ      'Y'
     C                   MOVE      'Y'           SECOK
     C                   ELSE
     C     APNO15        LOOKUP    SEC                                    41
     C     *IN41         IFEQ      *ON
     C                   MOVE      'Y'           SECOK
     C                   ENDIF
     C                   ENDIF
      * WRITE SUBFILE IF AUTHORIZED
     C     SECOK         IFEQ      'Y'
     C                   MOVE      *BLANKS       SELB
     C                   MOVE      *BLANKS       APNM01
     C     APNO01        CHAIN     APFMVEN4                           41
     C                   MOVE      APNO20        HCTL
     C                   ADD       1             RNB
     C                   WRITE     APS1112B
     C                   ENDIF
     C     NO11A         READE     APFTINHE                               40
     C                   ENDDO
      *------------------------------------------------------------------------*
      * STEP 3.  DISPLAY SUBFILE
      *------------------------------------------------------------------------*
      * IF ONLY ONE INVOICE FOUND
     C     RNB           IFEQ      1
      ** VALIDATE COMPANY SECURITY
     C     SECOK         IFEQ      'N'
     C                   MOVE      *ON           *IN80
     C                   MOVEA     EMS(83)       MSGFLD
     C                   GOTO      DSPA
      ** BYPASS SELECTION
     C                   ELSE
     C                   GOTO      BYPSEL
     C                   ENDIF
     C                   ENDIF
      *
     C     DSPB          TAG
     C                   Z-ADD     1             RNB
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVEA     '111'         *IN(74)
     C                   WRITE     APF1112B
     C                   EXFMT     APC1112B
     C                   MOVEA     '000'         *IN(74)
     C                   MOVE      *BLANKS       MSGFLD
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPB
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C                   MOVE      '1'           *IN79
     C                   WRITE     APC1112B
     C                   MOVE      '0'           *IN79
     C                   GOTO      ENDPGM
     C                   ENDIF
      * RETURN TO PREVIOUS SCREEN
     C     *IN12         IFEQ      *ON
     C                   MOVE      '1'           *IN79
     C                   WRITE     APC1112B
     C                   MOVE      '0'           *IN79
     C                   GOTO      DSPZ
     C                   ENDIF
      *------------------------------------------------------------------------*
      * STEP 4.  READ SUBFILE
      *------------------------------------------------------------------------*
     C     *IN42         DOUEQ     *ON
     C                   READC     APS1112B                               42
     C     *IN42         CABEQ     *ON           DSPB
      * INVOICE SELECTED
     C     SELB          CABNE     *BLANKS       BYPSEL
     C                   ENDDO
      *------------------------------------------------------------------------*
      * STEP 5.  DELETE SUBFILE
      *------------------------------------------------------------------------*
     C     BYPSEL        TAG
E0   C                   EXSR      CHK_PMTRUN
E0   C                   IF        MSGFLD <> *BLANKS
E0   C                   GOTO      DSPA
E0   C                   ENDIF
     C                   MOVE      '1'           *IN79
     C                   WRITE     APC1112B
     C                   MOVE      '0'           *IN79
      *------------------------------------------------------------------------*
      * SECTION 3         INVOICE HEADER SCREEN
      *
      * STEP 1.  LOAD SCREEN FIELDS
      * STEP 3.  DISPLAY SUBFILE
      * STEP 4.  READ SUBFILE
      * STEP 5.  DELETE SUBFILE
      *------------------------------------------------------------------------*
      * STEP 1.  LOAD SCREEN FIELDS
      *------------------------------------------------------------------------*
     C                   MOVE      *BLANKS       CD57C
     C                   MOVE      *BLANKS       CD57DS
     C                   MOVE      *BLANKS       MSGFLD
     C                   EXSR      LOADC
     C     MSGFLD        IFNE      *BLANKS
     C                   MOVE      *ON           *IN80
     C                   GOTO      DSPA
     C                   ENDIF                                                  MSGFLD NE BL
      *------------------------------------------------------------------------*
     C                   MOVE      *BLANKS       DBTWRN
     C                   MOVE      *BLANKS       MSGFLD
ES   C                   MOVE      *OFF          *IN02
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
   DXC*                  MOVE      *OFF          *IN64
     C                   MOVE      *OFF          *IN65
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN69
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN81
     C                   MOVE      *OFF          *IN82
     C                   MOVE      *OFF          *IN83
     C                   MOVE      *OFF          *IN84
     C                   MOVE      *OFF          *IN85
     C                   MOVE      *OFF          *IN86
     C                   MOVE      *OFF          *IN87
     C                   MOVE      *OFF          *IN88
     C                   MOVE      *OFF          *IN89
     C                   MOVE      *OFF          *IN90
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
     C                   MOVE      *OFF          *IN95
     C                   MOVE      *OFF          *IN96
     C                   MOVE      *OFF          *IN97
     C                   MOVE      *OFF          *IN98
     C                   MOVE      *OFF          *IN99
     C                   MOVE      'N'           F3WRN             1            RESET WARNING
     C                   MOVE      'N'           F11WRN            1            RESET WARNING
     C                   MOVE      'N'           F12WRN            1            RESET WARNING
     C                   MOVE      'N'           WRN04             1
     C                   MOVE      'N'           WRN05             1
     C                   MOVE      'N'           WRNC5             1
     C                   MOVE      *BLANKS       WARNEI
     C                   MOVE      *BLANK        DTEWRN            1
EP   C                   MOVE      *BLANK        DTEWRN2           1
EO   C                   MOVE      *OFF          *IN53
EO   C                   eval      f17text = 'Protect'
EJ    * If this is an unapproved credit/debit memo that references
EJ    * an invoice, re-default fields from the referenced invoice...
EJ   C                   IF        APCD09 <> 'Y'
EJ   C                             and CD26K <> 'I'
EJ   C                             and NO26K <> *blanks
EJ   C                   EXSR      LOAD_REF
EJ   C                   ENDIF
     C     PCTL#         IFNE      0
     C     APFL01        IFEQ      'Y'
     C     APAM26        ANDNE     0
     C                   MOVEA     EMS(67)       MSGFLD
     C                   MOVE      *ON           *IN92
     C                   MOVE      *ON           *IN99
     C                   ENDIF
     C     APCD45        IFEQ      'Y'
     C     APAM13        ANDNE     0
     C     MSGFLD        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN85
     C                   MOVE      *ON           *IN98
     C                   MOVE      'Y'           DFIFLG
     C                   MOVEA     UMS(31)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C     DSPC          TAG
ER   C     ICSYS         IFEQ      'Y'
E4   C     ezApSys       OREQ      'Y'
ER   C                   MOVE      *ON           *IN26
ER   C                   ENDIF
EZ    *
EZ    * See if user is authorized to change P/O vendor...
EZ   C                   CLEAR                   OVRAUT
EZ   C                   MOVEL     USRNM         USER
EZ   C                   Z-ADD     3             ID
EZ   C                   MOVE      'AP'          APP
EZ   C                   MOVE      'APM '        CDE
EZ   C                   MOVE      *BLANKS       USRVAL
EZ   C                   MOVE      *BLANKS       VALFRM
EZ   C                   MOVE      *BLANKS       RTNCOD
EZ   C                   CALL      'OPR8220'     PL8220
EZ   C     RTNCOD        IFEQ      '0'
EZ   C                   MOVEL     USRVAL        OVRAUT            1
EZ   C                   ENDIF
EZ    * Authority to Override 1099 Code
EZ   C                   MOVE      *IN52         SV52              1
EZ   C                   MOVE      *OFF          *IN52
EZ   C     Allow1099Ovr  IFNE      'Y'
EZ   C     OVRAUT        ORNE      'Y'
EZ   C     APCD38        OREQ      *BLANKS
EZ   C     APCD38        OREQ      'N'
EZ   C                   MOVE      *ON           *IN52
EZ   C                   ENDIF
      *
      * SEE IF THERE IS ANYTHING REFERENCING THIS INVOICE THAT IS ON
      * HOLD...
      *
     C     NO26K         IFEQ      *BLANKS
     C     APCD09        ANDNE     'Y'
      *
     C     APNO20        CHAIN     APLWINHR                           40
     C     *IN40         DOWEQ     *OFF
      *
     C     A$CD43        IFEQ      'Y'
     C     A$CD10        ORNE      'R'
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVE      UMS(6)        MSGFLD
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF                                                  A$CD43=Y
      *
     C     APNO20        READE     APLWINHR                               40
     C                   ENDDO
      *
     C                   ENDIF
      * SEE IF ON REFERENCE HOLD...
     C     APCD10        IFEQ      'R'
     C                   MOVE      *ON           *IN29
     C                   ELSE
     C                   MOVE      *OFF          *IN29
     C                   ENDIF
      * REFERENCE NOT ALLOWED IF THIS INVOICE IS REFERENCED BY
      * ANOTHER INVOICE...
     C     APNO20        SETLL     APLWINHR                               37
      *
D4    * Display alternative format if in MYHD env.
D4   C                   If        QQF = 'QQF'
EB    * 'RI' Issue in Myhd env.
EB ECC*                  Eval      Apnt01sv = Apnt01
EB ECC*                  Eval      Stsnotsv = Stsnot
EB ECC*                  Eval      Vndnotsv = Vndnot
EB ECC*                  Eval      Refnotsv = Refnot
EB ECC*                  Eval      Apnt01 = %Subst(Apnt01:2:%Len(Apnt01)-1)
EB ECC*                  Eval      Stsnot = %Subst(Stsnot:2:%Len(Stsnot)-1)
EB ECC*                  Eval      Vndnot = %Subst(Vndnot:2:%Len(Vndnot)-1)
EB ECC*                  Eval      Refnot = %Subst(Refnot:2:%Len(Refnot)-1)
D4   C                   EXFMT     APF1112CW
E3   C                   if        ALNLFTRF# <> 'Y'
E3   C                   evalR     NO26K = %TrimR(NO26K)
E3   C                   endif
EB ECC*                  Eval      Apnt01 = Apnt01sv
EB ECC*                  Eval      Stsnot = Stsnotsv
EB ECC*                  Eval      Vndnot = Vndnotsv
EB ECC*                  Eval      Refnot = Refnotsv
D4   C                   Else
     C                   EXFMT     APF1112C
D4   C                   Endif
D4    *
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVE      *OFF          CKTRM             1
     C                   MOVE      'N'           POCHG             1
     C                   MOVE      'N'           VRCHG             1
     C                   MOVE      'N'           SKPCHG            1
DT   C                   MOVE      'N'           MFRT_CHG          1
ES   C                   MOVE      *OFF          *IN02
EZ   C                   MOVE      SV52          *IN52
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN38
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN81
     C                   MOVE      *OFF          *IN82
     C                   MOVE      *OFF          *IN83
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN84
     C                   MOVE      *OFF          *IN86
     C                   MOVE      *OFF          *IN85
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN87
     C                   MOVE      *OFF          *IN88
     C                   MOVE      *OFF          *IN89
     C                   MOVE      *OFF          *IN90
     C                   MOVE      *OFF          *IN95
     C                   MOVE      *OFF          *IN96
     C                   MOVE      *OFF          *IN97
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
   DXC*                  MOVE      *OFF          *IN64
     C                   MOVE      *OFF          *IN65
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN71
EZ   C                   MOVE      *OFF          *IN73
     C                   MOVE      *OFF          *IN79
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
     C                   MOVE      *OFF          *IN98
     C                   MOVE      *OFF          *IN99
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPC
     C                   ENDIF
      * RE-CALCULATE AMOUNTS
      ** DISCOUNT AMOUNT
     C     PC01C         IFGT      0
¢L   C     APCD46        ANDNE     'Y'                                          EDI invoice
     C                   MOVE      PC01C         PERC              3 3
     C     PERC          MULT(H)   APAM04        APAM05
ES   C     PERC          MULT(H)   APAM04        wrkDisAmt1
     C                   ENDIF
      ** INHERENT FREIGHT DISCOUNT AMOUNT...
     C     PC40C         IFGT      0
     C                   MOVE      PC40C         PERC
     C     PERC          MULT(H)   APAM04        APAM40
ES   C     PERC          MULT(H)   APAM04        wrkDisAmt2
     C                   ENDIF
      ** OTHER CHARGES
     C     OTHCHG        IFNE      'Y'
     C                   Z-ADD     0             APTL03
      * IF INVOICE TYPE IS CREDIT,DEBIT
      * REMOVE ANY MATCHING TO OTHER CHARGES
     C     CD26K         IFNE      'I'
EK   C     REB_CR        ANDNE     'Y'
     C                   Z-ADD     VNDRTN        ENTRTN
     C                   EXSR      RMVOTH
     C                   EXSR      GETMHV
     C                   Z-ADD     ENTRTN        VNDRTN
     C                   ENDIF                                                  CD26K NE I
     C                   ENDIF
      ** NET AMOUNT
     C     APAM04        ADD       APAM14        APAM06                         GROSS+TAX
     C                   ADD       APAM13        APAM06                         + PPD FRT
     C                   ADD       APAM26        APAM06                         + FRT OUT
     C                   ADD       APTL03        APAM06                         + OTHER CHARGES
¢H   C                   IF        APAM04 > *Zero
     C                   SUB       APAM05        APAM06                         - DISC = NET
¢H   C                   ELSE
¢H   C                   z-add     *zero         APAM05                         clear disc on credt
¢H   C                   ENDIF
      * DETERMINE IF FREIGHT ONLY INVOICE
     C     APCD29        IFNE      'Y'
     C     APAM04        ANDEQ     0
     C     APAM13        ANDNE     0
     C     APCD29        ORNE      'Y'
     C     APAM04        ANDEQ     0
     C     APAM26        ANDNE     0
DT   C     FRTVEND       OREQ      'Y'
     C                   MOVE      'Y'           FRTONL
     C                   ELSE
     C                   MOVE      'N'           FRTONL
     C                   ENDIF
      * PROMPT
     C     *IN04         IFEQ      *ON
     C                   EXSR      @PRMPT
     C                   ENDIF
     C     *IN04         CABEQ     *ON           DSPC
     C                   EXSR      @CLCSR
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C                   MOVE      'N'           F11WRN                         RESET WARNING
     C                   MOVE      'N'           F12WRN                         RESET WARNING
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPC
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO PREVIOUS SCREEN
     C     *IN12         IFEQ      *ON
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C                   MOVE      'N'           F11WRN                         RESET WARNING
     C     F12WRN        IFEQ      'N'
     C                   MOVEA     EMS(7)        MSGFLD
     C                   MOVE      'Y'           F12WRN
     C                   GOTO      DSPC
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * RETURN TO INVOICE NUMBER PROMPT
     C     PCTL#         IFEQ      0
     C                   GOTO      DSPZ
     C                   ELSE
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      'N'           F12WRN
      * DELETE INVOICE
     C     *IN11         IFEQ      *ON
      * IF ANY INVOICES ARE REFERRING TO IT, DO NOT ALLOW DELETE...
     C     APNO20        SETLL     APLWINHR                               40
     C     *IN40         IFEQ      *ON
     C                   MOVEL     UMS(10)       MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPC
     C                   ENDIF
      * IF INVOICE IS REFERENCING AN INVOICE THAT IS APPROVED OR
      * MATCHED AND NOT ON VARIANCE HOLD, DO NOT ALLOW DELETE...
     C     NO26K         IFNE      *BLANKS
     C     REFCTL        CHAIN     APFTINH0                           40
     C     *IN40         IFEQ      *ON
     C     REFCTL        CHAIN     APFWINH5                           40
     C                   ENDIF
     C     *IN40         IFEQ      *OFF
     C     AXFL01        ANDEQ     'N'
     C     AXCD10        ANDNE     'H'                                          VAR HOLD
     C     *IN40         OREQ      *OFF
     C     AXCD09        ANDEQ     'Y'
     C                   MOVE      *ON           *IN65
     C                   MOVEA     EMS(12)       MSGFLD
     C                   GOTO      DSPC
     C                   ENDIF
     C                   ENDIF
     C     F11WRN        IFEQ      'N'
     C                   MOVEA     EMS(8)        MSGFLD
     C                   MOVE      'Y'           F11WRN
     C                   GOTO      DSPC
     C                   ENDIF
D0   C     ICSYS         IFEQ      'Y'
EL    * Determine if licensed to this product...
EL    * The following license key checking logic may not be altered, bypassed or removed.
EL    * See Legal Document in WRKMINKEY command for more information.
EL   C                   if        LicToDII
D0   C                   CLEAR                   QSEARCH
D0   C                   MOVEL     'QREINDEX'    QSEARCH
D0   C                   CALL      'OPC9832 '
D0   C                   PARM                    QSEARCH          10
EL   C                   else
EL    * Display error message if not licensed to DII (IntelliChief)
EL   C                   call      'MNR1300'     PL1300
EL   C                   endif
D0   C                   ENDIF
     C                   EXSR      DELET
DX D0C*    ICSYS         IFEQ      'Y'
DX D0C*                  CLEAR                   QSEARCH
DX D0C*                  MOVEL     'QREINDEX'    QSEARCH
DX D0C*                  CALL      'OPC9832 '
DX D0C*                  PARM                    QSEARCH          10
DX D0C*                  ENDIF
     C     PCTL#         IFEQ      0
     C                   GOTO      DSPZ
     C                   ELSE
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      'N'           F11WRN                         RESET WARNING
DX   C     *IN23         IFEQ      *ON
DX   C     ICSYS         IFEQ      'Y'
EL    * Determine if licensed to this product...
EL    * The following license key checking logic may not be altered, bypassed or removed.
EL    * See Legal Document in WRKMINKEY command for more information.
EL   C                   if        LicToDII
DX   C                   CLEAR                   QSEARCH
DX   C                   MOVEL     'QSEARCH'     QSEARCH
DX   C                   CALL      'OPC9832 '
DX   C                   PARM                    QSEARCH          10
EL    * Display error message if not licensed to DII (IntelliChief)
EL   C                   else
EL   C                   call      'MNR1300'     PL1300
EL   C                   endif
EV   C                   else
EV   C                   if        ezApFnd = 'Y'
EV   C                   move      apno20        apiin             7
EV   C                   call      'OPR9811'
EV   C                   parm                    apiin
EV   C                   endif
DX   C                   ENDIF
DX   C                   GOTO      DSPC
DX   C                   ENDIF
DX   C     *IN19         IFEQ      *ON
DX   C     ICSYS         IFEQ      'Y'
EL    * Determine if licensed to this product...
EL    * The following license key checking logic may not be altered, bypassed or removed.
EL    * See Legal Document in WRKMINKEY command for more information.
EL   C                   if        LicToDII
DX   C                   CLEAR                   QSEARCH
DX   C                   MOVEL     'QREINDEX'    QSEARCH
DX   C                   CALL      'OPC9832 '
DX   C                   PARM                    QSEARCH          10
EL    * Display error message if not licensed to DII (IntelliChief)
EL   C                   else
EL   C                   call      'MNR1300'     PL1300
EL   C                   endif
DX   C                   ENDIF
DX   C                   GOTO      DSPC
DX   C                   ENDIF
      * INVOICE NOTES ENTRY
     C     *IN06         IFEQ      *ON
     C                   EXSR      INVNOT
     C                   GOTO      DSPC
     C                   ENDIF
      * DISPLAY PURCHASE ORDER NOTES TO ACCOUNTS PAYABLE
     C     *IN07         IFEQ      *ON                                                      ES
     C     NUMPO         IFEQ      1
     C                   MOVE      'Y'           DSPF3
     C                   MOVE      '1'           NOTTYP
     C                   CALL      'POR0140'     PL0140
     C                   ELSE
     C                   MOVE      'N'           WHRFRM            1
     C                   EXSR      DSPPO
     C                   ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
      * REMIT TO ADDRESS ENTRY
     C     *IN08         IFEQ      *ON
     C                   EXSR      RMTADD
     C                   GOTO      DSPC
     C                   ENDIF
      * CHANGE P/O OR V/R VENDOR NUMBER TO A/P VENDOR NUMBER
EK    * NOTE: F9 is disabled for rebate credits.
     C     *IN09         IFEQ      *ON
     C     SKIPPO        ANDEQ     'N'
     C     NO01C         ANDNE     0
     C     APCD09        ANDNE     'Y'
      * If the user is not authorized, do not allow...
     C     CPOAUT        IFNE      'Y'
     C                   MOVEA     EMS(124)      MSGFLD
     C                   GOTO      DSPC
     C                   ENDIF
      * IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
      * CHANGE P/O VENDOR NUMBER TO A/P VENDOR NUMBER
     C     PO#           IFNE      0
     C                   MOVE      PO#           CHGPO#
     C                   MOVE      NO01C         CHGVEN
     C                   CALL      'APR1070'     PL1070
     C                   MOVE      *ON           CKTRM
     C                   ENDIF                                                  PO# NE 0
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
      * CHANGE V/R VENDOR NUMBER TO A/P VENDOR NUMBER
     C     VNDRTN        IFNE      0
     C                   CALL      'APR1072'     PL1072
     C                   GOTO      DSPC
     C                   ENDIF                                                  VNDRTN NE 0
     C                   ENDIF                                                  CD26K EQ I
     C                   ENDIF
      * DISPLAY RECEIVING NOTES TO ACCOUNTS PAYABLE
     C     *IN10         IFEQ      *ON                                                      ES
   DSC*    NUMPO         IFEQ      1
   DSC*                  MOVE      'Y'           DSPF3
   DSC*                  MOVE      '3'           NOTTYP
   DSC*                  CALL      'POR0140'     PL0140
DS   C                   MOVE      '3'           modecde
DS   C                   MOVE      'I'           mori
DS   C     NUMRC         IFEQ      1
DS   C                   CALL      'POR0141'     PL0141
     C                   ELSE
     C                   MOVE      'N'           WHRFRM
     C                   EXSR      DSPPO
     C                   ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
      * DISPLAY VENDOR INFORMATION
     C     *IN13         IFEQ      *ON
     C                   CALL      'APR4015'     PL4015
     C                   GOTO      DSPC
     C                   ENDIF
      * DISPLAY MATCHING INFORMATION
EK    * NOTE: F14 is disabled for rebate credits.
     C     *IN14         IFEQ      *ON                                                      ES
DK   C     SKIPPO        IFEQ      'Y'                                                      ES
DT   C     MATCH_FRT     ANDEQ     'N'                                                      ES
DK   C                   MOVEA     UMS(36)       MSGFLD
DK   C                   ELSE
     C                   MOVE      'S'           WHRFRM            1
      ** IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
     C                   EXSR      DSPPO
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
     C                   EXSR      DSPVR
      * IF VENDOR RETURN SELECTION CHANGED
      * RELOAD VENDOR RETURN OTHER CHARGES SAVE SUBFILE
      * RECALC OTHER CHARGES TOTAL
     C     SELRTN        IFEQ      'Y'
     C                   MOVE      'Y'           CLCOC
     C                   EXSR      LOADOC
     C                   ENDIF                                                  SELRTN EQ Y
     C                   ENDIF                                                  CD26K EQ I
DK   C                   ENDIF                                                  CD26K EQ I
     C                   GOTO      DSPC
     C                   ENDIF
      * DISPLAY MATCHING VARIANCE
     C     *IN15         IFEQ      *ON                                                      ES
     C     SKIPPO        IFEQ      'Y'
DT   C     MATCH_FRT     ANDNE     'Y'
     C                   MOVEA     UMS(27)       MSGFLD
     C                   ELSE
     C                   EXSR      VARPGM
     C                   ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
D1    * SELECT MATCH LINES
D1   C     *IN16         IFEQ      *ON
D1   C                   SELECT
D1   C                   WHEN      DIRECT = 'L'
D1   C     MSGFLD        IFEQ      *BLANKS
D1   C                   EVAL      MSGFLD = 'F16 not allowed for job -
D1   C                             lot invoices.'
D1   C                   ENDIF
D1   C                   WHEN      SKIPPO = 'Y'
D1   C                             AND MATCH_FRT <> 'Y'
D1   C     MSGFLD        IFEQ      *BLANKS
D1   C                   EVAL      MSGFLD = 'You must specify either -
D1   C                             skip match "N" or match freight "Y" -
D1   C                             to use F16.'
D1   C                   ENDIF
D1   C                   OTHER
D1   C                   EXSR      SELMTH
D1   C                   ENDSL
D1   C                   GOTO      DSPC
D1   C                   ENDIF
      * PROTECT/UN-PROTECT DISCOUNT % ?
     C     *IN17         IFEQ      *ON
     C     *IN53         IFEQ      *OFF
     C                   MOVE      *ON           *IN53
EO   C                   eval      f17text = 'UnProtect'
     C                   ELSE
     C                   MOVE      *OFF          *IN53
EO   C                   eval      f17text = 'Protect'
     C                   MOVE      *ON           *IN54
     C                   ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
      * INVOICE CHECK NOTES ENTRY
     C     *IN18         IFEQ      *ON
     C                   EXSR      CHKNOT
     C                   GOTO      DSPC
     C                   ENDIF
      * DISPLAY MORE KEYS
     C     *IN24         IFEQ      *ON
ER   C     *IN69         IFEQ      *OFF
ER   C                   MOVE      *ON           *IN69
ER   C                   ELSE
ER   C                   MOVE      *OFF          *IN69
ER   C                   ENDIF
   DXC*    *IN69         IFEQ      *OFF
   DXC*                  MOVE      *ON           *IN69
   DXC*                  ELSE
   DXC*                  MOVE      *OFF          *IN69
   DXC*                  ENDIF
DX ER *
DX ER * N69 AND N26 = VIEW 1 FUNCTION KEYS
DX ER *  69 AND N26 = VIEW 2 FUNCTION KEYS
DX ER *  69 AND  26 AND ICSYS INSTALLED = VIEW 3 FUNCTION KEYS
DX ER *
DX ER * GO FROM VIEW 1 TO VIEW 2
DX ERC*    *IN69         IFEQ      *OFF
DX ERC*    *IN26         ANDEQ     *OFF
DX ERC*                  MOVE      *ON           *IN69
DX ERC*                  MOVE      *OFF          *IN26
DX ERC*                  ELSE
DX ER * GO FROM VIEW 2 TO VIEW 1
DX ERC*    ICSYS         IFNE      'Y'
EV ERC*    ezApFnd       ANDNE     'Y'
DX ERC*                  MOVE      *OFF          *IN69
DX ERC*                  MOVE      *OFF          *IN26
DX ERC*                  ELSE
DX ER * GO FROM VIEW 2 TO VIEW 3
DX ERC*    *IN26         IFEQ      *OFF
DX ERC*                  MOVE      *ON           *IN26
DX ERC*                  MOVE      *ON           *IN69
DX ERC*                  ELSE
DX ER * GO FROM VIEW 3 TO VIEW 1
DX ERC*                  MOVE      *OFF          *IN26
DX ERC*                  MOVE      *OFF          *IN69
DX ERC*                  ENDIF
DX ERC*                  ENDIF
DX ERC*                  ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
¢I    * Allow User to Access Bank Info Screen APF1112U
¢I   C     *IN21         IFEQ      *ON
¢I   C                   EXSR      ACH
¢I   C                   GOTO      DSPC
¢I   C                   ENDIF
      * REDO ADDRESS IF ALTERNATE VENDOR CHANGED
     C     NO25C         IFNE      HO25C
     C                   EXSR      ADDSR
     C                   EXSR      RMTADD
     C                   EXSR      GETALT
     C                   MOVE      NO25C         HO25C
     C                   GOTO      DSPC
     C                   ENDIF
      * RESET FLAGS IF HEADER CHANGED
      * REDISPLAY TERMS SCREEN IF ANYTHING ON HEADER IS CHANGED
     C     *IN51         IFEQ      *ON
     C                   MOVE      *ON           CKTRM
     C                   ENDIF
      * DETERMINE IF P/O OR VENDOR RETURN INFO TO BE SHOWN
     C     CD26K         IFEQ      'I'
     C                   MOVE      *OFF          *IN59
     C                   ELSE
     C     SKIPPO        IFEQ      'Y'
     C                   MOVE      *OFF          *IN59
     C                   ELSE
     C                   MOVE      *ON           *IN59
     C                   ENDIF                                                  SKIPPO EQ Y
     C                   ENDIF                                                  CD26K EQ I
EK   C                   IF        REB_CR = 'Y'
EK   C                   EVAL      *IN77 = *ON
EK   C                   ELSE
EK   C                   EVAL      *IN77 = *OFF
EK   C                   ENDIF
      ** P/O NUMBER CHANGED, CLEAR RECEIVER NUMBER AND DIRECT FLAG
     C     PO#           IFNE      LSTPO
     C     CD26K         ANDEQ     'I'
     C                   MOVE      *ZEROS        RCV#
     C                   MOVE      *BLANKS       DIRECT
     C                   ENDIF
      ** SKIP MATCH CHANGED TO YES
      ** AND LAST SKIP MATCH IS NO
      ** CLEAR VENDOR RETURN NUMBER
     C     SKIPPO        IFEQ      'Y'
     C     LSTSKP        ANDNE     'Y'
     C                   MOVE      *ZEROS        VNDRTN
     C                   ENDIF
      * REFERENCE NUMBER
     C     APCD09        IFNE      'Y'
     C     NO26K         IFNE      *BLANKS
      * DO NOT ALLOW REFERENCE NUMBER IF MATCHING
     C     SKIPPO        IFNE      'Y'
     C                   MOVE      *ON           *IN65
     C                   MOVEL     UMS(14)       MSGFLD
     C                   MOVE      *ZEROS        REFCTL
     C                   ELSE
      * DO NOT ALLOW REFERENCE NUMBER IF INVOICE
     C     CD26K         IFEQ      'I'
     C                   MOVE      *ON           *IN65
     C                   MOVEL     UMS(23)       MSGFLD
     C                   MOVE      *ZEROS        REFCTL
     C                   ENDIF
     C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       DSPC
EH    * DO NOT ALLOW REFERENCE NUMBER SAME AS INVOICE NUMBER
EH   C                   IF        NO26K = NO11C
EH   C                   EVAL      *IN65 = *ON
EH   C                   EVAL      MSGFLD = 'Reference number cannot +
EH   C                             be the same as the invoice number.'
EH   C                   MOVE      *ZEROS        REFCTL
EH   C                   ENDIF
EH   C     MSGFLD        CABNE     *BLANKS       DSPC
      ** REFERENCE NUMBER SELECTION
     C     NO26K         IFNE      SAVREF
     C                   EXSR      GETREF
      ** REFERENCE NUMBER INVALID
     C     LSTRNN        IFEQ      0
     C                   MOVE      *ON           *IN65
     C     REFFND        IFEQ      'Y'
     C                   MOVEA     EMS(30)       MSGFLD
     C                   ELSE
     C                   MOVEL     EMS(31)       MSGFLD
     C                   ENDIF                                                  REFFND EQ Y
     C                   ELSE
      ** REFERENCE NUMBER NOT SELECTED
     C     LSTRNN        IFGT      1
     C     REFCTL        IFEQ      0
     C                   MOVE      *ON           *IN65
     C                   MOVEA     EMS(32)       MSGFLD
     C                   ENDIF                                                  REFCTL EQ 0
     C                   ENDIF                                                  LSTRNN GT 1
     C                   ENDIF                                                  LSTRNN EQ 0
     C     MSGFLD        CABNE     *BLANKS       DSPC
     C                   MOVE      NO26K         SAVREF
     C                   MOVE      *ON           *IN35
     C                   Z-ADD     AXNO25        NO25C
     C                   Z-ADD     AXNO25        HO25C
     C                   MOVE      AXAD04        AD04C
     C                   MOVE      AXAD05        AD05C
     C                   MOVE      AXAD06        AD06C
     C                   MOVE      AXCY02        CY02C
     C                   MOVE      AXST02        ST02C
     C                   MOVE      AXZP08        ZP08C
     C                   MOVEA     UMS(19)       MSGFLD
     C                   EXSR      RMTADD
     C                   MOVE      *ON           *IN83
     C                   MOVE      *ON           *IN91
     C                   MOVE      *ON           *IN88
     C                   MOVE      *ON           *IN95
     C                   MOVE      *ON           *IN67
     C                   MOVE      *ON           *IN63
     C                   MOVE      *ON           *IN31
     C                   Z-ADD     APBR#N        APBR#C
     C                   Z-ADD     AXNO38        NO38C
     C                   Z-ADD     AXMO06        DUEMO
     C                   Z-ADD     AXDY06        DUEDY
     C                   Z-ADD     AXCC06        DUECC
     C                   Z-ADD     AXYR06        DUEYR
     C                   Z-ADD     AXMO11        DSCMO
     C                   Z-ADD     AXDY11        DSCDY
     C                   Z-ADD     AXCC11        DSCCC
     C                   Z-ADD     AXYR11        DSCYR
      * Load ACH fields...
     C                   MOVE      AXCD67        CD67
     C                   MOVE      AXCD68        CD68
     C                   Z-ADD     AXNO53        NO53
     C                   MOVE      AXCD60        CD60
     C                   Z-ADD     AXMO21        PPMO
     C                   Z-ADD     AXDY21        PPDY
     C                   Z-ADD     AXCC21        PPCC
     C                   Z-ADD     AXYR21        PPYR
      * If payment type is not draft, turn off draft indicator...
     C     CD67          IFNE      'D'
     C                   MOVE      *OFF          *IN36
     C                   ENDIF
      *
     C                   EXSR      LODGLA
     C                   MOVEA     UMS(19)       MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPC
     C                   ENDIF                                                  NO26K NE SAVREF
     C                   ELSE
     C                   MOVE      *OFF          *IN35
     C     SAVREF        IFNE      *BLANKS
     C                   Z-ADD     0             NO25C
     C                   Z-ADD     0             HO25C
     C                   MOVEA     UMS(18)       MSGFLD
     C                   EXSR      ADDSR
     C                   EXSR      RMTADD
     C                   MOVE      NO25C         HO25C
     C                   MOVE      APNO37        NO38C
     C                   EXSR      CALCDT
     C                   Z-ADD     CLCDT         DSCDTC
     C                   Z-ADD     1             DATYP
     C                   MOVE      DSCYR         DATE2
     C                   MOVE      DS2000        PM2000
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000
     C                   MOVE      DATE4         DSCCY             4 0
     C                   MOVE      DACEN         DSCCC
     C                   Z-ADD     DSCDTC        DUEDTC
     C                   Z-ADD     DSCCC         DUECC
     C                   MOVE      '*'           CD16C
     C                   EXSR      LODGLA
     C                   MOVE      *ON           *IN83
     C                   MOVE      *ON           *IN91
     C                   MOVE      *ON           *IN88
     C                   MOVE      *ON           *IN95
     C                   MOVE      *ON           *IN67
     C                   MOVE      *ON           *IN63
     C                   MOVEA     UMS(18)       MSGFLD
     C                   ENDIF
     C                   MOVE      *BLANKS       SAVREF
     C                   Z-ADD     0             REFCTL
     C     MSGFLD        CABNE     *BLANKS       DSPC
     C                   ENDIF                                                  NO26K NE *BLANKS
     C                   ENDIF                                                  APCD09 NE Y
      *------------------------------------------------------------------------*
      * STEP 4. * ERROR EDITING
      *------------------------------------------------------------------------*
     C                   EXSR      EDITC
     C     APCD09        IFNE      'Y'
     C                   EXSR      EDITC1
     C                   EXSR      EDITC2
     C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       DSPC
      * REMOVE MATCHING
      ** IF NOT APPROVED
      ** IF SKIP MATCH IS YES
      ** AND LAST SKIP MATCH IS NO
     C     APCD09        IFNE      'Y'
     C     SKIPPO        ANDEQ     'Y'
     C     LSTSKP        ANDNE     'Y'
      ** IF ORIGINAL SKIP MATCH IS YES
      ** DELETE ALL MATCHING
     C     ORGSKP        IFEQ      'Y'
     C                   EXSR      DLTMTH
     C                   ELSE
      ** IF ORIGINAL SKIP MATCH IS NO
      ** REMOVE LAST MATCHING
     C                   EXSR      RMVMTH
     C                   ENDIF
     C                   MOVE      *ZEROS        RCV#
     C                   MOVE      *ZEROS        LSTPO
     C                   MOVE      *ZEROS        LSTRCV
     C                   MOVE      *BLANKS       LSTDIR
     C                   MOVE      'N'           LSTFRT
     C                   MOVE      *ZEROS        VNDRTN
     C                   MOVE      *ZEROS        LSTRTN
     C                   MOVE      *BLANKS       VARCDE
     C                   ENDIF
DT    * REMOVE FREIGHT MATCHING
DT    ** IF MATCH FREIGHT IS NO
DT    ** AND LAST MATCH FREIGHT IS YES
DT   C     MATCH_FRT     IFNE      'Y'
DT   C     LST_MATCH_FRT ANDEQ     'Y'
DT    ** IF ORIGINAL MATCH FREIGHT IS NO
DT    ** DELETE ALL MATCHING
DT   C     ORG_MATCH_FRT IFNE      'Y'
DT   C                   EXSR      DLTMTH_FRT
DT   C                   ELSE
DT    ** IF ORIGINAL FREIGHT MATCH IS YES
DT    ** REMOVE LAST MATCHING
DT   C                   EXSR      RMVMTH_FRT
DT   C                   ENDIF
DT   C                   MOVE      *ZEROS        RCV#
DT   C                   MOVE      *ZEROS        LSTPO
DT   C                   MOVE      *ZEROS        LSTRCV
DT   C                   MOVE      *BLANKS       LSTDIR
DT   C                   MOVE      'N'           LSTFRT
DT   C                   MOVE      *ZEROS        VNDRTN
DT   C                   MOVE      *ZEROS        LSTRTN
DT   C                   MOVE      *BLANKS       VARCDE_F
DT   C                   ENDIF
      * SELECT P/O OR VENDOR RETURN FOR MATCHING
      ** IF NOT APPROVED
      ** IF SKIP MATCH IS NO
     C     APCD09        IFNE      'Y'
     C     SKIPPO        ANDNE     'Y'
DT   C     MATCH_FRT     OREQ      'Y'
     C                   MOVE      'N'           GETORG            1
     C                   MOVE      'E'           ACTION
     C                   SELECT
     C     CD26K         WHENEQ    'I'
     C     PO#           IFEQ      0
     C     RCV#          ANDEQ     0
     C     PO#           ORNE      LSTPO
     C     RCV#          ORNE      LSTRCV
     C     PO#           OREQ      LSTPO
     C     FRTONL        ANDNE     LSTFRT
     C     FRTONL        ANDNE     'Y'
     C                   EXSR      SELMTH
     C     EXIT          CABEQ     *ON           DSPC
     C                   ENDIF                                                  PO# EQ 0
     C     CD26K         WHENNE    'I'
     C     VNDRTN        IFEQ      0
EK   C     REB_CR        ANDNE     'Y'
     C     VNDRTN        ORNE      LSTRTN
EK   C     REB_CR        ANDNE     'Y'
     C                   EXSR      SELMTH
     C     EXIT          CABEQ     *ON           DSPC
     C                   ENDIF                                                  VNDRTN EQ 0
     C                   ENDSL
     C                   ENDIF                                                  SKIPPO NE Y
      * IF SKIPPO HAS CHANGED SET CHANGE FLAG FOR G/L RELOAD
     C     SKIPPO        IFNE      LSTSKP
     C                   MOVE      'Y'           SKPCHG
     C                   ENDIF                                                  SKIPPO NE LSTSKP
DT    * IF MATCH FREIGHT HAS CHANGED SET CHANGE FLAG FOR G/L RELOAD
DT   C     MATCH_FRT     IFNE      LST_MATCH_FRT
DT   C                   MOVE      'Y'           MFRT_CHG
DT   C                   ENDIF
      * SAVE LAST SKIP MATCH
     C                   MOVE      SKIPPO        LSTSKP
DT   C                   MOVE      MATCH_FRT     LST_MATCH_FRT
     C     APCD09        IFNE      'Y'
      * PROTECT SCREEN FIELDS
     C                   EXSR      PROTCT
      * IF MULTIPLE G/L REQUESTED
      * CLEAR G/L ACCOUNT INFORMATION
     C     CD16C         IFEQ      'Y'
     C                   MOVE      *ZEROS        GLNOC
     C                   MOVE      *BLANKS       GDN03C
     C                   ENDIF
      * DETERMINE IF G/L ACCOUNT NEEDS TO BE LOADED
     C                   EXSR      LODGLA
     C     MSGFLD        CABNE     *BLANKS       DSPC
      * EDIT MATCHING
     C                   EXSR      EDITC2
     C     MSGFLD        CABNE     *BLANKS       DSPC
      * EDIT G/L INFORMATION
     C                   EXSR      EDITC3
     C     MSGFLD        CABNE     *BLANKS       DSPC
      *
      * DISPLAY TERMS VERIFICATION - P/O vs A/P
     C     CKTRM         IFEQ      *ON
     C     SHOTRM        ANDEQ     'Y'
     C     SKIPPO        IFNE      'Y'
     C     FRTONL        ANDNE     'Y'
     C     CD26K         ANDEQ     'I'
      *
     C                   Z-ADD     1             RNO
     C                   MOVE      'N'           DSPTRM            1
     C     RNO           CHAIN     APS1112O                           42
     C     *IN42         DOWEQ     *OFF
      * P/O DUE DATE
     C                   MOVE      POMO06        CMPMO1
     C                   MOVE      PODY06        CMPDY1
     C                   MOVE      POCC06        CMPCC1
     C                   MOVE      POYR06        CMPYR1
      * INVOICE DUE DATE
     C                   MOVE      DUEMO         CMPMO2
     C                   MOVE      DUEDY         CMPDY2
     C                   MOVE      DUECC         CMPCC2
     C                   MOVE      DUEYR         CMPYR2
      *
     C     POPC01        IFNE      PC01C                                        DISCOUNT %
     C     PODSAM        ORNE      APAM05                                       DISCOUNT $$
     C     POAM03        ORNE      APAM13                                       FRGHT/HDLG $
     C     PODUDT        ORGT      0                                            P/O DUE DATE
     C     CMPDT1        ANDNE     CMPDT2
     C                   MOVE      'Y'           DSPTRM
     C                   ENDIF
      *
     C                   ADD       1             RNO
     C     RNO           CHAIN     APS1112O                           42
     C                   ENDDO
      *
     C     DSPTRM        IFEQ      'Y'
     C     NUMPO         IFEQ      1
     C                   EXSR      CKTERM
     C                   ELSE
     C                   MOVE      'T'           WHRFRM
     C                   EXSR      DSPPO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
     C                   ENDIF                                                  APCD09 NE Y
      * REDISPLAY SCREEN IF ANY CHANGES MADE ON SCREEN
     C     *IN51         CABEQ     *ON           DSPC
      * FORCE CHANGE P/O VENDOR IF NOT SAME AS INVOICE VENDOR
     C     POVEND        IFNE      NO01C
     C     SKIPPO        ANDNE     'Y'
      * CHECK TO SEE IF P/O VENDOR AND INVOICE VENDOR ARE ASSOCIATED
     C                   MOVE      *BLANKS       ASSOC
     C                   MOVE      POVEND        POVEN
     C                   MOVE      NO01C         INVVEN
     C                   CALL      'APR0145'     PL0145
      * IF VENDORS ARE ASSOCIATED VENDORS,
      * OR VENDORS ARE NOT ASSOCIATED VENDORS AND INV ON MANUAL HOLD,
      * DISPLAY WARNING MESSAGE TO LET USER KNOW THE VENDORS ARE DIFF
     C     ASSOC         IFEQ      'Y'
     C     ASSOC         ORNE      'Y'
     C     CD43K         ANDEQ     'Y'
     C     WRNC5         IFNE      'Y'
     C                   MOVE      'Y'           WRNC5
     C     CD26K         IFEQ      'I'
     C     ASSOC         IFEQ      'Y'
     C                   MOVEA     EMS(122)      MSGFLD
     C                   ELSE
     C                   MOVEA     UMS(24)       MSGFLD
     C                   ENDIF
     C                   ELSE
     C     ASSOC         IFEQ      'Y'
     C                   MOVEA     EMS(123)      MSGFLD
     C                   ELSE
     C                   MOVEA     UMS(25)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      * IF VENDORS ARE NOT ASSOCIATED VENDORS AND INVOICE IS NOT ON
      * MANUAL HOLD,
      * DISPLAY ERROR MESSAGE TO LET USER KNOW THE VENDORS ARE DIFF
      *** USER MUST PUT INVOICE ON MANUAL HOLD OR EXIT INVOICE ENTRY
     C     CD26K         IFEQ      'I'
   DZC*                  MOVEA     EMS(24)       MSGFLD
DZ   C                   MOVEA     UMS(24)       MSGFLD
     C                   ELSE
     C                   MOVEA     UMS(25)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
     C     MSGFLD        IFNE      *BLANKS
     C                   GOTO      DSPC
     C                   ENDIF
     C                   ENDIF
      *------------------------------------------------------------------------*
      *  SECTION 4         FINISH INVOICE HEADER ENTRY
      * STEP 1.  DISPLAY MULTIPLE PAYMENT ENTRY
      * STEP 2.  DISPLAY MULTIPLE G/L ENTRY
      * STEP 3.  WRITE AND UPDATE FILES
      *------------------------------------------------------------------------*
      * STEP 2. * DISPLAY MULTIPLE G/L ENTRY
      *------------------------------------------------------------------------*
     C     *IN33         IFEQ      *OFF
     C     CD16C         IFEQ      'Y'
     C     MLGL          IFEQ      '0'
     C                   EXSR      LOADGL
     C                   ENDIF
     C     FRTONL        IFNE      'Y'
     C                   EXSR      MULGL
     C                   ENDIF
     C                   ENDIF
      * OTHER CHARGES ENTRY
     C     OTHCHG        IFEQ      'Y'
     C                   EXSR      MULOC
     C                   EXSR      GETMHV
      * RE-EDIT SCREEN
     C                   EXSR      EDITC
     C     MSGFLD        CABNE     *BLANKS       DSPC
     C                   ENDIF
     C                   ENDIF
      *------------------------------------------------------------------------*
      * STEP 1. * DISPLAY MULTIPLE PAYMENT ENTRY
      *------------------------------------------------------------------------*
      * IF FREIGHT ONLY INVOICE
      * SKIP MULTIPLE PAYMENT ENTRY
E0    * SKIP IF ACCESSED FROM WORK WITH PAYMENT RUNS
     C     APCD12        IFEQ      'Y'
     C     FRTONL        ANDNE     'Y'
E0   C     PMTRUN        ANDNE     *ON
     C                   EXSR      MULPAY
     C                   ENDIF
      *
      * ACH processing...
      *
     C     CD67          IFEQ      'A'                                          ACH PAYMENT
   EFC*    NO26K         ANDEQ     *BLANKS                                      NO REFERENCE
EJ   C     NO26K         ANDEQ     *BLANKS                                      NO REFERENCE
     C     CD67          OREQ      'P'                                          ACH PRENOTES
   EFC*    NO26K         ANDEQ     *BLANKS                                      NO REFERENCE
EJ   C     NO26K         ANDEQ     *BLANKS                                      NO REFERENCE
     C                   EXSR      ACH
     C     *IN12         CABEQ     *ON           DSPC
     C     *IN03         IFEQ      *ON
     C                   EXSR      UPDMTH
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF
      *
      * DETERMINE IF RECEIVER VARIANCE
     C     SKIPPO        IFNE      'Y'
     C     APCD09        ANDNE     'Y'
DT   C     MATCH_FRT     OREQ      'Y'
     C                   MOVE      *BLANKS       MSGFLD
     C                   EXSR      VARPGM
      * IF ERRORS FOUND IN VARIANCE PROGRAM, RETURN TO INVOICE HEADER
     C     MSGFLD        CABNE     *BLANKS       DSPC
      * IF F3 TAKEN IN VARIANCE PROGRAM, RETURN TO INVOICE HEADER
     C     VARCDE        CABEQ     ' '           DSPC
DT   C     VARCDE_F      CABEQ     ' '           DSPC
     C                   ENDIF
      * EDIT FOR G/L POSTING ERRORS
     C                   MOVE      'N'           GLERR             1
     C     APCD09        IFNE      'Y'
     C                   Z-ADD     NO20C         PCTLNO
     C                   MOVE      'I'           PFILE
EV   C                   IF        APCD46 = 'Y'
EV   C                   MOVE      'O'           PEDIT
EV   C                   ELSE
     C                   MOVE      'E'           PEDIT
EV   C                   ENDIF
     C                   MOVE      'N'           PERRCD
     C                   CALL      'APR2071'     PL2071
     C     PERRCD        IFEQ      'Y'
     C                   MOVE      'Y'           GLERR
     C                   ENDIF
     C     GLERR         IFEQ      'Y'
     C     DSPR          TAG
     C                   EXFMT     APF1112R
     C     *IN12         CABEQ     *ON           DSPC
     C     *IN10         CABEQ     *OFF          DSPR
     C     *IN10         IFEQ      *ON
     C                   MOVE      'Y'           CD43K
     C                   Z-ADD     NO20C         PCTLNO
     C                   MOVE      'I'           PFILE
     C                   MOVE      'P'           PEDIT
     C                   MOVE      'N'           PERRCD
     C                   CALL      'APR2071'     PL2071
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *------------------------------------------------------------------------*
      * STEP 3. * WRITE AND UPDATE FILES
      *------------------------------------------------------------------------*
     C                   EXSR      WRITE
     C     PCTL#         IFEQ      0
     C                   GOTO      DSPZ
     C                   ENDIF
      * END OF PROGRAM
     C     ENDPGM        TAG
     C                   MOVE      '1'           *INLR
     C                   RETURN
E0    *------------------------------------------------------------------------*
E0    * IF THE INVOICE IS ON AN ACTIVE PAYMENT AND THIS PROGRAM WAS NOT
E0    * CALLED FROM WORK WITH PAYMENT RUNS DON'T ALLOW MAINTENANCE
E0    *------------------------------------------------------------------------*
E0   C     CHK_PMTRUN    BEGSR
E0    *.............................................................
E0    * Determine if this program was called from the payment run...
E0   C                   EVAL      PMTRUN = *OFF
E0   C                   EVAL      PGMNAM2 = 'APR7110'
E0   C                   CALL      'OPC2500'     PL2500
E0    * If it's a recursive call that means we got here from the
E0    * check run...
E0   C                   IF        RCCALL = 'Y'
E0   C                   EVAL      PMTRUN = *ON
E0   C                   EVAL      *IN01 = *ON
E0   C                   ENDIF
E0    *.............................................................
E0   C                   CLEAR                   O_YN
E0   C                   CALL      'APR7115'     PL7115
E0   C                   IF        O_YN = 'Y'
E0   C                             AND NOT PMTRUN
E0   C                   EVAL      MSGFLD = 'Maintenance not allowed +
E0   C                             because the invoice is on an active +
E0   C                             payment run.'
E0   C                   ENDIF
E0   C                   ENDSR
      *------------------------------------------------------------------------*
      * LOAD FORMAT C FROM INVOICE RECORD
      *------------------------------------------------------------------------*
     C     VARPGM        BEGSR
     C                   MOVE      'N'           VARCDE
DT   C                   MOVE      'N'           VARCDE_F
     C                   MOVE      'N'           POCHG
     C                   MOVE      'N'           VRCHG
     C                   MOVE      'N'           SKPCHG
DT   C                   MOVE      'N'           MFRT_CHG
      *  CALL RCVR SELECTION PGM
     C     APCD29        IFEQ      'Y'
     C                   MOVE      'N'           INDCDE
     C                   ELSE
     C                   MOVE      '0'           INDCDE
     C                   ENDIF
     C     *IN15         IFEQ      *ON
     C                   MOVE      'Y'           FKEY
     C                   ELSE
     C                   MOVE      'N'           FKEY
     C                   ENDIF
     C     DIRECT        IFNE      'L'
     C     CD26K         IFEQ      'I'
     C     FRTONL        IFNE      'Y'
DP   C                   Z-ADD     APCO#F        PMICO
     C                   CALL      'APR1081'     PL1081
     C                   ENDIF
DT   C     MATCH_FRT     IFEQ      'Y'
DT   C                   Z-ADD     APCO#F        F_CO
DT   C                   Z-ADD     NO01C         F_VEND
DT   C                   Z-ADD     PO#           F_PO
DT   C                   Z-ADD     RCV#          F_RCVR
DT   C                   Z-ADD     APBR#C        F_BR
DT   C                   MOVEL     NO11C         F_INV
DT   C                   Z-ADD     NO20C         F_CTL
DT   C                   Z-ADD     APAM13        F_FRTAMT
DT   C                   MOVEL     INDCDE        F_INDCDE
DT   C                   MOVEL     FRTONL        F_FRTONL
DT   C                   MOVEL     FKEY          F_FKEY
DT    *
DT   C                   CLEAR                   PRETCD
DT   C                   CLEAR                   PFUNKY
DT   C     FRTVEND       IFNE      'Y'
DT   C                   MOVEL     'M'           PACTCD
DT   C                   ELSE
DT   C                   MOVEL     'C'           PACTCD
DT   C                   ENDIF
DT   C                   MOVEL     F_DATA        PDATA
DT    *
DT   C                   CALL      'APR1086'     PL1086
DT   C                   MOVEL     PDATA         F_DATA
DT   C                   ENDIF
     C                   ELSE
EK    * Credit memo matching to rebates...
EK   C                   IF        REB_CR = 'Y'
EK   C                   EXSR      OPEN_RB
EK   C     K_WRBM1       SETLL     POLWRBM1
EK   C                   IF        %EQUAL(POLWRBM1)
EK   C                             OR APAM04 <> *ZEROS
EK   C                   CLEAR                   pData1088
EK   C                   MOVEL     'CR'          r_trnTyp
EK   C                   Z-ADD     NO01C         r_vnd#
EK   C                   Z-ADD     NO20C         r_ctl#
EK   C                   MOVEL     NO11C         r_inv#
EK   C                   Z-ADD     APAM04        r_tranamt
EK   C                   MOVEL     FRTONL        r_frtOnl
EK   C                   MOVEL     FKEY          r_fKey
EM   C                   Z-ADD     APCO#F        cmp#1088
EK   C                   CLEAR                   PRETCD
EK   C                   CLEAR                   PFUNKY
EK   C                   CLEAR                   PACTCD
EK   C                   MOVEL     pData1088     PDATA
EK   C                   CALL      'APR1088'     STDPL
EK   C                   MOVEL     PDATA         pData1088
EK   C                   EVAL      VARCDE = r_varc
EK   C                   ENDIF
EK    * Credit/Debit matching to vendor returns...
EK   C                   ELSE
     C     NO20C         SETLL     APFWMTH3                               49
     C     *IN49         IFEQ      *ON
     C     APAM04        ORNE      0
     C     CD26K         IFEQ      'C'
     C                   MOVE      'Crd'         INVTYP
     C                   ELSE
     C     CD26K         IFEQ      'D'
     C                   MOVE      'Dbt'         INVTYP
     C                   ENDIF                                                  CD26K EQ D
     C                   ENDIF                                                  CD26K EQ C
DP   C                   Z-ADD     APCO#F        PMICO
     C                   CALL      'APR1091'     PL1091
     C                   ENDIF
EK   C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      APCO#F        INVCO             3
     C                   MOVE      APBR#C        INVBR             3
     C                   MOVE      NO01C         VNDN              6
     C                   MOVE      PO#           PON               7
     C                   MOVE      RCV#          RCVN              7
   ERC*                  MOVE      NO11C         INVN             12
ER   C                   MOVE      NO11C         INVN
     C                   Z-ADD     APAM04        IVAMT
     C                   Z-ADD     NO20C         CKCTL
     C                   MOVE      CKCTL         CNTN              7
     C                   MOVE      'N'           CC                1
     C                   MOVEL     INVMO         WRK2              4 0
     C                   MOVE      INVDY         WRK2
     C                   MOVEL     INVCC         WRK
     C                   MOVE      INVYR         WRK               4 0
     C                   MOVEL     WRK2          INVDT             8
     C                   MOVE      WRK           INVDT
     C                   CALL      'APR1066'     PL1066
     C     EXIT          IFEQ      *OFF
     C                   Z-ADD     APAM04        SVAM04
     C                   ENDIF
     C                   ENDIF
      * DETERMINE IF P/O OR VENDOR RETURN NUMBER HAS CHANGED
      * IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
      * IF NOT SAME P/O, CLEAR G/L INFO
     C     PO#           IFNE      LSTPO
     C                   MOVE      'Y'           POCHG
     C                   ENDIF
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT/DEBIT
      * IF NOT SAME VENDOR RETURN, CLEAR G/L INFO
     C     VNDRTN        IFNE      LSTRTN
EK   C     REB_CR        ANDNE     'Y'
     C                   MOVE      'Y'           VRCHG
     C                   ENDIF
     C                   ENDIF
      * GET MATCHING INFORMATION
     C                   MOVE      'N'           GETORG
     C     CD26K         IFEQ      'I'
     C                   EXSR      GETMTH
     C                   ELSE
EK    * Vendor return matching...
EK   C                   IF        REB_CR <> 'Y'
     C                   EXSR      GETMHV
     C                   MOVE      'Y'           CLCOC             1
     C                   EXSR      LOADOC
EK   C                   ENDIF
     C                   ENDIF
      * PROTECT SCREEN FIELDS
     C                   EXSR      PROTCT
      * DETERMINE IF G/L ACCOUNT NEEDS TO BE LOADED
     C                   EXSR      LODGLA
     C     MSGFLD        CABNE     *BLANKS       VAREND
      * EDIT G/L INFORMATION
     C                   EXSR      EDITC3
     C     VAREND        ENDSR
      *------------------------------------------------------------------------*
      * UPDATE MATCHING DATA
DT    * This subroutine is executed when the user exits without
DT    * updating the invoice.
      *------------------------------------------------------------------------*
     C     UPDMTH        BEGSR
      * IF ORIGINAL SKIP MATCH IS YES
      ** DELETE ALL MATCHING
     C     ORGSKP        IFEQ      'Y'
     C                   EXSR      DLTMTH
     C                   ELSE
      * IF ORIGINAL SKIP MATCH IS NO
      ** REMOVE LAST MATCHING
      ** RESTORE ORIGINAL MATCHING
     C                   EXSR      RMVMTH
     C                   EXSR      RSTMTH
     C                   ENDIF
DT    * REMOVE FREIGHT MATCHING WORK INFORMATION...
DT   C                   EXSR      RMVMTH_FRT
     C                   ENDSR
      *------------------------------------------------------------------------*
      * SELECT PURCHASE ORDER OR VENDOR RETURN MATCHING
EK    * OR REBATE
      *------------------------------------------------------------------------*
     C     SELMTH        BEGSR
      ** IF P/O OR V/R VENDOR DIFFERENT FROM INVOICE VENDOR
      ** REMOVE LAST MATCHING
     C     POVEND        IFNE      NO01C
     C     NO01C         ANDNE     0
DT   C     FRTVEND       ANDNE     'Y'
     C                   EXSR      RMVMTH
      ** IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
      ** IF NO P/O NUMBER, DEFAULT INVOICE VENDOR TO P/O VENDOR
     C     PO#           IFEQ      0
     C                   Z-ADD     NO01C         POVEND
     C                   ENDIF
     C                   ELSE
      ** IF INVOICE TYPE IS CREDIT,DEBIT
      ** IF NO V/R NUMBER, DEFAULT INVOICE VENDOR TO P/O VENDOR
     C     VNDRTN        IFEQ      0
EK   C     REB_CR        ANDNE     'Y'
     C                   Z-ADD     NO01C         POVEND
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      ** DETERMINE IF LINE SELECTION ALLOWED
     C     *IN16         IFEQ      *ON
     C     DIRECT        ANDNE     'Y'
     C     DIRECT        ANDNE     'L'
     C     FRTONL        ANDNE     'Y'
     C                   MOVE      'Y'           SELLIN            1
     C                   ELSE
     C                   MOVE      'N'           SELLIN
     C                   ENDIF
      * CALL SELECTION PROGRAM
     C                   MOVE      *OFF          EXIT
DP   C                   Z-ADD     APCO#F        PMICO
     C     DIRECT        IFNE      'L'
     C     CD26K         IFEQ      'I'
DT   C     SKIPPO        IFNE      'Y'
     C                   CALL      'APR1080'     PL1080
DT   C                   ENDIF
DT   C     MATCH_FRT     IFEQ      'Y'
DT   C                   Z-ADD     PMICO         F_CO
DT   C     FRTVEND       IFNE      'Y'
DT   C                   Z-ADD     POVEND        F_VEND
DT   C                   ELSE
DT   C                   CLEAR                   F_VEND
DT   C                   ENDIF
DT   C     SKIPPO        IFEQ      'Y'
DT   C                   Z-ADD     PO#           F_PO
DT   C                   Z-ADD     RCV#          F_RCVR
DT   C                   ELSE
DT   C                   CLEAR                   F_PO
DT   C                   CLEAR                   F_RCVR
DT   C                   ENDIF
DT   C                   Z-ADD     APBR#C        F_BR
DT   C                   MOVEL     NO11C         F_INV
DT   C                   Z-ADD     NO20C         F_CTL
DT   C                   CLEAR                   F_FRTAMT
DT   C                   CLEAR                   F_INDCDE
DT   C                   MOVEL     FRTONL        F_FRTONL
DT   C                   CLEAR                   F_FKEY
DT    *
DT   C                   CLEAR                   PRETCD
DT   C                   CLEAR                   PFUNKY
DT   C     FRTVEND       IFNE      'Y'
DT   C                   MOVEL     'M'           PACTCD
DT   C                   ELSE
DT   C                   MOVEL     'C'           PACTCD
DT   C                   ENDIF
DT   C                   MOVEL     F_DATA        PDATA
DT    *
DT   C                   CALL      'APR1085'     PL1085
DT   C     SKIPPO        IFEQ      'Y'
DT   C                   MOVEL     PDATA         F_DATA
DT   C                   MOVE      F_PO          PO#
DT   C                   MOVE      F_RCVR        RCV#
DT   C                   MOVE      F_BR          APBR#C
DT   C                   ENDIF
DT   C                   ENDIF
     C                   ELSE
EK    * Matching to rebates...
EK   C                   IF        REB_CR = 'Y'
EK   C                   IF        NO01C = *ZEROS
EK   C                   EVAL      NO01C = POVEND
EK   C                   ENDIF
EK   C                   MOVEL     'CR'          trnTyp1087
EK   C                   Z-ADD     NO01C         vnd#1087
EK   C                   Z-ADD     NO20C         ctl#1087
EM   C                   Z-ADD     APCO#F        cmp#1087
EK   C                   CLEAR                   PRETCD
EK   C                   CLEAR                   PFUNKY
EK   C                   CLEAR                   PACTCD
EK   C                   MOVEL     pData1087     PDATA
EK   C                   CALL      'APR1087'     STDPL
EK   C                   MOVEL     pData         pData1087
EK    * Matching to vendor returns...
EK   C                   ELSE
     C                   CALL      'APR1090'     PL1090
EK   C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      APCO#F        INVCO             3
     C                   MOVE      APBR#C        INVBR             3
     C                   MOVE      NO01C         VNDN              6
     C                   MOVE      PO#           PON               7
     C                   MOVE      RCV#          RCVN              7
   ERC*                  MOVE      NO26K         INVN             12
ER   C                   MOVE      NO26K         INVN
     C                   Z-ADD     APAM04        IVAMT
     C                   MOVE      NO20C         CNTN              7
     C                   MOVE      'N'           CC                1
     C                   MOVEL     INVMO         WRK2              4 0
     C                   MOVE      INVDY         WRK2
     C                   MOVEL     INVCC         WRK
     C                   MOVE      INVYR         WRK               4 0
     C                   MOVEL     WRK2          INVDT             8
     C                   MOVE      WRK           INVDT
     C                   CALL      'APR1066'     PL1066
     C                   MOVE      RCVN          RCV#
     C                   MOVE      PON           PO#
     C                   MOVE      INVBR         APBR#C
     C     EXIT          IFEQ      *OFF
     C                   Z-ADD     APAM04        SVAM04
     C                   ENDIF
     C                   ENDIF                                                  DIRECT EQ L
     C     CD26K         IFEQ      'I'
     C     RCV#          IFEQ      0
     C     EXIT          ANDNE     *ON
     C     FRTONL        ANDNE     'Y'
     C     DIRECT        ANDNE     'L'
     C                   MOVEA     EMS(84)       MSGFLD
     C                   MOVE      *ON           EXIT
     C                   ENDIF                                                  RCV# EQ 0
      * RECEIVER HEADER LOCKED
     C     RCV#          IFNE      0
     C     EXIT          ANDEQ     'L'
     C                   MOVE      *ON           *IN94
     C                   MOVEA     UMS(32)       MSGFLD
     C                   MOVE      *ON           EXIT
     C                   ELSE
      * NO OPEN LINES FOUND
     C     RCV#          IFNE      0
     C     EXIT          ANDEQ     'M'
     C                   MOVE      *ON           *IN94
     C                   MOVEA     EMS(84)       MSGFLD
     C                   MOVE      *ON           EXIT
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
EK    * Rebate matching...
EK   C                   IF        REB_CR = 'Y'
EK    * Vendor return matching...
EK   C                   ELSE
     C     VNDRTN        IFEQ      0
     C     EXIT          ANDNE     *ON
     C                   MOVEA     EMS(84)       MSGFLD
     C                   MOVE      *ON           EXIT
     C                   ELSE
     C     VNDRTN        IFNE      0
     C     EXIT          ANDEQ     'L'
     C                   MOVE      *ON           *IN57
     C                   MOVEA     EMS(99)       MSGFLD
     C                   MOVE      *ON           EXIT
     C                   ELSE
     C     VNDRTN        IFNE      0
     C     EXIT          ANDEQ     'M'
     C                   MOVE      *ON           *IN57
     C                   MOVEA     EMS(84)       MSGFLD
     C                   MOVE      *ON           EXIT
     C                   ENDIF                                                  VNDRTN NE 0
     C                   ENDIF                                                  VNDRTN NE 0
     C                   ENDIF                                                  VNDRTN EQ 0
EK   C                   ENDIF                                                  REB_CR
     C                   ENDIF                                                  CD26K EQ I
     C     EXIT          CABEQ     *ON           ENDMTH
      * DETERMINE IF P/O OR VENDOR RETURN NUMBER HAS CHANGED
      * IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
      * IF NOT SAME P/O, CLEAR G/L INFO
     C     PO#           IFNE      LSTPO
     C                   MOVE      'Y'           POCHG
     C                   ENDIF
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT/DEBIT
      * IF NOT SAME VENDOR RETURN, CLEAR G/L INFO
     C     VNDRTN        IFNE      LSTRTN
EK   C     REB_CR        ANDNE     'Y'
     C                   MOVE      'Y'           VRCHG
     C                   ENDIF
     C                   ENDIF
      * GET MATCHING INFORMATION
     C     CD26K         IFEQ      'I'
     C                   EXSR      GETMTH
     C                   ELSE
EK    * Vendor return matching...
EK   C                   IF        REB_CR <> 'Y'
     C                   EXSR      GETMHV
     C                   MOVE      'Y'           CLCOC
     C                   EXSR      LOADOC
EK   C                   ENDIF
     C                   ENDIF
     C     ENDMTH        ENDSR
      *------------------------------------------------------------------------*
      * LOAD FORMAT C FROM INVOICE RECORD
DT    *
DT    * This subroutine is only executed when an invoice has already
DT    * been entered and you select it for maintenance.
      *------------------------------------------------------------------------*
     C     LOADC         BEGSR
      * CLEAR MATCHING FIELDS
     C                   MOVE      *BLANKS       ORGDIR
     C                   MOVE      *ZEROS        ORGPO
     C                   MOVE      *ZEROS        ORGRCV
     C                   MOVE      *BLANKS       LSTDIR
     C                   MOVE      *ZEROS        LSTPO
     C                   MOVE      *ZEROS        LSTRCV
     C                   MOVE      *ZEROS        PO#
     C                   MOVE      *ZEROS        RCV#
     C                   MOVE      *ZEROS        LSTRTN
     C                   MOVE      *ZEROS        VNDRTN
D3   C                   clear                   frtmsg
D3   C                   MOVE      *off          *IN32
ED   C                   CLEAR                   ORG_REF
ED   C                   CLEAR                   ORG_REFCTL
ED   C                   CLEAR                   ORG_APAM04
      * Clear fields used for accounting period warning...
     C                   CLEAR                   WRNPD1
     C                   CLEAR                   SVAPPD
      * GET INVOICE HEADER
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     HCTL          CHAIN     APFTINH1                           4692
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
DD   C                   Z-ADD     APAM04        SVAM04
DD   C                   MOVE      'M'           ACTION
     C                   MOVE      APCD09        SVCD09
     C                   Z-ADD     APMO14        SVMO14
     C                   Z-ADD     APDY14        SVDY14
     C                   Z-ADD     APCC14        SVCC14
     C                   Z-ADD     APYR14        SVYR14
      * GET VENDOR MASTER
     C     APNO01        CHAIN     APFMVEN4                           47
      * LOAD SCREEN FIELDS
     C                   MOVE      APNO20        NO20C
     C                   MOVE      APNO15        APCO#F
     C                   MOVE      APNO17        BATCH#
     C                   MOVE      APNO02        NO02C
     C                   MOVE      APNO03        NO03C
     C                   MOVE      APNO04        NO04C
     C                   MOVE      APNM01        NM01C
     C                   MOVE      APNO01        NO01C
     C                   MOVE      APNO01        POVEND
     C                   MOVE      APNO01        KVEN
     C                   MOVE      APNO11        NO11C
     C                   MOVE      APNO11        SVNO11
     C                   MOVE      APNO21        NO21C
     C                   MOVE      APMO04        INVMO
     C                   MOVE      APDY04        INVDY
     C                   MOVE      APCC04        INVCC
     C                   MOVE      APYR04        INVYR
¢G   C                   MOVE      APMO04        SVINVMO
¢G   C                   MOVE      APYR04        SVINVYR
EX   C                   MOVE      APNO53        NO53
EY   C                   MOVE      APNO53        NO53C
     C                   MOVE      APCD60        CD60
     C                   MOVE      APCD67        CD67
     C                   MOVE      APCD68        CD68
     C                   MOVE      APMO21        PPMO
     C                   MOVE      APDY21        PPDY
     C                   MOVE      APCC21        PPCC
     C                   MOVE      APYR21        PPYR
     C                   Z-ADD     INVDTC        SVINVD
     C                   MOVE      APMO05        RECMO
     C                   MOVE      APDY05        RECDY
     C                   MOVE      APCC05        RECCC
     C                   MOVE      APYR05        RECYR
     C                   MOVE      APMO06        DUEMO
     C                   MOVE      APDY06        DUEDY
     C                   MOVE      APCC06        DUECC
     C                   MOVE      APYR06        DUEYR
     C                   MOVE      APMO22        DSHMO
     C                   MOVE      APDY22        DSHDY
     C                   MOVE      APCC22        DSHCC
     C                   MOVE      APYR22        DSHYR
     C                   MOVE      APNO38        NO38C
     C                   MOVE      APCD16        CD16C
DL   C                   MOVE      APFL09        CONINV
EZ   C                   MOVE      APCD81        CD81C
     C                   MOVE      GLNO06        GNO06C
     C                   MOVE      GLNO02        GNO02C
     C                   MOVE      GLNO03        GNO03C
     C                   MOVE      GLNO04        GNO04C
     C                   MOVE      *BLANKS       GDN03C
     C     GLNOC         IFNE      0
     C     GLKEYC        CHAIN     GLFMSTR                            48
     C     *IN48         IFEQ      *OFF
     C                   MOVE      GLDN03        GDN03C
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      APNO35        PO#
     C                   MOVE      APCD45        DIRECT
     C     DIRECT        IFEQ      'Y'
     C     DIRECT        OREQ      'L'
     C                   MOVE      'D'           ORGDIR
     C                   MOVE      'D'           LSTDIR
     C                   ENDIF
     C                   MOVE      APPC01        PC01C
     C                   MOVE      APPC40        PC40C
     C                   MOVE      APMO11        DSCMO
     C                   MOVE      APDY11        DSCDY
     C                   MOVE      APCC11        DSCCC
     C                   MOVE      APYR11        DSCYR
     C                   MOVE      APFL01        SKIPPO
     C                   MOVE      APFL01        ORGSKP
     C                   MOVE      APFL01        LSTSKP
DT   C                   MOVE      APFL13        MATCH_FRT
DT   C                   MOVE      APFL13        ORG_MATCH_FRT
DT   C                   MOVE      APFL13        LST_MATCH_FRT
EK   C                   MOVE      APFL14        REB_CR
     C                   MOVE      APFL01        SVSKP             1
     C                   MOVE      APMO12        ACTMOC
     C                   MOVE      APCC12        ACTCCC
     C                   MOVE      APYR12        ACTYRC
     C                   MOVE      APNO16        APBR#C
     C                   MOVE      APNO25        NO25C
     C                   MOVE      APNO25        HO25C
     C                   MOVE      APMO08        CHKMO
     C                   MOVE      APDY08        CHKDY
     C                   MOVE      APCC08        CHKCC
     C                   MOVE      APYR08        CHKYR
     C                   MOVE      APCD26        CD26K
     C                   MOVE      APNO26        NO26K
     C                   MOVE      APNO26        SAVREF
     C                   MOVE      APNO39        REFCTL
     C                   MOVE      APCD43        CD43K
     C                   MOVE      APAD04        AD04C
     C                   MOVE      APAD05        AD05C
     C                   MOVE      APAD06        AD06C
     C                   MOVE      APCY02        CY02C
     C                   MOVE      APST02        ST02C
     C                   MOVE      APZP08        ZP08C
     C                   MOVE      APCD10        VARCDE
DT   C                   MOVE      APCD79        VARCDE_F
ED   C                   MOVEL     APNO26        ORG_REF
ED   C                   Z-ADD     APNO39        ORG_REFCTL
ED   C                   Z-ADD     APAM04        ORG_APAM04
     C                   MOVE      *BLANKS       OTHCHG
EZ    * Allow 1099 override
EZ   C                   EVAL      OPCD34 = 'A'                                 ACTIVE
EZ   C                   EVAL      OPCD31 = 'S'                                 SYSTEM
EZ   C                   EVAL      OPNM25 = 'ALW1099OVR'
EZ   C                   EVAL      Allow1099Ovr = 'N'
EZ   C     VEA1KY        CHAIN     APFMVEA
EZ   C                   IF        %FOUND
EZ   C                   MOVEL     OPTX20        Allow1099Ovr      1
EZ   C                   ENDIF
DT    * Get freight vendor flag...
DT   C                   EVAL      OPCD34 = 'A'
DT   C                   EVAL      OPCD31 = 'S'
DT   C                   EVAL      OPNM25 = 'FRTVEND'
DT   C     VEA1KY        CHAIN     APFMVEA
DT   C                   IF        %FOUND
DT   C                   MOVEL     OPTX20        FRTVEND           1
DT   C                   ELSE
DT   C                   CLEAR                   FRTVEND
DT   C                   ENDIF
      * DETERMINE IF FREIGHT ONLY INVOICE
     C     APCD29        IFNE      'Y'
     C     APAM04        ANDEQ     0
     C     APAM13        ANDNE     0
     C     APCD29        ORNE      'Y'
     C     APAM04        ANDEQ     0
     C     APAM26        ANDNE     0
DT   C     FRTVEND       OREQ      'Y'
     C                   MOVE      'Y'           FRTONL
     C                   ELSE
     C                   MOVE      'N'           FRTONL
     C                   ENDIF
     C                   MOVE      FRTONL        ORGFRT
     C                   MOVE      FRTONL        LSTFRT
      * GET MATCHING INFORMATION
     C     SKIPPO        IFNE      'Y'
     C     FRTONL        IFNE      'Y'
      * CLEAR ANY OLD RECORDS FOR THIS INVOICE IN MATCH WORKFILE
EK    *=================
EK    *-----------------
EK    * Rebate credit...
EK    *-----------------
EK   C                   IF        REB_CR = 'Y'
EK   C                   EXSR      DEL_WRBM
EK    *------------------------
EK    * P/O or vendor return...
EK    *------------------------
EK   C                   ELSE
     C     NO20C         CHAIN     APFWMTH                            45
     C     *IN45         DOWEQ     *OFF
     C                   DELETE    APFWMTH
     C     NO20C         READE     APFWMTH                                45
     C                   ENDDO
EK   C                   ENDIF
      * IF NOT APPROVED
     C     APCD09        IFNE      'Y'
      * IF INVOICE TYPE IS INVOICE
      * UPDATE MAINTENANCE LOCK IN ALL MATCHED RECEIVER HEADERS
     C     CD26K         IFEQ      'I'
     C                   Z-ADD     0             SAVRCV
     C                   Z-ADD     0             CNTERR
      * READ MATCH FILE
     C     NO20C         CHAIN(N)  APFTINM1                           45
     C     *IN45         DOWEQ     *OFF
     C     MONO19        IFNE      SAVRCV
     C                   MOVE      'N'           LCKERR            1
     C                   MOVE      'N'           TRHLCK            1
      * GET RECEIVER HEADER
      * CHECK FOR RECORD LOCK
     C     TRYHA         TAG
     C     MONO19        CHAIN     POFTRH                             4792
     C     *IN92         IFEQ      *ON
     C                   MOVE      'Y'           DSPF1
     C                   EXSR      UNLOCK
     C     DSPF2         CABEQ     'Y'           TRYHA
     C     DSPF2         IFNE      'Y'
     C                   MOVE      *OFF          *IN92
     C                   MOVE      'Y'           LCKERR
     C                   ENDIF                                                  DSPF2 NE Y
     C                   ENDIF                                                  IN92 EQ ON
      ** CHECK FOR RECORD LOCKED FOR UPDATE FLAG
     C     LCKERR        IFNE      'Y'
     C                   MOVE      'Y'           TRHLCK
     C     POCD24        IFEQ      'Y'
     C                   MOVE      'Y'           LCKERR
     C                   ENDIF                                                  POCD24 EQ Y
     C                   ENDIF                                                  LCKERR NE Y
      **
     C     *IN47         IFEQ      *OFF
      * IF THERE WAS A LOCK ERROR
     C     LCKERR        IFEQ      'Y'
     C                   ADD       1             CNTERR
      * RELEASE RECORD LOCKED FOR UPDATE
     C     TRHLCK        IFEQ      'Y'
     C                   EXCEPT    UNLTRH
     C                   ENDIF                                                  TRHLCK EQ Y
     C                   ELSE
      * UPDATE RECEIVER LOCK FLAG IN RECEIVER HEADER
     C                   MOVE      'Y'           POCD24
     C                   EXCEPT    UPDTRH
      * WRITE WORK RECORDS FOR LOCKED RECEIVERS
      ** IF ANY LOCK ERRORS ARE FOUND FOR THE INVOICE,
      ** ANY RECEIVERS LOCKED WILL NEED TO BE UNLOCKED
     C                   Z-ADD     NO20C         MHNO20
     C                   Z-ADD     MONO19        MHNO19
     C                   WRITE     APFWMTH
     C                   ENDIF                                                  LCKERR EQ Y
     C                   ENDIF                                                  IN47 EQ OFF
     C                   Z-ADD     MONO19        SAVRCV
     C                   ENDIF                                                  MONO19 NE SAVRCV
     C     NO20C         READE(N)  APFTINM1                               45
     C                   ENDDO                                                  IN78 DOWEQ OFF
      * IF ANY ERRORS FOUND, REMOVE ANY MAINTENANCE LOCKS IN HEADERS
     C     NO20C         CHAIN     APFWMTH                            45
     C     *IN45         DOWEQ     *OFF
     C     CNTERR        IFGT      0
      * GET RECEIVER HEADER
      * CHECK FOR RECORD LOCK
      * IF RECORD LOCK FOUND, DO NOT LET USER HAVE THE RETRY OPTION
      * RECEIVER HEADER LOCK FLAG ALREADY SET TO Y
      * THIS UPDATE MUST HAPPEN OR THE RECEIVER LOCK FLAG WILL STAY Y
      *  AND WILL HAVE TO BE MANAULLY REMOVED USING DFU/DBU
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     MHNO19        CHAIN     POFTRH                             4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      ** REMOVE MAINTENANCE LOCK
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POCD24
     C                   EXCEPT    UPDTRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  CNTERR GT 0
     C                   DELETE    APFWMTH
     C     NO20C         READE     APFWMTH                                45
     C                   ENDDO                                                  IN45 DOWEQ OFF
     C     CNTERR        IFGT      0
     C                   MOVEA     UMS(33)       MSGFLD
     C                   GOTO      ENDLDC
     C                   ENDIF
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
      * UPDATE MAINTENANCE LOCK IN ALL MATCHED VENDOR RETURN HEADERS
EK   C                   IF        REB_CR <> 'Y'
     C                   Z-ADD     0             SAVRTN
     C                   Z-ADD     0             CNTERR            7 0
      * READ MATCH FILE
     C     NO20C         CHAIN(N)  APFTINM9                           45
     C     *IN45         DOWEQ     *OFF
      * GET VENDOR RETURN HEADER
      * CHECK FOR RECORD LOCK
     C     MONO27        IFNE      SAVRTN
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     MONO27        CHAIN     POFTVRH                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      ** CHECK FOR MAINTENANCE LOCK
     C     *IN47         IFEQ      *OFF
     C     POFL06        ANDNE     'Y'
     C                   MOVE      'Y'           POFL06
     C                   EXCEPT    UPDVRH
     C                   Z-ADD     NO20C         MHNO20
     C                   Z-ADD     MONO27        MHNO27
     C                   WRITE     APFWMTH
     C                   ELSE
     C     *IN47         IFEQ      *OFF
     C                   EXCEPT    UNLVRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ADD       1             CNTERR
     C                   ENDIF                                                  IN47 EQ OFF
     C                   Z-ADD     MONO27        SAVRTN
     C                   ENDIF                                                  MONO27 NE SAVRTN
     C     NO20C         READE(N)  APFTINM9                               45
     C                   ENDDO                                                  IN45 DOWEQ OFF
      * IF ANY ERRORS FOUND, REMOVE ANY MAINTENANCE LOCKS IN HEADERS
     C     NO20C         CHAIN     APFWMTH                            45
     C     *IN45         DOWEQ     *OFF
     C     CNTERR        IFGT      0
      * GET VENDOR RETURN HEADER
      * CHECK FOR RECORD LOCK
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     MHNO27        CHAIN     POFTVRH                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      ** REMOVE MAINTENANCE LOCK
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POFL06
     C                   EXCEPT    UPDVRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  CNTERR GT 0
     C                   DELETE    APFWMTH
     C     NO20C         READE     APFWMTH                                45
     C                   ENDDO                                                  IN45 DOWEQ OFF
     C     CNTERR        IFGT      0
     C                   MOVEA     EMS(100)      MSGFLD
     C                   GOTO      ENDLDC
     C                   ENDIF
EK   C                   ENDIF                                                  REB_CR
      *                                                                     ---*
     C                   ENDIF                                                  CD26K EQ I
     C                   ENDIF                                                  APCD09 NE Y
      * LOAD MATCHING TO MATCH WORKFILE
EK    *=================
EK    *-----------------
EK    * Rebate credit...
EK    *-----------------
EK   C                   IF        REB_CR = 'Y'
EK   C                   EXSR      OPEN_RB
EK   C     K_WRBM1       SETLL     POLTRBM1
EK   C                   DOU       %EOF(POLTRBM1)
EK   C     K_WRBM1       READE(N)  POLTRBM1
EK   C                   IF        not %EOF(POLTRBM1)
EK   C                   WRITE     POFWRBM
EK   C                   ENDIF
EK   C                   ENDDO
EK    *------------------------
EK    * P/O or vendor return...
EK    *------------------------
EK   C                   ELSE
     C     NO20C         CHAIN(N)  APFTINM1                           45
     C     *IN45         DOWEQ     *OFF
      * IF INVOICE IS NOT APPROVED
      ** LOCK RECEIVERS/VENDOR RETURNS TO THIS INVOICE DURING MAINT
      ** ADD ANY ADDITIONAL UNMATCHED QUANTITY TO THE MATCH FOR THIS
      ** INVOICE IF SPLIT MATCHING IS NOT USED
     C     APCD09        IFNE      'Y'
      * IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     TRDKY2        CHAIN     POFTRD1                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   Z-ADD     NO20C         PONO24
   ¢BC*    POQY38        IFGT      0
¢B   C     POQY38        IFne      0
     C     APCD50        ANDNE     'S'
     C                   ADD       POQY38        APQY05
     C     APQY05        MULT      POQYOF        STKQTY                         STOCKING UOM
     C                   Z-ADD     POQYPF        $PRFCT
     C                   Z-ADD     STKQTY        $STQTY
     C                   Z-ADD     POAMU7        $PRCST
     C                   EXSR      @EXCST
     C                   Z-ADD(H)  $EXCST        APAM32                         OPEN AMT
     C                   ADD       POQY38        POQY39
     C                   Z-ADD     0             POQY38
     C                   ENDIF                                                  POQY38 GT 0
     C                   EXCEPT    UPDRD1
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
      ** IF VENDOR RETURN LINE
     C     MOCD53        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VRLKY2        CHAIN     POFTVRL                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C     POQY41        IFEQ      0
     C                   Z-ADD     1             POQY41
     C                   ENDIF
     C                   Z-ADD     NO20C         PONO24
   ¢BC*    POQY38        IFGT      0
¢B   C     POQY38        IFne      0
     C     APCD50        ANDNE     'S'
     C                   ADD       POQY38        APQY05
     C                   Z-ADD     APQY05        STKQTY                         STOCKING UOM
     C                   Z-ADD     POQY41        $PRFCT
     C                   Z-ADD     STKQTY        $STQTY
     C     POAM13        DIV       POQY41        $PRCST
     C                   EXSR      @EXCST
     C                   Z-ADD(H)  $EXCST        APAM32                         OPEN AMT
     C                   ADD       POQY38        POQY39
     C                   Z-ADD     0             POQY38
     C                   ENDIF                                                  POQY38 GT 0
     C                   EXCEPT    UPDRL1
      * INTERFACE PGM TO SEND UNMATCHED QTY TO DATAQ WIIN...
     C     WHMYES        IFEQ      'Y'
     C                   EXSR      SENDWM
     C                   ENDIF
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ELSE
      ** IF VENDOR RETURN OTHER CHARGE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VROKY2        CHAIN     POFTVRO                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   Z-ADD     NO20C         PONO24
     C                   EXCEPT    UPDVRO
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  MOCD53 EQ BL
     C                   ENDIF                                                  CD26K EQ I
     C                   ENDIF                                                  APCD09 NE Y
     C                   Z-ADD     NO20C         MHNO20
     C                   Z-ADD     MONO01        MHNO01
     C                   Z-ADD     MONO05        MHNO05
     C                   Z-ADD     MONO19        MHNO19
     C                   Z-ADD     MONO27        MHNO27
     C                   Z-ADD     MONO32        MHNO32
     C                   MOVE      MOCD53        MHCD53
     C                   MOVE      PODN19        MHDN06
     C     DIRECT        IFEQ      'Y'
     C     DIRECT        OREQ      'L'
     C                   MOVE      'D'           MHCD01
     C                   ELSE
     C                   MOVE      *BLANKS       MHCD01
     C                   ENDIF
     C                   Z-ADD     APAM29        MHAM29
     C                   Z-ADD     APAM30        MHAM30
     C                   Z-ADD     APAM31        MHAM31
     C                   Z-ADD     APAM32        MHAM32
     C                   Z-ADD     APQY03        MHQY03
     C                   Z-ADD     APQY04        MHQY04
     C                   Z-ADD     APQY05        MHQY05
     C                   MOVE      APCD49        MHCD49
     C                   MOVE      APCD50        MHCD50
     C                   MOVE      APCD51        MHSEL
     C                   WRITE     APFWMTH
     C     NO20C         READE(N)  APFTINM1                               45
     C                   ENDDO
EK   C                   ENDIF                                                  REB_CR
     C                   ENDIF                                                  FRTONL NE Y
   DT * GET MATCHING INFORMATION
   DTC*                  MOVE      'Y'           GETORG
   DTC*    CD26K         IFEQ      'I'
   DTC*                  EXSR      GETMTH
   DTC*                  ELSE
   DTC*                  EXSR      GETMHV
   DTC*                  MOVE      'N'           CLCOC
   DTC*                  EXSR      LOADOC
   DTC*                  ENDIF
     C                   ENDIF                                                  SKIPPO NE Y
DT    * GET FREIGHT MATCHING INFORMATION...
DT   C     MATCH_FRT     IFEQ      'Y'
DT   C                   EXSR      LOAD_FRT
DT   C                   ENDIF
DT   C     SKIPPO        IFNE      'Y'
DT   C     MATCH_FRT     OREQ      'Y'
DT    * GET MATCHING INFORMATION
DT   C                   MOVE      'Y'           GETORG
DT   C     CD26K         IFEQ      'I'
DT   C                   EXSR      GETMTH
DT   C                   ELSE
EK    * Vendor return matching...
EK   C                   IF        REB_CR <> 'Y'
DT   C                   EXSR      GETMHV
DT   C                   MOVE      'N'           CLCOC
DT   C                   EXSR      LOADOC
EK   C                   ENDIF
DT   C                   ENDIF
DT   C                   ENDIF
      * PROTECT SCREEN FIELDS
     C                   EXSR      PROTCT
      * INVOICE APPROVED
     C     APCD09        IFEQ      'Y'
     C                   MOVE      *ON           *IN33
     C                   ELSE
     C                   MOVE      *OFF          *IN33
     C                   ENDIF
      * INVOICE STATUS
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *BLANKS       HLDSTS
     C                   SELECT
   DT ** VARIANCE ACCEPTED
   DTC*    APCD10        WHENEQ    'A'
   DTC*                  MOVE      *ON           *IN66
   DTC*                  MOVE      STS(1)        HLDSTS
   DT ** VARIANCE HOLD
DT    ** Both variance hold...
DT   C     APCD10        WHENEQ    'H'
DT   C     APCD79        ANDEQ     'H'
DT   C                   MOVE      *ON           *IN66
DT   C                   MOVE      STS(9)        HLDSTS
DT    ** Purchase variance hold...
     C     APCD10        WHENEQ    'H'
     C                   MOVE      *ON           *IN66
   DTC*                  MOVE      STS(2)        HLDSTS
DT   C                   MOVE      STS(7)        HLDSTS
DT    ** Freight variance hold...
DT   C     APCD79        WHENEQ    'H'
DT   C                   MOVE      *ON           *IN66
DT   C                   MOVE      STS(8)        HLDSTS
      ** EDI ERROR HOLD
     C     APCD10        WHENEQ    'E'
     C                   MOVE      *ON           *IN66
     C                   MOVE      STS(5)        HLDSTS
      ** EDI WAIT HOLD
     C     APCD10        WHENEQ    'W'
     C                   MOVE      *ON           *IN66
     C                   MOVE      STS(6)        HLDSTS
      ** PAYMENT HOLD
     C     APCD17        WHENEQ    'Y'
     C                   MOVE      *ON           *IN66
     C                   MOVE      STS(3)        HLDSTS
DT    ** Both variance accepted...
DT   C     APCD10        WHENEQ    'A'
DT   C     APCD79        ANDEQ     'A'
DT   C                   MOVE      *ON           *IN66
DT   C                   MOVE      STS(12)       HLDSTS
DT    ** Purchase variance accepted...
DT   C     APCD10        WHENEQ    'A'
DT   C                   MOVE      *ON           *IN66
DT   C                   MOVE      STS(10)       HLDSTS
DT    ** Freight variance accepted...
DT   C     APCD79        WHENEQ    'A'
DT   C                   MOVE      *ON           *IN66
DT   C                   MOVE      STS(11)       HLDSTS
      ** MANUAL HOLD
     C     APCD43        WHENEQ    'Y'
     C                   MOVE      *ON           *IN66
     C                   MOVE      STS(4)        HLDSTS
     C                   ENDSL
      * VENDOR NOTES
     C                   MOVEA     *BLANKS       VNT                                        ES
     C                   MOVE      *BLANKS       VNDNOT                                     ES
     C                   MOVE      '5'           CD07                           MGMT NOTES
     C     APNKY1        SETLL     APFTNT                                 40
     C     *IN40         IFEQ      *ON
EC   C                   if        qqf = 'QQF'
EC   C                   eval      vndnot = 'Vendor Notes'
EC   C                   else
     C                   BITOFF    '01234567'    VNTBA             1
     C                   BITOFF    '01234567'    VNTEA             1
     C                   BITON     HXRI          VNTBA
     C                   BITON     HXNORM        VNTEA
     C                   MOVEA     VNTBA         VNT(1)                                     ES
     C                   MOVEA     'Vendor N'    VNT(2)                                     ES
     C                   MOVEA     'otes'        VNT(10)                                    ES
     C                   MOVEA     VNTEA         VNT(14)                                    ES
     C                   MOVEA     VNT           VNDNOT                                     ES
EC   C                   endif
     C                   ENDIF
      * GET VENDOR AP SCREEN NOTE IF IT EXISTS
     C                   MOVE      '2'           CD07                           A/P NOTE
     C                   MOVE      *BLANKS       APNT01                                     ES
     C                   MOVEA     *BLANKS       APN                                        ES
     C     APNKY1        CHAIN     APLTNT1                            40
     C     *IN40         IFEQ      *OFF
EC   C                   if        qqf = 'QQF'
EC   C                   eval      apnt01 = aptx01
EC   C                   else
     C                   BITOFF    '01234567'    VNTBA
     C                   BITOFF    '01234567'    VNTEA
     C                   BITON     HXRI          VNTBA
     C                   BITON     HXNORM        VNTEA
     C                   MOVEA     VNTBA         APN(1)                                     ES
     C                   MOVEA     APTX01        APN(2)                                     ES
     C                   MOVEA     VNTEA         APN(77)
     C                   MOVEA     APN           APNT01
EC   C                   endif
     C                   ENDIF
      * Retrieve information for alternate vendor...
     C                   EXSR      GETALT
      *
      * EDI INVOICE
     C     APCD46        IFEQ      'Y'
     C                   MOVE      '*EDI*'       EDIM
     C                   MOVE      *ON           *IN53
     C                   ELSE
     C                   MOVE      *BLANKS       EDIM
     C                   MOVE      *OFF          *IN53
     C                   ENDIF
      * INVOICE TYPE
     C     CD26K         IFEQ      'I'
     C                   MOVE      *OFF          *IN59
     C                   ELSE
     C     SKIPPO        IFEQ      'Y'
     C                   MOVE      *OFF          *IN59
     C                   ELSE
     C                   MOVE      *ON           *IN59
     C                   ENDIF
     C                   ENDIF
EK   C                   IF        REB_CR = 'Y'
EK   C                   EVAL      *IN77 = *ON
EK   C                   ELSE
EK   C                   EVAL      *IN77 = *OFF
EK   C                   ENDIF
      * LOAD MULTIPLE G/L
     C     APCD16        IFEQ      'Y'
     C                   MOVE      *ON           MLGL              1
     C                   Z-ADD     0             RNS
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC1112S
     C                   MOVE      *OFF          *IN70
     C     NO20C         CHAIN     APFTING                            48
     C     *IN48         DOWEQ     *OFF
     C                   ADD       1             RNS
     C     RNS           CHAIN     APS1112S                           42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      APAM15        AM15S
     C                   MOVE      GLNO06        GNO06S
     C                   MOVE      GLNO02        GNO02S
     C                   MOVE      GLNO03        GNO03S
     C                   MOVE      GLNO04        GNO04S
     C                   UPDATE    APS1112S
     C                   ENDIF
     C     NO20C         READE     APFTING                                48
     C                   ENDDO
     C                   ELSE
     C                   MOVE      *OFF          MLGL
     C                   ENDIF
      * LOAD OTHER CHARGES
     C                   Z-ADD     0             RNS2
     C                   Z-ADD     0             RNS3
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC112S2
     C                   WRITE     APC112S3
     C                   MOVE      *OFF          *IN70
     C     APCD53        IFEQ      'Y'
     C                   MOVE      APCD53        OTHCHG
     C     APNO20        CHAIN     APFTINO                            48
     C     *IN48         DOWEQ     *OFF
     C     POCD53        IFEQ      *BLANKS
     C                   ADD       1             RNS2
     C     RNS2          CHAIN     APS112S2                           42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      APAM35        AM35S2
     C                   MOVE      GLNO06        NO06S2
     C                   MOVE      GLNO02        NO02S2
     C                   MOVE      GLNO03        NO03S2
     C                   MOVE      GLNO04        NO04S2
     C                   MOVE      APDN06        DN06S2
     C                   UPDATE    APS112S2
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             PONO32
     C     MTH5K3        CHAIN(N)  APFWMTH5                           45
     C     *IN45         IFEQ      *ON
     C                   Z-ADD     0             MHAM31
     C                   Z-ADD     0             MHAM32
     C                   MOVE      *BLANKS       MHCD49
     C                   MOVE      *BLANKS       MHCD50
     C                   MOVE      *BLANKS       MHSEL
     C                   ENDIF
     C                   ADD       1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      PONO27        NO27S3
     C                   MOVE      POCD53        CD53S3
     C                   MOVE      APDN06        DN06S3
     C                   MOVE      APAM35        AM35S3
     C                   MOVE      GLNO06        NO06S3
     C                   MOVE      GLNO02        NO02S3
     C                   MOVE      GLNO03        NO03S3
     C                   MOVE      GLNO04        NO04S3
     C                   Z-SUB     MHAM32        AM52S3
     C                   Z-SUB     MHAM32        ORAMS3
     C                   Z-ADD     0             OCVAR
     C     MHAM31        SUB       MHAM32        OCVAR
     C                   Z-SUB     OCVAR         OCVAR
     C                   MOVE      OCVAR         AMVRS3
     C                   MOVE      MHCD49        CD49S3
     C                   MOVE      MHCD50        CD50S3
     C                   MOVE      MHSEL         CD51S3
     C                   UPDATE    APS112S3
     C                   ENDIF
     C                   ENDIF                                                  POCD53 EQ BLANKS
     C     APNO20        READE     APFTINO                                48
     C                   ENDDO
     C                   ENDIF
      * LOAD MULTIPLE PAYMENTS
     C     APCD12        IFEQ      'Y'
     C                   MOVE      *ON           MLPAY             1
     C                   Z-ADD     1             X
     C     X             DOUGT     20
     C     X             OCCUR     PAYS
     C                   CLEAR                   PAYS
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   Z-ADD     0             X
     C     NO20C         CHAIN     APFTINP                            48
     C     *IN48         DOWEQ     *OFF
     C                   ADD       1             X
     C     X             OCCUR     PAYS
     C                   MOVE      APAM12        AM12D
     C                   MOVE      APMO10        PAYMOD
     C                   MOVE      APDY10        PAYDYD
     C                   MOVE      APCC10        PAYCCD
     C                   MOVE      APYR10        PAYYRD
     C                   MOVE      APAM16        AM16D
     C                   MOVE      APAM18        AM18D
     C                   MOVE      APAM37        AM37D
     C                   MOVE      APAM17        AM17D
     C                   MOVE      APAM19        AM19D
     C                   MOVE      APAM27        AM27D
     C     NO20C         READE     APFTINP                                48
     C                   ENDDO
     C                   ELSE
     C                   MOVE      *OFF          MLPAY
     C                   ENDIF
      * LOAD INVOICE NOTES
     C                   MOVE      *OFF          AP02              1
   DGC*                  MOVEA     *BLANKS       NOT
DG   C                   MOVEA     *BLANKS       NTE
     C                   MOVE      '1'           CD65
     C                   Z-ADD     0             X
     C     NOTKY         CHAIN     APFTINN                            48
     C     *IN48         DOWEQ     *OFF
     C                   ADD       1             X
   DGC*                  MOVEL     APTX01        NOT(X)
DG   C                   MOVEL     APTX01        NTE(X)
     C                   MOVE      *ON           AP02
     C     NOTKY         READE     APFTINN                                48
     C                   ENDDO
      * LOAD INVOICE CHECK NOTES
     C                   MOVE      *OFF          AP03              1
     C                   MOVEA     *BLANKS       CKN
     C                   MOVE      '2'           CD65
     C                   Z-ADD     0             X
     C     NOTKY         CHAIN     APFTINN                            48
     C     *IN48         DOWEQ     *OFF
     C                   ADD       1             X
     C                   MOVEL     APTX01        CKN(X)
     C                   MOVE      *ON           AP03
     C     NOTKY         READE     APFTINN                                48
     C                   ENDDO
      * LOAD INVOICE IMAGE
     C                   Z-ADD     0             NO47
EV   C                   CLEAR                   DN12
E4   C                   CLEAR                   DN13
EV   C                   clear                   ezApFnd
     C     NO20C         CHAIN(N)  APFTINI1                           48
     C     *IN48         IFEQ      *OFF
     C                   MOVE      APNO47        NO47
EV E4C*                  MOVE      APDN12        DN12
EV E4C*                  if        apdn12 <> *blanks
E4   C                   MOVE      APDN13        DN13
E4   C                   if        apdn13 <> *blanks
EV   C                             and ezApSys ='Y'
EV   C                   move      'Y'           ezApFnd           1
EV    * display F23 function key
EV   C                   eval      *in55 = *on
EV   C                   endif
     C                   ENDIF
      * DETERMINE IF ENTRY OF DEPARTMENT NUMBER IS REQUIRED
      * DETERMINE IF EXPENSES POSTED BY BRANCH
     C                   MOVEL     'AP03'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     APCO#F        TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        TBAP03
     C                   ELSE
     C                   MOVE      'N'           TBMEDP
     C                   MOVE      'N'           TBEXPS
     C                   ENDIF
      * DETERMINE IF AUTOMATIC INVOICE APPROVAL IS USED
     C                   MOVE      ' '           AUTOAP            1
     C                   MOVE      'AP05'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     APCO#F        TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        AUTOAP
EG   C     PCTL#         IFGT      *ZEROS                                       HAS VARIANCE
EG   C     AUTOAP        ANDNE     'Y'                                          AUTO APPROVE
EG   C                   MOVE      'Y'           AUTOAP                         HAS VARIANCE
EG   C                   ENDIF                                                  HAS VARIANCE
     C                   ENDIF
      * SEE IF A/P INVOICE REASON CODE SHOULD BE DISPLAYED/EDITED
     C                   CLEAR                   RSNDS
     C                   MOVE      'AP14'        TBNO01
     C                   CLEAR                   TBNO02
     C                   MOVEL     'DSPRSN'      TBNO02
     C                   MOVE      APCO#F        TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
      * IF ENTRY NOT FOUND FOR COMPANY, RETRIEVE DEFAULT...
     C     *IN40         IFEQ      *ON
     C                   MOVE      '   '         TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
     C                   ENDIF
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        RSNDS
     C                   ENDIF
      * IF TABLE SET FOR REASON CODE REQUIRED, DISPLAY MUST BE 'Y'...
     C     REQRSN        IFEQ      'Y'                                          R/C REQUIRED
     C     DSPRSN        ANDNE     'Y'                                          DISPLAY R/C
     C                   MOVEL     'Y'           DSPRSN
     C                   ENDIF
      * ONLY DISPLAY REASON CODE IF THIS IS A DEBIT OR CREDIT MEMO AND
      * THE ENTRY PREVIOUSLY RETRIEVED FROM TABLE AP14 IS 'Y'
     C     CD26K         IFNE      'I'
     C     DSPRSN        ANDEQ     'Y'
     C                   MOVE      *ON           *IN39
     C                   ELSE
     C                   MOVE      *OFF          *IN39
     C                   ENDIF
      * RETRIEVE REASON CODE DESCRIPTION...
     C                   MOVE      APCD57        CD57C
     C     CD57C         IFNE      *BLANKS
     C     DSPRSN        ANDEQ     'Y'
     C     CD57C         CHAIN     APFMRSN                            48
     C     *IN48         IFEQ      *OFF
     C                   MOVEL     APDN07        CD57DS
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANKS       CD57DS
     C                   ENDIF
      * See if ship date entry is required for directs....
     C                   CLEAR                   DSHREQ
     C                   MOVE      'AP15'        TBNO01
     C                   CLEAR                   TBNO02
     C                   MOVEL     APNO15        TBNO02
     C     TABKEY        CHAIN(N)  TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        DSHREQ            1
EP    * Load number of days allowance for invoice date warning...
EP    * (Defaults to 999 if a valid entry was not found)
EP   C                   MOVEL     TBNO03        FIVE              5
EP   C                   MOVE      FIVE          THREE             3
EP   C                   TESTN                   THREE                40
EP   C                   IF        *IN40 = *ON
EP   C                   MOVE      THREE         NODAYS            3 0
EP   C                   ELSE
EP   C                   EVAL      NODAYS = 999
EP   C                   ENDIF
     C                   ENDIF
      * Retrieve current A/R accounting period...
     C                   Z-ADD     2             DTFUNC
     C                   Z-ADD     APNO15        DTCOMP
     C                   CALL      'OPR0810'     PL0810
     C                   Z-ADD     CARFM2        CRARPD
      * GET CURRENT A/P PERIOD
     C                   EXSR      GETPRD
      * SEE IF ON REFERENCE HOLD...
     C     APCD10        IFEQ      'R'
     C                   MOVE      *ON           *IN29
     C                   ELSE
     C                   MOVE      *OFF          *IN29
     C                   ENDIF
      * REFERENCE NOT ALLOWED IF THIS INVOICE IS REFERENCED BY
      * ANOTHER INVOICE...
     C     APNO20        SETLL     APLWINHR                               37
      * IF APPROVAL IS IN PROGRESS,
      * PROTECT GROSS $, REF#, SKIPPO, P/O#, REC#, N/C...
     C                   MOVE      *OFF          *IN30
     C     APCD10        IFEQ      'I'                                          IN PROGRESS
DT   C     APCD79        OREQ      'I'                                          IN PROGRESS
     C                   MOVE      *ON           *IN30                          PROTECT
     C                   ELSE
      *
      * IF INVOICE IS REFERENCING AN INVOICE THAT IS APPROVED OR
      * MATCHED AND NOT ON VARIANCE HOLD, PROTECT GROSS $, REF#,
      * SKIPPO, P/O#, REC#, N/C...
      *
     C     NO26K         IFNE      *BLANKS
     C     REFCTL        CHAIN     APFTINH0                           40
     C     *IN40         IFEQ      *ON
     C     REFCTL        CHAIN     APFWINH5                           40
     C                   ENDIF
     C     *IN40         IFEQ      *OFF
     C     AXFL01        ANDEQ     'N'
     C     AXCD10        ANDNE     'H'                                          VAR HOLD
     C     *IN40         OREQ      *OFF
     C     AXCD09        ANDEQ     'Y'
     C                   MOVE      *ON           *IN30
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDLDC        TAG
     C                   ENDSR
      *----------------------------------------------------------------
      * Get alternate vendor information...
      *----------------------------------------------------------------
     C     GETALT        BEGSR
      * If there is an alternate vendor, retrieve the master...
     C     NO25C         IFNE      *ZEROS
     C     NO25C         CHAIN     APFMVEN4                           40
     C                   ENDIF
      * Save vendor ACH information at this point because if there is
      * an alternate vendor involved it will be the alternate's info,
      * otherwise it will be the invoice vendor's info...
     C                   MOVEL     CD59M         CD59A
     C                   MOVEL     CD66M         CD66A
     C                   Z-ADD     NO52M         NO52A
     C                   Z-ADD     NO53M         NO53A
     C                   MOVEL     CD25M         CD25A
      * If there is an alternate vendor, chain back to the original
      * vendor master...
     C     NO25C         IFNE      *ZEROS
     C     NO01C         CHAIN     APFMVEN4                           40
     C                   ENDIF
      * Flag what type of vendor it is for ACH processing...
      * Determine if EDI 820 vendor...
DI   C                   if        onedi = 'Y'
     C                   MOVE      'V'           VNDCUS
     C     NO25C         IFEQ      *ZEROS
     C                   MOVEL     NO01C         CUSNBR
     C                   ELSE
     C                   MOVEL     NO25C         CUSNBR
     C                   ENDIF
     C                   MOVE      '820'         DOCTYP
     C                   CALL      'EIR9505'     PL9505
DI   C                   endif
      * Load type of vendor...
     C                   MOVE      *OFF          *IN36
     C                   SELECT
     C     RCVSTS        WHENEQ    '0'
     C     EDITYP        ANDNE     '1'
DI   C     onedi         andeq     'Y'
     C                   MOVE      'E'           TYPVEN
     C     CD59A         WHENEQ    'Y'
     C                   MOVE      'A'           TYPVEN
     C     CD25A         WHENEQ    'Y'
     C                   MOVE      'D'           TYPVEN
     C                   MOVE      *ON           *IN36
     C                   OTHER
     C                   MOVE      'R'           TYPVEN
     C                   ENDSL
DM    * Load the default payment type based on type of vendor...
DM   C     NO25C         IFNE      HO25C
DM   C                   MOVE      TYPVEN        CD67
DM   C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * EXTEND @ PRICING UOM                                                   *
      *------------------------------------------------------------------------*
      *   LOAD THE FOLLOWING FIELDS BEFORE EXECUTING THIS SUBROUTINE...
      *     $PRFCT = PRICING FACTOR
      *     $STQTY = QUANTITY @ STOCKING UOM
      *     $PRCST = COST @ PRICING UOM
      *   THE FOLLOWING WILL BE CALCULATED...
      *     $PRQTY = QUANTITY @ PRICING UOM
      *     $EXCST = EXTENDED COST
      *------------------------------------------------------------------------*
     C     @EXCST        BEGSR
      *
     C     $PRFCT        IFEQ      *ZEROS
     C                   Z-ADD     1             $PRFCT
     C                   ENDIF
     C     $STQTY        DIV(H)    $PRFCT        $PRQTY           15 5
     C     $PRQTY        MULT(H)   $PRCST        $EXCST           15 5
     C                   ENDSR
      *------------------------------------------------------------------------*
      * GET P/O MATCHING INFORMATION
      *------------------------------------------------------------------------*
     C     GETMTH        BEGSR
      *
DT   C                   CLEAR                   TEXT15
     C                   MOVE      *ZEROS        NUMPO             3 0
     C                   MOVE      'N'           PONOTE            1
     C                   MOVE      ' '           POFRT             1
     C                   MOVE      *ZEROS        RCV#
     C                   MOVE      *ZEROS        LSTPO
     C                   MOVE      *ZEROS        LSTRCV
     C                   MOVE      *BLANKS       LSTDIR
     C                   MOVE      'N'           LSTFRT
DS   C                   MOVE      *ZEROS        NUMRC             3 0
     C                   MOVE      'N'           RCNOTE            1
     C                   MOVE      *ZEROS        VNDRTN
     C                   MOVE      *ZEROS        LSTRTN
      * FREIGHT ONLY INVOICE
     C     FRTONL        IFEQ      'Y'
DT   C     MATCH_FRT     ANDNE     'Y'
     C                   ADD       1             NUMPO
     C                   MOVE      PO#           LSTPO
     C                   MOVE      'Y'           LSTFRT
     C     PO#           CHAIN     POFTOH                             49
     C     *IN49         IFEQ      *OFF
     C                   MOVE      POCD18        PONOTE
     C                   MOVE      POCD04        POFRT
     C     POCD01        IFEQ      'D'
     C                   MOVE      'D'           LSTDIR
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      * CLEAR SUBFILE FOR MATCHED P/O'S
     C                   Z-ADD     0             RNO
     C                   MOVE      *ON           *IN73
     C                   WRITE     APC1112O
     C                   MOVE      *OFF          *IN73
      * LOAD SUBFILE
     C                   Z-ADD     0             SAVPO#
     C                   Z-ADD     0             SAVRCV
     C                   Z-ADD     0             SAVRTN
DT    *...........................
DT    * Load matched line items...
DT    *...........................
DT   C     SKIPPO        IFNE      'Y'
     C     NO20C         CHAIN(N)  APFWMTH                            41
     C     *IN41         DOWEQ     *OFF
      * GET P/O INFORMATION
     C     LSTPO         IFEQ      0
     C                   MOVE      MHNO01        PO#
     C                   MOVE      MHNO01        LSTPO
     C                   MOVE      MHNO19        RCV#
     C                   MOVE      MHNO19        LSTRCV
     C                   MOVE      MHCD01        LSTDIR
     C                   ENDIF
     C     MHNO01        IFNE      SAVPO#
     C                   ADD       1             NUMPO
     C     MHNO01        CHAIN     POFTOH                             49
     C     *IN49         IFEQ      *ON
     C                   Z-ADD     0             POPC01
     C                   Z-ADD     0             PODY05
     C                   Z-ADD     0             PONO04
     C                   Z-ADD     0             PODSAM
     C                   Z-ADD     0             PODUDT
     C                   MOVE      *BLANKS       NOTECD
     C                   ELSE
     C     POCD18        IFEQ      'Y'
     C                   MOVE      'Y'           PONOTE
     C                   MOVE      'P'           NOTECD
     C                   ENDIF                                                  POCD18 EQ Y
     C     POCD04        IFEQ      'P'
     C                   MOVE      'P'           POFRT
     C                   ELSE
     C     POCD04        IFEQ      'C'
     C                   MOVE      'C'           POFRT
     C                   ENDIF                                                  POCD04 EQ C
     C                   ENDIF                                                  POCD04 EQ P
     C                   Z-ADD     PDUDTE        PODUDT
     C                   MOVE      POPC01        PERC
     C                   ENDIF                                                  IN49 EQ ON
     C                   MOVE      MHNO01        SAVPO#
     C                   ENDIF                                                  MHNO01 NE SAVPO
     C     MHNO19        IFNE      SAVRCV
DS   C                   ADD       1             NUMRC
     C     MHNO19        CHAIN(N)  POFTRH                             49
     C     *IN49         IFEQ      *OFF
     C     POCD21        ANDEQ     'Y'
     C                   MOVE      'Y'           RCNOTE
     C     NOTECD        IFEQ      *BLANKS
     C                   MOVE      'R'           NOTECD
     C                   ELSE
DT   C     NOTECD        IFEQ      'P'
     C                   MOVE      'B'           NOTECD
DT   C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  IN49 EQ OFF
     C     PERC          MULT(H)   APAM04        PODSAM
     C                   MOVE      *BLANKS       SELO
     C                   ADD       1             RNO
     C                   WRITE     APS1112O
     C                   Z-ADD     MHNO19        SAVRCV
     C                   ENDIF
     C     NO20C         READE(N)  APFWMTH                                41
     C                   ENDDO
DT   C                   ENDIF
DT    *........................
DT    * Load matched freight...
DT    *........................
DT   C     MATCH_FRT     IFEQ      'Y'
DT   C                   EVAL      TEXT15 = 'Freight Matched'
DT   C     NO20C         CHAIN(N)  POFTRHC                            41
DT   C     *IN41         DOWEQ     *OFF
DT    * GET P/O INFORMATION
DT   C     LSTPO         IFEQ      *ZEROS
DT   C                   MOVE      PONO01        PO#
DT   C                   MOVE      PONO01        LSTPO
DT   C                   MOVE      PONO19        RCV#
DT   C                   MOVE      PONO19        LSTRCV
DT   C                   CLEAR                   LSTDIR
DT   C                   ENDIF
DT   C     PONO01        IFNE      SAVPO#
DT   C                   ADD       1             NUMPO
DT   C     PONO01        CHAIN     POFTOH                             49
DT   C     *IN49         IFEQ      *ON
DT   C                   CLEAR                   POPC01
DT   C                   CLEAR                   PODY05
DT   C                   CLEAR                   PONO04
DT   C                   CLEAR                   PODSAM
DT   C                   CLEAR                   PODUDT
DT   C                   CLEAR                   NOTECD
DT   C                   ELSE
DT   C     POCD18        IFEQ      'Y'
DT   C                   MOVE      'Y'           PONOTE
DT   C                   MOVE      'P'           NOTECD
DT   C                   ENDIF                                                  POCD18 EQ Y
DT   C     POCD04        IFEQ      'P'
DT   C                   MOVE      'P'           POFRT
DT   C                   ELSE
DT   C     POCD04        IFEQ      'C'
DT   C                   MOVE      'C'           POFRT
DT   C                   ENDIF                                                  POCD04 EQ C
DT   C                   ENDIF                                                  POCD04 EQ P
DT   C                   Z-ADD     PDUDTE        PODUDT
DT   C                   MOVE      POPC01        PERC
DT   C                   ENDIF                                                  IN49 EQ ON
DT   C                   MOVE      PONO01        SAVPO#
DT   C                   ENDIF                                                  MHNO01 NE SAVPO
DT   C     PONO19        IFNE      SAVRCV
DT   C                   ADD       1             NUMRC
DT   C     POCD21        IFEQ      'Y'
DT   C                   MOVE      'Y'           RCNOTE
DT   C     NOTECD        IFEQ      *BLANKS
DT   C                   MOVE      'R'           NOTECD
DT   C                   ELSE
DT   C     NOTECD        IFEQ      'P'
DT   C                   MOVE      'B'           NOTECD
DT   C                   ENDIF
DT   C                   ENDIF
DT   C                   ENDIF                                                  IN49 EQ OFF
DT   C                   CLEAR                   PODSAM
DT   C                   MOVE      *BLANKS       SELO
DT   C                   ADD       1             RNO
DT   C                   WRITE     APS1112O
DT   C                   Z-ADD     PONO19        SAVRCV
DT   C                   ENDIF
DT   C     NO20C         READE(N)  POFTRHC                                41
DT   C                   ENDDO
DT   C                   ENDIF
DT    *
     C                   ENDIF
      * LOAD ORIGINAL P/O MATCH INFORMATION
     C     GETORG        IFEQ      'Y'
     C                   MOVE      LSTPO         ORGPO
     C                   MOVE      LSTRCV        ORGRCV
     C                   ENDIF
      * DETERMINE IF P/O TO A/P NOTES EXIST
     C     PONOTE        IFEQ      'Y'
     C                   MOVE      *ON           *IN61
     C                   ELSE
     C                   MOVE      *OFF          *IN61
     C                   ENDIF
      * DETERMINE IF P/O HAS PREPAID FREIGHT
     C     POFRT         IFEQ      'P'
     C                   MOVE      *ON           *IN32
     C                   MOVEA     FMS(1)        FRTMSG
     C                   ELSE
     C     POFRT         IFEQ      'C'
     C                   MOVE      *ON           *IN32
     C                   MOVEA     FMS(2)        FRTMSG
     C                   ELSE
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *BLANKS       FRTMSG
     C                   ENDIF
     C                   ENDIF
      * DETERMINE IF RECEIVING TO A/P NOTES EXIST
     C     RCNOTE        IFEQ      'Y'
     C                   MOVE      *ON           *IN58
     C                   ELSE
     C                   MOVE      *OFF          *IN58
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * GET VENDOR RETURN MATCHING INFORMATION
      *------------------------------------------------------------------------*
     C     GETMHV        BEGSR
      *
     C                   MOVE      *ZEROS        NUMRTN            3 0
     C                   MOVE      *ZEROS        VNDRTN
     C                   MOVE      *ZEROS        LSTRTN
     C     CD26K         IFNE      'I'
     C                   MOVE      *ZEROS        RCV#
     C                   MOVE      *ZEROS        NUMPO
     C                   MOVE      *ZEROS        LSTPO
     C                   MOVE      *ZEROS        LSTRCV
     C                   MOVE      *BLANKS       LSTDIR
     C                   MOVE      'N'           LSTFRT
     C                   ENDIF
      * CLEAR SUBFILE FOR MATCHED VENDOR RETURNS
     C                   Z-ADD     0             RNQ
     C                   MOVE      *ON           *IN73
     C                   WRITE     APC1112Q
     C                   MOVE      *OFF          *IN73
      * LOAD SUBFILE
     C                   Z-ADD     0             SAVRTN
     C                   Z-ADD     0             AM18Q
     C                   Z-ADD     0             AM521
     C                   Z-ADD     0             AM522
     C                   Z-ADD     0             AM523
     C                   Z-ADD     0             AM524
     C                   Z-ADD     0             AM525
     C                   Z-ADD     0             AM526
     C     NO20C         CHAIN(N)  APFWMTH5                           41
     C     *IN41         DOWEQ     *OFF
      * GET VENDOR RETURN INFORMATION
     C     LSTRTN        IFEQ      0
     C                   MOVE      MHNO27        VNDRTN
     C                   MOVE      MHNO27        LSTRTN
     C                   ENDIF
     C     MHNO27        IFNE      SAVRTN
     C                   ADD       1             NUMRTN
     C     SAVRTN        IFNE      0
     C                   Z-ADD     SAVRTN        PONO27
     C                   MOVE      *BLANKS       SELQ
     C                   ADD       1             RNQ
     C                   WRITE     APS1112Q
     C                   Z-ADD     0             AM18Q
     C                   Z-ADD     0             AM521
     C                   Z-ADD     0             AM522
     C                   Z-ADD     0             AM523
     C                   Z-ADD     0             AM524
     C                   Z-ADD     0             AM525
     C                   Z-ADD     0             AM526
     C                   ENDIF                                                  SAVRTN# NE 0
     C                   MOVE      MHNO27        SAVRTN
     C                   ENDIF                                                  MHNO27 NE SAVRTN
     C     MHCD53        IFEQ      *BLANKS
     C                   ADD       MHAM32        AM18Q
     C                   ELSE
     C                   SELECT
     C     MHCD53        WHENEQ    'OC1'
     C                   Z-ADD     MHAM32        AM521
     C     MHCD53        WHENEQ    'OC2'
     C                   Z-ADD     MHAM32        AM522
     C     MHCD53        WHENEQ    'OC3'
     C                   Z-ADD     MHAM32        AM523
     C     MHCD53        WHENEQ    'OC4'
     C                   Z-ADD     MHAM32        AM524
     C     MHCD53        WHENEQ    'OC5'
     C                   Z-ADD     MHAM32        AM525
     C     MHCD53        WHENEQ    'OC6'
     C                   Z-ADD     MHAM32        AM526
     C                   ENDSL
     C                   ENDIF
     C     NO20C         READE(N)  APFWMTH5                               41
     C                   ENDDO
      * WRITE LAST RETURN TO SUBFILE
     C                   Z-ADD     SAVRTN        PONO27
     C                   MOVE      *BLANKS       SELQ
     C                   ADD       1             RNQ
     C                   WRITE     APS1112Q
      * P/O TO A/P NOTES - DO NOT SHOW FOR VENDOR RETURN
     C                   MOVE      *OFF          *IN61
      * P/O HAS PREPAID FREIGHT - DO NOT SHOW FOR VENDOR RETURN
     C                   MOVE      *OFF          *IN32
      * RECEIVING TO A/P NOTES - DO NOT SHOW FOR VENDOR RETURN
     C                   MOVE      *OFF          *IN58
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * EDIT FORMAT C
      *------------------------------------------------------------------------*
     C     EDITC         BEGSR
     C     APCD09        IFNE      'Y'
      *
      * INVOICE NUMBER
      ** INVOICE NUMBER REQUIRED
     C     NO11C         IFEQ      *BLANKS
     C                   MOVE      *ON           *IN80
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(13)       MSGFLD
     C                   ENDIF
     C                   ELSE
      ** DUPLICATE INVOICE
   ¢GC*    APCD03        IFEQ      'Y'
   ¢GC*                  MOVE      NO01C         KVEN
   ¢GC*                  MOVE      NO11C         KINV
   ¢GC*    KEYINV        SETLL     APFWINH2                               40
   ¢GC*    *IN40         IFEQ      *OFF
   ¢GC*    NO11C         ANDNE     SVNO11
¢d ¢GC*                  z-add     INVMO         KMTH
¢d ¢GC*                  z-add     INVYR         KYEAR
¢d ¢G * GMC reuses invoice# which causes invalid duplicate error
¢d ¢G * add additional check for inv mth and year
¢d ¢GC*    no01c         ifeq      14141
¢d ¢GC*    no01c         oreq      14158
¢d ¢GC*    no01c         oreq      22389
¢d ¢GC*    no01c         oreq      23729
¢d ¢GC*    KEYINVZ       SETLL     APFTINH6Z                              40
¢d ¢GC*                  else
   ¢GC*    KEYINV        SETLL     APFTINH6                               40
¢d ¢GC*                  end
   ¢GC*                  ENDIF
   ¢GC*    *IN40         IFEQ      *ON
   ¢GC*                  MOVE      *ON           *IN80
   ¢GC*    MSGFLD        IFEQ      *BLANKS
   ¢GC*                  MOVEA     EMS(14)       MSGFLD
   ¢GC*                  ENDIF
   ¢GC*                  ENDIF
   ¢GC*                  ENDIF
   ¢GC*                  ENDIF

¢G   C                   MOVE      NO01C         KVEN
¢G   C                   MOVE      NO11C         KINV
¢G   C                   z-add     INVMO         KMTH
¢G   C                   z-add     INVYR         KYEAR
¢G   C                   MOVE      *OFF          *IN40
¢G   C                   SELECT
¢G   C                   When      APCD03 = 'N'
¢G   C     KEYINVZ       SETLL     APFWINH6Z                              40
¢G   C     *IN40         IFEQ      *OFF
¢G   C     NO11C         IFNE      SVNO11
¢G   C     NO11C         OREQ      SVNO11
¢G   C     INVMO         ANDNE     SVINVMO                                      INV MO CHANGED
¢G   C     NO11C         OREQ      SVNO11
¢G   C     INVYR         ANDNE     SVINVYR                                      INV YR CHANGED
¢G   C     KEYINVZ       SETLL     APFTINH6Z                              40
¢G   C                   ENDIF
¢G   C                   ENDIF
¢G   C                   OTHER
¢G   C     KEYINV        SETLL     APFWINH2                               40
¢G   C     *IN40         IFEQ      *OFF
¢G   C     NO11C         ANDNE     SVNO11
¢G    * GMC reuses invoice# which causes invalid duplicate error
¢G    * add additional check for inv mth and year
¢G   C     KEYINV        SETLL     APFTINH6                               40
¢G   C                   ENDIF
¢G   C                   ENDSL
¢G   C     *IN40         IFEQ      *ON
¢G   C                   MOVE      *ON           *IN80
¢G   C     MSGFLD        IFEQ      *BLANKS
¢G   C                   MOVEA     EMS(14)       MSGFLD
¢G   C                   ENDIF
¢G   C                   ENDIF
¢G   C                   ENDIF
      *
      * INVOICE DATE
      ** DATE NOT ENTERED
     C     INVDTC        IFEQ      0
     C                   MOVE      *ON           *IN81
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(15)       MSGFLD
     C                   ENDIF
     C                   ELSE
      ** DETERMINE IF VALID DATE
     C                   MOVE      INVDTC        PDATE
     C                   MOVE      *ZEROS        PJULI
     C                   CALL      'GPR0100'     JULKEY
      *** GET INVOICE CENTURY
     C                   Z-ADD     1             DATYP
     C                   MOVE      INVYR         DATE2
     C                   MOVE      DS2000        PM2000                                     ERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      DATE4         INVCY             4 0
     C                   MOVE      DACEN         INVCC
      ** DATE INVALID
     C     PJULI         IFEQ      0
     C                   MOVE      *ON           *IN81
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(16)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      ** DATE ENTERED CANNOT BE > NOR < 1 YEAR FROM CURRENT YEAR
     C     *IN33         IFEQ      *OFF
     C     INVCY         IFLT      MIN1
     C     INVCY         ORGT      PUS1
     C                   MOVE      *ON           *IN81
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(1)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** DETERMINE IF INVOICE DATE IS GREATER THAN TODAY'S DATE
     C                   MOVE      INVMO         CMPMO1
     C                   MOVE      INVDY         CMPDY1
     C                   MOVE      INVCC         CMPCC1
     C                   MOVE      INVYR         CMPYR1
     C                   MOVE      UMONTH        CMPMO2
     C                   MOVE      UDAY          CMPDY2
     C                   MOVEL     *YEAR         CMPCC2
     C                   MOVE      UYEAR         CMPYR2
      ** DATE INVALID
     C     CMPDT1        IFGT      CMPDT2
     C     DTEWRN        ANDEQ     *BLANK
     C                   MOVE      *ON           *IN81
     C                   MOVE      'Y'           DTEWRN
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(23)       MSGFLD
     C                   ENDIF
     C                   ENDIF
EP    * Invoice date warning...
EP   C                   IF        INVDTC <> INVDTC_SV
EP   C                   CLEAR                   DTEWRN2
EP   C                   ENDIF
EP   C                   IF        MSGFLD = *BLANKS
EP   C                   MOVE      'D'           ZZFUNC
EP   C                   Z-ADD     INVDTC        ZZDIFF
EP   C                   Z-ADD     0             ZZDAYS
EP   C                   Z-ADD     UDATE         ZZDATE
EP   C                   CALL      'UDR'         PLUDR
EP   C                   IF        %abs(ZZDAYS) > NODAYS
EP   C                             and DTEWRN2 = *BLANKS
EP   C                   EVAL      DTEWRN2 = *ON
EP   C                   EVAL      *IN81 = *ON
EP   C                   EVAL      INVDTC_SV = INVDTC
EP   C                   IF        ZZDAYS > *ZEROS
EP   C                   EVAL      MSGFLD = 'Warning! Invoice date +
EP   C                             is ' + %char(%abs(zzdays)) +
EP   C                             ' days prior to today.'
EP   C                   ELSE
EP   C                   EVAL      MSGFLD = 'Warning! Invoice date +
EP   C                             is ' + %char(%abs(zzdays)) +
EP   C                             ' days greater than today.'
EP   C                   ENDIF
EP   C                   ENDIF
EP   C                   ENDIF
EP    *
     C                   ENDIF
      *
      * DATE RECEIVED
      ** DATE NOT ENTERED
     C     RECDTC        IFEQ      0
     C                   ELSE
      ** DETERMINE IF VALID DATE
     C                   MOVE      RECDTC        PDATE
     C                   MOVE      *ZEROS        PJULI
     C                   CALL      'GPR0100'     JULKEY
      *** GET RECEIVED CENTURY
     C                   Z-ADD     1             DATYP                          DATE TYPE
     C                   MOVE      RECYR         DATE2
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      DATE4         RECCY             4 0
     C                   MOVE      DACEN         RECCC
      ** DATE INVALID
     C     PJULI         IFEQ      0
     C                   MOVE      *ON           *IN82
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(16)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      ** DATE ENTERED CANNOT BE > NOR < 1 YEAR FROM CURRENT YEAR
     C     *IN33         IFEQ      *OFF
     C     RECCY         IFLT      MIN1
     C     RECCY         ORGT      PUS1
     C                   MOVE      *ON           *IN82
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(1)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      * DUE DATE
      ** CALCULATE IF NOT ENETERD
     C     DUEDTC        IFEQ      0
     C     DSCDTC        IFNE      0
     C                   MOVE      DSCDTC        DUEDTC
     C                   MOVE      DSCCC         DUECC
     C                   ENDIF
     C                   ENDIF
     C     DSCDTC        IFEQ      0
     C     SVINVD        ORNE      INVDTC
     C                   MOVE      INVDTC        SVINVD
     C     INVDTC        IFNE      0
     C     NO26K         ANDEQ     *BLANKS
     C                   EXSR      CALCDT
     C     DUEDTC        IFEQ      DSCDTC
     C                   Z-ADD     CLCDT         DUEDTC
     C                   ENDIF
     C                   Z-ADD     CLCDT         DSCDTC
     C                   ENDIF
     C                   ENDIF
      ** DETERMINE IF VALID DATE
     C     DUEDTC        IFEQ      *ZEROS
     C                   MOVE      *ON           *IN83
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(15)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C     DUEDTC        IFNE      0
     C                   MOVE      DUEDTC        PDATE
     C                   MOVE      *ZEROS        PJULI
     C                   CALL      'GPR0100'     JULKEY
      *** GET DUE CENTURY
     C                   Z-ADD     1             DATYP                          DATE TYPE
     C                   MOVE      DUEYR         DATE2
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      DATE4         DUECY             4 0
     C                   MOVE      DACEN         DUECC
      ** DATE INVALID
     C     PJULI         IFEQ      0
     C                   MOVE      *ON           *IN83
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(16)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      ** DATE ENTERED CANNOT BE > NOR < 1 YEAR FROM CURRENT YEAR
     C     DUECY         IFLT      MIN1
     C     DUECY         ORGT      PUS1
     C                   MOVE      *ON           *IN83
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(1)        MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      ** DETERMINE IF DUE DATE IS GREATER THAN INVOICE DATE
     C                   MOVE      INVMO         CMPMO1
     C                   MOVE      INVDY         CMPDY1
     C                   MOVE      INVCC         CMPCC1
     C                   MOVE      INVYR         CMPYR1
     C                   MOVE      DUEMO         CMPMO2
     C                   MOVE      DUEDY         CMPDY2
     C                   MOVE      DUECC         CMPCC2
     C                   MOVE      DUEYR         CMPYR2
      ** DATE INVALID
     C     CMPDT1        IFGT      CMPDT2
     C     MSGFLD        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN81
     C                   MOVE      *ON           *IN83
     C                   MOVEA     EMS(17)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
DH   C     APCD09        IFNE      'Y'
      * DIRECT SHIP DATE
     C     DIRECT        IFEQ      'Y'
      * If direct ship date entry is not required and no direct ship
      * was entered, default the invoice date into the direct ship
      * date...
     C     DSHREQ        IFNE      'Y'
     C     DSHDTC        ANDEQ     *ZEROS
     C     INVDTC        ANDNE     *ZEROS
     C     MSGFLD        ANDEQ     *BLANKS
     C                   Z-ADD     INVDTC        DSHDTC
     C                   ENDIF
      ** DATE NOT ENTERED
     C     DSHDTC        IFEQ      0
     C                   MOVE      *ON           *IN79
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(15)       MSGFLD
     C                   ENDIF
     C                   ELSE
      ** DETERMINE IF VALID DATE
     C                   MOVE      DSHDTC        PDATE
     C                   MOVE      *ZEROS        PJULI
     C                   CALL      'GPR0100'     JULKEY
      *** GET DIRECT SHIP CENTURY
     C                   Z-ADD     1             DATYP                          DATE TYPE
     C                   MOVE      DSHYR         DATE2
     C                   MOVE      DS2000        PM2000
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000
     C                   MOVE      DATE4         DSHCY             4 0
     C                   MOVE      DACEN         DSHCC
      ** DATE INVALID
     C     PJULI         IFEQ      0
     C                   MOVE      *ON           *IN79
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(16)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      ** DATE ENTERED CANNOT BE > NOR < 1 YEAR FROM CURRENT YEAR
     C     DSHCY         IFLT      MIN1
     C     DSHCY         ORGT      PUS1
     C                   MOVE      *ON           *IN79
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(1)        MSGFLD
     C                   ENDIF
     C                   ENDIF
EI    *
EI    * If direct and ship date is greater than invoice date, error
EI   C                   MOVE      INVMO         CMPMO1
EI   C                   MOVE      INVDY         CMPDY1
EI   C                   MOVE      INVCC         CMPCC1
EI   C                   MOVE      INVYR         CMPYR1
EI    *
EI   C                   MOVE      DSHMO         CMPMO2
EI   C                   MOVE      DSHDY         CMPDY2
EI   C                   MOVEL     DSHCC         CMPCC2
EI   C                   MOVE      DSHYR         CMPYR2
EI   C                   if        cmpdt2 > cmpdt1
EI   C                   MOVE      *ON           *IN81
EI   C                   MOVE      *ON           *IN79
EI   C                   IF        msgfld = *blanks
EI   C                   EVAL      msgfld = 'Ship date cannot be greater -
EI   C                             than invoice date for direct invoice.'
EI   C                   ENDIF
EI   C                   ENDIF
EI    *
     C                   ENDIF
     C                   ENDIF
   DH *
   DHC*    APCD09        IFNE      'Y'
      * INVOICE BANK NUMBER
      ** BANK NOT ENTERED
   ¢KC*    NO38C         IFEQ      0
   ¢JC*                  MOVE      *ON           *IN91
   ¢JC*    MSGFLD        IFEQ      *BLANKS
   ¢JC*                  MOVEA     EMS(21)       MSGFLD
   ¢JC*                  ENDIF
¢J   C                   EXSR      srDftBnk
   ¢KC*                  ELSE
     C     NO38C         CHAIN     APFMBNK                            40
      ** BANK NOT FOUND
     C     *IN40         IFEQ      *ON
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(21)       MSGFLD
     C                   ENDIF
     C                   ELSE
     C                   SELECT
      ** BANK CLOSED
     C     APFL02        WHENEQ    'Y'
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(18)       MSGFLD
     C                   ENDIF
      ** NOT AN A/P BANK
     C     APFL03        WHENEQ    'N'
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(19)       MSGFLD
     C                   ENDIF
      *
     C                   OTHER
      ** NOT AUTHORIZED TO BANK
     C     ALLOK         IFNE      'Y'
     C     BKNO15        LOOKUP    SEC                                    50
     C     *IN50         IFEQ      *OFF
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(20)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
     C     BKNO15        IFNE      APCO#F
     C     WRN04         IFEQ      'N'
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(4)        MSGFLD
     C                   MOVE      'Y'           WRN04             1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
   ¢KC*                  ENDIF
      *
      * DISCOUNT DATE
      ** CALCULATE IF NOT ENETERD
     C     DSCDTC        IFEQ      0
     C     INVDTC        ANDNE     0
     C                   EXSR      CALCDT
     C                   Z-ADD     CLCDT         DSCDTC
     C                   ENDIF
      ** DETERMINE IF VALID DATE
     C     DSCDTC        IFGT      0
     C                   MOVE      DSCDTC        PDATE
     C                   MOVE      *ZEROS        PJULI
     C                   CALL      'GPR0100'     JULKEY
      *** GET DISCOUNT CENTURY
     C                   Z-ADD     1             DATYP                          DATE TYPE
     C                   MOVE      DSCYR         DATE2
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      DATE4         DSCCY             4 0
     C                   MOVE      DACEN         DSCCC
      ** DATE INVALID
     C     PJULI         IFEQ      0
     C                   MOVE      *ON           *IN95
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(16)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      ** DATE ENTERED CANNOT BE > NOR < 1 YEAR FROM CURRENT YEAR
     C     *IN33         IFEQ      *OFF
     C     DSCCY         IFLT      MIN1
     C     DSCCY         ORGT      PUS1
     C                   MOVE      *ON           *IN95
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(1)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     APCD09        IFNE      'Y'
      * ACCOUNTING PERIOD
      ** DETERMINE IF VALID PERIOD
      *** GET ACCOUNTING PERIOD CENTURY
     C                   Z-ADD     3             DATYP                          DATE TYPE
     C                   MOVEL     ACTYRC        DATE4
     C                   MOVE      ACTMOC        DATE4
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      DACEN         ACTCCC
     C                   MOVE      ACTMOC        CMPMO2
     C                   MOVE      ACTYRC        CMPYR2
     C                   MOVE      ACTCCC        CMPCC2
      ** INVALID PERIOD
     C                   Z-ADD     *ZERO         WRKMD1            4 0
     C                   Z-ADD     *ZERO         WRKDT1            6 0
     C                   Z-ADD     1             WRKDY1            2 0
     C                   MOVEL     ACTMOC        WRKMD1
     C                   MOVE      WRKDY1        WRKMD1
     C                   MOVEL     WRKMD1        WRKDT1
     C                   MOVE      ACTYRC        WRKDT1
     C                   MOVE      WRKDT1        PDATE
     C                   MOVE      *ZEROS        PJULI
     C                   CALL      'GPR0100'     JULKEY
     C     PJULI         IFEQ      0
     C                   MOVE      *ON           *IN96
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(9)        MSGFLD                         INVALID ACT DAT
     C                   ENDIF
     C                   ENDIF
      * Accounting period cannot be less than current period...
     C     CMPPD2        IFLT      CURPRD
     C                   MOVE      *ON           *IN96
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVE      UMS(2)        MSGFLD
     C                   ENDIF
     C                   ENDIF
      * If A/P accounting period is less than A/R accounting period
      * display a warning message indicating that the invoice will
      * not be approved (Directs Only)...
     C     DIRECT        IFEQ      'Y'
     C     ACTDTC        IFNE      SVAPPD
     C                   MOVE      *OFF          WRNPD1            1
     C                   ENDIF
     C     WRNPD1        IFNE      *ON
     C     CMPPD2        IFLT      CRARPD
     C                   MOVE      *ON           *IN96
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVE      EMS(121)      MSGFLD
     C                   MOVE      *ON           WRNPD1
     C                   Z-ADD     ACTDTC        SVAPPD            4 0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      ** INVALID DUE PERIOD
     C                   MOVE      DUECC         CMPCC1
     C                   MOVE      DUEYR         CMPYR1
     C                   MOVE      DUEMO         CMPMO1
      * NO CHARGE INVOICE
     C     APCD29        IFEQ      'Y'
      ** NO AMOUNTS ARE ALLOWED
     C     APAM06        IFNE      0
     C     APAM04        ORNE      0
     C     APAM14        ORNE      0
     C     APAM05        ORNE      0
     C     APAM13        ORNE      0
     C     APAM26        ORNE      0
     C     APTL03        ORNE      0
     C                   MOVE      *ON           *IN84
     C                   MOVE      *ON           *IN87
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(42)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      ** NOT ALLOWED WITH VENDOR RETURN
     C     VNDRTN        IFNE      0
     C                   MOVE      *ON           *IN62
     C                   MOVE      *ON           *IN57
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(94)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      ** AT LEAST ONE AMOUNT REQUIRED
     C                   ELSE
     C     APAM06        IFEQ      0
     C     APAM04        ANDEQ     0
     C     APAM14        ANDEQ     0
     C     APAM05        ANDEQ     0
     C     APAM13        ANDEQ     0
     C     APAM26        ANDEQ     0
     C     APTL03        ANDEQ     0
     C                   MOVE      *ON           *IN84
     C                   MOVE      *ON           *IN87
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(43)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
DT    * Amount not allowed for 3rd party freight invoice...
DT   C     APAM04        IFNE      *ZEROS
DT   C     FRTVEND       ANDEQ     'Y'
DT   C                   MOVE      *ON           *IN84
DT   C     MSGFLD        IFEQ      *BLANKS
DT   C                   MOVEA     EMS(130)      MSGFLD
DT   C                   ENDIF
DT   C                   ENDIF
ES    *----------------------------
ES    * Discount amount exceeded...
ES    *----------------------------
ES   C                   IF        wrkDisAmt1 > 99999.99
ES   C                             OR wrkDisAmt1 < -99999.99
ES   C                   EVAL      *IN86 = *ON
ES   C                   EVAL      APAM05 = *ZEROS
ES   C                   ENDIF
ES   C                   IF        wrkDisAmt2 > 99999.99
ES   C                             OR wrkDisAmt2 < -99999.99
ES   C                   EVAL      *IN02 = *ON
ES   C                   EVAL      APAM40 = *ZEROS
ES   C                   ENDIF
ES    * Determine message to display based on whether or not the
ES    * gross purchase amount is protected...
ES   C                   IF        *IN86=*ON OR *IN02=*ON
ES   C                   IF        MSGFLD = *BLANKS
ES   C                   IF        *IN30=*OFF and *IN33=*OFF
ES   C                   EVAL      MSGFLD = 'Discount amount exceeded. +
ES   C                             Decrease the % or gross purchase amount.'
ES   C                   ELSE
ES   C                   EVAL      MSGFLD = 'Discount amount exceeded. +
ES   C                             Decrease the discount percent.'
ES   C                   ENDIF
ES   C                   ENDIF
ES   C                   ENDIF
ES    *----------------------------
      * ALTERNATE VENDOR
      ** VENDOR INVALID
     C     NO25C         IFNE      0
     C     NO25C         SETLL     APFMVEN4                               40
     C     *IN40         IFEQ      *OFF
     C                   MOVE      *ON           *IN63
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(29)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * Validate payment type...
      *
      * If referencing an invoice the payment type is defaulted from
      * from the referenced invoice and protected, so only validate
      * when not referencing...
     C     NO26K         IFEQ      *BLANKS
     C                   SELECT
      * Payment type 'E' is only allowed for EDI vendors...
     C     CD67          WHENEQ    'E'
     C     TYPVEN        ANDNE     'E'
     C                   MOVE      *ON           *IN31
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(114)      MSGFLD
     C                   ENDIF
      * Payment type 'D' is only allowed for draft vendors...
     C     CD67          WHENEQ    'D'
     C     TYPVEN        ANDNE     'D'
     C                   MOVE      *ON           *IN31
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(115)      MSGFLD
     C                   ENDIF
      * Payment type 'A' is only allowed for ACH vendors...
     C     CD67          WHENEQ    'A'
     C     TYPVEN        ANDNE     'A'
     C                   MOVE      *ON           *IN31
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(116)      MSGFLD
     C                   ENDIF
      * Payment type 'P' is only allowed for ACH vendors...
     C     CD67          WHENEQ    'P'
     C     TYPVEN        ANDNE     'A'
     C                   MOVE      *ON           *IN31
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(117)      MSGFLD
     C                   ENDIF
      * Payment type 'R' not allowed for EDI or draft vendors...
     C     CD67          WHENEQ    'R'
     C                   SELECT
     C     TYPVEN        WHENEQ    'E'
     C                   MOVE      *ON           *IN31
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(118)      MSGFLD
     C                   ENDIF
     C     TYPVEN        WHENEQ    'D'
     C                   MOVE      *ON           *IN31
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(119)      MSGFLD
     C                   ENDIF
     C                   ENDSL
      * Manual check not allowed through invoice maintenance...
     C     CD67          WHENEQ    'M'
     C                   MOVE      *ON           *IN31
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(120)      MSGFLD
     C                   ENDIF
      * Invalid payment code...
     C     CD67          WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN31
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(105)      MSGFLD
     C                   ENDIF
     C                   ENDSL
      * ACH pre-notes require zero dollar invoices...
     C     CD67          IFEQ      'P'
     C     APAM04        IFNE      0
     C     APAM05        ORNE      0
     C     APAM06        ORNE      0
     C     APAM13        ORNE      0
     C     APAM26        ORNE      0
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN84
     C                   MOVE      *ON           *IN85
     C                   MOVE      *ON           *IN86
     C                   MOVE      *ON           *IN87
     C                   MOVE      *ON           *IN92
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(113)      MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     APCD09        IFNE      'Y'
      *
      * P/O MATCH INFORMATION
      ** VALIDATE SKIP MATCH EQUAL YES
     C     SKIPPO        IFEQ      'Y'
      ** FREIGHT OUT NOT ALLOWED
     C     APAM26        IFNE      0
     C     CD43K         ANDNE     'Y'
     C                   MOVE      *ON           *IN92
     C                   MOVE      *ON           *IN99
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CD43K
     C                   MOVEA     EMS(67)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  SKIPPO EQ Y
     C                   ENDIF
      *
      * VALIDATE REASON CODE IF NOT PROTECTED...
     C     *IN33         IFEQ      *OFF
     C     *IN39         ANDEQ     *ON
     C                   CLEAR                   CD57DS
     C     CD57C         IFNE      *BLANKS
     C     DSPRSN        ANDEQ     'Y'
     C     CD57C         CHAIN     APFMRSN                            40
     C     *IN40         IFEQ      *OFF
     C     APFL05        ANDNE     'Y'                                          CLOSED FLAG
     C                   MOVEL     APDN07        CD57DS
     C                   ELSE
     C                   MOVE      *ON           *IN38
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(101)      MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPC
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      * REASON CODE REQUIRED
     C     REQRSN        IFEQ      'Y'
     C                   MOVE      *ON           *IN38
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(102)      MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * VALIDATE IMAGE CONTROL NUMBER
     C     *IN72         IFEQ      *ON
     C     NO47          IFEQ      *ZEROS
     C     IMGREQ        IFEQ      'Y'
     C     APCD46        ANDNE     'Y'
     C                   MOVE      *ON           *IN71
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(103)      MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     NO47          CHAIN     APFTINI3                           42
     C     *IN42         IFEQ      *OFF
     C     NO20C         ANDNE     IMNO20
     C                   MOVE      *ON           *IN71
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(104)      MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * REMIT TO ADDRESS
     C     AD04C         IFEQ      *BLANKS
     C     CY02C         OREQ      *BLANKS
     C     ST02C         OREQ      *BLANKS
     C     ZP08C         OREQ      *BLANKS
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(45)       MSGFLD
     C                   ENDIF
     C                   ENDIF
DL    ** SKIP MATCH NOT ALLOWED FOR CONSIGNMENT
DL   C     SKIPPO        IFNE      'Y'
DL   C     CONINV        ANDEQ     'Y'
DL   C                   MOVE      *ON           *IN99
DL   C     MSGFLD        IFEQ      *BLANKS
DL   C                   MOVEA     EMS(125)      MSGFLD
DL   C                   ENDIF
DL   C                   ENDIF
      * IF DEBIT, WARN ABOUT DISCOUNT
     C     MSGFLD        IFEQ      *BLANKS
     C     CD26K         IFEQ      'D'
     C     DBTWRN        ANDEQ     ' '
     C     APAM05        IFNE      0
     C     PC01C         ORNE      0
     C                   MOVE      'Y'           DBTWRN            1
     C                   MOVE      *ON           *IN86
     C                   MOVEA     EMS(65)       MSGFLD
     C                   GOTO      DSPC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * GIVE WARNING IF DIRECT WITH FREIGHT IN AMOUNT - UNAPPROVED ONLY
     C     APCD09        IFNE      'Y'
     C     DIRECT        ANDEQ     'Y'
     C     APAM13        ANDNE     0
     C     DFIFLG        IFNE      'Y'
     C                   MOVE      *ON           *IN85
     C                   MOVE      *ON           *IN98
     C                   MOVE      'Y'           DFIFLG
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(31)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
EZ    *  CHECK FOR VALID 1099 CODE
EZ   C     CD81C         IFNE      ' '
EZ   C     CD81C         ANDNE     '1'
EZ   C     CD81C         ANDNE     '2'
EZ   C     CD81C         ANDNE     '3'
EZ   C     CD81C         ANDNE     '7'
EZ   C     CD81C         ANDNE     'N'
EZ   C                   MOVE      '1'           *IN73
EZ   C     MSGFLD        IFEQ      *BLANKS
EZ    * 1099 code is invalid.                                                 24
EZ   C                   EVAL      MSGFLD = '1099 code is invalid.'
EZ   C                   ENDIF
EZ   C                   END
EZ    *
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * EDIT FORMAT C
      *------------------------------------------------------------------------*
     C     EDITC1        BEGSR
DT    ** Skip match and match freight reloaded for freight vendor...
DT    *    For invoice, skippo must be Y and match freight must be Y
DT   C     FRTVEND       IFEQ      'Y'
DT   C     CD26K         IFEQ      'I'
DT   C     SKIPPO        IFNE      'Y'
DT   C     MATCH_FRT     ORNE      'Y'
DT   C     MSGFLD        IFEQ      *BLANKS
DT   C                   MOVE      'Y'           SKIPPO
DT   C                   MOVE      'Y'           MATCH_FRT
EK   C                   MOVE      'N'           REB_CR
DT   C                   MOVEA     EMS(129)      MSGFLD
DT   C                   ENDIF
DT   C                   ENDIF
DT    *    For CR/DR, skippo must be Y and match freight must be N
DT   C                   ELSE
DT   C     SKIPPO        IFNE      'Y'
DT   C     MATCH_FRT     OREQ      'Y'
DT   C     MSGFLD        IFEQ      *BLANKS
DT   C                   MOVE      'Y'           SKIPPO
DT   C                   MOVE      'N'           MATCH_FRT
DT   C                   MOVEA     EMS(129)      MSGFLD
DT   C                   ENDIF
DT   C                   ENDIF
DT   C                   ENDIF
DT   C                   ENDIF
      ** SKIP MATCH REQUIRED
     C     SKIPPO        IFNE      'Y'
     C     SKIPPO        ANDNE     'N'
     C                   MOVE      *ON           *IN99
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(46)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      ** DIRECT FLAG
     C     DIRECT        IFNE      'Y'
     C     DIRECT        ANDNE     'N'
     C     DIRECT        ANDNE     'L'
     C     DIRECT        ANDNE     ' '
     C                   MOVE      *ON           *IN98
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(47)       MSGFLD
     C                   ENDIF
     C                   ENDIF
DW    ** DIRECT NOT ALLOWED WHEN MATCHING FREIGHT...
DW   C     MATCH_FRT     IFEQ      'Y'
DW   C     DIRECT        ANDEQ     'Y'
DW   C     MATCH_FRT     OREQ      'Y'
DW   C     DIRECT        ANDEQ     'L'
DW   C                   MOVE      *ON           *IN98
DW   C     MSGFLD        IFEQ      *BLANKS
DW   C                   EVAL      MSGFLD = 'Direct not allowed when -
DW   C                             matching freight.'
DW   C                   ENDIF
DW   C                   ENDIF
DP    * Validate branch number...
DP   C     APBR#C        IFNE      *ZEROS
DP   C     APBR#C        CHAIN     ARFMBCH                            40
DP   C     *IN40         IFEQ      *ON
DP   C                   MOVE      *ON           *IN67
DP   C     MSGFLD        IFEQ      *BLANKS
DP   C                   MOVEA     EMS(11)       MSGFLD
DP   C                   ENDIF
DP   C                   ELSE
DP   C     ARNO15        IFNE      APCO#F
DP   C                   MOVE      *ON           *IN67
DP   C     MSGFLD        IFEQ      *BLANKS
DP   C                   MOVEA     UMS(37)       MSGFLD
DP   C                   ENDIF
DP   C                   ENDIF
DP   C                   ENDIF
DP   C                   ENDIF
      ** VALIDATE SKIP MATCH EQUAL YES
     C     SKIPPO        IFEQ      'Y'
      ** RECEIVER NOT ALLOWED
     C     RCV#          IFNE      *ZERO
DT   C     MATCH_FRT     ANDNE     'Y'
     C                   MOVE      *ON           *IN94
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(48)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      ** EDI WARNING
     C     APCD46        IFEQ      'Y'
     C     WARNEI        ANDEQ     *BLANKS
E1   C     APNO35        ANDNE     *ZEROS
E1   C     POCD01        ANDNE     'O'
E1   C     POCD01        ANDNE     'F'
     C                   MOVE      *ON           *IN99
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(30)       MSGFLD
     C                   MOVE      'Y'           WARNEI            1
     C                   ENDIF
     C                   ENDIF
      ** BRANCH NUMBER REQUIRED
     C     APBR#C        IFEQ      *ZEROS
     C                   MOVE      *ON           *IN67
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(50)       MSGFLD
     C                   ENDIF
     C                   ELSE
   DP ** VALID BRANCH NUMBER
   DPC*    BRKEY         SETLL     ARFMBCH                                40
   DPC*    *IN40         IFEQ      *OFF
   DPC*                  MOVE      *ON           *IN67
   DPC*    MSGFLD        IFEQ      *BLANKS
   DPC*                  MOVEA     EMS(11)       MSGFLD
   DPC*                  ENDIF
   DPC*                  ENDIF
     C                   ENDIF
      ** FREIGHT ONLY NOT ALLOWED
     C     FRTONL        IFEQ      'Y'
     C     APAM26        ANDEQ     0
DT   C     MATCH_FRT     ANDNE     'Y'
DT   C     CD26K         ANDEQ     'I'
     C                   MOVE      *ON           *IN85
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(51)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      ** VENDOR RETURN NOT ALLOWED
     C     VNDRTN        IFNE      *ZERO
     C                   MOVE      *ON           *IN57
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(93)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  SKIPPO EQ Y
      ** INVOICE TYPE
     C     CD26K         IFNE      'I'
     C     CD26K         ANDNE     'C'
     C     CD26K         ANDNE     'D'
     C                   MOVE      *ON           *IN56
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(90)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      * EDIT SKIP P/O EQUAL NO
      *------------------------------------------------------------------------*
     C     EDITC2        BEGSR
      *
     C     SKIPPO        IFEQ      'N'                                                      MATCH
      ** IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'                                                      MATCH
      *
      * RECEIVER NUMBER
     C     RCV#          IFNE      0
      ** RECEIVER NOT ALLOWED WITH FREIGHT ONLY
     C     FRTONL        IFEQ      'Y'
     C                   MOVE      *ON           *IN94
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(79)       MSGFLD
     C                   ENDIF
      ** RECEIVER NOT FOUND
     C                   ELSE
     C     RCV#          CHAIN(N)  POFTRH                             40
     C     *IN40         IFEQ      *ON
     C                   MOVE      *ON           *IN94
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(57)       MSGFLD
     C                   ENDIF
DP    * Make sure the receiver is for the correct company...
DP   C                   ELSE
DP   C     PONO22        CHAIN     ARFMBCH                            40
DP   C     *IN40         IFEQ      *OFF
DP   C     ARNO15        ANDNE     APCO#F
DP   C                   MOVE      *ON           *IN94
DP   C     MSGFLD        IFEQ      *BLANKS
DP   C                   MOVEA     UMS(38)       MSGFLD
DP   C                   ENDIF
DP   C                   ENDIF
DP    *
     C                   ENDIF
     C                   Z-ADD     PONO01        PO#
     C                   ENDIF                                                  RCV# NE 0
     C                   ENDIF                                                  FRTONL EQ Y
      *
      * P/O NUMBER
     C     PO#           IFNE      0
      ** P/O NOT FOUND
     C     PO#           CHAIN     POFTOH                             40
     C     *IN40         IFEQ      *ON
     C                   MOVE      *ON           *IN93
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(52)       MSGFLD
     C                   ENDIF
DP    * Make sure the po is for the correct company...
DP   C                   ELSE
¢e    * check to see if the po is direct and untagged
¢e   C                   eval      poerr = ' '
¢e   C                   call      'ECR9972'
¢e   C                   parm                    PO#
¢e   C                   parm                    POERR             1
¢e   C     poerr         ifeq      'Y'
¢e   C                   move      *on           *IN93
¢e   C     msgfld        ifeq      *blanks
¢e   C                   movea     CMS(1)        msgfld
¢e   C                   endif
¢e   C                   endif
¢e   C
DP   C     POCD01        IFEQ      'D'
DP   C     PONO03        CHAIN     ARFMBCH                            40
DP   C                   ELSE
DP   C     PONO02        CHAIN     ARFMBCH                            40
DP   C                   ENDIF
DP   C     *IN40         IFEQ      *OFF
DP   C     ARNO15        ANDNE     APCO#F
DP   C                   MOVE      *ON           *IN93
DP   C     MSGFLD        IFEQ      *BLANKS
DP   C                   MOVEA     UMS(38)       MSGFLD
DP   C                   ENDIF
DP    *
      ** CLOSED P/O NOT ALLOWED IF DIRECT AND NOT FREIGHT ONLY
     C                   ELSE
     C                   Z-ADD     APNO01        POVEND
     C     POCD01        IFEQ      'D'
     C     POCD20        IFEQ      'C'
     C     FRTONL        ANDNE     'Y'
     C                   MOVE      *ON           *IN93
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(58)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C     POCD42        IFEQ      'Y'                                          LOT P/O
     C                   MOVE      'L'           DIRECT
     C                   ELSE
     C                   MOVE      'Y'           DIRECT                         DIRECT
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ' '           DIRECT                         DIRECT
      ** FREIGHT OUT NOT ALLOWED IF NOT DIRECT P/O
     C     APAM26        IFNE      0
     C                   MOVE      *ON           *IN92
     C                   MOVE      *ON           *IN98
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(53)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  POCD01 EQ D
DP   C                   ENDIF
     C                   ENDIF                                                  IN40 EQ ON
     C                   ENDIF                                                  PO# NE 0
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
      *
      * VENDOR RETURN NUMBER
     C     VNDRTN        IFNE      0
      ** VENDOR RETURN NOT FOUND
     C     VNDRTN        CHAIN(N)  POFTVRH                            40
     C     *IN40         IFEQ      *ON
     C                   MOVE      *ON           *IN57
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(86)       MSGFLD
     C                   ENDIF
DP    * Make sure the vendor return is for the correct company...
DP   C                   ELSE
DP   C     PONO29        CHAIN     ARFMBCH                            40
DP   C     *IN40         IFEQ      *OFF
DP   C     ARNO15        ANDNE     APCO#F
DP   C                   MOVE      *ON           *IN57
DP   C     MSGFLD        IFEQ      *BLANKS
DP   C                   MOVEA     UMS(39)       MSGFLD
DP   C                   ENDIF
DP    *
      ** CLOSED VENDOR RETURN NOT ALLOWED
     C                   ELSE
     C                   Z-ADD     APNO01        POVEND
     C     POCD37        IFEQ      'C'
     C                   MOVE      *ON           *IN57
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(87)       MSGFLD
     C                   ENDIF
      ** OPEN VENDOR RETURN NOT ALLOWED
     C                   ELSE
     C     POCD37        IFEQ      'O'
     C                   MOVE      *ON           *IN57
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(20)       MSGFLD
     C                   ENDIF
DU    ** PENDING VENDOR RETURN NOT ALLOWED
DU   C                   ELSE
DU   C     POCD37        IFEQ      'P'
DU   C                   MOVE      *ON           *IN57
DU   C     MSGFLD        IFEQ      *BLANKS
DU   C                   MOVEA     EMS(133)      MSGFLD
DU   C                   ENDIF
DU   C                   ENDIF                                                  POCD37 EQ P
     C                   ENDIF                                                  POCD37 EQ O
     C                   ENDIF                                                  POCD37 EQ C
DP   C                   ENDIF
     C                   ENDIF                                                  IN40 EQ ON
     C                   ENDIF                                                  VNDRTN NE 0
     C                   ENDIF                                                  CD26K EQ I
     C                   ENDIF                                                  SKIPPO EQ N
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * EDIT G/L INFORMATION
      *------------------------------------------------------------------------*
     C     EDITC3        BEGSR
      * G/L ACCOUNT NUMBER
     C     CD16C         IFNE      'Y'
     C     GLKEYC        CHAIN     GLFMSTR                            49
     C     *IN49         IFEQ      *ON
     C                   MOVE      *BLANKS       GDN03C
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(24)       MSGFLD
     C                   ENDIF
     C                   ELSE
     C                   MOVE      GLDN03        GDN03C
     C     GLCD15        IFNE      'Y'
     C     POCD01        ANDEQ     'O'
     C     GLCD15        ORNE      'Y'
     C     POCD01        ANDEQ     'F'
     C     GLCD15        ORNE      'Y'
     C     POCD01        ANDNE     'O'
     C     POCD01        ANDNE     'F'
     C     GLNOC2        ANDNE     AIPGL2
     C     GLNOC2        ANDNE     VRRGL2
DT   C     GLNOC2        ANDNE     AIPGL2_F
EK   C     GLNOC2        ANDNE     RBDGL2
EN   C     GLNOC2        ANDNE     RBDGL2_S
     C     GLCD15        ORNE      'Y'
     C     SKIPPO        ANDEQ     'Y'
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(28)       MSGFLD
     C                   ENDIF
     C                   ELSE
      * IF MATCHING
     C     SKIPPO        IFNE      'Y'
   DO ** IF INVOICE TYPE IS INVOICE
   DO ** AND P/O TYPE IS NOT BLANKET AND OVERHEAD
   DO * ACCRUED INVENTORY PAYABLES ACCOUNT MUST BE USED
DO    * If you are matching an invoice to an 'inventory' receipt,
DO    * the accrued inventory payables account must be used...
     C     CD26K         IFEQ      'I'
     C     APCD04        ANDNE     'Y'
     C     POCD01        ANDNE     'O'
     C     POCD01        ANDNE     'F'
     C     GLNOC2        ANDNE     AIPGL2
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(25)       MSGFLD
     C                   ENDIF
     C                   ELSE
EK    *-----------------------------------------------
EK    * If you are matching a credit memo to a rebate,
EK    * you must use the rebates due account...
EK    *-----------------------------------------------
EK    *
EK   C     CD26K         IFNE      'I'
EK   C     REB_CR        ANDEQ     'Y'
EK   C     GLNOC2        ANDNE     RBDGL2
EN   C     GLNOC2        ANDNE     RBDGL2_S
EK   C                   MOVE      *ON           *IN88
EK   C     MSGFLD        IFEQ      *BLANKS
EK ENC*                  EVAL      MSGFLD = 'Rebates due account required +
EK ENC*                            for rebate credit memos.'
EN   C                   EVAL      MSGFLD = 'Rebates due account required.'
EK   C                   ENDIF
   DO * IF INVOICE TYPE IS CREDIT,DEBIT
DO    * If you are matching a credit or debit memo to a vendor return,
DO    * you must use the vendor return receivable account...
EK   C                   ELSE
   ¢AC*   IF GMC VEND, USE DIFF VR RECEIVABLE #
¢A   C     APNO01        IFEQ      14141
¢A   C     APNO01        OREQ      14158
¢A   C     APNO01        OREQ      22389
¢A   C                   Z-ADD     4500          VRNO33
¢A   C                   Z-ADD     23            VRNO34
¢A   C                   END
     C     CD26K         IFNE      'I'
EK   C     REB_CR        ANDNE     'Y'
     C     GLNOC2        ANDNE     VRRGL2
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(91)       MSGFLD
     C                   ENDIF
     C                   ENDIF                                                  CD26K NE I
EK   C                   ENDIF
     C                   ENDIF                                                  CD26K EQ I
     C                   ENDIF                                                  SKIPPO NE Y
   DO * IF NOT MATCHING
   DO * OR MATCHING TO P/O AND P/O TYPE IS BLANKET AND OVERHEAD
   DO * IF INVOICE TYPE IS INVOICE
   DO * ACCRUED INVENTORY PAYABLES ACCOUNT CANNOT BE USED
DO    * If you're not matching and it's an invoice,
DO    * you can't use the accrued inventory payables account...
     C     SKIPPO        IFEQ      'Y'
     C     GLNOC2        ANDEQ     AIPGL2
     C     CD26K         ANDEQ     'I'
DO    * If you're not matching and it's a debit or credit memo, and
DO    * it is not referenced to an invoice,
DO    * you can't use the accrued inventory payables account...
DO   C     SKIPPO        OREQ      'Y'
DO   C     GLNOC2        ANDEQ     AIPGL2
DO   C     CD26K         ANDNE     'I'
DO   C     NO26K         ANDEQ     *BLANKS
DO    * If you are matching an invoice to an overhead P/O,
DO    * you can't use the accrued inventory payables account...
     C     SKIPPO        OREQ      'N'
     C     POCD01        ANDEQ     'O'
     C     GLNOC2        ANDEQ     AIPGL2
     C     CD26K         ANDEQ     'I'
DO    * If you are matching an invoice to a blanket P/O,
DO    * you can't use the accrued inventory payables account...
     C     SKIPPO        OREQ      'N'
     C     POCD01        ANDEQ     'F'
     C     GLNOC2        ANDEQ     AIPGL2
     C     CD26K         ANDEQ     'I'
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(81)       MSGFLD
     C                   ENDIF
     C                   ELSE
DO    * If you are not matching and it's a debit or credit memo that is
DO    * not referenced to an invoice,
DO    * you cannot use the vendor return receivable account...
     C     SKIPPO        IFEQ      'Y'
     C     GLNOC2        ANDEQ     VRRGL2
     C     CD26K         ANDNE     'I'
     C     NO26K         ANDEQ     *BLANKS
DO    * If you are not matching and it's an invoice,
DO    * you cannot use the vendor return receivable account...
     C     SKIPPO        OREQ      'Y'
     C     GLNOC2        ANDEQ     VRRGL2
     C     CD26K         ANDEQ     'I'
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(92)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
DT    * Must use accrued freight payable...
DT   C     FRTONL        IFEQ      'Y'
DT   C     MATCH_FRT     ANDEQ     'Y'
DT   C     GLNOC2        ANDNE     AIPGL2_F
DT   C                   MOVE      *ON           *IN88
DT   C     MSGFLD        IFEQ      *BLANKS
DT   C                   MOVEA     EMS(131)      MSGFLD
DT   C                   ENDIF
DT   C                   ENDIF
      * A/P TRADE ACCOUNT CANNOT BE USED
     C                   MOVE      '010'         PSTTYP
     C     GRPKY         CHAIN     GLFMGRP                            48
     C     *IN48         DOWEQ     *OFF
     C     GLNO33        IFEQ      GNO03C
     C     GLNO34        ANDEQ     GNO04C
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(21)       MSGFLD
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C     GRPKY         READE     GLFMGRP                                48
     C                   ENDDO
      * A/R TRADE ACCOUNT CANNOT BE USED
     C                   MOVE      '220'         PSTTYP
     C     GRPKY         CHAIN     GLFMGRP                            48
     C     *IN48         DOWEQ     *OFF
     C     GLNO33        IFEQ      GNO03C
     C     GLNO34        ANDEQ     GNO04C
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(22)       MSGFLD
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C     GRPKY         READE     GLFMGRP                                48
     C                   ENDDO
      * MUST ENTER DEPARTMENT NUMBER
     C     TBMEDP        IFEQ      'Y'
     C     GLNO02        ANDEQ     0
     C                   MOVE      *ON           *IN89
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(26)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      * PROTECT SCREEN FIELDS
      *------------------------------------------------------------------------*
     C     PROTCT        BEGSR
      * IF MATCHING TO P/O OR VENDOR RETURN
     C     SKIPPO        IFNE      'Y'
DT   C     MATCH_FRT     OREQ      'Y'
      * THESE FIELDS ARE LOADED BY PROGRAM AND CANNOT BE CHANGED
      ** INVOICE BRANCH NUMBER
     C                   MOVE      *ON           *IN34
      * IF THE P/O TYPE IS NOT BLANKET OR OVERHEAD
      * THESE FIELDS ARE LOADED BY PROGRAM AND CANNOT BE CHANGED
      ** G/L ACCOUNT NUMBER AND DESCRIPTION
     C     POCD01        IFNE      'F'
     C     POCD01        ANDNE     'O'
EK   C     REB_CR        ANDNE     'Y'
     C                   MOVE      *ON           *IN68
     C                   ELSE
     C                   MOVE      *OFF          *IN68
     C                   ENDIF
     C                   ELSE
EJ    * If it's a debit or credit memo and referencing an invoice
EJ    * protect the fields that are defaulted from the invoice...
EJ   C     CD26K         IFNE      'I'
EJ   C     REFCTL        ANDNE     *ZEROS
EJ   C                   MOVE      *ON           *IN35
EJ   C                   ELSE
EJ   C                   MOVE      *OFF          *IN35
EJ   C                   ENDIF
EJ    * ONLY DISPLAY REASON CODE IF THIS IS A DEBIT OR CREDIT MEMO AND
EJ    * THE ENTRY PREVIOUSLY RETRIEVED FROM TABLE AP14 IS 'Y'
EJ   C     CD26K         IFNE      'I'
EJ   C     DSPRSN        ANDEQ     'Y'
EJ   C                   MOVE      *ON           *IN39
EJ   C                   ELSE
EJ   C                   MOVE      *OFF          *IN39
EJ   C                   ENDIF
      * IF NOT MATCHING
      * THESE FIELDS ARE LOADED BY PROGRAM AND CAN BE CHANGED
      ** G/L ACCOUNT NUMBER AND DESCRIPTION
      ** INVOICE BRANCH NUMBER
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN68
     C                   ENDIF
      * ONLY DISPLAY A/P IMAGE CONTROL IF IMAGE IS REQUIRED.
     C     IMGCTL        IFEQ      'Y'
     C                   MOVE      *ON           *IN72
     C                   ELSE
     C                   MOVE      *OFF          *IN72
     C                   ENDIF
      * Only display direct ship date if it is a direct...
     C     DIRECT        IFEQ      'Y'
     C                   MOVE      *ON           *IN78
     C                   ELSE
     C                   MOVE      *OFF          *IN78
     C                   ENDIF
DN    * Protect multiple G/L accounts flag & G/L# if processing
DN    * for consignment.
DN   C     CONINV        IFEQ      'Y'
DN   C                   MOVE      *ON           *IN68
DN   C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * LOAD G/L ACCOUNT NUMBER
      *------------------------------------------------------------------------*
     C     LODGLA        BEGSR
      * DETERMINE IF G/L ACCOUNT NEEDS TO BE LOADED
     C                   MOVE      'N'           LDACCT            1
     C                   MOVE      'N'           LOADBR            1
     C                   MOVE      'N'           USEAIP            1
DT   C                   MOVE      'N'           USEAIP_F          1
EK   C                   MOVE      'N'           USERBD            1
     C                   MOVE      'N'           USEVEN            1
     C                   MOVE      'N'           USEVRR            1
      * SAVE CURRENT G/L ACCOUNT USED ON INVOICE
     C                   Z-ADD     GLNOC         SVGLNO
¢F   C                   Z-ADD     GLMNSUB       SVGLMNSUB
      * IF NOT PRE 10.1 INVOICE
     C     APCD04        IFNE      'Y'
      * IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
      * IF P/O NUMBER HAS CHANGED
     C     POCHG         IFEQ      'Y'
      ** IF SKIP MATCH IS NO
     C     SKIPPO        IFNE      'Y'
     C                   MOVE      'Y'           LDACCT
     C                   MOVE      'Y'           LOADBR
      ** LOAD MESSAGE THAT G/L ACCOUNT HAS BEEN CHANGED
      ** IF P/O TYPE IS BLANKET OR OVERHEAD
     C     POCD01        IFEQ      'F'
     C     POCD01        OREQ      'O'
     C                   MOVEA     UMS(15)       MSGFLD
     C                   ELSE
      ** IF P/O TYPE IS NOT BLANKET OR OVERHEAD
     C                   MOVEA     UMS(16)       MSGFLD
     C                   ENDIF                                                  POCD01 EQ F
     C                   ENDIF                                                  SKIPPO NE Y
     C                   ENDIF                                                  POCHG EQ Y
      * IF SKIPPO HAS CHANGED
     C     SKPCHG        IFEQ      'Y'
     C                   MOVE      'Y'           LDACCT
     C                   MOVE      'Y'           LOADBR
      ** LOAD MESSAGE THAT G/L ACCOUNT HAS BEEN CHANGED
     C                   MOVEA     UMS(17)       MSGFLD
     C                   ENDIF                                                  SKPCHG EQ Y
DT    * IF MATCH FREIGHT HAS CHANGED...
DT   C     MFRT_CHG      IFEQ      'Y'
DT   C                   MOVE      'Y'           LDACCT
DT   C                   MOVE      'Y'           LOADBR
DT    ** LOAD MESSAGE THAT G/L ACCOUNT HAS BEEN CHANGED
DT   C     MSGFLD        IFEQ      *BLANKS
DT   C                   MOVEA     EMS(132)      MSGFLD
DT   C                   ENDIF                                                  SKPCHG EQ Y
DT   C                   ENDIF                                                  SKPCHG EQ Y
DT    *
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT/DEBIT MEMO
      * IF MULTIPLE G/L CODE IS EQUAL TO '*'
     C     CD16C         IFEQ      '*'
     C                   MOVE      'Y'           LDACCT
     C                   MOVE      'Y'           LOADBR
     C                   ELSE
      * IF V/R NUMBER HAS CHANGED
     C     VRCHG         IFEQ      'Y'
      ** IF SKIP MATCH IS NO
     C     SKIPPO        IFNE      'Y'
     C                   MOVE      'Y'           LDACCT
     C                   MOVE      'Y'           LOADBR
      ** LOAD MESSAGE THAT G/L ACCOUNT HAS BEEN CHANGED
     C                   MOVEA     UMS(26)       MSGFLD
     C                   ENDIF                                                  SKIPPO NE Y
     C                   ENDIF                                                  VRCHG EQ Y
      * IF SKIP MATCH HAS CHANGED
     C     SKPCHG        IFEQ      'Y'
     C                   MOVE      'Y'           LDACCT
     C                   MOVE      'Y'           LOADBR
      ** LOAD MESSAGE THAT G/L ACCOUNT HAS BEEN CHANGED
     C                   MOVEA     UMS(17)       MSGFLD
     C                   ENDIF                                                  SKPCHG EQ Y
      ** IF SKIPPO IS YES
     C     SKIPPO        IFEQ      'Y'
      * IF REFERENCED TO INVOICE
      * AND G/L ACCOUNT USED IS NOT THE SAME G/L ACCOUNT USED ON THE
      * REFERENCED INVOICE
     C     NO26K         IFNE      *BLANKS
     C     AXCD16        IFNE      'Y'
     C     GLNOC         IFNE      GLNOR
     C                   MOVE      'Y'           LDACCT
     C                   MOVEA     UMS(19)       MSGFLD
     C                   ENDIF                                                  GLNOC NE GLNOR
     C                   ELSE
     C     GLNOC2        IFEQ      AIPGL2
DT   C     GLNOC2        OREQ      AIPGL2_F
     C                   MOVE      'Y'           LDACCT
     C                   MOVE      'Y'           LOADBR
     C                   MOVEA     UMS(19)       MSGFLD
     C                   ENDIF                                                  GLNOC2 EQ AIPGL2
     C                   ENDIF                                                  AXCD16 NE Y
     C                   ELSE
      * IF NOT REFERENCED TO INVOICE
      * IF G/L ACCOUNT USED IS ACCRUED INVENTORY PAYABLES
      * OR G/L ACCOUNT USED IS VENDOR RETURN RECEIVABLE
     C     GLNOC2        IFEQ      AIPGL2
     C     GLNOC2        OREQ      VRRGL2
DT   C     GLNOC2        OREQ      AIPGL2_F
     C                   MOVE      'Y'           LDACCT
     C                   MOVE      'Y'           LOADBR
     C                   MOVEA     UMS(18)       MSGFLD
     C                   ENDIF                                                  GLNOC2 EQ AIPGL2
     C                   ENDIF                                                  NO26K NE ' '
     C                   ENDIF                                                  SKIPPO EQ Y
     C                   ENDIF                                                  CD16C EQ '*'
     C                   ENDIF                                                  CD26K EQ I
     C                   ENDIF                                                  APCD04 NE Y
      ** IF LOAD ACCOUNT FLAG IS YES
     C     LDACCT        IFEQ      'Y'
      ** IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
      ** IF SKIP MATCH IS YES
      ** OR SKIP MATCH IS NO AND P/O TYPE IS BLANKET OR OVERHEAD
      ** IF G/L ACCOUNT ON INVOICE IS THE ACCRUED PAYABLE ACCOUNT
      ** OR G/L ACCOUNT ON INVOICE IS ZERO
      ** LOAD FROM VENDOR MASTER
     C     SKIPPO        IFEQ      'Y'
DT   C     MATCH_FRT     ANDNE     'Y'
     C     SKIPPO        OREQ      'N'
     C     POCD01        ANDEQ     'F'
     C     SKIPPO        OREQ      'N'
     C     POCD01        ANDEQ     'O'
     C     GLNOC2        IFEQ      AIPGL2
DT   C     GLNOC2        OREQ      AIPGL2_F
     C     GLNOC         OREQ      0
      ** LOAD MULTIPLE G/L CODE FROM VENDOR MASTER
     C     APCD20        IFNE      'Y'
     C                   MOVE      'N'           CD16C
     C                   ELSE
     C                   MOVE      'Y'           CD16C
     C                   ENDIF
      ** DO NOT LOAD IF VENDOR SET UP WITH SPLIT G/L DISTRIBUTION
     C     APCD20        IFNE      'Y'
     C                   MOVE      VNGLNO        GLNOC
     C                   MOVE      'Y'           USEVEN
     C                   ELSE
     C                   Z-ADD     0             GLNOC
     C                   MOVE      *BLANKS       GDN03C
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** IF SKIP MATCH IS NO AND P/O TYPE IS NOT BLANKET OR OVERHEAD
      ** LOAD ACCRUED INVENTORY PAYABLES ACCOUNT
DT   C     SKIPPO        IFNE      'Y'
     C                   MOVE      AIPGL         GLNOC
     C                   MOVE      'Y'           USEAIP
      ** LOAD MULTIPLE G/L CODE WITH 'N'
     C                   MOVE      'N'           CD16C
DT   C                   ELSE
DT   C     MATCH_FRT     IFEQ      'Y'
DT   C                   MOVE      AIPGL_F       GLNOC
DT   C                   MOVE      'Y'           USEAIP_F
DT    ** LOAD MULTIPLE G/L CODE WITH 'N'
DT   C                   MOVE      'N'           CD16C
DT   C                   ENDIF
DT   C                   ENDIF
     C                   ENDIF
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
      ** IF SKIP MATCH IS YES
     C     SKIPPO        IFEQ      'Y'
      ** IF NOT REFERENCED
      ** LOAD FROM VENDOR MASTER
     C     NO26K         IFEQ      *BLANKS
      ** LOAD MULTIPLE G/L CODE FROM VENDOR MASTER
     C     APCD20        IFNE      'Y'
     C                   MOVE      'N'           CD16C
     C                   ELSE
     C                   MOVE      'Y'           CD16C
     C                   ENDIF
      ** DO NOT LOAD IF VENDOR SET UP WITH SPLIT G/L DISTRIBUTION
     C     APCD20        IFNE      'Y'
     C                   MOVE      VNGLNO        GLNOC
     C                   MOVE      'Y'           USEVEN
     C                   ELSE
     C                   Z-ADD     0             GLNOC
     C                   MOVE      *BLANKS       GDN03C
     C                   ENDIF
     C                   ELSE
      ** IF REFERENCED
      ** LOAD REFERENCED INVOICE G/L ACCOUNT
     C                   MOVE      GLNOR         GLNOC
     C                   MOVE      *BLANKS       GDN03C
      ** LOAD MULTIPLE G/L CODE WITH VALUE FROM REFERENCED INVOICE
     C                   MOVE      AXCD16        CD16C
     C                   ENDIF
     C                   ELSE
      ** IF SKIP MATCH IS NO
EK    *----------------------
EK    * Rebate credit memo...
EK    *----------------------
EK   C                   IF        REB_CR = 'Y'
EK   C                   MOVE      RBDGL         GLNOC
EK   C                   MOVE      'Y'           USERBD
EK    ** LOAD MULTIPLE G/L CODE WITH 'N'
EK   C                   MOVE      'N'           CD16C
EK    *-----------------------------
EK    * Vendor return credit memo...
EK    *-----------------------------
      ** LOAD VENDOR RETURN RECEIVABLE ACCOUNT
EK   C                   ELSE
   ¢AC*   IF GMC VEND, USE DIFF VR RECEIVABLE #
¢A   C     APNO01        IFEQ      14141
¢A   C     APNO01        OREQ      14158
¢A   C     APNO01        OREQ      22389
¢A   C                   Z-ADD     4500          VRNO33
¢A   C                   Z-ADD     23            VRNO34
¢A   C                   END
     C                   MOVE      VRRGL         GLNOC
     C                   MOVE      'Y'           USEVRR
      ** LOAD MULTIPLE G/L CODE WITH 'N'
     C                   MOVE      'N'           CD16C
EK   C                   ENDIF
     C                   ENDIF                                                  SKIPPO EQ Y
     C                   ENDIF                                                  CD26K EQ I
     C                   ENDIF                                                  LDACCT EQ Y
      ** LOAD BRANCH NUMBER IN G/L ACCOUNT
     C     LOADBR        IFEQ      'Y'
      ** IF VENDOR MASTER G/L ACCOUNT USED
      *** IF A/P EXPENSES ARE POSTED BY BRANCH
      *** AND THE G/L ACCOUNT NUMBER IS NOT ZERO
      *** AND THE INVOICE BRANCH IS DIFFERENT FROM THE G/L BRANCH
      *** OVERRIDE BRANCH NUMBER IN G/L ACCOUNT WITH INVOICE BRANCH NUMBER
     C     USEVEN        IFEQ      'Y'
     C     TBEXPS        IFEQ      'Y'
     C     GLNOC         ANDNE     0
     C     APBR#C        ANDNE     GNO06C
     C                   MOVE      APBR#C        GNO06C
     C                   ENDIF
     C                   ENDIF
      ** IF ACCRUED INVENTORY PAYABLES USED
      *** IF ACCRUED INVENTORY PAYABLES POSTED BY BRANCH
      *** AND THE INVOICE BRANCH IS DIFFERENT FROM THE G/L BRANCH
      *** OVERRIDE BRANCH NUMBER IN G/L ACCOUNT WITH INVOICE BRANCH NUMBER
     C     USEAIP        IFEQ      'Y'
     C     AIPSUM        IFEQ      'B'
     C     APBR#C        ANDNE     GNO06C
     C                   MOVE      APBR#C        GNO06C
     C                   ENDIF
     C                   ENDIF
DT    ** IF ACCRUED FREIGHT PAYABLES USED
DT    *** IF ACCRUED FREIGHT PAYABLES POSTED BY BRANCH
DT    *** AND THE INVOICE BRANCH IS DIFFERENT FROM THE G/L BRANCH
DT    *** OVERRIDE BRANCH NUMBER IN G/L ACCOUNT WITH INVOICE BRANCH NUMBER
DT   C     USEAIP_F      IFEQ      'Y'
DT   C     AIPSUM_F      IFEQ      'B'
DT   C     APBR#C        ANDNE     GNO06C
DT   C                   MOVE      APBR#C        GNO06C
DT   C                   ENDIF
DT   C                   ENDIF
EK    ** IF ACCRUED FREIGHT PAYABLES USED
EK    *** IF ACCRUED FREIGHT PAYABLES POSTED BY BRANCH
EK    *** AND THE INVOICE BRANCH IS DIFFERENT FROM THE G/L BRANCH
EK    *** OVERRIDE BRANCH NUMBER IN G/L ACCOUNT WITH INVOICE BRANCH NUMBER
EK   C     USERBD        IFEQ      'Y'
EK   C     AIPSUM_R      IFEQ      'B'
EK   C     APBR#C        ANDNE     GNO06C
EK   C                   MOVE      APBR#C        GNO06C
EK   C                   ENDIF
EK   C                   ENDIF
      ** IF VENDOR RETURN RECEIVABLE USED
      *** IF VENDOR RETURN RECEIVABLE IS POSTED BY BRANCH
      *** AND THE INVOICE BRANCH IS DIFFERENT FROM THE G/L BRANCH
      *** OVERRIDE BRANCH NUMBER IN G/L ACCOUNT WITH INVOICE BRANCH NUMBER
     C     USEVRR        IFEQ      'Y'
     C     VRRSUM        IFEQ      'B'
     C     APBR#C        ANDNE     GNO06C
     C                   MOVE      APBR#C        GNO06C
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * GET G/L ACCOUNT DESCRIPTION
     C     GLNOC         IFNE      0
     C     GLKEYC        CHAIN     GLFMSTR                            48
     C     *IN48         IFEQ      *OFF
     C                   MOVE      GLDN03        GDN03C
     C                   ENDIF
     C                   ENDIF
      * COMPARE NEW G/L ACCOUNT TO SAVED G/L ACCOUNT
      * IF THE SAME, CLEAR MESSAGE FIELD
     C     GLNOC         IFEQ      SVGLNO
     C                   MOVE      *BLANK        MSGFLD
     C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      * DELETE INVOICE
      *------------------------------------------------------------------------*
     C     DELET         BEGSR
      * DELETE UNAPPROVED VENDOR
     C     APCD21        IFEQ      'Y'
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO01C         CHAIN     APFMVEN1                           4192
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN41         IFEQ      *OFF
     C                   DELETE    APFMVEN1
     C                   ENDIF
     C                   ENDIF
      * REMOVE ALL MATCHING
     C                   EXSR      DLTMTH
DT   C                   EXSR      DLTMTH_FRT
      * DELETE MULTIPLE PAYMENT RECORDS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINP                            4292
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN42         DOWEQ     *OFF
     C                   DELETE    APFTINP
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTINP                              9242
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
      * DELETE INVOICE NOTE RECORDS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINN                            4292
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN42         DOWEQ     *OFF
     C                   DELETE    APFTINN
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTINN                              9242
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
      * DELETE MULTIPLE G/L RECORDS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTING                            4292
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN42         DOWEQ     *OFF
     C                   DELETE    APFTING
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTING                              9242
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
      * DELETE OTHER CHARGES RECORDS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINO                            42
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN42         DOWEQ     *OFF
     C                   DELETE    APFTINO
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTINO                                42
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
      * DELETE IMAGE RECORDS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINI1                           42
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN42         DOWEQ     *OFF
     C                   DELETE    APFTINI1
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTINI1                               42
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
DD    * UPDATE JOB LOT P.O. DETAIL
DD   C                   EXSR      SRLOT
      * DELETE INVOICE RECORD
     C                   DELETE    APFTINH1
      * UPDATE VENDOR ANALYSIS FIELDS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     APNO01        CHAIN     APFMVEN1                           4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   SUB       1             APNO06
     C                   SUB       APAM06        APAM03
     C                   UPDATE    APFMVEN1
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * WRITE/UPDATE INVOICE RECORDS
      *------------------------------------------------------------------------*
     C     WRITE         BEGSR
      *
     C                   MOVEL     AD04C         APAD04
     C                   MOVEL     AD05C         APAD05
     C                   MOVEL     AD06C         APAD06
     C     APCD04        IFNE      'Y'
     C                   MOVE      'N'           APCD04
     C                   ENDIF
     C                   MOVE      ' '           APCD11
     C                   MOVE      CHKMO         APMO08
     C                   MOVE      CHKDY         APDY08
     C     CHKDTC        IFNE      *ZERO
     C                   MOVE      CHKCC         APCC08
     C                   ELSE
     C                   Z-ADD     *ZERO         APCC08
     C                   ENDIF
     C                   MOVE      CHKYR         APYR08
     C     VARCDE        IFEQ      'H'                                          HAS VARIANCE
     C                   MOVE      'H'           APCD10                         HOLD INV
     C                   ELSE
     C     VARCDE        IFEQ      'W'
     C                   MOVE      'W'           APCD10                         HOLD INV
     C                   ELSE
     C     VARCDE        IFEQ      'A'                                          HAS VARIANCE
     C                   MOVE      'A'           APCD10                         ACCEPT VAR.
     C                   ELSE
     C                   MOVE      ' '           APCD10                         NO VAR/NO HOLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
DT   C     VARCDE_F      IFEQ      'H'                                          HAS VARIANCE
DT   C                   MOVE      'H'           APCD79                         HOLD INV
DT   C                   ELSE
DT   C     VARCDE_F      IFEQ      'A'                                          HAS VARIANCE
DT   C                   MOVE      'A'           APCD79                         ACCEPT VAR.
DT   C                   ELSE
DT   C                   MOVE      ' '           APCD79                         NO VAR/NO HOLD
DT   C                   ENDIF
DT   C                   ENDIF
     C                   MOVE      CD16C         APCD16
     C                   MOVE      CY02C         APCY02
     C                   Z-ADD     UDAY          APDY01
     C                   Z-ADD     UMONTH        APMO01
     C                   Z-ADD     UYEAR         APYR01
     C                   MOVEL     *YEAR         APCC01
     C                   MOVE      INVMO         APMO04
     C                   MOVE      INVDY         APDY04
     C     INVDTC        IFNE      *ZERO
     C                   MOVE      INVCC         APCC04
     C                   ELSE
     C                   Z-ADD     *ZERO         APCC04
     C                   ENDIF
     C                   MOVE      INVYR         APYR04
     C                   MOVE      RECMO         APMO05
     C                   MOVE      RECDY         APDY05
     C     RECDTC        IFNE      *ZERO
     C                   MOVE      RECCC         APCC05
     C                   ELSE
     C                   Z-ADD     *ZERO         APCC05
     C                   ENDIF
     C                   MOVE      RECYR         APYR05
     C                   MOVE      DUEMO         APMO06
     C                   MOVE      DUEDY         APDY06
     C     DUEDTC        IFNE      *ZERO
     C                   MOVE      DUECC         APCC06
     C                   ELSE
     C                   Z-ADD     *ZERO         APCC06
     C                   ENDIF
     C                   MOVE      DUEYR         APYR06
     C     DSCDTC        IFGT      0
     C                   MOVE      DSCMO         APMO11
     C                   MOVE      DSCDY         APDY11
     C                   MOVE      DSCCC         APCC11
     C                   MOVE      DSCYR         APYR11
     C                   ELSE
     C                   MOVE      DUEMO         APMO11
     C                   MOVE      DUEDY         APDY11
     C     DUEDTC        IFNE      *ZERO
     C                   MOVE      DUECC         APCC11
     C                   ELSE
     C                   Z-ADD     *ZERO         APCC11
     C                   ENDIF
     C                   MOVE      DUEYR         APYR11
     C                   ENDIF
     C                   MOVE      ACTMOC        APMO12
     C     ACTDTC        IFNE      *ZERO
     C                   MOVE      ACTCCC        APCC12
     C                   ELSE
     C                   Z-ADD     *ZERO         APCC12
     C                   ENDIF
     C                   MOVE      ACTYRC        APYR12
      * If it's a direct load the direct ship date...
     C     DIRECT        IFEQ      'Y'
     C                   MOVE      DSHMO         APMO22
     C                   MOVE      DSHDY         APDY22
     C     DSHDTC        IFNE      *ZERO
     C                   MOVE      DSHCC         APCC22
     C                   ELSE
     C                   Z-ADD     *ZERO         APCC22
     C                   ENDIF
     C                   MOVE      DSHYR         APYR22
      * If it's not a direct, clear the direct ship date...
     C                   ELSE
     C                   CLEAR                   APMO22
     C                   CLEAR                   APDY22
     C                   CLEAR                   APCC22
     C                   CLEAR                   APYR22
     C                   ENDIF
      *
     C                   MOVE      NO38C         APNO38
     C                   Z-ADD     UMONTH        APMO01
     C                   MOVE      USRNM         APNM04
     C                   MOVE      NO01C         APNO01
     C                   MOVE      NO11C         APNO11
     C                   MOVE      APCO#F        APNO15
     C                   MOVE      APBR#C        APNO16
     C                   MOVE      BATCH#        APNO17
     C                   MOVE      NO21C         APNO21
     C                   MOVE      PC01C         APPC01
     C                   MOVE      PC40C         APPC40
     C                   MOVE      ST02C         APST02
     C                   Z-ADD     UYEAR         APYR01
     C                   MOVEL     *YEAR         APCC01
     C                   MOVE      ZP08C         APZP08
     C                   MOVE      GLNOC         GLNO
     C                   MOVE      NO25C         APNO25
     C                   MOVE      CD26K         APCD26
     C                   MOVE      NO26K         APNO26
     C                   Z-ADD     REFCTL        APNO39
     C                   MOVE      PO#           APNO35                         ENT PO#
     C                   MOVE      SKIPPO        APFL01
DT   C                   MOVE      MATCH_FRT     APFL13
EK   C                   MOVE      REB_CR        APFL14
EZ   C                   MOVE      CD81C         APCD81
     C                   MOVE      CD43K         APCD43
     C                   MOVE      OTHCHG        APCD53
     C                   MOVE      CD57C         APCD57
     C                   MOVE      DIRECT        APCD45                         DIRECT A/P
      *
     C                   MOVE      ' '           APRVIT
     C                   MOVE      ' '           PSTCHK            1
     C     APCD29        IFEQ      'Y'
     C     APCD43        ANDNE     'Y'                                          MANUAL HOLD
     C     APCD10        ANDNE     'H'                                          HAS VARIANCE
     C     APCD10        ANDNE     'E'
     C     APCD10        ANDNE     'W'
DT   C     APCD79        ANDNE     'H'
     C     CD67          ANDNE     'P'                                          NOT PRE-NOTE
     C                   MOVE      'P'           APCD11
     C                   MOVE      'Y'           APCD09
     C                   MOVE      UMONTH        APMO08
     C                   MOVE      UDAY          APDY08
     C                   MOVEL     *YEAR         APCC08
     C                   MOVE      UYEAR         APYR08
     C                   MOVE      'Y'           APRVIT
     C                   MOVE      UDAY          APDY14
     C                   MOVE      UMONTH        APMO14
     C                   MOVE      UYEAR         APYR14
     C                   MOVEL     *YEAR         APCC14
     C                   ELSE
     C     APCD09        IFNE      'Y'                                          NOT APPROVED
     C     AUTOAP        ANDEQ     'Y'                                          AUTO APPROVE
     C     APCD43        ANDNE     'Y'                                          MANUAL HOLD
     C     APCD10        ANDNE     'H'                                          VAR ON HOLD
     C     APCD10        ANDNE     'E'
     C     APCD10        ANDNE     'W'
DT   C     APCD79        ANDNE     'H'
     C                   MOVE      'Y'           APCD09                         APPROVE INV.
     C                   MOVE      'Y'           APRVIT
     C                   MOVE      UDAY          APDY14
     C                   MOVE      UMONTH        APMO14
     C                   MOVE      UYEAR         APYR14
     C                   MOVEL     *YEAR         APCC14
     C                   ENDIF
     C                   ENDIF
      * If A/P accounting period is less than A/R accounting period
      * do not approve the invoice (Directs Only)...
     C     APCD45        IFEQ      'Y'                                          DIRECT
DH   C     SVCD09        ANDNE     'Y'
     C                   Z-ADD     APCC12        CMPCC2
     C                   Z-ADD     APYR12        CMPYR2
     C                   Z-ADD     APMO12        CMPMO2
     C     CMPPD2        IFLT      CRARPD
     C                   CLEAR                   APCD09
     C                   CLEAR                   APDY14
     C                   CLEAR                   APMO14
     C                   CLEAR                   APYR14
     C                   CLEAR                   APCC14
     C                   ENDIF
     C                   ENDIF
      *
      * IF THIS INVOICE IS REFERENCING ANOTHER INVOICE IT WILL BE
      * PLACED ON REFERENCE HOLD UNLESS IT HAD PREVIOUSLY BEEN
      * APPROVED.  REFERENCING INVOICES ONLY GET APPROVED WHEN THE
      * REFERENCED INVOICE GETS APPROVED...
      *
     C     APNO26        IFNE      *BLANKS
     C                   MOVE      SVCD09        APCD09
     C                   Z-ADD     SVMO14        APMO14
     C                   Z-ADD     SVDY14        APDY14
     C                   Z-ADD     SVCC14        APCC14
     C                   Z-ADD     SVYR14        APYR14
     C     APCD09        IFNE      'Y'
     C                   MOVE      'R'           APCD10
     C                   CLEAR                   APDY14
     C                   CLEAR                   APMO14
     C                   CLEAR                   APYR14
     C                   CLEAR                   APCC14
     C                   ENDIF
      *
      * SEE IF THIS IS A REFERENCED INVOICE, AND IF SO IT CAN ONLY BE
      * APPROVED IF ALL REFERENCING INVOICES CAN ALSO BE APPROVED...
      *
     C                   ELSE
      *
     C     APNO20        SETLL     APLWINHR                               40
     C     *IN40         IFEQ      *ON
     C     SVCD09        IFEQ      'Y'
     C                   MOVE      'Y'           APCD09
     C                   Z-ADD     SVMO14        APMO14
     C                   Z-ADD     SVDY14        APDY14
     C                   Z-ADD     SVCC14        APCC14
     C                   Z-ADD     SVYR14        APYR14
     C                   ELSE
     C     APCD09        IFEQ      'Y'
     C                   MOVE      APNO20        PMICTL
     C                   CLEAR                   PMOAPP
     C                   CALL      'APR1057'
     C                   PARM                    PMICTL            7
     C                   PARM                    PMOAPP            1
     C     PMOAPP        IFNE      'Y'
     C                   CLEAR                   APCD09
     C                   CLEAR                   APDY14
     C                   CLEAR                   APMO14
     C                   CLEAR                   APYR14
     C                   CLEAR                   APCC14
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If payment type is not an ACH type, clear ACH fields...
     C     CD67          IFNE      'A'
     C     CD67          ANDNE     'P'
     C                   CLEAR                   CD68
     C                   CLEAR                   NO53
     C                   CLEAR                   CD60
     C                   CLEAR                   PPDAT
     C                   CLEAR                   PPCC
     C                   ENDIF
      * Load ACH screen fields to the database fields...
     C                   MOVE      CD60          APCD60
     C                   MOVE      CD67          APCD67
     C                   MOVE      CD68          APCD68
     C                   MOVE      NO53          APNO53
     C     PPDAT         IFNE      *ZERO
     C                   MOVE      PPMO          APMO21
     C                   MOVE      PPDY          APDY21
     C                   MOVE      PPCC          APCC21
     C                   MOVE      PPYR          APYR21
     C                   ELSE
     C                   CLEAR                   APMO21
     C                   CLEAR                   APDY21
     C                   CLEAR                   APCC21
     C                   CLEAR                   APYR21
     C                   ENDIF
DD    * UPDATE JOB LOT P.O. DETAIL
DD   C                   EXSR      SRLOT
      * UPDATE HEADER RECORD
     C                   UPDATE    APFTINH1
      * CHECK FOR RECORD LOCK AND RELOCK RECORD SO WE CAN PROCESS
      * IN CASE SOMEONE ELSE IS TRYING TO ACCESS BEFORE WRITE IS
      * COMPLETE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINH1                           4692      1ST RCD
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      * DELETE EXISTING NOTES
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINN                            4392
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN43         DOWEQ     *OFF
     C                   DELETE    APFTINN
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTINN                              9243
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
      * WRITE INVOICE NOTES
     C     AP02          IFEQ      *ON
     C                   MOVE      '1'           APCD65
     C                   MOVE      NO01C         APNO01
     C                   MOVE      NO11C         APNO11
     C                   MOVE      NO20C         APNO20
     C                   Z-ADD     UMONTH        APMO01
     C                   Z-ADD     UDAY          APDY01
     C                   Z-ADD     UYEAR         APYR01
     C                   MOVEL     *YEAR         APCC01
     C                   MOVEL     USRNM         APNM04
     C                   Z-ADD     1             X
   FAC*    X             DOUGT     20
   DGC*    NOT(X)        IFGT      *BLANKS
   DGC*                  MOVE      NOT(X)        APTX01
FA   C     X             DOUGT     98
DG   C     NTE(X)        IFGT      *BLANKS
DG   C                   MOVE      NTE(X)        APTX01
     C                   WRITE     APFTINN
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDIF
      * WRITE CHECK NOTES
     C     AP03          IFEQ      *ON
     C                   MOVE      '2'           APCD65
     C                   MOVE      NO01C         APNO01
     C                   MOVE      NO11C         APNO11
     C                   MOVE      NO20C         APNO20
     C                   Z-ADD     UMONTH        APMO01
     C                   Z-ADD     UDAY          APDY01
     C                   Z-ADD     UYEAR         APYR01
     C                   MOVEL     *YEAR         APCC01
     C                   MOVEL     USRNM         APNM04
     C                   Z-ADD     1             X
   FAC*    X             DOUGT     20
FA   C     X             DOUGT     98
     C     CKN(X)        IFGT      *BLANKS
     C                   MOVE      CKN(X)        APTX01
     C                   WRITE     APFTINN
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDIF
¢F    * HANDLE CUSTOMER DEPOSIT REFUND CHECK NOTE
¢F        Select;
¢F        When GLMNSUB = glDepRef;
¢F           Exsr srWrtCkNot;
¢F        When GLMNSUB <> glDepRef;
¢F           Exsr srDltCkNot;
¢F        EndSl;
      * WRITE MULTIPLE PAYMENTS RECORDS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINP                            4292
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN42         DOWEQ     *OFF
     C                   DELETE    APFTINP
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTINP                              9242
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
     C     APCD12        IFEQ      'Y'
     C                   MOVE      NO01C         APNO01
     C                   MOVE      NO11C         APNO11
     C                   MOVE      NO20C         APNO20
     C                   Z-ADD     UMONTH        APMO01
     C                   Z-ADD     UDAY          APDY01
     C                   MOVEL     *YEAR         APCC01
     C                   Z-ADD     APNO13        PNO13
     C                   Z-ADD     UYEAR         APYR01
     C                   MOVEL     USRNM         APNM04
     C                   Z-ADD     0             FIX               2 0
     C                   Z-ADD     1             X
     C     X             DOUGT     20
     C     X             OCCUR     PAYS
     C     AM12D         IFNE      0
     C                   MOVE      AM12D         APAM12
     C                   MOVE      AM16D         APAM16
     C                   MOVE      AM17D         APAM17
     C                   MOVE      AM18D         APAM18
     C                   MOVE      AM37D         APAM37
     C                   MOVE      AM19D         APAM19
     C                   MOVE      AM27D         APAM27
     C                   MOVE      PAYMOD        APMO10
     C                   MOVE      PAYDYD        APDY10
     C                   MOVE      PAYCCD        APCC10
     C                   MOVE      PAYYRD        APYR10
     C                   ADD       1             FIX
     C                   Z-ADD     FIX           APNO12
     C                   WRITE     APFTINP
     C                   END
     C                   ADD       1             X
     C                   END
     C                   END
      * WRITE MULTIPLE G/L RECORDS
     C     *IN33         IFEQ      *OFF
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTING                            4292
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN42         DOWEQ     *OFF
     C                   DELETE    APFTING
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTING                              9242
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
     C     APCD16        IFEQ      'Y'
     C                   MOVE      NO11C         APNO11
     C                   MOVE      NO01C         APNO01
     C                   MOVE      NO20C         APNO20
     C                   Z-ADD     UMONTH        APMO01
     C                   Z-ADD     UDAY          APDY01
     C                   MOVEL     *YEAR         APCC01
     C                   Z-ADD     UYEAR         APYR01
     C                   MOVEL     USRNM         APNM04
     C                   Z-ADD     1             RNS
     C     RNS           CHAIN     APS1112S                           42
     C     *IN42         DOWEQ     *OFF
     C     GNO03S        IFNE      0
     C                   MOVE      GNO06S        GLNO06
     C                   MOVE      GNO02S        GLNO02
     C                   MOVE      GNO03S        GLNO03
     C                   MOVE      GNO04S        GLNO04
     C                   MOVE      AM15S         APAM15
     C                   WRITE     APFTING
     C                   ENDIF
     C                   ADD       1             RNS
     C     RNS           CHAIN     APS1112S                           42
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      * WRITE OTHER CHARGES RECORDS
     C     NO20C         CHAIN     APFTINO                            42
     C     *IN42         DOWEQ     *OFF
     C                   DELETE    APFTINO
     C     NO20C         READE     APFTINO                                42
     C                   ENDDO
     C     OTHCHG        IFEQ      'Y'
     C                   MOVE      NO11C         APNO11
     C                   MOVE      NO01C         APNO01
     C                   MOVE      NO20C         APNO20
     C                   Z-ADD     UMONTH        APMO01
     C                   Z-ADD     UDAY          APDY01
     C                   MOVEL     *YEAR         APCC01
     C                   Z-ADD     UYEAR         APYR01
     C                   MOVEL     USRNM         APNM04
     C                   Z-ADD     1             RNS2
     C     RNS2          CHAIN     APS112S2                           42
     C     *IN42         DOWEQ     *OFF
     C     NO03S2        IFNE      0
     C                   MOVE      *ZEROS        PONO27
     C                   MOVE      *BLANKS       POCD53
     C                   MOVE      DN06S2        APDN06
     C                   MOVE      NO06S2        GLNO06
     C                   MOVE      NO02S2        GLNO02
     C                   MOVE      NO03S2        GLNO03
     C                   MOVE      NO04S2        GLNO04
     C                   MOVE      AM35S2        APAM35
     C                   WRITE     APFTINO
     C                   ENDIF
     C                   ADD       1             RNS2
     C     RNS2          CHAIN     APS112S2                           42
     C                   ENDDO
      *
     C                   Z-ADD     1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C     *IN42         DOWEQ     *OFF
     C     NO03S3        IFNE      0
     C                   MOVE      NO27S3        PONO27
     C                   MOVE      CD53S3        POCD53
     C                   MOVE      DN06S3        APDN06
     C                   MOVE      NO06S3        GLNO06
     C                   MOVE      NO02S3        GLNO02
     C                   MOVE      NO03S3        GLNO03
     C                   MOVE      NO04S3        GLNO04
     C                   MOVE      AM35S3        APAM35
     C                   WRITE     APFTINO
     C                   ENDIF
     C                   ADD       1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C                   ENDDO
     C                   ENDIF
      * WRITE INVOICE IMAGE RECORD
     C     NO20C         CHAIN     APFTINI1                           42
     C     *IN42         IFEQ      *OFF
     C                   DELETE    APFTINI1
     C                   ENDIF
     C     NO47          IFNE      0
EV   C     DN12          ORNE      *BLANKS
     C                   MOVE      NO01C         APNO01
     C                   MOVE      NO11C         APNO11
     C                   MOVE      NO20C         APNO20
     C                   MOVE      NO47          APNO47
EV   C                   MOVE      DN12          APDN12
     C                   WRITE     APFTINI1
     C                   ENDIF
      * REMOVE ANY MATCHING
      * IF INVOICE IS NOT APPROVED
      *
      * IF ORIGINAL SKIP MATCH IS NO
      * AND NOT FOR FREIGHT ONLY INVOICE
      * AND ORIGINAL P/O SELECTED IS NOT THE SAME AS THE LAST P/O
      * AND ORIGINAL P/O SELECTED WAS A DIRECT P/O
      ** DELETE THE DIRECT RECEIVER CREATED FOR THE ORIGINAL P/O MATCH
     C     SVCD09        IFNE      'Y'
     C     ORGSKP        IFNE      'Y'
     C     ORGFRT        ANDNE     'Y'
     C     ORGPO         ANDNE     LSTPO
     C     ORGDIR        ANDEQ     'D'
     C                   MOVE      ORGPO         DLTPO
     C                   MOVE      ORGRCV        DLTRCV
     C                   CALL      'APR1068'     PL1068
     C                   ENDIF                                                  ORGSKP EQ Y
      * REMOVE ORIGINAL MATCH THAT WAS NOT KEPT ON THE NEW MATCH
      * IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
     C                   Z-ADD     0             SAVRCV
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINM1                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MONO19        SAVRCV
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
     C     MTHKY2        CHAIN(N)  APFWMTH                            49
     C     *IN49         IFEQ      *ON
     C     ORGDIR        IFNE      'D'
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     TRDKY2        CHAIN     POFTRD1                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   EXCEPT    UPDRD1
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  ORGDIR NE D
     C                   ENDIF                                                  IN49 EQ ON
     C                   DELETE    APFTINM1
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTINM1                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      *REMOVE MAINTENANCE LOCK FLAG IN RECEIVER HEADER
     C     MONO19        IFNE      SAVRCV
     C     *IN45         OREQ      *ON
      *** DO NOT UPDATE HEADER IF IN CURRENT MATCH
     C     INM1K2        CHAIN     APFWMTH6                           49
     C     *IN49         IFEQ      *ON
      * GET RECEIVER HEADER
      * CHECK FOR RECORD LOCK
      * IF RECORD LOCK FOUND, DO NOT LET USER HAVE THE RETRY OPTION
      * RECEIVER HEADER LOCK FLAG ALREADY SET TO Y
      * THIS UPDATE MUST HAPPEN OR THE RECEIVER LOCK FLAG WILL STAY Y
      *  AND WILL HAVE TO BE MANAULLY REMOVED USING DFU/DBU
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRCV        CHAIN     POFTRH                             4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POCD24
     C                   EXCEPT    UPDTRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  IN49 EQ ON
     C                   Z-ADD     MONO19        SAVRCV
     C                   ENDIF
     C                   ENDDO
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
EK    *======
EK    *----------------------
EK    * Rebate credit memo...
EK    *----------------------
EK   C                   IF        REB_CR = 'Y'
EK   C                   EXSR      DEL_TRBM
EK   C                   ELSE
EK    *-----------------
EK    * Vendor return...
EK    *-----------------
     C                   Z-ADD     0             SAVRTN
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINM9                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MONO27        SAVRTN
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
     C     MTH5K1        CHAIN(N)  APFWMTH5                           49
     C     *IN49         IFEQ      *ON
      * IF VENDOR RETURN LINE ITEM
     C     MOCD53        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VRLKY2        CHAIN     POFTVRL                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   EXCEPT    UPDRL1
      * INTERFACE PGM TO SEND UNMATCHED QTY TO DATAQ WIIN...
     C     WHMYES        IFEQ      'Y'
     C                   EXSR      SENDWM
     C                   ENDIF
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ELSE
      * IF VENDOR RETURN OTHER CHARGE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VROKY2        CHAIN     POFTVRO                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   EXCEPT    UPDVRO
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  MOCD53 EQ BL
     C                   ENDIF                                                  IN49 EQ ON
     C                   DELETE    APFTINM9
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTINM9                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      * REMOVE MAINTENANCE LOCK FLAG IN VENDOR RETURN HEADER
     C     MONO27        IFNE      SAVRTN
     C     *IN45         OREQ      *ON
      *** DO NOT UPDATE HEADER IF IN CURRENT MATCH
     C     INM9K2        CHAIN(N)  APFWMTH5                           49
     C     *IN49         IFEQ      *ON
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRTN        CHAIN     POFTVRH                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POFL06
     C                   EXCEPT    UPDVRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  IN49 EQ ON
     C                   Z-ADD     MONO27        SAVRTN
     C                   ENDIF
     C                   ENDDO
EK   C                   ENDIF
     C                   ENDIF                                                  CD26K EQ I
      * WRITE CURRENT MATCH
      * REMOVE MATCHING IN THE MATCH WORK FILE
EK    *======
EK    *----------------------
EK    * Rebate credit memo...
EK    *----------------------
EK   C                   IF        REB_CR = 'Y'
EK   C                   EXSR      OPEN_RB
EK   C                   EXSR      WRBM_TO_TRBM
EK   C                   ELSE
EK    *------------------------
EK    * P/O or Vendor return...
EK    *------------------------
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFWMTH                            4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         DOWEQ     *OFF
     C                   MOVE      NO01C         MPNO01
     C                   MOVE      NO11C         MPNO11
     C                   MOVE      NO20C         MPNO20
     C                   Z-ADD     MHAM29        APAM29
     C                   Z-ADD     MHAM30        APAM30
     C                   Z-ADD     MHAM31        APAM31
     C                   Z-ADD     MHAM32        APAM32
     C                   Z-ADD     MHQY03        APQY03
     C                   Z-ADD     MHQY04        APQY04
     C                   Z-ADD     MHQY05        APQY05
     C                   MOVE      MHCD49        APCD49
     C                   MOVE      MHCD50        APCD50
     C                   MOVE      MHSEL         APCD51
     C                   Z-ADD     MHNO01        MONO01
     C                   Z-ADD     MHNO05        MONO05
     C                   Z-ADD     MHNO19        MONO19
     C                   Z-ADD     MHNO27        MONO27
     C                   Z-ADD     MHNO32        MONO32
     C                   MOVE      MHCD53        MOCD53
     C                   Z-ADD     UMONTH        APMO01
     C                   Z-ADD     UDAY          APDY01
     C                   MOVEL     *YEAR         APCC01
     C                   Z-ADD     UYEAR         APYR01
     C                   MOVEL     USRNM         APNM04
     C                   CLEAR                   MOCD62
     C                   WRITE     APFTINM1
      * IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     TRDKEY        CHAIN     POFTRD1                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   EXCEPT    UPDRD1
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
      * AND VENDOR RETURN LINE ITEM
     C     MOCD53        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VRLKEY        CHAIN     POFTVRL                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   EXCEPT    UPDRL1
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
      * AND VENDOR RETURN OTHER CHARGE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VROKEY        CHAIN     POFTVRO                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   EXCEPT    UPDVRO
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  MOCD53 EQ BL
     C                   ENDIF                                                  CD26K EQ I
     C                   DELETE    APFWMTH
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFWMTH                              9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
EK   C                   ENDIF
      * IF SKIP MATCH IS NO
      * AND NOT FREIGHT ONLY INVOICE
     C     SKIPPO        IFNE      'Y'
     C     FRTONL        ANDNE     'Y'
      * IF INVOICE TYPE IS INVOICE
      * REMOVE MAINTENANCE LOCK FLAG IN RECEIVER HEADER(S)
      * READ MATCHED RECEIVER SUBFILE
     C     CD26K         IFEQ      'I'
     C                   Z-ADD     1             RNO
     C     RNO           CHAIN     APS1112O                           42
     C     *IN42         DOWEQ     *OFF
      * GET RECEIVER HEADER
      * CHECK FOR RECORD LOCK
      * IF RECORD LOCK FOUND, DO NOT LET USER HAVE THE RETRY OPTION
      * RECEIVER HEADER LOCK FLAG ALREADY SET TO Y
      * THIS UPDATE MUST HAPPEN OR THE RECEIVER LOCK FLAG WILL STAY Y
      *  AND WILL HAVE TO BE MANAULLY REMOVED USING DFU/DBU
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     PONO19        CHAIN     POFTRH                             4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      ** REMOVE MAINTENANCE LOCK
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POCD24
     C                   EXCEPT    UPDTRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ADD       1             RNO
     C     RNO           CHAIN     APS1112O                           42
     C                   ENDDO                                                  IN42 DOWEQ OFF
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
      * REMOVE MAINTENANCE LOCK FLAG IN VENDOR RETURN HEADER(S)
      * READ MATCHED VENDOR RETURN SUBFILE
EK   C                   IF        REB_CR <> 'Y'
     C                   Z-ADD     1             RNQ
     C     RNQ           CHAIN     APS1112Q                           42
     C     *IN42         DOWEQ     *OFF
      * GET VENDOR RETURN HEADER
      * CHECK FOR RECORD LOCK
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     PONO27        CHAIN     POFTVRH                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      ** REMOVE MAINTENANCE LOCK
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POFL06
     C                   EXCEPT    UPDVRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ADD       1             RNQ
     C     RNQ           CHAIN     APS1112Q                           42
     C                   ENDDO                                                  IN42 DOWEQ OFF
EK   C                   ENDIF
     C                   ENDIF                                                  CD26K EQ I
     C                   ENDIF                                                  SKIPPO NE Y
     C                   ENDIF                                                  SVCD09 NE Y
DT    * WRITE FREIGHT MATCHING...
DT   C                   EXSR      WRITE_FRT
      *
     C                   EXCEPT    RELAPH
     C     APRVIT        IFEQ      'Y'                                          APPROVE INVC
     C     APCD09        ANDEQ     'Y'
     C                   Z-ADD     APNO17        PBTH
     C                   Z-ADD     NO01C         PVND
     C                   MOVE      APNO11        PINV
     C                   Z-ADD     APNO20        CKCTL
     C                   MOVE      'AP1'         PTYP
     C                   Z-ADD     0             CKCO
     C                   Z-ADD     0             CKBANK
     C                   Z-ADD     0             CKRUN
     C                   Z-ADD     0             CKCHK
     C                   OUT       LDADTA                                       LDA DATA
     C                   MOVEA     ARY           CMD             102            MOVE TO CMD.
     C                   Z-ADD     102           LEN              15 5          CHG BOTTOM
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM                    LEN              15 5
     C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      * REMITTANCE ADDRESS SELECTION
      *------------------------------------------------------------------------*
     C     ADDSEL        BEGSR
      *
     C                   Z-ADD     0             RNE
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVE      *ON           *IN73
     C                   WRITE     APC1112E
     C                   MOVE      *OFF          *IN73
      * LOAD SUBFILE
     C                   MOVE      2             KCOD
     C                   MOVE      *BLANK        SELE
     C                   MOVE      'N'           F3WRN
     C                   MOVE      'N'           F12WRN
      *
     C     NO25C         IFNE      *ZEROS
     C     NO25C         CHAIN     APFMVEN4                           40
     C                   MOVE      *ON           *IN50
     C                   MOVE      NO25C         KVEN
     C                   ELSE
     C     NO01C         CHAIN     APFMVEN4                           40
     C                   MOVE      *OFF          *IN50
     C                   MOVE      NO01C         KVEN
     C                   ENDIF
      *
     C                   MOVE      APAD01        APAD04
     C                   MOVE      APAD02        APAD05
     C                   MOVE      APAD03        APAD06
     C                   MOVE      APST01        APST02
     C                   MOVE      APCY01        APCY02
     C                   MOVE      APZP07        APZP08
     C                   ADD       1             RNE
     C                   WRITE     APS1112E
      *
     C     ADDKEY        CHAIN     APFMVAD                            45
     C     *IN45         DOWEQ     *OFF
     C                   ADD       1             RNE
     C                   WRITE     APS1112E
     C     ADDKEY        READE     APFMVAD                                45
     C                   END
      *
     C     NO25C         IFNE      *ZEROS
     C     NO01C         CHAIN     APFMVEN4                           40
     C                   ENDIF
      * DISPLAY SUBFILE
     C     DSPE          TAG
     C                   Z-ADD     1             RNE
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVEA     '111'         *IN(74)
     C                   WRITE     APF1112E
     C                   EXFMT     APC1112E
     C                   MOVEA     '000'         *IN(74)
D5   C                   MOVE      *BLANKS       MSGFLD
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPE
     C                   END
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPE
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO PREVIOUS SCREEN
     C     *IN12         IFEQ      *ON
     C                   MOVE      *ON           *IN79
     C                   WRITE     APC1112E
     C                   MOVE      *OFF          *IN79
     C                   GOTO      DSPC
     C                   END
      * READ SUBFILE
     C                   READC     APS1112E                               42
      *
     C     *IN42         CABEQ     *ON           DSPE
      *
     C     SELE          IFNE      *BLANK
     C                   MOVE      APAD04        AD04C
     C                   MOVE      APAD05        AD05C
     C                   MOVE      APAD06        AD06C
     C                   MOVE      APST02        ST02C
     C                   MOVE      APCY02        CY02C
     C                   MOVE      APZP08        ZP08C
     C                   ELSE
     C                   GOTO      DSPE
     C                   END
      *
     C                   MOVE      *ON           *IN79
     C                   WRITE     APC1112E
     C                   MOVE      *OFF          *IN79
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * INVOICE NOTES
      *------------------------------------------------------------------------*
     C     INVNOT        BEGSR
      * INITIALIZE SUBFILE
     C                   Z-ADD     0             RNH
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVE      *ON           *IN73
     C                   WRITE     APC1112H
     C                   MOVE      *OFF          *IN73
      * LOAD SUBFILE
     C                   Z-ADD     1             X
   FAC*    X             DOUGT     20
   DGC*                  MOVEA     NOT(X)        APTX01
FA   C     X             DOUGT     98
DG   C                   MOVEA     NTE(X)        APTX01
     C                   ADD       1             RNH
     C                   WRITE     APS1112H
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   MOVE      'N'           F3WRN
     C                   MOVE      'N'           F12WRN
      * DISPLAY SUBFILE
     C     DSPH          TAG
     C                   Z-ADD     1             RNH
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVEA     '111'         *IN(74)
     C                   WRITE     APF1112H
     C                   EXFMT     APC1112H
     C                   MOVEA     '000'         *IN(74)
     C                   MOVE      *BLANKS       MSGFLD
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPH
     C                   END
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C                   MOVE      'N'           F12WRN                         RESET WARNING
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPH
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO PREVIOUS SCREEN
     C     *IN12         IFEQ      *ON
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C     F12WRN        IFEQ      'N'
     C                   MOVEA     EMS(7)        MSGFLD
     C                   MOVE      'Y'           F12WRN
     C                   GOTO      DSPH
     C                   ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
     C                   MOVE      'N'           F12WRN
      * READ SUBFILE
     C                   Z-ADD     0             X                 2 0
   DGC*                  MOVEA     *BLANKS       NOT
DG   C                   MOVEA     *BLANKS       NTE
     C                   READC     APS1112H                               42
     C     *IN42         DOWEQ     *OFF
     C     APTX01        IFNE      *BLANKS
     C                   MOVE      *ON           AP02
     C                   ADD       1             X
   DGC*                  MOVE      APTX01        NOT(X)
DG   C                   MOVE      APTX01        NTE(X)
     C                   ENDIF
     C                   READC     APS1112H                               42
     C                   ENDDO
      * DELETE SUBFILE
     C                   MOVE      *ON           *IN79
     C                   WRITE     APC1112H
     C                   MOVE      *OFF          *IN79
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * INVOICE CHECK NOTES
      *------------------------------------------------------------------------*
     C     CHKNOT        BEGSR
      * INITIALIZE SUBFILE
     C                   Z-ADD     0             RRNT
     C                   MOVE      *ON           *IN73
     C                   WRITE     APC1112T
     C                   MOVE      *OFF          *IN73
      * LOAD SUBFILE
     C                   Z-ADD     1             X
   FAC*    X             DOUGT     20
FA   C     X             DOUGT     98
     C                   MOVEA     CKN(X)        APTX01
     C                   ADD       1             RRNT
     C                   WRITE     APS1112T
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   MOVE      'N'           F3WRN
     C                   MOVE      'N'           F12WRN
      * DISPLAY SUBFILE
     C     DSPT          TAG
     C                   Z-ADD     1             RRNT
     C                   MOVEA     '111'         *IN(74)
     C                   WRITE     APF1112T
     C                   EXFMT     APC1112T
     C                   MOVEA     '000'         *IN(74)
     C                   MOVE      *BLANKS       MSGFLD
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C                   MOVE      'N'           F12WRN                         RESET WARNING
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPT
     C                   END
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C                   MOVE      'N'           F12WRN                         RESET WARNING
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPT
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO PREVIOUS SCREEN
     C     *IN12         IFEQ      *ON
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C     F12WRN        IFEQ      'N'
     C                   MOVEA     EMS(7)        MSGFLD
     C                   MOVE      'Y'           F12WRN
     C                   GOTO      DSPT
     C                   ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
     C                   MOVE      'N'           F12WRN
      * READ SUBFILE
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       CKN
     C                   READC     APS1112T                               42
     C     *IN42         DOWEQ     *OFF
     C     APTX01        IFNE      *BLANKS
     C                   MOVE      *ON           AP03
     C                   ADD       1             X
     C                   MOVE      APTX01        CKN(X)
     C                   ENDIF
     C                   READC     APS1112T                               42
     C                   ENDDO
      * DELETE SUBFILE
     C                   MOVE      *ON           *IN79
     C                   WRITE     APC1112T
     C                   MOVE      *OFF          *IN79
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * PROCESS MULTIPLE PAYMENTS ENTRY
      *------------------------------------------------------------------------*
     C     MULPAY        BEGSR
      *
     C                   MOVE      INVMO         CMPMO1
     C                   MOVE      INVDY         CMPDY1
     C                   MOVE      INVCC         CMPCC1
     C                   MOVE      INVYR         CMPYR1
     C                   MOVE      DUEMO         CMPMO2
     C                   MOVE      DUEDY         CMPDY2
     C                   MOVE      DUECC         CMPCC2
     C                   MOVE      DUEYR         CMPYR2
     C                   MOVE      *OFF          *IN91
      *
     C                   Z-ADD     0             RNI
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC1112I
     C                   MOVE      *OFF          *IN70
      * LOAD SUBFILE
     C     MLPAY         IFEQ      *ON
     C                   Z-ADD     1             X
     C     X             DOUGT     20
     C                   ADD       1             RNI
     C     RNI           CHAIN     APS1112I                           42
     C     *IN42         IFEQ      *OFF
     C     X             OCCUR     PAYS
     C                   MOVE      AM12D         AM12I
     C                   MOVE      AM16D         AM16I
     C                   MOVE      AM17D         AM17I
     C                   MOVE      AM18D         AM18I
     C                   MOVE      AM37D         AM37I
     C                   MOVE      AM19D         AM19I
     C                   MOVE      AM27D         AM27I
     C                   MOVE      PAYMOD        PAYMO
     C                   MOVE      PAYDYD        PAYDY
     C                   MOVE      PAYCCD        PAYCC
     C                   MOVE      PAYYRD        PAYYR
     C                   UPDATE    APS1112I
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDIF
      *
     C                   Z-ADD     0             NUMPAY
     C                   MOVE      ' '           WRN               1
     C                   MOVE      'N'           F3WRN
     C                   MOVE      'N'           F12WRN
      * DISPLAY CURRENT MULTIPLE PAYMENTS
     C     DSPI          TAG
     C                   Z-ADD     1             RNI
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVEA     '0111'        *IN(73)
     C                   WRITE     APF1112I
     C                   EXFMT     APC1112I
     C                   MOVEA     '0000'        *IN(73)
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVE      *OFF          *IN91
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPI
     C                   END
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C                   MOVE      'N'           F12WRN                         RESET WARNING
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPI
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO PREVIOUS SCREEN
     C     *IN12         IFEQ      *ON
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C     F12WRN        IFEQ      'N'
     C                   MOVEA     EMS(7)        MSGFLD
     C                   MOVE      'Y'           F12WRN
     C                   GOTO      DSPI
     C                   ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
     C                   MOVE      'N'           F12WRN
      * DIVIDE INTO EQUAL PAYMENTS
     C     *IN51         IFEQ      *ON
      *
     C                   Z-ADD     0             RNI
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC1112I
     C                   MOVE      *OFF          *IN70
      *
     C     APAM04        DIV       NUMPAY        PYAM16
     C                   MVR                     RMN16
     C     APAM14        DIV       NUMPAY        PYAM17
     C                   MVR                     RMN17
     C     APAM13        DIV       NUMPAY        PYAM18
     C                   MVR                     RMN18
     C     APTL03        DIV       NUMPAY        PYAM37
     C                   MVR                     RMN37
     C     APAM05        DIV       NUMPAY        PYAM19
     C                   MVR                     RMN19
     C     APAM26        DIV       NUMPAY        PYAM27
     C                   MVR                     RMN27
      *
     C                   Z-ADD     1             X
     C     X             DOUGT     NUMPAY
     C                   ADD       1             RNI
     C     RNI           CHAIN     APS1112I                           42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      *ZEROS        PAYMO
     C                   MOVE      *ZEROS        PAYDY
     C                   MOVE      *ZEROS        PAYYR
     C                   MOVE      PYAM16        AM16I
     C                   MOVE      PYAM17        AM17I
     C                   MOVE      PYAM18        AM18I
     C                   MOVE      PYAM37        AM37I
     C                   MOVE      PYAM19        AM19I
     C                   MOVE      PYAM27        AM27I
     C     X             IFEQ      1
     C                   ADD       RMN16         AM16I
     C                   ADD       RMN17         AM17I
     C                   ADD       RMN18         AM18I
     C                   ADD       RMN37         AM37I
     C                   ADD       RMN19         AM19I
     C                   ADD       RMN27         AM27I
     C                   ENDIF
     C     AM16I         ADD       AM17I         AM12I
     C                   ADD       AM18I         AM12I
     C                   ADD       AM37I         AM12I
     C                   ADD       AM27I         AM12I
     C                   SUB       AM19I         AM12I
     C                   UPDATE    APS1112I
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
     C                   GOTO      DSPI
     C                   ENDIF
      *------------------------------------------------------------------------*
     C                   Z-ADD     0             PAYTOT
     C                   Z-ADD     0             GRSTOT
     C                   Z-ADD     0             FRTTOT
     C                   Z-ADD     0             TAXTOT
     C                   Z-ADD     0             DSCTOT
     C                   Z-ADD     0             OTCTOT
      *
     C     *IN42         DOUEQ     *ON
     C                   READC     APS1112I                               42
     C     *IN42         IFEQ      *ON
     C     MSGFLD        IFEQ      *BLANKS
     C                   SELECT
     C     FRTTOT        WHENNE    APAM13
     C                   MOVEA     EMS(73)       MSGFLD
     C     TAXTOT        WHENNE    APAM14
     C                   MOVEA     EMS(74)       MSGFLD
     C     DSCTOT        WHENNE    APAM05
     C                   MOVEA     EMS(75)       MSGFLD
     C     OTCTOT        WHENNE    APTL03
     C                   MOVEA     UMS(29)       MSGFLD
     C     PAYTOT        WHENNE    APAM06
     C                   MOVEA     EMS(76)       MSGFLD
     C     GRSTOT        WHENNE    APAM04
     C                   MOVEA     EMS(77)       MSGFLD
     C                   ENDSL
     C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       DSPI
     C     MSGFLD        CABEQ     *BLANKS       ENDPMT
     C                   ENDIF
      *
     C     AM16I         ADD       AM17I         AM12I
     C                   ADD       AM18I         AM12I
     C                   ADD       AM27I         AM12I
     C                   SUB       AM19I         AM12I
     C                   ADD       AM37I         AM12I
      *
     C                   ADD       AM16I         GRSTOT
     C                   ADD       AM18I         FRTTOT
     C                   ADD       AM17I         TAXTOT
     C                   ADD       AM19I         DSCTOT
     C                   ADD       AM12I         PAYTOT
     C                   ADD       AM37I         OTCTOT
      *
     C     AM12I         IFNE      0
     C     PAYDTI        IFEQ      0
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(16)       MSGFLD
     C                   ENDIF
     C                   ELSE
      ** DETERMINE IF VALID DATE
     C                   MOVE      PAYDTI        PDATE
     C                   MOVE      *ZEROS        PJULI
     C                   CALL      'GPR0100'     JULKEY
      *** GET PAYMENT CENTURY
     C                   Z-ADD     1             DATYP
     C                   MOVE      PAYYR         DATE2
     C                   MOVE      DS2000        PM2000                                     ERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      DATE4         PAYCY             4 0
     C                   MOVE      DACEN         PAYCC
      ** DATE INVALID
     C     PJULI         IFEQ      0
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(16)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      ** DATE ENTERED CANNOT BE > NOR < 1 YEAR FROM CURRENT YEAR
     C     PAYCY         IFLT      MIN1
     C     PAYCY         ORGT      PUS1
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     UMS(1)        MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      ** DATE LESS THAN INVOICE DATE / GREATER THAN DUE DATE
     C                   MOVE      PAYMO         CMPMO3
     C                   MOVE      PAYDY         CMPDY3
     C                   MOVE      PAYCC         CMPCC3
     C                   MOVE      PAYYR         CMPYR3
     C     CMPDT3        IFGT      CMPDT2
     C     CMPDT3        ORLT      CMPDT1
     C     MSGFLD        IFEQ      *BLANKS
     C     WRN           ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN91
     C                   MOVEA     EMS(78)       MSGFLD
     C                   MOVE      'Y'           WRN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF                                                  PAYDTI EQ 0
      *
     C                   UPDATE    APS1112I
     C                   MOVE      *OFF          *IN91
     C                   ENDIF                                                  AM12I NE 0
      *
     C                   ENDDO
      *
     C     ENDPMT        TAG
      *
     C                   Z-ADD     1             X
     C     X             DOUGT     20
     C     X             OCCUR     PAYS
     C                   CLEAR                   PAYS
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   Z-ADD     1             RNI
     C     RNI           DOUGT     20
     C     RNI           OCCUR     PAYS
     C     RNI           CHAIN     APS1112I                           42
     C                   MOVE      AM12I         AM12D
     C                   MOVE      AM16I         AM16D
     C                   MOVE      AM17I         AM17D
     C                   MOVE      AM18I         AM18D
     C                   MOVE      AM37I         AM37D
     C                   MOVE      AM19I         AM19D
     C                   MOVE      AM27I         AM27D
     C                   MOVE      PAYMO         PAYMOD
     C                   MOVE      PAYDY         PAYDYD
     C                   MOVE      PAYCC         PAYCCD
     C                   MOVE      PAYYR         PAYYRD
     C                   ADD       1             RNI
     C                   ENDDO
      * DELETE SUBFILE
     C                   MOVE      *ON           *IN79
     C                   WRITE     APC1112I
     C                   MOVE      *OFF          *IN79
      *
     C                   MOVE      *ON           MLPAY
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * PROCESS MULTIPLE G/L ENTRY
      *------------------------------------------------------------------------*
     C     MULGL         BEGSR
      * CLEAR SUBFILE
     C                   Z-ADD     0             RNJ
     C                   Z-ADD     0             SRNJ
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVE      *ON           *IN73
     C                   WRITE     APC1112J
     C                   MOVE      *OFF          *IN73
      * LOAD SUBFILE
     C                   MOVE      *ZEROS        AM04J
     C                   Z-ADD     1             RNS
     C     RNS           CHAIN     APS1112S                           42
     C     *IN42         DOWEQ     *OFF
     C                   ADD       AM15S         AM04J
     C                   MOVE      AM15S         AM15J
     C                   MOVE      GNO06S        GNO06J
     C                   MOVE      GNO02S        GNO02J
     C                   MOVE      GNO03S        GNO03J
     C                   MOVE      GNO04S        GNO04J
     C                   MOVE      *BLANKS       GDN03J
     C     GLKEYJ        CHAIN     GLFMSTR                            48
     C     *IN48         IFEQ      *OFF
     C                   MOVE      GLDN03        GDN03J
     C                   ENDIF
     C                   ADD       1             RNJ
     C                   WRITE     APS1112J
     C                   ADD       1             RNS
     C     RNS           CHAIN     APS1112S                           42
     C                   ENDDO
      *
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C                   MOVE      'N'           F12WRN                         RESET WARNING
ET   C                   EVAL      AMT0WRN = *OFF
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
      * DISPLAY SUBFILE
     C     DSPJ          TAG
     C     SRNJ          IFNE      0
     C                   Z-ADD     SRNJ          RNJ
     C                   ELSE
     C     RNJ           IFNE      0
     C                   Z-ADD     1             RNJ
     C                   ENDIF
     C                   ENDIF
     C     RNJ           IFEQ      0
     C                   MOVEA     '01'          *IN(75)
     C                   ELSE
     C                   MOVEA     '11'          *IN(75)
     C                   ENDIF
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVE      *ON           *IN74
     C                   WRITE     APF1112J
     C                   EXFMT     APC1112J
     C                   MOVEA     '000'         *IN(74)
     C                   Z-ADD     SCRRN         SRNJ                                       REC
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
     C                   MOVE      ' '           CHANGE            1
     C                   MOVE      *ZEROS        AM04J
      * PROMPT
     C     *IN04         IFEQ      *ON
     C                   EXSR      @PRMPT
     C                   ENDIF
     C     *IN04         CABEQ     *ON           DSPJ
     C                   EXSR      @CLCSR
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPJ
     C                   END
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C                   MOVE      'N'           F12WRN                         RESET WARNING
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPJ
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO INVOICE HEADER
     C     *IN12         IFEQ      *ON
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C     F12WRN        IFEQ      'N'
     C                   MOVEA     EMS(7)        MSGFLD
     C                   MOVE      'Y'           F12WRN
     C                   GOTO      DSPJ
     C                   ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
     C                   MOVE      'N'           F12WRN
      *------------------------------------------------------------------------*
      * STEP 2. * EDITING
      *------------------------------------------------------------------------*
      * PROCESS SUBFILE
ET   C                   EVAL      AMT0FOUND = *OFF
     C     *IN42         DOUEQ     *ON
     C                   READC     APS1112J                               42
     C     *IN42         IFEQ      *ON
     C     MSGFLD        IFEQ      *BLANKS
     C     AM04J         IFNE      APAM04
     C                   MOVEA     EMS(55)       MSGFLD
     C                   ENDIF
     C                   ENDIF
ET    * If total entered <> gross purchase amount
ET    * reset the amount zero warning indicator...
ET   C                   IF        AM04J <> APAM04
ET   C                   EVAL      AMT0WRN = *OFF
ET   C                   ENDIF
ET    * If account entry with a zero amount was found
ET    * AND the total entered = gross purchase amount
ET    * display warning that entries with zero $ will be removed...
ET   C                   IF        AM04J = APAM04
ET   C                             and MSGFLD = *BLANKS
ET   C                             and AMT0WRN = *OFF
ET   C                             and AMT0FOUND = *ON
ET   C                   EVAL      MSGFLD = 'WARNING! Entries with zero +
ET   C                             amounts will be removed.'
ET   C                   EVAL      AMT0WRN = *ON
ET   C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       DSPJ
     C     CHANGE        CABEQ     'Y'           DSPJ
     C                   ELSE
      * ACCOUNT NUMBER OR AMOUNT CHANGED
     C     GLNOJ         IFNE      SVNOJ
     C     AM15J         ORNE      SVAMJ
     C                   MOVE      'Y'           CHANGE                                     #
     C                   END
   ET * ACCOUNT NUMBER AND AMOUNT REQUIRED
   ETC*    AM15J         IFNE      0
   ETC*    GLNOJ         ANDEQ     0
   ETC*    AM15J         OREQ      0
   ETC*    GLNOJ         ANDNE     0
   ETC*                  MOVE      *ON           *IN91
   ETC*                  MOVE      *ON           *IN93
   ETC*    MSGFLD        IFEQ      *BLANKS
   ETC*                  Z-ADD     RNJ           SRNJ
   ETC*                  MOVEA     EMS(54)       MSGFLD
   ETC*                  ENDIF
   ETC*                  ENDIF
EU    * G/L number required if amount entered...
EU   C     AM15J         IFNE      0
EU   C     GLNOJ         ANDEQ     0
EU   C                   MOVE      *ON           *IN91
EU   C                   MOVE      *ON           *IN93
EU   C     MSGFLD        IFEQ      *BLANKS
EU   C                   Z-ADD     RNJ           SRNJ
EU   C                   EVAL      MSGFLD = 'Account number required.'
EU   C                   ENDIF
EU   C                   ENDIF
ET    * If account entry has zero amount
ET    * turn on the amount zero warning inticator...
ET   C                   IF        AM15J = *ZEROS
ET   C                             and GLNOJ <> *ZEROS
ET   C                   EVAL      AMT0FOUND = *ON
ET   C                   ENDIF
      * VALID ACCOUNT NUMBER
     C                   MOVE      *BLANKS       GDN03J
     C     GLNOJ         IFNE      0
     C     GLKEYJ        CHAIN     GLFMSTR                            49
     C     *IN49         IFEQ      *ON
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNJ           SRNJ
     C                   MOVEA     EMS(24)       MSGFLD
     C                   ENDIF
     C                   ELSE
     C                   MOVE      GLDN03        GDN03J
      ** OPEN ACCOUNT
     C     GLCD15        IFNE      'Y'
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNJ           SRNJ
     C                   MOVEA     UMS(28)       MSGFLD
     C                   ENDIF
     C                   ELSE
EN    * REBATE CREDIT
EN   C                   IF        REB_CR = 'Y' AND
EN   C                             GLNOJ2 <> RBDGL2
EN   C                             AND GLNOJ2 <> RBDGL2_S
EN   C                   MOVE      *ON           *IN91
EN   C     MSGFLD        IFEQ      *BLANKS
EN   C                   EVAL      MSGFLD = ('Rebates due account required.')
EN   C                   ENDIF
EN   C                   ELSE
      * A/P TRADE ACCOUNT CANNOT BE USED
     C                   MOVE      '010'         PSTTYP
     C     GRPKY         CHAIN     GLFMGRP                            48
     C     *IN48         DOWEQ     *OFF
     C     GLNO33        IFEQ      GNO03J
     C     GLNO34        ANDEQ     GNO04J
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNJ           SRNJ
     C                   MOVEA     UMS(21)       MSGFLD
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C     GRPKY         READE     GLFMGRP                                48
     C                   ENDDO
      * A/R TRADE ACCOUNT CANNOT BE USED
     C                   MOVE      '220'         PSTTYP
     C     GRPKY         CHAIN     GLFMGRP                            48
     C     *IN48         DOWEQ     *OFF
     C     GLNO33        IFEQ      GNO03J
     C     GLNO34        ANDEQ     GNO04J
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNJ           SRNJ
     C                   MOVEA     UMS(22)       MSGFLD
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C     GRPKY         READE     GLFMGRP                                48
     C                   ENDDO
      ** ACCRUED INVENTORY PAYABLES NOT ALLOWED
     C     GLNOJ2        IFEQ      AIPGL2
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNJ           SRNJ
     C                   MOVEA     EMS(81)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      ** VENDOR RETURN RECEIVABLE NOT ALLOWED
     C     GLNOJ2        IFEQ      VRRGL2
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNJ           SRNJ
     C                   MOVEA     EMS(92)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      ** DEPARTMENT NUMBER REQUIRED
     C     TBMEDP        IFEQ      'Y'
     C     GNO02J        ANDEQ     0
     C                   MOVE      *ON           *IN92
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNJ           SRNJ
     C                   MOVEA     EMS(26)       MSGFLD
     C                   ENDIF
     C                   ENDIF                                                  TBMEDP EQ Y
EN   C                   ENDIF                                                  TBMEDP EQ Y
     C                   ENDIF                                                  GLCD15 NE Y
     C                   ENDIF                                                  IN40 EQ ON
     C                   ENDIF                                                  GLNOJ NE 0
      * UPDATE SUBFILE
     C                   ADD       AM15J         AM04J
     C                   MOVE      GLNOJ         SVNOJ
     C                   MOVE      AM15J         SVAMJ
     C                   UPDATE    APS1112J
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
     C                   ENDIF
     C                   ENDDO
      ** WRITE TO SUBFILE 'S'
     C                   Z-ADD     0             RNS
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC1112S
     C                   MOVE      *OFF          *IN70
      *
     C                   Z-ADD     1             RNJ
     C     RNJ           CHAIN     APS1112J                           42
     C     *IN42         DOWEQ     *OFF
     C     GLNOJ         IFNE      0
     C                   MOVE      *ON           MLGL
     C                   ADD       1             RNS
     C     RNS           CHAIN     APS1112S                           43
     C     *IN43         IFEQ      *OFF
ET   C     AM15J         ANDNE     *ZEROS
     C                   MOVE      GNO06J        GNO06S
     C                   MOVE      GNO02J        GNO02S
     C                   MOVE      GNO03J        GNO03S
     C                   MOVE      GNO04J        GNO04S
     C                   MOVE      AM15J         AM15S
     C                   UPDATE    APS1112S
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             RNJ
     C     RNJ           CHAIN     APS1112J                           42
     C                   ENDDO
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * LOAD MULTILPE G/L
      *------------------------------------------------------------------------*
     C     LOADGL        BEGSR
      * CLEAR SUBFILE
     C                   Z-ADD     0             RNS
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC1112S
     C                   MOVE      *OFF          *IN70
      * LOAD SUBFILE
     C     NO01C         CHAIN     APFMVGL                            48
     C     *IN48         DOWEQ     *OFF
     C                   MOVE      *ON           MLGL
     C                   ADD       1             RNS
     C     RNS           CHAIN     APS1112S                           42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      *ZEROS        AM15S
     C                   MOVE      GLNO06        GNO06S
     C                   MOVE      GLNO02        GNO02S
     C                   MOVE      GLNO03        GNO03S
     C                   MOVE      GLNO04        GNO04S
     C                   UPDATE    APS1112S
     C                   ENDIF
     C     NO01C         READE     APFMVGL                                48
     C                   ENDDO
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * PROCESS OTHER CHARGES ENTRY
      *------------------------------------------------------------------------*
     C     MULOC         BEGSR
      *
     C     RELDOC        TAG
      * CLEAR SUBFILE
     C                   Z-ADD     0             RNP
     C                   Z-ADD     0             SRNP
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC1112P
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *ZEROS        TL03P
      * LOAD SUBFILE
      * LOAD OTHER CHARGES MATCHED TO VENDOR RETURN FIRST
     C                   Z-ADD     1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C     *IN42         DOWEQ     *OFF
     C     GLNOS3        IFNE      0
     C                   ADD       1             RNP
     C     RNP           CHAIN     APS1112P                           43
     C     *IN43         IFEQ      *OFF
     C                   ADD       AM35S3        TL03P
     C                   MOVE      NO27S3        NO27P
     C                   MOVE      CD53S3        CD53P
     C                   MOVE      AM35S3        AM35P
     C                   MOVE      DN06S3        DN06P
     C                   MOVE      NO06S3        NO06P
     C                   MOVE      NO02S3        NO02P
     C                   MOVE      NO03S3        NO03P
     C                   MOVE      NO04S3        NO04P
     C                   MOVE      AMVRS3        AMVRP
     C                   MOVE      AM52S3        AM52P
     C                   MOVE      AM52S3        ORAM52
     C                   MOVE      CD49S3        CD49P
     C                   MOVE      CD50S3        CD50P
     C                   MOVE      CD51S3        ORCD51
     C                   MOVE      *BLANKS       DN03P
     C     GLKEYP        CHAIN     GLFMSTR                            48
     C     *IN48         IFEQ      *OFF
     C                   MOVE      GLDN03        DN03P
     C                   ENDIF
     C     CD26K         IFEQ      'I'
     C     CD26K         ORNE      'I'
     C     SKIPPO        ANDEQ     'Y'
     C                   MOVE      *ON           *IN28
     C                   MOVE      *ON           SVIN28
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          SVIN55
     C                   ELSE
     C                   MOVE      *OFF          *IN28
     C                   MOVE      *OFF          SVIN28
     C                   MOVE      *ON           *IN55
     C                   MOVE      *ON           SVIN55
     C                   ENDIF
     C                   MOVE      'N'           WRNFLG
     C                   UPDATE    APS1112P
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C                   ENDDO
      * LOAD OTHER CHARGES NOT MATCHED TO VENDOR RETURN LAST
     C                   Z-ADD     1             RNS2
     C     RNS2          CHAIN     APS112S2                           42
     C     *IN42         DOWEQ     *OFF
     C                   ADD       1             RNP
     C     RNP           CHAIN     APS1112P                           43
     C     *IN43         IFEQ      *OFF
     C     GLNOS2        IFNE      0
     C                   ADD       AM35S2        TL03P
     C                   MOVE      AM35S2        AM35P
     C                   MOVE      DN06S2        DN06P
     C                   MOVE      NO06S2        NO06P
     C                   MOVE      NO02S2        NO02P
     C                   MOVE      NO03S2        NO03P
     C                   MOVE      NO04S2        NO04P
     C                   MOVE      *ZEROS        NO27P
     C                   MOVE      *BLANKS       CD53P
     C                   MOVE      *ZEROS        AM52P
     C                   MOVE      *ZEROS        AMVRP
     C                   MOVE      *BLANKS       CD49P
     C                   MOVE      *BLANKS       CD50P
     C                   MOVE      *BLANKS       DN03P
     C     GLKEYP        CHAIN     GLFMSTR                            48
     C     *IN48         IFEQ      *OFF
     C                   MOVE      GLDN03        DN03P
     C                   ENDIF                                                  IN48 EQ OFF
     C                   ENDIF                                                  GLNOS2 NE 0
     C                   MOVE      *ON           *IN28
     C                   MOVE      *ON           SVIN28
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          SVIN55
     C                   MOVE      'N'           WRNFLG
     C                   UPDATE    APS1112P
     C                   ENDIF
     C                   ADD       1             RNS2
     C     RNS2          CHAIN     APS112S2                           42
     C                   ENDDO
      *
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C                   MOVE      'N'           F12WRN
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
     C                   MOVE      *OFF          *IN95
     C                   MOVE      *OFF          *IN96
      * DISPLAY SUBFILE
     C     DSPP          TAG
     C     SRNP          IFNE      0
     C                   Z-ADD     SRNP          RNP
     C                   ELSE
     C                   Z-ADD     1             RNP
     C                   ENDIF
     C     RNP           IFEQ      0
     C                   MOVEA     '01'          *IN(75)
     C                   ELSE
     C                   MOVEA     '11'          *IN(75)
     C                   ENDIF
     C                   MOVE      *ON           *IN74
     C     CD26K         IFEQ      'I'
     C     CD26K         ORNE      'I'
     C     SKIPPO        ANDEQ     'Y'
     C                   MOVE      *ON           *IN28
     C                   ELSE
     C                   MOVE      *OFF          *IN28
     C                   ENDIF
     C                   MOVE      *OFF          *IN79                          SFLDLT
     C                   WRITE     APF1112P
     C                   EXFMT     APC1112P
     C                   MOVEA     '000'         *IN(74)
     C                   Z-ADD     SCRRN         SRNP                                       REC
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
     C                   MOVE      *OFF          *IN95
     C                   MOVE      *OFF          *IN96
     C                   MOVE      *OFF          *IN97
     C                   MOVE      ' '           CHANGE            1
     C                   MOVE      *ZEROS        TL03P
      * PROMPT
     C     *IN04         IFEQ      *ON
     C                   EXSR      @PRMPT
     C                   ENDIF
     C     *IN04         CABEQ     *ON           DSPP
     C                   EXSR      @CLCSR
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPP
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C                   MOVE      'N'           F12WRN                         RESET WARNING
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPP
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO INVOICE HEADER
     C     *IN12         IFEQ      *ON
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C     F12WRN        IFEQ      'N'
     C                   MOVEA     EMS(7)        MSGFLD
     C                   MOVE      'Y'           F12WRN
     C                   GOTO      DSPP
     C                   ENDIF
     C                   GOTO      DSPC
     C                   ENDIF
     C                   MOVE      'N'           F12WRN
      * SELECT OTHER CHARGES
     C     *IN07         IFEQ      *ON
      ** SAVE EXISTING OTHER CHARGES
     C                   Z-ADD     0             RNS2
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC112S2
     C                   MOVE      *OFF          *IN70
      *
     C                   Z-ADD     0             RNS3
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC112S3
     C                   MOVE      *OFF          *IN70
      *
     C                   Z-ADD     1             RNP
     C     RNP           CHAIN     APS1112P                           42
     C     *IN42         DOWEQ     *OFF
     C     GLNOP         IFNE      0
     C     CD53P         IFEQ      *BLANKS
     C                   ADD       1             RNS2
     C     RNS2          CHAIN     APS112S2                           43
     C     *IN43         IFEQ      *OFF
     C                   MOVE      NO06P         NO06S2
     C                   MOVE      NO02P         NO02S2
     C                   MOVE      NO03P         NO03S2
     C                   MOVE      NO04P         NO04S2
     C                   MOVE      AM35P         AM35S2
     C                   MOVE      DN06P         DN06S2
     C                   UPDATE    APS112S2
     C                   ENDIF                                                  IN43 EQ OFF
     C                   ELSE
     C                   ADD       1             RNS3
     C     RNS3          CHAIN     APS112S3                           43
     C     *IN43         IFEQ      *OFF
     C                   MOVE      AM35P         AM35S3
     C                   MOVE      CD53P         CD53S3
     C                   MOVE      NO27P         NO27S3
     C                   MOVE      DN06P         DN06S3
     C                   MOVE      CD50P         CD50S3
     C                   MOVE      CD49P         CD49S3
     C                   UPDATE    APS112S3
     C                   ENDIF                                                  IN43 EQ OFF
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             RNP
     C     RNP           CHAIN     APS1112P                           42
     C                   ENDDO
      *
     C                   MOVE      *OFF          EXIT
     C     NUMRTN        IFEQ      1
     C                   Z-ADD     VNDRTN        OCRTN
     C                   CALL      'APR1092'     PL1092
     C                   ELSE
     C                   MOVE      'O'           WHRFRM
     C                   EXSR      DSPVR
     C                   ENDIF
     C                   MOVE      'N'           CLCOC
     C                   EXSR      PMTCH
     C                   EXSR      LOADOC
     C                   GOTO      RELDOC
     C                   ENDIF
      *------------------------------------------------------------------------*
      * STEP 2. * EDITING
      *------------------------------------------------------------------------*
      * PROCESS SUBFILE
     C     *IN42         DOUEQ     *ON
     C                   READC     APS1112P                               42
     C     *IN42         IFEQ      *ON
     C     MSGFLD        CABNE     *BLANKS       DSPP
      * CHECK FOR VARIANCE IF MATCHED TO A VENDOR RETURN
      * DISPLAY WARNING MESSAGE IF FOUND
     C                   Z-ADD     1             RNP
     C     RNP           CHAIN     APS1112P                           42
     C     *IN42         DOWEQ     *OFF
     C     GLNOP         IFNE      0
     C     CD53P         ANDNE     *BLANKS
     C     AMVRP         ANDNE     0
     C     WRNFLG        ANDNE     'Y'
     C                   MOVE      'Y'           WRNFLG
     C                   MOVE      *ON           *IN93
     C                   MOVE      *ON           *IN97
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(98)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      SVIN28        *IN28
     C                   MOVE      SVIN55        *IN55
     C                   UPDATE    APS1112P
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN97
     C                   ADD       1             RNP
     C     RNP           CHAIN     APS1112P                           42
     C                   ENDDO
     C     MSGFLD        CABNE     *BLANKS       DSPP
     C     CHANGE        CABEQ     'Y'           DSPP
      *_*_*_*_*_*_*_*_*_*_
     C                   ELSE
      * ACCOUNT NUMBER OR AMOUNT CHANGED
     C     GLNOP         IFNE      SVNOP
     C     AM35P         ORNE      SVAMP
     C     CD53P         ORNE      SVCD53
     C     CD49P         ORNE      SVCD49
     C     CD50P         ORNE      SVCD50
     C     DN06P         ORNE      SVDN06
     C                   MOVE      'Y'           CHANGE                                     #
     C                   ENDIF
      * AMOUNT AND ACCOUNT NUMBER REQUIRED
     C     AM35P         IFNE      0
     C     GLNOP         ANDEQ     0
     C     AM35P         OREQ      0
     C     GLNOP         ANDNE     0
     C                   MOVE      *ON           *IN91
     C                   MOVE      *ON           *IN93
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNP           SRNP
     C                   MOVEA     EMS(54)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      * INVALID ACCOUNT NUMBER
     C                   MOVE      *BLANKS       DN03P
     C     GLNOP         IFNE      0
     C     GLKEYP        CHAIN     GLFMSTR                            49
     C     *IN49         IFEQ      *ON
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNP           SRNP
     C                   MOVEA     EMS(24)       MSGFLD
     C                   ENDIF
     C                   ELSE
     C                   MOVE      GLDN03        DN03P
      * VENDOR RETURN RECEIVABLE ACCOUNT NOT ALLOWED FOR NON VEND RTN
     C     GLNOP2        IFNE      0
     C     GLNOP2        ANDEQ     VRRGL2
     C     NO27P         ANDEQ     0
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     UMS(34)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      * ACCRUED INVENTORY PAYABLE ACCOUNT NOT ALLOWED FOR OTHER CHGS
     C     GLNOP2        IFNE      0
     C     GLNOP2        ANDEQ     AIPGL2
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     UMS(35)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      ** OPEN ACCOUNT
     C     GLCD15        IFNE      'Y'
     C     POCD01        ANDEQ     'O'
     C     GLCD15        ORNE      'Y'
     C     POCD01        ANDEQ     'F'
     C     GLCD15        ORNE      'Y'
     C     POCD01        ANDNE     'O'
     C     POCD01        ANDNE     'F'
     C     GLNOP2        ANDNE     VRRGL2
     C     GLCD15        ORNE      'Y'
     C     SKIPPO        ANDEQ     'Y'
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNP           SRNP
     C                   MOVEA     UMS(28)       MSGFLD
     C                   ENDIF
     C                   ELSE
      ** DEPARTMENT NUMBER REQUIRED
     C     TBMEDP        IFEQ      'Y'
     C     NO02P         ANDEQ     0
     C                   MOVE      *ON           *IN92
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNP           SRNP
     C                   MOVEA     EMS(26)       MSGFLD
     C                   ENDIF
     C                   ENDIF                                                  TBMEDP EQ Y
     C                   ENDIF                                                  GLCD15 NE Y
     C                   ENDIF                                                  IN49 EQ ON
     C                   ENDIF                                                  GLNOP NE 0
      * CLEAR VENDOR RETURN INFO IF AMOUNT AND G/L ACCOUNT CLEARED
     C     NO27P         IFNE      0
     C     GLNOP         ANDEQ     0
     C     AM35P         ANDEQ     0
     C                   MOVE      *BLANKS       CD53P
     C                   MOVE      *BLANKS       DN06P
     C                   Z-ADD     0             AM52P
     C                   MOVE      *BLANKS       CD50P
     C                   Z-ADD     0             AMVRP
     C                   MOVE      *BLANKS       CD49P
     C                   Z-ADD     0             NO27P
     C                   MOVE      *ON           SVIN28
     C                   MOVE      *OFF          SVIN55
     C                   MOVE      'N'           WRNFLG
     C                   ENDIF                                                  NO27P NE 0
      * IF MATCHED TO VENDOR RETURN
      * EDIT G/L ACCOUNT = VENDOR RETURN RECEIVABLE
     C     NO27P         IFNE      0
     C     GLNOP2        IFNE      VRRGL2
     C     AM35P         ANDNE     0
     C                   MOVE      *ON           *IN91
     C                   MOVE      *ON           *IN94
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNP           SRNP
     C                   MOVEA     EMS(97)       MSGFLD
     C                   ENDIF
     C                   ENDIF                                                  GLNOP NE VRRGL
      * EDIT SPLIT CODE
     C     CD50P         IFNE      'S'
     C     CD50P         ANDNE     ' '
     C                   MOVE      *ON           *IN95
     C     MSGFLD        IFEQ      *BLANKS
     C                   Z-ADD     RNP           SRNP
     C                   MOVEA     EMS(95)       MSGFLD
     C                   ENDIF
     C                   ENDIF                                                  CD50P NE S
      * RECALCULATE AM52P FROM OTHER CHARGE AMOUNT IF SPLIT LINE
     C     AM35P         IFNE      AM52P
     C     CD50P         IFEQ      'S'
     C                   Z-ADD     AM35P         AM52P
     C                   ELSE
     C     CD50P         IFEQ      ' '
     C     SVCD50        ANDEQ     'S'
     C                   Z-ADD     ORAM52        AM52P
     C                   ENDIF
     C                   ENDIF                                                  CD50P EQ S
     C                   ENDIF                                                  AM35P LE AM52P
     C                   ENDIF                                                  NO27P NE 0
      *-----------
     C                   ADD       AM35P         TL03P
     C                   MOVE      GLNOP         SVNOP
     C                   MOVE      AM35P         SVAMP
     C                   MOVE      CD53P         SVCD53
     C                   MOVE      CD49P         SVCD49
     C                   MOVE      CD50P         SVCD50
     C                   MOVE      DN06P         SVDN06
     C                   MOVE      SVIN28        *IN28
     C                   MOVE      SVIN55        *IN55
     C     AM35P         SUB       AM52P         AMVRP
     C                   UPDATE    APS1112P
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
     C                   MOVE      *OFF          *IN95
     C                   MOVE      *OFF          *IN96
     C                   MOVE      *OFF          *IN97
     C                   ENDIF
     C                   ENDDO
      ** REMOVE LAST MATCHING IN THE MATCH WORK FILE
     C                   MOVEA     *ZEROS        VNB
     C                   MOVEA     *ZEROS        VCB
     C                   Z-ADD     0             CNTLIN            7 0
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFWMTH4                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MHNO27        SAVRTN
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
     C                   ADD       1             CNTLIN
      *** REMOVE LAST MATCHING IN THE VENDOR RETURN OTHER CHARGE DETAIL
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VROKEY        CHAIN     POFTVRO                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
      *** DO NOT RELEASE IF ORIGINAL MATCH
     C     INM9K1        CHAIN(N)  APFTINM9                           49
     C     *IN49         IFEQ      *ON
     C                   MOVE      *ZEROS        PONO24
     C                   ENDIF
     C                   SUB       MHAM32        POAM51                         MATCHED
     C                   ADD       MHAM32        POAM52                         UNMATCHED
     C                   EXCEPT    UPDVRO
     C                   ENDIF
     C                   DELETE    APFWMTH4
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFWMTH4                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      * REMOVE MAINTENANCE LOCK FLAG IN VENDOR RETURN HEADER
     C     MHNO27        IFNE      SAVRTN
     C     *IN45         OREQ      *ON
      *** DO NOT UPDATE HEADER IF IN CURRENT MATCH
     C     INM9K2        SETLL     APFWMTH5                               49
     C     *IN49         IFEQ      *OFF
      *** DO NOT UPDATE HEADER IF IN ORIGINAL MATCH
     C     INM9K2        SETLL     APFTINM9                               49
     C                   ENDIF
     C     *IN49         IFEQ      *OFF
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRTN        CHAIN     POFTVRH                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POFL06
     C                   EXCEPT    UPDVRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  IN49 EQ ON
     C                   Z-ADD     1             V                 4 0
     C     0000000       LOOKUP    VNB(V)                                 44
     C     *IN44         IFEQ      *ON
     C                   Z-ADD     SAVRTN        VNB(V)
     C                   Z-ADD     CNTLIN        VCB(V)
     C                   ENDIF
     C                   Z-ADD     MHNO27        SAVRTN
     C                   Z-ADD     0             CNTLIN
     C                   ENDIF
     C                   ENDDO
      ** WRITE TO SUBFILE 'S'
      ** WRITE TO MATCH WORK FILE
     C                   Z-ADD     0             RNS2
     C                   Z-ADD     0             RNS3
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC112S2
     C                   WRITE     APC112S3
     C                   MOVE      *OFF          *IN70
      *
     C                   MOVE      'N'           OTHCHG
     C                   Z-ADD     1             RNP
     C     RNP           CHAIN     APS1112P                           42
     C     *IN42         DOWEQ     *OFF
     C     AM35P         IFNE      0
     C     GLNOP         ANDNE     0
      * SET OTHER CHARGE FLAG
     C                   MOVE      'Y'           OTHCHG
     C     CD53P         IFEQ      *BLANKS
     C                   ADD       1             RNS2
     C     RNS2          CHAIN     APS112S2                           43
     C     *IN43         IFEQ      *OFF
     C                   MOVE      NO06P         NO06S2
     C                   MOVE      NO02P         NO02S2
     C                   MOVE      NO03P         NO03S2
     C                   MOVE      NO04P         NO04S2
     C                   MOVE      AM35P         AM35S2
     C                   MOVE      DN06P         DN06S2
     C                   UPDATE    APS112S2
     C                   ENDIF                                                  IN43 EQ OFF
     C                   ELSE
     C                   ADD       1             RNS3
     C     RNS3          CHAIN     APS112S3                           43
     C     *IN43         IFEQ      *OFF
     C                   MOVE      NO27P         NO27S3
     C                   MOVE      CD53P         CD53S3
     C                   MOVE      DN06P         DN06S3
     C                   MOVE      NO06P         NO06S3
     C                   MOVE      NO02P         NO02S3
     C                   MOVE      NO03P         NO03S3
     C                   MOVE      NO04P         NO04S3
     C                   MOVE      AM35P         AM35S3
     C                   MOVE      AMVRP         AMVRS3
     C                   MOVE      AM52P         AM52S3
     C                   MOVE      ORAM52        ORAMS3
     C                   MOVE      CD49P         CD49S3
     C                   MOVE      CD50P         CD50S3
     C                   MOVE      ORCD51        CD51S3
     C                   UPDATE    APS112S3
     C                   ENDIF                                                  IN43 EQ OFF
      ** WRITE CURRENT MATCHING TO MATCH WORK FILE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VROKY3        CHAIN     POFTVRO                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C     PONO24        IFEQ      0
     C     POAM52        ANDNE     0
     C     PONO24        OREQ      NO20C
     C                   MOVE      ORCD51        MHSEL
     C                   Z-ADD     NO20C         MHNO20
     C                   Z-ADD     0             MHNO01
     C                   Z-ADD     0             MHNO05
     C                   Z-ADD     0             MHNO19
     C                   MOVE      *BLANKS       MHCD01
     C                   Z-SUB     AM35P         MHAM29                         PRC UNT PRC
     C                   Z-SUB     AM35P         MHAM30                         STK UNT PRC
     C                   Z-SUB     AM35P         MHAM31                         EXTENDED AMT
     C                   Z-SUB     AM52P         MHAM32                         OPEN AMT @ MTH
     C                   Z-ADD     1             MHQY03                         STOCKING
     C                   Z-ADD     1             MHQY04                         ORDERED
     C                   Z-ADD     1             MHQY05                         OPEN QTY @ MTH
     C                   MOVE      CD49P         MHCD49
     C                   MOVE      CD50P         MHCD50
     C                   Z-ADD     NO27P         MHNO27
     C                   Z-ADD     0             MHNO32
     C                   MOVE      CD53P         MHCD53
     C                   MOVE      DN06P         MHDN06
     C                   WRITE     APFWMTH
      ** UPDATE VENDOR RETURN OTHER CHARGE
     C                   Z-ADD     NO20C         PONO24
     C                   SUB       MHAM32        POAM52                         UNMATCHED
     C                   ADD       MHAM32        POAM51                         MATCHED
     C                   EXCEPT    UPDVRO
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  PONO24 EQ 0
      *
     C                   ENDIF                                                  CD53P EQ BLANKS
     C                   ENDIF
     C                   ADD       1             RNP
     C     RNP           CHAIN     APS1112P                           42
     C                   ENDDO
      ** DETERMINE IF MATCH SELECTION CODE NEED TO BE CHANGED
     C                   MOVEA     *ZEROS        VNA
     C                   MOVEA     *ZEROS        VCA
     C                   Z-ADD     0             CNTLIN            7 0
     C     NO20C         CHAIN(N)  APFWMTH4                           45
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MHNO27        SAVRTN
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
     C                   ADD       1             CNTLIN
     C     NO20C         READE(N)  APFWMTH4                               45
     C     MHNO27        IFNE      SAVRTN
     C     *IN45         OREQ      *ON
     C                   Z-ADD     1             V                 4 0
     C     0000000       LOOKUP    VNA(V)                                 44
     C     *IN44         IFEQ      *ON
     C                   Z-ADD     SAVRTN        VNA(V)
     C                   Z-ADD     CNTLIN        VCA(V)
     C                   ENDIF
     C                   Z-ADD     MHNO27        SAVRTN
     C                   Z-ADD     0             CNTLIN
     C                   ENDIF
     C                   ENDDO
      *
     C                   Z-ADD     1             V
     C     V             DOWLT     1000
     C     VNA(V)        IFNE      0
     C                   Z-ADD     VNA(V)        SAVRTN
     C                   Z-ADD     1             VB                4 0
     C     SAVRTN        LOOKUP    VNB(VB)                                44
     C     *IN44         IFEQ      *ON
     C     VCA(V)        IFLT      VCB(VB)
      ** UPDATE MATCH SELECTION CODE IN MATCH WORK FILE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     INM9K2        CHAIN     APFWMTH5                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         DOWEQ     *OFF
     C                   MOVE      'L'           MHSEL
     C                   EXCEPT    UPDSEL
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     INM9K2        READE     APFWMTH5                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             V
     C                   ENDDO
      *
     C                   Z-ADD     1             V
     C     V             DOWLT     1000
     C     VNB(V)        IFNE      0
     C                   Z-ADD     VNB(V)        SAVRTN
     C                   Z-ADD     1             VA                4 0
     C     SAVRTN        LOOKUP    VNA(VA)                                44
     C     *IN44         IFEQ      *OFF
      ** UPDATE MATCH SELECTION CODE IN MATCH WORK FILE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     INM9K2        CHAIN     APFWMTH5                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         DOWEQ     *OFF
     C                   MOVE      'L'           MHSEL
     C                   EXCEPT    UPDSEL
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     INM9K2        READE     APFWMTH5                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             V
     C                   ENDDO
      ** UPDATE AMOUNTS
     C                   Z-ADD     TL03P         APTL03                         OTHER CHARGE
     C     APAM04        ADD       APAM14        APAM06                         GROSS+TAX
     C                   ADD       APAM13        APAM06                         + PPD FRT
     C                   ADD       APAM26        APAM06                         + FRT OUT
     C                   ADD       APTL03        APAM06                         + OTHER CHARGES
¢H   C                   IF        APAM04 > *Zero
     C                   SUB       APAM05        APAM06                         - DISC = NET
¢H   C                   ELSE
¢H   C                   z-add     *zero         APAM05                         clear disc on credt
¢H   C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      * LOAD OTHER CHARGES
      *------------------------------------------------------------------------*
     C     LOADOC        BEGSR
      *
     C                   Z-ADD     0             RNS3
     C                   MOVE      *ON           *IN70
     C                   WRITE     APC112S3
     C                   MOVE      *OFF          *IN70
      *
     C                   Z-ADD     0             LDTL03
     C     NO20C         CHAIN     APFWMTH4                           48
     C     *IN48         IFEQ      *OFF
     C                   MOVE      'Y'           OTHCHG
     C                   ENDIF
     C     *IN48         DOWEQ     *OFF
     C                   ADD       1             RNS3
     C     RNS3          CHAIN     APS112S3                           49
     C     *IN49         IFEQ      *OFF
     C                   MOVE      MHNO27        NO27S3
     C                   MOVE      MHCD53        CD53S3
     C                   MOVE      MHDN06        DN06S3
     C                   Z-SUB     MHAM31        AM35S3
     C                   Z-SUB     MHAM32        AM52S3
     C                   Z-SUB     MHAM32        ORAMS3
     C                   Z-ADD     0             OCVAR
     C     MHAM31        SUB       MHAM32        OCVAR
     C                   Z-SUB     OCVAR         OCVAR
     C                   MOVE      OCVAR         AMVRS3
     C                   MOVE      MHCD49        CD49S3
     C                   MOVE      MHCD50        CD50S3
     C                   MOVE      MHSEL         CD51S3
     C                   MOVE      VRNO36        NO06S3
     C                   MOVE      VRNO32        NO02S3
     C                   MOVE      VRNO33        NO03S3
     C                   MOVE      VRNO34        NO04S3
     C     VRRSUM        IFEQ      'B'
     C                   MOVE      APBR#C        NO06S3
     C                   ENDIF
     C                   UPDATE    APS112S3
     C                   ADD       AM35S3        LDTL03
     C                   ENDIF
     C     NO20C         READE     APFWMTH4                               48
     C                   ENDDO
      * RECALCULATE TOTAL OTHER CHARGES
     C     CLCOC         IFEQ      'Y'
      * GET TOTAL OF OTHER CHARGES NOT MATCHED TO VENDOR RETURN
     C                   Z-ADD     1             RNS2
     C     RNS2          CHAIN     APS112S2                           42
     C     *IN42         DOWEQ     *OFF
     C     GLNOS2        IFNE      0
     C                   MOVE      'Y'           OTHCHG
     C                   ADD       AM35S2        LDTL03
     C                   ENDIF                                                  GLNOS2 NE 0
     C                   ADD       1             RNS2
     C     RNS2          CHAIN     APS112S2                           42
     C                   ENDDO
      * GET TOTAL OTHER CHARGE AMOUNT
     C                   Z-ADD     LDTL03        APTL03
      * RE-CALCULATE NET AMOUNT
     C     APAM04        ADD       APAM14        APAM06                         GROSS+TAX
     C                   ADD       APAM13        APAM06                         + PPD FRT
     C                   ADD       APAM26        APAM06                         + FRT OUT
     C                   ADD       APTL03        APAM06                         + OTHER CHARGES
¢H   C                   IF        APAM04 > *Zero
     C                   SUB       APAM05        APAM06                         - DISC = NET
¢H   C                   ELSE
¢H   C                   z-add     *zero         APAM05                         clear disc on credt
¢H   C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *----------------------------------------------------------------
      * PROCESS PREVIOUSLY MATCHED LINES FOR CHANGES THAT MAY HAVE
      * BEEN MADE PRIOR TO ACCESSING OTHER CHARGES SELECTION.
      *----------------------------------------------------------------
     C     PMTCH         BEGSR
     C                   MOVE      *IN42         SVIN42            1
     C                   MOVE      *IN43         SVIN43            1
     C                   Z-ADD     1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C     *IN42         DOWEQ     *OFF
     C     MTHKY4        CHAIN     APFWMTH4                           43
     C     *IN43         IFEQ      *OFF
     C                   Z-SUB     AM35S3        MHAM31
     C                   MOVE      CD53S3        MHCD53
     C                   MOVE      DN06S3        MHDN06
     C                   MOVE      CD49S3        MHCD49
     C                   MOVE      CD50S3        MHCD50
     C                   EXCEPT    UPMTH4
     C                   ENDIF
     C                   ADD       1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C                   ENDDO
     C                   MOVE      SVIN42        *IN42
     C                   MOVE      SVIN43        *IN43
     C                   ENDSR
      *------------------------------------------------------------------------*
      * REMIT TO ADDRESS
      *------------------------------------------------------------------------*
     C     RMTADD        BEGSR
      *
     C                   MOVE      AD04C         HAD04
     C                   MOVE      AD05C         HAD05
     C                   MOVE      AD06C         HAD06
     C                   MOVE      CY02C         HCY02
     C                   MOVE      ST02C         HST02
     C                   MOVE      ZP08C         HZP08
     C                   MOVE      'N'           F3WRN                          RESET WARNING
      *
     C     DSPK          TAG
     C                   EXFMT     APF1112K
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVE      *OFF          *IN90
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPK
     C                   END
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C                   MOVE      'N'           F12WRN                         RESET WARNING
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPK
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO PREVIOUS SCREEN
     C     *IN12         IFEQ      *ON
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C     F12WRN        IFEQ      'N'
     C                   MOVEA     EMS(7)        MSGFLD
     C                   MOVE      'Y'           F12WRN
     C                   GOTO      DSPK
     C                   ENDIF
     C                   MOVE      HAD04         AD04C
     C                   MOVE      HAD05         AD05C
     C                   MOVE      HAD06         AD06C
     C                   MOVE      HCY02         CY02C
     C                   MOVE      HST02         ST02C
     C                   MOVE      HZP08         ZP08C
     C                   MOVE      'N'           F12WRN
     C                   GOTO      ENDRMT
     C                   END
     C                   MOVE      'N'           F12WRN
      * ADDITIONAL ADDRESSES
     C     *IN18         IFEQ      *ON
     C                   EXSR      ADDSEL
     C                   GOTO      DSPK
     C                   END
      * EDIT FOR ERRORS
     C                   SELECT
      ** ADDRESS LINE ONE REQUIRED
     C     AD04C         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN91
      ** CITY REQUIRED
     C     CY02C         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN92
      ** STATE REQUIRED
     C     ST02C         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN93
      ** ZIP CODE REQUIRED
     C     ZP08C         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN94
     C                   ENDSL
      *
     C     *IN91         IFEQ      *ON
     C     *IN92         OREQ      *ON
     C     *IN93         OREQ      *ON
     C     *IN94         OREQ      *ON
     C                   MOVE      *ON           *IN90
     C                   MOVEA     EMS(44)       MSGFLD
     C                   ENDIF
      *
     C     MSGFLD        CABNE     *BLANKS       DSPK
      *
     C     ENDRMT        ENDSR
      *------------------------------------------------------------------------*
      * CALCULATE DUE DATE/DISCOUNT DATE
      *------------------------------------------------------------------------*
     C     CALCDT        BEGSR
      *
     C                   MOVE      INVDTC        CLCDT
      *
     C     APCD02        IFGT      0
     C     APCD02        IFLE      31
     C                   MOVE      APCD02        CLCDY
     C                   ADD       1             CLCMO
     C                   ELSE
      *
     C     TRMTRY        TAG
     C                   MOVE      ' '           RSPN
     C                   MOVE      *BLANKS       TABTRM
     C                   MOVE      'AP09'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'DUECD'       TBNO02
     C                   MOVE      APCD02        TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *ON
     C                   MOVE      'N'           TBCODE
     C                   CALL      'OPC1020'     PL1020
     C     RSPN          CABEQ     'Y'           TRMTRY
     C     RSPN          CABNE     'Y'           ENDPGM
     C                   ENDIF
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        TABTRM
     C                   MOVE      'N'           TRMERR            1
     C     TRM1          IFEQ      *BLANKS
     C                   MOVE      'Y'           TRMERR
     C                   ELSE
     C                   TESTN                   TRM1                 52
     C     *IN52         IFEQ      *ON
     C     TRM2          ANDNE     *BLANKS
     C                   TESTN                   TRM2                 52
     C     *IN52         IFEQ      *ON
     C     TRM3          ANDNE     *BLANKS
     C                   TESTN                   TRM3                 52
     C     *IN52         IFEQ      *ON
     C     TRM4          ANDNE     *BLANKS
     C                   TESTN                   TRM4                 52
     C     *IN52         IFEQ      *ON
     C     TRM5          ANDNE     *BLANKS
     C                   TESTN                   TRM5                 52
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     *IN52         IFEQ      *OFF
     C                   MOVE      'Y'           TRMERR
     C                   ENDIF
     C                   ENDIF
     C     TRMERR        IFEQ      'Y'
     C                   MOVE      'I'           TBCODE
     C                   CALL      'OPC1020'     PL1020
     C     RSPN          CABEQ     'Y'           TRMTRY
     C     RSPN          CABNE     'Y'           ENDPGM
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
     C     INVDY         WHENLE    T1INDY
     C                   MOVE      T1DUDY        CLCDY
     C                   ADD       T1INCR        CLCMO
     C     INVDY         WHENLE    T2INDY
     C                   MOVE      T2DUDY        CLCDY
     C                   ADD       T2INCR        CLCMO
     C     INVDY         WHENLE    T3INDY
     C                   MOVE      T3DUDY        CLCDY
     C                   ADD       T3INCR        CLCMO
     C     INVDY         WHENLE    T4INDY
     C                   MOVE      T4DUDY        CLCDY
     C                   ADD       T4INCR        CLCMO
     C     INVDY         WHENLE    T5INDY
     C                   MOVE      T5DUDY        CLCDY
     C                   ADD       T5INCR        CLCMO
     C                   ENDSL
     C                   ENDIF                                                  APCD02 LE 31
      *
     C     CLCMO         IFGT      12
     C                   SUB       12            CLCMO
     C                   ADD       1             CLCYR
     C                   ENDIF
      *
     C                   MOVE      'V'           ZZFUNC
     C                   Z-ADD     0             ZZDIFF
     C                   Z-ADD     0             ZZDAYS
     C                   Z-ADD     CLCDT         ZZDATE
     C                   CALL      'UDR'         PLUDR
     C     ZZFUNC        IFEQ      '*'
     C                   Z-ADD     01            CLCDY
     C                   Z-ADD     CLCDT         ZZDATE                         RESET DATE
     C                   MOVE      '8'           ZZFUNC                         CALC EOM DAY
     C                   CALL      'UDR'         PLUDR
     C                   ENDIF
     C                   Z-ADD     ZZDATE        CLCDT
      *
     C                   ELSE
      * CALCULATE DATE FROM INVOICE DATE & NUMBER OF DAYS
     C     APNO07        IFGT      0
     C                   MOVE      '5'           ZZFUNC
     C                   Z-ADD     CLCDT         ZZDATE
     C                   Z-ADD     APNO07        ZZDAYS
     C                   Z-ADD     0             ZZDIFF
     C                   CALL      'UDR'         PLUDR
     C                   Z-ADD     ZZDATE        CLCDT
     C                   ELSE
     C                   CLEAR                   CLCDT
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *----------------------------------------------------------------
      * REMOVE ALL P/O MATCHING
      *----------------------------------------------------------------
     C     DLTMTH        BEGSR
      * IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
      * IF LAST SKIP MATCH IS NO
      * AND NOT FOR FREIGHT ONLY INVOICE
      * AND LAST P/O SELECTED WAS A DIRECT P/O
      ** IF LAST P/O SELECTED IS NOT THE SAME AS THE ORIGINAL P/O
      ** OR LAST RCV SELECTED IS NOT THE SAME AS THE ORIGINAL RCV
      ** DELETE THE DIRECT RECEIVER CREATED FOR THE LAST P/O MATCH
     C     LSTSKP        IFNE      'Y'
     C     LSTFRT        ANDNE     'Y'
     C     LSTDIR        ANDEQ     'D'
     C     LSTPO         IFNE      ORGPO
     C     LSTRCV        ORNE      ORGRCV
     C                   MOVE      LSTPO         DLTPO
     C                   MOVE      LSTRCV        DLTRCV
     C                   CALL      'APR1068'     PL1068
     C                   ENDIF                                                  LSTPO NE ORGPO
     C                   ENDIF                                                  LSTSKP NE Y
      * IF ORIGINAL SKIP MATCH IS NO
      * AND NOT FOR FREIGHT ONLY INVOICE
      * AND ORIGINAL P/O SELECTED WAS A DIRECT P/O
      ** DELETE THE DIRECT RECEIVER CREATED FOR THE ORIGINAL P/O MATCH
     C     ORGSKP        IFNE      'Y'
     C     ORGFRT        ANDNE     'Y'
     C     ORGDIR        ANDEQ     'D'
     C                   MOVE      ORGPO         DLTPO
     C                   MOVE      ORGRCV        DLTRCV
     C                   CALL      'APR1068'     PL1068
     C                   ENDIF                                                  ORGSKP NE Y
      * REMOVE P/O MATCHING IN THE MATCH WORK FILE
     C                   Z-ADD     0             SAVRCV
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFWMTH                            4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MHNO19        SAVRCV
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
      ** IF LAST P/O SELECTED WAS NOT A DIRECT P/O
      *** REMOVE LAST P/O MATCHING IN THE RECEIVER DETAIL FILE
     C     LSTDIR        IFNE      'D'
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     TRDKEY        CHAIN     POFTRD1                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   ADD       MHQY05        POQY38
     C                   SUB       MHQY05        POQY39
     C                   EXCEPT    UPDRD1
     C                   ENDIF
      *** REMOVE LAST P/O MATCHING IN THE INVOICE MATCH FILE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     INMKY1        CHAIN     APFTINM1                           4992
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN49         IFEQ      *OFF
     C                   DELETE    APFTINM1
     C                   ENDIF
     C                   ENDIF
      *
     C                   DELETE    APFWMTH
      *
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFWMTH                              9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      * REMOVE MAINTENANCE LOCK FLAG IN RECEIVER HEADER(S)
     C     MHNO19        IFNE      SAVRCV
     C     *IN45         OREQ      *ON
      *** DO NOT UPDATE HEADER IF IN ORIGINAL MATCH
     C     INM1K2        CHAIN(N)  APFTINM1                           49
     C     *IN49         IFEQ      *ON
      * GET RECEIVER HEADER
      * CHECK FOR RECORD LOCK
      * IF RECORD LOCK FOUND, DO NOT LET USER HAVE THE RETRY OPTION
      * RECEIVER HEADER LOCK FLAG ALREADY SET TO Y
      * THIS UPDATE MUST HAPPEN OR THE RECEIVER LOCK FLAG WILL STAY Y
      *  AND WILL HAVE TO BE MANAULLY REMOVED USING DFU/DBU
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRCV        CHAIN     POFTRH                             4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POCD24
     C                   EXCEPT    UPDTRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  IN49 EQ ON
     C                   Z-ADD     MHNO19        SAVRCV
     C                   ENDIF                                                  MHNO19 NE SAVRCV
     C                   ENDDO
      * REMOVE REMAINING ORIGINAL MATCHING
     C                   Z-ADD     0             SAVRCV
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINM1                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MONO19        SAVRCV
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
      ** IF LAST P/O SELECTED WAS NOT A DIRECT P/O
      *** REMOVE LAST P/O MATCHING IN THE RECEIVER DETAIL FILE
     C     LSTDIR        IFNE      'D'
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     TRDKY2        CHAIN     POFTRD1                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   ADD       APQY05        POQY38
     C                   SUB       APQY05        POQY39
     C                   EXCEPT    UPDRD1
     C                   ENDIF
     C                   ENDIF
      *
     C                   DELETE    APFTINM1
      *
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTINM1                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      * REMOVE MAINTENANCE LOCK FLAG IN RECEIVER HEADER(S)
     C     MONO19        IFNE      SAVRCV
     C     *IN45         OREQ      *ON
      * GET RECEIVER HEADER
      * CHECK FOR RECORD LOCK
      * IF RECORD LOCK FOUND, DO NOT LET USER HAVE THE RETRY OPTION
      * RECEIVER HEADER LOCK FLAG ALREADY SET TO Y
      * THIS UPDATE MUST HAPPEN OR THE RECEIVER LOCK FLAG WILL STAY Y
      *  AND WILL HAVE TO BE MANAULLY REMOVED USING DFU/DBU
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRCV        CHAIN     POFTRH                             4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POCD24
     C                   EXCEPT    UPDTRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   Z-ADD     MONO19        SAVRCV
     C                   ENDIF                                                  MONO19 NE SAVRCV
     C                   ENDDO
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
      * REMOVE VENDOR RETURN MATCHING IN THE MATCH WORK FILE
     C                   Z-ADD     0             SAVRTN
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFWMTH5                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MHNO27        SAVRTN
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
      *** REMOVE LAST MATCHING IN THE INVOICE MATCH FILE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     INM9K1        CHAIN     APFTINM9                           4992
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN49         IFEQ      *OFF
     C                   DELETE    APFTINM9
     C                   ENDIF
     C     MHCD53        IFEQ      *BLANKS
      *** REMOVE LAST MATCHING IN THE VENDOR RETURN DETAIL FILE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VRLKEY        CHAIN     POFTVRL                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   ADD       MHQY05        POQY38
     C                   SUB       MHQY05        POQY39
     C                   EXCEPT    UPDRL1
      * INTERFACE PGM TO SEND UNMATCHED QTY TO DATAQ WIIN...
     C     WHMYES        IFEQ      'Y'
     C                   EXSR      SENDWM
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      *** REMOVE LAST MATCHING IN THE VENDOR RETURN OTHER CHARGE FILE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VROKEY        CHAIN     POFTVRO                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   ADD       MHAM32        POAM52
     C                   SUB       MHAM32        POAM51
     C                   EXCEPT    UPDVRO
     C                   ENDIF
     C                   ENDIF                                                  MHCD53 EQ BLANKS
     C                   DELETE    APFWMTH5
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFWMTH5                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      * REMOVE MAINTENANCE LOCK FLAG IN VENDOR RETURN HEADER(S)
     C     MHNO27        IFNE      SAVRTN
     C     *IN45         OREQ      *ON
      *** DO NOT UPDATE HEADER IF IN ORIGINAL MATCH
     C     INM9K2        CHAIN(N)  APFTINM9                           49
     C     *IN49         IFEQ      *ON
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRTN        CHAIN     POFTVRH                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POFL06
     C                   EXCEPT    UPDVRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  IN49 EQ ON
     C                   Z-ADD     MHNO27        SAVRTN
     C                   ENDIF
     C                   ENDDO
      * REMOVE REMAINING ORIGINAL MATCHING
     C                   Z-ADD     0             SAVRTN
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFTINM9                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MONO27        SAVRTN
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
     C     MOCD53        IFEQ      *BLANKS
      *** REMOVE REMAINING MATCHING IN THE VENDOR RETURN DETAIL FILE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VRLKY2        CHAIN     POFTVRL                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   ADD       APQY05        POQY38
     C                   SUB       APQY05        POQY39
     C                   EXCEPT    UPDRL1
      * INTERFACE PGM TO SEND UNMATCHED QTY TO DATAQ WIIN...
     C     WHMYES        IFEQ      'Y'
     C                   EXSR      SENDWM
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      *** REMOVE REMAINING MATCHING - VENDOR RETURN OTHER CHARGE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VROKY2        CHAIN     POFTVRO                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   ADD       APAM32        POAM52
     C                   SUB       APAM32        POAM51
     C                   EXCEPT    UPDVRO
     C                   ENDIF
     C                   ENDIF                                                  MOCD53 EQ BLANKS
     C                   DELETE    APFTINM9
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFTINM9                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      * REMOVE MAINTENANCE LOCK FLAG IN VENDOR RETURN HEADER(S)
     C     MONO27        IFNE      SAVRTN
     C     *IN45         OREQ      *ON
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRTN        CHAIN     POFTVRH                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POFL06
     C                   EXCEPT    UPDVRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   Z-ADD     MONO27        SAVRTN
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF                                                  CD26K EQ I
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * REMOVE LAST MATCHING
      *------------------------------------------------------------------------*
     C     RMVMTH        BEGSR
      * IF LAST SKIP MATCH IS NO
      * AND NOT FOR FREIGHT ONLY INVOICE
      * AND INVOICE NOT APPROVED
     C     LSTSKP        IFNE      'Y'
     C     LSTFRT        ANDNE     'Y'
     C     SVCD09        IFNE      'Y'
      * IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
      ** IF LAST P/O SELECTED WAS A DIRECT P/O
     C     LSTDIR        IFEQ      'D'
      *** IF LAST P/O SELECTED IS NOT THE SAME AS THE ORIGINAL P/O
      *** OR LAST RCV SELECTED IS NOT THE SAME AS THE ORIGINAL RCV
      *** DELETE THE DIRECT RECEIVER CREATED FOR THE LAST P/O MATCH
     C     LSTPO         IFNE      ORGPO
     C     LSTRCV        ORNE      ORGRCV
     C                   MOVE      LSTPO         DLTPO
     C                   MOVE      LSTRCV        DLTRCV
     C                   CALL      'APR1068'     PL1068
     C                   ENDIF                                                  LSTPO NE ORGPO
     C                   ENDIF                                                  LSTDIR EQ D
      ** REMOVE LAST P/O MATCHING IN THE P/O MATCH WORK FILE
     C                   Z-ADD     0             SAVRCV
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFWMTH                            4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MHNO19        SAVRCV
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
      ** IF LAST P/O SELECTED WAS NOT A DIRECT P/O
      *** REMOVE LAST P/O MATCHING IN THE RECEIVER DETAIL FILE
     C     LSTDIR        IFNE      'D'
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     TRDKEY        CHAIN     POFTRD1                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
      *** DO NOT RELEASE IF ORIGINAL MATCH
     C     INMKY1        CHAIN(N)  APFTINM1                           49
     C     *IN49         IFEQ      *ON
     C                   MOVE      *ZEROS        PONO24
     C                   ENDIF
     C                   ADD       MHQY05        POQY38
     C                   SUB       MHQY05        POQY39
     C                   EXCEPT    UPDRD1
     C                   ENDIF
     C                   ENDIF
      *
     C                   DELETE    APFWMTH
      *
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFWMTH                              9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      * REMOVE MAINTENANCE LOCK FLAG IN RECEIVER HEADER
     C     MHNO19        IFNE      SAVRCV
     C     *IN45         OREQ      *ON
      *** DO NOT UPDATE HEADER IF IN ORIGINAL MATCH
     C     INM1K2        CHAIN(N)  APFTINM1                           49
     C     *IN49         IFEQ      *ON
      * GET RECEIVER HEADER
      * CHECK FOR RECORD LOCK
      * IF RECORD LOCK FOUND, DO NOT LET USER HAVE THE RETRY OPTION
      * RECEIVER HEADER LOCK FLAG ALREADY SET TO Y
      * THIS UPDATE MUST HAPPEN OR THE RECEIVER LOCK FLAG WILL STAY Y
      *  AND WILL HAVE TO BE MANAULLY REMOVED USING DFU/DBU
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRCV        CHAIN     POFTRH                             4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POCD24
     C                   EXCEPT    UPDTRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  IN49 EQ ON
     C                   Z-ADD     MHNO19        SAVRCV
     C                   ENDIF
     C                   ENDDO
     C                   ELSE
EK    *======
EK    *----------------------
EK    * Rebate credit memo...
EK    *----------------------
EK   C                   IF        REB_CR = 'Y'
EK   C                   EXSR      DEL_WRBM
EK    *-----------------
EK    * Vendor return...
EK    *-----------------
EK   C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
      ** REMOVE LAST VENDOR RETURN MATCHING IN THE MATCH WORK FILE
     C                   Z-ADD     0             SAVRTN
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFWMTH5                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MHNO27        SAVRTN
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
      *** DETERMINE IF IN ORIGINAL MATCH
     C     INM9K1        CHAIN(N)  APFTINM9                           49
      *** REMOVE LAST MATCHING IN THE VENDOR RETURN DETAIL FILE
     C     MHCD53        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VRLKEY        CHAIN     POFTVRL                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
      *** DO NOT RELEASE IF ORIGINAL MATCH
     C     *IN49         IFEQ      *ON
     C                   MOVE      *ZEROS        PONO24
     C                   ENDIF                                                  IN49 EQ ON
     C                   ADD       MHQY05        POQY38
     C                   SUB       MHQY05        POQY39
     C                   EXCEPT    UPDRL1
      * INTERFACE PGM TO SEND UNMATCHED QTY TO DATAQ WIIN...
     C     WHMYES        IFEQ      'Y'
      ** DO NOT SEND TO INTERFACE PGM IF IN ORIGINAL MATCH
     C     *IN49         IFEQ      *ON
     C                   EXSR      SENDWM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ELSE
      *** REMOVE LAST MATCHING IN THE VENDOR RETURN OTHER CHARGE DETAIL
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VROKEY        CHAIN     POFTVRO                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
      *** DO NOT RELEASE IF ORIGINAL MATCH
     C     *IN49         IFEQ      *ON
     C                   MOVE      *ZEROS        PONO24
     C                   ENDIF                                                  IN49 EQ ON
     C                   ADD       MHAM32        POAM52
     C                   SUB       MHAM32        POAM51
     C                   EXCEPT    UPDVRO
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  MHCD53 EQ BLANKS
     C                   DELETE    APFWMTH5
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFWMTH5                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      * REMOVE MAINTENANCE LOCK FLAG IN VENDOR RETURN HEADER
     C     MHNO27        IFNE      SAVRTN
     C     *IN45         OREQ      *ON
      *** DO NOT UPDATE HEADER IF IN ORIGINAL MATCH
     C     INM9K2        CHAIN(N)  APFTINM9                           49
     C     *IN49         IFEQ      *ON
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRTN        CHAIN     POFTVRH                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POFL06
     C                   EXCEPT    UPDVRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  IN49 EQ ON
     C                   Z-ADD     MHNO27        SAVRTN
     C                   ENDIF
     C                   ENDDO
      * REMOVE OTHER CHARGES FROM SUBFILE
     C                   Z-ADD     1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C     *IN42         DOWEQ     *OFF
     C     NO03S3        IFNE      0
     C                   Z-ADD     0             PONO32
     C     MTH5K2        CHAIN(N)  APFWMTH5                           49
     C     *IN49         IFEQ      *ON
     C                   Z-ADD     0             NO06S3
     C                   Z-ADD     0             NO02S3
     C                   Z-ADD     0             NO03S3
     C                   Z-ADD     0             NO04S3
     C                   UPDATE    APS112S3
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C                   ENDDO
      *
EK   C                   ENDIF                                                  REB_CR
     C                   ENDIF                                                  CD26K EQ I
     C                   ELSE
      ** REMOVE MATCHING IN THE MATCH WORK FILE
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFWMTH                            4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         DOWEQ     *OFF
     C                   DELETE    APFWMTH
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFWMTH                              9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
     C                   ENDIF                                                  SVCD09 NE Y
     C                   ENDIF                                                  LSTSKP NE Y
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * RESTORE ORIGINAL MATCHING
      *------------------------------------------------------------------------*
     C     RSTMTH        BEGSR
      * IF ORIGINAL SKIP MATCH IS NO
      * AND NOT FOR FREIGHT ONLY INVOICE
      * AND NOT FOR DIRECT INVOICE
     C     ORGSKP        IFNE      'Y'
     C     ORGFRT        ANDNE     'Y'
     C     SVCD09        ANDNE     'Y'
      * IF INVOICE TYPE IS INVOICE
     C     CD26K         IFEQ      'I'
      * GET ORIGINAL MATCHING IN INVOICE MATCH FILE
     C                   Z-ADD     0             SAVRCV
     C     NO20C         CHAIN(N)  APFTINM1                           45
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MONO19        SAVRCV
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
      * GET RECEIVER DETAIL RECORD
     C     ORGDIR        IFNE      'D'
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     TRDKY2        CHAIN     POFTRD1                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   SUB       APQY05        POQY38
     C                   ADD       APQY05        POQY39
     C                   EXCEPT    UPDRD1
     C                   ENDIF
     C                   ENDIF                                                  ORGDIR NE Y
     C     NO20C         READE(N)  APFTINM1                               45
      * REMOVE MAINTENANCE LOCK FLAG IN RECEIVER HEADER
     C     MONO19        IFNE      SAVRCV
     C     *IN45         OREQ      *ON
      * GET RECEIVER HEADER
      * CHECK FOR RECORD LOCK
      * IF RECORD LOCK FOUND, DO NOT LET USER HAVE THE RETRY OPTION
      * RECEIVER HEADER LOCK FLAG ALREADY SET TO Y
      * THIS UPDATE MUST HAPPEN OR THE RECEIVER LOCK FLAG WILL STAY Y
      *  AND WILL HAVE TO BE MANAULLY REMOVED USING DFU/DBU
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRCV        CHAIN     POFTRH                             4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POCD24
     C                   EXCEPT    UPDTRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   Z-ADD     MONO19        SAVRCV
     C                   ENDIF
     C                   ENDDO
     C                   ELSE
      * IF INVOICE TYPE IS CREDIT,DEBIT
EK    *======
EK    * and it's not a rebate credit memo
EK   C                   IF        REB_CR <> 'Y'
      * GET ORIGINAL MATCHING IN INVOICE MATCH FILE
     C                   Z-ADD     0             SAVRTN
     C     NO20C         CHAIN(N)  APFTINM9                           45
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MONO27        SAVRTN
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
     C     MOCD53        IFEQ      *BLANKS
      * GET VENDOR RETURN DETAIL RECORD
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VRLKY2        CHAIN     POFTVRL                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   SUB       APQY05        POQY38
     C                   ADD       APQY05        POQY39
     C                   EXCEPT    UPDRL1
     C                   ENDIF
     C                   ELSE
      * GET VENDOR RETURN OTHER CHARGE DETAIL RECORD
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VROKY2        CHAIN     POFTVRO                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      *ZEROS        PONO24
     C                   SUB       APAM32        POAM52
     C                   ADD       APAM32        POAM51
     C                   EXCEPT    UPDVRO
     C                   ENDIF
     C                   ENDIF
     C     NO20C         READE(N)  APFTINM9                               45
      * REMOVE MAINTENANCE LOCK FLAG IN VENDOR RETURN HEADER
     C     MONO27        IFNE      SAVRTN
     C     *IN45         OREQ      *ON
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRTN        CHAIN     POFTVRH                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POFL06
     C                   EXCEPT    UPDVRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   Z-ADD     MONO27        SAVRTN
     C                   ENDIF
     C                   ENDDO
      *
EK   C                   ENDIF                                                  REB_CR
     C                   ENDIF                                                  CD26K EQ I
     C                   ENDIF                                                  ORGSKP NE Y
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * REMOVE OTHER CHARGES
      *------------------------------------------------------------------------*
     C     RMVOTH        BEGSR
     C                   Z-ADD     0             SAVRTN
     C                   MOVEA     *ZEROS        VNB
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         CHAIN     APFWMTH4                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD     MHNO27        SAVRTN
     C                   ENDIF
     C     *IN45         DOWEQ     *OFF
      *** DETERMINE IF IN ORIGINAL MATCH
     C     INM9K1        CHAIN(N)  APFTINM9                           49
      *** REMOVE LAST MATCHING IN THE VENDOR RETURN OTHER CHARGE DETAIL
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     VROKEY        CHAIN     POFTVRO                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
      *** DO NOT RELEASE IF ORIGINAL MATCH
     C     *IN49         IFEQ      *ON
     C                   MOVE      *ZEROS        PONO24
     C                   ENDIF                                                  IN49 EQ ON
     C                   ADD       MHAM32        POAM52
     C                   SUB       MHAM32        POAM51
     C                   EXCEPT    UPDVRO
     C                   ENDIF                                                  IN47 EQ OFF
     C                   DELETE    APFWMTH4
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NO20C         READE     APFWMTH4                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
      * REMOVE MAINTENANCE LOCK FLAG IN VENDOR RETURN HEADER
     C     MHNO27        IFNE      SAVRTN
     C     *IN45         OREQ      *ON
      *** DO NOT UPDATE HEADER IF IN CURRENT MATCH
     C     INM9K2        CHAIN(N)  APFWMTH5                           49
     C     *IN49         IFEQ      *ON
      *** DO NOT UPDATE HEADER IF IN ORIGINAL MATCH
     C     INM9K2        CHAIN(N)  APFTINM9                           49
     C     *IN49         IFEQ      *ON
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     SAVRTN        CHAIN     POFTVRH                            4792
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POFL06
     C                   EXCEPT    UPDVRH
     C                   ENDIF                                                  IN47 EQ OFF
     C                   ENDIF                                                  IN49 EQ ON
     C                   ENDIF                                                  IN49 EQ ON
      ** LOAD RETURN NUMBER TO USE FOR MATCH SELECTION UPDATE LATER
     C                   Z-ADD     1             V                 4 0
     C     0000000       LOOKUP    VNB(V)                                 44
     C     *IN44         IFEQ      *ON
     C                   Z-ADD     SAVRTN        VNB(V)
     C                   ENDIF
     C                   Z-ADD     MHNO27        SAVRTN
     C                   ENDIF
     C                   ENDDO
      ** UPDATE MATCH SELECTION CODE IN MATCH WORK FILE
     C                   Z-ADD     1             V
     C     V             DOWLT     1000
     C     VNB(V)        IFNE      0
     C                   Z-ADD     VNB(V)        SAVRTN
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     INM9K2        CHAIN     APFWMTH5                           4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN45         DOWEQ     *OFF
     C                   MOVE      'L'           MHSEL
     C                   EXCEPT    UPDSEL
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     INM9K2        READE     APFWMTH5                             9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
     C                   ENDIF
     C                   ADD       1             V
     C                   ENDDO
      * REMOVE OTHER CHARGES FROM SUBFILE
     C                   MOVE      *IN03         SVIN03
     C                   Z-ADD     1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C     *IN42         DOWEQ     *OFF
     C     NO03S3        IFNE      0
     C                   Z-ADD     0             NO06S3
     C                   Z-ADD     0             NO02S3
     C                   Z-ADD     0             NO03S3
     C                   Z-ADD     0             NO04S3
     C                   UPDATE    APS112S3
     C                   ENDIF
     C                   ADD       1             RNS3
     C     RNS3          CHAIN     APS112S3                           42
     C                   ENDDO
     C                   MOVE      SVIN03        *IN03
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * CHECK P/O TERMS
      *------------------------------------------------------------------------*
     C     CKTERM        BEGSR
      *
     C                   MOVE      'N'           F3WRN
     C                   MOVE      'N'           F12WRN
     C                   Z-ADD     PC01C         PCTC
     C                   Z-ADD     APAM05        DSCC
     C                   Z-ADD     DUEDTC        DUEDTM
     C                   Z-ADD     APAM13        FGHTC
     C                   Z-ADD     APAM26        FGHTX
     C                   MOVE      POPC01        PERC
     C     PERC          MULT(H)   APAM04        PODSC                          DISCOUNT $$
      *
     C     DSPM          TAG
     C                   EXFMT     APF1112M
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVE      *OFF          *IN91
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPM
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPM
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO PREVIOUS SCREEN
     C     *IN12         IFEQ      *ON
     C                   MOVE      'N'           F3WRN                          RESET WARNING
     C     F12WRN        IFEQ      'N'
     C                   MOVEA     EMS(7)        MSGFLD
     C                   MOVE      'Y'           F12WRN
     C                   GOTO      DSPM
     C                   ENDIF
     C                   GOTO      ENDCK
     C                   ENDIF
     C                   MOVE      'N'           F12WRN
      ** DETERMINE IF VALID DATE
     C     DUEDTM        IFNE      0
     C                   MOVE      DUEDTM        PDATE
     C                   MOVE      *ZEROS        PJULI
     C                   CALL      'GPR0100'     JULKEY
      *** GET DUE CENTURY
     C                   Z-ADD     1             DATYP                          DATE TYPE
     C                   MOVE      DUEYRM        DATE2
     C                   MOVE      DS2000        PM2000
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000
     C                   MOVE      DATE4         DUECYM            4 0
     C                   MOVE      DACEN         DUECCM
     C     PJULI         IFEQ      0
     C                   MOVEA     EMS(16)       MSGFLD
     C                   MOVE      *ON           *IN91
     C                   GOTO      DSPM
     C                   ENDIF
      *
      ** DATE ENTERED CANNOT BE > NOR < 1 YEAR FROM CURRENT YEAR
     C     DUECYM        IFLT      MIN1
     C     DUECYM        ORGT      PUS1
     C                   MOVEA     UMS(1)        MSGFLD
     C                   MOVE      *ON           *IN91
     C                   GOTO      DSPM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     PC01C         IFNE      PCTC                                         DISCOUNT %
     C     APAM05        ORNE      DSCC                                         DISCOUNT $$
     C     DUEDTC        ORNE      DUEDTM                                       DUE DATE
     C     APAM13        ORNE      FGHTC                                        FRGHT/HDLG $
¢L   C     APCD46        IFNE      'Y'                                          EDI invoice
     C     PC01C         IFNE      PCTC                                         DISCOUNT %
     C                   Z-ADD     PCTC          PC01C
     C                   MOVE      PCTC          PERC
     C     PERC          MULT(H)   APAM04        APAM05                         DISCOUNT $$
     C                   ELSE
     C                   Z-ADD     DSCC          APAM05
ES   C     PERC          MULT(H)   APAM04        wrkDisAmt1
     C                   ENDIF
¢L   C                   ENDIF
     C                   MOVE      DUEMOM        DUEMO
     C                   MOVE      DUEDYM        DUEDY
     C                   MOVE      DUECCM        DUECC
     C                   MOVE      DUEYRM        DUEYR
     C                   Z-ADD     FGHTC         APAM13
     C                   Z-ADD     FGHTX         APAM26
     C                   ENDIF
     C     ENDCK         ENDSR
      *------------------------------------------------------------------------*
      *   UNLOCK RECORD CALL SUBROUTINE
      *------------------------------------------------------------------------*
     C     UNLOCK        BEGSR
     C                   MOVE      *BLANK        DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   ENDSR
      *------------------------------------------------------------------------*
      * GET ADDRESS DEPENDING IF ALTERNATE VENDOR OR ORIGINAL VENDOR
      *------------------------------------------------------------------------*
     C     ADDSR         BEGSR
     C     HO25C         IFEQ      *ZEROS
     C     NO25C         ANDEQ     *ZEROS
     C                   MOVE      NO25M         NO25C
     C                   MOVE      NO25M         HO25C
     C                   ENDIF
      ******
     C     NO25C         IFNE      *ZEROS
     C                   MOVE      *ON           *IN50
     C                   MOVE      NO25C         KVEN
     C                   ELSE
     C                   MOVE      *OFF          *IN50
     C                   MOVE      NO01C         KVEN
     C                   ENDIF
     C                   MOVE      '2'           KCOD
     C     ADDKEY        CHAIN     APFMVAD                            45
     C     *IN45         IFEQ      *OFF
     C                   MOVE      APAD04        AD04C
     C                   MOVE      APAD05        AD05C
     C                   MOVE      APAD06        AD06C
     C                   MOVE      APCY02        CY02C
     C                   MOVE      APST02        ST02C
     C                   MOVE      APZP08        ZP08C
     C                   ELSE
     C     NO25C         IFNE      *ZEROS
     C     NO25C         CHAIN     APFMVEN4                           40
     C                   ELSE
     C                   MOVE      *OFF          *IN40
     C                   ENDIF
     C     *IN40         IFEQ      *OFF
     C                   MOVE      APAD01        AD04C
     C                   MOVE      APAD02        AD05C
     C                   MOVE      APAD03        AD06C
     C                   MOVE      APCY01        CY02C
     C                   MOVE      APST01        ST02C
     C                   MOVE      APZP07        ZP08C
     C                   ENDIF
     C                   ENDIF
      *
     C     NO25C         IFNE      *ZEROS
     C     NO01C         CHAIN     APFMVEN4                           40
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * DISPLAY REFERENCE INVOICE SELECTION
      *------------------------------------------------------------------------*
     C     GETREF        BEGSR
      *
     C                   Z-ADD     0             RNN
     C                   Z-ADD     0             LSTRNN
     C                   MOVEA     '1000'        *IN(73)
     C                   WRITE     APC1112N
     C                   MOVEA     '0000'        *IN(73)
      *
     C                   MOVE      'Y'           READH             1
     C                   MOVE      'N'           REFFND            1
     C                   Z-ADD     0             REFCTL
     C                   MOVE      NO01C         KVEN
     C                   MOVE      NO26K         KINV
     C     LOADN         TAG
      *
     C     READH         IFEQ      'Y'
     C     KEYINV        CHAIN     APFTINH6                           40
     C                   ELSE
     C     KEYINV        CHAIN     APFWINH2                           40
     C                   END
     C     *IN40         DOWEQ     *OFF
     C                   MOVE      'Y'           REFFND
     C     AXFL01        IFEQ      'N'                                          MATCHED
     C     AXCD09        ANDNE     'Y'                                          UNAPPROVED
     C     AXNO26        ANDEQ     *BLANKS                                      NO REF
     C     AXCD10        ANDEQ     'H'                                          VAR HOLD
     C     AXFL01        OREQ      'Y'                                          SKIP MATCH
     C     AXCD09        ANDNE     'Y'                                          UNAPPROVED
     C     AXNO26        ANDEQ     *BLANKS                                      NO REF
     C     AXCD11        IFEQ      'P'
     C                   MOVE      'P'           STSN                           PAID
     C                   ELSE
     C                   MOVE      'O'           STSN                           OPEN
     C     AXCD10        IFEQ      'H'
     C                   MOVE      'H'           STSN                           VAR HOLD
     C                   ELSE
     C     AXCD17        IFEQ      'Y'
     C                   MOVE      '$'           STSN                           PAYMENT HOLD
     C                   ELSE
     C     AXCD43        IFEQ      'Y'
     C                   MOVE      'M'           STSN                           MANUAL HOLD
     C                   END                                                    AXCD43 EQ Y
     C                   END                                                    AXCD17 EQ Y
     C                   END                                                    AXCD10 EQ H
     C                   END                                                    AXCD11 EQ P
     C                   Z-ADD     AXNO20        HCTL
     C                   Z-ADD     AXNO16        APBR#N
     C     AXAM13        ADD       AXAM14        GRSINV
     C                   ADD       AXAM04        GRSINV
     C                   Z-ADD     AXAM05        DSCAMT
     C                   Z-ADD     AXAM06        NETAMT
     C                   ADD       1             RNN
     C                   WRITE     APS1112N
     C                   END
     C     READH         IFEQ      'Y'
     C     KEYINV        READE     APFTINH6                               40
     C                   ELSE
     C     KEYINV        READE     APFWINH2                               40
     C                   END
     C                   END
     C     READH         IFEQ      'Y'
     C                   MOVE      'N'           READH
     C                   GOTO      LOADN
     C                   END
     C                   Z-ADD     RNN           LSTRNN
     C     RNN           CABEQ     0             ENDREF
     C     RNN           IFEQ      1
     C                   Z-ADD     HCTL          REFCTL
     C                   GOTO      ENDREF
     C                   END
     C                   MOVE      'N'           F3WRN
     C                   MOVE      'N'           F12WRN
      *   DISPLAY REFERENCE INVOICE SELECTION
     C     DSPN          TAG
     C                   MOVE      *IN40         *IN74
     C                   Z-ADD     1             RNN
     C                   MOVEA     '11'          *IN(75)
     C                   WRITE     APF1112N
     C                   EXFMT     APC1112N
     C                   MOVEA     '00'          *IN(75)
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPN
     C                   END
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C                   MOVE      'N'           F12WRN
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPN
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      *   PREVIOUS SCREEN
     C     *IN12         CABEQ     *ON           ENDREF
      *
     C     *IN44         DOUEQ     *ON
     C                   READC     APS1112N                               44
     C     *IN44         CABEQ     *ON           DSPN
     C     SELN          IFNE      *BLANKS
     C                   Z-ADD     HCTL          REFCTL
     C                   MOVE      *BLANKS       SELN
     C                   UPDATE    APS1112N
     C                   GOTO      ENDREF
     C                   END
     C                   END
      *
     C     ENDREF        ENDSR
      *------------------------------------------------------------------------*
      *   CHECK FOR VALID BANK NUMBER
      *------------------------------------------------------------------------*
     C     BNKCHK        BEGSR
      *
     C     BANKNO        CHAIN     APFMBNK                            40
     C     *IN40         IFEQ      *OFF
     C                   SELECT
      * BANK CLOSED
     C     APFL02        WHENEQ    'Y'
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(18)       MSGFLD
     C                   ENDIF
      * NOT AN A/P BANK
     C     APFL03        WHENEQ    'N'
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(19)       MSGFLD
     C                   ENDIF
      *
     C                   OTHER
     C     ALLOK         IFNE      'Y'
     C     BKNO15        LOOKUP    SEC                                    50
     C     *IN50         IFEQ      *OFF
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(20)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
      *
     C                   ELSE
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * GET CURRENT A/P PERIOD
      *------------------------------------------------------------------------*
     C     GETPRD        BEGSR
     C     APCO#F        CHAIN     APFMBNK1                           40
     C     *IN40         IFEQ      *OFF
     C                   Z-ADD     APMO17        CRAPMO
     C                   Z-ADD     APYR17        CRAPYR
     C                   Z-ADD     APCC17        CRAPCC
     C     CRAPMO        IFEQ      12
     C                   Z-ADD     1             CRAPMO
     C                   ADD       1             CRAPCY
     C                   ELSE
     C                   ADD       1             CRAPMO
     C                   ENDIF
     C                   Z-ADD     CRAPCC        CRPDCC
     C                   Z-ADD     CRAPYR        CRPDYR
     C                   Z-ADD     CRAPMO        CRPDMO
     C                   ELSE
     C                   MOVEA     EMS(6)        MSGFLD
     C                   MOVE      *ON           *IN90
     C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      * DISPLAY P/O'S / RECEIVERS MATCHED TO INVOICE
      *------------------------------------------------------------------------*
     C     DSPPO         BEGSR
      * DETERMINE SCREEN TITLE TO DISPLAY
     C                   MOVE      *BLANKS       TITLEO
     C                   SELECT
     C     WHRFRM        WHENEQ    'N'
     C                   MOVEA     HDG(1)        TITLEO
     C     WHRFRM        WHENEQ    'T'
     C                   MOVEA     HDG(2)        TITLEO
     C     WHRFRM        WHENEQ    'S'
     C                   MOVEA     HDG(3)        TITLEO
     C                   ENDSL
      *
     C                   MOVE      'N'           F3WRN
      * DISPLAY SUBFILE
     C     DSPO          TAG
     C     RNO           IFLE      0
     C                   MOVEA     '01'          *IN(75)
     C                   ELSE
     C                   MOVEA     '11'          *IN(75)
     C     SRNO          IFNE      0
     C                   Z-ADD     SRNO          RNO                                        REC
     C                   ELSE
     C                   Z-ADD     1             RNO                                        REC
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *ON           *IN74
      *
     C                   WRITE     APF1112O
     C                   EXFMT     APC1112O
     C                   MOVEA     '0000'        *IN(73)
     C                   MOVE      *BLANKS       MSGFLD
     C                   Z-ADD     SCRRN         SRNO                                       REC
      * PROMPT
     C     *IN04         IFEQ      *ON
     C                   EXSR      @PRMPT
     C                   GOTO      DSPO
     C                   ENDIF
     C                   EXSR      @CLCSR
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPO
     C                   END
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPO
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO PREVIOUS SCREEN
     C     *IN12         CABEQ     *ON           ENDPO
DK    * REDISPLAY SCREEN IF NO ENTRIES FOUND
DK   C     RNO           CABLE     0             DSPO
      *
     C     *IN42         DOUEQ     *ON
     C                   READC     APS1112O                               42
     C     *IN42         CABEQ     *ON           DSPO
     C     SELO          IFNE      ' '
      * CALL P/O NOTES INQUIRY
     C     SELO          IFEQ      'N'
     C                   MOVE      'Y'           DSPF3
     C                   MOVE      '1'           NOTTYP
     C                   CALL      'POR0140'     PL0140
     C                   ENDIF
      * CALL P/O INQUIRY
     C     SELO          IFEQ      'P'
     C                   MOVE      PONO01        PONBR
     C                   MOVE      'I'           CODE01
     C                   CALL      'POR0350'     INQKEY
     C                   ENDIF
      * CALL RECEIVING INQUIRY
     C     SELO          IFEQ      'R'
     C                   MOVE      PONO19        PONBR
     C                   MOVE      ' '           CODE01
     C                   CALL      'POR0375'     INQKEY
     C                   ENDIF
      * SELECT P/O FOR TERMS CHECK
     C     SELO          IFEQ      'T'
     C     PONO01        CHAIN     POFTOH                             49
     C                   EXSR      CKTERM
     C                   ENDIF
DS    * CALL RECEIVING NOTES TO A/P INQUIRY
DS   C     SELO          IFEQ      '1'
DS   C                   CALL      'POR0141'     PL0141
DS   C                   ENDIF
      *
     C                   MOVE      ' '           SELO
     C                   UPDATE    APS1112O
      *
     C                   ENDIF                                                  SELO NE ' '
     C                   ENDDO                                                  *IN42 DOUEQ *ON
      *
     C     ENDPO         ENDSR
      *------------------------------------------------------------------------*
      * DISPLAY VENDOR RETURNS MATCHED TO INVOICE
      *------------------------------------------------------------------------*
     C     DSPVR         BEGSR
      * DETERMINE SCREEN TITLE TO DISPLAY
     C                   MOVE      *BLANKS       TITLEQ
     C                   SELECT
     C     WHRFRM        WHENEQ    'O'
     C                   MOVEA     HDG(4)        TITLEQ
     C     WHRFRM        WHENEQ    'S'
     C                   MOVEA     HDG(5)        TITLEQ
     C                   ENDSL
      *
     C                   MOVE      'N'           F3WRN
     C                   MOVE      'N'           SELRTN            1
      * DISPLAY SUBFILE
     C     DSPQ          TAG
     C     RNQ           IFLE      0
     C                   MOVEA     '01'          *IN(75)
     C                   ELSE
     C                   MOVEA     '11'          *IN(75)
     C     SRNQ          IFNE      0
     C                   Z-ADD     SRNQ          RNQ                                        REC
     C                   ELSE
     C                   Z-ADD     1             RNQ                                        REC
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *ON           *IN74
      *
     C                   WRITE     APF1112Q
     C                   EXFMT     APC1112Q
     C                   MOVEA     '0000'        *IN(73)
     C                   MOVE      *BLANKS       MSGFLD
     C                   Z-ADD     SCRRN         SRNQ                                       REC
      * PROMPT
     C     *IN04         IFEQ      *ON
     C                   EXSR      @PRMPT
     C                   GOTO      DSPQ
     C                   ENDIF
     C                   EXSR      @CLCSR
      * DISPLAY HELP TEXT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'     HELP
     C                   GOTO      DSPQ
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     EMS(1)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPQ
     C                   ENDIF
      * REMOVE ANY MATCHING
     C                   EXSR      UPDMTH
      * EXIT PROGRAM
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   MOVE      'N'           F3WRN
      * RETURN TO PREVIOUS SCREEN
     C     *IN12         CABEQ     *ON           ENDVR
      *
     C     *IN42         DOUEQ     *ON
     C                   READC     APS1112Q                               42
     C     *IN42         CABEQ     *ON           DSPQ
     C     SELQ          IFNE      ' '
      * CALL VENDOR RETURN INQUIRY
     C     SELQ          IFEQ      'R'
     C                   CALL      'POR4290'     PL4290
     C                   ENDIF
      * SELECT VENDOR RETURN OTHER CHARGES
     C     SELQ          IFEQ      'O'
     C                   MOVE      'Y'           SELRTN
     C                   MOVE      *OFF          EXIT
     C                   Z-ADD     PONO27        OCRTN
     C                   CALL      'APR1092'     PL1092
     C                   ENDIF
     C                   MOVE      ' '           SELQ
     C                   UPDATE    APS1112Q
     C                   ENDIF                                                  SELQ NE ' '
     C                   ENDDO                                                  *IN42 DOUEQ *ON
      *
     C     ENDVR         ENDSR
      *----------------------------------------------------------------
      *  ACH - SUBROUTINE: EDIT AND DISPLAY ACH INFORMATION
      *----------------------------------------------------------------
     C     ACH           BEGSR
      * Due to the heavy use of indiactors, save indicators used in
      * this subroutine so they can be restored before returning...
     C                   MOVE      *IN55         SVIN55
     C                   MOVE      *IN56         SVIN56
     C                   MOVE      *IN57         SVIN57
     C                   MOVE      *IN58         SVIN58
     C                   MOVE      *IN59         SVIN59
      * Reset indicators and flags, etc...
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          F3WU              1
     C                   MOVE      *OFF          F12WU             1
     C                   CLEAR                   CD68DS
     C                   CLEAR                   NO53DS
     C                   CLEAR                   CD60DS
      * Save screen fields in case F12 is requested to return without
      * updating...
     C                   MOVE      CD68          SVCD68
     C                   Z-ADD     NO53          SVNO53
     C                   MOVE      CD60          SVCD60
     C                   Z-ADD     PPDAT         SVPDAT
     C                   Z-ADD     PPCC          SVPPCC
      * Only allow entry of payment period date if it is a tax vend...
     C     CD66A         IFEQ      'Y'                                          Tax vendor
     C                   MOVE      *OFF          *IN59
     C                   ELSE
     C                   MOVE      *ON           *IN59
     C                   CLEAR                   PPDAT
     C                   CLEAR                   PPCC
     C                   ENDIF
      * If bank number was not previously entered, default the
      * bank from the vendor master...
     C     NO53          IFEQ      *ZEROS                                       PREFILL
     C                   MOVE      'V'           MODE                           BANK FROM
     C                   MOVE      *BLANKS       NO53DS                         VENDOR ON
     C                   MOVE      NO53A         NO53C                          NEW ACH
D2    * Use alternate vendor...
D2   C     NO25C         IFNE      *ZEROS
D2   C                   Z-ADD     NO25C         VND_KEY
D2    * Use invoice vendor...
D2   C                   ELSE
D2   C                   Z-ADD     NO01C         VND_KEY
D2   C                   ENDIF
     C                   CALL      'APR0126'     PL0126                         PAYMENTS
     C     MODE          IFNE      'E'
     C                   MOVE      NO53C         NO53
     C                   MOVEL     BKDESC        NO53DS
     C                   ENDIF
     C                   ENDIF
      * If any information was previously entered, edit screen fields
      * before displaying...
     C     CD68          IFNE      *BLANKS
     C     CD60          ORNE      *BLANKS
     C     SVNO53        ORNE      *ZEROS
     C                   EXSR      EDITU
     C                   ENDIF
      * Allow the user to enter ACH information...
¢I   C     DSPU          TAG
¢I   C                   IF        *IN21 = *ON
     C     *IN03         DOUEQ     *ON
      *
     C                   EXFMT     APF1112U
      *
     C                   EXSR      @CLCSR
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *BLANKS       MSGFLD
      * Reset warning flags...
     C     F3WU          IFEQ      *ON
     C     *IN03         ANDEQ     *OFF
     C                   CLEAR                   F3WU
     C                   ENDIF
     C     F12WU         IFEQ      *ON
     C     *IN12         ANDEQ     *OFF
     C                   CLEAR                   F12WU
     C                   ENDIF
      * Process screen responses...
     C                   SELECT
      *-----------
      * F3=Exit...
      *-----------
     C     *IN03         WHENEQ    *ON
     C     F3WU          IFNE      *ON
     C                   MOVE      *ON           F3WU
     C                   MOVE      *OFF          *IN03
     C                   MOVEA     EMS(1)        MSGFLD
     C                   ITER
     C                   ENDIF
     C                   LEAVE
      *----------
      * F4=Prompt
      *----------
     C     *IN04         WHENEQ    *ON
     C                   EXSR      @PRMPT
     C                   ITER
      *--------------
      * F12=Cancel...
      *--------------
     C     *IN12         WHENEQ    *ON
     C     F12WU         IFNE      *ON
     C                   MOVE      *ON           F12WU
     C                   MOVE      *OFF          *IN12
     C                   MOVEA     EMS(7)        MSGFLD
     C                   ITER
     C                   ENDIF
      * Restore fields to their original values before returning...
     C                   MOVE      SVCD68        CD68
     C                   Z-ADD     SVNO53        NO53
     C                   MOVE      SVCD60        CD60
     C                   Z-ADD     SVPDAT        PPDAT
     C                   Z-ADD     SVPPCC        PPCC
     C                   LEAVE
      *------------------
      * Help requested...
      *------------------
     C     *IN25         WHENEQ    *ON
     C                   CALL      'HTR0010'     HELP
     C                   ITER
      *-----------------
      * Enter pressed...
      *-----------------
     C                   OTHER
     C                   EXSR      EDITU
     C     MSGFLD        IFEQ      *BLANKS
     C                   LEAVE
     C                   ELSE
     C                   ITER
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDDO
¢I   C                   ENDIF
      *
      * Restore indicators to original settings...
     C                   MOVE      SVIN55        *IN55
     C                   MOVE      SVIN56        *IN56
     C                   MOVE      SVIN57        *IN57
     C                   MOVE      SVIN58        *IN58
     C                   MOVE      SVIN59        *IN59
      *
     C                   ENDSR
      *----------------------------------------------------------------
      * Subroutine to edit screen APF1111U fields
      *----------------------------------------------------------------
     C     EDITU         BEGSR
      *
      * Validate transaction code...
      *
     C                   CLEAR                   CD68DS
     C                   SELECT
      * If nothing was entered display error...
     C     CD68          WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN55
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(109)      MSGFLD
     C                   ENDIF
      * If code was entered validate and retrieve description...
     C                   OTHER
     C                   MOVE      'AP18'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     CD68          TBNO02
     C                   MOVE      'V'           MODE
     C                   CALL      'TBR0025'     PL0025
     C     MODE          IFEQ      'E'
     C                   MOVE      *ON           *IN55
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(109)      MSGFLD
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     TBNO03        CD68DS
     C                   ENDIF
     C                   ENDSL
      *
      * Validate receiving bank...
      *
     C                   CLEAR                   NO53DS
     C                   SELECT
      * If nothing was entered display error...
     C     NO53C         WHENEQ    *BLANKS
     C                   MOVE      *ON           *IN56
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(110)      MSGFLD
     C                   ENDIF
      * If bank was entered validate and retrieve description...
     C                   OTHER
     C                   MOVE      'V'           MODE
     C                   MOVE      *BLANKS       NO53DS
     C                   MOVE      NO53          NO53C
D2    * Use alternate vendor...
D2   C     NO25C         IFNE      *ZEROS
D2   C                   Z-ADD     NO25C         VND_KEY
D2    * Use invoice vendor...
D2   C                   ELSE
D2   C                   Z-ADD     NO01C         VND_KEY
D2   C                   ENDIF
     C                   CALL      'APR0126'     PL0126
     C     MODE          IFEQ      'E'
     C                   MOVE      *ON           *IN56
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(110)      MSGFLD
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     BKDESC        NO53DS
     C                   ENDIF
     C                   ENDSL
      *
      * Vendor payment type code required...
      *
     C     CD60          IFEQ      *BLANKS
     C                   MOVE      *ON           *IN57
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(111)      MSGFLD
     C                   ENDIF
     C                   ENDIF
      * Validate payment type code...
E2    * 'CCD' is the default to use if one is not setup for vendor
     C                   CLEAR                   CD60DS
E2   C                   if        CD60 = 'CCD'
E2   C                   eval      CD60DS = 'ACH PAYMENT'
E2   C                   endif
E2
     C     CD60          IFNE      *BLANKS
E2   C     CD60          ANDNE     'CCD'
     C                   MOVE      'V'           MODE
     C                   MOVE      *BLANKS       CD60DS
     C                   MOVE      CD60          CD60C
D2    * Use alternate vendor...
D2   C     NO25C         IFNE      *ZEROS
D2   C                   Z-ADD     NO25C         VND_KEY
D2    * Use invoice vendor...
D2   C                   ELSE
D2   C                   Z-ADD     NO01C         VND_KEY
D2   C                   ENDIF
     C                   CALL      'APR0131'     PL0131
     C     MODE          IFEQ      'E'
     C                   MOVE      *ON           *IN57
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(111)      MSGFLD
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     TXDESC        CD60DS
     C                   ENDIF
     C                   ENDIF
      *
      * If tax vendor require payment period date...
      *
     C     CD66A         IFEQ      'Y'                                          Tax vendor
     C     PPDAT         ANDEQ     *ZEROS
     C                   MOVE      *ON           *IN58
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(112)      MSGFLD
     C                   ENDIF
     C                   ENDIF
      * Validate payment period date...
     C     PPDAT         IFNE      *ZEROS
     C                   MOVE      'V'           ZZFUNC
     C                   Z-ADD     0             ZZDIFF
     C                   Z-ADD     0             ZZDAYS
     C                   Z-ADD     PPDAT         ZZDATE
     C                   CALL      'UDR'         PLUDR
     C     ZZFUNC        IFEQ      '*'
     C                   MOVE      *ON           *IN58
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(112)      MSGFLD
     C                   ENDIF
     C                   ENDIF
      * Retrieve payment period century...
     C                   Z-ADD     1             DATYP
     C                   MOVE      PPYR          DATE2
     C                   MOVE      DS2000        PM2000                                     ERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      DACEN         PPCC
     C                   ELSE
     C                   CLEAR                   PPCC
     C                   ENDIF
      *
     C                   ENDSR
      *----------------------------------------------------------------
      *  @PRMPT - SUBROUTINE: PROCESS F4 , ALL FORMATS
      *----------------------------------------------------------------
     C     @PRMPT        BEGSR
      *
     C     CPOS          IFNE      0
      *
     C                   MOVE      'I'           MODE
     C                   MOVE      *OFF          F4ERR             1
     C                   MOVE      *ON           WDWFLG            1
      *
     C                   EXSR      @CURSR
      *
     C                   SELECT
     C     CRCD          WHENEQ    'APF1112C'
D4   C     CRCD          OREQ      'APF1112CW'
      *
     C                   SELECT
      *
     C     CFLD          WHENEQ    'GDN03C'
     C     *IN33         ANDEQ     *OFF
     C     GDN03C        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN90
     C                   MOVEA     EMS(39)       MSGFLD
     C                   GOTO      #PRMPT
     C                   ENDIF
     C                   MOVE      '0'           RTCOD                          RETURN CODE
     C                   MOVE      APCO#F        GNO01                          COMPANY #
     C                   MOVE      *BLANKS       GNO06                          BRANCH #
     C                   MOVE      *BLANKS       GNO02                          DEPARTMENT
     C                   MOVE      *BLANKS       GNO03                          MAIN ACCOUNT
     C                   MOVE      *BLANKS       GNO04                          SUB  ACCOUNT
     C                   MOVEL     GDN03C        GDN03                          NAME
     C                   CALL      'GLR2021'     PL2021
     C     RTCOD         IFEQ      '0'                                                         B2
     C                   MOVE      GNO06         GNO06C
     C                   MOVE      GNO02         GNO02C
     C                   MOVE      GNO03         GNO03C
     C                   MOVE      GNO04         GNO04C
     C                   MOVEL     GDN03         GDN03C
     C                   ELSE
     C                   MOVE      *ON           *IN90
     C                   MOVEA     EMS(40)       MSGFLD
     C                   ENDIF
      *
      * INVOICE PAYMENT TYPE...
     C     CFLD          WHENEQ    'CD67'
     C     NO26K         ANDEQ     *BLANKS
     C                   MOVE      *BLANKS       VALUE#
     C                   CALL      'TBR0060'     PL0060
     C     VALUE#        IFNE      *BLANKS
     C                   MOVEL     VALUE#        CD67
     C                   ENDIF
      *
     C     CFLD          WHENEQ    'APCD23'
     C     *IN33         ANDEQ     *OFF
     C                   MOVE      'AP02'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   CALL      'TBR0025'     PL0025
     C     TBNO02        IFNE      *BLANKS
     C                   MOVE      TBNO02        APCD23
     C                   ENDIF
      * REASON CODE
     C     CFLD          WHENEQ    'CD57C'
     C     *IN33         ANDEQ     *OFF
     C     DSPRSN        ANDEQ     'Y'
     C                   CLEAR                   SELCDE
     C                   CLEAR                   SELDES
     C                   CALL      'APR5000'     PL5000
     C     SELCDE        IFNE      *BLANKS
     C                   MOVEL     SELCDE        CD57C
     C                   MOVEL     SELDES        CD57DS
     C                   ENDIF
      *
     C                   OTHER
     C                   MOVE      *ON           F4ERR
     C                   ENDSL                                                  CFLD
      *
     C     CRCD          WHENEQ    'APS1112J'
     C     CRRN          CHAIN     APS1112J                           42
      *
     C                   SELECT
     C     CFLD          WHENEQ    'GDN03J'
     C     GDN03J        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN94
     C                   MOVEA     EMS(39)       MSGFLD
     C     *IN42         IFEQ      *OFF
     C                   UPDATE    APS1112J
     C                   GOTO      #PRMPT
     C                   ENDIF                                                  *IN42
     C                   ENDIF
     C                   MOVE      '0'           RTCOD                          RETURN CODE
     C                   MOVE      APCO#F        GNO01                          COMPANY #
     C                   MOVE      *BLANKS       GNO06                          BRANCH #
     C                   MOVE      *BLANKS       GNO02                          DEPARTMENT
     C                   MOVE      *BLANKS       GNO03                          MAIN ACCOUNT
     C                   MOVE      *BLANKS       GNO04                          SUB  ACCOUNT
     C                   MOVEL     GDN03J        GDN03                          NAME
     C                   CALL      'GLR2021'     PL2021
     C     RTCOD         IFEQ      '0'                                                         B2
     C                   MOVE      GNO06         GNO06J
     C                   MOVE      GNO02         GNO02J
     C                   MOVE      GNO03         GNO03J
     C                   MOVE      GNO04         GNO04J
     C                   MOVEL     GDN03         GDN03J
     C                   END
     C                   OTHER
     C                   MOVE      *ON           F4ERR
     C                   ENDSL                                                  CFLD
      *
     C     *IN42         IFEQ      *OFF
     C                   MOVE      *ON           *IN72                          SFLNXTCHG
     C                   UPDATE    APS1112J
     C                   ENDIF                                                  *IN42
      *
     C     CRCD          WHENEQ    'APS1112O'
     C     CRRN          CHAIN     APS1112O                           42
      *
     C                   SELECT
     C     CFLD          WHENEQ    'SELO'
     C                   MOVE      *BLANKS       VALUE#
     C                   CALL      'TBR0060'     PL0060                         TABLE FILE\ACTION
     C     VALUE#        IFNE      *BLANKS
     C                   MOVEL     VALUE#        SELO
     C                   ENDIF
     C                   OTHER
     C                   MOVE      *ON           F4ERR
     C                   ENDSL                                                  CFLD
      *
     C     *IN42         IFEQ      *OFF
     C                   UPDATE    APS1112O
     C                   ENDIF                                                  *IN42
      *
     C     CRCD          WHENEQ    'APS1112P'
     C     CRRN          CHAIN     APS1112P                           42
      *
     C                   SELECT
     C     CFLD          WHENEQ    'DN03P'
     C     DN03P         IFEQ      *BLANKS
     C                   MOVE      *ON           *IN94
     C                   MOVEA     EMS(39)       MSGFLD
     C     *IN42         IFEQ      *OFF
     C                   MOVE      SVIN28        *IN28
     C                   MOVE      SVIN55        *IN55
     C                   UPDATE    APS1112P
     C                   GOTO      #PRMPT
     C                   ENDIF                                                  *IN42
     C                   ENDIF
     C                   MOVE      '0'           RTCOD                          RETURN CODE
     C                   MOVE      APCO#F        GNO01                          COMPANY #
     C                   MOVE      *BLANKS       GNO06                          BRANCH #
     C                   MOVE      *BLANKS       GNO02                          DEPARTMENT
     C                   MOVE      *BLANKS       GNO03                          MAIN ACCOUNT
     C                   MOVE      *BLANKS       GNO04                          SUB  ACCOUNT
     C                   MOVEL     DN03P         GDN03                          NAME
     C                   CALL      'GLR2021'     PL2021
     C     RTCOD         IFEQ      '0'                                                         B2
     C                   MOVE      GNO06         NO06P
     C                   MOVE      GNO02         NO02P
     C                   MOVE      GNO03         NO03P
     C                   MOVE      GNO04         NO04P
     C                   MOVEL     GDN03         DN03P
     C                   ENDIF
     C                   OTHER
     C                   MOVE      *ON           F4ERR
     C                   ENDSL                                                  CFLD
      *
     C     *IN42         IFEQ      *OFF
     C                   MOVE      SVIN28        *IN28
     C                   MOVE      SVIN55        *IN55
     C                   UPDATE    APS1112P
     C                   ENDIF                                                  *IN42
      *
     C     CRCD          WHENEQ    'APS1112Q'
     C     CRRN          CHAIN     APS1112Q                           42
      *
     C                   SELECT
     C     CFLD          WHENEQ    'SELQ'
     C                   MOVE      *BLANKS       VALUE#
     C                   CALL      'TBR0060'     PL0060                         TABLE FILE\ACTION
     C     VALUE#        IFNE      *BLANKS
     C                   MOVEL     VALUE#        SELQ
     C                   ENDIF
     C                   OTHER
     C                   MOVE      *ON           F4ERR
     C                   ENDSL                                                  CFLD
      *
     C     *IN42         IFEQ      *OFF
     C                   UPDATE    APS1112Q
     C                   ENDIF                                                  *IN42
      *
     C     CRCD          WHENEQ    'APF1112U'
     C                   SELECT
     C     CFLD          WHENEQ    'CD68'
     C                   MOVE      'AP18'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   CALL      'TBR0025'     PL0025
     C     TBNO02        IFNE      *BLANKS
     C                   MOVEL     TBNO02        CD68
     C                   MOVEL     TBNO03        CD68DS
     C                   ENDIF
     C     CFLD          WHENEQ    'NO53'
D2    * Use alternate vendor...
D2   C     NO25C         IFNE      *ZEROS
D2   C                   Z-ADD     NO25C         VND_KEY
D2    * Use invoice vendor...
D2   C                   ELSE
D2   C                   Z-ADD     NO01C         VND_KEY
D2   C                   ENDIF
     C                   CALL      'APR0126'     PL0126
     C     NO53C         IFNE      *BLANKS
     C                   MOVE      NO53C         NO53
     C                   MOVE      BKDESC        NO53DS
     C                   ENDIF
     C     CFLD          WHENEQ    'CD60'
     C                   MOVE      'I'           MODE
D2    * Use alternate vendor...
D2   C     NO25C         IFNE      *ZEROS
D2   C                   Z-ADD     NO25C         VND_KEY
D2    * Use invoice vendor...
D2   C                   ELSE
D2   C                   Z-ADD     NO01C         VND_KEY
D2   C                   ENDIF
     C                   CALL      'APR0131'     PL0131
     C     CD60C         IFNE      *BLANKS
     C                   MOVE      CD60C         CD60
     C                   MOVE      TXDESC        CD60DS
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDSL                                                  CRCD
      *
     C                   ELSE
     C                   MOVE      *ON           F4ERR
     C                   ENDIF                                                  CPOS
      *
      * SEND ERROR MESSAGE - CURSOR LOCATION INVALID
      *
     C     F4ERR         IFEQ      *ON
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(41)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     ROW           CROW                           REPOSITION
     C                   Z-ADD     COL           CCOL                           CURSOR
      *
     C     #PRMPT        ENDSR
      *------------------------------------------------------------------------*
      *  @CURSR - SUBROUTINE: RETREIVE CURSOR LOCATION
      *------------------------------------------------------------------------*
     C     @CURSR        BEGSR
      *
     C     C@LOC         DIV       256           ROW
     C                   MVR                     COL
     C                   Z-ADD     ROW           CROW
     C                   Z-ADD     COL           CCOL
     C                   MOVE      ROW           ROW#              3
     C                   MOVE      COL           COL#              3
     C     ROW#          CAT       COL#          C@LOC#            6
     C                   MOVEL     CRCD          CRCD#
     C                   MOVEL     CFLD          CFLD#
      *
     C                   ENDSR
      *----------------------------------------------------------------
      *  @CLCRS - CLEAR CURSOR LOCATION KEYWORD
      *----------------------------------------------------------------
     C     @CLCSR        BEGSR
     C                   Z-ADD     0             CROW                           CLEAR
     C                   Z-ADD     0             CCOL                           CRSLOC
     C     #CLCSR        ENDSR
      *----------------------------------------------------------------
      * SEND V/R DATA FOR WAREHOUSE INTERFACE
      *----------------------------------------------------------------
     C     SENDWM        BEGSR
     C                   MOVE      'RQ'          TYPE
     C                   MOVEL     PONO27        TRANS#
     C                   MOVEL     PONO32        TRNLIN
     C                   CALL      'WXR5908'     PL5908
     C                   ENDSR
DD    *------------------------------------------------------------------------*
DD    *  SUBROUTINE TO UPDATE P.O LOT DETAIL FOR CREDIT INVOICE
DD    *------------------------------------------------------------------------*
DD   C     SRLOT         BEGSR
ED    *-------------------------------------------------------------------
ED    * Back out the original amount that was referenced...
ED    *-------------------------------------------------------------------
ED   C     ORG_REFCTL    IFNE      *ZEROS
ED   C     ORG_REFCTL    CHAIN     APFTINH0                           40
ED   C     *IN40         IFEQ      *ON
ED   C     ORG_REFCTL    CHAIN     APFWINH5                           40
ED   C                   ENDIF
ED    * Only update if original referenced invoice is for job lot...
ED   C     *IN40         IFEQ      *OFF
ED   C     AXCD45        ANDEQ     'L'
ED   C     AXNO35        CHAIN     POLTOL1                            40
ED   C     *IN40         IFEQ      *OFF
ED   C                   SUB       ORG_APAM04    POAM38
ED   C                   EXCEPT    POLREC
ED   C                   ENDIF
ED    *
ED   C                   ENDIF
ED   C                   ENDIF
ED    *-------------------------------------------------------------------
ED    * If referenced to a job lot invoice update the invoiced to date...
ED    *-------------------------------------------------------------------
DD    *
DD   C     SKIPPO        IFEQ      'Y'
ED   C     *IN11         ANDEQ     *OFF
DD   C     APNO26        ANDNE     *BLANKS
DD   C     REFCTL        CHAIN     APFTINH0                           40
DD   C     *IN40         IFEQ      *ON
DD   C     REFCTL        CHAIN     APFWINH5                           40
DD   C                   ENDIF
ED    * Only update if referenced invoice is for job lot...
DD   C     *IN40         IFEQ      *OFF
DD   C     AXCD45        ANDEQ     'L'
DD   C     AXNO35        CHAIN     POLTOL1                            40
DD   C     *IN40         IFEQ      *OFF
DD EDC*    *IN11         IFEQ      *OFF
DD EDC*                  SUB       SVAM04        POAM38
DD   C                   ADD       APAM04        POAM38
DD EDC*                  ELSE
DD EDC*                  SUB       APAM04        POAM38
DD EDC*                  ENDIF
DD   C                   EXCEPT    POLREC
DD   C                   ENDIF
DD   C                   ENDIF
DD   C                   ENDIF
DD    *
DD   C                   MOVE      *IN92         SVIN92            1
DD   C                   UNLOCK    POLTOL1                              92
DD   C                   MOVE      SVIN92        *IN92
DD    *
DD   C                   ENDSR
DT    *------------------------------------------------------------------------*
DT    * LOAD EXISTING FREIGHT MATCHING INTO WORK FIELDS.
DT    * This subroutine is only executed when you go in to maintain
DT    * existing invoice that has freight matching.
DT    *------------------------------------------------------------------------*
DT   C     LOAD_FRT      BEGSR
DT    * Remove any existing work information for this invoice...
DT   C                   EXSR      RMVMTH_FRT
DT    * Load receivers that are currently matched to this invoice...
DT   C     NO20C         SETLL     POFTRHD
DT   C                   DOU       %EOF
DT   C                   MOVE      *BLANKS       DSPF1
DT   C     *IN92         DOUEQ     *OFF
DT   C     NO20C         READE     POFTRHD                              92
DT   C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
DT   C                   ENDCS
DT   C                   ENDDO
DT    * If no more records, get outta here...
DT   C                   IF        %EOF
DT   C                   LEAVE
DT   C                   ENDIF
DT   C                   EVAL      APNO64 = NO20C
DT   C                   EVAL      APAM49 = APAM47
DT   C                   EVAL      APAM50 = APAM48
DT   C                   EXCEPT    LMTH_F
DT   C                   ENDDO
DT   C                   ENDSR
DT    *------------------------------------------------------------------------*
DT    * REMOVE EXISTING WORK INFORMATION FROM RECEIVER HEADERS THAT
DT    * CONTAIN THIS A/P INVOICE CONTROL NUMBER.
DT    *------------------------------------------------------------------------*
DT   C     RMVMTH_FRT    BEGSR
DT   C     NO20C         SETLL     POFTRHC
DT   C                   DOU       %EOF
DT   C                   MOVE      *BLANKS       DSPF1
DT   C     *IN92         DOUEQ     *OFF
DT   C     NO20C         READE     POFTRHC                              92
DT   C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
DT   C                   ENDCS
DT   C                   ENDDO
DT    * If not found, get outta here...
DT   C                   IF        %EOF
DT   C                   LEAVE
DT   C                   ENDIF
DT    * Remove 'work' information...
DT   C                   CLEAR                   APNO64
DT   C                   CLEAR                   APAM49
DT   C                   CLEAR                   APAM50
DT   C                   IF        APCD78 = 'I'
DT   C                   CLEAR                   APCD78
DT   C                   ENDIF
DT   C                   EXCEPT    RMTH_F
DT   C                   ENDDO
DT    *
DT   C                   ENDSR
DT    *------------------------------------------------------------------------*
DT    * REMOVE ALL EXISTING MATCHING FROM RECEIVER HEADERS THAT
DT    * CONTAIN THIS A/P INVOICE CONTROL NUMBER.
DT    *------------------------------------------------------------------------*
DT   C     DLTMTH_FRT    BEGSR
DT    * Remove work information...
DT   C                   EXSR      RMVMTH_FRT
DT    * Remove original matching...
DT   C     NO20C         SETLL     POFTRHD
DT   C                   DOU       %EOF
DT   C                   MOVE      *BLANKS       DSPF1
DT   C     *IN92         DOUEQ     *OFF
DT   C     NO20C         READE     POFTRHD                              92
DT   C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
DT   C                   ENDCS
DT   C                   ENDDO
DT    * If not found, get outta here...
DT   C                   IF        %EOF
DT   C                   LEAVE
DT   C                   ENDIF
DT    * Remove original matching information...
DT   C                   IF        APCD78 <> 'M'
DT   C                   CLEAR                   APNO63
DT   C                   CLEAR                   APAM47
DT   C                   CLEAR                   APAM48
DT   C                   CLEAR                   APCD78
DT   C                   EXCEPT    DMTH_F
DT   C                   ENDIF
DT   C                   ENDDO
DT    *
DT   C                   ENDSR
DT    *------------------------------------------------------------------------*
DT    * WRITE FREIGHT MATCHING INFORMATION
DT    * This subroutine is only executed from the write subroutine.
DT    *------------------------------------------------------------------------*
DT   C     WRITE_FRT     BEGSR
DT    * Read original matching and if no longer matched, remove the
DT    * match information from the receiver header...
DT   C     NO20C         SETLL     POFTRHD
DT   C                   DOU       %EOF
DT   C                   MOVE      *BLANKS       DSPF1
DT   C     *IN92         DOUEQ     *OFF
DT   C     NO20C         READE     POFTRHD                              92
DT   C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
DT   C                   ENDCS
DT   C                   ENDDO
DT    * If no more records, get outta here...
DT   C                   IF        %EOF
DT   C                   LEAVE
DT   C                   ENDIF
DT    * If the 'work' control number is zeros that means the user
DT    * removed the matching...
DT   C                   IF        APNO64 = *ZEROS
DT   C                             AND APCD78 <> 'M'
DT   C                   CLEAR                   APNO63
DT   C                   CLEAR                   APAM47
DT   C                   CLEAR                   APAM48
DT   C                   CLEAR                   APCD78
DT   C                   EXCEPT    DMTH_F
DT   C                   ENDIF
DT   C                   ENDDO
DT    * Read the current matching and update the receiver headers...
DT   C     NO20C         SETLL     POFTRHC
DT   C                   DOU       %EOF
DT   C                   MOVE      *BLANKS       DSPF1
DT   C     *IN92         DOUEQ     *OFF
DT   C     NO20C         READE     POFTRHC                              92
DT   C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
DT   C                   ENDCS
DT   C                   ENDDO
DT    * If not found, get outta here...
DT   C                   IF        %EOF
DT   C                   LEAVE
DT   C                   ENDIF
DT    * Load matching information...
DT   C                   IF        APCD78 <> 'M'
DT   C                   EVAL      APCD78 = 'W'
DT   C                   EVAL      APNO63 = APNO64
DT   C                   EVAL      APAM47 = APAM49
DT   C                   EVAL      APAM48 = APAM50
DT    * Remove 'work' information...
DT   C                   CLEAR                   APNO64
DT   C                   CLEAR                   APAM49
DT   C                   CLEAR                   APAM50
DT   C                   EXCEPT    WMTH_F
DT   C                   ENDIF
DT   C                   ENDDO
DT    *
DT   C                   ENDSR
EK    *------------------------------------------------------------------------*
EK    * OPEN REBATE FILES
EK    *------------------------------------------------------------------------*
EK   C     OPEN_RB       BEGSR
EK   C                   IF        not %OPEN(POLWRBM1)
EK   C                   OPEN      POLWRBM1
EK   C                   ENDIF
EK   C                   IF        not %OPEN(POLTRBM1)
EK   C                   OPEN      POLTRBM1
EK   C                   ENDIF
EK   C                   ENDSR
EK    *------------------------------------------------------------------------*
EK    * Delete records from rebate matching work file.
EK    *------------------------------------------------------------------------*
EK   C     DEL_WRBM      BEGSR
EK   C                   EXSR      OPEN_RB
EK   C                   DOU       not %FOUND(POLWRBM1)
EK   C                   CLEAR                   DSPF1
EK   C                   DOU       not %ERROR
EK   C     K_WRBM1       DELETE(E) POFWRBM
EK   C                   IF        %ERROR
EK   C                   EXSR      UNLOCK
EK   C                   ENDIF
EK   C                   ENDDO
EK   C                   ENDDO
EK   C                   ENDSR
EK    *------------------------------------------------------------------------*
EK    * Delete records from rebate matching transaction file.
EK    *------------------------------------------------------------------------*
EK   C     DEL_TRBM      BEGSR
EK   C                   EXSR      OPEN_RB
EK   C                   DOU       not %FOUND(POLTRBM1)
EK   C                   CLEAR                   DSPF1
EK   C                   DOU       not %ERROR
EK   C     K_WRBM1       DELETE(E) POFTRBM
EK   C                   IF        %ERROR
EK   C                   EXSR      UNLOCK
EK   C                   ENDIF
EK   C                   ENDDO
EK   C                   ENDDO
EK   C                   ENDSR
EK    *------------------------------------------------------------------------*
EK    * Read rebate matching work file and write
EK    * to rebate matching transaction file.
EK    *------------------------------------------------------------------------*
EK   C     WRBM_TO_TRBM  BEGSR
EK   C     K_WRBM1       SETLL     POLWRBM1
EK    *
EK   C                   DOU       %EOF(POLWRBM1)
EK    *
EK   C                   CLEAR                   DSPF1
EK   C                   DOU       not %ERROR
EK   C     K_WRBM1       READE(E)  POLWRBM1
EK   C                   IF        %ERROR
EK   C                   EXSR      UNLOCK
EK   C                   ENDIF
EK   C                   ENDDO
EK    *
EK   C                   IF        not %EOF(POLWRBM1)
EK   C                   EVAL      RB_GLFL05 = 'E'
EK   C                   CLEAR                   RB_GLCD13
EK   C                   CLEAR                   RB_GLNO05
EK   C                   EVAL      RB_POMO64 = APMO04
EK   C                   EVAL      RB_PODY64 = APDY04
EK   C                   EVAL      RB_POCC64 = APCC04
EK   C                   EVAL      RB_POYR64 = APYR04
EK   C                   Z-ADD     UMONTH        RB_APMO01
EK   C                   Z-ADD     UDAY          RB_APDY01
EK   C                   MOVEL     *YEAR         RB_APCC01
EK   C                   Z-ADD     UYEAR         RB_APYR01
EK   C                   MOVEL     USRNM         RB_APNM04
EK   C                   WRITE     POFTRBM
EK   C                   DELETE    POFWRBM
EK   C                   ENDIF
EK    *
EK   C                   ENDDO
EK   C                   ENDSR
EJ    *------------------------------------------------------------------------*
EJ    * Load fields from referenced invoice for credit/debit memo.
EJ    *------------------------------------------------------------------------*
EJ   C     LOAD_REF      BEGSR
EJ   C     REFCTL        CHAIN     APFTINH0
EJ   C                   IF        not %FOUND
EJ   C     REFCTL        CHAIN     APFWINH5
EJ   C                   IF        not %FOUND
EJ   C                   LEAVESR
EJ   C                   ENDIF
EJ   C                   ENDIF
EJ   C                   MOVE      *ON           *IN35
EJ   C                   Z-ADD     AXNO25        NO25C
EJ   C                   Z-ADD     AXNO25        HO25C
EJ   C                   MOVE      AXAD04        AD04C
EJ   C                   MOVE      AXAD05        AD05C
EJ   C                   MOVE      AXAD06        AD06C
EJ   C                   MOVE      AXCY02        CY02C
EJ   C                   MOVE      AXST02        ST02C
EJ   C                   MOVE      AXZP08        ZP08C
EJ   C                   EXSR      RMTADD
EJ   C                   MOVE      *ON           *IN83
EJ   C                   MOVE      *ON           *IN91
EJ   C                   MOVE      *ON           *IN88
EJ   C                   MOVE      *ON           *IN95
EJ   C                   MOVE      *ON           *IN67
EJ   C                   MOVE      *ON           *IN63
EJ   C                   MOVE      *ON           *IN31
EJ   C                   Z-ADD     AXNO16        APBR#C
EJ   C                   Z-ADD     AXNO38        NO38C
EJ   C                   Z-ADD     AXMO06        DUEMO
EJ   C                   Z-ADD     AXDY06        DUEDY
EJ   C                   Z-ADD     AXCC06        DUECC
EJ   C                   Z-ADD     AXYR06        DUEYR
EJ   C                   Z-ADD     AXMO11        DSCMO
EJ   C                   Z-ADD     AXDY11        DSCDY
EJ   C                   Z-ADD     AXCC11        DSCCC
EJ   C                   Z-ADD     AXYR11        DSCYR
EJ    * Load ACH fields...
EJ   C                   MOVE      AXCD67        CD67
EJ   C                   MOVE      AXCD68        CD68
EJ   C                   Z-ADD     AXNO53        NO53
EJ   C                   MOVE      AXNO53        NO53C
EJ   C                   MOVE      AXCD60        CD60
EJ   C                   Z-ADD     AXMO21        PPMO
EJ   C                   Z-ADD     AXDY21        PPDY
EJ   C                   Z-ADD     AXCC21        PPCC
EJ   C                   Z-ADD     AXYR21        PPYR
EJ    * If payment type is not draft, turn off draft indicator...
EJ   C     CD67          IFNE      'D'
EJ   C                   MOVE      *OFF          *IN36
EJ   C                   ENDIF
EJ    *
EJ   C                   EXSR      LODGLA
EJ   C                   EVAL      MSGFLD = 'Fields were defaulted from the +
EJ   C                             referenced invoice.'
EJ   C                   ENDSR
      *------------------------------------------------------------------------*
¢F    * Create Check Notes for Customer Deposit Refunds
¢F    *------------------------------------------------------------------------*
¢F     BegSr srWrtCkNot;
¢F
¢F         Reset cknotfnd;
¢F         exec sql
¢F          Select '0'
¢F          into :cknotfnd
¢F          from apptinn
¢F          Where APNO01 = :NO01C
¢F          And APNO11 = :NO11C
¢F          And APNO20 = :NO20C
¢F          And APCD65 = '2'
¢F          And APTX01 = 'REFUND FOR DEPOSIT ON YOUR EAST COAST ACCOUNT'
¢F          with NC;
¢F
¢F         If cknotfnd;
¢F         apcd65 = '2';
¢F         APTX01 = 'REFUND FOR DEPOSIT ON YOUR EAST COAST ACCOUNT';
¢F         Write apftinn;
¢F         Endif;
¢F
¢F     EndSr;
¢F    *------------------------------------------------------------------------*
¢F    * Create Check Notes for Customer Deposit Refunds
¢F    *------------------------------------------------------------------------*
¢F     BegSr srDltCkNot;
¢F      exec sql
¢F         Delete from APPTINN
¢F         Where APNO01 = :NO01C
¢F         And APNO11 = :NO11C
¢F         And APNO20 = :NO20C
¢F         And APCD65 = '2'
¢F         And APTX01 = 'REFUND FOR DEPOSIT ON YOUR EAST COAST ACCOUNT';
¢F     EndSr;
¢F    *------------------------------------------------------------------------*
¢J    * Lookup the Default Bank Information from the Table File
¢J    *------------------------------------------------------------------------*
¢J     BegSr srDftBnk;
¢J
¢J    *  Use screen company number to set up table file TBN002 ****
¢J        BNKCO = %CHAR(%EDITC(APCO#F:'X'));
¢J        SELECT;
¢J         WHEN CD67 = 'A';
¢J           BNKTYP = 'ACH';
¢J         OTHER;
¢J           BNKTYP = 'CHK';
¢J        ENDSL;
¢J
¢J        TBNO01 = 'APBK';
¢J        TBNO02 = BNKMST;
¢J        TBNO03 = *BLANKS;
¢J   C                   CALL      'TBR0040'     TB0040
¢J
¢J        If TBNO03 = *blanks;
¢J             NO38C = 0;
¢J        Else;
¢J             NO38C = %INT(%SUBST(TBNO03:1:2));
¢J        Endif;
¢J
¢J     EndSr;
¢J    *------------------------------------------------------------------------*
      *------------------------------------------------------------------------*
DD   OPOFTOL    E            POLREC
DD   O                       POAM38
     OPOFTRH    E            UNLTRH
     OPOFTRH    E            UPDTRH
     O                       POCD24
     OPOFTRD1   E            UPDRD1
     O                       PONO24
     O                       POQY38
     O                       POQY39
     OAPFTINH1  E            RELAPH
     OPOFTVRH   E            UNLVRH
     OPOFTVRH   E            UPDVRH
     O                       POFL06
     OPOFTVRL   E            UPDRL1
     O                       PONO24
     O                       POQY38
     O                       POQY39
     OPOFTVRO   E            UPDVRO
     O                       PONO24
     O                       POAM51
     O                       POAM52
     OAPFWMTH5  E            UPDSEL
     O                       MHSEL
     OAPFWMTH4  E            UPMTH4
     O                       MHAM31
     O                       MHCD53
     O                       MHDN06
     O                       MHCD49
     O                       MHCD50
DT    *
DT   OPOFTRHD   E            DMTH_F
DT   O                       APCD78
DT   O                       APNO63
DT   O                       APAM47
DT   O                       APAM48
DT    *
DT   OPOFTRHD   E            LMTH_F
DT   O                       APNO64
DT   O                       APAM49
DT   O                       APAM50
DT    *
DT   OPOFTRHC   E            RMTH_F
DT   O                       APCD78
DT   O                       APNO64
DT   O                       APAM49
DT   O                       APAM50
DT    *
DT   OPOFTRHC   E            WMTH_F
DT   O                       APCD78
DT   O                       APNO63
DT   O                       APAM47
DT   O                       APAM48
DT   O                       APNO64
DT   O                       APAM49
DT   O                       APAM50
      *------------------- TABLE FILE CHANGE AREA -----------------------------*
DK    * ADDED UMS ENTRY 36
DL    * ADDED EMS 125
DP    * Added UMS entries 37 through 39
DT    * Added entries 7 thru 12 to STS.
DT    * Added EMS entries 129 thru 132.
DT    * Changed EMS entry 51 as follows;
DT    * Before...
DT    * Freight in only not allowed if skip match is Y.
DT    * After...
DT    * Freight in only not allowed if skip match is Y and match freight is N.
DU    * Added EMS, 133:
DU    * Vendor return is pending. Match not allowed.                           1
¢e    * Added CMS entry 1                                                             33
      *------------------------------------------------------------------------*
**
SBMJOB JOB(APPROVAL) JOBD(HDJPACK) RQSDTA('CALL PGM
(APC2070)') JOBQ(*JOBD     )
**
Variance Accepted
  Variance Hold
  Payment Hold
   Manual Hold
 EDI Error Hold
 EDI Wait Hold
Purch Var Hold
  Frt Var Hold
 Both Var Hold
Pur Var Accepted
Frt Var Accepted
Both Var Accepted
** EMS
Press F3 again to exit invoice entry.                                          1
Batch contains invoices, cannot delete.                                        2
Batch already in use.                                                          3
Press enter again for a new batch.                                             4
Batch number not found.                                                        5
Invalid company number.                                                        6
Press F12 again to prevent update.                                             7
Press F11 again to delete.                                                     8
Invalid date.                                                                  9
Not authorized to this company number.                                        10
Invalid branch number.                                                        11
You cannot delete an invoice that references an approved invoice.             12
Invoice number required.                                                      13
Duplicate invoice number not allowed.                                         14
Date required.                                                                15
Date invalid.                                                                 16
Due date cannot be less than invoice date.                                    17
Bank is closed.                                                               18
Bank is not an A/P bank.                                                      19
Not authorized to this bank.                                                  20
Bank is invalid.                                                              21
Vendor return not allowed with invoice.                                       22
Warning! Invoice date is greater than system date.                            23
Invalid G/L account.                                                          24
Must use accrued inventory payables when match to inventory receiver.         25
Department number required.                                                   26
Accounting period closed.                                                     27
                                                                              28
Alternate vendor is invalid.                                                  29
No invoice with this number found that is eligible for reference.             30
Reference invoice does not exist.                                             31
Multiple invoices exist with this number, selection required.                 32
All manual check information required.                                        33
Invalid check date.                                                           34
Negative check number not allowed.                                            35
Vendor or date different than original.                                       36
Check number entered previously voided. Invalid entry.                        37
Negative check not allowed.                                                   38
Entry required for account description prompt.                                39
G/L not selected.                                                             40
Invalid cursor location for F4=Prompt.                                        41
Amount not allowed for a no-charge invoice.                                   42
Net amount must not be zero.                                                  43
Invalid remittance address.                                                   44
Press F8 to enter remittance address.                                         45
Enter Y or N.                                                                 46
Enter Y, N, or leave blank.                                                   47
Receiver number cannot be entered if skip match is a Y.                       48
Direct must be N if Skip Match is Y.                                          49
Branch number must be entered if skip match is Y.                             50
Freight in only not allowed if skip match is Y and match freight is N.        51
Purchase order not found.                                                     52
Freight out not allowed for non direct purchase order.                        53
Amount and account number required.                                           54
G/L distributions do not equal gross invoice amount.                          55
Enter a name to use unapproved vendor.                                        56
Receiver not found.                                                           57
P/O closed.                                                                   58
Vendor not found.                                                             59
Invalid request. Enter either a name or telephone search.                     60
Enter the area code and telephone prefix.                                     61
To scan search, enter part of the vendor name.                                62
Telephone number not found.                                                   63
Vendor name not found.                                                        64
Discount entered for debit memo - review amount and percent.                  65
Manual check not allowed if manual, variance or payment hold.                 66
Warning! Invoice held due to freight out with skip match = Y.                 67
Total not available since no invoices entered in batch.                       68
Batch recap report submitted.                                                 69
Number of invoices must equal calculated number.                              70
Batch amount must equal calculated amount.                                    71
Press enter again to post batch.                                              72
Freight payments do not equal freight charges.                                73
Tax payments do not equal tax charges.                                        74
Discount payments do not equal total discounts.                               75
Payments do not equal net invoice amount.                                     76
Gross payments do not equal total gross purchase.                             77
Warning! Payment dates not within the invoice date and due date.              78
Receiver not allowed with freight only invoice.                               79
Purchase order required for freight only invoice.                             80
Accrued inventory payables not allowed if not matching to inventory receiver. 81
Invoice not eligible for maintenance or not found.                            82
Not authorized to invoice.                                                    83
No open lines found, match not allowed.                                       84
                                                                              85
Vendor return not found.                                                      86
Vendor return is closed.                                                      87
                                                                              88
                                                                              89
Invalid invoice type.  Enter I=invoice, C=credit, D=debit.                    90
Must use vendor return receivable account when matching to vendor return.     91
Vendor return receivable account not allowed if not matching to vendor return.92
Vendor return number cannot be entered if skip match is a Y.                  93
Vendor return number cannot be entered if no charge invoice.                  94
Invalid split code.  Enter 'S' or leave blank.                                95
                                                                              96
G/L account must be vendor return receivable if matching to vendor return.    97
Warning!  Other charge variance exists.                                       98
Vendor return locked for maintenance.  No vendor return match done.           99
Vendor return(s) locked for maintenance.  No maintenance allowed.             00
Invalid reason code.                                                          01
Reason code required.                                                         02
A/P image control number required.                                            03
A/P image control number already exists.                                      04
Payment type required.                                                        05
Vendor not flagged to do ACH transactions.                                    06
Vendor not flagged to do ACH tax transactions.                                07
                                                                              08
Valid transaction code required. Press F4 to prompt.                          09
Valid vendor bank required. Press F4 to prompt.                               10
Valid payment type code required. Press F4 to prompt.                         11
Valid payment period date required.                                           12
ACH pre-notes are for a bank test run. Only zero dollar invoices allowed.     13
Payment type 'E' is only allowed for EDI vendors.                             14
Payment type 'D' is only allowed for draft vendors.                           15
Payment type 'A' is only allowed for ACH vendors.                             16
Payment type 'P' is only allowed for ACH vendors.                             17
Payment type 'R' not allowed for EDI vendors.                                 18
Payment type 'R' not allowed for draft vendors.                               19
Manual check not allowed through invoice maintenance.                         20
Warning! A/P period is less than A/R period. Invoice will not be approved.    21
Invoice matched to P/O for associated vendor.  Press enter to continue.       22
Invoice matched to V/R for associated vendor.  Press enter to continue.       23
Not authorized to change P/O vendor.                                          24
Skip matching must be set to 'Y' for consignment invoicing.                   25
                                                                              26
                                                                              27
                                                                              28
Skip match and match freight flags re-loaded for 3rd party freight invoice.   29
Amount not allowed for 3rd party freight invoice.                             30
Must use accrued freight payables when matching to freight only.              31
G/L account changed for match freight change.                                 32
Vendor return is pending. Match not allowed.                                  33
** UMS
Date entered cannot be greater than nor less than one year from current year.  1
Accounting period cannot be less than current period.                          2
Check date cannot be less than current period.                                 3
Warning!  Invoice bank company not the same as the invoice company.            4
                                                                               5
Cannot approve invoice due to referencing items on hold.                       6
You cannot reference an invoice that references another invoice.               7
                                                                               8
                                                                               9
You cannot delete an invoice that is referenced.                              10
                                                                              11
                                                                              12
                                                                              13
Reference not allowed when matching.                                          14
G/L account changed for blanket/overhead P/O.                                 15
G/L account changed for inventory P/O.                                        16
G/L account changed for skip P/O change.                                      17
Data changed for credit/debit not referenced.                                 18
Data changed for credit/debit referenced to invoice.                          19
Vendor return is open.  Match not allowed.                                    20
A/P trade account not allowed.                                                21
A/R trade account not allowed.                                                22
Reference not allowed for invoice.                                            23
Purchase order vendor not same as invoice vendor.                             24
Vendor return vendor not same as invoice vendor.                              24
G/L account changed for vendor return change.                                 26
F15=Variance not allowed.  No matching found.                                 27
Non posting account not allowed.                                              28
Other charges payments do not equal total other charges.                      29
Warning!  Skip match is Y for EDI invoice.                                    30
Warning! Direct invoice has freight in amount.                                31
Receiver locked for maintenance.  No receiver match done.                     32
Receiver(s) locked for maintenance.  No maintenance allowed.                  33
Vendor return receivable account not allowed.                                 34
Accrued inventory payable account not allowed.                                35
F14=Match info not allowed.  No matching found.                               31
This branch is for a different company than the A/P invoice company.          37
The po/receiver is for a different company than the A/P invoice company.      38
The vendor return is for a different company than the A/P invoice company.    39
** HDG
Select Purchase Order For Notes
Select Purchase Order For Terms
Display Matched Purchase Orders
Select Vnd Return Other Charges
Display Matched Vendor Returns
** FMS
 P/O has Prepaid                                                               1
 P/O has Collect                                                               2
** CMS
Untagged Direct PO# disallowed for Invoice Matching                     year.  1
