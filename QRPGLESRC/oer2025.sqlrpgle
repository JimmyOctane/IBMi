EL   H option(*srcstmt: *nodebugio) debug
       ctl-opt DFTACTGRP(*NO) actgrp(*CALLER);
       ctl-opt bnddir('SHBIND':'WMBIND':'HDBIND':'WKBIND':'MNBIND':'YAJL'
         :'ECBIND');
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - OER2025                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D  PRINT PICK TICKET                                                    *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    PRINT A PICKING TICKET                                             *
     F*S                                                                       *
     F*S   Important: When changing this program, you must also             *
     F*S               review OER2036 for any possible changes.              *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
DD   F*E 8000009801 051706 168 ADD PRINTER FRIENDLY BUTTON TO DOCS             *
DE   F*U 1090000293 052206 248 PRINT/FAX/EMAIL NET PRICES                      *
DF   F*E 8000009883 080106 907 SERIAL# TRACKING FOR ALL TRANSACTIONS           *
DH   F*E 8000009887 091406 907 ADD PACKING LIST LOGIC                          *
DI   F*E 8000009966 010807 913 CHANGE S/O NUMBER TO 7 CHARS ALPHA              *
DJ   F*E 8000009967 011807 070 CHANGE INVOICE NUMBER LOGIC                     *
DK   F*U 8000010073 011907 070 A/R TRANSACTION NUMBER ASSIGNMENT               *
DL   F*E 8000010108 041107 915 HD changes for WM Interface                     *
DM   F*E 8000010162 041808 914 MINCRONIZE RGA FOR NEXT RELEASE
DP   F*E 8000010245 072308 913 PRINT TOTALS ON CASH TICKETS                    *
DR   F*U 1090000420 092209 915 RGA CREDIT MEMO PRINT MISSING QTY               *
DS   F*U 0930000291 111110 097 RGA PENDING CREDIT MEMO PRINTING LIST           *
DT   F*U 1020000202 041211 248 PRINT PRICES NO & N/C NOT PRINTING              *
DU   F*U 0970000302 120511 915 DEPOSIT RECEIPT PRINT LOCATIONS                 *
DV   F*U 0930000300 082812 915 OEC2025 LOCK ON TBLMTBL1                        *
DW   F*U 0970000476 100512 144 PICK TICKET OVERFLOW DUE TO MSDS                *
DX   F*E 8000010983 111012 171 B2C/B2B CREDIT CARD INTERFACE                   *
DY   F*E 8000011207 022013 915 PRINT TOTALS ON PICK TICKET                     *
DZ   F*E 0970000535 092013 930 CREDIT ONLY REASON CODE - OER2025               *
D1   F*E 8000011209 093014 119 CREDIT CARD PROCESSING                          *
D0   F*U 0620000153 121713 915 Cash inv not print invoice comment              *
D2   F*U 8000012683 060616 923 CHG FORMAT OF ADDR AND ZIP-FORM SOL             *
D3   F*E 8000012436 110316 915 Curbstone C2 to C3 conversion                   *
D4   F*E 8000012571 082117 019 Apache FOP Project - Forms Solution             *
EA   F*U 8000012932 060118 915 Remit to addr missing city/st                   *
EC   F*U 1710000887 111418 171 Invoices lock with TBPMTBL                      *
EE   F*U 1800000240 030119 915 Table drive print item number on PT             *
EF   F*E 8000013122 041019 915 Card Connect - Credit card process              *
EH   F*U 8000013359 100719 915 Avatax internet down issue                      *
EI   F*E 8000013476 101119 171 Card Connect- Name and last 4 of card not print *
EJ   F*U 8000013570 021720 915 Rmv tax flag from pick tckt print               *
EK   F*U 1800000271 031320 915 Void credit card info print on invoice          *
EL   F*C 1820000123 061120 404 Include backorder lines on quote totals         *
EM   F*C 0910000582 061820 019 Exclude Lost Sale Items from pickticket         *
EN   F*E 0840000376 102920 007 ADD DISCLAIMER TO PICK TICKETS                  *
EO   F*E 2030000100 050621 404 PRINT DECIMALS FOR DM UOM                       *
EP   F*U 2030000106 061821 097 PRINT DECIMALS FOR DM UOM adjustment            *
ER   F*U 1710001103 091721 404 Change Key in Order Print Ticket                *
ES   F*E 1290000727 100121 171 Worldpay - Credit card processing               *
ET   F*C 1980000150 101421 404 add additional information                      *
EV   F*E 8000014036 022322 171 Worldpay - changes for certification            *
EW   F*U 2030000122 040422 404 GSST Not in Acknowldgement Total                *
EX   F*U 1220002081 041222 035 ENLARGE PASSED PARAMETERS                       *
EY   F*E 1890000197 051322 404 BACKORDERS BY VENDOR OR SGC                     *
EZ   F*E 8000014081 062422 404 COLORADO RETAIL DELIVERY FEE/TAX                *
E0   F*E 1400000502 092022 171 INCREASE DEVICE SERIAL# LENGTH                  *
E1   F*E 1400000500 020823 171 Credit Card Processing Fee                      *
E3   F*U 1890000221 092123 404 AR INVOICING DECIMAL DATA ERROR                 *
¢A   F*U KSB   8117 120720 KSB Print Weight, Br Ship Addr, Mfg#, Daikin Serial *
¢B   F*U CLP   6937 121720 CLP Ignore promise date in order detail file        *
¢C   F*U APB   9197 011921 APB ADD CC VERBIAGE IF CARD IS SAVED ON FILE        *
¢D   F*U APB   9199 012221 APB Modify SQL for CC verbiage                      *
¢E   F*U APB   9273 010522 APB Put in a fix to prevent the cc verbiage from    *
¢E   F*U                       writing multiple times.                         *
¢F   F*C DCB   7301 011322 DCB CONSUMABLE TAX CHANGES                          *
¢G   F*C APB   9345 062923 APB REMOVE CONSUMABLE TAX CHANGES                   *
¢H   F*C 0430000331 102423 097 mod conflicts OET2036 also                      *
¢I   F*C APB   3200 090225 APB REMOVE phone number under Remit to address and  *
     F*C                       add a TF for a future number                    *
¢J   F*C xxx   9999 042926 xxx Add printInPOSequence logic and OELTOL9 file    *
     F*M ----------------------------------------------------------------------*
   EKF*ARLTCCT1  IF   E           K DISK
EK   FARLTCCTB  IF   E           K DISK
     FARLMRES1  IF   E           K DISK
     FIVLMRSB1  IF   E           K DISK
     FOELTOH1   UF   E           K DISK
     FOELTOL5   UF   E           K DISK    INFDS(ERRDS2) USROPN
¢J   FOELTOL9   UF   E           K DISK    USROPN
¢J   F                                     RENAME(OEFTOL:OEFTOL2)
     FOELTOT1   IF   E           K DISK
     FARLMCUS1  IF   E           K DISK
     FIVLMLOC1  IF   E           K DISK
     FIVLMUOM1  IF   E           K DISK
     F                                     RENAME(IVFMUOM:IVFMUOM1)
     FIVLMUOM3  IF   E           K DISK
     FIVLMSTR8  IF   E           K DISK
     FIVLMEXT1  IF   E           K DISK
     FIVLMALI4  IF   E           K DISK    USROPN
     FARLMAAD1  IF   E           K DISK
     FOELTOA1   IF   E           K DISK
     FOELTOM1   IF   E           K DISK
     FOELTOC1   IF   E           K DISK
     FOELTOR1   IF   E           K DISK
E1   FOELTOR3   IF   E           K DISK    RENAME(OEFTOR:OEFTOR3)
     FIVLTNSK5  IF   E           K DISK    INFDS(ERRDS1)
     FARLTWI1   IF   E           K DISK    USROPN
     FARLTWI2   IF   E           K DISK    USROPN
     F                                     RENAME(ARFTWI:ARFTWI2)
     FTBLMTBL1  UF   E           K DISK
     FARLMJBM1  IF   E           K DISK
     FARLMJBA1  IF   E           K DISK
     FARLMENT1  IF   E           K DISK
     FOET2025   O    E             PRINTER USROPN
DD   F                                     INFDS(FIL1DS)
     FARLMBCH4  IF   E           K DISK
     FRCLMCCS1  IF   E           K DISK
     FARLTNT2   IF   E           K DISK
   DFF*OELTSR3   IF   E           K DISK
DF   FIVLTSRL6  IF   E           K DISK
     FOELTDD2   IF   E           K DISK    USROPN
     FOELTDD3   IF   E           K DISK    USROPN
     F                                     RENAME(OEFTDD:OEFTDD3)
     FOELTDP1   UF   E           K DISK    USROPN
     FOELTDP4   UF   E           K DISK    USROPN
     F                                     RENAME(OEFTDP:OEFTDP4)
     FOELTOHYM  IF   E           K DISK
     FOELTOH26  IF   E           K DISK
     F                                     RENAME(OEFTOH:OEFTOH26)
     FIVLTLOT1  IF   E           K DISK
     FIVLMSBR1  IF   E           K DISK
     FARLMTRD1  IF   E           K DISK
     FHZLMSIN1  IF   E           K DISK
DK   FARLTRAN1  IF   E           K DISK
EH   Foeltotx1  if   e           k disk    prefix(x)
DJ    *------------------------------------------------------------------------*
DJ    /COPY QCPYSRC,HDYPROTO
DJ    *----------------------------------------------------------------
      *------------------------------------------------------------------------*
     D TA              S             12    DIM(7) CTDATA PERRCD(1)
     D ALI             S              1    DIM(48) CTDATA PERRCD(48)
     D MAD             S             30    DIM(5)                               MAIN ADDRESS ARAY
     D SAD             S             30    DIM(5)                               SHIP ADDRESS ARAY
     D COM             S             40    DIM(6)                               SPECIAL INSTRUCTI
     D OT              S             15    DIM(6) CTDATA PERRCD(1)              ORDER TYPE
     D OS              S             15    DIM(5) CTDATA PERRCD(1)              ORDER STATUS
   DXD*CS              S              1    DIM(5) CTDATA PERRCD(1)              CARD STATUS
   DXD*DS              S              8    DIM(5) ALT(CS)
DX   D CS              S              1    DIM(6) CTDATA PERRCD(1)              CARD STATUS
DX   D DS              S              8    DIM(6) ALT(CS)
     D HZ1             S              1    DIM(51) CTDATA PERRCD(51)            HAZ 1 LINE
     D HZ2             S              1    DIM(51) CTDATA PERRCD(51)            HAZ 2 LINE
D1 EF * Parms passed to/from OER9600...
EF    * Parms passed to/from from card interface program
D1   D piMode          S              3    inz
D1   D piRetry         S              1    inz
D1   D piUpdError      S              1    inz
D1   D piTran          S              7    inz
D1 ESD*piMFUKEY        S             15    inz
ES   D piMFUKEY        S             19    inz
D1   D piOrgOrd        S              7    inz
D1   D piMethod        S              2    inz
D1   D piTrnDtl        S              1    inz
D1   D piTrnAmt        S              9  2 inz
D1   D piTaxable       S              1    inz
D1   D piTaxAmt        S              9  2 inz
D1   D poSuccess       S              1    inz
D1   D poMsg           S             78    inz
D1   D poData          S            256    inz
D1   D piData          S            256    inz
EH   D c@notax         c                   'TAX NOT INCLUDED'
D1    *------------------------------------------------------------------------*
D2   DLINEOUT2         S             30
D2   DLINEOUT3         S             30
D2   DLINEOUT4         S             30
D2   DLINEOUT5         S             30
D2   DLineInM2         S             30
D2   DLineInM3         S             30
D2   DLineInMC         S             25
D2   DLineInMS         S              2
D2   DLineInMZ         S             10
D2   DLineInS2         S             30
D2   DLineInS3         S             30
D2   DLineInSC         S             25
D2   DLineInSS         S              2
D2   DLineInSZ         S             10
D2   DLineInAd2        S             30
D2   DLineInAd3        S             30
D2   DLineInAcy        S             25
D2   DLineInAst        S              2
D2   DLineInAzp        S             10
D2   DLineInsa2        S             30
D2   DLineInsa3        S             30
D2   DLineInscy        S             25
D2   DLineInsst        S              2
D2   DLineInszp        S             10
     D                SDS
     D  PROG                   1      8
DD   D  PRMCNT                37     39  0
     D  USRNM                254    263
     D  DSPERR                91    160
     D ERRDS1          DS
     D  FIL1             *FILE
     D  REC1             *RECORD
     D  OP1              *OPCODE
     D  STS1             *STATUS
     D  RTN1             *ROUTINE
     D ERRDS2          DS
     D  FIL2             *FILE
     D  REC2             *RECORD
     D  OP2              *OPCODE
     D  STS2             *STATUS
     D  RTN2             *ROUTINE
     D                 DS
     D  ORDBR                  1     17
     D  ORDER                  1      7
     D  BR                     8     10
     D  TYPE                  11     11
     D  REPRNT                12     12
     D  PRTPRC                13     13
     D  PRTINV                15     15
     D  PICSEQ                16     16
     D                 DS
     D  ARNO07                 1      3  0
     D  ARNO08                 4      6  0
     D  ARNO09                 7     10  0
     D  TEL                    1     10  0
     D                 DS
     D  ARMO05                 1      2  0
     D  ARDY05                 3      4  0
     D  ARYR05                 5      6  0
     D  ARDS05                 1      6  0
     D                 DS
     D  ARMO06                 1      2  0
     D  ARDY06                 3      4  0
     D  ARYR06                 5      6  0
     D  ARDS06                 1      6  0
     D                 DS
     D  OEMO10                 1      2  0
     D  OEDY10                 3      4  0
     D  OEYR10                 5      6  0
     D  OEDS10                 1      6  0
     D                 DS
     D  OEMO11                 1      2  0
     D  OEDY11                 3      4  0
     D  OEYR11                 5      6  0
     D  OEDS11                 1      6  0
ET   D                 DS                  INZ
ET   D  OEMO07                 1      2  0
ET   D  OEDY07                 3      4  0
ET   D  OEYR07                 5      6  0
ET   D  PromDt                 1      6  0
     D                 DS
     D  OEMO01                 1      2  0
     D  OEDY01                 3      4  0
     D  OEYR01                 5      6  0
     D  DINV                   1      6  0
     D                 DS
   DJD* INVNUM                 1      7  0
DJ   D  INVNUM                 1      7
     D  INV#A                  1      7
     D  INVDTE                 8     15  0
¢a ¢HD*                DS
¢a ¢HD* OEMO07                 1      2  0
¢a ¢HD* OEDY07                 3      4  0
¢a ¢HD* OEYR07                 5      6  0
¢a ¢HD* PRMDTE                 1      6  0 Inz
     D  ORDINV                22     24
     D  PSTCSH                25     27
     D  INVDTA                 1     30
DJ    *
DJ   d outTransNo      ds             8
DJ   d   excNumber                    1a   Inz(*blanks)
DJ   d   highNumber                   7a   Inz(*blanks)
DJ    *
     D                 DS
     D  IVMO44                 1      2  0
     D  IVDY44                 3      4  0
     D  IVYR44                 5      6  0
     D  EXPDTE                 1      6  0
D1   D                 DS
D1   D  USING_CARD             1      1
D1 EFD* CARD_SOFTWARE          2     30
EF   D  Card_Software          2     16
D1   D  CARD_TABENTRY          1     30
D1   D                 DS                  INZ
D1   D  EXPDT                  1      4  0
D1   D  EXPMO                  1      2  0
D1   D  EXPYR                  3      4  0
D1 EF * Data structure returned from OER9600
EF    * Data structure returned from card interface program
D1   D inqDATA         DS
D1   D  inqCARD                      20
D1   D  inqEDAT                       4
D1   D  inqNAME                      40
D1   D  inqRVND                      16
D1   D  inqAMT1                      15  5
D1 EFD* inqMRCH                       5
EF   D  inqMRCH                      20
D1   D  inqSettleSts                  1
D1   D  inqSETR                      15  5
      *----------------------------------------------------------------
      * Order header
     D                 DS                  INZ
     D  HDDTA1                 1    256
   DLD* HDNO01                 1      7  0
DL   D  HDNO01                 1      7
      * WM data
     D                 DS                  INZ
      * WM time entered
     D  WMDTA1                 1    256
     D  WMTMEN                 1      6  0
      * WM date entered
     D  WMDTEN                 7     14  0
      * WM time completed
     D  WMTMCM                15     20  0
      * WM date completed
     D  WMDTCM                21     28  0
      *----------------------------------------------------------------
      * Lot data item
     D                 DS                  INZ
     D  HDDTA2                 1    256
   DLD* HD2ORD                 1      7  0
DL   D  HD2ORD                 1      7
     D  HD2ITM                 8     14  0
     D  HD2NSI                15     26
      * WM data
     D                 DS                  INZ
     D  WMDTA2                 1    256
     D  WM2QTY                 1      7  0
     D  WM2UOM                 8     10
     D  WM2LOT                11     30
      *----------------------------------------------------------------
      * WM location
     D                 DS                  INZ
     D  HDDTA3                 1    256
   DID* HD3ORD                 1      7  0
DI   D  HD3ORD                 1      7
     D  HD3CTL                 8     10  0
      * WM data
     D                 DS                  INZ
     D  WMDTA3                 1    256
     D  WM3QTY                 1      7  0
     D  WM3UOM                 8     10
     D  WM3OUT                11     30
     D  WM3PKR                31     45
      *----------------------------------------------------------------
     D                 DS
     D  WMCOBR                 1      6
     D  WMCO#                  1      3  0
     D  WMBR#                  4      6  0
      *
     D NOHIT           C                   CONST('NOT FOUND')
     D VRHDG1          C                   CONST('REASON:')
     D VRHDG2          C                   CONST('TAG#:')
     D VRHDG3          C                   CONST('RTN AUTH#:')
     D SNHDG           C                   CONST('SERIAL#:')
¢A   D MFGHDG          C                   CONST('MFG#:')
     D                 DS                  INZ
     D  GRP1AM                 1      1
     D  GRP2AM                 2      2
     D  GRP3AM                 3      3
     D  GRP4AM                 4      4
     D  GRP5AM                 5      5
     D  GRP6AM                 6      6
     D  GRP1AD                21     21
     D  GRP2AD                22     22
     D  GRP3AD                23     23
     D  GRP4AD                24     24
     D  GRP5AD                25     25
     D  GRP6AD                26     26
     D  AGEOPT                 1     40
     D                 DS                  INZ
     D  DSDATE                 1     53
     D  CO#                    1      3  0
     D  NOTUSD                 4      7  0
     D  PROX                   8      8
     D  AGEMOD                 9      9
     D  BILLPD                10     15  0
     D  BILLCC                10     11  0
     D  BILLYR                12     13  0
     D  BILLMO                14     15  0
     D  BILLCY                10     13  0
     D  TRANDT                16     23  0
     D  TRANMO                16     17  0
     D  TRANDY                18     19  0
     D  TRANCC                20     21  0
     D  TRANYR                22     23  0
     D  DISCDT                24     31  0
     D  DISCMO                24     25  0
     D  DISCDY                26     27  0
     D  DISCCC                28     29  0
     D  DISCYR                28     31  0
     D  DUEDAT                32     39  0
     D  DUEMO                 32     33  0
     D  DUEDY                 34     35  0
     D  DUECC                 36     37  0
     D  DUEYR                 38     39  0
     D  TMCD26                40     41  0
     D  TMNOC6                42     43  0
     D  TMCDB6                44     46  0
     D  TMDY88                47     48  0
     D  TMNOC7                49     50  0
     D  TMNOC8                51     53  0
     D                 DS                  INZ
     D  DDSCMO                32     33  0
     D  DDSCDY                34     35  0
     D  DDSCYR                36     39  0
     D  DATDSC                32     39  0
EO    *
EO   D                 DS
EO   D  #TBNO3                 1      7
EO   D  @UOM                   1      3
EO   D  @FCT                   4      6
EO   D  #FCT                   4      6  0
EO   D  @DECIMAL               7      7
EO   D  #DECIMAL               7      7  0
DD    *
DD   D FIL1DS          DS
DD   D  SPLNAM               103    112  0
DD   D  SPLNBR               123    124B 0
D1    * PiDet to contain tran type & override zip or ship zip.
D1   D  piDet          ds
D1   D   trantyp                      1    inz(' ')
EF   D   custmr                      10
EF    * Purchase order as reference transaction
EF   D   pono#                       22
EF   D   oezp03                      10
EF   D   brnch#                       3  0 inz
EF    * This flag controls saving and display of credit card info in
EF    * Curbstone processing.
EF   D   dspCrdFlg                    1
EF    * This param is passed only for interactive refunds, for Curbstone
EF    * (order/deposit maintenance)
EF   D   cardtype                     4
EF    * Device serial number to be sent for CardConnect                e
EF E0D*  DevSerial#                  20
E0   D   DevSerial#                        like(arnof5)
EF    *
D3   D  obj            s             10    inz(*blanks)
D2   D shad11          s                   like(arad11)
D2   D shcy04          s                   like(arcy04)
D2   D shst04          s                   like(arst04)
D2   D shzp18          s                   like(arzp18)
EF   D card_interface  s              1
EH   D wDefTax         s              1
EH   D AvaTaxActive    s              1
EJ   D trn_typ         s              3    inz('S/O')
EL   D ExtendQte       S              1    inz(' ')
EM   D ExcludeLost     S              1    inz(' ')
ET   D IncludeBid#     S              1    inz(' ')
ET   D IncludeCO#      S              1    inz(' ')
ET   D IncludeOrdBy    S              1    inz(' ')
ET   D IncludePrmDt    S              1    inz(' ')
EN   D dsoeqmdsc     e ds                  extname(oeqmdsc)
EZ    *
EZ   DAUTHDS           DS                  OCCURS(9) INZ
EZ   DADS_TYPE                        2  0
EZ   DADS_AUTH                        5  0
EZ   DADS_NAME                       25
EZ   DADS_TAXAMT                      9  2
E1   D CCPFEE          S                   LIKE(OEAM95)
E1   D OTHCOD          S                   LIKE(OECD06)
¢C   D @Count          s              7  0 Inz
¢E   D SVNOF6          s                   like(ARNOF6)
¢J         dcl-s printInPOSeq char(1) inz;
      *------------------------------------------------------------------------*
