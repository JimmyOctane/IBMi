     H OPTION(*SRCSTMT : *NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - ARR7915                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D SELECT ORDERS FOR INVOICING AND POST TO INVENTORY                     *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    This program selects transactions for invoicing and updates        *
     F*S    inventory and customer account records.                            *
     F*S    It reads the open order header file by batch, writes them to       *
     F*S    the YTD file and deletes them from the daily file.                 *
     F*S    It also updates inventory quantities for allocated and             *
     F*S    on hand, and posts item counts to the customer account file.       *
     F*S    Table ARCR determines if credits are posted to sales.              *
     F*S    Table AR09 provides soft close code and current period.            *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
BS   F*U 8000009875 032306 070 ADD FIELDS TO IVPHVAL                           *
BT   F*U 8000009877 040606 070 DATA BASE CHANGES FOR INV BALANCING             *
BU   F*U 8000009906 050906 070 POPULATE FIELDS ADDED FOR INV BAL               *
BV   F*U 8000009876 060806 070 NON-STOCK INVENTORY BALANCING                   *
BW   F*U 8000009930 070306 140 DO NOT ACCESS BI MST FOR COMMENTS               *
BX   F*E 8000009886 072106 248 VENDOR CONSIGNED INVENTORY
BY   F*E 8000009883 080206 907 SERIAL# TRACKING FOR ALL TRANSACTIONS
BZ   F*U 8000009926 080806 140 ADD WAC VAR POST TO ALL INV TRANS               *
B0   F*U 1550000230 110306 127 MTD SLS DEMAND INCLUDES DIRECT C/M              *
B2   F*E 8000009966 010407 914 CHANGE S/O NUMBER TO 7 ALPHA                    *
B3   F*E 8000010162 041408 907 MINCRONIZE RGA FOR NEXT RELEASE
B4   F*E 8000010256 020108 238 Weighted Average Freight                        *
B5   F*E 8000010541 100308 915 PRICE CREDIT IN RGA ENTRY                       *
CA   F*E 8000010325 012909 020 Weighted Average Rebates                        *
CB   F*U 1290000321 032911 248 WAC Variance on Rebill of order                 *
CC   F*U 1650000422 062911 002 Do not get new RUN# if not needed.              *
CD   F*U 1610001665 041612 070 WAC INCORRECT ON CM IF NO ON HAND               *
CE   F*E 8000010983 092412 171 B2C/B2B CREDIT CARD INTERFACE                   *
CG   F*U 0970000501 013013 070 LAST SALE DATE IN IVPMSBR                       *
CH   F*U 1550000371 082713 248 CREDIT/VENDOR RTN REASON CODES                  *
CI   F*U 1670000160 050514 915 NO WAC ADJ ON CREDIT MEMO ITEM < 0              *
CK   F*E 8000011209 100114 171 Credit card processing                          *
CM   F*U 1220001550 082515 119 N/S COST ADJUSTMENTS MISSING                    *
CN   F*E 1290000353 121015 248 WAR V3 SPECIAL BUY                              *
CP   F*U 1550000452 021516 915 OWNED VS CONSIGNED ON SPECIAL ORDER             *
CQ   F*U 1830000118 050916 119 PST GROUP SHOWING NODMD FROM OE55               *
CR   F*E 8000011850 092616 915 REMOVE JCHARGE INTERFACE                        *
CS   F*E 8000012436 110316 915 Curbstone C2 to C3 conversion                   *
CT   F*E 8000012857 070918 275 Update Sales statistics for Sales Portal app    *
CU   F*E 8000013071 090415 275 Use Sales Period instead of bill period         *
CW   F*U 1710000887 111418 171 Invoices lock with TBPMTBL                      *
CX   F*E 8000013122 041019 915 Card Connect - Credit card process              *
CY   F*U 1710001027 060920 019 MTD Lost Sales Calcs not same as IVR0900        *
CZ   F*E 1290000727 100121 171 Worldpay - Credit card processing               *
C0   F*E 1710001118 120121 404 Enhanced Lost Sales Tracking Phase 6            *
C1   F*U 1710001189 022723 404 Missing Ship Qty on Line Item                   *
¢A   F*U KSB   1915 032603 KSB CRED/DEB MEMO'S CHECK FOR AFF INV FLAG          *
¢B   F*U KSB   2222 012203 KSB GMC REBATE COST
¢C   F*U KSB   4906 110206 KSB Cr memo w/aff inv = No r updating oh
¢D   F*U KSB   4945 020107 KSB GMC REBATE COST
¢E   F*U JJF   3314 092926 JJF OVERFLOW MONITOR ADDED FOR ST_SACN03/ST_SACN05  *
     F*M ----------------------------------------------------------------------*
     FOEPWBIS   IF   E           K DISK
     FARLTCCT1  UF   E           K DISK
     FTBLMTBL1  UF A E           K DISK
     FIVLMSBR1  UF   E           K DISK
BV   FIVLMNSB1  UF   E           K DISK    USROPN
     FIVLMLOT1  UF   E           K DISK
     FIVLTLOT1  IF   E           K DISK
     FOEPTOTY   O    E             DISK
     FOEPTOAY   O    E             DISK
     FOEPTOCY   O    E             DISK
     FOEPTOMY   O    E             DISK
     FOEPTORY   O    E             DISK
     FOEPTOHY   O    E             DISK
     FOEPTOLY   O    E             DISK
     FOELTOLYN  IF   E           K DISK
     F                                     RENAME(OEFTOLY:FTOLYN)
B3   F                                     IGNORE(OEFTOL)
   BYF*OEPTSRY   O    E             DISK
     FOELTOT1   UF   E           K DISK
     FOELTOA1   UF   E           K DISK
     FOELTOC1   UF   E           K DISK
     FOELTOM1   UF   E           K DISK
     FOELTOR1   UF   E           K DISK
     FOELTOL7   UF   E           K DISK
     FOELTOH20  UF   E           K DISK
   BYF*OELTSR3   UF   E           K DISK
     FOELTOAH1  UF   E           K DISK
     FOELTOAL4  UF   E           K DISK
     FARLMBCH4  IF   E           K DISK
     FARLMCUS1  IF   E           K DISK
     FIVLMSTR8  IF   E           K DISK
     FOELWINVA  UF A E           K DISK
     FARLMBUS1  IF   E           K DISK
     FWBLMWBH1  IF   E           K DISK
     FWBLMWBL1  IF   E           K DISK
     FOELMCUS1  UF   E           K DISK
     FIVLTADJ4  IF A E           K DISK
     FAPLTINMB  UF   E           K DISK
     FIVPTWEA   IF A E             DISK
   BTF*IVPWACA   O    E             DISK
BT   FIVPWACA   IF A E             DISK
B4   FIVPWAFA   IF A E             DISK
CA   FIVPWARA   IF A E             DISK
CN   FIVPWASA   IF A E             DISK
BX   FIVLMCBI1  IF   E           K DISK    prefix(C_)
BX   FIVLMUOM1  IF   E           K DISK    prefix(M1)
BX   FIVLMUOM3  IF   E           K DISK    prefix(M3)
BX   F                                     RENAME(IVFMUOM:IVFMUOM3)
C0 C1F*OEQTLST01 UF   E           K DISK
C1   FOEQTLST01 UF   E           K DISK    prefix(L)
CT   FARQTSTAT01UF A E           K DISK    prefix(ST_)
      *-------------------------------------------------------------------------
     D BATCH#         UDS
     D  INVMTH                 1      2  0
     D  INVDAY                 3      4  0
     D  INVCC                  5      6  0
     D  INVYR                  7      8  0
     D  INVDAT                 1      8  0
     D  INVFLG               187    187
     D  CONBR                497    499
     D  FILENM               401    410
     D  RUN#                 411    417  0
     D                SDS
     D  DSPERR                91    160
     D  USRNM                254    263
     D VNO04           DS
     D  NSKSEC                 2      4
     D                 DS
     D  IVMO02                 1      2  0
     D  IVDY02                 3      4  0
     D  IVYR02                 5      6  0
     D  DATOUT                 1      6  0
     D                 DS
     D  ARMO06                 1      2  0
     D  ARDY06                 3      4  0
     D  ARCC06                 5      6  0
     D  ARYR06                 7      8  0
     D  SHIPDT                 1      8  0
CG   D                 DS
CG   D  newCC                  1      2  0
CG   D  newYR                  3      4  0
CG   D  newMO                  5      6  0
CG   D  newDY                  7      8  0
CG   D  newDate                1      8  0
CG   D                 DS
CG   D  oldCC                  1      2  0
CG   D  oldYR                  3      4  0
CG   D  oldMO                  5      6  0
CG   D  oldDY                  7      8  0
CG   D  oldDate                1      8  0
     D                 DS
     D  CIIFLG                 1      1
     D  ORDFLG                 2      2
     D  CRMFLG                 3      3
     D  DUFLGS                 1      3
     D MSG001          C                   CONST('WAC ADJ FROM CRDT -
     D                                     MEMO')
     D                 DS                  INZ
     D  WAMO01                 1      2  0
     D  WADY01                 3      4  0
     D  WACC01                 5      6  0
     D  WAYR01                 7      8  0
     D  WAEDTE                 1      8  0
     D                 DS                  INZ
     D  ARCC01                 1      2  0
     D  ARYR01                 3      4  0
     D  ARMO01                 5      6  0
     D  OEBLPD                 1      6  0
     D                 DS                  INZ
     D  OECC08                 1      2  0
     D  OEYR08                 3      4  0
     D  OEMO08                 5      6  0
     D  OESLPD                 1      6  0
C1   D                 DS                  INZ
C1   D LOECC08                 1      2  0
C1   D LOEYR08                 3      4  0
C1   D LOEMO08                 5      6  0
C1   D LOESLPD                 1      6  0
     D                 DS                  INZ
     D  OECC09                 1      2  0
     D  OEYR09                 3      4  0
     D  OEMO09                 5      6  0
     D  OEVDPD                 1      6  0
     D                 DS                  INZ
     D  OEMO01                 1      2  0
     D  OEDY01                 3      4  0
     D  OECC01                 5      6  0
     D  OEYR01                 7      8  0
     D  OEINDT                 1      8  0
     D                 DS                  INZ
     D  IVMO52                 1      2  0
     D  IVDY52                 3      4  0
     D  IVCC52                 5      6  0
     D  IVYR52                 7      8  0
     D  ADJPDT                 1      8  0
     D                 DS                  INZ
     D  IVCC55                 1      2  0
     D  IVYR55                 3      4  0
     D  IVMO55                 5      6  0
     D  ADJAPD                 1      6  0
BV   D                 DS                  INZ
BV   D  IVMO01                 1      2  0
BV   D  IVDY01                 3      4  0
BV   D  IVCC01                 5      6  0
BV   D  IVYR01                 7      8  0
BV   D  IVDT01                 1      8  0
BV   D                 DS                  INZ
BV   D  IVMO17                 1      2  0
BV   D  IVDY17                 3      4  0
BV   D  IVCC17                 5      6  0
BV   D  IVYR17                 7      8  0
BV   D  IVDT17                 1      8  0
B4   D                 DS                  INZ
B4   D  IVMO17_WAF             1      2  0
B4   D  IVDY17_WAF             3      4  0
B4   D  IVCC17_WAF             5      6  0
B4   D  IVYR17_WAF             7      8  0
B4   D  IVDT17_WAF             1      8  0
CA   D                 DS                  INZ
CA   D  IVMO17_WAR             1      2  0
CA   D  IVDY17_WAR             3      4  0
CA   D  IVCC17_WAR             5      6  0
CA   D  IVYR17_WAR             7      8  0
CA   D  IVDT17_WAR             1      8  0
CN   D                 DS                  INZ
CN   D  IVMO17_WAS             1      2  0
CN   D  IVDY17_WAS             3      4  0
CN   D  IVCC17_WAS             5      6  0
CN   D  IVYR17_WAS             7      8  0
CN   D  IVDT17_WAS             1      8  0
CE    *----------------------------------------------------------------
CE   D                 DS
CE   D  USING_CARD             1      1
CE CXD* CARD_SOFTWARE          2     30
CX   D  CARD_SOFTWARE          2     16
CE   D  CARD_TABENTRY          1     30
CE    *----------------------------------------------------------------
CE CX * Parms passed to/from OER9600 program...
CX    * Parms passed to/from card interface program
CE    *.....................................
CE   D piMode          S              3    inz
CE   D piRetry         S              1    inz
CE   D piUpdError      S              1    inz
CE   D piTran          S              7    inz
CE CZD*piMFUKEY        S             15    inz
CZ   D piMFUKEY        S             19    inz
CE   D piOrgOrd        S              7    inz
CE   D piMethod        S              2    inz
CE   D piTrnDtl        S              1    inz
CE   D piTrnAmt        S              9  2 inz
CE   D piTaxable       S              1    inz
CE   D piTaxAmt        S              9  2 inz
CE   D poSuccess       S              1    inz
CE   D poMsg           S             78    inz
CE   D poData          S            256    inz
CK   D piData          S            256    inz
CH   D NOD             S              1    DIM(30)                              AMT WAC SALES
CH   D skpcal          S              1                                         COUNT ADJS
CS   D type            S             10                                         COUNT ADJS
CS   D obj             S             10    inz(' ')                             COUNT ADJS
CS   D flag            S              1                                         COUNT ADJS
CE    *----------------------------------------------------------------
     D                 DS                  INZ
     D  OEMO26                 1      2  0
     D  OEDY26                 3      4  0
     D  OECC26                 5      6  0
     D  OEYR26                 7      8  0
     D  OLYPDT                 1      8  0
     D PM0810        E DS                  EXTNAME(OPPW810)
CK    * PiDet to contain tran type
CK   D  piDet          ds
CK   D   trantyp                      1    inz(' ')
      *-------------------------------------------------------------------------
      *-------------------------------------------------------------------------
BT BVI*IVFWACA
BT BVI*             IVNON1                      IBNON1
   BV *
     IOEFWINV
     I              ARNO15                      COMPNY
     I              GLCD41                      DIVISN
     I              GLCD42                      REGION
     I              OENO08                      BRANCH
     I              OECC08                      SLSCC
     I              OEYR08                      SLSYR
     I              OEMO08                      SLSMO
     I              OECC01                      INCC01
     I              OEYR01                      INYR01
     I              OEMO01                      INMO01
     I              OEDY01                      INDY01
     I              ARNO82                      ENTNUM
     I              ARNO01                      CUSNUM
     I              ARCD02                      MKTTYP
     I              OEID02                      SLSID
     I              IVCD17                      PURSEC
     I              IVCD18                      PURGRP
     I              IVCD19                      PURCAT
     I              OENO01                      ORDNUM
      *
     IOEFTOAH
     I              ARCDB5                      AACDB5
     I              ARCDB6                      AACDB6
     I              ARCD25                      AACD25
     I              ARCD26                      AACD26
     I              ARDY05                      AADY05
     I              ARMO05                      AAMO05
     I              ARNO01                      AANO01
     I              ARNM50                      AANM50
     I              ARNM51                      AANM51
     I              ARNO15                      AANO15
     I              ARCC05                      AACC05
     I              ARYR05                      AAYR05
     I              OEAM23                      OAAM23
     I              OEAM29                      OAAM29
     I              OEAM30                      OAAM30
     I              OEAM45                      OAAM45
     I              OEAM48                      OAAM48
     I              OEAM49                      OAAM49
     I              OECD03                      OACD03
     I              OECD05                      OACD05
     I              OECD13                      OACD13
     I              OECD17                      OACD17
     I              OECD18                      OACD18
     I              OECD19                      OACD19
     I              OECD33                      OACD33
     I              OECD58                      OACD58
     I              OECN06                      OACN06
     I              OEDY02                      OADY02
     I              OEDY03                      OADY03
     I              OEDY07                      OADY07
     I              OEDY14                      OADY14
     I              OEDY15                      OADY15
     I              OEDY16                      OADY16
     I              OEDY17                      OADY17
     I              OEFL06                      OAFL06
     I              OEFL07                      OAFL07
     I              OEFL08                      CONTAX
     I              OEFL09                      OAFL09
     I              OEFL14                      OAFL14
     I              OEFL15                      OAFL15
     I              OEID01                      OAID01
     I              OEID02                      CONSLS
     I              OEMO02                      OAMO02
     I              OEMO03                      OAMO03
     I              OEMO07                      OAMO07
     I              OEMO14                      OAMO14
     I              OEMO15                      OAMO15
     I              OEMO16                      OAMO16
     I              OEMO17                      OAMO17
     I              OENM01                      OANM01
     I              OENM02                      OANM02
     I              OENO01                      OANO01
     I              OENO06                      OANO06
     I              OENO07                      OANO07
     I              OENO08                      OANO08
     I              OENO24                      CONJUR
     I              OENO40                      OANO40
     I              OENO43                      OANO43
     I              OEPC02                      OAPC02
     I              OETL06                      OATL06
     I              OETL07                      OATL07
     I              OETL08                      OATL08
     I              OETL09                      OATL09
     I              OETL10                      OATL10
     I              OETL11                      OATL11
     I              OETL13                      OATL13
     I              OETM01                      OATM01
     I              OECC02                      OACC02
     I              OEYR02                      OAYR02
     I              OECC03                      OACC03
     I              OEYR03                      OAYR03
     I              OECC07                      OACC07
     I              OEYR07                      OAYR07
     I              OECC14                      OACC14
     I              OEYR14                      OAYR14
     I              OECC15                      OACC15
     I              OEYR15                      OAYR15
     I              OECC16                      OACC16
     I              OEYR16                      OAYR16
     I              OECC17                      OACC17
     I              OEYR17                      OAYR17
     I              ARCDF9                      OACDF9
     I              OECD86                      OACD86
     I              OEPC08                      OAPC08
     I              OECD01                      OACD01
     I              OEDN01                      OADN01
     I              ARCDC6                      OACDC6
     IOEFTOAL
     I              ARNO01                      AANO01
     I              ARNO15                      AANO15
     I              IVDN02                      AVDN02
     I              IVNO04                      AVNO04
     I              IVNO07                      AVNO07
     I              IVNO23                      AVNO23
     I              OEAM01                      OAAM01
     I              OEAM02                      OAAM02
     I              OEAM05                      OAAM05
     I              OEAM14                      OAAM14
B4   I              OEAMWF                      OAAMWF
B4   I              OEAMWC                      OAAMWC
CA   I              OEAMWR                      OAAMWR
     I              OEAM17                      OAAM17
     I              OEAM18                      OAAM18
B4   I              OEAMEF                      OAAMEF
B4   I              OEAMEC                      OAAMEC
CA   I              OEAMER                      OAAMER
     I              OEAM38                      OAAM38
     I              OEAM39                      OAAM39
     I              OEAM40                      OAAM40
     I              OEAM41                      OAAM41
     I              OEAM42                      OAAM42
     I              OEAM46                      OAAM46
     I              OEAM47                      OAAM47
     I              OECD03                      OACD03
     I              OECD09                      OACD09
     I              OECD26                      OACD26
     I              OECD27                      OACD27
     I              OECD28                      OACD28
     I              OECD30                      OACD30
     I              OECD31                      OACD31
     I              OECD43                      OACD43
     I              OECD55                      OACD55
     I              OECD66                      OACD66
     I              OECD72                      OACD72
     I              OECN04                      OACN04
     I              OEDN04                      OADN04
     I              OEDY02                      OADY02
     I              OEDY03                      OADY03
     I              OEDY07                      OADY07
     I              OEID02                      OAID02
     I              OEMO02                      OAMO02
     I              OEMO03                      OAMO03
     I              OEMO07                      OAMO07
     I              OENM01                      OANM01
     I              OENO01                      OANO01
     I              OENO16                      OANO16
     I              OENO31                      OANO31
     I              OENO32                      OANO32
     I              OENO33                      OANO33
     I              OENO35                      OANO35
     I              OENO36                      OANO36
     I              OENO37                      OANO37
     I              OEPC01                      OAPC01
     I              OEPC04                      OAPC04
     I              OEPC07                      OAPC07
     I              OEQY06                      OAQY06
     I              OEQY10                      OAQY10
     I              OEQY11                      OAQY11
     I              OEQY13                      OAQY13
     I              OEQY17                      OAQY17
     I              OETM01                      OATM01
     I              OECC02                      OACC02
     I              OEYR02                      OAYR02
     I              OECC03                      OACC03
     I              OEYR03                      OAYR03
     I              OECC07                      OACC07
     I              OEYR07                      OAYR07
     I              PONO01                      PANO01
     I              PONO05                      PANO05
     I              OECD47                      OACD47
CN   I              OEAMWR_S                    OAAMWR_S
CN   I              OEAMER_S                    OAAMER_S
      *
     IARFMBUS
     I              ARNO15                      NO15
     I              GLCD41                      CD41
      *
     IIVFMLOT
     I              IVQY01                      LTQY01
     I              IVQY02                      LTQY02
     I              IVQY03                      LTQY03
     I              IVQY04                      LTQY04
     I              IVQY22                      LTQY22
     I              IVQY23                      LTQY23
     I              IVQYV8                      LTQYV8
     I              IVQYV9                      LTQYV9
     I              IVMO04                      LTMO04
     I              IVDY04                      LTDY04
     I              IVCC04                      LTCC04
     I              IVYR04                      LTYR04
      *
     IAPFTINM
     I              PONO01                      XPNO01
     I              PONO05                      XPNO05
     IIVFMSBR
     I              ARCD14                      BICD14
     I              ARCD15                      BICD15
     I              IVNO14                      BINO14
     IIVFTADJ
     I              IVNO14                      AJNO14
     IIVFTWEA
     I              IVNO10                      WANO10
     I              IVNO66                      WANO66
     I              IVNO90                      WANO90
     I              IVNO07                      WANO07
     I              POQY04                      WAQY04
     I              POAM07                      WAAM07
     I              IVAMZ1                      WAAMZ1
     I              IVAMAG                      WAAMAG
     I              IVAMW6                      WAAMW6
     I              IVPC21                      WAPC21
     I              IVNM01                      WANM01
     I              IVMO01                      WAMO01
     I              IVDY01                      WADY01
     I              IVCC01                      WACC01
     I              IVYR01                      WAYR01
     I              IVTM01                      WATM01
     I              OPPGM                       WAPGM
BV   I              IVNON1                      WANON1
BV    *
BV   IIVFMNSB
BV   I              IVNO10                      NBNO10
BV   I              IVNON1                      NBNON1
BV   I              IVQY01                      NBQY01
BV   I              IVQY23                      NBQY23
BV   I              IVAMW6                      NBAMW6
B4   I              IVAMWF                      NBAMWF
B4   I              IVAMWC                      NBAMWC
CA   I              IVAMWR                      NBAMWR
BV   I              IVNM01                      NBNM01
BV   I              IVMO01                      NBMO01
BV   I              IVDY01                      NBDY01
BV   I              IVCC01                      NBCC01
BV   I              IVYR01                      NBYR01
BV   I              IVMO04                      NBMO04
BV   I              IVDY04                      NBDY04
BV   I              IVCC04                      NBCC04
BV   I              IVYR04                      NBYR04
CN   I              IVAMWR_S                    NBAMWR_S
      *------------------------------------------------------------------------*
      *  SECTION 0         FIRST CYCLE
      *
      * STEP 1.  DECLARE KEY LISTS
      * STEP 2.  INITIALIZATIONS AND RESETS
      * STEP 3.  DECLARE PARAMETER LIST
      *------------------------------------------------------------------------*
      * STEP 1. *  DECLARE KEY LISTS
      *------------------------------------------------------------------------*
     C     IVKEY1        KLIST
     C                   KFLD                    OENO16
     C                   KFLD                    IVNO07
     C     IVKEY2        KLIST
     C                   KFLD                    IVNO07
     C                   KFLD                    CD08              1
     C     OEKEY1        KLIST
     C                   KFLD                    OENO01                         ORDER NUMBER
     C     OEKEY2        KLIST
     C                   KFLD                    OENO26                         ORIG ORDER
     C                   KFLD                    IVNO07
C0   C     OEKEY3        KLIST
C0   C                   KFLD                    OENO01
C0   C                   KFLD                    OENO22
     C     ARKEY1        KLIST
     C                   KFLD                    ARNO01                         CUSTOMER NUMBER
     C                   KFLD                    ARNO15                         COMPANY NUMBER
     C     TKEY          KLIST
     C                   KFLD                    CMPANY                         COMPANY NUMBER
     C                   KFLD                    OECC05
     C                   KFLD                    OEYR05
     C                   KFLD                    OEMO05
     C                   KFLD                    OEDY05
     C                   KFLD                    OENO15
     C     TABKEY        KLIST
     C                   KFLD                    TBNO01
     C                   KFLD                    TBNO02
     C     OAKEY         KLIST
     C                   KFLD                    OENO19
     C                   KFLD                    OENO31
      *
     C     BUSKEY        KLIST
     C                   KFLD                    NO15                           COMPANY NUMBER
     C                   KFLD                    CD41                           DIVISION
     C                   KFLD                    OECC05                         BATCH CENTURY
     C                   KFLD                    OEYR05                         BATCH YEAR
     C                   KFLD                    OEMO05                         BATCH MONTH
     C                   KFLD                    OEDY05                         BATCH DAY
     C     CRDKEY        KLIST
     C                   KFLD                    TRANUM            7
     C                   KFLD                    ARCDF4
     C     WBHKEY        KLIST
     C                   KFLD                    ARNO01
     C     WBLKEY        KLIST
     C                   KFLD                    WBNO24
     C                   KFLD                    IVCDD5
     C                   KFLD                    IVCDD6
     C                   KFLD                    IVCDD7
     C     LTKEY1        KLIST
     C                   KFLD                    CDL1
     C                   KFLD                    OENO01
     C                   KFLD                    OENO26
     C                   KFLD                    LINE#
     C     LTKEY2        KLIST
     C                   KFLD                    IVNO10
     C                   KFLD                    IVNO07
     C                   KFLD                    IVNO99
     C     TINMKY        KLIST
     C                   KFLD                    PONO01
     C                   KFLD                    PONO05
     C                   KFLD                    PONO24
BV    *
BV   C     NSBKEY        KLIST
BV   C                   KFLD                    NBNO10
BV   C                   KFLD                    NBNON1
BX   C     MCBIKY        KLIST
BX   C                   KFLD                    OENO16
BX   C                   KFLD                    IVNO07
BX   C     MUOMKY        KLIST
BX   C                   KFLD                    IVNO07
BX   C                   KFLD                    M1IVCD08
BX   C     UOMKEY        KLIST
BX   C                   KFLD                    IVNO07                         ITEM NUMBER R
BX   C                   KFLD                    OEDN04                         UOM
CT   C     statKey       klist
CT   C                   kfld                    arno15
CT   C                   kfld                    oeno08
CT   C                   kfld                    oeid02
CT CUC*                  kfld                    arcc01
CT CUC*                  kfld                    aryr01
CT CUC*                  kfld                    armo01
CU   C                   kfld                    oecc08
CU   C                   kfld                    oeyr08
CU   C                   kfld                    oemo08
CE    *
CE   C     pl9600        PLIST
CE   C                   PARM                    piMode
CE   C                   PARM                    piRetry
CE   C                   PARM                    piUpdError
CE   C                   PARM                    piTran
CE   C                   PARM                    piMFUKEY
CE   C                   PARM                    piOrgOrd
CE   C                   PARM                    piMethod
CE   C                   PARM                    piTrnDtl
CE   C                   PARM                    piTrnAmt
CE   C                   PARM                    piTaxable
CE   C                   PARM                    piTaxAmt
CE   C                   PARM                    poSuccess
CE   C                   PARM                    poMsg
CE   C                   PARM                    poData
CK   C                   PARM                    piData
      *-------------------------------------------------------------------------
     C     *LIKE         DEFINE    OEAM05        EXTAMT
     C     *LIKE         DEFINE    OEAM05        GRSAMT
     C     *LIKE         DEFINE    OEAM38        PMIUPR
     C     *LIKE         DEFINE    OEAM38        PMIUCS
     C     *LIKE         DEFINE    OEPC01        PMIDSC
     C     *LIKE         DEFINE    OEAM38        PMONPR
     C     *LIKE         DEFINE    OEAM38        STKNET
     C     *LIKE         DEFINE    IVCDL1        CDL1
     C     *LIKE         DEFINE    IVNOL3        LINE#
     C     *LIKE         DEFINE    PDFMT2        CRARPD
     C     *LIKE         DEFINE    PDFMT2        INVPRD
     C     *LIKE         DEFINE    PDFMT2        BILPRD
     C     *LIKE         DEFINE    PDFMT2        SALPRD
   BZC*    *LIKE         DEFINE    OEQY01        SVQY01
     C     *LIKE         DEFINE    IVAMW6        BEFWAC                         BEFORE WAC  PEN
B4   C     *LIKE         DEFINE    IVAMWF        BEFWAF                         BEFORE WAC  PEN
CA   C     *LIKE         DEFINE    IVAMWR        BEFWAR                         BEFORE WAR  PEN
CN   C     *LIKE         DEFINE    IVAMWR_S      BEFWAS                         BEFORE WAR  PEN
     C     *LIKE         DEFINE    IVAMW6        CHGWAC
     C     *LIKE         DEFINE    ROLEX         ROLEXP                         PROCESS/DATE/TI
BU   C     *LIKE         DEFINE    OEAM18        RVAM18
BV   C     *LIKE         DEFINE    IVNO07        PMNO07
BX   C     *LIKE         DEFINE    IVQY01        IVQYDIFF                       PROCESS/DATE/TI
BX   C     *LIKE         DEFINE    IVQY01        QYDIFF                         PROCESS/DATE/TI
BX   C     *LIKE         DEFINE    M1IVQY12      PRCFCT                         PROCESS/DATE/TI
BX   C     *LIKE         DEFINE    M1IVQY12      ORDFCT                         PROCESS/DATE/TI
BX   C     *LIKE         DEFINE    IVQY01        HLDQY01                        PROCESS/DATE/TI
BX   C     *LIKE         DEFINE    IVNO40        CTLNBR
BX   C     *LIKE         DEFINE    OEQY03        WKOEQY03
BZ   C     *LIKE         DEFINE    IVQY01        OHBEF
BZ   C     *LIKE         DEFINE    IVQY01        OHAFT
BZ   C     *LIKE         DEFINE    IVAMW6        WACBEF
BZ   C     *LIKE         DEFINE    IVAMW6        WACAFT
B4   C     *LIKE         DEFINE    IVAMWF        WAFBEF
B4   C     *LIKE         DEFINE    IVAMWF        WAFAFT
CA   C     *LIKE         DEFINE    IVAMWR        WARBEF
CA   C     *LIKE         DEFINE    IVAMWR        WARAFT
CN   C     *LIKE         DEFINE    IVAMWR_S      WASBEF
CN   C     *LIKE         DEFINE    IVAMWR_S      WASAFT
      *
   BXC*    *DTAARA       DEFINE    IVADJN        WKADJN            7 0
      *------------------------------------------------------------------------*
      * STEP 2. *  INITIALIZATIONS AND RESETS
      *------------------------------------------------------------------------*
BT    * FAKE INPUT OPERATION NECESSARY SO FIELD RENAME COULD BE DONE
BT    * ON WHAT SHOULD REALLY BE AN OUTPUT ONLY FILE...
BT   C     *INLR         IFNE      *INLR
BT   C                   READ      IVPWACA
BT   C                   ENDIF
      *
      * VERIFY NECESSARY ONLINE PROGRAMS AND LIBRARY EXIST BEFORE
      * ALLOWING ANY ONLINE PROCESSING.
      *
     C                   MOVE      'N'           ONLINE            1
CE    *
CE CR * Based on card software JCHARGE OR CURBSTONE,
CR    * Based on card software,
CE    * check appropriate software library and program object.
CE   C                   MOVE      'N'           flag
CE   C                   clear                   card_software
CE   C                   clear                   tbno02
CE   C                   move      'AR27'        tbno01
CE   C                   movel     'CARD'        tbno02
CE CWC*    tabkey        chain     tblmtbl1
CW   C     tabkey        chain(n)  tblmtbl1
CE   C                   If        %found(tblmtbl1)
CE   C                   movel     tbno03        card_tabentry
CE   C                   If        using_card = 'Y'
CE CRC*                  If        card_software = 'JCHARGE'
CE CR *
CE CR * Verify existance of "ASCCOM1" library and required program
   CR *
   CRC*                  MOVEL     'ASCCOM1'     OBJ              10
   CRC*                  MOVEL     '*LIB   '     TYPE             10
   CRC*                  MOVE      ' '           FLAG              1
   CRC*                  CALL      'OPC0028'
   CRC*                  PARM                    OBJ
   CRC*                  PARM                    TYPE
   CRC*                  PARM                    FLAG
   CR *
   CRC*    FLAG          IFEQ      ' '
   CRC*                  MOVEL     'OER9002'     OBJ              10
   CRC*                  MOVEL     '*PGM   '     TYPE             10
   CRC*                  MOVE      ' '           FLAG              1
   CRC*                  CALL      'OPC0028'
   CRC*                  PARM                    OBJ
   CRC*                  PARM                    TYPE
   CRC*                  PARM                    FLAG
   CRC*                  ENDIF
CE CR *
CE    * Verify existance of "CURBSTONE" library and required program
CE CRC*                  else
CE   C                   If        card_software = 'CURBSTONE'
CS   C                   eval      tbno02 = 'CARDLIB'
CS   C     tabkey        chain     tblmtbl1
CS   C                   If        %found(tblmtbl1)
CS   C                   eval      obj = %trim(%subst(tbno03:1:10))
CS   C                   endif
CE CSC*                  MOVEL     'CURBSTONE'   OBJ
CE   C                   MOVEL     '*LIB     '   TYPE
CE   C                   MOVE      ' '           FLAG
CE   C                   CALL      'OPC0028'
CE   C                   PARM                    OBJ
CE   C                   PARM                    TYPE
CE   C                   PARM                    FLAG
CE    *
CE   C     FLAG          IFEQ      ' '
CE   C                   CLEAR                   OBJ
CE   C                   MOVEL     'OER9600   '  OBJ
CE   C                   MOVEL     '*PGM      '  TYPE
CE   C                   MOVE      ' '           FLAG
CE   C                   CALL      'OPC0028'
CE   C                   PARM                    OBJ
CE   C                   PARM                    TYPE
CE   C                   PARM                    FLAG
CE   C                   ENDIF
CE CRC*                  endif
CE   C                   endif
CE   C                   endif
CE   C                   endif
      *
     C     FLAG          IFEQ      ' '
     C                   MOVE      'Y'           ONLINE
     C                   ENDIF
      *
     C                   MOVE      'P'           CD08
     C                   MOVE      'OE'          APPCDE            2            APPLICAT CODE
     C     *DTAARA       DEFINE    *LDA          BATCH#                         LDA
     C                   MOVE      CONBR         CMPANY            3 0          COMPANY NUMBER
      * GET TABLE ENTRY FOR POSTING CODES
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVE      *BLANKS       TBNO01
     C                   MOVEL     'ARCR'        TBNO01
     C                   MOVEL     CMPANY        TBNO02
     C     TABKEY        CHAIN(N)  TBFMTBL                            40
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TBNO03        TBCRED            1
     C                   END
      *
      * CHECK IF A/R INVOICE TOTALS ARE TO BE APPLIED TO NEXT BUSINESS DAY
     C                   MOVE      'AR01'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'NEXTDAY'     TBNO02
     C     TABKEY        CHAIN(N)  TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        NXTDAY            1            NXTDAY
     C                   ENDIF
      *
      ***  RETRIEVE CURRENT ACCOUNTING PERIOD.
     C                   Z-ADD     2             DTFUNC
     C                   Z-ADD     CMPANY        DTCOMP
     C                   CALL      'OPR0810'     PL0810
     C                   Z-ADD     CARFM2        CRARPD
      * GET INVOICE DATE CONTROL
      * CIIFLG IS THE FLAG USED FOR CASH AND IMMEDIATE INVOICES...
      *   DEFAULT TO 'O' IF TABLE ENTRY NOT FOUND
      * ORDFLG IS THE FLAG USED FOR REGULAR ORDERS...
      *   DEFAULT TO 'I' IF TABLE ENTRY NOT FOUND
      * CRMFLG IS THE FLAG USED FOR CREDIT MEMOS...
      *   DEFAULT TO 'I' IF TABLE ENTRY NOT FOUND
     C                   MOVE      'O'           CIIFLG
     C                   MOVE      'I'           ORDFLG
     C                   MOVE      'I'           CRMFLG
     C                   MOVE      'AR01'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'SADATE'      TBNO02
     C     TABKEY        CHAIN(N)  TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        DUFLGS
     C                   ENDIF
      *
      ***  RETRIEVE WAC TOLERANCE PERCENT
     C                   MOVE      'WACT'        TBNO01
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVEL     'TOL'         TBNO02
     C     TABKEY        CHAIN     TBFMTBL                            48
     C     *IN48         IFEQ      '0'
     C                   MOVEL     TBNO03        TOLPC             3 0
     C                   ELSE
     C                   Z-ADD     999           TOLPC
     C                   END
     C                   Z-SUB     TOLPC         TOLPCN            3 0
B4    * RETRIEVE TABLE SETTINGS FOR INCLUDING FREIGHT IN COST..
B4   C                   MOVE      'WAFR'        TBNO01
B4   C                   CLEAR                   TBNO02
B4   C                   MOVEL     'OE'          TBNO02
B4   C     TABKEY        CHAIN     TBFMTBL
B4   C                   IF        %FOUND
B4   C                   MOVEL     TBNO03        WAFR_OE           1
B4   C                   ELSE
B4   C                   CLEAR                   WAFR_OE
B4   C                   ENDIF
      * DUMMY I/O TO SATISFY COMPILER FOR RENAMED FIELDS...
     C     1             IFEQ      2
     C                   READ      IVPTWEA                                40
     C                   ENDIF
CH    *
CH    * GET NO DEMAND REASON CODES
CH   C                   Z-ADD     *ZEROS        X                 5 0
CH   C                   MOVE      *BLANKS       TBNO02
CH   C                   MOVE      *BLANKS       TBNO01
CH CQC*                  MOVEL     'OE55'        TBNO01
CQ   C                   MOVEL     'IV11'        TBNO01
CH   C                   MOVEL     'NODMD'       TBNO02
CH   C     tabkey        setll     tbfmtbl
CH   C     tabkey        reade     tbfmtbl
CH   C                   dow       not %eof
CH   C                   add       1             x
CH   C                   movel     tbno03        nod(x)
CH   C     tabkey        reade     tbfmtbl
CH   C                   enddo
CH    *
C0    * Retrieve Enhanced Lost Sales Flag
C0   C                   Clear                   EnhLstTrk         1
C0   C                   Eval      TBNO01 = 'OE97'
C0   C                   Eval      TBNO02 = 'LST' + CONBR
C0   C     TabKey        Chain     Tblmtbl1
C0   C                   If        %Found(Tblmtbl1)
C0   C                   Eval      EnhLstTrk = %Subst(TBNO03:1:1)
C0   C                   Endif
      *
      *------------------------------------------------------------------------*
      * STEP 3. *  DECLARE PARAMETER LIST
      *------------------------------------------------------------------------*
     C     *ENTRY        PLIST
     C                   PARM                    BLDFLG            1
      *
     C     RLOCK         PLIST
     C                   PARM                    DSPERR
     C                   PARM                    DSPF1             1            DISPLAY RETRY?
     C                   PARM                    DSPF2             1            SCREEN RESPONSE
      *
     C     PL4947        PLIST
     C                   PARM                    PMIUPR
     C                   PARM                    PMIUCS
     C                   PARM                    PMIDSC
     C                   PARM                    PMONPR
      *
      * PARAMETER LIST FOR CALL TO UDR;
      *
     C     PLUDR         PLIST
     C                   PARM                    ZZFUNC            1
     C                   PARM                    ZZDATE            7 0
     C                   PARM                    ZZDAYS            5 0
     C                   PARM                    ZZDIFF            7 0
      *
     C     PL9002        PLIST
     C                   PARM                    OENO08
     C                   PARM      'M'           REQTYP            1
     C                   PARM                    APRVD             1
     C                   PARM                    CCAMT             9 2
     C                   PARM                    CARD#            24
     C                   PARM                    CRDTYP            4
     C                   PARM                    EXPDT             4
     C                   PARM                    CNAME            30
     C                   PARM                    BCITY            25
     C                   PARM                    BSTATE            2
     C                   PARM                    BZIP              9
     C                   PARM                    VERIF#            3
     C                   PARM                    CUSPO#           40
     C                   PARM                    PDESC            40
     C                   PARM                    TAXAMT            9 2
     C                   PARM                    AUCODE            9
     C                   PARM                    CTRACK          117
     C                   PARM                    MSGFLD           78
   CEC*                  PARM                    MERCID            4
CE   C                   PARM                    MERCID            5
     C                   PARM                    SETTLD            1
     C                   PARM                    ROUTD            15
      *
     C     PL0061        PLIST
     C                   PARM                    ROLEX            14 0
     C     PL0810        PLIST
     C                   PARM                    PM0810
     C     PL0002        PLIST
     C                   PARM                    OENO16
     C                   PARM                    HITEM             7 0
     C                   PARM                    PFOR              7 0
     C                   PARM                    PTYPE             1
     C                   PARM                    MSDS#            25
     C                   PARM                    SLOC1            20
     C                   PARM                    SLOC2            20
     C                   PARM      'Y'           UPDF              1
BX   C     PL1601        PLIST
BX   C                   PARM                    IVNO07
BX   C                   PARM                    WKQTYDIF
BX   C                   PARM                    OENO16
BX   C                   PARM                    RcvBrNbr          3 0
BX   C                   PARM                    OENO01
BX   C                   PARM                    OENO22
BX   C                   PARM                    TranType          2
BX   C                   PARM                    OESLPD
BX   C                   PARM                    VenRepFlg         1
BX   C                   PARM                    ROLEX
BX   C                   PARM                    CONHANDB          7 0
BX   C                   PARM                    CONHANDA          7 0
BX   C                   PARM                    MODE              1
BX   C                   PARM                    OTRANQTY          7 0
BX   C     PL9312        PLIST
BX   C                   PARM                    CTLNBR
BX   C     PL1693        PLIST
BX   C                   PARM                    HLDQY01
BX   C                   PARM                    C_IVQY01
BX   C                   PARM                    WKOEQY03
BX   C                   PARM                    QYDIFF
BX   C                   PARM                    IVQYDIFF
BZ   C     PL6111        PLIST
BZ   C                   PARM                    PMIOB             7 0          OnHand B4
BZ   C                   PARM                    PMIWB             9 4          WAC B4
BZ   C                   PARM                    PMIOA             7 0          OnHand after
BZ   C                   PARM                    PMIWA             9 4          WAC after
BZ   C                   PARM                    PMIRVB           11 2          Rcvr val b4
BZ   C                   PARM                    PMIRVA           11 2          Rcvr val aft
BZ   C                   PARM                    PMOWV            11 2          WAC variance
      *------------------------------------------------------------------------*
      *  SECTION 1         PROCESS FILES
      *
      * STEP 1.  SET LIMITS AND READ HEADER FILE
      * STEP 2.  WRITE YTD FILES AND DELETE ORDERS
      * STEP 3.  UPDATE INVENTORY AND CUSTOMER BALANCE RECORDS
      *------------------------------------------------------------------------*
      * STEP 1.  SET LIMITS AND READ HEADER FILE
      *------------------------------------------------------------------------*
     C     BLDFLG        IFEQ      'Y'
     C     *LOVAL        SETLL     OELWINVA
     C                   ENDIF
      *
     C                   READ      OEFWBIS                                40
     C     *IN40         DOWEQ     '0'
     C     TKEY          SETLL     OEFTOH
     C     *IN46         DOUEQ     '1'
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     TKEY          READE     OEFTOH                               9246
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
      *------------------------------------------------------------------------*
      * STEP 2.  WRITE YTD FILES AND DELETE ORDERS
      *------------------------------------------------------------------------*
     C     *IN46         IFEQ      '0'
      ***  HEADERS
     C                   MOVE      'E'           OECD39                         STS 'ENTERED'
      *
      * If direct, ship branch must = sell branch...
      *
     C     OECD16        IFEQ      'D'                                          DIRECT
     C     OENO16        ANDNE     OENO08                                       SHIP VS SELL
     C                   Z-ADD     OENO08        OENO16
     C                   ENDIF
      * GET PERIOD FOR INVOICE DATE
      * GET CLOSE TYPE
     C                   Z-ADD     1             DTFUNC
     C                   Z-ADD     1             DTFRMT
      * DETERMINE WHICH INVOICE DATE TO USE FOR SALES PERIOD CALC
     C                   CLEAR                   DTFMT1
      * Use flags retrieved from positions 2 & 3 of AR01 entry SADATE
      * to determine if the S/O ship date should be used for the
      * invoice date...
     C                   SELECT
      * Regular order requires ship date...
     C     OECD08        WHENNE    'C'
     C     ORDFLG        ANDEQ     'S'
     C                   Z-ADD     SHIPDT        DTFMT1
      * Credit memo requires ship date...
     C     OECD08        WHENEQ    'C'
     C     CRMFLG        ANDEQ     'S'
     C                   Z-ADD     SHIPDT        DTFMT1
      * If it wasn't one of the two above conditions then we are
      * using invoice date, in which case we need to check the setting
      * of the flag retrieved from position 1 of AR01/SADATE to see
      * if we need to use the invoice date from the sales order...
     C     CIIFLG        WHENEQ    'O'
     C                   Z-ADD     OEINDT        DTFMT1
     C                   ENDSL
      * If we don't have a date at this point, use the date from the
      * invoice run prompt...
     C     DTFMT1        IFEQ      *ZEROS
     C                   Z-ADD     INVDAT        DTFMT1
     C                   ENDIF
      *
     C                   CALL      'OPR0810'     PL0810
     C                   Z-ADD     PDFMT2        INVPRD
      * DETERMINE INVOICE SALES PERIOD
      * IF USING SOFT CLOSE
     C     SFTCLS        IFEQ      'Y'
      * IF INVOICE PERIOD IS LESS THAN CURRENT A/R PERIOD
      * USE CURRENT A/R PERIOD
     C     INVPRD        IFLT      CRARPD
     C                   Z-ADD     CRARPD        SALPRD
     C                   ELSE
      * USE INVOICE PERIOD
     C                   Z-ADD     INVPRD        SALPRD
     C                   ENDIF
     C                   ELSE
      * IF USING HARD CLOSE
      * USE CURRENT A/R PERIOD
     C                   Z-ADD     CRARPD        SALPRD
     C                   ENDIF
      * DETERMINE INVOICE BILLING PERIOD
      * IF INVOICE BILLING PERIOD IS LESS THAN THE SALES PERIOD
      * USE SALES PERIOD
     C     OEBLPD        IFLT      SALPRD
     C                   Z-ADD     SALPRD        BILPRD
     C                   ELSE
     C                   Z-ADD     OEBLPD        BILPRD
     C                   ENDIF
      * UPDATE FILE PERIODS
     C                   Z-ADD     BILPRD        OEBLPD
     C                   Z-ADD     SALPRD        OESLPD
      *
      * DETERMINE WHETHER PREVIOUS BUSINESS DAY OR NEXT BUSINESS DAY USED
     C     BLDFLG        IFEQ      'Y'
     C                   MOVE      ' '           FINISH            1
     C                   MOVE      *OFF          *IN47
     C                   Z-ADD     *ZERO         OEMO04
     C                   Z-ADD     *ZERO         OEDY04
     C                   Z-ADD     *ZERO         OECC04
     C                   Z-ADD     *ZERO         OEYR04
     C     BUSKEY        SETLL     ARFMBUS
      *
      * USE PREVIOUS BUSINESS DAY
     C     NXTDAY        IFNE      'Y'
     C     *IN47         DOUEQ     *ON
     C     FINISH        OREQ      'Y'
     C                   READP     ARFMBUS                                47
     C     *IN47         IFEQ      *OFF
     C     ARFL68        ANDEQ     'Y'
     C                   MOVE      'Y'           FINISH
     C                   Z-ADD     ARMO78        OEMO04
     C                   Z-ADD     ARDY78        OEDY04
     C                   Z-ADD     ARCC78        OECC04
     C                   Z-ADD     ARYR78        OEYR04
     C                   ENDIF
     C                   ENDDO
     C                   ELSE
      *
      * USE NEXT BUSINESS DAY
     C     *IN47         DOUEQ     *ON
     C     FINISH        OREQ      'Y'
     C                   READ      ARFMBUS                                47
     C     *IN47         IFEQ      *OFF
     C     ARFL68        ANDEQ     'Y'
     C                   MOVE      'Y'           FINISH
     C                   Z-ADD     ARMO78        OEMO04
     C                   Z-ADD     ARDY78        OEDY04
     C                   Z-ADD     ARCC78        OECC04
     C                   Z-ADD     ARYR78        OEYR04
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C     RUN#OK        CASNE     'Y'           GETRUN
     C                   END
     C                   Z-ADD     RUN#          GLNO05
     C                   MOVE      'Y'           OEFL06                         SHIP TO FLAG
     C                   WRITE     OEFTOHY
     C                   DELETE    OEFTOH
CT    *    Sales Stats
CT   C                   EXSR      UPDSTATS
      *    ADDRESSES
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OEKEY1        CHAIN     OEFTOA                             4192
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN41         IFEQ      '0'
     C                   WRITE     OEFTOAY
     C                   DELETE    OEFTOA
     C                   ELSE
      * Retrieve Customer shipping address to write to history.
     C     ARNO01        CHAIN     ARFMCUS                            41
     C     *IN41         IFEQ      *OFF
     C                   Z-ADD     UMONTH        OEMO02                         UPDATE MONTH
     C                   Z-ADD     UDAY          OEDY02                         UPDATE DAY
     C                   MOVEL     *YEAR         OECC02                         UPDATE CENTURY
     C                   Z-ADD     UYEAR         OEYR02                         UPDATE YEAR
     C                   MOVE      USRNM         OENM01                         USER ID
     C                   MOVE      ARAD04        OEAD01                         ADDRESS 1
     C                   MOVE      ARAD05        OEAD02                         ADDRESS 2
     C                   MOVE      ARAD06        OEAD03                         ADDRESS 3
     C                   MOVE      ARCY02        OECY01                         CITY
     C                   MOVE      ARST02        OEST01                         STATE
     C                   MOVE      ARZP16        OEZP03                         ZIP
     C                   WRITE     OEFTOAY
     C                   ENDIF
      *
     C                   END
      ***  CONTACTS
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OEKEY1        CHAIN     OEFTOC                             4292
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN42         IFEQ      '0'
      *
      * DID WE TAKE A CARD FOR THIS TRANSACTION
      *
     C     OEAM36        IFNE      *ZEROS
     C                   MOVE      OENO01        TRANUM
     C                   MOVE      'S'           ARCDF4
     C     CRDKEY        SETLL     ARFTCCT                                49
     C     *IN49         IFEQ      *ON
      *
     C     *IN49         DOUEQ     *ON
     C     *IN92         DOUEQ     *OFF
     C     CRDKEY        READE     ARFTCCT                              9249
     C     *IN92         CASEQ     *ON           UNLOCK
     C                   ENDCS
     C                   ENDDO
CE   C     *IN49         IFEQ      *OFF
CE    *
CE    * HAS CARD IN PENDING STATUS
CE    * (Credit Memo created from RGA is not approved yet;
CE    *  Need to refund Credit Amount.)
CE   C                   CLEAR                   APRVD                          MANUAL
CE   C     ARCDF6        IFEQ      'P'
CE CKC*    OEFL31        ANDEQ     'Y'
CK   C     ARCDF5        ANDEQ     'C'
CE   C     ONLINE        ANDEQ     'Y'
CE   C     card_software ANDEQ     'CURBSTONE'
CE   C                   EXCEPT    RLSCRD
CE   C                   EVAL      piMode = 'RFD'
CE   C                   EVAL      piRetry = 'N'
CE   C                   EVAL      piUpdError = 'Y'
CE   C                   EVAL      piTran = ARNOC1
CE   C                   EVAL      piMFUKEY = ARNOB7
CE CKC*                  EVAL      piMethod = '02'
CK   C                   EVAL      piMethod = '01'
CK   C                   EVAL      tranTyp  = arcdf4
CK   C                   EVAL      pidata   = pidet
CE   C                   EVAL      piTrnDtl = 'N'
CE   C                   CLEAR                   poMsg
CE   C                   CLEAR                   poData
CE   C                   CLEAR                   poSuccess
CE CXC*                  CALL      'OER9600'     PL9600
CX   C                   CALL      'OER9650'     PL9600
CE   C                   IF        poSuccess <> 'Y'
CE   C                   MOVE      'N'           APRVD                          MANUAL
CE   C                   ELSE
CE   C                   MOVE      'Y'           APRVD                          MANUAL
CE   C                   ENDIF
CE   C                   ELSE
      *
      * HAS CARD BEEN APPROVED
      *
     C     ARCDF6        IFEQ      'A'
      *
      * IF WE HAVE A ROUTING NUMBER, AND WE ARE ON-LINE THEN
      * MARK THE CARD FOR SETTLEMENT.
      *
     C     ARNOB7        IFNE      *BLANKS
     C     ONLINE        ANDEQ     'Y'
CE    *
CE   C     card_software IFEQ      'CURBSTONE'
CE   C     ARCDJ3        IFEQ      'C'
CE   C                   EXCEPT    RLSCRD
CE   C                   EVAL      piMode = 'FTS'
CE   C                   EVAL      piRetry = 'N'
CE   C                   EVAL      piUpdError = 'Y'
CE   C                   EVAL      piTran = ARNOC1
CE   C                   EVAL      piMFUKEY = ARNOB7
CE CKC*                  EVAL      piMethod = '02'
CK   C                   EVAL      piMethod = '01'
CK   C                   EVAL      trantyp  = ARCDf4
CK   C                   EVAL      piData   = pidet
CE   C                   EVAL      piTrnDtl = 'N'
CE   C                   CLEAR                   poMsg
CE   C                   CLEAR                   poData
CE   C                   CLEAR                   poSuccess
CE CXC*                  CALL      'OER9600'     PL9600
CX   C                   CALL      'OER9650'     PL9600
CE   C                   IF        poSuccess <> 'Y'
CE   C                   MOVE      'N'           APRVD                          MANUAL
CE   C                   ELSE
CE   C                   MOVE      'Y'           APRVD                          MANUAL
CE   C                   ENDIF
CE   C                   ELSE
CE   C                   MOVE      'M'           APRVD                          MANUAL
CE   C                   ENDIF
CE   C                   ELSE
CE CRC*    ARCDJ3        IFEQ      'J'
   CRC*                  MOVE      ARNOB7        ROUTD
   CRC*                  MOVEL     ARNOB6        CARD#
   CEC*                  MOVE      ARID06        MERCID
CE CRC*                  MOVEL     ARID06        MERCID
   CRC*                  Z-ADD     ARAMC7        CCAMT
   CRC*                  CALL      'OER9002'     PL9002
CE CRC*                  ELSE
CE   C                   MOVE      'M'           APRVD                          MANUAL
CE CRC*                  ENDIF
CE   C                   ENDIF
      *
      * ELSE WE ARE NOT USING ONLINE PROCESSING - SO JUST APROVE
      * THE CARD (UPDATE STATUS TO 'S' FOR SETTLED)
      *
     C                   ELSE
      *
     C                   MOVE      'M'           APRVD                          MANUAL
      *
     C                   ENDIF
      *
CE    * Approved Transaction for Curbstone will update ARPTCCT
CE CX * thru OER9600 above.
CX    * thru card interface program above
CE    *
CE CR * Approved Transaction for Jcharge need to update here and
CE CR * we will change them to "M" to indicate as "Mark to Settle".
CE CR *
CE    * If Transaction is marked for the settlement (M)
CE CR *    i.e. it has not gone thru OER9600 for Curbstone or
CE CR *         it has not gone thru OER9002 for Jcharge
CR CX *    i.e. it has not gone thru OER9600 for Curbstone
CX    *    i.e. it has not gone thru program, for Curbstone
CE    * so we will change them to "S" to indicate as "Settled".
CE    *
   CRC*    APRVD         IFEQ      'Y'                                          ON-LINE
CE CRC*    card_software ANDEQ     'JCHARGE'
   CRC*    APRVD         OREQ      'M'                                          MANUAL
CR   C     APRVD         IFEQ      'M'                                          MANUAL
      *
   CR * IF ONLINE - THEN TRANSACTION IS MARKED FOR SETTLEMENT, ELSE
      * GO AHEAD AND MARK AS SETTLED.
   CR *
   CRC*    APRVD         IFEQ      'Y'
   CRC*                  MOVE      'M'           ARCDF6
   CRC*                  ELSE
     C                   MOVE      'S'           ARCDF6
   CRC*                  ENDIF
      *
     C                   MOVE      UMONTH        ARMO09
     C                   MOVE      UDAY          ARDY09
     C                   MOVEL     *YEAR         ARCC09
     C                   MOVE      *YEAR         ARYR09
     C                   MOVE      USRNM         ARNM03
     C                   EXCEPT    UPDCRD
      *
     C                   ENDIF
     C                   ENDIF
CE   C                   ENDIF
CE   C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   WRITE     OEFTOCY
     C                   DELETE    OEFTOC
     C                   END
      ***  COMMENTS
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OEKEY1        CHAIN     OEFTOM                             4392
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN43         DOUEQ     '1'
     C     *IN43         IFEQ      '0'
     C                   WRITE     OEFTOMY
     C                   DELETE    OEFTOM
     C                   END
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OEKEY1        READE     OEFTOM                               9243
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C                   END
      ***  OTHER CHARGES
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OEKEY1        CHAIN     OEFTOR                             4492
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN44         DOUEQ     '1'
     C     *IN44         IFEQ      '0'
     C                   WRITE     OEFTORY
     C                   DELETE    OEFTOR
     C                   END
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OEKEY1        READE     OEFTOR                               9244
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C                   END
   BY ***  SERIAL NUMBER
   BYC*                  MOVE      *IN92         SVIN92                         SAVE *IN92
   BYC*                  MOVE      *BLANKS       DSPF1
   BYC*    *IN92         DOUEQ     *OFF
   BYC*    OEKEY1        CHAIN     OEFTSR                             4492
   BYC*    *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
   BYC*                  ENDCS
   BYC*                  ENDDO
   BYC*                  MOVE      SVIN92        *IN92                          RESTORE *IN92
   BYC*    *IN44         DOUEQ     '1'
   BYC*    *IN44         IFEQ      '0'
   BYC*                  WRITE     OEFTSRY
   BYC*                  DELETE    OEFTSR
   BYC*                  END
   BYC*                  MOVE      *IN92         SVIN92                         SAVE *IN92
   BYC*                  MOVE      *BLANKS       DSPF1
   BYC*    *IN92         DOUEQ     *OFF
   BYC*    OEKEY1        READE     OEFTSR                               9244
   BYC*    *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
   BYC*                  ENDCS
   BYC*                  ENDDO
   BYC*                  MOVE      SVIN92        *IN92                          RESTORE *IN92
   BYC*                  END
      *------------------------------------------------------------------------*
      * STEP 3.  UPDATE INVENTORY AND CUSTOMER BALANCE RECORDS
      *------------------------------------------------------------------------*
   BZ *   ZERO CUST BALANCE WORK FIELDS
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OEKEY1        CHAIN     OEFTOL                             4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN45         DOUEQ     '1'
     C     *IN45         IFEQ      '0'
BU    * Set affect inventory flag
BU   C                   SELECT
BU   C     OECD09        WHENEQ    'C'                                          Comment
BU   C     OECD09        OREQ      'A'                                          Stock kit
BU   C     OECD09        OREQ      'K'                                          Nonstk kit
BU   C                   MOVE      'N'           IVCD79
BU   C     OECD01        WHENEQ    'D'                                          Direct
BU   C                   MOVE      'N'           IVCD79
BU   C     OECD08        WHENEQ    'O'                                          Order
BU   C                   MOVE      'Y'           IVCD79
BU   C                   ENDSL
BU    * Update if not comment
BW   C     OECD09        IFNE      'C'                                          COMMENT
      *
      * If direct, ship branch must = sell branch...
      *
     C     OECD16        IFEQ      'D'                                          DIRECT
     C     OENO16        ANDNE     OENO08                                       SHIP VS SELL
     C                   Z-ADD     OENO08        OENO16
     C                   ENDIF
     C     OECD47        IFEQ      'V'
     C                   Z-ADD     CRARPD        OEVDPD
     C                   END
      * UPDATE FILE PERIODS
     C                   Z-ADD     BILPRD        OEBLPD
     C                   Z-ADD     SALPRD        OESLPD
     C                   MOVE      'I'           OECD04
     C                   Z-ADD     0             OETM09
     C                   Z-ADD     0             OLYPDT
      *   CLEAR INVENTORY WORK FIELDS
     C                   Z-ADD     *ZEROS        QYDEF             7 0
     C                   Z-ADD     *ZEROS        CAMT              9 2
¢D   C                   Z-ADD     *ZEROS        CAMT1             9 2
     C                   Z-ADD     *ZEROS        AMTDEF            9 2
     C                   Z-ADD     *ZEROS        DSC7              7 7
     C                   Z-ADD     *ZEROS        EXTAMT
     C                   Z-ADD     *ZEROS        GROSP             9 2
     C                   Z-ADD     *ZEROS        GRSAMT
BX   C                   MOVE      *BLANKS       ORDTyp            1            QTY ON HAND
      * GET PROCESS DATE AND TIME - TRANSACTION
     C                   CALL      'OPC0061'     PL0061
     C                   MOVE      ROLEX         ROLEXP                         PROCESS/DATE/TI
     C     OECD09        IFNE      'N'                                          N=NON STK
     C     OECD09        ANDNE     'K'                                          N=NON STK
     C     OECD09        ANDNE     'X'                                          N=NON STK
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     IVKEY1        CHAIN     IVFMSBR                            4092
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
      *
     C     *IN40         IFEQ      *ON
      * BRANCH MASTER NOT FOUND - GO SET-UP BLANK BRANCH MASTER
     C                   CALL      'IVR0115'
     C                   PARM                    OENO16                         SHIP TO BRANCH
     C                   PARM                    IVNO07                         ITEM #
     C                   PARM                    APPCDE                         APPLICATION
     C                   END
      *
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     IVKEY1        CHAIN     IVFMSBR                            4092
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
      *
     C     *IN40         IFEQ      '0'                                          UPDATE
      * GET PROCESS DATE AND TIME - TRANSACTION
     C                   CALL      'OPC0061'     PL0061
     C                   MOVE      ROLEX         ROLEXP                         PROCESS/DATE/TI
     C                   Z-ADD     IVAMW6        BEFWAC
B4   C                   Z-ADD     IVAMWF        BEFWAF
CA   C                   Z-ADD     IVAMWR        BEFWAR
CN   C                   Z-ADD     IVAMWR_S      BEFWAS
BZ    * SAVE ON HAND AND WAC BEFORE UPDATE
BZ   C                   Z-ADD     IVQY01        OHBEF
BZ   C                   Z-ADD     IVAMW6        WACBEF
B4   C                   Z-ADD     IVAMWF        WAFBEF
CA   C                   Z-ADD     IVAMWR        WARBEF
CN   C                   Z-ADD     IVAMWR_S      WASBEF
      *   CALCULATE COST
     C                   Z-ADD     OEAM17        CAMT
¢D   C     ivcd17        ifeq      'GMC'
¢D   C                   z-add     oeam18        camt1
¢D   C                   end
      *   SPECIAL ?
     C     OECD16        IFEQ      'S'
     C     OECD09        IFNE      'A'                                          COMBINATION
CP    * save fields for Consigned Quantity update for Specials                  QTY ON HAND
CP   C     OECD08        IFEQ      'O'                                          ORDER
CP   C     OECD09        IFEQ      'G'                                          QTY ON HAND
CP   C     OECD09        OREQ      'S'                                          QTY ON HAND
CP   C                   MOVE      'O'           ORDTyp                         QTY ON HAND
CP   C                   Z-ADD     IVQY01        HLDQY01                        QTY ON HAND
CP   C                   ENDIF                                                  QTY ON HAND
CP   C                   ENDIF                                                  QTY ON HAND
     C     OECD08        IFEQ      'O'                                          ORDER
     C     OECD08        OREQ      'C'                                          CREDIT
     C     IVCD79        ANDEQ     'Y'                                          AFFECT INV
     C     OECD08        OREQ      'D'                                          DEBIT
     C     IVCD79        ANDEQ     'Y'                                          AFFECT INV
     C                   SUB       OEQY03        IVQY01                         QTY ON HAND
     C                   SUB       OEQY03        IVQY02                         QTY ALLOCATED
     C                   END                                                    COMBINATION
     C                   END                                                    COMBINATION
     C                   ADD       1             IVCN29                         COUNT
     C                   ADD       OEQY03        IVQYQ7                         QTY SPECIAL
     C     OECD43        IFNE      'Y'
     C                   ADD       OEAM05        IVAMW7                         AMT PRC SPCL
     C                   END
     C                   ADD       CAMT          IVAMW8                         AMT COS SPCL
     C                   ELSE
      *   DIRECT ?
     C     OECD16        IFEQ      'D'
     C                   ADD       OEQY03        IVQYQ8                         QTY DIRECT
     C     OECD43        IFNE      'Y'
     C                   ADD       OEAM05        IVAMW9                         AMT PRC DIR
     C                   END
     C                   ADD       1             IVCN31                         COUNT
     C                   ADD       CAMT          IVAMX1                         AMT COS DIR
      * ALLOW DIRECT'S TO BE PROCESSED THRU CR/MEMO'S.
   B0C*                  END
B0   C                   ELSE
      *   CREDIT MEMO ?
¢A    *    WE HAVE SALES AND RETURNS ADDING INTO SAME BUCKET FOR
¢A    *    THE BR MASTER WHICH INCORRECTLY STATES THE MTD SALES VALUE
¢A    *         FOR WARRANTY CREDIT MEMOS
¢A    *    EX:  ENTER CREDIT MEMO FOR A WARRANTY PART
¢A    *         2 LINES ENTERED - PART 123 QTY -1 AFF INV N (DAMAGED)
¢A    *         PART 123 QTY 1 AFF INV Y (REPLACEMENT PART)
¢A    *         TECHNICALLY, I'VE SOLD 1 IN THIS TRANSACTION
¢A    *         BUT PGM ADDS THEM BOTH TO THE SOLD BUCKET AND THEY
¢A    *         CANCEL EACH OTHER OUT.  THIS ALSO SCREWS UP DEMAND
¢A    *         HISTORY.
     C     OECD08        IFEQ      'C'
¢A ¢CC     IVCD79        IFNE      'N'                                          AFFECT INV
CH    * CK REASON CODE IN NO DEMAND ARRAY
CH   C                   move      ' '           skpcal
CH   C     oecd14        lookup    nod                                    66
CH   C                   if        *in66 = '1'
CH   C                   move      'Y'           skpcal
CH   C                   endif
     C     TBCRED        IFEQ      'Y'
CH   C     skpcal        andne     'Y'
     C                   ADD       OEQY03        IVQY07                         QTY SALES
     C     OECD43        IFNE      'Y'
     C                   ADD       OEAM05        IVAM03                         AMT PRC SALS
     C                   END
¢D   C     ivcd17        ifne      'GMC'
     C                   ADD       CAMT          IVAM16                         AMT COS SALE
¢D   C                   else
¢D   C                   ADD       CAMT1         IVAM16                         AMT COS SALE
¢D   C                   end
     C                   ELSE
     C     OECD43        IFNE      'Y'
     C                   ADD       OEAM05        IVAMW4                         AMT PRC RTN
     C                   END
     C                   ADD       CAMT          IVAM26                         AMT COS RTN
     C                   ADD       OEQY03        IVQY15                         QTY RTN
     C                   ENDIF
CG    * Only update last return date if something was shipped and
CG    * the date is greater than the existing last sale date...
CG   C                   IF        OEQY03 <> *ZEROS
CG   C                   EVAL      newMO = ARMO06
CG   C                   EVAL      newDY = ARDY06
CG   C                   EVAL      newCC = ARCC06
CG   C                   EVAL      newYR = ARYR06
CG   C                   EVAL      oldMO = IVMO14
CG   C                   EVAL      oldDY = IVDY14
CG   C                   EVAL      oldCC = IVCC14
CG   C                   EVAL      oldYR = IVYR14
CG   C                   IF        newDate > oldDate
     C                   Z-ADD     ARDY06        IVDY14                         DATE
     C                   Z-ADD     ARMO06        IVMO14                          LAST
     C                   Z-ADD     ARCC06        IVCC14                           RETURN
     C                   Z-ADD     ARYR06        IVYR14                           RETURN
CG   C                   ENDIF
     C                   ADD       1             IVCN10                         # OF RTNS
CG   C                   ENDIF
     C     OECD09        IFNE      'A'                                          COMBINATION
   B0C*    OECD16        ANDNE     'D'                                          DIRECT
     C     IVCD79        ANDEQ     'Y'                                          AFFECT INV
   BZC*                  Z-ADD     IVQY01        SVQY01                         SAVE ON HAND
     C                   SUB       OEQY03        IVQY01                         QTY ON HAND
     C                   SUB       OEQY03        IVQY02                         QTY ALLOCATED
      *
   BZC*    SVQY01        IFEQ      *ZEROS
BZ   C     OEQY03        IFLT      0
BZ CIC*    OHBEF         ANDEQ     *ZEROS
CI   C     OHBEF         ANDLE     *ZEROS
     C     IVQY01        ANDGT     *ZEROS
   B4C*    OEAM41        ANDNE     IVAMW6
B4 CDC*    OEAM41        IFNE      IVAMW6
CD CMC*    OEAMWC        IFNE      IVAMWC
CM   C     OEAM41        IFNE      IVAMW6
¢B   C     IVCD17        ANDNE     'GMC'
¢B   C     IVCD18        ANDNE     'EQP'
B4   C     OEAMWF        ORNE      IVAMWF
¢B   C     IVCD17        ANDNE     'GMC'
¢B   C     IVCD18        ANDNE     'EQP'
CA   C     OEAMWR        ORNE      IVAMWR
¢B   C     IVCD17        ANDNE     'GMC'
¢B   C     IVCD18        ANDNE     'EQP'
CN   C     OEAMWR_S      ORNE      IVAMWR_S
¢B   C     IVCD17        ANDNE     'GMC'
¢B   C     IVCD18        ANDNE     'EQP'
     C                   EXSR      WACADJ
BZ   C                   Z-ADD     IVAMW6        WACBEF
B4   C                   Z-ADD     IVAMWF        WAFBEF
CA   C                   Z-ADD     IVAMWR        WARBEF
CN   C                   Z-ADD     IVAMWR_S      WASBEF
B4   C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
¢C   C                   ENDIF
     C                   ELSE
   B0C*    OECD16        IFNE      'D'                                          NOT DIRECT'S
      *   DEBIT ?
     C     OECD08        IFEQ      'D'
¢A ¢CC     IVCD79        IFNE      'N'                                          AFFECT INV
     C                   ADD       OEQY03        IVQY07                         QTY SALES
     C     OECD09        IFNE      'A'                                          COMBINATION
     C     IVCD79        ANDEQ     'Y'                                          COMBINATION
     C                   SUB       OEQY03        IVQY01                         QTY ON HAND
     C                   SUB       OEQY03        IVQY02                         QTY ALLOCATED
     C                   ENDIF
     C     OECD43        IFNE      'Y'
     C                   ADD       OEAM05        IVAM03                         AMT PRC SALS
     C                   END
¢D   C     ivcd17        ifne      'GMC'
     C                   ADD       CAMT          IVAM16                         AMT COS SALE
¢D   C                   else
¢D   C                   add       camt1         ivam16
¢D   C                   end
¢C   C                   ENDIF
     C                   ELSE
      *   ORDER ?
     C     OECD09        IFNE      'A'                                          COMBINATION
BX   C     OECD09        IFEQ      'G'                                          QTY ON HAND
BX   C     OECD09        OREQ      'S'                                          QTY ON HAND
BX   C                   MOVE      'O'           ORDTyp                         QTY ON HAND
BX   C                   Z-ADD     IVQY01        HLDQY01                        QTY ON HAND
BX   C                   ENDIF                                                  QTY ON HAND
     C                   SUB       OEQY03        IVQY01                         QTY ON HAND
     C                   SUB       OEQY03        IVQY02                         QTY ALLOCATED
     C                   END                                                    COMBINATION
¢A   C     IVCD79        IFNE      'N'                                          AFFECT INV
     C                   ADD       OEQY03        IVQY07                         QTY SALES
¢A   C                   END
     C     OECD43        IFNE      'Y'
     C                   ADD       OEAM05        IVAM03                         AMT PRC SALS
     C                   END
¢D   C     ivcd17        ifne      'GMC'
     C                   ADD       CAMT          IVAM16                         AMT COS SALE
¢D   C                   else
¢D   C                   add       camt1         ivam16
¢D   C                   end
      * IN ORDER TO PROVIDE MORE ACCURATE SERVICE LEVEL PERCENTAGES,
      * UPDATE ORDERS/ORDERS FILLED, FOR ORIGINALLY ORDERED ITEMS ONLY.
     C     OENO01        IFEQ      OENO26                                       NOT BACKORD?
     C                   ADD       1             IVCN16                         # OF SALES
     C     OEQY03        IFGE      OEQY01
     C                   ADD       1             IVCN17                         # OF SALES
     C                   END                                                     FILLED
     C                   ELSE                                                   BACKORDERED?
      * IF ITEM WAS ON A BACKORDER, THEN UPDATE THE ORDER/ORDER FILLED
      * FIELDS ONLY IF THE ITEM DOES NOT EXIST ON THE ORIGINAL ORDER...
     C     OEKEY2        SETLL     FTOLYN                                 48
     C     *IN48         IFEQ      '0'
     C                   ADD       1             IVCN16
     C     OEQY03        IFGE      OEQY01
     C                   ADD       1             IVCN17
     C                   END
     C                   END
     C                   END
      * CALCULATE MTD SERVICE LEVEL (SALES ONLY, NO TRANSFERS)...
     C     IVCN16        IFGT      0
     C     IVCN17        DIV(H)    IVCN16        IVPC05
     C                   ELSE
     C                   Z-SUB     1             IVPC05
     C                   END
     C     IVPC05        IFGT      1
     C                   Z-ADD     1             IVPC05
     C                   END
      * ITEM QTY LOST?
     C     OECD09        IFNE      'A'                                          COMBINATION
CY   C     OECD09        ANDNE     'K'
C0    *
C0    * If Enhanced Lost Sales is in play-execute subroutine to
C0    * retrieve lost sales information from OEQTLST
C0    *
C0   C                   IF        EnhLstTrk = 'Y'
C0   C                   Exsr      Rtv_QTLST
C0   C                   Else
      * NO BACKORDERED QUANITY
     C     OEQY02        IFEQ      0
     C     OEQY01        IFGT      OEQY03
     C     OEQY01        SUB       OEQY03        QYDEF                          CAL QTY LOST
     C     QYDEF         IFNE      0
     C                   ADD       QYDEF         IVQY08                         QTY LOST
     C                   EXSR      PRCEXT
     C     OECD43        IFNE      'Y'
     C                   ADD       AMTDEF        IVAM17                         AMT QTY LOST
     C                   END
     C                   END
     C                   END
      * BACKORDERED
     C                   ELSE
     C     OECD47        IFEQ      'V'                                          B/O VOIDED
     C                   Z-ADD     OEQY02        QYDEF
     C                   ADD       QYDEF         IVQY08                         QTY LOST
     C                   EXSR      PRCEXT
     C     OECD43        IFNE      'Y'
     C                   ADD       AMTDEF        IVAM17                         AMT QTY LOST
     C                   END
     C                   END
     C                   END
C0   C                   Endif
     C                   END
CG    * Only update last sale date if something was shipped and
CG    * the date is greater than the existing last sale date...
CG   C                   IF        OEQY03 <> *ZEROS
CG   C                   EVAL      newMO = ARMO06
CG   C                   EVAL      newDY = ARDY06
CG   C                   EVAL      newCC = ARCC06
CG   C                   EVAL      newYR = ARYR06
CG   C                   EVAL      oldMO = IVMO06
CG   C                   EVAL      oldDY = IVDY06
CG   C                   EVAL      oldCC = IVCC06
CG   C                   EVAL      oldYR = IVYR06
CG   C                   IF        newDate > oldDate
     C                   Z-ADD     ARDY06        IVDY06                         DATE
     C                   Z-ADD     ARMO06        IVMO06                          LAST
     C                   Z-ADD     ARCC06        IVCC06                           SALE
     C                   Z-ADD     ARYR06        IVYR06                           SALE
CG   C                   ENDIF
CG   C                   ENDIF
     C                   END
     C                   END
     C                   END
     C                   END
      * GROSS MARGINS
     C     IVAM03        SUB       IVAM16        IVAM25                         G/M STOCK
     C     IVAMW7        SUB       IVAMW8        IVAMY1                         G/M SPECIAL
     C     IVAMW9        SUB       IVAMX1        IVAMY3                         G/M DIRECT
      * DEMAND
     C     IVAM03        ADD       IVAM17        IVAM37                         SALES DEMAND ST
     C     IVQY07        ADD       IVQY08        IVQY35                         QTY DEMAND   ST
      *    END OF INVENTORY CALCS
      *
      * IF STOCK IS DEPLETED BY SHIPMENT. CHANGE STOCK STATUS
      * TO 'OUT OF STOCK' AND DATE STAMP IT.
      *
     C     IVQY01        IFLE      0
     C     IVCD10        ANDNE     'Y'
     C                   MOVE      'Y'           IVCD10
     C                   Z-ADD     UMONTH        IVMO02
     C                   Z-ADD     UDAY          IVDY02
     C                   MOVEL     *YEAR         IVCC02
     C                   Z-ADD     UYEAR         IVYR02
     C                   Z-ADD     0             IVMO38
     C                   Z-ADD     0             IVDY38
     C                   Z-ADD     0             IVCC38
     C                   Z-ADD     0             IVYR38
     C                   END
      *
      * IF A CREDIT/DEBI MEMO - AND AFFECT INVENTORY = YES, AND ON HAND
      * IS BROUGHT ABOVE ZERO, AND OUT OF STOCK CODE IS A 'Y'. (WHEW)
      * THEN CALC #DAYS OUT AND CHANGE OUT OF STOCK CODE TO 'N'...
      *
     C     OECD08        IFEQ      'C'
     C     IVCD79        ANDEQ     'Y'
     C     IVQY01        ANDGT     0
     C     IVCD10        ANDEQ     'Y'
     C                   Z-ADD     UDATE         RCVDT             6 0
     C                   Z-ADD     RCVDT         ZZDATE
     C                   Z-ADD     DATOUT        ZZDIFF
     C                   MOVEL     'D'           ZZFUNC
     C                   CALL      'UDR'         PLUDR
     C                   ADD       ZZDAYS        IVDY08
     C                   MOVE      'N'           IVCD10
     C                   Z-ADD     UMONTH        IVMO38
     C                   Z-ADD     UDAY          IVDY38
     C                   MOVEL     *YEAR         IVCC38
     C                   Z-ADD     UYEAR         IVYR38
     C                   ENDIF
      *
      *
     C                   MOVE      *BLANKS       IVNM01                         USR NAME
     C                   MOVEL     'INVOICE'     IVNM01                         USR NAME
     C                   MOVEL     *YEAR         IVCC01                         LAST UPDATE CENTURY
     C                   Z-ADD     UYEAR         IVYR01                         LAST UPDATE
     C                   Z-ADD     UMONTH        IVMO01                          DATE
     C                   Z-ADD     UDAY          IVDY01
      * IF ON HAND IS GREATER THAN ZERO AFTER THE ADJUSTMENT, AND THE
      * ITEM IS CURRENTLY DELETED, THEN "UN-DELETE" IT...
     C     IVQY01        IFGT      0
     C     IMCD67        ANDEQ     'D'
     C                   CLEAR                   IMCD67
     C                   ENDIF
B5    * Do not load WAC if reason code on credit memos is price credit
BV   C     OECD01        IFNE      'D'
BV   C     OECD09        IFEQ      'G'
B5   C     OECD27        ANDNE     'X'
BV   C     OECD09        OREQ      'S'
B5   C     OECD27        ANDNE     'X'
BV   C                   Z-ADD     IVAMW6        OEAM14
BV   C     OEQY03        MULT(H)   OEAM14        OEAM18
B4   C                   Z-ADD     IVAMWF        OEAMWF
B4   C     OEQY03        MULT(H)   OEAMWF        OEAMEF
CA   C                   Z-ADD     IVAMWR        OEAMWR
CA   C     OEQY03        MULT(H)   OEAMWR        OEAMER
CN   C                   Z-ADD     IVAMWR_S      OEAMWR_S
CN   C     OEQY03        MULT(H)   OEAMWR_S      OEAMER_S
BV   C                   ENDIF
BV   C                   ENDIF
BS    * Load transaction parms to pass to IVR0940...
BS   C                   clear                   pmnon1
BS    * Transaction type...
BS BVC*                  select
BS BVC*    oecd08        wheneq    'C'
BS BVC*                  eval      pmcdf3 = 'ARC'
BS BVC*    oecd08        wheneq    'D'
BS BVC*                  eval      pmcdf3 = 'ARD'
BS BVC*    oecd08        wheneq    'O'
BS BVC*                  eval      pmcdf3 = 'ARI'
BS BVC*                  other
BS BVC*                  clear                   pmcdf3
BS BVC*                  endsl
BV   C                   MOVE      'INV'         PMCDF3
BS    * Transaction number/sequence#/quantity/wac...
BS B2C*                  eval      pmnoa1 = oeno01
B2   C                   MOVE      OENO01        PMNOA1
BS BVC*                  eval      pmnoa2 = oeno22
BS BVC*                  eval      pmqyab = oeqy03
BV   C                   Z-ADD     OENO09        PMNOA2
BV   C                   Z-SUB     OEQY03        PMQYAB
BS   C                   eval      pmamai = oeam14
      * RECORD ANY CHANGE TO ON HAND OR WAC...
     C                   CALL      'IVR0940'
     C                   PARM                    IVNO10
     C                   PARM                    IVNO07
     C                   PARM                    IVQY01
     C                   PARM                    IVAMW6
B4   C                   PARM                    IVAMWF                         Weighted Average Frt
B4   C                   PARM                    IVAMWR                         Weighted Average Reb
B4   C                   PARM                    IVAMWC                         Combined WAC
     C                   PARM      'ARR7915'     PGM              10
     C                   PARM                    ROLEXP                         PROCESS/DATE/TI
BS   C                   PARM                    PMNON1           12            Nonstock ID
BS   C                   PARM                    PMCDF3            3            Tran type
BS B2C*                  PARM                    PMNOA1            7 0          Tran number
B2   C                   PARM                    PMNOA1            7            Tran number
BS   C                   PARM                    PMNOA2            3 0          Tran seq #
BS   C                   PARM                    PMQYAB            7 0          Tran qty
BS   C                   PARM                    PMAMAI            9 4          Tran wac
CN   C                   PARM                    IVAMWR_S                       Tran wac
     C                   UPDATE    IVFMSBR
BZ    * SAVE ON HAND AND WAC AFTER UPDATE
BZ   C                   Z-ADD     IVQY01        OHAFT
BZ   C                   Z-ADD     IVAMW6        WACAFT
B4   C                   Z-ADD     IVAMWF        WAFAFT
CA   C                   Z-ADD     IVAMWR        WARAFT
CN   C                   Z-ADD     IVAMWR_S      WASAFT
BX    *
BX    *  CALCULATE CONSIGNMENT AMOUNT
BX   C     ORDTyp        IFEQ      'O'
BX   C     IVCDF7        ANDEQ     'Y'
BX   C                   EXSR      CONSIGN
BX   C                   ENDIF
      *
      *  WRITE THE WAC EXCEPTION RECORD IF WAC CHANGES OVER CERTAIN %
     C                   EXSR      WRTWEA
      *
      * IF ITEM IS A LOT TRACKING ITEM IVCDL5 = YES, AND LOT AFFECT
      * INVENTORY IVCDL3 = YES THEN RELIEVE INVENTORY FOR THE ITEM
      * IN IVPMLOT FOR BRANCH/ITEM/LOT...
     C                   MOVE      'SO'          CDL1
     C                   Z-ADD     OENO22        LINE#
      *
     C     IVCDL5        IFEQ      'Y'
      *
      * GET TRANSACTION LOT RECORDS
      *
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     LTKEY1        CHAIN     IVFTLOT                            4892
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN48         DOWEQ     *OFF                                         UPDATE
      *
      *  REDUCE QUANTITY ON-HAND
      *
     C     IVCDL3        IFEQ      'Y'
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     LTKEY2        CHAIN     IVFMLOT                            4892
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN48         IFEQ      *OFF                                         UPDATE
     C                   SUB       IVQYL1        LTQY01
     C                   SUB       IVQYL1        LTQY02
      *
     C                   MOVE      *BLANKS       IVNM01                         USR NAME
     C                   MOVEL     'INVOICE'     IVNM01                         USR NAME
     C                   MOVEL     *YEAR         IVCC01                         LAST UPDATE CENTURY
     C                   Z-ADD     UYEAR         IVYR01                         LAST UPDATE
     C                   Z-ADD     UMONTH        IVMO01                          DATE
     C                   Z-ADD     UDAY          IVDY01
     C                   UPDATE    IVFMLOT
     C                   ENDIF
     C                   ENDIF
      *
      * GET TRANSACTION LOT RECORDS
      *
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     LTKEY1        READE     IVFTLOT                              9248
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C                   ENDDO
     C                   ENDIF
   BVC*    OECD01        IFNE      'D'
   BVC*    OECD09        IFEQ      'G'
   BVC*    OECD09        OREQ      'S'
   BVC*                  Z-ADD     IVAMW6        OEAM14
   BVC*    OEQY03        MULT(H)   OEAM14        OEAM18
   BVC*                  ENDIF
   BVC*                  ENDIF
     C                   END
BV   C                   ELSE
BV    * Update non-stock inventory...
BV   C                   EXSR      UPDNSI
     C                   END
BW   C                   ENDIF
BZ    * Get wac variance
BZ   C                   Z-ADD     0             OEAM54                         WAC variance
BZ   C     IVCD79        IFEQ      'Y'
BZ   C                   Z-ADD     OHBEF         PMIOB                          OH B4
BZ   C                   Z-ADD     WACBEF        PMIWB                          WAC B4
BZ   C                   Z-ADD     OHAFT         PMIOA                          OH after
BZ   C                   Z-ADD     WACAFT        PMIWA                          WAC after
BZ   C                   Z-ADD     0             PMIRVB                         Rcvr val b4
BZ   C                   Z-SUB     OEAM18        PMIRVA                         Rcvr val aft
BZ   C                   CALL      'IVR6111'     PL6111
BZ   C                   Z-ADD     PMOWV         OEAM54                         WAC variance
BZ   C                   ENDIF
B4    * Get WAF variance
B4   C                   CLEAR                   OEAM54_WAF                     WAC variance
B4   C     IVCD79        IFEQ      'Y'
B4   C                   Z-ADD     OHBEF         PMIOB                          OH B4
B4   C                   Z-ADD     WAFBEF        PMIWB                          WAC B4
B4   C                   Z-ADD     OHAFT         PMIOA                          OH after
B4   C                   Z-ADD     WAFAFT        PMIWA                          WAC after
B4   C                   Z-ADD     0             PMIRVB                         Rcvr val b4
B4   C                   Z-SUB     OEAMEF        PMIRVA                         Rcvr val aft
B4   C                   CALL      'IVR6111'     PL6111
B4   C                   Z-ADD     PMOWV         OEAM54_WAF                     WAC variance
B4   C                   ENDIF
CA    * Get WAR variance
CA   C                   CLEAR                   OEAM54_WAR                     WAR variance
CA   C     IVCD79        IFEQ      'Y'
CA   C                   Z-ADD     OHBEF         PMIOB                          OH B4
CA   C                   Z-ADD     WARBEF        PMIWB                          WAR B4
CA   C                   Z-ADD     OHAFT         PMIOA                          OH after
CA   C                   Z-ADD     WARAFT        PMIWA                          WAR after
CA   C                   Z-ADD     0             PMIRVB                         Rcvr val b4
CA   C                   Z-SUB     OEAMER        PMIRVA                         Ext War
CA   C                   CALL      'IVR6111'     PL6111
CA   C                   Z-ADD     PMOWV         OEAM54_WAR                     WAR variance
CA   C                   ENDIF
CN    * Get WAS variance
CN   C                   CLEAR                   OEAM54_WAS                     WAR variance
CN   C     IVCD79        IFEQ      'Y'
CN   C                   Z-ADD     OHBEF         PMIOB                          OH B4
CN   C                   Z-ADD     WASBEF        PMIWB                          WAR B4
CN   C                   Z-ADD     OHAFT         PMIOA                          OH after
CN   C                   Z-ADD     WASAFT        PMIWA                          WAR after
CN   C                   Z-ADD     0             PMIRVB                         Rcvr val b4
CN   C                   Z-SUB     OEAMER_S      PMIRVA                         Ext War
CN   C                   CALL      'IVR6111'     PL6111
CN   C                   Z-ADD     PMOWV         OEAM54_WAS                     WAR variance
CN   C                   ENDIF
BU    * Get total cost
BU   C     OEAM18        MULT      -1            RVAM18
BU   C     RVAM18        ADD       OEAM54        OEAM55
BU    *
      * Update direct line item status...
     C     OECD01        IFEQ      'D'
     C     APCD62        ANDEQ     *BLANK
     C     PONO24        ANDNE     *ZEROS
     C     PONO01        ANDNE     *ZEROS
     C     PONO05        ANDNE     *ZEROS
     C                   MOVE      *IN42         SVIN42            1
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     TINMKY        CHAIN     APFTINM                            4292
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN42         IFEQ      *OFF
     C                   MOVE      'M'           APCD62
     C                   EXCEPT    UPTINM
     C                   ENDIF
     C                   MOVE      SVIN42        *IN42
     C                   ENDIF
     C                   MOVEL     ROLEXP        OETM09
     C                   MOVE      ROLEXP        OLYPDT
B4    * Calculate combined amounts based on WAFR table setting...
B4   C                   Z-ADD     OEAM14        OEAMWC
B4   C                   Z-ADD     OEAM18        OEAMEC
B4   C                   SELECT
B4   C     WAFR_OE       WHENEQ    '2'
B4   C                   ADD       IVAMWF        OEAMWC
B4   C                   ADD       OEAMEF        OEAMEC
CA   C     WAFR_OE       WHENEQ    '3'
CA   C                   SUB       IVAMWR        OEAMWC
CA   C                   SUB       OEAMER        OEAMEC
CA   C     WAFR_OE       WHENEQ    '4'
CA   C                   ADD       IVAMWF        OEAMWC
CA   C                   ADD       OEAMEF        OEAMEC
CA   C                   SUB       IVAMWR        OEAMWC
CA   C                   SUB       OEAMER        OEAMEC
CN   C     WAFR_OE       WHENEQ    '5'
CN   C                   SUB       IVAMWR_S      OEAMWC
CN   C                   SUB       OEAMER_S      OEAMEC
CN   C     WAFR_OE       WHENEQ    '6'
CN   C                   SUB       IVAMWR        OEAMWC
CN   C                   SUB       IVAMWR_S      OEAMWC
CN   C                   SUB       OEAMER        OEAMEC
CN   C                   SUB       OEAMER_S      OEAMEC
CN   C     WAFR_OE       WHENEQ    '7'
CN   C                   ADD       IVAMWF        OEAMWC
CN   C                   ADD       OEAMEF        OEAMEC
CN   C                   SUB       IVAMWR_S      OEAMWC
CN   C                   SUB       OEAMER_S      OEAMEC
CN   C     WAFR_OE       WHENEQ    '8'
CN   C                   ADD       IVAMWF        OEAMWC
CN   C                   ADD       OEAMEF        OEAMEC
CN   C                   SUB       IVAMWR        OEAMWC
CN   C                   SUB       OEAMER        OEAMEC
CN   C                   SUB       IVAMWR_S      OEAMWC
CN   C                   SUB       OEAMER_S      OEAMEC
B4   C                   ENDSL
CA    * Combined cost cannot be negative
CA   C                   IF        OECD08 <> 'C'                                Not a credit memo
CB   C                   if        oeqy03 > 0
CA   C                   IF        OEAMWC < 0
CA   C                   EVAL      OEAMWC = 0
CA CBC*                  ENDIF
CA CBC*                  IF        OEAMEC < 0
CA   C                   EVAL      OEAMEC = 0
CA   C                   ENDIF
CA   C                   ENDIF
CB   C                   endif
B5    * Do not load combined cost if reason code on credit memos is price credit
B5   C                   IF        OECD08 = 'C' and oecd27 = 'X'                credit memo
B5   C                   EVAL      OEAMWC = 0
B5   C                   EVAL      OEAMEC = 0
B5   C                   ENDIF
     C                   WRITE     OEFTOLY
      *
      * UPDATE C/O ITEM INVOICED DOLLARS TO DATE
      *
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OENO19        CHAIN     OEFTOAH                            4492
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN44         IFEQ      *OFF
     C     OECD43        IFNE      'Y'
     C                   ADD       OEAM05        OAAM48
     C                   ENDIF
     C                   ADD       OEAM17        OAAM49
     C                   EXCEPT    TOAH
     C                   ENDIF
      *
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OAKEY         CHAIN     OEFTOAL                            4492
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN44         IFEQ      *OFF
     C     OECD43        IFNE      'Y'
     C                   ADD       OEAM05        OAAM46                         INVOICED $
     C                   SUB       OEAM05        OAAM47                         UNINVOICED $
     C                   ENDIF
     C                   EXCEPT    TOAL
     C                   ENDIF
      *
      * UPDATE SALES HISTORY
     C     BLDFLG        IFEQ      'Y'
     C     OECD09        IFNE      'C'                                          COMMENTS
     C     OECD09        ANDNE     'A'                                          STK COMBO
     C     OECD09        ANDNE     'K'                                          NONSTK COMBO
     C                   EXSR      UPDSLS
     C                   ENDIF
     C                   ENDIF
      *    CHECK TO SEE IF CUSTOM INDEX NEEDS TO BE REBUILT
     C                   EXSR      CICHK
      *
      *    END OF ITEM
     C                   DELETE    OEFTOL
     C                   END
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OEKEY1        READE     OEFTOL                               9245
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C                   END
      *    ITEM TAGS
     C     OEKEY1        SETLL     OEFTOT
     C     *IN49         DOUEQ     '1'
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OEKEY1        READE     OEFTOT                               9249
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN49         IFEQ      '0'
     C                   WRITE     OEFTOTY
     C                   DELETE    OEFTOT
     C                   END
     C                   END
      *** END OF ORDER
     C                   END
     C                   END
     C                   READ      OEFWBIS                                40
     C                   END
      *** END OF JOB
     C                   SETON                                        LR
     C                   RETURN
      *------------------------------------------------------------------------*
      *  GET THE RUN# FIELD FROM TABLE FILE                                    *
      *------------------------------------------------------------------------*
     C     GETRUN        BEGSR
CC   C     RUN#          ifeq      0
CC   C     RUN#          oreq      9999999
     C                   MOVE      'AR01'        TBNO01                         TABLE CODE 1
     C                   MOVE      *BLANKS       TBNO02                         TABLE CODE 2
     C                   MOVEL     'RUN#    '    TBNO02                         TABLE CODE 2
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     TABKEY        CHAIN     TBFMTBL                            4092
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TBNO03        RUN#
     C     RUN#          IFGT      9999990
     C                   Z-ADD     1             RUN#
     C                   ELSE
     C                   ADD       1             RUN#
     C                   ENDIF
     C                   Z-ADD     RUN#          GLNO05
     C                   MOVEL     GLNO05        TBNO03
     C                   UPDATE    TBFMTBL
     C                   ELSE
     C                   Z-ADD     1             RUN#
     C                   WRITE     TBFMTBL
     C                   END
CC   C                   OUT       BATCH#                                       OUTPUT *LDA
CC   C                   endif
     C                   MOVE      'Y'           RUN#OK            1
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    EXTEND UNIT PRICE                                       *
      *------------------------------------------------------------------------*
     C     PRCEXT        BEGSR
      *
      * CALCULATE NET UNIT PRICE...
      *
     C                   Z-ADD(H)  OEAM42        STKNET
     C     OEPC01        IFNE      *BLANKS
     C                   Z-ADD     OEAM42        PMIUPR
     C                   CLEAR                   PMIUCS
     C                   MOVEL     OEPC01        PMIDSC
     C                   CLEAR                   PMONPR
     C                   CALL      'PRR4947'     PL4947
     C     PMONPR        IFNE      *ZEROS
     C                   Z-ADD(H)  PMONPR        STKNET
     C                   ENDIF
     C                   ENDIF
      * EXTEND...
     C     QYDEF         MULT(H)   STKNET        AMTDEF
     C                   ENDSR
      *------------------------------------------------------------------------*
      * UPDATE SALES
      *------------------------------------------------------------------------*
     C     UPDSLS        BEGSR
      *
      * Initialize Sales Amount and Gross Profit Amount
     C                   Z-ADD     *ZERO         SLSAMT                         SALES AMOUNT
     C                   Z-ADD     *ZERO         CSTAMT                         COST AMOUNT
     C                   Z-ADD     *ZERO         GRSPFT                         GROSS PROFIT
      *
      * Retrieve division and region from the Branch Master
     C     OENO08        CHAIN     ARFMBCH                            44
      *
      * Retrieve Enterprise and Market Type from the Customer Master
     C     ARNO01        CHAIN     ARFMCUS                            45
      *
      * Retrieve purchasing section/group/category from item master
     C     IVNO07        IFNE      *ZERO
     C     IVNO07        CHAIN     IVFMSTR                            46
     C     *IN46         IFEQ      *OFF
     C     OEQY03        ANDGT     *ZEROS
     C                   MOVE      'C'           PTYPE
     C                   Z-ADD     IVNO07        HITEM
     C                   Z-ADD     ARNO01        PFOR
     C                   CALL      'HZR0002'     PL0002
     C                   ENDIF
     C                   ELSE
     C                   MOVE      NSKSEC        IVCD17
     C                   MOVE      *BLANKS       IVCD18
     C                   MOVE      *BLANKS       IVCD19
     C                   ENDIF
      *
      * Populate Sales Amount and Gross Profit Amounts
     C     OECD43        IFNE      'Y'                                          NO CHARGE ITEM
     C                   Z-ADD     OEAM05        SLSAMT                         SALE AMOUNT
     C                   Z-ADD     OEAM17        CSTAMT                         COST AMOUNT
     C     OEAM05        SUB       OEAM17        GRSPFT                         GROSS PROFIT
     C                   ELSE
     C                   Z-ADD     *ZEROS        SLSAMT                         SALE AMOUNT
     C                   Z-ADD     OEAM17        CSTAMT                         COST AMOUNT
     C     *ZEROS        SUB       OEAM17        GRSPFT                         GROSS PROFIT
     C                   ENDIF
      *
      * WRITE A/R INVOICE WORK FILE RECORD
     C                   Z-ADD     ARNO15        COMPNY
     C                   MOVE      GLCD41        DIVISN
     C                   MOVE      GLCD42        REGION
     C                   Z-ADD     OENO08        BRANCH
     C                   Z-ADD     OECC08        SLSCC
     C                   Z-ADD     OEYR08        SLSYR
     C                   Z-ADD     OEMO08        SLSMO
     C                   Z-ADD     INVCC         INCC01
     C                   Z-ADD     INVYR         INYR01
     C                   Z-ADD     INVMTH        INMO01
     C                   Z-ADD     INVDAY        INDY01
     C                   Z-ADD     ARNO82        ENTNUM
     C                   Z-ADD     ARNO01        CUSNUM
     C                   MOVEL     ARCD02        MKTTYP
     C                   MOVEL     OEID02        SLSID
     C                   MOVE      IVCD17        PURSEC
     C                   MOVE      IVCD18        PURGRP
     C                   MOVE      IVCD19        PURCAT
   B2C*                  Z-ADD     OENO01        ORDNUM
B2   C                   MOVE      OENO01        ORDNUM
     C                   WRITE     OEFWINV
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * CUSTOM INDEX REBUILD CHECK
      *------------------------------------------------------------------------*
     C     CICHK         BEGSR
      * GET TABLE ENTRY FOR BOOK TYPE
     C                   MOVE      *BLANKS       TBNO02
     C                   MOVE      *BLANKS       TBNO01
     C                   MOVEL     'WEB '        TBNO01
     C                   MOVEL     'BOOKTYPE'    TBNO02
     C     TABKEY        CHAIN(N)  TBFMTBL                            40
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TBNO03        BTYPE             1
     C                   END
     C     ARNO01        CHAIN     OEFMCUS                            40
     C     *IN40         IFEQ      *OFF
     C     WBFL07        ANDEQ     'Y'
     C     WBFL06        ANDNE     'Y'
     C     ARNO01        CHAIN     WBFMWBH                            40
     C     *IN40         IFEQ      *OFF
     C                   SELECT
     C     BTYPE         WHENEQ    'C'
     C                   MOVE      IVCD01        IVCDD5
     C                   MOVE      IVCD02        IVCDD6
     C                   MOVE      IVCD03        IVCDD7
     C     BTYPE         WHENEQ    'P'
     C                   MOVE      IVCD17        IVCDD5
     C                   MOVE      IVCD18        IVCDD6
     C                   MOVE      IVCD19        IVCDD7
     C     BTYPE         WHENEQ    'S'
     C                   MOVE      IVCD14        IVCDD5
     C                   MOVE      IVCD15        IVCDD6
     C                   MOVE      IVCD16        IVCDD7
     C                   ENDSL
     C     WBLKEY        SETLL     WBFMWBL                                41
     C     *IN41         IFEQ      *ON
     C                   MOVE      'Y'           WBFL06
     C                   EXCEPT    UPDCUS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Load new WAC to Branch Master and create adjustment record
      *------------------------------------------------------------------------*
     C     WACADJ        BEGSR
   BV * Load weighted average cost to be updated to branch master
   BVC*                  Z-ADD     OEAM41        IVAMW6
   BV * Load field for record to be written to Adjustments Transactions
   BVC*                  Z-ADD     BINO14        AJNO14
BV   C     OECD09        IFEQ      'S'
BV   C     OECD09        OREQ      'G'
BV   C                   Z-ADD     OEAM41        IVAMW6
B4   C                   Z-ADD     OEAMWF        IVAMWF
CA   C                   Z-ADD     OEAMWR        IVAMWR
CN   C                   Z-ADD     OEAMWR_S      IVAMWR_S
BV   C                   Z-ADD     BINO14        AJNO14
BV   C                   MOVEL     'S'           IVCDE5                         stk/non-stk
BV   C                   CLEAR                   IVNON1                         non-stock id
BV   C                   ELSE
BV   C                   Z-ADD     OEAM41        NBAMW6
B4   C                   Z-ADD     OEAMWF        NBAMWF
CA   C                   Z-ADD     OEAMWR        NBAMWR
CN   C                   Z-ADD     OEAMWR_S      NBAMWR_S
BV   C                   CLEAR                   AJNO14
BV   C                   MOVEL     'N'           IVCDE5                         stk/non-stk
BV   C                   MOVEL     IVNO04        IVNON1                         non-stock id
BV   C                   ENDIF
     C                   MOVEL     OEID01        IVID02                         Sales Init
     C                   MOVE      'W'           IVCD35                         Reason Code
     C                   MOVEL     MSG001        IVDN17                         Reason Desc
     C                   MOVE      OENO01        IVDN17                         Order Number
     C                   Z-ADD     *ZEROS        IVQY24                         Qty Adj
     C                   Z-ADD     OEAM41        IVAMY7                         Cost Adj
     C                   MOVEL     USRNM         IVNM01                         User Name
     C                   Z-ADD     OENO16        IVNO10                         Branch
   BVC*                  MOVEL     *YEAR         IVCC17                         Lst Cent Adj
   BVC*                  Z-ADD     UYEAR         IVYR17                         Lst Year Adj
   BVC*                  Z-ADD     *MONTH        IVMO17                         Lst Mth  Adj
   BVC*                  Z-ADD     *DAY          IVDY17                         Lst Day  Adj
   BVC*                  TIME                    IVTM01                         Update Time
   BVC*                  MOVEL     *YEAR         IVCC01                         Update Cntry
   BVC*                  Z-ADD     UYEAR         IVYR01                         Update Year
   BVC*                  Z-ADD     *MONTH        IVMO01                         Update Month
   BVC*                  Z-ADD     *DAY          IVDY01                         Update Day
BV   C                   MOVEL     ROLEXP        IVTM01
BV   C                   MOVE      ROLEXP        IVDT01
BV   C                   MOVE      ROLEXP        IVDT17
   BZC*                  Z-ADD     SVQY01        IVQYX8                         QOH bfor adj
BZ   C                   Z-ADD     OHBEF         IVQYX8                         QOH bfor adj
     C                   Z-ADD     BEFWAC        IVAMY8                         WAC bfor adj
B4   C                   Z-ADD     BEFWAF        IVAMY8_WAF                     WAC bfor adj
CA   C                   Z-ADD     BEFWAR        IVAMY8_WAR                     WAR bfor adj
CN   C                   Z-ADD     BEFWAS        IVAMY8_WAS                     WAR bfor adj
     C                   MOVE      *BLANKS       IVNO39                         Adj Ref Nbr
     C                   MOVE      *BLANK        IVCD54                         Adj Ref Type
     C                   Z-ADD(H)  *ZEROS        IVTL11                         Tot Cst b4 adj
     C                   Z-ADD(H)  *ZEROS        IVTL12                         Tot Cst aft adj
   BVC*                  Z-ADD     IVAMW6        IVAMZ3                         WAC aft adj
BV   C                   Z-ADD     OEAM41        IVAMZ3                         WAC aft adj
B4   C                   Z-ADD     OEAMWF        IVAMZ3_WAF                     WAC aft adj
CA   C                   Z-ADD     OEAMWR        IVAMZ3_WAR                     WAR aft adj
CN   C                   Z-ADD     OEAMWR_S      IVAMZ3_WAS                     WAR aft adj
     C                   MOVE      *BLANKS       IVDN30                         Frzn Prc UOM
   BVC*                  MOVEL     'S'           IVCDE5                         stk/non-stk
BV   C                   MOVE      'CRM'         IVCDE7
   BVC*                  MOVE      *BLANKS       IVCDE7
   BVC*                  CLEAR                   IVNON1                         non-stock id
     C                   MOVEL     ROLEXP        IVTM10
     C                   MOVE      ROLEXP        ADJPDT
     C                   Z-ADD     SALPRD        ADJAPD
      *  Get Control #
     C                   EXSR      CNTRL#
     C                   WRITE     IVFTADJ
     C     IVAMY8        IFNE      IVAMZ3
     C                   WRITE     IVFWACA
     C                   ENDIF
B4    * Write to adjustment transaction WAF file...
B4   C     IVAMY8_WAF    IFNE      IVAMZ3_WAF
B4   C                   Z-ADD     IVNO07        IVNO07_WAF
B4   C                   Z-ADD     IVNO10        IVNO10_WAF
B4   C                   Z-ADD     IVNO40        IVNO40_WAF
B4   C                   Z-ADD     OEAMWF        IVAMY7_WAF                     Cost Adj
B4    * This field was already loaded----------> IVAMY8_WAF                     WAC bfor adj
B4   C                   CLEAR                   IVAMZ1_WAF
B4    * This field was already loaded----------> IVAMZ3_WAF                     WAC aft adj
B4   C                   Z-ADD     OHBEF         IVQYX8_WAF                     QOH bfor adj
B4   C                   Z-ADD     IVQY24        IVQY24_WAF                     Qty Adj
B4   C                   MOVEL     IVCDE5        IVCDE5_WAF                     stk/non-stk
B4   C                   MOVE      IVCDE7        IVCDE7_WAF
B4   C                   MOVE      ROLEXP        IVDT17_WAF
B4   C                   MOVEL     ROLEXP        IVTM01_WAF
B4   C                   MOVEL     IVNM01        IVNM01_WAF                     User Name
B4   C                   MOVEL     IVNON1        IVNON1_WAF                     non-stock id
B4   C                   WRITE     IVFWAFA
B4   C                   ENDIF
CA    * Write to adjustment transaction WAR file...
CA   C     IVAMY8_WAR    IFNE      IVAMZ3_WAR
CA   C                   Z-ADD     IVNO07        IVNO07_WAR
CA   C                   Z-ADD     IVNO10        IVNO10_WAR
CA   C                   Z-ADD     IVNO40        IVNO40_WAR
CA   C                   Z-ADD     OEAMWR        IVAMY7_WAR                     Cost Adj
CA    * This field was already loaded----------> IVAMY8_WAR                     WAR bfor adj
CA   C                   CLEAR                   IVAMZ1_WAR
CA    * This field was already loaded----------> IVAMZ3_WAR                     WAR aft adj
CA   C                   Z-ADD     OHBEF         IVQYX8_WAR                     QOH bfor adj
CA   C                   Z-ADD     IVQY24        IVQY24_WAR                     Qty Adj
CA   C                   MOVEL     IVCDE5        IVCDE5_WAR                     stk/non-stk
CA   C                   MOVE      IVCDE7        IVCDE7_WAR
CA   C                   MOVE      ROLEXP        IVDT17_WAR
CA   C                   MOVEL     ROLEXP        IVTM01_WAR
CA   C                   MOVEL     IVNM01        IVNM01_WAR                     User Name
CA   C                   MOVEL     IVNON1        IVNON1_WAR                     non-stock id
CA   C                   WRITE     IVFWARA
CA   C                   ENDIF
CN    * Write to adjustment transaction WAS file...
CN   C     IVAMY8_WAS    IFNE      IVAMZ3_WAS
CN   C                   Z-ADD     IVNO07        IVNO07_WAS
CN   C                   Z-ADD     IVNO10        IVNO10_WAS
CN   C                   Z-ADD     IVNO40        IVNO40_WAS
CN   C                   Z-ADD     OEAMWR_S      IVAMY7_WAS                     Cost Adj
CN    * This field was already loaded----------> IVAMY8_WAS                     WAR bfor adj
CN   C                   CLEAR                   IVAMZ1_WAS
CN    * This field was already loaded----------> IVAMZ3_WAS                     WAR aft adj
CN   C                   Z-ADD     OHBEF         IVQYX8_WAS                     QOH bfor adj
CN   C                   Z-ADD     IVQY24        IVQY24_WAS                     Qty Adj
CN   C                   MOVEL     IVCDE5        IVCDE5_WAS                     stk/non-stk
CN   C                   MOVE      IVCDE7        IVCDE7_WAS
CN   C                   MOVE      ROLEXP        IVDT17_WAS
CN   C                   MOVEL     ROLEXP        IVTM01_WAS
CN   C                   MOVEL     IVNM01        IVNM01_WAS                     User Name
CN   C                   MOVEL     IVNON1        IVNON1_WAS                     non-stock id
CN   C                   WRITE     IVFWASA
CN   C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      * Get Adjustment Control Number
      *------------------------------------------------------------------------*
     C     CNTRL#        BEGSR
      *
   BXC*                  MOVE      *IN92         SVIN92            1            SAVE *IN92
   BXC*                  MOVE      *BLANKS       DSPF1
   BXC*    *IN92         DOUEQ     *OFF
   BXC*    *LOCK         IN        WKADJN                               92
   BXC*    *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
   BXC*                  ENDCS
   BXC*                  ENDDO
   BXC*                  MOVE      SVIN92        *IN92                          RESTORE *IN92
   BXC*                  MOVE      WKADJN        IVNO40
   BXC*    IVNO40        SETLL     IVFTADJ                                43    P.O. EXIST ?
   BXC*    *IN43         DOWEQ     '1'
   BXC*    IVNO40        OREQ      *ZERO
   BXC*                  ADD       1             IVNO40
   BXC*    IVNO40        SETLL     IVFTADJ                                43    P.O. EXIST ?
   BXC*                  END
   BXC*    IVNO40        ADD       1             WKADJN
   BXC*                  OUT       WKADJN
   BX *
BX    * Call program to get adjustment number
BX   C                   CLEAR                   CtlNbr
BX   C                   CALL      'IVR9312'     PL9312
BX   C                   Z-ADD     CtlNbr        IVNO40
     C                   ENDSR
      *------------------------------------------------------------------------*
      * UNLOCK RECORD SUBROUTINE
      *------------------------------------------------------------------------*
     C     UNLOCK        BEGSR
     C                   MOVE      *BLANK        DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   ENDSR
      *----------------------------------------------------------------
      *  THIS SUBROUTINE WILL WRITE WAC EXCEPTION AUDIT RECORD             *
      *------------------------------------------------------------------------*
     C     WRTWEA        BEGSR
      *
     C     BEFWAC        IFNE      *ZEROS
     C                   Z-ADD     *ZEROS        WAPC21
BV   C     OECD09        IFEQ      'S'
BV   C     OECD09        OREQ      'G'
     C     IVAMW6        SUB       BEFWAC        CHGWAC
BV   C                   ELSE
BV   C     NBAMW6        SUB       BEFWAC        CHGWAC
BV   C                   ENDIF
     C     CHGWAC        DIV(H)    BEFWAC        WAPCT1            5 2
     C     WAPCT1        MULT      100           WAPC21                         WAC CHG%
     C     WAPC21        IFGT      TOLPC                                        TOL %
     C     WAPC21        ORLT      TOLPCN                                       NEG TOL %
     C                   Z-ADD     IVNO10        WANO10
   B2C*                  Z-ADD     IVNO40        WANO66
B2   C                   MOVE      IVNO40        WANO66
     C                   Z-ADD     *ZEROS        WANO90
   BVC*                  Z-ADD     IVNO07        WANO07
     C                   Z-ADD     IVQY24        WAQY04
     C                   Z-ADD     IVAMY7        WAAM07
     C                   Z-ADD     *ZEROS        WAAMZ1
     C                   Z-ADD     BEFWAC        WAAMAG
BV   C     OECD09        IFEQ      'S'
BV   C     OECD09        OREQ      'G'
BV   C                   CLEAR                   WANON1
BV   C                   Z-ADD     IVNO07        WANO07
     C                   Z-ADD     IVAMW6        WAAMW6
BV   C                   ELSE
BV   C                   CLEAR                   WANO07
BV   C                   MOVEL     NBNON1        WANON1
BV   C                   Z-ADD     NBAMW6        WAAMW6
BV   C                   ENDIF
     C                   MOVE      USRNM         WANM01
     C                   MOVE      ROLEXP        WAEDTE
     C                   MOVEL     ROLEXP        WATM01
     C                   MOVEL     'ARR7915'     WAPGM
     C                   WRITE     IVFTWEA
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
BV    *------------------------------------------------------------------------*
BV    * Subroutine to update non-stock inventory                               *
BV    *------------------------------------------------------------------------*
BV   C     UPDNSI        BEGSR
BV   C                   MOVE      *IN49         SVIN49            1
BV   C                   MOVE      *IN92         SVIN92            1
BV   C                   Z-ADD     OENO16        NBNO10
BV   C                   MOVEL     IVNO04        NBNON1
BV   C                   EXSR      GETNSB
BV    *
BV   C     NSBFND        IFEQ      *ON
BV    * GET PROCESS DATE AND TIME - TRANSACTION
BV   C                   CALL      'OPC0061'     PL0061
BV   C                   MOVE      ROLEX         ROLEXP                         PROCESS/DATE/TI
BV   C                   Z-ADD     NBAMW6        BEFWAC
B4   C                   Z-ADD     NBAMWF        BEFWAF
CA   C                   Z-ADD     NBAMWR        BEFWAR
CN   C                   Z-ADD     NBAMWR_S      BEFWAS
BZ    * SAVE ON HAND AND WAC BEFORE UPDATE
BZ   C                   Z-ADD     NBQY01        OHBEF
BZ   C                   Z-ADD     NBAMW6        WACBEF
B4   C                   Z-ADD     NBAMWF        WAFBEF
CA   C                   Z-ADD     NBAMWR        WARBEF
CN   C                   Z-ADD     NBAMWR_S      WASBEF
BV    *   SPECIAL ?
BV   C     OECD16        IFEQ      'S'                                          SPECIAL
BV   C     OECD09        IFNE      'K'                                          NOT COMBO
BV   C     OECD08        IFEQ      'O'                                          ORDER
BV   C     OECD08        OREQ      'C'                                          CREDIT
BV   C     IVCD79        ANDEQ     'Y'                                          AFFECT INV
BV   C     OECD08        OREQ      'D'                                          DEBIT
BV   C     IVCD79        ANDEQ     'Y'                                          AFFECT INV
BV   C                   SUB       OEQY03        NBQY01                         QTY ON HAND
BV   C                   ENDIF
BV   C                   ENDIF
BV   C                   ELSE
BV    *   CREDIT MEMO ?
BV   C     OECD08        IFEQ      'C'                                          CREDIT MEMO
BV   C     OECD09        IFNE      'K'                                          NOT COMBO
BV   C     OECD16        ANDNE     'D'                                          NOT DIRECT
BV   C     IVCD79        ANDEQ     'Y'                                          AFFECT INV
BV BZC*                  Z-ADD     NBQY01        SVQY01                         SAVE ON HAND
BV   C                   SUB       OEQY03        NBQY01                         QTY ON HAND
BV    *
BV BZC*    SVQY01        IFEQ      *ZEROS
BZ   C     OEQY03        IFLT      0
BZ CIC*    OHBEF         ANDEQ     *ZEROS
CI   C     OHBEF         ANDLE     *ZEROS
BV   C     NBQY01        ANDGT     *ZEROS
BV B4C*    OEAM41        ANDNE     NBAMW6
B4 CDC*    OEAM41        IFNE      NBAMW6
CD CMC*    OEAMWC        IFNE      NBAMWC
CM   C     OEAM41        IFNE      NBAMW6
B4   C     OEAMWF        ORNE      NBAMWF
CA   C     OEAMWR        ORNE      NBAMWR
CN   C     OEAMWR_S      ORNE      NBAMWR_S
BV   C                   EXSR      WACADJ
BZ   C                   Z-ADD     NBAMW6        WACBEF
B4   C                   Z-ADD     NBAMWF        WAFBEF
CA   C                   Z-ADD     NBAMWR        WARBEF
CN   C                   Z-ADD     NBAMWR_S      WASBEF
B4   C                   ENDIF
BV   C                   ENDIF
BV   C                   ENDIF
BV    *
BV   C                   ELSE
BV    *   DEBIT ?
BV   C     OECD16        IFNE      'D'                                          NOT DIRECT'S
BV   C     OECD08        IFEQ      'D'
BV   C     OECD09        IFNE      'K'                                          NOT COMBO
BV   C     IVCD79        ANDEQ     'Y'                                          AFFECT INV
BV   C                   SUB       OEQY03        NBQY01                         QTY ON HAND
BV   C                   ENDIF
BV   C                   ELSE
BV    *   ORDER ?
BV   C     OECD09        IFNE      'K'                                          NOT COMBO
BV   C                   SUB       OEQY03        NBQY01                         QTY ON HAND
BV   C                   ENDIF
BV   C                   ENDIF
BV   C                   ENDIF
BV   C                   ENDIF
BV   C                   ENDIF
BV    *
BV   C                   MOVE      *BLANKS       NBNM01
BV   C                   MOVEL     'INVOICE'     NBNM01
BV   C                   MOVEL     *YEAR         NBCC01
BV   C                   Z-ADD     UYEAR         NBYR01
BV   C                   Z-ADD     UMONTH        NBMO01
BV   C                   Z-ADD     UDAY          NBDY01
BV   C     OECD01        IFNE      'D'
B5    * Do not load WAC if reason code on credit memos is price credit
BV   C     OECD09        IFEQ      'X'
B5   C     OECD27        ANDNE     'X'
BV   C     OECD09        OREQ      'N'
B5   C     OECD27        ANDNE     'X'
BV   C                   Z-ADD     NBAMW6        OEAM14
BV   C     OEQY03        MULT(H)   OEAM14        OEAM18
B4   C                   Z-ADD     NBAMWF        OEAMWF
B4   C     OEQY03        MULT(H)   OEAMWF        OEAMEF
CA   C                   Z-ADD     NBAMWR        OEAMWR
CA   C     OEQY03        MULT(H)   OEAMWR        OEAMER
CN   C                   Z-ADD     NBAMWR_S      OEAMWR_S
CN   C     OEQY03        MULT(H)   OEAMWR_S      OEAMER_S
BV   C                   ENDIF
BV   C                   ENDIF
BV    * Load transaction parms to pass to IVR0940...
BV   C                   CLEAR                   PMNO07
BV    * Transaction type...
BV   C                   MOVE      'INV'         PMCDF3
BV    * Transaction number/sequence#/quantity/wac...
BV B2C*                  Z-ADD     OENO01        PMNOA1
B2   C                   MOVE      OENO01        PMNOA1
BV   C                   Z-ADD     OENO09        PMNOA2
BV   C                   Z-SUB     OEQY03        PMQYAB
BV   C                   Z-ADD     OEAM14        PMAMAI
BV    * RECORD ANY CHANGE TO ON HAND OR WAC...
BV   C                   CALL      'IVR0940'
BV   C                   PARM                    NBNO10
BV   C                   PARM                    PMNO07
BV   C                   PARM                    NBQY01
BV   C                   PARM                    NBAMW6
B4   C                   PARM                    NBAMWF                         Weighted Average Frt
B4   C                   PARM                    NBAMWR            9 4          Reb = N/A for NonStk
B4   C                   PARM                    NBAMWC                         Combined WAC
BV   C                   PARM      'ARR7915'     PGM              10
BV   C                   PARM                    ROLEXP                         PROCESS/DATE/TI
BV   C                   PARM                    NBNON1                         Nonstock ID
BV   C                   PARM                    PMCDF3            3            Tran type
BV B2C*                  PARM                    PMNOA1            7 0          Tran number
B2   C                   PARM                    PMNOA1            7            Tran number
BV   C                   PARM                    PMNOA2            3 0          Tran seq #
BV   C                   PARM                    PMQYAB            7 0          Tran qty
BV   C                   PARM                    PMAMAI            9 4          Tran wac
CN   C                   PARM                    IVAMWR_S                       Tran wac
BV   C                   EXCEPT    UPDNSB
BZ    * SAVE ON HAND AND WAC AFTER UPDATE
BZ   C                   Z-ADD     NBQY01        OHAFT
BZ   C                   Z-ADD     NBAMW6        WACAFT
B4   C                   Z-ADD     NBAMWF        WAFAFT
CA   C                   Z-ADD     NBAMWR        WARAFT
CN   C                   Z-ADD     NBAMWR_S      WASAFT
BV    *
BV    *  WRITE THE WAC EXCEPTION RECORD IF WAC CHANGES OVER CERTAIN %
BV   C                   EXSR      WRTWEA
BV   C                   ENDIF
BV   C                   MOVE      SVIN92        *IN92
BV   C                   MOVE      SVIN49        *IN49
BV   C                   ENDSR
BV    *----------------------------------------------------------------
BV    * Subroutine to retrieve the non-stock branch item master for
BV    * update purposes.
BV    *----------------------------------------------------------------
BV   C     GETNSB        BEGSR
BV   C                   MOVE      *IN42         SVIN42            1
BV   C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
BV   C                   MOVE      *OFF          NSBFND            1
BV   C                   CLEAR                   DSPF1
BV    * Open non-stock branch item master...
BV   C     OPNNSB        IFNE      *ON
BV   C                   MOVE      *ON           OPNNSB            1
BV   C                   OPEN      IVLMNSB1
BV   C                   ENDIF
BV    * Retrieve non-stock branch item master...
BV   C     *IN92         DOUEQ     *OFF
BV   C     NSBKEY        CHAIN     IVFMNSB                            4292
BV   C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
BV   C                   ENDCS
BV   C                   ENDDO
BV    * If non-stock branch item master doesn't exist, create it...
BV   C     *IN42         IFEQ      *ON
BV   C                   CALL      'IVR0215'
BV   C                   PARM                    NBNO10                         BRANCH NUMBER
BV   C                   PARM                    NBNON1                         NON-STOCK ID
BV    * Retrieve newly created NSB...
BV   C                   CLEAR                   DSPF1
BV   C     *IN92         DOUEQ     *OFF
BV   C     NSBKEY        CHAIN     IVFMNSB                            4292
BV   C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
BV   C                   ENDCS
BV   C                   ENDDO
BV   C                   ENDIF
BV    * Set record retrieved flag...
BV   C     *IN42         IFEQ      *OFF
BV   C                   MOVE      *ON           NSBFND
BV   C                   ENDIF
BV    *
BV   C                   MOVE      SVIN92        *IN92
BV   C                   MOVE      SVIN42        *IN42
BV   C                   ENDSR
BX    *----------------------------------------------------------------
BX    *  THIS SUBROUTINE WILL CALCULATE CONSIGNMENT AMOUNT                 *
BX    *------------------------------------------------------------------------*
BX   C     CONSIGN       BEGSR
BX   C                   Z-ADD     *ZEROS        QYDIFF
BX   C                   Z-ADD     *ZEROS        WKQYDIFF
BX   C                   Z-ADD     *ZEROS        WKQTYDIF
BX   C                   Z-ADD     *ZEROS        IVQYDIFF
BX    * RTV CONSIGNMENT MASTER
BX    * Calculate own quantity in IVQYDIFF
BX   C     MCBIKY        CHAIN     IVFMCBI                            40
BX   C     *IN40         IFEQ      *off
BX   C                   Z-ADD     OEQY03        WKOEQY03
BX   C                   CALL      'IVR1693'     PL1693                         LOT UPDATE PGM
BX    * CONSIGNMENT QTY?
BX    * BYPASS consignment calculation if negative,
BX    * ordered qty consider owned
BX   C     QYDIFF        IFGT      *ZEROS
BX   C                   Z-ADD     1.0           PRCFCT
BX   C                   Z-ADD     1.0           ORDFCT
BX   C                   Z-ADD     QYDIFF        WKQYDIFF         15 5
BX   C                   Z-ADD     QYDIFF        WKQTYDIF          7 0
BX   C                   MOVE      'P'           M1IVCD08
BX    * GET PRICING UOM
BX   C     MUOMKY        CHAIN     IVFMUOM                            40
BX   C     *IN40         IFEQ      *off
BX   C                   Z-ADD     M1IVQY12      PRCFCT
BX   C                   Endif
BX   C     UOMKEY        CHAIN     IVFMUOM3                           40
BX   C     *IN40         IFEQ      *off
BX   C                   Z-ADD     M3IVQY12      ORDFCT
BX   C                   Endif
BX   C                   Z-ADD     OEAM02        WKAMT41          11 5
BX   C     PRCFCT        IFNE      *ZEROS
BX   C     OEAM02        DIV(H)    PRCFCT        WKAMT41          11 5
BX   C                   Endif
BX   C     WKAMT41       MULT(H)   ORDFCT        WKAMT40          11 5
BX   C     WKAMT40       MULT(H)   WKQYDIFF      OEAM56
BX    * Consignment Contra Cost (WAC)
BX   C     WKQTYDIF      MULT(H)   OEAM14        OEAM57
BX    * UPDATE CONSIGNMENT FILES
BX   C                   MOVE      'SO'          TRANTYPE
BX   C                   CALL      'IVR1601'     PL1601                         LOT UPDATE PGM
BX    * Get wac variance
BX   C                   Z-ADD     0             OEAM58                         WAC variance
BX   C                   Z-ADD     COnHandB      PMIOB                          OH B4
BX   C                   Z-ADD     WACBEF        PMIWB                          WAC B4
BX   C                   Z-ADD     COnHandA      PMIOA                          OH after
BX   C                   Z-ADD     WACAFT        PMIWA                          WAC after
BX   C                   Z-ADD     0             PMIRVB                         Rcvr val b4
BX   C                   Z-SUB     OEAM57        PMIRVA                         Rcvr val aft
BX   C                   CALL      'IVR6111'     PL6111
BX   C                   Z-SUB     PMOWV         OEAM58                         WAC variance
BX   C                   Endif
BX   C                   Endif
BX   C                   ENDSR
CT    *------------------------------------------------------------------------*
CT    *  This subroutine will update ARQTSTAT with figures from OEPTOHY        *
CT    *------------------------------------------------------------------------*
CT   C     UPDSTATS      BEGSR
CT
CT   C     statKey       chain     arqtstat01
CT   C                   if        not %found(arqtstat01)
CT   C                   clear                   arftstat
CT   C                   eval      st_arno15 = arno15
CT   C                   eval      st_arno16 = oeno08
CT   C                   eval      st_oeid02 = oeid02
CT CUC*                  eval      st_arcc01 = arcc01
CT CUC*                  eval      st_aryr01 = aryr01
CT CUC*                  eval      st_armo01 = armo01
CU   C                   eval      st_oecc08 = oecc08
CU   C                   eval      st_oeyr08 = oeyr08
CU   C                   eval      st_oemo08 = oemo08
CT   C                   endif
CT
CT   C                   if        oecd08 <> 'C'
CT   C                   eval      st_sacn02 += 1

¢E   C                   monitor
¢E   C                   eval      st_sacn03 += oecn01
¢E   C                   on-error
¢E   C                   eval      st_sacn03 = *hival
¢E   C                   endmon

¢E   C                   monitor
¢E   C                   eval      st_sacn05 += (oecn01 - oecn05)
¢E   C                   on-error
¢E   C                   eval      st_sacn05 = *hival
¢E   C                   endmon

CT   C                   eval      st_saam31 += oetl02
CT   C                   eval      st_saam45 += oetl04
CT   C                   else
CT   C                   eval      st_sacn08 += 1
CT   C                   eval      st_saam35 += oetl02
CT   C                   endif
CT
CT   C                   if        %found(arqtstat01)
CT   C                   update    arftstat
CT   C                   else
CT   C                   write     arftstat
CT   C                   endif
CT
CT   C                   ENDSR
C0    *------------------------------------------------------------------------*
C0    *  This subroutine will retrieve lost sales information from OEQTLST     *
C0    *------------------------------------------------------------------------*
C0   C     Rtv_QTLST     BEGSR
C0   C     OEKEY3        Chain     OEQTLST01
C0   C                   If        Not %Found(OEQTLST01)
C0   C                   Leavesr
C0   C                   Endif
C0   C                   If        %Found(OEQTLST01)
C0 C1C*                             and OECDBA <> 'X'
C1   C                              and LOECDBA <> 'X'
C0 C1C*                  Eval      QYDEF = OEQY26
C1   C                   Eval      QYDEF = LOEQY26
C0   C     QYDEF         IfNe      0
C0   C                   Add       QYDEF         IVQY08                         QTY LOST
C0   C                   Exsr      PRCEXT
C0   C     OECD43        IfNe      'Y'
C0   C                   Add       AMTDEF        IVAM17                         AMT QTY LOST
C0   C                   Endif
C0   C                   Endif
C0    * Update process date/time fields
C0 C1C*                  Eval      IVMO77 = *Month
C0 C1C*                  Eval      IVDY77 = *Day
C0 C1C*                  Movel     *Year         IVCC77
C0 C1C*                  Move      *Year         IVYR77
C0 C1C*                  Time                    IVTM20
C0 C1C*                  Z-ADD     SALPRD        OESLPD
C1   C                   Eval      LIVMO77 = *Month
C1   C                   Eval      LIVDY77 = *Day
C1   C                   Movel     *Year         LIVCC77
C1   C                   Move      *Year         LIVYR77
C1   C                   Time                    LIVTM20
C1   C                   Z-ADD     SALPRD        LOESLPD
C0   C                   Except    UpdQLST
C0   C                   Endif
C0   C                   ENDSR
BX    *
      *------------------------------------------------------------------------*
     OOEFTOAH   E            TOAH
     O                       OAAM48
     O                       OAAM49
     OOEFTOAL   E            TOAL
     O                       OAAM46
     O                       OAAM47
     OARFTCCT   E            UPDCRD
     O                       ARCDF6
     O                       ARMO09
     O                       ARDY09
     O                       ARCC09
     O                       ARYR09
     O                       ARNM03
     OOEFMCUS   E            UPDCUS
     O                       WBFL06
     OAPFTINM   E            UPTINM
     O                       APCD62
BV   OIVFMNSB   E            UPDNSB
BV   O                       NBQY01
BV   O                       NBAMW6
B4   O                       NBAMWF
B4   O                       NBAMWC
CA   O                       NBAMWR
CN   O                       NBAMWR_S
BV   O                       NBMO01
BV   O                       NBDY01
BV   O                       NBCC01
BV   O                       NBYR01
BV   O                       NBNM01
CE   OARFTCCT   E            RLSCRD
C0   OOEFTLST   E            UPDQLST
C0 C1O*                      OEMO08
C0 C1O*                      OECC08
C0 C1O*                      OEYR08
C0 C1O*                      IVMO77
C0 C1O*                      IVDY77
C0 C1O*                      IVCC77
C0 C1O*                      IVYR77
C0 C1O*                      IVTM20
C1   O                       LOEMO08
C1   O                       LOECC08
C1   O                       LOEYR08
C1   O                       LIVMO77
C1   O                       LIVDY77
C1   O                       LIVCC77
C1   O                       LIVYR77
C1   O                       LIVTM20
