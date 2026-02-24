     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - BAKR0220 (Copy of AIR7100)                             *
     F*------------------------------------------------------------------------*
     F*D CREATE ORDER FROM SHOPPING CART                                       *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S   Create a sales and po from XML in IT_UPLOADS/IMPORTS/NEUCO_XML      *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S   transmision id = web card id                                        *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V RPG-242    102825 DKS Process Nueco orders                            *
AA   F*E 8000011199 111111 070 WRT SHOPPING CART HISTORY                       *
AC   F*E 8000011294 040512 070 B2B/B2C API CORRECTIONS                         *
AD   F*E 8000011315 050212 168 CLEAR LINE COMMENTS                             *
AE   F*E 8000011354 062712 168 LOAD SHIP VIA DESCRIPTION                       *
AF   F*E 8000011374 082212 168 VERIFY IF WM IS INSTALLED                       *
AH   F*E 8000011182 082912 070 B2B/B2C TAX API INTERFACE                       *
AI   F*E 8000011377 100212 200 Customer Service Mobile App                     *
AJ   F*E 8000010983 102912 171 B2C/B2B Credit card interface                   *
AK   F*E 8000010982 112912 171 B2C/B2B Freight API interface                   *
AL   F*E 8000011434 121712 070 SAVE B2C USER ID                                *
AM   F*E 8000011442 121912 070 ITEM TAXABLE FLAG WRONG ON B2B ORD              *
AN   F*E 8000011441 010913 070 APPLY ADD'L RATE TO CRD CARD ORD                *
AO   F*U 8000011560 071113 171 CHANGE LOADING OF TAX JURIS                     *
AP   F*U 8000011578 080813 102 UPDATE PICKSEQ ENTRY OF WEB TABLE               *
AQ   F*U 8000011561 112013 102 CHANGE LOADING OF SHIP ADDRESS                  *
AR   F*U 1710000562 032114 102 CRT ORD AS CSH TCK IN WEBSMART                  *
AT   F*E 8000011775 071114 915 B2B (API) LICENSE KEY CHECK                     *
AU   F*E 8000011777 071414 915 B2C (API) LICENSE KEY CHECK                     *
AV   F*E 8000011209 100214 915 Credit card processing                          *
AW   F*U 8000012031 061015 915 SRVTRK API LICENSE KEY CHECK                    *
AX   F*U 8000012029 061015 915 CUSTSERVE API LICENSE KEY CHECK                 *
AZ   F*U 1650000444 092916 102 WEBSMART NONSTOCK NOT CRT / ITEM                *
A0   F*E 8000012436 110316 915 Curbstone C2 to C3 conversion                   *
A1   F*E 8000012610 051117 915 Avalara AvaTax interface                        *
A3   F*E 8000012747 021518 915 AvaTax parm changes - Tax override              *
A4   F*E 8000012817 032118 915 AvaTax - Taxable flag handling                  *
A5   F*E 8000012865 040218 915 Avatax Corrections #1                           *
BA   F*E 8000012946 060618 915 B2B order without AvaTax rec                    *
BB   F*U 0970000696 112818 915 HDE0020 does not include BO fill                *
BD   F*E 1290000646 021719 070 CUSTOMER INCENTIVES PHASE 2 PART 2              *
BF   F*E 8000013156 040219 168 WB - PLACE ORDER                                *
BG   F*E 8000013122 041019 915 Card Connect - Credit card process              *
BH   F*U 8000013307 042419 102 SKIP CHK STK IN WS FOR NON INV ITM              *
BI   F*E 8000013392 102419 019 Add Sales Order creation Event notification     *
BJ   F*U 0930000564 102419 019 Add Sales Order creation Event notification     *
BM   F*E 1290000727 100121 171 Worldpay - Credit card processing               *
BN   F*E 1400000490 071222 404 Customer Specific Credit Limits                 *
BO   F*E 1400000502 092022 171 INCREASE DEVICE SERIAL# LENGTH                  *
     F*M ----------------------------------------------------------------------*
     FAIPCSCH   IF   E           K DISK    PREFIX(CH_)
     FAILTSCH1  IF   E           K DISK    PREFIX(SH_)
     FAILTSCL2  IF   E           K DISK    PREFIX(SL_)
     FAILTSCL3  IF   E           K DISK    PREFIX(XX_)
     F                                     RENAME(AIFTSCL:AIFTSCL3)
     FAILTSCT1  IF   E           K DISK    PREFIX(ST_)
     FTBLMTBL1  IF   E           K DISK
     FARLMBCH4  IF   E           K DISK    USROPN
     FARLMCUS1  IF   E           K DISK
     FARLMBALA  IF   E           K DISK
     FARLMENT1  IF   E           K DISK    USROPN
     FARLEBAL1  IF   E           K DISK    USROPN
     FARLMJBM1  IF   E           K DISK    USROPN
     FARLMTRH1  IF   E           K DISK    USROPN
     FARLMTXS1  IF   E           K DISK    USROPN
     FIVLMSTR8  IF   E           K DISK
     FIVLMSBR1  IF   E           K DISK
     FIVLMNSB1  IF   E           K DISK    USROPN
     FOPLMUPM1  IF   E           K DISK    USROPN
      * Business to Business files...
     FAILMUSR1  IF   E           K DISK    USROPN
     FAILMUBR1  IF   E           K DISK    USROPN
     FAILMCUS1  IF   E           K DISK    USROPN
      * Business to Customer files...
     FAILMRCF1  IF   E           K DISK    USROPN
     FAILMRCS1  IF   E           K DISK    USROPN
      * Ship Code master...
     FOELMSCD1  IF   E           K DISK    PREFIX(SC_)
      * Cash sale information...
     FOEPTOC    O    E             DISK    USROPN
      * Ship to address...
     FOEPTOA    O    E             DISK    USROPN
      * Order header...
     FOELTOH1   UF A E           K DISK
      * Line items...
     FOELTOL9   UF A E           K DISK
      * Line item comments...
     FOEPTOT    O    E             DISK    USROPN
      * Order comments...
     FOEPTOM    O    E             DISK    USROPN
      * Order other charges...
     FOEPTOR    O    E             DISK    USROPN PREFIX(OC_)
      * Walk-in customer transaction...
     FARPTWI    O    E             DISK    USROPN
      * Purchase Orders *
     FAPLMVEN1  IF   E           K DISK
     FPOLTOH1   UF A E           K DISK    Prefix(p_)
     FPOLTOL1   UF A E           K DISK    Prefix(p_)
     FPOPTTG    O    E             DISK    Prefix(t_)
     FPOPTOA    O    E             DISK    Prefix(p_)
     Fivlmirq2  if   E           K DISK
      * New Verified Temp Item *
     FIVPMSTR   O    E             DISK    Rename(ivfmstr:newmstr) Prefix(i_)
     FIVPMUOM   O    E             DISK    Prefix(i_)
     FIVPMRNS   O    E             DISK    Prefix(i_)
     FIVLMWHC4  if A E           K DISK    Prefix(w_)
      * Files needed to restore deleted item *
     FIVLMALI2  IF   E           K DISK
     FIVLMCMP1  IF   E           K DISK
     FIVLMSUB1  IF   E           K DISK
     FIVLMASC1  IF   E           K DISK
     Foeltotx2  if   e           k disk    rename(oeftotx:oeftotx2)
      * Email sales ack
     FOPLMEMA1  IF   E           K DISK
      *------------------------------------------------------------------------*
      *-------
      * Arrays
      *-------
     D CRM             S              1    DIM(138) CTDATA PERRCD(46)           CREDIT HOLD MSG
     D INV             S              1    DIM(120) CTDATA PERRCD(60)           INVALID USER MSG
     D USR             S             10    DIM(3)                               USER ID'S
     D ARY             S              1    DIM(70) CTDATA PERRCD(70)
     D MS              S              1    DIM(320) CTDATA PERRCD(80)

     d GetItem         pr                  Extpgm('IVR9310')
     d                                6  0

     d SendWm          pr                  Extpgm('WXR5956')
     d                                3
     d                              256
      *-----------
      * Indicators
      *-----------
     D B2B             S               N   INZ(*OFF)
     D B2C             S               N   INZ(*OFF)
AI   D IMO             S               N   INZ(*OFF)
BD   D CRB             S               N   INZ(*OFF)
     D CreditCard      S               N   INZ(*OFF)
     D FromContract    S               N   INZ(*OFF)
      *-------------------
      * Stand alone fields
      *-------------------
      * Input parms...
     D piHostURL       s            256
     D piVer           s             10
     D piSecToken      s             64
     D piLang          s             10
     D piApp           s              3    inz('B2B')
     D piCustomer      s              6
     D piUserID        s             80
     D piCartID        s             20
     D piShipBr        s              3
     D piShAddr1       s             30
     D piShAddr2       s             30
     D piShAddr3       s             30
     D piShCity        s             25
     D piShState       s              2
     D piShZip         s             10
     D piShCountry     s              5
     D piPromDate      s              8
     D piShipMethod    s              1
     D piShipCode      s              2
     D piShipDesc      s             15
     D piPhone         s             20
     D piJobNumber     s              7
     D piJobName       s             15
     D piSubTotal      s              9s 2
     D piTax           s              9s 2
     D piGST_HST       s              9s 2
     D piShpHdlg       s              9s 2
     D piOrdTotal      s              9s 2
     D piSpecInst      s            240
     D piBodyCmts      s            240
     D piCustPO        s             22
     D piCCOrd         s              1
     D piTaxJur        s              7
AJ BMD*piMFUKEY        s             15
BM   D piMFUKEY        s             19
AN   D piCCAmt         s             11s 2
      * Output parms...
     D poErrCd         s              1
     D poErrMsg        s            500
     D poOrderNo       s              7
     D dft_uom         s                   like(ivdn20) inz('EA')
     D dft_fct         s                   like(i_ivqy12) inz(1)
     D new_ivno04      s                   like(ivno04)
     D line_err        s              1a   inz('N')
     D ord_err         s              1a   inz('N')
     D po_err          s              1a   inz('N')
     D new_ivno07      s                   like(ivno07)
     D itmnum          s                   like(ivno07)
     D timestamp       s                   like(w_W701A5)
     D cIvcd17         s                   like(ivcd17)
     D cIvcd18         s                   like(ivcd18)
     D cIvcd19         s                   like(ivcd19)
     D cConfirm        s                   like(p_ponm02)
     D cBuyerid        s                   like(p_poid01)
     D cShipVia        s                   like(p_podn02)
     D cNDordsts       s                   like(oecd04)
     D cPickupCode     s                   like(arcdc6)
     D cEslsack        s                   like(arfl72)
     D wrkcc           s                   like(i_ivcc04)
     D bynm01          s                   like(apnm01)
     D tranid          s             36a
     D octype          s              1a
      *---------------
      * Work fields...
      *---------------
     D Customer        s                   like(ARNO01)
     D Company         s                   like(ARNO15)
     D UserProfile     s                   like(SH_OENM17)
     D ShipBr          s                   like(OENO16)
     D SellBr          s                   like(OENO08)
     D OrderBy         s                   like(OENM16)
     D SalesId         s                   like(ARID01)
     D ORDFCT          s             14  9
     D PRCFCT          s             14  9
     D TAXJUR          s                   like(ARCD04)
     D GSTPCT          s                   like(OEPC08)
     D MSGNAM          s                   like(OENM15)
     D EXTLMT          s                   like(CAVAIL)
     D ELIMIT          s                   like(CAVAIL)
     D EOVR            s                   like(CAVAIL)
     D $OVR            s                   like(CAVAIL)
     D CO#TYP          s                   like(OECD03)
     D OE#NTY          s                   like(OECD03)
     D OE#OTY          s                   like(OECD03)
     D PMNO06          s                   like(OENO06)
     D PNO26           s                   like(OENO26)
     D PNO22           s                   like(OENO22)
     D CRARPD          s                   like(CARFM2)
     D NSFLAG          s              1    inz('N')
     D ZeroItem        s                   like(IVNO07) inz(0)
     D ZeroLine#       s                   like(OENO22) inz(0)
     D ComboQY01       s                   like(OEQY01)
     D ComboQY02       s                   like(OEQY02)
     D ComboQY03       s                   like(OEQY03)
     D PUOMI#          s                   like(IVNO07)
     D WKAM38          s                   like(OEAM38)
     D DftOrdSts       s                   like(OECD04)
     D SVCD04          s                   like(OECD04)
     D OrdMsgPrf       s                   like(OENM01)
     D SrcOfSale       s                   like(OECD17) Inz('W')
     D SaleType        s                   like(OECD19) Inz('R' )