¢B   IOEFTOL
¢B   I              OEMO07                      XXMO07
¢B   I              OEDY07                      XXDY07
¢B   I              OECC07                      XXCC07
¢B   I              OEYR07                      XXYR07
¢J   IOEFTOL2
¢J   I              OEMO07                      XXMO07
¢J   I              OEDY07                      XXDY07
¢J   I              OECC07                      XXCC07
¢J   I              OEYR07                      XXYR07
     IOEFTOA
     I              OEAD01                      ARAD04
     I              OEAD02                      ARAD05
     I              OEAD03                      ARAD06
     I              OECY01                      ARCY02
     I              OEST01                      ARST02
     I              OEZP03                      ARZP16
     IARFTNT
     I              ARNO01                      NO01
     I              ARCD01                      CD01
     IIVFMALI
     I              IVNO41                      ALNO41
     I              IVNO07                      ALNO07
     I              ARNO01                      ALNO01
     I              ARNO16                      ALNO16
     I              IVCD60                      ALCD60
     I              IVCD61                      ALCD61
     IARFTWI
     I              OENO01                      UNUSEA
     I              OENO30                      UNUSEB
     IARFTWI2
     I              OENO01                      UNUSEA
     I              OENO30                      UNUSEB
     IOEFTDP
     I              ARNO15                      DEPCO#
     I              ARNO16                      DEPBR#
     I              OENO10                      DEPCK#
     I              OENO01                      UNUSE4
     I              OENO11                      UNUSE6
     IOEFTDP4
     I              ARNO15                      DEPCO#
     I              ARNO16                      DEPBR#
     I              OENO10                      DEPCK#
     I              OENO01                      UNUSE4
     I              OENO11                      UNUSE6
     IOEFTDD
     I              OENO30                      WDNO30
     IARFMCUS
     I              ARCDC6                      WKCDC6
     I              ARCDF9                      XXCDF9
      *****************************************************************
      *  SECTION 0         NON-EXECUTABLE STATEMENTS
      *
      * STEP 1.  DECLARE PARAMETER LISTS
      * STEP 1.  KEY LIST
      *
      *****************************************************************
      * STEP 1. *
      ***********
     C     *ENTRY        PLIST
     C                   PARM                    ORD              17
     C                   PARM                    DTP              10
     C                   PARM                    BBC              39
     C                   PARM                    EBC              39
DD   C                   PARM                    CONSFL            1
DD   C                   PARM                    SNUM              6
      *
     C     RLOCK         PLIST
     C                   PARM                    DSPERR
     C                   PARM                    DSPF1             1            DISPLAY RETRY?
     C                   PARM                    DSPF2             1            SCREEN RESPONSE
     C     PL0100        PLIST
     C                   PARM                    PMAGOP
     C     PL0110        PLIST
     C                   PARM                    PMDATE
      *
     C     PL0002        PLIST
     C                   PARM                    OENO16
     C                   PARM                    HITEM             7 0
     C                   PARM                    PFOR              7 0
     C                   PARM                    PTYPE             1
     C                   PARM                    MSDS#            25
     C                   PARM                    SLOC1            20
     C                   PARM                    SLOC2            20
     C                   PARM      ' '           UPDF              1
      *
     C     PL0402        PLIST
     C                   PARM                    PMIPOS            2
     C                   PARM                    BRANCH
     C                   PARM                    BCPRT             1
      *
D1   C     PL9600        PLIST
D1   C                   PARM                    piMode
D1   C                   PARM                    piRetry
D1   C                   PARM                    piUpdError
D1   C                   PARM                    piTran
D1   C                   PARM                    piMFUKEY
D1   C                   PARM                    piOrgOrd
D1   C                   PARM                    piMethod
D1   C                   PARM                    piTrnDtl
D1   C                   PARM                    piTrnAmt
D1   C                   PARM                    piTaxable
D1   C                   PARM                    piTaxAmt
D1   C                   PARM                    poSuccess
D1   C                   PARM                    poMsg
D1   C                   PARM                    poData
D1   C                   PARM                    piData
EL    *
EL   C     PLOE02        PLIST
EL   C                   PARM                    OENO01
EL   C                   PARM                    ORDSUB            9 2
EL EXC*                  PARM                    ORDTX             7 2
EL EXC*                  PARM                    GSTTX             7 2
EX   C                   PARM                    ORDTX             9 2
EX   C                   PARM                    GSTTX             9 2
EL   C                   PARM                    UpdTotx           1
EY    *
EY   C     PL2300        PLIST
EY   C                   PARM                    IVNO07
EY   C                   PARM                    NSITM
EY   C                   PARM      'N'           SKIPBO            1
EZ    *
EZ   C     PL9308        PLIST
EZ   C                   PARM                    OENO01
EZ   C                   PARM                    AUTHDS
EZ   C                   PARM                    ARST02
¢F ¢GC*    PL_IVRC024    PLIST
¢F ¢GC*                  PARM                    IVNO07
¢F ¢GC*                  PARM                    FIELD_NAME       10
¢F ¢GC*                  PARM                    FIELD_STS         1
¢F ¢GC*                  PARM                    FIELD_VALUE      70
      ***********
      * STEP 2. * KEY LISTS
      ***********
     C     LOCKEY        KLIST                                                  LOCATION MASTER
     C                   KFLD                    BRANCH                         BRANCH
     C                   KFLD                    IVNO07                         OUR ITEM #
     C                   KFLD                    LOCTYP            1            LOCATION TYPE
     C     COMKEY        KLIST                                                  NON-STOCK
     C                   KFLD                    OENO01                         ORDER NUMBER
     C                   KFLD                    OECD11                         RECORD CODE
     C     TAGKEY        KLIST
     C                   KFLD                    OENO01
     C                   KFLD                    OENO22                         COMMENT CNTRL #
     C     TABKEY        KLIST
     C                   KFLD                    TABCOD            4            TABLE CODE
     C                   KFLD                    TABENT            9            TABLE ENTRY
     C     NOTKEY        KLIST                                                  CUST NOTES
     C                   KFLD                    NO01
     C                   KFLD                    CD01
     C     SRLKEY        KLIST                                                  SERL# KEY
   ERC*                  KFLD                    OENO01
ER   C                   KFLD                    ORDKEY
DF   C                   KFLD                    IVCDF8
     C                   KFLD                    OENO22
      *
     C     BRHKEY        KLIST                                                  ARFMAAD
     C                   KFLD                    ARCDA2                         TYPE CODE
     C                   KFLD                    GLCD44                         CODE
     C                   KFLD                    ARNO15                         COMPANY
     C                   KFLD                    GLCD41                         DIVISION#
     C                   KFLD                    GLCD42                         REGION#
     C                   KFLD                    OENO08                         BRANCH#
      *
     C     REGKEY        KLIST                                                  ARFMAAD
     C                   KFLD                    ARCDA2                         TYPE CODE
     C                   KFLD                    GLCD44                         CODE
     C                   KFLD                    ARNO15                         COMPANY
     C                   KFLD                    GLCD41                         DIVISION#
     C                   KFLD                    GLCD42                         REGION#
      *
     C     DIVKEY        KLIST                                                  ARFMAAD
     C                   KFLD                    ARCDA2                         TYPE CODE
     C                   KFLD                    GLCD44                         CODE
     C                   KFLD                    ARNO15                         COMPANY
     C                   KFLD                    GLCD41                         DIVISION#
      *
     C     CMPKEY        KLIST                                                  ARFMAAD
     C                   KFLD                    ARCDA2                         TYPE CODE
     C                   KFLD                    GLCD44                         CODE
     C                   KFLD                    ARNO15                         COMPANY
      *
     C     ADRKEY        KLIST                                                  ARFMJBA
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    OENO06                         JOB
     C                   KFLD                    ARCD76                         TYPE CODE
      *
     C     JOBKEY        KLIST                                                  ARFMJBA
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    OENO06                         JOB
      *
     C     ALIKEY        KLIST
     C                   KFLD                    IVNO07                         ITEM #
     C                   KFLD                    WKCUST                         CUST #
     C     ALIKY2        KLIST
     C                   KFLD                    IVNO07                         ITEM #
     C                   KFLD                    ARNO82                         ENTERPRISE
     C     KYTDD         KLIST
     C                   KFLD                    OECD51
     C                   KFLD                    OENO44
     C     UOMKY         KLIST
     C                   KFLD                    IVNO07
     C                   KFLD                    OEDN04
     C     UOMKY1        KLIST
     C                   KFLD                    IVNO07
     C                   KFLD                    IVCD08
     C     UDRLST        PLIST
     C                   PARM                    ZZFUNC            1
     C                   PARM                    ZZDATE            7 0
     C                   PARM                    ZZDAYS            5 0
     C                   PARM                    ZZDIFF            7 0
      *
     C     PL0400        PLIST
     C                   PARM                    PMIAPL            2
     C                   PARM                    PMOYN             1
EH    *
EH   C     kTotx         klist                                                  NON-STOCK
EH   C                   kfld                    trantype          3            COMPANY #
EH   C                   kfld                    tranum                         ORDER NUMBER
      *
     C     I#KEY         KLIST
     C                   KFLD                    ARNO15                         COMPANY NUMBER
     C                   KFLD                    INV#A                          INV #
DK    *
DK   C     I3KEY         KLIST
DK   C                   KFLD                    ARNO15
DK   C                   KFLD                    ARNO01
DK   C                   KFLD                    INV#A
      *
     C     RESKEY        KLIST                                                  ARFMRES
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    OENM15                         ORDERED BY
     C                   KFLD                    IVCDC4                         RES CODE
      *
     C     ITMBKY        KLIST                                                  IVFMRSB
     C                   KFLD                    IVNO07                         ITEM
     C                   KFLD                    OENO16                         BRANCH
     C     TRAKEY        KLIST                                                  IVFMRSB
     C                   KFLD                    TRANUM            7            TRANS#
     C                   KFLD                    TRATYP            1            TRANS TYPE
      *
     C     IVTKEY        KLIST
     C                   KFLD                    TRNTYP            2            TRANS TYPE
     C                   KFLD                    OENO01                         TRANS NUMBER
     C                   KFLD                    OENO26                         ORIG TRANS
     C                   KFLD                    TRNLIN                         LINE NUMBER
      *
     C     ITMKEY        KLIST
     C                   KFLD                    OENO16                         BRANCH
     C                   KFLD                    IVNO07                         OUR ITEM
EO    *
EO   C     TKEY          KLIST
EO   C                   KFLD                    #TBNO1                         TABLE CODE
EO   C                   KFLD                    #TBNO2                         TABLE ENTRY
E1    *
E1   C     TORKEY        KLIST
E1   C                   KFLD                    OENO01
E1   C                   KFLD                    OTHCOD                         Other charge code
      *
      *
     C     *LIKE         DEFINE    ARNO01        WKCUST                          CUST#
     C     *LIKE         DEFINE    *IN40         SVIN40
     C     *LIKE         DEFINE    IVQY12        PRCFCT
     C     *LIKE         DEFINE    IVQY12        ORDFCT
     C     *LIKE         DEFINE    ARAD07        SVNM07
     C     *LIKE         DEFINE    ARAD08        SVAD08
     C     *LIKE         DEFINE    ARAD09        SVAD09
     C     *LIKE         DEFINE    ARCY03        SVCY03
     C     *LIKE         DEFINE    ARST03        SVST03
     C     *LIKE         DEFINE    ARZP17        SVZP17
     C     *LIKE         DEFINE    IVNO04        WKNO04
     C     *LIKE         DEFINE    IVDN01        WKDN01
     C     *LIKE         DEFINE    AGEOPT        PMAGOP
     C     *LIKE         DEFINE    DSDATE        PMDATE
EO   C     *LIKE         DEFINE    TBNO01        #TBNO1
EO   C     *LIKE         DEFINE    TBNO02        #TBNO2
EP   C     *LIKE         DEFINE    OEAM39        AM39A
EP   C     *LIKE         DEFINE    OEAM39        AM39B
EP   C     *LIKE         DEFINE    OEDN04        OED104
EP   C     *LIKE         DEFINE    OEDN04        OED204
EY   C     *LIKE         DEFINE    IVNO04        NSITM
¢F ¢GC*    *LIKE         DEFINE    OENO08        DESC_LENGTH
     C                   Z-ADD     *ZEROS        IVQTY             7 0
     C                   Z-ADD     *ZEROS        TRNLIN            5 0
     C                   MOVE      *ZEROS        WKCUST
      ***********
      * STEP 3. * INITIALIZATIONS AND RESETS
      ***********
     C                   MOVE      *BLANKS       OEPC01
     C     *LIKE         DEFINE    OEQY01        QY01
     C     *LIKE         DEFINE    OEQY02        QY02
     C     *LIKE         DEFINE    OEQY03        QY03
     C     *LIKE         DEFINE    WCNT          LCNT
      *
      *  SET NUMBER OF LINES IN BODY OF PICK TICKET
      *
     C     *LIKE         DEFINE    CNT           MAXLIN                          MAX LINES
D4   C                   if        Dtp <> 'BPDF'
     C                   Z-ADD     26            MAXLIN
D4   C                   else
D4   C                   eval      MaxLin = 46
D4   C                   endif
      * GET AGE MODES AND AGE CODE DEFAULTS
     C                   MOVEL     AGEOPT        PMAGOP
     C                   CALL      'ARR0100'     PL0100
     C                   MOVEL     PMAGOP        AGEOPT
      *
      *****************************************************************
      *  SECTION 1      PROCESS PICK TICKET PRINT
      *
      * STEP 1.  RETRIEVE ORDER HEADER
      * STEP 2.  RETRIEVE CUSTOMER INFORMATION
      * STEP 3.  RETRIEVE LINE ITEM INFORMATION
      *
      *****************************************************************
      * STEP 1. * ORDER HEADER INFORMATION
      ***********
      *
      *  GO CLEAR FIELDS
     C                   EXSR      CLEAR
      *
EH    * Check if AvaTax installed
EH   C                   eval      pmiapl = '18'
EH   C                   call      'OPR0400'     pl0400
EH   C                   if        pmoyn = 'Y'
EH   C                   eval      AvaTaxActive = 'Y'
EH    *
EH    * If using software, retrieve default for tax jurisdiction
EH   C                   eval      wDefTax = *blanks
EH   C                   eval      tabcod = 'TAXS'
EH   C                   eval      tabent = 'TAXDOWN'
EH   C     tabkey        chain     tbfmtbl
EH   C                   if        %found
EH   C                   eval      wDefTax = %trim(tbno03)
EH   C                   endif
EH   C                   endif
EH    *
EL    * Retrieve EXTENDACK value-will total be by shipped or order quantity?
EL   C                   eval      ExtendQte = *blanks
EL   C                   eval      tabcod = 'OE30'
EL   C                   eval      tabent = 'EXTENDACK'
EL   C     tabkey        chain     tbfmtbl
EL   C                   if        %found
EL   C                   eval      ExtendQte = %subst(TBNO03:1:1)
EL   C                   endif
EL
EM    * If using software, retrieve default for tax jurisdiction
EM   C                   eval      ExcludeLost = *blanks
EM   C                   eval      tabcod = 'OE30'
EM   C                   eval      tabent = 'NOLOST'
EM   C     tabkey        chain     tbfmtbl
EM   C                   if        %found
EM   C                   eval      ExcludeLost = %subst(TBNO03:1:1)
EM   C                   endif
¢I
¢I    * Retreive Remit To phone number
¢I   C                   eval      ARPHN# = *blanks
¢I   C                   eval      tabcod = 'OE30'
¢I   C                   eval      tabent = 'REMITPH#'
¢I   C     tabkey        chain     tbfmtbl
¢I   C                   if        %found
¢I   C                   eval      ARPHN# = %subst(TBNO03:1:12)
¢I   C                   if        ARPHN# <> *blanks
¢I   C                   seton                                        28
¢I   C                   endif
¢I   C                   endif
ET
ET    * Retrieve optional information inclusion
ET   C                   eval      IncludeBid# = *blanks
ET   C                   eval      IncludeCO#  = *blanks
ET   C                   eval      IncludeOrdBy= *blanks
ET   C                   eval      IncludePrmDt= *blanks
ET   C                   eval      tabcod = 'OE30'
ET   C                   eval      tabent = 'INCLTKT'
ET   C     tabkey        chain     tbfmtbl
ET   C                   if        %found
ET   C                   eval      IncludeBid# = %subst(TBNO03:1:1)
ET   C                   eval      IncludeCO#  = %subst(TBNO03:2:1)
ET   C                   eval      IncludeOrdBy= %subst(TBNO03:3:1)
ET   C                   eval      IncludePrmDt= %subst(TBNO03:4:1)
ET   C                   endif
ET
      * CHECK WHETHER W/H MANAGEMENT SYSTEM IS INSTALLED OR NOT.
     C                   MOVE      '03'          PMIAPL
     C                   CALL      'OPR0400'     PL0400
     C     PMOYN         IFEQ      'Y'
     C                   MOVE      'Y'           WHMYES            1
     C                   ELSE
     C                   MOVE      'N'           WHMYES
     C                   ENDIF
      *
      *
      * PRINT TERMS AND TAX ?
      *
     C                   MOVE      'OE40'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'STATUS10'    TABENT
     C     TABKEY        CHAIN(N)  TBFMTBL                            40
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TBNO03        PRTT              1
EE    *
EE    * Print item# only if table setting is Y
EE   C                   if         %trim(%subst(tbno03:2:1)) = 'Y'
EE   C                   eval      *in89 = *on
EE   C                   endif
EE    *
     C     PRTT          IFEQ      'B'
     C     PRTT          OREQ      'P'
     C                   MOVE      '1'           *IN67
     C                   END
     C                   END
      *
      *  OPEN PRINTER FILE
     C                   OPEN      OET2025
      *
     C                   Z-ADD     0             PAGE
     C                   MOVE      ORD           ORDBR
   DIC*                  MOVE      ORDER         ORDKEY            7 0          ORDER NUMBER
DI   C                   MOVE      ORDER         ORDKEY            7            ORDER NUMBER
     C                   MOVE      BR            BRANCH            3 0          BRANCH
DD    *
DD   C     PRMCNT        IFGT      4
DD   C     CONSFL        IFEQ      'W'
DD   C                   Z-ADD     SPLNBR        WRKFLD            6 0
DD   C                   MOVE      WRKFLD        SNUM
DD   C                   ENDIF
DD   C                   ENDIF
      *
      * Retrieve barcode option...
      *
     C                   MOVE      '01'          PMIPOS
     C                   CALL      'OPR0402'     PL0402
      *
      * Is WM installed at branch?
     C                   CLEAR                   WMCOBR
     C                   CLEAR                   WHMBR
     C     WHMYES        IFEQ      'Y'
     C                   Z-ADD     BRANCH        WMBR#
     C                   CLEAR                   WHMBR
     C                   CALL      'WIC0116'
     C                   PARM                    WMCOBR
     C                   PARM                    WHMBR             1
     C                   ENDIF
      * Retrieve date and times
     C                   MOVE      *OFF          *IN21
     C     WHMBR         IFEQ      'Y'
     C                   CLEAR                   HDDTA1
     C                   RESET                   WMDTA1
     C                   MOVE      ORDER         HDNO01
     C                   CLEAR                   WMERR
     C                   CLEAR                   PRMPT
     C                   CALL      'WIR0140'
     C                   PARM      'PT '         FROM              3
     C                   PARM                    PRMPT             2
     C                   PARM                    HDDTA1
     C                   PARM                    WMDTA1
     C                   PARM                    WMERR             3
     C     WMERR         IFEQ      *BLANKS
     C     WMDTEN        IFNE      *ZEROS
     C     WMDTCM        ORNE      *ZEROS
     C     WMTMEN        ORNE      *ZEROS
     C     WMTMCM        ORNE      *ZEROS
     C                   MOVE      *ON           *IN21
     C                   MOVE      WMDTEN        WMENDT            8 0
     C                   Z-ADD     WMTMEN        WMENTM            6 0
     C                   MOVE      WMDTCM        WMCMDT            8 0
     C                   Z-ADD     WMTMCM        WMCMTM            6 0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
D1    * Based on card software, check appropriate software library
D1    * program object.
D1   C                   clear                   online
D1   C                   eval      flag = 'N'
EF   C                   eval      card_interface = 'N'
D1   C                   clear                   tabent
D1   C                   move      'AR27'        tabcod
D1   C                   movel     'CARD'        tabent
D1 ECC*    tabkey        chain     tblmtbl1
EC   C     tabkey        chain(n)  tblmtbl1
D1   C                   If        %found(tblmtbl1)
D1   C                   movel     tbno03        card_tabentry
D1    *
D1 EFC*                  If        using_card = 'Y' and
D1 EFC*                            card_software = 'CURBSTONE'
EF   C                   If        using_card = 'Y'
EF    * Check if card software is used
EF   C                   if        card_software = 'CARDCONNECT'
ES   C                               or card_software = 'WORLDPAY  '
EF   C                   eval      card_interface = 'Y'
EF   C                   eval      flag = *blanks
EF   C                   endif
EF    * Check objects required for Curbstone
EF   C                   if        card_software = 'CURBSTONE'
D3    *
D3   C                   eval      tabent = 'CARDLIB'
D3   C     tabkey        chain     tblmtbl1
D3   C                   If        %found(tblmtbl1)
D3   C                   eval      obj = %trim(%subst(tbno03:1:10))
D3   C                   endif
D3    *
D1 D3C*                  MOVEL     'CURBSTONE'   OBJ              10
D1   C                   MOVEL     '*LIB   '     OBJ_TYPE         10
D1   C                   MOVE      ' '           FLAG              1
D1   C                   CALL      'OPC0028'
D1   C                   PARM                    OBJ
D1   C                   PARM                    OBJ_TYPE
D1   C                   PARM                    FLAG
D1    *
D1   C     FLAG          IFEQ      ' '
D1   C                   CLEAR                   OBJ
D1   C                   MOVEL     'OER9600'     OBJ
D1   C                   MOVEL     '*PGM   '     OBJ_TYPE
D1   C                   MOVE      ' '           FLAG
D1   C                   CALL      'OPC0028'
D1   C                   PARM                    OBJ
D1   C                   PARM                    OBJ_TYPE
D1   C                   PARM                    FLAG
D1   C                   EndIf
EF   C                   endif
D1   C     FLAG          IFEQ      ' '
D1   C                   MOVE      'Y'           ONLINE            1
D1   C                   EndIf
D1   C                   EndIf
D1   C                   EndIf                                                  I=INQ MODE
      *
      * CHECK TO SEE IF THIS IS A CONSIGNED BRANCH
     C     BRANCH        SETLL     RCFMCCS                                81
      *
     C                   TIME                    TIME              6 0
     C                   Z-ADD     UDATE         UDATE2
      *
      * DETERMINE IF PRINTING A PICK TICKET, DEPOSIT, OR REFUND RECEIPT
      *
     C     PICSEQ        IFEQ      'D'
     C     PICSEQ        OREQ      'R'
      *
     C     PICSEQ        IFEQ      'D'
     C                   MOVE      '1'           *IN69
     C                   MOVE      OT(6)         ORDTYP
     C                   ELSE
     C                   MOVE      '1'           *IN68
     C                   MOVE      OT(5)         ORDTYP
     C     OPNDD3        IFNE      'Y'
     C                   OPEN      OELTDD3
     C                   MOVE      'Y'           OPNDD3            1
     C                   END
     C                   MOVE      ORDER         OENO45
     C     OENO45        CHAIN     OEFTDD3                            40
     C     *IN40         IFEQ      '0'
     C                   MOVE      OENO30        ORDER
     C                   ELSE
     C                   MOVE      *BLANKS       ORDER
     C                   END
     C                   END
      *
     C     OPNTDP        IFNE      'Y'
     C                   OPEN      OELTDP1
     C                   MOVE      'Y'           OPNTDP            1
     C                   END
     C                   MOVE      ORDER         OENO30
     C     *IN92         DOUEQ     '0'
     C     OENO30        CHAIN     OEFTDP                             4092
     C     *IN92         IFEQ      '1'                                          RECORD LOCK
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
      * IF DEPOSIT RECEIPT REQUESTED, UPDATE THE DEP RCPT PRINTED FLAG.
     C     *IN40         IFEQ      '0'
     C     PICSEQ        IFNE      'D'
     C     OECD52        OREQ      'Y'
     C                   EXCEPT    RELDP1
     C                   ELSE
     C                   MOVE      'Y'           OECD52
     C                   EXCEPT    UPDDP1
     C                   END
     C                   END
     C                   MOVE      DEPCO#        ARNO15
     C                   MOVE      DEPBR#        OENO08
     C                   MOVE      DEPBR#        OENO16
     C                   ELSE
     C     GETHDR        TAG
     C     ORDKEY        CHAIN     OEFTOH                             4094      HEADER FILE
     C     *IN94         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C     DSPF2         CABEQ     'Y'           GETHDR
     C                   GOTO      ENDPT
     C                   END
      *
     C                   END
      *
     C     *IN40         IFEQ      '0'
      *
      * Retrieve invoice sequence from customer add-on field
 ¢J         printInPOSeq = *BLANKS;
 ¢J         EXEC SQL
 ¢J           SELECT SUBSTR(OPTX20,1,1)
 ¢J             INTO :printInPOSeq
 ¢J             FROM ARPMCUA
 ¢J            WHERE ARNO01 = :ARNO01
 ¢J              AND OPNM25 = 'INVSEQPO'
 ¢J            FETCH FIRST 1 ROW ONLY;
      *
      * Open appropriate order line file based on print sequence
