     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - IVR6200                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D WAC TRICKLE DOWN                                                      *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
AA   F*U 8000009877 040706 070 DATA BASE CHANGES FOR INV BALANCING             *
AB   F*U 8000009876 072606 070 NON-STOCK INVENTORY BALANCING                   *
AC   F*U 8000009906 082206 070 POPULATE FIELDS ADDED FOR INV BAL               *
AD   F*E 8000009570 110106 062 HD/WO INTERFACE                                 *
AE   F*E 8000009966 020907 914 CHANGE S/O NUMBER TO 7 ALPHA                    *
AF   F*U 8000010272 121207 019 Use Unit Cost for W/O Rcpt, not Extended        *
AG   F*E 8000010256 022808 019  Weighted Average Freight                       *
AH   F*E 8000010344 072208 915  RENAME WOPWAC IN HD DUE TO MSS/LM              *
AI   F*E 8000010325 012109 070 WEIGHTED AVERAGE REBATES                        *
AJ   F*E 1290000353 010416 248 WAR V3 SPECIAL BUY                              *
     F*M ----------------------------------------------------------------------*
     FIVLTADJ4  IF   E           K DISK
   ACF*IVLTTL4   IF   E           K DISK
AC   FIVLTRL1   IF   E           K DISK
   ABF*IVLWAC1   IF   E           K DISK
AB   FIVLWAC3   IF   E           K DISK
     FPOLTRD1   IF   E           K DISK
     FPOLWAC1   IF   E           K DISK
     F                                     RENAME(POFWAC:POFWAC1)
   ADF*WOLTRD1   IF   E           K DISK
AD   FWKLTRCPT1 IF   E           K DISK
     D                 DS                  INZ
     D  RCNCC                  1      2  0
     D  RCNYR                  3      4  0
     D  RCNMO                  5      6  0
     D  RCNPRD                 1      6  0
     D                 DS                  INZ
     D  IVCC55                 1      2  0
     D  IVYR55                 3      4  0
     D  IVMO55                 5      6  0
     D  IVDT55                 1      6  0
   ACD*                DS                  INZ
   ACD* IVCC57                 1      2  0
   ACD* IVYR57                 3      4  0
   ACD* IVMO57                 5      6  0
   ACD* IVDT57                 1      6  0
AC   D                 DS                  INZ
AC   D  IVCC56                 1      2  0
AC   D  IVYR56                 3      4  0
AC   D  IVMO56                 5      6  0
AC   D  IVDT56                 1      6  0
     D                 DS                  INZ
     D  POCCA1                 1      2  0
     D  POYRA1                 3      4  0
     D  POMOA1                 5      6  0
     D  PODTA1                 1      6  0
     D                 DS                  INZ
   ADD* WOCC13                 1      2  0
   ADD* WOYR13                 3      4  0
   ADD* WOMO13                 5      6  0
AD   D  ACCPERCCMK             1      2  0
AD   D  ACCPERYRMK             3      4  0
AD   D  ACCPERMOMK             5      6  0
     D  WODT13                 1      6  0
     IIVFTADJ
     I              IVAMY7                      AJAMY7
     I              IVAMY8                      AJAMY8
     I              IVAMZ1                      AJAMZ1
     I              IVAMZ3                      AJAMZ3
     I              IVQYX8                      AJQYX8
     I              IVQY24                      AJQY24
   ACI*IVFTTL
   ACI*             IVAM31                      RCVCST
   ACI*             IVQYX5                      RCVQTY
AC   IIVFTRL
AC   I              IVAMAT                      RCVCST
AC   I              IVQY26                      RCVQTY
     IPOFWAC1
     I              IVAMW6                      XXW6
     I              IVQY01                      XX01
AA ABI*             IVNON1                      I1NON1
     IIVFWACA       49
     I              IVAMY8                      WACBEF
     I              IVQYX8                      OHBEF
AA   I              IVNON1                      I2NON1
     IIVFWAC        48
     I              IVAMW6                      WACBEF
     I              IVQY01                      OHBEF
AA   I              IVNON1                      I3NON1
     IPOFWAC        47
     I              IVAMW6                      WACBEF
     I              IVQY01                      OHBEF
