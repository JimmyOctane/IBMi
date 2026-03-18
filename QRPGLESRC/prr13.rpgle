     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - PRR0841                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D BUILD WORK FILE FOR REBATE REPORT                                     *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S   Build a work file for the Rebate Report.  The work file will        *
     F*S   contain sales line item detail records that meet the                *
     F*S   selection criteria that was entered by the user.                    *
     F*S METHODS:                                                              *
     F*S   The Rebate Contract Master file is read.  If the contract was       *
     F*S   valid during the selected sales period, then the contract           *
     F*S   sub-headers are read.  If the contract sub-headers were valid       *
     F*S   during the sales period, then the contract details are read.        *
     F*S   Each contract detail record will either contain an inventory        *
     F*S   item number or will point to one through the sec/grp/cat.           *
     F*S   A search is made for items that were sold under the contract        *
     F*S   agreement, and if/when found, they are written to a workfile.       *
     F*S CONTROLS:                                                             *
     F*S   Records that were processed outside of the selected sales           *
     F*S      period will be bypassed.                                         *
     F*S   Debit Memo sales records are bypassed.                              *
     F*S   Sales records with quantity shipped = 0 are bypassed.               *
     F*S   The same Order/Order Line Seq# will not be written twice.           *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
AM   F*E 1230000810 071007 127 Primary Vendor Override Entry/Maintenance       *
AN   F*E 8000010162 042108 914 MINCRONIZE RGA FOR NEXT RELEASE                 *
AO   F*E 0820000542 050223 404 EMAIL CONTRACT REBATE REPORT
     F*M ----------------------------------------------------------------------*
     FOPLMPRD1  IF   E           K DISK
     FPRLMCPH1  IF   E           K DISK
     FPRLMCPS1  IF   E           K DISK
     FPRLMCPS5  IF   E           K DISK
     F                                     RENAME(PRFMCPS:PRFMCPS5)
     FPRLMCPD4  IF   E           K DISK
     FPRLMPSD2  IF   E           K DISK
     FPRLMPSD5  IF   E           K DISK
     F                                     RENAME(PRFMPSD:PRFPSDE)
     FPRLMREG1  IF   E           K DISK
     FARLMCUS1  IF   E           K DISK
     FIVLMUOM1  IF   E           K DISK
     FPRPWREB   O    E             DISK
     FIVLMSTR8  IF   E           K DISK
     FOELTOHY6  IF   E           K DISK
     FOELTOHY7  IF   E           K DISK
     F                                     RENAME(OEFTOHY:OEFTOHY7)
     FOELTOLYN  IF   E           K DISK
AN   F                                     IGNORE(OEFTOL)
     FPRLWREB2  IF   E           K DISK
     F                                     RENAME(PRFWREB:BYORD)
     FARLMCUSD  IF   E           K DISK
     F                                     RENAME(ARFMCUS:BYENT)
     FARLMENT1  IF   E           K DISK
     D* SALES PERIOD "FROM" YEAR/MONTH/DAY
     D                 DS
     D  PFRYMD                 1      8  0
     D  PFRCC                  1      2  0
     D  PFRYR                  3      4  0
     D  PFRMO                  5      6  0
     D  PFRDY                  7      8  0
     D* SALES PERIOD "TO" YEAR/MONTH/DAY
     D                 DS
     D  PTOYMD                 1      8  0
     D  PTOCC                  1      2  0
     D  PTOYR                  3      4  0
     D  PTOMO                  5      6  0
     D  PTODY                  7      8  0
     D* REBATE CONTRACT HEADER "FROM" YEAR/MONTH/DAY
     D                 DS
     D  HFRYMD                 1      6  0
     D  PRYR13                 1      2  0
     D  PRMO13                 3      4  0
     D  PRDY13                 5      6  0
     D* REBATE CONTRACT HEADER "TO" YEAR/MONTH/DAY
     D                 DS
     D  HTOYMD                 1      6  0
     D  PRYR14                 1      2  0
     D  PRMO14                 3      4  0
     D  PRDY14                 5      6  0
     D* REBATE CONTRACT SUB-HEADER "FROM" YEAR/MONTH/DAY
     D                 DS
     D  SFRYMD                 1      8  0
     D  PRCC15                 1      2  0
     D  PRYR15                 3      4  0
     D  PRMO15                 5      6  0
     D  PRDY15                 7      8  0
     D* REBATE CONTRACT SUB-HEADER "TO" YEAR/MONTH/DAY
     D                 DS
     D  STOYMD                 1      8  0
     D  PRCC16                 1      2  0
     D  PRYR16                 3      4  0
     D  PRMO16                 5      6  0
     D  PRDY16                 7      8  0
     D* SALES ORDER HEADER - DATE ORDER PLACED
     D                 DS
     D  OEPYMD                 1      8  0
     D  ARCC05                 1      2  0
     D  ARYR05                 3      4  0
     D  ARMO05                 5      6  0
     D  ARDY05                 7      8  0
     IIVFMSTR
     I              IVNO07                      MSTITM
