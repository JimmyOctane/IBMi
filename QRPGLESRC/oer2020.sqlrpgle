     H dftactgrp( *no ) bnddir( 'QC2LE') OPTION(*NODEBUGIO)
       ctl-opt bnddir('SHBIND':'WMBIND':'HDBIND':'WKBIND':'MNBIND':'YAJL'
         :'ECBIND');
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - OER2020                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D ORDER ENTRY                                                           *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    ALLOWS THE USER TO ENTER A SALES ORDER.                            *
     F*S    Program will assign the order number, if not entered by            *
     F*S    the user.  Stock levels will be checked (table driven).            *
     F*S    Any type of order can be entered.  Program handles option          *
     F*S    to print pick tickets, cash sale invoices, quotations,             *
     F*S    and will call other programs.                                      *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S IMPORTANT: IF YOU MAKE CHANGES TO SFLDS IN THIS PROGRAM YOU         *
     F*S MUST ALSO MAKE CHANGES TO THE SFLDS IN PROGRAM OER2021 !            *
TJ   F*S            IF YOU MAKE CHANGES TO SAVDS IN THIS PROGRAM YOU         *
TJ   F*S            MUST ALSO MAKE CHANGES TO THE SAVDS IN                   *
TJ   F*S            PROGRAM OER2030 !                                        *
X1   F*S                                                                     *
X1   F*S IMPORTANT: Some subroutines are extracted from OER2020 source       *
X1   F*S            and added to the copy book member OEY2020                *
X1   F*S            using the task                                           *
X1   F*S            8000012637 EXTRACT OER2020 CODES INTO COPYBOOK.          *
X1   F*S            This is done as the total source lines of OER2020        *
X1   F*S            were reaching SEU limit of 32,764.                       *
YR   F*S                                                                     *
YR   F*S NOTE:      ALL subroutines have been extracted from OER2020         *
YR   F*S            and added to the copy book members OEY2020/OEY2021       *
YR   F*S                                                                     *
YR   F*S            ALL change spec ID's associated with code moved to       *
YR   F*S            OEY2020/2021 and no longer exists in this member         *
YR   F*S            have been changed to id "YR" from their original         *
YR   F*S            ID and have also been moved to the top of the            *
YR   F*S            change spec box area to separate them from code          *
YR   F*S            changes that still exist in this source member.          *
YR   F*S                                                                     *
YR   F*S            OER2020 should primarily remain a "mainline" only        *
YR   F*S            member with no subroutines.                              *
:5   F*S                                                                     *
:5   F*S        *** IMPORTANT ***                                            *
:5   F*S            In order to track modifications from OER2020 to          *
:5   F*S            OEY2020 and/or OEY2021, please do the following:         *
:5   F*S                                                                     *
:5   F*S            For new modifications, get next change spec ID           *
:5   F*S            from OER2020 & enter it there. Use it for coding         *
:5   F*S            in OER2020, OEY2020 and/or OEY2021.                      *
:5   F*S                                                                     *
:5   F*S            ONLY enter in the new change spec ID for the             *
:5   F*S            QCPYSRC that coding is being done in.                    *
:5   F*S                                                                     *
:5   F*S            ALL new custom subroutines are to be added to the        *
:5   F*S            end of OEY2020.                                          *
X1   F*S                                                                     *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
YR   F*U 0520000218 120705 168 CONTRACT CUSTOMER NUMBER CHANGING               *
YR   F*U 1110000424 010406 144 SHIP VIA DESC REQUIRED MSG                      *
YR   F*U 1110000425 010406 144 DIRECT SHIP CODE DESC NOT LOADED                *
YR   F*U 1110000420 011106 144 BO GEN PRINT AT COUNTER FOR OUR TRK             *
YR   F*U 1220000993 011206 144 CONTRACT RELEASE NO PRODUCT FOUND               *
YR   F*U 8000009863 022406 062 COST/PRICE CORRECTIONS - REL 11.0               *
YR   F*U 1090000309 030406 094 HIGHLIGHTED ITEMS NOT RELEASED                  *
YR   F*U 1090000315 030606 097 DO NOT DEFAULT JOB TAX JURIS W/O GOOD JOB       *
YR   F*U 1090000335 031706 062 ENTERED BY INITIALS CORRUPTED IN OE             *
YR   F*U 1550000223 050906 094 F15 BYPASS EDIT                                 *
YR   F*U 1090000293 051906 248 PRINT/FAX/EMAIL NET PRICES                      *
YR   F*U 1210000129 052406 127 TERMS CODE AUTH IN ORDER ENTRY                  *
YR   F*U 0970000236 062106 127 REL ITEM RESERVED TO O/E B/O'S ITEM             *
YR   F*U 0420000855 070706 127 ORDER TOTAL GP% WRONG                           *
YR   F*U 1350000379 092206 127 ITEM NOTES TOO LATE IN ORDER ENT                *
YR   F*U 0430000249 102406 127 TAX JURIS NOT CHG WHEN SELL/SHIP CH             *
YR   F*U 0970000247 120106 907 NO DEPOSIT RECPT ON COD RESERVE ORDER           *
YR   F*U 8000010073 012207 070 A/R TRANSACTION NUMBER ASSIGNMENT               *
YR   F*U 1430000289 020207 127 PRINT TICKET FLAG NOT UPDATED                   *
YR   F*U 0970000257 022807 127 QTY'S ON CREDIT MEMO FOR PRICE CHNG             *
YR   F*E 8000010125 041307 913 SERIAL NUMBER TRACKING                          *
YR   F*U 1550000245 050407 915 SHIP & B/O FIELDS ZERO ON SALES ORDER           *
YR   F*U 0970000273 051707 127 PO TAG PREVENTS ITEM GOING TO TRNSF             *
YR   F*U 0970000268 060107 915 PRNT NET PRICE FLG & PRICE FACTOR               *
YR   F*U 0420000889 061107 914 WRONG SHIP TO ADDRESS ON ORDER                  *
YR   F*U 0970000283 082007 914 WRONG AMT IN UNINV ON CONTRACT DETL             *
YR   F*U 8000010283 121707 915 SPLIT ORDER TOTAL CHG AFT MOS CHG               *
YR   F*U 1110000484 122607 914 GENERATED PO FIELD PROTECTED                    *
YR   F*U 1380000191 020608 915 DUPLICATE TAX INFORMATION DISPLAYED             *
YR   F*U 0420000938 020708 914 CROSS COMPANY ORDER NOT GOING TO WM             *
YR   F*U 8000010374 041608 020 PREVENT LM CALLS IF NOT INSTALLED               *
YR   F*E 8000010195 050107 907 SERIAL NUMBER CORRECTIONS-USER GROUP            *
YR   F*U 1430000300 091808 913 INV CUST VS CREDIT CARD CUSTOMER                *
YR   F*U 1430000334 111108 920 ADD PRINT FLAG TO SPLIT SO SCREEN               *
YR   F*U 1670000157 113008 913 TAX JURISDICTION WRONG FOR PICK UP              *
YR   F*U 1430000407 101508 907 INTELLCHIEF CHANGES                             *
YR   F*U 0100005095 020309 127 PI CONTROL NUMBER LOST W/ ITEM NUMB             *
YR   F*U 0100005156 060209 097 Do not require P/T print if W/M branch          *
YR   F*U 8000010801 121009 200 Change date fields to be 6-digit fields         *
YR   F*U 0430000280 122909 001 Correct taxable flag for non inv items          *
YR   F*U 0100005341 051310 007 ORDER NOT SENT TO WM                            *
YR   F*U 0420001260 011013 097 reserves printing when OE30 = 'N'               *
YR   F*U 0100005522 040611 248 I/I ERROR ON FILE IVLMSBR2                      *
YR   F*U 0100005576 082511 020 Orders missing ship codes from rel ords         *
YR   F*U 0970000379 102011 001 Price protected when usr authorized to change   *
YR   F*U 1380000225 110711 001 Correct non tax item, calculating tax           *
YR   F*U 1380000236 112911 915 SHOW NEG QTY ON SERIAL # ENTRY                  *
YR   F*U 1090000482 112911 097 OER2020 error calling WIC0116                   *
YR   F*U 0970000302 120511 915 DEPOSIT RECEIPT PRINT LOCATIONS                 *
YR   F*U 1670000177 122111 915 CONTRACT REL/SUBSTITUTE PRICING                 *
YR   F*U 8000010138 040112 915 STANDARD PACKAGES ON DIRECT S/O                 *
YR   F*U 8000009972 050112 915 VALIDATE SALES TYPE IN ORDER ENTRY              *
YR   F*U 8000010286 060112 915 CONTRACT REL. DOESN'T CREATE SPLIT              *
YR   F*U 0420001157 041312 078 B/O status code for work orders                 *
YR   F*U 0970000450 071612 144 ERROR MSG INSERTING LINES ORD ENTRY             *
YR   F*U 0970000465 120912 928 Tax Code Not Changed When Brn Chg'd             *
YR   F*U 1760000109 091312 915 CONTRACT RLS TO SO LINE TAX FLAG                *
YR   F*U 1380000248 091712 915 WRONG PICK UP TAX JURISDICTION                  *
YR   F*U 0970000504 031413 001 Terms % not on item when Sub from Bid           *
YR   F*U 8000011208 022413 915 Allow items to be copied into order             *
YR   F*E 8000011221 061413 070 ADD 120 DAY A/R AGING BUCKET                    *
YR   F*U 0970000531 070913 001 CORRECT LINE ITEM DISCOUNT OVRRDE FLAG          *
YR   F*U 0420001316 080913 001 Correct W/O Number in Sales Order               *
YR   F*U 1110000598 092513 915 CANNOT CHG DIRECT CR MEMO TO PENDNG             *
YR   F*U 0420001363 111313 915 Auth to work order thru OE/MAINT                *
YR   F*U 1800000158 070214 001 correct cursor positioning on full page         *
YR   F*U 8000011841 100814 275 Fix order recalc problem when removing items    *
YR   F*U 8000011848 102114 001 SO fab items not updated with WO information    *
YR   F*U 8000011869 111114 001 Pricing incorrect when copying orders           *
YR   F*U 8000011891 021215 275 Fix addition of multiselect recs into sfl.      *
YR   F*U 1090000535 021219 915 PRR4947 decimal data error                      *
YR   F*U 0970000604 022015 923 TAX JURISDICATION POP UP                        *
YR   F*U 8000011932 031715 915 Curbstone card process changes #1               *
YR   F*U 8000011932 031715 915 Curbstone card process changes #1               *
YR   F*U 1610000884 050115 923 1281-DEFAULTS NOT ADJ TO NEW CUST #             *
YR   F*U 0970000617 052615 915 Stop auth return req. for price                 *
YR   F*U 8000012042 071415 275 Fix selection code disappearance in wide o/e    *
YR   F*U 1110000621 080315 119 TAX JURIS WRONG FOR ORIGINATION                 *
YR   F*U 1510000177 080815 915 Split order total cost wrong                    *
YR   F*U 1220001554 090215 923 CONTRACT REL SHIP TO ADD NOT UPDATE             *
YR   F*U 1550000424 092415 915 SPLIT ORDER NOT GOING TO RIGHT OUTQ             *
YR   F*U 8000012210 121715 915 WARN MSG FOR OTHER CHARGES TAX FLAG             *
YR   F*U 0820000362 012816 119 OE LINE ITEM 9 IS SKIPPED                       *
YR   F*U 1650000425 020815 923 SERIAL # IN WAREHOUSE/AFFECT INV N              *
YR   F*U 8000012596 051616 119 CANNOT GENERATE WORK ORDER                      *
YR   F*U 1710000730 061016 097 reason code invalid cursor location             *
YR   F*U 8000012398 081716 200 Style change for TS2                            *
YR   F*U 1380000281 083116 915 Missing OEPTTA tax records                      *
YR   F*U 1380000282 092016 119 Credit Reason Code Not Required                 *
YR   F*U 1510000236 011317 001 Ship branch not secured                         *
YR   F*U 8000012566 030917 019 Add access to Unbilled Ledger                   *
YR   F*U 1330000286 041817 119 TAX FLAG FOR ITEM WHEN RELEASED BID             *
YR   F*U 1550000489 050517 915 CURSTONE DEPOSIT ISSUE                          *
YR   F*U 1890000113 062617 019 Revise Item Price Inquiry authority check       *
YR   F*U 1020000230 071217 144 INV REGISTER DOUBLING COST OF KIT               *
YR   F*U 0970000704 072017 144 OTHER CHARGES AND SALES TAX RECALC              *
YR   F*U 1870000104 073117 144 OED2020S UPDATE OR DELETE ERROR                 *
YR   F*E 8000012747 013118 915 AVATAX PARM CHANGES - TAX OVERRIDE              *
YR   F*E 8000012817 031618 915 AvaTax - Taxable flag handling                  *
YR   F*E 8000012813 032218 915 CHG/CORRCT'N TO AVATAX INTIGRATION              *
YR   F*E 8000012867 040418 404 Bid rel to order for generic cust               *
YR   F*U 1670000201 041618 007 ORDER LINES MISSING TERMS                       *
YR   F*U 8000012913 052218 915 Cash invoice record lock                        *
YR   F*U 0970000761 071318 001 Rsvd/Pending orders on Hold changes             *
YR   F*U 1090000318 030606 094 DEFAULT SALES ID IF BLANK IN BID                *
YR   F*U 0970000240 081606 127 CORRECT ITEM PRICE USING CR MEMO                *
YR   F*E 0970000285 100107 913 DEPOSIT NOT PRINTING FOR COD ORDER              *
YR   F*U 1710000186 011008 914 S/N REQUIRED WITH NO SHIP/BO QTY                *
YR   F*U 1610000757 021608 915 COMPONENT PRICE NOT CORRECT IN O/E              *
YR   F*U 0100005022 030909 248 NON-INVENTORY SHIP QUANTITY DEFAULT             *
YR   F*U 0100005148 031209 248 ALLOW MOP CHG IF SO FROM CONTRACT               *
YR   F*U 0100005192 070209 001 Overriding SlsID not being kept                 *
YR   F*U 8000010767 092109 171 C/M NOT LOADING 0 COST FOR PRCCRD               *
YR   F*U 1220001356 051410 144 LOSING GENERATE PO FLAG IN OE/OM                *
YR   F*E 9000001477 101110 200 Remove format OEF2020M                          *
YR   F*U 8000010995 033111 070 CHECKBOX NOT DISPLAYING                         *
YR   F*U 1020000206 040611 248 I/I ERROR ON FILE IVLMSBR2                      *
YR   F*U 1220001416 080111 915 INVALID 'IN LIEU OF' COMMENT                    *
YR   F*U 8000011300 041312 078 Bid release for work orders                     *
YR   F*U 0970000413 042612 001 Ship branch tax jurisdiction for pickup         *
YR   F*U 0430000251 020713 915 Tax flag for other charges                      *
YR   F*U 0920000214 102714 019 Correct Repetative DNR Message Issue            *
YR   F*U 8000012909 051818 404 Allow to complete order w/tax error             *
QV   F*U 1090000325 030706 062 INVALID MESSAGE IN ORDER ENTRY                  *
QX   F*E 8000009869 030906 171 CRM-ACCESS TO OTH SCREENS FRM NOTES             *
Q2   F*U 8000009923 060106 171 O/E IS LOADING "P" AS MOS                       *
Q4   F*E 8000009570 041706 020 HD/WO interface                                 *
RA   F*U 8000009876 071706 070 NON-STOCK INVENTORY BALANCING                   *
RB   F*E 8000009883 080106 907 SERIAL# TRACKING FOR ALL TRANSACTIONS           *
RD   F*U 0910000231 081906 127 JOB CHG FOR ORDER RLS FROM CONTRACT             *
RE   F*E 8000009889 060506 171 Warranty claim entry                            *
RF   F*U 8000009994 091106 070 UNABLE TO ENTER CREDIT MEMO                     *
RH   F*U 0520000236 092806 907 REMOVE LIMIT OF 99 SERIAL#                      *
RI   F*U 1430000299 102006 127 NOT GETTING WINDOW FOR TAX CODE                 *
RK   F*U 8000010003 110906 070 FUTURE INV & INVENTORY BALANCING                *
RO   F*E 8000010061 012207 915 P/O TAG TO USE NEW FIELD FOR S/O                *
RN   F*E 8000009966 010407 907 CHANGE S/O NUMBER TO 7 CHARS ALPHA              *
RV   F*E 8000010117 040407 907 SERIAL NUMBER CONTROL CHANGES                   *
RX   F*E 8000010120 050107 907 SERIAL NUMBER CORRECTIONS-USER GROUP            *
R3   F*U 0430000269 071307 171 STEP TAX ISSUE FOR MULT UOM ON ITEM             *
R5   F*E 8000009999 083007 907 SERIAL NUMBER CHANGES FOR V/R                   *
SD   F*E 8000010235 120407 078 Work order costing                              *
SH   F*U 1430000364 122007 078 Work order creation only for fab branch         *
SJ   F*U 8000010278 122707 915 TAX JUR OF CONTRACT RELEASED TO S/O             *
SK   F*U 1610000748 122607 913 MATERIAL HANDLING FLAG NOT CORRECT              *
SL   F*U 0050004137 010208 002 O/C taxable follows header flag.                *
SO   F*U 1430000418 012208 078 Update w/o files before maintaining w/o         *
ST   F*E 8000010199 021208 062 INTELLIGENT MESSAGING                           *
SV   F*E 8000010256 021808 019 Weighted Average Freight                        *
SX   F*E 8000010307 031708 913 INCREASE PRICE IN O/E FOR REL 12.0              *
SZ   F*E 8000010162 041408 914 MINCRONIZE RGA FOR NEXT RELEASE                 *
S4   F*E 8000010333 050508 099 Add F22 to O/E for Ship Complete                *
TA   F*E 8000010376 050808 913 NET PRICE EXPANSION-EXT TO 8-10307              *
TB   F*E 8000010203 051308 020 CUSTOMER RELATIONSHIP MANAGEMENT I              *
TC   F*E 8000010234 050708 913 SET UP AN ITEM AS NON-INVENTORY ITM             *
TD   F*E 8000010242 052608 920 BRANCH SECURITY - ORDER MAINTENANCE             *
TE   F*E 8000010408 052708 913 EDIT TOTALS IN OE SYSTEM FOR OVRFLW             *
TF   F*E 8000010336 061708 915 SUPERSEDED ITEMS                                *
TH   F*E 8000010431 072508 920 SERIAL NUMBER EDITING                           *
TI   F*U 8000010481 072308 020 Changes to superseded items                     *
TJ   F*E 8000010493 080408 171 Data structure incorrect in Order Entry         *
TL   F*U 8000010527 081908 001 BRANCH SECURITY - Add Ship Branch               *
TM   F*E 8000010510 082108 913 SERIAL # SEARCH IN RGA ENTRY                    *
TN   F*E 8000010532 082208 915 AUTH TO CRT OPEN CREDIT MEMO ISSUE              *
TO   F*E 8000010544 082608 127 BRN SECURITY ALLOW TO MAINT IF TIDS             *
TP   F*E 8000010550 090408 001 Add supsersed/overstock code changes            *
TQ   F*E 8000010541 091008 915 Price credit in RGA                             *
TV   F*U 1090000357 102808 920 LOSING BID # ON RESERVE RELEASE                 *
TW   F*E 8000010610 102808 915 PRICE CREDIT ON RETURNS FOR COMBO               *
T2   F*E 8000010325 012909 020 Weighted Average Rebates                        *
T4   F*U 1290000277 020509 127 PREVENT ENTERING FUTURE ORDER DATE              *
UC   F*E 8000010690 042509 015 ADD QTY/PROD/DESC/PRICE VIEW TO O/E             *
UI   F*U 1220001337 031810 007 SPLIT ORDER LOSING JOB INFORMATION              *
UM   F*U 1220001363 051410 144 OE PARM OVERRIDE NOT RETAINED                   *
U5   F*U 8000008941 011012 915 ERR MSG FOR SHIP CODE NOT CLEAR                 *
VF   F*U 0970000415 051512 915 SALES ID NOT PROTECTED BID RELEASE              *
VG   F*U 0420001183 091013 019 Prevent use of (F) select for Bid WO Rel to SO  *
VQ   F*E 8000011288 030513 915 Restrict ability to override prices             *
VR   F*E 8000011216 030713 915 User enrolment for tax flag in OE               *
VU   F*E 8000011233 032613 248 MAKE DNR MATERIAL MORE VISIBLE                  *
VW   F*E 8000011222 052413 915 PRT/FAX/EMAIL FROM CREDIT ANALYSIS              *
VX   F*E 8000011202 060413 915 EMAIL BIDS AND S/O TO MULT ADDRRESS             *
V3   F*U 8000011468 092513 200 Add more info to SmartDistributor prompter      *
V4   F*U 0420001358 100213 915 Work order created for wrong branch             *
WA   F*U 0910000279 020414 915 CUST DEFAULTS WHEN CHG CO/BR IN OE              *
WC   F*E 8000011586 032014 915 INTELLICHIEF LICENSE KEY CHECK                  *
WG   F*U 8000011785 070914 200 Create wide view of OE for SmartDistributor     *
WI   F*U 8000011806 090314 275 Add Multiselect capability from SmartDistributor*
WJ   F*E 8000011209 100214 915 Credit card processing                          *
WO   F*U 8000011871 111214 200 Wide screen OE version 2                        *
WV   F*U 0970000500 022715 923 Ship address not retained in maintenance        *
WX   F*U 1810000150 031715 923 OEPTTA TAX AUTH DETAIL DUPLICATES               *
W2   F*U 8000011582 062415 275 Require ship code if a sigsmart br              *
XD   F*E 8000012183 102815 001 Add logic for new event HDE0020                 *
XE   F*E 1290000353 121315 248 WAR V3 SPECIAL BUY                              *
XH   F*U 1850000100 121915 923 OE WIDE VIEW SYSTEM DEFAULT ENRLMNT             *
XI   F*U 1090000578 012716 915 CASH DISC % FIELD PROTECTED                     *
XR   F*U 0970000674 092116 119 BO's Not showing in Backorder/Lowst             *
XS   F*U 8000012446 092816 001 Corrections to event HDE0020; orders on crd hld *
XT   F*E 8000012436 110316 915 Curbstone C2 to C3 conversion                   *
XU   F*U 8000012899 122616 915 Chg format of addr and zip-form sol             *
X0   F*U 8000012610 053017 915 Avalara AvaTax interface                        *
X1   F*E 8000012637 060817 171 EXTRACT OER2020 CODES INTO COPYBOOK             *
YB   F*E 8000012729 121917 404 Avalara Avatax interface-minimize API calls     *
YD   F*U 8000012776 010918 404 CORRECT OVERRIDE ADDRESS FOR SPLIT ORDERS       *
YK   F*E 8000012868 040418 915 AvaTax cash sales inv handling chg              *
YM   F*U 1710000842 050918 404 Zero Tax Leaving Order Entry                    *
YQ   F*E 8000012680 080818 915 AvaTax interface for C/O                        *
YR   F*E 8000013070 083118 019 Remove all subrtns & place in OEY2020 cpysrc    *
YS   F*E 8000013106 101918 282 Apache Forms - QFORMS JOBQ                      *
YT   F*E 8000013114 102418 171 Cash order not voided in AvaTax                 *
Y0   F*E 8000013122 050219 915 Card Connect - Credit card process              *
Y1   F*E 8000013392 110119 019 New sales order creation notification           *
Y2   F*U 8000013359 092519 915 Avatax internet down issue                      *
Y3   F*E 1710000932 112019 404 Manager Approval price overrides                *
Y4   F*C 1430000659 121619 404 Make Ordered By Mandatory in OE                 *
ZB   F*C 0930000549 011820 169 MAKE ORD BY REQ IN OE FROM                      *
ZC   F*E 1820000118 012320 404 ADD USER ENROLLMENT TO EDIT BO QTY              *
ZD   F*U 1230001048 013020 915 RELEASE BID TO S/O USING MAILING AD             *
ZE   F*U 0930000560 021220 915 DEFAULT SHIP FROM BR WITH USER ENROL            *
ZF   F*E 1510000263 011020 169 ASSIGN PRINTER BY SHIP CODE                     *
ZG   F*U 8000013709 050120 171 Change tax fields loading for better fee        *
ZI   F*E 8000013734 061120 168 SD1 ORDER ENTRY ITEM IMPORT                     *
ZJ   F*E 1400000412 050620 171 Card on file for CardConnect                    *
ZM   F*E 1400000428 101520 169 GL POSTING FOR NON-INV ITEMS                    *
ZN   F*E 8000013873 112320 171 Display Taxable Amount for authority            *
ZO   F*U 1430000735 020921 275 Fix order qty for item import.                  *
ZQ   F*E 1220001980 043021 169 CHG BUTTON TXT SD-ONE STRY0016421               *
ZR   F*E 8000013940 050321 171 Prompts for Card not present                    *
ZU   F*E 1290000727 100121 171 Worldpay - Credit card processing               *
ZV   F*E 1710001106 111221 404 Enhanced Lost Sales Phase 5                     *
ZY   F*E 8000014036 022322 171 Worldpay - changes for certification            *
ZZ   F*E 1710001130 031622 404 Enhanced Lost Sales User Added Item             *
Z0   F*E 1650000657 042622 275 Fix mulit select in SD-One for pricing sfl      *
Z0   F*E                       and rework.                                     *
Z1   F*E 8000014082 062122 404 Non Returnable Item                             *
Z2   F*E 8000014081 061522 171 Colorado Retail Delivery Fee changes            *
Z3   F*E 1400000490 071122 404 Customer Specific Credit Limits                 *
Z4   F*E 1710001144 072022 404 Capture Customer Jobsite Address                *
Z5   F*E 1710001089 071221 404 ALLOW MANAGER OVERRIDE REMOTE                   *
0A   F*E 1710001146 072521 404 Deposit popup window notification               *
0C   F*E 1400000502 092022 171 INCREASE DEVICE SERIAL# LENGTH                  *
0E   F*E 1400000500 020823 171 Credit Card Processing Fee                      *
0F   F*E 1880000112 030623 097 default to ticket if allowed to immediate inv   *
0N   F*U 8000014138 121323 321 CARD - EDIT CARD DEVICE BY DEV TYPE             *
0P   F*C 1400000537 013024 321 STORE GEOCOORDINATES CUST BR ADDRES             *
¢A   F*E KSB   1456        KSB CHG ARRAY A2 TO FUEL SURCHARGE                  *
¢B   F*E KSB   1493        KSB GMC WARRANTY CHG - REQ VALID GMC/AMNTAG#        *
¢D   F*E KSB   1600        KSB ALLOW USER TO CHG CHARGE TO CASH                *
¢E   F*E KSB   1606        KSB CHG PRTTYP BASED ON CASH/WALKIN CUST            *
¢F   F*E KSB   1607        KSB REQ RA# ONLY IF GMC/AMN ITM AND VR = Y          *
¢G   F*U SHB   1264 073100 RRB DO NOT ALLOW CASH DIRECTS                       *
¢I   F*E KSB   1360 091803 KSB DISALLOW BO FOR DNR ITEM                        *
¢M   F*E KSB   2925 101504 KSB SEND EMAIL IF ORD ON CRD HOLD                   *
¢N   F*E KSB   3011 102604 KSB DISALLOW OLD ITEM# TO BE USED                   *
¢R   F*C 0430000239 012806 094 DO NOT ALLOW CASH TICKETS.                      *
¢P   A*C APB   9042 111617 APB Add Unit Exchange to Warranty                   *
¢P   A*C                       Allow pricing correction on debit memos         *
¢Q   F*C APB   9054 080318 APB Add order# to header file                       *
¢R1  F*C CLP   6720 070918 CLP Changed cash ticket credit limit to 7,500       *
¢S   F*C APB   9075 091918 APB Modified warranty order# update when the        *
¢S   F*C                       original order was voided or not created        *
¢U   F*C ksb   4856 081806 ksb Validate ship to state                          *
¢V   F*C ksb   4858 082106 ksb restrict our truck ship to certain state        *
¢W   F*C ksb   4861 082306 ksb Validate ship to address for UPS shipmen        *
¢KSB F*C ksb   4861 082306 ksb Fix mincron bug oth chgs not redefaultin        *
¢KSB F*C ksb   4951 012507 ksb Fix mincron bug oth chgs not redefaultin        *
¢Y   F*C ksb   5005 050707 ksb REQUIRE RA# FOR HEAT KITS                       *
¢Z   F*C ksb   5016 051407 ksb chg default gp% display                         *
¢A2  F*C ksb   5028 080807 ksb check gmc/amn warranty item                     *
¢A3  F*C ksb   5144 011508 ksb DEFAULT FRT AMT IF SHIP = S                     *
¢A4  F*C ksb   5167 020508 ksb Require fuel surcharge cash & our trk           *
¢A3  F*C ksb   5172 021908 ksb Warranty fee for walkin cust                    *
¢A5  F*U KSB   5131 013008 KSB Add flag to turn on/off addr validation         *
¢A6  F*U KSB   5182 031408 KSB Req HSE sls# for walkin                         *
¢A9  F*U KSB   5218 071408 KSB Increase Fuel Surcharge to $15                  *
¢B1  F*U KSB   5242 090808 KSB don't hold orders < 100                         *
¢B2  F*U KSB   5287 010509 KSB always write prod# even if item# entered        *
¢B3  F*U KSB   5289 010609 KSB don't overwrite ship to city if addr val        *
$A   F*C DCB   5345 042409 DCB GMC INFO FINDER INTERFACE                       *
$C   F*C RELEASE 12 072409 DCB LIMIT REASON CODES IN OE ENTRY/MAINT            *
$D   F*C RELEASE 12 080409 DCB MAKE EMS(12) HARD ERROR                         *
$E   F*C RELEASE 12 081209 DCB CHECK FOR BLANK SOURCE/TYPE CODE                *
$F   F*C RELEASE 12 082809 DCB SHOW RPL ITEM MSG B4 NO BO ON DNR MSG           *
$H   F*C RELEASE 12 091609 DCB ALLOW DUPLICATE RA#                             *
$L   F*C DCB   5422 111109 DCB INCORRECT DNR MSG                               *
$N   F*C ksb   5470 033110 ksb require prom date if ship type our trk          *
$P   F*C       5479 042010 DCB USE TABLE FILE FOR FUEL SURCHARGE               *
$S   F*C ksb   5558 062110 DCB force oth chg to display                        *
$T   F*C       5580 062011 DCB DISCOUNT SOURCE CODE                            *
$U   F*C       5657 062411 DCB GMC RGA NUMBER SIZE CHANGE TO 8 DIGITS          *
$V   F*C       5664 072011 DCB ALWAYS EDIT SHIP CODE NOT JUST ON F15           *
$W   F*C ALA   6092 012712 ALA Change freight amount from $75 to $25           *
$Y   F*C DCB   5746 050712 DCB Capture price before price override             *
$0   F*C DCB   5797 053112 DCB Disc src code change for uom                    *
$2   F*C ksb   5894 030613 ksb recalc amn cost if price override               *
$4   F*C DCB   5914 052913 DCB ADD BAKER ITEM SEARCH INQUIRY                   *
$5   F*C ALA   6139 010814 ALA CHANGE SMALL DOLLAR AUTO RELEASE THRESHOLD      *
$7   F*C DCB   7008 060414 DCB DO NOT ALLOW SLASH ITEMS                        *
¢(   F*C DCB   7024 081814 DCB B2B - Credit Memo                               *
¢)   F*C CLP   6037 083115 CLP IF FAXTKT='Y' ASSUME 'E' FOR EMAIL              *
$8   F*C DCB   7114 042016 DCB CANNOT ENTER DIRECT SERIAL NUMBERS              *
$9   F*C CLP   6491 060316 CLP Updated RA validation logic to allow for length *
$9   F*C                       of 9 starting with character                    *
:C   F*C KSB   9006 083016 KSB allow freight charge and warranty fee           *
:D   F*C CLP   6488 052416 CLP Initial Order Fulfillment implementation        *
:H   F*C APB   9024 061917 APB Add GMC Vend# to OER9990 parms                  *
:I   F*C DCB   7133 063017 DCB ADD EDIT FOR CORRECT CREDIT CARD AMOUNT         *
:J   F*C APB   9022 062217 APB Warranty Claim Entry                            *
:K   F*C APB   9025 090117 APB Update OEPTWCD, OEPGWCD, OEPCGWCD               *
:L   F*C APB   9026 090117 APB Prevent reason code 'P' from being used         *
:M   F*C DCB   7143 091317 DCB Allow F11 terminate on cash invoice             *
:P   A*C APB   9052 022018 APB Add printer control for express pickup          *
:Q   A*C APB   9042 111617 APB Add Unit Exchange to Warranty                   *
:Q   A*C                       Allow pricing correction on debit memos         *
:R   F*C APB   9054 030918 APB Add order# to header file                       *
:S   F*C APB   9059 032718 APB Remove program OER9431                          *
:T   F*C APB   9060 032818 APB Add error file to capture when order#           *
:T   F*C                       is not being updated in oepgwcd, oeptwcd        *
:U   F*C APB        052218 APB Add error file to capture when order#           *
¢*   F*C RELEASE122 071918 DCB ADD ITEM LINK LOOKUP TO SELECT FIELD            *
:V   F*C APB   9070 081318 APB Open file ARLTCCT1 on cash sale                 *
:W   F*C DCB   7164 082318 DCB CORRECT TOTAL COST DOUBLED                      *
:U   F*C APB   6734 091818 APB Removed obsolete code for :T                    *
     F*C CLP   6742 092118 CLP Updated for SOX documentation                   *
:X   F*C DCB   7166 092718 DCB CAPTURE CANCELLED ORDER LINES                   *
:Y   F*C APB   9075 091002 APB Update warranty order# when the original        *
:Y   F*C                       order was voided or not created                 *
:0   F*C DCB   7183 021519 DCB DO NOT ALLOW BOLES CUSTOMER NUMBER              *
:1   F*C CLP   6781 022819 CLP Removed :0 to allow usage of Boles customers    *
:2   F*C APB   9058 110118 APB Remove :R                                       *
:3   F*C DCB   7200 082219 DCB DO NOT ALLOW CLOSED BRANCH                      *
:4   F*C 0430000299 071719 279 UNMARKED CODE (12.2E)                           *
:5   F*C 0430000299 080119 144 Instructions on coding           (12.2E)        *
:6   F*C 0430000299 080119 144 Change MSG 184-188 to CSG 25-29  (12.2E)        *
:7   F*C APB   9104 101419 APB Add manual tax                                  *
:8   F*C DCB   7204 102419 DCB Look up and load other charge description       *
:9   F*C APB   9108 111219 APB Disallow reason codes 'C' & 'I' for CM's        *
#0   F*C APB   9125 012020 APB If HIller & job WARR make item a no charge      *
#1   F*C APB   9126 020520 APB Increase Tag# to 10 in length                   *
#2   F*C DCB   7174 121718 DCB CAPTURE ALIAS ITEM NUMBER USED                  *
#3   F*C DCB   7224 022720 DCB PUT BACK MOD TO ALWAYS WRITE OEPTOA             *
#4   F*C CLP   6890 032320 CLP Override customer tax flag for Motili and CS    *
#4   F*C                       Sloan for the state of MO                       *
#5   F*C CLP   6894 040920 CLP Reset ship branch information if changed on the *
#5   F*C                       order header                                    *
#6   F*C CLP   6900 051820 CLP Override customer tax flag for C&S Sloan        *
#7   F*C APB   9143 051920 APB Prevent Hiller's 'WARR' job from being used on  *
#7   F*C                       credits, have them use RGA                      *
#8   F*C APB   9146 060520 APB Display code 'O' for superseded items           *
#9   F*C APB   9157 072920 APB Remove tax customization for Ingram's           *
#9   F*C CLP        080620 CLP Remove tax customization for CS Sloan           *
#10  F*C DCB   7225 040720 DCB ADD PROMO DATES FOR COUPON POST GROUP           *
#A   F*C DCB   7238 082620 DCB FIX BID ISSUE WITH PRICE SOURCE CODE            *
#B   F*C DCB   7255 122120 DCB DEFALUT R STATUS IF OPEN BO AND SHIP COMPLETE   *
#C   F*C APB   9191 010621 APB Corrected #B changes and cleaned up markings    *
#C   F*C                       for clarity                                     *
#D   F*C APB   9193 011221 APB -Skip cc total validation if card connect       *
#E   F*C APB   9195 011521 APB -For CardConnect display 'F' only if customer   *
#E   F*C                        has a card on file                             *
#F   F*C DCB   7259 020121 DCB GET OE COMPLETION SCREEN DEFAULTS               *
#G   F*C APB   9207 031521 APB Fix tax issue when order is Cash, COD           *
#G   F*C                       and on Credit Hold                              *
#H   F*C DCB   7264 031121 DCB FIX OE COMPLETION SCREEN DEFAULTS               *
#I   F*C APB   9208 031721 APB -Remove expired credit cards from card on file  *
#I   F*C                       -Do not allow card to be saved for walk-ins     *
#J   F*C DCB   7267 032421 DCB ADD MOS TO TABLE CM11                           *
#K   F*C DCB   7267 040221 DCB DO NOT ALLOW BR 700-899 FOR SELL BRANCH         *
#L   F*C DCB   7269 041021 DCB ADD OT OE DEFAULT                               *
#L   F*C                   CLP Added call to OER2024 to sequence items for     *
#L   F*C                       picking before calling FULR002 for orders that  *
#L   F*C                       are not going to be printed                     *
#M   F*C APB   9217 042621 APB Exclude Quotes from OT Defaults                 *
#N   F*C APB   9222 052021 APB Fix Zip Code Logic to avoid offering the cc     *
#N   F*C                       billing zip and CVV prompt for cash and check   *
#N   F*C                       transactions                                    *
#O   F*C APB   9223 051821 APB Added WC to OE defaults                         *
#P   F*V APB   9224 060421 APB Added new parm to oerc027 to determine if date  *
#P   F*V                       logic is to be used                             *
#P   F*V                       Print ticket if date logic is used to open up   *
#P   F*V                       serialized orders.                              *
#Q   F*V APB   9228 070121 APB Do not let CM go on reserve                     *
#R   F*C DCB   7279 072321 DCB CHANGE TERMS DISCOUNT CALC - USE ORDER TOTAL    *
#S   F*C APB   9252 092421 APB Prevent XP and AC tickets from going on reserve *
#T   F*C APB   9259 111021 APB Flip order type to DM if a return exists on tkt *
#T   F*C                       Do not allow WUE claims through order entry     *
#U   F*C DCB   7300 011022 DCB BRING BACK QTY FROM COLON SEARCH                *
#V   F*C DCB   7309 021422 DCB CLEAR PROD NUMBER ON RETURN FROM COLON SEARCH   *
#W   F*C APB        040722 APB Cube D upgrade modifications                    *
#Y   F*C DCB   7317 041422 DCB ADD PRICE OVERRIDE TRACKING                     *
#Y   F*C DCB   7317 041422 DCB ADD EDIT PROMISED DATE CANNOT BE LT ORDERED DATE*
#Z   F*C APB   9278 042822 APB If quote and pending make ship complete 'N'     *
&A   F*C APB   9286 061722 APB Warranty claims cannot be invoiced through OE   *
&A   F*C                       Fix warranty CM status due to paperless project *
&B   F*C DCB   7333 092122 DCB DEPOSIT FRAUD ALERT                             *
&C   F*C APB   9301 092922 APB Use RGA if item is set up as inventory, has a   *
&C   F*C                       negative qty, and a reason code with affect     *
&C   F*C                       inventory = 'Y'                                 *
&D   F*C APB   9314 120122 APB Don't allow deposit if walk-in                  *
&E   F*C APB   9325 020123 APB Selling branch cannot be a hub                  *
&F   F*C APB   9362 110823 APB Req HYD sls# for company 2 walkins              *
&G   F*C DCB   7366 010824 DCB ADD COMPANY TO ORDER DEFAULTS                   *
&H   F*C APB   9369 020224 APB - Do not make ticket a credit or debit if       *
&H   F*C                         negative item is inventory='N'                *
&I   F*C DCB   9377 110923 DCB ARPMBAL AND MULTI COMPANY                       *
&J   F*C DCB   8185 031124 DCB ARPMBAL AND MULTI COMPANY                       *
&K   F*C APB   9355 031424 APB Fix default salesman id for company 2           *
&L   F*C DCB   7313 030122 DCB GIVE WARN MESSAGE IF ALL BO VOID ITEM ON ORDER  *
&M   F*C JJF   3071 032424 JJF Add table file entry CM66 to control  COD       *
&M   F*C                       credit limit maximum.                           *
&N   F*C APB   9394 052124 APB - Promo code cannot be used on negative dollar  *
&N   F*C                         ticket.  Default reason codes if promo exists *
&O   F*C APB   9373 040124 APB If ship complete 'C' default 'R' status         *
&P   F*C APB   9422 110524 APB Do not allow direct invoicing on a will call    *
&Q   F*C APB   9448 032025 APB Do not track serial numbers for Hydros          *
&R   F*C APB   9445 030325 APB PROTECT PAYMENT ON ACCOUNT                      *
&S   F*C APB   9472 071525 APB Allow DNR item to be ordered if found at another*
     F*C                       branch, send email to purchasing.               *