AA   I              IVNON1                      I4NON1
   AHI*WOFWAC        46
AH   IIVFWACW       46
     I              IVAMW6                      WACBEF
     I              IVQY01                      OHBEF
AA   I              IVNON1                      I5NON1
AA   IPOFTRD
AA   I              IVNON1                      I6NON1
AA ADI*WOFTRD
AA ADI*             IVNON1                      I7NON1
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
   AEC*                  PARM                    RCVNUM
AE   C                   PARM                    RCVNUM            7
     C                   PARM                    RCVLIN
     C                   PARM                    NEWWAC
     C                   PARM                    PMCRPD            6
     C                   PARM                    ENDTRN
     C                   PARM                    ENDTYP            3
     C     PL212         PLIST
     C                   PARM                    PONO19
     C                   PARM                    PONO05
     C                   PARM                    RCVQTY
     C                   PARM                    RCVCST
AG   C                   PARM                    RCVFRT            9 4
AI   C                   PARM                    RCVREB            9 4
AJ   C                   PARM                    RCVSPC            9 4
     C                   PARM                    CHNVAL
   ADC*    PLW212        PLIST
   ADC*                  PARM                    PONO19
   ADC*                  PARM                    OENO22
   ADC*                  PARM                    RCVQTY
   ADC*                  PARM                    RCVCST
   ADC*                  PARM                    CHNVAL
      *------------------------------------------------------------------------*
      * STEP 2.  DECLARE KEY LISTS
      *------------------------------------------------------------------------*
     C     PRCVKY        KLIST
     C                   KFLD                    PONO19
     C                   KFLD                    PONO05
     C     RCVKEY        KLIST
   AEC*                  KFLD                    RCVNUM
AE   C                   KFLD                    RCVNUM#
     C                   KFLD                    RCVLIN
     C     TFRKEY        KLIST
     C                   KFLD                    IVNO26
     C                   KFLD                    IVNO44
     C     WACKY1        KLIST
     C                   KFLD                    PONO22
     C                   KFLD                    IVNO07
AB   C                   KFLD                    IVNON1
     C                   KFLD                    POCC10
     C                   KFLD                    POYR10
     C                   KFLD                    POMO10
     C                   KFLD                    PODY10
     C                   KFLD                    POTM05
     C     WACKY2        KLIST
     C                   KFLD                    PONO22
     C                   KFLD                    IVNO07
AB   C                   KFLD                    IVNON1
     C     WRCVKY        KLIST
     C                   KFLD                    PONO19
     C                   KFLD                    OENO22
      *------------------------------------------------------------------------*
      * STEP 3.  FIELD DEFINITIONS
      *------------------------------------------------------------------------*
     C     *LIKE         DEFINE    XX01          CHGQTY
   AEC*    *LIKE         DEFINE    PONO19        RCVNUM
     C     *LIKE         DEFINE    PONO05        RCVLIN
     C     *LIKE         DEFINE    PONO19        ENDTRN
     C     *LIKE         DEFINE    XXW6          NEWWAC
     C     *LIKE         DEFINE    OHBEF         OHAFT
     C     *LIKE         DEFINE    WACBEF        WACAFT
     C     *LIKE         DEFINE    OHBEF         RCVVAR
      *------------------------------------------------------------------------*
      * STEP 4.  INITIALIZATIONS AND RESETS
      *------------------------------------------------------------------------*
     C                   MOVEL     PMCRPD        RCNPRD
     C                   Z-ADD     NEWWAC        WACAFT
     C                   Z-ADD     0             RCVVAR
      *------------------------------------------------------------------------*
      *  SECTION 1      PROCESS TRICKLE DOWN
      *
      * STEP 1.
      *------------------------------------------------------------------------*
      * Get initial receiver entry date and time
      * This will be used to determine where to start the trickle down
AE   C                   MOVE      RCVNUM        RCVNUM#           7 0
     C     RCVKEY        CHAIN     POFWAC1                            49
      *
      * Recalculate WAC and On Hand for any proceeding receivers,
      * stopping at the last receipt processed in the eom recalc from
      * the inventory recon transaction file
   ABC*    WACKY1        SETGT     IVLWAC1