¢J         select;
¢J           when printInPOSeq = 'Y';
¢J             open OELTOL9;
¢J           other;
¢J             open OELTOL5;
¢J         endsl;
      *
     C                   MOVEA     '0'           *IN(50)
     C                   MOVEA     '0'           *IN(59)
DM DRC*                  MOVE      '0'           *IN55
DR   C                   MOVE      '0'           *IN87
      *
      *  IS THIS A REPRINT?...
      *
     C                   CLEAR                   *IN71
     C     OECD03        IFEQ      'C'
     C     OEFL02        ANDEQ     'Y'
     C     OECD03        OREQ      'R'
     C     OEFL18        ANDEQ     'Y'
     C     OECN03        IFGT      0
     C                   MOVE      *ON           *IN71
     C                   ENDIF
     C                   ELSE
     C     OECN02        IFGT      0
     C                   MOVE      *ON           *IN71
     C                   ENDIF
     C                   ENDIF
      *
      * RETRIEVE TABLE ENTRY TO DETERMINE WHETHER OR NOT TO PRINT THE
      * EXTENDED PRICE FOR NO CHARGE ITEMS...
      *
     C                   MOVEL     'Y'           PRTNC             1
     C     OEFL02        IFEQ      'Y'                                          CASH INVOICE
     C     OEFL18        OREQ      'Y'                                          IMMED INVOICE
     C                   CLEAR                   TABCOD
     C                   CLEAR                   TABENT
     C                   MOVE      'AR01'        TABCOD
     C                   MOVEL     'PRTNC'       TABENT
     C     TABKEY        CHAIN(N)  TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        PRTNC
     C                   ENDIF
     C                   ENDIF
      *
      * RETRIEVE TABLE ENTRY TO DETERMINE WHERE TO PRINT "N/C"
      * UNIT PRICE OR EXTENDED PRICE OR BOTH FOR NO CHARGE ITEMS...
      *
     C                   MOVEL     'U'           PLCNC             1
     C                   CLEAR                   TABCOD
     C                   CLEAR                   TABENT
     C                   MOVE      'AR01'        TABCOD
     C                   MOVEL     'PLCNC'       TABENT
     C     TABKEY        CHAIN(N)  TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        PLCNC
     C                   ENDIF
      *
      * SEE IF USING GST TAX ?
      *
     C                   EXSR      GHTXSR
     C     OECD86        IFNE      *BLANKS
     C                   MOVE      'AR17'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     ARNO15        TABENT
     C     TABKEY        CHAIN(N)  TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        GSTREG           10
     C                   ELSE
     C                   MOVE      NOHIT         GSTREG
     C                   END
     C                   ENDIF
      *----------------------------------------------------------------
      *
     C     PICSEQ        IFEQ      'D'
     C     PICSEQ        OREQ      'R'
     C     ARNO01        IFEQ      *ZERO
     C                   MOVE      'W'           WALKIN
     C                   END
     C                   ELSE
     C     OENO01        IFNE      OENO26
     C                   MOVE      OENO26        ORIG1             7
     C                   MOVE      '1'           *IN59
     C                   END
DM   C     OEFL31        IFEQ      'Y'
DM   C                   MOVE      OENO14        ORIG1
DM   C     *IN59         IFEQ      '1'
DM   C                   MOVE      '0'           *IN59
DM   C                   ENDIF
DM DRC*                  MOVE      '1'           *IN55
DR   C                   MOVE      '1'           *IN87
DM   C                   ENDIF
      *
      * WAS A DEPOSIT TAKEN FOR THIS ORDER.
      *
     C                   MOVE      *BLANKS       OENO30
     C     OECD03        IFEQ      'C'
     C     OEFL02        ANDEQ     'Y'
     C     OECD03        OREQ      'C'
     C     OEFL02        ANDEQ     'C'                                          C.O.D.
     C     OPNDP4        IFNE      'Y'
     C                   OPEN      OELTDP4
     C                   MOVE      'Y'           OPNDP4            1
     C                   END
     C     OENO01        SETLL     OEFTDP4                                40
     C     *IN40         IFEQ      '1'
     C     *IN92         DOUEQ     '0'
     C     OENO01        READE     OEFTDP4                              9240
     C     *IN92         IFEQ      '1'                                          RECORD LOCK
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
      * DETERMINE IF DEPOSIT RECEIPT HAS ALREADY BEEN PRINTED.
     C     *IN40         IFEQ      '0'
     C     OECD52        IFEQ      'Y'
     C                   EXCEPT    RELDP4
DU    *
DU    * Do not clear Dep# if it is a COD order with ship/sell br diff
DU    * For such COD orders, deposit receipt is to be printed with pick
DU    * tkt at ship branch also.
DU    *
DU   C                   if        oefl02 <> 'C' or
DU   C                             (oefl02 = 'C' and
DU   C                             oeno08 = oeno16)
     C                   MOVE      *BLANKS       OENO30
DU   C                   endif
     C                   ELSE
     C                   MOVE      'Y'           OECD52
     C                   EXCEPT    UPDDP4
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C                   MOVE      OT(1)         ORDTYP
     C                   MOVE      OS(3)         ORDSTS
      *
      * PRINT CHARGE INVOICE ?
      *
     C     OEFL18        IFEQ      'Y'
     C                   MOVE      'Y'           PRTPRC
     C                   MOVE      OS(4)         ORDSTS
     C                   ELSE
      *
      * RESERVED ORDER ?
      *
     C     OECD04        IFEQ      'K'
     C                   MOVE      OS(1)         ORDSTS           15
     C                   END
DH    * PACKING LIST ?
DH   C     REPRNT        IFEQ      'P'
DH   C                   MOVE      OS(5)         ORDSTS
DH   C                   ENDIF
      *
     C                   MOVE      '0'           *IN82                          PRINT QTY   E
     C     WHMBR         IFEQ      'Y'
     C     OECD04        IFEQ      'R'                                          REVIEWED
     C     OECD04        OREQ      'P'                                          PRICED
     C     OECD04        OREQ      'C'                                          CHANGED
     C                   MOVE      OS(5)         ORDSTS           15
     C                   MOVE      '1'           *IN82                          PRINT QTY   E
     C                   ENDIF
     C                   ENDIF
      *
     C     OECD65        IFEQ      'Y'
     C                   MOVEA     '1'           *IN(58)
     C                   END
      *
      * QUOTATION ?
      *
     C     OECD08        IFEQ      'Q'
     C                   MOVE      OT(4)         ORDTYP           15
     C                   END
      *
      * PENDING ORDER ?
      *
     C     OECD04        IFEQ      'N'
     C                   MOVE      OS(2)         ORDSTS
     C                   END
     C                   ENDIF
      *
      * PRINT PRICES ON TICKETS ?
      *
     C     PRTPRC        IFEQ      'Y'
     C     OECD67        ANDNE     'Y'                                          BULK PRICING
     C                   MOVEA     '1'           *IN(50)
     C                   END
      *
      * FREIGHT TYPE
      *
     C     OECD32        IFEQ      'P'
     C                   MOVE      TA(4)         OEVIA
     C                   END
     C     OECD32        IFEQ      'C'
     C                   MOVE      TA(5)         OEVIA
     C                   END
     C     OECD32        IFEQ      'A'
     C                   MOVE      TA(6)         OEVIA
     C                   END
      *
      * METHOD OF SHIPMENT
      *
     C     OECD01        IFEQ      'O'
     C                   MOVEL     TA(1)         OEVIA
     C                   END
     C     OECD01        IFEQ      'P'
     C                   MOVEL     TA(2)         OEVIA
     C                   END
     C     OECD01        IFEQ      'S'
     C                   MOVEL     TA(3)         OEVIA
     C                   END
     C     OECD01        IFEQ      'D'
     C                   MOVEL     TA(7)         OEVIA
     C                   MOVE      *ON           *IN30
     C                   END
      *
      * CASH OR CHARGE SALE
      *
     C     OECD03        IFEQ      'R'
     C                   MOVE      'CHARGE'      PMTTYP            6
     C                   ELSE
     C                   MOVE      'CASH'        PMTTYP
     C     OEFL02        IFEQ      'Y'
     C                   MOVE      OS(4)         ORDSTS
     C                   MOVEA     '1'           *IN(82)                        PRINT QTY   E
     C                   END
     C     OEFL02        IFEQ      'C'
     C                   MOVE      'C.O.D.'      PMTTYP
     C                   MOVEA     '1'           *IN(82)                        PRINT QTY   E
     C                   END
     C                   END
      *
      *  BULK PRICING
      *
      *
      *  CREDIT OR DEBIT MEMO ?
      *
     C     OECD08        IFEQ      'C'                                           CREDIT MEMO
     C                   MOVE      OT(2)         ORDTYP
DM   C                   if        oecd04='N'
DM   C                   MOVE      'OE31'        TABCOD
DM   C                   MOVE      *BLANKS       TABENT                         INZ TAB ENT
DM   C                   MOVEL     'RGA'         TABENT                         INZ TAB ENT
DM DVC*    TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
DV   C     TABKEY        CHAIN(N)  TBFMTBL                            40        TABLE FILE
DM   C     *IN40         IFEQ      *OFF
DM   C                   MOVEL     TBNO03        ORDTYP
DM   C                   ENDIF
DM   C                   endif
     C                   ELSE
     C     OECD08        IFEQ      'D'                                           DEBIT MEMO
     C                   MOVE      OT(3)         ORDTYP
     C                   END
     C                   END
      *
     C                   MOVEA     '0'           *IN(32)
     C     OEFL02        IFEQ      'Y'
     C     OEFL02        OREQ      'C'
     C     OEFL18        OREQ      'Y'
     C     OECD08        OREQ      'C'
     C     OECD08        OREQ      'Q'                                          QUOTE
DP   C     OECD79        OREQ      'Y'
     C                   MOVEA     '1'           *IN(32)
     C                   END
      *
      * WALKIN CUSTOMER ?
      *
     C                   MOVE      OECD05        WALKIN
     C                   END
      *
      * DATE ORDERED AND DATE SHIPPED
      *
     C     PICSEQ        IFEQ      'D'
     C                   MOVE      OEDS10        DATORD            6 0
     C                   MOVE      OEDS10        DATSHP            6 0
     C                   ELSE
     C     PICSEQ        IFEQ      'R'
     C                   MOVE      OEDS11        DATORD
     C                   MOVE      OEDS11        DATSHP
     C                   ELSE
     C                   MOVE      ARDS05        DATORD
     C                   MOVE      ARDS06        DATSHP
     C                   END
     C                   END
     C                   MOVE      '0'           *IN70
     C     DATSHP        IFGT      0
     C                   MOVE      '1'           *IN70
     C                   END
      ***********
      * STEP 2. * CUSTOMER INFORMATION
      ***********
     C     WALKIN        IFNE      'W'                                          NOT A WALKIN CS
     C     ARNO01        CHAIN     ARFMCUS                            40
     C     *IN40         IFEQ      *OFF
      *
DY    * Seton flag to print prices on pick ticket for charge orders
DY   C                   if        arfl88 ='Y'                                  CHGINV
DY   C                   movea     '1'           *IN(32)
DY   C                   endif
      * GENERIC CASH - RETRIEVE CUSTOMER NAME FROM WALK-IN FILE
      *
     C     ARCDC4        IFEQ      'Y'                                          GENERIC CASH
     C     PICSEQ        IFEQ      'D'
     C     PICSEQ        OREQ      'R'
     C     OPNWI2        IFNE      'Y'
     C                   OPEN      ARLTWI2
     C                   MOVE      'Y'           OPNWI2            1
     C                   ENDIF
     C     OENO30        CHAIN     ARFTWI2                            42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      *BLANKS       ARNM01
     C                   MOVEL     ARNM09        ARNM01                         CUSTOMER NAME
     C                   ENDIF
     C                   ELSE
     C     OPNWI1        IFNE      'Y'
     C                   OPEN      ARLTWI1
     C                   MOVE      'Y'           OPNWI1            1
     C                   ENDIF
     C     ORDKEY        CHAIN     ARFTWI                             42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      *BLANKS       ARNM01
     C                   MOVEL     ARNM09        ARNM01                         CUSTOMER NAME
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   END
   DEC*    ARCDB8        IFEQ      '1'                                          PRINT
   DEC*    ARCDB8        OREQ      '4'                                          PRINT & FAX
   DEC*    ARCDB8        OREQ      '5'                                          PRINT & EMAIL
   DEC*                  MOVE      '1'           *IN57
   DEC*                  ELSE
   DEC*                  MOVE      '0'           *IN57
   DEC*                  END
DE   C     ARCDB8        IFEQ      'Y'
DE   C                   MOVE      *ON           *IN57
DE   C                   ELSE
DE   C                   MOVE      *OFF          *IN57
DE   C                   ENDIF
     C     OEFL06        IFEQ      'Y'                                          SHIP TO FLAG
     C     ORDKEY        CHAIN     OEFTOA                             41        SHIP TO FILE
     C                   END
DM DS *
DM DS * if pending credit memo do not print prices
DM DS *
DM DSc*                  if        oecd08='C' and oecd04='N'
DM DSC*                  MOVE      '0'           *IN36
DM DSC*                  MOVE      '0'           *IN57
DM DSc*                  endif
DM DS *
      *
      * BLANK ARRAYS
      *
     C                   MOVE      *BLANKS       MAD                            MAIL ADDRESS AR
     C                   MOVE      *BLANKS       SAD                            SHIP ADDRESS AR
     C                   MOVE      *BLANKS       COM                            SPECIAL INSTRUC
     C                   MOVE      *BLANKS       MAILNM                         MAIL ADDRESS AR
      *
      * LOAD SHIPPING CITY,STATE,ZIP
      *
     C                   MOVEL     ARCY02        SHIP             30
     C                   MOVE      ARST02        SHIP
      *
      * DETERMINE WHICH MAILING ADDRESS TO PRINT
      *
     C                   MOVE      ' '           USEJOB
     C                   MOVE      ' '           USECST
     C                   MOVE      ' '           USEENT
     C     OENO06        IFNE      *BLANKS
     C     JOBKEY        CHAIN     ARFMJBM                            46
     C     *IN46         IFEQ      *OFF
     C     ARFL28        ANDNE     'Y'                                          BILL TO CUST
     C                   MOVE      'Y'           USEJOB            1
     C                   ELSE
     C     ARFL29        IFEQ      'Y'                                          BILL TO ENT
     C                   MOVE      'Y'           USEENT            1
     C                   ELSE
     C                   MOVE      'Y'           USECST            1
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     ARFL29        IFEQ      'Y'
     C                   MOVE      'Y'           USEENT
     C                   ELSE
     C                   MOVE      'Y'           USECST
     C                   ENDIF
     C                   ENDIF
      *
      * LOAD MAILING ADDRESS TO ARRAY
      *
     C     WALKIN        IFNE      'W'                                          NOT A WALKIN CS
      *  -- CUSTOMER MAILING ADDRESS
     C                   SELECT
     C     USECST        WHENEQ    'Y'
     C                   MOVEL     ARNM01        MAILNM
     C                   MOVE      *BLANKS       MAIL             35
     C     ARCY01        CAT       ARST01:1      MAIL
     C                   Z-ADD     0             X                 1 0
     C     ARAD01        IFNE      *BLANKS                                      MAIL ADDRESS 1
     C                   ADD       1             X
     C                   MOVEA     ARAD01        MAD(X)
     C                   END
     C     ARAD02        IFNE      *BLANKS                                      MAIL ADDRESS 2
     C                   ADD       1             X
   D2C*                  MOVEA     ARAD02        MAD(X)
D2   C                   MOVE      ARAD02        LineInM2
     C                   END
     C     ARAD03        IFNE      *BLANKS                                      MAIL ADDRESS 3
     C                   ADD       1             X
   D2C*                  MOVEA     ARAD03        MAD(X)
D2   C                   MOVE      ARAD03        LineInM3
     C                   END
     C     MAIL          IFNE      *BLANKS                                      CITY,STATE,ZIP
     C                   ADD       1             X
   D2C*                  MOVEA     MAIL          MAD(X)
D2   C                   MOVE      ARCY01        LineInMC
D2   C                   MOVE      ARST01        LineInMS
     C                   END
     C     ARZP15        IFNE      *BLANKS                                      CITY,STATE,ZIP
     C                   ADD       1             X
   D2C*                  MOVE      ARZP15        MAD(X)
D2   C                   MOVE      ARZP15        LineInMZ
     C                   END
      *  -- ENTERPRISE MAILING ADDRESS
     C     USEENT        WHENEQ    'Y'
     C     ARNO82        CHAIN     ARLMENT1                           46
     C     *IN46         IFEQ      *OFF
     C                   MOVEL     ARNM62        MAILNM
     C                   MOVE      *BLANKS       MAIL
     C     ARCY08        CAT       ARST08:1      MAIL
     C                   Z-ADD     0             X
     C     ARAD22        IFNE      *BLANKS
     C                   ADD       1             X
     C                   MOVEA     ARAD22        MAD(X)
     C                   ENDIF
     C     ARAD23        IFNE      *BLANKS
     C                   ADD       1             X
   D2C*                  MOVEA     ARAD23        MAD(X)
D2   C                   MOVE      ARAD23        LineInM2
     C                   ENDIF
     C     ARAD24        IFNE      *BLANKS
     C                   ADD       1             X
   D2C*                  MOVEA     ARAD24        MAD(X)
D2   C                   MOVE      ARAD24        LineInM3
     C                   ENDIF
     C     MAIL          IFNE      *BLANKS
     C                   ADD       1             X
   D2C*                  MOVEA     MAIL          MAD(X)
D2   C                   MOVE      ARCY08        LineInMC
D2   C                   MOVE      ARST08        LineInMS
     C                   ENDIF
     C     ARZP22        IFNE      *BLANKS
     C                   ADD       1             X
   D2C*                  MOVE      ARZP22        MAD(X)
D2   C                   MOVE      ARZP22        LineInMZ
     C                   ENDIF
     C                   ENDIF
      *  -- JOB MAILING ADDRESS
     C     USEJOB        WHENEQ    'Y'
     C                   MOVEL     ARNM01        MAILNM
     C                   MOVE      '9'           ARCD76
     C     ADRKEY        CHAIN     ARFMJBA                            46
     C     *IN46         IFEQ      *OFF
     C                   MOVE      *BLANKS       MAIL
     C     ARCY06        CAT       ARST06:1      MAIL
     C                   Z-ADD     0             X
     C     ARAD16        IFNE      *BLANKS
     C                   ADD       1             X
     C                   MOVEA     ARAD16        MAD(X)
     C                   ENDIF
     C     ARAD17        IFNE      *BLANKS
     C                   ADD       1             X
   D2C*                  MOVEA     ARAD17        MAD(X)
D2   C                   MOVE      ARAD17        LineInM2
     C                   ENDIF
     C     ARAD18        IFNE      *BLANKS
     C                   ADD       1             X
   D2C*                  MOVEA     ARAD18        MAD(X)
D2   C                   MOVE      ARAD18        LineInM3
     C                   ENDIF
     C     MAIL          IFNE      *BLANKS
     C                   ADD       1             X
   D2C*                  MOVEA     MAIL          MAD(X)
D2   C                   MOVE      ARCY06        LineInMC
D2   C                   MOVE      ARST06        LineInMS
     C                   ENDIF
     C     ARZP20        IFNE      *BLANKS
     C                   ADD       1             X
   D2C*                  MOVE      ARZP20        MAD(X)
D2   C                   MOVE      ARZP20        LineInMZ
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
      *
     C                   END
      *
      * LOAD SHIPPING ADDRESS TO ARRAY
      *
     C                   Z-ADD     0             X
     C     ARAD04        IFNE      *BLANKS                                      SHIP ADDRESS 1
     C                   ADD       1             X
     C                   MOVEA     ARAD04        SAD(X)
     C                   END
     C     ARAD05        IFNE      *BLANKS                                      SHIP ADDRESS 2
     C                   ADD       1             X
   D2C*                  MOVEA     ARAD05        SAD(X)
D2   C                   MOVE      ARAD05        LineInS2
     C                   END
     C     ARAD06        IFNE      *BLANKS                                      SHIP ADDRESS 3
     C                   ADD       1             X
   D2C*                  MOVEA     ARAD06        SAD(X)
D2   C                   MOVE      ARAD06        LineInS3
     C                   END
     C     SHIP          IFNE      *BLANKS                                      CITY,STATE,ZIP
     C                   ADD       1             X
   D2C*                  MOVEA     SHIP          SAD(X)
D2   C                   MOVE      ARCY02        LineInSC
D2   C                   MOVE      ARST02        LineInSS
     C                   END
     C     ARZP16        IFNE      *BLANKS                                      CITY,STATE,ZIP
     C                   ADD       1             X
   D2C*                  MOVE      ARZP16        SAD(X)
