     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - ARR5006                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D CUSTOMER MASTER PROMPT                                                *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    This program finds the next available customer number.             *
     F*S    Dtaara ARDA01 is used for the new number.                          *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S     W = WORK FILE RECORD                                              *
     F*S     N = NEW RECORD CREATED                                            *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
     F*M ----------------------------------------------------------------------*
     FARLMCUS1  IF   E           K DISK
     FARLMENT1  IF   E           K DISK
     FARPWARM   IF A E           K DISK
     C     *ENTRY        PLIST
     C                   PARM                    ARNO01
     C                   PARM                    TYPE              2
     C                   PARM                    VALID             1
      *------------------------------------------------------------------------*
      *  SECTION 1         PROCESS PROMPTING
      *
      * STEP 1.  Check TYPE for 'ZZ' or not.
      * STEP 2.  Get last number from ARDA01 dtaara.
      * STEP 3.  Check for not already in use.
      * STEP 4.  Return value to calling program.
      *
      *------------------------------------------------------------------------*
     C     *DTAARA       DEFINE                  ARDA01            6 0
      *------------------------------------------------------------------------*
      * STEP 1.  Initialize fields.
      *------------------------------------------------------------------------*
     C                   CLEAR                   VALID
     C     TYPE          IFEQ      'ZZ'
     C                   MOVE      '1'           *INLR
     C                   ELSE
      *------------------------------------------------------------------------*
      * STEP 2.  Get last number from ARDA01 dtaara.
      *------------------------------------------------------------------------*
     C     *LOCK         IN        ARDA01
      *------------------------------------------------------------------------*
      * STEP 3.  Check for not already in use.
      *------------------------------------------------------------------------*
      * Check if customer number is entered.
     C     ARNO01        IFEQ      *ZEROS
     C     *IN98         DOUEQ     '0'
     C     *IN97         ANDEQ     '0'
     C     *IN96         ANDEQ     '0'
     C                   ADD       1             ARDA01
     C     ARDA01        SETLL     ARFMCUS                                98
     C     ARDA01        SETLL     ARFMENT                                97
     C     ARDA01        SETLL     ARFWARM                                96
     C                   END
     C                   MOVE      'N'           VALID
     C                   Z-ADD     ARDA01        ARNO01
     C                   WRITE     ARFWARM
     C                   ELSE
     C     ARNO01        SETLL     ARFMCUS                                98
     C     ARNO01        SETLL     ARFMENT                                97
     C     ARNO01        SETLL     ARFWARM                                96
     C     *IN98         IFEQ      *OFF
     C     *IN97         ANDEQ     *OFF
     C     *IN96         ANDEQ     *OFF
     C                   MOVE      'N'           VALID
     C                   WRITE     ARFWARM
     C                   ELSE
     C     *IN96         IFEQ      *ON
     C                   MOVE      'W'           VALID
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   OUT       ARDA01
      *------------------------------------------------------------------------*
      * STEP 4.  Return value to calling program.
      *------------------------------------------------------------------------*
     C                   END
     C                   RETURN
