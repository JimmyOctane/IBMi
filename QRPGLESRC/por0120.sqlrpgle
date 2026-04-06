KM   H option(*srcstmt: *nodebugio) debug
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - POR0120                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D PURCHASE ORDER MAINTENANCE                                            *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    Revise purchase orders, add/change/delete line items.              *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
KM   F*S                                                                       *
KM   F*S   Important: SFDS is used in POR0120 and POR0123.  Any             *
KM   F*S               changes to SFDS in POR0120 must be made to            *
KM   F*S               SFDS in POR0123.                                      *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
G3   F*U 8000009668 080505 002 ONLY GO TO WM FOR TYPE D, O, & F.               *
G5   F*U 1090000299 030106 019 CORRECT ISSUE W/EXT DESC ON PRICING SCRN        *
HA   F*U 1090000312 030606 094 ONLY ALLOW 99 SERIAL NUMBER ON A P/O
HB   F*U 1320000148 051206 238 Stk Qty Fill qty carry to next tag              *
HC   F*U 0420000830 051706 238 Do not allow tag chg if asn exist               *
HD   F*E 8000009886 063006 248 VENDOR CONSIGNED INVENTORY
HE   F*E 8000009570 080906 062 HD/WO INTERFACE
HF   F*U 0520000236 092806 907 REMOVE LIMIT OF 99 SERIAL#
HG   F*U 1290000254 101206 911 All Branch Authority for a Company
HH   F*E 8000010061 011907 915 P/O TO USE NEW FIELD FOR S/O                    *
HI   F*E 8000009966 013007 915 CHANGE S/O NUMBER TO 7 CHARS ALPHA              *
HL   F*U 0970000263 051507 915 ITEMS DELETED FROM PO THRU MAINT                *
HL   F*U 0970000263 062207 019 PRESERVE DELETED ITEM AND WARN USER             *
HM   F*U 0430000262 052307 914 COPY PO HAS ETA DATE FOR BLANKET                *
HN   F*U 0050004134 062707 914 FACTOR ON PO FROM BACKORDER LOWSTOC             *
HP   F*U 1400000310 080207 019 PREVENT MANF# OVERLAY FROM ITEM MASTER          *
HR   F*U 0420000858 031011 248 PO TYPE NOT UPDATED IN WM                       *
HQ   F*U 1700000143 082207 914 CONSIGNED P/O FLAG NOT SAVED                    *
HS   F*E 8000010256 010808 238 Weighted Average Freight                        *
HT   F*E 8000010289 012408 920 THIRD PARTY FREIGHT                             *
HU   F*U 0420000938 020908 914 CROSS COMPANY ORDER NOT GOING TO WM             *
HV   F*U 8000010364 031708 914 PROGESSIVE BILLING UNINVOICE INCORR             *
HW   F*E 8000010307 042908 913 INCREASE PRICE IN O/E FOR REL 12.0              *
HX   F*E 8000010199 050208 020 Messaging                                       *
HY   F*E 8000010335 050708 099 COLUMN COSTING
HZ   F*E 8000010234 052208 920 SET UP AN ITEM AS NON-INVENTORY ITM             *
H0   F*E 8000010441 062608 020 REVISE HD/LM INTERFACE CODE IN R12              *
H1   F*U 1550000268 082508 920 PO NOT FOUND IN P/O MAINTENANCE                 *
H2   F*E 8000010542 082608 070 3RD PARTY FRT FLAG IN PO MAINT                  *
H3   F*E 8000010122 040507 914 VENDOR CONSGN INV CORRECT'N-USR GRP             *
H4   F*U 8000010565 091008 020 Transaction Logging - Phase II                  *
H5   F*U 1430000407 101508 907 INTELLCHIEF CHANGES                             *
IA   F*U 1710000271 112508 127 PO COST CHANGING                                *
IE   F*U 1550000270 011509 085 WRONG ADDRESS ON ROR CREATED PO                 *
IF   F*U 1670000165 012109 085 EDI PO FROM BACKORDER/LOW STOCK                 *
IG   F*U 8000009684 012609 085 DATA QUEUES NOT DELETED                         *
IH   F*U 8000010661 022709 019 Correct issue w/WAF not updating Nonstocks      *
II   F*U 1430000458 081109 002 Correct LQty size for POR0022.                  *
IJ   F*U 1550000281 091809 070 N/S TAG NOT REMOVED FROM SLS ORDER              *
IK   F*E 9000001963 113010 001 Remove message screen format POF0120M           *
IL   F*E 8000010980 030411 019 Force deletion of QTEMP attachment for QQF jobs *
IM   F*E 9000001957 030411 019 Force deletion of QTEMP attachment for QQF jobs *
IO   F*E 8000011196 122711 923 ADD TARGETS & TOTALS TO P/O MAINT               *
IQ   F*U 0840000305 011812 924 PO WON'T STAY CLOSED                            *
IR   F*U 0370000548 012712 924 ADD ABILITY TO FIND A PRODUCT W/POS TO          *
IS   F*U 0100005614 063017 019 Column Cost Not Restored after Qty Changed      *
IV   F*U 0970000435 070412 915 ADD PRODUCT COMMENT ON EDI P/O                  *
IU   F*U 0910000285 080912 924 PO ENTRY NEXT AVAIL LINE                        *
IW   F*U 8000011381 091312 070 FREIGHT NOT ALLOCATED TO NON-STOCKS             *
IX   F*U 1430000359 092612 928 NONSTOCK COMPONENTS ON PO                       *
IY   F*U 0970000473 100412 928 LIST VS. COST IN PO ENTRY/MAINT                 *
IZ   F*E 8000011258 050613 248 INCREASE SIZE OF MANUF NUMBER TO 30             *
I0   F*E 8000011257 071813 921 ADD ABILITY TO INSERT COMMENT LINE IN P/O       *
I1   F*E 8000011257 071913 921 FIX INDICATOR IN PROGRAM FOR THIS TASK          *
I2   F*E 8000011628 110713 930 INC PICKUP TRANS IN TRUCK ROUTE SYS
I4   F*U 0920000198 012914 019 Correct issue with "List exceeds Cost" error    *
I5   F*E 8000011288 030614 915 Restrict ability to override prices             *
JA   F*E 8000011586 032114 915 INTELLICHIEF LICENSE KEY CHECK                  *
JB   F*U 1700000141 051314 915 Coversheet window disp for PO fax               *
JC   F*E 8000011260 060514 019 Add PO Void logic                               *
JD   F*U 0420001402 072214 020 Improve b/o fill at work center
JF   F*U 1110000615 041215 923 MAX PO TAGS ERRONEOUS MSG DISPLAYED             *
JG   F*U 1790000119 050615 915 PURCHASE ORDER NOT CLOSED                       *
JJ   F*U 1550000404 091015 119 JOB LOT PO NEXT AVAIL LINE INCREMENT            *
JK   F*U 1430000537 102315 119 PO FAXES NOT BEING SENT IF NO COVER             *
JL   F*E 1290000374 102315 248 WAR V3 SPECIAL PRICING                          *
JM   F*U 1790000131 102815 119 MULTIPLE SO TAGGING ISSUE ON PO                 *
JN   F*U 1090000556 011516 915 CHANGE CMS TO EMS FOR TASK 8-11257              *
JO   F*E 8000012273 032216 070 WAR V3 CHANGES                                  *
JP   F*U 1550000467 062416 119 PO LINE NUMBER RESEQUENCING ISSUE               *
JR   F*U 1380000283 093016 119 WRONG NEXT AVAIL LINE IN PO HEADER              *
JS   F*U 1430000557 112816 144 PO LINE NOT MATCHING RECEIVER LINES             *
JT   F*U 1550000477 113016 019 Correct issue w/next avail line for Job Lot Po's*
JU   F*U 0520000451 040717 119 PO Receipt Target for a Number ERR              *
JV   F*U 1550000487 042817 019 M Selection causes Job Lot Item Seq Nbr issue   *
JW   F*U 1090000582 111816 019 Line insert issues in purchasing                *
JY   F*E 1290000483 120617 144 INCREASE SIZE OF G/L AMT AND BL FLD             *
JZ   F*E 8000012738 031618 019 PO Total Amount Event                           *
J0   F*E 8000012929 062218 921 Apache FOP Project,P/O Print                    *
J1   F*U 0970000732 100818 915 Direct receiver not unlocking                   *
J2   F*U 8000013106 102318 282 APACHE FORMS - JOBQ QFORMS                      *
J3   F*U 0820000427 012519 915 Prevent tagging to PO Ship To Branch            *
J4   F*U 8000013243 021519 019 Incorrect P/O Tag to S/O tag error occurring    *
J5   F*U 1250000166 090919 915 *V PO COMMENT NOT WORKING                       *
KA   F*U 0970000842 120619 019 Correct issue w/Weight Total using prior item   *
KB   F*E 8000013551 090919 915 Capture promo code on P/O                       *
KC   F*E 8000013132 120620 171 LBMX interface                                  *
KD   F*E 1820000116 012320 019 Protect defaulted Buyer ID from User profile    *
KE   F*E 8000013616 022720 019 Add product search by Line Number               *
KF   F*C 0820000454 031020 404 cost from PO for Direct from Bid                *
KG   F*U 1430000687 052820 404 Manuf# not cleared on PO                        *
KH   F*U 0970000885 101620 019 Prevent loss of cost after Col Qualifier Item   *
KI   F*E 1400000428 101520 169 GL POSTING FOR NON-INV ITEMS                    *
KJ   F*C 0930000635 011723 171 LBMX - RHEEM REQUIREMENTS                       *
KL   F*U 0970000895 040921 171 Numeric operation is too small                  *
KM   F*E 1710001092 092721 404 PO Price Sheet Options                          *
KN   F*E 1710001111 111121 404 Require MFG # on EDI PO's                       *
KO   F*E 1710001117 120221 404 Add F Key to Load Mfg Number                    *
KP   F*C 2030000108 020222 404 Auto Print REC RPT When PO Complete             *
KQ   F*U 1220001983 081222 035 Clear FINDLN field before reuse.                *
KR   F*E 1650000657 082322 275 Fix mulit select in SD-One for pricing sfl      *
KR   F*E                       and rework.                                     *
KT   F*U 0820000544 102822 097 program error item over received                *
KU   F*U 1820000165 032323 035 Correct field being cleared                     *
KV   F*U 2070000109 050123 275 SD_One product prompter corrections             *
KW   F*E 1400000517 060623 169 PREVENT INV & OVERHEAD ITM SAME PO              *
KY   F*U 0430000339 012924 097 po total on completion screen incorrect         *
¢C   F*U LEH   1072 121693 RRB ALLOW NEQATIVE P/O QTY.                         *
¢E   F*U KSB   1401            Require mfg# if po vend is EDI                  *
¢G   F*U KSB   4929 021907 KSB prevent user from sending po chg via EDI        *
¢I   F*U ksb   5238 082808 KSB soft error if ESD item ordered                  *
¢N   F*C ALA   6159 070913 ala Add product lookup                              *
¢O   F*C CLP   6202 021014 clp Disallow order type F and O                     *
¢O   F*C CLP   6202 021014 CLP Issue error if both EDI and Fax/Email           *
¢O   F*C                        are selected                                   *
¢P   F*C DCB   7008 060414 DCB DO NOT ALLOW SLASH ITEMS                        *
¢Q   F*C DCB   7040 022515 DCB ADD BUYER P/O LIMITS                            *
¢R   F*C DCB   7100 101515 DCB CORRECT ISSUE WITH MFGID REQUIRED ERROR         *
¢S   F*C DCB   7115 092616 DCB ENTER ITEM ONCE ON PO                           *
¢T   F*C CLP   6618 062617 CLP Changed PO note for slow items to direct        *
¢T   F*C                       inquiries to Purch instead of to Charles        *
¢U   F*C DCB   7153 122117 DCB CORRECT MAN REPULL VALUE WHEN ITEM CHANGED      *
¢V   F*C RELEASE122 052218 DCB ALWAYS FOLD SCREEN, REMOVE F20=FOLD             *
¢W   F*C KSB   8061 122719 ksb make purch of slow item be hard error           *
¢X   F*C DCB   7216 020320 DCB SHOW MESSAGE IF ORDERING SLOW ITEM              *
¢Y   F*C KSB   8080 061920 ksb make purch of excess item hard error            *
¢Z   F*C DCB   7234 062220 DCB ADD SLOW EXEMPT                                 *
¢1   F*C APB   6914 072020 APB Remove custom profile                           *
¢2   F*C APB   9175 103020 APB Disallow Non Inventory Item exept for Purch     *
¢3   F*C KSB   8110 110920 KSB Change error for disallow NPI inv               *
¢4   F*C APB   9254 081621 APB Fix bug after Cube B upgrade                    *
¢5   F*C APB   9233 080321 APB Use new NPI Codes                               *
¢6   F*C CLP   6999 091321 CLP Replaced CLLITMMST1 with IVLCNPI1               *
¢7   F*C DCB   7290 110821 DCB ITEM VENDOR TO MATCH PO VENDOR IF IN TABLE      *
¢8   F*C DCB   7315 030922 DCB PROTECT ITEM NUMBER IF PO SENT TO VENDOR        *
¢9   F*C APB   9340 052523 APB Validate directs when gross margin is           *
¢9   F*C                       negative.                                       *
#1   F*C APB   9343 061523 APB Change validation of directs to use pricing uom *
#2   F*C DCB   7353 060923 DCB ADD MULTI COMPANY TO ESD                        *
#3   F*C JJF   3024 073123 JJF NPI Hard Stop Transfers/PO's by Company         *
#4   F*C DCB   7355 072423 DCB ADD VENDOR QUOTE AT LINE LEVEL                  *
#5   F*C APB   9348 061623 APB Allow SPS vendors to send a PO change via EDI   *
#5   F*C                       Do not protect item number if SPS vendor ¢8     *
#6   F*C APB   9350 092923 APB Do not allow PO changes if EDI 860 flag is 'N'  *
#7   F*C APB   9353 101723 APB Do not display cost/price msg if invoice is old *
#8   F*C APB   9353 101723 APB Ship date cannot be zero.                       *
#9   F*C 0430000331 092523 097 ADJUSTMENTS FOR 12.3 CONFLICTS                  *
#0   F*C CLP   5132 021425 CLP Avoid NPI errors for branches in TF NPI         *
:A   F*C CLP   5135 021425 CLP -Added F10=Close PO/Open PO                     *
:A   F*C                       -Disallow the update of an item nbr after PO    *
:A   F*C                        has been EDIed to the vendor even if SPS       *
:A   F*C                       -Added last PO line nbr to the position to at   *
:A   F*C                        the top of the detail screen to be used to     *
:A   F*C                        position to the last item                      *
:A   F*C                       -Added PO line nbr to the detail sfl            *
:A   F*C                       -Removed the warning on PO lines over received  *
     F*M ----------------------------------------------------------------------*
¢Q   FIMLCBUY1  IF   E           K DISK
¢1   FIMLMBUY1  IF   E           K DISK
JL   FPOLTRD2   UF   E           K DISK    prefix(r_)
     FPRLMREG1  IF   E           K DISK
     FAPLMMFL1  IF A E           K DISK
     FARLMMUL1  IF   E           K DISK
     FTBLMTBL1  IF   E           K DISK
#0   FTBLMTBL4  IF   E           K DISK
#0   F                                     RENAME(TBFMTBL:TBFMTBL4)
     FARLMBCH4  IF   E           K DISK
     FPRLMPSH2  IF   E           K DISK
     FPRLMPSF1  IF   E           K DISK
     FPRLMPSD3  IF   E           K DISK
HY   FPRLMPSC1  IF   E           K DISK    PREFIX(CC_)
     FIVLMSTRC  IF   E           K DISK
     F                                     RENAME(IVFMSTR:IVFPROD)
     FIVLMMFL1  IF   E           K DISK
     F                                     RENAME(IVFMSTR:IVFITEM)
HL   FIVLMSTR8  IF   E           K DISK
HL   F                                     RENAME(IVFMSTR:ALLITEM)
KA   Fivlmstr9  if   e           k disk    Prefix(VI_)
KA   F                                     rename(ivfmstr:ByVndItm)
     FIVLTTL15  UF   E           K DISK
     FIVLTTH1   IF   E           K DISK
     FIVLTTLK   UF   E           K DISK
     F                                     RENAME(IVFTTL:IVFTTLK)
JM   FIVLTTLZ   IF   E           K DISK
JM   F                                     RENAME(IVFTTL:IVFTTLZ)
     FPOLTLT1   IF   E           K DISK
     FIVLMSBR1  UF   E           K DISK
¢5   FIVLMSBR2  IF   E           K DISK    prefix(I_)
¢5   F                                     RENAME(ivfmsbr:msbr2)
     FIVLMPBT1  IF   E           K DISK
     FIVLTNSK5  UF A E           K DISK
     FOELTOHY8  IF   E           K DISK
     FOELTOLY9  UF   E           K DISK
     FOELTOLY8  IF   E           K DISK
     F                                     RENAME(OEFTOL:OEFTOL8)
     F                                     RENAME(OEFTOLY:OEFTOLY8)
     FOELTOLYO  IF   E           K DISK
     F                                     RENAME(OEFTOL:OEFTOLO)
     F                                     RENAME(OEFTOLY:OEFTOLYO)
JM J4F*OELTOLYN  IF   E           K DISK
JM J4F*                                    RENAME(OEFTOL:OEFTOLN)
JM J4F*                                    RENAME(OEFTOLY:OEFTOLYN)
     FOELTOLV3  IF   E           K DISK
   HEF*WOLTOL1   UF   E           K DISK
   HEF*WOLTOL3   UF   E           K DISK
   HEF*                                    RENAME(WOFTOL:WOTOL3)
     FPOLTOH1   UF   E           K DISK
KB   FPOLTOHA1  UF A E           K DISK
     FPOLTOH6   IF   E           K DISK
     F                                     RENAME(POFTOH:POFTOH6)
     FPOLTOL4   IF   E           K DISK
     F                                     RENAME(POFTOL:POFTOL4)
     FPOPTRVL   O    E             DISK
     FPOLTOA1   IF A E           K DISK
     FPOLTOLA   IF A E           K DISK
     FPOLTTG1   UF A E           K DISK
     FPOLTNT1   IF A E           K DISK
     FOPLMSEC2  IF   E           K DISK
     FPOLTRH3   UF   E           K DISK
     FPOLTRH1   UF   E           K DISK
     F                                     RENAME(POFTRH:POFTRH1)
     FEILADT1   IF   E           K DISK
     FPOLWTAG1  UF A E           K DISK    USROPN
   HEF*WOLTOH1   IF   E           K DISK
HE   FWKLTMOV2  UF   E           K DISK
HE   FWKLTMOV4  UF   E           K DISK
HE   F                                     RENAME(WKFTMOV:WOMOVE)
     FOELTOLYK  UF   E           K DISK
     F                                     RENAME(OEFTOL:OEFTOLK)
     F                                     IGNORE(OEFTOLY)
     FOELTCMB1  IF   E           K DISK
     F                                     IGNORE(OEFTOL)
     F                                     IGNORE(OEFTOLY)
   HIF*                                    IGNORE(WOFTOT)
     FOELTOAH1  IF   E           K DISK    USROPN
     FOELTOAD1  UF A E           K DISK    USROPN
     FOELTOAD2  IF   E           K DISK    USROPN
     F                                     RENAME(OEFTOAD:OEFTOAD2)
     FOELTOAL8  IF   E           K DISK    USROPN
     F                                     RENAME(OEFTOAL:OETOAL8)
     FOELTOALA  UF   E           K DISK    USROPN
     F                                     RENAME(OEFTOAL:OETOALA)
     FOELTOALB  UF   E           K DISK    USROPN
     F                                     RENAME(OEFTOAL:OETOALB)
     FOELTOL14  UF   E           K DISK
     F                                     RENAME(OEFTOL:OETOL14)
     F                                     RENAME(OEFTOLY:OETOLY14)
     FOELTOL15  IF   E           K DISK
     F                                     RENAME(OEFTOL:OETOL15)
     F                                     RENAME(OEFTOLY:OETOLY15)
     FWXLTXRF1  IF   E           K DISK
IR   FPOPWPOL   UF A E           K DISK
KE   FPOPWPOLL  UF A E           K DISK
HZ   FIVLMSTIN  IF   E           K DISK
HZ   F                                     RENAME(IVFMSTR:MSTRIN)
IO   FIMLWTGT1  IF   E           K DISK
KM   FPOQTOLA01 IF A E           K DISK    PREFIX(Z)
KR   FSHLCLIP1  UF A E           K DISK
¢5 ¢6F*CLLITMMST1IF   E           K DISK
¢6   FIVLCNPI1  IF   E           K DISK    Prefix(NP_)
     FPOD0120   CF   E             WORKSTN
     F                                     INFDS(FIL1DS)
     F                                     SFILE(POS0120E:RRN)
     F                                     SFILE(POS0120F:RNO)
     F                                     SFILE(POS0120G:RRN)
     F                                     SFILE(POS0120I:RRN)
     F                                     SFILE(POS0120J:RRN)
     F                                     SFILE(POS0120K:RRN)
     F                                     SFILE(POS0120N:RRN)
     F                                     SFILE(POS0120P:SORRN)
     F                                     SFILE(POS0120R:RNR)
HE    *------------------------------------------------------------------------*
HE    /COPY QCPYSRC,HDYPROTO
JA    /COPY QCPYSRC,MNYPROTO
HE    *------------------------------------------------------------------------*
JL   D fl67cnt         S              5  0
JL   D savfl67         S                   like(pofl67)
      * WHEN THE VALUE OF KY OR OS IS CHANGED THE VALUE
      * OF MAXKY MUST BE CHANGED AS WELL!!!!!!!!!
     D KY              S              3  0 DIM(990) ASCEND                      TAG & HOLD KEY
     D TH              S             85    DIM(990)
      *
     D OS              S             10  0 DIM(990)                             S.O. TAG REF
     D PL              S              3  0 DIM(990)
     D FC              S              1    DIM(8)                               CHAIN DSC OR DSC
     D AD              S              1    DIM(50)                              ALT MAIL ADDRESS
     D NSI             S             12    DIM(400)                             PREV NS ITEMS
     D ARY             S              1    DIM(140) CTDATA PERRCD(70)           SUBMIT JOB
     D TEL             S              1    DIM(32)                              TELEPHONE ARRAY
     D PS              S              1    DIM(10)                              PREFIX/SUFFIX ARRAY
   J2D*FX              S             53    DIM(4) CTDATA PERRCD(1)
J2   D FX              S             53    DIM(5) CTDATA PERRCD(1)
     D NSC             S             11    DIM(400)                             NON STOCKS
   HAD*UMS             S             78    DIM(62) CTDATA PERRCD(1)             ERROR MSG TABLE
HA HLD*UMS             S             78    DIM(63) CTDATA PERRCD(1)             ERROR MSG TABLE
HL IYD*UMS             S             78    DIM(64) CTDATA PERRCD(1)             ERROR MSG TABLE
IY JFD*UMS             S             78    DIM(65) CTDATA PERRCD(1)             ERROR MSG TABLE
JF JMD*UMS             S             78    DIM(66) CTDATA PERRCD(1)             ERROR MSG TABLE
JM KID*UMS             S             78    DIM(67) CTDATA PERRCD(1)             ERROR MSG TABLE
KI   D UMS             S             78    DIM(68) CTDATA PERRCD(1)             ERROR MSG TABLE
     D MSG             S             78    DIM(1) CTDATA PERRCD(1)              ERROR MSG TABLE
   HDD*EMS             S             78    DIM(55) CTDATA PERRCD(1)             ERROR MSG TABLE
HD JND*EMS             S             78    DIM(63) CTDATA PERRCD(1)             ERROR MSG TABLE
JN   D EMS             S             78    DIM(67) CTDATA PERRCD(1)             ERROR MSG TABLE
¢E ¢ID*CMS             S             78    DIM(1) CTDATA PERRCD(1)              ERROR MSG TABLE
¢I ¢OD*CMS             S             78    DIM(2) CTDATA PERRCD(1)              ERROR MSG TABLE
¢O ¢PD*CMS             S             78    DIM(5) CTDATA PERRCD(1)              ERROR MSG TABLE
¢P ¢QD*CMS             S             78    DIM(6) CTDATA PERRCD(1)
¢Q ¢SD*CMS             S             78    DIM(10) CTDATA PERRCD(1)
¢S ¢XD*CMS             S             78    DIM(11) CTDATA PERRCD(1)
¢X ¢3D*CMS             S             78    DIM(12) CTDATA PERRCD(1)
¢3 ¢7D*CMS             S             78    DIM(13) CTDATA PERRCD(1)
¢7 ¢9D*CMS             S             78    DIM(14) CTDATA PERRCD(1)
¢9 #6D*CMS             S             78    DIM(15) CTDATA PERRCD(1)
#6   D CMS             S             78    DIM(16) CTDATA PERRCD(1)
     D AMS             S             78    DIM(2) CTDATA PERRCD(1)              ADD ON MESSAGES
     D R               S              6  0 DIM(50)                              RNS ITEMS CREATED
     D RNS             S              6  0 DIM(400)                             ALL RNS ITEMS S/O+P/
     D RN2             S              6  0 DIM(400)                             RNS ITEMS ON S/O ONL
     D FCD             S              3  0 DIM(50)                              FAX CODE
     D CXPDDS          S              1    DIM(48)                              LOT PDDS
     D DOA             S              1    DIM(140) CTDATA PERRCD(70)           SUBMIT DIR AUD
I0 JND*CMS             S             78    DIM(4) CTDATA PERRCD(1)              ERROR MSG TABLE
     D LCK             S              7  0 DIM(400)                             LOCKED RCVRS
KP   D ARY2            S              1    DIM(51) CTDATA PERRCD(51)            RECEIVING REPORT
JA   d p1300App        s             10    inz('DII')
JA   d p1300Bypass     s              1    inz('N')
¢S   D FITM            S              6  0 DIM(5000)                            OUR ITEM NUMBER
HX    *
HX   D attachTxt       s             70
HX   D attachType      s              3    inz('P/O')
HX   D fileOpt         s              1    inz(*blanks)
H4   D pRetCd          s              1
H4   D pActCd          s              2
H4   D pFunKy          s              2
H4   D pData           s            256
IG   D DQFLG           s              1
JU   D TotFCost        S              8  2 inz(0)
¢2 ¢5D*@Count          S              7  0 Inz
:A   D @Count          S              7  0 Inz
¢2   D npi_item        S              1
#0   D ChkNPI          S              1
#7   D days            S              4  0
#7   D Today           S               d   datfmt(*ISO) Inz(*Sys)
:A   D PO_OpnCls       S              1
:A   D OpenLines       S              7  0 Inz
:A   D POLine          S              3
JD    *
JD   d woboqty         s                   like(bakstkqymp)
JD    *
#3   D checkCompany    s              3  0 inz
#3   D toCompany       s              3  0 inz
#6   D EDI860          s              1
HX    *
KW   D INVFND          S              1    inz('N')
KW   D OVHFND          S              1    inz('N')
     D RECPSD        E DS                  EXTNAME(PRLMPSD3)
     D                SDS
     D  PROG                   1      8
     D  USRNM                254    263
KR   D  JOBNUM               264    269  0
     D  #BIPGM                81     90
     D  DSPERR                91    160
     D SAVSDS          DS
     D  STSPGM                 1      8
     D  STSLIB                81     90
     D  STSERR                91    160
     D  STSUSR               254    263
     D FIL1DS          DS
     D  SCREEN               261    268
     D  WSNAME               273    281
     D  C@LOC                370    371B 0
     D  CPFRRN               378    379B 0
     D ZZNO04          DS
     D  I1                     1      1
     D  I2                     1      2
     D  I1A                    2      2
     D  SEC                    2      4
     D  NS                     2     12
¢N   D  IQSRCH                 2     15
     D  NSITM                  5     12
     D  I3                     3     12
     D  ITM1                   1      6
     D  LAST6A                 7     12
     D  ITM                    1     12
I2    *----------------------------------------------------------------
I2   D                 DS
I2   D  ADONS                  1     30
I2   D  WOSYS                  2      2
I2   D  WHMYES                 3      3
I2   D  RNSYS                  5      5
I2   D  PFSYS                  6      6
¢N    * Product lookup
¢N   D @P@           E DS                  EXTNAME(@PARMSIQ)
¢N   D  @P@500               500    500
      *----------------------------------------------------------------
     D                 DS                  INZ
     D  FAXSV                  1     10  0
     D  NO32SV                 1      3  0
     D  NO33SV                 4      6  0
     D  NO34SV                 7     10  0
      *----------------------------------------------------------------
     D                 DS                  INZ
     D  FAXSC                  1     10  0
     D  FAX1C                  1      3  0
     D  FAX2C                  4      6  0
     D  FAX3C                  7     10  0
      *----------------------------------------------------------------
      *
      *----------------------------------------------------------------
     D FAXDTA          DS                  OCCURS(212)
     D  FX1                    1     53
     D  FX2                   54    106
     D  FX3                  107    159
     D  FX4                  160    212
J2   D  FX5                  213    270
      *
     D  SYSTEM                36     39
     D  FAXPH#                43     74
     D  SYSDTA                78    127
     D  RQTIME               131    136
     D  RQDATE               140    145
      * BELOW ARE THE FIELDS NEEDED TO PRINT P/O
      *
     D  PONUM                 78     84
J0   D  POPRT                 85     85
     D  POCD11                86     86
     D  POSUFX                87     89
J0    * Position 90-90 reserved
J0   D  POENTBR               91     93                                         ENTERED BY BRANCH
      *----------------------------------------------------------------
     D OPTS            DS             4    INZ
     D  CVRSHT                 1      1
     D  DELAY                  2      2
     D  FAX4C                  3      3
     D  IFXAC                  4      4
      *----------------------------------------------------------------
     D                 DS
     D  REQMO                  1      2
     D  REQDAY                 3      4
     D  REQYR                  5      6
     D  REQDAT                 1      6
      *----------------------------------------------------------------
     D SFDS            DS
     D  SEL                    1      1
     D  QTY                    2      8  0
     D  PROD                   9     38
   IZD* MAN                   39     50
IZ   D  MANX                  39     50
     D  UOM                   51     53
     D  DESC                  54     88
     D  IVNO7                 89     94  0
     D  KEY                   95     97  0
     D  LIST                  98    108  5
     D  DISC                 109    116
     D  COST                 117    125  4
     D  DOVR                 126    126
     D  COVR                 127    127
     D  TYP                  128    128
     D  PUOM                 129    131
     D  QTYR                 132    138  0
     D  OQTY                 139    145  0
     D  NSITMX               146    153
     D  SYSASN               154    154
     D  NUSED1               155    155
     D  SFORLN               156    158  0
     D  SFBOOK               159    159
     D  SFDNR                160    160
     D  SFCD29               161    162
     D  SFCD13               163    163
     D  SFCD19               164    164
     D  ETASO                165    170  0
     D  ETASR                171    176  0
     D  SAVSO                177    182  0
     D  SAVSR                183    188  0
     D  ODIFF                189    195  0
     D  SEDIT                196    196
     D  SEDIT1               197    197
     D  SEDIT3               198    198
     D  NSPREV               199    199
     D  SECX                 200    202
     D  UOMSF                203    207  0
     D  UQYSF                208    214  0
     D  PUAMSF               220    228  4
     D  PUAMSL               229    239  5
     D  SUOMSF               240    242
     D  RUOMSF               243    245
     D  RUOMSQ               246    254  4
     D  OUOM                 255    257
     D  UQYSFO               258    264  0
     D  UQYSFR               265    271  0
     D  CMTFLG               272    272
     D  CTRL                 273    277  0
     D  WRN                  278    278
     D  SEDIT4               279    279
     D  PUOMSF               280    293  9
     D  RDEC                 285    293  9
     D  SEDIT5               294    294
     D  ONASNF               295    295
HL   D  SFDEL                296    296
HL   D  SFDELD               297    297
HS   D  SExtCost             298    312  5
IZ   D  man                  313    342
I0   D  ORGL                 343    345  0
JL   D  fl67                 346    346
JL   D  hdfl67               347    347
KH   D  ColCst               348    356  4
KM   D  PSNME                357    363
KM   D  PSCTNM               364    368  0
KM   D  PSSTS                369    369
KM   D  PSTYPE               370    370
KM   D  PSWARN               371    371
KM   D  PSOVR                372    372
¢I ¢4D* SFESD                348    348
¢4   D  SFESD                457    457
¢8   D  SFORGPROD            458    472
¢9   D  SFSELPRC             473    483  5
¢9   D  SFSELCST             484    494  5
#4   D  VENQ                 513    524
     D SAVDS           DS                  OCCURS(400)
     D  DSEL                   1      1
     D  DQTY                   2      8  0
     D  DITM                   9     38
   IZD* DMAN                  39     50
IZ   D  DMANX                 39     50
     D  DUOM                  51     53
     D  DDES                  54     88
     D  DNO7                  89     94  0
     D  DKEY                  95     97  0
     D  DLST                  98    108  5
     D  DDSC                 109    116
     D  DCST                 117    125  4
     D  DDOV                 126    126
     D  DCOV                 127    127
     D  DTYP                 128    128
     D  DUMP                 129    131
     D  DQYR                 132    138  0
     D  DOQTY                139    145  0
     D  DITMX                146    153
     D  DASN                 154    154
     D  NUSED2               155    155
     D  DSORLN               156    158  0
     D  DSBOOK               159    159
     D  DSDNR                160    160
     D  DSCD29               161    162
     D  DSCD13               163    163
     D  DSCD19               164    164
     D  ETADO                165    170  0
     D  ETADR                171    176  0
     D  SAVDO                177    182  0
     D  SAVDR                183    188  0
     D  DODIFF               189    195  0
     D  DEDIT                196    196
     D  DEDIT1               197    197
     D  DEDIT3               198    198
     D  DSPREV               199    199
     D  DSECX                200    202
     D  UOMDF                203    207  0
     D  UQYDF                208    214  0
     D  PUAMDF               220    228  4
     D  PUAMDL               229    239  5
     D  SUOM                 240    242
     D  RUOM                 243    245
     D  RUOMDQ               246    254  4
     D  DOUOM                255    257
     D  UQYDFO               258    264  0
     D  DQYRO                265    271  0
     D  DCMTFL               272    272
     D  DSCTRL               273    277  0
     D  SAVWRN               278    278
     D  DEDIT4               279    279
     D  PUOMDF               280    293  9
     D  DEDIT5               294    294
     D  DONASN               295    295
HL   D  DSDEL                296    296
HL   D  DDELETED             297    297
HS   D  DExtCost             298    312  5
IZ   D  dman                 313    342
I0   D  DSORGL               343    345  0
JL   D  dfl67                346    346
JL   D  dhdfl67              347    347
KH   D  DColCst              348    356  4
KM   D  DPSNME               357    363
KM   D  DPSCTNM              364    368  0
KM   D  DPSSTS               369    369
KM   D  DPSTYPE              370    370
KM   D  DPSWARN              371    371
KM   D  DPSOVR               372    372
¢I ¢4D* DSESD                348    348
¢4   D  DSESD                457    457
¢8   D  DSORGPROD            458    472
¢9   D  DSSELPRC             473    483  5
¢9   D  DSSELCST             484    494  5
#4   D  DVENQ                513    524
     D SAVDSR          DS                  OCCURS(998)
     D  RSEL                   1      1
     D  RQTY                   2      8  0
     D  RITM                   9     38
   IZD* RMAN                  39     50
IZ   D  RMANX                 39     50
     D  RUOMX                 51     53
     D  RDES                  54     88
     D  RNO7                  89     94  0
     D  RKEY                  95     97  0
     D  RLST                  98    108  5
     D  RDSC                 109    116
     D  RCST                 117    125  4
     D  RDOV                 126    126
     D  RCOV                 127    127
     D  RTYP                 128    128
     D  RUMP                 129    131
     D  RQYR                 132    138  0
     D  ROQTY                139    145  0
     D  RITMX                146    153
     D  RASN                 154    154
     D  NUSED3               155    155
     D  RSORLN               156    158  0
     D  RSBOOK               159    159
     D  RSDNR                160    160
     D  RSCD29               161    162
     D  RSCD13               163    163
     D  RSCD19               164    164
     D  UNUSE1               165    170  0
     D  UNUSE2               171    176  0
     D  UNUSE3               177    182  0
     D  UNUSE4               183    188  0
     D  UNUSE5               189    195  0
     D  UNUSE6               199    199
     D  UNUSE7               200    202
     D  RQYOF                203    207  0
     D  RQY01                208    214  0
     D  RAM02                220    228  4
     D  RAM01                229    239  5
     D  UNUSE8               240    264
     D  RQYRO                265    271  0
     D  RCMTFL               272    272
     D  RSCTRL               273    277  0
     D  RWRN                 278    278
     D  UNUSE9               279    279
     D  RQYPF                280    293  9
     D  UNUS10               294    294
     D  RONASN               295    295
HL   D  RSDEL                296    296
HL   D  RDELETED             297    297
HS   D  RExtCost             298    312  5
IZ   D  rman                 313    342
I0   D  RSORGL               343    345  0
JL   D  Rfl67                346    346
JL   D  rhdfl67              347    347
KH   D  RColCst              348    356  4
KM   D  RPSNME               357    363
KM   D  RPSCTNM              364    368  0
KM   D  RPSSTS               369    369
KM   D  RPSTYPE              370    370
KM   D  RPSWARN              371    371
KM   D  RPSOVR               372    372
¢I ¢4D* RSESD                348    348
¢4   D  RSESD                457    457
¢8   D  RSORGPROD            458    472
¢9   D  RSSELPRC             473    483  5
¢9   D  RSSELCST             484    494  5
#4   D  RVENQ                513    524
     D LOTDS           DS                  OCCURS(57)
     D  CIITM                  1      6  0
     D  CIUOM                  7      9
     D  CIQTY                 10     16  0
     D  CITYP                 17     17
   HWD* CIPRC                 18     24  2
   HWD* CICST                 25     31  2
   HWD* CIDSC                 32     39
   HWD* CIEXT                 40     48  2
   HWD* CICSH#                49     55
   HWD* CITRM                 56     58  1
   HWD* CIOVR                 59     59
   HWD* CISHPB                60     62  0
   HWD* CICSTS                63     63
   HWD* CIPRCS                64     64
   HWD* CIPDDS                65    112
   HWD* CIKID                113    115  0
   HWD* CIKLC#               116    120  0
   HWD* CIPID                121    123  0
   HWD* CIPLC#               124    128  0
   HWD* CINCI                129    129
   HWD* CICD84               130    130
   HWD* CICD47               131    131
   HWD* CIPN01               132    138  0
   HWD* CIPN05               139    141  0
   HWD* CIIEX                142    142
   HWD* CIQ11                143    149  0
   HWD* CIQ13                150    156  0
   HWD* CINSA                157    157
   HWD* CICD28               158    158
   HWD* CIVSC                159    218
   HWD* CISAC                219    220
HW   D  CIPRC                 18     25  2
HW   D  CICST                 26     32  2
HW   D  CIDSC                 33     40
HW   D  CIEXT                 41     49  2
HW   D  CICSH#                50     56
HW   D  CITRM                 57     59  1
HW   D  CIOVR                 60     60
HW   D  CISHPB                61     63  0
HW   D  CICSTS                64     64
HW   D  CIPRCS                65     65
HW   D  CIPDDS                66    113
HW   D  CIKID                114    116  0
HW   D  CIKLC#               117    121  0
HW   D  CIPID                122    124  0
HW   D  CIPLC#               125    129  0
HW   D  CINCI                130    130
HW   D  CICD84               131    131
HW   D  CICD47               132    132
HW   D  CIPN01               133    139  0
HW   D  CIPN05               140    142  0
HW   D  CIIEX                143    143
HW   D  CIQ11                144    150  0
HW   D  CIQ13                151    157  0
HW   D  CINSA                158    158
HW   D  CICD28               159    159
HW   D  CIVSC                160    219
HW   D  CISAC                220    221
I5   D  CIprcchg                      1
I5   D  CIcstchg                      1
     D PODS            DS                  OCCURS(50)
     D  Q                      1      7  0
     D  U                      8     10
     D  I                     11     40
     D RNSDS           DS                  OCCURS(50)
     D  RNSITM                 1      6  0
     D RCDS            DS                  OCCURS(28)
     D  DSNOT1                 1     78
     D APDS            DS                  OCCURS(98)
     D  DSNOT2                 1     78
     D                 DS
     D  SNAME                  1     30
     D  SADD1                 31     60
     D  SADD2                 61     90
     D  SADD3                 91    120
     D  SCITY                121    145
     D  SSTAT                146    147
     D  SMAIN                148    157
     D  SSHIP                  1    177
     D                 DS
     D  MNAME                  1     30
     D  MADD1                 31     60
     D  MADD2                 61     90
     D  MADD3                 91    120
     D  MCITY                121    145
     D  MSTAT                146    147
     D  MMAIN                148    157
     D  TEL1C                158    160  0
     D  TEL2C                161    163  0
     D  TEL3C                164    167  0
     D  MFAX1C               168    170  0
     D  MFAX2C               171    173  0
     D  MFAX3C               174    177  0
     D  MMAIL                  1    177
     D                 DS
     D  ARNM01                 1     30
     D  ARAD04                31     60
     D  ARAD05                61     90
     D  ARAD06                91    120
     D  ARCY02               121    145
     D  ARST02               146    147
     D  ARZP16               148    157
     D  CUSHIP                 1    177
     D                 DS
     D  APNM01                 1     30
     D  APAD04                31     60
     D  APAD05                61     90
     D  APAD06                91    120
     D  APCY02               121    145
     D  APST02               146    147
     D  APZP08               148    157
     D  APNO22               158    160  0
     D  APNO23               161    163  0
     D  APNO24               164    167  0
     D  APNO32               168    170  0
     D  APNO33               171    173  0
     D  APNO34               174    177  0
     D  AVMAIL                 1    177
     D                 DS
     D  UNNAME                 1     30
     D  APAD01                31     60
     D  APAD02                61     90
     D  APAD03                91    120
     D  APCY01               121    145
     D  APST01               146    147
     D  APZP07               148    157
     D  APNO02               158    160  0
     D  APNO03               161    163  0
     D  APNO04               164    167  0
     D  VMO32                168    170  0
     D  VMO33                171    173  0
     D  VMO34                174    177  0
     D  UVMAIL                 1    177
     D  FAX#                 168    177  0
     D                 DS
     D  PONM03                 1     30
     D  POAD01                31     60
     D  POAD02                61     90
     D  POAD03                91    120
     D  POCY01               121    145
     D  POST01               146    147
     D  POZP03               148    157
     D  POO22                158    160  0
     D  POO23                161    163  0
     D  POO24                164    167  0
     D  POO32                168    170  0
     D  POO33                171    173  0
     D  POO34                174    177  0
     D  POOVAD                 1    177
     D                 DS
     D  POMO02                 1      2  0
     D  PODY02                 3      4  0
     D  POYR02                 5      6  0
     D  ORDDAT                 1      6  0
     D                 DS
     D  POMO03                 1      2  0
     D  PODY03                 3      4  0
     D  POYR03                 5      6  0
     D  ETAOH                  1      6  0
     D                 DS
     D  POMO14                 1      2  0
     D  PODY14                 3      4  0
     D  POYR14                 5      6  0
     D  ETARH                  1      6  0
     D                 DS
     D  POMO13                 1      2  0
     D  PODY13                 3      4  0
     D  MMDD13                 1      4  0
     D  POCC13                 5      6  0
     D  POYR13                 7      8  0
     D  ETAOL                  1      8  0
     D                 DS
     D  POMO15                 1      2  0
     D  PODY15                 3      4  0
     D  MMDD15                 1      4  0
     D  POCC15                 5      6  0
     D  POYR15                 7      8  0
     D  ETARL                  1      8  0
     D                 DS
     D  POMO04                 1      2  0
     D  PODY04                 3      4  0
     D  POYR04                 5      6  0
     D  SHPDAT                 1      6  0
I2   D                 DS
I2   D  POMO50                 1      2  0
I2   D  PODY50                 3      4  0
I2   D  POYR50                 5      6  0
I2   D  DWNDAT                 1      6  0
     D                 DS
     D  POMO06                 1      2  0
     D  PODY06                 3      4  0
     D  POYR06                 5      6  0
     D  DUEDAT                 1      6  0
     D                 DS
     D  SHPCC                  1      2  0
     D  SHPYR                  3      4  0
     D  SHPCY                  1      4  0
     D  SHPMO                  5      6  0
     D  SHPDY                  7      8  0
     D  SHCYMD                 1      8  0
     D                 DS                  INZ
     D  MAXCC                  1      2  0
     D  MAXYR                  3      4  0
     D  MAXCY                  1      4  0
     D  MAXMO                  5      6  0
     D  MAXDY                  7      8  0
     D  MAXDT                  1      8  0
     D                 DS                  INZ
     D  MINCC                  1      2  0
     D  MINYR                  3      4  0
     D  MINCY                  1      4  0
     D  MINMO                  5      6  0
     D  MINDY                  7      8  0
     D  MINDT                  1      8  0
     D                 DS
     D  ORDCC                  1      2  0
     D  ORDYR                  3      4  0
     D  ORDCY                  1      4  0
     D  ORDMO                  5      6  0
     D  ORDDY                  7      8  0
     D  ORCYMD                 1      8  0
#7   D                 DS
#7   D  ORDRCC                 1      2  0
#7   D  ORDRYR                 3      4  0
#7   D  ORDRCY                 1      4  0
#7   D  ORDRMO                 5      6  0
#7   D  ORDRDY                 7      8  0
#7   D  ORDCYMD                1      8  0
     D                 DS
     D  ETACC                  1      2  0
     D  ETAYR                  3      4  0
     D  ETAMO                  5      6  0
     D  ETADY                  7      8  0
     D  ETCYMD                 1      8  0
     D                 DS
     D  ETARCC                 1      2  0
     D  ETARYR                 3      4  0
     D  ETARMO                 5      6  0
     D  ETARDY                 7      8  0
     D  ETRYMD                 3      8  0
     D  TRCYMD                 1      8  0
     D                 DS
     D  ETLIMO                 1      2  0
     D  ETLIDY                 3      4  0
     D  ETLIYR                 5      6  0
     D  ETLMDY                 1      6  0
     D                 DS
     D  ETALCC                 1      2  0
     D  ETALYR                 3      4  0
     D  ETALMO                 5      6  0
     D  ETALDY                 7      8  0
     D  ETLYMD                 3      8  0
     D  TLCYMD                 1      8  0
     D                 DS
     D  ETLRMO                 1      2  0
     D  ETLRDY                 3      4  0
     D  ETLRYR                 5      6  0
     D  ETRMDY                 1      6  0
     D                 DS
     D  ETALRC                 1      2  0
     D  ETALRY                 3      4  0
     D  ETALRM                 5      6  0
     D  ETALRD                 7      8  0
     D  ERLYMD                 3      8  0
     D  RLCYMD                 1      8  0
     D                 DS
     D  ENTDAT                 1      6  0
     D  OEMO03                 1      2  0
     D  OEDY03                 3      4  0
     D  OEYR03                 5      6  0
     D                 DS
     D  MO02                   1      2  0
     D  DY02                   3      4  0
     D  YR02                   5      6  0
     D  DATE2                  1      6  0
     D                 DS
     D  MO04                   1      2  0
     D  DY04                   3      4  0
     D  YR04                   5      6  0
     D  DATE4                  1      6  0
     D                 DS
     D  IVCC16                 1      2  0
     D  IVYR16                 3      4  0
     D  IVMO16                 5      6  0
     D  IVDY16                 7      8  0
     D  LSTPUR                 1      8  0
     D                 DS
     D  POCC11                 1      2  0
     D  POYR11                 3      4  0
     D  POMO11                 5      6  0
     D  PODY11                 7      8  0
     D  DATENT                 1      8  0
     D                 DS
   HID* OREF                   1      7  0
HI   D  OREF                   1      7
     D  OLIN                   8     10  0
     D  OSK                    1     10  0
     D TAGH            DS            85
     D  TTYP                   1      1
     D  TQTY                   2      8  0
     D  TBRA                   9     11  0
     D  TCUS                  12     17  0
   HID* TREF                  18     24  0
HI   D  TREF                  18     24
     D  TCOM                  25     59
     D  TQTYF                 60     66  0
     D  TLIN                  67     69  0
     D  ORDTYP                70     71
   HID* TTORG                 72     78  0
HI   D  TTORG                 72     78
     D  TTCTL                 79     85  0
     D                 DS
     D  P1                     1      1
     D  P2                     3      8
     D  PC1                    1      2
     D  PC2                    4      5
     D  PC3                    7      8
     D  PCPC01                 1      8
     D                 DS
     D  PONO                   1      7  0
     D  YESNO                  8      8
     D  REPRNT                 9      9
     D  RVPRNT                10     12  0
     D  DSPO                   1     12
      *
     D PARAM           DS
     D  PONUMB                 1      7
     D  POFLAG                 9      9
     D  SELLBR                62     64
     D  SHIPBR                65     67
      *
      *  DATA AREA FOR NEXT NON-STOCK ITEM NUMBER
     D NSITEM          DS
     D  NSITMN                 1      8
      *
     D                 DS                  INZ
     D  PDATYP                 1      1  0
     D  PDATE2                 2      3  0
     D  PDATE4                 4      7  0
     D  PDATE6                 8     13  0
     D  PDATE8                14     21  0
     D  PDACEN                22     23  0
     D  PDACYR                18     21  0
     D  DS2000                 1     23  0
     D TAGDS           DS                  OCCURS(50)
   HID* ORG#                   1      7  0
HI   D  ORG#                   1      7
     D  CTL#                   8     14  0
     D  QTYT                  15     21  0
JM   D  NO01T                 22     28
     D                 DS
     D  FAX                    1      1
     D  AFP                    2      2
     D  FXOPTS                 1      2
      *
     D SELMDS          DS                  OCCURS(50) INZ
     D  ITMSEL                 1      6
      *
     D  ACTION                 1      4
     D  VALDSO                 1      1
     D  VALDCO                 2      2
     D  VALDTF                 3      3
     D  VALDWO                 4      4
     D                 DS                  INZ
     D  WMCOBR                 1      6
     D  WMCO#                  1      3  0
     D  WMBR#                  4      6  0
     D                 DS                  INZ
     D  HDDTA1                 1    256
     D  HDNO01                 1      7  0
      *
     D DQMSG           DS
     D  DQDTA1                 1    256
     D  DQDTA2               257    512
     D  DQDTA3               513    576
     D HDRDS           DS
     D  HDFRM                  1      2
     D  HDFUNC                 3      3
     D  HDSTAT                 4      4
     D  HDCODE                 5      7
     D  HDDTTM                 8     31
     D  HDGRP#                32     46  0
     D  HDERCD                47     49
     D ASNDTA          DS          2025
      * TRANSACTION #
     D  ASNTX#                50     56  0
      * STOCK ITEM#
     D  ASNSI#                57     62  0
      * NON-STOCK IDENTIFIER
     D  ASNNSI                63     74
      * ASN STATUS TO CHECK - *OPEN,
      *                     - *POSTED
      *                     - *ALL
     D  ASNSTS                75     84
      * ASN OCCURENCE - *FIRST
      *               - *ALL
     D  ASNOCR                85     94
      * DATA QUEUE NAME
     D  ASNQNM                95    104
      * DATA QUEUE LIBRARY
     D  ASNQLB               105    114
      * ASN TRANSACTION TYPE 'P' = PURCHASE ORDER
     D  ASNTYP               115    115
     D ENDDTA          DS          2025
     D  ENNO01                50     56  0
     D  ENDQNM                57     66
     D  ENDQLB                67     76
KF   D                 DS                  INZ
KF   D  BIDCOST                1      2
KF   D  @BCCD                  1      1
KF   D  @DIRPONS               2      2
KP    *
KP   D                 DS                  INZ
KP   D PRTRCVOPT               1     30
KP   D PRTRCVDFT               2      2
KP    *
¢S   D                 DS
¢S   D  DUPITMCC               1      2  0
¢S   D  DUPITMYR               3      4  0
¢S   D  DUPITMMO               5      6  0
¢S   D  DUPITMDY               7      8  0
¢S   D  DUPITMDATE             1      8  0
     D WMERR1          C                   CONST('Open ASN exists, -
     D                                     Order Type & Ship-
     D                                      To Branch cannot-
     D                                      be changed.')
     D WMERR2          C                   CONST('Cannot contact wa-
     D                                     rehouse system. -
     D                                     Order Type & Ship-
     D                                      To Branch protec-
     D                                     ted.')
     D WMERR3          C                   CONST('Warehouse system -
     D                                     error occurred. -
     D                                     Order Type & Ship-
     D                                      To Branch protec-
     D                                     ted.')
     D F17DSC          C                   CONST('F17=Description ')
     D F17PRD          C                   CONST('F17=Product #   ')
     D F17MNF          C                   CONST('F17=Manuf #     ')
     D F17DS           C                   CONST('Description     ')
     D F17PR           C                   CONST('Product #       ')
     D F17MN           C                   CONST('Manuf #         ')
HE   D TWKCENTER       C                   CONST('Move to Work Center')
IV   D ediflg          s              1
#5   d customerVendor  s              6    inz
#5   d ediFlag         s              1    inz
#5   d ediSolution     s              7    inz
JZ    *
JZ   D d_HDE0039       DS           256    inz
JZ   D  totE39                        7s 0
JZ   D  orgE39                        1a
JZ   D  byrE39                        3a
JZ   D  vndE39                        6s 0
JZ   D  po#E39                        7s 0
JZ   D  cmpE39                        3s 0
JZ   D  divE39                        3a
JZ   D  regE39                        3a
JZ   D  brnE39                        3s 0
      *
#5   d retrieveEDISolution...
#5   d                 pr                  extpgm('APRC006')
#5   d inValue                        6
#5   d outNetwork                     7    const
#5   d outTranslate                   1    const
      *------------------------------------------------------------------------*
      *
     IIVFTNSK       49
     I              IVNO04                      INO04
     I              IVDN01                      IDN01
     I              IVMO01                      IMO01
     I              IVDY01                      IDY01
     I              IVCC01                      ICC01
     I              IVYR01                      IYR01
     I              IVNM01                      INM01
      *
     IOEFTOH        49
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              OENO26                      ONO26
     I              OENO43                      ONO43
      *
     IOEFTOHY       49
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              OENO26                      ONO26
     I              OENO43                      ONO43
      *
     IOEFTOL        48
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              OENO26                      ONO26
     I              PONO05                      ONO15
      *
     IOEFTOLY       49
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              OENO26                      ONO26
     I              PONO05                      ONO15
      *
     IOEFTOLK
     I              OENO01                      ONO01K
     I              ARNO01                      ANO01K
     I              PONO01                      PNO01K
     I              IVNO07                      INO07K
     I              IVNO04                      INO04K
     I              IVNO14                      INO14K
     I              PONO05                      ONO15K
      *
     IOEFTOL8       48
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              PONO05                      ONO15
      *
     IOEFTOLY8      49
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              PONO05                      ONO15
     IOEFTOLO       48
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              OENO26                      ONO26
     I              PONO05                      ONO15
     IOEFTOLYO      49
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              OENO26                      ONO26
     I              PONO05                      ONO15
JM J4I*OEFTOLN
JM J4I*             OENO01                      ONO01
JM J4I*             ARNO01                      ANO01
JM J4I*             PONO01                      PNO01
JM J4I*             IVNO07                      INO07
JM J4I*             IVNO04                      INO04
JM J4I*             IVNO14                      INO14
JM J4I*             OENO26                      ONO26
JM J4I*             PONO05                      ONO15
JM J4I*OEFTOLYN
JM J4I*             OENO01                      ONO01
JM J4I*             ARNO01                      ANO01
JM J4I*             PONO01                      PNO01
JM J4I*             IVNO07                      INO07
JM J4I*             IVNO04                      INO04
JM J4I*             IVNO14                      INO14
JM J4I*             OENO26                      ONO26
JM J4I*             PONO05                      ONO15
      *
     IOEFTOAD
     I              OENO01                      ADOE01
     I              OENO31                      ADNO31
     I              OENO56                      ADNO56
     I              IVNO07                      ADNO07
     I              OEDN04                      ADDN04
     I              ARNO01                      ADAR01
     I              ARNO15                      ADNO15
     I              PONO01                      ADPO01
      *
     IOEFTOAH
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              OENO43                      ONO43
     I              OECD86                      OACD86
     I              OEPC08                      OAPC08
     I              OECD01                      OACD01
     I              OEDN01                      OADN01
     I              ARCDC6                      OACDC6
     I              ARCDF9                      OACDF9
      *
     IOETOALA
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              PONO05                      PNO05
     I              IVNO07                      INO07
     I              IVNO04                      INO04
      *
     IOETOALB
     I              IVNO04                      INO04
     I              IVNO07                      INO07
     I              ARNO01                      ANO01
     I              OENO01                      ONO01
     I              PONO01                      PNO01
     I              PONO05                      PNO05
      *
     IOETOAL8
     I              IVNO07                      INO07
     I              OENO01                      ONO01
     I              PONO01                      PNO01
     I              PONO05                      PNO05
     I              ARNO01                      ANO01
     I              IVNO04                      INO04
      *
      *
     IOEFTOAD2
     I              OENO01                      ADOE01
     I              OENO31                      ADNO31
     I              OENO56                      ADNO56
     I              IVNO07                      ADNO07
     I              OEDN04                      ADDN04
     I              ARNO01                      ADAR01
     I              ARNO15                      ADNO15
     I              PONO01                      ADPO01
      *
     IOEFTOLV
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              PONO05                      ONO15
      *
   HEI*WOFTOL
   HII*             WONO01                      ONO01
   HEI*             ARNO01                      ANO01
   HEI*             IVDN01                      IDN01
   HEI*             PONO01                      PNO01
   HEI*             IVNO07                      INO07
   HEI*             IVNO04                      INO04
   HEI*             IVNO14                      INO14
   HII*             WONO22                      ONO26
   HEI*             PONO05                      ONO15
   HEI*WOTOL3
   HII*             WONO01                      ONO01
   HEI*             ARNO01                      ANO01
   HEI*             IVDN01                      IDN01
   HEI*             PONO01                      PNO01
   HEI*             IVNO07                      INO07
   HEI*             IVNO04                      INO04
   HEI*             IVNO14                      INO14
   HII*             WONO22                      ONO26
   HEI*             PONO05                      ONO15
     IOETOL14       48
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              PONO05                      ONO15
      *
     IOETOLY14      49
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              PONO05                      ONO15
     IOETOL15       48
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              OENO26                      ONO26
     I              PONO05                      ONO15
     IOETOLY15      49
     I              OENO01                      ONO01
     I              ARNO01                      ANO01
     I              PONO01                      PNO01
     I              IVNO07                      INO07
     I              IVNO04                      INO04
     I              IVNO14                      INO14
     I              OENO26                      ONO26
     I              PONO05                      ONO15
     IPOFTOL
     I              POMO02                      MO02
     I              PODY02                      DY02
     I              POCC02                      CC02
     I              POYR02                      YR02
     I              POMO04                      MO04
     I              PODY04                      DY04
     I              POCC04                      CC04
     I              POYR04                      YR04
     IAPFMVEN
     I              APNO32                      VMO32
     I              APNO33                      VMO33
     I              APNO34                      VMO34
     IAPFMVAD
     I              APNO01                      VENDOR
     IIVFPROD
     I              IVNO22                      NO22
     I              IVNO93                      NO93
     IIVFITEM
     I              IVNO22                      NO22
     I              IVNO93                      NO93
HP  IALLITEM
HP  I              IVNO22                      NO22
HP  I              IVNO93                      NO93
     IPOFTOA
     I              APNO22                      POO22
     I              APNO23                      POO23
     I              APNO24                      POO24
     I              APNO32                      POO32
     I              APNO33                      POO33
     I              APNO34                      POO34
     IIVFTTL
     I              PONO01                      XXNO01
     IIVFTTLK
     I              PONO01                      PNO01
JM   IIVFTTLZ
JM   I              PONO01                      PNO01Z
HH   IPOFTTG
HH   I              OENO01                      TGNO01
HH   I              OENO22                      TGNO22
      *------------------------------------------------------------------------*
      *  SECTION 0         NON-EXECUTABLE STATEMENTS
      *
      * STEP 1.  KEY LIST
      *------------------------------------------------------------------------*
      * STEP 1. * KEY LIST
      *------------------------------------------------------------------------*
     C     *ENTRY        PLIST
     C                   PARM                    POPARM
     C                   PARM                    WHRFRM            1
     C     RLOCK         PLIST
     C                   PARM                    DSPERR
     C                   PARM                    DSPF1             1            DISPLAY RETRY?
     C                   PARM                    DSPF2             1            SCREEN RESPONSE
     C     SSPRM         PLIST                                                  STOCK STATUS
     C                   PARM                    WRKITM                         ITEM NO
     C                   PARM                    SHIPTO                         BRANCH
     C                   PARM      ' '           P0420             1            SHIPPING
     C                   PARM      'N'           ALWCHG            1            ALLOW CHANGE
     C     DMDPRM        PLIST                                                  ITEM HISTORY
     C                   PARM                    SHIPTO                         BRANCH
     C                   PARM                    WRKITM                         ITEM NO
     C     UDRPRM        PLIST                                                  CALC CLNDR DT
     C                   PARM                    ZZFUNC            1
     C                   PARM                    ZZDATE            7 0
     C                   PARM                    ZZDAYS            5 0
     C                   PARM                    ZZDIFF            7 0
     C     VLTPRM        PLIST
     C                   PARM                    IVVLT7                         ITEM #
     C                   PARM                    APVLT1                         VENDOR #
     C                   PARM                    POVLT2                         SHIP TO BR #
     C     PL0060        PLIST
     C                   PARM                    VALUE#           30
     C                   PARM                    ACT#              1
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
IX    *
IX   C     PL0111        PLIST
IX   C                   PARM                    CMPPRDNOKY
IX   C                   PARM                    PFLAG             1
IX   C                   PARM                    CUCOSTAMKY
      *
     C     R0300         PLIST
     C                   PARM                    C@LOC#                         CURSOR LOCATION
     C                   PARM                    CRCD#                          CURSOR RECORD
     C                   PARM                    CFLD#                          CURSOR FIELD
     C                   PARM                    SYSID             4            APPLICATION COD
     C                   PARM                    DOCNUM           12            DOCUMENT NUMBER
     C                   PARM                    FAXNUM           32            DOCUMENT NUMBER
     C                   PARM                    OPTION            4            OPTIONS
     C                   PARM                    REQTIM            6            REQUESTED FAX TIME
     C                   PARM                    REQDAT                         REQUESTED FAX DATE
   HIC*                  PARM                    TRNNUM            7 0          TRANSFER NUMBER
HI   C                   PARM                    TRNNUM            7            TRANSFER NUMBER
     C     PL3450        PLIST
     C                   PARM                    ITMWK                          ITEM
     C                   PARM                    UOMWK                          UOM
     C                   PARM                    FACTO            14 9          FACTOR
     C                   PARM                    QUAN              7 0          QTY
     C                   PARM                    WDWFLG                         WINDOW FLAG
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM                    FRMAPP            1            FROM APP
     C     ALIPRM        PLIST
     C                   PARM                    ALIDTA                         OUT
     C                   PARM                    ALICUS            6 0          OUT (OPT)
     C                   PARM                    ALIPRD                         IN
     C                   PARM                    ALIITM                         IN
     C                   PARM                    ALIAS                          IN
     C                   PARM                    SCREEN                         OUT
     C                   PARM                    BRCH#             3 0          OUT
     C                   PARM                    SELMDS                         SELECT DATA STRUCT
     C                   PARM      ' '           SELMOD            1            SEL MODE
     C                   PARM                    RTRNCD            1 0          RETURN CODE
      *
     C     PL2000        PLIST
     C                   PARM                    PM2000           23 0
      *
     C     PL0055        PLIST
     C                   PARM                    PONO01
     C                   PARM                    PONO02
     C                   PARM                    IVNO07
     C                   PARM                    TAGREF
     C                   PARM                    TAGDS
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM                    RTNCDE            1 0
      *
     C     PL0056        PLIST
     C                   PARM                    PONO01
     C                   PARM                    PONO02
     C                   PARM                    IVNO07
     C                   PARM                    TAGREF
     C                   PARM                    TAGDS
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM                    RTNCDE            1 0
      *
     C     PL0050        PLIST
     C                   PARM                    TAGREF
     C                   PARM                    ACTION            4
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
      *
     C     PL2062        PLIST
     C                   PARM                    ACCESS            1
     C                   PARM                    NSKEY
     C                   PARM                    ZPONO1
     C                   PARM                    TAGXST            1
     C                   PARM                    ONTRF             1
     C                   PARM                    ONSO              1
     C                   PARM                    ONPO              1
     C                   PARM                    ONWO              1
     C                   PARM                    EXISTS            1
      *
     C     PL0021        PLIST
     C                   PARM                    LTORD#
     C                   PARM                    LTCTL#
     C                   PARM                    ADNO56
      *
     C     PL9505        PLIST
     C                   PARM                    VNDCUS            1
     C                   PARM                    CUSNBR            6
     C                   PARM                    TRPNID           15
     C                   PARM                    VENBRN            3
     C                   PARM                    DOCTYP            3
     C                   PARM                    SUBTYP            1
     C                   PARM                    RCVSTS            1
     C                   PARM                    EDITYP            1
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
     C     PL0303        PLIST
     C                   PARM                    SYSID                          APPLICATION COD
     C                   PARM                    DOCNUM           12            DOCUMENT NUMBER
     C                   PARM                    EMAIL            45            EMAIL ADDRS
     C                   PARM                    REQTIM                         REQUESTED FAX TIME
     C                   PARM                    REQDAT                         REQUESTED FAX DATE
   HIC*                  PARM                    TRNNUM            7 0          TRANSACTION REQUEST
HI   C                   PARM                    TRNNUM            7            TRANSACTION REQUEST
     C     PL0315        PLIST
     C                   PARM                    APNO01
     C                   PARM                    ETYPE             2
     C                   PARM                    EMAIL
     C                   PARM                    C@LOC#            6
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
      *
     C     PL0510        PLIST
     C                   PARM                    LBLINE            5
     C                   PARM                    LBBRN             3
     C                   PARM                    LBITM             6
     C     PL0025        PLIST
     C                   PARM                    TABCOD
     C                   PARM                    VALUE2            9
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
KJ   C                   PARM                    VALUE3           30
KJ   C                   PARM                    MODE              1
      *
     C     PL0118        PLIST
      *                                                  API BUYER  -
     C                   PARM                    ABUYID                         BUYER ID
     C                   PARM                    ABUYRC            1            RETURN CODE
      *
     C     PL0119        PLIST
      *                                                  API RECIVG FLD
     C                   PARM                    ARCVPO                         P/O NUMBER  BER
     C                   PARM                    ARCVLF                         P/O LIN REF BER
     C                   PARM                    ARCVCS                         ITM CST @STKBER
     C                   PARM                    ARCVCP                         ITM CST @PRCBER
     C                   PARM                    ARCVRC            1            RETURN CODE
      *
     C     PL0400        PLIST
     C                   PARM                    PMIAPL            2
     C                   PARM                    PMOYN             1
      *
     C     PL8220        PLIST                                                  GET USR AUTH
     C                   PARM                    USER             10
     C                   PARM                    APP               2
     C                   PARM                    CDE               4
     C                   PARM                    ID                4 0
     C                   PARM                    USRVAL           10
     C                   PARM                    VALFRM            1
     C                   PARM                    RTNCOD            1
H4    *
H4   c     pl0306        plist                                                  GET USR AUTH
H4   c                   parm                    pRetCd
H4   c                   parm                    pActCd
H4   c                   parm                    pFunKy
H4   c                   parm                    pData
JA    *
JA   C     PL1300        PLIST
JA   C                   PARM                    p1300App
JA   C                   PARM                    p1300Bypass
KM    *
KM   C     PL0123        PLIST
KM   C                   PARM                    APNO01
KM   C                   PARM                    PONO02
KM   C                   PARM                    PONO03
KM   C                   PARM                    POCD01
KM   C                   PARM                    SVPSTS
KM   C                   PARM                    SVPSAO
KM   C                   PARM      *BLANK        GOTOVR            1
KM   C                   PARM                    SFDS
      *
     C     MAILKY        KLIST
     C                   KFLD                    APNO01                         VENDOR #
     C                   KFLD                    APCD08                         TYPE CODE
     C                   KFLD                    SEQMAL            3 0          SEQUENCE #
     C     KYMAIL        KLIST
     C                   KFLD                    APNO01                         VENDOR #
     C                   KFLD                    APCD08                         TYPE CODE
     C     PRCKYH        KLIST
     C                   KFLD                    APNO01                         VENDOR #
     C                   KFLD                    PRNO01                         PRICE SHEET #
     C                   KFLD                    PRNO02                         CONTROL #
     C     PRCKYD        KLIST
     C                   KFLD                    APNO01                         VENDOR #
     C                   KFLD                    PRCD21                         PURCH STATUS
     C                   KFLD                    IVNO07                         OUR ITEM #
IO   C     PSDKEY1       KLIST
IO   C                   KFLD                    APNO01                         VENDOR #
IO   C                   KFLD                    PRCD21                         PURCH STATUS
IO   C                   KFLD                    DNO7                           OUR ITEM #
KA   C     WeightKey     KLIST
KA   C                   KFLD                    APNO01
KA   C                   KFLD                    DNO7
#4   C     PCDKEY        KLIST
#4   C                   KFLD                    VEN#PD
#4   C                   KFLD                    STATPD
#4   C                   KFLD                    ITEMPD
     C     BRKEY         KLIST
     C                   KFLD                    PONO02                         SHIP TO BRANCH
     C                   KFLD                    IVNO07                         OUR ITEM #
     C     ADRSOV        KLIST
     C                   KFLD                    PONO01                         P.O. NUMBER
     C                   KFLD                    POCD02                         TYPE CODE
     C     LINKEY        KLIST
     C                   KFLD                    PONO01                         P.O. NUMBER
     C                   KFLD                    PONO05                         LINE NUMBER
     C     POKEY         KLIST
     C                   KFLD                    PONO01                         P.O. NUMBER
     C                   KFLD                    DSORLN                         LINE NUMBER
     C     NTSKEY        KLIST
     C                   KFLD                    PONO01                         P.O. NUMBER
     C                   KFLD                    POCD08                         NOTES TYPE
     C     TABKEY        KLIST
     C                   KFLD                    TABCOD            4            TABLE CODE
     C                   KFLD                    TABENT            9            TABLE ENTRY
     C     OEKEY         KLIST
     C                   KFLD                    PONO01                         P.O.#
     C                   KFLD                    TREF                           ORDER #
     C                   KFLD                    DNO7                           ITEM #
     C                   KFLD                    TLIN                           SEQ#
      *  OE line item key by item number and original order #
     C     TAGKY         KLIST
     C                   KFLD                    IVNO07                         ITEM#
     C                   KFLD                    ONO26                          ORIG ORD#
      *
JM J4C*    TAGKYO        KLIST
JM J4C*                  KFLD                    ONO01                          ORD#
JM J4C*                  KFLD                    IVNO07                         ITEM#
JM J4 *
JM   C     TFRKYZ        KLIST
JM   C                   KFLD                    TrnNbr
JM   C                   KFLD                    Ivno07
JM    *
     C     TAGKY2        KLIST
     C                   KFLD                    ONO01
     C                   KFLD                    OENO22
      *  OE line item key by item #/orig order #/PO #/PO line #
     C     OKEY3         KLIST                                                  OELTOLYO
     C                   KFLD                    DNO7                           ITEM #
     C                   KFLD                    ONO26                          ORIG ORD#
     C                   KFLD                    PONO01                         PO #
     C                   KFLD                    PONO05                         LINE #
      *
     C     REFBKY        KLIST
     C                   KFLD                    PONO25
     C                   KFLD                    PONO02
     C     CLSKEY        KLIST
     C                   KFLD                    PONO13
     C                   KFLD                    SAVCO#
      *
     C     WRKKEY        KLIST
     C                   KFLD                    POCD45
     C                   KFLD                    TTORG
     C                   KFLD                    TTCTL
JL    *
JL   C     TRDKEY        KLIST
JL   C                   KFLD                    PONO01
JL   C                   KFLD                    PONO05
¢5    *
¢5   C     MSBRKEY2      KLIST
¢5   C                   KFLD                    IVNO07                         OUR ITEM NUMBER
¢5   C                   KFLD                    BR#               3 0          BRANCH NUMBER
      *
     C     EDTDAT        PLIST
     C                   PARM                    PDATE             6 0
     C                   PARM                    PJULI             5 0
JG    *
JG   C     PL0145        PLIST
JG   C                   PARM                    PO#
      *  OE LINE ITEM KEY BY CUST # AND ORIG ORDER #
     C     OLYKEY        KLIST
     C                   KFLD                    ANO01                          CUST #
     C                   KFLD                    ONO26                          ORIG ORDER #
      *
   HGC*    PBKEY         KLIST
   HGC*                  KFLD                    SECPRF                         PROFILE#
   HGC*                  KFLD                    OPNO03                         BR#
      *
   HGC*    PXKEY         KLIST
   HGC*                  KFLD                    SECPRF                         PROFILE#
   HGC*                  KFLD                    BR@               3 0          ZERO
     C     PRCFAC        KLIST
     C                   KFLD                    PRNO01                         PRICE SHEET
     C                   KFLD                    PRCD60                         PRICE TYPE  #
      * REGIONAL P/S BRANCH ASSIGNMENT FILE - KLIST
     C     CTL#BR        KLIST
     C                   KFLD                    PRNO02                                     BER
     C                   KFLD                    COSTBR
     C     LTKEY         KLIST
     C                   KFLD                    APNO01                         VENDOR #
     C                   KFLD                    PONO02                         SHIP TO BRANCH
     C                   KFLD                    IVNO07                         OUR ITEM #
      *
      *
     C     TRFKEY        KLIST
     C                   KFLD                    IVNO55
     C                   KFLD                    IVNO57
     C                   KFLD                    IVNO92
      *
     C     OAL8KY        KLIST
     C                   KFLD                    ONO01                          CUST #
     C                   KFLD                    IVNO07                         ITEM #
      *
     C     OASKY2        KLIST
     C                   KFLD                    OENO01                         SO#
     C                   KFLD                    OENO31                         LINE CTL #
      *
     C     KEYLOT        KLIST
     C                   KFLD                    ONO01
     C                   KFLD                    OENO31
      *
      *
     C     OLYKY2        KLIST
     C                   KFLD                    ANO01                          CUST #
     C                   KFLD                    ONO01                          ORDER #
      *
     C     WOKY1         KLIST                                                  TO TAG FILE
     C                   KFLD                    ZZNO04                         N/S PROD#
     C                   KFLD                    TREF                           WO#
      *
      *
     C     WMKEY         KLIST
     C                   KFLD                    POPOPO            2            TRN TYPE
   HIC*                  KFLD                    PONO01                         PO NUMBER
HI   C                   KFLD                    WMN#                           PO NUMBER
IR   C     FINDKY        KLIST                                                  REBAT STOCK SHT
IR   C                   KFLD                    PONO01                         PO
IR   C                   KFLD                    FIND04                         PRODUCT SRCH
KE   C     FINDKY2       KLIST                                                  REBAT STOCK SHT
KE   C                   KFLD                    PONO01
KE   C                   KFLD                    FINDLN
HE   C     WOKEY         KLIST
HE   C                   KFLD                    PONO02
HE   C                   KFLD                    ITEMNBR           7 0
HE   C                   KFLD                    PRODNBR          30
HE   C                   KFLD                    TRANTYP           3
HY    *----------------------------------------------------*
HY   C     COLKEY        KLIST
HY   C                   KFLD                    APNO01
HY   C                   KFLD                    PRNO01
HY   C                   KFLD                    IVNO07
HY   C                   KFLD                    CC_PRCD53
HY    *----------------------------------------------------*
KR   C     KeyClip2      klist
KR   C                   kfld                    SessioNmMv
KR   C                   kfld                    EnttypCdMv
KR    *----------------------------------------------------*
      * NEXT AVAILAIBLE NON-STOCK ITEM NUMBER
     C     *LIKE         DEFINE    POTL01        AMT
JZ   C     *LIKE         DEFINE    POTL02        SavedTotal
     C     *LIKE         DEFINE    PONO02        SVNO02                         SAVE SHIP TO
     C     *LIKE         DEFINE    PONO18        REVNO                          REVISION NUMBER
     C     *LIKE         DEFINE    PONO02        SAVSHP
     C     *LIKE         DEFINE    IVNO07        WRKITM                         WORK ITEM
     C     *LIKE         DEFINE    PONO02        SAVESB                         SAVE SHIP BR
     C     *LIKE         DEFINE    ETAOH         SAVOH                          ETA ORIG SV
     C     *LIKE         DEFINE    ETARH         SAVRH                          ETA RVSD SV
     C     *LIKE         DEFINE    X             MAXDS                          MAX DS SIZE
     C     *LIKE         DEFINE    PONO01        POPARM                         PO PARM FLD
     C     *LIKE         DEFINE    IVNO07        IVVLT7                         ITEM #
     C     *LIKE         DEFINE    APNO01        APVLT1                         VENDOR #
     C     *LIKE         DEFINE    PONO02        POVLT2                         SHIP TO BR #
     C     *LIKE         DEFINE    ODIFF         NWDIFF                         QTY DIFF FLD
     C     *LIKE         DEFINE    CROW          ROW
     C     *LIKE         DEFINE    CCOL          COL
     C     *LIKE         DEFINE    ARNO15        SAVCO#
     C     *LIKE         DEFINE    PONO03        SAVBR#
     C     *LIKE         DEFINE    POCD01        SAVCD1
     C     *LIKE         DEFINE    POCD01        SVCD01
     C     *LIKE         DEFINE    QTY           DFLTQ                          SAVE QTY
     C     *DTAARA       DEFINE    *LDA          PARAM
     C     *DTAARA       DEFINE                  NSITEM                         NON STOCK ITEM
     C     *LIKE         DEFINE    RECPSD        SAVPSD                         DETAIL RECORD
     C     *LIKE         DEFINE    PONO02        COSTBR                         COSTING BRANCH
     C     *LIKE         DEFINE    OENO22        SVNO22
     C     *LIKE         DEFINE    POCD20        POSTS
     C     *LIKE         DEFINE    PONO13        CUSTSV
     C     *LIKE         DEFINE    POCD01        SVTYPE
     C     *LIKE         DEFINE    POCD12        SVCD12                         PRE-REL 10 P/O
     C     *LIKE         DEFINE    APNO01        VNDNUM
     C     *LIKE         DEFINE    UOM           UOMWK
     C     *LIKE         DEFINE    IVNO07        ITMWK
     C     *LIKE         DEFINE    PONO07        SVNO07
     C     *LIKE         DEFINE    PONO01        LSTPO#
     C     *LIKE         DEFINE    IVNO04        ALIDTA
     C     *LIKE         DEFINE    IVNO04        ALIPRD
     C     *LIKE         DEFINE    IVNO07        ALIITM
     C     *LIKE         DEFINE    IVNO04        ALIAS
     C     *LIKE         DEFINE    RRN           THERRN
     C     *LIKE         DEFINE    PONO02        ITMBR
     C     *LIKE         DEFINE    POCC03        SVCC03                         ORIG ETA CEN
     C     *LIKE         DEFINE    POCC14        SVCC14                         RVSD ETA CEN
     C     *LIKE         DEFINE    OENO26        ORDNUM
     C     *LIKE         DEFINE    PONO02        SAVBR
   HIC*    *LIKE         DEFINE    IVNO26        TAGREF
HI   C     *LIKE         DEFINE    PONO11        TAGREF
HI   C     *LIKE         DEFINE    IVNO26        TREF#
HI   C     *LIKE         DEFINE    EINO03        EIN#
HI   C     *LIKE         DEFINE    WMNO05        WMN#
     C     *LIKE         DEFINE    PODN10        NSKEY
     C     *LIKE         DEFINE    PONO01        ZPONO1
     C     *LIKE         DEFINE    *IN40         SVIN40
KJ   C     *LIKE         DEFINE    *IN69         SVIN69
     C     *LIKE         DEFINE    PONO02        SHIPTO
     C     *LIKE         DEFINE    PDACYR        SOCCYR
     C     *LIKE         DEFINE    PDACYR        POCYR3
     C     *LIKE         DEFINE    PDACYR        PCYR14
     C     *LIKE         DEFINE    PDACYR        SRCCYR
     C     *LIKE         DEFINE    TCOM          SVCOM
     C     *LIKE         DEFINE    TCOM          SVCOM2
     C     *LIKE         DEFINE    TCOM          SVCOM3
     C     *LIKE         DEFINE    IVAMZ2        SVAM31
     C     *LIKE         DEFINE    OEQY01        QTY1
     C     *LIKE         DEFINE    ZZNO04        WKNO04
     C     *LIKE         DEFINE    NSITMX        SAVNS
     C     *LIKE         DEFINE    ONO01         LTORD#
     C     *LIKE         DEFINE    ADNO31        LTCTL#
     C     *LIKE         DEFINE    KEY           SVKEY                          TAG & HOLD KEY
     C     *LIKE         DEFINE    MAN           SVMAN                          MANUF NUMBER
     C     *LIKE         DEFINE    COVR          SVCOVR                         COST OVERRIDE
     C     *LIKE         DEFINE    DOVR          SVDOVR                         DISC OVERRIDE
     C     *LIKE         DEFINE    NSITMX        SVITMX                         NONSTK ITM
     C     *LIKE         DEFINE    SYSASN        SVASN                          SYSTEM ASSGNED
     C     *LIKE         DEFINE    SFBOOK        SVSFBK
     C     *LIKE         DEFINE    SFDNR         SVDNR                          DNR FLAG
¢I   C     *LIKE         DEFINE    SFESD         SVESD                          DNR FLAG
¢8   C     *LIKE         DEFINE    SFORGPROD     SVORGPROD
¢9   C     *LIKE         DEFINE    SFORGPROD     SVSELPRC
¢9   C     *LIKE         DEFINE    SFORGPROD     SVSELCST
HL   C     *LIKE         DEFINE    SFDEL         SVDEL                          DEL ITM FLAG
     C     *LIKE         DEFINE    ETASO         SVETAO                         ETA DATE
     C     *LIKE         DEFINE    SEDIT         SVEDT                          EDIT FLAGS
     C     *LIKE         DEFINE    SEDIT1        SVEDT1                          "    "
     C     *LIKE         DEFINE    SEDIT3        SVEDT3                          "    "
     C     *LIKE         DEFINE    SEDIT4        SVEDT4                          "    "
     C     *LIKE         DEFINE    SEDIT5        SVEDT5                          "    "
     C     *LIKE         DEFINE    SECX          SVSECX                         SAVE SECTION
     C     *LIKE         DEFINE    QTYR          SVQTYR                         QTY RELEASED
     C     *LIKE         DEFINE    SFORLN        SVORLN                         SAVED LINE #
JV   C     *LIKE         DEFINE    ORGL          SVORGL                         SAVED LINE #
     C     *LIKE         DEFINE    ETASR         SVETAR                         ETA DATE
     C     *LIKE         DEFINE    SAVSO         SVSO
     C     *LIKE         DEFINE    SAVSR         SVSR
     C     *LIKE         DEFINE    POCC13        SVETCC
     C     *LIKE         DEFINE    POCC15        SVRTCC
     C     *LIKE         DEFINE    SVCC13        SVSOCC
     C     *LIKE         DEFINE    SVCC15        SVSRCC
     C     *LIKE         DEFINE    ODIFF         SVDIFF
     C     *LIKE         DEFINE    NSPREV        SVPREV
     C     *LIKE         DEFINE    POID01        ABUYID
     C     *LIKE         DEFINE    PONO01        ARCVPO                         P/O NUMBER  BER
     C     *LIKE         DEFINE    PONO05        ARCVLF                         P/O LIN REF BER
     C     *LIKE         DEFINE    POAM02        ARCVCS                         ITM CST @STKBER
     C     *LIKE         DEFINE    POAMU2        ARCVCP                         ITM CST @PRCBER
     C     *LIKE         DEFINE    ARNO15        COMPNY
     C     *LIKE         DEFINE    PONO02        BRNBR
     C     *LIKE         DEFINE    IVNO04        SITM
     C     *LIKE         DEFINE    IVDN01        SDES
     C     *LIKE         DEFINE    MAN           SMAN
      *
     C     *LIKE         DEFINE    IVNO07        AUOMI#
     C     *LIKE         DEFINE    RRN           MXNOTE
     C     *LIKE         DEFINE    WHRFRM        XXXWHR
     C     *LIKE         DEFINE    POCD03        SVCD03
HY   C     *LIKE         DEFINE    CC_PRAM26     COLCST
HY   C     *LIKE         DEFINE    CC_PRQY06     WGHT
HY   C     *LIKE         DEFINE    CC_PRQY06     DLRS
KH   C     *LIKE         DEFINE    CC_PRQY06     OWGHT
KH   C     *LIKE         DEFINE    CC_PRQY06     ODLRS
HY   C     *LIKE         DEFINE    CC_PRAM26     COLCS1
HY   C     *LIKE         DEFINE    CC_PRAM26     COLCS2
HY   C     *LIKE         DEFINE    CC_PRAM26     COLCS3
HZ   C     *LIKE         DEFINE    POTL01        InventoryTotal
IR   C     *LIKE         DEFINE    PONO01        SVNO01
IX   C     *LIKE         DEFINE    PRODNOMP      CMPPRDNOKY
IX   C     *LIKE         DEFINE    UNTWACAMMP    CUCOSTAMKY
I0   C                   Z-ADD     *ZEROS        INSX              3 0
I0   C                   Z-ADD     *ZEROS        CURSER_RRN        3 0
I0   C     *LIKE         DEFINE    PONO05        SVDSORLN
I2   C     *LIKE         DEFINE    POCD56        DEF_OSHPCODE
I2   C     *LIKE         DEFINE    POCD56        DEF_SSHPCODE
IS   C     *LIKE         DEFINE    ColCst        LastColCst
KB   C     *LIKE         DEFINE    POCDA4        SVCDA4
#4   C     *LIKE         DEFINE    APNO01        VEN#PD
#4   C     *LIKE         DEFINE    PRCD21        STATPD
#4   C     *LIKE         DEFINE    IVNO07        ITEMPD
      *----------------------------------------------------------------
      * SAVE VALUE PASSED IN FROM ROR ($=SINGLE PO, OR  %=MULTI PO)...
     C                   MOVE      WHRFRM        XXXWHR
      * IF A SINGLE PO PASSED IN FROM ROR MAINT, CLEAR ENTRY PARM AS
      * IF NORMAL P/O PASSED IN... WE WILL REFER TO ($) VALUE LATER...
     C     XXXWHR        IFEQ      '$'
     C                   MOVE      *BLANK        WHRFRM
     C                   ENDIF
     C                   Z-ADD     98            MXNOTE
      * See if user is cancel backorders on directs...
     C                   CLEAR                   DBOAUT
     C                   MOVEL     USRNM         USER
     C                   Z-ADD     1             ID
     C                   MOVE      'PO'          APP
     C                   MOVE      'POM '        CDE
     C                   MOVE      *BLANKS       USRVAL
     C                   MOVE      *BLANKS       VALFRM
     C                   MOVE      *BLANKS       RTNCOD
     C                   CALL      'OPR8220'     PL8220
     C     RTNCOD        IFEQ      '0'
     C                   MOVEL     USRVAL        DBOAUT            1
     C                   ENDIF
¢W    * See if user can order slow items on a po
¢W   C                   CLEAR                   SLOWAUT
¢W   C                   MOVEL     USRNM         USER
¢W   C                   Z-ADD     9000          ID
¢W   C                   MOVE      'PO'          APP
¢W   C                   MOVE      'POM '        CDE
¢W   C                   MOVE      *BLANKS       USRVAL
¢W   C                   MOVE      *BLANKS       VALFRM
¢W   C                   MOVE      *BLANKS       RTNCOD
¢W   C                   CALL      'OPR8220'     PL8220
¢W   C     RTNCOD        IFEQ      '0'
¢W   C                   MOVEL     USRVAL        SLOWAUT           1
¢W   C                   ENDIF
JL    * GET SPECIAL PRICING AUTHORIZATION ...
JL   C                   CLEAR                   SPLPRCAUT
JL   C                   MOVEL     USRNM         USER
JL   C                   MOVE      'PO'          APP
JL   C                   MOVE      'SPRC'        CDE
JL   C                   MOVE      0001          ID
JL   C                   MOVE      *BLANKS       USRVAL
JL   C                   MOVE      *BLANKS       VALFRM
JL   C                   MOVE      *BLANKS       RTNCOD
JL   C                   CALL      'OPR8220'     PL8220
JL   C     RTNCOD        IFEQ      '0'
JL   C                   MOVEL     USRVAL        SPLPRCAUT         1
JL   C                   ENDIF
KI    * GET OVERHEAD ITEM AUTHORIZATION ...
KI   C                   eval      ohauth = 'N'
KI   C                   MOVEL     USRNM         USER
KI   C                   MOVE      'PO'          APP
KI   C                   MOVE      'OHPO'        CDE
KI   C                   MOVE      0001          ID
KI   C                   MOVE      *BLANKS       USRVAL
KI   C                   MOVE      *BLANKS       VALFRM
KI   C                   MOVE      *BLANKS       RTNCOD
KI   C                   CALL      'OPR8220'     PL8220
KI   C     RTNCOD        IFEQ      '0'
KI   C                   MOVEL     USRVAL        ohauth            1
KI   C                   ENDIF
I2    *
I2    * GET DEFAULT SHIP CODE BASED ON METHOD OF SHIP = OUR TRUCK
I2   C                   MOVE      'IV62'        TABCOD
I2   C                   MOVE      *BLANKS       TABENT
I2   C                   MOVEL     'SHPCODE'     TABENT
I2   C                   MOVE      'O'           TABENT
I2   C                   CLEAR                   DEF_OSHPCODE
I2   C     TABKEY        CHAIN     TBFMTBL                            40
I2   C     *IN40         IFEQ      *OFF
I2   C                   MOVEL     TBNO03        DEF_OSHPCODE
I2   C                   ENDIF
I2    *
I2    * GET DEFAULT SHIP CODE BASED ON METHOD OF SHIP = SHIPPED
I2   C                   MOVE      'IV62'        TABCOD
I2   C                   MOVE      *BLANKS       TABENT
I2   C                   MOVEL     'SHPCODE'     TABENT
I2   C                   MOVE      'S'           TABENT
I2   C                   CLEAR                   DEF_SSHPCODE
I2   C     TABKEY        CHAIN     TBFMTBL                            40
I2   C     *IN40         IFEQ      *OFF
I2   C                   MOVEL     TBNO03        DEF_SSHPCODE
I2   C                   ENDIF
I2    *
I2    *------------------------------------------------
H5    * Check whether using Intellichief is used.
H5   C                   MOVE      '0'           ERR01             1
H5   C                   MOVE      *BLANKS       TABCOD
H5   C                   MOVEL     'IMAG'        TABCOD
H5   C                   MOVE      *BLANKS       TABENT
H5   C                   MOVEL     'ICSYS'       TABENT
H5   C     TABKEY        CHAIN     TBFMTBL                            40
H5   C     *IN40         IFEQ      *OFF
H5   C                   MOVEL     TBNO03        ICSYS             1
H5   C                   ELSE
H5   C                   MOVE      'N'           ICSYS
H5   C                   ENDIF
H5   C     ICSYS         IFEQ      'Y'
H5   C                   CALL      'OPC9805'
H5   C                   PARM                    ERR01             1
H5   C                   ENDIF
H5   C                   if        err01 = '1' and
H5   C                             isWebFaced() = *on
H5   C                   eval      err01 = '0'
H5   C                   endif
H5   C     ICSYS         IFEQ      'Y'
H5   C                   MOVE      *ON           SV57              1
H5   C                   ELSE
H5   C                   MOVE      *OFF          SV57
H5   C                   ENDIF
H5    *
      *
     C                   MOVE      '1'           *IN28                          DFLT SFLDROP
     C                   MOVE      *ZEROS        APNO01
     C                   MOVE      'PO'          APPCDE            2            APPLICATION
     C                   Z-ADD     *ZERO         RTRNCD                         RETURN CODE
     C                   MOVE      *BLANKS       TABENT
     C                   MOVE      *BLANKS       TBNO03
     C                   MOVEL     'FAX '        TABCOD                         TABLE CODE
     C                   MOVEL     'PO'          TABENT                         TABLE ENTRY
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TBNO03        FXOPTS            2            SET WRKFLD
     C                   END
     C                   MOVEL     'LOCAL'       TABENT                         TABLE ENTRY
     C     TABKEY        CHAIN     TBFMTBL                            40
     C                   CLEAR                   XX
     C     *IN40         DOWEQ     *OFF
     C     XX            ANDLT     50
     C                   ADD       1             XX                2 0
     C                   MOVEL     TBNO03        FCD(XX)
     C     TABKEY        READE     TBFMTBL                                40
     C                   ENDDO
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'EDI '        TABCOD                         TABLE CODE
     C                   MOVEL     'EDI '        TABENT                         TABLE ENTRY
     C                   MOVE      'Y'           TABENT                         TABLE ENTRY
     C     TABKEY        SETLL     TBFMTBL                                40
     C     *IN40         IFEQ      '1'
     C                   MOVE      'Y'           EDI               1            SET WRKFLD
     C                   END
     C     EDI           IFEQ      'Y'
     C                   MOVEL     'EDI '        TABCOD                         TABLE CODE
     C                   MOVEL     'PO850S'      TABENT                         TABLE ENTRY
     C                   MOVE      'Y'           TABENT                         TABLE ENTRY
     C     TABKEY        SETLL     TBFMTBL                                40
     C     *IN40         IFEQ      '1'
     C                   MOVE      'Y'           EDI                            SET WRKFLD
     C                   END
     C                   END
      *
      * CHECK IF FAXING IS SET UP FOR SALES ORDERS
     C                   MOVE      'FAX '        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'EMAIL'       TABENT
     C                   CLEAR                   EALLOW
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        EALLOW            1
     C                   ENDIF
      *
      * CHECK FOR SETUP PROD # OR DESCRIPTION ON PRICING SCREEN
     C                   MOVE      'PO06'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'OPTIONS'     TABENT
     C                   CLEAR                   TPRD
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        TPRD              1
     C                   ENDIF
KD    * Determine if Buyer ID is t be defaulted from User Profile...
KD   C                   MOVE      'PO06'        TABCOD
KD   C                   MOVE      *BLANKS       TABENT
KD   C                   MOVEL     'DFTBUYID'    TABENT
KD   C                   CLEAR                   DfltyBuyer
KD   C     TABKEY        CHAIN     TBFMTBL                            40
KD   C     *IN40         IFEQ      *OFF
KD   C                   MOVEL     TBNO03        DfltyBuyer        1
KD   C                   ELSE
KD   C                   EVAL      DfltyBuyer = 'N'
KD   C                   ENDIF
KM    *
KM    * Retrieve flag for changing price sheet status for costing items
KM   C                   MOVE      'PO06'        TABCOD
KM   C                   MOVE      *BLANKS       TABENT
KM   C                   MOVEL     'PRCSHTSTS'   TABENT
KM   C                   CLEAR                   ALWPSSTS          1
KM   C     TABKEY        CHAIN     TBFMTBL                            40
KM   C     *IN40         IFEQ      *OFF
KM   C                   MOVEL     TBNO03        ALWPSSTS
KM   C                   ENDIF
KN    *
KN    * Retrieve flag for changing price sheet status for costing items
KN   C                   MOVE      'PO06'        TABCOD
KN   C                   MOVE      *BLANKS       TABENT
KN   C                   MOVEL     'MANUFREQ '   TABENT
KN   C                   CLEAR                   MANUFREQ          1
KN   C     TABKEY        CHAIN     TBFMTBL                            40
KN   C     *IN40         IFEQ      *OFF
KN   C                   MOVEL     TBNO03        MANUFREQ
KN   C                   ENDIF
KP    * Retrieve flag for displaying/defaulting option for receiving reports
KP   C                   MOVE      'PO06'        TABCOD
KP   C                   MOVE      *BLANKS       TABENT
KP   C                   MOVEL     'PRTRCVRPT'   TABENT
KP KUC*                  CLEAR                   MANUFREQ          1
KU   C                   CLEAR                   PRTRCVOPT
KP   C     TABKEY        CHAIN     TBFMTBL                            40
KP   C     *IN40         IFEQ      *OFF
KP   C                   MOVEL     TBNO03        PRTRCVOPT
KP   C                   ENDIF
KD    *
KD    *  If default Buyer ID is active,
KD   C                   if        DfltyBuyer = 'Y'
KD    *  Determine if Buyer ID should be protected ?
KD   C                   MOVE      'PO06'        TABCOD
KD   C                   MOVE      *BLANKS       TABENT
KD   C                   MOVEL     'PROTECTID'   TABENT
KD   C                   CLEAR                   ProtectBuyer
KD   C     TABKEY        CHAIN     TBFMTBL                            40
KD   C     *IN40         IFEQ      *OFF
KD   C                   MOVEL     TBNO03        ProtectBuyer      1
KD   C                   ELSE
KD   C                   EVAL      ProtectBuyer = 'N'
KD   C                   ENDIF
KD   C                   endif
KF    *
KF    * Retrieve Bid cost flags
KF   C                   CLEAR                   BIDCOST
KF   C                   MOVE      *BLANKS       TABENT
KF   C                   MOVE      'OB01'        TABCOD                         TABLE CODE
KF   C                   MOVEL     'RTNCST'      TABENT                         TABLE ENTRY
KF   C     TABKEY        CHAIN     TBFMTBL                            40
KF   C     *IN40         IFEQ      '0'
KF   C                   MOVEL     TBNO03        BIDCOST
KF   C                   ENDIF
KD    *
¢S    *
¢S    * GET DATE FOR DUPLICATE ITEM CHECKING
¢S   C                   MOVE      'CM08'        TABCOD
¢S   C                   MOVE      *BLANKS       TABENT
¢S   C                   MOVEL     'DUPITEM'     TABENT
¢S   C     TABKEY        CHAIN     TBFMTBL                            40
¢S   C     *IN40         IFEQ      *OFF
¢S   C                   MOVEL     TBNO03        DUPITMDATE
¢S   C                   ENDIF
      *------------------------------------------------------------------------*
      *  SECTION 1      PROCESS PURCHASE ORDER ENTRY
      *
      * STEP 1.  PROMPT PO#, INITIALIZE FIELDS
      * STEP 2.  VENDOR INFORMATION
      * STEP 3.  HEADER INFORMATION
      * STEP 4.  MAILING INFORMATION
      * STEP 5.  SHIPPING INFORMATION
      * STEP 6.  LINE ITEM ENTRY
      * STEP 7.  LINE ITEM PRICES
      * STEP 8.  ORDER COMPLETION SCREEN
      * STEP 9.  WRITE ORDER
      * STEP 11  SEND FAX
      *------------------------------------------------------------------------*
      * STEP 1.  PROMPT PO#, INITIALIZE FIELDS
      *------------------------------------------------------------------------*
     C     PRMPT         TAG
HX    *
HX    * Clear OPPWTRA in qtemp
HX   c                   call      'OPR2506'
HX   c                   parm                    attachTxt
HX ILc*                  parm                    attachType
IL   c                   parm      '!!!'         attachType
HX   c                   parm      'D'           fileOpt
IL   c                   Clear                   attachType
HX    *
   IGC*                  MOVE      'N'           DQFLG             1
     C                   EXSR      CLRWKF
      *
      * INITIALIZE THE SEND FAX OPTIONS
      *
     C                   MOVE      *BLANKS       OPTS
     C                   CLEAR                   EMAIL
      *
      * IF PO PARAMETER WAS PASSED TO THIS PROGRAM, THEN PLACE IT IN
      * THE DISPLAY FILE FIELD AND PROTECT FIELD FROM INPUT...
     C     POPARM        IFNE      0
      * IF A P/O REF# W/MULTI BRANCHES PLACE PO PARM IN REF# FIELD
     C     XXXWHR        IFEQ      '%'
     C                   MOVE      POPARM        PONO25
     C                   MOVE      *BLANK        WHRFRM
     C                   MOVE      *ON           *IN72
     C                   ELSE
      *
     C                   MOVE      POPARM        PONO01
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      * IF CALLED FROM BO/LOWSTOCK AND USER F3S OUT OF P/O THEN DELETE
      * P/O
     C     *IN03         IFEQ      *ON
     C     WHRFRM        ANDEQ     'B'
     C                   EXCEPT    DUM1
     C                   MOVE      'B'           CODE1
     C                   MOVE      PONO01        PO#
     C                   MOVE      'O'           POSTS
     C                   CALL      'POR0130'
     C                   PARM                    PO#
     C                   PARM                    CODE1
     C                   PARM                    POSTS
     C                   PARM                    VNDNUM
     C                   PARM                    WHRFRM
HV   C                   PARM      ' '           PGMFRM
     C                   ENDIF
      *
      * IF USER TRIED TO EXIT FROM ANOTHER SCREEN, THEN GO BACK T THE
      * CALLING PROGRAM...
     C     *IN03         CABEQ     '1'           ENDPGM                         CMD 03 RETURN
     C                   END
      *
      * IF RETURNED BY CMD-03 RELEASE (POFTOH) P/O HDR.
     C     *IN03         IFEQ      '1'
     C     RELFLG        ANDEQ     'Y'
     C                   EXCEPT    DUM1                                         UNLOCK HDR
     C                   END
      *
      * IF A P/O PARAMETER WAS PASSED IN,
      * WE WILL BYPASS THE PROMPT SCREEN ON THE FIRST TIME IN THE
      * PROGRAM... BUT IF THERE ARE ANY ERRORS WHICH CAUSE THE PGM TO
      * REDISPLAY THE PROMPT, THEN WE WILL SHOW IT...
     C     POPARM        IFNE      0
     C     FSTTIM        IFEQ      'Y'
     C                   EXFMT     POF0120L                                     P.O.# PROMPT
     C                   END
     C                   MOVE      'Y'           FSTTIM            1
      * NO P/O PARAMETER, DISPLAY THE PROMPT...
     C                   ELSE
     C                   EXFMT     POF0120L                                     P.O.# PROMPT
     C                   END
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVE      *OFF          *IN68
     C                   MOVE      *OFF          *IN69
     C                   MOVE      *OFF          *IN90
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN92
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           PRMPT
     C                   END
      *
      * CMD 03 RETURN
     C     *IN03         CABEQ     '1'           ENDPGM                         CMD 03 RETURN
H4    *
H4    * F15=My transactions
H4   c                   if        *in15 = *on                                  F15=My transactions
H4   c                   eval      pActCd = 'HD'
H4   c                   eval      pData = *blanks
H4   c                   eval      %subst(pData : 1 : 3) = 'PO '
H4   c                   call      'SHR0306'     pl0306
H4   c                   if        pData <> *blanks
H4   c                   movel     pData         pono01
H4   c                   endif
H4   c                   endif
H4    *
      * CHECK TO SEE IF P/O REFERENCE NUMBER LOGIC
     C     PONO01        IFEQ      0
      * ERROR IF BRANCH KEYED AND REFERENCE IF NOT
     C     PONO02        IFGT      0
     C     PONO25        ANDEQ     0
     C                   MOVE      *ON           *IN91
     C                   MOVEL     UMS(57)       MSGFLD
     C                   GOTO      PRMPT
     C                   END
      * IF THE REF# AND THE BRANCH IS KEYED CHECK REF LOGICAL TO SEE
      * IF REF# IS VALID
     C     PONO25        IFGT      0
     C     PONO02        ANDGT     0
     C                   MOVE      PONO02        SAVSHP
      * SEE IF PO REF# EXIST
     C     PONO25        CHAIN     POFTOH6                            40
     C     *IN40         IFEQ      '1'
     C                   SETON                                        68
     C                   END
      * SEE IF PO REF# BRANCH EXIST
     C                   MOVE      SAVSHP        PONO02
     C     REFBKY        CHAIN     POFTOH6                            40
     C     *IN40         IFEQ      '1'
     C                   SETON                                        69
     C                   END
      * SEE IF PO REF# HAS MULTI PO'S IF SO CALL THE PO REF INQUIRY
     C     REFBKY        READE     POFTOH6                                40
     C     *IN40         IFEQ      '0'
     C                   GOTO      REFINQ
     C                   END
      *
     C     *IN68         IFEQ      *ON                                                      E
     C                   MOVE      *ON           *IN91
     C                   MOVEL     UMS(58)       MSGFLD
     C                   GOTO      PRMPT
     C                   ENDIF
     C     *IN69         IFEQ      *ON                                                      E
     C                   MOVE      *ON           *IN92
     C                   MOVEL     UMS(59)       MSGFLD
     C                   GOTO      PRMPT
     C                   ENDIF
      *
     C     *IN68         IFEQ      '0'                                                      E
     C     *IN69         ANDEQ     '0'                                                      E
     C                   GOTO      TRYA                                         PROCESS REF# PO
     C                   END
     C                   ELSE
     C     REFINQ        TAG
      * PASS THE PROCESS CODES FOR THE REFERENCE SELECTION PGM
      *           1 PROCESS BY REF# ONLY
      *           2 SHOW ALL NOT ZERO REFERENCE NUMBER P/O 'S
     C     PONO25        IFGT      0
     C                   MOVE      '1'           RETCDE            1
     C                   ELSE
     C                   MOVE      '2'           RETCDE
     C                   END
     C                   END
     C                   MOVE      PONO25        WKNO25            7            REF#
     C                   MOVE      PONO02        WKNO02            3            BRANCH
      * CALL REFERENCE NBR SELECTION PGM
     C                   CALL      'POR0315'                                    REF SELECTION
     C                   PARM                    WKNO25                         REF#
     C                   PARM                    WKNO02                         BRANCH
     C                   PARM                    RETCDE                         RETURN CODE
     C     RETCDE        IFEQ      'N'
     C                   SETON                                        68
     C     *IN68         CABEQ     '1'           PRMPT                          ERROR MESSAGE
     C                   ELSE
     C     RETCDE        IFEQ      'C'
      * IF WE ARE COMING FROM ROR MAINTENANCE, AND
      * IF USER EXITS OUT OF SELECTION LIST, THEN PASS BACK (X) TO
      * INFORM ROR TO FINISH, OTHERWISE CONTINUE DISPLAYING PO LIST...
     C     XXXWHR        IFEQ      '%'
     C                   MOVE      'X'           WHRFRM
     C     XXXWHR        CABEQ     '%'           ENDPGM
     C                   ENDIF
     C                   SETOFF                                       40
     C                   SETOFF                                       666869
     C                   GOTO      PRMPT
     C                   ELSE
      *  REFERENCE SELECTED
     C                   MOVE      WKNO25        PONO01                                     E
     C                   END
     C                   END
     C                   END
      *
     C                   MOVE      ' '           RELFLG            1            REL REC FLAG
     C     TRYA          TAG                                                    RETRY
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      'Y'           DSPF1
     C     *IN92         DOUEQ     *OFF
     C     PONO01        CHAIN     POFTOH                             4092
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C     DSPF2         IFEQ      'N'                                          DO NOT RETRY
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C                   GOTO      PRMPT
     C                   ENDIF
     C                   ENDDO
KB    * GET QUOTE #
KB   C                   MOVE      *BLANKS       POCDA4
KB   C     PONO01        CHAIN(N)  POFTOHA
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
   H1C*    *IN40         CABEQ     '1'           PRMPT                    90    ERROR MESSAGE
H1   C     *IN40         IFEQ      *ON
H1   C                   MOVE      *ON           *IN90
H1   C     MSGFLD        IFEQ      *BLANKS
H1   C                   MOVEL     UMS(55)       MSGFLD
H1   C                   ENDIF
H1   C                   GOTO      PRMPT
H1   C                   ENDIF
KY   C                   eval      XXTL02 = POTL02                              load PO total
     C                   MOVE      'Y'           RELFLG                         REL REC FLAG
HX    *
HX    * Write to OPPWTRA in qtemp
HX   c                   eval      attachTxt = *blanks
HX   c                   eval      attachTxt = %editc(pono01 : 'X')
HX   c                   call      'OPR2506'
HX   c                   parm                    attachTxt
HX   c                   parm                    attachType
HX   c                   parm      ' '           fileOpt
HX    *
      * IF MAINTAINING A DIRECT P/O
      * CHECK ALL THE RECEIVERS FOR THE P/O
      * IF ANY RECEIVER HAS A LOCK FLAG = YES
      * DO NOT ALLOW P/O MAINTENEANCE
      * IF NO LOCK FLAG IS FOUND
      * UPDATE ALL THE RECEIVERS FOR THE P/O WITH A LOCK FLAG = Y
      *
     C     POCD01        IFEQ      'D'
     C                   MOVEA     *ZEROS        LCK
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      'Y'           DSPF1
     C     *IN92         DOUEQ     *OFF
     C     PONO01        CHAIN     POFTRH                             4992
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C     DSPF2         IFEQ      'N'                                          DO NOT RETRY
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C                   EXCEPT    DUM1                                         UNLOCK HDR
     C                   GOTO      PRMPT
     C                   ENDIF
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN49         DOWEQ     *OFF
     C     POCD24        IFEQ      'Y'
     C                   EXSR      RMVLCK
     C                   MOVEL     UMS(60)       MSGFLD
     C                   EXCEPT    DUM1                                         UNLOCK HDR
     C                   EXCEPT    UNLRH3                                       UNLOCK RCV
     C                   GOTO      PRMPT
     C                   ELSE
     C                   Z-ADD     1             L                 4 0
     C     *ZEROS        LOOKUP    LCK(L)                                 48
     C     *IN48         IFEQ      *ON
     C                   Z-ADD     PONO19        LCK(L)
     C                   MOVE      'Y'           POCD24
     C                   EXCEPT    UPDRH3
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *IN92         SVIN92                         SAVE *IN92
     C                   MOVE      'Y'           DSPF1
     C     *IN92         DOUEQ     *OFF
     C     PONO01        READE     POFTRH                               9249
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C     DSPF2         IFEQ      'N'                                          DO NOT RETRY
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C                   EXSR      RMVLCK
     C                   EXCEPT    DUM1                                         UNLOCK HDR
     C                   EXCEPT    UNLRH3                                       UNLOCK RCV
     C                   GOTO      PRMPT
     C                   ENDIF
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C                   ENDDO
     C                   ENDIF                                                  POCD01 EQ D
      *
      * SEE IF PO REF# SHOULD BE DISPLAYED
     C     PONO25        IFGT      0
     C                   SETON                                        63
     C                   ELSE
     C                   SETOFF                                       63
     C                   END
      *
     C                   EXSR      INITSR
      *
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     PONO01        CHAIN     POFTOH                             4092
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
KB    * GET QUOTE #
KB   C                   MOVE      *BLANKS       POCDA4
KB   C     PONO01        CHAIN(N)  POFTOHA
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN40         IFEQ      *ON
     C                   MOVE      *ON           *IN90
     C                   MOVEL     UMS(55)       MSGFLD
     C                   GOTO      PRMPT
     C                   ENDIF
JZ    * Save current P/O Total amount...
JZ   C                   eval      SavedTotal = potl02
      * RE-CALC P/O TAX PERCENT FROM CURRENT P/O HEADER DATA BEFORE
      * THE DATA CAN BE CHANGED (I.E. QTY/COST CHANGES IN MAINT)...
     C                   Z-ADD     0             TAXPCT
     C     POTL01        IFNE      *ZEROS
     C     POAM04        ANDNE     *ZEROS
     C     POAM04        DIV(H)    POTL01        TAXPC
     C     TAXPC         MULT      100           TAXPCT
     C                   END
     C                   MOVE      POCD41        SAVE41                         SAVE VALUE
     C                   MOVE      PONO02        SAVESB                         SAVE VALUE
      *   SET UP REVISION NUMBER WORK FIELD
     C     PONO18        ADD       1             REVNO
      *   CHECK USERID SECURITY AUTHORIZATION
   HGC*    PXKEY         SETLL     OPFMSEC                                40     ALL BR'S OK
   HGC*    *IN40         IFEQ      '0'
   HGC*                  MOVE      PONO03        OPNO03                         ENTRD BR#
   HGC*    PBKEY         SETLL     OPFMSEC                                40     THIS BR# OK
   HGC*    *IN40         IFEQ      *OFF
HG   C                   CALL      'OPR0015'
HG   C                   PARM      'B'           CHKBRN            1
HG   C                   PARM                    PONO03
HG   C                   PARM                    AUTHBR            1
HG   C     AUTHBR        IFNE      'Y'
     C                   MOVE      *ON           *IN90
     C                   MOVEL     UMS(56)       MSGFLD
     C                   GOTO      PRMPT
     C                   ENDIF
     C     PONO02        CABEQ     0             OPNTAG                         DIR SHIP OK
     C     POCD01        IFNE      'D'
   HGC*                  MOVE      PONO02        OPNO03                         SHIP TO BR#
   HGC*    PBKEY         SETLL     OPFMSEC                                40     THIS BR# OK
   HGC*    *IN40         IFEQ      *OFF
HG   C                   CALL      'OPR0015'
HG   C                   PARM      'B'           CHKBRN
HG   C                   PARM                    PONO02
HG   C                   PARM      'N'           AUTHBR
HG   C     AUTHBR        IFNE      'Y'
     C                   MOVE      *ON           *IN90
     C                   MOVEL     UMS(56)       MSGFLD
     C                   GOTO      PRMPT
     C                   ENDIF
     C                   ELSE
     C                   MOVE      PONO03        OPNO03                         ENTRD BR#
     C                   END
   HGC*                  END
      *
     C     OPNTAG        TAG
     C     POCD42        IFEQ      'Y'
     C     OPNOAL        IFNE      'Y'
     C                   OPEN      OELTOALA
     C                   OPEN      OELTOALB
     C                   OPEN      OELTOAL8
     C                   OPEN      OELTOAH1
     C                   MOVE      'Y'           OPNOAL            1
     C                   ENDIF
     C     TOAD1         IFEQ      *BLANK
     C                   MOVE      'Y'           TOAD1             1
     C                   OPEN      OELTOAD1
     C                   ENDIF
     C     TOAD          IFEQ      *BLANK
     C                   OPEN      OELTOAD2
     C                   MOVE      'Y'           TOAD              1
     C                   ENDIF
     C                   ENDIF
      *------------------------------------------------------------------------*
      * STEP 2. * VENDOR INFORMATION
      *------------------------------------------------------------------------*
     C     VNDTAG        TAG
     C                   EXSR      VNDSR                                        VENDOR INFO
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C                   Z-ADD     0             PONO01                         P.O. NUMBER
     C                   MOVEA     '0'           *IN(56)                        DSPLY MESSAGE
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
#5        // Determine if vendor is SPS or Extol
#5        customerVendor = %editc(APNO01:'X');
#5        customerVendor = %editc(APNO01:'X');
#5        retrieveEDISolution(customerVendor: ediSolution: ediFlag);
#6        if EDISolution = 'SPS';
#6           *in18 = *on;
#6        endif;

#6          // EIPMCTP EDI - Trading Partner File
#6          // EIPMTTP EDI - Trading Partner File
#6         exec sql
#6          select
#6          a.eicd06 into :EDI860
#6          from EIPMCTP a
#6          join EIPMTTP b
#6          on a.eino02 = b.eino02
#6          where a.eicd02 = 'A' and
#6          b.eicd02 = 'A' and
#6          a.eino01 = : APNO01
#6          fetch first row only
#6          with NC;

:A         // Set F10 text for PO based on PO status
:A         Clear F10TEXT;
:A         Clear OpenLines;
:A         Clear POStatus;
:A
:A         Select;
:A          When POCD20='O';
:A            F10TEXT = 'F10=Close PO';
:A            POStatus = 'Open';
:A
:A          When POCD20='C';
:A            F10TEXT = 'F10=Open PO';
:A            POStatus = 'Closed';
:A            exec sql
:A             select count(*) into :OpenLines
:A             from POPTOL
:A             where pono01 = :PONO01 and poqyu1 > poqyu3;
:A         Endsl;
:A
:A         // Determine if PO has been transmitted to the vendor
:A         exec sql
:A          select count(*) into :@Count
:A          from EIPADT
:A          where eino03 = digits(:PONO01);
:A
:A         If @Count > 0;
:A           %subst(POStatus:9:3) = 'EDI';
:A         Endif;

      *------------------------------------------------------------------------*
      * STEP 3. * HEADER INFORMATION
      *------------------------------------------------------------------------*
     C     HDRTAG        TAG
HD   C                   MOVE      *OFF          *IN62
     C                   EXSR      HDRSR                                        HEADER INFO
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
J1   C     *in12         oreq      '1'
     C     POCD01        IFEQ      'D'
     C                   EXSR      RMVLCK
     C                   ENDIF
     C                   Z-ADD     0             PONO01                         P.O. NUMBER
     C                   MOVEA     '0'           *IN(56)                        DSPLY MESSAGE
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN50         IFEQ      '1'                                          UNAPPROVED VEND
     C     *IN12         CABEQ     '1'           VNDTAG                         CMD 12 PREVIOUS
     C                   END
     C     POCD11        CABNE     'Y'           SHPTAG                         MAIL CONFRM CPY
      *------------------------------------------------------------------------*
      * STEP 4. * MAILING INFORMATION
      *------------------------------------------------------------------------*
     C     MALTAG        TAG
     C                   EXSR      MAILSR                                       MAILING INFO
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C     POCD01        IFEQ      'D'
     C                   EXSR      RMVLCK
     C                   ENDIF
     C                   Z-ADD     0             PONO01                         P.O. NUMBER
     C                   MOVEA     '0'           *IN(56)                        DSPLY MESSAGE
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         CABEQ     '1'           HDRTAG                         CMD 12 PREVIOUS
      *------------------------------------------------------------------------*
      * STEP 5. * SHIPPING INFORMATION
      *------------------------------------------------------------------------*
     C     SHPTAG        TAG
HD   C     POCD67        IFEQ      'Y'                                          SHIP TO INFO
HD   C                   MOVE      '1'           *IN62                          SHIP TO INFO
HD   C                   EXSR      SHIPSR                                       SHIP TO INFO
H3   C     *IN12         CABEQ     '1'           HDRTAG                         MAIL CONRM COPY
HD   C                   ENDIF                                                  SHIP TO INFO
     C     PONO02        CABNE     0             LINTAG                         SHIP TO BRANCH
HD   C                   MOVE      '0'           *IN62                          SHIP TO INFO
     C                   EXSR      SHIPSR                                       SHIP TO INFO
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C     POCD01        IFEQ      'D'
     C                   EXSR      RMVLCK
     C                   ENDIF
     C                   Z-ADD     0             PONO01                         P.O. NUMBER
     C                   MOVEA     '0'           *IN(56)                        DSPLY MESSAGE
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         IFEQ      '1'                                          CMD 12 PREVIOUS
     C     POCD11        CABEQ     'Y'           MALTAG                         MAIL CONRM COPY
     C     POCD11        CABNE     'Y'           HDRTAG                         MAIL CONRM COPY
     C                   END
      *------------------------------------------------------------------------*
      * STEP 6. * LINE ITEM ENTRY
      *------------------------------------------------------------------------*
     C     LINTAG        TAG
KN    *
KN    * Determine if vendor is an EDI vendor for manufacturer number edit
KN   C     EDI           IFEQ      'Y'                                          ALLOW EDI ?
KN   C                   MOVE      'V'           VNDCUS
KN   C                   MOVEL     APNO01        CUSNBR
KN   C                   MOVE      '850'         DOCTYP
KN   C                   MOVE      PONO03        VENBRN
KN   C                   MOVE      'N'           EDIPOMF           1
KN   C                   EXSR      GETTPI
KN   C     *IN42         IFEQ      '0'                                          NO EDI
KN   C     MANUFREQ      ANDEQ     'E'                                          Not Factory Dir
KN   C                   MOVE      'Y'           EDIPOMF
KN   C                   ENDIF
KN   C                   ENDIF

:A         // Get the line count for display
:A         clear LastLn;
:A         exec sql
:A          select max(pono05) into :LastLn
:A          from poptol
:A          where pono01=:pono01;

     C                   EXSR      LINSR                                        LINE ITEM ENTRY
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C     POCD01        IFEQ      'D'
     C                   EXSR      RMVLCK
     C                   ENDIF
     C                   Z-ADD     0             PONO01                         P.O. NUMBER
     C                   MOVEA     '0'           *IN(56)                        DSPLY MESSAGE
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         IFEQ      '1'                                          CMD 12 PREVIOUS
     C     PONO02        CABEQ     0             SHPTAG                         SHIP TO BRANCH
     C     POCD11        CABEQ     'Y'           MALTAG                         MAIL CONRM COPY
     C     POCD11        CABNE     'Y'           HDRTAG                         MAIL CONRM COPY
     C                   END
      *------------------------------------------------------------------------*
      * STEP 7. * LINE ITEM PRICES
      *------------------------------------------------------------------------*
     C     PRCTAG        TAG
     C                   EXSR      PRCSR
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C     POCD01        IFEQ      'D'
     C                   EXSR      RMVLCK
     C                   ENDIF
     C                   Z-ADD     0             PONO01                         P.O. NUMBER
     C                   MOVEA     '0'           *IN(56)                        DSPLY MESSAGE
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         CABEQ     '1'           LINTAG                         CMD 12 PREVIOUS
      *------------------------------------------------------------------------*
      * STEP 8. * ORDER COMPLETION SCREEN
      *------------------------------------------------------------------------*
     C     COMTAG        TAG
     C                   EXSR      COMSR
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C     POCD01        IFEQ      'D'
     C                   EXSR      RMVLCK
     C                   ENDIF
     C                   Z-ADD     0             PONO01                         P.O. NUMBER
     C                   MOVEA     '0'           *IN(56)                        DSPLY MESSAGE
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         IFEQ      '1'                                          CMD 12 PREVIOUS
     C                   MOVE      *OFF          *IN52
     C                   GOTO      PRCTAG                                       PRICE TAG
     C                   ENDIF
      *------------------------------------------------------------------------*
      * STEP 9. * WRITE ORDER
      *------------------------------------------------------------------------*
     C                   EXSR      WRTSR
     C     WHMYES        IFEQ      'Y'
     C     POCD01        IFEQ      'D'
HR   C     POCD01        OREQ      'F'
HR   C     POCD01        OREQ      'O'
     C     WHMBR         ORNE      'Y'
     C                   CLEAR                   HDDTA1
     C                   CLEAR                   WMDTA1
     C                   Z-ADD     PONO01        HDNO01
     C                   CLEAR                   WMERR
     C                   CLEAR                   WMFUNC
     C                   CALL      'WIR0143'
     C                   PARM      'POR'         FROM              3
     C                   PARM                    WMFUNC            2
     C                   PARM                    HDDTA1
     C                   PARM                    WMDTA1          256
     C                   PARM                    WMERR             3
     C                   ENDIF
     C                   ENDIF
      *
     C     WHMBR         IFEQ      'Y'
     C     POCD01        ANDNE     'D'
     C     POCD01        ANDNE     'O'                                          Overhead
     C     POCD01        ANDNE     'F'                                          Blanket
     C                   MOVE      'POM'         WMFRM
     C                   CLEAR                   PDATA
     C                   MOVEL     PONO01        PDATA
     C                   CALL      'WXR5952'
     C                   PARM                    WMFRM             3
     C                   PARM                    PDATA           256
     C                   ENDIF
      *
      * IF THIS PO IS DIRECT PO AND AT LEAST ONE LINE ITEM HAS ZERO
      * ON ORDER #
     C                   EXSR      DIRECT
      *
      * IF DIRECT P/O, REMOVE LOCK FLAG FROM ALL RECEIVERS FOR P/O
     C     POCD01        IFEQ      'D'
     C                   EXSR      RMVLCK
     C                   ENDIF
      *------------------------------------------------------------------------*
      * STEP 10 * PRINT PURCHASE ORDER
      *------------------------------------------------------------------------*
     C     PRNTPO        IFEQ      'Y'
     C                   MOVE      PONO01        PONUM             7
     C                   MOVEA     PONUM         ARY(80)
   J0C*                  MOVEA     POCD11        ARY(87)
   J0C*                  MOVEA     'Y'           ARY(88)                        REPRINT P.O.
J0    * Put the reprint flag before the POCD11 flag so they are in the same
J0    * position as the data that is passed into program OPC0500. So the
J0    * position is the same in POC0115, POR0115 and OPC0500.
J0   C                   MOVEA     'Y'           ARY(87)                        REPRINT P.O.
J0   C                   MOVEA     POCD11        ARY(88)
     C                   MOVEA     '000'         ARY(89)                        PRINT REV. ONLY
J0   C                   MOVE      PONO03        BRALPH            3
J0   C                   MOVEA     BRALPH        ARY(92)
J0   C                   MOVE      ' '           P115                           PRT PGM
      *
      *  ADD OPTION TO PRINT REVISION ONLY
     C     PRNTRV        IFEQ      'Y'
     C                   MOVE      PONO18        REVNUM            3            REV # WORK FLD
     C                   MOVEA     REVNUM        ARY(89)                        PRINT REV. ONLY
     C                   END
     C                   MOVE      PONO03        BRALPH            3
     C                   MOVEA     BRALPH        ARY(92)
     C                   MOVEA     P115          ARY(95)
     C                   MOVEA     ARY           CMD             140
     C                   Z-ADD     140           LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM                    LEN
     C                   END
      *------------------------------------------------------------------------*
      * STEP 11 * SEND FAX
      *------------------------------------------------------------------------*
     C                   MOVEA     *BLANKS       TEL
     C     SNDFAX        IFEQ      'F'
     C     SNDFAX        OREQ      'E'
      *------------------------------------------------------------------------*
      *        INITIALIZE & LOAD ARRAY DATA STRUCTURE
      *------------------------------------------------------------------------*
     C                   MOVEA     FX(1)         FX1
     C                   MOVEA     FX(2)         FX2
     C                   MOVEA     FX(3)         FX3
     C                   MOVEA     FX(4)         FX4
J2   C                   MOVEA     FX(5)         FX5
      *
     C                   MOVE      *BLANKS       FAXPH#
     C                   MOVE      *BLANKS       SYSDTA
      *
     C                   MOVE      *BLANKS       SYSTEM
     C                   MOVE      'PO01'        SYSTEM
      *------------------------------------------------------------------------*
      * LOAD PHONE NUMBER WORK FIELD INTO FAX NBR AND CALL FAX PGM...
     C     SNDFAX        IFEQ      'F'
     C                   MOVE      FAXNUM        FAXNBR           32
     C                   ELSE
     C                   CLEAR                   FAXNBR
     C                   ENDIF
     C                   MOVE      PONO01        PONUM             7
J0   C                   MOVE      PRNTPO        POPRT             1
J0   C                   MOVE      PONO03        POENTBR           3
     C                   MOVE      '000'         POSUFX
     C     PRNTRV        IFEQ      'Y'
     C                   MOVE      PONO18        REVNUM                         REV # WORK FLD
     C                   MOVE      REVNUM        POSUFX                         PRINT REV. ONLY
     C                   END
     C                   MOVE      FAXNBR        FAXPH#
     C                   MOVE      REQTIM        RQTIME
     C                   MOVE      REQDAT        RQDATE
   J2C*                  Z-ADD     212           LEN              15 5
J2   C                   Z-ADD     270           LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    FAXDTA
     C                   PARM                    LEN
     C                   END
      *------------------------------------------------------------------------*
      *  SEND EDI REVISED PURCHASE ORDER
      *------------------------------------------------------------------------*
     C     EDIPOR        IFEQ      'Y'
   IVC*    CHGFLG        ANDEQ     'Y'                                          CHG EXISTS
IV   C     EdiFLG        ANDEQ     'Y'                                          CHG EXISTS
     C                   MOVE      PONO01        PONO
     C                   MOVE      ' '           YESNO
     C                   MOVE      ' '           REPRNT
     C                   MOVE      '000'         RVPRNT
     C                   MOVEL     TRPNID        @TPID
     C                   MOVEL     APNO01        @ACCT#
     C                   MOVEL     DSPO          @TRANS
     C                   MOVE      *BLANKS       @ERRCD
     C                   CALL      'EIR1200'
     C                   PARM      'S860'        @DOCID            4
     C                   PARM                    @TPID            15
     C                   PARM                    @ACCT#            6
     C                   PARM                    @TRANS           15
     C                   PARM                    @ERRCD            3
     C                   END
      *------------------------------------------------------------------------*
      *  SEND EDI PURCHASE ORDER
      *------------------------------------------------------------------------*
   #5C*    EDIPO         IFEQ      'Y'
   ¢GC*    EDIPOC        OREQ      'Y'
#5        if ediPO = 'Y' or
#6           (EDIPOC='Y' and ediSolution = 'SPS' and EDI860 = 'Y');
     C                   MOVE      PONO01        PONO
     C                   MOVE      ' '           YESNO
     C                   MOVE      ' '           REPRNT
     C     EDIPOC        IFEQ      'Y'
     C                   MOVE      'Y'           REPRNT                          CONFIRMING
     C                   END
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
     C                   END
      *------------------------------------------------------------------------*
      * Submit Direct Order Audit...
      *------------------------------------------------------------------------*
     C     POCD01        IFEQ      'D'
     C     SVCD01        OREQ      'D'
     C                   MOVE      PONO01        PONUM             7
     C                   MOVEA     PONUM         DOA(75)
     C                   MOVEA     DOA           CMD             140
     C                   Z-ADD     140           LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM                    LEN
     C                   ENDIF
      *------------------------------------------------------------------------*
JG    * Close Purchaes order if all items received...
JG    *------------------------------------------------------------------------*
JG   C                   move      pono01        po#
JG   C                   call      'POR0145'     pl0145
KP    *
KP    * Print receiving report if PRTRR = 'Y' and PO is not closed
KP    *
KP   C     PRTRR         IFEQ      'Y'                                          PRINT RECV REPT
KP   C     PONO01        CHAIN     POLTOH1
KP   C                   IF        %FOUND(POLTOH1)
KP   C                               AND POCD20 <> 'C'
KP   C                   MOVE      'W'           WARCNT            1
KP   C                   MOVE      PONO01        PONUM             7
KP   C                   MOVE      PONO02        BRNCH             3
KP   C                   MOVEA     PONUM         ARY2(13)
KP   C                   MOVEA     BRNCH         ARY2(20)
KP   C                   MOVEA     WARCNT        ARY2(23)
KP   C                   MOVEA     USRNM         ARY2(24)
KP   C                   MOVEA     ARY2          CMD2             51
KP   C                   Z-ADD     51            LEN2             15 5
KP   C                   CALL      'QCMDEXC'
KP   C                   PARM                    CMD2
KP   C                   PARM                    LEN2
KP   C                   ENDIF
KP   C                   ENDIF
      *
     C                   Z-ADD     0             PONO01
     C                   Z-ADD     0             PONO02
     C                   Z-ADD     0             PONO25
      * IF PO NUMBER WAS PASSED IN TO THIS PROGRAM, THEN END PGM...
     C     POPARM        IFEQ      0
     C     PONO01        CABEQ     0             PRMPT
     C                   END
      *
      * END OF JOB
     C     ENDPGM        TAG
IR    * CLEAR PRODUCT SEARCH WORKFILE...
IR   C     SVNO01        SETLL     POFWPOL
IR   C     *IN49         DOUEQ     *ON
IR   C     SVNO01        DELETE    POFWPOL                            49
IR   C                   ENDDO
KE    *
KE   C     SVNO01        SETLL     POFWPOLL
KE   C     *IN49         DOUEQ     *ON
KE   C     SVNO01        DELETE    POFWPOLL                           49
KE   C                   ENDDO
HX    *
HX    * Clear OPPWTRA in qtemp
HX   c                   call      'OPR2506'
HX   c                   parm                    attachTxt
HX   c                   parm                    attachType
HX   c                   parm      'D'           fileOpt
      *
      * IF WM BRANCH, DELETE TEMP DATA QUEUE CREATED TO
      * GET DATA FROM WM SYSTEM
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     DQFLG         ANDEQ     'Y'
     C                   CALL      'WIC9900'
     C                   PARM                    DQNAME
     C                   PARM      #BIPGM        DQLIB
     C                   PARM      'D'           DQACT
     C                   ENDIF
      *
     C                   EXSR      CLRWKF
     C                   SETON                                        LR
     C                   RETURN
      *------------------------------------------------------------------------*
      *  SUBROUTINE    CLEAR TAG WORK FILE                                     *
      *------------------------------------------------------------------------*
     C     CLRWKF        BEGSR
      *
      * CLEAR WORKFILE
      *
     C     TAGOPN        IFEQ      'Y'
     C                   CLOSE     POLWTAG1
     C                   MOVE      'N'           TAGOPN
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       @FILE            10
     C                   MOVE      '0'           FUNCTN            1
     C                   MOVEL     'POPWTAG'     @FILE
     C                   CALL      'OPC9990'
     C                   PARM                    FUNCTN
     C                   PARM                    @FILE
IR    * CLEAR PRODUCT SEARCH WORKFILE...
IR   C     SVNO01        SETLL     POFWPOL
IR   C     *IN49         DOUEQ     *ON
IR   C     SVNO01        DELETE    POFWPOL                            49
IR   C                   ENDDO
KE    *
KE   C     SVNO01        SETLL     POFWPOLL
KE   C     *IN49         DOUEQ     *ON
KE   C     SVNO01        DELETE    POFWPOLL                           49
KE   C                   ENDDO
     C                   ENDSR
      *------------------------------------------------------------------------*
      * REMOVE LOCK FLAG FOR RECEIVERS LOCKED BY THIS MAINT                    *
      *------------------------------------------------------------------------*
     C     RMVLCK        BEGSR
     C                   Z-ADD     1             L
     C     L             DOWLE     400
     C     LCK(L)        IFNE      0
     C                   Z-ADD     LCK(L)        PONO19
     C     PONO19        CHAIN     POFTRH1                            47
     C     *IN47         IFEQ      *OFF
     C                   MOVE      ' '           POCD24
     C                   EXCEPT    UPDRH1
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     400           L
     C                   ENDIF
     C                   ADD       1             L
     C                   ENDDO
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    VENDOR INFORMATION                                      *
      *------------------------------------------------------------------------*
     C     VNDSR         BEGSR
      * UNAPPROVED VENDOR SCREEN
     C     TAGVND        TAG
     C     *IN50         IFEQ      '1'                                          UNAPPROVED VNDR
     C                   EXFMT     POF0120A                                     INFORMATION
     C                   MOVE      UNNAME        APNM01                         VENDOR NAME
     C                   MOVE      ' '           ERRFLG            1            RESET FLAG
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C                   READ      POF0120A                               41
     C     *IN25         CABEQ     '1'           TAGVND
     C                   END
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           ENDVND                         CMD 03 RETURN
     C                   END
     C     *IN03         CABEQ     '1'           TAGVND                   56    CMD 03 RETURN
     C                   MOVEA     '0'           *IN(56)                        MESSAGE DISPLAY
      *
      * EDIT DATA
     C     UNNAME        IFEQ      *BLANKS                                      UNAPROVED NAME
     C                   MOVEA     '1'           *IN(90)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   ELSE
      *
     C     APNM02        IFEQ      *BLANKS                                      SORT NAME
     C                   MOVEL     UNNAME        APNM02
     C                   Z-ADD     20            LEN1              5 0          FIELD LENGTH
     C                   MOVEL     'QSYS'        T1                9            TRANSLATE
     C                   MOVE      'IMAGE'       T1                9            LOWER CASE TO
     C                   MOVEL     T1            TBL              10            UPPER CASE
     C                   CALL      'QDCXLATE'
     C                   PARM                    LEN1
     C                   PARM                    APNM02
     C                   PARM                    TBL
     C                   END
     C                   END
      *
     C     APAD01        IFEQ      *BLANKS                                      ADDRESS LINE 1
     C                   MOVEA     '1'           *IN(91)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     APCY01        IFEQ      *BLANKS                                      CITY
     C                   MOVEA     '1'           *IN(92)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     APST01        IFEQ      *BLANKS                                      STATE
     C                   MOVEA     '1'           *IN(93)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     APZP07        IFEQ      *BLANKS                                      MAIN ZIP CODE
     C                   MOVEA     '1'           *IN(94)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     APNO02        IFEQ      0                                            AREA CODE
     C                   MOVEA     '1'           *IN(95)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     APNO03        IFEQ      0                                            TEL PREFIX #
     C                   MOVEA     '1'           *IN(96)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     ERRFLG        CABEQ     'Y'           TAGVND                         DSPLY ERROR
     C                   END
     C     ENDVND        ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    HEADER INFORMATION                                      *
      *------------------------------------------------------------------------*
     C     HDRSR         BEGSR
KJ   C                   eval      svin69 = *in69
JL   C                   if        splprcaut <> 'Y'
JL   C                   eval      *in71 = *on
JL   C                   endif
JO    * If special pricing flag is blank default it to 'N'...
JO   C                   IF        POFL67 = *BLANKS
JO   C                   EVAL      POFL67 = 'N'
JO   C                   ENDIF
     C                   CLEAR                   *IN24
     C     WMMSG         IFNE      *BLANKS
     C                   MOVE      *ON           *IN24
     C                   ENDIF
H2   C                   IF        APFL12 = *BLANKS
H2   C                   EVAL      APFL12 = 'N'
H2   C                   ENDIF
HD    *
HD    * CONSIGNMENT PURCHASE
HD   C                   MOVE      '1'           *IN26
HD   C     APFL08        IFEQ      'Y'
HD   C                   MOVE      '0'           *IN26
HD HQ * Determine if from ROR and if so, set Consigned to (N)...
HD HQC*    PONO07        IFGT      0
HD HQC*                  MOVE      'N'           POFL65
HD HQC*                  MOVE      'N'           POCD67
HD HQC*                  ENDIF
HD   C                   ENDIF
H5   C                   MOVE      *IN57         SVIN57            1
H5   C                   MOVE      SV57          *IN57
I2   C                   MOVE      POCD57        RNSTS                          ROADNET STS
      * SAVE THE SHIP TO BRANCH...
     C                   MOVE      PONO02        SVNO02
     C                   Z-ADD     PONO02        SAVBR
     C                   MOVE      ' '           BRCHG             1
      * SAVE ETA DATE FOR LATER COMPARISON... THIS HAPPENS ONLY WHEN
      * USER HAS USED F12 TO COME BACK TO HEADER FROM LINE ITEM SFL...
      * SET FLAG TO TELL LINE ITEM LOGIC ETA DATE WAS SAVED IN HEADER..
     C     ETAOH         IFNE      *ZEROS
     C                   Z-ADD     ETAOH         SAVOH                          SV ORIG ETA
     C                   Z-ADD     POCC03        SVCC03                         SV ORIG ETA CENTURY
     C                   MOVE      'Y'           FRMHD1                         FROM HEADER
     C                   END
     C     ETARH         IFNE      *ZEROS
     C                   Z-ADD     ETARH         SAVRH                          SV RVSD ETA
     C                   Z-ADD     POCC14        SVCC14                         SV RVSD ETA CENTURY
     C                   MOVE      'Y'           FRMHD2                         FROM HEADER
     C                   END
      *
      * SAVE DIRECT/NON-DIRECT CODE; USE FOR LATER COMPARISON IF TAGS
      * EXIST.
     C                   MOVE      POCD01        SAVCD1
      *
     C                   CLEAR                   MFLG
     C                   MOVE      *IN68         SV68              1                        E
     C     TAGHDR        TAG
     C                   MOVE      SVIN60        *IN60
      * IF A P/O REF# W/MULTI BRANCHES PLACE PO PARM IN REF# FIELD
     C     XXXWHR        IFEQ      '%'
     C     XXXWHR        OREQ      '$'
     C     BYPHDR        IFEQ      ' '
     C                   MOVE      'Y'           BYPHDR            1
     C                   GOTO      BYPH
     C                   ENDIF
     C                   ENDIF
HM   C     POCD01        IFEQ      'F'
HM   C                   MOVE      *ZEROS        ETAOH
HM   C                   MOVE      *ZEROS        ETARH
HM   C                   ENDIF
H5   C                   MOVE      *IN57         SVIN57            1
H5   C                   MOVE      SV57          *IN57
I2   C                   EXSR      $ROAD
KD    * Do not allow Buyer ID to be Changed ?
KD   C                   If        ProtectBuyer = 'Y'
KD   C                   eval      *in79 = *on
KD   C                   endif

     C                   EXFMT     POF0120B
H5   C                   MOVE      SVIN57        *IN57
KD   C                   eval      *in79 = *off
     C     BYPH          TAG
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN53
     C                   MOVE      *OFF          *IN92
     C                   CLEAR                   MSGFLD
     C                   MOVE      ' '           ERRFLG                         RESET FLAG
G3    *
G3    *  WHMTYP IS SET "N" FOR TYPES D, O, & F.
G3   C     WHMYES        IFEQ      'Y'
G3   C     POCD01        ANDNE     'D'
G3   C     POCD01        ANDNE     'O'
G3   C     POCD01        ANDNE     'F'
G3   C                   MOVE      'Y'           WHMTYP            1
G3   C                   ELSE
G3   C                   MOVE      'N'           WHMTYP
G3   C                   ENDIF
      * Re-set cancel direct backorders warning...
     C     POCD03        IFNE      'Y'
     C     POCD01        ORNE      'D'
     C                   MOVE      *OFF          CBOWRN
     C                   ENDIF
      * RESET NON "ERRMSG" ERROR INDICATORS...
     C                   MOVEA     '00'          *IN(36)
     C                   MOVEA     '00'          *IN(51)
     C                   MOVE      ' '           TAGFLG            1
   :AC*                  MOVE      ' '           WRNR@P
:A   C                   MOVE      ' '           WRNR@P            1
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C                   READ      POF0120B                               41
     C     *IN25         CABEQ     '1'           TAGHDR
     C                   END
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           HDREND                         CMD 03 RETURN
     C                   END
     C     *IN03         IFEQ      '1'                                          CMD 03 RETUR
     C                   MOVE      '0'           *IN98
     C                   MOVE      '0'           *IN94
     C                   MOVE      '1'           *IN56
     C                   GOTO      TAGHDR
     C                   END
     C                   MOVEA     '0'           *IN(56)                        MESSAGE DISPLAY
      *
      * CMD 02 PREVIOUS
     C     *IN50         IFEQ      '1'                                          UNAPPROVED VEND
     C     *IN12         CABEQ     '1'           HDREND                         CMD 12 PREVIOUS
     C                   END
KJ    * CMD 04 PROMPT
KJ   C     *IN04         IFEQ      *ON
KJ   C                   EXSR      @PRMPT
KJ   C                   GOTO      TAGHDR
KJ   C                   ENDIF
KJ   C                   EXSR      @CLCSR
KJ    *
:A
:A         // Set the PO open/close function
:A         Clear PO_OpnCls;
:A         If *in10 and F10TEXT = 'F10=Close PO';
:A           PO_OpnCls = 'C';
:A         Endif;
:A         If *in10 and F10TEXT = 'F10=Open PO';
:A           PO_OpnCls = 'O';
:A         Endif;
:A
H5   C     *IN23         IFEQ      *ON
H5   C     ICSYS         IFEQ      'Y'
JA    * Determine if licensed to this product...
JA    * The following license key checking logic may not be altered, bypassed or removed.
JA    * See Legal Document in WRKMINKEY command for more information.
JA   C                   if        LicToDII
H5   C                   CLEAR                   QSEARCH
H5   C                   MOVEL     'QSEARCH'     QSEARCH
H5   C                   CALL      'OPC9832 '
H5   C                   PARM                    QSEARCH          10
JA    * Display error message if not licensed to DII (IntelliChief)
JA   C                   else
JA   C                   call      'MNR1300'     pl1300
JA   C                   endif
H5   C                   ENDIF
H5   C                   GOTO      TAGHDR
H5   C                   ENDIF
      *
      * ALL ERROR CHECKING THAT IS GOING TO USE 'MSGFLD' MUST BE DONE
      * IN THIS AREA, PRIOR TO ANY OF THE 'OLD' ERROR CHECKING THAT
      * TURNS ON INDICATORS FOR 'ERRMSG' ON THE DDS...
      *
¢O    * ORDER TYPE F AND O ARE DISALLOWED...
¢O   C     POCD01        IFEQ      'F'
¢O   C     ERRFLG        ANDNE     'Y'
¢O   C     POCD01        OREQ      'O'                                          DIRECT ?
¢O   C     ERRFLG        ANDNE     'Y'
¢O   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
¢O   C                   MOVE      'Y'           MFLG              1            ERROR OCCURED
¢O   C                   MOVEA     CMS(4)        MSGFLD                         ERROR OCCURED
¢O   C                   END
      * ETA DEFAULT MUST BE 'H' FOR DIRECTS...
     C     POCD41        IFNE      'H'
     C     POCD01        ANDEQ     'D'                                          DIRECT ?
     C     ERRFLG        ANDNE     'Y'
     C                   MOVE      'H'           POCD41
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   MOVE      'Y'           MFLG              1            ERROR OCCURED
     C                   MOVEA     UMS(47)       MSGFLD                         ERROR OCCURED
     C                   END
      * ALL ERROR CHECKING THAT IS GOING TO USE 'MSGFLD' MUST BE
      * PLACED ABOVE THIS CODE...
     C     ERRFLG        CABEQ     'Y'           TAGHDR
     C     MSGFLD        IFEQ      *BLANKS
     C     MFLG          ANDEQ     'Y'
     C                   CLEAR                   MFLG
H5   C                   MOVE      SV57          *IN57
I2   C                   EXSR      $ROAD
KD    * Do not allow Buyer ID to be Changed ?
KD   C                   If        ProtectBuyer = 'Y'
KD   C                   eval      *in79 = *on
KD   C                   endif
     C                   WRITE     POF0120B
H5   C                   MOVE      svin57        *IN57
KD   C                   eval      *in79 = *off
     C                   ENDIF
      *
      * EDIT DATA
      *
HD
HD    *  Consignment Flag Validations
HD    *  Consignment FLAGS must be 'Y' OR 'N'
HD   C                   MOVE      *Off          *IN62                          RI/PC
HD   C     *in26         Ifeq      '0'
HD   C     POFL65        IFNE      'Y'
HD   C     POFL65        ANDNE     'N'
HD   C                   MOVE      *ON           *IN62                          RI/PC
HD   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
HD   C                   MOVE      'Y'           MFLG                           ERROR OCCURED
HD   C     MSGFLD        IFEQ      *BLANKS
HD   C                   MOVEA     EMS(61)       MSGFLD
HD   C                   ENDIF
HD   C                   ENDIF
HD    *
HD   C                   MOVE      *Off          *IN64                          RI/PC
HD   C     POCD67        IFNE      'Y'
HD   C     POCD67        ANDNE     'N'
HD   C                   MOVE      *ON           *IN64                          RI/PC
HD   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
HD   C                   MOVE      'Y'           MFLG                           ERROR OCCURED
HD   C     MSGFLD        IFEQ      *BLANKS
HD   C                   MOVEA     EMS(62)       MSGFLD
HD   C                   ENDIF
HD   C                   ENDIF
HD    *  Consignment Purchase flag must be 'Y' if vendor rep = 'Y'
HD   C     POFL65        IFNE      'Y'
HD   C     POCD67        ANDEQ     'Y'
HD   C                   MOVE      *ON           *IN62                          RI/PC
HD   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
HD   C     MSGFLD        IFEQ      *BLANKS
HD   C                   MOVEA     EMS(60)       MSGFLD
HD   C                   ENDIF
HD   C                   ENDIF
HD   C                   ENDIF
HD    * Do not allow Consigned if Direct, Blanket or Overhead...
HD   C     POFL65        IFEQ      'Y'
HD   C     POCD01        IFEQ      'D'
HD   C     POCD01        OREQ      'F'
HD   C     POCD01        OREQ      'O'
HD   C                   MOVE      *ON           *IN62                          RI/PC
HD   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
HD   C                   MOVE      'Y'           MFLG                           ERROR OCCURED
HD   C     MSGFLD        IFEQ      *BLANKS
HD   C                   MOVEA     EMS(63)       MSGFLD
HD   C                   ENDIF
HD   C                   ENDIF
HD   C                   ENDIF
      * USER CANNOT CHANGE "SHIP TO" BRANCH IF TAGS EXIST
      *
     C     SVNO02        IFNE      PONO02
      *
     C                   MOVE      *OFF          SHBCHG            1
     C                   MOVE      'Y'           BRCHG
     C                   MOVE      *ON           SHBCHG
     C                   SELECT
     C     TRTCNT        WHENGT    *ZEROS
     C                   MOVE      *ON           *IN53
     C                   MOVE      'Y'           ERRFLG
     C     SOTCNT        WHENGT    *ZEROS
     C                   MOVE      *ON           *IN67
     C                   MOVE      'Y'           ERRFLG
     C     COTCNT        WHENGT    *ZEROS
     C                   MOVE      *ON           *IN59
     C                   MOVE      'Y'           ERRFLG
     C     WOTCNT        WHENGT    *ZEROS
     C                   MOVE      *ON           *IN67
     C                   MOVE      'Y'           ERRFLG
     C                   OTHER
      *
      * IF TAG COUNT IS ZERO - WE COULD STILL HAVE NON-STOCK TAGS
      * BECAUSE THEY ARE NOT ADDED TO THE COUNTERS.  THE REASON IS
      * THAT NON-STOCK TAGS ARE PROTECTED AND CANNOT BE REMOVED BY
      * THE USER (WE ALWAYS AUTO TAG). SO WE WILL NEED TO CHECK
      * AND SEE IF ANY NON-STOCK TAGS EXIST, AND IF SO, DELETE THEM.
      * BUT ONLY TAGS WITH REFERENCE NUMBERS, WE WANT TO LEAVE ALL
      * COMMENT TAGS.
      *
     C                   MOVE      *IN51         SV51              1
     C                   Z-ADD     1             Y                 3 0
     C     *IN51         DOUEQ     *OFF
     C     *ZEROS        LOOKUP    KY(Y)                              51
     C     *IN51         IFEQ      *ON
     C                   MOVE      TH(Y)         TAGH
     C     TREF          IFNE      *ZEROS
HI   C     TREF          ANDNE     *BLANKS
     C                   CLEAR                   TAGH
     C                   MOVE      TAGH          TH(Y)
     C                   Z-ADD     *ZEROS        KY(Y)
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
     C                   MOVE      SV51          *IN51
     C                   ENDSL
      *
     C                   ENDIF
      *
     C     POID01        IFEQ      '   '                                        BUYERS ID
     C                   MOVEA     '1'           *IN(80)                        ERROR MESSAGE
¢Q   C                   MOVEA     CMS(07)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   ELSE
      *
      * USE API TO VALIDATE BUYER ID.
     C                   MOVE      POID01        ABUYID
     C                   MOVE      *BLANKS       ABUYRC
     C                   CALL      'POR0118'     PL0118
     C     ABUYRC        IFNE      '0'
   ¢QC*                  MOVEA     '1'           *IN(97)                        ERROR MESSAGE
¢Q   C                   MOVE      '1'           *IN80                          ERROR MESSAGE
¢Q   C                   MOVEA     CMS(08)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
¢Q    * If valid buyer initials,
¢Q    * Check the initials against the user profile initials
¢Q    * If initials are not the same, do not allow the initials
¢Q   C     ABUYRC        IFEQ      '0'
¢Q   C     POID01        CHAIN     IMFCBUY
¢Q   C                   IF        NOT %FOUND
¢Q   C                   CLEAR                   CMAM01
¢Q ¢1C*                  CLEAR                   CMNM06
¢Q   C                   ENDIF
¢1   C     POID01        CHAIN     IMFMBUY
¢1   C                   IF        NOT %FOUND
¢1   C                   CLEAR                   IMNM06
¢1   C                   ENDIF
¢1   C     IMNM06        IFNE      USRNM
¢Q ¢1C*    CMNM06        IFNE      USRNM
¢Q   C                   MOVE      '1'           *IN80                          ERROR MESSAGE
¢Q   C                   MOVEA     CMS(09)       MSGFLD
¢Q   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
¢Q   C                   ENDIF
¢Q   C                   ENDIF
     C                   END
      *
     C     POID02        IFEQ      '   '                                        ENTERED BY
     C                   MOVEA     '1'           *IN(90)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
JL    *
JL    *  SPECIAL PRICING
JL    *
JL   C                   if        splprcaut = 'Y'
JL   C                   eval      *IN72  = *OFF
JL   C     POFL67        IFNE      'Y'
JL   C     POFL67        ANDNE     'N'
JL   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
JL   C                   eval      *IN72  = *ON
JL   C                   endif
JL   C                   endif
      *
     C     POCD01        IFNE      ' '                                          P/O TYPE
     C                   MOVE      *BLANKS       TBNO03
     C                   MOVE      *BLANKS       TABENT
     C                   MOVE      'PO02'        TABCOD                         TABLE CODE
     C                   MOVEL     POCD01        TABENT                         TABLE ENTRY
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C                   ELSE
     C                   MOVEA     '1'           *IN(40)
     C                   END
      *
     C     *IN40         IFEQ      '1'                                          EXIST ????
     C                   MOVEA     '1'           *IN(81)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   ELSE
      *
      *  FIRST TIME THRU, DETERMINE IF A DIRECT ORDER INITIALLY
      *
     C     FRSTHR        IFEQ      'Y'                                          1ST TIME THR
     C     POCD01        IFEQ      'D'
     C                   MOVE      'D'           FRSTHR                         1ST = DIRECT
     C                   ELSE
     C                   MOVE      'N'           FRSTHR                         1ST = OTHER
     C                   END
     C                   ELSE
      *
      *  NOT 1ST TIME, HAS INIT DIRECT CHG'D TO OTHER, RESET TO OTHER
      *
     C     FRSTHR        IFEQ      'D'
     C     POCD01        IFNE      'D'
     C                   MOVE      'N'           FRSTHR                         SET = OTHER
     C                   END
     C                   END
     C                   END
      *
     C     POCD01        IFEQ      'D'                                          DIRECT
     C     OURTRK        IFNE      ' '                                          OUR TRUCK
     C                   MOVEA     '1'           *IN(95)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
      *
     C     POCD01        IFNE      'F'                                          BLANKET ORDER
   #8C*    SHPDAT        IFNE      0
     C                   Z-ADD     SHPDAT        PDATE
     C                   Z-ADD     *ZEROS        PJULI
     C                   CALL      'GPR0100'     EDTDAT                         EDIT FOR
     C     PJULI         IFEQ      0                                             VALID SHP
     C                   MOVE      '1'           *IN87                            DATE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
   #8C*                  END
      *
      * VALIDATE THE ORIGINAL ETA DATE...
     C                   Z-ADD     ETAOH         PDATE
     C                   Z-ADD     *ZEROS        PJULI
     C                   CALL      'GPR0100'     EDTDAT                         EDIT FOR
     C     PJULI         IFEQ      0                                             VALID ETA
     C                   MOVE      '1'           *IN88                            DATE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   ELSE
      * NOW THAT WE HAVE A GOOD DATE, MAKE SURE DATE IS NOT LESS THAN
      * THE CURRENT DATE, BUT ONLY IF DATE HAS BEEN CHANGED...
     C     ETAOH         IFNE      SAVOH
     C                   MOVE      'D'           ZZFUNC
     C                   Z-ADD     ETAOH         ZZDATE                         HEADER ETA
     C                   Z-ADD     UDATE         ZZDIFF                         CURRENT DATE
     C                   CALL      'UDR'         UDRPRM
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETAOH         PDATE6                         ORIG ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACEN        POCC03
     C                   MOVEL     POCC03        POCYR3                         ETA CEN/YR
     C                   MOVE      POYR03        POCYR3
     C     ZZDAYS        IFLT      0                                            LT UDATE "CURRENT YR
     C     POCYR3        ORLT      *YEAR                                        OLDER THAN 1 YEAR ?
     C                   MOVE      '1'           *IN36
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   MOVE      SAVOH         ETAOH                          RESTORE ORIG
     C                   MOVE      SVCC03        POCC03                         RESTORE ORIG CEN
     C                   END
     C                   END
     C                   END
      * VALIDATE THE REVISED ETA DATE...
     C                   Z-ADD     ETARH         PDATE
     C                   Z-ADD     *ZEROS        PJULI
     C                   CALL      'GPR0100'     EDTDAT                         EDIT FOR
     C     PJULI         IFEQ      0                                             VALID ETA
     C                   MOVE      '1'           *IN99                            DATE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   ELSE
      * NOW THAT WE HAVE A GOOD DATE, MAKE SURE DATE IS NOT LESS THAN
      * THE CURRENT DATE, BUT ONLY IF DATE HAS BEEN CHANGED...
     C     ETARH         IFNE      SAVRH
     C                   MOVE      'D'           ZZFUNC
     C                   Z-ADD     ETARH         ZZDATE                         HEADER ETA
     C                   Z-ADD     UDATE         ZZDIFF                         CURRENT DATE
     C                   CALL      'UDR'         UDRPRM
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETARH         PDATE6                         REPLACE RSVD
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACEN        POCC14                         REVISED ETA CENTURY
     C                   MOVEL     POCC14        PCYR14                         REVISED ETA YEAR
     C                   MOVE      POYR14        PCYR14                         REVISED ETA CEN/YEAR
     C     ZZDAYS        IFLT      0                                            LT UDATE "CURRENT YR
     C     PCYR14        ORLT      *YEAR                                        OLDER THAN 1 YEAR ?
     C                   MOVE      '1'           *IN37
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   MOVE      SAVRH         ETARH                          RESTORE ORIG
     C                   MOVE      SVCC14        POCC14                         RESTORE RVSD CEN
     C                   END
     C                   END
     C                   END
      *
     C     ORDDAT        IFNE      0
     C                   Z-ADD     ORDDAT        PDATE
     C                   Z-ADD     *ZEROS        PJULI
     C                   CALL      'GPR0100'     EDTDAT                         EDIT FOR
     C     PJULI         IFEQ      0                                             VALID SHP
     C                   MOVE      '1'           *IN86                            DATE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   ELSE
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ORDDAT        PDATE6                         DATE ORDERED
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACEN        POCC02                         ORD DATE CENTURY
     C                   END
     C                   END
      *
     C                   ELSE
     C     SHPDAT        IFNE      0
     C                   MOVE      '1'           *IN54
     C                   MOVE      'Y'           ERRFLG
     C                   END
     C     ETAOH         IFNE      0
     C                   MOVE      '1'           *IN55
     C                   MOVE      'Y'           ERRFLG
     C                   END
     C     ETARH         IFNE      0
     C                   MOVE      '1'           *IN66
     C                   MOVE      'Y'           ERRFLG
     C                   END
     C                   END
     C                   END
      *
     C     ORDDAT        IFEQ      0                                            DATE ORDERED
     C                   Z-ADD     UDATE         ORDDAT
     C                   MOVEL     *YEAR         POCC02                         CENTURY ORDERED
     C                   END
      *
     C                   MOVE      POMO02        ORDMO
     C                   MOVE      PODY02        ORDDY
     C                   MOVE      POCC02        ORDCC
     C                   MOVE      POYR02        ORDYR
     C     SHPDAT        IFNE      0
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      SHPDAT        PDATE6                         SHIP DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACEN        POCC04                         SHP DATE CENTURY
     C                   MOVE      POMO04        SHPMO
     C                   MOVE      PODY04        SHPDY
     C                   MOVE      POCC04        SHPCC
     C                   MOVE      POYR04        SHPYR
     C     ORCYMD        IFGT      SHCYMD                                       ORD DATE GT ETA
     C     SHPWRN        ANDNE     'Y'
     C     ERRFLG        ANDNE     'Y'
     C                   MOVE      *ON           *IN32                          WARNING MESSE
     C                   MOVE      'Y'           SHPWRN            1
     C                   MOVE      'Y'           ERRFLG
     C     ERRFLG        CABEQ     'Y'           TAGHDR
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     *ZERO         POCC04                         SHIP CENTURY
     C                   ENDIF
      *
     C                   MOVE      POMO03        ETAMO
     C                   MOVE      PODY03        ETADY
     C                   MOVE      POCC03        ETACC
     C                   MOVE      POYR03        ETAYR
     C     ORCYMD        IFGT      ETCYMD                                       ORD DATE GT ETA
     C     POCD01        ANDNE     'F'                                          NOT BLANKET
     C                   MOVE      *ON           *IN51                          ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   MOVE      SAVOH         ETAOH                          RESTORE ORIG
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETAOH         PDATE6                         ORIG ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACEN        POCC03
     C                   ENDIF
      *
     C                   MOVE      POMO14        ETARMO
     C                   MOVE      PODY14        ETARDY
     C                   MOVE      POYR14        ETARYR
     C                   Z-ADD     5             PDATYP                         DATE TYPE
     C                   MOVE      ETRYMD        PDATE6                         ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDATE8        TRCYMD                         ETA DATE
     C     ORCYMD        IFGT      TRCYMD                                       ORD DATE GT ETA
     C     POCD01        ANDNE     'F'                                          NOT BLANKET
     C     *IN51         ANDEQ     *OFF                                         ORD DATE GT ETA
     C                   MOVE      *ON           *IN52                          ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   MOVE      SAVRH         ETARH                          RESTORE ORIG
     C                   MOVE      SVCC14        POCC14                         RESTORE RVSD CEN
     C                   ENDIF
     C     PONO03        IFEQ      0                                            ENT BY BRANCH
     C                   MOVEA     '1'           *IN(82)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   ELSE
     C     PONO03        SETLL     ARFMBCH                                40    BRANCH MASTER
     C     *IN40         IFEQ      '0'                                          NOT SETUP
     C                   MOVEA     '1'           *IN(82)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   ELSE
     C                   MOVE      PONO03        SAVBR#
     C                   END
      *   CHECK USERID SECURITY AUTHORIZATION
   HGC*    PXKEY         SETLL     OPFMSEC                                40     ALL BR'S OK
   HGC*    *IN40         IFEQ      '0'
   HGC*                  MOVE      PONO03        OPNO03
   HGC*    PBKEY         SETLL     OPFMSEC                                40     THIS BR# OK
   HGC*    *IN40         IFEQ      '0'
HG   C                   CALL      'OPR0015'
HG   C                   PARM      'B'           CHKBRN
HG   C                   PARM                    PONO03
HG   C                   PARM      'N'           AUTHBR
HG   C     AUTHBR        IFNE      'Y'
     C                   MOVE      *ON           *IN68                          ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
   HGC*                  END
     C                   END
      *
     C                   Z-ADD     400           ITMSIZ                         REG PO SIZE
     C                   MOVE      ' '           DFLG              1            DIRECT FLAG
      *
     C                   MOVE      'N'           CRTRNS                         CRT TEMPORARY ITEM
     C     POCD01        IFEQ      'D'                                          DIRECT SHIPMENT
     C                   MOVE      'Y'           CRTRNS                         CRT TEMPORARY ITEM
     C     PONO02        IFNE      0                                            SHIP TO BRANCH
     C                   MOVEA     '1'           *IN(91)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   Z-ADD     400           ITMSIZ                         DIR SF SIZE
     C                   MOVE      'Y'           DFLG
     C                   END
      *
      * MUST BE DIRECT IF LOT PURCHASE
      * SET FLAG ON HERE TO SELECT C/O FILES INSTEAD OF S/O FILES
      *
     C     POCD42        IFEQ      'Y'
     C     POCD01        ANDNE     'D'
     C                   MOVE      *ON           *IN58                          ERRMSG
     C                   MOVE      'Y'           ERRFLG
     C                   ELSE
      *
     C     POCD01        IFEQ      'C'                                          CALENDAR BUY
     C     PONO02        IFEQ      0                                            SHIP TO BRANCH
     C                   MOVEA     '1'           *IN(96)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
      *
     C     POCD01        IFEQ      'B'                                          BUYOUT
     C     PONO02        IFEQ      0                                            SHIP TO BRANCH
     C                   MOVEA     '1'           *IN(96)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
      *
     C     POCD01        IFEQ      'S'                                          SPECIAL
     C     PONO02        IFEQ      0                                            SHIP TO BRANCH
     C                   MOVEA     '1'           *IN(96)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
      *
     C     POCD01        IFEQ      'J'                                          JOB
     C     PONO02        IFEQ      0                                            SHIP TO BRANCH
     C                   MOVEA     '1'           *IN(96)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
      *
     C     POCD01        IFEQ      'O'                                          OVERHEAD
     C     PONO02        IFEQ      0                                            SHIP TO BRANCH
     C                   MOVEA     '1'           *IN(96)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
     C                   ENDIF
I2    *--------------------------------------------------------
I2    * ROADNET STATUS
I2    *--------------------------------------------------------
I2   C                   MOVE      *OFF          *IN63
I2    *
I2   C     RNSTS         IFNE      *BLANKS
I2   C     RNSTS         ANDNE     'ND'                                         NOT TO BE DOWNL
I2   C     RNSTS         ANDNE     'DW'                                         DOWNLOADED
I2   C     RNSYS         ANDEQ     'Y'
I2   C     RNAUTF        ANDEQ     'Y'
I2   C                   MOVE      *ON           *IN63
I2   C                   MOVE      'Y'           ERRFLG                         ERROR
I2   C                   ENDIF
I2    *--------------------------------------------------------
      *
      * DONT ALLOW SHIP TO BRANCH TO BE CHG'D IF PO CREATED BY AN ROR..
     C     PONO02        IFNE      0                                            SHIP TO BRANCH
     C     PONO02        SETLL     ARFMBCH                                40    BRANCH MASTER
     C     *IN40         IFEQ      '0'                                          NOT SETUP
     C                   MOVEA     '1'           *IN(85)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *   CHECK USERID SECURITY AUTHORIZATION
   HGC*    PXKEY         SETLL     OPFMSEC                                40     ALL BR'S OK
   HGC*    *IN40         IFEQ      '0'
   HGC*                  MOVE      PONO02        OPNO03
   HGC*    PBKEY         SETLL     OPFMSEC                                40     THIS BR# OK
   HGC*    *IN40         IFEQ      '0'
HG   C                   CALL      'OPR0015'
HG   C                   PARM      'B'           CHKBRN
HG   C                   PARM                    PONO02
HG   C                   PARM      'N'           AUTHBR
HG   C     AUTHBR        IFNE      'Y'
     C                   MOVE      *ON           *IN37                          ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
   HGC*                  END
     C                   END
      *
     C     ORDDAT        IFEQ      0                                            DATE ORDERED
     C                   Z-ADD     UDATE         ORDDAT
     C                   MOVEL     *YEAR         POCC02                         ORDERED CEN
     C                   END
      *
     C                   Z-ADD     0             CNT               1 0          COUNT
     C     POCD01        IFNE      'D'
     C     OURTRK        IFNE      ' '                                          OUR TRUCK
     C                   ADD       1             CNT                            COUNT
     C                   END
     C     SHIPED        IFNE      ' '                                          SHIPPED
     C                   ADD       1             CNT                            COUNT
     C                   END
     C     CNT           IFEQ      0
     C                   MOVEA     '1'           *IN(83)                        ERRMSG
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C     CNT           IFGT      1
     C                   MOVE      '1'           *IN35                          ERRMSG
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   ELSE
     C     POCD01        IFEQ      'D'
     C     SHIPED        IFNE      ' '
     C     OURTRK        ANDEQ     ' '
     C                   ADD       1             CNT
     C                   END
     C     CNT           IFEQ      0
     C                   MOVE      '1'           *IN31
     C                   MOVE      'Y'           ERRFLG
     C                   END
     C                   END
     C                   END
      * IF OUR TRUCK SELECTED, REQUIRE SHIP VIA & FREIGHT TO BE BLANK..
     C     OURTRK        IFNE      ' '                                          OUR TRUCK
     C     PODN02        IFNE      *BLANKS                                      SHIPPED VIA
     C                   MOVE      '1'           *IN33                          ERRMSG
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C     POCD04        IFNE      ' '                                          FREIGHT CHK
     C                   MOVE      '1'           *IN34                          ERRMSG
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
      * MAKE SURE THE ETA LINE ITEM DEFAULT CODE HAS A PROPER VALUE...
     C     POCD41        IFNE      'H'
     C     POCD41        ANDNE     'L'
     C                   MOVE      '1'           *IN30                          ERRMSG
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   END
      *
HT   C     APFL12        IFNE      'Y'                                          FREIGHT CHK
HT   C     APFL12        ANDNE     'N'                                          FREIGHT CHK
HT   C                   MOVE      '1'           *IN43                          ERRMSG
HT   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
HT   C                   END
     C     SHIPED        IFNE      ' '                                          ENT BY BRANCH
     C     PODN02        IFEQ      *BLANKS                                      SHIPPED VIA
     C                   MOVEA     '1'           *IN(84)                        ERRMSG
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
KJ    *
KJ    * SHIP VIA VALIDATION FOR VENDOR RHEEM VND# 684200
KJ   C     PODN02        IFNE      *BLANKS
KJ   C                   CLEAR                   TABCOD
KJ   C                   CLEAR                   TABENT
KJ   C                   MOVE      'PO07'        TABCOD
KJ   C                   MOVEL     APNO01        TABENT
KJ   C                   MOVE      'N'           SHIPOK            1
KJ   C     TABKEY        CHAIN     TBFMTBL                            40
KJ   C     *IN40         IFEQ      '1'
KJ   C                   MOVE      'Y'           SHIPOK
KJ   C                   ELSE
KJ   C     *IN40         DOWEQ     '0'
KJ   C                   MOVEL     TBNO03        SHIPCK           15
KJ   C     SHIPCK        IFEQ      PODN02
KJ   C                   MOVE      'Y'           SHIPOK            1
KJ   C                   LEAVE
KJ   C                   ENDIF
KJ   C     TABKEY        READE     TBFMTBL                                40
KJ   C                   ENDDO
KJ   C                   ENDIF
KJ   C                   MOVE      '0'           *IN69
KJ   C     SHIPOK        IFEQ      'N'
KJ   C                   MOVE      '1'           *IN69
KJ   C                   MOVE      'Y'           ERRFLG
KJ   C                   ENDIF
KJ   C                   ENDIF
KJ    *
     C     POCD04        IFEQ      ' '                                          FREIGHT CHK
     C                   MOVE      '1'           *IN38                          ERRMSG
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       PODN02                         SHIPPED VIA
     C                   END
      *
     C     PONM02        IFEQ      *BLANKS                                      CONFIRM TO NAME
     C                   MOVEA     '1'           *IN(89)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
      * If it's a direct only allow backorders to be cancelled if
      * the user is authorized or if the cancel b/o flag was already
      * a Y and it was already a direct...
      *
     C     POCD01        IFEQ      'D'                                          Direct P/O
     C     POCD03        ANDEQ     'Y'                                          Cancel B/O
     C     DBOAUT        IFNE      'Y'
     C     SVCD01        IFNE      'D'
     C     SVCD03        ORNE      'Y'
     C                   MOVE      *ON           *IN92                          RI PC       E
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(53)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      * If direct backorders are being cancelled display a warning
      * message...
     C                   ELSE
     C     ERRFLG        IFNE      'Y'
     C     CBOWRN        IFNE      *ON
     C                   MOVE      *ON           CBOWRN            1
     C                   MOVE      *ON           *IN92                          RI PC       E
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   MOVEL     EMS(55)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     POCD03        IFNE      'N'                                          CANCEL B/O
     C     POCD03        IFNE      'Y'                                          CANCEL B/O
     C                   MOVEA     '1'           *IN(92)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(52)       MSGFLD
     C                   ENDIF
     C                   END
     C                   END
      *
     C     ERRFLG        CABEQ     'Y'           TAGHDR                         DSPLY ERROR
      *
      * WARNINGS?
     C     *IN98         IFEQ      '0'
     C     SHPDAT        IFNE      0
     C     SHCYMD        IFGE      MAXDT
     C     SHCYMD        ORLE      MINDT
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   MOVE      '1'           *IN98
     C                   END
     C                   END
     C                   END
      *
      *  CHECK IF ORDER TYPE CHANGED TO DIRECT FROM INITIAL VALUE
      *
     C     *IN94         IFEQ      '0'
     C     FRSTHR        IFEQ      'N'                                          ORIG = OTHER
     C     POCD01        IFEQ      'D'                                          TYP NOW DIR
     C     SAVCNT        IFGT      400                                          ORD LINES>56
     C                   MOVE      '1'           *IN94                          WARN MSG >56
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
     C                   END
     C                   END
      * WARN USER THAT CHANGING THE "SHIP TO" BRANCH IS NOT ADVISED
      * IF THE PURCHASE ORDER WAS CREATED BY AN ROR...
     C     ONCE          IFEQ      ' '
     C     ERRFLG        ANDNE     'Y'                                          NO ERROR
     C     PONO07        IFNE      0                                            FROM AN ROR?
     C     PONO02        ANDNE     SVNO02                                       CHANGED ?
     C                   MOVEA     '1'           *IN(93)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   MOVE      'Y'           ONCE
     C                   END
     C                   END
      * WARN USER IF ETA DATE DEFAULT WAS CHANGED...
     C     *IN39         IFEQ      '0'
     C     SAVE41        ANDNE     POCD41                                       CHANGED ?
     C                   MOVE      '1'           *IN39
     C                   MOVE      'Y'           ERRFLG
     C                   END
      * WARN USER IF SHIP TO BRANCH WAS CHANGED WHILE ETA DATE DEFAULT
      * CODE IS AN 'L' (USE LEAD TIMES)...
     C     *IN29         IFEQ      '0'
     C     SAVESB        ANDNE     PONO02                                       CHANGED ?
     C     POCD41        ANDEQ     'L'                                          CHANGED ?
     C                   MOVE      '1'           *IN29
     C                   MOVE      'Y'           ERRFLG
     C                   END
      *
      * IF ORDER CHANGED FROM OTHER TO DIRECT, CHECK IF TAGS EXIST AND
      * SET ON INDICATOR FOR MSG; SET FLAG ON TO DISPLAY TAG SCREEN LATER.
     C     POCD01        IFEQ      'D'
     C     SAVCD1        ANDNE     'D'
     C     PONO01        SETLL     POFTTG                                 41
     C     *IN41         IFEQ      '1'
     C                   MOVE      'Y'           TAGFLG
     C     *IN27         IFEQ      '0'
     C                   MOVE      '1'           *IN27
     C                   MOVE      'Y'           ERRFLG
     C                   END
     C                   END
     C                   END
      *
      * IF ORDER CHANGED FROM DIRECT TO OTHER, CHECK IF TAGS EXIST AND
      * SET ON FLAG FOR WARNING MSG.
     C     POCD01        IFNE      'D'
     C     SAVCD1        ANDEQ     'D'
     C     PONO01        SETLL     POFTTG                                 41
     C     *IN41         IFEQ      '1'
     C                   MOVE      'Y'           TAGFLG
     C     *IN61         IFEQ      '0'
     C                   MOVE      '1'           *IN61
     C                   MOVE      'Y'           ERRFLG
     C                   END
     C                   END
     C                   END
      * WARNING ?
     C     ERRFLG        CABEQ     'Y'           TAGHDR
     C                   MOVE      '0'           *IN94
     C                   MOVE      '0'           *IN98
     C                   MOVE      '0'           *IN39
     C                   MOVE      '0'           *IN61
     C                   MOVE      '0'           *IN27
     C                   MOVE      POCD01        SAVCD1
     C                   MOVE      SV68          *IN68                                      E
      *
      * DETERMINE IF WM INSTALLED AT BRANCH
     C                   MOVE      'N'           WHMBR
     C     WHMYES        IFEQ      'Y'
     C                   CLEAR                   WMCOBR
     C                   CLEAR                   WHMBR
     C     PONO02        CHAIN     ARFMBCH                            40
     C                   Z-ADD     ARNO15        WMCO#
     C                   Z-ADD     PONO02        WMBR#
HU   C                   Z-ADD     *ZEROS        WMCO#
     C                   CALL      'WIC0116'
     C                   PARM                    WMCOBR
     C                   PARM                    WHMBR             1
     C                   ENDIF
      *
      * IF WM BRANCH, CREATE TEMP DATA QUEUE TO GET DATA FROM WM SYSTEM
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     DQFLG         ANDNE     'Y'
     C                   TIME                    TIME#             6 0
     C                   MOVE      TIME#         TIMEA             6
     C     'DQ'          CAT(P)    TIMEA:0       DQNAME           10
     C                   CALL      'WIC9900'
     C                   PARM                    DQNAME
     C                   PARM      #BIPGM        DQLIB            10
     C                   PARM      'C'           DQACT             1
     C                   MOVE      'Y'           DQFLG
     C                   ENDIF
     C                   CLEAR                   *IN24
JL   C                   eval      *in71 = *off
   H5C*    HDREND        ENDSR
H5   C     HDREND        TAG
H5   C                   MOVE      SVIN57        *IN57
KJ   C                   eval      *in69 = svin69
#0
#0    * Check to see if PO should be checked for NPI items
#0      ChkNPI = 'Y';
#0      TBNO01 = 'NPI';
#0      TBNO02 = 'NONPI';
#0      TBNO03 = %editc(PONO02:'X');
#0      Setll (TBNO01:TBNO02:TBNO03) TBLMTBL4;
#0      If %equal;
#0        ChkNPI = 'N';
#0      Else;
#0        TBNO03 = %editc(PONO03:'X');
#0        Setll (TBNO01:TBNO02:TBNO03) TBLMTBL4;
#0        If %equal;
#0          ChkNPI = 'N';
#0        Endif;
#0      Endif;
#0
H5   C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    MAILING INFORMATION                                     *
      *------------------------------------------------------------------------*
     C     MAILSR        BEGSR
     C     TAGMAL        TAG
     C                   EXFMT     POF0120C                                     MAILING INFO
     C                   MOVEA     '0'           *IN(95)                        ERROR MESSAGE
     C                   MOVE      ' '           ERRFLG                         RESET FLAG
     C                   MOVE      FAX1C         MFAX1C
     C                   MOVE      FAX2C         MFAX2C
     C                   MOVE      FAX3C         MFAX3C
JB   C                   eval      faxsv = faxsc
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           TAGMAL
     C                   END
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           MALEND                         CMD 03 RETURN
     C                   END
     C     *IN03         CABEQ     '1'           TAGMAL                   56    CMD 03 RETURN
     C                   MOVEA     '0'           *IN(56)                        MESSAGE DISPLAY
      *
      * CMD 12 PREVIOUS
     C     *IN12         CABEQ     '1'           MALEND                         CMD 12 PREVIOUS
      *
      * CMD 13 ALTERNATE MAILING ADDRESSES
     C     *IN22         IFEQ      '1'                                          CMD 22 ADDRESS
     C                   Z-ADD     2             SEQMAL                         SEQUENCE #
     C                   MOVE      '1'           APCD08                         TYPE CODE
     C     MAILKY        SETLL     APFMVAD
     C     KYMAIL        READE     APFMVAD                                40
     C     *IN40         CABEQ     '1'           TAGMAL                   95    ERROR MESSAGE
     C                   EXSR      ALTADD
     C     *IN03         CABEQ     '1'           MALEND
     C     *IN22         CABEQ     '1'           TAGMAL
     C                   END
      *
      * EDIT DATA
     C     MNAME         IFEQ      *BLANKS                                      MAIL TO NAME
     C                   MOVEA     '1'           *IN(90)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     MADD1         IFEQ      *BLANKS                                      MAILING ADDRS 1
     C                   MOVEA     '1'           *IN(91)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     MCITY         IFEQ      *BLANKS                                      MAILING CITY
     C                   MOVEA     '1'           *IN(92)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     MSTAT         IFEQ      *BLANKS                                      MAILING STATE
     C                   MOVEA     '1'           *IN(93)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     MMAIN         IFEQ      *BLANKS                                      MAILING ZIP COD
     C                   MOVEA     '1'           *IN(94)                        ERROR MESSAGE
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C     ERRFLG        CABEQ     'Y'           TAGMAL                         DSPLY ERROR
     C     MALEND        ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    ALTERNATE MAILING ADDRESSES                             *
      *------------------------------------------------------------------------*
     C     ALTADD        BEGSR
      * CLEAR SUBFILE
     C                   MOVE      *BLANK        SEL
     C                   Z-ADD     0             RRN
     C                   MOVEA     '1000'        *IN(73)
     C                   WRITE     POC0120K
     C                   MOVEA     '0000'        *IN(73)
      *
      * FILL SUBFILE
     C                   Z-ADD     1             SEQMAL                         SEQUENCE #
     C     MAILKY        SETGT     APFMVAD
     C     *IN41         DOUEQ     '1'
     C     KYMAIL        READE     APFMVAD                                41
     C     *IN41         IFEQ      '0'
     C                   ADD       1             RRN
     C                   WRITE     POS0120K
     C                   END
     C                   END
      *
      * DISPLAY VENDOR MAILING ADDRESSES
     C     DSPADD        TAG
     C                   MOVEA     '0111'        *IN(73)
     C                   WRITE     POF0120K
     C                   EXFMT     POC0120K
     C                   MOVEA     '0000'        *IN(73)
      *
      * CALL USER DOCUMENTATION
     C     *IN25         IFEQ      '1'
     C                   CALL      'HTR0010'
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           DSPADD
     C                   END
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           ALTEND                         CMD 03 RETURN
     C                   END
     C     *IN03         CABEQ     '1'           DSPADD                   56    CMD 03 RETURN
     C                   MOVEA     '0'           *IN(56)                        MESSAGE DISPLAY
      *
      * CMD 12 PREVIOUS
     C     *IN12         CABEQ     '1'           ALTEND                         CMD 12 PREVIOUS
      *
      * READ SUBFILE
     C                   READC     POS0120K                               41
     C     *IN41         CABEQ     '1'           DSPADD
      *
     C     SEL           IFNE      ' '
     C                   MOVE      APAD04        MADD1
     C                   MOVE      APAD05        MADD2
     C                   MOVE      APAD06        MADD3
     C                   MOVE      APST02        MSTAT
     C                   MOVE      APCY02        MCITY
     C                   MOVE      APZP08        MMAIN
      * ESTABLISH SELECTED TELEPHONE & FAX NUMBERS FOR DISPLAY ONLY...
     C                   MOVE      APNO22        TEL1C
     C                   MOVE      APNO23        TEL2C
     C                   MOVE      APNO24        TEL3C
     C                   MOVE      APNO32        FAX1C
     C                   MOVE      APNO33        FAX2C
     C                   MOVE      APNO34        FAX3C
     C                   MOVE      APCD44        FAX4C
     C                   MOVE      APNO32        NO32SV
     C                   MOVE      APNO33        NO33SV
     C                   MOVE      APNO34        NO34SV
     C                   Z-ADD     APNO28        NO28              3 0          ADDRESS SEQ #
     C                   END
     C     SEL           CABEQ     ' '           DSPADD
     C     ALTEND        TAG
     C                   MOVE      '1'           *IN79
     C                   WRITE     POC0120K
     C                   MOVE      '0'           *IN79
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    SHIPPING INFORMATION                                    *
      *------------------------------------------------------------------------*
     C     SHIPSR        BEGSR
     C     TAGSHP        TAG
     C     FRSTSP        IFEQ      'Y'                                          FIRST TIME THRU
     C                   MOVE      'N'           FRSTSP                         FIRST TIME THRU
     C     PONO13        IFEQ      0                                            CUSTOMER #
     C                   MOVE      *BLANKS       ARNM01                         CUSTOMER NAME
     C                   Z-ADD     0             SAVCUS            6 0          SAVE CUSTOMER #
     C                   ELSE
     C     PONO13        IFNE      SAVCUS
     C                   Z-ADD     PONO13        SAVCUS                         SAVE CUSTOMER #
     C     PONO13        CHAIN     ARFMCUS                            40        CUSTOMER MSTR
     C     *IN40         IFEQ      '0'
     C                   EXSR      CKCLOS                                       CUST CLOSED?
     C     *IN95         CABEQ     *ON           TAGSH1
     C                   MOVE      CUSHIP        SSHIP                          CUSTOMER SHIPIN
     C                   ELSE
     C                   MOVEA     '1'           *IN(95)                        ERROR MESSAGE
     C                   MOVEA     EMS(1)        MSGFLD
     C                   Z-ADD     0             SAVCUS                         SAVE CUSTOMER #
     C                   MOVE      *BLANKS       ARNM01                         CUSTOMER NAME
     C                   END                                                    ADDRESS
     C                   END
     C                   END
     C                   END
HD   C                   MOVE      *BLANKS       SHPLOOP           1            ERROR MESSAGE
      *
     C     TAGSH1        TAG
     C                   EXFMT     POF0120D                                     SHIP TO INFO
     C                   CLEAR                   MSGFLD
     C                   MOVEA     '000000'      *IN(90)
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           TAGSHP
     C                   END
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           SHPEND                         CMD 03 RETURN
     C                   END
     C     *IN03         IFEQ      *ON
     C                   MOVE      *ON           *IN56
     C                   MOVEA     EMS(9)        MSGFLD
     C                   GOTO      TAGSHP
     C                   ENDIF
     C                   MOVEA     '0'           *IN(56)
      *
      * CMD 12 PREVIOUS
     C     *IN12         CABEQ     '1'           SHPEND                         CMD 12 PREVIOUS
      *
     C     PONO13        IFNE      SAVCUS                                       CUSTOMER
     C                   MOVE      'Y'           FRSTSP                         ENTERED/CHANGED
     C                   MOVE      'N'           BNHERE            1
     C     PONO13        CABNE     SAVCUS        TAGSHP                         ????
     C                   END
      *
      * EDIT DATA
HD    * Vendor Rep
HD   C     *IN62         IFEQ      '1'
HD   C     PONOR6        IFEQ      *BLANKS
HD   C                   MOVEA     '1'           *IN(95)                        ERROR MESSAGE
HD   C                   MOVEA     EMS(58)       MSGFLD
HD   C                   GOTO      TAGSHP
HD   C                   ENDIF
HD   C                   ENDIF
     C     SNAME         IFEQ      *BLANKS                                      SHIP TO NAME
     C                   MOVEA     '1'           *IN(90)                        ERROR MESSAGE
     C                   MOVEA     EMS(4)        MSGFLD
     C                   GOTO      TAGSHP
     C                   END
      *
     C     SADD1         IFEQ      *BLANKS                                      SHIPING ADDRS 1
     C                   MOVEA     '1'           *IN(91)                        ERROR MESSAGE
     C                   MOVEA     EMS(5)        MSGFLD
     C                   GOTO      TAGSHP
     C                   END
      *
     C     SCITY         IFEQ      *BLANKS                                      SHIPING CITY
     C                   MOVEA     '1'           *IN(92)                        ERROR MESSAGE
     C                   MOVEA     EMS(6)        MSGFLD
     C                   GOTO      TAGSHP
     C                   END
      *
     C     SSTAT         IFEQ      *BLANKS                                      SHIPING STATE
     C                   MOVEA     '1'           *IN(93)                        ERROR MESSAGE
     C                   MOVEA     EMS(7)        MSGFLD
     C                   GOTO      TAGSHP
     C                   END
      *
     C     SMAIN         IFEQ      *BLANKS                                      SHIPING ZIP COD
     C                   MOVEA     '1'           *IN(94)                        ERROR MESSAGE
     C                   MOVEA     EMS(8)        MSGFLD
     C                   GOTO      TAGSHP
     C                   END
      * IF THIS IS A DIRECT P/O AND TAGS EXIST, WARN IF THE CUSTOMER
      * NUMBER IS CHANGED...
HD   C     *IN62         IFEQ      '0'
     C     POCD01        IFEQ      'D'
     C     CUSTSV        ANDNE     PONO13
     C     BNHERE        ANDEQ     'N'
     C     TAGH          ANDNE     *BLANKS
     C                   MOVE      *ON           *IN95
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVE      'Y'           BNHERE
     C                   MOVE      *BLANKS       BLKTAG
     C                   MOVEA     EMS(10)       MSGFLD
     C                   GOTO      TAGSHP
     C                   ENDIF
     C                   ENDIF
HD   C                   ENDIF
HD    * Vendor Location Code
HD   C     *IN62         IFEQ      '1'
HD   C     POCD70        IFEQ      *BLANKS
HD   C     SHPLOOP       ANDEQ     *BLANKS
HD   C                   MOVE      SMAIN         POCD70                         ERROR MESSAGE
HD   C                   MOVE      'N'           SHPLOOP           1            ERROR MESSAGE
HD   C                   MOVEA     EMS(59)       MSGFLD
HD   C                   GOTO      TAGSHP
HD   C                   ENDIF
HD   C                   ENDIF
      *
     C     SHPEND        ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    LINE ITEM ENTRY                                         *
      *------------------------------------------------------------------------*
     C     LINSR         BEGSR
KN   C                   MOVE      *IN61         SVIN61            1
      * INITIALIZE SUBFILE
      *
     C                   MOVE      *IN51         SVIN51            1
     C                   MOVE      *IN54         SVIN54            1
     C                   Z-ADD     1             DSPRRN
     C     CMD12         IFEQ      'Y'
     C     DFLG          IFEQ      'Y'
     C                   MOVE      '1'           *IN77
     C                   WRITE     POC0120E
     C                   MOVE      '0'           *IN77
     C                   MOVE      ' '           CMD12
     C                   ELSE
     C                   MOVE      '1'           *IN77
     C                   WRITE     POC0120N
     C                   MOVE      '0'           *IN77
     C                   MOVE      ' '           CMD12
     C                   END
     C                   END
      *
     C     CMD12         IFNE      'Y'                                          CMD 12 PREVIOUS
     C                   Z-ADD     1             RRN
     C                   MOVEA     '1'           *IN(70)                        INITIALIZE
     C     ITMSIZ        IFEQ      400
     C                   WRITE     POC0120E                                     ENTRY SUBFILE
     C                   ELSE
     C                   WRITE     POC0120N                                     DIRECT ENTSFE
     C                   END
     C                   MOVEA     '0'           *IN(70)                        SETOF INITIALIZ
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C                   MOVEA     '0'           *IN(57)                        EXTENDED DESC
KQ   C                   Z-ADD     0             FINDLN                         RESET
     C                   MOVE      *OFF          *IN59                          RESET ERROR
     C                   EXSR      LOAD                                         LOAD SF FROM DS
     C                   MOVE      ' '           BRCHG
     C                   END
      *
      * IF THE ETA DATE DEFAULT CODE WAS CHANGED, THEN SET THE "DIFF"
      * FLAG FOR LATER USE, AND SAVE THE NEW VALUE...
     C     SAVE41        IFNE      POCD41
     C                   MOVE      'Y'           DIFF              1            DIFFERENT
     C                   MOVE      'Y'           NOVRFY            1            NO VRFY MSG
     C                   MOVE      POCD41        SAVE41            1            SAVE VALUE
     C                   END
      * IF THE SHIP TO BRANCH WAS CHANGED, THEN SET THE "DIFF"
      * FLAG FOR LATER USE, AND SAVE THE NEW VALUE...
     C     SAVESB        IFNE      PONO02
     C     POCD41        ANDEQ     'L'
     C                   MOVE      'Y'           DIFF                           DIFFERENT
     C                   MOVE      'Y'           NOVRFY                         NO VRFY MSG
     C                   MOVE      PONO02        SAVESB                         SAVE VALUE
     C                   END
      * IF THE ETA HEADER DATES WERE CHANGED, THEN SET THE "DIFF"
      * FLAG FOR LATER USE.  NEW VALUES WILL BE SAVED LATER IN PGM...
     C     ETAOH         IFNE      SAVOH                                        ORIG
     C     ETARH         ORNE      SAVRH                                        RVSD
     C                   MOVE      'Y'           DIFF2             1            DIFFERENT
     C                   MOVE      'Y'           NOVRFY                         NO VRFY MSG
     C                   END
     C     DSPLAY        TAG
      * SAVE ETA DATES BEFORE USER CHANGES THEM... BUT DO NOT SAVE WHEN
      * WE FIRST COME IN FROM THE HEADER SCREEN, OTHERWISE WE WOULD
      * OVERLAY THE SAVED VALUES (SAVXX) FROM THE HEADER SCREEN.. ALSO,
      * DO NOT OVERLAY THE SAVED VALUES IF ETA DATE ERRORS EXISTS...
      * ORIGINAL DATE
     C     FRMHD1        IFNE      'Y'                                          NOT FROM HDR
     C     ETAER1        ANDNE     'Y'                                          NO ETA ERROR
     C                   Z-ADD     ETAOH         SAVOH                          SAVE ETA
     C                   Z-ADD     POCC03        SVCC03                         SAVE ORIG CEN
     C                   ELSE
     C                   MOVE      ' '           FRMHD1            1            NOT FROM HDR
     C                   MOVE      ' '           ETAER1            1            NO MORE ERR
     C                   END
      * REVISED DATE
     C     FRMHD2        IFNE      'Y'                                          NOT FROM HDR
     C     ETAER2        ANDNE     'Y'                                          NO ETA ERROR
     C                   Z-ADD     ETARH         SAVRH                          SAVE ETA
     C                   Z-ADD     POCC14        SVCC14                         SAVE RVSD CEN
     C                   ELSE
     C                   MOVE      ' '           FRMHD2            1            NOT FROM HDR
     C                   MOVE      ' '           ETAER2            1            NO MORE ERR
     C                   END
      * RESET ALL LINE ITEM DATES DUE TO A CHANGE ON THE HEADER SCREEN
      * OF THE ETA DEFAULT CODE, SHIP TO BRANCH, OR HEADER DATE. BYPASS
      * THE INITIAL DISPLAY OF THE LINE ITEM SUBFILE...  THIS ALLOWS US
      * TO RESET ALL DATES FIRST, & THEN DISPLAY SUBFILE W/CHGD DATES..
     C     DIFF          CABEQ     'Y'           SKPSFL                         BYPASS SFL
     C     DIFF2         CABEQ     'Y'           SKPSFL                         BYPASS SFL
      *
     C     POCD01        IFEQ      'F'
     C                   MOVE      '1'           *IN65
     C                   END
   IRC*                  MOVEA     '1100'        *IN(75)                        DSPLY SUB & CNT
     C     ITMSIZ        IFEQ      400
     C     OVRLMT        IFEQ      'Y'                                          OVER LINE LIMIT
     C                   Z-ADD     400           RRN
     C                   MOVEL     UMS(13)       MSGFLD
     C                   ELSE
     C                   Z-ADD     1             RRN
     C                   ENDIF
IR   C     FINDE         TAG
IR   C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB & CNT
:A   C     PO_OpnCls     IFEQ      ' '
:A   C     PO_OpnCls     OREQ      'O'
:A   C     OpenLines     ANDEQ     0
     C                   WRITE     POF0120E                                     CMD KEY FORMAT
     C                   EXFMT     POC0120E                                     ENTRY CNTRL FRM
KW   C                   eval      ovhfnd = 'N'
KW   C                   eval      invfnd = 'N'
:A   C                   ENDIF
I0   C     INSFLG        IFEQ      'Y'
JW   C     ERRFLG        ANDEQ     ' '
I0   C                   CLEAR                   SEL
I0   C                   CLEAR                   MSGFLD
I0   C                   MOVE      'N'           INSFLG
I0   C                   CLEAR                   INSX
I0   C                   MOVE      *ZEROS        CURSER_RRN
I0 JWC*                  END
JW   C                   z-add     *zeros        insrrn            4 0
JW   C                   END
     C                   ELSE
IR   C     FINDN         TAG
IR   C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB & CNT
     C                   WRITE     POF0120N                                     CMD KEY FORMAT
     C                   EXFMT     POC0120N                                     ENTRY CNTRL FRM
     C                   END                                                    FOR DIRECT
I0   C                   CLEAR                   SEL
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVE      ' '           ERRFLG                         RESET FLAG
     C                   MOVE      'Y'           FSTERR
IR   C                   MOVE      *OFF          *IN02
      * ORIGINAL ETA INDICATORS
     C                   MOVE      '0'           *IN35                          RESET HDR RI
     C                   MOVE      '0'           *IN36                          RESET HDR RI
     C                   MOVE      *OFF          *IN31                          RESET HDR RI
      * REVISED ETA INDICATORS
     C                   MOVE      '0'           *IN37                          RESET HDR RI
     C                   MOVE      '0'           *IN38                          RESET HDR RI
     C                   MOVE      *OFF          *IN33                          RESET HDR RI
      *  RESET WINDOW IND
   ¢VC*                  MOVE      MODE          *IN28
     C                   MOVE      'N'           OVRLMT            1            OVER LINE LIMIT
KN   C                   MOVE      *OFF          *IN61
KR    *---------------------------------------------------------------------
KR    * Update: This is a rework of the product prompter. It loads the sfl as if
KR    * a user entered them and process as normal. If CLIPK2CDMV <> ' ' then that
KR    * is the rrn number of where the prompter button was clicked.  We are going
KR    * to update that line with what's in the file.  All other items will be
KR    * added to the bottom.
KR   C                   If        %subst(wsname:1:3) = 'QQF'
KR   C                   z-add     rrn           sd1rrn            4 0
KR   C                   z-add     0             ii                4 0
KR   C                   eval      SessioNmMv = 'JOB_' + %editc(jobnum:'X')
KR   C                   eval      EnttypCdMv  = 'PRODUCT_PROMPTER_MULTI_ROWS'
KR   C                   eval      Clipk1CdMv = *blanks
KR   C                   eval      Clipk2CdMv = *blanks
KR   C                   eval      Clipk3CdMv = *blanks
KR   C                   eval      Clipk4CdMv = *blanks
KR   C                   eval      Clipk5CdMv = *blanks
KR    *
KR   C     KeyClip2      setll     SHLCLIP1
KR   C                   If        %equal(SHLCLIP1)
KR    *
KR    * Write items into the subfile at the next available line or at the
KR    * prompted line.
KR    *
KR   C                   dou       %eof(shlclip1)
KR   C     KeyClip2      reade     SHLCLIP1
KR   C                   if        %eof(shlclip1)
KR   C                   iter
KR   C                   endif
KR    *
KR   C                   if        CLIPK2CDMV <> *blanks
KR KVC*                  eval      rrn = %dec(%trimr(CLIPK2CDMV): 4: 0)
KV   C                   eval      rrn = crrn
KR
KR   C                   If        rrn = botrrn
KR   C                   eval      botrrn += 1
KR   C                   endif
KR   C                   else
KR   C                   eval      rrn = botrrn
KR   C                   eval      botrrn += 1
KR   C                   endif
KR
KR   C                   If        itmSiz = 400
KR   C     rrn           chain     pos0120e
KR   C                   else
KR   C     rrn           chain     pos0120n
KR   C                   endif
KR    *
KR    * Update/Write SFL
KR    *
KR   C                   eval      qty = %int(%subst(clipbdtxmv: 1: 7))
KR   C                   eval      uom = %subst(clipbdtxmv: 8: 3)
KR   C                   eval      zzno04 = %subst(clipbdtxmv: 11: 30)
KR   C                   eval      *in32  = *on
KR   C                   delete    shfclip
KR
KR   C                   if        %found
KR   C                   if        itmSiz = 400
KR   C                   update    pos0120e
KR   C                   else
KR   C                   update    pos0120n
KR   C                   endif
KR
KR   C                   else
KR
KR   C                   if        itmSiz = 400
:A   C                   if        SFORLN > 0
:A   C                   eval      POLine = %editc(SFORLN:'X')
:A   C                   else
:A   C                   eval      PoLine = *blanks
:A   C                   endif
KR   C                   write     pos0120e
KR   C                   else
KR   C                   write     pos0120n
KR   C                   endif
KR   C                   endif
KR   C                   enddo
KR    *
KR    * Reset RRN to whatever it was before
KR    *
KR   C                   z-add     sd1rrn        rrn
KR   C                   endif
KR   C                   endif
KR    *---------------------------------------------------------------------
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           DSPLAY
     C                   END
      * PROCESS F4
      *
     C     *IN04         IFEQ      *ON
     C                   EXSR      @PRMPT
     C     *IN04         CABEQ     *ON           DSPLAY
     C                   ENDIF
KO    *
KO    * Command key to load manufacturer number from item master
KO    *
KO   C                   If        *In09 = *On
KO   C                   Exsr      @Load_Mfg
KO   C                   Goto      DSPLAY
KO   C                   Endif
     C                   EXSR      @CLCSR
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           LINEND                         CMD 03 RETURN
     C                   END
     C     *IN03         IFEQ      '1'
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C                   MOVE      *ON           *IN56
     C                   MOVEL     UMS(39)       MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPLAY
     C                   END
     C                   MOVEA     '0'           *IN(56)
      *
      * CMD 12 PREVIOUS
     C     *IN12         IFEQ      '1'
     C                   MOVE      'Y'           CMD12             1
      * IF WE ARE GOING BACK TO THE HEADER SCREEN, OVERLAY THE HEADER
      * ETA DATES W/THE SAVED ETA DATES.. BASICALLY, IF A USER CHANGES
      * THE HEADER ETA, AND THEN PRESSES F12 (W/O PRESSING ENTER FIRST)
      * THEY WILL LOSE THEIR CHANGES HERE... THIS MUST BE DONE TO KEEP
      * THE CURRENT SAVED ETA DATES, SINCE THE FIRST THING THAT HAPPENS
      * IN THE HEADER SUBROUTINE IS TO OVERLAY THE SAVED DATES WITH THE
      * ETA DATES.. OTHERWISE, WE WILL LOSE OUR 'GOOD' SAVED ETA DATES,
      * CAUSING THE (LINE ITEM -VS- SAVED DATE) COMPARISONS TO FAIL...
     C                   Z-ADD     SAVOH         ETAOH                          REPLACE ORIG
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETAOH         PDATE6                         ORIG ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACEN        POCC03
     C                   Z-ADD     SAVRH         ETARH                          REPLACE RVSD
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETARH         PDATE6                         REVS ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACEN        POCC14
     C     *IN12         CABEQ     '1'           LINEND                         CMD 12-PREVIOUS
     C                   END
     C                   MOVE      ' '           CMD12             1
      *
      * CMD 14 EXTENDED DESCRIPTION ?
     C     *IN14         IFEQ      '1'                                          CMD 14 EXT DESC
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C     *IN57         IFEQ      '1'                                          57 ON EXT DESC
     C                   MOVE      '0'           *IN(57)
     C                   ELSE
     C                   MOVE      '1'           *IN(57)
     C                   END
     C                   END
     C                   MOVEA     '0'           *IN(85)                        REVERSE IMAGE
     C                   MOVE      ' '           SVCD36                         EXTENDED DESC ?
      * ERROR CHECK ORIGINAL ETA DATE...
     C     POCD01        IFNE      'F'
     C                   Z-ADD     ETAOH         PDATE
     C                   Z-ADD     *ZEROS        PJULI
     C                   CALL      'GPR0100'     EDTDAT
     C     PJULI         IFEQ      0
     C                   MOVE      '1'           *IN35                          INVALID DATE
     C                   MOVE      '0'           *IN55                          NO VERFY MSG
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(26)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   MOVE      'Y'           ETAER1                         ETA ERROR
      *
     C                   ELSE
      * NOW THAT WE HAVE A GOOD DATE, MAKE SURE DATE IS NOT LESS THAN
      * THE CURRENT DATE, BUT ONLY IF DATE HAS BEEN CHANGED...
     C     ETAOH         IFNE      SAVOH
     C                   MOVE      'D'           ZZFUNC
     C                   Z-ADD     ETAOH         ZZDATE                         HEADER ETA
     C                   Z-ADD     UDATE         ZZDIFF                         CURRENT DATE
     C                   CALL      'UDR'         UDRPRM
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETAOH         PDATE6                         ORIG ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACYR        POCYR3                         CEN/YEAR
     C     ZZDAYS        IFLT      0                                            LT UDATE "CURRENT YR
     C     POCYR3        ORLT      *YEAR                                        OLDER THAN 1 YEAR ?
     C                   MOVE      '1'           *IN36
     C                   MOVE      '0'           *IN55                          NO VERFY MSG
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(27)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   MOVE      'Y'           ETAER1                         ETA ERROR
     C                   MOVE      SAVOH         ETAOH                          RESTORE ORIG
     C                   MOVE      SVCC03        POCC03                         RESTORE ORIG
     C                   END
     C                   END
     C                   END
      *
      * ERROR CHECK REVISED ETA DATE...
     C                   Z-ADD     ETARH         PDATE
     C                   Z-ADD     *ZEROS        PJULI
     C                   CALL      'GPR0100'     EDTDAT
     C     PJULI         IFEQ      0
     C                   MOVE      '1'           *IN37                          INVALID DATE
     C                   MOVE      '0'           *IN55                          NO VERFY MSG
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(29)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   MOVE      'Y'           ETAER2                         ETA ERROR
      *
     C                   ELSE
      * NOW THAT WE HAVE A GOOD DATE, MAKE SURE DATE IS NOT LESS THAN
      * THE CURRENT DATE, BUT ONLY IF DATE HAS BEEN CHANGED...
     C     ETARH         IFNE      SAVRH
     C                   MOVE      'D'           ZZFUNC
     C                   Z-ADD     ETARH         ZZDATE                         HEADER ETA
     C                   Z-ADD     UDATE         ZZDIFF                         CURRENT DATE
     C                   CALL      'UDR'         UDRPRM
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETARH         PDATE6                         REPLACE RSVD
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACYR        PCYR14                         REVISED ETA CENTURY
     C     ZZDAYS        IFLT      0                                            LT UDATE "CURRENT YR
     C     PCYR14        ORLT      *YEAR                                        OLDER THAN 1 YEAR ?
     C                   MOVE      '1'           *IN38
     C                   MOVE      '0'           *IN55                          NO VERFY MSG
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(30)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   MOVE      'Y'           ETAER2                         ETA ERROR
     C                   MOVE      SAVRH         ETARH                          RESTORE ORIG
     C                   MOVE      SVCC14        POCC14                         RESTORE ORIG
     C                   END
     C                   END
     C                   END
      *
     C                   END
     C                   MOVE      POMO02        ORDMO
     C                   MOVE      PODY02        ORDDY
     C                   MOVE      POCC02        ORDCC
     C                   MOVE      POYR02        ORDYR
     C                   MOVE      POMO03        ETAMO
     C                   MOVE      PODY03        ETADY
     C                   MOVE      POYR03        ETAYR
      *
     C     ETAOH         IFNE      *ZERO
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   Z-ADD     ETAOH         PDATE6
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   Z-ADD     PDACEN        POCC03                         ETA CENTURY
     C                   ELSE
     C                   Z-ADD     *ZERO         POCC03
     C                   ENDIF
     C                   MOVE      POCC03        ETACC
      *
     C     ORCYMD        IFGT      ETCYMD                                       ORD DATE GT ETA
     C     POCD01        ANDNE     'F'                                          NOT BLANKET
     C                   MOVE      *ON           *IN31                          ERROR MESSAGE
     C                   MOVE      *OFF          *IN55                          NO VERFY MSG
     C                   MOVE      'Y'           ETAER1                         ETA ERROR
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(41)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   MOVE      SAVOH         ETAOH                          ERROR OCCURED
     C                   MOVE      SVCC03        POCC03                         ERROR OCCURED
     C                   ENDIF
      *
     C                   MOVE      POMO14        ETARMO
     C                   MOVE      PODY14        ETARDY
     C                   MOVE      POYR14        ETARYR
     C                   Z-ADD     5             PDATYP                         DATE TYPE
     C                   MOVE      ETRYMD        PDATE6                         ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDATE8        TRCYMD                         ETA DATE
     C     ORCYMD        IFGT      TRCYMD                                       ORD DATE GT ETA
     C     POCD01        ANDNE     'F'                                          NOT BLANKET
     C     *IN31         ANDEQ     *OFF                                         ORD DATE GT ETA
     C                   MOVE      *ON           *IN33                          ERROR MESSAGE
     C                   MOVE      'Y'           ETAER2                         ETA ERROR
     C                   MOVE      SAVRH         ETARH                          RESTORE ORIG
     C                   MOVE      SVCC14        POCC14                         ERROR OCCURED
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(42)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
IR    * "POSITION TO" PRODUCT DESIRED ?
IR   C     *IN16         IFEQ      *ON
KE   C     FIND04        IFNE      *BLANKS
KE   C     FINDLN        ANDNE     0
KE   C                   Eval      MSGFLD = 'Only 1 Pos To can be used to find.'
KE   C                   MOVE      *ON           *IN02
KE   C                   MOVE      'Y'           ERRFLG
KE   C                   ELSE
IR   C     FIND04        IFNE      *BLANKS
KE   C     FINDLN        ORNE      0
IR   C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
KE    * Search by Product Number ?
KE   C     FIND04        IFNE      *BLANKS
IR   C     FINDKY        CHAIN     POFWPOL                            40
IR   C     *IN40         IFEQ      *OFF
IR    * Remove the DSPATR(PC) value from the first input capable line...
IR    * This will allow the DSPRRN on the SFLRCDNBR keyword to work...
IR   C                   If        NextLineRRN > 0
IR   C                   If        ItmSiz = 400
IR   C     NextLineRRN   Chain     POS0120E
IR   C                   if        %found(POD0120)
IR   C                   If        Qty = 0 and ZZNO04 = ' ' and ZZDN01 = ' '
IR   C                   eval      *in80 = *off
¢8   C                   eval      *in28 = *off
IR   C                   update    POS0120E
IR   C                   Endif
IR   C                   Endif
IR   C                   Else
IR   C     NextLineRRN   Chain     POS0120N
IR   C                   if        %found(POD0120)
IR   C                   If        Qty = 0 and ZZNO04 = ' ' and ZZDN01 = ' '
IR   C                   eval      *in80 = *off
¢8   C                   eval      *in28 = *off
IR   C                   update    POS0120N
IR   C                   Endif
IR   C                   Endif
IR   C                   Endif
IR   C                   Endif
IR    *
IR   C                   Z-ADD     POSFRN        DSPRRN
IR   C     ITMSIZ        IFEQ      400
IR   C                   GOTO      FINDE
IR   C                   ELSE
IR   C                   GOTO      FINDN
IR   C                   ENDIF
IR   C                   ELSE
IR   C                   MOVEL     UMS(18)       MSGFLD
IR   C                   MOVE      *ON           *IN02                          ERROR MESSAGE
IR   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
IR   C                   ENDIF
KE   C                   ENDIF
KE    * Search by Line Number ?
KE   C     FINDLN        IFNE      0
KE   C     FINDKY2       CHAIN     POFWPOLL                           40
KE   C     *IN40         IFEQ      *OFF
KE    * Remove the DSPATR(PC) value from the first input capable line...
KE    * This will allow the DSPRRN on the SFLRCDNBR keyword to work...
KE   C                   If        NextLineRRN > 0
KE   C                   If        ItmSiz = 400
KE   C     NextLineRRN   Chain     POS0120E
KE   C                   if        %found(POD0120)
KE   C                   If        Qty = 0 and ZZNO04 = ' ' and ZZDN01 = ' '
KE   C                   eval      *in80 = *off
¢8   C                   eval      *in28 = *off
KE   C                   update    POS0120E
KE   C                   Endif
KE   C                   Endif
KE   C                   Else
KE   C     NextLineRRN   Chain     POS0120N
KE   C                   if        %found(POD0120)
KE   C                   If        Qty = 0 and ZZNO04 = ' ' and ZZDN01 = ' '
KE   C                   eval      *in80 = *off
¢8   C                   eval      *in28 = *off
KE   C                   update    POS0120N
KE   C                   Endif
KE   C                   Endif
KE   C                   Endif
KE   C                   Endif
KE    *
KE   C                   Z-ADD     POSFRN        DSPRRN
KE   C     ITMSIZ        IFEQ      400
KE   C                   GOTO      FINDE
KE   C                   ELSE
KE   C                   GOTO      FINDN
KE   C                   ENDIF
KE   C                   ELSE
KE   C                   MOVEL     UMS(18)       MSGFLD
KE   C                   MOVE      *ON           *IN02                          ERROR MESSAGE
KE   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
KE   C                   ENDIF
KE   C                   ENDIF
IR   C                   ELSE
IR   C                   Eval      MSGFLD = 'Pos To cannot be blank for find.'
IR   C                   MOVE      *ON           *IN02
IR   C                   MOVE      'Y'           ERRFLG
IR   C                   ENDIF
KE   C                   ENDIF
IR   C                   ENDIF
I0    * Cannot insert comments if receiver found
I0   C     RCVFND        IFEQ      'Y'
I0   C     SEL           IFGE      '1'
I0   C     SEL           ANDLE     '9'
I0   C                   MOVE      'Y'           ERRFLG
I0 JNC*                  MOVEL     CMS(2)        MSGFLD
JN   C                   MOVEL     EMS(65)       MSGFLD
I0   C                   ENDIF
I0   C                   ENDIF
I0    * Cannot insert comments if LOT PO.
I0   C     POCD42        IFEQ      'Y'
I0   C     SEL           IFGE      '1'
I0   C     SEL           ANDLE     '9'
I0   C                   MOVE      'Y'           ERRFLG
I0 JNC*                  MOVEL     CMS(3)        MSGFLD
JN   C                   MOVEL     EMS(66)       MSGFLD
I0   C                   ENDIF
I0   C                   ENDIF
I0    * Cannot insert comments if EDI Processing has occurred...
I0   C                   If        EDI = 'Y'
I0   C     SEL           IFGE      '1'
I0   C     SEL           ANDLE     '9'
I0   C                   Call      'EIR9507'
I0   C                   Parm                    PONO01
I0   C                   Parm                    AllowInsert       1
I0   C                   If        AllowInsert <> 'Y'
I0   C                   MOVE      'Y'           ERRFLG
I0 JNC*                  MOVEL     CMS(4)        MSGFLD
JN   C                   MOVEL     EMS(67)       MSGFLD
I0   C                   endif
I0   C                   ENDIF
I0   C                   endif
     C     ERRFLG        CABEQ     'Y'           DSPLAY                         DSPLY ERROR
      *
     C     SKPSFL        TAG
      * MOVES SUBFILE TO DATA STRUCTURE
     C                   EXSR      SQUASH                                       MOVE S/F TO D/S
I0   C     ERRFLG        CABEQ     'Y'           DSPLAY                         DSPLY ERROR
      *
      * INITIALIZE SUBFILE
     C                   MOVEA     '1'           *IN(70)                        INITIALIZE
     C     ITMSIZ        IFEQ      400
     C                   WRITE     POC0120E                                     ENTRY SUBFILE
     C                   ELSE
     C                   WRITE     POC0120N                                     ENTRY SUBFILFRM
     C                   END
     C                   MOVEA     '0'           *IN(70)                        SETOF INITIALIZ
     C                   CLEAR                   ONELOT
¢S   C                   CLEAR                   FITM
      *
IR    * CLEAR PRODUCT SEARCH WORKFILE...
IR   C     PONO01        SETLL     POFWPOL
IR   C     *IN49         DOUEQ     *ON
IR   C     PONO01        DELETE    POFWPOL                            49
IR   C                   ENDDO
KE    *
KE   C     PONO01        SETLL     POFWPOLL
KE   C     *IN49         DOUEQ     *ON
KE   C     PONO01        DELETE    POFWPOLL                           49
KE   C                   ENDDO
      * MOVE DATA STRUCTURE TO SUBFILE & EDIT DATA
     C     X             IFEQ      0                                            ANY RCDS ?
     C                   MOVEL     UMS(17)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
      *
     C                   Z-ADD     X             SRRN              3 0          SAVE LAST ITEM
     C                   Z-ADD     1             RRN                            S/F INDEX
     C                   Z-ADD     1             X                              D/S INDEX
     C     SRRN          ADD       1             SVRRN             3 0          NEXT AVAILIBALE
      * CLEAR NONSTOCK ARRAY...
     C                   CLEAR                   NSC
      *
     C     X             DOUGT     SVRRN
     C     X             CABGT     ITMSIZ        SKIP2
     C     X             OCCUR     SAVDS
     C                   MOVE      '1'           *IN32                          SFLNXTCHG
     C                   MOVE      SAVDS         SFDS
     C                   MOVEL     PROD          ZZNO04
     C                   MOVEL     PROD          SVNO04
     C                   MOVEL     ZZNO04        PRT                            SAVE ZZNO04
     C                   MOVEL     DESC          ZZDN01
I0   C     I1            IFEQ      '*'
I0 J5C*                  CLEAR                   NS
JW    * if insertion position cusor
JW   C                   if        insflg = 'Y'
JW   C                             and msgfld = ' '
JW   C                             and x = insrrn
JW   C     insrrn        sub       1             dsprrn
JW   C                   endif
I0   C                   END
      *
     C     POCD01        IFEQ      'F'
     C                   MOVE      *ZEROS        ETASO
     C                   MOVE      *ZEROS        POCC13                         ETA ORIG LINE CEN
     C                   MOVE      *ZEROS        ETASR
     C                   MOVE      *ZEROS        POCC15                         ETA RVSD LINE CEN
     C                   MOVE      '1'           *IN65
     C                   END
      *
      * IF ITEM ON OPEN ASN IN WM SYSTEM, PROTECT PROD#.
      * CANNOT DELETE ITEM.
     C                   MOVE      *OFF          *IN54
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     ONASNF        IFEQ      'Y'
     C     ONASNF        OREQ      '0'
     C                   MOVE      *ON           *IN54
     C                   END
     C                   END
      *
      * POSITION CURSOR AT NEXT AVAILIABLE LINE
     C     X             IFGT      SRRN
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
JW    * if no insertions
JW   C                   if        insrrn = *zeros
     C                   Z-ADD     SRRN          DSPRRN
JW   C                   else
JW   C     insrrn        sub       1             dsprrn
JW   C                   endif
IR    * Save the next available line RRN in case F16 is used later...
IR   C                   Z-add     X             NextLineRRN       4 0
     C                   MOVEA     '1'           *IN(80)                        POSITION CURSOR
     C                   MOVE      '0'           *IN32                          NO SFLNXTCHG
¢8    * Check to see if this is an original line
¢8    * If so, then the item needs to be protected if po sent to vendor
¢8   C                   MOVE      *OFF          *IN28
#5 :AC*                  IF        ediSolution <> 'SPS'
¢8 :AC*                  IF        SFORGPROD <> *BLANKS
¢8 :AC*                  IF        SentToVendor = 'Y'
:A   C                   IF        SFORGPROD <> *BLANKS and
:A   C                             SentToVendor = 'Y'
¢8   C                   MOVE      *ON           *IN28
:A   C                   ENDIF
¢8 :AC*                  ENDIF
#5 :AC*                  ENDIF
     C     ITMSIZ        IFEQ      400
:A   C                   IF        SFORLN > 0
:A   C                   EVAL      POLine = %editc(SFORLN:'X')
:A   C                   ELSE
:A   C                   EVAL      PoLine = *blanks
:A   C                   ENDIF
     C                   WRITE     POS0120E
     C                   ELSE
     C                   WRITE     POS0120N
     C                   END                                                    FOR DIRECT
     C                   MOVEA     '0'           *IN(80)                        POSITION CURSOR
¢8   C                   MOVE      *OFF          *IN28
     C                   END
     C     X             CABGT     SRRN          ENDLIN
     C                   END
      *
     C                   MOVEA     '0'           *IN(51)                        SETOF IND 51
      *------------------------------------------------------------------------*
      * TYPE OF LINE ITEM
      * TEST LAST 6 POS. OF ITEM NUMBER FOR BLANKS.
      *------------------------------------------------------------------------*
     C     LAST6A        IFEQ      *BLANKS
     C                   MOVEL     ITM1          TESTN7            7            TEST FLD
     C                   MOVE      '0'           TESTN7                         TEST FLD
     C                   TESTN                   TESTN7               51        51 = OUR ITEM
     C                   END
      *
     C     TYP           IFNE      'D'                                          NOT LOT DETAIL
I0   C                   Exsr      ChkInsert
     C     I1            IFEQ      '*'                                          1ST DIGIT ITEM
     C     IVNO7         IFNE      *ZEROS                                       SAME ITEM ?
     C     NSITMX        ORNE      *BLANKS                                      SAME ITEM ?
     C                   CLEAR                   SFORLN
     C                   ENDIF
     C                   MOVE      'C'           TYP                            COMMENTS TYPE
     C                   Z-ADD     0             KEY                            TAG & HOLD KEY
     C                   Z-ADD     0             IVNO7                          ITEM NUMBER
     C                   Z-ADD     0             IVNO07                         ITEM NUMBER
     C                   Z-ADD     0             LIST                           UNIT LIST
     C                   MOVE      *BLANKS       DISC                           DISCOUNT
     C                   MOVE      ' '           DOVR                           DISC OVRRIDE
     C                   MOVE      ' '           COST                           UNIT COST
     C                   MOVE      ' '           COVR                           COST OVRRIDE
     C                   MOVE      '   '         PUOM                           PRICING UOM
I0   C                   If        InsertError <> 'Y'
     C                   MOVE      ' '           SEL                            SELECT
I0   C                   Endif
     C                   Z-ADD     0             QTY                            QTY ORDERED
#4   C                   Z-ADD     0             QTYO
     C                   MOVE      '   '         UOM                            ORDERED UOM
     C                   MOVE      ' '           BLKTAG                         BLINK TAG&HOLD
     C                   MOVE      *BLANKS       MAN                            MANUFACTURER
#4   C                   MOVE      *BLANKS       VENQ
     C                   MOVEA     '1'           *IN(22)                        PRTCT ETA'S
     C     I2            CABEQ     '*V'          SKIP1                          COMMENTS
     C     I2            CABEQ     '* '          SKIP1                           COMMENTS
     C                   END
     C     I1            IFEQ      '/'
     C                   EXSR      NONSTK                                       NON STOCK
     C                   ELSE
     C     ZZNO04        IFEQ      *BLANKS
     C     QTYR          IFGT      0
     C                   Z-ADD     0             QTYR
     C                   ENDIF
     C                   EXSR      NONSTK                                       NON-STOCK
     C                   ELSE
     C     *IN51         IFEQ      '1'                                          NUMERIC
     C                   MOVE      'O'           TYP
     C                   EXSR      CHKITM                                       OUR ITEM #
     C                   ELSE
     C     ZZNO04        IFNE      *BLANKS
     C                   MOVE      'P'           TYP
     C                   EXSR      CHKITM                                       PRODUCT #
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     *IN03         IFEQ      '1'                                          CMD 03 FROM
     C     POCD01        IFEQ      'D'
     C                   EXSR      RMVLCK
     C                   ENDIF
     C                   Z-ADD     0             PONO01                          TAG & HOLD
     C     *IN03         CABEQ     '1'           PRMPT
     C                   END
      *
     C                   MOVE      ' '           BLKTAG                         INITIALIZE
     C     KEY           IFNE      0                                            TAG & HOLD ?
     C                   MOVE      'T'           BLKTAG                         BLINK TAG & HOL
     C                   END
      *
      *   ERROR CHECK-PO DIRECT MUST HAVE TAG ITEMS
     C     POCD01        IFEQ      'D'
     C     BLKTAG        IFEQ      ' '
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C     TAGWRN        IFNE      'W'                                          TAG WARNING
     C                   MOVE      '1'           TAGWRN            1            TAG WARNING
     C                   END
     C                   END
     C                   ELSE
     C                   Z-ADD     1             Z
     C     KEY           IFNE      0
     C     *IN40         DOUEQ     '0'
     C     Z             IFLE      MAXKY
     C     KEY           LOOKUP    KY(Z)                                  40
     C                   ELSE
     C                   MOVE      '0'           *IN40
     C                   END
     C     *IN40         IFEQ      '1'
     C                   MOVEA     TH(Z)         TAGH
   HIC*    TREF          IFEQ      0
HI   C     TREF          IFEQ      *ZEROS
HI   C     TREF          OREQ      *BLANKS
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C     TAGWRN        IFNE      'W'                                          TAG WARNING
     C                   MOVE      '1'           TAGWRN                         TAG WARNING
     C                   END
     C                   END
     C                   END
     C                   ADD       1             Z
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     SKIP1         TAG
      * UPDATE ORIGINAL VALUES W/NEW VALUES FOR NEXT COMPARE...
      * ONLY UPDATE ORIGINAL UOM VALUE IF NEW UOM IS VALID...
     C     *IN01         IFEQ      *OFF
     C                   MOVE      UOM           OUOM
     C                   ENDIF
     C                   Z-ADD     UQYSF         UQYSFO
     C                   MOVEL     ZZNO04        PROD                           PRODUCT#
     C                   MOVEL     ZZNO04        PRT                            SAVE ZZNO04
     C                   Z-ADD     IVNO07        IVNO7                          OUR ITEM #
     C                   MOVE      NSITM         NSITMX                         NS ITEM #
     C                   MOVE      SEC           SECX                           NS SEC #
     C                   ELSE
     C                   MOVEL     ZZNO04        PRT                            SAVE ZZNO04
     C                   CLEAR                   SEL                            SELECT
     C                   MOVE      *ON           *IN21                          PROTECT ETA
     C                   MOVE      *ON           *IN22                          PROTECT ETA
     C                   ENDIF
KN    *
KN    * Error if MANUFEQ = 'Y' and Vendor is an EDI Vendor
KN   C                   EVAL      *IN61 = *OFF
KN   C                   IF        TYP <> 'C'
KN   C                   IF        EDIPOMF = 'Y' AND MAN = *BLANKS
KN   C                              OR MANUFREQ = 'A' AND MAN = *BLANKS
KN   C                   EVAL      *IN61 = *ON
KN   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
KN   C                   IF        MSGFLD = *BLANKS
KN   C                   EVAL      *IN28 = *OFF                                 fold screen
KN   C                   IF        EDIPOMF = 'Y'
KN   C                   EVAL      MSGFLD = 'Manufacturer number required for a-
KN   C                             n EDI vendor.'
KN   C                   ELSE
KN   C                   EVAL      MSGFLD = 'Manufacturer number required for a-
KN   C                             ll vendors.'
KN   C                   ENDIF
KN   C                   ENDIF
KN   C                   ENDIF
KN   C                   ENDIF
      *
      * UPDATE DATA STRUCTURE, SO IF F12 IS PRESSED, DATA IS PRESERVED.
     C                   MOVE      SFDS          SAVDS
      * DO NOT DISPLAY UOM FACTOR DATA IF PURCHASE UOM FACTOR = 1...
     C     UOMSF         IFEQ      1
     C                   MOVE      *ON           *IN26
     C                   ENDIF
     C     ERRFLG        IFEQ      'Y'
     C     FSTERR        ANDEQ     'Y'
     C                   Z-ADD     X             DSPRRN
     C                   MOVE      'N'           FSTERR            1
     C                   ENDIF
     C     QTYR          IFNE      0                                            QTY RECEIVED
     C                   MOVEA     '1'           *IN(84)                        PROTECT ITEM #
     C                   END
     C     *IN91         IFEQ      *ON
   HLC*                  MOVE      *ON           SAV91             1
     C                   MOVE      *OFF          *IN84
     C                   MOVE      *OFF          *IN21
     C                   ENDIF
      *
      * IF ITEM ON OPEN ASN IN WM SYSTEM, PROTECT PROD#.
      * CANNOT DELETE ITEM.
     C                   MOVE      *OFF          *IN54
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     ONASNF        IFEQ      'Y'
     C     ONASNF        OREQ      '0'
     C                   MOVE      *ON           *IN54
     C                   END
     C                   END
I0   C     CURSER_RRN    IFEQ      RRN
I0   C     CURSER_RRN    ANDNE     *ZEROS
JW   C     MSGFLD        ANDEQ     ' '
I0 JNC*                  MOVE      CMS(1)        MSGFLD
JN   C                   MOVE      EMS(64)       MSGFLD
I0   C                   ELSE
I0   C                   MOVE      *OFF          *IN82
I0   C                   END
I0    *
I0    * Blank out the Select field for line insertion...
I0    * If there are previous Subfile errors, then the insertion logic will occur again
I0    * because this value is not being blanked out. The insert lines get written after this
I0    * line is tested. this logic makes sure leftover Insert values are not leftover.
I0    * However, if insertion error exists, then DO NOT blank out the Select field.
I0   C                   If        Sel >= '1' and Sel <= '9'
I0   C                   If        InsertError <> 'Y'
I0   C                   Eval      Sel = ' '
I0   C                   else
I0   C                   Eval      InsertError = ' '
I0   C                   Endif
I0   C                   Endif
      *
¢8    * Check to see if this is an original line
¢8    * If so, then the item needs to be protected if po sent to vendor
¢8   C                   MOVE      *OFF          *IN28
#5 :AC*                  IF        ediSolution <> 'SPS'
¢8 :AC*                  IF        SFORGPROD <> *BLANKS
¢8 :AC*                  IF        SentToVendor = 'Y'
:A   C                   IF        SFORGPROD <> *BLANKS and
:A   C                             SentToVendor = 'Y'
¢8   C                   MOVE      *ON           *IN28
¢8   C                   ENDIF
¢8 :AC*                  ENDIF
#5 :AC*                  ENDIF
     C     ITMSIZ        IFEQ      400
:A   C                   IF        SFORLN > 0
:A   C                   EVAL      POLine = %editc(SFORLN:'X')
:A   C                   ELSE
:A   C                   EVAL      PoLine = *blanks
:A   C                   ENDIF
     C                   WRITE     POS0120E
     C                   ELSE
     C                   WRITE     POS0120N
     C                   END
¢8   C                   MOVE      *OFF          *IN28
IR    * LOAD PRODUCT SEARCH WORKFILE...
IR   C                   Z-ADD     RRN           POSFRN
IR   C                   MOVEL     ZZNO04        SFDITM
KE   C                   eval      sfdline = sforln
IR   C                   WRITE     POFWPOL
KE   C                   WRITE     POFWPOLL
IR    *
     C                   MOVEA     '00000'       *IN(80)                        ERRORS
     C                   MOVE      *OFF          *IN26                          SHOW UOM DATA
     C                   MOVE      *OFF          *IN01                          HIGHLITE ERROR
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN91
      * RESET ETA RELATED INDICATORS...
     C                   MOVE      *OFF          *IN21                          LOT DETAIL PROTECT
     C                   MOVEA     '0'           *IN(22)                        UN PROTECT
JT   C                   MOVEA     '0'           *IN(23)                        Reset Insert Error
     C                   MOVEA     '0'           *IN(89)                        RESET RI/PC
     C                   MOVEA     '0'           *IN(99)                        RESET RI/PC
     C                   MOVE      ' '           BLKTAG                         BLINK TAG & HOL
     C                   MOVE      ' '           DOVR                           DISC OVRRIDE
     C                   MOVE      ' '           COVR                           COST OVRRIDE
      * RESET UOM FIELDS...
     C                   CLEAR                   UOMSF
     C                   CLEAR                   UQYSF
      *
      * EXTENDED DESCRIPTION ?
     C     *IN57         IFEQ      '1'                                          EXTENDED DESC
     C     IVNO07        IFNE      0                                            STOCKED ITEM ?
     C     IVCD36        IFEQ      'Y'                                          EXT DESC EXIST
     C                   MOVE      'E'           WHERE1            1            ENTRY S/F
     C                   EXSR      EXTDSC
     C                   MOVE      ' '           WHERE1                         ENTRY S/F
     C                   END
     C                   END
     C                   END
      *
      * GET LOT DETAIL IF USER ENTERED LOT NONSTOCK
      *
     C     POCD42        IFEQ      'Y'
     C     OECD72        ANDEQ     'Y'
     C     LOTFLG        ANDEQ     'Y'
     C     TYP           ANDEQ     'N'
     C                   EXSR      LOTDTL
     C                   CLEAR                   OECD72
     C                   ENDIF
      *
     C     ENDLIN        TAG
     C                   ADD       1             RRN                            S/F INDEX
     C                   ADD       1             X                              D/S INDEX
     C                   END
KV   C                   Z-ADD     RRN           BOTRRN
   HLC*    SAV91         IFEQ      *ON
   HLC*                  MOVE      SAV91         *IN91
   HLC*                  ENDIF
   HLC*                  MOVE      *OFF          SAV91
      *
     C     SKIP2         TAG
     C     SVCD36        IFEQ      'Y'                                          EXTENDED DESC ?
     C                   MOVEA     '1'           *IN(85)                        REVERSE IMAGE
     C                   END                                                    CMD 07-EXTEND
      *
      * RESET "ETA DATE DEFAULT" DIFFERENCE FLAG...
     C                   MOVE      ' '           DIFF                           RESET FLAG
     C                   MOVE      ' '           DIFF2                          RESET FLAG
      *
      * ERROR OCCURED ?
     C     ERRFLG        IFEQ      'Y'                                          ERROR
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C                   Z-ADD     0             CNTLIN                         # OF LINES
     C     ERRFLG        CABEQ     'Y'           DSPLAY                         DSPLY ERROR
     C                   END
      *
      * VERIFY MESSAGE
     C     CNTLIN        IFNE      SAVCNT                                       # OF LINES
      *
     C     TAGWRN        IFEQ      '1'                                          TAG WARNING
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C                   MOVE      'W'           TAGWRN                         WARN
     C     TAGWRN        IFEQ      'W'
     C                   MOVEL     UMS(40)       MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPLAY
     C                   ENDIF
     C                   END
     C                   Z-ADD     CNTLIN        SAVCNT            3 0          SAVE # OF LINES
     C                   MOVE      '0'           TAGWRN                         RESET
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C                   END
     C                   MOVE      *OFF          SHBCHG
      * IF NOVRFY IS = 'Y', THIS MEANS ALL WE HAVE DONE WAS LOADED ALL
      * SUBFILE DATES W/NEW VALUES FROM ANY HEADER CHANGES... SO DONT
      * SHOW THE VERIFY MESSAGE WHEN THE SUBFILE IS FIRST PRESENTED...
     C     NOVRFY        IFEQ      'Y'
     C                   MOVE      ' '           NOVRFY
     C     NOVRFY        CABEQ     ' '           DSPLAY                         DSPLY SFL
     C                   ELSE
     C     *IN55         IFEQ      *OFF
I0   C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     UMS(38)       MSGFLD
     C                   MOVE      *ON           *IN55
I0   C                   ENDIF
IU    *   Postitioning cursor to next line
IU   C     X             IFGT      SRRN
IU   C                   ADD       1             DSPRRN
IU   C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       DSPLAY
     C                   ENDIF
     C                   END
      *
     C     LINEND        TAG
     C                   MOVE      SVIN51        *IN51
     C                   MOVE      SVIN54        *IN54
     C                   MOVE      '0'           *IN65
     C                   MOVEA     '1'           *IN(77)                        DELETE S/F
     C                   WRITE     POC0120F
     C                   MOVEA     '0'           *IN(77)                        DELETE S/F
JL   C                   eval      *in28 = *on
KN   C                   MOVE      SVIN61        *IN61
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    SQUASH LINE ITEMS                                       *
      *------------------------------------------------------------------------*
     C     SQUASH        BEGSR
      * SAVE ALL INDICATOR SETTINGS (THEY ARE RESTORED AT THE BOTTOM OF
      * THE SUBROUTINE), INITIALIZE THE INDICATOR ARRAY.
      *
     C                   MOVEA     *IN           SQUIN            99            SAVE ALL IND'S
     C                   CLEAR                   *IN                            RESET ALL IND'S
      * MOVES SUBFILE DATA TO DATA STRUCTURE
     C                   MOVE      'Y'           FIRST             1
     C                   CLEAR                   CHGCMB
     C                   EXSR      BLKDS                                        BLANK/ZERO DS
     C                   Z-ADD     0             X                 3 0          INDEX
     C                   Z-ADD     0             CNTLIN            3 0          # OF LINE ITEMS
     C     *IN40         DOUEQ     '1'
     C     LOOP5         TAG
     C     FIRST         IFEQ      'Y'
     C                   MOVE      *BLANKS       FIRST
     C     ITMSIZ        IFEQ      400
     C     1             CHAIN     POS0120E                           40        ENTRY SUBFILE
     C                   ELSE
     C     1             CHAIN     POS0120N                           40        ENTRY DIR SFE
     C                   ENDIF
     C                   ELSE
     C     ITMSIZ        IFEQ      400
     C                   READC     POS0120E                               40    ENTRY SUBFILE
     C                   ELSE
     C                   READC     POS0120N                               40    ENTRY DIR SFE
     C                   END
     C                   ENDIF
     C     *IN40         IFEQ      '0'
      *
     C     TYP           IFNE      'D'                                          LOT DETAIL
     C                   CLEAR                   DLTCMP                         DELETE COMPONENT
     C     CHGCMB        CASEQ     'Y'           CHGCMP
     C                   ENDCS
     C                   ENDIF
      *
     C     TYP           IFEQ      'D'                                          LOT DETAIL
     C     DLTCMP        CABEQ     'Y'           LOOP5                    53    DELETE COMPONENT
     C     CHGCMB        IFEQ      'Y'
     C                   ADD       1             XY
     C     XY            OCCUR     LOTDS
     C                   MOVE      IVNO7         CIITM                          OUR ITEM #
     C                   MOVE      UOM           CIUOM                          UNITS OF MEASR
     C                   Z-ADD     QTY           CIQTY
     C                   Z-ADD     COST          CICST
     C                   MOVE      TYP           CITYP                          ITEM TYPE
     C                   MOVE      ZZDN01        CIPDDS                         DESCRITPION
     C                   MOVEL     ZZNO04        CIPDDS                         PRODUCT NUMBER
     C                   Z-ADD     CTRL          CIKLC#
     C     CHGCMB        CABEQ     'Y'           LOOP5                    53    CHANGE COMPONENT
     C                   ENDIF
     C                   ENDIF
      *
     C     ZZNO04        IFEQ      *BLANKS                                      ITEM NUMBER
     C     ZZNO04        ORNE      SVNO04                                       PROD CHANGED
KM   C                   CLEAR                   PSNME
KM   C                   CLEAR                   PSSTS
KM   C                   CLEAR                   PSTYPE
KM   C                   CLEAR                   PSCTNM
KM   C                   CLEAR                   PSOVR
¢U   C                   CLEAR                   MAN
     C                   MOVE      'Y'           DLTCMP            1
     C     POCD42        IFEQ      'Y'
     C     TYP           ANDEQ     'N'                                          LOT DETAIL
     C                   MOVE      'Y'           LOTFLG            1            LOT FLAG
     C                   ENDIF
KG    *
KG    * Clear manufacturer number field
KG   C                   CLEAR                   MAN
      *
      * BLANK OUT LOT PURCHASE ORDER FLAG IF PRODUCT NUMBER REMOVED
     C     ZZNO04        IFEQ      *BLANKS                                      ITEM NUMBER
     C     QTY           ANDEQ     *ZERO
     C                   CLEAR                   POCD42
     C                   ENDIF
      * REMOVE TAGS...
     C                   Z-ADD     1             K                 3 0
     C     KEY           IFNE      *ZEROS
     C     *IN43         DOUEQ     '0'
     C     K             IFLE      MAXKY
     C     KEY           LOOKUP    KY(K)                                  43
     C                   ELSE
     C                   MOVE      '0'           *IN43
     C                   ENDIF
     C     *IN43         IFEQ      '1'
      *
      * DELETE WORK FILE ENTRIES
      *
     C                   MOVEA     TH(K)         TAGH
     C     TTORG         IFNE      *ZEROS
HI   C     TTORG         ANDNE     *BLANKS
     C     ORDTYP        IFEQ      'SO'                                         S/O TAG
     C                   MOVEL     'S'           POCD45
     C     WRKKEY        DELETE    POFWTAG                            47
     C                   ELSE
     C                   MOVE      'T'           POCD45
     C     WRKKEY        DELETE    POFWTAG                            47
     C                   ENDIF
     C                   ENDIF
      *
     C                   CLEAR                   OS(K)
     C                   CLEAR                   PL(K)
     C                   CLEAR                   KY(K)
     C                   CLEAR                   TH(K)
     C                   ADD       1             K
     C                   ENDIF
     C                   ENDDO
     C                   Z-ADD     *ZEROS        KEY
     C                   MOVE      ' '           BLKTAG
      * SQUASH KY ARRAY...
     C                   EXSR      SQUISH
     C                   ENDIF
     C     ZZNO04        IFEQ      *BLANKS
     C     QTY           CABEQ     *ZEROS        LOOP5
     C                   ENDIF
     C                   END
      *
      * MAINTAIN LOT DETAIL
      *
     C     SEL           IFEQ      'M'                                          LOT MAINTENANCE
     C     TYP           ANDEQ     'N'                                          NONSTK
     C     POCD42        ANDEQ     'Y'
     C     DLTCMP        IFNE      'Y'
     C                   MOVE      'Y'           CHGCMB            1
     C                   DO        57            XY
     C     XY            OCCUR     LOTDS
     C                   CLEAR                   LOTDS
     C                   ENDDO
      *
     C                   Z-ADD     1             XY                2 0
     C                   MOVEL     NSITMX        SAVNS
     C     XY            OCCUR     LOTDS
     C                   MOVEL     IVNO7         CIITM                          OUR ITEM #
     C                   MOVEL     UOM           CIUOM                          UNITS OF MEASR
     C                   Z-ADD     QTY           CIQTY                          QTY ORDERED
     C                   MOVEL     DISC          CIDSC                          DISCOUNT
     C                   Z-ADD     COST          CICST                          COST
     C                   MOVEL     TYP           CITYP                          ITEM TYPE
     C                   MOVE      ZZDN01        CIPDDS                         DESCRIPTION
     C                   MOVEL     ZZNO04        CIPDDS                         PRODUCT NUMBER
     C                   MOVE      MAN           SVMAN                          MANUF NUMBER
     C                   MOVE      COVR          SVCOVR                         COST OVERRIDE
     C                   MOVE      DOVR          SVDOVR                         DISC OVERRIDE
     C                   MOVE      NSITMX        SVITMX                         NONSTK ITM
     C                   MOVE      SYSASN        SVASN                          SYSTEM ASSGNED
     C                   MOVE      SFBOOK        SVSFBK
     C                   MOVE      SFDNR         SVDNR                          DNR FLAG
¢I   C                   MOVE      SFESD         SVESD                          ESD FLAG
¢8   C                   MOVE      SFORGPROD     SVORGPROD                      ORIGINAL PRODUCT NO
¢9   C                   MOVE      SFSELPRC      SVSELPRC                       ORIGINAL PRODUCT NO
¢9   C                   MOVE      SFSELCST      SVSELCST                       ORIGINAL PRODUCT NO
HL   C                   MOVE      SFDEL         SVDEL                          DEL ITEM FLAG
     C                   MOVE      ETASO         SVETAO                         ETA DATE
     C                   MOVE      POCC13        SVETCC                         ETA DATE
     C                   MOVE      SEDIT         SVEDT                          EDIT FLAGS
     C                   MOVE      SEDIT1        SVEDT1                          "    "
     C                   MOVE      SEDIT3        SVEDT3                          "    "
     C                   MOVE      SEDIT4        SVEDT4                          "    "
     C                   MOVE      SEDIT5        SVEDT5                          "    "
     C                   MOVE      SECX          SVSECX                         SAVE SECTION
     C                   MOVE      ETASR         SVETAR                         ETA DATE
     C                   MOVE      POCC15        SVRTCC                         ETA DATE
     C                   Z-ADD     QTYR          SVQTYR                         QTY RELEASED
     C                   Z-ADD     SFORLN        SVORLN                         QTY RELEASED
JV   C                   Z-ADD     ORGL          SVORGL
     C                   Z-ADD     SAVSO         SVSO
     C                   MOVE      SVCC13        SVSOCC
     C                   Z-ADD     SAVSR         SVSR
     C                   MOVE      SVCC15        SVSRCC
     C                   Z-ADD     ODIFF         SVDIFF                         QTY DIFF
     C                   MOVE      NSPREV        SVPREV
     C                   Z-ADD     KEY           SVKEY                          SAVE TAGHOLD KEY
     C                   ENDIF
     C     CHGCMB        CABEQ     'Y'           LOOP5                    53    CHANGE COMPONENT
     C                   ENDIF
      *
      * PRODUCT # CHANGED
      *
     C     PRT           IFNE      ZZNO04                                       CHANGED ITEM #
     C                   MOVE      'Y'           DLTCMP            1            DELETE COMPONEN
     C     POCD42        IFEQ      'Y'                                          LOT PURCHASE
     C                   CLEAR                   POCD42
      * REMOVE TAGS...
     C                   Z-ADD     1             K
     C     KEY           IFNE      *ZEROS
     C     *IN43         DOUEQ     *OFF
     C     K             IFLE      MAXKY
     C     KEY           LOOKUP    KY(K)                                  43
     C                   ELSE
     C                   MOVE      *OFF          *IN43
     C                   ENDIF
     C     *IN43         IFEQ      *ON
     C                   CLEAR                   OS(K)
     C                   CLEAR                   PL(K)
     C                   CLEAR                   KY(K)
     C                   CLEAR                   TH(K)
     C                   ADD       1             K
     C                   ENDIF
     C                   ENDDO
      * SQUASH KY ARRAY...
     C                   EXSR      SQUISH
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * ITEM SEARCH BY PURCHASING BOOK CODES
     C     I1            IFEQ      '?'                                          1ST DIGIT ITEM#
     C     I1A           IFEQ      ' '                                          2ND DIGIT ITEM#
     C                   MOVEA     '0'           *IN(55)                        VERIFY MESSAGE
     C                   Z-ADD     1             INDX              2 0          INITIALIZE
     C     INDX          DOUGT     50                                            DATA
     C     INDX          OCCUR     PODS                                           STRUCTURE
     C                   CLEAR                   PODS                           CLEAR DS
     C                   ADD       1             INDX                           INDEX
     C                   END
      * CLEAR RNS ARRAY
     C                   Z-ADD     *ZERO         R
      *
     C                   EXSR      @CURSR
     C                   CALL      'IVR3006'                                    P/B SEARCH PGM
     C                   PARM                    PODS                           DATA STRUCTUR
     C                   PARM                    BOOK              1
     C                   PARM                    WDWFLG            1
     C                   PARM                    C@LOC#            6            CURSOR LOCATION
     C                   PARM                    CRCD#            10            CURSOR RECORD
     C                   PARM                    CFLD#            10            CURSOR FIELD
     C                   PARM                    CRTRNS            1            CRT TEMPORARY ITEM
     C                   PARM                    R                              RNS ITEMS CREATED
     C                   EXSR      @CLCSR
      *
     C                   Z-ADD     1             INDX              2 0          LOAD DATA
     C     INDX          DOUGT     50                                            STRUCTURE FRM
     C     INDX          OCCUR     PODS                                          SEARCH PROGRAM
     C     Q             IFNE      0
      *
      * ADD TEMPORARY ITEMS CREATED TO TOTAL TEMPORARY ITEMS ON S/O
      *
     C     R(INDX)       IFNE      *ZERO
     C                   Z-ADD     1             RX                3 0          ARRAY INDEX
     C     *ZERO         LOOKUP    RNS(RX)                                47
     C                   MOVE      R(INDX)       RNS(RX)                        ADD TEMP ITEMS
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ADD       1             INDX
     C                   ADD       1             CNTLIN                         # OF LINE ITEMS
     C     X             OCCUR     SAVDS                                72
     C     *IN72         CABEQ     '1'           ENDSQ
     C                   MOVE      I             DITM                           ITEM NUMBER
     C                   Z-ADD     Q             DQTY                           QUANTITY
     C                   MOVE      U             DUOM                           UNITS OF MEASR
     C                   ELSE
     C     INDX          IFEQ      1
     C                   CLEAR                   SFDS
     C                   MOVEL     ZZNO04        PROD
     C                   LEAVE
     C                   ELSE
     C                   GOTO      LOOP5
     C                   ENDIF
     C                   END
     C                   END
     C                   END
     C                   END
      *
      * GENERIC ITEM SEARCH BY OUR PRODUCT NUMBER
     C     I1            IFEQ      '?'                                          1ST DIGIT ITEM#
     C     I1A           IFNE      ' '                                          2ND DIGIT ITEM#
     C                   MOVEA     '0'           *IN(55)                        VERIFY MESSAGE
     C                   Z-ADD     1             INDX              2 0          INITIALIZE
     C     INDX          DOUGT     50                                            DATA
     C     INDX          OCCUR     PODS                                           STRUCTURE
     C                   CLEAR                   PODS                           CLEAR DS
     C                   ADD       1             INDX                           INDEX
     C                   END
      * CLEAR RNS ARRAY
     C                   Z-ADD     *ZERO         R
      *
     C     *LIKE         DEFINE    IVNO04        PRT#
     C                   MOVEL     ZZNO04        PRT#                           ITEM NUMBER
     C                   EXSR      @CURSR
     C                   CALL      'IVR3026'                                    GENERIC SEARCH
     C                   PARM                    PODS                           DATA STRUCTR
     C                   PARM                    PRT#                           ITEM NUMBER
     C                   PARM                    WDWFLG            1
     C                   PARM                    C@LOC#            6            CURSOR LOCATION
     C                   PARM                    CRCD#            10            CURSOR RECORD
     C                   PARM                    CFLD#            10            CURSOR FIELD
     C                   PARM                    CRTRNS            1            CRT TEMPORARY ITEM
     C                   PARM                    R                              RNS ITEMS CREATED
     C                   EXSR      @CLCSR
     C     PRT#          IFNE      *BLANKS                                      ITEM FRM SEARCH
     C                   MOVEL     PRT#          ZZNO04                         S/F ITEM NO
     C                   ELSE
      *
     C                   Z-ADD     1             INDX              2 0
     C     INDX          DOUGT     50
     C     INDX          OCCUR     PODS
     C     Q             IFNE      0
      *
      * ADD TEMPORARY ITEMS CREATED TO TOTAL TEMPORARY ITEMS ON S/O
      *
     C     R(INDX)       IFNE      *ZERO
     C                   Z-ADD     1             RX                3 0          ARRAY INDEX
     C     *ZERO         LOOKUP    RNS(RX)                                47
     C                   MOVE      R(INDX)       RNS(RX)                        ADD TEMP ITEMS
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ADD       1             INDX
     C                   ADD       1             CNTLIN                         # OF LINE ITEMS
     C     X             OCCUR     SAVDS                                72
     C     *IN72         CABEQ     '1'           ENDSQ
     C                   MOVE      I             DITM                           ITEM NUMBER
     C                   Z-ADD     Q             DQTY                           QUANTITY
     C                   MOVE      U             DUOM                           UNITS OF MEASR
     C                   ELSE
     C     INDX          IFEQ      1
     C                   CLEAR                   SFDS
     C                   MOVEL     ZZNO04        PROD
     C                   LEAVE
     C                   ELSE
     C                   GOTO      LOOP5
     C                   ENDIF
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
      * ITEM DESCRIPTION SEARCH ???
     C     I1            IFEQ      '.'                                          1ST DIGIT IT
     C                   MOVEA     '0'           *IN(55)                        VERIFY MESSAGE
     C                   Z-ADD     1             INDX              2 0          INITIALIZE
     C     INDX          DOUGT     50                                            DATA
     C     INDX          OCCUR     PODS                                           STRUCTURE
     C                   CLEAR                   PODS                           CLEAR DS
     C                   ADD       1             INDX                           INDEX
     C                   ENDDO
      * CLEAR RNS ARRAY
     C                   Z-ADD     *ZERO         R
      *
     C                   CLEAR                   PRT#P
     C                   MOVEL     ZZNO04        PRT#P
     C                   MOVEL     PONO02        ITMBR                          SHIP BRANCH
     C                   MOVE      'B'           UOMTYP                         BUYING UOM
     C                   EXSR      @CURSR
     C                   CALL      'IVC3061'                                    GENERIC SEARCH
     C                   PARM                    PODS                           DATA STRUCTR
     C                   PARM                    PRT#P            25
     C                   PARM                    ITMBR
     C                   PARM                    UOMTYP            1
     C                   PARM                    WDWFLG            1
     C                   PARM                    C@LOC#            6            CURSOR LOCATION
     C                   PARM                    CRCD#            10            CURSOR RECORD
     C                   PARM                    CFLD#            10            CURSOR FIELD
     C                   PARM                    CRTRNS                         CRT TEMP ITEM
     C                   PARM                    RNSDS                          RNS ITEMS
     C                   EXSR      @CLCSR
      *
     C                   Z-ADD     1             INDX              2 0
     C     INDX          DOUGT     50
     C     INDX          OCCUR     PODS
     C     Q             IFNE      0
      *
      * ADD RNS ITEMS CREATED TO TOTAL RNS ITEMS ON S/O
      *
     C     INDX          OCCUR     RNSDS
     C     RNSITM        IFNE      *ZERO
     C                   Z-ADD     1             RX                3 0          ARRAY INDEX
     C     *ZERO         LOOKUP    RNS(RX)                                47
     C                   Z-ADD     RNSITM        RNS(RX)                        ADD TEMP ITEMS
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ADD       1             INDX
     C                   ADD       1             CNTLIN                         # OF LINE ITEMS
     C     X             OCCUR     SAVDS                                72
     C     *IN72         CABEQ     '1'           ENDSQ
     C                   MOVEL     I             DITM                           ITEM NUMBER
     C                   Z-ADD     Q             DQTY                           QUANTITY
     C                   MOVE      U             DUOM                           UNITS OF MEASR
     C                   ELSE
     C     INDX          IFEQ      1
     C                   CLEAR                   SFDS
     C                   MOVEL     ZZNO04        PROD
     C                   LEAVE
     C                   ELSE
     C                   GOTO      LOOP5
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
¢N    *
¢N    * ITEM SEARCH BY BAKER
¢N   C     I1            IFEQ      ';'                                          1ST DIGIT IT
¢N   C     I1            OREQ      ':'                                          1ST DIGIT IT
¢N   C                   MOVEA     '0'           *IN(55)                        VERIFY MESSAGE
¢N   C                   Z-ADD     1             INDX              2 0          INITIALIZE
¢N   C     INDX          DOUGT     50                                            DATA
¢N   C     INDX          OCCUR     PODS                                           STRUCTURE
¢N   C                   CLEAR                   PODS                           CLEAR DS
¢N   C                   ADD       1             INDX                           INDEX
¢N   C                   ENDDO
¢N    * CLEAR RNS ARRAY
¢N   C                   Z-ADD     *ZERO         R
¢N    *
¢N   C                   MOVEL     *ALL' '       @P@
¢N   C                   MOVEL     PROG          @P@SRC
¢N   C                   MOVEL     *ALL'0'       @P@CMD
¢N   C                   MOVEL     '2'           @PITYP
¢N   C                   MOVEL     'N'           @PIRPT
¢N   C                   MOVEL     PROG          @PICBY
¢N   C                   MOVEL     PONO02        @POBNO
¢N   C                   MOVEL     IQSRCH        @PIPOS
¢N   C     IQSRCH        IFEQ      *BLANKS
¢N   C                   MOVEL     'I'           @PIFLD
¢N   C                   ELSE
¢N   C                   MOVEL     'D'           @PIFLD
¢N   C                   ENDIF
¢N   C                   CALL      'IQRC001S'
¢N   C                   PARM                    @P@
¢N   C                   EXSR      @CLCSR
¢N    * LOAD UP THE RETURNED RESULTS TO DATA STRUCTURE FOR PROCESSING
¢N   C     @P@CMD        IFEQ      *ALL'0'
¢N   C     @PIRTN        ANDNE     *ALL' '
¢N   C     1             OCCUR     PODS
¢N   C                   MOVEL     @PIRTN        I
¢N   C                   Z-ADD     -1            Q
¢N   C     @PIRTN2       IFNE      *ALL' '
¢N   C     2             OCCUR     PODS
¢N   C                   MOVEL     @PIRTN2       I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN3       IFNE      *ALL' '
¢N   C     3             OCCUR     PODS
¢N   C                   MOVEL     @PIRTN3       I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN4       IFNE      *ALL' '
¢N   C     4             OCCUR     PODS
¢N   C                   MOVEL     @PIRTN4       I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN5       IFNE      *ALL' '
¢N   C     5             OCCUR     PODS
¢N   C                   MOVEL     @PIRTN5       I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN6       IFNE      *ALL' '
¢N   C     6             OCCUR     PODS
¢N   C                   MOVEL     @PIRTN6       I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN7       IFNE      *ALL' '
¢N   C     7             OCCUR     PODS
¢N   C                   MOVEL     @PIRTN7       I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN8       IFNE      *ALL' '
¢N   C     8             OCCUR     PODS
¢N   C                   MOVEL     @PIRTN8       I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN9       IFNE      *ALL' '
¢N   C     9             OCCUR     PODS
¢N   C                   MOVEL     @PIRTN9       I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN10      IFNE      *ALL' '
¢N   C     10            OCCUR     PODS
¢N   C                   MOVEL     @PIRTN10      I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN11      IFNE      *ALL' '
¢N   C     11            OCCUR     PODS
¢N   C                   MOVEL     @PIRTN11      I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN12      IFNE      *ALL' '
¢N   C     12            OCCUR     PODS
¢N   C                   MOVEL     @PIRTN12      I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN13      IFNE      *ALL' '
¢N   C     13            OCCUR     PODS
¢N   C                   MOVEL     @PIRTN13      I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C     @PIRTN14      IFNE      *ALL' '
¢N   C     14            OCCUR     PODS
¢N   C                   MOVEL     @PIRTN14      I
¢N   C                   Z-ADD     -1            Q
¢N   C                   ENDIF
¢N   C                   ENDIF
¢N    *
¢N   C                   Z-ADD     1             INDX
¢N   C     INDX          DOUGT     50
¢N   C     INDX          OCCUR     RNSDS
¢N   C                   Z-ADD     0             RNSITM
¢N   C                   ADD       1             INDX
¢N   C                   ENDDO
¢N    *
¢N   C                   Z-ADD     1             INDX              2 0
¢N   C     INDX          DOUGT     50
¢N   C     INDX          OCCUR     PODS
¢N   C     Q             IFNE      0
¢N    *
¢N    * ADD TEMPORARY ITEMS CREATED TO TOTAL TEMPORARY ITEMS ON S/O
¢N    *
¢N   C
¢N   C     INDX          OCCUR     RNSDS
¢N   C     RNSITM        IFNE      *ZERO
¢N   C                   Z-ADD     1             RX                3 0          ARRAY INDEX
¢N   C     *ZERO         LOOKUP    RNS(RX)                                47
¢N   C                   Z-ADD     RNSITM        RNS(RX)                        ADD TEMP ITEMS
¢N   C                   ENDIF
¢N    *
¢N   C                   ADD       1             X
¢N   C                   ADD       1             INDX
¢N   C                   ADD       1             CNTLIN                         # OF LINE ITEMS
¢N   C     X             OCCUR     SAVDS                                72
¢N   C     *IN72         CABEQ     '1'           ENDSQ
¢N   C                   MOVEL     I             DITM                           ITEM NUMBER
¢N   C                   Z-ADD     0             DQTY                           QUANTITY
¢N   C*****              Z-ADD     Q             DQTY                           QUANTITY
¢N   C                   MOVE      U             DUOM                           UNITS OF MEASR
¢N   C                   ELSE
¢N   C     INDX          IFEQ      1
¢N   C                   CLEAR                   SFDS
¢N   C                   MOVEL     ZZNO04        PROD
¢N   C                   LEAVE
¢N   C                   ELSE
¢N   C                   GOTO      LOOP5
¢N   C                   ENDIF
¢N   C                   ENDIF
¢N   C                   ENDDO
¢N   C                   ENDIF
      *
      * IF NONSTOCK ITEM, CHECK FOR ANY LINE COMMENT TAGS
     C                   MOVE      ' '           RTVCMT            1
     C     I1            IFEQ      '/'                                          NONSTOCK
     C     NSITM         ANDNE     *BLANKS                                      ITEM
     C     NSITM         IFNE      NSITMX
     C                   MOVE      ' '           CMTFLG
     C                   ENDIF
     C     CMTFLG        IFNE      'Y'
     C                   MOVE      *IN43         SVIN43            1
     C     ZZNO04        CHAIN     OELTOLY8                           43
     C     *IN43         IFEQ      *OFF
     C     OECD30        IFEQ      'Y'                                          LINE TAGS
     C                   MOVE      *IN47         SVIN47            1
     C     TAGKY2        SETLL     OEFTOT                                 47
     C     *IN47         IFEQ      *OFF
     C     TAGKY2        SETLL     OEFTOTY                                47
     C                   ENDIF
     C     *IN47         IFEQ      *ON
     C                   MOVE      'Y'           CMTFLG
     C                   MOVE      'Y'           RTVCMT            1
     C                   ENDIF
     C                   MOVE      SVIN47        *IN47
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      SVIN43        *IN43
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             CNTLIN                         # OF LINE ITEMS
     C                   ADD       1             X                              D/S INDEX
     C     X             OCCUR     SAVDS                                72
     C     *IN72         CABEQ     '1'           ENDSQ
     C                   MOVEL     ZZNO04        PROD
     C                   MOVEL     ZZDN01        DESC
     C                   MOVE      SFDS          SAVDS
      *
      * LOAD LINE ITEM TAG COMMENTS
     C     I1            IFEQ      '/'                                          NONSTOCK
     C     NSITM         ANDNE     *BLANKS                                      ITEM
     C     CMTFLG        ANDEQ     'Y'                                          COMMENT FLG
     C     RTVCMT        ANDEQ     'Y'                                          RTV COMMENTS
     C     OECD30        ANDEQ     'Y'                                          LINE TAG EXISTS
     C                   MOVE      *IN47         SVIN47
     C                   MOVE      *OFF          *IN47
     C                   CLEAR                   TOTYFL
     C     TAGKY2        SETLL     OEFTOT                                 47
     C     *IN47         IFEQ      *OFF
     C                   MOVE      'Y'           TOTYFL            1
     C     TAGKY2        SETLL     OEFTOTY                                47
     C                   ENDIF
     C     *IN47         DOUEQ     *ON
     C     TOTYFL        IFEQ      'Y'
     C     TAGKY2        READE     OEFTOTY                                47
     C                   ELSE
     C     TAGKY2        READE     OEFTOT                                 47
     C                   ENDIF
     C     *IN47         IFEQ      *OFF
     C                   CLEAR                   SFDS
     C                   MOVEL     '*'           PROD
     C                   MOVEL     OEDN05        DESC
     C                   ADD       1             CNTLIN                         # OF LINE ITEMS
     C                   ADD       1             X                              D/S INDEX
     C     X             OCCUR     SAVDS                                72
     C     *IN72         CABEQ     '1'           ENDSQ
     C                   MOVE      SFDS          SAVDS
     C                   ENDIF
     C                   ENDDO
     C                   MOVE      SVIN47        *IN47
     C                   ENDIF
I0    *
I0    * INSERT LINE ITEMS
I0    * Cannot insert comments if EDI Processing has occurred...
I0   C                   eval      AllowInsert = 'Y'
I0   C                   If        EDI = 'Y'
I0   C     SEL           IFGE      '1'
I0   C     SEL           ANDLE     '9'
I0   C                   Call      'EIR9507'
I0   C                   Parm                    PONO01
I0   C                   Parm                    AllowInsert       1
I0   C                   ENDIF
I0   C                   endif
I0   C     RCVFND        IFNE      'Y'                                          NO RECEIVER
JT   C     POCD42        Andne     'Y'                                          NOT A LOT PO
I0   C     AllowInsert   Andeq     'Y'                                          NO RECEIVER
I0   C     SEL           IFGE      '1'
I0   C     SEL           ANDLE     '9'
I0   C                   MOVE      SFDS          SAVDS
I0   C                   MOVE      SEL           INSERT            1 0
I0   C                   MOVE      SEL           DSEL
I0   C                   CLEAR                   SEL
I0   C                   ADD       1             INSX
I0   C                   CLEAR                   SFDS
I0    *LOG WHETHER THERE IS MORE THAN ONE INSERT ON A SCREEN
I0   C     INSX          IFEQ      1
I0   C     x             add       1             curser_rrn
I0   C                   ADD       1             INSX
I0   C                   ENDIF
I0   C                   DO        INSERT
I0   C                   ADD       1             X
I0   C                   ADD       1             CNTLIN
I0 I1C*    X             OCCUR     SAVDS                                26
I1   C     X             OCCUR     SAVDS                                72
I0   C     *IN72         IFEQ      *ON
I0   C                   MOVE      'Y'           OVRLMT
I0   C                   ENDIF
I0   C     *IN72         CABEQ     '1'           ENDSQ
I0   C                   CLEAR                   IVNO7
I0   C                   CLEAR                   ITM
I0   C                   CLEAR                   ZZNO04
I0   C                   CLEAR                   NSITM
I0   C                   CLEAR                   DESC
I0   C                   CLEAR                   TYP
I0   C                   MOVE      'C'           TYP
I0   C                   MOVEL     '* '          ZZNO04
I0   C                   MOVEL     '* '          PROD
I0   C                   MOVEL     'Y'           DCMTFL
I0   C                   MOVEL     'Y'           CMTFLG
I0   C                   MOVE      SFDS          SAVDS
JW    * remember the insertion rrn
JW   C                   if        insrrn = *zeros
JW   C                   z-add     x             insrrn
JW   C                   endif
I0   C                   END
I0   C                   MOVE      'Y'           INSFLG
I0   C                   MOVE      'Y'           INSCOM
I0   C                   END
I0   C                   ENDIF                                                  RCVFND NE 'Y'
      *
     C                   ELSE
     C     CHGCMB        CASEQ     'Y'           CHGCMP
     C                   ENDCS
     C                   END
     C                   END
      * SAVE MAX SIZE USED FOR DATA STRUCTURE (FOR LATER INIT)...
     C                   Z-ADD     X             MAXDS
     C     ENDSQ         TAG
      *
      * *IN72 = OCUR OUT OF RANGE, LINE ITEM LIMIT HAS BEEN EXCEEDED
      *
     C     *IN72         IFEQ      *ON
     C                   MOVE      'Y'           OVRLMT                         OVER LINE LIMIT
     C                   ENDIF
      *
      * RESTORE ALL INDICATOR SETTINGS (THEY WERE SAVED AT THE BEGINNING OF
      * THE SUBROUTINE).
      *
     C                   MOVEA     SQUIN         *IN                            RSTR ALL IND'S
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    OUR ITEM NUMBER                                         *
      *------------------------------------------------------------------------*
     C     CHKITM        BEGSR
     C                   MOVE      *OFF          BRCHK
     C                   Z-ADD     0             IVNO07                         ITEM NUMBER
      *
      * NO STOCKED ITEMS ALLOWED IF DIRECT LOT P.O.
      *
     C     POCD42        IFEQ      'Y'
     C                   MOVE      *ON           *IN81                          DSPATR(RI)
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   MOVEL     EMS(39)       MSGFLD
     C     MSGFLD        CABNE     *BLANKS       ENDO
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       DESC                           DESCRIPTION
     C                   MOVE      *BLANKS       ZZDN01                         DESCRIPTION
     C     I1            IFEQ      '.'
I0   C     I1            OREQ      '*'
     C     I1            OREQ      '?'
     C                   MOVE      'Y'           NOVRFY
     C                   GOTO      ENDO
     C                   ENDIF
     C     TYP           IFEQ      'O'
     C                   MOVEL     ZZNO04        ITEM#             6 0          OUR ITEM #
     C                   END
      *
   ¢CC*    QTY           IFLE      0                                            QTY ORDERED
¢C   C     QTY           IFEQ      0                                            QTY ORDERED
¢8   C     SFORGPROD     ANDEQ     *BLANKS
     C                   MOVEA     '1'           *IN(80)                        POSITION CURSOR
     C                   MOVEA     '1'           *IN(83)                        HIGHLITE
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVEL     UMS(22)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
      * CALCULATE QUANTITY RECEIVED TO DATE AT PURCHASING UOM...
     C     UOMSF         IFNE      *ZEROS
     C     QTYR          DIV       UOMSF         QTYR@P                         RCV @ PCHSNG
     C                   ELSE
     C                   Z-ADD     QTYR          QTYR@P
     C                   ENDIF
      * DONT ALLOW QTY TO BE LESS THAN RECEIVED QTY...
KT    * only load message is user selected to go to tag & hold screen
   :AC*    MSGFLD        IFEQ      *BLANKS                                      NO ERROR
KT :AC*    SEL           ANDEQ     'T'
   :AC*    QTY           IFLT      QTYR@P
   :AC*    WRNR@P        ANDEQ     *BLANKS
      *
      * IF REC QTY GT STK P/O QTY, ALLOW TO CHANGE THE P/O QTY.
   :AC*                  MOVE      *ON           *IN93                          RI,PC
   :AC*                  MOVE      'Y'           ALWQCH
   :AC*                  MOVE      'Y'           ERRFLG
   :AC*                  MOVE      'Y'           WRNR@P            1
   :AC*                  MOVE      'Y'           ERRFLG
   :AC*                  MOVEL     EMS(22)       MSGFLD
   :AC*                  ENDIF
   :AC*                  ENDIF
      *
      * IF ITEM ON OPEN ASN IN WM SYSTEM,
      * AND QTY IS DECREASED, ERROR
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     ONASNF        ANDEQ     'Y'
     C     QTY           ANDLT     OQTY
     C     WHMBR         OREQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     ONASNF        ANDEQ     '0'
     C     QTY           ANDLT     OQTY
     C                   MOVE      *ON           *IN83
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVEL     EMS(54)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   ENDIF
     C                   ENDIF
      *
      *
     C     TYP           IFEQ      'O'                                          OUR ITEM ?
     C     ITEM#         CHAIN     IVFITEM                            41        ITEM MASTER
     C                   CLEAR                   ALIDTA
     C                   MOVEL     ITEM#         ALIDTA
     C                   END
     C     TYP           IFEQ      'P'                                          OUR PROD# ?
     C     ZZNO04        CHAIN     IVFPROD                            41        ITEM MASTER
     C                   MOVEL     ZZNO04        ALIDTA
     C                   END
      * IF ITEM ENTERED IS IN ERROR,
      * THEN DETERMINE IF AN ALIAS WAS ENTERED...  IF IT WAS, GET THE
      * PRODUCT NUMBER, ITEM NUMBER, AND THEN RETRIEVE DATA FOR ITEM...
     C     *IN41         IFEQ      *ON
     C                   CALL      'IVR0404'     ALIPRM
     C     ALIAS         IFNE      *BLANKS
     C                   MOVEL     ALIPRD        ZZNO04
     C                   MOVEL     ALIPRD        SVNO04
     C     ALIITM        CHAIN     IVFITEM                            41
     C                   ENDIF
     C                   ENDIF
     C     *IN41         IFEQ      '0'                                          NOT FOUND
     C     IVCD25        ANDEQ     ' '                                          NOT DELETED
KI    * Overhead item?
KI   C                   if        ivfl19 = 'Y' and ohauth <> 'Y'
KI   C                   if        msgfld = ' '
KI   C                   eval      msgfld = ums(68)
KI   C                   endif
KI   C                   eval      errflg = 'Y'
KI   C                   eval      *in81 = *on
KI   C     MSGFLD        CABNE     *BLANKS       ENDO
KI   C                   endif
KW    * If overhead item on po, do not allow inventory item on same po
KW   C                   if        ivfl19 = 'Y'
KW   C                   eval      ovhfnd = 'Y'
KW   C                   endif
KW   C                   if        ivcdin = 'Y'
KW   C                   eval      invfnd = 'Y'
KW   C                   endif
KW    *
KW   C                   if        ovhfnd = 'Y' and invfnd = 'Y'
KW   C                             or ovhfnd = 'Y' and nsc(1) <> ' '            nonstock found
KW   C                   eval      errflg = 'Y'
KW   C                   eval      *in81  = *on
KW   C                   if        msgfld = ' '
KW   C                   if        invfnd = 'Y'
KW   C                   eval      msgfld = 'Inventory item not allowed on PO +
KW   C                             with overhead item'
KW   C                   else
KW   C                   eval      msgfld = 'Nonstock item not allowed on PO +
KW   C                             with overhead item'
KW   C                   endif
KW   C                   endif
KW   C                   endif
¢7    * Check to see if item vendor matches po vendor
¢7   C                   IF        ItmVndToMatch = 'Y'
¢7   C     POYR02        ifeq      21
¢7   C     POMO02        andeq     11
¢7   C     POdy02        andge     18
¢7   C     POyr02        oreq      21
¢7   C     POMO02        andgt     11
¢7   C     POyr02        orge      22
¢7   C                   IF        IVNO05 <> APNO01
¢7   C                   MOVE      *ON           *IN81
¢7   C     MSGFLD        IFEQ      *BLANKS                                      NO ERRORS
¢7   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
¢7   C                   MOVEL     CMS(14)       MSGFLD
¢7   C                   ENDIF
¢7   C                   ENDIF
¢7   C                   ENDIF
¢7   C                   ENDIF
¢S    * Record po item entered
¢S   C                   MOVE      *IN50         SAVEIN50          1
¢S   C                   Z-ADD     1             F                 4 0          INZ ARRAY INDEX
¢S   C     IVNO07        LOOKUP    FITM(F)                                50
¢S   C     *IN50         IFEQ      *ON
¢S   C     DATENT        IFGT      DUPITMDATE
¢S   C                   MOVE      *ON           *IN81                          DSPATR(RI)
¢S   C     MSGFLD        IFEQ      *BLANKS                                      NO ERRORS
¢S   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
¢S   C                   MOVEL     CMS(11)       MSGFLD
¢S   C                   ENDIF
¢S   C                   ENDIF
¢S   C                   ELSE
¢S   C                   Z-ADD     1             F                              INZ ARRAY INDEX
¢S   C     *ZEROS        LOOKUP    FITM(F)                                50    FIND EMPTY SPOT
¢S   C     *IN50         IFEQ      *ON                                          SPOT FOUND
¢S   C                   MOVEA     IVNO07        FITM(F)                        OUR ITEM NUMBER
¢S   C                   ENDIF
¢S   C                   ENDIF
¢S   C                   MOVE      SAVEIN50      *IN50
HD    *
HD    * Consignment Check
HD   C     POFL65        IFEQ      'Y'
HD   C     IVCDF4        IFNE      'Y'
HD   C     MSGFLD        IFEQ      *BLANKS
HD   C                   MOVEL     EMS(56)       MSGFLD
HD   C                   ENDIF
HD   C                   ELSE
HD   C     BRKEY         CHAIN(N)  IVFMSBR                            46
HD   C     *IN46         IFEQ      '0'
HD   C     IVCDF7        IFNE      'Y'
HD   C     MSGFLD        IFEQ      *BLANKS
HD   C                   MOVEL     EMS(57)       MSGFLD
HD   C                   ENDIF
HD   C                   ENDIF
HD   C                   ENDIF
HD   C                   ENDIF
HD   C     MSGFLD        IFNE      *BLANKS
HD   C                   MOVE      '1'           *IN81                          ERROR OCCURED
HD   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
HD   C                   GOTO      ENDO                                         ERROR OCCURED
HD   C                   ENDIF
HD   C                   ENDIF
¢P   C                   MOVEL     IVNO04        PROD
¢P   C                   MOVEL     IVNO04        ZZNO04
¢P   C                   MOVEL     IVNO04        SVNO04
¢P   C                   MOVEL     IVNO04        PRT
     C                   MOVEL     IVDN01        DESC                           DESCRIPTION
     C                   MOVEL     IVDN01        ZZDN01                         DESCRIPTION
     C     IVCD24        IFEQ      'Y'
     C                   MOVE      '1'           *IN81
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   MOVEL     UMS(19)       MSGFLD
     C     MSGFLD        CABNE     *BLANKS       ENDO
     C                   END
     C                   END
HA HF *
HA HF * CHECK SERIAL NUMBER GREATER THAN 99
HA HF *
HA HFC*    IVCD57        IFEQ      'Y'
HA HFC*    QTY           IFGT      99
HA HFC*    QTY           ORLT      -99
HA HFC*                  MOVEA     '1'           *IN(80)                        HIGHLITE ERROR
HA HFC*                  MOVEA     '1'           *IN(83)                        HIGHLITE ERROR
HA HFC*    ERRFLG        IFNE      'Y'                                          NO ERRORS
HA HFC*                  MOVE      UMS(63)       MSGFLD
HA HFC*                  MOVE      'Y'           ERRFLG
HA HFC*                  ENDIF
HA HFC*                  ENDIF
HA HFC*                  ENDIF
HA HF *
      *
      *
      * CHECK IF ITEM IS A TEMPORARY ITEM WITH A STATUS OF 'E'
      * OR 'P' AND IF SO, VERIFY THAT THE ITEMS EXISTS IN THE TOTAL RNS
      * ITEMS ARRAY(RNS).  IF ITEM DOES NOT EXISTS IN THE ARRAY,
      * DISPLAY ERROR: TEMPORARY ITEM MUST BE VERIFIED.
      *
     C     IVCDC8        IFEQ      'E'                                          ENTERED
     C     IVCDC8        OREQ      'P'                                          PRINTED
     C                   Z-ADD     1             RX
     C     IVNO07        LOOKUP    RNS(RX)                                46
     C     *IN46         IFEQ      *OFF
     C                   MOVE      *ON           *IN81
     C                   MOVE      *ON           *IN83
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(14)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * FOR NONDIRECTS:
      * CHECK IF ITEM IS A TEMPORARY ITEM THAT EXISTS IN THE
      * RNS ITEMS ONLY FROM SALES ORDER(DOES NOT INCLUDE ITEMS CREATED
      * ON THE GENERIC SEARCH) ARRAY.  IF THE ITEM DOES NOT EXIST IN
      * IN THE ARRAY, DISPLAY ERRROR: TEMPORARY ITEM MUST BE VERIFIED
      *
     C     POCD01        IFNE      'D'                                          NON-DIRECT
     C     IVCDC8        IFEQ      'E'                                          ENTERED
     C     IVCDC8        OREQ      'P'                                          PRINTED
     C                   Z-ADD     1             RY
     C     IVNO07        LOOKUP    RN2(RY)                                46
     C     *IN46         IFEQ      *OFF
     C                   MOVE      *ON           *IN81
     C                   MOVE      *ON           *IN83
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(14)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * SAVE STOCKING AND REFERENCE UOM'S IN SFL FOR LATER ERR CHK...
     C                   MOVE      IVDN20        SUOMSF
     C                   MOVE      IVDN41        RUOMSF
     C                   Z-ADD     IVQYZ9        RUOMSQ
     C     IVNO07        IFNE      IVNO7                                        SAME ITEM ?
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C                   Z-ADD     0             COST                           RPLCMNT COST
     C                   MOVE      *BLANKS       DISC                           DISCOUNT
     C                   Z-ADD     0             LIST                           MANUF LIST
     C                   MOVE      ' '           COVR                           COST OVERRIDE
     C                   MOVE      ' '           DOVR                           DISC OVERRIDE
     C                   MOVE      ' '           SFBOOK                         PRCH BK WARN
     C                   MOVE      ' '           SFDNR                          DNR WARN
¢I   C                   MOVE      ' '           SFESD                          DNR WARN
¢8   C                   MOVE      ' '           SFORGPROD
¢9   C                   MOVE      0             SFSELPRC
¢9   C                   MOVE      0             SFSELCST
     C                   CLEAR                   SFORLN
     C                   CLEAR                   KEY
      *
      * RETRIEVE PURCHASING UOM...
     C     IVNO07        IFNE      0                                            NO NON-STK
      *
      * RETRIEVE PURCHASE ORDER UOM IF NOT ENTERED &
      * & PURCHASE ORDER UOM FACTOR USING API.
      * ALSO RETRIEVE PRICE UOM AND ITS FACTOR.
     C                   Z-ADD     IVNO07        AUOMI#
     C                   MOVE      UOM           AUOMOU
     C                   CALL      'POR0117'     PL0117                         UOM API
      * IF A NEW ITEM WAS ENTERED WITHOUT A UOM, THEN RETRIEVE UOM...
     C     UOM           IFEQ      *BLANKS                                      UOM BLANK
     C     IVNO7         ANDEQ     0                                            NEW ITEM
      * OR, IF EXIST ITEM WAS CHGD, BUT UOM LEFT ALONE, RETRIEVE UOM...
     C     UOM           OREQ      OUOM                                         UOM SAME
     C     IVNO7         ANDNE     0                                            CHG ITEM
     C     AUOMOU        IFNE      *BLANKS
     C                   MOVE      AUOMOU        UOM                            SELLING UOM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * RETRIEVE PRICING UOM...
     C     IVNO07        IFNE      0                                            NO NON-STK
     C     AUOMPU        IFNE      *BLANKS
     C                   MOVE      AUOMPU        PUOM
     C                   ENDIF
     C                   END
     C                   ENDIF
      * IF THE UOM (OR ITEM) HAS BEEN CHANGED,
      * OR IF THE STOCKING UOM FACTOR DOES NOT EXIST,
      * RETRIEVE AND VALIDATE PURCHASING UOM, AND SAVE UOM FACTOR...
     C     IVNO07        IFNE      IVNO7                                        SAME ITEM ?
     C     UOM           ORNE      OUOM
     C     UOMSF         OREQ      0
      *
      * VALIDATE PURCHASING UOM, AND SAVE UOM FACTOR...
     C                   Z-ADD     IVNO07        AUOMI#
     C                   MOVE      UOM           AUOMOU
     C                   CALL      'POR0117'     PL0117                         UOM API
     C     AUOMOU        IFNE      *BLANKS
     C     AUOMRC        ANDEQ     '0'
     C     AUOMOF        IFNE      *ZEROS
     C                   Z-ADD     AUOMOF        UOMSF
     C                   ENDIF
     C                   ELSE
      *
      * PURCHASE ORDER UOM NOT FOUND
     C     AUOMRC        IFEQ      '1'
     C                   MOVE      *ON           *IN01
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(35)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   ELSE
      *
      * IF  ORDER UOM IS SAME AS PRICE UOM
      * AND ORDER UOM IS NOT SAME AS STOCK UOM,REF UOM,
      * AND ORDER UOM IS NOT SAME AS PURCHASE UOM, O/E UOM
      *                  AND ALT UOM (I.E. NOT IN UOM FILE) THAN
     C     AUOMRC        IFEQ      '3'
     C                   MOVE      *ON           *IN01
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     EMS(49)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * MAKE SURE UOM HAS BEEN ENTERED...
     C     IVNO07        IFNE      0
     C     UOM           ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN01
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(35)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      * CALCULATE ORDERED UNITS IN STOCKING QTY...
     C     UOMSF         MULT      QTY           UQYSF
      * CALCULATE QUANTITY RECEIVED TO DATE AT PURCHASING UOM...
     C     UOMSF         IFNE      0
     C     QTYR          DIV       UOMSF         QTYR@P            7 0          RCV @ PCHSNG
     C                   ELSE
     C                   Z-ADD     QTYR          QTYR@P
     C                   ENDIF
      *
     C     QTYR          IFNE      0                                            QTY RECEIVED
      * PROTECT UOM FIELDS IF QTY'S HAVE BEEN RECEIVED...
     C                   MOVE      *ON           *IN60
     C     UQYSF         IFNE      UQYSFO                                       QTY CHANGE ?
     C     QTY           IFLT      QTYR@P
     C                   MOVEA     '1'           *IN(83)                        HIGHLITE ERROR
     C     ERRFLG        IFNE      'Y'                                          ERROR
      * IF ERROR WITH RECEIVED-TO-DATE, SHOW STOCKING RCVD QTY...
      * FOLD THE SCREEN IF NEEDED (SO USER CAN VIEW)...
   ¢VC*    MODE          IFEQ      '1'
   ¢VC*                  MOVE      '0'           MODE
   ¢VC*                  MOVE      MODE          *IN28
   ¢VC*                  ENDIF
     C                   MOVEL     UMS(21)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
     C                   END
     C                   END
KM    * SKIP THE FOLLOWING LOGIC IF PSOVR = 'Y'; PRICE SHEET STATUS HAS BEEN
KM    * OVERRIDDEN ON THE POC0110G.
KM   C                   IF        PSOVR = 'Y'
KM   C                   EVAL      COVR = 'Y'
KM   C     PSOVR         CABEQ     'Y'           SKIP_PSOVR
KM   C                   ENDIF
      *
      * DETERMINE COSTING BRANCH
     C     POCD01        IFEQ      'D'                                          DIRECT PO
     C     PONO02        OREQ      *ZERO                                        SHIPTO = 0
     C                   MOVE      PONO03        COSTBR
     C                   ELSE
     C                   MOVE      PONO02        COSTBR
     C                   END
      *
KM   C                   CLEAR                   PSNME
KM   C                   CLEAR                   PSCTNM
KM   C                   CLEAR                   PSSTS
KM   C                   CLEAR                   PSTYPE
KM    *
     C                   MOVE      '0'           GOTIT             1
     C                   MOVE      '0'           SAVED             1
     C     PRCKYD        CHAIN     PRFMPSD                            40
     C     *IN40         DOWEQ     '0'
      * DETERMINE IF THE ITEM ON A REGIONAL PRICE SHEET
     C     CTL#BR        SETLL     PRFMREG                                41
     C     *IN41         IFEQ      '1'
KM   C                   MOVE      'R'           PSTYPE
     C                   MOVE      '1'           GOTIT                           YES-REGN'L
     C                   MOVE      '1'           *IN40
     C                   ELSE
     C     SAVED         IFEQ      '0'
     C     PRNO02        SETLL     PRFMREG                                41
     C     *IN41         IFEQ      '0'
     C                   MOVE      RECPSD        SAVPSD                         SAVE NORM'L
     C                   MOVE      '1'           SAVED
     C                   END
     C                   END
     C                   END
     C     *IN40         IFEQ      '0'
     C     PRCKYD        READE     PRFMPSD                                40
     C                   END
     C                   END
      ** USE DATA SAVED FROM "NORMAL" PRICE SHEET. NO REG'L SHEET FOUND
     C     GOTIT         IFEQ      '0'
      *          SAVED     ANDEQ'1'
     C                   Z-ADD     IVAM01        PRAM01
     C                   Z-ADD     IVAM02        PRAM03
     C                   Z-ADD     IVAM05        PRAM11
     C                   Z-ADD     IVAM32        PRAM05
     C                   Z-ADD     IVAM34        PRAM13
     C     SAVED         IFEQ      '1'
     C                   MOVE      SAVPSD        RECPSD                         RESTORE NORM'L
     C                   MOVE      '1'           GOTIT
     C                   END
     C                   END
      *
     C     GOTIT         IFEQ      '1'
KM   C                   MOVE      PRNO01        PSNME
KM   C                   MOVE      PRNO02        PSCTNM
KM   C                   MOVE      PRCD21        PSSTS
KM   C                   IF        PSTYPE <> 'R'
KM   C                   MOVE      'N'           PSTYPE
KM   C                   ENDIF
#4   C     VENQ          IFEQ      *BLANKS
#4   C                   MOVEL     IVNO22        VENQ
#4   C                   END
     C     MAN           IFEQ      *BLANKS                                      MANUFACTURER
     C     IVNO07        ORNE      IVNO7                                        SAME ITEM ?
   IZC*                  MOVE      IVNO22        MAN                            MANUFACTURER
IZ   C                   MOVE      IVNO93        MAN                            MANUFACTURER
     C                   END
#4   C     VENQ          IFEQ      *BLANKS
#4   C     IVNO07        ORNE      IVNO7
#4   C                   MOVE      IVNO22        VENQ
#4   C                   END
   HYC*    COST          IFEQ      0                                            RPLCMNT COST
   HYC*    COVR          ANDNE     'Y'                                          NO OVERRIDE
HY
HY   C                   EXSR      Rtv_Col_Cost
HY
HY   C                   if        colCst  = 0
HY IAC*                  if        cost    = 0 or                               RPLCMNT COST
HY IAC*                            (cost  <> 0 and
HY IAC*                             covr  <> 'Y' and
HY IAC*                             dovr  <> 'Y')
IA   C     COST          IFEQ      0                                            RPLCMNT COST
IA   C     COVR          ANDNE     'Y'                                          NO OVERRIDE
HY   C                   eval      covr    = ' '                                Cost Override
     C                   Z-ADD     PRAM13        COST                           RPLCMNT COST
     C     PRCD17        IFEQ      'Y'                                          NET RPLC COST
     C     PRCD17        OREQ      'T'                                          NET RPLC COST
KH   C                   if        ColCostZro <> 'Y'
     C                   MOVE      'Y'           COVR                           COST OVRRIDE
KH   C                   endif
     C                   END
     C     PRCKYH        CHAIN     PRFMPSH                            40        PRICE SHEET
     C     *IN40         IFEQ      '0'
      *
      * RETRIEVE HEADER FACTOR FROM FACTOR FILE
      * WHEN PRICING PURCHASE ORDERS IF REPLACEMENT COST WAS COMPUTED
      * FROM BASE PRICE OF MANUFACTURES LIST RETRIEVE FACTOR
     C                   MOVE      '  '          PRCD61                         SRC CODE
     C                   MOVE      'RC'          PRCD60                         PRC/COST TYP
     C     PRCFAC        CHAIN     PRFMPSF                            40        FACTOR FILE
      *
     C     PRCD61        IFEQ      'ML'                                         RPLCOST SOURCE
     C     PRCD17        IFNE      'Y'                                          NET RPLC COST
     C     PRCD17        ANDNE     'T'                                          NET RPLC COST
     C     LIST          IFEQ      0                                            MANUF LIST
     C                   Z-ADD     PRAM01        LIST
     C                   END
     C     DISC          IFEQ      *BLANKS                                      DISCOUNT
     C     PRPC08        IFEQ      *BLANKS                                      OVRRIDE FACTOR
     C                   MOVE      PRPC16        DISC                           HEADER FACTOR
     C                   ELSE
     C                   MOVE      'Y'           DOVR                           DISCOUNT OVRRID
     C                   MOVE      PRPC08        DISC                           OVRRIDE FACTOR
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
HY   C                   endif
HY   C                   if        (dovr   <> 'Y' and
HY   C                              covr   <> 'Y') or
HY   C                             (covr    = 'Y' and
HY   C                              cost    = 0)
HY   C                   if        colCst <> 0
IA   C                             and  qty <> oqty
IA   C                             and  qtyr = 0
IS   C                             or colCst <> 0
IS   C                             and ColCostChg = 'Y'
IS   C                             and  qtyr = 0
HY   C                   eval      covr    = ' '
HY   C                   eval      cost    = colCst
HY   C                   eval      list    = 0
HY   C                   eval      disc    = *blanks
HY   C                   endif
HY   C                   endif
HY
     C                   ELSE
     C     COST          IFEQ      *ZEROS
     C     COVR          ANDNE     'Y'                                          NO OVERRIDE
     C                   Z-ADD     IVAM34        COST
     C                   ENDIF
     C                   END
      *
     C     IVCD36        IFEQ      'Y'                                          EXTENDED DESC ?
     C                   MOVE      IVCD36        SVCD36            1            EXTENDED DESC ?
     C                   END
      * GET PRICING UOM FACTOR (ONLY IF THE ITEM HAS CHG'D)...
     C     IVNO07        IFNE      IVNO7                                        SAME ITEM ?
     C     PUOM          IFEQ      IVDN20                                       STOCKING ?
     C                   Z-ADD     1             PUOMSF
     C                   ELSE
     C     PUOM          IFEQ      IVDN41                                       REFERENCE ?
     C                   Z-ADD     IVQYZ9        PUOMSF
     C                   ELSE
      *
      * GET FACTOR FOR THE UOM.
     C                   Z-ADD     IVNO07        AUOMI#
     C                   MOVE      PUOM          AUOMOU
     C                   CALL      'POR0117'     PL0117                         UOM API
     C     AUOMOF        IFNE      *ZEROS
     C                   Z-ADD     AUOMOF        PUOMSF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
JL    * Special Pricing flag
JL   C                   if        fl67 = ' '
JL   C                   eval      fl67 = 'N'
JL   C                   endif
      * ------------------------
      * CONVERT THE CURRENT COST DOWN TO THE STOCKING LEVEL...
      * ------------------------
     C     PUOMSF        IFNE      0
     C     COST          DIV(H)    PUOMSF        FCTAMT                         GET STCK AMT
     C                   ELSE
     C                   CLEAR                   FCTAMT
     C                   ENDIF
¢R #9C*                  MOVEA     '0'           *IN(23)                        POSITION CURSOR
¢E #9C*                  CALL      'POR9959'
¢E #9C*                  PARM                    APNO01
¢E #9C*                  PARM                    FLAG              1
¢E #9C*    FLAG          IFEQ      'Y'
¢E #9C*    MAN           ANDEQ     *BLANKS                                      Mfg#
¢E #9C*                  MOVEA     '1'           *IN(23)                        POSITION CURSOR
¢E #9C*    ERRFLG        IFNE      'Y'                                          NO ERRORS
¢E #9C*                  MOVEL     CMS(1)        MSGFLD
¢E #9C*                  MOVE      'Y'           ERRFLG                         ERROR OCCURED
¢E #9C*                  END
¢E #9C*                  END
      * PLACE THE STOCKING COST INTO SFL FIELD...
     C                   Z-ADD(H)  FCTAMT        PUAMSF
      * ------------------------
      * CONVERT THE CURRENT LIST DOWN TO THE STOCKING LEVEL...
      * ------------------------
     C     PUOMSF        IFNE      0
     C     LIST          DIV(H)    PUOMSF        FCTAMT                         GET STCK AMT
     C                   ELSE
     C                   CLEAR                   FCTAMT
     C                   ENDIF
      * ---------------------------------------------------------------
      * PLACE THE STOCKING LIST SFL FIELD...
     C                   Z-ADD(H)  FCTAMT        PUAMSL
KM   C     SKIP_PSOVR    TAG
      *
      * ERROR CHECK FOR DNR ITEMS...
     C     BRKEY         CHAIN(N)  IVFMSBR                            46
     C     *IN46         IFEQ      '0'
     C     IMCD64        IFEQ      'Y'                                          DNR ITEM ?
     C     SFDNR         ANDNE     'Y'                                          NOT CHKD YET
     C                   MOVEA     '1'           *IN(81)                        PC / RI
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVE      'Y'           SFDNR                          NO MORE CHKG
     C                   MOVEL     UMS(24)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
     C                   END

¢i    * check item to see if it's slow or excess
¢i    * issue soft error message if it is
¢i   c     ivno07        ifne      0
#0   C     ChkNPI        andeq     'Y'                                          Check NPI by branch
¢5   C                   exsr      npisr

¢i ¢Wc*    sfesd         andne     'Y'
#2   C     PONO03        CHAIN     ARFMBCH
¢i   c                   z-add     ivno07        esno07            6 0
¢i   C                   call      'POR9949'
#2   C                   parm                    arno15
¢i   C                   parm                    esno07
¢i   c                   parm                    esclass           2
¢Z   C                   parm      ' '           skip_emempt       1
¢i   c     esclass       ifeq      'S '
¢i   C     esclass       oreq      'SF'
¢Y   C     esclass       oreq      'E '
¢Y   C     esclass       oreq      'EF'
¢2   C     npi_item      oreq      'Y'
¢i ¢wC*    esclass       oreq      'E '
¢i ¢WC*    esclass       oreq      'EF'
¢i ¢Wc*    pono02        ifle      74
¢i ¢WC*    sfesd         andne     'Y'                                          NOT CHKD YET
¢i ¢Wc*    pono02        orge      80
¢i ¢WC*    sfesd         andne     'Y'                                          NOT CHKD YET
¢w   C     slowaut       ifne      'Y'                                          NOT CHKD YET
¢i   C                   movea     '1'           *IN(81)                        POSITION CURSOR
¢i   C     ERRFLG        IFNE      'Y'                                          NO ERRORS
¢3   C     npi_item      ifeq      'Y'
¢3   C                   MOVEL     CMS(13)       MSGFLD
¢3   c                   else
¢i ¢WC*                  MOVE      'Y'           SFESD                          NO MORE CHKG
¢i   C                   MOVEL     CMS(2)        MSGFLD
¢3   c                   end
¢i   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
¢i   C                   END
¢X   C                   ELSE
¢X   C     SFESD         IFNE      'Y'
¢X   C                   MOVE      *ON           *IN81
¢X   C     ERRFLG        IFNE      'Y'                                          NO ERRORS
¢X   C                   MOVE      'Y'           SFESD                          NO MORE CHKG
¢X   C                   MOVEL     CMS(12)       MSGFLD
¢X   C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
¢X   C                   ENDIF
¢X   C                   ENDIF
¢w   C                   END
¢i ¢WC*                  END
¢i   C                   END
¢i   C                   END
      * ERROR CHECK FOR (PURCHASE BOOK ACCESS CODE *NE 'Y') ITEMS...
     C     IVCD32        IFNE      'Y'                                          NO ACCESS ?
     C     SFBOOK        ANDNE     'Y'                                          NOT CHKD YET
     C                   MOVEA     '1'           *IN(81)                        POSITION CURSOR
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVE      'Y'           SFBOOK                         NO MORE CHKG
     C                   MOVEL     UMS(25)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
      * DEFAULT/EDIT ETA DATE...
     C                   MOVE      'Y'           USELT             1            USE LEAD TM
     C     POCD01        IFNE      'F'
     C                   EXSR      ETA
     C                   END
      *
     C                   ELSE                                                   ITEM NOT FOUND
HL    * If item is deleted, warn user and protect all data...                   NOT FOUND
HL   C     DDELETED      IFEQ      'Y'                                          DELETED ITEM
HL   C                   MOVEA     '1'           *IN(21)
HL   C     IVNO7         CHAIN     ALLITEM                            46        ITEM MASTER
HL   C     *IN46         IFEQ      *OFF
HL   C                   MOVEL     IVDN01        DESC                           DESCRIPTION
HL   C                   MOVEL     IVDN01        ZZDN01                         DESCRIPTION
HL   C                   ENDIF
HL   C     SFDEL         IFNE      'Y'
HL   C                   MOVEA     '1'           *IN(81)
HL   C     ERRFLG        IFNE      'Y'
HL   C                   MOVE      'Y'           SFDEL
HL   C                   MOVEL     UMS(64)       MSGFLD
HL   C                   MOVE      'Y'           ERRFLG
HL   C                   ENDIF
HL   C                   ENDIF
HL   C                   ELSE                                                   NOT DELETED
     C                   MOVEA     '1'           *IN(81)                        HIGHLITE
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVEA     '1'           *IN(91)                        ERROR MESSAGE
     C                   MOVEL     UMS(18)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
HL   C                   ENDIF                                                  NOT DELETED
     C                   END
      *
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
      * IF THE ITEM CURRENTLY HAS TAGS ASSOCIATED WITH IT, AND IT
      * IS THE SAME ITEM (NOT CHANGED), AND THE QTY HAS CHANGED, THEN
      * DISPLAY THE TAG & HOLD SCREEN...
     C     QTY           SUB       OQTY          NWDIFF                         NEW QTY DIFF
     C     KEY           IFNE      0                                            TAGS ?
     C     IVNO07        ANDEQ     IVNO7
     C     NWDIFF        ANDNE     ODIFF                                        NEW VS OLD
     C                   Z-ADD     NWDIFF        ODIFF
      * IF THE USER SELECTED THE TAG OPTION, THEN BLANK OUT SO WE DONT
      * BRING THE TAG & HOLD DISPLAY UP TWICE...
     C     SEL           IFEQ      'T'
     C                   MOVE      ' '           SEL
     C                   END
     C                   EXSR      TAGHLD                                       TAG & HOLD
      * If the ship branch was changed execute the tag/hold routine
      * to determine if there are any tags to the new ship branch...
     C                   ELSE
     C     SHBCHG        IFEQ      *ON
     C     KEY           ANDNE     0
     C     SEL           ANDNE     'T'
     C                   MOVE      *ON           BRCHK             1
     C                   EXSR      TAGHLD                                       TAG & HOLD
     C                   ENDIF
     C                   END
     C     TAGFLG        IFEQ      'Y'
     C                   MOVE      ' '           TAGFLG
     C     SEL           IFEQ      'T'
     C                   MOVE      ' '           SEL
     C                   END
     C                   EXSR      TAGHLD                                       TAG & HOLD
     C                   END
      *
     C     SEL           IFNE      ' '
     C                   Z-ADD     IVNO07        WRKITM
     C     SEL           IFEQ      'T'
     C                   MOVE      '0'           *IN66                          PR/ND T-TAG
     C                   EXSR      TAGHLD                                       TAG & HOLD
     C                   ELSE
      *
     C     SEL           IFEQ      'L'                                          ITM LDGR
     C     POCD01        ANDNE     'D'
     C                   MOVE      PONO02        BRANCH            3            BRANCH
     C                   MOVE      IVNO07        NO7               6            OUR ITEM
     C                   CALL      'IVR0445'                                    ITEM LEDGER
     C                   PARM                    BRANCH
     C                   PARM                    NO7
     C                   ELSE
      *
     C     SEL           IFEQ      'D'                                          DEMAND
     C     POCD01        ANDNE     'D'
     C                   Z-ADD     PONO02        SHIPTO
     C                   CALL      'IMR0401'     DMDPRM                         ITEM HISTORY
     C                   ELSE
      *
     C     SEL           IFEQ      'S'                                          STOCK STATUS
     C                   Z-ADD     PONO02        SHIPTO
     C                   CALL      'IVR0420'     SSPRM
     C                   ELSE
      *
     C     SEL           IFEQ      'V'                                          VEND LEAD TM
     C                   MOVE      IVNO07        IVVLT7                         ITEM #
     C                   MOVE      APNO01        APVLT1                         VENDOR #
     C                   MOVE      PONO02        POVLT2                         SHIP TO BR #
     C                   CALL      'IMR0410'     VLTPRM
     C                   ELSE
      *
     C     SEL           IFEQ      'B'                                          LINE BUY ?
     C     POCD01        ANDNE     'D'
     C                   MOVE      PONO02        BRNO              3 0          BRANCH
     C                   CALL      'IMR0421'
     C                   PARM                    BRNO
     C                   PARM                    IVNO07
     C                   ELSE
      *
     C     SEL           IFEQ      'I'                                          BRANCH ITEM?
     C     POCD01        ANDNE     'D'
     C                   MOVE      PONO02        BRNO                           BRANCH
     C                   CALL      'IVR0450'
     C                   PARM                    BRNO
     C                   PARM                    IVNO07
     C                   ELSE
      *
     C     SEL           IFEQ      'U'                                          VALID UOMS ?
     C     QTYR          ANDEQ     0                                            NO RCPTS ?
     C                   Z-ADD     IVNO07        ITMWK
     C                   Z-ADD     QTY           QUAN
     C                   MOVE      UOM           UOMWK
     C                   Z-ADD     UOMSF         FACTO
     C                   MOVE      'P'           FRMAPP
     C                   EXSR      @CURSR
     C                   CALL      'IVR3450'     PL3450
     C     QUAN          IFNE      0
     C                   Z-ADD     QUAN          QTY
#4   C                   Z-ADD     QUAN          QTYO
     C                   MOVE      UOMWK         UOM
     C                   Z-ADD     FACTO         UOMSF
     C     UOMSF         MULT      QTY           UQYSF
     C                   ENDIF
     C                   ENDIF
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C                   MOVE      ' '           SEL                            SUBROUTINE
     C                   END
     C                   END
     C     ENDO          ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    NON STOCK                                               *
      *------------------------------------------------------------------------*
     C     NONSTK        BEGSR
     C                   MOVE      UOM           PUOM
     C                   MOVE      'N'           TYP                            NON STOCK ITEM
     C                   Z-ADD     0             IVNO07                         ITEM NUMBER
      * PREVENT DUPLICATE ENTRY OF NON-STOCK NUMBERS...
      * NON-STOCK NUMBER ALREADY ENTERED?
     C     I1            IFEQ      '/'
     C     NS            ANDNE     *BLANKS
     C                   Z-ADD     1             N                 3 0
     C     NS            LOOKUP    NSC(N)                                 41
     C     *IN41         IFEQ      '1'
     C                   MOVEA     '1'           *IN(81)                        RI,PC
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(34)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C     MSGFLD        CABNE     *BLANKS       ENDNS
     C                   END
     C                   ELSE
      * NOT A DUPLICATE NON-STOCK, STORE IN ARRAY FOR FUTURE CHECKING...
     C                   Z-ADD     1             N
     C     *BLANKS       LOOKUP    NSC(N)                                 41
     C     *IN41         IFEQ      '1'
     C                   MOVE      NS            NSC(N)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * NO OTHER ITEMS ALLOWED IF A LOT EXISTS ON THE P/O!
      *
     C     POCD42        IFEQ      'Y'
     C     ONELOT        ANDEQ     'Y'
     C                   MOVE      *ON           *IN81                          DSPATR(RI)
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   MOVEL     EMS(39)       MSGFLD
     C     MSGFLD        CABNE     *BLANKS       ENDNS
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     1             UOMSF                          DFLT FACTOR
     C                   Z-ADD     1             PUOMSF                         DFLT FACTOR
      * SEE IF NON STOCK ALREADY EXISTED ON P/O...
     C     ITM           LOOKUP    NSI                                    40
     C     *IN40         IFEQ      '1'
     C                   MOVE      'Y'           NSPREV
     C                   ELSE
     C                   MOVE      ' '           NSPREV
     C                   END
      *
      * SEE IF NON STOCK EXISTS ON A SALES ORDER, IF IT DOES, THEN DO
      * NOT CHECK THE QTY FOR A 'ZERO' ERROR, SINCE WE ARE GOING TO
      * DEFAULT THE QTY FROM THE SALES ORDER ANYWAY...
      * HOWEVER, IF THE QTY HAS ALREADY BEEN DEFAULTED, THEN EDIT THE
      * QTY IN CASE THE USER HAS CHANGED IT TO AN INVALID ENTRY...
      * ALSO, IF ITEM ALREADY EXISTED ON P/O, WE NEED TO CHECK QTY IN
      * CASE USER CHANGED IT...
     C     POCD42        IFEQ      'Y'                                          LOT PURCHASE
     C     ZZNO04        SETLL     OETOALA                                40
     C                   ELSE                                                   USE S/O FILES
     C     ZZNO04        SETLL     OELTOLY8                               40
     C                   ENDIF
     C     *IN40         IFEQ      '0'
     C     SEDIT         OREQ      'Y'
     C     NSPREV        OREQ      'Y'
      * SEE IF QTY IS IN ERROR...
   ¢CC*    QTY           IFLE      0                                            QTY ORDERED
¢C   C     QTY           IFEQ      0                                            QTY ORDERED
     C                   MOVEA     '1'           *IN(80)                        POSITION CURSOR
     C                   MOVEA     '1'           *IN(83)                        HIGHLITE
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVEL     UMS(22)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
     C                   END
      * NON STOCK SO BLANK OUT ANYTHING AFTER 12
     C                   MOVEL     ZZNO04        SAVE12           12
     C                   MOVE      *BLANKS       ZZNO04
     C                   MOVEL     SAVE12        ZZNO04
      *
      *  TEST FOR CHANGE IN NON-STOCK NUMBER
     C     NSITM         IFNE      NSITMX                                       SAME ITEM ?
     C     NSITMX        OREQ      *BLANKS
     C     POCD42        IFEQ      'Y'
     C     NSITMX        IFNE      *BLANK
     C                   CLEAR                   OECD72
     C                   ENDIF
     C                   ENDIF
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C                   Z-ADD     0             COST                           RPLCMNT COST
     C                   MOVE      *BLANKS       DISC                           DISCOUNT
     C                   Z-ADD     0             LIST                           MANUF LIST
     C                   MOVE      ' '           SEDIT
     C                   MOVE      ' '           SEDIT1
     C                   MOVE      ' '           SEDIT3
     C                   MOVE      ' '           SEDIT4
     C                   MOVE      ' '           SEDIT5
     C                   CLEAR                   SFORLN
     C                   CLEAR                   KEY
      *
      *  TEST FOR NON-STOCK IDENTIFIER ENTERED
     C     NSITM         IFNE      *BLANKS
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ZZDN01
     C                   END
     C                   MOVE      ' '           SYSASN                         SYSTEM ASSGN
     C                   END
      *
      *  TEST FOR SECTION NOT ENTERED
     C     SEC           IFEQ      *BLANKS                                      BLANK SEC. #
I0   C     I1            ANDNE     '*'
     C                   MOVEL     '/000'        ITM                            ASSIGN SEC #
     C                   MOVE      ' '           SYSASN                         SYSTEM ASSGN
     C                   END
      *  TEST FOR VALID SECTION NUMBER IF ENTERED
     C                   MOVE      ' '           SECFLG            1
     C     SEC           IFNE      '000'                                        SEC ENTERED    B1
     C     SEC           SETLL     IVFMPBT                                40    CNTR BOOK FILE  1
     C     *IN40         IFEQ      '0'                                          NOT FOUND      B2
     C                   MOVEA     '1'           *IN(81)                        HIGHLITE ERROR  2
     C                   MOVE      'Y'           SECFLG                                         2
     C     ERRFLG        IFNE      'Y'                                          ERROR OCCURE   B3
     C                   MOVEL     UMS(23)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED   3
     C                   END                                                                   E3
     C                   END                                                                   E2
     C                   END                                                                   E1
      *
      *  TEST FOR NON-STOCK NUMBER NOT ENTERED
     C     NSITM         IFEQ      *BLANKS                                      BLANK NS #
     C     SECFLG        ANDNE     'Y'                                          ERROR OCCURE    1
      *  GET NEXT NON-STOCK NUMBER FROM DATA AREA
     C     *LOCK         IN        NSITEM                                       GET DATA ARA
      *  ASSIGN NON-STOCK NUMBER FROM DATA AREA
     C                   MOVE      NSITMN        NSITM                          ASSIGN NS #
     C                   MOVE      NSITMN        NSI#              8 0
      *  NEXT NON-STOCK NUMBER TO USE
     C                   ADD       1             NSI#                           NEXT NS #
     C                   MOVE      NSI#          NSITMN
      *  PUT NEXT NON-STOCK NUMBER BACK IN DATA AREA
     C                   OUT       NSITEM                                       TO DATA AREA
      *  FLAG THAT NON-STOCK NUMBER WAS SYSTEM ASSIGNED
     C                   MOVE      'Y'           SYSASN                         SYSTEM ASSIGNED
     C                   END
      *
     C     SYSASN        IFEQ      'Y'                                          SYS ASSIGNED
      *
      * HAS ITEM BEEN EDITED ?
      *
     C     SEDIT1        IFNE      'Y'
     C                   MOVE      *ON           *IN81                          HIGHLITE ERROR  2
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      'Y'           SEDIT1                         EDITED
     C                   MOVEL     UMS(32)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED   3
     C                   ENDIF
     C                   ENDIF                                                                 E3
     C                   ENDIF                                                                 E3
      *
      * If this is a direct P/O, make sure the non-stock does not exist
      * on a non-direct transaction, and vice versa....
      *
     C                   MOVE      '2'           ACCESS
     C                   MOVEL     ITM           NSKEY
     C                   CALL      'OER2062'     PL2062
     C     POCD01        IFEQ      'D'                                          DIRECT P/O
     C     ONTRF         IFEQ      'Y'                                          ON TRANSFER
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(43)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   ENDIF
     C                   ENDIF
     C     ONSO          IFEQ      'N'                                          NON-DIR S/O
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(45)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   ENDIF
     C                   ENDIF
     C     ONSO          IFEQ      'V'                                          NON-DIR VOID
     C     SEDIT4        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(45)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   MOVE      'Y'           SEDIT4
     C                   ENDIF
     C                   ENDIF
     C     ONSO          IFEQ      'W'                                          DIRECT VOID
     C     SEDIT4        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     EMS(48)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   MOVE      'Y'           SEDIT4
     C                   ENDIF
     C                   ENDIF
     C                   ELSE                                                   NON-DIR P/O
     C     ONSO          IFEQ      'D'                                          DIRECT S/O
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(44)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   ENDIF
     C                   ENDIF
     C     ONSO          IFEQ      'W'                                          DIRECT VOID
     C     SEDIT4        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(44)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   MOVE      'Y'           SEDIT4
     C                   ENDIF
     C                   ENDIF
     C     ONSO          IFEQ      'V'                                          DIRECT VOID
     C     SEDIT4        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     EMS(48)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   MOVE      'Y'           SEDIT4
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
KW    * Nonstock not allowed
KW   C                   if        ovhfnd = 'Y'
KW   C                   eval      errflg = 'Y'
KW   C                   eval      *in81  = *on
KW   C                   if        msgfld = ' '
KW   C                   eval      msgfld = 'Nonstock item not allowed on PO +
KW   C                             with overhead item'
KW   C                   endif
KW   C                   endif
      *
     C                   MOVE      'N'           VALDTF
     C                   MOVE      'N'           VALDSO
     C                   MOVE      'N'           VALDCO
     C                   MOVE      'N'           VALDWO
     C     POCD01        IFEQ      'D'
     C                   MOVE      'N'           BRERR                          EDIT BRN
     C                   ELSE
     C                   MOVE      'Y'           BRERR
     C                   ENDIF
     C                   MOVEL     ZZNO04        NSKEY
     C     ZZNO04        CHAIN(N)  IVFTNSK                            40
     C     *IN40         IFEQ      *OFF
     C     ZZDN01        IFEQ      *BLANKS
     C                   MOVEL     IDN01         DESC                           DESCRIPTION
     C                   MOVEL     IDN01         ZZDN01                         DESCRIPTION
     C                   ENDIF
     C                   ELSE                                                   USER ASSIGNED
     C                   MOVE      *IN53         SVIN53            1
     C                   MOVEL     NSITM         NSITM9            9
     C                   MOVE      '0'           NSITM9
     C                   TESTN                   NSITM9               53        53 = LAST 8
     C     *IN53         IFEQ      '0'                                          NUMERIC
     C                   MOVE      *ON           *IN81                                      OR  2
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(52)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED   3
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      SVIN53        *IN53
     C                   ENDIF
      *
      *
      *  TEST SALES ORDER FOR NON-STOCK ITEM ORDERED
      *
     C     ZZNO04        CHAIN(N)  OELTOLY8                           40
     C     *IN40         IFEQ      *ON
     C     ZZNO04        CHAIN(N)  OELTOLV3                           40
     C                   ENDIF
     C     *IN40         IFEQ      '0'
     C     WRN           IFNE      'Y'
     C     OENO60        IFNE      *ZEROS
     C     OENO16        ANDEQ     PONO02
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(37)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   MOVE      'Y'           WRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'Y'           VALDSO
     C     OENO16        IFEQ      PONO02
     C     OECD01        OREQ      'D'
     C                   MOVE      'N'           BRERR
     C                   ENDIF
      *  MOVE UOM FROM SALES ORDER TO PO UOM
     C     UOM           IFEQ      *BLANKS
     C     NSITM         ORNE      NSITMX
     C                   MOVE      OEDN04        UOM                            UOM
     C                   MOVE      UOM           PUOM                           PUOM
     C                   ENDIF
     C                   ELSE
      *
      *  TEST WHETHER NON-STOCK ITEM ORDERED IS ON A PENDING ORDER
     C     ZZNO04        CHAIN(N)  OELTOL14                           40
     C     *IN40         IFEQ      '0'
     C     OECD04        ANDEQ     'N'
     C     SEDIT5        IFNE      'Y'
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(54)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   MOVE      'Y'           SEDIT5
     C                   ENDIF
     C                   ENDIF
     C     WRN           IFNE      'Y'
     C     OENO60        IFNE      *ZEROS
     C     OENO16        ANDEQ     PONO02
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(37)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   MOVE      'Y'           WRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'Y'           VALDSO
     C     OENO16        IFEQ      PONO02
     C     OECD01        OREQ      'D'
     C                   MOVE      'N'           BRERR
     C                   ENDIF
      *  MOVE UOM FROM SALES ORDER TO PO UOM
     C     UOM           IFEQ      *BLANKS
     C     NSITM         ORNE      NSITMX
     C                   MOVE      OEDN04        UOM                            UOM
     C                   MOVE      UOM           PUOM                           PUOM
     C                   ENDIF
     C                   ENDIF
      *
     C                   END
      *
   HE * TEST WORK ORDER FOR NON-STOCK ITEM ORDERED
   HEC*    ZZNO04        CHAIN(N)  WOTOL3                             40
   HEC*    *IN40         IFEQ      *OFF
   HEC*    WOCD05        ANDEQ     'Z'                                          COMPONENT
   HEC*                  MOVE      'Y'           VALDWO            1
   HEC*    WONO09        IFEQ      PONO02
   HEC*                  MOVE      'N'           BRERR
   HEC*                  ENDIF
   HEC*                  CLEAR                   DESC
   HEC*                  CLEAR                   ZZDN01
   HEC*                  MOVEL     IDN01         DESC                           DESCRIPTION
   HEC*                  MOVEL     IDN01         ZZDN01                         DESCRIPTION
   HEC*                  ENDIF
HE    * TEST OPEN WORK ORDER MOVE REQUESTS FOR NON-STOCK ITEM ORDERED
HE   C                   CLEAR                   ITEMNBR
HE   C                   MOVEL     ZZNO04        PRODNBR
HE   C                   MOVE      'MOV'         TRANTYP
JD   c                   eval      woboqty = 0
HE JDC*    WOKEY         CHAIN(N)  WKFTMOV                            40
HE JDC*    *IN40         IFEQ      *OFF
JD   c     woKey         setll     wkftmov
JD   c     woKey         reade     wkftmov
JD   c                   dow       not %eof
HE JDC*    TRANSNOMP     ANDNE     '0000000'
JD   C     TRANSNOMP     ifne      '0000000'
HE   C     TRANSNOMP     ANDNE     '       '
HE   C     BAKSTKQYMP    ANDGT     0
HE   C                   MOVE      'Y'           VALDWO            1
HE   C                   MOVE      'N'           BRERR
JD   c                   eval      woboqty = woboqty + bakstkqymp
HE   C                   ENDIF
JD   c     woKey         reade     wkftmov
JD   c                   enddo
      * SEE IF ON TRANSFER - KEEP CHECKING UNTIL BRANCH MATCHES
      *
     C     NSKEY         SETLL     IVFTTLK                                40
     C     *IN40         IFEQ      *ON
     C     *IN40         DOUEQ     *ON
     C     NSKEY         READE(N)  IVFTTLK                                40
     C     *IN40         IFEQ      *OFF
     C     IVCD70        ANDNE     'V'
     C                   MOVE      'Y'           VALDTF
     C     IVNO52        IFEQ      PONO02
     C                   MOVE      'N'           BRERR
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      * TEST CONTRACT ORDER FOR NON-STOCK ITEM ORDERED
      *
     C     OPNOAL        IFEQ      ' '
     C                   OPEN      OELTOALA
     C                   MOVE      'Y'           OPNOAL
     C                   ENDIF
     C     ZZNO04        CHAIN(N)  OETOALA                            40
     C     *IN40         IFEQ      '0'
     C     OECD72        IFEQ      'Y'
      *
     C                   Z-ADD     OEAM02        COST
      *
     C     PNO01         IFEQ      *ZERO
     C     PNO01         OREQ      PONO01
     C                   MOVE      'Y'           POCD42
     C                   MOVE      DSORLN        SFORLN
     C                   MOVE      'Y'           GETLOT            1
      *
      *  LOAD TAG ARRAY TO TAG THIS NONSTK BACK TO THE CONTRACT
      *
     C     POCD42        IFEQ      'Y'                                          LOT P/O
     C     OECD72        ANDEQ     'Y'                                          LOT ITEM
     C     KEY           IFEQ      *ZERO
     C     ARNO01        CHAIN     ARFMCUS                            41
     C     *IN41         IFEQ      *OFF
     C                   MOVEL     ARNM01        TCOM                           CUST NAME TO
     C                   MOVE      ' (A.G.)'     TCOM                           TAG COMMENTS
     C                   ELSE
     C                   CLEAR                   TCOM
     C                   ENDIF
     C                   Z-ADD     X             KEY
     C                   Z-ADD     QTY           TQTY
     C                   Z-ADD     ARNO01        TCUS
   HIC*                  Z-ADD     ONO01         TREF
   HIC*                  Z-ADD     *ZEROS        TTORG
HI   C                   MOVE      ONO01         TREF
HI   C                   MOVE      *ZEROS        TTORG
     C                   Z-ADD     *ZEROS        TTCTL
     C                   MOVE      'CO'          ORDTYP
     C                   MOVE      '3'           TTYP
     C                   Z-ADD     OENO31        TLIN
     C                   MOVE      TAGH          TH(X)                          TAG INFO
     C                   Z-ADD     X             KY(X)                          TAG KEY
     C                   MOVE      TREF          OREF                           S.O. TAG REF
     C                   MOVE      TLIN          OLIN                           S.O. TAG REF
     C                   MOVE      X             PL(X)                          S.O. TAG REF
     C                   MOVE      *BLANK        TTYP
     C                   MOVE      'T'           BLKTAG                         BLINK TAG & HOL
     C                   ENDIF
     C                   ENDIF
     C                   ELSE                                                   ON ANOTHER P/O
     C                   MOVE      *ON           *IN81
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     EMS(40)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'Y'           VALDCO
     C     OENO16        IFEQ      PONO02
     C     OECD55        OREQ      'Y'
     C                   MOVE      'N'           BRERR
     C                   ENDIF
      *  MOVE UOM FROM SALES ORDER TO PO UOM
     C     UOM           IFEQ      *BLANKS
     C     NSITM         ORNE      NSITMX
     C                   MOVE      OEDN04        UOM                            UOM
     C                   MOVE      UOM           PUOM                           PUOM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *  NON-STOCK ITEM NOT FOUND IN SALES ORDER OR TRANSFER
      *
     C     VALDSO        IFNE      'Y'                                          NOT FOUND
     C     VALDTF        ANDNE     'Y'                                          NOT FOUND
     C     VALDCO        ANDNE     'Y'                                          NOT FOUND
     C     VALDWO        ANDNE     'Y'                                          NOT FOUND
     C     SYSASN        ANDNE     'Y'                                          SYS ASSIGNED
     C     SEDIT3        IFNE      'Y'
IX    *   Calling POR0111 to check nonstock component exists in workorder compfile
IX   C                   MOVEL     ZZNO04        CMPPRDNOKY
IX   C                   Call      'POR0111'     PL0111
IY   C                   If        CUCOSTAMKY   >  0
IX   C                   eval(H)   Cost = CUCOSTAMKY
IY   C                   Endif
IX    *   Displaying Error Message if nonstock not found in workorder component file (PFLAG <>'Y)
IX   C                   If        PFLAG  <> 'Y'
     C                   MOVEA     '1'           *IN(81)                        HIGHLITE ERROR
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVEL     UMS(15)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   MOVE      'Y'           SEDIT3                         EDITED          3
     C                   END
IX   C                   Endif
     C                   END                                                                   E3
     C                   END
     C     UOM           IFEQ      *BLANKS
     C                   MOVE      'EA '         UOM                            DFLT UOM
     C                   MOVE      'EA '         PUOM                           DFLT UOM
     C                   ENDIF
      *
      * SHIP TO BRANCH IS NOT VALID
      *
     C     VALDSO        IFEQ      'Y'
     C     VALDTF        OREQ      'Y'
     C     VALDCO        OREQ      'Y'
     C     VALDWO        OREQ      'Y'
     C     BRERR         IFEQ      'Y'
     C     SVCD12        ANDNE     'Y'                                          REL 10+ P/O
     C                   MOVE      *ON           *IN81                          HIGHLITE ERROR
     C     ERRFLG        IFNE      'Y'                                          NO ERRORS
     C                   MOVEL     UMS(36)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     VALDSO        IFEQ      'Y'
      *
      * DEFAULT P/O QTY TO S/O ORD QTY IF DIRECT, OTHERWISE,
      * DEFAULT P/O QTY TO S/O BACKORDER QTY IF NOT DIRECT
     C     SEDIT         IFNE      'Y'
     C     ERRFLG        ANDNE     'Y'
     C     NSPREV        ANDNE     'Y'
     C                   Z-ADD     QTY           DFLTQ
     C     OECD16        IFEQ      'D'                                          DIR FIL ORD
     C                   Z-ADD     OEQY01        QTY                            ORD QTY
      *
      * On directs, if the non-stock is found on a salesorder, the
      * customer numbers must match between the S/O and P/O....
      *
     C     PONO13        IFNE      ANO01
     C                   MOVE      *ON           *IN81
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   MOVEL     UMS(51)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     OEQY02        QTY                            B/O QTY
     C                   END
#4   C                   Z-ADD     QTY           QTYO
     C     QTY           IFNE      DFLTQ
     C                   MOVEA     '1'           *IN(80)                        PC
     C                   MOVEA     '1'           *IN(83)                        RI
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      'Y'           SEDIT
     C                   MOVEL     UMS(33)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   END
     C                   END
     C                   END
     C                   ENDIF
      *
     C     VALDCO        IFEQ      'Y'
      *
      * DEFAULT P/O QTY TO C/O ORD QTY IF DIRECT, OTHERWISE,
      *
     C     SEDIT         IFNE      'Y'
     C     ERRFLG        ANDNE     'Y'
     C     NSPREV        ANDNE     'Y'
     C                   Z-ADD     QTY           DFLTQ
     C                   Z-ADD     OEQY17        QTY                            C/O ORD QTY
     C     QTY           IFNE      DFLTQ
     C                   MOVE      *ON           *IN80                          PC
     C                   MOVE      *ON           *IN83                          RI
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      'Y'           SEDIT
     C                   MOVEL     EMS(47)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * LOT QTY MUST BE 1 AND NO OTHER ITEMS ALLOWED!
      * PROTECT LOT ITEM - CANNOT BE CHANGED.
      *
     C     POCD42        IFEQ      'Y'
     C                   Z-ADD     1             QTY
     C     ONELOT        IFNE      'Y'
     C                   MOVE      'Y'           ONELOT            1
     C                   ELSE
     C                   MOVE      *ON           *IN81                          DSPATR(RI)
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     EMS(39)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     VALDWO        IFEQ      'Y'
      *
   HEC*                  MOVE      WODN10        UOM                            UOM
   HEC*                  MOVE      WODN09        PUOM                           PUOM
HE   C                   MOVE      UOMDNMP       UOM                            UOM
HE   C                   MOVE      UOMDNMP       PUOM                           PUOM
      *
      * DEFAULT W/O QTY TO P/O QUANTITY
      *
     C     SEDIT         IFNE      'Y'
     C     ERRFLG        IFNE      'Y'
     C                   Z-ADD     QTY           DFLTQ
   HEC*                  Z-ADD     WOQY02        QTY                            B/O QTY
HE JDC*                  eval      qty = hdChkDecQTY(bakstkqymp)                B/O QTY
JD   c                   eval      qty = hdChkDecQty(woboqty)                   B/O QTY
     C     QTY           IFNE      DFLTQ
     C                   MOVEA     '1'           *IN(80)                        PC
     C                   MOVEA     '1'           *IN(83)                        RI
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      'Y'           SEDIT
     C                   MOVEL     UMS(33)       MSGFLD
     C                   MOVE      'Y'           ERRFLG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *
      * VALIDATE NON-STOCK UOM AGAINST UOM MASTER TABLE.
     C                   MOVE      'IV40'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     UOM           TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *ON
     C     UOM           OREQ      '*'
     C                   MOVE      *ON           *IN01
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      'Y'           ERRFLG
     C                   MOVEL     UMS(53)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      *  TEST FOR NON-STOCK NUMBER ON PREVIOUS P.O.
     C     ITM           SETLL     POFTOL4                                40    PREV. PO
     C     *IN40         IFEQ      '1'                                          P.O. FOUND
     C     NSPREV        ANDNE     'Y'
      *  NON-STOCK ITEM FOUND ON PREVIOUS P.O.
     C                   MOVEA     '1'           *IN(81)                        HIGHLITE ERROR
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVEL     UMS(16)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
      *
      *
      *
     C     ZZDN01        IFEQ      *BLANKS                                      DESCRIPTION
     C                   MOVEA     '1'           *IN(82)                        HIGHLITE
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVEL     UMS(20)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
      *
     C     QTYR          IFNE      0                                            QTY RECEIVED
     C     QTY           IFNE      OQTY                                         ORIGINAL QTY ?
     C     QTY           IFLT      QTYR                                         QTY ORDERED
     C                   Z-ADD     OQTY          QTY
#4   C                   Z-ADD     OQTY          QTYO
     C                   MOVEA     '1'           *IN(83)                        HIGHLITE ERROR
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVEL     UMS(21)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
     C                   END
     C                   END
     C                   END
      *
      * IF ITEM ON OPEN ASN IN WM SYSTEM,
      * AND QTY IS INCREASED, ERROR
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     ONASNF        ANDEQ     'Y'
     C     QTY           ANDLT     OQTY
     C     WHMBR         OREQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     ONASNF        ANDEQ     '0'
     C     QTY           ANDLT     OQTY
     C                   MOVE      *ON           *IN83
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
     C                   MOVEL     EMS(54)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   ENDIF
     C                   ENDIF
      *
      * DEFAULT/EDIT ETA DATE...
     C                   MOVE      ' '           USELT             1            DONT USE LT
     C     POCD01        IFNE      'F'
     C                   EXSR      ETA
     C                   END
      *
     C     ERRFLG        IFNE      'Y'                                          NO ERROR
      * IF THE ITEM CURRENTLY HAS TAGS ASSOCIATED WITH IT, AND IT
      * IS THE SAME ITEM (NOT CHANGED), AND THE QTY HAS CHANGED, THEN
      * DISPLAY THE TAG & HOLD SCREEN...
     C     QTY           SUB       OQTY          NWDIFF                         NEW QTY DIFF
     C     KEY           IFNE      0                                            TAGS ?
     C     NSITM         ANDEQ     NSITMX
     C     SEC           ANDEQ     SECX
     C     NWDIFF        ANDNE     ODIFF                                        NEW VS OLD
     C                   Z-ADD     NWDIFF        ODIFF
      * IF THE USER SELECTED THE TAG OPTION, THEN BLANK OUT SO WE DONT
      * BRING THE TAG & HOLD DISPLAY UP TWICE...
     C     SEL           IFEQ      'T'
     C                   MOVE      ' '           SEL
     C                   END
     C                   EXSR      TAGHLD                                       TAG & HOLD
     C                   END
     C     SEL           IFNE      ' '                                          SELECT--TAGHOLD
HB   C                   Clear                   Tqtyf
     C     SEL           IFEQ      'T'                                          SELECT--TAGH
     C                   MOVE      '1'           *IN66                          PR/ND T-TAG
     C                   EXSR      TAGHLD                                       TAG & HOLD
     C     KEY           IFNE      *ZEROS
     C     RRN           OCCUR     SAVDS
     C                   Z-ADD     KEY           DKEY
     C                   MOVE      ' '           DSEL
     C                   END
     C                   END
     C                   MOVE      ' '           SEL
     C                   MOVEA     '0'           *IN(55)
     C                   END
     C                   END
      * CALCULATE QUANTITY RECEIVED TO DATE AT PURCHASING UOM...
     C     UOMSF         IFNE      *ZEROS
     C     QTYR          DIV       UOMSF         QTYR@P                         RCV @ PCHSNG
     C                   ELSE
     C                   Z-ADD     QTYR          QTYR@P
     C                   ENDIF
      * DONT ALLOW QTY TO BE LESS THAN RECEIVED QTY...
KT    * only load message is user selected to go to tag & hold screen
   :AC*    MSGFLD        IFEQ      *BLANKS                                      NO ERROR
KT :AC*    SEL           ANDEQ     'T'
   :AC*    QTY           IFLT      QTYR@P
   :AC*    WRNR@P        ANDEQ     *BLANKS
      *
      * IF REC QTY GT STK P/O QTY, ALLOW TO CHANGE THE P/O QTY.
   :AC*                  MOVE      *ON           *IN93                          RI,PC
   :AC*                  MOVE      'Y'           ALWQCH
   :AC*                  MOVE      'Y'           WRNR@P            1
   :AC*                  MOVEL     EMS(22)       MSGFLD
   :AC*                  ENDIF
   :AC*                  ENDIF
JL    * Special Pricing flag
JL   C                   if        fl67 = ' '
JL   C                   eval      fl67 = 'N'
JL   C                   endif
      * FOR NON STOCKS, SINCE ALL QTY'S ARE AT STOCKING LEVEL, PLACE
      * THE CURRENT QTY IN THE "FACTORED" QTY FIELD WHICH IS NOW USED
      * TO EXTEND PO TOTALS...
     C                   Z-ADD     QTY           UQYSF
#4   C                   Z-ADD     QTY           QTYO
     C                   Z-ADD     1             UOMSF
¢P    *
¢P    * DO NOT ALLOW NON-STOCK ITEMS
¢P   C                   MOVE      'Y'           ERRFLG
¢P   C                   MOVE      *ON           *IN81
¢P   C                   MOVEL     CMS(06)       MSGFLD
     C     ENDNS         ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    LOT DETAIL                                              *
      *------------------------------------------------------------------------*
     C     LOTDTL        BEGSR
      *
     C                   MOVE      'N'           LOTFLG                         LOT FLAG
     C     TOAD1         IFEQ      *BLANK
     C                   MOVE      'Y'           TOAD1             1
     C                   OPEN      OELTOAD1
     C                   ENDIF
     C     TOAD          IFEQ      *BLANK
     C                   OPEN      OELTOAD2
     C                   MOVE      'Y'           TOAD              1
     C                   ENDIF
      *
     C     OASKY2        CHAIN     OEFTOAD                            41
     C     *IN41         IFEQ      *ON
     C                   CLEAR                   POCD42
     C                   ENDIF
     C     *IN41         DOWEQ     *OFF
     C                   CLEAR                   KEY                            TAG & HOLD KEY
     C                   CLEAR                   LIST                           LIST
     C                   CLEAR                   DISC                           DISC PERCENT
     C                   CLEAR                   DOVR                           DISC OVRRIDE
     C                   CLEAR                   COST                           UNIT COST
     C                   CLEAR                   COVR                           COST OVRRIDE
     C                   CLEAR                   SEL                            SELECT FIELD
     C                   CLEAR                   MAN                            MANUFACTURER
     C                   CLEAR                   BLKTAG                         TAG & HOLD
     C                   CLEAR                   SYSASN                         SYSTEM ASSIGNED
     C                   CLEAR                   NSITMX                         NONSTK ITEM#
     C                   CLEAR                   SEDIT                          NONSTK EDIT FLAG
     C                   CLEAR                   SEDIT1                           "    "     "
     C                   CLEAR                   SEDIT3                           "    "     "
     C                   CLEAR                   SEDIT4                           "    "     "
     C                   CLEAR                   SEDIT5                           "    "     "
     C                   CLEAR                   SECX                           SECTION
     C                   CLEAR                   SFBOOK                         PURCH BOOK WARN
     C                   CLEAR                   SFDNR                          DNR WARNING
¢I   C                   CLEAR                   SFESD                          ESD WARNING
¢8   C                   CLEAR                   SFORGPROD
¢9   C                   CLEAR                   SFSELPRC
¢9   C                   CLEAR                   SFSELCST
HL   C                   CLEAR                   SFDEL                          DNR WARNING
     C                   CLEAR                   ETASO                          ETA DATE
      *
      * STOCKED ITEM
     C                   CLEAR                   ZZNO04
     C                   CLEAR                   ZZDN01
     C     OECD85        IFEQ      'I'                                          STOCK ITM
     C     OECD85        OREQ      'P'                                          STOCK ITM
     C     ADNO07        CHAIN     IVFITEM                            44
     C     *IN44         IFEQ      *OFF
     C                   Z-ADD     ADNO07        IVNO7
     C                   MOVEL     IVDN01        ZZDN01
     C     OECD85        IFEQ      'I'                                          ITEM#
   ¢PC*                  MOVEL     ADNO07        ZZNO04
¢P   C                   MOVEL     IVNO04        ZZNO04
     C                   ELSE                                                   PRODUCT#
     C                   MOVEL     IVNO04        ZZNO04
     C                   ENDIF
     C                   ENDIF                                                  EIF 44
      *
      * NONSTOCK ITEM/COMMENT
     C                   ELSE
     C                   MOVEL     OEDN12        ZZNO04                         NSTK#
     C     OECD85        IFEQ      'N'                                          NONSTOCK
     C     ZZNO04        CHAIN(N)  IVFTNSK                            44
     C     *IN44         IFEQ      *OFF
     C                   MOVEL     IDN01         ZZDN01
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     OEDN13        ZZDN01                         NSTK DESCR
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'D'           TYP                            EXTENDED DESC
     C                   Z-ADD     OEQY18        QTY                            QTY ORDERED
     C                   Z-ADD     OEQY18        OQTY                           QTY ORDERED
     C                   MOVE      ADDN04        UOM                            ORDERED UOM
     C                   MOVE      ADDN04        PUOM                           PRICING UOM
     C                   Z-ADD     ADNO56        CTRL
     C                   MOVE      ZZNO04        PRT                            SAVE ZZNO04
     C                   MOVE      ZZNO04        SVNO04
     C                   MOVEL     ZZNO04        PROD
     C                   MOVEL     ZZDN01        DESC
     C                   ADD       1             RRN
     C                   MOVE      *ON           *IN21                          PROTECT
      *
      * IF ITEM ON OPEN ASN IN WM SYSTEM, PROTECT PROD#.
      * CANNOT DELETE ITEM.
     C                   MOVE      *OFF          *IN54
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     ONASNF        IFEQ      'Y'
     C     ONASNF        OREQ      '0'
     C                   MOVE      *ON           *IN54
     C                   END
     C                   END
¢8    * Check to see if this is an original line
¢8    * If so, then the item needs to be protected if po sent to vendor
¢8   C                   MOVE      *OFF          *IN28
#5 :AC*                  IF        ediSolution <> 'SPS'
¢8 :AC*                  IF        SFORGPROD <> *BLANKS
¢8 :AC*                  IF        SentToVendor = 'Y'
:A   C                   IF        SFORGPROD <> *BLANKS and
:A   C                             SentToVendor = 'Y'
¢8   C                   MOVE      *ON           *IN28
¢8   C                   ENDIF
¢8 :AC*                  ENDIF
#5 :AC*                  ENDIF
      *
     C     ITMSIZ        IFEQ      400
:A   C                   IF        SFORLN > 0
:A   C                   EVAL      POLine = %editc(SFORLN:'X')
:A   C                   ELSE
:A   C                   EVAL      PoLine = *blanks
:A   C                   ENDIF
     C                   WRITE     POS0120E                                     ENTRY S/F
     C                   ELSE
     C                   WRITE     POS0120N                                     ENTRY S/F DR
     C                   ENDIF
     C                   MOVE      *OFF          *IN21                          PROTECT
¢8   C                   MOVE      *OFF          *IN28
     C     OASKY2        READE     OEFTOAD                                41
     C                   ENDDO
      *
     C     ENDLOT        ENDSR
¢5    *------------------------------------------------------------------------*
¢5    *  SUBROUTINE    NON-PERFORMING INVENTORY CHECK                          *
¢5    *------------------------------------------------------------------------*
¢5   C     NPISR         BEGSR
¢5    *
¢5    *  Check if Non performing inventory
¢5    *
¢5   C                   eval      npi_item = 'N'
¢5 ¢6C*                  move      ivno07        ITMCHAR

#3         reset toCompany;
#3         exec sql
#3         select arno15
#3          into :toCompany
#3         from ARPMBCH
#3         where arno16 = :PONO02;

¢5    *
¢5 ¢6C*    ITMCHAR       setll     CL_ITMMSTR
¢5 ¢6C*    ITMCHAR       reade     CL_ITMMSTR                             19
¢6   C     IVNO07        setll     IVLCNPI1
¢6   C     IVNO07        reade     IVLCNPI1                               19
¢5   C     *IN19         DOWEQ     *OFF
¢5 ¢6C*                  move      fields09      BR#
¢6   C                   move      np_ivno10     BR#
¢5   C     MSBRKEY2      CHAIN     MSBR2
¢5   C                   IF        %FOUND
¢5   C                             and I_ivqy23 > 0

#3        reset checkCompany;
#3        exec sql
#3        select arno15
#3         into :checkCompany
#3        from ARPMBCH
#3        where arno16 = :np_IVNO10;

#3                if checkCompany = toCompany;
¢5   C                   eval      NPI_ITEM = 'Y'
¢5   C                   LEAVE
#3                endif;
¢5   C                   endif
¢5 ¢6C*    ITMCHAR       reade     CL_ITMMSTR                             19
¢6   C     IVNO07        reade     IVLCNPI1                               19
¢5   C                   enddo
¢5    *
¢5   C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    ETA DATE DEFAULTING & EDITING                           *
      *------------------------------------------------------------------------*
     C     ETA           BEGSR
     C                   MOVE      ' '           NODIFF            1
      * PROCESS ORIGINAL ETA DATE
      * IF THE PRODUCT NUMBER HAS BEEN CHANGED, OR
      * IF THE ETA DATE DEFAULT CODE HAS BEEN CHANGED ON THE HEADER, OR
      * IF THE ETA DFLT CODE = L, & SHIP TO BRANCH WAS CHGD ON HDR, OR
      * IF SFL ETA DATE IS BLANK (ZERO), THEN MOVE THE HEADER ETA DATE
      * OR A CALCULATED ETA DATA (USING LEAD TIMES) INTO THE DATA
      * STRUCTURE ETA DATE FIELD... HOWEVER, DONT USE LEAD TIMES WHEN
      * COMING FROM THE NON STOCK SUBROUTINE (NO LEAD TIMES EXIST)...
     C     DIFF          IFEQ      'Y'                                          DIFF DEFAULT
     C     ETASO         OREQ      *ZEROS                                       NO ETA DATE
     C     IVNO07        ORNE      IVNO7                                        DIFF STKITM?
     C     NSITM         ORNE      NSITMX                                       DIFF NS ITM?
     C     NSITMX        ANDNE     *BLANKS                                      NOT NEW N/S
     C     POCD41        IFEQ      'H'                                          USE HEADER
     C                   MOVE      ETAOH         ETASO
     C                   MOVE      POCC03        POCC13                         ORIG ETA LINE
     C                   MOVE      ETAOH         SAVSO
     C                   MOVE      POCC03        SVCC13                         SAVE ORIG ETA LINE
     C                   ELSE                                                   USE LEAD TM
      *
     C     USELT         IFEQ      'Y'
     C     LTKEY         CHAIN     POFTLT                             47
     C     *IN47         IFEQ      '0'
      * CALCULATE ETA DATE BY ADDING AVG LEAD TIME TO CURRENT DATE...
     C                   MOVE      '5'           ZZFUNC
     C                   Z-ADD     UDATE         ZZDATE
     C                   Z-ADD     PODY20        ZZDAYS                         AVG LEAD TM
     C                   CALL      'UDR'         UDRPRM
     C                   Z-ADD     ZZDATE        ETASO
     C                   Z-ADD     ZZDATE        SAVSO
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETASO         PDATE6                         ORIG ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACEN        POCC13                         ORIG ETA LINE CEN
     C                   MOVE      POCC13        SVCC13                         ORIG ETA LINE CEN
      *
     C                   ELSE
      * IF NO AVG LEAD TIME, PLACE HEADER DATE IN LINE ITEM ETA DATE...
     C                   MOVE      ETAOH         ETASO
     C                   MOVE      POCC03        POCC13                         ORIG ETA LINE CEN
     C                   MOVE      ETAOH         SAVSO
     C                   MOVE      POCC03        SVCC13                         ORIG ETA LINE CEN
     C                   END
      *
     C                   ELSE
      * IF THIS IS A NON STOCK,PLACE HEADER DATE IN LINE ITEM ETA DATE.
     C                   MOVE      ETAOH         ETASO
     C                   MOVE      POCC03        POCC13                         ORIG ETA LINE CEN
     C                   MOVE      ETAOH         SAVSO
     C                   MOVE      POCC03        SVCC13                         ORIG ETA LINE CEN
     C                   END
     C                   END
      *
     C                   ELSE
      * SET FLAG THAT INDICATES A DIFFERENCE IN ETA CODE, PRODUCT #, OR
      * BRANCH NUMBER DID NOT CAUSE THE LINE ITEM ORIG ETA DATE TO CHG.
     C                   MOVE      'Y'           NODIFF
      * IF SFL ETA DATE IS NOT ZERO, THEN SEE IF THE HEADER ETA DATE
      * WAS CHANGED BY THE USER... IF IT WAS, THEN CHANGE ALL ITEMS
      * WHOSE DATES WERE EQUAL TO THE "OLD" ETA DATE, TO NOW BE EQUAL
      * TO THE "NEW" ETA DATE... ALSO CHANGE THE CORRESPONDING REVISED
      * ETA DATE TO BE THE SAME VALUE AS THE "NEW" ETA DATE...
     C     ETAOH         IFNE      SAVOH                                        CHANGED ?
     C     ETASO         ANDEQ     SAVOH                                        SAME AS OLD?
      * ONLY OVERLAY REVISED ETA LINE DATE W/ORIGINAL HEADER DATE IF
      * THE REVISED HEADER HAS NOT BEEN CHANGED, WHICH WOULD MEAN THAT
      * THE REVISED ETA LINE DATE IS ABOUT TO BE CHANGED TO EQUAL THE
      * NEW REVISED HEADER VALUE. ALSO WE CANNOT OVERLAY THE REVISED
      * ETA LINE DATE UNLESS IT'S CURRENT DATE IS EQUAL TO THAT OF THE
      * CORRESPONDING ORIGINAL ETA LINE DATE...
     C     ETARH         IFEQ      SAVRH                                        RVSDH UNCHGD
     C     ETASR         ANDEQ     ETASO                                        RVSDL=ORIGL
     C                   MOVE      ETAOH         ETASR                          LOAD REVISED
     C                   MOVE      POCC03        POCC15                         ETA RVSD LINE CEN
     C                   END
     C                   MOVE      ETAOH         ETASO                          LOAD ORIGNAL
     C                   MOVE      POCC03        POCC13                         ETA ORIG LINE CEN
      * IF CHG IN DATE, RESET RDSPLY INDICATOR...
     C                   MOVE      '0'           *IN55
     C                   END
     C                   END
      * IF THE ORIGINAL ETA HEADER DATE HAS BEEN CHANGED, THEN OVERLAY
      * THE REVISED ETA HEADER DATE WITH THE ORIGINAL ETA HEADER DATE.
      * BUT ONLY DO THIS IF THE REVISED ETA HEADER DATE WAS NOT JUST
      * CHANGED BY THE USER, AND IF THE REVISED ETA HEADER DATE WAS
      * THE SAME AS THE ORIGIAL ETA HEADER DATA BEFORE IT WAS CHANGED..
     C     ETAOH         IFNE      SAVOH                                        ORIG CHG'D
     C     ETARH         ANDEQ     SAVRH                                        RVSD UNCHGD
     C     ETARH         ANDEQ     SAVOH                                        RVSD=PRVORIG
     C                   MOVE      ETAOH         ETARH
     C                   MOVE      POCC03        POCC14
     C                   END
      *
      * VALIDATE THE LINE ITEM ETA DATE...
     C                   Z-ADD     ETASO         PDATE
     C                   Z-ADD     *ZEROS        PJULI
     C                   CALL      'GPR0100'     EDTDAT                         EDIT FOR
     C     PJULI         IFEQ      0                                            VALID ETA DT
     C                   MOVE      '1'           *IN89                          RI PC
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(26)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
      *
     C                   ELSE
      * NOW THAT WE HAVE A GOOD DATE, MAKE SURE DATE IS NOT LESS THAN
      * THE CURRENT DATE, BUT ONLY IF DATE HAS BEEN CHANGED...
     C     ETASO         IFNE      SAVSO
     C                   MOVE      ETASO         SOYEAR            2 0          YEAR WKFLD
     C                   MOVE      'D'           ZZFUNC
     C                   Z-ADD     ETASO         ZZDATE                         HEADER ETA
     C                   Z-ADD     UDATE         ZZDIFF                         CURRENT DATE
     C                   CALL      'UDR'         UDRPRM
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETASO         PDATE6                         ORIG ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACYR        SOCCYR                         CEN/YEAR
     C     ZZDAYS        IFLT      0                                            LT UDATE "CURRENT YR
     C     SOCCYR        ORLT      *YEAR                                        OLDER THAN 1 YEAR ?
     C                   MOVE      '1'           *IN89                          RI PC
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     UMS(27)       MSGFLD
     C                   ENDIF
     C                   MOVE      SAVSO         ETASO                          RESTORE ORIG
     C                   MOVE      SVCC13        POCC13                         RESTORE ORIG ETA CEN
     C                   ELSE
      * IF THE ORIGINAL ETA LINE DATE HAS BEEN CHANGED, THEN OVERLAY
      * THE REVISED ETA LINE DATE WITH THE ORIGINAL ETA LINE DATE.
      * BUT ONLY DO THIS IF THE REVISED ETA LINE DATE IS EQUAL TO THE
      * CORRESPONDING ORIGINAL ETA LINE DATE, AND IF ORIGINAL DATE HAS
      * BEEN PREVIOUSLY SAVED (I.E. SAVSO NOT ZERO, 1ST TIME THRU)...
     C     NODIFF        IFEQ      'Y'
     C     ETASO         ANDNE     SAVSO
     C     ETASR         ANDEQ     SAVSO
     C     SAVSO         ANDNE     0
      * IN ADDITION, WE CANNOT OVERLAY THE REVISED ETA LINE IF THE
      * REVISED ETA HEADER HAS BEEN CHANGED, AND THE REVISED LINE ETA
      * DATE IS THE SAME AS THE PREVIOUS REVISED ETA HEADER...
     C     ETARH         IFEQ      SAVRH                                        NO RVHDR CHG
     C     ETARH         ORNE      SAVRH                                        RVHDR CHG,
     C     ETASR         ANDNE     SAVRH                                        BUT NOT=PRV
     C                   MOVE      ETASO         ETASR
     C                   MOVE      POCC13        POCC15                         RVSD ETA CEN
     C                   END
     C                   END
     C                   MOVE      ETASO         SAVSO                          SAVE CHANGE
     C                   MOVE      POCC13        SVCC13                         ORIG ETA CEN
     C                   END
     C                   END
     C                   END
      * REVISED ETA DATE
      * IF THE PRODUCT NUMBER HAS BEEN CHANGED, OR
      * IF THE ETA DATE DEFAULT CODE HAS BEEN CHANGED ON THE HEADER, OR
      * IF THE ETA DFLT CODE = L, & SHIP TO BRANCH WAS CHGD ON HDR, OR
      * IF SFL ETA DATE IS BLANK (ZERO), THEN MOVE THE HEADER ETA DATE
      * OR A CALCULATED ETA DATA (USING LEAD TIMES) INTO THE DATA
      * STRUCTURE ETA DATE FIELD... HOWEVER, DONT USE LEAD TIMES WHEN
      * COMING FROM THE NON STOCK SUBROUTINE (NO LEAD TIMES EXIST)...
     C     DIFF          IFEQ      'Y'                                          DIFF DEFAULT
     C     ETASR         OREQ      *ZEROS                                       NO ETA DATE
     C     IVNO07        ORNE      IVNO7                                        DIFF STKITM?
     C     NSITM         ORNE      NSITMX                                       DIFF NS ITM?
     C     NSITMX        ANDNE     *BLANKS                                      NOT NEW N/S
     C     POCD41        IFEQ      'H'                                          USE HEADER
     C                   MOVE      ETARH         ETASR
     C                   MOVE      POCC14        POCC15                         RVSD ETA CEN
     C                   MOVE      ETARH         SAVSR
     C                   MOVE      POCC14        SVCC15                         RVSD ETA CEN
     C                   ELSE                                                   USE LEAD TM
      *
     C     USELT         IFEQ      'Y'
     C     LTKEY         CHAIN     POFTLT                             47
     C     *IN47         IFEQ      '0'
      * CALCULATE ETA DATE BY ADDING AVG LEAD TIME TO CURRENT DATE...
     C                   MOVE      '5'           ZZFUNC
     C                   Z-ADD     UDATE         ZZDATE
     C                   Z-ADD     PODY20        ZZDAYS                         AVG LEAD TM
     C                   CALL      'UDR'         UDRPRM
     C                   Z-ADD     ZZDATE        ETASR
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETASR         PDATE6                         RVSD ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACEN        POCC15                         RVSD ETA LINE CEN
     C                   MOVE      PDACEN        SVCC15                         RVSD ETA LINE CEN
     C                   Z-ADD     ZZDATE        SAVSR
      *
     C                   ELSE
      * IF NO AVG LEAD TIME, PLACE HEADER DATE IN LINE ITEM ETA DATE...
     C                   MOVE      ETARH         ETASR
     C                   MOVE      POCC14        POCC15                         RVSD ETA LINE CEN
     C                   MOVE      ETARH         SAVSR
     C                   MOVE      POCC14        SVCC15                         RVSD ETA LINE CEN
     C                   END
      *
     C                   ELSE
      * IF THIS IS A NON STOCK,PLACE HEADER DATE IN LINE ITEM ETA DATE.
     C                   MOVE      ETARH         ETASR
     C                   MOVE      POCC14        POCC15                         RVSD ETA LINE CEN
     C                   MOVE      ETARH         SAVSR
     C                   MOVE      POCC14        SVCC15                         RVSD ETA LINE CEN
     C                   END
     C                   END
      *
     C                   ELSE
      * IF SFL ETA DATE IS NOT ZERO, THEN SEE IF THE HEADER ETA DATE
      * WAS CHANGED BY THE USER... IF IT WAS, THEN CHANGE ALL ITEMS
      * WHOSE DATES WERE EQUAL TO THE "OLD" ETA DATE, TO NOW BE EQUAL
      * TO THE "NEW" ETA DATE...
     C     ETARH         IFNE      SAVRH                                        CHANGED ?
     C     ETASR         ANDEQ     SAVRH                                        SAME AS OLD?
     C                   MOVE      ETARH         ETASR                          LOAD REVISED
     C                   MOVE      POCC14        POCC15                         RVSD ETA LINE CEN
      * IF CHG IN DATE, RESET RDSPLY INDICATOR...
     C                   MOVE      '0'           *IN55
     C                   END
     C                   END
      *
      * VALIDATE THE LINE ITEM ETA DATE...
     C                   Z-ADD     ETASR         PDATE
     C                   Z-ADD     *ZEROS        PJULI
     C                   CALL      'GPR0100'     EDTDAT                         EDIT FOR
     C     PJULI         IFEQ      0                                            VALID ETA DT
     C                   MOVE      '1'           *IN99                          RI PC
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(29)       MSGFLD
     C                   ENDIF
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
      *
     C                   ELSE
      * NOW THAT WE HAVE A GOOD DATE, MAKE SURE DATE IS NOT LESS THAN
      * THE CURRENT DATE, BUT ONLY IF DATE HAS BEEN CHANGED...
     C     ETASR         IFNE      SAVSR
     C                   MOVE      ETASR         SRYEAR            2 0          YEAR WKFLD
     C                   MOVE      'D'           ZZFUNC
     C                   Z-ADD     ETASR         ZZDATE                         HEADER ETA
     C                   Z-ADD     UDATE         ZZDIFF                         CURRENT DATE
     C                   CALL      'UDR'         UDRPRM
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETASR         PDATE6                         RVSD ETA LINE DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACYR        SRCCYR                         CEN/YEAR WRKFLDEN
     C     ZZDAYS        IFLT      0                                            LT UDATE "CURRENT YR
     C     SRCCYR        ORLT      *YEAR                                        OLDER THAN 1 YEAR ?
     C                   MOVE      '1'           *IN99                          RI PC
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(30)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   MOVE      SAVSR         ETASR                          RESTORE ORIG
     C                   MOVE      SVCC15        POCC15                         RVSD ETA LINE CEN
     C                   ELSE
     C                   MOVE      ETASR         SAVSR                          SAVE CHANGE
     C                   MOVE      POCC15        SVCC15                         RVSD ETA LINE CEN
     C                   END
     C                   END
     C                   END
     C                   MOVE      ETASO         ETLMDY
     C                   MOVE      ETLIMO        ETALMO
     C                   MOVE      ETLIDY        ETALDY
     C                   MOVE      ETLIYR        ETALYR
     C                   Z-ADD     5             PDATYP                         DATE TYPE
     C                   MOVE      ETLYMD        PDATE6                         ETA DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDATE8        TLCYMD                         ETA DATE
     C     ORCYMD        IFGT      TLCYMD                                       ORD DATE GT ETA
     C     POCD01        ANDNE     'F'                                          NOT BLANKET
     C     *IN31         ANDEQ     *OFF
     C                   MOVE      *ON           *IN89                          ERROR MESSAGE
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(28)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      ETASR         ETRMDY
     C                   MOVE      ETLRMO        ETALRM
     C                   MOVE      ETLRDY        ETALRD
     C                   MOVE      ETLRYR        ETALRY
     C                   Z-ADD     5             PDATYP                         DATE TYPE
     C                   MOVE      ERLYMD        PDATE6                         RVSD ETA
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDATE8        RLCYMD                         RVSD ETA
     C     ORCYMD        IFGT      RLCYMD                                       ORD DATE GT ETA
     C     POCD01        ANDNE     'F'                                          NOT BLANKET
     C     *IN33         ANDEQ     *OFF
     C                   MOVE      *ON           *IN99                          ERROR MESSAGE
     C     ERRFLG        IFNE      'Y'
     C                   MOVEL     UMS(31)       MSGFLD
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   ENDIF
     C                   ENDIF
      * If ETA date error, fold subfile.
     C     *IN89         IFEQ      *ON
     C     *IN99         OREQ      *ON
     C                   MOVE      *OFF          *IN28                          SFLFOLD
     C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    TAG & HOLD                                              *
      *------------------------------------------------------------------------*
     C     TAGHLD        BEGSR
     C                   CLEAR                   TQTY
     C                   CLEAR                   FQTY
     C                   MOVE      *OFF          SAMEBR            1
     C                   MOVE      *OFF          TGEDIT            1
      *
      * SAVE *IN67
      *
     C                   MOVE      *IN67         SVIN67            1
     C                   MOVE      *IN54         SVIN54            1
     C                   MOVE      *IN64         SVIN64            1
     C     POCD01        IFEQ      'D'
     C                   MOVE      '1'           *IN33
     C                   ELSE
     C                   MOVE      '0'           *IN33
     C                   END
     C                   MOVE      'N'           ALWQCH            1
     C                   MOVE      *IN93         SVIN93            1
     C                   MOVE      *IN53         SVIN53            1
     C                   MOVE      *OFF          *IN93
      *
      * IF LOT PO, PO QTY NOT ALLOWED TO BE CHANGED ON TAG SCREEN.
     C     TYP           IFEQ      'D'
     C                   MOVE      '0'           *IN53
     C                   ELSE
     C                   MOVE      '1'           *IN53
     C                   ENDIF
     C                   MOVEA     '1'           *IN(70)                        INITIALIZE
     C                   WRITE     POC0120F                                     TAG & HOLD
     C                   MOVEA     '0'           *IN(70)                        SETOF INITIALIZ
     C                   MOVEA     '0'           *IN(51)                        INIT IND FROM TESTN
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
      * RESET... LEFTOVER FROM HEADER SCREEN...
     C                   MOVE      *OFF          *IN69
     C                   MOVE      ' '           KEYYN             1            TAG & HOLD ?
     C                   MOVE      ' '           WRNR@P                         TAG & HOLD ?
      * CALCULATE OPEN P/O QTY AT STOCKING UOM...
     C     UQYSF         SUB       QTYR          OPNPO             7 0          RCV @ PCHSNG
      * CALCULATE QUANTITY RECEIVED TO DATE AT PURCHASING UOM...
     C     UOMSF         IFNE      0
     C     QTYR          DIV       UOMSF         QTYR@P                         RCV @ PCHSNG
     C                   ELSE
     C                   Z-ADD     QTYR          QTYR@P
     C                   ENDIF
      * CALCULATE OPEN P/O QTY...
     C     QTY           SUB       QTYR@P        OPENPO
      *
     C                   Z-ADD     1             Z                 3 0          ARRAY INDEX
     C                   Z-ADD     1             RNO               3 0          S/F INDEX
     C                   Z-ADD     1             RNR               3 0          S/F INDEX
      *
     C     KEY           IFNE      0                                            TAG & HOLD KEY
     C     I1            ANDNE     '/'
     C     *IN40         DOUEQ     '0'
     C     Z             ORGT      MAXKY
     C     KEY           LOOKUP    KY(Z)                                  40    TAG & HOLD
     C     *IN40         IFEQ      '1'                                          EXIST ????
     C                   MOVEA     TH(Z)         TAGH                           TAG & HOLD
     C                   ADD       TQTY          FQTY
   HIC*                  Z-ADD     TREF          SVREF
HI   C                   MOVE      TREF          SVREF
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *IN67         SV67
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
     C                   WRITE     POS0120F                                     DATA
     C                   ADD       1             RNO                            S/F INDEX
HC   C                   eval      *in78 = *off
     C                   ADD       1             Z                              D/S INDEX
     C                   MOVE      'Y'           KEYYN                          TAG & HOLD ?
      * See if tagged to ship branch...
     C     TBRA          IFEQ      PONO02
     C     WHMBR         IFEQ      'Y'
     C     TTYP          OREQ      'T'
     C                   MOVE      *ON           SAMEBR
     C                   ENDIF
     C                   ENDIF
     C                   END
     C                   END
      * If BRCHK is on we only came here to check for tags where the
      * the branch is equal to the ship branch, so if there are no
      * tags to the ship branch, get out of here...
     C     BRCHK         IFEQ      *ON
     C     SAMEBR        CABNE     *ON           ENDIT
     C                   ENDIF
      *
     C                   ELSE
      *
     C     I1            IFEQ      '/'
     C     ZZNO04        CHAIN(N)  OELTOLY8                           40
     C     *IN40         IFEQ      *OFF
     C     OENO16        IFEQ      PONO02
     C     PONO02        OREQ      *ZERO
      * GET S/O COMMENT...
     C                   CLEAR                   SVCOM
     C                   Z-ADD     1             Z
     C     KEY           IFNE      *ZEROS                                       TAG & HOLD KEY
     C     *IN40         DOUEQ     *OFF
     C     Z             ORGT      MAXKY
     C     KEY           LOOKUP    KY(Z)                                  40    TAG & HOLD
     C     *IN40         IFEQ      *ON                                          EXIST ????
     C                   MOVEA     TH(Z)         TAGH                           TAG & HOLD
     C                   ADD       TQTY          FQTY
     C     ORDTYP        IFEQ      'SO'
     C                   MOVEL     TCOM          SVCOM
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             Z                              D/S INDEX
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   MOVE      'SO'          ORDTYP
   HIC*                  Z-ADD     ONO01         TREF
   HIC*                  Z-ADD     ONO01         SVREF
HI   C                   MOVE      ONO01         TREF
HI   C                   MOVE      ONO01         SVREF
     C                   Z-ADD     ANO01         TCUS
      * IF B/O QTY EXISTS, USE IT... OTHERWISE, USE QTY ORDERED...
     C     OEQY02        IFGT      0
     C                   Z-ADD     OEQY02        TQTY
     C                   ELSE
     C                   Z-ADD     OEQY01        TQTY
     C                   ENDIF
     C                   ADD       TQTY          FQTY
     C                   Z-ADD     *ZEROS        TBRA
   HIC*                  Z-ADD     OENO26        TTORG
HI   C                   MOVE      OENO26        TTORG
     C                   Z-ADD     OENO22        TTCTL
   HIC*                  Z-ADD     OENO26        ORDNUM
HI   C                   MOVE      OENO26        ORDNUM
     C                   Z-ADD     OENO22        TLIN
     C                   MOVEL     SVCOM         TCOM
     C                   MOVE      '1'           TTYP
     C                   MOVE      *ON           *IN67
     C                   MOVE      *IN67         SV67
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
     C                   WRITE     POS0120F                                     DATA
     C                   MOVE      *OFF          *IN67
HC   C                   eval      *in78 = *off
     C                   ADD       1             RNO                            S/F INDEX
     C                   MOVE      'Y'           KEYYN
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN40         IFEQ      *ON
   HEC*    ZZNO04        CHAIN(N)  WOTOL3                             40
   HEC*    *IN40         IFEQ      *OFF
   HEC*    WOCD01        ANDNE     'C'
   HEC*    WOCD01        ANDNE     'V'
   HEC*                  MOVE      'WO'          ORDTYP
   HIC*                  Z-ADD     ONO01         TREF
   HIC*                  Z-ADD     ONO01         SVREF
HI HEC*                  MOVE      ONO01         TREF
HI HEC*                  MOVE      ONO01         SVREF
   HEC*                  Z-ADD     ANO01         TCUS
   HEC*                  Z-ADD     WOQY02        TQTY
   HEC*                  ADD       TQTY          FQTY
   HEC*                  Z-ADD     *ZEROS        TBRA
   HIC*                  Z-ADD     *ZEROS        TTORG
HI HEC*                  MOVE      *ZEROS        TTORG
   HEC*                  Z-ADD     *ZEROS        TTCTL
   HEC*                  Z-ADD     OENO22        TLIN
   HEC*                  MOVE      *BLANKS       TCOM
   HEC*                  MOVE      '4'           TTYP
   HEC*                  MOVE      *ON           *IN67
   HEC*                  MOVE      *IN67         SV67
   HEC*                  WRITE     POS0120F                                     DATA
   HEC*                  MOVE      *OFF          *IN67
   HEC*                  ADD       1             RNO                            S/F INDEX
   HEC*                  ENDIF
HE    * CHECK OPEN WORK ORDER MOVE REQUESTS...
HE    *
HE   C                   CLEAR                   ITEMNBR
HE   C                   MOVEL     ZZNO04        PRODNBR
HE   C                   MOVE      'MOV'         TRANTYP
HE   C     WOKEY         SETLL     WKFTMOV
HE   C     *IN40         DOUEQ     *ON
HE   C     WOKEY         READE(N)  WKFTMOV                                40
HE   C     *IN40         IFEQ      *OFF
HE   C     TRANSNOMP     ANDNE     '0000000'
HE   C     TRANSNOMP     ANDNE     '       '
HE   C     BAKSTKQYMP    ANDGT     0
HE   C                   MOVE      'WO'          ORDTYP
HE   C                   MOVE      TRANSNOMP     TREF
HE   C                   MOVE      TRANSNOMP     SVREF
HE   C                   Z-ADD     0             TCUS
HE   C                   eval      tqty = hdChkDecQTY(bakstkqymp)               B/O QTY
HE   C                   ADD       TQTY          FQTY
HE   C                   Z-ADD     *ZEROS        TBRA
HE   C                   MOVE      *ZEROS        TTORG
HE   C                   Z-ADD     *ZEROS        TTCTL
HE   C                   Z-ADD     0             TLIN
HE   C                   MOVE      *BLANKS       TCOM
HE   C                   MOVE      '4'           TTYP
HE   C                   MOVE      *ON           *IN67
HE   C                   MOVE      *IN67         SV67
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
HE   C                   WRITE     POS0120F                                     DATA
HE   C                   MOVE      *OFF          *IN67
HC   C                   eval      *in78 = *off
HE   C                   ADD       1             RNO                            S/F INDEX
HE   C                   ENDIF
HE   C                   ENDDO
      * GET COMMENTS
     C                   CLEAR                   SVCOM
     C                   Z-ADD     1             Z
     C     KEY           IFNE      *ZEROS                                       TAG & HOLD KEY
     C     *IN40         DOUEQ     *OFF
     C     Z             ORGT      MAXKY
     C     KEY           LOOKUP    KY(Z)                                  40    TAG & HOLD
     C     *IN40         IFEQ      *ON                                          EXIST ????
     C                   MOVEA     TH(Z)         TAGH                           TAG & HOLD
     C                   ADD       TQTY          FQTY
     C     ORDTYP        IFEQ      'WO'
     C                   MOVEL     TCOM          SVCOM
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             Z                              D/S INDEX
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
      * CHECK TRANSFERS
      *
     C                   MOVEL     ZZNO04        NSKEY
     C     NSKEY         SETLL     IVFTTLK                                40
     C     *IN40         IFEQ      *ON
     C     *IN40         DOUEQ     *ON
     C     NSKEY         READE(N)  IVFTTLK                                40
     C     *IN40         IFEQ      *OFF
     C     IVNO52        ANDEQ     PONO02
     C     IVCD70        ANDNE     'V'
     C     IVQYX2        ANDGT     0
      *
      * GET TRF COMMENT...
     C                   CLEAR                   SVCOM2
     C                   Z-ADD     1             Z
     C     KEY           IFNE      *ZEROS                                       TAG & HOLD KEY
     C     *IN44         DOUEQ     *OFF
     C     Z             ORGT      MAXKY
     C     KEY           LOOKUP    KY(Z)                                  44    TAG & HOLD
     C     *IN44         IFEQ      *ON                                          EXIST ????
     C                   MOVEA     TH(Z)         TAGH                           TAG & HOLD
     C                   ADD       TQTY          FQTY
     C     ORDTYP        IFEQ      'TR'
     C                   MOVEL     TCOM          SVCOM2
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             Z                              D/S INDEX
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   MOVE      'TR'          ORDTYP
   HIC*                  Z-ADD     IVNO26        TREF
   HIC*                  Z-ADD     IVNO26        SVREF
HI   C                   MOVE      IVNO26        TREF
HI   C                   MOVE      IVNO26        SVREF
     C                   Z-ADD     IVQYX2        TQTY
     C                   ADD       TQTY          FQTY
     C                   Z-ADD     *ZEROS        TCUS
     C                   Z-ADD     *ZEROS        TBRA
   HIC*                  Z-ADD     IVNO55        TTORG
HI   C                   MOVE      IVNO55        TTORG
     C                   Z-ADD     IVNO92        TTCTL
     C                   Z-ADD     IVNO44        TLIN
     C                   MOVEL     SVCOM2        TCOM
     C                   MOVE      '2'           TTYP
     C                   MOVE      *ON           *IN67
     C                   MOVE      *IN67         SV67
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
     C                   WRITE     POS0120F                                     DATA
     C                   MOVE      *OFF          *IN67
HC   C                   eval      *in78 = *off
     C                   ADD       1             RNO                            S/F INDEX
     C                   MOVE      'Y'           KEYYN
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      * CHECK CONTRACTS
     C     POCD42        IFEQ      'Y'
     C     ZZNO04        CHAIN(N)  OELTOALA                           40
     C     *IN40         IFEQ      *OFF
     C     OENO16        IFEQ      PONO02
     C     OECD72        ANDEQ     'Y'
     C     PONO02        OREQ      *ZERO
     C     OECD72        ANDEQ     'Y'
      *
      * GET C/O COMMENT...
     C                   CLEAR                   SVCOM3
     C                   Z-ADD     1             Z
     C     KEY           IFNE      *ZEROS                                       TAG & HOLD KEY
     C     *IN44         DOUEQ     *OFF
     C     Z             ORGT      MAXKY
     C     KEY           LOOKUP    KY(Z)                                  44    TAG & HOLD
     C     *IN44         IFEQ      *ON                                          EXIST ????
     C                   MOVEA     TH(Z)         TAGH                           TAG & HOLD
     C                   ADD       TQTY          FQTY
     C     ORDTYP        IFEQ      'CO'
     C                   MOVEL     TCOM          SVCOM3
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             Z                              D/S INDEX
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   MOVE      'CO'          ORDTYP
   HIC*                  Z-ADD     ONO01         TREF
   HIC*                  Z-ADD     ONO01         SVREF
HI   C                   MOVE      ONO01         TREF
HI   C                   MOVE      ONO01         SVREF
     C                   Z-ADD     ANO01         TCUS
     C                   Z-ADD     OEQY17        TQTY
     C                   ADD       TQTY          FQTY
     C                   Z-ADD     *ZEROS        TBRA
   HIC*                  Z-ADD     *ZEROS        TTORG
HI   C                   MOVE      *ZEROS        TTORG
     C                   Z-ADD     *ZEROS        TTCTL
     C                   Z-ADD     OENO31        TLIN
     C                   MOVEL     SVCOM3        TCOM
     C                   MOVE      '3'           TTYP
     C                   MOVE      *ON           *IN67
     C                   MOVE      *IN67         SV67
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
     C                   WRITE     POS0120F                                     DATA
     C                   MOVE      *OFF          *IN67
HC   C                   eval      *in78 = *off
     C                   ADD       1             RNO                            S/F INDEX
     C                   MOVE      'Y'           KEYYN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     1             Z
     C     KEY           IFNE      *ZEROS                                       TAG & HOLD KEY
     C     *IN40         DOUEQ     *OFF
     C     Z             ORGT      MAXKY
     C     KEY           LOOKUP    KY(Z)                                  40    TAG & HOLD
     C     *IN40         IFEQ      *ON                                          EXIST ????
     C                   MOVEA     TH(Z)         TAGH                           TAG & HOLD
     C                   ADD       TQTY          FQTY
     C     ORDTYP        IFNE      'SO'
     C     ORDTYP        ANDNE     'TR'
     C     ORDTYP        ANDNE     'CO'
     C     ORDTYP        ANDNE     'WO'
   HIC*                  Z-ADD     TREF          SVREF
HI   C                   MOVE      TREF          SVREF
     C                   MOVE      *ON           *IN67
     C                   MOVE      *IN67         SV67
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
     C                   WRITE     POS0120F                                     DATA
     C                   ADD       1             RNO                            S/F INDEX
HC   C                   eval      *in78 = *off
     C                   MOVE      'Y'           KEYYN                          TAG & HOLD ?
     C                   ENDIF
     C                   ADD       1             Z                              D/S INDEX
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   CLEAR                   TAGH
     C     RNO           DOWLT     51
     C                   MOVE      *ON           *IN67
     C                   MOVE      *IN67         SV67
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
     C                   WRITE     POS0120F
     C                   ADD       1             RNO                            S/F INDEX
HC   C                   eval      *in78 = *off
     C                   ENDDO
      *
     C                   ENDIF
     C                   END
      *
      * IF NON/STOCK PROTECT & NON-DISPLAY (TTYP) FIELD
   HCC*    *IN66         IFEQ      '1'                                          NON/STOCK
   HCC*    RNO           ANDLT     51
   HCC*    *IN33         OREQ      '1'                                          direct
   HCC*    RNO           ANDLT     51
HC   C                   if        rno < 51
HC    * Nonstock
HC   C                   if        *in66
HC    * Direct
HC   C                             or *in33
HC    * ASN exists for item
HC   C                             or onAsnF = 'Y'
     C                   CLEAR                   TAGH
     C     RNO           DOWLT     51
     C     I1            IFEQ      '/'
     C                   MOVE      *ON           *IN67
     C                   ELSE
     C                   MOVE      *OFF          *IN67
     C                   ENDIF
     C                   MOVE      *IN67         SV67
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
     C                   WRITE     POS0120F
HC   C                   eval      *in78 = *off
     C                   ADD       1             RNO                            S/F INDEX
     C                   END
     C                   Z-ADD     1             RNO
     C                   END
HC   C                   endif
     C                   MOVE      'F'           SWITCH            1
      *
      * DISPLAY TAG & HOLD
     C     TAGDSP        TAG
     C                   MOVEA     '1'           *IN(70)                        INITIALIZE
     C     SWITCH        IFEQ      'F'
     C                   WRITE     POC0120R                                     TAG & HOLD
     C                   ELSE
     C                   WRITE     POC0120F
     C                   ENDIF
      *
      * DISPLAY WARNING MESSAGE IF ITEMS HAVE BEEN RECEIVED...
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN64
     C     QTYR          IFGT      *ZEROS
     C     QTYR          IFLT      UQYSF
     C                   MOVE      *ON           *IN54
     C                   ELSE
     C                   MOVE      *ON           *IN64
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEA     '0'           *IN(70)                        SETOF INITIALIZ
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C                   MOVEL     ZZNO04        PDDS
     C                   MOVE      ZZDN01        PDDS
     C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB & CNT
      *
HC    * Protect input capable fields if open ASN exists for item
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      prtctMsg = 'Open ASN exists.  Tag +
HC   C                                         maintenance not allowed.'
HC   C                   eval      *in78 = *on
HC   C                   endif
JF KTC*                  If        Msgfld = *blanks
KT   C                   If        Msgfld <> ums(66)
JF   C                   Eval      TERRRN = 1
JF   C                   Endif
     C     SWITCH        IFEQ      'F'
     C                   WRITE     POF0120F                                     CMD KEY FORMAT
     C                   EXFMT     POC0120F                                     TAG & HOLD CONT
     C                   Z-ADD     1             RNR
     C                   ELSE
     C                   WRITE     POF0120R                                     CMD KEY FORMAT
     C                   EXFMT     POC0120R                                     TAG & HOLD CONT
     C                   Z-ADD     1             RNO
     C                   ENDIF
HC   C                   eval      prtctMsg = *blanks
HC   C                   eval      *in78 = *off
      *
     C                   EXSR      @CURSR
     C                   MOVE      *OFF          *IN88
     C                   MOVE      *OFF          *IN93                          RI,PC
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
     C                   MOVE      *OFF          *IN37                          ERROR OCCURED
     C                   MOVE      POCD01        SVTYPE
      * SAVE THE ORIGINAL CUSTOMER NUMBER...
     C     POCD01        IFEQ      'D'
     C                   Z-ADD     PONO13        CUSTSV
     C                   ENDIF
      *
      * SINCE ORDERING UNITS CAN BE CHANGED ON THIS SCREEN, RE-CALC
      * THE FOLLOWING INFORMATION...
      *
      * CALCULATE ORDERED UNITS IN STOCKING QTY...
     C     UOMSF         MULT      QTY           UQYSF
      * CALCULATE OPEN P/O QTY AT STOCKING UOM...
     C     UQYSF         SUB       QTYR          OPNPO             7 0          RCV @ PCHSNG
      * CALCULATE QUANTITY RECEIVED TO DATE AT PURCHASING UOM...
     C     UOMSF         IFNE      0
     C     QTYR          DIV       UOMSF         QTYR@P                         RCV @ PCHSNG
     C                   ELSE
     C                   Z-ADD     QTYR          QTYR@P
     C                   ENDIF
      * CALCULATE OPEN P/O QTY...
     C     QTY           SUB       QTYR@P        OPENPO
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           TAGDSP
     C                   END
      * Do not allow F12 if there was a ship branch change and the tags
      * have not been edited yet...
     C     *IN12         IFEQ      *ON
     C     SHBCHG        ANDEQ     *ON
     C     TGEDIT        ANDNE     *ON
     C                   MOVE      *OFF          *IN12
     C                   ENDIF
      *
      * F12 PREVIOUS
     C     MSGFLD        IFEQ      *BLANKS                                      NO ERRORS
     C     *IN12         IFEQ      *ON
     C     FQTY          ANDLE     UQYSF
     C     *IN12         CABEQ     *ON           TAGEND                         F12 PREVIOUS
     C                   ENDIF
     C                   ENDIF
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           ENDIT                          CMD 03 RETURN
     C                   END
     C     *IN03         IFEQ      *ON
     C                   MOVEL     EMS(9)        MSGFLD
     C                   MOVE      *ON           *IN56
     C     *IN56         CABEQ     *ON           TAGDSP
     C                   ENDIF
      *
     C                   MOVEA     '0'           *IN(56)                        MESSAGE DISPLAY
      *
     C                   MOVE      ' '           KEYYN                          TAG & HOLD ?
      *
      * READ SUBFILE
     C                   CLEAR                   MSGFLD
      *
      * F4=PROMPT
      *
     C     *IN04         IFEQ      *ON
     C                   EXSR      @PRMPT
     C                   ENDIF
      *
      * IF ALLOWED TO CHANGE QTY, ENSURE THAT IT IS GT ZERO.
     C     TYP           IFNE      'D'
     C     ALWQCH        ANDEQ     'Y'
     C     QTY           IFLE      *ZEROS
     C                   MOVE      *ON           *IN93                          RI,PC
     C                   MOVEL     UMS(22)       MSGFLD
     C                   END
     C                   END
      *
     C                   Z-ADD     0             FQTY                           TAGGED QTYS
     C                   Z-ADD     0             TGCNT             3 0          tag count
     C                   Z-ADD     1             Z                 3 0          ARRAY INDEX
     C                   MOVE      'Y'           FIRST
     C     *IN41         DOUEQ     '1'
     C                   MOVE      *BLANKS       TAGERR            1
      *
     C     FIRST         IFEQ      'Y'
      *
     C                   MOVE      'N'           FIRST
      *
     C     SWITCH        IFEQ      'F'
     C     1             CHAIN     POS0120F                           41        TAG & HOLD S/F
     C                   ELSE
     C     1             CHAIN     POS0120R                           41        TAG & HOLD S/F
     C                   ENDIF
      *
     C                   ELSE                                                   NOT FIRST
      *
     C     SWITCH        IFEQ      'F'
     C                   READC     POS0120F                               41    TAG & HOLD S/F
     C                   ELSE
     C                   READC     POS0120R                               41    TAG & HOLD S/F
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN41         IFEQ      '0'
      *
     C                   MOVE      'N'           SFLWRT            1
      *
      * EDIT DATA
      * If direct order force entry of sales order, do not allow TYPE
      * 'T' (transfer) or branch entry.
     C     POCD01        IFEQ      'D'
     C     TQTY          IFGT      0
     C     TTYP          IFEQ      'T'                                          transfer not
     C                   MOVE      *ON           *IN52
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(28)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   END
     C                   END
      *
     C     TBRA          IFNE      0                                            branch entry
     C                   MOVE      '1'           *IN58
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(31)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   END
     C                   END
      *
   HIC*    TREF          IFEQ      0                                            sales order
HI   C     TREF          IFEQ      *ZEROS                                       sales order
HI   C     TREF          OREQ      *BLANKS                                      sales order
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(30)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   END
      * Don't allow multiple tags on directs
     C                   ELSE
     C                   ADD       1             TGCNT
     C     TGCNT         IFGT      1
     C                   MOVE      *ON           *IN88                          rev image
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(33)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
     C                   END
     C                   END
      *
     C                   ELSE
     C     POCD01        IFNE      'D'                                          non-direct
     C     TQTY          IFNE      0                                            qty ent'd
     C     TBRA          ANDEQ     0                                            branch or
   HIC*    TREF          ANDEQ     0                                            sls ord req
HI   C     TREF          IFEQ      *ZEROS                                       sls ord req
HI   C     TREF          OREQ      *BLANKS                                      sls ord req
     C                   MOVE      '1'           *IN58
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(29)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   END
HI   C                   ENDIF
     C                   END
     C     TTYP          IFEQ      'T'                                          TYPE-T TRANSFER
     C     TCUS          IFNE      0                                            TAG TO CUSTOMER
     C                   MOVEA     '1'           *IN(58)                        HIGHLITE ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(26)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   END
     C                   END
     C                   END
      *
     C     TTYP          IFEQ      'T'                                          TYPE-T TRANSFER
     C     TBRA          IFEQ      0                                            TAG TO CUSTOMER
     C                   MOVEA     '1'           *IN(58)                        HIGHLITE ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(26)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   END
     C                   END
     C                   END
      *
J3    *  Prevent any non-customer tag to the Ship To branch
     C     TTYP          IFEQ      'T'                                          TYPE-T TRANSFER
J3   C     ttyp          orne      'T'
J3   C     tcus          andeq     *zeros
J3   C     tref          andeq     *blanks
     C     TBRA          IFEQ      PONO02                                       EQUAL SHIP TO ?
     C                   MOVEA     '1'           *IN(58)                        HIGHLITE ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(27)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   END
     C                   END
     C                   END
      * Tag branch cannot be the same as P/O ship to branch
      * for WM branches...
     C     WHMBR         IFEQ      'Y'
     C     TBRA          ANDEQ     PONO02
     C                   MOVE      *ON           *IN58
     C                   MOVE      'Y'           TAGERR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     UMS(62)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
     C     TBRA          IFNE      0                                            TAG TO BRANCH
   HIC*    TREF          ANDNE     0
HI   C     TREF          ANDNE     *ZEROS
HI   C     TREF          ANDNE     *BLANKS
     C                   MOVEA     '1'           *IN(82)                        HIGHLITE ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(24)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   END
     C                   END
      *
     C     TBRA          IFNE      0                                            TAG TO BRANCH
     C     TBRA          CHAIN     ARFMBCH                            40        BRANCH MASTER
     C     *IN40         IFEQ      *ON                                          NOT SETUP
     C                   MOVEA     '1'           *IN(80)                        HIGHLITE ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(18)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   END
     C                   END
     C     *IN40         IFEQ      *OFF
     C     ARFL16        ANDEQ     'C'                                          CLOSED
     C                   MOVE      *ON           *IN80                          HIGHLITE ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     UMS(46)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
     C                   END
     C                   END
     C                   END
      *
      *  TEST FOR REF. NUMBER (ORDER NUMBER)
   HIC*    TREF          IFNE      0
HI   C     TREF          IFNE      *ZEROS
HI   C     TREF          ANDNE     *BLANKS
     C     TREF          ANDNE     SVREF
      *
     C     TTORG         IFNE      *ZEROS
HI   C     TTORG         ANDNE     *BLANKS
   HIC*    SVREF         ANDGE     *ZEROS
HI   C     SVREF         ANDNE     'ZZZZZZZ'
     C     ORDTYP        IFEQ      'SO'                                         S/O TAG
     C                   MOVEL     'S'           POCD45
     C     WRKKEY        DELETE    POFWTAG                            47
     C                   ELSE
     C                   MOVE      'T'           POCD45
     C     WRKKEY        DELETE    POFWTAG                            47
     C                   ENDIF
     C                   ENDIF
      *
      * BACK OUT TAG COUNT IN CASE OF CHANGE OR DELETION.
      * WE'LL ADD BACK DEPENDING ON WHAT KIND OF TAG WE END UP WITH.
      *
     C                   SELECT
     C     ORDTYP        WHENEQ    'TR'
     C                   SUB       1             TRTCNT
     C     ORDTYP        WHENEQ    'SO'
     C                   SUB       1             SOTCNT
     C     ORDTYP        WHENEQ    'CO'
     C                   SUB       1             COTCNT            5 0
     C     ORDTYP        WHENEQ    'WO'
     C                   SUB       1             WOTCNT
     C                   ENDSL
     C                   MOVE      *BLANKS       ORDTYP
     C                   Z-ADD     0             INO07
      *
      *  GET ORDER HEADER TO GET CUSTOMER NUMBER
     C                   MOVE      'N'           FOUND             1
     C                   MOVE      'N'           VALDSO            1
     C                   MOVE      'N'           VALDTF            1
     C                   MOVE      'N'           VALDCO            1
     C                   MOVE      'N'           VALDWO            1
      *
      * DETERMINE IF TRYING TO TAG TO SALES ORDER, TRANSFER, CONTRACT,
      * OR WORK ORDER. THE NUMBER ENTERED COULD BE VALID FOR 3 OUT OF 4
      *
     C                   Z-ADD     *ZEROS        VALDCT            1 0
     C     TREF          SETLL     OELTOHY8                               40
     C     *IN40         IFEQ      *ON
     C                   MOVE      'Y'           VALDSO
     C                   ADD       1             VALDCT
     C                   ENDIF
HI   C                   TESTN                   TREF                 51
HI   C     *IN51         IFEQ      *ON
HI   C                   MOVE      TREF          TREF#
HI   C                   ENDIF
   HIC*    TREF          SETLL     IVFTTH                                 40
HI   C     TREF#         SETLL     IVFTTH                                 40
     C     *IN40         IFEQ      *ON
     C                   MOVE      'Y'           VALDTF
     C                   ADD       1             VALDCT
     C                   ENDIF
      *
      * DETERMINE IF TRYING TO TAG TO CONTRACT
      *
     C     POCD42        IFEQ      'Y'
     C     TREF          SETLL     OEFTOAH                                40
     C     *IN40         IFEQ      *ON
     C                   MOVE      'Y'           VALDCO
     C                   ADD       1             VALDCT
     C                   ENDIF
     C                   ENDIF
HI HEC*    TREF#         SETLL     WOFTOH                                 40
   HIC*    TREF          SETLL     WOFTOH                                 40
HE   C                   MOVE      TREF          AlphaTran         7
HE   C     AlphaTran     SETLL     WOMOVE                                 40
     C     *IN40         IFEQ      *ON
     C                   MOVE      'Y'           VALDWO
     C                   ADD       1             VALDCT
     C                   ENDIF
      *
      * NOT A VALID SALES ORDER OR TRANSFER NUMBER
      * NOR A VALID CONTRACT
   HE * NOR A VALID WORK ORDER
HE    * NOR A VALID WORK ORDER MOVE REQUEST
      *
     C     VALDSO        IFNE      'Y'
     C     VALDTF        ANDNE     'Y'
     C     VALDCO        ANDNE     'Y'
     C     VALDWO        ANDNE     'Y'
     C                   MOVE      *ON           *IN88
     C                   MOVE      EMS(41)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C     VALDCT        IFGT      1
   HIC*                  Z-ADD     TREF          TAGREF
HI   C                   MOVE      TREF          TAGREF
      *
     C                   CALL      'POR0050'     PL0050
     C                   ENDIF
      *
     C                   SELECT
      *
      * TRYING TO TAG TO SALES ORDER
      *
     C     VALDSO        WHENEQ    'Y'
      *
     C                   MOVE      ' '           TAGALR            1
     C                   MOVE      ' '           BRERR             1
      *
     C     TREF          CHAIN     OELTOHY8                           40
     C     *IN40         IFEQ      '0'
      * DETERMINE IF THE CUSTOMER NUMBER ON THE DIRECT P/O MATCHES THE
      * CUSTOMER NUMBER ON THE SALES ORDER...
     C     POCD01        IFEQ      'D'
     C     PONO13        ANDNE     ANO01
     C                   MOVE      *ON           *IN88                          RI,PC
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(36)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      * IF THE P/O IS A NON-DIRECT, DO NOT ALLOW A DIRECT S/O TO BE
      * TAGGED TO IT...
     C     POCD01        IFEQ      'D'
     C     OECD01        ANDNE     'D'
     C     POCD01        ORNE      'D'
     C     OECD01        ANDEQ     'D'
     C                   MOVE      *ON           *IN88                           RI,PC
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(36)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
      *
      * See if item exists on salesorder with open backorders;
      *
     C                   MOVE      'Y'           BRERR             1
     C                   MOVE      ' '           BRFLG             1
     C     TAGKY         SETLL     OELTOLYO                               40
     C     *IN40         DOUEQ     *ON
     C     TAGKY         READE     OELTOLYO                               40
     C                   SELECT
     C     *IN40         WHENEQ    *ON                                          RCD NOT FND
     C                   LEAVE
     C     POCD01        WHENEQ    'D'                                          DIR P/O
     C     OECD01        ANDNE     'D'                                          NON-DIR S/O
     C                   ITER                                                   KEEP LOOKING
     C     POCD01        WHENNE    'D'                                          NON-DIR P/O
     C     OECD01        ANDEQ     'D'                                          DIR S/O
     C                   ITER                                                   KEEP LOOKING
     C     POCD01        WHENNE    'D'                                          NON-DIR P/O
     C     PONO02        ANDNE     OENO16                                       SAME SHIP BR
     C                   MOVE      'S'           BRFLG             1
     C                   ITER                                                   KEEP LOOKING
     C                   OTHER
     C                   MOVE      ' '           BRERR
     C     PNO01         IFNE      *ZEROS                                       SEE IF ALREADY
     C     PNO01         ANDNE     PONO01                                       TAGGED TO P/O
     C                   MOVE      'Y'           TAGALR
     C                   ITER
     C                   ELSE
     C     WRN           IFNE      'Y'
     C     OENO60        ANDNE     *ZEROS                                       OR TRANSFER
     C                   MOVE      *ON           *IN69
     C     MSGFLD        IFNE      'Y'
     C                   MOVEL     UMS(50)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   MOVE      'Y'           WRN
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'Y'           FOUND                          FOUND LINE
     C                   MOVE      ' '           TAGALR
     C                   LEAVE                                                  QUIT LOOKING
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
     C                   ENDDO
      *
     C                   END
      *
      * ITEM NOT FOUND ON SALES ORDER
      *
     C     FOUND         IFNE      'Y'
     C     TAGALR        ANDEQ     ' '
     C     BRFLG         ANDEQ     ' '
     C                   MOVEA     '1'           *IN(88)
     C     MSGFLD        IFEQ      *BLANKS                                      NO ERRORS
     C                   MOVEL     EMS(20)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
      * SHIP BRANCH ON S/O DOES NOT MATCH SHIP TO BRANCH OF P/O
      *
     C     BRERR         IFEQ      'Y'
     C     SVCD12        ANDNE     'Y'                                          REL 10+ P/O
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVE      EMS(14)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
      * ITEM FOUND ON S/O BUT IS ALREADY TAGGED
      *
     C     TAGALR        IFEQ      'Y'
     C                   MOVEA     '1'           *IN(88)                        HIGHLIGHT ERROR
     C     MSGFLD        IFEQ      *BLANKS                                      NO ERRORS
     C                   MOVEL     EMS(25)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
      * ITEM IS FOUND - SO TAG IT !
      *
     C     FOUND         IFEQ      'Y'
     C                   Z-ADD     ANO01         TCUS
   HIC*                  Z-ADD     ONO26         ORDNUM
HI   C                   MOVE      ONO26         ORDNUM
     C                   MOVE      'SO'          ORDTYP
      *
      * Sales order line item tagging
      *
      *
      * Process directs...
      *
     C     POCD01        IFEQ      'D'                                          DIRECT
   HIC*    TREF          ANDNE     0
HI   C     TREF          ANDNE     *ZEROS
HI   C     TREF          ANDNE     *BLANKS
     C     TQTY          ANDNE     0
     C     MSGFLD        ANDEQ     *BLANKS                                      NO ERRORS
     C     *IN12         ANDEQ     *OFF
     C                   Z-ADD     ZZ            SVZZ              3 0
     C                   EXSR      SOTAG
     C                   Z-ADD     SVZZ          ZZ
     C                   Z-ADD     SVNO22        TLIN
   HIC*                  Z-ADD     ONO26         TTORG
HI   C                   MOVE      ONO26         TTORG
     C                   Z-ADD     SVNO22        TTCTL
      * Update tag & hold array and subfile...
     C                   EXSR      UPDARY
     C                   EXSR      WRTSFL
     C                   ADD       1             SOTCNT
     C                   MOVE      'Y'           SFLWRT
      *
     C                   ELSE
      *
      * Process non-directs...
      *
     C     MSGFLD        IFEQ      *BLANKS                                      NO ERRORS
      *
      * CLEAR TAGDS
      *
     C                   Z-ADD     1             W                 2 0
     C     W             DO        50            W
     C     W             OCCUR     TAGDS
     C                   CLEAR                   TAGDS
     C                   ENDDO
      *
      * (WE DON'T WANT THESE FIELDS INITIALIZED IF WE GOT HERE VIA F4)
      *
     C     *IN04         IFEQ      *OFF
   HIC*                  Z-ADD     *ZEROS        TTORG
HI   C                   MOVE      *ZEROS        TTORG
     C                   Z-ADD     *ZEROS        TTCTL
     C                   ENDIF
      *
     C                   Z-ADD     ANO01         TCUS
   HIC*                  Z-ADD     ONO26         ORDNUM
   HIC*                  Z-ADD     TREF          TAGREF
HI   C                   MOVE      ONO26         ORDNUM
HI   C                   MOVE      TREF          TAGREF
     C     1             OCCUR     TAGDS
     C                   Z-ADD     TQTY          QTYT
   HIC*                  Z-ADD     TTORG         ORG#
HI   C                   MOVE      TTORG         ORG#
     C                   Z-ADD     TTCTL         CTL#
     C                   Z-ADD     0             RTNCDE
      *
     C                   MOVE      *BLANKS       CRCD#
     C                   MOVEL     'POC0120F'    CRCD#
      *
     C                   CALL      'POR0056'     PL0056
      *
      *
     C                   SELECT
      *
      * NO SELECTION MADE
      *
     C     RTNCDE        WHENEQ    1
     C                   MOVE      *ON           *IN88
      *
      * IF USER MADE NO SELECTION - THEN WE ARE GOING TO ZERO OUT
      * SVREF.  THIS WILL CAUSE THE USER TO STAY IN TAG & HOLD UNTIL
      * EITHER A VALID SELECTION IS MADE, OR THE TAG IS REMOVED.
      *
   HIC*                  Z-ADD     *ZEROS        SVREF
HI   C                   MOVE      *ZEROS        SVREF
      *
     C     MSGFLD        IFEQ      *BLANKS
   JMC*                  MOVEL     EMS(35)       MSGFLD
JM   C                   eval      MSGFLD = 'Order or associated order(s) have +
JM   C                             not been tagged, Remove or press Enter.'
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
      *
      * ITEM NOT FOUND SALES ORDER
      *
     C     RTNCDE        WHENEQ    2
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(20)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
      *
      * S/O SHIP FROM BRANCH NOT SAME AS P/O SHIP TO BRANCH
      *
     C     RTNCDE        WHENEQ    3
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(14)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
      *
      * ITEM IS ALREADY TAGGED
      *
     C     RTNCDE        WHENEQ    4
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(25)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
      *
      * NOT FOUND AS OPEN B/O ON SALES ORDERS
      *
     C     RTNCDE        WHENEQ    5
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(32)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   OTHER
     C                   MOVE      'SO'          ORDTYP
      *
      * READ TAGDS AND WRITE NEW TAGS
      *
     C                   Z-ADD     0             W
     C     W             DOUEQ     50
     C                   ADD       1             W
     C     W             OCCUR     TAGDS
     C     ORG#          IFEQ      *ZEROS
HI   C     ORG#          OREQ      *BLANKS
     C                   LEAVE
     C                   ENDIF
   HIC*                  Z-ADD     ORG#          TTORG
HI   C                   MOVE      ORG#          TTORG
     C                   Z-ADD     CTL#          TTCTL
     C                   Z-ADD     CTL#          TLIN
     C                   Z-ADD     QTYT          TQTY
JM   C                   MOVE      NO01T         TREF
      *
     C                   EXSR      UPDARY
     C                   EXSR      WRTSFL
      *
     C                   ADD       1             SOTCNT
     C                   MOVE      'Y'           SFLWRT
     C                   ENDDO
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      *
      * TRYING TO TAG TO TRANSFER
      *
     C     VALDTF        WHENEQ    'Y'
      *
      * CLEAR TAGDS
      *
     C                   Z-ADD     1             W                 2 0
     C     W             DO        50            W
     C     W             OCCUR     TAGDS
     C                   CLEAR                   TAGDS
     C                   ENDDO
      *
      * (WE DON'T WANT THESE FIELDS INITIALIZED IF WE GOT HERE VIA F4)
      *
     C     *IN04         IFEQ      *OFF
   HIC*                  Z-ADD     *ZEROS        TTORG
HI   C                   MOVE      *ZEROS        TTORG
     C                   Z-ADD     *ZEROS        TTCTL
     C                   ENDIF
      *
     C                   Z-ADD     *ZEROS        TCUS
   HIC*                  Z-ADD     IVNO26        ORDNUM
   HIC*                  Z-ADD     TREF          TAGREF
   HIC*                  Z-ADD     TREF          TAGREF
HI   C                   MOVE      IVNO26        ORDNUM
HI   C                   MOVE      TREF          TAGREF
     C     1             OCCUR     TAGDS
     C                   Z-ADD     TQTY          QTYT
   HIC*                  Z-ADD     TTORG         ORG#
HI   C                   MOVE      TTORG         ORG#
     C                   Z-ADD     TTCTL         CTL#
     C                   Z-ADD     0             RTNCDE
JM   C                   MOVE      TREF          NO01T
      *
     C                   MOVE      *BLANKS       CRCD#
     C                   MOVEL     'POC0120F'    CRCD#
      *
     C                   CALL      'POR0055'     PL0055
      *
      *
     C                   SELECT
      *
      * NO SELECTION MADE
      *
     C     RTNCDE        WHENEQ    1
     C                   MOVE      *ON           *IN88
      *
      * IF USER MADE NO SELECTION - THEN WE ARE GOING TO ZERO OUT
      * SVREF.  THIS WILL CAUSE THE USER TO STAY IN TAG & HOLD UNTIL
      * EITHER A VALID SELECTION IS MADE, OR THE TAG IS REMOVED.
      *
   HIC*                  Z-ADD     *ZEROS        SVREF
HI   C                   MOVE      *ZEROS        SVREF
      *
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(37)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
      *
      * ITEM NOT FOUND ON TRANSFER
      *
     C     RTNCDE        WHENEQ    2
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(16)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
      *
      * TRANSFER SHIP FROM BRANCH NOT SAME AS P/O SHIP TO BRANCH
      *
     C     RTNCDE        WHENEQ    3
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(15)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
      *
      * ITEM IS ALREADY TAGGED
      *
     C     RTNCDE        WHENEQ    4
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(25)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
      *
      * NOT FOUND AS OPEN B/O ON ANY TRANSFERS
      *
     C     RTNCDE        WHENEQ    5
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(17)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
      *
      * THIS IS A VOIDED TRANSFER
      *
     C     RTNCDE        WHENEQ    6
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     UMS(61)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   OTHER
     C                   MOVE      'TR'          ORDTYP
      *
      * READ TAGDS AND WRITE NEW TAGS
      *
     C                   Z-ADD     0             W
     C     W             DOUEQ     50
     C                   ADD       1             W
     C     W             OCCUR     TAGDS
     C     ORG#          IFEQ      *ZEROS
HI   C     ORG#          OREQ      *BLANKS
     C                   LEAVE
     C                   ENDIF
   HIC*                  Z-ADD     ORG#          TTORG
HI   C                   MOVE      ORG#          TTORG
     C                   Z-ADD     CTL#          TTCTL
     C                   Z-ADD     QTYT          TQTY
      *
     C                   EXSR      UPDARY
     C                   EXSR      WRTSFL
      *
     C                   ADD       1             TRTCNT
     C                   MOVE      'Y'           SFLWRT
     C                   ENDDO
     C                   ENDSL
      *
      * TRYING TO TAG TO CONTRACT
      *
     C     VALDCO        WHENEQ    'Y'
      *
     C                   MOVE      ' '           TAGAL2            1
     C                   MOVE      ' '           BRERR
      *
     C     TREF          CHAIN     OEFTOAH                            40
     C     *IN40         IFEQ      '0'
      *
      * DETERMINE IF THE CUSTOMER NUMBER ON THE DIRECT P/O MATCHES THE
      * CUSTOMER NUMBER ON THE CONTRACT...
      *
     C     POCD01        IFEQ      'D'
     C     PONO13        ANDNE     ANO01
     C                   MOVE      *ON           *IN88                          RI,PC
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(42)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
      * IF THE P/O IS A NON-DIRECT, DO NOT ALLOW A CONTRACT TO BE
      * TAGGED TO IT...
      *
     C     POCD01        IFEQ      'D'
     C     OECD55        ANDNE     'Y'
     C     POCD01        ORNE      'D'
     C     OECD55        ANDEQ     'Y'
     C                   MOVE      *ON           *IN88                           RI,PC
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(43)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
      * See if item exists on salesorder with open backorders;
      *
     C                   MOVE      'Y'           BRERR             1
     C                   MOVE      ' '           BRFLG             1
     C     OAL8KY        SETLL     OETOAL8                                40
     C     *IN40         DOUEQ     *ON
     C     OAL8KY        READE     OETOAL8                                40
     C                   SELECT
     C     *IN40         WHENEQ    *ON                                          RCD NOT FND
     C                   LEAVE
     C     OECD72        WHENNE    'Y'                                          NOT LOT CONTRACT
     C                   ITER
     C     POCD01        WHENEQ    'D'                                          DIR P/O
     C     OECD55        ANDNE     'Y'                                          NON-DIR C/O
     C                   ITER                                                   KEEP LOOKING
     C     POCD01        WHENNE    'D'                                          NON-DIR P/O
     C     OECD55        ANDEQ     'Y'                                          DIR C/O
     C                   ITER                                                   KEEP LOOKING
     C     POCD01        WHENNE    'D'                                          NON-DIR P/O
     C     PONO02        ANDNE     OENO16                                       SAME SHIP BR
     C                   MOVE      'S'           BRFLG
     C                   ITER                                                   KEEP LOOKING
     C                   OTHER
     C                   MOVE      ' '           BRERR
     C     PNO01         IFNE      *ZEROS                                       SEE IF ALREADY
     C     PNO01         ANDNE     PONO01                                       TAGGED TO P/O
     C                   MOVE      'Y'           TAGAL2
     C                   ITER
     C                   ELSE
     C                   MOVE      'Y'           FOUND                          FOUND LINE
     C                   MOVE      ' '           TAGAL2
     C                   LEAVE                                                  QUIT LOOKING
     C                   ENDIF
     C                   ENDSL
     C                   ENDDO
      *
     C                   END
      *
      * ITEM NOT FOUND ON CONTRACT
      *
     C     FOUND         IFNE      'Y'
     C     TAGAL2        ANDEQ     ' '
     C     BRFLG         ANDEQ     ' '
     C                   MOVEA     '1'           *IN(88)
     C     MSGFLD        IFEQ      *BLANKS                                      NO ERRORS
     C                   MOVEL     EMS(44)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
      * SHIP BRANCH ON C/O DOES NOT MATCH SHIP TO BRANCH OF P/O
      *
     C     BRERR         IFEQ      'Y'
     C     SVCD12        ANDNE     'Y'                                          REL 10+ P/O
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVE      EMS(45)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
      * ITEM FOUND ON C/O BUT IS ALREADY TAGGED
      *
     C     TAGAL2        IFEQ      'Y'
     C                   MOVEA     '1'           *IN(88)                        HIGHLIGHT ERROR
     C     MSGFLD        IFEQ      *BLANKS                                      NO ERRORS
     C                   MOVEL     EMS(25)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
      * ITEM IS FOUND - SO TAG IT !
      *
     C     FOUND         IFEQ      'Y'
     C                   Z-ADD     ANO01         TCUS
     C                   MOVE      'CO'          ORDTYP
     C                   ADD       1             COTCNT
     C                   ENDIF
      *
      * UPDATE TAG & HOLD ARRAY
      *
     C                   EXSR      UPDARY
      *
     C                   EXSR      WRTSFL
     C                   MOVE      'Y'           SFLWRT
      *
HE    * TRYING TO TAG TO WORK ORDER MOVE REQUEST
     C     VALDWO        WHENEQ    'Y'
      *
     C                   MOVE      ' '           TAGALR            1
     C                   MOVE      ' '           BRERR             1
     C                   CLEAR                   WOTCNT
      *
     C                   MOVE      'Y'           BRERR             1
     C                   MOVE      ' '           BRFLG
      *
HI HEC*    TREF#         SETLL     WOFTOL
   HIC*    TREF          SETLL     WOFTOL
HE   C                   MOVE      TREF          AlphaTran
HE   C     AlphaTran     SETLL     WOMOVE                                 40
     C     *IN40         DOUEQ     *ON
   HIC*    TREF          READE(N)  WOFTOL                                 40
HI HEC*    TREF#         READE(N)  WOFTOL                                 40
HE   C     AlphaTran     READE(N)  WOMOVE                                 40
     C                   SELECT
     C     *IN40         WHENEQ    *ON                                          RCD NOT FND
HE   C     TRNTYPCDMP    OREQ      'WIP'
     C                   LEAVE
     C     POCD01        WHENEQ    'D'                                          RCD NOT FND
     C                   LEAVE
   HEC*    INO07         WHENNE    IVNO07
HE   C     ITEMNOMP      WHENNE    IVNO07
     C                   ITER
   HEC*    PONO02        WHENNE    WONO09                                       SAME SHIP BR
HE   C     PONO02        WHENNE    BRANCHNOMP                                   SAME SHIP BR
     C                   MOVE      'S'           BRFLG             1            NOT SAME SHIP BR
     C                   ITER                                                   KEEP LOOKING
     C                   OTHER
     C                   MOVE      ' '           BRERR
   HEC*    PNO01         IFNE      *ZEROS                                       SEE IF ALREADY
   HEC*    PNO01         ANDNE     PONO01                                       TAGGED TO P/O
HE   C                   MOVE      PONO01        ALPHAPO
HE   C     TAGTRNNOMP    IFNE      '0000000'
HE   C     TAGTRNNOMP    ANDNE     *BLANKS
HE   C     TAGTRNNOMP    ANDNE     ALPHAPO
     C                   MOVE      'Y'           TAGALR
     C                   ITER
     C                   ELSE
     C                   MOVE      'Y'           FOUND                          FOUND LINE
     C                   MOVE      ' '           TAGALR                         FOUND LINE
     C                   LEAVE                                                  QUIT LOOKING
     C                   ENDIF
     C                   ENDSL
     C                   ENDDO
      *
      *
   HE * ITEM NOT FOUND ON WORK ORDER
HE    * ITEM NOT FOUND ON WORK ORDER MOVE REQUEST...
      *
     C     FOUND         IFNE      'Y'
     C     TAGALR        ANDEQ     ' '
     C     BRFLG         ANDEQ     ' '
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS                                      NO ERRORS
     C                   MOVEL     AMS(1)        MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
   HE * SHIP BRANCH ON W/O DOES NOT MATCH SHIP TO BRANCH OF P/O
HE    * BRANCH ON W/O MOVE REQUEST DOES NOT MATCH P/O SHIP TO BR...
      *
     C     BRERR         IFEQ      'Y'
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVE      AMS(2)        MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
   HE * ITEM FOUND ON W/O BUT IS ALREADY TAGGED
HE    * ITEM FOUND ON W/O MOVE REQUEST, BUT IS ALREADY TAGGED...
      *
     C     TAGALR        IFEQ      'Y'
     C                   MOVE      *ON           *IN88                          HIGHLIGHT ERROR
     C     MSGFLD        IFEQ      *BLANKS                                      NO ERRORS
     C                   MOVEL     EMS(25)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDIF
      *
      * ITEM IS FOUND - SO TAG IT !
      *
     C     FOUND         IFEQ      'Y'
     C                   Z-ADD     ANO01         TCUS
   HIC*                  Z-ADD     ONO01         ORDNUM
HI HEC*                  MOVE      ONO01         ORDNUM
HE   C                   CLEAR                   TCUS
HE   C                   MOVE      TRANSNOMP     ORDNUM
HE   C     TCOM          IFEQ      *BLANKS
HE   C                   MOVEL     TWKCENTER     TCOM
HE   C                   MOVE      WRKCENIDMP    TCOM
HE   C                   ENDIF
     C                   MOVE      'WO'          ORDTYP
     C                   ADD       1             WOTCNT
     C                   ENDIF
      *
      * UPDATE TAG & HOLD ARRAY
      *
     C                   EXSR      UPDARY
      *
     C                   EXSR      WRTSFL
     C                   MOVE      'Y'           SFLWRT
      *
      *
      * ITEM EXISTS ON A SALES ORDER AND A TRANSFER, CHOOSE ONE OR THE
      * OTHER.
      *
     C                   OTHER
     C                   MOVE      *ON           *IN88
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(12)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   ENDSL
      *
      *  MOVE CUSTOMER NUMBER TO TAG CUSTOMER FIELD
     C                   ELSE
     C     TREF          IFEQ      *ZEROS
HI   C     TREF          OREQ      *BLANKS
     C     TTORG         IFNE      *ZEROS
HI   C     TTORG         ANDNE     *BLANKS
     C     ORDTYP        IFEQ      'SO'                                         S/O TAG
     C                   MOVEL     'S'           POCD45
     C     WRKKEY        DELETE    POFWTAG                            47
     C                   ELSE
     C                   MOVE      'T'           POCD45
     C     WRKKEY        DELETE    POFWTAG                            47
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     0             TCUS
     C                   MOVE      *BLANKS       ORDTYP
     C                   ENDIF
     C                   END
      *
      * IF NOT TAGGED TO S/O LINE, DISPLAY AN ERROR MESSAGE...
     C     TYP           IFNE      'N'
     C     ORDTYP        ANDEQ     'SO'
   HIC*    TREF          ANDNE     0
HI   C     TREF          ANDNE     *ZEROS
HI   C     TREF          ANDNE     *BLANKS
     C     TLIN          ANDEQ     0
     C     *IN12         IFEQ      *OFF
     C                   MOVE      *ON           *IN88                          RI,PC
     C                   ENDIF
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(35)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   CLEAR                   SVREF
     C                   ENDIF
     C                   ENDIF
      *
     C     TQTY          IFLT      TQTYF                                        TAGGED QUANTITY
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(23)       MSGFLD
     C                   MOVE      'Y'           TAGERR
     C                   ENDIF
     C                   END
      *
     C     TQTYF         IFNE      0                                            TAGGED QUANTITY
     C     TQTY          ANDEQ     TQTYF                                        TAGGED QUANTITY
     C     TTYP          ANDEQ     'T'                                          TYPE
     C                   MOVE      'F'           TTYP                           ERROR MESSAGE
     C                   END
      *
     C     TQTYF         IFNE      0                                            TAGGED QUANTITY
     C     TQTY          ANDGT     TQTYF                                        TAGGED QUANTITY
     C     TTYP          ANDEQ     'F'                                          TYPE
     C                   MOVE      'T'           TTYP                           ERROR MESSAGE
     C                   END
      *
      *
      *
      * IF RECORD HAS NOT BEEN WRITTEN YET, DUE TO SOME SORT OF ERROR
      * THEN GO AHEAD AND WRITE THE SUBFILE RECORD.
      *
     C     SFLWRT        IFEQ      'N'
     C                   EXSR      UPDARY
     C                   EXSR      WRTSFL
     C                   ENDIF
     C                   END
     C                   END
      *
     C     MSGFLD        IFEQ      *BLANKS                                      NO ERROR
     C     FQTY          IFGT      UQYSF                                        QTY VS TAG Q
      *
      * IF TAG QTY GT STK P/O QTY, ALLOW TO CHANGE THE P/O QTY.
     C                   MOVE      *ON           *IN93                          RI,PC
     C                   MOVE      'Y'           ALWQCH
     C                   MOVEL     EMS(21)       MSGFLD
     C                   END
     C                   END
      * CALCULATE QUANTITY RECEIVED TO DATE AT PURCHASING UOM...
     C     UOMSF         IFNE      0
     C     QTYR          DIV       UOMSF         QTYR@P                         RCV @ PCHSNG
     C                   ELSE
     C                   Z-ADD     QTYR          QTYR@P
     C                   ENDIF
      * DONT ALLOW QTY TO BE LESS THAN RECEIVED QTY...
KT    * only load message is user selected to go to tag & hold screen
   :AC*    MSGFLD        IFEQ      *BLANKS                                      NO ERROR
KT :AC*    SEL           ANDEQ     'T'
   :AC*    QTY           IFLT      QTYR@P
   :AC*    WRNR@P        ANDEQ     *BLANKS
      *
      * IF REC QTY GT STK P/O QTY, ALLOW TO CHANGE THE P/O QTY.
   :AC*                  MOVE      *ON           *IN93                          RI,PC
   :AC*                  MOVE      'Y'           ALWQCH
   :AC*                  MOVE      'Y'           WRNR@P            1
   :AC*                  MOVEL     EMS(22)       MSGFLD
   :AC*                  END
   :AC*                  END
      *
      * CHANGE SUBFILE SWITCH
      *
     C     SWITCH        IFEQ      'F'
     C                   MOVE      'R'           SWITCH
     C                   ELSE
     C                   MOVE      'F'           SWITCH
     C                   ENDIF
      *
     C                   MOVE      *ON           TGEDIT
     C     MSGFLD        CABNE     *BLANKS       TAGDSP                         DSPLY ERROR
      *
     C     *IN04         CABEQ     *ON           TAGDSP                                     OUS
      *
     C     TAGEND        TAG
     C     KEYYN         IFNE      'Y'                                          TAG & HOLD ?
     C                   Z-ADD     0             KEY                            TAG & HOLD KEY
     C                   ELSE
     C                   Z-ADD     1             Z                              ARRAY INDEX
     C     KEY           LOOKUP    KY(Z)                                  40    TAG & HOLD
     C     *IN40         IFEQ      '0'                                          NOT FOUND
     C                   Z-ADD     0             KEY                            TAG & HOLD KEY
     C                   END
     C                   END
      * IN CASE THE USER HAS CHANGED THE QTY ON THE TAG & HOLD SCREEN,
      * RECALC THE DIFFERENCE BETWEEN QTY & OQTY SO WE DONT DISPLAY THE
      * TAG & HOLD SCREEN "A SECOND TIME" UNNECCESSARILY...
     C     KEY           IFNE      0                                            TAGS ?
     C     QTY           SUB       OQTY          NWDIFF                         NEW QTY DIFF
     C                   Z-ADD     NWDIFF        ODIFF                          OVERLAY OLD
     C                   ELSE
     C                   CLEAR                   ODIFF                          INIT OLD
     C                   END
      * SQUASH TAG ARRAY...
     C                   EXSR      SQUISH
      *
     C     ENDIT         TAG
      * RESTORE *IN67
      *
     C                   MOVE      SVIN67        *IN67
     C                   MOVE      SVIN93        *IN93
     C                   MOVE      SVIN53        *IN53
     C                   MOVE      SVIN54        *IN54
     C                   MOVE      SVIN64        *IN64
     C                   ENDSR
      *----------------------------------------------------------------*
      * WRITE SUBFILE RECORD
      *----------------------------------------------------------------*
      *
     C     WRTSFL        BEGSR
      *          ------    -----
      *
     C                   MOVE      SV67          *IN67
      *
      * MAKE SURE TAG QTY IS NOT 0...
      *
   HIC*    TREF          IFNE      0
HI   C     TREF          IFNE      *ZEROS
HI   C     TREF          ANDNE     *BLANKS
     C     TQTY          ANDEQ     0
     C                   MOVE      *ON           *IN69
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     UMS(48)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      * MAKE SURE TAG QTY DOES NOT EXCEED SALESORDER QTY...
      *
     C     IVNO07        IFNE      *ZEROS
     C                   MOVE      *IN40         SVIN40
     C     ORDTYP        IFEQ      'SO'
   HIC*    TREF          ANDNE     0
HI   C     TREF          ANDNE     *ZEROS
HI   C     TREF          ANDNE     *BLANKS
     C     TQTY          ANDNE     0
     C     TREF          CHAIN     OELTOHY8                           40
     C     *IN40         IFEQ      *OFF
   JMC*    TAGKY         CHAIN     OELTOLYO                           40
JM J4C*    TAGKYO        CHAIN     OELTOLYN                           40
J4   C     TAGKY         CHAIN     OELTOLYO                           40
     C                   ENDIF
     C                   CLEAR                   QTY1
     C     *IN40         DOWEQ     *OFF
   JMC*                  ADD       OEQY01        QTY1
   JMC*    TAGKY         READE     OELTOLYO                               40
JM J4C*                  ADD       OEQY02        QTY1
JM J4C*    TAGKYO        READE     OELTOLYN                               40
J4   C                   ADD       OEQY01        QTY1
J4   C     TAGKY         READE     OELTOLYO                               40
     C                   ENDDO
     C     TQTY          IFGT      QTY1
     C                   MOVE      *ON           *IN69
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     UMS(49)       MSGFLD
     C                   ENDIF
     C                   ENDIF
JM    * check for transfer qty issue
JM   C                   Else
JM   C                   Move      Tref          TrnNbr            7 0
JM   C     ORDTYP        Ifeq      'TR'
JM   C     TFRKYZ        Chain(N)  IVLTTLZ                            40
JM   C     *IN40         Ifeq      *OFF
JM   C                   MOVE      *OFF          *IN51
JM   C     TQTY          Ifgt      IVQYX2
JM   C                   MOVE      *ON           *IN69
JM   C     MSGFLD        Ifeq      *BLANKS
JM   C                   MOVEL     UMS(67)       MSGFLD
JM   C                   EndIf
JM   C                   EndIf
JM   C                   EndIf
JM   C                   EndIf
     C                   ENDIF
     C                   MOVE      SVIN40        *IN40
      *
      * MAKE SURE TAG QTY DOES NOT EXCEED CONTRACT QTY...
      *
     C                   MOVE      *IN40         SVIN40
     C     ORDTYP        IFEQ      'CO'
   HIC*    TREF          ANDNE     0
HI   C     TREF          ANDNE     *ZEROS
HI   C     TREF          ANDNE     *BLANKS
     C     TQTY          ANDNE     0
     C     OAL8KY        CHAIN     OETOAL8                            40
     C     *IN40         IFEQ      *OFF
     C     TQTY          ANDGT     OEQY10
     C     PNO01         ANDNE     *ZEROS
     C                   MOVE      *ON           *IN69
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(46)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      SVIN40        *IN40
     C                   ENDIF
      *
     C     TAGERR        IFNE      'Y'
   HIC*                  Z-ADD     TREF          SVREF
HI   C                   MOVE      TREF          SVREF
     C                   ENDIF
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
      *
     C     SWITCH        IFEQ      'F'
     C                   WRITE     POS0120R
     C                   ADD       1             RNR
     C                   ELSE
     C                   WRITE     POS0120F
     C                   ADD       1             RNO
     C                   ENDIF
      *
HC   C                   eval      *in78 = *off
     C                   MOVEA     '000'         *IN(80)                        HIGHLITE ERRORS
     C                   MOVEA     '0'           *IN(84)                        HIGHLITE ERRORS
     C                   MOVEA     '0'           *IN(88)                        HIGHLITE ERRORS
     C                   MOVEA     '0'           *IN(58)                        HIGHLITE ERROR
     C                   MOVEA     '0'           *IN(60)                        HIGHLITE ERROR
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN26
     C                   MOVE      *OFF          *IN69
     C                   MOVE      *OFF          *IN88
     C                   ADD       TQTY          FQTY              9 0          TOTAL TAGGED QT
      *
     C                   ENDSR
      *----------------------------------------------------------------*
      * UPDATE EXISTING TAG & HOLD ARRAY
      *----------------------------------------------------------------*
      *
     C     UPDARY        BEGSR
      *          ------    -----
      *
      * ASSIGN NEW KEY ?
      *
     C     KEY           IFEQ      0                                            TAG & HOLD K
     C                   ADD       1             KEY1                           UNIQUE KEY
     C                   Z-ADD     KEY1          KEY                            TAG & HOLD KEY
     C                   ENDIF
      *
      * USE CURRENT VALUE OF Z TO PERFORM LOKUP OPERATION...
      *
     C                   Z-ADD     Z             #                 3 0
      * END OF ARRAY?
     C     Z             IFLE      MAXKY
     C     KEY           LOOKUP    KY(#)                                  40    TAG & HOLD
     C                   ELSE
     C                   MOVE      *OFF          *IN40
     C                   ENDIF
     C     *IN40         IFEQ      *ON                                          EXIST ????
      * SAVE FOUND ELEMENT VALUE OF SUCCESSFUL LOKUP...
     C                   Z-ADD     #             Z
     C     TQTY          IFNE      0                                            TAG QTY
     C     TCOM          ORNE      *BLANKS                                      TAG COMMENTS
     C                   MOVE      'Y'           KEYYN                          TAG & HOLD ?
   HIC*                  Z-ADD     ORDNUM        OREF                           S.O. TAG REF
HI   C                   MOVE      ORDNUM        OREF                           S.O. TAG REF
     C                   MOVE      TLIN          OLIN                           S.O. TAG REF
      * PROCESS EXISTING SFL TAGS, SEE IF AN EARLIER SPACE IN THE
      * ARRAY HAS BECOME AVAILABLE DUE TO ONE OF THE PRIOR TAGS FOR
      * THIS ITEM BEING DELETED.
      * IF A SPACE HAS BECOME AVAILABLE USE IT. THIS WILL KEEP THE
      * TAGS FOR THIS ITEM PACKED...
     C                   Z-ADD     1             NW                3 0
      * IS THERE AN AVAILABLE SPACE ?
     C     *ZEROS        LOOKUP    KY(NW)                                 42
     C     *IN42         IFEQ      '1'
     C     NW            ANDLT     Z
     C                   MOVE      OSK           OS(NW)
     C                   MOVE      KEY           PL(NW)
     C                   MOVE      KEY           KY(NW)
     C                   MOVE      TAGH          TH(NW)                         UPDATE TAG &
     C                   CLEAR                   OS(Z)
     C                   CLEAR                   PL(Z)
     C                   CLEAR                   KY(Z)
     C                   CLEAR                   TH(Z)
     C                   ELSE
     C                   MOVE      OSK           OS(Z)                          S.O. TAG REF
     C                   MOVE      KEY           PL(Z)                          S.O. TAG REF
     C                   MOVE      KEY           KY(Z)
     C                   MOVE      TAGH          TH(Z)                          UPDATE TAG &
     C                   ENDIF
      * DELETE EXISTING SFL TAGS...
     C                   ELSE
     C                   Z-ADD     0             KY(Z)                          KEY ARRAY
     C                   CLEAR                   PL(Z)                          S.O. TAG REF
     C                   CLEAR                   OS(Z)                          S.O. TAG REF
     C                   CLEAR                   TH(Z)
     C                   ENDIF
     C                   ADD       1             Z                              HOLD ARRAY
      *
      * UPDATE NEW TAG & HOLD ARRAY
     C                   ELSE
     C     TQTY          IFNE      0                                            TAG QTY
     C     TCOM          ORNE      *BLANKS                                      TAG COMMENTS
      * PROCESS A NEW TAG,
      * FIND FIRST AVAILABLE SPACE IN ARRAY...
     C                   Z-ADD     1             NW
     C     *ZEROS        LOOKUP    KY(NW)                                 42
     C     *IN42         IFEQ      '0'
     C                   MOVE      '1'           *IN60
     C     MSGFLD        IFEQ      *BLANKS
   JFC*                  MOVEL     EMS(28)       MSGFLD
JF   C                   MOVEL     UMS(66)       MSGFLD
     C                   ENDIF
JF   C                   EXSR      TARERR
     C                   ELSE
     C                   MOVE      'Y'           KEYYN                          TAG & HOLD ?
     C     NW            ADD       1             Z                              NEXT LOKUP
     C                   Z-ADD     KEY           KY(NW)                         KEY ARRAY
     C                   MOVE      TAGH          TH(NW)                         TAG & HOLD DATA
   HIC*                  Z-ADD     ORDNUM        OREF                           S.O. TAG REF
HI   C                   MOVE      ORDNUM        OREF                           S.O. TAG REF
     C                   MOVE      TLIN          OLIN                           S.O. TAG REF
     C                   MOVE      OSK           OS(NW)                         S.O. TAG REF
     C                   MOVE      KEY           PL(NW)                         S.O. TAG REF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *----------------------------------------------------------------*
      * THIS SUBROUTINE SQUASHES THE TAG ARRAY                         *
      *----------------------------------------------------------------*
     C     SQUISH        BEGSR
      * SQUASH ENTIRE TAG ARRAY, FIND THE FIRST ZERO SPACE IN THE ARRAY
      * IF THERE IS A NON-ZERO SPACE AFTER THIS THEN MOVE THE NON-
      * ZERO SPACE TO THE ZERO SPACE,
      * THIS PROCESS IS CONTINUED UNTIL NO ZERO SPACES APPEAR AFTER NON
      * ZERO SPACES IN THE ARRAY...
     C                   Z-ADD     1             FZ                3 0
     C                   Z-ADD     *ZEROS        SQ                3 0
      *
     C     *IN42         DOUEQ     '0'
      * FIND ZERO SPACES...
     C     *ZEROS        LOOKUP    KY(FZ)                                 41
     C     *IN41         IFEQ      '1'
     C                   Z-ADD     FZ            SQ
      * LOOK FOR NON-ZERO SPACES...
     C     *ZEROS        LOOKUP    KY(SQ)                             42
     C     *IN42         IFEQ      '1'
      * MOVE NON-ZERO TO ZERO ELEMENTS IN THE ARRAY...
     C                   MOVE      OS(SQ)        OS(FZ)
     C                   MOVE      PL(SQ)        PL(FZ)
     C                   MOVE      KY(SQ)        KY(FZ)
     C                   MOVE      TH(SQ)        TH(FZ)
      * CLEAR ORIGINAL NON-ZERO POSITIONS...
     C                   CLEAR                   OS(SQ)
     C                   CLEAR                   PL(SQ)
     C                   CLEAR                   KY(SQ)
     C                   CLEAR                   TH(SQ)
     C                   ENDIF
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
I0    *-------------------------------------------------------------------------------------------*
I0    * Check for invalid line insertion...
I0    *-------------------------------------------------------------------------------------------*
I0   C     ChkInsert     Begsr
I0   C                   eval      *IN23 = *off
I0    * Cannot insert comments if receiver found
I0   C     RCVFND        IFEQ      'Y'
I0   C     SEL           IFGE      '1'
I0   C     SEL           ANDLE     '9'
I0   C                   Move      'Y'           InsertError       1
I0   C                   eval      *IN23 = *on
I0   C     ERRFLG        IFNE      'Y'
I0 JNC*                  MOVEL     CMS(2)        MSGFLD
JN   C                   MOVEL     EMS(65)       MSGFLD
I0   C                   MOVE      'Y'           ERRFLG
I0   C                   ENDIF
I0   C                   ENDIF
I0   C                   ENDIF
I0    * Cannot insert comments if LOT PO.
I0   C     POCD42        IFEQ      'Y'
I0   C     SEL           IFGE      '1'
I0   C     SEL           ANDLE     '9'
I0   C                   Move      'Y'           InsertError
I0   C                   eval      *IN23 = *on
I0   C     ERRFLG        IFNE      'Y'
I0   C                   MOVE      'Y'           ERRFLG
I0 JNC*                  MOVEL     CMS(3)        MSGFLD
JN   C                   MOVEL     EMS(66)       MSGFLD
I0   C                   MOVE      'Y'           ERRFLG
I0   C                   ENDIF
I0   C                   ENDIF
I0   C                   ENDIF
I0    * Cannot insert comments if EDI Processing has occurred...
I0   C                   If        EDI = 'Y'
I0   C     SEL           IFGE      '1'
I0   C     SEL           ANDLE     '9'
I0   C                   Call      'EIR9507'
I0   C                   Parm                    PONO01
I0   C                   Parm                    AllowInsert       1
I0   C                   If        AllowInsert <> 'Y'
I0   C                   MOVE      'Y'           ERRFLG
I0 JNC*                  MOVEL     CMS(4)        MSGFLD
JN   C                   MOVEL     EMS(67)       MSGFLD
I0   C                   endif
I0   C                   ENDIF
I0   C                   endif
I0   C                   Endsr
      *----------------------------------------------------------------*
      * THIS SUBROUTINE ALLOWS USER TO SELECT THE S/O LINE ITEM TO BE  *
      * TAGGED                                                         *
      *----------------------------------------------------------------*
     C     SOTAG         BEGSR
     C                   MOVE      'Y'           PTSEL             1
     C                   MOVE      *BLANK        SSELSV            1
     C                   CLEAR                   SVNO22
     C                   CLEAR                   SOMSG
     C                   MOVEA     '1000'        *IN(73)                        CLEAR
     C                   WRITE     POC0120P
     C                   MOVEA     '0000'        *IN(73)
     C                   Z-ADD     0             SORRN             4 0
     C                   Z-ADD     0             SSORRN            4 0
     C                   MOVEL     ZZNO04        PDDS
     C                   MOVE      ZZDN01        PDDS
      * Retrieve original order number;
     C     TREF          CHAIN     OELTOHY8                           40
     C     *IN40         CABEQ     *ON           ENDSO
      * Build subfile of S/O lines for the item being tagged.
     C     TAGKY         CHAIN     OELTOLYO                           40
     C     *IN40         DOWEQ     *OFF
     C     OECD01        ANDNE     'D'                                          DIRECT ?
     C     TAGKY         READE     OELTOLYO                               40
     C                   ENDDO
     C     *IN40         CABEQ     *ON           ENDSO
     C     *IN40         DOWEQ     *OFF
     C     OECD01        IFEQ      'D'                                          DIRECT
     C                   ADD       1             SORRN
     C                   CLEAR                   SSEL
     C                   Z-ADD     ONO15         PL#
      * Protect if already tagged to another PO.
     C     PNO01         IFNE      PONO01
     C     PNO01         ANDNE     *ZEROS
      * OR ALREADY TAGGED TO A TRANSFER.
     C     OENO60        ORNE      *ZEROS
     C                   MOVE      *ON           *IN44
     C                   ELSE
     C                   MOVE      *OFF          *IN44
     C                   ENDIF
      * If already tagged on another line, display the line number.
     C                   Z-ADD     1             ZZ
   HIC*                  Z-ADD     ONO26         OREF
HI   C                   MOVE      ONO26         OREF
     C                   Z-ADD     OENO22        OLIN
     C     OSK           LOOKUP    OS(ZZ)                                 41
     C     *IN41         IFEQ      *ON
     C                   Z-ADD     PONO01        PNO01
     C     PL(ZZ)        IFNE      KEY                                          LINE# DIFF
     C                   Z-ADD     PL(ZZ)        PL#                            LINE REF#
     C                   MOVE      *ON           *IN44
     C                   ELSE
     C                   MOVE      'X'           SSEL                           PREV TAG
     C                   MOVE      'X'           SSELSV                         PREV TAG
     C                   MOVE      *OFF          *IN44
     C                   ENDIF
     C                   ENDIF
      * Set flag to indicate that there is at least one line where the
      * select field is not protected.
     C     *IN44         IFEQ      *OFF
     C                   MOVE      'N'           PTSEL
     C                   ENDIF
      * Write subfile record
     C                   WRITE     POS0120P
     C                   ENDIF
     C     TAGKY         READE     OELTOLYO                               40
     C                   ENDDO
      *
      * If no records were written to the subfile,
      * -or-
      * If PTSEL = 'Y'
      * Then there are no sales order lines available for tagging.
     C     SORRN         IFEQ      *ZEROS
     C     PTSEL         OREQ      'Y'
     C                   MOVE      *ON           *IN88                          HIGHLIGHT ERROR
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(32)       MSGFLD
     C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       ENDSO
     C                   ENDIF
      * Find out if there is only one line on the S/O that has a
      * quantity that matches the quantity being tagged.
     C                   Z-ADD     1             SORRN
     C     SORRN         CHAIN     POS0120P                           40
     C     *IN40         DOWEQ     *OFF
     C     QTY           IFEQ      OEQY01
     C     SSORRN        CABNE     *ZEROS        DSPSO                          duplicate
     C                   Z-ADD     SORRN         SSORRN
     C                   ENDIF
     C                   ADD       1             SORRN
     C     SORRN         CHAIN     POS0120P                           40
     C                   ENDDO
      * If only one line was found with a matching quantity, attempt
      * to auto tag.
     C     SSORRN        IFNE      *ZEROS                                       unique
     C     SSORRN        CHAIN     POS0120P                           40
      * If S/O line not previously tagged, and PO line not previously
      * tagged---> auto tag!
     C     *IN40         IFEQ      *OFF
     C     PL#           ANDEQ     *ZEROS
     C     SSELSV        ANDNE     'X'
      * If they are already tagged to each other, since there are no
      * other lines with matching quantity---> skip display of subfile!
     C     *IN40         OREQ      *OFF
     C     PL#           ANDEQ     *ZEROS
     C     SSEL          ANDEQ     'X'
     C                   Z-ADD     OENO22        SVNO22
     C     SVNO22        CABNE     *ZEROS        ENDSO                          auto tag
     C                   ENDIF
     C                   ENDIF
      *
      * Display subfile of S/O lines for this item.
     C     DSPSO         TAG
     C                   MOVEA     '0011'        *IN(73)
     C                   WRITE     POF0120P                                     CMD KEY FORMAT
     C                   EXFMT     POC0120P
     C                   MOVEA     '0000'        *IN(73)
     C                   MOVE      *ON           *IN35
      *
      * Call help text.
      *
     C     *IN25         IFEQ      *ON                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     *ON           DSPSO
     C                   ENDIF
      *
      * F3 Exit.
      *
     C     *IN56         IFEQ      *ON                                          MESSAGE DISP
     C     *IN03         CABEQ     *ON           ENDSO                          F3 EXIT
     C                   ENDIF
     C     *IN03         IFEQ      *ON                                          F3 EXIT
     C                   MOVE      *ON           *IN56                          MESSAGE DISPLAY
     C                   MOVE      *OFF          *IN35
     C                   MOVEL     UMS(10)       SOMSG
     C     *IN03         CABEQ     *ON           DSPSO
     C                   ENDIF
     C                   MOVE      *OFF          *IN56                          MESSAGE DISPLAY
      * If multiple lines were selected, display an error message...
     C                   Z-ADD     *ZEROS        SELCNT            1 0
     C                   Z-ADD     1             SORRN
     C     SORRN         CHAIN     POS0120P                           40
     C     *IN40         DOWEQ     *OFF
     C     SSEL          IFNE      *BLANK
     C                   ADD       1             SELCNT
     C     SELCNT        IFGT      1
     C                   MOVEL     EMS(51)       SOMSG
     C     SOMSG         CABNE     *BLANKS       DSPSO
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             SORRN
     C     SORRN         CHAIN     POS0120P                           40
     C                   ENDDO
      * Process subfile selection.
     C                   MOVE      *OFF          *IN40
     C                   CLEAR                   SVNO22
     C                   Z-ADD     1             SORRN
     C     SORRN         CHAIN     POS0120P                           40
     C     *IN40         DOWEQ     *OFF
     C     SSEL          IFNE      *BLANK
     C                   MOVE      *OFF          *IN35
     C                   Z-ADD     OENO22        SVNO22
     C                   CLEAR                   SSEL
     C                   UPDATE    POS0120P
     C     SVNO22        CABNE     *ZEROS        ENDSO
     C                   ENDIF
     C                   ADD       1             SORRN
     C     SORRN         CHAIN     POS0120P                           40
     C                   ENDDO
      * F12 Previous.
     C     *IN12         CABEQ     *ON           ENDSO                          F12-PREVIOUS
      * If no selection made, redisplay.
     C     *IN35         CABEQ     *ON           DSPSO
      *
     C     ENDSO         ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    LINE ITEM PRICES                                        *
      *------------------------------------------------------------------------*
     C     PRCSR         BEGSR
KM   C                   MOVE      *IN27         SVIN27            1
KM   C                   MOVE      *IN29         SVIN29            1
      *
      * SAVE INDICATOR USED ON HEADER SCREEN.
     C                   MOVE      *IN34         SVIN34            1
     C     LASTTM        IFEQ      ' '
     C                   MOVE      'Y'           LASTTM            1
     C                   MOVE      TPRD          PRD
     C                   SELECT
     C     TPRD          WHENEQ    '1'
     C                   MOVE      F17DS         F17HDG
     C                   MOVE      F17PRD        F17TXT
     C     TPRD          WHENEQ    '2'
     C                   MOVE      F17PR         F17HDG
     C                   MOVE      F17MNF        F17TXT
     C     TPRD          WHENEQ    '3'
     C                   MOVE      F17MN         F17HDG
     C                   MOVE      F17DSC        F17TXT
     C                   ENDSL
     C                   ENDIF
JL    * SET SPECIAL PRICING INDICATOR
JL   C                   eval      *in55  = *on
JL   C                   if        splprcaut = 'Y'
JL   C                   eval      *in55  = *Off
JL   C                   endif
      *
     C     RELOAD        TAG
KM   C                   EVAL      *IN27 = *OFF
KM   C                   IF        ALWPSSTS = 'Y'
KM   C                   EVAL      *IN27 = *ON
KM   C                   ENDIF
      * CLEAR SUBFILE
     C                   MOVE      *IN63         SVIN63            1
     C                   MOVE      *OFF          *IN63
     C                   MOVEA     '1'           *IN(73)                        CLEAR
     C                   WRITE     POC0120G                                     PRICING S/F
     C                   MOVEA     '0'           *IN(73)                        SETOF *IN
     C                   MOVEA     '0'           *IN(57)                        EXTENDED DESC
     C                   MOVEA     '0'           *IN(65)                        MANDATORY COST
     C                   MOVE      *OFF          *IN60
     C                   MOVE      'P'           WHERE             1            PRICING S/F
     C                   EXSR      LOAD                                         LOAD SUBROUTINE
     C                   Z-ADD     1             RRN
     C                   MOVE      ' '           WHERE                          PRICING S/F
     C     SVCD36        IFEQ      'Y'                                          EXTENDED DESC ?
     C                   MOVEA     '1'           *IN(85)                        REVERSE IMAGE
     C                   END                                                    CMD 07-EXTEND
      *
      * DISPLAY ENTRY SCREEN
     C     DSPPRC        TAG
     C     ERRFLG        IFEQ      'Y'
     C                   MOVE      SAVRRN        RRN
     C                   ENDIF
     C                   MOVE      ' '           ERRFLG
     C                   MOVE      *OFF          *IN65
¢E #9C*                  MOVE      *OFF          *IN23                          Mfg# Required  ECT
     C                   MOVE      ' '           CHGSFG
     C                   MOVEA     '110'         *IN(75)                        DSPLY SUB & CNT
:A   C     PO_OpnCls     IFEQ      ' '
:A   C     PO_OpnCls     OREQ      'O'
:A   C     OpenLines     ANDEQ     0
     C                   WRITE     POF0120G                                     CMD KEY FORMAT
     C                   EXFMT     POC0120G                                     PRICING CNTL RC
:A   C                   ENDIF
     C                   MOVE      *BLANKS       MSGFLD
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
   ¢VC*                  MOVE      MODE          *IN28
     C                   Z-ADD     0             POTL01                         SUB-TOTAL
JY   C                   Z-ADD     0             XXTL01
IO   C                   Z-ADD     0             LSTTOTAL
IO   C                   Z-ADD     0             WGTTOT
IO   C                   Z-ADD     0             CUBTOT
IO   C                   Z-ADD     0             PCSTOT
     C                   Z-ADD     0             RNSAV             3 0
I0   C                   CLEAR                   INSX
     C                   MOVE      ' '           ERRFLG                         RESET FLAG
     C                   MOVEA     '0'           *IN(71)
     C                   Z-ADD     CPFRRN        THERRN                         CURRENT RRN  POS
JL   C                   eval      fl67cnt = *zeros
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C                   READ      POF0120G                               41
     C     *IN25         CABEQ     '1'           DSPPRC
     C                   END
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           ENDPRC                         CMD 03 RETURN
     C                   END
     C     *IN03         IFEQ      *ON
     C                   MOVE      UMS(10)       MSGFLD
     C     *IN03         CABEQ     '1'           DSPPRC                   56    CMD 03 RETURN
     C                   ENDIF
     C                   CLEAR                   MSGFLD
     C                   MOVEA     '0'           *IN(56)                        MESSAGE DISPLAY
      *
     C     *IN12         CABEQ     '1'           ENDPRC                         CMD 12-PREVIOUS
      *
      * PROCESS F4 (PROCESS SELECTION DURING SFL READ LOOP BELOW)...
     C     *IN04         IFEQ      *ON
     C                   EXSR      @PRMPT
     C                   ENDIF
     C                   EXSR      @CLCSR
      *
      * CMD 14 EXTENDED DESCRIPTION ?
     C     *IN14         IFEQ      '1'                                          CMD 14 EXT DESC
     C                   MOVEA     '0'           *IN(55)                        VERIFY MSG
     C     *IN57         IFEQ      '1'                                          57 ON EXT DESC
     C                   MOVE      '0'           *IN(57)
     C                   ELSE
     C                   MOVE      '1'           *IN(57)
     C                   END
     C                   MOVEA     '1'           *IN(73)                        CLEAR
     C                   WRITE     POC0120G                                     PRICING S/F
     C                   MOVEA     '0'           *IN(73)                        SETOF *IN
     C                   MOVE      'P'           WHERE                          PRICING S/F
     C                   EXSR      LOAD
     C                   MOVE      ' '           WHERE                          PRICING S/F
     C                   Z-ADD     1             RRN                            POSTION SFL
     C     *IN14         CABEQ     '1'           DSPPRC
     C                   END
     C     *IN17         IFEQ      *ON
     C                   SELECT
     C     PRD           WHENEQ    '1'
     C                   MOVE      '2'           PRD               1
     C                   MOVE      F17PR         F17HDG
     C                   MOVE      F17MNF        F17TXT
     C     PRD           WHENEQ    '2'
     C                   MOVE      '3'           PRD
     C                   MOVE      F17MN         F17HDG
     C                   MOVE      F17DSC        F17TXT
     C     PRD           WHENEQ    '3'
     C                   MOVE      '1'           PRD
     C                   MOVE      F17DS         F17HDG
     C                   MOVE      F17PRD        F17TXT
     C                   ENDSL
     C                   CLEAR                   PDDS35
#4   C                   CLEAR                   PDDS20
     C                   GOTO      RELOAD
     C                   ENDIF
KM    *
KM    * Override Price Sheet Status?
KM   C                   IF        OVRSTS <> *BLANKS
KM   C                   MOVE      'Y'           HDRSTS            1
KM   C                   MOVE      OVRSTS        SVPSTS            1
KM   C                   MOVE      OVRA_O        SVPSAO            1
KM   C                   CLEAR                   OVRSTS
KM   C                   CLEAR                   OVRA_O
KM   C                   ELSE
KM   C                   MOVE      'N'           HDRSTS            1
KM   C                   CLEAR                   SVPSTS
KM   C                   CLEAR                   SVPSAO
KM   C                   ENDIF
      *
      * HEADER FACTOR ?
     C     HDDISC        IFNE      *BLANKS                                      HEADER FACTOR
     C                   MOVE      'Y'           HDRFAC            1            HEADER FACTOR
     C                   MOVE      HDDISC        SVDISC            8            SAVE HDR FACTOR
     C                   MOVE      *BLANKS       HDDISC                         HEADER FACTOR
     C                   ELSE
     C                   MOVE      'N'           HDRFAC            1            HEADER FACTOR
     C                   MOVE      *BLANKS       SVDISC                         SAVE HDR FACTOR
     C                   END
      *
HZ   C                   Clear                   InventoryTotal
     C                   Z-ADD     1             RELREC            4 0
     C     *IN40         DOUEQ     '1'
     C     RELREC        CHAIN     POS0120G                           40        PRICING S/F
     C     *IN40         IFEQ      '0'
     C                   MOVE      ' '           CHGPUM
     C     TYP           CABEQ     ' '           ENDSFL
     C                   ADD       1             RNSAV
IM    *
IM   C     TYP           IFEQ      'N'                                          non stock
IM   C                   MOVEA     '1'           *IN(60)                        PROTECT
IM   C                   END
      *
     C     TYP           IFEQ      'E'                                          EXTENDED DESC
IM   C                   MOVEA     '1'           *IN(60)                        PROTECT
     C                   SUB       1             RNSAV
     C                   MOVEA     '1'           *IN(82)                        PROTECT/NONDSP
¢E #9C*                  MOVEA     '0'           *IN(23)                        PROTECT/NONDSP
     C     TYP           CABEQ     'E'           PRCEND                         EXTENDED DESC
     C                   END
      *
     C     TYP           IFEQ      'C'                                          COMMENTS
IM   C                   MOVEA     '1'           *IN(60)                        PROTECT
     C                   MOVEA     '1'           *IN(82)                        PROTECT/NONDSP
     C     TYP           CABEQ     'C'           PRCEND                         COMMENTS
     C                   END
      *
     C     TYP           IFEQ      'D'                                          COMMENTS
     C                   MOVE      *ON           *IN21                          PROTECT/NONDSP
     C     TYP           CABEQ     'D'           PRCEND                         COMMENTS
     C                   ENDIF
      *
      *  CHECK FOR NEGATIVE LIST
      *
     C     LIST          IFLT      0
     C                   MOVE      *ON           *IN63
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      'Y'           ERRFLG
     C                   Z-ADD     RELREC        SAVRRN
     C                   MOVE      UMS(9)        MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
     C     RNSAV         OCCUR     SAVDS                                        DATA STRUCTURE
KM    *
KM    * Process price sheet retrieval based on status override
KM   C                   EVAL      *IN29 = *OFF
KM   C                   IF        HDRSTS = 'Y'
KM   C                   IF        TYP = 'O' OR TYP = 'P'
KM   C                   IF        PSSTS <> SVPSTS
KM   C                   CLEAR                   PSWARN
KM   C                   CLEAR                   DPSWARN
KM    * CALL PROGRAM TO RETRIEVE NEW COST
KM   C                   CALL      'POR0123'     PL0123
KM   C                   MOVE      PSOVR         DPSOVR
KM    * IF FOUND ON P/S OVERRIDE STATUS SHEET
KM   C                   IF        GOTOVR = 'Y'
KM   C                   IF        COST <> DCST
KM   C                              OR LIST <> DLST
KM   C                   EVAL      DLST = LIST
KM   C                   EVAL      DCST = COST
KM   C                   IF        DDSC <> DISC
KM   C                   MOVE      'Y'           DOVR                           DISC OVRRIDE
KM   C                   MOVE      'Y'           DDOV                           DISC OVRRIDE
KM   C                   ENDIF
KM   C                   EVAL      DDSC = DISC
KM   C                   MOVE      'Y'           COVR                           COST OVRRIDE
KM   C                   MOVE      'Y'           DCOV                           COST OVRRIDE
KM   C                   MOVE      PSNME         DPSNME
KM   C                   MOVE      PSCTNM        DPSCTNM
KM   C                   MOVE      PSSTS         DPSSTS
KM   C                   MOVE      PSTYPE        DPSTYPE
KM   C                   ENDIF
KM   C                   ELSE
KM   C                   IF        PSWARN <> 'Y'
KM   C                   EVAL      PSWARN = 'Y'
KM   C                   EVAL      DPSWARN = 'Y'
KM    * SET INDICATOR TO FLAG ITEM NOT ON P/S OVERRIDE STATUS SHEET
KM   C                   EVAL      *IN29 = *ON
KM   C                   EVAL      MSGFLD = 'Item not found on price sheet or-
KM   C                              cost has not changed.'
KM   C                   ENDIF
KM   C                   ENDIF
KM   C                   ENDIF
KM   C                   ENDIF
KM   C                   ENDIF
      *
     C     HDRFAC        IFEQ      'Y'                                          HEADER DISCOUNT
     C     LIST          IFNE      0                                            LIST
   HNC*    DOVR          IFEQ      *BLANK
HN   C     DOVR          IFNE      'Y'
     C                   MOVE      SVDISC        DISC                           DISCOUNT
     C                   END
     C                   EXSR      FACTOR                                       COMPUTE COST
     C                   MOVE      ' '           COVR                           COST OVRRDE
     C                   ELSE
     C                   MOVE      *BLANKS       DISC                           DISCOUNT
     C                   MOVE      ' '           DOVR                           DISCOUNT OVRRDE
     C     COST          IFNE      DCST                                         COST OVRRIDE ?
     C                   MOVE      'Y'           COVR                           COST OVRRIDE
     C                   END
     C                   END
     C                   END
      *
     C     HDRFAC        IFNE      'Y'                                          HEADER DISCOUNT
     C     LIST          IFEQ      0                                            LIST
     C                   MOVE      *BLANKS       DISC                           DISCOUNT
     C                   MOVE      ' '           DOVR                           DISCOUNT OVRRDE
     C     COST          IFNE      DCST                                         COST OVRRIDE ?
     C                   MOVE      'Y'           COVR                           COST OVRRIDE
     C                   END
     C                   ELSE
     C     DISC          IFNE      *BLANKS                                      LINE DISCOUNT
     C                   EXSR      FACTOR                                       COMPUTE COST
     C                   MOVE      ' '           COVR                           COST OVRRDE
     C     DISC          IFNE      DDSC                                         DISC OVRRIDE ?
     C                   MOVE      'Y'           DOVR                           DISC OVRRIDE
     C                   END
     C                   ELSE
     C                   MOVE      ' '           DOVR
     C     COST          IFEQ      0
     C     COVR          ANDNE     'Y'                                          NO OVERRIDE
     C                   Z-ADD     LIST          COST
IY I4C*                  If        (LIST   <>    COST)
I4   C                   If        LIST > 99999.9999
I4   C                   eval      Cost = 0
IY   C                   MOVE      UMS(65)       MSGFLD
IY   C                   MOVE      '1'           *IN63
IY   C                   MOVE      'Y'           ERRFLG
IY   C                   Z-ADD     RELREC        SAVRRN
IY I4 *  Reset Cost if Truncation occurs
IY I4C*                  EVAL      COST = DCST
IY   C                   Endif
     C                   END
     C     COST          IFNE      DCST                                         COST OVRRIDE ?
I4   C                   If        LIST <= 99999.9999
     C                   MOVE      'Y'           COVR                           COST OVRRIDE
I4   C                   Endif
     C                   END
     C                   END
     C                   END
     C                   END
KM    * If Price Sheet is overridden from current-set override flags
KM   C     PSOVR         IFEQ      'Y'
KM   C                   MOVE      'Y'           COVR                           COST OVRRIDE
KM   C                   MOVE      'Y'           DCOV                           COST OVRRIDE
KM   C                   ENDIF
      *
      *  CHECK FOR NEGATIVE COST
      *
     C     COST          IFLT      0
     C                   MOVE      *ON           *IN64
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      'Y'           ERRFLG
     C                   Z-ADD     RELREC        SAVRRN
     C                   MOVE      UMS(8)        MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
      * TEST FOR ANY CHANGED DATA...
     C     DOVR          IFNE      DDOV
     C     COVR          ORNE      DCOV
     C     LIST          ORNE      DLST
     C     COST          ORNE      DCST
     C     DISC          ORNE      DDSC
     C     PUOM          ORNE      DUMP
     C     HDRFAC        OREQ      'Y'
KM   C     HDRSTS        OREQ      'Y'
     C                   MOVE      'Y'           CHGSFG            1
     C     PUOM          IFNE      DUMP
#4   C     VENQ          ORNE      DVENQ
     C                   MOVE      'Y'           CHGPUM            1
     C                   ENDIF
     C                   ENDIF
      * VALIDATE AND RETREIVE THE PRICING UOM FACTOR ONLY WHEN THE
      * PRODUCT OR THE PRICING UOM HAS BEEN CHANGED...
      * THIS WILL PREVENT RE-PULL OF THE PRICING UOM FACTOR FOR
      * UNCHANGED ITEMS WHOSE PRICING UOM MAY HAVE BEEN CHANGED AT
      * THE ITEM MASTER LEVEL AFTER THIS P/O WAS CREATED...
     C     DNO7          IFNE      0
      * VALIDATE PRICING UOM SFL FLD, AND GET UOM FACTOR...
     C     DNO7          IFNE      IVNO7
     C     CHGPUM        OREQ      'Y'
     C     PUOM          IFEQ      SUOMSF                                       STOCKING ?
     C                   Z-ADD     1             PUOMSF
     C                   ELSE
     C     PUOM          IFEQ      RUOMSF                                       REFERENCE ?
     C                   Z-ADD     RUOMDQ        PUOMSF
     C                   ELSE
     C                   Z-ADD     DNO7          AUOMI#
     C                   MOVE      PUOM          AUOMOU
     C                   CALL      'POR0117'     PL0117                         UOM API
     C     AUOMOU        IFNE      *BLANKS
     C     AUOMRC        ANDNE     '1'
     C     AUOMOF        IFNE      *ZEROS
     C                   Z-ADD     AUOMOF        PUOMSF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN01
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      *ON           *IN(59)
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   Z-ADD     RELREC        SAVRRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * IF F4 PRESSED AND A UOM SELECTION MADE FOR THIS SFLRCD, THEN
      * LOAD THE SELECTION DATA INTO THE SFL/DS FIELDS...
     C     *IN04         IFEQ      *ON
     C     UOMSEL        ANDEQ     'Y'
     C     CRRN          ANDEQ     RELREC
     C                   MOVE      UOMWK         PUOM
     C                   Z-ADD     FACTO         PUOMSF
     C                   ENDIF
     C                   ENDIF
      * IF PRICING UOM BLANK, DISPLAY ERROR...
     C     DNO7          IFNE      0
     C     PUOM          ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN01
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      *ON           *IN(59)
     C                   MOVE      'Y'           ERRFLG                         ERROR OCCURED
     C                   Z-ADD     RELREC        SAVRRN
     C                   ENDIF
     C                   ENDIF
      *
      * IF THE PRICING UOM HAS BEEN CHANGED FOR STOCK ITEMS, BUT THE
      * THE USER DID NOT CHANGE THE LIST,COST, OR COST FACTOR, THEN
      * AUTO-CALC THE NEW LIST/COST BASED ON ANY CHANGE IN UOM FACTORS.
      * FOR EXAMPLE:   BEF  UOM=CTN(10)   LIST=100 COST=50
      *                AFT  UOM=BOX(20)   LIST=200 COST=100
      *
     C     DNO7          IFNE      0
     C     PUOM          ANDNE     DUMP
     C     DOVR          ANDEQ     DDOV
     C     COVR          ANDEQ     DCOV
     C     LIST          ANDEQ     DLST
     C     COST          ANDEQ     DCST
     C     DISC          ANDEQ     DDSC
      *  IF NOT GOING TO STOCKING LEVEL, THEN CALCULATE FACTOR...
     C     PUOMSF        IFNE      1
      *  BUT ONLY IF UOM EXISTS, OWSE LEAVE LIST/COST AS IS...
      *  (I.E. USER ACCIDENTALLY HIT FIELD EXIT...)
     C     PUOMDF        IFNE      0
     C     PUOMSF        ANDNE     0
     C     PUOMSF        DIV       PUOMDF        WK155            15 5          (20/10)=2
     C                   MULT(H)   WK155         LIST                           RE-FACTOR
     C                   MULT(H)   WK155         COST                               "
     C                   ENDIF
     C                   ELSE
      *  IF GOING TO STOCKING LEVEL, THEN USE CURRENT STOCKING AMTS...
      *  (PREVENTS "LOST DECIMAL" (ROUNDING) TYPE PROBLEMS)
     C                   Z-ADD     PUAMSL        LIST
     C                   Z-ADD     PUAMSF        COST
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      DOVR          DDOV                           DISCOUNT OVRRDE
     C                   MOVE      COVR          DCOV                           COST OVRRDE
     C                   Z-ADD     LIST          DLST                           MANUF LIST
     C                   Z-ADD     COST          DCST                           RPLC COST
     C                   MOVE      DISC          DDSC                           DISCOUNT
     C                   MOVE      PUOM          DUMP                           PRICING UOM
     C                   Z-ADD     0             AMT
      *
      * PLACE THE PRICING UOM SFL FACTOR INTO DS FIELD...
     C                   Z-ADD     PUOMSF        PUOMDF
      * ------------------------
      * CONVERT THE CURRENT COST DOWN TO THE STOCKING LEVEL...
      * ------------------------
     C     PUOMDF        IFNE      0
     C     COST          DIV(H)    PUOMDF        FCTAMT           11 5          GET STCK AMT
     C                   ELSE
     C                   CLEAR                   FCTAMT
     C                   ENDIF
      * PLACE THE STOCKING COST INTO SFL & DS FIELDS...
     C                   Z-ADD(H)  FCTAMT        PUAMSF
     C                   Z-ADD(H)  FCTAMT        PUAMDF
      * ------------------------
      * CONVERT THE CURRENT LIST DOWN TO THE STOCKING LEVEL...
      * ------------------------
     C     PUOMDF        IFNE      0
     C     LIST          DIV(H)    PUOMDF        FCTAMT                         GET STCK AMT
     C                   ELSE
     C                   CLEAR                   FCTAMT
     C                   ENDIF
      * ---------------------------------------------------------------
      * PLACE THE STOCKING LIST INTO SFL & DS FIELDS...
     C                   Z-ADD(H)  FCTAMT        PUAMSL
     C                   Z-ADD(H)  FCTAMT        PUAMDL
      * EXTEND COST...
     C                   Z-ADD     PUOMSF        $PRFCT
     C                   Z-ADD     UQYDF         $STQTY
     C                   Z-ADD     COST          $PRCST
     C                   EXSR      @EXCST
JY   C                   add(h)    $excst        xxtl01
     C                   ADD(H)    $EXCST        POTL01
IO   C                   ADD(H)    $LSTCST       LSTTOTAL         11 2
IO   C                   ADD(H)    $WEIGHT       WGTTOT
IO   C                   ADD(H)    $CUBES        CUBTOT
IO   C                   ADD(H)    $PIECES       PCSTOT
HS   C                   Eval      SExtCost = $ExCst
HZ    * Accumulate total for inventory items only......
HZ   C     DNO7          setll     MSTRIN
IH    * Bypass Non Inventory items (but include non-stocks)...
HZ   C                   If        %equal
IH   C                             or DNO7 = *zero
HZ   C                   ADD(H)    $EXCST        InventoryTotal
HZ   C                   EndIf
      *
      * WHEN PRICE FACTOR IN DECIMAL, SET *IN34 TO *ON TO DISPLAY
      * PRICE FACTOR IN DECIMAL,
      * ELSE SET *IN34 TO *OFF TO DISPLAY AS WHOLE NUMBER.
     C                   Z-ADD     PUOMSF        XUOMSF
     C     RDEC          IFNE      0
     C                   MOVE      '1'           *IN34
     C                   ELSE
     C                   MOVE      '0'           *IN34
     C                   ENDIF
     C     DOVR          IFEQ      'Y'
     C                   MOVEA     '1'           *IN(80)                        HIGHLITE OVRRDE
     C                   END
     C     COVR          IFEQ      'Y'
     C                   MOVEA     '1'           *IN(81)                        HIGHLITE OVRRDE
     C                   END
     C     ZCOST         IFNE      'Y'
     C     COST          ANDEQ     0                                            COST = 0?
     C                   MOVEA     '00'          *IN(80)
     C                   MOVE      '1'           *IN64                          RI PC
     C     *IN65         IFEQ      '0'                                          NO ERR YET?
     C                   MOVE      '1'           *IN65                          SFLMSG
     C     ERRFLG        IFNE      'Y'
     C                   MOVE      'Y'           ERRFLG
     C                   MOVE      UMS(12)       MSGFLD
     C                   Z-ADD     RELREC        SAVRRN            4 0          SAV 1ST ERR
     C                   ENDIF
     C                   END
     C                   END

¢9    * IF Direct PO check sell price and sell cost
#7                       IF oecd01 = 'D';
#7                         days   =  0;
#7                         ORDRMO =  ARMO05;
#7                         ORDRDY =  ARDY05;
#7                         ORDRCC =  ARCC05;
#7                         ORDRYR =  ARYR05;
#7                         If ORDCYMD <> 0;
#7         days = %ABS(%Diff(%date(ORDCYMD : *iso): today: *days));
#7                         endif;
#7                       endif;

¢9   C     OECD01        IFEQ      'D'
¢9   C     COST          ANDGE     DSSELPRC                                     COST = 0?
¢9   C     DSSELCST      ANDGT     DSSELPRC                                     COST = 0?
#7   C     days          ANDLT     180
¢9   C                   MOVEA     '00'          *IN(80)
¢9   C                   MOVE      '1'           *IN64                          RI PC
¢9   C     *IN65         IFEQ      '0'                                          NO ERR YET?
¢9   C                   MOVE      '1'           *IN65                          SFLMSG
¢9   C     ERRFLG        IFNE      'Y'
¢9   C                   MOVE      'Y'           ERRFLG
¢9   C                   MOVE      CMS(15)       MSGFLD
¢9   C                   Z-ADD     RELREC        SAVRRN            4 0          SAV 1ST ERR
¢9   C                   ENDIF
¢9   C                   END
¢9   C                   END
      * IF PURCHASING UOM SAME AS STOCKING, OR IF ITEM IS A NON STOCK,
      * THEN DO NOT DISPLAY STOCKING DATA...
     C     QTY           IFEQ      UQYSF
     C     DNO7          OREQ      0
     C                   MOVE      *ON           *IN26                          NON DISPLAY
     C                   ENDIF
     C     PRCEND        TAG
JL    *
JL    *  CHECK SPECIAL PRICING FLAG
JL    *
JL   C                   if        splprcaut = 'Y'
JL   C                   if        typ <> 'C' and typ <> 'E'
JL   C                             and typ <> 'D'
JL    *
JL   C                   if        fl67 <> 'Y' and fl67 <> 'N'
JL   C                   eval      *in58 = *on
JL   C                   eval      *in28 = *off
JL   C     ERRFLG        IFNE      'Y'
JL   C                   MOVE      'Y'           ERRFLG
JL   C                   Z-ADD     RELREC        SAVRRN
JL   C                   eval      MSGFLD = 'Special pricing must be Y or N.'
JL   C                   ENDIF
JL   c                   else
JL   C     rnsav         occur     savds                                        DATA STRUCTURE
JL   C                   eval      dfl67 = fl67
JL   C                   if        fl67 = 'Y'
JL   C                   eval      fl67cnt = fl67cnt +1
JL   C                   endif
JL   C                   ENDIF
JL    *
JL   C                   endif
JL    *
JL   C                   if        typ = 'C' or typ = 'E'
JL   C                             or typ = 'D'
JL   C                   eval      *in55  = *On
JL   C                   else
JL   C                   eval      *in55  = *Off
JL   C                   endif
JL    *
JL   c                   endif
      * PROTECT UOM FIELDS IF QTY'S HAVE BEEN RECEIVED...
     C     QTYR          IFNE      0                                            QTY RECEIVED
     C                   MOVE      *ON           *IN60
     C                   ENDIF
#4   C                   eval      DVENQ = VENQ
      *
     C                   UPDATE    POS0120G
     C                   MOVE      *OFF          *IN21                          RESET- RI PC
     C                   MOVE      *OFF          *IN71
     C                   MOVEA     '000'         *IN(80)                        HIGHLITE OVRRDE
     C                   MOVE      *OFF          *IN63                          RESET- RI PC
     C                   MOVE      '0'           *IN64                          RESET- RI PC
     C                   MOVE      *OFF          *IN26                          NON DISPLAY
     C                   MOVE      *OFF          *IN01                          HIGHLITE ERROR
     C                   MOVE      *OFF          *IN60
     C                   ADD       1             RELREC
JL   C                   eval      *in58 = *off
      *
     C                   END
     C                   END
JL    * Check special pricing
JL   C                   if        splprcaut = 'Y'
JL   C                   if        errflg <> 'Y'
JL   C                   if        pofl67 = 'Y'
JL   C                             and fl67cnt = *zeros
JL   C                   eval      *in28  = *off
JL   C                   eval      errflg = 'Y'
JL   C                   eval      savrrn = 1
JL   C                   eval      msgfld =  'At least one item must be marked -
JL   c                             for special pricing.'
JL   c                   else
JL   C                   eval      *in28  = *on
JL   C                   endif
JL   C                   endif
JL   C                   endif
     C     ERRFLG        CABEQ     'Y'           DSPPRC
      *
      * IF F4 WAS PRESSED, THEN REDISPLAY SCREEN...
     C     *IN04         IFEQ      *ON
     C     CRRN          IFGT      0
     C                   Z-ADD     CRRN          RRN
     C                   ENDIF
     C                   GOTO      DSPPRC
     C                   ENDIF
     C     ENDSFL        TAG
      * IF ANY CHANGES OCCURRED ON SCREEN, THEN RE-DISPLAY...
     C     CHGSFG        IFEQ      'Y'
     C                   Z-ADD     THERRN        RRN
     C     CHGSFG        CABEQ     'Y'           DSPPRC                         CHANGES ?
     C                   ENDIF
     C     ENDPRC        TAG
     C                   MOVEA     '1'           *IN(77)                        DELETE S/F
     C                   WRITE     POC0120G                                     PRICING S/F
     C                   MOVEA     '0'           *IN(77)                        DELETE S/F
     C                   MOVE      SVIN63        *IN63
      *
      * RETURN INDICATOR VALUE BACK.
KM   C                   MOVE      SVIN27        *IN27
KM   C                   MOVE      SVIN29        *IN29
     C                   MOVE      SVIN34        *IN34
JL   C                   eval      *in28  = *on
     C                   ENDSR
      *------------------------------------------------------------------------*
      *          COMPUTE TRADE & COST BY FACTORS                               *
      *------------------------------------------------------------------------*
     CSR   FACTOR        BEGSR
     C                   MOVEA     DISC          FC                             FACTOR
     C                   Z-ADD     0             COST1
     C                   MOVE      '0'           *IN71
     C                   MOVE      DISC          PCPC01
      *
      * TEST DISCOUNT PERCENT
     C     FC(1)         IFEQ      '.'
     C                   Z-ADD     0             PCTST             3 0
     C                   Z-ADD     1             J                 3 0
     C     J             DOUGE     8
     C                   ADD       1             J
     C     FC(J)         IFNE      ' '
     C     FC(J)         IFLT      '0'
     C     FC(J)         ORGT      '9'
     C                   Z-ADD     8             J
     C                   MOVEA     '1'           *IN(71)                        HIGHLIGHT ERROR
     C                   ELSE
     C                   MOVE      FC(J)         PCCNT             1 0
     C                   ADD       PCCNT         PCTST
     C                   END
     C                   ELSE
     C     J             DOUGE     9
     C     FC(J)         IFNE      ' '
     C                   Z-ADD     8             J
     C                   MOVEA     '1'           *IN(71)                        HIGHLIGHT ERROR
     C                   END
     C                   ADD       1             J
     C                   END
     C                   END
     C                   END
     C     PCTST         IFEQ      0
     C                   MOVEA     '1'           *IN(71)                        HIGHLIGHT ERROR
     C                   END
      *
     C                   ELSE
      *
      * TEST MULTIPLIER GE 1.0
      *
     C     FC(2)         IFEQ      '.'
     C     FC(1)         IFLT      '1'                                          MISSING
     C                   MOVE      '1'           *IN(71)                        FLAG ERROR
     C                   END
     C                   Z-ADD     0             PCTST
     C                   Z-ADD     0             J
     C     J             DOUGE     8
     C                   ADD       1             J
     C     FC(J)         IFNE      ' '
     C     J             IFNE      2
     C     FC(J)         IFLT      '0'
     C     FC(J)         ORGT      '9'
     C                   MOVE      '1'           *IN(71)                        FLAG ERROR
     C                   ELSE
     C                   MOVE      FC(J)         PCCNT
     C                   ADD       PCCNT         PCTST                          SUM DIGITS
     C                   END
     C                   END
     C                   ELSE
     C     J             DOUGT     8                                            TRAILING BL
     C     FC(J)         IFNE      ' '
     C                   MOVE      '1'           *IN(71)                        FLAG ERROR
     C                   END
     C                   ADD       1             J
     C                   END
     C                   END
     C                   END
     C     PCTST         IFEQ      0                                            NO VALUE
     C                   MOVE      '1'           *IN(71)                        FLAG ERROR
     C                   END
     C                   ELSE
      *
      * TEST CHAIN DISCOUNTS
     C     FC(3)         IFNE      *BLANKS
     C     FC(6)         ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(71)                        HIGHLIGHT ERROR
     C                   END
      *
     C     PC1           IFNE      *BLANKS
     C     PC1           IFEQ      '00'
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C     FC(1)         IFLT      '0'
     C     FC(1)         ORGT      '9'
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C     FC(2)         IFLT      '0'
     C     FC(2)         ORGT      '9'
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C                   END
      *
     C     PC2           IFNE      *BLANKS
     C     PC2           IFEQ      '00'
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C     FC(4)         IFLT      '0'
     C     FC(4)         ORGT      '9'
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C     FC(5)         IFLT      '0'
     C     FC(5)         ORGT      '9'
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C     PC1           IFEQ      *BLANKS
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C                   END
      *
     C     PC3           IFNE      *BLANKS
     C     PC3           IFEQ      '00'
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C     FC(7)         IFLT      '0'
     C     FC(7)         ORGT      '9'
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C     FC(8)         IFLT      '0'
     C     FC(8)         ORGT      '9'
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C     PC1           IFEQ      *BLANKS
     C     PC2           OREQ      *BLANKS
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C                   END
     C                   END
     C                   END
      *
      *
      * COMPUTE REPLACEMENT COST FROM MANUFACTURERS LIST
     C     *IN71         IFEQ      '0'
     C     FC(1)         IFEQ      '.'
     C     FC(2)         IFNE      '.'
     C                   MOVE      DISC          DSC7              7 7          MULTIPLIER
     C     LIST          MULT      DSC7          COST1             9 4          COST
IY    * Checking for truncation error for cost
IY I4C*                  If        (LIST  *   DSC7) <>
IY I4C*                            COST1
I4   C                   If        (LIST * DSC7) > 99999.9999
IY   C                   MOVE      UMS(65)       MSGFLD
IY   C                   MOVE      '1'           *IN63
IY   C                   MOVE      'Y'           ERRFLG
IY   C                   Z-ADD     RELREC        SAVRRN
IY I4 *  Reset Cost if Truncation occurs
IY I4C*                  Eval      COST1 = DCST
IY   C                   Endif
     C                   ELSE
     C                   MOVEA     '1'           *IN(71)                        FACTOR ERR
     C                   END
     C                   ELSE
      *
     C     FC(2)         IFEQ      '.'
     C     FC(1)         IFNE      '.'
     C                   MOVEL     P1            PPP1              7 0
     C                   MOVE      P2            PPP1
     C                   MOVE      PPP1          PPP2              7 6
     C     LIST          MULT      PPP2          COST1                          COST
IY    * Checking for truncation error for cost
IY I4C*                  If        (LIST  *  PPP2 ) <>
IY I4C*                            COST1
I4   C                   If        (LIST * PPP2) > 99999.9999
IY   C                   MOVE      UMS(65)       MSGFLD
IY   C                   MOVE      '1'           *IN63
IY   C                   MOVE      'Y'           ERRFLG
IY   C                   Z-ADD     RELREC        SAVRRN
IY I4 *  Reset Cost if Truncation occurs
IY I4C*                  Eval      COST1 = DCST
IY   C                   Endif
     C                   ELSE
     C                   MOVEA     '1'           *IN(71)                        FACTOR ERR
     C                   END
     C                   ELSE
      *
     C                   Z-ADD     0             PP1               2 2
     C     PC1           IFNE      *BLANKS
     C                   MOVE      PC1           PP1
     C     1             SUB       PP1           PP1
     C     LIST          MULT      PP1           COST1             9 4
IY    * Checking for truncation error for cost
IY I4C*                  If        (LIST  *   PP1 ) <>
IY I4C*                            COST1
I4   C                   If        (LIST * PP1) > 99999.9999
IY   C                   MOVE      UMS(65)       MSGFLD
IY   C                   MOVE      '1'           *IN63
IY   C                   MOVE      'Y'           ERRFLG
IY   C                   Z-ADD     RELREC        SAVRRN
IY I4 *  Reset Cost if Truncation occurs
IY I4C*                  Eval      COST1 = DCST
IY   C                   Endif
     C                   END
     C     PC2           IFNE      *BLANKS
     C                   MOVE      PC2           PP1
     C     1             SUB       PP1           PP1
     C     COST1         MULT      PP1           COST1
     C                   END
     C     PC3           IFNE      *BLANKS
     C                   MOVE      PC3           PP1
     C     1             SUB       PP1           PP1
     C     COST1         MULT      PP1           COST1
     C                   END
     C                   END
     C                   END
     C     *IN71         IFEQ      '0'
     C                   Z-ADD     COST1         COST                           COST
     C                   END
     C                   END
      * TEST FOR DISCOUNT ERROR
     C     *IN71         IFEQ      '1'
     C     ERRFLG        ANDNE     'Y'                                          NO ERROR
     C                   MOVE      UMS(11)       MSGFLD
     C                   Z-ADD     RELREC        SAVRRN
     C                   MOVE      'Y'           ERRFLG                         ERROR
     C                   END
JL   C                   eval      *in28  = *on
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    ORDER COMPLETION SCREEN                                 *
      *------------------------------------------------------------------------*
     C     COMSR         BEGSR
KP   C                   MOVE      *IN39         SVIN39            1
      *
      * GENERATE SALES ORDER FROM P/O QUESTION
     C                   EXSR      DIRQST                                       SHW DIR QUES
      * CHECK TO SEE IF EDI INFORMATION SHOULD BE DISPLAYED OR NOT...
     C                   MOVEA     '0'           *IN(48)
     C                   MOVEA     '0'           *IN(60)
     C     EDI           IFEQ      'Y'                                          ALLOW EDI ?
     C                   MOVE      'N'           EDIPOC            1            EDI CONFIRM
     C                   MOVE      'N'           EDIPOR            1            EDI RVSD LIN
     C                   MOVE      'N'           EDIPO                          EDI P/O?
IF   C                   If        WHRFRM = 'B'
IF   C                   Eval      EDIPO = 'Y'
IF   C                   Endif
     C                   CLEAR                   VNDCUS
     C                   CLEAR                   CUSNBR
     C                   CLEAR                   TRPNID
     C                   CLEAR                   DOCTYP
     C                   CLEAR                   SUBTYP
KC   C                   CLEAR                   EDITYP
     C                   CLEAR                   VENBRN
     C                   CLEAR                   RCVSTS
     C                   MOVE      'V'           VNDCUS
     C                   MOVEL     APNO01        CUSNBR
     C                   MOVE      '850'         DOCTYP
     C                   MOVE      PONO03        VENBRN
     C                   EXSR      GETTPI
     C     *IN42         IFEQ      '0'                                          NO EDI
     C                   MOVE      *OFF          *IN48                          SEND PO
     C                   MOVE      *OFF          *IN53                          SEND PO CONF
     C                   MOVE      *OFF          *IN59                          SEND PO CHG
HI   C                   MOVE      PONO01        EIN#                           SEND PO CHG
   HIC*    PONO01        SETLL     EIFADT                                 40    P/O SENT B4?
HI   C     EIN#          SETLL     EIFADT                                 40    P/O SENT B4?
      * IF THE ORDER HAS NOT BEEN SENT BEFORE, THE ONLY VALID OPTION
      * IS TO SEND AN ORIGINAL 850, SO SET ON THE INDICATOR TO DISPLAY
      * THAT PROMPT IF T/P FLAG IS SET TO "Y".
     C     *IN40         IFEQ      '0'                                          NOT SENT B4
     C                   MOVEA     '1'           *IN(48)                        SEND PO
     C                   ELSE
      * IF THE ORIGINAL ORDER HAS ALREADY BEEN SENT, THE USER CAN SEND
      * A CONFIRMATION ORDER (850-01) OR A PO CHANGE (860).
     C     *IN42         IFEQ      *OFF                                         PO CONF (850)
     C     SUBTYP        ANDNE     'A'
     C     SUBTYP        ANDNE     'P'
KC   C     EDITYP        ANDNE     'L'                                          not LMBX
#6   C     EIN#          READE     EIFADT                                 40    P/O SENT B4?
     C                   MOVE      *ON           *IN53                          PROMPT
     C                   ENDIF
     C                   MOVE      'V'           VNDCUS
     C                   MOVEL     APNO01        CUSNBR
     C                   MOVE      '860'         DOCTYP
     C                   MOVE      PONO03        VENBRN
     C                   EXSR      GETTPI
     C     *IN42         IFEQ      *OFF                                         NO EDI
     C     SUBTYP        ANDNE     'A'
     C     SUBTYP        ANDNE     'P'
     C                   MOVE      *ON           *IN59                          PROMPT
     C                   ENDIF
     C                   END
     C                   END
     C                   ENDIF
      * CHECK TO SEE IF FAX INFORMATION SHOULD BE DISPLAYED OR NOT...
     C                   MOVE      '0'           *IN69                          INIT DSP IND
     C                   MOVE      *BLANKS       SYSTEM
     C                   MOVE      'PO01'        SYSTEM
     C     FAX           IFEQ      'Y'                                          ALLOW FAX ?
     C                   MOVE      '1'           *IN69                          SET DSP IND
     C                   END
     C                   MOVE      *IN62         SVIN62            1
     C                   MOVE      *OFF          *IN62
KP   C                   EVAL      *IN39 = *OFF
KP   C                   IF        (WHMYES = 'Y' AND WHMBR = 'Y')
KP   C                              OR POCD01 ='D'
KP   C                              OR PRTRCVDFT ='X'
KP   C                   EVAL      *IN39 = *ON
KP   C                   MOVE      'N'           PRTRR
KP   C                   ELSE
KP   C                   MOVE      PRTRCVDFT     PRTRR
KP   C                   ENDIF
JY    *
JY    * If calculated sub-total is greater than the sub-total maximum, display error
JY   C                   if        xxtl01 > potl01
JY   C                   eval      msgfld = 'Purchase order sub-total ' +
JY   C                              %trim(%editc(XXTL01:'2')) + ' exceeds +
JY   C                              9,999,999.99 maximum.'
JY   C                   end
      *
      * DISPLAY ORDER COMPLETION SCREEN
      *
     C     DSPCOM        TAG
IO   C                   EXSR      COMTT
     C                   MOVE      'N'           EDTFAX                         EDIT/VIEW FAX
     C                   MOVE      SVIN52        *IN52                          EDIT/VIEW FAX OPTS
:A   C                   IF        PO_OpnCls <> ' '
:A   C                   EVAL      POCD20 = PO_OpnCls
:A   C                   ENDIF
     C                   EXFMT     POF0120H                                     COMPLETION SCRE
     C                   CLEAR                   MSGFLD
     C                   MOVEA     '0'           *IN(68)                        INIT FAX ERR
     C                   MOVEA     '000'         *IN(90)
     C                   MOVE      *OFF          *IN83                          EDI TYP ERR
     C                   MOVE      *OFF          *IN67
¢O   C                   MOVE      *OFF          *IN61
#6   C                   MOVE      *OFF          *IN18                          SPS
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           DSPCOM
     C                   END
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           ENDCOM                         CMD 03 RETURN
     C                   END
     C     *IN03         IFEQ      *ON
     C                   MOVE      UMS(2)        MSGFLD                         MESSAGE
     C     *IN03         CABEQ     '1'           DSPCOM                   56    CMD 03 RETURN
     C                   ENDIF
     C                   MOVEA     '0'           *IN(56)                        MESSAGE DISPLAY
      *
   JYC*    *IN12         CABEQ     '1'           ENDCOM                         CMD 12-PREVIOUS
JY   C                   IF        *IN12 = '1'
JY   C                   Z-ADD     0             XXTL02
JY   C                   Z-ADD     0             POTL02
JY   C     *IN12         CABEQ     '1'           ENDCOM                         CMD 12-PREVIOUS
JY   C                   ENDIF
      *
      * EDIT DISCOUNT DATA
      * 1. IF DISC % IS ENTERED, FORCE ENTRY OF EITHER DAY, DAYS
      *    OR DUE DATE.
     C     POPC01        IFNE      0
     C     DUEDAT        IFEQ      0
     C     PONO04        ANDEQ     0
     C     PODY05        ANDEQ     0
     C                   MOVE      '1'           *IN90
     C                   MOVE      UMS(3)        MSGFLD                         MESSAGE
     C                   END
     C                   END
      * 2. IF DISC % IS ENTERED, ONLY ALLOW ONE ENTRY: DAY, OR DAYS
      *    OR DUE DATE.
     C                   Z-ADD     0             CNT1              1 0
     C     DUEDAT        IFNE      0
     C                   ADD       1             CNT1
     C                   END
     C     PONO04        IFNE      0
     C                   ADD       1             CNT1
     C                   END
     C     PODY05        IFNE      0
     C                   ADD       1             CNT1
     C                   END
     C     CNT1          IFGT      1
     C                   MOVE      '1'           *IN91
     C                   MOVE      UMS(4)        MSGFLD                         MESSAGE
     C                   END
      * 3. WARN IF DISC% IS ZERO, BUT DATE OR DAY(S) ENTERED.
     C     *IN90         CABEQ     '1'           DSPCOM                         DT/DAYS ZERO
     C     *IN91         CABEQ     '1'           DSPCOM                         MORE THAN 1
      * 4. WARN IF DISC DAY IS GREATER THAN 31, VALIDATE
      * FIELD AGAINST TABLE FILE FOR CORRECT TERMS......
     C     PODY05        IFGT      31                                           IF SPECIAL TERMS
     C                   MOVE      *BLANKS       TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVE      'AP09'        TABCOD
     C                   MOVEL     'DUECD   '    TABENT
     C                   MOVE      PODY05        TABENT
     C     TABKEY        CHAIN     TBFMTBL                            45
     C     *IN45         IFEQ      *ON
     C                   MOVE      *ON           *IN83                          TURN ON SPEC TERM IN
     C                   MOVE      UMS(7)        MSGFLD                         MESSAGE
     C                   ENDIF
     C                   ENDIF
     C     *IN83         CABEQ     *ON           DSPCOM
      *
     C     DUEDAT        IFNE      0
     C                   Z-ADD     DUEDAT        PDATE
     C                   Z-ADD     *ZEROS        PJULI
     C                   CALL      'GPR0100'     EDTDAT                         EDIT FOR
     C     PJULI         IFEQ      0                                             VALID DUE
     C                   MOVE      '1'           *IN94                            DATE
     C                   GOTO      DSPCOM
     C                   ELSE
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      DUEDAT        PDATE6                         DUE DATE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDACEN        POCC06                         DUE DATE CENTURY
     C                   END
     C     *IN37         IFEQ      '0'                                          EDIT FOR
     C     POYR06        IFNE      UYEAR                                        CURRENT DATE
     C                   MOVE      '1'           *IN37
     C                   MOVE      UMS(5)        MSGFLD                         MESSAGE
     C     *IN37         CABEQ     '1'           DSPCOM
     C                   END
     C                   END
     C                   END
¢O    *
¢O    * If Fax/Email and EDI are selected, issue an error...
¢O    *
¢O   C     SNDFAX        IFEQ      'E'                                          SEND FAX ?
¢O   C     SNDFAX        OREQ      'F'                                          SEND FAX ?
¢O   C     EDI           IFEQ      'Y'                                          SEND FAX ?
¢O   C     EDIPO         ANDEQ     'Y'                                          SEND FAX ?
¢O   C     EDI           OREQ      'Y'                                          SEND FAX ?
¢O   C     EDIPOC        ANDEQ     'Y'                                          SEND FAX ?
¢O   C     EDI           OREQ      'Y'                                          SEND FAX ?
¢O   C     EDIPOR        ANDEQ     'Y'                                          SEND FAX ?
¢O   C                   MOVE      CMS(5)        MSGFLD                         MESSAGE
¢O   C                   MOVE      *ON           *IN61
¢O   C                   MOVE      *ON           *IN67
¢O   C     *IN67         CABEQ     '1'           DSPCOM
¢O   C                   ENDIF
¢O   C                   ENDIF
#6    *
#6    * ISSUE AN ERROR MSG IF PO is already waiting to be sent
#6    *
#6   C     EDIPOC        IFEQ      'Y'                                          SEND FAX ?
#6   C     EICD23        andeq     'W'                                          SEND FAX ?
#6   C                   MOVE      CMS(16)       MSGFLD                         MESSAGE
#6   C                   MOVE      *ON           *IN61
#6   C     *IN67         CABEQ     '1'           DSPCOM
#6   C                   ENDIF
      *
      * IF P/O IS NOT TO BE FAXED, DO NOT DISPLAY THE EDIT/VIEW FAX OPTIONS
      *
JB    * If flag in table FAX for PO is no, do not display option to
JB    * edit fax/email option
     C     SNDFAX        IFEQ      'N'                                          DO NOT FAX P/O
JB   C     sndfax        oreq      'F'
JB   C     afp           andeq     'N'
     C                   MOVE      *OFF          *IN52                          EDIT FAX OPTION
     C                   MOVE      *OFF          SVIN52                         SAV *IN52
     C                   ENDIF
      *
      * MAKE SURE THAT FAX NUMBER CONTAINS VALID DATA...
      *
     C     SNDFAX        IFEQ      'F'                                          SEND FAX ?
     C     FAX2C         IFEQ      *ZEROS
     C                   MOVE      UMS(6)        MSGFLD                         MESSAGE
     C     FAX2C         CABEQ     *ZEROS        DSPCOM                   68        "
     C                   ENDIF
      *
      * IF THE FAX NUMBER ON THE SCREEN MATCHES FAX NUMBER IN THE
      * VENDOR MASTER FILE, GET THE ONE BEFORE DIALING FIELD FROM
      * THE VENDOR MASTER FILE
      *
     C     FAX4C         IFEQ      ' '                                          ONEB4 = ' ' DE
     C     FAX1C         LOOKUP    FCD                                    40
     C     *IN40         IFEQ      *ON
     C     FAXSC         ANDEQ     FAX#
     C     APCD44        IFNE      ' '
     C                   MOVE      APCD44        FAX4C                          ONEB4 DIALING
     C                   END
     C                   ELSE
     C                   MOVE      'N'           FAX4C                          ONEB4 DIALING
     C                   END
     C                   END
      *
      * IF ANY OF THE FAX OPTIONS ARE BLANK OR THE FAX NUMBER ON
      * THE COMPLETION SCREEN HAS CHANGED, EXECUTE FAXOPT SUBROUTINE
      *
JB    *
JB    * If flag in table FAX for PO is no, do not display option to
JB    * edit fax/email option
JB JKC*                  if        afp = 'Y'
     C     CVRSHT        IFEQ      ' '
     C     DELAY         OREQ      ' '
     C     FAX4C         OREQ      ' '
     C     FAXSC         ORNE      FAXSV
     C     EDTFAX        OREQ      'Y'
     C                   EXSR      FAXOPT
     C                   Z-ADD     FAXSC         FAXSV
     C                   MOVE      *ON           *IN52
     C                   MOVE      *ON           SVIN52
     C                   GOTO      DSPCOM
     C                   END                                                    GROUP IF
JB JKC*                  endif
JB    *
      *----------------------------------------------------------------
     C                   END
      *
      * EMAIL ?
      *
     C     SNDFAX        IFEQ      'E'
     C     EALLOW        IFNE      'Y'
     C                   MOVE      *ON           *IN67
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     EMS(50)       MSGFLD
     C     MSGFLD        CABNE     *BLANKS       DSPCOM
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN52
     C                   MOVE      *ON           SVIN52
     C     EMAIL         IFEQ      *BLANKS
     C     EDTFAX        OREQ      'Y'
     C                   MOVE      '02'          ETYPE
     C                   CALL      'OPR0315'     PL0315
      *
      * FORCE RE-DISPLAY IF NO SELECTION MADE.
      *
     C     EMAIL         CABEQ     *BLANKS       DSPCOM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * EMAIL?
      *
      * WRITE EMAIL CONTROL RECORD
      *
     C     SNDFAX        IFEQ      'E'
     C     EMAIL         ANDNE     *BLANKS
     C                   MOVEL     PONO01        DOCNUM           12
     C                   MOVE      SYSTEM        SYSID             4
     C                   MOVE      APNO01        TRNNUM                         TRANSFER NUMBER
     C                   CALL      'OPR0303'     PL0303
     C                   ENDIF
      *
      * CHECK HOW TO DO ORDER TYPE  PRT, FAX, EDI
     C                   MOVE      ' '           P115              1            PRT PGM
     C                   MOVE      ' '           P500              1            FAX PGM
     C     EDIPO         IFEQ      'Y'                                          EDI ORDER
     C     EDIPOC        OREQ      'Y'                                          EDI CONFIRM
     C     EDIPOR        OREQ      'Y'                                          EDI REVISED
     C                   MOVE      'E'           P115                           PRT PGM
     C                   MOVE      'E'           P500                           FAX PGM
     C                   ELSE
     C     SNDFAX        IFEQ      'F'                                          FAX
     C     SNDFAX        OREQ      'E'                                          EMAIL
     C                   MOVE      'F'           P115                           PRT PGM
     C                   MOVE      'O'           P500                           FAX PGM
     C                   ELSE
     C     PRNTPO        IFEQ      'Y'                                          PRINT ORDER
     C     PRNTRV        OREQ      'Y'                                          PRT REVISED
     C                   MOVE      ' '           P115                           PRT PGM
     C                   MOVE      ' '           P500                           FAX PGM
     C                   END
     C                   END
     C                   END
      * CHECK VALUE OF PO PRINT AND PO PRINT REVISED LINES
     C     PRNTPO        IFEQ      'Y'                                          PRINT ORDER
     C     SNDFAX        OREQ      'F'                                          FAX
     C     SNDFAX        OREQ      'E'                                          EMAIL
     C                   MOVE      *OFF          *IN62                          DSPATR(RI)
     C                   CLEAR                   MSGFLD
     C                   ELSE                                                   PRNTPO = N
     C     PRNTRV        IFEQ      'Y'                                          PRT REVISED
     C                   MOVE      UMS(1)        MSGFLD                         ERROR MSG
     C                   MOVE      *ON           *IN62                          DSPATR(RI)
     C                   ELSE
     C                   MOVE      *OFF          *IN62                          DSPATR(RI)
     C                   ENDIF
     C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       DSPCOM                         ERROR!
     C                   MOVE      SVIN62        *IN62
      *
      * COMPUTE TOTALS
     C     TAXPCT        IFNE      0                                            TAX %
     C     TAXPCT        MULT      .01           TAXPC             5 5          TAX PERCENT
     C     POTL01        MULT(H)   TAXPC         POAM04                         TAX AMOUNT
JY   C     XXTL01        MULT(H)   TAXPC         XXAM04                         TAX AMOUNT
JY   C                   ELSE
JY   C                   Z-ADD     POAM04        XXAM04
     C                   END
     C     POTL01        ADD       POAM03        POTL02                         P.O. TOTAL
     C                   ADD       POAM04        POTL02                         P.O. TOTAL
IO   C     LSTTOTAL      ADD       POAM03        LSTTOT
IO   C                   ADD       POAM04        LSTTOT
JY   C     XXTL01        ADD       POAM03        XXTL02
JY   C                   ADD       XXAM04        XXTL02
JY    *
JY    * If calculated total is greater than the total maximum, display error
JY   C                   if        xxtl02 > potl02
JY   C                   eval      msgfld = 'Purchase order total ' +
JY   C                              %trim(%editc(XXTL02:'2')) + ' exceeds +
JY   C                              9,999,999.99 maximum.'
JY   C     msgfld        cabne     *blanks       dspcom
JY   C                   end
¢Q    *
¢Q   C     POTL02        IFGT      CMAM01
¢Q   C                   MOVEA     CMS(10)       MSGFLD                         ENTER DAY(S)
¢Q   C                   GOTO      DSPCOM                                       FOUND P.O.
¢Q   C                   ENDIF
¢Q    *
      *
      * NOTES FROM P/O TO RECEIVING
     C     *IN06         IFEQ      '1'                                          RECEIVING NOTES
     C                   EXSR      RCNOT                                        RECEIVING NOTES
     C     *IN03         CABEQ     '1'           ENDCOM
     C     *IN06         CABEQ     '1'           DSPCOM
     C                   END
      *
      * NOTES FROM P/O TO A/P
     C     *IN07         IFEQ      '1'                                          A/P NOTES
     C                   EXSR      APNOT                                        A/P NOTES
     C     *IN03         CABEQ     '1'           ENDCOM
     C     *IN07         CABEQ     '1'           DSPCOM
     C                   END
      *
      * IF FAX OR EMAIL CHANGED - RETURN TO DISPLAY
      *
     C     EDTFAX        IFEQ      'Y'
     C                   MOVE      'N'           EDTFAX
     C                   GOTO      DSPCOM
     C                   ENDIF
      *
     C     POTL02        IFNE      TL02                                         TOTAL PO AMOUNT
     C                   Z-ADD     POTL02        TL02                           HIDDEN FIELD
     C     POTL02        CABEQ     TL02          DSPCOM
     C                   END
KP   C                   MOVE      SVIN39        *IN39
     C     ENDCOM        ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    LOAD ITEM SUBFILES                                      *
      *------------------------------------------------------------------------*
     C     LOAD          BEGSR
KW   C                   eval      ovhfnd = 'N'
KW   C                   eval      invfnd = 'N'
JL   C                   eval      fl67cnt = *zeros
IR    * CLEAR PRODUCT SEARCH WORKFILE...
IR   C     PONO01        SETLL     POFWPOL
IR   C     *IN49         DOUEQ     *ON
IR   C     PONO01        DELETE    POFWPOL                            49
IR   C                   ENDDO
KE    *
KE   C     PONO01        SETLL     POFWPOLL
KE   C     *IN49         DOUEQ     *ON
KE   C     PONO01        DELETE    POFWPOLL                           49
KE   C                   ENDDO
     C                   MOVEA     '0'           *IN(82)                        PROTECT/NONDSP
     C                   Z-ADD     1             X
     C                   Z-ADD     0             RRN
     C     X             DOUGT     ITMSIZ
     C     X             OCCUR     SAVDS
     C     DITM          IFEQ      *BLANKS
     C                   MOVE      *OFF          *IN21                          PROTECT/NONDISPLAY
     C                   MOVEA     '0'           *IN(84)                        PROTECT ITEM #
     C                   MOVEA     '0'           *IN(80)                        POSITION CURSOR
     C                   MOVE      ' '           BLKTAG                         BLINK TAG & HOL
     C     DDES          CABEQ     *BLANKS       ENDLD                          DESCRIPTION
     C                   END
     C                   MOVE      '1'           *IN32                          SFLNXTCHG
     C                   MOVE      SAVDS         SFDS
     C                   MOVEL     PROD          ZZNO04
     C                   MOVEL     PROD          SVNO04
     C                   MOVEL     ZZNO04        PRT                            SAVE ZZNO04
     C                   MOVEL     DESC          ZZDN01
     C                   ADD       1             X
     C                   ADD       1             RRN
     C     DTYP          IFEQ      'D'                                          LOT DETAIL
     C                   MOVE      *ON           *IN21                          PROTECT/NONDSP
     C                   ENDIF
      * PROTECT UOM FIELDS IF QTY'S HAVE BEEN RECEIVED...
     C     QTYR          IFNE      0
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *
      * LOAD PRICING SUBFILE
     C     WHERE         IFEQ      'P'                                          PRICING S/F
     C     DTYP          IFEQ      'C'                                          COMMENTS
     C                   MOVEA     '1'           *IN(82)                        PROTECT/NONDSP
     C                   END
   HNC*    DDOV          IFNE      ' '                                          DISCOUNT OVRRDE
HN   C     DDOV          IFEQ      'Y'                                          DISCOUNT OVRRDE
     C                   MOVEA     '1'           *IN(80)                        HIGHLITE DISC
     C                   END
   HNC*    DCOV          IFNE      ' '                                          COST OVRRDE
HN   C     DCOV          IFEQ      'Y'                                          COST OVRRDE
     C                   MOVEA     '1'           *IN(81)                        HIGHLITE COST
     C                   END
      * IF PURCHASING UOM SAME AS STOCKING, OR IF ITEM IS A NON STOCK,
      * THEN DO NOT DISPLAY STOCKING DATA...
     C     QTY           IFEQ      UQYSF
     C     DNO7          OREQ      0
     C                   MOVE      *ON           *IN26                          NON DISPLAY
     C                   ENDIF
#4   C                   Z-ADD     QTY           QTYO
     C     DNO7          IFEQ      0
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *
      *
      * WHEN PRICE FACTOR IN DECIMAL, SET *IN34 TO *ON TO DISPLAY
      * PRICE FACTOR IN DECIMAL,
      * ELSE SET *IN34 TO *OFF TO DISPLAY AS WHOLE NUMBER.
     C                   Z-ADD     PUOMSF        XUOMSF
     C     RDEC          IFNE      0
     C                   MOVE      '1'           *IN34
     C                   ELSE
     C                   MOVE      '0'           *IN34
     C                   ENDIF
     C                   CLEAR                   SITM
     C                   CLEAR                   SDES
     C                   CLEAR                   SMAN
     C                   CLEAR                   PDDS35
#4   C                   CLEAR                   PDDS20
     C                   MOVEL     PROD          SITM
     C                   MOVEL     DESC          SDES
     C                   MOVEL     MAN           SMAN
     C                   SELECT
     C     PRD           WHENEQ    '1'
     C                   MOVEL     SDES          PDDS35
#4   C                   MOVEL     SDES          PDDS20
     C     PRD           WHENEQ    '2'
     C                   MOVEL     SITM          PDDS35
#4   C                   MOVEL     SITM          PDDS20
     C     PRD           WHENEQ    '3'
     C                   MOVEL     SMAN          PDDS35
#4   C                   MOVEL     SMAN          PDDS20
     C                   ENDSL
JL    * SET SPECIAL PRICING INDICATOR
JL   C                   eval      *in55  = *on
JL   C                   if        splprcaut = 'Y'
JL   C                             and pofl67 = 'Y'
JL   C                   if        typ <> 'C' and typ <> 'E'
JL   C                             and typ <> 'D'
JL   C                   eval      *in55  = *Off
JL   C                   endif
JL   C                   endif
      *
     C                   WRITE     POS0120G                                     PRICING S/F
     C                   MOVE      *OFF          *IN60
     C                   MOVEA     '000'         *IN(80)                        HIGHLITE OVRRDE
     C                   MOVE      '0'           *IN31                          NOT PROTECT
     C                   MOVE      *OFF          *IN26
     C     *IN57         IFEQ      '1'                                          EXTENDED DESC
     C                   Z-ADD     IVNO7         IVNO07                         ITEM NUMBER
     C                   EXSR      EXTDSC
     C                   END
     C                   ELSE
      *
      * LOAD ENTRY SUBFILE
      *
      * IF SHIP TO BRANCH HAS CHANGED - VERIFY THAT THIS TAG
      * STILL EXIST (NON-STOCK TAGS GET DELETED).
      *
     C     KEY           IFNE      *ZEROS
     C     BRCHG         ANDEQ     'Y'
      *
     C                   MOVE      *IN51         SV51
     C     KEY           LOOKUP    KY(1)                                  51
     C     *IN51         IFEQ      *OFF
     C                   Z-ADD     *ZEROS        KEY
     C                   ENDIF
     C                   MOVE      SV51          *IN51
      *
     C                   ENDIF
      *
     C     KEY           IFNE      0                                            TAG & HOLD ?
     C                   MOVE      'T'           BLKTAG                         BLINK TAG & HOL
      * IF THE CUSTOMER NUMBER WAS CHANGED AND TAGS EXIST, OR IF THE
      * P/O TYPE HAS CHANGED FROM DIRECT TO NON-DIRECT (OR VICE VERSA),
      * FORCE A 'T' IN THE SELECT FIELD TO REVIEW THE TAGS...
     C     CUSTSV        IFNE      PONO13
     C     CUSTSV        ANDNE     0
     C     POCD01        OREQ      'D'
     C     SVTYPE        ANDNE     'D'
     C     SVTYPE        ANDNE     *BLANKS
     C     POCD01        ORNE      'D'
     C     SVTYPE        ANDEQ     'D'
     C                   MOVE      BLKTAG        SEL
     C                   MOVE      *ON           *IN68                          PROTECT SEL
     C                   ENDIF
     C                   END
      * DO NOT DISPLAY UOM FACTOR DATA IF PURCHASE UOM FACTOR = 1...
     C     UOMSF         IFEQ      1
     C                   MOVE      *ON           *IN26
     C                   ENDIF
     C     QTYR          IFNE      0                                            QTY RECEIVED
     C                   MOVEA     '1'           *IN(84)                        PROTECT ITEM #
     C                   END
     C                   MOVE      *BLANK        HIDZN4
     C                   MOVEL     ZZNO04        HIDZN4
      *
      * IF ITEM ON OPEN ASN IN WM SYSTEM, PROTECT PROD#.
      * CANNOT DELETE ITEM.
     C                   MOVE      *OFF          *IN54
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     DONASN        IFEQ      'Y'
     C     DONASN        OREQ      '0'
     C                   MOVE      *ON           *IN54
     C                   END
     C                   END
HL    * If item is deleted, warn user and protect all data...                   NOT FOUND
HL   C     DDELETED      IFEQ      'Y'                                          DELETED ITEM
HL   C                   MOVEA     '1'           *IN(21)
HL   C     IVNO7         CHAIN     ALLITEM                            46        ITEM MASTER
HL   C     *IN46         IFEQ      *OFF
HL   C                   MOVEL     IVDN01        DESC                           DESCRIPTION
HL   C                   MOVEL     IVDN01        ZZDN01                         DESCRIPTION
HL   C                   ENDIF
HL   C     SFDEL         IFNE      'Y'
HL   C                   MOVEA     '1'           *IN(81)
HL   C     ERRFLG        IFNE      'Y'
HL   C                   MOVE      'Y'           SFDEL
HL   C                   MOVEL     UMS(64)       MSGFLD
HL   C                   MOVE      'Y'           ERRFLG
HL   C                   ENDIF
HL   C                   ENDIF
HL   C                   ENDIF
KW   C                   if        ivno7 <> 0
KW   C     IVNO7         CHAIN     ALLITEM
KW   C                   if        %found and ivfl19 = 'Y'
KW   C                   eval      ovhfnd = 'Y'
KW   C                   endif
KW   C                   endif
¢8    * Check to see if this is an original line
¢8    * If so, then the item needs to be protected if po sent to vendor
¢8   C                   MOVE      *OFF          *IN28
#5 :AC*                  IF        ediSolution <> 'SPS'
¢8 :AC*                  IF        SFORGPROD <> *BLANKS
¢8 :AC*                  IF        SentToVendor = 'Y'
:A   C                   IF        SFORGPROD <> *BLANKS and
:A   C                             SentToVendor = 'Y'
¢8   C                   MOVE      *ON           *IN28
¢8   C                   ENDIF
¢8 :AC*                  ENDIF
#5 :AC*                  ENDIF
      *
     C     ITMSIZ        IFEQ      400
:A   C                   IF        SFORLN > 0
:A   C                   EVAL      POLine = %editc(SFORLN:'X')
:A   C                   ELSE
:A   C                   EVAL      PoLine = *blanks
:A   C                   ENDIF
     C                   WRITE     POS0120E                                     ENTRY S/F
     C                   ELSE
     C                   WRITE     POS0120N                                     ENTRY S/F DR
     C                   END
¢8   C                   MOVE      *OFF          *IN28
IR    * LOAD PRODUCT SEARCH WORKFILE...
IR   C                   Z-ADD     RRN           POSFRN
IR   C                   MOVEL     ZZNO04        SFDITM
KE   C                   eval      sfdline = sforln
IR   C                   WRITE     POFWPOL
KE   C                   WRITE     POFWPOLL
HL   C                   MOVE      *OFF          *IN21                          PROTECT
HL   C                   MOVE      *OFF          *IN81                          PROTECT
I0   C                   MOVE      *OFF          *IN23
     C                   MOVE      *OFF          *IN26                          SHOW UOM DATA
     C                   MOVE      *OFF          *IN68                                         LD
     C                   MOVEA     '0'           *IN(84)                        PROTECT ITEM #
     C                   MOVEA     '0'           *IN(80)                        POSITION CURSOR
     C                   MOVE      ' '           BLKTAG                         BLINK TAG & HOL
     C                   END
     C                   MOVE      *OFF          *IN60
     C                   END
KR
KR   C     ENDLD         tag
KR   C                   z-add     rrn           botrrn            4 0
KR   C                   add       1             botrrn            4 0
   KRC*    ENDLD         ENDSR
KR   C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    RECEIVING NOTES                                         *
      *------------------------------------------------------------------------*
     C     RCNOT         BEGSR
      *
      * INITIALIZE SUBFILE
     C                   MOVEA     '1'           *IN(70)                        INITIALIZE
     C                   WRITE     POC0120I                                     RECEIVING NOTES
     C                   MOVEA     '0'           *IN(70)                        SETOF INITIALIZ
      *
      * LOAD SUBFILE
     C                   Z-ADD     1             X
     C                   Z-ADD     1             RRN
     C     X             DOUGT     28
     C     X             OCCUR     RCDS                                         LOAD SUBFILE
     C     DSNOT1        IFNE      *BLANKS                                      FROM RECEIVING
     C                   MOVE      DSNOT1        NOTES                          NOTES D/S
     C                   WRITE     POS0120I
     C                   ADD       1             RRN
     C                   END
     C                   ADD       1             X
     C                   END
      *
      * DISPLAY RECEIVING NOTES
     C     RCDSP         TAG
     C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB & CNT
     C                   WRITE     POF0120I                                     CMD KEY FORMAT
     C                   EXFMT     POC0120I                                     RECEIVING NOTES
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           RCDSP
     C                   END
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           RCEND                          CMD 03 RETURN
     C                   END
     C     *IN03         CABEQ     '1'           RCDSP                    56    CMD 03 RETURN
     C                   MOVEA     '0'           *IN(56)                        MESSAGE DISPLAY
      *
      * CMD 12 PREVIOUS
     C     *IN12         CABEQ     '1'           RCEND                          CMD 12 PREVIOUS
      *
     C                   Z-ADD     1             X
     C     X             DOUGT     028                                          BLANK OUT
     C     X             OCCUR     RCDS                                         RECEIVING NOTES
     C                   CLEAR                   RCDS
     C                   ADD       1             X
     C                   END
      *
      * READ SUBFILE
     C     *IN41         DOUEQ     '1'
     C                   READC     POS0120I                               41
     C     *IN41         IFEQ      '0'
     C                   UPDATE    POS0120I
     C     RRN           OCCUR     RCDS
     C                   MOVE      NOTES         DSNOT1
     C                   END
     C                   END
      *
     C     RCEND         TAG
     C                   MOVEA     '1'           *IN(77)                        DELETE S/F
     C                   WRITE     POC0120I                                     RECEIVING NOTES
     C                   MOVEA     '0'           *IN(77)                        SETOF DELETE
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    A/P NOTES                                               *
      *------------------------------------------------------------------------*
     C     APNOT         BEGSR
      * INITIALIZE SUBFILE
     C                   MOVEA     '1'           *IN(70)                        INITIALIZE
     C                   WRITE     POC0120J                                     A/P NOTES
     C                   MOVEA     '0'           *IN(70)                        SETOF INITIALIZ
      *
      * LOAD SUBFILE
     C                   Z-ADD     1             X
     C                   Z-ADD     1             RRN
     C     X             DOUGT     MXNOTE
     C     X             OCCUR     APDS                                         FROM A/P
     C     DSNOT2        IFNE      *BLANKS                                      DATA STRUCTURE
     C                   MOVE      DSNOT2        NOTES
     C                   WRITE     POS0120J
     C                   ADD       1             RRN
     C                   END
     C                   ADD       1             X
     C                   END
      *
      * DISPLAY A/P NOTES
     C     APDSP         TAG
     C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB & CNT
     C                   WRITE     POF0120J                                     CMD KEY FORMAT
     C                   EXFMT     POC0120J                                     A/P NOTES
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           APDSP
     C                   END
      *
      * CMD 03 RETURN
     C     *IN56         IFEQ      '1'                                          MESSAGE DISPLAY
     C     *IN03         CABEQ     '1'           APEND                          CMD 03 RETURN
     C                   END
     C     *IN03         CABEQ     '1'           APDSP                    56    CMD 03 RETURN
     C                   MOVEA     '0'           *IN(56)                        MESSAGE DISPLAY
      *
      * CMD 12 PREVIOUS
     C     *IN12         CABEQ     '1'           APEND                          CMD 12 PREVIOUS
      *
     C                   Z-ADD     1             X
     C     X             DOUGT     MXNOTE                                       BLANK OUT
     C     X             OCCUR     APDS                                         A/P NOTES DATA
     C                   CLEAR                   APDS
     C                   ADD       1             X
     C                   END
      *
      * READ SUBFILE
     C     *IN41         DOUEQ     '1'
     C                   READC     POS0120J                               41
     C     *IN41         IFEQ      '0'
     C                   UPDATE    POS0120J
     C     RRN           OCCUR     APDS
     C                   MOVE      NOTES         DSNOT2
     C                   END
     C                   END
      *
     C     APEND         TAG
     C                   MOVEA     '1'           *IN(77)                        DELETE
     C                   WRITE     POC0120J                                     A/P NOTES
     C                   MOVEA     '0'           *IN(77)                        SETOF DELETE
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    BLANK/ZERO DATA STRUCTURE                               *
      *------------------------------------------------------------------------*
     C     BLKDS         BEGSR
      *
     C     TAGOPN        IFNE      'Y'
      *
      * CREATE WORK FILE IN QTEMP AND OPEN
      *
     C                   MOVE      *BLANKS       @FILE            10
     C                   MOVE      '3'           FUNCTN            1
     C                   MOVEL     'POPWTAG'     @FILE
     C                   CALL      'OPC9990'
     C                   PARM                    FUNCTN
     C                   PARM                    @FILE
      *
     C                   MOVEL     'POLWTAG1'    @FILE
     C                   CALL      'OPC9990'
     C                   PARM                    FUNCTN
     C                   PARM                    @FILE
      *
     C                   OPEN      POLWTAG1
     C                   MOVE      'Y'           TAGOPN            1
     C                   ENDIF
      *
     C                   Z-ADD     1             X                 3 0
     C     X             DOUGT     MAXDS                                        MAX DS SIZE
     C     X             OCCUR     SAVDS
     C                   CLEAR                   SAVDS
     C     FRSTLN        IFEQ      'Y'
     C     X             OCCUR     SAVDSR
     C                   CLEAR                   SAVDSR
     C                   ENDIF
     C                   ADD       1             X
     C                   END
     C                   Z-ADD     0             X
     C     FRSTLN        IFEQ      'Y'
     C                   MOVE      ' '           LODDTL            1
     C                   CLEAR                   RNS                            TOTAL RNS ITEMS
     C                   CLEAR                   RN2                            RNS FROM S/O ARRAY
     C                   Z-ADD     *ZEROS        TRTCNT            5 0          TAG COUNT
     C                   Z-ADD     *ZEROS        SOTCNT            5 0          TAG COUNT
     C                   Z-ADD     *ZEROS        COTCNT            5 0          TAG COUNT
     C                   Z-ADD     *ZEROS        WOTCNT            5 0          TAG COUNT
     C     PONO01        SETLL     POFTOL
     C     *IN40         DOUEQ     '1'
     C     PONO01        READE     POFTOL                                 40
      * CHECK FOR RECORD LOCK
     C     *IN40         IFEQ      '0'
     C                   ADD       1             X
     C     X             OCCUR     SAVDS
KM    *
KM    * Load price sheet override informatino
KM   C     LINKEY        CHAIN     POQTOLA01
KM   C                   IF        %FOUND(POQTOLA01)
KM   C                   EVAL      DPSNME = ZPRNO01
KM   C                   EVAL      DPSSTS = ZPRCD21
KM   C                   EVAL      DPSTYPE = ZPRCD77
KM   C                   EVAL      DPSCTNM = ZPRNO02
KM   C                   EVAL      DPSOVR = 'Y'
KM   C                   ELSE
KM   C                   CLEAR                   DPSNME
KM   C                   CLEAR                   DPSSTS
KM   C                   CLEAR                   DPSTYPE
KM   C                   CLEAR                   DPSCTNM
KM   C                   CLEAR                   DPSOVR
KM   C                   ENDIF
KM    *
     C                   MOVE      ' '           DSPREV                         PREVIOUSLY ENT  1
      *
HL   C                   CLEAR                   DDELETED                       NOT DELETED ITEM
     C     POCD13        IFEQ      'S'                                          STOCKED ITEM
   HLC*    IVNO07        CHAIN     IVFITEM                            41        ITEM MASTER
HL   C     IVNO07        CHAIN     ALLITEM                            41        ITEM MASTER
     C     *IN41         IFEQ      *OFF
HL   C     IVNO07        SETLL     IVFITEM                                41    ITEM MASTER
HL   C     *IN41         IFEQ      *OFF
HL   C                   MOVE      'Y'           DDELETED                       DELETED ITEM
HL   C                   ENDIF
      *
      * ADD RNS ITEMS CREATED TO TOTAL RNS ITEMS ON S/O
      *
     C     IVCDC8        IFEQ      'E'                                          ENTERED
     C     IVCDC8        OREQ      'P'
     C                   Z-ADD     1             RX                3 0          ARRAY INDEX
     C     *ZERO         LOOKUP    RNS(RX)                                46
     C                   MOVE      IVNO07        RNS(RX)                        ADD RNS ITEMS
     C                   ENDIF
      *
      * ADD RNS ITEMS CREATED TO TOTAL RNS ITEMS ON S/O(NONDIRECTS)
      *
     C     IVCDC8        IFEQ      'E'                                          ENTERED
     C     IVCDC8        OREQ      'P'
     C                   Z-ADD     1             RY                3 0          ARRAY INDEX
     C     *ZERO         LOOKUP    RN2(RY)                                46
     C                   MOVE      IVNO07        RN2(RY)                        ADD RNS ITEMS
     C                   ENDIF
      *
     C                   MOVEL     IVDN01        DDES                           DESCRIPTION
     C                   Z-ADD     IVNO07        DNO7
     C     POCD19        IFEQ      'O'                                          OUR ITEM NUMBER
     C                   MOVEL     IVNO07        DITM
     C                   ELSE
     C                   MOVEL     IVNO04        DITM
     C                   END
     C                   ENDIF
¢8   C                   MOVEL     DITM          DSORGPROD
     C                   ELSE
     C     POCD13        IFEQ      'N'                                          NON-STOCK ITEM
     C                   MOVE      'Y'           DCMTFL
     C                   CLEAR                   DDES
     C                   CLEAR                   INO04
     C                   MOVEL     PODN10        INO04
     C     INO04         CHAIN(N)  IVFTNSK                            41
     C     *IN41         IFEQ      *OFF
     C                   MOVEL     IDN01         DDES
     C                   ENDIF
     C                   MOVE      *BLANKS       DITM
     C                   MOVEL     PODN10        DITM
     C                   Z-ADD     0             DNO7
     C                   MOVE      PODN10        DITMX
     C                   MOVEL     PODN10        NS4LNG            4
     C                   MOVE      NS4LNG        DSECX
     C                   ADD       1             IX                3 0
     C                   MOVE      PODN10        NSI(IX)                        NS THIS PO
      *  NON-STOCK IDENTIFIER PREVIOUSLY ASSIGNED
     C                   MOVE      'P'           DASN
¢8   C                   MOVEL     DITM          DSORGPROD
     C                   ELSE
     C     POCD13        IFEQ      'C'                                          COMMENTS
     C     LINKEY        CHAIN     POFTOT                             41        FILE
     C                   MOVEL     PODN08        DDES
     C                   MOVEL     PODN10        DITM
     C                   Z-ADD     0             DNO7
¢8   C                   MOVE      *BLANKS       DSORGPROD
     C                   END
     C                   END
     C                   END
      *
     C                   Z-ADD     POAM01        PUAMDL
     C                   Z-ADD     POAM02        PUAMDF
     C                   Z-ADD     POQY01        UQYDF                          STCK QTY ORD
     C                   Z-ADD     POQY01        UQYDFO                         STCK QTY ORD
     C                   Z-ADD     POQYU1        DQTY                           QTY ORDERED
     C                   Z-ADD     POQYU1        DOQTY                          ORIG QTY ORD
     C                   Z-ADD     POQYOF        UOMDF                          ORD UOM FCT
     C                   Z-ADD     POQYPF        PUOMDF                         PRC UOM FCT
     C                   Z-ADD     POQY03        DQYR                           QTY RECEIVED
     C                   Z-ADD     POQYU3        DQYRO                          QTY RCVD ORD UM
   IZC*                  MOVE      IVNO22        DMAN                           MANUFACTURER #
IZ   C                   MOVE      IVNO93        DMAN                           MANUFACTURER #
#4   C                   MOVE      IVNO22        DVENQ
     C                   MOVE      PODN03        DUOM                           ORDERED UOM
     C                   MOVE      PODN03        DOUOM                          ORDERED UOM
     C                   MOVE      PODN04        DUMP                           PRICING UOM
     C                   Z-ADD     POAMU1        DLST                           LIST PRICE
     C                   Z-ADD     POAMU2        DCST                           UNIT COST
     C                   MOVE      POPC02        DDSC                           ITEM DISCOUNT
     C                   MOVE      POCD16        DDOV                           DISC OVERRIDE
     C                   MOVE      POCD17        DCOV                           COST OVERRIDE
     C                   Z-ADD     PONO05        DSORLN                         ORIG. LINE #
I0   C                   Z-ADD     PONO05        DSORGL                         ORIG. LINE #
     C                   MOVE      POCD13        DSCD13                                     E
     C                   MOVE      POCD19        DSCD19                                     E
     C                   MOVEL     MMDD13        ETADO                          MTH, DAY, & E
     C                   MOVE      POYR13        ETADO                          YR ORIG ETA E
     C                   MOVEL     MMDD15        ETADR                          MTH, DAY, & E
     C                   MOVE      POYR15        ETADR                          YR RVSD ETA E
     C                   Z-ADD     ETADO         SAVDO                          SAVE ORIG ETA
     C                   Z-ADD     ETADR         SAVDR                          SAVE REVISED ETA
     C                   Z-ADD     0             DODIFF                                      ETA
JL   C                   eval      dfl67 = pofl67
JL   C                   eval      dhdfl67 = pofl67
     C     POCD14        IFEQ      'Y'
     C                   Z-ADD     X             DKEY                           LINE NUMBER
     C                   Z-ADD     X             KEY1                           LINE NUMBER
     C                   ELSE
     C                   Z-ADD     0             DKEY                           LINE NUMBER
     C                   END
      *
      * If WM branch, check whether item is On-ASN in WM system or not.
      * If On-ASN,    protect product# (i.e. it cannot be deleted)
      *               it will be edited to ensure that the user do
      *               not increase P/O qty.
      *               User can still add line item for a new product
      *                    or an existing product.
      *
     C                   MOVE      'N'           DONASN
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     POCD13        IFEQ      'S'                                          STOCKED ITEM
     C     POCD13        OREQ      'N'                                          NON-STOCK ITEM
     C                   EXSR      CHKASN
     C     HDSTAT        IFEQ      '*'
     C                   MOVE      'Y'           DONASN
     C                   ELSE
     C     HDSTAT        IFEQ      '0'
     C                   MOVE      '0'           DONASN
     C                   ELSE
     C                   MOVE      'N'           DONASN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Load tag & hold array
     C     POCD42        IFNE      'Y'                                          NOT A LOT PO
     C                   MOVE      POCD14        DTYP                           TAG CODE
     C                   ELSE
     C                   MOVE      'N'           DTYP                           NONSTOCK TYPE
     C                   ENDIF
     C     POCD14        IFEQ      'Y'                                          TAG & HOLD
     C     LINKEY        SETLL     POFTTG
     C     *IN41         DOUEQ     '1'
     C     LINKEY        READE(N)  POFTTG                                 41
     C     *IN41         IFEQ      '0'
     C     POCD15        IFEQ      'T'
     C     POCD15        OREQ      'F'
     C     POCD15        OREQ      *BLANKS
     C                   MOVE      POCD15        TTYP                           TYPE TAG & HOLD
     C                   MOVE      *BLANKS       ORDTYP
     C                   ELSE
     C                   SELECT
     C     POCD15        WHENEQ    '1'
     C                   MOVE      'SO'          ORDTYP
   HHC*    IVNO55        IFNE      *ZEROS
HH   C     TGNO01        IFNE      *ZEROS
HI   C     TGNO01        ANDNE     *BLANKS
     C                   MOVE      'S'           POCD45
   HHC*                  Z-ADD     IVNO55        PONO57                         TAG REF#
   HHC*                  Z-ADD     IVNO92        PONO58                         CONTROL #
HH   C                   MOVE      TGNO01        PONO57                         TAG REF#
HH   C                   Z-ADD     TGNO22        PONO58                         CONTROL #
     C                   WRITE     POFWTAG
     C                   ENDIF
     C                   ADD       1             SOTCNT
     C     POCD15        WHENEQ    '2'
     C                   MOVE      'TR'          ORDTYP
     C                   MOVE      'T'           POCD45
   HIC*                  Z-ADD     IVNO55        PONO57                         ORIG#
HI   C                   MOVE      IVNO55        PONO57                         ORIG#
     C                   Z-ADD     IVNO92        PONO58                         CONTROL #
     C                   WRITE     POFWTAG
     C                   ADD       1             TRTCNT
     C     POCD15        WHENEQ    '3'
     C                   MOVE      'CO'          ORDTYP
     C                   ADD       1             COTCNT
     C     POCD15        WHENEQ    '4'
     C                   MOVE      'WO'          ORDTYP
     C                   ADD       1             WOTCNT
     C                   ENDSL
     C                   MOVE      *BLANKS       TTYP
     C                   ENDIF
     C                   Z-ADD     POQY02        TQTY                           TAGGED QTY
     C                   Z-ADD     PONO09        TBRA                           TAGGED BRANCH
     C                   Z-ADD     PONO10        TCUS                           TAGGED CUSTOMER
   HIC*                  Z-ADD     PONO11        TREF                           TAGGED REF #
HI   C                   MOVE      PONO11        TREF                           TAGGED REF #
     C                   Z-ADD     POQY06        TQTYF                          TAG QTY FILLED
     C                   MOVE      PODN06        TCOM                           TAG COMMENTS
HH   C                   IF        POCD15 = '1'
HH   C                             OR POCD15 = '3'
HH   C                   MOVE      TGNO01        TTORG                          ORIG #
HH   C                   Z-ADD     TGNO22        TTCTL                          CONTROL #
HH   C                   ELSE
   HIC*                  Z-ADD     IVNO55        TTORG                          ORIG #
HI   C                   MOVE      IVNO55        TTORG                          ORIG #
     C                   Z-ADD     IVNO92        TTCTL                          CONTROL #
HH   C                   ENDIF
     C                   CLEAR                   TLIN                           TAG LINE#
     C                   CLEAR                   ONO26
      * IF THIS IS A SALES ORDER TAG, THEN...
     C     POCD15        IFEQ      '1'
      * Retrieve original order number;
     C     TREF          CHAIN     OELTOHY8                           43
      * Using item#, orig order#, P/O#, & P/O line#, retrieve S/O line#
     C     *IN43         IFEQ      *OFF
     C     OKEY3         SETLL     OELTOL15
     C     *IN43         DOUEQ     *ON
     C     OKEY3         READE     OELTOL15                               43
     C     *IN43         IFEQ      *OFF
     C     TTCTL         IFNE      *ZEROS
     C     OENO22        ANDNE     TTCTL
     C                   ITER
     C                   ENDIF
     C                   Z-ADD     OENO22        TLIN
      * IF THIS IS A DIRECT, RETRIEVE CURRENT QTY FROM SALES ORDER...
      * IF BACKORDER QTY IS ZERO, USE ORDERED QTY...
     C     OECD01        IFEQ      'D'                                          DIRECT
     C     OEQY02        IFNE      0
     C                   Z-ADD     OEQY02        TQTY
     C                   ELSE
     C                   Z-ADD     OEQY01        TQTY
     C                   ENDIF
#1   C                   Z-ADD     OEAM01        DSSELPRC
#1   C                   Z-ADD     OEAM02        DSSELCST
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             ZZ                             ARRARY INDEX
     C                   Z-ADD     X             KY(ZZ)                         LINE NUMBER
     C                   MOVE      TAGH          TH(ZZ)
      * IF THIS IS A SALES ORDER TAG, UPDATE REFERENCE NUMBER...
     C     POCD15        IFEQ      '1'
   HIC*                  Z-ADD     ONO26         OREF                           S.O. TAG REF
HI   C                   MOVE      ONO26         OREF                           S.O. TAG REF
     C                   ENDIF
     C                   MOVE      TLIN          OLIN                           S.O. TAG REF
     C                   MOVE      OSK           OS(ZZ)                         S.O. TAG REF
     C                   MOVE      X             PL(ZZ)                         S.O. TAG REF
   HIC*    PONO11        IFNE      0
   HIC*                  Z-ADD     PONO11        ORGORD                         ORIG. ORDER#
HI   C     PONO11        IFNE      *ZEROS
HI   C     PONO11        ANDNE     *BLANKS
HI   C                   MOVE      PONO11        ORGORD                         ORIG. ORDER#
     C                   END
     C                   END
     C                   END
     C                   END
     C     DSORLN        OCCUR     SAVDSR
     C                   MOVE      SAVDS         SAVDSR
     C                   MOVE      *BLANKS       RSCD29                         REVISION CODE
      *
      * LOT P/O
      *
     C     POCD42        IFEQ      'Y'
     C     LODDTL        ANDEQ     ' '
     C     TOAD1         IFEQ      *BLANK
     C                   MOVE      'Y'           TOAD1             1
     C                   OPEN      OELTOAD1
     C                   ENDIF
     C     TOAD          IFEQ      *BLANK
     C                   MOVE      'Y'           TOAD
     C                   OPEN      OELTOAD2
     C                   ENDIF
      *
     C     PONO01        CHAIN     OEFTOAD2                           42
     C     *IN42         DOWEQ     *OFF
     C                   ADD       1             X
     C     X             OCCUR     SAVDS
     C                   CLEAR                   SFDS                           INIT SFL DS
      *
      * STOCKED ITEM
      *
     C     OECD85        IFEQ      'I'                                          STOCK ITM
     C     OECD85        OREQ      'P'                                          STOCK ITM
     C     ADNO07        CHAIN     IVFITEM                            44
     C     *IN44         IFEQ      *OFF
     C                   Z-ADD     ADNO07        IVNO7
     C                   MOVEL     IVDN01        DESC
     C     OECD85        IFEQ      'I'                                          ITEM#
   ¢PC*                  MOVEL     ADNO07        PROD
¢P   C                   MOVEL     IVNO04        PROD
     C                   ELSE                                                   PRODUCT#
     C                   MOVEL     IVNO04        PROD
     C                   ENDIF
     C                   ENDIF                                                  EIF 44
      *
      * NONSTOCK ITEM/COMMENT
      *
     C                   ELSE
     C                   MOVEL     OEDN12        PROD                           NSTK#
     C     OECD85        IFEQ      'N'                                          NONSTOCK
     C                   CLEAR                   IVNO04
     C                   MOVEL     OEDN12        IVNO04
     C     IVNO04        CHAIN(N)  IVFTNSK                            44
     C     *IN44         IFEQ      *OFF
     C                   MOVEL     IDN01         DESC
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     OEDN13        DESC                           NSTK DESCR
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'D'           TYP
     C                   Z-ADD     OEQY18        QTY
     C                   Z-ADD     OEQY18        OQTY
     C                   MOVE      ADDN04        UOM
     C                   MOVE      ADDN04        PUOM
     C                   Z-ADD     ADNO56        CTRL
     C                   MOVE      OEDN12        NSITMX                         LOT NONSTK 8
     C                   MOVE      'Y'           CMTFLG                         COMMENT FLAG
     C                   MOVE      SFDS          SAVDS
     C     PONO01        READE     OEFTOAD2                               42
     C                   ENDDO
     C                   MOVE      'Y'           LODDTL            1
     C                   ENDIF
     C                   END
     C                   END
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    EXTENDED DESCRIPTIONS                                   *
      *------------------------------------------------------------------------*
     C     EXTDSC        BEGSR
     C     IVNO07        SETLL     IVFMEXT                                40
     C     *IN40         IFEQ      '1'
     C     *IN41         DOUEQ     '1'
     C     IVNO07        READE     IVFMEXT                                41
     C     *IN41         IFEQ      '0'
     C                   Z-ADD     0             KEY                            TAG & HOLD KEY
     C                   Z-ADD     0             IVNO7                          ITEM NUMBER
     C                   Z-ADD     0             LIST                           LIST
     C                   MOVE      *BLANKS       DISC                           DISC PERCENT
     C                   MOVE      ' '           DOVR                           DISC OVRRIDE
     C                   Z-ADD     0             COST                           UNIT COST
     C                   MOVE      ' '           COVR                           COST OVRRIDE
     C                   MOVE      ' '           SEL                            SELECT FIELD
     C                   Z-ADD     0             QTY                            QTY ORDERED
#4   C                   Z-ADD     0             QTYO
     C                   MOVE      *BLANKS       ZZNO04                         ITEM NUMBER
     C                   MOVE      *BLANKS       SVNO04                         ITEM NUMBER
     C                   CLEAR                   PRT
     C                   MOVE      *BLANKS       PROD                           ITEM NUMBER
     C                   MOVE      *BLANKS       MAN                            MANUFACTURER
#4   C                   MOVE      *BLANKS       VENQ
     C                   MOVE      '   '         UOM                            ORDERED UOM
     C                   MOVEL     IVDN18        DESC                           DESCRIPTION
     C                   MOVEL     IVDN18        ZZDN01                         DESCRIPTION
     C                   MOVE      ' '           BLKTAG                         TAG & HOLD
     C                   MOVE      'E'           TYP                            EXTENDED DESC
     C                   MOVE      '   '         PUOM                           PRICING UOM
     C                   ADD       1             RRN
     C     WHERE1        IFEQ      'E'
     C                   MOVEA     '1'           *IN(21)                        PROTECT
¢8    * Check to see if this is an original line
¢8    * If so, then the item needs to be protected if po sent to vendor
¢8   C                   MOVE      *OFF          *IN28
#5 :AC*                  IF        ediSolution <> 'SPS'
¢8 :AC*                  IF        SFORGPROD <> *BLANKS
¢8 :AC*                  IF        SentToVendor = 'Y'
:A   C                   IF        SFORGPROD <> *BLANKS and
:A   C                             SentToVendor = 'Y'
¢8   C                   MOVE      *ON           *IN28
¢8   C                   ENDIF
¢8 :AC*                  ENDIF
#5 :AC*                  ENDIF
     C     ITMSIZ        IFEQ      400
:A   C                   IF        SFORLN > 0
:A   C                   EVAL      POLine = %editc(SFORLN:'X')
:A   C                   ELSE
:A   C                   EVAL      PoLine = *blanks
:A   C                   ENDIF
     C                   WRITE     POS0120E                                     ENTRY S/F
     C                   ELSE
     C                   WRITE     POS0120N                                     ENTRY S/F DR
     C                   END
     C                   ELSE
      *
      * WHEN PRICE FACTOR IN DECIMAL, SET *IN34 TO *ON TO DISPLAY
      * PRICE FACTOR IN DECIMAL,
      * ELSE SET *IN34 TO *OFF TO DISPLAY AS WHOLE NUMBER.
     C                   Z-ADD     PUOMSF        XUOMSF
     C     RDEC          IFNE      0
     C                   MOVE      '1'           *IN34
     C                   ELSE
     C                   MOVE      '0'           *IN34
     C                   ENDIF
     C                   MOVEA     '1'           *IN(82)                        PROTECT NON-DSP
G5   C                   CLEAR                   PDDS35                         DESCRIPTION
G5   C                   MOVEL     DESC          PDDS35                         DESCRIPTION
IM   C                   MOVEA     '1'           *IN(60)                        PROTECT
JL   C                   eval      *in55 = '1'
#4   C                   CLEAR                   PDDS20                         DESCRIPTION
#4   C                   MOVEL     DESC          PDDS20                         DESCRIPTION
     C                   WRITE     POS0120G                                     PRICING S/F
IM   C                   MOVEA     '0'           *IN(60)                        PROTECT
     C                   MOVEA     '0'           *IN(82)                        PROTECT NON-DSP
     C                   END
     C                   MOVEA     '0'           *IN(21)                        PROTECT
     C                   END
     C                   END
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    INITIALIZE FIELDS                                       *
      *------------------------------------------------------------------------*
     C     INITSR        BEGSR
IR   C                   MOVE      PONO01        SVNO01
     C                   CLEAR                   WMMSG
     C                   MOVE      *OFF          CBOWRN
I0   C                   MOVE      'N'           INSFLG            1
I0   C                   CLEAR                   INSX
I0   C                   CLEAR                   INSCOM            1
     C                   Z-ADD     400           ITMSIZ            3 0          REG SF SIZE
     C                   Z-ADD     990           MAXKY             3 0          MAX TAGS
     C                   MOVE      ' '           ONCE              1            1 TIME ONLY
     C                   MOVE      'UIDS'        TABCOD                         USER AUTH
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     USRNM         TABENT                         USERID
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C  N40              MOVEL     TBNO03        SECPRF            7            PROFILE
      * GET ALLOW ZERO COST Y/N CODE
     C                   MOVE      'PO10'        TABCOD
     C                   MOVE      *BLANK        TABENT
     C                   MOVEL     'COST'        TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TBNO03        ZCOST             1
     C                   ELSE
     C                   MOVE      'Y'           ZCOST
     C                   END
      *
     C                   CLEAR                   SFDS                           INIT SFL DS
     C                   MOVE      *BLANKS       NSI
     C                   Z-ADD     0             IX
     C                   MOVE      ' '           CMD12             1            CMD 12 PREVIOUS
     C                   MOVE      ' '           OURTRK                         METHOD OF
     C                   MOVE      ' '           SHIPED                            "
     C                   MOVE      'N'           PRNTPO                         PRINT P/O
     C                   MOVE      'N'           PRNTRV                         PRINT REV P/O
     C                   MOVE      'N'           FRSTSP            1            FRST TIME THRU
     C                   MOVE      'Y'           FRSTHR            1            FRST TIME THRU
     C                   MOVE      'C'           PRCD21                         PURCH STATUS
     C                   MOVE      *BLANKS       SNAME                          SHIPPING NAME
     C                   MOVE      *BLANKS       SADD1                          SHIPING ADDRS 1
     C                   MOVE      *BLANKS       SADD2                          SHIPING ADDRS 2
     C                   MOVE      *BLANKS       SADD3                          SHIPING ADDRS 3
     C                   MOVE      *BLANKS       SCITY                          SHIPING CITY
     C                   MOVE      '  '          SSTAT                          SHIPING STATE
     C                   MOVE      *BLANKS       SMAIN                          SHIPING MAIN ZI
     C                   MOVE      *BLANKS       MNAME                          MAILING NAME
     C                   MOVE      *BLANKS       MADD1                          MAILING ADDRS 1
     C                   MOVE      *BLANKS       MADD2                          MAILING ADDRS 2
     C                   MOVE      *BLANKS       MADD3                          MAILING ADDRS 3
     C                   MOVE      *BLANKS       MCITY                          MAILING CITY
     C                   MOVE      '  '          MSTAT                          MAILING STATE
     C                   CLEAR                   MFAX1C
     C                   CLEAR                   MFAX2C
     C                   CLEAR                   MFAX3C
     C                   MOVE      *BLANKS       MMAIN                          MAILING MAIN ZI
     C                   MOVE      *BLANKS       PONM03                         OVRRIDE NAME
     C                   MOVE      *BLANKS       POAD01                         OVRRIDE ADDRS 1
     C                   MOVE      *BLANKS       POAD02                         OVRRIDE ADDRS 2
     C                   MOVE      *BLANKS       POAD03                         OVRRIDE ADDRS 3
     C                   MOVE      *BLANKS       POCY01                         OVRRIDE CITY
     C                   MOVE      '  '          POST01                         OVRRIDE STATE
     C                   MOVE      *BLANKS       POZP03                         OVRRIDE MAIN ZI
     C                   CLEAR                   POO22
     C                   CLEAR                   POO23
     C                   CLEAR                   POO24
     C                   CLEAR                   POO32
     C                   CLEAR                   POO33
     C                   CLEAR                   POO34
     C                   MOVE      *BLANKS       ARNM01                         CUSTOMER NAME
     C                   MOVE      *BLANKS       ARAD04                         CUS SHIP ADDRS1
     C                   MOVE      *BLANKS       ARAD05                         CUS SHIP ADDRS2
     C                   MOVE      *BLANKS       ARAD06                         CUS SHIP ADDRS3
     C                   MOVE      *BLANKS       ARCY02                         CUS SHIP CITY
     C                   MOVE      '  '          ARST02                         CUS SHIP STATE
     C                   MOVE      *BLANKS       ARZP16                         CUS SHIP MAIN Z
     C                   MOVE      *BLANKS       APNM01                         VENDOR NAME
     C                   MOVE      *BLANKS       APAD04                         VEN MAIL ADDRS1
     C                   MOVE      *BLANKS       APAD05                         VEN MAIL ADDRS2
     C                   MOVE      *BLANKS       APAD06                         VEN MAIL ADDRS3
     C                   MOVE      *BLANKS       APCY02                         VEN MAIL CITY
     C                   MOVE      '  '          APST02                         VEN MAIL STATE
     C                   MOVE      *BLANKS       APZP08                         VEN MAIL MAIN Z
     C                   CLEAR                   APNO22
     C                   CLEAR                   APNO23
     C                   CLEAR                   APNO24
     C                   CLEAR                   APNO32
     C                   CLEAR                   APNO33
     C                   CLEAR                   APNO34
     C                   MOVE      *BLANKS       UNNAME                         UNAPPROVED NAME
     C                   MOVE      *BLANKS       APAD01                         VEN CORP ADDS 1
     C                   MOVE      *BLANKS       APAD02                         VEN CORP ADDS 2
     C                   MOVE      *BLANKS       APAD03                         VEN CORP ADDS 3
     C                   MOVE      *BLANKS       APCY01                         VEN CORP CITY
     C                   MOVE      '  '          APST01                         VEN CORP STATE
     C                   MOVE      *BLANKS       APZP07                         VEN CORP MAIN Z
     C                   CLEAR                   APNO02
     C                   CLEAR                   APNO03
     C                   CLEAR                   APNO04
     C                   CLEAR                   VMO32
     C                   CLEAR                   VMO33
     C                   CLEAR                   VMO34
     C                   MOVE      *BLANKS       SAVE41                         POCD41 SAVE
     C                   Z-ADD     0             SAVESB                         SHIPBR SAVE
     C                   Z-ADD     0             POMO02                         ORDERED DAY
     C                   Z-ADD     0             PODY02                         ORDERED MONTH
     C                   Z-ADD     0             POCC02                         ORDERED CENTURY
     C                   Z-ADD     0             POYR02                         ORDERED YEAR
     C                   Z-ADD     0             ORDDAT                         ORDERED DATE
     C                   Z-ADD     UDATE         ORDDAT                         ORDERED DATE
     C                   MOVEL     *YEAR         POCC02                         ORDERED CENTURY
     C                   Z-ADD     0             POMO03                         ETA DAY
     C                   Z-ADD     0             PODY03                         ETA MONTH
     C                   Z-ADD     0             POCC03                         ETA CENTURY
     C                   Z-ADD     0             POYR03                         ETA YEAR
     C                   Z-ADD     0             ETAOH                          ETA ORIG HDR
     C                   Z-ADD     0             POCC14                         ETA RVSD CENTURY
     C                   Z-ADD     0             ETARH                          ETA RVSD HDR
     C                   Z-ADD     0             SAVOH                          ETA ORIG SAV HDR
     C                   Z-ADD     0             SAVRH                          ETA RVSD SAV HDR
     C                   CLEAR                   ETCYMD                         CLEAR DATA
     C                   CLEAR                   ORCYMD                         CLEAR DATA
     C                   CLEAR                   ETLMDY                         CLR DTA STR ETA LINI
     C                   CLEAR                   TLCYMD                         CLEAR DATA
     C                   CLEAR                   TRCYMD                         CLR DTA STR REVS YMD
     C                   CLEAR                   ETRMDY                         CLR DTA STR REVS MDY
     C                   CLEAR                   RLCYMD                         CLR DTA STR REVS YMD
     C                   CLEAR                   SHCYMD                         CLEAR DATA
     C                   CLEAR                   SHPWRN
     C                   CLEAR                   RNS                            TOTAL RNS ITEMS
     C                   MOVE      *ON           *IN28                          DFLT SFLDROP
I2   C                   Z-ADD     0             POCC50                         DOWNLOAD CENTURY
I2   C                   Z-ADD     0             DWNDAT                         DOWNLOAD DATE
     C                   Z-ADD     0             POMO04                         SHIPPING DAY
     C                   Z-ADD     0             PODY04                         SHIPPING MONTH
     C                   Z-ADD     0             POCC04                         SHIPPING CENTURY
     C                   Z-ADD     0             POYR04                         SHIPPING YEAR
     C                   Z-ADD     0             SHPDAT                         SHIPPING DATE
     C                   Z-ADD     0             POMO06                         DUE DATE DAY
     C                   Z-ADD     0             PODY06                         DUE DATE MONTH
     C                   Z-ADD     0             POCC06                         DUE DATE CENTURY
     C                   Z-ADD     0             POYR06                         DUE DATE YEAR
     C                   Z-ADD     0             DUEDAT                         DUE DATE
     C                   Z-ADD     0             MAXDT                          UDATE + 1 YR
     C                   Z-ADD     UMONTH        MAXMO                          UDATE + 1 YR
     C                   Z-ADD     UDAY          MAXDY                          UDATE + 1 YR
     C     *YEAR         ADD       1             MAXCY                          UDATE + 1 YR
     C                   Z-ADD     0             MINDT                          UDATE - 1 YR
     C                   Z-ADD     UMONTH        MINMO                          UDATE - 1 YR
     C                   Z-ADD     UDAY          MINDY                          UDATE - 1 YR
     C     *YEAR         SUB       1             MINCY                          UDATE - 1 YR
     C                   Z-ADD     0             MO02                           ORDERED DAY
     C                   Z-ADD     0             DY02                           ORDERED MONTH
     C                   Z-ADD     0             CC02                           ORDERED CENTURY
     C                   Z-ADD     0             YR02                           ORDERED YEAR
     C                   Z-ADD     0             DATE2                          ORDERED DATE
     C                   Z-ADD     0             MO04                           SHIPPING DAY
     C                   Z-ADD     0             DY04                           SHIPPING MONTH
     C                   Z-ADD     0             CC04                           SHIPPING CENTURY
     C                   Z-ADD     0             YR04                           SHIPPING YEAR
     C                   Z-ADD     0             DATE4                          SHIPPING DATE
     C                   Z-ADD     0             POMO11                         ENTERED MONTH
     C                   Z-ADD     0             PODY11                         ENTERED DAY
     C                   Z-ADD     0             POCC11                         ENTERED CENTURY
     C                   Z-ADD     0             POYR11                         ENTERED YEAR
     C                   Z-ADD     0             DATENT                         ENTERED DATE
     C                   Z-ADD     0             IVMO16                         LAST PURCH MO
     C                   Z-ADD     0             IVDY16                         LAST PURCH DAY
     C                   Z-ADD     0             IVCC16                         LAST PURCH CENTURY
     C                   Z-ADD     0             IVYR16                         LAST PURCH YEAR
     C                   Z-ADD     0             LSTPUR                         LAST PURCH DATE
     C                   Z-ADD     0             TEL1C                          PHONE WRKFLD
     C                   Z-ADD     0             TEL2C                          PHONE WRKFLD
     C                   Z-ADD     0             TEL3C                          PHONE WRKFLD
     C                   Z-ADD     0             FAX1C                          FAX WRKFLD
     C                   Z-ADD     0             FAX2C                          FAX WRKFLD
     C                   Z-ADD     0             FAX3C                          FAX WRKFLD
     C                   MOVE      'N'           SNDFAX                         SEND FAX
     C                   MOVE      *BLANKS       REQMO                          REQUESTED FAX MONTH
     C                   MOVE      *BLANKS       REQDAY                         REQUESTED FAX DAY
     C                   MOVE      *BLANKS       REQYR                          REQUESTED FAX YEAR
     C                   MOVE      *BLANKS       REQTIM                         REQUESTED FAX TIME
     C                   MOVE      *OFF          SVIN52            1            EDIT FAX OPTIONIME
     C                   MOVE      *BLANKS       I1                             1ST DIGIT ITEM#
     C                   MOVE      *BLANKS       I2                             1ST 2ND DIGIT
     C                   MOVE      *BLANKS       I2                             3RD-12 DIGIT
     C                   MOVE      *BLANKS       ITM1                           6 DIGIT ITEM #
     C                   MOVE      *BLANKS       ITM                            12 DIGIT ITEM #
     C                   MOVE      *BLANKS       ZZNO04                         PRODUCT NUMBER
     C                   MOVE      *BLANKS       SVNO04                         ITEM NUMBER
     C                   Z-ADD     0             ZZ                3 0          TAG & HOLD
     C                   Z-ADD     0             KEY1              3 0          TAG & HOLD
     C                   MOVE      ' '           TTYP                           TYPE---TAG&HOLD
     C                   Z-ADD     0             TQTY                           QTY----TAG&HOLD
     C                   CLEAR                   TLIN                           P/O LINE#
     C                   Z-ADD     0             TBRA                           BRANCH-TAG&HOLD
     C                   Z-ADD     0             TCUS                           CUSTMR-TAG&HOLD
     C                   Z-ADD     0             TQTYF                          TAG QTY FILLED
   HIC*                  Z-ADD     0             TREF                           REFRE#-TAG&HOLD
   HIC*                  Z-ADD     0             ORGORD            7 0          ORIG ORDER# OLD
HI   C                   MOVE      *BLANKS       TREF                           REFRE#-TAG&HOLD
HI   C                   MOVE      *ZEROS        ORGORD            7            ORIG ORDER# OLD
     C                   Z-ADD     *ZEROS        KY
     C                   MOVEA     *ZEROS        TH
     C                   CLEAR                   PL
     C                   CLEAR                   OS
     C                   Z-ADD     0             Z                              BLANK/ZERO OUT
     C                   MOVE      ' '           P1                             *****
     C                   MOVE      *BLANKS       P2                             *****
     C                   MOVE      '  '          PC1                            DISCOUNT
     C                   MOVE      '  '          PC2                            DATA STRUCTURE
     C                   MOVE      '  '          PC3                            *****
     C                   MOVE      *BLANKS       PCPC01                         *****
     C                   MOVE      *BLANKS       ZZNO04                         ITEM NUMBER
     C                   MOVE      *BLANKS       SVNO04                         ITEM NUMBER
     C                   MOVE      *BLANKS       ZZDN01                         DESCRIPTION
JM   C                   Clear                   BlkTag                         Tag flag
      *
      * HEADER FILE
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     PONO01        CHAIN     POFTOH                             4092
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
KB    * GET QUOTE #
KB   C                   MOVE      *BLANKS       POCDA4
KB   C     PONO01        CHAIN(N)  POFTOHA
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
JP JSC*                  If        pocd42 = 'Y'                                 lot item flag
JP JSC*                  Z-ADD     2             NXTLN#                         NEXT LINE#
JP JSC*                  else
   JJC*                  Z-ADD     PONO16        NXTLN#            3 0          NEXT LINE#
JP JSC*                  Z-ADD     1             NXTLN#            3 0          NEXT LINE#
JP JSC*                  EndIf
JT    * If this is a Lot PO, begin next available line with 2, as there can only be 1 item...
JT    * Even though there is really only one POPTOL record for a Lot PO, the program later
JT    * increments the next available value based on the number of Lot components... As that
JT    * is how PO Entry currently works, PO Maintenance will retain that type of logic...
JT    * This change prevents the Next Avail Line on PO Header from continually growing
JT    * by the number of components each time PO is maintained (even if no changes are made)...
JT   C                   if        pocd42 = 'Y'
JT   C                   Z-ADD     2             NXTLN#
JT   C                   Z-ADD     2             SVNXTLN#
JT   C                   else
JS   C                   Z-ADD     PONO16        NXTLN#            3 0          NEXT LINE#
I0   C                   Z-ADD     PONO16        SVNXTLN#          3 0          SAVED NEXT LINE#
JT   C                   endif
     C                   MOVE      POCD12        SVCD12                         SAVE POCD12
     C                   MOVE      POCD20        POSTS
     C                   MOVE      APNO01        VNDNUM
      * IND 60 WILL PROTECT P/O TYPE (POCD01)
     C     PONO01        SETLL     POFTRH                                 60    REC RPT EXIST
     C                   MOVE      *IN60         SVIN60            1
HD   C     *IN60         IFEQ      '1'                                          METHOD
HD   C                   MOVE      'Y'           RCVFND            1            METHOD
I0   C                   ELSE
I0   C                   MOVE      ' '           RCVFND
HD   C                   ENDIF                                                  METHOD
     C     POCD10        IFEQ      'O'                                          METHOD
     C                   MOVE      'X'           OURTRK                          OF
     C                   END                                                      SHIPMENT
     C     POCD10        IFEQ      'S'                                             "
     C                   MOVE      'X'           SHIPED                            "
     C                   END                                                       "
     C                   Z-ADD     PONO13        SAVCUS                         SHIP TO CUSTR
     C                   MOVE      'Y'           FRSTLN            1            1ST TIME THRU
     C                   Z-ADD     ITMSIZ        MAXDS
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
      * DETERMINE IF WM INSTALLED AT BRANCH
     C                   MOVE      'N'           WHMBR
     C     WHMYES        IFEQ      'Y'
     C                   CLEAR                   WMCOBR
     C                   CLEAR                   WHMBR
     C     PONO02        CHAIN     ARFMBCH                            40
     C                   Z-ADD     ARNO15        WMCO#
     C                   Z-ADD     PONO02        WMBR#
HU   C                   Z-ADD     *ZEROS        WMCO#
     C                   CALL      'WIC0116'
     C                   PARM                    WMCOBR
     C                   PARM                    WHMBR             1
     C                   ENDIF
G3    *
G3    *  WHMTYP IS SET "N" FOR TYPES D, O, & F.
G3   C     WHMYES        IFEQ      'Y'
G3   C     POCD01        ANDNE     'D'
G3   C     POCD01        ANDNE     'O'
G3   C     POCD01        ANDNE     'F'
G3   C                   MOVE      'Y'           WHMTYP            1
G3   C                   ELSE
G3   C                   MOVE      'N'           WHMTYP
G3   C                   ENDIF
IG    * Delete existing Data Queue
IG   C                   If        DQNAME <> *Blanks and DQLIB <> *Blanks
IG   C                   Call      'WIC9900'
IG   C                   Parm                    DQNAME
IG   C                   Parm      #BIPGM        DQLIB
IG   C                   Parm      'D'           DQACT
IG   C                   Eval      DQFLG = 'N'
IG   C                   Endif
      *
      * IF WM BRANCH, CREATE TEMP DATA QUEUE TO GET DATA FROM WM SYSTEM
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     DQFLG         ANDNE     'Y'
     C                   TIME                    TIME#             6 0
     C                   MOVE      TIME#         TIMEA             6
     C     'DQ'          CAT(P)    TIMEA:0       DQNAME           10
     C                   CALL      'WIC9900'
     C                   PARM                    DQNAME
     C                   PARM      #BIPGM        DQLIB            10
     C                   PARM      'C'           DQACT             1
     C                   MOVE      'Y'           DQFLG
     C                   ENDIF
      *
      * If WM branch, check whether open ASN in WM system or not.
      * If one exists, prevent P/O Type and P/O Ship To branch from
      * being changed. Do the same if no response from WM as this is
      * how the line item product numbers are being treated...
      *
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C                   MOVE      'Y'           MFILE             1
     C                   EXSR      CHKASN
     C                   CLEAR                   MFILE
     C     HDSTAT        IFEQ      '*'
     C     HDSTAT        OREQ      '0'
     C     HDSTAT        OREQ      'E'
     C                   SELECT
     C     HDSTAT        WHENEQ    '*'
     C                   MOVEL     WMERR1        WMMSG
     C     HDSTAT        WHENEQ    '0'
     C                   MOVEL     WMERR2        WMMSG
     C     HDSTAT        WHENEQ    'E'
     C                   MOVEL     WMERR3        WMMSG
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      BLKDS                                        BLANK/ZERO DS
      * LOAD W/HIGHEST OCCURENCE NUMBER (MAXIMUM DS SIZE)...
     C                   Z-ADD     X             MAXDS
     C                   MOVE      'N'           FRSTLN                         1ST TIME THRU
     C     POCD09        IFEQ      'U'                                          VENDOR SETUP ?
     C                   MOVEA     '1'           *IN(50)                        UNAPPROVED VEND
     C                   ELSE
     C                   MOVEA     '0'           *IN(50)                        UNAPPROVED VEND
     C                   END
     C     APNO01        CHAIN     APFMVEN                            40        VENDOR MASTER
     C     APCD28        IFNE      'Y'                                          APPROVED VENDOR
     C                   MOVEA     '0'           *IN(50)
     C                   MOVE      'A'           POCD09
     C                   ELSE
     C                   MOVEA     '1'           *IN(50)
     C                   MOVE      'U'           POCD09
     C                   END
     C                   MOVE      APNM01        UNNAME                         CORPORATE
      *
      * MAILING ADDRESS
     C     POCD06        IFNE      'Y'                                          NO OVRRIDE
     C                   MOVE      '1'           APCD08                         TYPE CODE
     C                   Z-ADD     PONO14        SEQMAL                         SEQUENCE #
     C                   Z-ADD     PONO14        NO28                           SEQUENCE #
     C     MAILKY        CHAIN     APFMVAD                            40
     C     *IN40         IFEQ      '0'
     C                   MOVE      AVMAIL        MMAIL
     C                   MOVE      APNO32        FAX1C
     C                   MOVE      APNO33        FAX2C
     C                   MOVE      APNO34        FAX3C
     C                   MOVE      APCD44        FAX4C
     C                   MOVE      APNO32        NO32SV
     C                   MOVE      APNO33        NO33SV
     C                   MOVE      APNO34        NO34SV
     C                   ELSE
     C                   MOVE      VMO32         FAX1C
     C                   MOVE      VMO33         FAX2C
     C                   MOVE      VMO34         FAX3C
     C                   MOVE      UVMAIL        MMAIL                           ADDRESS
     C                   END
     C                   ELSE
     C                   MOVE      'M'           POCD02                         MAIL TO ADDRESS
     C     ADRSOV        CHAIN     POFTOA                             40
     C     *IN40         IFEQ      '0'
     C                   MOVE      POOVAD        MMAIL
     C                   MOVE      POO32         FAX1C
     C                   MOVE      POO33         FAX2C
     C                   MOVE      POO34         FAX3C
     C                   END
     C                   END
      *
      * SHIPPING ADDRESS
     C     POCD05        IFNE      'Y'                                          NO OVRRIDE
     C     PONO13        CHAIN     ARFMCUS                            40
     C                   MOVE      CUSHIP        SSHIP                          SHIPPING ADDRES
     C                   END
     C     POCD05        IFEQ      'Y'                                          OVRRIDE ADDRESS
     C                   MOVE      'S'           POCD02                         MAIL TO ADDRESS
     C     PONO13        IFNE      0                                            SHIP TO CUSTMR
     C     PONO13        CHAIN     ARFMCUS                            40
     C                   END
     C     ADRSOV        CHAIN     POFTOA                             40
     C     *IN40         IFEQ      '0'
     C                   MOVE      POOVAD        SSHIP                          SHIPPING ADDRES
     C                   END
     C                   END
      *
     C                   Z-ADD     1             X
     C     X             DOUGT     028                                          BLANK OUT
     C     X             OCCUR     RCDS                                         RECEIVING NOTES
     C                   CLEAR                   RCDS                           BLANK/ZERO DS
     C                   ADD       1             X
     C                   END
      *
     C                   Z-ADD     1             X
     C     X             DOUGT     MXNOTE                                       BLANK OUT
     C     X             OCCUR     APDS                                         A/P NOTES
     C                   CLEAR                   APDS                           BLANK/ZERO DS
     C                   ADD       1             X
     C                   END
      *
     C     POCD07        IFEQ      'Y'                                          NOTES ?
     C                   Z-ADD     1             X
     C                   MOVE      '2'           POCD08                         TYPE CODE
     C     NTSKEY        SETLL     POFTNT
     C     *IN40         DOUEQ     '1'
     C     NTSKEY        READE     POFTNT                                 40
     C     *IN40         IFEQ      '0'
     C     X             OCCUR     RCDS                                         RECEIVING NOTES
     C                   MOVE      PODN01        DSNOT1
     C                   ADD       1             X
     C                   END
     C                   END
     C                   END
      *
     C     POCD18        IFEQ      'Y'                                          NOTES ?
     C                   Z-ADD     1             X
     C                   MOVE      '1'           POCD08                         TYPE CODE
     C     NTSKEY        SETLL     POFTNT
     C     *IN40         DOUEQ     '1'
     C     NTSKEY        READE     POFTNT                                 40
     C     *IN40         IFEQ      '0'
     C     X             OCCUR     APDS                                         A/P NOTES
     C                   MOVE      PODN01        DSNOT2
     C                   ADD       1             X
     C                   END
     C                   END
     C                   END
     C                   MOVE      POCD01        SVTYPE
      * SAVE THE ORIGINAL CUSTOMER NUMBER...
     C     POCD01        IFEQ      'D'
     C                   Z-ADD     PONO13        CUSTSV
     C                   ENDIF
     C                   MOVE      POCD01        SVCD01
     C                   MOVE      POCD03        SVCD03
¢7    * Check vendor to see if item vendor needs to match po vendor
¢7   C                   MOVEL     'CM13'        TABCOD
¢7   C                   CLEAR                   TABENT
¢7   C                   MOVEL     APNO01        TABENT
¢7   C     TABKEY        CHAIN     TBFMTBL
¢7   C                   IF        %FOUND
¢7   C                   MOVE      'Y'           ItmVndToMatch     1
¢7   C                   ELSE
¢7   C                   MOVE      'N'           ItmVndToMatch
¢7   C                   ENDIF
¢8    * Check po to see if sent to vendor
¢8    * If po sent to vendor, existing item numbers on po cannot be changed
¢8   C                   MOVEL     PONO01        ALFPO             7
¢8   C     ALFPO         SETLL     EIFADT
¢8   C                   IF        %EQUAL
¢8   C                   MOVE      'Y'           SentToVendor      1
¢8   C                   ELSE
¢8   C                   MOVE      'N'           SentToVendor
¢8   C                   ENDIF
      *
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    WRITE PURCHASE ORDER                                    *
      *------------------------------------------------------------------------*
     C     WRTSR         BEGSR
      * CALL PGM TO DELETE OLD ORDER
     C                   MOVE      'M'           CODE1             1
     C                   MOVE      PONO01        PO#               7
     C     POCD20        IFEQ      'C'
     C                   MOVE      'X'           POSTS
     C                   ENDIF
IJ   C                   IF        POCD42 = 'Y'
IJ   C                   EVAL      PGMFRM = 'M'
IJ   C                   ELSE
IJ   C                   CLEAR                   PGMFRM
IJ   C                   ENDIF
     C                   CALL      'POR0130'
     C                   PARM                    PO#
     C                   PARM                    CODE1
     C                   PARM                    POSTS
     C                   PARM                    VNDNUM
     C                   PARM                    WHRFRM
HV IJC*                  PARM      'M'           PGMFRM            1
IJ   C                   PARM                    PGMFRM            1
     C                   MOVE      VNDNUM        APNO01
     C                   MOVE      ' '           POCD23                         EDIT STATUS COD
     C                   Z-ADD     UMONTH        POMO01                         UPDATE MONTH
     C                   Z-ADD     UDAY          PODY01                         UPDATE DAY
     C                   MOVEL     *YEAR         POCC01                         UPDATE CENTURY
     C                   Z-ADD     UYEAR         POYR01                         UPDATE YEAR
     C                   MOVE      USRNM         PONM01                         USER ID
     C                   Z-ADD     ORDDAT        DATE2                          LINE ITEM DATE
     C                   Z-ADD     POCC02        CC02                           ORDERED CENTURY
     C                   Z-ADD     SHPDAT        DATE4                          LINE ITEM DATE
     C                   Z-ADD     POCC04        CC04                           SHIPPING CENTURY
JL   C                   eval      savfl67 = pofl67
      *
      * METHOD OF SHIPMENT
     C     OURTRK        IFNE      ' '
     C                   MOVE      'O'           POCD10                         OUR TRUCK
I2   C                   MOVE      DEF_OSHPCODE  POCD56
     C                   END
     C     SHIPED        IFNE      ' '
     C                   MOVE      'S'           POCD10                         SHIPPED VIA
I2   C                   MOVE      DEF_SSHPCODE  POCD56
     C                   END
      *
     C     POCD01        IFNE      'D'
     C                   CLEAR                   PONO13
     C                   ENDIF
      *
      * SHIP TO ADDRESS
     C                   CLEAR                   POCD05
     C     PONO02        IFEQ      0                                            SHIP TO BRANCH
     C     PONO13        IFEQ      0                                            SHIP TO CUSTOME
     C                   MOVE      'S'           POCD02                         OVRRIDE ADDRS T
     C                   MOVE      'Y'           POCD05                         OVRRIDE ADDRS C
     C                   MOVE      SSHIP         POOVAD                         OVRRIDE ADDRESS
     C                   CLEAR                   POO22
     C                   CLEAR                   POO23
     C                   CLEAR                   POO24
     C                   CLEAR                   POO32
     C                   CLEAR                   POO33
     C                   CLEAR                   POO34
     C                   WRITE     POFTOA                                       OVRRIDE ADDRESS
     C                   ELSE
     C     CUSHIP        IFNE      SSHIP                                        OVRRIDE ADDRS ?
     C                   MOVE      'S'           POCD02                         OVRRIDE ADDRS T
     C                   MOVE      'Y'           POCD05                         OVRRIDE ADDRS C
     C                   MOVE      SSHIP         POOVAD                         OVRRIDE ADDRESS
     C                   CLEAR                   POO22
     C                   CLEAR                   POO23
     C                   CLEAR                   POO24
     C                   CLEAR                   POO32
     C                   CLEAR                   POO33
     C                   CLEAR                   POO34
     C                   WRITE     POFTOA                                       OVRRIDE ADDRESS
     C                   END
     C                   END
     C                   END
HD    *
HD    * VENDOR REP INFORMATION
HD   C     POCD67        IFEQ      'Y'                                          OVRRIDE ADDR
HD   C                   MOVE      'S'           POCD02                         OVRRIDE ADDRS T
HD   C                   MOVE      'Y'           POCD05                         OVRRIDE ADDRS C
HD   C                   MOVE      SSHIP         POOVAD                         OVRRIDE ADDRESS
HD   C                   CLEAR                   POO22
HD   C                   CLEAR                   POO23
HD   C                   CLEAR                   POO24
HD   C                   CLEAR                   POO32
HD   C                   CLEAR                   POO33
HD   C                   CLEAR                   POO34
HD   C                   WRITE     POFTOA                                       OVRRIDE ADDRESS
HD   C                   ENDIF                                                  OVRRIDE ADDR
      *
      * MAILING ADDRESS
     C                   CLEAR                   POCD06
     C     *IN50         IFEQ      '1'                                          UNAPPROVED VEND
     C                   MOVE      'M'           POCD02                         OVRRIDE ADDRS T
     C                   MOVE      'Y'           POCD06                         OVRRIDE ADDRS C
     C                   MOVE      MMAIL         POOVAD                         OVRRIDE ADDRESS
     C                   WRITE     POFTOA                                       OVRRIDE ADDRESS
     C                   END
      *
     C     *IN50         IFEQ      '0'                                          APPROVED VENDOR
     C     UVMAIL        IFNE      MMAIL                                        OVRRIDE ADDRS ?
     C     AVMAIL        IFNE      MMAIL                                        OVRRIDE ADDRS ?
     C                   MOVE      'M'           POCD02                         OVRRIDE ADDRS T
     C                   MOVE      'Y'           POCD06                         OVRRIDE ADDRS C
     C                   MOVE      MMAIL         POOVAD                         OVRRIDE ADDRESS
   IEC*                  Z-ADD     0             PONO14                         MAIL ADDRS SEQ#
     C                   WRITE     POFTOA                                       OVRRIDE ADDRESS
     C                   ELSE
     C                   Z-ADD     NO28          PONO14                         MAIL ADDRS SEQ#
     C                   END
     C                   END
     C                   END
      *
      * UNAPPROVED VENDOR ?
     C     *IN50         IFEQ      '1'
     C                   Z-ADD     UMONTH        APMO01                         UPDATE MONTH
     C                   Z-ADD     UDAY          APDY01                         UPDATE DAY
     C                   MOVEL     *YEAR         APCC01                         UPDATE CENTURY
     C                   Z-ADD     UYEAR         APYR01                         UPDATE YEAR
     C                   MOVE      USRNM         APNM04                         USER ID
     C                   MOVE      'Y'           APCD28
     C                   WRITE     APFMVEN                                      VENDOR MASTER
     C                   END
      *
      * NOTES TO RECEIVING ?
     C                   MOVE      'N'           POCD07                         NOTES EXIST ?
     C                   Z-ADD     1             X
     C                   Z-ADD     0             PONO06                         LINE NUMBER
     C     X             DOUGT     028
     C     X             OCCUR     RCDS                                         RECEIVING NOTES
     C     DSNOT1        IFNE      *BLANKS                                      NOTES
     C                   ADD       1             PONO06                         LINE NUMBER
     C                   MOVE      '2'           POCD08                         NOTES TYPE CODE
     C                   MOVE      'Y'           POCD07                         NOTES EXIST ?
     C                   MOVE      DSNOT1        PODN01                         DATA STRUCTURE
     C                   WRITE     POFTNT                                       NOTES FILE
     C                   END
     C                   ADD       1             X
     C                   END
      *
      * NOTES TO ACCOUNTS PAYABLE ?
     C                   MOVE      'N'           POCD18                         NOTES EXIST ?
     C                   Z-ADD     1             X
     C                   Z-ADD     0             PONO06                         LINE NUMBER
     C     X             DOUGT     MXNOTE
     C     X             OCCUR     APDS                                         A/P NOTES
     C     DSNOT2        IFNE      *BLANKS                                      NOTES
     C                   ADD       1             PONO06                         LINE NUMBER
     C                   MOVE      '1'           POCD08                         NOTES TYPE CODE
     C                   MOVE      'Y'           POCD18                         NOTES EXIST ?
     C                   MOVE      DSNOT2        PODN01                         DATA STRUCTURE
     C                   WRITE     POFTNT                                       NOTES FILE
     C                   END
     C                   ADD       1             X
     C                   END
      *
      * WRITE LINE ITEMS
      * REVISION DATE AND TIME
     C                   MOVE      'N'           CHGFLG
IV   C                   MOVE      'N'           ediFLG
     C                   MOVE      ' '           POCD14                         ITEM TAG CODE
     C                   MOVEL     UDAY          PODY12                         REVISION DAY
     C                   MOVEL     UMONTH        POMO12                         REVISION MONTH
     C                   MOVEL     *YEAR         POCC12                         REVISION CENTURY
     C                   MOVEL     UYEAR         POYR12                         REVISION YEAR
     C                   TIME                    POTM04                         REVISION TIME
     C                   Z-ADD     1             X
JJ JPC*                  Z-ADD     0             NXTLN#            3 0
     C     X             DOUGT     ITMSIZ
     C     X             OCCUR     SAVDS
     C     DITM          IFEQ      *BLANKS                                      ITEM NUMBER
     C     DDES          CABEQ     *BLANKS       ENDWRT                         DESCRIPTION
     C                   END
     C                   MOVE      ' '           POCD19                         ITEM ENTERED
JJ JPC*                  Add       1             NXTLN#                         INCREASE BY 1
     C     DTYP          IFEQ      'C'                                          COMMENTS
     C                   MOVE      'C'           POCD13                         TYPE CODE
     C                   Z-ADD     0             DQTY                           QTY ORDERED
     C                   Z-ADD     0             DLST                           LIST
     C                   Z-ADD     0             DCST                           COST
     C                   CLEAR                   UQYDF
     C                   CLEAR                   PUAMDF
     C                   CLEAR                   PUAMDL
     C                   MOVE      *BLANK        DDSC                           DISCOUNT
     C                   MOVE      *BLANK        DDOV                           DISC OVRRIDE
     C                   MOVE      *BLANK        DCOV                           COST OVRRIDE
     C                   MOVE      *BLANK        DUMP                           PRICING UOM
     C                   ELSE
     C     DTYP          IFNE      'N'                                          NONSTOCK ITEM
     C                   MOVE      DTYP          POCD19                         ITEM ENTERED
     C                   MOVE      'S'           POCD13                         ITEM TYPE CODE
     C                   ELSE
     C                   MOVE      'N'           POCD13                         ITEM TYPE CODE
     C                   END
     C                   END
JP JS * Only 1 LOT can be on a PO, and the LOTTED Items may not be maintained.
JP JS * LOTTED item records are not in POPTOL,therefor the data structure value for
JP JS * the line sequence# for LOTTED items is zero.
I0    * Save original PO line#
I0   C     DSORGL        IFNE      0
I0   C     INSCOM        IFEQ      'Y'
I0    * Since lines were inserted the DSORLN becomes what 'X' is equal to.
I0   C                   Z-ADD     X             DSORLN                         INSERTED LINE#
JR JSC*                  Z-add     X             NxtLn#
I0   C                   ELSE
I0    * No lines were inserted
JP JS * Check if LOT items
JP JSC*                  If        pocd42 = 'Y'                                 lot item flag
JP JSC*                  ADD       1             NxtLn#                         INCREASE BY 1
JP JSC*                  Else
JP JRC*                  Z-ADD     DSORGL        DSORLN
I0 JJC*                  Z-ADD     DSORGL        DSORLN
JJ JPC*                  Z-ADD     NXTLN#        DSORLN                         USE NXT LIN#
JR JSC*                  Z-ADD     NXTLN#        DSORLN                         USE NXT LIN#
JP JSC*                  ADD       1             NxtLn#                         INCREASE BY 1
JP JSC*                  EndIf
JS   C                   Z-ADD     DSORGL        DSORLN
I0   C                   END
I0   C                   ELSE
I0   C     INSCOM        IFEQ      'Y'
I0   C                   Z-ADD     X             DSORLN                         INSERTED LINE#
I0 JJC*                  ADD       1             NXTLN#                         INCREASE BY 1
JP JSC*                  ADD       1             NXTLN#                         INCREASE BY 1
JS   C                   ADD       1             NXTLN#                         INCREASE BY 1
I0   C                   ELSE
JP JSC*                  Z-ADD     X             NXTLN#
JP JRC*                  ADD       1             NXTLN#                         INCREASE BY 1
I0   C                   Z-ADD     NXTLN#        DSORLN                         USE NXT LIN#
I0 JJC*                  ADD       1             NXTLN#                         INCREASE BY 1
JR JSC*                  ADD       1             NXTLN#                         INCREASE BY 1
JS   C                   ADD       1             NXTLN#                         INCREASE BY 1
I0   C                   END
I0   C                   END
   I0C*    DSORLN        IFEQ      0
   I0C*                  Z-ADD     NXTLN#        DSORLN                         USE NXT LIN#
   I0C*                  ADD       1             NXTLN#                         INCREASE BY 1
   I0C*                  END
     C                   Z-ADD     DQYR          POQY03                         QTY RECEIVIED
     C                   Z-ADD     DQYRO         POQYU3                         QTY RCVD ORD UM
     C                   Z-ADD     DNO7          IVNO07                         OUR ITEM NUMBER
   IZC*                  MOVE      DMAN          IVNO22                         MANUFACTURER #
IZ   C                   MOVE      DMAN          IVNO93                         MANUFACTURER #
#4   C                   MOVE      DVENQ         IVNO22
     C                   MOVE      DUOM          PODN03                         ORDERED UOM
     C                   Z-ADD     DSORLN        PONO05                         LINE ITEM NUMBE
     C                   Z-ADD     DSORLN        PONO08                         LINE SEQ NUMBER
     C                   Z-ADD     UQYDF         POQY01                         STOCKING QTY
     C                   Z-ADD     DQTY          POQYU1                         QTY ORDERED
     C                   Z-ADD     UOMDF         POQYOF                         ORD UOM FCTR
     C                   Z-ADD     PUOMDF        POQYPF                         PRC UOM FCTR
     C                   Z-ADD     DLST          POAMU1                         LIST
     C                   Z-ADD     DCST          POAMU2                         COST
     C                   Z-ADD     PUAMDL        POAM01                         LIST
     C                   Z-ADD     PUAMDF        POAM02                         COST
     C                   MOVE      DDSC          POPC02                         DISCOUNT
     C                   MOVE      DDOV          POCD16                         DISC OVRRIDE
     C                   MOVE      DCOV          POCD17                         COST OVRRIDE
     C                   MOVE      DUMP          PODN04                         PRICING UOM
     C                   MOVE      *BLANKS       PODN10
     C                   MOVEL     DITM          PODN10
JL   C                   MOVE      dfl67         pofl67
JL   C                   if        savfl67 = 'N'
JL   C                   eval      pofl67 = 'N'
JL   C                   endif
      * LOAD ORIGINAL & REVISED ETA LINE ITEM DATES...
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETADO         PDATE6                         ORIG LINE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDATE8        ETAOL                          ORIG LINE
     C                   Z-ADD     4             PDATYP                         DATE TYPE
     C                   MOVE      ETADR         PDATE6                         RVSD LINE
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   MOVE      PDATE8        ETARL                          RVSD LINE
     C     DKEY          IFNE      0                                            TAG & HOLD KEY
     C                   EXSR      WRTTG
     C                   END
      *
      *  TEST FOR NEW ITEM
   I0C*    DSORLN        OCCUR     SAVDSR                                       ADDED ITEM
I0   C     DSORGL        IFNE      *ZERO
I0   C     DSORGL        OCCUR     SAVDSR                                       ADDED ITEM
     C     RITM          IFEQ      *BLANKS                                      ADDED ITEM
     C                   MOVEL     'AI'          RSCD29                         ADDED ITEM
     C                   ELSE
      *  TEST FOR REVISED PURCHASE ORDER LINE ITEMS
     C     DITM          IFNE      RITM                                         CHANGED ITEM
     C                   MOVEL     'RI'          RSCD29                         REVISION CODE
     C                   ELSE
      *  TEST FOR QTY CHANGE GREATER THAN
     C     DQTY          IFGT      RQTY                                         CHANGED QTY
     C                   MOVEL     'QI'          RSCD29                         REVISION CODE
     C                   ENDIF
      *  TEST FOR QTY CHANGE LESS THAN
     C     DQTY          IFLT      RQTY                                         QTY DECREASE
     C                   MOVEL     'QD'          RSCD29                         REVISION CODE
     C                   ENDIF
      *  TEST FOR PRICE CHANGE GREATER THAN
     C     DCST          IFGT      RCST                                         PRC INCREASE
     C     RSCD29        IFEQ      'QD'
     C     RSCD29        OREQ      'QI'
     C                   MOVE      'PQ'          RSCD29
     C                   ELSE
     C                   MOVEL     'PI'          RSCD29                         REVISION CODE
     C                   ENDIF
     C                   ELSE
      *  TEST FOR PRICE CHANGE LESS THAN
     C     DCST          IFLT      RCST                                         PRC DECREASE
     C     RSCD29        IFEQ      'QD'
     C     RSCD29        OREQ      'QI'
     C                   MOVE      'PQ'          RSCD29
     C                   ELSE
     C                   MOVEL     'PD'          RSCD29                         REVISION CODE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *  TEST FOR ORDERING UOM CHANGE...
     C     DUOM          IFNE      RUOMX                                        ORD UOM CHG
     C                   MOVEL     'OU'          RSCD29                         REVISION CODE
     C                   ELSE
      *  TEST FOR PRICING UOM CHANGE...
     C     DUMP          IFNE      RUMP                                         PRC UOM CHG
     C                   MOVEL     'PU'          RSCD29                         REVISION CODE
     C                   ELSE
      *  ITEMS NOT CHANGED
     C     RSCD29        IFEQ      *BLANKS
     C                   MOVEL     'NC'          RSCD29                         REVISION CODE
     C                   ENDIF
     C                   ENDIF
     C                   END
     C                   ENDIF
     C                   END
I0   C                   ELSE                                                   DSORGL=0
I0    * A NEW LINE WAS ADDED EITHER COMMENT OR ITEM.
I0   C     X             IFLE      SVNXTLN#
I0   C                   MOVEL     'AI'          RSCD29                         ADDED ITEM
I0   C                   ENDIF
I0   C                   ENDIF
      *
JP    * NO revisions for Lot items allowed
JP   C                   If        pocd42 = 'Y'                                 lot item flag
JP   C                   eval      RSCD29 = 'NC'
JP   C                   EndIf
      *  TEST FOR REVISION
     C     RSCD29        IFNE      'NC'                                         CHGD ITEM
I0   C     RSCD29        ANDNE     *BLANK
      *  WRITE TO TRANSACTION FILE
     C                   MOVE      'Y'           CHGFLG            1
IV   C                   if        ediflg = 'N'
IV   C                   if        (rscd29 = 'AI' or
IV   C                              rscd29 = 'RI') and
IV   C                              dtyp = 'C'
IV   C                   eval      ediflg = 'N'
IV   C                   else
IV   C                   eval      ediflg = 'Y'
IV   C                   endif
IV   C                   endif
IV    *
     C                   Z-ADD     REVNO         PONO18                         REVISION NUMBER
     C                   MOVE      RSCD29        POCD29                         REVISION CODE
     C                   WRITE     POFTRVL
     C                   END
      *
     C     POCD01        IFEQ      'D'                                          DIRECT ORDER
     C                   EXSR      WRTCOS                                       WRT COST O/E
      *
      *  UPDATE DIRECT RECEIVER FOR STOCK ITEM AND NON-STOCK ITEM BOTH.
      *  IT IS UPDATED ONLY IF A/P INVOICE IS NOT APPROVED YET.
      *  IT WILL ALSO UPDATE A/P INVOICE FLAG(S).
     C     DTYP          IFNE      'C'                                          NOT COMMENT
     C     DTYP          ANDNE     'D'                                          LOT DETAIL ITEM
     C                   Z-ADD     PONO01        ARCVPO                         P/O NUMBER  BER
     C                   Z-ADD     PONO05        ARCVLF                         P/O LIN REF BER
     C                   Z-ADD     POAM02        ARCVCS                         ITM CST @STKBER
     C                   Z-ADD     POAMU2        ARCVCP                         ITM CST @PRCBER
     C                   MOVE      *BLANKS       ARCVRC                         RETURN CODE
     C                   CALL      'POR0119'     PL0119                         WRT COST O/E
     C                   ENDIF
     C                   END
      *
      *  TEST FOR NON-STOCK NUMBER
     C     DTYP          IFEQ      'N'
      *  SETUP TO READ SALES ORDER LINE ITEMS BY NON-STOCK ID #
     C                   MOVEL     DITM          ZZNO04
      *
     C     POCD42        IFEQ      'Y'                                          LOT PURCHASE
     C     OPNOAL        IFEQ      ' '
     C                   OPEN      OELTOALA
     C                   MOVE      'Y'           OPNOAL
     C                   ENDIF
     C     ZZNO04        SETLL     OETOALA
     C                   ELSE                                                   USE S/O FILES
     C     ZZNO04        SETLL     OELTOL14
     C                   ENDIF
      *
     C     *IN40         DOUEQ     '1'
     C                   MOVEA     '00'          *IN(48)
     C                   MOVE      '0'           *IN61
      *  GET ORDER LINE ITEM BY NON-STOCK ID #
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     POCD42        IFEQ      'Y'                                          LOT PURCHASE
     C     ZZNO04        READE     OETOALA                              9240
     C                   ELSE                                                   USE S/O FILES
     C     ZZNO04        READE     OELTOL14                             9240
     C                   ENDIF
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN40         IFEQ      '0'
      *
      * DELETE LOT DETAIL
      *
     C     OECD04        IFNE      'N'
     C     OECD47        ANDNE     'C'
     C     OECD47        ANDNE     'V'
     C     OECD72        IFEQ      'Y'
     C     KEYLOT        SETLL     OEFTOAD                                45
     C     *IN45         IFEQ      *ON
     C     *IN43         DOUEQ     *ON
     C     MYTOAD        TAG
     C     KEYLOT        READE     OEFTOAD                              2643
     C     *IN43         IFEQ      *OFF
     C     *IN26         ANDEQ     *OFF
     C                   DELETE    OEFTOAD
      * DELETE NONSTOCK DESCRIPTION...
     C     OECD85        IFEQ      'N'                                          NONSTOCK
     C                   MOVE      '4'           ACCESS
     C                   MOVEL     OEDN12        NSKEY
     C                   CALL      'OER2062'     PL2062
     C                   ENDIF
      *
     C                   ELSE
     C     *IN26         IFEQ      *ON
     C                   EXSR      UNLOCK
     C     DSPF2         CABNE     *BLANK        MYTOAD
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      * SAVE KEY FOR WRITING NEW LOT DETAIL
   HIC*                  Z-ADD     ONO01         LTORD#
HI   C                   MOVE      ONO01         LTORD#
     C                   Z-ADD     OENO31        LTCTL#
     C                   CLEAR                   OENO61
     C                   ENDIF
     C                   ENDIF
      *
      *  TEST FOR NON-STOCK IDENTIFIER NUMBER FROM PO LINE ITEM
     C     PODN10        IFEQ      INO04
     C     OENO16        IFEQ      PONO02
     C     OECD16        OREQ      'D'
     C     PONO02        ANDEQ     0
     C     OECD08        IFNE      'C'                                          CREDIT MEMO
     C     OECD08        ANDNE     'D'                                          DEBIT MEMO
     C     OECD47        IFNE      'C'
     C     OECD47        ANDNE     'V'
     C     OEQY02        IFGT      0
     C                   MOVE      'P'           OECD47
     C                   END
     C                   Z-ADD     PONO01        PNO01
I0    * Use DSORLN for the ONO15 because PONO05 comes from the read
I0    * of OETOALA just before this move and it is the old line number,
I0    * And we want to update with the new line number. If there were
I0    * no lines added DSORLN and PONO05 will be the same.
I0   C                   Z-ADD     DSORLN        ONO15
   I0C*                  Z-ADD     PONO05        ONO15
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *  TEST FOR COST OVERRIDE IN SALES ORDER LINE ITEM
      *
     C     POCD42        IFEQ      'Y'                                          LOT PURCHASE
     C     POAM02        IFNE      OEAM02                                       COST CHANGE
     C                   Z-ADD(H)  POAM02        OEAM02                         COST
     C     POQY01        MULT(H)   POAM02        OEAM17                         EXT. COST
     C                   Z-ADD     POAM02        OEAM40                         COST
     C                   Z-ADD     POAM02        OEAM41                         COST
     C                   MOVE      'V'           OECD27
     C                   ENDIF
     C                   ELSE                                                   USE S/O FILES
     C     OECD27        IFNE      'O'
     C     PONO24        ANDEQ     0
KF   C     OECD16        OREQ      'D'
KF   C     OECD27        ANDEQ     'O'
KF   C     ONO43         ANDNE     *ZEROS
KF   C     @DIRPONS      ANDEQ     'Y'
     C                   Z-ADD(H)  POAM02        OEAM02                         COST
     C                   Z-ADD     POAM02        OEAM40                         COST
     C                   Z-ADD     POAM02        OEAM41                         COST
KF   C     OECD16        IFEQ      'D'
KF   C     OECD27        ANDEQ     'O'
KF   C     ONO43         ANDNE     *ZEROS
KF   C     @DIRPONS      ANDEQ     'Y'
KF   C                   ELSE
     C                   MOVE      'V'           OECD27
KF   C                   ENDIF
     C                   END
     C                   ENDIF
      *  TEST FORMAT - IND. 48= DAILY LINE ITEM FILE
      *
     C     POCD42        IFNE      'Y'                                          LOT PURCHASE
     C     *IN48         IFEQ      '1'
     C                   EXCEPT    TOL14
     C                   ELSE
     C     OEQY03        IFEQ      0
     C                   MOVE      '1'           *IN61
     C                   END
     C                   EXCEPT    TOY14
     C                   END
     C                   ELSE                                                   USE S/O FILES
     C                   EXCEPT    TOALA
     C                   ENDIF
      *
     C     OECD47        IFNE      'C'
     C     OECD47        ANDNE     'V'
     C     OENO16        IFEQ      PONO02
     C     OECD16        OREQ      'D'
     C     PONO02        ANDEQ     0
     C                   Z-ADD     1             TAGCNT
     C     DKEY          IFEQ      *ZEROS
     C                   MOVE      '1'           POCD15
     C                   MOVE      *BLANKS       PODN06
     C                   Z-ADD     0             PONO09                         NO BRANCH
     C                   Z-ADD     ANO01         PONO10                         CUSTOMER
   HIC*                  Z-ADD     ONO01         PONO11                         REFERENCE
HI   C                   MOVE      ONO01         PONO11                         REFERENCE
     C                   Z-ADD     TAGCNT        PONO12                         LINE SEQ NUMBER
      * IF B/O QTY EXISTS, USE IT... OTHERWISE, USE QTY ORDERED...
     C     OEQY02        IFGT      0
     C                   Z-ADD     OEQY02        POQY02                         QTY TAGGED
     C                   ELSE
     C                   Z-ADD     OEQY01        POQY02                         QTY TAGGED
     C                   ENDIF
   HHC*                  Z-ADD     OENO26        IVNO55
   HHC*                  Z-ADD     OENO22        IVNO92
HH   C                   MOVE      OENO26        TGNO01
HH   C                   Z-ADD     OENO22        TGNO22
HH   C                   Z-ADD     *ZEROS        IVNO55
HH   C                   Z-ADD     *ZEROS        IVNO92
     C                   WRITE     POFTTG
     C                   ADD       1             TAGCNT
     C                   MOVE      'Y'           POCD14
     C                   ENDIF
      *
     C                   END
     C                   ENDIF
     C                   ENDIF
     C                   END
     C                   END
      *
      * TAG TO TRANSFERS
      *
     C                   MOVEL     ZZNO04        NSKEY
     C     NSKEY         SETLL     IVLTTLK
     C                   MOVE      ' '           DSPF1
     C                   MOVE      *IN92         SVIN92
     C     *IN40         DOUEQ     *ON
     C     *IN92         DOUEQ     *OFF
     C     NSKEY         READE     IVFTTLK                              9240
     C     *IN92         CASEQ     *ON           UNLOCK
     C                   ENDCS
     C                   ENDDO
     C     *IN40         IFEQ      *OFF
     C     IVNO52        IFEQ      PONO02
     C     IVCD70        ANDNE     'V'
     C     IVCD72        ANDNE     'C'
     C     IVCD72        ANDNE     'V'
     C     IVQYX2        IFGT      0
     C                   MOVE      'P'           IVCD72
     C                   END
     C                   Z-ADD     PONO01        PNO01
     C                   ENDIF
      * UPDATE TRANSFER COST
      * UPDATE IF TRANSFER STATUS IS NOT VOIDED OR CLOSED
     C     IVCD70        IFNE      'V'
     C     IVCD70        ANDNE     'C'
      * SET UP 2 DECIMAL COST FIELD FOR COST COMPARISON
      * IVAMZ2 = 9/2  IVAM31 = 9/4
     C                   Z-ADD(H)  IVAM31        SVAM31
      * IF NONSTOCK HAS NO COST ON THE TRANSFER
      * OR NONSTOCK HAS COST ON TRANSFER AND IT HAS NOT BEEN OVERRIDDEN
      *    BY A USER
      * UPDATE NONSTOCK COST/LINE ITEM COST ON TRANSFER WITH P/O COST
     C     IVAMZ2        IFEQ      *ZEROS
     C     SVAM31        OREQ      IVAMZ2
     C                   Z-ADD(H)  POAM02        IVAMZ2
     C                   Z-ADD     POAM02        IVAM31
     C                   ENDIF
      * UPDATE WAC WITH P/O COST
     C                   Z-ADD     POAM02        IVAMAF
HS    * UPDATE WAF WITH P/O FREIGHT
HS   C                   Z-ADD     POAM96        IVAMTF
     C                   ENDIF
     C                   EXCEPT    UPDTTL
     C     IVNO52        IFEQ      PONO02
     C     IVCD70        ANDNE     'V'
     C     IVCD72        ANDNE     'C'
     C     IVCD72        ANDNE     'V'
     C                   Z-ADD     1             TAGCNT
     C     DKEY          IFEQ      *ZEROS
     C                   MOVE      '2'           POCD15
     C                   MOVE      *BLANKS       PODN06
     C                   Z-ADD     0             PONO09                         NO BRANCH
     C                   Z-ADD     *ZEROS        PONO10                         CUSTOMER
   HIC*                  Z-ADD     IVNO26        PONO11                         REFERENCE
HI   C                   MOVE      IVNO26        PONO11                         REFERENCE
     C                   Z-ADD     TAGCNT        PONO12                         LINE SEQ NUMBER
     C                   Z-ADD     IVQYX2        POQY02                         QTY TAGGED
HH   C                   MOVE      *ZEROS        TGNO01
HH   C                   Z-ADD     *ZEROS        TGNO22
     C                   WRITE     POFTTG
     C                   ADD       1             TAGCNT
     C                   MOVE      'Y'           POCD14
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
   HE * SEE IF ON WORK ORDER
HE    * SEE IF ON WORK ORDER MOVE REQUEST
      *
     C                   EXSR      WONS
      *
     C                   END
     C     DTYP          IFEQ      'D'                                          LOT DETAIL ITEM
     C                   EXSR      WRTLOT                                       WRITE LOT DETAIL
     C                   ELSE                                                   OTHERWISE
HS    *  Required Parms
HS    *   Out going Parms     Extended cost
HS    *                       Total P/O cost
HS    *                       Total freight cost
HS    *                       No of Items
HS    *   Income coming Parm  Line item freight value
HS    *                       Total line freight value
HS
HZ   C     DNO7          setll     MSTRIN
HZ   C                   If        %equal
IW   C                             or DNO7 = *ZEROS
HS   C                   If        x <=  MaxDs
HS   C                   MoveL     dExtCost      LExtCost         15 5
HS IIC*                  Move      UQydf         LQty              5 0
II   C                   Move      UQydf         LQty              7 0
JU   C                   Eval      TotFCost = PoAm03
HS   C                   CALL      'POR0022'
HS   C                   Parm                    LExtCost                       Extended Cost
HS HZC*                  Parm                    PoTl01                         Total P/O Cost
HZ   C                   Parm                    InventoryTotal                 Total P/O Cost
HS JUC*                  Parm                    PoAm03                         Total Freight Cost
JU   C                   Parm                    TotFCost                       Total Freight Cost
HS   C                   Parm                    LQty                           No of Items
HS   C                   Parm                    PoAm96                         Line Item Freight Va
HS   C                   Else
HS   C                   Eval      PoAm96    =  *zeros
HS   C                   EndIf
HZ   C                   Else
HZ   C                   Eval      PoAm96    =  *zeros
HZ   C                   EndIf
JS    * Capture highest line item number for storing as Header Next Available
#4   C                   MOVE      DVENQ         IVNO22
     C                   WRITE     POFTOL
KM   C                   IF        IVNO07 <> *ZEROS
KM   C                   EVAL      ZAPNO01 = APNO01
KM   C                   EVAL      ZPONO01 = PONO01
KM   C                   EVAL      ZPONO05 = PONO05
KM   C                   EVAL      ZPRNO01 = DPSNME
KM   C                   EVAL      ZPRNO02 = DPSCTNM
KM   C                   EVAL      ZPRCD21 = DPSSTS
KM   C                   EVAL      ZPRCD77 = DPSTYPE
KM   C                   MOVE      USRNM         PONM01
KM   C                   WRITE     POFTOLA
KM   C                   ENDIF
JL   C                   If        dhdfl67 <> pofl67
JL   C     trdkey        setll     poftrd
JL   C     trdkey        reade     poftrd
JL   C                   dow       not %eof
JL   C                   eval      r_pofl67 = pofl67
JL   C                   update    poftrd
JL   C     trdkey        reade     poftrd
JL   C                   Enddo
JL   C                   Endif
     C                   ENDIF
      *
      *
     C     PONO02        IFNE      0                                            SHIP TO BRANCH
     C     POCD01        IFNE      'F'                                          BLANKET ORDER
     C     POCD01        IFNE      'D'                                          DIRECT ORDER
     C     POCD01        IFNE      'O'                                          OVERHEAD
     C     POQY01        SUB       POQY03        QTYRMN            7 0
     C     QTYRMN        IFLT      0
     C                   Z-ADD     0             QTYRMN
     C                   END
     C     POCD13        CASEQ     'S'           UPDINV                         STOCKED ITEM
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     DTYP          IFEQ      'N'                                          NONSTOCK ITEM
     C                   CLEAR                   INO04
     C                   MOVEL     PODN10        INO04
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     INO04         CHAIN     IVFTNSK                            4092
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVEL     DDES          IDN01
     C                   Z-ADD     UMONTH        IMO01                          LAST UPDATE MO
     C                   Z-ADD     UDAY          IDY01                          LAST UPDATE DY
     C                   MOVEL     *YEAR         ICC01                          LAST UPDATE DY
     C                   Z-ADD     UYEAR         IYR01                          LAST UPDATE YR
     C                   MOVE      USRNM         INM01                          USER ID NAME
     C     *IN40         IFEQ      *OFF
     C                   UPDATE    IVFTNSK
     C                   ELSE
     C                   WRITE     IVFTNSK
     C                   ENDIF
     C                   END
     C     DTYP          IFEQ      'C'                                          COMMENTS
     C                   MOVEL     DDES          PODN08                         DESCRIPTION
     C                   WRITE     POFTOT
     C                   END
     C                   ADD       1             X
     C                   MOVE      ' '           POCD14                         ITEM TAG CODE
     C                   END
      *
     C     ENDWRT        TAG
JJ JPC*                  ADD       1             NXTLN#                         NXT AVAIL LN
JR JSC*                  If        INSCOM = 'Y'
JR JSC*                  Add       1             NXTLN#                         NXT AVAIL LN
JR JSC*                  EndIf
     C                   Z-ADD     NXTLN#        PONO16                         NXT AVAIL LN
     C                   MOVE      SVCD12        POCD12                         RESTORE POCD12
     C     ETAOH         IFEQ      *ZEROS
     C     POCC03        ANDNE     *ZEROS
     C                   CLEAR                   POCC03
     C                   ENDIF
     C     ETARH         IFEQ      *ZEROS
     C     POCC14        ANDNE     *ZEROS
     C                   CLEAR                   POCC14
     C                   ENDIF
I2   C                   MOVE      RNSTS         POCD57
JL   C                   eval      pofl67 = savfl67
JZ    * Send Event data for PO Total Amount...
JZ    *  If not a Direct and PO Total exists...
JZ   C                   if        pono02 > 0 and POTL02 > SavedTotal
JZ   C     pono02        chain     ARLMBCH4
JZ   C                   if        %found(ARLMBCH4)
JZ   C                   eval      totE39 = potl02
JZ    * Determine origin...
JZ   C                   eval      orgE39 = 'M'                                 PO Maint = Origin
JZ   C                   if        XXXWHR = '%' or XXXWHR = '$'
JZ   C                   eval      orgE39 = 'R'                                 ROR Maint = Origin
JZ   C                   endif
JZ   C                   eval      byrE39 = poid01
JZ   C                   eval      vndE39 = apno01
JZ   C                   eval      po#E39 = pono01
JZ   C                   eval      cmpE39 = arno15
JZ   C                   eval      divE39 = glcd41
JZ   C                   eval      regE39 = glcd42
JZ   C                   eval      brnE39 = pono02
JZ   C                   Call      'SHC5050'
JZ   C                   Parm      'HDE0039'     EventID           7            Event Id
JZ   C                   Parm                    d_HDE0039                      Event Data
JZ   C                   endif
JZ   C                   endif
JZ    *
     C                   UPDATE    POFTOH
KB    * RETRIEVE QUOTE/PROMO #
KB   C                   MOVE      POCDA4        SVCDA4
KB   C                   MOVE      *BLANKS       POCDA4
KB   C     PONO01        CHAIN     POLTOHA1
KB   C                   MOVE      SVCDA4        POCDA4
KB   C                   if        %found(POLTOHA1)
KB   C     POCDA4        IFEQ      *BLANKS
KB   C                   DELETE    POFTOHA
KB   C                   ELSE
KB   C                   UPDATE    POFTOHA
KB   C                   ENDIF
KB   C                   else
KB   C     POCDA4        IFNE      *BLANKS
KB   C                   WRITE     POFTOHA
KB   C                   ENDIF
KB   C                   endif
      *
      * PROCESS ORIGINAL DATA IN LINE ITEM DATA STRUCTURE
     C                   Z-ADD     1             X
     C     X             DOUGT     ITMSIZ
     C     X             OCCUR     SAVDSR
     C     RSCD29        IFNE      'NC'
     C     RITM          ANDNE     *BLANKS
     C     RSCD29        IFEQ      '  '
     C                   MOVE      'DI'          POCD29                         REVISION CODE
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     PONO01        CHAIN     POFTOH                             4092
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C                   Z-ADD     REVNO         PONO18                         REVISION NUMBER
     C     *IN40         IFEQ      '0'
     C                   EXCEPT    UPDREV
     C                   END
     C                   ELSE
     C                   MOVE      '  '          POCD29                         ORIGINAL CODE
     C                   END
     C                   Z-ADD     RQYR          POQY03                         QTY RECEIVED
     C                   Z-ADD     RQYRO         POQYU3                         QTY RECEIVED
     C                   Z-ADD     RNO7          IVNO07                         OUR ITEM NUMBER
   IZC*                  MOVE      RMAN          IVNO22                         MANUFACTURER #
IZ   C                   MOVE      RMAN          IVNO93                         MANUFACTURER #
#4   C                   MOVE      RVENQ         IVNO22
     C                   MOVE      RUOMX         PODN03                         ORDERED UOM
     C                   Z-ADD     RSORLN        PONO05                         LINE ITEM NUMBER
     C                   Z-ADD     RSORLN        PONO08                         LINE SEQ NUMBER
     C                   Z-ADD     RQY01         POQY01
     C                   Z-ADD     RQTY          POQYU1
     C                   Z-ADD     RQYOF         POQYOF
     C                   Z-ADD     RQYPF         POQYPF
     C                   Z-ADD     RLST          POAMU1
     C                   Z-ADD     RCST          POAMU2
     C                   Z-ADD     RAM01         POAM01
     C                   Z-ADD     RAM02         POAM02
     C                   MOVE      RDSC          POPC02                         DISCOUNT
     C                   MOVE      RDOV          POCD16                         DISC OVRRIDE
     C                   MOVE      RCOV          POCD17                         COST OVRRIDE
     C                   MOVE      RUMP          PODN04                         PRICING UOM
     C                   MOVE      *BLANKS       PODN10
     C                   MOVEL     RITM          PODN10
     C                   MOVE      RSCD13        POCD13
     C                   MOVE      RSCD19        POCD19
     C                   WRITE     POFTRVL
     C                   END
     C                   ADD       1             X
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
   HE *  SUBROUTINE    TAG & HOLD WO NON-STOCKS                                *
HE    *  SUBROUTINE    TAG & HOLD NON-STOCKS ON W/O MOVE REQUESTS              *
      *------------------------------------------------------------------------*
     C     WONS          BEGSR
   HEC*    ZZNO04        SETLL     WOTOL3
   HEC*    *IN40         CABEQ     *OFF          ENDWON
   HEC*    *IN40         DOUEQ     *ON
   HEC*                  MOVE      *BLANKS       DSPF1
   HEC*                  MOVE      *IN92         SVIN92
   HEC*    *IN92         DOUEQ     *OFF
   HEC*    ZZNO04        READE     WOTOL3                               9240
   HEC*    *IN92         CASEQ     *ON           UNLOCK
   HEC*                  ENDCS
   HEC*                  ENDDO
   HEC*                  MOVE      SVIN92        *IN92
   HEC*    *IN40         IFEQ      *OFF
   HEC*    WOCD01        ANDNE     'C'
   HEC*    WOCD01        ANDNE     'V'
   HEC*    PNO01         IFEQ      *ZEROS
   HEC*    PNO01         OREQ      PONO01
   HEC*    WOQY02        IFGT      *ZEROS
   HEC*                  MOVE      'P'           OECD47
   HEC*                  ENDIF
   HEC*                  MOVE      'P'           OECD47
   HEC*                  MOVE      *ON           *IN40
   HEC*                  Z-ADD     PONO01        PNO01
   HEC*                  Z-ADD     0             ONO15
   HEC*                  EXCEPT    UPDWO3
   HEC*    DKEY          IFEQ      *ZEROS
   HEC*                  MOVE      '4'           POCD15
   HEC*                  MOVE      *BLANKS       PODN06
   HEC*                  Z-ADD     0             PONO09                         NO BRANCH
   HEC*                  Z-ADD     *ZEROS        PONO10                         CUSTOMER
   HIC*                  Z-ADD     ONO01         PONO11                         REFERENCE
HI HEC*                  MOVE      ONO01         PONO11                         REFERENCE
   HEC*                  Z-ADD     TAGCNT        PONO12                         LINE SEQ NUMBER
   HEC*                  Z-ADD     WOQY02        POQY02                         QTY TAGGED
HH HEC*                  MOVE      *ZEROS        TGNO01
HH HEC*                  Z-ADD     *ZEROS        TGNO22
   HEC*                  WRITE     POFTTG
   HEC*                  ADD       1             TAGCNT
   HEC*                  MOVE      'Y'           POCD14
   HEC*                  ENDIF
   HEC*                  ENDIF
   HEC*                  ENDIF
   HEC*                  ENDDO
HE   C     WOKEY         SETLL     WKFTMOV
HE   C     *IN40         DOUEQ     *ON
HE   C     *IN92         DOUEQ     *OFF
HE   C     WOKEY         READE     WKFTMOV                                40
HE   C     *IN92         CASEQ     *ON           UNLOCK
HE   C                   ENDCS
HE   C                   ENDDO
HE   C     *IN40         IFEQ      *OFF
HE   C     TRANSNOMP     ANDNE     '0000000'
HE   C     TRANSNOMP     ANDNE     '       '
HE   C                   MOVE      PONO01        ALPHAPO           7
HE   C     TAGTRNNOMP    IFEQ      '0000000'
HE   C     TAGTRNNOMP    OREQ      *BLANKS
HE   C     TAGTRNNOMP    OREQ      ALPHAPO
HE   C     BAKSTKQYMP    IFGT      0
HE   C                   MOVE      'P'           BOSTATCDMP
HE   C                   ENDIF
HE   C                   MOVE      *ON           *IN40
HE   C                   MOVE      PONO01        TAGTRNNOMP
HE   C                   MOVE      'PO'          TAGTRNTPMP
HE   C                   Eval      Dattimtmmp =
HE   C                              RtvDatTimStmp(USRNM)
HE   C                   EXCEPT    UPDTMOV
HE   C     DKEY          IFEQ      *ZEROS
HE   C                   MOVE      '4'           POCD15
HE   C                   MOVE      *BLANKS       PODN06
HE   C                   Z-ADD     0             PONO09                         NO BRANCH
HE   C                   Z-ADD     *ZEROS        PONO10                         CUSTOMER
HE   C                   MOVE      TRANSNOMP     PONO11                         REFERENCE
HE   C                   Z-ADD     TAGCNT        PONO12                         LINE SEQ NUMBER
HE   C                   eval      poqy02 = hdchkdecqty(bakstkqymp)             QTY TAGGED
HE   C                   WRITE     POFTTG
HE   C                   ADD       1             TAGCNT
HE   C                   MOVE      'Y'           POCD14
HE   C                   ENDIF
HE   C                   ENDIF
HE   C                   ENDIF
HE   C                   ENDDO
     C     ENDWON        TAG
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    TAG & HOLD                                              *
      *------------------------------------------------------------------------*
     C     WRTTG         BEGSR
     C                   Z-ADD     1             Z                              ARRAY INDEX
     C                   Z-ADD     1             TAGCNT            3 0          LINE SEQ NUMBER
     C     *IN40         DOUEQ     '0'
     C     Z             IFLE      MAXKY
     C     DKEY          LOOKUP    KY(Z)                                  40    TAG & HOLD
     C                   ELSE
     C                   MOVE      '0'           *IN40
     C                   END
     C     *IN40         IFEQ      '1'                                          EXIST ????
     C                   MOVEA     TH(Z)         TAGH                           TAG & HOLD
     C                   MOVE      'Y'           POCD14                         ITEM TAG CODE
     C                   SELECT
     C     ORDTYP        WHENEQ    'SO'
     C                   MOVE      '1'           POCD15
     C     TTCTL         IFEQ      *ZEROS
     C     TLIN          ANDNE     *ZEROS
     C                   Z-ADD     TLIN          TTCTL
     C                   ENDIF
     C     ORDTYP        WHENEQ    'TR'
     C                   MOVE      '2'           POCD15
     C     ORDTYP        WHENEQ    'CO'
     C                   MOVE      '3'           POCD15
     C     ORDTYP        WHENEQ    'WO'
     C                   MOVE      '4'           POCD15
     C                   OTHER
     C                   MOVE      TTYP          POCD15                         ITEM TAG TYPE
     C                   ENDSL
     C                   MOVE      TCOM          PODN06                         COMMENTS
     C                   Z-ADD     TBRA          PONO09                         BRANCH
     C                   Z-ADD     TCUS          PONO10                         CUSTOMER
   HIC*                  Z-ADD     TREF          PONO11                         REFERENCE
HI   C                   MOVE      TREF          PONO11                         REFERENCE
     C                   Z-ADD     TAGCNT        PONO12                         LINE SEQ NUMBER
     C                   Z-ADD     TQTY          POQY02                         QTY TAGGED
     C                   Z-ADD     TQTYF         POQY06                         TAG QTY FILLED
HH   C                   IF        POCD15 = '1'  OR
HH   C                             POCD15 = '3'
HH   C                   MOVE      TTORG         TGNO01                                     ED
HH   C                   MOVE      TTCTL         TGNO22                                     ED
HH   C                   Z-ADD     *ZEROS        IVNO55                                     ED
HH   C                   Z-ADD     *ZEROS        IVNO92                                     ED
HH   C                   ELSE
   HIC*                  Z-ADD     TTORG         IVNO55                                     ED
HI   C                   MOVE      TTORG         IVNO55                                     ED
     C                   Z-ADD     TTCTL         IVNO92                                     ED
HH   C                   MOVE      *ZEROS        TGNO01                                     ED
HH   C                   Z-ADD     *ZEROS        TGNO22                                     ED
HH   C                   ENDIF
     C                   WRITE     POFTTG                                       LINE ITEM TAGS
      *
      *  TEST FOR OUR ITEM NUMBER
     C     DTYP          IFNE      'N'
      *
      *  TEST FOR REF. NUMBER (ORDER NUMBER)
   HIC*    TREF          IFNE      0
HI   C     TREF          IFNE      *ZEROS
HI   C     TREF          ANDNE     *BLANKS
     C                   SELECT
     C     ORDTYP        WHENEQ    'SO'
      *  GET ORDER HEADER TO GET CUSTOMER NUMBER
     C     TREF          CHAIN     OELTOHY8                           40
      *
      *  SETUP TO READ SALES ORDER LINE ITEMS
     C     OLYKEY        SETLL     OELTOLY9
      *
     C     *IN40         DOUEQ     '1'
     C                   MOVEA     '00'          *IN(48)
      *  GET ORDER LINE ITEM PER CUST. AND ORDER NUMBER
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OLYKEY        READE     OELTOLY9                             9240
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN40         IFEQ      '0'
      *  TEST FOR OUR ITEM NUMBER EQUAL ITEM NUMBER FROM PO LINE ITEM
     C                   SELECT
     C     POCD01        WHENEQ    'D'                                          DIR P/O
     C     OECD01        ANDNE     'D'                                          NON-DIR S/O
     C                   ITER                                                   KEEP LOOKING
     C     POCD01        WHENNE    'D'                                          NON-DIR P/O
     C     OECD01        ANDEQ     'D'                                          DIR S/O
     C                   ITER                                                   KEEP LOOKING
     C     TLIN          WHENNE    0                                            TAG BY LINE
     C     TLIN          ANDNE     OENO22                                       S/O LINE#
     C                   ITER                                                   KEEP LOOKING
     C     POCD01        WHENNE    'D'                                          NON-DIR P/O
     C     PONO02        ANDNE     OENO16                                       NOT SAME BR
     C                   ITER                                                   KEEP LOOKING
     C                   ENDSL
     C     INO07         IFEQ      IVNO07
     C     OEQY02        IFGT      0
     C                   MOVE      'P'           OECD47
     C                   END
     C                   Z-ADD     PONO01        PNO01
     C                   CLEAR                   ONO15
     C     TLIN          IFEQ      OENO22
I0    * Use DSORLN for the ONO15 because PONO05 comes from the read
I0    * of OELTOLY9 just before this move and it is the old line number,
I0    * And we want to update with the new line number. If there were
I0    * no lines added DSORLN and PONO05 will be the same.
I0   C                   Z-ADD     DSORLN        ONO15
   I0C*                  Z-ADD     PONO05        ONO15
     C                   ENDIF
      *  TEST FORMAT FOR UPDATE - IND. 48= DAILY LINE ITEM FILE
     C     *IN48         IFEQ      '1'
     C                   EXCEPT    OFTOL
     C                   ELSE
     C                   EXCEPT    OFTOLY
     C                   END
     C                   ELSE
     C     *IN48         IFEQ      *ON
     C                   EXCEPT    RELO9
     C                   ELSE
     C                   EXCEPT    RELY9
     C                   ENDIF
     C                   END
     C                   END
     C                   END
      *
      * CONTRACT TAGS
     C     ORDTYP        WHENEQ    'CO'
     C     POCD42        ANDEQ     'Y'
      *
      * GET CONTRACT HEADER TO GET CUSTOMER NUMBER
     C     TREF          CHAIN     OEFTOAH                            40
      *
      * SETUP TO READ CONTRACT LINE ITEMS
     C     OLYKY2        SETLL     OELTOALB
      *
     C     *IN40         DOUEQ     *ON
      *
      * GET CONTRACT LINE ITEM PER CUSTOMER & ORDER NUMBER
      * CHECK FOR RECORD LOCK
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OLYKY2        READE     OETOALB                              9240
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN40         IFEQ      '0'
      *
     C                   SELECT
     C     OECD72        WHENNE    'Y'                                          NOT LOT CONTRACT
     C                   ITER
     C     POCD01        WHENEQ    'D'                                          DIR P/O
     C     OECD55        ANDNE     'Y'                                          NON-DIR C/O
     C                   ITER                                                   KEEP LOOKING
     C     POCD01        WHENNE    'D'                                          NON-DIR P/O
     C     OECD55        ANDEQ     'Y'                                          DIR C/O
     C                   ITER                                                   KEEP LOOKING
     C     POCD01        WHENEQ    'D'                                          DIRECT
     C     TLIN          ANDNE     0                                            TAG BY LINE
     C     TLIN          ANDNE     OENO31                                       C/O LINE#
     C                   ITER                                                   KEEP LOOKING
     C     POCD01        WHENNE    'D'                                          NON-DIR P/O
     C     PONO02        ANDNE     OENO16                                       NOT SAME BR
     C                   ITER                                                   KEEP LOOKING
     C                   ENDSL
     C     INO07         IFEQ      IVNO07
     C                   Z-ADD     PONO01        PNO01
     C                   CLEAR                   ONO15
I0   C                   CLEAR                   PNO05
     C     POCD01        IFEQ      'D'
     C     TLIN          ANDEQ     OENO31
I0    * Use DSORLN for the PNO05 because PONO05 comes from the read
I0    * of OETOALB just before this move and it is the old line number,
I0    * And we want to update with the new line number. If there were
I0    * no lines added DSORLN and PONO05 will be the same.
I0   C                   Z-ADD     DSORLN        PNO05
   I0C*                  Z-ADD     PONO05        PNO05
     C                   ENDIF
      *
      * UPDATE CONTRACT LINE ITEM
     C                   EXCEPT    OFTOAL
     C                   EXCEPT    RLSOAL
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     ORDTYP        WHENEQ    'TR'
     C                   Z-ADD     PONO02        IVNO57
     C     TRFKEY        SETLL     IVFTTL
     C                   MOVE      *IN92         SVIN92
     C                   MOVE      ' '           DSPF1
     C     *IN40         DOUEQ     *ON
     C     *IN92         DOUEQ     *OFF
     C     TRFKEY        READE     IVFTTL                               9240
     C     *IN92         CASEQ     *ON           UNLOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92
     C     *IN40         IFEQ      *OFF
     C     IVCD72        IFNE      'C'
     C     IVCD72        ANDNE     'V'
     C     IVCD70        ANDNE     'V'
     C     IVQYX2        IFGT      *ZEROS
     C                   MOVE      'P'           IVCD72                         BACKORDER STATUS
     C                   ENDIF
     C                   Z-ADD     PONO01        XXNO01
     C                   EXCEPT    IVTTL
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C     ORDTYP        WHENEQ    'WO'
HI H0C*                  TESTN                   TREF                 51
HI H0C*    *IN51         IFEQ      *ON
HI H0C*                  MOVE      TREF          TREF#
HI H0C*                  ENDIF
HI H0C*    TREF#         SETLL     WOFTOL
   HIC*    TREF          SETLL     WOFTOL
HE   C                   MOVE      TREF          AlphaTran
HE   C     AlphaTran     SETLL     WOMOVE                                 40
     C     *IN40         DOUEQ     *ON
     C     *IN92         DOUEQ     *OFF
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
   HIC*    TREF          READE     WOFTOL                               9240
HI HEC*    TREF#         READE     WOFTOL                               9240
HE   C     AlphaTran     READE     WOMOVE                                 40
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN40         IFEQ      *OFF
HE   C     TRNTYPCDMP    ANDNE     'WIP'
   HEC*    INO07         IFEQ      IVNO07
   HEC*    PNO01         ANDEQ     *ZEROS
   HEC*                  MOVE      'P'           OECD47
   HEC*                  Z-ADD     PONO01        PNO01
   HEC*                  Z-ADD     PONO05        ONO15
HE   C     ITEMNOMP      IFEQ      IVNO07
HE   C     TAGTRNNOMP    IFEQ      '0000000'
HE   C     TAGTRNNOMP    OREQ      '       '
HE   C                   MOVE      'P'           BOSTATCDMP
HE   C                   MOVE      PONO01        TAGTRNNOMP
HE   C                   MOVE      'PO'          TAGTRNTPMP
HE   C                   Eval      Dattimtmmp =
HE   C                              RtvDatTimStmp(USRNM)
HE   C                   EXCEPT    UPDWOMOVE
   HEC*                  EXCEPT    UPDWO
     C                   MOVE      *ON           *IN40
HE   C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSL
     C                   END
     C                   END
      *
     C                   ADD       1             TAGCNT                         LINE SEQ NUMBER
     C                   ADD       1             Z                              D/S INDEX
     C                   END
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    UPDATE INVENTORY                                        *
      *------------------------------------------------------------------------*
     CSR   UPDINV        BEGSR
     C                   Z-ADD     0             EXTCST            9 2
     C     POQY01        IFGT      0
     C     POAM02        MULT(H)   POQY01        EXTCST                         EXT COST
     C                   END
      *
      ***  ADD CODE TO CALL 'IVR0115' IF NO BRANCH MASTER FOR ITEM
      ***  'IVR0115' WILL ADD NEEDED BRANCH MASTER RECORD
     C     BRKEY         SETLL     IVFMSBR                                41
     C     *IN41         IFEQ      '0'
      * BRANCH MASTER NOT FOUND - GO SET-UP BLANK BRANCH MASTER
     C                   CALL      'IVR0115'
     C                   PARM                    PONO02                         SHIP TO BRANCH
     C                   PARM                    IVNO07                         ITEM #
     C                   PARM                    APPCDE                         APPLICATION
     C                   END
      *
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     BRKEY         CHAIN     IVFMSBR                            4192
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
      *
HZ   C     *IN41         IFEQ      *OFF
      *
     C                   Z-ADD     UMONTH        IVMO01                         DATE OF LAST
     C                   Z-ADD     UDAY          IVDY01                          UPDATE AND
     C                   MOVEL     *YEAR         IVCC01                          WHO DUN-IT
     C                   Z-ADD     UYEAR         IVYR01                          WHO DUN-IT
     C                   MOVE      USRNM         IVNM01                         UPDATE USER
     C                   ADD       POQY01        IVQY17                         MTD QTY PURCHAS
     C     POCD20        IFEQ      'O'                                          OPEN ORDER
     C                   ADD       QTYRMN        IVQY22                         QTY ON ORDER
     C                   END
     C                   ADD       1             IVCN13                         MTD COUNT OF
     C                   ADD       EXTCST        IVAM28                         MTD COST AMOUNT
      *
      * ENTERED DATE OF THIS P.O. VS LAST PURCHASE DATE IN BRANCH
      * MASTER FILE..RESET LAST P.O.,DATE, AND LAST PURCHASE DATE
     C                   MOVE      IVNO13        LSTPO#
     C     DATENT        IFGT      LSTPUR
     C     DATENT        OREQ      LSTPUR
     C     PONO01        ANDGT     LSTPO#
     C                   MOVE      *BLANKS       IVNO13                         P/O NUMBER
     C                   MOVEL     PONO01        IVNO13                         LAST P/O #
     C                   Z-ADD     POMO11        IVMO16                         DATE OF LAST
     C                   Z-ADD     PODY11        IVDY16                          TIME ITEM
     C                   Z-ADD     POCC11        IVCC16                          PURCHASED
     C                   Z-ADD     POYR11        IVYR16                          PURCHASED
     C     PONO07        IFNE      *ZERO
     C                   Z-ADD     POQY01        IVQY06                         LAST ORDER QTY
     C                   ENDIF
     C                   END
      *
     C                   UPDATE    IVFMSBR                                       PURCHASES
      * UPDATE THE B/O LOWSTOCK WORKFILE FOR THIS LINE BUY ITEM...
     C     IMNO08        IFNE      *BLANKS
     C     DQTY          ANDNE     DOQTY
     C                   MOVE      IMNO08        LBLINE
     C                   MOVE      IVNO10        LBBRN
     C                   MOVE      IVNO07        LBITM
     C                   CALL      'IMR0510'     PL0510
     C                   ENDIF
HZ   C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      ** SUBROUTINE ** SHOW GENERATE SALES ORDER QUESTION            *****
      *------------------------------------------------------------------------*
     C     DIRQST        BEGSR
     C                   MOVE      ' '           GENORD
     C                   MOVE      '0'           *IN30                          QUESTION OFF
     C     POCD01        IFEQ      'D'                                          DIRECT ORDER
     C     POCD42        ANDNE     'Y'                                          LOT P/O
     C                   Z-ADD     1             X
     C     DITM          DOUEQ     *BLANKS
     C     X             ORGT      ITMSIZ
     C     X             OCCUR     SAVDS
      *
      * If there are any lines not tagged to a sales order,
      * default generate S/O to 'Y'...
      *
     C     DQTY          IFNE      *ZEROS
     C     DKEY          IFEQ      *ZEROS
     C     DNO7          IFNE      *ZEROS
     C                   MOVE      'Y'           GENORD
     C                   MOVE      *ON           *IN30
      * Check to see if non-stock exists on a sales order.  If so, it
      * will get auto-tagged, so we will consider it as being tagged...
     C                   ELSE
     C                   CLEAR                   ZZNO04
     C                   MOVEL     DITM          ZZNO04
     C     ZZNO04        SETLL     OELTOL14                               41
     C     *IN41         IFEQ      *OFF
     C                   MOVE      'Y'           GENORD
     C                   MOVE      *ON           *IN30
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *OFF          TGTOSO            1
     C                   CLEAR                   Z
     C     *IN41         DOUEQ     *OFF
     C                   ADD       1             Z
     C     Z             IFLE      MAXKY
     C     DKEY          LOOKUP    KY(Z)                                  41    TAG & HOLD
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C     *IN41         IFEQ      *ON                                          EXIST ????
     C                   MOVEA     TH(Z)         TAGH                           TAG & HOLD
     C     ORDTYP        IFEQ      'SO'                                         S/O TAG
     C                   MOVE      *ON           TGTOSO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C     TGTOSO        IFEQ      *OFF
     C                   MOVE      'Y'           GENORD
     C                   MOVE      *ON           *IN30
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * If P/O is currently closed, determine if there is an open
      * quantity, and if so, default the status to open...
      *
     C     POCD20        IFEQ      'C'
     C     DQTY          ANDNE     *ZEROS
     C     DQTY          SUB       DQYR          QTYRMN
     C     QTYRMN        IFGT      *ZEROS
IQ   C     POCD03        ANDNE     'Y'
     C                   MOVE      'O'           POCD20
     C                   ENDIF
     C                   ENDIF
      *
      * If the P/O status is open and the generate order flag has
      * already been loaded, get out of here...
      *
     C     POCD20        IFEQ      'O'
     C     GENORD        ANDNE     *BLANKS
     C                   LEAVE
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDIF
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  DIRECT-SUBROUTINE: EXECUTE ORDER ENTRY. THIS SUB. WILL EXE**
      *         ONLY WHEN THE PO IS A DIRECT ORDER AND AT LEAST    **
      *         ONE OF THE LINE ITEM CARRIES ZERO ORDER # AND      **
      *         AN "Y" IN GEN SALES ORDER QUESTION ON COMPLETION SCR*
      *------------------------------------------------------------------------*
     C     DIRECT        BEGSR
     C     GENORD        IFEQ      'Y'                                          YES ON QUEST
      *
      * SETUP LDA: PO# AND "Y" FOR POFLAG MEANS THIS SALES ORDER
      * IS FROM P/O SYSTEM NOT FROM O/E ENTRY
      *
     C                   MOVE      PONO01        PONUMB
     C                   MOVE      'Y'           POFLAG
     C                   MOVE      PONO02        SHIPBR
     C                   MOVE      PONO03        SELLBR
     C                   OUT       PARAM
      *
   IKC*                  WRITE     POF0120M
     C                   CALL      'OER2020'                                    O/E ENTRY
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
      ** SUBROUTINE ** WRITE UNIT COST FROM PO TO OE LINE ITEM       *****
      *------------------------------------------------------------------------*
     C     WRTCOS        BEGSR
     C     DTYP          IFNE      'N'                                          NOT NON-STK
     C     DTYP          ANDNE     'C'                                          NOT COMMENT
     C     DTYP          ANDNE     'D'                                          LOT DETAIL ITEM
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     OEKEY         CHAIN     OEFTOLK                            4992
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
      *
      * PROCESS ALL O/E LINE FOR PO#/ORG ORD#/ITEM#/LINE REF#
      * REGARDLESS OF B/O STATUS AND THE ORDER STATUS.
      * DO NOT UPDATE COST IF LINE ITEM HAS COST OVERRIDE OR
      * USING CONTRACT COST.
     C     *IN49         DOWEQ     *OFF
     C     PONO24        IFEQ      0
     C     OECD27        ANDNE     'O'
     C     OECD27        ANDNE     'C'
      *
      * RETRIEVE PRICE UOM FACTOR USING API.
     C                   Z-ADD     DNO7          AUOMI#
     C                   MOVE      *BLANKS       AUOMOU
     C                   CALL      'POR0117'     PL0117                         UOM API
     C     PUAMDF        MULT(H)   AUOMPF        OEAM02                         UNIT COST
     C     PUAMDF        MULT(H)   UOMDF         OEAM40                         ORDERING
     C                   Z-ADD     PUAMDF        OEAM41
     C                   MOVE      'V'           OECD27
     C                   EXCEPT    OFTOLK
     C                   ELSE
     C                   EXCEPT    RLTOLK                                       Release rcd
     C                   END
     C     *IN92         DOUEQ     *OFF
     C     OEKEY         READE     OEFTOLK                              9249
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   END
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
      ** SUBROUTINE ** WRITE LOT DETAIL                                    *****
      *------------------------------------------------------------------------*
     C     WRTLOT        BEGSR
      *
     C     TOAD1         IFEQ      *BLANK
     C                   MOVE      'Y'           TOAD1             1
     C                   OPEN      OELTOAD1
     C                   ENDIF
      *
     C     OENO61        IFEQ      *ZERO
     C                   Z-ADD     1             OENO61
     C                   ELSE
     C                   ADD       1             OENO61
     C                   ENDIF
     C                   CLEAR                   ADNO07
     C                   CLEAR                   OEDN12
     C                   CLEAR                   OEDN13
     C                   CLEAR                   OEQY19
     C                   CLEAR                   OEQY20
     C                   CLEAR                   OEQY21
   HIC*                  Z-ADD     LTORD#        ADOE01                         ORDER #
HI   C                   MOVE      LTORD#        ADOE01                         ORDER #
     C                   Z-ADD     LTCTL#        ADNO31                         CONTROL #
     C                   Z-ADD     DQTY          OEQY18
     C                   Z-ADD     PONO01        ADPO01
     C                   MOVEL     DUOM          ADDN04
     C                   Z-ADD     ARNO01        ADAR01
     C                   Z-ADD     ARNO15        ADNO15
     C                   Z-ADD     UMONTH        OEMO02
     C                   Z-ADD     UDAY          OEDY02
     C                   MOVEL     *YEAR         OECC02
     C                   Z-ADD     UYEAR         OEYR02
     C                   MOVE      USRNM         OENM01
      *
      * DETERMINE ITEM TYPE
      *
     C                   MOVEL     DITM          PRT1              1            OUR ITEM # ?
     C                   SELECT
     C     PRT1          WHENEQ    '/'                                          NONSTOCK
     C                   MOVEL     DITM          OEDN12                         NSTK ID#
     C                   MOVE      'N'           OECD85                         ITEM TYPE CD
     C                   Z-ADD     1             OEQY19                         UOM FACTOR
      * COMMENTS
     C     PRT1          WHENEQ    '*'                                          BODY COMMENT
     C     PRT1          OREQ      '#'                                          LINE COMMENT
     C                   MOVEL     PRT1          OEDN12                         NSTK ID#
     C                   MOVEL     DDES          OEDN13                         COMMENT
     C                   MOVE      'C'           OECD85                         ITEM TYPE CD
      * ITEM/PRODUCT#
     C                   OTHER                                                  ITEM/PRODUCT #
     C                   Z-ADD     DNO7          ADNO07                         ITM#
     C                   MOVEL     DITM          FLD06             6            OUR ITEM # ?
     C                   MOVEL     DITM          FLD12            12
     C                   MOVE      FLD12         REST6             6            OUR ITEM # ?
     C                   MOVEL     FLD06         TESTN7            7            TEST FLD
     C                   MOVE      '0'           TESTN7                         TEST FLD
     C                   TESTN                   TESTN7               69        OUR ITEM # ?
     C     REST6         IFNE      *BLANKS
     C                   MOVE      *OFF          *IN69
     C                   ENDIF
     C     *IN69         IFEQ      *ON
     C                   MOVE      'I'           OECD85                         ITEM#
     C                   ELSE
     C                   MOVE      'P'           OECD85                         PRODUCT#
     C                   ENDIF
      *
      * RETRIEVE PURCHASE ORDER UOM FACTOR USING API.
     C                   Z-ADD     ADNO07        AUOMI#
     C                   MOVE      ADDN04        AUOMOU
     C                   CALL      'POR0117'     PL0117                         UOM API
     C     AUOMOF        IFNE      *ZEROS
     C                   Z-ADD     AUOMOF        OEQY19
     C                   ENDIF
      *
     C                   ENDSL
      *
      * DETAIL CONTROL#
      *
     C                   Z-ADD     DSCTRL        ADNO56                         CTRL #
     C     ADNO56        IFEQ      *ZERO
      *
      * CALL PROGRAM TO ASSIGN CONTROL NUMBERS
      *
     C                   CALL      'POR0021'     PL0021
      *
     C                   ENDIF
      *
     C                   WRITE     OEFTOAD                                      LOT DETAIL
      *
      * WRITE NONSTOCK DESCRIPTION IF IT DOES NOT ALREADY EXIST...
      *
     C     OECD85        IFEQ      'N'                                          NONSTOCK
     C                   CLEAR                   INO04
     C                   MOVEL     OEDN12        INO04
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     INO04         CHAIN     IVFTNSK                            4592
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVEL     DDES          IDN01
     C                   Z-ADD     UMONTH        IMO01                          LAST UPDATE MO
     C                   Z-ADD     UDAY          IDY01                          LAST UPDATE DY
     C                   MOVEL     *YEAR         ICC01                          LAST UPDATE DY
     C                   Z-ADD     UYEAR         IYR01                          LAST UPDATE YR
     C                   MOVE      USRNM         INM01                          USER ID NAME
     C     *IN45         IFEQ      *OFF
     C                   UPDATE    IVFTNSK
     C                   ELSE
     C                   WRITE     IVFTNSK
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *------------------------------------------------------------------------*
      *  CHGCMP - SUBROUTINE: CHANGE COMPONENT ITEMS
      *------------------------------------------------------------------------*
     C     CHGCMP        BEGSR
      *
     C                   MOVE      *BLANK        CHGCMB            1            CHANGE COMPONENT
HI   C                   MOVE      *ZEROS        LDO
     C                   CALL      'OER9550'
     C                   PARM                    LOTDS
   HIC*                  PARM      0             LDO               7 0
HI   C                   PARM                    LDO               7
     C                   PARM      0             LDSQ              5 0
     C                   PARM                    PONO02
     C                   PARM                    TAXCHG            1            TAXABLE ?
      *
      * UNLOAD DATA STRUCTURE
      *
     C                   Z-ADD     1             INDX
     C     INDX          DOUGT     56
     C     INDX          OCCUR     LOTDS
     C     CIQTY         IFGT      *ZERO
     C     CITYP         OREQ      'D'
     C                   ADD       1             X
     C                   ADD       1             CNTLIN                         # OF LINE ITEMS
     C     X             OCCUR     SAVDS                                26
     C     *IN26         CABEQ     *ON           ENDCC
     C     INDX          IFEQ      1
     C                   Z-ADD     CICST         DCST                           COST
     C                   MOVE      CIDSC         DDSC                           DISCOUNT
     C                   MOVE      SVMAN         DMAN                           MANUF NUMBER
     C                   MOVE      SVCOVR        DCOV                           COST OVERRIDE
     C                   MOVE      SVDOVR        DDOV                           DISC OVERRIDE
     C                   MOVE      SVITMX        DITMX                          NONSTK ITM
     C                   MOVE      SVASN         DASN                           SYSTEM ASSGNED
     C                   MOVE      SVSFBK        DSBOOK                         PURCH BOOK CHECKD?
     C                   MOVE      SVDNR         DSDNR                          DNR FLAG
¢I   C                   MOVE      SVESD         DSESD                          PURCH BOOK CHECKD?
¢8   C                   MOVE      SVORGPROD     DSORGPROD
HL   C                   MOVE      SVDEL         DSDEL                          DEL ITM FLAG
     C                   MOVE      SVETAO        ETADO                          ETA DATE
     C                   MOVE      SVETCC        POCC13                         ETA DATE
     C                   MOVE      SVEDT         DEDIT                          EDIT FLAGS
     C                   MOVE      SVEDT1        DEDIT1                          "    "
     C                   MOVE      SVEDT3        DEDIT3                          "    "
     C                   MOVE      SVEDT4        DEDIT4                          "    "
     C                   MOVE      SVEDT5        DEDIT5                          "    "
     C                   MOVE      ONASNF        DONASN                         ON ASN FLAG
     C                   MOVE      SVSECX        DSECX                          SAVE SECTION
     C                   MOVE      SVETAR        ETADR                          ETA DATE
     C                   MOVE      SVRTCC        POCC15                         ETA DATE
     C                   Z-ADD     SVQTYR        DQYR                           QTY RELEASED
     C                   Z-ADD     SVORLN        DSORLN                         SAVED LINE #
JV   C                   Z-ADD     SVORGL        DSORGL                         SAVED LINE #
     C                   Z-ADD     SVSO          SAVDO
     C                   MOVE      SVSOCC        SVCC13                         ETA DATE
     C                   Z-ADD     SVSR          SAVDR
     C                   MOVE      SVSRCC        SVCC15                         ETA DATE
     C                   Z-ADD     SVDIFF        DODIFF                         QTY DIFF
     C                   MOVE      SVPREV        DSPREV
     C                   Z-ADD     SVKEY         DKEY                           TAG/HOLD KEY
     C                   ENDIF
     C                   Z-ADD     CIITM         DNO7                           ITEM NUMBER
     C                   Z-ADD     CIQTY         DQTY                           QTY
     C                   Z-ADD     CIQTY         DOQTY                          QTY ORD
     C                   MOVEA     CIPDDS        CXPDDS
     C                   MOVEL     CIPDDS        DITM                           PROD#
     C                   MOVE      CIPDDS        DDES                           DESC
     C     ' '           CHECK     DDES          XC                2 0
     C     XC            IFGT      *ZERO
     C                   SUBST(P)  DDES:XC       DDES
     C                   ENDIF
     C                   MOVE      SAVNS         DITMX
     C                   MOVE      CIUOM         DUOM                           UNIT OF MEASURE
     C                   MOVE      CIUOM         DUMP                           UNIT OF MEASURE
     C                   MOVE      CITYP         DTYP                           ITEM TYPE
     C                   Z-ADD     CIKLC#        DSCTRL
     C                   ADD       1             INDX
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C     ENDCC         ENDSR
      *
      *----------------------------------------------------------------
      *  @PRMPT - SUBROUTINE: PROCESS F4 , ALL FORMATS
      *----------------------------------------------------------------
     C     @PRMPT        BEGSR
      *
     C     CPOS          IFNE      0
      *
     C                   MOVE      *OFF          F4ERR             1
      *
     C                   EXSR      @CURSR
      *
     C                   SELECT
     C     CRCD          WHENEQ    'POS0120E'
     C     CRCD          OREQ      'POS0120N'
      *
     C     CRCD          IFEQ      'POS0120E'
     C     CRRN          CHAIN     POS0120E                           42
     C                   ELSE
     C     CRRN          CHAIN     POS0120N                           42
     C                   ENDIF
     C                   MOVE      *OFF          *IN32                          SFLNXTCHG
      *
     C                   SELECT
     C     CFLD          WHENEQ    'SEL'
     C     IVNO7         ANDNE     0
     C                   MOVE      *BLANKS       VALUE#
     C                   CALL      'TBR0060'     PL0060                         TABLE FILE\ACTION
     C     VALUE#        IFNE      *BLANKS
     C                   MOVEL     VALUE#        SEL
     C     ACT#          IFEQ      '1'
     C                   MOVE      *OFF          *IN04                          PROCESS SEL
     C                   ENDIF                                                  TABENT
     C                   ENDIF                                                  TABENT
      *
     C     CFLD          WHENEQ    'UOM'
     C     *IN42         ANDEQ     *OFF
     C     IVNO7         ANDNE     0                                            VALID ITEM ?
     C     QTYR          ANDEQ     0                                            NONE RCVD ?
     C                   Z-ADD     IVNO7         ITMWK
     C                   Z-ADD     QTY           QUAN
     C                   MOVE      UOM           UOMWK
     C                   Z-ADD     UOMSF         FACTO
     C                   MOVE      'P'           FRMAPP
     C                   EXSR      @CURSR
     C                   CALL      'IVR3450'     PL3450
     C     QUAN          IFNE      0
     C                   Z-ADD     QUAN          QTY
#4   C                   Z-ADD     QUAN          QTYO
     C                   MOVE      UOMWK         UOM
     C                   MOVE      UOMWK         OUOM
     C                   Z-ADD     FACTO         UOMSF
     C     QTY           MULT      UOMSF         UQYSF
     C                   ENDIF
      *
     C     CFLD          WHENEQ    'UOM'
     C     *IN42         ANDEQ     *OFF
     C     NSITMX        ANDNE     *BLANKS
     C     QTYR          ANDEQ     0                                            NONE RCVD ?
     C                   MOVE      'IV40'        TABCOD
     C                   MOVE      *BLANKS       VALUE2
     C                   CALL      'TBR0025'     PL0025
     C     VALUE2        IFNE      *BLANKS
     C                   MOVE      *BLANKS       UOM
     C                   MOVEL     VALUE2        UOM
     C                   ENDIF
     C                   OTHER
     C                   MOVE      *ON           F4ERR
     C                   ENDSL                                                  CFLD
      *
     C     *IN42         IFEQ      *OFF
     C                   MOVE      *ON           *IN32                          SFLNXTCHG
      * DO NOT DISPLAY UOM FACTOR DATA IF PURCHASE UOM FACTOR = 1...
     C     UOMSF         IFEQ      1
     C                   MOVE      *ON           *IN26
     C                   ENDIF
      * PROTECT UOM FIELDS IF QTY'S HAVE BEEN RECEIVED...
     C     QTYR          IFNE      0                                            QTY RECEIVED
     C                   MOVE      *ON           *IN60
      *  MAINTAIN PRODUCT NUMBER PROTECTION ALSO...
     C                   MOVE      *ON           *IN84
     C                   ENDIF
      *
      * IF ITEM ON OPEN ASN IN WM SYSTEM, PROTECT PROD#.
      * CANNOT DELETE ITEM.
     C                   MOVE      *OFF          *IN54
     C     WHMBR         IFEQ      'Y'
G3   C     WHMTYP        ANDEQ     'Y'
     C     ONASNF        IFEQ      'Y'
     C     ONASNF        OREQ      '0'
     C                   MOVE      *ON           *IN54
     C                   END
     C                   END
¢8    * Check to see if this is an original line
¢8    * If so, then the item needs to be protected if po sent to vendor
¢8   C                   MOVE      *OFF          *IN28
#5 :AC*                  IF        ediSolution <> 'SPS'
¢8 :AC*                  IF        SFORGPROD <> *BLANKS
¢8 :AC*                  IF        SentToVendor = 'Y'
:A   C                   IF        SFORGPROD <> *BLANKS and
:A   C                             SentToVendor = 'Y'
¢8   C                   MOVE      *ON           *IN28
¢8   C                   ENDIF
¢8 :AC*                  ENDIF
#5 :AC*                  ENDIF
      *
     C     CRCD          IFEQ      'POS0120E'
     C                   UPDATE    POS0120E
     C                   ELSE
     C                   UPDATE    POS0120N
     C                   ENDIF
JT   C                   MOVE      *OFF          *IN23
     C                   MOVE      *OFF          *IN26
¢8   C                   MOVE      *OFF          *IN28
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN84
     C                   ENDIF                                                  *IN42
      *
      * PRICING SCREEN ?
     C     CRCD          WHENEQ    'POS0120G'
     C     CRRN          CHAIN     POS0120G                           42
     C                   CLEAR                   UOMSEL
      *
     C                   SELECT
      *
     C     CFLD          WHENEQ    'PUOM'
     C     *IN42         ANDEQ     *OFF
     C     IVNO7         ANDNE     0                                            VALID ITEM ?
     C     QTYR          ANDEQ     0                                            NONE RCVD ?
     C                   Z-ADD     IVNO7         ITMWK
     C                   Z-ADD     0             QUAN
     C                   MOVE      PUOM          UOMWK
     C                   Z-ADD     PUOMSF        FACTO
     C                   EXSR      @CURSR
     C                   MOVE      'S'           FRMAPP                         SEL ONLY
     C                   CALL      'IVR3450'     PL3450
     C     PUOM          IFNE      UOMWK
     C                   MOVE      'Y'           UOMSEL            1
     C                   ENDIF
     C                   OTHER
     C                   MOVE      *ON           F4ERR
     C                   ENDSL                                                  CFLD
      *
     C     *IN42         IFEQ      *OFF
      * PROTECT UOM FIELDS IF QTY'S HAVE BEEN RECEIVED...
     C     QTYR          IFNE      0                                            QTY RECEIVED
     C                   MOVE      *ON           *IN60
     C                   ENDIF
     C                   UPDATE    POS0120G
     C                   MOVE      *OFF          *IN60
     C                   ENDIF                                                  *IN42
      *
      *
      * WE MAKE SVREF NEGATIVE TO EASILY IDENTIFY AN ALREADY
      * ESTABLISHED VALID TRANSACTION NUMBER.  SO USER WON'T HAVE
      * TO TELL US AGAIN WHICH TRANSACTION TYPE HE IS TRYING TO TAG TO.
      *
     C     CRCD          WHENEQ    'POS0120F'
     C     CFLD          IFNE      'TREF'
     C                   MOVE      MSG(1)        MSGFLD
     C                   ELSE
     C     CRRN          CHAIN     POS0120F                           42
     C     *IN42         IFEQ      *OFF
     C     TREF          IFEQ      *ZEROS
HI   C     TREF          OREQ      *BLANKS
     C     ORDTYP        ORNE      'TR'
     C     ORDTYP        ANDNE     'SO'
     C                   MOVEL     EMS(38)       MSGFLD
     C                   ELSE
   HIC*                  Z-SUB     1             SVREF                          FORCE EDIT
HI   C                   MOVE      'ZZZZZZZ'     SVREF
     C                   ENDIF
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
     C                   UPDATE    POS0120F
HC   C                   eval      *in78 = *off
     C                   ELSE
     C                   MOVEL     MSG(1)        MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
     C     CRCD          WHENEQ    'POS0120R'
     C     CFLD          IFNE      'TREF'
     C                   MOVE      MSG(1)        MSGFLD
     C                   ELSE
     C     CRRN          CHAIN     POS0120R                           42
     C     *IN42         IFEQ      *OFF
     C     TREF          IFEQ      *ZEROS
HI   C     TREF          OREQ      *BLANKS
     C     ORDTYP        ORNE      'TR'
     C     ORDTYP        ANDNE     'SO'
     C                   MOVEL     EMS(38)       MSGFLD
     C                   ELSE
   HIC*                  Z-SUB     1             SVREF                          FORCE EDIT
HI   C                   MOVE      'ZZZZZZZ'     SVREF
     C                   ENDIF
HC   C                   if        onAsnF = 'Y'
HC   C                   eval      *in78 = *on
HC   C                   endif
     C                   UPDATE    POS0120R
HC   C                   eval      *in78 = *off
     C                   ELSE
     C                   MOVEL     MSG(1)        MSGFLD
     C                   ENDIF
     C                   ENDIF
KJ    *
KJ   C     CRCD          WHENEQ    'POF0120B'
KJ    *
KJ    * SHIP VIA PROMPT FOR VENDOR RHEEM VND# 684200
KJ   C                   SELECT
KJ   C     CFLD          WHENEQ    'PODN02'
KJ   C                   MOVE      'PO07'        TABCOD
KJ   C                   MOVE      *BLANKS       TABENT
KJ   C                   MOVEL     APNO01        TABENT
KJ   C     TABKEY        SETLL     TBFMTBL
KJ   C                   IF        %EQUAL
KJ   C                   MOVE      *BLANKS       VALUE2
KJ   C                   MOVE      *BLANKS       VALUE3
KJ   C                   MOVE      *BLANKS       CFLD#
KJ   C                   MOVEL     APNO01        CFLD#
KJ   C                   MOVE      ' '           MODE
KJ   C                   CALL      'TBR0025'     PL0025
KJ   C     VALUE3        IFNE      *BLANKS
KJ   C                   MOVEL     VALUE3        PODN02
KJ   C     ACT#          IFEQ      '1'
KJ   C                   MOVE      *OFF          *IN04
KJ   C                   ENDIF
KJ   C                   ENDIF
KJ   C                   ENDIF
KJ   C                   OTHER
KJ   C                   MOVE      *ON           F4ERR
KJ   C                   ENDSL
      *
     C                   ENDSL                                                  CFLD
      *
     C                   ELSE
     C                   MOVE      *ON           F4ERR
     C                   ENDIF
      *
      * SEND ERROR MESSAGE - CURSOR LOCATION INVALID
      *
     C     F4ERR         IFEQ      *ON
     C                   MOVE      MSG(1)        MSGFLD
     C                   ENDIF
      *
     C                   Z-ADD     ROW           CROW                           REPOSITION
     C                   Z-ADD     COL           CCOL                           CURSOR
      *
     C     #PRMPT        ENDSR
KO    *----------------------------------------------------------------
KO    *  @Load_Mfg - SUBROUTINE: PROCESS F9 , ALL FORMATS
KO    *----------------------------------------------------------------
KO   C     @Load_Mfg     BEGSR
KO
KO   C                   EVAL      *IN61 = *OFF
KO   C                   MOVE      *OFF          F9ERR             1
KO   C     CPOS          IFNE      0
KO   C     MAN           IFEQ      *BLANKS
KO    *
KO   C                   EXSR      @CURSR
KO    *
KO   C                   SELECT
KO   C     CRCD          WHENEQ    'POS0120E'
KO   C     CRCD          OREQ      'POS0120N'
KO    *
KO   C     CRCD          IFEQ      'POS0120E'
KO   C     CRRN          CHAIN     POS0120E                           42
KO   C                   ELSE
KO   C     CRRN          CHAIN     POS0120N                           42
KO   C                   ENDIF
KO    *
KO   C                   SELECT
KO   C     CFLD          WHENEQ    'MAN'
KO   C     IVNO7         IFNE      0
KO   C     ZZNO04        CHAIN     IVLMSTRC
KO   C                   IF        %FOUND(IVLMSTRC)
KO   C                   IF        NO93 = *BLANKS
KO   C                   EVAL      *IN61 = *ON
KO   C                   EVAL      MSGFLD = 'Manufacturer number not found.'
KO   C                   ELSE
KO   C                   EVAL      *IN61 = *OFF
KO   C                   EVAL      MAN = NO93
KO   C                   EVAL      MSGFLD = 'Manufacturer number found.'
KO   C                   ENDIF
KO   C                   ENDIF
KO   C                   ELSE
KO   C                   EVAL      *IN61 = *ON
KO   C                   EVAL      MSGFLD = 'Manufacturer number not found.'
KO   C                   ENDIF
KO   C                   MOVE      *OFF          *IN09                          PROCESS SEL
KO   C                   OTHER
KO   C                   MOVE      *ON           F9ERR
KO   C                   ENDSL                                                  CFLD
KO    *
KO   C     *IN42         IFEQ      *OFF
KO   C                   MOVE      *ON           *IN32                          SFLNXTCHG
KO   C     CRCD          IFEQ      'POS0120E'
KO   C                   UPDATE    POS0120E
KO   C                   ELSE
KO   C                   UPDATE    POS0120N
KO   C                   ENDIF
KO   C                   MOVE      *OFF          *IN32
KO   C                   ENDIF                                                  *IN42
KO   C                   ENDSL                                                  CFLD
KO    * mfg# not blank
KO   C                   ELSE
KO   C                   EVAL      *IN61 = *ON
KO   C                   EVAL      MSGFLD = 'Manufacturer number not blank.'
KO   C                   ENDIF                                                  *IN42
KO   C                   ELSE
KO   C                   MOVE      *ON           F9ERR
KO   C                   ENDIF
KO
KO    * give error if the cursor is not in the mfg# field for a valid item
KO   C                   if        F9Err = *on
KO   C                   EVAL      MSGFLD = 'Cursor must be on the manufacturer-
KO   C                              number field for the desired item.'
KO   C                   ENDIF
KO
KO   C     #Load_Mfg     ENDSR
      *------------------------------------------------------------------------*
      *  @CURSR - SUBROUTINE: RETREIVE CURSOR LOCATION,RECORD & FIELD
      *------------------------------------------------------------------------*
     C     @CURSR        BEGSR
      *
     C     C@LOC         DIV       256           ROW
     C                   MVR                     COL
     C                   MOVE      ROW           ROW#              3
     C                   MOVE      COL           COL#              3
     C     ROW#          CAT       COL#          C@LOC#            6
     C                   MOVEL     CRCD          CRCD#
     C                   MOVEL     CFLD          CFLD#
      *
     C                   ENDSR
      *----------------------------------------------------------------
      *  @CLCSR - CLEAR CURSOR LOCATION KEYWORD
      *----------------------------------------------------------------
     C     @CLCSR        BEGSR
      *
     C                   Z-ADD     0             CROW                           CLEAR
     C                   Z-ADD     0             CCOL                           CSRLOC
      *
     C     #CLCSR        ENDSR
      *----------------------------------------------------------------
      *  CKCLOS - CHECK IF CUST ACCOUNT CLOSED
      *----------------------------------------------------------------
     C     CKCLOS        BEGSR
     C     SAVBR#        CHAIN     ARFMBCH                            41
     C     *IN41         IFEQ      '0'
     C                   MOVE      ARNO15        SAVCO#
     C     CLSKEY        CHAIN     ARFMBAL                            41
     C     *IN41         IFEQ      '0'
     C     ARFL17        IFEQ      'C'
     C                   MOVE      *ON           *IN95
     C                   MOVEA     EMS(3)        MSGFLD
     C                   Z-ADD     0             SAVCUS
     C                   MOVE      *BLANKS       ARNM01
     C                   END
     C                   ELSE
     C                   MOVE      *ON           *IN95
     C                   MOVEA     EMS(3)        MSGFLD
     C                   Z-ADD     0             SAVCUS
     C                   MOVE      *BLANKS       ARNM01
     C                   END
     C                   END
     C                   ENDSR
      *----------------------------------------------------------------
     C     FAXOPT        BEGSR
      *----------------------------------------------------------------
     C                   EXSR      @CURSR
     C                   MOVEL     PONO01        DOCNUM           12
     C                   MOVE      SYSTEM        SYSID             4
     C                   MOVE      *BLANKS       FAXNUM
     C                   MOVEL     FAXSC         FAXNUM
     C                   MOVE      OPTS          OPTION
     C                   MOVE      APNO01        TRNNUM
JK   C                   if        afp = 'Y'
     C                   CALL      'OPR0300'     R0300
JK   C                   Else
JK   C                   Eval      option = 'NNNN'
JK   C                   EndIf
     C                   MOVE      FAXNUM        FAXNBR
     C                   MOVE      OPTION        OPTS
     C     FAX4C         IFEQ      ' '
     C                   MOVE      'N'           FAX4C
     C                   ENDIF
     C                   EXSR      @CLCSR
     C                   ENDSR
      *
      *------------------------------------------------------------------------*
      *         SUBROUTINE          UNLOCK RECORD CALL                         *
      *------------------------------------------------------------------------*
     C     UNLOCK        BEGSR
     C                   MOVE      *BLANK        DSPF2
     C                   CALL      'OPC1002'     RLOCK
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
     C     *LIKE         DEFINE    POQYPF        $PRFCT
     C     *LIKE         DEFINE    POQY01        $STQTY
     C     *LIKE         DEFINE    POAMU2        $PRCST
¢E #9C*    *LIKE         DEFINE    IVNO93        ZZNO93
      *
     C     $PRFCT        IFEQ      *ZEROS
     C                   Z-ADD     1             $PRFCT
     C                   ENDIF
     C     $STQTY        DIV(H)    $PRFCT        $PRQTY           15 5
     C     $PRQTY        MULT(H)   $PRCST        $EXCST           15 5
IO   C     $PRQTY        MULT(H)   DLST          $LSTCST          15 5
KA    * Initialize Target values...
KA   C                   eval      $Weight = 0
KA   C                   eval      $Cubes  = 0
KA   C                   eval      $Pieces = 0
KA    * Calculate Target values for accumulation...
IO   C     PSDKEY1       CHAIN     PRLMPSD3
IO   C                   IF        %FOUND
IO   C     $STQTY        MULT(H)   IMWT01        $WEIGHT          15 5
IO   C     $STQTY        MULT(H)   IMNO14        $CUBES           15 5
IO   C     $STQTY        MULT(H)   IMNO15        $PIECES          15 5
KA   C                   else
KA    * Not on Price Sheet? Get weight from Item Master based on Primary Vendor...
KA   C     WeightKey     Chain     ivlmstr9
KA   C                   if        %found(ivlmstr9)
KA   C     $StQty        mult(H)   VI_ivwt01     $WEIGHT
KA   C                   endif
IO   C                   ENDIF
HS   C                   Eval      DExtCost = $ExCst
     C                   ENDSR
      *****************************************************************
      * Get Trading Partner Information using Data Queue
      *****************************************************************
      *
     C     GETTPI        BEGSR
      *
     C                   CALL      'EIR9505'     PL9505
      *
     C     RCVSTS        IFEQ      '0'
     C                   MOVE      *OFF          *IN42
     C                   ELSE
     C     RCVSTS        IFNE      '1'
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'EDI '        TABCOD                         TABLE CODE
     C                   MOVEL     RCVSTS        TABENT                         TABLE ENTRY
     C                   MOVE      *ON           *IN88
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVE      TBNO03        BYNM01
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
      * Check whether item is On ASN in WM system or not.
      *------------------------------------------------------------------------*
     C     CHKASN        BEGSR
      * DETERMINE IF TRANSACTION EXISTS IN W/M...
     C                   CLEAR                   WMTRAN
     C                   MOVEL     'PO'          POPOPO
HI   C                   MOVE      PONO01        WMN#
     C     WMKEY         CHAIN     WXFTXRF                            47
     C     *IN47         IFEQ      *OFF
     C                   MOVEL     WMNO06        WMTRAN            7 0
     C                   ENDIF
      *
      * Get interface transaction group number
     C                   Z-ADD     *ZEROS        HDGRP#
     C                   CALL      'WIR0118'
     C                   PARM                    WMGRP#           15
      *
      * Request the ASN detail information for this PO/ITEM
     C                   CLEAR                   ASNDTA
     C                   MOVE      WMGRP#        HDGRP#
      * MASTER OR SUMMARY ?
     C     MFILE         IFEQ      'Y'
     C                   MOVE      'M'           HDFUNC
     C                   ELSE
     C                   MOVE      'S'           HDFUNC
     C                   ENDIF
      *
     C                   MOVE      'ASN'         HDCODE
     C                   MOVE      'WI'          HDFRM
     C                   MOVE      *BLANK        HDSTAT
     C                   MOVEL     HDRDS         ASNDTA
     C     WMTRAN        IFNE      0
     C                   Z-ADD     WMTRAN        ASNTX#
     C                   MOVE      'U'           ASNTYP
     C                   ELSE
     C                   Z-ADD     PONO01        ASNTX#
     C                   MOVE      'P'           ASNTYP
     C                   ENDIF
     C                   MOVEL     '*OPEN'       ASNSTS
     C                   MOVEL     '*FIRST'      ASNOCR
     C     MFILE         IFNE      'Y'
     C     IVNO07        IFNE      *ZEROS
     C                   Z-ADD     IVNO07        ASNSI#
     C                   CLEAR                   ASNNSI
     C                   ELSE
     C                   CLEAR                   ASNSI#
     C                   MOVEL     INO04         ASNNSI
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      DQLIB         ASNQLB
     C                   MOVE      DQNAME        ASNQNM
     C                   CALL      'WXR0220'
     C                   PARM      'WIIN'        QUENAM           10
     C                   PARM      '*LIBL'       LIBNAM           10
     C                   PARM      2025          MSGSZ             5 0
     C                   PARM                    ASNDTA
      *
      * Send completion message for this group
     C                   CLEAR                   ENDDTA
     C                   MOVE      WMGRP#        HDGRP#
     C                   MOVE      'E'           HDFUNC
     C                   MOVE      'ASN'         HDCODE
     C                   MOVE      'WI'          HDFRM
     C                   MOVEL     HDRDS         ENDDTA
     C                   Z-ADD     PONO01        ENNO01
     C                   MOVE      DQLIB         ENDQLB
     C                   MOVE      DQNAME        ENDQNM
     C                   CALL      'WXR0220'
     C                   PARM      'WIIN'        QUENAM
     C                   PARM      '*LIBL'       LIBNAM
     C                   PARM      2025          MSGSZ
     C                   PARM                    ENDDTA
      *
      * Receive from data queue within 5 seconds.
     C                   MOVEL     DQLIB         LIBNAM
     C                   MOVEL     DQNAME        QUENAM
     C                   Z-ADD     0             DX                3 0
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    QUENAM
     C                   PARM                    LIBNAM
     C                   PARM                    MSGSZ
     C                   PARM                    DQMSG
     C                   PARM      5             WAITTM            5 0
      *
      * IF NO MESSAGE RETURN WITHIN 5 SECONDS,
      *    LOAD ZERO INTO STATUS AND PREVENT USER FROM MAINTENANCE.
     C                   MOVEL     DQMSG         HDRDS
     C     MSGSZ         IFEQ      *ZEROS
     C                   MOVE      '0'           HDSTAT
     C                   ENDIF
      *
     C                   ENDSR
HY    *----------------------------------------------------*
HY    * Rtv_Col_Cost retrieves all 3 column costs.         *
HY    *----------------------------------------------------*
HY
HY   C     Rtv_Col_Cost  BEGSR
IS   C                   clear                   ColCostChg        1
KH   C                   clear                   ColCostZro        1
IS   C                   eval      LastColCst = ColCst
HY
HY   C                   eval      CC_PRCD53 = 'C'
HY   C                   eval      colCst = 0
HY   C                   eval      colCs1 = 0
HY   C                   eval      colCs2 = 0
HY   C                   eval      colCs3 = 0
KH   C                   eval      owght  = ivwt01 * oqty
KH KLC*                  eval      odlrs  = prAm13 * oqty
KL    * convert Replace cost to Stocking UOM level and
KL    * ordered quantity to stocking UOM level
KL   C                   if        puomdf <> *zeros
KL   C                   eval      odlrs  = (prAm13/puomsf) * (oqty * uomsf)
KL   C                   else
KL   C                   eval      odlrs  = 0
KL   C                   endif
HY   C     COLKEY        CHAIN     PRFMPSC
HY   C                   IF        %FOUND
HY   C                   eval      colCs1 = cc_PrAm26
HY   C                   eval      colCs2 = cc_PrAm27
HY   C                   eval      colCs3 = cc_PrAm28
HY
HY    * CHK FOR QUANTITY
HY   C                   if        CC_PRCD56 = 'Q'
HY   C                   if        qty      >=  cc_PrQy08
HY   C                   eval      colCst    = colCs3
HY   C                   endif
HY    *
HY   C                   if        qty      >= cc_PrQy07 and
HY   C                             colCst    = 0
HY   C                   eval      colCst    = colCs2
HY   C                   endif
HY    *
HY   C                   if        qty      >= cc_PrQy06 and
HY   C                             colCst    = 0
HY   C                   eval      colCst    = colCs1
KH    * Remove the (Goto ENDCST) statement as logic has been added that needs to occur...
KH    * Apparently when the goto was added, the only logic being bypassed had to do with the
KH    * colCst = 0. Since colCst had just been loaded, the goto bypassed the zero cost logic.
KH    * But now we have logic that deals with non-zero colCst, so it cannot be bypassed...
HY KHC*                  Goto      ENDCST
HY   C                   endif
HY    *
HY   C                   endif
HY    *
HY    * CHK FOR WEIGHT
HY   C                   if        CC_PRCD56 = 'W'
HY   C                   eval      wght      = ivwt01 * QTY
HY   C                   if        wght     >=  cc_PrQy08
HY   C                   eval      colCst    = colCs3
HY   C                   endif
HY    *
HY   C                   if        wght     >= cc_PrQy07 and
HY   C                             colCst    = 0
HY   C                   eval      colCst    = colCs2
HY   C                   endif
HY    *
HY   C                   if        wght     >= cc_PrQy06 and
HY   C                             colCst    = 0
HY   C                   eval      colCst    = colCs1
KH    * Remove (Goto ENDCST) statement as logic has been added that needs to occur... See above...
HY KHC*                  Goto      ENDCST
HY   C                   endif
HY    *
HY   C                   endif
HY    *
HY    * CHK FOR DOLLARS (USING REPLACEMENT)
HY   C                   if        CC_PRCD56 = 'D'
HY KLC*                  eval      dlrs      = prAm13 * QTY
KL    * convert Replace cost to Stocking UOM level and
KL    * ordered quantity to stocking UOM level
KL   C                   if        puomdf <> *zeros
KL   C                   eval      dlrs      = (prAm13/puomsf) * (qty * uomsf)
KL   C                   else
KL   C                   eval      dlrs      = 0
KL   C                   endif
HY   C                   if        dlrs     >=  cc_PrQy08
HY   C                   eval      colCst    = colCs3
HY   C                   endif
HY    *
HY   C                   if        dlrs     >= cc_PrQy07 and
HY   C                             colCst    = 0
HY   C                   eval      colCst    = colCs2
HY   C                   endif
HY    *
HY   C                   if        dlrs     >= cc_PrQy06 and
HY   C                             colCst    = 0
HY   C                   eval      colCst    = colCs1
HY   C                   endif
HY    *
HY   C                   endif
KH    * If cost override flag is on but the Cost is equal to Replacement Cost, remove the
KH    * override flag.
KH   C                   if        covr = 'Y' and cost = pram13
KH   C                   eval      covr = ' '
KH   C                   endif
KH    *
KH    * Establish LastColCost value if it is missing...
KH    * The following situation tends to occur when the user changes a
KH    * quantity to a value that does not meet any column cost qualifiers
KH    * and presses ENTER on the first display of the line item screen.
KH    * No column cost will be found with the new quantity entered,
KH    * but the original quantity would have pulled a column cost,
KH    * so the previous column cost value (LastColCost) should have a value,
KH    * but it is zero because it was never established with the orig qty.
KH    * Establish the LastColCost value using the original quantity now...
KH   C                   if        ColCst = 0 and LastColCst = 0
KH    *  By Original Quantity
KH   C                   if        CC_PRCD56 = 'Q'
KH   C                   if        oqty      >= cc_PrQy08
KH   C                   eval      LastColCst = colCs3
KH   C                   endif
KH    *
KH   C                   if        oqty      >= cc_PrQy07
KH   C                   eval      LastColCst = colCs2
KH   C                   endif
KH    *
KH   C                   if        oqty      >= cc_PrQy06
KH   C                   eval      LastColCst = colCs1
KH   C                   endif
KH   C                   endif
KH    *  By Original Weight
KH   C                   if        CC_PRCD56 = 'W'
KH   C                   if        owght      >= cc_PrQy08
KH   C                   eval      LastColCst = colCs3
KH   C                   endif
KH    *
KH   C                   if        owght     >= cc_PrQy07
KH   C                   eval      LastColCst = colCs2
KH   C                   endif
KH    *
KH   C                   if        owght     >= cc_PrQy06
KH   C                   eval      LastColCst = colCs1
KH   C                   endif
KH   C                   endif
KH    *  By Original Dollars
KH   C                   if        CC_PRCD56 = 'D'
KH   C                   if        odlrs      >= cc_PrQy08
KH   C                   eval      LastColCst = colCs3
KH   C                   endif
KH    *
KH   C                   if        odlrs     >= cc_PrQy07
KH   C                   eval      LastColCst = colCs2
KH   C                   endif
KH    *
KH   C                   if        odlrs     >= cc_PrQy06
KH   C                   eval      LastColCst = colCs1
KH   C                   endif
KH   C                   endif
KH   C                   endif
HY    *
HY KHC*                  endif
KH    * No Columm Cost Qualifiers met?
KH    * Flag to prevent an Override situation when re-pulling cost...
KH    * This only applies to items setup with Cost Qualifiers...
KH   C                   if        ColCst = 0
KH   C                   eval      ColCostZro = 'Y'
KH   C                   endif
IS    * Columm Cost Calculated different from Prior Column Cost
IS    * Set flag indicating Column Cost has changed
IS   C                   if        ColCst <> 0
IS   C                             and LastColCst <> ColCst
IS   C                   eval      ColCostChg = 'Y'
IS   C                   endif
IS    * No Columm Cost found when there was one before
IS    * Clear Cost so it can be re-pulled
IS   C                   if        ColCst = 0
IS   C                             and LastColCst <> 0
IS   C                   eval      Cost = 0
IS   C                   endif
IS    * New Column Cost found when there was not one before
IS    * Clear Cost Overide (if one exists) to load new column cost
IS    * For example:
IS    * Buy 10 get for $4, Buy 50 get for $3, Buy less than 10 get for $10
IS    * Less than 10 is not a colum cost, and the system will pull a cost
IS    * However, it can do this as a cost override, so if you chg qty from 55 to 5
IS    * and then back to 55, the overide keeps the cost at $10 instead of $3
IS    *
IS   C                   if        LastColCst = 0
IS   C                             and ColCst <> 0
IS   C                   eval      Covr = ' '
IS   C                   endif
KH   C                   endif
HY
HY   C     ENDCST        ENDSR
IO    *------------------------------------------------------------------------*
IO    * Load target values and calculate totals for Completion Screen
IO    *------------------------------------------------------------------------*
IO   C     COMTT         BEGSR
IO    * Get Targets...
IO   C     PONO01        CHAIN     IMFWTGT                            84
IO    * Calculate Totals...
IO    * These need to occur prior to display of completion screen to be accurate
IO    * on the first display. Any changes to Tac % or Other Charges will occcur
IO    * after user Presses Enter...
IO   C     TAXPCT        MULT      .01           TAXPC
IO   C     POTL01        MULT(H)   TAXPC         POAM04
IO   C                   Eval      POTL02 = POTL01 + POAM03 + POAM04
IO   C                   EVAL      CSTTOT = POTL02
IO   C                   Eval      LSTTOT = LSTTOTAL + POAM03 + POAM04
IO   C                   ENDSR
I2    *------------------------------------------------------------------------*
I2    * ROAD NET INSTALLED...AND USER AUTHORITY TO USE ROADNET
I2    *------------------------------------------------------------------------*
I2   C     $ROAD         BEGSR
I2    *------------------------------------------------
I2    * SEE WHAT ADD ONS ARE BEING USED
I2    *------------------------------------------------
I2   C                   MOVE      'ADON'        TABCOD
I2   C                   MOVE      *BLANKS       TABENT
I2   C                   MOVEL     'ADDON'       TABENT
I2   C     TABKEY        CHAIN     TBFMTBL                            40
I2    *
I2   C     *IN40         IFEQ      *OFF
I2   C                   MOVEL     TBNO03        ADONS
I2   C                   ELSE
I2   C                   MOVE      *ALL'N'       ADONS
I2   C                   ENDIF
I2    *--------------------------------------------------------
I2    * ROADNET SYSTEM - DISPLAY / NON-DISPLAY
I2    *--------------------------------------------------------
I2   C     RNSYS         IFEQ      'Y'
I2   C                   MOVE      *ON           *IN65
I2   C                   ELSE
I2   C                   MOVE      *OFF          *IN65
I2   C                   ENDIF
I2    *--------------------------------------------------------
I2    * RETRIEVE THE USER'S AUTHORITY TO MAINTAIN ROADNET STATUS.
I2    *--------------------------------------------------------
I2   C                   MOVE      USRNM         USER
I2   C                   MOVE      'OP'          APP
I2   C                   MOVE      'RN01'        CDE
I2   C                   Z-ADD     1             ID
I2   C                   MOVE      *BLANKS       USRVAL
I2   C                   MOVE      *BLANKS       VALFRM
I2   C                   MOVE      *BLANKS       RTNCOD
I2   C                   CALL      'OPR8220'     PL8220
I2   C     RTNCOD        IFEQ      '0'
I2   C                   MOVEL     USRVAL        RNAUTF            1
I2   C                   ELSE
I2   C                   MOVE      *BLANKS       RNAUTF
I2   C                   ENDIF
I2   C     RNAUTF        IFEQ      'Y'                                          AUTH
I2   C                   MOVE      *ON           *IN70
I2   C                   ELSE
I2   C                   MOVE      *OFF          *IN70
I2   C                   ENDIF
I2    *
I2   C                   ENDSR
JF    *------------------------------------------------------------------------*
JF    * Highlight error for tags over 990 limit
JF    *------------------------------------------------------------------------*
JF   C     TARERR        BEGSR
JF    *
JF   C     MSGFLD        IFEQ      UMS(66)
JF   C     SWITCH        IFEQ      'F'
JF   C                   EVAL      TERRRN = RNO
JF   C                   ELSE
JF   C                   EVAL      TERRRN = RNR
JF   C                   ENDIF
JF   C                   EVAL      *IN52 = *ON
JF   C                   EVAL      *IN69 = *ON
JF   C                   EVAL      *IN80 = *ON
JF   C                   EVAL      *IN88 = *ON
JF   C                   ENDIF
JF    *
JF   C                   ENDSR
      *------------------------------------------------------------------------*
     OPOFTOH    E            DUM1
     OPOFTOH    E            UPDREV
     O                       PONO18
     OOEFTOL    E            OFTOL
     O                       OECD47
     O                       PNO01
     O                       ONO15
      *
     OIVFTTL    E            IVTTL
     O                       IVCD72
     O                       XXNO01
     OIVFTTLK   E            UPDTTL
     O                       PNO01
     O                       IVCD72
     O                       IVAMZ2
     O                       IVAM31
     O                       IVAMAF
HS   O                       IVAMTF
      *
     OOEFTOLY   E            OFTOLY
     O                       OECD47
     O                       PNO01
     O                       ONO15
      *
     OOETOL14   E            TOL14
     O                       OECD47
     O                       PNO01
     O                       OEAM02
     O                       OEAM40
     O                       OEAM41
     O                       OECD27
     O                       ONO15
      *
     OOETOLY14  E            TOY14
     O                       OECD47
     O                       PNO01
     O                       ONO15
      *
     OOEFTOLK   E            OFTOLK
     O                       OEAM02
     O                       OEAM40
     O                       OEAM41
     O                       OECD27
      *
     OOEFTOL    E            RELO9
     OOEFTOLY   E            RELY9
     OOEFTOLK   E            RLTOLK
     OOETOALA   E            TOALA
     O                       OECD47
     O                       PNO01
     O                       OEAM02
     O                       OEAM17
     O                       OEAM40
     O                       OEAM41
     O                       OECD27
     OOETOALB   E            OFTOAL
     O                       OECD47
     O                       PNO01
     O                       PNO05
     O                       OEAM02
     O                       OEAM17
     O                       OEAM40
     O                       OEAM41
     O                       OECD27
     OOETOALB   E            RLSOAL
   HEO*WOTOL3    E            UPDWO3
   HEO*                      OECD47
   HEO*                      PNO01
   HEO*                      ONO15
   HEO*WOFTOL    E            UPDWO
   HEO*                      PNO01
   HEO*                      ONO15
   HEO*                      OECD47
HE   OWKFTMOV   E            UPDTMOV
HE   O                       BOSTATCDMP
HE   O                       TAGTRNNOMP
HE   O                       TAGTRNTPMP
HE   O                       DATTIMTMMP
HE   OWOMOVE    E            UPDWOMOVE
HE   O                       BOSTATCDMP
HE   O                       TAGTRNNOMP
HE   O                       TAGTRNTPMP
HE   O                       DATTIMTMMP
     OPOFTRH    E            UNLRH3
     OPOFTRH    E            UPDRH3
     O                       POCD24
     OPOFTRH1   E            UPDRH1
     O                       POCD24
      *
      *
      *------------------- TABLE FILE CHANGE AREA -----------------------------*
HA    * ADD UMS,63 Quantity limited to 99 for serial numbered items.
¢E    * Added TABLE CMS
HD    * ADD EMS,56 Item must be consignable.
HD    * ADD EMS,57 Ship to branch item must be consignment for a consignment
HD    *            purchase.
HD    * ADD EMS,58 Vendor Rep must be entered.
HD    * ADD EMS,59 Vendor Rep Location has been defaulted. Press enter to continue.
HD    * ADD EMS,60 Consigned Purchase & From Vendor Rep flags, can not both be set 'Y'.
HD    * ADD EMS,61 Consigned Purchase flag must be 'Y' or 'N'.
HD    * ADD EMS,62 From vendor rep flag must be 'Y' or 'N'.
HD    * ADD EMS,63 Consigned purchase not allowed if Direct, Blanket or Overhead
HF    * CHANGED UMS,63
HF    * BEFORE:Quantity limited to 99 for serial numbered items.
HF    * AFTER: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
HL    * Added following message #64 to UMS table.
HL    * Warning. Item master for this item has been deleted.
IX    * CHANGED UMS,15
IX    * BEFORE:Warning!  Non-stock item not found in sales order.
IX    * AFTER: Warning! Non-stock item not found on S/O, C/O, W/O, or Transfer.
I0 JN * ADD CMS,1 Line items inserted as comments. Please verify or modify as needed.
I0 JN * ADD CMS,2 P/O Receiver found, cannot insert lines.
I0 JN * ADD CMS,3 Cannot insert lines for a Lot Type Purchase Order.
I0 JN * ADD CMS,4 EDI Processing has occurred, line insertion no longer allowed.
JC    * CHANGED UMS,55
JC    * BEFORE: Purchase order not found.
JC    * AFTER:  Purchase order not found, or Voided.
JF    * Added UMS,66
JF    * Cannot add new tag as the purchase order has reached the max tag limit.
JN    * Delete CMS 1-4
JN    * ADD EMS,64 Line items inserted as comments. Please verify or modify as needed.
JN    * ADD EMS,65 P/O Receiver found, cannot insert lines.
JN    * ADD EMS,66 Cannot insert lines for a Lot Type Purchase Order.
JN    * ADD EMS,67 EDI Processing has occurred, line insertion no longer allowed.
JM    * ADD UMS,67 Quantity tagged exceeds transfer quantity ordered.
J2    * NEW JOBQ QFORMS
KI    * Added UMS(68)
KI    * You are not authorized to enter PO with overhead item.
KP    * Added ARY2
KP    *  SNDMSG MSG('XXXXXXXXXXXXXXXXXXXXX') TOMSGQ(REMRPTS)
¢P    * ADDED ENTRY 6 TO TABLE CMS
¢P    *   Slash items are not allowed.
¢Q    * ADDED ENTRY 7-10 TO TABLE CMS
¢S    * ADDED ENTRY 11 TO TABLE CMS
¢T    * Changed CMS,2
¢T    * Before: Slow or Excess Item.  Contact Charles for approval to order.
¢T    * Before: Slow or Excess Item.  Contact Misty for approval to order.
¢X    * ADDED ENTRY 12 TO TABLE CMS
¢2    * Add NPI to the message CMS(2)
¢3    * Create new NPI message CMS(13)
¢9    * Add error message CMS(15)
#9    * CMS 1 no longer used
      *------------------------------------------------------------------------*
** A5
SBMJOB JOB(PURCHORDR) JOBD(HDJPACK) JOBPTY(4) RQSDTA('CALL PGM(POC0115
) PARM(''XXXXXXXXXXXXXXXX'')') MSGQ(*NONE)
**     (FX) - SUBMIT JOB TABLE FOR SENDING FAX
SBMJOB CMD(CALL PGM(OPC0500) PARM('XXXX' 'XXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXX' 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXX' 'XXXXXX' 'XXXXXX' ' ')) JOB(FM
_PO) JOBD(*LIBL/HDJPACK) JOBPTY(4) MSGQ(*NONE)
 JOBQ(QFORMS)
** UMS (ERRMSG) - ERROR MESSAGE TABLE
You must print, fax, or email the P/O to print revised lines.                  1
Order not udpated if F3 is pressed again.                                     03
Enter day, days or due date if discount % is not zero.                        04
Enter only one!  Day, days or due date for discount.                          05
Warning!  Due date year is not current year.                                  06
Enter fax number or change fax flag to (N).
If due day is greater than 31, special terms must be in table AP09.           08
Negative cost not allowed.
Negative list not allowed.
Order lost if F3 is pressed again.
Invalid discount entered.
Zero cost not allowed.
Maximum number of lines exceeded!  Review order, some lines were dropped.     13
Temporary item must be verified.                                              14
Warning! Non-stock item not found on S/O, C/O, W/O, or Transfer.              15
Non-stock item entered on previous P/O.                                       16
Line items must be entered.                                                   17
Item not found.                                                               18
Combination items cannot be purchased.                                        19
Description required for non-stock items.                                     20
Quantity ordered cannot be less than quantity received.                       21
Quantity ordered must be greater than zero.                                   22
Purchasing book codes not found.                                              23
Warning!  Item is "DNR" and cannot be reordered.                              24
Warning!  Item not in the purchasing book.                                    25
Correct ETA date.                                                             26
ETA date cannot be less than current date - original value used.              27
ETA date cannot be less than ordered date, check header information.          28
Correct revised date.                                                         29
Rvsd date cannot be less than current date - original value used.             30
Rvsd date cannot be less than ordered date, check header information.         31
Warning!  System assigned non-stock item not found in sales order.            32
Warning!  Quantity defaulted to the sales order quantity.                     33
Duplicate entry of non-stock numbers is not allowed.                          34
Unit of measure not found for this item.                                      35
Non-stock item does not exist on a transaction for this ship to branch.       36
This non-stock item is already tagged to a transfer.                          37
Verify line items, press enter to continue.                                   38
Order not updated if F3 is pressed again.                                     39
Warning!  Some items not tagged. B/O fill will fail. Press enter to continue. 40
ETA date cannot be less than ordered date - original value used.              41
Rvsd date cannot be less than ordered date - original value used.             42
This non-stock is on a transfer.  You cannot place it on a direct P/O.        43
This non-stock is on a direct S/O.  You cannot place it on a non-direct P/O.  44
This non-stock is on a non-direct S/O.  You cannot place it on a direct P/O.  45
Branch is closed.                                                             47
ETA date default was changed to H (header) for direct order.                  47
Enter the quantity tagged.                                                    48
Quantity tagged exceeds salesorder quantity ordered.                          49
Warning!  Item already tagged to transfer.                                    51
Non-stock is on a sales order for a different customer.                       51
Non-stock item's last 8 characters are not numbers.                           52
Invalid UOM. Press F4 for the list.
Warning! Non-stock item found on pending sales order.
Purchase order not found, or Voided.
Not authorized to P/O`s branches.
P/O reference number required.
P/O reference number not found.
Branch not found for P/O reference number entered.
P/O has receiver(s) locked for maintenance.  P/O maintenance not allowed.
This is a voided transfer.
Tag branch cannot be the same as the P/O ship to branch for WM branches.      62
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
Warning. Item master for this item has been deleted.                          64
List value entered exceeds limits of Cost field and cannot be used.           65
Cannot add new tag as the purchase order has reached the max tag limit.       66
Quantity tagged exceeds transfer quantity ordered.                            67
You are not authorized to enter PO with overhead item.                        68
** MSG (ERRMSG) - ERROR MESSAGE TABLE
Invalid cursor location for F4=Prompt.
** EMS
Customer not found.
Cash account customer cannot be used for a direct P/O.
Customer account is closed - cannot be used.
Ship to name must be entered.
Shipping address line 1 must be entered.
Enter the shipping city.
Shipping state must be entered.
Enter the main zip code.
Order not updated if F3 is pressed again.
Customer changed, tags must be reviewed.
EMS,11 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Reference number is valid for multiple transaction types. Please choose one.
Sales order/Transfer not found.
Sales order shipping branch is not the same as P/O receiving branch.
Transfer shipping branch is not the same as P/O receiving branch.
Referenced item was not found on a transfer.
Referenced item was not found as an open backorder for this transfer.
Branch is not set up.
Customer not found.
Referenced item was not found on a sales order.
Total tagged qty exceeds stocking qty ordered. Change P/O qty or tag qty.
Warning, P/O quantity should not be less than received P/O quantity.
Tagged quantities cannot be less than the Filled To Date quantity.
Tags for branch and customer not allowed at same time.
This item is already tagged.
Type (T-Transfer) allowed only with branch, not customer.
Type (T-Transfer) branch cannot equal Ship To Branch of P/O.
Type (T-Transfer) not allowed for direct order.
Branch or reference number must be entered.
Sales order number must be entered.
Branch not allowed for direct order.
There are no sales order lines available for tagging to this item.
Multiple tags not allowed for directs.
Tag limit has been exceeded.
This item has not been tagged to a sales order line, please correct.
Invalid tag.  Direct vs non-direct, or customer mis-match.
No transfer line was selected for the transfer number entered.
Reference type is not valid for F4=Prompt.
Additional items are not allowed on a direct lot P/O.
Lot item is already tagged to a direct lot P/O.                                2
Sales order, transfer, nor contract found.
Invalid tag.  Customer on contract does not match customer on P/O.
Invalid tag.  Cannot tag a contract to a non-direct P/O.
Referenced item not found on contract.
Contract shipping branch is not the same as P/O receiving branch.
Quantity tagged exceeds contract quantity ordered.                            37
Warning!  Quantity defaulted to the contract order quantity.                  33
Warning! Non-stock item found on voided sales order.                           8
Cannot use pricing UOM as a purchasing UOM.
Email ability is not currently set up. Cannot specify 'E'.
Only one selection allowed.                                                   51
Cancel backorders must be 'Y' or 'N'.
Not authorized to cancel backorders on directs.
Cannot decrease quantity as open ASN exist for item in WM System.
Warning! Cancel B/O will cause B/O's to be voided on tagged S/O's.            55
Item must be consignable.
Ship to branch item must be consignment for a consignment purchase.
Vendor rep must be entered.
Vendor rep location has been defaulted. Press enter to continue.
Consigned purchase & from vendor rep flags, can not both be set 'Y'.
Consigned purchase flag must be 'Y' or 'N'.
From vendor rep flag must be 'Y' or 'N'.
Consigned purchase not allowed if Direct, Blanket or Overhead
Line items inserted as comments. Please verify or modify as needed.
P/O Receiver found, cannot insert lines.
Cannot insert lines for a Lot Type Purchase Order.
EDI Processing has occurred, line insertion no longer allowed.
** CMS ¢E ¢I ¢k ¢l ¢O ¢2 ¢3 #9
                                                                               1
Slow, Excess Item.  Contact Purch Mgr for approval to order.                   2
Primary vendor assigned to item <> po vendor.                                  3
Order type is disallowed.                                                      4
Both EDI and Fax/Email cannot be selected.                                     5
Slash items are not allowed.                                                   6
Enter buyer initials.                                                          7
Buyer initials not found.                                                      8
Buyer initials not allowed.  User id does not match.                           9
P/O total cannot be more than P/O limit.                                      10
Item already entered on P/O. Duplicate entry not allowed.                     11
Slow or Excess Item.  Press enter to continue.                                12
NPI Item.  Contact Purch Mgr for approval to order.                           13
Item vendor does not match PO vendor.  Item cannot be ordered on this PO.     14
Sales Order Price is < PO Cost. Missing special quote?'                       15
** AMS
Referenced item not found on work order.
Work order shipping branch is not the same as P/O receiving branch.
** DOA Submit job for Direct Order Audit
SBMJOB JOB(DIRAUDIT) JOBD(HDJPACK) RQSDTA('CALL PGM(POR0010) PARM(''P'
' ''XXXXXXX'')') JOBPTY(4) LOG(0) MSGQ(*NONE)
** ARY2
SNDMSG MSG('XXXXXXXXXXXXXXXXXXXXX') TOMSGQ(REMRPTS)