D2   C                   MOVE      ARZP16        LineInSZ
     C                   END
     C     WALKIN        IFEQ      'W'                                          WALKIN       CS
     C     PICSEQ        IFEQ      'D'
     C     PICSEQ        OREQ      'R'
     C     OPNWI2        IFNE      'Y'
     C                   OPEN      ARLTWI2
     C                   MOVE      'Y'           OPNWI2            1
     C                   END
     C     OENO30        CHAIN     ARFTWI2                            40
     C                   ELSE
     C     OPNWI1        IFNE      'Y'
     C                   OPEN      ARLTWI1
     C                   MOVE      'Y'           OPNWI1            1
     C                   END
     C     ORDKEY        CHAIN     ARFTWI                             40
     C                   END
      *
     C     *IN40         IFEQ      '0'
     C                   MOVEA     ARNM09        MAD(1)                         WALKIN NAME
     C     TEL           IFNE      0
     C                   MOVEL     ARNO07        TEL1              7            TEL AREA CODE
     C                   MOVE      ARNO08        TEL1                           TEL PREFIX #
     C                   MOVEL     TEL1          TEL2             12            AREA & PREFIX
     C                   MOVE      ARNO09        TEL2                           TEL PREFIX #
     C                   MOVEA     TEL2          MAD(2)                         TELEPHONE #
     C                   END
     C                   END
     C                   END
      *
      * LOAD SPECIAL INSTRUCTIONS TO ARRAY
      *
     C     PICSEQ        IFNE      'D'
     C     PICSEQ        ANDNE     'R'
     C                   Z-ADD     0             X
     C                   MOVE      '3'           OECD11                         RECORD CODE
     C     COMKEY        SETLL     OEFTOM                                 48
     C     *IN48         IFEQ      '1'
     C     *IN49         DOUEQ     '1'
     C     COMKEY        READE     OEFTOM                                 49
     C     *IN49         IFEQ      '0'
     C                   ADD       1             X
     C                   MOVEL     OEDN02        COM(X)
     C                   END
     C                   END
     C                   END
      *
      * RETRIEVE CASH SALE INFO FOR PRINT
      *
     C     OECD03        IFEQ      'C'                                          CASH SALE
     C     OENO01        CHAIN     OEFTOC                             49        CASH SALE MSTR
     C                   END
     C                   END
      *
      * GET SELLING BRANCH
      *
     C     OENO08        CHAIN     ARFMBCH                            01        BRANCH MSTR
     C     *IN01         IFEQ      '0'
     C                   MOVE      ARAD07        SVNM07
     C                   MOVE      ARAD08        SVAD08
     C                   MOVE      ARAD09        SVAD09
     C                   MOVE      ARCY03        SVCY03
     C                   MOVE      ARST03        SVST03
     C                   MOVE      ARZP17        SVZP17
     C                   END
      *
      * BRANCH NAME
      *
      * GET SHIPPING BRANCH
     C     OENO16        CHAIN     ARFMBCH                            01        BRANCH MSTR
     C     *IN01         IFEQ      '0'
     C                   MOVE      ARNM07        SHNM07
     C                   MOVE      ARAD10        SHAD10
     C                   MOVE      ARAD11        SHAD11
     C                   MOVE      ARCY04        SHCY04
     C                   MOVE      ARST04        SHST04
     C                   MOVE      ARZP18        SHZP18
     C                   END
      *
      *  GET REMITTANCE ADDRESS
     C                   MOVE      'R'           ARCDA2
     C                   MOVEL     'BR'          GLCD44
     C     BRHKEY        CHAIN     ARFMAAD                            44
     C     *IN44         IFEQ      '0'
     C     ARAD19        ANDNE     *BLANKS
     C                   MOVEL     ARAD19        ADDR1            30
     C                   MOVEL     ARAD20        ADDR2            30
     C                   MOVEL     ARAD21        ADDR3            30
     C                   MOVE      *BLANKS       RMIT
     C                   MOVEL     ARCY07        RMIT
     C                   MOVE      ARST07        RMIT
     C                   MOVEL     ARZP21        RMITZP
     C                   ELSE
     C                   MOVEL     'RG'          GLCD44
     C     REGKEY        CHAIN     ARFMAAD                            44
     C     *IN44         IFEQ      '0'
     C     ARAD19        ANDNE     *BLANKS
     C                   MOVEL     ARAD19        ADDR1
     C                   MOVEL     ARAD20        ADDR2
     C                   MOVEL     ARAD21        ADDR3
     C                   MOVE      *BLANKS       RMIT
     C                   MOVEL     ARCY07        RMIT
     C                   MOVE      ARST07        RMIT
     C                   MOVEL     ARZP21        RMITZP
     C                   ELSE
     C                   MOVEL     'DV'          GLCD44
     C     DIVKEY        CHAIN     ARFMAAD                            44
     C     *IN44         IFEQ      '0'
     C     ARAD19        ANDNE     *BLANKS
     C                   MOVEL     ARAD19        ADDR1
     C                   MOVEL     ARAD20        ADDR2
     C                   MOVEL     ARAD21        ADDR3
     C                   MOVE      *BLANKS       RMIT
     C                   MOVEL     ARCY07        RMIT
     C                   MOVE      ARST07        RMIT
     C                   MOVEL     ARZP21        RMITZP
     C                   ELSE
     C                   MOVEL     'CO'          GLCD44
     C     CMPKEY        CHAIN     ARFMAAD                            44
     C     *IN44         IFEQ      '0'
     C     ARAD19        ANDNE     *BLANKS
     C                   MOVEL     ARAD19        ADDR1
     C                   MOVEL     ARAD20        ADDR2
     C                   MOVEL     ARAD21        ADDR3
     C                   MOVE      *BLANKS       RMIT             30
     C                   MOVEL     ARCY07        RMIT
     C                   MOVE      ARST07        RMIT
     C                   MOVEL     ARZP21        RMITZP
     C                   ENDIF                                                  COMPANY
     C                   ENDIF                                                  DIVISION
     C                   ENDIF                                                  REGION
     C                   ENDIF                                                  BRANCH
D2   C                   move      arcy07        lineinAcy
D2   C                   move      arst07        lineinAst
D2   C                   move      arzp21        lineinAzp
      *
     C     ADDR1         IFEQ      *BLANKS                                      USE BRANCH MAIL
     C                   MOVEL     SVNM07        ADDR1                             ADDRESS AS THE
     C                   MOVEL     SVAD08        ADDR2                             DEFAULT.
     C                   MOVEL     SVAD09        ADDR3
     C                   MOVEL     SVCY03        RMIT
     C                   MOVE      SVST03        RMIT
     C                   MOVEL     SVZP17        RMITZP
D2   C                   move      svcy03        lineinAcy
D2   C                   move      svst03        lineinAst
D2   C                   move      svzp17        lineinAzp
     C                   ENDIF
D2    *
D2   C                   move      addr2         lineinAd2
D2 EAC*                  move      addr3         lineinAd3
D2    *
     C     PICSEQ        IFNE      'D'
     C     PICSEQ        ANDNE     'R'
     C     OENO08        CHAIN     ARFMBCH                            01        BRANCH MSTR
     C     *IN01         IFEQ      '0'
     C     SHNM07        IFEQ      *BLANKS
     C     SHAD10        OREQ      *BLANKS
     C                   MOVE      ARNM07        SHNM07
     C                   MOVE      ARAD10        SHAD10
     C                   MOVE      ARAD11        SHAD11
     C                   MOVE      ARCY04        SHCY04
     C                   MOVE      ARST04        SHST04
     C                   MOVE      ARZP18        SHZP18
     C                   END
     C                   END
     C                   END
D2    *
D2   C                   move      shad11        lineinSA2
D2   C                   move      shcy04        lineinScy
D2   C                   move      shst04        lineinSSt
D2   C                   move      shzp18        lineinSzP
D2    *
      * CASH OR CHARGE SALE INVOICE TICKET
     C     PICSEQ        IFNE      'D'
     C     PICSEQ        ANDNE     'R'
     C     OEFL18        IFEQ      'Y'
     C     OEFL02        OREQ      'Y'
     C                   EXSR      TERMSR
     C                   MOVE      *ON           *IN76
     C                   END
     C                   ENDIF
      * CUSTOMER NOTES
     C     PICSEQ        IFNE      'D'
     C     PICSEQ        ANDNE     'R'
     C                   MOVE      ARNO01        NO01
     C                   MOVE      'P'           CD01
     C     NOTKEY        CHAIN     ARFTNT                             02        CUST NOTES
     C                   ELSE
     C                   MOVE      '1'           *IN02
     C                   END
D2   C                   EXSR      AlignAddr
     C                   EXSR      CPYARY
      *
      * PRINTING BAR CODE?
      *
     C     BCPRT         IFEQ      '1'
     C     BCPRT         OREQ      '2'
     C     OENO01        IFNE      *ZEROS
DI   C     OENO01        ANDNE     *BLANKS
     C                   MOVE      OENO01        BARCDE
     C                   CLEAR                   BARCD2
     C                   MOVEL     OENO01        BARCD2
     C                   MOVE      ARNO01        BARCD2
     C                   MOVE      *OFF          *IN88
     C     BCPRT         IFEQ      '2'
     C                   MOVE      *ON           *IN88
     C                   ENDIF
      *
      * Device type *IPDS...
      *
     C     DTP           IFEQ      'IPDS'
     C                   WRITE     OE2025BC
     C                   ELSE
      *
      * Device type *SCS...
      *
     C     DTP           IFEQ      'SCS'
     C     BBC           ANDNE     *BLANKS
     C                   MOVEL     BBC           FONT1
     C                   MOVEL     EBC           FONT2
     C                   WRITE     OE2025B1
     C                   WRITE     OE2025B2
     C                   WRITE     OE2025B3
D4   C                   else
D4    * Base PDF Form ?
D4   C                   if        Dtp = 'BPDF'
D4   C                   WRITE     OE2025BB
D4   C                   endif
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
D4   C                   EVAL      TYPSTS = %TRIM(ORDTYP) + ' ' + %TRIM(ORDSTS)
     C                   WRITE     OE2025H1
     C                   WRITE     OE2025H2
     C                   CLEAR                   CNT
      ***********
      * STEP 3. * LINE ITEM INFORMATION
      ***********
     C     PICSEQ        IFNE      'R'
     C     PICSEQ        IFEQ      'D'
     C     OENO30        ORNE      *BLANKS
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025DP
     C                   ADD       9             CNT
     C     OEAM37        IFNE      0
     C                   MOVE      OENO30        TRANUM
     C                   MOVE      'D'           TRATYP
ES   C                   EVAL      *IN31 = *OFF
¢E   C                   eval      SVNOF6 = *blanks
     C     TRAKEY        SETLL     ARFTCCT                                47
     C     *IN47         IFEQ      *ON
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025CH
     C                   ADD       6             CNT
     C     *IN47         DOUEQ     *ON
     C     TRAKEY        READE     ARFTCCT                                47
     C     *IN47         IFEQ      *OFF
¢E   C     ARNOF6        andne     SVNOF6
¢E   C                   eval      SVNOF6 = ARNOF6
ES   C     ARCDJ3        COMP      'W'                                    31
     C                   CLEAR                   STATUS
     C                   Z-ADD     1             X
     C     ARCDF6        LOOKUP    CS(X)                                  51
     C     *IN51         IFEQ      *ON
     C                   MOVEL     DS(X)         STATUS            8
     C                   ELSE
     C                   MOVEL     'UNKNOWN'     STATUS
     C                   ENDIF
EI   C                   IF        arcdj3 = 'J' or
EI   C                             ONLINE <> 'Y'
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025CC
     C                   ADD       1             CNT
EI   C                   ENDIF
D1 EF * Check for CURBSTONE CrCard Information for Deposits
EF    * Check for CrCard Information for Deposits
D1   C                   EXSR      CURBSR
     C                   ENDIF
     C                   ENDDO
E1    * Print Card Processinf Fee
E1   C                   EXSR      Print_CCPFee
     C                   ENDIF
     C                   ENDIF
     C                   END
D1    * Refund?
     C                   ELSE
     C     OECD61        IFEQ      'C'
     C                   MOVEL     'CASH'        PAYTYP
     C                   ELSE
     C     OECD61        IFEQ      'I'
     C                   MOVEL     'CHECK IS'    PAYTYP
     C                   MOVE      'SUED   '     PAYTYP
     C                   ELSE
     C     OECD61        IFEQ      'R'
     C                   MOVEL     'CHECK RE'    PAYTYP
     C                   MOVE      'QUESTED'     PAYTYP
     C                   ELSE
     C     OECD61        IFEQ      'A'
     C                   MOVEL     'CREDIT C'    PAYTYP
     C                   MOVE      'ARD    '     PAYTYP
     C                   END
     C                   END
     C                   END
     C                   END
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025RF
     C                   ADD       9             CNT
D1    * PICSEQ <> 'R'
     C     OECD61        IFEQ      'A'
     C                   MOVE      OENO30        TRANUM
     C                   MOVE      'D'           TRATYP
ES   C                   EVAL      *IN31 = *OFF
¢E   C                   eval      SVNOF6 = *blanks
     C     TRAKEY        SETLL     ARFTCCT                                47
     C     *IN47         IFEQ      *ON
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025CH
     C                   ADD       6             CNT
     C     *IN47         DOUEQ     *ON
     C     TRAKEY        READE     ARFTCCT                                47
     C     *IN47         IFEQ      *OFF
¢E   C     ARNOF6        andne     SVNOF6
¢E   C                   eval      SVNOF6 = ARNOF6
ES   C     ARCDJ3        COMP      'W'                                    31
     C                   CLEAR                   STATUS
     C                   Z-ADD     1             X
     C     ARCDF6        LOOKUP    CS(X)                                  51
     C     *IN51         IFEQ      *ON
     C                   MOVEL     DS(X)         STATUS
     C                   ELSE
     C                   MOVEL     'UNKNOWN'     STATUS
     C                   ENDIF
EI   C                   IF        arcdj3 = 'J' or
EI   C                             ONLINE <> 'Y'
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025CC
     C                   ADD       1             CNT
EI   C                   ENDIF
D1   C                   EXSR      CURBSR
     C                   ENDIF
     C                   ENDDO
E1    * Print Card Processinf Fee
E1   C                   EXSR      Print_CCPFee
     C                   ENDIF
     C                   ENDIF
     C                   END
      *
D1    * CASH PT w/o deposit drops to here
     C     PICSEQ        IFNE      'D'
     C     PICSEQ        ANDNE     'R'
D0    *
D0    * Print 'invoice comments' on immediate invoices before printing
D0    * line item details
D0   C                   if        (oecd03 = 'C' and
D0   C                             oefl02 ='Y') or
D0   C                             (oecd03 = 'R' and
D0   C                             oefl18 = 'Y')
D0   C                   if        oecd04 = 'I'
D0   C                   move      '1'           oecd11                         RECORD CODE
D0   C     comkey        chain     oeftom                             49
D0   C                   if        *in49 = *off
D0   C                   eval      wkpdds = oedn02
D0   C                   write     oe2025d4                                     PRINT LINE ITEM
D0   C                   endif
D0   C                   endif
D0   C                   endif
D0    *
D1   C                   If        ONLINE = 'Y'
D1   C                   eval      *IN39 = '1'
EI   C                   Endif
D1   C                   MOVE      OENO01        TRANUM
ES   C                   EVAL      *IN31 = *OFF
¢E   C                   eval      SVNOF6 = *blanks
D1   C     TRANUM        SETLL     ARFTCCT                                47
D1   C     *IN47         IFEQ      *ON
D1   C     CNT           CASGT     MAXLIN        OVRFLW
D1   C                   ENDCS
D1   C                   WRITE     OE2025CH
D1   C                   ADD       6             CNT
D1   C     *IN47         DOUEQ     *ON
D1   C     TRANUM        READE     ARFTCCT                                47
D1   C     *IN47         IFEQ      *OFF
¢E   C     ARNOF6        andne     SVNOF6
¢E   C                   eval      SVNOF6 = ARNOF6
ES   C     ARCDJ3        COMP      'W'                                    31
D1   C                   CLEAR                   STATUS
D1   C                   Z-ADD     1             X
D1   C     ARCDF6        LOOKUP    CS(X)                                  51
D1   C     *IN51         IFEQ      *ON
D1   C                   MOVEL     DS(X)         STATUS
D1   C                   ELSE
D1   C                   MOVEL     'UNKNOWN'     STATUS
D1   C                   ENDIF
EI   C                   IF        arcdj3 = 'J' or
EI   C                             ONLINE <> 'Y'
D1   C     CNT           CASGT     MAXLIN        OVRFLW
D1   C                   ENDCS
D1   C                   WRITE     OE2025CC
D1   C                   ADD       1             CNT
EI   C                   ENDIF
D1   C                   EXSR      CURBSR
D1   C                   ENDIF
D1   C                   ENDDO
E1    * Print Card Processinf Fee
E1   C                   EXSR      Print_CCPFee
D1   C                   ENDIF
D1 EIC*                  EndIf
D1   C                   EVAL      *IN39 = '0'
D1    *
¢J   C     printInPOSeq  IFEQ      'Y'
¢J   C     ORDKEY        SETLL     OEFTOL2                                41    LINE ITEMS
¢J   C                   ELSE
     C     ORDKEY        SETLL     OEFTOL                                 41    LINE ITEMS
¢J   C                   ENDIF
     C     *IN41         IFEQ      '1'
      *
     C     *IN42         DOUEQ     '1'
     C     RDTOL         TAG
¢J   C     printInPOSeq  IFEQ      'Y'
¢J   C     ORDKEY        READE     OEFTOL2                              9242    LINE ITEMS
¢J   C                   ELSE
     C     ORDKEY        READE     OEFTOL                               9242    LINE ITEMS
¢J   C                   ENDIF
     C     *IN92         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C     DSPF2         CABEQ     'Y'           RDTOL
     C                   GOTO      ENDPT
     C                   END
     C                   END
     C     *IN42         IFEQ      '0'
EM    * Exclude Lost Sales from printing?
EM   C                   if        ExcludeLost = 'Y'
EM   C                   if        oeqy02 = 0 and oeqy03= 0
EM   C                   if        oecd09 = 'S' or oecd09 = 'N'
EM   C                   goto      rdtol
EM   C                   endif
EM   C                   endif
EM   C                   endif
EM    *
EY    * CALL OER2300 TO CHECK FOR BACKORDER EXCLUSION
EY   C                   IF        OEQY02 <> *ZEROS AND OEQY03 = *ZEROS
EY   C                   IF        %SUBST(IVNO04:1:1) = '/'
EY   C                   EVAL      NSITM = IVNO04
EY   C                   ELSE
EY   C                   CLEAR                   NSITM
EY   C                   ENDIF
EY   C                   CALL      'OER2300'     PL2300
EY   C                   IF        SKIPBO = 'Y'
EY   C                   IF        OECN01 = 1 AND OECN05 = 1
EY   C                   WRITE     OE2025D7
EY   C                   ENDIF
EY   C                   GOTO      RDTOL
EY   C                   ENDIF
EY   C                   ENDIF
EY    *
     C                   MOVEA     '00'          *IN(83)
     C                   ADD       1             SEQNUM            3 0          # OF LINES
      *
     C     EINO22        IFNE      *BLANKS
     C                   MOVE      *ON           *IN90
     C                   ELSE
     C                   MOVE      *OFF          *IN90
     C                   ENDIF
      *
      *
      *
      * IS ITEM A 'NO-CHARGE' ITEM ?
      *
     C     OECD43        IFEQ      'Y'
   DTC*    *IN50         ANDEQ     *ON                                          PRINT PRICES?
     C     PLCNC         IFEQ      'U'
     C     PLCNC         OREQ      'B'
     C                   MOVE      '1'           *IN53
     C                   END
     C     PLCNC         IFEQ      'E'
     C     PLCNC         OREQ      'B'
     C                   MOVE      '1'           *IN72
     C                   END
     C                   ELSE
     C                   MOVE      '0'           *IN53
     C                   MOVE      '0'           *IN72
     C                   END
      *
      * 14 LINES TO A PAGE---OVERLOW ?
      *
      *
      * BODY COMMENTS,STOCKED ITEMS,NON-STOCK ITEMS
      *
     C     *IN57         IFEQ      '1'                                          PRINT NET PRICE
EL   C     OECD08        OREQ      'Q'
EL   C     ExtendQte     ANDEQ     'O'
     C                   EXSR      DISC
     C                   END
¢J    * UPDATE SEQUENCE NUMBER - Use LINES2 for PO sequence, LINES for standard
     C                   Z-ADD     SEQNUM        OENO09                         SEQUENCE NUMBER
¢J         select;
¢J           when printInPOSeq = 'Y';
¢J             except LINES2;
¢J           other;
     C                   EXCEPT    LINES
¢J         endsl;
      *
      * IF NOT PRINTING COMPONENT DETAIL THEN READ NEXT LINE ITEM.
      *
     C     OECD09        IFEQ      'G'
     C     OECD09        OREQ      'X'
     C     OECD83        CABEQ     'I'           RDTOL                          INVOICE ONLY
     C     OECD83        CABEQ     'N'           RDTOL                          NEITHER
     C                   ENDIF
      *
     C     OECD09        CASEQ     'C'           BDYSR                          BODY COMMENTS
     C     OECD09        CASEQ     'N'           NONSR                          NON STOCK ITEMS
     C     OECD09        CASEQ     'K'           NONSR                          NON STOCK ITEMS
     C     OECD09        CASEQ     'X'           NONSR                          NON STOCK ITEMS
     C                   CAS                     STKSR                          STOCKING ITEMS
     C                   END
     C                   END
     C                   END
     C                   END