AO   I              IVNO93                      XXNO93
     IIVFMUOM
     I              IVNO07                      UOMITM
     IPRFMCPD
     I              PRNO12                      CPDCTL
     I              IVNO07                      CPDITM
     I              IVCD17                      CPDSEC
     I              IVCD18                      CPDGRP
     I              IVCD19                      CPDCAT
     IPRFMPSD
     I              APNO01                      XXNO01
      *****************************************************************
      *  SECTION 0         NON EXECUTABLE STATEMENTS
      *
      * STEP 1.  DECLARE PARAMETER LISTS
      * STEP 2.  DEFINE LIKE FIELDS
      * STEP 3.  DECLARE KEY LISTS
      * STEP 4.  INITIALIZE DATA STRUCTURES
      *****************************************************************
      ***********
      * STEP 1. * PARMS LIST
      ***********
     C     *ENTRY        PLIST
     C                   PARM                    XXCO                           COMPANY NUMBER
     C                   PARM                    XXBR                           BRANCH NUMBER
     C                   PARM                    XXSLYR                         SALES YEAR
     C                   PARM                    XXSLMO                         SALES MONTH
     C                   PARM                    XXVEND                         VENDOR NUMBER
     C                   PARM                    XXSLCC
AM    *
AM   C     PL0075        PLIST
AM   C                   PARM                    IVNO07
AM   C                   PARM                    XXBR
AM   C                   PARM                    IVNO05
      ***********
      * STEP 2. * DEFINE LIKE FIELDS
      ***********
     C     *LIKE         DEFINE    IVNO07        SNO07                          ITEM #
     C     *LIKE         DEFINE    PRAM13        SAM13                          COST
     C     *LIKE         DEFINE    ARNO15        XXCO                           COMPANY
     C     *LIKE         DEFINE    OENO16        XXBR                           BRANCH NUMBER
     C     *LIKE         DEFINE    OECC08        XXSLCC
     C     *LIKE         DEFINE    OEYR08        XXSLYR                         SALES YEAR
     C     *LIKE         DEFINE    OEMO08        XXSLMO                         SALES MONTH
     C     *LIKE         DEFINE    APNO01        XXVEND                         VENDOR NUMBER
     C     *LIKE         DEFINE    ARNO01        SVNO01                         SAVE CUST NO.
     C     *LIKE         DEFINE    ARNO06        SVNO06                         SAVE JOB NO.
     C     *LIKE         DEFINE    IVCD08        CD08
     C     *LIKE         DEFINE    PRCD01        PRCCDE
      ***********
      * STEP 3. * DECLARE KEY LISTS
      ***********
     C     CTL#BR        KLIST
     C                   KFLD                    PRNO02                                     BER
     C                   KFLD                    OENO08
     C     MCPDKY        KLIST
     C                   KFLD                    CPDCTL
     C                   KFLD                    CPDSEC
     C                   KFLD                    CPDGRP
     C                   KFLD                    CPDCAT
     C                   KFLD                    CPDITM
     C     MCPDK2        KLIST
     C                   KFLD                    CPDCTL
     C                   KFLD                    CPDSEC
     C     TOHKY1        KLIST
     C                   KFLD                    XXCO
     C                   KFLD                    XXSLCC
     C                   KFLD                    XXSLYR
     C                   KFLD                    XXSLMO
     C                   KFLD                    ARNO01
     C                   KFLD                    SVNO06
     C                   KFLD                    XXBR
     C     TOHKY2        KLIST
     C                   KFLD                    XXCO
     C                   KFLD                    XXSLCC
     C                   KFLD                    XXSLYR
     C                   KFLD                    XXSLMO
     C                   KFLD                    ARNO01
     C                   KFLD                    XXBR
     C     TOHKY3        KLIST
     C                   KFLD                    XXCO
     C                   KFLD                    XXSLCC
     C                   KFLD                    XXSLYR
     C                   KFLD                    XXSLMO
     C                   KFLD                    ARNO01
     C     TOHKY4        KLIST
     C                   KFLD                    XXCO
     C                   KFLD                    XXSLCC
     C                   KFLD                    XXSLYR
     C                   KFLD                    XXSLMO
     C                   KFLD                    ARNO01
     C                   KFLD                    SVNO06
     C     VNDSHT        KLIST
     C                   KFLD                    IVNO05
     C                   KFLD                    PRCCDE
     C                   KFLD                    IVNO07
     C     UOMKEY        KLIST
     C                   KFLD                    IVNO07
     C                   KFLD                    CD08
     C     OEKEY         KLIST
     C                   KFLD                    OENO01
     C                   KFLD                    OENO22
     C     PRCKEY        KLIST
     C                   KFLD                    PRNO15
     C                   KFLD                    IVNO07
     C     PRDKY         KLIST
     C                   KFLD                    XXSLCC
     C                   KFLD                    XXSLYR
     C                   KFLD                    XXSLMO
      ***********
      * STEP 4. * INITIALIZE DATA STRUCTURES AND FIELDS
      ***********
     C                   MOVE      *ZEROS        OEPYMD
     C                   MOVE      *ZEROS        PFRYMD
     C                   MOVE      *ZEROS        PTOYMD
     C                   MOVE      *ZEROS        HFRYMD
     C                   MOVE      *ZEROS        HTOYMD
     C                   MOVE      *ZEROS        SFRYMD
     C                   MOVE      *ZEROS        STOYMD
     C                   MOVE      *ZEROS        SVNO01
     C                   MOVE      *ZEROS        PRNO12
     C                   MOVE      *ZEROS        IVNO07
     C                   MOVE      'B'           CD08
      *****************************************************************
      *  SECTION 1         BUILD WORK FILE - MAINLINE
      *
      * STEP 1.  GET THE DATE RANGE OF THE SELECTED SALES PERIOD
      * STEP 2.  READ CONTRACTS MASTER FILE BY VENDOR OR FOR A VENDOR
      * STEP 3.  DETERMINE IF THE REBATE CONTRACT EFFECTIVE DATE RANGE
      *          IS WITHIN THE SELECTED SALES PERIOD DATE RANGE.
      * STEP 4.  IF THE CONTRACT WAS VALID DURING THE SELECTED SALES
      *          PERIOD, READ THE CONTRACT SUB-HDR CUSTOMER/JOB FILE.
      * STEP 5.  DETERMINE IF THE CONTRACT SUB-HDR EFFECTIVE DATE RANGE
      *          IS WITHIN THE SELECTED SALES PERIOD DATE RANGE.
      * STEP 6.  IF THE CONTRACT SUB-HDR WAS VALID DURING THE SELECTED
      *          SALES PERIOD, DETERMINE ITEMS UNDER CONTRACT.
      * STEP 7.  WRITE SELECTED ORDER LINES TO REBATE REPORT WORKFILE.
      *****************************************************************
      ***********
      * STEP 1.  GET THE DATE RANGE OF THE SELECTED SALES PERIOD
      ***********
     C     PRDKY         CHAIN     OPFMPRD                            49
     C     *IN49         IFEQ      *OFF
     C                   Z-ADD     OPMO08        PFRMO
     C                   Z-ADD     OPDY08        PFRDY
     C                   Z-ADD     OPCC08        PFRCC
     C                   Z-ADD     OPYR08        PFRYR
     C                   Z-ADD     OPMO09        PTOMO
     C                   Z-ADD     OPDY09        PTODY
     C                   Z-ADD     OPCC09        PTOCC
     C                   Z-ADD     OPYR09        PTOYR
     C                   ENDIF
      ***********
      * STEP 2.  READ CONTRACTS MASTER FILE BY VENDOR OR FOR A VENDOR
      *          PROCESS ALL CUSTOMER/JOB ASSIGNMENTS FIRST.
      ***********
      *
     C                   DO        2             Z                 1 0
     C     XXVEND        IFEQ      0
     C     XXVEND        SETLL     PRFMCPH
     C                   READ      PRFMCPH                                41
     C                   ELSE
     C     XXVEND        CHAIN     PRFMCPH                            41
     C                   END
      *
     C     *IN41         DOWEQ     '0'
      ***********
      * STEP 3.  DETERMINE IF THE REBATE CONTRACT EFFECTIVE DATE RANGE
      *          IS WITHIN THE SELECTED SALES PERIOD DATE RANGE.
      ***********
      * STEP 4.  IF THE CONTRACT WAS VALID DURING THE SELECTED SALES
      *          PERIOD, READ THE CONTRACT SUB-HDR CUSTOMER/JOB FILE.
      *          PROCESS ALL CUSTOMER/JOB ASSIGNMENTS FIRST.
      ***********
     C     Z             IFEQ      1
     C     PRNO12        CHAIN     PRLMCPS5                           42
     C                   ELSE
     C     PRNO12        CHAIN     PRLMCPS1                           42
     C                   ENDIF
     C     *IN42         DOWEQ     '0'
     C                   MOVE      ARNO06        SVNO06                         SAVE JOB NO.
      ***********
      * STEP 5.  DETERMINE IF THE CONTRACT SUB-HDR EFFECTIVE DATE RANGE
      *          IS WITHIN THE SELECTED SALES PERIOD DATE RANGE.
      ***********
      *
      * ENTERPRISE OR CUSTOMER ?
      *
     C     ARNO01        SETLL     ARFMENT                                51
     C     *IN51         IFEQ      *ON
     C                   EXSR      SRENT
     C                   ELSE
     C                   EXSR      SRSALE
     C                   ENDIF
      *
     C     Z             IFEQ      1
     C     PRNO12        READE     PRLMCPS5                               42
     C                   ELSE
     C     PRNO12        READE     PRLMCPS1                               42
     C                   ENDIF
     C                   END
      *
     C     XXVEND        IFEQ      0
     C                   READ      PRFMCPH                                41
     C                   ELSE
     C     XXVEND        READE     PRFMCPH                                41
     C                   END
     C                   END
     C                   ENDDO
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      **********************************************************************
      * STEP 7.  WRITE SELECTED ORDER LINES TO REBATE REPORT WORKFILE.
      * THIS SUBROUTINE READS SALES ORDER LINES AND DETERMINES WHETHER
      * THE RECORD SHOULD BE WRITTEN TO THE REBATE REPORT WORK FILE.
      **********************************************************************
     C     SRSALE        BEGSR
      *
     C     SVNO06        IFNE      *BLANKS
     C     XXBR          ANDNE     *ZEROS
     C     TOHKY1        CHAIN     OEFTOHY                            45
     C                   END
      *
     C     SVNO06        IFNE      *BLANKS
     C     XXBR          ANDEQ     *ZEROS
     C     TOHKY4        CHAIN     OEFTOHY                            45
     C                   END
      *
     C     SVNO06        IFEQ      *BLANKS
     C     XXBR          ANDNE     *ZEROS
     C     TOHKY2        CHAIN     OEFTOHY7                           45
     C                   END
      *
     C     SVNO06        IFEQ      *BLANKS
     C     XXBR          ANDEQ     *ZEROS
     C     TOHKY3        CHAIN     OEFTOHY                            45
     C                   END
      *
     C     *IN45         DOWEQ     '0'
      * BYPASS DEBIT MEMOS
     C     OECD08        IFNE      'D'
      * CHECK "ORDER PLACED DATE" TO SEE IF WITHIN CONTRACT EFFECTIVE DT'S
     C     OEPYMD        IFGE      SFRYMD
     C     OEPYMD        ANDLE     STOYMD
      * CHECK THIS ORDER FOR THE ITEM BEING PROCESSED
     C     OENO01        CHAIN     OEFTOLY                            46
     C     *IN46         DOWEQ     '0'
      * BYPASS......IF THIS ORDER & LINE IS ALREADY IN WORKFILE
     C     OEKEY         SETLL     BYORD                                  52
     C     *IN52         IFEQ      *OFF
      * BYPASS......IF QTY SHIPPED = 0
     C     OEQY03        IFNE      *ZERO
     C     OECD09        IFEQ      'S'
     C     OECD09        OREQ      'G'
     C                   MOVE      '0'           *IN50
     C                   EXSR      CHKITM
     C     *IN50         IFEQ      '1'
      * GET CUSTOMER NAME, IF A NEW CUSTOMER IS BEING PROCESSED
     C     ARNO01        IFNE      SVNO01
     C     ARNO01        CHAIN     ARFMCUS                            47
     C     *IN47         IFEQ      '1'
     C                   MOVE      *BLANKS       ARNM01
     C                   END
     C                   MOVE      ARNO01        SVNO01
     C                   END
      * WRITE TO REBATE REPORT WORK FILE
     C                   MOVE      SVNO06        ARNO06
     C     OECD16        IFEQ      'I'
     C                   MOVE      'S'           OECD16                         STOCKING ORD
     C                   END
     C                   WRITE     PRFWREB
      *
     C                   END
     C                   END
     C                   ENDIF
     C                   ENDIF
     C     OENO01        READE     OEFTOLY                                46
     C                   END
      *
     C                   END
     C                   END
     C     SVNO06        IFNE      *BLANKS
     C     XXBR          ANDNE     *ZEROS
     C     TOHKY1        READE     OEFTOHY                                45
     C                   END
      *
     C     SVNO06        IFNE      *BLANKS
     C     XXBR          ANDEQ     *ZEROS
     C     TOHKY4        READE     OEFTOHY                                45
     C                   END
      *
     C     SVNO06        IFEQ      *BLANKS
     C     XXBR          ANDNE     *ZEROS
     C     TOHKY2        READE     OEFTOHY7                               45
     C                   END
      *
     C     SVNO06        IFEQ      *BLANKS
     C     XXBR          ANDEQ     *ZEROS
     C     TOHKY3        READE     OEFTOHY                                45
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *----------------------------------------------------*
      * RETRIEVE SGC FROM ITEM MASTER AND CHECK TO SEE IF  *
      * AN ITEM IS SETUP ON THE CONTRACT DETAIL.           *
      *----------------------------------------------------*
     C     CHKITM        BEGSR
     C     IVNO07        CHAIN     IVFMSTR                            30
     C     *IN30         CABEQ     '1'           ENDCHK                         NOT FND
      *
      * CHECK FOR PROFILE
      *
     C                   Z-ADD     PRNO12        CPDCTL
     C                   Z-ADD     IVNO07        CPDITM
     C                   MOVE      IVCD17        CPDSEC
     C                   MOVE      IVCD18        CPDGRP
     C                   MOVE      IVCD19        CPDCAT
     C     MCPDK2        SETLL     PRFMCPD                                40
     C     *IN40         CABEQ     *OFF          ENDCHK                         NOT FND /SEC
     C     MCPDKY        CHAIN     PRFMCPD                            40
      *
      * ONLY PROCESS IF COST TYPE, FIRST RECORD
      *  NOTE:  LOGICAL HAS PRCD73 AS KEY ("C" WILL BE FIRST)
      *
     C     PRCD73        IFNE      'C'
     C                   MOVE      *ON           *IN40
     C                   ENDIF
     C     *IN40         IFEQ      *ON
     C                   Z-ADD     0             CPDITM
     C     MCPDKY        CHAIN     PRFMCPD                            40
     C     PRCD73        IFNE      'C'
     C                   MOVE      *ON           *IN40
     C                   ENDIF
     C     *IN40         IFEQ      *ON
     C                   Z-ADD     0             CPDITM
     C                   MOVE      *BLANKS       CPDCAT
     C     MCPDKY        CHAIN     PRFMCPD                            40
     C     PRCD73        IFNE      'C'
     C                   MOVE      *ON           *IN40
     C                   ENDIF
     C     *IN40         IFEQ      *ON
     C                   Z-ADD     0             CPDITM
     C                   MOVE      *BLANKS       CPDCAT
     C                   MOVE      *BLANKS       CPDGRP
     C     MCPDKY        CHAIN     PRFMCPD                            40
     C     PRCD73        IFNE      'C'
     C                   MOVE      *ON           *IN40
     C                   ENDIF
     C     *IN40         CABEQ     *ON           ENDCHK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     PRNO15        IFNE      *BLANKS
     C     PRCKEY        CHAIN     PRFPSDE                            45
     C     *IN45         IFEQ      *OFF
     C                   Z-ADD(H)  PRAM13        IVAM34
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'C'           PRCCDE
     C                   MOVE      '0'           GOTIT             1
     C                   MOVE      '0'           SAVED             1
