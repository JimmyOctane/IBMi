     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - IVR6110                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983, 1990, 1992, 1997, 2006              *
     F*------------------------------------------------------------------------*
     F*D CALCULATE WAC                                                         *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S   This program can be called to calculate WAC for an item.            *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000009876 060906 070 NON-STOCK INVENTORY BALANCING                   *
AA   F*E 8000009570 072607 070 HD/WO INTERFACE                                 *
     F*M ----------------------------------------------------------------------*
      *------------------------------------------------------------------------*
      * Parameter lists
      *------------------------------------------------------------------------*
     C     *ENTRY        PLIST
     C                   PARM                    PMIOB             7 0          OnHand B4
     C                   PARM                    PMIWB             9 4          WAC B4
     C                   PARM                    PMITQ             7 0          Tran Qty
     C                   PARM                    PMITC             9 4          Tran Cost
     C                   PARM                    PMOWA             9 4          WAC after
      *------------------------------------------------------------------------*
      * Field definitions and initializations
      *------------------------------------------------------------------------*
     C                   CLEAR                   PMOWA
     C     PMIOB         ADD       PMITQ         OA                7 0          OnHand after
      *------------------------------------------------------------------------*
      * Mainline processing
      *------------------------------------------------------------------------*
      *
     C                   SELECT
      * If on-hand after the receipt is <= 0, WAC remains the same
      * as before the receipt...
     C     OA            WHENLE    *ZERO
     C                   Z-ADD     PMIWB         PMOWA
      * If on-hand before the receipt is <= 0, and on-hand after the
      * receipt is > 0, WAC becomes the new receipt landed cost...
     C     PMIOB         WHENLE    *ZERO
     C     OA            ANDGT     *ZERO
     C                   Z-ADD     PMITC         PMOWA
      * If on-hand before the receipt is > 0, and on-hand after the
      * receipt is > 0, calculate WAC...
     C     PMIOB         WHENGT    *ZERO
     C     OA            ANDGT     *ZERO
      *   On Hand B4 * WAC B4 = Perpetual Value B4...
     C     PMIOB         MULT(H)   PMIWB         VALBEF           15 7
      *   Quantity Received * Landed Cost = Receipt Value...
AA   C     PMITQ         IFNE      *ZEROS
     C     PMITQ         MULT(H)   PMITC         VALREC           15 7
AA   C                   ELSE
AA   C                   Z-ADD     PMITC         VALREC
AA   C                   ENDIF
      *   Perpetual Value B4 + Receipt Value = Perpetual Value After...
     C     VALBEF        ADD       VALREC        VALNEW           15 7
      *   Perpetual Value After / Quantity On Hand After = WAC...
     C     VALNEW        DIV(H)    OA            PMOWA
     C                   ENDSL
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