EZ    *
EZ    * COLORADO RETAIL DELIVERY FEE/TAX
EZ    *
EZ   C                   IF        OEFL02 = 'Y' OR OEFL18 = 'Y'
EZ   C                   IF        OEFL08 = 'Y' AND OECD01 <> 'P'
EZ   C                   EXSR      RTV_RTLDLV
EZ   C                   ENDIF
EZ   C                   ENDIF
EN    *
EN    * PRINT DISCLAIMER TEXT
EN    *
EN   C     PICSEQ        IFNE      'D'
EN   C     PICSEQ        ANDNE     'R'
EN   C                   MOVE      'N'           TXT_PRINTED       1
EN    *
EN    * Branch Select
EN    *
EN    *  declare cursor
EN    *
EN   C/EXEC SQL
EN   C+ DECLARE c1 CURSOR FOR
EN   C+ SELECT * FROM oeqmdsc
EN   C+ where arno16 = :oeno16
EN   C+ ORDER BY arno16
EN   C/END-EXEC
EN    *
EN    *  open cursor
EN    *
EN   C/EXEC SQL
EN   C+ OPEN c1
EN   C/END-EXEC
EN    *
EN   C                   dou       sqlcod <> 0
EN    *
EN    *  get records
EN    *
EN   C/EXEC SQL
EN   C+ FETCH NEXT FROM c1 INTO :dsoeqmdsc
EN   C/END-EXEC
EN    *
EN    * check for end of file
EN   C                   if        sqlcod <>0
EN   C                   leave
EN   C                   endif
EN    *
EN   C                   IF        TXT_PRINTED = 'N'
EN   C                   eval      wkpdds    = *blanks
EN    *
EN    * space
EN   C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
EN   C                   ENDCS
EN   C                   write     oe2025d4
EN   C                   ADD       1             CNT
EN   C                   ENDIF
EN    *
EN   C                   eval      wkpdds    = oetx07
EN    *
EN    * print detail
EN   C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
EN   C                   ENDCS
EN   C                   write     oe2025d4
EN   C                   ADD       1             CNT
EN   C                   MOVE      'Y'           TXT_PRINTED       1
EN   C                   enddo
EN    *
EN    *
EN   C/EXEC SQL
EN   C+ Close c1
EN   C/END-EXEC
EN    *
EN    * Branch Default
EN   C                   IF        TXT_PRINTED = 'N'
EN   C                   Z-ADD     *ZEROS        ZEROBR            3 0
EN    *
EN    *  declare cursor
EN    *
EN   C/EXEC SQL
EN   C+ DECLARE c2 CURSOR FOR
EN   C+ SELECT * FROM oeqmdsc
EN   C+ where arno16 = :ZEROBR
EN   C+ ORDER BY arno16
EN   C/END-EXEC
EN    *
EN    *  open cursor
EN    *
EN   C/EXEC SQL
EN   C+ OPEN c2
EN   C/END-EXEC
EN    *
EN   C                   dou       sqlcod <> 0
EN    *
EN    *  get records
EN    *
EN   C/EXEC SQL
EN   C+ FETCH NEXT FROM c2 INTO :dsoeqmdsc
EN   C/END-EXEC
EN    *
EN    * check for end of file
EN   C                   if        sqlcod <>0
EN   C                   leave
EN   C                   endif
EN    *
EN   C                   IF        TXT_PRINTED = 'N'
EN   C                   eval      wkpdds    = *blanks
EN    *
EN    * space
EN   C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
EN   C                   ENDCS
EN   C                   write     oe2025d4
EN   C                   ADD       1             CNT
EN   C                   ENDIF
EN    *
EN   C                   eval      wkpdds    = oetx07
EN    *
EN    * print detail
EN   C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
EN   C                   ENDCS
EN   C                   write     oe2025d4
EN   C                   ADD       1             CNT
EN   C                   MOVE      'Y'           TXT_PRINTED       1
EN   C                   enddo
EN    *
EN    *
EN   C/EXEC SQL
EN   C+ Close c2
EN   C/END-EXEC
EN   C                   ENDIF
EN   C                   END
      *
     C     OECD03        IFEQ      'C'
     C     OEFL02        ANDEQ     'Y'
     C                   ADD       1             OECN03
     C                   ELSE
     C     OEFL18        IFEQ      'Y'
     C                   ADD       1             OECN03
     C                   ELSE
     C                   ADD       1             OECN02
     C                   ENDIF
      *
     C                   END
      * Reset print pick ticket flag from 'In progress'...
     C     OEFL03        IFEQ      'I'
     C     OECN02        IFGT      *ZEROS
     C                   MOVE      'Y'           OEFL03
     C                   ELSE
     C                   MOVE      'N'           OEFL03
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      PICSEQ        OECD36
     C                   EXCEPT    UPDHDR
      *
EH    * If using tax software and tax setting is for Zero tax,
EH    * if tax API fails and order is taxable -
EH    * print 'Tax not included'
EH    * Also print 'TBD' as tax$ and total$, if order is a ticket
EH   C                   if        avataxactive = 'Y'
EH   C                             and wDefTax = 'Z'
EH   C                             and oeam04 = *zeros
EH   C                             and oefl08 = 'Y'
EH    *
EH   C                   eval      tranum = oeno01
EH   C                   eval      trantype = 'S/O'
EH   C     kTotx         chain     oeltotx1                           88
EH   C                   if        *in88 = *on
EH   C                             and (oefl02 = 'Y'
EH   C                             or oefl02 = 'C'
EH   C                             or oefl18 = 'Y'
EH   C                             or oecd08 = 'Q'
EH   C                             or oecd67 = 'Y')
EH   C                             or (*in88 = *off
EH   C                             and %trim(xoecdc1) <> *blanks)
EH    * Print tax not included before printing line items
EH   C                   move      c@noTax       noTaxTxt
EH    * Print 'TBD' where tax prints, if order is not an invoice as
EH    * tax can be calculated when order is maintained/reviewed
EH    * For invoices, skip this as tax cannot be re-calculated
EH   C                   if        *in88 = *off and
EH   C                             %trim(xoecdc1) <> *blanks
EH   C                   eval      *in79 = *on
EH   C                   endif
EH   C                   write     oe2025ntax                                   PRINT LINE ITEM
EH   C                   add       1             cnt
EH   C     cnt           casgt     maxlin        ovrFlw
EH   C                   endcs
EH   C                   endif
EH   C                   endif
      * CASH SALE/OTHER CHARGES
      *
     C     OECD67        IFEQ      'Y'                                          BULK PRICING
     C     OECD03        ANDNE     'C'                                          NOT A CASH SALE
D4   C                   if        Dtp <> 'BPDF'
     C                   WRITE     OE2025NT
     C                   WRITE     OE2025SH
     C                   WRITE     OE2025EO
D4   C                   else
D4   C                   WRITE     OE2025NTB
¢A   C                   Z-ADD     OEWT01        WGHT              7 0
D4   C                   WRITE     OE2025SHB
D4   C                   WRITE     OE2025EOB
D4   C                   endif
     C     PRTPRC        IFEQ      'Y'                                          BULK PRICING
     C                   MOVE      OETL01        WKTL01
D4   C                   if        Dtp <> 'BPDF'
     C                   WRITE     OE2025BP
D4   C                   else
D4   C                   WRITE     OE2025BPB
D4   C                   endif
     C                   ENDIF
     C                   ELSE
     C     OECD03        CASEQ     'C'           CSHSR                          CASH SALE
     C                   END
     C                   END
     C                   END
      *
     C     OECD67        IFNE      'Y'                                          BULK PRICING
     C     OECD03        IFNE      'C'
     C     *IN68         OREQ      '1'                                          RFND RECEIPT
     C     *IN69         OREQ      '1'                                          DEP RECEIPT
     C     OECD08        IFEQ      'Q'                                          QUOTE
     C     OEFL18        OREQ      'Y'                                          CHGINV
DY   C     ARFL88        OREQ      'Y'                                          CHGINV
     C                   EXSR      CSHSR
     C                   ELSE
D4   C                   if        Dtp <> 'BPDF'
     C                   WRITE     OE2025NT
     C                   WRITE     OE2025SH
     C                   WRITE     OE2025EO
D4   C                   else
D4   C                   WRITE     OE2025NTB
¢A   C                   Z-ADD     OEWT01        WGHT              7 0
D4   C                   WRITE     OE2025SHB
D4   C                   WRITE     OE2025EOB
D4   C                   endif
     C                   ENDIF
     C                   ELSE
     C     OECD03        IFNE      'C'
D4   C                   if        Dtp <> 'BPDF'
     C                   WRITE     OE2025NT
     C                   WRITE     OE2025SH
     C                   WRITE     OE2025EO
D4   C                   else
D4   C                   WRITE     OE2025NTB
¢A   C                   Z-ADD     OEWT01        WGHT              7 0
D4   C                   WRITE     OE2025SHB
D4   C                   WRITE     OE2025EOB
D4   C                   endif
     C                   ENDIF
     C                   END
     C                   END
      *
     C     ENDPT         TAG
      *
      *  CLOSE PRINTER FILE
     C                   CLOSE     OET2025
      *
      * RETURN LEAVING PROGRAM ACTIVE
     C                   RETURN
      *
     C                   SETON                                        LR
      **********************************************************************
      * CONVERT NET PRICE AT PRICING UOM TO NET PRICE AT ORDERED UOM  ******
      **********************************************************************
     C     DISC          BEGSR
     C                   MOVE      *IN40         SVIN40
     C                   Z-ADD     1             ORDFCT
     C                   Z-ADD     1             PRCFCT
     C     IVNO07        IFNE      *ZEROS
     C                   MOVE      'P'           IVCD08
     C     UOMKY1        CHAIN     IVFMUOM1                           40
     C     *IN40         IFEQ      *OFF
     C                   Z-ADD     IVQY12        PRCFCT
     C                   ENDIF
     C     UOMKY         CHAIN     IVFMUOM                            40
     C     *IN40         IFEQ      *OFF
     C                   Z-ADD     IVQY12        ORDFCT
     C                   ENDIF
     C                   ENDIF
     C     OEAM38        DIV(H)    PRCFCT        NETP                           STOCKING
     C                   MULT(H)   ORDFCT        NETP                           ORDERED
     C                   MOVE      SVIN40        *IN40
EL
EL    * Calculate extended price at ordered UOM
EL   C                   If        OECD08 = 'Q'
EL   C                               and ExtendQte = 'O'
EL   C                   Eval(h)   OEAM05 = netp * OEQY14
EL   C                   Endif
EL
     C                   ENDSR
      ********************************************************************
      ****** BODY COMMENTS ***********************************************
      ********************************************************************
     C     BDYSR         BEGSR
     C     TAGKEY        SETLL     OEFTOT                                 43
     C     *IN43         IFEQ      '1'
     C     *IN44         DOUEQ     '1'
     C     TAGKEY        READE     OEFTOT                                 44
     C     *IN44         IFEQ      '0'
     C                   MOVEL     OEDN05        PDDS35           35            DESCRIPTION
     C                   MOVE      *BLANKS       IVDN01
     C                   MOVEL     OEDN05        IVDN01
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025D3                                     PRINT LINE ITEM
     C                   ADD       1             CNT               2 0
      *
     C                   END
     C                   END
     C                   END
     C                   ENDSR
      ********************************************************************
      ****** NON STOCK ***************************************************
      ********************************************************************
     C     NONSR         BEGSR
      *
     C                   MOVEA     '0'           *IN(80)
     C                   MOVE      *BLANKS       STKUOM
     C                   Z-ADD     OEQY01        QY01
     C                   Z-ADD     OEQY02        QY02
     C                   Z-ADD     OEQY03        QY03
     C                   Z-ADD     OEQY14        OEQY01
     C                   Z-ADD     OEQY15        OEQY02
     C                   Z-ADD     OEQY16        OEQY03
      *
     C                   Z-ADD     CNT           WCNT
     C     RDNSTK        TAG
     C     IVNO04        CHAIN     IVFTNSK                            45        NON STOCK DESC
      *
      * IF  COMBINATION ITEM
      * AND PRINT COMBO DETAIL = Y I.E. OECD83 = T OR B
      *     DO NOT PRINT SHIP QTY
      * (THIS PRINT SHIP QTY IF PRINT COMBO DETAIL = N).
     C     OECD09        IFEQ      'K'                                          COMBINATION
     C     OECD83        IFEQ      'T'                                          PRNT ON TKT
     C     OECD83        OREQ      'B'                                          PRNT ON BOTH
     C                   MOVEA     '1'           *IN(55)
     C                   ENDIF
     C                   END
     C     OECD09        IFEQ      'X'                                          COMPONENT
     C                   MOVEA     '1'           *IN(56)
     C                   END
      *
      * *** IF W/H BR, GET LOCATION AND PICKERS ID
      *
     C     WHMBR         CASEQ     'Y'           WHLOC
     C                   ENDCS
      *
      * OVERFLOW ?
      *
     C     OECD30        IFEQ      'Y'                                          LINE ITEM TAGS
     C     OECN04        ADD       CNT           WCNT
     C                   END
      *
      *
     C                   MOVE      *BLANKS       PART48
     C                   MOVEL     IVNO04        PART48           48
     C                   MOVE      *BLANKS       PDDS35
     C                   MOVEL     IVDN01        PDDS35
     C                   MOVE      IVDN01        PART48
     C     OECD47        COMP      'V'                                    52    B/O STATUS
     C                   Z-ADD(H)  OEAM39        AM39
      **
      *  IF PRINTING DTL1 FOR TAX AND TERMS ADD 1 TO WCNT
     C     *IN67         IFEQ      *ON                                          PRT TAX/TRM
     C     *IN56         OREQ      *ON                                          COMPONENT
     C     *IN90         OREQ      *ON
EE   C     *in89         oreq      *on                                          item#
     C                   ADD       1             WCNT
     C                   ENDIF
¢a    * retrieve mfg#
¢a   c                   eval      mfg# = *blanks
¢a   c                   eval      item = ivno07
¢a   c                   eval      prod = *blanks
¢a   c                   CALL      'PRR9959'
¢a   c                   PARM                    PROD             15
¢a   c                   PARM                    ITEM              7 0
¢a   c                   PARM                    MFG#             30
¢a   c                   PARM                    mBR               3 0
¢a   c     mfg#          ifne      *blanks
¢a   c                   add       1             wcnt
¢a   c                   end
      *  PRINTING DTL ADD 2 TO WCNT
     C                   ADD       2             WCNT
     C     WCNT          SUB       CNT           LCNT
     C     WCNT          IFGT      MAXLIN
     C     LCNT          CASLE     MAXLIN        OVRFLW
     C                   ENDCS
     C                   ENDIF
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
      *
      * DETERMINE WHETHER TO PRINT PRICE AND/OR EXTENDED AMOUNT...
      *
     C                   EXSR      PRICEO
      *
      *
      * If the quantity ordered is a seven-digit number, the last three
      * positions of the item description will not be printed.
      * This is being done so that the entire quantities can be printed
      * without using an additional print line.
     C     OEQY01        IFGE      1000000
     C     OEQY01        ORLE      -1000000
     C                   MOVE      *ON           *IN29                          print quantity
     C                   Z-ADD     OEQY01        LQY01                          PRT FIELDS
     C                   Z-ADD     OEQY03        LQY03
     C                   MOVE      OEDN04        LDN04
     C                   ELSE
     C                   MOVE      *OFF          *IN29                          print UOM
     C                   ENDIF
   EOC*                  MOVE      OEDN04        WKDN04
EO   C                   MOVEL     OEDN04        OED104                         UOM
EO   C                   MOVEL     OEDN04        OED204                         UOM
EO   C                   MOVEL     OEDN04        OED304                         UOM
EO   C                   EXSR      SRUOM
EP   C                   select
EP   C                   when      *in37
EP   C                   WRITE     OE2025D1A                                    PRINT LINE ITEM
EP   C                   when      *in38
EP   C                   WRITE     OE2025D1B                                    PRINT LINE ITEM
EP   C                   other
     C                   WRITE     OE2025D1                                     PRINT LINE ITEM
EP   C                   endsl
     C                   ADD       2             CNT
     C     *IN67         IFEQ      *ON                                          PRT TAX/TRM
     C     *IN56         OREQ      *ON                                          COMPONENT
EE   C     *in89         oreq      *on                                          item#
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
EJ   C                   eval      *in34 = *off
EJ    * If order uses tax software, do not print 'Taxable'
EJ   C                   if        getTaxCalType(trn_typ:ordKey) = 'A'
EJ   C                   eval      *in34 = *on
EJ   C                   endif
     C                   WRITE     OE2025D2                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C                   ENDIF
¢a   c     mfg#          ifne      *blanks
¢a   C                   MOVE      *BLANKS       WKDN01
¢a   C                   MOVE      *BLANKS       WKPDDS
¢a   C                   MOVE      *BLANKS       WKNO04
¢a   C                   MOVE      MFGHDG        WKNO04
¢a   C                   MOVEL     MFG#          WKDN01                         DESCRIPTION
¢a   C     WKNO04        CAT       WKDN01:1      WKPDDS
¢A   C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
¢A   C                   ENDCS
¢a   c                   write     oe2025D4
¢a   c                   add       1             CNT
¢a   c                   end
      *
     C     WHMBR         IFEQ      'Y'
     C                   EXSR      WHLOC
     C                   ENDIF
      *
     C     *IN90         IFEQ      *ON
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025D6
     C                   ADD       1             CNT
     C                   ENDIF
      *
      * LINE ITEM COMMENTS
      *
     C     OECD30        IFEQ      'Y'                                          LINE ITEM TAGS
     C     TAGKEY        SETLL     OEFTOT                                 43
     C     *IN43         IFEQ      '1'
     C     *IN44         DOUEQ     '1'
     C     TAGKEY        READE     OEFTOT                                 44
     C     *IN44         IFEQ      '0'
     C                   MOVEL     OEDN05        PDDS35                         DESCRIPTION
     C                   MOVE      *BLANKS       IVDN01
     C                   MOVEL     OEDN05        IVDN01
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025D3                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C                   END
     C                   END
     C                   END
     C                   END
     C                   MOVEA     '00'          *IN(55)
     C                   ENDSR
      ********************************************************************
      ****** STOCKED ITEMS ***********************************************
      ********************************************************************
     C     STKSR         BEGSR
     C                   MOVEA     '00'          *IN(85)
     C                   Z-ADD     CNT           WCNT
     C                   MOVE      *BLANKS       IVCD56
     C     IVNO07        CHAIN     IVFMSTR                            46        ITEM MASTER
     C                   MOVE      '1'           LOCTYP                         PRIMARY SEQ
     C     WHMBR         IFNE      'Y'                                                      TER
     C     LOCKEY        CHAIN     IVFMLOC                            46        LOCATION MASTER
     C     *IN46         IFEQ      '0'
     C                   MOVE      '1'           *IN85
     C                   MOVE      IVDN07        PRMDN7            3            PRIMARY
     C                   MOVE      IVDN08        PRMDN8            3            LOCATION
     C                   MOVE      IVDN09        PRMDN9            3
     C                   END
     C                   MOVE      '2'           LOCTYP                         SECONDARY SEQ
     C     LOCKEY        CHAIN     IVFMLOC                            46        LOCATION MASTER
     C     *IN46         IFEQ      '0'
     C                   MOVE      '1'           *IN86
     C                   MOVE      IVDN07        SECDN7            3            SECONDARY
     C                   MOVE      IVDN08        SECDN8            3            LOCATION
     C                   MOVE      IVDN09        SECDN9            3
     C                   END
     C                   END                                                                TER
      *
      *
     C                   CLEAR                   HAZITM
     C                   CLEAR                   MSDS#
     C                   CLEAR                   SLOC1
     C                   CLEAR                   SLOC2
     C     IVCDE6        IFNE      ' '
     C                   MOVE      'Y'           HAZITM            1
     C                   ENDIF
     C     OEQY03        IFGT      *ZEROS
     C                   MOVE      'C'           PTYPE
     C                   Z-ADD     IVNO07        HITEM
     C                   Z-ADD     ARNO01        PFOR
     C                   CALL      'HZR0002'     PL0002
     C                   ENDIF
     C     MSDS#         IFNE      *BLANKS
     C                   ADD       5             WCNT
     C                   ELSE
     C                   ADD       1             WCNT
     C                   ENDIF
      *
     C     SLOC2         IFNE      *BLANKS
     C                   MOVE      *ON           *IN30
     C                   ELSE
     C                   MOVE      *OFF          *IN30
     C                   ENDIF
      *
      * OVERFLOW ?
      *
     C     IVCD36        IFEQ      'Y'                                          EXTENDED DESC
     C                   ADD       IVCN07        WCNT              2 0          WORK COUNT
     C                   END
      *
     C     OECD30        IFEQ      'Y'                                          LINE ITEM TAGS
     C                   ADD       OECN04        WCNT
     C                   END
      *
      * IS ITEM A RESTRICTED MATERIAL ?
      *
     C                   MOVE      'N'           RESMAT            1
     C     ITMBKY        SETLL     IVFMRSB                                45
     C     *IN45         IFEQ      *ON
     C                   ADD       3             WCNT
     C                   MOVE      'Y'           RESMAT
     C                   ENDIF
      *
      * IF  COMBINATION ITEM
      * AND PRINT COMBO DETAIL = Y I.E. OECD83 = T OR B
      *     DO NOT PRINT SHIP QTY
      * (THIS PRINT SHIP QTY IF PRINT COMBO DETAIL = N).
     C     OECD09        IFEQ      'A'                                          COMBINATION
     C     OECD83        IFEQ      'T'                                          PRNT ON TKT
     C     OECD83        OREQ      'B'                                          PRNT ON BOTH
     C                   MOVEA     '1'           *IN(55)
     C                   ENDIF
     C                   END
     C     OECD09        IFEQ      'G'                                          COMPONENT
     C                   MOVEA     '1'           *IN(56)
     C                   END
      *
      *
     C     IVCD56        IFEQ      'Y'                                          ALIAS
     C     OPNALI        IFNE      'Y'
     C                   MOVE      'Y'           OPNALI
     C                   OPEN      IVLMALI4
     C                   ENDIF
     C     ARNO01        IFNE      *ZERO
     C                   Z-ADD     ARNO01        WKCUST
     C                   MOVE      *IN40         SVIND             1
     C     ALIKEY        CHAIN     IVFMALI                            40
     C     *IN40         IFEQ      *ON
     C     ARNO82        ANDNE     0
     C     ALIKY2        CHAIN     IVFMALI                            40
     C                   ENDIF
     C     *IN40         IFEQ      '0'
     C                   ADD       1             WCNT
     C                   ENDIF
     C                   MOVE      SVIND         *IN40
     C                   ENDIF
     C                   ENDIF
      **
      *  ADD 1 FOR DTL3, ADD 1 FOR DTL TO WCNT
     C                   ADD       2             WCNT                           DTL LINE
¢a    * retrieve mfg#
¢a   c                   eval      mfg# = *blanks
¢a   c                   eval      item = ivno07
¢a   c                   eval      prod = *blanks
¢a   c                   CALL      'PRR9959'
¢a   c                   PARM                    PROD             15
¢a   c                   PARM                    ITEM              7 0
¢a   c                   PARM                    MFG#             30
¢a   c                   PARM                    mbr               3 0
¢a   c     mfg#          ifne      *blanks
¢a   c                   add       1             wcnt
¢a   c                   end
      *
      *  IF PRINTING DTL1 FOR TAX AND TERMS ADD 1 TO WCNT
     C     *IN56         IFEQ      *ON                                          COMPONENT
     C     *IN67         OREQ      *ON                                          PRT TAX/TRM
     C     *IN85         OREQ      *ON                                          PRIMARY LOC
     C     *IN86         OREQ      *ON                                          SECOND LOC
     C     *IN90         OREQ      *ON                                          COMPONENT
EE   C     *in89         oreq      *on                                          item#
     C                   ADD       1             WCNT
     C                   ENDIF
     C     WCNT          SUB       CNT           LCNT
     C     WCNT          IFGT      MAXLIN                                                   PAGE
     C     LCNT          CASLE     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   ENDIF