AZ   D NonStock        s                   like(IVNO04)
BD   D PMAGOP          s                   like(AGEOPT)
BF   D WBFlag          s              1    inz('N')
BF   D WBOrderStatus   s                   like(OECD04)
BI   D ShortVersion    s              3
BN   D AddOn_OvrPct    S              4  3 inz
     D ponum           S                   like(pono01)
     D ordqty          S                   like(oeqy01)
     D orduom          S                   like(ivdn02)
     D auomi#          S                   like(ivno07)
     D puom            s                   like(oedn04)
     D puomsf          s             14  9
     D Temp_item       s              1    Inz('N')
     D new_prod        s                   like(ivno04)
     D new_desc        s                   like(ivdn01)
     D item_found      s              1a
     D crtitmflg       s              1a
     D appcde          s              2a   inz('IT')
     D IsoDate         S               D   DatFmt(*ISO)
     D item_err        s              1a
     D itemcntr        s              2  0 inz(10)
     D loopcnt         s              2  0
     D errmsg          s                   like(oedn02)
     D @wPrmTimeStamp  s               Z   Inz
      *-------------
      * Constants...
      *-------------
     D UP              C                   CONST('ABCDEFGHIJKLMNOPQRS-
     D                                     TUVWXYZ')
     D LO              C                   CONST('abcdefghijklmnopqrs-
     D                                     tuvwxyz')
   AZD*NONSTOCK        C                   CONST('         NONSTOCK')
BF   D WB              C                   CONST('WB')
      *-------------------
      * Data structures...
      *-------------------
     D                SDS
A1   D  pgmName                1      8
     D  DSPERR                91    160
     D  UsrNm                254    263
      * Order being placed on problem hold
     D d_HDE7020       DS           256    inz
     D  ordE70                        7a
     D  comE70                        3s 0
     D  divE70                        3a
     D  regE70                        3a
     D  sbrE70                        3s 0
     D  bnmE70                       25a
     D  usrE70                       10a
     D  cusE70                        6s 0
     D  cnmE70                       30a
HX   D d_HDE7039       DS           256    inz
HX   D  totE39                        7s 0
HX   D  orgE39                        1a
HX   D  byrE39                        3a
HX   D  vndE39                        6s 0
HX   D  po#E39                        7s 0
HX   D  cmpE39                        3s 0
HX   D  divE39                        3a
HX   D  regE39                        3a
HX   D  brnE39                        3s 0
BA    * order being placed on credit hold event
BA   D d_HDE0027       DS           256    inz
BA   D  itemE27                       6s 0
BA   D  pddsE27                      48a
BA   D  branE27                       3s 0
BA   D  brnmE27                      25a
BA   D  userE27                      10a
BA   D  vndrE27                       6s 0
BA   D  vnrnm27                      30a
GD    * ---------------------------------------------------------------
GD    * HDE7029 EVENT DATA/FILTER
GD    * ---------------------------------------------------------------
GD   D d_HDE7029       DS           256    inz qualified
GD   D  ITEM                         48A
GD   D  IVNO07                        6  0
GD   D  CRTUSER                      10A
GD   D  DATE                          8A
GD   D  TIME                          8A
GD
      *
     D SPCINS          DS
     D  SILIN1                       40
     D  SILIN2                       40
     D  SILIN3                       40
     D  SILIN4                       40
     D  SILIN5                       40
     D  SILIN6                       40
      *
     D BodyCmts        DS
     D  BC01                               like(IVDN01)
     D  BC02                               like(IVDN01)
     D  BC03                               like(IVDN01)
     D  BC04                               like(IVDN01)
     D  BC05                               like(IVDN01)
     D  BC06                               like(IVDN01)
     D  BC07                               like(IVDN01)
     D  BC08                               like(IVDN01)
     D  BC09                               like(IVDN01)
     D  BC10                               like(IVDN01)
     D  BC11                               like(IVDN01)
      *
     D LineCmts        DS
     D  LC01                               like(IVDN01)
     D  LC02                               like(IVDN01)
     D  LC03                               like(IVDN01)
     D  LC04                               like(IVDN01)
     D  LC05                               like(IVDN01)
     D  LC06                               like(IVDN01)
     D  LC07                               like(IVDN01)
     D  LC08                               like(IVDN01)
     D  LC09                               like(IVDN01)
     D  LC10                               like(IVDN01)
     D  LC11                               like(IVDN01)
      *
     D                 DS
     D  ADONS                  1     30
     D  WMSYS                  3      3
     D  PFSYS                  6      6
A1   D  AvaTaxActive          18     18
     D                 DS
     D  PDATA2                 1    256
     D  ITM#                   1      6  0
      *
     D                 DS
     D  PRTDET                 1      2
     D  PTCD83                 1      1
     D  INVC83                 2      2
      *
     D  COMPNY                 1      3  0
     D  BRNBR                  4      6  0
     D  COBR                   1      6
      *
     D                 DS
     D  SHPDAT                 3      3
     D  WLKBAS                16     16
     D  OPTS                   1     30
      *
     D  @W_DatUsr      DS
     D  @W_CurDate             1      8  0
     D  @W_Time                9     14  0
     D  @W_User               15     24                                         User Name
      *
      *
     D                 DS
     D  CURTIM                 1      6  0
     D  CURDAT                 7     14  0
     D  TIMDAT                 1     14  0
      *
     D SAVDAT          DS
     D  HOUR                   1      2
     D  MIN                    3      4
     D  SEC                    5      6
     D  MONTH                  7      8
     D  DAY                    9     10
     D  CENTRY                11     12
     D  YEAR                  13     14
      *
     D                 DS
     D  IVMO01                 1      2  0
     D  IVDY01                 3      4  0
     D  IVCC01                 5      6  0
     D  IVYR01                 7      8  0
     D  DATE01                 1      8  0
      *
     D                 DS
     D  OEMO02                 1      2  0
     D  OEDY02                 3      4  0
     D  OECC02                 5      6  0
     D  OEYR02                 7      8  0
     D  DATE02                 1      8  0
      *
     D                 DS
     D  OC_OEMO02              1      2  0
     D  OC_OEDY02              3      4  0
     D  OC_OECC02              5      6  0
     D  OC_OEYR02              7      8  0
     D  OC_DATE02              1      8  0
      *
     D                 DS
     D  OEMO03                 1      2  0
     D  OEDY03                 3      4  0
     D  OECC03                 5      6  0
     D  OEYR03                 7      8  0
     D  SODATE                 1      8  0
      *
     D                 DS
     D  POMO02                 1      2  0
     D  PODY02                 3      4  0
     D  POCC02                 5      6  0
     D  POYR02                 7      8  0
     D  PODATE                 1      8  0
     D                 DS
     D  POMO03                 1      2  0
     D  PODY03                 3      4  0
     D  POCC03                 5      6  0
     D  POYR03                 7      8  0
     D  ETADATE                1      8  0
     D                 DS
     D  POMO11                 1      2  0
     D  PODY11                 3      4  0
     D  POCC11                 5      6  0
     D  POYR11                 7      8  0
     D  POENTD                 1      8  0
     D                 DS
     D  POMO14                 1      2  0
     D  PODY14                 3      4  0
     D  POCC14                 5      6  0
     D  POYR14                 7      8  0
     D  RVSETA                 1      8  0
      *
     D                 DS
     D  ARMO05                 1      2  0
     D  ARDY05                 3      4  0
     D  ARCC05                 5      6  0
     D  ARYR05                 7      8  0
     D  DATE05                 1      8  0
      *
     D                 DS
     D  ARMO06                 1      2  0
     D  ARDY06                 3      4  0
     D  ARCC06                 5      6  0
     D  ARYR06                 7      8  0
     D  DATE06                 1      8  0
      *
     D                 DS
     D  OECC07                 1      2  0
     D  OEYR07                 3      4  0
     D  OEMO07                 5      6  0
     D  OEDY07                 7      8  0
     D  DATE07                 1      8  0
      *
     D                 DS
     D  OEMO08                 1      2  0
     D  OECC08                 3      4  0
     D  OEYR08                 5      6  0
     D  DATE08                 1      6  0
      *
     D                 DS
     D  ARMO84                 1      2  0
     D  ARDY84                 3      4  0
     D  ARCC84                 5      6  0
     D  ARYR84                 7      8  0
     D  DATE09                 1      8  0
      *
     D                 DS
     D  ARMO09                 1      2  0
     D  ARDY09                 3      4  0
     D  ARCC09                 5      6  0
     D  ARYR09                 7      8  0
     D  DATE10                 1      8  0
      *
     D PM0810        E DS                  EXTNAME(OPPW810)
      *
     D                 DS                  INZ
     D  CRHOLD                 1      1
     D  CRCASH                 2      2
     D  OLHOLD                 3      3
     D  OLCASH                 4      4
     D  PCTOVR                 5      8
     D  USEMSG                 9      9
     D  HLDCND                 1      9
     D                 DS                  INZ
     D  ARCC01                 1      2  0
     D  ARYR01                 3      4  0
     D  ARMO01                 5      6  0
     D  BILCYM                 1      6  0
      *
     D PhoneDS         DS
     D  ARNO07
     D  ARNO08
     D  ARNO09
      *
     D                 DS
     D  CH_OEMO14              1      2  0
     D  CH_OEDY14              3      4  0
     D  CH_OECC14              5      6  0
     D  CH_OEYR14              7      8  0
     D  FSTREL                 1      8  0
      *
     D                 DS
     D  CH_OEMO15              1      2  0
     D  CH_OEDY15              3      4  0
     D  CH_OECC15              5      6  0
     D  CH_OEYR15              7      8  0
     D  LSTREL                 1      8  0
BB    * order being placed on credit hold event
BB   D d_hde0020       ds           256    inz
BB   D  ordE20                        7a
BB   D  comE20                        3s 0
BB   D  divE20                        3a
BB   D  regE20                        3a
BB   D  sbrE20                        3s 0
BB   D  bnmE20                       25a
BB   D  usrE20                       10a
BB   D  cusE20                        6s 0
BB   D  cnmE20                       30a
BD    * Data structure used for Customer Rebates
BD   D  CRB_DS         DS           256    INZ
BD   D  LicToCustReb                   N   INZ(*ON)
BD   D  CRB_Co                             LIKE(GLNO01)
BD   D  CRB_SlsId                          LIKE(ARID01)
BD   D  CRB_CMSTS                     1
BD   D  CRB_CMSSRC                    1
BD   D  CRB_CMSTYP                    1
BD   D  CRB_CMRSN                     1
BD    * Age options...
BD   D                 DS                  INZ
BD   D  GRP1AM                 1      1
BD   D  GRP2AM                 2      2
BD   D  GRP3AM                 3      3
BD   D  GRP4AM                 4      4
BD   D  GRP5AM                 5      5
BD   D  GRP6AM                 6      6
BD   D  GRP1AD                21     21
BD   D  GRP2AD                22     22
BD   D  GRP3AD                23     23
BD   D  GRP4AD                24     24
BD   D  GRP5AD                25     25
BD   D  GRP6AD                26     26
BD   D  AGEOPT                 1     40
BD    *
AJ   D                 DS
AJ   D  USING_CARD             1      1
AJ BGD* CARD_SOFTWARE          2     30
BG   D  CARD_SOFTWARE          2     16
AJ   D  CARD_TABENTRY          1     30
     D                 DS
     D  PONO                   1      7  0
     D  YESNO                  8      8
     D  REPRNT                 9      9
     D  RVPRNT                10     12  0
     D  DSPO                   1     12
AJ    *----------------------------------------------------------------
AJ BG * Parms passed to/from OER9600 program...
BG    * Parms passed to/from card processing program
AJ    *.....................................
AJ   D pMode           S              3    inz
AJ   D pRetry          S              1    inz
AJ   D pUpdError       S              1    inz
AJ   D pTran           S              7    inz
AJ   D pMFUKEY         S             15    inz
AJ   D pOrgOrd         S              7    inz
AJ   D pMethod         S              2    inz
AJ   D pTrnDtl         S              1    inz
AJ   D pTrnAmt         S              9  2 inz
AJ   D pTaxable        S              1    inz
AJ   D pTaxAmt         S              9  2 inz
AJ   D pSuccess        S              1    inz
AJ   D pMsg            S             78    inz
AJ   D pData           S            256    inz
AT    *
AT    /include QCPYSRC,MNYPROTO
AV   D piData          S            256    inz
AV    *
AV    * PiDet to contain tran type & override zip or ship zip.
AV   D  piDet          ds
AV   D   trantyp                      1    inz('S')
AV   D   custmr                      10
AV    * Purchase order as reference transaction
AV   D   pono#                       22
AV   D   oezp03                      10
AV   D   brnch#                       3  0 inz
BG    * This flag controls saving and display of credit card info in
BG    * Curbstone processing.
BG   D   dspCrdFlg                    1
BG    * This param is passed only for interactive refunds, for Curbstone
BG    * (order/deposit maintenance)
BG   D   cardtype                     4
BG    * Device serial number to be sent for CardConnect                e
BG BOD*  DevSerial#                  20
BO   D   DevSerial#                  40
AV    *
A0   D   obj           s             10    inz(' ')
A1   D PiTranType      s              3
A1   D PiTranNum       s              7
A1   D PiAPIRqstTyp    s              3
A1   D PiDocCode       s             30
A1   D PiDocType       s              1  0
A1   D PiTaxSts        s              2
A1   D PiTaxErrCd      s              2
A1   D PiTaxRate       s              6  6
A1   D piTaxAmt        S              9  2
A1   D PiGstRate       s              6  6
A1   D PiGstAmt        s              9  2
A1   D PiHstRate       s              6  6
A1   D PiHstAmt        s              9  2
A1   D PiPstRate       s              6  6
A1   D PiPstAmt        s              9  2
A1   D PiTaxableAmt    s              9  2
A1   D PiNTaxableAmt   s              9  2
A1   D PiAPIErrMsg     s             50
A1   D PiBillType      s              2
A1   D PiMode          s              1
A1   D PiUpdTax        s              1
A1   D PiTaxOvrAmt     s              9  2
A1   D PiPgmName       s             10
A1 BAD*PiMisc          s             10
A1   D PiHdrUpd        s              1    inz(' ')
A1   D pModeOE         s              1
A1   D pType           s              5
A1   D pAPIMsgO        s             50
A1   D pTaxblAmtO      s              9  2
A1   D pNTaxblAmtO     s              9  2
A1   D PGstAmtO        s              9  2
A1   D pTaxAmtO        s              9  2
A1   D pTaxRateO       s              5  3
A1   D pGstHstRateO    s                   like(oepc08)
A1   D pGStHSTCdO      s                   like(oecd86)
BA   D PiMisc          ds            10
BA   D OrdHdrTaxFlag                  1    overlay(pimisc:1)
BA   D WebSmartOrd                    1    overlay(pimisc:2)
BA   D kTranType       s              3
BA   D kDocCode        s             30
BG   D card_interface  s              1    inz(' ')
     D alias_yn        s              1    inz('N')
     D sub_yn          s              1    inz('N')
     D assoc_yn        s              1    inz('N')
     D cmp_yn          s              1    inz('N')
      *------------------------------------------------------------------------*
     IARFMCUS
     I              ARNO01                      CUSNBR
     I              ARNM01                      CUSNAM
     I              ARNO07                      CUSARA
     I              ARNO08                      CUSPRE
     I              ARNO09                      CUSSUF
     I              ARZP15                      CUSMZP
     I              ARAD04                      CUSAD1
     I              ARAD05                      CUSAD2
     I              ARAD06                      CUSAD3
     I              ARCY02                      CUSCTY
     I              ARST02                      CUSSTA
     I              ARZP16                      CUSZIP
     I              ARCD04                      CUSJUR
     I              ARCD30                      CPUJUR
     I              ARNO82                      ENTNBR
     I              ARAM01                      CSAM01
     I              ARCDC6                      CSCDC6
     I              ARCDF9                      CSCDF9
     IARFMBAL
     I              ARNO01                      CUSNBR
     I              ARNO15                      CUSCO
     I              ARNO16                      CUSBRA
     I              ARID01                      CUSSLS
     I              ARAM01                      CBAM01
     I              ARNO82                      ENTNBR
     I              ARFL03                      BALFLG
     IARFEBAL
     I              ARNO82                      EBNO82
     I              ARNO15                      EBNO15
     I              ARNO16                      EBNO16
     I              ARMO09                      EBMO09
     I              ARDY09                      EBDY09
     I              ARCC09                      EBCC09
     I              ARYR09                      EBYR09
     I              ARNM03                      EBNM03
     I              ARFL24                      EBFL24
     I              ARFL25                      EBFL25
     I              ARID01                      EBID01
     I              ARCN01                      EBCN01
     I              ARAM01                      EBAM01
     I              ARBL75                      EBBL75
     I              ARMO11                      EBMO11
     I              ARDY11                      EBDY11
     I              ARCC11                      EBCC11
     I              ARYR11                      EBYR11
     I              ARMO12                      EBMO12
     I              ARDY12                      EBDY12
     I              ARCC12                      EBCC12
     I              ARYR12                      EBYR12
     I              ARAM16                      EBAM16
     I              ARMO03                      EBMO03
     I              ARDY03                      EBDY03
     I              ARCC03                      EBCC03
     I              ARYR03                      EBYR03
     IARFMJBM
     I              ARCDC6                      AJCDC6
     I              ARCDF9                      JBCDF9
      *------------------------------------------------------------------------*
      * Parameter lists...
      *------------------------------------------------------------------------*
     C     *ENTRY        PLIST
     C                   PARM                    piCartid                       transmission ID
      *
     C     PL0810        PLIST
     C                   PARM                    PM0810
      *
     C     PL9200        PLIST
     C                   PARM                    OENO01
     C                   PARM                    OENO19                         CONTRACT#
     C                   PARM                    ARNO01                         CUSTOMER
     C                   PARM                    PMNO06                         JOB
     C                   PARM                    ARNO15                         COMPANY
     C                   PARM                    OEAM31           11 2
     C                   PARM                    OEAM32           11 2
     C                   PARM                    OEAM33           11 2
     C                   PARM                    OEAM34           11 2
     C                   PARM      'N'           F9100             1
     C                   PARM      'O'           F9200             1            FROM O/E
     C                   PARM                    OE#OTY
     C                   PARM                    OE#NTY
     C                   PARM                    CO#TYP
     C                   PARM                    ER9200            9
     C                   PARM                    CAVAIL            9 2
     C                   PARM                    JAVAIL            9 2
     C                   PARM                    EAVAIL            9 2
      *
     C     PL9050        PLIST
     C                   PARM                    PNO26
     C                   PARM                    PNO22
      *
     C     PL0421        PLIST
     C                   PARM                    SL_IVNO07
     C                   PARM                    ShipBr
     C                   PARM                    IVQY23
     C                   PARM      'N'           NODSP             1
      *
     C     PL0422        PLIST
     C                   PARM                    SH_OENO19
     C                   PARM                    SL_OENO31
     C                   PARM                    ShipBr
     C                   PARM      'N'           NODSP             1
     C                   PARM                    IVQY23
      *
     C     RLOCK         PLIST
     C                   PARM                    DSPERR
     C                   PARM                    DSPF1             1
     C                   PARM                    DSPF2             1
      *
     C     PL9320        PLIST
     C                   PARM                    PUOMI#                         OUR ITEM#
     C                   PARM                    PUOMOU            3            ORDER UOM
     C                   PARM                    PUOMOF           14 9          ORD UOM FCT
     C                   PARM                    PUOMOB            1            O/E UOM BASE
     C                   PARM                    PUOMPU            3            PRICE UOM
     C                   PARM                    PUOMPF           14 9          PRC UOM FCT
     C                   PARM                    PUOMRC            1            RETURN CODE
AJ    *
AJ   C     pl9600        PLIST
AJ   C                   PARM                    pMode
AJ   C                   PARM                    pRetry
AJ   C                   PARM                    pUpdError
AJ   C                   PARM                    pTran
AJ   C                   PARM                    pMFUKEY
AJ   C                   PARM                    pOrgOrd
AJ   C                   PARM                    pMethod
AJ   C                   PARM                    pTrnDtl
AJ   C                   PARM                    pTrnAmt
AJ   C                   PARM                    pTaxable
AJ   C                   PARM                    pTaxAmt
AJ   C                   PARM                    pSuccess
AJ   C                   PARM                    pMsg
AJ   C                   PARM                    pData
AV   C                   PARM                    piData
A1    *
A1   C     pl9351        Plist
A1    * Mode program called in
A1   C                   Parm                    PiMode
A1    * Billing type - 01 B2C, 02 - SD
A1   C                   parm                    PiBillType
A1   C                   parm                    PiTranNum
A1    * S/O, C/O, BID
A1   C                   Parm                    PiTranType
A1    * GET/PST/CMT/ADR/CNL etc
A1   C                   Parm                    piAPIRqstTyp
A1   C                   Parm                    PiDocCode
A1   C                   Parm                    PiDocType
A1    * Tax status 01 = success, 02 = error
A1   C                   Parm                    PiTaxSts
A1    * Tax calc error code
A1   C                   Parm                    PiTaxErrCd
A1   C                   Parm                    PiTaxRate
A1   C                   Parm                    PiTaxAmt
A1   C                   Parm                    PiGSTRate
A1   C                   Parm                    PiGSTAmt
A1   C                   Parm                    PiHSTRate
A1   C                   Parm                    PiHSTAmt
A1   C                   Parm                    PiPSTRate
A1   C                   Parm                    PiPSTAmt
A1   C                   Parm                    PiTaxableAmt
A1   C                   Parm                    PiNtaxableAmt
A1    * Tax API error message
A1   C                   Parm                    PiAPIErrMsg
A1   C                   parm                    PiUpdTax
A1   C                   parm                    PiTaxOvrAmt
A1   C                   Parm                    PiPgmName
A1   C                   Parm                    PiMisc
A1   C                   Parm                    PiHdrUpd
BD    *
BD   C     PL0100        PLIST
BD   C                   PARM                    PMAGOP
BN    *
BN   C     PL9201        PLIST
BN   C                   PARM                    ARNO01
BN   C                   PARM      *ZEROS        AddOn_OvrPct
BD    *
      *
     C     PL0117        PLIST
      *                                                  API UOM FLD -
     C                   PARM                    AUOMI#                         OUR ITEM#
     C                   PARM                    AUOMOU            3            ORDER UOM
     C                   PARM                    AUOMOF           14 9          ORD UOM FCT
     C                   PARM                    AUOMOB            1            O/E UOM BASE
     C                   PARM                    AUOMPU            3            PRICE UOM
     C                   PARM                    AUOMPF           14 9          PRC UOM FCT
     C                   PARM                    AUOMRC            1            RETURN CODE
      *
     C     PL9505        PLIST
     C                   PARM                    VNDCUS            1
     C                   PARM                    CUSNBRA           6
     C                   PARM                    TRPNID           15
     C                   PARM                    VENBRN            3
     C                   PARM                    DOCTYP            3
     C                   PARM                    SUBTYP            1
     C                   PARM                    RCVSTS            1
     C                   PARM                    EDITYP            1
      *------------------------------------------------------------------------*
      * Key lists...
      *------------------------------------------------------------------------*
     C     TABKEY        KLIST
     C                   KFLD                    TBNO01
     C                   KFLD                    TBNO02
      * by cart id and line number...
     C     SCT1_K1       KLIST
     C                   KFLD                    piCartID
     C                   KFLD                    SL_OENO09
      * by Customer, User Profile...
     C     USR1_K1       KLIST
     C                   KFLD                    Customer
     C                   KFLD                    UserProfile
      * by Authorized Flag, User Profile...
     C     UBR1_K1       KLIST
     C                   KFLD                    WBFL09
     C                   KFLD                    UserProfile
      * by Host URL, Customer...
     C     RCF1_K1       KLIST
     C                   KFLD                    piHostURL
     C                   KFLD                    Customer
      * by Enterprise, Company...
     C     EBKEY         KLIST
     C                   KFLD                    ENTNBR
     C                   KFLD                    Company
      * by Customer, Company...
     C     Cus_Co        KLIST
     C                   KFLD                    Customer
     C                   KFLD                    Company
      * by branch and item number...
     C     SBR1_K1       KLIST
     C                   KFLD                    ShipBr
     C                   KFLD                    SL_IVNO07
      * by branch and item number...
     C     SBR1_K2       KLIST
     C                   KFLD                    OENO16
     C                   KFLD                    IVNO07
      * by ship branch and non-stock id...
     C     NSBKEY        KLIST
     C                   KFLD                    ShipBr
     C                   KFLD                    IVNON1
      * by order number and line control number...
     C     TOL9_K1       KLIST
     C                   KFLD                    OENO01
     C                   KFLD                    OENO22
      * by customer and job number...
     C     JOBKEY        KLIST
     C                   KFLD                    Customer
     C                   KFLD                    OENO06
      * Ship Method and ship code ...
     C     ShpCodeKY     KLIST
   AKC*                  KFLD                    piShipMethod
   AKC*                  KFLD                    piShipCode
AK   C                   KFLD                    OECD01
AK   C                   KFLD                    ARCDC6
BA    * By document# and tran type
BA   C     k_totx1       klist
BA   C                   kfld                    kTranType
BA   C                   kfld                    kDocCode
     C     EKEY          KLIST
     C                   KFLD                    ARNO01
     C                   KFLD                    opcd14
     C                   KFLD                    OPNM13
      *------------------------------------------------------------------------*
      * Mainline processing...
      *------------------------------------------------------------------------*
     C                   EXSR      INITSR
      * Continue only if no errors were encountered...
     C                   IF        poErrCd = '0'
BA    *
BA    * Write to AvaTax Log file
BA   C                   if        AvaTaxActive = 'Y'
BA   C                   eval      kTranType = 'S/O'
BA   C                   eval      kDocCode  = %trim(picartid)
BA    * Write a row into TOTX if not already found.
BA    * This can occur if this program is called without calling AIR7062 first.
BA   C     k_totx1       setll     oeltotx2
BA   C                   if        not %equal
BA    *
BA   C                   z-add     1             piDocType
BA   C                   eval      piTaxErrCd = '05'
BA   C                   eval      piMode     = 'D'
BA   C                   eval      piAPIRqstTyp = 'CFG'
BA   C                   eval      piMode = 'T'
BA   C                   eval      piTranType= 'S/O'
BA   C                   eval      piTranNum = *blanks
BA   C                   eval      piDocCode = %trim(picartid)
BA   C                   eval      piPgmName = pgmName
BA    * To indicate the order is WebSmart order and so TOTX will need to be reached
BA    * using cart id & tran type
BA   C                   eval      WebSmartOrd = '1'
BA   C                   call      'OER9351'     pl9351
BA   C                   eval      WebSmartOrd = ' '
BA   C                   endif
BA   C                   endif
      *.....................
      * Process the order...
      *.....................
     C                   EXSR      PrcOrd
     C                   IF        poErrCd = '0'
      * Update log file with the new ord#
     C                   EXSR      WrtTaxLog
      *..................................................
      * Call program to roll combo price to components...
      *..................................................
     C                   CALL      'OER2504'
     C                   PARM                    BLANK_2           2
     C                   PARM                    BLANK_2
     C                   PARM                    BLANK_2
     C                   PARM                    BLANK_2
     C                   PARM                    BLANK_5           5
     C                   PARM                    OENO01
      *..............................................
      * Extend line items and re-calc order totals...
      *..............................................
     C                   CALL      'OER0005'
     C                   PARM                    OENO01
     C                   PARM      'Y'           NewOrder          1
     C                   parm                    PgmName
     C                   parm                    pModeOE
     C                   parm                    pType
     C                   parm                    pTaxAmtO
     C                   parm                    pTaxRateO
     C                   parm                    pGSTamtO
     C                   parm                    pGSTHSTCdO
     C                   parm                    pGSTHstRateO
     C                   parm                    pTaxblAmtO
     C                   parm                    pNTaxblAmtO
     C                   parm                    pApiMsgO
      *...........................................
      * For business to business orders see if the
      * order needs to be placed on credit hold...
      *...........................................
     C                   IF        B2B
     C                             or IMO
     C                   EVAL      SVCD04 = OECD04
     C                   CLEAR                   HLDORD
      * Credit check for charge only.
     C                   If        ch_oecd03='R'
     C                   EXSR      CREDSR
      * Place order on credit hold...
     C                   IF        HLDORD = 'Y'
     C                   CLEAR                   DSPF1
     C                   DOU       NOT %ERROR
     C     OENO01        CHAIN(E)  OELTOH1
     C                   IF        %ERROR
     C                   EXSR      UNLOCK
     C                   ENDIF
     C                   ENDDO
     C                   IF        %FOUND(OELTOH1)
      *   Change all line items to pending status...
     C                   IF        SVCD04 <> 'N'
     C                   EXSR      ChgLinSts
     C                   ENDIF
      *   Change order header to pending and credit hold...
     C                   MOVE      'N'           OEFL03                         PRINT PICK-TKT
     C                   MOVE      'N'           OEFL18                         CHRG INVOICEKT
     C                   MOVE      'N'           OEFL02                         CASH INVOICEKT
     C                   MOVE      'Y'           OECD38                         CREDIT HOLD
     C                   MOVE      ' '           OEFL04                         PROBLEM FLAG
     C                   MOVE      ' '           OEFL05                         PRICING FLAG
     C                   MOVE      'P'           OECD04                         ORDER STATUS
     C                   EXCEPT    CrdHld
      *   Send credit hold message...
     C                   EXSR      SndCrdMsg
BB    * Order being placed on credit hold event
BB   C                   if        not %open(arlmbch4)
BB   C                   open      arlmbch4
BB   C                   endif
BB   C     sellbr        chain     arlmbch4                                     BRANCH MASTER
     C                   if        %found
BB   C                   eval      comE20 = arno15
BB   C                   eval      divE20 = glcd41
BB   C                   eval      regE20 = glcd42
BB   C                   eval      sbrE20 = oeno08
BB   C                   eval      bnmE20 = arnm07
BB   C                   eval      ordE20 = oeno01
BB   C                   eval      cusE20 = arno01
BB   C                   eval      cnmE20 = cusnam
BB   C                   eval      usrE20 = oenm01
BB   C                   Call      'SHC5050'
BB   C                   Parm      'HDE0020'     EventID           7            Event Id
BB   C                   Parm                    d_hde0020                      Event Data
     C                   endif
      *   If order was not pending before it was placed on
      *   credit hold call program to re-total so that
      *   credit checking buckets will be adjusted...
     C                   IF        SVCD04 <> 'N'
     C                   CALL      'OER0005'
     C                   PARM                    OENO01
     C                   PARM      'N'           NewOrder          1
A1   C                   parm                    PgmName
A1   C                   parm                    pModeOE
A1   C                   parm                    pType
A1   C                   parm                    pTaxAmtO
A1   C                   parm                    pTaxRateO
A1   C                   parm                    pGSTamtO
A1   C                   parm                    pGSTHSTCdO
A1   C                   parm                    pGSTHstRateO
A1   C                   parm                    pTaxblAmtO
A1   C                   parm                    pNTaxblAmtO
A1   C                   parm                    pApiMsgO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   endif
     C                   ENDIF
      * Call program to update inventory...
     C                   CALL      'OER0006'
     C                   PARM                    OENO01
     C                   PARM                    ZeroLine#
     C                   PARM      'Y'           ALLOC             1
      * Send to Warehouse Management...
     C     WHMBR         IFEQ      'Y'
     C     OECD01        ANDNE     'D'
     C     OECD04        ANDNE     'N'
     C     OECD08        ANDNE     'Q'
     C                   CLEAR                   PDATA
     C                   MOVE      'OE '         WMFRM
     C                   MOVEL     OENO01        PDATA
     C                   CALL      'WXR5950'
     C                   PARM                    WMFRM             3
     C                   PARM                    PDATA           256
     C                   ENDIF
     C                   eval      oefl03 = 'N'                                 do not print pt
      * Print the pick ticket...
     C     OECD04        IFNE      'N'
     C     OEFL03        ANDEQ     'Y'
     C                   MOVEL     OENO01        OE1              10            ORDER NUMBER
     C                   MOVE      OENO16        OE1                            BRANCH
     C                   MOVEL     OE1           OE2              11            ORDER & BRANCH
   BJC*                  MOVE      'W'           OE2                            COUNTR/WAREHSE
BJ   C                   MOVE      OECD77        OE2                            COUNTR/WAREHSE
     C                   MOVE      ' '           OE3              12            REPRINT
     C                   MOVEL     OE2           OE3                            ORDER & BRANCH
     C                   MOVEA     OE3           ARY(13)
     C                   MOVE      ARCDB7        ARY(25)                        PRT PRICES
     C     OECD36        IFNE      'O'
     C     OECD36        ANDNE     'P'
     C     OECD36        ANDNE     'S'
     C                   MOVE      'N'           ARY(28)                        PICKING SEQ CODE
     C                   ELSE
     C                   MOVE      PICSEQ        ARY(28)                        PICKING SEQ CODE
     C                   ENDIF
     C                   MOVE      '2'           ARY(46)
     C                   MOVE      *BLANKS       ARY(27)
     C                   MOVEA     ARY           PTKT             70
     C                   Z-ADD     70            LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    PTKT                           COMMAND
     C                   PARM                    LEN                            LENGTH
     C                   ENDIF
      * Send order created message...
   DSC*                  EXSR      SndOrdMsg
      *
     C                   ENDIF
     C                   ENDIF
      *
      * Create direct purchase order, order status cannot be pending.
     C                   if        ch_apno01<>0                                 Create PO
     C                   Exsr      SrCreatePo
      * Do not send PO to EDI if sales order is on credit or problem hold
     C                   if        oecd38 <> 'Y' and oefl04 <> 'Y'
     C                   Exsr      SrSendEDI
     C                   Endif
     C                   Endif
      *...................
      * End the program...
      *...................
     C                   IF        poErrCd = '0'
     C                   EVAL      poOrderNo = OENO01
      * Update XML/IFS log files
     C                   exsr      srUpdIFSLog
     C                   ELSE
     C                   EVAL      poOrderNo = *ZEROS
     C                   ENDIF
      * If error, place order on problem hold.
     C                   if        ord_err ='Y' or po_err = 'Y'
     C                   exsr      srUpdHeader
     C                   if        oefl04 = 'Y'
     C                   if        not %open(arlmbch4)
     C                   open      arlmbch4
     C                   endif

     C     sellbr        chain     arlmbch4                                     BRANCH MASTER
     C                   if        %found
     C                   eval      bnmE70 = arnm07
     C                   eval      comE70 = arno15
     C                   eval      divE70 = glcd41
     C                   eval      regE70 = glcd42
     C                   eval      ordE70 = oeno01
     C                   eval      cusE70 = arno01
     C                   eval      cnmE70 = cusnam
     C                   eval      usrE70 = oenm01
     C                   Call      'SHC5050'
     C                   Parm      'HDE7020'     EventID           7            Event Id
     C                   Parm                    d_HDE7020                      Event Data
     C                   endif
     C                   endif
     C                   endif

      * Email sales order ack?
     C                   if        cEslsack = 'Y' and arfl72 = 'E'
     C                   eval      opnm13=' '
     C                   eval      opcd14='01'                                  email
     C     ekey          chain     opfmema
     C                   if        %found and opad01 <> ' '
     C                   call      'OERB9020'
     C                   parm                    oeno01
     C                   parm                    opad01
     C                   endif
     C                   endif

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *------------------------------------------------------------------------*
      * Send message indicating a web order has been created
      *------------------------------------------------------------------------*
     C     SndOrdMsg     BEGSR
     C                   MOVEA     piCustomer    MS(20)
     C                   MOVEA     OENO01        MS(49)
     C                   MOVEA     MONTH         MS(77)
     C                   MOVEA     DAY           MS(80)
     C                   MOVEA     YEAR          MS(83)
     C                   MOVEA     HOUR          MS(109)
     C                   MOVEA     MIN           MS(112)
     C                   MOVEA     SEC           MS(115)
      * Include type of order in the message.
     C                   SELECT
     C                   WHEN      OECD04 = 'O'
     C                   MOVEA     ' -Open- '    MS(154)
     C                   WHEN      OECD04 = 'I'
     C                   MOVEA     'Invoiced'    MS(154)
     C                   WHEN      OECD04 = 'N'
     C                   MOVEA     '*Pending'    MS(154)
     C                   WHEN      OECD04 = 'K'
     C                   MOVEA     'Reserved'    MS(154)
     C                   ENDSL
     C                   MOVEA     MS            SNDMSG          243
      * Call program to send the message...
     C                   CALL      'WBC0315'
     C                   PARM                    OrdMsgPrf
     C                   PARM                    SNDMSG
     C                   ENDSR
A1    *------------------------------------------------------------------------*
A1    * Write to tax log file
A1    *------------------------------------------------------------------------*
A1   C     WrtTaxLog     begsr
A1    *
A1   C                   if        piApp = 'B2C'
A1   C                   eval      piBillType = '01'
A1   C                   else
A1   C                   eval      piBillType = '02'
A1   C                   endif
A1   C                   eval      piMode = 'T'
A1   C                   eval      piTranNum = oeno01
A1   C                   eval      piTranType= 'S/O'
A1   C                   eval      piDocCode = %trim(picartid)
A1   C                   eval      piDocType = 1
A1   C                   eval      piPgmName = pgmName
A1   C                   call      'OER9351'     pl9351
A1    *
A1   C                   ENDSR
      *------------------------------------------------------------------------*
      * Process the order
      *------------------------------------------------------------------------*
     C     PRCORD        BEGSR
     C                   eval      ord_err  = 'N'
     C                   eval      po_err   = 'N'
      *....................
      * Get the job name...
      *....................
     C                   MOVE      *BLANKS       JBCDF9
     C     OENO06        IFNE      *BLANKS
     C                   IF        not %OPEN(ARLMJBM1)
     C                   OPEN      ARLMJBM1
     C                   ENDIF
     C     JOBKEY        CHAIN     ARLMJBM1                           40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     ARNM04        OENM02
     C                   MOVE      'Y'           GOODJB                         VALID JOB RCD
      *  If job has a credit limit set up then use it instead of
      *  the customer credit limit...
     C     ARAMB5        IFNE      *ZEROS
     C                   MOVE      'Y'           USEJOB            1
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ' '           GOODJB            1            VALID JOB RCD
     C                   MOVEL     piJobName     OENM02
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ' '           GOODJB
     C                   MOVEL     piJobName     OENM02
     C                   ENDIF
      *.....................................
      * ASSIGN CONSTANT SALES ORDER DEFAULTS
      *.....................................
     C                   CLEAR                   OECD65
     C                   CLEAR                   OEFTOL
     C                   eval      oecc07 = ch_oecc07
     C                   eval      oeyr07 = ch_oeyr07
     C                   eval      oemo07 = ch_oemo07
     C                   eval      oedy07 = ch_oedy07
     C                   EVAL      OENO16 = ShipBr
     C                   EVAL      OENO08 = SellBr
     C                   EVAL      ARNO01 = Customer
     C                   EVAL      ARNO15 = Company
     C                   EVAL      OEID02 = SalesId
     C                   EVAL      OECD01 = ch_oecd01
     C                   EVAL      OEFL17 = 'Y'
     C                   EVAL      OECD17 = SrcOfSale
     C                   EVAL      OECD19 = SaleType
      *
      * RETRIEVE PICKING SEQUENCE OPTION FROM TF-WEB
      *
     C                   MOVE      *BLANKS       TBNO01
     C                   MOVEL     'WEB'         TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'PICKSEQ'     TBNO02
     C     TABKEY        CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   MOVEL     TBNO03        PICSEQ            1
AP   C     PICSEQ        IFNE      'O'
AP   C     PICSEQ        ANDNE     'P'
AP   C     PICSEQ        ANDNE     'S'
AP   C                   MOVE      'P'           OECD36                         PICKING SEQ CODE
     C                   eval      picseq = oecd36
AP   C                   ELSE
AP   C                   MOVE      PICSEQ        OECD36                         PICKING SEQ CODE
AP   C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'N'           OEFL03                         PRINT PICK TICKET
     C                   MOVE      'WOE'         OEID01
     C                   MOVE      ' '           OECD38                         S/O ON CREDIT HOLD
   AAC*                  MOVE      'W'           OECD10                         TYPE OF S/O ENTERED
AA   C                   IF        B2B
AI   C                             or IMO
AA   C                   EVAL      OECD10 = '1'
AA   C                   ELSE
AA   C                   EVAL      OECD10 = '2'
AA   C                   ENDIF
BD   C                   IF        CRB
BD   C                   EVAL      OECD10 = '3'
BD   C                   ENDIF
     C                   MOVE      'R'           OECD03                         CHARGE OR CASH
     C                   MOVE      'A'           OECD05                         S/O TYPE ENTERED
     C                   MOVE      'N'           OECD18                         OVERRIDE PRICE CODE
     C                   MOVE      'O'           OECD08                         MEMO TYPE CODE
     C                   MOVE      'I'           OECD16                         ORD FILL TYPE CODE
     C                   if        oecd01 = 'D'
     C                   MOVE      'D'           OECD16                         ORD FILL TYPE CODE
     C                   eval      oecd32 =  'P'                                Prepaid freight code
     C                   endif
     C                   MOVE      'N'           OEFL09
     C                   MOVE      ' '           OEFL02
     C                   MOVE      'N'           OEFL15
     C                   MOVE      'N'           OEFL18
     C                   MOVE      'N'           OECD67                         BULK PRICING
     C                   MOVE      ' '           OECD07
AL   C                   IF        B2C
AL   C                   MOVEL     SH_OEAD04     OENM01
AL   C                   ELSE
     C                   MOVEL     SH_OENM17     OENM01
AL   C                   ENDIF
AJ   C                   IF        B2B
AJ   C                             or IMO
     C                   MOVEL     SH_OENM17     OENM15
AJ   C                   ELSE
AJ   C                   MOVEL     ORDERBY       OENM15
AJ   C                   ENDIF
     C                   MOVE      SH_OENO19     OENO19                         CONTRACT NUMBER
     C                   IF        OENO19 = *BLANKS
     C                   MOVE      *ALL'0'       OENO19
     C                   ENDIF
      * No print pick ticket for pending orders or warehouse branches...
     C                   IF        DftOrdSts = 'P'
     C                             or ANYWM = 'Y'
     C                   MOVE      'N'           OEFL03
     C                   ENDIF
      * Convert customer PO number to upper case...
     C     LO:UP         XLATE     piCustPO      OENO07
     C                   eval      oeno07 = ch_oeno07
      * Get the next order number...
     C                   EXSR      NextOrd
      *
      * SEE IF USING GST TAX ?
      *
     C                   MOVE      'AR17'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'GSTTAX'      TBNO02
     C                   MOVE      'Y'           TBNO02
     C     TABKEY        CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   MOVE      'Y'           USEGST            1
     C                   MOVEL     TBNO03        GSTPCT
     C                   ELSE
     C                   MOVE      ' '           USEGST
     C                   ENDIF
      *
      * RETRIEVE ORDER ENTRY APPLICATION OPTIONS
      *
     C                   MOVE      'OE40'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'OPTIONS'     TBNO02
     C     TABKEY        CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   MOVEL     TBNO03        OPTS                           O/E OPTIONS
     C                   ENDIF
      *
      * Retrieve the system date and time...
      *
     C                   CALL      'OPC0061'
     C                   PARM                    WRKDAT           14 0
     C                   MOVE      WRKDAT        TIMDAT
     C                   MOVE      TIMDAT        SAVDAT
     C                   Z-ADD     CURDAT        DATE02
     C                   Z-ADD     CURDAT        SODATE
     C                   Z-ADD     CURDAT        DATE05
     C                   Z-ADD     CURDAT        DATE01
     C                   Z-ADD     CURDAT        DATE09
     C                   Z-ADD     CURDAT        DATE10
     C     SHPDAT        IFEQ      'Y'
     C                   Z-ADD     CURDAT        DATE06
     C                   ELSE
     C                   Z-ADD     *ZEROS        DATE06
     C                   ENDIF
      *
     C                   MOVE      OENO01        OENO26
      * If B2B and ship method is 'pick-up', get the jurisdiction
      * from the branch master...
     C                   IF        ch_oecd01 = 'P'
A5   C                             and B2B
     C                   IF        not %OPEN(ARLMBCH4)
     C                   OPEN      ARLMBCH4
     C                   ENDIF
AO   C     ShipBr        CHAIN     ARLMBCH4
     C                   IF        %FOUND
     C                   MOVE      ARCD04        TAXJUR
AQ    *...................................................
AQ    * If Pickup default shp Address to Brch address  ...
AQ    *...................................................
AQ   C                   EVAL      piShAddr1  =  ARAD10                         ADDRESS 1
AQ   C                   EVAL      piShAddr2  =  ARAD11                         ADDRESS 2
AQ   C                   EVAL      piShAddr3  =  ARAD12                         ADDRESS 3
AQ   C                   EVAL      piShCity   =  ARCY04                         CITY
AQ   C                   EVAL      piShState  =  ARST04                         STATE
AQ   C                   EVAL      piShZip    =  ARZP18                         ZIP
     C                   ENDIF
     C                   ENDIF
      * Retrieve customer master information...
     C                   MOVE      *BLANKS       CSCDF9
     C     Customer      CHAIN     ARFMCUS
     C                   IF        not %FOUND
     C                   eval      ord_err = 'Y'
     C                   eval      errmsg  = 'Invalid customer account'
     C                   exsr      srComments
     C                   else
      * If B2B and ship method is 'pick-up' and the customer master
      * has a pick-up jurisdiction, use it...
     C                   IF        ch_oecd01 = 'P'
A5   C                             and B2B
     C                             and CPUJUR <> 0
     C                   EVAL      TAXJUR = CPUJUR
     C                   ENDIF
BD    * Customer rebate credit memos use direct MOS
BD    * should use the customer jurisdiction...
BD   C                   IF        CRB
BD   C                             and CUSJUR <> *ZEROS
BD   C                   EVAL      TAXJUR = CUSJUR
BD   C                   ENDIF
     C                   EVAL      OENO24 = TAXJUR
AA    * For B2C we will get the tax jurisdiction from
AA    * table TAXS entry JURIS...
A1    * The following license key checking logic may not be altered, bypassed or removed.
A1    * See Legal Document in WRKMINKEY command for more information.
AA   C                   IF        B2C
A1 A5C*                            or AvaTaxActive = 'Y'
A1 A5C*                            and LicToAvaTax
AA   C                   MOVE      'TAXS'        TBNO01
AA   C                   MOVE      *BLANKS       TBNO02
AA   C                   MOVEL     'JURIS'       TBNO02
AA   C     TABKEY        CHAIN     TBFMTBL
AA   C                   IF        %FOUND
AA   C                   MOVEL     TBNO03        OENO24
AA   C                   ELSE
AA   C                   CLEAR                   OENO24
AA   C                   ENDIF
AA   C                   ENDIF
      * Load cash/charge flag...
     C                   IF        CreditCard
     C                   MOVE      'C'           OECD03
AH   C                   MOVE      'N'           OEFL02
     C                   ELSE
   ARC*                  MOVE      'R'           OECD03
BD   C                   IF        NOT CRB
AR   C                   MOVE      ARCD21        OECD03
BD   C                   ENDIF
AH   C                   CLEAR                   OEFL02
     C                   ENDIF
      * Set to charge
     C                   eval      oecd03 = ch_oecd03
      * if customer is a cash account, do not allow terms order.
     C                   if        oecd03 = 'R' and arcd21='C'
     C                   eval      ord_err = 'Y'
     C                   eval      errmsg  = 'Terms not allow on cash acct'
     C                   exsr      srComments
     C                   endif
     C                   eval      oecd01 = ch_oecd01
      * Load taxable flag using tax exempt from customer master...
     C     ARFL13        IFEQ      'Y'
AH   C     B2C           ANDNE     *ON
A3 A4C*    avaTaxActive  oreq      'Y'
     C                   MOVE      'N'           OEFL08
     C                   ELSE
     C                   MOVE      'Y'           OEFL08
     C                   ENDIF
      *
      * CUSTOMER ORDER TERMS
      *
      *
      * DOES CUSTOMER BELONG TO AN ENTERPRISE ?
      *
     C                   Z-ADD     *ZEROS        ARAMC6
     C                   CLEAR                   EBAM01
     C     ENTNBR        IFNE      *ZEROS
     C     CONSOL        IFEQ      'C'
     C                   IF        not %OPEN(ARLMENT1)
     C                   OPEN      ARLMENT1
     C                   ENDIF
     C     ENTNBR        CHAIN     ARLMENT1
     C                   ELSE
     C                   IF        not %OPEN(ARLEBAL1)
     C                   OPEN      ARLEBAL1
     C                   ENDIF
     C     EBKEY         CHAIN     ARLEBAL1
     C                   ENDIF
     C                   ENDIF

      * Check for customer balance balance
     C     Cus_Co        CHAIN     ARFMBAL
     C                   if        not %found
     C                   eval      ord_err = 'Y'
     C                   eval      errmsg  = 'No customer balance'
     C                   exsr      srComments
     C                   else
     C                   if        %found and arfl17 = 'C'
     C                   eval      ord_err = 'Y'
     C                   eval      errmsg  = 'Customer balance closed'
     C                   exsr      srComments
     C                   endif
     C                   endif
      *
      * RETRIEVE HOLD CONDITIONS
      *
     C                   MOVE      'OE90'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'HOLD'        TBNO02
     C     TABKEY        CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   MOVEL     TBNO03        HLDCND
     C                   ENDIF
      * Set order status
     C                   eval      oecd04='O'
      * If nondirect, use table order status of open, pending or reserved.
     C                   if        oecd01 <> 'D'
     C                   eval      oecd04 = cNDordsts
     C                   endif
     C                   ENDIF
      *
      * GET CURRENT A/R PERIOD FOR COMPANY
     C                   Z-ADD     2             DTFUNC
     C                   Z-ADD     Company       DTCOMP
     C                   CALL      'OPR0810'     PL0810
     C                   Z-ADD     CARFM1        DATE08
     C                   Z-ADD     CARFM2        CRARPD
     C                   EVAL      poErrMsg = 'DTFUNC = ' + %char(DTFUNC) +
     C                              ' DTCOMP = ' + %char(DTCOMP) +
     C                              ' COMPANY = ' + %char(COMPANY) +
     C                              ' DATE08  = ' + %char(DATE08) +
     C                              ' CARFM1 = ' + %CHAR(CARFM1)
     C                   EXSR      BILSR
      *................................
      * Process special instructions...
      *................................
     C                   IF        piSpecInst <> *Blanks
     C                   EXSR      PrcSpecInst
     C                   ENDIF
      *.........................
      * Process body comments...
      *.........................
     C                   IF        piBodyCmts <> *Blanks
     C                   EXSR      PrcBodyCmt
     C                   ENDIF
      *......................
      * Process line items...
      *......................
     C                   EXSR      PrcCartDetail
      *...............................................
      * All line items have been written.
      * See if the order status needs to be changed...
      *...............................................
     C                   IF        CreditCard
     C                             and OEFL10 = 'Y'
     C                             and OECD04 <> 'N'
     C                   EXSR      ChgStsRes
     C                   ENDIF
      *.........................
      * Process other charges...
      *.........................
     C                   EXSR      PrcOtherChgs
      *...........................................
      * Populate additional order header fields...
      *...........................................
     C                   Z-ADD     OENO09        OECN01
AL   C                   IF        B2C
AL   C                   MOVEL     SH_OEAD04     OENM01
AL   C                   ELSE
     C                   MOVEL     SH_OENM17     OENM01
AL   C                   ENDIF
     C                   MOVE      'N'           OEFL07
     C                   CLEAR                   OENO20
     C                   EVAL      OECD17 = SrcOfSale
     C                   EVAL      OECD19 = SaleType
      *...................................................
      * For B2B order see if the address was overridden...
      *...................................................
     C                   EVAL      OEFL06 = 'N'
     C                   IF        B2B
AI   C                             or IMO
     C                   IF        piShAddr1 <> CUSAD1
     C                             or piShAddr2 <> CUSAD2
     C                             or piShAddr3 <> CUSAD3
     C                             or piShCity  <> CUSCTY
     C                             or piShState <> CUSSTA
     C                             or piShZip   <> CUSZIP
     C                   EVAL      OEFL06 = 'Y'
     C                   ENDIF
     C                   ENDIF
      *.....................................................
      * If the address was overridden or if it's a B2C order
      * write the address to the address override file...
      *.....................................................
     C                   IF        OEFL06 = 'Y'
     C                             or B2C
     C                   MOVE      'Y'           OEFL06                         SHIP TO FLAG
AL   C                   IF        B2C
AL   C                   MOVEL     SH_OEAD04     OENM01
AL   C                   ELSE
     C                   MOVEL     SH_OENM17     OENM01                         USER ID
AL   C                   ENDIF
     C                   MOVEL     piShAddr1     OEAD01                         ADDRESS 1
     C                   MOVEL     piShAddr2     OEAD02                         ADDRESS 2
     C                   MOVEL     piShAddr3     OEAD03                         ADDRESS 3
     C                   MOVEL     piShCity      OECY01                         CITY
     C                   MOVEL     piShState     OEST01                         STATE
     C                   MOVEL     piShZip       OEZP03                         ZIP
     C                   IF        not %OPEN(OEPTOA)
     C                   OPEN      OEPTOA
     C                   ENDIF
     C                   WRITE     OEFTOA                                      SHIP TO FILE
     C                   ENDIF
      *....................................................
      * For B2C order write walk-in customer transaction...
      *....................................................
     C                   IF        B2C
     C                   MONITOR
     C                   MOVEL     piPhone       PhoneDS
     C                   ON-ERROR
     C                   EVAL      ARNO07 = *ZEROS
     C                   EVAL      ARNO08 = *ZEROS
     C                   EVAL      ARNO09 = *ZEROS
     C                   ENDMON
     C                   EVAL      ARNM09 = OrderBy
     C                   EVAL      OEAD04 = piUserId
     C                   Z-ADD     CURDAT        DATE10
     C                   IF        not %OPEN(ARPTWI)
     C                   OPEN      ARPTWI
     C                   ENDIF
     C                   WRITE     ARFTWI
     C                   ENDIF
      *...................
      * Get tax percent...
      *...................
     C                   EXSR      TAXSR
      *...................
      * Get order terms...
      *...................
     C                   MOVE      *BLANKS       ARCDF9
     C                   Z-ADD     0             ARCD25
     C                   MOVE      'N'           ARCDB5
     C     OECD03        IFNE      'C'
     C     JBCDF9        IFNE      *BLANKS
     C                   MOVE      JBCDF9        ARCDF9
     C                   ELSE
     C                   MOVE      CSCDF9        ARCDF9
     C                   ENDIF
     C     ARCDF9        IFNE      *BLANKS
     C                   IF        not %OPEN(ARLMTRH1)
     C                   OPEN      ARLMTRH1
     C                   ENDIF
     C     ARCDF9        CHAIN     ARLMTRH1                           44
     C     *IN44         IFEQ      *OFF
     C                   Z-ADD     ARPC71        ARCD25
     C                   MOVE      ARCDG1        ARCDB5
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *..........................
      * Print location....
      *   similar to OER2020
      *..........................
     C                   if        OEFL03 = 'Y'
     C                   if        OECD01 = 'P'
     C                   eval      OECD77 = 'C'
     C                   else
     C                   eval      OECD77 = 'W'
     C                   endif
     C                   endif
      *..........................
      * Print component detail...
      *..........................
     C                   SELECT
     C     PRTDET        WHENEQ    'YY'
     C                   MOVE      'B'           OECD83                         BOTH
     C     PRTDET        WHENEQ    'YN'
     C                   MOVE      'T'           OECD83                         PICK-TICKET
     C     PRTDET        WHENEQ    'NY'
     C                   MOVE      'I'           OECD83                         INVOICE
     C     PRTDET        WHENEQ    'NN'
     C                   MOVE      'N'           OECD83                         NEITHER
     C                   ENDSL
      *...............................................
      * Write the cash sale information transaction...
      * NOTE: The record is written with zero amounts
      *       because they will be populated later by
      *       another program.
      *...............................................
     C                   IF        CreditCard
     C                   CLEAR                   OEAM04
     C                   CLEAR                   OEAM06
     C                   CLEAR                   OEAM07
     C                   CLEAR                   OEAM08
     C                   IF        piCCAmt <> *ZEROS
     C                   Z-ADD     piCCAmt       OEAM36
     C                   ELSE
     C                   Z-ADD     piOrdTotal    OEAM36
     C                   ENDIF
     C                   CLEAR                   OEAM44
     C                   CLEAR                   OETL01
     C                   IF        not %OPEN(OEPTOC)
     C                   OPEN      OEPTOC
     C                   ENDIF
     C                   WRITE     OEFTOC
AJ    *
AJ    * Write to Credit Card transaction file.
AJ   C     ONLINE        IFEQ      'Y'
AJ   C                   EVAL      pMode = 'WRT'
AJ   C                   EVAL      pRetry = 'N'
AJ   C                   EVAL      pUpdError = 'N'
AJ   C                   EVAL      pTran = OENO01
AJ   C                   EVAL      pMFUKEY = piMFUKEY
AJ   C                   EVAL      pMethod = '02'
AV   C                   EVAL      Brnch# = Sellbr
AV   C                   EVAL      pidata  = pidet
AJ   C                   EVAL      pTrnDtl = 'N'
AJ   C                   CLEAR                   pMsg
AJ   C                   CLEAR                   pData
AJ   C                   CLEAR                   pSuccess
BG   C                   CLEAR                   devSerial#
AJ BGC*                  CALL      'OER9600'     pl9600
BG   C                   CALL      'OER9650'     pl9600
AJ   C                   ENDIF
AJ    *
     C                   ENDIF
      *................................................
      * Write the order header...
      * NOTE: The record is written without the order
      *       tax amounts and totals because they will
      *       be populated by another program.
      *................................................
      * Direct sales order tied to PO must be in open status!!!!!
     C                   if        oecd01 = 'D'
     C                   eval      oecd04 = 'O'
     C                   endif
      * If cash order, place order on problem hold
     C                   if        oecd03='C'
     C                   eval      ord_err = 'Y'
     C                   eval      errmsg  = 'B2B Payment Hold'
     C                   exsr      srComments
     C                   eval      oefl04='Y'
     C                   endif
      * If account closed, place order on problem hold.
     C                   if        arfl10 = 'C'
     C                   eval      ord_err = 'Y'
     C                   eval      errmsg  = 'Closed account'
     C                   exsr      srComments
     C                   endif

     C                   WRITE     OEFTOH
      *
     C                   ENDSR
      *----------------------------------------------------------------
      * Process shopping cart detail
      *
      * Read records from the shopping cart detail file for the ship
      * branch being processed and write them to the O/E line item file
      *------------------------------------------------------------------------*
     C     PrcCartDetail BEGSR
     C                   eval      line_err = 'N'
     C                   eval      oeno17 = 0
     C     piCartID      SETLL     AILTSCL2
     C                   DOU       %EOF(AILTSCL2)
     C     piCartID      READE     AILTSCL2
     C                   IF        %EOF(AILTSCL2)
     C                   LEAVE
     C                   ENDIF
      * Initialize fields...
     C                   CLEAR                   OENO21
      * Get the line control number for the sales order line...
     C                   EXSR      GetLineCtl
     C                   EXSR      PrcLineItem
      * The shopping cart does not contain components.
      * So, if the line item that was just processed was a combo or kit
      * write the components to the sales order...
     C                   IF        OECD09 = 'A'
     C                             or OECD09 = 'K'
     C                   EXSR      PrcComponents
     C                   ENDIF
      * Line comments must follow the last component (if any) so
      * they are processed last and the subroutine will update the
      * line item they follow with the tag information...
     C                   EXSR      PrcLineCmt
      *
     C                   ENDDO
     C                   ENDSR
      *----------------------------------------------------------------
      * Process shopping a shopping cart line item
      *
      * The shopping cart only contains the following types of
      * line items:
      *    S = Stocked
      *    N = Non-stock
      *    A = Stocked Combination
      * Therefore, these are the only types of line items this
      * subroutine deals with.
      *
      * After this subroutine is executed a check is done to see if
      * the item processed was a combination, and if so another
      * subroutine is executed to load the components.
      *------------------------------------------------------------------------*
     C     PrcLineItem   BEGSR
     C                   CLEAR                   OEQY06
     C                   CLEAR                   IVNO14
     C                   CLEAR                   OECD30
     C                   CLEAR                   OECN04
     C                   CLEAR                   OECD28
     C                   CLEAR                   OECD43
      *..................................................
      * Populate order entry line item fields with values
      * from the shopping cart...
      *..................................................
     C                   Z-ADD     SL_IVNO07     IVNO07
      *..................................................
      * Process line item.
      *..................................................
       if sl_ivno07 = 0;
          if sl_ivno07= 0;
          exec sql
               select IVNO07
               into :sl_ivno07
               from IVPMSTR
               where IVNO04= :sl_ivno04;     // Check prod to prod
          endif;
          if sl_ivno07= 0;
             exec sql
                 select IVNO07
                 into :sl_ivno07
                 from IVPMSTR
                 where IVNO93= :sl_ivno04;   // Check prod to manuf#
          endif;
          if sl_ivno07 = 0 and sl_ivdn01<> ' ';
             exec sql
                  select IVNO07
                  into :sl_ivno07
                  from IVPMSTR
                  where IVNO93= :sl_ivdn01;   // Check description to manuf#
          endif;
       endif;
       if sl_ivno07=0;
          temp_item='Y';  // Flag to create temp item and place order on hold
          new_ivno04 = sl_ivno04;
          new_desc   = sl_ivdn01;
          if   sl_ivdn01 = ' ';
               sl_ivdn01 = 'No desc';
          endif;
          exsr sr_CreateItem;
       endif;
       ivno07 = sl_ivno07;
      * If temporary item created, trigger event.
     C                   if        crtitmflg = 'Y'
     C                   eval      ivno07  = new_ivno07
     C                   eval      sl_ivno07  = new_ivno07
     C                   eval      itemE27 = ivno07
     C                   MOVEL     i_ivno04      pddsE27
     C                   MOVE      i_ivdn01      pddsE27
     C                   eval      branE27 = sl_oeno16
     C                   eval      brnmE27 = arnm07
     C                   eval      userE27 = ivnm01
     C                   eval      vndrE27 = ch_apno01
     C                   eval      vnrnm27 = apnm01
     C                   Call      'SHC5050'
     C                   Parm      'HDE0027'     EventID           7            Event Id
     C                   Parm                    d_HDE0027                      Event Data
     C                   endif
     C                   Z-ADD     SL_OENO16     OENO16
      *  The quantity ordered from the shopping cart is
      *  at the ordering UOM so it gets loaded to OEQY14...
     C                   Z-ADD     SL_OEQY01     OEQY14
     C                   MOVEL     SL_OEDN04     OEDN04
     C                   Z-ADD     SL_OEAM01     OEAM01

      * If zero price, place order on problem hold.
     C                   if        oeam01 = 0
     C                   eval      ord_err = 'Y'
     C                   eval      errmsg  = '** Zero Price **'
     C                   exsr      srComments
     C                   endif

     C                   Z-ADD     SL_OEAM02     OEAM02
      * If zero cost, place order on problem hold.
     C                   if        oeam02 = 0
     C                   eval      ord_err = 'Y'
     C                   eval      errmsg  = '** Zero Cost **'
     C                   exsr      srComments
     C                   endif

     C                   Z-ADD     SL_OEAM05     OEAM05
     C                   MOVE      SL_OEPC01     OEPC01
     C                   MOVE      SL_OECD26     OECD26
     C                   MOVE      SL_OECD27     OECD27
     C                   MOVE      SL_OECD31     OECD31
   ACC*                  Z-ADD     SL_OENO08     OENO08
AC   C                   Z-ADD     SellBr        OENO08
     C                   Z-ADD     SL_OEAM38     OEAM38
     C                   Z-ADD     SL_OEPC07     OEPC07
     C                   Z-ADD     SL_PONO05     PONO05
     C                   Z-ADD     SL_OENO31     OENO31
      *................................
      * Determine the line item type...
      *................................
      * If the shopping cart has an item number determine if the item
      * is a regular item or a combo...
     C                   IF        IVNO07 <> *ZEROS
     C     IVNO07        CHAIN     IVLMSTR8
      *
     C                   IF        IVCD24 = 'Y'
     C                   EVAL      OECD09 = 'A'
     C                   ELSE
     C                   EVAL      OECD09 = 'S'
     C                   ENDIF
      * Check for deleted item
     C                   if        ivcd25 = 'D'
     C                   exsr      srUnDeleteItem
      *----------------------------------------------------------------
      * Create event for reactivated item
      *----------------------------------------------------------------
     C                   move      *blanks       LongItem         48
     C                   movel     ivno04        LongItem
     C                   move      ivdn01        LongItem
     C                   eval      d_HDE7029.Item = LongItem
     C                   eval      d_HDE7029.CrtUser = UsrNm
     C                   eval      d_HDE7029.IVNO07 = IVNO07
     C                   eval      d_HDE7029.date = %char(%date : *ymd/)
     C                   eval      d_HDE7029.time = %char(%time() : *HMS:)
      *
      * Call program to create Event
     C                   Call      'SHC5050'
     C                   Parm      'HDE7029'     EventID           7            Event Id
     C                   Parm                    d_HDE7029                      Event Data
      *
      *
     C     IVNO07        CHAIN     IVLMSTR8
     C                   endif
      *.............................................
      * Get pricing and ordering UOMs and factors...
      *.............................................
     C                   Z-ADD     1.            PRCFCT
     C                   Z-ADD     1.            ORDFCT
      * Not required for non-stocks...
     C                   IF        OECD09 <> 'N'
      * Use API to retrieve ordering and pricing UOMs and factors...
      * NOTE: If ordering uom is populated it will retrieve the
      *       factor for that uom, otherwise it will retrieve
      *       the default ordering uom and factor.
     C                   Z-ADD     IVNO07        PUOMI#
     C                   MOVE      OEDN04        PUOMOU
     C                   CALL      'OER9320'     PL9320
     C                   EVAL      OEDN04 = PUOMOU
     C                   IF        PUOMOF <> *ZEROS
     C                   EVAL      ORDFCT = PUOMOF
     C                   ENDIF
     C                   EVAL      IVDN02 = PUOMPU
     C                   IF        PUOMPF <> *ZEROS
     C                   EVAL      PRCFCT = PUOMPF
     C                   ENDIF
      * Check for UOM error = Order UOM not found
     C                   if        PUOMRC  = '1'
     C                   eval      ord_err = 'Y'
     C                   eval      errmsg ='Order UOM not found' + %char(ivno07)
     C                   exsr      srComments
     C                   endif
      * Calculate quantity ordered at stocking uom...
     C     OEQY14        MULT      ORDFCT        OEQY01
     C                   ENDIF
      *.................................
      * Calculate pricing net amount...
      * NOTE: OEAM38 is in the shopping cart at the ordered UOM.
      *       The logic below converts it to the pricing UOM
      *       because that's how it is carried in the order entry
      *       line item file.
     C     OEAM38        DIV       ORDFCT        WKAM38
     C     WKAM38        MULT      PRCFCT        OEAM38
      *
      * IF CUSTOMER NONTAXABLE, MAKE LINE NONTAXABLE
      *
     C     OEFL08        IFEQ      'N'
     C                   MOVE      'N'           OECD31
     C                   ENDIF
BH   C     IVCDIN        IFEQ      'Y'
BH   C     CRB           OREQ      *ON
      * Retrieve quantity available...
     C                   IF        OECD09 = 'N'
     C                   MOVEL     SL_IVNO04     IVNON1
     C                   ENDIF
     C                   EXSR      GetAvail
     C                   Z-ADD     IVQY23        OEQY07
      * Calculate ship and backorder quantities...
     C                   EXSR      CHKSTK
BH   C                   ELSE
BH   C                   Z-ADD     OEQY01        OEQY07
BH   C                   Z-ADD     OEQY01        OEQY03
BH   C                   Z-ADD     OEQY01        OEQY16
BH   C                   CLEAR                   OEQY02
BH   C                   CLEAR                   OEQY15
BH   C                   ENDIF
      *
      * IF THERE IS A BACK ORDER QTY AND ALLOW BACKORDERS IS NO IN
      * THE CUSTOMER MASTER FILE THEN STATUS THE B/O WITH A 'V'
      *
     C     OEQY02        IFGT      *ZERO
     C     ARFL01        ANDEQ     'N'
     C                   MOVE      'V'           OECD47
     C                   ELSE
     C                   MOVE      ' '           OECD47
     C                   ENDIF
      *  Set purchase in progress backorder status
     C                   if        oeqy02 > 0 and ch_apno01<>0
     C                   eval      oecd47 = 'P'
     C                   endif
      *
     C                   TIME                    OETM01                         ENTERED TIME
     C                   CLEAR                   OECD66
     C                   Z-ADD     ARCD65        OECD48
      * If it's a combo populate the line item combination
      * sequence number...
     C                   IF        OECD09 = 'A'
     C                   EVAL      OENO23 = OENO22
     C                   ELSE
     C                   CLEAR                   OENO23
     C                   ENDIF
     C                   eval      orduom = ivdn02
      *
      * Write the line item...
     C                   ADD       1             OENO09
     C                   WRITE     OEFTOL
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Get available
      * NOTE: For non-stocks field IVNON1 needs to be populated with
      *       the non-stock id prior to executing this subroutine.
      *------------------------------------------------------------------------*
     C     GetAvail      BEGSR
     C                   CLEAR                   IVQY23
     C                   SELECT
      * Stock items...
     C                   WHEN      OECD09 = 'S'
     C     SBR1_K1       CHAIN     IVLMSBR1
      * BRANCH MASTER NOT FOUND - GO SET-UP BLANK BRANCH MASTER
     C                   if        not %found
     C                   CALL      'IVR0115'
     C                   PARM                    shipbr                         SHIP TO BRANCH
     C                   PARM                    IVNO07                         ITEM #
     C                   PARM                    APPCDE                         APPLICATION
     C                   endif
      * Stock components...
     C                   WHEN      OECD09 = 'G'
     C     SBR1_K2       CHAIN     IVLMSBR1
      * Non-stock items...
     C                   WHEN      OECD09 = 'N'
     C                             or OECD09 = 'X'
     C                   IF        not %OPEN(IVLMNSB1)
     C                   OPEN      IVLMNSB1
     C                   ENDIF
     C     NSBKEY        CHAIN     IVLMNSB1
      * Combo items NOT released from a contract...
     C                   WHEN      OECD09 = 'A'
     C                             and NOT FromContract
     C                   CALL      'IVR0421'     PL0421
      * Combo items released from a contract...
     C                   WHEN      OECD09 = 'A'
     C                             and FromContract
     C                   CALL      'IVR0422'     PL0422
     C                   ENDSL
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Calculate shipped and backordered quantities
      * NOTE: OEQY01 and IVQY23 are both at the stocking UOM.
      * NOTE: Do not use this subroutine for components!
      *------------------------------------------------------------------------*
     C     CHKSTK        BEGSR
     C                   SELECT
      *   Entire quantity backordered...
     C                   WHEN      IVQY23 <= *ZEROS
     C                   Z-ADD     OEQY01        OEQY02
     C                   CLEAR                   OEQY03
      *   Entire quantity shipped...
     C                   WHEN      IVQY23 >= OEQY01
     C                   Z-ADD     OEQY01        OEQY03
     C                   Z-ADD     *ZEROS        OEQY02
      *   Some shipped and some backordered...
     C                   OTHER
     C     OEQY01        SUB       IVQY23        OEQY02
     C                   Z-ADD     IVQY23        OEQY03
     C                   ENDSL
      *.................................................
      * Populate quantities stored at the ordered UOM...
      *.................................................
     C                   CLEAR                   OEQY05
     C                   CLEAR                   OEQY15
     C                   CLEAR                   OEQY16
      *   Make sure order factor is not zero...
     C                   IF        ORDFCT = *ZEROS
     C                   EVAL      ORDFCT = 1
     C                   ENDIF
      *   Backordered...
     C                   IF        OEQY02 <> *ZEROS
     C     OEQY02        DIV       ORDFCT        OEQY15
     C                   ENDIF
      *   Shipped...
     C                   IF        OEQY03 <> *ZEROS
     C     OEQY03        DIV       ORDFCT        OEQY16
     C                   ENDIF
      *   Pricing...
     C                   Z-ADD     OEQY16        OEQY05
      *..........................................
      * If backorders exist
      *    populate b/o fields in order header...
      *..........................................
     C                   IF        OEQY02 <> *ZEROS
     C                   MOVE      'Y'           OEFL10
     C                   ADD       1             OECN05
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Process Components
      *------------------------------------------------------------------------*
     C     PrcComponents BEGSR
      * Set order header combo items exist flag...
     C                   IF        OECD33 <> 'Y'
     C                   EVAL      OECD33 = 'Y'
     C                   ENDIF
      * Save the combo ordered, backordered, and shipped
      * quantities at the stocking UOM...
     C                   EVAL      ComboQY01 = OEQY01
     C                   EVAL      ComboQY02 = OEQY02
     C                   EVAL      ComboQY03 = OEQY03
     C     SL_IVNO07     SETLL     IVFMCMP
     C                   DOU       %EOF(IVLMCMP1)
     C     SL_IVNO07     READE     IVLMCMP1
     C                   IF        %EOF(IVLMCMP1)
     C                   LEAVE
     C                   ENDIF
      * Retrieve the item master...
     C     IVNO16        CHAIN     IVLMSTR8
     C                   IF        %FOUND
      *
      * Load order entry line item fields...
      *
      *   Use API to retrieve the pricing UOM...
      *   NOTE: If ordering uom is populated it will retrieve the
      *       factor for that uom, otherwise it will retrieve
      *       the default ordering uom and factor.
     C                   Z-ADD     IVNO07        PUOMI#
     C                   CLEAR                   PUOMOU
     C                   CALL      'OER9320'     PL9320
     C                   EVAL      OEDN04 = PUOMOU
     C                   EVAL      IVDN02 = PUOMPU
      *
     C                   EVAL      OECD09 = 'G'
     C                   EVAL      OENO09 = OENO09 + 1
     C                   EVAL      OEQY06 = IVQYS5
      * Use the combo quantity at the stocking UOM multiplied by
      * the number of components required for 1 combo to calculate
      * the component ordered, backordered, and shipped quantities...
     C                   EVAL      OEQY01 = ComboQY01 * OEQY06
     C                   EVAL      OEQY02 = ComboQY02 * OEQY06
     C                   EVAL      OEQY03 = ComboQY03 * OEQY06
     C                   EVAL      OEQY05 = OEQY03
      * Components are always ordered at the stocking UOM.
      * So, no conversion is necessary for quantities @ ordered UOM...
     C                   EVAL      OEQY14 = OEQY01
     C                   EVAL      OEQY15 = OEQY02
     C                   EVAL      OEQY16 = OEQY03
      * Cost and price fields will be cleared for now and will
      * be updated later...
     C                   CLEAR                   OEAM01
     C                   CLEAR                   OEAM02
     C                   CLEAR                   OEAM05
     C                   CLEAR                   OEPC01
     C                   CLEAR                   OECD26
     C                   CLEAR                   OECD27
     C                   CLEAR                   OECD28
     C                   CLEAR                   OEAM38
     C                   CLEAR                   OEAM39
     C                   CLEAR                   OEAM40
     C                   CLEAR                   OEAM41
     C                   CLEAR                   OEAM42
      *
      * For components the ordering UOM is always the
      * stocking UOM from the item master...
     C                   EVAL      OEDN04 = IVDN20
      * Get quantity available when order entered and count
      * control number...
     C                   CLEAR                   IVNO14
     C                   EXSR      GetAvail
     C                   EVAL      OEQY07 = IVQY23
      * Clear the line item tag fields because they will
      * be updated later after line comments are processed...
     C                   CLEAR                   OECD30
     C                   CLEAR                   OECN04
      * Get the line control number...
     C                   EXSR      GetLineCtl
      * Write the component to the sales order line item file...
     C                   WRITE     OEFTOL
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *----------------------------------------------------------------
      * Process line comments...
      *
      * Line comments are written to OEPTOT with the line control
      * number (OENO22) for the line item they are associated with.
      *------------------------------------------------------------------------*
     C     PrcLineCmt    BEGSR
     C                   CLEAR                   OECD30
     C                   CLEAR                   OECN04
      * Retrieve line comments from shopping cart and write to
      * order entry line comment file...
     C                   EXSR      LINCOMSR
      * Update tag information in the order entry line item...
     C                   IF        OENO21 > *ZEROS
     C                   CLEAR                   DSPF1
     C                   DOU       NOT %ERROR
     C     TOL9_K1       CHAIN(E)  OELTOL9
     C                   IF        %ERROR
     C                   EXSR      UNLOCK
     C                   ENDIF
     C                   ENDDO
     C                   EVAL      OECN04 = OENO21
     C                   EVAL      OECD30 = 'Y'
     C                   IF        %FOUND(OELTOL9)
     C                   EXCEPT    UpdTag
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *----------------------------------------------------------------
      * Get next line control number
      *------------------------------------------------------------------------*
     C     GetLineCtl    BEGSR
     C                   MOVE      OENO26        PNO26
     C                   Z-ADD     *ZEROS        PNO22
     C                   CALL      'OER9050'     PL9050
     C                   Z-ADD     PNO22         OENO22
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Credit checking
      *------------------------------------------------------------------------*
     C     CREDSR        BEGSR
      * FORMAT WALKIN/CASH ACCOUNT/OVER CREDIT LIMIT MESSAGE
      *
      * CALCULATE "GRACE" LIMIT ALLOWED BEFORE ORDER GOES ON HOLD.
      *
     C                   MOVE      PCTOVR        CRDPCT            4 3
BN    *
BN    * CALL OER9201 TO RETRIEVE CUSTOMER LEVEL GRACE OVERRIDES IF THEY EXIST
BN    *
BN   C                   Call      'OER9201'     PL9201
BN   C                   If        AddOn_OvrPct <> *Zeros
BN   C                   Eval      CRDPCT = AddOn_OvrPct
BN   C                   Endif
      *
      * USE JOB CREDIT LIMIT OR CUSTOMER CREDIT LIMIT ?
      *
     C     USEJOB        IFEQ      'Y'
     C     CRDPCT        MULT      ARAMB5        EXTLMT
     C                   ELSE
     C     CONSOL        IFEQ      'C'                                          CONSOLIDATED
     C     CRDPCT        MULT      CSAM01        EXTLMT
     C                   ELSE                                                   BY COMPANY
     C     CRDPCT        MULT      CBAM01        EXTLMT
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      ' '           HLDORD            1
     C                   Z-ADD     *ZEROS        $OVR                           RESET
      *
      *  SET ACCOUNT ON HOLD FLAG USING AR09 POSITION 1
      *
     C     CONSOL        IFEQ      'A'
     C                   MOVE      BALFLG        ARFL03
     C                   ENDIF
      *
     C     ARCD21        IFNE      'C'
     C     ARFL03        ANDNE     'Y'
     C                   MOVE      OECD03        OE#NTY
     C                   MOVE      OECD03        OE#OTY
     C                   MOVE      CH_OECD03     CO#TYP
      *
      * CREDIT CHECKING
      *
      *
     C     GOODJB        IFEQ      'Y'
     C                   MOVE      OENO06        PMNO06
     C                   ELSE
     C                   MOVE      *BLANKS       PMNO06
     C                   END
      *
     C                   CALL      'OER9200'     PL9200
      *
      * END SUBROUTINE IF ANY ERRORS FOUND DURING CREDIT CHECKING
      *
     C                   Z-ADD     0             ZZ
     C     'Y'           SCAN      ER9200        ZZ                1 0
     C     ZZ            CABGT     *ZERO         ENDCRD
      *
      * HOW FAR OVER THE CREDIT LIMIT IS THE CUSTOMER ?
      *
     C     USEJOB        IFEQ      'Y'
     C                   Z-SUB     JAVAIL        $OVR
     C                   ELSE
     C                   Z-SUB     CAVAIL        $OVR
      *
      * CALCULATE ENTERPRISE GRACE AMOUNT & OVERAGE (IF ANY)
      *
     C     CONSOL        IFEQ      'C'                                          CONSOLIDATED
     C     CRDPCT        MULT      ARAMC6        ELIMIT
     C                   ELSE                                                   BY COMPANY
     C     CRDPCT        MULT      EBAM01        ELIMIT
     C                   ENDIF
     C                   Z-SUB     EAVAIL        EOVR
      *
      * IF CUSTOMER IS NOT OVER, AND ENTERPRISE IS - USE ENTERPRISE
      *
     C     $OVR          IFLE      EXTLMT
     C     EOVR          ANDGT     ELIMIT
     C                   Z-ADD     EOVR          $OVR
     C                   Z-ADD     ELIMIT        EXTLMT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ENDCRD        TAG
      *
      * DETERMINE IF SALES ORDER SHOULD BE HELD DUE TO CREDIT PROBLEMS
      * ORDERS ONLY (NO CREDIT/DEBIT OR QUOTES)
      *
     C     OECD08        IFEQ      'O'
     C     OECD03        IFEQ      'C'                                          CASH ORDER
      *
     C     ARFL03        IFEQ      'Y'                                          CREDIT HOLD
     C     CRHOLD        ANDEQ     'Y'                                          FORCE HOLD
     C     CRCASH        ANDNE     'Y'                                          NO CASH S/O
     C                   MOVE      'Y'           HLDORD                         HOLD ORDER
     C                   ENDIF
      *
     C     OLHOLD        IFEQ      'Y'                                          LIMIT HOLD
     C     $OVR          ANDGT     EXTLMT                                       OVER GRACE
     C     OLCASH        ANDNE     'Y'                                          NO CASH S/O
     C                   MOVE      'Y'           HLDORD                         HOLD ORDER
     C                   ENDIF
      *
     C                   ELSE                                                   NOT CASH ORD
      *
     C     ARFL03        IFEQ      'Y'                                          CREDIT HOLD
     C     CRHOLD        ANDEQ     'Y'                                          FORCE HOLD
     C                   MOVE      'Y'           HLDORD                         HOLD S/O
     C                   ENDIF
      *
     C     OLHOLD        IFEQ      'Y'                                          LIMIT HOLD
     C     $OVR          ANDGT     EXTLMT                                       OVER GRACE
     C                   MOVE      'Y'           HLDORD                         HOLD ORDER
     C                   ENDIF
      *
     C                   ENDIF                                                  END CASH CHK
     C                   ENDIF                                                  END CASH CHK
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Change line item status
      *
      * This subroutine is executed when it has been determined that
      * an order needs to be placed on credit hold.
      * It will change the status of all line items to 'pending'.
      *------------------------------------------------------------------------*
     C     ChgLinSts     BEGSR
      *..............................................
      * Change the status in all of the line items...
      *..............................................
     C     OENO01        SETLL     OELTOL9
     C                   DOU       %EOF(OELTOL9)
     C                   CLEAR                   DSPF1
     C                   DOU       NOT %ERROR
     C     OENO01        READE(E)  OELTOL9
     C                   IF        %ERROR
     C                   EXSR      UNLOCK
     C                   ENDIF
     C                   ENDDO
     C                   IF        not %EOF(OELTOL9)
     C                   EVAL      OECD04 = 'N'
     C                   EXCEPT    UpdSts
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Change the order status
      *
      * This subroutine is executed when it has been determined that
      * a credit card order can't be fully shipped.
      * It will change the order status to 'reserved' and update the
      * status in all of the line items.
      *------------------------------------------------------------------------*
     C     ChgStsRes     BEGSR
      *..............................................
      * Change the status in all of the line items...
      *..............................................
     C     OENO01        SETLL     OELTOL9
     C                   DOU       %EOF(OELTOL9)
     C                   CLEAR                   DSPF1
     C                   DOU       NOT %ERROR
     C     OENO01        READE(E)  OELTOL9
     C                   IF        %ERROR
     C                   EXSR      UNLOCK
     C                   ENDIF
     C                   ENDDO
     C                   IF        not %EOF(OELTOL9)
     C                   EVAL      OECD04 = 'K'
     C                   EXCEPT    UpdSts
     C                   ENDIF
     C                   ENDDO
      *................................
      * Populate order header fields...
      *................................
      * Status...
     C                   EVAL      OECD04 = 'K'
      * Ship order complete...
     C                   EVAL      OECD65 = 'Y'
      * Ship combo complete...
     C                   EVAL      OEFL17 = 'Y'
      * Retain backorders...
     C                   EVAL      OECD76 = 'Y'
      * Print invoice...
     C                   EVAL      OEFL02 = 'N'
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Process other charges
      *
      * If a shipping/handling amount was passed in write an other
      * charges record and populate order header other charges fields.
      * fields.
      *------------------------------------------------------------------------*
     C     PrcOtherChgs  BEGSR
       exec sql
            select type, amount, description into :octype, :pishphdlg,
            :oc_oedn03
            from  GMPXMLHEC
             where transmission_id=:piCartid;
     C                   IF        piShpHdlg <> *ZEROS
     C                   EVAL      OC_OENO01 = OENO01
     C                   EVAL      OC_ARNO01 = ARNO01
     C                   EVAL      OC_ARNO15 = ARNO15
     C                   Z-ADD     piShpHdlg     OC_OEAM03
     C                   MOVE      'N'           OC_OEFL08
     C                   MOVE      'N'           OC_OEFL12
     C                   MOVE      'F'           OC_OECD06
     C                   if        oc_oedn03 = ' '
     C                   EVAL      OC_OEDN03 = 'Shipping/Handling'
     C                   endif
     C                   MOVEL     SH_OENM17     OC_OENM01
     C                   Z-ADD     CURDAT        OC_DATE02
     C                   IF        not %OPEN(OEPTOR)
     C                   OPEN      OEPTOR
     C                   ENDIF
     C                   WRITE     OEFTOR
     C                   MOVE      'Y'           OEFL09
     C                   ADD       OC_OEAM03     OETL03
     C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Get tax percent
      *  Check arpmtbz
      *------------------------------------------------------------------------*
     C     TAXSR         BEGSR
      * Initialize tax percent if order is non-taxable...
     C     OEFL08        IFNE      'Y'                                          TAXABLE FLAG
     C                   Z-ADD     *ZEROS        OEPC02                         TAX RATE
     C                   MOVE      'N'           OEFL08                         TAXABLE FLAG
     C                   ENDIF
      * Get GST/HST tax information...
     C                   EXSR      GHTXSR
      * Retrieve tax percent if the order is taxable...
     C     OEFL08        IFEQ      'Y'
     C                   IF        not %OPEN(ARLMTXS1)
     C                   OPEN      ARLMTXS1
     C                   ENDIF
     C     OENO24        CHAIN     ARLMTXS1
     C                   IF        %FOUND
     C                   Z-ADD     ARPC04        OEPC02                         TAX RATE
     C                   ELSE
     C                   Z-ADD     *ZEROS        OEPC02                         TAX RATE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Get GST/HST tax information
      *------------------------------------------------------------------------*
     C     GHTXSR        BEGSR
     C     USEGST        IFEQ      'Y'
     C                   MOVE      'AR17'        TBNO01
     C                   CLEAR                   TBNO02
     C                   MOVEL     'GR'          TBNO02
     C                   MOVE      OENO24        TBNO02
     C     TABKEY        CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   MOVEL     TBNO03        OEPC08
     C                   MOVE      'H'           OECD86
     C                   ELSE
     C                   MOVEL     GSTPCT        OEPC08
     C                   MOVE      'G'           OECD86
     C                   ENDIF
     C     ARCDB9        IFEQ      'Y'                                          GST EXEMPT
     C                   CLEAR                   OEPC08
     C                   CLEAR                   OECD86
     C                   ENDIF
     C                   ELSE
     C                   CLEAR                   OEPC08
     C                   CLEAR                   OECD86
     C                   ENDIF
     C                   ENDSR
      *----------------------------------------------------------------
      * Process body comments...
      *
      * For body comments a line is written to OEPTOL with a line item
      * type of C=Body Comment and a blank product number.  The actual
      * comments are written to OEPTOT which ties back to OEPTOL by
      * order number and line control number.
      *------------------------------------------------------------------------*
     C     PrcBodyCmt    BEGSR
     C                   IF        not %OPEN(OEPTOT)
     C                   OPEN      OEPTOT
     C                   ENDIF
     C                   MOVEL     piBodyCmts    BodyCmts
AL   C                   IF        B2C
AL   C                   MOVEL     SH_OEAD04     OENM01
AL   C                   ELSE
     C                   MOVEL     SH_OENM17     OENM01
AL   C                   ENDIF
     C                   EXSR      GetLineCtl
     C                   CLEAR                   OENO21
      *
     C     BC01          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC01          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     BC02          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC02          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     BC03          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC03          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     BC04          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC04          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     BC05          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC05          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     BC06          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC06          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     BC07          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC07          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     BC08          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC08          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     BC09          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC09          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     BC10          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC10          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     BC11          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     BC11          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C                   MOVE      'C'           OECD09
     C                   MOVE      'Y'           OECD30
     C                   ADD       1             OENO09
     C                   Z-ADD     OENO21        OECN04
     C                   CLEAR                   IVNO04
     C                   WRITE     OEFTOL
      *
     C                   ENDSR
      *----------------------------------------------------------------
      * Process special instructions
      *------------------------------------------------------------------------*
     C     PrcSpecInst   BEGSR
     C                   IF        not %OPEN(OEPTOM)
     C                   OPEN      OEPTOM
     C                   ENDIF
     C                   MOVEL     piSpecInst    SPCINS
AL   C                   IF        B2C
AL   C                   MOVEL     SH_OEAD04     OENM01
AL   C                   ELSE
     C                   MOVEL     SH_OENM17     OENM01
AL   C                   ENDIF
     C                   MOVE      '3'           OECD11
      *
     C     SILIN1        IFNE      *BLANKS
     C                   MOVE      1             OENO17
     C                   MOVE      SILIN1        OEDN02
     C                   WRITE     OEFTOM
     C                   ENDIF
      *
     C     SILIN2        IFNE      *BLANKS
     C                   MOVE      2             OENO17
     C                   MOVE      SILIN2        OEDN02
     C                   WRITE     OEFTOM
     C                   ENDIF
      *
     C     SILIN3        IFNE      *BLANKS
     C                   MOVE      3             OENO17
     C                   MOVE      SILIN3        OEDN02
     C                   WRITE     OEFTOM
     C                   ENDIF
      *
     C     SILIN4        IFNE      *BLANKS
     C                   MOVE      4             OENO17
     C                   MOVE      SILIN4        OEDN02
     C                   WRITE     OEFTOM
     C                   ENDIF
      *
     C     SILIN5        IFNE      *BLANKS
     C                   MOVE      5             OENO17
     C                   MOVE      SILIN5        OEDN02
     C                   WRITE     OEFTOM
     C                   ENDIF
      *
     C     SILIN6        IFNE      *BLANKS
     C                   MOVE      6             OENO17
     C                   MOVE      SILIN6        OEDN02
     C                   WRITE     OEFTOM
     C                   ENDIF
      *
     C                   ENDSR
      *----------------------------------------------------------------
      * Process order comments
      *------------------------------------------------------------------------*
     C     srComments    Begsr
     C                   IF        not %OPEN(OEPTOM)
     C                   OPEN      OEPTOM
     C                   ENDIF
     C**                 MOVEL     SH_OENM17     OENM01
     C                   eval      oecd11 = '2'                                 Display on ord/inv
     C                   eval      oeno17 +=1
      *
     C                   eval      oedn02 = errmsg
     C                   eval      oenm01 = pgmname
     C                   write     oeftom
      *
     C                   endsr
      *----------------------------------------------------------------
      * Compute billing period
      *------------------------------------------------------------------------*
     C     BILSR         BEGSR
      * GET PERIOD FOR DATE
      * USE SHIPPING DATE IF ENTERED, OTHERWISE USE DATE ORDERED
     C     DATE06        IFNE      0
     C                   Z-ADD     DATE06        DTFMT1
     C                   ELSE
     C                   Z-ADD     DATE05        DTFMT1
     C                   ENDIF
      *
     C                   Z-ADD     1             DTFUNC
     C                   Z-ADD     1             DTFRMT
     C                   CALL      'OPR0810'     PL0810
     C                   Z-ADD     PDFMT2        BILCYM
      * IF THE BILLING PERIOD IS LESS THAN THE CURRENT A/R PERIOD THEN
      * USE THE CURRENT A/R PERIOD AS THE BILLING PERIOD.
      *
     C     BILCYM        IFLT      CRARPD
     C                   Z-ADD     CRARPD        BILCYM                                     PRD
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Get the next available order number
      *------------------------------------------------------------------------*
     C     NextOrd       BEGSR
     C                   CALL      'OER9310'
     C                   PARM                    OENO01
     C                   PARM                    Company
     C                   PARM                    Customer
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Send credit hold message
      *------------------------------------------------------------------------*
     C     SndCrdMsg     BEGSR
      *
     C                   MOVEL     'MSG'         WRKFLD            6
     C                   MOVE      OENO08        WRKFLD
     C                   MOVE      'OE90'        TBNO01
     C                   MOVE      *BLANKS       TBNO02                         TABLE ENTRY
     C                   MOVEL     WRKFLD        TBNO02                         TABLE ENTRY
     C                   MOVEA     *BLANKS       USR
      *
     C     TABKEY        CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   MOVEA     TBNO03        USR
     C                   ELSE
     C                   MOVE      *BLANKS       TBNO02                         TABLE ENTRY
     C                   MOVEL     'MSGDFT'      TBNO02
     C     TABKEY        CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   MOVEA     TBNO03        USR
     C                   ENDIF
     C                   ENDIF
      *
     C     USR(1)        IFNE      *BLANKS
     C     USR(2)        ORNE      *BLANKS
     C     USR(3)        ORNE      *BLANKS
      *
     C                   Z-ADD     1             E                 1 0
      *
     C     E             DOWLT     4
      *
     C     USR(E)        IFEQ      *BLANKS
     C                   ADD       1             E
     C                   ITER
     C                   ENDIF
      *
     C                   MOVEL     USR(E)        CRDMGR           10
      *
      * VALIDATE THE USER PROFILE, IF INVALID THEN LET QSYSOPR KNOW
      *
     C                   MOVE      ' '           INVLID            1
     C                   CALL      'OPC0026'
     C                   PARM                    CRDMGR
     C                   PARM                    INVLID
      * IF "Y" - PROFILE NOT SET UP ON AS/400.
      * IF "E" - PROFILE NAME HAS INVALID CHARACTERS.
     C     INVLID        IFEQ      'Y'
     C     INVLID        OREQ      'E'
     C                   MOVEA     CRDMGR        INV(42)
     C                   MOVEA     INV           INVMSG          120
     C                   Z-ADD     120           LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    INVMSG                         COMMAND
     C                   PARM                    LEN                            LENGTH
      *
     C                   ELSE
      *
      * REPLACE ANY APOSTROPHE IN CUSTOMER NAME TO PREVENT CPF ERROR
      *
     C     '''':'`'      XLATE     OENM15        MSGNAM
      *
     C                   MOVEA     OENO01        CRM(35)
     C                   MOVEA     MSGNAM        CRM(56)
     C                   MOVEA     CRDMGR        CRM(99)
     C                   MOVEA     CRM           CRMSG           138
     C                   Z-ADD     138           LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CRMSG                          COMMAND
     C                   PARM                    LEN                            LENGTH
     C                   ENDIF
      *
     C                   ADD       1             E
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Initializations
      *------------------------------------------------------------------------*
     C     INITSR        BEGSR
ds    *.......................................
ds    * Get the shopping cart header record...
ds    *.......................................
ds   C     piCartId      CHAIN     AILTSCH1
ds   C                   IF        not %FOUND(AILTSCH1)
ds   C                   EVAL      poErrCd = '1'
ds   C                   EVAL      poErrMsg = 'Unable to obtain +
ds   C                             shopping cart header.'
ds   C                   LEAVESR
ds   C                   ENDIF
ds   C     piCartId      CHAIN     AIFCSCH
ds   C                   IF        not %FOUND
ds   C                   LEAVESR
ds   C                   ENDIF
ds   C                   Time                    @W_Time                         Get current time
ds   C                   eval      Isodate = %date()
ds   C                   MoveL     IsoDate       @W_CurDate                      Curr date, CCYYMMDD
ds   C                   Eval      @W_User = usrnm
BF    * Is the order coming from Web Builder ?
BF   C                   if        WB = %subst(piVer:1:2)
BF   C                   eval      WBFlag = 'Y'
BF   C                   eval      WBOrderStatus = %subst(piVer:4:1)
BF   C                   endif
     C                   EVAL      poErrCd = '0'
     C                   EVAL      poErrMsg = *BLANKS
   dsC*                  MOVE      piCustomer    Customer
ds   C                   eval      customer = sh_arno01
     C                   MOVEL     piUserID      UserProfile
   dsC*                  MOVE      piShipBr      ShipBr
      *.......................................
      * Populate fields based on B2B or B2C...
      *.......................................
     C                   CLEAR                   Company
     C                   CLEAR                   SellBr
     C                   CLEAR                   OrderBy
     C                   CLEAR                   SalesId
     C                   CLEAR                   OENO08
     C                   CLEAR                   ARNO15
     C                   CLEAR                   OENM16
     C                   CLEAR                   ARID01
     C                   SELECT
      *........................
      * Business to Business...
      *........................
     C                   WHEN      piApp = 'B2B'
     C                   EVAL      B2B = *ON
      *   Load the tax jurisdiction...
     C                   IF        piTaxJur <> *blanks
     C                   MONITOR
     C                   MOVE      piTaxJur      taxJur
     C                   ON-ERROR
     C                   EVAL      taxJur = *ZEROS
     C                   ENDMON
     C                   ENDIF
      *   Check for web user...
     C                   IF        not %OPEN(AILMUSR1)
     C                   OPEN      AILMUSR1
     C                   ENDIF
     C     USR1_K1       CHAIN     AILMUSR1
     C                   IF        %FOUND(AILMUSR1)
     C                   EVAL      SellBr = OENO08
     C                   EVAL      Company = ARNO15
     C                   EVAL      OrderBy = OENM16
     C                   EVAL      SalesId = ARID01
     C                   EVAL      OrdMsgPrf = OENM01
     C                   EVAL      SrcOfSale = OECD17
     C                   EVAL      SaleType = OECD19
     C                   IF        not CreditCard
     C                   EVAL      DftOrdSts = OECD89
     C                   ENDIF
      *   Check for branch personnel...
     C                   ELSE
     C                   EVAL                    WBFL09 = 'Y'
     C                   IF        not %OPEN(AILMUBR1)
     C                   OPEN      AILMUBR1
     C                   ENDIF
     C     UBR1_K1       CHAIN     AILMUBR1
     C                   IF        %FOUND(AILMUBR1)
     C                   EVAL      OrderBy = OENM16
     C                   IF        not %OPEN(AILMCUS1)
     C                   OPEN      AILMCUS1
     C                   ENDIF
     C     Customer      CHAIN     AILMCUS1
     C                   IF        %FOUND(AILMCUS1)
     C                   EVAL      SellBr = OENO08
     C                   EVAL      Company = ARNO15
     C                   EVAL      SalesId = ARID01
     C                   EVAL      OrdMsgPrf = OENM01
     C                   EVAL      SrcOfSale = OECD17
     C                   EVAL      SaleType = OECD19
     C                   IF        not CreditCard
     C                   EVAL      DftOrdSts = OECD89
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
ds    * Load values from header
ds   C                   eval      company = 1
ds   C                   eval      sellbr  = sh_oeno08
ds   C                   if        not %open(arlmbch4)
ds   C                   open      arlmbch4
ds   C                   endif
ds   C     sellbr        chain     arfmbch
ds   C                   if        %found
ds   C                   eval      company =  arno15
ds   C                   endif
ds   C                   eval      orderby =  'B2B'
ds   C                   eval      salesid =  'B2B'
ds   C                   eval      shipbr    = ch_oeno16
ds   C                   eval      piShAddr1 = ch_arad10
ds   C                   eval      piShAddr2 = ch_arad11
ds   C                   eval      piShAddr3 = ch_arad12
ds   C                   eval      piShCity  = ch_arcy04
ds   C                   eval      piShState   = ch_arst04
ds   C                   eval      piShZip     = ch_arzp18
ds   C                   eval      piShipCode = ch_oecd01
ds   C                   eval      piShipDesc = ch_oedn01
ds   C                   eval      piPhone    = %char(ch_arno07) +
ds   C                             %char(ch_arno08) + %char(ch_arno09)
ds   C                   eval      piTaxJur = %char(ch_oeno24)
      *........................
      * Business to Customer...
      *........................
     C                   WHEN      piApp = 'B2C'
     C                   EVAL      B2C = *ON
     C                   IF        not %OPEN(AILMRCF1)
     C                   OPEN      AILMRCF1
     C                   ENDIF
     C     RCF1_K1       CHAIN     AILMRCF1
     C                   IF        %FOUND(AILMRCF1)
     C                   EVAL      SellBr = OENO08
     C                   EVAL      Company = ARNO15
     C                   EVAL      SalesId = ARID01
     C                   EVAL      OrdMsgPrf = OENM17
     C                   EVAL      SrcOfSale = OECD17
     C                   EVAL      SaleType = OECD19
     C                   ENDIF
     C                   IF        not %OPEN(AILMRCS1)
     C                   OPEN      AILMRCS1
     C                   ENDIF
     C     piUserID      CHAIN     AILMRCS1
     C                   IF        %FOUND(AILMRCS1)
     C                   EVAL      OrderBy = ARNM02
     C                   ENDIF
AI    *........................
AI    * Internal Mobile App...
AI    *........................
AI   C                   WHEN      piApp = 'IMO'
AI   C                   EVAL      IMO = *ON
AI    *   Load the tax jurisdiction...
AI   C                   IF        piTaxJur <> *blanks
AI   C                   MONITOR
AI   C                   MOVE      piTaxJur      taxJur
AI   C                   ON-ERROR
AI   C                   EVAL      taxJur = *ZEROS
AI   C                   ENDMON
AI   C                   ENDIF
AI    *   Get TIDS defaults for the user
AI   C*                  EVAL      Tbno01 = 'TIDS'
AI   C*                  EVAL      Tbno02 = PiUserId
AI   C*    TabKey        CHAIN     TBLMTBL1
AI   C*                  IF        %found(TBLMTBL1)
AI    *   Selling Branch
AI   C*                  IF        %subst(Tbno03:1:3) <> *blanks
AI   C*                  MONITOR
AI   C*                  EVAL      SellBr = %int(%subst(Tbno03:1:3))
AI   C*                  ON-ERROR
AI   C*                  EVAL      SellBr = *ZEROS
AI   C*                  ENDMON
AI   C*                  ENDIF
AI    *   Company
AI   C*                  IF        %subst(Tbno03:4:3) <> *blanks
AI   C*                  MONITOR
AI   C*                  EVAL      Company = %int(%subst(Tbno03:4:3))
AI   C*                  ON-ERROR
AI   C*                  EVAL      Company = *ZEROS
AI   C*                  ENDMON
AI   C*                  ENDIF
AI    *   Sales Type
AI   C*                  EVAL      SaleType = %subst(Tbno03:29:1)
AI   C*                  ENDIF
AI    *   Order By
AI   C                   IF        not %OPEN(AILMUBR1)
AI   C                   OPEN      AILMUBR1
AI   C                   ENDIF
AI   C                   EVAL                    WBFL09 = 'Y'
AI   C     UBR1_K1       CHAIN     AILMUBR1
AI   C                   IF        %FOUND(AILMUBR1)
AI   C                   EVAL      OrderBy = OENM16
AI   C                   ENDIF
AI    *   Sales rep id
AI   C                   IF        not %OPEN(OPLMUPM1)
AI   C                   OPEN      OPLMUPM1
AI   C                   ENDIF
AI   C     UserProfile   CHAIN     OPLMUPM1
AI   C                   IF        %found(OPLMUPM1)
AI   C                   EVAL      SalesId = OPID12
AI   C                   ENDIF
AI    *
AI   C                   EVAL      SrcOfSale = 'O'
AI   C                   EVAL      OrdMsgPrf = UserProfile
AI   C                   IF        not CreditCard
AI   C                   EVAL      DftOrdSts = 'P'
AI   C                   ENDIF
     C                   ENDSL
BF    * Default order status to Web Builder Config Order status
BF   C                   IF        not CreditCard
BF   C                             and WBFlag = 'Y'
BF   C                   EVAL      DftOrdSts = WBOrderStatus
BF   C                   ENDIF
      *............................................................
      * If we were unable to obtain all of the required information
      * then set the error code and message to be returned...
      *............................................................
     C                   SELECT
     C                   WHEN      SellBr = *ZEROS
     C                   EVAL      poErrCd = '1'
     C                   EVAL      poErrMsg = 'Unable to obtain +
     C                             selling branch.'
     C                   LEAVESR
     C                   WHEN      OrderBy = *BLANKS
BD   C                             and piApp <> 'CRB'
     C                   EVAL      poErrCd = '1'
     C                   EVAL      poErrMsg = 'Unable to obtain +
     C                             ordered by name.'
     C*                  LEAVESR
     C                   WHEN      Company = *ZEROS
     C                   EVAL      poErrCd = '1'
     C                   EVAL      poErrMsg = 'Unable to obtain +
     C                             company number.'
     C                   LEAVESR
     C                   WHEN      SalesId = *BLANKS
     C                   EVAL      poErrCd = '1'
     C                   EVAL      poErrMsg = 'Unable to obtain +
     C                             salesperson ID.'
     C                   LEAVESR
     C                   ENDSL
      *............................
      * Load default values, etc...
      *............................
     C                   Z-ADD     1             ORDFCT
      * Retrieve print component detail defaults...
     C                   MOVE      'OE40'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'DETAIL'      TBNO02
     C     TABKEY        CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   MOVEL     TBNO03        PRTDET
     C                   ELSE
     C                   MOVE      'YY'          PRTDET
     C                   ENDIF
      *   Default 'Y' if blank or not valid...
     C     PTCD83        IFNE      'N'
     C                   MOVE      'Y'           PTCD83
     C                   ENDIF
      *
     C     INVC83        IFNE      'N'
     C                   MOVE      'Y'           INVC83
     C                   ENDIF
      *
      * See what add-ons are being used...
      *
     C                   MOVE      'ADON'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'ADDON'       TBNO02
     C     TABKEY        CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   MOVEL     TBNO03        ADONS
     C                   ELSE
     C                   MOVE      *ALL'N'       ADONS
     C                   ENDIF
      * GET CREDIT LIMIT SETTING - COMPANY OR CONSOLIDATED
      ** A = CREDIT LIMIT BY COMPANY (FROM BALANCE RECORD)
      ** C = CREDIT LIMIT BY CUSTOMER (FROM CUSTOMER/ENTERPRISE RECORD)
     C                   MOVE      'AR09'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'MAINT'       TBNO02
     C     TABKEY        CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   MOVEL     TBNO03        CONSOL            1
     C                   ENDIF
     C     CONSOL        IFNE      'A'
     C     CONSOL        ANDNE     'C'
     C                   MOVEL     'C'           CONSOL
     C                   ENDIF
      * Retrieve Baker's B2B default setting
     C                   eval      tbno01 = 'CB2B'
     C                   eval      tbno02 = 'PURSGC'
     C     tabkey        chain     tbfmtbl
     C                   if        %found
     C                   eval      cIvcd17 = %subst(tbno03:1:3)
     C                   eval      cIvcd18 = %subst(tbno03:4:3)
     C                   eval      cIvcd19 = %subst(tbno03:7:3)
     C                   endif

     C                   eval      tbno02 = 'CONFIRMTO'
     C     tabkey        chain     tbfmtbl
     C                   if        %found
     C                   eval      cConfirm = %subst(tbno03:1:20)
     C                   endif

     C                   eval      tbno02 = 'BUYERID'
     C     tabkey        chain     tbfmtbl
     C                   if        %found
     C                   eval      cBuyerid = %subst(tbno03:1:3)
     C                   endif

      * PO Ship Via Description
     C                   eval      tbno02 = 'SHIPVIA'
     C     tabkey        chain     tbfmtbl
     C                   if        %found
     C                   eval      cShipVia= %subst(tbno03:1:15)
     C                   endif

      * Non direct sales order status
     C                   eval      tbno02 = 'NDORDSTS'
     C     tabkey        chain     tbfmtbl
     C                   if        %found
     C                   eval      cNDordsts= %subst(tbno03:1:1)
     C                   endif

      * Validate order status
     C                   if        cNDordsts <> 'O' and cNDordsts <> 'K'
     C                             and cNDordsts <> 'N'
     C                   eval      cNDordsts = 'O'
     C                   endif

      * Non direct default pickup code
     C                   eval      tbno02 = 'PICKUPC'
     C     tabkey        chain     tbfmtbl
     C                   if        %found
     C                   eval      cPickupCode = %subst(tbno03:1:2)
     C                   endif

      * Email sales order ack?
     C                   eval      tbno02 = 'ESLSACK'
     C     tabkey        chain     tbfmtbl
     C                   if        %found
     C                   eval      cESLSACK  = %subst(tbno03:1:1)
     C                   endif
      * Check EDI
     C                   eval      tbno01 = 'EDI'
     C                   eval      tbno02 = 'EDI     Y'
     C     TABKEY        SETLL     TBFMTBL
     C                   if        %equal
     C                   MOVE      'Y'           EDION             1            SET WRKFLD
     C                   endif
      *
     C                   EVAL      OENO06 = sh_oeno06
     C                   EVAL      OECD01 = ch_oecd01
     C                   EVAL      ARCDC6 = ch_arcdc6
     C                   EVAL      OEDN01 = ch_oedn01
     C                   if        ch_oecd01 = 'P'
     C     ShpCodeKY     chain     oefmscd
     C                   if        %found
     C                   EVAL      OEDN01 = SC_OEDN01
     C                   else
     C                   eval      arcdc6=cPickupCode
     C                   endif
     C                   endif
   AKC*                  EVAL      ARCDC6 = piShipCode
      * Check for warehouse branch...
     C                   CLEAR                   COBR
     C                   CLEAR                   WHMBR
AF   C                   if        WMSYS = 'Y'
     C                   Z-ADD     ShipBr        BRNBR
     C                   CALL      'WIC0116'
     C                   PARM                    COBR
     C                   PARM                    WHMBR             1
     C     WHMBR         IFEQ      'Y'
     C                   MOVE      'Y'           ANYWM             1
     C                   ELSE
     C                   MOVE      'N'           ANYWM
     C                   ENDIF
AF   C                   endif
AJ    *
AJ    * Based on card software JCHARGE OR CURBSTONE,
AJ    * check appropriate software library and program object.
AJ   C                   clear                   ONLINE
AJ   C                   clear                   flag
AJ   C                   clear                   card_software
AJ   C                   clear                   tbno02
AJ   C                   move      'AR27'        tbno01
AJ   C                   movel     'CARD'        tbno02
AJ   C     tabkey        chain     tblmtbl1
AJ   C                   If        %found(tblmtbl1)
AJ   C                   movel     tbno03        card_tabentry
AJ BGC*                  If        using_card = 'Y' and
AJ BGC*                            card_software = 'CURBSTONE'
AJ    *
BG   C                   If        using_card = 'Y'
BG    * Check if using interface for card transactions
BG   C                   if        card_software = 'CARDCONNECT'
BG   C                   eval      card_interface = 'Y'
BG   C                   clear                   flag
BG   C                   endif
BG    * Check objects required for Curbstone
BG   C                   if        card_software = 'CURBSTONE'
A0   C                   eval      tbno02 = 'CARDLIB'
A0   C     tabkey        chain     tblmtbl1
A0   C                   If        %found(tblmtbl1)
A0   C                   eval      obj = %trim(%subst(tbno03:1:10))
A0   C                   endif
AJ A0C*                  MOVEL     'CURBSTONE'   OBJ              10
AJ   C                   MOVEL     '*LIB   '     OBJ_TYPE         10
AJ   C                   MOVE      ' '           FLAG              1
AJ   C                   CALL      'OPC0028'
AJ   C                   PARM                    OBJ
AJ   C                   PARM                    OBJ_TYPE
AJ   C                   PARM                    FLAG
AJ    *
AJ   C     FLAG          IFEQ      ' '
AJ   C                   CLEAR                   OBJ
AJ   C                   MOVEL     'OER9600'     OBJ
AJ   C                   MOVEL     '*PGM   '     OBJ_TYPE
AJ   C                   MOVE      ' '           FLAG
AJ   C                   CALL      'OPC0028'
AJ   C                   PARM                    OBJ
AJ   C                   PARM                    OBJ_TYPE
AJ   C                   PARM                    FLAG
AJ   C                   ENDIF
BG   C                   endif
AJ   C     FLAG          IFEQ      ' '
AJ   C                   MOVE      'Y'           ONLINE            1
AJ   C                   ENDIF
AJ   C                   ENDIF
AJ   C                   ENDIF
AJ    *
     C                   movel     uyear         wrkcc
      *
      *
     C                   ENDSR
      *------------------------------------------------------------------*
      * SUBROUTINE TO PROCESS RECORD LOCKS
      *------------------------------------------------------------------*
     C     UNLOCK        BEGSR
     C                   CLEAR                   DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   ENDSR
      *------------------------------------------------------------------*
      * SUBROUTINE TO LINE COMMENTS
      *------------------------------------------------------------------*
     C     LINCOMSR      BEGSR
BD   C                   IF        CRB
BD   C                   CLEAR                   OENO21
BD   C     SCT1_K1       SETLL     AILTSCT1
BD   C                   DOU       %EOF(AILTSCT1)
BD   C     SCT1_K1       READE     AILTSCT1
BD   C                   IF        not %EOF(AILTSCT1)
BD   C                   ADD       1             OENO21
BD   C                   MOVEL     ST_OEDN05     OEDN05
BD   C                   WRITE     OEFTOT
BD   C                   ENDIF
BD   C                   ENDDO
BD   C                   ELSE
      * line comment file...
     C                   move      'Y'           FSTLN             1
AD   C                   clear                   LineCmts
     C     SCT1_K1       SETLL     AILTSCT1
     C                   DOU       %EOF(AILTSCT1)
     C     SCT1_K1       READE     AILTSCT1
     C                   IF        not %EOF(AILTSCT1)
     C                   IF        FSTLN = 'Y'
     C                   EVAL      FSTLN = 'N'
     C                   EVAL      LineCmts = ST_OEDN05
     C                   ELSE
     C                   EVAL      LineCmts = %trimr(LineCmts) + ST_OEDN05
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   CLEAR                   OENO21
     C     LC01          IFNE      *BLANKS
     C                   IF        not %OPEN(OEPTOT)
     C                   OPEN      OEPTOT
     C                   ENDIF
     C                   ADD       1             OENO21
     C                   MOVEL     LC01          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     LC02          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     LC02          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     LC03          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     LC03          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     LC04          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     LC04          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     LC05          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     LC05          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     LC06          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     LC06          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     LC07          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     LC07          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     LC08          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     LC08          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     LC09          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     LC09          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     LC10          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     LC10          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
      *
     C     LC11          IFNE      *BLANKS
     C                   ADD       1             OENO21
     C                   MOVEL     LC11          OEDN05
     C                   WRITE     OEFTOT
     C                   ENDIF
BD   C                   ENDIF
      *
     C                   ENDSR
BD    *------------------------------------------------------------------*
BD    * SUBROUTINE TO GET AGE CODE FOR CREDIT MEMOS
BD    *------------------------------------------------------------------*
BD   C     GETAGE        BEGSR
BD   C                   CLEAR                   PMAGOP
BD   C                   CALL      'ARR0100'     PL0100
BD   C                   MOVEL     PMAGOP        AGEOPT
BD   C                   MOVE      GRP2AD        OECD07
BD   C                   ENDSR
      *------------------------------------------------------------------------*
     C     srCreatePo    begsr
      *------------------------------------------------------------------------*
     C                   clear                   poftoh
     C                   clear                   poftol
      * Get next available PO number
     C                   eval      ponum = 0
     C                   call      'POR0195'
     C                   parm                    ponum
      * Create PO header
     C                   eval      po_err = 'N'
     C                   eval      p_apno01 = ch_apno01
     C     ch_apno01     chain     apfmven
     C                   if        not %found
     C                   eval      po_err = 'Y'
     C                   eval      errmsg  = 'Invalid vendor number'
     C                   exsr      srComments
     C                   endif
     C                   eval      p_pono01 = ponum
     C                   eval      p_pono02 = oeno16
     C                   eval      p_pono03 = oeno08
     C                   eval      p_pono04 = apno07
     C                   eval      p_pono14 = 1
     C                   eval      p_pono16 = oecn01+1
      *
      * If sales order is not direct, change PO to buyout.
     C                   eval      p_pocd01 = 'D'
     C                   if        oecd01 <> 'D'
     C                   eval      p_pocd01 = 'B'                               Buyout
     C                   endif
     C                   eval      p_pocd03 = 'N'                               Cancel BO code
     C                   eval      p_pocd04 = 'P'                               Freight code
     C                   eval      p_pocd05 = 'N'
     C                   eval      p_pocd06 = 'N'
     C                   eval      p_pocd07 = 'N'
     C                   eval      p_pocd09 = 'A'
     C                   eval      p_pocd10 = 'S'
      * Retrieve default ship code
     C                   eval      tbno01 ='IV62'
     C                   eval      tbno02 = p_pocd10
     C     tabkey        chain     tbfmtbl
     C                   if        %found
     C                   eval      p_pocd56 = %subst(tbno03:1:2)
     C                   endif
     C                   eval      p_pocd11 = 'N'
     C                   eval      p_pocd12 = 'N'
     C                   eval      p_pocd18 = 'N'
     C                   eval      p_pocd20 = 'O'
     C                   eval      p_podn02 = cShipVia
     C                   eval      p_ponm01 = pgmname
     C                   eval      p_pocd31 = 'N'
     C                   eval      p_pocd41 = 'H'                                ETA date
     C                   eval      p_pocd42 = 'N'
     C                   eval      podate = sodate
     C                   eval      etadate= sodate
     C                   eval      poentd = sodate
     C                   eval      rvseta = sodate
     C                   eval      p_poid01 = cBuyerid
     C                   eval      p_poid02 ='WEB'
      * If direct, ship to branch = 0
     C                   if        p_pocd01 = 'D'
     C                   eval      p_pono02 = 0
     C                   endif
     C                   eval      p_ponm02 =cConfirm
     C                   eval      p_pono05 = 0
     C     oeno01        setll     oeftol
     C     oeno01        reade     oeftol
     C                   dow       not %eof
     C                   eval      p_ivno07 = ivno07
     C                   eval      p_pono05 +=1
      * Ordered qty
     C                   eval      p_poqy01 = oeqy01
     C                   eval      p_poqyu1 = oeqy01
      * Received qty
     C                   eval      p_poqy03 = 0
      * Price and cost
     C                   eval      p_poam01 = 0                                 List price
     C                   eval      p_poamu1 = 0                                 price at stk uom
     C                   eval      p_poam02 = sl_oeam02                         List cost
     C                   eval      p_poamu2 = sl_oeam02                         cost at stk uom
     C                   eval      p_popc02 = ' '                               discount
     C                   eval      p_pocd16 = 'N'                               discount override
     C                   eval      p_pocd13 = 'S'                               stocked
     C                   eval      p_pocd14 = 'Y'                               tagged
     C                   eval      p_pocd17 = 'N'                               line cost override
     C                   eval      p_pocd19 = 'P'                               Product entered
     C                   eval      p_pocn01 =  0                                line item comment
     C                   eval      p_poqy03=0                                   qty rcvd
     C                   eval      p_podn03 = orduom
      * UOM
     C                   if        oedn04 = ivdn20
     C                   eval      puomsf = 1
     C                   else
     C                   if        oedn04 = ivdn41
     C                   eval      puomsf = ivqyz9                              uom conversion
     C                   else
     C                   eval      auomi# = ivno07
     C                   eval      auomou = puom
     C                   call      'POR0117'     pl0117
     C                   if        auomof <>  0
     C                   eval      puomsf = auomof
     C                   eval      puom   = auompu
     C                   endif
     C                   endif
     C                   endif
     C                   if        puom = ' '
     C                   eval      puom = p_podn03
     C                   endif
     C                   eval      p_podn04 = puom
     C                   eval      p_pono01 = ponum
     C                   eval      p_podn10 = ivno04
     C                   eval      p_ponm01 = pgmname
     C                   eval      p_poqyof = ordfct
     C                   eval      p_poqypf = prcfct
     C                   eval      p_pocd20 = 'O'                               status
     C                   write     poftol
                         pono01 = p_pono01;
                         pono05 = p_pono05;
       update    oeftol %fields(pono01:pono05);
      * Write tag
     C                   eval      t_pono01 = p_pono01
     C                   eval      t_pono05 = p_pono05
     C                   eval      t_pono12 = p_pono05
     C                   eval      t_podn06 = cusnam + ' (A.G.)'
     C                   eval      t_pocd15 = '1'
     C                   eval      t_pono10 = arno01
     C                   eval      t_pono11 = oeno01
     C                   eval      t_poqy02 = oeqy01
     C                   eval      t_oeno01 =oeno26
     C                   eval      t_oeno22 =oeno22
     C                   write     pofttg
      * Calculate extended amounts
     C                   EXSR      PRCEXT
      *
     C     oeno01        reade     oeftol
     C                   enddo

      * Write po header
     C                   eval      p_pono13 = sh_arno01                           Customer
     C                   eval      p_pono18 = 1                                   Revision
     C                   eval      p_pocd05 = 'Y'                                ship to address ovr
     C                   write     poftoh
      * Create new B2B Po...
     C                   eval      totE39 = p_potl01
     C                   eval      orgE39 = 'E'                                 PO Entry = Origin
     C                   eval      byrE39 = p_poid01
     C                   eval      vndE39 = p_apno01
     C                   eval      po#E39 = p_pono01
     C                   eval      cmpE39 = arno15
     C                   eval      divE39 = glcd41
     C                   eval      regE39 = glcd42
     C                   eval      brnE39 = p_pono02
     C                   Call      'SHC5050'
     C                   Parm      'HDE7039'     EventID           7            Event Id
     C                   Parm                    d_HDE7039                      Event Data
      *
     C                   eval      p_pocd02 = 'S'
     C                   eval      p_ponm03 = cusnam
     C                   eval      p_POAD01 =  ch_ARAD10
     C                   eval      p_POAD02 =  ch_ARAD11
     C                   eval      p_POAD03 =  ch_ARAD12
     C                   eval      p_POCY01 =  ch_ARCY04
     C                   eval      p_POST01 =  ch_ARST04
     C                   eval      p_POZP03 =  ch_ARZP18
     C                   write     poftoa
     C                   endsr
      *---------------------------------------------------------------------
      * EXTEND PRICES                                                  *****
      *---------------------------------------------------------------------
     C     PRCEXT        BEGSR
      * Calculate stocking unit price
     C     PRCFCT        IFNE      0
     C     p_POAMU1      DIV(H)    PRCFCT        p_POAM01
     C                   ENDIF
      * Calculate stocking unit cost
     C     PRCFCT        IFNE      *ZEROS
     C     p_POAMU2      DIV(H)    PRCFCT        p_POAM02
     C                   END                                                                   E2
      * Calculate extended cost
     C     p_POQY01      DIV(H)    PRCFCT        $PRQTY           15 5
     C     $PRQTY        MULT(H)   p_POAMU2      $EXCST           15 5
      * Accumulate total cost
     C                   ADD(H)    $EXCST        p_POTL01
     C                   ADD(H)    $EXCST        p_POTL02
      *
     C                   ENDSR
      *---------------------------------------------------------------------
      * Send PO to EDI (logic pulled from POR0110)                     *****
      *---------------------------------------------------------------------
     C     srSendEDI     BEGSR
     C                   move      'N'           edipo             1
     C     EDION         IFEQ      'Y'                                          ALLOW EDI ?
     C                   CLEAR                   TRPNID
     C                   CLEAR                   VNDCUS
     C                   CLEAR                   CUSNBRA
     C                   CLEAR                   VENBRN
     C                   CLEAR                   DOCTYP
     C                   CLEAR                   SUBTYP
     C                   CLEAR                   RCVSTS
     C                   MOVE      'V'           VNDCUS
     C                   MOVEL     APNO01        CUSNBRA
     C                   MOVE      '850'         DOCTYP
     C                   MOVE      P_PONO03      VENBRN
     C                   EXSR      GETTPI
     C                   if        edipo = 'Y'
     C                   MOVE      PONO01        PONO
     C                   MOVE      ' '           YESNO
     C                   MOVE      ' '           REPRNT
     C                   MOVE      '000'         RVPRNT
     C                   MOVEL     TRPNID        @TPID
     C                   MOVEL     APNO01        @ACCT#
     C                   MOVEL     DSPO          @TRANS
     C                   MOVE      *BLANKS       @ERRCD
     C                   CALL      'EIR1200'
     C                   PARM      'S850'        @DOCID            4
     C                   PARM                    @TPID            15
     C                   PARM                    @ACCT#            6
     C                   PARM                    @TRANS           15
     C                   PARM                    @ERRCD            3
     C                   endif
     C                   endif
     C                   ENDSR
      *****************************************************************
      * Get Trading Partner Information using Data Queue
      *****************************************************************
      *
     C     GETTPI        BEGSR
      *
     C                   CALL      'EIR9505'     PL9505
GF   C     CUSNBRA       IFEQ      *ZEROS
GF   C                   MOVE      '1'           RCVSTS
GF   C                   ENDIF
      *
     C     RCVSTS        IFEQ      '0'
     C                   MOVE      *OFF          *IN42
     C                   eval      edipo = 'Y'
     C                   ELSE
     C     RCVSTS        IFNE      '1'
     C                   eval      edipo = 'Y'
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *BLANKS       tbno02
     C                   MOVEL     'EDI '        tbno01                         TABLE CODE
     C                   MOVEL     RCVSTS        tbno01                         TABLE ENTRY
     C                   MOVE      *ON           *IN88
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVE      TBNO03        BYNM01
     C                   MOVE      *ON           *IN42
     C                   ELSE
     C                   MOVE      *ON           *IN42
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN42
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
       Begsr sr_CreateItem;
      *------------------------------------------------------------------------*
           loopcnt +=0;
           item_err = 'N';
           crtitmflg = 'N';                      // Item creation flag
           eval item_found = 'N';

           setll new_ivno04 ivfmirq;             // Check temp item request
           if %equal;
              eval item_found = 'Y';
              eval line_err   = 'Y';
              errmsg = 'Temporary item request found';
              exsr srComments;
           endif;

           if  item_found <> 'Y';                //Only create temp item when item number = 0
               dow item_found = 'Y';
                   i_ivno04='$' + %subst(new_ivno04:1:16);
                   loopcnt +=1;

                   setll i_ivno04 ivfmirq;
                   if not %found;
                      sl_ivno04  = i_ivno04;
                      new_ivno04 = i_ivno04;
                      leave;
                   endif;

                   if loopcnt > itemcntr;      // If looped maxed, exit and mark as error
                      item_err = 'Y';
                      leave;
                   endif;
               enddo;
           endif;

           if line_err <> ' ' ;        // Create new product
           clear newmstr;
           clear ivfmuom;
           clear ivfmwhc;
           clear ivfmrns;
           i_ivnm01 = pgmname;         // Last update user
           i_ivmo01=umonth;            // Last update
           i_ivdy01=uday;
           i_ivcc01=wrkcc;
           i_ivyr01=uyear;

           itmnum = 0;
           dow itmnum = 0;
               callp GetItem(itmnum);  // Retrieve next item number
           enddo;
           new_ivno07 = itmnum;

           if  new_ivno07<> 0 and item_err <> 'Y';
               i_ivno07 = new_ivno07;  //
               i_ivno04 = new_ivno04;  //
               i_ivno05 = ch_apno01;   // Inventory item
               i_ivcdc8 = 'V';         // Verified temporary item
               i_ivcd21 = 'Y';         // Taxable code
               i_ivcd22 = 'N';         // Substitute code
               i_ivcd23 = 'N';         // Associated code
               i_ivcd24 = 'N';         // Component code

               i_ivcd27 = 'N';         // counter book access code
               i_ivcd31 = 'N';         // selling book access code
               i_ivcd32 = 'N';         // purchasing book access code

               if civcd17 <> ' ';      // purchasing section/group/cat from CB2B table
                  i_ivcd32 = 'Y';
                  i_ivcd17 = civcd17;
                  i_ivcd18 = civcd18;
                  i_ivcd19 = civcd19;
               endif;

               i_ivcd36 = 'N';           // extended desc
               i_ivcd56 = 'N';           // alias code
               i_ivdn01 = sl_ivdn01;     // description
               i_ivdn20 = dft_uom;
               i_ivcdin = 'Y'   ;        // inventory item
               write newmstr;

               i_ivqy12 = dft_fct;
               i_ivdn21 = dft_uom;
               i_ivcd08 = 'P';           // Pricing UOM
               i_ivcd91 = 'Y';
               i_ivno69 = 1  ;
               write ivfmuom;

               i_ivqy12 = dft_fct;
               i_ivdn21 = dft_uom;
               i_ivcd08 = 'B';           // Purchasing UOM
               i_ivcd91 = 'Y';
               i_ivno69 = 1  ;
               write ivfmuom;

               i_ivqy12 = dft_fct;
               i_ivdn21 = dft_uom;
               i_ivcd08 = 'O';           // Order entry UOM
               i_ivcd91 = 'Y';
               i_ivno69 = 1  ;
               write ivfmuom;

               w_ivcd08 = 'S';
               setll (i_ivno07:i_ivcd08) ivfmwhc;
               if  not %equal;
                   wmfrm = 'ITM';
                   itm#  = new_ivno07;
                   callp SendWM  (wmfrm:pdata2);
               endif;

               i_ivno10=shipbr;
               i_ivmo04=i_ivmo01;
               i_ivdy04=i_ivdy01;
               i_ivcc04=i_ivcc01;
               i_ivyr04=i_ivyr01;
               write ivfmrns;
               crtitmflg = 'Y';
               else;
                 line_err = 'Y';
                 ord_err  = 'Y';
                 errmsg = 'Error processing product' + new_ivno04;
                 exsr srComments;
               endif;
           endif;

       Endsr;
      *------------------------------------------------------------------------*
       Begsr  srUpdIFSLog;
      *------------------------------------------------------------------------*
       exec sql
            update GMPXMLHT set baker_document=:poOrderNo
             where transmission_id=:ch_wbno29;
       exec sql
            update GMPXMLH  set order_number=:poOrderNo,
                            baker_document=:poOrderNo
             where transmission_id=:ch_wbno29;
       exec sql
            update GMPXMLD  set baker_document=:poOrderNo
             where transmission_id=:ch_wbno29;
       exec sql
            update GMPXMLHBI  set oeno01=:poOrderNo
             where transmission_id=:ch_wbno29;
       exec sql
            update GMPXMLHCI  set oeno01=:poOrderNo
             where transmission_id=:ch_wbno29;
       exec sql
            update GMPXMLHEC  set oeno01=:poOrderNo
             where transmission_id=:ch_wbno29;
       exec sql
            update GMPXMLHTC  set oeno01=:poOrderNo
             where transmission_id=:ch_wbno29;
       exec sql
            update GMPXMLLOG set baker_document=:poOrderNo
             where transmission_id=:ch_wbno29;
       exec sql
            select TRANSMISSION_ID into :tranid from GMPXMLH
             where transmission_id=:ch_wbno29;
       exec sql
            update OEPMEXTI set oeno01=:oeno01
             where extkey1=:ch_wbno29 and oeno01=' ';
       Endsr;
      *------------------------------------------------------------------------*
       Begsr srUpdHeader;
      *------------------------------------------------------------------------*
       exec sql                                      // Place order on problem hold
            update Oeptoh set oefl04 = 'Y'
             where oeno01=:poOrderNo;
       Endsr;
      *------------------------------------------------------------------------*
       Begsr srUnDeleteItem;
      *------------------------------------------------------------------------*
       alias_yn ='N';
       setll (sl_ivno07) ivlmali2;
       if %found;
          alias_yn='Y';
       endif;

       sub_yn ='N';
       setll (sl_ivno07) ivlmsub1;
       if %found;
          sub_yn ='Y';
       endif;

       assoc_yn ='N';
       setll (sl_ivno07) ivlmasc1;
       if %found;
          assoc_yn ='Y';
       endif;

       cmp_yn ='N';
       setll (sl_ivno07) ivlmcmp1;
       if %found;
          cmp_yn ='Y';
       endif;

       exec sql
            update ivpmstr set ivcd56=:alias_yn, ivcd22=:sub_yn,
                   ivcd23=:assoc_yn, ivcd24=:cmp_yn, ivcd36='N', ivcd25=' '
                   where ivno07=:sl_ivno07 and ivcd25='D';
       Endsr;
      *------------------------------------------------------------------------*
     OOEFTOL    E            UpdTag
     O                       OECN04
     O                       OECD30
     OOEFTOL    E            UpdSts
     O                       OECD04
     OOEFTOH    E            CrdHld
     O                       OEFL03
     O                       OEFL18
     O                       OEFL02
     O                       OECD38
     O                       OEFL04
     O                       OEFL05
     O                       OECD04
      *------------------------------------------------------------------------*
      *------------------- TABLE FILE CHANGE AREA -----------------------------*
      *------------------------------------------------------------------------*
** CRM
SNDMSG MSG('Held B2B S/O XXXXXXX for Customer
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
TOUSR(XXXXXXXXXX)
** INV
SNDMSG MSG('Credit hold message for user XXXXXXXXXX was not
sent! This ID is not valid! See table OE90.') TOUSR(QSYSOPR)
** ARY
SNDMSG MSG('                 ') TOMSGQ(OEMORDS)
** MS
  CUSTOMER NUMBER:                ORDER NUMBER:                       DATE:   /
 /                    TIME:   :  :                             A WEB O/E xxxxxxx
x order has been placed.
