     H OPTION(*SRCSTMT: *NODEBUGIO)
     H dftactgrp(*no)
F*------------------------------------------------------------------------*
F*N PROGRAM NAME - WRITPHBAL                                             *
F*------------------------------------------------------------------------*
F*D WRITE ARPHBAL RECORDS                                                *
F*------------------------------------------------------------------------*
F*S PURPOSE:                                                             *
F*S    This program writes records to the ARPHBAL table.                *
F*S    Logic extracted from ARR5015.                                     *
F*------------------------------------------------------------------------*
     FARPHBAL   O    E             DISK
     FTBLMTBL1  IF   E           K DISK
     
D                 DS
D  ARMO82                 1      2  0
D  ARCC82                 3      4  0
D  ARYR82                 5      6  0
D  DSTMPR                 1      6  0
D                 DS                  INZ
D  MONTH                  1      2  0
D  DAY                    3      4  0
D  CEN                    5      6  0
D  YEAR                   7      8  0
D  DATE                   1      8  0
D                 DS
D  STDATE                 1     16
D  DSDATE                 1      8  0
D  LSTMDT                 9     16  0
D                 DS
D  ACDATE                 1     12
D  ACDT1                  1      6  0
D  ACDT2                  7     12  0

C     *ENTRY        PLIST
C                   PARM                    ARNO01            6 0
C                   PARM                    ARNO15            3 0
C                   PARM                    ARNO16            3 0
C                   PARM                    ARID01            3
C                   PARM                    ARID05            3
C                   PARM                    ARFL14            1
C                   PARM                    CREDIT            1
C                   PARM                    FL03              1
C                   PARM                    FL76              1
C                   PARM                    AM01              9 2

C     TBKEY         KLIST
C                   KFLD                    TBNO01            4
C                   KFLD                    TBNO02            9

C                   Z-ADD     UMONTH        MONTH
C                   Z-ADD     UDAY          DAY
C                   Z-ADD     UYEAR         YEAR
C                   MOVEL     *YEAR         CEN

C                   EXSR      DATES
C                   Z-ADD     ACDT2         DSTMPR
C                   EXSR      CLRAMT
C                   WRITE     ARFHBAL

C                   SETON                                        LR
C                   RETURN

C     DATES         BEGSR
C                   EVAL      STDATE = *ZEROS
C                   EVAL      ACDATE = *ZEROS
C                   MOVE      'AR09'        TBNO01
C                   MOVE      *BLANKS       TBNO02
C                   MOVEL     ARNO15        TBNO02
C     TBKEY         CHAIN     TBFMTBL                            49
C     *IN49         IFEQ      '0'
C                   MOVEL     TBNO03        ACDATE
C                   END
C                   MOVE      'AR11'        TBNO01
C                   MOVE      *BLANKS       TBNO02
C                   MOVEL     ARNO15        TBNO02
C                   MOVE      'DATA  '      TBNO02
C     TBKEY         CHAIN     TBFMTBL                            49
C     *IN49         IFEQ      '0'
C                   MOVEL     TBNO03        STDTE            16
C                   MOVE      STDTE         STDATE
C                   END
C                   ENDSR

C     CLRAMT        BEGSR
C                   Z-ADD     0             ARBL02
C                   Z-ADD     0             ARBL11
C                   Z-ADD     0             ARBL12
C                   Z-ADD     0             ARBL15
C                   Z-ADD     0             ARBL50
C                   Z-ADD     0             ARBL51
C                   Z-ADD     0             ARBL52
C                   Z-ADD     0             ARBL53
C                   Z-ADD     0             ARBL54
C                   Z-ADD     0             ARBL55
C                   Z-ADD     0             ARBL56
C                   Z-ADD     0             ARBL57
C                   Z-ADD     0             ARBL58
C                   Z-ADD     0             ARBL75
C                   Z-ADD     0             ARBL61
C                   Z-ADD     0             ARBL62
C                   Z-ADD     0             ARAM04
C                   Z-ADD     0             ARAM05
C                   Z-ADD     0             ARAM07
C                   Z-ADD     0             ARAM08
C                   Z-ADD     0             ARAM09
C                   Z-ADD     0             ARAM16
C                   Z-ADD     0             ARAM17
C                   Z-ADD     0             ARAM18
C                   Z-ADD     0             ARAM19
C                   Z-ADD     0             ARAM20
C                   Z-ADD     0             ARAM21
C                   Z-ADD     0             ARAM22
C                   Z-ADD     0             ARAM23
C                   Z-ADD     0             ARCN01
C                   Z-ADD     0             ARDY03
C                   Z-ADD     0             ARDY04
C                   Z-ADD     0             ARDY11
C                   Z-ADD     0             ARDY16
C                   Z-ADD     0             ARMO03
C                   Z-ADD     0             ARMO04
C                   Z-ADD     0             ARMO11
C                   Z-ADD     0             ARMO16
C                   Z-ADD     0             ARCC03
C                   Z-ADD     0             ARYR03
C                   Z-ADD     0             ARCC04
C                   Z-ADD     0             ARYR04
C                   Z-ADD     0             ARCC11
C                   Z-ADD     0             ARYR11
C                   Z-ADD     0             ARCC16
C                   Z-ADD     0             ARYR16
C                   Z-ADD     0             ARNO03
C                   ENDSR