¢F ¢G * Set description if tax
¢F ¢GC*                  EVAL      FIELD_STS    = 'A'
¢F ¢GC*                  EVAL      FIELD_NAME = 'ITMTAXCODE'
¢F ¢GC*                  CALL      'IVRC024'     PL_IVRC024
¢F ¢GC*                  IF        FIELD_VALUE = 'PM020760'
¢F ¢GC*                  EVAL      DESC_LENGTH = %LEN(%TRIM(IVDN01))
¢F ¢GC*                  IF        DESC_LENGTH >= 29
¢F ¢GC*                  MOVE      ' TAX'        IVDN01
¢F ¢GC*                  ELSE
¢F ¢GC*                  EVAL      IVDN01 = %TRIM(IVDN01) + ' TAX'
¢F ¢GC*                  ENDIF
¢F ¢GC*                  ENDIF
¢F ¢G *
     C                   MOVE      *BLANKS       PART48
     C                   MOVE      IVDN01        PART48
     C                   MOVEL     IVNO04        PART48           48
     C     OECD47        COMP      'V'                                    52    B/O STATUS
      *
      *
     C                   Z-ADD     0             QY01
     C                   Z-ADD     0             QY02
     C                   Z-ADD     0             QY03
     C                   MOVEA     '1'           *IN(80)
     C                   MOVE      IVDN20        STKUOM
     C                   Z-ADD     OEQY01        QY01
     C                   Z-ADD     OEQY02        QY02
     C                   Z-ADD     OEQY03        QY03
     C                   Z-ADD     OEQY14        OEQY01
     C                   Z-ADD     OEQY15        OEQY02
     C                   Z-ADD     OEQY16        OEQY03
     C                   Z-ADD     1             PULQY1            5 0
     C     UOMKY         CHAIN     IVFMUOM                            43
     C     *IN43         IFEQ      '0'
     C                   Z-ADD     IVQY12        PULQY1
     C                   END
      *
      *ONLY SHOW FACTOR MSG (CONTROLLED BY *IN64) IF DIFFERENT.
      *
     C                   MOVE      *OFF          *IN64
     C     PULQY1        IFNE      1
     C                   MOVE      *ON           *IN64
     C                   ENDIF
      *
     C     IVDN41        IFNE      *BLANKS
     C     IVDN41        ANDNE     OEDN04
     C     OEQY03        ANDNE     *ZEROS
     C     IVQYZ9        ANDNE     *ZEROS
     C     OEQY03        DIV       IVQYZ9        CNVQTY            9 2
     C                   MOVE      *ON           *IN65
     C                   ELSE
     C                   MOVE      *OFF          *IN65
     C                   END
     C                   Z-ADD     OEAM39        AM39
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
      *
      * DETERMINE WHETHER TO PRINT PRICE AND/OR EXTENDED AMOUNT...
      *
     C                   EXSR      PRICEO
      *
      *
      * If the quantity ordered is a seven-digit number, the last three
      * positions of the item description will not be printed.
      * This is being done so that the entire quantities can be printed
      * without using an additional print line.
     C     OEQY01        IFGE      1000000
     C     OEQY01        ORLE      -1000000
     C                   MOVE      *ON           *IN29                          print quantity
     C                   Z-ADD     OEQY01        LQY01                          PRT FIELDS
     C                   Z-ADD     OEQY03        LQY03
     C                   MOVE      OEDN04        LDN04
     C                   ELSE
     C                   MOVE      *OFF          *IN29                          print UOM
     C                   ENDIF
     C     HAZITM        IFEQ      'Y'
     C                   WRITE     OE2025Z1
DW   C                   ADD       1             CNT
     C                   ENDIF
   EOC*                  MOVE      OEDN04        WKDN04
EO   C                   MOVEL     OEDN04        OED104                         UOM
EO   C                   MOVEL     OEDN04        OED204                         UOM
EO   C                   MOVEL     OEDN04        OED304                         UOM
EO   C                   EXSR      SRUOM
EP   C                   select
EP   C                   when      *in37
EP   C                   WRITE     OE2025D1A                                    PRINT LINE ITEM
EP   C                   when      *in38
EP   C                   WRITE     OE2025D1B                                    PRINT LINE ITEM
EP   C                   other
     C                   WRITE     OE2025D1                                     PRINT LINE ITEM
EP   C                   endsl
     C                   ADD       2             CNT
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025D5                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C     *IN56         IFEQ      *ON                                          COMPONENT
     C     *IN67         OREQ      *ON                                          PRT TAX/TRM
     C     *IN85         OREQ      *ON                                          PRIMARY LOC
     C     *IN86         OREQ      *ON                                          SECOND LOC
EE   C     *in89         oreq      *on                                          item#
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
EJ   C                   eval      *in34 = *off
EJ    * If order uses tax software, do not print 'Taxable'
EJ   C                   if        getTaxCalType(trn_typ:ordKey) = 'A'
EJ   C                   eval      *in34 = *on
EJ   C                   endif
     C                   WRITE     OE2025D2                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C                   ENDIF
      * print mfg# if available
¢a   c     mfg#          ifne      *blanks
¢a   C                   MOVE      *BLANKS       WKDN01
¢a   C                   MOVE      *BLANKS       WKPDDS
¢a   C                   MOVE      *BLANKS       WKNO04
¢a   C                   MOVE      MFGHDG        WKNO04
¢a   C                   MOVEL     MFG#          WKDN01                         DESCRIPTION
¢a   C     WKNO04        CAT       WKDN01:1      WKPDDS
¢a   C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
¢a   C                   ENDCS
¢a   c                   write     oe2025D4
¢a   c                   add       1             CNT
¢a   c                   end
¢a   C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
¢a   C                   ENDCS
     C     *IN90         IFEQ      *ON
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025D6
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEA     '0'           *IN(80)
     C                   MOVEA     '00'          *IN(55)
      *
      * EXTENDED DESCRIPTION
      *
     C     IVCD36        IFEQ      'Y'                                          EXTENDED DESC
     C     IVNO07        SETLL     IVFMEXT                                43
     C     *IN43         IFEQ      '1'
     C     *IN44         DOUEQ     '1'
     C     IVNO07        READE     IVFMEXT                                44
     C     *IN44         IFEQ      '0'
     C                   MOVE      *BLANKS       PDDS35
     C                   MOVEL     IVDN18        PDDS35                         DESCRIPTION
     C                   MOVE      *BLANKS       IVDN01
     C                   MOVEL     IVDN18        IVDN01
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025D3                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C                   END
     C                   END
     C                   END
     C                   END
      * ALIAS NUMBER
     C     IVCD56        CASEQ     'Y'           PRTALI                         PRINT ALIAS
     C                   END
      *
      * SEE IF SHIPPING INSTRUCTIONS EXIST - IF SO, PRINT THEM
      *
     C                   Z-ADD     IVNO07        HITEM
     C     HITEM         SETLL     HZFMSIN                                45
     C     *IN45         IFEQ      *ON
     C     *IN45         DOUEQ     *ON
     C     HITEM         READE     HZFMSIN                                45
     C     *IN45         IFEQ      *OFF
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   MOVEL     HZDN04        SHPINS
     C                   WRITE     OE2025S1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C     MSDS#         IFNE      *BLANKS
     C                   WRITE     OE2025M1
DW   C                   ADD       2             CNT
     C                   ENDIF
      *
     C     WHMBR         IFEQ      'Y'
     C                   EXSR      WHLOC
     C                   ENDIF
      *
      * LINE ITEM COMMENTS
      *
     C     OECD30        IFEQ      'Y'                                          LINE ITEM TAGS
     C     TAGKEY        SETLL     OEFTOT                                 43
     C     *IN43         IFEQ      '1'
     C     *IN44         DOUEQ     '1'
     C     TAGKEY        READE     OEFTOT                                 44
     C     *IN44         IFEQ      '0'
     C                   MOVEL     OEDN05        PDDS35                         DESCRIPTION
     C                   MOVE      *BLANKS       IVDN01
     C                   MOVEL     OEDN05        IVDN01
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025D3                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C                   END
     C                   END
     C                   END
     C                   END
      * SERIAL NUMBERS
     C     IVCD57        IFEQ      'Y'                                          SERIAL# USED
   DFC*    SRLKEY        SETLL     OEFTSR
   DFC*    SRLKEY        READE     OEFTSR                                 44    SERIAL# FILE
DF   C                   MOVE      'SO'          IVCDF8
DF   C     SRLKEY        SETLL     IVFTSRL
DF   C     SRLKEY        READE     IVFTSRL                                44    SERIAL# FILE
     C     *IN44         DOWEQ     '0'
     C                   MOVE      *BLANKS       WKPDDS
     C                   MOVE      *BLANKS       WKNO04
     C                   MOVE      *BLANKS       WKDN01
     C                   MOVE      SNHDG         WKNO04
¢S   C                   IF        IVCD17 <> 'DAI' OR
¢S   C                             IVCD17 =  'DAI' AND
¢S   C                             (%LEN(%TRIM(IVNOA0))) > 8
   DFC*                  MOVEL     OENO25        WKDN01                         DESCRIPTION
DF   C                   MOVEL     IVNOA0        WKDN01                         DESCRIPTION
¢S   C                   ELSE
¢S   C                   EVAL      WKDN01 = %SUBST(IVNOA0:1:7) +
¢S   C                             '             '
¢S   C                   ENDIF
     C                   MOVEL     WKNO04        WKPDDS
     C                   MOVE      WKDN01        WKPDDS
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025D4                                     PRINT LINE ITEM
     C                   ADD       1             CNT
   DFC*    SRLKEY        READE     OEFTSR                                 44    SERIAL# FILE
DF   C     SRLKEY        READE     IVFTSRL                                44    SERIAL# FILE
     C                   END
     C                   END
      *
      * PRINT VENDOR RETURN DETAILS.
     C     OECD14        IFNE      *BLANKS                                      V/R REQUIRED
     C                   MOVE      'OE55'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     OECD14        TABENT
     C                   MOVE      'B'           TABENT
     C     TABKEY        CHAIN(N)  TBFMTBL                            40
DZ    *
     C     *IN40         IFEQ      '1'
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     OECD14        TABENT
     C                   MOVE      'V'           TABENT
DZ   C     TABKEY        CHAIN(N)  TBFMTBL                            40
     C                   ENDIF
DZ    *
DZ   C     *IN40         IFEQ      '1'
DZ   C                   MOVE      *BLANKS       TABENT
DZ   C                   MOVEL     OECD14        TABENT
DZ   C                   MOVE      'C'           TABENT
DZ   C     TABKEY        CHAIN(N)  TBFMTBL                            40
DZ   C                   ENDIF
DZ    *
     C     *IN40         IFEQ      '0'
     C     TBNO03        ANDNE     *BLANKS
     C                   MOVE      *BLANKS       WKPDDS
     C                   MOVE      *BLANKS       WKNO04
     C                   MOVE      *BLANKS       WKDN01
     C                   MOVE      TBNO03        RSNDSC           27
     C                   MOVE      VRHDG1        WKNO04
     C                   MOVEL     RSNDSC        WKDN01                         V/R REASON DESC.
     C                   MOVEL     WKNO04        WKPDDS
     C                   MOVE      WKDN01        WKPDDS
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025D4                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   ENDIF
      *
      *     TAG #.
     C     OENO27        IFNE      *BLANKS
     C                   MOVE      *BLANKS       WKPDDS
     C                   MOVE      *BLANKS       WKNO04
     C                   MOVE      *BLANKS       WKDN01
     C                   MOVE      VRHDG2        WKNO04
     C                   MOVEL     OENO27        WKDN01                         TAG#
     C                   MOVEL     WKNO04        WKPDDS
     C                   MOVE      WKDN01        WKPDDS
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025D4                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C                   ENDIF
      *
      *     R/A AUTHORIZATION #.
     C     OENO69        IFNE      *BLANKS
     C                   MOVE      *BLANKS       WKPDDS
     C                   MOVE      *BLANKS       WKNO04
     C                   MOVE      *BLANKS       WKDN01
     C                   MOVE      VRHDG3        WKNO04
     C                   MOVEL     OENO69        WKDN01
     C                   MOVEL     WKNO04        WKPDDS
     C                   MOVE      WKDN01        WKPDDS
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025D4                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WKPDDS
      *
      *  See if the line item is a lot control item
      *
     C                   MOVE      *OFF          *IN66
     C     ITMKEY        CHAIN     IVFMSBR                            66
     C     *IN66         IFEQ      *OFF
     C     IVCDL5        IFEQ      'Y'
      *
      *  See if there are lot transactions for this invoice and
      *  if so, print them
      *
     C                   MOVE      *OFF          *IN91
     C                   Z-ADD     OENO22        TRNLIN
     C                   MOVE      'SO'          TRNTYP
     C     IVTKEY        SETLL     IVFTLOT                                91
     C     *IN91         IFEQ      *ON                                          PRINT LOT DT
     C                   EXSR      PRTLOT
     C                   ELSE
      *
      *  If this is a lot item but no lot transactions exist yet,
      *  print 2 blank lines to allow picking person to write lot/qty.
      *
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025L1
     C                   WRITE     OE2025L1
     C                   ADD       2             CNT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      * LOT NUMBERS
     C     WHMBR         IFEQ      'Y'
     C                   CLEAR                   HDDTA2
     C                   MOVE      ORDER         HD2ORD                         TRANS #
     C     IVNO07        IFNE      *ZEROS
     C                   Z-ADD     IVNO07        HD2ITM                         ITEM
     C                   ENDIF
     C     IVNO04        IFNE      *BLANKS
     C                   MOVEL     IVNO04        HD2NSI                         NONSTK
     C                   ENDIF
     C                   MOVE      'Y'           LOTYN             1
     C     LOTYN         DOWEQ     'Y'
     C                   CLEAR                   WMDTA2
     C                   CLEAR                   WMERR
     C                   CLEAR                   PRMPT
     C                   CALL      'WIR0140'
     C                   PARM      'PTL'         FROM
     C                   PARM                    PRMPT
     C                   PARM                    HDDTA2
     C                   PARM                    WMDTA2
     C                   PARM                    WMERR
     C     WMERR         IFEQ      'END'
     C                   MOVE      'N'           LOTYN
     C                   LEAVE
     C                   ENDIF
     C                   MOVE      'Lot#'        WMTEXT            4
     C                   CLEAR                   IVDN01
     C                   MOVE      WM2LOT        IVDN01                         DESCRIPTION
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025D3                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C                   ENDDO
     C                   CLEAR                   WM2QTY
     C                   CLEAR                   WM2UOM
     C                   CLEAR                   WMTEXT
     C                   ENDIF
      *
      * PRINT RESTRICTED MATERIALS CERTIFICATES
      *
     C     RESMAT        IFEQ      'Y'
     C     *IN45         DOUEQ     *ON
     C     ITMBKY        READE     IVFMRSB                                45
     C     *IN45         IFEQ      *OFF
     C     RESKEY        CHAIN     ARFMRES                            44
     C     *IN44         IFEQ      *OFF
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025RS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C     HAZITM        IFEQ      'Y'
     C                   WRITE     OE2025Z2
DW   C                   ADD       1             CNT
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       IVDN01                         DESCRIPTION
     C                   MOVE      *BLANKS       PRMDN7
     C                   MOVE      *BLANKS       PRMDN8
     C                   MOVE      *BLANKS       PRMDN9
     C                   MOVE      *BLANKS       SECDN7
     C                   MOVE      *BLANKS       SECDN8
     C                   MOVE      *BLANKS       SECDN9
     C                   ENDSR
EO    ********************************************************************
EO    * CONVERT UOM BASED ON VALUES IN TABLE FILE UOMD
EO    ********************************************************************
EO    *
EO   C     SRUOM         BEGSR
E3   C                   If        OEDN04 = *Blanks
E3   C                   Leavesr
E3   C                   Endif
EO    *
EP    *  OEQY01 has to be less than 100,000 to print decimals
EP    *  and smartforms have to be in use
EP    *
EO   C                   Z-ADD     *ZEROS        AM39A                          unit price
EP   C                   Z-ADD     *ZEROS        AM39B                          unit price
EP   C                   Z-ADD     *ZEROS        NETPA            10 4          net price
EP   C                   Z-ADD     *ZEROS        NETPB            10 4          net price
EP   C                   CLEAR                   CQY011            5 1
EP   C                   CLEAR                   CQY021            5 1
EP   C                   CLEAR                   CQY031            5 1
EP   C                   CLEAR                   #TBNO3
EO EPC*                  Z-ADD     *ZEROS        NETPA                          net price
EO EPC*                  CLEAR                   CQY011            7 1
EO EPC*                  CLEAR                   CQY021            7 1
EO EPC*                  CLEAR                   CQY031            7 1
EO    *
EO   C                   MOVE      *OFF          *IN37
EO   C                   MOVE      *OFF          *IN38
EP   C                   if        Dtp = 'BPDF' and
EP   C                             OEQY01 < 100000 or
EP   C                             Dtp = 'BPDF' and
EP   C                             OEQY01 > -100000
EP
EO   C                   MOVE      'UOMD'        TABCOD
EO   C                   MOVE      *BLANKS       TABENT
EO EPC*                  MOVEL     LDN04         TABENT
EP   C                   MOVEL     OEDN04        TABENT
EO   C                   Z-ADD     *ZEROS        #FCT                           FACTOR TO DIVIDE QTY
EO   C                   MOVE      *BLANKS       TBNO02
EO   C                   MOVEL(P)  '   001'      TBNO03
EO   C     TABKEY        CHAIN(N)  TBFMTBL                            40
EO   C     *IN40         IFEQ      *OFF
EO   C     TBNO02        IFEQ      *BLANKS
EO   C                   MOVE      *BLANKS       TBNO02
EO   C                   MOVEL(P)  '   001'      TBNO03
EO   C                   ENDIF
EO   C                   MOVEL     TBNO03        #TBNO3
EO   C                   MOVEL     TBNO02        #TBN2A            2
EO   C                   ENDIF
EO    *
EO    *------------------------------------------------------------------
EO EPC*    *IN29         IFEQ      *ON                                          PRINT QUANTITY
EO EPC*    #TBN2A        IFEQ      LDN04
EO EP *
EO EP * UNIT OF MESURE IN TABLE FILE UOMD, CONVERSION AND PRINT 2 DECIMAL
EO EP *
EO EPC*                  MOVEL     @UOM          LDN04A            3
EO EPC*                  MOVEL     @UOM          CUOM24            3            UOM
EO EPC*    LQY01         DIV       #FCT          CQY01             7 2
EO EPC*    LQY03         DIV       #FCT          CQY03             7 2
EO EPC*    OEQY02        DIV       #FCT          CQY02             7 2
EO EPC*    *IN57         IFEQ      *OFF
EO EPC*    OEAM39        MULT      #FCT          AM39A                          unit price
EO EPC*                  ENDIF                                                  *IN57 IFEQ *OFF
EO EPC*    *IN57         IFEQ      *ON
EO EPC*    OEAM38        MULT      1             NETPA                          net price
EO EPC*                  ENDIF                                                  *IN57 IFEQ *ON
EO EP *
EO EPC*                  IF        @DECIMAL = '1'
EO EPC*                  MOVEA     '01'          *IN(37)
EO EPC*                  EVAL(H)   CQY011=CQY01
EO EPC*                  EVAL(H)   CQY021=CQY02
EO EPC*                  EVAL(H)   CQY031=CQY03
EO EPC*                  ELSE
EO EPC*                  MOVEA     '10'          *IN(37)
EO EPC*                  ENDIF                                                  *IN40 IFEQ *OFF
EO EP *
EO EPC*                  ENDIF                                                  #TBN2A IFEQ LDN04
EO EPC*                  ENDIF                                                  *IN29 IFEQ *ON
EO EP *------------------------------------------------------------------
EO EP *
EO EPC*                  MOVE      *OFF          *IN37
EO EPC*                  MOVE      'UOMD'        TABCOD
EO EPC*                  MOVE      *BLANKS       TABENT
EO EPC*                  MOVEL     OED104        TABENT
EO EPC*                  Z-ADD     *ZEROS        #FCT                           FACTOR TO DIVIDE QTY
EO EPC*                  MOVE      *BLANKS       TBNO02
EO EPC*                  MOVEL(P)  '   001'      TBNO03
EO EPC*    TABKEY        CHAIN(N)  TBFMTBL                            40
EO EPC*    *IN40         IFEQ      *OFF
EO EPC*    TBNO02        IFEQ      *BLANKS
EO EPC*                  MOVE      *BLANKS       TBNO02
EO EPC*                  MOVEL(P)  '   001'      TBNO03
EO EPC*                  ENDIF
EO EPC*                  MOVEL     TBNO03        #TBNO3
EO EPC*                  MOVEL     TBNO02        #TBN2A            2
EO EPC*                  ENDIF
EO EP *
EO EPC*    *IN29         IFEQ      *OFF                                         PRINT UOM
EO EPC*    #TBN2A        IFEQ      OED104
EO    *
EO    * UNIT OF MESURE IN TABLE FILE UOMD, CONVERSION AND PRINT 2 DECIMAL
EO    *
EP   C                   if        *in40 = *off
EO EPC*                  MOVE      *ON           *IN37
EO   C                   MOVEL     @UOM          CUOM14            3            UOM
EO   C                   MOVEL     @UOM          CUOM24            3            UOM
EO   C                   MOVEL     @UOM          OED104                         UOM
EO EPC*                  MOVEL     @UOM          LDN04                          UOM
EO EPC*    OEQY01        DIV       #FCT          CQY01             7 2
EO EPC*    OEQY03        DIV       #FCT          CQY03             7 2
EO EPC*    OEQY02        DIV       #FCT          CQY02             7 2
EP   C     OEQY01        DIV       #FCT          CQY01             5 2
EP   C     OEQY03        DIV       #FCT          CQY03             5 2
EP   C     OEQY02        DIV       #FCT          CQY02             5 2
EO   C     *IN57         IFEQ      *OFF
EO   C     OEAM39        MULT      #FCT          AM39A                          unit price
EO   C                   ENDIF                                                  *IN57 IFEQ *OFF
EO   C     *IN57         IFEQ      *ON
EO   C     OEAM38        MULT      1             NETPA                          net price
EO   C                   ENDIF                                                  *IN57 IFEQ *ON
EO    *
EO   C                   IF        @DECIMAL = '1'
EO   C                   MOVEA     '01'          *IN(37)
EP   C     OEAM39        MULT      #FCT          AM39B                          unit price
EP   C     OEAM38        MULT      1             NETPB                          net price
EO   C                   EVAL(H)   CQY011=CQY01
EO   C                   EVAL(H)   CQY021=CQY02
EO   C                   EVAL(H)   CQY031=CQY03
EO   C                   ELSE
EO   C                   MOVEA     '10'          *IN(37)
EO   C                   ENDIF                                                  *IN40 IFEQ *OFF
EO    *
EO   C                   ENDIF                                                  #TBN2A IFEQ OED104
EO   C                   ENDIF                                                  *IN29 IFEQ *OFF
EO EP *------------------------------------------------------------------
EO EP *
EO EP *
EO EPC*    *IN37         IFEQ      *ON
EO EPC*    *IN38         OREQ      *ON
EO EP *
EO EPC*    *IN50         IFEQ      *ON
EO EPC*    *IN57         ANDEQ     *OFF
EO EPC*    *IN56         ANDNE     *ON                                          not compo
EO EPC*                  ELSE                                                   *IN50 IFEQ *ON
EO EPC*                  MOVEL     *BLANKS       OEPC01
EO EPC*                  ENDIF                                                  *IN50 IFEQ *ON
EO EPC*    *IN63         IFEQ      *ON
EO EPC*                  Z-ADD     OEAM05        OEAMA5
EO EPC*                  ELSE                                                   *IN63 IFEQ *ON
EO EPC*                  Z-ADD     *ZEROS        OEAMA5
EO EPC*                  ENDIF                                                  *IN63 IFEQ *ON
EO EPC*                  ENDIF                                                  *IN37 IFEQ *ON
EO    *
EO   C                   ENDSR
      ********************************************************************
      ****** CASH SALES/OTHER CHARGES ************************************
      ********************************************************************
     C     CSHSR         BEGSR
     C     OENO01        CHAIN     OEFTOC                             49        CASH SALE MSTR
     C     OEFL09        IFEQ      'Y'                                          OTHER CHARGES
     C     OENO01        SETLL     OEFTOR                                 47
     C     *IN47         IFEQ      '1'
     C     *IN48         DOUEQ     '1'
     C     OENO01        READE     OEFTOR                                 48
     C     *IN48         IFEQ      '0'
     C     *IN61         IFEQ      *ON                                          USING GST
     C                   ADD       OEAM03        OCAMT
     C                   ELSE
     C     OECD06        IFEQ      'F'                                          FREIGHT CHARGE
     C                   Z-ADD     OEAM03        FRTAMT            7 2          FREIGHT AMOUNT
     C                   ELSE
     C                   ADD       OEAM03        OCAMT             7 2
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
      * WAS A DEPOSIT WITHDRAWAL MADE FOR THIS CASH SALE INVOICE
      * ** MULTIPLE WITHDRAWALS ARE POSSIBLE **
      *
     C     OEFL02        IFEQ      'Y'
     C     OPNDD2        IFNE      'Y'
     C                   OPEN      OELTDD2
     C                   MOVE      'Y'           OPNDD2            1
     C                   END
     C                   MOVE      'W'           OECD51
     C                   MOVE      ORDER         OENO44
     C     KYTDD         SETLL     OEFTDD                                 40
     C     *IN40         IFEQ      '1'
      *
      * DETERMINE NUMBER OF WITHDRAWALS FOR OVERFLOW
      *
     C     CNT           ADD       7             WCNT
     C     *IN40         DOUEQ     *ON
     C     KYTDD         READE     OEFTDD                                 40
     C     *IN40         IFEQ      '0'
     C                   ADD       1             WCNT
     C                   ENDIF
     C                   ENDDO
      *
     C     WCNT          CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025DW
     C                   ADD       4             CNT
     C                   Z-ADD     OETL01        RMN$                           REMAINING AMOUNT
      *
     C     KYTDD         SETLL     OEFTDD                                 40
     C     *IN40         DOUEQ     *ON
     C     KYTDD         READE     OEFTDD                                 40
     C     *IN40         IFEQ      '0'
     C                   ADD       1             CNT
     C     CNT           IFGT      MAXLIN
     C                   EXSR      OVRFLW
     C                   WRITE     OE2025DW
     C                   ENDIF
     C                   WRITE     OE2025WD
     C                   SUB       OEAM22        RMN$
     C                   ENDIF
     C                   ENDDO
      *
      * ONLY ADD BOTTOM ROW OF STARS IF ROOM ON PAGE
      *
     C                   ADD       1             CNT
     C     CNT           IFLE      MAXLIN
     C                   WRITE     OE2025WS
     C                   ENDIF
      *
      * PRINT REMAINING BALANCE DUE
      *
     C                   ADD       2             CNT
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
     C                   WRITE     OE2025RM
     C                   END
     C                   END
      *
     C     OCAMT         IFNE      0
     C                   MOVE      '1'           *IN54
     C                   END
      *
     C     OEAM08        IFNE      0
     C                   MOVE      '1'           *IN51
     C                   ELSE
     C                   MOVE      '0'           *IN51
     C                   END