&T   F*C APB   9482 092625 APB CC Payment screen fix after Upgrade 12.3 F-G    *
&U   F*C CLP   5159 092725 CLP Increased windor size for OEWC2020A to avoid    *
&U   F*C                       hard error trying to display warning window     *
&V   F*C APB   9486 102925 APB Add direct call to AFS for shipping quotes      *
&V   F*C                       Add TF entries for creating AFS pending order,  *
&V   F*C                       prompt AFS portal, save addresses               *
     F*M ----------------------------------------------------------------------*
ZF   Foelmsbr1  if   e           k disk    prefix(d_)
ZB   FARLMCUA4  if   e           k disk
     FOEPWITX   IF A E             DISK    USROPN
     FOELTDP1   UF   E           K DISK    USROPN
     FOELTALL1  O    E             DISK    USROPN
     F                                     IGNORE(OEFTLN)
     FOELTOV1   UF A E           K DISK    USROPN
     FOELTOHY8  IF A E           K DISK    USROPN
     F                                     RENAME(OEFTOH:OEFTOHH)
     FOELTOLYE  IF A E           K DISK    USROPN
     F                                     RENAME(OEFTOL:OEFTOLE)
     FARLMTRD3  IF   E           K DISK
     FARLMTXS1  IF   E           K DISK    USROPN
   :3F*ARLMBCH4  IF   E           K DISK
:3   FARLMBCH2  IF   E           K DISK
     FTBLMTBL1  IF   E           K DISK
     FARLMCUS1  IF A E           K DISK
     FARLMBALA  IF   E           K DISK
     F                                     RENAME(ARFMBAL:ARFMBALA)
     FARLMJBM1  IF A E           K DISK    USROPN
     FARLTNT2   IF A E           K DISK
     FARLMSLS4  IF   E           K DISK
     FIVLMEXT1  IF   E           K DISK    USROPN
     FIVLMSBR1  UF   E           K DISK    USROPN
RA   FIVLMNSB1  UF   E           K DISK    USROPN
     FIVLMSBR2  IF   E           K DISK    USROPN
     F                                     RENAME(IVFMSBR:IVFMSB2)
     FIVLMSTRC  IF   E           K DISK    USROPN
     F                                     RENAME(IVFMSTR:IVFPROD)
     FIVLMSTRK  IF   E           K DISK    USROPN
     F                                     RENAME(IVFMSTR:IVFOUR)
     FIVLMCMP1  IF   E           K DISK    USROPN
     FIVLMALI3  IF   E           K DISK    USROPN
   RBF*OELTSR1   IF A E           K DISK    USROPN
   RBF*OELTSRY1  IF   E           K DISK    USROPN
     FOPLMSEC1  IF   E           K DISK
     FPOLTOL4   IF   E           K DISK    USROPN
     FPOLTOT1   IF   E           K DISK    USROPN
     FPOLTOL1   UF   E           K DISK    USROPN
     F                                     RENAME(POFTOL:POFTOL1)
     FPOLTOH1   UF   E           K DISK    USROPN
     FPOLTTG1   UF A E           K DISK    USROPN
     FIVLTNSK5  UF A E           K DISK    USROPN
     F                                     RENAME(IVFTNSK:IVFTNSK5)
     FOELWOAR1  IF   E           K DISK    USROPN
     FOELTOAL4  UF   E           K DISK    USROPN
     FOELTCOH1  UF   E           K DISK    USROPN
     FOELTCOL1  IF   E           K DISK    USROPN
     F                                     RENAME(OEFTOAL:OEFTOAL7)
     FOELTBRH1  UF   E           K DISK    USROPN
     FOELTBRL1  UF   E           K DISK    USROPN
     FOELWCBL1  UF   E           K DISK    USROPN
     FARLMCAD1  IF   E           K DISK    USROPN
     FIVLMPBT1  IF   E           K DISK
     FOELTOAM2  IF   E           K DISK    USROPN
     FOELTOAD1  UF A E           K DISK
     FOELTLLN1  UF A E           K DISK
     FOELWRLS1  UF   E           K DISK    USROPN
     F                                     RENAME(OEFWRLS:OEFWRL1)
     FOELWRLS2  UF   E           K DISK    USROPN
     F                                     RENAME(OEFWRLS:OEFWRL2)
     FARLMENT1  IF   E           K DISK
     FARLEBAL1  IF   E           K DISK
     FIVLINOT1  IF   E           K DISK
SJ   FARLMZMF1  IF   E           K DISK    PREFIX(Z)
Q4   Fwkpwreq   uf a e             disk    usropn
Q4   f                                     infds(infdsWreq)
Q4   fwkltoh1   if   e           k disk    infds(infdsToh1)
Q4   f                                     usropn
TF   fivlmrep5  if   e           k disk    prefix(x)
TF   fivlmrep6  if   e           k disk    rename(ivfmrep:bynewitm)
TF   f                                     prefix(y)
TV   foeltoh1   if   e           k disk    rename(oeftoh:oeftoh1)
TV   f                                     prefix(b_)
VG   FOELTBL1   IF   E           K DISK    rename(oeftbl:oeftbl1)
VG   f                                     prefix(c_)
V3   FSHLCLIP1  UF A E           K DISK
WG   FOEPW2020S UF A E           K DISK    Usropn
WJ   Farltcct1  uf   e           k disk    prefix(v) usropn
ZJ   FARLTCCTD  IF   E           K DISK
ZJ   F                                     RENAME(ARFTCCT:ARFTCCTD)
WJ Y0F*arlmcsc1  if   e           k disk    prefix(f) usropn
Y0   Farlmcsc3  if   e           k disk    prefix(f) usropn
WX   FOELWTA1   UF   E           k DISK    Prefix(TX_)
X0   Ftblmtbl3  if   e           k disk    rename(tbfmtbl:tbfmtbl3)
Y0 0NF*arlmccd1  if   e           k disk
0N   Farlmccd3  if   e           k disk
Y3   FOEPTPOL   IF A E             DISK    prefix(OV_)
Y3   FOELWPOL1  UF A E           k DISK    Usropn prefix(OV_)
Z5   FOELWPOL2  UF   E           k DISK    Usropn prefix(OV_)
Z5   F                                     Rename(oefwpol:oefwpol2)
ZD    * Bid ship to address file
ZD   Foeltba2   if   e           k disk    usropn prefix(s)
ZD   F                                     rename(oeftba:oeftba2)
ZE   Foplmupe1  if   e           k disk    prefix(n)
ZI   Fivlmpck2  if   E           K DISK    prefix(i_)
ZV   FOEQWLST   UF A E             DISK    USROPN PREFIX(L)
Z1   FIVLMSTA4  IF   E           K DISK
WO   FOED2020S  CF   E             WORKSTN Usropn
WO   F                                     SFILE(OES2020S:RRN)
¢*   FIVLCCID1  IF   E           K DISK
:X   FOEPTOLV   O    E             DISK
#2   FIVPALIAUD IF A E             DISK
#O   FOEPCTOH   UF A E           K DISK
&S   FOEPDNRA   UF A E             DISK    Usropn
     FOED2020   CF   E             WORKSTN
     F                                     INFDS(FIL1DS)
     F                                     SFILE(OES2020G:RRN)
UC   F                                     SFILE(OES2020R:RRN)
WG WOF*                                    SFILE(OES2020S:RRN)
     F                                     SFILE(OES2020H:RRN)
     F                                     SFILE(OES2020J:RRN)
   RBF*                                    SFILE(OES2020K:RRN)
     F                                     SFILE(OES2020L:RRN)
     F                                     SFILE(OES2020N:SHPRRN)
     F                                     SFILE(OES2020P:NOTRRN)
Q4    *------------------------------------------------------------------------*
Q4    /COPY QCPYSRC,WKYPROTO
SH    /COPY QCPYSRC,HDYPROTO
WC    /COPY QCPYSRC,MNYPROTO
X0    /COPY QCPYSRC,HDYAVATAX
ZI   * ---- System : Handle Upper/Lower case conversions
ZI    /copy qcpysrc,SHYCASE
      *------------------------------------------------------------------------*
     D GA20            S              1    DIM(20)                              GENERIC SEARCH AR
     D A1              S             20    DIM(1) CTDATA PERRCD(1)              FREIGHT DESC
     D A2              S             20    DIM(1) CTDATA PERRCD(1)              DELIVERY DESC
     D A3              S             20    DIM(1) CTDATA PERRCD(1)              HANDLING DESC
     D A4              S             20    DIM(1) CTDATA PERRCD(1)              RESTOCKING DESC
0E   D A5              S             20    DIM(1) CTDATA PERRCD(1)              RESTOCKING DESC
     D ARY             S              1    DIM(70) CTDATA PERRCD(70)            PICK TICKET PRINT
   YSD*FX              S             53    DIM(4) CTDATA PERRCD(1)              FAX TICKET ARRAY
YS   D FX              S             53    DIM(5) CTDATA PERRCD(1)              FAX TICKET ARRAY
     D LOU             S              1    DIM(35) CTDATA PERRCD(35)            IN LIEU OF MSG
      *
      *  Only ENHANCEMENT tasks should add messages to table MSG.  If
      *  you need to add a message for an UPDATE task, use table UMS.
      *
   SZD*MSG             S             78    DIM(180) CTDATA PERRCD(1)            MESSAGES
SZ TDD*MSG             S             78    DIM(181) CTDATA PERRCD(1)            MESSAGES
TD TLD*MSG             S             78    DIM(182) CTDATA PERRCD(1)            MESSAGES
TL   D MSG             S             78    DIM(183) CTDATA PERRCD(1)            MESSAGES
&P &VD*CSG             S             78    DIM(44) CTDATA PERRCD(1)
&V   D CSG             S             78    DIM(46) CTDATA PERRCD(1)
      *
      *  Only UPDATE tasks should add messages to table UMS.  If you
      *  need to add a message for an ENHANCEMENT, use table MSG.
      *
   RKD*UMS             S             78    DIM(34) CTDATA PERRCD(1)             MESSAGES
RK RID*UMS             S             78    DIM(35) CTDATA PERRCD(1)             MESSAGES
RI SLD*UMS             S             78    DIM(36) CTDATA PERRCD(1)             MESSAGES
SL SJD*UMS             S             78    DIM(37) CTDATA PERRCD(1)             MESSAGES
SJ T4D*UMS             S             78    DIM(38) CTDATA PERRCD(1)             MESSAGES
T4 WVD*UMS             S             78    DIM(39) CTDATA PERRCD(1)             MESSAGES
WV U5D*UMS             S             78    DIM(40) CTDATA PERRCD(1)             MESSAGES
U5 ZMD*UMS             S             78    DIM(43) CTDATA PERRCD(1)             MESSAGES
ZM   D UMS             S             78    DIM(44) CTDATA PERRCD(1)             MESSAGES
      *
      *  ADD ON APPLICATIONS MESSAGES
   Q4D*AMS             S             78    DIM(2) CTDATA PERRCD(1)              ADD ON MSG'S
Q4   D AMS             S             78    DIM(9) CTDATA PERRCD(1)
      *
¢W   D ZC#1            S              1    DIM(30)                                ZIP CLASS ARRAY
¢W   D CT#1            S             28    DIM(30)                                CITY NAME ARRAY
¢W   D NA#1            S             13    DIM(30)                                CITY ABBREV ARRAY
¢W   D FC#1            S              1    DIM(30)                                FACILITY CODE ARRA
¢W   D MI#1            S              1    DIM(30)                                MAIL NAME IND ARRA
¢W   D PN#1            S             28    DIM(30)                                PREFD CITY NAME AR
¢W   D CI#1            S              1    DIM(30)                                CITY DEL IND ARRAY
¢W   D ZI#1            S              1    DIM(30)                                AUTO ZONE IND ARRA
¢W   D UI#1            S              1    DIM(30)                                UNI ZIP NM IND ARR
¢W   D FN#1            S              4    DIM(30)                                FINANCE NUMBER ARR
¢W   D ST#1            S              2    DIM(30)                                STATE CODE ARRAY
¢W   D CY#1            S              3    DIM(30)                                COUNTY NUMBER ARRA
¢W   D CN#1            S             25    DIM(30)                                COUNTY NAME ARRAY
¢W   D A1#             S             64    DIM(10)                              MLT SEC ADDR
¢W   D A2#             S             64    DIM(10)                              MLT DEL ADDR
¢W   D NO#             S             10    DIM(10)                              MLT STR NO
¢W   D PR#             S              2    DIM(10)                              MLT PRE DIR
¢W   D NM#             S             28    DIM(10)                              MLT NTR NAME
¢W   D SF#             S              4    DIM(10)                              MLT STR SUFFIX
¢W   D PS#             S              2    DIM(10)                              MLT POST DIR
¢W   D AT#             S              4    DIM(10)                              MLT APT TYPE
¢W   D AN#             S              8    DIM(10)                              MLT APT NUMBER
¢W   D CT#             S             28    DIM(10)                              MLT CITY NAME
¢W   D CA#             S             13    DIM(10)                              MLT CITY ABRV
¢W   D ST#             S              2    DIM(10)                              MLT STATE CODE
¢W   D Z5#             S              5    DIM(10)                              MLT ZIP CODE
¢W   D Z4#             S              4    DIM(10)                              MLT ZIP+4
¢W   D LL#             S             64    DIM(10)                              MLT LAST LINE
¢W   D CR#             S              4    DIM(10)                              MLT CARRIER RTE
¢W   D DP#             S              3    DIM(10)                              MLT DEL PT
¢W   D CP#             S             25    DIM(10)                              MLT COUNTY NAME
¢W   D FS#             S              2    DIM(10)                              MLT FIPS STATE #
¢W   D FC#             S              3    DIM(10)                              MLT FIPS COUNTY #
¢W   D CD#             S              2    DIM(10)                              MLT CONG DIST #
¢W   D LC#             S              1    DIM(10)                              MLT LACS IND
¢W   D SL#             S              1    DIM(10)                              MLT STR MATCH LEV
¢W   D AF#             S              1    DIM(10)                              MLT SEC ADR FLAG
     D WRK             S              1    DIM(78)                              WORK ARRAY
     D W$              S              1    DIM(9)                               WORK ARRAY
     D PCPC            S              1    DIM(8)                               CHAIN DSC OR DSC
   RHD*SRL             S             20    DIM(99)                              SERIAL #S FROM SF
RH   D SRL             S             20    DIM(9999)                            SERIAL #S FROM SF
     D TAG             S              9    DIM(400)                             TAG #'S
     D AB#             S              6    DIM(400) ASCEND                      BRANCH#+OCUR#
     D BITM            S              9  0 DIM(400)                             BRANCH/ITEM/QTY
     D QTY1            S              7  0 DIM(400)
     D ITMS            S              6  0 DIM(400)                             ITEMS CHECKED
     D REF             S              1    DIM(35)                              REF UOM MSG LINE
   RND*WOS             S              7  0 DIM(400)                             MULT S/O
RN Q4D*WOS             S              7    DIM(400)                             MULT S/O
     D AR5             S              1    DIM(10) CTDATA PERRCD(1)             NUMBER EDIT
     D CRM             S              1    DIM(92) CTDATA PERRCD(46)            CREDIT HOLD MSG
     D INV             S              1    DIM(120) CTDATA PERRCD(60)           INVALID USER MSG
     D WM              S             78    DIM(3) CTDATA PERRCD(1)              WM MESSAGES
     D USR             S             10    DIM(3)                               USER ID'S     SG
     D R               S              6  0 DIM(50)                              RNS ITEMS CREATED
     D RNS             S              6  0 DIM(400)                             ALL RNS ITEMS ON S/O
     D DEP#            S              7    DIM(10)                              WITHDRAWALS
     D WD$             S              9  2 DIM(10)
   RND*ORN             S              7  0 DIM(400)
RN   D ORN             S              7    DIM(400)
     D VOD             S              1    DIM(98) CTDATA PERRCD(49)            SUBMIT JOB
     D DOA             S              1    DIM(140) CTDATA PERRCD(70)           SUBMIT DIR AUD
