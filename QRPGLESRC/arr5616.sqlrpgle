      F*------------------------------------------------------------------------*
      F*N PROGRAM NAME - ARR5616                                                *
      F*------------------------------------------------------------------------*
      F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
      F*------------------------------------------------------------------------*
      F*D MAINT CREDIT CARD DEVICE MASTER                                       *
      F*------------------------------------------------------------------------*
      F*S PURPOSE:                                                              *
      F*S    This program maintains credit card divice master records           *
      F*S                                                                       *
      F*S SPECIAL NOTES:                                                        *
      F*S                                                                       *
      F*M ----------------------------------------------------------------------*
      F*M TASK       DATE   ID  DESCRIPTION                                     *
      F*M ---------- ------ --- ------------------------------------------------*
      F*V 8000013122 011819 282 CARD CONNECT - CREDIT CARD PROCESS              *
      AA   F*U 1400000418 072820 171 validate dup name and serial number             *
      AB   F*U 1400000453 041421 171 Ability to reuse deactivated device             *
      AC   F*E 1290000727 092421 168 WORLDPAY INTEGRATION                            *
      AD   F*U 8000014024 111721 168 CLEAR ALL HIDDEN FIELDS                         *
      AE   F*E 1400000502 092022 171 INCREASE DEVICE SERIAL# LENGTH                  *
      AF   F*U 0000000000 080226 JJF ADD SEL 'M' MOVE DEVICE TO ANOTHER BRANCH       *
      F*M ----------------------------------------------------------------------*
      F*C ----------------------------------------------------------------------*
      F*C CHANGES IN PROGRESS - TASK AF (JJF 080226):                            *
      F*C   1. Added H-spec: DFTACTGRP(*NO) ACTGRP(*NEW) BNDDIR('ECBIND')         *
      F*C      to allow calling bound procedure retrieveAuthorizedBranches()      *
      F*C      from RTVABRC_CP (used to prompt user for branch to move device     *
      F*C      to when SEL='M' is entered).                                      *
      F*C   2. PENDING: /COPY QCPYSRC,RTVABRC_CP and newBranch work field.        *
      F*C   3. PENDING: Update SEL edit validation (srEditD) to allow 'M' as a    *
      F*C      valid selection value, alongside blank/D/R/T.                      *
      F*C   4. PENDING: Add SEL='M' processing logic in srEditD to:               *
      F*C        - call retrieveAuthorizedBranches('Y') to prompt for branch      *
      F*C        - delete/rewrite ARFMCCD record for device under new branch key  *
      F*C        - set zdmsg = 'Device moved.' and clear SEL                      *
      F*C   NOTE: Implementation not yet complete - see items above.             *
      F*C ----------------------------------------------------------------------*
      H DFTACTGRP(*NO) ACTGRP(*NEW) BNDDIR('ECBIND') OPTION(*SRCSTMT: *NODEBUGIO)

      FARD5616   CF   E             WORKSTN

     F                                     INFDS(FIL1DS)
     F                                     SFILE(ARS5616A:RRN)
     Farlmbch2  if   e           k disk
     FARLMCCD1  UF A E           K DISK
     FARLMCCD2  IF   E           K DISK    RENAME(ARFMCCD:ARFMCCD2)
AC   FARLMCCD3  IF   E           K DISK    RENAME(ARFMCCD:ARFMCCD3)
AB   FARPHCCD   O    E             DISK

     **********************************************************************

     *  define all work fields
AA   D devnam          S             30    DIM(99)
AA AED*srlnum          S             20    DIM(99)
AE   D srlnum          S             40    DIM(99)
AA   D D               S              3  0
AA   D S               S              3  0
     D sv03            S              1
     D no              c                   'N'
     D yes             c                   'Y'
     D true            c                   *ON
     D false           c                   *OFF
     D FIL1DS          DS
     D  SCREEN               261    268
     D  C@LOC                370    371B 0
     D  CPFRRN               378    379B 0
AB   D                 DS
AB   D  lst_year               1      4  0
AB   D  lst_month              5      6  0
AB   D  lst_ccyrmo             1      6  0

        dcl-s OutUseScreen char(1) inz('Y');

      /COPY qcpysrc,RTVABRC_CP
     **********************************************************************
     *  define all parameter lists
     C     *entry        plist
     C                   parm                    BRANCH            3 0
     C                   parm                    Merchant         20
      *
     C     ccdkey2       klist
     C                   kfld                    branch
     C                   kfld                    arnm71
      *
     C     cdvkey2       klist
     C                   kfld                    branch
     C                   kfld                    svnm71