EL
EL    * Get totals at ordered quantity
EL   C                   If        OECD08 = 'Q'
EL   C                               and ExtendQte = 'O'
EL   C                   Clear                   OrdSub
EL   C                   Clear                   OrdTx
EL   C                   Clear                   GstTx
EL   C                   Call      'OEC0002'     PLOE02
EL    * Order Total = Subtotal(line items) + Other Chgs + Cash Disc + Tax
EL   C     OrdSub        Add       Oetl03        Oetl01
EL   C                   Add       Oeam08        Oetl01
EL   C                   Add       OrdTx         Oetl01
EW   C                   Add       GSTTx         Oetl01
EL   C                   Z-add     OrdTx         Oeam04
EW   C                   Z-add     GSTTx         Oeam44
EL   C                   Z-add     OrdSub        Oetl02
EL   C                   Endif
EL
     C     CNT           ADD       2             WCNT
     C     OECD67        IFEQ      'Y'
D4   C                   if        Dtp <> 'BPDF'
     C                   WRITE     OE2025NT
     C                   WRITE     OE2025SH
     C                   WRITE     OE2025EO
D4   C                   else
D4   C                   WRITE     OE2025NTB
¢A   C                   Z-ADD     OEWT01        WGHT              7 0
D4   C                   WRITE     OE2025SHB
D4   C                   WRITE     OE2025EOB
D4   C                   endif
     C     PRTPRC        IFEQ      'Y'
     C                   MOVE      OETL01        WKTL01
D4   C                   if        Dtp <> 'BPDF'
     C                   WRITE     OE2025BP
D4   C                   else
D4   C                   WRITE     OE2025BPB
D4   C                   endif
     C                   ENDIF
     C                   ELSE
     C     OEFL02        IFEQ      'Y'
     C     OEFL02        OREQ      'C'
     C     OECD08        OREQ      'Q'                                          QUOTE
     C     OEFL18        OREQ      'Y'                                          CHG INV
DP   C     OECD79        OREQ      'Y'
DY   C     ARFL88        OREQ      'Y'                                          CHGINV
D4   C                   if        Dtp <> 'BPDF'
     C                   WRITE     OE2025NT
D4   C                   else
D4   C                   WRITE     OE2025NTB
D4   C                   endif
     C                   Z-ADD     OCAMT         OCAMT1
     C                   Z-ADD     OCAMT         OCAMT2
     C                   MOVE      OEPC08        OEPCT8
     C                   Z-ADD     OEAM44        OEAMT4
     C                   Z-ADD     OEAM08        OEAMT8
     C                   Z-ADD     OETL01        OETOT1
     C                   MOVE      GHTXT1        GHTXT2
D4   C                   if        Dtp <> 'BPDF'
     C                   WRITE     OE2025TL
D4   C                   else
¢A   C                   Z-ADD     OEWT01        WGHT              7 0
D4   C                   WRITE     OE2025TLB
D4   C                   endif
     C                   ELSE
D4   C                   if        Dtp <> 'BPDF'
     C                   WRITE     OE2025NT
     C                   WRITE     OE2025SH
     C                   WRITE     OE2025EO
D4   C                   else
D4   C                   WRITE     OE2025NTB
¢A   C                   Z-ADD     OEWT01        WGHT              7 0
D4   C                   WRITE     OE2025SHB
D4   C                   WRITE     OE2025EOB
D4   C                   endif
     C                   END
     C                   END
     C                   ENDSR
      ********************************************************************
      ****** CLEAR FIELDS AND INDICATORS *********************************
      ********************************************************************
     C     CLEAR         BEGSR
     C                   MOVE      '0'           *IN
     C                   MOVE      *BLANKS       IVNO04
     C                   MOVE      *BLANKS       IVDN01
     C                   MOVE      *BLANKS       IVDN02
     C                   MOVE      *BLANKS       ARNM01
     C                   MOVE      *BLANKS       OECD03
     C                   MOVE      *BLANKS       OEFL02
     C                   MOVE      *BLANKS       OEFL18
     C                   Z-ADD     0             OECN03
     C                   Z-ADD     0             OECN02
     C                   Z-ADD     0             ARNO07                         AREA CODE
     C                   Z-ADD     0             ARNO08                         TEL PREFIX
     C                   Z-ADD     0             ARNO09                         TEL SUFFIX
     C                   Z-ADD     0             OEAM01
     C                   Z-ADD     0             OEAM05
     C                   Z-ADD     0             OEAM08
     C                   Z-ADD     0             OEQY01
     C                   Z-ADD     0             OEQY02
     C                   Z-ADD     0             OEQY03
     C                   MOVE      *BLANKS       OEPC01
     C                   MOVE      *BLANKS       OEDN04
     C                   Z-ADD     0             CNT
     C                   Z-ADD     0             DATORD
     C                   Z-ADD     0             DATSHP
     C                   Z-ADD     0             FRTAMT
     C                   MOVE      *BLANKS       PRMDN7
     C                   MOVE      *BLANKS       PRMDN8
     C                   MOVE      *BLANKS       PRMDN9
     C                   MOVE      *BLANKS       SECDN7
     C                   MOVE      *BLANKS       SECDN8
     C                   MOVE      *BLANKS       SECDN9
     C                   Z-ADD     0             SEQNUM
     C                   Z-ADD     0             TEL                            DS TELEPHONE
     C                   Z-ADD     0             NETP
     C                   MOVE      *BLANKS       ORIG1
     C                   MOVE      *BLANKS       MAIL
     C                   MOVE      *BLANKS       SHIP
     C                   MOVE      *BLANKS       ARAD01
     C                   MOVE      *BLANKS       ARAD02
     C                   MOVE      *BLANKS       ARAD03
     C                   MOVE      *BLANKS       ARAD04
     C                   MOVE      *BLANKS       ARAD05
     C                   MOVE      *BLANKS       ARAD06
     C                   MOVE      *BLANKS       ARAD07
     C                   MOVE      *BLANKS       ARAD08
     C                   MOVE      *BLANKS       ARAD10
     C                   MOVE      *BLANKS       ARAD11
     C                   MOVE      *BLANKS       ARCY01
     C                   MOVE      *BLANKS       ARCY02
     C                   MOVE      *BLANKS       ARCY03
     C                   MOVE      *BLANKS       ARCY04
     C                   MOVE      *BLANKS       ARST01
     C                   MOVE      *BLANKS       ARST02
     C                   MOVE      *BLANKS       ARST03
     C                   MOVE      *BLANKS       ARST04
     C                   MOVE      *BLANKS       ARZP15
     C                   MOVE      *BLANKS       ARZP16
     C                   MOVE      *BLANKS       ARZP17
     C                   MOVE      *BLANKS       ARZP18
     C                   MOVE      *BLANKS       ARNO17
     C                   MOVE      *BLANKS       ARNO18
     C                   MOVE      *BLANKS       ARNO19
     C                   MOVE      *BLANK        WALKIN            1
     C                   MOVE      *ALL'*'       STAR70           70
     C                   MOVE      *ZEROS        OEAM20
     C                   MOVE      *ZEROS        OEAM22
     C                   MOVE      *ZEROS        OEAM24
     C                   MOVE      *ZEROS        OEAM25
     C                   MOVE      *ZEROS        OEAM37
     C                   MOVE      *BLANKS       OECD51
     C                   MOVE      *BLANKS       OECD61
     C                   MOVE      *BLANKS       OEDN01
     C                   MOVE      *BLANKS       OEDN08
     C                   MOVE      *BLANKS       OEDN11
     C                   MOVE      *BLANKS       OEFL06
     C                   MOVE      *BLANKS       OENO06
     C                   MOVE      *BLANKS       OENO07
     C                   MOVE      *ZEROS        OENO08
     C                   MOVE      *ZEROS        OENO16
     C                   MOVE      *BLANKS       OENO30
     C                   MOVE      *BLANKS       OENM02
     C                   MOVE      *BLANKS       OENM14
     C                   MOVE      *BLANKS       OEID01
     C                   MOVE      *BLANKS       OEID02
     C                   MOVE      *BLANKS       OEVIA            26
     C                   MOVE      *ZEROS        ARDS05
     C                   MOVE      *ZEROS        ARDS06
     C                   MOVE      *ZEROS        OEDS10
     C                   MOVE      *ZEROS        OEDS11
     C                   MOVE      *ZEROS        DEPCO#
     C                   MOVE      *ZEROS        DEPBR#
     C                   MOVE      *ZEROS        DEPCK#
     C                   MOVE      *BLANKS       PAYTYP           15
     C                   MOVE      *BLANKS       SHNM07
     C                   MOVE      *BLANKS       SHAD10
     C                   MOVE      *BLANKS       SHAD11
     C                   MOVE      *BLANKS       SHCY04
     C                   MOVE      *BLANKS       SHST04
     C                   MOVE      *BLANKS       SHZP18
     C                   CLEAR                   ADDR1
     C                   CLEAR                   ADDR2
     C                   CLEAR                   ADDR3
     C                   CLEAR                   RMIT
     C                   CLEAR                   RMITZP
     C                   MOVE      *ZEROS        RMN$
     C                   MOVE      *BLANKS       PMTTYP
     C                   MOVE      *BLANKS       ORDTYP
     C                   MOVE      *BLANKS       ORDSTS
     C                   Z-ADD     0             OCAMT
     C                   CLEAR                   ARCDC6
     C                   ENDSR
      *------------------------------------------------------------------------*
      * THIS SUBROUTINE PRINTS ALIAS PRODUCT NUMBER
      *------------------------------------------------------------------------*
     C     PRTALI        BEGSR
     C     OPNALI        IFNE      'Y'
     C                   MOVE      'Y'           OPNALI            1
     C                   OPEN      IVLMALI4
     C                   END
     C     ARNO01        IFNE      *ZERO
     C                   Z-ADD     ARNO01        WKCUST
     C     ALIKEY        CHAIN     IVFMALI                            40
     C     *IN40         IFEQ      *ON
     C     ARNO82        ANDNE     0
     C     ALIKY2        CHAIN     IVFMALI                            40
     C                   ENDIF
      * DO NOT PRINT ALIAS IF NOT ATTACHED TO THIS CUST#
     C     *IN40         IFEQ      '0'
     C                   MOVEA     *BLANKS       ALI(11)
     C                   MOVEA     ALNO41        ALI(12)
     C                   MOVEA     ALI           PDDS             48
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025AL                                     PRINT ALIAS #
     C                   ADD       1             CNT
     C                   END
     C                   END
     C                   MOVE      *BLANKS       PDDS
     C                   ENDSR
      *------------------------------------------------------------------------*
      * CALCULATE INVOICE TERMS AND DUE DATE
      *------------------------------------------------------------------------*
     C     TERMSR        BEGSR
     C     DINV          IFEQ      *ZEROS
     C                   Z-ADD     UDATE         DINV                           DATE INVOICED
     C                   MOVEL     *YEAR         OECC01
     C                   ENDIF
     C                   MOVE      'AR01'        TABCOD                         TABLE CODE
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     '   INV'      TABENT                         TABLE ENTRY
     C                   MOVE      ARNO15        CMPANY            3
     C                   MOVEL     CMPANY        TABENT                         TABLE ENTRY
     C     *IN99         DOUEQ     *OFF
     C     TABKEY        CHAIN     TBFMTBL                            4099
     C                   ENDDO
     C     *IN40         IFEQ      '0'
   DJC*                  Z-ADD     0             INVNUM                         INITIALIZE DS
DJ   C                   CLEAR                   INVNUM                         INITIALIZE DS
     C                   Z-ADD     0             INVDTE                         INITIALIZE DS
     C                   MOVE      TBNO03        INVDTA
      * ASSIGN INVOICE NUMBER
     C     OENO04        IFEQ      '       '
     C     ORDINV        IFEQ      'YES'
     C                   MOVEL     OENO01        OENO04
     C                   ELSE
     C     *IN73         DOUEQ     '0'
     C     *IN74         ANDEQ     '0'
DK   C     *IN72         ANDEQ     *OFF
   DJC*                  ADD       1             INVNUM
DJ    * Increment the invoice number...
DJ   C                   eval      invNum = addTransNo(invNum)
DJ    * See if the number should be excluded...
DJ   C                   eval      outTransNo = excTransNo(invNum)
DJ   C                   if        excNumber = 'Y'
DJ   C                   eval      invNum = highNumber
DJ   C                   eval      *in73 = *on
DJ   C                   iter
DJ   C                   endif
DJ    *
     C     I#KEY         SETLL     OEFTOHY                                73
     C     I#KEY         SETLL     OEFTOH26                               74
DK   C     I3KEY         SETLL     ARFTRAN                                72
     C                   END
     C                   MOVEL     INVNUM        OENO04
     C                   END
     C                   END
     C                   MOVE      INVDTA        TBNO03
     C                   UPDATE    TBFMTBL
     C                   END
      * SKIP TO ENDSR IF CASH SALE INVOICE
     C     OEFL02        CABEQ     'Y'           ENDTRM
     C     OETL12        IFNE      0
     C     OETL01        SUB       OETL12        AFTDSC                         DUE AFTER DISC
     C                   Z-ADD     AFTDSC        AFTDS2                         DUE AFTER DISC
     C     OETL12        IFGT      0
     C                   MOVE      *ON           *IN75
     C                   ELSE
     C                   MOVE      *ON           *IN77
     C                   ENDIF
      * GET INVOICE TERMS INFO
     C                   EXSR      GETTRM
      * CALCULATE DISCOUNT DATE
     C                   EXSR      CLCDAT
     C                   Z-ADD     DISCMO        DDSCMO
     C                   Z-ADD     DISCDY        DDSCDY
     C                   Z-ADD     DISCYR        DDSCYR
     C                   END
     C     ENDTRM        TAG
     C                   ENDSR
      *------------------------------------------------------------------------*
      * GET INVOICE TERMS INFO
      *------------------------------------------------------------------------*
     C     GETTRM        BEGSR
      *
     C     ARCDF9        CHAIN     ARFMTRD                            93
     C     *IN93         DOWEQ     *OFF
     C     OEDY01        IFLE      ARDY85
      * DISCOUNT TERMS INFO
     C                   Z-ADD     ARDY86        ARCD26
     C                   Z-ADD     ARNOC2        ARNOC6
     C                   Z-ADD     ARNOC4        ARCDB6
      * DUE TERMS INFO
     C                   Z-ADD     ARDY87        ARDY88
     C                   Z-ADD     ARNOC3        ARNOC7
     C                   Z-ADD     ARNOC5        ARNOC8
     C                   LEAVE
     C                   ENDIF
     C     ARCDF9        READE     ARFMTRD                                93
     C                   ENDDO
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * CALCULATE A/R DATES
      *------------------------------------------------------------------------*
     C     CLCDAT        BEGSR
      * SET DATA STRUCTURE VALUES
      * COMPANY NUMBER
     C                   Z-ADD     ARNO15        CO#
      * AGING MODE
     C                   SELECT
     C     OECD08        WHENEQ    'O'
     C                   MOVE      GRP1AM        AGEMOD
     C     OECD08        WHENEQ    'D'
     C     OECD08        OREQ      'C'
     C                   MOVE      GRP2AM        AGEMOD
     C                   ENDSL
      * IF USING DATE AGING
      * OR USING ROLL AGING AND FOR SALES ORDER
      * USE CALCULATED TERMS
     C     AGEMOD        IFEQ      'O'
     C     AGEMOD        OREQ      'B'
     C     OECD08        ANDEQ     'O'
      * USE PROX TERMS FLAG
     C                   MOVE      ARFL78        PROX
      * TERMS DISCOUNT DAY OF MONTH
     C                   Z-ADD     ARCD26        TMCD26
      * TERMS DISCOUNT NUMBER OF MONTHS TO INCREMENT
     C                   Z-ADD     ARNOC6        TMNOC6
      * TERMS DISCOUNT IN NUMBER OF DAYS
     C                   Z-ADD     ARCDB6        TMCDB6
      * TERMS DUE DAY OF MONTH
     C                   Z-ADD     ARDY88        TMDY88
      * TERMS DUE NUMBER OF MONTHS TO INCREMENT
     C                   Z-ADD     ARNOC7        TMNOC7
      * TERMS DUE IN NUMBER OF DAYS
     C                   Z-ADD     ARNOC8        TMNOC8
     C                   ELSE
      * IF USING ROLL AGING AND FOR CREDIT MEMO, DEBIT MEMO
      * USE ZERO TERMS
      ** THIS WILL FORCE THE DISCOUNT AND DUE DATES TO BE THE SAME AS
      ** THE TRANSACTION DATE
      *
      * USE PROX TERMS FLAG
     C                   CLEAR                   PROX
      * TERMS DISCOUNT DAY OF MONTH
     C                   Z-ADD     0             TMCD26
      * TERMS DISCOUNT NUMBER OF MONTHS TO INCREMENT
     C                   Z-ADD     0             TMNOC6
      * TERMS DISCOUNT IN NUMBER OF DAYS
     C                   Z-ADD     0             TMCDB6
      * TERMS DUE DAY OF MONTH
     C                   Z-ADD     0             TMDY88
      * TERMS DUE NUMBER OF MONTHS TO INCREMENT
     C                   Z-ADD     0             TMNOC7
      * TERMS DUE IN NUMBER OF DAYS
     C                   Z-ADD     0             TMNOC8
     C                   ENDIF
      * BILLING PERIOD
     C                   Z-ADD     ARMO01        BILLMO
     C                   Z-ADD     ARCC01        BILLCC
     C                   Z-ADD     ARYR01        BILLYR
      * TRANSACTION DATE
     C                   Z-ADD     OEMO01        TRANMO
     C                   Z-ADD     OEDY01        TRANDY
     C                   Z-ADD     OECC01        TRANCC
     C                   Z-ADD     OEYR01        TRANYR
      * DISCOUNT DATE
     C                   Z-ADD     0             DISCDT
      * DUE DATE
     C                   Z-ADD     0             DUEDAT
      * CALL DATE CALCULATION SUB PROGRAM
     C                   MOVEL     DSDATE        PMDATE
     C                   CALL      'ARR0110'     PL0110
     C                   MOVEL     PMDATE        DSDATE
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * THIS SUBROUTINE CHECKS FOR OVERFLOW
      *------------------------------------------------------------------------*
     C     OVRFLW        BEGSR
     C                   EXSR      CPYARY
D4   C                   if        Dtp <> 'BPDF'
     C                   WRITE     OE2025NT
     C                   WRITE     OE2025SH
     C                   WRITE     OE2025CN