AB   C     WACKY1        SETGT     IVLWAC3
     C     *IN40         DOUEQ     *ON
     C                   MOVEA     '0000'        *IN(46)
   ABC*    WACKY2        READE     IVLWAC1                                40
AB   C     WACKY2        READE     IVLWAC3                                40
     C     *IN40         IFEQ      *OFF
     C                   Z-ADD     *ZEROS        AMTBEF
     C                   Z-ADD     *ZEROS        RCVAMT
     C                   Z-ADD     *ZEROS        OHAFT
     C                   Z-ADD     *ZEROS        AMTAFT
      * PURCHASE ORDER RECEIVER DETAIL FILE...
     C     *IN47         IFEQ      *ON
     C     PRCVKY        CHAIN     POFTRD                             45
     C     *IN45         IFEQ      *OFF
     C     PODTA1        IFLE      RCNPRD
     C                   MOVE      *ZEROS        RCVQTY
     C                   MOVE      *ZEROS        RCVCST
     C                   MOVE      *BLANKS       CHNVAL            1
     C                   CALL      'POR0212'     PL212
     C     CHNVAL        IFEQ      'Y'
     C                   EXSR      CLCWAC
     C                   ENDIF
     C                   ELSE
     C     OHBEF         SUB       IVQYAA        CHGQTY
     C                   ADD       CHGQTY        RCVVAR
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     WACAFT        NEWWAC
     C                   ELSE
      * TRANSFER DETAIL FILE...
     C     *IN48         IFEQ      *ON
   ACC*    TFRKEY        CHAIN     IVFTTL                             45
AC   C     TFRKEY        CHAIN     IVFTRL                             45
     C     *IN45         IFEQ      *OFF
   ACC*    IVDT57        IFLE      RCNPRD
AC   C     IVDT56        IFLE      RCNPRD
     C                   EXSR      CLCWAC
     C                   ELSE
     C     OHBEF         SUB       IVQYAA        CHGQTY
     C                   ADD       CHGQTY        RCVVAR
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     WACAFT        NEWWAC
     C                   ELSE
      * W/O RECEIVER DETAIL FILE...
     C     *IN46         IFEQ      *ON
   ADC*    WRCVKY        CHAIN     WOFTRD                             45
AD   C     PONO19        CHAIN     WKFTRCPT                           45
     C     *IN45         IFEQ      *OFF
     C     WODT13        IFLE      RCNPRD
   ADC*                  MOVE      *ZEROS        RCVQTY
   ADC*                  MOVE      *ZEROS        RCVCST
   ADC*                  MOVE      *BLANKS       CHNVAL
   ADC*                  CALL      'WOR0212'     PLW212
   ADC*    CHNVAL        IFEQ      'Y'