AC    *
AC   C     ccd3KY        klist
AC   C                   kfld                    branch
AC   C                   kfld                    cardCode          1
      *
     C     PL0060        PLIST
     C                   PARM                    VALUE#           30
     C                   PARM                    ACT#              1
     C                   PARM                    C@LOC#
     C                   PARM                    CRCD#
     C                   PARM                    CFLD#
      *----------------------------------------------------*
     C     PL9750        PLIST
     C                   PARM                    piMerchantID     20
   AEC*                  PARM                    piDeviceSN       20
AE   C                   PARM                    piDeviceSN       40
     C                   PARM                    piCrdPresent      1
     C                   PARM                    piTransAmt       10
     C                   PARM                    poToken          20
     C                   PARM                    poExpiry          4
     C                   PARM                    poName           30
     C                   PARM                    poErrCode        50
     C                   PARM                    poErrMsg        150
    **********************************************************************
AB    * Get last year/month from today's date
AB   C                   if        umonth = 12
AB   C                   eval      lst_month = 1
AB   C                   eval      lst_year  = *year
AB   C                   else
AB   C                   eval      lst_year  = *year - 1
AB   C                   eval      lst_month = umonth + 1
AB   C                   endif
     *  SUBROUTINE:  Enter/Display credit card devices


     *  Load subfile
     C                   exsr      srLoadD
     *  Display until user updates or exits
     C     DispD         tag
     C                   eval      rrn   = 1
     C                   if        x > *zero
     C                   eval      *in75 = *on
     C                   endif

     C                   write     ARf5616A
     C                   exfmt     ARc5616A


     *  F3=Exit
     C                   if        *IN03 = *on
     C                   if        sv03 <> 'Y'
     C                   eval      zdmsg = 'Press F3 again to exist without -
     C                             update.'
     C                   eval      sv03 = 'Y'
     C                   goto      Dispd
     C                   endif
     *  set returning parameter
     C                   else
      *
      * PROCESS F4
      *
     C     *IN04         IFEQ      *ON
     C                   EXSR      @PRMPT
     C     *IN04         CABEQ     *ON           DispD
     C                   ENDIF
     C                   EXSR      @CLCSR
     C
     C                   eval      sv03 = 'N'
      *  edit the screen
     C                   exsr      srEditD
     *  Errors, redisplay
     C     zdmsg         cabne     *blanks       DispD
     *  write/update card devices if f10
     C                   if        *IN10 = *on
     C                   exsr      srSaveD
     C                   else
     C                   goto      Dispd
     C                   endif
     C                   endif

     C                   eval      *inlr = *on

     **********************************************************************
     *  SUBROUTINE:  Edit credit card devices
     C     srEditD       begsr

     C                   move      *off          *in83
     C                   move      *blanks       zdmsg
AA   C                   clear                   devnam
AA   C                   clear                   srlnum
     *  Read each record in subfile
     C                   for       rrn   = 1 to 100
     C                   move      *off          *in50
     C                   move      *off          *in51
     C                   move      *off          *in52
     C                   move      *off          *in53
     C     rrn           chain     ARs5616A
     C                   if        %found
   AB*  cannot delete, serial number used in transaction.
AB   *  Warning, serial number used in active transaction.
AB   C                   if        dltWarned <> 'Y'
     C                   if        arnm71 = *blanks and
     C                             arnof5 = s2nof5  and
AB   C                             act_tx_cnt    > *zeros and
     C                             arnof5 <> *blanks
     C                   eval      *in51 = *on
     C                   if        zdmsg = *blanks
   ABC*                  eval      zdmsg = 'Cannot delete, serial number +
   ABC*                            used in transaction.'
AB   C                   eval      zdmsg = 'Warning! ' + %char(act_tx_cnt   )  +
AB   C                             ' active transactions exist; +
AB   C                             verify before delete.'
AB   C                   eval      dltWarned = 'Y'
     C                   endif
     C                   endif
AB   C                   endif
     *  if device name is not blank
     C                   if        arnm71 <> *blanks
     *  all three fields must contain a value.
     C                   if        arnm72 = *blanks or
     C                             arnof5 = *blanks
     C                   eval      *in52 = *on
     C                   eval      *in51 = *on
     C                   if        zdmsg = *blanks
   AEC*                  eval      zdmsg = 'Device serial number and type must +
   AEC*                            contain a value.'
AE   C                   eval      zdmsg = 'Device serial number and +
AE   C                             model/comments must be entered.'
     C                   endif
     C                   endif
     C                   if        arnm71 <> svnm71
     *  name must be unique
     C     ccdkey2       setll     arlmccd1
     C                   if        %equal(arlmccd1)
     C                   eval      *in50 = *on
     C                   if        zdmsg = *blanks
     C                   eval      zdmsg = 'Device name already used.'
     C                   endif