¢B   D GMC             S             20    DIM(400)                             GMC TAGS      ON S/O
$A   D Opary           S             15A   Dim(100)
Q4 V4D*woAry           S              7    DIM(400)
V4   D woAry           S              7    DIM(400) descend
:J   D wvnd#           s              6  0 dim(400)
:J   D wrnty           s              1    dim(400)
SX TCD*EMS             S             78    DIM(1) CTDATA PERRCD(1)              MESSAGES
TC TBD*EMS             S             78    DIM(2) CTDATA PERRCD(1)              MESSAGES
TB TED*EMS             S             78    DIM(3) CTDATA PERRCD(1)              MESSAGES
TE TFD*EMS             S             78    DIM(8) CTDATA PERRCD(1)              MESSAGES
TF TND*EMS             S             78    DIM(10) CTDATA PERRCD(1)             MESSAGES
TN TPD*EMS             S             78    DIM(11) CTDATA PERRCD(1)             MESSAGES
TP TWD*EMS             S             78    DIM(12) CTDATA PERRCD(1)             MESSAGES
TW VUD*EMS             S             78    DIM(13) CTDATA PERRCD(1)             MESSAGES
VU   D EMS             S             78    DIM(14) CTDATA PERRCD(1)             MESSAGES
TB   d contactNbr      s              5  0 inz                                  MESSAGES
TI   d ivr1015         s              1    inz
0E   D svin64          s              1    inz('0')
0E   D appccpfee       s              1
0E   D cardamount      s              9  2
0E   D ccpfee          s              7  2
0E   D ccptax          s                   like(oeam04)
0E   D ctaxdf          s              1
0E   D cdscdf          s              1                                         RES DISCOUNT
0E   D siCCPAmt        s              7  2
0E   D siCCPDesc       s             20
0E   D svam04          s                   like(oeam04)
0E   D sf_dscper       s                   like(dscper)                         RES DISCOUNT
0E   D sf_oeam06       s                   like(oeam06)                         RES DISCOUNT
0E   D sf_oeam07       s                   like(oeam07)                         RES DISCOUNT
0E   D sf_oeam36       s                   like(oeam36)                         RES DISCOUNT
0E   D sf_swd$         s                   like(oeam22)                         RES DISCOUNT
0E   D                 DS
0E   D  TBNO02                 1      9
0E   D  RSNTYP                 9      9
¢(   D W_Backup        s              8a   Inz(*Blanks)
:J   D wc_ra#          S             20    INZ(*blanks)
:J   D Rcount          s              3s 0 inz(*zeros)
:J   D Wcount          s              3s 0 inz(*zeros)
:J   D RA#Found        S              1
:J   D Tchsts          S             10
:R   D Tchtyp          S              3
:Y   D Tcho56          S              7
:J   D gmcsec          S              3
:J   D gmctmp          S              1
:J   D @Count          s              7  0 Inz
&S   D Allow_DNR       s              1    inz('N')
:J   D RaNum           s                   like(oeno69)
#L   D is_pickable     S              1
#T   D Credit_exists   S              1    inz('N')
&N   D Promo_exists    S              1    inz('N')
&N   D BO_exists       S              1    inz('N')
&O   D recalcdate      s              1    inz('N')
&V   D outOrderID      S              7
&V   D myTrue          S              1    inz('1')
&V   D myFalse         S              1    inz('0')
&V   D svin13          S              1    inz('0')
&V   D afsactive       S              1    inz('N')
&V   D afsauto         S              1    inz('N')
&V   D afspop          S              1    inz('N')
&V   D afsorderid      S             10
&V   D afsshipc        S                   like(arcdc6)
&V   D woeno08         S              3
&V   D btemail         s             45
&V   D bremail         s             45
&V   D prodTest        S             10    inz(*blanks)
&V   D Apos            s              1a   inz('''')
&V   D myURL           S           1000    inz(*blanks)
&V   D MG06EV          S              1    inz(*blanks)
      *
Q4   D procWorkOrders  pr                  extpgm('WKR3001')
Q4   D                                1
Q4   D                                2
Q4   D                                2
Q4   D                              256
Q4   D                               29
Q4    *
     D                SDS
     D  PROG                   1      8
     D  DSPERR                91    160
     D  USRNM                254    263
     D  WSNAME               244    252
     D  JOBNME               244    253
     D  JOBNUM               264    269  0
     D                 DS
     D  NO03                   1     30
     D  TB1                    1      3
     D  TB2                    4     29
     D  TB3                   30     30
     D ADDON           DS
     D  RC                     1      1
     D  WOSYS                  2      2
     D  WHMYES                 3      3
     D  PFSYS                  6      6
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
     D                 DS                  INZ
     D  ARMO05                 1      2  0
     D  ARDY05                 3      4  0
     D  ARYR05                 5      6  0
     D  DATORD                 1      6  0
T4   D                 DS                  INZ
T4   D  MARYR05                1      2  0
T4   D  MARMO05                3      4  0
T4   D  MARDY05                5      6  0
T4   D  DATEORD                1      6  0
T4   D                 DS                  INZ
T4   D  TOYEAR                 1      2  0
T4   D  TOMONTH                3      4  0
T4   D  TODAY                  5      6  0
T4   D  CMPTODAY               1      6  0
     D                 DS                  INZ
     D  SVMO05                 1      2  0
     D  SVDY05                 3      4  0
     D  SVYR05                 5      6  0
     D  SAVORD                 1      6  0
     D                 DS                  INZ
     D  ARMO06                 1      2  0
     D  ARDY06                 3      4  0
     D  ARYR06                 5      6  0
     D  DATSHP                 1      6  0
     D                 DS                  INZ
     D  SVMO06                 1      2  0
     D  SVDY06                 3      4  0
     D  SVYR06                 5      6  0
     D  SAVSHP                 1      6  0
     D                 DS
     D  IVMO02                 1      2  0
     D  IVDY02                 3      4  0
     D  IVYR02                 5      6  0
     D  DATOUT                 1      6  0
#10  D                 DS
#10  D  ENTER_CC               1      2  0
#10  D  ENTER_YR               3      4  0
#10  D  ENTER_MO               5      6  0
#10  D  ENTER_DY               7      8  0
#10  D  ENTER_DT               1      8  0
#I   D                 DS                  INZ
#I   D  tcy                    1      2  0
#I   D  tyr                    3      4  0
#I   D  tcyyr                  1      4  0
#I   D  tmo                    6      7  0
#I   D  tdy                    9     10  0
#I   D  DateInCymd             1     10d
     D                 DS
     D  OAPC1                  1      2
     D  OAPC2                  4      5
     D  OAPC3                  7      8
     D  OAPC01                 1      8
     D ZZNO04          DS
     D  NSCDE                  1      1
     D  SEC                    2      4
     D  NSITM                  5     12
$4   D  IQSRCH                 2     15
     D PRT             DS
     D  NSI                    5     12
     D                 DS
     D  SUB                    1      1
     D  ASS                    2      2
     D  COM                    3      3
     D  PRCQ                   4      4
     D  EXSTRS                 5      5
   ¢*D* SAC                    1      5
¢*   D  B2BLINK                6      6
¢*   D  SAC                    1      6
     D                 DS
     D  WBO                    1      1
     D  CHKSTK                 1      1
     D  WPR                    3      5
     D  TBNO03                 1     30
     D                 DS
     D  OPNPRT                 1      1
     D  PNDPRT                 2      2
     D  RESPRT                 3      3
     D  QTEPRT                 4      4
     D  PRTCTL                 1      4
     D FIL1DS          DS
     D  SCREEN               261    268
     D  C@LOC                370    371B 0
     D  CPFRRN               378    379B 0
     D                 DS                  INZ
     D  REGMIN                 1      3  0
     D  REGMAX                 4      6  0
     D  RMNMX                  1      6
     D                 DS                  INZ
     D  DIRMIN                 1      3  0
     D  DIRMAX                 4      6  0
     D  DMNMX                  1      6
     D                 DS
     D  USE$                   1      4
     D  USEA$                  1      1
     D  USEB$                  2      2
¢A5  D PERZIP          DS
¢A5  D  pzflg                  1      1
     D CTLFMT          DS                  INZ
     D  ARNM01                 1     30
     D  ARNO07                31     32P 0
     D  ARNO08                33     34P 0
     D  ARNO09                35     37P 0
     D  ARZP15                38     47
     D  ARNO01                48     51P 0
     D  OENO06                52     58
     D  OENM02                59     73
     D  OENM15                74    103
     D  OENO07               104    125
     D  OECD03               126    126
     D  PRTTYP               127    127
     D  OECD01               128    128
     D  OEDN01               129    143
     D  OECD32               144    144
     D  SHPCOD               145    146
TN   D  OECD08               147    147
     D SAVCTL          DS                  INZ
     D  CTNM01                 1     30
     D  CTNO07                31     32P 0
     D  CTNO08                33     34P 0
     D  CTNO09                35     37P 0
     D  CTZP15                38     47
     D  CTNO01                48     51P 0
     D  CTNO06                52     58
     D  CTNM02                59     73
     D  CTNM15                74    103
     D  CTPONO               104    125
     D  CTCD03               126    126
     D  CTLTYP               127    127
     D  CTCD01               128    128
     D  CTDN01               129    143
     D  CTCD32               144    144
     D  CTLSCD               145    146
TN   D  CTCD08               147    147
     D SAVDS           DS                  OCCURS(400)
     D  ORDQTY                 1      7  0
     D  ORDITM                 8     37
     D  ORDSHP                38     44  0
     D  ORDBKO                45     51  0
     D  ORDDSC                52     86
   SXD* ORDAM1                87     93  2
   SXD* ORDAM2                94    100  2
   SXD* ORDPC1               101    108
   SXD* ORDICT               109    109
   SXD* ORDDN2               110    112
   SXD* ORDNO7               113    118  0
   SXD* ORDC26               119    119
   SXD* ORDC28               120    120
   SXD* ORDDN4               121    123
   SXD* ORDAM5               124    132  2
   SXD* ORDSEL               133    133
   SXD* ORDBRA               134    134
   SXD* ORDSTK               135    135
   SXD* ORDQY                136    142  0
   SXD* ORDSEC               143    143
   SXD* ORDCMP               147    147
   SXD* ORDCQY               148    152  0
   SXD* ORDALI               153    153
   SXD* ORDSR#               154    154
   SXD* ORRSN                155    155
   SXD* ORAFIV               156    156
   SXD* ORTAG#               157    165
   SXD* ORDSEQ               166    168  0
   SXD* ORTSEQ               169    171  0
   SXD* ORTXCD               172    172
   SXD* ORDOAL               173    177  0
   SXD* DSBOOK               178    178
   SXD* ORDBQY               179    185  0
   SXD* ORDBOQ               186    192  0
   SXD* ORDDFT               193    193
   SXD* ORDSBR               194    196  0
   SXD* ORDDIR               197    197
   SXD* ORDSVB               198    200  0
   SXD* ORDSVD               201    201
   SXD* ORDBO$               202    210  2
   SXD* ORDCO$               211    219  2
   SXD* ORCOTX               220    220
   SXD* ORDBDL               221    225  0
   SXD* ORDF43               226    226
   SXD* ORDSAC               227    231
   SXD* ORDPR#               232    238
   SXD* ORDPC7               247    249  1
   SXD* ORDSV7               250    252  1
   SXD* ORDC66               253    253
   SXD* ORDQ14               254    260  0
   SXD* ORDQ15               261    267  0
   SXD* ORDQ16               268    274  0
   SXD* ORAM38               293    303  5
   SXD* ORAM39               304    314  5
   SXD* ORAM40               315    325  5
   SXD* ORAM41               326    336  5
   SXD* ORAM42               337    347  5
   SXD* ORDUM                348    350
   SXD* ORSALT               351    351
   SXD* ORSORD               352    352
   SXD* DSAVL                353    359  0
   SXD* ORDP22               360    362  0
   SXD* ORDP23               363    365  0
   SXD* ORDP24               366    368  0
   SXD* ORDP25               369    371  0
   SXD* ORDERR               372    372
   SXD* ORDC27               373    373
   SXD* SAVAM1               374    380  2
   SXD* SAVPC1               381    388
   SXD* ORNTSL               389    399  5
   SXD* ORCREF               400    400
   SXD* ORSVPR               401    411  5
   SXD* DSVCAT               412    412
   RND* ORDRO#               413    419  0
RN SXD* ORDRO#               413    419
   SXD* ORDRL#               420    422  0
   SXD* ORDRTP               423    424
   SXD* ORDLOU               425    454
   SXD* ORGPPC               455    458  1
   SXD* ORDTBR               459    461  0
   SXD* ORDSVT               462    464  0
   SXD* ORSV43               465    465
   SXD* ORDC$B               466    474  2
   SXD* WT01                 475    485  4
   SXD* ORNSA                486    486
   SXD* QCHK                 487    487
   SXD* SENO22               488    493
   SXD* ORDC72               494    494
   SXD* ORNO56               495    499  0
   SXD* ORDPO#               500    506  0
   SXD* ORDPN5               507    509  0
   SXD* ORDSHQ               510    516  0
   SXD* SRANBR               517    536
   SXD* SRAREQ               537    537
   SXD* SVRREQ               538    538
   SXD* ORPFCT               539    552  9
   SXD* OROFCT               553    566  9
   SXD* ORDTNO               567    573  0
   SXD* SAVCON               574    580  0
   SXD* ORDLOT               581    581
   SXD* ORDREQ               582    582
   SXD* ORLENT               583    583
   SXD* ORDTMP               584    588  0
   SXD* ORMHCD               589    589
   SXD* SRACHK               590    590
   RND* ORDAO#               594    600  0
RN SXD* ORDAO#               594    600
   SXD* ORDAL#               601    605  0
   SXD* SNTCHK               606    606
Q4 SXD* ordWoNbr             607    613
Q4 SXD* ordWolin             614    617  0
SX   D  ORDAM1                87     94  2
SX   D  ORDAM2                95    101  2
SX   D  ORDPC1               102    109
SX   D  ORDICT               110    110
SX   D  ORDDN2               111    113
SX   D  ORDNO7               114    119  0
SX   D  ORDC26               120    120
SX   D  ORDC28               121    121
SX   D  ORDDN4               122    124
SX   D  ORDAM5               125    133  2
SX   D  ORDSEL               134    134
SX   D  ORDBRA               135    135
SX   D  ORDSTK               136    136
SX   D  ORDQY                137    143  0
SX   D  ORDSEC               144    144
SX   D  ORDCMP               148    148
SX   D  ORDCQY               149    153  0
SX   D  ORDALI               154    154
SX   D  ORDSR#               155    155
SX   D  ORRSN                156    156
SX   D  ORAFIV               157    157
SX   D  ORTAG#               158    166
SX   D  ORDSEQ               167    169  0
SX   D  ORTSEQ               170    172  0
SX   D  ORTXCD               173    173
SX   D  ORDOAL               174    178  0
SX   D  DSBOOK               179    179
SX   D  ORDBQY               180    186  0
SX   D  ORDBOQ               187    193  0
SX   D  ORDDFT               194    194
SX   D  ORDSBR               195    197  0
SX   D  ORDDIR               198    198
SX   D  ORDSVB               199    201  0
SX   D  ORDSVD               202    202
SX   D  ORDBO$               203    211  2
SX   D  ORDCO$               212    220  2
SX   D  ORCOTX               221    221
SX   D  ORDBDL               222    226  0
SX   D  ORDF43               227    227
SX ¢*D* ORDSAC               228    232
SX   D  ORDPR#               233    239
SX   D  ORDPC7               248    250  1
SX   D  ORDSV7               251    253  1
SX   D  ORDC66               254    254
SX   D  ORDQ14               255    261  0
SX   D  ORDQ15               262    268  0
SX   D  ORDQ16               269    275  0
SX   D  ORAM38               294    304  5
SX   D  ORAM39               305    315  5
SX   D  ORAM40               316    326  5
SX   D  ORAM41               327    337  5
SX   D  ORAM42               338    348  5
SX   D  ORDUM                349    351
SX   D  ORSALT               352    352
SX   D  ORSORD               353    353
SX   D  DSAVL                354    360  0
SX   D  ORDP22               361    363  0
SX   D  ORDP23               364    366  0
SX   D  ORDP24               367    369  0
SX   D  ORDP25               370    372  0
SX   D  ORDERR               373    373
SX   D  ORDC27               374    374
SX   D  SAVAM1               375    382  2
SX   D  SAVPC1               383    390
SX TAD* ORNTSL               391    401  5
SX TAD* ORCREF               402    402
SX TAD* ORSVPR               403    413  5
SX TAD* DSVCAT               414    414
SX TAD* ORDRO#               415    421
SX TAD* ORDRL#               422    424  0
SX TAD* ORDRTP               425    426
SX TAD* ORDLOU               427    456
SX TAD* ORGPPC               457    460  1
SX TAD* ORDTBR               461    463  0
SX TAD* ORDSVT               464    466  0
SX TAD* ORSV43               467    467
SX TAD* ORDC$B               468    476  2
SX TAD* WT01                 477    487  4
SX TAD* ORNSA                488    488
SX TAD* QCHK                 489    489
SX TAD* SENO22               490    495
SX TAD* ORDC72               496    496
SX TAD* ORNO56               497    501  0
SX TAD* ORDPO#               502    508  0
SX TAD* ORDPN5               509    511  0
SX TAD* ORDSHQ               512    518  0
SX TAD* SRANBR               519    538
SX TAD* SRAREQ               539    539
SX TAD* SVRREQ               540    540
SX TAD* ORPFCT               541    554  9
SX TAD* OROFCT               555    568  9
SX TAD* ORDTNO               569    575  0
SX TAD* SAVCON               576    582  0
SX TAD* ORDLOT               583    583
SX TAD* ORDREQ               584    584
SX TAD* ORLENT               585    585
SX TAD* ORDTMP               586    590  0
SX TAD* ORMHCD               591    591
SX TAD* SRACHK               592    592
SX TAD* ORDAO#               596    602
SX TAD* ORDAL#               603    607  0
SX TAD* SNTCHK               608    608
SX TAD* ordWoNbr             609    615
SX TAD* ordWolin             616    619  0
SX TAD* PRCOVRFLW            620    620                                         Ext Prc Ovr Flow
TA   D  ORNTSL               391    402  5
TA   D  ORCREF               403    403
TA   D  ORSVPR               404    414  5
TA   D  DSVCAT               415    415
TA   D  ORDRO#               416    422
TA   D  ORDRL#               423    425  0
TA   D  ORDRTP               426    427
TA   D  ORDLOU               428    457
TA   D  ORGPPC               458    461  1
TA   D  ORDTBR               462    464  0
TA   D  ORDSVT               465    467  0
TA   D  ORSV43               468    468
TA   D  ORDC$B               469    477  2
TA   D  WT01                 478    488  4
TA   D  ORNSA                489    489
TA   D  QCHK                 490    490
TA   D  SENO22               491    496
TA   D  ORDC72               497    497
TA   D  ORNO56               498    502  0
TA   D  ORDPO#               503    509  0
TA   D  ORDPN5               510    512  0
TA   D  ORDSHQ               513    519  0
TA   D  SRANBR               520    539
TA   D  SRAREQ               540    540
TA   D  SVRREQ               541    541
TA   D  ORPFCT               542    555  9
TA   D  OROFCT               556    569  9
TA   D  ORDTNO               570    576  0
TA   D  SAVCON               577    583  0
TA   D  ORDLOT               584    584
TA   D  ORDREQ               585    585
TA   D  ORLENT               586    586
TA   D  ORDTMP               587    591  0
TA   D  ORMHCD               592    592
TA   D  SRACHK               593    593
TA   D  ORDAO#               597    603
TA   D  ORDAL#               604    608  0
TA   D  SNTCHK               609    609
TA   D  ordWoNbr             610    616
TA   D  ordWolin             617    620  0
TA   D  PRCOVRFLW            621    621                                         Ext Prc Ovr Flow
TC   D  INVITM               622    622
TF   D  SUPSEDCHK            623    623
VU   D  DSDNR                624    624
VG   D  bidwods              625    631  0
VQ   D  alwprcchgds                   1
VQ   D  alwcstchgds                   1
VQ   D  itmPrcFlgds                   1
Y3   D  SvOrgAm01                     8  2
Y3   D  SvOrgPc01                     8
Y3   D  SvOrgNet                     11  5
Y3   D  SVACPT_REJ                    1
Y3   D  SvOrgCd26                     1
Y3   D  SvOrgCd28                     1
Y3   D  SvAVQFlg                      1
ZZ   D  itmrlsflgds                   1
ZZ   D  itmascflgds                   1
$T   D  ORDC40                        1
$Y   D  ORDA16                        7  2
¢*   D  ORDSAC                        6
      * IMPORTANT: IF YOU MAKE CHANGES TO SFLDS IN THIS PROGRAM YOU   
      * MUST ALSO MAKE CHANGES TO THE SFLDS IN PROGRAM OER2021 !      
     D SFLDS           DS
     D  OEQY01                 1      7  0
     D  PROD#                  8     37
     D  OEQY03                38     44  0
     D  OEQY02                45     51  0
     D  ITMDSC                52     86
   SXD* AM01                  87     93  2
   SXD* AM02                  94    100  2
   SXD* DISCNT               101    108
   SXD* ITMCAT               109    109
   SXD* DN02                 110    112
   SXD* IVNO7                113    118  0
   SXD* OECD26               119    119
   SXD* OECD28               120    120
   SXD* OEDN04               121    123
   SXD* OEAM05               124    132  2
   SXD* SEL                  133    133
   SXD* BRA                  134    134
   SXD* STK                  135    135
   SXD* STKQTY               136    142  0
   SXD* SECDSC               143    143
   SXD* CMPCHK               147    147
   SXD* CMPQTY               148    152  0
   SXD* ALIAS                153    153
   SXD* SERIL#               154    154
   SXD* REASON               155    155
   SXD* AFTINV               156    156
   SXD* TAG#                 157    165
   SXD* LINSEQ               166    168  0
   SXD* TTGSEQ               169    171  0
   SXD* ITTXCD               172    172
   SXD* OADOAL               173    177  0
   SXD* SFBOOK               178    178
   SXD* BOQTY                179    185  0
   SXD* SAVBOQ               186    192  0
   SXD* BODFT                193    193
   SXD* SFLSBR               194    196  0
   SXD* DIR                  197    197
   SXD* SVB                  198    200  0
   SXD* SVD                  201    201
   SXD* BO$                  202    210  2
   SXD* CO$                  211    219  2
   SXD* COTXCD               220    220
   SXD* BDDOAL               221    225  0
   SXD* CD43                 226    226
   SXD* SACQE                227    231
   SXD* SFLPR#               232    238
   SXD* PC07                 247    249  1
   SXD* SV07                 250    252  1
   SXD* CD66                 253    253
   SXD* OEQY14               254    260  0
   SXD* OEQY15               261    267  0
   SXD* OEQY16               268    274  0
   SXD* OEAM38               293    303  5
   SXD* OEAM39               304    314  5
   SXD* OEAM40               315    325  5
   SXD* OEAM41               326    336  5
   SXD* OEAM42               337    347  5
   SXD* DN4                  348    350
   SXD* SELALT               351    351
   SXD* USEORD               352    352
   SXD* SFAVL                353    359  0
   SXD* PRPC22               360    362  0
   SXD* PRPC23               363    365  0
   SXD* PRPC24               366    368  0
   SXD* PRPC25               369    371  0
   SXD* GPERR                372    372
   SXD* OECD27               373    373
   SXD* SVAM01               374    380  2
   SXD* SVPC01               381    388
   SXD* NETSEL               389    397  4
   SXD* CHKREF               400    400
   SXD* SVPR                 401    411  5
   SXD* SSVCAT               412    412
   RND* RRNO01               413    419  0
RN SXD* RRNO01               413    419
   SXD* RRNO22               420    422  0
   SXD* RELTYP               423    424
   SXD* SFLLO                425    454
   SXD* HGPPCT               455    458  1
   SXD* TBR                  459    461  0
   SXD* SVT                  462    464  0
   SXD* SVCD43               465    465
   SXD* CO$B                 466    474  2
   SXD* ORDWT1               475    485  4
   SXD* NSASS                486    486
   SXD* QTYCHK               487    487
   SXD* EINO22               488    493
   SXD* SAVSHQ               494    500  0
   SXD* RANBR                517    536
   SXD* RAREQ                537    537
   SXD* VRREQ                538    538
   SXD* PRCFCT               539    552  9
   SXD* ORDFCT               553    566  9
   SXD* PONO01               567    573  0
   SXD* PONO05               574    576  0
   SXD* OENO60               577    583  0
   SXD* LOTITM               584    584
   SXD* LOTREQ               585    585
   SXD* LOTENT               586    586
   SXD* TMPLIN               587    591  0
   SXD* RACHK                592    592
   SXD* MHCODE               593    593
   RND* RROA19               594    600  0
RN SXD* RROA19               594    600
   SXD* RRNO31               601    605  0
   SXD* NTCHK                606    606
Q4 SXD* woNbr                607    613
Q4 SXD* woline               614    617  0
SX   D  AM01                  87     94  2
SX   D  AM02                  95    101  2
SX   D  DISCNT               102    109
SX   D  ITMCAT               110    110
SX   D  DN02                 111    113
SX   D  IVNO7                114    119  0
SX   D  OECD26               120    120
SX   D  OECD28               121    121
SX   D  OEDN04               122    124
SX   D  OEAM05               125    133  2
SX   D  SEL                  134    134
SX   D  BRA                  135    135
SX   D  STK                  136    136
SX   D  STKQTY               137    143  0
SX   D  SECDSC               144    144
SX   D  CMPCHK               148    148
SX   D  CMPQTY               149    153  0
SX   D  ALIAS                154    154
SX   D  SERIL#               155    155
SX   D  REASON               156    156
SX   D  AFTINV               157    157
SX   D  TAG#                 158    166
SX   D  LINSEQ               167    169  0
SX   D  TTGSEQ               170    172  0
SX   D  ITTXCD               173    173
SX   D  OADOAL               174    178  0
SX   D  SFBOOK               179    179
SX   D  BOQTY                180    186  0
SX   D  SAVBOQ               187    193  0
SX   D  BODFT                194    194
SX   D  SFLSBR               195    197  0
SX   D  DIR                  198    198
SX   D  SVB                  199    201  0
SX   D  SVD                  202    202
SX   D  BO$                  203    211  2
SX   D  CO$                  212    220  2
SX   D  COTXCD               221    221
SX   D  BDDOAL               222    226  0
SX   D  CD43                 227    227
SX ¢*D* SACQE                228    232
SX   D  SFLPR#               233    239
SX   D  PC07                 248    250  1
SX   D  SV07                 251    253  1
SX   D  CD66                 254    254
SX   D  OEQY14               255    261  0
SX   D  OEQY15               262    268  0
SX   D  OEQY16               269    275  0
SX   D  OEAM38               294    304  5
SX   D  OEAM39               305    315  5
SX   D  OEAM40               316    326  5
SX   D  OEAM41               327    337  5
SX   D  OEAM42               338    348  5
SX   D  DN4                  349    351
SX   D  SELALT               352    352
SX   D  USEORD               353    353
SX   D  SFAVL                354    360  0
SX   D  PRPC22               361    363  0
SX   D  PRPC23               364    366  0
SX   D  PRPC24               367    369  0
SX   D  PRPC25               370    372  0
SX   D  GPERR                373    373
SX   D  OECD27               374    374
SX   D  SVAM01               375    382  2
SX   D  SVPC01               383    390
SX TAD* NETSEL               391    399  4
SX TAD* CHKREF               402    402
SX TAD* SVPR                 403    413  5
SX TAD* SSVCAT               414    414
SX TAD* RRNO01               415    421
SX TAD* RRNO22               422    424  0
SX TAD* RELTYP               425    426
SX TAD* SFLLO                427    456
SX TAD* HGPPCT               457    460  1
SX TAD* TBR                  461    463  0
SX TAD* SVT                  464    466  0
SX TAD* SVCD43               467    467
SX TAD* CO$B                 468    476  2
SX TAD* ORDWT1               477    487  4
SX TAD* NSASS                488    488
SX TAD* QTYCHK               489    489
SX TAD* EINO22               490    495
SX TAD* SAVSHQ               496    502  0
SX TAD* RANBR                519    538
SX TAD* RAREQ                539    539
SX TAD* VRREQ                540    540
SX TAD* PRCFCT               541    554  9
SX TAD* ORDFCT               555    568  9
SX TAD* PONO01               569    575  0
SX TAD* PONO05               576    578  0
SX TAD* OENO60               579    585  0
SX TAD* LOTITM               586    586
SX TAD* LOTREQ               587    587
SX TAD* LOTENT               588    588
SX TAD* TMPLIN               589    593  0
SX TAD* RACHK                594    594
SX TAD* MHCODE               595    595
SX TAD* RROA19               596    602
SX TAD* RRNO31               603    607  0
SX TAD* NTCHK                608    608
SX TAD* woNbr                609    615
SX TAD* woline               616    619  0
TA   D  NETSEL               391    400  4
TA   D  CHKREF               403    403
TA   D  SVPR                 404    414  5
TA   D  SSVCAT               415    415
TA   D  RRNO01               416    422
TA   D  RRNO22               423    425  0
TA   D  RELTYP               426    427
TA   D  SFLLO                428    457
TA   D  HGPPCT               458    461  1
TA   D  TBR                  462    464  0
TA   D  SVT                  465    467  0
TA   D  SVCD43               468    468
TA   D  CO$B                 469    477  2
TA   D  ORDWT1               478    488  4
TA   D  NSASS                489    489
TA   D  QTYCHK               490    490
TA   D  EINO22               491    496
TA   D  SAVSHQ               497    503  0
TA   D  RANBR                520    539
TA   D  RAREQ                540    540
TA   D  VRREQ                541    541
TA   D  PRCFCT               542    555  9
TA   D  ORDFCT               556    569  9
TA   D  PONO01               570    576  0
TA   D  PONO05               577    579  0
TA   D  OENO60               580    586  0
TA   D  LOTITM               587    587
TA   D  LOTREQ               588    588
TA   D  LOTENT               589    589
TA   D  TMPLIN               590    594  0
TA   D  RACHK                595    595
TA   D  MHCODE               596    596
TA   D  RROA19               597    603
TA   D  RRNO31               604    608  0
TA   D  NTCHK                609    609
TA   D  woNbr                610    616
TA   D  woline               617    620  0
TF TJD* supsedchkd           621    621
TJ   D  OVRFLW               621    621                                         Ext Prc Ovr Flow
TJ   D  SINVITM              622    622
TJ   D  supsedchkd           623    623
VU   D  SFDNR                624    624
VG   D  bidwo                625    631  0
VQ   D  alwprcchg                     1
VQ   D  alwcstchg                     1
VQ   D  itmPrcFlg                     1
Y3   D  OrgAm01                       8  2
Y3   D  OrgPc01                       8
Y3   D  OrgNet                       11  5
Y3   D  SfAcpt_Rej                    1
Y3   D  OrgCd26                       1
Y3   D  OrgCd28                       1
Y3   D  AVQFlg                        1
ZZ   D  itmrlsflg                     1
ZZ   D  itmascflg                     1
$T   D  OECD40                        1
$Y   D  AM16                          7  2
¢*   D  SACQE                         6
      * IMPORTANT: IF YOU MAKE CHANGES TO SFLDS IN THIS PROGRAM YOU   
      * MUST ALSO MAKE CHANGES TO THE SFLDS IN PROGRAM OER2021 !      
     D PRCDS           DS                  OCCURS(400)
     D  PRITM                  1      6  0
     D  PRUOM                  7      9
     D  PRQTY                 10     16  0
     D  PRTYP                 17     17
   SXD* PRPRC                 18     24  2
   SXD* PRCST                 25     31  2
   SXD* PRDSC                 32     39
   SXD* PREXT                 40     48  2
   SXD* PRCSH#                49     55
   SXD* PRTRM                 56     58  1
   SXD* PROVR                 59     59
   SXD* PRSHPB                60     62  0
   SXD* PRCSTS                63     63
   SXD* PRPRCS                64     64
SX   D  PRPRC                 18     25  2
SX   D  PRCST                 26     32  2
SX   D  PRDSC                 33     40
SX   D  PREXT                 41     49  2
SX   D  PRCSH#                50     56
SX   D  PRTRM                 57     59  1
SX   D  PROVR                 60     60
SX   D  PRSHPB                61     63  0
SX   D  PRCSTS                64     64
SX   D  PRPRCS                65     65
SD   D  prWoNbr                       7s 0 inz
$T   D  PRDSCS                        1A
     D COMBO           DS                  OCCURS(57)
     D  CIITM                  1      6  0
     D  CIUOM                  7      9
     D  CIQTY                 10     16  0
     D  CITYP                 17     17
   SXD* CIPRC                 18     24  2
   SXD* CICST                 25     31  2
   SXD* CIDSC                 32     39
   SXD* CIEXT                 40     48  2
   SXD* CICSH#                49     55
   SXD* CITRM                 56     58  1
   SXD* CIOVR                 59     59
   SXD* CISHPB                60     62  0
   SXD* CICSTS                63     63
   SXD* CIPRCS                64     64
   SXD* CIPDDS                65    112
   SXD* CIKID                113    115  0
   SXD* CIKLC#               116    120  0
   SXD* CIPID                121    123  0
   SXD* CIPLC#               124    128  0
   SXD* CINCI                129    129
   SXD* CICD84               130    130
   SXD* CICD47               131    131
   SXD* CIPN01               132    138  0
   SXD* CIPN05               139    141  0
   SXD* CIIEX                142    142
   SXD* CIQ11                143    149  0
   SXD* CIQ13                150    156  0
   SXD* CINSA                157    157
   SXD* CICD28               158    158
   SXD* CIVSC                159    218
   SXD* CISAC                219    220
SX   D  CIPRC                 18     25  2
SX   D  CICST                 26     32  2
SX   D  CIDSC                 33     40
SX   D  CIEXT                 41     49  2
SX   D  CICSH#                50     56
SX   D  CITRM                 57     59  1
SX   D  CIOVR                 60     60
SX   D  CISHPB                61     63  0
SX   D  CICSTS                64     64
SX   D  CIPRCS                65     65
SX   D  CIPDDS                66    113
SX   D  CIKID                114    116  0
SX   D  CIKLC#               117    121  0
SX   D  CIPID                122    124  0
SX   D  CIPLC#               125    129  0
SX   D  CINCI                130    130
SX   D  CICD84               131    131
SX   D  CICD47               132    132
SX   D  CIPN01               133    139  0
SX   D  CIPN05               140    142  0
SX   D  CIIEX                143    143
SX   D  CIQ11                144    150  0
SX   D  CIQ13                151    157  0
SX   D  CINSA                158    158
SX   D  CICD28               159    159
SX   D  CIVSC                160    219
SX   D  CISAC                220    221
VQ   D  CIprcchg                      1
VQ   D  CIcstchg                      1
:J
:J   D dsCM57          DS
:J   D  CM57                          9a
:J   D   OpenCM                       1a   overlay(CM57)
:J   D   VoidCM                       1a   overlay(CM57:*next)
:J   D   PrintCM                      1a   overlay(CM57:*next)
:J   D   ReviewCM                     1a   overlay(CM57:*next)
:J   D   Space                        1a   overlay(CM57:*next)
:J   D   CreateVR                     1a   overlay(CM57:*next)
:J   D   ShpCfmVR                     1a   overlay(CM57:*next)
:J   D   CloseWC                      1a   overlay(CM57:*next)
:J   D   UpdStsWC                     1a   overlay(CM57:*next)
:J
     D                 DS
     D  GENPOS                15     15
     D  TFRGEN                16     16
     D  SEE$                  17     17
     D  DSPTRM                18     18
     D  CHGMOP                21     21
     D  CRDANA                23     23
     D  ENTBYI                26     28
     D  PROHIB                 1     28
     D                 DS
     D  GENDIR                 1      1
     D  GENBOS                 2      2
     D  POAUTH                 1      2
     D                 DS
     D  ISTS                   1      1
     D  BSTS                   2      2
     D  SHPDAT                 3      3
   RBD* REQSR#                 4      4
     D  OPT5                   5      5
     D  OPT6                   6      6
     D  OPT7                   7      7
     D  OPT8                   8      8
     D  DFTBOQ                11     11
     D  RESET1                12     12
     D  RESET2                13     13
     D  WLKBAS                16     16
   RND* LOW                   17     23  0
   RND* HIGH                  24     30  0
RN   D  LOW                   17     23
RN   D  HIGH                  24     30
     D  OPTS                   1     30
     D                 DS
     D  ADDLOT                 6      6
     D  AFCRED                11     11
     D  NOTCTL                15     15
     D  ADDBCK                16     16
     D  RSVENT                18     18
     D  WIACTR                19     19
VQ   D  WlkPrcFlg             21     21
0F   D  ImmInvTkt             22     22
     D  OPTS2                  1     30
RB   D                 DS
RB   D  SRLSET                 1     30
RB   D  SKIP_SRL               1      1
RV   D  SKIP_DSP               2      2
     D                 DS                  INZ
     D  CRHOLD                 1      1
     D  CRCASH                 2      2
     D  OLHOLD                 3      3
     D  OLCASH                 4      4
     D  PCTOVR                 5      8
     D  USEMSG                 9      9
     D  HLDCND                 1      9
     D                 DS                  INZ
     D  FTAXDF                 1      1
     D  DTAXDF                 2      2
     D  HTAXDF                 3      3
     D  RTAXDF                 4      4
     D  OTAXDF                 5      5
     D  TAXOPT                 1      5
     D                 DS                  INZ
     D  DIRCDF                 7      7
     D  OPT2                   1      7
     D OTHCGS          DS                  INZ
     D  FTAXYN                 1      1
     D  DTAXYN                 2      2
     D  HTAXYN                 3      3
     D  RTAXYN                 4      4
     D  OTAXYN                 5      5
     D  DIRCYN                 7      7
     D  FRTAMT                 8     14  2
     D  DELAMT                15     21  2
     D  HANAMT                22     28  2
     D  RESAMT                29     35  2
     D  OTHAMT                36     42  2
     D  FRTDSC                43     62
     D  DELDSC                63     82
     D  HANDSC                83    102
     D  RESDSC               103    122
     D  OTHDSC               123    142
     D  FDSCYN               143    143
     D  DDSCYN               144    144
     D  HDSCYN               145    145
     D  RDSCYN               146    146
     D  ODSCYN               147    147
0E   D  CTAXYN
0E   D  CCPAMT
0E   D  CCPDSC
0E   D  CDSCYN
     D SAVCGS          DS
     D  SVFTAX                 1      1
     D  SVDTAX                 2      2
     D  SVHTAX                 3      3
     D  SVRTAX                 4      4
     D  SVOTAX                 5      5
     D  SVFRT$                 8     14  2
     D  SVDEL$                15     21  2
     D  SVHAN$                22     28  2
     D  SVRES$                29     35  2
     D  SVOTH$                36     42  2
     D  SVFDSC                43     62
     D  SVDDSC                63     82
     D  SVHDSC                83    102
     D  SVRDSC               103    122
     D  SVODSC               123    142
     D  SVFCYN               143    143
     D  SVDCYN               144    144
     D  SVHCYN               145    145
     D  SVRCYN               146    146
     D  SVOCYN               147    147
0E   D  SVCTAX                             like(CTAXYN)
0E   D  SVCCP$                             like(CCPAMT)
0E   D  SVCDSC                             like(CCPDSC)
0E   D  SVCCYN                             like(CDSCYN)
     D OEDS            DS                  OCCURS(50)
     D  QTY                    1      7  0
     D  UOM                    8     10
     D  ITM                   11     40
     D SVOEDS          DS                  OCCURS(50)
     D  QTYSV                  1      7  0
     D  UOMSV                  8     10
     D  ITMSV                 11     40
     D RNSDS           DS                  OCCURS(50)
     D  RNSITM                 1      6  0
     D NOTDS           DS                  OCCURS(98)
     D  ORDNOT                 1     40
     D                 DS
     D  NO07                   1      3  0
     D  NO08                   4      6  0
     D  NO09                   7     10  0
     D  NO0809                 4     10  0
     D                 DS                  INZ
     D  DFTMO                  1      2  0
     D  DFTCC                  3      4  0
     D  DFTYR                  5      6  0
     D  DFTMCY                 1      6  0
     D                 DS                  INZ
     D  CURCY                  1      2  0
     D  CURYY                  3      4  0
     D  CURMO                  5      6  0
     D  CURCC                  7      8  0
     D  CURYR                  9     10  0
     D  CURCYM                 1      6  0
     D  CURMCY                 5     10  0
     D                 DS                  INZ
     D  ARCC01                 1      2  0
     D  ARYR01                 3      4  0
     D  ARMO01                 5      6  0
     D  BILCYM                 1      6  0
     D                 DS                  INZ
     D  DFCC01                 1      2  0
     D  DFYR01                 1      2  0
     D  DFMO01                 3      4  0
     D  DFTCYM                 1      6  0
     D                 DS                  INZ
     D  SVCC01                 1      2  0
     D  SVYR01                 3      4  0
     D  SVMO01                 5      6  0
     D  SAVCYM                 1      6  0
     D                 DS                  INZ
     D  PLS1CC                 1      2  0
     D  PLS1YR                 3      4  0
     D  PLS1MO                 5      6  0
     D  PL1CYM                 1      6  0
     D                 DS                  INZ
     D  MIN1CC                 1      2  0
     D  MIN1YR                 3      4  0
     D  MIN1MO                 5      6  0
     D  MI1CYM                 1      6  0
     D                 DS
     D  WRK1                   1      9  2
     D  WRK1A                  1      9
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
     D SPOEDS          DS                  OCCURS(400)
     D  SPQTY                  1      7  0
     D  SPUOM                  8     10
     D  SPITM                 11     40
     D  CMTCDE                41     41
     D  SPCQTY                42     48  0
     D PARAM           DS
     D  PONUMB                 1      7
     D  POFLAG                 9      9
     D  OACNTL                 1      7
     D  OASELL                 8     10
     D  OASHIP                11     13
     D  OACRED                14     14
     D  OADIRT                15     15
     D  RELORD                16     23
     D  CSNO07                 1      3  0
     D  CSNO08                 4      6  0
     D  CSNO09                 7     10  0
     D  CSNM05                11     30
     D  CSNO01                31     36  0
     D  CSZP03                37     46
     D  CSFLAG                47     47
     D  BIDNUM                47     53
     D  BIDJOB                54     60
     D  POSELL                62     64
     D  POSHIP                65     67
     D  CSAUOM               301    303
   RND* RETRN#               500    506  0
RN XRD* RETRN#               500    506
XR   D  RETRN#               500    507
¢(   D  W_OECD08             985    985                                         B2B Credit Memo
¢(   D  W_OENO14             986    992                                         B2B CC.MEMO ORDER #
QX   D  LDCUSN              1019   1024
     D NSITEM          DS
     D  NSITMN                 1      8
     D NXTTDD          DS
     D  NEXT#                  1      7
¢M   D CRDEML          DS
¢M   D  FLAGYN                 1      1
     D                 DS
     D  COMPNY                 1      3  0
     D  BRNBR                  4      6  0
     D  COBR                   1      6
     D                 DS                  INZ
     D  WMPRM                  1     28
     D  WMPGM                  1      4
     D  WMTRN#                 5     12
     D  WMTAG#                13     15  0
     D  WMCON                 16     18
     D  WMBRN                 19     21
     D  WMITM                 22     28
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
     D                 DS
     D  NBR                    1      3
     D  NBR1                   1      2
      *
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
     D  ARCC12                 1      2  0
     D  ARYR12                 3      4  0
     D  ARMO12                 5      6  0
     D  ARDY12                 7      8  0
     D  DATHLD                 1      8  0
      *
     D WKNO04          DS
     D  ALPHA6                 1      6
     D  LAST6A                 7     12
      *
     D                 DS                  INZ
     D  DATYP                  1      1  0
     D  DATE2                  2      3  0
     D  DATE4                  4      7  0
     D  DATE6                  8     13  0
     D  DATE8                 14     21  0
     D  DACEN                 22     23  0
     D  DS2000                 1     23  0
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
YS   D  FX5                  213    267
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
      *
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
Q4   *
Q4   DinfdsWreq        ds
Q4   D rrnwReq               397    400I 0
Q4   *
Q4   DinfdsWreq1       ds
Q4   D rrnwReq1              397    400I 0
Q4   *
Q4   d infdsToh1       ds
Q4   d  rrnToh1              397    400I 0
Q4   *
     D CLRBAL        E DS                  EXTNAME(ARPMBAL)
     D  CUSNBR       E                     EXTFLD(ARNO01)
     D  CUSCO        E                     EXTFLD(ARNO15)
     D  CUSBRA       E                     EXTFLD(ARNO16)
     D  CUSSLS       E                     EXTFLD(ARID01)
     D  CBAM01       E                     EXTFLD(ARAM01)
     D  BALFLG       E                     EXTFLD(ARFL03)
     D  MO12         E                     EXTFLD(ARMO12)
     D  DY12         E                     EXTFLD(ARDY12)
     D  CC12         E                     EXTFLD(ARCC12)
     D  YR12         E                     EXTFLD(ARYR12)
     D RELMSG          C                   CONST('FROM RSVD ORD')
     D GPOFF           C                   CONST('F19=Hide G/P%')
     D GPON            C                   CONST('F19=Show G/P%')
     D LOTSOK          C                   CONST('L O T S   O K')
ST   D mailmsg         C                   CONST('YOU HAVE NEW MAIL!')
ST   D taskmsg         C                   CONST('YOU HAVE A NEW TASK!')
ST   D urgentmsg       C                   CONST('YOU HAVE URGENT MAIL')
$5   DSMLORDAMT        S              7S 0
      *----------------------------------------------------------------
      *
     D                 DS                  INZ
     D  HDDTA1                 1    256
     D  HDCUS1                 1      6  0
     D  HDJOB1                 7     13
     D                 DS                  INZ
     D  WMDTA1                 1    256
     D  WMBOHC                 1      1
     D                 DS
     D  WMCO                   1      3
     D  WMBR                   4      6
     D  WMITEM                 7     13
     D  WMVEND                14     20
     D  WMUOM                 21     23
     D  PDDS                  24     71
     D  WPRTNM                72     82  0
     D  WPRTCD                73     73
     D  WPTR#                 74     84  0
     D  PRMDTA                 1    256
Q4
Q4   D rtnDta          DS
Q4   D  rtnWkoNum                     7
Q4   D  rtnWkoPrc                    19  9 inz(0)
Q4   D  rtnWkoCst                    19  9 inz(0)
Q4
Q4   d pretcd          s              1
Q4   d pactcd          s              2
Q4   d pfunky          s              2
Q4   d pdata           s            256
Q4   d puser           s             29
Q4   d pWmQty          s             19  9
Q4   d pWmItemNum      s              7  0
Q4   d pHdTransNum     s              7
Q4   d pHdTrans#Cod    s              1
Q4   d pHdNsNum        s             12
Q4   d pHdProdDesc     s             30
Q4   d pHdEntityId     s             20
Q4   d pWoTagLineNum   s              5  0
Q4   d woWarn          s              1
Q4   d genwo           s              1
Q4   d woIndx          s              3  0
Q4   d woBrNbr         s                   like(oeno16)
Q4   d wkoTrnNum       s              7  0
SO   d wkoMaintFlag    s               n
Q4   d so              s              2    inz('SO')
Q4   d wkEnt7          s              7  0 inz
Q4   d wkoDate         s              8
Q4   d fileOpt         s              1
Q4   d fileName        s             10
TF   d rplItm          s              1
TF   d sRetCd          s              1
TF   d sActCd          s              2
TF   d sFunKy          s              2
TF   d sData           s            256
TH   D trannum         s              7A
0P   DPoLat            S              8F
0P   DPoLng            S              8F
WG
WG    * Define the data string written to the clipboard to make all
WG    * line item data available to SmartDistributor.
WG
WG   d ClipBoard       DS                  Qualified
WG ¢*d* Sac                           5
¢*   d  Sac                           6
WG   d  ItemDesc                     50
WG   d  NetPrice                     15
WG   d  ExtPrice                     15
WG
WG   d Oes2020sDS      DS                  LikeRec(OEFW2020S)
WG
WG    * Define the data string returned from hdGetBrItmQty
WG
WG   d BrItemDS        DS                  Qualified
WG   d   qtyonhand                    7s 0 inz(0)
WG   d   qtyallocated                 7s 0 inz(0)
WG   d   qtyreserved                  7s 0 inz(0)
WG   d   qtyTrfOut                    7s 0 inz(0)
WG   d   qtyAvailable                 7s 0 inz(0)
WG   d   qtybackord                   7s 0 inz(0)
WG   d   qtyonorder                   7s 0 inz(0)
WG   d   qtyTrfIn                     7s 0 inz(0)
WG   d   qtyCtrCt                     7s 0 inz(0)
WG
WG   D BrItemParm      S            256a
WG   D PerformChain    S              1a
WG   D gbCount         S              2s 0 inz(0)
WG   D c1head          S             20a
WG   D c1data          S             20a
WG   D c2head          S             20a
WG   D c2data          S             20a
WG
WG   D UVA             S             10    DIM(999)
WG
$9   D TESTN8          S              8A
:J   D Warranty        S              1
:J   D NewStatus       S             10
:J   D TranType        S              1
:J   D QtyErr          S              1
:J   D RWErr           S              1
:J   D RsnErr          S              1
#I   D TodayCYM        S              6s 0
#T   D WUEclaim        S              1    inz('N')
Q4
RE   D WARRANTY_DS     DS                  OCCURS(50)
RE   D  WRNTY_QTY              1      7  0
RE   D  WRNTY_UOM              8     10
RE   D  WRNTY_ITM             11     40
     D PM0810        E DS                  EXTNAME(OPPW810)
Q4
Q4   D ChkSo           DS
Q4   D  sOeNo01                       7
Q4   D  sTransNoKx                    7
Q4   D  sOeCd38                       1
Q4   D  sOeFl04                       1
Q4   D  sOeFl05                       1
Q4
TH   D                 DS
TH   D SRL_FLAGS               1      5    inz(*blanks)
TH   D  RGAFLG                 1      1
$4   D @P@           E DS                  EXTNAME(@PARMSIQ)
$4   D  @P@500               500    500
TO   Dtabdsc           s                   like(tbno03)
TQ    * This DS is used to save unit cost and cost source code for use
TQ    * in  RTNSR routine.
TQ    * When user creates a credit memo, and uses price credit as a
TQ    * reason code, the cost of the item will be made 0 and cost sourc
TQ    * code will be hard coded to 'X'.
TQ    * If the user decides to change the reason code to any other value,
TQ    * the cost of the item and its cost source code will be rolled back
TQ    * to the original values.
TQ    * This DS is used to store the original cost and cost source code
TQ    * of the item, so it can be used to roll back.
TQ   D cstds           ds                  occurs(400)
TQ   D svordam2                            like(ordam2)
TQ   D svoecd27                            like(oecd27)
TQ    * Flags to know whether the reason code is for price credit.
TQ   D prcrflg         s              1
TQ   D svprcfl         s              1
TQ   D prccrdt         s              1
TW   D cmpprcdt        s              1
VF   D svin62          s              1    inz('0')
Y0   D svin69          s              1    inz('0')
Y0   D svin65          s              1    inz('0')
Y0   D svin66          s              1    inz('0')
Y0   D svin82          s              1    inz('0')
ZJ   D svin63          s              1    inz('0')
V4   d woexs           s              1    inz('N')
V4   d cwoexs          s              1    inz('N')
V4   d bwoexs          s              1    inz('N')
WC   d p1300App        s             10    inz('DII')
WC   d p1300Bypass     s              1    inz('N')
WC    *
VR   D taxfaut         s              1
VQ   D prcaut          s              1
VQ   D cusPrcFlg       s              1
VQ   D jobPrcFlg       s              1
VQ   D alwRprc         s              1
VX   D multmg          C                   'Emailing to multiple addresses'
WJ    *
WJ   D                 ds
WJ   D  using_card             1      1
WJ Y0D* card_software          2     30
Y0   D  CARD_SOFTWARE          2     16
ZU   D  card_softtype         17     17
WJ   D  card_tabentry          1     30
WJ    *
WJ   D  meth01         s              1
WJ   D  meth03         s              1
WJ XID* svin58         s              1
XI   D  svin59         s              1
WJ   D  svoeam36       s                   like(oeam36)
WJ    *
WJ    * PiDet to contain values to send to card processing program.
WJ   D  piDet          ds
WJ   D   trantyp                      1    inz('S')
WJ   D   custmr                      10
WJ    * Purchase order as reference transaction
WJ   D   pono#                       22
WJ   D   zipcd                       10
WJ   D   brnch#                       3  0 inz
WJ    * This flag controls display and save of credit card info in
WJ    * Curbstone processing.
WJ   D   dspCrdFlg                    1
Y0    * This param is passed only for interactive refunds, for Curbstone
Y0    * (order/deposit maintenance)
Y0   D   cardtype                     4
Y0    * Device serial number to be sent for CardConnect                e
Y0 0CD*  DevSerial#                  20
0C   D   DevSerial#                        like(varnof5)
ZG   D   JobNumber                    7
ZJ   D   Token                             like(varnof6)
ZJ   D   ExpiryCC                          like(varcc83) inz
ZJ   D   ExpiryYR                          like(varyr83) inz
ZJ   D   ExpiryMO                          like(varmo83) inz
ZJ   D   HldrName                          like(varnm70)
ZJ   D   SaveCard                     1
ZJ   D   DefCard                      1
ZJ   D   Misc                        10
ZR   D   billzp                      10
ZR   D   crdCVV                       4
ZU   D   NetTrnID                          like(varnof8)
ZY   D   TokenSubmted                      like(varcdm3)
WJ    *
WJ Y0 * poData from Curbstone program is parsed as this DS.
Y0    * poData from card processing program is parsed as this DS.
WJ   D authData        DS
WJ ZUD* authLstMFUKEY                15
ZU   D  authLstMFUKEY                      like(varnob7)
WJ   D  authAmt                      11  2 inz
ZU   D  token_added                        like(varnof6)
ZU   D  level3_card                   1
WJ    *
WJ    *----------------------------------------------------------------
WJ Y0 * Parms passed to/from OER9600 program...
Y0    * Parms passed to/from card interface program...
WJ    *.....................................
WJ   D piMode          s              3    inz
WJ   D piRetry         s              1    inz
WJ   D piUpdError      s              1    inz('Y')
WJ   D piTran          s              7    inz
WJ ZUD*piMFUKEY        s             15    inz
ZU   D piMFUKEY        s             19    inz
WJ   D piOrgOrd        s              7    inz
WJ   D piMethod        s              2    inz
WJ   D piTrnDtl        s              1    inz
WJ   D piTrnAmt        s              9  2 inz
WJ   D piTaxable       s              1    inz
WJ   D piTaxAmt        s              9  2 inz
WJ   D poSuccess       s              1    inz
WJ   D poMsg           s             78    inz
WJ   D poData          s            256    inz
WJ   D piData          s            256    inz
WJ   D DiffAmt         s             15  2 inz
WJ   D svaramc7        s                   inz like(Varamc7)
WJ   D wRtnCrd         s              1
WJ   D wPrcSal         s              1
WJ   D c@aprvd         c                   const('Card Processing: Approved.')
WJ   D alwCard         s              1    inz('N')
W2   D sigsmart        s              1    inz
WA   D wAcctErr        s              1
YD   D prvaddovr       s              1    inz
XD    * order being placed on credit hold event
XD   D d_HDE0020       DS           256    inz
XD   D  ordE20                        7a
XD   D  comE20                        3s 0
XD   D  divE20                        3a
XD   D  regE20                        3a
XD   D  sbrE20                        3s 0
XD   D  bnmE20                       25a
XD   D  usrE20                       10a
XD   D  cusE20                        6s 0
XD   D  cnmE20                       30a
XT   D obj             s             10    inz(*blanks)
X0   D kTbl            s                   like(tbno01)
X0   D kDsc            s                   like(tbno03)
X0   D trn_typ         s              3    inz('S/O')
X0   D TaxErr          s              1
X0   D errMsgA         s                    like(errmsg)
X0   D wTaxOvrAmt      s              9  2  inz
X0   D wAPIRqstTyp     s              3
X0   D wTaxTyp         s              5     inz
X0   D coTaxCalType    s              1
X0   D wTempTrans#     s              7     inz
X0   D wTempDocCd      s             26     inz
X0   D othWrn          s              1
X0   D msgdsp          s              1
X0   D mode            s              1
X0   D tabent2         s                    like(tbno03)
X0   D msg9050         s            150
X0   D Errcd           s              1
X0   D Item_totals     s             11s 2 inz
X0   D AvaTaxActive    s              1
X0   D Lower           c                   Const('abcdefghijklmnopqrstuvwxyz')
X0   D Upper           c                   Const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
X0   D wUpdTax$        s              1
X0   D FromWrt         s              1
X0   D wItmQty         s              7  0  inz
X0   D svad04          s                    like(arad04)
X0   D svad05          s                    like(arad05)
X0   D svad06          s                    like(arad06)
X0   D svcy02          s                    like(arcy02)
X0   D svzp16          s                    like(arzp16)
X0   D svst02          s                    like(arst02)
X0   D warnFlg         s              1     inz
XU   DLINEOUT2         S             30
XU   DLINEOUT3         S             30
XU   DLINEOUT4         S             30
XU   DLINEOUT5         S             30
XU   DLineInS2         S             30
XU   DLineInS3         S             30
XU   DLineInSC         S             25
XU   DLineInSS         S              2
XU   DLineInSZ         S             10
YB   D TaxCalcFin      s              1     inz
YB   D TaxCalcSkip     s              1     inz
YB   D @totdsc         c                    const('     Total ')
YB   D @totdscbtax     c                    const('Total B/Tax')
X0   D TaxCalcSkipI    s              1     inz
X0   D wcallAPI        s              1     inz
X0   D wcallAPI_prv    s              1     inz
X0   D wItmDsChg       s              1    inz('N')
X0   D wParmChg        s              1    inz('N')
X0   D wcnt            s              5  0 inz
X0   D wupdtax$_s      s              1
X0   D wupdtax$_o      s              1
X0   D wupdtax$_b      s              1
X0   D wOthChg_ds      ds                  occurs(3)
X0   D wFrtAmt                              like(sifrtamt) inz
X0   D wFrtDesc                             like(sifrtdesc) inz
X0   D wDelAmt                              like(sidelamt) inz
X0   D wDelDesc                             like(sideldesc) inz
X0   D wHdlAmt                              like(sihdlamt) inz
X0   D wHdlDesc                             like(sihdldesc) inz
X0   D wRstAmt                              like(sirstamt) inz
X0   D wRstDesc                             like(sirstdesc) inz
X0   D wOthAmt                              like(siothamt) inz
X0   D wOthDesc                             like(siothdesc) inz
0E   D wCCPAmt                              like(siccpamt) inz
0E   D wCCPDesc                             like(siccpdesc) inz
X0   D wTax_Ds         ds                  occurs(3)
X0   D wTaxAmt                              like(pTaxAmt) inz
X0   D wTaxRate                             like(pTaxRate) inz
X0   D wPstAmt                              like(pPstAmt) inz
X0   D wPstRate                             like(pPstRate) inz
X0   D wHstAmt                              like(pHstAmt) inz
X0   D wHstRate                             like(pHstRate) inz
X0   D wGstAmt                              like(pGstAmt) inz
X0   D wGstRate                             like(pGstRate) inz
X0   D wTaxableamt                          like(pTaxableAmt) inz
X0   D wNTaxableamt                         like(pNTaxableAmt) inz
X0   D pTax_saveItems  ds                  occurs(11000)
X0   D  Sav_ItmLinNum          1      5
X0   D  Sav_ItmNumber          6     35
X0   D  Sav_OrdQty            36     46  4
X0   D  Sav_ExtAmt            47     55  2
X0   D  Sav_ItmDesc           56    103
X0   D  Sav_ItmType          104    104
X0   D  Sav_ItmTaxCod        105    129
X0   D pTax_saveship   ds                  occurs(11000)
X0   D  S_Sav_ItmLin           1      5
X0   D  S_Sav_ItmNumb          6     35
X0   D  S_Sav_OrdQty          36     46  4
X0   D  S_Sav_ExtAmt          47     55  2
X0   D  S_Sav_ItmDesc         56    103
X0   D  S_Sav_ItmType        104    104
X0   D S_Sav_ItmTaxCd        105    129
X0   D pTax_saveordr   ds                  occurs(11000)
X0   D  O_Sav_ItmLin           1      5
X0   D  O_Sav_ItmNumb          6     35
X0   D  O_Sav_OrdQty          36     46  4
X0   D  O_Sav_ExtAmt          47     55  2
X0   D  O_Sav_ItmDesc         56    103
X0   D  O_Sav_ItmType        104    104
X0   D O_Sav_ItmTaxCd        105    129
X0   D pTax_savebo     ds                  occurs(11000)
X0   D  B_Sav_ItmLin           1      5
X0   D  B_Sav_ItmNumb          6     35
X0   D  B_Sav_OrdQty          36     46  4
X0   D  B_Sav_ExtAmt          47     55  2
X0   D  B_Sav_ItmDesc         56    103
X0   D  B_Sav_ItmType        104    104
X0   D B_Sav_ItmTaxCd        105    129
X0    *
X0   D siMisc          ds            10
X0   D siHdrTaxFlag                   1    overlay(simisc:1)
X0    *
X0   D siNumOfItems    s              5  0
X0   D sCustomerCode   s             30
X0   D sMode           s              1
X0   D sDocCode        s             30
X0   D sDocType        s              1  0
X0   D sDocDate        s              8
X0   D sOrgOrder       s              7
X0   D sSellBr         s              3
X0   D sShipFromBr     s              3
X0   D sDAddress1      s             30
X0   D sDAddress2      s             30
X0   D sDAddress3      s             30
X0   D sDCity          s             25
X0   D sDState         s              2
X0   D sDCountry       s             30
X0   D sDZipCode       s             10
X0   D sCommitTran     s              1
X0   D sTaxRate        s              6  6
X0   D sTaxAmt         s              9  2
X0   D sGstRate        s              6  6
X0   D sGstAmt         s              9  2
X0   D sHstRate        s              6  6
X0   D sHstAmt         s              9  2
X0   D sPstRate        s              6  6
X0   D sPstAmt         s              9  2
X0   D sTaxableAmt     s              9  2
X0   D sNTaxableAmt    s              9  2
X0   D sErrCode        s             50
X0   D sErrMsg         s            150
X0   D siPgmName       s             10
X0   D siHdrUpd        s              1
X0   D siAPIRqstTyp    s              3
X0   D siBillType      s              2
X0   D siCustNum       s              6  0
X0   D siFrtAmt        s              7  2
X0   D siFrtDesc       s             20
X0   D siDelAmt        s              7  2
X0   D siDelDesc       s             20
X0   D siHdlAmt        s              7  2
X0   D siHdlDesc       s             20
X0   D siRstAmt        s              7  2
X0   D siRstDesc       s             20
X0   D siOthAmt        s              7  2
X0   D siOthDesc       s             20
X0   D siTaxSts        s              2
X0   D siTaxErrCd      s              2
X0   D siTranNum       s              7
X0   D siTranType      s              3
X0   D sJobNum         s              7
X0   D siUpdTax        s              1
X0   D siTaxOvrAmt     s              9  2  inz
X0   D sCustPoNum      s             22
YM   D FrcTaxCalc      s              1     inz
X0    *
YK   D pCompanyCode    s             30
YK   D pCancelCode     s              1  0
YK   D PoErrMsg        s            150
YT   D PoDocSts        s             15
YT   D PoTotAmt        s              9  2
YT   D PoTotNonTax     s              9  2
YT   D PoTotTax        s              9  2
YT   D PoTotTaxble     s              9  2
YT   D PoTaxOvrAmt     s              9  2
YT   D PoTaxDetail     DS                  OCCURS(20)
YT   D  PoTaxJurName           1     30
YT   D  PoTaxRate             31     40  6
YT   D  PoTaxAmount           41     50  2
ZN   D  PoTaxableAmt          51     60  2
ZB   D ordbyreq        s              1    inz('N')
ZJ   D COF_Mode        S              1
ZJ   D Cust_Type       S              1
ZJ   D Cust_Num        S                   like(arno01)
ZJ   D PoToken         S                   like(varnof6)
ZJ   D PoExpcc         S                   like(varcc83)
ZJ   D PoExpyr         S                   like(varyr83)
ZJ   D PoExpmo         S                   like(varmo83)
ZJ   D PoNAME          S                   like(varnm70)
ZU   D PoNetTrnID      S                   like(arnof8)
ZU   D NegQty_flag     S              1
ZY   D PoTokenSubmted  S                   like(arcdm3)
ZJ   D cdf4            S                   like(arcdf4)
ZJ   D kfla5           S                   like(arfla5)
ZZ   D ELSXRLS         S              1
ZZ   D ELSXASC         S              1
Y2    * ---------------------------------------------------------------
Y2    * HDE0060 Event Data/Filter
Y2    * ---------------------------------------------------------------
Y2   D d_hde0060       ds           256    inz
Y2   D  hbranch                       3  0
Y2   D  huser                        10a
Y2   D  hTrans                        7a
Y2   D  hcust#                        6a
Y2   D  hcustname                    30a
Y2   D  hbatch#                       5a
Y2   D  hrun#                         7a
Y2   D  heventtype                    1a
Y2   D  htrantype                     1a
Y0    * ---------------------------------------------------------------
Y0    * HDE0056 Event Data/Filter
Y0    * ---------------------------------------------------------------
Y0   D d_hde0056       ds           256    inz
Y0   D  wbranch                       3  0
Y0   D  wuser                        10a
Y0   D  transtyp                      1a
Y0   D  transe                        7a
Y0   D  trans2                        7a
Y0   D  wcust#                        6a
Y0   D  custname                     30a
Y0   D  eventtype                     1a
#L   D                 DS
#L   D  PL2024                 1     17
#L   D  ORDBR                  1     10
#L   D  PICSEQ                16     16
Y0    *
Y0   D kDevName        s                   like(arnm71)
Y0   D card_interface  s              1    inz(' ')
Y0   D save_curbston   s              1    inz(' ')
Y0   D save_interface  s              1    inz(' ')
Y0   D wNetErr         s              3  0
Y0   D c@Neterr        c                   const('SEND/RECEIVE ERROR')
Y0   D dTyp            s              1
Y0   Dinfo_msg         s             78
Y2   D wDefTax         s              1
Y2   D save_no24       s                   like(oeno24)
Y2   D save_pc02       s                   like(oepc02)
Y2   D taxneterr       s              1
Y2   D save_avatax     s              1
Y3   D prcautreqapv    s              1    inz
Y3   D prcautcanapv    s              1    inz
Y3   D overridereject  s              1    inz
Y3   D from2020        s              1    inz
Y3   D ovrordr         s                   like(OENO01) inz
Y4   D OE_OrdBy        s              1    Inz
ZC   D authqty         s              1    inz
ZR   D usingAVS        s             10
ZR   D usingCVV        s             10
ZI    *------------------------------------------------------------------------*
ZI   D dsItemsCount    s             10  0 inz(%elem(dsItems))
ZI   D rowcount        s             10  0 inz
ZI   D lastrow         s             10  0 inz
ZI   D ii              s             10  0 inz
ZI   D importCount     s             10  0 inz
ZI   D #jobNbr         s              6  0 inz
ZI
ZI   D dSItems         ds                  inz qualified dim(200)
ZI   D  wLineType                     1a
ZI ZOD* wOrderQty                     3  0
ZO   D  wOrderQty                     7  0
ZI   D  wPdds                        50a
ZI   D  wPrice                        9  2
ZI   D  wUOM                          3a
ZI   D  wbranchNo                     3  0
ZI
ZI   D dSItem          ds                  inz qualified
ZI   D  iProduct                           like(zzno04)
ZI   D  iQty                               like(oeqy01)
ZI   D  iDesc                              like(zzdn01)
ZI   D  iUOM                               like(oedn04)
Z3   D AddOn_OvrPct    S              4  3 inz
ZV
ZV   D                 ds                  inz
ZV   D ELSALL                  1      3a
ZV   D ELSF3F5                 1      1a
ZV   D ELSRMV                  2      2a
ZV   D ELSSUB                  3      3a
0A   D DEPWDW          s              1    inz
0A   D DEPWDWDSPD      s              1    inz
:D    * Order Fulfillment
:D   d WrkPgm          s             10a   Inz('OER2020')
:D   d WrkDFNO15       s              3s 0 Inz
:D   d WrkOENO08       s              3s 0 Inz
:D   d WrkOECD01       s              1a   Inz
:D   d WrkARCDC6       s              2a   Inz
:D   D Wrk_FL          s               n
$9   D UP              C                   CONST('ABCDEFGHIJKLMNOPQRS-
$9   D                                     TUVWXYZ')

&V
&V   d $command        pr                  extpgm('QCMDEXC')
&V   d   command                   1000
&V   d   Length                      15  5
&V   d commandString   s           1000    inz
&V   d commandLength   s             15  5 inz
&V
&V     // create a pending order
&V     dcl-pr createPendingOrder EXTPGM('AFSPOPR');
&V      outAddressDS_ likeDS(addressDS);
&V      outOrderID_ char(7);
&V     end-pr;

&V     // AFS Order Request Header
&V     dcl-ds addressDS extname('AFSOREQ') qualified inz;
&V     end-ds addressDS;
&V
AM    *
      *------------------------------------------------------------------------*
     IOEFTOLY
     I              PONO05                      OPOLN
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
     I              ARNO75                      FAXARA
     I              ARNO76                      FAXPRE
     I              ARNO77                      FAXSUF
     I              ARFL72                      FAXF72
     I              ARAM01                      CSAM01
¢A2  I              ARCD59                      CSCD59
     IARFMBALA
     I              ARNO01                      CUSNBR
     I              ARNO15                      CUSCO
     I              ARNO16                      CUSBRA
     I              ARID01                      CUSSLS
     I              ARAM01                      CBAM01
     I              ARNO82                      ENTNBR
     I              ARFL03                      BALFLG
     I              ARMO12                      MO12
     I              ARDY12                      DY12
     I              ARCC12                      CC12
     I              ARYR12                      YR12
     IARFMJBM
     I              ARNO01                      JOBCUS
     I              ARAD13                      JOBAD1
     I              ARAD14                      JOBAD2
     I              ARAD15                      JOBAD3
     I              ARCY05                      JOBCTY
     I              ARST05                      JOBSTA
     I              ARZP19                      JOBZIP
     I              ARID04                      JOBSLS
     I              ARCD83                      JOBJUR
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
     IARFMBCH
     I              ARCD04                      CD04
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
     IIVFMALI
     I              ARNO01                      RNNO01
     I              ARNO16                      RNNO16
#2   IIVFALIAUD
#2   I              ARNO01                      RNNO01
#2   I              ARNO16                      RNNO16
     IPOFTOL
     I              PONO01                      PN1
     I              PONO05                      PN5
     I              IVNO07                      PN7
     I              IVNO22                      PN22
     I              IVNO93                      PN93
     IPOFTOL1
     I              PONO01                      RN1
     I              PONO05                      RN5
     I              IVNO07                      RN7
     I              IVNO22                      RN22
     I              IVNO93                      RN93
     IPOFTOH
     I              PONO01                      RN1
     I              APNO01                      RP1
     IARFTNT
     I              ARNO16                      XXNO16
     IOEFWOAR
     I              OENO01                      OANO01
     I              OENO31                      OANO31
     I              OENO38                      OANO38
     I              OEQY12                      OAQY12
     I              OEAM50                      OAAM50
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
SV   I              OEAMWF                      OAAMWF
SV   I              OEAMWC                      OAAMWC
T2   I              OEAMWR                      OAAMWR
     I              OEAM17                      OAAM17
     I              OEAM18                      OAAM18
SV   I              OEAMEF                      OAAMEF
SV   I              OEAMEC                      OAAMEC
T2   I              OEAMER                      OAAMER
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
     I              OEQY13                      OAQY13
     I              OETM01                      OATM01
     I              OEYR02                      OAYR02
     I              OEYR03                      OAYR03
     I              OEYR07                      OAYR07
     I              OECD31                      OACD31
     I              OECD43                      OACD43
     I              OEPC07                      OAPC07
     I              OECD66                      OACD66
     I              OECD47                      OACD47
     I              PONO01                      OAPN01
     I              PONO05                      OAPN05
     I              OECD72                      OACD72
     I              OEAM46                      OAAM46
     I              OEAM47                      OAAM47
     I              OEAM38                      OAAM38
     I              OEAM39                      OAAM39
     I              OEAM40                      OAAM40
     I              OEAM41                      OAAM41
     I              OEAM42                      OAAM42
Q4   I              WONO01                      OWNO01
XE   I              OEAMWR_S                    OAAMWR_S
XE   I              OEAMER_S                    OAAMER_S
     IOEFTOAL7
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
SV   I              OEAMWF                      OAAMWF
SV   I              OEAMWC                      OAAMWC
T2   I              OEAMWR                      OAAMWR
XE   I              OEAMWR_S                    OAAMWR_S
     I              OEAM17                      OAAM17
     I              OEAM18                      OAAM18
SV   I              OEAMEF                      OAAMEF
SV   I              OEAMEC                      OAAMEC
T2   I              OEAMER                      OAAMER
XE   I              OEAMER_S                    OAAMER_S
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
     I              OECD31                      OACD31
     I              OECD43                      OACD43
     I              OEPC07                      OAPC07
     I              OECD66                      OACD66
     I              OECD47                      OACD47
     I              PONO01                      OAPN01
     I              PONO05                      OAPN05
     I              OECD72                      OACD72
     I              OEAM46                      OAAM46
     I              OEAM47                      OAAM47
     IOEFTOAT
     I              ARNO01                      AANO01
     I              ARNO15                      AANO15
     I              OECC02                      OACC02
     I              OEDN05                      OADN05
     I              OEDY02                      OADY02
     I              OEMO02                      OAMO02
     I              OENM01                      OANM01
     I              OENO01                      OANO01
     I              OENO21                      OANO21
     I              OENO32                      OANO32
     I              OEYR02                      OAYR02
     IOEFTOAW
     I              ARCC09                      AACC09
     I              ARDY09                      AADY09
     I              ARMO09                      AAMO09
     I              ARNM03                      AANM03
     I              ARNM09                      AANM09
     I              ARNO07                      AANO07
     I              ARNO08                      AANO08
     I              ARNO09                      AANO09
     I              ARNO15                      AANO15
     I              ARNO16                      AANO16
     I              ARYR09                      AAYR09
     I              OECC03                      OACC03
     I              OEDY03                      OADY03
     I              OEMO03                      OAMO03
     I              OENO01                      OANO01
     I              OEYR03                      OAYR03
     IOEFTOAH
     I              ARCC05                      AACC05
     I              ARCD25                      COCD25
     I              ARCD26                      AACD26
     I              ARDY05                      AADY05
     I              ARMO05                      AAMO05
     I              ARNO01                      AANO01
     I              ARNO15                      AANO15
     I              ARYR05                      AAYR05
     I              OEAM23                      OAAM23
     I              OECC02                      OACC02
     I              OECC03                      OACC03
     I              OECC07                      OACC07
     I              OECC14                      OACC14
     I              OECC15                      OACC15
     I              OECD03                      OACD03
     I              OECD05                      OACD05
     I              OECD13                      OACD13
     I              OECD18                      OACD18
     I              OECD33                      OACD33
     I              OECD58                      OACD58
     I              OECN06                      OACN06
     I              OEDY02                      OADY02
     I              OEDY03                      OADY03
     I              OEDY07                      OADY07
     I              OEDY14                      OADY14
     I              OEDY15                      OADY15
     I              OEFL06                      OAFL06
     I              OEFL07                      OAFL07
     I              OEFL08                      CONTAX
     I              OEFL09                      OAFL09
     I              OEFL14                      OAFL14
     I              OEID01                      OAID01
     I              OEID02                      CONSLS
     I              OEMO02                      OAMO02
     I              OEMO03                      OAMO03
     I              OEMO07                      OAMO07
     I              OEMO14                      OAMO14
     I              OEMO15                      OAMO15
     I              OENM01                      OANM01
     I              OENM02                      OANM02
     I              OENO01                      OANO01
     I              OENO06                      OANO06
     I              OENO07                      OANO07
     I              OENO08                      OANO08
     I              OENO24                      CONJUR
     I              OEPC02                      OAPC02
     I              OETL06                      OATL06
     I              OETL07                      OATL07
     I              OETL08                      OATL08
     I              OETL09                      OATL09
     I              OETL10                      OATL10
     I              OETL11                      OATL11
     I              OETM01                      OATM01
     I              OEYR02                      OAYR02
     I              OEYR03                      OAYR03
     I              OEYR07                      OAYR07
     I              OEYR14                      OAYR14
     I              OEYR15                      OAYR15
     I              OEMO16                      OAMO16
     I              OEDY16                      OADY16
     I              OECC16                      OACC16
     I              OEYR16                      OAYR16
     I              OEMO17                      OAMO17
     I              OEDY17                      OADY17
     I              OECC17                      OACC17
     I              OEYR17                      OAYR17
     I              OEFL15                      OAFL15
     I              OEAM29                      OAAM29
     I              OEAM30                      OAAM30
     I              ARCDB5                      COCDB5
     I              ARCDB6                      AACDB6
     I              OETL13                      OATL13
     I              OENO43                      OANO43
     I              OEPC08                      OAPC08
     I              OECD86                      OACD86
     I              ARCDF9                      COCDF9
UI   I              OENM15                      OANM15
UI   I              OECD17                      OACD17
UI   I              OECD19                      OACD19
UI   I              OECD01                      OACD01
UI   I              OEDN01                      OADN01
     IOEFTOAA
     I              ARNO01                      AANO01
     I              ARNO15                      AANO15
     I              OEAD01                      CONAD1
     I              OEAD02                      CONAD2
     I              OEAD03                      CONAD3
     I              OECC02                      OACC02
     I              OECY01                      CONCTY
     I              OEST01                      CONSTA
     I              OEZP03                      CONZIP
     I              OEDY02                      OADY02
     I              OEMO02                      OAMO02
     I              OENM01                      OANM01
     I              OENO01                      OANO01
     I              OEYR02                      OAYR02
     IOEFTOAR
     I              ARNO01                      AANO01
     I              ARNO15                      AANO15
     I              OEAM03                      AAAM03
     I              OECC02                      AACC02
     I              OECD06                      AACD06
     I              OEDN03                      AADN03
     I              OEDY02                      AADY02
     I              OEFL08                      AAFL08
     I              OEFL12                      AAFL12
     I              OEFL13                      AAFL13
     I              OEMO02                      AAMO02
     I              OENM01                      AANM01
     I              OENO01                      OANO01
     I              OEYR02                      AAYR02
     IOEFTBH
     I              ARNO01                      BDNO01
     I              ARNO15                      BDNO15
     I              OECC02                      OBCC02
     I              OECC03                      OBCC03
     I              OECC18                      OBCC18
     I              OECC19                      OBCC19
     I              OECD18                      OBCD18
     I              OECD33                      OBCD33
     I              OECD58                      OBCD58
     I              OECN06                      OBCN06
     I              OEDN10                      OBDN10
     I              OEDY02                      OBDY02
     I              OEDY03                      OBDY03
     I              OEDY18                      OBDY18
     I              OEDY19                      OBDY19
     I              OEFL06                      OBFL06
     I              OEFL07                      OBFL07
     I              OEFL08                      BIDTAX
     I              OEFL09                      OBFL09
     I              OEFL14                      OBFL14
     I              OEID01                      OBID01
     I              OEID02                      BIDSLS
     I              OEMO02                      OBMO02
     I              OEMO03                      OBMO03
     I              OEMO18                      OBMO18
     I              OEMO19                      OBMO19
     I              OENM01                      OBNM01
     I              OENO01                      OBNO01
     I              OENO08                      OBNO08
     I              OENO24                      BIDJUR
     I              OENO42                      OBNO42
     I              OENO43                      OBNO43
     I              OEPC02                      OBPC02
     I              OETL06                      OBTL06
     I              OETL07                      OBTL07
     I              OETL08                      OBTL08
     I              OETL09                      OBTL09
     I              OETL10                      OBTL10
     I              OETL11                      OBTL11
     I              OETM01                      OBTM01
     I              OETM03                      OBTM03
     I              OEYR02                      OBYR02
     I              OEYR03                      OBYR03
     I              OEYR18                      OBYR18
     I              OEYR19                      OBYR19
     I              ARCD25                      BDCD25
     I              ARCD26                      BDCD26
     I              ARCDB5                      BDCDB5
     I              ARCDB6                      BDCDB6
     I              OETL13                      OBTL13
     I              OEPC08                      OBPC08
     I              OECD86                      OBCD86
     I              ARCDF9                      BDCDF9
UI   I              OENO06                      OBNO06
UI   I              OENM02                      OBNM02
UI   I              OENM15                      OBNM15
UI   I              OECDA6                      OBCDA6
UI   I              OEID06                      OBID06
UI   I              OEDN21                      OBDN21
UI   I              OEID07                      OBID07
UI   I              OEMO27                      OBMO27
UI   I              OEDY27                      OBDY27
UI   I              OECC27                      OBCC27
UI   I              OEYR27                      OBYR27
     IOEFTBR
     I              ARNO01                      BANO01
     I              ARNO15                      BDNO15
     I              OEAM03                      BDAM03
     I              OECC02                      BDCC02
     I              OECD06                      BDCD06
     I              OEDN03                      BDDN03
     I              OEDY02                      BDDY02
     I              OEFL08                      BDFL08
     I              OEFL12                      BDFL12
     I              OEFL13                      BDFL13
     I              OEMO02                      BDMO02
     I              OENM01                      BDNM01
     I              OENO01                      OBNO01
     I              OEYR02                      BDYR02
     I              OENO43                      OBNO43
     IOEFTBW
     I              ARCC09                      BDCC09
     I              ARDY09                      BDDY09
     I              ARMO09                      BDMO09
     I              ARNM03                      BDNM03
     I              ARNM09                      BDNM09
     I              ARNO07                      BDNO07
     I              ARNO08                      BDNO08
     I              ARNO09                      BDNO09
     I              ARNO15                      BDNO15
     I              ARNO16                      BDNO16
     I              ARYR09                      BDYR09
     I              OECC03                      OBCC03
     I              OEDY03                      OBDY03
     I              OEMO03                      OBMO03
     I              OENO01                      OBNO01
     I              OEYR03                      OBYR03
     I              OENO43                      OBNO43
     IOEFTBM
     I              ARNO01                      BMNO01
     I              OENO01                      OBNO01
     I              ARNO15                      BDNO15
     I              OENO43                      OBNO43
     IOEFTBL
     I              ARNO01                      ABNO01
     I              ARNO15                      ABNO15
     I              IVDN02                      BVDN02
     I              IVNO04                      BVNO04
     I              IVNO07                      BVNO07
     I              OEAM01                      OBAM01
     I              OEAM02                      OBAM02
     I              OEAM05                      OBAM05
     I              OEAM14                      OBAM14
SV   I              OEAMWF                      OBAMWF
SV   I              OEAMWC                      OBAMWC
T2   I              OEAMWR                      OBAMWR
     I              OEAM17                      OBAM17
     I              OEAM18                      OBAM18
SV   I              OEAMEF                      OBAMEF
SV   I              OEAMEC                      OBAMEC
T2   I              OEAMER                      OBAMER
     I              OECC02                      OBCC02
     I              OECC03                      OBCC03
     I              OECD09                      OBCD09
     I              OECD26                      OBCD26
     I              OECD27                      OBCD27
     I              OECD28                      OBCD28
     I              OECD30                      OBCD30
     I              OECD43                      OBCD43
     I              OECN04                      OBCN04
     I              OEDN04                      OBDN04
     I              OEDY02                      OBDY02
     I              OEDY03                      OBDY03
     I              OEID02                      OBID02
     I              OEMO02                      OBMO02
     I              OEMO03                      OBMO03
     I              OENM01                      OBNM01
     I              OENO01                      OBNO01
     I              OENO31                      OBNO31
     I              EINO22                      OBNO22
     I              OENO32                      OBNO32
     I              OENO33                      OBNO33
     I              OENO36                      OBNO36
     I              OENO37                      OBNO37
     I              OENO41                      OBNO41
     I              OENO43                      OBNO43
     I              OEPC01                      OBPC01
     I              OEQY06                      OBQY06
     I              OEQY10                      OBQY10
     I              OETM01                      OBTM01
     I              OEYR02                      OBYR02
     I              OEYR03                      OBYR03
     I              OEPC07                      OBPC07
     I              OECD66                      OBCD66
     I              OECD31                      OBCD31
     I              OECD70                      OBCD70
     I              OEAM38                      OBAM38
     I              OEAM39                      OBAM39
     I              OEAM40                      OBAM40
     I              OEAM41                      OBAM41
     I              OEAM42                      OBAM42
     I              OECD55                      OBCD55
XE   I              OEAMWR_S                    OBAMWR_S
XE   I              OEAMER_S                    OBAMER_S
     IOEFTBT
     I              ARNO01                      BANO01
     I              ARNO15                      BDNO15
     I              OECC02                      OBCC02
     I              OEDN05                      OBDN05
     I              OEDY02                      OBDY02
     I              OEMO02                      OBMO02
     I              OENM01                      OBNM01
     I              OENO01                      OBNO01
     I              OENO21                      OBNO21
     I              OENO32                      OBNO32
     I              OEYR02                      OBYR02
     I              OENO43                      OBNO43
     IOEFWCBL
     I              OENO43                      OBNO43
     I              OENO31                      OBNO31
     I              IVNO04                      WNO04
     I              OEQY10                      WQY10
     I              OEQY17                      WQY17
     IIVFMSBR
     I              ARCD14                      UNUSEA
     I              ARCD15                      UNUSEB
     I              IVNO07                      UNUSEC
     IARFMCAD
     I              ARNO01                      NO01S
     I              ARNM21                      NM21S
     I              ARNO40                      NO40S
     I              ARCD04                      CD04S
     I              ARID01                      ID01S
     IOEFTOAM
     I              ARNO01                      AANO01
     I              OENO01                      OANO01
     I              OECD11                      OACD11
     I              OENO17                      OANO17
     I              OEDN02                      OADN02
     I              OENM01                      OANM01
     I              OEMO02                      OAMO02
     I              OEDY02                      OADY02
     I              OECC02                      OACC02
     I              OEYR02                      OAYR02
     I              ARNO15                      AANO15
     IOEFWRL1
     I              JOBNUM                      RRJOB#
     I              JOBNME                      RRJOBN
     I              ARNO15                      RRNO15
     I              IVDN01                      RRDN01
     I              IVNO04                      RRNO04
     I              IVNO07                      RRNO07
     I              OEAM01                      RRAM01
     I              OEAM02                      RRAM02
     I              OECD03                      RRCD03
     I              OECD09                      RRCD09
     I              OECD26                      RRCD26
     I              OECD27                      RRCD27
     I              OECD28                      RRCD28
     I              OECD31                      RRCD31
     I              OECD43                      RRCD43
     I              OECD66                      RRCD66
     I              OEDN04                      RRDN04
     I              OENO01                      RRNO01
     I              OENO08                      RRNO08
     I              OENO16                      RRNO16
     I              OENO22                      RRNO22
     I              OENO23                      RRNO23
     I              OENO52                      RRNO52
     I              OENO53                      RRNO53
     I              OENO54                      RRNO54
     I              OENO55                      RRNO55
     I              OEPC01                      RRPC01
     I              OEPC07                      RRPC07
     I              OEQY01                      RRQY01
     I              OEQY02                      RRQY02
     I              OEQY03                      RRQY03
     I              OEQY04                      RRQY04
     I              OEQY05                      RRQY05
     I              OEQY06                      RRQY06
     I              OEQY14                      RRQY14
     I              OEQY15                      RRQY15
     I              OEQY16                      RRQY16
     I              EINO22                      RENO22
     I              PONO01                      RRPN01
     I              PONO05                      RRPN05
     I              OENO59                      RRNO59
     I              OENO60                      RRNO60
     IOEFWRL2
     I              ARNO15                      RRNO15
     I              IVDN01                      RRDN01
     I              IVNO04                      RRNO04
     I              IVNO07                      RRNO07
     I              OEAM01                      RRAM01
     I              OEAM02                      RRAM02
     I              OECD03                      RRCD03
     I              OECD09                      RRCD09
     I              OECD26                      RRCD26
     I              OECD27                      RRCD27
     I              OECD28                      RRCD28
     I              OECD31                      RRCD31
     I              OECD43                      RRCD43
     I              OECD66                      RRCD66
     I              OEDN04                      RRDN04
     I              OENO01                      RRNO01
     I              OENO08                      RRNO08
     I              OENO16                      RRNO16
     I              OENO22                      RRNO22
     I              OENO23                      RRNO23
     I              OENO52                      RRNO52
     I              OENO53                      RRNO53
     I              OENO54                      RRNO54
     I              OENO55                      RRNO55
     I              OEPC01                      RRPC01
     I              OEPC07                      RRPC07
     I              OEQY01                      RRQY01
     I              OEQY02                      RRQY02
     I              OEQY03                      RRQY03
     I              OEQY04                      RRQY04
     I              OEQY05                      RRQY05
     I              OEQY06                      RRQY06
     I              OEQY14                      RRQY14
     I              OEQY15                      RRQY15
     I              OEQY16                      RRQY16
     I              EINO22                      RENO22
     I              PONO01                      RRPN01
     I              PONO05                      RRPN05
     I              OENO59                      RRNO59
     I              OENO60                      RRNO60
     IIVFTNSK5
     I              IVNO04                      NSNO04
     I              IVNM01                      NSNM01
     I              IVMO01                      NSMO01
     I              IVDY01                      NSDY01
     I              IVCC01                      NSCC01
     I              IVYR01                      NSYR01
     IARFMENT
     I              ARMO09                      EMO09
     I              ARDY09                      EDY09
     I              ARCC09                      ECC09
     I              ARYR09                      EYR09
     I              ARNM03                      ENM03
     I              ARCDF9                      ECDF9
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
     IOEFTOAD
     I              ARNO15                      ADNO15
     I              ARNO01                      ADNO01
     I              OENO01                      ADOE01
     I              OENO31                      ADNO31
     I              IVNO07                      ADNO07
     I              OEDN04                      ADDN04
     I              PONO01                      ADPO01
     IOEFTLLN
     I              OENO01                      LNNO01
     I              OENO31                      LNNO31
RA    *
RA   IIVFMNSB
RA   I              IVNO10                      NBNO10
RA   I              IVNON1                      NBNON1
RA   I              IVQY01                      NBQY01
RA   I              IVQY23                      NBQY23
RA   I              IVAMW6                      NBAMW6
SV   I              IVAMWF                      NBAMWF
SV   I              IVAMWC                      NBAMWC
T2   I              IVAMWR                      NBAMWR
RA   I              IVNM01                      NBNM01
RA   I              IVMO01                      NBMO01
RA   I              IVDY01                      NBDY01
RA   I              IVCC01                      NBCC01
RA   I              IVYR01                      NBYR01
RA   I              IVMO04                      NBMO04
RA   I              IVDY04                      NBDY04
RA   I              IVCC04                      NBCC04
RA   I              IVYR04                      NBYR04
XE   I              IVAMWR_S                    NBAMWR_S
     IOEFWITX
     I              OECD31                      MTXFLG
   R3I*             OEAM38                      MAM38
   R3I*             OEQY03                      MQSHP
R3   I              OEQY05                      MQSHP
     I              OECD43                      MNOCHG
     I              OEAM01                      MUNIT
     I              OEAM05                      MEXT
     I              OEQY01                      MQORD
     I              OEQY02                      MQBO
RO   IPOFTTG
RO   I              OENO01                      TXNO01
RO   I              OENO22                      TXNO22
Z1   IIVFMSTA
Z1   I              IVNO07                      QQNO07
      *****************************************************************
      *  SECTION 0         NON-EXECUTABLE STATEMENTS
      * STEP 1.  KEY LIST
      *****************************************************************
      * STEP 1. *
      ***********
TM   C     *like         define    oeno01        @oeno01
TM   C     *like         define    ivno07        @ivno07
TM   C     *like         define    oeno22        @oeno22
TM   C     *like         define    arno01        @arno01
S4   C     *LIKE         DEFINE    RRN           HLDRRN
SK   C     *LIKE         DEFINE    AFTINV        @AFTINV
SX   C     *LIKE         DEFINE    OEAM05        EXTDPRC          +4
SX   C     *LIKE         DEFINE    OEAM05        EXTDPRC1
TE   C     *LIKE         DEFINE    ORTL02        SBTL02           +4
TE   C     *LIKE         DEFINE    ORTL02        DSBTL02
TE   C     *LIKE         DEFINE    ORDTAX        TXTL02           +4
TE   C     *LIKE         DEFINE    ORDTAX        DTXTL02
TE   C     *LIKE         DEFINE    ORTL01        GNTL01           +4
TE   C     *LIKE         DEFINE    ORTL01        DGNTL01
TE   C     *LIKE         DEFINE    GSTAMT        GSTL01           +4
TE   C     *LIKE         DEFINE    GSTAMT        DGSTL01
TE   C     *LIKE         DEFINE    OETL02        SSBTL02          +4
TE   C     *LIKE         DEFINE    OETL02        DSSBTL02
TE   C     *LIKE         DEFINE    OEAM04        STXTL02          +4
TE   C     *LIKE         DEFINE    OEAM04        DSTXTL02
TE   C     *LIKE         DEFINE    OETL01        SGNTL01          +4
TE   C     *LIKE         DEFINE    OETL01        DSGNTL01
TE   C     *LIKE         DEFINE    OEAM44        SGSTL01          +4
TE   C     *LIKE         DEFINE    OEAM44        DSGSTL01
TE   C     *LIKE         DEFINE    ORDEXT        BEXTDPRC         +4
TE   C     *LIKE         DEFINE    ORDEXT        BEXTDPRC1
     C     *LIKE         DEFINE    IVNO07        ASCITM
     C     *LIKE         DEFINE    OPNO01        SECPRF                         CO SECURITY PRF
     C     *LIKE         DEFINE    ARNO15        DFNO15                         DFT COMPANY
     C     *LIKE         DEFINE    ARNO15        ZRNO15                         ZERO COMPANY
     C     *LIKE         DEFINE    ARNO15        SVNO15                         SAVE COMPANY
     C     *LIKE         DEFINE    ARNO15        RSNO15                         RESTORE COMPANY
     C     *LIKE         DEFINE    OENO08        DFNO08                         DFT SELL BR
     C     *LIKE         DEFINE    OENO08        SVSLBR                         SAVE SELL BR
     C     *LIKE         DEFINE    OENO08        SAVNO8                         SAVE SELL BR
     C     *LIKE         DEFINE    PONO03        SAVNO3                         SAVE ENT BR
     C     *LIKE         DEFINE    OENO16        DFNO16                         DFT SHIP BR
     C     *LIKE         DEFINE    OENO16        SVSHBR                         SAVE SHIP BR
     C     *LIKE         DEFINE    ARNO07        AREACD                         DFT AREA CODE
     C     *LIKE         DEFINE    OECD17        DFCD17                         DFT ORD SOURCE
     C     *LIKE         DEFINE    OECD19        DFCD19                         DFT SALE TYPE
     C     *LIKE         DEFINE    OECD01        OURTRK                         OUR TRUCK
     C     *LIKE         DEFINE    OECD01        PICKUP                         PICKUP
     C     *LIKE         DEFINE    OECD01        SHIPED                         SHIPPED
     C     *LIKE         DEFINE    OEFL06        ADDOVR                         ADDR OVERRIDE
     C     *LIKE         DEFINE    OEFL15        TAXOVR                         TAX OVERRIDE
     C     *LIKE         DEFINE    ARAD10        SAVAD1                         SAVE ADR LN 1
     C     *LIKE         DEFINE    ARAD11        SAVAD2                         SAVE ADR LN 2
     C     *LIKE         DEFINE    ARAD12        SAVAD3                         SAVE ADR LN 3
     C     *LIKE         DEFINE    ARCY04        SAVCTY                         SAVE CITY
     C     *LIKE         DEFINE    ARST04        SAVSTA                         SAVE STATE
     C     *LIKE         DEFINE    ARZP18        SAVZIP                         SAVE ZIP CODE
     C     *LIKE         DEFINE    ARAD10        DSLAD1                         DFT SELL BR ADR
     C     *LIKE         DEFINE    ARAD11        DSLAD2                         DFT SELL BR ADR
     C     *LIKE         DEFINE    ARAD12        DSLAD3                         DFT SELL BR ADR
     C     *LIKE         DEFINE    ARCY04        DSLCTY                         DFT SELL BR CTY
     C     *LIKE         DEFINE    ARST04        DSLSTA                         DFT SELL BR STA
     C     *LIKE         DEFINE    ARZP18        DSLZIP                         DFT SELL BR ZIP
     C     *LIKE         DEFINE    ARAD10        SLBAD1                         SELL BR ADR
     C     *LIKE         DEFINE    ARAD11        SLBAD2                         SELL BR ADR
     C     *LIKE         DEFINE    ARAD12        SLBAD3                         SELL BR ADR
     C     *LIKE         DEFINE    ARCY04        SLBCTY                         SELL BR CTY
     C     *LIKE         DEFINE    ARST04        SLBSTA                         SELL BR STA
     C     *LIKE         DEFINE    ARZP18        SLBZIP                         SELL BR ZIP
     C     *LIKE         DEFINE    ARAD10        DSHAD1                         DFT SHIP BR ADR
XU    *
XU   C     *LIKE         DEFINE    ARAD10        SLDAD2                         SELL BR ADR
XU   C     *LIKE         DEFINE    ARAD12        SLDAD3                         SELL BR ADR
XU   C     *LIKE         DEFINE    ARCY04        SLDCTY                         SELL BR CTY
XU   C     *LIKE         DEFINE    ARST04        SLDSTA                         SELL BR STA
XU   C     *LIKE         DEFINE    ARZP18        SLDZIP                         SELL BR ZIP
XU    *
     C     *LIKE         DEFINE    ARAD11        DSHAD2                         DFT SHIP BR ADR
     C     *LIKE         DEFINE    ARAD12        DSHAD3                         DFT SHIP BR ADR
     C     *LIKE         DEFINE    ARCY04        DSHCTY                         DFT SHIP BR CTY
     C     *LIKE         DEFINE    ARST04        DSHSTA                         DFT SHIP BR STA
     C     *LIKE         DEFINE    ARZP18        DSHZIP                         DFT SHIP BR ZIP
     C     *LIKE         DEFINE    OEID02        DSHSLS                         DFT SHIP BR SLS
     C     *LIKE         DEFINE    OEFL08        DSHTAX                         DFT SHIP BR TAX
     C     *LIKE         DEFINE    CD04          DSHJUR                         DFT SHIP BR JUR
     C     *LIKE         DEFINE    ARAD10        SHBAD1                         SHIP BR ADR
     C     *LIKE         DEFINE    ARAD11        SHBAD2                         SHIP BR ADR
     C     *LIKE         DEFINE    ARAD12        SHBAD3                         SHIP BR ADR
     C     *LIKE         DEFINE    ARCY04        SHBCTY                         SHIP BR CTY
     C     *LIKE         DEFINE    ARST04        SHBSTA                         SHIP BR STA
     C     *LIKE         DEFINE    ARZP18        SHBZIP                         SHIP BR ZIP
     C     *LIKE         DEFINE    OEID02        SHBSLS                         SHIP BR SLS
     C     *LIKE         DEFINE    OEFL08        SHBTAX                         SHIP BR TAX
     C     *LIKE         DEFINE    CD04          SHBJUR                         SHIP BR JUR
     C     *LIKE         DEFINE    OEFL08        JOBTAX                         JOB TAX FLAG
     C     *LIKE         DEFINE    OEFL08        CUSTAX                         CUS TAX FLAG
     C     *LIKE         DEFINE    ARAD19        ALTAD1                         ADDRESS 1
     C     *LIKE         DEFINE    ARAD20        ALTAD2                         ADDRESS 2
     C     *LIKE         DEFINE    ARAD21        ALTAD3                         ADDRESS 3
     C     *LIKE         DEFINE    ARCY07        ALTCTY                         CITY
     C     *LIKE         DEFINE    ARST07        ALTSTA                         STATE
     C     *LIKE         DEFINE    ARZP21        ALTZIP                         ZIP
     C     *LIKE         DEFINE    OEID02        ALTSLS                         ALT SLS ID
     C     *LIKE         DEFINE    CD04S         ALTJUR                         ALT TAX JURIS
     C     *LIKE         DEFINE    OEPC02        SAVPCT                         SAVE TAX PCT
     C     *LIKE         DEFINE    OENO24        SAVJUR                         SAVE TAX JURIS
     C     *LIKE         DEFINE    OENO01        SVBTNO                         SAVE BATCH NBR
     C     *LIKE         DEFINE    OECD13        LSTTRD                         WALKIN BASE PRC
     C     *LIKE         DEFINE    ARNM05        PMNM05                         CUS NAME PARM
     C     *LIKE         DEFINE    ARNO07        PMNO07                         CUS PHN PARM
     C     *LIKE         DEFINE    ARNO08        PMNO08                         CUS PHN PARM
     C     *LIKE         DEFINE    ARNO09        PMNO09                         CUS PHN PARM
     C     *LIKE         DEFINE    ARNO01        PMNO01                         CUS NUMBER PARM
     C     *LIKE         DEFINE    ARNO01        SVNO01
     C     *LIKE         DEFINE    ARNO01        CUSNUM                         CUSTOMER NUMBER
     C     *LIKE         DEFINE    ARZP15        PMZP15                         CUS ZIP PARM
     C     *LIKE         DEFINE    ARNO01        DEPCUS                         DEPOSIT CUST NO
     C     *LIKE         DEFINE    ARNM01        DEPNAM                         DEPOSIT CUST NM
     C     *LIKE         DEFINE    ARNO15        DEPCO                          DEPOSIT COMPANY
     C     *LIKE         DEFINE    OENO08        DEPBR                          DEPOSIT BRANCH
     C     *LIKE         DEFINE    OENO01        DEPORD                         DEPOSIT ORD NBR
     C     *LIKE         DEFINE    NOTRRN        NOTIND                         NOTE INDEX
     C     *LIKE         DEFINE    NOTRRN        MXNOTE                         MAXIMUM NOTES
     C     *LIKE         DEFINE    NOTRRN        NOTPAG                         PAGE POSITION
     C     *LIKE         DEFINE    ARNM21        SVNM21                         SAVE ADDR DESC
     C     *LIKE         DEFINE    ARNM21        SUBFLD                         SUBSTRING DESC
     C     *LIKE         DEFINE    SHPRRN        SHPLST                         SHIP ADDR RRN
     C     *LIKE         DEFINE    SHPRRN        SHPPAG                         SHIP ADDR PAGE
     C     *LIKE         DEFINE    IVNO14        SAVN14
     C     *LIKE         DEFINE    ZZNO04        SAVNO4
     C     *LIKE         DEFINE    ZZNO04        SVNO04          - 1
     C     *LIKE         DEFINE    ZZNO04        SVLU04
     C     *LIKE         DEFINE    IVNO04        PRT#
     C     *LIKE         DEFINE    IVDN01        DESC
     C     *LIKE         DEFINE    IVNO05        V#                             EMPTY VEN#
     C     *LIKE         DEFINE    PN1           PO#                            PO# FROM LDA
     C     *LIKE         DEFINE    PONO12        TAGSEQ                         TAG SEQ# TEM
     C     *LIKE         DEFINE    OETL02        TAXAMT
     C     *LIKE         DEFINE    OETL02        NTXAMT
     C     *LIKE         DEFINE    RRN           RRN@A
¢B   C     *LIKE         DEFINE    RRN           QRRN
     C     *LIKE         DEFINE    RRN           SAVRRN
     C     *LIKE         DEFINE    RRN           SVLRRN
     C     *LIKE         DEFINE    RRN           LOURRN
     C     *LIKE         DEFINE    OEQY03        LOWASQ
     C     *LIKE         DEFINE    OEQY03        ASQ
     C     *LIKE         DEFINE    OEQY03        GSQ
     C     *LIKE         DEFINE    OEQY03        SSQY03
     C     *LIKE         DEFINE    STKQTY        SSKQTY
     C     *LIKE         DEFINE    PRT           SSPRT
     C     *LIKE         DEFINE    SERIL#        SSRIL#
     C     *LIKE         DEFINE    ALIAS         SSLIAS
     C     *LIKE         DEFINE    OEQY02        BOCMPQ
     C     *LIKE         DEFINE    ITMCAT        SVCAT
     C     *LIKE         DEFINE    SBR           XXXSBR
     C     *LIKE         DEFINE    DIR           XXXDIR
     C     *LIKE         DEFINE    SBR           PRMSBR
     C     *LIKE         DEFINE    DIR           SAVDIR
     C     *LIKE         DEFINE    SBR           SAVSBR
     C     *LIKE         DEFINE    OENO16        WRTBR#
     C     *LIKE         DEFINE    OENO16        THSBR#
     C     *LIKE         DEFINE    Z             BEG#
     C     *LIKE         DEFINE    Z             SAVEZ
     C     *LIKE         DEFINE    Z             CNTBR#
     C     *LIKE         DEFINE    OENO16        SVNO16
     C     *LIKE         DEFINE    OECD01        SVMOS1
     C     *LIKE         DEFINE    OECD01        SVMOS2
     C     *LIKE         DEFINE    OECD01        SVMOS3
     C     *LIKE         DEFINE    OEDN01        SV3VIA
     C     *LIKE         DEFINE    OENO24        SVNO24
     C     *LIKE         DEFINE    BKOR          SVBKOR
     C     *LIKE         DEFINE    PICSEQ        SVPICS
     C     *LIKE         DEFINE    OEFL03        SVFL03
     C     *LIKE         DEFINE    OENO01        ORD1ST
     C     *LIKE         DEFINE    BEG#          SVBEG#
     C     *LIKE         DEFINE    OEQY02        QTY02
     C     *LIKE         DEFINE    OEQY02        QTY03
     C     *LIKE         DEFINE    OETL02        BTAXBL
     C     *LIKE         DEFINE    OETL02        CTAXBL
     C     *LIKE         DEFINE    OETL02        DTAXBL
     C     *LIKE         DEFINE    OETL01        BOTL01
     C     *LIKE         DEFINE    OETL01        COTL01
     C     *LIKE         DEFINE    OETL02        BOTL02
     C     *LIKE         DEFINE    OETL02        COTL02
     C     *LIKE         DEFINE    OETL02        DRTL02
     C     *LIKE         DEFINE    OEAM04        BOAM04
     C     *LIKE         DEFINE    OEAM04        COAM04
     C     *LIKE         DEFINE    OCAMT         COOC$
     C     *LIKE         DEFINE    OTHTAX        COOCT$
     C     *LIKE         DEFINE    OAQY10        REMAIN
     C     *LIKE         DEFINE    OECD03        OE#OTY
     C     *LIKE         DEFINE    OECD03        OE#NTY
     C     *LIKE         DEFINE    OACD03        CO#TYP
     C     *LIKE         DEFINE    NO40S         SVNO40                         S/ADD CTL#
     C     *LIKE         DEFINE    ARNO01        WKCUST
     C     *LIKE         DEFINE    RESSTK        SVRESS
     C     *LIKE         DEFINE    RESSTK        RESSZZ
     C     *LIKE         DEFINE    OENO30        ODEP#
     C     *LIKE         DEFINE    OENO01        OORD#
     C     *LIKE         DEFINE    ARNO01        OCUS#
     C     *LIKE         DEFINE    OENO08        OBR#
     C     *LIKE         DEFINE    OENO30        PVDEP#
     C     *LIKE         DEFINE    OENO30        NEWDEP
     C     *LIKE         DEFINE    DPAM21        NEWRMN
     C     *LIKE         DEFINE    OEID02        SAVID2                         SAVE SLSMAN
     C     *LIKE         DEFINE    OENO16        SAVN16
     C     *LIKE         DEFINE    OENO16        SACH16
     C     *LIKE         DEFINE    DIRSPC        SAVSPC
     C     *LIKE         DEFINE    SBR           TSTSBR
     C     *LIKE         DEFINE    Z             SELL@Z
     C     *LIKE         DEFINE    OENO01        DIROR#
     C     *LIKE         DEFINE    OENO01        BUYOR#
     C     *LIKE         DEFINE    COOCT$        SVOCT$
     C     *LIKE         DEFINE    COOC$         SVOC$
     C     *LIKE         DEFINE    OEFL09        SVFL09
     C     *LIKE         DEFINE    OEAM42        SVAM1
     C     *LIKE         DEFINE    OEAM40        SVAM2
     C     *LIKE         DEFINE    OEAM40        CST1
     C     *LIKE         DEFINE    OEAM40        COST
     C     *LIKE         DEFINE    OEAM40        COSTG
     C     *LIKE         DEFINE    OEAM42        PRC1
     C     *LIKE         DEFINE    OEAM42        PRICC
     C     *LIKE         DEFINE    OEAM42        PRICG
     C     *LIKE         DEFINE    OEAM42        SVPRC
     C     *LIKE         DEFINE    OEFL17        SVFL17
     C     *LIKE         DEFINE    CROW          ROW
     C     *LIKE         DEFINE    CCOL          COL
     C     *LIKE         DEFINE    CRCD          CRCD#
     C     *LIKE         DEFINE    CFLD          CFLD#
     C     *LIKE         DEFINE    OEID02        ID02#
     C     *LIKE         DEFINE    OENO06        NO06#
     C     *LIKE         DEFINE    OECD65        SVSHPC
     C     *LIKE         DEFINE    RRN           SAVERN
     C     *LIKE         DEFINE    OEPC07        PC07A                          COMBO TERMS DSC
     C     *LIKE         DEFINE    OEPC07        SV07A                          COMBO TERMS DSC
     C     *LIKE         DEFINE    OECD66        CD66A                          COMBO TERMS OVR
     C     *LIKE         DEFINE    OECD43        CD43A                          COMBO NC ITEM
     C     *LIKE         DEFINE    OECD03        SVCD03                         SAVE CSH/CHG
     C     *LIKE         DEFINE    ARCDB5        LSCDB5                         LAST TERMS Y/N
     C     *LIKE         DEFINE    ARCD25        LSCD25                         LAST TERMS DISC
     C     *LIKE         DEFINE    OETL12        WKTL12                         CALC TERMS DISC
     C     *LIKE         DEFINE    OEQY01        ALTENT
     C     *LIKE         DEFINE    OEQY01        SVQY01
     C     *LIKE         DEFINE    OEQY02        ALTBOQ
     C     *LIKE         DEFINE    OEQY02        SVQY02
     C     *LIKE         DEFINE    OEQY03        SVQY03
     C     *LIKE         DEFINE    IVQY23        SVQY23
     C     *LIKE         DEFINE    OECD08        SVCD08                         SAVE ORDER TYPE
     C     *LIKE         DEFINE    IVDN41        RUOM                           REF UOM
     C     *LIKE         DEFINE    IVQYZ9        RQTY                           REF QTY
     C     *LIKE         DEFINE    OEQY01        CNVRND
     C     *LIKE         DEFINE    OEQY01        WRKQTY
     C     *LIKE         DEFINE    *YEAR         PRMMXY
     C     *LIKE         DEFINE    *YEAR         PRMMNY
     C     *LIKE         DEFINE    *YEAR         OECY07
     C     *LIKE         DEFINE    *YEAR         WRKYR
     C     *LIKE         DEFINE    OEAM38        SNET
     C     *LIKE         DEFINE    OENO16        ALTLOC                         ALTERNATE LOC
     C     *LIKE         DEFINE    OECD26        CBCD26                         COMBO OVERRIDE
     C     *LIKE         DEFINE    OEFL08        SVFL08                                     DE
     C     *LIKE         DEFINE    OENO06        PMNO06                                     DE
     C     *LIKE         DEFINE    OECD26        SVPRCD                                     DE
     C     *LIKE         DEFINE    OENO08        SVNO08
     C     *LIKE         DEFINE    OENM15        ORDBY                          ORDERED BY  DE
     C     *LIKE         DEFINE    IVNO07        PITEM                                      DE
     C     *LIKE         DEFINE    OENO08        PBRNCH                                     DE
     C     *LIKE         DEFINE    APPCDE        APP                            APPLIC CODE DE
     C     *LIKE         DEFINE    OENO07        CUSTPO                                     DE
     C     *LIKE         DEFINE    ARNO01        CUSTNO                                     DE
     C     *LIKE         DEFINE    RETCDE        RTNCDE                                     DE
     C     *LIKE         DEFINE    DSPM1         DSPM3                                      DE
     C     *LIKE         DEFINE    RELTYP        SVRTYP                                     DE
     C     *LIKE         DEFINE    RRQY01        QTYA                                       DE
     C     *LIKE         DEFINE    RRQY02        QTYB                                       DE
     C     *LIKE         DEFINE    RELCDE        RCDE                                       DE
     C     *LIKE         DEFINE    OENO01        RLSORD                                     DE
     C     *LIKE         DEFINE    CUSERR        TAXCHG                                     DE
     C     *LIKE         DEFINE    CUSERR        TAXPRM                                     DE
     C     *LIKE         DEFINE    *IN29         @IN29                                      DE
     C     *LIKE         DEFINE    FACTOR        SVFCTR                                     DE
     C     *LIKE         DEFINE    OEAM44        BOAM44
     C     *LIKE         DEFINE    OEAM45        COAM45
     C     *LIKE         DEFINE    ARNM01        XXNM01
     C     *LIKE         DEFINE    ARNO07        XXNO07
     C     *LIKE         DEFINE    ARNO08        XXNO08
     C     *LIKE         DEFINE    ARNO09        XXNO09
     C     *LIKE         DEFINE    OENO01        ORGORD
     C     *LIKE         DEFINE    OEID01        ORGENT
      * The following fields are for passing data to/from OER9300;
     C     *LIKE         DEFINE    OATL09        PMISUB                         Sub-total
     C     *LIKE         DEFINE    OAAM29        PMITXA                         Taxable
     C     *LIKE         DEFINE    OAAM30        PMINTA                         Non-taxable
     C     *LIKE         DEFINE    OATL10        PMIOTH                         Oth charges
     C     *LIKE         DEFINE    OATL10        PMIOTX                         Taxable oth
     C     *LIKE         DEFINE    OATL10        PMIONT                         Non-tax oth
     C     *LIKE         DEFINE    OEFL08        PMITXF                         Taxable flag
     C     *LIKE         DEFINE    OEFL09        PMIOCF                         Oth chg flag
     C     *LIKE         DEFINE    ARCDB9        PMIGEX                         GST exempt
     C     *LIKE         DEFINE    OEPC02        PMITPC                         Tax %
     C     *LIKE         DEFINE    OEPC08        PMIGHP                         GST/HST %
     C     *LIKE         DEFINE    OENO24        PMIJUR                         Jurisdiction
     C     *LIKE         DEFINE    OAAM29        PMOTXA                         Taxable
     C     *LIKE         DEFINE    OAAM30        PMONTA                         Non-taxable
     C     *LIKE         DEFINE    OATL06        PMOTAX                         Tax amount
     C     *LIKE         DEFINE    OEAM45        PMOGST                         GST amount
     C     *LIKE         DEFINE    ARFL02        PMFLTA                         TAX AUTH FLAG
     C     *LIKE         DEFINE    ARCD67        PMTTYP                         TRANS TYPE
      *
     C     *LIKE         DEFINE    RRN           CBORRN
     C     *LIKE         DEFINE    X             CBOX
     C     *LIKE         DEFINE    TBR           TRFSBR
     C     *LIKE         DEFINE    TBR           XXXTBR
     C     *LIKE         DEFINE    TBR           SAVTBR
     C     *LIKE         DEFINE    OEAM39        AMNET                          GP% WORK
     C     *LIKE         DEFINE    OEAM39        GP                             GP% INQ WORK
     C     *LIKE         DEFINE    ARCC06        SVCC06                         SHIP CENTURY
     C     *LIKE         DEFINE    TAXAMT        ORTAX
     C     *LIKE         DEFINE    NTXAMT        ORNTAX
     C     *LIKE         DEFINE    OETL04        ORTL04
     C     *LIKE         DEFINE    OEAM05        ORDEXT
     C     *LIKE         DEFINE    CSTAMT        ORDCST
     C     *LIKE         DEFINE    OEAM38        ORDNET
     C     *LIKE         DEFINE    CAVAIL        EXTLMT
     C     *LIKE         DEFINE    CAVAIL        $OVR
     C     *LIKE         DEFINE    BOTRRN        SAVBOT
     C     *LIKE         DEFINE    TBNO03        TABDSC
     C     *LIKE         DEFINE    PONO01        ZPONO1
     C     *LIKE         DEFINE    CAVAIL        ELIMIT
     C     *LIKE         DEFINE    CAVAIL        EOVR
     C     *LIKE         DEFINE    OEWT01        WKWT01
     C     *LIKE         DEFINE    QTYCHK        QHCK
      * Work fields used to calculate ship and B/O quantity and $'s
      * for contracts...
     C     *LIKE         DEFINE    OEAM39        COGRBO
     C     *LIKE         DEFINE    OEQY02        COQYBO
     C     *LIKE         DEFINE    OETL02        CTXBLB
     C     *LIKE         DEFINE    OETL01        COTL1B
     C     *LIKE         DEFINE    OETL02        COTL2B
     C     *LIKE         DEFINE    OEAM04        CO04B
     C     *LIKE         DEFINE    OEAM45        CO45B
      *
     C     *LIKE         DEFINE    OEQY03        MAXQTY
     C     *LIKE         DEFINE    OAQY11        WKQY11
     C     *LIKE         DEFINE    RRN           PCRRN
     C     *LIKE         DEFINE    OCAMT         OCAMTE
:J   C     *LIKE         DEFINE    *IN18         SVIN18
:J   C     *LIKE         DEFINE    *IN20         SVIN20
:J   C     *LIKE         DEFINE    *IN21         SVIN21
     C     *LIKE         DEFINE    *IN90         SVIN90
SL   C     *LIKE         DEFINE    *IN51         SVIN51
SL   C     *LIKE         DEFINE    *IN52         SVIN52
SL   C     *LIKE         DEFINE    *IN53         SVIN53
SL   C     *LIKE         DEFINE    *IN54         SVIN54
SL   C     *LIKE         DEFINE    *IN55         SVIN55
     C     *LIKE         DEFINE    *IN57         SVIN57
      *
     C     *LIKE         DEFINE    ARNM01        MSGNAM
     C     *LIKE         DEFINE    OEPC02        GSTPCT
     C     *LIKE         DEFINE    OEAM38        PMIUPR
     C     *LIKE         DEFINE    OEAM38        PMIUCS
     C     *LIKE         DEFINE    OEPC01        PMIDSC
     C     *LIKE         DEFINE    OEAM38        PMONPR
     C     *LIKE         DEFINE    OEQY01        STKQ01
     C     *LIKE         DEFINE    OANO31        KYNO31
     C     *LIKE         DEFINE    IVNO07        LTNO07
     C     *LIKE         DEFINE    OEDN04        LTDN04
     C     *LIKE         DEFINE    OENO31        LTNO31
     C     *LIKE         DEFINE    OAAM05        PRCLT                          LOT PRICE
     C     *LIKE         DEFINE    OAAM17        CSTLT                          LOT COST
     C     *LIKE         DEFINE    SHIPC         SAVSHC                         SAVE SHIP COMPLETE
#O   C     *LIKE         DEFINE    SHIPC         SHIPCSV                        SAVE SHIP COMPLETE
     C     *LIKE         DEFINE    GENTRF        SAVTFR                         SAVE SHIP COMPLETE
     C     *LIKE         DEFINE    GENTRF        USRTFR                         USER OVERRIDE
     C     *LIKE         DEFINE    RESSTK        SAVSTK                         SAVE STATUS
     C     *LIKE         DEFINE    OEFL03        SAVFL3                         SAVE PRINT PICK TKT
     C     *LIKE         DEFINE    FAXF72        SAVFTK                         SAVE PRINT PICK TKT
     C     *LIKE         DEFINE    FAXARA        SVFARA                         SAVE FAX AREA
     C     *LIKE         DEFINE    FAXPRE        SVFPRE                         SAVE FAX PREFIX
     C     *LIKE         DEFINE    FAXSUF        SVFSUF                         SAVE FAX SUFFIX
     C     *LIKE         DEFINE    PICSEQ        SAVSEQ                         SAVE PICK SEQUENCE
     C     *LIKE         DEFINE    IVDN01        WKDN01
     C     *LIKE         DEFINE    ARCDF9        SVCDF9
     C     *LIKE         DEFINE    OECD01        SVCD01
     C     *LIKE         DEFINE    AGEOPT        PMAGOP
     C     *LIKE         DEFINE    OEDN01        SCDN01                         SHP VIA
     C     *LIKE         DEFINE    CUSERR        FBAERR
     C     *LIKE         DEFINE    CUSERR        DSP20G
     C     *LIKE         DEFINE    OECD01        CUSMOS                         ORIG MOS
     C     *LIKE         DEFINE    OEDN01        CUSSCD                         ORIG SH CODE
     C     *LIKE         DEFINE    SHPCOD        SVSCOD                         SHIP CODE
     C     *LIKE         DEFINE    OENO16        LINBR#                         BR# @LINE
      *
      * The following fields are for passing data to/from OER9050;
      *
     C     *LIKE         DEFINE    OENO26        PNO26                          Orig order no.
     C     *LIKE         DEFINE    OENO22        PNO22                          New line no  no
      *
      * The following fields are for passing data to/from OER9320;
      *
     C     *LIKE         DEFINE    IVNO07        PUOMI#
     C     *LIKE         DEFINE    LININ         PGMIN                                       no
     C     *LIKE         DEFINE    ARNO01        PLNO01
     C     *LIKE         DEFINE    ARNM01        PLNM01
     C     *LIKE         DEFINE    CROW          SROW
     C     *LIKE         DEFINE    CCOL          SCOL
     C     *LIKE         DEFINE    ERRMSG        SAVMSG
     C     *LIKE         DEFINE    OENO01        TRN#
     C     *LIKE         DEFINE    OENO26        TRNSEC
     C     *LIKE         DEFINE    OEQY03        SHPQTY
     C     *LIKE         DEFINE    OEQY03        ORIGBO
     C     *LIKE         DEFINE    TMPLIN        OLDLIN
     C     *LIKE         DEFINE    SBR           RBRN
     C     *LIKE         DEFINE    SBR           LBRN
     C     *LIKE         DEFINE    DATHLD        SAVHLD
     C     *LIKE         DEFINE    ARCDF9        CSCDF9
     C     *LIKE         DEFINE    ARCDB5        CSCDB5
     C     *LIKE         DEFINE    ARCD25        CSCD25
     C     *LIKE         DEFINE    ARCDF9        JBCDF9
     C     *LIKE         DEFINE    ARCDB5        JBCDB5
     C     *LIKE         DEFINE    ARCD25        JBCD25
     C     *LIKE         DEFINE    ARCDF9        OVCDF9
     C     *LIKE         DEFINE    ARCDB5        OVCDB5
     C     *LIKE         DEFINE    ARCD25        OVCD25
     C     *LIKE         DEFINE    OENO24        TAXCPY
     C     *LIKE         DEFINE    ARZP16        ZIPCPY
     C     *LIKE         DEFINE    OECD01        MOSCPY                         MTH OF SHIP
     C     *LIKE         DEFINE    ARST02        SSTCPY                         SHIP STATE
     C     *LIKE         DEFINE    OENO06        JOBCPY                         JOB#
     C     *LIKE         DEFINE    ARNO01        CSTCPY                         CUST#
     C     *LIKE         DEFINE    OENO08        SLBCPY                         SALE BR
     C     *LIKE         DEFINE    OENO24        SAVTJ
     C     *LIKE         DEFINE    ARZP16        ZPCD
     C     *LIKE         DEFINE    OENO24        TXCD
     C     *LIKE         DEFINE    OENO24        SLBR24                         SEL BR TX CD
     C     *LIKE         DEFINE    ARCDG8        SLBRG8                         SEL BR TX TY
     C     *LIKE         DEFINE    ARST03        SLBRST
     C     *LIKE         DEFINE    OENO01        SO#
     C     *LIKE         DEFINE    OENO19        CO#
     C     *LIKE         DEFINE    ARST02        SHIPST                         SHIP STATE
     C     *LIKE         DEFINE    OECD01        MOS                            MTH OF SHP
     C     *LIKE         DEFINE    TAXOPT        TAXFLG                         OTH TAX FLGS
     C     *LIKE         DEFINE    OECD01        SACD01                         SAV SHPMTH
     C     *LIKE         DEFINE    ARST02        SAST02                         SAV SHPSTATE
     C     *LIKE         DEFINE    OENO19        SVOA19
     C     *LIKE         DEFINE    OANO01        SVOA01
     C     *LIKE         DEFINE    ORDOAL        SVOA31
     C     *LIKE         DEFINE    FDSCYN        FDSCDF                         FRT DISCOUNT
     C     *LIKE         DEFINE    DDSCYN        DDSCDF                         DEL DISCOUNT
     C     *LIKE         DEFINE    HDSCYN        HDSCDF                         HAN DISCOUNT
     C     *LIKE         DEFINE    RDSCYN        RDSCDF                         RES DISCOUNT
     C     *LIKE         DEFINE    ODSCYN        ODSCDF                         OTHER DISCOUNT
     C     *LIKE         DEFINE    OENO19        CURRCO                                     NT
Q2   C     *LIKE         DEFINE    LDCUSN        LSCUSN                                     NT
RE   C     *LIKE         DEFINE    IVNO04        WC_IVNO04
0E   C     *LIKE         DEFINE    OEAM36        WTOTAL          + 2
SK    *
SK    * Parameter list for call to OER2075;
SK    *
SK   C     PL2075        PLIST
SK   C                   PARM                    TABCD             4
SK   C                   PARM                    RSNCD             9
SK   C                   PARM                    C@LOC#            6
SK   C                   PARM                    CRCD#            10
SK   C                   PARM                    CFLD#            10
SK   C                   PARM                    RSNDEC           30
SK   C                   PARM      'OE'          PGCD              2
ST    *
ST   C     PL2500        PLIST
ST   C                   PARM                    newmessage       20
ST   C                   PARM                    newurgent        20
ST   C                   PARM                    newtask          20
ST   C                   PARM                    newmqty           3 0
ST   C                   PARM                    newuqty           3 0
ST   C                   PARM                    newtqty           3 0
ST   C                   PARM                    msgcolor          1
      *
¢N   C     PL9978        PLIST
¢N   C                   PARM                    PL991            15
¢N   C                   PARM                    PL992            15
¢N   C                   PARM                    PLRTN             1
      * Parameter list for call to OER9050;
      *
     C     PL9050        PLIST
     C                   PARM                    PNO26                          Orig order n
     C                   PARM                    PNO22                          New line no
      *
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
     C                   PARM                    PMFLTA                         TAX AUTH FLAG
     C                   PARM                    OENO06                         JOB NUMBER
     C                   PARM                    PMTTYP                         TRANS TYPE
     C                   PARM                    ARNO01                         CUST#
     C                   PARM                    CALTYP            1            TAXCAL TYPE
     C                   PARM                    USAGE             1
      * 'USAGE' CONTAINS CODES FOR PROCESSING:
      *          O = ORDERED CALCS
      *          B = B/O CALCS
      *      BLANK = ALL OTHERS (SHIPPED, CONTRACTS, BIDS, ETC. - THESE
      *                          PROCESS OKAY SO KEEP ORIGINAL CALCS)
     C                   PARM                    WEBKEY           30            WEB ORD KEY
Z2   C                   Parm                    PiTaxMOS
Z2   C                   Parm                    PiTaxOrdTyp
Z2   C                   Parm                    PiTaxGenRef
Z2   C                   Parm                    PiTaxShpst
Z2   C                   Parm                    PiTaxTranType     3
      *
      * Parameter list for call to OER9302;
     C     PL9302        PLIST
     C                   PARM                    OENO01                         ORDER #
      *
     C     EDTDAT        PLIST
     C                   PARM                    PDATE             6 0
     C                   PARM                    PJULI             5 0
      *
     C     PLMBAL        PLIST
     C                   PARM                    OENO01                         ORDER#
     C                   PARM                    OENO19                         CONTRACT#
     C                   PARM                    ARNO01                         CUSTOMER
     C                   PARM                    OENO06                         JOB
     C                   PARM                    ARNO15                         COMPANY
     C                   PARM                    OEAM31           11 2
     C                   PARM                    OEAM32           11 2
     C                   PARM                    OEAM33           11 2
     C                   PARM                    OEAM34           11 2
     C                   PARM      'N'           F9100             1
     C                   PARM                    OE#OTY
     C                   PARM                    OE#NTY
     C                   PARM                    CO#TYP
     C                   PARM      'N'           ER9100            1
      *
     C     PL9200        PLIST
     C                   PARM                    OENO01                         ORDER#
     C                   PARM                    OENO19                         CONTRACT#
     C                   PARM                    ARNO01                         CUSTOMER
     C                   PARM                    PMNO06                         JOB
     C                   PARM                    ARNO15                         COMPANY
     C                   PARM                    OEAM31
     C                   PARM                    OEAM32
     C                   PARM                    OEAM33
     C                   PARM                    OEAM34
     C                   PARM      'N'           F9100
     C                   PARM      'O'           F9200             1            FROM O/E
     C                   PARM                    OE#OTY
     C                   PARM                    OE#NTY
     C                   PARM                    CO#TYP
     C                   PARM                    ER9200            9
     C                   PARM                    CAVAIL            9 2
     C                   PARM                    JAVAIL            9 2
     C                   PARM                    EAVAIL            9 2
     C     RLOCK         PLIST
     C                   PARM                    DSPERR
     C                   PARM                    DSPF1             1            DISPLAY RETRY?
     C                   PARM                    DSPF2             1            SCREEN RESPONSE
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
     C                   PARM                    OENO01                         ORDER #
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
     C                   PARM                    OENO01                         ORIG ORD #
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
X0   C                   PARM                    tabent2
X0   C                   PARM                    mode
     C     PL6200        PLIST
     C                   PARM                    CUSTNO                         CUST#
     C                   PARM                    RETCOD                         RETURN CODE
     C                   PARM                    ORDBY                          ORDERED BY
     C                   PARM                    FROMOE            1            FROM O/E FLAG
     C                   PARM                    XXNM01                         CUST NAME
     C                   PARM                    XXNO07                         CUST AREA CODE
     C                   PARM                    XXNO08                         CUST PH PREFIX
     C                   PARM                    XXNO09                         CUST PH SUFFIX
TB   c                   parm                    contactNbr                     CUST PH SUFFIX
     C     PL0026        PLIST
     C                   PARM                    USRNM
     C                   PARM                    APP
     C                   PARM                    LVL               2
     C                   PARM                    OPTION            2
     C                   PARM                    AUTH              1
     C     PL0060        PLIST
     C                   PARM                    VALUE#           30
     C                   PARM                    ACT#              1
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL2055        PLIST
     C                   PARM                    CUSTPO                         CUST P/O#
     C                   PARM                    CUSTNO                         CUST#
     C                   PARM                    RTNCDE
     C     PL5010        PLIST
     C                   PARM                    PMNM05                         CUS NAME
     C                   PARM                    PMNO07                         CUS PHN AREA
     C                   PARM                    PMNO08                         CUS PHN PREFIX
     C                   PARM                    PMNO09                         CUS PHN SUFFIX
     C                   PARM                    PMNO01                         CUS NUMBER
     C                   PARM                    RETCOD            1 0          RETURN CODE
     C                   PARM                    PMZP15                         CUS ZIP
     C                   PARM      'N'           ALWENT            1
     C     PL5211        PLIST
     C                   PARM                    TAXJUR            7 0
     C                   PARM                    RETCDE            1 0
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL5620        PLIST
     C                   PARM                    SBR#
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
     C     PL5420        PLIST
     C                   PARM                    NO15#
     C                   PARM                    ID02#
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL6053        PLIST
     C                   PARM                    ARNO01                         CUST#
     C                   PARM                    ARNM01                         CUST NAME
     C                   PARM                    ARNO07                         AREA CODE
     C                   PARM                    ARNO08                         TELEPHONE
     C                   PARM                    ARNO09                         NUMBER
     C                   PARM                    OENO06                         JOB#
     C                   PARM                    OENO07                         P/O#
     C                   PARM                    DSPMOD                         DSPLY MODE
     C                   PARM                    TRANS                          RETURN CODE
     C                   PARM                    USRNM
     C                   PARM                    JOBNME
     C                   PARM                    JOBNBR
     C                   PARM                    OENO01                         ORDER#
     C                   PARM                    CURRCO                         CURRENT C/O
QX   C                   PARM                    FRMOE             1            FROM O/E
     C     PL6055        PLIST
     C                   PARM                    PLNO01                         CUST#
     C                   PARM                    PLNM01                         CUST NAME
     C                   PARM                    IVNO07                         ITEM#
     C                   PARM                    ZZNO04                         PRODUCT#
     C                   PARM                    ZZDN01                         PROD DESC
     C                   PARM                    RTNCDE                         RETURN CODE
     C                   PARM                    DSPMOD            1            DSPLY MODE
     C                   PARM                    WDWFLG                         WINDOW FLAG
     C                   PARM                    C@LOC#                         CURSOR LOC
     C                   PARM                    CRCD#                          CURSOR RCD
     C                   PARM                    CFLD#                          CURSOR FLD
     C     QUOLST        PLIST
     C                   PARM                    OENO08                         BRANCH
     C                   PARM                    ARNO01                         CUSTOMER
     C     PL9400        PLIST
     C                   PARM                    SBR                            SHIP BRANCH
     C                   PARM                    IVNO07                         ITEM
     C                   PARM                    ARNO01                         CUSTOMER
     C                   PARM                    OENM15                         CUST CONTACT
     C                   PARM                    ZZNO04                         PRODUCT NO
     C                   PARM                    ZZDN01                         PRODUCT DESC
     C                   PARM                    DISPLY            1            DISPLAY MODE
     C                   PARM                    DIRORD            1            DIRECT/NDIRECT
     C                   PARM                    RTNCDE                         RETURN CODE
      *
     C     PL3450        PLIST
     C                   PARM                    IVNO07                         ITEM
     C                   PARM                    OEDN04                         ORD UOM
     C                   PARM                    QY12             14 9
     C                   PARM                    QQTY                           QTY ORD
     C                   PARM                    WDWFLG                         WINDOW FLAG
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM                    FRMAPP            1            FROM APP
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
      *
     C     PL2021        PLIST
     C                   PARM                    SFLDS                                      RE
     C                   PARM                    ARNO01
     C                   PARM                    ARCDB5                                     RE
     C                   PARM                    ARCD25                                     RE
     C                   PARM                    LSCDB5                                     RE
     C                   PARM                    LSCD25                                     RE
     C                   PARM                    REPRIC
     C                   PARM                    CUSCHG
     C                   PARM                    JOBCHG
     C                   PARM                    SLBCHG
     C                   PARM                    OAFLAG
     C                   PARM                    BDFLAG
     C                   PARM                    PRTTYP
     C                   PARM                    DLTCMT
     C                   PARM                    TFRGEN
     C                   PARM                    DIRSPC
     C                   PARM                    WALKIN
     C                   PARM                    LSTTRD
     C                   PARM                    OEFL08
     C                   PARM                    OECD08
     C                   PARM                    OECD03
     C                   PARM                    SHOWGP            1
     C                   PARM                    OENO08
     C                   PARM                    OENO16
     C                   PARM                    DFTBOQ
     C                   PARM                    MODE
     C                   PARM                    SV28              1
     C                   PARM                    PRCFLG
     C                   PARM                    WDWFLG                         WINDOW FLAG
     C                   PARM                    C@LOC#                         CURSOR LOCATION
     C                   PARM                    CRCD#                          CURSOR RECORD
     C                   PARM                    CFLD#                          CURSOR FIELD
     C                   PARM                    OENO06                         CURSOR FIELD
     C                   PARM                    DSPTRM                         TERMS AUTH
     C                   PARM                    AUTCP                          C/O prc auth
      * Parameter list for call to UDR;
     C     PLUDR         PLIST
     C                   PARM                    ZZFUNC            1
     C                   PARM                    ZZDATE            7 0
     C                   PARM                    ZZDAYS            5 0
     C                   PARM                    ZZDIFF            7 0
      * Parameter list for call to OPR2000;
     C     PL2000        PLIST
     C                   PARM                    PM2000           23 0
      * Parameter list for call to OER2062;
     C     PL2062        PLIST
     C                   PARM      '2'           ACCESS            1
     C                   PARM                    PODN10
     C                   PARM                    ZPONO1
     C                   PARM                    TAGXST            1
     C                   PARM                    ONTRF             1
     C                   PARM                    ONSO              1
     C                   PARM                    ONPO              1
     C                   PARM                    ONWO              1
     C                   PARM                    EXISTS            1
      *
      *
     C     PL4520        PLIST
     C                   PARM                    NO82#                          ENTERPRISE#
     C                   PARM                    NO01#                          CUSTOMER#
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C     PL1230        PLIST
     C                   PARM                    CSGBR             3 0          CONSIGN BR#
     C                   PARM                    FOUND             1
      *
     C     PL4947        PLIST
     C                   PARM                    PMIUPR
     C                   PARM                    PMIUCS
     C                   PARM                    PMIDSC
     C                   PARM                    PMONPR
   Q4C*    PL2010        PLIST
   Q4C*                  PARM                    WOS
   Q4C*                  PARM                    TYPPGM
   Q4C*                  PARM                    UPDADD
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
   RNC*                  PARM                    TRNNUM            7 0          TRANSFER NUMBER
RN   C                   PARM                    TRNNUM            7
     C     PL0302        PLIST
     C                   PARM                    ORGDOC           12                        BER
     C                   PARM                    NEWDOC           12                        BER
     C                   PARM                    REQTIM            6            REQUESTED FAX TIME
     C                   PARM                    REQDAT            6            REQUESTED FAX DATE
VW   C                   PARM                    SYSTEM            4            REQUESTED FAX DATE
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
      *
WJ   C     pl9602        plist
WJ   C                   parm                    arno01
WJ   C                   parm                    arno07
WJ   C                   parm                    arno08
WJ   C                   parm                    arno09
WJ   C                   parm                    arnm01
WJ   C                   parm                    tranum            7
WJ   C                   parm                    oeno08
WJ   C                   parm                    ccmode            1
WJ   C                   parm                    tratyp            1
WJ   C                   parm                    totchg            9 2
WJ   C                   parm                    cctaxa            9 2
WJ   C                   parm                    aprvd             1
WJ    *
WJ   C     pl9600        plist
WJ   C                   parm                    piMode
WJ   C                   parm                    piRetry
WJ   C                   parm                    piUpdError
WJ   C                   parm                    piTran
WJ   C                   parm                    piMFUKey
WJ   C                   parm                    piOrgOrd
WJ   C                   parm                    piMethod
WJ   C                   parm                    piTrnDtl
WJ   C                   parm                    piTrnAmt
WJ   C                   parm                    piTaxable
WJ   C                   parm                    piTaxAmt
WJ   C                   parm                    poSuccess
WJ   C                   parm                    poMsg
WJ   C                   parm                    poData
WJ   C                   parm                    piData
WJ    *
     C     PL0100        PLIST
     C                   PARM                    PMAGOP
      *
     C     PL9010        PLIST
     C                   PARM                    USRNM
     C                   PARM      '12'          PSN               2
     C                   PARM                    AUTHTY            1
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
     C                   PARM                    TXTYP             1            TRANS TYPE
     C                   PARM                    SCBRAN            3 0          SHP BRANCH
     C                   PARM                    OECD01                         SHP METHOD
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
   RNC*                  PARM                    TRNNUM            7 0          TRANSACTION REQUEST
RN   C                   PARM                    TRNNUM            7
VX    *
VX   C     PL0304        PLIST
VX   C                   PARM                    SYSID                          APPLICATION COD
VX   C                   PARM                    DOCNUM                         DOCUMENT (BID#)
VX   C                   PARM                    REQTIM                         REQUESTED FAX TIME
VX   C                   PARM                    REQDAT                         REQUESTED FAX DATE
VX   C                   PARM                    TRNNUM                         BID NUMBER
VX   C                   PARM                    JOBNME                         JOB NAME
VX   C                   PARM                    JOB##             6            JOB NUMBER
   VXC*    PL0315        PLIST
VX   C     PL0316        PLIST
     C                   PARM                    ARNO01
     C                   PARM                    ETYPE             2
     C                   PARM                    EMAIL
     C                   PARM                    C@LOC#            6
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
VX   C                   PARM                    DOCTP             4
VX   C                   PARM                    DOC#             12
VX   C                   PARM                    REQTIM                         REQUESTED TIME
VX   C                   PARM                    REQDAT                         REQUESTED DATE
     C     PL0510        PLIST
     C                   PARM                    LBLINE            5
     C                   PARM                    LBBRN             3
     C                   PARM                    LBITM             6
     C     PL0600        PLIST
     C                   PARM                    UJOB              1            USE JOB KEY
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
     C                   PARM                    LRETRN            1            LOT RETURN  M
     C     PL0601        PLIST
     C                   PARM                    LFUNC             1            LOT FUNCTION
     C                   PARM                    TRN#                           TRANSACTION#
     C                   PARM                    TRNSEC                         SECONDARY#
     C                   PARM      'SO'          TRNTYP            2            TRAN TYPE
     C                   PARM                    TRNLIN            5 0          TRAN LINE #
     C                   PARM                    TRNSTS            1            TRAN STATUS
     C                   PARM                    UJOB              1            USE JOB KEY
     C                   PARM                    LLINE#                         TEMP LINE#
     C                   PARM                    LEXIST            1            LOT EXISTS
     C     WHSINQ        PLIST
     C                   PARM                    RTCDE             1
     C                   PARM                    ACTCOD            2
     C                   PARM                    PFUNKY            2
     C                   PARM                    PRMDTA
     C     PL0810        PLIST
     C                   PARM                    PM0810
     C     PLHZ01        PLIST
     C                   PARM                    CITEM                          CHEM ITEM#
     C                   PARM                    OECD01                         MOS
     C                   PARM                    SHPCOD                         SHIP CODE
     C                   PARM                    HZRTNC            1            RETURN CODE
     C     PL3434        PLIST
     C                   PARM                    ASCITM                         CHEM ITEM#
     C                   PARM                    REQCDE            1
      *
     C     PL8220        PLIST
     C                   PARM                    USER             10
     C                   PARM                    APP
     C                   PARM                    CDE               4
     C                   PARM                    ID                4 0
     C                   PARM                    USRVAL           10
     C                   PARM                    VALFRM            1
     C                   PARM                    RTNCOD            1
WG    *
WG   C     PL8225        PLIST
WG   C                   PARM                    USER             10
WG   C                   PARM                    APP
WG   C                   PARM                    CDE               4
WG   C                   PARM                    ID                4 0
WG   C                   PARM                    UVA              10
WG   C                   PARM                    VALFRM            1
WG   C                   PARM                    RTNCOD            1
WG XHC*                  PARM                    RTVGV             1
      *
     C     PL4900        PLIST
     C                   PARM                    ORGCST           11 5
     C                   PARM                    OECD27
     C                   PARM                    ITEMNO            6
     C                   PARM                    CBR               3
     C                   PARM                    CTYPE             1
     C     PL9100        PLIST
     C                   PARM                    ZPCD
     C                   PARM                    TXCD
     C                   PARM                    RETFLG            1 0
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
   RF *----------------------------------------------------*
   RFC*    PL6100        PLIST
   RFC*                  PARM                    BRANCH            3
   RFC*                  PARM                    NSITM#           12
   RFC*                  PARM                    QTYOH             7 0
   RFC*                  PARM                    QTYAVL            7 0
   RFC*                  PARM                    NSCOST            9 4
   RFC*                  PARM                    NSCTRN            2 0
   RFC*                  PARM                    POCOST            9 4
      *----------------------------------------------------*
RB    *
RB   C     PL1800        PLIST
RB   C                   PARM                    REQ               1
RB   C                   PARM                    BRANCH            3
RB   C                   PARM                    ITEM#             6
RB   C                   PARM                    TRAN#             7
RB   C                   PARM                    TRNTYP            2
RB   C                   PARM                    TRNLIN#           3
RB   C                   PARM                    QTYNED            7 0
RB   C                   PARM                    CUSTNO            6 0
RB   C                   PARM                    CMPNY#            3 0
RB   C                   PARM                    TRNIOC            1
RB   C                   PARM                    ITEMTY            1
RB   C                   PARM                    F11_ALLOWED       1
R5   C                   PARM                    F12_CANCEL        1
RX   C                   PARM                    QTYCDE            1
TH   C                   PARM                    SRL_FLAGS
TH   C                   PARM      *zeros        trannum
TM   C                   parm      *blanks       SRLNBR
$8   C                   PARM                    DIRECTORDER       1
      *
     C     PL9316        PLIST
     C                   PARM                    SHIPST                         SHIP STATE
     C                   PARM                    MOS                            MTH OF SHP
     C                   PARM                    TAXFLG                         OTH TAX FLGS
     C     PL9003        PLIST
     C                   PARM                    TRANUM            7
     C                   PARM                    TRATYP            1
     C                   PARM                    TOTCHG            9 2
     C                   PARM                    CARD              1
     C                   PARM                    PMODE             1
      *
RK   C     PL0061        PLIST
RK   C                   PARM                    ROLEX            14 0
TB    *
TB   C     PL2500X       PLIST
TB   C                   PARM                    PGMNAM2          10
TB   C                   PARM                    RCCALL            1
TF   C     PL1015        PLIST
TF   C                   PARM                    sRetCd
TF   C                   PARM                    sActCd
TF   C                   PARM                    sFunKy
TF   C                   PARM                    sData
TF   C                   PARM                    OEDS
WC    *
WC   C     PL1300        PLIST
WC   C                   PARM                    p1300App
WC   C                   PARM                    p1300Bypass
WC    *
WG   C     pl6043        plist
WG   C                   PARM                    p@cust            6 0          CUST #
WG   C                   PARM                    p@pdds           50            PDDS-48
WG   C                   PARM                    p@item            6 0          ITEM #
WG   C                   PARM                    p@sellbr          3 0          SELL BR#
WG   C                   PARM                    p@shipbr          3 0          SHIP BR#
WG   C                   PARM                    p@denter          6 0
WG   C                   PARM                    p@selnet         10 4
WG   C                   PARM                    p@cost            7 2
WG   C                   PARM                    p@gmperc          4 1
WG   C                   PARM                    p@prloc          11
WG   C                   PARM                    p@seloc          11
X0    *
X0   C     pl0400        plist
X0   C                   parm                    pmiapl            2
X0   C                   parm                    pmoyn             1
X0    *
X0   C     p_air9050     Plist
X0   C                   Parm                    Msg9050
X0   C                   Parm                    ErrCd
X0    *
X0   C     pl9010Adr     Plist
X0   C                   Parm                    piLine1
X0   C                   Parm                    piLine2
X0   C                   Parm                    piLine3
X0   C                   Parm                    piCity
X0   C                   Parm                    piState
X0   C                   Parm                    PiCountry
X0   C                   Parm                    PiZip
X0   C                   Parm                    PoErrCode
X0   C                   Parm                    PoErrMessage
0P   C                   parm                    PoLat
0P   C                   parm                    PoLng
X0    *
X0   C     PL9350        PLIST
X0   C                   Parm                    PiNumOfItems
X0   C                   Parm                    pCustomerCode
X0   C                   Parm                    pDocCode
X0   C                   Parm                    pDocType
X0   C                   Parm                    pDocDate
X0   C                   Parm                    pSellBr
X0   C                   Parm                    pShipFromBr
X0   C                   Parm                    pDAddress1
X0   C                   Parm                    pDAddress2
X0   C                   Parm                    pDAddress3
X0   C                   Parm                    pDCity
X0   C                   Parm                    pDState
X0   C                   parm                    pDCountry
X0   C                   Parm                    pDZipCode
X0   C                   Parm                    pCommitTran
X0   C                   Parm                    pTax_lineitems
X0   C                   Parm                    POrgOrder
X0   C                   Parm                    pTaxRate
X0   C                   Parm                    pTaxAmt
X0   C                   Parm                    pGstRate
X0   C                   Parm                    pGstAmt
X0   C                   Parm                    pHstRate
X0   C                   Parm                    pHstAmt
X0   C                   Parm                    pPstRate
X0   C                   Parm                    pPstAmt
X0   C                   Parm                    pTaxableAmt
X0   C                   Parm                    pNTaxableAmt
X0   C                   parm                    PErrCode
X0   C                   parm                    PErrMsg
X0   C                   parm                    PiAPIRqstTyp
X0   C                   parm                    PiTranType
X0   C                   parm                    PiBillType
X0   C                   parm                    PiTranNum
X0   C                   parm                    PCustPoNum
X0   C                   parm                    PJobNum
X0   C                   parm                    PiUpdTax
X0   C                   parm                    PiTaxOvrAmt
X0   C                   parm                    PiFrtAmt
X0   C                   parm                    PiFrtDesc
X0   C                   parm                    PiDelAmt
X0   C                   parm                    PiDelDesc
X0   C                   parm                    PiHdlAmt
X0   C                   parm                    PiHdlDesc
X0   C                   parm                    PiRstAmt
X0   C                   parm                    PiRstDesc
X0   C                   parm                    PiOthAmt
X0   C                   parm                    PiOthDesc
0E   C                   parm                    PiCCPAmt
0E   C                   parm                    PiCCPDesc
X0   C                   parm                    PiCustNum
X0   C                   Parm                    PiPgmName
X0   C                   Parm                    PiMisc
X0   C                   Parm                    PiHdrUpd
Z2   C                   Parm                    PiTaxMOS
Z2   C                   Parm                    PiTaxOrdTyp
Z2   C                   Parm                    PiTaxGenRef
Z2   C                   Parm                    wTaxTyp
Z2   C                   PARM                    PMFLTA                         TAX AUTH FLAG
Z2   C                   Parm                    PoTaxAmt1
Z2   C                   Parm                    PoTaxNum1
X0    *
YK   C     PL9040        PLIST
YK   C                   Parm                    pCompanyCode
YK   C                   Parm                    pDocCode
YK   C                   Parm                    pDocType
YK   C                   Parm                    pCancelCode
YK   C                   parm                    PErrCode
YK   C                   parm                    PErrMsg
YK    *
X0   C     pl9351        Plist
X0   C                   Parm                    PMode
X0   C                   Parm                    PiBillType
X0   C                   Parm                    PiTranNum
X0   C                   Parm                    PiTranType
X0   C                   Parm                    piAPIRqstTyp
X0   C                   Parm                    PDocCode
X0   C                   Parm                    PDocType
X0    * Tax status 01 = success, 02 = error
X0   C                   Parm                    PiTaxSts
X0   C                   Parm                    PiTaxErrCd
X0   C                   Parm                    PTaxRate
X0   C                   Parm                    PTaxAmt
X0   C                   Parm                    PGSTRate
X0   C                   Parm                    PGSTAmt
X0   C                   Parm                    PHSTRate
X0   C                   Parm                    PHSTAmt
X0   C                   Parm                    PPSTRate
X0   C                   Parm                    PPSTAmt
X0   C                   Parm                    PTaxableAmt
X0   C                   Parm                    PNtaxableAmt
X0   C                   Parm                    PErrMsg
X0   C                   parm                    PiUpdTax
X0   C                   parm                    PiTaxOvrAmt
X0   C                   Parm                    PiPgmName
X0   C                   Parm                    PiMisc
X0   C                   Parm                    PiHdrUpd
YQ    *
YQ   C     pl0003        plist
YQ   C                   parm                    oeno19                         ORDER#
YT   C     PL9060        Plist
YT   C                   parm                    PCompanyCode
YT   C                   parm                    pDocCode
YT   C                   parm                    PDocType
YT   C                   parm                    PErrCode
YT   C                   parm                    PErrMsg
YT   C                   parm                    poDocSts
YT   C                   parm                    poTotAmt
YT   C                   parm                    poTotNonTax
YT   C                   parm                    poTotTax
YT   C                   parm                    poTotTaxble
YT   C                   parm                    PoTaxOvrAmt
YT   C                   parm                    PoTaxDetail
Y0    *
Y0   C     plDev         plist
Y0   C                   parm                    pbranch           3 0
Y0   C                   parm                    pUser97          10
Y0   C                   parm                    pDevName         30
Y0   C     pl9701        plist
Y0   C                   parm                    info_msg
Y0   C     pl9703        plist
Y0   C                   parm                    pRetry            1
Y2    *
Y2   C     pl9352        plist
Y2   C                   parm                    pComp#            3
Y2   C                   parm                    pCust#            6 0
Y2   C                   parm                    pJob#             7
Y2   C                   parm                    pTran#            7
Y2   C                   parm                    pTranType         3
Y2   C                   parm                    PShipBrn          3
Y2   C                   parm                    PSellBrn          3
Y2   C                   parm                    pTaxable          9 2
Y2   C                   parm                    pNtaxable         9 2
Y2   C                   parm                    pTaxRate          6 6
Y2   C                   parm                    pTaxAmount        9 2
Y2   C                   parm                    pRqsType          3
Y2   C                   parm                    pLogType          1
Y2   C                   parm                    pPgmName          8
Y2   C                   parm                    pErrorCd         50
Y2   C                   parm                    pErrorMsg       150
ZR    *
ZR   C     PL9704        Plist
ZR   C                   PARM                    crdmth
ZR   C                   PARM                    usingAVS
ZR   C                   PARM                    usingCVV
ZR   C                   PARM                    billzp
ZR   C                   PARM                    crdcvv
ZR    *
ZR   C     PL9705        Plist
ZR   C                   PARM                    usingAVS
ZR   C                   PARM                    usingCVV
ZJ    *
ZJ   C     PL9751        Plist
ZJ   C                   PARM                    COF_Mode
ZJ   C                   PARM                    Cust_Num
ZJ   C                   PARM                    Cust_Type
ZJ   C                   PARM                    PoToken
ZJ   C                   PARM                    PoExpcc
ZJ   C                   PARM                    PoExpyr
ZJ   C                   PARM                    PoExpmo
ZJ   C                   PARM                    PoNAME
ZU   C                   PARM                    PoNetTrnID
ZY   C                   PARM                    PoTokenSubmted
Y3    *
Y3   C     pl2023        plist
Y3   C                   parm                    povcust           6 0
Y3   C                   parm                    walkin
Y3   C                   parm      *Blanks       ovrordr
Y3   C                   parm                    povsell           3 0
Y3   C                   parm                    povship           3 0
Y3   C                   parm                    povjobno          7
Y3   C                   parm                    povjobnm         15
Y3   C                   parm                    povcstpo         22
Y3   C                   parm                    overridereject
Y3   C                   parm                    SVRRN
Y3   C                   parm                    From2020
ZV    *
ZV   C     PL2190        PLIST
ZV   C                   PARM                    LSMENU            2
ZV   C                   PARM                    LSBRCH            3
ZV   C                   PARM                    LSCUST            6
ZV   C                   PARM                    LSORDR            7
ZV   C                   PARM      *BLANKS       LSITEM            6
ZU    *
ZU   C     pl9805        PLIST
ZU   C                   PARM                    piMode
ZU   C                   PARM                    piRetry
ZU   C                   PARM                    piUpdError
ZU   C                   PARM                    piTran
ZU   C                   PARM                    poData
ZU   C                   PARM                    piData
ZU   C                   Parm                    PoErrCode
ZU   C                   Parm                    PoErrMsg
ZU    *
Z3   C     PL9201        PLIST
Z3   C                   PARM                    ARNO01
Z3   C                   PARM      *ZEROS        AddOn_OvrPct
Z4    *
Z4   C     PL2312        PLIST
Z4   C                   PARM                    ARNO01                         ORDER#
Z4   C                   PARM                    OENO01                         ORDER#
Z4   C                   PARM      'S/O'         JTRNTYP           3
Z4   C                   PARM      'E'           JSAMODE           1
Z4   C                   PARM      *BLANK        JSAREQ            1
0E   C     PL9707        PLIST
0E   C                   PARM                    TRANS_TYPE        3
0E   C                   PARM                    CARDAMOUNT
0E   C                   PARM                    CCPFEE
0E   C                   PARM                    CCPAPR_FLG        1
0E   C     PL2039        PLIST
0E   C                   PARM                    NEWDEP
      *
¢A1   *
¢A1  C     PL9991        PLIST
¢A1  C                   PARM                    oecd01
¢A1  C                   PARM                    oeno16
¢A1  C                   PARM                    pitem
¢A1  C                   PARM                    zzno04
¢A1  C                   PARM                    oeno19
¢A1  C                   PARM                    oeno43
¢A1  C                   PARM                    oecd26
¢A1  C                   PARM                    oepc01
¢A1  C                   PARM                    oecd08
¢A2  C                   PARM                    gppct1
¢A1  C                   PARM                    id01s
¢A1  C                   PARM                    arno01
¢A1  C                   PARM                    oecd28
¢A1  C                   PARM                    ret991            1
:D   C     UTRP2021      PLIST
:D   C                   PARM                    OENO01
:D   C                   PARM                    WrkDFNO15
:D   C                   PARM                    WrkOENO08
:D   C                   PARM                    WrkOECD01
:D   C                   PARM                    WrkARCDC6
:D   C                   PARM                    WrkPgm
:J    *
:J   C     PLC510        PLIST
:J   C                   parm      *blanks       prClaim          10
:J   C                   parm                    prCust            6
:J   C                   parm                    prRANbr          10
:J   C                   parm      *blanks       prStatus         10
:J   C                   parm      *blanks       prClaimTxt      207
#F   C     PL_OERC022    PLIST
&G   C                   PARM                    ARNO15
#F   C                   PARM                    PROGNAME         10
#F   C                   PARM                    ORDERTYPE         1
#F   C                   PARM                    METHODSHIP        1
#F   C                   PARM                    SHIPCODE          2
#F   C                   PARM                    SERIALTAG         1
#F   C                   PARM                    OPENBO            1
#F   C                   PARM                    ORDSTATUS         1
#F   C                   PARM                    WRITEOF           1
#F   C                   PARM                    SHIPCOMP          1
#F   C                   PARM                    PRINTTKT          1
#F   C                   PARM                    DEFAULTFOUND      1
#J   C     PL_OERC026    PLIST
#J   C                   PARM                    OENO08
#J   C                   PARM                    OECD01
#J   C                   PARM                    USEDEFAULT        1
#L   C     PL_OERC027    PLIST
#L   C                   PARM                    OENO08
#O   C                   PARM                    OECD01
#L   C                   PARM                    PROM_DATE         6 0
#L   C                   PARM                    RLS_DATE          6 0
#P   C                   PARM                    Date_flag         1
      *------------------------------------------------------------------------*
     C     CMKEY         KLIST
     C                   KFLD                    IVNO7
     C     TABKEY        KLIST
     C                   KFLD                    TABCOD            4            TABLE CODE
     C                   KFLD                    TABENT            9            TABLE ENTRY
     C     NOTKEY        KLIST
     C                   KFLD                    ARNO01                         CUSTOMER #
     C                   KFLD                    RCDCDE            1            RECORD CODE
     C     BRIKEY        KLIST
     C                   KFLD                    OENO16                         SHIP BRANCH
     C                   KFLD                    IVNO07                         OUR ITEM #
     C     BRKEY2        KLIST
     C                   KFLD                    IVNO07                         OUR ITEM #
     C                   KFLD                    SBR                            BRANCH
     C     BRKEY3        KLIST
     C                   KFLD                    IVNO07                         OUR ITEM #
     C                   KFLD                    OENO08                         SELL BRANCH
   RBC*    KEYSRL        KLIST
   RBC*                  KFLD                    IVNO07                         OUR ITEM #
   RBC*                  KFLD                    OENO25                         SERIAL NO.
     C     PONSTK        KLIST
     C                   KFLD                    PN1                            P.O. NUMBER
     C                   KFLD                    PN5                            LINE NUMBER
     C     POKEY         KLIST
     C                   KFLD                    RN1                            P.O. NUMBER
     C                   KFLD                    RN5                            LINE NUMBER
     C     CUSCPY        KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    ARNO15                         COMPANY
     C     SLSCPY        KLIST
     C                   KFLD                    OEID02                         CUSTOMER
     C                   KFLD                    ARNO15                         COMPANY
     C     PCKEY         KLIST
     C                   KFLD                    SECPRF                         PROFILE#
     C                   KFLD                    ARNO15                         CO#
   TDC*    PXKEY         KLIST
   TDC*                  KFLD                    SECPRF                         PROFILE#
   TDC*                  KFLD                    ZRNO15                         ZERO COMPANY
     C     JOBKEY        KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    OENO06                         JOB NUMBER
RD   C     JOBKY1        KLIST
RD   C                   KFLD                    ARNO01                         CUSTOMER
RD   C                   KFLD                    OANO06                         JOB NUMBER
     C     OAKEY         KLIST
     C                   KFLD                    OANO01                         ORDER #
     C                   KFLD                    OANO31                         C/O CNTL #
     C     OAKEY1        KLIST
     C                   KFLD                    OANO01                         ORDER #
     C                   KFLD                    ORDOAL                         LINE CTL #
     C     OAKEY2        KLIST
     C                   KFLD                    OANO01                         ORDER #
     C                   KFLD                    OADOAL                         LINE CTL #
     C     OATGK         KLIST
     C                   KFLD                    OANO01                         ORDER #
     C                   KFLD                    OANO32                         C/O TAG #
     C     OABRK         KLIST
     C                   KFLD                    OANO16                         BRANCH
     C                   KFLD                    AVNO07                         ITEM #
     C     OACMBO        KLIST
     C                   KFLD                    OANO01                         ORDER #
     C                   KFLD                    OANO33                         COMBO #
     C     OACMB2        KLIST
     C                   KFLD                    OANO01                         ORDER #
     C                   KFLD                    OANO33                         COMBO #
     C                   KFLD                    OANO36                         COMBO #
     C     QUOKEY        KLIST                                                  QUOTES
     C                   KFLD                    OENO08                         BRANCH
     C                   KFLD                    ARNO01                         CUSTOMER
     C     AKEY          KLIST
     C                   KFLD                    ARNO01                         CUSTOMER
     C                   KFLD                    ARCDA1                         SHIP ADDRESSES
     C     ALIKEY        KLIST                                                  ALIAS
     C                   KFLD                    ZZNO04                         PROD #
     C                   KFLD                    WKCUST                         CUSTOMER
     C     BIDKEY        KLIST
     C                   KFLD                    OBNO43                         ORDER #
     C                   KFLD                    OBNO31                         LINE CTL #
     C     BIDKY1        KLIST
     C                   KFLD                    OBNO43                         ORDER #
     C                   KFLD                    ORDBDL                         C/O CNTL #
     C     BDTGK         KLIST
     C                   KFLD                    OBNO43                         ORDER #
     C                   KFLD                    OBNO32                         C/O TAG #
     C     SIKEY         KLIST
     C                   KFLD                    OANO01
     C                   KFLD                    OACD11
     C     JOBRKY        KLIST
     C                   KFLD                    USRNM
     C                   KFLD                    JOBNME
     C                   KFLD                    JOBNUM
     C                   KFLD                    RCDE
     C     JOBTKY        KLIST
     C                   KFLD                    USRNM
     C                   KFLD                    JOBNME
     C                   KFLD                    JOBNUM
     C                   KFLD                    RRNO01
     C                   KFLD                    RRNO22
     C     KEYLLN        KLIST
     C                   KFLD                    OENO19
     C                   KFLD                    ORDOAL
     C     KEYLOT        KLIST
     C                   KFLD                    OENO19
     C                   KFLD                    ORDOAL
     C                   KFLD                    OENO56
      *
     C     EBKEY         KLIST
     C                   KFLD                    ENTNBR                         ENTERPRISE
     C                   KFLD                    ARNO15                         COMPANY
RA   C     NSBKEY        KLIST
RA   C                   KFLD                    NBNO10                         BRANCH
RA   C                   KFLD                    NBNON1                         N/S ID
TF    *
TF   C     KRkey         klist
TF   C                   kfld                    sbr                            BRANCH
TF   C                   kfld                    ivno07                         N/S ID
V3   C     KeyClip1      klist
V3   C                   kfld                    SessioNmMv
V3   C                   kfld                    EnttypCdMv
V3   C                   kfld                    Clipk1CdMv
V3   C                   kfld                    Clipk2CdMv
V3   C                   kfld                    Clipk3CdMv
V3   C                   kfld                    Clipk4CdMv
V3   C                   kfld                    Clipk5CdMv
Z0   C     KeyClip2      klist
Z0   C                   kfld                    SessioNmMv
Z0   C                   kfld                    EnttypCdMv
WG   C     KeyClip1a     klist
WG   C                   kfld                    SessioNmMv
WG   C                   kfld                    EnttypCdMv
WG   C                   kfld                    Clipk1CdMv
WG   C     Key2020S      klist
WG   C                   kfld                    Exportkey
WG   C                   kfld                    rrnsd
WJ   C     TraKey        klist
WJ   C                   kfld                    oeno01
WJ   C                   kfld                    trantyp                                    Y?
X0    *
Y0   C     TraKey1       klist
Y0   C                   kfld                    kTran             7
Y0   C                   kfld                    trantyp
Y0    *
X0   C     k_Tbl3        klist
X0   C                   kfld                    kTbl                           ITEM#
X0   C                   kfld                    kDsc                           PRICING UOM
Y0   C     kCsc3         klist
Y0   C                   kfld                    oeno08                         ITEM#
Y0   C                   kfld                    kCode             1            PRICING UOM
Y0    *
Y0   C     kCCD1         klist
Y0   C                   kfld                    kBranch           3 0
0N   C                   kfld                    card_softtype
Y0   C                   kfld                    kDevName
ZB   C     CUA4KEY       klist
ZB   C                   kfld                    arno01
ZB   C                   kfld                    OPNM25
ZD    *
ZD   C     k_Ba2         klist
ZD   C                   kfld                    oeno43                         ITEM#
ZD   C                   kfld                    wAdrTyp           1            PRICING UOM
ZE    *
ZE   C     k_Upe         klist
ZE   C                   kfld                    kUser            10            ITEM#
ZE   C                   kfld                    kApp              2            PRICING UOM
ZE   C                   kfld                    kAppCde           4            PRICING UOM
ZE   C                   kfld                    KAppId            4 0          PRICING UOM
ZF   C     MsbrKey       klist
ZF   C                   kfld                    oecd01
ZF   C                   kfld                    shpcod
ZF   C                   kfld                    oeno16
ZJ    *
ZJ   C     kTCCTD        KLIST
ZJ   C                   KFLD                    arno01
ZJ   C                   KFLD                    cdf4
ZJ   C                   KFLD                    kfla5
Z1    *
Z1   C     ADDONKY       KLIST
Z1   C                   KFLD                    IVNO07
Z1   C                   KFLD                    OPNM25
Z1   C                   KFLD                    OPCD31
Z1   C                   KFLD                    OPCD34
:I   C     CARDKEY       KLIST
:I   C                   KFLD                    OENO01
:I   C                   KFLD                    TRAN_TYPE         1
      *****************************************************************
      *  SECTION 1      PROCESS ORDER ENTRY MAINLINE
      ***********
      * STEP 1. * PROGRAM INITIALIZATION
      ***********
      * STEP 2. * ZERO/BLANK OUT FIELDS & CUSTOMER PROMPT
      ***********
      * STEP 3. * EDIT HEADER INFORMATION
      ***********
      * STEP 4. * DETAIL LINE ITEMS
      ***********
      * STEP 5. * RETURNED ITEM REASON CODE AND DAMAGED ITEM TAG #'S
      ***********
      * STEP 6. * CASH SALES ENTRY
      ***********
      * STEP 7. * SUMMARY SCREEN
      *****************************************************************
      * STEP 1. * PROGRAM INITIALIZATION
      ***********
     C     *DTAARA       DEFINE    *LDA          PARAM
     C     *DTAARA       DEFINE                  NXTTDD
     C                   IN        PARAM
     C                   Z-ADD     1             INDX
     C     INDX          DOUGT     50
     C     INDX          OCCUR     SVOEDS
     C                   CLEAR                   SVOEDS
     C                   ADD       1             INDX
     C                   END
     C     *DTAARA       DEFINE                  NSITEM                         NON STOCK ITEM
     C                   UNLOCK    NSITEM                                       NUMBER
     C                   MOVE      '01'          PMTTYP
     C                   MOVE      '3'           CLROPT            1
     C                   MOVEL     'OEPWTA'      FILE             10
     C                   CALL      'OPC9990'
     C                   PARM                    CLROPT
     C                   PARM                    FILE
¢A5  C     *DTAARA       DEFINE                  PERZIP
¢A5  C                   IN        perzip                                       AUDIT TRANS
     C                   EXSR      INITSR
ST   C                   EXSR      CHECKMAIL
ZQ    *
ZQ    * Set SD user function key  preference.
ZQ   C                   MOVE      USRNM         USER
ZQ   C                   MOVE      'OE'          APP
ZQ   C                   MOVEL     'SD1'         CDE
ZQ   C                   MOVE      0001          ID
ZQ   C                   MOVE      *BLANKS       USRVAL
ZQ   C                   MOVE      *BLANKS       VALFRM
ZQ   C                   MOVE      *BLANKS       RTNCOD
ZQ   C                   CALL      'OPR8220'     PL8220
ZQ   C     RTNCOD        IFEQ      '0'
ZQ   C                   MOVEL     USRVAL        sd1fkey           1
ZQ   C                   ELSE
ZQ   C                   MOVE      *BLANKS       sd1fkey
ZQ   C                   ENDIF
ZQ   C                   eval      sd1key = ' '
ZQ   C                   If        %subst(wsname:1:3) = 'QQF' and sd1fkey = 'Y'
ZQ   C                   eval      sd1key = 'F'
ZQ   C                   endif
$5
$5    * GET THE SMALL DOLLAR AUTO RELEASE AMOUNT
$5   C     *DTAARA       DEFINE    SMDLAURT      SMLORDAMT
$5   C                   IN        SMLORDAMT
$5
#L   C     UDATE         MULT      10000.01      TODAYS_DATE       6 0
      ***********
      * STEP 2. * ZERO/BLANK OUT FIELDS & CUSTOMER PROMPT
      ***********
     C     CUSTAG        TAG
      *
      * IF EXIT OR RESET CHECK TO SEE IF ANY ITEMS RELEASED FROM
      * RESERVE ORDER, IF SO WE WILL NEED TO UNLOCK THE RECORDS
      * AND CLEAR OUT THE WORKFILE.
      *
     C     F3EXIT        IFEQ      'Y'
     C     F5RSET        OREQ      'Y'                                          RESET
     C     UNLFLG        IFEQ      'Y'
     C                   MOVE      'L'           DSPMOD
     C                   MOVE      *BLANKS       JOBNBR                         JOB NUMBER
     C                   MOVE      JOBNUM        JOBNBR                         JOB NUMBER
     C                   CALL      'OER6053'     PL6053
     C                   END
     C                   END
      *
     C     F3EXIT        IFEQ      'Y'                                          EXIT
     C     MODE          ANDEQ     'I'                                          INTERACTIVE
     C     OENO01        ANDNE     *ZERO
RN   C     OENO01        ANDNE     *BLANKS
     C     F5RSET        OREQ      'Y'                                          RESET
     C     MODE          ANDEQ     'I'                                          INTERACTIVE
     C     OENO01        ANDNE     *ZERO
RN   C     OENO01        ANDNE     *BLANKS
     C                   Z-ADD     UMONTH        OEMO03                         LAST UPDATE MO
     C                   Z-ADD     UDAY          OEDY03                         LAST UPDATE DY
     C                   MOVEL     *YEAR         OECC03                         LAST UPDATE CC
     C                   Z-ADD     UYEAR         OEYR03                         LAST UPDATE YR
     C                   Z-ADD     UMONTH        OEMO02                         LAST UPDATE MO
     C                   Z-ADD     UDAY          OEDY02                         LAST UPDATE DY
     C                   MOVEL     *YEAR         OECC02                         LAST UPDATE CC
     C                   Z-ADD     UYEAR         OEYR02                         LAST UPDATE YR
     C                   Z-ADD     *ZERO         DATPRM                         DATE PROMISED
     C                   Z-ADD     *ZERO         OECC07                         CENTURY PROMISED
     C                   MOVE      USRNM         OENM01                         USER ID
     C                   MOVE      'Y'           OECD25                         UNUSED ORDER #
     C                   Z-ADD     0             RNS                            TOTAL RNS ITMS ON S/
     C     OPNTOV        IFNE      '1'
     C                   OPEN      OELTOV1
     C                   MOVE      '1'           OPNTOV            1
     C                   END
     C     OENO26        IFEQ      *ZEROS
RN   C     OENO26        OREQ      *BLANKS
RN   C                   MOVE      OENO01        OENO26
   RNC*                  Z-ADD     OENO01        OENO26
     C                   ENDIF
     C                   WRITE     OEFTOV                                       VOID ORDERS
:X   C     OPNSB1        IFNE      '1'
:X   C                   OPEN      IVLMSBR1
:X   C                   MOVE      '1'           OPNSB1            1
:X   C                   ENDIF
:X   C                   Z-ADD     1             X
:X   C     X             DOUGT     400
:X   C     X             OCCUR     SAVDS
:X   C                   IF        ORDITM = *BLANKS AND
:X   C                             ORDDSC = *BLANKS
:X   C                   LEAVE
:X   C                   ENDIF
:X   C                   EVAL      IVNO04 = ORDITM
:X   C                   EVAL      IVNO07 = ORDNO7
:X   C                   EVAL      IVDN02 = ORDDN2
:X   C                   EVAL      OENO09 = X
:X   C                   EVAL      OEQY01 = ORDQTY
:X   C                   EVAL      OEQY02 = ORDBKO
:X   C                   EVAL      OEQY03 = ORDSHP
:X   C                   EVAL      OEAM01 = ORDAM1
:X   C                   EVAL      OEAM02 = ORDAM2
:X   C                   EVAL      OEAM05 = ORDAM5
:X   C                   EVAL      OEAM16 = ORDA16
:X   C                   EVAL      OEPC01 = ORDPC1
:X   C                   EVAL      OECD40 = ORDC40
:X   C                   EVAL      OEMO02 = UMONTH
:X   C                   EVAL      OEDY02 = UDAY
:X   C                   MOVEL     *YEAR         OECC02
:X   C                   EVAL      OEYR02 = UYEAR
:X   C                   EVAL      OENM01 = USERID
:X   C                   EVAL      OECD26 = ORDC26
:X   C                   EVAL      OECD27 = ORDC27
:X   C                   EVAL      OECD28 = ORDC28
:X   C                   EVAL      OECD31 = ORTXCD
:X   C                   EVAL      OEDN04 = ORDDN4
:X   C                   EVAL      OENO22 = X
:X   C                   EVAL      OEQY05 = OEQY03
:X   C                   EVAL      OECD43 = ORDF43
:X   C                   EVAL      OEAM38 = ORAM38
:X   C                   EVAL      OEAM39 = ORAM39
:X   C                   EVAL      OEAM40 = ORAM40
:X   C                   EVAL      OEAM41 = ORAM41
:X   C                   EVAL      OEAM42 = ORAM42
:X   C                   EVAL      OEQY14 = ORDQ14
:X   C                   EVAL      OEQY15 = ORDQ15
:X   C                   EVAL      OEQY16 = ORDQ16
:X   C     BRIKEY        CHAIN(N)  IVFMSBR
:X   C                   WRITE     OEFTOLV
:X   C                   ADD       1             X
:X   C                   ENDDO
     C                   END
      *
     C     F3EXIT        IFEQ      'Y'                                          EXIT
     C     NEWTDP        ANDEQ     'Y'
     C     F5RSET        OREQ      'Y'                                          RESET
     C     NEWTDP        ANDEQ     'Y'
     C     OPNDP1        IFEQ      '1'
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
Y0    * Check if deposit is created using card software
Y0   C                   exsr      chkTcct
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
WJ   C                   if        alwCard = 'Y'
Y0   C                             and wNetErr = *zeros
Y0   C                             and dTyp <> 'G'
WJ   C                   call      'OER9602'     pl9602
Y0   C                   delete    oeftdp
0E    * Also delete OEPTDP/OEPTCRD records when the deposit is deleted.
0E    * (This program will delete these records if Credit card process fee applies)
0E   C                   call      'OER2039'     pl2039
WJ   C                   else
     C                   CALL      'OER9000'     PL9000
WJ Y0C*                  endif
¢(    * B2B Resture local area
¢(   C                   In        PARAM                                        *LDA
¢(   C                   Eval      W_OECD08 = %Subst(W_Backup:1:1)              Restore local area
¢(   C                   Eval      W_OENO14 = %Subst(W_Backup:2:7)
¢(   C                   Out       PARAM                                        *LDA
¢(    * End-B2B
      *
     C                   DELETE    OEFTDP
Y0   C                   endif
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     F3EXIT        IFEQ      'Y'
     C     F5RSET        OREQ      'Y'
YK    * Cancel AvaTax also, if order exited
YK   C                   exsr      srCNLTax
Q4   *
Q4   C                   if        wosys = 'Y' and
Q4   C                             genwo = 'Y'
Q4   C                   exsr      srDelWo
V4   C                   eval      woexs = 'N'
SO   C                   eval      wkoMaintFlag = *off
Q4   C                   endif
      *
      * IF WE ARE CANCELLING THIS ORDER & WE HAVE ALREADY TAKEN A CARD
      * THEN WE MUST ISSUE A CREIDT OR VOID REQUEST.
      *
     C     CARD          IFEQ      'Y'
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
WJ    *
WJ   C                   if        alwCard = 'Y'
Y0   C                             and wNetErr = *zeros
WJ   C                   call      'OER9602'     pl9602
WJ   C                   else
     C                   CALL      'OER9000'     PL9000
WJ   C                   endif
¢(    * B2B Resture local area
¢(   C                   In        PARAM                                        *LDA
¢(   C                   Eval      W_OECD08 = %Subst(W_Backup:1:1)              Restore local area
¢(   C                   Eval      W_OENO14 = %Subst(W_Backup:2:7)
¢(   C                   Out       PARAM                                        *LDA
     C                   ENDIF
      *
      * ALSO - GET RID OF ANY LOT WORK FILE RECORDS THAT MAY EXIST
      *
     C                   EXSR      CLRWRK
      *
     C                   ENDIF
      *
     C     BDFLAG        IFEQ      'Y'                                          SKIP CUSSR
     C     F3EXIT        ANDEQ     'Y'                                          IF PROCESSED
      *
      * IF FROM BID RELEASE, ZERO OUT ORDER # IN LDA SO THAT BID
      * RELEASE KNOWS THE SALES ORDER WAS CANCELLED.
      *
   RNC*                  Z-ADD     *ZEROS        RETRN#
RN   C                   MOVE      *ZEROS        RETRN#
     C                   OUT       PARAM
      *
     C                   GOTO      ENDPGM                                       FROM P/O
     C                   END
      *
     C     OAFLAG        IFEQ      'Y'                                          SKIP CUSSR
     C     F3EXIT        ANDEQ     'Y'                                          IF PROCESSED
     C                   GOTO      ENDPGM                                       FROM P/O
     C                   END
      *
     C     POFLAG        IFEQ      'Y'                                          SKIP CUSSR
     C     F3EXIT        ANDEQ     'Y'                                          IF PROCESSED
     C                   GOTO      ENDPGM                                       FROM P/O
     C                   END
      *
Y0    * Trigger event if card processing using software was not normal
Y0    * and user was forced to complete order
Y0   C                   if        wneterr <> *zeros
Y0   C                             and fromWrt = 'Y'
Y0   C                   exsr      srevent
Y0   C                   endif                                                  Event Id
Y0    *
Y2    * Delete any temp rows that could be in TOTX for same job#
Y2    * Delete orders that started as avatax but completed without
Y2    * avatax due to errors
Y2    * Also trigger an event to notify
Y2   C                   exsr      delAvaTaxLog
ZV    *
ZV    * If Enhanced Lost Sales in play and F5 command key pressed and reset
ZV    * control flag value is 'Y', dump contents of SAVDS to OEQWLST.
ZV   C                   If        F3Exit = 'Y'
ZV   C                              and EnhLstTrk = 'Y'
ZV   C                              and ELSF3F5 = 'Y'
ZV   C                   Exsr      Load_LST
ZV   C                   Endif
     C     F3EXIT        CABEQ     'Y'           ENDPGM                         EXIT PGM
      *
      * INITIALIZE PROGRAM FIELDS
      *
     C                   EXSR      BLKSR
YB    * Clear minimize AVATAX call flags
YB   C                   CLEAR                   TaxCalcSkip
YB   C                   CLEAR                   TaxCalcFin
YB   C                   EVAL      totdsc = @totdsc
YB   C                   IF        minTaxCalc = 'Y'
YB   C                               and AvaTaxActive = 'Y'
YB   C                   EVAL      totdsc = @totdscbtax
YB   C                   ENDIF
QX    *
QX    * LOAD CUSTOMER NUMBER LOADED FROM FOLLOW UP NOTES SCREEN.
QX Q2C*                  MOVE      'Y'           CNFLAG            1
QX Q2C*    ARNO01        IFEQ      *ZEROS
QX Q2C*                  IN        PARAM                                        *LDA
QX Q2C*    LDCUSN        IFNE      *BLANKS
QX Q2C*                  MOVE      LDCUSN        ARNO01                         CUSTOMER NUMBER
QX Q2C*                  ENDIF
QX Q2C*                  OUT       PARAM                                        *LDA
QX Q2C*    ARNO01        IFNE      *ZEROS
QX Q2C*                  MOVE      'Y'           CNFLAG            1
QX Q2C*                  ENDIF
QX Q2C*                  ENDIF
Q2   C     CNFLAG        IFEQ      'Y'
Q2   C                   MOVE      LSCUSN        ARNO01                         CUSTOMER NUMBER
Q2   C                   ENDIF
QX    *
      *
      * LOAD CUSTOMER INFORMATION IF FROM INTERFACE
      *
     C     BDFLAG        IFEQ      'Y'                                          BID RELEASE
     C     OAFLAG        OREQ      'Y'                                          C/O RELEASE
     C     POFLAG        OREQ      'Y'                                          P/O INTERFACE
     C     CSFLAG        OREQ      'Y'                                          CUS SEARCH
QX   C     CNFLAG        OREQ      'Y'                                          CUS NOTES
     C                   EXSR      CUSSR
     C                   EXSR      JOBSR
     C                   EXSR      GETTRM
     C                   ENDIF
      ***********
      * STEP 3. * EDIT HEADER INFORMATION
      ***********
     C                   EXSR      HDRSR
     C     F3EXIT        CABEQ     'Y'           CUSTAG                         EXIT
      ***********
      * STEP 4. * DETAIL LINE ITEMS
      ***********
     C     DTLLIN        TAG
ST   C                   EXSR      CHECKMAIL
     C                   EXSR      LINSR
     C     F3EXIT        CABEQ     'Y'           CUSTAG                         EXIT
     C     F5RSET        CABEQ     'Y'           CUSTAG                         RESET
      ***********
      * STEP 5. * RETURNED ITEM REASON CODE AND DAMAGED ITEM TAG #'S
      ***********
     C     RTNLIN        TAG
     C     OECD08        CASEQ     'C'           RTNSR                          CREDIT MEMO
     C     OECD08        CASEQ     'D'           RTNSR                          DEBIT MEMO
     C                   ENDCS
      *
     C     F3EXIT        CABEQ     'Y'           CUSTAG                         EXIT
     C     F12CNL        CABEQ     'Y'           DTLLIN                         CANCEL
      ***********
      * STEP 6. * CASH SALES ENTRY
      ***********
     C     CSHTAG        TAG
      *
      * NO CASH IF ORDER HELD DUE TO CREDIT PROBLEMS
      *
     C     HLDORD        IFNE      'Y'
     C     OEFL02        CASEQ     'C'           CSHSR                          C.O.D.
     C     OEFL02        CASEQ     'Y'           CSHSR                          CASH SALE INV
     C                   ENDCS
     C                   ENDIF
      *
     C     F3EXIT        CABEQ     'Y'           CUSTAG                         EXIT
     C     F12CNL        CABEQ     'Y'           RTNLIN                         CANCEL
      ***********
      * STEP 7. * SUMMARY SCREEN
      ***********
UM   C                   MOVE      'Y'           OEFL03
UM   C                   MOVE      ' '           SAVFL3
     C     SUMTAG        TAG
     C                   EXSR      SUMSR
      *
     C     F3EXIT        CABEQ     'Y'           CUSTAG                         EXIT
     C     F12CNL        CABEQ     'Y'           CSHTAG                         CANCEL
     C     WMERR         IFNE      *BLANKS
     C     WHMBR         CABEQ     'Y'           DTLLIN
     C                   ENDIF
      *
      * CHECK IF FAX S/O IS EQUAL TO Y. IF SO, CALL FAX CONTROL PGM.
      *
X0   C                   if        taxerr <> 'Y'
     C     FAXTKT        IFEQ      'F'
     C     FAXSO         ANDEQ     'Y'
     C     PRBHLD        ANDNE     'Y'
     C     PRCHLD        ANDNE     'Y'
     C     CRDHLD        ANDNE     'Y'
     C     CVRSHT        IFEQ      ' '
     C     DELAY         OREQ      ' '
     C     ONEB4         OREQ      ' '
     C     FAXSC         ORNE      FAXSV
     C     EDTFAX        OREQ      'Y'
     C                   EXSR      FAXSR
     C                   Z-ADD     FAXSC         FAXSV
     C                   MOVE      *ON           SVIN60
     C     FAXSC         CABEQ     FAXSV         SUMTAG
     C                   ENDIF
     C                   ENDIF
X0   C                   ENDIF
WJ Y0 * If curbstone and order is cash invoice & card amount entered,
Y0    * If card softwere used and order is cash invoice & card amount
Y0    * is entered,
WJ   C                   if        alwCard = 'Y' and
WJ   C                             oecd03 = 'C' and
WJ   C                             oefl02 = 'Y' and
WJ   C                             oeam36  <> totapr
WJ   C                   eval      svoeam36 = oeam36
WJ   C                   select
WJ    * If amount zeroed out and card was taken, void earlier transaction
WJ   C                   when      oeam36 = *zeros
WJ   C                             and card = 'Y'
WJ   C                   exsr      voidcards
WJ   C                   if        totapr <> *zeros
WJ   C                   goto      cshtag
WJ   C                   endif
WJ    *
WJ    * If amount paid by card is greater than approved amount, and if
WJ    * it is a sale(not pre-auth), void the excess amount.
WJ    * For pre-auth, simply update correct amount in TCCT file which
WJ    * will be used for approval in settlement process during invoice run.
WJ   C                   when      oeam36 <> *zeros and
WJ   C                             %abs(totapr) > %abs(oeam36)
WJ   C                             and card = 'Y'
WJ   C                             and wPrcSal = 'Y'
WJ   C                   exsr      voidcards
WJ    * If approved amount was completely voided and totapr = 0, call
WJ Y0 * Curbstone for approval of new card amount entered.
Y0    * card processing program for approval of new card amount entered.
WJ   C                   if        totapr = *zeros
WJ   C                   eval      oeam36 = svoeam36
WJ   C                   else
WJ    * If approved amount was not totally voided,go back to cash sales
WJ    * so user can re-view & re-adjust.
WJ   C                   if        %abs(totapr) <> %abs(svoeam36)
WJ   C                   goto      cshtag
WJ   C                   endif
WJ   C                   endif
WJ    *
WJ   C                   endsl
WJ    *
WJ Y0 * Call Curbstone program for interactive card selection if
Y0    * Call card processing program for interactive card selection if
WJ    * card amount entered is greater than approved amount.
WJ   C                   if        %abs(oeam36) > %abs(totapr)
WJ   C                   exsr      clr_pl9600
WJ   C                   exsr      call9600
WJ    *
Y0    * If internet error occurs after processing some cards, F11 will
Y0    *
Y0    *
WJ   C                   if        poMsg = *blanks
Y0   C                             and alwcard  = 'Y'
Y0   C                             or  wNetErr <> *zeros
Y0   C                             and  card_interface = 'Y'
WJ    *
WJ    *  Display error if no card selected.
WJ   C                   if        piMode = 'VRF' or
WJ   C                             piMode = 'IAS' or
WJ   C                             piMode = 'IRF'
WJ   C                   if        authLstMFUKEY = *blanks
WJ   C                   eval      pomsg = 'No card selected for transaction.'
WJ   C                   else
WJ   C                   eval      card = 'Y'
WJ   C                   endif
WJ   C                   endif
WJ    *
WJ    * Set error messages based on amount approved.
WJ   C                   if        piMode <>'VRF'
WJ   C                   if        totapr = *zeros
WJ   C                   eval      pomsg = 'No amount charged on credit card.-
WJ   C                              Adjust amounts.'
WJ   C                   else
WJ   C                   if        totapr <> oeam36
WJ   C                   z-add     totapr        oeam36
WJ   C                   eval      pomsg = 'Approved amount $' +
WJ   C                             %trim(%char(totapr))+
WJ   C                             ' is less than original credit card amt. -
WJ   C                             Adjust amounts.'
WJ    *
WJ   C                   endif
WJ   C                   endif
WJ   C                   endif
WJ    *
WJ   C                   endif
WJ    * If error, go back to cash tag
WJ   C                   eval      aprvd = 'Y'
WJ   C                   if        pomsg <> *blanks
Y0    *
Y0    * if internet error,
Y0    *    (if no amount collected on card, card flags are changed to N
Y0    *     so that generic card process will be activated
Y0    *     else they remain active as in Initialization routine.)
Y0    *    if flag is still active i.e. amount is already collected on card
Y0    *       display message to complete Deposit for remaining in cash or check
Y0    *    else (i.e. no amount is collected on card)
Y0    *       display message to collect Credit amount using Generic card entry
Y0    *    endif
Y0    *  endif
Y0    *
Y0   C                   if        wNetErr <> *zeros
Y0   C                             and using_card = 'Y'
Y0   C                   if        alwcard = 'Y'
Y0   C                   eval      pomsg = 'Card send/receive error. Collect +
Y0   C                             remaining amount in cash/check.'
Y0   C                   eval      *in94 = *on
Y0   C                   if        newtdp = 'Y'
Y0   C                   eval      eventtype = '3'
Y0   C                   eval      trans2    = newdep
Y0   C                   else
Y0   C                   eval      eventtype = '2'
Y0   C                   endif
Y0   C                   else
Y0   C                   eval      pomsg = 'Card send/receive error. Press +
Y0   C                             ENTER to collect card payment without +
Y0   C                             software.'
Y0   C                   eval      eventtype = '1'
Y0   C                   endif
Y0   C                   endif
Y0    *
WJ   C                   eval      aprvd = 'N'
Y0   C                   if        card_interface = 'Y'
Y0   C                   z-add     totapr        oeam36
Y0   C                   endif
WJ   C                   goto      cshtag
WJ   C                   endif
WJ    *
WJ   C                   z-add     totapr        oeam36
WJ    *
WJ   C                   endif
WJ    *
WJ   C                   endif
      *
      * CHECK IF EMAILING TICKET. IF SO, WRITE OPPTFXI RECORD.
      *
X0   C                   if        taxerr <> 'Y'
     C     FAXTKT        IFEQ      'E'
     C     EALLOW        ANDEQ     'Y'
     C     PRBHLD        ANDNE     'Y'
     C     PRCHLD        ANDNE     'Y'
     C     CRDHLD        ANDNE     'Y'
¢)   C     FAXTKT        OREQ      'Y'
¢)   C     EALLOW        ANDEQ     'Y'
¢)   C     PRBHLD        ANDNE     'Y'
¢)   C     PRCHLD        ANDNE     'Y'
¢)   C     CRDHLD        ANDNE     'Y'
     C                   MOVEL     OENO01        DOCNUM           12
     C                   MOVE      'OE02'        SYSID             4
     C                   MOVE      *BLANKS       FAXNUM
     C                   MOVE      ARNO01        TRNNUM                         TRANSFER NUMBER
VX   C     EMAIL         IFNE      MULTMG
     C                   CALL      'OPR0303'     PL0303
VX   C                   ELSE
VX    * PROCESS MULTIPLE EMAIL ADDRESSES
VX   C                   MOVE      JOBNUM        JOB##
VX   C                   CALL      'OPR0304'     PL0304
VX   C                   ENDIF
     C                   ENDIF
X0   C                   ENDIF
      *
      * WRITE ORDER
      *
     C                   EXSR      WRTSR1
#Y    * Price override tracking
#Y    * Get start date for price override tracking
#Y   C                   EVAL      TABCOD = 'CM14'
#Y   C                   EVAL      TABENT = 'PRICEOVRD'
#Y   C     TABKEY        CHAIN     TBFMTBL
#Y   C                   IF        %FOUND and
#Y   C                             %subst(TBNO03:1:1)='Y'
#Y   C                   CALL      'OERC019'
#Y   C                   PARM                    OENO01
#Y   C                   ENDIF
:D    * Order Fulfilments - Entry Counter Quantity Picking
:D   C                   Exsr      Sbr_2021
      *
     C     SPLORD        IFEQ      'Y'
     C                   CALL      'OER2022'
     C                   PARM                    OENO26
Z4   C                   ELSE
Z4   C                   IF        OECD08 = 'O'
Z4   C                   CALL      'OER2312'     PL2312
Z4   C                   ENDIF
     C                   END
      *
     C     WHMBR         IFEQ      'Y'
     C     OEFL20        ANDEQ     'Y'
     C     SPLORD        IFNE      'Y'
     C     OECD01        ANDNE     'D'
     C     OECD04        ANDNE     'N'
     C     OECD08        ANDNE     'Q'
     C     OECD38        ANDNE     'Y'
     C     SPLORD        ANDNE     'Y'
     C                   CLEAR                   PDATA
     C                   MOVE      'OE '         WMFRM
     C                   MOVEL     OENO01        PDATA
     C                   CALL      'WXR5950'
     C                   PARM                    WMFRM             3
     C                   PARM                    PDATA           256
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      PKTKSR
      *
      * UPDATE CREDIT CARD RECORDS TO ACTIVE STATUS.
      *
     C                   MOVE      OENO01        TRANUM
     C                   MOVE      'S'           TRATYP
     C                   Z-ADD     *ZEROS        TOTCHG
     C                   MOVE      ' '           CARD
     C                   MOVE      'U'           PMODE
     C                   CALL      'OER9003'     PL9003
      *
      *
   Q4 * IF GENWO = 'Y', CALL W/O INTERFACE PROGRAM
   Q4 *
   Q4C*    WOSYS         IFEQ      'Y'
   Q4C*    GENWO         IFEQ      'Y'
   Q4C*                  CALL      'WOR2010'     PL2010
   Q4C*                  CLEAR                   WOS
   Q4C*                  ENDIF
   Q4C*                  ENDIF
RE    *
RE    * CALL WARRANTY CLAIM UPDATE / SEND PROGRAM
RE    * IT WILL UDPATE CREDIT MEMO NUMBER IN WARRANTY CLAIM FILE.
RE    * IT WILL SEND THE CLAIM IF REQUESTED.
RE    *
RE :SC*    SNDWC         IFEQ      'Y'
RE :SC*    WARRANTY#     ORNE      *BLANKS
RE :SC*                  MOVE      OENO01        WC_OENO01
RE :SC*                  MOVE      'U'           WC_REQTYPE
RE :SC*                  CALL      'OER9431'
RE :SC*                  PARM                    WARRANTY#
RE :SC*                  PARM                    WC_OENO01         7
RE :SC*                  PARM                    WC_REQTYPE        1
RE :SC*                  PARM                    SNDWC
RE :SC*                  ENDIF
RE :TC*                  CLEAR                   WARRANTY#
RE   C                   CLEAR                   CREATE_MODE
   Q4 *
     C                   Z-ADD     0             RNS                            TOTAL RNS ITMS ON S/
      *
      * GENERATE TRANSFERS ?
      *
     C     GENTRF        IFEQ      'Y'
     C                   MOVE      OENO26        ORGNO
     C                   MOVE      *ZEROS        ORDNO
     C                   CALL      'OER0112'
     C                   PARM                    ORGNO             7
     C                   PARM                    ORDNO             7
     C                   ENDIF
      *
      * IF ANY ITEMS WERE RELEASED FROM RESERVE ORDERS THEN WE
      * NEED TO GO BACK AND UPDATE THE RESERVE ORDER.  IF ITEMS
      * WERE RELEASED, BUT THEN DELETED, THEN WE NEED TO GO BACK
      * AND UNLOCK THE RESERVE ORDER HEADER RECORDS.
      *
     C     UPDFLG        IFEQ      'Y'                                          UPDATE ORDER
     C                   MOVE      'U'           DSPMOD
     C                   MOVE      *BLANKS       JOBNBR                         JOB NUMBER
     C                   MOVE      JOBNUM        JOBNBR            6            JOB NUMBER
     C                   CALL      'OER6053'     PL6053
     C                   ELSE
     C     UNLFLG        IFEQ      'Y'                                          UNLOCK ORDER
     C                   MOVE      'L'           DSPMOD
     C                   MOVE      *BLANKS       JOBNBR                         JOB NUMBER
     C                   MOVE      JOBNUM        JOBNBR                         JOB NUMBER
     C                   CALL      'OER6053'     PL6053
     C                   END
     C                   END
      *
      * SALES ORDER TO PURCHASE ORDER INTERFACE
      *
      *
      * IF DIRECT S/O WAS GENERATED FROM MULTI-SHIP BRANCH, CALL
      * ORDER MAINTENANCE
      *
      *
      * IF ATLEAST ONE ITEM WITH VENDOR RETURN FLAG = Y,
      *    CALL VENDOR RETURN WORK FILE BUILD PROGRAM.
      * ENDIF
     C     SVRFLG        IFEQ      'Y'
      *
      * IF VR00-INCLUDE TABLE SETTING = Y
      *    INCLUDE PENDING CR MEMO ALONG WITH ALL OTHER ORDER STATUS
      *    IN INCOMPLETE CR MEMO WORK FILE
      * IF VR00-INCLUDE TABLE SETTING = N
      *    EXCLUDE PENDING CR MEMO FROM INCOMPLETE CR MEMO WORK FILE
     C     INCLUD        IFEQ      'Y'
     C     INCLUD        ORNE      'Y'
     C     OECD04        ANDNE     'N'
     C                   MOVE      OENO01        CRNO
     C                   CALL      'POR4350'
     C                   PARM                    CRNO              7
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *BLANK        SVRFLG            1
SZ    *
SZ    * check user have authority to create V/R from C/M
SZ   C                   MOVE      USRNM         USER
SZ   C                   MOVE      'OE'          APP
SZ   C                   MOVEL     'RGA'         CDE
SZ   C                   MOVE      0003          ID
SZ   C                   MOVE      *BLANKS       USRVAL
SZ   C                   MOVE      *BLANKS       VALFRM
SZ   C                   MOVE      *BLANKS       RTNCOD
SZ   C                   CALL      'OPR8220'     PL8220
SZ   C     RTNCOD        IFEQ      '0'
SZ   C                   MOVEL     USRVAL        VRAUTH            1
SZ   C                   ELSE
SZ   C                   MOVE      *BLANKS       VRAUTH
SZ   C                   ENDIF
SZ    *
SZ    * WHEN CREATING OPEN C/M IF AUTHORIZED CALL C/M TO V/R INTERFACE
SZ    * PROGRAM
SZ   C     RESSTK        IFEQ      'O'
SZ   C     OECD08        ANDEQ     'C'
SZ   C     VRAUTH        ANDEQ     'Y'
SZ   C     CMVRFLG       ANDEQ     'Y'
SZ   C     *IN03         ANDNE     '1'
SZ   C                   MOVE      OENO01        CORD#             7
SZ   C                   CALL      'POR4112'
SZ   C                   PARM                    CORD#
SZ   C                   ENDIF
SZ   C                   MOVE      *BLANK        CMVRFLG
      *
      *
      * IF CREDIT MEMO OR DEBIT MEMO IS ENTERED, AND AUTO FILL B/O
      * FROM CREDIT MEMOS IS SET TO 'Y'.  THEN SUBMIT JOB THAT WILL
      * SEARCH SALES ORDER FOR ITEMS THAT ARE BEING RETURNED THAT
      * CAN FILL BACKORDERS.
      *
     C     OECD08        IFEQ      'C'
     C     OECD08        OREQ      'D'
     C     AFCRED        IFEQ      'Y'
     C                   MOVE      *BLANKS       ORD2              7
     C                   MOVE      OENO01        ORD2
     C                   MOVEA     ORD2          VOD(36)
     C                   MOVEA     'E'           VOD(46)
     C                   MOVEA     VOD           CMX              98
     C                   Z-ADD     98            LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMX
     C                   PARM                    LEN
     C                   ENDIF
     C                   ENDIF
      *
      *
      * END PROGRAM IF FROM INTERFACE
      *
     C     BDFLAG        IFEQ      'Y'                                          BID RELEASE
     C     OAFLAG        OREQ      'Y'                                          C/O RELEASE
     C     POFLAG        OREQ      'Y'                                          P/O INTERFACE
     C     CSFLAG        OREQ      'Y'                                          CUS SEARCH
Q2   C     CNFLAG        OREQ      'Y'                                          CUS SEARCH
     C                   MOVE      '1'           *INLR
     C                   END
XD
XD    * Order being placed on credit hold event
XD   C                   if        oecd38 = 'Y'
XS   C     OENO08        CHAIN     ARFMBCH                                      BRANCH MASTER
XS   C                   eval      comE20 = arno15
XS   C                   eval      divE20 = glcd41
XS   C                   eval      regE20 = glcd42
XS   C                   eval      sbrE20 = arno16
XS   C                   eval      bnmE20 = arnm07
XD   C                   eval      ordE20 = oeno01
XD   C                   eval      cusE20 = arno01
XD   C                   eval      cnmE20 = arnm01
XD   C                   eval      usrE20 = oenm01
XD   C                   Call      'SHC5050'
XD   C                   Parm      'HDE0020'     EventID           7            Event Id
XD   C                   Parm                    d_HDE0020                      Event Data
XD   C                   end
XD
&S    * If DNR items exist send purchasing the report
&S   C/EXEC SQL
&S   C+ select count(*) into:@Count
&S   C+ from oepdnra
&S   C/END-EXEC
&S    *
&S   C                   if        @count > 0
&S   C                   Call      'OECDNRA'
&S   C                   Parm                    oeno01
&S   C                   Endif
&S    *
Y3    * Remove records from OELWPOL1
Y3    *
Y3   C     *Start        Setll     OELWPOL1
Y3   C                   Dou       %Eof(OELWPOL1)
Y3   C                   Read      OELWPOL1
Y3   C                   If        Not %Eof(OELWPOL1)
Y3   C                   Delete    OEFWPOL
Y3   C                   Endif
Y3   C                   Enddo
Y3    *
Y1    * New order creation notification event
Y1   C                   Call      'SHR5300'
Y1   C                   Parm                    oeno01
Y1   C                   Parm      '01'          FromArea          2
ZV    * Call OER2190 if Enhanced Lost Sales Tracking in play and one of the OE
ZV    * control flag values is 'Y'
ZV   C                   CLEAR                   ELSX              2 0
ZV   C                   EVAL      ELSX = %Scan('Y':ELSALL:1)
ZV   C                   IF        ENHLSTTRK = 'Y' AND ELSX <> *ZEROS
ZV   C                   Eval      LSMENU = 'OE'
ZV   C                   Move      OENO08        LSBRCH
ZV   C                   Move      ARNO01        LSCUST
ZV   C                   Move      OENO01        LSORDR
ZV   C                   Call      'OER2190'     PL2190
ZV   C                   ENDIF
ZV   C                   Exsr      Clear_LST
:J    *
:J   C                   if        wc_ra#<>*blanks and *inlr='0'
:J   C                   MOVEL     arno01        prCust
:J   C                   MOVEL     wc_ra#        prRANbr
:J   C                   call      'OERC510'     plc510
:J   C                   endif
:J   C                   MOVE      *BLANKS       wc_ra#
:J   C                   MOVE      *BLANKS       RaNum
     C     *INLR         CABEQ     '0'           CUSTAG
      *
      * END OF JOB
      *
     C     ENDPGM        TAG
V3    *
WJ   C                   clear                   pidet
V3    * Delete clipboard info
V3    *
V3   C                   If        %subst(wsname:1:3) = 'QQF'
V3   C                   clear                   SHFCLIP
V3   C                   eval      SessioNmMv = 'JOB_' + %editc(jobnum:'X')
V3   C                   eval      EnttypCdMv  = 'PROGRAM_VARIABLES'
V3   C                   eval      Clipk1CdMv  = 'PRODUCT_PROMPTER'
V3   C     KeyClip1      chain     SHLCLIP1
V3   C                   if        %found(SHLCLIP1)
V3   C                   delete    shfclip
V3   C                   EndIf
WG    *
WG    * Delete all line item data
WG    *
WG   C                   exsr      ClearSDClip
WG WOO*                  exsr      ClearSDClipI
WO
WO    *  Close the display file
WO   C                   if        %open(OED2020S)
WO   C                   close     OED2020S
WO   C                   endif
WG
WG    *  Close the work file
WG   C                   if        %open(OEPW2020S)
WG   C                   close     OEPW2020S
WG   C                   endif
WG   C                   clear                   clropt            1
WG   C                   clear                   clrfile          10
WG    *  Lock the work file
WG   C                   eval      clropt = 'L'
WG   C                   eval      clrfile = 'OEPW2020S'
WG   C                   call(e)   'OPC9990'
WG   C                   parm                    clropt
WG   C                   parm                    clrfile
WG    *  Clear the work file
WG   C                   if        clropt <> '#'
WG   C                   eval      clropt = '1'
WG   C                   call(e)   'OPC9990'
WG   C                   parm                    clropt
WG   C                   parm                    clrfile
WG    *  UnLock the work file
WG   C                   eval      clropt = 'U'
WG   C                   call(e)   'OPC9990'
WG   C                   parm                    clropt
WG   C                   parm                    clrfile
WG   C                   endif
V3   C                   EndIf
ZV    * CLEAR IN QTEMP
ZV   C                   If        %Open(OEQWLST)
ZV   C                   Exsr      Clear_LST
ZV   C                   Close     OEQWLST
ZV   C                   Endif
V3    *
WX    * Delete tax records
WX   C                   Exsr      ClearTaxr
X0 Y2 * Delete any temp rows that could be in TOTX for same job#
X0 Y2C*                  exsr      delAvaTaxLog
Y3    *
Y3    * Remove records from OELWPOL1
Y3    *
Y3   C     *Start        Setll     OELWPOL1
Y3   C                   Dou       %Eof(OELWPOL1)
Y3   C                   Read      OELWPOL1
Y3   C                   If        Not %Eof(OELWPOL1)
Y3   C                   Delete    OEFWPOL
Y3   C                   Endif
Y3   C                   Enddo
Y3    *
     C                   SETON                                        LR
     C                   RETURN
X1    /COPY QCPYSRC,OEY2020
YR    /COPY QCPYSRC,OEY2021
#H    *--------------------------------------------------------------------------
#H    * DETERMINE IF GMC SERIAL NUMBER TAGS ARE REQUIRED
#H    *--------------------------------------------------------------------------
#H   C     GETNEEDTAGS   BEGSR
#H    *
#H   C     OPNIVH        IFNE      '1'
#H   C                   OPEN      IVLMSTRK
#H   C                   MOVE      '1'           OPNIVH
#H   C                   ENDIF
#H    *
#H   C                   MOVE      'N'           NEEDGMCTAG        1
#H   C                   Z-ADD     1             RRNGT             3 0
#H   C                   MOVE      *IN49         SAVEIN49          1
#H    *
#H   C     RRNGT         CHAIN     OES2020G                           49
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
#H   C     RRNGT         CHAIN     OES2020G                           49
#H   C                   ENDDO
#H    *
#H   C                   MOVE      SAVEIN49      *IN49
#H    *
#H   C                   ENDSR
YR    *--------------------------------------------------------------------------
YR    * The following Subroutines were moved to copy member (OEY2020 or OEY2021)
YR    *--------------------------------------------------------------------------
YR    *    BLKSR         BEGSR
YR    *    BLKDS         BEGSR
      **********************************************************************
      ** SUBROUTINE ** GET INFORMATION IF THIS FROM PO NOT FROM O/E  *******
      **********************************************************************
X1    *  Subroutine FROMPO has been moved to the copy book member OEY2020
   X1C*SR   FROMPO        BEGSR
      ********************************************************************
      ** SUBROUTINE ** LOAD DATA STRUCTURE FROM **************************
      ** CONTRACT ORDER RELEASES *****************************************
      ********************************************************************
X1    *  Subroutine FROMOA has been moved to the copy book member OEY2020
   X1C*    FROMOA        BEGSR
      ********************************************************************
      ** SUBROUTINE ** LOAD CONTRACT LINE ITEM FIELDS TO SAVDS FIELDS*****
      ********************************************************************
YR    *--------------------------------------------------------------------------
YR    * The following Subroutines were moved to copy member (OEY2020 or OEY2021)
YR    *--------------------------------------------------------------------------
YR    *    CLTODS        BEGSR
      ********************************************************************
      ** SUBROUTINE ** LOAD LOT ITEM DETAIL ITEMS TO SAVDS FIELDS*********
      ********************************************************************
X1    *  Subroutine LOTSR  has been moved to the copy book member OEY2020
   X1C*    LOTSR         BEGSR
      ********************************************************************
      ** SUBROUTINE ** LOAD DATA STRUCTURE FROM **************************
      ** BID RELEASE *****************************************************
      ********************************************************************
X1    *  Subroutine FROMBD has been moved to the copy book member OEY2020
   X1C*    FROMBD        BEGSR
YR    *--------------------------------------------------------------------------
YR    * The following Subroutines were moved to copy member (OEY2020 or OEY2021)
YR    *--------------------------------------------------------------------------
YR    *    BLTODS        BEGSR
YR    *    FROMCS        BEGSR
YR    *    CUSSR         BEGSR
YR    *    JOBSR         BEGSR
YR    *    GETTRM        BEGSR
YR    *    HDRSR         BEGSR
YR    *    DFTSR         BEGSR
YR    *    TAXSR         BEGSR
YR    *    TAXSR2        BEGSR
YR    *    BILSR         BEGSR
YR    *    DEPSR         BEGSR
YR    *    OTHSR         BEGSR
YR    *    CALCOC        BEGSR
YR    *    CSHSR         BEGSR
YR    *    LINSR         BEGSR
YR    *    CHECKMAIL     BEGSR
YR    *    STDPCK        BEGSR
YR    *    CTLSR         BEGSR
YR    *    ValAddr       begsr
YR    *    CTLSRB        BEGSR
YR    *    SQUASH        BEGSR
YR    *    ASSOC         BEGSR
YR    *    TOTALS        BEGSR
      **********************************************************************
      ** SUBROUTINE ** DETERMINE CREDIT CHECKING MESSAGE          **********
      **********************************************************************
X1    *  Subroutine CREDSR has been moved to the copy book member OEY2020
   X1C*    CREDSR        BEGSR
YR    *--------------------------------------------------------------------------
YR    * The following Subroutines were moved to copy member (OEY2020 or OEY2021)
YR    *--------------------------------------------------------------------------
YR    *    PRCINF        BEGSR
YR    *    BLKCOM        BEGSR
YR    *    NONSTK        BEGSR
YR    *    EDITBR        BEGSR
YR    *    EDITPR        BEGSR
YR    *    FCTEDT        BEGSR
YR    *    ITEMSR        BEGSR
YR    *    TERMS         BEGSR
YR    *    AVLQTY        BEGSR
YR    *    CUOMSR        BEGSR
YR    *    COMPSR        BEGSR
YR    *    EXTDSC        BEGSR
YR    *    SELSR         BEGSR
YR    *    INVSR         BEGSR
YR    *    DIRLOT        BEGSR
YR    *    RTNSR         BEGSR
YR    *    SORTBR        BEGSR
YR    *    SUMSR         BEGSR
YR    *    NOTSR         BEGSR
YR    *    LOAD          BEGSR
YR    *    WRTSR1        BEGSR
YR    *    WRTSR         BEGSR
YR    *    BDYCOM        BEGSR
YR    *    LINCOM        BEGSR
YR    *    LOTDTL        BEGSR
YR    *    ITEMS         BEGSR
YR    *    DSTOFL        BEGSR
YR    *    CMTOFL        BEGSR
YR    *    UPIVOA        BEGSR
YR    *    UPDINV        BEGSR
YR    *    PRICE         BEGSR
YR    *    CROLL         BEGSR
YR    *    PRCEXT        BEGSR
YR    *    DIRECT        BEGSR
YR    *    WRTTAG        BEGSR
      **********************************************************************
      ** SUBROUTINE ** ALTERNATE SHIP-TO ADDRESSES *************************
      **********************************************************************
X1    *  Subroutine SHPSR  has been moved to the copy book member OEY2020
   X1C*    SHPSR         BEGSR
YR    *--------------------------------------------------------------------------
YR    * The following Subroutines were moved to copy member (OEY2020 or OEY2021)
YR    *--------------------------------------------------------------------------
YR    *    @PRMPT        BEGSR
YR    *    @CURSR        BEGSR
YR    *    @CLCSR        BEGSR
      ********************************************************************
      * SUBROUTINE TO MOVE REF UOM CONV MESSAGE TO DESC LINE
      *****************************************************************
X1    *  Subroutine RMSGSR has been moved to the copy book member OEY2020
   X1C*    RMSGSR        BEGSR
YR    *--------------------------------------------------------------------------
YR    * The following Subroutines were moved to copy member (OEY2020 or OEY2021)
YR    *--------------------------------------------------------------------------
YR    *    UNLOCK        BEGSR
YR    *    INITSR        BEGSR
YR    *    CHGCMP        BEGSR
YR    *    LOADRI        BEGSR
      *----------------------------------------------------------------
      * @WNCTL - WINDOW CONTROL SUBROUTINE
      *------------------------------------------------------------------------*
X1    *  Subroutine @WNCTL has been moved to the copy book member OEY2020
   X1C*    @WNCTL        BEGSR
      *----------------------------------------------------------------
      * SNDMSG - WINDOW CONTROL SUBROUTINE
      *------------------------------------------------------------------------*
      *
X1    *  Subroutine SNDMSG has been moved to the copy book member OEY2020
   X1C*    SNDMSG        BEGSR
      *------------------------------------------------------------------------*
      * CALCQY - Calculate maximum quantity used to affect open order
      *          credit checking for contracts.
      *----------------------------------------------------------------
X1    *  Subroutine CALCQY has been moved to the copy book member OEY2020
   X1C*    CALCQY        BEGSR
      *----------------------------------------------------------------
      * CLRWRK - CLEAR WORK FILE FOR ANY LOT RECORDS FOR THIS SESSION
      *----------------------------------------------------------------
X1    *  Subroutine CLRWRK has been moved to the copy book member OEY2020
   X1C*    CLRWRK        BEGSR
      *----------------------------------------------------------------
      * LODLOT - CALL LOT SELECTION PGM.
      *----------------------------------------------------------------
      *
X1    *  Subroutine LODLOT has been moved to the copy book member OEY2020
   X1C*    LODLOT        BEGSR
      *----------------------------------------------------------------
      * CLRLOT - REMOVE LOT NUMBERS ENTERED FOR A GIVEN ITEM.
      *----------------------------------------------------------------
      *
X1    *  Subroutine CLRLOT has been moved to the copy book member OEY2020
   X1C*    CLRLOT        BEGSR
      *----------------------------------------------------------------
      * UPDLOT - CALL PGM TO UPDATE MLOT RECORD AND WRITE TLOTS.
      *----------------------------------------------------------------
      *
X1    *  Subroutine UPDLOT has been moved to the copy book member OEY2020
   X1C*    UPDLOT        BEGSR
YR    *--------------------------------------------------------------------------
YR    * The following Subroutines were moved to copy member (OEY2020 or OEY2021)
YR    *--------------------------------------------------------------------------
YR    *    GHTXSR        BEGSR
YR    *    MULTSR        BEGSR
YR    *    FAXSR         BEGSR
YR    *    PROCRD        BEGSR
YR    *    GETAGE        BEGSR
YR    *    CMPCNT        BEGSR
YR    *    PKTKSR        BEGSR
YR    *    BOLOW         BEGSR
YR    *    CHKTYP        BEGSR
YR    *    UPDNSI        BEGSR
YR    *    GETNSB        BEGSR
YR    *    PRTDEP        BEGSR
YR    *    srOpnWko      begsr
YR    *    srDelwo       begsr
YR    *    S$LDWITX      BEGSR
YR    *    chksupsede    begsr
YR    *    getcst        begsr
YR    *    recalccost    begsr
YR    *    WriteSDClip   begsr
YR    *    WriteSDClipI  begsr
YR    *    ReadSDClip    begsr
YR    *    ReadSDClipI   begsr
YR    *    ClearSDClip   begsr
YR    *    ClearSDClipI  begsr
WG WO *----------------------------------------------------------------
WG WO * Initialize remainder of subfile so valid RRN's exist for axes
WG WO *----------------------------------------------------------------
WG WOC*    WriteSDFill   begsr
WI WOC*                  z-add     x             svx               4 0
WG WOC*                  If        sdwide = 'Y'
WG WO *
WG WO * Initialize remainder of subfile records
WG WOC*                  eval      x = rrn
WG WOC*                  eval      PerformChain = 'Y'
WG WOC*                  dow       rrn < 400
WG WOC*                  if        PerformChain = 'Y'
WG WOC*    rrn           chain     oes2020s
WG WOC*                  if        not %found(oed2020)
WG WOC*                  clear                   oes2020s
WG WOC*                  eval      rrnsd = rrn
WG WOC*                  eval      PerformChain = 'N'
WG WOC*                  endif
WG WOC*                  else
WG WOC*                  clear                   oes2020s
WG WOC*                  eval      rrnsd = rrn
WG WOC*                  endif
WG WOC*                  eval      rrn += 1
WG WOC*                  enddo
WG WO *
WG WOC*                  eval      rrn = x
WG WOC*                  endif
WI WOC*                  z-add     svx           x
WG WOC*                  endsr
YR    *--------------------------------------------------------------------------
YR    * The following Subroutines were moved to copy member (OEY2020 or OEY2021)
YR    *--------------------------------------------------------------------------
YR    *    chkprc        begsr
YR    *    clr_pl9600    begsr
YR    *    Upd_tcct      Begsr
YR    *    call9600      Begsr
YR    *    VoidCards     Begsr
YR    *    chkCrdBrn     Begsr
YR    *    ClearTaxr     begsr
YR    *    Tax_API       Begsr
YR    *    LoadTaxAPIItm begsr
YR    *    DelAvaTaxLog  begsr
YR    *    WrtAvaTaxLog  begsr
YR    *    srValOthChargebegsr
X0    *------------------------------------------------------------------------*
X0    *  Check if input params are different and set flag to call Tax API
X0    *------------------------------------------------------------------------*
X0    * Subroutine srChkInParm has been added to the copy book member OEY2020
X0    *    srChkInParm   begsr
X0    *------------------------------------------------------------------------*
X0    * Check if any of the line item details is changed
X0    *------------------------------------------------------------------------*
X0    * Subroutine srChkDsChg has been added to the copy book member OEY2020
X0    *    srChkDsChg    begsr
X0    *****************************************************************
X0    * Load saved Other Charge data from save fields
X0    *****************************************************************
X0    * Subroutine srLoadOthChg has been added to the copy book member OEY2020
X0    *    SrLOadOthChg  begsr
X0    *------------------------------------------------------------------------*
X0    * Load pTax_saveitems
X0    *------------------------------------------------------------------------*
X0    * Subroutine srLoadDshSv has been added to the copy book member OEY2020
X0    *    srLoadDsSv    begsr
X0    *------------------------------------------------------------------------*
X0    *  Restore all output params if params to Tax API are same as prior call
X0    *------------------------------------------------------------------------*
X0    * Subroutine srRstrOutParm has been added to the copy book member OEY2020
X0    *    srRstrOutParm begsr
X0    *------------------------------------------------------------------------*
X0    *  Save all output params of Tax API
X0    *------------------------------------------------------------------------*
X0    * Subroutine srSavOutParam has been added to the copy book member OEY2020
X0    *    srSavOutParam begsr
X0    *------------------------------------------------------------------------*
X0    *  Save all input params of Tax API
X0    *------------------------------------------------------------------------*
X0    * Subroutine srSavInParam has been added to the copy book member OEY2020
X0    *    srSavInParam  begsr
X0    *****************************************************************
X0    * Save data from other charges fields
X0    *****************************************************************
X0    * Subroutine srSaveOthChg has been added to the copy book member OEY2020
X0    *    SrSaveOthChg  begsr
X0    *****************************************************************
X0    * Save data from DS pTax_LineItems to pTax_SaveItems
X0    *****************************************************************
X0    * Subroutine srSaveItemDs has been added to the copy book member OEY2020
X0    *    SrSaveItemDs  begsr
X0    *****************************************************************
X0    * Restore tax field values from successful call to API
X0    *****************************************************************
X0    * Subroutine srRstTax has been added to the copy book member OEY2020
X0    *    srRstTax      begsr
YR    *--------------------------------------------------------------------------
YR    * The following Subroutines were moved to copy member (OEY2020 or OEY2021)
YR    *--------------------------------------------------------------------------
YR    *    AlignAddr     Begsr
YR    *    getOrd#       begsr
YR    *    srCNLTax      begsr
YR    *    AvaTaxVoidFld begsr
      *----------------------------------------------------------------
     OPOFTOH    E            UPDTOH
     O                       PONO13
     OPOFTOL1   E            UPTOL1
     O                       POCD14
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
     OIVFMSBR   E            OAMSBR
     O                       IVMO01
     O                       IVDY01
     O                       IVCC01
     O                       IVYR01
     O                       IVNM01
     O                       IVQYY9
     OOEFTOAH   E            OAHDR
     O                       OAMO14
     O                       OADY14
     O                       OACC14
     O                       OAYR14
     O                       OAMO15
     O                       OADY15
     O                       OACC15
     O                       OAYR15
     O                       OAMO16
     O                       OADY16
     O                       OACC16
     O                       OAYR16
     O                       OAMO17
     O                       OADY17
     O                       OACC17
     O                       OAYR17
     OOEFTDP    E            UNLKDP
     OOEFTDP    E            UPDTDP
     O                       DANO01
     O                       DANO15
     O                       DANO16
     O                       DPNM14
     O                       DPNO01
     OOEFTDP    E            DEPSIT
     O                       DPAM21
     O                       DPCD50
     O                       DPNM01
     O                       DPMO02
     O                       DPDY02
     O                       DPCC02
     O                       DPYR02
     O                       DPTM04
     OOEFTBL    E            UPDTBL
     O                       OBNO01
     O                       OBCD70
     OOEFTBH    E            UPDBH
     O                       OBNO01
     OOEFWRL1   E            WRL1
     O                       RELCDE
     OOEFWRL2   E            WRL2
     O                       RELQTY
     OOEFWRL2   E            RELLCK
     OOEFTOAD   E            TOAD
     O                       OEQY20
     O                       OEQY21
RA   OIVFMNSB   E            UPDNSB
RA   O                       NBMO01
RA   O                       NBDY01
RA   O                       NBCC01
RA   O                       NBYR01
RA   O                       NBNM01
RA   O                       NBQY23
WJ   OARFTCCT   E            UPDTCCT
WJ   O                       vARAMC7
WJ   O                       vARcdF6
WJ   O                       vARcdG4
      *------------------- TABLE FILE CHANGE AREA -----------------------------*
QV    * CHANGE MSG 178 FROM:
QV    * Quantity exceeds contract order total.
QV    * TO:
QV    * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
RH    * CHANGED MSG,88
RH    * BEFORE:QUANTITY LIMITED TO 99 FOR SERIAL NUMBERED ITEMS.
RH    * AFTER: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
RK    * Added entry 35 to UMS.
RI    * UMS,36  ADD
RI    * No tax jurisdiction assigned to zip code.
SL    * UMS,37  ADD
SL    * Quantities must be negative on a credit memo.
Q4    * Add messages to AMS:
Q4    * Work orders can only be created for a backorder quantity.
Q4    * Work orders will be deleted if retain backorder is no.
Q4    * Cannot create work order for non-fab items.
Q4    * Branch is not a fab branch. Work order creation not allowed.
Q4    * Unable to lock work order.  Make sure work order is not in use.
Q4    * Work order not found.
Q4    * Work order request not found.
SX    *   ADDED TABLE EMS AS FOLLOWS:
SX    * ** EMS
SX    * Extended amount exceeds the allowed value. Review the price/quantity.          1
SZ    * Added entry 181 to MSG:
SZ    * Not authorized to create open credit memo's in order entry.
TC    * Add entry 2 to EMS
TC    * B/O quantities not allowed with non-inventory items.                           2
TD    * Added entry 182 to MSG:
TD    * Not authorized to sell branch.
TD    * Change MSG 14 FROM:
TD    * Not authorized to branch/company.
TD    * TO:
TD    * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
TB    * Added entry 3 to EMS.
TE    * Added entry 4 - 8 to EMS:
TE    * Sub total amount exceeds the allowed value. Review the price/quantity.         4
TE    * Tax amount exceeds the allowed value. Review the price/quantity.               5
TE    * HST amount exceeds the allowed value. Review the price/quantity.               6
TE    * GST amount exceeds the allowed value. Review the price/quantity.               7
TE    * Total amount exceeds the allowed value. Review the price/quantity.             8
TF    * Added entry 9 and 10 to EMS:
TF    * Superseding item exists.
TF    * Replaced item exists with inventory.
TL    * Changed EMS,182
TL    *  BEFORE: Not authorized to sell branch.
TL    *  AFTER: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
TL    * ADDED EMS,183
TL    *  Not authorized to sell/ship branch.
TN    * Added EMS,11
TN    * Not authorized to this print type for credit memo.
TP    * Changed/removed EMS,10
TP    *  BEFORE: Replaced items exist with inventory.
TP    *  AFTER:  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
TP    * Added EMS,12
TP    * Over stock / superseded items exist with inventory.
SJ    * Added UMS,38
SJ    * Invalid zip code.
TW    * Added EMS,13
TW    * All components must have same reason code for price credit.
T4    * UMS,39  Add
T4    * Date ordered must be less than or equal to today's date.
VU    * EMS,14 ADDED
WV    * UMS, 40 added with below message
WV    *  Ship to address line 1 must be entered.
U5    * UMS,41 -43 Add
U5    * Ship method/code combination not valid.
U5    * Ship method/code not valid for branch.
U5    * Ship method/code not valid for transaction.
YS    * Override JOBQ to QFORMS for OEC0500
ZM    * Added UMS(44)
ZM    * Overhead items are not allowed.
0E    * Added A5
0E    * Card Processing Fee
¢B    * ADDED TABLE CSG
$U    * CHANGED CSG,1
$U    *  BEFORE:
$U    *  RA# first 7 pos must contain numbers & remainder field must be blank.
$U    *  AFTER:
$U    *  RA# first 7 or 8 pos must contain numbers & remainder field must be blank.
$V    * Added entry to CSG #20
$V    *  Pickup ship method requires code for At Counter or Will Call
$7    * Added entry to CSG #21
$7    *  Slash items are not allowed.
$9    * Added entry to CSG #22
$9    *  RA# must start with A/D/G followed by 8 numbers
:C    *  Changed entry for CSG #16 from Fuel Surcharge
:C    *   Delivery fee required for this customer
:I    * ADD ENTRY 23 TO TABLE CSG
:I    *   Credit card transactions do not match credit card amount.
:J    * ADD ENTRY 184 - 187 to MSG
:L    * ADD ENTRY 188 to MSG
:0    * ADD ENTRY 24 TO TABLE CSG
:6    * Change 184-187 from MSG to CSG as 25-28 and...
:6    * Change 188 from MSG to CSG as 29
:6    *  Must Select F22 to Create a Warranty Claim.
:6    *  For every 'W'arranty item you must enter a 'R'eplacement item.
:6    *  'W'arranty item must have qty -1; 'R'eplacement item must have qty 1
:6    *  Return authorization number has been used, please re-enter.
:6    *  Please use RGA for Price Corrections.
:9    * ADD 30 & 31 to CSG
#1    * ADD ENTRY 32 TO TABLE CSG
#7    * ADD ENTRY 33 TO TABLE CSG
#10   * ADD ENTRY 34 TO TABLE CSG
#K    * ADD ENTRY 35 TO TABLE CSG
#L    * ADD ENTRY 36 TO TABLE CSG
#S    * ADD ENTRY 37 TO TABLE CSG
#T    * ADD ENTRY 38 TO TABLE CSG
#Y    * ADD ENTRY 39 TO TABLE CSG
&A    * ADD ENTRY 40 TO TABLE CSG
&C    * ADD ENTRY 41 TO TABLE CSG
&E    * ADD ENTRY 42 TO TABLE CSG
&N    * ADD ENTRY 43 TO TABLE CSG
&P    * ADD ENTRY 44 TO TABLE CSG
&V    * ADD ENTRY 45 TO TABLE CSG
      *------------------------------------------------------------------------*
**
Freight Charge
**
Delivery Charge
**
Handling Charge
**
Restocking Charge
** A5
Card Processing Fee
**
SNDMSG MSG('XXXXXXXXXXXXXXXXX') TOMSGQ(OEMORDS)
**     (FX) - SUBMIT JOB TABLE FOR SENDING FAX
SBMJOB CMD(CALL PGM(OPC0500) PARM('XXXX' 'XXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXX' 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXX' 'XXXXXX' 'XXXXXX' ' ')) JOB(FM
_SOACK) JOBD(*LIBL/HDJPACK) JOBPTY(4) MSGQ(*NONE)
JOBQ(QFORMS)
**
IN LIEU OF
** MSG
*** Account On Hold xx/xx/xx ***                                              1
*** Cash Account ***                                                          2
*** Walk-In Customer ***                                                      3
*** Cust Over Limit By $                                                      4
*** Job Over Limit By $                                                       5
Additional deposits exist.                                                    6
Remaining amount to collect $                                                 7
You have collected $                                                          8
Withdrawal for order#                                                         9
*** Cust Over Credit Limit ***                                                10
*** Job Over Credit Limit ***                                                 11
Quote not allowed when the sales order number has been entered.               12
Correct branch number.                                                        13
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                 14
Account closed, order cannot be entered for this customer.                    15
Account not found in company/branch.                                          16
Only one search may be requested.                                             17
Area code and prefix must be entered for telephone search.                    18
Telephone number must be entered for walk-in customers.                       19
Search for telephone number not found.                                        20
For a scan search, the name must be enclosed in quotes.                       21
Customer information must be entered.                                         22
Search for customer not found.                                                23
Customer not found.                                                           24
Requested zip code not found.                                                 25
Order number already on file.                                                 26
Order number out of range allowed.                                            27
Invalid entered by initials.                                                  28
Enter cash sale or charge sale.                                               29
Invalid print type.                                                           30
Enter type of price- - "L"ist or "T"rade.                                     31
Enter correct order date.                                                     32
Age code is only valid for credit/debit memo's.                               33
Enter correct ship date.                                                      34
Reference number is only valid for credit/debit memo's.                       35
Enter correct promised ship date.                                             36
Enter the purchase order number.                                              37
Enter the job name.                                                           38
Job number is required for this customer.                                     39
Job has lien or is completed, unable to enter order.                          40
Method of shipment not valid with direct.                                     41
Enter method of shipment.                                                     42
Only one method of shipment may be entered.                                   43
Method of shipment requires ship via description.                             44
Enter a valid code - "D"irect, "S"pecial, "I"nventory.                        45
All quantity defaulted to shipped for direct cash sale or direct invoice      46
Invalid tax jurisdiction.                                                     47
Invalid shipping address.                                                     48
Order lost if F3 is pressed again.                                            49
No alternate UOMs exist for this item.                                        50
Enter the "C"redit, "D"ebit, "O"rder, or "Q"uote field.                       51
Quote not allowed for charge sale invoice, cash sale invoice, or C.O.D.       52
This billing period has been closed.                                          53
Only one alternate UOM may be selected.                                       54
Enter salesperson ID.                                                         55
Salesperson ID not valid.                                                     56
Invalid tax information. Tax must be 'Y' (Yes) or 'N' (No).                   57
Enter the other charges field.                                                58
Enter or correct the order source type.                                       59
Enter or correct the order sale type.                                         60
Invalid terms information. Terms must be 'Y' (Yes) or 'N' (No).               61
Invalid age code.                                                             62
Enter the invoice reference number.                                           63
Other charges requested, enter at least one.                                  64
For collect orders, customer freight billing account number is required.      65
'N' not allowed, line item is not a lot controlled item.                      66
Item contains hazardous materials that cannot be shipped on this carrier.     67
Warning! This item has required associated items.                             68
Price is protected!  Price returned was not retained!                         69
Cash, check, or credit card amount not allowed during C.O.D entry.            70
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       71
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       72
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       73
Enter the cash, check, or credit card amount.                                 74
Enter the check number.                                                       75
Amounts do not add to invoice total.                                          76
The cash, check, and credit card amount must equal the invoice amount.        77
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX         78
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX         79
Verify totals, press enter to continue.                                       80
Correct branch number.                                                        81
Enter "Y" for direct ship, or blank if not direct.                            82
Branch is invalid when item is direct ship.                                   83
Direct ship items not allowed for cash sales.                                 84
All lines must be direct if header is direct.                                 85
Cash items must be shipped from header ship branch.                           86
Warning! Item does not exist in the counter book.                             87
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.                            88
Non-stock item not found in purchasing.                                       89
Non-stock item already exists.                                                90
Description must be entered for a non-stock item.                             91
Enter quantity ordered.                                                       92
Section not found in purchasing book.                                         93
Line item comments must follow a line item.                                   94
Item number not found in item master.                                         95
Before continuing, line items must be entered.                                96
Substitutes do not exist for this item.                                       97
Item is not stocked at this branch.                                           98
Insufficient stock for this item.                                             99
Warning! Ship branch/direct changed, review branch/dir changes to line items. 100
Verify line items, press enter to continue.                                   101
Invalid discount entered.                                                     102
Enter the selling unit of measure.                                            103
Enter the unit price.                                                         104
This function is not available.                                               105
Warning! Negative gross profit.                                               106
Warning! Billing period is greater than next month or less than last month.   107
Open orders not set up for type of print.                                     108
Pending orders not set up for type of print.                                  109
Reserved orders not set up for type of print.                                 110
Credit/debit memo may not be reserved.                                        111
Enter "Y" or "N" for "Enter serial numbers" question.                         112
Cannot generate P/O unless backorders are retained.                           113
Cannot generate P/O if status is pending.                                     114
Enter "Y" or "N" for "Retain Backorders" question.                            115
Enter serial numbers.                                                         116
Duplicate serial numbers were entered for this order.                         117
Warning! Serial number(s) entered already exists.                             118
Verify serial numbers, press enter to continue.                               119
Quantity must be 1 for tagged item.                                           120
Invalid reason code entered.                                                  121
Invalid damaged tag number entered.                                           122
Damaged tag number was previously entered.                                    123
Invalid cursor location for F4=Prompt.                                        124
Order type must be reserved if ship complete = Y.                             125
Terms information is not allowed for cash sales.                              126
Terms Discount must be zero if terms = 'N' or terms code is blank.            127
Invalid terms code.                                                           128
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX        129
Terms Discount cannot be less than zero.                                      130
Bulk Pricing must be a 'Y' (Yes) or 'N' (No).                                 131
Stocking unit of measure must be used on direct ship sales orders.            132
Unit of measure has not been set up for this item or access code is not 'Y'.  133
Invalid unit of measure.                                                      134
                                                                              135
*** Job Within Credit Limit ***                                               136
Warning! G/P % not within acceptable range.                                   137
Job number is invalid.                                                        138
Order lost if F5 is pressed again.                                            139
Invalid freight type.                                                         140
Warning! Quantity ordered is not a multiple of Reference UOM.                 141
Freight terms must be entered for direct ship orders.                         142
Warning! This branch is closed.                                               143
*** Cash Account On Hold  xx/xx/xx ***                                        144
Not authorized to item price inquiry.                                         145
The customer P/O number does not exist.                                       146
No open transactions exist for the customer/item.                             147
Transfer branch is invalid for Credit, Debit, or Quotes.                      148
Transfer branch cannot be the same as the shipping branch.                    149
Transfer branch is only valid for stock, component, or nonstock items.        150
Transfer branch valid only with backorder quantity.                           151
Generate transfers cannot be yes if retain backorder is no.                   152
Generate transfers cannot be yes if order status is pending.                  153
You are not authorized to create transfers.                                   154
Restricted item. "Ord By" is not authorized to purchase.                      155
Restricted item. "Ord By" has expired license and cannot purchase.            156
Restricted item. "Ord By" must be entered.                                    157
There are no open transactions for this customer.                             158
This order will be placed on credit hold!                                     159
This order will be placed on credit hold, cannot invoice!                     160
Temporary item must be verified.                                              161
*** Ent Over Limit By $                                                       162
Quantity for a lot must be one.                                               163
Price exceeds contract order total.                                           164
Enter correct fax number.                                                     165
Return authorization number required for this item.                           166
You must void credit cards taken before you can change the selling branch.    167
You must void credit cards taken before changing sales order to charge.       168
You must void credit cards taken before changing from invoice to ticket.      169
Cannot use a pricing UOM as an order UOM.                                     170
Invalid ship method/code.                                                     171
Email ability is not currently set up. Cannot specify 'E'.                    172
Period definition not found for this date.  Date not allowed.                 173
Terms code with installments not allowed for credit/debit.                    174
Warning! tax jurisdiction is not attached to zip code.                        175
Tax jurisdiction not valid with overridden zip code.                          176
Warning! Tax jurisdiction code has been re-defaulted.                         177
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       178
Warning! Other charge tax flags have been re-defaulted.                       179
Account number must be entered.                                               180
Not authorized to create open credit memo's in order entry.                   181
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       182
Not authorized to sell/ship branch.                                           183
** CSG
RA# first 7 or 8 pos must contain numbers & remainder field must be blank.    1
Duplicate GMC Tag#/RA#.  Throw away tag!                                      2
No charge sls orders disallowed for salesman id WAR.                          3
Duplicate GMC Tag#/RA# within this credit memo.  Correct one.                 4
BO disallowed for DNR (do not reorder) item.                                  5
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       6
Our truck shipments disallowed for ship to state                              7
Invalid ship to state                                                         8
Invalid zip code                                                              9
Shipments to this state should not be taxable                                 10
Price is below minimum price limit                                            11
Ship type O required if delivery amount <> 0                                  12
Our truck deliveries disallowed for walkins                                   13
Warranty fee must be charged for this customer.                               14
Customer should not be charged Warranty Fee.                                  15
Delivery fee required for this customer.                                      16
Sls# for walkins must be 'HSE'.                                               17
Freight is disallowed for this customer.                                      18
Invalid value.  Enter I or U.                                                 19
Pickup ship method requires code for At Counter or Will Call.                 20
Slash items are not allowed.                                                  21
RA# must start with A/D/G followed by 8 numbers                               22
Credit card transactions do not match credit card amount.                     23
Boles customer not available until March.                                     24
Must Select F22 to Create a Warranty Claim.                                   25
For every 'W'arranty item you must enter a 'R'eplacement item.                26
'W'arranty item must have qty -1; 'R'eplacement item must have qty 1          27
Return authorization number has been used, please re-enter.                   28
Please use RGA for Price Corrections.                                         29
Please use RGA for Credit Return.                                             30
Please use RGA for an Incorrect Shipment.                                     31
Return authorization number cannot exceed a length of 10.                     32
Credits must be entered through RGA for Hiller job 'WARR'.                    33
Promo not valid at this time.                                                 34
Sell branch disallowed.                                                       35
Ship code is required.                                                        36
Express Pickup and At Counter Orders cannot be placed on Reserve.             37
Unit Exchange Claims must be placed through RGA.                              38
Promised ship date must be greater than date ordered.                         39
Warranty claims cannot be invoiced through order entry.                       40
Please use RGA for a return affecting inventory.                              41
Selling branch cannot be a hub.                                               42
Backorders cannot exist with a promo code.                                    43
WILL CALL is not eligible for immediate invoicing.                            44
AFS preorder has been created ID:                                             45
AFS preorder not created.                                                     46
** UMS
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       1
This customer is not eligible for immediate invoicing.                        2
Warning! Selling branch does not match purchase order entered by branch.      3
Non-stock item not found on previous order.                                   4
Please verify notes, press enter to continue.                                 5
Value must not be less than 0.                                                6
Job has pending status, unable to enter order.                                7
Direct shipment not allowed when releasing from reserved orders.              8
Substitute not allowed for items tagged to purchase orders.                   9
Component entry/maintenance not allowed for items tagged to purchase orders.  10
Non-stock is on a direct P/O.  Must be direct on sales order.                 11
Non-stock is on a non-direct P/O.  Direct not allowed.                        12
Non-stock is on a direct P/O.  Transfer not allowed.                          13
GST Percent  . .                                                              14
HST Percent  . .                                                              15
GST                                                                           16
HST                                                                           17
GST Tax Amt                                                                   18
HST Tax Amt                                                                   19
Warning, no other charge amounts have been entered.                           20
Non-stock item not found on purchase order for this customer.                 21
Date promised cannot be greater nor less than two years from current year.    22
Component maintenance not allowed for item released from contract.            23
*** Enterprise Over Credit Limit ***                                          24
Print type must be 'I' for direct cash sale.                                  25
Insufficient stock for this item and stocking code equal to 'N'.              26
Maximum number of lines exceeded. Combo cannot be entered.                    27
P/O generation not allowed if order is placed on credit hold.                 28
'E' is not a valid selection for the component items.                         29
Quantity ordered cannot be a negative value.                                  30
Components need price and cost. Use component maintenance.                    31
Cannot transfer from a closed or non-operational branch.                      32
Warning! Terms code has been changed, please verify.                          33
This reason code is not valid for a WM branch.                                34
Ship date must be less than or equal to today's date.                         35
No tax jurisdiction assigned to zip code.                                     36
Must be Non-Taxable to follow header.                                         37
Invalid zip code.                                                             38
Date ordered must be less than or equal to today's date.                      39
Ship to address line 1 must be entered.                                       40
Ship method/code combination not valid.                                       41
Ship method/code not valid for branch.                                        42
Ship method/code not valid for transaction.                                   43
Overhead items are not allowed.                                               44
** AMS
Generate work orders cannot be yes if retain backorder is no.                 1
Generate work orders cannot be yes if order status is pending.                2
Work order can only be created for a backorder quantity.                      3
Work orders will be deleted if retain backorder is no.                        4
Cannot create work order for non-fab items.                                   5
Branch is not a fab branch. Work order creation not allowed.                  6
Unable to lock work order.  Make sure work order is not in use.               7
Work order not found.                                                         8
Work order request not found.                                                 9
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
** CRM
SNDMSG MSG('Held S/O XXXXXXX for Customer XXXX
XXXXXXXXXXXXXXXXXXXXXXXXXX') TOUSR(XXXXXXXXXX)
** INV
SNDMSG MSG('Credit hold message for user XXXXXXXXXX was not
sent! This ID is not valid! See table OE90.') TOUSR(QSYSOPR)
** WM
Sales order cannot contain negative quantity ordered items.
Ship via/code not valid.  Please correct.
Quantities must be negative on a credit memo.
** VOD
SBMJOB CMD(CALL PGM(OER8205) PARM('XXXXXXX' 'X'))
 JOB(BOFILL) JOBD(*LIBL/HDJPACK)
** DOA Submit job for Direct Order Audit
SBMJOB JOB(DIRAUDIT) JOBD(HDJPACK) RQSDTA('CALL PGM(POR0010) PARM(''S'
' ''XXXXXXX'')') JOBPTY(4) LOG(0) MSGQ(*NONE)
** EMS
Extended amount exceeds the allowed value. Review the price/quantity.          1
B/O quantities not allowed with non-inventory items.                           2
Cannot access customer contacts because you are already in that same program.  3
Sub total amount exceeds the allowed value. Review the price/quantity.         4
Tax amount exceeds the allowed value. Review the price/quantity.               5
GST amount exceeds the allowed value. Review the price/quantity.               6
HST amount exceeds the allowed value. Review the price/quantity.               7
Total amount exceeds the allowed value. Review the price/quantity.             8
Superseding item exists.                                                       9
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                        10
Not authorized to this print type for credit memo.                             11
Over stock / superseded items exist with inventory.                            12
All components must have same reason code for price credit.                    13
Item being sold is DNR, and will no longer be carried.                         14