AD   C                   Z-ADD(h)  TOTRECQYMK    RCVQTY
AD AFC*                  Z-ADD(h)  TRCCSTAMMK    RCVCST
AF   C                   if        totrecqymk <> 0
AF   C                   eval(h)   rcvcst = trccstammk/totrecqymk
AF   C                   else
AF   C                   eval(h)   rcvcst = trccstammk
AF   C                   endif
     C                   EXSR      CLCWAC
   ADC*                  ENDIF
     C                   ELSE
     C     OHBEF         SUB       IVQYAA        CHGQTY
     C                   ADD       CHGQTY        RCVVAR
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     WACAFT        NEWWAC
     C                   ELSE
      * INVENTORY ADJUSTMENT FILE...
     C     *IN49         IFEQ      *ON
     C     WACBEF        IFEQ      IVAMZ3
     C     IVQY24        ORLT      *ZEROS
     C     IVAMY7        ANDNE     *ZEROS
     C                   ITER
     C                   ENDIF
     C     IVNO40        CHAIN     IVFTADJ                            45
     C     *IN45         IFEQ      *OFF
     C     IVDT55        IFLE      RCNPRD
      * THE WAC WILL BE CALCULATED DIFFERENTLY BASED ON WHAT TYPE
      * OF ADJUSTMENT HAS TAKEN PLACE, THE TYPE OF ADJUSTMENTS THAT
      * AFFECT WAC ARE:
      * 1. A QUANTITY AND COST ADJUSTMENT
      * 2. A COST ONLY ADJUSTMENT
      * 3. A TOTAL COST ADJUSTMENT
      *
      * 1. A QUANTITY AND COST ADJUSTMENT
      *
     C     IVQY24        IFNE      *ZEROS
     C     IVAMY7        ANDNE     *ZEROS
     C                   EXSR      CLCWAC
     C                   ELSE
      * PUT THE CORRECT RECALCULATED WAC INTO
      * THE WAC SAVED AT THE INITIAL ENTRY OF THE ADJUSTMENT...
     C                   Z-ADD     WACAFT        WACBEF
      * ADJUST THE ON HAND QUANTITY THAT WAS SAVED AT THE INITIAL
      * ENTRY OF THE ADJUSTMENT...
     C                   ADD       RCVVAR        OHBEF
      * CALCULATE THE VALUE OF THE ADJUSTED "FROZEN" ON HAND AND WAC,
     C     OHBEF         MULT(H)   WACBEF        AMTBEF
      *
      * 2. A COST ONLY ADJUSTMENT
     C     IVAMY7        IFNE      *ZEROS
     C     IVQY24        ANDEQ     *ZEROS
     C                   Z-ADD     IVAMY7        WACAFT
     C                   ELSE
      *
      * 3. A TOTAL COST ADJUSTMENT
     C     IVAMZ1        IFNE      *ZEROS
     C     AMTBEF        ADD       IVAMZ1        AMTAFT
     C     AMTAFT        DIV(H)    OHBEF         WACAFT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   Z-SUB     IVQY24        CHGQTY
     C                   ADD       CHGQTY        RCVVAR
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     WACAFT        NEWWAC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * Check to see if we have processed the last receipt processed
      * in program IVR0951.  If this is the last receipt, leave the
      * trickle down.
     C                   SELECT
     C     ENDTYP        WHENEQ    'POR'
     C     *IN47         ANDEQ     *ON
     C     PONO19        ANDEQ     ENDTRN
     C                   LEAVE
     C     ENDTYP        WHENEQ    'TRR'
     C     *IN48         ANDEQ     *ON
     C     IVNO26        ANDEQ     ENDTRN
     C                   LEAVE
     C     ENDTYP        WHENEQ    'WOR'
     C     *IN46         ANDEQ     *ON
     C     PONO19        ANDEQ     ENDTRN
     C                   LEAVE
     C                   ENDSL
     C                   ENDIF
     C                   ENDDO
     C                   MOVE      *ON           *INLR
      *----------------------------------------------------------------
      * Calculate Wac
      *----------------------------------------------------------------
     C     CLCWAC        BEGSR
      * GET ON HAND AND WAC BEFORE
     C                   ADD       RCVVAR        OHBEF
     C                   Z-ADD     WACAFT        WACBEF
      * CALCULATE INVENTORY VALUE BEFORE
     C     OHBEF         MULT(H)   WACBEF        AMTBEF           15 7
      * CALCULATE RECEIVER AMOUNT
     C     RCVQTY        MULT(H)   RCVCST        RCVAMT           15 7
      * CALCULATE ON HAND AFTER
     C     OHBEF         ADD       RCVQTY        OHAFT
      * CALCULATE INVENTORY VALUE AFTER
     C     AMTBEF        ADD       RCVAMT        AMTAFT           15 7
      * CALCULATE NEW W.A.C.
      * IF NEW O/H QUANTITY IS NEGATIVE OR ZERO, THEN
      *     WAC WILL EQUAL TO WAC BEFORE.
      * IF THE FROZEN ON HAND IS LESS THAN OR EQUAL TO ZERO
      *     PUT THE RECEIVER COST INTO WAC...
     C     OHAFT         IFLE      *ZEROS
     C                   Z-ADD     WACBEF        WACAFT
     C                   ELSE
     C     OHBEF         IFLE      *ZEROS
     C                   Z-ADD     RCVCST        WACAFT
     C                   ELSE
     C     AMTAFT        DIV(H)    OHAFT         WACAFT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