AA   C                   else
AA   C     arnm71        lookup    devnam                                 61
AA   C                   if        *in61 = *on
AA   C                   eval      *in50 = *on
AA   C                   if        zdmsg = *blanks
AA   C                   eval      zdmsg = 'Device name already entered.'
AA   C                   endif
AA   C                   else
AA   C                   eval      d = d + 1
AA   C                   eval      devnam(d) = arnm71
AA   C                   endif
     C                   endif
     C                   endif
     C                   endif
     *  if device type is not blank
     C                   if        arnm72 <> *blanks
     *  all three fields must contain a value.
     C                   if        arnm71 = *blanks or
     C                             arnof5 = *blanks
     C                   eval      *in52 = *on
     C                   eval      *in51 = *on
     C                   if        zdmsg = *blanks
   AEC*                  eval      zdmsg = 'Device name and serial number +
   AEC*                            must contain a value.'
AE   C                   eval      zdmsg = 'Device name and serial number +
AE   C                             must be entered.'
     C                   endif
     C                   endif
     C                   endif
     *  if device serial is not blank
     C                   if        arnof5 <> *blanks
     *  all three fields must contain a value.
     C                   if        arnm72 = *blanks or
     C                             arnm71 = *blanks
AB   C                   if        dltWarned <> 'Y'
     C                   eval      *in50 = *on
     C                   eval      *in52 = *on
     C                   if        zdmsg = *blanks
   AEC*                  eval      zdmsg = 'Device name and type must +
   AEC*                            contain a value.'
AE   C                   eval      zdmsg = 'Device name and model/comments +
AE   C                             must be entered.'
     C                   endif
     C                   endif
AB   C                   endif
     C                   if        arnof5 <> svnof5
     *  serial number must be unique
     C     arnof5        setll     arlmccd2
     C                   if        %equal(arlmccd2)
     C                   eval      *in51 = *on
     C                   if        zdmsg = *blanks
     C                   eval      zdmsg = 'Device serial number already used.'
     C                   endif