D4   C                   else
D4   C                   WRITE     OE2025NTB
D4   C                   WRITE     OE2025SHBO
D4   C                   WRITE     OE2025CNB
D4   C                   endif
      *
      * PRINTING BAR CODE?
      *
     C     BCPRT         IFEQ      '1'
     C     BCPRT         OREQ      '2'
     C     OENO01        IFNE      *ZEROS
DI   C     OENO01        ANDNE     *BLANKS
     C                   MOVE      OENO01        BARCDE
     C                   CLEAR                   BARCD2
     C                   MOVEL     OENO01        BARCD2
     C                   MOVE      ARNO01        BARCD2
     C                   MOVE      *OFF          *IN88
     C     BCPRT         IFEQ      '2'
     C                   MOVE      *ON           *IN88
     C                   ENDIF
      *
      * Device type *IPDS...
      *
     C     DTP           IFEQ      'IPDS'
     C                   WRITE     OE2025BC
     C                   ELSE
      *
      * Device type *SCS...
      *
     C     DTP           IFEQ      'SCS'
     C     BBC           ANDNE     *BLANKS
     C                   MOVEL     BBC           FONT1
     C                   MOVEL     EBC           FONT2
     C                   WRITE     OE2025B1
     C                   WRITE     OE2025B2
     C                   WRITE     OE2025B3
D4   C                   else
D4    * Base PDF Form ?
D4   C                   if        Dtp = 'BPDF'
D4   C                   WRITE     OE2025BB
D4   C                   endif
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
D4   C                   EVAL      TYPSTS = %TRIM(ORDTYP) + ' ' + %TRIM(ORDSTS)
     C                   WRITE     OE2025H1
     C                   WRITE     OE2025H2
     C                   Z-ADD     0             CNT
     C                   ENDSR
      *----------------------------------------------------------------
      * GHTXSR - SET UP FIELDS FOR GST VS. HST TAX RATES
      *----------------------------------------------------------------
     C     GHTXSR        BEGSR
     C                   MOVE      *ON           *IN61
     C                   SELECT
     C     OECD86        WHENEQ    'H'
     C                   MOVEL     'HST'         GHTXT1            3
     C     OECD86        WHENEQ    'G'
     C                   MOVEL     'GST'         GHTXT1
     C                   OTHER
     C                   MOVE      *OFF          *IN61
     C                   ENDSL
     C                   ENDSR
      *----------------------------------------------------------------
      * DETERMINE WHETHER TO PRINT PRICE AND/OR EXTENDED AMOUNT...
      *----------------------------------------------------------------
     C     PRICEO        BEGSR
     C                   MOVE      *OFF          *IN60                          AM39
     C                   MOVE      *OFF          *IN62                          NETP
     C                   MOVE      *OFF          *IN63                          OEAM05
     C     OECD43        IFNE      'Y'                                          N/C ITEM?
     C     OECD43        OREQ      'Y'                                          N/C ITEM?
     C     PRTNC         ANDEQ     'Y'                                          PRT N/C?
     C     *IN50         IFEQ      *ON                                          PRT PRCS?
     C     *IN56         ANDEQ     *OFF                                         COMPONENT?
     C     *IN57         IFEQ      *OFF                                         PRT NET?
     C                   MOVE      *ON           *IN60                          AM39
     C                   ELSE
     C                   MOVE      *ON           *IN62                          NETP
     C                   ENDIF
     C     *IN32         IFEQ      *ON                                          PRT EXTD?
     C                   MOVE      *ON           *IN63                          OEAM05
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Print Lot Control detail lines
      *------------------------------------------------------------------------*
     C     PRTLOT        BEGSR
      *
      *  Load array with lot # and qty for printing
      *
     C     IVTKEY        SETLL     IVFTLOT
     C     *IN78         DOUEQ     *ON
     C     IVTKEY        READE     IVFTLOT                                78
     C     *IN78         IFEQ      *OFF
     C                   MOVEA     '00'          *IN(83)
     C                   CLEAR                   IVLOT
     C                   CLEAR                   IVQTY
     C                   MOVEL     IVNO99        IVLOT
     C                   Z-ADD     IVQYL1        IVQTY
     C     IVCDLX        IFEQ      'R'
     C                   MOVE      *ON           *IN83
     C                   ENDIF
     C     IVCDLX        IFEQ      'E'
     C                   MOVE      *ON           *IN84
     C                   ENDIF
      *
     C                   WRITE     OE2025L2
     C                   ADD       1             CNT
      *
     C     CNT           CASGT     MAXLIN        OVRFLW
     C                   ENDCS
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * GET LOCATION FOR WAREHOUSE BRANCHES
      *------------------------------------------------------------------------*
     C     WHLOC         BEGSR
     C                   CLEAR                   HDDTA3
     C                   CLEAR                   WMDTA3
   DIC*                  Z-ADD     OENO01        HD3ORD
DI   C                   MOVE      OENO01        HD3ORD
     C                   Z-ADD     OENO22        HD3CTL
     C                   MOVE      'Y'           LOCYN             1
     C     LOCYN         DOWEQ     'Y'
     C                   CLEAR                   WMDTA3
     C                   CLEAR                   WMERR
     C                   CLEAR                   PRMPT
     C                   CALL      'WIR0140'
     C                   PARM      'WL '         FROM
     C                   PARM                    PRMPT
     C                   PARM                    HDDTA3
     C                   PARM                    WMDTA3
     C                   PARM                    WMERR
     C     WMERR         IFEQ      'END'
     C                   MOVE      'N'           LOCYN
     C                   LEAVE
     C                   ENDIF
     C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
     C                   ENDCS
     C                   WRITE     OE2025WM                                     PRINT LINE ITEM
     C                   ADD       1             CNT
     C                   ENDDO
     C                   ENDSR
      *----------------------------------------------------------------
      * CPYARY - COPY ARRAY DATA TO PRINTER FILE FIELDS...
      *----------------------------------------------------------------
     C     CPYARY        BEGSR
     C                   MOVEA     COM(1)        COM1
     C                   MOVEA     COM(2)        COM2
     C                   MOVEA     COM(3)        COM3
     C                   MOVEA     COM(4)        COM4
     C                   MOVEA     COM(5)        COM5
     C                   MOVEA     COM(6)        COM6
     C                   MOVEA     MAD(1)        MAD1
     C                   MOVEA     MAD(2)        MAD2
     C                   MOVEA     MAD(3)        MAD3
     C                   MOVEA     MAD(4)        MAD4
     C                   MOVEA     MAD(5)        MAD5
     C                   MOVEA     SAD(1)        SAD1
     C                   MOVEA     SAD(2)        SAD2
     C                   MOVEA     SAD(3)        SAD3
     C                   MOVEA     SAD(4)        SAD4
     C                   MOVEA     SAD(5)        SAD5
     C                   MOVEA     HZ1           HZ1F
     C                   MOVEA     HZ2           HZ2F
ET    * Include bid#?
ET   C                   if        OENO43 <> 0 and IncludeBid# = 'Y'
ET   C                   eval      Bid#    = 'Bid #: '
ET   C                                       + %trim(%editc(OENO43:'X'))
ET   C                   else
ET   C                   eval      Bid# = *blanks
ET   C                   endif
ET
ET    * Include contract#?
ET   C                   if        IncludeCO# = 'Y'
ET   C                   if        OENO19 <> *blanks and OENO19 <> '0000000'
ET   C                   eval      Contract#  = 'C/O#: ' + %trim(OENO19)
ET   C                   else
ET   C                   eval      Contract# = *blanks
ET   C                   endif
ET   C                   else
ET   C                   eval      Contract# = *blanks
ET   C                   endif
ET
ET    * Include promised date?
ET   C                   if        PromDt <> 0 and IncludePrmDt = 'Y'
ET   C                   eval      PromDate = 'Promised Date: ' +
ET   C                                        %char(%date(PromDt:*mdy):*mdy/)
ET   C                   else
ET   C                   eval      PromDate = *blanks
ET   C                   endif
ET
ET    * Include order by?
ET   C                   if        OENM15 <> *blanks and IncludeOrdBy = 'Y'
ET   C                   eval      OrderBy = 'ORDERED BY:' + %trim(OENM15)
ET   C                   else
ET   C                   eval      OrderBy = *blanks
ET   C                   endif
ET
     C                   ENDSR
      *
      *
D1    *----------------------------------------------------------------
D1    * CURBSR - CURBSTONE SOFTWARE INQUIRY - RETRIEVE DATA
D1    *----------------------------------------------------------------
D1   C     CURBSR        BEGSR
D1    *
D1    * Curbstone Card inquiry...
D1   C                   If        ONLINE = 'Y'
D1   C                   If        ARCDJ3 = 'C'                                 C=CURBSTONE
EF   C                             or arcdj3 = 'F'                              C=CURBSTONE
ES   C                             or arcdj3 = 'W'                              W=WORLDPAY
D1 EF * Clear parms passed to/from Curbstone interface...
EF    * Clear parms passed to/from card interface...
D1   C                   CLEAR                   piMode
D1   C                   CLEAR                   piRetry
D1   C                   CLEAR                   piUpdError
D1   C                   CLEAR                   piTran
D1   C                   CLEAR                   piMFUKEY
D1   C                   CLEAR                   piOrgOrd
D1   C                   CLEAR                   piMethod
D1   C                   CLEAR                   piTrnDtl
D1   C                   CLEAR                   piTrnAmt
D1   C                   CLEAR                   piTaxable
D1   C                   CLEAR                   piTaxAmt
D1   C                   CLEAR                   poSuccess
D1   C                   CLEAR                   poMsg
D1   C                   CLEAR                   poData
D1    *
D1 EF * Retrieve information from Curbstone Card interface...
EF    * Retrieve information from Card interface program...
D1   C                   CLEAR                   CRDNUM
D1   C                   CLEAR                   EXPMO
D1   C                   CLEAR                   EXPYR
D1   C                   CLEAR                   HNAME
D1   C                   CLEAR                   CRDTYP
D1   C                   Z-ADD     ARAMC7        REQAMT            9 2
D1   C                   EVAL      piMode = 'INQ'
D1   C                   EVAL      piRetry = 'N'
D1   C                   EVAL      piUpdError = 'N'
D1   C                   EVAL      piTran = TRANUM
D1   C                   EVAL      piMFUKEY = ARNOB7
D1 EIC*                  EVAL      trantyp  = ARcdf6
EI   C                   EVAL      trantyp  = ARcdf4
D1   C                   EVAL      pidata   = pidet
D1   C                   CLEAR                   poMsg
D1   C                   CLEAR                   poData
D1    *
EF   C                   clear                   devSerial#
D1 EFC*                  CALL      'OER9600'     pl9600
EF   C                   call      'OER9650'     pl9600
D1   C                   MOVEL     poData        inqData
D1   C                   MOVEL     inqCARD       CRDNUM
D1   C                   MOVEL     inqNAME       HNAME            30
D1   C                   MOVEL     inqRVND       CRDTYP            4
EI   C                   MOVEL     HNAME         ARNM70
EI    * Print card info
EI   C     CNT           CASGT     MAXLIN        OVRFLW
EI   C                   ENDCS
EI   C                   WRITE     OE2025CC
EI ESC*                  ADD       1             CNT
ES   C  N31              ADD       1             CNT
ES   C                   IF        *IN31
ES   C                   IF        ARNM77 <> *BLANKS
ES   C                   EVAL      *IN35 = *ON
ES EVC*                  ADD       5             CNT
EV   C                   ADD       7             CNT
ES   C                   ELSE
ES   C                   EVAL      *IN35 = *OFF
ES EVC*                  ADD       4             CNT
EV   C                   ADD       6             CNT
ES   C                   ENDIF
ES   C     CNT           CASGT     MAXLIN        OVRFLW
ES   C                   ENDCS
ES   C                   ENDIF
EI    * Print last 4 digits of card number
¢C   C                   eval      *in38 = *off
¢C   C/EXEC SQL
¢C   C+ select count(*) into:@Count
¢C   C+ from arptcct t
¢C ¢DC* left join oeq9751 q
¢D   C+ join oeq9751 q
¢C   C+ on t.arnof6=q.arnof6 and t.arno01=q.arno01
¢C   C+ WHERE t.arnoc1=:tranum and t.arno01=:arno01
¢C   C/END-EXEC
¢C   C                   if        @count > 0
¢C   C                   eval      *in38 = *on
¢C   C                   endif
D1   C                   WRITE     OE2025CB
¢C   C                   if        *in38=*on
¢C   C                   ADD       4             CNT
¢C   C                   else
D1 ESC*                  ADD       1             CNT
ES   C  N31              ADD       1             CNT
ES    * If WorldPay in use and Aplication Identifier not blank write new lines...
ES   C                   CLEAR                   APPNM            16
ES   C                   CLEAR                   PINMSG           15
ES   C                   IF        ARID14 <> *BLANKS
ES   C                              AND *IN31
ES   C                   IF        ARNM79 = *BLANKS
ES   C                   EVAL      APPNM = ARNM78
ES   C                   ELSE
ES   C                   EVAL      APPNM = ARNM79
ES   C                   ENDIF
ES   C                   IF        ARFLB4 <> 'Y'
ES   C                   EVAL      PINMSG = 'PIN VERIFIED'
ES   C                   ENDIF
ES EVC*                  ADD       6             CNT
EV   C                   ADD       4             CNT
ES   C     CNT           CASGT     MAXLIN        OVRFLW
ES   C                   ENDCS
ES   C                   WRITE     OE2025CBW
ES   C                   ENDIF
¢C   C                   EndIf
D1   C                   EndIf
D1   C                   EndIf
D1    *
D1   C                   ENDSR
E1    *----------------------------------------------------------------
E1    * Print Credit Card Processing if applied
E1    *----------------------------------------------------------------
E1   C     Print_CCPFee  BEGSR
E1    *
E1    *
E1    * If Credit Card Processing fee was applied, print it.
E1    *    For deposit, use CCP fee from Deposit file
E1    *    otherwise (Cash Invoices) get CCP fee from Order Other charge file
E1   C                   EVAL      CCPFEE = *ZEROS
E1   C     PICSEQ        IFEQ      'D'
E1   C     PICSEQ        OREQ      'd'
E1   C     PICSEQ        OREQ      'R'
E1   C     OENO30        ORNE      *BLANKS
E1   C                   EVAL      CCPFEE = OEAM95
E1   C                   ELSE
E1   C     OEFL09        IFEQ      'Y'                                          OTHER CHARGES
E1   C                   EVAL      OTHCOD = 'C'
E1   C     TORKEY        CHAIN     OELTOR3
E1   C                   IF        %FOUND(OELTOR3)
E1   C                   EVAL      CCPFEE = OEAM03
E1   C                   ENDIF
E1   C                   ENDIF
E1   C                   ENDIF
E1    *
E1   C                   IF        CCPFEE <> *ZEROS
E1   C                   EVAL      WKPDDS  = 'Credit card processing fee $ ' +
E1   C                             %trim(%char(CCPFEE))
E1   C                   ADD       1             CNT
E1   C     CNT           CASGT     MAXLIN        OVRFLW
E1   C                   ENDCS
E1   C                   WRITE     OE2025D4
E1   C                   EVAL      WKPDDS  = 'has been applied.'
E1   C                   ADD       1             CNT
E1   C     CNT           CASGT     MAXLIN        OVRFLW
E1   C                   ENDCS
E1   C                   WRITE     OE2025D4
E1   C                   ENDIF
E1    *
E1    *
E1   C                   ENDSR
D2    *---------------------------------------------------------
D2    * Adjust address lines on sold to & Ship to address by
D2    * truncating spaces and/or lines
D2    *---------------------------------------------------------
D2   C     AlignAddr     Begsr
D2    *
D2    * Customer mailing address (from Job, enterprise or customer master
D2   C                   if        walkin <> 'W'
D2   C                   Clear                   LineOut2
D2   C                   Clear                   LineOut3
D2   C                   Clear                   LineOut4
D2   C                   Clear                   LineOut5
D2    *
D2   C                   Callp     FormatAddrLines(LineinM2:LineinM3:LineinMC:
D2   C                             LineinMS:LineinMZ:LineOut2:LineOut3:
D2   C                             LineOut4:LineOut5)
D2    *
D2   C                   Eval      Mad(2) = lineout2
D2   C                   Eval      Mad(3) = lineout3
D2   C                   Eval      Mad(4) = lineout4
D2   C                   Eval      Mad(5) = lineout5
D2    *
D2   C                   Clear                   LineInM2
D2   C                   Clear                   LineInM3
D2   C                   Clear                   LineInMc
D2   C                   Clear                   LineInMs
D2   C                   Clear                   LineInMz
D2   C                   Endif
D2    *
D2    * Customer Shipping address
D2   C                   Clear                   LineOut2
D2   C                   Clear                   LineOut3
D2   C                   Clear                   LineOut4
D2   C                   Clear                   LineOut5
D2    *
D2   C                   Callp     FormatAddrLines(Lineins2:Lineins3:LineinsC:
D2   C                             LineinsS:LineinsZ:LineOut2:LineOut3:
D2   C                             LineOut4:LineOut5)
D2    *
D2   C                   Eval      Sad(2) = lineout2
D2   C                   Eval      Sad(3) = lineout3
D2   C                   Eval      Sad(4) = lineout4
D2   C                   Eval      Sad(5) = lineout5
D2    *
D2   C                   Clear                   LineInS2
D2   C                   Clear                   LineInS3
D2   C                   Clear                   LineInSc
D2   C                   Clear                   LineInSs
D2   C                   Clear                   LineInSz
D2    *
D2    * Branch remittance address from ARPMAAD for branch, region, div or comp
D2   C                   Clear                   LineOut2
D2   C                   Clear                   LineOut3
D2   C                   Clear                   LineOut4
D2   C                   Clear                   LineOut5
D2    *
D2   C                   Callp     FormatAddrLines(LineinAd2:Lineinad3:
D2   C                             LineinaCy:LineinaSt:LineinaZp:LineOut2:
D2   C                             Lineout3:LineOut4:LineOut5)
D2    *
D2   C                   Eval      addr2  = lineout2
D2 EAC*                  Eval      addr3  = lineout3
D2 EAC*                  Eval      rmit   = lineout4
D2 EAC*                  Eval      rmitzp = %subst(lineout5:21:10)
EA   C                   Eval      rmit   = lineout3
EA   C                   Eval      rmitzp = %subst(lineout4:21:10)
D2    *
D2   C                   Clear                   LineInAd2
D2   C                   Clear                   LineInAd3
D2   C                   Clear                   LineInAcy
D2   C                   Clear                   LineInAst
D2   C                   Clear                   LineInAzp
D2    *
D2    * Branch address
D2   C                   Clear                   LineOut2
D2   C                   Clear                   LineOut3
D2   C                   Clear                   LineOut4
D2   C                   Clear                   LineOut5
D2    *
D2    * LineinSA3 is always blanks, so only 3 lines will be populated
D2    * when back from the format routine.
D2   C                   Callp     FormatAddrLines(LineinSa2:Lineinsa3:
D2   C                             LineinSCy:LineinSSt:LineinSZp:LineOut2:
D2   C                             Lineout3:LineOut4:LineOut5)
D2    *
D2   C                   Eval      bsad2  = lineout2
D2   C                   Eval      bsad3  = lineout3
D2   C                   Eval      bsad4  = lineout4
D2    *
D2   C                   Clear                   LineInSa2
D2   C                   Clear                   LineInSa3
D2   C                   Clear                   LineInScy
D2   C                   Clear                   LineInSst
D2   C                   Clear                   LineInSzp
D2    *
D2   C                   Endsr
EZ    *----------------------------------------------------------------
EZ    * RTV_RTLDLV - RETRIEVE RETAIL DELIVERY FEE/TAX INFORMATION
EZ    *----------------------------------------------------------------
EZ   C     RTV_RTLDLV    BEGSR
EZ    * Call program to retrieve authority data to print
EZ   C                   CALL      'OER9308'     PL9308
EZ   C                   DO        9             Z                 2 0
EZ   C     Z             OCCUR     AUTHDS
EZ   C                   IF        ADS_TYPE = *ZEROS
EZ   C                   LEAVE
EZ   C                   ENDIF
EZ   C                   IF        Z = 1
EZ    * Print blank space before output
EZ   C                   eval      wkpdds    = *blanks
EZ   C                   ADD       1             CNT
EZ   C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
EZ   C                   ENDCS
EZ   C                   write     oe2025d4
EZ    * Print title
EZ   C                   eval      wkpdds    = 'TAX AMOUNT BREAKDOWN: '
EZ   C                   ADD       1             CNT
EZ   C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
EZ   C                   ENDCS
EZ   C                   write     oe2025d4
EZ   C                   ENDIF
EZ   C                   eval      wkpdds = ADS_NAME + ' '
EZ   C                                      + %EditC(ADS_TAXAMT:'1')
EZ   C                   ADD       1             CNT
EZ   C     CNT           CASGT     MAXLIN        OVRFLW                                     PAGE
EZ   C                   ENDCS
EZ   C                   write     oe2025d4
EZ   C                   ENDDO
EZ   C                   ENDSR
      ********************************************************************
      *
     OOEFTOL    E            LINES
     O                       OENO09
     OOEFTOL2   E            LINES2
     O                       OENO09
     OOEFTDP    E            RELDP1
     OOEFTDP    E            UPDDP1
     O                       OECD52
     OOEFTDP4   E            RELDP4
     OOEFTDP4   E            UPDDP4
     O                       OECD52
      *------------------------------------------------------------------------*
      *------------------------------------------------------------------------*
     OOEFTOH    E            UPDHDR
     O                       OECN02
     O                       OECN03
     O                       OEFL03
     O                       OENO04
     O                       OEDY01
     O                       OEMO01
     O                       OECC01
     O                       OEYR01
     O                       OECD36
      *------------------- TABLE FILE CHANGE AREA -----------------------------*
DX    * Changed CS/DS Table to add PENDING status
DX    * Before:
DX    * AAPPROVED
DX    * DDENIED
DX    * MMARKED
DX    * SSETTLED
DX    * VVOIDED
DX    * After:
DX    * AAPPROVED
DX    * DDENIED
DX    * MMARKED
DX    * PPENDING
DX    * SSETTLED
DX    * VVOIDED
      *------------------------------------------------------------------------*
**
OUR TRUCK
PICKUP
SHIPPED
PREPAID
COLLECT
PREPAY & ADD
DIRECT SHIP
** ALI
Cust Item#
** OT
SALES ORDER
CREDIT MEMO
DEBIT MEMO
QUOTATION
DEPOSIT REFUND
DEPOSIT RECEIPT
** OS
RESERVE TICKET
PENDING TICKET
PICK TICKET
INVOICE
PACKING SLIP
** CS/DS
AAPPROVED
DDENIED
MMARKED
PPENDING
SSETTLED
VVOIDED
** HZ1
*************** HAZARDOUS MATERIAL ****************
** HZ2
***************************************************