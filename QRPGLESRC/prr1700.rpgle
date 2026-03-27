     H OPTION(*SRCSTMT : *NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - PRR1700                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D PRICE BOOK REQUEST                                                    *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    Allows users to request a customer price book or price analysis    *
     F*S    report.                                                            *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
¢A   F*V KSB   5899 031913 KSB Omit some options                               *
¢B   F*V KSB   8189 102924 KSB Change deft value email                         *
¢C   F*V JJF   3139 061025 JJF Submit to QPGMR job queue                       *
¢D   F*V JJF   3194 032626 JJF F7 to call LISTPRBK for item exclusions         *
     F*M ----------------------------------------------------------------------*
     FPRD1700   CF   E             WORKSTN
     F                                     INFDS(FIL1DS)
     FPRLPBRQ1  O  A E           K DISK
     FARLMCUS1  IF   E           K DISK    PREFIX(CM_)
     FARLMENT1  IF   E           K DISK    PREFIX(EP_)
     FARLMJBM1  IF   E           K DISK    PREFIX(JM_)
     FARLMBCH4  IF   E           K DISK    PREFIX(BM_)
     FPRLMDPH1  IF   E           K DISK    PREFIX(DP_)
     FIVLMCBT1  IF   E           K DISK    PREFIX(CB_)
     FIVLMPBT1  IF   E           K DISK    PREFIX(PB_)
     FIVLMSBT1  IF   E           K DISK    PREFIX(SB_)
     FAPLMVEN1  IF   E           K DISK    PREFIX(VM_)
     FPRLMCPH1  IF   E           K DISK    PREFIX(CP_)
     FTBLMTBL1  IF   E           K DISK

     D MSG             S             78    DIM(21) CTDATA PERRCD(1)
¢C   D CMS             S             78    DIM(3) CTDATA PERRCD(1)
¢A   D*SJB             S              1    DIM(280) CTDATA PERRCD(70)           SUBMIT JOB
¢A   D SJB             S              1    DIM(420) CTDATA PERRCD(70)           SUBMIT JOB

     D                SDS
     D  PRGNM                  1     10
     D  PROG                   1      8
     D  User_Name            254    263

     D FIL1DS          DS
     D  SCREEN               261    268
     D  C@LOC                370    371B 0
     D  CPFRRN               378    379B 0
      * Sales history date range
     D FDATE           DS
     D FROM_SDATE              1      6  0
     D  FROM_SMONTH            1      2  0
     D  FROM_SDAY              3      4  0
     D  FROM_SYEAR             5      6  0

     D TDATE           DS
     D TO_SDATE                1      6  0
     D  TO_SMONTH              1      2  0
     D  TO_SDAY                3      4  0
     D  TO_SYEAR               5      6  0

     D SELDS           DS                  OCCURS(900)
     D  CNBR                   1      6  0
     D  CNAM                   7     36
     D  CADD                  37     66

     D PRFDS           DS                  OCCURS(300) INZ
     D  DSPNO                  1      7

     D CRCD#           S                   LIKE(CRCD)
     D CFLD#           S                   LIKE(CFLD)
     D COL             S                   LIKE(CCOL)
     D ROW             S                   LIKE(CROW)
     D F4ERR           S              1
     D VERIFIED        S              1    INZ('N')
     D WDWFLG          S              1
     D NO01#           S              6
     D NO06#           S              7
     D SBMJOB_PROF     S              7
     D SBMJOB_CUST     S              6
     D File_Name       S             10
     D Library         S             10
      * Enterprise or customer flag
     D EorC_Flag       S              1    INZ(' ')
     D Allow_Email     S              1    INZ('N')
     D Allow_Cost      S              1    INZ('N')
     D Cost_Warning    S              1    INZ('N')
     D SBMJOB_Name     S             10    INZ('CUST_PR_BK')
 ¢A  D wk2ndv          S              6a
 ¢A  D wk3rdv          S              6a
 ¢A  D wkvend          S              6a
 ¢A  D wkv_NAME        S             15a
 ¢D    dcl-s companyNumber   packed(15:5);
 ¢D    dcl-s branchNumber    packed(15:5);
 ¢D    dcl-s customerNumber  packed(15:5);
      *--------------------------------------------------------*
 ¢D   // Omit Items from Price Book
 ¢D    dcl-pr listprbk extpgm('LISTPRBK');
 ¢D     incompany   packed(15:5);
 ¢D     inbranch    packed(15:5);
 ¢D     incustomer  packed(15:5);
 ¢D    end-pr;
      *--------------------------------------------------------*
     C     HELP          PLIST
     C                   PARM                    PROG
     C                   PARM                    SCREEN
      *--------------------------------------------------------*
     C     PL0060        PLIST
     C                   PARM                    VALUE#            9
     C                   PARM                    ACT#              1
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
      *--------------------------------------------------------*
     C     PL1701        PLIST
     C                   PARM                    FROM              6 0
     C                   PARM                    TO                6 0
     C                   PARM                    REQ_TYPE          1
     C                   PARM                    RETCOD            1 0
     C                   PARM                    C@LOC#            6
     C                   PARM                    CRCD#            10
     C                   PARM                    CFLD#            10
      *--------------------------------------------------------*
     C     PL5620        PLIST
     C                   PARM                    SBR#              3
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
      *--------------------------------------------------------*
     C     PL1702        PLIST
     C                   PARM                    SBMJOB_PROF
     C                   PARM                    SBMJOB_CUST
     C                   PARM                    PRCD98
     C                   PARM                    PRCDB2
     C                   PARM                    PRCDA2
     C                   PARM                    File_Name
     C                   PARM                    Library
     C                   PARM                    EMAIL
     C                   PARM                    RETCOD
     C                   PARM                    C@LOC#            6
     C                   PARM                    CRCD#            10
     C                   PARM                    CFLD#            10
      *--------------------------------------------------------*
     C     PL1703        PLIST
     C                   PARM                    SBMJOB_PROF
     C                   PARM                    File_Name
     C                   PARM                    Library
     C                   PARM                    RETCOD
     C                   PARM                    C@LOC#            6
     C                   PARM                    CRCD#            10
     C                   PARM                    CFLD#            10
      *--------------------------------------------------------*
     C     PL4516        PLIST
     C                   PARM                    SELDS                          SELECT CUSTOMERS
     C                   PARM                    RETCOD
     C                   PARM      'Y'           ALWENT            1            ALLOW ENTERPRISE Y/N
      *--------------------------------------------------------*
     C     PL5720        PLIST
     C                   PARM                    NO01#
     C                   PARM                    NO06#
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
     C                   PARM                    STAT              1
      *--------------------------------------------------------*
     C     PL3009        PLIST
     C                   PARM                    RSEC              3
     C                   PARM                    RGRP              3
     C                   PARM                    RCAT              3
     C                   PARM                    PRCD89
     C                   PARM                    RTYPE             1
     C                   PARM                    RETCOD            1 0
     C                   PARM                    C@LOC#            6
     C                   PARM                    CRCD#            10
     C                   PARM                    CFLD#            10
      *--------------------------------------------------------*
     C     PL0165        PLIST
     C                   PARM                    PNO               7
     C                   PARM                    RETCOD            1 0
     C                   PARM                    PRFDS                      CTUR
     C                   PARM      ' '           SELMOD            1
      *--------------------------------------------------------*
     C     PL0175        PLIST
     C                   PARM                    VENDOR            6
     C                   PARM                    PROFIL            8
     C                   PARM                    SELECT            1
      *--------------------------------------------------------*
     C     PL0315        PLIST
     C                   PARM                    ENT_CUS
     C                   PARM                    ETYPE             2
     C                   PARM                    EMAIL
     C                   PARM                    C@LOC#            6
     C                   PARM                    CRCD#            10
     C                   PARM                    CFLD#            10
¢A   C     PL03151       PLIST
¢A   C                   PARM                    ENT_CUS
¢A   C                   PARM                    ETYPE             2
¢A   C                   PARM                    EMAIL2
¢A   C                   PARM                    C@LOC#            6
¢A   C                   PARM                    CRCD#            10
¢A   C                   PARM                    CFLD#            10
      *--------------------------------------------------------*
     C     JOB_KEY       KLIST
     C                   KFLD                    ENT_CUS
     C                   KFLD                    ARNO06
      *--------------------------------------------------------*
     C     SGC_KEY       KLIST
     C                   KFLD                    SECTION
     C                   KFLD                    GROUP
     C                   KFLD                    CATEGORY
      *--------------------------------------------------------*
     C     SG_KEY        KLIST
     C                   KFLD                    SECTION
     C                   KFLD                    GROUP
      *--------------------------------------------------------*
     C     MCPH_KEY      KLIST
     C                   KFLD                    PROF_VEND
     C                   KFLD                    NO13
      *--------------------------------------------------------*
     C     MTBL_KEY      KLIST
     C                   KFLD                    TBNO01
     C                   KFLD                    TBNO02
      *--------------------------------------------------------*

      * Initialize/Default SCREEN fields

     C                   EVAL      PRNO24 = *BLANKS
     C                   EVAL      PRNO25 = *BLANKS
     C                   EVAL      PRNO26 = *BLANKS
     C                   EVAL      JOB_NAME = '   Blank=All   '
     C                   EVAL      SEC_NAME = '   Blank=All             '
     C                   EVAL      GRP_NAME = '   Blank=All             '
     C                   EVAL      CAT_NAME = '   Blank=All             '
¢A   C                   EVAL      STKCY  = 'N'
   ¢AC*                  EVAL      PRCD96 = 'Y'
¢A   C                   EVAL      PRCD96 = 'N'
¢A   C                   EVAL      *IN42 = *ON
   ¢AC*                  EVAL      PRCD89 = ' '
¢A   C                   EVAL      PRCD89 = 'P'
     C                   EVAL      PRCD93 = 'N'
     C                   EVAL      PRCD94 = 'N'
     C                   EVAL      PRCD95 = 'N'
     C                   EVAL      PRCDB3 = 'N'
¢A   C                   EVAL      PRIABC = 'N'
¢A   C                   EVAL      PRDISO = 'N'
      * Default alias print flag
     C                   IF        PRCD95 = 'Y'
     C                   EVAL      PRCDB3 = 'Y'
     C                   ELSE
     C                   EVAL      PRCDB3 = 'N'
     C                   ENDIF

     C                   EVAL      PRCD97 = 'A'
     C                   EVAL      FROM_SDATE = 0
     C                   EVAL      TO_SDATE = 0
      * Screen B fields
     C     *DTAARA       DEFINE    NEXTPROF#     Next_Prof#        7 0
     C                   EVAL      PRCD98 = 'Y'
¢A   C     section       ifne      *blanks
¢A   C     group         orne      *blanks
¢A   C     category      orne      *blanks
¢A   C                   EVAL      PRCD99 = 'B'
¢A   C                   else
     C                   EVAL      PRCD99 = 'P'
¢A   C                   end
     C                   EVAL      PRCDA1 = 'C'
     C                   EVAL      PRCDA6 = 'R'
     C                   EVAL      PRCDA3 = 'Y'
     C                   EVAL      PRCDA4 = 'N'
     C                   EVAL      PRCDA5 = 'N'
     C                   EVAL      PRCDA7 = 'N'
     C                   EVAL      PRCDA8 = 'N'
     C                   EVAL      PRCDA9 = 'N'
     C                   EVAL      PRCDB1 = 'N'
     C                   EVAL      PRNO23 = 01
   ¢BC*                  EVAL      PRCDA2 = 'N'
¢B   C                   EVAL      PRCDA2 = 'Y'
     C                   EVAL      PRCDB2 = 'N'
     C                   EVAL      DN11A  = *BLANKS
     C                   EVAL      DN11B  = *BLANKS

     C     *IN03         DOWEQ     *OFF

     C     REDSPA        TAG
 ¢A  C                   if        vend2  = *zeros
 ¢A  C                   eval      vend_name2 = *blanks
 ¢A  C                   endif
 ¢A  C                   if        vend3  = *zeros
 ¢A  C                   eval      vend_name3 = *blanks
 ¢A  C                   endif
     C                   EXFMT     PRF1700A
     C                   EVAL      MSGFLD = *BLANKS
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      *IN88 = *OFF
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN96 = *OFF
      * Exit prgram
     C                   IF        *IN03
     C                   LEAVE
     C                   ENDIF                                                  *IN03
      * Call user documentation
     C                   IF        *IN25
     C                   CALL      'HTR0010'     HELP
     C                   ITER
     C                   ENDIF                                                  *IN25
      * Open up or close other options

      * If discount, close contract specfic
     C                   EVAL      *IN46 = *OFF
     C                   IF        ENT_CUS <> *ZEROS AND PRCD96 = 'N'
     C                   EVAL      *IN46 = *ON
     C                   ENDIF
      * Open others
     C                   IF        PRCD96 = 'N' AND *IN42 = *OFF
     C     1             CABEQ     1             REDSPA                   42
     C                   ENDIF
      * Blank/default for discounts
     C                   IF        *IN46 = *OFF
     C                   EVAL      PRCD97     = 'A'
     C                   EVAL      PROF_VEND  = 0
     C                   EVAL      PRF_VNAME  = *BLANKS
     C                   EVAL      NO13       = *BLANKS
     C                   EVAL      PROF_NAME  = *BLANKS
     C                   ENDIF

     C                   IF        PRCD96 = 'Y' AND *IN42 = *ON
      * Blank/default combination fields
     C                   EVAL      PRCD89     = ' '
     C                   EVAL      SECTION    = *BLANKS
     C                   EVAL      SEC_NAME   = *BLANKS
     C                   EVAL      GROUP      = *BLANKS
     C                   EVAL      GRP_NAME   = *BLANKS
     C                   EVAL      CATEGORY   = *BLANKS
     C                   EVAL      CAT_NAME   = *BLANKS
     C                   EVAL      PRCD94     = 'N'
     C                   EVAL      APNO01     = 0
¢A   C                   EVAL      vend2      = 0
¢A   C                   EVAL      vend3      = 0
     C                   EVAL      VEND_NAME  = *BLANKS
¢A   C                   EVAL      VEND_NAME2 = *BLANKS
¢A   C                   EVAL      VEND_NAME3 = *BLANKS
     C                   EVAL      PRCD93     = 'N'
     C                   EVAL      FROM_SDATE = 0
     C                   EVAL      TO_SDATE   = 0
     C                   EVAL      PRCD95     = 'N'
     C                   EVAL      PRCD97     = 'A'
     C                   EVAL      PROF_VEND  = 0
     C                   EVAL      PRF_VNAME  = *BLANKS
     C                   EVAL      NO13       = *BLANKS
     C                   EVAL      PROF_NAME  = *BLANKS
     C                   EVAL      *IN39 = *OFF
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN44 = *OFF

     C     1             CABEQ     1             REDSPA               4242
     C                   ENDIF
      * Prompt
     C                   IF        *IN04
     C                   EXSR      @PRMPT
     C                   ITER
     C                   ENDIF                                                  *IN04
      * F7 - Omit Items
 ¢D   /free
 ¢D    if *in07;
 ¢D      if ent_cus <> 0 and arno16 <> 0;
 ¢D        companyNumber = 0;
 ¢D        // Get company number from branch master
 ¢D        exec sql
 ¢D          select arno15
 ¢D          into :companyNumber
 ¢D          from arpmbch
 ¢D          where arno16 = :arno16;
 ¢D        branchNumber = arno16;
 ¢D        customerNumber = ent_cus;
 ¢D        listprbk(companyNumber: branchNumber: customerNumber);
 ¢D      else;
 ¢D        if msgfld = *blanks;
 ¢D          msgfld = cms(3);
 ¢D        endif;
 ¢D      endif;
 ¢D      iter;
 ¢D    endif;
 ¢D   /end-free
     C                   EXSR      @CLCSR

      * Validate branch

     C     ARNO16        CHAIN     ARFMBCH                            40
     C     *IN40         IFEQ      *ON
     C                   EVAL      *IN80 = *ON
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     MSG(4)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C     BM_ARFL23     IFEQ      'N'
     C                   EVAL      *IN80 = *ON
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEL     MSG(4)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       REDSPA
     C                   EVAL      ARNM07 = BM_ARNM07

      * Make sure at least customer is entered
     C                   IF        ENT_CUS = 0 AND PRNO24 = *BLANKS
     C                             AND PRNO25 = *BLANKS AND PRNO26 = *BLANKS
     C                             AND *IN04 = *OFF
     C                   EVAL      *IN81 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(5)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C     MSGFLD        CABNE     *BLANKS       REDSPA
      * Validate enterprise number or customer number

     C                   EVAL      CUS_NAME  = *BLANKS
     C                   EVAL      EorC_Flag = ' '

     C                   IF        ENT_CUS <> 0
     C     ENT_CUS       CHAIN     ARFMENT
     C                   IF        NOT %FOUND
     C     ENT_CUS       CHAIN     ARFMCUS                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN81 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(5)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      CUS_NAME = %TRIM(CM_ARNM01)
     C                   EVAL      EorC_Flag = 'C'
     C                   ELSE
     C                   EVAL      CUS_NAME = %TRIM(EP_ARNM62)
     C                   EVAL      EorC_Flag = 'E'
     C                   ENDIF
      * Cannot be entered with profiles
     C                   IF        PRNO24 <> *BLANKS
     C                             OR PRNO25 <> *BLANKS
     C                             OR PRNO26 <> *BLANKS
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(6)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Ensure discount profile is entered in order

     C                   IF        PRNO24 = *BLANKS
     C                   IF        PRNO25 <> *BLANKS
     C                             OR PRNO26 <> *BLANKS
     C                   EVAL      *IN82 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(7)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        PRNO24 <> *BLANKS AND PRNO25 = *BLANKS
     C                   IF        PRNO26 <> *BLANKS
     C                   EVAL      *IN83 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(7)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * Validate discount profiles

     C                   IF        PRNO24 <> *BLANKS
     C     PRNO24        CHAIN     PRFMDPH                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN82 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(8)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        PRNO25 <> *BLANKS
     C     PRNO25        CHAIN     PRFMDPH                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN83 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(8)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        PRNO26 <> *BLANKS
     C     PRNO26        CHAIN     PRFMDPH                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN84 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(8)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Ensure same discount not entered more than once

     C                   IF        PRNO24 <> *BLANKS
     C                   IF        PRNO24 = PRNO25 OR PRNO24 = PRNO26
     C                   EVAL      *IN82 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        PRNO25 <> *BLANKS
     C                   IF        PRNO25 = PRNO24 OR PRNO25 = PRNO26
     C                   EVAL      *IN83 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        PRNO26 <> *BLANKS
     C                   IF        PRNO26 = PRNO24 OR PRNO26 = PRNO25
     C                   EVAL      *IN84 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(21)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF


      * Validate job number

     C                   EVAL      JOB_NAME = '   Blank=All   '
     C                   IF        ARNO06 <> *BLANKS
     C     JOB_KEY       CHAIN     ARFMJBM                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN85 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(9)        MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      JOB_NAME = JM_ARNM04
     C                   ENDIF

      * Validate section, group, category

     C                   EVAL      SEC_NAME = '   Blank=All             '
     C                   EVAL      GRP_NAME = '   Blank=All             '
     C                   EVAL      CAT_NAME = '   Blank=All             '

     C                   IF        PRCD89 = 'A'
     C                   EVAL      SECTION = *BLANKS
     C                   EVAL      GROUP = *BLANKS
     C                   EVAL      CATEGORY = *BLANKS

     C                   ELSE

     C     PRCD89        CASEQ     'C'           CounterBook
     C     PRCD89        CASEQ     'P'           PurchasingBook
     C     PRCD89        CASEQ     'S'           SellingBook
     C                   ENDCS
     C                   ENDIF

      * Allow vendor specific

     C                   IF        PRCD94 = 'Y'

     C                   IF        APNO01 = 0
     C                   EXSR      Vendor_Select
     C                   IF        APNO01 = 0
     C                   EVAL      *IN96 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(20)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ELSE
     C                   EVAL      APNO01 = 0
     C                   EVAL      VEND_NAME = *BLANKS
     C                   EVAL      *IN30 = *OFF
     C                   ENDIF

      * Allow date range to be entered if sales history selected

     C                   IF        PRCD93 = 'Y'

     C                   IF        FROM_SDATE = 0 AND TO_SDATE = 0
     C                   EVAL      REQ_TYPE = 'S'
     C                   EXSR      Date_Range
     C                   ENDIF

     C                   ELSE
     C                   EVAL      FROM_SDATE = 0
     C                   EVAL      TO_SDATE = 0
     C                   EVAL      *IN39 = *OFF
     C                   ENDIF

      * Allow contract specific

     C                   IF        PRCD97 = 'S'

     C                   IF        PROF_VEND = 0
     C                   EXSR      Sel_Contract
     C                   ENDIF

     C                   ELSE
     C                   EVAL      PROF_VEND = 0
     C                   EVAL      PRF_VNAME = *BLANKS
     C                   EVAL      NO13      = *BLANKS
     C                   EVAL      PROF_NAME = *BLANKS
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
      * Ensure at least one option has been entered for All Items No
   ¢AC*                  IF        PRCD96 = 'N' AND PRCD89 = ' '
   ¢AC*                            AND PRCD94 = 'N' AND PRCD93 = 'N'
   ¢AC*                            AND PRCD95 = 'N' AND PRCD97 = 'A'
¢A   C                   IF        PRCD96 = 'N' AND PRCD89 = 'P'
¢A   C                             AND PRCD94 = 'N' AND PRCD93 = 'N'
¢A   C                             AND PRCD95 = 'N' AND PRCD97 = 'A'
¢A   C                             and section = ' ' and group = ' '
¢A   C                             and category = ' '
¢A   C                             and stkcy = 'N'
¢A   C                             and vend2  = *zeros
¢A   C                             and vend3  = *zeros
¢A   C                             and prdiso = 'N'
¢A   C                             and prIABC = 'N'
     C                   EVAL      *IN86 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(10)       MSGFLD
     C                   ENDIF
     C                   ENDIF

     C     MSGFLD        CABNE     *BLANKS       REDSPA
      * Send to verify if not already
     C                   IF        VERIFIED = 'N' OR *IN90 = *ON
     C                   EVAL      VERIFIED = 'Y'
     C                   MOVEA     MSG(2)        MSGFLD
     C                   ITER
     C                   ENDIF

      * Retrieve and assign next profile number

     C                   IF        PRNO22 = 0
     C     *LOCK         IN        Next_Prof#                           92
     C                   EVAL      PRNO22 = Next_Prof#
     C                   EVAL      Next_Prof# = Next_Prof# + 1
     C                   OUT       Next_Prof#
     C                   ENDIF

      * Display next format

      * Protect email if not allowed and not a Customer Price Book request

     C                   EVAL      TBNO01 = 'FAX '
     C                   EVAL      TBNO02 = 'EMAIL    '
     C                   EVAL      *IN50 = *OFF
     C     MTBL_KEY      CHAIN     TBFMTBL
     C                   EVAL      Allow_Email = TBNO03

     C                   IF        Allow_Email = 'N' OR ENT_CUS = *ZEROS
     C                   EVAL      *IN50 = *ON
     C                   EVAL      PRCDA2 = 'N'
     C                   EVAL      EMAIL = *BLANKS
     C                   ENDIF

      * Is user authorized to cost?  Display cost and gross profit questions
      *   if authorized

     C                   EVAL      TBNO01 = 'COST'
     C                   EVAL      TBNO02 = User_Name
     C                   EVAL      *IN52 = *OFF
     C     MTBL_KEY      CHAIN     TBFMTBL
     C                   IF        %FOUND
     C                   EVAL      Allow_Cost = %SUBST(TBNO03:12:1)
     C                   EVAL      *IN52 = Allow_Cost = '2'
     C                   ENDIF

     C                   EVAL      VERIFIED = 'N'
     C                   EVAL      Cost_Warning = 'N'
     C                   EVAL      *IN95 = *OFF
¢A   C                   eval      dsrfmt = 'P'
     C     REDSPB        TAG
     C                   EXFMT     PRF1700B
     C                   EVAL      MSGFLD = *BLANKS
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
¢A   C                   EVAL      *IN65 = *OFF
¢A   C                   EVAL      *IN66 = *OFF
      * Exit prgram
     C                   IF        *IN03
     C                   LEAVE
     C                   ENDIF                                                  *IN03

      * Previous screen
     C                   IF        *IN12
     C                   EVAL      VERIFIED = 'N'
     C     *IN12         CABEQ     *ON           REDSPA
     C                   ENDIF
      * Prompt
     C                   IF        *IN04
     C                   EXSR      @PRMPT_B
     C     *IN04         CABEQ     *ON           REDSPB
     C                   ENDIF                                                  *IN04
     C                   EXSR      @CLCSR
      * Call user documentation
     C                   IF        *IN25
     C                   CALL      'HTR0010'     HELP
     C     *IN25         CABEQ     *ON           REDSPB
     C                   ENDIF                                                  *IN25
¢A   C                   IF        PRCDA2 = 'Y'
¢A   C                             and DSRFMT <> 'X'
¢A   C                             and DSRFMT <> 'P'
¢A   C                   EVAL      *IN97 = *ON
¢A   C                   IF        MSGFLD = *BLANKS
¢A ¢CC*                  MOVEL     MSG(22)       MSGFLD
¢C   C                   MOVEL     CMS(1)        MSGFLD
¢A   C                   ENDIF
¢A   C                   ENDIF
      * Verify sort selection is correct
     C                   IF        PRCD89 = ' '
     C                   IF        PRCD99 = 'B'
     C                   EVAL      *IN94 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(18)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        PRCD95 = 'N'
     C                   IF        PRCD99 = 'A'
     C                   EVAL      *IN94 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(17)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

¢A   C* force print flag based on email settings
¢A   C     prcda2        ifeq      'Y'
¢A   C     email         orne      *blanks
¢A   C                   eval      prcd98 = 'N'
¢A   C                   else
¢A   C                   eval      prcd98 = 'Y'
¢A   C                   end
      * Ensure one output type has been requested
     C                   IF        PRCD98 = 'N' AND PRCDB2 = 'N'
     C                             AND PRCDA2 = 'N'
     C                   EVAL      *IN93 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(16)       MSGFLD
     C                   ENDIF
     C                   ENDIF
      * Call email selection if customer
     C                   IF        PRCDA2 = 'Y'
     C                   IF        EorC_Flag = 'C' AND EMAIL = *BLANKS
     C                   EVAL      ETYPE = '01'
     C                   CALL      'OPR0315'     PL0315
     C                   ENDIF

     C                   ELSE
     C                   EVAL      EMAIL = *BLANKS
¢A   C                   EVAL      EMAIL2= *BLANKS
     C                   ENDIF

¢A    * validate email addresses
¢A   C     email         ifne      *blanks
¢A   C                   move      '1'           emtyp             1
¢A   C                   exsr      @email
¢A   C     emlerr        ifeq      'Y'
¢A   C                   IF        MSGFLD = *BLANKS
¢A   C                   move      *on           *in65
¢A ¢CC*                  MOVEL     MSG(23)       MSGFLD
¢C   C                   MOVEL     CMS(2)        MSGFLD
¢A   C                   ENDIF
¢A   C                   ENDIF
¢A   C                   ENDIF

¢A    * validate 2nd email addr

¢A   C     email2        ifne      *blanks
¢A   C                   move      '2'           emtyp             1
¢A   C                   exsr      @email
¢A   C     emlerr        ifeq      'Y'
¢A   C                   IF        MSGFLD = *BLANKS
¢A   C                   move      *on           *in66
¢A ¢CC*                  MOVEL     MSG(23)       MSGFLD
¢C   C                   MOVEL     CMS(2)        MSGFLD
¢A   C                   ENDIF
¢A   C                   ENDIF
¢A   C                   ENDIF
      * Warn user if print cost requested for customer price books

      * Initialize warning flag if fields changed to 'N'.  This way program
      * will re-warn them of the impact of saying Yes to cost/gross profits

     C                   IF        PRCDA7 = 'N' AND PRCDA5 = 'N'
     C                   EVAL      Cost_Warning = 'N'
     C                   ENDIF

     C                   IF        ENT_CUS <> *ZEROS AND Cost_Warning = 'N'
     C                   IF        PRCDA7 = 'Y' OR PRCDA5 = 'Y'
     C                   EVAL      Cost_Warning = 'Y'
     C                   EVAL      *IN95 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(19)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     MSGFLD        CABNE     *BLANKS       REDSPB

      * Send to verify if not already verified
     C                   IF        VERIFIED = 'N' OR *IN90 = *ON
     C                   EVAL      VERIFIED = 'Y'
     C                   MOVEA     MSG(2)        MSGFLD
     C     1             CABEQ     1             REDSPB
     C                   ENDIF

      * F10 = Update Request File and submit job to batch

     C                   IF        *IN10

      * If data base option, display confirmation window

     C                   IF        PRCDB2 = 'Y'
     C                   MOVE      PRNO22        SBMJOB_PROF
     C                   EVAL      RETCOD = 0
     C                   CALL      'PRR1703'     PL1703
     C     RETCOD        CABEQ     1             REDSPB
     C                   ENDIF
      * Download DataBase File name and library
     C                   EVAL      PRDN12 = File_Name
     C                   EVAL      PRDN13 = Library
      * Enterprise/customer
     C                   EVAL      ARNO01 = ENT_CUS
      * Book
     C                   EVAL      PRCD90 = SECTION
     C                   EVAL      PRCD91 = GROUP
     C                   EVAL      PRCD92 = CATEGORY
      * Email
     C                   EVAL      OPAD01 = EMAIL
      * From/To sales history dates
     C                   IF        FROM_SDATE <> 0
     C                   EVAL      PRMO19 = FROM_SMONTH
     C                   EVAL      PRDY19 = FROM_SDAY
     C                   EVAL      PRYR19 = FROM_SYEAR
     C                   IF        PRYR19 > 50
     C                   EVAL      PRCC19 = 19
     C                   ELSE
     C                   EVAL      PRCC19 = 20
     C                   ENDIF
     C                   EVAL      PRMO20 = TO_SMONTH
     C                   EVAL      PRDY20 = TO_SDAY
     C                   EVAL      PRYR20 = TO_SYEAR
     C                   IF        PRYR20 > 50
     C                   EVAL      PRCC20 = 19
     C                   ELSE
     C                   EVAL      PRCC20 = 20
     C                   ENDIF
     C                   ENDIF
      * Specific contract
     C                   EVAL      APNO25 = PROF_VEND
     C                   EVAL      PRNO13 = NO13
      * Print headings
     C                   EVAL      PRDN11 = DN11A
     C                   EVAL      %SUBST(PRDN11:31:30) = DN11B

      * Capture request
     C                   WRITE     PRFPBRQ

     C                   IF        EorC_Flag = 'C' OR PRNO24 <> *BLANKS
     C                   IF        PRNO24 <> *BLANKS
     C                   EVAL      SBMJOB_Name = 'AnalysisBk'
     C                   ENDIF
     C                   MOVEA     SBMJOB_Name   SJB(12)
     C                   MOVE      PRNO22        SBMJOB_PROF
     C                   MOVE      ARNO01        SBMJOB_CUST
     C                   MOVEA     SBMJOB_PROF   SJB(79)
     C                   MOVEA     SBMJOB_CUST   SJB(91)
     C                   MOVEA     PRNO24        SJB(102)
     C                   MOVEA     PRNO25        SJB(114)
     C                   MOVEA     PRNO26        SJB(126)
     C                   MOVEA     EMAIL         SJB(214)
¢A   C                   MOVE      vend2         wk2ndv
¢A   C                   MOVE      vend3         wk3rdv
¢A   C                   MOVEA     DSRFMT        SJB(264)
¢A   C                   MOVEA     stkcy         SJB(270)
¢A   C                   MOVEA     priabc        SJB(276)
¢A   C                   MOVEA     prdiso        SJB(285)
¢A   C                   MOVE      vend2         wk2ndv
¢A   C                   MOVE      vend3         wk3rdv
¢A   C                   MOVEA     wk2ndv        SJB(291)
¢A   C                   MOVEA     wk3rdv        SJB(302)
¢A   C                   MOVEA     EMAIL2        SJB(354)
   ¢AC*                  MOVEA     prmanu        SJB(313)
      *
     C                   MOVEA     File_Name     SJB(144)
     C                   MOVEA     Library       SJB(159)
   ¢AC*                  MOVEA     SJB           CMD             280
¢A   C                   MOVEA     SJB           CMD             420
   ¢AC*                  Z-ADD     280           LEN              15 5
¢A   C                   Z-ADD     420           LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM                    LEN

     C                   ELSE

     C                   MOVE      PRNO22        SBMJOB_PROF
     C                   MOVE      ARNO01        SBMJOB_CUST
     C                   CALL      'PRR1702'     PL1702
     C     RETCOD        CABEQ     1             REDSPB
     C                   ENDIF                                                  *IN03

     C                   LEAVE

     C                   ENDIF                                                  *IN03
      * Redisplay if no function key
     C                   MOVEA     MSG(3)        MSGFLD
     C     1             CABEQ     1             REDSPB

      * End of *IN03 Format A

     C                   ENDDO

      *--------------------------------------------------------*

      * End program

     C                   EVAL      *INLR = *ON

      *--------------------------------------------------------*
      * Subroutine CounterBook ensures the section, group, and *
      * category entered is valid.                             *
      *--------------------------------------------------------*

     C     CounterBook   BEGSR
      * Section
     C                   IF        SECTION <> *BLANKS
     C     SECTION       CHAIN     IVFMCBT                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN87 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(11)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      SEC_NAME = %TRIM(CB_IVDN06)
     C                   ENDIF
      * Group
     C                   IF        GROUP <> *BLANKS
     C     SG_KEY        CHAIN     IVFMCBT                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN88 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(12)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      GRP_NAME = %TRIM(CB_IVDN06)
     C                   ENDIF
      * Category
     C                   IF        CATEGORY <> *BLANKS
     C     SGC_KEY       CHAIN     IVFMCBT                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN88 = *ON
     C                   EVAL      *IN89 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(13)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      CAT_NAME = %TRIM(CB_IVDN06)
     C                   ENDIF
     C                   ENDSR

      *--------------------------------------------------------*
      * Subroutine PurchasingBook ensures the section, group,  *
      * and category entered is valid.                         *
      *--------------------------------------------------------*

     C     PurchasingBookBEGSR
      * Section
     C                   IF        SECTION <> *BLANKS
     C     SECTION       CHAIN     IVFMPBT                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN87 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(11)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      SEC_NAME = %TRIM(PB_IVDN06)
     C                   ENDIF
      * Group
     C                   IF        GROUP <> *BLANKS
     C     SG_KEY        CHAIN     IVFMPBT                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN88 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(12)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      GRP_NAME = %TRIM(PB_IVDN06)
     C                   ENDIF
      * Category
     C                   IF        CATEGORY <> *BLANKS
     C     SGC_KEY       CHAIN     IVFMPBT                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN88 = *ON
     C                   EVAL      *IN89 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(13)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      CAT_NAME = %TRIM(PB_IVDN06)
     C                   ENDIF
     C                   ENDSR

      *--------------------------------------------------------*
      * Subroutine SellingBook ensures the section, group, and *
      * category entered is valid.                             *
      *--------------------------------------------------------*

     C     SellingBook   BEGSR
      * Section
     C                   IF        SECTION <> *BLANKS
     C     SECTION       CHAIN     IVFMSBT                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN87 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(11)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      SEC_NAME = %TRIM(SB_IVDN06)
     C                   ENDIF
      * Group
     C                   IF        GROUP <> *BLANKS
     C     SG_KEY        CHAIN     IVFMSBT                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN88 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(12)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      GRP_NAME = %TRIM(SB_IVDN06)
     C                   ENDIF
      * Category
     C                   IF        CATEGORY <> *BLANKS
     C     SGC_KEY       CHAIN     IVFMSBT                            40
     C                   IF        *IN40 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN88 = *ON
     C                   EVAL      *IN89 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(13)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      CAT_NAME = %TRIM(SB_IVDN06)
     C                   ENDIF
     C                   ENDSR

      *--------------------------------------------------------*
      * Date_Range subroutine will display a window that allows*
      * users to enter a date range for sales and purchasing.  *
      *--------------------------------------------------------*

     C     Date_Range    BEGSR

     C                   EVAL      FROM = FROM_SDATE
     C                   EVAL      TO = TO_SDATE
     C                   EVAL      RETCOD = *ZEROS
     C                   CALL      'PRR1701'     PL1701
      * Error message
     C                   IF        RETCOD = 0 OR RETCOD = 1
     C                   EVAL      *IN91 = *ON
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(14)       MSGFLD
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      FROM_SDATE = FROM
     C                   EVAL      TO_SDATE = TO
     C                   EVAL      *IN39 = *ON

     C                   ENDSR

      *--------------------------------------------------------*
      * Vendor_Select subroutine will allow the user to search *
      * and select a vendor.                                   *
      *--------------------------------------------------------*

     C     Vendor_Select BEGSR

     C                   EVAL      VEN# = *BLANKS
     C                   CALL      'APR4005'
     C                   PARM                    VEN#              6

     C                   IF        VEN# <> *BLANKS
     C                   MOVE      VEN#          APNO01
     C     APNO01        CHAIN     APFMVEN
     C                   EVAL      VEND_NAME = %TRIM(VM_APNM01)
     C                   EVAL      *IN30 = *ON
     C                   ENDIF

     C                   ENDSR

 ¢A   *--------------------------------------------------------*
 ¢A   * Vend_Select23 subroutine will allow the user to search *
 ¢A   * and select a vendor FOR the 2nd and/or 3rd vendor(s)   *
 ¢A   *   if specified by the user.                            *
 ¢A   *--------------------------------------------------------*
 ¢A
 ¢A  C     Vend_Select23 BEGSR
 ¢A
 ¢A  C                   EVAL      VEN# = *BLANKS
 ¢A  C                   CALL      'APR4005'
 ¢A  C                   PARM                    VEN#              6
 ¢A
 ¢A  C                   IF        VEN# <> *BLANKS
 ¢A  C                   MOVE      VEN#          wkvend
 ¢A  C                   MOVE      wkvend        wkvendn           6 0
 ¢A  C     wkvendn       CHAIN     APFMVEN
 ¢A  C                   EVAL      wkv_NAME = %TRIM(VM_APNM01)
 ¢A  C                   ENDIF
 ¢A  C                   SELECT
 ¢A  C                   when      cfld = 'VEND2 '
 ¢A  C                   eval      VEND2   = wkvendn
 ¢A  C                   eval      vend_name2  = wkv_NAME
 ¢A  C                   when      cfld = 'VEND3 '
 ¢A  C                   eval      VEND3   = wkvendn
 ¢A  C                   eval      vend_name3  = wkv_NAME
 ¢A  C                   ENDSL
 ¢A
 ¢A  C                   ENDSR
      *--------------------------------------------------------*
      * Sel_Contract subroutine will allow the user to search  *
      * and select a contract price sheet.                     *
      *--------------------------------------------------------*

     C     Sel_Contract  BEGSR

     C                   IF        PROF_VEND = 0
     C                   EVAL      VENDOR = '00000?'
     C                   ELSE
     C                   MOVE      PROF_VEND     VENDOR
     C                   ENDIF
     C                   EVAL      PROFIL = NO13
     C                   EVAL      SELECT = *BLANKS
     C                   CALL      'PRR0175'     PL0175

     C                   IF        PROF_VEND = *ZEROS
     C                   IF        SELECT <> 'Y'
     C                   EVAL      *IN92 = *ON
     C                   EVAL      VENDOR = '000000'
     C                   IF        MSGFLD = *BLANKS
     C                   MOVEL     MSG(15)       MSGFLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   MOVE      VENDOR        PROF_VEND
     C                   EVAL      NO13 = PROFIL
     C     PROF_VEND     CHAIN     APFMVEN
     C                   EVAL      PRF_VNAME = %TRIM(VM_APNM01)

     C                   MOVE      PROFIL        NO13
     C     MCPH_KEY      CHAIN     PRFMCPH

     C                   EVAL      PROF_NAME = %TRIM(CP_PRDN07)
     C                   EVAL      *IN44 = *ON

     C                   ENDSR

      *--------------------------------------------------------*
      *  @PRMPT - SUBROUTINE: PROCESS F4 , ALL FORMATS
      *--------------------------------------------------------*

     C     @PRMPT        BEGSR
      * Set to verified to No if some field prompted
     C                   EVAL      VERIFIED = 'N'

     C                   IF        CPOS <> *ZEROS

     C                   EVAL      F4ERR = *OFF
     C                   EVAL      WDWFLG = *ON

     C                   EXSR      @CURSR

     C                   SELECT
     C                   WHEN      CRCD = 'PRF1700A'

     C                   SELECT
      * Customer number search
     C                   WHEN      CFLD = 'ENT_CUS'

     C                   Z-ADD     1             INDEX             3 0
     C     INDEX         OCCUR     SELDS
     C                   CLEAR                   SELDS

     C                   CALL      'ARR4516'     PL4516

     C                   Z-ADD     1             INDEX
     C     INDEX         OCCUR     SELDS
     C                   Z-ADD     CNBR          ENT_CUS
      *
     C                   OTHER
     C                   SELECT
      * Customer number search
     C                   WHEN      CFLD = 'ARNO06'

     C                   MOVEL     ENT_CUS       NO01#
     C                   MOVE      *BLANKS       NO06#             7
     C                   CALL      'ARR5720'     PL5720                         JOB ACCOUNTS
     C                   IF        NO06# <> *BLANKS
     C                   MOVEL     NO06#         ARNO06
     C                   ENDIF                                                  NO06#

      *
     C                   OTHER
     C                   SELECT
      * Branch search
     C                   WHEN      CFLD = 'ARNO16'

     C                   EVAL      SBR# = *BLANKS
     C                   CALL      'ARR5620'     PL5620                         JOB ACCOUNTS
     C                   IF        SBR# <> *BLANKS
     C                   MOVE      SBR#          ARNO16
     C                   ENDIF                                                  NO06#

      *
     C                   OTHER
     C                   SELECT
      * Discount profile #1
     C                   WHEN      CFLD = 'PRNO24'

     C                   EVAL      PNO = *BLANKS
     C                   CALL      'PRR0165'     PL0165                         JOB ACCOUNTS
     C     RETCOD        CABEQ     1             REDSPA                         NO SELECTION   ED
     C                   IF        PNO <> *BLANKS
     C                   MOVEL     PNO           PRNO24
     C                   ENDIF                                                  NO06#

      *
     C                   OTHER
     C                   SELECT
      * Discount profile #2
     C                   WHEN      CFLD = 'PRNO25'

     C                   EVAL      PNO = *BLANKS
     C                   CALL      'PRR0165'     PL0165                         JOB ACCOUNTS
     C     RETCOD        CABEQ     1             REDSPA                         NO SELECTION   ED
     C                   IF        PNO <> *BLANKS
     C                   MOVEL     PNO           PRNO25
     C                   ENDIF                                                  NO06#

      *
     C                   OTHER
     C                   SELECT
      * Discount profile #3
     C                   WHEN      CFLD = 'PRNO26'

     C                   EVAL      PNO = *BLANKS
     C                   CALL      'PRR0165'     PL0165                         JOB ACCOUNTS
     C     RETCOD        CABEQ     1             REDSPA                         NO SELECTION   ED
     C                   IF        PNO <> *BLANKS
     C                   MOVEL     PNO           PRNO26
     C                   ENDIF                                                  NO06#

      *
     C                   OTHER
     C                   SELECT
      * Sales history date range
     C                   WHEN      CFLD = 'PRCD93'
     C     PRCD93        CABNE     'Y'           REDSPA

     C                   EVAL      REQ_TYPE = 'S'
     C                   EXSR      Date_Range
      *
     C                   OTHER
     C                   SELECT
      * Book - section search
     C                   WHEN      CFLD = 'SECTION'

     C                   EVAL      RSEC = SECTION
     C                   EVAL      RGRP = *BLANKS
     C                   EVAL      RCAT = *BLANKS
     C                   EVAL      RTYPE = 'S'
     C                   EVAL      RETCOD = 0
     C                   CALL      'IVR3009'     PL3009                         JOB ACCOUNTS
     C                   IF        RSEC <> *BLANKS
     C                   EVAL      SECTION = RSEC
     C                   EVAL      GROUP = *BLANKS
     C                   EVAL      CATEGORY = *BLANKS
     C                   ENDIF                                                  NO06#
      *
     C                   OTHER
     C                   SELECT
      * Book - group search
     C                   WHEN      CFLD = 'GROUP'

     C                   EVAL      RSEC = SECTION
     C                   EVAL      RGRP = GROUP
     C                   EVAL      RCAT = *BLANKS
     C                   EVAL      RTYPE = 'G'
     C                   EVAL      RETCOD = 0
     C                   CALL      'IVR3009'     PL3009                         JOB ACCOUNTS
     C                   IF        RGRP <> *BLANKS
     C                   EVAL      SECTION = RSEC
     C                   EVAL      GROUP = RGRP
     C                   EVAL      CATEGORY = *BLANKS
     C                   ENDIF                                                  NO06#
      *
     C                   OTHER
     C                   SELECT
      * Book- category search
     C                   WHEN      CFLD = 'CATEGORY'

     C                   EVAL      RSEC = SECTION
     C                   EVAL      RGRP = GROUP
     C                   EVAL      RCAT = *BLANKS
     C                   EVAL      RTYPE = 'C'
     C                   EVAL      RETCOD = 0
     C                   CALL      'IVR3009'     PL3009                         JOB ACCOUNTS
     C                   IF        RCAT <> *BLANKS
     C                   EVAL      SECTION = RSEC
     C                   EVAL      GROUP = RGRP
     C                   EVAL      CATEGORY = RCAT
     C                   ENDIF                                                  NO06#
      *
     C                   OTHER
     C                   SELECT
      * Vendor specific
     C                   WHEN      CFLD = 'PRCD94'

     C     PRCD94        CABNE     'Y'           REDSPA
     C                   EXSR      Vendor_Select
      *
     C                   OTHER
     C                   SELECT
      * Contract specific
     C                   WHEN      CFLD = 'PRCD97'

     C                   IF        PRCD97 = 'S'
     C                   EXSR      Sel_Contract
     C                   ENDIF
      *
     C                   OTHER
 ¢A  C
 ¢A  C                   SELECT
 ¢A   * 2nd Vendor Selected
 ¢A  C                   WHEN      CFLD = 'VEND2 '
 ¢A  C                   EXSR      vend_select23
 ¢A  C                   OTHER
 ¢A  C
 ¢A  C                   SELECT
 ¢A   * 3rd Vendor Selected
 ¢A  C                   WHEN      CFLD = 'VEND3 '
 ¢A  C                   EXSR      vend_select23
 ¢A  C                   OTHER
     C                   MOVE      *ON           F4ERR                          NOT A VALID LOC
     C                   ENDSL                                                  CFLD
     C                   ENDSL                                                  CFLD
      *
     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
¢A   C                   ENDSL
¢A   C                   ENDSL
     C                   ELSE
     C                   MOVE      *ON           F4ERR
     C                   ENDIF
      *
      * SEND ERROR MESSAGE - CURSOR LOCATION INVALID
      *
     C     F4ERR         IFEQ      *ON
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     MSG(1)        MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     ROW           CROW                           REPOSITION
     C                   Z-ADD     COL           CCOL                           CURSOR
     C                   ENDSR

      *--------------------------------------------------------*
      *  @PRMPT_B - SUBROUTINE: PROCESS F4 , ALL FORMATS       *
      *--------------------------------------------------------*

     C     @PRMPT_B      BEGSR
      * Set to verified to No if some field prompted
     C                   EVAL      VERIFIED = 'N'

     C                   IF        CPOS <> *ZEROS

     C                   EVAL      F4ERR = *OFF
     C                   EVAL      WDWFLG = *ON

     C                   EXSR      @CURSR

     C                   SELECT
     C                   WHEN      CRCD = 'PRF1700B'

     C                   SELECT
      * Customer number search
     C                   WHEN      CFLD = 'EMAIL'
     C                   IF        EorC_Flag = 'C'
     C                   EVAL      ETYPE = '01'
     C                   CALL      'OPR0315'     PL0315
     C                   ENDIF
¢A   C                   WHEN      CFLD = 'EMAIL2'
¢A   C                   IF        EorC_Flag = 'C'
¢A   C                   EVAL      ETYPE = '01'
¢A   C                   CALL      'OPR0315'     PL03151
¢A   C                   ENDIF
     C                   OTHER
     C                   MOVE      *ON           F4ERR

     C                   ENDSL                                                  CRCD
     C                   ENDSL                                                  CRCD
     C                   ELSE
     C                   MOVE      *ON           F4ERR
     C                   ENDIF
      *
      * SEND ERROR MESSAGE - CURSOR LOCATION INVALID
      *
     C     F4ERR         IFEQ      *ON
     C     MSGFLD        IFEQ      *BLANKS
     C                   MOVEA     MSG(1)        MSGFLD
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     ROW           CROW                           REPOSITION
     C                   Z-ADD     COL           CCOL                           CURSOR
     C                   ENDSR

      *--------------------------------------------------------*
      *  @CURSR - SUBROUTINE: RETREIVE CURSOR LOCATION
      *--------------------------------------------------------*

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
     C                   Z-ADD     0             CROW
     C                   Z-ADD     0             CCOL
      *
     C                   ENDSR
      *----------------------------------------------------------------
      *  @email - validate email address
      *----------------------------------------------------------------
     C     @email        BEGSR
      * VALIDATE EMAIL ADDRESS FORMAT
      *
¢A    * VERIFY EMAIL ADDR HAS PROPER SYNTAX
¢A   C                   move      *off          *in78
¢A   C                   move      *blanks       emlerr
¢A   C                   move      *blanks       ecmderr
¢A   C     emtyp         ifeq      '1'
¢A   C                   movel     email         tstemail         45
¢A   C                   end
¢A   C     emtyp         ifeq      '2'
¢A   C                   movel     email2        tstemail         45
¢A   C                   end
¢A   C     tstemail      IFNE      *BLANKS                                      TEL AREA CODE
¢A   C                   MOVEL     tstemail      EMAIL80          80
¢A   C                   MOVEL     ' '           ECMDI
¢A   C                   CALL      'ECC9977'                                    TEL AREA CODE
¢A   C                   PARM                    EMAIL80
¢A   C                   PARM                    EMLERR            1
¢A   C                   PARM                    ECMDI             1
¢A   C                   PARM                    ECMDERR           1
¢A   C                   ENDIF
¢A   C                   ENDSR
      *------------------- TABLE FILE CHANGE AREA -----------------------------*
¢C    * Added CMS table for custom messages
¢A    * Added 2 messages to CMS:
¢A    *   If email is selected, report format must be P or X.
¢A    *   If email is selected then you must have a valid email address
¢C    * Changed SBJ entry below to add jobq entry
¢C    *   Before:
¢C    *      ''XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'')')
¢C    *   To:
¢C    *      ''XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'')') JOBQ(QPGMR)
** MSG
Invalid cursor location for F4=Prompt.                                         01
Verify information and press Enter to continue.                                02
Press F10 to submit request.                                                   03
Branch is not valid or is non operational.                                     04
Enterprise/Customer number not valid. Use F4=Prompt.                           05
Enterprise/Customer number cannot be used with discount profiles.              06
Discount profiles are out of order.                                            07
Discount profile is not valid.                                                 08
Job number is not valid.                                                       09
No options selected below. At least one option must be selected.               10
Section not valid for book specified.                                          11
Section/Group not valid for book specified.                                    12
Section/Group/Category not valid for book specified.                           13
Date range is not correct.                                                     14
Specific contract specified, but none selected.                                15
You must select at least one output type.                                      16
Cannot select alias sort if alias items not selected.                          17
Cannot select book sort if book type not selected.                             18
Warning! Customer will see cost and or GP% on price book.                      19
Specific vendor specified, but vendor not selected.                            20
Cannot enter duplicate profile numbers.                                        21
** CMS
If email is selected, report format must be P or X.                            01
If email is selected then you must have a valid email address                  02
Branch and customer must be entered to use F7=Omit Items.                      03
** SJB
SBMJOB JOB(XXXXXXXXXX) JOBD(HDJPACK) RQSDTA('CALL PGM(PRC1710)
 PARM(''XXXXXXX'' ''XXXXXX'' ''XXXXXXX'' ''XXXXXXX'' ''XXXXXXX''
 ''XXXXXXXXXX'' ''XXXXXXXXXX''
 ''XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'' ''X'' ''X'' ''X''
  ''X'' ''v11111'' ''v22222''