AA   C                   else
AA   C     arnof5        lookup    srlnum                                 61
AA   C                   if        *in61 = *on
AA   C                   eval      *in51 = *on
AA   C                   if        zdmsg = *blanks
AA   C                   eval      zdmsg = 'Device serial number already  +
AA   C                             entered.'
AA   C                   endif
AA   C                   else
AA   C                   eval      s = s + 1
AA   C                   eval      srlnum(s) = arnof5
AA   C                   endif
     C                   endif
     C                   endif
     C                   endif
     *  selection must be blank or T
     C                   if        sel <> *blanks
     C                             and sel <> 'D'
     C                             and sel <> 'R'
     C                             and sel <> 'T'
     C                   eval      *in53 = *on
     C                   if        zdmsg = *blanks
     C                   eval      zdmsg = 'Selection must be blank, D, R, +
     C                                     or T'
     C                   endif
     C                   endif
     *  if selection is D test connection
     C                   if        sel = 'D'
     C                             and arcdl3 <> 'I'
     C                   eval      InactiveCnt += 1
     C                   eval      arcdl3 = 'I'
     C                   eval      sel = *blanks
     C                   endif
     *  if selection is R test connection
     C                   if        sel = 'R'
     C                             and arcdl3 = 'I'
     C                   eval      InactiveCnt -= 1
     C                   eval      arcdl3 = *blank
     C                   eval      sel = *blanks
     C                   endif
     *  if selection is T test connection
     C                   if        sel = 'T'
     C                             and *in50 = *off
     C                             and *in51 = *off
     C                             and *in52 = *off
     C                             and *in53 = *off
     C                   move      *on           tested            1
     C                   eval      PiMerchantID = Merchant
     C                   eval      PiDeviceSN = arnof5
     C                   eval      PiCrdPresent = 'Y'
     C                   eval      PiTransAmt = '0000000000'
     C                   call      'OER9750'     PL9750
     C                   if        PoErrMsg <> *blanks
     C                   movea     '1111'        *in(50)
     C                   if        zdmsg = *blanks
     C                   eval      zdmsg = 'Device is invalid.'
     C                   endif
     C                   else
     C                   eval      sel = *blank
     C                   movea     '0000'        *in(50)
     C                   endif
     C                   endif
     C                   if        tested = *on
     C                   eval      tested = *off
     C                   if        zdmsg = *blanks
     C                   eval      zdmsg = 'Device is valid.'
     C                   endif
     C                   endif
     *  update subfile record
     C                   if        s2nof5 = arnof5
     C                             and arnof5 <> *blanks
     C                   eval      *in54 = *on
     C                   else
     C                   eval      *in54 = *off
     C                   endif
     C                   if        arcdl3 = 'I'
     C                   eval      *in55 = *on
     C                   else
     C                   eval      *in55 = *off
     C                   endif
     C                   if        InactiveCnt > *zero
     C                   eval      *in56 = *on
     C                   else
     C                   eval      *in56 = *off
     C                   endif
     C                   update    ARs5616A
     C                   endif
     C                   endfor

     C                   endsr

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
     C     CRCD          WHENEQ    'ARS5616A'
     C     CRRN          CHAIN     ARS5616A                           42
      *
     C                   SELECT
     C     CFLD          WHENEQ    'SEL'
     C                   MOVE      *BLANKS       VALUE#
     C                   CALL      'TBR0060'     PL0060                         TABLE FILE\ACTION
     C     VALUE#        IFNE      *BLANKS
     C                   MOVEL     VALUE#        SEL
     C     ACT#          IFEQ      '1'
     C                   MOVE      *OFF          *IN04                          PROCESS SEL
     C                   ENDIF                                                  TABENT
     C                   ENDIF                                                  TABENT
     C                   OTHER
     C                   MOVE      *ON           F4ERR
     C                   ENDSL                                                  CFLD
      *
     C     *IN42         IFEQ      *OFF
     C                   MOVE      *ON           *IN90                          SFLNXTCHG
     C                   if        s2nof5 = arnof5
     C                             and arnof5 <> *blanks
     C                   eval      *in54 = *on
     C                   else
     C                   eval      *in54 = *off
     C                   endif
     C                   if        arcdl3 = 'I'
     C                   eval      *in55 = *on
     C                   else
     C                   eval      *in55 = *off
     C                   endif
     C                   UPDATE    ARS5616A
     C                   MOVE      *OFF          *IN90                          SFLNXTCHG
     C                   ENDIF                                                  *IN42
      *
     C                   MOVE      *BLANKS       SEL
     C                   ENDSL                                                  CFLD
      *
     C                   ELSE
     C                   MOVE      *ON           F4ERR
     C                   ENDIF
      *
      * SEND ERROR MESSAGE - CURSOR LOCATION INVALID
      *
     C     F4ERR         IFEQ      *ON
     C                   MOVE      *ON           *IN99
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
     C     C@LOC         DIV       256           ROW               3 0
     C                   MVR                     COL               3 0
     C                   MOVE      ROW           ROW#              3
     C                   MOVE      COL           COL#              3
     C     ROW#          CAT       COL#          C@LOC#            6
     C                   MOVEL     CRCD          CRCD#            10
     C                   MOVEL     CFLD          CFLD#            10
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

     **********************************************************************
     *  SUBROUTINE:  Load device list
     C     srLoadD       begsr

     C                   eval      srno16 = BRANCH
     C     branch        chain     arlmbch2
     C                   if        %found(arlmbch2)
     C                   eval      srnm07 = arnm07
     C                   endif
     C                   eval      rrn   = 0
     C                   Z-ADD     0             X                 3 0

     *  Initialize subfile
     C                   eval      *in73 = true
     C                   eval      *in75 = false
     C                   eval      *in76 = false
     C                   eval      *in77 = false
     C                   write     ARc5616A
     C                   eval      *in73 = false
     C                   eval      *in76 = true

     C                   z-add     *zeros        InactiveCnt       3 0
     *  list all devices for this branch
   ACC*    BRANCH        CHAIN(N)  ARLMCCD1
   ACC*                  if        %found(ARLMCCD1)
   ACC*                  dow       not %eof(ARLMCCD1)
AC   C                   eval      cardCode = 'F'
AC   C     CCD3KY        CHAIN(N)  ARLMCCD3
AC   C                   if        %found(ARLMCCD3)
AC   C                   dow       not %eof(ARLMCCD3)
     C                   MOVEL     ARNM71        svnm71
     C                   MOVEL     ARNM72        svnm72
     C                   MOVEL     ARNOF5        svnof5
     C                   MOVEL     ARCDL3        svcdl3
     C                   eval      s2nof5 = *blanks
   AB*  If serial number is used in transaction protect it.
   ABC*/exec sql
   ABC*+  select  arnof5 into :s2nof5
   ABC*+  from arptcct
   ABC*+     where trim(arnof5) = trim(:arnof5)
   ABC*/end-exec
