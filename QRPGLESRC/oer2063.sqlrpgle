SB   H option(*srcstmt: *nodebugio) debug
&6       ctl-opt dftactgrp(*no);
&6       ctl-opt bnddir('SHBIND':'WMBIND':'HDBIND':'WKBIND':'MNBIND':'YAJL'
&6         :'ECBIND');
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - OER2063                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D MAINTENANCE/SHIPMENT CONFIRMATION OF SALES ORDERS                     *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    MAINTAIN WORK ORDER INFORMATION INCLUDING THE HEADER, LINE         *
     F*S    ITEM, CASH SALE, OTHER CHARGES, SHIPPING ADDRESS, AND              *
     F*S    COMMENTS.                                                          *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
UY   F*S                                                                     *
UY   F*S            Task 8000013755 moved ALL subroutines from member        *
UY   F*S            OER2063 into this member (OEY2063).                      *
UY   F*S                                                                     *
UY   F*S            This was done so that going forward, there would         *
UY   F*S            be ample room to support future subroutines as           *
UY   F*S            well as existing customer modifications to any           *
UY   F*S            subroutines.                                             *
UY   F*S                                                                     *
UY   F*S            All custom subroutines and new package                   *
UY   F*S            subroutines should be added to OER2063 after the         *
UY   F*S            /COPY OEY2063 statement.                                 *
UY   F*S                                                                     *
UY   F*S            It is recommended to add custom subroutines              *
UY   F*S            after new package subroutines in OER2063.                *
UY   F*S                                                                     *
OM   F*S IMPORTANT: IF YOU MAKE CHANGES TO OEPWRGA FILE THEN YOU NEED        *
OM   F*S            TO MAKE CHANGES TO PSDATA IN THIS PROGRAM.               *
OM   F*S            ALSO MUST MAKE CHANGES TO PROGRAMS OER0450,              *
OM   F*S            OER0451, OER0453, OER0491, OER0492, OER0495.             *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
MI   F*U 0340000754 010306 070 QUOTE GOING ON HOLD IN MAINTENANCE              *
MJ   F*U 1110000416 011106 144 PRINT INVOICE FLAG NOT RETAINED                 *
MK   F*U 8000009837 020106 062 CHANGES TO REL 11.0 FOR ILE                     *
ML   F*U 1550000221 041806 238 ITEM SHIP QTY REMOVED IN ORDER REVW             *
MM   F*U 1090000293 051906 248 PRINT/FAX/EMAIL NET PRICES                      *
MN   F*U 1220001059 052406 127 NO F4 PROMPT ON SALES ID IN MAINTENANCE         *
MO   F*U 8000009876 060606 070 NON-STOCK INVENTORY BALANCING                   *
MP   F*E 8000009570 070306 020 HD/WO Interface                                 *
MQ   F*U 1280000343 073106 127 ADD GP% WARNING TO S/O MAINTENANCE              *
MR   F*E 8000009883 080306 907 SERIAL NUMBER TRACKING                          *
MS   F*U 0100004944 081006 127 NEW TRANSFER TAGS FROM PEND TRF RELEASE         *
MU   F*U 0910000231 081906 127 JOB CHG FOR ORDER RLS FROM CONTRACT             *
MV   F*E 8000009889 060506 171 Warranty claim entry                            *
MW   F*U 8000009994 091406 070 UNABLE TO ENTER CREDIT MEMO                     *
MX   F*U 1430000282 092106 127 CUST OVR CRED LIMIT & REL PEND ORDR             *
MY   F*U 0930000240 092606 907 CHANGE FAX/EMAIL TO DEFAULT TO 'N'              *
MZ   F*U 0520000236 092806 907 REMOVE LIMIT OF 99 SERIAL#
M0   F*U 1430000299 102006 127 NOT GETTING WINDOW FOR TAX CODE
M1   F*U 1110000449 110806 907 CHG METHOD OF SHIP NOT UPD SHIP TO
M2   F*U 8000010003 111006 070 FUTURE INV & INVENTORY BALANCING                *
M3   F*U 1550000240 120606 062 SHIPPED QTY WRONG ON LOT ITEM                   *
M4   F*U 1430000292 121206 070 CREDIT IN WMS DOUBLES ALLOC QTY                 *
M5   F*E 8000009966 010407 914 CHANGE S/O NUMBER TO 7 ALPHA                    *
NC   F*U 1550000241 022707 127 F9 PROTECT PULLING UP WRONG SCREEN              *
NE   F*U 0930000237 032407 913 SENDING MSG TO QCONSOLE                         *
NF   F*E 8000010117 040407 907 SERIAL NUMBER CONTROL CHANGES                   *
ND   F*U 0970000262 030107 127 PENDING CREDIT MEMO CORRECT PRICING             *
NG   F*U 1290000262 050307 914 F4=PROMPT ON JOB # IN ORDER MAINT               *
NH   F*E 8000010120 051607 907 SERIAL NUMBER CORRECTIONS-USER GROUP            *
NJ   F*U 0970000275 061907 248 CONTRACT AMT IN UNINVOICED SCREEN               *
NK   F*U 8000010169 071707 248 INCORRECT TAX ON B/O AMOUNT                     *
NL   F*U 0430000269 071907 915 Step tax issue for mult UOM on item             *
NM   F*E 8000009999 083007 907 SERIAL NUMBER CHANGES FOR V/R                   *
NN   F*U 1430000314 110107 913 MOP CHANGED AFTER SHIPPED BY WMS                *
NP   F*E 8000010195 113007 920 SERIAL NUMBER IMPROVEMENTS                      *
NQ   F*U 8000010235 120407 078 Work order costing                              *
NR   F*U 1430000364 122007 078 Maintenance of fab items and w/o                *
NS   F*U 1610000420 122407 914 DISAPPEARING COMBINATION ITEMS                  *
NT   F*U 1610000748 122607 913 MATERIAL HANDLING FLAG NOT CORRECT              *
NU   F*U 0050004137 010208 002 O/C taxable follows header flag.                *
NV   F*U 8000010280 010308 920 COMBINATION ITEM ERROR IN O/E MAINT             *
NW   F*U 1380000199 013108 915 NO TAX RECORD CREATED FOR ORDERS                *
NZ   F*U 1380000191 021108 915 NO TAX RECORD CREATED FOR ORDERS                *
NX   F*U 0420000938 020708 914 CROSS COMPANY ORDER NOT GOING TO WM             *
N0   F*U 1610000757 021608 915 COMPONENT PRICE NOT CORRECT IN O/E              *
N1   F*E 8000010256 021908 019 Weighted Average Freight                        *
N2   F*U 8000010304 021908 078 F11 should use order # not job #                *
N4   F*E 8000010307 031808 913 INCREASE PRICE IN O/E FOR REL 12.0              *
N5   F*U 0970000299 032508 914 NEGATIVE REMAINING BALANCE DEPOSIT              *
OA   F*E 8000010162 041408 914 MINCRONIZE RGA FOR NEXT RELEASE                 *
OD   F*E 8000010199 050208 020 Messaging                                       *
OE   F*E 8000010203 051308 020 CUSTOMER RELATIONSHIP MANAGEMENT I              *
OF   F*E 8000010234 050708 913 SET UP AN ITEM AS NON-INVENTORY ITM             *
OG   F*E 8000010242 052608 920 BRANCH SECURITY - ORDER MAINTENANCE             *
OH   F*E 8000010408 060308 913 EDIT TOTALS IN OE SYSTEM FOR OVRFLW             *
OI   F*E 8000010425 071708 171 CUSTOMER RETURN ENTRY ADD'N CHANGES             *
OJ   F*E 8000010431 072508 920 SERIAL NUMBER EDITING                           *
OK   F*U 0420000910 080108 920 CHANGING SHIP BR ON TAGGED ORDER                *
OM   F*E 8000010472 073008 913 CUSTOMER RETURN CHANGES                         *
ON   F*E 8000010496 080608 913 ADD F14=EXT DESC TO RGA ENTRY                   *
OO   F*E 8000010505 081108 913 RGA ENTRY CORRECTIONS                           *
OP   F*U 8000010527 081808 001 BRANCH SECURITY - ADD SHIP BRANCH               *
OQ   F*E 8000010494 081908 907 ADD LOT TRACKING TO RGA ENTRY                   *
OR   F*E 8000010510 082008 913 SERIAL # SEARCH IN RGA ENTRY                    *
OS   F*E 8000010532 082208 915 AUTH TO CRT OPEN CREDIT MEMO ISSUE              *
OT   F*E 8000010544 082608 127 BRN SECURITY ALLOW TO MAINT IF TIDS     ell     *
OU   F*E 8000010548 090408 907 HAZMAZ WARNING MESSAGE IN RGA                   *
OW   F*E 8000010541 091008 913 PRICE CREDIT IN RGA ENTRY                       *
OW   F*E                       RGA related corrections
OY   F*U 1430000404 091608 913 ACKNOWLEDGE FLAG REL FROM CR HOLD               *
OZ   F*E 8000010541 091708 915 PRICE CREDIT IN RGA                             *
OZ   F*E                       Credit memo maintenance corrections             *
O3   F*U 1430000407 101508 907 INTELLCHIEF CHANGES                             *
O4   F*E 8000010610 102808 915 PRICE CREDIT ON RETURNS FOR COMBO               *
O5   F*U 0050004142 110408 913 UNABLE TO CHG ORDERED BY ON REL ORD             *
PA   F*U 0100005074 110408 915 ALLOW CHANGE TO CASH INV IN MAINT               *
PB   F*U 8000010626 110408 907 OTH CHRG DSP IN ERROR IN ORD MAINT              *
PC   F*U 1350000391 120208 915 REQUIRED ASSOC ITEMS FOR COMPONENTS             *
PD   F*U 0100005144 012009 127 DECIMAL DATA ERROR SUB ON COMPONENT             *
PE   F*E 8000010325 012209 020 Weighted Average Rebates                        *
PF   F*U 0100005122 012909 127 CO/BR IN WALKIN FILE NOT UPDATED                *
PG   F*U 0100005095 020309 127 PI CONTROL NUMBER LOST W/ ITEM NUMB             *
PJ   F*U 0100005055 022509 248 ORDER MAINT PRICING CURSOR POSITION             *
PK   F*U 1550000271 041009 001 Do not allow quotes to go on credit hold        *
PL   F*U 8000010720 072009 171 REDUCED PRICE NOT APPLIED FOR RGA C/M           *
PM   F*U 1550000279 091509 001 Put order on credit hold if over limit          *
PN   F*E 8000010756 091709 171 Reason code change do not rst prc/cost          *
PO   F*U 8000010782 102209 001 Correct feet/inches from being protected        *
PP   F*U 1430000434 102709 001 Correct credit memo affect inv flag             *
PQ   F*U 0100005265 120909 001 Allow MOP change if from C/O if authorized      *
PR   F*U 1220001286 120909 094 F9 protect in order review              ed      *
PS   F*U 1330000208 121409 001 Correct feet/inches error                       *
PT   F*U 1090000417 121809 001 Correct issue with adding items to CM           *
PU   F*U 0430000280 122909 001 Correct taxable flag for non inv items          *
PV   F*U 0100005300 123109 070 Can change order status without authority       *
PW   F*U 1220001293 012110 094 OVERRIDE QTY CONSISTANCY IN OE                  *
PX   F*U 1220001356 051410 144 LOSING GENERATE PO FLAG IN OE/OM                *
PY   F*U 1550000305 061510 001 Put order on credit hold if over limit          *
PZ   F*U 1090000437 070710 248 RGA CREDIT QUANTITY IN MAINTENANCE              *
P0   F*E 9000001516 101110 200 Remove format OEF2063L                          *
P2   F*U 1620000111 011811 183 CREDIT HOLD IN ORD MAINT HANGS UP               *
P4   F*U 1220001414 042412 001 PENDING S/O ON PRICING HOLD ISSUE               *
QA   F*U 1550000300 040111 271 TAX JURIS RE-DEFAULTING ORDER MAINT             *
QB   F*U 8000010995 040111 001 CHECKBOX NOT DISPLAYING                         *
QC   F*U 1550000323 040411 271 PREVENT CHG OF REF# ON RGA CRED MEMO            *
QD   F*U 0970000358 040411 248 LOSE QTY'S OF COMBO IN ORDER REVIEW             *
QE   F*U 0970000359 061411 001 Combo maintenance correction                    *
QF   F*U 1650000420 042911 097 order maintenance duplicating serial #s         *
QG   F*U 1330000216 050911 002 Prevent Occur out of range error                *
QH   F*U 0100005301 072611 915 NOT GETTING NEG QTY MSG IN MAINT                *
QI   F*U 1220001426 072811 915 BATCH DATE/# REMOVAL ISSUE                      *
QJ   F*U 1220001435 080411 144 OE SHIPPING TRACKING # ISSUES                   *
QK   F*U 0420001084 092111 001 Prevent change from Resv to Pend if Tagged      *
QL   F*U 1550000252 092111 001 Unable to Review Over Credit Limit Direct       *
QM   F*U 1380000225 110711 001 Correct non tax item, calculating tax           *
QN   F*E 8000010981 111111 070 WEB CASH SALE ORDER PROCESSING - HD             *
QO   F*U 1380000236 112911 915 SHOW NEG QTY ON SERIAL # ENTRY                  *
QP   F*U 8000008941 011012 915 ERR MSG FOR SHIP CODE NOT CLEAR                 *
QQ   F*E 8000011235 020312 915 SEND SHIPMENT CONF NOTICE- WEB ORD              *
QS   F*U 0420001157 041312 078 B/O status code for work orders                 *
QU   F*U 0970000413 042612 001 Ship branch tax jurisdiction for pickup         *
QV   F*U 0970000415 051512 915 SALES ID NOT PROTECTED BID RELEASE              *
QW   F*U 0420001182 060112 923 INCORRECT W/O ACCESSED FROM S/O                 *
QX   F*U 1090000484 061212 915 PROTECT N/C FLAG ON RGA CREDIT                  *
QY   F*U 0970000436 070412 915 ZERO SHIP QTY KEEPS SERIAL ASSIGNED             *
QZ   F*E 8000011182 080212 070 B2B/B2C TAX API INTERFACE                       *
Q0   F*U 8000011372 082112 070 B2B SHIP NOTICE EMAILING CORRECTN'S             *
Q1   F*E 8000010983 100312 070 B2C/B2B CREDIT CARD INTERFACE                   *
Q2   F*U 0970000489 112412 915 MAINTAINING PENDING CREDIT ORDER                *
Q3   F*U 1090000490 011513 915 RGA QTY EXEEDS QTY AVAIL MSG                    *
Q4   F*U 0430000251 020713 915 Tax flag for other charges                      *
Q5   F*U 0970000502 022113 915 S/O WITH BID # NOT RELATED TO ORDER             *
RA   F*E 8000011205 030113 915 INSERT LINES IN ORDER MAINTENANCE               *
RB   F*E 8000011288 030513 915 Restrict ability to override prices             *
RC   F*E 8000011216 030813 915 User enrolment for tax flag in OE               *
RD   F*E 8000011233 032813 248 MAKE DNR MATERIAL MORE VISIBLE                  *
RE   F*U 0970000509 042613 119 RESV ORD ALLOW GEN PO CUST CR HOLD              *
RF   F*E 8000011202 060513 915 EMAIL BIDS AND S/O TO MULT ADDRRESS             *
RG   F*E 8000011221 061413 070 ADD 120 DAY A/R AGING BUCKET                    *
RJ   F*U 8000011572 092513 915 F14 ERROR ON ORDER PRICING SCREEN               *
RK   F*U 8000011468 101013 200 Add more info to SmartDistributor prompter      *
RL   F*U 0420001358 100213 915 WORK ORDER CREATED FOR WRONG BRANCH             *
RM   F*U 0420001363 111313 915 Auth to work order thru OE/MAINT                *
RP   F*U 0930000319 040114 915 Can chg order qty when RGA exists               *
RO   F*E 8000011586 032014 915 INTELLICHIEF LICENSE KEY CHECK                  *
RS   F*U 1090000533 052814 915 Two users in credit hold release                *
RU   F*U 8000011744 053014 019 Branch Number Zero in WKPWREQ                   *
RV   F*U 1810000125 061214 915 Order maintenance in loop                       *
RW   F*E 8000011768 062614 915 B2B (HD) LICENSE KEY CHECK                      *
RX   F*E 8000011771 062614 915 B2C (HD) LICENSE KEY CHECK                      *
RY   F*U 1800000162 080814 915 SO NOT ON CREDIT HOLD/REL QUOTE                 *
RZ   F*E 8000011209 093014 915 Credit card processing                          *
R0   F*U 8000011848 102714 001 SO fab items not updated with WO information   *
R3   F*U 0920000214 102714 019 Correct Repetative DNR Message Issue            *
R4   F*U 1550000395 010515 171 B2B/B2C loading negative amount on RGA C/M     *
SB   F*U 8000011891 020315 275 Add Multiselect capability from SmartDistributor*
SC   F*U 0970000609 022415 923 IMPORT STD PACK TO RGA CREDIT MEMO              *
SD   F*U 0970000586 022515 923 Do not allow gen PO Cust CR hold                *
SE   F*U 8000011932 031715 915 Curbstone card process changes #1               *
SF   F*U 0970000604 031715 923 TAX JURISDICATION POP UP                        *
SH   F*U 1810000150 031715 923 OEPTTA TAX AUTH DETAIL DUPLICATES               *
SI   F*U 8000011933 032015 915 RGA CREDIT MEMO ADDITIONAL CNTLS                *
SJ   F*U 8000011933 040815 915 RGA CREDIT MEMO ADDITIONAL CNTLS                *
SL   F*U 8000011967 041415 915 HANDLING OF OLD CREDIT CARD TXN                 *
SM   F*U 8000011974 042015 915 Credit card process for Gen Order               *
SN   F*U 0100005606 012915 923 Prevent changing to rsv if shipped in wm        *
SO   F*U 0970000617 052615 915 Stop auth return req. for price                 *
SP   F*E 8000011777 061215 915 B2C (API) LICENSE KEY CHECK                     *
SQ   F*E 8000011582 062415 275 Require ship code if a sigsmart br              *
SR   F*U 0970000626 070115 915 MAINTAINING RGA GEN CM WITH CLSD                *
SS   F*U 1620000108 070915 915 FAX ERROR PUTTING ORDER ON CR HOLD              *
ST   F*U 0970000632 080715 915 RGA KIT COMPONENT PRICING ERROR                 *
SV   F*U 0420001179 081415 915 RGA AND PRICING UOM ISSUE                       *
SW   F*U 8000012113 090315 915 RGA PRICE CREDIT WITH PRICE UOM CHG             *
SX   F*U 1800000185 091515 915 NO METHOD OF PAYMENT ON MANUAL RGA              *
SY   F*U 8000012135 092815 915 CORRECT RGA PROCESSING OF CURBSTONE             *
SZ   F*E 8000012183 102815 001 Add logic for new event HDE0020                 *
S0   F*E 1290000353 121415 248 WAR V3 SPECIAL BUY                              *
S5   F*U 0100005901 072016 923 SHIP TO ADD NOT UPD WHEN BR CHANGE              *
TA   F*U 0100005948 092916 007 IMMED INVOICES NOT SENDING TO WM                *
TB   F*U 8000012453 100516 070 WAR V3 COMBINED COST INCORRECT                  *
TC   F*E 8000012436 110316 915 Curbstone C2 to C3 conversion                   *
TF   F*U 1200000181 041117 915 Taxable field def to N when blanks              *
TG   F*U 1550000489 050517 915 CURSTONE DEPOSIT ISSUE                          *
TH   F*U 0350001618 051017 119 Job # chg not updating terms                    *
TJ   F*U 0420001342 070517 020 Transaction not removed from wm                 *
TL   F*U 1110000640 072117 144 DIRECT OTHER CHARGE TAXABLE FLAG                *
TM   F*U 1430000572 072417 144 SHIP TO ADDRESS NOT CHANGED                     *
TN   F*U 8000012733 111017 144 EVENT NOTIFICATION, CR HOLD RELEASE             *
TI   F*E 8000012610 051817 915 Avalara AvaTax interface                        *
TP   F*E 8000012729 122017 404 Minimize AVATAX API calls                       *
TQ   F*E 8000012747 013018 915 AVATAX PARM CHANGES - TAX OVERRIDE              *
TR   F*E 8000012813 030318 915 CHG/CORRCT'N TO AVATAX INTIGRATION              *
TT   F*E 8000012817 031618 915 AvaTax - Taxable flag handling                  *
TU   F*E 8000012865 040218 915 Avatax Corrections #1                           *
TV   F*E 8000012868 040418 915 AvaTax cash sales inv handling chg              *
TW   F*E 8000012917 052419 915 All orders maint after edit list                *
TX   F*E 8000012949 070518 915 Ord maint val addr for Avatax early             *
TY   F*U 0970000761 071318 001 Rsvd/Pending orders on Hold changes             *
TZ   F*U 0520000497 072618 001 Cash order phone/name changing                  *
T0   F*U 0970000783 072718 001 Update contract to open or released             *
T1   F*E 8000012680 080818 915 AvaTax interface for C/O                        *
T2   F*E 8000012826 091718 915 Streamling TAXO table functionality             *
T4   F*E 8000013106 102318 282 APACHE FORMS - JOBQ QFORMS                      *
T5   F*U 0910000509 121418 915 Non-inv items on direct orders                  *
UA   F*E 1290000646 021319 007 CUSTOMER INCENTIVES PHASE 2 PART 2              *
UB   F*E 8000013254 030419 404 N/S ITEMS NONTAX IN AVATAX OE/BID/CO            *
UD   F*U 1230001025 040819 001 Cannot change sales id on order                 *
UE   F*U 1290000655 041019 070 CI PHASE 2 BETA CHANGES 1                       *
UG   F*E 8000013122 050319 915 Card Connect - Credit card process              *
UI   F*U 8000013359 092519 915 Avatax internet down issue                      *
UJ   F*E 1710000932 121219 404 Manager Approve Price Overrides                 *
UK   F*C 0930000549 011820 169 MAKE ORD BY REQ IN OE FROM                      *
UL   F*U 8000013572 012120 915 AVATAX DOWN - CASH INV TO TCK ISSUE             *
UM   F*E 1820000118 012420 404 ADD USER ENROLLMENT TO EDIT BO QTY              *
UN   F*E 1710000970 012820 404 ADD REPRINT OPTION IN ORDER CHG                 *
UO   F*C 0820000454 031020 404 Cost from PO for Direct from Bid                *
UP   F*U 8000013695 041620 171 AVATAX DOWN - Load Def Tax Juris for TAXDOWN=Z  *
UQ   F*C 1510000263 011020 169 ASSIGN PRINTER BY SHIP CODE                     *
UR   F*U 8000013709 050120 171 Change tax fields loading for better fee        *
US   F*U 1710001009 051120 404 BR CHANGE ON SELECT DEPOSIT                     *
UT   F*C 1430000659 121619 097 Make Ordered By Mandatory in OE by branch       *
UU   F*U 8000013726 052720 171 RGA C/M with different CardConnect MID          *
UV   F*U 1890000169 061920 404 N/S cost not including landed                   *
UW   F*E 1400000412 050620 171 Card on file for CardConnect                    *
UX   F*C 1710000968 070720 097 position cursor next line when new item added   *
UY   F*E 8000013755 070820 097 move all OER2063 subroutines to OEY2063         *
U2   F*E 1400000428 101520 169 GL POSTING FOR NON-INV ITEMS                    *
U3   F*E 0930000605 030421 404 TRACK LINES TAKEN OFF SL IN MAINT               *
U4   F*E 1400000413 041321 171 PARTIAL REFUND FOR RGA ON SAME DAY              *
U5   F*E 8000013940 050321 171 Prompts for Card not present                    *
VA   F*U 1380000363 052121 097 freight not included in totals                  *
VB   F*E 1400000472 072821 171 Serial number expansion                         *
VD   F*E 1290000727 100121 171 Worldpay - Credit card processing               *
VE   F*E 1710001105 102021 404 Enhanced Lost Sales Tracking Ph 4               *
VG   F*E 8000013189 011122 035 Correct Spelling of Jurisdicton in EMS(54)      *
VI   F*E 8000014036 022322 171 Worldpay - changes for certification            *
VJ   F*E 0420001503 041322 404 OPTION TO REPRICE RECOST SALES ORDER            *
VL   F*E 1650000657 042622 275 Fix mulit select in SD-One for pricing sfl      *
VL   F*E                       and rework.                                     *
VM   F*E 8000014081 061522 171 Colorado Retail Delivery Fee changes            *
VN   F*E 8000014082 062022 404 Non Returnable Item                             *
VO   F*E 1400000490 071122 404 Customer Specific Credit Limits                 *
VP   F*E 1710001144 072022 404 Capture Customer Jobsite Address                *
VQ   F*E 1710001146 072621 404 Deposit popup window notification               *
VR   F*E 1400000502 092022 171 INCREASE DEVICE SERIAL# LENGTH                  *
VT   F*U 1710001189 030223 404 Missing Ship Qty on Line Item                   *
VU   F*E 1400000500 020823 171 Credit Card Processing Fee                      *
VX   F*U 8000014173 051623 171 Wrong CC screen for voiding pending CC record   *
V4   F*E 1290000791 092623 171 Worldpay - eCommerce orders                      *
V5   F*U 8000014138 121423 321 CARD - EDIT CARD DEVICE BY DEV TYPE             *
WA   F*C 1400000537 013024 321 STORE GEOCOORDINATES CUST BR ADDRES             *
WB   F*U 8000014296 040524 404 Lost Sales Order Maintenance Fix                *
¢A   F*U JPF   XXXX 040500 RRB Fuel Surcharge                                  *
¢B   F*E KSB   1607        KSB REQ RA# ONLY IF GMC/AMN ITM AND VR = Y          *
¢C   F*E KSB   1910        KSB WRITE AUDIT RCD IF REL FRM CRD HLD              *
¢D   F*E KSB   1915        KSB DISALLOW F11 IN REVIEW MODE FOR CHARGE ORDERS   *
¢E   F*E KSB   1360 091803 KSB DISALLOW BO FOR DNR ITEM                        *
¢G   F*E KSB        091803 KSB DISALLOW USR CHG QTY FOR TAGGED NON STKS        *
¢H   F*E KSB   2925 101504 KSB SEND EMAIL IF ORD ON CRD HOLD                   *
¢J   F*E KSB   3011 102604 KSB DISALLOW OLD ITEM# TO BE USED                   *
¢K   F*E KSB   4546 062305 KSB TOTAL INCORRECT FOR FUEL SURCHARGE              *
¢M   F*E KSB   4618 093005 KSB ADDITIONAL CREDIT CHECKING                      *
¢N   F*E KSB   4713 011106 KSB CUST W/PAY RATE = 3 NO CREDIT HOLDS             *
¢O   F*C 0430000239 012806 094 C.O.D. MOD                                      *
¢P   F*C ksb   4856 081806 ksb validate ship to state                          *
¢S   F*C ksb   4858 082106 ksb restrict our truck ship to certain state        *
¢T   F*C ksb   4861 082306 ksb Validate ship to address for UPS shipmen        *
¢V   F*C ksb   5005 050707 ksb REQUIRE RA# FOR HEAT KITS                       *
¢W   F*C ksb   5024 051407 ksb chg default gp% display                         *
¢X   F*C ksb   5038 061507 ksb allow override for b/o fills                    *
¢Y   F*C ksb   5028 080807 ksb check gmc/amn warranty item                     *
¢O   F*C ksb   5098 101907 ksb c.o.d.mod                                       *
¢Z   F*C ksb   5144 011708 ksb warranty changes                                *
¢A1  F*U KSB   5131 013008 KSB Add flag to turn on/off addr validation         *
¢A5  F*U KSB   5287 010509 KSB always write prod# if item# entered             *
$A   F*C DCB   5345 042409 DCB GMC INFO FINDER INTERFACE                       *
$C   F*C RELEASE 12 072409 DCB plug oecd17 & oecd19 if blank                   *
$E   F*C RELEASE 12 091509 DCB F9 PROTECT/UNPROTECT NOT WORKING                *
$F   F*C RELEASE 12 091609 DCB ALLOW DUPLICATE RA#                             *
$G   F*C RELEASE 12 091609 KSB remove mod MX (pending loop)                    *
$N   F*C       5657 062411 DCB GMC RGA NUMBER SIZE CHANGE TO 8 DIGITS          *
$O   F*C       5580 062911 DCB DISCOUNT SOURCE CODE                            *
$Q   F*C DCB   5746 050712 DCB Capture price before price override             *
$R   F*C DCB   5646 053112 DCB CASH TICKET MODIFICATION                        *
$S   F*C DCB   5797 053112 DCB Disc src code change for uom                    *
$T   F*C DCB   5646 062912 DCB CASH TICKET MODIFICATION                        *
¢v   F*C ksb   5894 030713 ksb Amana cost calc based on price                  *
¢w   F*C ksb   5900 032113 ksb Don't override cost if Price Credit Aman        *
¢x   F*C ala   6147 051313 ala Allow MD as valid state for our truck           *
$w   F*C ksb   5912 052113 ksb prevent F9 Hold order from working              *
$X   F*C DCB   5914 060613 DCB ADD BAKER ITEM SEARCH INQUIRY                   *
$Y   F*C DCB   5924 070313 DCB CASH TICKET MODIFICATION                        *
$Z   F*C ALA   6139 010814 ALA CHANGE SMALL DOLLAR AUTO RELEASE THRESHOLD      *
$1   F*C DCB   7006 051314 DCB ADD HOLD EDIT TO ORDER REVIEW                   *
$2   F*C DCB   7008 060414 DCB DO NOT ALLOW SLASH ITEMS                        *
$4   F*C DCB   7011 070114 DCB CORRECT FREIGHT REQUIRED EDIT                   *
$5   F*C DCB   7018 090414 DCB ALWAYS USE PRODUCT NUMBER                       *
¢6   F*C CLP   6260 092514 CLP When an order is released from credit hold,     *
¢6   F*C                       send an email to the person who entered it      *
¢(   F*C DCB   7024 081914 AIP B2B                                             *
¢:   F*C DCB   7024 081914 AIP B2B - Tax Re-Calculation                        *
$7   F*C CLP   7043 031215 CLP ADD branch to OEREXTI3 call                     *
$8   F*C DCB   7055 042415 DCB CANNOT CHANGE ENT BY ID IF WEB ORDER            *
$9   F*C DCB   7076 070115 DCB EXCLUDE CREDIT FROM FRT EDIT                    *
%A   F*C DCB   7086 082415 DCB EDIT CASH INFO FOR WEB ORDER                    *
%A   F*C DCB   7086 082415 DCB USE DEPOSIT AMOUNT FIRST                        *
%B   F*C CLP   6037 083115 CLP IF FAXTKT='Y' ASSUME 'E' FOR EMAIL              *
%C   F*C DCB   7114 042016 DCB CANNOT ENTER DIRECT SERIAL NUMBERS              *
%D   F*C CLP   6491 060316 CLP Updated RA validation logic to allow for length *
%D   F*C                       of 9 starting with character                    *
%F   F*C KSB   9006 083016 ksb allow freight warranty delivery fee             *
%G   F*C CLP   6488 052416 CLP Initial Order Fulfillment implementation        *
%J   F*C CLP   6535 093016 CLP When defaulting shipto address use branch       *
%J   F*C                       addr for pickup orders rather than customer     *
%J   F*C                       shipping addr                                   *
%K   F*C CLP   6552 110316 CLP Allow tax recalculation on B2B orders if a      *
%K   F*C                       not a cc order                                  *
%L   F*C CLP   6556 121916 CLP Issue the pick ticket print request after       *
%L   F*C                       everything else is completed in order to        *
%L   F*C                       avoid duplicating serial nbrs present before    *
%L   F*C                       the order maintenance and missing serial nbrs   *
%L   F*C                       entered on the counter pick screens             *
%M   F*C CLP   6594 051017 CLP Allow F11=Serial Nbr Override for cash          *
%M   F*C                       transactions                                    *
%N   F*C                   KSB Lock down item/qty changes if order is in       *
%N   F*C                       the process of being picked in OF               *
%O   F*C APB   9024 061917 APB Add GMC Vend# to OER9990 parms                  *
%P   F*C DCB   7133 070517 DCB ADD EDIT FOR CORRECT CREDIT CARD AMOUNT         *
%Q   F*C CLP   6633 080317 CLP -Release CC transactions from pending status    *
%Q   F*C                        before offering serial nbr maintenance         *
%S   F*C CLP   9022 082817 CLP Recognize new non-inventory item, 322505,       *
%S   F*C                       for warranty fees                               *
%T   F*C CLP   9025 090117 CLP Allow positive qtys on a RGA credit memo,       *
%U   F*C DCB   7142 091217 DCB MOVE SERIAL NUMBER ENTRY                        *
%W   F*C APB   9036 120517 APB Warranty Claim Entry                            *
%X   F*C APB   9036 121917 APB Compare only shipped qty to return qty          *
%Y   F*C APB   9044 010218 APB Fix tax bug on cash screen                      *
%Y   F*C                       Do not go through warranty if RGA               *
%Z   F*C APB   9046 010318 APB Fix gross profit condition                      *
:A   A*C APB   9052 022118 APB Add printer control for express pickup          *
:B   A*C APB   9042 011018 APB Add Unit Exchange to Warranty                   *
:C   A*C APB   9054 030918 APB Add Order# to oeptwch and oeptwcd               *
:D   F*C APB   9059 032718 APB Remove program OER9431                          *
:E   F*C APB   9060 032718 APB Add error file to capture when order#           *
:E   F*C                       is not being updated in oepgwcd, oeptwcd        *
:E   F*C                       Update oeptwcd, oepgwcd & oepcgwcd with         *
:E   F*C                       CM & Line Seq#                                  *
:F   F*C APB   9060 041318 APB Correct missing order# in claim files           *
:G   F*C RELEASE122        APB Open ARLTCCT1 when cash ticket                  *
:H   F*C CLP        061918 CLP Add error msg for invalid salesman ID           *
:K   F*C CLP   6734 082918 APB -Capture Physical Count Control# field          *
:L   F*C APB   9073 091218 APB Validate the order type before accessing        *
:L   F*C                       warranty                                        *
     F*C CLP   6742 092118 CLP Updated for SOX documentation                   *
:M   F*C APB   9077 100518 APB -Modify the missing ivno14 trap                 *
:O   F*C CLP   6789 040119 CLP Added B2B initials to WKSTS lookup so that each *
:O   F*C                       B2B order type can have a different status path *
:P   F*C APB   9100 071119 APB Orders in MO & TN for Ingrams are taxable       *
:P   F*C                       Orders in MO for Motili are taxable             *
:Q   F*C APB   9102 062619 APB Protect Status if CM is tied to claim           *
:Q   F*C                       that is not approved                            *
:R   F*C DCB   7200 080519 DCB ADD EDIT FOR CLOSED BRANCH, SELL & SHIP         *
:T   F*C APB   9093 062619 APB Modify for Warranty Express Claims              *
:U   F*C CLP   6841 092619 CLP If taxation variables change on a CC web order, *
:U   F*C                       recalculate sales tax                           *
:V   F*E 0430000299 082219 097 comment out move to CALLED_FROM                 *
:W   F*C APB   9104 101519 APB Modify for Cube E Mincron upgrade               *
:X   F*C DCB   7204 110619 DCB Look up and load other charge description       *
:Y   F*C APB   9108 111219 APB Disallow reason codes 'P', 'C' & 'I' for CM's   *
:Z   F*C DCB   7213 012720 DCB Do not allow zero price, use no charge          *
#0   F*C APB   9125 012020 APB If HIller & job WARR make item a no charge      *
#1   F*C APB   9126 020520 APB Increase Tag# to 10 in length                   *
#2   F*C DCB   7224 022720 DCB PUT BACK MOD TO ALWAYS WRITE OEPTOA             *
#3   F*C CLP   6884 030620 CLP Removed sales tax override for Ingrams TN       *
#4   F*C APB   9141 051520 APB Do not remove NC flag if Hiller RGA             *
#5   F*C APB   9141 051420 APB Logic for RGA returns over nonAvatax orders     *
#6   F*C APB   9144 060120 APB Disallow pricing on RGA credits                 *
#7   F*C APB   9158 080320 APB Validate ship to state is not blank             *
#8   F*C APB   9157 072920 APB Remove tax customization for Ingram's           *
#8   F*C CLP        080620 CLP Remove tax customization for CS Sloan           *
#9   F*C DCB   7225 060120 DCB ADD PROMO DATES FOR COUPON POST GROUP           *
#A   F*C APB   6920 091420 APB Issue an error if F7=Create Sales Deposit is    *
#A   F*C                       selected for a web cc refund that is within 120 *
#A   F*C                       days of the original cc transaction to avoid    *
#A   F*C                       creating a sales deposit and issuing a refund   *
#A   F*C                       through authorize.net.                          *
#B   F*C APB   6920 092220 APB Allow field ops to open pending orders          *
#C   F*C APB   9178 111020 APB -Skip cc total validation if card connect       *
#C   F*C                       -If web order and authorize.net turn off        *
#C   F*C                        card connect                                   *
#D   F*C APB   9195 011821 APB -If CardConnect display values available for    *
#D   F*C                        Card on File                                   *
#E   F*C DCB   7260 020921 DCB -ADD OE DEFAULTS FOR SUMMARY SCREEN             *
#F   F*C                       -Get GMC Tag                                    *
#G   F*C APB   9205 030521 APB Allow cardconnect to take balance after WEB     *
#G   F*C                       payment is taken.                               *
#H   F*C DCB   7264 022521 DCB ADD OE DEFAULTS FOR CREDIT RELEASE              *
#I   F*C APB   9208 031721 APB -Remove expired credit cards from card on file  *
#I   F*C                       -Do not allow card to be saved for walk-ins     *
#I   F*C                       -Display card Connect screen on authorize.net   *
#I   F*C                        Web orders needing second form of payment.     *
#J   F*C                       -Remove WMICHALOVE from opening pending tickets *
#K   F*C DCB   7267 032421 DCB ADD MOS TO TABLE CM11                           *
#L   F*C DCB   7269 041021 DCB ADD OT OE DEFAULT                               *
#L   F*C                   CLP Added call to OER2024 to sequence items for     *
#L   F*C                       picking before calling FULR002 for orders that  *
#L   F*C                       are not going to be printed                     *
#M   F*C APB   9217 042621 APB Exclude Quotes from OT Defaults                 *
#N   F*C DCB   7270 051321 DCB FIX ISSUE WITH GEN PO AND OVER CREDIT LIMIT     *
#O   F*C DCB   7271 051921 DCB KEEP SELL BR IF CREDIT & ORIG USED CARD CONNECT *
#P   F*C APB   9223 051821 APB Added WC to OE defaults                         *
#Q   F*V APB   9224 060421 APB Added new parm to oerc027 to determine if date  *
#Q   F*V                       logic is to be used                             *
#Q   F*V                       Print ticket if date logic is used to open up   *
#Q   F*V                       serialized orders.                              *
#Q   F*V                       Do not reprint pick tickets.                    *
#R   F*V APB   9228 062821 APB Update ship code before sending it to OERC027   *
#S   F*C DCB   7279 072321 DCB CHANGE TERMS DISCOUNT CALC - USE ORDER TOTAL    *
#T   F*V APB   9250 072221 APB Allow SPELLETIER to open up pending tickets     *
#U   F*V APB   9251 081621 APB Do not allow a cash ticket to be changed to chg *
#V   F*C APB   9252 092421 APB Prevent XP and AC tickets from going on reserve *
#W   F*C APB   9258 110821 APB Prevent releasing of tickets if claim is not    *
#W   F*C                       approved.                                       *
#X   F*V APB   9261 112921 APB Authorize SSPENCER to open pending tickets      *
#Y   F*C DCB   7295 111921 DCB DO NOT ALLOW UPDATE IF PICKING IN PROGRESS      *
#Y   F*C DCB   7295 120921 DCB DO NOT ALLOW ZERO DATE ORDERED                  *
#Z   F*C DCB   7300 011022 DCB BRING BACK QUANTITY FROM COLON SEARCH           *
&A   F*C DCB   7303 012422 DCB SHOW ORIG PMT TYPE ON CASH SCREEN REVIEW RGA    *
&B   F*C APB   9274 031522 APB Allow the generation of a PO if ticket is       *
&B   F*C                       released from credit hold                       *
&B   F*C                       WUE claims must originate through RGA           *
&C   F*C DCB   7317 041422 DCB ADD PRICE OVERRIDE TRACKING                     *
&C   F*C DCB   7317 041422 DCB ADD EDIT PROMISED DATE CANNOT BE LT ORDERED DATE*
&D   F*C APB   9278 042822 APB Fix looping issue when quote turns to credit hld*
&D   F*C                       Protect warranty lines if claim exists and not  *
&D   F*C                       derived from RGA                                *
&E   F*C APB   9281 051722 APB Allow PO to be generated if customer payment    *
&E   F*C                       rank code (ARCD08) is not blank for the customer*
&F   F*C APB   9286 060322 APB If reserve or quote order changes to warranty CM*
&F   F*C                       and status open show OED2063G summary screen    *
&F   F*C                       instead of OED2063H to force a claim to be      *
&F   F*C                       created                                         *
&G   F*C APB   9288 071222 APB Allow credit dept to change paytype             *
&H   F*C DCB   7333 092122 DCB DEPOSIT FRAUD ALERT                             *
&I   F*C APB   9301 092922 APB Disallow if negative qty inventory item with    *
&I   F*C                       affect inventory = 'Y'                          *
&I   F*C                   APB Lock Cash orders if charge ticket changed to    *
&I   F*C                       cash and in process of being picked by OF       *
&J   F*C APB   9309 102522 APB Ignore NonReturn items if affect inventory = 'N'*
&J   F*C                       or is a Missouri branch                         *
&K   F*C APB   9314 120122 APB -Don't allow deposit if walk-in                 *
&L   F*C                       -Allow multiple payments with RGA Warranty CM   *
&L   F*C                        when original invoice is over a year old       *
&L   F*C                        Don't allow deposit if walk-in                 *
&M   F*C APB   9323 011723 APB Correct web credit card CM's from using the old *
&M   F*C                       credit card screen.                             *
&N   F*C APB   9325 020123 APB Selling branch cannot be a hub                  *
&O   F*C VLG   2031 012723 VLG Allow Users with sec to override pending cm's   *
     F*M ----------------------------------------------------------------------*
*a   F*CGEMAIRE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
*a   F*C APB   9265 022123 AP20210208 AIP [3AF-27C7DE38-0014] CardConnect      *
!¢4  F*C APB   9265 022123 AP20220399 20220414 AIP -[278-29CDF5D9-0041] Process*
!¢4  F*C                   ecommerce Authorization without deposit             *
*a   F*CGEMAIRE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
&P   F*C VLG   2068 012924 VLG Allow Users with authority to change sales      *
&P   F*C                       person ID (IT/RHORVATH)                         *
&Q   F*C DCB   7366 010824 DCB ADD COMPANY TO ORDER DEFAULTS                   *
&S   F*C APB   9369 022224 APB - Must change order to CM or DM if negative item*
&T   F*C DCB   9377 110923 DCB ARPMBAL AND MULTI COMPANY                       *
&U   F*C DCB   8185 031124 DCB ARPMBAL AND MULTI COMPANY                       *
&V   F*C APB   9394 061724 APB - Promo code cannot be used on negative dollar  *
&V   F*C                         ticket.  Default reason codes if promo exists *
&W   F*C APB   9407 092424 APB - Remove call to EDI 855 PO acknowledgements    *
&X   F*C APB   9373 101624 APB - Correct ship complete code                    *
&Y   F*C APB   9421 110524 APB - Delete ship complete code if ship code = AC   *
&Z   F*C APB   9426 111524 APB - Allow web cardconnect orders to be debit memos*
&1   F*C APB   9430 120924 APB - Do not send EDI ASN if no shipable items exist*
&2   F*C APB   9448 032125 APB Do not track serial numbers for Hydros          *
&3   F*C APB   9445 030425 APB PROTECT PAYMENT ON ACCOUNT                      *
&4   F*C APB   9472 072125 APB Allow DNR item to be ordered if found at another*
&4   F*C                       branch.                                         *
&5   F*C APB   9475 081325 APB - When pending order is open call E4REXTI3 to   *
&5   F*C                         send EDI 855 Order Acknowledgement            *
&6   F*C CP005173   032626 CLP -When calculating tax for shipments, only load  *
&6   F*C                        items that will be shipped                     *
&6   F*C                       -When calculating tax for backorders, only load *
&6   F*C                        items that have a backorder                    *
&6   F*C                       -Since Hydros is tax exempt, only call the tax  *
&6   F*C                        API if pushing an invoice/return document, or  *
&6   F*C                        maintaining an order in reviewed status, or    *
&6   F*C                        if going through the review process            *
&6   F*C                       -Since Hydros is tax exempt and credit limits   *
&6   F*C                        are not an issue, skip all tax calls for BOs   *
&7   F*C APB   9515 043026 APB - Pull in new customer terms from PCTERMS       *
&7   F*C                       - If B/O is closed allow promo to be used       *
&7   F*C                       - If salesman is not active use brnch house acct*
&8   F*C APB   9523 061126 APB - Promo codes need to be excluded when          *
&8   F*C                         determining if ticket should be DM or CM but  *
&8   F*C                         should not be the cause of a negative ticket  *
     F*M ----------------------------------------------------------------------*
     FOED2063   CF   E             WORKSTN
     F                                     INFDS(FIL1DS)
     F                                     SFILE(OES2063E:RRN)
     F                                     SFILE(OES2063F:RRN)
   MRF*                                    SFILE(OES2063I:RRN)
     F                                     SFILE(OES2063J:RRN)
     F                                     SFILE(OES2063N:RNN)
$8   FOELMEXTI3 IF   E           K DISK    PREFIX(EX_)
UQ   Foelmsbr1  if   e           k disk    prefix(d_)
OI   FARLMCUA4  if   e           k disk
     FARLMJBM1  IF   E           K DISK
     FARLMCUSJ  IF   E           K DISK
     FARLTWI1   UF   E           K DISK
   :RF*ARLMBCH4  IF   E           K DISK
:R   FARLMBCH2  IF   E           K DISK
     FARLMBALQ  IF   E           K DISK
     FARLMTRD3  IF   E           K DISK
     FARLMTXS1  IF   E           K DISK
     FARLMSLS4  IF   E           K DISK
     FIVLMCMP1  IF   E           K DISK
     FIVLMSBR1  UF   E           K DISK
     FIVLMSTRC  IF   E           K DISK
     F                                     RENAME(IVFMSTR:IVFPROD)
     FIVLMMFL1  IF   E           K DISK
     F                                     RENAME(IVFMSTR:IVFOUR)
     FIVLMPBT1  IF   E           K DISK    USROPN
   MRF*OELTSRY4  IF   E           K DISK
   MRF*                                    RENAME(OEFTSR:OEFTSR1)
   MRF*OELTSR2   IF   E           K DISK
   MRF*                                    RENAME(OEFTSR:OEFTSR2)
     FIVLTNSK5  UF A E           K DISK
MO   FIVLMNSB1  UF   E           K DISK    USROPN
     FOELTOM1   UF A E           K DISK
     FOELTOA1   UF A E           K DISK
     FOELTOC1   UF A E           K DISK
     FOELTOR1   UF A E           K DISK
     FOELTOH1   UF   E           K DISK
     FOELTOL7   UF A E           K DISK
OA   Foeltori1  if   e           k disk    prefix(f)
OA   Foeltori2  uf a e           k disk    prefix(g)
OA   F                                              rename(oeftori:ori2)
OA   Foeltpcc2  uf a e           k disk    prefix(g)
OA   Foeltpcc1  if   e           k disk    prefix(H)
OA   F                                     RENAME(OEFTPCC:PCC1)
OA   Foeltor2   if   e           k disk    prefix(r2)
OA   F                                     rename(oeftor:oeftor2)
OA   Foeltol9   if   e           k disk    prefix(e)
OA   F                                              rename(oeftol:oeftol9)
OA   Foeltolyy  if   e           k disk    prefix(e)
OA   F                                              rename(oeftoly:oeftolyy)
OA   Foeltol16  if a e           k disk
OA   F                                     prefix(z_)
OA   F                                     rename(oeftol:oeftolz)
OA   F                                     rename(oeftoly:oeftolyz)
OA   FOELTORY5  if   e           k disk    prefix(or5)
OA   F                                     rename(oeftor:oeftor5)
OA   F                                     rename(oeftory:oeftory5)
OA   Foeltoh67  UF   E           K DISK    prefix(h67)
OA   F                                     rename(oeftoh:oeftoh67)
OA   F                                     rename(oeftohy:oeftohy67)
OA   FPOLWVRD1  IF   E           K DISK
     FOELTOLYE  IF   E           K DISK
     F                                     RENAME(OEFTOL:OEFTOLE)
     FOELTOT1   UF A E           K DISK
     FTBLMTBL1  IF   E           K DISK
     FOPLMSEC1  IF   E           K DISK
     FOELTOH21  IF   E           K DISK
     F                                     RENAME(OEFTOH:OEFTOH21)
     FOELTOHZ2  IF   E           K DISK
     F                                     RENAME(OEFTOH:OEFTOHJ)
     F                                     RENAME(OEFTOHY:OEFTOHYJ)
     FPOLTOL4   IF   E           K DISK
     FAPLTINH1  IF   E           K DISK
     FOELTOAL4  UF   E           K DISK    USROPN
     FOELTOAH1  UF   E           K DISK    USROPN
QV   FOELTBH2   IF   E           K DISK    USROPN PREFIX(X)
     FOELTBAL1  IF   E           K DISK
     FARLMCAD1  IF   E           K DISK    USROPN
     FARLMCAD2  IF   E           K DISK    USROPN
     F                                     RENAME(ARFMCAD:ARFCAD2)
     FOELTDP1   UF   E           K DISK    USROPN
     FOELTDP4   IF   E           K DISK
     F                                     RENAME(OEFTDP:BYORD)
     FPOLTOL5   IF   E           K DISK
     F                                     RENAME(POFTOL:POFTOL5)
     FOELTLN1   UF A E           K DISK
     FOELTLD1   UF A E           K DISK    USROPN
     FOELTLLN2  UF A E           K DISK
     FOELTALL2  O    E           K DISK
     FOELTOLI   IF   E           K DISK
     F                                     RENAME(OEFTOL:TAGLNS)
     FPOLTOH1   IF   E           K DISK
     FIVLINOT1  IF   E           K DISK
¢C #NF*ARPAUDT   O    E           K DISK
#N   FARPAUDT   IF A E           K DISK
MP   Fwkpwreq   uf a e             disk    usropn
MP   f                                     infds(infdsWreq)
MP   fwkltoh1   if   e           k disk    infds(infdsToh1)
MP   f                                     usropn
MP   fwklTtag5  if   e           k disk
MP   f                                     usropn
QQ   Failhsch1  if   e           k disk
QQ   Failmusr1  if   e           k disk
Q1 RZF*ARLTCCT1  IF   E           K DISK    USROPN PREFIX(CC_)
RZ   FARLTCCT1  UF   E           K DISK    USROPN PREFIX(CC_)
UW   FARLTCCTD  IF   E           K DISK
UW   F                                     RENAME(ARFTCCT:ARFTCCTD)
RZ UGF*arlmcsc1  if   e           k disk    prefix(f) usropn
UG   Farlmcsc3  if   e           k disk    prefix(f) usropn
RK   FSHLCLIP1  UF A E           K DISK
SH   Foelwta1   UF   E           K DISK    Prefix(TX_)
SI   Foeltocy4  if   e           k disk    Prefix(cy4_)
SI   F                                     rename(oeftoc:oeftoc4)
SI   F                                     rename(oeftocy:oeftocy4)
SI   Foeltdd5   if   e           k disk    Prefix(dd5_)
SI   F                                     rename(oeftdd:oeftdd5)
SV   Fivlwumc2  if   e           k disk    usropn prefix(j)
SV   Fivlmuom1  if   e           k disk    usropn prefix(k)
TI   Ftblmtbl3  if   e           k disk    rename(tbfmtbl:tbfmtbl3)
UA   Foeqtrbc01 if   e           k disk    prefix(q)
UG V5F*arlmccd1  if   e           k disk
V5   Farlmccd3  if   e           k disk
UJ   Foeltpol1  if A e           k disk    prefix(OV_)
UJ   Foeltpol2  if   e           k disk    prefix(OV_)
UJ   F                                     rename(OEFTPOL:OEFTPOL2)
UJ   Foelwpol1  uf A e           k disk    prefix(OV_) usropn
VJ   FOEQWPRC01 uf a e           k disk    usropn prefix(w)
VJ   FOEQAPRC   if a e           k disk    usropn prefix(w)
VN   FIVLMSTA4  IF   E           K DISK
V4   Farltcctg  if   e           k disk    prefix(WC_)
V4   F                                     RENAME(ARFTCCT:ARFTCCTG)
%N   foelffl01a if   e           k disk    prefix(fl_)
:K   FOEPNO14   IF A E             DISK    USROPN PREFIX(KP_)
#P   FOEPCTOH   UF A E           K DISK
*a    * Card Connect
*a   FOELMGT29B if   e           k disk    prefix(m_)
      *------------------------------------------------------------------------*
MP    /COPY QCPYSRC,WKYPROTO
NR    /COPY QCPYSRC,HDYPROTO
RO    /COPY QCPYSRC,MNYPROTO
&7    /copy QCPYSRC,PCTERMS_CP
!¢4   //* display window
!¢4   /copy qcpysrc,utrg9390pr
MP    *------------------------------------------------------------------------*
     D GA9             S              1    DIM(9)                               GENERIC SEARCH AR
     D GB9             S              1    DIM(9)                               GENERIC SEARCH AR
     D TAB             S              1    DIM(10) CTDATA PERRCD(1)
     D AR1             S             20    DIM(1) CTDATA PERRCD(1)
     D AR2             S             20    DIM(1) CTDATA PERRCD(1)
     D AR3             S             20    DIM(1) CTDATA PERRCD(1)
     D AR4             S             20    DIM(1) CTDATA PERRCD(1)
     D ARY             S              1    DIM(70) CTDATA PERRCD(70)            PICK TICKET PRINT
   T4D*FX              S             53    DIM(4) CTDATA PERRCD(1)              FAX TICKET ARRAY
T4   D FX              S             53    DIM(5) CTDATA PERRCD(1)              FAX TICKET ARRAY
     D PCPC            S              1    DIM(8)                               CHAIN DSC OR DSC
   MZD*SRL             S             20    DIM(99)                              SERIAL #S FROM SF
MZ   D SRL             S             20    DIM(9999)                            SERIAL #S FROM SF
     D TAG             S              9    DIM(400)                             TAG #'S
     D TG#             S              9    DIM(400)                             TAGS THIS ORD.
     D IT1             S              6  0 DIM(400)                             ITM & ORG QTY
     D QT1             S              7  0 DIM(400)
     D IT2             S              6  0 DIM(400)                             ITM & TOTAL QTY
     D QT2             S              7  0 DIM(400)
     D SK2             S              1    DIM(400)                             CHECK STOCK   Y
     D MSG             S             78    DIM(13) CTDATA PERRCD(1)             MESSAGES
     D WRK             S              1    DIM(78)                              WORK ARRAY
     D W$              S              1    DIM(9)                               WORK ARRAY
     D LOU             S              1    DIM(35) CTDATA PERRCD(35)            IN LIEU OF MSGINT
     D CL#             S              5  0 DIM(400)                             C/O LIN#+OCUR#
     D CLO             S              3  0 DIM(400)
     D FMSG            S              1    DIM(12) CTDATA PERRCD(12)            FACTOR MSG    INT
     D ARS             S              1    DIM(65) CTDATA PERRCD(65)            SHIP BRANCH MSG
     D MS2             S              1    DIM(109) CTDATA PERRCD(80)           SNDBRKMSG
     D REF             S              1    DIM(35)                              REF UOM MSG LINE
     D AR5             S              1    DIM(10) CTDATA PERRCD(1)             NUMBER EDIT
VU   D AR6             S             20    DIM(1) CTDATA PERRCD(1)
   MQD*UMS             S             78    DIM(82) CTDATA PERRCD(1)             MESSAGES
MQ M2D*UMS             S             78    DIM(83) CTDATA PERRCD(1)             MESSAGES
M2 M0D*UMS             S             78    DIM(84) CTDATA PERRCD(1)             MESSAGES
M0 NUD*UMS             S             78    DIM(85) CTDATA PERRCD(1)             MESSAGES
NU N5D*UMS             S             78    DIM(86) CTDATA PERRCD(1)             MESSAGES
N5 OKD*UMS             S             78    DIM(87) CTDATA PERRCD(1)             MESSAGES
OK NND*UMS             S             78    DIM(88) CTDATA PERRCD(1)             MESSAGES
NN QPD*UMS             S             78    DIM(89) CTDATA PERRCD(1)             MESSAGES
QP   D UMS             S             78    DIM(93) CTDATA PERRCD(1)             MESSAGES
   M5D*WOS             S              7  0 DIM(400)                             MULT S/O
M5   D WOS             S              7  0 DIM(400)                             MULT S/O
     D R               S              6  0 DIM(50)                              RNS ITEMS CREATED
     D RNS             S              6  0 DIM(400)                             ALL RNS ITEMS ON S/O
     D CRM             S              1    DIM(92) CTDATA PERRCD(46)            CREDIT HOLD MSG
     D INV             S              1    DIM(120) CTDATA PERRCD(60)           INVALID USER MSG
     D USR             S             10    DIM(3)                               USER ID'S     SG
   N4D*EMS             S             78    DIM(55) CTDATA PERRCD(1)             MESSAGES
N4 OAD*EMS             S             78    DIM(57) CTDATA PERRCD(1)             MESSAGES
OA OFD*EMS             S             78    DIM(72) CTDATA PERRCD(1)             MESSAGES
OF OED*EMS             S             78    DIM(74) CTDATA PERRCD(1)             MESSAGES
OE OHD*EMS             S             78    DIM(75) CTDATA PERRCD(1)             MESSAGES
OH OGD*EMS             S             78    DIM(80) CTDATA PERRCD(1)             MESSAGES
OG OID*EMS             S             78    DIM(81) CTDATA PERRCD(1)             MESSAGES
OI OPD*EMS             S             78    DIM(83) CTDATA PERRCD(1)             MESSAGES
OP OSD*EMS             S             78    DIM(84) CTDATA PERRCD(1)             MESSAGES
OS OZD*EMS             S             78    DIM(85) CTDATA PERRCD(1)             MESSAGES
OZ RDD*EMS             S             78    DIM(86) CTDATA PERRCD(1)             MESSAGES
RD U2D*EMS             S             78    DIM(87) CTDATA PERRCD(1)             MESSAGES
U2   D EMS             S             78    DIM(88) CTDATA PERRCD(1)             MESSAGES
MP   D AMS             S             78    DIM(7) CTDATA PERRCD(1)              MESSAGES
     D DEP#            S              7    DIM(10)                              WITHDRAWALS
     D WD$             S              9  2 DIM(10)
     D VOD             S              1    DIM(98) CTDATA PERRCD(49)            SUBMIT VOIDYN
     D DOA             S              1    DIM(140) CTDATA PERRCD(70)           SUBMIT DIR AUD
&N &SD*CSG             S             78    DIM(52) CTDATA PERRCD(1)
&S &VD*CSG             S             78    DIM(53) CTDATA PERRCD(1)
&V &8D*CSG             S             78    DIM(54) CTDATA PERRCD(1)
&8   D CSG             S             78    DIM(55) CTDATA PERRCD(1)
¢T   D ZC#1            S              1    DIM(30)
¢T   D CT#1            S             28    DIM(30)
¢T   D NA#1            S             13    DIM(30)
¢T   D FC#1            S              1    DIM(30)
¢T   D MI#1            S              1    DIM(30)
¢T   D PN#1            S             28    DIM(30)
¢T   D CI#1            S              1    DIM(30)
¢T   D ZI#1            S              1    DIM(30)
¢T   D UI#1            S              1    DIM(30)
¢T   D FN#1            S              4    DIM(30)
¢T   D ST#1            S              2    DIM(30)
¢T   D CY#1            S              3    DIM(30)
¢T   D CN#1            S             25    DIM(30)
¢T   D A1#             S             64    DIM(10)
¢T   D A2#             S             64    DIM(10)
¢T   D NO#             S             10    DIM(10)
¢T   D PR#             S              2    DIM(10)
¢T   D NM#             S             28    DIM(10)
¢T   D SF#             S              4    DIM(10)
¢T   D PS#             S              2    DIM(10)
¢T   D AT#             S              4    DIM(10)
¢T   D AN#             S              8    DIM(10)
¢T   D CT#             S             28    DIM(10)
¢T   D CA#             S             13    DIM(10)
¢T   D ST#             S              2    DIM(10)
¢T   D Z5#             S              5    DIM(10)
¢T   D Z4#             S              4    DIM(10)
¢T   D LL#             S             64    DIM(10)
¢T   D CR#             S              4    DIM(10)
¢T   D DP#             S              3    DIM(10)
¢T   D CP#             S             25    DIM(10)
¢T   D FS#             S              2    DIM(10)
¢T   D FC#             S              3    DIM(10)
¢T   D CD#             S              2    DIM(10)
¢T   D LC#             S              1    DIM(10)
¢T   D SL#             S              1    DIM(10)
¢T   D AF#             S              1    DIM(10)
$A   D Opary           S             15A   Dim(100)
OA   D ordlin          S             10    DIM(400)
OA   D shpdqty         S              7s 0 DIM(400)
OA   D orddqty         S              7s 0 DIM(400)
OA   D ordflg          S              1    DIM(400) inz(*blanks)
%W   D wvnd#           s              6  0 dim(400)
%W   D wrnty           s              1    dim(400)
¢(    * B2B - - - - - - - - - - - - - - - - - - - - - - - - - ->
¢(    *
¢(   D Syscmd          pr            10i 0 extproc('system')
¢(   D  command                        *   value options(*string)
¢(   D ExcpID          s              7a   import('_EXCP_MSGID')
¢(    *
¢(   D Wrkcmd          s            512a   Inz(*blanks)
¢(   D Cmxy            s              1a   Inz(X'7D')
¢(   D WkB2B           S              4    DIM(50) Inz(*blanks)
:O   D WKSTS           S              5    DIM(50) Inz(*blanks)
¢(   D WKST1           S              2    DIM(50) Inz(*blanks)
¢(   D BkB2B           S              4a   Inz(*Blanks)
¢(   D WTyChn          s              4a   Inz(*Blanks)
¢(   D XY              s              3s 0 Inz(*Zeros)
:O   D WkSts0          s              5a   Inz(*Blanks)
¢(   D W_Backup        s              8a   Inz(*Blanks)
¢(    * End-B2B
OA   D qtyavl          s                   like(eoeqy03)
OA   D orddavl         s                   like(eoeqy01)
OA   D WMLOCK          s              1
MP RLD*woAry           s              7  0 DIM(400)
RL   D woAry           s              7  0 DIM(400) DESCEND
OD   D attachTxt       s             70
OD   D attachType      s              3    inz('S/O')
OD   D fileOpt         s              1
OE   d contactNbr      s              5  0 inz
RL   d woexs           s              1
RL   d woalc           s              1
RL   d sin47           s              1
RL   d cwono01         s              7    inz
WA   DPoLat            S              8F
WA   DPoLng            S              8F
MP
MP   D pfWkoh        e ds                  extname(wkptoh)
MP   D rtnDta          DS
MP   D  rtnWkoNum                     7
MP   D  rtnWkoPrc                    19  9 inz(0)
MP   D  rtnWkoCst                    19  9 inz(0)
MP
RF   D multmg          c                   'Emailing to multiple addresses'
MP   d pretcd          s              1
MP   d pactcd          s              2
MP   d pfunky          s              2
MP   d pdata           s            256
MP   d pUser           s             29
MP   d wmQty           s             19  9
MP   d pWmItemNum      s              7  0
MP   d pHdTransNum     s              7
MP   d pHdTrans#Cod    s              1
MP   d pHdNsNum        s             12
MP   d pHdProdDesc     s             30
MP   d pHdEntityId     s             20
MP   d pWoTagLineNum   s              5  0
MP   d woWarn          s              1
MP   d genwo           s              1
MP   d woIndx          s              3  0
MP   d woBrNbr         s                   like(oeno16)
MP   d wkoTrnNum       s              7  0
MP   d woNbr           s              7
MP   d wkEnt7          s              7  0 inz
MP   d wkoDate         s              8
OJ   D trannum         S              7A
RP   D cmqty           S                   like(oeqy01)
RE   d wNoPo           s              1
UK   D ordbyreq        s              1    inz('N')
UT   D OE_OrdBy        s              1    Inz
VU   D ccpfee          s              7  2
VU   D cardamount      s              9  2
VU   D appccpfee       s              1
VU   D svam04          s                   like(oeam04)
VU   D ccptax          s                   like(oeam04)
VU   D ctaxdf          s              1
VU   D cdscdf          s              1                                         RES DISCOUNT
VU   D sf_dscper       s                   like(dscper)                         RES DISCOUNT
VU   D sf_oeam06       s                   like(oeam06)                         RES DISCOUNT
VU   D sf_oeam07       s                   like(oeam07)                         RES DISCOUNT
VU   D sf_oeam36       s                   like(oeam36)                         RES DISCOUNT
VU   D sf_swd$         s                   like(oeam22)                         RES DISCOUNT
VU   D                 DS
VU   D  TBNO02                 1      9
VU   D  RSNTYP                 9      9
%D   D TESTN8          S              8A
:K   D TimeStamp       s               z
:K   D @Count          s              7  0 Inz
&4   D Allow_DNR       s              1    inz('N')
#A   D cc_web          s               N   INZ(*OFF)
#A   D ccarnoc1        s                   like(cc_arnoc1)
#A   D days            s              6s 0
#A   D Today           S               d   datfmt(*ISO) Inz(*Sys)
#I   D TodayCYM        S              6s 0
:F   D wrntyYN         S              1
&B   D WUEclaim        S              1    inz('N')
%W   D NewStatus       S             10
%W   D TransType       S              2
%W   D QtyErr          S              1
%W   D RWErr           S              1
%W   D RsnErr          S              1
%W   D wc_ra#          S             20    INZ(*blanks)
%W   D Rcount          s              3s 0 inz(*zeros)
%W   D Wcount          s              3s 0 inz(*zeros)
%W   D RA#Found        S              1
%W   D Tchsts          S             10
:C   D Tchtyp          S              3
%W   D gmcsec          S              3
%W   D gmctmp          S              1
%W   D RaNum           s                   like(oeno69)
:Q   D stscode         s              2
:Q   D stsdesc         s             10
#5   D woepc02         s                   like(oepc02)
#5   D woeam04         s                   like(oeam04)
%W   D is_pickable     S              1
#W   D claim_appvd     S              1
&C   D Price_Ovrd      s              1    inz('N')
&V   D Promo_exists    S              1    inz('N')
&V   D BO_exists       S              1    inz('N')
&8   D PCCODEFOUND     S              1    inz('0')
&8   D NOUPDATEH       S              1    inz('0')
&7   D TermCustomer    s                   like(arno01)
&7   D TermitemCount   s             10  0 Inz
&7   D TermBranch      s                   like(oeno08)
&7   D TermOrder       s                   like(oeno01)
&7   D SLSNO16         s              3
&7   D HouseBranch     s              3
MP    *
MP   D procWorkOrders  pr                  extpgm('WKR3001')
MP   D                                1
MP   D                                2
MP   D                                2
MP   D                              256
MP   D                               29
MP   D workOrderMaint  pr                  extpgm('WKR1020')
MP   D                                1
MP   D                                2
MP   D                                2
MP   D                              256
MP   D                               29
      *
OA   D psdata        e ds                  occurs(400) extname(OEPWRGA) inz
OA   D  PSEL         E                     EXTFLD(SEL)
OA   D  PDESC        E                     EXTFLD(IVDN01)
OA   D  PNO08        E                     EXTFLD(OENO01)
OA   D  PNO09        E                     EXTFLD(OENO09)
OA   D  PCD12        E                     EXTFLD(OECD16)
OA   D  PNO07        E                     EXTFLD(IVNO07)
OA   D  PNO04        E                     EXTFLD(IVNO04)
OA   D  PNO14        E                     EXTFLD(OENO23)
OA   D  PCD09        E                     EXTFLD(OECD09)
OA   D  PAM01        E                     EXTFLD(OEAM01)
OA   D  PAM02        E                     EXTFLD(OEAM02)
OA   D  PAM05        E                     EXTFLD(OEAM05)
OA   D  PAM04        E                     EXTFLD(OEAM17)
OA   D  PDN02        E                     EXTFLD(IVDN02)
OA   D  PDN04        E                     EXTFLD(OEDN04)
OA   D  PFL01        E                     EXTFLD(OECD26)
OA   D  PFL02        E                     EXTFLD(OECD27)
OA   D  PFL04        E                     EXTFLD(OEFL32)
OA   D  PFL05        E                     EXTFLD(IVCD57)
OA   D  PQY01        E                     EXTFLD(OEQY01)
OA   D  PN07P        E                     EXTFLD(OENO07)
OA   D  PQY01O       E                     EXTFLD(OEQY01_SV)
OA   D  PNO07O       E                     EXTFLD(IVNO07_SV)
OA   D  PNO04O       E                     EXTFLD(IVNO04_SV)
OA   D  PDESCO       E                     EXTFLD(IVDN01_SV)
OA   D  PAM01O       E                     EXTFLD(OEAM01_SV)
OA   D  PNO08O       E                     EXTFLD(OENO01_SV)
OA   D  PCD17        E                     EXTFLD(OECDB2)
OA   D  PNO05        E                     EXTFLD(IVNO05)
OA   D  PCD42        E                     EXTFLD(OECD42)
OA   D  PNO41        E                     EXTFLD(PONO01)
OA   D  preacd       e                     extfld(OECD14)
OA   D  pshpbr       e                     extfld(OENO16)
OA   D  porgow       e                     extfld(OEID01)
OA   D  pshpco       e                     extfld(ARNO15)
OA   D  pcd31        e                     extfld(OECD31)
OA   D  pcd79        e                     extfld(IVCD79)
OA   D  pcd50        e                     extfld(POCD50)
OA   D  ppc01        e                     extfld(OEPC01)
OA   D  preacdo      e                     extfld(OECD14_SV)
OA   D  pfl04o       e                     extfld(OEFL32_SV)
OA   D  PRSTKPCT     e                     extfld(OEPC09)
OA   D  PCD43        e                     extfld(OECD43)
OA   D  PNO22        e                     extfld(OENO22)
OA   D  PAM38        e                     extfld(OEAM38)
OA   D  PMANPR       e                     extfld(OEFL34)
OA   D  PNETR        e                     extfld(OEAM65)
OA   D  PNETRO       e                     extfld(OEAM65_SV)
OA   D  PQY06        e                     extfld(OEQY06)
OA   D  PRSTK        e                     extfld(OEAM64)
OA   D  PPRCDONE     e                     extfld(OEFL35)
OM   D  portag#      e                     extfld(oeno27)
OM   D  psranbr      e                     extfld(oeno69)
OM   D  prareq       e                     extfld(ivcde2)
OM   D  pmhcode      e                     extfld(oecd74)
OM   D  preqtag      e                     extfld(oefl37)
ON   D  pextdesc     e                     extfld(ivcd36)
OQ   D  pordlot      e                     extfld(ivcdl5)
OQ   D  pordreq      e                     extfld(ivcdl8)
OQ   D  pordent      e                     extfld(ivcdl5_l)
OQ   D  pordtmp      e                     extfld(IVNOL3_l)
OR   D  psrlno       e                     extfld(ivnoa0)
OU   D  pfl38        e                     extfld(oefl38)
OW   D  pam02_sv     e                     extfld(oeam02_sv)
OW   D  ppc01_sv     e                     extfld(oepc01_sv)
OW   D  pam38_sv     e                     extfld(oeam38_sv)
OW   D  pfl02_sv     e                     extfld(oecd27_sv)
OA   D ORDLIN#         DS
OA   D  order#                 1      7
OA   D  line#                  8     10
     D                SDS
     D  PROG                   1      8
     D  USRNM                254    263
     D  DSPERR                91    160
RK   D  WSNAME               244    252
RF   D  JOBNME               244    253
     D  JOBNBR               264    269  0
     D PARAM           DS
     D  CSAUOM               301    303
#H   D  CREDIT_REL           309    309
¢(    * B2B - Credit Memo Information
¢(   D  W_OECD08             985    985                                         B2B Credit Memo
¢(   D  W_OENO14             986    992                                         B2B CC.MEMO ORDER
¢(    * End-B2B
     D                 DS                  INZ
     D  PC0                    1      1
     D  PC1                    1      2
     D  PC2                    4      5
     D  PC3                    7      8
     D  PC4                    5      8
     D  PC6                    3      8
     D  PC12                   2      2
     D  PC13                   3      3
     D  PC14                   4      4
     D  PC15                   5      5
     D  PC48                   4      8
     D  PC68                   6      8
     D  PC01                   1      8
¢H   D CRDEML          DS
¢H   D  FLAGYN                 1      1
     D                 DS
     D  NBR                    1      3
     D  NBR1                   1      2
      *
     D                 DS
     D  P11                    1      1
     D  P2                     3      8
     D  PCPC01                 1      8
     D                 DS
     D  OAPC1                  1      2
     D  OAPC2                  4      5
     D  OAPC3                  7      8
     D  OAPC01                 1      8
     D                 DS
     D  WBO                    1      1
     D  CHKSTK                 1      1
     D  HLD                    3      3
     D  WPR                    3      5
     D  CYTX                   3      7
     D  STTX                  13     17
     D  TBNO03                 1     30
¢A1  D PERZIP          DS
¢A1  D  pzflg                  1      1
      *
     D                 DS                  INZ
     D  AUTHFL                11     11
     D  TBN03                  1     30
      *
     D ZZNO04          DS
     D  NSCDE                  1      1
     D  SEC                    2      4
     D  NSITM                  5     12
$X   D  IQSRCH                 2     15
     D NXTTDD          DS
     D  NEXT#                  1      7
     D PRT             DS
     D  NS                     5     12
     D                 DS
     D  FT1                    1      1
     D  FT2                    2      2
     D  FT3                    3      3
     D  FT4                    4      4
     D  FEET                   1      4
     D  SEPR                   5      5
     D  IN1                    6      6
     D  IN2                    7      7
     D  INCH                   6      7
     D  OEQY04                 1      7
     D                 DS
     D  ARCC01                 1      2  0
     D  ARYR01                 3      4  0
     D  ARMO01                 5      6  0
     D  BILLDT                 1      6  0
     D                 DS
     D  SVBLCC                 1      2  0
     D  SVBLYR                 3      4  0
     D  SVBLMO                 5      6  0
     D  SVDBIL                 1      6  0
     D                 DS
     D  BILLCC                 1      2  0
     D  BILLYR                 3      4  0
     D  BILLMO                 5      6  0
     D  BILLCM                 1      6  0
     D                 DS
     D  OEYR03                 1      2  0
     D  OEMO03                 3      4  0
     D  OEDY03                 5      6  0
     D  OEDATE                 1      6  0
     D                 DS
     D  PUSC                   1      2  0
     D  PUSY                   3      4  0
     D  PUSM                   5      6  0
     D  PUS1                   1      6  0
     D                 DS
     D  MINC                   1      2  0
     D  MINY                   3      4  0
     D  MINM                   5      6  0
     D  MIN1                   1      6  0
     D                 DS
     D  OEMO07                 1      2  0
     D  OEDY07                 3      4  0
     D  OEYR07                 5      6  0
     D  DATPRM                 1      6  0
     D                 DS
     D  SVMO07                 1      2  0
     D  SVDY07                 3      4  0
     D  SVYR07                 5      6  0
     D  SAVPRM                 1      6  0
     D                 DS
     D  ARMO05                 1      2  0
     D  ARDY05                 3      4  0
     D  ARYR05                 5      6  0
     D  DATORD                 1      6  0
     D                 DS
     D  SVMO05                 1      2  0
     D  SVDY05                 3      4  0
     D  SVYR05                 5      6  0
     D  SAVORD                 1      6  0
     D                 DS
     D  ARMO06                 1      2  0
     D  ARDY06                 3      4  0
     D  ARYR06                 5      6  0
     D  DATSHP                 1      6  0
     D                 DS
     D  OEMO05                 1      2  0
     D  OEDY05                 3      4  0
     D  OEYR05                 5      6  0
     D  BDATE                  1      6  0
     D                 DS
     D  SVMO06                 1      2  0
     D  SVDY06                 3      4  0
     D  SVYR06                 5      6  0
     D  SVDSHP                 1      6  0
     D                 DS
     D  CRARCC                 1      2  0
     D  CRARYR                 3      4  0
     D  CRARMO                 5      6  0
     D  STDT                   1      6  0
     D                 DS
     D  SOMO02                 1      2  0
     D  SODY02                 3      4  0
     D  SOYR02                 5      6  0
     D  DATOUT                 1      6  0
     D                 DS
     D  IVYR02                 1      2  0
     D  IVMO02                 3      4  0
     D  IVDY02                 5      6  0
     D  IVDATE                 1      6  0
     D                 DS
     D  OEMO25                 1      2  0
     D  OEDY25                 3      4  0
     D  OEYR25                 5      6  0
     D  RNDATE                 1      6  0
#A   D                 DS
#A   D  cmo                    1      2  0
#A   D  cdy                    3      4  0
#A   D  ccc                    5      6  0
#A   D  cyr                    7      8  0
#A   D  DateMdcy               1      8  0
#I   D                 DS                  INZ
#I   D  tcy                    1      2  0
#I   D  tyr                    3      4  0
#I   D  tcyyr                  1      4  0
#I   D  tmo                    6      7  0
#I   D  tdy                    9     10  0
#I   D  DateInCymd             1     10d
&C   D                 DS
&C   D  POTSTARTCC             1      2  0
&C   D  POTSTARTYR             3      4  0
&C   D  POTSTARYMO             5      6  0
&C   D  POTSTARYDY             7      8  0
&C   D  POTSTARTCYMD           1      8  0
&C   D                 DS
&C   D  ORDEREDCC              1      2  0
&C   D  ORDEREDYR              3      4  0
&C   D  ORDEREDMO              5      6  0
&C   D  ORDEREDDY              7      8  0
&C   D  ORDEREDCYMD            1      8  0
     D                 DS
     D  OPNPRT                 1      1
     D  PNDPRT                 2      2
     D  RESPRT                 3      3
     D  QTEPRT                 4      4
     D  PRTCTL                 1      4
     D FIL1DS          DS
     D  SCREEN               261    268
     D  WSNANE               273    282
     D  C@LOC                370    371B 0
     D  TOPRR                378    379B 0
     D SAVDS           DS                  OCCURS(400)
     D  ORDQTY                 1      7  0
     D  ORDITM                 8     37
     D  ORDSHP                38     44  0
     D  ORDBKO                45     51  0
     D  ORDDSC                52     86
   N4D* ORDAM1                87     93  2
   N4D* ORDAM2                94    100  2
   N4D* ORDPC1               101    108
   N4D* ORDICT               109    109
   N4D* ORDDN2               110    112
   N4D* ORDNO7               113    118  0
   N4D* ORDN23               119    124  0
   N4D* ORDC26               125    125
   N4D* ORDC27               126    126
   N4D* ORDC28               127    127
   N4D* ORDDN4               128    130
   N4D* ORDAM5               131    139  2
   N4D* DSEXT                140    140
   N4D* ORDQY4               141    147
   N4D* ORDCMP               148    148
   N4D* ORDCQY               149    153  0
   N4D* ORDALI               154    154
   N4D* ORDSR#               155    155
   N4D* ORDOLN               156    158  0
   N4D* ORNSA                159    159
   N4D* ORBOS                160    160
   N4D* ORBOH                161    161
   N4D* ORBOP                162    168  0
   N4D* ORRSN                176    176
   N4D* ORAFIV               177    177
   N4D* ORTAG#               178    186
   N4D* ORSTK                187    187
   N4D* ORDPO#               188    194  0
   N4D* ORDCTL               195    201  0
   N4D* ORDAPR               202    202
   N4D* ORTXCD               203    203
   N4D* ORDOAL               204    208  0
   N4D* ORDA18               209    217  2
   N4D* ORDA17               225    233  2
   N4D* DSBOOK               234    234
   N4D* ORDBQY               235    241  0
   N4D* ORDSQY               242    248  0
   N4D* ORDDFT               249    249
   N4D* ORDBO$               250    258  2
   N4D* ORDF43               259    259
   N4D* ORDPC7               260    262  1
   N4D* ORDSV7               263    265  1
   N4D* ORDC66               266    266
   N4D* ORDQ14               267    273  0
   N4D* ORDQ15               274    280  0
   N4D* ORDQ16               281    287  0
   N4D* ORAM38               306    316  5
   N4D* ORAM39               317    327  5
   N4D* ORAM40               328    338  5
   N4D* ORAM41               339    349  5
   N4D* ORAM42               350    360  5
   N4D* ORAUM                361    363
   N4D* ORSALT               364    364
   N4D* ORSORD               365    365
   N4D* ORDA14               366    374  4
   N4D* ORDPO1               375    375
   N4D* ORDPO2               376    376
   N4D* ORNO22               377    379  0
   N4D* ORCREF               382    382
   N4D* ORSVPR               383    393  5
   N4D* ORGITM               394    394
   N4D* ORDAVL               395    401  0
   N4D* ORDPOL               402    404  0
   N4D* ORDLOU               405    434
   N4D* ORDTBR               435    437  0
   N4D* ORDTR#               438    444  0
   N4D* ORDTAG               445    445
   N4D* ORDWT1               446    456  4
   N4D* SENO22               466    471
   N4D* ORDC72               472    472
   N4D* ORNO56               473    477  0
   N4D* ORDWO#               478    484  0
   N4D* SRANBR               485    504
   N4D* SRAREQ               505    505
   N4D* SVRREQ               506    506
   N4D* ORPFCT               507    520  9
   N4D* OROFCT               521    534  9
   N4D* ORDLOT               535    535
   N4D* ORDREQ               536    536
   N4D* ORLENT               537    537
   N4D* ORSVQ1               538    544  0
   N4D* ORMHCD               545    545
   N4D* OR6100               546    546
   N4D* ORDBOW               547    547
   M5D* ORDAO#               548    554  0
M5 N4D* ORDAO#               548    554
   N4D* ORDAL#               555    559  0
   N4D* ORDRTP               560    561
   N4D* ONTCHK               562    562
   N4D* ORCD62               563    563
MP N4D* ORDWOLIN             564    567  0
N1 N4D* ORDAWF               569    577  4
N1 N4D* ORDAEF               578    586  4
N4   D  ORDAM1                87     94  2
N4   D  ORDAM2                95    101  2
N4   D  ORDPC1               102    109
N4   D  ORDICT               110    110
N4   D  ORDDN2               111    113
N4   D  ORDNO7               114    119  0
N4   D  ORDN23               120    125  0
N4   D  ORDC26               126    126
N4   D  ORDC27               127    127
N4   D  ORDC28               128    128
N4   D  ORDDN4               129    131
N4   D  ORDAM5               132    140  2
N4   D  DSEXT                141    141
N4   D  ORDQY4               142    148
N4   D  ORDCMP               149    149
N4   D  ORDCQY               150    154  0
N4   D  ORDALI               155    155
N4   D  ORDSR#               156    156
N4   D  ORDOLN               157    159  0
N4   D  ORNSA                160    160
N4   D  ORBOS                161    161
N4   D  ORBOH                162    162
N4   D  ORBOP                163    169  0
N4   D  ORRSN                177    177
N4   D  ORAFIV               178    178
N4   D  ORTAG#               179    187
N4   D  ORSTK                188    188
N4   D  ORDPO#               189    195  0
N4   D  ORDCTL               196    202  0
N4   D  ORDAPR               203    203
N4   D  ORTXCD               204    204
N4   D  ORDOAL               205    209  0
N4   D  ORDA18               210    218  2
N4   D  ORDA17               226    234  2
N4   D  DSBOOK               235    235
N4   D  ORDBQY               236    242  0
N4   D  ORDSQY               243    249  0
N4   D  ORDDFT               250    250
N4   D  ORDBO$               251    259  2
N4   D  ORDF43               260    260
N4   D  ORDPC7               261    263  1
N4   D  ORDSV7               264    266  1
N4   D  ORDC66               267    267
N4   D  ORDQ14               268    274  0
N4   D  ORDQ15               275    281  0
N4   D  ORDQ16               282    288  0
N4   D  ORAM38               307    317  5
N4   D  ORAM39               318    328  5
N4   D  ORAM40               329    339  5
N4   D  ORAM41               340    350  5
N4   D  ORAM42               351    361  5
N4   D  ORAUM                362    364
N4   D  ORSALT               365    365
N4   D  ORSORD               366    366
N4   D  ORDA14               367    375  4
N4   D  ORDPO1               376    376
N4   D  ORDPO2               377    377
N4   D  ORNO22               378    380  0
N4   D  ORCREF               383    383
N4   D  ORSVPR               384    394  5
N4   D  ORGITM               395    395
N4   D  ORDAVL               396    402  0
N4   D  ORDPOL               403    405  0
N4   D  ORDLOU               406    435
N4   D  ORDTBR               436    438  0
N4   D  ORDTR#               439    445  0
N4   D  ORDTAG               446    446
N4   D  ORDWT1               447    457  4
N4   D  SENO22               467    472
N4   D  ORDC72               473    473
N4   D  ORNO56               474    478  0
N4   D  ORDWO#               479    485  0
N4   D  SRANBR               486    505
N4   D  SRAREQ               506    506
N4   D  SVRREQ               507    507
N4   D  ORPFCT               508    521  9
N4   D  OROFCT               522    535  9
N4   D  ORDLOT               536    536
N4   D  ORDREQ               537    537
N4   D  ORLENT               538    538
N4   D  ORSVQ1               539    545  0
N4   D  ORMHCD               546    546
N4   D  OR6100               547    547
N4   D  ORDBOW               548    548
N4   D  ORDAO#               549    555
N4   D  ORDAL#               556    560  0
N4   D  ORDRTP               561    562
N4   D  ONTCHK               563    563
N4   D  ORCD62               564    564
N4   D  ORDWOLIN             565    568  0
N4   D  ORDAWF               570    578  4
N4   D  ORDAEF               579    587  4
OA   D  PROTECTORD           588    588
OA   D  ORDLINE#             589    591  0
OA   D  ORDno#               592    598
OA PTD* itemno#              599    615
PT   D  filler599            599    615
OA   D  RESTKPCT             616    620S 3
OA   D  RESTKFLG             621    621
OA   D  @RESTKPCT            622    626S 3
OA   D  @RESTKFLG            627    627
OA   D  EXTPRC               628    638S 5
OA   D  @SVEXTPRC            639    649S 5
OA   D  ORVRTYPE             650    650
OF   D  INVITM               651    651
PE   D  ORDAWR               652    660  4
PE   D  ORDAER               661    669  4
S0 TBD* ORDAWR_S             652    660  4
S0 TBD* ORDAER_S             661    669  4
PT   D  itemno#              770    799
RD   D  DSDNR                800    800
RB   D  ALWPRCCHGDS                   1
RB   D  ALWCSTCHGDS                   1
RB   D  ITMPRCFLGDS                   1
TB   D  ORDAWR_S                      9  4
TB   D  ORDAER_S                      9  4
UJ   D  SvOrgAm01                     8  2
UJ   D  SvOrgPc01                     8
UJ   D  SvOrgNet                     11  5
UJ   D  SVACPT_REJ                    1
UJ   D  SVPOVFLG                      1
UJ   D  SvOrgCd26                     1
UJ   D  SvOrgCd28                     1
$O   D  ORDC40                        1
$Q   D  ORDA16                        7  2
:Z   D  ORDORGAM01                    8  2 INZ
     D PRCDS           DS                  OCCURS(400)
     D  PRITM                  1      6  0
     D  PRUOM                  7      9
     D  PRQTY                 10     16  0
     D  PRTYP                 17     17
   N4D* PRPRC                 18     24  2
   N4D* PRCST                 25     31  2
   N4D* PRDSC                 32     39
   N4D* PREXT                 40     48  2
   N4D* PRCSH#                49     55
   N4D* PRTRM                 56     58  1
   N4D* PROVR                 59     59
   N4D* PRSHPB                60     62  0
   N4D* PRCSTS                63     63
   N4D* PRPRCS                64     64
N4   D  PRPRC                 18     25  2
N4   D  PRCST                 26     32  2
N4   D  PRDSC                 33     40
N4   D  PREXT                 41     49  2
N4   D  PRCSH#                50     56
N4   D  PRTRM                 57     59  1
N4   D  PROVR                 60     60
N4   D  PRSHPB                61     63  0
N4   D  PRCSTS                64     64
N4   D  PRPRCS                65     65
NQ   D  prWoNbr                       7s 0 inz
$O   D  PRDSCS                        1A
     D MXTXDS          DS                  OCCURS(400) INZ
     D  MAM38                  1     11  5
     D  MTXFLG                12     12
   NLD* MQSHP                 13     19  0
   NLD* MNOCHG                20     20
   NLD* MUNIT                 21     27  2
   NLD* MEXT                  28     36  2
   NLD* MQORD                 37     43  0
   NLD* MQBO                  44     50  0
NL   D  MQSHP                 13     23  4
NL   D  MNOCHG                24     24
NL N4D* MUNIT                 25     31  2
NL N4D* MEXT                  32     40  2
NL N4D* MQORD                 41     47  0
NL N4D* MQBO                  48     54  0
N4   D  MUNIT                 25     32  2
N4   D  MEXT                  33     41  2
N4   D  MQORD                 42     48  0
N4   D  MQBO                  49     55  0
     D COMBO           DS                  OCCURS(57)
     D  CIITM                  1      6  0
     D  CIUOM                  7      9
     D  CIQTY                 10     16  0
     D  CITYP                 17     17
   N4D* CIPRC                 18     24  2
   N4D* CICST                 25     31  2
   N4D* CIDSC                 32     39
   N4D* CIEXT                 40     48  2
   N4D* CICSH#                49     55
   N4D* CITRM                 56     58  1
   N4D* CIOVR                 59     59
   N4D* CISHPB                60     62  0
   N4D* CICSTS                63     63
   N4D* CIPRCS                64     64
   N4D* CIPDDS                65    112
   N4D* CIKID                113    115  0
   N4D* CIKLC#               116    120  0
   N4D* CIPID                121    123  0
   N4D* CIPLC#               124    128  0
   N4D* CINCI                129    129
   N4D* CICD84               130    130
   N4D* CICD47               131    131
   N4D* CIPN01               132    138  0
   N4D* CIPN05               139    141  0
   N4D* CIIEX                142    142
   N4D* CIQ11                143    149  0
   N4D* CIQ13                150    156  0
   N4D* CINSA                157    157
   N4D* CICD28               158    158
   N4D* CIVSC                159    218
   N4D* CISAC                219    220
N4   D  CIPRC                 18     25  2
N4   D  CICST                 26     32  2
N4   D  CIDSC                 33     40
N4   D  CIEXT                 41     49  2
N4   D  CICSH#                50     56
N4   D  CITRM                 57     59  1
N4   D  CIOVR                 60     60
N4   D  CISHPB                61     63  0
N4   D  CICSTS                64     64
N4   D  CIPRCS                65     65
N4   D  CIPDDS                66    113
N4   D  CIKID                114    116  0
N4   D  CIKLC#               117    121  0
N4   D  CIPID                122    124  0
N4   D  CIPLC#               125    129  0
N4   D  CINCI                130    130
N4   D  CICD84               131    131
N4   D  CICD47               132    132
N4   D  CIPN01               133    139  0
N4   D  CIPN05               140    142  0
N4   D  CIIEX                143    143
N4   D  CIQ11                144    150  0
N4   D  CIQ13                151    157  0
N4   D  CINSA                158    158
N4   D  CICD28               159    159
N4   D  CIVSC                160    219
N4   D  CISAC                220    221
RB   D  CIprcchg                      1
RB   D  CIcstchg                      1
     D OEDS            DS                  OCCURS(50)
     D  QTY                    1      7  0
     D  UOM                    8     10
     D  ITM                   11     40
     D RNSDS           DS                  OCCURS(50)
     D  RNSITM                 1      6  0
     D SPOEDS          DS                  OCCURS(400)
     D  SPQTY                  1      7  0
     D  SPUOM                  8     10
     D  SPITM                 11     40
     D  CMTCDE                41     41
     D  SPCQTY                42     48  0
     D NSITEM          DS
     D  NSITMN                 1      8
     D CO#DS           DS                  OCCURS(400)
     D  CO#TX                  1      1
     D  CO#QYO                 2      8  0
     D  CO#QYN                 9     15  0
     D  CO#CO$                16     24  2
     D  CO#QBO                25     31  0
     D  CO#QBN                32     38  0
     D  CO#C$B                39     47  2
NK   D COTXDS          DS                  OCCURS(400) INZ
NK   D  CAM38                  1     11  5
NK   D  CTXFLG                12     12
NK NLD* CQSHP                 13     19  0
NK NLD* CNOCHG                20     20
NK NLD* CUNIT                 21     27  2
NK NLD* CEXT                  28     36  2
NK NLD* CQORD                 37     43  0
NK NLD* CQBO                  44     50  0
NL   D  CQSHP                 13     23  4
NL   D  CNOCHG                24     24
NL N4D* CUNIT                 25     31  2
NL N4D* CEXT                  32     40  2
NL N4D* CQORD                 41     47  0
NL N4D* CQBO                  48     54  0
N4   D  CUNIT                 25     32  2
N4   D  CEXT                  33     41  2
N4   D  CQORD                 42     48  0
N4   D  CQBO                  49     55  0
     D                 DS
     D  WRK1                   1      9  2
     D  WRK1A                  1      9
%W
%W   D dsCM57          DS
%W   D  CM57                          9a
%W   D   OpenCM                       1a   overlay(CM57)
%W   D   VoidCM                       1a   overlay(CM57:*next)
%W   D   PrintCM                      1a   overlay(CM57:*next)
%W   D   ReviewCM                     1a   overlay(CM57:*next)
%W   D   Space                        1a   overlay(CM57:*next)
%W   D   CreateVR                     1a   overlay(CM57:*next)
%W   D   ShpCfmVR                     1a   overlay(CM57:*next)
%W   D   CloseWC                      1a   overlay(CM57:*next)
%W   D   UpdStsWC                     1a   overlay(CM57:*next)
%W
     D                 DS
     D  GENPOS                15     15
     D  TFRGEN                16     16
     D  SEE$                  17     17
     D  DSPTRM                18     18
     D  MAINTS                19     19
     D  CHGMOP                21     21
     D  PROHIB                 1     21
     D                 DS
     D  GENDIR                 1      1
     D  GENBOS                 2      2
     D  POAUTH                 1      2
     D                 DS
   MRD* REQSR#                 4      4
     D  HLDYN                  9      9
     D  ZSHIP                 10     10
     D  DFTBOQ                11     11
     D  RESET1                12     12
     D  RESET2                13     13
     D  SNDMSG                14     14
     D  ZROSHP                15     15
     D  OPTS                   1     30
MR   D                 DS
MR   D  SRLSET                 1     30
MR   D  SKIP_SRL               1      1
NF   D  SKIP_DSP               2      2
     D                 DS
     D  RNSCST                 1      1
     D  RSET                   1     30
     D OTHCGS          DS                  INZ
     D  FTAXYN                 1      1
     D  DTAXYN                 2      2
     D  HTAXYN                 3      3
     D  RTAXYN                 4      4
     D  OTAXYN                 5      5
     D  TAXOPT                 1      5
     D  ADDLOT                 6      6
     D  DIRCYN                 7      7
     D  AFPEND                 9      9
     D  AFDIR                 10     10
     D  ADDBCK                16     16
     D  RSVENT                18     18
RA   D  INSLN                 20     20  0
RB   D  WlkPrcFlg             21     21
     D  OTHOPT                 6     30
     D  FRTAMT                31     37  2
     D  DELAMT                38     44  2
     D  HANAMT                45     51  2
     D  RESAMT                52     58  2
     D  OTHAMT                59     65  2
     D  FRTDSC                66     85
     D  DELDSC                86    105
     D  HANDSC               106    125
     D  RESDSC               126    145
     D  OTHDSC               146    165
     D  FDSCYN               166    166
     D  DDSCYN               167    167
     D  HDSCYN               168    168
     D  RDSCYN               169    169
     D  ODSCYN               170    170
     D SAVCGS          DS
     D  SVFTAX                 1      1
     D  SVDTAX                 2      2
     D  SVHTAX                 3      3
     D  SVRTAX                 4      4
     D  SVOTAX                 5      5
     D  SVTOPT                 1     30
     D  SVFRT$                31     37  2
     D  SVDEL$                38     44  2
     D  SVHAN$                45     51  2
     D  SVRES$                52     58  2
     D  SVOTH$                59     65  2
     D  SVFDSC                66     85
     D  SVDDSC                86    105
     D  SVHDSC               106    125
     D  SVRDSC               126    145
     D  SVODSC               146    165
     D  SVFCYN               166    166
     D  SVDCYN               167    167
     D  SVHCYN               168    168
     D  SVRCYN               169    169
     D  SVOCYN               170    170
     D                 DS
     D  RWRK                   1      9
     D  RWRK1                  1      1
     D  RWRK2                  2      2
     D  RWRK3                  3      3
     D  RWRK4                  4      4
     D  RWRK5                  5      5
     D  RWRK6                  6      6
     D  RWRK7                  7      7
     D  RWRK8                  8      8
     D  RWRK9                  9      9
     D                 DS
     D  PRTDET                 1      2
     D  PTCD83                 1      1
     D  INVC83                 2      2
      *
     D                 DS
     D  OATMDT                 1     12  0
     D  OAMO02                 7      8  0
     D  OADY02                 9     10  0
     D  OAYR02                11     12  0
     D                 DS                  INZ
     D  DATYP                  1      1  0
     D  DATE2                  2      3  0
     D  DATE4                  4      7  0
     D  DATE6                  8     13  0
     D  DATE8                 14     21  0
     D  DACEN                 22     23  0
     D  DS2000                 1     23  0
     D                 DS                  INZ
     D  CRHOLD                 1      1
     D  CRCASH                 2      2
     D  OLHOLD                 3      3
     D  OLCASH                 4      4
     D  PCTOVR                 5      8
     D  USEMSG                 9      9
     D  HLDCND                 1      9
      *
     D SELMDS          DS                  OCCURS(50) INZ
     D  ITMSEL                 1      6
      *
     D WKNO04          DS
     D  ALPHA6                 1      6
     D  LAST6A                 7     12
      *
     D                 DS
     D  ADONS                  1     30
     D  WOSYS                  2      2
     D  WHMYES                 3      3
     D  RNSYS                  5      5
     D  PFSYS                  6      6
TI TRD*AvaTaxActive           18     18
      *
     D FAXOPT          DS             4    INZ
     D  CVRSHT                 1      1
     D  DELAY                  2      2
     D  ONEB4                  3      3
     D  IFXAC                  4      4
      *
     D                 DS                  INZ
     D  FAXSC                  1     10  0
     D  FAREA                  1      3  0
     D  FPRFX                  4      6  0
     D  FSUFX                  7     10  0
      *
     D                 DS                  INZ
     D  FAXSV                  1     10  0
     D  FAX1SV                 1      3  0
     D  FAX2SV                 4      6  0
     D  FAX3SV                 7     10  0
      *
     D FAXDTA          DS                  OCCURS(212)
     D  FX1                    1     53
     D  FX2                   54    106
     D  FX3                  107    159
     D  FX4                  160    212
T4   D  FX5                  213    267
      *
     D  SYSTEM                36     39
     D  FAXPH#                43     74
     D  SYSDTA                78    127
     D  RQTIME               131    136
     D  RQDATE               140    145
      *
      * BELOW ARE THE FIELDS NEEDED TO FAX TICKET
     D  OENUM                 78     84
     D  OEBR                  85     87
     D  OELOC                 88     88
     D  OEPRT                 89     89
     D  OEPRC                 90     90
     D  OEPINV                92     92
     D  OEPSEQ                93     93
     D                 DS
     D  WMCO#                  1      3  0
     D  WMBR#                  4      6  0
     D  COBR                   1      6
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
MP   *
MP   DinfdsWreq        ds
MP   D rrnwReq               397    400I 0
MP   *
MP   d infdsToh1       ds
MP   d  rrnToh1              397    400I 0
MP   *
MQ   D                 DS                  INZ
MQ   D  REGMIN                 1      3  0
MQ   D  REGMAX                 4      6  0
MQ   D  RMNMX                  1      6
PP   D                 ds                  inz
PP   D  wmdta1                 1    256
PP   D  wmstat                 1      2
PP   D  wmstds                 3     32
PP   D                 ds                  inz
PP   D  hddta1                 1    256
PP   D  hdtrn#                 1      7
PP   D  hdshpm                 8      8
PP   D  hdshpc                 9     10
PP   D  hdshpv                11     25
PP   D  pshpm                 26     27  0
PP   D  pshpd                 28     29  0
PP   D  pshpy                 30     31  0
PP   D  pshpc                 32     33  0
MQ   D                 DS                  INZ
MQ   D  DIRMIN                 1      3  0
MQ   D  DIRMAX                 4      6  0
MQ   D  DMNMX                  1      6
MP
MP   D ChkSo           DS
MP   D  sOeNo01                       7
MP   D  sTransNoKx                    7
MP   D  sOeCd38                       1
MP   D  sOeFl04                       1
MP   D  sOeFl05                       1
MP
MV   D WARRANTY_DS     DS                  OCCURS(50)
MV   D  WRNTY_QTY              1      7  0
MV   D  WRNTY_UOM              8     10
MV   D  WRNTY_ITM             11     40
OA   D                 DS
OA   D  RCDESC                 4     28
OA   D  RDSC                   1     30
UO   D                 DS                  INZ
UO   D  BIDCOST                1      2
UO   D  @BCCD                  1      1
UO   D  @DIRPONS               2      2
OA    *
     D LOTSOK          C                   CONST('L O T S   O K')
OA   D PRCMSG          C                   CONST(' - price credits.  ')
     D PM0810        E DS                  EXTNAME(OPPW810)
OJ   D                 DS
OJ   D SRL_FLAGS               1      5    inz(*blanks)
OJ   D  RGAFLG                 1      1
$X   D @P@           E DS                  EXTNAME(@PARMSIQ)
$X   D  @P@500               500    500
OT   Dtabdsc           s                   like(tbno03)
RO    *
RO   d p1300App        s             10    inz('DII')
RO   d p1300Bypass     s              1    inz('N')
¢:   d B2BIn01         s               n
OZ    *
OZ   D prcrflg         s              1
OZ   D svprcfl         s              1
OZ   D repric          s              1
OZ   D prc_crd_qtyok   s              1    inz(*blank)
O4   D cmpprcdt        s              1
QN   D WebCreditCard   S               N   INZ(*OFF)
QN   D Save45          S               N   INZ(*OFF)
QN   D Save44          S               N   INZ(*OFF)
SC   D Save51          S               N   INZ(*OFF)
QQ   D B2B             S               N   INZ(*OFF)
QQ   D B2C             S               N   INZ(*OFF)
QQ   D WcEmail         s                   like(oead04)
QQ   D Lower           c                   Const('abcdefghijklmnopqrstuvwxyz')
QQ   D Upper           c                   Const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
QV   D Save41          S               N   INZ(*OFF)
QV   D svsalid         s                   like(oeid02)
QV   D opnbh           s              1
QX   D svin46          s               n   inz(*off)
TQ   D svin47          s               n   inz(*off)
TF   D svin73          s               n   inz(*off)
UI   D svin03          s               n   inz(*off)
VA   D svin12          s               n   inz(*off)
UW   D svin62          s               n   inz(*off)
UW   D svin63          s               n   inz(*off)
RS   D svcd38          S              1
SV   D opnivw          s              1
SV   D opnivm          s              1
SV   D prcUOMchg       s              1
TJ   d svshbr          s              1
#0   d protectnc       S               N   INZ(*OFF)
#0   d UseWEflag       S               N   INZ(*OFF)
QZ    *...............................................*
QZ    * Begin: Definitions for tax software interface *
QZ    *...............................................*
QZ   D Tax_Date        ds                  inz
QZ   D  Tax_Century            1      2  0
QZ   D  Tax_Year               3      4  0
QZ   D  Tax_Month              5      6  0
QZ   D  Tax_Day                7      8  0
QZ    *
QZ TQD*pTax_lineitems  ds                  occurs(400)
TQ   D pTax_lineitems  ds                  occurs(11000)
QZ   D  Tax_ItmLinNum          1      5
QZ   D  Tax_ItmNumber          6     35
QZ   D  Tax_OrdQty            36     46  4
QZ   D  Tax_ExtAmt            47     55  2
QZ   D  Tax_ItmDesc           56    103
QZ   D  Tax_ItmType          104    104
QZ   D  Tax_ItmTaxCod        105    129
QZ    *
QZ   D Item_totals     s             11s 2 inz
QZ   D PDDS            s             48
QZ TQD*Tax_line_indx   s              3s 0
QZ TQD*Tax_line#       s              4s 0
QZ TQD*PiNumOfItems    s              3  0
TQ   D Tax_line_indx   s              5s 0
TQ   D Tax_line#       s              5s 0
TQ   D PiNumOfItems    s              5  0
QZ   D pCustomerCode   s             30
QZ   D pDocCode        s             30
QZ   D pDocType        s              1  0
QZ   D pDocDate        s              8
QZ   D pSellBr         s              3
QZ   D pShipFromBr     s              3
QZ   D pDAddress1      s             30
QZ   D pDAddress2      s             30
QZ   D pDAddress3      s             30
QZ   D pDCity          s             25
QZ   D pDState         s              2
QZ   D pDCountry       s             30
QZ   D pDZipCode       s             10
QZ   D pCommitTran     s              1
QZ   D POrgOrder       s              7
QZ   D PTaxRate        s              6  6
QZ   D pTaxAmt         s              9  2
QZ   D PGstRate        s              6  6
QZ   D PGstAmt         s              9  2
QZ   D PHstRate        s              6  6
QZ   D PHstAmt         s              9  2
QZ   D PPstRate        s              6  6
QZ   D PPstAmt         s              9  2
QZ   D PTaxableAmt     s              9  2
QZ   D PNTaxableAmt    s              9  2
QZ   D PErrCode        s             50
QZ   D PErrMsg         s            150
QZ    *
QZ   D sOrgOrder       s              7
QZ   D B2C_RGA         S               N   INZ(*OFF)
Q1   D B2B_RGA         S               N   INZ(*OFF)
SE    * Flag used to identify RGAs created from orders
SE    * . that are not B2B/B2C    and
SE    * . are paid by credit card
SY    * (B2B RGAs are only those created from B2B orders that are paid
SY UG * by card using Curbstone)
UG    * by card using card software)
RZ   D regcshRGA       S               N   INZ(*OFF)
Q1   D CCErrWrn        S               N   INZ(*OFF)
Q1   D CCError         S               N   INZ(*OFF)
QZ   D TxsWarnR        S               N   INZ(*OFF)
QZ   D TxsWarnI        S               N   INZ(*OFF)
QZ   D Msg9050         s            150
SP   D ErrCd           s              1
QZ    *
QZ   D                 DS
QZ   DTAXCAL_ENABLED           1      1
QZ   DADDRVAL_ENABLED          2      2
TP   DminTaxCalc               3      3
QZ   DTAXS_CNTRLS              1     30
QZ    *.............................................*
QZ    * End: Definitions for tax software interface *
QZ    *.............................................*
Q1    *.....................................
Q1    * Parms passed to/from OER9600...
Q1 UG * Parms passed to/from OER9600...
UG    * Parms passed to/from card processing program
Q1    *.....................................
Q1   D piMode          S              3
Q1   D piRetry         S              1
Q1   D piUpdError      S              1
Q1   D piTran          S              7
Q1 VDD*piMFUKEY        S             15
VD   D piMFUKEY        S             19
Q1   D piOrgOrd        S              7
Q1   D piMethod        S              2
Q1   D piTrnDtl        S              1
Q1   D piTrnAmt        S              9  2
Q1   D piTaxable       S              1
Q1   D piTaxAmt        S              9  2
Q1   D poSuccess       S              1
Q1   D poMsg           S             78
Q1   D poData          S            256
RZ   D piData          s            256    inz
Q1    *...................................*
Q1 UG * End: Parms passed to/from OER9600 *
UG    * End: Parms passed to/from card processing program
Q1    *...................................*
RA   D insrrn          s                   like(kitrrn)
RA   D inslin          s              1
RC   D taxfaut         s              1
RB   D prcaut          s              1
RB   D cusPrcflg       s              1
RB   D jobPrcFlg       s              1
RB   D alwRprc         s              1
RB   D svin67          s              1
UA   D svin68c         s              1
UA   D REB_CM          S               N   INZ(*OFF)
RB   D jobchg          s              1
RB    *
RZ   D                 ds
RZ   D  using_card             1      1
RZ UGD* card_software          2     30
UG   D  card_software          2     16
VD   D  card_softtype         17     17
RZ   D  card_tabentry          1     30
RZ   D
RZ   D  meth01         s              1
RZ   D  meth03         s              1
RZ   D  svin58         s              1
RZ   D  svoeam36       s                   like(oeam36)
RZ    *
RZ    * PiDet to contain data to be sent to card processing program.
RZ   D  piDet          ds
RZ   D   trantyp                      1    inz('S')
RZ   D   custmr                      10
RZ    * Purchase order as reference transaction
RZ   D   pono#                       22
RZ   D   zipcd                       10
RZ   D   brnch#                       3  0 inz
RZ    * This flag controls saving and display of credit card info in
RZ    * Curbstone processing.
RZ   D   dspCrdFlg                    1
RZ    * This parameter is only sent when creating a record for refunds
RZ   D   cardtype                     4
UG    * Device serial number to be sent for CardConnect                e
UG VRD*  DevSerial#                  20
VR   D   DevSerial#                        like(cc_arnof5)
UR   D   JobNumber                    7
UW   D   Token                             like(cc_arnof6)
UW   D   ExpiryCC                          like(cc_arcc83) inz
UW   D   ExpiryYR                          like(cc_aryr83) inz
UW   D   ExpiryMO                          like(cc_armo83) inz
UW   D   HldrName                          like(cc_arnm70)
UW   D   SaveCard                     1
UW   D   DefCard                      1
UW   D   Misc                        10
U5   D   billzp                      10
U5   D   crdCVV                       4
VD   D   NetTrnID                          like(cc_arnof8)
VI   D   TokenSubmted                      like(cc_arcdm3)
V4   D   TknProvderCd                      like(cc_arcdm8)
RZ    *
RZ   D authData        DS
RZ VDD* authMFUKey                   15
VD   D  authMFUKey                         like(cc_arnob7)
RZ   D  authAmt                      11  2 inz
VD   D  token_added                        like(cc_arnof6)
VD   D  level3_card                   1
RZ    *
RZ   D DifrAmt         s             15  2 inz
RZ   D svaramc7        s                   inz like(CC_aramc7)
RZ   D c@aprvd         c                   const('Card Processing: Approved.')
UG   D c@Neterr        c                   const('SEND/RECEIVE ERROR')
U4   D c@NotStl        c                   const('CANNOT REFUND TODAY')
UG   D save_curbston   s              1    inz(' ')
UG   D save_interface  s              1    inz(' ')
UG   D wNetErr         s              3  0
U4   D wNotStl         s              3  0
RZ   D wRtnCrd         s              1
RZ SED*wPrcSal         s              1
RZ   D rfdToCrd        s              1
RZ   D dspCrdMth       s              1
RZ   D alwCard         s              1    inz('N')
SE   D wRGACM          s              1
&L   D InvOvr1yr       s              1
SE UG * Table setting values for Curbstone credit card processing for
UG    * Table setting values for credit card processing software for
SE    * sales order and RGA credit memo
SE    * If wPrcSal=Y, the sale is immediate, else it is a 2-step process
SE    * of verification and then approval
SE    * Similarly with wPrcRGA, if Y, immediate refund, else 2-step.
SE   D                 ds
SE   D WprcCCRD                1     30
SE   D  wPrcSal                1      1
SE   D  wPrcRGA                2      2
SI    *
SI    * Flag to decide if cash RGAs are to be paid back to original
SI    * payment methods on sales order of RGA
SI   D  wRstRfd        s              1
SI   D  svin77         s               n       inz(*off)
SI   D  svin78         s               n       inz(*off)
SI   D  svin59         s               n       inz(*off)
SI   D  svin60         s               n       inz(*off)
SI   D  kRefOrd        s                       like(oeno14)
SI   D  depBal         s                       like(oeam22)
SE SMD*wCsh            s               n   inz(*off)
SE SMD*wChq            s               n   inz(*off)
SL    * Flag for card used for payment on original order
SL   D wOrigCrd        s              1
UU   D wOrigMerchID    s                   like(cc_arid06)
SM   D wTcct           s              1
SM   D wGenOrder       s               n   inz(*off)
SQ   D sigsmart        s              1    inz
SW   D @oeno01         s                   Like(oeno01)
SW   D @oeno22         s                   like(oeno22)
SZ    * order being placed on credit hold event
SZ   D d_HDE0020       DS           256    inz
SZ   D  ordE20                        7a
SZ   D  comE20                        3s 0
SZ   D  divE20                        3a
SZ   D  regE20                        3a
SZ   D  sbrE20                        3s 0
SZ   D  bnmE20                       25a
SZ   D  usrE20                       10a
SZ   D  cusE20                        6s 0
SZ   D  cnmE20                       30a
TN    * Sales order released from credit hold
TN   D d_HDE0037       DS           256    inz
TN   D  ordE37                        7a
TN   D  usrE37                       10a
TN   D  sbrE37                        3s 0
TN   D  sidE37                        3a
TN   D  entE37                        3a
TN   D  comE37                        3s 0
TN   D  divE37                        3a
TN   D  regE37                        3a
TN    *
TQ    * Future use field
TQ   D PiMisc          ds            10
TQ   D OrdHdrTaxFlag                  1    overlay(pimisc:1)
TQ    *
UG    * ---------------------------------------------------------------
UG    * HDE0056 Event Data/Filter
UG    * ---------------------------------------------------------------
UG   D d_hde0056       ds           256    inz
UG   D  wbranch                       3  0
UG   D  wuser                        10a
UG   D  transtyp                      1a
UG   D  trans                         7a
UG   D  trans2                        7a
UG   D  wcust#                        6a
UG   D  custname                     30a
UG   D  eventtype                     1a
UG    *
UI    * ---------------------------------------------------------------
UI    * HDE0060 Event Data/Filter
UI    * ---------------------------------------------------------------
UI   D d_hde0060       ds           256    inz
UI   D  hbranch                       3  0
UI   D  huser                        10a
UI   D  hTrans                        7a
UI   D  hcust#                        6a
UI   D  hcustname                    30a
UI   D  hbatch#                       5a
UI   D  hrun#                         7a
UI   D  heventtype                    1a
UI   D  htrantype                     1a
UI    *
#L   D                 DS
#L   D  PL2024                 1     17
#L   D  ORDBR                  1     10
#L   D  PICSEQ                16     16
#L    *
TC   D obj             s             10    inz(*blanks)
TI   D svin49          s              1
TI   D  trn_typ        s              3    inz('S/O')
TI   D  taxwrn         s              1    inz(' ')
TI   D msgdsp          s              1
TI   D wTaxTyp         s              5
TI    *
TI   DpiLine1          s                   like(arad01)
TI   DpiLine2          s                   like(arad02)
TI   DpiLine3          s                   like(arad03)
TI   DpiCity           s                   like(arcy01)
TI   DpiState          s                   like(arst01)
TI   DpiZip            s                   like(arzp15)
TI   DpiCountry        s             30
TI   DPoErrCode        s             50
TI   DPoErrMessage     s            100
TI   DtaxCalType       s              1
TI   DPiFrtAmt         s              7  2  inz
TI   DPiFrtDesc        s             20
TI   DPiDelAmt         s              7  2  inz
TI   DPiDelDesc        s             20
TI   DPiHdlAmt         s              7  2  inz
TI   DPiHdlDesc        s             20
TI   DPiRstAmt         s              7  2  inz
TI   DPiRstDesc        s             20
TI   DPiOthAmt         s              7  2  inz
TI   DPiOthDesc        s             20
VU   DPiCCPAmt         s              7  2  inz
VU   DPiCCPDesc        s             20
TI   D PiTranType      s              3
TI   D PiTranNum       s              7
TI   D PiCustNum       s              6  0 inz
TI   D PiAPIRqstTyp    s              3
TI   D PiDocCode       s             30
TI   D PiDocType       s              1  0  inz
TI   D PiTaxSts        s              2
TI   D PiTaxErrCd      s              2
TI   D PiTaxRate       s              6  6  inz
TI   D PiGSTRate       s              6  6  inz
TI   D PiHSTRate       s              6  6  inz
TI   D PiPSTRate       s              6  6  inz
TI   D PiGSTAmt        s              9  2  inz
TI   D PiHSTAmt        s              9  2  inz
TI   D PiPSTAmt        s              9  2  inz
TI   D PiTaxblAmt      s              9  2  inz
TI   D PiNTaxblAmt     s              9  2  inz
TI   D PiAPIErrMsg     s             50
TI   D PiBillType      s              2
TI   D PMode           s              1
TI   D pJobNum         s              7
TI   D pCustPONum      s                   like(oeno07)
TI   D kTbl            s                   like(tbno01)
TI   D kDsc            s                   like(tbno03)
TI   D soin58          s              1
TI   D soin59          s              1
TI   D soin60          s              1
TI   D soin61          s              1
TI   D soin62          s              1
TI   D soin67          s              1
TI   D soin68          s              1
TI   D TaxErr          s              1
TI   D PiUpdTax        s              1
TI   D wUpdTax$        S              1
TI   D PiTaxOvrAmt     s              9  2  inz
TI   D othWrn          s              1
TI   D mode            s              1
TI   D tabent2         s                    like(tbno03)
TI   D PiPgmName       s             10
TI TQD*PiMisc          s             10
TI   D PiHdrUpd        s              1
TI   D wItmQty         s              7  0  inz
TI   D svad04          s                    like(arad04)
TI   D svad05          s                    like(arad05)
TI   D svad06          s                    like(arad06)
TI   D svcy02          s                    like(arcy02)
TI   D svzp16          s                    like(arzp16)
TI   D svst02          s                    like(arst02)
TI   D warnFlg         s              1     inz
TI   D wbatyes         s              1     inz
&6   D TaxCalcSkip     s               n    inz
TP   D TaxCalcSkipP    s              1     inz
TP   D TaxCalcSkipO    s              1     inz
TW   D wTempTrans#     s              7     inz
TW   D wTempDocCd      s             26     inz
TZ   D gencsh          s              1
UG   D kDevName        s                   like(arnm71)
UG   D card_interface  s              1
UG   D dTyp            s              1
UG   D rgaerr          s                   like(msgfld)
UG   Dinfo_msg         s             78
UI   D wDefTax         s              1
UI   D save_no24       s                   like(oeno24)
UI   D save_pc02       s                   like(oepc02)
UI   D taxneterr       s              1
UI   D save_taxType    s              1
UI   D SvIn45          S               N   INZ(*OFF)
UL   D svfxEmail       S              1    inz
UL   D svprtprc        S              1    inz
UM   D AUTHQTY         S              1    INZ
UN   D AUTHPRT         S              1    INZ
UW   D COF_Mode        S              1
UW   D Cust_Type       S              1
UW   D Cust_Num        S                   like(arno01)
UW   D PoToken         S                   like(cc_arnof6)
UW   D PoExpcc         S                   like(cc_arcc83)
UW   D PoExpyr         S                   like(cc_aryr83)
UW   D PoExpmo         S                   like(cc_armo83)
UW   D PoNAME          S                   like(cc_arnm70)
VD   D PoNetTrnID      S                   like(arnof8)
VD   D L3_Card_Used    S              1
VD   D NegQty_flag     S              1
VI   D PoTokenSubmted  S                   like(arcdm3)
UW   D cdf4            S                   like(arcdf4)
UW   D kfla5           S                   like(arfla5)
U5   D usingAVS        s             10
U5   D usingCVV        s             10
VD   D PoErrCode_L3    s             50
VD   D PoErrMsg_L3     s            150
VJ   D Au_RprcRcst     s              1    inz
VM   D PiTaxMOS        s                   like(oecd01)
VM   D PiTaxOrdTyp     s                   like(oecd08)
VM   D PiTaxGenRef     s                   like(oeno26)
VM   D PiTaxShpSt      s                   like(arst02)
VM   D PoTaxAmt1       s                   like(oeam04)
VM   D PoTaxNum1       s              8  0
VO   D AddOn_OvrPct    S              4  3 inz
VQ   D DEPWDW          s              1    inz
VQ   D DEPWDWDSPD      s              1    inz
$Z   DSMLORDAMT        S              7S 0
%G    * Order Fulfillments
%G   d WrkOENO01       s              7a   Inz
%G   d WrkFFLSTS       s              1a   Inz
%G   D Wrk_FL          s               n
%G   d WrkPgm          s             10a   Inz('OER2063')
%G   d WrkDFNO15       s              3s 0 Inz
%G   d WrkOENO08       s              3s 0 Inz
%G   d WrkOECD01       s              1a   Inz
%G   d WrkARCDC6       s              2a   Inz
!¢4  d GetDevName      pr                  EXTPGM('OERG9702')
!¢4  d                                3P 0
!¢4  d                               10a
!¢4  d                               30a
%D   D UP              C                   CONST('ABCDEFGHIJKLMNOPQRS-
%D   D                                     TUVWXYZ')
#9   D                 DS
#9   D  ENTER_CC               1      2  0
#9   D  ENTER_YR               3      4  0
#9   D  ENTER_MO               5      6  0
#9   D  ENTER_DY               7      8  0
#9   D  ENTER_DT               1      8  0
*a    * Card Connect API
*a     dcl-pr CardConnectTransa extpgm('OEREXTI4');
*a       out_TrnType      char(1);       // D=Depost S=Sales Order
*a       out_SalesOrder   char(7);       //
*a       out_Deposit      char(7);       //
*a       out_CreditMemo   char(7);       //
*a       out_ReqAmount    packed(9:2);   //
*a       out_ReqStst      char(2);       // IQ Inquiry or RF Refund
*a       out_PgmName      char(20);      //
*a       out_Branch       packed(3:0);   // Transaction Branch
*a       out_OriginalOdr  char(7);       // Original Order Number
*a       out_PurchaseOdr  char(22);      // Purchase Order Number
*a       out_TaxableFlag  char(1);       // Taxable flag
*a       out_TaxAmount    packed(9:2);   // Tax Amount
*a       out_ErrMsg       char(80);
*a     end-pr;
*a
*a     dcl-s  @TrnType     char(1)     inz;
*a     dcl-s  @SalesOrder  char(7)     inz;
*a     dcl-s  @Deposit     char(7)     inz;
*a     dcl-s  @CreditMemo  char(7)     inz;
*a     dcl-s  @ReqAmount   packed(9:2) inz;
*a     dcl-s  @ReqStst     char(2)     inz;
*a     dcl-s  @PgmName     char(20)    inz;
*a     dcl-s  @Branch      packed(3:0) inz;
*a     dcl-s  @OriginalOdr char(7)     inz;
*a     dcl-s  @PurchaseOdr char(22)    inz;
*a     dcl-s  @TaxableFlag char(1)     inz;
*a     dcl-s  @TaxAmount   packed(9:2) inz;
*a     dcl-s  @StsMsg      char(80)    inz;
*a     dcl-s  MGTCardConnect  ind      inz;
!¢4    dcl-s  MGTAuthorization ind     inz;
!¢4    dcl-s  Save_ECOMAMT     like(ECOMAMT) inz;
!¢4    dcl-s  txtLine1         char(70)      inz;
!¢4    dcl-s  txtLine2         char(70)      inz;
!¢4    dcl-s  PopResponse      char(1)       inz;
!¢4    dcl-s  CopyIn60         ind           inz;
!¢4    dcl-s  CopyIn66         ind           inz;

&7     // Input item array
&7     dcl-ds termItemArray likeds(PCTERMS_Item_t) dim(9999);

&7     // Return data structure
&7     dcl-ds returnData likeds(PCTERMS_Return_t);

      *------------------------------------------------------------------------*
     IARFTWI
     I              ARNO15                      XXNO15
     I              OENO30                      XXNO30
     IARFMBAL
     I              ARNO16                      XXNO16
     I              ARAM01                      CBAM01
     I              ARFL03                      BALFLG
     I              ARMO12                      MO12
     I              ARDY12                      DY12
     I              ARCC12                      CC12
     I              ARYR12                      YR12
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
     IARFMCUS
     I              ARAM01                      CSAM01
     IARFMENT
     I              ARMO09                      EMO09
     I              ARDY09                      EDY09
     I              ARCC09                      ECC09
     I              ARYR09                      EYR09
     I              ARNM03                      ENM03
     IOEFTOH
     I              ARNO15                      NO15
     I              OECD13                      LSTTRD
     I              OEMO07                      MO07
     I              OEDY07                      DY07
     I              OECC07                      CC07
     I              OEYR07                      YR07
     I              ARCDF9                      HDRCF9
     IOEFTOC
     I              ARNO15                      NO15
     I              OEAM04                      A04
     I              OEAM06                      A06
     I              OEAM07                      A07
     I              OEAM08                      A08
     I              OECC02                      C02
     I              OEDY02                      D02
     I              OEMO02                      M02
     I              OENM01                      NM01
     I              OENO10                      N10
     I              OENO11                      N11
     I              OETL01                      T01
     I              OEYR02                      Y02
     I              OEAM36                      A36
     I              OETM04                      T04
     I              OEAM44                      A44
     IOEFTOA
     I              ARNO15                      NO15
     IOEFTOR
     I              ARNO15                      NO15
     I              OEFL08                      FL08
     IOEFTOM
     I              ARNO15                      NO15
     IOEFTOHJ
     I              ARNO01                      AHNO01
     I              OENO01                      OHNO01
     I              OENO02                      OHNO02
     I              OENO03                      OHNO03
     I              OENO04                      OHNO04
     I              OENO05                      OHNO05
     I              OENO06                      OHNO06
     I              OENO07                      OHNO07
     I              OENO08                      OHNO08
     I              OENO14                      OHNO14
     I              OECD01                      OHCD01
     I              OECD03                      OHCD03
     I              OECD04                      OHCD04
     I              OECD05                      OHCD05
     I              OECD07                      OHCD07
     I              OECD08                      OHCD08
     I              OEFL02                      OHFL02
     I              OEFL03                      OHFL03
     I              OEFL04                      OHFL04
     I              OEFL05                      OHFL05
     I              OEFL06                      OHFL06
     I              OEFL07                      OHFL07
     I              OEFL08                      OHFL08
     I              OEFL09                      OHFL09
     I              OEFL10                      OHFL10
     I              OECN01                      OHCN01
     I              OEDN01                      OHDN01
     I              OEPC02                      OHPC02
     I              OENM02                      OHNM02
     I              OEID01                      OHID01
     I              OEID02                      OHID02
     I              OEAM04                      OHAM04
     I              OETL01                      OHTL01
     I              OETL02                      OHTL02
     I              OETL03                      OHTL03
     I              OETL04                      OHTL04
     I              ARMO01                      AHMO01
     I              ARCC01                      AHCC01
     I              ARYR01                      AHYR01
     I              ARMO05                      AHMO05
     I              ARDY05                      AHDY05
     I              ARCC05                      AHCC05
     I              ARYR05                      AHYR05
     I              ARMO06                      AHMO06
     I              ARDY06                      AHDY06
     I              ARCC06                      AHCC06
     I              ARYR06                      AHYR06
     I              OEMO01                      OHMO01
     I              OEDY01                      OHDY01
     I              OECC01                      OHCC01
     I              OEYR01                      OHYR01
     I              OEMO02                      OHMO02
     I              OEDY02                      OHDY02
     I              OECC02                      OHCC02
     I              OEYR02                      OHYR02
     I              OENM01                      OHNM01
     I              OECD10                      OHCD10
     I              OETM01                      OHTM01
     I              OETM02                      OHTM02
     I              OEMO03                      OHMO03
     I              OEDY03                      OHDY03
     I              OECC03                      OHCC03
     I              OEYR03                      OHYR03
     I              OEMO04                      OHMO04
     I              OEDY04                      OHDY04
     I              OECC04                      OHCC04
     I              OEYR04                      OHYR04
     I              OEMO05                      OHMO05
     I              OEDY05                      OHDY05
     I              OECC05                      OHCC05
     I              OEYR05                      OHYR05
     I              OENO15                      OHNO15
     I              ARNO15                      AHNO15
     I              ARCD14                      AHCD14
     I              ARCD15                      AHCD15
     I              OECD13                      OHCD13
     I              OECD15                      OHCD15
     I              OECD16                      OHCD16
     I              OECD17                      OHCD17
     I              OECD18                      OHCD18
     I              OECD19                      OHCD19
     I              OECD20                      OHCD20
     I              OECD21                      OHCD21
     I              OECD22                      OHCD22
     I              OECD23                      OHCD23
     I              OECD25                      OHCD25
     I              OEAM12                      OHAM12
     I              OEAM13                      OHAM13
     I              OETL05                      OHTL05
     I              OENO18                      OHNO18
     I              OENO19                      OHNO19
     I              OENO20                      OHNO20
     I              OECN02                      OHCN02
     I              OECN03                      OHCN03
     I              ARCD25                      AHCD25
     I              ARCD26                      AHCD26
     I              OEMO07                      OHMO07
     I              OEDY07                      OHDY07
     I              OECC07                      OHCC07
     I              OEYR07                      OHYR07
     I              OEPC03                      OHPC03
     I              OECD32                      OHCD32
     I              OEMO08                      OHMO08
     I              OECC08                      OHCC08
     I              OEYR08                      OHYR08
     I              OEAM15                      OHAM15
     I              OECD33                      OHCD33
     I              OECD36                      OHCD36
     I              OECD37                      OHCD37
     I              OECD38                      OHCD38
     I              OECD39                      OHCD39
     I              OENO24                      OHNO24
     I              OECN05                      OHCN05
     I              OECD48                      OHCD48
     I              OENO26                      OHNO26
     I              OENO16                      OHNO16
     I              OEAM26                      OHAM26
     I              OEAM27                      OHAM27
     I              OEFL15                      OHFL15
     I              ARCDB5                      AHCDB5
     I              ARCDB6                      AHCDB6
     I              OETL12                      OHTL12
     I              OECD67                      OHCD67
     I              OECD65                      OHCD65
     I              ARCDC6                      AHCDC6
     I              OEPC08                      OHPC08
     I              OECD86                      OHCD86
     I              OECD98                      OHCD98
     I              OEMO25                      OHMO25
     I              OEDY25                      OHDY25
     I              OECC25                      OHCC25
     I              OEYR25                      OHYR25
     I              OETM08                      OHTM08
OA   I              OEFL31                      OHFL31
OA   I              OEAM62                      OHAM62
OA   I              OEAM63                      OHAM63
OA   I              OECDB1                      OHCDB1
OA   I              OEFL33                      OHFL33
     I              ARCDF9                      ACMCF9
QJ   I              OENO83                      OHNO83
O5   I              OENM15                      OHNM15
     IOEFTOHYJ
     I              ARNO01                      AYNO01
     I              OENO01                      OYNO01
     I              OENO02                      OYNO02
     I              OENO03                      OYNO03
     I              OENO04                      OYNO04
     I              OENO05                      OYNO05
     I              OENO06                      OYNO06
     I              OENO07                      OYNO07
     I              OENO08                      OYNO08
     I              OENO14                      OYNO14
     I              OECD01                      OYCD01
     I              OECD03                      OYCD03
     I              OECD04                      OYCD04
     I              OECD05                      OYCD05
     I              OECD07                      OYCD07
     I              OECD08                      OYCD08
     I              OEFL02                      OYFL02
     I              OEFL03                      OYFL03
     I              OEFL04                      OYFL04
     I              OEFL05                      OYFL05
     I              OEFL06                      OYFL06
     I              OEFL07                      OYFL07
     I              OEFL08                      OYFL08
     I              OEFL09                      OYFL09
     I              OEFL10                      OYFL10
     I              OECN01                      OYCN01
     I              OEDN01                      OYDN01
     I              OEPC02                      OYPC02
     I              OENM02                      OYNM02
     I              OEID01                      OYID01
     I              OENM15                      OYNM15
     I              OEID02                      OYID02
     I              OEAM04                      OYAM04
     I              OETL01                      OYTL01
     I              OETL02                      OYTL02
     I              OETL03                      OYTL03
     I              OETL04                      OYTL04
     I              ARMO01                      AYMO01
     I              ARCC01                      AYCC01
     I              ARYR01                      AYYR01
     I              ARMO05                      AYMO05
     I              ARDY05                      AYDY05
     I              ARCC05                      AYCC05
     I              ARYR05                      AYYR05
     I              ARMO06                      AYMO06
     I              ARDY06                      AYDY06
     I              ARCC06                      AYCC06
     I              ARYR06                      AYYR06
     I              OEMO01                      OYMO01
     I              OEDY01                      OYDY01
     I              OECC01                      OYCC01
     I              OEYR01                      OYYR01
     I              OEMO02                      OYMO02
     I              OEDY02                      OYDY02
     I              OECC02                      OYCC02
     I              OEYR02                      OYYR02
     I              OENM01                      OYNM01
     I              OECD10                      OYCD10
     I              OETM01                      OYTM01
     I              OETM02                      OYTM02
     I              OEMO03                      OYMO03
     I              OEDY03                      OYDY03
     I              OECC03                      OYCC03
     I              OEYR03                      OYYR03
     I              OEMO04                      OYMO04
     I              OEDY04                      OYDY04
     I              OECC04                      OYCC04
     I              OEYR04                      OYYR04
     I              OEMO05                      OYMO05
     I              OEDY05                      OYDY05
     I              OECC05                      OYCC05
     I              OEYR05                      OYYR05
     I              OENO15                      OYNO15
     I              ARNO15                      AYNO15
     I              ARCD14                      AYCD14
     I              ARCD15                      AYCD15
     I              OECD13                      OYCD13
     I              OECD15                      OYCD15
     I              OECD16                      OYCD16
     I              OECD17                      OYCD17
     I              OECD18                      OYCD18
     I              OECD19                      OYCD19
     I              OECD20                      OYCD20
     I              OECD21                      OYCD21
     I              OECD22                      OYCD22
     I              OECD23                      OYCD23
     I              OECD25                      OYCD25
     I              OEAM12                      OYAM12
     I              OEAM13                      OYAM13
     I              OETL05                      OYTL05
     I              OENO18                      OYNO18
     I              OENO19                      OYNO19
     I              OENO20                      OYNO20
     I              OECN02                      OYCN02
     I              OECN03                      OYCN03
     I              ARCD25                      AYCD25
     I              ARCD26                      AYCD26
     I              OEMO07                      OYMO07
     I              OEDY07                      OYDY07
     I              OECC07                      OYCC07
     I              OEYR07                      OYYR07
     I              OEPC03                      OYPC03
     I              OECD32                      OYCD32
     I              OEMO08                      OYMO08
     I              OECC08                      OYCC08
     I              OEYR08                      OYYR08
     I              OEAM15                      OYAM15
     I              OECD33                      OYCD33
     I              OECD36                      OYCD36
     I              OECD37                      OYCD37
     I              OECD38                      OYCD38
     I              OECD39                      OYCD39
     I              OENO24                      OYNO24
     I              OECN05                      OYCN05
     I              OECD48                      OYCD48
     I              OENO26                      OYNO26
     I              OENO16                      OYNO16
     I              OEAM26                      OYAM26
     I              OEAM27                      OYAM27
     I              OEFL15                      OYFL15
     I              ARCDB5                      AYCDB5
     I              ARCDB6                      AYCDB6
     I              OETL12                      OYTL12
     I              OECD67                      OYCD67
     I              OECD65                      OYCD65
     I              ARCDC6                      AYCDC6
     I              OEPC08                      OYPC08
     I              OECD86                      OYCD86
     I              OECD98                      OYCD98
     I              OEMO25                      OYMO25
     I              OEDY25                      OYDY25
     I              OECC25                      OYCC25
     I              OEYR25                      OYYR25
     I              OETM08                      OYTM08
OA   I              OEFL31                      OYFL31
OA   I              OEAM62                      OYAM62
OA   I              OEAM63                      OYAM63
OA   I              OECDB1                      OYCDB1
OA   I              OEFL33                      OYFL33
     I              ARCDF9                      YCMCF9
QJ   I              OENO83                      OYNO83
     IOEFTOL
     I              ARNO15                      NO15
     I              OENO08                      NO08
     I              IVDN02                      D2
     I              IVNO01                      N1
     I              IVNO02                      N2
     I              IVNO03                      N3
     I              IVNO04                      N4
     I              IVNO07                      N7
     I              IVNO23                      N23
     I              OEAM01                      A1
     I              OEAM02                      A2
     I              OEAM05                      A5
     I              OEAM18                      A18
N1   I              OEAMEF                      AEF
N1   I              OEAMEC                      AEC
PE   I              OEAMER                      AER
     I              OEAM14                      A14
N1   I              OEAMWF                      AWF
N1   I              OEAMWC                      AWC
PE   I              OEAMWR                      AWR
     I              OEAM17                      A17
     I              OENO09                      N9
     I              OEPC01                      P1
     I              OEQY01                      Q1
     I              OEQY02                      Q2
     I              OEQY03                      Q3
     I              ARMO06                      MO06
     I              ARDY06                      DY06
     I              ARCC06                      CC06
     I              ARYR06                      YR06
     I              ARMO01                      MO01
     I              ARCC01                      CC01
     I              ARYR01                      YR01
     I              OENO14                      NO14
     I              OECD03                      CD03
     I              OECD04                      CD04
     I              OECD08                      CD08
     I              OEMO07                      MO07
     I              OEDY07                      DY07
     I              OECC07                      CC07
     I              OEYR07                      YR07
     I              OEAM38                      A38
     I              OEAM39                      A39
     I              OEAM40                      A40
     I              OEAM41                      A41
     I              OEAM42                      A42
     I              OEQY14                      Q14
     I              OEQY15                      Q15
     I              OEQY16                      Q16
     I              OEQY07                      Q07
S0   I              OEAMWR_S                    AWR_S
S0   I              OEAMER_S                    AER_S
MO   IIVFMNSB
MO   I              IVNO10                      NBNO10
MO   I              IVNON1                      NBNON1
MO   I              IVQY01                      NBQY01
MO   I              IVQY23                      NBQY23
MO   I              IVAMW6                      NBAMW6
N1   I              IVAMWF                      NBAMWF
N1   I              IVAMWC                      NBAMWC
PE   I              IVAMWR                      NBAMWR
MO   I              IVNM01                      NBNM01
MO   I              IVMO01                      NBMO01
MO   I              IVDY01                      NBDY01
MO   I              IVCC01                      NBCC01
MO   I              IVYR01                      NBYR01
MO   I              IVMO04                      NBMO04
MO   I              IVDY04                      NBDY04
MO   I              IVCC04                      NBCC04
MO   I              IVYR04                      NBYR04
S0   I              IVAMWR_S                    NBAMWR_S
     IARFMBCH
     I              ARCD04                      CD04B
     IARFMSLS
     I              ARNO15                      RXNO15
     I              ARNO16                      RXNO16
     I              ARCD14                      RXCD14
     I              ARCD15                      RXCD15
     I              ARID01                      RXID01
     I              ARNM03                      RXNM03
     I              ARMO09                      RXMO09
     I              ARDY09                      RXDY09
     I              ARCC09                      RXCC09
     I              ARYR09                      RXYR09
     IARFMTXS
     I              ARNO16                      NO16
     I              ARCD04                      TCD04
   MRI*OEFTSR1
   MRI*             ARNO15                      XXNO15
   MRI*             OENO01                      RNOE01
   MRI*             OENO22                      RNOE22
   MRI*             IVNO07                      RNIV07
   MRI*             OENO25                      RNOE25
   MRI*             ARNO01                      RNAR01
   MRI*             OECD46                      RNCD46
   MRI*OEFTSRY
   MRI*             ARNO15                      XXNO15
   MRI*OEFTSR2
   MRI*             ARNO15                      XXNO15
     IOEFTOT
     I              ARNO15                      NO15
     IPOFTOL
     I              PONO01                      PN1
     I              PONO05                      PN5
     I              IVNO07                      PN7
     I              IVNO22                      PN22
     I              IVNO93                      PN93
     IPOFTOL5
     I              PONO01                      PN1
     I              PONO05                      PN5
     I              IVNO07                      PN7
     I              IVNO22                      PN22
     I              IVNO93                      PN93
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
N1   I              OEAMWF                      OAAMWF
N1   I              OEAMWC                      OAAMWC
PE   I              OEAMWR                      OAAMWR
     I              OEAM17                      OAAM17
     I              OEAM18                      OAAM18
N1   I              OEAMEF                      OAAMEF
N1   I              OEAMEC                      OAAMEC
PE   I              OEAMER                      OAAMER
     I              OECC02                      OACC02
     I              OECC03                      OACC03
     I              OECC07                      OACC07
     I              OECD03                      OACD03
     I              OECD09                      OACD09
     I              OECD26                      OACD26
     I              OECD27                      OACD27
     I              OECD28                      OACD28
     I              OECD30                      OACD30
     I              OECD55                      OACD55
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
     I              EINO22                      OANO22
     I              OENO32                      OANO32
     I              OENO33                      OANO33
     I              OENO35                      OANO35
     I              OENO36                      OANO36
     I              OENO37                      OANO37
     I              OEPC01                      OAPC01
     I              OEPC04                      OAPC04
     I              OEQY06                      OAQY06
     I              OEQY10                      OAQY10
     I              OEQY11                      OAQY11
     I              OETM01                      OATM01
     I              OEYR02                      OAYR02
     I              OEYR03                      OAYR03
     I              OEYR07                      OAYR07
     I              OEQY13                      OAQY13
     I              OECD31                      OACD31
     I              OECD43                      OACD43
     I              OEPC07                      OAPC07
     I              OECD66                      OACD66
     I              OEAM41                      OAAM41
     I              OEAM42                      OAAM42
     I              OECD47                      OACD47
     I              PONO01                      OAPN01
     I              PONO05                      OAPN05
     I              OECD72                      OACD72
     I              OEAM46                      OAAM46
     I              OEAM47                      OAAM47
     I              OEAM38                      OAAM38
     I              OEAM39                      OAAM39
     I              OEAM40                      OAAM40
S0   I              OEAMWR_S                    OAAMWR_S
S0   I              OEAMER_S                    OAAMER_S
     IOEFTOAH
     I              ARCC05                      AHCC05
     I              ARCD25                      AHCD25
     I              ARCD26                      AHCD26
     I              ARDY05                      AHDY05
     I              ARMO05                      AHMO05
     I              ARNO01                      AHNO01
     I              ARNO15                      AHNO15
     I              ARYR05                      AHYR05
     I              OEAM23                      AHAM23
     I              OECC02                      AHCC02
     I              OECC03                      AHCC03
     I              OECC07                      AHCC07
     I              OECC14                      AHCC14
     I              OECC15                      AHCC15
     I              OECC16                      AHCC16
     I              OECC17                      AHCC17
     I              OECD03                      AHCD03
     I              OECD05                      AHCD05
     I              OECD13                      AHCD13
     I              OECD18                      AHCD18
     I              OECD33                      AHCD33
     I              OECD58                      AHCD58
     I              OECN06                      AHCN06
     I              OEDY02                      AHDY02
     I              OEDY03                      AHDY03
     I              OEDY07                      AHDY07
     I              OEDY14                      AHDY14
     I              OEDY15                      AHDY15
     I              OEDY16                      AHDY16
     I              OEDY17                      AHDY17
     I              OEFL06                      AHFL06
     I              OEFL07                      AHFL07
     I              OEFL08                      AHFL08
     I              OEFL09                      AHFL09
     I              OEFL14                      AHFL14
     I              OEID01                      AHID01
     I              OEID02                      AHID02
     I              OEMO02                      AHMO02
     I              OEMO03                      AHMO03
     I              OEMO07                      AHMO07
     I              OEMO14                      AHMO14
     I              OEMO15                      AHMO15
     I              OEMO16                      AHMO16
     I              OEMO17                      AHMO17
     I              OENM01                      AHNM01
     I              OENM02                      AHNM02
     I              OENO01                      AHNO1
     I              OENO06                      AHNO06
     I              OENO07                      AHNO07
     I              OENO08                      AHNO08
     I              OENO24                      AHNO24
     I              OEPC02                      AHPC02
     I              OETL06                      AHTL06
     I              OETL07                      AHTL07
     I              OETL08                      AHTL08
     I              OETL09                      AHTL09
     I              OETL10                      AHTL10
     I              OETL11                      AHTL11
     I              OETM01                      AHTM01
     I              OEYR02                      AHYR02
     I              OEYR03                      AHYR03
     I              OEYR07                      AHYR07
     I              OEYR14                      AHYR14
     I              OEYR15                      AHYR15
     I              OEYR16                      AHYR16
     I              OEYR17                      AHYR17
     I              OEAM29                      OAAM29
     I              OEAM30                      OAAM30
     I              OEFL15                      OAFL15
     I              ARCDB5                      AHCDB5
     I              ARCDB6                      AHCDB6
     I              OETL13                      AHTL13
     I              OEPC08                      AHPC08
     I              OECD86                      AHCD86
     I              ARCDF9                      ARCDF9
     I              OECD01                      AHCD01
     I              OEDN01                      AHDN01
     I              ARCDC6                      AHCDC6
O5   I              OENM15                      AHNM15
     IOEFTBAL
     I              OENO01                      BALO01
     I              ARNO01                      BALA01
     I              ARNO06                      BALA06
     I              ARNO15                      BALA15
     I              OEAM31                      BAL31
     I              OEAM32                      BAL32
     I              OEAM33                      BAL33
     I              OEAM34                      BAL34
     IARFMCAD
     I              ARNO01                      NO01S
     I              ARNM21                      NM21S
     I              ARNO40                      NO40S
     I              ARCD04                      CD04S
     I              ARID01                      ID01S
     IARFCAD2
     I              ARNO01                      NO01S
     I              ARNM21                      NM21S
     I              ARNO40                      NO40S
     I              ARCD04                      CD04S
     I              ARID01                      ID01S
     IOEFTDP
     I              ARNO01                      DANO01
     I              ARNO15                      DANO15
     I              ARNO16                      DANO16
     I              OEAM20                      DPAM20
     I              OEAM21                      DPAM21
     I              OEAM24                      DPAM24
     I              OEAM25                      DPAM25
     I              OEAM37                      DPAM37
     I              OECC02                      DPCC02
     I              OECC10                      DPCC10
     I              OECD50                      DPCD50
     I              OECD52                      DPCD52
     I              OEDN08                      DPDN08
     I              OEDY02                      DPDY02
     I              OEDY10                      DPDY10
     I              OEFL16                      DPFL16
     I              OEMO02                      DPMO02
     I              OEMO10                      DPMO10
     I              OENM01                      DPNM01
     I              OENM14                      DPNM14
     I              OENO01                      DPNO01
     I              OENO10                      DPNO10
     I              OENO11                      DPNO11
     I              OENO30                      DPNO30
     I              OETM04                      DPTM04
     I              OEYR02                      DPYR02
     I              OEYR10                      DPYR10
     IOEFTLLN
     I              OENO01                      LNNO01
     I              OENO31                      LNNO31
     IOEFTOAD
     I              OENO01                      LDNO01
     I              OENO31                      LDNO31
     I              OENO56                      LDNO56
     I              OENO61                      LDNO61
     I              IVNO07                      LDNO07
     I              OEQY18                      LDQY18
     I              OEQY19                      LDQY19
     I              OEQY20                      LDQY20
     I              OEQY21                      LDQY21
     I              OECD85                      LDCD85
     I              OEDN04                      LDDN04
     I              OEDN12                      LDDN12
     I              OEDN13                      LDDN13
     I              PONO01                      LDPN01
     I              ARNO01                      LDAR01
     I              ARNO15                      LDAR15
     IOEFTLD
     I              IVNO07                      LTNO07
     I              OEQY22                      LTQY22
     I              OECD85                      LTCD85
     I              OEDN12                      LTDN12
     I              OEDN13                      LTDN13
     I              OEDN04                      LTDN04
     I              OENO01                      LTNO01
     I              OENO22                      LTNO22
     I              OENO31                      LTNO31
     I              OENO56                      LTNO56
     I              OENO61                      LTNO61
     I              ARNO01                      LTAR01
     I              ARNO15                      LTAR15
US   IAIFHSCH
US   I              OENO08                      WBNO08
US   IAIFMUSR
US   I              OENO08                      WBNO08
VN   IIVFMSTA
VN   I              IVNO07                      QQNO07
      *****************************************************************
      *  SECTION 0         NON-EXECUTABLE STATEMENTS
      *
      * STEP 1.  DECLARE PARAMETER LISTS
      * STEP 2.  KEY LISTS
      *
      *****************************************************************
      * STEP 1. * PARAMETER LIST
      ***********
     C     *DTAARA       DEFINE    *LDA          PARAM
     C                   IN        PARAM
¢A1  C     *DTAARA       DEFINE                  PERZIP
¢A1  C                   IN        perzip
      *
¢W   C     *LIKE         DEFINE    IVNO07        PITM1
¢W   C     *LIKE         DEFINE    IVNO07        PITM2
N4   C     *LIKE         DEFINE    OEAM05        EXTDPRC          +4
N4   C     *LIKE         DEFINE    OEAM05        EXTDPRC1
OH   C     *LIKE         DEFINE    OETL02        SBTL02           +4
OH   C     *LIKE         DEFINE    OETL02        DSBTL02
OH   C     *LIKE         DEFINE    OETL01        GNTL01           +4
OH   C     *LIKE         DEFINE    OETL01        DGNTL01
OH   C     *LIKE         DEFINE    OEAM04        TXTL01           +4
OH   C     *LIKE         DEFINE    OEAM04        DTXTL01
OH   C     *LIKE         DEFINE    OEAM44        GSTL01           +4
OH   C     *LIKE         DEFINE    OEAM44        DGSTL01
NT   C     *LIKE         DEFINE    AFTINV        @AFTINV
OA   C     *LIKE         DEFINE    resamt        @resamt
OA   C     *LIKE         DEFINE    resamt        @svresamt
OA   C     *LIKE         DEFINE    resamt        @svresamt2
OA   C     *LIKE         DEFINE    resamt        @svresamt3
OA   C     *LIKE         DEFINE    OENO01        OAEN01
OA   C     *LIKE         DEFINE    oeam38        oeam38h
OA   C     *LIKE         DEFINE    OENO04        OAEN04
OA   C     *like         define    FOEQY24       @foeqy24
OA   C     *LIKE         DEFINE    OENO22        OLINE#                         SAVE SOURCE
OA   C     *LIKE         DEFINE    resstk        @resstk2
OA   C     *LIKE         DEFINE    resstk        @resstk
OA   C     *LIKE         DEFINE    OENO01        CORD#
OA   C     *LIKE         DEFINE    *IN76         SVIN76
OA   C     *LIKE         DEFINE    oeno01        cmemo
OA   C     *LIKE         DEFINE    oeno22        cseq
     C     *LIKE         DEFINE    OEFL18        SVFL18
     C     *LIKE         DEFINE    OENO22        SVNO22
%W   C     *LIKE         DEFINE    *IN18         SVIN18
%W   C     *LIKE         DEFINE    *IN20         SVIN20
%W   C     *LIKE         DEFINE    *IN21         SVIN21
     C     *LIKE         DEFINE    *IN91         SVIN91
     C     *LIKE         DEFINE    *IN79         SVIN79
     C     *LIKE         DEFINE    *IN74         SVIN74
     C     *LIKE         DEFINE    IVNO05        V#                             EMPTY VEN#
#0   C     *LIKE         DEFINE    IVNO05        WENO05                         VENDOR#
     C     *LIKE         DEFINE    IVNO04        PRT#
      *
     C     *LIKE         DEFINE    OEAM05        GRSAMT
     C     *LIKE         DEFINE    OETL02        TAXAMT
     C     *LIKE         DEFINE    OETL02        NTXAMT
     C     *LIKE         DEFINE    OENO06        SAVN06                         JOB NUMBER
     C     *LIKE         DEFINE    PICKUP        SAVPUP
     C     *LIKE         DEFINE    PICKBY        PICKNM
     C     *LIKE         DEFINE    RRN           RRN@A
     C     *LIKE         DEFINE    RRN           SAVRRN
     C     *LIKE         DEFINE    RRN           SVLRRN
     C     *LIKE         DEFINE    RRN           LOURRN
     C     *LIKE         DEFINE    OEQY03        LOWASQ
     C     *LIKE         DEFINE    OEQY03        ASQ
     C     *LIKE         DEFINE    OEQY03        GSQ
     C     *LIKE         DEFINE    OEQY02        BOCMPQ
     C     *LIKE         DEFINE    OEQY03        SHCMPQ
     C     *LIKE         DEFINE    PRT           SSPRT
     C     *LIKE         DEFINE    SERIL#        SSRIL#
     C     *LIKE         DEFINE    ALIAS         SSLIAS
     C     *LIKE         DEFINE    DIRSPC        SVDMOS
     C     *LIKE         DEFINE    OEFL18        SFL18
     C     *LIKE         DEFINE    OEFL18        SCD03
     C     *LIKE         DEFINE    OECD01        CD01FL
     C     *LIKE         DEFINE    OEQY02        QTY03
     C     *LIKE         DEFINE    OEAM05        GRS02
     C     *LIKE         DEFINE    OEAM05        GRS03
     C     *LIKE         DEFINE    OETL02        BTAXBL
     C     *LIKE         DEFINE    OETL02        CTAXBL
     C     *LIKE         DEFINE    OETL01        BOTL01
     C     *LIKE         DEFINE    OETL01        COTL01
     C     *LIKE         DEFINE    OETL02        BOTL02
     C     *LIKE         DEFINE    OETL02        COTL02
     C     *LIKE         DEFINE    OEAM04        BOAM04
     C     *LIKE         DEFINE    OEAM04        COAM04
     C     *LIKE         DEFINE    OAQY10        REMAIN
     C     *LIKE         DEFINE    OECD03        OE#OTY
     C     *LIKE         DEFINE    OECD03        OE#NTY
     C     *LIKE         DEFINE    OACD03        CO#TYP
     C     *LIKE         DEFINE    OEAM31        DIFF31
     C     *LIKE         DEFINE    OEAM32        DIFF32
     C     *LIKE         DEFINE    OEAM33        DIFF33
     C     *LIKE         DEFINE    OECD04        CCCD04
     C     *LIKE         DEFINE    BKOR          SVBKOR
     C     *LIKE         DEFINE    RESSTK        SVRESS
     C     *LIKE         DEFINE    NO40S         SVNO40                         S/ADD CTL#
     C     *LIKE         DEFINE    NM21S         SVNM21
     C     *LIKE         DEFINE    ARNO01        WKCUST
     C     *LIKE         DEFINE    OENO30        ODEP#
     C     *LIKE         DEFINE    OENO30        SVDEP#
     C     *LIKE         DEFINE    OENO01        OORD#
     C     *LIKE         DEFINE    ARNO01        OCUS#
     C     *LIKE         DEFINE    OENO08        OBR#
     C     *LIKE         DEFINE    OENO30        PVDEP#
     C     *LIKE         DEFINE    OENO30        NEWDEP
     C     *LIKE         DEFINE    DPAM21        NEWRMN
     C     *LIKE         DEFINE    OEAM42        SVAM1
     C     *LIKE         DEFINE    OEAM40        SVAM2
     C     *LIKE         DEFINE    OEAM40        CST1
     C     *LIKE         DEFINE    OEAM40        COST
     C     *LIKE         DEFINE    OEAM40        COSTG
     C     *LIKE         DEFINE    OEAM01        GRS1
     C     *LIKE         DEFINE    OECD65        SVSHPC
     C     *LIKE         DEFINE    CROW          ROW
     C     *LIKE         DEFINE    CCOL          COL
     C     *LIKE         DEFINE    CRCD          CRCD#
     C     *LIKE         DEFINE    CFLD          CFLD#
     C     *LIKE         DEFINE    OEID02        ID02#
     C     *LIKE         DEFINE    OENO06        NO06#
     C     *LIKE         DEFINE    ZZNO04        SVNO04          - 1
     C     *LIKE         DEFINE    IVNO04        SVLU04
     C     *LIKE         DEFINE    OEPC07        PC07A                          COMBO TERMS DSC
     C     *LIKE         DEFINE    OEPC07        SV07A                          COMBO TERMS DSC
     C     *LIKE         DEFINE    OECD66        CD66A                          COMBO TERMS OVR
     C     *LIKE         DEFINE    OECD43        CD43A                          COMBO NC ITEM
#0   C     *LIKE         DEFINE    OECD43        WECD43                         COMBO NC ITEM
     C     *LIKE         DEFINE    OECD03        SVCD03                         SAVE CSH/CHG
     C     *LIKE         DEFINE    ARCDF9        CSCDF9                         CUST TERMS CODE
     C     *LIKE         DEFINE    ARCDB5        CSCDB5                         CUST TERMS Y/N
     C     *LIKE         DEFINE    ARCD25        CSCD25                         CUST TERMS PCT
     C     *LIKE         DEFINE    ARCDF9        JBCDF9                         JOB TERMS CODE
     C     *LIKE         DEFINE    ARCDB5        JBCDB5                         JOB TERMS Y/N
     C     *LIKE         DEFINE    ARCD25        JBCD25                         JOB TERMS PCT
     C     *LIKE         DEFINE    ARCDF9        ORCDF9                         ORDER TERMS CODE
     C     *LIKE         DEFINE    ARCDB5        ORCDB5                         ORDER TERMS Y/N
     C     *LIKE         DEFINE    ARCD25        ORCD25                         ORDER TERMS PCT
     C     *LIKE         DEFINE    ARCDF9        OVCDF9                         OVRRDE TERMS CODE
     C     *LIKE         DEFINE    ARCDB5        OVCDB5                         OVRRDE TERMS Y/N
     C     *LIKE         DEFINE    ARCD25        OVCD25                         OVRRDE TERMS PCT
     C     *LIKE         DEFINE    OECD03        ORGC03
     C     *LIKE         DEFINE    OENO06        ORGN06
     C     *LIKE         DEFINE    ARCDF9        SVCDF9                         SAVE TERMS CODE
     C     *LIKE         DEFINE    ARCDB5        LSCDB5                         LAST TERMS Y/N
     C     *LIKE         DEFINE    ARCD25        LSCD25                         LAST TERMS DISC
     C     *LIKE         DEFINE    OETL12        WKTL12                         CALC TERMS DISC
     C     *LIKE         DEFINE    OEQY01        SVQY01
     C     *LIKE         DEFINE    OEQY02        SVQY02
     C     *LIKE         DEFINE    OEQY03        SVQY03
     C     *LIKE         DEFINE    OEDN04        SVDN04
     C     *LIKE         DEFINE    OEID01        SAVEDI
     C     *LIKE         DEFINE    OECD04        ONEDI
     C     *LIKE         DEFINE    OECD04        ONPOA
     C     *LIKE         DEFINE    OECD04        ONSHP
     C     *LIKE         DEFINE    OECD04        EDICUS
     C     *LIKE         DEFINE    OECD08        SVCD08                         SAVE CSH/CHG
     C     *LIKE         DEFINE    *YEAR         PRMMNY
     C     *LIKE         DEFINE    *YEAR         PRMMXY
     C     *LIKE         DEFINE    *YEAR         OECY07
     C     *LIKE         DEFINE    IVDN41        RUOM                           REF UOM
     C     *LIKE         DEFINE    IVQYZ9        RQTY                           REF QTY
     C     *LIKE         DEFINE    OEQY01        CNVRND
     C     *LIKE         DEFINE    OEQY01        WRKQTY
     C     *LIKE         DEFINE    OENO22        KITRRN
     C     *LIKE         DEFINE    OENO22        LOTRRN
     C     *LIKE         DEFINE    OEAM40        SVPRC
     C     *LIKE         DEFINE    OEAM40        PRC1
     C     *LIKE         DEFINE    OEAM40        PRICC
     C     *LIKE         DEFINE    OEAM40        PRICG
     C     *LIKE         DEFINE    OEQY02        SVQTY
     C     *LIKE         DEFINE    OEID02        SAVSLM
     C     *LIKE         DEFINE    FACTOR        SVFCTR                                     DE
     C     *LIKE         DEFINE    OEAM44        BOAM44
     C     *LIKE         DEFINE    OEAM45        COAM45
     C     *LIKE         DEFINE    OECD38        CF09                           CRD HLD FLG
      * The following fields are for passing data to/from OER9300;
     C     *LIKE         DEFINE    AHTL09        PMISUB                         Sub-total
     C     *LIKE         DEFINE    OAAM29        PMITXA                         Taxable
     C     *LIKE         DEFINE    OAAM30        PMINTA                         Non-taxable
     C     *LIKE         DEFINE    AHTL10        PMIOTH                         Oth charges
     C     *LIKE         DEFINE    AHTL10        PMIOTX                         Taxable oth
     C     *LIKE         DEFINE    AHTL10        PMIONT                         Non-tax oth
     C     *LIKE         DEFINE    OEFL08        PMITXF                         Taxable flag
     C     *LIKE         DEFINE    OEFL09        PMIOCF                         Oth chg flag
     C     *LIKE         DEFINE    ARCDB9        PMIGEX                         GST exempt
     C     *LIKE         DEFINE    OEPC02        PMITPC                         Tax %
     C     *LIKE         DEFINE    OEPC08        PMIGHP                         GST/HST %
     C     *LIKE         DEFINE    OENO24        PMIJUR                         Jurisdiction
     C     *LIKE         DEFINE    OAAM29        PMOTXA                         Taxable
     C     *LIKE         DEFINE    OAAM30        PMONTA                         Non-taxable
     C     *LIKE         DEFINE    AHTL06        PMOTAX                         Tax amount
     C     *LIKE         DEFINE    OEAM45        PMOGST                         GST amount
     C     *LIKE         DEFINE    OENO16        TRFSBR                         TRANSFER BRN
     C     *LIKE         DEFINE    OENO16        PRMSBR                         TRANSFER BRN
     C     *LIKE         DEFINE    IVNO04        ALIDTA
     C     *LIKE         DEFINE    IVNO04        ALIPRD
     C     *LIKE         DEFINE    IVNO07        ALIITM
     C     *LIKE         DEFINE    IVNO04        ALIASS
     C     *LIKE         DEFINE    OENM15        ORDBY                          ORDERED BY  DE
     C     *LIKE         DEFINE    ARNO01        CUSTNU                                     DE
     C     *LIKE         DEFINE    PONO01        PO#PRM
     C     *LIKE         DEFINE    OEWT01        WKWT01                         ITEM WEIGHT
     C     *LIKE         DEFINE    OEWT01        WGTTOT
     C     *LIKE         DEFINE    OEWT01        EXTWGT
     C     *LIKE         DEFINE    OEQY16        FCTQTY
     C     *LIKE         DEFINE    OENO31        LOT#31
      * Work fields used to calculate ship and B/O quantity and $'s
      * for contracts...
     C     *LIKE         DEFINE    OEQY02        COQYBO
     C     *LIKE         DEFINE    OEAM39        COGRBO
     C     *LIKE         DEFINE    OETL02        CTXBLB
     C     *LIKE         DEFINE    OETL01        COTL1B
     C     *LIKE         DEFINE    OETL02        COTL2B
     C     *LIKE         DEFINE    OEAM04        CO04B
     C     *LIKE         DEFINE    OEAM45        CO45B
      *
     C     *LIKE         DEFINE    OEQY03        MAXQTY
     C     *LIKE         DEFINE    OAQY11        WKQY11
     C     *LIKE         DEFINE    OEPC02        GSTPCT
     C     *LIKE         DEFINE    RCDNBR        PCRRN
     C     *LIKE         DEFINE    RCDNBR        NXARRN
     C     *LIKE         DEFINE    RCDNBR        RRNERR
     C     *LIKE         DEFINE    OEAM38        ORDNET
     C     *LIKE         DEFINE    OEAM38        PMIUPR
     C     *LIKE         DEFINE    OEAM38        PMIUCS
     C     *LIKE         DEFINE    OEPC01        PMIDSC
     C     *LIKE         DEFINE    OEAM38        PMONPR
     C     *LIKE         DEFINE    CAVAIL        EXTLMT
     C     *LIKE         DEFINE    CAVAIL        $OVR
     C     *LIKE         DEFINE    CAVAIL        ELIMIT
     C     *LIKE         DEFINE    CAVAIL        EOVR
     C     *LIKE         DEFINE    OENO06        PMNO06                                     DE
     C     *LIKE         DEFINE    ARNM01        MSGNAM
     C     *LIKE         DEFINE    OECD03        ORGCD3                         SAVE CSH/CHG
     C     *LIKE         DEFINE    RESSTK        SAVSTK                         SAVE PRINT PICK TICK
     C     *LIKE         DEFINE    OEFL03        SAVFL3                         SAVE PRINT PICK TICK
     C     *LIKE         DEFINE    PICSEQ        SAVSEQ                         SAVE PICK SEQUENCE
     C     *LIKE         DEFINE    SHIPC         SAVSHC                         SAVE SHIP COMPLETE
#P   C     *LIKE         DEFINE    SHIPC         SHIPCSV                        SAVE SHIP COMPLETE
     C     *LIKE         DEFINE    RESSTK        SV2STK                         SAVE PRINT PICK TICK
     C     *LIKE         DEFINE    SHIPC         SV2SHC                         SAVE SHIP COMPLETE
     C     *LIKE         DEFINE    IVDN01        WKDN01
     C     *LIKE         DEFINE    OENO08        PVNO08                         PREV SELL BR
     C     *LIKE         DEFINE    ARNO01        CUSNUM                         CUSTOMER NUMBER
     C     *LIKE         DEFINE    ARFL72        SAVFTK                         SAVE PRINT PICK TKT
     C     *LIKE         DEFINE    ARNO75        SVFARA                         SAVE FAX AREA
     C     *LIKE         DEFINE    ARNO76        SVFPRE                         SAVE FAX PREFIX
     C     *LIKE         DEFINE    ARNO77        SVFSUF                         SAVE FAX SUFFIX
     C     *LIKE         DEFINE    OENO08        SVSLBR
     C     *LIKE         DEFINE    AGEOPT        PMAGOP
     C     *LIKE         DEFINE    IVNO07        PUOMI#
     C     *LIKE         DEFINE    OENO15        SBATNO                         SAV BAT#
     C     *LIKE         DEFINE    OEMO05        SBATMO                         SAV BAT MO
     C     *LIKE         DEFINE    OEDY05        SBATDY                         SAV BAT DY
     C     *LIKE         DEFINE    OECC05        SBATCC                         SAV BAT CC
     C     *LIKE         DEFINE    OEYR05        SBATYR                         SAV BAT YR
     C     *LIKE         DEFINE    OENO22        LINCTL
     C     *LIKE         DEFINE    OECD01        SVCD01
     C     *LIKE         DEFINE    OECD04        SVCD04
     C     *LIKE         DEFINE    OETM01        SVTM01
     C     *LIKE         DEFINE    OECD01        METHOD                         SHIP METHOD
     C     *LIKE         DEFINE    OEDN01        SCDN01                         SHIP VIA
     C     *LIKE         DEFINE    OECD01        CUSMOS                         ORIG MOS
     C     *LIKE         DEFINE    OEDN01        CUSSCD                         ORIG SH CODE
     C     *LIKE         DEFINE    OENO01        CRNO#
     C     *LIKE         DEFINE    OENO22        LINRF#
     C     *LIKE         DEFINE    OENO01        TRN#
     C     *LIKE         DEFINE    OENO26        TRNSEC
     C     *LIKE         DEFINE    OEQY03        SHPQTY
     C     *LIKE         DEFINE    OEQY03        ORIGBO
     C     *LIKE         DEFINE    OENO16        RBRN
     C     *LIKE         DEFINE    OENO08        PBR                            PARM BR (PACK) ED
     C     *LIKE         DEFINE    OECD01        SVWMSM                         SHIP METHOD
     C     *LIKE         DEFINE    ARCDC6        SVWMSC                         SHIP CODE
     C     *LIKE         DEFINE    RRN           SVRRN
     C     *LIKE         DEFINE    RRN           CBORRN
     C     *LIKE         DEFINE    OENO16        LBRN
     C     *LIKE         DEFINE    OENO01        SO#
     C     *LIKE         DEFINE    OENO19        CO#
     C     *LIKE         DEFINE    ARST02        SHIPST                         SHIP STATE
     C     *LIKE         DEFINE    OECD01        MOS                            MTH OF SHP
     C     *LIKE         DEFINE    TAXOPT        TAXFLG                         OTH TAX FLGS
     C     *LIKE         DEFINE    TAXOPT        SVTAXO                         OTH TAX FLGS
     C     *LIKE         DEFINE    OECD01        SACD01                         SAV SHPMTH
     C     *LIKE         DEFINE    ARST02        SAST02                         SAV SHPSTATE
     C     *LIKE         DEFINE    OENO24        TAXCPY
     C     *LIKE         DEFINE    ARZP16        ZIPCPY
     C     *LIKE         DEFINE    OECD01        MS1CPY                         MTH OF SHIP1
     C     *LIKE         DEFINE    OECD01        MS2CPY                         MTH OF SHIP2
     C     *LIKE         DEFINE    OECD01        MS3CPY                         MTH OF SHIP3
     C     *LIKE         DEFINE    ARST02        SSTCPY                         SHIP STATE
     C     *LIKE         DEFINE    OENO06        JOBCPY                         JOB#
     C     *LIKE         DEFINE    OENO08        SLBCPY                         SALE BR
     C     *LIKE         DEFINE    OENO24        SAVTJ
     C     *LIKE         DEFINE    ARZP16        ZPCD
     C     *LIKE         DEFINE    OENO24        TXCD
     C     *LIKE         DEFINE    ARCDG8        SLBRG8                         SELL BR TYPE
     C     *LIKE         DEFINE    CD04B         SLBR4B                         TAX CODE
     C     *LIKE         DEFINE    ARST03        SLBRST
     C     *LIKE         DEFINE    OENO19        SVOA19
     C     *LIKE         DEFINE    OANO01        SVOA01
     C     *LIKE         DEFINE    ARFL02        PMFLTA                         TAX AUTH FLAG
     C     *LIKE         DEFINE    ARCD67        PMTTYP                         TRANS TYPE
MV   C     *LIKE         DEFINE    IVNO04        WC_IVNO04
OA   C     *LIKE         DEFINE    oeam03        $I_HND
OA   C     *LIKE         DEFINE    oeam03        $I_DEL
OA   C     *LIKE         DEFINE    oeam03        $I_OTH
OA   C     *LIKE         DEFINE    oeam03        $C_HND
OA   C     *LIKE         DEFINE    oeam03        $C_DEL
OA   C     *LIKE         DEFINE    oeam03        $C_OTH
PF   C     *like         define    ARNO15        SVNO15
TZ   C     *like         define    arno07        wino07
TZ   C     *like         define    arno08        wino08
TZ   C     *like         define    arno09        wino09
TZ   C     *like         define    arnm05        winm09
UJ   C     *like         define    ARNO01        POVARNO01
UJ   C     *like         define    OENO01        POVOENO01
UJ   C     *like         define    OENO08        POVOENO08
UJ   C     *like         define    OENO16        POVOENO16
VU   C     *LIKE         DEFINE    OEAM36        WTOTAL          + 2
¢(    * B2B
¢(   C     *like         define    OECD04        BkOECD04                       Order Status
¢(   C     *like         define    OETL01        BkOETL01                       Order Total Amount
¢(   C     *like         define    OETL02        BkOETL02                       Order Total Amount
¢(   C     *like         define    OEAM36        BkOEAM36                       C.C. Amount
¢(   C     *like         define    OEAM04        BkOEAM04                       Tax  Amount
¢(   C     *like         define    OEAM44        BkOEAM44                       GST Tax Amount
¢:    * B2B - Tax Re-Calculation
¢:   C     *like         define    OEFL08        BkOEFL08                       Taxable (Y/N)
¢:   C     *like         define    OENO24        BkOENO24                       Tax Code
¢:   C     *like         define    OEFL09        BKOEFL09                       Other Charger(Y/N)
¢:    * Other Charges Information
¢:   C     *like         define    FRTAMT        BkFRTAMT                       Freight
¢:   C     *like         define    DELAMT        BkDELAMT                       Delivery Charge
¢:   C     *like         define    HANAMT        BkHANAMT                       Handling Charge
¢:   C     *like         define    RESAMT        BkRESAMT                       Restocking Charge
¢:   C     *like         define    OTHAMT        BkOTHAMT                       Other Charges
¢:   C     *like         define    FTAXYN        BkFTAXYN                       Tax Freight
¢:   C     *like         define    DTAXYN        BKDTAXYN                       Tax Delivery
¢:   c     *like         define    HTAXYN        BkHTAXYN                       Tax Handling
¢:   c     *like         define    RTAXYN        BkRTAXYN                       Tax Restocking
¢:   C     *like         define    OTAXYN        BkOTAXYN                       Tax Other
¢(    * B2B End
      *
     C     *ENTRY        PLIST
     C                   PARM                    OENO01                         ORDER NUMBER
     C                   PARM                    DSPCST            1            DISPLAY COST ?
OA   C     pl0495        plist
OA   C                   parm                    arno01
OA   C                   parm      'O'           $mode             1
OA   C                   parm      *blanks       OAen04
OA   C                   parm                    OAen01
OA   C                   parm      *blanks       OAen07           22
OA   C                   parm                    psdata
OA   C                   parm                    OAonly            1
     C     EDTDAT        PLIST
     C                   PARM                    PDATE             6 0
     C                   PARM                    PJULI             5 0
     C     SRLUPD        PLIST
     C                   PARM                    ORDER             7            ORDER #
     C                   PARM                    PGMREQ            1            PGM FUNCTION
     C     RLOCK         PLIST
     C                   PARM                    DSPERR
     C                   PARM                    DSPF1             1            DISPLAY RETRY?
     C                   PARM                    DSPF2             1            SCREEN RESPONSE
      *
     C     PLMBAL        PLIST
     C                   PARM                    OENO01                         ORDER#
     C                   PARM                    OENO19                         CONTRACT#
     C                   PARM                    ARNO01                         CUSTOMER
     C                   PARM                    OENO06                         JOB
     C                   PARM                    NO15                           COMPANY
     C                   PARM                    OEAM31           11 2
     C                   PARM                    OEAM32           11 2
     C                   PARM                    OEAM33           11 2
     C                   PARM                    OEAM34           11 2
     C                   PARM      'Y'           F9100             1
     C                   PARM                    OE#OTY
     C                   PARM                    OE#NTY
     C                   PARM                    CO#TYP
     C                   PARM      'N'           ER9100            1
     C     PL0060        PLIST
     C                   PARM                    VALUE#           30
     C                   PARM                    ACT#              1
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
      *
     C     PLUDR         PLIST
     C                   PARM                    ZZFUNC            1
     C                   PARM                    ZZDATE            7 0
     C                   PARM                    ZZDAYS            5 0
     C                   PARM                    ZZDIFF            7 0
      *
     C     PL2000        PLIST
     C                   PARM                    PM2000           23 0
      *
     C     PL5211        PLIST
     C                   PARM                    TAXJUR            7 0
     C                   PARM                    RETCDE            1 0
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL9200        PLIST
     C                   PARM                    OENO01                         ORDER#
     C                   PARM                    OENO19                         CONTRACT#
     C                   PARM                    ARNO01                         CUSTOMER
     C                   PARM                    OENO06                         JOB
     C                   PARM                    NO15                           COMPANY
     C                   PARM                    OEAM31
     C                   PARM                    OEAM32
     C                   PARM                    OEAM33
     C                   PARM                    OEAM34
     C                   PARM                    F9200A            1
     C                   PARM      'O'           F9200B            1            FROM O/E
     C                   PARM                    OE#OTY
     C                   PARM                    OE#NTY
     C                   PARM                    CO#TYP
     C                   PARM                    ER9200            9
     C                   PARM                    CAVAIL            9 2
     C                   PARM                    JAVAIL            9 2
     C                   PARM                    EAVAIL            9 2
     C     PL3050        PLIST
     C                   PARM                    ARNO01                         CUST #
     C                   PARM                    ARNM01                         CUST NAME
     C                   PARM                    ARNO07                         CUST AREA CODE
     C                   PARM                    ARNO08                         CUST PH PREFIX
     C                   PARM                    ARNO09                         CUST PH SUFFIX
     C                   PARM                    ARNO15                         COMPANY #
     C                   PARM                    OENO08                         BRANCH #
     C                   PARM                    OENO01                         ORDER #
     C                   PARM                    DEP$1             9 2          THIS SALE
     C                   PARM                    DEP$2             9 2          B/O AMT
     C                   PARM                    DEP$3             9 2          TOTAL SALE
     C                   PARM                    NEWDEP                         DEPOSIT#
     C                   PARM                    NEWRMN                         REMAINING$
     C                   PARM                    NEWRTN            1            RETURNED STATUS
     C     PL3060        PLIST
     C                   PARM                    ARNO01                         CUST #
     C                   PARM                    ARNM01                         CUST NAME
     C                   PARM                    ARNO07                         CUST AREA CODE
     C                   PARM                    ARNO08                         CUST PH PREFIX
     C                   PARM                    ARNO09                         CUST PH SUFFIX
     C                   PARM                    ARNO15                         COMPANY #
     C                   PARM                    OENO08                         BRANCH #
     C                   PARM                    OENO01                         ORDER #
     C                   PARM                    OENO26                         ORIG ORD #
     C                   PARM                    DEP$1             9 2          THIS SALE
     C                   PARM                    DEP$2             9 2          B/O AMT
     C                   PARM                    DEP$3             9 2          TOTAL SALE
     C                   PARM                    ODEP#                          DEPOSIT #
     C                   PARM                    ORMN$             9 2          REMAIN $
     C                   PARM                    ORTNCD            1            RTN CODE
     C                   PARM                    DEP#                           ARRAY
     C                   PARM                    WD$                            ARRAY
     C                   PARM                    SWD$
     C                   PARM                    OETL01
     C                   PARM                    OEAM06
     C                   PARM                    OEAM07
     C                   PARM                    OEAM36
     C     PL3200        PLIST
     C                   PARM                    ARNO01                         CUST #
     C                   PARM                    OENO08                         SELL BR #
     C                   PARM                    OENO01                         ORD #
     C                   PARM                    OENO26                         ORIG ORD #
     C                   PARM                    ODEP#                          DEPOSIT #
     C                   PARM                    ORMN$                          REMAIN $
     C                   PARM                    OADDL             1            ADD'L DEP'S
     C                   PARM                    OFLAG             1            LOCK/ORIG#
     C     PL3210        PLIST
     C                   PARM                    SDEP#                          DEPOSIT #
     C                   PARM                    OSTS              1            STATUS
     C                   PARM                    OLOCK             1            LOCK FLAG
     C                   PARM                    OORD#                          ORDER#
     C                   PARM                    OCUS#                          CUST#
     C                   PARM                    OBR#                           BRANCH#
     C                   PARM                    ORMN$                          REMAIN $
     C     PL0025        PLIST
     C                   PARM                    TABCOD
     C                   PARM                    TABENT
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
TI   C                   parm                    tabent2
TI   C                   parm                    mode
MR    *
MR   C     PL1800        PLIST
MR   C                   PARM                    REQ               1
MR   C                   PARM                    BRANCH            3
MR   C                   PARM                    ITEM#             6
MR   C                   PARM                    TRAN#             7
MR   C                   PARM                    TRNTYP            2
MR   C                   PARM                    TRNLIN#           3
MR   C                   PARM                    QTYNED            7 0
MR   C                   PARM                    CUST#             6 0
MR   C                   PARM                    CMPNY#            3 0
MR   C                   PARM                    TRNIOC            1
MR   C                   PARM                    ITEMTY            1
MR   C                   PARM                    F11_ALLOWED       1
NM   C                   PARM                    F12_CANCEL        1
NH   C                   PARM                    REQCDE            1
OJ   C                   PARM                    SRL_FLAGS
OJ   C                   PARM                    trannum
OR VBC*                  parm                    srl_num          20
VB   C                   parm                    srl_num          30
%C   C                   PARM                    DIRECTORDER       1
MR    *
MR   C     PL1801        PLIST
MR   C                   PARM                    SRLMOD            1
MR   C                   PARM                    TRAN#
MR   C                   PARM                    TRNTYP
MR   C                   PARM                    TRNLIN#
MR   C                   PARM                    SRL_USEJOB        1
MR   C                   PARM                    SRLSEC            7
MR   C                   PARM                    SRLTLN            3
MR   C                   PARM                    QTYNED
MR   C                   PARM                    SRLEXS            1
MR    *
     C     PL6200        PLIST
     C                   PARM                    CUSTNU                         CUST#
     C                   PARM                    RETCOD                         RETURN CODE
     C                   PARM                    ORDBY                          ORDERED BY
     C                   PARM                    FROMOE            1            FROM O/E FLAG
     C                   PARM                    ARNM01                         CUST NAME
     C                   PARM                    ARNO07                         CUST AREA CODE
     C                   PARM                    ARNO08                         CUST PH PREFIX
     C                   PARM                    ARNO09                         CUST PH SUFFIX
OE   c                   parm                    contactNbr
     C     PL0026        PLIST
     C                   PARM                    TABCOD
     C                   PARM                    TABENT
     C                   PARM                    ACT#              1
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL5620        PLIST
     C                   PARM                    SBR#              3
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL5720        PLIST
     C                   PARM                    NO01#
     C                   PARM                    NO06#
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM                    STAT              1
      *
     C     PL8439        PLIST
     C                   PARM                    OENO16                         SHIP BRANCH
     C                   PARM                    OENO01                         ORDER NUMBER
     C                   PARM                    ZZNO04                         PRODUCT#
     C                   PARM                    BOEXT                          B/O EXISTS
      * Parameter list for call to OER9300;
     C     PL9300        PLIST
     C                   PARM                    PMISUB                         Sub-total
     C                   PARM                    PMITXA                         Taxable
     C                   PARM                    PMINTA                         Non-taxable
     C                   PARM                    PMIOTH                         Oth charges
     C                   PARM                    PMIOTX                         Taxable oth
     C                   PARM                    PMIONT                         Non-tax oth
     C                   PARM                    PMITXF                         Taxable flag
     C                   PARM                    PMIOCF                         Oth chg flag
     C                   PARM                    PMIGEX                         GST exempt
     C                   PARM                    PMITPC                         Tax %
     C                   PARM                    PMIGHP                         GST/HST %
     C                   PARM                    PMIJUR                         Jurisdiction
     C                   PARM                    PMOTXA                         Taxable
     C                   PARM                    PMONTA                         Non-taxable
     C                   PARM                    PMOTAX                         Tax amount
     C                   PARM                    PMOGST                         GST amount
     C                   PARM                    SO#
     C                   PARM                    PMFLTA
     C                   PARM                    OENO06
     C                   PARM                    PMTTYP
     C                   PARM                    ARNO01
     C                   PARM                    CALTYP            1            TAXCAL TYPE
     C                   PARM                    USAGE             1            HOW TO PROC
      * 'USAGE' CONTAINS CODES FOR PROCESSING:
      *          O = ORDERED CALCS
      *          B = B/O CALCS
      *      BLANK = ALL OTHERS (SHIPPED, CONTRACTS, BIDS, ETC. - THESE
      *                          PROCESS OKAY SO KEEP ORIGINAL CALCS)
     C                   PARM                    WEBKEY           30            WEB ORD KEY
VM   C                   Parm                    PiTaxMOS
VM   C                   Parm                    PiTaxOrdTyp
VM   C                   Parm                    PiTaxGenRef
VM   C                   Parm                    PiTaxShpst
VM   C                   Parm                    PiTaxTranType     3
      *
      * Parameter list for call to OER9302;
     C     PL9302        PLIST
     C                   PARM                    OENO01                         ORDER #
     C     PL9400        PLIST
     C                   PARM                    SCNO16                         SHIP BRANCH
     C                   PARM                    IVNO07                         ITEM
     C                   PARM                    ARNO01                         CUSTOMER
     C                   PARM                    OENM15                         CUST CONTACT
     C                   PARM                    ZZNO04                         PRODUCT NO
     C                   PARM                    ZZDN01                         PRODUCT DESC
     C                   PARM                    DISPLY            1            DISPLAY MODE
     C                   PARM                    DIRORD            1            DIRECT/NDIRECT
     C                   PARM                    RETCDE                         ERROR CODE
      *
     C     PL3450        PLIST
     C                   PARM                    IVNO07                         ITEM
     C                   PARM                    OEDN04                         ORD UOM
     C                   PARM                    ORDFCT                         ORD FACTOR
     C                   PARM                    OEQY01                         ORD QTY
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
     C                   PARM                    ALIASS                         IN
     C                   PARM                    SCREEN                         OUT
     C                   PARM                    BRCH#             3 0          OUT
     C                   PARM                    SELMDS                         SELECT DATA STRUCT
     C                   PARM      ' '           SELMOD            1            SEL MODE
     C                   PARM                    RTRNCD            1 0          RETURN CODE
      *
     C     PL2062        PLIST
     C                   PARM                    ACCESS            1
     C                   PARM                    PODN10
     C                   PARM                    PO#PRM
     C                   PARM                    TAGXST            1
     C                   PARM                    ONTRF             1
     C                   PARM                    ONSO              1
     C                   PARM                    ONPO              1
     C                   PARM                    ONWO              1
     C                   PARM                    EXISTS            1
      *
     C     PL4947        PLIST
     C                   PARM                    PMIUPR
     C                   PARM                    PMIUCS
     C                   PARM                    PMIDSC
     C                   PARM                    PMONPR
     C     PL2010        PLIST
     C                   PARM                    WOS
     C                   PARM                    TYPPGM
     C                   PARM                    UPDADD
NT    *
NT   C     PL2075        PLIST
NT   C                   PARM                    TABCD             4
NT   C                   PARM                    RSNCD             9
NT   C                   PARM                    C@LOC#            6
NT   C                   PARM                    CRCD#            10
NT   C                   PARM                    CFLD#            10
NT   C                   PARM                    RSNDEC           30
NT   C                   PARM      'OE'          PGCD              2
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
     C     PL6202        PLIST
     C                   PARM                    CUSNUM                         CUSTOMER#
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM                    FXAREA            3 0
     C                   PARM                    FXPRFX            3 0
     C                   PARM                    FXSUFX            4 0
      *
     C     R0300         PLIST
     C                   PARM                    C@LOC#                         CURSOR LOCATION
     C                   PARM                    CRCD#                          CURSOR RECORD
     C                   PARM                    CFLD#                          CURSOR FIELD
     C                   PARM                    SYSID             4            APPLICATION COD
     C                   PARM                    DOCNUM           12            DOCUMENT NUMBER
     C                   PARM                    FAXNUM           32            DOCUMENT NUMBER
     C                   PARM                    OPTON             4            OPTIONS
     C                   PARM                    REQTIM            6            REQUESTED FAX TIME
     C                   PARM                    REQDAT            6            REQUESTED FAX DATE
   M5C*                  PARM                    TRNNUM            7 0          TRANSFER NUMBER
M5   C                   PARM                    TRNNUM            7            TRANSFER NUMBER
      *
     C     PL9000        PLIST
     C                   PARM                    ARNO01
     C                   PARM                    ARNO07
     C                   PARM                    ARNO08
     C                   PARM                    ARNO09
     C                   PARM                    ARNM01
     C                   PARM                    TRANUM            7
     C                   PARM                    OENO08
     C                   PARM                    CCMODE            1
     C                   PARM                    TRATYP            1
     C                   PARM                    TOTCHG            9 2
     C                   PARM                    CCTAXA            9 2
     C                   PARM                    APRVD             1
RZ    *
RZ   C     pl9602        plist
RZ   C                   parm                    arno01
RZ   C                   parm                    arno07
RZ   C                   parm                    arno08
RZ   C                   parm                    arno09
RZ   C                   parm                    arnm01
RZ   C                   parm                    tranum            7
RZ   C                   parm                    oeno08
RZ   C                   parm                    ccmode            1
RZ   C                   parm                    tratyp            1
RZ   C                   parm                    totchg            9 2
RZ   C                   parm                    cctaxa            9 2
RZ   C                   parm                    aprvd             1
      *
     C     PL0100        PLIST
     C                   PARM                    PMAGOP
      *
     C     PL9320        PLIST
     C                   PARM                    PUOMI#                         OUR ITEM#
     C                   PARM                    PUOMOU            3            ORDER UOM
     C                   PARM                    PUOMOF           14 9          ORD UOM FCT
     C                   PARM                    PUOMOB            1            O/E UOM BASE
     C                   PARM                    PUOMPU            3            PRICE UOM
     C                   PARM                    PUOMPF           14 9          PRC UOM FCT
     C                   PARM                    PUOMRC            1            RETURN CODE
      *
     C     PL3112        PLIST
     C                   PARM                    SCTXTY            1            TRANS TYPE
     C                   PARM                    SCBRAN            3 0          SHP BRANCH
     C                   PARM                    METHOD                         SHP METHOD
     C                   PARM                    SHPCOD                         SHP CODE
     C                   PARM                    SCDN01                         SHP VIA
     C                   PARM                    SCRCOD            1            RETURN CODE
      *
     C     PL0303        PLIST
     C                   PARM                    SYSID                          APPLICATION COD
     C                   PARM                    DOCNUM           12            DOCUMENT NUMBER
     C                   PARM                    EMAIL            45            EMAIL ADDRS
     C                   PARM                    REQTIM                         REQUESTED FAX TIME
     C                   PARM                    REQDAT                         REQUESTED FAX DATE
   M5C*                  PARM                    TRNNUM            7 0          TRANSACTION REQUEST
M5   C                   PARM                    TRNNUM            7            TRANSACTION REQUEST
RF    *
RF   C     PL0304        PLIST
RF   C                   PARM                    SYSID                          APPLICATION COD
RF   C                   PARM                    DOCNUM                         DOCUMENT (BID#)
RF   C                   PARM                    REQTIM                         REQUESTED FAX TIME
RF   C                   PARM                    REQDAT                         REQUESTED FAX DATE
RF   C                   PARM                    TRNNUM                         BID NUMBER
RF   C                   PARM                    JOBNME                         JOB NAME
RF   C                   PARM                    JOB##             6            JOB NUMBER
   RFC*    PL0315        PLIST
RF   C     PL0316        PLIST
     C                   PARM                    ARNO01
     C                   PARM                    ETYPE             2
     C                   PARM                    EMAIL
     C                   PARM                    C@LOC#            6
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
RF   C                   PARM                    DOCTP             4
RF   C                   PARM                    DOC#             12
RF   C                   PARM                    REQTIM                         REQUESTED TIME
RF   C                   PARM                    REQDAT                         REQUESTED DATE
      *
     C     PL8220        PLIST                                                  GET USR AUTH
     C                   PARM                    USER             10
     C                   PARM                    APP               2
     C                   PARM                    CDE               4
     C                   PARM                    ID                4 0
     C                   PARM                    USRVAL           10
     C                   PARM                    VALFRM            1
     C                   PARM                    RTNCOD            1
      *
     C     PL0900        PLIST                                                  ADD P/F LIB
     C                   PARM                    PFRTNC            1
      *
     C     PL0004        PLIST                                                  GET P/F STS
     C                   PARM                    TRAN#             7
     C                   PARM                    TXTYP             2
     C                   PARM                    PFSTS             3
      *
     C     PL0510        PLIST
     C                   PARM                    LBLINE            5
     C                   PARM                    LBBRN             3
     C                   PARM                    LBITM             6
      *
     C     PL4356        PLIST
     C                   PARM                    CRNO#
     C                   PARM                    LINRF#
     C                   PARM                    VRLMOD            1            V/R LIN MODE
     C                   PARM                    VRLSRC            1            V/R LIN SOUR
     C                   PARM                    RTNCOD            1            RETURN CODE
     C                   PARM                    CLSFLG            1            CLOSE FLAG
      *
     C     PL0260        PLIST
     C                   PARM                    USRNM
     C                   PARM      'OE'          APP               2
     C                   PARM      '05'          LVL               2
     C                   PARM      '02'          OPTION            2
     C                   PARM      ' '           RPAUTH            1
      *
     C     PL9990        PLIST
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM                    PROG
     C                   PARM                    WLIN#             3
     C                   PARM                    WPOS#             3
     C                   PARM                    TROW#             3
     C                   PARM                    TCOL#             3                        ons
     C                   PARM                    MODE#             1
     C     PL0600        PLIST
     C                   PARM      'N'           UJOB              1            USE JOB KEY
     C                   PARM                    AUTOA             1            AUTO ALLOC
     C                   PARM                    SHPQTY                         AFFECT INV
     C                   PARM                    ORIGBO                         B/O QTY
     C                   PARM                    LBRN                           LOT BRANCH
     C                   PARM                    RBRN                           RCV BRN
     C                   PARM                    LITM              6 0          ITEM
     C                   PARM                    TRN#                           TRANSACTION
     C                   PARM                    TRNSEC                         SECONDARY #
     C                   PARM                    LLINE#            5 0          TRANS LINE #
     C                   PARM      'SO'          TRNTYP            2            TRANS TYPE  M
     C                   PARM                    LRETRN            1            LOT RET CODEM
     C     PL0601        PLIST
     C                   PARM                    LFUNC             1            LOT FUNCTION
     C                   PARM                    TRN#                           TRANSACTION#
     C                   PARM                    TRNSEC                         SECONDARY#
     C                   PARM      'SO'          TRNTYP            2            TRAN TYPE
     C                   PARM                    TRNLIN            5 0          TRAN LINE #
     C                   PARM                    TRNSTS            1            TRAN STATUS
     C                   PARM      'N'           UJOB              1            USE JOB KEY
     C                   PARM                    LLINE#                         TEMP LINE#
     C                   PARM                    LEXIST            1            LOT EXISTS
     C     ISNPRM        PLIST
     C                   PARM                    TRANS#            7            TRANS #
     C                   PARM                    TRNTYP            2            TRANS TYPE
     C     PL0810        PLIST
     C                   PARM                    PM0810
     C     PLHZ01        PLIST
     C                   PARM                    CITEM                          CHEM ITEM#
     C                   PARM                    METHOD                         MOS
     C                   PARM                    SHPCOD                         SHIP CODE
     C                   PARM                    HZRTNC            1            RETURN CODE
      *
     C     PL5825        PLIST
     C                   PARM                    TRMCD
     C                   PARM                    TRMYN
     C                   PARM                    TRMPCT            3 1
     C                   PARM                    RTNCOD            1
      *
     C     PL5810        PLIST
     C                   PARM                    TRMCD             2
     C                   PARM                    TRMYN             1
     C                   PARM                    TRMPC             3
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM      'Y'           SHWPMT            1
      *
   MOC*    PL6100        PLIST
   MOC*                  PARM                    BRANCH            3
   MOC*                  PARM                    NSITM#           12
   MOC*                  PARM                    QTYOH             7 0
   MOC*                  PARM                    QTYAVL            7 0
   MOC*                  PARM                    NSCOST            9 4
   MOC*                  PARM                    NSCTRN            2 0
   MOC*                  PARM                    POCOST            9 4
      *
     C     PL4900        PLIST
     C                   PARM                    ORGCST           11 5
     C                   PARM                    OECD27
     C                   PARM                    ITEMNO            6
     C                   PARM                    CBR               3
     C                   PARM                    CTYPE             1
      *
     C     PL9003        PLIST
     C                   PARM                    TRANUM            7
     C                   PARM                    TRATYP            1
     C                   PARM                    TOTCHG            9 2
     C                   PARM                    CARD              1
     C                   PARM                    PMODE             1
      *
MN   C     PL5420        PLIST
MN   C                   PARM                    NO15#
MN   C                   PARM                    ID02#
MN   C                   PARM                    C@LOC#
MN   C                   PARM                    CRCD#
MN   C                   PARM                    CFLD#
MN    *
MS   C     PL2163        PLIST
MS   C                   PARM                    OENO01
MS    *
M2   C     PL0061        PLIST
M2   C                   PARM                    ROLEX            14 0
M2    *
     C     PL9316        PLIST
     C                   PARM                    SHIPST                         SHIP STATE
     C                   PARM                    MOS                            MTH OF SHP
     C                   PARM                    TAXFLG                         OTH TAX FLGS
      *
     C     PL9100        PLIST
     C                   PARM                    ZPCD
     C                   PARM                    TXCD
     C                   PARM                    RETFLG            1 0
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
OE    *
OE   C     PL2500        PLIST
OE   C                   PARM                    PGMNAM2          10
OE   C                   PARM                    RCCALL            1
QZ    *
QZ   C     P_AIR9050     PLIST
QZ   C                   Parm                    Msg9050
SP   C                   Parm                    ErrCd
QZ    *
QZ   C     PL9350        PLIST
QZ   C                   Parm                    PiNumOfItems
QZ   C                   Parm                    pCustomerCode
QZ   C                   Parm                    pDocCode
QZ   C                   Parm                    pDocType
QZ   C                   Parm                    pDocDate
QZ   C                   Parm                    pSellBr
QZ   C                   Parm                    pShipFromBr
QZ   C                   Parm                    pDAddress1
QZ   C                   Parm                    pDAddress2
QZ   C                   Parm                    pDAddress3
QZ   C                   Parm                    pDCity
QZ   C                   Parm                    pDState
QZ   C                   parm                    pDCountry
QZ   C                   Parm                    pDZipCode
QZ   C                   Parm                    pCommitTran
QZ   C                   Parm                    pTax_lineitems
QZ   C                   Parm                    POrgOrder
QZ   C                   Parm                    pTaxRate
QZ   C                   Parm                    pTaxAmt
QZ   C                   Parm                    pGstRate
QZ   C                   Parm                    pGstAmt
QZ   C                   Parm                    pHstRate
QZ   C                   Parm                    pHstAmt
QZ   C                   Parm                    pPstRate
QZ   C                   Parm                    pPstAmt
QZ   C                   Parm                    pTaxableAmt
QZ   C                   Parm                    pNTaxableAmt
QZ   C                   parm                    PErrCode
QZ   C                   parm                    PErrMsg
TI   C                   parm                    PiAPIRqstTyp
TI   C                   parm                    PiTranType
TI   C                   parm                    PiBillType
TI   C                   parm                    PiTranNum
TI   C                   parm                    PCustPoNum
TI   C                   parm                    PJobNum
TI   C                   parm                    PiUpdTax
TI   C                   parm                    PiTaxOvrAmt
TI   C                   parm                    PiFrtAmt
TI   C                   parm                    PiFrtDesc
TI   C                   parm                    PiDelAmt
TI   C                   parm                    PiDelDesc
TI   C                   parm                    PiHdlAmt
TI   C                   parm                    PiHdlDesc
TI   C                   parm                    PiRstAmt
TI   C                   parm                    PiRstDesc
TI   C                   parm                    PiOthAmt
TI   C                   parm                    PiOthDesc
VU   C                   parm                    PiCCPAmt
VU   C                   parm                    PiCCPDesc
TI   C                   parm                    PiCustNum
TI   C                   Parm                    PiPgmName
TI   C                   Parm                    PiMisc
TI   C                   Parm                    PiHdrUpd
VM   C                   Parm                    PiTaxMOS
VM   C                   Parm                    PiTaxOrdTyp
VM   C                   Parm                    PiTaxGenRef
VM   C                   Parm                    wTaxTyp
VM   C                   PARM                    PMFLTA
VM   C                   Parm                    PoTaxAmt1
VM   C                   Parm                    PoTaxNum1
Q1    *
Q1   C     pl9600        PLIST
Q1   C                   PARM                    piMode
Q1   C                   PARM                    piRetry
Q1   C                   PARM                    piUpdError
Q1   C                   PARM                    piTran
Q1   C                   PARM                    piMFUKEY
Q1   C                   PARM                    piOrgOrd
Q1   C                   PARM                    piMethod
Q1   C                   PARM                    piTrnDtl
Q1   C                   PARM                    piTrnAmt
Q1   C                   PARM                    piTaxable
Q1   C                   PARM                    piTaxAmt
Q1   C                   PARM                    poSuccess
Q1   C                   PARM                    poMsg
Q1   C                   PARM                    poData
RZ   C                   parm                    piData
RO    *
RO   C     PL1300        PLIST
RO   C                   PARM                    p1300App
RO   C                   PARM                    p1300Bypass
TI   C     pl9010        plist
TI   C                   parm                    piLine1
TI   C                   parm                    piLine2
TI   C                   parm                    piLine3
TI   C                   parm                    piCity
TI   C                   parm                    piState
TI   C                   parm                    PiCountry
TI   C                   parm                    PiZip
TI   C                   parm                    PoErrCode
TI   C                   parm                    PoErrMessage
WA   C                   parm                    PoLat
WA   C                   parm                    PoLng
TI    *
TI   C     pl9351        Plist
TI   C                   Parm                    PMode
TI   C                   Parm                    PiBillType
TI   C                   Parm                    PiTranNum
TI   C                   Parm                    PiTranType
TI   C                   Parm                    piAPIRqstTyp
TI   C                   Parm                    PiDocCode
TI   C                   Parm                    PiDocType
TI    * Tax status 01 = success, 02 = error
TI   C                   Parm                    PiTaxSts
TI   C                   Parm                    PiTaxErrCd
TI   C                   Parm                    PiTaxRate
TI   C                   Parm                    PiTaxAmt
TI   C                   Parm                    PiGSTRate
TI   C                   Parm                    PiGSTAmt
TI   C                   Parm                    PiHSTRate
TI   C                   Parm                    PiHSTAmt
TI   C                   Parm                    PiPSTRate
TI   C                   Parm                    PiPSTAmt
TI   C                   Parm                    PiTaxblAmt
TI   C                   Parm                    PiNtaxblAmt
TI   C                   Parm                    PiAPIErrMsg
TI   C                   parm                    PiUpdTax
TI   C                   parm                    PiTaxOvrAmt
TI   C                   Parm                    PiPgmName
TI   C                   Parm                    PiMisc
TI   C                   Parm                    PiHdrUpd
T0    *
T0   C     PL6084        PLIST
T0   C                   PARM                    AHNO1
T0   C                   PARM                    xcode             1
T1    *
T1   C     pl0003        plist
T1   C                   parm                    oeno01                         ORDER#
UG    *
UG   C     plDev         plist
UG   C                   parm                    pbranch           3 0
UG   C                   parm                    pUser97          10
UG   C                   parm                    pDevName         30
UG    *
UG   C     pl9701        plist
UG   C                   parm                    info_msg
UG    *
UG   C     pl9703        plist
UG   C                   parm                    pRetry            1
UJ    *
UJ   C     pl2023        plist
UJ   C                   parm                    POVarno01
UJ   C                   parm                    POVoecd05         1
UJ   C                   parm                    POVoeno01
UJ   C                   parm                    POVoeno08
UJ   C                   parm                    POVoeno16
UJ   C                   parm                    povjobno          7
UJ   C                   parm                    povjobnm         15
UJ   C                   parm                    povcstpo         22
UJ   C                   parm                    overridereject    1
UJ   C                   parm                    SRRN
UJ   C                   parm                    From2020          1
UI    *
UI   C     pl0400        plist
UI   C                   parm                    pmiapl            2
UI   C                   parm                    pmoyn             1
UI    *
UI   C     pl9352        plist
UI   C                   parm                    pComp#            3
UI   C                   parm                    pCust#            6 0
UI   C                   parm                    pJob#             7
UI   C                   parm                    pTran#            7
UI   C                   parm                    pTranType         3
UI   C                   parm                    PShipBrn          3
UI   C                   parm                    PSellBrn          3
UI   C                   parm                    pTaxable          9 2
UI   C                   parm                    pNtaxable         9 2
UI   C                   parm                    pTaxRate          6 6
UI   C                   parm                    pTaxAmount        9 2
UI   C                   parm                    pRqsType          3
UI   C                   parm                    pLogType          1
UI   C                   parm                    pPgmName          8
UI   C                   parm                    pErrorCd         50
UI   C                   parm                    pErrorMsg       150
U5    *
U5   C     PL9704        Plist
U5   C                   PARM                    crdmth
U5   C                   PARM                    usingAVS
U5   C                   PARM                    usingCVV
U5   C                   PARM                    billzp
U5   C                   PARM                    crdcvv
U5    *
U5   C     PL9705        Plist
U5   C                   PARM                    usingAVS
U5   C                   PARM                    usingCVV
UW    *
UW   C     PL9751        Plist
UW   C                   PARM                    COF_Mode
UW   C                   PARM                    Cust_Num
UW   C                   PARM                    Cust_Type
UW   C                   PARM                    PoToken
UW   C                   PARM                    PoExpcc
UW   C                   PARM                    PoExpyr
UW   C                   PARM                    PoExpmo
UW   C                   PARM                    PoNAME
VD   C                   PARM                    PoNetTrnID
VI   C                   PARM                    PoTokenSubmted
VE    *
VE   C     PL2190        PLIST
VE   C                   PARM                    LSMENU            2
VE   C                   PARM                    LSBRCH            3
VE   C                   PARM                    LSCUST            6
VE   C                   PARM                    LSORDR            7
VE   C                   PARM      *BLANKS       LSITEM            6
VD    *
VD   C     pl9805        PLIST
VD   C                   PARM                    piMode
VD   C                   PARM                    piRetry
VD   C                   PARM                    piUpdError
VD   C                   PARM                    piTran
VD   C                   PARM                    poData
VD   C                   PARM                    piData
VD   C                   Parm                    PoErrCode_L3
VD   C                   Parm                    PoErrMsg_L3
VJ    *
VJ   C     PL2120        PLIST
VJ   C                   PARM      'SO'          TRNSRC            2
VJ   C                   PARM                    OENO08
VJ   C                   PARM                    OENO16
VJ   C                   PARM                    ARNO01
VJ   C                   PARM                    OENO01
VJ   C                   PARM                    DIRORD
VJ   C                   PARM                    @INCPRC
VJ   C                   PARM                    @INCCST
VJ   C                   PARM                    @INCOVR
VJ   C                   PARM                    @INCCO
VJ   C                   PARM      ' '           ACPT_REJALL       1
VO    *
VO   C     PL9201        PLIST
VO   C                   PARM                    ARNO01
VO   C                   PARM      *ZEROS        AddOn_OvrPct
VP    *
VP   C     PL2312        PLIST
VP   C                   PARM                    ARNO01                         ORDER#
VP   C                   PARM                    OENO01                         ORDER#
VP   C                   PARM      'S/O'         JTRNTYP           3
VP   C                   PARM      'M'           JSAMODE           1
VP   C                   PARM      *BLANK        JSAREQ            1
VU   C     PL9707        PLIST
VU   C                   PARM                    TRANS_TYPE        3
VU   C                   PARM                    CARDAMOUNT
VU   C                   PARM                    CCPFEE
VU   C                   PARM                    CCPAPR_FLG        1
VU   C     PL2039        PLIST
VU   C                   PARM                    NEWDEP
VD    *
      *
¢J   C     PL9978        PLIST
¢J   C                   PARM                    PL991            15
¢J   C                   PARM                    PL992            15
¢J   C                   PARM                    PLRTN             1
¢W   C     PL9991        PLIST
¢W   C                   PARM                    oecd01
¢W   C                   PARM                    oeno16
¢W   C                   PARM                    pitm2
¢W   C                   PARM                    izno04
¢W   C                   PARM                    oeno19
¢W   C                   PARM                    oeno43
¢W   C                   PARM                    oecd26
¢W   C                   PARM                    oepc01
¢W   C                   PARM                    oecd08
¢W   C                   PARM                    gppct1
¢W   C                   PARM                    oeid02
¢W   C                   PARM                    arno01
¢W   C                   PARM                    oecd28
¢W   C                   PARM                    ret991            1
%G    * Order Fulfillments
%G   C     UTRP2022      PLIST
%G   C                   PARM                    WrkOENO01
%G   C                   PARM                    WrkFFLSTS
      *
%G   C     UTRP2021      PLIST
%G   C                   PARM                    OENO01
%G   C                   PARM                    WrkDFNO15
%G   C                   PARM                    WrkOENO08
%G   C                   PARM                    WrkOECD01
%G   C                   PARM                    WrkARCDC6
%G   C                   PARM                    WrkPgm
%W    *
%W   C     PLC510        PLIST
%W   C                   parm      *blanks       prClaim          10
%W   C                   parm                    prCust            6
%W   C                   parm                    prRANbr          10
%W   C                   parm      *blanks       prStatus         10
%W   C                   parm      *blanks       prClaimTxt      207
#E   C     PL_OERC022    PLIST
&Q   C                   PARM                    ARNO15
#E   C                   PARM                    PROGNAME         10
#E   C                   PARM                    ORDERTYPE         1
#E   C                   PARM                    METHODSHIP        1
#E   C                   PARM                    SHIPCODE          2
#E   C                   PARM                    SERIALTAG         1
#E   C                   PARM                    OPENBO            1
#E   C                   PARM                    ORDSTATUS         1
#E   C                   PARM                    WRITEOF           1
#E   C                   PARM                    SHIPCOMP          1
#E   C                   PARM                    PRINTTKT          1
#E   C                   PARM                    DEFAULTFOUND      1
#K   C     PL_OERC026    PLIST
#K   C                   PARM                    OENO08
#K   C                   PARM                    OECD01
#K   C                   PARM                    USEDEFAULT        1
#L   C     PL_OERC027    PLIST
#L   C                   PARM                    OENO08
#P   C                   PARM                    OECD01
#L   C                   PARM                    PROM_DATE         6 0
#L   C                   PARM                    RLS_DATE          6 0
#Q   C                   PARM                    Date_flag         1
&5   C     PL_E4REXTI3   PLIST
&5   C                   PARM                    @ReqStst          2
&5   C                   PARM                    @Response         2
&5   C                   PARM                    @ArNum            6
&5   C                   PARM                    @ordNum           7
&5   C*
     C                   CALL      'OEC2063'
     C                   CLEAR                   PVNO08
     C                   MOVE      ' '           PNDORD            1            PENDING ORDER
OA   C                   clear                   @first            1
OA   C                   z-add     *zero         @svresamt2
OI   C                   movel     'RSTFEEPCT'   OPNM25
N5   C                   MOVE      ' '           WDRFLG            1            W/D FLAG
$1   C                   MOVE      'N'           ORDER_REVIEW      1
     C     DSPCST        IFEQ      'R'                                          REVIEW MODE
     C                   MOVEA     '1'           *IN(31)                        PROTECT KEYWORD
$1   C                   MOVE      'Y'           ORDER_REVIEW      1
     C                   END
     C     DSPCST        IFEQ      'P'                                          PENDING MODE
     C                   MOVEA     '1'           *IN(31)                        PROTECT KEYWORD
     C                   MOVE      'Y'           PNDORD                         PENDING ORDERS
     C                   END
     C     DSPCST        IFEQ      'K'                                          RESERVED
     C                   MOVEA     '1'           *IN(31)                        PROTECT KEYWORD
     C                   END
      ***********
      * STEP 2. * KEY LISTS
      ***********
OI   C     CUA4KEY       klist
OI   C                   kfld                    arno01
OI   C                   kfld                    OPNM25
OI    *
     C     CMKEY         KLIST
     C                   KFLD                    IVNO7
     C     TABKEY        KLIST
     C                   KFLD                    TABCOD            4            TABLE CODE
     C                   KFLD                    TABENT            9            TABLE ENTRY
     C     BRIKEY        KLIST
     C                   KFLD                    OENO16                         SHIP BR#
     C                   KFLD                    N7                             OUR ITEM #
     C     BRKEY         KLIST
     C                   KFLD                    SAVBR                          BRANCH
     C                   KFLD                    N7                             OUR ITEM #
     C     BRKEY2        KLIST
     C                   KFLD                    OENO16                         SHIP BR#
     C                   KFLD                    IVNO07                         OUR ITEM #
     C     BRKEY3        KLIST
     C                   KFLD                    OENO16                         SHIP BR#
     C                   KFLD                    IVNO7                          OUR ITEM #
     C     BRKEY4        KLIST
     C                   KFLD                    OENO08                         SELL BR#
     C                   KFLD                    IVNO07                         OUR ITEM #
     C     COMKEY        KLIST
     C                   KFLD                    OENO01                         ORDER NUMBER
     C                   KFLD                    OECD11                         RECORD CODE
     C     KEYCOM        KLIST
     C                   KFLD                    OENO01                         ORDER NUMBER
     C                   KFLD                    LINCTL                         CONTROL NUMBER
   MRC*    KEYSRL        KLIST
   MRC*                  KFLD                    IVNO07                         OUR ITEM #
   MRC*                  KFLD                    OENO25                         SERIAL NO.
   MRC*    KEYSR2        KLIST
   MRC*                  KFLD                    KEYSTS            1            SRL STATUS
   MRC*                  KFLD                    OENO01                         ORDER NO.
   MRC*                  KFLD                    ORNO22                         ORIG LINE #
     C     PONSTK        KLIST
     C                   KFLD                    PN1                            P.O. NUMBER
     C                   KFLD                    PN5                            LINE NUMBER
     C     CUSCPY        KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    NO15                           COMPANY
     C     SLSCPY        KLIST
     C                   KFLD                    OEID02                         SALESPERSON ID
     C                   KFLD                    ARNO15                         COMPANY NO
     C     PCKEY         KLIST
     C                   KFLD                    SECPRF                         PROFILE#
     C                   KFLD                    ARNO15                         CO#
   OGC*    PXKEY         KLIST
   OGC*                  KFLD                    SECPRF                         PROFILE#
   OGC*                  KFLD                    CO@                            COMPANY
     C     BCHKY1        KLIST
     C                   KFLD                    OEMO05                         BATCH MTH
     C                   KFLD                    OEDY05                         BATCH DAY
     C                   KFLD                    OECC05                         BATCH CENTURY
     C                   KFLD                    OEYR05                         BATCH YEAR
     C                   KFLD                    OENO15                         BATCH NBR
     C                   KFLD                    ARNO15                         COMPANY NUMBER
     C     BCHKY2        KLIST
     C                   KFLD                    OEMO05                         BATCH MTH
     C                   KFLD                    OEDY05                         BATCH DAY
     C                   KFLD                    OECC05                         BATCH CNTRY
     C                   KFLD                    OEYR05                         BATCH YEAR
     C                   KFLD                    OENO15                         BATCH NBR
     C     JOBKEY        KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    OENO06                         JOB NUMBER
     C     OAKEY         KLIST
     C                   KFLD                    OENO19                         ORDER #
     C                   KFLD                    OENO31                         C/O CNTL #
     C     OAKEY1        KLIST
     C                   KFLD                    OENO19                         ORDER #
     C                   KFLD                    ORDOAL                         LINE CTL #
     C     OABRK         KLIST
     C                   KFLD                    OANO16                         BRANCH
     C                   KFLD                    AVNO07                         ITEM #
     C     AKEY          KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    CDA1                           S/M CODE
     C     AKEY2         KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    CDA1                           S/M CODE
     C                   KFLD                    ARNM21                         SHORT DESC
     C     AKEY3         KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    CDA1                           S/M CODE
     C                   KFLD                    SVNO40                         CTL#
     C     ALIKEY        KLIST                                                  ALIAS
     C                   KFLD                    ZZNO04                         PROD #
     C                   KFLD                    WKCUST                         CUSTOMER
      *  EDI TRADING PARTNER KEY
      *
     C     ORGKEY        KLIST
     C                   KFLD                    OENO26
     C                   KFLD                    OECC03
     C                   KFLD                    OEYR03
     C                   KFLD                    OEMO03
     C                   KFLD                    OEDY03
     C                   KFLD                    OENO01
      *
     C     POKEY1        KLIST                                                  POLTOL
     C                   KFLD                    PODN10                         NON-STOCK #
      *
     C     POKEY2        KLIST                                                  POLTOL5
     C                   KFLD                    PONO01                         P/O NUMBER
     C                   KFLD                    IVNO07                         ITEM NUMBER
      *
     C     KEYLD1        KLIST
     C                   KFLD                    OENO01
     C                   KFLD                    OENO22
      *
     C     KEYLD2        KLIST
     C                   KFLD                    OENO01
     C                   KFLD                    OENO22
     C                   KFLD                    LDNO56
     C     KEYLOT        KLIST
     C                   KFLD                    OENO19
     C                   KFLD                    OANO31
     C     KEYLT2        KLIST
     C                   KFLD                    OENO19
     C                   KFLD                    LOT#31
     C                   KFLD                    ORNO56
     C     KEYLLN        KLIST
     C                   KFLD                    OENO19
     C                   KFLD                    LOT#31
     C     EBKEY         KLIST
     C                   KFLD                    ARNO82                         ENTERPRISE
     C                   KFLD                    NO15                           COMPANY
MO    *
MO   C     NSBKEY        KLIST
MO   C                   KFLD                    NBNO10
MO   C                   KFLD                    NBNON1
      *
OA   C     ori1ky        klist
OA   C                   kfld                    arno01
OA   C                   kfld                    goeno01
OA   C                   kfld                    goeno22
OA   C     ori2ky        klist
OA   C                   kfld                    arno01
OA   C                   kfld                    cmemo
OA   C                   kfld                    cseq
OA   C     ori3ky        klist
OA   C                   kfld                    arno01
OA   C                   kfld                    cmemo
OA   C     tolynky       klist
OA   C                   kfld                    oeno14
OA   C                   kfld                    OLINE#
OA   C     tor2          KLIST
OA   C                   KFLD                    r2arno15
OA   C                   KFLD                    r2oeno01
OA   C                   KFLD                    r2oecd06
OA   C     torkey        KLIST
OA   C                   KFLD                    or5oeno01
OA   C                   KFLD                    or5oecd06
OA   C     PRCKEY        KLIST
OA   C                   KFLD                    ARNO01
OA   C                   KFLD                    Z_OENO01
OA   C                   KFLD                    Z_oeno22
OA    *
OA   C     pcc1ky        klist
OA   C                   kfld                    arno01
OA   C                   kfld                    ordno#
OA   C                   kfld                    ordline#
QQ   C     kWusr         Klist
QQ   C                   kfld                    arno01
QQ   C                   kfld                    oenm17
QQ    *
QW   C     kLTag         Klist
QW   C                   kfld                    wkTagTrnNo
QW   C                   kfld                    wkTagLinNo
QW    *
Q1   C     KL_TCCT1      KLIST
Q1   C                   KFLD                    piTran
Q1   C                   KFLD                    tranType          1
Q1    *
RK   C     KeyClip1      klist
RK   C                   kfld                    SessioNmMv
RK   C                   kfld                    EnttypCdMv
RK   C                   kfld                    Clipk1CdMv
RK   C                   kfld                    Clipk2CdMv
RK   C                   kfld                    Clipk3CdMv
RK   C                   kfld                    Clipk4CdMv
RK   C                   kfld                    Clipk5CdMv
RZ    *
VL   C     KeyClip2      klist
VL   C                   kfld                    SessioNmMv
VL   C                   kfld                    EnttypCdMv
VL    *
RZ   C     trakey        klist
RZ   C                   kfld                    tranum
RZ   C                   kfld                    tratyp
      *
SV   C     uomky2        klist
SV   C                   kfld                    kivno07                        ITEM#
SV   C                   kfld                    kivcd08                        UOM TYPE CD
SV    *
SV   C     ivwky         klist
SV   C                   kfld                    kivno07                        ITEM#
SV   C                   kfld                    kivdn21                        PRICING UOM
SW    *
SW   C     ordkey        klist
SW   C                   kfld                    @oeno01                        ITEM#
SW   C                   kfld                    @oeno22                        PRICING UOM
TI    *
TI   C     k_Tbl3        klist
TI   C                   kfld                    kTbl                           ITEM#
TI   C                   kfld                    kDsc                           PRICING UOM
UG   C     kCsc3         klist
UG   C                   kfld                    oeno08
UG   C                   kfld                    kCode             1
UG   C     kCCD1         klist
UG   C                   kfld                    kBranch           3 0
V5   C                   kfld                    card_softtype
UG   C                   kfld                    kDevName
UJ    *
UJ   C     POVRKY        klist
UJ   C                   kfld                    OENO01
UJ   C                   kfld                    OENO22
UQ   C     MsbrKey       klist
UQ   C                   kfld                    oecd01
UQ   C                   kfld                    shpcod
UQ   C                   kfld                    oeno16
UW    *
UW   C     kTCCTD        KLIST
UW   C                   KFLD                    arno01
UW   C                   KFLD                    cdf4
UW   C                   KFLD                    kfla5
VN    *
VN   C     ADDONKY       KLIST
VN   C                   KFLD                    IVNO07
VN   C                   KFLD                    OPNM25
VN   C                   KFLD                    OPCD31
VN   C                   KFLD                    OPCD34
V4    *
V4   C     KL_TCCTG      KLIST
V4   C                   KFLD                    TknSrcCd          1
V4   C                   KFLD                    oeno01
%P   C     CARDKEY       KLIST
%P   C                   KFLD                    OENO01
%P   C                   KFLD                    TRAN_TYPE         1
%G    * Verify Order Fulfillments Status
%G   c                   Eval      WrkOENO01 = OENO01
%G   c                   Eval      WrkFFLSTS = *Blanks
%G   c                   Call      'UTRG2022'    UTRP2022
%G   c                   If        WrkFFLSTS <> 'N'
%G   c                   Goto      EndPgm
%G   c                   Endif
%G    * Verify Order Fulfillments Status
      *****************************************************************

$Z    * GET THE SMALL DOLLAR AUTO RELEASE AMOUNT
$Z   C     *DTAARA       DEFINE    SMDLAURT      SMLORDAMT
$Z   C                   IN        SMLORDAMT
¢(    * B2B Sub-Rutine Load Table Information
¢(   C                   Exsr      B2B_SBR001
¢(    * End-B2B
#L   C     UDATE         MULT      10000.01      TODAYS_DATE       6 0

OD   c                   eval      attachTxt = *blanks
OD   c                   eval      attachTxt = oeno01
OD   c                   call      'OPR2506'
OD   c                   parm                    attachTxt
OD   c                   parm                    attachType
OD   c                   parm      ' '           fileOpt
OD    *
MP   C                   clear                   woary
VJ   C                   clear                   file
     C                   MOVE      '02'          PMTTYP
     C                   MOVE      '3'           CLROPT            1
   UJC*                  MOVEL     'OEPWTA'      FILE             10
UJ   C                   MOVEL(P)  'OEPWTA'      FILE             10
     C                   CALL      'OPC9990'
     C                   PARM                    CLROPT
     C                   PARM                    FILE
UJ    *
UJ   C                   If        %open(OELWPOL1)
UJ   C                   Close     OELWPOL1
UJ   C                   Endif
UJ   C                   MOVE      '3'           CLROPT            1
UJ   C                   MOVEL(P)  'OEPWPOL'     FILE             10
UJ   C                   CALL      'OPC9990'
UJ   C                   PARM                    CLROPT
UJ   C                   PARM                    FILE
UJ   C                   MOVE      '3'           CLROPT            1
UJ   C                   MOVEL(P)  'OELWPOL1'    FILE             10
UJ   C                   CALL      'OPC9990'
UJ   C                   PARM                    CLROPT
UJ   C                   PARM                    FILE
UJ   C                   Open      OELWPOL1
UJ    * Clear contents of OEPWPOL
UJ   C     *Start        Setll     OELWPOL1
UJ   C                   Dou       %Eof(OELWPOL1)
UJ   C                   Read      OELWPOL1
UJ   C                   If        Not %Eof(OELWPOL1)
UJ   C                   Delete    OEFWPOL
UJ   C                   Endif
UJ   C                   Enddo
UJ    *
RB    * See if user is authorized to price overrides..
UJ   C                   clear                   prcautreqapv      1
UJ   C                   clear                   prcautcanapv      1
RB   C                   eval      user = usrnm
RB   C                   eval      id = 1
RB   C                   move      'OE'          app
RB   C                   move      'PRIC'        cde
RB   C                   eval      usrval = *blanks
RB   C                   eval      valfrm = *blanks
RB   C                   eval      rtncod = *blanks
RB   C                   CALL      'OPR8220'     PL8220
RB   C                   if        rtncod = '0'
RB   C                   eval      prcaut = usrval
UJ    * Field PRCAUTREQAPV will be set to 'Y' if the value of OE/PRIC/0001 is a '3' meaning
UJ    * the user can override a price but it will need manager approval.  Field PRCAUTCANAPV
UJ    * will be set to 'Y' if the value of OE/PRIC/0001 is a '4' meaning they can enter and/or
UJ    * approve price overrides.
UJ   C                   if        prcaut = '3'
UJ   C                   eval      prcautreqapv = 'Y'
UJ   C                   endif
UJ   C                   if        prcaut = '4'
UJ   C                   eval      prcautcanapv = 'Y'
UJ   C                   endif
RB   C                   endif
RB    *
RC    * See if user is authorized to maintain tax flag.
RC   C                   clear                   taxfaut
RC   C                   eval      user = usrnm
RC   C                   eval      id = 1
RC   C                   move      'OE'          app
RC   C                   move      'TAX '        cde
RC   C                   eval      usrval = *blanks
RC   C                   eval      valfrm = *blanks
RC   C                   eval      rtncod = *blanks
RC   C                   call      'OPR8220'     PL8220
RC   C                   if        rtncod = *off
RC   C                   eval      taxfaut = usrval
RC   C                   endif
RC    *
UM    * See if user is authorized to change shipped/backorde quantity fields
UM   C                   eval      user = usrnm
UM   C                   eval      id = 5
UM   C                   move      'OE'          app
UM   C                   move      'OEM '        cde
UM   C                   eval      usrval = *blanks
UM   C                   eval      valfrm = *blanks
UM   C                   eval      rtncod = *blanks
UM   C                   CALL      'OPR8220'     PL8220
UM   C                   if        rtncod = '0'
UM   C                   eval      authqty = usrval
UM   C                   endif
UM    *
UN    * See if user is authorized to print pickticket from all orders
UN   C                   eval      user = usrnm
UN   C                   eval      id = 6
UN   C                   move      'OE'          app
UN   C                   move      'OEM '        cde
UN   C                   eval      usrval = *blanks
UN   C                   eval      valfrm = *blanks
UN   C                   eval      rtncod = *blanks
UN   C                   CALL      'OPR8220'     PL8220
UN   C                   if        rtncod = '0'
UN   C                   eval      authprt = usrval
UN   C                   endif
UN    *
&C    * Is price override tracking activated?
&C   C                   EVAL      TABCOD = 'CM14'
&C   C                   EVAL      TABENT = 'PRICEOVRD'
&C   C                   EVAL      Price_Ovrd = ' '
&C   C     TABKEY        CHAIN     TBFMTBL
&C   C                   IF        %FOUND
&C   C                   EVAL      Price_Ovrd = %subst(TBNO03:1:1)
&C   C                   ENDIF
&C    *
&C    * Get start date for price override tracking
&C   C                   EVAL      TABCOD = 'CM14'
&C   C                   EVAL      TABENT = 'STARTDATE'
&C   C                   EVAL      POTSTARTCYMD = *ZEROS
&C   C     TABKEY        CHAIN     TBFMTBL
&C   C                   IF        %FOUND
&C   C                   MOVEL     TBNO03        POTSTARTCYMD
&C   C                   ENDIF
&C    *
NX   C                   Z-ADD     *ZEROS        WMCO#
     C                   EXSR      CLRWRK
:K   C                   EVAL      TimeStamp = %timestamp()
     C                   EXSR      INITL
VX    *
VX    * Check if branch allows credit card processing using card softwares
VX   C                   exsr      chkCrdBrn
VX    *
%W   C                   MOVE      *OFF          SVIN20
%W   C                   MOVE      *OFF          SVIN21
Q1   C                   IF        not webCreditCard
Q1   C                             and not B2B_RGA
Q1   C                             and not B2C_RGA
RZ   C                             or (regcshRGA
RZ SEC*                            and wPrcSal = 'Y')
SE   C                             and wPrcRGA = 'Y')
      * CHECK FOR ANY CREDIT CARD RECORDS IN A PENDING STATUS.
      * IF THERE ARE ANY WE WILL NEED TO VOID THEM.  THE ONLY WAY
      * THEY COULD EXIST IS IF A PREVIOUS MAINT SESSION ENDED
      * ABNORMALLY.
      *
     C                   MOVE      OENO01        TRANUM
     C                   MOVE      'S'           TRATYP
     C                   Z-ADD     *ZEROS        TOTCHG
     C                   MOVE      ' '           CARD
     C                   MOVE      'C'           PMODE
     C                   CALL      'OER9003'     PL9003
      *
     C     CARD          IFEQ      'Y'
     C     DSPLYS        TAG
     C                   EXFMT     OEF2063S
     C     *IN03         CABEQ     *ON           QEXIT
     C     *IN25         IFEQ      *ON
     C                   CALL      'HTR0010'
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     *ON           DSPLYS
     C                   ENDIF
     C                   Z-ADD     TOTCHG        TOTAPR
     C     TOTAPR        DOULE     *ZEROS
     C                   Z-ADD     TOTAPR        TOTCHG
     C                   MOVE      OENO01        TRANUM
     C                   MOVE      'S'           TRATYP
   RZC*                  MOVE      'M'           CCMODE
RZ   C                   MOVE      'V'           CCMODE
     C                   MOVE      ' '           APRVD
¢(    * B2B - Credit Memo Information
¢(   C                   In        PARAM                                        *LDA
¢(   C                   Eval      W_Backup = W_OECD08                          Backup local area
¢(   C                                      + W_OENO14
¢(   C                   Eval      W_OECD08 = OECD08                            'C' = Credit Memo
¢(   C                   Eval      W_OENO14 = OENO14                            Credit Memo Order #
¢(   C                   Out       PARAM                                        *LDA
¢(    * End-B2B
RZ UG * If using Curbstone card software, call OER9602
UG    * If using card software, call OER9602
RZ   C                   if        alwCard  = 'Y'
RZ VXC*                  call      'OER9602'     pl9602
VX   C                   MOVE      'D'           PMODE
VX   C                   call      'OER9003'     pl9003
VX   C                   Z-ADD     *ZEROS        TOTAPR
RZ   C                   else
     C                   CALL      'OER9000'     PL9000
RZ   C                   endif
¢(    * B2B Resture local area
¢(   C                   In        PARAM                                        *LDA
¢(   C                   Eval      W_OECD08 = %Subst(W_Backup:1:1)              Restore local area
¢(   C                   Eval      W_OENO14 = %Subst(W_Backup:2:7)
¢(   C                   Out       PARAM                                        *LDA
¢(    * End-B2B
     C     APRVD         IFEQ      'Y'
!¢4  c                   if        OECD08 <> 'C'
     C                   ADD       TOTCHG        TOTAPR
!¢4  C                   else
!¢4  C                   sub       TOTCHG        TOTAPR
!¢4  C                   endif
     C                   ENDIF
     C     TOTAPR        IFEQ      *ZEROS
     C                   MOVE      ' '           CARD              1
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
Q1   C                   ENDIF
      *
     C                   CLEAR                   EMAIL
     C                   MOVE      'N'           ZEROPO            1
     C                   MOVE      ' '           RESTR
¢W   C                   MOVE      'N'           GPERR1            1
     C                   MOVE      'N'           UNLTWI
     C                   MOVE      'N'           UNLTOA
     C                   MOVE      'N'           UNLTOC
     C                   MOVEL     'OE'          TYPPGM            3
     C                   MOVE      'UPD'         UPDADD            3
     C                   CLEAR                   RRNERR
     C                   Z-ADD     *ZERO         RTRNCD                         RETURN CODE
      *
      * SEE WHAT ADD ONS ARE BEING USED
      *
     C                   MOVE      'ADON'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'ADDON'       TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        ADONS
     C                   ELSE
     C                   MOVE      *ALL'N'       ADONS
     C                   ENDIF
¢O    *
¢O    * SEE IF COD FLAG SET TO PROTECT
¢O    *
¢O   C                   MOVE      'CM04'        TABCOD
¢O   C                   MOVE      *BLANKS       TABENT
¢O   C                   MOVEL     'CODFLAG'     TABENT
¢O   C     TABKEY        CHAIN     TBFMTBL                            40
¢O   C     *IN40         IFEQ      *OFF
¢O   C                   MOVEL     TBNO03        CODFLG            1
¢O   C                   ELSE
¢O   C                   MOVEL     'N'           CODFLG
¢O   C                   ENDIF
¢O    *
¢O    * SEE IF COD FLAG SET TO PROTECT
¢O    *
¢O   C                   MOVE      'CM04'        TABCOD
¢O   C                   MOVE      *BLANKS       TABENT
¢O   C                   MOVEL     'CODTKT'      TABENT
¢O   C     TABKEY        CHAIN     TBFMTBL                            40
¢O   C     *IN40         IFEQ      *OFF
¢O   C                   MOVEL     TBNO03        CODTKT            1
¢O   C                   ELSE
¢O   C                   MOVEL     'N'           CODTKT
¢O   C                   ENDIF
N1    ***  RETRIEVE WAC INFLUENCES...
N1   C                   MOVE      'WAFR'        TABCOD
N1   C                   MOVE      *BLANKS       TABENT
N1   C                   MOVEL     'OE'          TABENT
N1   C     TABKEY        CHAIN     TBFMTBL                            40
N1   C     *IN40         IFEQ      *OFF
N1   C                   MOVEL     TBNO03        WAFR_OE           1
N1   C                   ELSE
N1   C                   MOVE      1             WAFR_OE
N1   C                   ENDIF
O3    * Check whether using Intellichief is used.
O3   C                   MOVE      '0'           ERR01             1
O3   C                   MOVE      *BLANKS       TABCOD
O3   C                   MOVEL     'IMAG'        TABCOD
O3   C                   MOVE      *BLANKS       TABENT
O3   C                   MOVEL     'ICSYS'       TABENT
O3   C     TABKEY        CHAIN     TBFMTBL                            40
O3   C     *IN40         IFEQ      *OFF
O3   C                   MOVEL     TBNO03        ICSYS             1
O3   C                   ELSE
O3   C                   MOVE      'N'           ICSYS
O3   C                   ENDIF
O3   C     ICSYS         IFEQ      'Y'
O3   C                   CALL      'OPC9805'
O3   C                   PARM                    ERR01             1
O3   C                   ENDIF
O3   C                   if        err01 = '1' and
O3   C                             isWebFaced() = *on
O3   C                   eval      err01 = '0'
O3   C                   endif
O3   C     ICSYS         IFEQ      'Y'
O3   C     ERR01         ANDEQ     '0'
O3   C                   MOVE      *ON           I_IN85            1
O3   C                   ELSE
O3   C                   MOVE      *OFF          I_IN85
O3   C                   ENDIF
O3    *
      *
      * SEE IF OVERRIDING COST ON COST PLUS MULTIPLIERS
      *
     C                   MOVE      'PR09'        TABCOD
     C                   MOVE      *BLANKS       TABENT                         INZ TAB ENT
     C                   MOVEL     'OVRCST'      TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        OVRCST            1            OVERRIDE COST
     C                   ELSE
     C                   MOVE      'N'           OVRCST
     C                   ENDIF
      *
      * SEE IF USING GST TAX ?
      *
     C                   MOVE      'AR17'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'GSTTAX'      TABENT
     C                   MOVE      'Y'           TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVE      'Y'           USEGST            1
     C                   MOVE      *ON           *IN67
     C                   MOVEL     TBNO03        GSTPCT
     C                   ELSE
     C                   MOVE      ' '           USEGST
     C                   END
UI    *
UI    * Check if AvaTax installed
UI   C                   eval      pmiapl = '18'
UI   C                   call      'OPR0400'     pl0400
UI   C                   if        pmoyn = 'Y'
UI    * Retrieve default for tax jurisdiction only if using avatax
UI   C                   eval      tabcod = 'TAXS'
UI   C                   eval      tabent = 'TAXDOWN'
UI   C     tabkey        chain     tbfmtbl
UI   C                   if        %found
UI   C                   eval      wDefTax = %trim(tbno03)
UI   C                   endif
UP    *
UP    * Retrieve default jurisdiction
UP   C                   clear                   wDefJuris         7
UP   C                   eval      tabcod = 'TAXS'
UP   C                   eval      tabent = *blanks
UP   C                   movel     'JURIS'       tabent
UP   C     tabkey        chain     tbfmtbl
UP   C                   if        %found
UP   C                   eval      wDefJuris = %trim(tbno03)
UP   C                   endif
QZ    *
QZ    * RETRIEVE TAX SETTINGS FOR AVATAX INTERFACE
QZ   C                   MOVE      'TAXS'        TABCOD
QZ   C                   MOVE      *BLANKS       TABENT
QZ   C                   MOVEL     'CONTROLS'    TABENT
QZ   C     TABKEY        CHAIN     TBFMTBL
QZ   C                   IF        %FOUND
QZ   C                   MOVEL     TBNO03        TAXS_CNTRLS
QZ   C                   ELSE
QZ   C                   CLEAR                   TAXS_CNTRLS
QZ   C                   ENDIF
UI   C                   endif
      *
      * CHECK IF FAXING IS SET UP FOR SALES ORDERS
     C                   MOVE      'FAX '        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'OE'          TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        FAXSO             1
     C                   ELSE
     C                   MOVE      'N'           FAXSO
     C                   ENDIF
      *
      * CHECK IF FAXING IS SET UP FOR SALES ORDERS
     C                   MOVE      'FAX '        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'EMAIL'       TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        EALLOW            1
     C                   ELSE
     C                   MOVE      'N'           EALLOW
     C                   ENDIF
QQ    * Check if FastFax is used.
QQ   C                   MOVE      'FAX '        TABCOD
QQ   C                   MOVE      *BLANKS       TABENT
QQ   C                   MOVEL     'FASTFAX'     TABENT
QQ   C     TABKEY        CHAIN     TBFMTBL                            40
QQ   C     *IN40         IFEQ      *OFF
QQ   C                   MOVEL     TBNO03        FFYES             1
QQ   C                   ELSE
QQ   C                   MOVE      'N'           FFYES
QQ   C                   ENDIF
MQ    *
MQ    * RETRIEVE G.P. MIN/MAX LIMITS FOR NON-DIRECTS
MQ    *
MQ   C                   MOVE      'PR05'        TABCOD
MQ   C                   MOVE      *BLANKS       TABENT
MQ   C                   MOVEL     'GPREG'       TABENT
MQ   C     TABKEY        CHAIN     TBFMTBL                            40
MQ   C     *IN40         IFEQ      *OFF
MQ   C                   MOVEL     TBNO03        RMNMX
MQ   C                   ENDIF
MQ    *
MQ    * RETRIEVE G.P. MIN/MAX LIMITS FOR DIRECTS
MQ    *
MQ   C                   MOVE      *BLANKS       TABENT
MQ   C                   MOVEL     'GPDIR'       TABENT
MQ   C     TABKEY        CHAIN     TBFMTBL                            40
MQ   C     *IN40         IFEQ      *OFF
MQ   C                   MOVEL     TBNO03        DMNMX
MQ   C                   ENDIF
UO    *
UO    * Retrieve Bid cost flags
UO   C                   CLEAR                   BIDCOST
UO   C                   MOVE      *BLANKS       TABENT
UO   C                   MOVE      'OB01'        TABCOD                         TABLE CODE
UO   C                   MOVEL     'RTNCST'      TABENT                         TABLE ENTRY
UO   C     TABKEY        CHAIN     TBFMTBL                            40
UO   C     *IN40         IFEQ      '0'
UO   C                   MOVEL     TBNO03        BIDCOST
UO   C                   ENDIF
UV    * RETRIEVE COST TABLE SETTINGS
UV   C                   MOVE      'COST'        TABCOD
UV   C                   MOVE      *BLANKS       TABENT
UV   C                   MOVEL(P)  'S/O'         TABENT
UV   C     TABKEY        CHAIN     TBFMTBL
UV   C                   IF        %FOUND
UV   C                   MOVEL     TBNO03        SOCOST            3
UV   C                   ENDIF
UV    * RETRIEVE DIRECT LANDED COST OPTION
UV   C                   MOVE      'AP20'        TABCOD
UV   C                   MOVE      *BLANKS       TABENT
UV   C                   MOVEL(P)  'DLCOST'      TABENT
UV   C     TABKEY        CHAIN     TBFMTBL
UV   C                   IF        %FOUND
UV   C                   MOVEL     TBNO03        DLCOST            1
UV   C                   ENDIF
UV    *
      *
      * See if user is authorized to maintain direct sales orders...
      *
     C                   CLEAR                   DAUTH
     C                   MOVEL     USRNM         USER
     C                   Z-ADD     8             ID
     C                   MOVE      'OE'          APP
     C                   MOVE      'USID'        CDE
     C                   MOVE      *BLANKS       USRVAL
     C                   MOVE      *BLANKS       VALFRM
     C                   MOVE      *BLANKS       RTNCOD
     C                   CALL      'OPR8220'     PL8220
     C     RTNCOD        IFEQ      '0'
     C                   MOVEL     USRVAL        DAUTH             1
     C                   ENDIF
      *
      * See if user is authorized to override price on line items
      * released from contracts...
      *
     C                   CLEAR                   AUTCP
     C                   MOVEL     USRNM         USER
     C                   Z-ADD     3             ID
     C                   MOVE      'OE'          APP
     C                   MOVE      'OEM '        CDE
     C                   MOVE      *BLANKS       USRVAL
     C                   MOVE      *BLANKS       VALFRM
     C                   MOVE      *BLANKS       RTNCOD
     C                   CALL      'OPR8220'     PL8220
     C     RTNCOD        IFEQ      '0'
     C                   MOVEL     USRVAL        AUTCP             1
     C                   ENDIF
OA    *  If user is authorized to change to open credit memo
OA   C                   MOVEL     USRNM         USER
OA   C                   MOVE      'OE'          APP
OA   C                   MOVE      'RGA '        CDE
OA   C                   Z-ADD     1             ID
OA   C                   MOVE      *BLANKS       USRVAL
OA   C                   MOVE      *BLANKS       VALFRM
OA   C                   MOVE      *BLANKS       RTNCOD
OA   C                   CALL      'OPR8220'     PL8220
OA   C     RTNCOD        IFEQ      '0'
OA   C                   MOVEL     USRVAL        GENCREDIT         1
OA   C                   ELSE
OA   C                   MOVE      *BLANKS       GENCREDIT
OA   C                   ENDIF
RM    *
RM    * See if user is authorized to maintain direct sales orders...
RM   C                   CLEAR                   WOAUTH
RM   C                   MOVEL     USRNM         USER
RM   C                   Z-ADD     1             ID
RM   C                   MOVE      'OE'          APP
RM   C                   MOVE      'WOID'        CDE
RM   C                   MOVE      *BLANKS       USRVAL
RM   C                   MOVE      *BLANKS       VALFRM
RM   C                   MOVE      *BLANKS       RTNCOD
RM   C                   CALL      'OPR8220'     PL8220
RM   C     RTNCOD        IFEQ      '0'
RM   C                   MOVEL     USRVAL        WOAUTH            1
RM   C                   ENDIF
VJ    *
VJ    * See if user is authorized to RePrice/Recost option...
VJ   C                   CLEAR                   Au_RprcRcst
VJ   C                   MOVEL     USRNM         USER
VJ   C                   Z-ADD     7             ID
VJ   C                   MOVE      'OE'          APP
VJ   C                   MOVE      'OEM '        CDE
VJ   C                   MOVE      *BLANKS       USRVAL
VJ   C                   MOVE      *BLANKS       VALFRM
VJ   C                   MOVE      *BLANKS       RTNCOD
VJ   C                   CALL      'OPR8220'     PL8220
VJ   C     RTNCOD        IFEQ      '0'
VJ   C                   MOVEL     USRVAL        Au_RprcRcst
VJ   C                   ENDIF
VJ    * Open Work File if Authorized to RePrice/ReCost option
VJ   C                   If        %Open(OEQWPRC01)
VJ   C                   Close     OEQWPRC01
VJ   C                   Endif
VJ    * Copy to QTEMP
VJ   C                   If        Au_RprcRcst = 'Y'
VJ   C                   clear                   file
VJ   C                   MOVE      '3'           CLROPT            1
VJ   C                   MOVEL     'OEQWPRC  '   FILE             10
VJ   C                   CALL      'OPC9990'
VJ   C                   PARM                    CLROPT
VJ   C                   PARM                    FILE
VJ   C                   MOVE      '3'           CLROPT            1
VJ   C                   MOVEL     'OEQWPRC01'   FILE             10
VJ   C                   CALL      'OPC9990'
VJ   C                   PARM                    CLROPT
VJ   C                   PARM                    FILE
VJ   C                   Open      OEQWPRC01
VJ   C                   If        Not %Open(OEQAPRC)
VJ   C                   Open      OEQAPRC
VJ   C                   Endif
VJ    * Clear Contents of OEQWPRC
VJ   C     *Start        Setll     OEQWPRC01
VJ   C                   Dou       %Eof(OEQWPRC01)
VJ   C                   Read      OEQWPRC01
VJ   C                   If        Not %Eof(OEQWPRC01)
VJ   C                   Delete    OEFWPRC
VJ   C                   Endif
VJ   C                   Enddo
VJ   C                   Endif
      *----------------------------------------------------------------
      *
     C                   Z-ADD     0             CO@               3 0          COMPANY
     C                   MOVE      'OE'          APPCDE            2            APPLICATION
     C                   Z-ADD     UDATE         RCVDT             6 0
     C                   Z-ADD     0             SAVORD
     C                   Z-ADD     0             SAVPRM
      *
     C     UMONTH        IFEQ      12
     C                   Z-ADD     0             WRKFLD
     C     *YEAR         ADD       1             WRKFLD            4 0
     C                   MOVE      WRKFLD        PUSY
     C                   Z-ADD     1             PUSM
     C                   Z-ADD     UYEAR         MINY
     C     UMONTH        SUB       1             MINM
     C                   ELSE
     C     UMONTH        IFEQ      1
     C                   Z-ADD     0             WRKFLD
     C     *YEAR         SUB       1             WRKFLD
     C                   MOVE      WRKFLD        MINY
     C                   Z-ADD     12            MINM
     C                   Z-ADD     UYEAR         PUSY
     C     UMONTH        ADD       1             PUSM
     C                   ELSE
     C                   Z-ADD     UYEAR         MINY
     C                   Z-ADD     UYEAR         PUSY
     C     UMONTH        ADD       1             PUSM
     C     UMONTH        SUB       1             MINM
     C                   END
     C                   END
     C                   Z-ADD     2             DATYP
     C                   MOVEL     PUSM          DATE4
     C                   MOVE      PUSY          DATE4
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   Z-ADD     DACEN         PUSC                                       Y
     C                   Z-ADD     2             DATYP
     C                   MOVEL     MINM          DATE4
     C                   MOVE      MINY          DATE4
     C                   MOVE      DS2000        PM2000                         SEND PARAMETERS
     C                   CALL      'OPR2000'     PL2000
     C                   MOVE      PM2000        DS2000                         RCV PARAMETERS
     C                   Z-ADD     DACEN         MINC                                       Y
      *
     C     *YEAR         ADD       2             PRMMXY
     C     *YEAR         SUB       2             PRMMNY
     C                   Z-ADD     0             SBATNO                         SAV BAT#
     C                   Z-ADD     0             SBATMO                         SAV BAT MO
     C                   Z-ADD     0             SBATDY                         SAV BAT DY
     C                   Z-ADD     0             SBATCC                         SAV BAT CC
     C                   Z-ADD     0             SBATYR                         SAV BAT YR
      *****************************************************************
      *  SECTION 1      PROCESS MAINLINE
      *
      * STEP 1.  CHAIN TO CUSTOMER MASTER & INITIALIZE SCREEN FIELDS
      * STEP 2.  HEADER INFORMATION MAINTENANCE
      * STEP 3.  CREDIT/DEBIT MEMO MAINTENANCE
      * STEP 4.  LINE ITEM MAINTENANCE
      * STEP 5.  OTHER CHARGES MAINTENANCE
      * STEP 6.  CASH SALES MAINTENANCE
      * STEP 7.  SUMMARY SCREEN
      * STEP 6.1  OVERRIDE MAINTENANCE
      * STEP 6.2  ENTER REQUIRED SERIAL NUMBERS
      *
      *****************************************************************
      * STEP 1. * CHAIN TO CUSTOMER MASTER & INITIALIZE SCREEN FIELDS
      ***********
      *
     C                   Z-ADD     0             STDT                           INIT'L DATE 3
     C                   Z-ADD     0             BILLDT
      *
     C                   MOVE      ' '           VDTJOB            1            VALIDATE JOB #
     C                   MOVE      *BLANKS       TBNO03                         TABLE ENTRY 3
     C                   MOVE      *BLANKS       ARNM21                         SHORT DESC
     C                   Z-ADD     0             SVNO40                         ALT/ADDR CTL
      * GET CREDIT LIMIT SETTING - COMPANY OR CONSOLIDATED
      ** A = CREDIT LIMIT BY COMPANY (FROM BALANCE RECORD)
      ** C = CREDIT LIMIT BY CUSTOMER (FROM CUSTOMER/ENTERPRISE RECORD)
     C                   CLEAR                   CONSOL
     C                   MOVE      'AR09'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'MAINT'       TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        CONSOL            1
     C                   ENDIF
     C     CONSOL        IFNE      'A'
     C     CONSOL        ANDNE     'C'
     C                   MOVEL     'C'           CONSOL
     C                   ENDIF
      *
      * RETREIVE AUTHORITY FOR GENERATING P.O.'S
     C                   MOVE      'N'           OVRBIL            1
      *
OA   C                   MOVE      ' '           VRAUTH
     C                   MOVE      'USID'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     USRNM         TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C     *IN40         IFEQ      '1'                                          DSP G/P %
     C                   MOVE      *ALL'N'       PROHIB
     C                   MOVE      *OFF          GENPOS
     C                   MOVE      *OFF          TFRGEN
     C                   MOVE      'N'           ALWTRN
     C                   ELSE
     C                   MOVEL     TBNO03        PROHIB
     C                   END
      *
     C                   SELECT
     C     GENPOS        WHENEQ    '0'
     C                   MOVE      'NN'          POAUTH
     C     GENPOS        WHENEQ    '1'
     C                   MOVE      'YN'          POAUTH
     C     GENPOS        WHENEQ    '2'
     C                   MOVE      'NY'          POAUTH
     C     GENPOS        WHENEQ    '3'
     C                   MOVE      'YY'          POAUTH
     C                   OTHER
     C                   MOVE      'NN'          POAUTH
     C                   ENDSL
      *
   MPC*    WOSYS         IFEQ      'Y'
   MP *
   MP * RETRIEVE USER SECURITY FOR GENERATING WORK ORDER
   MP *
   MPC*                  MOVE      'WOID'        TABCOD
   MPC*                  MOVE      *BLANKS       TABENT
   MPC*                  MOVEL     USRNM         TABENT
   MPC*    TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
   MP *
   MPC*    *IN40         IFEQ      *ON                                          NOT AUTH
   MPC*                  MOVE      'N'           WOGEN             1
   MPC*                  ELSE
   MPC*                  MOVEL     TBNO03        WOGEN
   MPC*                  ENDIF
   MP *
   MPC*                  MOVE      *BLANKS       TBNO03                         TABLE ENTRY 3
   MP *
   MPC*                  ENDIF
      *
      * RETREIVE O/E DEFAULTS
      *
     C                   MOVE      'OE40'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'OPTIONS'     TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C     *IN40         IFEQ      '1'                                          DSP G/P %
     C                   MOVE      *ALL' '       OPTS
     C                   ELSE
     C                   MOVEL     TBNO03        OPTS
     C                   END
      *
     C                   MOVE      'OE40'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'OPTION2'     TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      *OFF
     C                   MOVE      TBNO03        OTHOPT
     C     ADDLOT        IFNE      'Y'
     C                   MOVE      'N'           ADDLOT
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ALL'N'       TAXOPT
     C                   ENDIF
      * MESSAGE RESET OPTIONS...
     C                   MOVE      'OE40'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'RESETALL'    TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C     *IN40         IFEQ      *ON                                          DSP G/P %
     C                   MOVE      *ALL' '       RSET
     C                   ELSE
     C                   MOVEL     TBNO03        RSET
     C                   ENDIF
      *
      * RETRIEVE HOLD CONDITIONS
      *
     C                   MOVE      'OE90'        TABCOD
     C                   MOVE      *BLANKS       TABENT                         TABLE ENTRY
     C                   MOVEL     'HOLD'        TABENT                         TABLE ENTRY
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TBNO03        HLDCND
     C                   ENDIF
      *
      * RETREIVE TABLE FOR 'EDI' INSTALLED
     C                   MOVE      'EDI '        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'EDI '        TABENT
     C                   MOVE      'Y'           TABENT
     C     TABKEY        SETLL     TBFMTBL                                40
     C     *IN40         IFEQ      '1'
     C                   MOVE      'Y'           ONEDI
      * CHECK FOR EDI PURCHASE ORDER ACKNOWLEDGMENT
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'PO855S'      TABENT
     C                   MOVE      'Y'           TABENT
     C     TABKEY        SETLL     TBFMTBL                                40    TABLE FILE
     C     *IN40         IFEQ      '1'                                           NO P/O ACK?
     C                   MOVE      'Y'           ONPOA                          POA'S ACTIVE
     C                   END
      * CHECK FOR EDI SHIPPING CONFIRMATION
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'AR856S'      TABENT
     C                   MOVE      'Y'           TABENT
     C     TABKEY        SETLL     TBFMTBL                                40    TABLE FILE
     C     *IN40         IFEQ      '1'                                           NO SHP CF?
     C                   MOVE      'Y'           ONSHP                          POA'S ACTIVE
     C                   END
     C                   END
      *
      * GET TABLE FOR JOB VALIDATION TEST
      *
     C                   MOVE      'AR15'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'VDTJOB'      TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TBNO03        VDTJOB                         VALIDATE JOB ?
     C                   END
     C                   MOVE      *BLANKS       TBNO03                         TABLE ENTRY 3
      *
      * CLIENT USE FEET/INCHES ????
      *
     C                   MOVE      'OE20'        TABCOD                         PRICE THIS
     C                   MOVE      *BLANKS       TABENT                         ORDER ?
     C                   MOVEL     'YES'         TABENT                         ORDER ?
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C     *IN40         IFEQ      '1'
     C                   MOVEA     '1'           *IN(56)                        NO FEET/INCHES
     C                   ELSE
     C                   MOVEA     '0'           *IN(56)                        N56 YES FEET
     C                   END                                                    AND INCHES
      *
      * PICK TICKET PRINT CONTROL
      *
     C                   MOVE      'OE30'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'CONTROL'     TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TBNO03        PRTCTL
     C                   END
MR NP *
MR NP ***  RETRIEVE SERIAL NUMBER SETTING
MR NPC*                  MOVE      'IV60'        TABCOD
MR NPC*                  MOVE      *BLANKS       TABENT
MR NPC*    DSPCST        IFEQ      'R'                                          REVIEW MODE
MR NPC*                  MOVEL     'SOR'         TABENT
MR NPC*                  ELSE
MR NPC*                  MOVEL     'SOM'         TABENT
MR NPC*                  ENDIF
MR NPC*    TABKEY        CHAIN     TBFMTBL                            40
MR NPC*    *IN40         IFEQ      '0'
MR NPC*                  MOVEL     TBNO03        SRLSET
MR NPC*                  ELSE
MR NPC*                  MOVE      *BLANKS       SRLSET
MR NPC*                  ENDIF
MR NPC*    SKIP_SRL      IFEQ      'Y'
MR NPC*                  MOVE      'N'           REQSR#            1
MR NPC*                  ELSE
MR NPC*                  MOVE      'Y'           REQSR#
MR NPC*                  ENDIF
      *
      * MUST AUTHORIZE RE-PRINT ABILITY       .
      *
     C                   CALL      'OPR0026'     PL0260                         AUTH PROGRAM
      *
      * CMD KEYS PRICING/PROBLEM HOLD ALLOWED ?
      *
      *
      * RETRIEVE WALKIN CUSTOMER DEFAULTS
      * GENERATE BACK ORDERS FOR WALKINS ?
      * WALKIN CUSTOMER BACK ORDER PRIORITY CODE
      *
     C                   MOVE      'OE50'        TABCOD
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     'WALKINS'     TABENT
     C     TABKEY        CHAIN     TBFMTBL                            40
     C     *IN40         IFEQ      '0'
     C                   MOVE      WBO           BOYN              1
     C                   MOVE      WPR           BOPRO             3 0
     C                   ELSE
     C                   MOVE      'N'           BOYN
     C                   Z-ADD     0             BOPRO
     C                   END
      *
      * INITIALIZE AGE MODES & CODES
      *
     C                   CLEAR                   PMAGOP
     C                   CALL      'ARR0100'     PL0100
     C                   MOVEL     PMAGOP        AGEOPT
      *
      * RETRIEVE USER SECURITY PROFILE
      *
     C                   MOVE      'UIDS'        TABCOD                         USER AUTH
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     USRNM         TABENT                         USERID
     C                   MOVE      *BLANKS       TBN03
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C  N40              MOVEL     TBNO03        SECPRF            7            PROFILE
     C  N40              MOVE      TBNO03        TBN03
      *
      * RETRIEVE TABLE TO DETERMINE WHETHER TO DEFAULT QTY ORD TO
      * QTY BACKORDERED FOR NONSTOCK ITEMS.
      *
      * UNLOCK NON STOCK DATA AREA--ITEM NUMBER IDENTIFIER
      *
     C     *DTAARA       DEFINE                  NXTTDD
     C     *DTAARA       DEFINE                  NSITEM                         NON STOCK ITEM
     C                   UNLOCK    NSITEM                                       NUMBER
      *
      * INITIALIZE CUSTOMER FAX FIELDS
     C                   MOVE      'N'           FAXTKT                         FAX PICK TICK
     C                   MOVE      'N'           FAXPRC                         FAX PRICES
     C                   MOVE      *BLANKS       FAXOPT                         FAX OPTIONS
     C                   MOVE      *BLANKS       REQDAT                         REQUESTED FAX DATE
     C                   MOVE      *BLANKS       REQTIM                         REQUESTED FAX TIME
     C                   Z-ADD     *ZEROS        FAREA                          FAX AREA CODE
     C                   Z-ADD     *ZEROS        FPRFX                          FAX PREFIX
     C                   Z-ADD     *ZEROS        FSUFX                          FAX SUFFIX
     C                   Z-ADD     *ZEROS        SVFARA
     C                   Z-ADD     *ZEROS        SVFPRE
     C                   Z-ADD     *ZEROS        SVFSUF
     C                   MOVE      *OFF          SVN60             1
RL   C                   eval      woexs = 'N'
RL   C                   eval      woalc = 'N'
VT    *
VT    * Retrieve Enhanced Lost Sales Tracking Flag
VT    *
VT   C                   MOVE      'OE97'        TABCOD
VT   C                   MOVE      *BLANKS       TABENT
VT   C                   Eval      TABENT = 'LST' + %editc(ARNO15:'X')
VT   C                   MOVE      'N'           EnhLstTrk         1
VT   C     TABKEY        CHAIN     TBFMTBL                            40
VT   C     *IN40         IFEQ      *OFF
VT   C                   Eval      EnhLstTrk = %subst(TBNO03:1:1)
VT   C                   Endif
      *
      * CUSTOMER SUBROUTINE
      *
TZ    * walkin account info
TZ   c                   eval      wino07 = *zeros
TZ   c                   eval      wino08 = *zeros
TZ   c                   eval      wino09 = *zeros
TZ   c                   eval      winm09 = *blanks
TZ   c                   eval      gencsh = ' '
TZ    *
     C                   EXSR      CSTSR
¢O   C     OECD03        IFEQ      'C'
¢O   C     OECD04        ANDEQ     'K'
¢O   C     OEFL03        ANDNE     'Y'
¢O   C     OEcn02        ANDeq     0
¢O   C                   MOVE      'N'           CODFLG
¢O   C                   ENDIF
     C                   Z-ADD     1             PCRRN
QZ    * If this is a B2C order and we're in order review mode,
TI    * or it is an order taxed using tax software
QZ    * Check to see if the tax software connection is working...
QZ   C                   CLEAR                   Msg9050
SP   C                   CLEAR                   ErrCd
TI   C                   eval      msgdsp = *blanks
TI   C                   eval      taxerr = *blanks
TI   C                   eval      piPgmName = prog
QZ   C                   EVAL      TxsWarnR = *OFF
QZ TIC*                  IF        B2C and DSPCST = 'R'
TI   C                   IF        B2C
TI   C                             or TaxCalType = 'A'
RX    *
RX    * Determine if licensed to this product...
RX    * The following license key checking logic may not be altered, bypassed or removed.
RX    * See Legal Document in WRKMINKEY command for more information.
RX TIC*                  if        LicToB2CHD
TI   C                   if        B2C and LicToB2CHD
TI   C                             or TaxCalType = 'A'
TI   C                             and LicToAvaTax
RX    *
QZ   C                   If        TAXCAL_ENABLED = 'N'
QZ   C                   EVAL      TxsWarnR = *ON
TI   C                   eval      piTaxErrCd = '02'
TI   C                   eval      pMode      = 'D'
TI   C                   eval      taxErr = 'Y'
TI   C                   eval      piAPIRqstTyp = 'CFG'
TI   C                   exsr      WrtAvaTaxLog
QZ   C                   else
UI    * Set variable to check connection afresh if previous order had
UI    * send receive error
UI   C                   if        taxNetErr = 'Y'
UI   C                   eval      msg9050 = 'CheckConnection'
UI   C                   endif
UI   C                   clear                   taxNetErr
QZ   C                   CALL      'AIR9050'     P_AIR9050
QZ   C                   If        %trim(Msg9050) <> 'Success'
QZ   C                   EVAL      TxsWarnR = *ON
TI   C                   eval      pMode      = 'D'
TI   C                   eval      taxErr = 'Y'
TI   C                   eval      piTaxErrCd = '01'
TI   C                   eval      piAPIErrMsg= Msg9050
TI   C                   eval      piAPIRqstTyp = 'CNN'
TI   C                   exsr      WrtAvaTaxLog
QZ   C                   ENDIF
QZ   C                   ENDIF
RX    * Display error message if not licensed to B2C HD
TI    * or licensed to AvaTax
RX   C                   else
TI   C                   if        B2C
RX   C                   eval       p1300app = 'B2CHD'
TI   C                   else
TI   C                   eval      p1300app = 'AVATAX'
TI   C                   endif
RX   C                   eval       p1300bypass= 'N'
RX   C                   call      'MNR1300'     pl1300
RX   C                   endif
RX    *
QZ   C                   ENDIF
      ***********
      * STEP 2. * HEADER INFORMATION MAINTENANCE
      ***********
     C     HDRTAG        TAG
     C                   MOVE      *IN35         SVIN35            1
     C                   EXSR      HDRSR
     C                   MOVE      SVIN35        *IN35
     C     *IN03         CABEQ     '1'           ENDPGM                         CMD 03 RETURN
      *
     C     OECD10        IFEQ      'C'
     C                   MOVE      *ON           *IN01
     C                   ELSE
     C                   MOVE      *OFF          *IN01
     C                   ENDIF
Q0   C                   IF        B2B or B2C
Q0   C                   EXSR      GetWebEmail
Q0   C                   ELSE
Q0   C                   EVAL      wcEmail = *BLANKS
Q0   C                   ENDIF
      *
      *
      ***********
      * STEP 4. * DETAIL LINE ITEMS
      ***********
     C     DTLLIN        TAG
     C                   EXSR      LINSR
      *
      * STSCOD INITIALIZED WILL NOT RE-INITIALIZE SUBFILE
      *
     C                   Z-ADD     1             STSCOD            1 0
     C                   MOVE      ' '           TAXCHG
      *
     C     *IN03         CABEQ     '1'           ENDPGM                         CMD 03 RETURN
     C     *IN12         CABEQ     *ON           HDRTAG                         CMD 12 PREVIOUS
      ***********
      * STEP 6. * RETURNED ITEM REASON CODE AND DAMAGED ITEM TAG #'S
      ***********
     C     RTNLIN        TAG
     C                   MOVE      *IN10         SVIN10            1            SAVE IND 10
     C     OECD08        IFNE      'O'
     C     OECD08        ANDNE     'Q'
     C     OECD08        CASNE     'O'           RTNSR                          RETURN SUB RTN.
     C                   END
     C                   END
      *
     C     *IN03         CABEQ     '1'           ENDPGM                         CMD 03 REURN
     C     *IN12         CABEQ     '1'           DTLLIN                         CMD 12 PREVIOUS
     C     *IN10         IFEQ      '0'                                          WALKIN ?
     C                   MOVE      SVIN10        *IN10                          RESTORE IN10
     C                   END
      *
      * PRICE THIS CUSTOMERS ORDER ?
      *
     C     OECD08        IFEQ      'Q'                                          QUOTATION
     C                   MOVEA     '1'           *IN(10)                        PRICE THIS
     C                   END
      *
      *
      * CASH SALE ?
      *
     C     OECD67        IFNE      'Y'
     C     OECD03        IFEQ      'C'                                          CASH SALE
     C     OEFL02        IFEQ      'Y'                                          PRINT INVOICE
     C     OEFL02        OREQ      'C'                                          COD
     C                   MOVEA     '1'           *IN(10)                        CMD 10 PRICING
     C                   END
     C                   END
      *
     C                   ELSE
     C                   MOVEA     '1'           *IN(10)
     C                   END
      *
      * CHARGE SALE INVOICE ?
      *
     C     OECD03        IFEQ      'R'                                          CHARGE SALE
     C     OEFL18        ANDEQ     'Y'
     C                   MOVEA     '1'           *IN(10)
     C                   END
      ***********
      * STEP 5. * LINE ITEMS PRICING SUBFILE
      ***********
      *
     C     PRCTAG        TAG
     C                   CLEAR                   REPRC
     C                   EXSR      PRICE                                        INTERACTIVE
     C     PRCLIN        TAG
     C                   CLEAR                   MSGFLD
     C                   EXSR      PRCSR                                        PRICING SUBFILE
      *
      *  NEED TO DO PRICE SUBROUTINE IF PRICE HAS BEEN BLANKED
     C     REPRC         IFEQ      'Y'
     C                   MOVE      *ON           *IN10
     C     REPRC         CABEQ     'Y'           PRCTAG
     C                   ENDIF
      *
     C     *IN03         CABEQ     '1'           ENDPGM                         CMD 03 REURN
     C     *IN12         IFEQ      '1'                                          CMD 12 PREVIOUS
     C                   MOVEA     '0'           *IN(10)                        CMD 10
     C     *IN12         CABEQ     '1'           RTNLIN                         CMD 12 PREVIOUS
     C                   END
      ***********
      * STEP 6. * OTHER CHARGES INFORMATION
      ***********
     C     OTHTAG        TAG
¢Z    * if ship mth changed to 'S', force user to other chgs
¢Z   C     force         ifeq      'Y'
¢Z   c     doneit        andeq     ' '
¢Z   c                   move      'Y'           oefl09
¢Z   c                   end
PB    * display other charges screen for Sales order with charge OR
PB    * Customer returns if change in price/rstk fee/flag or with charge
     C     OEFL09        IFEQ      'Y'                                          OTHER CHG FLAG
OA   C     calc_restk    oreq      'Y'                                          Calc Restock?
PB   C     oefl31        andeq     'Y'                                          Calc Restock?
PB   C     @resamt       orne      *zeros                                       Calc Restock?
PB   C     oefl31        andeq     'Y'                                          Calc Restock?
¢Z   C                   MOVE      *IN27         SVIN27            1
     C                   EXSR      OTHSR
¢Z   C                   MOVE      SVIN27        *IN27
     C     *IN03         CABEQ     '1'           ENDPGM                         CMD 03 RETURN
     C     *IN12         IFEQ      '1'                                          CMD 12 PREVIOUS
     C     *IN10         CABEQ     '1'           PRCLIN                         CMD 10 PRICING
     C     *IN12         CABEQ     '1'           RTNLIN                         CMD 12 PREVIOUS
     C                   END
     C                   END
      ***********
      * STEP 6.1* OVERRIDE MAINTENANCE
      ***********
     C                   MOVE      CDF9          HDRCF9
     C                   MOVE      CDB5          ARCDB5
     C                   Z-ADD     CD25          ARCD25
     C                   Z-ADD     0             ARCD26
     C                   Z-ADD     0             ARCDB6
      ***********
      * STEP 7. * CASH SALES INFORMATION
      ***********
     C     CSHTAG        TAG
      *
      * NO CASH IF ORDER HELD DUE TO CREDIT PROBLEMS
      *
     C     HLDORD        IFNE      'Y'
     C     OECD03        IFEQ      'C'                                          CASH/CHARGE CODE
     C     OEFL02        IFEQ      'Y'                                          PRINT INVOICE
     C     OEFL02        OREQ      'C'                                          COD
     C                   EXSR      CSHSR                                        CASH/CAHRGE
     C     *IN03         CABEQ     '1'           ENDPGM                         CMD 03 RETURN
     C     *IN12         IFEQ      '1'                                          CMD 12 PREVIOUS
     C     OEFL09        CABEQ     'Y'           OTHTAG                         OTHER CHARGES
     C     *IN10         CABEQ     '1'           PRCLIN                         CMD 10 PRICING
     C     *IN12         CABEQ     '1'           RTNLIN                         CMD 12 PREVIOUS
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ***********
      * STEP 8. * SUMMARY SCREEN
      ***********
     C     SUMM          TAG
     C                   CLEAR                   MSGFLD
     C                   MOVE      SVIN64        *IN64                          PROB HOLD
     C                   EXSR      SUMSR                                        COMPLETION SCREEN
     C     *IN03         CABEQ     '1'           ENDPGM                         CMD 03 RETURN
N5   C                   EXSR      CHKREM
N5    *NEED TO RE DISPLAY IF W/D DOLLAR AMT IS GREATER THAN
N5    *REMAINING AMOUNT
N5   C     WDRFLG        CABEQ     'Y'           CSHTAG
     C     *IN12         IFEQ      '1'                                          CMD 12 PREVIOUS
     C                   MOVE      '0'           *IN64                          CLEAR IND 64
     C     OEFL02        CABEQ     'Y'           CSHTAG                         CASH SALES CODE
     C     OEFL02        CABEQ     'C'           CSHTAG                         COD
     C     OEFL09        CABEQ     'Y'           OTHTAG                         OTHER CHGS FLAG
     C     *IN10         CABEQ     '1'           PRCLIN                         CMD 10 PRICING
     C     *IN12         CABEQ     '1'           RTNLIN                         CMD 12 PREVIOUS
     C                   END
TI    * Commit needs to happen during invoice run, so removing it here.
QZ TI * If it's a B2C invoice call the tax software
QZ TI * interface to 'commit' the tax...
QZ TIC*                  IF        B2C and OEFL02 = 'Y'
QZ TIC*                  EVAL      pCommitTran = 'Y'
QZ TIC*                  EXSR      Tax_API
QZ TIC*                  IF        %trim(pErrCode) <> 'Success'
QZ TIC*                  EVAL      MSGFLD = 'Tax cannot be calculated +
QZ TIC*                            for this transaction. Tax +
QZ TIC*                            calculator error.'
QZ TIC*    MSGFLD        CABNE     *BLANKS       SUMM
QZ TIC*                  ENDIF
QZ TIC*                  ENDIF
      *
      * CHECK IF FAX PICK TICKET IS EQUAL TO Y. IF SO, CALL FAX CONTROL PGM.
      *
SS    * Allow FAXSR to execute even for credit holds, as pick ticket is
SS    * to be printed for orders on credit hold.
TI UIC*                  if        taxerr <>'Y'
     C     FAXTKT        IFEQ      'F'
     C     *IN08         ANDEQ     *OFF
   SSC*    *IN09         ANDEQ     *OFF
     C     *IN10         ANDEQ     *OFF
     C     CVRSHT        IFEQ      ' '
     C     DELAY         OREQ      ' '
     C     ONEB4         OREQ      ' '
     C     FAXSC         ORNE      FAXSV
     C     EDTFAX        OREQ      'Y'
     C                   EXSR      FAXSR
     C                   Z-ADD     FAXSC         FAXSV
     C                   MOVE      *ON           SVN60
     C     FAXSC         CABEQ     FAXSV         SUMM
     C                   ENDIF
     C                   ENDIF
TI UIC*                  endif
SM    *
SM UG * Curbstone Card processing:
SM UG *   It will call Credit card inteface program OER9600 to
UG    * Credit Card processing for card softwares
UG    *   It will call Credit card inteface program to
SM    *   do the credit card processing. The logic below must remain as
SM    *   a last edits before we Write Order; this is done to minimize
SM    *   the number of times we have redo the credit card
SM    *   processing due to the changes to the order.
SM    *
SM    *   If there is a problem with the credit card processing,
SM    *   it will display Cash Sales screen.
SM    *
RZ    *
RZ UG * If curbstone and order is a cash invoice and card amount
RZ UG * entered process thru Curbstone if
UG    * If card software used and order is a cash invoice and card
UG    * amount entered, process through card software if
RZ    * . not ecommerce order/RGA
RZ    * . is cash sales RGA and process immediate is Yes
SL    * . is cash sales RGA created from orders that did not use
SL UG *   Curbstone for payment.
UG    *   card software for payment.
RZ    * . is anything else (sales order/debit memos)
RZ    *
RZ   C                   if        alwCard  = 'Y'
UG   C                             and wNetErr = *zeros
RZ   C                             and not webCreditCard
RZ   C                             and not B2B_RGA
RZ   C                             and not B2C_RGA
RZ   C                             and
RZ   C                             oecd03 = 'C' and
RZ   C                             oefl02 = 'Y' and
RZ   C                             oeam36 <> totapr
RZ   C                             and
RZ   C                             ((regcshRGA and
RZ SEC*                              wPrcSal = 'Y')
SE   C                               wPrcRGA = 'Y')
SL   C                             or (regcshRGA and
SL UGC*                              wOrigCrd  <> 'C')
UG   C                               wOrigCrd  <> 'C'
UG   C                               or regcshRGA and
UG   C                               wOrigCrd  <> 'F')
RZ   C                             or not regcshRGA)
RZ   C                   eval      svoeam36 = oeam36
RZ    *
SE UG * Calculate amount to send to Curbstone based on amt entered for
UG    * Calculate amount to send to card software based on amt entered for
SE    * card on display file and amount already approved.
SE    *
SE    * 1. If user zeroed out amt on card but an amt was already approved
SE    *    (Card = Y represents it), void the approved amount.
SE    *
SE    * 2. If user updates amt on card to less than amount already approved
SE    *     if it is an immediate sale/immediate refund(1 step process)
SE    *     void the excess amount
SE    *     (if it is a pre-auth(2 step process), the correct amt is to
SE    *      be updated to TCCT which will be used for settlement during
SE    *      invoice run. This is done in Upd_Tcct routine)
SE    *
SE    *  In both cases(1 & 2 above), if approved amt is-
SE    *   . NOT totally voided, go back cash sales screen, so user
SE    *     re-view & re-adjust the amounts
SE UG *   . totally voided (totapr=0), call Curbstone for approval
UG    *   . totally voided (totapr=0), call card software for approval
SE    *     of card amount entered(OEAM36)
SE    *
RZ   C                   select
RZ SE * If amount zeroed out and card was taken, void earlier transaction
RZ   C                   when      oeam36 = *zeros
RZ   C                             and card = 'Y'
RZ   C                   exsr      voidcards
RZ   C                   if        totapr <> *zeros
RZ   C                   goto      cshtag
RZ   C                   endif
RZ    *
RZ SE *
RZ SE * If amount paid by card is greater than approved amount, and if
RZ SE * it is a sale(not pre-auth), void the excess amount.
RZ SE * For pre-auth, simply update correct amount in TCCT file which
RZ SE * will be used for approval in settlement process during invoice run.
RZ   C                   when      oeam36 <> *zeros and
RZ   C                             %abs(totapr) > %abs(svoeam36)
RZ   C                             and card = 'Y'
RZ SEC*                            and wPrcSal = 'Y'
SE   C                             and (wPrcSal = 'Y'
SE   C                             or wPrcRGA = 'Y' )
RZ   C                   exsr      voidcards
RZ SE * If approved amount was completely voided and totapr = 0, call
RZ SE * Curbstone for approval of new card amount entered.
RZ   C                   if        totapr = *zeros
RZ   C                   eval      oeam36 = svoeam36
RZ   C                   else
RZ SE * If approved amount was not totally voided,go back to cash sales
RZ SE * so user can re-view & re-adjust.
RZ   C                   if        %abs(totapr) <> %abs(svoeam36)
RZ   C                   goto      cshtag
RZ   C                   endif
RZ   C                   endif
RZ    *
RZ   C                   endsl
SE    *
RZ UG * Call Curbstone program for interactive card selection if
UG    * Call card software program for interactive card selection if
RZ    * card amount entered is greater than approved amount.
RZ   C                   if        %abs(oeam36) > %abs(totapr)
RZ   C                   exsr      clr_pl9600
RZ   C                   exsr      call9600
U4    *
U4    * If partial refund on the same day S/O was shipped,
U4   C                   if        wPartRfd = 'Y'
U4   C                   eval      aprvd = 'Y'
U4   C                   else
RZ    *
RZ    * If error, go back to cash tag
RZ   C                   eval      aprvd = 'Y'
RZ   C                   if        pomsg <> *blanks and
RZ   C                             pomsg <> c@aprvd
RZ   C                   eval      aprvd = 'N'
UG   C                   if        card_interface= 'Y'
UG   C                   z-add     totapr        oeam36
UG   C                   endif
RZ   C                   goto      cshtag
RZ   C                   endif
U4   C                   endif
RZ   C                   z-add     totapr        oeam36
RZ    *
RZ   C                   endif
RZ   C                   endif
      *
      * CHECK IF EMAILING TICKET. IF SO, WRITE OPPTFXI RECORD.
      *
     C     FAXTKT        IFEQ      'E'
     C     EALLOW        ANDEQ     'Y'
     C     *IN08         ANDEQ     *OFF
     C     *IN09         ANDEQ     *OFF
     C     *IN10         ANDEQ     *OFF
QQ    * Write OPPTFXI record if B2B order and email is found.
QQ   C     WCEMAIL       orne      *BLANKS
QQ   C     *IN08         ANDEQ     *OFF
QQ   C     *IN09         ANDEQ     *OFF
QQ   C     *IN10         ANDEQ     *OFF
%B   C     FAXTKT        OREQ      'Y'
%B   C     EALLOW        ANDEQ     'Y'
%B   C     *IN08         ANDEQ     *OFF
%B   C     *IN09         ANDEQ     *OFF
%B   C     *IN10         ANDEQ     *OFF
     C                   MOVEL     OENO01        DOCNUM           12
TI    * If tax software is used, check if the order has tax errors.
TI UI * Do not fax/email if errors exist
UI    * Change it to calculate tax without using software.
UI    * Display message if no tax is to be calculated
UI    *
TI   C                   if        taxerr = 'Y'
UI   C                             and TaxCalType ='A'
UI   C                   eval      TaxCalType = ' '
UI   C                   if        wDefTax = 'Z'
UI   C                   eval      msgfld = 'Tax cannot be calculated. -
UI   C                             No tax is charged for this order.'
UP   C                   eval      msgfld = 'Warning! ' + msgfld
UL   C                   else
UL   C                   eval      msgfld = 'Tax software error. Tax -
UL   C                             calculated without using software.'
UP   C                   eval      msgfld = 'Warning! ' + msgfld
UI   C                   endif
TI UIC*                  eval      msgfld = 'Cannot email sales order as+
TI UIC*                            tax has not been calculated.'
TI   C     msgfld        cabne     *blanks       summ
TI   C                   else
TI    *
QQ   C                   IF        FFYES = 'N' and
QQ   C                             WCEMAIL <> *BLANKS
QQ   C                   MOVE      'OE03'        SYSID
QQ   C                   ELSE
     C                   MOVE      'OE02'        SYSID             4
QQ   C                   ENDIF
     C                   MOVE      *BLANKS       FAXNUM
     C                   MOVE      ARNO01        TRNNUM                         TRANSFER NUMBER
QQ   C                   IF        WCEMAIL <> *BLANKS
QQ   C                   EVAL      EMAIL = WCEMAIL
QQ   C                   ENDIF
RF   C     EMAIL         IFNE      MULTMG
     C                   CALL      'OPR0303'     PL0303
RF   C                   ELSE
RF    * PROCESS MULTIPLE EMAIL ADDRESSES
RF   C                   MOVE      JOBNBR        JOB##
RF   C                   CALL      'OPR0304'     PL0304
RF   C                   ENDIF
     C                   ENDIF
TI   C                   endif
      *
      * ENTER PRESSED--REMOVE ALL HOLDS
      *
¢C   C     OECD38        IFEQ      'Y'
¢C   C                   MOVEL     USRNM         USER1            10
¢C   C                   Z-ADD     UDATE         DATE
¢C   C                   TIME                    TIME
¢C   C                   END
     C                   MOVE      ' '           OEFL04                         PROBLEM FLAG
     C                   MOVE      ' '           OEFL05                         PRICING FLAG
     C                   MOVE      ' '           OECD38                         CREDIT HOLD
     C                   MOVE      ' '           CF09                           CREDIT HOLD
      *
      * CREDIT CHECK HOLD
      *
     C     HLDORD        IFEQ      'Y'
PM   C     HOLDIT        OREQ      'Y'
     C                   MOVE      *ON           *IN09
¢C   C                   MOVEL     *BLANKS       USER1
     C                   ENDIF
      *
      * F10=PRICING HOLD
      *
     C     *IN10         IFEQ      '1'
     C                   Z-ADD     0             OEMO05                         ZERO BATCH
     C                   Z-ADD     0             OEDY05                         DATE AND
     C                   Z-ADD     0             OECC05                         AND CENTURY
     C                   Z-ADD     0             OEYR05                         NUMBER
     C                   Z-ADD     0             OENO15                         WHEN
     C                   MOVE      'Y'           OEFL05                         PRICING HOLD
     C                   END
      *
      * CMD 08 HOLD FOR PROBLEM
      *
     C     *IN08         IFEQ      '1'
     C                   Z-ADD     0             OEMO05                         ZERO BATCH
     C                   Z-ADD     0             OEDY05                         DATE AND
     C                   Z-ADD     0             OECC05                         CENTURY AND
     C                   Z-ADD     0             OEYR05                         NUMBER
     C                   Z-ADD     0             OENO15                         WHEN
     C                   MOVE      'Y'           OEFL04                         PROBLEM FLAG
     C                   END
      *
      * F9=CREDIT HOLD
      *
   $wC*    *IN09         IFEQ      *ON
OA $wC*    OEFL31        IFEQ      'Y'
OA $wC*                  MOVE      'N'           USEMSG
OA $wC*                  END
   $wC*                  Z-ADD     0             OEMO05
   $wC*                  Z-ADD     0             OEDY05
   $wC*                  Z-ADD     0             OEYR05
   $wC*                  Z-ADD     0             OECC05
   $wC*                  Z-ADD     0             OENO15
   $wC*                  MOVE      'Y'           OECD38
   $wC*                  MOVE      'Y'           CF09
     C                   MOVE      OENO01        HOLD#             7
   $wC*    USEMSG        CASEQ     'Y'           SNDCRM
   $wC*                  ENDCS
   $wC*                  END
      *
&D    * F9=CREDIT HOLD
&D    *
&D   C     HLDORD        IFEQ      'Y'
&D   C                   MOVE      'Y'           OECD38
&D   C                   END
      *
      * WRITE ORDER
      *
      * RESTORE SOURCE & SALE TYPES
     C     SAVSOU        IFNE      *BLANK
     C                   MOVE      SAVSOU        OECD17                         SOURCE TYPE
     C                   END
     C     SAVSAL        IFNE      *BLANK
     C                   MOVE      SAVSAL        OECD19                         SALE TYPE
     C                   END
      *
     C                   EXSR      WRTSR                                        UPDATE SUBR
¢(    * B2B - Web Order Update Next Status
¢(   C                   If        %Lookup(BkB2B:WkB2B) <> *Zeros
¢(   C                   Exsr      B2B_SBR002
¢(   C                   Endif
¢(    * End-B2B
&C    * Price override tracking
&C    * This is only done on orders entered on or after the start date
&C    * This is only done on orders that are original order
&C    *
&C   C                   If        Price_ovrd = 'Y'
&C   C                   EVAL      ORDEREDCC = ARCC05
&C   C                   EVAL      ORDEREDYR = ARYR05
&C   C                   EVAL      ORDEREDMO = ARMO05
&C   C                   EVAL      ORDEREDDY = ARDY05
&C    *
&C   C                   IF        ORDEREDCYMD >= POTSTARTCYMD
&C   C                   IF        OENO01 = OENO26
&C   C                   CALL      'OERC029'
&C   C                   PARM                    OENO01
&C   C                   CALL      'OERC019'
&C   C                   PARM                    OENO01
&C   C                   ENDIF
&C   C                   ENDIF
&C   C                   ENDIF
%G    * - - - - - - - - - - - - - - - - - - - - - - - - - -
%G    * Order Fulfilments - Entry Counter Quantity Picking
%G   C                   Exsr      Sbr_2021
%G    * - - - - - - - - - - - - - - - - - - - - - - - - - -
     C                   Z-ADD     0             RNS                            TOTAL RNS ITMS ON S/
VP    *
VP    * Call program for jobsite address entry/maintenance
VP    *
VP   C                   IF        OECD08 = 'O'
VP   C                   CALL      'OER2312'     PL2312
VP   C                   ENDIF
      *
      * UPDATE LOT RECORDS
      *
     C     HAVLOT        IFEQ      'Y'
     C                   EXSR      UPDLOT
     C                   ENDIF
      *
      * GENERATE TRANSFERS ?
      *
     C     GENTRF        IFEQ      'Y'
     C                   MOVE      OENO26        ORGNO
     C                   MOVE      OENO01        ORDNO
     C                   CALL      'OER0112'
     C                   PARM                    ORGNO             7
     C                   PARM                    ORDNO             7
     C                   ENDIF
      *
   MPC*    WOSYS         IFEQ      'Y'
   MP *
   MP * IF GENWO = 'Y', CALL W/O INTERFACE PROGRAM
   MP *
   MPC*    GENWO         IFEQ      'Y'
   MPC*                  CLEAR                   WOS
   MPC*                  Z-ADD     OENO01        WOS(1)
   MPC*                  CALL      'WOR2010'     PL2010
   MPC*                  CLEAR                   WOS
   MPC*                  ENDIF
   MP *
   MPC*                  ENDIF
MV    *
MV    * CALL WARRANTY CLAIM UPDATE / SEND PROGRAM
MV    * IT WILL UDPATE CREDIT MEMO NUMBER IN WARRANTY CLAIM FILE.
MV    * IT WILL SEND THE CLAIM IF REQUESTED.
MV    *
MV :DC*    SNDWC         IFEQ      'Y'
MV :DC*    WARRANTY#     ORNE      *BLANKS
MV :DC*                  MOVE      OENO01        WC_OENO01
MV :DC*                  MOVE      'U'           WC_REQTYPE
MV :DC*                  CALL      'OER9431'
MV :DC*                  PARM                    WARRANTY#
MV :DC*                  PARM                    WC_OENO01         7
MV :DC*                  PARM                    WC_REQTYPE        1
MV :DC*                  PARM                    SNDWC
MV :DC*                  ENDIF
MV :EC*                  CLEAR                   WARRANTY#
MV   C                   CLEAR                   CREATE_MODE
MV    *
      *
      *
      * IF ATLEAST ONE ITEM WITH VENDOR RETURN FLAG = Y,
      *    CALL VENDOR RETURN WORK FILE BUILD PROGRAM.
      * ENDIF
     C     SVRFLG        IFEQ      'Y'
     C                   MOVE      OENO01        CRNO
     C                   CALL      'POR4350'
     C                   PARM                    CRNO              7
OA   C     OENO01        SETLL     POLWVRD1
OA   C                   IF        NOT(%EQUAL)
OA   C                   MOVE      *BLANK        SVRFLG
OA   C                   ENDIF
     C                   ENDIF
   OAC*                  MOVE      *BLANK        SVRFLG            1
      *
     C                   EXSR      DIRECT                                       ORDER DIRECT
      *------------------------------------------------------------------------*
      * Submit Direct Order Audit...
      *------------------------------------------------------------------------*
     C     OECD01        IFEQ      'D'
     C     CD01FL        OREQ      'D'
     C                   MOVE      OENO01        ALPHSO            7
     C                   MOVEA     ALPHSO        DOA(75)
     C                   MOVEA     DOA           CMD3            140
     C                   Z-ADD     140           LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD3
     C                   PARM                    LEN
     C                   ENDIF
      *----------------------------------------------------------------
      * Call program to delete any existing P/O tag records...
      *
     C                   MOVE      OENO01        ALPHSO
     C                   CALL      'POR0011'
     C                   PARM      'S'           PMMOD             1
     C                   PARM      'U'           PMUPD             1
     C                   PARM                    ALPHSO
      *----------------------------------------------------------------
      *  SEND EDI SHIPPING CONFIRMATION  (ADVANCE SHIPPING NOTICE)
      *----------------------------------------------------------------
     C     ONSHP         IFEQ      'Y'                                          EDI SHIP CONF
     C     DSPCST        ANDEQ     'R'                                          REVIEW ORDER
&1   C/Exec Sql
&1   C+ select count(*) into:@Count
&1   C+ from oeptol
&1   C+ where arno01=:arno01 and oeno01=:oeno01 and
&1   C+       OEQY03<>0
&1   C/END-EXEC
&1   C
&1   C                   If        @Count>0
     C                   MOVE      OENO01        SONUM             7
     C                   MOVE      'C'           EDICUS
     C                   CLEAR                   CUSNBR
     C                   CLEAR                   TRPNID
     C                   CLEAR                   DOCTYP
     C                   CLEAR                   SUBTYP
     C                   CLEAR                   RCVSTS
     C                   CLEAR                   TRPNID
     C                   CLEAR                   VENBRN
     C                   CLEAR                   VNDCUS
     C                   MOVEL     EDICUS        VNDCUS
     C                   MOVEL     ARNO01        CUSNBR
     C                   MOVEL     *BLANKS       TRPNID
     C                   MOVE      '856'         DOCTYP
     C                   EXSR      GETTPI
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     TRPNID        @TPID
     C                   MOVEL     ARNO01        @ACCT#
     C                   MOVEL     ARNO01        @TRANS
     C                   MOVE      OENO01        @TRANS
     C                   MOVE      *BLANKS       @ERRCD
     C                   CALL      'EIR1200'
     C                   PARM      'S856'        @DOCID            4
     C                   PARM                    @TPID            15
     C                   PARM                    @ACCT#            6
     C                   PARM                    @TRANS           15
     C                   PARM                    @ERRCD            3
     C                   END                                                    *IN44 IFEQ '1'
&1   C                   END                                                    DSPCST='R'
     C                   END                                                    DSPCST='R'
      *----------------------------------------------------------------
      *
      * END OF JOB
%W    *
%W   C                   if        wc_ra#<>*blanks and *inlr='0'
%W   C                   MOVEL     arno01        prCust
%W   C                   MOVEL     wc_ra#        prRANbr
%W   C                   call      'OERC510'     plc510
%W   C                   endif
%W   C                   MOVE      *BLANKS       wc_ra#
%W   C                   MOVE      *BLANKS       RaNum
      *
     C     ENDPGM        TAG
     C     *IN51         IFEQ      '1'                                          CMD 1-NO UPDATE
MP    *
MP   C                   if        *in03 = *on
MP   C                             and wosys = 'Y' and
MP   C                             genwo = 'Y'
MP   C                   exsr      srDelWo
MP   C                   endif
OD    *
OD    * Delete record from OPPWTRA in qtemp
OD   C                   call      'OPR2506'
OD   C                   parm                    attachTxt
OD   C                   parm                    attachType
OD   C                   parm      'D'           fileOpt
OD    *
     C                   EXCEPT    RELTOH                                       DUMMY UPDATE
     C     UNLTWI        IFEQ      'Y'                                          UNLOCK ARFTWI
     C                   EXCEPT    DMYTWI                                       DUMMY UPDATE
     C                   END
     C     UNLTOA        IFEQ      'Y'                                          UNLOCK OEFTOA
     C                   EXCEPT    DMYTOA                                       DUMMY UPDATE
     C                   END
     C     UNLTOC        IFEQ      'Y'                                          UNLOCK OEFTOC
     C                   EXCEPT    DMYTOC                                       DUMMY UPDATE
     C                   END
     C                   END                                                    UNLOCK RCDS
      *
   MRC*                  MOVE      OENO01        ORDER
      *
      * CMD KEY 01 ?
     C     *IN03         IFEQ      '0'
      *
      * WERE SERIAL #'S REQUIRED ?
     C     SRLTST        IFEQ      'Y'
      *  CALL PGM TO UPDATE ANY 'I' RECORDS TO 'A' RECORDS SRL # FILE
      *  OEC2064 SUBMITS OER2064 (HDJPACK) AND RETURNS
   MRC*                  MOVE      'U'           PGMREQ                         UPDATE FUNCTION
   MRC*                  CALL      'OEC2064'     SRLUPD
MR   C                   MOVE      'S'           SRLMOD                         'DELETE' MODE
MR   C                   MOVE      OENO01        TRAN#                          SRL TRANS NBR
MR   C                   MOVE      'SO'          TRNTYP                         SRL TRANS TYPE
MR   C                   CLEAR                   TRNLIN#                        SRL TRANS LINE
MR   C                   CLEAR                   SRLSEC                         SRL TEMP LINE
MR   C                   CLEAR                   SRLTLN                         SRL TEMP LINE
MR   C                   MOVE      *BLANK        SRLEXS                         SRL EXISTS
MR   C                   MOVE      'N'           SRL_USEJOB
NF   C     SKIP_DSP      IFNE      'N'
MR   C                   CALL      'IVR1801'     PL1801
NF   C                   ENDIF
     C                   END
     C                   ELSE
     C     NEWTDP        IFEQ      'Y'
     C     OPNDP1        ANDEQ     '1'
     C     NEWDEP        SETLL     OEFTDP                                 40
     C     *IN40         IFEQ      '1'
     C                   MOVE      *IN92         SVIN92            1            SAVE *IN92
     C                   MOVE      *BLANKS       DSPF1
     C     *IN92         DOUEQ     *OFF
     C     NEWDEP        READE     OEFTDP                               9240
     C     *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN92        *IN92                          RESTORE *IN92
     C     *IN40         IFEQ      '0'
      *
      * IF WE ARE ABOUT TO DELETE A DEPOSIT, SEE IF WE TOOK A
      * CREDIT CARD. IF SO, WE MUST VOID THE CARD.
      *
UG   C                   exsr      chkTcctD
     C                   MOVE      NEWDEP        TRANUM
     C                   MOVE      'D'           TRATYP
     C                   MOVE      'V'           CCMODE
¢(    * B2B - Credit Memo Information
¢(   C                   In        PARAM                                        *LDA
¢(   C                   Eval      W_Backup = W_OECD08                          Backup local area
¢(   C                                      + W_OENO14
¢(   C                   Eval      W_OECD08 = OECD08                            'C' = Credit Memo
¢(   C                   Eval      W_OENO14 = OENO14                            Credit Memo Order #
¢(   C                   Out       PARAM                                        *LDA
¢(    * End-B2B
RZ UG * If using Curbstone card software, call OER9602
UG    * If using card software, call OER9602
RZ   C                   if        alwCard  = 'Y'
UG   C                             and wNetErr = *zeros
UG   C                             and dTyp <> 'G'
RZ   C                   call      'OER9602'     pl9602
UG   C                   delete    oeftdp
VU    * Also delete OEPTDP/OEPTCRD records when the deposit is deleted.
VU    * (This program will delete these records if Credit card process fee applies)
VU   C                   call      'OER2039'     pl2039
RZ   C                   else
     C                   CALL      'OER9000'     PL9000
RZ UGC*                  endif
¢(    * B2B Resture local area
¢(   C                   In        PARAM                                        *LDA
¢(   C                   Eval      W_OECD08 = %Subst(W_Backup:1:1)              Restore local area
¢(   C                   Eval      W_OENO14 = %Subst(W_Backup:2:7)
¢(   C                   Out       PARAM                                        *LDA
¢(    * End-B2B
      *
     C                   DELETE    OEFTDP
UG   C                   endif
     C                   END
     C                   END
     C                   END
     C                   END
     C     ONPOA         IFEQ      'Y'                                          P/O ACK'S
     C     SAVEDI        ANDEQ     'EDI'                                        EDI RECORD
     C     PNDORD        ANDEQ     'Y'                                          ORIG PEND
     C     RESSTK        ANDEQ     'O'                                          NOW OPEN ORD
     C                   MOVE      OENO01        SONUM             7
     C                   MOVE      'C'           EDICUS
     C                   CLEAR                   CUSNBR
     C                   CLEAR                   TRPNID
     C                   CLEAR                   DOCTYP
     C                   CLEAR                   SUBTYP
     C                   CLEAR                   RCVSTS
     C                   CLEAR                   TRPNID
     C                   CLEAR                   VENBRN
     C                   CLEAR                   VNDCUS
     C                   MOVEL     EDICUS        VNDCUS
     C                   MOVEL     ARNO01        CUSNBR
     C                   MOVEL     *BLANKS       TRPNID
     C                   MOVE      '855'         DOCTYP
     C                   EXSR      GETTPI
     C     *IN40         IFEQ      '0'
     C                   MOVEL     TRPNID        @TPID
     C                   MOVEL     ARNO01        @ACCT#
     C                   MOVEL     OENO01        @TRANS
     C                   MOVE      *BLANKS       @ERRCD
     C                   CALL      'EIR1200'
     C                   PARM      'S855'        @DOCID            4
     C                   PARM                    @TPID            15
     C                   PARM                    @ACCT#            6
     C                   PARM                    @TRANS           15
     C                   PARM                    @ERRCD            3
&5   C                   EVAL      @ReqStst ='PP'
&5   C                   EVAL      @Response = '00'
&5   C                   EVAL      @ARNUM = %char(arno01)
&5   C                   EVAL      @OrdNum = oeno01
&5   C                   CALL      'E4REXTI3'    PL_E4REXTI3
&5    *
     C                   END
     C                   END
      *
      * IF CANCELLING PROGRAM, AND CARDS WERE TAKEN - VOID THEM.
      *
     C     *IN03         IFEQ      *ON
     C     CARD          ANDEQ     'Y'
Q1   C     webCreditCard ANDNE     *ON
Q1   C     B2B_RGA       ANDNE     *ON
Q1   C     B2C_RGA       ANDNE     *ON
     C                   MOVE      OENO01        TRANUM
     C                   MOVE      'S'           TRATYP
     C                   MOVE      'V'           CCMODE
¢(    * B2B - Credit Memo Information
¢(   C                   In        PARAM                                        *LDA
¢(   C                   Eval      W_Backup = W_OECD08                          Backup local area
¢(   C                                      + W_OENO14
¢(   C                   Eval      W_OECD08 = OECD08                            'C' = Credit Memo
¢(   C                   Eval      W_OENO14 = OENO14                            Credit Memo Order #
¢(   C                   Out       PARAM                                        *LDA
¢(    * End-B2B
RZ UG * If using Curbstone card software, call OER9602
UG    * If using card software, call OER9602
RZ   C                   if        alwCard  = 'Y'
UG   C                             and wNetErr = *zeros
RZ   C                   call      'OER9602'     pl9602
RZ   C                   else
     C                   CALL      'OER9000'     PL9000
RZ   C                   endif
¢(    * B2B Resture local area
¢(   C                   In        PARAM                                        *LDA
¢(   C                   Eval      W_OECD08 = %Subst(W_Backup:1:1)              Restore local area
¢(   C                   Eval      W_OENO14 = %Subst(W_Backup:2:7)
¢(   C                   Out       PARAM                                        *LDA
¢(    * End-B2B
     C                   ENDIF
MP    *
MP    * If cancelling program and work orders were created, void them.
MP    * w/o are voided through F11 not deleted.
MP    *
      *
      * CLOSE VENDOR RETURN LINE ITEM RETRIVAL/UPDATE PROGRAM.
   M5C*                  Z-ADD     *ZEROS        CRNO#
M5   C                   MOVE      *BLANKS       CRNO#
     C                   Z-ADD     *ZEROS        LINRF#
     C                   MOVE      'Y'           CLSFLG
     C                   CALL      'POR4356'     PL4356
      *
      * SEND TO WM
     C     *IN03         IFNE      *ON
TJ   c                   if        svshbr = 'Y'
TJ   * If original shipping branch was a wm branch, make sure to delete from cc. If current
TJ   * ship branch is a wm branch, it will get sent back to wm.
TJ   c                   clear                   pdata
TJ   c                   eval      pdata = oeno01
TJ   c                   call      'WXR5950'
TJ   c                   parm      'OED'         wmfrm
TJ   c                   parm                    pdata
TJ   c                   endif
     C     WHMBR         IFEQ      'Y'
     C     OEFL20        ANDEQ     'Y'
     C     OECD01        ANDNE     'D'
     C     OECD04        ANDNE     'N'
     C     OECD08        ANDNE     'Q'
     C     OECD38        ANDNE     'Y'
     C                   CLEAR                   PDATA
TA   C                   if        wmstat = '**'
TA   C                   MOVE      'OE '         WMFRM
TA   C                   else
     C                   MOVE      'OEM'         WMFRM
TA   C                   endif
     C                   MOVEL     OENO01        PDATA
     C                   CALL      'WXR5950'
     C                   PARM                    WMFRM             3
     C                   PARM                    PDATA           256
     C                   ELSE
     C     WHBR          IFEQ      'Y'
     C                   CLEAR                   PDATA
     C                   MOVE      'OED'         WMFRM
     C                   MOVEL     OENO01        PDATA
     C                   CALL      'WXR5950'
     C                   PARM                    WMFRM             3
     C                   PARM                    PDATA           256
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
OA   C                   MOVE      *IN03         SV03              1
OA    * check user have authority to V/R  creation
OA   C                   MOVE      *BLANKS       CDE
OA   C                   MOVE      USRNM         USER
OA   C                   MOVE      'OE'          APP
OA   C                   MOVEL     'RGA'         CDE
OA   C                   MOVE      0003          ID
OA   C                   MOVE      *BLANKS       USRVAL
OA   C                   MOVE      *BLANKS       VALFRM
OA   C                   MOVE      *BLANKS       RTNCOD
OA   C                   CALL      'OPR8220'     PL8220
OA   C     RTNCOD        IFEQ      '0'
OA   C                   MOVEL     USRVAL        VRAUTH            1
OA   C                   ELSE
OA   C                   MOVE      *BLANKS       VRAUTH
OA   C                   ENDIF
      * BLANK/ZERO OUT FIELDS
      *
OA    * IF C/M STATUS CHANGED FROM 'P' TO 'O'
OA   C     DSPCST        IFEQ      'P'
OA   C     OECD04        ANDEQ     'O'
OA   C     OECD08        ANDEQ     'C'
OA   C     SV03          ANDNE     '1'
OA   C     VRAUTH        ANDEQ     'Y'
OA   C     SVRFLG        ANDEQ     'Y'
OA   C                   MOVE      OENO01        CORD#
OA   C                   CALL      'POR4112'
OA   C                   PARM                    CORD#
OA   C                   ENDIF
OA   C                   MOVE      *BLANKS       SVRFLG            1
     C                   EXSR      BLKSR
MS    *
MS   C     NWTRFN        IFEQ      'Y'
MS   C                   CALL      'OER2163'     PL2163
MS   C                   END
      *
     C     OPNOAL        IFEQ      '1'
     C                   CLOSE     OELTOAL4
     C                   MOVE      *ZERO         OPNOAL
     C                   END
     C     QEXIT         TAG
RK    *
RK    * Delete clipboard info
RK    *
RK   C                   If        %subst(wsname:1:3) = 'QQF'
RK   C                   clear                   SHFCLIP
RK   C                   eval      SessioNmMv = 'JOB_' + %editc(jobnbr:'X')
RK   C                   eval      EnttypCdMv  = 'PROGRAM_VARIABLES'
RK   C                   eval      Clipk1CdMv  = 'PRODUCT_PROMPTER'
RK   C     KeyClip1      chain     SHLCLIP1
RK   C                   if        %found(SHLCLIP1)
RK   C                   delete    shfclip
RK   C                   EndIf
RK   C                   EndIf
RK    *
TW    * Delete any temporary rows created for processing order
TW   C                   exsr      delAvaTaxLog
SH    * Delete tax records
SH   C                   Exsr      ClearTaxr
SZ    * If order came from credit hold option do not process event
SZ    * Order being placed on credit hold event
SZ   C                   if        svcd38 <> 'Y'
SZ   C                             and oecd38 = 'Y'
SZ   C                   eval      ordE20 = oeno01
SZ   C                   eval      cusE20 = arno01
SZ   C                   eval      cnmE20 = arnm01
SZ   C                   eval      usrE20 = oenm01
SZ   C                   Call      'SHC5050'
SZ   C                   Parm      'HDE0020'     EventID           7            Event Id
SZ   C                   Parm                    d_HDE0020                      Event Data
SZ   C                   end
SZ
TN    * If order is on credit hold & is being released, process event
TN    * Sales Order released from credit hold
TN   C                   if        svcd38 = 'Y'
TN   C                             and oecd38 <> 'Y'
TN   C                   eval      ordE37 = oeno01
TN   C                   eval      usrE37 = usrnm
TN   C                   eval      sidE37 = oeid02
TN   C                   eval      entE37 = oeid01
TN   C                   Call      'SHC5050'
TN   C                   Parm      'HDE0037'     EventID           7            Event Id
TN   C                   Parm                    d_HDE0037                      Event Data
TN   C                   end
UG    * Trigger event if card processing using software was not normal
UG    * and if the transaction was completed.
UG    * or if it was an RGA that was prevented from completing due to
UG    * error
UG   C                   if        eventtype <> *blanks
UG   C                             and using_card = 'Y'
UG   C                             and (frmwrt = 'Y'
UG   C                             or eventtype = '5')
UG   C                   exsr      srevent
UG   C                   endif                                                  Event Id
TN
T0    * if order from contract
T0    * check for remaining quantities and re-open contract (if necessary)
T0    *
T0   c                   if        ahno1  <> *blanks
T0   c                   eval      xcode = ' '
T0   c                   CALL      'OER6084'     PL6084
T0   c                   end
T0    *
U3    * Call OER2201 to check for lines removed from order
U3   C                   CALL      'OER2201'
U3   C                   PARM                    OENO01
VE    *
VE    * Call OER2190 if Enhanced Lost Sales Tracking in play and Order Maintenance
VE    * control flag set to 'Y'
VE    *
VE    * Retrieve Enhanced Lost Sales Tracking Flag
VE    *
VE    * All order/Review mode only
VE   C                   IF        DSPCST = 'Y' OR DSPCST = 'R'
WB   C                   MOVE      'OE97'        TABCOD
VE VTC*                  MOVE      'OE97'        TABCOD
VE VTC*                  MOVE      *BLANKS       TABENT
VE VTC*                  Eval      TABENT = 'LST' + %editc(ARNO15:'X')
VE VTC*                  MOVE      'N'           EnhLstTrk         1
VE VTC*    TABKEY        CHAIN     TBFMTBL                            40
VE VTC*    *IN40         IFEQ      *OFF
VE VTC*                  Eval      EnhLstTrk = %subst(TBNO03:1:1)
VE VTC*                  ENDIF
VE VT * Is Order Void active for use with Enhanced Lost Sales?
VT    * Is Order Maintenance active for use with Enhanced Lost Sales?
VE   C                   MOVE      *BLANKS       TABENT
VE   C                   Eval      TABENT = 'CONTROL '
VE   C                   MOVE      'N'           EnhLstTrkOM       1
VE   C     TABKEY        CHAIN     TBFMTBL                            40
VE   C     *IN40         IFEQ      *OFF
VE   C                   Eval      EnhLstTrkOM = %subst(TBNO03:4:1)
VE   C                   ENDIF
VE   C                   IF         ENHLSTTRK = 'Y'
VE   C                               AND  ENHLSTTRKOM = 'Y'
VE   C                   If        DSPCST = 'K'
VE   C                   Eval      LSMENU = 'RM'
VE   C                   Else
VE   C                   Eval      LSMENU = 'OM'
VE   C                   Endif
VE   C                   Move      OENO08        LSBRCH
VE   C                   Move      ARNO01        LSCUST
VE   C                   Move      OENO01        LSORDR
VE   C                   Call      'OER2190'     PL2190
VE   C                   ENDIF
VE   C                   ENDIF
VJ    *
VJ    * Clear and Close OEQWPRC if Open
VJ    *
VJ   C                   IF        %OPEN(OEQWPRC01)
VJ    * Clear Contents of OEQWPRC
VJ   C     *Start        Setll     OEQWPRC01
VJ   C                   Dou       %Eof(OEQWPRC01)
VJ   C                   Read      OEQWPRC01
VJ   C                   If        Not %Eof(OEQWPRC01)
VJ   C                   Delete    OEFWPRC
VJ   C                   Endif
VJ   C                   Enddo
VJ   C                   Close     OEQWPRC01
VJ   C                   ENDIF
VJ   C                   If        %Open(OEQAPRC)
VJ   C                   Close     OEQAPRC
VJ   C                   Endif
U3
%L    * If requested to print pick ticket, print it now
%L   C                   IF        PRTCMD <> *blanks
%L   C                   CALL      'QCMDEXC'
%L   C                   PARM                    PRTCMD
%L   C                   PARM                    PRTLEN
%L   C                   CLEAR                   PRTCMD
%L   C                   CLEAR                   PRTLEN
%L   C                   ENDIF
     C                   RETURN
UY
MI    * all source lines exist in OEY2063
MJ    * all source lines exist in OEY2063
MK    * all source lines exist in OEY2063
ML    * all source lines exist in OEY2063
MM    * all source lines exist in OEY2063
MU    * all source lines exist in OEY2063
MJ    * all source lines exist in OEY2063
MW    * all source lines exist in OEY2063
MX    * all source lines exist in OEY2063
MY    * all source lines exist in OEY2063
M1    * all source lines exist in OEY2063
M3    * all source lines exist in OEY2063
M4    * all source lines exist in OEY2063
MJ    * all source lines exist in OEY2063
NC    * all source lines exist in OEY2063
NE    * all source lines exist in OEY2063
ND    * all source lines exist in OEY2063
NG    * all source lines exist in OEY2063
NJ    * all source lines exist in OEY2063
NS    * all source lines exist in OEY2063
NV    * all source lines exist in OEY2063
NW    * all source lines exist in OEY2063
NZ    * all source lines exist in OEY2063
N0    * all source lines exist in OEY2063
N2    * all source lines exist in OEY2063
OO    * all source lines exist in OEY2063
OY    * all source lines exist in OEY2063
PA    * all source lines exist in OEY2063
PC    * all source lines exist in OEY2063
PD    * all source lines exist in OEY2063
PG    * all source lines exist in OEY2063
PJ    * all source lines exist in OEY2063
PK    * all source lines exist in OEY2063
PL    * all source lines exist in OEY2063
PN    * all source lines exist in OEY2063
PO    * all source lines exist in OEY2063
PQ    * all source lines exist in OEY2063
PR    * all source lines exist in OEY2063
PS    * all source lines exist in OEY2063
PU    * all source lines exist in OEY2063
PV    * all source lines exist in OEY2063
PW    * all source lines exist in OEY2063
PX    * all source lines exist in OEY2063
PY    * all source lines exist in OEY2063
PZ    * all source lines exist in OEY2063
P0    * all source lines exist in OEY2063
P2    * all source lines exist in OEY2063
P4    * all source lines exist in OEY2063
QA    * all source lines exist in OEY2063
QB    * all source lines exist in OEY2063
QC    * all source lines exist in OEY2063
QD    * all source lines exist in OEY2063
QE    * all source lines exist in OEY2063
QF    * all source lines exist in OEY2063
QG    * all source lines exist in OEY2063
QH    * all source lines exist in OEY2063
QI    * all source lines exist in OEY2063
QK    * all source lines exist in OEY2063
QL    * all source lines exist in OEY2063
QM    * all source lines exist in OEY2063
QO    * all source lines exist in OEY2063
QS    * all source lines exist in OEY2063
QU    * all source lines exist in OEY2063
QY    * all source lines exist in OEY2063
Q2    * all source lines exist in OEY2063
Q3    * all source lines exist in OEY2063
Q4    * all source lines exist in OEY2063
Q5    * all source lines exist in OEY2063
RG    * all source lines exist in OEY2063
RJ    * all source lines exist in OEY2063
RU    * all source lines exist in OEY2063
RV    * all source lines exist in OEY2063
RW    * all source lines exist in OEY2063
RY    * all source lines exist in OEY2063
R0    * all source lines exist in OEY2063
R3    * all source lines exist in OEY2063
R4    * all source lines exist in OEY2063
SB    * all source lines exist in OEY2063
SD    * all source lines exist in OEY2063
SF    * all source lines exist in OEY2063
SJ    * all source lines exist in OEY2063
SO    * all source lines exist in OEY2063
SR    * all source lines exist in OEY2063
ST    * all source lines exist in OEY2063
SX    * all source lines exist in OEY2063
S5    * all source lines exist in OEY2063
TG    * all source lines exist in OEY2063
TH    * all source lines exist in OEY2063
TL    * all source lines exist in OEY2063
TM    * all source lines exist in OEY2063
TT    * all source lines exist in OEY2063
TU    * all source lines exist in OEY2063
TV    * all source lines exist in OEY2063
TX    * all source lines exist in OEY2063
TY    * all source lines exist in OEY2063
T2    * all source lines exist in OEY2063
T5    * all source lines exist in OEY2063
UB    * all source lines exist in OEY2063
UD    * all source lines exist in OEY2063
UE    * all source lines exist in OEY2063
UX    * all source lines exist in OEY2063
UY
UY    /COPY QCPYSRC,OEY2063
UY    *                                                                
UY    *             All custom subroutines and new package             
UY    *             subroutines should be added below these comments   
UY    *                                                                
#H    *--------------------------------------------------------------------------
#H    * DETERMINE IF GMC SERIAL NUMBER TAGS ARE REQUIRED
#H    *--------------------------------------------------------------------------
#H   C     GETNEEDTAGS   BEGSR
#H    *
#H   C                   MOVE      'N'           NEEDGMCTAG        1
#H   C                   Z-ADD     1             RRNGT             3 0
#H   C                   MOVE      *IN49         SAVEIN49          1
#H    *
#H   C     RRNGT         CHAIN     OES2063E                           49
#H   C     *IN49         DOWEQ     *OFF
#H   C                   IF        IVNO7 <> 0 AND
#H   C                             OEQY03 > 0
#H   C     IVNO7         CHAIN     IVFOUR
#H   C                   IF        %FOUND
#H   C                   IF        IVCD57 = 'Y'
#L   C                   MOVEL     'CM12'        TABCOD
#L   C                   CLEAR                   TABENT
#L   C                   MOVEL     IVCD17        TABENT
#L   C     TABKEY        CHAIN     TBFMTBL
#L   C                   IF        %FOUND
#H   C                   IF        OECD08 = 'O' OR
#H   C                             OECD08 = 'C' AND
#H   C                             AFTINV = 'Y' OR
#H   C                             OECD08 = 'D' AND
#H   C                             AFTINV = 'Y'
#H   C                   MOVE      'Y'           NEEDGMCTAG
#H   C                   ENDIF
#H   C                   ENDIF
#H   C                   ENDIF
#H   C                   ENDIF
#H   C                   ENDIF
#H   C                   ADD       1             RRNGT
#H   C     RRNGT         CHAIN     OES2063E                           49
#H   C                   ENDDO
#H    *
#H   C                   MOVE      SAVEIN49      *IN49
#H    *
#H   C                   ENDSR
      /EJECT
      *----------------------------------------------------------------
     OARFTWI    E            DMYTWI
     OOEFTOA    E            DMYTOA
     OOEFTOC    E            DMYTOC
     OOEFTOAL   E            UPTOAL
     O                       OAQY11
     O                       OAQY13
     O                       OAMO02
     O                       OADY02
     O                       OACC02
     O                       OAYR02
     O                       OANM01
     O                       OAAM46
     O                       OAAM47
     OOEFTOAL   E            UNLCK1
     OOEFTOAH   E            UPTOAH
     O                       AHMO16
     O                       AHDY16
     O                       AHCC16
     O                       AHYR16
     O                       AHMO17
     O                       AHDY17
     O                       AHCC17
     O                       AHYR17
     OOEFTOAH   E            UNLCK2
     OIVFMSBR   E            OAMSBR
     O                       IVMO01
     O                       IVDY01
     O                       IVCC01
     O                       IVYR01
     O                       IVNM01
     O                       IVQYY9
MO   OIVFMNSB   E            UPDNSB
MO   O                       NBMO01
MO   O                       NBDY01
MO   O                       NBCC01
MO   O                       NBYR01
MO   O                       NBNM01
MO   O                       NBQY23
     OOEFTDP    E            UNLKDP
     OOEFTDP    E            DEPSIT
     O                       DPAM21
     O                       DPCD50
     O                       DPNM01
     O                       DPMO02
     O                       DPDY02
     O                       DPCC02
     O                       DPYR02
     O                       DPTM04
     OOEFTOH    E            RELTOH
     OOEFTOAD   E            TOAD
     O                       LDQY20
     O                       LDQY21
     O                       OEMO02
     O                       OEDY02
     O                       OECC02
     O                       OEYR02
     O                       OENM01
RZ   OARFTCCT   E            UPDTCCT
RZ   O                       cc_ARAMC7
RZ   O                       cc_ARcdF6
RZ   O                       cc_ARcdG4
      *
      *------------------- TABLE FILE CHANGE AREA -----------------------------*
MP    * Changed EMS(16)
MP    *  BEFORE
MP    * Cannot generate W/O unless backorders are retained.
MP    *  AFTER
MP    * Work orders will be deleted if backorders are not retained.
MP    *   ADDED TABLE AMS AS FOLLOWS:
MP    * ** AMS
MP    * Branch is not a fab branch. Work order creation not allowed.
MP    * Work order not allowed unless b/o qty > 0 and b/o status is open.
MP    * Item selected is not a fab item.
MP    * Unable to lock work order.  Make sure work order is not in use.
MP    * Work order not found.
MP    * Work order request not found.
MP    * Work order xxxxxxx already released.  W/O quantity must be updated manually.
MP    *
MQ    * ADDED UMS,83
MQ    *Warning! G/P % not within acceptable range.
MZ    * CHANGED UMS,35
MZ    * BEFORE:Quantity limited to 99 for items that require serial numbers.
MZ    * AFTER: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.
M2    * Added entry 84 to UMS.
M0    * Changed UMS(85)
M0    * No tax jurisdiction assigned to zip code.
NN    * Added entry 89 to UMS.
NN    * Warning! Order has been shipped by WMS.
NU    * Added UMS(86).
NU    *Must be Non-Taxable to follow header.
N5    * Added UMS(87).
N5    *Withdrawal amount cannot exceed remaining balance.
N4    * Added EMS(56) and EMS(57).
OA    * Added EMS messages 58 -72
OA    *  Unit item price exceeds the original item price on order.
OA    *  Freight price exceeds the original freight price on order.
OA    *  Invalid freight type.
OA    *  Return quantity exceeds the original shipped quantity.
OA    *  Cannot change product number.
OA    *  Quantities must be negative on a credit memo.
OA    *  Enter a valid value for re-stocking.
OA    *  Not authorized to change credit memo status from open.
OA    *  Not authorized to change order status.
OA    *  F16=Add Lines available only for C/M created from RGA with Reference.
OA    *  F16=Add lines not available as order is already sent to WM.
OA    *  Amount exceed the original handling amount by
OA    *  Amount exceed the original delivery amount by
OA    *  Amount exceed the original other chg amount by
OA    *  Component maintenance not allowed for item released from RGA.
OG    * Added entry 81 to EMS:
OG    *  Not authorized to sell branch.
OG    * Changed UMS,5
OG    * BEFORE:Not authorized to branch/company.
OG    * AFTER: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
OF    * Added entry 73 and 74 to EMS.
OE    * Added entry 75 to EMS.
OH    * Added EMS messages 76 -80
OH    * Sub Total amount exceeds the allowed value. Review the price/quantity.        76
OH    * Total amount exceeds the allowed value. Review the price/quantity.            77
OH    * Tax amount exceeds the allowed value. Review the price/quantity.              78
OH    * HST amount exceeds the allowed value. Review the price/quantity.              79
OH    * GST amount exceeds the allowed value. Review the price/quantity.              80
OI    * Changed the message EMS(60) as follows:                               60
OI    * Before:                                                               60
OI    * Invalid freight type.                                                 60
OI    * After:                                                                60
OI    * Invalid bill/credit code.                                             60
OI    * Added the message EMS(82) and (83) as follows:                        60
OI    * Bill/Credit amount is required.
OI    * Bill/Credit amount should be zero.
OI    * Changed the message EMS(65) as follows:                               60
OI    * Before:
OI    * Not authorized to change credit memo status from open.                65
OI    * After:
OI    * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
OI    * Changed the message EMS(66) as follows:                               60
OI    * Before:
OI    * Not authorized to change order status.                                65
OI    * After:
OI    * Not authorized to change order type.                                  65
OK    * Added entry 88 to UMS:
OK    *  Warning! Ship branch changed; This order is tagged to a transfer or P/O.
OP    * Changed EMS,81
OP    *  BEFORE: Not authorized to sell branch.
OP    *  AFTER: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
OP    * ADDED EMS,84
OP    *  Not authorized to sell/ship branch.
OS    * ADDED EMS,85
OS    * Not authorized to print invoice for credit memo.
OZ    * Added EMS 86
OZ    * For price credit, quantity must be same as qty available for return =>            1
RD    * Added EMS 87
RD    * Item being sold is DNR, and will no longer be carried.                            1
QP    * Added UMS 90 - 93
QP    * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
QP    * Ship method/code combination not valid.
QP    * Ship method/code not valid for branch.
QP    * Ship method/code not valid for transaction.
SN    * Changed UMS 90                                                        15
SN    * Before:
SN    * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
SN    * After:
SN    * Order is ship confirmed in WMS. Order type cannot be changed.
T4    * NEW JOBQ QFORMS
U2    * Added EMS(88)
U2    * Overhead items are not allowed.
VG    * Correct Spelling of Jurisdiction in EMS(54)
VU    * Added AR6
VU    * Card Processing Fee
¢A    * Delivery Charge has been changed to Fuel Surcharge
¢E    * ADDED TABLE CSG
$N    * CHANGED CSG,11
$N    *  BEFORE:
$N    *  RA# first 7 pos must contain numbers & remainder field must be blank.
$N    *  AFTER:
$N    *  RA# first 7 or 8 pos must contain numbers & remainder field must be bla
$1    * ADDED CSG,21 - CSG,22
$2    * Added entry to CSG #23
$2    *  Slash items are not allowed.
$4    * CHANGED CSG,12
$4    *  BEFORE:
$4    *  Freight amount defaulted to $75 for ship type 'S'
$4    *  AFTER:
$4    *  Freight amount defaulted to $25 for ship type 'S'
%A    * Added entry to CSG #24
%A    *  Web order cash deposit available.  Use cash deposit for payment.
%D    * Added entry to CSG #25
%D    *  RA# must start with A/D/G followed by 8 numbers
%F    * Changed entry CSG #3 to remove reference for fuel Surcharge
%F    *  Delivery Charge disallowed for this customer
%F    * Changed entry CSG #13 to remove reference for fuel Surcharge
%F    *  Ship type Our Truck required if delivery charge not equal 0
%F    * Changed entry AR2 from Fuel Surcharge
%F    *  Delivery Charge
%P    * ADD ENTRY 26 TO TABLE CSG
%P    *   Credit card transactions do not match credit card amount.
%W    * ADD ENTRY 27-31 TO TABLE CSG
:Y    * ADD ENTRY 33-35 TO TABLE CSG
:Z    * ADD ENTRY 37 TO TABLE CSG
#1    * ADD ENTRY 38 TO TABLE CSG
#6    * ADD ENTRY 39 TO TABLE CSG
#7    * ADD ENTRY 40 TO TABLE CSG
#9    * ADD ENTRY 41 TO TABLE CSG
#A    * ADD ENTRY 42 TO TABLE CSG
#L    * ADD ENTRIES 43-44 TO TABLE CSG
#O    * ADD ENTRY 45 TO TABLE CSG
#V    * ADD ENTRY 46 TO TABLE CSG
#Y    * ADD ENTRY 47 TO TABLE CSG
&B    * ADD ENTRY 48 TO TABLE CSG
&C    * ADD ENTRY 49 TO TABLE CSG
&D    * ADD ENTRY 50 TO TABLE CSG
&I    * ADD ENTRY 51 TO TABLE CSG
&N    * ADD ENTRY 52 TO TABLE CSG
&S    * ADD ENTRY 53 TO TABLE CSG
&V    * ADD ENTRY 54 TO TABLE CSG
      *------------------------------------------------------------------------*
**
0
1
2
3
4
5
6
7
8
9
**
Freight Charge
**
Delivery Charge
**
Handling Charge
**
Restocking Charge
**
SNDMSG MSG('XXXXXXXXXXXXXXXXX') TOMSGQ(OEMORDS)
**     (FX) - SUBMIT JOB TABLE FOR SENDING FAX
SBMJOB CMD(CALL PGM(OPC0500) PARM('XXXX' 'XXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXX' 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXX' 'XXXXXX' 'XXXXXX' ' ')) JOB(FM
_SOACK) JOBD(*LIBL/HDJPACK) JOBPTY(4) MSGQ(*NONE)
 JOBQ(QFORMS)
** MSG              (CREDIT MESSAGES)
*** Account On Hold xx/xx/xx ***                                               1
*** Cash Account ***                                                           2
*** Walk-In Customer ***                                                       3
*** Cust Over Limit By $                                                       4
*** Job Over Limit By $                                                        5
Additional deposits exist.                                                     6
Remaining amount to collect $                                                  7
You have collected $                                                           8
Withdrawal for order#                                                          9
*** Cust Over Credit Limit ***                                                 10
*** Job Over Credit Limit ***                                                  11
*** Cash Account On Hold  xx/xx/xx ***                                         12
*** Ent Over Limit By $                                                        13
**
IN LIEU OF
**
XXX Per XXX)
** ARS
SNDMSG MSG('S/O  #XXXXXXX has been shipped.') TOMSGQ(XXXXXXXXXX)
**  MS2
SNDBRKMSG MSG('Unable to send message to 9999999999.  Please correct device tabl
e BMSG. ') TOMSGQ(          )
** AR5
0
1
2
3
4
5
6
7
8
9
** AR6
Card Processing Fee
** UMS
Invalid operators initials.                                                    1
Account closed, may not enter order.                                           2
Account not found in company/branch.                                           3
Enter/correct branch number.                                                   4
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                         5
Print invoice must be 'Y' or 'N' or 'C'.                                       6
Enter 'Y/N' in Print Invoice (Y/N).                                            7
Enter correct order date.                                                      8
Warning! Date ordered is not current date.                                     9
Warning! Date shipped is not current date.                                    10
Correct shipping date.                                                        11
Correct promised ship date.                                                   12
Enter method of shipment.                                                     13
Only one method of shipment may be entered.                                   14
Method of shipment requires ship via description.                             15
Enter a valid code D-Dir, S-Spcl, I-Inv.                                      16
All quantity defaulted to shipped for direct cash sale or direct invoice      17
Cannot change method of shipment, some line items have tags.                  18
Enter the P/O number for this order.                                          19
Enter the job name for this order.                                            20
Job number is required for this customer.                                     21
Job number is invalid.                                                        22
Job has lien or is completed or pending.                                      23
No records found for description search criteria.                             24
Ship to address line 1 must be entered.                                       25
Order not updated if F3 is pressed again.                                     26
Warning! Review the tax jurisdiction code.                                    27
Cursor not in valid location for F4=Prompt.                                   28
Temporary item must be verified.                                              29
Warning!  Item does not exist in the counter book.                            30
Non-stock item already exists in O/E.                                         31
Non-stock item not found in purchasing.                                       32
Item is not stocked at this branch.                                           33
Value must not be less than 0.                                                34
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.                 35
Insufficient stock for this item.                                             36
Item number not found in item master.                                         37
Before continuing, line items must be entered.                                38
Warning!  There are items with zero quantity shipped.                         39
Warning!  All items have zero quantity shipped.                               40
Line item comments must follow a line item.                                   41
Enter quantity ordered.                                                       42
Description must be entered for a non-stock item.                             43
Section not found in purchasing book.                                         44
Unit of measure has not been setup for this product or access code is not 'Y'.45
Warning!  No cost found on a purchase order.                                  46
Warning!  Item is not on a purchase order.                                    47
Warning!  Quantity is not a multiple of reference UOM.                        48
Item selected does not have components.                                       49
Restricted item.  "Ord By" must be entered.                                   50
Restricted item.  "Ord By" is not authorized to purchase.                     51
Restricted item.  "Ord By" has expired license and cannot purchase.           52
Line selected is not valid for stock status inquiry.                          53
Maximum number of lines exceeded!  Review order, some lines were dropped.     54
Verify line items, press enter to continue.                                   55
Non-stock is on a direct P/O.  You cannot put it on a non-direct sales order. 56
Non-stock is on a non-direct P/O.  You cannot put it on a direct sales order. 57
Freight type must be entered for direct ship orders.                          58
GST Tax Amt                                                                   59
HST Tax Amt                                                                   60
GST %                                                                         61
HST %                                                                         62
Invalid tax information. Tax must be 'Y' (Yes) or 'N' (No).                   63
Warning, no other charge amounts have been entered.                           64
Non-stock item not found on purchase order for this customer.                 65
*** Job Within Credit Limit ***                                               66
Date promised cannot be greater nor less than two years from current year.    67
Component maintenance not allowed for item released from contract.            68
*** Enterprise Over Credit Limit ***                                          69
Warning! Job chgd. Review tax Y/N, tax jur, ship mth/cde, terms.              70
Warning!  Sell branch not valid for company. Press enter to re-default Co#.   71
Print invoice must be 'Y' for direct cash sale.                               72
Maximum number of lines exceeded. Combo cannot be entered.                    73
Invalid terms discount entered.                                               74
Correct feet and inches price quantity field.                                 75
Enter the unit price.                                                         76
Negative gross profit percent.                                                77
Invalid discount entered.                                                     78
Not authorized to re-print this pick ticket.                                  79
Warning! Job chgd. Review prices by F10=Pricing and F6=Reprice.               80
Warning! This item may have been shipped on a subsequent order. See B/O Gen's.81
Cash, check, or credit card amount not allowed during C.O.D entry.            82
Warning! G/P % not within acceptable range.                                   83
Ship date must be less than or equal to today's date.                         84
No tax jurisdiction assigned to zip code.                                     85
Must be Non-Taxable to follow header.                                         86
Withdrawal amount cannot exceed remaining balance.                            87
Warning! Ship branch changed; This order is tagged to a transfer or P/O.      88
Warning! Order has been shipped by WMS.                                       89
Order is ship confirmed in WMS. Order type cannot be changed.                 90
Ship method/code combination not valid.                                       91
Ship method/code not valid for branch.                                        92
Ship method/code not valid for transaction.                                   93
** CRM
SNDMSG MSG('Held S/O XXXXXXX for Customer XXXX
XXXXXXXXXXXXXXXXXXXXXXXXXX') TOUSR(XXXXXXXXXX)
** INV
SNDMSG MSG('Credit hold message for user XXXXXXXXXX was not
sent! This ID is not valid! See table OE90.') TOUSR(QSYSOPR)
** EMS
Item selected is not a lot item.                                              1
Cannot order or ship more than 1 lot item.                                    2
Return authorization number required for this item.                           3
Invalid age code.                                                             4
Enter the invoice reference number.                                           5
Verify line items, press enter to continue.                                   6
Order not updated if F3 is pressed again.                                     7
Correct generate back orders (Y/N).                                           8
Order must be reserved if "Ship Complete" = 'Y'.                              9
This order is not eligible to be made pending.                                10
Enter fax number.                                                             11
Cannot generate P/O unless backorders are retained.                           12
Cannot generate P/O if status is pending or reserve.                          13
Generate transfers cannot be yes if retain backorders is no.                  14
Generate transfers cannot be yes if order status is pending.                  15
Work orders will be deleted if backorders are not retained.                   16
Enter the cash, check, or credit card amount.                                 17
Enter the check number                                                        18
Cash, check, and credit card amount must equal the invoice amount.            19
Cannot generate W/O for pending sales order.                                  20
Amounts do not add to invoice total.                                          21
Verify totals, press enter to continue.                                       22
You must void credit cards taken before changing from invoice to ticket.      23
You must void credit cards taken before you can change the selling branch.    24
You must void credit cards taken before changing sales order to charge.       25
Cannot use a pricing UOM as an order UOM.                                     26
Item selected is not a lot controlled item.                                   27
Item contains hazardous materials that cannot be shipped on specified carrier.28
Invalid Roadnet status code.                                                  29
Email is not currently set up.  Cannot specify 'E'.                           30
Quotation orders cannot be changed from pending status.                       31
Open orders not set up for this type of print.                                32
Credit/Debit memo may not be reserved.                                        33
Pending orders not set up for this type of print.                             34
Reserved orders not set up for this type of print.                            35
Branch must be entered.                                                       36
This is not a valid branch.                                                   37
This order will be placed on credit hold!                                     38
Verify line items, press F10 again for pricing.                               39
For collect orders, freight billing account number is required.               40
Invalid ship method and ship code combination.                                41
Not authorized to maintain the order.                                         42
Period definition not found for this date.  Date not allowed.                 43
Changing shipment to direct not allowed for reviewed/priced/changed orders.   44
Method of shipment change to direct will cause all items to be backordered!   45
Not authorized to change method of shipment to direct.                        46
Changing order from cash to charge will cause all items to be backordered!    47
Changing print invoice from 'Y' to 'N' will cause all items to be backordered!48
Item was not a lot controlled item at time of shipment.                       49
Maintenance not allowed. Component changed to lot controlled after shipment.  50
Warning! tax jurisdiction is not attached to zip code.                        51
Tax jurisdiction not valid with overridden zip code.                          52
Warning! Tax jurisdiction code has been re-defaulted.                         53
Correct tax jurisdiction code.                                                54
Warning! Other charge tax flags have been re-defaulted.                       55
                                                                              56
Extended amount exceeds the allowed value. Review the price/quantity.         57
Unit item price exceeds the original item price on order.                     58
Freight price exceeds the original freight price on order.                    59
Invalid bill/credit code.                                                     60
Return quantity exceeds the original shipped quantity.                        61
Cannot change product number.                                                 62
Quantities must be negative on a credit memo.                                 63
Enter a valid value for re-stocking.                                          64
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.                        65
Not authorized to change order type.                                          66
F16=Add Lines available only for C/M created from RGA with Reference.         67
F16=Add lines not available as order is already sent to WM.                   68
Amount exceed the original handling amount by                                 69
Amount exceed the original delivery amount by                                 70
Amount exceed the original other chg amount by                                71
Component maintenance not allowed for item released from RGA.                 72
                                                                              73
B/O quantities not allowed with non-inventory items.                          74
Cannot access customer contacts because you are already in that same program. 75
Sub Total amount exceeds the allowed value. Review the price/quantity.        76
Total amount exceeds the allowed value. Review the price/quantity.            77
Tax amount exceeds the allowed value. Review the price/quantity.              78
HST amount exceeds the allowed value. Review the price/quantity.              79
GST amount exceeds the allowed value. Review the price/quantity.              80
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX              81
Bill/Credit amount is required.                                               82
Bill/Credit amount should be zero.                                            83
Not authorized to sell/ship branch.                                           84
Not authorized to print invoice for credit memo.                              85
For price credit, quantity must be same as qty available for return ->        86
Item being sold is DNR, and will no longer be carried.                        87
Overhead items are not allowed.
** AMS
Branch is not a fab branch. Work order creation not allowed.                  1
Work order not allowed unless b/o qty > 0 and b/o status is open.             2
Item selected is not a fab item.                                              3
Unable to lock work order.  Make sure work order is not in use.               4
Work order not found.                                                         5
Work order request not found.                                                 6
Work order xxxxxxx already released.  W/O quantity must be updated manually.  7
** VOD
SBMJOB CMD(CALL PGM(OER8205) PARM('XXXXXXX' 'X'))
 JOB(BOFILL) JOBD(*LIBL/HDJPACK)
** DOA Submit job for Direct Order Audit
SBMJOB JOB(DIRAUDIT) JOBD(HDJPACK) RQSDTA('CALL PGM(POR0010) PARM(''S'
' ''XXXXXXX'')') JOBPTY(4) LOG(0) MSGQ(*NONE)
** CSG
BO disallowed for DNR (do not reorder) item.                                  1
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX              2
Delivery charge disallowed for this customer                                  3
Not allow to change cash order to print invoice "N".                          4
Valid State code required                                                     5
Our truck shipments disallowed for ship to state                              6
Invalid zip code                                                              7
Shipments to this state should not be taxable                                 8
Invalid shipping address                                                      9
Price is below minimum price limit                                            10
RA# first 7 or 8 pos must contain numbers & remainder field must be blank.    11
Freight amount defaulted to $25 for ship type 'S'                             12
Ship type Our Truck required if delivery charge not equal 0                   13
Warranty fee must be charged for this customer.                               14
Customer should not be charged Warranty Fee.                                  15
Order total < 0 requires order type of Credit.                                16
Credit Order type invalid if order total > O.                                 17
Freight is disallowed for this customer.                                      18
                                                                              19
Cannot print ticket for COD or invoice.                                       20
Positive quantity not allowed with this reason code.                          21
Freight charge required.                                                      22
Slash items are not allowed.                                                  23
Web order cash deposit available.  Use cash deposit for payment.              24
RA# must start with A/D/G followed by 8 numbers                               25
Credit card transactions do not match credit card amount.                     26
Must Select F22 to Create a Warranty Claim.                                   27
For every 'W'arranty item you must enter a 'R'eplacement item.                28
'W'arranty item must have qty -1; 'R'eplacement item must have qty 1          29
Return authorization number has been used, please re-enter.                   30
Please use RGA for Price Corrections.                                         31
Invalid Reason Code.                                                          32
Invalid salesman ID.                                                          33
Please use RGA for Price Corrections.                                         34
Please use RGA for Credit Return.                                             35
Please use RGA for an Incorrect Shipment.                                     36
Zero price not allowed, use no charge flag instead.                           37
Return authorization number cannot exceed a length of 10.                     38
Pricing is not allowed on RGA Credit Memo.                                    39
Invalid City                                                                  40
Promo period is not valid.                                                    41
Deposit disallowed. Funds automatically issued back to original credit card.  42
Promised date is required for our truck orders.                               43
Ship code is required.                                                        44
Sell branch must be original selling branch                                   45
Express Pickup and At Counter Orders cannot be placed on Reserve.             46
Order is being picked.  No order update allowed.  Press F3 to exit order.     47
Unit Exchange Claims must be placed through RGA.                              48
Promised ship date must be greater than date ordered.                         49
Warranty claim attached, cannot change from debit/credit memo.                50
Please use RGA for a return affecting inventory.                              51
Selling branch cannot be a hub.                                               52
Order must be a CM or DM if negative quantity line exists.                    53
Backorders cannot exist with a promo code.                                    54
A promo code must not reduce the ticket price below $0.                       55