AM    *
AM    * POPULATE ALTERNATE VENDOR IF AVAILABLE
AM    *
AM   C                   CALL      'IVR0075'     PL0075
AM    *
     C     VNDSHT        CHAIN     PRFMPSD                            32
     C     *IN32         DOWEQ     '0'
      * DETERMINE IF THE ITEM ON A REGIONAL PRICE SHEET
     C     CTL#BR        SETLL     PRFMREG                                36
     C     *IN36         IFEQ      '1'
     C                   MOVE      '1'           GOTIT                           YES-REGN'L
     C                   MOVE      '1'           *IN32
     C                   ELSE
     C     SAVED         IFEQ      '0'
     C     PRNO02        SETLL     PRFMREG                                36
     C     *IN36         IFEQ      '0'
     C                   Z-ADD     IVNO07        SNO07                           SAVE ITEM#
     C                   Z-ADD     PRAM13        SAM13                           SAVE COST
     C                   MOVE      '1'           SAVED                           NOT-REGN'L
     C                   END
     C                   END
     C                   END
     C     *IN32         IFEQ      '0'
     C     VNDSHT        READE     PRFMPSD                                32
     C                   END
     C                   END
      *
     C     GOTIT         IFEQ      '0'
     C     SAVED         ANDEQ     '1'
     C                   Z-ADD     SNO07         IVNO07                         RESTORE ITEM
     C                   Z-ADD     SAM13         PRAM13                         RESTORE COST
     C                   MOVE      '1'           GOTIT
     C                   END
      *
     C     GOTIT         IFEQ      '1'
     C                   Z-ADD(H)  PRAM13        IVAM34
     C                   END
      *
     C     UOMKEY        CHAIN     IVFMUOM                            31
     C     *IN31         IFEQ      '1'
     C                   MOVE      'EA '         IVDN21
     C                   END
      *
     C                   ENDIF
     C                   MOVE      '1'           *IN50
     C     ENDCHK        ENDSR
      *----------------------------------------------------------------
     C     SRENT         BEGSR
      *          -----     -----
      *
     C                   MOVE      ARNO01        ARNO82
     C     ARNO82        CHAIN     BYENT                              49
     C     *IN49         DOWEQ     *OFF
     C                   EXSR      SRSALE
     C     ARNO82        READE     BYENT                                  49
     C                   ENDDO
      *
     C                   ENDSR
      *
      *----------------------------------------------------------------
      * TABLE FILE CHANGE AREA
      *----------------------------------------------------------------
      ** TABLES TO EDIT THE DAYS IN A YEAR
      * 0131
      * 0228  * SUBROUTINE WILL CALCULATE LEAP YEAR
      * 0331
      * 0430
      * 0531
      * 0630
      * 0731
      * 0831
      * 0930
      * 1031
      * 1130
      * 1231