AB   C                   eval      act_tx_cnt = *zeros
AB   C                   eval      dltWarned = *blanks
AB    *
AB   *  Check the device serial number is used in transaction that is less than 1 year
AB   *  and status is not Settled, Voided and Declined.
AB   *  (Note - instead of 1 year = 12 month, we are comparing about 11 months
AB   *   as day is not used in transaction date comparison to avoid unnecessary processing)
AB   C/exec sql
AB   C+  select  count(arnoc1) into :act_tx_cnt
AB   C+  from arptcct
AB   C+   where trim(arnof5) = trim(:arnof5) and
AB   C+    arno16 = :srno16 and
AB   C+    arcdf6 <> 'S' and arcdf6 <> 'V' and arcdf6 <> 'D' and
AB   C+    int(arcc84 || digits(aryr84) || digits(armo84)) >= :lst_ccyrmo
AB   C/end-exec
AB   C                   if        act_tx_cnt    > *zeros
AB   C                   eval      s2nof5 = arnof5
AB   C                   endif
AB    *
     C                   if        s2nof5 = arnof5
     C                             and arnof5 <> *blanks
     C                   eval      *in54 = *on
     C                   else
     C                   eval      *in54 = *off
     C                   endif
     C                   if        arcdl3 = 'I'
     C                   eval      *in55 = *on
     C                   eval      InactiveCnt += 1
     C                   else
     C                   eval      *in55 = *off
     C                   endif
     C                   if        InactiveCnt > *zero
     C                   eval      *in56 = *on
     C                   else
     C                   eval      *in56 = *off
     C                   endif
     * write subfile record
     C                   eval      x += 1
     C                   eval      rrn   = x
     C                   write     ARs5616A
   ACC*    BRANCH        READE(N)  ARLMCCD1
AC   C     CCD3KY        READE(N)  ARLMCCD3
     C                   enddo
     C                   endif

     C                   eval      *in54 = *off
     C                   eval      *in55 = *off
     C                   MOVEL     *blanks       svnm71
     C                   MOVEL     *blanks       svnm72
     C                   MOVEL     *blanks       svnof5
     C                   MOVEL     *blanks       svcdl3
     C                   MOVEL     *blanks       arnm71
     C                   MOVEL     *blanks       arnm72
     C                   MOVEL     *blanks       arnof5
     C                   MOVEL     *blanks       arcdl3
AD   C                   clear                   s2nm71
AD   C                   clear                   s2nof5
AD   C                   clear                   s2nm72
AD   C                   clear                   s2cdl3
AD   C                   clear                   act_tx_cnt
AD   C                   clear                   dltwarned
     *  write 20 blank lines for new devices
     C     1             do        20
     * write subfile record
     C                   eval      x += 1
     C                   eval      rrn   = x
     C                   write     ARs5616A
     C                   enddo

     C                   endsr
     **********************************************************************
     *  SUBROUTINE:  Save device
     C     srSaveD       begsr

     C                   eval      arno16 = branch
     C                   for       rrn   = 1 to 100
     C     rrn           chain     ARs5616A
     C                   eval      s2nof5 = arnof5
     C                   eval      s2nm71 = arnm71
     C                   eval      s2nm72 = arnm72
     C                   eval      s2cdl3 = arcdl3
     C                   if        arcdl3 = 'I'
     C/exec sql
     C+  delete
     C+  from oepmcdv
     C+     where trim(arnof5) = trim(:arnof5)
     C/end-exec
     C                   endif
     C                   if        %found(ARd5616)
     C                   if        arnm71 <> *blanks
     C     cdvkey2       chain     arlmccd1
     C                   eval      arnof5 = s2nof5
     C                   eval      arnm71 = s2nm71
     C                   eval      arnm72 = s2nm72
     C                   eval      arcdl3 = s2cdl3
AC   C                   eval      arcdj3 = 'F'
     C                   if        %found(arlmccd1)
     C                   update    arfmccd
     C                   else
     C                   write     arfmccd
     C                   endif
     C                   else
     C                   if        svnm71 <> *blanks
     C     cdvkey2       delete    arfmccd
AB   C                   if        dltWarned = 'Y'
AB   C                   eval      arnm71 = svnm71
AB   C                   eval      arnm72 = svnm72
AB   C                   eval      arcdl3 = 'D'
AC   C                   eval      arcdj3 = 'F'
AB   C                   write     arfhccd
AB   C                   endif
     C/exec sql
     C+  delete
     C+  from oepmcdv
     C+     where trim(arnof5) = trim(:svnof5)
     C/end-exec
     C                   endif
     C                   endif
     C                   endif
     C                   endfor
     C                   endsr


