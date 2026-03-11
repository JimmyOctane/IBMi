¢8   H OPTION(*SRCSTMT: *NODEBUGIO)
     H dftactgrp( *no ) bnddir( 'QC2LE')
       ctl-opt bnddir('SHBIND':'WMBIND':'HDBIND':'WKBIND':'MNBIND':'YAJL'
         :'ECBIND');
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - ARR5015                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D CUSTOMER MASTER FILE MAINTENANCE                                      *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    This program maintains customer master file records.               *
     F*S    Customer name and address, salesperson, and control info           *
     F*S    for credit, pricing, and other processing are entered/updated      *
     F*S    Customer accounts can also be created (one per company).           *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S    The user's USERID controls which company account records are       *
     F*S    displayed/updated using table file UIDS.                           *
     F*S IMPORTANT: IF YOU MAKE CHANGES TO THIS PROGRAM, YOU MUST            *
     F*S   ALSO CHECK ENTERPRISE MASTER MAINTENANCE (ARR4515) FOR            *
     F*S   POSSIBLE CHANGES.                                                 *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
B4   F*U 1220001028 123005 144 CASH/CHARGE NOT MANDATORY                       *
B5   F*U 8000009832 013006 171 TAX JURISDICTION BY ZIP CODE CORRECTIONS        *
CA   F*U 1090000293 051806 248 PRINT/FAX/EMAIL NET PRICES                      *
CC   F*U 1090000343 061506 248 MUST FAX STMT TO USER F9 FAX INFO               *
CD   F*U 0930000256 031707 168 CUST CLOSED BUT ROE/WEB ACCT EXIST              *
CE   F*U 1430000310 102307 070 DISC EXISTS FOR CLOSED ENTERPRISE               *
CH   F*U 0420000932 010708 914 CUSTOMER SET UP WITH CLOSED BRANCH              *
CI   F*E 8000010203 032508 020 CUSTOMER RELATIONSHIP MANAGEMENT I              *
CJ   F*E 8000010205 062508 913 CREATE LIKE CUSTOMER                            *
CK   F*E 8000010469 072308 085 Add event to track new customers.               *
CL   F*E 1710000250 081408 085 Include Like Customer for new customer events.  *
CM   F*E 1710000274 101508 085 Event management fixes.                         *
CN   F*U 1430000407 101608 913 INTELLICHIEF INTERFACE FOR PACKAGE              *
CO   F*U 1230000808 102008 915 A/R AUDIT NOT TRACKING TERMS CD CHG             *
CP   F*U 1430000402 012009 102 CONNOT CLOSE CUSTOMER/COMPANY                   *
CQ   F*U 1110000526 120309 070 ARR5015 INCORRECT RELATIVE RECORD               *
CR   F*U 1430000455 121709 070 ID IS NOT SET UP FOR NOTES                      *
CS   F*U 8000010869 040510 070 CSR ID SHOULD NOT BE REQUIRED                   *
CU   F*E 9000000334 120310 070 MYHD CHANEGS                                    *
CV   F*U 1090000416 091911 183 Two users in notes maintenance                  *
CW   F*U 1090000457 111411 001 Customer email address inconsistency            *
CX   F*U 1220001446 111711 001 Tax exemption century not cleared               *
CY   F*E 8000010949 111811 915 W/C MENU AND OPTIONS IN MSS/HD                  *
CZ   F*E 8000011264 030812 271 IF BLANK ARFL64 CHANGE ARFL64 TO 'N'            *
C0   F*U 0970000477 110812 928 ADD F4=PROMPT TO MARKET CLASS FIELD             *
C1   F*E 8000011207 021213 915 PRINT TOTALS ON PICK TICKET                     *
C2   F*E 8000011288 030513 915 RESTRICT ABILITY TO OVERRIDE PRICES             *
C3   F*E 8000011227 051313 915 UNIVERSAL UPDATE OF SALESPERSON ID              *
C4   F*E 8000011586 031914 915 INTELLICHIEF LICENSE KEY CHECK                  *
DB   F*U 0970000604 031615 923 TAX JURISDICATION POP UP                        *
DC   F*U 1290000445 081817 070 DECIMAL DATA ERROR IN A/R PROGRAMS              *
DE   F*U 0100006041 062717 279 F23 IMAGE NOT DISPLAYED                         *
DD   F*U 8000012610 051217 915 Avalara AvaTax interface                        *
DF   F*E 8000012769 021218 282 Apache Forms - Acknowledgement                  *
DG   F*E 8000012747 021918 915 AvaTax parm changes - Tax override              *
DH   F*E 8000012817 031618 915 AvaTax - Taxable flag handling                  *
DI   F*E 1710000838 040918 404 Lickey err w/avatax if addr val=off             *
DJ   F*E 8000012921 051118 915 AvaTax correction #2                            *
DK   F*U 8000013078 090718 171 Credit limit not displayed                      *
DL   F*E 8000012870 091318 915 AvaTax addr val control by new setn             *
DM   F*E 8000012953 112018 915 Interface to CertCapture                        *
DN   F*E 8000013170 010319 915 Avatax usage type handling                      *
DP   F*E 8000013249 031819 915 Customer Market Type & Geo Territory validation *
DQ   F*E 8000013163 040919 168 WB - PRODUCT RANGE PCAR                         *
DS   F*U 8000013553 010720 020 Remove call to wm                               *
DT   F*U 1800000263 012820 070 CANNOT REMOVE ADDITIONAL SHIP TO                *
DU   F*E 1400000412 050620 171 Card on file for CardConnect                    *
DW   F*E 1290000727 100121 171 Worldpay - Credit card processing               *
DZ   F*U 1710001149 071222 035 Add Check of Open Deposits                      *
D0   F*E 1230001085 071322 404 Protect Customer Bank Info                      *
D1   F*U 1880000106 022723 035 Don't force entry of Market Class Type          *
D2   F*U 1710001179 050123 404 ABILITY TO PIN A/R FOLLOW UP NOTES              *
D5   F*C 1400000537 012924 321 STORE GEOCOORDINATES CUST BR ADDRES             *
EB   F*U 2030000134 032524 035 MOVE CHAIN TO AR17 TABLE ENTRY                  *
¢A   F*U JPF   1249 033000 RRB FUEL SURCHARGE                                  *
¢B   F*U JPF   1892 012403 KSB CUSTOMER COMMENTS                               *
¢C   F*U KSB   1893 012403 KSB VERIFY CUST ADDR IS VALID                       *
¢D   F*U KSB   1962 042203 KSB DISALLOW CONS FAX FLAG IF FAX INV = N           *
¢H   F*U KSB   1350 091703 KSB REQ TERMS IF CHARGE CUST                        *
¢I   F*U KSB   1350 091703 KSB REQ CREDIT REP FOR ALL CUST                     *
¢J   F*U KSB   2222 121503 KSB WRITE CONTRACT PRF RCD WHEN ADD CUST            *
¢N   F*U KSB   4855 081806 KSB VALIDATE SHIP TO ADDRESS                        *
¢O   F*U KSB   4893 121906 KSB Delete cont prf when cust is deleted            *
¢O   F*U KSB   4941 011707 KSB Delete cont prf when cust is deleted            *
¢P   F*U KSB   4949 012307 KSB Validate Mkt Type                               *
¢Q   F*U KSB   5144 011008 KSB Add Warranty Fee                                *
¢r   F*U KSB   5131 013008 KSB Add flag to turn on/off addr validation         *
¢s   F*U KSB   5167 020508 KSB Req value in Fuel Surcharge                     *
¢t   F*U KSB   5188 040808 KSB Req Price Levels 1 - 6                          *
¢W   F*C DCB   5334 051409 DCB ADD MMC Sls# Field & Charge Freight Flg         *
¢2   F*C ksb   5673 082511 ksb add honeywell contractor pro                    *
¢3   F*C DCB   5670 082311 DCB ADD CREDIT LIMIT AUDIT FILE                     *
¢4   F*C KSB   5708 011812 ksb fix honeywell cnt pro being cutoff              *
¢6   F*C ALA   5795 052912 ala Matrix pricing expansion                        *
¢7   F*C KSB   5870 103012 ksb add last review date fields                     *
¢8   F*C ALA   6170 081313 ALA ADD MMC IDENTIFIER IN PLACE OF EPDSLS FIELD     *
¢9   F*C DCB   7099 110615 DCB ADD SEND COD TO BILLTRUST                       *
$3   F*C RELEASE122 051118 DCB REMOVE PROMPT ON MARKET CLASS CODE              *
$4   F*C 0430000299 082019 097 put back TBR0025 plist                          *
$A   F*C DCB   7198 072319 DCB ADD EMAIL ADDRESS EDIT                          *
$B   F*C KSB   8065 022820 KSB Turn off IN60 after address validation          *
$C   F*C APB   9150 062220 APB Remove ¢O                                       *
$D   F*C APB   9152 062620 APB Run ARR9200 to set up all new customers in      *
$D   F*C                       CertCapture reguardless of being exepmpt or not *
$E   F*C DCB   7261 021021 DCB FIX *IN57 CONFLICT                              *
$F   F*C DCB   7277 062921 DCB ADD FKEY TO GO TO BOTTOM OF NOTES               *
¢G   F*C JJF   3001 051523 JJF rename field text and protect field Honeywell   *
¢G   F*C                       change honeywell text to Resideo Pro Perks      *
$H   F*C JJF   3015 062723 JJF add logic to control credit limit entry/change  *
$I   F*C CLP   5087 022627 CLP Updated Zip+4 validation indicator to avoid     *
$I   F*C                       conflict with Rel 12.3 Cube E upgrade changes   *
$J   F*C VLG   2072 021924 VLG add logic to protect statement print type field *
$J   F*C                       ARCD29 and default it to 'O' for non-walkin     *
$J   F*C                       customers (ARNO01 <> 0 or blanks                *
$K   F*C DCB   7374 052824 DCB ADD CALL TO ZIP VALIDATION PROGRAM IN ARRC104   *
$L   F*C JJF   3097 073024 JJF correct address 1 issue with address validation *
$M   F*C VLG   2081 050724 VLG Add validation on the customer sort name for    *
$M   F*C                       Hydros customer (Co 002) against the table file *
$M   F*C                       CLTY.                                           *
$N   F*C KSB   8187 091724 KSB Plug todays date and user id if notes are added *
$O   F*C VLG   2104 022625 VLG Add table file ARAM DFT001 to retreive the acct *
$O   F*C                       matrix defaults for the customer add            *
$P   F*C CLP   5163 010626 CLP Updatd the $J logic to do as described to       *
$P   F*C                       default ARCD29 to 'O' and protect it for all    *
$P   F*C                       customers except for the walkin customer        *
     F*M ----------------------------------------------------------------------*
     FPRLMCPF1  IF   E           K DISK
     FPRLMCPS4  IF   E           K DISK
     FPRLMDPH1  IF   E           K DISK
     FGLLMHDR1  IF   E           K DISK
     FARLTRAN2  IF   E           K DISK
     FARLTRAND  IF   E           K DISK
     F                                     RENAME(ARFTRAN:ARFTRAND)
     FARPHBAL   O    E             DISK
     FARLMBALA  UF A E           K DISK
     FARLEBAL1  IF   E           K DISK
     FARLMBCH1  IF   E           K DISK
     FARLMBCH4  IF   E           K DISK
     F                                     RENAME(ARFMBCH:ARFMBCH4)
CH   F                                     PREFIX(BR_)
     FARLMCUS1  UF A E           K DISK
     FARPWARM   UF   E           K DISK
     FARLMCON1  UF   E           K DISK
     FARLTNT9   UF A E           K DISK
     FARLMSLS4  IF   E           K DISK
     FARLMTAX1  IF   E           K DISK
     FOELTOH7   IF   E           K DISK
     FOELTOHY9  IF   E           K DISK
     FOELTOH19  IF   E           K DISK
     F                                     RENAME(OEFTOH:FTOH19)
     FOELTOLYC  IF   E           K DISK
     FOELTOLYJ  IF   E           K DISK
     F                                     RENAME(OEFTOL:OEFTOLJ)
     F                                     RENAME(OEFTOLY:OEFTOLYJ)
     FTBLMTBL1  IF   E           K DISK
     FARPTCSA   UF A E             DISK
¢3   FARPCCSA   O    E             DISK
     FOPLMSEC1  IF   E           K DISK
     FOPLMUPM4  IF   E           K DISK
CI   foplmupm1  if   e           k disk    rename(opfmupm : opfmupm1)
     FARLMCAD1  UF A E           K DISK
     FARLTOPN2  IF   E           K DISK
   C3F*ARLMJBM1  IF   E           K DISK
C3   FARLMJBM1  UF   E           K DISK
     FOELTOAH3  IF   E           K DISK
     FARLHBAL5  UF   E           K DISK
     F                                     RENAME(ARFHBAL:FHBAL)
     FARLMENT1  UF   E           K DISK
     FARLMFRQ1  UF A E           K DISK
     FOELMSCD1  IF   E           K DISK
     FOPLMEMA1  UF A E           K DISK
     FARLMTRH1  IF   E           K DISK
B5   FARLMZMF1  IF   E           K DISK
CD C3F*OELMCUS1  IF   E           K DISK
C3   FOELMCUS1  UF   E           K DISK
CP   FOELMUSR1  IF   E           K DISK
CY C3F*AILMCUS1  IF   E           K DISK
C3   FAILMCUS1  uF   E           K DISK
CY   FAILMUSR1  IF   E           K DISK
C3   FOELMUSR3  UF   E           K DISK    RENAME(OEFMUSR:OEFMUSR3)
C3   F                                     prefix(x)
C3   FAILMUSR4  UF   E           K DISK    RENAME(AIFMUSR:AIFMUSR4)
C3   F                                     prefix(y)
C3   FAILMRCF4  UF   E           K DISK    prefix(z)
C3   F
DQ   FARQMCUB   IF   E           K DISK    USROPN
DZ   FOELTDPB   IF   E           K DISK
D5   FARLMACO1  UF A E           K DISK
¢B   FARPCSCMT  UF A E           K DISK
¢J   FPRLMCPS2  UF A E           K DISK
¢J   F                                     RENAME(PRFMCPS:PRFCONT )
     FARD5015   CF   E             WORKSTN
     F                                     INFDS(FIL1DS)
     F                                     SFILE(ARS5015E:RNO)
     F                                     SFILE(ARS5015F:RN)
     F                                     SFILE(ARS5015G:RN)
     F                                     SFILE(ARS5015H:RNH)
     F                                     SFILE(ARS5015I:RNI)
     D SEC             S              3  0 DIM(999)                             AUTHORIZED CO.#S
     D FCD             S              3  0 DIM(50)                              FAX CODE
     D MSG             S             78    DIM(1) CTDATA PERRCD(1)              MESSAGES
   CID*EMS             S             78    DIM(60) CTDATA PERRCD(1)             WARN MESSAGES
CI CJD*EMS             S             78    DIM(62) CTDATA PERRCD(1)             WARN MESSAGES
CJ DQD*EMS             S             78    DIM(65) CTDATA PERRCD(1)             WARN MESSAGES
DQ   D EMS             S             78    DIM(66) CTDATA PERRCD(1)             WARN MESSAGES
   CCD*UMS             S             78    DIM(6) CTDATA PERRCD(1)              MESSAGES
CC B4D*UMS             S             78    DIM(7) CTDATA PERRCD(1)              MESSAGES
B4 CDD*UMS             S             78    DIM(8) CTDATA PERRCD(1)              MESSAGES
CD   D UMS             S             78    DIM(9) CTDATA PERRCD(1)              MESSAGES
¢D ¢ND*CMS             S             78    DIM(5) CTDATA PERRCD(1)              MESSAGES
¢P ¢tD*CMS             S             78    DIM(6) CTDATA PERRCD(1)              MESSAGES
¢t   D*CMS             S             78    DIM(7) CTDATA PERRCD(1)              MESSAGES
¢7 $HD*CMS             S             78    DIM(13) CTDATA PERRCD(1)             MESSAGES
$H $MD*CMS             S             78    DIM(14) CTDATA PERRCD(1)             MESSAGES
$M   D CMS             S             78    DIM(15) CTDATA PERRCD(1)             MESSAGES
CC   Ddist             S              5    dim(3) ctdata
C3   Dsv38             S              1
C3   Dsv39             S              1
C3   Dsv40             S              1
C3   Dsv41             S              1
¢G   d AllowResideo    s              1    inz('N')
C4   d p1300App        s             10    inz('DII')
C4   d p1300Bypass     s              1    inz('N')
¢G   d saveIndicatorIN25...
     d                 s               n   inz(*off)
DQ   D SQLCOUNT        S             10  0 INZ
DW   D CC_COUNT        S             10  0 INZ
D5   DTYPCOD           S              4    inZ('CUST')
D5   DPoLat            S              8F
D5   DPoLng            S              8F
D5   DUpdFlg           S              1    Inz('N')
C4    *
$H   d mycreditLimit   s              9  0 inz
$H   d creditLimitChange...
$H   d                 s               n   inz(*off)
$H   d userName        s             10    inz
$M   d Hydros_Flg      s              1    inz('N')
$M   d srtNm_Hydros    s             30    varying inz                          SQL like % stmt
$M   d Hydros_Prfx     s              6    inz('HYDROS')
$M   D svin28          s              1
$M   D SvSrtName       s             20
$O   d AccMtx_Flg      s              1    inz('N')
CI    *--------------------------------------------------------------------
CN    /include qcpysrc,hdyproto
C4    /include QCPYSRC,MNYPROTO
     D                SDS
     D  PROG                   1      8
CZ   D  QQF                  244    246
CZ   D  JOBNAME              244    253
CZ   D  JOBNBR               264    269
     D  DSPERR                91    160
     D  USRNM                254    263
CI    *
     D FIL1DS          DS
     D  SCREEN               261    268
     D  WSNANE               273    282
     D  C@LOC                370    371B 0
     D  CPFRRN               378    379B 0
     D                 DS
     D  ARMO09                 1      2  0
     D  ARDY09                 3      4  0
     D  ARCC09                 5      6  0
     D  ARYR09                 7      8  0
     D  DLSTUP                 1      8  0
     D                 DS
     D  ARMO11                 1      2  0
     D  ARDY11                 3      4  0
     D  ARCC11                 5      6  0
     D  ARYR11                 7      8  0
     D  DACCLS                 1      8  0
     D                 DS
     D  ARMO12                 1      2  0
     D  ARDY12                 3      4  0
     D  ARCC12                 5      6  0
     D  ARYR12                 7      8  0
     D  DACHLD                 1      8  0
     D                 DS
     D  ARMO14                 1      2  0
     D  ARDY14                 3      4  0
     D  ARCC14                 5      6  0
     D  ARYR14                 7      8  0
     D  DACSTR                 1      8  0
     D                 DS
     D  ARMO15                 1      2  0
     D  ARDY15                 3      4  0
     D  ARCC15                 5      6  0
     D  ARYR15                 7      8  0
     D  DLSTMT                 1      8  0
     D                 DS
     D  ARMO17                 1      2  0
     D  ARDY17                 3      4  0
     D  ARCC17                 5      6  0
     D  ARYR17                 7      8  0
     D  DAUDIT                 1      8  0
     D                 DS
     D  ARMO50                 1      2  0
     D  ARCC50                 3      4  0
     D  ARYR50                 5      6  0
     D  DACTPR                 1      6  0
     D                 DS                  INZ
     D  ARMO82                 1      2  0
     D  ARCC82                 3      4  0
     D  ARYR82                 5      6  0
     D  DSTMPR                 1      6  0
     D                 DS                  INZ
     D  ARMO89                 1      2  0
     D  ARDY89                 3      4  0
     D  ARYR89                 5      6  0
     D  EXPDAT                 1      6  0
     D                 DS
     D  ARMO02                 1      2  0
     D  ARDY02                 3      4  0
     D  ARYR02                 5      6  0
     D  OPNDAT                 1      6  0
¢7   D                 DS
¢7   D  ECMO01                 1      2  0
¢7   D  ECDY01                 3      4  0
¢7   D  ECYR01                 5      6  0
¢7   D  RVWDAT                 1      6  0
     D                 DS
     D  MONTH                  1      2  0
     D  DAY                    3      4  0
     D  CEN                    5      6  0
     D  YEAR                   7      8  0
     D  DATE                   1      8  0
     D                 DS
     D  MO53                   1      2  0
     D  DY53                   3      4  0
     D  YR53                   5      6  0
     D  FDATE                  1      6  0
     D                 DS
     D  STDATE                 1     16
     D  DSDATE                 1      8  0
     D  LSTMDT                 9     16  0
     D                 DS
     D  ACDATE                 1     12
     D  ACDT1                  1      6  0
     D  ACDT2                  7     12  0
     D                 DS
     D  CRDCLS                 1     21
     D  CREDIT                 1      1
     D  CLSE                   3      3
     D  DFTCST                13     13
     D  DFTSMT                15     15
     D  ALWCST                17     17
     D  ALWSMT                19     19
     D  ALWTAX                21     21
     D                 DS                  INZ
     D  ARNO75                 1      3  0
     D  ARNO76                 4      6  0
     D  ARNO77                 7     10  0
     D  FAXNUM                 1     10  0
     D                 DS                  INZ
     D  NO75SC                 1      3  0
     D  NO76SC                 4      6  0
     D  NO77SC                 7     10  0
     D  FAXSC                  1     10  0
     D                 DS                  INZ
     D  NO75SV                 1      3  0
     D  NO76SV                 4      6  0
     D  NO77SV                 7     10  0
     D  FAXSV                  1     10  0
     D ARAUDT          DS
     D  AUDNO                  1      7
¢R   D PERZIP          DS
¢R   D  pzflg                  1      1
      *
     D                 DS                  INZ
     D  DATYP                  1      1  0
     D  DATE2                  2      3  0
     D  DATE4                  4      7  0
     D  DATE6                  8     13  0
     D  DATE8                 14     21  0
     D  DACEN                 22     23  0
     D  DS2000                 1     23  0
     D                 DS
     D  PS15                   1      5
     D  PS1                    1      1
     D  PS2                    2      2
     D  PS3                    3      3
     D  PS4                    4      4
     D  PS5                    5      5
     D                 DS
     D  PT15                   1      5
     D  PT1                    1      1
     D  PT2                    2      2
     D  PT3                    3      3
     D  PT4                    4      4
     D  PT5                    5      5
     D                 DS
     D  PP15                   1      5
     D  PP1                    1      1
     D  PP2                    2      2
     D  PP3                    3      3
     D  PP4                    4      4
     D  PP5                    5      5
     D                 DS
     D  PN15                   1      5
     D  PN1                    1      1
     D  PN2                    2      2
     D  PN3                    3      3
     D  PN4                    4      4
     D  PN5                    5      5
     D                 DS
     D  OPMO04                 1      2  0
     D  OPDY04                 3      4  0
     D  OPCC04                 5      6  0
     D  OPYR04                 7      8  0
     D  OPDATE                 1      8  0
     D SCRNER          DS
     D  S15AER                 1      1
     D  S15BER                 2      2
     D  S15CER                 3      3
     D  S15EER                 4      4
     D  S15FER                 5      5
     D  S15GER                 6      6
     D  S15HER                 7      7
     D  S15IER                 8      8
     D  S15JER                 9      9
      * ---------------------------------------------------------------
   DS * Customer master
   DSD*CUSDTA          DS          2025    INZ
   DSD* CMFRM                  1      2
   DSD* CMFUNC                 3      3
   DSD* CMSTAT                 4      4
   DSD* CMCODE                 5      7
   DSD* CMDTTM                 8     31
   DSD* CMGRP#                32     46  0
   DSD* CMERCD                47     49
   DS * Customer#
   DSD* CMNO01                50     55  0
      *
     D                 DS                  INZ
     D  WMCOBR                 1      6  0
     D  CONBR                  1      3  0
     D  BRNBR                  4      6  0
      *
     D                 DS
     D  ADDON                  1     30
     D  IASYS                 12     12
DD   D  AvaTaxActive          18     18
DP   D  VectaYes              22     22
CI    *-------------------------
CI    * Reserved Pdata fields...
CI    *-------------------------
CI   D RsvData         DS
CI   D  RsvFile                1     10A
CI   D  RsvField              11     20A
CI   D  RsvDefType            21     21A
CI   D  RsvJobKey             22     22A
CI   D  RsvFuture             23     56A
CI   D  RsvParms              57    256A
CI    *--------------------------
CI    * ARPMCUA data structure...
CI    *--------------------------
CI   D arpmcuaData     DS           200
CI   D  arpmcuaCust                   6  0
CK    *--------------------------
CK    * New Customer Event
CK   D d_HDE0003       ds           256    inz
CK   D  cusnamE3                     30A
CK   D  cusnumE3                      6  0
CM   D  usridE3                      10A
CK   D  cusmailstE3                   2A
CK   D  slsbrnumE3                    3  0
CK   D  slsidE3                       3A
CV    *
CV    * Data passed to/from Opr1010
CV   D pData1010       ds                  inz
CV   D  nCustNo                       6
CV   D  nNoteCd                       1
CV   D  nMsg                               like(MsgFld)
$O    * TBNO02 AR Acct Matrix TF
$O   D                 ds
$O   D  TBNO02                 1      9
$O   D  Val1                   1      3
$O   D  Co#                    4      6
$M    * TBNO03 SortName Values
$M   D                 ds
$M   D  TBNO03                 1     30
$M   D  HSrtNm                 1     20
$O   D  TBEqp                  1      1
$O   D  TBSup                  2      2
$O   D  TBPrt                  3      3
$O   D  TBTls                  4      4
$O   D  TBCom                  5      5
CI    *----------------------
CI    * Stand alone fields...
CI    *----------------------
CI   d pRetCd          s              1
CI   d pActCd          s              2
CI   d pFunKy          s              2
CI   d pData           s            256
CI   d contactNbr      s              5  0 inz
CV   d nRetCd          s              1
CV   d nActCd          s              2
CV   d nFunKy          s              2
CV   d nData           s            256
CI    *
CK   d Eventid         s              7
CI    *
CV    *---------------------
CV    * Prototypes...
CV    *---------------------
CV    * Call Opr1010
CV   D Opr1010         pr                  extpgm('OPR1010')
CV   D nRetCd                         1
CV   D nActCd                         2
CV   D nFunKy                         2
CV   D nData                        256

$H    * Call OPR8220 - Retrieve enrollment value for the user
$H   d retrieveEnrollmentValue...
$H   d                 pr                  extpgm('OPR8220')
$H   d userid_                       10
$H   d application_                   2
$H   d code_                          4
$H   d ID_                            4  0
$H   d returnValue_                  10
$H   d valueFrom_                     1
$H   d returnCode_                    1
      *
DD   D                 DS
DD   DTaxCal_Enabled           1      1
DD DLD*AddrVal_Enabled          2      2
DL   DAddrVal_Enabled          4      4
DD   DTaxs_Cntrls              1     30
DD    *
DD   DpiLine1          s                   like(arad01)
DD   DpiLine2          s                   like(arad02)
DD   DpiLine3          s                   like(arad03)
DD   DpiCity           s                   like(arcy01)
DD   DpiState          s                   like(arst01)
DD   DpiZip            s                   like(arzp15)
DD   DpiCountry        s             30
DD   DPoErrCode        s             50
DD   DPoErrMessage     s            100
DD   Dsvin88           s              1
DD   Dsvin73           s              1
DD   DTaxs_Juris       s              7
DD   DTaxs_Juris_N     s                   like(arcd04)
DD   DWarnFlg          s              1    inz('N')
DD   DwrnShpFlg        s              1    inz('N')
DD   Dsvad04           s                   like(arad04)
DD   Dsvad05           s                   like(arad05)
DD   Dsvad06           s                   like(arad06)
DD   Dsvcy02           s                   like(arcy02)
DD   Dsvzp16           s                   like(arzp16)
DD   Dsvst02           s                   like(arst02)
DD   Dsvad19s          s                   like(arad04)
DD   Dsvad20s          s                   like(arad05)
DD   Dsvad21s          s                   like(arad06)
DD   Dsvcy07s          s                   like(arcy02)
DD   Dsvst07s          s                   like(arzp16)
DD   Dsvzp21s          s                   like(arst02)
DG DND*wECMS            s              1
DM   D CertCapture     s              1
DM   D pCust#          s                   like(arno01)
DM   D pJob#           s              7
DM   D pPgmName        s             10
DM   D pUpdCust        s              1    inz('N')
DM   D pMode           s              1
DN   D wEcms           ds            30
DN   DwEcms1                   1      1
DN   DwEcms2                   2      2
DM    *
DM   D                 ds
DM   D  arad01                 1     30A
DM   D  arad02                31     60A
DM   D  arad03                61     90A
DM   D  arcy01                91    115A
DM   D  arst01               116    117a
DM   D  arzp15               118    127A
DM   D  addrVal                1    127A
DM   D                 ds
DM   D  svarad01               1     30A
DM   D  svarad02              31     60A
DM   D  svarad03              61     90A
DM   D  svarcy01              91    115A
DM   D  svarst01             116    117A
DM   D  svarzp15             118    127A
DM   D  svaddr                 1    127A
DM   D                 ds                  inz
DM   D  svarno75               1      3  0
DM   D  svarno76               4      6  0
DM   D  svarno77               7     10  0
DM   D  svfax                  1     10  0
DM   D                 ds                  inz
DM   D  svarno07               1      3  0
DM   D  svarno08               4      6  0
DM   D  svarno09               7     10  0
DM   D  svPhone                1     10  0
DM   D                 ds                  inz
DM   D  arno07                 1      3  0
DM   D  arno08                 4      6  0
DM   D  arno09                 7     10  0
DM   D  phNum                  1     10  0
DM   D  svemail        s                   like(opad01)
DM   D  brnchg         s              1
DM   D  updCnct        s              1
DP   D svin53          s              1    inz
DU   D COF_Mode        S              1
DU   D Cust_Type       S              1
DU   D Cust_Num        S                   like(arno01)
DU DWD*PoToken         S             25
DW   D PoToken         S             50
DU   D PoExpcc         S                   like(arcc09)
DU   D PoExpyr         S                   like(aryr09)
DU   D PoExpmo         S                   like(armo09)
DU   D PoNAME          S                   like(arnm01)
DW   D PoNetTrnID      S             40
DU   D card_interface  S              1    inz('N')
DU   D                 ds
DU   D  using_card             1      1
DU   D  card_software          2     16
DU   D  card_tabentry          1     30
D2   D                 DS                  INZ
D2   D  MO09                   1      2  0
D2   D  DY09                   3      4  0
D2   D  YR09                   5      6  0
D2   D  LSTDAT                 1      6  0
DD    *****************************************************************
     IARFMBAL
     I              ARAM01                      A01
     I              ARCN01                      C01
     I              ARNO03                      N03
     I              ARFL03                      F03
     I              ARMO11                      M11
     I              ARDY11                      D11
     I              ARCC11                      C11
     I              ARYR11                      Y11
     I              ARMO12                      M12
     I              ARDY12                      D12
     I              ARCC12                      C12
     I              ARYR12                      Y12
     I              ARFL76                      CBFL76
     IARFEBAL
     I              ARNO16                      ENO16
     I              ARMO09                      EMO09
     I              ARDY09                      EDY09
     I              ARCC09                      ECC09
     I              ARYR09                      EYR09
     I              ARNM03                      ENM03
     I              ARID01                      EID01
     I              ARAM01                      EAM01
     I              ARCN01                      ECN01
     I              ARBL75                      EBL75
     I              ARMO11                      E1111
     I              ARDY11                      E1111
     I              ARCC11                      E1111
     I              ARYR11                      E1111
     I              ARMO12                      EMO12
     I              ARDY12                      EDY12
     I              ARCC12                      ECC12
     I              ARYR12                      EYR12
     I              ARMO03                      EMO03
     I              ARDY03                      EDY03
     I              ARCC03                      ECC03
     I              ARYR03                      EYR03
     I              ARFL25                      EBFL25
     IARFMCAD
     I              ARCD04                      XXCD04
     I              ARID01                      XXID01
     I              ARDN08                      XXDN08
     IOEFTOAH
     I              ARNO15                      NO15
     IFHBAL
     I              ARNM05                      NM05
     IARFTCSA
     I              ARAM01                      CAAM01
     I              ARFL03                      CAFL03
     I              ARFL76                      CAFL76
     I              ARCN01                      CACN01
     I              ARMO12                      CAMO12
     I              ARDY12                      CADY12
     I              ARCC12                      CACC12
     I              ARYR12                      CAYR12
CO   I              ARID05                      CAID05
CO   I              ARCDF9                      CACDF9
CO   I              ARFL77                      CAFL77
CO   I              ARFL72                      CAFL72
CO   I              ARFL73                      CAFL73
CO   I              ARDN08                      CADN08
CO   I              ARDY89                      CADY89
CO   I              ARMO89                      CAMO89
CO   I              ARCC89                      CACC89
CO   I              ARYR89                      CAYR89
     IARFMFRQ
     I              ARNO01                      CUSTNO
     IARFMENT
     I              ARCDB3                      XXCDB3
     I              ARFL25                      EPFL25
     I              ARMO12                      EPMO12
     I              ARDY12                      EPDY12
     I              ARCC12                      EPCC12
     I              ARYR12                      EPYR12
     I              ARCN01                      EPCN01
     I              ARNO81                      NO81
     I              ARCDF9                      CDF9
     IARFMTRH
     I              ARCDF9                      XCDF9
     IARFMJBM
     I              ARCDF9                      JBCDF9
     I              ARDN08                      XXDN08
     IARFMBCH
     I              ARCDG8                      XXCDG8
     I              ARDN08                      XXDN08
CP   IOEFMUSR
CP   I              ARNO15                      WCCMPY
CY   IAIFMUSR
CY   I              ARNO15                      WCCMP
C3   IOEFMCUS
C3   I              ARID01                      WCsalid
C3   IAIFMCUS
C3   I              ARID01                      BCsalid
   CHI*ARFMBCH4
   CHI*             ARCDG8                      XXCDG8
   CHI*             ARDN08                      XXDN08
      *------------------------------------------------------------------------*
      *  SECTION 0         NON-EXECUTABLE STATEMENTS                     *
      *                                                                  *
      * STEP 1.  DECLARE PARAMETER LISTS                                 *
      * STEP 2.  DECLARE KEY LISTS                                       *
      *                                                                  *
      *------------------------------------------------------------------------*
      * STEP 1. *
      *------------------------------------------------------------------------*
     C     *ENTRY        PLIST
     C                   PARM                    ARNO01                         Customer #
CJ   C                   parm                    f3flg             1
     C     JULKEY        PLIST
     C                   PARM                    PDATE             6 0
     C                   PARM                    PJULI             5 0
C0 $3C*    PL0025        PLIST
C0 $3C*                  PARM                    TABCOD
C0 $3C*                  PARM                    TABENT
C0 $3C*                  PARM                    C@LOC#
C0 $3C*                  PARM                    CRCD#
C0 $3C*                  PARM                    CFLD#
DP ??C*                  PARM                    tabDesc          30
DP ??C*                  PARM                    MODE              1
$4   C     PL0025        PLIST
$4   C                   PARM                    TABCOD            4
$4   C                   PARM                    TABENT            9
$4   C                   PARM                    C@LOC#
$4   C                   PARM                    CRCD#
$4   C                   PARM                    CFLD#
$4   C                   PARM                    tabDesc          30
$4   C                   PARM                    MODE              1
     C     PL5211        PLIST
     C                   PARM                    TAXJUR            7 0
     C                   PARM                    RETCDE            1 0
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL6200        PLIST
     C                   PARM                    ARNO01
     C                   PARM                    RETCDE
     C                   PARM                    ORDBY            30
     C                   PARM                    FROMOE            1
     C                   PARM                    NM01CN
     C                   PARM                    NO07CN
     C                   PARM                    NO08CN
     C                   PARM                    NO09CN
CI   C                   PARM                    CONTACTNBR
      *
     C     PL2000        PLIST
     C                   PARM                    PM2000           23 0
      *
     C     RLOCK         PLIST
     C                   PARM                    DSPERR
     C                   PARM                    DSPF1             1            DISPLAY RETRY?
     C                   PARM                    DSPF2             1            SCREEN RESPONSE
      *
     C     PL2014        PLIST
     C                   PARM                    CMPNY#            3
     C                   PARM                    DIV               3
     C                   PARM                    RGN               3
     C                   PARM                    BRN#              3
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM                    LTYP              1
      *
     C     PL5420        PLIST
     C                   PARM                    NO15#             3
     C                   PARM                    ID01#             3
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     UDRPRM        PLIST                                                  CALC CLNDR DT
     C                   PARM                    ZZFUNC            1
     C                   PARM                    ZZDATE            7 0
     C                   PARM                    ZZDAYS            5 0
     C                   PARM                    ZZDIFF            7 0
      *
     C     PL0310        PLIST
     C                   PARM                    C@LOC#                         CURSOR LOCATION
     C                   PARM                    CRCD#                          CURSOR RECORD
     C                   PARM                    CFLD#                          CURSOR FIELD
     C                   PARM                    CUSNBR            6            CUSTOMER NUMBER
     C                   PARM                    CUSNAM           30            CUSTOMER NUMBER
     C                   PARM                    FAXNBR           32            FAX NUMBER
     C                   PARM                    OPTION            3            OPTIONS
     C     PL8220        PLIST
     C                   PARM                    USER             10
     C                   PARM                    APP               2
     C                   PARM                    CDE               4
     C                   PARM                    IDNUM             4 0
     C                   PARM                    USRVAL           10
     C                   PARM                    VALFRM            1
     C                   PARM                    RTNCOD            1
     C     PL9020        PLIST
     C                   PARM                    F4ID05
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
      *
     C     PL0060        PLIST
     C                   PARM                    VALUE#           30
     C                   PARM                    ACT#              1
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
      *
     C     PL0400        PLIST
     C                   PARM                    PMIAPL            2
     C                   PARM                    PMOYN             1
      *
     C     PL5810        PLIST
     C                   PARM                    TRMCD             2
     C                   PARM                    TRMYN             1
     C                   PARM                    TRMPC             3
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM      'N'           SHWPMT            1
      *----------------------------------------------------*
     C     PL9100        PLIST
     C                   PARM                    ZPCD
     C                   PARM                    TXCD
     C                   PARM                    RETCOD            1 0
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
CI    *
CI   c     pl3100        plist
CI   c                   parm                    pRetCd
CI   c                   parm                    pActCd
CI   c                   parm                    pFunKy
CI   c                   parm                    pData
CI    *
CI   C     pl3220        plist
CI   c                   parm                    pRetCd
CI   c                   parm                    pActCd
CI   c                   parm                    pFunKy
CI   c                   parm                    pData
CI    *
CI   C     PL2500        PLIST
CI   C                   PARM                    PGMNAM2          10
CI   C                   PARM                    RCCALL            1
C4    *
C4   C     pl1300        plist
C4   C                   parm                    p1300App
C4   C                   parm                    p1300Bypass
C4    *
DD    *----------------------------------------------------*
DD   C     PL9010        PLIST
DD   C                   PARM                    piLine1
DD   C                   PARM                    piLine2
DD   C                   PARM                    piLine3
DD   C                   PARM                    piCity
DD   C                   PARM                    piState
DD   C                   PARM                    PiCountry
DD   C                   PARM                    PiZip
DD   C                   PARM                    PoErrCode
DD   C                   PARM                    PoErrMessage
D5   C                   parm                    PoLat
D5   C                   parm                    PoLng
DD   C     PL5218        PLIST
DD   C                   PARM                    pi_juris
DD   C                   PARM                    pi_zip
DM    *
DM   C     pl9210        plist
DM   C                   parm                    pCust#
DM   C                   parm                    pJob#
DM    *
DM   C     pl9200        plist
DM   C                   parm                    pMode
DM   C                   parm                    pCust#
DM   C                   parm                    pJob#
DM   C                   parm                    pPgmName
DM   C                   parm                    pUpdCust
DU    *
DU   C     PL9751        Plist
DU   C                   PARM                    COF_Mode
DU   C                   PARM                    Cust_Num
DU   C                   PARM                    Cust_Type
DU   C                   PARM                    PoToken
DU   C                   PARM                    PoExpcc
DU   C                   PARM                    PoExpyr
DU   C                   PARM                    PoExpmo
DU   C                   PARM                    PoNAME
DW   C                   PARM                    PoNetTrnID
$K   C     PL_ARRC104    PLIST
$K   C                   PARM                    INAME            30            Input Address name
$K   C                   PARM                    IADDR1           30            Input Address line 1
$K   C                   PARM                    IADDR2           30            Input Address line 2
$K   C                   PARM                    IADDR3           30            Input Address line 3
$K   C                   PARM                    ICITY            25            Input City
$K   C                   PARM                    ISTATE            2            Input State
$K   C                   PARM                    IZIP             10            Input Zip
$K   C                   PARM                    OADDR1           30            Output Addres line 1
$K   C                   PARM                    OADDR2           30            Output Addres line 2
$K   C                   PARM                    OADDR3           30            Output Addres line 3
$K   C                   PARM                    OCITY            25            Output City
$K   C                   PARM                    OSTATE            2            Output State
$K   C                   PARM                    OZIP             10            Output Zip
$K   C                   PARM                    CASE              1            Address Case
$K   C                   PARM                    ECOD##            3            Error Code
$K   C                   PARM                    EMSG##           80            Error Message
$K   C                   PARM                    MAXADRL           2            Max Address Length
$K   C                   PARM                    ADDRTYPE          1            Address Type M S
      *------------------------------------------------------------------------*
      * STEP 2. *
      *------------------------------------------------------------------------*
     C     KEY           KLIST
     C                   KFLD                    ARNO15                         COMPANY
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    CODE              1            STATUS CODE
     C     KEY2          KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    CODE                           STATUS CODE
     C     MKEY          KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    CDA1                           S/M CODE
     C                   KFLD                    NO40M                          CONTROL #
     C     SKEY          KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    CDA1                           S/M CODE
     C                   KFLD                    NO40S                          CONTROL #
     C     AKEY          KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    CDA1                           S/M CODE
     C     BKEY          KLIST
     C                   KFLD                    NO16                           BRANCH
     C                   KFLD                    ARNO01                         CUSTOMER
     C     BALKEY        KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    ARNO15                         COMPANY
     C     ENTKEY        KLIST
     C                   KFLD                    ARNO82                         ENTERPRISE
     C                   KFLD                    ARNO15                         COMPANY
     C     BRKEY         KLIST
     C                   KFLD                    ARNO15                         COMPANY
     C                   KFLD                    NO16                           BRANCH
C3   C     BRKEY1        KLIST
C3   C                   KFLD                    ARNO15                         COMPANY
C3   C                   KFLD                    ARNO57                         BRANCH
     C     HISKEY        KLIST
     C                   KFLD                    ARCC50                         ACCT CC
     C                   KFLD                    ARYR50                         ACCT YR
     C                   KFLD                    ARMO50                         ACCT MO
     C                   KFLD                    ARNO15                         COMPANY
     C                   KFLD                    ARNO01                         CUSTOMER
     C     LKEY          KLIST
     C                   KFLD                    ARNO15                         COMPANY
     C                   KFLD                    ARNO01                         CUSTOMER
     C     SLKEY         KLIST
     C                   KFLD                    ID01                           SALESPERSON
     C                   KFLD                    ARNO15                         COMPANY
¢W   C     SLKEY2        KLIST
¢W   C                   KFLD                    EPDID                          SALESPERSON
¢W   C                   KFLD                    ARNO15                         COMPANY
     C     TBKEY         KLIST
     C                   KFLD                    TBNO01                         TABLE CODE 1
     C                   KFLD                    TBNO02                         TABLE CODE 2
     C     SHPKEY        KLIST
     C                   KFLD                    ARCDC5                         METHOD OF SHIPMENT
     C                   KFLD                    ARCDC6                         SHIP CODE
     C     EKEY          KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    ETYPE             2
     C                   KFLD                    OPNM13
DD   C     TABKEY        KLIST
DD   C                   KFLD                    TBNO01
DD   C                   KFLD                    TBNO02
D5   C     ACOKEY        KList
D5   C                   KFld                    TYPCOD
D5   C                   KFld                    ARNO01
D5   C     ACOKEY1       KList
D5   C                   KFld                    TYPCOD
D5   C                   KFld                    ARNO01
D5   C                   KFld                    ARNO40
D5    *
¢J   C     CONTK         KLIST
¢J   C                   KFLD                    ARNO01                         CUSTOMER
¢J   C                   KFLD                    PRNO12                         CONT PRF#
      *------------------------------------------------------------------------*
      *  SECTION 1         PROCESS MAINLINE                              *
      *                                                                  *
      * STEP 1.  INITIALIZE                                              *
      * STEP 2.  RETREIVE CUSTOMER IF SETUP                              *
      * STEP 3.  AUDIT TRANSACTION                                       *
      * STEP 4.  NAME AND ADDRESS SUBROUTINE                             *
      * STEP 5.  SALESPERSON & CUSTOMER REQUIREMENTS                     *
      * STEP 6.  PRICING/CREDIT INFORMATON                               *
      * STEP 7.  CUSTOMER CONTACTS                                       *
      * STEP 8.  ADD NEW CUSTOMER                                        *
      * STEP 9.  AUDIT TRANSACTION                                       *
      *                                                                  *
      *------------------------------------------------------------------------*
      * STEP 1. * INITIALIZE
      *------------------------------------------------------------------------*
     C                   EXSR      INITSR
      *------------------------------------------------------------------------*
      * STEP 2. * RETREIVE CUSTOMER IF SETUP
      *------------------------------------------------------------------------*
¢3   C                   CLEAR                   ORGAM01                        SAVE FAX#
CN    *
CN    * Check whether using Intellichief is used.
CN   C                   move      '0'           err01             1
CN   C                   move      *blanks       tbno01
C0 $3C*                  move      *blanks       TABENT            9            TABLE ENTRY
$4   C                   move      *blanks       TABENT            9            TABLE ENTRY
CN   C                   movel     'IMAG'        tbno01
CN   C                   move      *blanks       tbno02
CN   C                   movel     'ICSYS'       tbno02
CN   C     tbkey         chain     tbfmtbl                            40
CN   C     *in40         ifeq      *off
CN   C                   movel     tbno03        icsys             1
CN   C                   else
CN   C                   move      'N'           icsys
CN   C                   endif
CN   C     icsys         ifeq      'Y'
CN   C                   call      'OPC9805'
CN   C                   parm                    err01             1
CN   C                   endif
CN   C                   if        err01 = '1' and
CN   C                             iswebfaced() = *on
CN   C                   eval      err01 = '0'
CN   C                   endif
CN   C     icsys         ifeq      'Y'
CN   C     err01         andeq     '0'
CN   C                   move      *on           *in48
CN   C                   else
CN   C                   move      *off          *in48
CN   C                   endif
CN    *
DD    * Retreive tax settings for AvaTax interface
DD    *  - get address controls
DD   C                   move      'TAXS'        tbno01
DD   C                   move      *BLANKS       tbno02
DD   C                   movel     'CONTROLS'    tbno02
DD   C     TABKEY        CHAIN     TBFMTBL
DD   C                   IF        %FOUND
DD   C                   MOVEL     TBNO03        TAXS_CNTRLS
DD   C                   ELSE
DD   C                   CLEAR                   TAXS_CNTRLS
DD   C                   ENDIF
DD    *
DD    * Retreive tax settings for AvaTax interface
DD    *  - get default tax jurisdiction
DD   C                   move      'TAXS'        tbno01
DD   C                   move      *BLANKS       tbno02
DD   C                   movel     'JURIS'       tbno02
DD   C     TABKEY        CHAIN     TBFMTBL
DD   C                   IF        %FOUND
DD   C                   MOVEL     TBNO03        TAXS_JURIS
DD   C                   MOVE      TAXs_JURIS    TAXS_JURIS_N
DD   C                   ELSE
DD   C                   CLEAR                   TAXS_JURIS_N
DD   C                   ENDIF
DD    *
DG    * Retreive setting for ECMS
DG   C                   clear                   wEcms
DG   C                   eval      tbno01 = 'TAXS'
DG   C                   eval      tbno02 = 'ECMS'
DG   C     tabkey        chain     tbfmtbl
DG   C                   if        %found
DG   C                   eval      wEcms = %trim(tbno03)
DG   C                   endif
DM    *
DM    * Check if using CertCapture
DM   C                   eval      CertCapture = 'N'
DM   C                   eval      pmiapl = '21'
DM   C                   eval      pmoyn = *blanks
DM   C                   call      'OPR0400'     pl0400
DM   C                   if        pmoyn = 'Y'
DM   C                   eval      CertCapture = 'Y'
DM   C                   endif
DG    *
DE   C                   if        iasys = 'Y'
DE   C                   eval      *in48 = *on
DE   C                   endif
D0    *
D0    * Retrieve user enrollment for bank information
D0    *
D0   C                   CLEAR                   BNKINFAUTH        1
D0   C                   MOVE      USRNM         USER
D0   C                   MOVE      'AR'          APP
D0   C                   MOVE      'BANK'        CDE
D0   C                   Z-ADD     1             IDNUM
D0   C                   MOVE      *BLANKS       USRVAL
D0   C                   MOVE      *BLANKS       VALFRM
D0   C                   MOVE      *BLANKS       RTNCOD
D0   C                   CALL      'OPR8220'     PL8220
D0   C     RTNCOD        IFEQ      '0'
D0   C                   MOVEL     USRVAL        BNKINFAUTH
D0   C                   ENDIF
DE    *
     C                   MOVE      *BLANKS       ARNM05
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      'Y'           DSPF1             1
     C     *IN92         DOUEQ     *OFF
     C     ARNO01        CHAIN     ARFMCUS                            4092      CUSTOMER MASTER
¢B   C     ARNO01        CHAIN     ARFCSCMT                           43        CUST COMMENTS
¢B   C                   MOVE      *OFF          *IN43
¢9   C                   IF        CMCD07 = ' '
¢9   C                   MOVE      'N'           CMCD07
¢9   C                   ENDIF
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C     DSPF2         CABEQ     'N'           ENDPGM                         DO NOT RETRY
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN40         IFEQ      '0'                                          RECORD FOUND ?
     C                   MOVE      'N'           ADDCUS                         ADD CUSTOMER
     C                   MOVE      *OFF          *IN27
     C                   MOVE      ARFL11        FL11              1            NOTES EXIST ?
     C                   MOVE      ARFL03        SAVHLD            1            SAVE HOLD FLAG
     C                   Z-ADD     FAXNUM        FAXSV                          SAVE FAX#
     C                   MOVE      ARCDC4        SAVCD4            1            GENERIC CASH ACCT
     C                   MOVE      ARZP16        CPYZIP
DM   C                   eval      svaddr = addrVal
DM   C                   eval      svfax  = faxnum
DM   C                   eval      svPhone= phNum
¢3   C                   Z-ADD     ARAM01        ORGAM01                        SAVE FAX#
      * IF CUSTOMER NOT PART OF AN ENTERPRISE,
      * NON-DISPLAY / PROTECT LOCK FLAGS...
     C     ARNO82        IFEQ      0
     C                   MOVE      *ON           *IN01
     C                   ENDIF
DQ    * RETRIEVES CUSTOMER MASTER ADD-ON DATA
DQ                       exsr      @RetrieveAddOnData;
      *------------------------------------------------------------------------*
      * STEP 3. * WRITE AUDIT RECORD--BEFORE UPDATE
      *------------------------------------------------------------------------*
     C     ARNO01        CHAIN(N)  ARFMBAL                            46
     C     *IN46         DOWEQ     *OFF
     C     CREDIT        IFEQ      'C'                                          CONSOLIDATED
     C                   Z-ADD     ARAM01        CAAM01                         CREDIT LIMIT
     C                   MOVEL     ARFL03        CAFL03                         CR HLD FLG
     C                   MOVEL     ARFL76        CAFL76                         CR HLD LOCK
     C                   Z-ADD     ARCN01        CACN01                         HOLD COUNT
     C                   Z-ADD     ARMO12        CAMO12                         MONTH HELD
     C                   Z-ADD     ARDY12        CADY12                         DAY HELD
     C                   Z-ADD     ARCC12        CACC12                         CENTURY HELD
     C                   Z-ADD     ARYR12        CAYR12                         YEAR HELD
     C                   ELSE
     C                   Z-ADD     A01           CAAM01                         CREDIT LIMIT
     C                   MOVEL     F03           CAFL03                         CR HLD FLG
     C                   MOVEL     CBFL76        CAFL76                         CR HLD LOCK
     C                   Z-ADD     C01           CACN01                         HOLD COUNT
     C                   Z-ADD     M12           CAMO12                         MONTH HELD
     C                   Z-ADD     D12           CADY12                         DAY HELD
     C                   Z-ADD     C12           CACC12                         CENTURY HELD
     C                   Z-ADD     Y12           CAYR12                         YEAR HELD
     C                   ENDIF
     C                   TIME                    ARTM01                         UPDATE TIME
     C                   MOVE      'B'           ARCD23                         BEFORE UPDATE
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DAUDIT                         TRANS AUDIT DT
CO   C                   MOVEL     ARCDF9        CACDF9                         TRANS AUDIT DT
CO   C                   MOVEL     ARFL77        CAFL77                         TRANS AUDIT DT
CO   C                   MOVEL     ARFL72        CAFL72                         TRANS AUDIT DT
CO   C                   MOVEL     ARFL73        CAFL73                         TRANS AUDIT DT
CO   C                   MOVEL     ARDN08        CADN08                         TRANS AUDIT DT
CO   C                   Z-ADD     ARDY89        CADY89                         TRANS AUDIT DT
CO   C                   Z-ADD     ARMO89        CAMO89                         TRANS AUDIT DT
CO   C                   Z-ADD     ARCC89        CACC89                         TRANS AUDIT DT
CO   C                   Z-ADD     ARYR89        CAYR89                         TRANS AUDIT DT
CO   C                   MOVEL     ARID05        CAID05                         TRANS AUDIT DT
     C                   WRITE     ARFTCSA                                      AUDIT TRANS
     C     ARNO01        READE(N)  ARFMBAL                                46
     C                   ENDDO
      * IF CUSTOMER BELONGS TO AN ENTERPRISE RETRIEVE
      * ENTERPRISE NAME...
     C                   MOVE      *IN48         SVIN48            1
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      'Y'           DSPF1             1
     C                   MOVE      'N'           ENTLOK            1            ENTERPRISE LOCK
     C     ARNO82        IFNE      *ZEROS
     C     *IN92         DOUEQ     *OFF
     C     ARNO82        CHAIN     ARFMENT                            4892
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C     DSPF2         CABEQ     'N'           ENDPGM                         DO NOT RETRY
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
      *
     C     *IN48         IFEQ      *OFF
     C                   MOVE      'Y'           ENTLOK                         ENTERPRISE LOCK
     C                   ENDIF
     C                   MOVE      SVIN48        *IN48
      *
     C     *IN40         IFEQ      *OFF
     C                   MOVE      *ON           *IN44
      * IF THE ENTERPRISE THAT THE CUSTOMER BELONGS TO IS CURRENTLY
      * SET TO A CASH ACCOUNT, THEN PROTECT THE CASH/CHARGE FIELD...
     C     ARCDE1        IFEQ      'C'
     C                   MOVE      'Y'           PRCASH            1            PROTECT CASH
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN01                          DSPATR(ND PR)
     C                   END
      *
      * IF CUSTOMER BELONGS TO ENTERPRISE, RETRIEVE PRINT FREQUENCY INFO
     C                   MOVE      *IN48         SVIN48
     C     ARNO82        IFNE      *ZERO
     C     ARNO82        CHAIN(N)  ARFMFRQ                            48        ENTERPRISE MASTER
     C     *IN48         IFEQ      *OFF
     C                   MOVE      ARFL52        EFL52
     C                   MOVE      ARFL61        EFL61
     C                   MOVE      ARFL54        EFL54
     C                   MOVE      ARFL55        EFL55
     C                   MOVE      ARFL56        EFL56
     C                   MOVE      ARFL57        EFL57
     C                   MOVE      ARFL58        EFL58
     C                   MOVE      ARFL59        EFL59
     C                   MOVE      ARFL60        EFL60
     C                   MOVE      ARNOA7        ENOA7
     C                   MOVE      ARNOA8        ENOA8
     C                   MOVE      ARNOA9        ENOA9
     C                   ENDIF
     C                   MOVE      SVIN48        *IN48
     C                   ENDIF
      *
      * CHAIN TO THE CUSTOMER PRINT FREQUENCY FILE FOR PRINT INFORMATION
     C     ARNO01        CHAIN(N)  ARFMFRQ                            40        ENTERPRISE MASTER
     C     *IN40         IFEQ      *OFF                                         RECORD FOUND ?
     C                   MOVE      'N'           ADDFRQ                         ADD FREQUENCY
     C                   MOVE      'N'           DSPFAX
     C                   ENDIF
      *
     C                   CLEAR                   EMAIL
     C                   CLEAR                   OPNM13
     C                   MOVE      '01'          ETYPE
     C     EKEY          CHAIN(N)  OPFMEMA                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     OPAD01        EMAIL
DM   C                   eval      svEmail = %trim(opad01)
     C                   ENDIF
      *
      * IF NEW CUSTOMER, SECURITY PROFILE REQUIRED TO SET UP ACCOUNTS
     C     ADDCUS        IFEQ      'Y'                                          NEW CUSTOMER
     C     SECPRF        SETLL     OPFMSEC                                40    =FOUND
     C     *IN40         CABEQ     '0'           ENDPGM
     C                   END
      *------------------------------------------------------------------------*
      * STEP 4. * NAME AND ADDRESS
      *------------------------------------------------------------------------*
     C                   MOVE      'N'           HAVTNT            1            ? HAVE NOTES
     C                   MOVE      'N'           RCMD2             1            CMD-2 RETURN
     C                   MOVEA     '0'           *IN(69)                        ONE B-4 DIAL FAX#
     C     NMTAG         TAG
     C                   EXSR      NMADS
     C     F10FLG        CABEQ     'Y'           UPDEXT                         UPD & EXIT
      *------------------------------------------------------------------------*
      * STEP 5. * SALESPERSON & CUSTOMER REQUIREMENTS
      *------------------------------------------------------------------------*
     C     SLTAG         TAG
     C                   EXSR      SLSCUS
     C     *IN12         CABEQ     '1'           NMTAG                          CMD 12 PREVIOUS
     C     F10FLG        CABEQ     'Y'           UPDEXT                         UPD & EXIT
CI    *-----------------------------------
CI    * Add-on fields entry/maintenance...
CI    *-----------------------------------
CI   C     AOEM          TAG
CI   C                   eval      RsvFile    = 'ARPMCUA'
CI   C                   eval      RsvField   = *BLANKS
CI   C                   eval      RsvDefType = *BLANKS
CI   C                   eval      RsvJobKey  = 'N'
CI   C                   eval      arpmcuaCust = ARNO01
CI   C                   eval      RsvParms  = arpmcuaData
CI   C                   eval      pretcd     = ' '
CI   C                   eval      pactcd     = 'AL'
CI   C                   eval      pfunky     = '  '
CI   C                   eval      pdata     = RsvData
CI   C                   call      'OPR3220'     PL3220
CJ   C     f3flg         ifne      'Y'
CI   C     PFUNKY        CABEQ     '03'          ENDPGM
CJ   C                   endif
CI   C     PFUNKY        CABEQ     '12'          SLTAG
CI   C     PRETCD        CABEQ     '1'           SLTAG
CI    *
      *
      * CUSTOMER PRINT CODES
     C     DSPJ          TAG
     C                   EXSR      PRTCOD
   CIC*    *IN12         CABEQ     *ON           SLTAG                          CMD 12 PREVIOUS
CI   C     *IN12         CABEQ     *ON           AOEM                           CMD 12 PREVIOUS
     C     F10FLG        CABEQ     'Y'           UPDEXT                         UPD & EXIT
      *------------------------------------------------------------------------*
      * STEP 6. * PRICING/CREDIT INFORMATION
      *------------------------------------------------------------------------*
     C     PRTAG         TAG
     C                   EXSR      PRCCRD
     C     *IN12         CABEQ     *ON           DSPJ                           CMD 12 PREVIOUS
     C     F10FLG        CABEQ     'Y'           UPDEXT                         UPD & EXIT
      *------------------------------------------------------------------------*
      * STEP 6.1* COMPANY INFORMATION
      *------------------------------------------------------------------------*
     C     CMPTAG        TAG
CI   c                   eval      svIn83 = *in83
     C                   EXSR      CMPNY
CI   c                   eval      *in83 = svIn83
     C     *IN12         CABEQ     '1'           PRTAG                          CMD 12 PREVIOUS
     C     F10FLG        CABEQ     'Y'           UPDEXT                         UPD & EXIT
      *------------------------------------------------------------------------*
      * STEP 7. * CUSTOMER CONTACTS
      *------------------------------------------------------------------------*
CI    * Check for recursive call...
CI   C                   eval      pgmnam2 = 'ARR6200'
DM   C                   eval      updCnct = 'N'
CI   C                   call      'OPC2500'     PL2500
CI   C                   If        rccall = 'N'
     C                   MOVE      'R'           FROMOE
     C                   MOVE      *ZEROS        RETCDE
     C                   MOVEL     ARNM01        NM01CN
     C                   Z-ADD     ARNO07        NO07CN
     C                   Z-ADD     ARNO08        NO08CN
     C                   Z-ADD     ARNO09        NO09CN
     C                   CALL      'ARR6200'     PL6200
     C     RETCDE        IFEQ      8
     C                   MOVE      *ON           *IN12
DM    * Retcde <> 8 is being considered that some changes occured
DM    * to customer's contacts to enable update in certcapture
DM    * Even if nothing was changed, this will help minimize the
DM    * calls update in Certcapture
DM   C                   else
DM   C                   eval      updCnct = 'Y'
     C                   ENDIF
CI    * Recursive call error...
CI   C                   else
CI   C                   eval      msgfld = ems(62)
CI   C                   eval      *IN12 = *ON
CI   C                   endif
     C                   MOVE      'N'           RCMD2                          CMD-2 RETURN
     C   12              MOVE      'Y'           RCMD2                          CMD-12 RETURN
     C     *IN12         CABEQ     '1'           CMPTAG                         CMD 12 PREVIOUS
     C                   MOVE      'N'           RCMD2                          CMD-2 RETURN
      *------------------------------------------------------------------------*
      * STEP 8. * ADD NEW CUSTOMER
      *------------------------------------------------------------------------*
     C     UPDEXT        TAG
DD    *
DD    *  If using AvaTax, load default Tax Jurisdiction if zeros
DD   C                   if        AvaTaxActive = 'Y'
DD   C                             and LicToAvaTax
DD   C                   if        arcd04 = *zeros
DD   C                   z-add     Taxs_Juris_N  arcd04
DD   C                   endif
DD   C                   if        arcd30 = *zeros
DD   C                   z-add     Taxs_Juris_N  arcd30
DD   C                   endif
DD   C                   endif
DD    *
     C     ADDCUS        IFEQ      'Y'
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DACSTR                         HISTORY START
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   WRITE     ARFMCUS
DQ    * Write to Customer Master Add-on File
DQ                       EXSR      @ProcessAddOnFile ;
      *
      * WRITE EMAIL ADDRESS
      *
     C     EMAIL         IFNE      *BLANKS
     C                   MOVEL     EMAIL         OPAD01
     C                   MOVE      ARNO01        OPNO17
     C                   MOVE      '01'          OPCD14
     C                   MOVE      USRNM         OPNM06
     C                   CLEAR                   OPNM13
     C                   Z-ADD     DATE          OPDATE
     C                   WRITE     OPFMEMA
     C                   ENDIF
     C     HAVTNT        IFEQ      'Y'
     C                   EXSR      WRTNT                                        NOTES
     C                   MOVE      'N'           HAVTNT                         ? HAVE NOTES
     C                   END
      *
      * WRITE MAIL-TO  AND SHIP-TO ADDRESSES IF THESE SCREENS ARE USED.
     C     S15HUP        CASEQ     'Y'           UPDMAL                         MAIL ADDR
     C                   ENDCS
     C     S15IUP        CASEQ     'Y'           UPDSHP                         SHIP ADDR
     C                   ENDCS
      *
      * WRITE COMPANIES
     C                   Z-ADD     1             RN
     C     RN            DOUGT     SVRN
   DCC*    RN            CHAIN     ARS5015F                           40
   DCC*    *IN40         IFEQ      '0'
DC   C     RN            CHAIN(E)  ARS5015F
DC   C                   IF        %FOUND
     C     NO16          IFNE      0                                            BRANCH
     C                   EXSR      DATES
     C     CREDIT        IFEQ      'A'                                          BY COMPANY
     C                   MOVEL     FL76          CBFL76                         CR HOLD LOCK
     C                   Z-ADD     AM01          A01                            CREDIT LIMIT
     C                   MOVE      FL03          F03                            HOLD FLAG
     C     FL03          IFEQ      'Y'                                          HOLD ?
     C                   ADD       1             C01                            CNT CUST HELD
     C                   Z-ADD     UMONTH        M12                            MONTH HELD
     C                   Z-ADD     UDAY          D12                            DAY HELD
     C                   MOVEL     *YEAR         C12                            CENTURY HELD
     C                   Z-ADD     UYEAR         Y12                            YEAR HELD
     C                   ELSE
     C                   Z-ADD     0             M12                            MONTH HELD
     C                   Z-ADD     0             D12                            DAY HELD
     C                   Z-ADD     0             C12                            CENTURY HELD
     C                   Z-ADD     0             Y12                            YEAR HELD
     C                   END                                                    FL03 EQ Y
     C                   ELSE
     C                   Z-ADD     ARAM01        A01                            CREDIT LIMIT
     C                   END                                                    *IN30 EQ 1
     C                   Z-ADD     NO16          ARNO16                         BRANCH
     C                   MOVE      ID01          ARID01                         SALESPERSON
     C                   MOVE      ID05          ARID05
CI   C                   MOVE      ID08          ARID08
     C                   MOVE      FL14          ARFL14                         SVC CHG FLG
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   Z-ADD     11            ARCD51                         TRANS CODE
     C                   Z-ADD     LSTMDT        DLSTMT                         DT LAST STATMNT
     C                   Z-ADD     ACDT1         DACTPR                         ACT PERIOD
     C                   EXSR      CLRAMT
     C                   WRITE     ARFMBAL
     C                   Z-ADD     ACDT2         DSTMPR                         STMT PERIOD
     C                   WRITE     ARFHBAL
CM   c                   Exsr      CusEvent
     C                   END                                                    NO16 NE 0
     C                   END                                                    *IN40 EQ 0
     C                   ADD       1             RN
     C                   END                                                    RN DOUGT SVRN
CK    * Capture new customer event
CK CLC*                  Eval      cusnamE3    = ARNM01
CK CLC*                  Eval      cusnumE3    = ARNO01
CK CLC*                  Eval      cusmailstE3 = ARST01
CK CLC*                  Eval      slsbrnumE3  = ARNO16
CK CLC*                  Eval      slsidE3     = ARID01
CK CLC*                  Call      'SHC5050'
CK CLC*                  Parm      'HDE0003'     EventID                        Event Id
CK CLC*                  Parm                    d_HDE0003
CL CMC*                  Exsr      CusEvent
DM    *
DM    * If tax exempt flag is Y, call program to update in CertCapture also
DM   C                   if        certCapture = 'Y'
DM $DC*                            and arfl13 = 'Y'
DM    * Determine if licensed to this product...
DM    * The following license key checking logic may not be altered, bypassed or removed.
DM    * See Legal Document in WRKMINKEY command for more information.
DM   C                   if        licToAvaTax
DM   C                   eval      pMode = 'A'
DM   C                   exsr      srCallCertsv
DM    * Display error message if not licensed to AvaTax
DM   C                   else
DM   C                   eval       p1300App  = 'AVATAX'
DM   C                   call      'MNR1300'     pl1300
DM   C                   endif
DM   C                   endif
DM    *
     C                   ELSE
      *
      * UPDATE EXISTING CUSTOMER INFO
      * UPDATE SCREENS THE USERS HAS (REVIEWED &) GONE THRU.
     C     S15AUP        IFEQ      'Y'
     C     S15BUP        OREQ      'Y'
     C     S15CUP        OREQ      'Y'
     C     S15JUP        OREQ      'Y'
     C                   EXSR      UPDCUS                                       UPD CUST MST
     C                   ENDIF
     C     S15AUP        IFEQ      'Y'
     C                   EXSR      UPDHIS                                       A/R HIST BAL
     C                   EXSR      UPDEMA                                       E-MAIL
     C                   ENDIF
     C     S15EUP        CASEQ     'Y'           WRTNT                          NOTE
     C                   ENDCS
     C     S15FUP        CASEQ     'Y'           UPDBAL                         A/R BAL
     C                   ENDCS
     C     S15HUP        CASEQ     'Y'           UPDMAL                         MAIL ADDR
     C                   ENDCS
     C     S15IUP        CASEQ     'Y'           UPDSHP                         SHIP ADDR
     C                   ENDCS
CL CMC*                  If        f3flg = 'Y'
CL CMC*                  Exsr      CusEvent
CL CMC*                  Endif
      *
DM    * If tax exempt flag is Y, call program to update in CertCapture also
DM   C                   if        certCapture = 'Y'
DM $DC*                            and arfl13 = 'Y'
DM    * Determine if licensed to this product...
DM    * The following license key checking logic may not be altered, bypassed or removed.
DM    * See Legal Document in WRKMINKEY command for more information.
DM   C                   if        licToAvaTax
DM    * If customer is being created as a like customer, send 'A' -Add
DM    * as flag to certcapture.
DM   C                   if        f3flg = 'Y'
DM   C                   eval      pMode = 'A'
DM   C                   else
DM   C                   eval      pMode = 'C'
DM    * Pass flag as Y to update in CertCapture if customer details
DM    * are changed
DM   C                   eval      pUpdCust = 'N'
DM   C                   if        svAddr     <> addrVal
DM   C                             or svFax   <> faxnum
DM   C                             or svPhone <> phNum
DM   C                             or svEmail <> %trim(email)
DM   C                             or brnChg   = 'Y'
DM   C                             or updCnct  = 'Y'
DM   C                   eval      pUpdCust = 'Y'
DM   C                   endif
DM   C                   endif
DM   C                   exsr      srCallCertsv
DM    * Display error message if not licensed to AvaTax
DM   C                   else
DM   C                   eval       p1300App  = 'AVATAX'
DM   C                   call      'MNR1300'     pl1300
DM   C                   endif
DM   C                   endif
     C                   END                                                    ADDCUS EQ Y
      *
      * CHAIN TO THE CUSTOMER PRINT FREQUENCY FILE FOR PRINT INFORMATION
     C                   MOVE      ARFL52        FL52
     C                   MOVE      ARFL54        FL54
     C                   MOVE      ARFL55        FL55
     C                   MOVE      ARFL56        FL56
     C                   MOVE      ARFL57        FL57
     C                   MOVE      ARFL58        FL58
     C                   MOVE      ARFL59        FL59
     C                   MOVE      ARFL60        FL60
     C                   MOVE      ARFL61        FL61
     C                   Z-ADD     ARNOA7        NOA7
     C                   Z-ADD     ARNOA8        NOA8
     C                   Z-ADD     ARNOA9        NOA9
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   CLEAR                   DSPF1
     C     *IN92         DOUEQ     *OFF
     C     ARNO01        CHAIN     ARFMFRQ                            4692      ENTERPRISE MASTER
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C                   MOVE      FL52          ARFL52
     C                   MOVE      FL54          ARFL54
     C                   MOVE      FL55          ARFL55
     C                   MOVE      FL56          ARFL56
     C                   MOVE      FL57          ARFL57
     C                   MOVE      FL58          ARFL58
     C                   MOVE      FL59          ARFL59
     C                   MOVE      FL60          ARFL60
     C                   MOVE      FL61          ARFL61
     C                   Z-ADD     NOA7          ARNOA7
     C                   Z-ADD     NOA8          ARNOA8
     C                   Z-ADD     NOA9          ARNOA9
      *
      * WRITE PRINT FREQUENCY RECORD
     C     ADDFRQ        IFEQ      'Y'
     C     *IN46         ANDEQ     *ON
     C                   Z-ADD     ARNO01        CUSTNO                         CUSTOMER NUMBER
     C                   WRITE     ARFMFRQ
      *
      * UPDATE PRINT FREQUENCY RECORD
     C                   ELSE                                                               NTERPRIS
     C                   UPDATE    ARFMFRQ                                      UPDATE ENTERPRISE
     C                   ENDIF
DD    *
DD    *  If using AvaTax, update Zip code master file and
DD    *     update Tax Jurisdiction by Zip code master file
DD   C                   if        AvaTaxActive = 'Y'
DD   C                             and LicToAvaTax
DD   C                   z-add     arcd04        pi_juris
DD   C                   move      arzp16        pi_zip
DD   C                   call      'ARR5218'     PL5218
DD   C                   z-add     arcd30        pi_juris
DD   C                   move      arzp16        pi_zip
DD   C                   call      'ARR5218'     PL5218
DD   C                   endif
¢B    * WRITE CUST COMMENTS
¢B   C                   MOVEL     COMMNT        SVCOMT           60
¢t   C                   MOVEL     prclv1        svprc1            1
¢t   C                   MOVEL     prclv2        svprc2            1
¢6   C                   MOVEL     prclv3        svprc3            1
¢6   C                   MOVEL     prclv4        svprc4            1
¢6   C                   MOVEL     prclv5        svprc5            1
¢W   C                   MOVEL     CHGFRT        SVCHGFRT          1
¢4   C                   Z-ADD     cntpro        SVcntpro          8 0
¢7   C                   Z-ADD     ECmo01        SVECmo01          2 0
¢7   C                   Z-ADD     ECyr01        SVECyr01          2 0
¢7   C                   Z-ADD     ECdy01        SVECdy01          2 0
¢7   C                   Z-ADD     ECcc01        SVECcc01          2 0
¢9   C                   MOVE      CMCD07        SVCMCD07          1
¢B   C     ARNO01        CHAIN     ARFCSCMT                           43
¢B   C     *IN43         IFEQ      *OFF
¢B   C                   DELETE    ARFCSCMT
¢B   C                   END
¢B   C                   MOVEL     SVCOMT        COMMNT
¢t   C                   MOVEL     svprc1        prclv1
¢t   C                   MOVEL     svprc2        prclv2
¢6   C                   MOVEL     svprc3        prclv3
¢6   C                   MOVEL     svprc4        prclv4
¢6   C                   MOVEL     svprc5        prclv5
¢W   C                   MOVEL     SVCHGFRT      CHGFRT
¢W   C                   MOVEL     SVEPDID       EPDSLS
¢2   C                   Z-ADD     SVcntpro      cntpro
¢7   C                   Z-ADD     SVECmo01      ECmo01
¢7   C                   Z-ADD     SVECyr01      ECyr01
¢7   C                   Z-ADD     SVECdy01      ECdy01
¢7   C                   Z-ADD     SVECcc01      ECcc01
¢9   C                   MOVE      SVCMCD07      CMCD07
¢B   C                   WRITE     ARFCSCMT
¢J    * WRITE CONTRACT PROFILE RCD
¢J    * IF WHOLESALER, WRITE THIS CONTRACT PRF
¢J   C     ARCD02        IFEQ      'GM'                                         NOT GMC WHOLE
¢J   C                   Z-ADD     8             PRNO12
¢J   C     CONTK         CHAIN     PRFCONT                            43
¢J   C     *IN43         IFEQ      *OFF
¢J   C                   DELETE    PRFCONT
¢J   C                   END
¢J   C                   Z-ADD     18            PRNO12
¢J   C     CONTK         CHAIN     PRFCONT                            43
¢J   C     *IN43         IFEQ      *ON
¢J   C                   MOVE      'C'           PRCD72
¢J   C                   Z-ADD     12            PRMO15
¢J   C                   Z-ADD     26            PRDY15
¢J   C                   Z-ADD     3             PRYR15
¢J   C                   Z-ADD     20            PRCC15
¢J   C                   Z-ADD     12            PRMO16
¢J   C                   Z-ADD     25            PRDY16
¢J   C                   Z-ADD     20            PRYR16
¢J   C                   Z-ADD     20            PRCC16
¢J   C                   MOVE      'C'           PRCD76
¢J   C                   MOVEL     'FIXIT'       PRNM01
¢J   C                   WRITE     PRFCONT
¢J   C                   END
¢J   C                   END
CI    * Add-on fields update...
CI   C                   eval      RsvFile    = 'ARPMCUA'
CI   C                   eval      RsvField   = *BLANKS
CI   C                   eval      RsvDefType = *BLANKS
CI   C                   eval      RsvJobKey  = 'N'
CI   C                   eval      arpmcuaCust = ARNO01
CI   C                   eval      RsvParms  = arpmcuaData
CI   C                   eval      pretcd     = ' '
CI   C                   eval      pactcd     = 'UP'
CI   C                   eval      pfunky     = '  '
CI   C                   eval      pdata     = RsvData
CI   C                   call      'OPR3220'     PL3220
CI    *
      * END OF JOB
     C     ENDPGM        TAG
      *------------------------------------------------------------------------*
      * STEP 9. * WRITE AUDIT RECORD--AFTER UPDATE
      *------------------------------------------------------------------------*
     C     ARNO01        CHAIN(N)  ARFMCUS                            46
     C     ARNO01        CHAIN(N)  ARFMBAL                            46
     C     *IN46         DOWEQ     *OFF
     C     CREDIT        IFEQ      'C'                                          CONSOLIDATED
     C                   Z-ADD     ARAM01        CAAM01                         CREDIT LIMIT
     C                   MOVEL     ARFL03        CAFL03                         CR HLD FLG
     C                   MOVEL     ARFL76        CAFL76                         CR HLD LOCK
     C                   Z-ADD     ARCN01        CACN01                         HOLD COUNT
     C                   Z-ADD     ARMO12        CAMO12                         MONTH HELD
     C                   Z-ADD     ARDY12        CADY12                         DAY HELD
     C                   Z-ADD     ARCC12        CACC12                         CENTURY HELD
     C                   Z-ADD     ARYR12        CAYR12                         YEAR HELD
     C                   ELSE
     C                   Z-ADD     A01           CAAM01                         CREDIT LIMIT
     C                   MOVEL     F03           CAFL03                         CR HLD FLG
     C                   MOVEL     CBFL76        CAFL76                         CR HLD LOCK
     C                   Z-ADD     C01           CACN01                         HOLD COUNT
     C                   Z-ADD     M12           CAMO12                         MONTH HELD
     C                   Z-ADD     D12           CADY12                         DAY HELD
     C                   Z-ADD     C12           CACC12                         CENTURY HELD
     C                   Z-ADD     Y12           CAYR12                         YEAR HELD
     C                   ENDIF
     C                   TIME                    ARTM01                         UPDATE TIME
     C                   MOVE      'A'           ARCD23                         BEFORE UPDATE
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DAUDIT                         TRANS AUDIT DT
CO   C                   MOVEL     ARCDF9        CACDF9                         TRANS AUDIT DT
CO   C                   MOVEL     ARFL77        CAFL77                         TRANS AUDIT DT
CO   C                   MOVEL     ARFL72        CAFL72                         TRANS AUDIT DT
CO   C                   MOVEL     ARFL73        CAFL73                         TRANS AUDIT DT
CO   C                   MOVEL     ARDN08        CADN08                         TRANS AUDIT DT
CO   C                   Z-ADD     ARDY89        CADY89                         TRANS AUDIT DT
CO   C                   Z-ADD     ARMO89        CAMO89                         TRANS AUDIT DT
CO   C                   Z-ADD     ARCC89        CACC89                         TRANS AUDIT DT
CO   C                   Z-ADD     ARYR89        CAYR89                         TRANS AUDIT DT
CO   C                   MOVEL     ARID05        CAID05                         TRANS AUDIT DT
     C                   WRITE     ARFTCSA                                      AUDIT TRANS
     C     ARNO01        READE(N)  ARFMBAL                                46
     C                   ENDDO
¢3   C     CREDIT        IFEQ      'C'                                          CONSOLIDATED
¢3   C     ARAM01        ANDNE     ORGAM01                                      CONSOLIDATED
¢3   C                   Z-ADD     ORGAM01       ARAM01B4                       BY COMPANY
¢3   C                   Z-ADD     ARAM01        ARAM01NW                       BY COMPANY
¢3   C                   Z-ADD     UMONTH        ARMO09                         MONTH HELD
¢3   C                   Z-ADD     UDAY          ARDY09                         DAY HELD
¢3   C                   MOVEL     *YEAR         ARCC09                         CENTURY HELD
¢3   C                   Z-ADD     UYEAR         ARYR09                         YEAR HELD
¢3   C                   TIME                    ARTM01                         YEAR HELD
¢3   C                   MOVEL     USRNM         ARNM03                         CENTURY HELD
¢3   C                   WRITE     ARFCCSA                                      CENTURY HELD
¢3   C                   ENDIF                                                  CONSOLIDATED
      *------------------------------------------------------------------------*
      *  REMOVED MAILDS AND SHIPDS DATA STRUCTURES AS
      *  MAIL-TO AND SHIP-TO ADDRESS ARE ADDED THRU CONTROL FLAGS.
      *
     C     ENTLOK        IFEQ      'Y'
     C     ARNO82        ANDNE     *ZERO
   CNC*                  EXCEPT    DUMMY
CN   C                   EXCEPT    DUMMY1
     C                   ENDIF
      *
      *
      * CHECK WHETHER W/H MANAGEMENT SYSTEM IS INSTALLED OR NOT.
     C                   MOVE      '03'          PMIAPL
     C                   CALL      'OPR0400'     PL0400
     C     PMOYN         IFEQ      'Y'
     C                   MOVE      'Y'           WHMYES            1
     C                   ELSE
     C                   MOVE      'N'           WHMYES
     C                   ENDIF
      *
     C     WHMYES        IFEQ      'Y'
     C     *IN03         ANDNE     *ON
     C                   CLEAR                   PDATA
     C                   MOVE      'CSM'         WMFRM
     C                   MOVEL     ARNO01        PDATA
     C                   CALL      'WXR5956'
     C                   PARM                    WMFRM             3
     C                   PARM                    PDATA           256
   DSC*                  CLEAR                   CUSDTA
     C                   CLEAR                   WMGRP#
     C                   CALL      'WIR0118'
     C                   PARM                    WMGRP#           15
      *
   DS * CALL PGM TO ENTER WM CODES FOR CUSTOMER
   DSC*                  Z-ADD     ARNO01        CMNO01
   DSC*                  MOVE      'M'           CMFUNC
   DSC*                  MOVE      'CSM'         CMCODE
   DSC*                  MOVE      'CM'          CMFRM
   DSC*                  CLEAR                   CMDTTM
   DSC*                  CLEAR                   CMERCD
   DSC*                  MOVE      WMGRP#        CMGRP#
   DSC*                  CLEAR                   WMERR
   DSC*                  CALL      'WIR0175'
   DSC*                  PARM                    CUSDTA
   DSC*                  PARM                    WMERR             3
     C                   ENDIF
      *
      *  REMOVE WORK FILE RECORDS FOR NEW CUSTOMER
      *
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   CLEAR                   DSPF1
     C     *IN92         DOUEQ     *OFF
     C     ARNO01        CHAIN     ARPWARM                            4692
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN46         IFEQ      *OFF
     C                   DELETE    ARFWARM
     C                   ENDIF
CI    * Add-on fields remove work records...
CI   C                   eval      RsvFile    = 'ARPMCUA'
CI   C                   eval      RsvField   = *BLANKS
CI   C                   eval      RsvDefType = *BLANKS
CI   C                   eval      RsvJobKey  = 'N'
CI   C                   eval      arpmcuaCust = ARNO01
CI   C                   eval      RsvParms  = arpmcuaData
CI   C                   eval      pretcd     = ' '
CI   C                   eval      pactcd     = 'RW'
CI   C                   eval      pfunky     = '  '
CI   C                   eval      pdata     = RsvData
CI   C                   call      'OPR3220'     PL3220
CI    *
     C                   SETON                                        LR
     C                   RETURN
      *------------------------------------------------------------------------*
      *  SUBROUTINE    INITIALIZE                                              *
      *------------------------------------------------------------------------*
     C     INITSR        BEGSR
     C     *DTAARA       DEFINE                  ARAUDT
     C     *LOCK         IN        ARAUDT                                       AUDIT TRANS
     C                   MOVE      AUDNO         ARNO22                         CONTROL NUMBER
     C     ARNO22        ADD       1             AUD#              7 0          DATA AREA
     C                   MOVE      AUD#          AUDNO
     C                   OUT       ARAUDT
¢R   C     *DTAARA       DEFINE                  PERZIP
¢R   C                   IN        perzip                                       AUDIT TRANS
      *----------------------------------------------------------------
      * DETERMINE IF FAX IS SET UP ON TABLE FILE FOR AR IF SO, THEN
      * GET LOCAL AREA CODE FOR FAX EXCHANGE COMPARISON.
      *
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVE      *BLANKS       TBNO03
     C                   MOVEL     'FAX '        TBNO01                         TABLE CODE
     C                   MOVEL     'AR'          TBNO02                         TABLE ENTRY
     C     TBKEY         CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TBNO03        FAX               1            SET WRKFLD
     C                   END
     C     FAX           COMP      'Y'                                    33
     C     *IN33         IFEQ      '1'
     C                   MOVEL     *BLANKS       TBNO01                         TABLE CODE
     C                   MOVEL     'FAX '        TBNO01                         TABLE CODE
     C                   MOVE      *BLANKS       TBNO02                         TABEL ENTRY
     C                   MOVEL     'LOCAL'       TBNO02                         TABLE ENTRY
     C                   MOVE      *BLANKS       TBNO03
     C     TBKEY         CHAIN     TBFMTBL                            49
     C                   CLEAR                   FX
     C     *IN49         DOWEQ     *OFF
     C     FX            ANDLT     50
     C                   ADD       1             FX                2 0
     C                   MOVEL     TBNO03        FCD(FX)
     C     TBKEY         READE     TBFMTBL                                49
     C                   ENDDO
     C                   MOVEL     *BLANKS       TBNO01                         TABLE CODE
     C                   MOVE      *BLANKS       TBNO02                         TABEL ENTRY
     C                   MOVE      *BLANKS       TBNO03
     C                   END                                                    *IN33 = '1'
      *
      * DETERMINE IF EMAIL IS SET UP
      *
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVE      *BLANKS       TBNO03
     C                   MOVEL     'FAX '        TBNO01                         TABLE CODE
     C                   MOVEL     'EMAIL'       TBNO02                         TABLE ENTRY
     C                   CLEAR                   EALLOW
     C     TBKEY         CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        EALLOW            1
     C                   ENDIF
   EB *----------------------------------------------------------------
   EB * SEE IF USING GST TAX ?
   EB *
   EBC*                  MOVE      'AR17'        TBNO01
   EBC*                  MOVE      *BLANKS       TBNO02
   EBC*                  MOVEL     'GSTTAX'      TBNO02
   EBC*                  MOVE      'Y'           TBNO02
   EBC*    TBKEY         SETLL     TBFMTBL                                71
      *----------------------------------------------------------------
     C                   MOVE      'AR09'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'MAINT'       TBNO02
     C     TBKEY         CHAIN     TBFMTBL                            49
     C     *IN49         IFEQ      '0'
     C                   MOVEL     TBNO03        CRDCLS
     C     CREDIT        IFNE      'A'
     C     CREDIT        ANDNE     'C'
     C                   MOVEL     'C'           CREDIT
     C                   ENDIF
     C     CREDIT        IFEQ      'C'                                          CONSOLIDATED
     C                   MOVE      '0'           *IN30
     C                   ELSE
     C                   MOVE      '1'           *IN30                          BY COMPANY
     C                   END
     C     CLSE          IFEQ      'C'                                          CONSOLIDATED
     C                   MOVE      '0'           *IN31
     C                   ELSE
     C                   MOVE      '1'           *IN31                          BY COMPANY
     C                   END
     C                   CLEAR                   TBNO01
     C                   CLEAR                   TBNO02
     C                   MOVEL     'ADON'        TBNO01
     C                   MOVEL     'ADDON'       TBNO02
     C     TBKEY         CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        ADDON
     C                   ENDIF
     C     IASYS         IFEQ      'Y'
     C                   MOVE      *ON           *IN48
     C                   ELSE
     C                   MOVE      *OFF          *IN48
     C                   ENDIF
DU    *
DU    * Check whether using Card Connect interface or not
DU   C                   eval      card_interface = ' '
DU   C                   move      'AR27'        tbno01
DU   C                   move      *blanks       tbno02
DU   C                   MOVEL     'CARD'        tbno02
DU   C     tbkey         chain     tbfmtbl
DU   C                   if        %found
DU   C                   movel     tbno03        card_tabentry
DU   C                   If        using_card = 'Y' and
DU   C                             card_software = 'CARDCONNECT'
DW   C                             or card_software = 'WORLDPAY'
DU   C                   eval      card_interface = 'Y'
DU   C                   endif
DU   C                   endif
DU    *
      * DEFAULT CUSTOMER TYPE O REQUIRED
     C                   MOVE      'O'           ARCD22
      * DEFAULT CUSTOMER STATEMENT TYPE (OPEN ITEM OR BAL. FORWARD)
     C                   MOVE      DFTSMT        ARCD29
      * TEST FOR NO MAINTENANCE OF CUSTOMER STATEMENT TYPE
     C     ALWSMT        CAB       'Y'                                    58
      * TEST FOR NO MAINTENANCE OF PICKUP TAX JURISDICTION CODE
     C     ALWTAX        CAB       'Y'                                    59
     C                   END
     C                   MOVE      'Y'           ADDCUS            1            ADD CUSTOMER ?
     C                   MOVE      *ON           *IN27
     C                   MOVE      'Y'           ADDFRQ            1            ADD PRINT FREQUENCY
     C                   MOVE      'Y'           DSPFAX            1            DSP FAX WINDOW
     C                   MOVE      'Y'           FRSTIM            1            FIRST TIME THRU
     C                   MOVE      'Y'           FRSTM             1            FIRST TIME THRU
     C                   MOVE      'Y'           FRSTME            1            FIRST TIME THRU
     C                   MOVE      'N'           FL11              1            NOTES EXIST
     C                   MOVE      'Y'           FRSTSH            1            FIRST TIME THRU
     C                   MOVE      'Y'           FRSTMS            1            FIRST TIME THRU
     C                   Z-ADD     0             ARMO09                         UPDATE MONTH
     C                   Z-ADD     0             ARDY09                         UPDATE DAY
     C                   Z-ADD     0             ARCC09                         UPDATE CENTURY
     C                   Z-ADD     0             ARYR09                         UPDATE YEAR
     C                   Z-ADD     0             DLSTUP                         UPDATE DATE
     C                   Z-ADD     0             ARMO11                         MONTH CLOSED
     C                   Z-ADD     0             ARDY11                         DAY CLOSED
     C                   Z-ADD     0             ARCC11                         CENTURY CLOSED
     C                   Z-ADD     0             ARYR11                         YEAR CLOSED
     C                   Z-ADD     0             DACCLS                         DATE CLOSED
     C                   Z-ADD     0             ARMO12                         MONTH HELD
     C                   Z-ADD     0             ARDY12                         DAY HELD
     C                   Z-ADD     0             ARCC12                         CENTURY HELD
     C                   Z-ADD     0             ARYR12                         YEAR HELD
     C                   Z-ADD     0             DACHLD                         DATE HELD
     C                   Z-ADD     0             ARMO14                         MONTH START
     C                   Z-ADD     0             ARDY14                         DAY START
     C                   Z-ADD     0             ARCC14                         CENTURY START
     C                   Z-ADD     0             ARYR14                         YEAR START
     C                   Z-ADD     0             DACSTR                         HIST STARTED
     C                   Z-ADD     0             ARMO15                         STMNT MONTH
     C                   Z-ADD     0             ARDY15                         STMNT DAY
     C                   Z-ADD     0             ARCC15                         STMNT CENTURY
     C                   Z-ADD     0             ARYR15                         STMNT YEAR
     C                   Z-ADD     0             DLSTMT                         LAST STMNT DATE
     C                   Z-ADD     0             ARMO17                         AUDIT MONTH
     C                   Z-ADD     0             ARDY17                         AUDIT DAY
     C                   Z-ADD     0             ARCC17                         AUDIT CENTURY
     C                   Z-ADD     0             ARYR17                         AUDIT YEAR
     C                   Z-ADD     0             DAUDIT                         TRANS AUDIT DT
     C                   Z-ADD     0             ARMO50                         ACT MONTH
     C                   Z-ADD     0             ARCC50                         ACT CENTURY
     C                   Z-ADD     0             ARYR50                         ACT YEAR
     C                   Z-ADD     0             DACTPR                         ACTING PERIOD
     C                   Z-ADD     0             MONTH                          UMONTH
     C                   Z-ADD     0             DAY                            UDAY
     C                   Z-ADD     0             CEN                            CENTURY
     C                   Z-ADD     0             YEAR                           UYEAR
     C                   Z-ADD     0             DATE                           UDATE
     C                   Z-ADD     UMONTH        MONTH                          UMONTH
     C                   Z-ADD     UDAY          DAY                            UDAY
     C                   Z-ADD     UYEAR         YEAR                           UYEAR
     C                   MOVEL     *YEAR         CEN                            CENTURY
     C                   Z-ADD     0             FDATE                          FOLLOW-UP
     C                   Z-ADD     0             CC53                           FOLLOW-UP
     C                   MOVE      *BLANKS       STDTE            16            STATEMENT
     C                   CLEAR                   STDATE
     C                   CLEAR                   ACDATE
     C     *LIKE         DEFINE    XXCD04        CD04M                          TAX J/CODE
     C     *LIKE         DEFINE    XXID01        ID01M                          SLSMAN-ID
     C     *LIKE         DEFINE    ARNM05        SVNM05                         SORT NAME
     C     *LIKE         DEFINE    CROW          ROW
     C     *LIKE         DEFINE    CCOL          COL
     C     *LIKE         DEFINE    CRCD          CRCD#
     C     *LIKE         DEFINE    CFLD          CFLD#
     C     *LIKE         DEFINE    ARNO05        SVNO05
     C     *LIKE         DEFINE    ARFL04        SVFL04
     C     *LIKE         DEFINE    ARCD29        SVCD29
     C     *LIKE         DEFINE    ARFL72        SVFL72
     C     *LIKE         DEFINE    ARFL02        SVFL02
     C     *LIKE         DEFINE    ARFL01        SVFL01
     C     *LIKE         DEFINE    ARCD65        SVCD65
     C     *LIKE         DEFINE    ARCDB7        SVCDB7
     C     *LIKE         DEFINE    ARCDB8        SVCDB8
     C     *LIKE         DEFINE    ARCDF9        SVCDF9
     C     *LIKE         DEFINE    ARCDE7        SVCDE7
     C     *LIKE         DEFINE    ARFL48        SVFL48
     C     *LIKE         DEFINE    ARFL50        SVFL50
     C     *LIKE         DEFINE    ARFL52        SVFL52
     C     *LIKE         DEFINE    ARFL61        SVFL61
C1   C     *LIKE         DEFINE    ARFL88        SVFL88
C2   C     *LIKE         DEFINE    ARFL91        SVFL91
     C     *LIKE         DEFINE    ARFL52        FL52
     C     *LIKE         DEFINE    ARFL54        FL54
     C     *LIKE         DEFINE    ARFL55        FL55
     C     *LIKE         DEFINE    ARFL56        FL56
     C     *LIKE         DEFINE    ARFL57        FL57
     C     *LIKE         DEFINE    ARFL58        FL58
     C     *LIKE         DEFINE    ARFL59        FL59
     C     *LIKE         DEFINE    ARFL60        FL60
     C     *LIKE         DEFINE    ARFL61        FL61
     C     *LIKE         DEFINE    ARNOA7        NOA7
     C     *LIKE         DEFINE    ARNOA8        NOA8
     C     *LIKE         DEFINE    ARNOA9        NOA9
     C     *LIKE         DEFINE    ARID05        F4ID05
     C     *LIKE         DEFINE    RN            RRN
     C     *LIKE         DEFINE    ARNM01        NM01CN
     C     *LIKE         DEFINE    ARNO07        NO07CN
     C     *LIKE         DEFINE    ARNO08        NO08CN
     C     *LIKE         DEFINE    ARNO09        NO09CN
     C     *LIKE         DEFINE    ARZP16        ZPCD
     C     *LIKE         DEFINE    ARCD04        TXCD
     C     *LIKE         DEFINE    ARZP16        CPYZIP
DD   C     *LIKE         DEFINE    ARCD04        pi_juris
DD   C     *LIKE         DEFINE    ARZP16        pi_zip
$F   C     *LIKE         DEFINE    *IN69         SAVE_IN69
$F   C     *LIKE         DEFINE    RNO           BOTTOMRNO
      *----------------------------------------------------*
     C                   Z-ADD     0             NO41M
     C                   Z-ADD     0             NO42M
     C                   Z-ADD     0             NO43M
     C                   MOVE      *BLANKS       ZP21M
     C                   Z-ADD     0             FAXSV                          FAX SAVE
     C                   MOVE      *BLANKS       NM21M                          SHORT DESC
     C                   MOVE      'N'           ARFL29
     C                   Z-ADD     0             CD04M                          TAX J/CODE
     C                   MOVE      *BLANKS       ID01M                          SLSMAN-ID
     C                   Z-ADD     0             NO41S
     C                   Z-ADD     0             NO42S
     C                   Z-ADD     0             NO43S
     C                   MOVE      *BLANKS       ZP21S
     C                   MOVE      *BLANKS       DN08S
     C                   MOVE      *BLANKS       NM21S                          SHORT DESC
     C                   Z-ADD     0             CD04S                          TAX J/CODE
     C                   Z-ADD     0             OPNDAT
¢7   C                   Z-ADD     0             RVWDAT
     C                   Z-ADD     *ZERO         ARCC02
     C                   MOVE      *BLANKS       ID01S                          SLSMAN-ID
D5   C                   Z-ADD     0             CNO05S
D5   C                   Z-ADD     0             CNO06S
      ***  RETRIEVE THE USER'S SECURITY PROFILE.
     C                   MOVE      'UIDS'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     USRNM         TBNO02
     C     TBKEY         CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TBNO03        SECPRF            7            SECURITY PROFIL
     C                   END
      ***  RETRIEVE THE COMPANIES THAT THE USER IS AUTHORIZED TO.
     C                   Z-ADD     0             @X                3 0
     C     SECPRF        CHAIN     OPFMSEC                            40
     C     *IN40         DOWEQ     '0'
     C     OPNO02        IFEQ      0
     C                   MOVE      'Y'           ALLOK             1            ALL CO'S OK
     C                   SETON                                        5240      ALL CO'S OK
     C                   ELSE
     C                   ADD       1             @X                             ARRAY INDEX
     C                   MOVE      OPNO02        SEC(@X)
     C                   END
     C     SECPRF        READE     OPFMSEC                                40
     C                   END
      *
      * JUST TO GET INPUT SPECS FOR RENAME
      *
     C     NEVER         IFNE      *BLANKS
     C                   READ(N)   ARFTCSA                                40
     C                   MOVE      *BLANKS       NEVER             1
     C                   ENDIF
      *
      * CLEAR SCREEN ERROR AND UPDATE FLAGS
      * CLEAR F10 UPDATE & EXIT FLAG
     C                   MOVE      *BLANKS       SCRNER
     C                   MOVE      *BLANK        S15AUP            1
     C                   MOVE      *BLANK        S15BUP            1
     C                   MOVE      *BLANK        S15CUP            1
     C                   MOVE      *BLANK        S15EUP            1
     C                   MOVE      *BLANK        S15FUP            1
     C                   MOVE      *BLANK        S15GUP            1
     C                   MOVE      *BLANK        S15HUP            1
     C                   MOVE      *BLANK        S15IUP            1
     C                   MOVE      *BLANK        S15JUP            1
     C                   MOVE      *BLANK        F10FLG            1
     C                   MOVE      *BLANK        F11FLG            1
CI    * Add-on fields initialization...
CI   C                   eval      RsvFile    = 'ARPMCUA'
CI   C                   eval      RsvField   = *BLANKS
CI   C                   eval      RsvDefType = *BLANKS
CI   C                   eval      RsvJobKey  = 'N'
CI   C                   eval      arpmcuaCust = ARNO01
CI   C                   eval      RsvParms  = arpmcuaData
CI   C                   eval      pretcd     = ' '
CI   C                   eval      pactcd     = 'IZ'
CI   C                   eval      pfunky     = '  '
CI   C                   eval      pdata     = RsvData
CI   C                   call      'OPR3220'     PL3220
CI    *
DM   C                   clear                   svaddr
DM   C                   clear                   svfax
DM   C                   clear                   svPhone
DM   C                   clear                   svemail
DQ    // -- Dummy Open for field definitions...
DQ        if 1 = 2 ;
DQ          open ARQMCUB ;
DQ        endif ;
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    NAME AND ADDRESS                                        *
      *------------------------------------------------------------------------*
     C     NMADS         BEGSR
     C                   MOVE      ARNM05        SVNM05
¢C   C                   MOVEL     ARAD02        ARAD
¢C   C                   MOVE      ARAD03        ARAD
CZ   C                   IF        %SUBST(JOBNAME:1:3) = 'QQF'
CZ   C                   EVAL      *IN47 = *ON
CZ   C                   ENDIF
     C                   MOVE      'Y'           FIRST             1            FIRST TIME
     C                   MOVE      'N'           F3WRN             1
     C                   MOVE      *BLANKS       ERRMSG
B5   C                   MOVE      *IN57         SVIN57
B5   C                   MOVE      *IN58         SVIN58
DD   C                   eval      svin73 = *in73
     C     DSPLY         TAG
D0    *
D0    * Set indicator for bank information command key if user
D0    * is authorized
D0    *
D0   C                   EVAL      *IN71 = *OFF
D0   C                   IF        BNKINFAUTH = 'Y'
D0   C                   EVAL      *IN71 = *ON
D0   C                   ENDIF
D0    *
     C                   EXFMT     ARF5015A
     C                   MOVEA     '0'           *IN(99)                        ERROR OCCURED
     C                   MOVEA     '00'          *IN(93)                        ERROR MESSAGE
     C                   MOVE      *OFF          *IN43                          ONE BEFORE DIAL
     C                   MOVE      *OFF          *IN97
     C                   MOVE      *OFF          *IN98
     C                   MOVE      *OFF          *IN78
     C                   MOVE      *OFF          *IN81
DD   C                   eval      *in73 = *off
$M   C                   Eval      *IN28 = svin28
     C                   MOVE      'Y'           S15AUP
     C                   MOVE      *BLANKS       ERRMSG
CJ   C     f3flg         ifeq      'Y'
CJ   C     *in03         ifeq      *on
CJ   C                   move      '0'           *in03
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(63)       errmsg
CJ   C                   endif
CJ   C                   goto      dsply
CJ   C                   endif
CJ   C     *in10         ifeq      *on
CJ   C                   move      '0'           *in10
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(64)       errmsg
CJ   C                   endif
CJ   C                   goto      dsply
CJ   C                   endif
CJ   C     *in11         ifeq      *on
CJ   C                   move      '0'           *in11
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(65)       errmsg
CJ   C                   endif
CJ   C                   goto      dsply
CJ   C                   endif
CJ   C                   endif
     C     *IN03         IFEQ      *OFF
     C                   MOVE      'N'           F3WRN
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     UMS(5)        ERRMSG
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPLY
     C                   ENDIF
     C                   GOTO      ENDPGM
     C                   ENDIF
     C     *IN25         IFEQ      '1'                                          CMD KEY HELP
     C                   CALL      'HTR0010'                                    HELP TEXT
     C                   PARM                    PROG                           PROGRAM
     C                   PARM                    SCREEN                         SCREEN
     C     *IN25         CABEQ     '1'           DSPLY                          GO TO DISPLAY
     C                   END
      *** DISPLAY IMAGE - CREDIT DOCUMENTS
   CUC*    *IN07         IFEQ      '1'
CU   C     *in23         ifeq      *on
CN   C     icsys         ifeq      'Y'
C4    * Determine if licensed to this product...
C4    * The following license key checking logic may not be altered, bypassed or removed.
C4    * See Legal Document in WRKMINKEY command for more information.
C4   C                   if        LicToDII
CN   C                   clear                   qsearch
CN   C                   movel     'QSEARCH'     qsearch
CN   C                   call      'OPC9832'
CN   C                   parm                    qsearch          10
C4    * Display error message if not licensed to DII (IntelliChief)
C4   C                   else
C4   C                   eval       p1300App  = 'DII'
C4   C                   eval       p1300Bypass = 'N'
C4   C                   call      'MNR1300'     pl1300
C4   C                   endif
CN   C                   GOTO      DSPLY
CN   C                   ELSE
     C                   MOVE      'M'           ACTION
     C                   CALL      'ARR2130'
     C                   PARM                    ARNO01
     C                   PARM                    ACTION            1
     C                   GOTO      DSPLY
CN   C                   endif
     C                   END
CN   C     *in22         ifeq      *on
CN   C     icsys         andeq     'Y'
CN   C                   exsr      srch_index
CN   C                   goto      dsply
CN   C                   endif
$M    *** CHECK SORT NAME AGAINST HYDROS TABLE FILE ENTRIES CLTY
$M   C     SortTg        Tag
$M   C                   EXSR      SORTNMSR
$M   C                   If        *IN28 = *ON
$M   C                   GOTO      DSPLY
$M   C                   ENDIF
      *** ADDITIONAL SHIP TO ADDRESSES
     C     *IN08         IFEQ      '1'
     C                   EXSR      SHADD
     C     F10FLG        CABEQ     'Y'           ENDADS                         END NMADS
     C                   GOTO      DSPLY
     C                   END
      *** ADDITIONAL MAIL TO ADDRESSES
     C     *IN09         IFEQ      '1'
     C                   EXSR      MLADD
     C     F10FLG        CABEQ     'Y'           ENDADS                         END NMADS
     C                   GOTO      DSPLY
     C                   END
     C     *IN06         IFEQ      '1'                                          CMD 06 NOTES
CV    *
CV    * If notes for this customer are currently being
CV    * maintained by someone else, don't allow maintenance...
CV   C                   CLEAR                   pData1010
CV   C                   EVAL      nCustNo = %editc(Arno01: 'X')
CV   C                   EVAL      nNoteCd = 'G'
CV   C                   EVAL      nData = pData1010
CV   C                   EVAL      nActCd = 'L'
CV    * Check in use record...
CV   C                   CALLP     Opr1010(nRetCd: nActCd: nFunky: nData)
CV    *
CV   C                   EVAL      pData1010 = nData
CV   C                   IF        ErrMsg = *Blanks
CV   C                   EVAL      ErrMsg = nMsg
CV   C                   ENDIF
CV    *
CV   C                   IF        nRetCd <>'S'
CV   C                   GOTO      DSPLY
CV   C                   ENDIF
CV    *
     C                   EXSR      NTSSR
CV    *
CV    * Unlock in use record...
CV   C                   EVAL      nActCd = 'U'
CV   C                   CALLP     Opr1010(nRetCd: nActCd: nFunky: nData)
CV    *
     C     F10FLG        CABEQ     'Y'           ENDADS                         END NMADS
     C     *IN06         CABEQ     '1'           DSPLY                          CMD 02 PREVIOUS
     C                   MOVE      FL11          ARFL11                         NOTES EXIST
     C                   END
      * DELETE REQUESTED
     C     *IN11         IFEQ      '1'                                          CMD KEY 11
CD    * If web commerce account exists, don't allow close...
CD   C     ARNO01        SETLL     OEFMCUS                                40
CY   C                   IF        *IN40 = *OFF
CY   C     ARNO01        SETLL     AIFMCUS                                40
CY   C                   ENDIF
CD   C     *IN40         IFEQ      *ON
CP   C     *IN31         ANDEQ     *OFF
CD   C                   MOVE      UMS(9)        ERRMSG
CD   C     ERRMSG        CABNE     *BLANKS       DSPLY
CD   C                   ENDIF
¢O $C * OPEN CONTRACT PROFILE
¢O $Cc*    arno01        setll     prfcont                                45
¢O $Cc*    *IN45         ifeq      *ON
¢O $Cc*    arno01        reade     prfcont                                45
¢O $Cc*    *IN45         doweq     *off
¢O $Cc*                  delete    prfcont
¢O $Cc*    arno01        reade     prfcont                                45
¢O $Cc*                  enddo
¢O $Cc*                  end
CE    * Not allowed if contract profiles exist...
CE ¢OC*    ARNO01        SETLL     PRFMCPS                                40
CE ¢OC*    *IN40         IFEQ      *ON
CE ¢OC*                  MOVE      *ON           *IN78
CE ¢OC*    *IN78         CABEQ     *ON           DSPLY
CE ¢OC*                  ENDIF
CE    * Not allowed if contract profiles exist...
$C   C     ARNO01        SETLL     PRFMCPS                                40
$C   C     *IN40         IFEQ      *ON
$C   C                   MOVE      *ON           *IN78
$C   C     *IN78         CABEQ     *ON           DSPLY
$C   C                   ENDIF
CE    * Not allowed if customer discounts exist...
CE ¢OC*    ARNO01        SETLL     PRFMCPF                                40
CE ¢OC*    *IN40         IFEQ      *ON
CE ¢OC*                  MOVE      *ON           *IN81
CE ¢OC*    *IN81         CABEQ     *ON           DSPLY
CE ¢OC*                  ENDIF
DW    * If credit cards on account exist, don't allow close...
DW   C                   CALL      'OER9753'
DW   C                   PARM                    ARNO01
DW   C                   PARM      *ZEROS        CC_COUNT
DW   C     CC_COUNT      IFNE      *ZEROS
DW   C     *IN31         ANDEQ     *OFF
DW   C                   EVAL      ERRMSG = 'Deletion not allowed - credit card-
DW   C                             s on file still exist for customer.'
DW   C     ERRMSG        CABNE     *BLANKS       DSPLY
DW   C                   ENDIF
DZ    *
DZ    * If active deposits from for customer, don't allow close...
DZ   C                   EXSR      ACTVDP
DZ   C     ACTIVDEP      IFEQ      'Y'
DZ   C                   EVAL      ERRMSG = 'Deletion not allowed - active depo-
DZ   C                             sits found for customer.'
DZ   C     ERRMSG        CABNE     *BLANKS       DSPLY
DZ   C                   ENDIF
CE    *
     C     *IN31         IFEQ      '0'
     C     ADDCUS        CABEQ     'Y'           DSPLY                    96    ERROR MESSAGE
     C     *IN50         CABEQ     '0'           DSPLY                    50    MSG NOT DSPLYD
     C                   EXSR      CLOSE
     C     *IN99         CABEQ     '1'           DSPLY                          ERROR OCCURED
     C     *IN99         CABEQ     '0'           ENDPGM                         CLOSED ACCOUNT
     C                   ELSE
     C                   EXSR      CMPCLS
     C     *IN12         CABEQ     '1'           DSPLY
     C     F11FLG        CABEQ     'Y'           ENDPGM                         END NMADS
     C                   END
     C                   END
DF    *----------------------------------------------------------------
DF    * Email address validation
DF    *----------------------------------------------------------------
DF   C                   if        email <> *blanks
DF   C                   call      'SHR0006'
DF   C                   parm                    email
DF   C                   parm                    eflag             1
DF   C                   if        eflag = 'N'
DF   C                   eval      *in24 = *on
DF   C                   goto      DSPLY
DF   C                   else
DF   C                   eval      *in24 = *off
DF   C                   endif
DF   C                   endif
      *----------------------------------------------------------------
      * SIC CODE MAINTENANCE
      *----------------------------------------------------------------
     C     *IN16         IFEQ      '1'
     C                   MOVE      ARNO01        CUST#             6
     C                   MOVE      'M'           SICCDE            1
     C                   CALL      'ARR5016'
     C                   PARM                    CUST#
     C                   PARM                    SICCDE
     C                   PARM                    RETCOD            1 0
     C     *IN16         CABEQ     '1'           DSPLY
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * DUN & BRAD STREET MAINTENANCE
      *----------------------------------------------------------------
     C     *IN17         IFEQ      '1'
     C                   MOVE      ARNO01        CUST#             6
     C                   MOVE      'M'           SICCDE            1
     C                   CALL      'ARR5017'
     C                   PARM                    CUST#
     C                   PARM                    SICCDE
     C                   PARM                    RETCOD
     C     *IN17         CABEQ     '1'           DSPLY
     C                   ENDIF
      *----------------------------------------------------------------
      * BANK ACCOUNT MAINTENANCE
      *----------------------------------------------------------------
     C     *IN19         IFEQ      *ON
     C                   MOVE      ARNO01        CUST#
     C                   MOVE      'M'           SICCDE
     C                   CALL      'ARR5018'
     C                   PARM                    CUST#
     C                   PARM                    SICCDE
     C                   PARM                    RETCOD
     C     *IN19         CABEQ     *ON           DSPLY
     C                   ENDIF
      *
     C                   MOVEA     '0'           *IN(50)                        DISPLAY MSG
      * EDIT NAME AND ADDRESS INFORMATION
     C     ARNM01        IFEQ      *BLANKS                                      NAME ENTERED ?
     C                   MOVEA     '1'           *IN(80)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C     ARNM05        IFEQ      *BLANKS                                      SORT NAME ?
     C                   MOVEL     ARNM01        ARNM05                         IF BLANK MOVE
     C                   Z-ADD     20            LEN               5 0          CUSTOMER NAME
     C                   MOVEL     'QSYS'        T1                9            AND TRANSLATE
     C                   MOVE      'IMAGE'       T1                9            TO UPPER CASE
     C                   MOVEL     T1            TBL              10
     C                   CALL      'QDCXLATE'                                   TRANSLATE
     C                   PARM                    LEN                            LENGTH
     C                   PARM                    ARNM05                         SORT NAME
     C                   PARM                    TBL                            TRANSLATE
     C                   END                                                    TABLE
   ¢CC*          ARAD01    IFEQ *BLANKS                    MAILING ADS 1
¢C   C                   MOVEL     ARAD          ARAD02
¢C   C                   MOVE      ARAD          ARAD03
¢C   C     ARAD02        IFEQ      *BLANKS                                      MAILING ADS 1
     C                   MOVEA     '1'           *IN(82)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C     ARCY01        IFEQ      *BLANKS                                      MAILING CITY ?
     C                   MOVEA     '1'           *IN(83)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C     ARST01        IFEQ      *BLANKS                                      MAILING ST ?
     C                   MOVEA     '1'           *IN(84)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
¢R   C     pzflg         ifeq      'Y'
¢C   C                   EXSR      PERSRT
¢r   C                   end
     C     ARZP15        IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(85)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
B5   C                   ELSE
$K    * Validate zip only if not using tax software
$K   C                   if        AvaTaxActive <> 'Y'
B5   C     ARZP15        SETLL     ARFMZMF                                40
B5   C     *IN40         IFEQ      *OFF
B5   C                   MOVE      '1'           *IN57                          ERROR MSG
B5   C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
B5   C                   ENDIF
$K   C                   ENDIF
     C                   END
     C     ARNO07        IFEQ      0                                            TEL AREA CODE
     C                   MOVEA     '1'           *IN(86)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C     ARNO08        IFEQ      0                                            TEL PREFIX NO
     C                   MOVEA     '1'           *IN(86)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
      *           FAX PHONE NUMBER CHECKING
      *
     C     *IN33         IFEQ      '1'
      *
      *  IF THE PREFIX NUMBER OF THE FAX NUMBER IS ZERO, BLANK OUT THE
      *  ONE BEFORE DIALING FIELD AND DO NOT DISPLAY TEXT
      *
     C     ARNO76        IFEQ      *ZERO
     C                   MOVE      *BLANK        ARCDB3                         1 BEFORE DIAL
     C                   MOVE      *OFF          *IN69
     C                   ELSE
      *
      *  CHECK TO SEE IF "1" BEFORE DIALING IS NEEDED IF THE FAX
      *  AREA CODE AND EXCHANGE IS THE SAME AS THE LOCAL NUMBER
      *
     C     FAXNUM        IFGT      0
      *
     C     FAXNUM        IFNE      FAXSV
     C                   MOVE      ' '           ARCDB3
     C                   Z-ADD     FAXNUM        FAXSV
     C                   END
      *
     C     ARCDB3        IFEQ      ' '
     C     ARNO75        LOOKUP    FCD                                    40
     C     *IN40         IFEQ      *ON
     C     FIRST         IFEQ      'Y'
     C                   MOVE      'N'           FIRST
     C                   MOVEA     '1'           *IN(69)
     C                   MOVEA     '1'           *IN(99)
     C                   ELSE
     C                   MOVE      *ON           *IN43                          ENTER ONEB4
     C                   MOVEA     '1'           *IN(69)
     C                   MOVEA     '1'           *IN(99)
     C                   END
     C                   ENDIF
     C                   END
      *
     C                   END
     C                   ENDIF                                                  *IN33 IFEQ '1'
     C                   END                                                    *IN33 IFEQ '1'
$A    * Edit email address
$A   C                   move      *blanks       emlerr
$A   C                   move      *blanks       ecmderr
$A   C     EMAIL         IFNE      *BLANKS                                      TEL AREA CODE
$A   C                   MOVEL     EMAIL         EMAIL80          80
$A   C                   MOVEL     ' '           ECMDI
$A   C                   CALL      'ECC9977'                                    TEL AREA CODE
$A   C                   PARM                    EMAIL80
$A   C                   PARM                    EMLERR            1
$A   C                   PARM                    ECMDI             1
$A   C                   PARM                    ECMDERR           1
$A   C                   ENDIF
$A   C     EMLERR        IFEQ      'Y'
$A $EC*                  MOVE      *ON           *IN57
$E   C                   MOVE      *ON           *IN02
$A   C                   MOVE      *ON           *IN99
$A   C                   ENDIF
      *----------------------------------------------------------------
     C     ARAD04        IFNE      *BLANKS                                      SHIP TO ADDRESS
     C     ARCY02        IFEQ      *BLANKS                                      SHIP TO CITY
     C                   MOVEA     '1'           *IN(88)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C     ARST02        IFEQ      *BLANKS                                      SHIP TO STATE
     C                   MOVEA     '1'           *IN(89)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C     ARZP16        IFEQ      *BLANKS                                      SHIP TO ZIP
     C                   MOVEA     '1'           *IN(90)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
B5   C                   ELSE
DD    * Validate zip only if not using tax software
DD   C                   if        AvaTaxActive <> 'Y'
B5   C     ARZP16        SETLL     ARFMZMF                                40
B5   C     *IN40         IFEQ      *OFF
B5   C                   MOVE      '1'           *IN58                          ERROR MSG
B5   C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
B5   C                   ENDIF
DD   C                   endif
DD    *
     C                   END
     C                   ELSE                                                   SHIP TO ADDRESS
¢C   C     arad01        ifne      *blanks
     C                   MOVE      ARAD01        ARAD04                         BLANK
     C                   MOVE      ARAD02        ARAD05                         MOVE MAIL TO
     C                   MOVE      ARAD03        ARAD06                         ADDRESS TO
¢C   C                   else
¢C   C                   MOVE      ARAD02        ARAD04                         BLANK
¢C   C                   MOVE      ARAD03        ARAD05                         MOVE MAIL TO
¢C   C                   MOVE      *blanks       ARAD06                         ADDRESS TO
¢C   C                   END
     C                   MOVE      ARCY01        ARCY02                         SHIP TO
     C                   MOVE      ARST01        ARST02                         ADDRESS
     C                   MOVE      ARZP15        ARZP16
     C                   END
DD    *
DD    * Validate address for AvaTax software
DD   C                   if        AvaTaxActive =  'Y'
DD   C                   if        LicToAvaTax
DD   C                   if        addrval_enabled = 'Y'
DD    * If address is changed, validate it
DD   C                   if        arad04 <> svad04 or
DD   C                             arad05 <> svad05 or
DD   C                             arad06 <> svad06 or
DD   C                             arcy02 <> svcy02 or
DD   C                             arzp16 <> svzp16 or
DD   C                             arst02 <> svst02
DD    * Save address
DD   C                   eval      svad04  = arad04
DD   C                   eval      svad05  = arad05
DD   C                   eval      svad06  = arad06
DD   C                   eval      svcy02  = arcy02
DD   C                   eval      svzp16  = arzp16
DD   C                   eval      svst02  = arst02
DD   C                   eval      warnFlg = 'N'
DD    * Validate address
DD   C                   eval      piLine1 = arad04
DD   C                   eval      piline2 = arad05
DD   C                   eval      piline3 = arad06
DD   C                   eval      piCity  = arcy02
DD   C                   eval      piState = arst02
DD   C                   eval      piZip   = arzp16
DD   C                   eval      piCountry = *blanks
DD   C                   eval      poErrCode = *blanks
DD   C                   eval      poErrMessage = *blanks
DD   C                   call      'AIR9010'     PL9010
D5   C                   Eval      UpdFlg ='Y'
DD   C                   if        %trim(PoErrCode)  <> 'Success'
DD   C                   if        warnFlg = 'N'
DD   C                   eval      *in73 = *on
DD   C                   eval      *in99 = *on
DD   C                   eval      warnFlg = 'Y'
DD   C                   if        errmsg = *blanks
DD   C                   Eval      errmsg = 'Warning: Invalid address for -
DD DHC*                            AvaTax. ' +  %trim(poErrMessage)
DH   C                             Tax calculator. ' +  %trim(poErrMessage)
D5   C                   Eval      UpdFlg ='N'
DD   C                   Endif
DD   C                   endif
DD   C                   Endif
DD   C                   Endif
DD   C                   Endif
DI   C                   Else
DI    * Display error message if not licensed to AvaTax
DI   C                   eval      *in99 = *on
DI   C                   eval       p1300App  = 'AVATAX'
DI   C                   eval       p1300Bypass = 'N'
DI   C                   call      'MNR1300'     pl1300
DD   C                   Endif
DD   C                   Endif
¢R   C     pzflg         ifeq      'Y'
¢N   C                   EXSR      PERSRT1
¢R   C                   end
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           S15AER
     C                   ELSE
     C                   MOVE      ' '           S15AER
     C                   ENDIF
     C     *IN99         CABEQ     '1'           DSPLY                          ERROR OCCURED ?
      *
      * IF F10= UPDATE PRESSED,
      *    ENSURE NO ERROR EXIST ON ANY SCREEN
      *    SET F10 UPDATE FLAG TO YES
     C     *IN10         IFEQ      '1'
     C     ADDCUS        ANDEQ     'N'
     C                   SELECT
     C     SCRNER        WHENNE    *BLANKS
     C                   MOVE      UMS(3)        ERRMSG
     C     ERRMSG        CABNE     *BLANKS       DSPLY
     C                   OTHER
     C                   MOVE      'Y'           F10FLG
     C                   ENDSL
     C                   ENDIF
      *
B5   C     ENDADS        TAG
B5   C                   MOVE      *IN57         SVIN57
B5   C                   MOVE      *IN58         SVIN58
DD   C                   eval      *in73 = svin73
B5   C                   ENDSR
   B5C*    ENDADS        ENDSR
      *------------------------------------------------------------------------*
      *  SECTION 5     ADDITIONAL ADDRESS MAINTENANCE - SHIP TO
      *
      * STEP 1. OBTAIN EXISTING ADDRESSES AND LOAD TO SFL
      * STEP 2. DISPLAY SCREEN AND DETERMINE SCREEN RESPONSE
      * STEP 3. ERROR EDITING
      *------------------------------------------------------------------------*
      * STEP 1. * OBTAIN EXISTING ADDRESSES AND LOAD TO DATA STRUCTURE
      *------------------------------------------------------------------------*
     C     SHADD         BEGSR
     C                   MOVE      'S'           CDA1              1
     C                   Z-ADD     0             NO40S
     C                   Z-ADD     0             RNI               4 0
     C                   Z-ADD     0             RNERRI            4 0
     C                   MOVE      'N'           F3WRN
B5   C                   MOVE      *IN58         SVIN58
DD   C                   eval      svin88 = *in88                               SETOF *IND
DD   C                   eval      svin54 = *in54                               SETOF *IND
DD   C                   eval      *in88  = *off                                SETOF *IND
DD   C                   eval      *in54  = *off                                SETOF *IND
DD    *
DD    * Do not display tax jurisdiction if tax software used.
DD   C                   if        AvaTaxActive = 'Y'
DD   C                   eval      *in54 = *on
DD   C                   endif
DD    *
      * INITIALIZE SUBFILE
     C     FRSTSH        IFEQ      'Y'                                          FIRST TIME THRU
     C                   MOVE      'N'           FRSTSH            1
     C                   MOVEA     '1'           *IN(73)                        CLEAR
     C                   WRITE     ARC5015I
     C                   MOVEA     '0'           *IN(73)                        SETOF CLEAR
      * LOAD SHIP TO ADDRESSES
     C     AKEY          SETLL     ARFMCAD
     C     *IN46         DOUEQ     '1'
     C     AKEY          READE     ARFMCAD                                46
     C     *IN46         IFEQ      '0'
     C                   Z-ADD     ARNO40        NO40S
     C                   Z-ADD     ARNO41        NO41S
     C                   Z-ADD     ARNO42        NO42S
     C                   Z-ADD     ARNO43        NO43S
     C                   MOVEL     ARAD19        AD19S
     C                   MOVEL     ARAD20        AD20S
     C                   MOVEL     ARAD21        AD21S
     C                   MOVEL     ARCY07        CY07S
     C                   MOVEL     ARST07        ST07S
     C                   MOVEL     ARZP21        ZP21S
D5   C                   Z-ADD     RCNO05        CNO05S
D5   C                   Z-ADD     RCNO05        CNO06S
     C                   MOVEL     XXDN08        DN08S
     C                   MOVEL     ARNM21        NM21S                          SHORT DESC
     C                   Z-ADD     XXCD04        CD04S                          TAX J/CODE
     C                   MOVEL     XXID01        ID01S                          SLSMAN-ID
     C                   MOVE      ZP21S         CPYZPS
     C                   ADD       1             RNI
     C                   WRITE     ARS5015I                                     CMD KEY FORMAT
     C                   END                                                    IN46 IF
     C                   END                                                    IN46 DO
     C     RNI           IFLT      60
     C     RNI           DOWLT     60
     C                   ADD       1             NO40S
     C                   Z-ADD     0             NO41S
     C                   Z-ADD     0             NO42S
     C                   Z-ADD     0             NO43S
     C                   MOVEL     *BLANKS       AD19S
     C                   MOVEL     *BLANKS       AD20S
     C                   MOVEL     *BLANKS       AD21S
     C                   MOVEL     *BLANKS       CY07S
     C                   MOVEL     *BLANKS       ST07S
     C                   MOVE      *BLANKS       ZP21S
     C                   MOVE      *BLANKS       DN08S
     C                   MOVE      *BLANKS       NM21S                          SHORT DESC
     C                   Z-ADD     0             CD04S                          TAX J/CODE
     C                   MOVE      *BLANKS       ID01S                          SLSMAN-ID
     C                   MOVE      ZP21S         CPYZPS
D5   C                   Z-ADD     0             CNO05S
D5   C                   Z-ADD     0             CNO06S
     C                   ADD       1             RNI
     C                   WRITE     ARS5015I
     C                   END                                                    RNI DO
     C                   END                                                    RNI IF
     C                   END                                                    1ST TIME
     C     DSPLYI        TAG
     C     RNERRI        IFNE      0
     C                   Z-ADD     RNERRI        RNI
     C                   ELSE
     C                   Z-ADD     1             RNI
     C                   END                                                    RNERRI NE 0
     C                   MOVEA     '11'          *IN(75)                        DSPLY SUB& CNTL
     C                   MOVE      *OFF          WDWFLG
     C                   WRITE     ARF5015I                                     CMD KEY FORMAT
     C                   EXFMT     ARC5015I                                     CONTACTS
     C                   MOVEA     '00'          *IN(75)                        SETOF *IND
     C                   MOVEA     '0'           *IN(99)                        SETOF *IND
     C                   MOVEA     '00000000'    *IN(60)                        SETOF *IND
DD   C                   eval      *in88 = *off                                 SETOF *IND
     C                   Z-ADD     0             RNERRI
     C                   MOVE      *BLANKS       ERRMSG                         INZ ERROR MSG
     C                   MOVE      'Y'           S15IUP
CJ   C     f3flg         ifeq      'Y'
CJ   C     *in03         ifeq      *on
CJ   C                   move      '0'           *in03
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(63)       errmsg
CJ   C                   endif
CJ   C                   goto      dsplyi
CJ   C                   endif
CJ   C     *in10         ifeq      *on
CJ   C                   move      '0'           *in10
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(64)       errmsg
CJ   C                   endif
CJ   C                   goto      dsplyi
CJ   C                   endif
CJ   C                   endif
     C     *IN03         IFEQ      *OFF
     C                   MOVE      'N'           F3WRN
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     UMS(5)        ERRMSG
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPLYI
     C                   ENDIF
     C                   GOTO      ENDPGM
     C                   ENDIF
      * F4 = PROMPT
     C     *IN04         IFEQ      *ON                                          PROMPT
     C                   EXSR      @PRMPT
     C                   Z-ADD     CRRN          RNERRI
     C                   ENDIF
     C     *IN04         CABEQ     *ON           DSPLYI
     C                   EXSR      @CLCSR
      * READ SUBFILE
     C     *IN42         DOUEQ     '1'
     C                   READC     ARS5015I                               42
     C     *IN42         IFEQ      '0'
     C     NM21S         IFNE      *BLANKS
     C     AD19S         ORNE      *BLANKS
     C     CY07S         ORNE      *BLANKS
     C     ST07S         ORNE      *BLANKS
     C     ZP21S         ORNE      *BLANKS
     C     DN08S         ORNE      *BLANKS
     C     ID01S         ORNE      *BLANKS
     C     CD04S         ORNE      0
DT   C     *IN54         ANDEQ     *OFF
     C     NO41S         ORNE      0
     C     NO42S         ORNE      0
     C     NM21S         IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(56)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(60)                        (RI PC)     G
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C     AD19S         IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(82)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(61)                        (RI PC)     G
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C     CY07S         IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(83)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(62)                        (RI PC)     G
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C     ST07S         IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(84)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(63)                        (RI PC)     G
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C     ZP21S         IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(85)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(64)                        (RI PC)     G
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
B5   C                   ELSE
B5   C     ZP21S         SETLL     ARFMZMF                                40
B5   C     *IN40         IFEQ      *OFF
B5   C                   MOVE      '1'           *IN58                          SFL ERROR MSG
B5   C                   MOVEA     '1'           *IN(64)                        (RI PC)
B5   C     *IN99         IFEQ      '0'                                          NO ERRORS
B5   C                   Z-ADD     RNI           RNERRI
B5   C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
B5   C                   END
B5   C                   ENDIF
     C                   END
DD    *
DD   C                   if        AvaTaxActive =  'Y'
DD   C                   if        LicToAvaTax
DD   C                   if        addrval_enabled = 'Y'
DD    * If address is changed, validate it
DD   C                   if        ad19s  <> svad19s or
DD   C                             ad20s  <> svad20s or
DD   C                             ad21s  <> svad21s or
DD   C                             cy07s  <> svcy07s or
DD   C                             st07s  <> svst07s or
DD   C                             zp21s  <> svzp21s
DD    * Save address
DD   C                   eval      svad19s = ad19s
DD   C                   eval      svad20s = ad20s
DD   C                   eval      svad21s = ad21s
DD   C                   eval      svcy07s = cy07s
DD   C                   eval      svst07s = st07s
DD   C                   eval      svzp21s = zp21s
DD   C                   eval      warnFlg = 'N'
DD    * Validate address
DD   C                   eval      piLine1 = ad19s
DD   C                   eval      piline2 = ad20s
DD   C                   eval      piline3 = ad21s
DD   C                   eval      piCity  = cy07s
DD   C                   eval      piState = st07s
DD   C                   eval      piZip   = zp21s
DD   C                   eval      piCountry = *blanks
DD   C                   eval      poErrCode = *blanks
DD   C                   eval      poErrMessage = *blanks
DD   C                   call      'AIR9010'     PL9010
DD   C                   if        %trim(PoErrCode)  <> 'Success'
DD   C                   if        *in99 = *off
DD   C                             and wrnShpFlg  = 'N'
DD   C                   eval      *in88 = *on
DD   C                   eval      wrnShpFlg =  'Y'
DD   C                   z-add     rni           rnerri
DD   C                   Eval      errmsg = 'Warning: Invalid address for -
DD DHC*                            AvaTax. ' +  %trim(poErrMessage)
DH   C                             Tax calculator. ' +  %trim(poErrMessage)
DD   C                   eval      *in99 = *on
DD   C                   endif
D5   C                   Else
D5   C                   Eval       CNO05S =  %dec(PoLat:15:7)
D5   C                   Eval       CNO06S =  %dec(PoLng:15:7)
D5    *
DD   C                   endif
DD   C                   endif
DD   C                   endif
DD   C                   Else
DD    * Display error message if not licensed to DII (IntelliChief)
DD   C                   eval      *in99 = *on
DD   C                   eval       p1300App  = 'AVATAX'
DD   C                   eval       p1300Bypass = 'N'
DD   C                   call      'MNR1300'     pl1300
DD   C                   Endif
DD   C                   endif
DD    *
     C     NO41S         IFEQ      0
     C     NO42S         OREQ      0
     C                   MOVEA     '1'           *IN(86)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(65)                        (RI PC)     G
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C     ID01S         SETLL     ARFMSLS                                40    SALESPERSON EXIST?
     C     *IN40         IFEQ      '0'
     C                   MOVEA     '1'           *IN(57)                        HIGHLITE ERROR
     C                   MOVEA     '1'           *IN(66)                        (RI PC)     G
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
      *
      * If zip code overridden, display window if more than one tax
      * code is attached to the zip code and allow user to select tax
      * jurisdiction that applies to the order.
DD   C                   if        AvaTaxActive <> 'Y'
     C     ZP21S         IFNE      CPYZPS
     C                   MOVE      ZP21S         ZPCD
     C                   MOVE      CD04S         TXCD
   DBC*                  Z-ADD     9             RETCOD
DB   C                   Z-ADD     2             RETCOD
     C                   CALL      'ARR9100'     PL9100
     C     RETCOD        IFEQ      7
     C                   MOVE      *ON           *IN81                          ERROR MESSAGE
     C                   MOVE      *ON           *IN67                          (RI PC)     G
     C     *IN99         IFEQ      *OFF                                         NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVE      *ON           *IN99                          ERROR OCCURED
     C                   ENDIF
     C                   ELSE
     C                   MOVE      TXCD          CD04S
     C                   MOVE      ZPCD          ZP21S
     C                   ENDIF
     C                   MOVE      ZP21S         CPYZPS
     C                   MOVE      *ON           *IN99                          ERROR OCCURED
     C                   ENDIF
      *
      * Ensure shipping zip code is attached to jurisdiction
      *
     C                   MOVE      ZP21S         ZPCD
     C                   MOVE      CD04S         TXCD
     C                   Z-ADD     8             RETCOD
     C                   CALL      'ARR9100'     PL9100
      *
     C     RETCOD        IFEQ      7
     C                   MOVE      *ON           *IN81                          ERROR MESSAGE
     C                   MOVE      *ON           *IN67                          (RI PC)     G
     C     *IN99         IFEQ      *OFF                                         NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVE      *ON           *IN99                          ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      *
     C     CD04S         SETLL     ARFMTAX                                40    EXIST ?
     C     *IN40         IFEQ      '0'
     C                   MOVEA     '1'           *IN(81)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(67)                        (RI PC)     G
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
DD   C                   ENDIF
     C                   END
     C                   UPDATE    ARS5015I
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           S15IER
     C                   ELSE
     C                   MOVE      ' '           S15IER
     C                   ENDIF
     C     *IN99         CABEQ     '1'           DSPLYI                         HAVE ERROR
     C                   END
     C                   END
      * PREVIOUS
     C     *IN12         CABEQ     *ON           ENDSH
      *
      * IF F10= UPDATE PRESSED,
      *    ENSURE NO ERROR EXIST ON ANY SCREEN
      *    SET F10 UPDATE FLAG TO YES
     C     *IN10         IFEQ      '1'
     C     ADDCUS        ANDEQ     'N'
     C                   SELECT
     C     SCRNER        WHENNE    *BLANKS
     C                   MOVE      UMS(3)        ERRMSG
     C     ERRMSG        CABNE     *BLANKS       DSPLYI
     C                   OTHER
     C                   MOVE      'Y'           F10FLG
     C                   ENDSL
     C                   ENDIF
      *
     C     ENDSH         TAG
     C                   MOVEA     '00000000'    *IN(60)                        SETOF *IND
B5   C                   MOVE      SVIN58        *IN58
DD   C                   eval      *in88 = svin88
DD   C                   eval      *in54 = svin54
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SECTION 6    ADDITIONAL ADDRESS MAINTENANCE - MAIL TO
      *
      * STEP 1.  OBTAIN EXISTING ADDRESSES AND LOAD TO SFL
      * STEP 2.  DISPLAY SCREEN AND DETERMINE SCREEN RESPONSE
      * STEP 3.  ERROR EDITING
      *------------------------------------------------------------------------*
      * STEP 1. * OBTAIN EXISTING ADDRESSES AND LOAD TO SFL
      *------------------------------------------------------------------------*
     C     MLADD         BEGSR
     C                   MOVE      'M'           CDA1
     C                   Z-ADD     0             NO40M
     C                   Z-ADD     0             RNH               4 0
     C                   Z-ADD     0             RNERRH            4 0
     C                   MOVE      'N'           F3WRN
     C                   MOVE      *BLANKS       ERRMSG
      * INITIALIZE SUBFILE
     C     FRSTMS        IFEQ      'Y'                                          FIRST TIME THRU
     C                   MOVE      'N'           FRSTMS            1
     C                   MOVEA     '1'           *IN(73)                        CLEAR
     C                   WRITE     ARC5015H
     C                   MOVEA     '0'           *IN(73)                        SETOF CLEAR
      * LOAD MAIL TO ADDRESSES
     C     AKEY          SETLL     ARFMCAD
     C     *IN40         DOUEQ     '1'
     C     AKEY          READE     ARFMCAD                                40
     C     *IN40         IFEQ      '0'
     C                   Z-ADD     ARNO40        NO40M
     C                   Z-ADD     ARNO41        NO41M
     C                   Z-ADD     ARNO42        NO42M
     C                   Z-ADD     ARNO43        NO43M
     C                   MOVEL     ARAD19        AD19M
     C                   MOVEL     ARAD20        AD20M
     C                   MOVEL     ARAD21        AD21M
     C                   MOVEL     ARCY07        CY07M
     C                   MOVEL     ARST07        ST07M
     C                   MOVEL     ARZP21        ZP21M
     C                   MOVEL     ARNM21        NM21M                          SHORT DESC
     C                   Z-ADD     XXCD04        CD04M                          TAX J/CODE
     C                   MOVEL     XXID01        ID01M                          SLSMAN-ID
     C                   ADD       1             RNH
     C                   WRITE     ARS5015H
     C                   END                                                    *IN40 IFEQ 0
     C                   END                                                    *IN40 DOUEQ 1
     C     RNH           IFLT      60
     C     RNH           DOWLT     60
     C                   ADD       1             NO40M
     C                   Z-ADD     0             NO41M
     C                   Z-ADD     0             NO42M
     C                   Z-ADD     0             NO43M
     C                   MOVEL     *BLANKS       AD19M
     C                   MOVEL     *BLANKS       AD20M
     C                   MOVEL     *BLANKS       AD21M
     C                   MOVEL     *BLANKS       CY07M
     C                   MOVEL     *BLANKS       ST07M
     C                   MOVE      *BLANKS       ZP21M
     C                   MOVE      *BLANKS       NM21M                          SHORT DESC
     C                   Z-ADD     0             CD04M                          TAX J/CODE
     C                   MOVE      *BLANKS       ID01M                          SLSMAN-ID
     C                   ADD       1             RNH
     C                   WRITE     ARS5015H
     C                   END                                                    RNH IF
     C                   END                                                    RNH DO
     C                   END                                                    IST TIME
      * DISPLAY ADDRESSES
     C     DSPLYH        TAG
     C     RNERRH        IFNE      0
     C                   Z-ADD     RNERRH        RNH
     C                   ELSE
     C                   Z-ADD     1             RNH
     C                   END                                                    RNERRI NE 0
     C                   MOVEA     '11'          *IN(75)                        DSPLY SUB& CNTL
     C                   WRITE     ARF5015H                                     CMD KEY FORMAT
     C                   EXFMT     ARC5015H                                     CONTACTS
     C                   MOVEA     '00'          *IN(75)                        SETOF *IND
     C                   MOVEA     '0'           *IN(99)                        SETOF *IND
     C                   MOVEA     '00000000'    *IN(60)                        SETOF *IND
     C                   Z-ADD     0             RNERRH
     C                   MOVE      'Y'           S15HUP
     C                   MOVE      *BLANKS       ERRMSG
CJ   C     f3flg         ifeq      'Y'
CJ   C     *in03         ifeq      *on
CJ   C                   move      '0'           *in03
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(63)       errmsg
CJ   C                   endif
CJ   C                   goto      dsplyh
CJ   C                   endif
CJ   C     *in10         ifeq      *on
CJ   C                   move      '0'           *in10
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(64)       errmsg
CJ   C                   endif
CJ   C                   goto      dsplyh
CJ   C                   endif
CJ   C                   endif
     C     *IN03         IFEQ      *OFF
     C                   MOVE      'N'           F3WRN
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     UMS(5)        ERRMSG
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPLYH
     C                   ENDIF
     C                   GOTO      ENDPGM
     C                   ENDIF
      * READ SUBFILE
     C     *IN42         DOUEQ     '1'
     C                   READC     ARS5015H                               42
     C     *IN42         IFEQ      '0'
     C     NM21M         IFNE      *BLANKS
     C     AD19M         ORNE      *BLANKS
     C     CY07M         ORNE      *BLANKS
     C     ST07M         ORNE      *BLANKS
     C     ZP21M         ORNE      *BLANKS
     C     NO41S         ORNE      0
     C     NO42S         ORNE      0
     C     NM21M         IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(56)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(60)                        (RI PC)
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNH           RNERRH
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C     AD19M         IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(82)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(61)                        (RI PC)
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNH           RNERRH
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C     CY07M         IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(83)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(62)                        (RI PC)
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNH           RNERRH
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C     ST07M         IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(84)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(63)                        (RI PC)
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNH           RNERRH
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C     ZP21M         IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(85)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(64)                        (RI PC)
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNH           RNERRH
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C     NO41M         IFEQ      0
     C     NO42M         OREQ      0
     C                   MOVEA     '1'           *IN(86)                        SFL ERROR MSG
     C                   MOVEA     '1'           *IN(65)                        (RI PC)
     C     *IN99         IFEQ      '0'                                          NO ERRORS
     C                   Z-ADD     RNH           RNERRH
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
     C                   END
     C                   UPDATE    ARS5015H
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           S15HER
     C                   ELSE
     C                   MOVE      ' '           S15HER
     C                   ENDIF
     C     *IN99         CABEQ     '1'           DSPLYH                         HAVE ERROR
     C                   END
     C                   END
      * PREVIOUS SCREEN
     C     *IN12         CABEQ     *ON           ENDML
      *
      * IF F10= UPDATE PRESSED,
      *    ENSURE NO ERROR EXIST ON ANY SCREEN
      *    SET F10 UPDATE FLAG TO YES
     C     *IN10         IFEQ      '1'
     C     ADDCUS        ANDEQ     'N'
     C                   SELECT
     C     SCRNER        WHENNE    *BLANKS
     C                   MOVE      UMS(3)        ERRMSG
     C     ERRMSG        CABNE     *BLANKS       DSPLYH
     C                   OTHER
     C                   MOVE      'Y'           F10FLG
     C                   ENDSL
     C                   ENDIF
      *
     C     ENDML         TAG
     C                   MOVEA     '00000000'    *IN(60)                        SETOF *IND
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  UPDHIS - UPDATE ARPHBAL RECORDS FOR SORT NAME.                ***
      *------------------------------------------------------------------------*
     C     UPDHIS        BEGSR
     C     ARNM05        IFNE      SVNM05
     C     ARNO01        CHAIN     FHBAL                              40
     C     *IN40         DOWEQ     '0'
     C     ARNM05        IFNE      NM05
     C                   MOVE      ARNM05        NM05
     C                   EXCEPT    UPHBAL
     C                   END
     C     ARNO01        READE     FHBAL                                  40
     C                   END
     C                   MOVE      ARNM05        SVNM05
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
      ** SUBROUTINE ** UPDATE CUSTOMER SHIPPING/MAILING ADDRESSES ********
      *------------------------------------------------------------------------*
     C     UPDSHP        BEGSR
     C                   Z-ADD     1             RNI
     C                   Z-ADD     0             DIFI              1 0
     C                   MOVE      'S'           CDA1
     C     *IN40         DOUEQ     '1'
     C     RNI           CHAIN     ARS5015I                           40
     C     *IN40         IFEQ      '0'
     C     SKEY          CHAIN     ARFMCAD                            41
     C     AD19S         IFNE      *BLANKS
     C                   SUB       DIFI          NO40S
     C                   Z-ADD     NO40S         ARNO40
     C                   Z-ADD     NO41S         ARNO41
     C                   Z-ADD     NO42S         ARNO42
     C                   Z-ADD     NO43S         ARNO43
     C                   MOVEL     AD19S         ARAD19
     C                   MOVEL     AD20S         ARAD20
     C                   MOVEL     AD21S         ARAD21
     C                   MOVEL     CY07S         ARCY07
     C                   MOVEL     ST07S         ARST07
     C                   MOVEL     ZP21S         ARZP21
     C                   MOVEL     DN08S         XXDN08
     C                   MOVEL     USRNM         ARNM03
     C                   Z-ADD     DAY           ARDY09
     C                   Z-ADD     MONTH         ARMO09
     C                   MOVEL     *YEAR         ARCC09
     C                   Z-ADD     YEAR          ARYR09
     C                   MOVEL     CDA1          ARCDA1
     C                   MOVEL     NM21S         ARNM21                         SHORT DESC
D5    * Write/Update ARPMACO
D5   C                   Exsr      WRITMACO1
DD    *
DD    *  If using AvaTax, load default Tax Jurisdiction if zeros
DD   C                   if        AvaTaxActive = 'Y'
DD   C                             and LicToAvaTax
DD   C                   if        cd04s = *zeros
DD   C                   z-add     Taxs_Juris_N  cd04s
DD   C                   endif
DD   C                   endif
DD    *
     C                   Z-ADD     CD04S         XXCD04                         TAX J/CODE
     C                   MOVEL     ID01S         XXID01                         SLSMAN-ID
     C     *IN41         IFEQ      '0'
     C                   UPDATE    ARFMCAD
     C                   ELSE
     C                   WRITE     ARFMCAD
     C                   END
DD    *
DD    *  If using AvaTax, update Zip code master file and
DD    *     update Tax Jurisdiction by Zip code master file
DD   C                   if        AvaTaxActive = 'Y'
DD   C                             and LicToAvaTax
DD   C                   z-add     cd04s         pi_juris
DD   C                   move      zp21s         pi_zip
DD   C                   call      'ARR5218'     PL5218
DD   C                   endif
DD    *
     C                   ELSE
     C     *IN41         IFEQ      '0'
     C                   DELETE    ARFMCAD
     C                   ADD       1             DIFI
     C                   END
     C                   END                                                     NE BLANKS
     C                   END
     C                   ADD       1             RNI
     C                   END                                                    DOUEQ
     C     ENDSHP        ENDSR
      *------------------------------------------------------------------------*
      ** SUBROUTINE ** UPDATE CUSTOMER MAILING ADDRESSES *****************
      *------------------------------------------------------------------------*
     C     UPDMAL        BEGSR
     C                   Z-ADD     1             RNH
     C                   Z-ADD     0             DIFH              1 0
     C                   MOVE      'M'           CDA1
     C     *IN40         DOUEQ     '1'
     C     RNH           CHAIN     ARS5015H                           40
     C     *IN40         IFEQ      '0'
     C     MKEY          CHAIN     ARFMCAD                            41
     C     AD19M         IFNE      *BLANKS
     C                   SUB       DIFH          NO40M
     C                   Z-ADD     NO40M         ARNO40
     C                   Z-ADD     NO41M         ARNO41
     C                   Z-ADD     NO42M         ARNO42
     C                   Z-ADD     NO43M         ARNO43
     C                   MOVEL     AD19M         ARAD19
     C                   MOVEL     AD20M         ARAD20
     C                   MOVEL     AD21M         ARAD21
     C                   MOVEL     CY07M         ARCY07
     C                   MOVEL     ST07M         ARST07
     C                   MOVEL     ZP21M         ARZP21
     C                   MOVEL     USRNM         ARNM03
     C                   Z-ADD     DAY           ARDY09
     C                   Z-ADD     MONTH         ARMO09
     C                   MOVEL     *YEAR         ARCC09
     C                   Z-ADD     YEAR          ARYR09
     C                   MOVEL     CDA1          ARCDA1
     C                   MOVEL     NM21M         ARNM21                         SHORT DESC
     C                   MOVE      *BLANKS       XXDN08                         COUNTRY
     C                   Z-ADD     0             XXCD04                         TAX J/CODE
     C                   MOVEL     *BLANKS       XXID01                         SLSMAN-ID
     C     *IN41         IFEQ      '0'
     C                   UPDATE    ARFMCAD
     C                   ELSE
     C                   WRITE     ARFMCAD
     C                   END
     C                   ELSE
     C     *IN41         IFEQ      '0'
     C                   DELETE    ARFMCAD
     C                   ADD       1             DIFH
     C                   END
     C                   END
     C                   END
     C                   ADD       1             RNH
     C                   END
     C     ENDMAL        ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    SALESPERSON & CUSTOMER REQUIREMENTS                     *
      *------------------------------------------------------------------------*
     C     SLSCUS        BEGSR
     C                   CLEAR                   ERRMSG
     C                   CLEAR                   MFLG
     C                   CLEAR                   WRNFLG
     C                   MOVE      'N'           F3WRN
     C                   MOVE      *IN51         SVIN51
DP   C                   clear                   geoDesc
DP   C                   clear                   mktDesc
DD   C                   eval      svin54 = *in54
DG   C                   eval      svin60 = *in60
DG   C                   eval      svin61 = *in61
DG   C                   eval      svin62 = *in62
DM   C                   eval      svin39 = *in39
DP   C                   eval      svin69 = *in69
DP   C                   eval      svin53 = *in53
DG    *
DP    * Validate values for Vecta
DP   C                   if        VectaYes = 'Y'
DP    * Validate customer market type
DP   C                   if        arcd02 <> *blanks
DP    *
DP    * Determine if licensed to this product...
DP    * The following license key checking logic may not be altered, bypassed or removed.
DP    * See Legal Document in WRKMINKEY command for more information.
DP   C                   if        LicToVecta
DP   C                   eval      tbno01 = 'AR36'
DP   C                   eval      tbno02 = 'MT'
DP    * Right adjust value, if just 1 char
DP   C                   if        %len(%trim(arcd02)) = 1
DP   C                   eval      arcd02 = ' ' + %trim(arcd02)
DP   C                   endif
DP   C                   move      arcd02        tbno02
DP   C     tbKey         chain     Tbfmtbl
DP   C                   if        not %found
DP   C                   eval      *in53 = *on
DP   C                   if        errmsg = *blanks
DP   C                   eval      errmsg = 'Customer Market Type not valid.'
DP   C                   endif
DP   C                   else
DP   C                   eval      mktDesc =  %trim(tbno03)
DP   C                   endif
DP   C                   endif
DP   C                   endif
DP    *
DP    * Validate geographic territory
DP   C                   if        arcd05 <> *zeros
DP    *
DP    * Determine if licensed to this product...
DP    * The following license key checking logic may not be altered, bypassed or removed.
DP    * See Legal Document in WRKMINKEY command for more information.
DP   C                   if        LicToVecta
DP   C                   eval      tbno01 = 'AR36'
DP   C                   eval      tbno02 = 'GT'
DP   C                   move      arcd05        tbno02
DP   C     tbKey         chain     Tbfmtbl
DP   C                   if        not %found
DP   C                   eval      *in69 = *on
DP   C                   if        errmsg = *blanks
DP   C                   eval      errmsg = 'Geographic Territory not valid.'
DP   C                   endif
DP   C                   else
DP   C                   eval      geoDesc =  %trim(tbno03)
DP   C                   endif
DP   C                   endif
DP   C                   endif
DP   C                   endif
DP    *
     C     DSPLY1        TAG
      *
DP   C                   eval      Vecta = ' '
DP    * Set flag for WW Prompter display...
DP   C                   if        VectaYes = 'Y' and QQF ='QQF'
DP   C                   eval      Vecta = 'Y'
DP   C                   endif
EB    *----------------------------------------------------------------
EB    * SEE IF USING GST TAX ?
EB    *
EB   C                   MOVE      'AR17'        TBNO01
EB   C                   MOVE      *BLANKS       TBNO02
EB   C                   MOVEL     'GSTTAX'      TBNO02
EB   C                   MOVE      'Y'           TBNO02
EB   C     TBKEY         SETLL     TBFMTBL                                71
EB    *----------------------------------------------------------------
      * DEFAULT (ARCDB9) GST EXEMPT FLAG. (IF USED)
      *
     C     *IN71         IFEQ      *ON
     C     ARCDB9        ANDEQ     ' '                                          GST FLAG
     C                   MOVE      'N'           ARCDB9                                     D
     C                   END
DD    *
DD    * Do not display tax jurisdiction if tax software used.
DG   C                   eval      *in54 = *off
DG   C                   if        AvaTaxActive = 'Y'
DG   C                   eval      *in54 = *on
DG    *
DG DN * Do not display usage type if using certificate software
DG DNC*                  eval      *in61 = *on
DG DNC*                  if        wEcms = 'Y'
DG DNC*                  eval      *in61 = *off
DG DNC*                  endif
DG    *
DM    * Do not display expiry date & tax exempt # if using certcapture
DM   C                   eval      *in39 = *off
DM   C                   if        CertCapture = 'Y'
DM   C                   eval      *in39 = *on
DM   C                   endif
DM    *
DG   C                   endif
DD    *
DN    * Display usage type if it is allowed to be maintained
DN   C                   eval      *in61 = *off
DN   C                   if        wEcms2= 'Y'
DN   C                             and wEcms1 <> 'Y'
DN   C                   eval      *in61 = *oN
DN   C                   endif
DN    *
     C                   MOVE      ARFL02        SVFL02
     C                   MOVE      ARFL01        SVFL01
     C                   MOVE      ARCD65        SVCD65
¢S    * default warranty fee & fuel surcharge
¢Q   C     arcd59        ifeq      ' '
¢Q   c                   move      'Y'           arcd59
¢Q   c                   end
¢s   C     arfl08        ifeq      ' '
¢s   c                   move      'Y'           arfl08
¢s   c                   end
¢W    * Default allow freight charge
¢W   C     CHGFRT        IFEQ      ' '
¢W   c                   MOVE      'Y'           CHGFRT
¢W   c                   ENDIF
      *
$B   C                   move      *off          *IN60
     C                   EXFMT     ARF5015B
     C                   MOVEA     '0'           *IN(99)                        ERROR OCCURED
     C                   MOVE      *OFF          *IN96
     C                   MOVEA     '000000'      *IN(61)
     C                   MOVEA     '000000'      *IN(34)
¢A   C                   MOVE      *OFF          *IN80
¢P   C                   MOVE      *OFF          *IN29
¢Q   C                   MOVE      *OFF          *IN89
     C                   MOVE      *OFF          *IN51
DD DGC*                  eval      *in54 = *off
DM   C                   eval      *in39 = *off
DP   C                   eval      *in53 = *off
DP   C                   eval      *in69 = *off
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN68
     C                   MOVE      *OFF          *IN79
     C                   MOVE      *OFF          *IN81
     C                   MOVE      *OFF          *IN82
     C                   MOVE      *OFF          *IN84
     C                   MOVE      *OFF          *IN85
     C                   MOVE      *OFF          *IN86
     C                   MOVE      *OFF          *IN97
     C                   MOVE      *OFF          *IN98
     C                   MOVE      *OFF          *IN26
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN28
DQ   C                   MOVE      *OFF          *IN72
¢W   C                   MOVE      *OFF          *IN83
     C                   MOVE      'Y'           S15BUP
     C                   MOVE      *BLANKS       ERRMSG                         INZ ERROR MSG
     C     ARFL02        IFNE      SVFL02
     C     ARFL01        ORNE      SVFL01
     C     ARCD65        ORNE      SVCD65
     C                   CLEAR                   WRNFLG
     C                   ENDIF
CJ   C     f3flg         ifeq      'Y'
CJ   C     *in03         ifeq      *on
CJ   C                   move      '0'           *in03
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(63)       errmsg
CJ   C                   endif
CJ   C                   goto      dsply1
CJ   C                   endif
CJ   C     *in10         ifeq      *on
CJ   C                   move      '0'           *in10
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(64)       errmsg
CJ   C                   endif
CJ   C                   goto      dsply1
CJ   C                   endif
CJ   C                   endif
     C     *IN03         IFEQ      *OFF
     C                   MOVE      'N'           F3WRN
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     UMS(5)        ERRMSG
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPLY1
     C                   ENDIF
     C                   GOTO      ENDPGM
     C                   ENDIF
     C     *IN25         IFEQ      '1'                                          CMD KEY HELP
     C                   CALL      'HTR0010'                                    HELP TEXT
     C                   PARM                    PROG                           PROGRAM
     C                   PARM                    SCREEN                         SCREEN
     C     *IN25         CABEQ     '1'           DSPLY1                         GO TO DISPLAY
     C                   END
      *
      * F4 = PROMPT
     C     *IN04         IFEQ      *ON                                          PROMPT
     C                   EXSR      @PRMPT
     C                   ENDIF
     C     *IN04         CABEQ     *ON           DSPLY1
     C                   EXSR      @CLCSR
DM    * F7 = Certificates
DM   C                   if        certCapture = 'Y'                            PROMPT
DM   C                             and *in07 = *on                              PROMPT
DM    * Determine if licensed to this product...
DM    * The following license key checking logic may not be altered, bypassed or removed.
DM    * See Legal Document in WRKMINKEY command for more information.
DM   C                   if        licToAvaTax
DM   C                   eval      pCust# = arno01
DM   C                   eval      pJob# = *blanks
DM   C                   call      'ARR9210'     pl9210
DM    * Display error message if not licensed to AvaTax
DM   C                   else
DM   C                   eval       p1300App  = 'AVATAX'
DM   C                   call      'MNR1300'     pl1300
DM   C                   endif
DM   C                   endif
DM   C     *in07         cabeq     *on           dsply1
DM   C                   exsr      @clcsr
      * BACKORDER ALLOWED
     C     ARFL01        IFNE      'Y'
     C     ARFL01        ANDNE     'N'
     C     ARFL01        ANDNE     ' '
     C                   MOVE      *ON           *IN34                          RI/PC
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(7)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      * P/O REQUIRED
     C     ARFL02        IFNE      'Y'                                          P.O. REQUIRED
     C     ARFL02        ANDNE     'N'                                          P.O. REQUIRED
     C                   MOVE      *ON           *IN82                          RI/PC
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(2)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      * JOB NUMBER
     C     ARFL06        IFNE      'Y'
     C     ARFL06        ANDNE     'N'
     C     ARFL06        ANDNE     ' '
     C                   MOVE      *ON           *IN35                          RI/PC
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(7)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      * JOB NAME
     C     ARFL05        IFNE      'Y'
     C     ARFL05        ANDNE     'N'
     C     ARFL05        ANDNE     ' '
     C                   MOVE      *ON           *IN36                          RI/PC
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(7)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      *
¢A    * FUEL SURCHARGE
¢A   C     ARFL08        IFNE      'Y'
¢A   C     ARFL08        ANDNE     'N'
¢A   C                   MOVE      *ON           *IN80                          RI/PC
¢A   C     ERRMSG        IFEQ      *BLANKS
¢A ¢SC                   MOVE      EMS(2)        ERRMSG                         ERROR OCCURED
¢A   C                   ENDIF
¢A   C                   ENDIF
¢q    *
¢q    * Warranty Fee
¢q   C     ARCD59        IFNE      'Y'
¢q   C     ARCD59        ANDNE     'N'
¢q   C                   MOVE      *ON           *IN89                          RI/PC
¢q   C     ERRMSG        IFEQ      *BLANKS
¢q ¢SC                   MOVE      EMS(2)        ERRMSG                         ERROR OCCURED
¢q   C                   ENDIF
¢q   C                   ENDIF
¢W    * Charge freight
¢W   C     CHGFRT        IFNE      'Y'
¢W   C     CHGFRT        ANDNE     'N'
¢W   C                   MOVE      *ON           *IN83                          RI/PC
¢W   C     ERRMSG        IFEQ      *BLANKS
¢W   C                   MOVE      EMS(2)        ERRMSG                         ERROR OCCURED
¢W   C                   ENDIF
¢W   C                   ENDIF
      *  Validate ship method/code
      *
     C     ARCDC5        IFNE      *BLANKS
     C     ARCDC6        ORNE      *BLANKS
     C     ARCDC5        IFNE      'D'
     C     ARCDC5        ANDNE     'O'
     C     ARCDC5        ANDNE     'P'
     C     ARCDC5        ANDNE     'S'
     C                   MOVE      *ON           *IN28
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(49)       ERRMSG
     C                   ENDIF
     C                   ENDIF
     C     ARCDC6        IFNE      *BLANKS
     C     SHPKEY        CHAIN     OEFMSCD                            40
     C     *IN40         DOWEQ     *OFF
     C     OEFL24        ANDNE     'X'                                          SALES ORDER
     C     SHPKEY        READE     OEFMSCD                                40
     C                   ENDDO
     C     *IN40         IFEQ      *ON
     C                   MOVE      *ON           *IN67
     C                   MOVE      *ON           *IN28
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(50)       ERRMSG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
DQ    * VALIDATE CUSTOMER CLASS PCAR
DQ   C     ARCDl1        IFNE      *BLANKS
DQ   C                   EXSR      @ValidCusClass
DQ   C     SQLCOUNT      IFEQ      0
DQ   C                   MOVE      *ON           *IN72                          RI/PC
DQ   C     ERRMSG        IFEQ      *BLANKS
DQ   C                   MOVE      EMS(66)       ERRMSG                         ERROR OCCURED
DQ   C                   ENDIF
DQ   C                   ENDIF
DQ   C                   ENDIF
      *
      * MARKET CLASS/SALES TYPE
C0 D1 * If ARCD03 is Blank  then display error message
C0 D1C*    ARCD03        IFEQ      *BLANK
C0 D1C*                  MOVE      *ON           *IN68
C0 D1C*    ERRMSG        IFEQ      *BLANKS
C0 D1C*                  MOVE      EMS(4)        ERRMSG
C0 D1C*                  ENDIF
C0 D1C*                  ENDIF
C0
     C     ARCD03        IFNE      *BLANK
     C                   MOVE      'OE36'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     ARCD03        TBNO02
     C     TBKEY         CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *ON
     C                   MOVE      *ON           *IN68
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(4)        ERRMSG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
¢P    * MARKET TYPE
¢P   C     ARCD02        IFNE      *BLANK
¢P   C                   MOVE      'MTYP'        TBNO01
¢P   C                   MOVE      *BLANKS       TBNO02
¢P   C                   MOVEL     ARCD02        TBNO02
¢P   C     TBKEY         CHAIN     TBFMTBL                            40
¢P   C     *IN40         IFEQ      *ON
¢P   C                   move      *ON           *IN29
¢P   C     ERRMSG        IFEQ      *BLANKS
¢P   C                   MOVE      CMS(6)        ERRMSG
¢P   C                   ENDIF
¢P   C                   ENDIF
¢P   C                   ENDIF
      * TAX EXEMPT
     C     ARFL13        IFNE      'Y'
     C     ARFL13        ANDNE     'N'
     C     ARFL13        ANDNE     ' '
     C                   MOVE      *ON           *IN37                          RI/PC
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(7)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
DP    *
DP   C                   if        VectaYes = 'Y'
DP   C                   eval      mktDesc =  *blanks
DP   C                   eval      geoDesc =  *blanks
DP   C                   eval      tbno01 = 'AR36'
DP    *
DP    * Validate customer market type
DP   C                   if        arcd02 <>*blanks
DP    * Determine if licensed to this product...
DP    * The following license key checking logic may not be altered, bypassed or removed.
DP    * See Legal Document in WRKMINKEY command for more information.
DP   C                   if        LicToVecta
DP   C                   eval      tbno02 = 'MT'
DP    * Right adjust value, if just 1 char
DP   C                   if        %len(%trim(arcd02)) = 1
DP   C                   eval      arcd02 = ' ' + %trim(arcd02)
DP   C                   endif
DP   C                   move      arcd02        tbno02
DP   C     tbKey         chain     Tbfmtbl
DP   C                   if        not %found
DP   C                   eval      *in53 = *on
DP   C                   if        errmsg = *blanks
DP   C                   eval      errmsg = 'Customer Market Type not valid.'
DP   C                   endif
DP   C                   else
DP   C                   eval      mktDesc =  %trim(tbno03)
DP   C                   endif
DP   C                   endif
DP   C                   endif
DP    *
DP    * Validate geographic territory
DP   C                   if        arcd05 <> *zeros
DP    * Determine if licensed to this product...
DP    * The following license key checking logic may not be altered, bypassed or removed.
DP    * See Legal Document in WRKMINKEY command for more information.
DP   C                   if        LicToVecta
DP   C                   eval      tbno02 = 'GT'
DP   C                   move      arcd05        tbno02
DP   C     tbKey         chain     Tbfmtbl
DP   C                   if        not %found
DP   C                   eval      *in69 = *on
DP   C                   if        errmsg = *blanks
DP   C                   eval      errmsg = 'Geographic Territory not valid.'
DP   C                   endif
DP   C                   else
DP   C                   eval      geoDesc =  %trim(tbno03)
DP   C                   endif
DP   C                   endif
DP   C                   endif
DP   C                   endif
DG    *
DG    * Exemption number and expiry date only required if not using
DG    * AvaTax
DJ    * Exemption# & expiry date are optional if using AvaTax.
DG DJC*                  if        avaTaxActive <>'Y'
     C     ARFL13        IFEQ      'Y'
     C     ARNO02        ANDEQ     *BLANK
DJ   C     avaTaxActive  andne     'Y'
     C                   MOVE      *ON           *IN26                          RI/PC
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      UMS(2)        ERRMSG
     C                   ENDIF
     C                   ENDIF
     C     EXPDAT        IFNE      *ZEROS
     C                   MOVE      'V'           ZZFUNC
     C                   Z-ADD     EXPDAT        ZZDATE
     C                   CALL      'UDR'         UDRPRM
     C     ZZFUNC        IFEQ      '*'
     C                   MOVE      *ON           *IN51
     C     ERRMSG        IFEQ      *BLANKS
   DJC*                  MOVEL     EMS(58)       MSGFLD
DJ   C                   MOVEL     EMS(58)       ERRMSG
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     4             DATYP                          DATE TYPE
     C                   MOVE      EXPDAT        DATE6                          EXPIRATION DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      DACEN         ARCC89
     C                   ENDIF
CX   C                   ELSE
CX   C                   Z-ADD     0             ARCC89
     C                   ENDIF
DG DJC*                  endif
      * DELIVERY TAX JURISDICTION
      *
      * If zip code overridden, display window if more than one tax
      * code is attached to the zip code and allow user to select tax
      * jurisdiction that applies to the order.
DD   C                   if        AvaTaxActive <> 'Y'
     C     ARZP16        IFNE      CPYZIP
     C                   MOVE      ARZP16        ZPCD
     C                   MOVE      ARCD04        TXCD
   DBC*                  Z-ADD     9             RETCOD
DB   C                   Z-ADD     2             RETCOD
     C                   CALL      'ARR9100'     PL9100
     C     RETCOD        IFEQ      7
     C                   MOVE      *ON           *IN81                          ERROR MESSAGE
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(5)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ELSE
     C     ZPCD          IFNE      ARZP16
     C                   MOVE      EMS(57)       ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   MOVE      TXCD          ARCD04
     C                   MOVE      ZPCD          ARZP16
     C                   ENDIF
     C                   MOVE      ARZP16        CPYZIP
     C                   GOTO      DSPLY1
     C                   ENDIF
      *
      * Ensure shipping zip code is attached to jurisdiction
      *
     C                   MOVE      ARZP16        ZPCD
     C                   MOVE      ARCD04        TXCD
     C                   Z-ADD     8             RETCOD
     C                   CALL      'ARR9100'     PL9100
     C     RETCOD        IFEQ      7
     C                   MOVE      *ON           *IN81                          ERROR MESSAGE
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(5)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      *
     C     ARCD04        IFNE      0                                            DELIVERY TAX JURS
     C     *IN37         ANDEQ     *OFF
     C     ARCD04        SETLL     ARFMTAX                                40    EXIST ?
     C     *IN40         IFEQ      '0'
     C                   MOVE      *ON           *IN81                          ERROR MESSAGE
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(5)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * PICKUP TAX JURISDICTION
     C     ARCD30        IFNE      0                                            PICKUP TAX JURS
     C     ARCD30        SETLL     ARFMTAX                                40    EXIST ?
     C     *IN40         IFEQ      '0'
     C                   MOVE      *ON           *IN84                          RI/PC
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(6)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
DD   C                   endif
      * GST TAX EXEMPT
     C     ARCDB9        IFNE      'Y'
     C     ARCDB9        ANDNE     'N'
     C     ARCDB9        ANDNE     ' '
     C     *IN71         ANDEQ     *ON
     C                   MOVE      *ON           *IN57                          RI/PC
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(7)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
DG    * Always exempt
DG   C                   if        avaTaxActive = 'Y'
DG   C                   eval      *in60 = *off                                 RI/PC
DG   C                   if        arfla2 <> 'Y'                                P.O. REQUIRED
DG   C                             and arfla2  <> 'N'                           P.O. REQUIRED
DG   C                             and arfla2  <> *blanks                       P.O. REQUIRED
DG   C                   eval      *in60 = *on                                  RI/PC
DG   C                   if        errmsg = *blanks
DG   C                   eval      errmsg = 'Value must be (''Y'',  +           ERROR OCCURED
DG   C                             ''N'', '' '' ).'
DG   C                   endif
DG   C                   endif
DN   C                   endif
DG    *
DG DN * Usage type, validate only if not using Certificate software
DN    * Usage type, validate if field is allowed to be maintained
DG DNC*                  if        wEcms <> 'Y'
DN   C                   if        wEcms2 = 'Y'
DN   C                             and wEcms1 <> 'Y'
DG   C                   eval      *in62 = *off                                 RI/PC
DG DKC*                  eval      *in30 = *on
DG    * Do not allow blank values, if customer is tax exempt
DG   C                   if        arfl13 = 'Y' and
DG   C                             arcdk3 = *blanks
DG   C                   eval      *in62 = *on
DG   C                   if        errmsg = *blanks
DG   C                   eval      errmsg = 'Usage type cannot be -
DG   C                             blanks.'
DG   C                   endif
DG   C                   endif
DG    *
DG    * Do not allow values, if customer is NOT tax exempt
DG   C                   if        arfl13 <>'Y' and
DG   C                             arcdk3 <> *blanks
DG   C                   eval      *in62 = *on
DG DKC*                  eval      *in30 = *off
DG   C                   if        errmsg = *blanks
DG   C                   eval      errmsg = 'Usage type should be -
DG   C                             blanks, if customer is not tax -
DG   C                             exempt.'
DG   C                   endif
DG   C                   endif
DG    *
DG    * Validate if entered value is 1 character only
DG   C                   if        %len(%trim(arcdk3)) = 1                      P.O. REQUIRED
DG   C                   eval      tbno01 = 'AR29'
DG   C                   eval      tbno02 = arcdk3
DG   C     tbkey         setll     tbfmtbl                                40
DG   C                   if        *in40 = *off
DG   C                   eval      *in62 = *on
DG   C                   if        errmsg = *blanks
DG   C                   eval      errmsg = 'Invalid usage type; use -
DG   C                             Prompt for valid values.'
DG   C                   endif
DG   C                   endif
DG   C                   endif
DG    *
DG   C                   endif
DG    *
DG DNC*                  endif
DG    *
      * VALIDATE LOCK FIELDS...
     C                   SELECT
     C     ARFL30        WHENNE    'Y'
     C     ARFL30        ANDNE     'N'
     C     ARFL30        ANDNE     ' '
     C                   MOVE      *ON           *IN63
     C                   MOVE      EMS(7)        ERRMSG
     C     ARFL31        WHENNE    'Y'
     C     ARFL31        ANDNE     'N'
     C     ARFL31        ANDNE     ' '
     C                   MOVE      *ON           *IN64
     C                   MOVE      EMS(7)        ERRMSG
     C     ARFL32        WHENNE    'Y'
     C     ARFL32        ANDNE     'N'
     C     ARFL32        ANDNE     ' '
     C                   MOVE      *ON           *IN65
     C                   MOVE      EMS(7)        ERRMSG
     C     ARFL46        WHENNE    'Y'
     C     ARFL46        ANDNE     'N'
     C     ARFL46        ANDNE     ' '
     C                   MOVE      *ON           *IN66
     C                   MOVE      EMS(7)        ERRMSG
      *
     C                   ENDSL
      *
      * WARN USER IF ENTERPRISE VALUES DO NOT MATCH CUSTOMER VALUES
      * AND NOT LOCKED.
      *
     C     ARNO82        IFNE      0
     C     WRNFLG        IFNE      'Y'
     C     ARFL31        IFNE      'Y'
     C     ARFL27        ANDNE     ARFL01
     C                   MOVE      *ON           *IN34
     C                   MOVE      'Y'           WRNFLG
     C                   ENDIF
     C     ARFL32        IFNE      'Y'
     C     ARCDD2        ANDNE     ARCD65
     C                   MOVE      *ON           *IN79
     C                   MOVE      'Y'           WRNFLG
     C                   ENDIF
     C     ARFL30        IFNE      'Y'
     C     ARFL26        ANDNE     ARFL02
     C                   MOVE      *ON           *IN82
     C                   MOVE      'Y'           WRNFLG
     C                   ENDIF
     C     ARFL46        IFNE      'Y'
     C     ARCDC5        IFNE      ARCDE2
     C     ARCDC6        ORNE      ARCDE3
     C                   MOVE      *ON           *IN66
     C                   MOVE      'Y'           WRNFLG
     C                   ENDIF
     C                   ENDIF
      *
     C     WRNFLG        IFEQ      'Y'
     C                   MOVE      EMS(9)        ERRMSG
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      *
      * The following code is to clear MSGFLD from the screen;
      * NOTE: All logic using 'MSGFLD' needs to go above this code
      *       in order to prevent conflicts between the use of
      *       ERRMSG keyword on DDS and message field use.
      *
     C     ERRMSG        IFEQ      *BLANKS
     C     MFLG          ANDEQ     'Y'
     C                   CLEAR                   MFLG
     C                   WRITE     ARF5015B
     C                   ENDIF
      *
     C     ERRMSG        IFNE      *BLANKS
     C                   MOVE      'Y'           S15BER
     C                   ELSE
     C                   MOVE      ' '           S15BER
     C                   ENDIF
      *
     C     ERRMSG        CABNE     *BLANKS       DSPLY1                                     D ?
      *
      * DEFAULT ENTERPRISE VALUES IF CUSTOMER VALUES NOT LOCKED
     C     ARNO82        IFNE      0
     C     ARFL30        IFNE      'Y'
     C                   MOVE      ARFL26        ARFL02
     C                   ENDIF
     C     ARFL31        IFNE      'Y'
     C                   MOVE      ARFL27        ARFL01
     C                   ENDIF
     C     ARFL32        IFNE      'Y'
     C                   MOVE      ARCDD2        ARCD65
     C                   ENDIF
     C     ARFL46        IFNE      'Y'
     C                   MOVE      ARCDE2        ARCDC5
     C                   MOVE      ARCDE3        ARCDC6
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           S15BER
     C                   ELSE
     C                   MOVE      ' '           S15BER
     C                   ENDIF
     C     *IN99         CABEQ     '1'           DSPLY1                         ERROR OCCURED ?
      * PREVIOUS
     C     *IN12         CABEQ     *ON           ENDSLS                         CMD 12 PREVIOUS
      *
      * IF F10= UPDATE PRESSED,
      *    ENSURE NO ERROR EXIST ON ANY SCREEN
      *    SET F10 UPDATE FLAG TO YES
     C     *IN10         IFEQ      '1'
     C     ADDCUS        ANDEQ     'N'
     C                   SELECT
     C     SCRNER        WHENNE    *BLANKS
     C                   MOVE      UMS(3)        ERRMSG
     C     ERRMSG        CABNE     *BLANKS       DSPLY1
     C                   OTHER
     C                   MOVE      'Y'           F10FLG
     C                   ENDSL
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN28
     C     ENDSLS        TAG
DD   C                   eval      *in54 = svin54
DG   C                   eval      *in60 = svin60
DG   C                   eval      *in61 = svin61
DG   C                   eval      *in62 = svin62
DM   C                   eval      *in39 = svin39
     C                   MOVE      SVIN51        *IN51
DP   C                   eval      *in69 = svin69
DP   C                   eval      *in53 = svin53
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    CUSTOMER PRINT CODE SUBROUTINE                          *
      *------------------------------------------------------------------------*
     C     PRTCOD        BEGSR
      *
     C                   MOVE      *IN34         SVIN34            1
     C                   MOVE      *IN35         SVIN35            1
     C                   MOVE      *IN38         IN38SV            1
     C                   MOVE      *IN39         SVIN39            1
C1   C                   MOVE      *IN40         SVIN40            1
C1   C                   MOVE      *IN41         SVIN41            1
C2   C                   MOVE      *IN42         SVIN42            1
C2   C                   MOVE      *IN43         SVIN43            1
     C                   MOVE      *IN50         SVIN50            1
     C                   MOVE      *IN51         SVIN51            1
     C                   MOVE      *IN52         SVIN52            1
     C                   MOVE      *IN54         SVIN54            1
     C                   MOVE      *IN55         SVIN55            1
     C                   MOVE      *IN56         SVIN56            1
     C                   MOVE      *IN57         SVIN57            1
     C                   MOVE      *IN58         SVIN58            1
     C                   MOVE      *IN59         SVIN59            1
     C                   MOVE      *IN60         SVIN60            1
     C                   MOVE      *IN61         SVIN61            1
     C                   MOVE      *IN62         SVIN62            1
     C                   MOVE      *IN66         SVIN66            1
     C                   MOVE      *IN68         SVIN68            1
     C                   MOVE      *IN69         SVIN69            1
DQ   C                   MOVE      *IN72         SVIN72            1
     C                   MOVE      *IN81         SVIN81            1
     C                   MOVE      *IN83         SVIN83            1
     C                   MOVE      *IN84         SVIN84            1
     C                   MOVE      *IN85         SVIN85            1
     C                   MOVE      *IN86         SVIN86            1
     C                   MOVE      *IN87         SVIN87            1
     C                   MOVE      *IN89         SVIN89            1
     C                   MOVE      *IN91         SVIN91            1
     C                   MOVE      *IN93         SVIN93            1
     C                   MOVE      *IN94         SVIN94            1
     C                   MOVE      *IN96         SVIN96            1
     C                   MOVE      *IN97         SVIN97            1
     C                   MOVE      *IN98         SVIN98            1
     C                   MOVEA     '0'           *IN(86)
     C                   MOVEA     '00'          *IN(34)
   C1C*                  MOVEA     '00'          *IN(38)
C1 C2C*                  MOVEA     '0000'        *IN(38)
C2   C                   MOVEA     '000000'      *IN(38)
     C                   MOVEA     '000'         *IN(50)
     C                   MOVEA     '00000000'    *IN(54)
     C                   MOVEA     '0'           *IN(62)
     C                   MOVEA     '0'           *IN(66)
     C                   MOVEA     '00'          *IN(68)
     C                   MOVEA     '0'           *IN(81)
     C                   MOVEA     '0'           *IN(83)
     C                   MOVEA     '0'           *IN(84)
     C                   MOVEA     '000'         *IN(85)
     C                   MOVE      '0'           *IN(89)
     C                   MOVE      '0'           *IN(91)
     C                   MOVEA     '00'          *IN(93)
     C                   MOVEA     '000'         *IN(96)
     C                   MOVE      'N'           WARNCP            1            SET WARN FLAG OFF
     C                   CLEAR                   MSGFLD
     C                   CLEAR                   MFLG
     C                   CLEAR                   WRNFLG
     C                   MOVE      'N'           F3WRN
      *
   CCC*    DSPLYJ        TAG
      *
      * UNCODE PRINT TYPES INTO SCREEN FIELDS
      *
      * CUSTOMER STATEMENT PRINT TYPE
     C                   SELECT
     C     ARFL04        WHENEQ    '0'
     C                   MOVE      '   '         CCSTYP
     C                   MOVE      '     '       PS15
     C     ARFL04        WHENEQ    '1'
     C                   MOVE      ' P '         CCSTYP
     C                   MOVE      'X    '       PS15
     C     ARFL04        WHENEQ    '2'
     C                   MOVE      ' F '         CCSTYP
     C                   MOVE      ' X   '       PS15
     C     ARFL04        WHENEQ    '3'
     C                   MOVE      ' E '         CCSTYP
     C                   MOVE      '  X  '       PS15
     C     ARFL04        WHENEQ    '4'
     C                   MOVE      'P/F'         CCSTYP
     C                   MOVE      '   X '       PS15
     C     ARFL04        WHENEQ    '5'
     C                   MOVE      'P/E'         CCSTYP
     C                   MOVE      '    X'       PS15
     C                   ENDSL
CC   C                   move      ps15          svps15            5
      * ENTERPRISE STATEMENT PRINT TYPE
     C                   SELECT
     C     ARFL81        WHENEQ    '0'
     C                   MOVE      '   '         ENSTYP
     C     ARFL81        WHENEQ    '1'
     C                   MOVE      ' P '         ENSTYP
     C     ARFL81        WHENEQ    '2'
     C                   MOVE      ' F '         ENSTYP
     C     ARFL81        WHENEQ    '3'
     C                   MOVE      ' E '         ENSTYP
     C     ARFL81        WHENEQ    '4'
     C                   MOVE      'P/F'         ENSTYP
     C     ARFL81        WHENEQ    '5'
     C                   MOVE      'P/E'         ENSTYP
     C                   ENDSL
      * CUSTOMER PRINT TYPE
     C                   SELECT
     C     ARCDE7        WHENEQ    '0'
     C                   MOVE      '   '         CUSTYP
     C                   MOVE      '     '       PT15
     C     ARCDE7        WHENEQ    '1'
     C                   MOVE      ' P '         CUSTYP
     C                   MOVE      'X    '       PT15
     C     ARCDE7        WHENEQ    '2'
     C                   MOVE      ' F '         CUSTYP
     C                   MOVE      ' X   '       PT15
     C     ARCDE7        WHENEQ    '3'
     C                   MOVE      ' E '         CUSTYP
     C                   MOVE      '  X  '       PT15
     C     ARCDE7        WHENEQ    '4'
     C                   MOVE      'P/F'         CUSTYP
     C                   MOVE      '   X '       PT15
     C     ARCDE7        WHENEQ    '5'
     C                   MOVE      'P/E'         CUSTYP
     C                   MOVE      '    X'       PT15
     C                   ENDSL
CC   C                   move      pt15          svpt15            5
      * ENTERPRISE PRINT TYPE
     C                   SELECT
     C     ARCDE8        WHENEQ    '0'
     C                   MOVE      '   '         ENTTYP
     C     ARCDE8        WHENEQ    '1'
     C                   MOVE      ' P '         ENTTYP
     C     ARCDE8        WHENEQ    '2'
     C                   MOVE      ' F '         ENTTYP
     C     ARCDE8        WHENEQ    '3'
     C                   MOVE      ' E '         ENTTYP
     C     ARCDE8        WHENEQ    '4'
     C                   MOVE      'P/F'         ENTTYP
     C     ARCDE8        WHENEQ    '5'
     C                   MOVE      'P/E'         ENTTYP
     C                   ENDSL
   CA * CUSTOMER PRINT PRICES
   CAC*                  SELECT
   CAC*    ARCDB7        WHENEQ    '0'
   CAC*                  MOVE      '   '         CUSPP
   CAC*                  MOVE      '     '       PP15
   CAC*    ARCDB7        WHENEQ    '1'
   CAC*                  MOVE      ' P '         CUSPP
   CAC*                  MOVE      'X    '       PP15
   CAC*    ARCDB7        WHENEQ    '2'
   CAC*                  MOVE      ' F '         CUSPP
   CAC*                  MOVE      ' X   '       PP15
   CAC*    ARCDB7        WHENEQ    '3'
   CAC*                  MOVE      ' E '         CUSPP
   CAC*                  MOVE      '  X  '       PP15
   CAC*    ARCDB7        WHENEQ    '4'
   CAC*                  MOVE      'P/F'         CUSPP
   CAC*                  MOVE      '   X '       PP15
   CAC*    ARCDB7        WHENEQ    '5'
   CAC*                  MOVE      'P/E'         CUSPP
   CAC*                  MOVE      '    X'       PP15
   CAC*                  ENDSL
   CA * CUSTOMER PRINT NET PRICES
   CAC*                  SELECT
   CAC*    ARCDB8        WHENEQ    '0'
   CAC*                  MOVE      '   '         CUSPN
   CAC*                  MOVE      '     '       PN15
   CAC*    ARCDB8        WHENEQ    '1'
   CAC*                  MOVE      ' P '         CUSPN
   CAC*                  MOVE      'X    '       PN15
   CAC*    ARCDB8        WHENEQ    '2'
   CAC*                  MOVE      ' F '         CUSPN
   CAC*                  MOVE      ' X   '       PN15
   CAC*    ARCDB8        WHENEQ    '3'
   CAC*                  MOVE      ' E '         CUSPN
   CAC*                  MOVE      '  X  '       PN15
   CAC*    ARCDB8        WHENEQ    '4'
   CAC*                  MOVE      'P/F'         CUSPN
   CAC*                  MOVE      '   X '       PN15
   CAC*    ARCDB8        WHENEQ    '5'
   CAC*                  MOVE      'P/E'         CUSPN
   CAC*                  MOVE      '    X'       PN15
   CAC*                  ENDSL
   CA * ENTERPRISE PRINT PRICES
   CAC*                  SELECT
   CAC*    ARCDD4        WHENEQ    '0'
   CAC*                  MOVE      '   '         ENTPP
   CAC*    ARCDD4        WHENEQ    '1'
   CAC*                  MOVE      ' P '         ENTPP
   CAC*    ARCDD4        WHENEQ    '2'
   CAC*                  MOVE      ' F '         ENTPP
   CAC*    ARCDD4        WHENEQ    '3'
   CAC*                  MOVE      ' E '         ENTPP
   CAC*    ARCDD4        WHENEQ    '4'
   CAC*                  MOVE      'P/F'         ENTPP
   CAC*    ARCDD4        WHENEQ    '5'
   CAC*                  MOVE      'P/E'         ENTPP
   CAC*                  ENDSL
   CA * ENTERPRISE PRINT NET PRICES
   CAC*                  SELECT
   CAC*    ARCDD5        WHENEQ    '0'
   CAC*                  MOVE      '   '         ENTPN
   CAC*    ARCDD5        WHENEQ    '1'
   CAC*                  MOVE      ' P '         ENTPN
   CAC*    ARCDD5        WHENEQ    '2'
   CAC*                  MOVE      ' F '         ENTPN
   CAC*    ARCDD5        WHENEQ    '3'
   CAC*                  MOVE      ' E '         ENTPN
   CAC*    ARCDD5        WHENEQ    '4'
   CAC*                  MOVE      'P/F'         ENTPN
   CAC*    ARCDD5        WHENEQ    '5'
   CAC*                  MOVE      'P/E'         ENTPN
   CAC*                  ENDSL
CC   C     DSPLYJ        TAG
      *
      * SAVE SCREEN FIELDS
     C                   MOVE      ARFL04        SVFL04
     C                   MOVE      ARCD29        SVCD29
$J   C                   MOVE      *IN36         SVIN36                         SAVE *IN36
$P   C                   IF        ARNO01 <> 0                                  Non-Walkin
$P   C                   EVAL      ARCD29 = 'O'
$P   C                   ENDIF
$J   C                   EVAL      *IN36 = *ON                                  Protect Stmt Type
     C                   MOVE      ARFL72        SVFL72
     C                   MOVE      ARCDE7        SVCDE7
     C                   MOVE      ARNO05        SVNO05
     C                   MOVE      ARFL48        SVFL48
     C                   MOVE      ARFL50        SVFL50
     C                   MOVE      ARCDB7        SVCDB7
     C                   MOVE      ARCDB8        SVCDB8
     C                   MOVE      ARFL52        SVFL52
     C                   MOVE      ARFL61        SVFL61
C1   C                   MOVE      ARFL88        SVFL88
C2   C                   MOVE      ARFL91        SVFL91
CZ   C     ARFL48        IFEQ      ' '
CZ   C                   EVAL      ARFL48 = 'N'
CZ   C                   ENDIF
C1   C     ARFL88        IFEQ      ' '
C1   C                   EVAL      ARFL88 = 'N'
C1   C                   ENDIF
C1   C     ARFL89        IFEQ      ' '
C1   C                   EVAL      ARFL89 = 'N'
C1   C                   ENDIF
C1   C     ARFL90        IFEQ      ' '
C1   C                   EVAL      ARFL90 = 'N'
C1   C                   ENDIF
C2   C     ARFL91        IFEQ      ' '
C2   C                   EVAL      ARFL91 = 'N'
C2   C                   ENDIF
C2   C     ARFL93        IFEQ      ' '
C2   C                   EVAL      ARFL93 = 'N'
C2   C                   ENDIF
C2   C     ARFL94        IFEQ      ' '
C2   C                   EVAL      ARFL94 = 'N'
C2   C                   ENDIF
      *
     C                   EXFMT     ARF5015J
$J   C                   MOVE      SVIN36        *IN36                          Restore *IN36
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVEA     '00'          *IN(34)
   C1C*                  MOVEA     '00'          *IN(38)
C1 C2C*                  MOVEA     '0000'        *IN(38)
C2   C                   MOVEA     '000000'      *IN(38)
     C                   MOVEA     '000'         *IN(50)
     C                   MOVEA     '00000000'    *IN(54)
     C                   MOVEA     '0'           *IN(86)
     C                   MOVEA     '0'           *IN(62)
     C                   MOVEA     '0'           *IN(66)
     C                   MOVEA     '00'          *IN(68)
     C                   MOVEA     '0'           *IN(81)
     C                   MOVEA     '0'           *IN(83)
     C                   MOVEA     '0'           *IN(84)
     C                   MOVEA     '000'         *IN(85)
     C                   MOVE      '0'           *IN(89)
     C                   MOVE      '0'           *IN(91)
     C                   MOVEA     '00'          *IN(93)
     C                   MOVEA     '000'         *IN(96)
     C                   MOVE      'Y'           S15JUP
      *
      * RESET WARNING FLAG
     C     ARFL04        IFNE      SVFL04
     C     ARCD29        ORNE      SVCD29
     C     ARFL72        ORNE      SVFL72
     C     ARCDE7        ORNE      SVCDE7
     C     ARNO05        ORNE      SVNO05
     C     ARFL48        ORNE      SVFL48
     C     ARFL50        ORNE      SVFL50
     C     ARCDB7        ORNE      SVCDB7
     C     ARCDB8        ORNE      SVCDB8
     C     ARFL52        ORNE      SVFL52
     C     ARFL61        ORNE      SVFL61
C1   C     ARFL88        ORNE      SVFL88
C2   C     ARFL91        ORNE      SVFL91
     C                   CLEAR                   WRNFLG
     C                   ENDIF
CJ   C     f3flg         ifeq      'Y'
CJ   C     *in03         ifeq      *on
CJ   C                   move      '0'           *in03
CJ   C     msgfld        ifeq      *blanks
CJ   C                   move      ems(63)       msgfld
CJ   C                   endif
CJ   C                   goto      dsplyj
CJ   C                   endif
CJ   C     *in10         ifeq      *on
CJ   C                   move      '0'           *in10
CJ   C     msgfld        ifeq      *blanks
CJ   C                   move      ems(64)       msgfld
CJ   C                   endif
CJ   C                   goto      dsplyj
CJ   C                   endif
CJ   C                   endif
     C     *IN03         IFEQ      *OFF
     C                   MOVE      'N'           F3WRN
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     UMS(5)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPLYJ
     C                   ENDIF
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      * CALL HELP TEXT USER DOCUMENTATION
      *
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'
     C                   PARM                    PROG
     C                   PARM                    SCREEN
     C     *IN25         CABEQ     *ON           DSPLYJ
     C                   ENDIF
      *
      * F9=Fax inormation
     C     *IN09         IFEQ      *ON                                          F9=FAX INFO
   CCC*    ARFL04        IFNE      '2'
   CCC*    ARFL04        ANDNE     '4'
CC   C     ps15          Ifne      svps15
CC   C     ps15          Lookup    dist                                   40
CC   C     *in40         Ifeq      *off
CC   C     ps2           IFNE      'X'
CC   C     ps4           ANDNE     'X'
     C                   MOVE      *ON           *IN86
     C                   MOVE      EMS(60)       MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPLYJ
     C                   ENDIF
     C     FAXNUM        IFEQ      *ZERO                                        FAX NUMBER
   CCC*    ARFL04        IFEQ      '2'                                          FAX
   CCC*    ARFL04        OREQ      '4'                                          BOTH
CC   C     ps2           IFeq      'X'
CC   C     ps4           ANDeq     'X'
     C                   MOVE      *ON           *IN86                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(59)       MSGFLD                         ENTER C, E, B, OR N.
     C     MSGFLD        CABNE     *BLANKS       DSPLYJ
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
CC   C                   Endif
CC   C                   Endif
CC   C     ps2           IFeq      'X'
CC   C     ps4           oreq      'X'
     C                   EXSR      @CURSR
     C                   MOVE      ARNO01        CUSNBR
     C                   MOVE      *BLANKS       CUSNAM
     C                   MOVEL     ARNM01        CUSNAM
     C                   MOVE      *BLANKS       FAXNBR
     C                   MOVEL     FAXNUM        FAXNBR
     C                   MOVE      ARCDB3        OPTION
     C                   CALL      'OPR0310'     PL0310
     C                   EXSR      @CLCSR
     C                   MOVE      'N'           DSPFAX
CC   C                   Endif
CC   C     msgfld        CABne     *blanks       DSPLYJ
   CCC*    *IN09         CABEQ     *ON           DSPLYJ
     C                   ENDIF
      *
      * F9=Fax inormation
     C     *IN09         IFEQ      *ON                                          F9=FAX INFO
   CCC*    ARCDE7        IFNE      '2'
   CCC*    ARCDE7        ANDNE     '4'
CC   C     pt15          ifne      svpt15
CC   C     pt15          Lookup    dist                                   40
CC   C     *in40         Ifeq      *off
CC   C     pt2           IFne      'X'
CC   C     pt4           ANDne     'X'
     C                   MOVE      *ON           *IN34
     C                   MOVE      EMS(37)       MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPLYJ
     C                   ENDIF
     C     FAXNUM        IFEQ      *ZERO                                        FAX NUMBER
   CCC*    ARCDE7        IFEQ      '2'                                          FAX
   CCC*    ARCDE7        OREQ      '4'                                          BOTH
CC   C     pt2           IFeq      'X'
CC   C     pt4           ANDeq     'X'
     C                   MOVE      *ON           *IN34                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(36)       MSGFLD                         ENTER C, E, B, OR N.
     C     MSGFLD        CABNE     *BLANKS       DSPLYJ
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
CC   C                   Endif
CC   C                   Endif
CC   C     pt2           IFeq      'X'
CC   C     pt4           oreq      'X'
     C                   EXSR      @CURSR
     C                   MOVE      ARNO01        CUSNBR
     C                   MOVE      *BLANKS       CUSNAM
     C                   MOVEL     ARNM01        CUSNAM
     C                   MOVE      *BLANKS       FAXNBR
     C                   MOVEL     FAXNUM        FAXNBR
     C                   MOVE      ARCDB3        OPTION
     C                   CALL      'OPR0310'     PL0310
     C                   EXSR      @CLCSR
     C                   MOVE      'N'           DSPFAX
CC   C                   Endif
   CCC*    *IN09         CABEQ     *ON           DSPLYJ
CC   C     msgfld        CABne     *blanks       DSPLYJ
     C                   ENDIF
CC    * F9=Fax information
CC   C     *IN09         IFEQ      *ON                                          F9=FAX INFO
CC   C     ps2           Ifne      'X'
CC   C     ps4           Andne     'X'
CC   C     pt2           Andne     'X'
CC   C     pt4           Andne     'X'
CC   C                   Move      *on           *in34
CC   C                   Move      *on           *in86
CC   C                   Move      UMS(7)        Msgfld
CC   C     Msgfld        Cabne     *blanks       DSPLYJ
CC   C                   ENDIF
CC   C                   ENDIF
      *
      * TRANSLATE/EDIT PRINT STATEMENT TYPE SELECTION
      *
     C                   MOVE      '0'           ARFL04
     C     PS1           IFNE      ' '
     C                   MOVE      '1'           ARFL04
     C                   ENDIF
     C     PS2           IFNE      ' '
     C     ARFL04        IFEQ      '0'
     C                   MOVE      '2'           ARFL04
     C                   ELSE
     C                   MOVE      *ON           *IN86                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     PS3           IFNE      ' '
     C     ARFL04        IFEQ      '0'
     C                   MOVE      '3'           ARFL04
     C                   ELSE
     C                   MOVE      *ON           *IN86                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     PS4           IFNE      ' '
     C     ARFL04        IFEQ      '0'
     C                   MOVE      '4'           ARFL04
     C                   ELSE
     C                   MOVE      *ON           *IN86                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     PS5           IFNE      ' '
     C     ARFL04        IFEQ      '0'
     C                   MOVE      '5'           ARFL04
     C                   ELSE
     C                   MOVE      *ON           *IN86                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * STATEMENT PRT/TYPE CANNOT BE 'F' NOR 'B' IF FAX NUMBER IS ZERO
      *
     C     FAXNUM        IFEQ      *ZERO                                        FAX NUMBER
     C     ARFL04        IFEQ      '2'                                          FAX
     C     ARFL04        OREQ      '4'                                          BOTH
     C                   MOVE      *ON           *IN86                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(59)       MSGFLD                         ENTER C, E, B, OR N.
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * CANNOT BE '3' OR '5' IF EMAIL IS NOT SET UP
      *
     C     EALLOW        IFNE      'Y'
     C     ARFL04        IFEQ      '3'                                          FAX
     C     ARFL04        OREQ      '5'                                          BOTH
     C                   MOVE      *ON           *IN86                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(54)       MSGFLD                         NO EMAIL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     EMAIL         IFEQ      *BLANKS
     C     ARFL04        IFEQ      '3'                                          FAX
     C     ARFL04        OREQ      '5'                                          BOTH
     C                   MOVE      *ON           *IN86                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(55)       MSGFLD                         ENTER C, E, B, OR N.
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * STATEMENT PRINT TYPE
      *
     C     ARCD29        IFNE      'B'                                          STMT TYPE PRINT
     C     ARCD29        ANDNE     'O'                                          OPEN,BAL FRD
     C                   MOVE      *ON           *IN85                          RI/PC
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVE      EMS(3)        MSGFLD                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      *
      * VALIDATE FAX S/O ACKNOWLEDGEMENTS
      *
     C     ARFL72        IFNE      'F'                                          FAX S/O ACK = Y
     C     ARFL72        ANDNE     'E'                                          EMAIL S/O   = N
     C     ARFL72        ANDNE     'N'                                          FAX S/O ACK = N
     C                   MOVE      *ON           *IN81                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(52)       MSGFLD                         ENTER Y, N, OR BLANK
     C                   ENDIF
     C                   ENDIF
      *
      * FAX S/O ACKNOWLEDGEMENT CANNOT BE 'Y' IF FAX NUMBER IS ZERO
      *
     C     FAXNUM        IFEQ      *ZERO                                        FAX NUMBER
     C     ARFL72        IFEQ      'F'                                          FAX S/O ACK.
     C                   MOVE      *ON           *IN81                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(38)       MSGFLD                         FAX# CANNOT BE ZERO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * CANNOT BE 'E' IF EMAIL IS NOT SET UP
      *
     C     EALLOW        IFNE      'Y'
     C     ARFL72        IFEQ      'E'                                          EMAIL
     C                   MOVE      *ON           *IN81                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(54)       MSGFLD                         NO EMAIL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     EMAIL         IFEQ      *BLANKS                                      EMAIL
     C     ARFL72        IFEQ      'E'
     C                   MOVE      *ON           *IN81                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                                  ANKS
     C                   MOVE      EMS(55)       MSGFLD                                     BE ZERO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * TRANSLATE/EDIT PRINT TYPE SELECTION
      *
      * VALIDATE INVOICE PRINT TYPE
      *
     C     PT15          IFEQ      ' '
     C     ARNO05        ANDGT     0
     C                   MOVE      *ON           *IN34                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      UMS(6)        MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      '0'           ARCDE7
     C     PT1           IFNE      ' '
     C                   MOVE      '1'           ARCDE7
     C                   ENDIF
     C     PT2           IFNE      ' '
     C     ARCDE7        IFEQ      '0'
     C                   MOVE      '2'           ARCDE7
     C                   ELSE
     C                   MOVE      *ON           *IN34                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     PT3           IFNE      ' '
     C     ARCDE7        IFEQ      '0'
     C                   MOVE      '3'           ARCDE7
     C                   ELSE
     C                   MOVE      *ON           *IN34                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     PT4           IFNE      ' '
     C     ARCDE7        IFEQ      '0'
     C                   MOVE      '4'           ARCDE7
     C                   ELSE
     C                   MOVE      *ON           *IN34                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     PT5           IFNE      ' '
     C     ARCDE7        IFEQ      '0'
     C                   MOVE      '5'           ARCDE7
     C                   ELSE
     C                   MOVE      *ON           *IN34                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * INVOICE PRINT TYPE CANNOT BE 'F' NOR 'B' IF FAX NUMBER IS ZERO
      *
     C     FAXNUM        IFEQ      *ZERO                                        FAX NUMBER
     C     ARCDE7        IFEQ      '2'                                          FAX
     C     ARCDE7        OREQ      '4'                                          BOTH
     C                   MOVE      *ON           *IN34                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(36)       MSGFLD                         ENTER C, E, B, OR N.
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * CANNOT BE '3' OR '5' IF EMAIL IS NOT SET UP
      *
     C     EALLOW        IFNE      'Y'
     C     ARCDE7        IFEQ      '3'                                          FAX
     C     ARCDE7        OREQ      '5'                                          BOTH
     C                   MOVE      *ON           *IN34                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(54)       MSGFLD                         NO EMAIL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     EMAIL         IFEQ      *BLANKS
     C     ARCDE7        IFEQ      '3'                                          FAX
     C     ARCDE7        OREQ      '5'                                          BOTH
     C                   MOVE      *ON           *IN34                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(55)       MSGFLD                         ENTER C, E, B, OR N.
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * # OF INVOICE COPIES CANNOT BE ZERO IF INVOICE PRINT TYPE 'P' OR 'B'
      *
     C     ARCDE7        IFEQ      '1'                                          PRINT
     C     ARCDE7        OREQ      '4'                                          PRINT/FAX
     C     ARCDE7        OREQ      '5'                                          PRINT/EMAIL
     C     ARNO05        IFEQ      *ZERO                                        NUMBER OF INVOICES
     C                   MOVE      *ON           *IN96                          RI PC
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(24)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * VALIDATE NUMBER OF INVOICES TO PRINT
      *
     C     *IN96         IFEQ      *OFF                                         NO ERROR ON # OF COP
     C     ARNO05        IFLE      *ZERO                                        NUMBER OF INVOICES
     C     WARNCP        ANDNE     'Y'                                          WARN FLAG NOT ON'
     C                   MOVE      *ON           *IN96                          RI PC
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      'Y'           WARNCP                         SET WARN FLAG ON
     C                   MOVE      UMS(1)        MSGFLD                         WARNING ON # OF INV.
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * VALIDATE CONSOLIDATED PRINTING
      *
     C     ARFL48        IFNE      'Y'                                          CONSOLID PRT /= Y
     C     ARFL48        ANDNE     'N'                                          CONSOLID PRT /= N
     C                   MOVE      *ON           *IN60                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(2)        MSGFLD                         ENTER Y OR N.
     C                   ENDIF
     C                   ENDIF
¢D   C     ARFL48        IFEQ      'Y'                                          CONSOLID prt /= Y
¢D   C     ARCDE7        ANDEQ     '2'                                          Invprt not print
¢D   C                   MOVE      *ON           *IN60                          DSPATR(RI PC)
¢D   C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
¢D   C                   MOVE      CMS(2)        MSGFLD                         ENTER Y OR N.
¢D   C                   ENDIF
¢D   C                   ENDIF
      *
      * VALIDATE CONSOLIDATED FAXING
      *
     C     ARFL50        IFNE      'F'                                          CONSOLID FAX
     C     ARFL50        ANDNE     'E'                                          CONSOLID EMAIL
     C     ARFL50        ANDNE     'N'                                          CONSOLID FAX /= N
     C                   MOVE      *ON           *IN50                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(52)       MSGFLD                         ENTER Y OR N.
     C                   ENDIF
     C                   ENDIF
      *
      * CANNOT BE 'E' IF EMAIL IS NOT SET UP
      *
     C     EALLOW        IFNE      'Y'
     C     ARFL50        IFEQ      'E'                                          EMAIL
     C                   MOVE      *ON           *IN50                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(54)       MSGFLD                         NO EMAIL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     EMAIL         IFEQ      *BLANKS                                      EMAIL
     C     ARFL50        IFEQ      'E'
     C                   MOVE      *ON           *IN50                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                                  ANKS
     C                   MOVE      EMS(55)       MSGFLD                                     BE ZERO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
¢D   C     ARFL50        IFEQ      'Y'                                          CONSOLID FAX /= Y
¢D   C     ARCDE7        ANDEQ     '1'                                          Invprt not fax
¢D   C     ARFL50        OREQ      'Y'                                          CONSOLID FAX /= Y
¢D   C     ARCDE7        ANDEQ     '0'                                          invprt not fax
¢D   C                   MOVE      *ON           *IN50                          DSPATR(RI PC)
¢D   C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
¢D   C                   MOVE      CMS(1)        MSGFLD                         ENTER Y OR N.
¢D   C                   ENDIF
¢D   C                   ENDIF
   CA *
   CA * TRANSLATE/EDIT PRINT PRICE SELECTION
   CA *
   CAC*                  MOVE      '0'           ARCDB7
   CAC*    PP1           IFNE      ' '
   CAC*                  MOVE      '1'           ARCDB7
   CAC*                  ENDIF
   CAC*    PP2           IFNE      ' '
   CAC*    ARCDB7        IFEQ      '0'
   CAC*                  MOVE      '2'           ARCDB7
   CAC*                  ELSE
   CAC*                  MOVE      *ON           *IN38                          DSPATR(RI PC)
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(21)       MSGFLD
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*    PP3           IFNE      ' '
   CAC*    ARCDB7        IFEQ      '0'
   CAC*                  MOVE      '3'           ARCDB7
   CAC*                  ELSE
   CAC*                  MOVE      *ON           *IN38                          DSPATR(RI PC)
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(21)       MSGFLD
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*    PP4           IFNE      ' '
   CAC*    ARCDB7        IFEQ      '0'
   CAC*                  MOVE      '4'           ARCDB7
   CAC*                  ELSE
   CAC*                  MOVE      *ON           *IN38                          DSPATR(RI PC)
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(21)       MSGFLD
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*    PP5           IFNE      ' '
   CAC*    ARCDB7        IFEQ      '0'
   CAC*                  MOVE      '5'           ARCDB7
   CAC*                  ELSE
   CAC*                  MOVE      *ON           *IN38                          DSPATR(RI PC)
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(21)       MSGFLD
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CA *
   CA * IF NOT FAXING SALES ORDER OR INVOICE
   CA * PRINT PRICES CANNOT BE '2' OR '4' IF FAX/EMAIL IS NOT 'F'.
   CA *
   CAC*    ARFL72        IFNE      'F'                                          FAX S/O ACK
   CAC*    ARFL04        ANDNE     '2'                                          FAX INVC
   CAC*    ARFL04        ANDNE     '4'                                          FAX & PRT INVC
   CAC*    ARCDB7        IFEQ      '2'                                          FAX
   CAC*    ARCDB7        OREQ      '4'                                          BOTH
   CAC*                  MOVE      *ON           *IN38                          RI/PC
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(39)       MSGFLD                         FAX P/T MUST BE Y
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CA * IF NOT EMAILING SALES ORDER OR INVOICE
   CA * PRINT PRICES CANNOT BE '3' OR '5' IF FAX/EMAIL IS NOT 'E'.
   CA *
   CAC*    ARFL72        IFNE      'E'                                          FAX S/O ACK
   CAC*    ARFL04        ANDNE     '3'                                          FAX INVC
   CAC*    ARFL04        ANDNE     '5'                                          FAX & PRT INVC
   CAC*    ARCDB7        IFEQ      '3'                                          FAX
   CAC*    ARCDB7        OREQ      '5'                                          BOTH
   CAC*                  MOVE      *ON           *IN38                          RI/PC
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(51)       MSGFLD                         FAX P/T MUST BE Y
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CA *
   CA * IF NOT FAXING SALES ORDER OR INVOICE
   CA * PRINT PRICES CANNOT BE '2' OR '4' IF FAX/EMAIL IS NOT 'F'.
   CA *
   CAC*    ARFL72        IFNE      'F'                                          FAX S/O ACK
   CAC*    ARCDE7        ANDNE     '2'                                          FAX INVC
   CAC*    ARCDE7        ANDNE     '4'                                          FAX & PRT INVC
   CAC*    ARCDB7        IFEQ      '2'                                          FAX
   CAC*    ARCDB7        OREQ      '4'                                          BOTH
   CAC*                  MOVE      *ON           *IN38                          RI/PC
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(39)       MSGFLD                         FAX P/T MUST BE Y
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CA * IF NOT EMAILING SALES ORDER OR INVOICE
   CA * PRINT PRICES CANNOT BE '3' OR '5' IF FAX/EMAIL IS NOT 'E'.
   CA *
   CAC*    ARFL72        IFNE      'E'                                          FAX S/O ACK
   CAC*    ARCDE7        ANDNE     '3'                                          FAX INVC
   CAC*    ARCDE7        ANDNE     '5'                                          FAX & PRT INVC
   CAC*    ARCDB7        IFEQ      '3'                                          FAX
   CAC*    ARCDB7        OREQ      '5'                                          BOTH
   CAC*                  MOVE      *ON           *IN38                          RI/PC
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(51)       MSGFLD                         FAX P/T MUST BE Y
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CA *
   CA * TRANSLATE/EDIT PRINT NET PRICE SELECTION
   CA *
   CAC*                  MOVE      '0'           ARCDB8
   CAC*    PN1           IFNE      ' '
   CAC*                  MOVE      '1'           ARCDB8
   CAC*                  ENDIF
   CAC*    PN2           IFNE      ' '
   CAC*    ARCDB8        IFEQ      '0'
   CAC*                  MOVE      '2'           ARCDB8
   CAC*                  ELSE
   CAC*                  MOVE      *ON           *IN39                          DSPATR(RI PC)
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(21)       MSGFLD
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*    PN3           IFNE      ' '
   CAC*    ARCDB8        IFEQ      '0'
   CAC*                  MOVE      '3'           ARCDB8
   CAC*                  ELSE
   CAC*                  MOVE      *ON           *IN39                          DSPATR(RI PC)
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(21)       MSGFLD
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*    PN4           IFNE      ' '
   CAC*    ARCDB8        IFEQ      '0'
   CAC*                  MOVE      '4'           ARCDB8
   CAC*                  ELSE
   CAC*                  MOVE      *ON           *IN39                          DSPATR(RI PC)
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(21)       MSGFLD
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*    PN5           IFNE      ' '
   CAC*    ARCDB8        IFEQ      '0'
   CAC*                  MOVE      '5'           ARCDB8
   CAC*                  ELSE
   CAC*                  MOVE      *ON           *IN39                          DSPATR(RI PC)
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(21)       MSGFLD
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CA *
   CA * IF NOT FAXING SALES ORDER OR INVOICE
   CA * PRINT NET PRICES CANNOT BE '2' OR '4' IF FAX/EMAIL IS NOT 'F'.
   CA *
   CAC*    ARFL72        IFNE      'F'                                          FAX S/O ACK
   CAC*    ARFL04        ANDNE     '2'                                          FAX INVC
   CAC*    ARFL04        ANDNE     '4'                                          FAX & PRT INVC
   CAC*    ARCDB8        IFEQ      '2'                                          FAX
   CAC*    ARCDB8        OREQ      '4'                                          BOTH
   CAC*                  MOVE      *ON           *IN39                          RI/PC
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(39)       MSGFLD                         FAX P/T MUST BE Y
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CA * IF NOT EMAILING SALES ORDER OR INVOICE
   CA * PRINT NET PRICES CANNOT BE '3' OR '5' IF FAX/EMAIL IS NOT 'E'.
   CA *
   CAC*    ARFL72        IFNE      'E'                                          EMAIL S/O
   CAC*    ARFL04        ANDNE     '3'                                          FAX INVC
   CAC*    ARFL04        ANDNE     '5'                                          FAX & PRT INVC
   CAC*    ARCDB8        IFEQ      '3'                                          EMAIL
   CAC*    ARCDB8        OREQ      '5'                                          EMAIL & PRT
   CAC*                  MOVE      *ON           *IN39                          RI/PC
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(51)       MSGFLD                         FAX P/T MUST BE Y
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CA *
   CA * IF NOT FAXING SALES ORDER OR INVOICE
   CA * PRINT NET PRICES CANNOT BE '2' OR '4' IF FAX/EMAIL IS NOT 'F'.
   CA *
   CAC*    ARFL72        IFNE      'F'                                          FAX S/O ACK
   CAC*    ARCDE7        ANDNE     '2'                                          FAX INVC
   CAC*    ARCDE7        ANDNE     '4'                                          FAX & PRT INVC
   CAC*    ARCDB8        IFEQ      '2'                                          FAX
   CAC*    ARCDB8        OREQ      '4'                                          BOTH
   CAC*                  MOVE      *ON           *IN39                          RI/PC
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(39)       MSGFLD                         FAX P/T MUST BE Y
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
   CA * IF NOT EMAILING SALES ORDER OR INVOICE
   CA * PRINT NET PRICES CANNOT BE '3' OR '5' IF FAX/EMAIL IS NOT 'E'.
   CA *
   CAC*    ARFL72        IFNE      'E'                                          EMAIL S/O
   CAC*    ARCDE7        ANDNE     '3'                                          FAX INVC
   CAC*    ARCDE7        ANDNE     '5'                                          FAX & PRT INVC
   CAC*    ARCDB8        IFEQ      '3'                                          EMAIL
   CAC*    ARCDB8        OREQ      '5'                                          EMAIL & PRT
   CAC*                  MOVE      *ON           *IN39                          RI/PC
   CAC*    MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
   CAC*                  MOVE      EMS(51)       MSGFLD                         FAX P/T MUST BE Y
   CAC*                  ENDIF
   CAC*                  ENDIF
   CAC*                  ENDIF
CA    * PRINT PRICES
CA   C     ARCDB7        IFNE      'Y'                                          STATEMENT
CA   C     ARCDB7        ANDNE     'N'                                          PRINT CODE
CA   C     ARCDB7        ANDNE     ' '
CA   C                   MOVE      *ON           *IN38                          RI/PC
CA   C     MSGFLD        IFEQ      *BLANKS
CA   C                   MOVE      EMS(7)        MSGFLD                         ERROR OCCURED
CA   C                   ENDIF
CA   C                   ENDIF
CA    * PRINT NET PRICES
CA   C     ARCDB8        IFNE      'Y'                                          STATEMENT
CA   C     ARCDB8        ANDNE     'N'                                          PRINT CODE
CA   C     ARCDB8        ANDNE     ' '                                          PRINT CODE
CA   C                   MOVE      *ON           *IN39                          RI/PC
CA   C     MSGFLD        IFEQ      *BLANKS
CA   C                   MOVE      EMS(7)        MSGFLD                         ERROR OCCURED
CA   C                   ENDIF
CA   C                   ENDIF
C1    * PRINT TOTALS FOR CHARGE ORDER
C1   C     ARFL88        IFNE      'Y'                                          STATEMENT
C1   C     ARFL88        ANDNE     'N'                                          PRINT CODE
C1   C     ARFL88        ANDNE     ' '                                          PRINT CODE
C1   C                   MOVE      *ON           *IN40                          RI/PC
C1   C     MSGFLD        IFEQ      *BLANKS
C1   C                   EVAL      MSGFLD = 'Value must be -                    ERROR OCCURED
C1   C                             (''Y'', ''N'' or '' '').'                    ERROR OCCURED
C1   C                   ENDIF
C1   C                   ENDIF
      *
C2    * ALLOW PRICE OVERRIDES
C2   C     ARFL91        IFNE      'Y'                                          STATEMENT
C2   C     ARFL91        ANDNE     'N'                                          PRINT CODE
C2   C     ARFL91        ANDNE     ' '                                          PRINT CODE
C2   C                   MOVE      *ON           *IN42                          RI/PC
C2   C     MSGFLD        IFEQ      *BLANKS
C2   C                   EVAL      MSGFLD = 'Value must be -                    ERROR OCCURED
C2   C                             (''Y'', ''N'' or '' '').'                    ERROR OCCURED
C2   C                   ENDIF
C2   C                   ENDIF
      * MUST ENTER PRINT WEEKLY OR PRINT MONTHLY
      *
     C     ARFL52        IFEQ      ' '                                          PRINT WEEKLY
     C     ARFL61        ANDEQ     ' '                                          PRINT MONTHLY
     C                   MOVE      *ON           *IN52                          DSPATR(RI PC)
     C                   MOVE      *ON           *IN55                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(25)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      * BLANK OUT THE DAYS OF WEEK IF PRINT WEEKLY EQUAL TO ' '
     C     ARFL52        IFEQ      ' '
     C                   MOVE      ' '           ARFL54                         PRT ON SUN
     C                   MOVE      ' '           ARFL55                         PRT ON MON
     C                   MOVE      ' '           ARFL56                         PRT ON TUE
     C                   MOVE      ' '           ARFL57                         PRT ON WED
     C                   MOVE      ' '           ARFL58                         PRT ON THU
     C                   MOVE      ' '           ARFL59                         PRT ON FRI
     C                   MOVE      ' '           ARFL60                         PRT ON SAT
     C                   ENDIF
      *
      * BLANK OUT THE DAYS OF MONTH IF PRINT MONTHLY EQUAL TO ' '
      *
     C     ARFL61        IFEQ      ' '
     C                   Z-ADD     *ZERO         ARNOA7                         PRT ON FIRST DAY
     C                   Z-ADD     *ZERO         ARNOA8                         PRT ON SECOND DAY
     C                   Z-ADD     *ZERO         ARNOA9                         PRT ON THIRD DAY
     C                   ENDIF
      *
      * CANNOT ENTER BOTH PRINT WEEKLY AND PRINT MONTHLY
      *
     C     ARFL52        IFEQ      'D'                                          PRINT WEEKLY
     C     ARFL61        ANDNE     *BLANKS                                      PRINT MONTHLY
     C     ARFL52        OREQ      'W'                                          PRINT WEEKLY
     C     ARFL61        ANDNE     *BLANKS                                      PRINT MONTHLY
     C                   MOVE      *ON           *IN52                          DSPATR(RI PC)
     C                   MOVE      *ON           *IN55                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(23)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      * CANNOT ENTER BOTH PRINT ON DAY OF WEEK AND PRINT ON DAY OF MONTH
      *
     C     ARFL54        IFNE      *BLANKS                                      PRT ON SUN
     C     ARFL55        ORNE      *BLANKS                                      PRT ON MON
     C     ARFL56        ORNE      *BLANKS                                      PRT ON TUE
     C     ARFL57        ORNE      *BLANKS                                      PRT ON WED
     C     ARFL58        ORNE      *BLANKS                                      PRT ON THU
     C     ARFL59        ORNE      *BLANKS                                      PRT ON FRI
     C     ARFL60        ORNE      *BLANKS                                      PRT ON SAT
     C     ARNOA7        IFNE      *ZERO                                        PRT ON DAY 1
     C     ARNOA8        ORNE      *ZERO                                        PRT ON DAY 2
     C     ARNOA9        ORNE      *ZERO                                        PRT ON DAY 3
     C                   MOVEA     '111'         *IN(57)                        DSPATR(RI PC)
     C                   MOVEA     '11'          *IN(68)                        DSPATR(RI PC)
     C                   MOVE      *ON           *IN87                          DSPATR(RI PC)
     C                   MOVE      *ON           *IN89                          DSPATR(RI PC)
     C                   MOVE      *ON           *IN91                          DSPATR(RI PC)
     C                   MOVEA     '11'          *IN(93)                        DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(26)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * VALIDATE PRINT WEEKLY
      *
     C     *IN52         IFEQ      *OFF
     C     ARFL52        ANDNE     ' '
     C     ARFL52        IFNE      'D'                                          NOT PRINT DAILY
     C     ARFL52        ANDNE     'W'                                          NOT PRINT WEEKLY
     C                   MOVE      *ON           *IN52                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(22)       MSGFLD                         ENTER D OR W.
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * DEFAULT ALL X'S IF PRINT FREQUENCE EQUALS DAILY
     C     ARFL52        IFEQ      'D'
     C     ARFL54        IFEQ      *BLANKS
     C     ARFL55        OREQ      *BLANKS
     C     ARFL56        OREQ      *BLANKS
     C     ARFL57        OREQ      *BLANKS
     C     ARFL58        OREQ      *BLANKS
     C     ARFL59        OREQ      *BLANKS
     C     ARFL60        OREQ      *BLANKS
     C                   MOVE      'X'           ARFL54                         PRT ON SUN
     C                   MOVE      'X'           ARFL55                         PRT ON MON
     C                   MOVE      'X'           ARFL56                         PRT ON TUE
     C                   MOVE      'X'           ARFL57                         PRT ON WED
     C                   MOVE      'X'           ARFL58                         PRT ON THU
     C                   MOVE      'X'           ARFL59                         PRT ON FRI
     C                   MOVE      'X'           ARFL60                         PRT ON SAT
     C     ARFL52        CABEQ     'D'           DSPLYJ
     C                   ENDIF
     C                   ENDIF
      *
      * CANNOT SELECT ALL DAYS OF WEEK IF PRINT FREQUENCY EQUAL 'W'.
      *
     C     ARFL52        IFEQ      'W'
     C     ARFL54        IFNE      *BLANKS                                      PRT ON SUN
     C     ARFL55        ANDNE     *BLANKS                                      PRT ON MON
     C     ARFL56        ANDNE     *BLANKS                                      PRT ON TUE
     C     ARFL57        ANDNE     *BLANKS                                      PRT ON WED
     C     ARFL58        ANDNE     *BLANKS                                      PRT ON THU
     C     ARFL59        ANDNE     *BLANKS                                      PRT ON FRI
     C     ARFL60        ANDNE     *BLANKS                                      PRT ON SAT
     C                   MOVEA     '111'         *IN(57)                        DSPATR(RI PC)
     C                   MOVEA     '11'          *IN(68)                        DSPATR(RI PC)
     C                   MOVE      *ON           *IN87                          DSPATR(RI PC)
     C                   MOVE      *ON           *IN89                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(29)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * MUST SELECT DAYS OF WEEK IF PRINT FREQUENCY EQUAL 'W'.
      *
     C     ARFL52        IFEQ      'W'
     C     ARFL54        IFEQ      *BLANKS                                      PRT ON SUN
     C     ARFL55        ANDEQ     *BLANKS                                      PRT ON MON
     C     ARFL56        ANDEQ     *BLANKS                                      PRT ON TUE
     C     ARFL57        ANDEQ     *BLANKS                                      PRT ON WED
     C     ARFL58        ANDEQ     *BLANKS                                      PRT ON THU
     C     ARFL59        ANDEQ     *BLANKS                                      PRT ON FRI
     C     ARFL60        ANDEQ     *BLANKS                                      PRT ON SAT
     C                   MOVEA     '111'         *IN(57)                        DSPATR(RI PC)
     C                   MOVEA     '11'          *IN(68)                        DSPATR(RI PC)
     C                   MOVE      *ON           *IN87                          DSPATR(RI PC)
     C                   MOVE      *ON           *IN89                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(31)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * VALIDATE PRINT MONTHLY
      *
     C     ARFL61        IFNE      *BLANKS                                      PRINT MONTHLY
     C     ARFL61        IFNE      'M'                                          PRINT MONTHLY
     C                   MOVE      *ON           *IN55                          DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(30)       MSGFLD                         ENTER M FOR MONTHLY
     C                   ENDIF
     C                   ENDIF
      *
      * ENTER PRINT OF DAYS OF MONTH IF PRINT MONTHLY EQUAL 'M'
      *
     C     *IN55         IFEQ      *OFF
     C     ARFL61        ANDEQ     'M'
     C     ARNOA7        IFEQ      *ZERO                                        PRT ON DAY 1
     C     ARNOA8        ANDEQ     *ZERO                                        PRT ON DAY 2
     C     ARNOA9        ANDEQ     *ZERO                                        PRT ON DAY 3
     C                   MOVE      *ON           *IN91                          DSPATR(RI PC)
     C                   MOVEA     '11'          *IN(93)                        DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(27)       MSGFLD                                     .
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * CANNOT ENTER PRINT OF DAYS OF MONTH IF PRINT MONTHLY EQUAL ' '
      *
     C     ARFL61        IFEQ      ' '
     C     ARNOA7        IFNE      *ZERO                                        PRT ON DAY 1
     C     ARNOA8        ORNE      *ZERO                                        PRT ON DAY 2
     C     ARNOA9        ORNE      *ZERO                                        PRT ON DAY 3
     C                   MOVE      *ON           *IN91                          DSPATR(RI PC)
     C                   MOVEA     '11'          *IN(93)                        DSPATR(RI PC)
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(28)       MSGFLD                                     .
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * VALIDATE PRINT ON FIRST DAY OF MONTH
      *
     C     ARFL61        IFEQ      'M'
     C     ARNOA7        IFNE      *ZERO
     C     ARNOA7        IFLE      *ZERO
     C     ARNOA7        ORGT      31
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(32)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * MUST ENTER FIRST DAY OF MONTH PRIOR TO SECOND DAY OF MONTH
      *
     C     ARNOA8        IFNE      *ZERO
     C     ARNOA7        IFEQ      *ZERO
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(35)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      * VALIDATE PRINT ON SECOND DAY OF MONTH
      *
     C     ARNOA8        IFLE      *ZERO
     C     ARNOA8        ORGT      31
     C                   MOVE      *ON           *IN93
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(32)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * MUST ENTER FIRST DAY OF MONTH PRIOR TO THIRD DAY OF MONTH
      *
     C     ARNOA9        IFNE      *ZERO
     C     ARNOA7        IFEQ      *ZERO
     C                   MOVE      *ON           *IN91
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(33)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      * MUST ENTER SECOND DAY OF MONTH PRIOR TO THIRD DAY OF MONTH
      *
     C     ARNOA8        IFEQ      *ZERO
     C                   MOVE      *ON           *IN93
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(34)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      * VALIDATE PRINT ON THIRD DAY OF MONTH
     C     ARNOA9        IFLE      *ZERO
     C     ARNOA9        ORGT      31
     C                   MOVE      *ON           *IN94
     C     MSGFLD        IFEQ      *BLANKS                                      MESSAGE = BLANKS
     C                   MOVE      EMS(32)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * CHECK FOR ERROR MESSAGES
      *
     C     MSGFLD        IFNE      *BLANKS
     C                   MOVE      'Y'           S15JER
     C                   ELSE
     C                   MOVE      ' '           S15JER
     C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       DSPLYJ
      *
      * VALIDATE LOCK FIELDS...
      *
     C                   SELECT
     C     ARFL41        WHENNE    'Y'
     C     ARFL41        ANDNE     'N'
     C     ARFL41        ANDNE     ' '
     C                   MOVE      *ON           *IN62
     C                   MOVE      EMS(7)        MSGFLD
     C     ARFL42        WHENNE    'Y'
     C     ARFL42        ANDNE     'N'
     C     ARFL42        ANDNE     ' '
     C                   MOVE      *ON           *IN97
     C                   MOVE      EMS(7)        MSGFLD
     C     ARFL73        WHENNE    'Y'
     C     ARFL73        ANDNE     'N'
     C     ARFL73        ANDNE     ' '
     C                   MOVE      *ON           *IN84
     C                   MOVE      EMS(7)        MSGFLD
     C     ARFL63        WHENNE    'Y'
     C     ARFL63        ANDNE     'N'
     C     ARFL63        ANDNE     ' '
     C                   MOVE      *ON           *IN35
     C                   MOVE      EMS(7)        MSGFLD
     C     ARFL40        WHENNE    'Y'
     C     ARFL40        ANDNE     'N'
     C     ARFL40        ANDNE     ' '
     C                   MOVE      *ON           *IN61
     C                   MOVE      EMS(7)        MSGFLD
     C     ARFL64        WHENNE    'Y'
     C     ARFL64        ANDNE     'N'
     C     ARFL64        ANDNE     ' '
     C                   MOVE      *ON           *IN83
     C                   MOVE      EMS(7)        MSGFLD
     C     ARFL65        WHENNE    'Y'
     C     ARFL65        ANDNE     'N'
     C     ARFL65        ANDNE     ' '
     C                   MOVE      *ON           *IN51
     C                   MOVE      EMS(7)        MSGFLD
     C     ARFL33        WHENNE    'Y'
     C     ARFL33        ANDNE     'N'
     C     ARFL33        ANDNE     ' '
     C                   MOVE      *ON           *IN66
     C                   MOVE      EMS(7)        MSGFLD
     C     ARFL43        WHENNE    'Y'
     C     ARFL43        ANDNE     'N'
     C     ARFL43        ANDNE     ' '
     C                   MOVE      *ON           *IN98
     C                   MOVE      EMS(7)        MSGFLD
C1   C     ARFL89        WHENNE    'Y'
C1   C     ARFL89        ANDNE     'N'
C1   C     ARFL89        ANDNE     ' '
C1   C                   MOVE      *ON           *IN41
C1   C                   EVAL      MSGFLD = 'Value must be -                    ERROR OCCURED
C1   C                             (''Y'', ''N'' or '' '').'                    ERROR OCCURED
C2   C     ARFL93        WHENNE    'Y'
C2   C     ARFL93        ANDNE     'N'
C2   C     ARFL93        ANDNE     ' '
C2   C                   MOVE      *ON           *IN43
C2   C                   EVAL      MSGFLD = 'Value must be -                    ERROR OCCURED
C2   C                             (''Y'', ''N'' or '' '').'                    ERROR OCCURED
     C     ARFL66        WHENNE    'Y'
     C     ARFL66        ANDNE     'N'
     C     ARFL66        ANDNE     ' '
     C                   MOVE      *ON           *IN54
     C                   MOVE      EMS(7)        MSGFLD
     C     ARFL67        WHENNE    'Y'
     C     ARFL67        ANDNE     'N'
     C     ARFL67        ANDNE     ' '
     C                   MOVE      *ON           *IN56
     C                   MOVE      EMS(7)        MSGFLD
      *
     C                   ENDSL
      *
      * CHECK FOR ERROR MESSAGES
      *
     C     MSGFLD        IFNE      *BLANKS
     C                   MOVE      'Y'           S15JER
     C                   ELSE
     C                   MOVE      ' '           S15JER
     C                   ENDIF
      *
     C     MSGFLD        CABNE     *BLANKS       DSPLYJ
      *
      * WARN USER IF ENTERPRISE VALUES DO NOT MATCH CUSTOMER VALUES
      * AND NOT LOCKED.
      *
     C     ARNO82        IFNE      0
     C     WRNFLG        IFNE      'Y'
     C     ARFL41        IFNE      'Y'
     C     ARFL81        ANDNE     ' '
     C     ARFL81        ANDNE     ARFL04
     C                   MOVE      *ON           *IN86
     C                   MOVE      'Y'           WRNFLG            1
     C                   ENDIF
     C     ARFL42        IFNE      'Y'
     C     ARCDD6        ANDNE     ' '
     C     ARCDD6        ANDNE     ARCD29
     C                   MOVE      *ON           *IN85
     C                   MOVE      'Y'           WRNFLG
     C                   ENDIF
     C     ARFL73        IFNE      'Y'
     C     ARFL74        ANDNE     ' '
     C     ARFL74        ANDNE     ARFL72
     C                   MOVE      *ON           *IN81
     C                   MOVE      'Y'           WRNFLG
     C                   ENDIF
     C     ARFL63        IFNE      'Y'
     C     ARCDE8        ANDNE     ' '
     C     ARCDE8        ANDNE     ARCDE7
     C                   MOVE      *ON           *IN34
     C                   MOVE      'Y'           WRNFLG            1
     C                   ENDIF
     C     ARFL40        IFNE      'Y'
     C     ARNO90        ANDNE     *ZERO
     C     ARNO90        ANDNE     ARNO05
     C                   MOVE      *ON           *IN96
     C                   MOVE      'Y'           WRNFLG            1
     C                   ENDIF
     C     ARFL64        IFNE      'Y'
     C     ARFL49        ANDNE     ' '
     C     ARFL49        ANDNE     ARFL48
     C                   MOVE      *ON           *IN60
     C                   MOVE      'Y'           WRNFLG            1
     C                   ENDIF
     C     ARFL65        IFNE      'Y'
     C     ARFL51        ANDNE     ' '
     C     ARFL51        ANDNE     ARFL50
     C                   MOVE      *ON           *IN50
     C                   MOVE      'Y'           WRNFLG            1
     C                   ENDIF
     C     ARFL33        IFNE      'Y'
     C     ARCDD4        ANDNE     ' '
     C     ARCDD4        ANDNE     ARCDB7
     C                   MOVE      *ON           *IN38
     C                   MOVE      'Y'           WRNFLG
     C                   ENDIF
     C     ARFL43        IFNE      'Y'
     C     ARCDD5        ANDNE     ' '
     C     ARCDD5        ANDNE     ARCDB8
     C                   MOVE      *ON           *IN39
     C                   MOVE      'Y'           WRNFLG
     C                   ENDIF
C1   C     ARFL89        IFNE      'Y'
C1   C     ARFL90        ANDNE     ' '
C1   C     ARFL90        ANDNE     ARFL88
C1   C                   MOVE      *ON           *IN40
C1   C                   MOVE      'Y'           WRNFLG
C1   C                   ENDIF
C2   C     ARFL93        IFNE      'Y'
C2   C     ARFL94        ANDNE     ' '
C2   C     ARFL94        ANDNE     ARFL91
C2   C                   MOVE      *ON           *IN42
C2   C                   MOVE      'Y'           WRNFLG
C2   C                   ENDIF
     C     ARFL66        IFNE      'Y'
     C     EFL52         ANDNE     ' '
     C     EFL52         ANDNE     ARFL52
     C                   MOVE      *ON           *IN52
     C                   MOVE      'Y'           WRNFLG
     C                   ENDIF
     C     ARFL67        IFNE      'Y'
     C     EFL61         ANDNE     ' '
     C     EFL61         ANDNE     ARFL61
     C                   MOVE      *ON           *IN55
     C                   MOVE      'Y'           WRNFLG
     C                   ENDIF
      *
     C     WRNFLG        IFEQ      'Y'
     C                   MOVE      EMS(9)        MSGFLD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     MSGFLD        IFNE      *BLANKS
     C                   MOVE      'Y'           S15JER
     C                   ELSE
     C                   MOVE      ' '           S15JER
     C                   ENDIF
      *
      * CHECK FOR ANY MESSAGES
      *
     C     MSGFLD        CABNE     *BLANKS       DSPLYJ
      *
      * DISPLAY FAX INFORMATION WINDOW - FIRST TIME ONLY
     C     DSPFAX        IFEQ      'Y'                                          F9=FAX INFO
     C     *IN33         ANDEQ     *ON
     C     ARCDE7        IFEQ      '2'
     C     ARCDE7        OREQ      '4'
     C     ARFL04        OREQ      '2'
     C     ARFL04        OREQ      '4'
     C                   EXSR      @CURSR
     C                   MOVE      ARNO01        CUSNBR
     C                   MOVE      *BLANKS       CUSNAM
     C                   MOVEL     ARNM01        CUSNAM
     C                   MOVE      *BLANKS       FAXNBR
     C                   MOVEL     FAXNUM        FAXNBR
     C                   MOVE      ARCDB3        OPTION
     C                   CALL      'OPR0310'     PL0310
     C                   EXSR      @CLCSR
     C                   MOVE      'N'           DSPFAX
     C     DSPFAX        CABEQ     'N'           DSPLYJ
     C                   ENDIF
     C                   ENDIF
      *
      * DEFAULT ENTERPRISE VALUES IF CUSTOMER VALUES NOT LOCKED
     C     ARNO82        IFNE      0
     C     ARFL41        IFNE      'Y'
     C     ARFL81        ANDNE     ' '
     C                   MOVE      ARFL81        ARFL04
     C                   ENDIF
     C     ARFL42        IFNE      'Y'
     C     ARCDD6        ANDNE     ' '
     C                   MOVE      ARCDD6        ARCD29
     C                   ENDIF
     C     ARFL73        IFNE      'Y'
     C     ARFL74        ANDNE     ' '
     C                   MOVE      ARFL74        ARFL72
     C                   ENDIF
     C     ARFL63        IFNE      'Y'
     C     ARCDE8        ANDNE     ' '
     C                   MOVE      ARCDE8        ARCDE7
     C                   ENDIF
     C     ARFL40        IFNE      'Y'
     C     ARNO90        ANDNE     *ZERO
     C                   MOVE      ARNO90        ARNO05
     C                   ENDIF
     C     ARFL64        IFNE      'Y'
     C     ARFL49        ANDNE     ' '
     C                   MOVE      ARFL49        ARFL48
     C                   ENDIF
     C     ARFL65        IFNE      'Y'
     C     ARFL51        ANDNE     ' '
     C                   MOVE      ARFL51        ARFL50
     C                   ENDIF
     C     ARFL33        IFNE      'Y'
     C     ARCDD4        ANDNE     ' '
     C                   MOVE      ARCDD4        ARCDB7
     C                   ENDIF
     C     ARFL43        IFNE      'Y'
     C     ARCDD5        ANDNE     ' '
     C                   MOVE      ARCDD5        ARCDB8
     C                   ENDIF
C1   C     ARFL89        IFNE      'Y'
C1   C     ARFL90        ANDNE     ' '
C1   C                   MOVE      ARFL90        ARFL88
C1   C                   ENDIF
C2   C     ARFL93        IFNE      'Y'
C2   C     ARFL94        ANDNE     ' '
C2   C                   MOVE      ARFL94        ARFL91
C2   C                   ENDIF
     C     ARFL66        IFNE      'Y'
     C     EFL52         ANDNE     ' '
     C                   MOVE      EFL52         ARFL52
     C                   MOVE      EFL61         ARFL61
     C                   MOVE      EFL54         ARFL54
     C                   MOVE      EFL55         ARFL55
     C                   MOVE      EFL56         ARFL56
     C                   MOVE      EFL57         ARFL57
     C                   MOVE      EFL58         ARFL58
     C                   MOVE      EFL59         ARFL59
     C                   MOVE      EFL60         ARFL60
     C                   Z-ADD     *ZERO         ARNOA7
     C                   Z-ADD     *ZERO         ARNOA8
     C                   Z-ADD     *ZERO         ARNOA9
     C                   ENDIF
     C     ARFL67        IFNE      'Y'
     C     EFL61         ANDNE     ' '
     C                   MOVE      EFL61         ARFL61
     C                   MOVE      EFL52         ARFL52
     C                   MOVE      *BLANKS       ARFL54
     C                   MOVE      *BLANKS       ARFL55
     C                   MOVE      *BLANKS       ARFL56
     C                   MOVE      *BLANKS       ARFL57
     C                   MOVE      *BLANKS       ARFL58
     C                   MOVE      *BLANKS       ARFL59
     C                   MOVE      *BLANKS       ARFL60
     C                   Z-ADD     ENOA7         ARNOA7
     C                   Z-ADD     ENOA8         ARNOA8
     C                   Z-ADD     ENOA9         ARNOA9
     C                   ENDIF
     C                   ENDIF
      * PREVIOUS
     C     *IN12         CABEQ     *ON           ENDPRT                         CMD 12 PREVIOUS
      *
      * IF F10= UPDATE PRESSED,
      *    ENSURE NO ERROR EXIST ON ANY SCREEN
      *    SET F10 UPDATE FLAG TO YES
     C     *IN10         IFEQ      '1'
     C     ADDCUS        ANDEQ     'N'
     C                   SELECT
     C     SCRNER        WHENNE    *BLANKS
     C                   MOVE      UMS(3)        MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPLYJ
     C                   OTHER
     C                   MOVE      'Y'           F10FLG
     C                   ENDSL
     C                   ENDIF
      *
      *
     C     ENDPRT        TAG
     C                   MOVE      SVIN34        *IN34
     C                   MOVE      SVIN35        *IN35
     C                   MOVE      IN38SV        *IN38
     C                   MOVE      SVIN39        *IN39
C1   C                   MOVE      SVIN40        *IN40
C1   C                   MOVE      SVIN41        *IN41
C2   C                   MOVE      SVIN42        *IN42
C2   C                   MOVE      SVIN43        *IN43
     C                   MOVE      SVIN50        *IN50
     C                   MOVE      SVIN51        *IN51
     C                   MOVE      SVIN52        *IN52
     C                   MOVE      SVIN54        *IN54
     C                   MOVE      SVIN55        *IN55
     C                   MOVE      SVIN56        *IN56
     C                   MOVE      SVIN57        *IN57
     C                   MOVE      SVIN58        *IN58
     C                   MOVE      SVIN59        *IN59
     C                   MOVE      SVIN60        *IN60
     C                   MOVE      SVIN61        *IN61
     C                   MOVE      SVIN62        *IN62
     C                   MOVE      SVIN66        *IN66
     C                   MOVE      SVIN68        *IN68
     C                   MOVE      SVIN69        *IN69
DQ   C                   MOVE      SVIN72        *IN72
     C                   MOVE      SVIN81        *IN81
     C                   MOVE      SVIN83        *IN83
     C                   MOVE      SVIN84        *IN84
     C                   MOVE      SVIN85        *IN85
     C                   MOVE      SVIN86        *IN86
     C                   MOVE      SVIN87        *IN87
     C                   MOVE      SVIN89        *IN89
     C                   MOVE      SVIN91        *IN91
     C                   MOVE      SVIN93        *IN93
     C                   MOVE      SVIN94        *IN94
     C                   MOVE      SVIN96        *IN96
     C                   MOVE      SVIN97        *IN97
     C                   MOVE      SVIN98        *IN98
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    PRICING/CREDIT INFORMATION                              *
      *------------------------------------------------------------------------*
     C     PRCCRD        BEGSR
     C                   Z-ADD     ARAM01        HDAM01            9 2          DID IT CHANG
     C                   MOVE      *IN38         SVIN38            1            SAVE *IN38
DU   C                   MOVE      *IN36         SVIN36            1            SAVE *IN36
DU   C                   MOVE      *OFF          *IN36
DU   C                   if        card_interface = 'Y'
DU   C                   MOVE      *ON           *IN36
DU   C                   endif
¢t   C                   MOVE      *IN35         SVIN35
¢t   C                   MOVE      *IN82         SVIN82            1
¢6   C                   MOVE      *IN87         SVIN87            1
¢6   C                   MOVE      *IN88         SVIN88            1
¢6   C                   MOVE      *IN89         SVIN89            1
¢G         // save indicator from prior state
¢G         saveIndicatorIN25 = *in25;
¢G         // set this to *off
¢G         reset *in25;
¢G         reset AllowResideo;
¢G   C                   MOVE      USRNM         USER
¢G   C                   MOVE      'AR'          APP
¢G   C                   MOVE      'CRED'        CDE
¢G   C                   Z-ADD     9000          IDNUM
¢G   C                   MOVE      *BLANKS       USRVAL
¢G   C                   MOVE      *BLANKS       VALFRM
¢G   C                   MOVE      *BLANKS       RTNCOD
¢G   C                   CALL      'OPR8220'     PL8220
¢G   C     RTNCOD        IFEQ      '0'
¢G   C                   MOVEL     USRVAL        AllowResideo
¢G   C                   ENDIF
¢G    *
¢G                       if AllowResideo = 'Y';
¢G                        *in25 = *on;
¢G                       endif;

     C     ADDCUS        IFEQ      'Y'                                          NEW CUSTOMERN
     C                   MOVE      'N'           OEFL18                         CHG INV PRT?
     C                   END
     C                   CLEAR                   WRNFLG
     C                   MOVE      'N'           F3WRN
      * IF THE CUSTOMER DOES NOT BELONG TO A CASH ACCOUNT ENTERPRISE
      * AND THE CUSTOMER IS A CHARGE CUSTOMER, CLEAR THE GENERIC CASH
      * FIELD...
     C     PRCASH        IFNE      'Y'
     C     ARCD21        ANDEQ     'R'
     C                   MOVE      ' '           ARCDC4                         GENERIC CASH=N
     C                   ENDIF
     C     DSPLY2        TAG
     C                   MOVE      ARCDF9        SVCDF9
     C                   MOVE      *BLANKS       TRMDSC                         TERM CODE DESC
     C                   MOVE      *ON           *IN37
     C     ARCDF9        IFNE      *BLANKS
     C     ARCDF9        CHAIN     ARFMTRH                            42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      *OFF          *IN37
     C                   MOVE      ARDN06        TRMDSC                         TERM DESC
     C                   ENDIF
     C                   ENDIF
      *
      * default in matrix price when adding customers
¢6   c     addcus        ifeq      'Y'
$O   C                   Exsr      ACCTMXSR
¢6 $OC*                  MOVE      '6'           PRCLV1                         FIRST TIME THRU
¢6 $OC*                  MOVE      '6'           PRCLV2                         FIRST TIME THRU
¢6 $OC*                  MOVE      '6'           PRCLV3                         FIRST TIME THRU
¢6 $OC*                  MOVE      '6'           PRCLV4                         FIRST TIME THRU
¢6 $OC*                  MOVE      '6'           PRCLV5                         FIRST TIME THRU
¢6   c                   end
     C                   EXFMT     ARF5015C
     C                   MOVEA     '0'           *IN(99)                        ERROR OCCURED
     C                   MOVEA     '00000'       *IN(61)
     C                   MOVE      *OFF          *IN51
     C                   MOVE      *OFF          *IN97
     C                   MOVE      *OFF          *IN29
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN86
     C                   MOVE      *OFF          *IN81
¢7   C                   MOVE      *OFF          *IN84
   DUC*                  MOVE      *OFF          *IN36
     C                   MOVE      *OFF          *IN37
     C                   MOVE      *OFF          *IN72
     C                   MOVE      *OFF          *IN74
     C                   MOVE      *OFF          *IN79
     C                   MOVE      *OFF          *IN95
¢6   C                   MOVE      *OFF          *IN87
¢6   C                   MOVE      *OFF          *IN88
¢6   C                   MOVE      *OFF          *IN89
     C                   MOVE      'Y'           S15CUP
     C                   MOVE      *BLANKS       MSGFLD                         MESSAGE FIELD
     C     ARCDF9        IFNE      SVCDF9
     C                   CLEAR                   WRNFLG
     C                   ENDIF
CJ   C     f3flg         ifeq      'Y'
CJ   C     *in03         ifeq      *on
CJ   C                   move      '0'           *in03
CJ   C     msgfld        ifeq      *blanks
CJ   C                   move      ems(63)       msgfld
CJ   C                   endif
CJ   C                   goto      dsply2
CJ   C                   endif
CJ   C     *in10         ifeq      *on
CJ   C                   move      '0'           *in10
CJ   C     msgfld        ifeq      *blanks
CJ   C                   move      ems(64)       msgfld
CJ   C                   endif
CJ   C                   goto      dsply2
CJ   C                   endif
CJ   C                   endif
     C     *IN03         IFEQ      *OFF
     C                   MOVE      'N'           F3WRN
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     UMS(5)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      DSPLY2
     C                   ENDIF
     C                   GOTO      ENDPGM
     C                   ENDIF
     C     *IN25         IFEQ      '1'                                          CMD KEY HELP
     C                   CALL      'HTR0010'                                    HELP TEXT
     C                   PARM                    PROG                           PROGRAM
     C                   PARM                    SCREEN                         SCREEN
     C     *IN25         CABEQ     '1'           DSPLY2                         GO TO DISPLAY
     C                   END
      *
      * F4=PROMPT
     C     *IN04         IFEQ      *ON                                          PROMPT
     C                   EXSR      @PRMPT
     C                   ENDIF
     C     *IN04         CABEQ     *ON           DSPLY2
     C                   EXSR      @CLCSR
DU    *
DU    * F7=Display Card on file list
DU   C     *IN07         IFEQ      *ON                                          PROMPT
DU   C                   EVAL      PoToken   = *blanks
DU   C                   EVAL      PoExpcc   = *zeros
DU   C                   EVAL      PoExpyr   = *zeros
DU   C                   EVAL      PoExpmo   = *zeros
DU   C                   EVAL      PoName    = *blanks
DW   C                   EVAL      PoNetTrnID = *blanks
DU   C                   movel     arno01        cust_num
DU   C                   move      'C'           cust_type
DU   C                   move      'M'           COF_Mode
DU   C                   CALL      'OER9751'     PL9751
DU   C     *IN07         CABEQ     *ON           DSPLY2
DU   C                   ENDIF
DU    *
B4    * VALIDATE CHARGE/CASH
B4   C     ARCD21        IFNE      'C'
B4   C     ARCD21        ANDNE     'R'
B4   C                   MOVE      *ON           *IN54
B4   C                   MOVEL     UMS(8)        MSGFLD
B4   C     *IN54         CABEQ     *ON           DSPLY2
B4   C                   ENDIF
B4    *
      *
      * IF THE CUSTOMER BELONGS TO AN ENTERPRISE THAT IS CURRENTLY
      * SET TO A CASH ACCOUNT, THEN MAKE SURE CUSTOMER IS A CASH CUST..
     C     PRCASH        IFEQ      'Y'
     C     ARCD21        IFNE      'C'
     C                   MOVE      *ON           *IN54
     C                   MOVEL     EMS(10)       MSGFLD
     C     *IN54         CABEQ     *ON           DSPLY2
     C                   ENDIF
     C                   ENDIF
      *
      *
      * IF CHARGE ACCT, RE-INITIALIZE THE GENERIC CASH ACCT FIELDS
      *
     C     ARCD21        IFEQ      'R'                                          CHARGE ACCT
     C                   MOVE      ' '           ARCDC4                         GENERIC CASH ACCT
     C                   ENDIF
      *
      * IF GENERIC CASH ACCOUNT HAS BEEN CHANGED, DISPLAY WARNING
      * MESSAGE THAT CASH ORDERS EXIST FOR THIS ACCOUNT
      *
     C     ARCDC4        IFNE      SAVCD4                                       GENERIC CASH
     C                   MOVE      ARCDC4        SAVCD4                         SAVE GENERIC
     C     ARNO01        SETLL     OEFTOH                                 42
     C     *IN42         IFEQ      *OFF
     C     ARNO01        SETLL     OEFTOHY                                42
     C                   ENDIF
     C     *IN42         IFEQ      *ON
     C                   MOVEA     EMS(1)        MSGFLD                         WARNING - CASH
     C                   GOTO      DSPLY2
     C                   ENDIF
     C                   ENDIF
      *
     C     ARCDC4        IFEQ      'Y'                                          GENERIC CASH
     C     ARNO82        IFNE      0
     C                   MOVE      *ON           *IN29
     C                   MOVEL     EMS(11)       MSGFLD
     C     *IN29         CABEQ     *ON           DSPLY2
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      'V'           ZZFUNC
     C                   Z-ADD     OPNDAT        ZZDATE                         OPEN DATE
     C                   CALL      'UDR'         UDRPRM
     C     ZZFUNC        IFEQ      '*'
     C                   MOVEL     EMS(12)       MSGFLD
     C                   MOVE      *ON           *IN81
     C     *IN81         CABEQ     *ON           DSPLY2
     C                   ENDIF
     C                   Z-ADD     1             DATYP                          DATE TYPE
     C                   MOVE      ARYR02        DATE2                          YEAR ACCT OPEN
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      DACEN         ARCC02                         CENTURY ACCT OPEN
     C     CREDIT        IFEQ      'C'                                          CONSOLIDATED
     C     ARAM01        IFEQ      0                                            CREDIT LIMIT
     C                   MOVEA     '1'           *IN(80)                        ERROR MESSAGE
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     EMS(13)       MSGFLD
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   ENDIF
     C                   END
      * HOLD CUSTOMER
     C     SAVHLD        IFNE      'Y'                                          SAVE HOLD
     C     ARFL03        IFEQ      'Y'                                          HOLD ?
     C     CHECK         IFEQ      *BLANKS                                      CHECKED ?
     C                   ADD       1             ARCN01                         CNT CUST HELD
     C                   MOVE      'Y'           CHECK             1            HAS BEEN CHECKD
     C                   ENDIF
     C                   Z-ADD     DATE          DACHLD                         DATE HELD
     C                   END
     C                   ELSE
     C     ARFL03        IFNE      'Y'                                          HOLD ?
     C                   Z-ADD     0             DACHLD
     C                   END
     C                   END
     C                   END
      *
      * VALIDATE TERMS CODE
      *
     C     ARCDF9        IFNE      *BLANKS
     C     ARCDF9        CHAIN     ARFMTRH                            42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      *OFF          *IN37
     C                   MOVE      ARDN06        TRMDSC                         TERM DESC
     C                   ELSE
     C                   MOVE      *ON           *IN79
     C     *IN99         IFNE      *ON
     C                   MOVEL     EMS(56)       MSGFLD
     C                   MOVE      '1'           *IN99
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * TERMS CODE NOT ENTERED
      *
     C     ARCDF9        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN37
     C                   MOVE      *BLANKS       TRMDSC                         TERM CODE DESC
     C                   ENDIF
¢H   C     ARCDF9        IFEQ      *BLANKS
¢H   C     ARCD21        ANDEQ     'R'
¢H   C                   MOVE      *ON           *IN79
¢H   C     *IN99         IFNE      *ON
¢H   C                   MOVEL     CMS(3)        MSGFLD
¢H   C                   MOVE      '1'           *IN99
¢H   C                   ENDIF
¢H   C                   ENDIF
¢7    * VALIDATE Last Review Date FIELD
¢7   c     rvwdat        ifne      0
¢7   C                   MOVE      'V'           ZZFUNC
¢7   C                   Z-ADD     RVWDAT        ZZDATE                         OPEN DATE
¢7   C                   Z-ADD     20            ECCC01                         OPEN DATE
¢7   C                   CALL      'UDR'         UDRPRM
¢7   C     ZZFUNC        IFEQ      '*'
¢7   C                   MOVEL     CMS(12)       MSGFLD
¢7   C                   MOVE      *ON           *IN84
¢7   C     *IN84         CABEQ     *ON           DSPLY2
¢7   C                   ENDIF
¢7    * issue error if year keyed is > current year
¢7   C     ecyr01        ifgt      uyear
¢7   c                   movel     cms(13)       msgfld
¢7   c                   move      *on           *IN84
¢7   C     *IN84         CABEQ     *ON           DSPLY2
¢7   C                   else
¢7    * issue error if mth keyed is > to current mth
¢7   C     ecyr01        ifeq      uyear
¢7   c     ecmo01        andgt     umonth
¢7   c                   movel     cms(13)       msgfld
¢7   c                   move      *on           *in84
¢7   C     *IN84         CABEQ     *ON           DSPLY2
¢7   C                   ENDIF
¢7   C                   ENDIF
     c
¢7   C                   ENDIF
      *
      *
      * VALIDATE DISCOUNT PROFILE NUMBER
     C     PRNO03        IFNE      *BLANKS
     C     PRNO03        SETLL     PRFMDPH                                40
     C     *IN40         IFEQ      '0'
     C                   MOVEA     '1'           *IN(86)
     C     *IN99         IFNE      *ON
     C                   MOVEL     EMS(20)       MSGFLD
     C                   MOVEA     '1'           *IN(99)
     C                   ENDIF
     C                   END
     C                   END
¢t    * VALIDATE Price levels
¢t    * eqp price level
¢t   C     prclv1        IFNE      '1'
¢t   C     prclv1        andne     '2'
¢t   C     prclv1        andne     '3'
¢6   C     prclv1        andne     '4'
¢6   C     prclv1        andne     '5'
¢6   C     prclv1        andne     '6'
¢t   C     prclv1        andne     ' '
¢t   C                   MOVEA     '1'           *IN(82)
¢t   C     *IN99         IFNE      *ON
¢t   C                   MOVEL     CMS(7)        MSGFLD
¢t   C                   MOVEA     '1'           *IN(99)
¢t   C                   ENDIF
¢t   C                   END
¢t    * supplies price level
¢t   C     prclv2        IFNE      '1'
¢t   C     prclv2        andne     '2'
¢t   C     prclv2        andne     '3'
¢6   C     prclv2        andne     '4'
¢6   C     prclv2        andne     '5'
¢6   C     prclv2        andne     '6'
¢t   C     prclv2        andne     ' '
¢t   C                   MOVEA     '1'           *IN(35)
¢t   C     *IN99         IFNE      *ON
¢t   C                   MOVEL     CMS(7)        MSGFLD
¢t   C                   MOVEA     '1'           *IN(99)
¢t   C                   ENDIF
¢t   C                   END
¢6    * Parts price level
¢6   C     prclv3        IFNE      '1'
¢6   C     prclv3        andne     '2'
¢6   C     prclv3        andne     '3'
¢6   C     prclv3        andne     '4'
¢6   C     prclv3        andne     '5'
¢6   C     prclv3        andne     '6'
¢6   C     prclv3        andne     ' '
¢6   C                   MOVEA     '1'           *IN(87)
¢6   C     *IN99         IFNE      *ON
¢6   C                   MOVEL     CMS(7)        MSGFLD
¢6   C                   MOVEA     '1'           *IN(99)
¢6   C                   ENDIF
¢6   C                   END
¢6    * Tools price level
¢6   C     prclv4        IFNE      '1'
¢6   C     prclv4        andne     '2'
¢6   C     prclv4        andne     '3'
¢6   C     prclv4        andne     '4'
¢6   C     prclv4        andne     '5'
¢6   C     prclv4        andne     '6'
¢6   C     prclv4        andne     ' '
¢6   C                   MOVEA     '1'           *IN(88)
¢6   C     *IN99         IFNE      *ON
¢6   C                   MOVEL     CMS(7)        MSGFLD
¢6   C                   MOVEA     '1'           *IN(99)
¢6   C                   ENDIF
¢6   C                   END
¢6    * Commodities price level
¢6   C     prclv5        IFNE      '1'
¢6   C     prclv5        andne     '2'
¢6   C     prclv5        andne     '3'
¢6   C     prclv5        andne     '4'
¢6   C     prclv5        andne     '5'
¢6   C     prclv5        andne     '6'
¢6   C     prclv5        andne     ' '
¢6   C                   MOVEA     '1'           *IN(89)
¢6   C     *IN99         IFNE      *ON
¢6   C                   MOVEL     CMS(7)        MSGFLD
¢6   C                   MOVEA     '1'           *IN(99)
¢6   C                   ENDIF
¢6   C                   END
      * VALIDATE LOCK FIELDS...
     C                   SELECT
     C     CREDIT        WHENEQ    'C'                                          CONSOLIDATED
     C     ARFL76        ANDNE     'Y'
     C     ARFL76        ANDNE     'N'
     C     ARFL76        ANDNE     *BLANKS
     C                   MOVE      *ON           *IN95
     C     *IN99         IFNE      *ON
     C                   MOVE      *ON           *IN99
     C                   MOVE      EMS(7)        MSGFLD
     C                   ENDIF
     C     ARFL44        WHENNE    'Y'
     C     ARFL44        ANDNE     'N'
     C     ARFL44        ANDNE     ' '
     C                   MOVE      *ON           *IN97
     C     *IN99         IFNE      *ON
     C                   MOVE      *ON           *IN99
     C                   MOVE      EMS(7)        MSGFLD
     C                   ENDIF
      *
     C                   ENDSL
      *
      * WARN USER IF ENTERPRISE VALUES DO NOT MATCH CUSTOMER VALUES
      * AND NOT LOCKED.
      *
     C     ARNO82        IFNE      0                                            ENTERPRISE #
     C     WRNFLG        IFNE      'Y'
     C     CREDIT        IFEQ      'C'                                          CONSOLIDATED
     C     ARFL76        ANDNE     'Y'                                          CR HLD LOCK
     C     ARFL03        ANDNE     EPFL25
     C                   MOVE      *ON           *IN51
     C                   MOVE      'Y'           WRNFLG            1
     C                   ENDIF
     C     ARFL44        IFNE      'Y'                                          CR HLD LOCK
     C     ARCDE1        ANDNE     ARCD21
     C                   MOVE      *ON           *IN54
     C                   MOVE      'Y'           WRNFLG            1
     C                   ENDIF
     C     ARFL77        IFNE      'Y'
     C     CDF9          IFNE      ARCDF9
     C                   MOVE      *ON           *IN79
     C                   MOVE      'Y'           WRNFLG            1
     C                   ENDIF
     C                   ENDIF
      *
     C     WRNFLG        IFEQ      'Y'
     C     *IN99         IFNE      *ON
     C                   MOVE      EMS(9)        MSGFLD
     C                   MOVE      *ON           *IN99
     C                   ELSE
     C                   MOVE      ' '           WRNFLG
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           S15CER
     C                   ELSE
     C                   MOVE      ' '           S15CER
     C                   ENDIF
     C     *IN99         CABEQ     '1'           DSPLY2                         ERROR OCCURED ?
      *
      * DEFAULT ENTERPRISE VALUES IF CUSTOMER VALUES NOT LOCKED
      *
     C     ARFL44        IFNE      'Y'
     C     ARCDE1        ANDNE     *BLANKS
     C                   MOVE      ARCDE1        ARCD21
     C                   ENDIF
     C     ARNO82        IFNE      0
     C     CREDIT        IFEQ      'C'                                          CONSOLIDATED
     C     ARFL76        ANDNE     'Y'                                          CR HLD LOCK
     C                   MOVE      EPFL25        ARFL03                         CR HLD FLAG
     C                   ENDIF
     C     ARFL77        IFNE      'Y'
     C                   MOVE      CDF9          ARCDF9
     C                   MOVE      *BLANKS       TRMDSC                         TERM CODE DESC
     C                   MOVE      *ON           *IN37
     C     ARCDF9        IFNE      *BLANKS
     C     ARCDF9        CHAIN     ARFMTRH                            42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      *OFF          *IN37
     C                   MOVE      ARDN06        TRMDSC                         TERM DESC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      * UPDATE CUSTOMER
     C     ADDCUS        IFEQ      'N'                                          UPDATE CUST
     C                   MOVEL     ARFL03        SAVHLD
     C                   END
      * PREVIOUS
     C     *IN12         CABEQ     *ON           ENDPRC                         CMD 012 REVIOUS
      *
      * IF F10= UPDATE PRESSED,
      *    ENSURE NO ERROR EXIST ON ANY SCREEN
      *    SET F10 UPDATE FLAG TO YES
     C     *IN10         IFEQ      '1'
     C     ADDCUS        ANDEQ     'N'
     C                   SELECT
     C     SCRNER        WHENNE    *BLANKS
     C                   MOVE      UMS(3)        MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPLY2
     C                   OTHER
     C                   MOVE      'Y'           F10FLG
     C                   ENDSL
     C                   ENDIF
      *
     C     ENDPRC        TAG
     C                   MOVE      SVIN38        *IN38                          RESTOR *IN38
DU   C                   MOVE      SVIN36        *IN36                          RESTOR *IN38
¢t   C                   MOVE      SVIN35        *IN35                          RESTOR *IN38
¢t   C                   MOVE      SVIN82        *IN82                          RESTOR *IN38
¢6   C                   MOVE      SVIN87        *IN87                          RESTOR *IN87
¢6   C                   MOVE      SVIN88        *IN88                          RESTOR *IN88
¢6   C                   MOVE      SVIN89        *IN89                          RESTOR *IN89
¢G         // place *in5 back to prior state
¢G         *in25 = saveIndicatorIN25;
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    COMPANY INFORMATION                                     *
      *------------------------------------------------------------------------*
     C     CMPNY         BEGSR
     C                   MOVE      *IN58         IN58              1
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN39
CI   c                   eval      svIn83 = *in83
     C                   MOVE      'N'           F3WRN
¢W   C                   MOVE      *BLANKS       SVEPDID           3
     C     RCMD2         IFEQ      'Y'
     C                   Z-ADD     1             RRN
   DCC*    RRN           CHAIN     ARS5015F                           40
   DCC*    *IN40         IFEQ      '0'
DC   C     RRN           CHAIN(E)  ARS5015F
DC   C                   IF        %FOUND
     C                   UPDATE    ARS5015F
     C                   END
     C                   GOTO      CMDSP
     C                   END
      * INITIALIZE SUBFILE
     C     FRSTME        IFEQ      'Y'                                          FIRST TIME THRU
     C                   MOVE      'N'           FRSTME
     C                   MOVEA     '1'           *IN(73)                        CLEAR
     C                   Z-ADD     0             RN                4 0
     C                   WRITE     ARC5015F
     C                   MOVEA     '0'           *IN(73)                        SETOF CLEAR
     C                   Z-ADD     0             CONUM             3 0
      * LOAD CUSTOMER COMPANIES
     C     CONUM         SETLL     GLFMHDR
     C     *IN40         DOUEQ     '1'
     C                   READ      GLFMHDR                                40
     C                   Z-ADD     GLNO01        ARNO15                         COMPANY NO
      ***  CHECK COMPANY AUTHORIZATION.
     C     ALLOK         IFNE      'Y'
     C     ARNO15        LOOKUP    SEC                                    52
     C                   END
     C     *IN40         IFEQ      '0'
     C     *IN52         ANDEQ     '1'                                          AUTH OK
     C     GLFL03        ANDNE     'C'
     C     ARNO82        IFNE      0                                            ENTERPRISE
     C     ENTKEY        CHAIN     ARFEBAL                            46
     C     *IN46         IFEQ      *ON
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C     ADDCUS        IFEQ      'N'
     C     *IN53         DOUEQ     '0'
     C     BALKEY        CHAIN     ARFMBAL                            4153
     C                   END
     C     *IN41         IFEQ      '0'
     C                   Z-ADD     ARNO16        NO16                           BRANCH NO
     C                   MOVE      ARID01        ID01                           SALESPERSON ID
¢W   C                   MOVE      EPDSLS        EPDID                          SALESPERSON ID
     C                   MOVE      ARID05        ID05
CI   C                   MOVE      ARID08        ID08                           CSR user id
     C                   MOVE      ARFL14        FL14                           FINANCE CHG
     C                   Z-ADD     ARNO16        SVNO16                         BRANCH NO
     C                   MOVE      ARID01        SVID01                         SALESPERSON ID
     C                   MOVE      ARID05        SVID05                         CREDIT REP ID
CI   C                   MOVE      ARID08        SVID08                         CSR user rep
     C                   MOVE      ARFL14        SVFL14                         FINANCE CHG
     C                   MOVE      ' '           REOPEN                         OPEN
     C     CREDIT        IFEQ      'A'                                          CR BY CMPNY
     C                   MOVEL     CBFL76        FL76                           CR HOLD LOCK
     C                   MOVEL     CBFL76        SVFL76                         CR HOLD LOCK
     C                   Z-ADD     A01           AM01                           CR LIMIT
$H                        AM01H = AM01;
     C                   MOVE      F03           FL03                           CR HOLD
     C                   Z-ADD     A01           SVAM01                         CR LIMIT
     C                   MOVE      F03           SVFL03                         CR HOLD
     C                   END
     C     *IN31         IFEQ      '1'                                          CLS BY CMPNY
     C     ARFL17        IFEQ      'C'
     C                   MOVE      '1'           *IN32
     C                   MOVE      ARFL17        SVFL17
     C                   ELSE
     C                   MOVE      '0'           *IN32
     C                   MOVE      ' '           SVFL17
     C                   END
     C                   ELSE
     C                   MOVE      '0'           *IN32
     C                   MOVE      ' '           SVFL17
     C                   END
     C                   UPDATE    ARFMBAL
     C                   ELSE
     C                   Z-ADD     0             NO16                           BRANCH NO
     C                   MOVE      '   '         ID01                           SALESPERSON ID
¢W   C                   MOVE      '   '         EPDID                          SALESPERSON ID
     C                   MOVE      *BLANKS       ID05
CI   C                   MOVE      *BLANKS       ID08
     C                   MOVE      ' '           FL14                           FINANCE CHG
     C                   Z-ADD     0             SVNO16                         BRANCH NO
     C                   MOVE      '   '         SVID01                         SALESPERSON ID
     C                   MOVE      *BLANKS       SVID05                         CREDIT REP ID
CI   C                   MOVE      *BLANKS       SVID08                         CSR user rep id
     C                   MOVE      ' '           SVFL14                         FINANCE CHG
     C                   Z-ADD     0             AM01                           CR LIMIT
     C                   MOVE      ' '           FL03                           CR HOLD
     C                   CLEAR                   FL76                           CR HOLD LOCK
     C                   CLEAR                   SVFL76                         CR HOLD LOCK
     C                   MOVE      ' '           REOPEN                         CLOSE
     C                   Z-ADD     0             SVAM01                         CR LIMIT
     C                   MOVE      ' '           SVFL03                         CR HOLD
     C                   MOVE      ' '           SVFL17
     C                   END                                                    *IN41 IFEQ 1
     C                   END                                                    ADDCUS IFEQ N
CH   C                   MOVE      *BLANKS       WCLSBR            1
     C                   ADD       1             RN
     C                   WRITE     ARS5015F
     C                   END                                                    *IN40 IFEQ 0
     C                   END                                                    *IN40 DOUEQ 1
     C                   Z-ADD     RN            SVRN              4 0
     C                   END                                                    FRSTME IFEQ Y
      * DISPLAY COMPANIES
     C     CMDSP         TAG
     C     RNERR         IFNE      0
     C                   Z-ADD     RNERR         RN
     C                   ELSE
     C                   Z-ADD     1             RN
     C                   END
     C     SVRN          IFNE      0
     C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB& CNTL
     C                   ELSE
     C                   MOVEA     '0100'        *IN(75)                        DSPLY CTL ONLY
     C                   END
     C                   WRITE     ARF5015F                                     CMD KEY FORMAT
     C                   EXFMT     ARC5015F                                     CONTACTS
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN81
     C                   MOVE      *OFF          *IN82
CI   C                   eval      *in83 = *off
     C                   MOVE      *OFF          *IN90
     C                   MOVE      *OFF          *IN29
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVE      'N'           COMPNY            1            COMPANY EXIST ?
     C                   Z-ADD     0             RNERR             4 0
     C                   MOVE      'Y'           S15FUP
CJ   C     f3flg         ifeq      'Y'
CJ   C     *in03         ifeq      *on
CJ   C                   move      '0'           *in03
CJ   C     msgfld        ifeq      *blanks
CJ   C                   move      ems(63)       msgfld
CJ   C                   endif
CJ   C                   goto      cmdsp
CJ   C                   endif
CJ   C                   endif
     C     *IN03         IFEQ      *OFF
     C                   MOVE      'N'           F3WRN
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     UMS(5)        MSGFLD
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      CMDSP
     C                   ENDIF
     C                   GOTO      ENDPGM
     C                   ENDIF
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           CMDSP
     C                   END
      *
      * F4=PROMPT
      *
     C     *IN04         IFEQ      *ON
     C                   EXSR      @PRMPT
     C     *IN04         CABEQ     *ON           CMDSP
     C                   ENDIF
     C                   EXSR      @CLCSR
      * READ SUBFILE
     C     SVRN          CABEQ     0             CMEND                          NO RECORDS
     C     *IN42         DOUEQ     '1'
     C                   READC     ARS5015F                               42
     C     *IN42         IFEQ      '0'
     C     NO16          IFNE      0                                            BRANCH
$M    * Validate Sort Name hasn't changed since last verification
$M   C                   If        SvSrtName <> ARNM05
$M   C                   Exsr      SortNmSr
$M   C                   EndIf
$M    * Validate Sort Name Against Branch
$M   C                   IF        (NO16 = 500                                  Co 2 and bad srtnm
$M   C                             AND Hydros_Flg = 'N')
$M   C                             or (NO16 <> 500                              Co 1 and Hydros Srt
$M   C                             AND Hydros_Flg = 'Y')
$M   C                   MOVEA     '1'           *IN(99)
$M   C     MSGFLD        IFEQ      *BLANKS
$M   C                   MOVEA     CMS(15)       MSGFLD
$M   C                   Z-ADD     RN            RNERR
$M   C                   ENDIF
$M   C                   ENDIF
      *
      * CHECK IF BRANCH IS VALID
      *
     C     NO16          SETLL     ARFMBCH4                               49    BRANCH EXIST ?
     C     *IN49         IFEQ      *OFF                                         INVALID BRANCH
     C                   MOVE      *ON           *IN82
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(40)       MSGFLD
     C                   Z-ADD     RN            RNERR
     C                   ENDIF
     C                   ENDIF
      *
     C     BRKEY         SETLL     ARFMBCH                                40    BRANCH EXIST ?
     C     *IN40         IFEQ      '0'
     C                   MOVE      *ON           *IN82
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(41)       MSGFLD
     C                   Z-ADD     RN            RNERR
     C                   END
     C                   END
CH    * Give warning message if branch is closed...
CH   C     NO16          CHAIN     ARFMBCH4
CH   C                   IF        %FOUND(ARLMBCH4)
CH   C                             AND BR_ARFL16 = 'C'
CH   C                             AND WCLSBR <> 'Y'
CH   C                   MOVE      *ON           *IN82
CH   C                   IF        MSGFLD = *BLANKS
CH   C                   EVAL      MSGFLD = 'Warning!  This branch +
CH   C                             is closed.'
CH   C                   MOVE      'Y'           WCLSBR
CH   C                   Z-ADD     RN            RNERR
CH   C                   ENDIF
CH   C                   ENDIF
     C     CREDIT        IFEQ      'A'                                          BY COMPANY
     C                   CLEAR                   EBFL25
     C     ENTKEY        CHAIN     ARFEBAL                            44
     C                   ENDIF
     C     ID01          IFEQ      '   '                                        SALESPERSON
     C                   MOVEA     '1'           *IN(80)                        HIGHLITE ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(43)       MSGFLD
     C                   Z-ADD     RN            RNERR
     C                   END
     C                   ELSE
     C     SLKEY         SETLL     ARFMSLS                                40    SALESPERSON EXIST?
     C     *IN40         IFEQ      '0'
     C                   MOVE      *ON           *IN80
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(44)       MSGFLD
     C                   Z-ADD     RN            RNERR
     C                   END
     C                   END
     C                   END
¢W   C                   MOVE      EPDID         SVEPDID                        SALESPERSON
     C     ID05          IFNE      *BLANKS
     C                   MOVE      *BLANKS       CRDREP            1
     C     ID05          CHAIN     OPFMUPM                            40
     C     *IN40         IFEQ      *OFF
     C     OPCD11        ANDEQ     'I'
     C     OPCD12        ANDEQ     'A'
     C                   MOVE      OPUSER        USER
     C                   MOVE      'AR'          APP
     C                   MOVE      'CRED'        CDE
     C                   Z-ADD     1             IDNUM
     C                   MOVE      *BLANKS       USRVAL
     C                   MOVE      *BLANKS       VALFRM
     C                   MOVE      *BLANKS       RTNCOD
     C                   CALL      'OPR8220'     PL8220
     C     RTNCOD        IFEQ      '0'
     C                   MOVEL     USRVAL        CRDREP
     C                   ENDIF
     C                   ENDIF
     C     CRDREP        IFNE      'Y'
     C                   MOVE      *ON           *IN81
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(48)       MSGFLD
     C                   Z-ADD     RN            RNERR
     C                   ENDIF
     C                   ENDIF
¢I   C                   ELSE
¢I   C                   MOVE      *ON           *IN81
¢I   C     MSGFLD        IFEQ      *BLANKS
¢I   C                   MOVEA     EMS(48)       MSGFLD
¢I   C                   Z-ADD     RN            RNERR
¢I   C                   ENDIF
     C                   ENDIF
CI    *
CI    * Validate CSR user id
CI   c                   if        no16 <> 0
CS   c                             and id08 <> *blanks
CI   c                   eval      rtnCod = *blanks
CI   c                   eval      usrVal = *blanks
CI   c     id08          chain     opfmupm1
CI   c                   if        %found
CI   c                             and opcd11 = 'I'
CI   c                             and opcd12 = 'A'
CI   c                   eval      user = opUser
CI   c                   eval      app = 'OP'
CI   c                   eval      cde = 'CRM1'
CI   c                   eval      idNum = 1
CI   c                   eval      valFrm = *blanks
CI   c                   call      'OPR8220'     pl8220
CI   c                   endif
CI   c                   if        rtnCod <> '0'
CI   c                             or %subst(usrVal : 1) <> 'Y'
CI   c                   eval      *in83 = *on
CI   c                   if        msgFld = *blanks
CI   c                   eval      msgFld = ems(61)
CI   c                   endif
CI   c                   endif
CI   c                   endif
CI    *
     C     CREDIT        IFEQ      'A'                                          BY COMPANY
     C     AM01          IFLE      *ZERO
     C     AM01          IFEQ      0                                            CREDIT LIMIT
     C                   MOVEA     '1'           *IN(90)                        HIGHLITE ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(46)       MSGFLD
     C                   Z-ADD     RN            RNERR
     C                   END
     C                   ELSE
     C                   MOVEA     '1'           *IN(90)                        HIGHLITE ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(47)       MSGFLD
     C                   Z-ADD     RN            RNERR
     C                   ENDIF
     C                   END
     C                   ENDIF

$H         // check to see if credit amount has changed
$H         // if it has then process credit limits logic
$H         // bypass logic if F12 or F3 is pressed
$H         reset creditLimitChange;
$H         if AM01 <> AM01H and not(*in12) and not(*in03);
$H          creditLimitChange = *on;
$H          userName = USRNM;
$H
$H          clear usrval;
$H          clear valfrm;
$H          clear rtncod;
$H          app = 'AR';
$H          cde = 'WBUS';
$H          idnum = 9001;
$H          retrieveEnrollmentValue(userName:app:cde:idnum:usrval:
$H                                  valfrm:rtncod);
$H          myCreditLimit = %dec(USRVAL:9:0);
$H
$H          // at this point check the entered credit limit against the preset file value
$H          if AM01 > myCreditLimit and msgfld = *blanks;
$H           msgfld = %trim(CMS(14)) +
$H             ' (' + %trim(%editc(myCreditLimit:'J')) + ')';
$H           RNERR = RN;
$H           *in90 = *on;
$H          endif;
$H
$H         endif;

      * IF CUSTOMER BELONGS TO AN ENTERPRISE, VALIDATE CREDIT HOLD...
     C     ARNO82        IFNE      *ZEROS
     C     FL76          IFNE      'Y'                                          CR HLD LOCK
     C     FL76          ANDNE     'N'
     C     FL76          ANDNE     *BLANKS
     C                   MOVE      *ON           *IN29                          RI PC
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(7)        MSGFLD
     C                   Z-ADD     RN            RNERR
     C                   ENDIF
     C                   ENDIF
     C     FL76          IFNE      'Y'                                          CR HLD LOCK
     C     FL03          ANDNE     EBFL25                                       CREDIT HOLD
     C                   MOVE      *ON           *IN29                          RI PC
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(8)        MSGFLD
     C                   Z-ADD     RN            RNERR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   END
     C                   ELSE                                                   BRANCH
     C     ID01          IFNE      '   '                                        SALESPERSON
     C     ID05          ORNE      *BLANKS                                      CREDIT REP
     C                   MOVE      *ON           *IN82
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(42)       MSGFLD
     C                   Z-ADD     RN            RNERR
     C                   END
     C                   END
     C                   END
     C     SVFL17        IFEQ      'C'
     C                   MOVE      '1'           *IN32
     C                   ELSE
     C                   MOVE      '0'           *IN32
     C                   END
     C                   UPDATE    ARS5015F
     C                   MOVEA     '0'           *IN(80)                        HIGHLITE ERROR
     C                   MOVE      *OFF          *IN81
     C                   MOVEA     '0'           *IN(82)                        HIGHLITE ERROR
CI   c                   eval      *in83 = *off
     C                   MOVEA     '0'           *IN(90)                        HIGHLITE ERROR
     C                   MOVE      *OFF          *IN29
     C     NO16          IFNE      0
     C                   MOVE      'Y'           COMPNY
     C                   END
     C                   END
     C                   END
      *
     C     *IN99         IFEQ      '1'
     C     COMPNY        ORNE      'Y'
     C                   MOVE      'Y'           S15FER
     C                   ELSE
     C                   MOVE      ' '           S15FER
     C                   ENDIF
     C     COMPNY        IFNE      'Y'
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     EMS(45)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       CMDSP
     C     MSGFLD        IFEQ      *BLANKS
      * PREVIOUS
     C     *IN12         CABEQ     *ON           CMEND                          CMD 12 PREVIOUS
      *
      * IF F10= UPDATE PRESSED,
      *    ENSURE NO ERROR EXIST ON ANY SCREEN
      *    SET F10 UPDATE FLAG TO YES
     C     *IN10         IFEQ      '1'
     C     ADDCUS        ANDEQ     'N'
     C                   SELECT
     C     SCRNER        WHENNE    *BLANKS
     C                   MOVE      UMS(3)        MSGFLD
     C     MSGFLD        CABNE     *BLANKS       CMDSP
     C                   OTHER
     C                   MOVE      'Y'           F10FLG
     C                   ENDSL
     C                   ENDIF
      *
     C                   END
     C     CMEND         TAG
     C                   MOVE      IN58          *IN58
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    UPDATE CUSTOMER BALANCE RECORDS                         *
      *------------------------------------------------------------------------*
     C     UPDBAL        BEGSR
DM   C                   eval      brnchg = 'N'
     C                   Z-ADD     1             RN
     C     RN            DOUGT     SVRN
   DCC*    RN            CHAIN     ARS5015F                           40
   DCC*    *IN40         IFEQ      '0'
DC   C     RN            CHAIN(E)  ARS5015F
DC   C                   IF        %FOUND
     C     NO16          IFNE      0                                            BRANCH
     C     SVNO16        IFEQ      0                                            0 NO PRIOR RCD
DM   C                   eval      brnchg = 'Y'
     C                   EXSR      DATES
     C     CREDIT        IFEQ      'A'                                          BY COMPANY
     C                   MOVEL     FL76          CBFL76                         CR HOLD LOCK
     C                   Z-ADD     AM01          A01                            CREDIT LIMIT
     C                   MOVE      FL03          F03                            HOLD FLAG
     C     FL03          IFEQ      'Y'                                          HOLD ?
     C     SVFL03        IFNE      'Y'
     C                   ADD       1             C01                            CNT CUST HELD
     C                   Z-ADD     UMONTH        M12                            MONTH HELD
     C                   Z-ADD     UDAY          D12                            DAY HELD
     C                   MOVEL     *YEAR         C12                            CENTURY HELD
     C                   Z-ADD     UYEAR         Y12                            YEAR HELD
     C                   END
     C                   ELSE
     C                   Z-ADD     0             M12                            MONTH HELD
     C                   Z-ADD     0             D12                            DAY HELD
     C                   Z-ADD     0             C12                            CENTURY HELD
     C                   Z-ADD     0             Y12                            YEAR HELD
     C                   END
     C                   END
     C                   Z-ADD     NO16          ARNO16                         BRANCH
     C                   MOVE      ID01          ARID01                         SALESPERSON
     C                   MOVE      ID05          ARID05
CI   C                   MOVE      ID08          ARID08
     C                   MOVE      FL14          ARFL14                         SVC CHG FLG
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   Z-ADD     11            ARCD51                         TRANS CODE
     C                   Z-ADD     LSTMDT        DLSTMT                         DT LAST STATMNT
     C                   Z-ADD     ACDT1         DACTPR                         ACT PERIOD
     C                   EXSR      CLRAMT
     C                   WRITE     ARFMBAL
     C                   Z-ADD     ACDT2         DSTMPR                         STMT PERIOD
     C                   WRITE     ARFHBAL
¢3   C     CREDIT        IFEQ      'A'                                          BY COMPANY
¢3   C                   Z-ADD     SVAM01        ARAM01B4                       BY COMPANY
¢3   C                   Z-ADD     AM01          ARAM01NW                       BY COMPANY
¢3   C                   Z-ADD     UMONTH        ARMO09                         MONTH HELD
¢3   C                   Z-ADD     UDAY          ARDY09                         DAY HELD
¢3   C                   MOVEL     *YEAR         ARCC09                         CENTURY HELD
¢3   C                   Z-ADD     UYEAR         ARYR09                         YEAR HELD
¢3   C                   TIME                    ARTM01                         YEAR HELD
¢3   C                   MOVEL     USRNM         ARNM03                         CENTURY HELD
¢3   C                   WRITE     ARFCCSA                                      CENTURY HELD
¢3   C                   ENDIF                                                  BY COMPANY
     C                   ELSE
C3   C                   IF        ID01 <> SVID01
C3   C                   EXSR      SRDspSlsID
C3   C                   ENDIF
     C     NO16          IFNE      SVNO16
     C     ID01          ORNE      SVID01
     C     ID05          ORNE      SVID05
CI   C     ID08          ORNE      SVID08
     C     FL14          ORNE      SVFL14
     C     AM01          ORNE      SVAM01
     C     FL03          ORNE      SVFL03
     C     FL76          ORNE      SVFL76                                       CR HOLD LOCK
     C     REOPEN        OREQ      'Y'
     C     *IN53         DOUEQ     '0'
     C     BALKEY        CHAIN     ARFMBAL                            4153
     C                   END
     C     *IN41         IFEQ      '0'
DM    * Flag if branch is changed, to send to CertCapture also
DM   C                   if        no16 <> svno16
DM   C                   eval      brnchg = 'Y'
DM   C                   endif
DM    *
     C     CREDIT        IFEQ      'A'                                          BY COMPANY
     C                   MOVEL     FL76          CBFL76
     C                   Z-ADD     AM01          A01                            CREDIT LIMIT
     C     SVFL03        IFNE      'Y'                                          SAVE HOLD
     C     FL03          IFEQ      'Y'                                          HOLD ?
     C                   MOVE      FL03          F03                            HOLD FLAG
     C                   ADD       1             C01                            CNT CUST HELD
     C                   Z-ADD     UMONTH        M12                            MONTH HELD
     C                   Z-ADD     UDAY          D12                            DAY HELD
     C                   MOVEL     *YEAR         C12                            CENTURY HELD
     C                   Z-ADD     UYEAR         Y12                            YEAR HELD
     C                   END                                                    FL03 EQ Y
     C                   ELSE
     C     FL03          IFNE      'Y'                                          HOLD ?
     C                   MOVE      FL03          F03                            HOLD FLAG
     C                   Z-ADD     0             M12                            MONTH HELD
     C                   Z-ADD     0             D12                            DAY HELD
     C                   Z-ADD     0             C12                            CENTURY HELD
     C                   Z-ADD     0             Y12                            YEAR HELD
     C                   END                                                    FL03 NE Y
     C                   END                                                    SVFL03 NE Y
     C     REOPEN        IFEQ      'Y'
     C                   MOVE      ' '           ARFL17
     C                   Z-ADD     0             M11                            MONTH CLOSED
     C                   Z-ADD     0             D11                            DAY CLOSED
     C                   Z-ADD     0             C11                            CENTURY CLOSED
     C                   Z-ADD     0             Y11                            YEAR CLOSED
     C                   MOVE      '0'           *IN32
     C                   ELSE
     C     SVFL17        IFEQ      'Y'
     C                   MOVE      '1'           *IN32
     C                   ELSE
     C                   MOVE      '0'           *IN32
     C                   END
     C                   END
     C                   END
     C                   Z-ADD     NO16          ARNO16                         BRANCH
     C                   MOVE      ID01          ARID01                         SALESPERSON
     C                   MOVE      ID05          ARID05
CI   C                   MOVE      ID08          ARID08
     C                   MOVE      FL14          ARFL14                         SVC CHG FLG
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   UPDATE    ARFMBAL
¢3   C     CREDIT        IFEQ      'A'                                          BY COMPANY
¢3   C     AM01          ANDNE     SVAM01                                       BY COMPANY
¢3   C                   Z-ADD     SVAM01        ARAM01B4                       BY COMPANY
¢3   C                   Z-ADD     AM01          ARAM01NW                       BY COMPANY
¢3   C                   Z-ADD     UMONTH        ARMO09                         MONTH HELD
¢3   C                   Z-ADD     UDAY          ARDY09                         DAY HELD
¢3   C                   MOVEL     *YEAR         ARCC09                         CENTURY HELD
¢3   C                   Z-ADD     UYEAR         ARYR09                         YEAR HELD
¢3   C                   TIME                    ARTM01                         YEAR HELD
¢3   C                   MOVEL     USRNM         ARNM03                         CENTURY HELD
¢3   C                   WRITE     ARFCCSA                                      CENTURY HELD
¢3   C                   ENDIF                                                  BY COMPANY
     C                   END
     C                   END
     C                   END
CM   c                   If        f3flg = 'Y'
CM   c                   Exsr      CusEvent
CM   c                   Endif
     C                   END
     C                   MOVE      NO16          SVNO16
     C                   MOVE      ID01          SVID01
     C                   MOVE      FL14          SVFL14
     C                   MOVE      AM01          SVAM01
     C                   MOVE      FL03          SVFL03
     C                   MOVE      FL76          SVFL76
     C                   MOVE      ID05          SVID05
CI   C                   MOVE      ID08          SVID08
     C                   UPDATE    ARS5015F
     C                   END
     C                   ADD       1             RN
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    CUSTOMER NOTES                                          *
      *------------------------------------------------------------------------*
     C     NTSSR         BEGSR
D2   C                   MOVE      *IN95         SVIN95            1
D2   C                   MOVE      *IN96         SVIN96            1
     C                   MOVE      'N'           F3WRN
$F   C                   MOVE      *IN69         SAVE_IN69
$F   C                   MOVE      *ON           *IN69
      * INITIALIZE SUBFILE
     C     FRSTM         IFEQ      'Y'                                          FIRST TIME THRU
     C                   MOVE      'N'           FRSTM
     C     ADDCUS        IFEQ      'Y'
     C                   MOVEA     '1'           *IN(70)                        INITIALIZE
     C                   ELSE
     C                   MOVEA     '1'           *IN(73)                        CLEAR
     C                   END
   CQC*                  Z-ADD     0             RNO               3 0
CQ   C                   Z-ADD     0             RNO               4 0
     C                   WRITE     ARC5015E                                     CUST CONTACS
     C                   MOVEA     '0'           *IN(70)                        SETOF INITIALIZ
     C                   MOVEA     '0'           *IN(73)                        SETOF CLEAR
     C                   MOVE      *BLANKS       ERRMSG
      * LOAD CUSTOMER NOTES
     C     ADDCUS        IFEQ      'N'
     C     ARNO01        SETLL     ARFTNT
     C     *IN40         DOUEQ     '1'
     C     ARNO01        READE     ARFTNT                                 40
     C     *IN40         IFEQ      '0'
     C     ARCD01        IFEQ      'O'                                          O/E NOTES
     C                   MOVE      ARTX01        OEDSP                          DSPLY ON O/E
     C                   END
     C     ARCD01        IFEQ      'P'                                          O/E NOTES PRINT
     C                   MOVE      ARTX01        PTPRT                          ON PICK TICKET
     C                   END
     C     ARCD01        IFEQ      'N'                                          CUSTOMER NOTES
D2    * Write pin notes first
D2   C                   if        arflb7 <> ' '
     C                   ADD       1             RNO
     C                   Z-ADD     ARMO53        MO53
     C                   Z-ADD     ARDY53        DY53
     C                   Z-ADD     ARCC53        CC53
     C                   Z-ADD     ARYR53        YR53
D2   C                   eval      flb7 = arflb7
D2   C                   eval      mo09 = armo09
D2   C                   eval      dy09 = ardy09
D2   C                   eval      yr09 = aryr09
     C                   MOVE      ARID02        ID
     C                   MOVE      ARTX01        NOTES
CR   C                   MOVE      ID            ORIG_ID
     C                   WRITE     ARS5015E
D2   C                   endif
CQ   C                   IF        RNO = 9999
CQ   C                   LEAVE
CQ   C                   ENDIF
     C                   END
     C                   END
     C                   END
D2   C     ARNO01        SETLL     ARFTNT
D2   C     *IN40         DOUEQ     '1'
D2   C   02ARNO01        READE(N)  ARFTNT                                 40
D2   C  N02ARNO01        READE     ARFTNT                                 40
D2   C     *IN40         IFEQ      '0'
D2   C     ARCD01        IFEQ      'N'                                          CUSTOMER NOTES
D2   C                   if        arflb7 = ' '
D2   C                   ADD       1             RNO
D2   C                   Z-ADD     ARMO53        MO53
D2   C                   Z-ADD     ARDY53        DY53
D2   C                   Z-ADD     ARCC53        CC53
D2   C                   Z-ADD     ARYR53        YR53
D2   C                   MOVE      ARID02        ID
D2   C                   MOVE      ARTX01        NOTES
D2   C                   MOVE      ID            ORIG_ID
D2   C                   eval      flb7 = arflb7
D2   C                   eval      mo09 = armo09
D2   C                   eval      dy09 = ardy09
D2   C                   eval      yr09 = aryr09
D2   C                   WRITE     ARS5015E
D2   C                   endif
D2   C                   IF        RNO = 9999
D2   C                   LEAVE
D2   C                   ENDIF
D2   C                   END
D2   C                   END
D2   C                   END
     C                   END
$F   C     RNO           ADD       1             BOTTOMRNO
      *** IF SUBFILE IS NOT FILLED, WRITE BLANK RECORDS UNTIL FILLED
     C                   Z-ADD     0             MO53                           FOLLOW-UP MONTH
     C                   Z-ADD     0             DY53                           FOLLOW-UP DAY
     C                   Z-ADD     0             CC53                           FOLLOW-UP CENTURY
     C                   Z-ADD     0             YR53                           FOLLOW-UP YEAR
     C                   MOVE      *BLANKS       ID
D2   C                   eval      flb7 = ' '
D2   C                   eval      mo09 = *zeros
D2   C                   eval      dy09 = *zeros
D2   C                   eval      yr09 = *zeros
D2   C                   eval      arcc09 = *zeros
CR   C                   CLEAR                   ORIG_ID
     C                   MOVE      *BLANKS       NOTES                          CUSTOMER NOTES
CQ   C                   IF        RNO <> 9999
CQ   C                   DO        120
CQ   C                   ADD       1             RNO
CQ   C                   WRITE     ARS5015E
CQ   C                   IF        RNO = 9999
CQ   C                   LEAVE
CQ   C                   ENDIF
CQ   C                   ENDDO
CQ   C                   ENDIF
   CQC*    RNO           IFLT      120
   CQC*    RNO           DOWLT     120
   CQC*                  ADD       1             RNO
   CQC*                  WRITE     ARS5015E
   CQC*                  END
   CQC*                  ELSE
   CQ * ADD SOME BLANK RECORDS
   CQC*    RNO           SUB       120           PLUS              3 0
   CQC*    PLUS          IFLT      6
   CQC*    6             SUB       PLUS          PLUS
   CQC*                  ELSE
   CQC*                  Z-ADD     6             PLUS
   CQC*                  END
   CQC*                  DO        PLUS
   CQC*                  ADD       1             RNO
   CQC*                  WRITE     ARS5015E
   CQC*                  END
   CQC*                  END
     C                   END
      * DISPLAY CUSTOMER NOTES
     C     NTDSP         TAG
$F   C     *IN03         IFNE      *ON
     C     RRNERR        IFNE      0
     C                   Z-ADD     RRNERR        RNO
     C                   ELSE
$F   C     *IN09         IFEQ      *ON
$F   C     *IN69         IFEQ      *ON
$F   C                   Z-ADD     BOTTOMRNO     RNO
$F   C                   MOVE      *OFF          *IN69
$F   C                   ELSE
$F   C                   Z-ADD     1             RNO
$F   C                   MOVE      *ON           *IN69
$F   C                   ENDIF
$F   C                   ELSE
     C                   Z-ADD     1             RNO
$F   C                   ENDIF
     C                   END
$F   C                   ENDIF
     C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB& CNTL
     C                   WRITE     ARF5015E                                     CMD KEY FORMAT
     C                   EXFMT     ARC5015E                                     CUSTOMER NOTES
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
     C                   Z-ADD     0             RRNERR            4 0
     C                   MOVE      'Y'           S15EUP
     C                   MOVE      *BLANKS       ERRMSG
CJ   C     f3flg         ifeq      'Y'
CJ   C     *in03         ifeq      *on
CJ   C                   move      '0'           *in03
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(63)       errmsg
CJ   C                   endif
CJ   C                   goto      ntdsp
CJ   C                   endif
CJ   C     *in10         ifeq      *on
CJ   C                   move      '0'           *in10
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(64)       errmsg
CJ   C                   endif
CJ   C                   goto      ntdsp
CJ   C                   endif
CJ   C                   endif
     C     *IN03         IFEQ      *OFF
     C                   MOVE      'N'           F3WRN
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     UMS(5)        ERRMSG
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      NTDSP
     C                   ENDIF
CV    *
CV    * Unlock in use record...
CV   C                   EVAL      nActCd = 'U'
CV   C                   CALLP     Opr1010(nRetCd: nActCd: nFunky: nData)
CV    *
     C                   GOTO      ENDPGM
     C                   ENDIF
      * SERVICE NOTES
     C     *IN07         IFEQ      *ON
     C                   MOVE      'M'           MODE              1
     C                   MOVE      ARNO01        CUST              6
     C                   CALL      'ARR0700'
     C                   PARM                    MODE
     C                   PARM                    CUST
     C     *IN07         CABEQ     '1'           NTDSP
     C                   ENDIF
$F    * F9 = GO TO BOTTOM/TOP
$F   C     *IN09         CABEQ     *ON           NTDSP
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           NTDSP
     C                   END
      * READ AND UPDATE SUBFILE
     C                   MOVEA     '0'           *IN(92)
     C                   MOVEA     '0'           *IN(94)
     C                   MOVEA     '0'           *IN(99)
     C     *IN40         DOUEQ     '1'
     C                   READC     ARS5015E                               40
     C     *IN40         IFNE      '1'
      *** VERIFY DATE (PASS PARAMETERS TO DATE PROGRAM- IF ERROR
      *** DISPLAY ERROR MESSAGE
     C     FDATE         IFNE      *ZEROS
     C                   MOVE      FDATE         PDATE
     C                   MOVE      *ZEROS        PJULI
     C                   CALL      'GPR0100'     JULKEY
     C     PJULI         IFEQ      0
     C                   MOVEA     '1'           *IN(92)
     C     *IN99         IFEQ      '0'
     C                   MOVEA     '1'           *IN(91)
     C                   MOVEA     '1'           *IN(99)
     C                   END
     C     RRNERR        IFEQ      0
     C                   Z-ADD     RNO           RRNERR
     C                   END
     C                   END
      *
     C                   Z-ADD     4             DATYP                          DATE TYPE
     C                   MOVE      FDATE         DATE6                          YEAR ACCT OPEN
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      DACEN         ARCC53                         CENTURY ACCT OPEN
     C                   MOVE      DACEN         CC53
      *
     C                   END
      *** CHECK ID AGAINST ENTRIES IN TABLE FILE
     C     ID            IFNE      *BLANKS
CR   C     ID            ANDNE     ORIG_ID
     C                   MOVE      'AR08'        TBNO01                         TABLE CODE 1
     C                   MOVE      *BLANKS       TBNO02                         TABLE CODE 2
     C                   MOVEL     ID            TBNO02                         TABLE CODE 2
     C     TBKEY         CHAIN     TBFMTBL                            41        TABLE MAST FILE
     C     *IN41         IFEQ      '1'
     C                   MOVEA     '1'           *IN(94)
     C     *IN99         IFEQ      '0'
     C                   MOVEA     '1'           *IN(93)
     C                   MOVEA     '1'           *IN(99)
     C                   END
     C     RRNERR        IFEQ      0
     C                   Z-ADD     RNO           RRNERR
     C                   END
     C                   END
     C                   END
D2    ***  VALIDATE PIN CODE
D2   C                   IF        FLB7 <> 'X'
D2   C                              AND FLB7 <> ' '
D2   C                   SETON                                            96
D2   C     *IN99         IFEQ      '0'
D2   C                   SETON                                        95  99
D2   C                   Z-ADD     RNO           RRNERR
D2   C                   END
D2   C                   ENDIF
     C                   UPDATE    ARS5015E
     C                   MOVEA     '0'           *IN(92)
     C                   MOVEA     '0'           *IN(94)
D2   C                   MOVEA     '0'           *IN(96)
     C                   END
     C                   END
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           S15EER
     C                   ELSE
     C                   MOVE      ' '           S15EER
     C                   ENDIF
     C     *IN99         CABEQ     '1'           NTDSP
      * PREVIOUS
     C     *IN12         CABEQ     *ON           NTEND                          CMD 12 PREVIOUS
      *
      * IF F10= UPDATE PRESSED,
      *    ENSURE NO ERROR EXIST ON ANY SCREEN
      *    SET F10 UPDATE FLAG TO YES
     C     *IN10         IFEQ      '1'
     C     ADDCUS        ANDEQ     'N'
     C                   SELECT
     C     SCRNER        WHENNE    *BLANKS
     C                   MOVE      UMS(3)        ERRMSG
     C     ERRMSG        CABNE     *BLANKS       NTDSP
     C                   OTHER
     C                   MOVE      'Y'           F10FLG
     C                   ENDSL
     C                   ENDIF
      *
     C     ADDCUS        IFNE      'Y'
     C                   ELSE
     C     RNO           IFNE      0
     C                   MOVE      'Y'           HAVTNT                         ? HAVE NOTES
     C                   ELSE
     C                   MOVE      'N'           HAVTNT                         ? HAVE NOTES
     C                   END
     C                   END
D2   C                   MOVE      SVIN95        *IN95
D2   C                   MOVE      SVIN96        *IN96
     C     NTEND         ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    WRITE CUSTOMER NOTES                                    *
      *------------------------------------------------------------------------*
     C     WRTNT         BEGSR
      * DELETE CUSTOMER NOTES
     C     ARNO01        SETLL     ARFTNT
     C     *IN40         DOUEQ     '1'
     C     ARNO01        READE     ARFTNT                                 40
     C     *IN40         IFEQ      '0'
     C     ARCD01        IFNE      'S'
     C                   DELETE    ARFTNT
     C                   ENDIF
     C                   END
     C                   END
      * WRITE CUSTOMER NOTES
     C                   Z-ADD     0             RNO
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C     *IN40         DOUEQ     '1'
     C                   ADD       1             RNO
     C     RNO           CHAIN     ARS5015E                           40
     C     *IN40         IFEQ      '0'
     C     NOTES         IFNE      *BLANKS                                      CONTACT NAME
$N   C     FDATE         IFEQ      *zeros
$N   C                   Z-ADD     UDAY          DY53
$N   C                   Z-ADD     UYEAR         YR53
$N   C                   Z-ADD     UMONTH        MO53
$N   C                   Z-ADD     20            CC53
$N   C                   ENDIF

$N         If ID = *blanks;
$N            exec sql
$N             select OPEINT
$N             into :id
$N             from OPPMUPM
$N             where OPUSER = current_user;
$N         Endif;

     C                   Z-ADD     MO53          ARMO53
     C                   Z-ADD     DY53          ARDY53
     C     FDATE         IFEQ      *ZEROS
     C                   Z-ADD     *ZEROS        CC53
     C                   ENDIF
     C                   Z-ADD     CC53          ARCC53
     C                   Z-ADD     YR53          ARYR53
     C                   MOVE      ID            ARID02
     C                   MOVE      NOTES         ARTX01
     C                   MOVE      'N'           ARCD01                         TYPE CODE
D2   C                   MOVE      FLB7          ARFLB7
     C                   WRITE     ARFTNT
     C                   END
     C                   END
     C                   END
     C     OEDSP         IFNE      *BLANKS
     C                   MOVE      'O'           ARCD01                         TYPE CODE
     C                   MOVE      OEDSP         ARTX01
     C                   MOVE      'Y'           FL11                           NOTES EXIST
     C                   Z-ADD     *ZERO         ARMO53                         FOLLOW UP MONTH
     C                   Z-ADD     *ZERO         ARDY53                         FOLLOW UP DAY
     C                   Z-ADD     *ZERO         ARCC53                         FOLLOW UP CENTURY
     C                   Z-ADD     *ZERO         ARYR53                         FOLLOW UP YEAR
     C                   MOVE      *BLANKS       ARID02                         FOLLOW UP ID
     C                   WRITE     ARFTNT
     C                   ELSE
     C                   MOVE      'N'           FL11                           NOTES EXIST
     C                   END
     C     PTPRT         IFNE      *BLANKS
     C                   MOVE      'P'           ARCD01                         TYPE CODE
     C                   MOVE      PTPRT         ARTX01
     C                   MOVE      'Y'           FL11                           NOTES EXIST
     C                   Z-ADD     *ZERO         ARMO53                         FOLLOW UP MONTH
     C                   Z-ADD     *ZERO         ARDY53                         FOLLOW UP DAY
     C                   Z-ADD     *ZERO         ARCC53                         FOLLOW UP CENTURY
     C                   Z-ADD     *ZERO         ARYR53                         FOLLOW UP YEAR
     C                   MOVE      *BLANKS       ARID02                         FOLLOW UP ID
     C                   WRITE     ARFTNT
     C                   ELSE
     C                   MOVE      'N'           FL11                           NOTES EXIST
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    RETRIEVE A/R DATES                                      *
      *------------------------------------------------------------------------*
     C     DATES         BEGSR
C3   C                   EVAL      STDATE = *ZEROS                              STMT NUMERIC
C3   C                   EVAL      ACDATE = *ZEROS                              STMT NUMERIC
     C                   MOVE      'AR09'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     ARNO15        TBNO02
     C     TBKEY         CHAIN     TBFMTBL                            49
     C     *IN49         IFEQ      '0'
     C                   MOVEL     TBNO03        ACDATE
     C                   END
     C                   MOVE      'AR11'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     ARNO15        TBNO02
     C                   MOVE      'DATA  '      TBNO02
     C     TBKEY         CHAIN     TBFMTBL                            49
     C     *IN49         IFEQ      '0'
     C                   MOVEL     TBNO03        STDTE                          STMT ALPHA
     C                   MOVE      STDTE         STDATE                         STMT NUMERIC
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    CLOSE ACCOUNT                                           *
      *------------------------------------------------------------------------*
     C     CMPCLS        BEGSR
      * INITIALIZE SUBFILE
     C                   MOVEA     '1'           *IN(73)                        CLEAR
     C                   Z-ADD     0             RN
     C                   WRITE     ARC5015G
     C                   MOVEA     '0'           *IN(73)                        SETOF CLEAR
     C                   Z-ADD     0             CONUM             3 0
     C                   MOVE      '0'           *IN90
     C                   MOVE      ' '           CLSFL             1            CUST MSTR CLOSE
     C                   MOVE      'N'           F3WRN
     C                   MOVE      *BLANKS       ERRMSG
      * LOAD CUSTOMER COMPANIES
     C     CONUM         SETLL     GLFMHDR
     C     *IN40         DOUEQ     '1'
     C                   READ      GLFMHDR                                40
     C     *IN40         IFEQ      '0'
     C                   Z-ADD     GLNO01        ARNO15                         COMPANY NO
     C     *IN53         DOUEQ     '0'
     C     BALKEY        CHAIN     ARFMBAL                            4153
     C                   END
     C     *IN41         IFEQ      '0'
      ***  CHECK COMPANY AUTHORIZATION.
     C     ALLOK         IFNE      'Y'
     C     ARNO15        LOOKUP    SEC                                    52
     C                   END
     C     *IN52         IFEQ      '0'
     C                   MOVE      'N'           CLSFL                          CUST MSTR CLOSE
     C                   ELSE
     C     ARFL17        IFNE      'C'                                          NOT CLOSED
     C                   MOVE      ' '           FL17                           CLOSE
     C                   Z-ADD     ARNO16        NO16
     C                   ADD       1             RN
     C                   WRITE     ARS5015G
     C                   END                                                    ARFL17 IFNE C
     C                   END                                                    *IN41 IFEQ 1
     C                   END                                                    *IN40 IFEQ 0
     C                   END                                                    *IN40 IFEQ 0
     C                   END                                                    *IN40 DOUEQ 1
     C                   Z-ADD     RN            SVRN              4 0
      * DISPLAY COMPANIES
     C     CLDSP         TAG
     C     RNERR         IFNE      0
     C                   Z-ADD     RNERR         RN
     C                   ELSE
     C                   Z-ADD     1             RN
     C                   END
     C     SVRN          IFNE      0
     C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB& CNTL
     C                   ELSE
     C                   MOVEA     '0100'        *IN(75)                        DSPLY CTL ONLY
     C                   END
     C                   WRITE     ARF5015G                                     CMD KEY FORMAT
     C                   EXFMT     ARC5015G                                     CONTACTS
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
     C                   MOVEA     '0'           *IN(99)                        ERROR OCCURED
     C                   Z-ADD     0             RNERR             4 0
     C                   MOVE      'Y'           S15GUP
     C                   MOVE      *BLANKS       ERRMSG
CJ   C     f3flg         ifeq      'Y'
CJ   C     *in03         ifeq      *on
CJ   C                   move      '0'           *in03
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(63)       errmsg
CJ   C                   endif
CJ   C                   goto      cldsp
CJ   C                   endif
CJ   C     *in10         ifeq      *on
CJ   C                   move      '0'           *in10
CJ   C     errmsg        ifeq      *blanks
CJ   C                   move      ems(64)       errmsg
CJ   C                   endif
CJ   C                   goto      cldsp
CJ   C                   endif
CJ   C                   endif
     C     *IN03         IFEQ      *OFF
     C                   MOVE      'N'           F3WRN
     C                   ENDIF
      * EXIT PROGRAM
     C     *IN03         IFEQ      *ON
     C     F3WRN         IFEQ      'N'
     C                   MOVEA     UMS(5)        ERRMSG
     C                   MOVE      'Y'           F3WRN
     C                   GOTO      CLDSP
     C                   ENDIF
     C                   GOTO      ENDPGM
     C                   ENDIF
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           CLDSP
     C                   END
      * CMD 12 PREVIOUS
     C     *IN12         CABEQ     '1'           CLEND                          CMD 12 PREVIOUS
      * READ SUBFILE
     C     SVRN          CABEQ     0             CLEND                          NO RECORDS
     C                   MOVE      'Y'           CUSCLS            1
     C     *IN42         DOUEQ     '1'
     C                   READC     ARS5015G                               42
     C     *IN42         IFEQ      '0'
     C     FL17          IFNE      'Y'
     C                   MOVE      FL17          CUSCLS
     C                   END
     C     FL17          IFEQ      'Y'                                          CLOSE
      * TOTAL BALANCE OWED ?
     C     *IN53         DOUEQ     '0'
     C     BALKEY        CHAIN     ARFMBAL                            4953
     C                   END
     C     *IN49         IFEQ      '0'
     C     LKEY          SETLL     ARFTOPN                                81
     C     ARBL58        IFNE      *ZEROS                                       TOTAL OWE
     C     *IN81         OREQ      '1'                                          OPEN TRAN
     C                   MOVEA     '11'          *IN(80)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
     C                   END
CP    * If web commerce account exists, don't allow close...
CP   C     ARNO01        SETLL     OEFMUSR                                40
CP   C     *IN40         DOUEQ     *ON
CP   C     ARNO01        READE     OEFMUSR                                40
CP   C     *IN40         IFEQ      *OFF
CP   C     WCCMPY        ANDEQ     ARNO15
CP   C                   MOVE      '1'           *IN65
CP   C                   MOVE      '1'           *IN80
CP   C                   MOVE      '1'           *IN99
CP   C                   ENDIF
CP   C                   ENDDO
CY    *
CY   C     ARNO01        SETLL     AIFMUSR                                40
CY   C     *IN40         DOUEQ     *ON
CY   C     ARNO01        READE     AIFMUSR                                40
CY   C     *IN40         IFEQ      *OFF
CY   C     WCCMP         ANDEQ     ARNO15
CY   C                   MOVE      '1'           *IN65
CY   C                   MOVE      '1'           *IN80
CY   C                   MOVE      '1'           *IN99
CY   C                   ENDIF
CY   C                   ENDDO
      * OPEN JOBS?
     C                   MOVE      '0'           *IN45
     C     ARNO01        SETLL     ARFMJBM
     C     *IN45         DOUEQ     '1'
     C     ARNO01        READE     ARFMJBM                                45
     C     *IN45         IFEQ      '0'
     C     ARCD81        IFNE      'C'
     C                   MOVE      '1'           *IN45
     C                   MOVE      '1'           *IN80                          ERROR MESSAGE
     C                   MOVE      '1'           *IN61                          ERROR MESSAGE
     C                   MOVE      '1'           *IN99                          ERROR OCCURED
     C                   END
     C                   END
     C                   END
      * OPEN CONTRACTS?
     C                   MOVE      '0'           *IN45
     C     ARNO01        SETLL     OEFTOAH
     C     *IN45         DOUEQ     '1'
     C     ARNO01        READE     OEFTOAH                                45
     C     *IN45         IFEQ      '0'
     C     NO15          IFEQ      ARNO15
     C     OECD58        ANDEQ     'O'
     C                   MOVE      '1'           *IN45
     C                   MOVE      '1'           *IN80                          ERROR MESSAGE
     C                   MOVE      '1'           *IN62                          ERROR MESSAGE
     C                   MOVE      '1'           *IN99                          ERROR OCCURED
     C                   END
     C                   END
     C                   END
      * OPEN ORDERS ?
     C     LKEY          SETLL     FTOH19                                 40    OPEN ORDERS
     C     *IN40         IFEQ      '1'
     C                   MOVEA     '11'          *IN(82)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
      * OPEN BACKORDERS ?
     C     LKEY          SETLL     OELTOLYJ                               40    OPEN ORDERS
     C     *IN40         IFEQ      '1'
     C                   MOVEA     '11'          *IN(84)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
      * POSTED TRANSACTIONS ?
     C                   MOVE      'P'           CODE                           POSTED
     C     KEY           SETLL     ARFTRAN                                40
     C     *IN40         IFEQ      '1'
     C                   MOVEA     '11'          *IN(86)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
      * ENTERED TRANSACTIONS ?
     C                   MOVE      'E'           CODE                           ENTERED
     C     KEY           SETLL     ARFTRAN                                40
     C     *IN40         IFEQ      '1'
     C                   MOVEA     '11'          *IN(88)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C                   END
¢O $C * OPEN CONTRACT PROFILE
¢O $Cc*    arno01        setll     prfcont                                45
¢O $Cc*    *IN45         ifeq      *ON
¢O $Cc*    arno01        reade     prfcont                                45
¢O $Cc*    *IN45         doweq     *off
¢O $Cc*                  delete    prfcont
¢O $Cc*    arno01        reade     prfcont                                45
¢O $Cc*                  enddo
¢O $Cc*                  end
   CE * OPEN CONTRACT PROFILE
   CEC*    ARNO01        SETLL     PRFMCPS                                45
   CEC*    *IN45         IFEQ      *ON
   CEC*                  MOVE      '1'           *IN63                          ERROR MESSAGE
   CEC*                  MOVE      '1'           *IN80                          ERROR MESSAGE
   CEC*                  MOVE      '1'           *IN99                          ERROR OCCURED
   CEC*                  ENDIF
   CE * CUSTOMER DISCOUNTS
   CEC*    ARNO01        SETLL     PRFMCPF                                45
   CEC*    *IN45         IFEQ      *ON
   CEC*                  MOVE      '1'           *IN64                          ERROR MESSAGE
   CEC*                  MOVE      '1'           *IN80                          ERROR MESSAGE
   CEC*                  MOVE      '1'           *IN99                          ERROR OCCURED
   CEC*                  ENDIF
     C                   END
     C                   UPDATE    ARS5015G
     C                   MOVEA     '0'           *IN(80)                        HIGHLITE ERROR
     C                   MOVEA     '0'           *IN(82)                        HIGHLITE ERROR
     C                   MOVEA     '0'           *IN(84)                        HIGHLITE ERROR
     C                   MOVEA     '0'           *IN(86)                        HIGHLITE ERROR
     C                   MOVEA     '0'           *IN(88)                        HIGHLITE ERROR
     C                   END
     C                   END
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           S15GER
     C                   ELSE
     C                   MOVE      ' '           S15GER
     C                   ENDIF
     C     *IN99         IFEQ      '0'
      *
      *    ENSURE NO ERROR EXIST ON ANY SCREEN
     C     SCRNER        IFNE      *BLANKS
     C                   MOVE      UMS(4)        ERRMSG
     C     ERRMSG        CABNE     *BLANKS       CLDSP
     C                   ENDIF
      *
     C     *IN90         CABEQ     '0'           CLDSP                    90
      *
      *    SET F11 CLOSE FLAG TO YES
     C     *IN11         CABEQ     '0'           CLDSP                    90
     C                   MOVE      'Y'           F11FLG
     C                   ELSE
     C                   MOVE      '0'           *IN90
     C     *IN99         CABEQ     '1'           CLDSP                          ERROR OCCURED
     C                   END
      * CLOSE COMPANIES
     C                   Z-ADD     1             RN
     C     RN            DOUGT     SVRN
   DCC*    RN            CHAIN     ARS5015G                           42
   DCC*    *IN42         IFEQ      '0'
DC   C     RN            CHAIN(E)  ARS5015G
DC   C                   IF        %FOUND
     C     FL17          IFEQ      'Y'                                          CLOSE
     C     *IN53         DOUEQ     '0'
     C     BALKEY        CHAIN     ARFMBAL                            4953
     C                   END
     C     *IN49         IFEQ      '0'
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   Z-ADD     UMONTH        M11                            DATE CLOSED
     C                   Z-ADD     UDAY          D11                            DATE CLOSED
     C                   MOVEL     *YEAR         C11                            DATE CLOSED
     C                   Z-ADD     UYEAR         Y11                            DATE CLOSED
     C                   MOVE      'C'           ARFL17
     C                   UPDATE    ARFMBAL
     C                   END
     C                   END
     C                   ADD       1             RN
     C                   END
     C                   END
      * CLOSE CUSTOMER MASTER
     C     CUSCLS        IFEQ      'Y'
     C     CLSFL         ANDNE     'N'                                          NOT ALL ACCTS
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   Z-ADD     DATE          DACCLS                         DATE CLOSED
     C                   MOVE      'C'           ARFL10                         CLOSE FLAG
     C                   UPDATE    ARFMCUS
      * CLOSE CUSTOMER CONTACT MASTER
     C     ARNO01        SETLL     ARFMCON
     C     *IN40         DOUEQ     '1'
     C     ARNO01        READE     ARFMCON                                40
     C     *IN40         IFEQ      '0'
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   MOVE      'C'           ARFL10                         CLOSE FLAG
     C                   UPDATE    ARFMCON
     C                   END
     C                   END
     C                   END
     C                   MOVE      '0'           *IN90
     C     CLEND         ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    CLOSE ACCOUNT                                           *
      *------------------------------------------------------------------------*
     C     CLOSE         BEGSR
      * TOTAL BALANCE OWED ?
     C     ARNO01        SETLL     ARFMBAL
     C     *IN49         DOUEQ     '1'
     C     ARNO01        READE     ARFMBAL                                49
     C     *IN49         IFEQ      '0'
     C     LKEY          SETLL     ARFTOPN                                93
     C     ARBL58        IFNE      *ZEROS                                       TOTAL OWE
     C     *IN93         OREQ      '1'                                          OPEN TRAN
     C                   MOVEA     '1'           *IN(93)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C     *IN99         CABEQ     '1'           CLSEND                         END OF SUBRTINE
     C                   END
     C                   END
     C                   END
      * OPEN JOBS?
     C                   MOVE      '0'           *IN45
     C     ARNO01        SETLL     ARFMJBM
     C     *IN45         DOUEQ     '1'
     C     ARNO01        READE     ARFMJBM                                45
     C     *IN45         IFEQ      '0'
     C     ARCD81        IFEQ      *BLANKS
     C                   MOVE      '1'           *IN97                          ERROR MESSAGE
     C                   MOVE      '1'           *IN99                          ERROR OCCURED
     C     *IN99         CABEQ     '1'           CLSEND                         END OF SUBRTINE
     C                   END
     C                   END
     C                   END
      * OPEN CONTRACTS?
     C                   MOVE      '0'           *IN45
     C     ARNO01        SETLL     OEFTOAH
     C     *IN45         DOUEQ     '1'
     C     ARNO01        READE     OEFTOAH                                45
     C     *IN45         IFEQ      '0'
     C     OECD58        IFEQ      'O'
     C                   MOVE      '1'           *IN98                          ERROR MESSAGE
     C                   MOVE      '1'           *IN99                          ERROR OCCURED
     C     *IN99         CABEQ     '1'           CLSEND                         END OF SUBRTINE
     C                   END
     C                   END
     C                   END
      * OPEN ORDERS ?
     C     ARNO01        SETLL     OEFTOH                                 40    OPEN ORDERS
     C     *IN40         IFEQ      '1'
     C                   MOVEA     '1'           *IN(94)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C     *IN99         CABEQ     '1'           CLSEND                         END OF SUBRTINE
     C                   END
      * OPEN BACKORDERS ?
     C     ARNO01        SETLL     OEFTOLY                                40    OPEN B/O
     C     *IN40         IFEQ      '1'
     C                   MOVEA     '1'           *IN(95)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C     *IN99         CABEQ     '1'           CLSEND                         END OF SUBRTINE
     C                   END
      * POSTED TRANSACTIONS ?
     C                   MOVE      'P'           CODE                           POSTED
     C     KEY2          SETLL     ARFTRAND                               40
     C     *IN40         IFEQ      '1'
     C                   MOVEA     '1'           *IN(95)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C     *IN99         CABEQ     '1'           CLSEND                         END OF SUBRTINE
     C                   END
      * ENTERED TRANSACTIONS ?
     C                   MOVE      'E'           CODE                           ENTERED
     C     KEY2          SETLL     ARFTRAND                               40
     C     *IN40         IFEQ      '1'
     C                   MOVEA     '1'           *IN(95)                        ERROR MESSAGE
     C                   MOVEA     '1'           *IN(99)                        ERROR OCCURED
     C     *IN99         CABEQ     '1'           CLSEND                         END OF SUBRTINE
     C                   END
   CE * OPEN CONTRACT PROFILE
   CEC*    ARNO01        SETLL     PRFMCPS                                45
   CEC*    *IN45         IFEQ      *ON
   CEC*                  MOVE      '1'           *IN78                          ERROR MESSAGE
   CEC*                  MOVE      '1'           *IN99                          ERROR OCCURED
   CEC*    *IN99         CABEQ     '1'           CLSEND                         END OF SUBRTINE
   CEC*                  ENDIF
   CE * CUSTOMER DISCOUNTS
   CEC*    ARNO01        SETLL     PRFMCPF                                45
   CEC*    *IN45         IFEQ      *ON
   CEC*                  MOVE      '1'           *IN81                          ERROR MESSAGE
   CEC*                  MOVE      '1'           *IN99                          ERROR OCCURED
   CEC*    *IN99         CABEQ     '1'           CLSEND                         END OF SUBRTINE
   CEC*                  ENDIF
      * CLOSE CUSTOMER MASTER
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   Z-ADD     DATE          DACCLS                         DATE CLOSED
     C                   MOVE      'C'           ARFL10                         CLOSE FLAG
     C                   UPDATE    ARFMCUS
      * CLOSE BALANCE MASTER
     C     ARNO01        SETLL     ARFMBAL
     C     *IN49         DOUEQ     '1'
     C     ARNO01        READE     ARFMBAL                                49
     C     *IN49         IFEQ      '0'
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   Z-ADD     ARMO11        M11                            DATE CLOSED
     C                   Z-ADD     ARDY11        D11                            DATE CLOSED
     C                   Z-ADD     ARCC11        C11                            DATE CLOSED
     C                   Z-ADD     ARYR11        Y11                            DATE CLOSED
     C                   MOVE      'C'           ARFL17
     C                   UPDATE    ARFMBAL
     C                   END
     C                   END
      * CLOSE CUSTOMER CONTACT MASTER
     C     ARNO01        SETLL     ARFMCON
     C     *IN40         DOUEQ     '1'
     C     ARNO01        READE     ARFMCON                                40
     C     *IN40         IFEQ      '0'
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   MOVE      'C'           ARFL10                         CLOSE FLAG
     C                   UPDATE    ARFMCON
     C                   END
     C                   END
     C     CLSEND        ENDSR
      *----------------------------------------------------------------
      *  @PRMPT - SUBROUTINE: PROCESS F4 , ALL FORMATS
      *----------------------------------------------------------------
     C     @PRMPT        BEGSR
      *
     C     CPOS          IFNE      0
      *
     C                   MOVE      *OFF          F4ERR             1
     C                   MOVE      *ON           WDWFLG            1
      *
     C                   EXSR      @CURSR
      *
     C                   SELECT
      *
      * PROMPT ON COMPANY SCREEN
      *
     C     CRCD          WHENEQ    'ARS5015F'
     C     CRRN          CHAIN     ARS5015F                           46
      *
      * DISPLAY BRANCH INQUIRY
      *
     C                   SELECT
     C     CFLD          WHENEQ    'NO16'
     C                   MOVE      'B'           LTYP              1
     C                   MOVE      ARNO15        CMPNY#
     C                   MOVE      *BLANKS       DIV
     C                   MOVE      *BLANKS       RGN
     C                   MOVE      *BLANKS       BRN#
     C                   CALL      'GLR2014'     PL2014
     C     BRN#          IFNE      *BLANKS
     C                   MOVEL     BRN#          NO16                           BRANCH SELECTED
     C                   ENDIF
      *
      * DISPLAY SALESPERSON INQUIRY
      *
     C     CFLD          WHENEQ    'ID01'
     C                   MOVE      ARNO15        NO15#
     C                   MOVE      *BLANKS       ID01#
     C                   CALL      'ARR5420'     PL5420                         SALESPERSON
     C     ID01#         IFNE      *BLANKS
     C                   MOVEL     ID01#         ID01
     C                   ENDIF
      *
      * DISPLAY CREDIT REPRESENTATIVE ID SELECTION
      *
     C     CFLD          WHENEQ    'ID05'
     C                   MOVE      *BLANKS       F4ID05
     C                   CALL      'ARR9020'     PL9020
     C     F4ID05        IFNE      *BLANKS
     C                   MOVEL     F4ID05        ID05
     C                   ENDIF
CI    *
CI    * DISPLAY CSR ID SELECTION
CI    *
CI   c                   when      cfld = 'ID08'
CI   c                   eval      pData = *blanks
CI   c                   eval      pActCd = 'CS'
CI   c                   call      'OPR3100'     pl3100
CI   c                   if        pData <> *blanks
CI   c                   eval      id08 = %subst(pData : 1 : 10)
CI   c                   endif
      *
     C                   OTHER
     C                   MOVE      *ON           F4ERR
     C                   ENDSL                                                  CFLD
      *
      * UPDATE SUBFILE WITH BRANCH OR SALESPERSON SELECTED
      *
     C     *IN46         IFEQ      *OFF
     C     F4ERR         ANDEQ     *OFF
     C                   UPDATE    ARS5015F
     C                   Z-ADD     *ZERO         NO16                           BRANCH NUMBER
     C                   MOVE      *BLANKS       ID01                           SALESPERSON
     C                   ENDIF
      *
     C     CRCD          WHENEQ    'ARF5015B'
      *
     C                   SELECT
DP   C                   when      cfld = 'ARCD05'
DP   C                   if        VectaYes = 'Y'
DP   C                             and licToVecta
DP   C                   eval      tabcod = 'AR36'
DP   C                   eval      tabent = *blanks
DP   C                   call      'TBR0025'     pl0025
DP   C                   if        tabent <> *blanks
DP   C                   move      tabent        arcd05
DP   C                   eval      geoDesc = tabdesc
DP   C                   endif
DP   C                   endif
DP    *
DP   C                   when      cfld = 'ARCD02'
DP   C                   if        VectaYes = 'Y'
DP   C                             and licToVecta
DP   C                   eval      tabcod = 'AR36'
DP   C                   eval      tabent = *blanks
DP   C                   call      'TBR0025'     pl0025
DP   C                   if        tabent <> *blanks
DP   C                   move      tabent        arcd02
DP   C                   eval      mktDesc = tabdesc
DP   C                   endif
DP   C                   endif
C0 $3 *
C0 $3 * Market class prompt selection
C0 $3c*                  when      cfld = 'ARCD03'
C0 $3C*                  MOVE      'OE36'        TABCOD            4
C0 $3C*                  MOVE      *BLANKS       TABENT
C0 $3C*                  CALL      'TBR0025'     PL0025                         ORDER SOURCE
C0 $3C*    TABENT        IFNE      *BLANKS
C0 $3C*                  MOVEL     TABENT        ARCD03
C0 $3C*                  ENDIF                                                  TABENT
     C     CFLD          WHENEQ    'ARCD04'                                     DELIV TAX JURIS
DG   C                   If        avaTaxActive <> 'Y'
     C     ARZP16        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        TAXJUR                         INIT TAX JURISD
     C                   Z-ADD     *ZEROS        RETCDE                         RETURN CODE
     C                   CALL      'ARR5211'     PL5211                         WDW PGM TAX JUR
     C     TAXJUR        IFNE      *ZEROS                                       TAX CODE CHOSEN
     C                   Z-ADD     TAXJUR        ARCD04                         MOVE CDE TO DSP
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ARZP16        ZPCD
     C                   MOVE      ARCD04        TXCD
     C                   Z-ADD     9             RETCOD
     C                   CALL      'ARR9100'     PL9100
     C     RETCOD        IFEQ      7
     C                   MOVE      *ON           *IN81                          ERROR MESSAGE
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(5)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ELSE
     C     ZPCD          IFNE      ARZP16
     C                   MOVE      EMS(57)       ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   MOVE      TXCD          ARCD04
     C                   MOVE      ZPCD          ARZP16
     C                   MOVE      ARZP16        CPYZIP
     C                   ENDIF
     C                   ENDIF
DG   C                   else                                                   CFLD
DG   C                   eval      f4err = *on
DG   C                   endif
      *
     C     CFLD          WHENEQ    'ARCD30'                                     PICKUP TAX JURS
     C     *IN59         ANDEQ     *OFF                                         NON PROTECT FLD
DG   C                   If        avaTaxActive <> 'Y'
     C     ARZP16        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        TAXJUR                         INIT TAX JURISD
     C                   Z-ADD     *ZEROS        RETCDE                         RETURN CODE
     C                   CALL      'ARR5211'     PL5211                         WDW PGM TAX JUR
     C     TAXJUR        IFNE      *ZEROS                                       TAX CODE CHOSEN
     C                   Z-ADD     TAXJUR        ARCD30                         MOVE CDE TO DSP
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ARZP16        ZPCD
     C                   MOVE      ARCD30        TXCD
     C                   Z-ADD     9             RETCOD
     C                   CALL      'ARR9100'     PL9100
     C     RETCOD        IFEQ      7
     C                   MOVE      *ON           *IN81                          ERROR MESSAGE
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVE      EMS(5)        ERRMSG                         ERROR OCCURED
     C                   ENDIF
     C                   ELSE
     C                   MOVE      TXCD          ARCD30
     C                   MOVE      ZPCD          ARZP16
     C                   MOVE      ARZP16        CPYZIP
     C                   ENDIF
     C                   ENDIF
DG   C                   else                                                   CFLD
DG   C                   eval      f4err = *on
DG   C                   endif
      *
     C     CFLD          WHENEQ    'ARCDC5'                                     MTH OF SHP
     C                   MOVE      *BLANKS       VALUE#
     C                   CALL      'TBR0060'     PL0060
     C     VALUE#        IFNE      *BLANKS
     C                   MOVEL     VALUE#        ARCDC5
     C                   ENDIF
     C     CFLD          WHENEQ    'ARCDC6'                                     SHIP CODE
     C                   MOVE      'S'           TXTYP             1            SALES ORDER
     C                   Z-ADD     *ZEROS        SCBRAN            3 0          SHIP BRANCH P
     C                   MOVE      ARCDC5        SHPMTD            1
     C                   MOVE      *BLANKS       SHPCD             2
     C                   MOVE      *BLANKS       SCDN01           15
     C                   CALL      'OER3110'                                                   ON
     C                   PARM                    TXTYP
     C                   PARM                    SCBRAN
     C                   PARM                    SHPMTD
     C                   PARM                    SHPCD
     C                   PARM                    SCDN01
     C     SHPCD         IFNE      *BLANKS
     C                   MOVE      SHPCD         ARCDC6
     C                   MOVE      SHPMTD        ARCDC5
     C                   ENDIF
DG    *
DG    * Prompt for Usage types
DG   C                   when      cfld = 'ARCDK3'
DG DNC*                  if        avaTaxActive = 'Y'
DN   C                   if        wEcms2 = 'Y'
DN   C                             and wEcms1 <> 'Y'
DG   C                   eval      tabcod = 'AR29'
DG   C                   eval      tabent = *blanks
DG   C                   call      'TBR0025'     pl0025
DG   C                   if        tabent <> *blanks
DG   C                   eval      arcdk3 = tabent
DG   C                   endif
DG   C                   endif
DQ    *
DQ    * CUSTOMER CLASS CODE SEARCH
DQ    *
DQ   C     CFLD          WHENEQ    'ARCDL1'
DQ   C                   MOVE      *BLANKS       CDL1#
DQ   C                   CALL      'ARR5041'
DQ   C                   PARM                    CDL1#             4
DQ   C                   PARM                    C@LOC#
DQ   C                   PARM                    CRCD#
DQ   C                   PARM                    CFLD#
DQ   C     CDL1#         IFNE      *BLANKS
DQ   C                   MOVEL     CDL1#         ARCDL1
DQ   C                   ENDIF
      *
     C                   OTHER
     C                   MOVE      *ON           F4ERR                          NOT A VALID LOC
     C                   ENDSL
      *
     C     CRCD          WHENEQ    'ARF5015C'
      *
     C                   SELECT
     C     CFLD          WHENEQ    'ARCDF9'                                     TERMS CODE
     C                   MOVE      *BLANKS       TRMCD                          TERMS CODE PARM
     C                   MOVE      *BLANKS       TRMYN                          TERMS Y/N  PARM
     C                   MOVE      *BLANKS       TRMPC                          TERMS PERCENT PARM
     C                   EXSR      @CURSR                                       POS CURSOR
     C                   CALL      'ARR5810'     PL5810                         WDW PGM TERMS CODE
     C     TRMCD         IFNE      *BLANKS                                      TAX CODE CHOSEN
     C                   MOVE      TRMCD         ARCDF9                         MOVE CDE TO DSP
     C                   MOVE      TRMPC         ARPC71
     C                   ENDIF
      *
     C                   OTHER
     C                   MOVE      *ON           F4ERR                          NOT A VALID LOC
     C                   ENDSL
      *
     C     CRCD          WHENEQ    'ARS5015I'
     C     CRRN          CHAIN     ARS5015I                           42
      *
     C                   SELECT
     C     CFLD          WHENEQ    'CD04S'                                      TAX CODE
     C     *IN67         ANDEQ     *OFF
DG   C                   if        avaTaxActive <> 'Y'
     C     ZP21S         IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        TAXJUR                         INIT TAX JURISD
     C                   Z-ADD     *ZEROS        RETCDE                         RETURN CODE
     C                   CALL      'ARR5211'     PL5211                         WDW PGM TAX JUR
     C     TAXJUR        IFNE      *ZEROS                                       TAX CODE CHOSEN
     C                   Z-ADD     TAXJUR        CD04S                          MOVE CDE TO DSP
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ZP21S         ZPCD
     C                   MOVE      CD04S         TXCD
     C                   Z-ADD     9             RETCOD
     C                   CALL      'ARR9100'     PL9100
     C     RETCOD        IFEQ      7
     C                   MOVE      *ON           *IN81                          ERROR MESSAGE
     C                   MOVE      *ON           *IN67                          (RI PC)     G
     C     *IN99         IFEQ      *OFF                                         NO ERRORS
     C                   Z-ADD     RNI           RNERRI
     C                   MOVE      *ON           *IN99                          ERROR OCCURED
     C                   ENDIF
     C                   ELSE
     C                   MOVE      TXCD          CD04S
     C                   MOVE      ZPCD          ZP21S
     C                   MOVE      ZP21S         CPYZPS
     C                   ENDIF
     C                   ENDIF
DG   C                   else                                                   CFLD
DG   C                   eval      f4err = *on
DG   C                   endif
      *
     C                   OTHER
     C                   MOVE      *ON           F4ERR                          NOT A VALID LOC
     C                   ENDSL
      *
     C     *IN42         IFEQ      *OFF
     C     F4ERR         ANDEQ     *OFF
     C                   UPDATE    ARS5015I
     C                   ENDIF
     C                   ENDSL
      *
     C                   ELSE
     C                   MOVE      *ON           F4ERR
     C                   ENDIF                                                  CPOS ENDIF
      *
      * SEND ERROR MESSAGE - CURSOR LOCATION INVALID
      *
     C     F4ERR         IFEQ      *ON
     C     *IN99         IFEQ      *OFF
     C                   MOVE      MSG(1)        ERRMSG
     C                   MOVE      'Y'           MFLG              1
     C                   MOVE      *ON           *IN99
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
      *
     C                   Z-ADD     0             CROW                           CLEAR
     C                   Z-ADD     0             CCOL                           CRSLOC
      *
     C     #CLCSR        ENDSR
      *------------------------------------------------------------------------*
      *CLRAMT    CLEAR AMOUNT FIELDS IN BALANCE RECORD
      *------------------------------------------------------------------------*
     C     CLRAMT        BEGSR
     C                   Z-ADD     0             ARBL02
     C                   Z-ADD     0             ARBL11
     C                   Z-ADD     0             ARBL12
     C                   Z-ADD     0             ARBL15
     C                   Z-ADD     0             ARBL50
     C                   Z-ADD     0             ARBL51
     C                   Z-ADD     0             ARBL52
     C                   Z-ADD     0             ARBL53
     C                   Z-ADD     0             ARBL54
     C                   Z-ADD     0             ARBL55
     C                   Z-ADD     0             ARBL56
     C                   Z-ADD     0             ARBL57
     C                   Z-ADD     0             ARBL58
     C                   Z-ADD     0             ARBL75
     C                   Z-ADD     0             ARBL61
     C                   Z-ADD     0             ARBL62
     C                   Z-ADD     0             ARAM04
     C                   Z-ADD     0             ARAM05
     C                   Z-ADD     0             ARAM07
     C                   Z-ADD     0             ARAM08
     C                   Z-ADD     0             ARAM09
     C                   Z-ADD     0             ARAM16
     C                   Z-ADD     0             ARAM17
     C                   Z-ADD     0             ARAM18
     C                   Z-ADD     0             ARAM19
     C                   Z-ADD     0             ARAM20
     C                   Z-ADD     0             ARAM21
     C                   Z-ADD     0             ARAM22
     C                   Z-ADD     0             ARAM23
     C                   Z-ADD     0             ARCN01
     C                   Z-ADD     0             ARDY03
     C                   Z-ADD     0             ARDY04
     C                   Z-ADD     0             ARDY11
     C                   Z-ADD     0             ARDY16
     C                   Z-ADD     0             ARMO03
     C                   Z-ADD     0             ARMO04
     C                   Z-ADD     0             ARMO11
     C                   Z-ADD     0             ARMO16
     C                   Z-ADD     0             ARCC03
     C                   Z-ADD     0             ARYR03
     C                   Z-ADD     0             ARCC04
     C                   Z-ADD     0             ARYR04
     C                   Z-ADD     0             ARCC11
     C                   Z-ADD     0             ARYR11
     C                   Z-ADD     0             ARCC16
     C                   Z-ADD     0             ARYR16
     C                   Z-ADD     0             ARNO03
     C                   ENDSR
      *----------------------------------------------------------------
      *  UNLOCK - UNLOCK SUBROUTINE
      *----------------------------------------------------------------
     C     UNLOCK        BEGSR
     C                   MOVE      *BLANK        DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   ENDSR
      *------------------------------------------------------------------------*
      ** SUBROUTINE ** UPDATE BASIC CUSTOMER SCREEN INFO *****************
      *------------------------------------------------------------------------*
     C     UPDCUS        BEGSR
      *
     C                   MOVE      USRNM         ARNM03                         USER NAME
     C                   Z-ADD     DATE          DLSTUP                         UPDATE DATE
     C                   UPDATE    ARFMCUS                                      UPDATE CUSTOMER
DQ    * Update Customer Master Add-on File
DQ                       EXSR      @ProcessAddOnFile ;
      *
     C                   ENDSR
DM    *------------------------------------------------------------------------*
DM   C     srCallCertsv  begsr
DM    *
DM    * Determine if licensed to this product...
DM    * The following license key checking logic may not be altered, bypassed or removed.
DM    * See Legal Document in WRKMINKEY command for more information.
DM   C                   if        licToAvaTax
DM   C                   eval      pCust# = arno01
DM   C                   eval      pJob# = *blanks
DM   C                   eval      pPgmName= prog
DM   C                   call      'ARR9200'     pl9200
DM    * Display error message if not licensed to AvaTax
DM   C                   else
DM   C                   eval       p1300App  = 'AVATAX'
DM   C                   call      'MNR1300'     pl1300
DM   C                   endif
DM    *
DM   C                   endsr
      *------------------------------------------------------------------------*
      ** SUBROUTINE ** UPDATE E-MAIL INFO  **************              ***
      *------------------------------------------------------------------------*
     C     UPDEMA        BEGSR
      *
     C                   CLEAR                   OPNM13
     C                   MOVE      '01'          ETYPE
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      'Y'           DSPF1             1
     C     *IN92         DOUEQ     *OFF
     C     EKEY          CHAIN     OPFMEMA                            4092
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVEL     EMAIL         OPAD01
     C                   MOVE      ARNO01        OPNO17
     C                   MOVE      '01'          OPCD14
     C                   MOVE      USRNM         OPNM06
     C                   CLEAR                   OPNM13
     C                   Z-ADD     DATE          OPDATE
     C     *IN40         IFEQ      *OFF
     C     OPAD01        IFNE      *BLANKS
     C                   UPDATE    OPFMEMA
     C                   ELSE
     C                   DELETE    OPFMEMA
     C                   ENDIF
     C                   ELSE
CW   C                   If        opad01 <> *blanks
     C                   WRITE     OPFMEMA
CW   C                   end
     C                   ENDIF
      *
      *
     C                   ENDSR
¢C    *----------------------------------------------------------------
¢C    *  PER SORT ADDR VALIDATION FOR MAILING ADDRESS
¢C    *----------------------------------------------------------------
¢C   C     PERSRT        BEGSR
$K   C                   MOVE      *BLANKS       CASE
$K   C                   MOVE      *BLANKS       ECOD##
$K   C                   MOVE      *BLANKS       EMSG##
$K   C                   MOVE      '60'          MAXADRL
$K   C                   MOVE      'M'           ADDRTYPE
$K    * Load mailing address to input parms for validation program
$K   C                   MOVEL     ARNM01        INAME
$K $LC*                  MOVEL     ARAD01        IADDR1
$K $LC*                  MOVEL     ARAD02        IADDR2
$K $LC*                  MOVEL     ARAD03        IADDR3
$L   C                   MOVEL     ARAD02        IADDR2
$L   C                   MOVEL     ARAD03        IADDR3
$L   C                   MOVEL     *BLANKS       IADDR3
$K   C                   MOVEL     ARCY01        ICITY
$K   C                   MOVEL     ARST01        ISTATE
$K   C                   MOVEL     ARZP15        IZIP
$K    * Call validation program
$K   C                   CALL      'ARRC104'     PL_ARRC104
$K    * If no errors found, load per zip address
$K   C                   IF        ECOD## = *BLANKS
$K $LC*                  MOVEL     OADDR1        ARAD01
$K $LC*                  MOVEL     OADDR2        ARAD02
$K $LC*                  MOVEL     OADDR3        ARAD03
$L   C                   MOVEL     OADDR2        ARAD02
$L   C                   MOVEL     OADDR3        ARAD03
$K   C                   MOVEL     OCITY         ARCY01
$K   C                   MOVEL     OSTATE        ARST01
$K   C                   MOVEL     OZIP          ARZP15
$K   C                   ENDIF
$K    * If errors found, load proper error meessage
¢C   C     ECOD##        COMP      *BLANKS                                60     ERROR CODE
¢C    *
¢C   C     *IN60         IFEQ      *OFF
¢C   C                   SELECT
¢C   C     ECOD##        WHENEQ    'ADR'
¢C   C                   MOVE      *ON           *IN61
¢C   C                   MOVE      *ON           *IN99
¢C   C     ECOD##        WHENEQ    'ANS'
¢C   C                   MOVE      *ON           *IN62
¢C   C                   MOVE      *ON           *IN99
¢C   C     ECOD##        WHENEQ    'BNC'
¢C   C                   MOVE      *ON           *IN99
¢C   C                   MOVE      *ON           *IN63
¢C   C     ECOD##        WHENEQ    'LLN'
¢C   C                   MOVE      *ON           *IN99
¢C   C                   MOVE      *ON           *IN65
¢C   C     ECOD##        WHENEQ    'MLT'
¢C   C                   MOVE      *ON           *IN99
¢C   C                   MOVE      *ON           *IN66
¢C   C     ECOD##        WHENEQ    'RNZ'                                         RNZ replaced by RNF
¢C   C                   MOVE      *ON           *IN99
¢C   C                   MOVE      *ON           *IN67
¢C   C     ECOD##        WHENEQ    'SNF'
¢C   C                   MOVE      *ON           *IN99
¢C   C                   MOVE      *ON           *IN68
¢C   C     ECOD##        WHENEQ    'STR'
¢C   C                   MOVE      *ON           *IN99
¢C $IC*                  MOVE      *ON           *IN70
$I   C                   MOVE      *ON           *IN68
¢C   C     ECOD##        WHENEQ    'XST'
¢C   C                   MOVE      *ON           *IN99
¢C $IC*                  MOVE      *ON           *IN71
$I   C                   MOVE      *ON           *IN70
¢C   C     ECOD##        WHENEQ    'NDA'
¢C   C                   MOVE      *ON           *IN99
¢C   C                   MOVE      *ON           *IN72
¢C   C     ECOD##        WHENEQ    'DBE'
¢C   C                   MOVE      *ON           *IN99
¢C   C                   MOVE      *ON           *IN73
¢C   C     ECOD##        WHENEQ    'PGM'
¢C   C                   MOVE      *ON           *IN99
¢C   C                   MOVE      *ON           *IN74
¢C   C     ECOD##        WHENEQ    'RNF'
¢C   C                   MOVE      *ON           *IN99
¢C   C                   MOVE      *ON           *IN67
¢C   C                   ENDSL
¢C   C                   END
¢C    *
¢C    *   EXCEPTION TO THE RULE - BNR IS AN ERROR WHERE THE
¢C    *   DEFAULT VALUE IS TAKEN.
¢C    *
¢C   C  N60
¢C   CAN 64              SETON                                        60
¢C   C   60
¢C   CAN 64              SETOFF                                       64
¢C    *
¢C   C                   ENDSR
      *------------------------------------------------------------------------*
$K    *  PER SORT ADDR VALIDATION FOR SHIPPING ADDRESS
$K    *------------------------------------------------------------------------*
$K   C     PERSRT1       BEGSR
$K   C                   MOVE      *OFF          *IN47
$K   C                   MOVE      *IN99         SVIN99            1
$K   C                   MOVE      *BLANKS       CASE
$K   C                   MOVE      *BLANKS       ECOD##
$K   C                   MOVE      *BLANKS       EMSG##
$K   C                   MOVE      '30'          MAXADRL
$K   C                   MOVE      'S'           ADDRTYPE
$K    * Load shipping address to input parms for validation program
$K   C                   MOVEL     ARNM01        INAME
$K   C                   MOVEL     ARAD04        IADDR1
$K   C                   MOVEL     ARAD05        IADDR2
$K   C                   MOVEL     ARAD06        IADDR3
$K   C                   MOVEL     ARCY02        ICITY
$K   C                   MOVEL     ARST02        ISTATE
$K   C                   MOVEL     ARZP16        IZIP
$K    * Call validation program
$K   C                   CALL      'ARRC104'     PL_ARRC104
$K    * If no errors found, load per zip address
$K   C                   IF        ECOD## = *BLANKS
$K   C                   MOVEL     OADDR1        ARAD04
$K   C                   MOVEL     OADDR2        ARAD05
$K   C                   MOVEL     OADDR3        ARAD06
$K   C                   MOVEL     OCITY         ARCY02
$K   C                   MOVEL     OSTATE        ARST02
$K   C                   MOVEL     OZIP          ARZP16
$K   C                   ENDIF
$K    * If errors found, load error meessage
$K   C     ECOD##        COMP      *BLANKS                                60     ERROR CODE
$K   C     ECOD##        IFNE      *BLANKS
$K   C                   MOVE      *ON           *IN47
$K   C                   MOVE      *ON           *IN99
$K   C                   ENDIF
$K    *
¢K   C                   ENDSR
CN    *------------------------------------------------------------------------*
CN    ** Subroutine ** Call OPC9832
CN    *------------------------------------------------------------------------*
CN   C     srch_index    begsr
CN   C     icsys         ifeq      'Y'
C4    * Determine if licensed to this product...
C4    * The following license key checking logic may not be altered, bypassed or removed.
C4    * See Legal Document in WRKMINKEY command for more information.
C4   C                   if        LicToDII
CN   C                   clear                   qsearch
CN   C                   movel     'QREINDEX'    qsearch
CN   C                   call      'OPC9832'
CN   C                   parm                    qsearch          10
C4    * Display error message if not licensed to DII (IntelliChief)
C4   C                   else
C4   C                   eval       p1300App  = 'DII'
C4   C                   eval       p1300Bypass = 'N'
C4   C                   call      'MNR1300'     pl1300
C4   C                   endif
CN   C                   endif
CN   C                   endsr
      *------------------------------------------------------------------------*
CL    ** SUBROUTINE ** Customer creation event **************              ***
CL    *------------------------------------------------------------------------*
CL   C     CusEvent      BegSR
CL   C                   Eval      cusnamE3    = ARNM01
CL   C                   Eval      cusnumE3    = ARNO01
CL   C                   Eval      cusmailstE3 = ARST01
CL CMC*                  Eval      slsbrnumE3  = NO16
CL CMC*                  Eval      slsidE3     = ID01
CM   C                   Eval      slsbrnumE3  = ARNO16
CM   C                   Eval      slsidE3     = ARID01
CM   C                   Eval      usridE3     = USRNM
CL   C                   Call      'SHC5050'
CL   C                   Parm      'HDE0003'     EventID                        Event Id
CL   C                   Parm                    d_HDE0003
CL   C                   EndSR
CL    *------------------------------------------------------------------------*
C3   C     SRDspSlsID    Begsr
C3    *
C3   C                   eval      sv38 = *in38
C3   C                   eval      sv39 = *in39
C3   C                   eval      sv40 = *in40
C3   C                   eval      sv41 = *in41
C3   C                   eval      oslsid = svid01
C3   C                   eval      nslsid = id01
C3   C                   movea     '0000'        *in(38)
C3    *
C3   C                   IF        %SUBST(JOBNAME:1:3) = 'QQF'
C3   C                   EVAL      addUpd = 'N'
C3   C                   EVAL      jobUpd = 'N'
C3   C                   EVAL      webUpd = 'N'
C3   C                   EVAL      bcbUpd = 'N'
C3   C                   ENDIF
C3    *
C3   C                   dou       msgfld = *blanks
C3   C
C3   C                   exfmt     arf5015d
C3   C                   eval      msgfld = *blanks
C3   C                   movea     '0000'        *in(38)
C3    *
C3    * Call help text
C3   C                   if        *in25 = *on                                  HELP KEY
C3   C                   call      'HTR0010'                                    DSPLY HELP TEXT
C3   C                   parm                    prog                           PROGRAM NAME
C3   C                   parm                    screen                         DISPLAY FORMAT
C3   C                   endif
C3    *
C3   C                   if        (addupd <> 'Y' and
C3   C                             addupd <> 'N')
C3   C                   eval      *in38 = *on
C3   C                   endif
C3    *
C3   C                   if        (jobupd <> 'Y' and
C3   C                              jobupd <> 'N')
C3   C                   eval      *in39 = *on
C3   C                   endif
C3    *
C3   C                   if        (webupd <> 'Y' and
C3   C                              webupd <> 'N')
C3   C                   eval      *in40 = *on
C3   C                   endif
C3    *
C3   C                   if        (bcbupd <> 'Y' and
C3   C                              bcbupd <> 'N')
C3   C                   eval      *in41 = *on
C3   C                   endif
C3    *
C3   C                   if        *in38 = *on or
C3   C                             *in39 = *on or
C3   C                             *in40 = *on or
C3   C                             *in41 = *on
C3   C                   eval      msgfld = 'Value must be (''Y'' or ''N'').'
C3   C                   iter
C3   C                   endif
C3    *
C3   C                   exsr      SrUpdSlsId
C3    *
C3   C                   enddo
C3   C                   eval      *in38 = sv38
C3   C                   eval      *in39 = sv39
C3   C                   eval      *in40 = sv40
C3   C                   eval      *in41 = sv41
C3    *
C3   C                   EndSR
C3    *------------------------------------------------------------------------*
C3   C     srUpdSlsId    Begsr
C3    *
C3    * Update additional addresses subfile with sales id
C3   C                   if        addupd = 'Y'
C3    * If additional address loaded to subfile (F8 was pressed), update
C3    * sales id in format ARS5015I. File will be updated in routine
C3    * UPDSHP.
C3   C                   if        no40s <> *zeros
C3   C                   eval      rni = 1
C3   C                   eval      *in89 = *off
C3   C                   dow       *in89 = *off
C3   C     rni           chain     ars5015i                           89
C3   C                   if        *in89 = *on
C3   C                   leave
C3   C                   endif
C3   C                   eval      id01s = id01
C3   C                   update    ars5015i
C3   C                   eval      rni = 1 +rni
C3   C                   enddo
C3    * If additional address is not loaded to subfile, update file    e
C3    * directly.
C3   C                   else
C3   C                   eval      *in45 = *off
C3   C     arno01        setll     arfmcad
C3   C                   dou       *in45 = *on
C3   C     arno01        reade     arfmcad                                45
C3   C                   if        *in45 = *off
C3   C                   eval      xxid01 = id01
C3   C                   except    upArCad
C3   C                   endif
C3   C                   enddo
C3   C                   endif
C3   C                   endif
C3    *
C3    * Update job master
C3   C                   if        jobupd = 'Y'
C3   C                   eval      *in45 = *off
C3   C     arno01        setll     arfmjbm
C3   C                   dou       *in45 = *on
C3   C     arno01        reade     arfmjbm                                45
C3   C                   if        *in45 = *off
C3   C     brkey1        chain     arfmbch                            46
C3   C                   if        *in46 = *off
C3   C                   eval      arid04 = id01
C3   C                   except    upArJbm
C3   C                   endif
C3   C                   endif
C3   C                   enddo
C3   C                   endif
C3    *
C3    * Update web commerce customer config files
C3   C                   if        webupd = 'Y'
C3    *
C3   C                   eval      *in45 = *off
C3   C     balkey        setll     oefmcus
C3   C                   dou       *in45 = *on
C3   C     balkey        reade     oefmcus                                45
C3   C                   if        *in45 = *off
C3   C                   eval      wcsalid = id01
C3   C                   except    upOeCus
C3   C                   endif
C3   C                   enddo
C3    *
C3   C                   eval      *in45 = *off
C3   C     lkey          setll     oefmusr3
C3   C                   dou       *in45 = *on
C3   C     lkey          reade     oefmusr3                               45
C3   C                   if        *in45 = *off
C3   C                   eval      xarid01 = id01
C3   C                   except    upOeUsr
C3   C                   endif
C3   C                   enddo
C3   C                   endif
C3    * Update B2C/B2B customer config files
C3   C                   if        BCBupd = 'Y'
C3    *
C3   C                   eval      *in45 = *off
C3   C     balkey        setll     aifmcus
C3   C                   dou       *in45 = *on
C3   C     balkey        reade     aifmcus                                45
C3   C                   if        *in45 = *off
C3   C                   eval      bcsalid = id01
C3   C                   except    upAiCus
C3   C                   endif
C3   C                   enddo
C3    *
C3   C                   eval      *in45 = *off
C3   C     lkey          setll     aifmusr4
C3   C                   dou       *in45 = *on
C3   C     lkey          reade     aifmusr4                               45
C3   C                   if        *in45 = *off
C3   C                   eval      yarid01 = id01
C3   C                   except    upAiUsr
C3   C                   endif
C3   C                   enddo
C3    *
C3   C                   eval      *in45 = *off
C3   C     lkey          setll     aifmrcf
C3   C                   dou       *in45 = *on
C3   C     lkey          reade     aifmrcf                                45
C3   C                   if        *in45 = *off
C3   C                   eval      zarid01 = id01
C3   C                   except    upAiRcf
C3   C                   endif
C3   C                   enddo
C3   C                   endif
C3    *
C3   C                   EndSR
C3    *------------------------------------------------------------------------*
DQ    * THIS SUBROUTINE RETRIEVES ITEM MASTER ADD-ON DATA
DQ    *------------------------------------------------------------------------*
DQ         Begsr @RetrieveAddOnData ;
DQ
DQ            clear arcdl1;
DQ            exec sql
DQ              select customerClassCode
DQ              Into
DQ              :arcdl1
DQ              from arq5015b
DQ              where customerNumber = :arno01;
DQ
DQ         Endsr;
DQ    *------------------------------------------------------------------------*
DQ    * THIS SUBROUTINE VALIDATES CUSTOMER CLASS CODES
DQ    *------------------------------------------------------------------------*
DQ         Begsr @ValidCusClass ;
DQ
DQ            exec sql
DQ              select count(*)
DQ              Into
DQ              :sqlcount
DQ              from arq5015a
DQ              where upper(customerClassCode) = upper(:ARCDL1);
DQ
DQ         Endsr;
DQ    *------------------------------------------------------------------------*
DQ    * THIS SUBROUTINE PROCESSES THE CUSTOMER ADD ON FILE
DQ    *------------------------------------------------------------------------*
DQ         Begsr @ProcessAddOnFile ;
DQ
DQ            exec sql
DQ              select count(*)
DQ              Into
DQ              :sqlcount
DQ              from arq5015b
DQ              where customerNumber = :arno01;
DQ
DQ            if sqlcount = 0;
DQ              exsr @InsertToAddOnFile;
DQ            else;
DQ              exsr @UpdateAddOnFile;
DQ            endif;
D5             exsr   WRITMACO;
DQ
DQ         Endsr;
DQ    *------------------------------------------------------------------------*
DQ    * THIS SUBROUTINE WRITES TO THE CUSTOMER ADD ON FILE
DQ    *------------------------------------------------------------------------*
DQ         Begsr @InsertToAddOnFile ;
DQ
DQ            exec sql insert into arq5015b
DQ                 (
DQ                  customerNumber,
DQ                  customerClassCode,
DQ                  userMaintId
DQ                 )
DQ                values
DQ                 (
DQ                  :arno01,
DQ                  :arcdl1,
DQ                  :usrnm
DQ                 );
DQ
DQ
DQ         Endsr;
DQ    *------------------------------------------------------------------------*
DQ    * THIS SUBROUTINE UPDATES THE CUSTOMER ADD ON FILE
DQ    *------------------------------------------------------------------------*
DQ         Begsr @UpdateAddOnFile ;
DQ
DQ            exec sql update arq5015b set
DQ                customerClassCode = :arcdl1,
DQ                userMaintId = :usrnm
DQ              where customerNumber = :arno01;
DQ
DQ         Endsr;
DQ    *------------------------------------------------------------------------*
DZ    *  ACTVDP - SUBROUTINE: CHECK FOR OPEN DEPOSITS
DZ    *------------------------------------------------------------------------*
DZ   C     ACTVDP        BEGSR
DZ    *
DZ   C                   MOVE      'N'           ACTIVDEP          1
DZ   C                   MOVE      *IN91         SVIN91            1
DZ    *
DZ   C     ARNO01        SETLL     OEFTDP
DZ   C     ARNO01        READE     OEFTDP                                 91
DZ   C     *IN91         DOWEQ     *OFF
DZ    *
DZ   C     OECD50        IFEQ      'O'
DZ   C     OECD50        OREQ      'P'
DZ   C                   MOVE      'Y'           ACTIVDEP
DZ   C                   ENDIF
DZ    *
DZ   C     ARNO01        READE     OEFTDP                                 91
DZ   C                   ENDDO
DZ    *
DZ   C                   MOVE      SVIN91        *IN91
DZ    *
DZ   C                   ENDSR
DZ    *------------------------------------------------------------------------*
D5    *----------------------------------------------------*
D5    * Write/Update ARPMACO                               *
D5    *----------------------------------------------------*
D5   C     WRITMACO      BEGSR
D5   C                   IF         UpdFlg  =  'Y'
D5    * Checking for Record Lock
D5   C     ACOKEY        Chain     ARFMACO                            4092
D5   C     *IN92         IFEQ      '1'
D5   C                   MOVE      *BLANKS       DSPF1
D5   C                   MOVE      *BLANKS       DSPF2
D5   C                   CALL      'OPC1002'     RLOCK
D5   C                   EndIf
D5    * Moving Data
D5   C                   MOVE      TYPCOD        ARCDN0
D5   C                   Eval      RCNO05 = %dec(PoLat:15:7)
D5   C                   Eval      RCNO06 = %dec(PoLng:15:7)
D5   C                   MOVE      USRNM         ARNM03
D5   C                   Z-ADD     UDAY          ARDY09
D5   C                   Z-ADD     UMONTH        ARMO09
D5   C                   MOVEL     *YEAR         ARCC09
D5   C                   Z-ADD     UYEAR         ARYR09
D5    *
D5   C                   If        *In40= *On
D5   C                   Write     ARFMACO
D5   C                   Else
D5   C                   Update    ARFMACO
D5   C                   EndIf
D5    *
D5   C                   EndIf
D5   C                   ENDSR
D5    *----------------------------------------------------*
D5    * Write/Update ARPMACO                               *
D5    *----------------------------------------------------*
D5   C     WRITMACO1     BEGSR
D5   C                   IF         CNO05S  > 0  And  CNO05S >0
D5    * Checking for Record Lock
D5   C     ACOKEY1       Chain     ARFMACO                            4092
D5   C     *IN92         IFEQ      '1'
D5   C                   MOVE      *BLANKS       DSPF1
D5   C                   MOVE      *BLANKS       DSPF2
D5   C                   CALL      'OPC1002'     RLOCK
D5   C                   EndIf
D5    * Moving Data
D5   C                   MOVE      'CADD'        ARCDN0
D5   C                   Eval      RCNO05  =     CNO05S
D5   C                   Eval      RCNO06  =     CNO06S
D5   C                   MOVE      USRNM         ARNM03
D5   C                   Z-ADD     UDAY          ARDY09
D5   C                   Z-ADD     UMONTH        ARMO09
D5   C                   MOVEL     *YEAR         ARCC09
D5   C                   Z-ADD     UYEAR         ARYR09
D5    *
D5   C                   If        *In40= *On
D5   C                   Write     ARFMACO
D5   C                   Else
D5   C                   Update    ARFMACO
D5   C                   EndIf
D5    *
D5   C                   EndIf
D5   C                   ENDSR
D5    *------------------------------------------------------------------------*
$M   C     SORTNMSR      BEGSR
$M         svin28 = *in28;
$M         clear *IN28;
$M         tbno01 = 'CLTY';
$M         tbno02 = 'SORTNAME';
$M         clear tbno03;
$M         Hydros_Flg = 'N';
$M    //   Check sort name prefix to see if it's a hydros customer
$M         If   %subst(ARNM05:1:6) = Hydros_Prfx;
$M    //           Set up like paramter to check table file for hydros customer
$M            srtnm_Hydros = %trimr(ARNM05) + '%';
$M    //           Check to see if Sort Name is set up in table file
$M            Exec SQL
$M               SELECT 'Y', tbno03 INTO :Hydros_Flg, :tbno03
$M                 FROM tblmtbl4
$M               WHERE tbno01 = :tbno01 and tbno02 = :tbno02
$M                 and tbno03 LIKE :srtnm_Hydros
$M                 with NC;
$M    //  If the sortname has a 'HYDROS' prefix and not found it TB, set error
$M            SELECT;
$M              WHEN Hydros_Flg <> 'Y' ;
$M                 *IN(99) = '1';
$M                 *IN28 = *ON;
$M            OTHER;
$M              Hydros_flg = 'Y';
$M              SvSrtName  = ARNM05;
$M            EndSl;
$M         EndIf;
$M   C                   ENDSR
$M    *------------------------------------------------------------------------*
$O   C     ACCTMXSR      BEGSR
$O         tbno01 = 'ARAM';
$O         tbno02 = 'DFTMTX';
$O         clear tbno03;
$O            Exec SQL
$O               SELECT 'Y', tbno03 INTO :AccMtx_Flg, :tbno03
$O                 FROM tblmtbl4
$O               WHERE tbno01 = :tbno01 and tbno02 = :tbno02
$O                 with NC;
$O         If AccMtx_Flg = 'Y';
$O           PRCLV1 = TBEqp;
$O           PRCLV2 = TBSup;
$O           PRCLV3 = TBPrt;
$O           PRCLV4 = TBTls;
$O           PRCLV5 = TBCom;
$O         EndIf;
$O   C                   ENDSR
$O    *------------------------------------------------------------------------*
     OFHBAL     E            UPHBAL
     O                       NM05
   CNO*ARFMENT   E            DUMMY
CN   OARFMENT   E            DUMMY1
C3   Oarfmcad   e            upArCad
C3   O                       xxid01
C3   Oarfmjbm   e            upArJbm
C3   O                       arid04
C3   Ooefmcus   e            upOeCus
C3   O                       wcsalid
C3   Ooefmusr3  e            upOeUSr
C3   O                       xarid01
C3   Oaifmcus   e            upAiCus
C3   O                       bcsalid
C3   Oaifmusr4  e            upAiUsr
C3   O                       yarid01
C3   Oaifmrcf   e            upAiRcf
C3   O                       zarid01
      *------------------- TABLE FILE CHANGE AREA -----------------------------*
CC    *Added entry 7 to UMS.                                           --------*
CC    *Added table DIST                                                --------*
B4    * ADDED UMS,8
B4    * Value must be 'R' or 'C'.
CD    * ADDED UMS,9
CD    * Web commerce account exists, cannot close account.
CI    * ADDED entries 61 thru 62 to EMS.
CJ    * Added EMS entries 63-65
CJ    * F3 not allowed when creating like customer.                                   63
CJ    * F10 allowed only on last screen when creating like customer.                  64
CJ    * F11 not allowed when creating like customer.                                  65
DQ    * Invalid PCAR customer class code.                                             66
¢D    * ADDED CMS TABLE
¢7    * ADDED CMS TABLE entry 12 13
$H    * ADDED CMS TABLE entry 14
$M    * ADDED CMS TABLE entry 15
      *------------------------------------------------------------------------*
** MSG
Invalid cursor location for F4=Prompt.
** EMS
Warning! There are existing cash orders for this account.                     01
Value must be ('Y' or 'N').                                                   02
Value must be ('B' or 'O').                                                   03
Market Class/Sales Type Code not valid.                                       04
Delivery Tax Jurisdiction not found or not attached to zip code.              05
Pickup Tax Jurisdiction not found.                                            06
Value must be ('Y', 'N' or ' ').                                              07
Credit hold flag does not match enterprise.  Lock flag must be Y.             08
Warning! Unlocked values that do not match enterprise will be lost.           09
Customer belongs to a cash enterprise.  Customer must also be cash.           10
Customer belongs to an enterprise. May not be a generic cash account.         11
Enter correct date account was opened.                                        12
Enter credit limit.                                                           13
Cannot enter discount percent if terms equals no.                             14
Discount percent cannot be negative.                                          15
Cannot enter both due day and due in number of days.                          16
Due day cannot be negative or greater than 31.                                17
Number of days cannot be negative.                                            18
Grace day cannot be negative.                                                 19
Invalid discount profile number.                                              20
Cannot make more than one selection.                                          21
Enter 'D' for daily or 'W' for weekly.                                        22
Cannot enter both print weekly and print monthly.                             23
Number of copies cannot be 0 if "Print" type is specified.                    24
Enter print weekly or print monthly.                                          25
Cannot enter both print on day of week and print on day of month.             26
Enter print on day(s) of month.                                               27
Cannot enter print on day(s) of month if print monthly not equal to 'M'.      28
Cannot select all days of week if print frequency equal 'W' for Weekly.       29
Enter 'M' for print monthly.                                                  30
Enter print on day(s) of week.                                                31
Enter a valid day of month(1 through 31).                                     32
Must enter first day of month prior to third day of month.                    33
Must enter second day of month prior to third day of month.                   34
Must enter first day of month prior to second day of month.                   35
Cannot enter invoice print type 'F' nor 'B' if fax number is zero.            36
Invoice print type must be 'F' or 'P/F' before pressing F9 function key.      37
Cannot enter fax s/o acknowledgement 'Y' if fax number is zero.               38
Cannot select 'F','P/F' if Fax/Email Sales Order/Invoice is not equal to 'F'. 39
Invalid branch number.                                                        40
Branch number does not exist in this company.                                 41
Branch number required.                                                       42
Salesperson ID required.                                                      43
Salesperson ID invalid.                                                       44
One company required.                                                         45
Credit limit required.                                                        46
Credit limit cannot be less than zero.                                        47
Credit representative ID invalid.                                             48
Invalid method of shipment.                                                   49
Method of shipment/Ship code invalid.                                         50
Cannot select 'E','P/E' if Fax/Email Sales Order/Invoice is not equal to 'E'. 51
Value must be 'F', 'E', or 'N'.                                               52
Value must be 'F', 'E', 'N', or ' '.                                          53
Email ability is not currently set up. Cannot specify 'E'.                    54
Cannot specify 'E' if email address is blank.                                 55
Invalid terms code entered.                                                   56
Warning, zip code has been changed.                                           57
Invalid tax exemption expiration date.                                        58
Cannot enter print statement 'F' or 'P/F' if fax number is zero.              59
Print statement must be 'F' or 'P/F' before pressing F9 function key.         60
Invalid customer service representative id.                                   61
Cannot access customer contacts because you are already in that same program. 62
F3 not allowed when creating like customer.                                   63
F10 allowed only on last screen when creating like customer.                  64
F11 not allowed when creating like customer.                                  65
Invalid PCAR customer class code.                                             66
** UMS
Warning! No invoices will print for this customer.                            01
Exemption number required.                                                    02
There is an error on one or more screens. Correct it before F10=Update.       03
There is an error on one or more screens. Correct it before F11=Close.        04
No update if F3 is pressed again.                                             05
Print type required if number of invoice copies is greater than 0.            06
Fax information available upon selecting statement or invoice faxing.         07
Value must be 'R' or 'C'.                                                     08
Web commerce account exists, cannot close account.                            09
** CMS
Consolidate Fax must be 'N' if Inv Prt Type = P or N                          01
Consolidate Print must be 'N' if Inv Prt Type = F                             02
Terms required for charge customers                                           03
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX        04
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX        05
Invalid Mkt Typ (AM GM MC MS RN RR SM WH)                                     06
Price level valid values are 1, 2, 3, 4, 5, 6 or blank.                       07
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                 08
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX        09
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                 10
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX        11
Enter valid date for Last Review Date                                         12
Last Review Month/Year must be less than current date                         13
Credit limit entered exceeds your preset user/group limit.                    14
Company/Branch does not match Sort Name requirements.                         15
** DIST
X
  X
    X
