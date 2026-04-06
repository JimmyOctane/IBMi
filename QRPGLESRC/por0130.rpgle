     H OPTION(*SRCSTMT : *NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - POR0130                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D VOID PURCHASE ORDERS                                                  *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    Void (delete) purchase orders                                      *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S   Important: When changing this program, please keep in mind       *
     F*S               that it is called from P/O maintenance.               *
     F*S               The *ENTRY parm 'CODE' will be an 'M' when            *
     F*S               called from P/O maintenance, and functions that       *
     F*S               should only be performed when voiding a P/O           *
     F*S               should be conditioned based on this parm.             *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
BV   F*E 8000009570 102306 019 HD/WO INTERFACE
BW   F*E 8000010061 011807 915 P/O TAG TO USE NEW FIELD FOR S/O                *
BX   F*E 8000009966 012907 915 CHANGE S/O NUMBER TO 7 CHARS ALPHA              *
BY   F*U 0420000938 020908 914 CROSS COMPANY ORDER NOT GOING TO WM             *
BZ   F*E 8000010256 021908 019 Weighted Average Freight                        *
B0   F*U 8000010364 031708 914 PROGESSIVE BILLING UNINVOICE INCORR             *
B1   F*E 8000010207 051308 070 RECEIVING NOTES TO A/P ENHANCEMENT              *
B2   F*U 8000010565 091808 020 Transaction logging - Phase II                  *
B3   F*U 1430000407 101508 907 INTELLCHIEF CHANGES                             *
B4   F*E 8000010325 013009 020 Weighted Average Rebates                        *
B5   F*U 1550000281 091809 070 N/S TAG NOT REMOVED FROM SLS ORDER              *
CA   F*U 0100005323 022310 078 Send PO information to WM                       *
CB   F*E 9000001970 022211 001 Correct subfile issue                           *
CC   F*U 1710000410 101411 923 Function key F6 inclusion & Err Msgs altered    *
CD   F*E 8000011258 050613 248 INCREASE SIZE OF MANUF NUMBER TO 30             *
CE   F*E 8000011260 071213 248 TRACK VOIDED PURCHASE ORDERS                    *
CF   F*E 8000011586 032114 915 Intellichief license key check                  *
CH   F*U 1710000671 072715 115 POD0130 SESSION OR DEVICE ERROR                 *
CI   F*E 1290000353 121515 248 WAR V3 SPECIAL BUY                              *
CK   F*E 8000013132 120620 171 LBMX interface                                  *
CL   F*E 8000013551 010720 915 Capture promo code on P/O                       *
CN   F*C 1710001092 092721 404 PO Price Sheet Options                          *
¢A   F*U 2401       091004 023 DON'T EDI VOIDED ORDERS                         *
     F*M ----------------------------------------------------------------------*
     FAPLMVEN1  UF   E           K DISK    INFDS(ERRDS1)
     FARLMCUS1  IF   E           K DISK
     FAPLMVAD2  IF   E           K DISK
     FIVLMSTR8  IF   E           K DISK
     FIVLTTL10  UF   E           K DISK
     FIVLTTLG   UF   E           K DISK
     F                                     RENAME(IVFTTL:IVFTTLG)
     FEILADT1   IF   E           K DISK
     FIVLMSBR1  UF   E           K DISK
     FOELTOLYK  UF   E           K DISK
   BVF*WOLTOLC   UF   E           K DISK
BV   FWKLTMOV6  UF   E           K DISK
     FPOLTOH1   UF   E           K DISK
     FPOLTOH2   IF   E           K DISK
     F                                     RENAME(POFTOH:POFTOHV)
     FPOLTOA1   UF   E           K DISK
     FPOLTOL1   UF   E           K DISK
     FPOLTOL2   IF   E           K DISK
     F                                     RENAME(POFTOL:POFTOL2)
     FPOLTOT1   UF   E           K DISK
     FPOLTTG1   UF   E           K DISK
     FPOLTNT1   UF   E           K DISK
CL   FPOLTOHA1  UF   E           K DISK
     FIVLTNSK5  IF   E           K DISK
     FPOLTRVL1  UF   E           K DISK
     FPOLTRH3   IF   E           K DISK
     FPOLTSTS1  UF   E           K DISK
     FOPLMSEC2  IF   E           K DISK
     FOPLTFXI3  UF   E           K DISK
     FOELTOALC  UF   E           K DISK
     FOELTOAD2  UF   E           K DISK
     FARLMBCH4  IF   E           K DISK
     FWXLTXRF1  IF   E           K DISK
CE   FPOPTVNT   O    E             DISK
CE   FPOPTVOA   O    E             DISK
CE   FPOPTVOH   O    E             DISK
CE   FPOPTVOL   O    E             DISK
CE   FPOPTVOT   O    E             DISK
CE   FPOPTVVL   O    E             DISK
CE   FPOPTVNK   O    E             DISK
CE   FPOPTVTG   O    E             DISK
CL   FPOPTVOHA  O    E             DISK
CN   FPOQTOLA01 UF   E           K DISK
CN   FPOQTVOLA  O    E             DISK
     FPOD0130   CF   E             WORKSTN
     F                                     INFDS(FIL1DS)
     F                                     SFILE(POS0130E:RRN)
     F                                     SFILE(POS0130F:RNO)
     F                                     SFILE(POS0130G:RRN)
     F                                     SFILE(POS0130K:RRN)
     F                                     SFILE(POS0130M:RRN)
     FTBLMTBL1  IF   E           K DISK
BV    *------------------------------------------------------------------------*
BV B3 */COPY QCPYSRC,SHYPROTO
B3    /INCLUDE QCPYSRC,HDYPROTO
CF    /include QCPYSRC,MNYPROTO
BV    *------------------------------------------------------------------------*
CF   d p1300App        s             10    inz('DII')
CF   d p1300Bypass     s              1    inz('N')
CF    *
     D KY              S              3  0 DIM(990)                             TAG & HOLD KEY
   CBD*TH              S             58    DIM(990)
CB   D TH              S             59    DIM(990)
     D AD              S              1    DIM(50)                              ALT MAIL ADDRESS
     D DOA             S              1    DIM(140) CTDATA PERRCD(70)           SUBMIT DIR AUD
B2    *
B2   d pRetCd          s              1
B2   d pActCd          s              2
B2   d pFunKy          s              1
B2   d pData           s            256
B2    *
     D STSDS          SDS
     D  PROG                   1      8
     D  #BIPGM                81     90
     D  DSPERR                91    160
     D  USRNM                254    263
     D SAVSDS          DS
     D  STSPGM                 1      8
     D  STSLIB                81     90
     D  STSERR                91    160
     D  STSUSR               254    263
     D ERRDS1          DS
     D  FIL1             *FILE
     D  REC1             *RECORD
     D  OP1              *OPCODE
     D  STS1             *STATUS
     D  RTN1             *ROUTINE
     D FIL1DS          DS
     D  SCREEN               261    268
     D  WSNAME               273    281
     D SAVDS           DS                  OCCURS(400)
     D  DSEL                   1      1
     D  DQTY                   2      8  0
     D  DITM                   9     38
   CDD* DMAN                  39     50
   CDD* DUOM                  51     53
   CDD* DDES                  54     88
   CDD* DNO7                  89     94  0
   CDD* DKEY                  95     97  0
   CDD* DLST                  98    108  5
   CDD* DDSC                 109    116
   CDD* DCST                 117    125  4
   CDD* DDOV                 126    126
   CDD* DCOV                 127    127
   CDD* DTYP                 128    128
   CDD* DUMP                 129    131
   CDD* DQYR                 132    138  0
   CDD* DCOM                 139    139
   CDD* DLITD                140    148  2
   CDD* DSDATA                 1    148
CD   D  DMAN                  39     68
CD   D  DUOM                  69     71
CD   D  DDES                  72    106
CD   D  DNO7                 107    112  0
CD   D  DKEY                 113    115  0
CD   D  DLST                 116    126  5
CD   D  DDSC                 127    134
CD   D  DCST                 135    143  4
CD   D  DDOV                 144    144
CD   D  DCOV                 145    145
CD   D  DTYP                 146    146
CD   D  DUMP                 147    149
CD   D  DQYR                 150    156  0
CD   D  DCOM                 157    157
CD   D  DLITD                158    166  2
CD   D  DSDATA                 1    166
     D                 DS
     D  SNAME                  1     30
     D  SADD1                 31     60
     D  SADD2                 61     90
     D  SADD3                 91    120
     D  SCITY                121    145
     D  SSTAT                146    147
     D  SMAIN                148    157
     D  SSHIP                  1    157
     D                 DS
     D  MNAME                  1     30
     D  MADD1                 31     60
     D  MADD2                 61     90
     D  MADD3                 91    120
     D  MCITY                121    145
     D  MSTAT                146    147
     D  MMAIN                148    157
     D  MMAIL                  1    157
     D                 DS
     D  ARNM01                 1     30
     D  ARAD04                31     60
     D  ARAD05                61     90
     D  ARAD06                91    120
     D  ARCY02               121    145
     D  ARST02               146    147
     D  ARZP16               148    157
     D  CUSHIP                 1    157
     D                 DS
     D  APNM01                 1     30
     D  APAD04                31     60
     D  APAD05                61     90
     D  APAD06                91    120
     D  APCY02               121    145
     D  APST02               146    147
     D  APZP08               148    157
     D  AVMAIL                 1    157
     D                 DS
     D  NAME                   1     30
     D  APAD01                31     60
     D  APAD02                61     90
     D  APAD03                91    120
     D  APCY01               121    145
     D  APST01               146    147
     D  APZP07               148    157
     D  UVMAIL                 1    157
     D                 DS
     D  PONM03                 1     30
     D  POAD01                31     60
     D  POAD02                61     90
     D  POAD03                91    120
     D  POCY01               121    145
     D  POST01               146    147
     D  POZP03               148    157
     D  POOVAD                 1    157
     D                 DS
     D  POMO02                 1      2  0
     D  PODY02                 3      4  0
     D  POYR02                 5      6  0
     D  ORDDAT                 1      6  0
     D                 DS
     D  POMO03                 1      2  0
     D  PODY03                 3      4  0
     D  POYR03                 5      6  0
     D  ETADAT                 1      6  0
     D                 DS
     D  POMO04                 1      2  0
     D  PODY04                 3      4  0
     D  POYR04                 5      6  0
     D  SHPDAT                 1      6  0
     D                 DS
     D  TTYP                   1      1
     D  TQTY                   2      8  0
     D  TBRA                   9     11  0
     D  TCUS                  12     17  0
   BXD* TREF                  18     24  0
BX   D  TREF                  18     24
     D  TCOM                  25     59
     D  TAGH                   1     59
     D                 DS
     D  PONO                   1      7  0
     D  YESNO                  8      8
     D  REPRNT                 9      9
     D  RVPRNT                10     12  0
     D  DSPO                   1     12
     D                 DS
     D  DLYMTH                 1      2
     D  DLYDAY                 3      4
     D  DLYYR                  5      6
     D  DLYDAT                 1      6
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
     D                 DS                  INZ
     D  WMCOBR                 1      6
     D  WMCO#                  1      3  0
     D  WMBR#                  4      6  0
     IIVFMSTR
     I              IVNO22                      NO22
     I              IVNO93                      NO93
     IPOFTOL2
     I              PONO01                      PONO1
     I              PONO02                      PONO2
     I              IVNO07                      IVNO7
     I              POCD01                      POC01
     I              POCD13                      POC13
     IIVFTTLG
     I              PONO01                      PONUMB
     IOEFTOL        48
     I              PONO01                      PO#
     I              PONO05                      OPOLN
     IOEFTOLY       49
     I              PONO01                      PO#
     I              PONO05                      OPOLN
     IIVFTTL
     I              PONO01                      TRNO01
   BVI*WOFTOL
   BVI*             PONO01                      PO#
   BVI*             PONO05                      POL#
     IPOFTOA
     I              APNO22                      POO22
     I              APNO23                      POO23
     I              APNO24                      POO24
     I              APNO32                      POO32
     I              APNO33                      POO33
     I              APNO34                      POO34
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
BZ   I              OEAMWF                      OAAMWF
BZ   I              OEAMWC                      OAAMWC
B4   I              OEAMWR                      OAAMWR
     I              OEAM17                      OAAM17
     I              OEAM18                      OAAM18
BZ   I              OEAMEF                      OAAMEF
BZ   I              OEAMEC                      OAAMEC
B4   I              OEAMER                      OAAMER
     I              OEAM38                      OAAM38
     I              OEAM39                      OAAM39
     I              OEAM40                      OAAM40
     I              OEAM41                      OAAM41
     I              OEAM42                      OAAM42
     I              OEAM46                      OAAM46
     I              OEAM47                      OAAM47
     I              OECD03                      OACD03
     I              OECD09                      OACD09
     I              OECD26                      OACD26
     I              OECD27                      OACD27
     I              OECD28                      OACD28
     I              OECD30                      OACD30
     I              OECD31                      OACD31
     I              OECD43                      OACD43
     I              OECD47                      OACD47
     I              OECD55                      OACD55
     I              OECD66                      OACD66
     I              OECD72                      OACD72
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
     I              OENO32                      OANO32
     I              OENO33                      OANO33
     I              OENO35                      OANO35
     I              OENO36                      OANO36
     I              OENO37                      OANO37
     I              OEPC01                      OAPC01
     I              OEPC04                      OAPC04
     I              OEPC07                      OAPC07
     I              OEQY06                      OAQY06
     I              OEQY10                      OAQY10
     I              OEQY11                      OAQY11
     I              OEQY13                      OAQY13
     I              OEQY17                      OAQY17
     I              OETM01                      OATM01
     I              OECC02                      OACC02
     I              OEYR02                      OAYR02
     I              OECC03                      OACC03
     I              OEYR03                      OAYR03
     I              OECC07                      OACC07
     I              OEYR07                      OAYR07
     I              PONO01                      OAPN01
     I              PONO05                      OAPN05
CI   I              OEAMWR_S                    OAAMWR_S
CI   I              OEAMER_S                    OAAMER_S
     IOEFTOAD
     I              PONO01                      LOTPO
BW   IPOFTTG
BW   I              OENO01                      TGNO01
BW   I              OENO22                      TGNO22
      *------------------------------------------------------------------------*
      *  SECTION 0         NON-EXECUTABLE STATEMENTS
      *
      * STEP 1.  DECLARE PARAMETER LISTS
      * STEP 2.  NEXT AVAILIABLE P.O. NUMBER
      * STEP 3.  KEY LIST
      * STEP 4.  LIKE DEFINITIONS
      *------------------------------------------------------------------------*
      * STEP 1. * PARAMETER LIST
      *------------------------------------------------------------------------*
     C     RLOCK         PLIST
     C                   PARM                    DSPERR
     C                   PARM                    DSPF1             1            DISPLAY RETRY?
     C                   PARM                    DSPF2             1            SCREEN RESPONSE
     C     *ENTRY        PLIST
     C                   PARM                    NO01              7            P/O NUMBER
     C                   PARM                    CODE              1            TYPE CODE
     C                   PARM                    POSTS             1            STATUS CODE
     C                   PARM                    VNDNUM            6 0          VENDOR NUMBER
     C                   PARM                    WHRFRM            1
B0   C                   PARM                    PGMFRM            1
     C                   MOVE      NO01          PONO01
     C     POSTS         IFEQ      'X'
     C                   MOVE      'O'           POCD20
     C                   ELSE
     C                   MOVE      POSTS         POCD20
     C                   ENDIF
     C                   MOVE      VNDNUM        APNO01
     C     PL0700        PLIST
     C                   PARM                    USRNAM                         USER ID
     C                   PARM                    SPLNAM                         SPOOL FILE NAME
     C                   PARM                    SPLF#             4 0          SPOOL FILE #
     C                   PARM                    JOBNAM                         JOB NAME
     C                   PARM                    JOB#              6            JOB NUMBER
     C     NOTKEY        PLIST
     C                   PARM                    PONO01                         PO NUMBER
     C                   PARM                    NOTTYP            1            NOTE TYPE
     C                   PARM                    APNO01                         VENDOR NUMBER
     C                   PARM                    DSPF3             1            DSP F3=EXIT
      * Parameter list for call to OER2062;
     C     PL2062        PLIST
     C                   PARM      '4'           ACCESS            1
     C                   PARM                    NSID
     C                   PARM                    ZPONO
     C                   PARM                    TAGXST            1
     C                   PARM                    ONTRF             1
     C                   PARM                    ONSO              1
     C                   PARM                    ONPO              1
     C                   PARM                    ONWO              1
     C                   PARM                    EXISTS            1
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
B2   C     pl0306        plist
B2   C                   parm                    pRetCd
B2   C                   parm                    pActCd
B2   C                   parm                    pFunKy
B2   C                   parm                    pData
CC   C     pl0307        plist
CC   C                   parm                    pMode             1
CC   C                   parm                    AppCod
CC   C                   parm                    DocNo             7
CC   C                   parm                    FaxCnt
     C     PL0400        PLIST
     C                   PARM                    PMIAPL            2
     C                   PARM                    PMOYN             1
      *
     C     PL0510        PLIST
     C                   PARM                    LBLINE            5
     C                   PARM                    LBBRN             3
     C                   PARM                    LBITM             6
CF    *
CF   C     PL1300        PLIST
CF   C                   PARM                    p1300App
CF   C                   PARM                    p1300Bypass
CF    *
      *------------------------------------------------------------------------*
      * STEP 3. * KEY LIST
      *------------------------------------------------------------------------*
     C     MAILKY        KLIST
     C                   KFLD                    APNO01                         VENDOR #
     C                   KFLD                    APCD08                         TYPE CODE
     C                   KFLD                    PONO14                         SEQUENCE #
     C     ADRSOV        KLIST
     C                   KFLD                    PONO01                         P.O. NUMBER
     C                   KFLD                    POCD02                         TYPE CODE
     C     LINKEY        KLIST
     C                   KFLD                    PONO01                         P.O. NUMBER
     C                   KFLD                    PONO05                         LINE NUMBER
     C     NTSKEY        KLIST
     C                   KFLD                    PONO01                         P.O. NUMBER
     C                   KFLD                    POCD08                         NOTES TYPE
     C     TABKEY        KLIST
     C                   KFLD                    TABCOD            4            TABLE CODE
     C                   KFLD                    TABENT            9            TABLE ENTRY
     C     BRKEY         KLIST
     C                   KFLD                    PONO02                         SHIP TO BRANCH
     C                   KFLD                    IVNO07                         OUR ITEM #
      *
     C     RSTKEY        KLIST
     C                   KFLD                    PONO02                         SHIP TO BRANCH
     C                   KFLD                    IVNO07                         OUR ITEM #
     C                   KFLD                    CC11              2 0          ENTERED CENTURY
     C                   KFLD                    YR11              2 0          ENTERED YEAR
     C                   KFLD                    MO11              2 0          ENTERED MONTH
     C                   KFLD                    DY11              2 0          ENTERED DAY
      *
     C     PBKEY         KLIST
     C                   KFLD                    SECPRF                         PROFILE#
     C                   KFLD                    OPNO03                         BR#
      *
     C     PXKEY         KLIST
     C                   KFLD                    SECPRF                         PROFILE#
     C                   KFLD                    BR@               3 0          ZERO
      *
     C     FAXKEY        KLIST
     C                   KFLD                    APPCOD                         APPLICAT. CODE
     C                   KFLD                    PONBR                          P/O #
      *
     C     TRNITM        KLIST
     C                   KFLD                    IVNO07                         OUR ITEM #
   BXC*                  KFLD                    IVNO66                         TRAN NUMBER CH
BX   C                   KFLD                    WKIVNO55                       TRAN NUMBER CH
      *
     C     ITMTRN        KLIST
     C                   KFLD                    PONUMB                         TRAN NUMBER CH
     C                   KFLD                    IVNO66                         TRAN NUMBER CH
     C                   KFLD                    IVNO07                         OUR ITEM #
      *
     C     WMKEY         KLIST
     C                   KFLD                    POPOPO            2            TRN TYPE
   BXC*                  KFLD                    PONO01                         PO NUMBER
BX   C                   KFLD                    WMN01                          PO NUMBER
BV    *
BV   C     WOKEY         KLIST
BV   C                   KFLD                    TAGTRNTPMP                     TRN TYPE
BV   C                   KFLD                    TAGTRNNOMP                     PO NUMBER
CN    *
CN   C     POQ1KY        KLIST
CN   C                   KFLD                    PONO01
CN   C                   KFLD                    DKEY
      *------------------------------------------------------------------------*
      * STEP 4.  LIKE DEFINITIONS
      *------------------------------------------------------------------------*
     C     *LIKE         DEFINE    OPID02        USRNAM                         USER NAME
     C     *LIKE         DEFINE    OPNM04        JOBNAM                         JOB NAME
     C     *LIKE         DEFINE    OPNM05        SPLNAM                         SPOOL FILE NAME
     C     *LIKE         DEFINE    OPNO06        PONBR                          P/O #
     C     *LIKE         DEFINE    OPCD02        APPCOD                         APPLICAT CODE
     C     *LIKE         DEFINE    PONO01        SAVPO                          SAVE P/O    E
     C     *LIKE         DEFINE    PODN10        NSID
     C     *LIKE         DEFINE    PONO01        ZPONO
BX   C     *LIKE         DEFINE    EINO03        PONN01
BX   C     *LIKE         DEFINE    IVNO55        WKIVNO55
BX   C     *LIKE         DEFINE    WMNO05        WMN01
      *
      *------------------------------------------------------------------------*
      *  SECTION 1      PROCESS PURCHASE ORDER ENTRY
      *
      * STEP 1.  INITIALIZE FIELDS
      * STEP 2.  VENDOR INFORMATION
      * STEP 3.  HEADER INFORMATION
      * STEP 4.  MAILING INFORMATION
      * STEP 5.  SHIPPING INFORMATION
      * STEP 6.  LINE ITEM INFORMATION
      * STEP 7.  LINE ITEM QTY STATUS
      * STEP 8.  LINE ITEM PRICES
      * STEP 9.  ORDER COMPLETION SCREEN
      * STEP 10. PRINT RECEIVING REPORT
      *------------------------------------------------------------------------*
      * STEP 1. * INITIALIZE FIELDS
      *------------------------------------------------------------------------*
B3    *
B3    * Check whether using Intellichief is used.
B3   C                   MOVE      '0'           ERR01             1
B3   C                   MOVE      *BLANKS       TABCOD
B3   C                   MOVEL     'IMAG'        TABCOD
B3   C                   MOVE      *BLANKS       TABENT
B3   C                   MOVEL     'ICSYS'       TABENT
B3   C     TABKEY        CHAIN     TBFMTBL                            40
B3   C     *IN40         IFEQ      *OFF
B3   C                   MOVEL     TBNO03        ICSYS             1
B3   C                   ELSE
B3   C                   MOVE      'N'           ICSYS
B3   C                   ENDIF
B3   C     ICSYS         IFEQ      'Y'
B3   C                   CALL      'OPC9805'
B3   C                   PARM                    ERR01             1
B3   C                   ENDIF
B3   C                   if        err01 = '1' and
B3   C                             isWebFaced() = *on
B3   C                   eval      err01 = '0'
B3   C                   endif
B3   C     ICSYS         IFEQ      'Y'
B3   C     ERR01         ANDEQ     '0'
B3   C                   MOVE      *ON           *IN54
B3   C                   ELSE
B3   C                   MOVE      *OFF          *IN54
B3   C                   ENDIF
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
     C     CODE          IFEQ      'M'                                          FROM MAINTENANCE
     C                   EXSR      DELET                                         DELETE ORDER
     C     CODE          CABEQ     'M'           ENDPGM
     C                   END
      *
     C     CODE          IFEQ      'B'                                          FROM BO/LOW STCK
     C                   EXSR      DELET                                         DELETE ORDER
     C     CODE          CABEQ     'B'           ENDPGM
     C                   END
      *
      * INITIALIZE FAX FIELDS
     C                   MOVE      ' '           FAXDEL            1            FAX DELETE FLAG
     C                   Z-ADD     *ZERO         SAVPO                          SAVE P/O#
     C                   MOVE      *OFF          *IN85                          WARNING MSG
     C                   MOVE      *OFF          *IN86                          WARNING MSG
CD   C                   MOVE      '1'           *IN28                          DFLT SFLDROP
      *
      * P.O. HEADER
     C     PRMPT         TAG
      *
      * IF RETURNED BY CMD-03 RELEASE (POFTOH) P/O HDR.
     C     *IN03         IFEQ      '1'
     C     RELFG1        IFEQ      'Y'
     C                   EXCEPT    XDUM1                                        UNLOCK HDR
     C                   END
     C     RELFG2        IFEQ      'Y'
     C                   EXCEPT    XDUM2                                        UNLOCK HDR
     C                   END
     C     RELFG3        IFEQ      'Y'
     C                   EXCEPT    XDUM3                                        UNLOCK HDR
     C                   END
     C                   END
      *
     C                   EXFMT     POF0130L
CD   C                   MOVE      MODE          *IN28
      *
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           PRMPT
     C                   END
      *
     C     *IN03         CABEQ     '1'           ENDPGM                         CMD 03 RETURN
      *
B2    * F15=My transactions
B2   c                   if        *in15 = *on
B2   c                   eval      pActCd = 'HD'
B2   c                   eval      pData = *blanks
B2   c                   eval      %subst(pData : 1 : 3) = 'PO '
B2   c                   call      'SHR0306'     pl0306
B2   c                   if        pData <> *blanks
B2   c                   movel     pData         pono01
B2   C                   write     pof0130l
B2   c                   endif
B2   c                   endif
B2    *
     C                   MOVE      ' '           RELFG1            1            REL REC FLAG
     C     TRYA          TAG                                                    RETRY
     C     PONO01        CHAIN     POFTOH                             4088
     C     *IN40         CABEQ     '1'           PRMPT                    90    ERROR MESSAGE
      * CHECK FOR RECORD LOCK
     C     *IN88         IFEQ      '1'                                          RECORD LOCK
     C                   MOVE      'Y'           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C     DSPF2         CABEQ     'Y'           TRYA
     C                   GOTO      PRMPT
     C                   END
      * DETERMINE IF WM INSTALLED AT BRANCH
     C                   MOVE      'N'           WHMBR
     C     WHMYES        IFEQ      'Y'
     C     PONO02        ANDNE     *ZERO
     C                   CLEAR                   WMCOBR
     C                   CLEAR                   WHMBR
     C     PONO02        CHAIN     ARFMBCH                            40
     C                   Z-ADD     ARNO15        WMCO#
     C                   Z-ADD     PONO02        WMBR#
BY   C                   Z-ADD     *ZEROS        WMCO#
     C                   CALL      'WIC0116'
     C                   PARM                    WMCOBR
     C                   PARM                    WHMBR             1
     C                   ENDIF
      *
      * IF WM BRANCH, CREATE TEMP DATA QUEUE TO GET DATA FROM WM SYSTEM
     C     WHMBR         IFEQ      'Y'
     C     DQFLG         ANDNE     'Y'
     C                   TIME                    TIME#             6 0
     C                   MOVE      TIME#         TIMEA             6
     C     'DQ'          CAT(P)    TIMEA:0       DQNAME           10
     C                   CALL      'WIC9900'
     C                   PARM                    DQNAME
     C                   PARM      #BIPGM        DQLIB            10
     C                   PARM      'C'           DQACT             1
     C                   MOVE      'Y'           DQFLG             1
     C                   ENDIF
      *
      * If WM branch, check whether open ASN in WM system or not.
      * If exists, send message that void is not allowed.
      * If no response from data queue, send message.
      *
     C     WHMBR         IFEQ      'Y'
     C     POCD01        ANDNE     'D'                                          Direct
     C     POCD01        ANDNE     'O'                                          Overhead
     C     POCD01        ANDNE     'F'                                          Blanket
     C                   EXSR      CHKASN
     C     HDSTAT        IFEQ      '*'
     C     HDSTAT        OREQ      '0'
     C     HDSTAT        OREQ      'E'
      * ERROR - PO NOT AVAILABLE FOR VOID - OPEN ASN
     C     HDSTAT        CABEQ     '*'           PRMPT                    94
      * ERROR - NO COMMUNICATION WITH WM
     C     HDSTAT        CABEQ     '0'           PRMPT                    95
      * ERROR - UNEXPECTED ERROR
     C     HDSTAT        CABEQ     'E'           PRMPT                    97
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      'Y'           RELFG1                         REL REC FLAG
      *
     C                   EXSR      INITSR
CC    * F6=Fax/Email History
CC   C                   Eval      Appcod = 'PO01'
CC   C                   MOVE      PONO01        DocNo
CC   C                   If        *in06 = *On
CC   C                   Eval      pMode = 'Y'
CC   C                   Call      'OPR0605'     pl0307
CC   C                   Eval      pMode = *Blank
CC   C                   Goto      PRMPT
CC   C                   EndIf
CC   C                   Call      'OPR0605'     pl0307
      *
     C     *IN88         DOUEQ     '0'
     C     PONO01        CHAIN     POFTOH                             4088
     C     *IN88         IFEQ      '1'                                          RECORD LOCK
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         CABEQ     '1'           PRMPT                    90    ERROR MESSAGE
     C     POCD20        CABEQ     'C'           PRMPT                    91    ERROR MESSAGE
      *
      *   CHECK USERID SECURITY AUTHORIZATION
     C     PXKEY         SETLL     OPFMSEC                                40     ALL BR'S OK
     C     *IN40         IFEQ      '0'
      *
     C     POCD01        IFNE      'D'
     C                   MOVE      PONO03        OPNO03                         ENTRD BR#
     C     PBKEY         SETLL     OPFMSEC                                40     THIS BR# OK
     C     *IN40         CABEQ     '0'           PRMPT                    93    ERROR MESSAGE
     C                   END
      *
     C     POCD01        IFNE      'D'
     C                   MOVE      PONO02        OPNO03                         SHIP TO BR#
     C     PBKEY         SETLL     OPFMSEC                                40     THIS BR# OK
     C     *IN40         CABEQ     '0'           PRMPT                    93    ERROR MESSAGE
     C                   END
     C                   END
      *
      * CHECK TO SEE IF P/O HAS ANY PENDING FAXES TO BE SENT
      *
     C     FAXDEL        IFNE      'Y'                                          FAX DELETE FLAG
     C     PONO01        ORNE      SAVPO                                        DIFFRENT P/O
     C                   MOVE      'Y'           FAXDEL
     C                   MOVE      'PO01'        APPCOD                         APPLICAT CODE
     C                   MOVEL     PONO01        PONBR                          P/O NUMBER
     C                   Z-ADD     PONO01        SAVPO                          SAVE P/O#
   CCC*                  Z-ADD     0             FAXCNT                         FAX COUNT
      *
      * CHECK IF ANY FAXES HAVE BEEN SENT TO DISPLAY WARNING MESSAGE
     C     FAXKEY        SETLL     OPFTFXI
     C     *IN42         DOUEQ     *ON
     C     FAXKEY        READE     OPFTFXI                                42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      OPMO01        DLYMTH                         DELAY MONTH
     C                   MOVE      OPDY01        DLYDAY                         DELAY DAY
     C                   MOVE      OPYR01        DLYYR                          DELAY YEAR
     C                   MOVE      DLYDAT        DATDLY                         DELAY DATE
     C                   MOVE      OPTM01        MILTIM            6 0          MILITARY TIME
     C                   TIME                    TIME                           SYSTEM TIME
      *
      * IF THE DELAY TIME FOR THE FAX TO BE SENT IS GREATER THAN OR
      * EQUAL TO THE CURRENT SYSTEM TIME, THIS MEANS THE FAX HAS NOT
      * BEEN SENT AND THEREFORE DISPLAY WARNING MESSAGE TO LET THE USER
      * KNOW THAT ALL FAXES THAT HAVE NOT BEEN SENT WILL BE DELETED
      *
     C     DATDLY        IFGE      UDATE                                        >= CURRENT DATE
     C     MILTIM        ANDGE     TIME                                         >= CURRENT TIME
     C     DATDLY        ORGT      UDATE                                        > CURRENT DATE
     C                   MOVE      *ON           *IN85                          WARN MSG
     C                   MOVE      DLYDAT        DELAY                          DELAY DATE
      *
      * CONVERT MILITARY TIME TO REGULAR TIME
     C     MILTIM        IFGT      120000
     C     MILTIM        SUB       120000        REGTIM
     C                   MOVE      'p.m.'        DAYNIT            4            NIGHT TIME
     C                   ELSE
     C                   Z-ADD     MILTIM        REGTIM                         REGULAR TIME
     C                   MOVE      'a.m.'        DAYNIT                         DAY TIME
     C                   ENDIF
     C                   ELSE
      *
      * ELSE THE P/O FAX HAS ALREADY BEEN SENT AND WE MUST WARN THE
      * USER THAT VENDOR CONTACT MAY BE NEEDED.
      *
     C                   MOVE      *ON           *IN86                          WARN MSG
   CCC*                  ADD       1             FAXCNT                         FAX COUNT
     C                   GOTO      PRMPT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C     PONO01        SETLL     POFTRH                                 41    RECEIPTS ?
     C     *IN41         CABEQ     '1'           PRMPT                    92    ERROR MESSAGE
      *
     C     POCD10        IFEQ      'O'                                          OUR TRUCK
     C                   MOVE      'X'           OURTRK
     C                   END
     C     POCD10        IFEQ      'S'                                          SHIPPED
     C                   MOVE      'X'           SHIPED
     C                   END
      *
      * P.O. HEADER
     C     POCD07        IFEQ      'Y'                                          RECEIVING
     C                   MOVEA     '1'           *IN(56)                        NOTES DSPLAY
     C                   END                                                    CMD KEYS
      *
     C     POCD18        IFEQ      'Y'                                          A/P NOTES
     C                   MOVEA     '1'           *IN(57)                        DISPLAY CMD
     C                   END                                                    KEYS
      *
      * REMOVE PO# FROM C/O LINE ITEM
      *
     C     POCD42        IFEQ      'Y'
     C     *IN88         DOUEQ     *OFF
     C     PONO01        CHAIN     OEFTOAL                            4088
     C                   ENDDO
     C     *IN40         IFEQ      *OFF
     C                   CLEAR                   OAPN01
     C                   CLEAR                   OAPN05
     C                   EXCEPT    TOAL
     C                   ENDIF
     C                   ENDIF
      *
      * VENDOR MASTER
     C                   MOVE      ' '           RELFG2            1            REL REC FLAG
     C     *IN88         DOUEQ     '0'
     C     APNO01        CHAIN     APFMVEN                            4088      VENDOR MASTER
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         IFEQ      '0'
     C                   MOVE      'Y'           RELFG2                         REL REC FLAG
     C                   END
     C     APCD28        IFEQ      'Y'                                          VENDOR SETUP ?
     C                   MOVEA     '1'           *IN(50)                        UNAPPROVED VEND
     C                   ELSE
     C                   MOVE      *OFF          *IN50
     C                   END
      *
      * MAILING ADDRESS
     C                   MOVE      ' '           RELFG3                         REL REC FLAG
     C     POCD06        IFNE      'Y'                                          NO OVRRIDE
     C                   MOVE      '1'           APCD08                         TYPE CODE
     C     MAILKY        CHAIN     APFMVAD                            40
     C     *IN40         IFEQ      '0'
     C                   MOVE      AVMAIL        MMAIL
     C                   ELSE
     C                   MOVE      APNM01        NAME
     C                   MOVE      UVMAIL        MMAIL
     C                   END
     C                   ELSE
     C                   MOVE      'M'           POCD02                         MAIL TO ADDRESS
     C                   MOVE      ' '           RELFG3            1            REL REC FLAG
     C     *IN88         DOUEQ     '0'
     C     ADRSOV        CHAIN     POFTOA                             4088
     C     *IN88         IFEQ      '1'                                          RECORD LOCK
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         IFEQ      '0'
     C                   MOVE      'Y'           RELFG3                         REL REC FLAG
     C                   END
     C                   MOVE      POOVAD        MMAIL
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
     C                   MOVE      ' '           RELFG3                         REL REC FLAG
     C     *IN88         DOUEQ     '0'
     C     ADRSOV        CHAIN     POFTOA                             4088
     C     *IN88         IFEQ      '1'                                          RECORD LOCK
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         IFEQ      '0'
     C                   MOVE      'Y'           RELFG3                         REL REC FLAG
     C                   END
     C                   MOVE      POOVAD        SSHIP                          SHIPPING ADDRES
     C                   END
      *------------------------------------------------------------------------*
      * STEP 2. * VENDOR INFORMATION
      *------------------------------------------------------------------------*
     C     VNDTAG        TAG
     C     *IN50         IFEQ      '1'                                          UNAPPRVED VNDR
     C                   EXFMT     POF0130A                                     INFORMATION
      *
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           VNDTAG
     C                   END
      *
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C                   Z-ADD     0             PONO01
     C                   MOVE      ' '           FAXDEL            1            FAX DELETE FLAG
     C                   Z-ADD     *ZERO         SAVPO                          SAVE P/O#
     C                   MOVE      *OFF          *IN85                          WARNING MSG
     C                   MOVE      *OFF          *IN86                          WARNING MSG
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C                   END
      *------------------------------------------------------------------------*
      * STEP 3. * HEADER INFORMATION
      *------------------------------------------------------------------------*
     C     HDRTAG        TAG
     C                   EXFMT     POF0130B
      *
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           HDRTAG
     C                   END
      *
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C                   Z-ADD     0             PONO01
     C                   MOVE      ' '           FAXDEL            1            FAX DELETE FLAG
     C                   Z-ADD     *ZERO         SAVPO                          SAVE P/O#
     C                   MOVE      *OFF          *IN85                          WARNING MSG
     C                   MOVE      *OFF          *IN86                          WARNING MSG
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN50         IFEQ      '1'                                          UNAPPROVED VEND
     C     *IN12         CABEQ     '1'           VNDTAG                         CMD 12 PREVIOUS
     C                   END
B3    * F23 = Image
B3   C     *IN23         IFEQ      *ON
B3   C     ICSYS         IFEQ      'Y'
CF    * Determine if licensed to this product...
CF    * The following license key checking logic may not be altered, bypassed or removed.
CF    * See Legal Document in WRKMINKEY command for more information.
CF   C                   if        LicToDII
B3   C                   CLEAR                   QSEARCH
B3   C                   MOVEL     'QSEARCH'     QSEARCH
B3   C                   CALL      'OPC9832 '
B3   C                   PARM                    QSEARCH          10
CF    * Display error message if not licensed to DII (IntelliChief)
CF   C                   else
CF   C                   call      'MNR1300'     pl1300
CF   C                   endif
B3   C                   ENDIF
B3   C                   GOTO      HDRTAG
B3   C                   ENDIF
     C     POCD11        CABNE     'Y'           SHPTAG                         MAIL CONFRM COPY
      *------------------------------------------------------------------------*
      * STEP 4. * MAILING INFORMATION
      *------------------------------------------------------------------------*
     C     MALTAG        TAG
     C                   EXFMT     POF0130C                                     MAILING INFO
      *
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           MALTAG
     C                   END
      *
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C                   Z-ADD     0             PONO01
     C                   MOVE      ' '           FAXDEL            1            FAX DELETE FLAG
     C                   Z-ADD     *ZERO         SAVPO                          SAVE P/O#
     C                   MOVE      *OFF          *IN85                          WARNING MSG
     C                   MOVE      *OFF          *IN86                          WARNING MSG
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         CABEQ     '1'           HDRTAG                         CMD 12 PREVIOUS
      *------------------------------------------------------------------------*
      * STEP 5. * SHIPPING INFORMATION
      *------------------------------------------------------------------------*
     C     SHPTAG        TAG
     C     POCD01        CABEQ     'W'           LINTAG                         3RD PARTY PO
     C     PONO02        CABNE     0             LINTAG                         SHIP TO BRANCH
     C                   EXFMT     POF0130D                                     SHIP TO INFO
      *
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           SHPTAG
     C                   END
      *
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C                   Z-ADD     0             PONO01
     C                   MOVE      ' '           FAXDEL            1            FAX DELETE FLAG
     C                   Z-ADD     *ZERO         SAVPO                          SAVE P/O#
     C                   MOVE      *OFF          *IN85                          WARNING MSG
     C                   MOVE      *OFF          *IN86                          WARNING MSG
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         IFEQ      '1'                                          CMD 12 PREVIOUS
     C     POCD11        CABEQ     'Y'           MALTAG                         MAIL CONFRM COPY
     C     POCD11        CABNE     'Y'           HDRTAG                         MAIL CONFRM COPY
     C                   END
      *------------------------------------------------------------------------*
      * STEP 6. * LINE ITEM ENTRY
      *------------------------------------------------------------------------*
     C     LINTAG        TAG
     C                   EXSR      LINSR                                        LINE ITEM ENTRY
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C                   Z-ADD     0             PONO01
     C                   MOVE      ' '           FAXDEL            1            FAX DELETE FLAG
     C                   Z-ADD     *ZERO         SAVPO                          SAVE P/O#
     C                   MOVE      *OFF          *IN85                          WARNING MSG
     C                   MOVE      *OFF          *IN86                          WARNING MSG
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         IFEQ      '1'                                          CMD 12 PREVIOUS
     C     POCD01        CABEQ     'W'           HDRTAG                         3RD PARTY PO
     C     PONO02        CABEQ     0             SHPTAG                         SHIP TO BRANCH
     C     POCD11        CABEQ     'Y'           MALTAG                         MAIL CONFRM COPY
     C     POCD11        CABNE     'Y'           HDRTAG                         MAIL CONFRM COPY
     C                   END
      *------------------------------------------------------------------------*
      * STEP 7. * QUANTITY STATUS
      *------------------------------------------------------------------------*
     C     QTYTAG        TAG
     C                   EXSR      QTYSR                                        QTY STATUS
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C                   Z-ADD     0             PONO01
     C                   MOVE      ' '           FAXDEL            1            FAX DELETE FLAG
     C                   Z-ADD     *ZERO         SAVPO                          SAVE P/O#
     C                   MOVE      *OFF          *IN85                          WARNING MSG
     C                   MOVE      *OFF          *IN86                          WARNING MSG
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         CABEQ     '1'           LINTAG                         CMD 12 PREVIOUS
      *------------------------------------------------------------------------*
      * STEP 8. * LINE ITEM PRICES
      *------------------------------------------------------------------------*
     C     PRCTAG        TAG
     C                   EXSR      PRCSR
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C                   Z-ADD     0             PONO01
     C                   MOVE      ' '           FAXDEL            1            FAX DELETE FLAG
     C                   Z-ADD     *ZERO         SAVPO                          SAVE P/O#
     C                   MOVE      *OFF          *IN85                          WARNING MSG
     C                   MOVE      *OFF          *IN86                          WARNING MSG
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         CABEQ     '1'           QTYTAG                         CMD 12 PREVIOUS
      *------------------------------------------------------------------------*
      * STEP 9. * ORDER COMPLETION SCREEN
      *------------------------------------------------------------------------*
     C                   EXSR      COMSR
     C     *IN03         IFEQ      '1'                                          CMD 03 RETURN
     C                   Z-ADD     0             PONO01
     C     *IN03         CABEQ     '1'           PRMPT                          CMD 03 RETURN
     C                   END
     C     *IN12         CABEQ     '1'           PRCTAG                         CMD 12 PREVIOUS
   ¢A *
   ¢AC*    EDIPO         IFEQ      'Y'
   ¢AC*                  MOVE      'V'           YESNO                          VOID THIS
   ¢AC*                  MOVE      ' '           REPRNT
   ¢AC*                  Z-ADD     0             RVPRNT                         JUST VOID
   ¢AC*                  Z-ADD     PONO01        PONO                           P/O TO VOID
   ¢AC*                  MOVEL     TRPNID        @TPID
   ¢AC*                  MOVEL     APNO01        @ACCT#
   ¢AC*                  MOVEL     DSPO          @TRANS
   ¢AC*                  MOVE      *BLANKS       @ERRCD
   ¢AC*                  CALL      'EIR1200'
   ¢AC*                  PARM      'S850'        @DOCID            4
   ¢AC*                  PARM                    @TPID            15
   ¢AC*                  PARM                    @ACCT#            6
   ¢AC*                  PARM                    @TRANS           15
   ¢AC*                  PARM                    @ERRCD            3
   ¢AC*                  END
      *
      * BEGIN DELETING ALL SPOOL FILES RELATED TO THE PURCHASE ORDER
      *
     C     FAXKEY        SETLL     OPFTFXI
     C     *IN42         DOUEQ     *ON
     C                   MOVE      *IN96         SVIN96            1            SAVE *IN96
     C                   MOVE      *BLANKS       DSPF1
     C     *IN96         DOUEQ     *OFF
     C     FAXKEY        READE     OPFTFXI                              9642
     C     *IN96         CASEQ     *ON           UNLOCK                         RECORD LOCK
     C                   ENDCS
     C                   ENDDO
     C                   MOVE      SVIN96        *IN96                          RESTORE *IN96
     C     *IN42         IFEQ      *OFF
     C                   MOVE      OPMO01        DLYMTH                         DELAY MONTH
     C                   MOVE      OPDY01        DLYDAY                         DELAY DAY
     C                   MOVE      OPYR01        DLYYR                          DELAY YEAR
     C                   MOVE      DLYDAT        DATDLY            6 0          DELAY DATE
     C                   MOVE      OPTM01        MILTIM                         REGULAR TIME
     C                   TIME                    TIME              6 0          SYSTEM TIME
      *
      * IF THE DELAY TIME FOR THE FAX TO BE SENT IS GREATER THAN
      * THE CURRENT SYSTEM TIME, THIS MEANS THE FAX HAS NOT BEEN
      * SENT AND THEREFORE MUST GET DELETED
      *
     C     DATDLY        IFGE      UDATE                                        CURRENT DATE
     C     MILTIM        ANDGE     TIME                                         CURRENT TIME
     C     DATDLY        ORGT      UDATE                                        > CURRENT DATE
     C                   MOVEL     OPID02        USRNAM                         USER ID
     C                   MOVEL     OPNM05        SPLNAM                         SPOOL FILE NAME
     C                   MOVE      OPNO09        SPLF#                          SPOOL FILE #
     C                   MOVEL     OPNM04        JOBNAM                         JOB NAME
     C                   MOVE      OPNO08        JOB#                           JOB NUMBER
     C                   DELETE    OPFTFXI
     C                   CALL      'OPC0700'     PL0700                         DELET SPLF PGM
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   EXSR      DELET
      *------------------------------------------------------------------------*
      * Submit Direct Order Audit...
      *------------------------------------------------------------------------*
     C     POCD01        IFEQ      'D'
     C                   MOVE      PONO01        ALPHPO            7
     C                   MOVEA     ALPHPO        DOA(75)
     C                   MOVEA     DOA           CMD             140
     C                   Z-ADD     140           LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM                    LEN
     C                   ENDIF
     C                   Z-ADD     0             PONO01
     C                   MOVE      ' '           FAXDEL            1            FAX DELETE FLAG
     C                   Z-ADD     *ZERO         SAVPO                          SAVE P/O#
     C                   MOVE      *OFF          *IN85                          WARNING MSG
     C                   MOVE      *OFF          *IN86                          WARNING MSG
     C     CODE          CABNE     'M'           PRMPT                          FROM MAINTENANCE
      *
      * END OF JOB
     C     ENDPGM        TAG
      *
      * IF WM BRANCH, DELETE TEMP DATA QUEUE CREATED TO
      * GET DATA FROM WM SYSTEM
     C     WHMBR         IFEQ      'Y'
     C     DQFLG         ANDEQ     'Y'
     C                   CALL      'WIC9900'
     C                   PARM                    DQNAME
     C                   PARM                    DQLIB
     C                   PARM      'D'           DQACT
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *------------------------------------------------------------------------*
      *  SUBROUTINE    LINE ITEM ENTRY                                         *
      *------------------------------------------------------------------------*
     C     LINSR         BEGSR
      * CLEAR & LOAD SUBFILE
     C                   Z-ADD     1             RRN               3 0
     C                   MOVEA     '1'           *IN(73)                        CLEAR
     C                   WRITE     POC0130E                                     ENTRY SUBFILE
     C                   MOVEA     '0'           *IN(73)                        SETOF INITIALIZE
     C                   Z-ADD     1             X
      *
     C     X             DOUGT     400
     C     X             OCCUR     SAVDS
     C     DDES          IFEQ      *BLANKS
     C     DCOM          CABEQ     'C'           ENDLP
     C     DDES          CABEQ     *BLANKS       DSPLAY
     C                   ENDIF
     C                   Z-ADD     DKEY          KEY                            LINE NUMBER
     C                   Z-ADD     DQTY          QTY                            QTY ORDERED
     C                   MOVEL     DITM          ITM                            ITEM NUMBER
     C                   MOVE      DUOM          UOM                            ORDERED UOM
     C                   MOVEL     DDES          DES                            DESCRIPTION
     C                   MOVEL     ITM           PDDS
     C                   MOVE      DES           PDDS
     C                   MOVE      DMAN          MAN                            MANUFACTURER #
     C     DTYP          IFEQ      'Y'                                          TAG & HOLD
     C                   MOVE      'T'           BLKTAG                         TAG & HOLD DSPY
     C                   ELSE
     C     DTYP          IFEQ      'D'                                          TAG & HOLD
     C                   MOVE      *ON           *IN21                          PROTECT NONDSP
     C                   ENDIF
     C                   MOVEA     '1'           *IN(80)                        PROTECT NONDSP
     C                   MOVE      ' '           BLKTAG                          SELECT FIELD
     C                   END
     C                   WRITE     POS0130E
     C                   ADD       1             RRN
     C                   MOVE      *OFF          *IN21                          PROTECT NONDSP
     C                   MOVEA     '0'           *IN(80)
     C     ENDLP         TAG
     C                   ADD       1             X
     C                   END
      *
      * DISPLAY ENTRY SCREEN
     C     DSPLAY        TAG
     C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB & CNTRL
   CBC*    RRN           IFLE      1                                            EMPTY SFL
CB   C     RRN           IFLE      0                                            EMPTY SFL
     C                   MOVE      *OFF          *IN75
     C                   ENDIF
CH   C     RRN           IFLE      1                                            EMPTY SFL
CH   C     REEDC         Andne     'Y'                                          EMPTY SFL
CH   C                   MOVE      *OFF          *IN75
CH   C                   ENDIF
     C                   WRITE     POF0130E                                     CMD KEY FORMAT
     C                   EXFMT     POC0130E                                     ENTRY CNTRL FRMAT
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           DSPLAY
     C                   END
      *
      * CMD 03 RETURN
     C     *IN03         CABEQ     '1'           LINEND                         CMD 03 RETURN
      *
      * CMD 12 PREVIOUS
     C     *IN12         CABEQ     '1'           LINEND                         CMD 12-PREVIOUS
      *
      * READ SUBFILE
     C                   MOVE      ' '           REEDC             1            DSPLY TAG & HLD
     C     *IN40         DOUEQ     '1'
     C     RRN           IFLE      1                                            EMPTY SFL
     C                   MOVE      *ON           *IN40
     C                   ELSE
CH   C                   Z-ADD     RRN           SAVERN            3 0
     C                   READC     POS0130E                               40
     C     SEL           IFNE      ' '
     C                   MOVE      'Y'           REEDC                          DSPLY TAG & HLD
     C                   EXSR      TAGHLD
     C                   MOVE      ' '           SEL
     C                   UPDATE    POS0130E
CH   C                   Z-ADD     SAVERN        RRN
     C                   END
     C                   ENDIF
     C                   END
     C     REEDC         CABEQ     'Y'           DSPLAY
      *
     C     LINEND        TAG
     C                   MOVEA     '1'           *IN(77)                        DELETE S/F
     C                   WRITE     POC0130E
     C                   MOVEA     '0'           *IN(77)                        DELETE S/F
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    QUANTITY STATUS                                         *
      *------------------------------------------------------------------------*
     C     QTYSR         BEGSR
      * CLEAR & LOAD SUBFILE
     C                   Z-ADD     1             RRN               3 0
     C                   MOVEA     '1'           *IN(73)                        CLEAR
     C                   WRITE     POC0130K                                     QTY STATUS S/F
     C                   WRITE     POC0130M                                     $$$ STATUS S/F
     C                   MOVEA     '0'           *IN(73)                        SETOF INITIALIZE
     C                   Z-ADD     1             X
     C     X             DOUGT     400
     C     X             OCCUR     SAVDS
     C     DDES          IFEQ      *BLANKS
     C     DCOM          CABEQ     'C'           ENDLP2
     C     DDES          CABEQ     *BLANKS       DSPQTY
     C                   ENDIF
     C                   Z-ADD     DQTY          QTY                            QTY ORDERED
     C                   Z-ADD     DQYR          REC                            QTY RECEIVED
     C                   MOVEL     DITM          ITM                            ITEM NUMBER
     C                   MOVEL     DDES          DES                            DESCRIPTION
     C                   MOVEL     ITM           PDDS
     C                   MOVE      DES           PDDS
     C     QTY           SUB       REC           DIF                            QTY REMAINING
     C                   Z-ADD     DCST          QTY$                           THESE ARE LOT
     C                   Z-ADD     DLITD         REC$                           DOLLARS ON 350N
     C     QTY$          SUB       REC$          DIF$                           $$$ REMAINING
     C     DCOM          IFEQ      'C'                                          COMMENTS ?
     C                   MOVEA     '1'           *IN(51)                        NON DISPLAY
     C     DTYP          IFEQ      'D'
     C                   MOVE      *ON           *IN35                          NON DISPLAY
     C                   ENDIF
     C                   END
     C     *IN52         IFEQ      *ON
     C     DTYP          ANDNE     'D'
     C                   MOVE      *ON           *IN51                          NON DISPLAY
     C                   ENDIF
     C                   WRITE     POS0130K
     C                   WRITE     POS0130M
     C                   MOVE      *OFF          *IN35                          NON DISPLAY
     C                   MOVEA     '0'           *IN(51)                        NON DISPLAY
     C                   ADD       1             RRN
     C     ENDLP2        TAG
     C                   ADD       1             X
     C                   END
      *
      * DISPLAY ENTRY SCREEN
     C     DSPQTY        TAG
     C                   MOVEA     '11100'       *IN(74)                        DSPLY SUB & CNTRL
     C     RRN           IFLE      1                                            EMPTY SFL
     C                   MOVE      *OFF          *IN74                          SFLEND
     C                   MOVE      *OFF          *IN75
     C                   ENDIF
     C     LOTFLG        IFEQ      *OFF
     C                   WRITE     POF0130K                                     CMD KEY FORMAT
     C                   EXFMT     POC0130K                                     ENTRY CNTRL FRMAT
     C                   ELSE
     C                   WRITE     POF0130M                                     CMD KEY FORMAT
     C                   EXFMT     POC0130M                                     ENTRY CNTRL FRMAT
     C                   ENDIF
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           DSPQTY
     C                   END
      *
      * LOT QTYS/DOLLARS TOGGLE
      *
     C     *IN15         IFEQ      *ON
     C                   SELECT
     C     LOTFLG        WHENEQ    *OFF
     C                   MOVE      *ON           LOTFLG
     C     LOTFLG        WHENEQ    *ON
     C                   MOVE      *OFF          LOTFLG
     C                   ENDSL
     C     *IN15         CABEQ     *ON           DSPQTY
     C                   ENDIF
      *
     C                   MOVEA     '1'           *IN(77)                        DELETE S/F
     C                   WRITE     POC0130K
     C                   WRITE     POC0130M
     C                   MOVEA     '0'           *IN(77)                        DELETE S/F
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    TAG & HOLD                                              *
      *------------------------------------------------------------------------*
     C     TAGHLD        BEGSR
     C                   MOVEA     '1'           *IN(70)                        INITIALIZE
     C                   WRITE     POC0130F                                     TAG & HOLD
     C                   MOVEA     '0'           *IN(70)                        SETOF INITIALIZE
      *
     C                   Z-ADD     1             Z                 3 0          ARRAY INDEX
     C                   Z-ADD     1             RNO               3 0          S/F INDEX
      *
     C     KEY           IFNE      0                                            TAG & HOLD KEY
     C     *IN40         DOUEQ     '0'
     C     KEY           LOOKUP    KY(Z)                                  40    TAG & HOLD
     C     *IN40         IFEQ      '1'                                          EXIST ????
     C                   MOVEA     TH(Z)         TAGH                           TAG & HOLD
     C                   WRITE     POS0130F                                     DATA
     C                   ADD       1             RNO                            S/F INDEX
     C                   ADD       1             Z                              D/S INDEX
     C                   END
     C                   END
     C                   END
      *
      * DISPLAY TAG & HOLD
     C     TAGDSP        TAG
     C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB & CNTRL
     C                   EXFMT     POC0130F                                     TAG & HOLD CONTRL
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
      *
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           TAGDSP
     C                   END
      *
     C     TAGEND        ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    LINE ITEM PRICES                                        *
      *------------------------------------------------------------------------*
     C     PRCSR         BEGSR
      * CLEAR SUBFILE
     C                   Z-ADD     0             RRN               3 0
     C                   MOVEA     '1'           *IN(73)                        CLEAR
     C                   WRITE     POC0130G                                     PRICING SUBFILE
     C                   MOVEA     '0'           *IN(73)                        SETOF CLEAR
     C                   Z-ADD     1             X
     C     X             DOUGT     400
     C     X             OCCUR     SAVDS
     C     DDES          IFEQ      *BLANKS
     C     DCOM          CABEQ     'C'           ENDLP3
     C     DDES          CABEQ     *BLANKS       DSPPRC
     C                   ENDIF
     C                   MOVEL     DDES          DES                            DESCRIPTION
     C                   MOVEL     DES           PDDS35                         DESCRIPTION
     C                   Z-ADD     DQTY          QTY                            QTY ORDERED
     C                   MOVE      DUMP          UMP                            PRICING UOM
     C                   MOVE      DUOM          UOM                            ORDERING UOM
     C                   Z-ADD     DLST          LST                            LIST
     C                   MOVE      DDSC          DSC                            DISCOUNT
     C                   Z-ADD     DCST          CST                            COST
     C     DDOV          IFEQ      'Y'                                          DISC OVERRIDE
     C                   MOVEA     '1'           *IN(81)                         HIGHLITE DISC
     C                   END
     C     DCOV          IFEQ      'Y'                                          COST OVERRIDE
     C                   MOVEA     '1'           *IN(82)                         HIGHLITE COST
     C                   END
     C                   ADD       1             RRN
     C     DCOM          IFEQ      'C'                                          COMMENTS ?
     C                   MOVEA     '1'           *IN(51)                        NON DISPLAY
     C                   END
     C     DTYP          IFEQ      'D'                                          LOT DETAIL
     C                   MOVE      *ON           *IN35                          NON DISPLAY
     C                   ENDIF
CN    * Retrive price sheet information
CN   C                   EVAL      *IN60 = *OFF
CN   C                   CLEAR                   PSNME
CN   C                   CLEAR                   PSSTS
CN   C                   CLEAR                   PSTYPE
CN   C     POQ1KY        CHAIN(N)  POQTOLA01
CN   C                   IF        %FOUND(POQTOLA01)
CN   C                   EVAL      PSNME = PRNO01
CN   C                   EVAL      PSSTS = PRCD21
CN   C                   EVAL      PSTYPE = PRCD77
CN   C                   ELSE
CN   C                   EVAL      *IN60 = *ON
CN   C                   ENDIF
     C                   WRITE     POS0130G
     C                   MOVE      *OFF          *IN35                          NON DISPLAY
     C                   MOVEA     '0'           *IN(51)                        NON DISPLAY
     C                   MOVEA     '00'          *IN(81)                         HIGHLITE
     C     ENDLP3        TAG
     C                   ADD       1             X
     C                   END
      *
      * DISPLAY ENTRY SCREEN
     C     DSPPRC        TAG
     C                   MOVEA     '1100'        *IN(75)                        DSPLY SUB & CNTRL
     C     RRN           IFLT      1                                            EMPTY SFL
     C                   MOVE      *OFF          *IN75
     C                   ENDIF
     C                   WRITE     POF0130G                                     CMD KEY FORMAT
     C                   EXFMT     POC0130G                                     PRICING CNTL RCD
     C                   MOVEA     '0000'        *IN(75)                        SETOF *IND
     C                   MOVE      MODE          *IN28
      *
      * CALL HELP TEXT
     C     *IN25         IFEQ      '1'                                          HELP KEY
     C                   CALL      'HTR0010'                                    DSPLY HELP TEXT
     C                   PARM                    PROG                           PROGRAM NAME
     C                   PARM                    SCREEN                         DISPLAY FORMAT
     C     *IN25         CABEQ     '1'           DSPPRC
     C                   END
      *
     C                   MOVEA     '1'           *IN(77)                        DELETE S/F
     C                   WRITE     POC0130G                                     PRICING S/F
     C                   MOVEA     '0'           *IN(77)                        DELETE S/F
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    ORDER COMPLETION SCREEN                                 *
      *------------------------------------------------------------------------*
     C     COMSR         BEGSR
      * CHECK TO SEE IF EDI INFORMATION SHOULD BE DISPLAYED OR NOT...
     C                   MOVE      'N'           EDIPO             1            EDI P/O?
     C     EDI           IFEQ      'Y'                                          ALLOW EDI ?
     C                   CLEAR                   CUSNBR
     C                   CLEAR                   TRPNID
     C                   CLEAR                   DOCTYP
     C                   CLEAR                   SUBTYP
CK   C                   CLEAR                   EDITYP
     C                   CLEAR                   RCVSTS
     C                   CLEAR                   TRPNID
     C                   CLEAR                   VENBRN
     C                   CLEAR                   VNDCUS
     C                   MOVE      'V'           VNDCUS
     C                   MOVEL     APNO01        CUSNBR
     C                   MOVE      '850'         DOCTYP
     C                   MOVE      PONO03        VENBRN
     C                   MOVEL     *BLANKS       TRPNID
     C                   EXSR      GETTPI
     C     *IN42         IFEQ      '0'                                          NO EDI
     C     SUBTYP        ANDNE     'A'
     C     SUBTYP        ANDNE     'P'
CK   C     EDITYP        ANDNE     'L'                                          not LMBX
     C                   MOVE      'Y'           EDIPO             1            EDI P/O?
     C                   MOVEA     '1'           *IN(58)                        SHOW EDI
     C                   END
BX   C                   MOVE      PONO01        PONN01
   BXC*    PONO01        SETLL     EILADT1                                42    P/O SENT B4?
BX   C     PONN01        SETLL     EILADT1                                42    P/O SENT B4?
     C     *IN42         IFEQ      '0'                                          NO EDI
     C                   MOVE      'N'           EDIPO                          NO EDI
     C                   MOVEA     '0'           *IN(58)                        SHOW EDI
     C                   END
     C                   END
      * DISPLAY ORDER COMPLETION SCREEN
     C     DSPCOM        TAG
     C                   EXFMT     POF0130H                                     COMPLETION SCREEN
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
     C     *IN03         CABEQ     '1'           ENDCOM                         CMD 03 RETURN
     C     *IN12         CABEQ     '1'           ENDCOM                         CMD 12-PREVIOUS
      *
      * NOTES FROM P/O TO RECEIVING
     C     *IN17         IFEQ      '1'                                          RECEIVING NOTES
     C     POCD07        CABNE     'Y'           DSPCOM                         NOTES TO RECEVG
     C                   MOVE      'Y'           DSPF3
     C                   MOVE      '2'           NOTTYP
     C                   CALL      'POR0140'     NOTKEY
     C     *IN17         CABEQ     '1'           DSPCOM
     C                   END
      *
      * NOTES FROM P/O TO A/P
     C     *IN21         IFEQ      '1'                                          A/P NOTES
     C     POCD18        CABNE     'Y'           DSPCOM                         NOTES TO RECEVG
     C                   MOVE      'Y'           DSPF3
     C                   MOVE      '1'           NOTTYP
     C                   CALL      'POR0140'     NOTKEY
     C     *IN21         CABEQ     '1'           DSPCOM
     C                   END
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN57
     C     ENDCOM        ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    INITIALIZE FIELDS                                       *
      *------------------------------------------------------------------------*
     C     INITSR        BEGSR
     C                   MOVE      '1'           *IN28                          DFLT=SFLDROP
     C     *LIKE         DEFINE    IVNO04        ITM
     C     *LIKE         DEFINE    IVDN01        DES
      *
     C                   MOVE      'UIDS'        TABCOD                         USER AUTH
     C                   MOVE      *BLANKS       TABENT
     C                   MOVEL     USRNM         TABENT                         USERID
     C     TABKEY        CHAIN     TBFMTBL                            40        TABLE FILE
     C  N40              MOVEL     TBNO03        SECPRF            7            PROFILE
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
     C                   MOVE      *BLANKS       SNAME                          SHIPPING NAME
     C                   MOVE      *BLANKS       SADD1                          SHIPING ADDRS 1
     C                   MOVE      *BLANKS       SADD2                          SHIPING ADDRS 2
     C                   MOVE      *BLANKS       SADD3                          SHIPING ADDRS 3
     C                   MOVE      *BLANKS       SCITY                          SHIPING CITY
     C                   MOVE      '  '          SSTAT                          SHIPING STATE
     C                   MOVE      *BLANKS       SMAIN                          SHIPING MAIN ZIP
     C                   MOVE      *BLANKS       MNAME                          MAILING NAME
     C                   MOVE      *BLANKS       MADD1                          MAILING ADDRS 1
     C                   MOVE      *BLANKS       MADD2                          MAILING ADDRS 2
     C                   MOVE      *BLANKS       MADD3                          MAILING ADDRS 3
     C                   MOVE      *BLANKS       MCITY                          MAILING CITY
     C                   MOVE      '  '          MSTAT                          MAILING STATE
     C                   MOVE      *BLANKS       MMAIN                          MAILING MAIN ZIP
     C                   MOVE      *BLANKS       PONM03                         OVRRIDE NAME
     C                   MOVE      *BLANKS       POAD01                         OVRRIDE ADDRS 1
     C                   MOVE      *BLANKS       POAD02                         OVRRIDE ADDRS 2
     C                   MOVE      *BLANKS       POAD03                         OVRRIDE ADDRS 3
     C                   MOVE      *BLANKS       POCY01                         OVRRIDE CITY
     C                   MOVE      '  '          POST01                         OVRRIDE STATE
     C                   MOVE      *BLANKS       POZP03                         OVRRIDE MAIN ZIP
     C                   MOVE      *BLANKS       ARNM01                         CUSTOMER NAME
     C                   MOVE      *BLANKS       ARAD04                         CUS SHIP ADDRS1
     C                   MOVE      *BLANKS       ARAD05                         CUS SHIP ADDRS2
     C                   MOVE      *BLANKS       ARAD06                         CUS SHIP ADDRS3
     C                   MOVE      *BLANKS       ARCY02                         CUS SHIP CITY
     C                   MOVE      '  '          ARST02                         CUS SHIP STATE
     C                   MOVE      *BLANKS       ARZP16                         CUS SHIP MAIN ZP
     C                   MOVE      *BLANKS       APNM01                         VENDOR NAME
     C                   MOVE      *BLANKS       APAD04                         VEN MAIL ADDRS1
     C                   MOVE      *BLANKS       APAD05                         VEN MAIL ADDRS2
     C                   MOVE      *BLANKS       APAD06                         VEN MAIL ADDRS3
     C                   MOVE      *BLANKS       APCY02                         VEN MAIL CITY
     C                   MOVE      '  '          APST02                         VEN MAIL STATE
     C                   MOVE      *BLANKS       APZP08                         VEN MAIL MAIN ZP
     C                   MOVE      *BLANKS       APNM01                         VENDOR NAME
     C                   MOVE      *BLANKS       APAD01                         VEN MAIL ADDRS1
     C                   MOVE      *BLANKS       APAD02                         VEN MAIL ADDRS2
     C                   MOVE      *BLANKS       APAD03                         VEN MAIL ADDRS3
     C                   MOVE      *BLANKS       APCY01                         VEN MAIL CITY
     C                   MOVE      '  '          APST01                         VEN MAIL STATE
     C                   MOVE      *BLANKS       APZP07                         VEN MAIL MAIN ZP
     C                   Z-ADD     0             POMO02                         ORDERED DAY
     C                   Z-ADD     0             PODY02                         ORDERED MONTH
     C                   Z-ADD     0             POCC02                         ORDERED CENTURY
     C                   Z-ADD     0             POYR02                         ORDERED YEAR
     C                   Z-ADD     0             ORDDAT                         ORDERED DATE
     C                   Z-ADD     0             POMO03                         ETA DAY
     C                   Z-ADD     0             PODY03                         ETA MONTH
     C                   Z-ADD     0             POCC03                         ETA CENTURY
     C                   Z-ADD     0             POYR03                         ETA YEAR
     C                   Z-ADD     0             ETADAT                         ETA DATE
     C                   Z-ADD     0             POMO04                         SHIPPING DAY
     C                   Z-ADD     0             PODY04                         SHIPPING MONTH
     C                   Z-ADD     0             POCC04                         SHIPPING CENTURY
     C                   Z-ADD     0             POYR04                         SHIPPING YEAR
     C                   Z-ADD     0             SHPDAT                         SHIPPING DATE
     C     *IN88         DOUEQ     '0'
     C     PONO01        CHAIN     POFTOH                             4088
     C     *IN88         IFEQ      '1'                                          RECORD LOCK
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
      *
     C                   Z-ADD     0             ZZ                3 0          TAG & HOLD
     C                   MOVE      ' '           TTYP                           TYPE---TAG&HOLD
     C                   Z-ADD     0             TQTY                           QTY----TAG&HOLD
     C                   Z-ADD     0             TBRA                           BRANCH-TAG&HOLD
     C                   Z-ADD     0             TCUS                           CUSTMR-TAG&HOLD
   BXC*                  Z-ADD     0             TREF                           REFRE#-TAG&HOLD
BX   C                   MOVE      *ZEROS        TREF                           REFRE#-TAG&HOLD
     C                   MOVE      *BLANKS       TCOM                           COMNTS-TAG&HOLD
     C                   Z-ADD     1             X                 3 0
     C     X             DOUGT     400
     C     X             OCCUR     SAVDS
     C                   MOVE      ' '           DSEL                           SELECT
     C                   Z-ADD     0             DQTY                           QUANTITY
     C                   MOVE      *BLANKS       DITM                           ITEM NUMBER
     C                   MOVE      *BLANKS       DMAN                           MANUFACTURER
     C                   MOVE      '   '         DUOM                           UNITS OF MEASURE
     C                   MOVE      *BLANKS       DDES                           DESCRIPTION
     C                   Z-ADD     0             DNO7                           OUR ITEM #
     C                   Z-ADD     0             DKEY                           TAG & HOLD KEY
     C                   Z-ADD     0             DLST                           MANUF LIST
     C                   MOVE      *BLANKS       DDSC                           DISCOUNT
     C                   Z-ADD     0             DCST                           REPLC COST
     C                   MOVE      ' '           DDOV                           DISCOUNT OVRRDE
     C                   MOVE      ' '           DCOV                           COST OVRRIDE
     C                   MOVE      ' '           DTYP                           TAG & HOLD
     C                   MOVE      '   '         DUMP                           PRICING UOM
     C                   Z-ADD     0             DQYR                           RECEIVED QTY
     C                   MOVE      ' '           DCOM                           ITEM TYPE
     C                   Z-ADD     *ZEROS        DLITD                          LOT INV TO DATE
     C                   ADD       1             X
     C                   END
      *
     C                   Z-ADD     0             X
     C     PONO01        SETLL     POFTOL
     C     *IN40         DOUEQ     '1'
     C     *IN88         DOUEQ     '0'
     C     PONO01        READE     POFTOL                               8840
     C     *IN88         IFEQ      '1'                                          RECORD LOCK
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         IFEQ      '0'
     C                   ADD       1             X
     C     X             OCCUR     SAVDS
      *
     C     POCD13        IFEQ      'S'                                          STOCKED ITEM
     C     IVNO07        CHAIN     IVFMSTR                            41        ITEM MASTER
     C                   Z-ADD     IVNO07        DNO7
     C     POCD19        IFEQ      'O'                                          OUR ITEM NUMBER
     C                   MOVEL     IVNO07        DITM
     C                   ELSE
     C                   MOVEL     IVNO04        DITM
     C                   END
     C                   ELSE
     C     POCD13        IFEQ      'N'                                          NON-STOCK ITEM
     C                   CLEAR                   IVNO04
     C                   MOVEL     PODN10        IVNO04
     C     IVNO04        CHAIN     IVFTNSK                            41
     C                   MOVEL     PODN10        DITM
     C                   Z-ADD     0             DNO7
     C                   ELSE
     C     POCD13        IFEQ      'C'                                          COMMENTS
     C     *IN88         DOUEQ     '0'
     C     LINKEY        CHAIN     POFTOT                             4188      FILE
     C     *IN88         IFEQ      '1'                                          RECORD LOCK
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C                   MOVE      *BLANKS       DITM
     C                   MOVEL     PODN08        IVDN01
     C                   Z-ADD     0             DNO7
CH   C                   If        PODN08 = ' '                                 RECORD LOCK
CH   C                   Z-add     0             DNO7
CH   C                   MoveL     PODN10        IVDN01
CH   C                   EndIf                                                  RECORD LOCK
     C                   END
     C                   END
     C                   END
      *
     C                   Z-ADD     POQYU1        DQTY                           QTY ORDERED
   CDC*                  MOVE      IVNO22        DMAN                           MANUFACTURER #
CD   C                   MOVE      IVNO93        DMAN                           MANUFACTURER #
     C                   MOVE      PODN03        DUOM                           ORDERED UOM
     C                   MOVE      PODN04        DUMP                           PRICING UOM
     C                   MOVEL     IVDN01        DDES                           DESCRIPTION
     C                   Z-ADD     POAMU1        DLST                           LIST PRICE
     C                   Z-ADD     POAMU2        DCST                           UNIT COST
     C                   MOVE      POPC02        DDSC                           ITEM DISCOUNT
     C                   MOVE      POCD16        DDOV                           DISC OVERRIDE
     C                   MOVE      POCD17        DCOV                           COST OVERRIDE
     C                   Z-ADD     PONO05        DKEY                           LINE NUMBER
     C                   MOVE      POCD14        DTYP                           TAG CODE
     C                   Z-ADD     POQYU3        DQYR                           RECEIVED QTY
     C                   MOVE      POCD13        DCOM                           ITEM TYPE
     C                   Z-ADD     POAM38        DLITD                          LOT INV TO DATE
      *
     C     POCD14        IFEQ      'Y'                                          TAG & HOLD
     C     LINKEY        SETLL     POFTTG
     C     *IN41         DOUEQ     '1'
     C     *IN88         DOUEQ     '0'
     C     LINKEY        READE     POFTTG                               8841
     C     *IN88         IFEQ      '1'                                          RECORD LOCK
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN41         IFEQ      '0'
     C                   MOVE      POCD15        TTYP                           TYPE TAG & HOLD
     C                   Z-ADD     POQY02        TQTY                           TAGGED QTY
     C                   Z-ADD     PONO09        TBRA                           TAGGED BRANCH
     C                   Z-ADD     PONO10        TCUS                           TAGGED CUSTOMER
   BXC*                  Z-ADD     PONO11        TREF                           TAGGED REF #
BX   C                   MOVE      PONO11        TREF                           TAGGED REF #
     C                   MOVE      PODN06        TCOM                           TAG COMMENTS
     C                   ADD       1             ZZ                             ARRARY INDEX
     C                   Z-ADD     PONO05        KY(ZZ)                         LINE NUMBER
     C                   MOVE      TAGH          TH(ZZ)
     C                   END
     C                   END
     C                   END
      *
      * GET LOT DETAIL
      *
     C     POCD42        IFEQ      'Y'
     C     POCD13        ANDEQ     'N'
     C                   MOVE      *ON           *IN52                          DSP C/O NUMBER
     C                   MOVE      *ON           LOTFLG
     C     PONO01        CHAIN(N)  OEFTOAD                            42
     C     *IN42         DOWEQ     *OFF
     C                   ADD       1             X
     C     X             OCCUR     SAVDS
     C                   CLEAR                   SAVDS
      *
      * STOCKED ITEM
      *
     C     OECD85        IFEQ      'I'                                          STOCK ITM
     C     OECD85        OREQ      'P'                                          STOCK ITM
     C     IVNO07        CHAIN     IVFMSTR                            44
     C     *IN44         IFEQ      *OFF
     C                   Z-ADD     IVNO07        DNO7
     C                   MOVEL     IVDN01        DDES
     C     OECD85        IFEQ      'I'                                          ITEM#
     C                   MOVEL     IVNO07        DITM
     C                   ELSE                                                   PRODUCT#
     C                   MOVEL     IVNO04        DITM
     C                   ENDIF
     C                   ENDIF                                                  EIF 44
      *
      * NONSTOCK ITEM/COMMENT
      *
     C                   ELSE
     C                   MOVEL     OEDN12        DITM                           NSTK#
     C     OECD85        IFEQ      'N'                                          NONSTOCK
     C                   CLEAR                   IVNO04
     C                   MOVEL     OEDN12        IVNO04
     C     IVNO04        CHAIN     IVFTNSK                            44
     C     *IN44         IFEQ      *OFF
     C                   MOVEL     IVDN01        DDES
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     OEDN13        DDES                           NSTK DESCR
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'D'           DTYP                           ITEM TYPE
     C                   Z-ADD     OEQY18        DQTY                           QTY ORDERED
     C                   Z-ADD     OEQY20        DQYR                           RELEASED
     C                   MOVE      OEDN04        DUOM                           UOM
     C                   MOVE      OEDN04        DUMP                           "
     C                   MOVE      OECD85        DCOM                           ITEM TYPE
     C                   Z-ADD     0             DKEY                           TAG & HOLD KEY
     C                   Z-ADD     0             DLST                           MANUF LIST
     C                   Z-ADD     0             DCST                           REPLC COST
     C                   Z-ADD     0             DLITD                          LOT INV TO DATE
     C     PONO01        READE     OEFTOAD                                42
     C                   ENDDO
     C                   ELSE
     C                   MOVE      *OFF          LOTFLG            1
     C                   ENDIF
      *
     C                   END
     C                   END
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    DELETE SUBROUTINE                                       *
      *------------------------------------------------------------------------*
     C     DELET         BEGSR
     C     CODE          IFNE      'M'                                          MAINTENANCE
      *-----VOID PRINTED RECEIVING REPORTS
     C                   CALL      'POR0380'
     C                   PARM                    PONO01                         P/O #
     C                   PARM      'P'           WKCODE            1            CODE=P
      *
     C     *IN88         DOUEQ     '0'
     C     PONO01        CHAIN     POFTOH                             4088
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
CA
CA    * Set WM branch flag for special calls to PO void program
CA   C                   if        isWMCoBr(0:pono02)
CA   C                   eval      whmBr = 'Y'
CA   C                   endif
      *
     C     *IN40         IFEQ      '0'
     C     CODE          IFNE      'M'
     C     WHMBR         ANDEQ     'Y'                                          Whse branch
     C     POCD01        ANDNE     'D'                                          Direct
     C     POCD01        ANDNE     'O'                                          Overhead
     C     POCD01        ANDNE     'F'                                          Blanket
     C                   MOVE      'V'           POCD20
     C                   UPDATE    POFTOH
     C                   CLEAR                   PDATA
     C                   MOVE      'PO '         WMFRM
     C                   MOVEL     PONO01        PDATA
     C                   CALL      'WXR5952'
     C                   PARM                    WMFRM             3
     C                   PARM                    PDATA           256
     C                   ENDIF
     C                   ENDIF
      *
     C                   CLEAR                   DSPF1
     C     *IN88         DOUEQ     *OFF
     C     PONO01        CHAIN     POFTOH                             4088
     C     *IN88         CASEQ     *ON           UNLOCK
     C                   ENDCS
     C                   ENDDO
      *
     C     *IN40         IFEQ      '0'
B3    *
B3   C     ICSYS         IFEQ      'Y'
CF    * Determine if licensed to this product...
CF    * The following license key checking logic may not be altered, bypassed or removed.
CF    * See Legal Document in WRKMINKEY command for more information.
CF   C                   if        LicToDII
B3   C                   CLEAR                   QSEARCH
B3   C                   MOVEL     'QREINDEX'    QSEARCH
B3   C                   CALL      'OPC9832 '
B3   C                   PARM                    QSEARCH          10
CF    * Display error message if not licensed to DII (IntelliChief)
CF   C                   else
CF   C                   eval      p1300bypass = 'Y'
CF   C                   call      'MNR1300'     pl1300
CF   C                   endif
B3   C                   ENDIF
B3    *
CE   C     CODE          IFNE      'M'                                          MAINTENANCE
CE   C                   MOVE      UMONTH        POMOA9
CE   C                   MOVE      UDAY          PODYA9
CE   C                   MOVEL     *YEAR         POCCA9
CE   C                   MOVE      UYEAR         POYRA9
CE   C                   TIME                    POTM14
CE   C                   MOVE      USRNM         PONM08
CE   C                   WRITE     POFTVOH
CE   C                   ENDIF
     C                   DELETE    POFTOH
     C                   END
     C                   ENDIF
      *
     C     *IN88         DOUEQ     '0'
     C     APNO01        CHAIN     APFMVEN                            4088      VENDOR MASTER
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
      *
     C     CODE          IFEQ      'M'                                          MAINTENANCE
     C     APCD28        IFEQ      'Y'
     C                   DELETE    APFMVEN
     C                   END
     C                   ELSE
     C     *IN50         IFEQ      '1'                                          UNAPPROVED VEND
     C     APNO01        SETLL     POFTOHV                                40
     C     *IN40         IFEQ      '0'
     C                   DELETE    APFMVEN
     C                   ELSE
     C                   EXCEPT    XDUM2
     C                   END
     C                   ELSE
     C                   EXCEPT    XDUM2
     C                   END
     C                   END
      *
     C     PONO01        SETLL     POFTOA
     C     *IN40         DOUEQ     '1'
     C     *IN88         DOUEQ     '0'
     C     PONO01        READE     POFTOA                               8840
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         IFEQ      '0'
CE   C     CODE          IFNE      'M'                                          MAINTENANCE
CE   C                   MOVE      UMONTH        POMOA9
CE   C                   MOVE      UDAY          PODYA9
CE   C                   MOVEL     *YEAR         POCCA9
CE   C                   MOVE      UYEAR         POYRA9
CE   C                   TIME                    POTM14
CE   C                   MOVE      USRNM         PONM08
CE   C                   WRITE     POFTVOA
CE   C                   ENDIF
     C                   DELETE    POFTOA
     C                   END
     C                   END
      *
     C     PONO01        SETLL     POFTNT
     C     *IN40         DOUEQ     '1'
     C     *IN88         DOUEQ     '0'
     C     PONO01        READE     POFTNT                               8840
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         IFEQ      '0'
B1   C     POCD08        ANDNE     '3'
CE   C     CODE          IFNE      'M'                                          MAINTENANCE
CE   C                   MOVE      UMONTH        POMOA9
CE   C                   MOVE      UDAY          PODYA9
CE   C                   MOVEL     *YEAR         POCCA9
CE   C                   MOVE      UYEAR         POYRA9
CE   C                   TIME                    POTM14
CE   C                   MOVE      USRNM         PONM08
CE   C                   WRITE     POFTVNT
CE   C                   ENDIF
     C                   DELETE    POFTNT
     C                   END
     C                   END
      *
      * MOVE TAG DELETION UNTIL AFTER LINE ITEM DELETION HAS OCCCURRED
      * SO THAT B/O LOWSTOCK IS PROCESSED "AFTER" PO LINE ITEM IS GONE
      * OTHERWISE IT STILL THINKS IT'S ON ORDER AND NOTHING HAPPENS...
      *
      * REMOVE TAGS TO LOT DETAIL
      *
     C     PONO01        SETLL     OEFTOAD
     C     *IN40         DOUEQ     *ON
     C     *IN88         DOUEQ     *OFF
     C     PONO01        READE     OEFTOAD                              8840
     C     *IN88         IFEQ      *ON
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   ENDIF
     C                   ENDDO
     C     *IN40         IFEQ      *OFF
     C                   Z-ADD     *ZEROS        LOTPO
     C                   EXCEPT    UPDLOT
     C                   ENDIF
     C                   ENDDO
      *
     C     PONO01        SETLL     POFTOT
     C     *IN40         DOUEQ     '1'
     C     *IN88         DOUEQ     '0'
     C     PONO01        READE     POFTOT                               8840
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         IFEQ      '0'
CE   C     CODE          IFNE      'M'                                          MAINTENANCE
CE   C                   MOVE      UMONTH        POMOA9
CE   C                   MOVE      UDAY          PODYA9
CE   C                   MOVEL     *YEAR         POCCA9
CE   C                   MOVE      UYEAR         POYRA9
CE   C                   TIME                    POTM14
CE   C                   MOVE      USRNM         PONM08
CE   C                   WRITE     POFTVOT
CE   C                   ENDIF
     C                   DELETE    POFTOT
     C                   END
     C                   END
CE    *
CE    *   Write non-stock archive
CE   C     CODE          IFNE      'M'                                          MAINTENANCE
CE   C     PONO01        SETLL     POFTOL
CE   C     *IN47         DOUEQ     *ON
CE   C     PONO01        READE     POFTOL                                 47
CE   C     *IN47         IFEQ      *OFF
CE   C     IVNO07        ANDEQ     0
CE   C     POCD13        ANDEQ     'N'
CE   C                   MOVEL     PODN10        IVNO04
CE   C     IVNO04        CHAIN     IVFTNSK                            41
CE   C     *IN41         IFEQ      *OFF
CE   C                   MOVE      UMONTH        POMOA9
CE   C                   MOVE      UDAY          PODYA9
CE   C                   MOVEL     *YEAR         POCCA9
CE   C                   MOVE      UYEAR         POYRA9
CE   C                   TIME                    POTM14
CE   C                   MOVE      USRNM         PONM08
CE   C                   WRITE     POFTVNK
CE   C                   ENDIF
CE   C                   ENDIF
CE   C                   ENDDO
CE   C                   ENDIF
      *
     C     CODE          IFNE      'M'
      * DELETE REVISED PO LINES
     C     PONO01        SETLL     POFTRVL
     C     *IN40         DOUEQ     *ON
     C     *IN88         DOUEQ     *OFF
     C     PONO01        READE     POFTRVL                              8840
     C     *IN88         IFEQ      *ON
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   ENDIF
     C                   ENDDO
     C     *IN40         IFEQ      *OFF
CE   C     CODE          IFNE      'M'                                          MAINTENANCE
CE   C                   MOVE      UMONTH        POMOA9
CE   C                   MOVE      UDAY          PODYA9
CE   C                   MOVEL     *YEAR         POCCA9
CE   C                   MOVE      UYEAR         POYRA9
CE   C                   TIME                    POTM14
CE   C                   MOVE      USRNM         PONM08
CE   C                   WRITE     POFTVVL
CE   C                   ENDIF
     C                   DELETE    POFTRVL
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      *  REMOVE THIS PO NUMBER FROM TRANSFER LINE ITEMS
     C                   MOVEA     '00'          *IN(48)
     C     PONO01        SETLL     IVFTTL
     C     *IN88         DOUEQ     '0'
     C     PONO01        READE     IVFTTL                               8840
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         DOWEQ     '0'
     C     IVCD72        IFNE      'C'                                          NOT CLOSED
     C     IVCD72        ANDNE     'V'                                          NOT VOIDED
     C                   Z-ADD     0             TRNO01                         P/O NUMBER
     C                   MOVE      *BLANK        IVCD72                         B/O STATUS
     C                   Z-ADD     UMONTH        IVMO01                         DATE OF LAST
     C                   Z-ADD     UDAY          IVDY01                          UPDATE AND
     C                   MOVEL     *YEAR         IVCC01                          WHO DUN-IT
     C                   Z-ADD     UYEAR         IVYR01                          WHO DUN-IT
     C                   MOVE      USRNM         IVNM01                         UPDATE USER
     C                   EXCEPT    IVTTL
     C                   END
     C                   MOVEA     '00'          *IN(48)
     C     *IN88         DOUEQ     '0'
     C     PONO01        READE     IVFTTL                               8840
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C                   END
      *
      *
      *  REMOVE THIS PO NUMBER FROM SALES ORDER LINE ITEMS
     C                   MOVEA     '00'          *IN(48)
     C     PONO01        SETLL     OELTOLYK
     C     *IN88         DOUEQ     '0'
     C     PONO01        READE     OELTOLYK                             8840
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         DOWEQ     '0'
     C     OECD47        IFNE      'R'                                          VEND RETURN
     C     OECD09        IFEQ      'N'                                          NONSTOCK
     C     OECD09        OREQ      'X'                                          NONSTOCK
     C     OECD27        IFNE      'O'
     C     OECD27        ANDNE     'A'                                          COST O/A
     C     PONO24        ANDEQ     0
     C     *IN48         ANDEQ     *ON
     C                   Z-ADD     0             OEAM02
     C                   CLEAR                   OEAM40
     C                   CLEAR                   OEAM41
     C                   ENDIF
     C                   END
     C     OECD47        IFNE      'C'                                          NOT CLOSED
     C     OECD47        ANDNE     'V'                                          NOT VOIDED
B0   C     PGMFRM        ANDNE     'M'                                          NOT MAINTENANCE
B5    * The above field 'PGMFRM' should only be an 'M' if maintaining
B5    * a Job Lot purchase order.
B0 B5C*    POCD42        ANDNE     'Y'                                          NOT JOB LOT
     C                   Z-ADD     0             PO#
     C                   CLEAR                   OPOLN
     C                   MOVE      ' '           OECD47
     C                   ENDIF
     C                   Z-ADD     UMONTH        OEMO02                         DATE OF LAST
     C                   Z-ADD     UDAY          OEDY02                          UPDATE AND
     C                   MOVEL     *YEAR         OECC02                          WHO DUN-IT
     C                   Z-ADD     UYEAR         OEYR02                          WHO DUN-IT
     C                   MOVE      USRNM         OENM01                         UPDATE USER
     C     *IN48         IFEQ      '1'
     C                   EXCEPT    OETOL
     C                   ELSE
     C                   EXCEPT    OETOLY
     C                   END
     C                   END
     C                   MOVEA     '00'          *IN(48)
     C     *IN88         DOUEQ     '0'
     C     PONO01        READE     OELTOLYK                             8840
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C                   END
      * REMOVE BACKORDER STATUS ON PURCHASES ORDERS AND TRANSFERS
      *
     C     CODE          IFNE      'M'
     C     POSTS         OREQ      'X'
     C     PONO01        SETLL     POFTSTS
     C     *IN40         DOUEQ     *ON
     C     PONO01        READE     POFTSTS                                40
     C     *IN40         IFEQ      *OFF
     C     POCD45        IFEQ      'S'
     C                   Z-ADD     *ZERO         PONUMB
     C     ITMTRN        SETLL     OELTOLYK
     C     *IN41         DOUEQ     *ON
     C     *IN88         DOUEQ     *OFF
     C                   CLEAR                   *IN48
     C                   CLEAR                   *IN49
     C     ITMTRN        READE     OELTOLYK                             8841
     C     *IN88         IFEQ      *ON
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   ENDIF
     C                   ENDDO
     C     *IN41         IFEQ      *OFF
     C     OECD47        ANDNE     'C'
     C     OECD47        ANDNE     'V'
     C     OEQY02        ANDNE     0
     C                   MOVE      ' '           OECD47
     C     *IN49         IFEQ      *ON
     C                   EXCEPT    UDTOLY
     C                   ELSE
     C                   EXCEPT    UPDTOL
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ELSE
BX   C                   MOVE      IVNO66        WKIVNO55
     C     TRNITM        SETLL     IVFTTLG
     C     *IN41         DOUEQ     *ON
     C     TRNITM        READE     IVFTTLG                                41
     C     *IN41         IFEQ      *OFF
     C     PONUMB        ANDEQ     *ZEROS
     C     IVCD72        ANDNE     'C'
     C     IVCD72        ANDNE     'V'
     C                   MOVE      ' '           IVCD72
     C                   EXCEPT    UPDTTL
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   DELETE    POFTSTS
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
   BV *  REMOVE THIS PO NUMBER FROM WORK ORDER LINE ITEMS
   BVC*    PONO01        SETLL     WOFTOL                                 40
   BVC*    *IN40         IFEQ      *ON
   BV * CHECK FOR RECORD LOCK
   BVC*                  MOVE      *IN92         SVIN92            1            SAVE *IN92
   BVC*                  MOVE      *BLANKS       DSPF1
   BVC*    *IN92         DOUEQ     *OFF
   BVC*    PONO01        READE     WOFTOL                               9240
   BVC*    *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
   BVC*                  ENDCS
   BVC*                  ENDDO
   BVC*                  MOVE      SVIN92        *IN92                          RESTORE *IN92
   BVC*    *IN40         DOWEQ     *OFF
   BVC*    OECD47        IFNE      'C'
   BVC*    OECD47        ANDNE     'V'
   BVC*                  Z-ADD     UMONTH        WOMO02                         DATE OF LAST
   BVC*                  Z-ADD     UDAY          WODY02                          UPDATE AND
   BVC*                  Z-ADD     UYEAR         WOYR02                          WHO DUN-IT
   BVC*                  MOVEL     *YEAR         WOCC02
   BVC*                  MOVE      USRNM         WONM01                         UPDATE USER
   BVC*                  CLEAR                   PO#
   BVC*                  CLEAR                   POL#
   BVC*                  EXCEPT    UPDWOL
   BVC*                  ENDIF
   BV * CHECK FOR RECORD LOCK
   BVC*                  MOVE      *IN92         SVIN92            1            SAVE *IN92
   BVC*                  MOVE      *BLANKS       DSPF1
   BVC*    *IN92         DOUEQ     *OFF
   BVC*    PONO01        READE     WOFTOL                               9240
   BVC*    *IN92         CASEQ     *ON           UNLOCK                         RECORD LOCK
   BVC*                  ENDCS
   BVC*                  ENDDO
   BVC*                  MOVE      SVIN92        *IN92                          RESTORE *IN92
   BVC*                  ENDDO
   BVC*                  ENDIF
BV    *  REMOVE THIS PO NBR FROM WORK ORDER MOVE REQUEST LINE ITEMS...
BV   C                   MOVE      'PO'          TAGTRNTPMP
BV   C                   MOVE      PONO01        TAGTRNNOMP
BV   C     WOKEY         SETLL     WKFTMOV
BV   C     *IN40         DOUEQ     *ON
BV   C     *IN92         DOUEQ     *OFF
BV   C     WOKEY         READE     WKFTMOV                                40
BV   C     *IN92         CASEQ     *ON           UNLOCK
BV   C                   ENDCS
BV   C                   ENDDO
BV   C     *IN40         IFEQ      *OFF
BV   C     BOSTATCDMP    IFEQ      'P'
BV   C     BOSTATCDMP    OREQ      ' '
BV   C                   CLEAR                   BOSTATCDMP
BV   C                   CLEAR                   TAGTRNTPMP
BV   C                   CLEAR                   TAGTRNNOMP
BV   C                   Eval      Dattimtmmp =
BV   C                              RtvDatTimStmp(USRNM)
BV   C                   EXCEPT    UPDTMOV
BV   C                   ENDIF
BV   C                   ENDIF
BV   C                   ENDDO
      *
      *
     C     PONO01        SETLL     POFTOL
     C     *IN40         DOUEQ     '1'
     C     *IN88         DOUEQ     '0'
     C     PONO01        READE     POFTOL                               8840
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         IFEQ      '0'
CE   C     CODE          IFNE      'M'                                          MAINTENANCE
CE   C                   MOVE      UMONTH        POMOA9
CE   C                   MOVE      UDAY          PODYA9
CE   C                   MOVEL     *YEAR         POCCA9
CE   C                   MOVE      UYEAR         POYRA9
CE   C                   TIME                    POTM14
CE   C                   MOVE      USRNM         PONM08
CE   C                   WRITE     POFTVOL
CE   C                   ENDIF
     C                   DELETE    POFTOL
      * DELETE NON-STOCK DESCRIPTION...
     C     POCD13        IFEQ      'N'
     C                   MOVEL     PODN10        NSID
     C                   CALL      'OER2062'     PL2062
     C                   ENDIF
      *
     C                   MOVEL     PONO01        PONUM            12            P/O NUMBER
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
     C                   END
     C                   END
CN    *
CN   C     PONO01        SETLL     POQTOLA01
CN   C     *IN40         DOUEQ     '1'
CN   C     *IN88         DOUEQ     '0'
CN   C     PONO01        READE     POQTOLA01                            8840
CN   C     *IN88         IFEQ      '1'
CN   C                   MOVE      ' '           DSPF1
CN   C                   MOVE      ' '           DSPF2
CN   C                   CALL      'OPC1002'     RLOCK
CN   C                   ENDIF
CN   C                   ENDDO
CN   C     *IN40         IFEQ      '0'
CN   C     CODE          IFNE      'M'                                          MAINTENANCE
CN   C                   MOVE      UMONTH        POMOA9
CN   C                   MOVE      UDAY          PODYA9
CN   C                   MOVEL     *YEAR         POCCA9
CN   C                   MOVE      UYEAR         POYRA9
CN   C                   TIME                    POTM14
CN   C                   MOVE      USRNM         PONM08
CN   C                   WRITE     POFTVOLA
CN   C                   ENDIF
CN   C                   DELETE    POFTOLA
CN   C                   ENDIF
CN   C                   ENDDO
      * REMOVE P/O LINE TAGS...
     C     PONO01        SETLL     POFTTG
     C     *IN40         DOUEQ     *ON
     C     *IN88         DOUEQ     *OFF
     C     PONO01        READE     POFTTG                               8840
     C     *IN88         IFEQ      *ON
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN40         IFEQ      *OFF
CE   C     CODE          IFNE      'M'                                          MAINTENANCE
CE   C                   MOVE      UMONTH        POMOA9
CE   C                   MOVE      UDAY          PODYA9
CE   C                   MOVEL     *YEAR         POCCA9
CE   C                   MOVE      UYEAR         POYRA9
CE   C                   TIME                    POTM14
CE   C                   MOVE      USRNM         PONM08
CE   C                   WRITE     POFTVTG
CE   C                   ENDIF
     C                   DELETE    POFTTG
     C                   END
     C                   END
CL    *
CL    * Remove P/O promo code..
CL   C                   clear                   dspf1
CL   C                   clear                   dspf2
CL   C     *IN88         DOUEQ     *off
CL   C     PONO01        CHAIN     POFTOHA                            4088
CL   C     *IN88         CASEQ     *ON           UNLOCK
CL   C                   ENDcs
CL   C                   ENDDO
CL    *
CL   C     *IN40         IFEQ      *OFF
CL   C     CODE          IFNE      'M'
CL   C                   MOVE      UMONTH        POMOA9
CL   C                   MOVE      UDAY          PODYA9
CL   C                   MOVEL     *YEAR         POCCA9
CL   C                   MOVE      UYEAR         POYRA9
CL   C                   TIME                    POTM14
CL   C                   MOVE      USRNM         PONM08
CL   C                   WRITE     POfTVOHa
CL   C                   endif
CL   C                   DELETE    POfTOHa
CL   C                   endif
CL    *
     C                   ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE    UPDATE INVENTORY                                        *
      *------------------------------------------------------------------------*
     CSR   UPDINV        BEGSR
     C                   Z-ADD     0             EXTCST            9 2
     C     POQY01        IFGT      0
     C     POAM02        MULT(H)   POQY01        EXTCST                         EXTENDED COST
     C                   END
      *
     C                   MOVE      ' '           LSTPO             1            RESTORE LAST PO
      *
     C     *IN88         DOUEQ     '0'
     C     BRKEY         CHAIN     IVFMSBR                            4188
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN41         IFEQ      '0'
      * UPDATE THE B/O LOWSTOCK WORKFILE WITH ITEM BEING VOIDED...
     C     IMNO08        IFNE      *BLANKS
     C     WHRFRM        ANDNE     'B'
     C                   MOVE      IMNO08        LBLINE
     C                   MOVE      PONO02        LBBRN
     C                   MOVE      IVNO07        LBITM
     C                   CALL      'IMR0510'     PL0510
     C     LINKEY        SETLL     POFTTG
     C     *IN44         DOUEQ     *ON
     C     LINKEY        READE(N)  POFTTG                                 44
     C     *IN44         IFEQ      *OFF
      * PROCESS ALL TAGGED BRANCHES FOR THE ITEM TO INSURE B/O LOWSTOCK
      * FILE IS KEPT UP TO DATE... OTHERWISE, UPDATE MAY MISS B/O'S...
      * (I.E. BRANCH 001 BUT ONLY BACKORDER IS AT TAG BRANCH 006...)
     C     PONO09        IFNE      0
     C                   MOVE      IMNO08        LBLINE
     C                   MOVE      PONO09        LBBRN
     C                   MOVE      IVNO07        LBITM
     C                   CALL      'IMR0510'     PL0510
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   Z-ADD     UMONTH        IVMO01                         DATE OF LAST
     C                   Z-ADD     UDAY          IVDY01                          UPDATE AND
     C                   MOVEL     *YEAR         IVCC01                          WHO DUN-IT
     C                   Z-ADD     UYEAR         IVYR01                          WHO DUN-IT
     C                   MOVE      USRNM         IVNM01                         UPDATE USER
     C                   SUB       POQY01        IVQY17                         MTD QTY PURCHAS
     C     POCD20        IFEQ      'O'                                          OPEN PO
     C                   SUB       QTYRMN        IVQY22                         QTY ON ORDER
     C     IVQY22        IFLT      0
     C                   CLEAR                   IVQY22
     C                   ENDIF
     C                   END
     C                   SUB       1             IVCN13                         MTD COUNT OF PURC
     C                   SUB       EXTCST        IVAM28                         MTD COST AMOUNT
      *
     C     PONUM         IFEQ      IVNO13                                       LAST P/O # ?
     C                   MOVE      'Y'           LSTPO                          RESTORE LAST PO
     C                   MOVE      *BLANKS       IVNO13                         P/O NUMBER
     C                   Z-ADD     0             IVMO16                         DATE OF LAST
     C                   Z-ADD     0             IVDY16                          TIME ITEM
     C                   Z-ADD     0             IVCC16                          PURCHASED
     C                   Z-ADD     0             IVYR16                          PURCHASED
     C     PONO07        IFNE      *ZERO
     C                   Z-ADD     0             IVQY06                         LAST ORDER QTY
     C                   ENDIF
     C                   END
      *
     C                   UPDATE    IVFMSBR                                       PURCHASES
      *
      * WHEN VOIDING ORDER -- RESTORE TO LAST P/O
     C     LSTPO         IFEQ      'Y'                                          RESTORE LAST PO
     C                   Z-ADD     99            CC11                           ENTERED CENTURY
     C                   Z-ADD     99            YR11                           ENTERED YEAR
     C                   Z-ADD     99            MO11                           ENTERED MONTH
     C                   Z-ADD     99            DY11                           ENTERED DAY
      *
     C     BRKEY         SETLL     POFTOL2                                41    EXIST ?
     C     *IN41         CABEQ     '0'           AROUND
     C     RSTKEY        SETGT     POFTOL2                                      SETGREATERTHAN
      *
     C     READIT        TAG
     C                   READP     POFTOL2                                42
     C     *IN42         CABEQ     '1'           AROUND                         END OF FILE
     C     IVNO07        CABNE     IVNO7         AROUND
     C     POC13         CABNE     'S'           READIT                         STOCKED ITEM ?
     C     POC01         CABEQ     'F'           READIT                         BLANKET ORDER
     C     POC01         CABEQ     'D'           READIT                         DIRECT ORDER
     C     POC01         CABEQ     'O'           READIT                         OVERHEAD ORDER
      *
     C     *IN88         DOUEQ     '0'
     C     BRKEY         CHAIN     IVFMSBR                            4188
     C     *IN88         IFEQ      '1'
     C                   MOVE      ' '           DSPF1
     C                   MOVE      ' '           DSPF2
     C                   CALL      'OPC1002'     RLOCK
     C                   END
     C                   END
     C     *IN41         IFEQ      '0'
     C                   MOVE      *BLANKS       IVNO13                         P/O NUMBER
     C                   MOVEL     PONO1         IVNO13                         LAST P/O #
     C                   Z-ADD     POMO11        IVMO16                         DATE OF LAST
     C                   Z-ADD     PODY11        IVDY16                          TIME ITEM
     C                   Z-ADD     POCC11        IVCC16                          PURCHASED
     C                   Z-ADD     POYR11        IVYR16                          PURCHASED
     C                   UPDATE    IVFMSBR
     C                   END
     C                   END
     C                   END
     C     AROUND        ENDSR
      *------------------------------------------------------------------------*
      *  SUBROUTINE - UNLOCK FILE                                              *
      *------------------------------------------------------------------------*
     C     UNLOCK        BEGSR
     C                   MOVE      *BLANK        DSPF2
     C                   CALL      'OPC1002'     RLOCK
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
      * Check whether open ASN exists in WM system or not.
      *------------------------------------------------------------------------*
     C     CHKASN        BEGSR
      * DETERMINE IF TRANSACTION EXISTS IN W/M...
     C                   CLEAR                   WMTRAN
     C                   MOVEL     'PO'          POPOPO
BX   C                   MOVE      PONO01        WMN01
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
      * Request the ASN information for this PO
      *  (send blank item/non-stock)
     C                   CLEAR                   ASNDTA
     C                   MOVE      WMGRP#        HDGRP#
     C                   MOVE      'M'           HDFUNC
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
     C                   Z-ADD     0             ASNSI#
     C                   MOVE      *BLANKS       ASNNSI
      *
     C                   MOVE      DQLIB         ASNQLB
     C                   MOVE      DQNAME        ASNQNM
     C                   CALL      'WIR0220'
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
     C                   CALL      'WIR0220'
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
      *------------------------------------------------------------------------*
     OOEFTOL    E            OETOL
     O                       PO#
     O                       OPOLN
     O                       OEAM02
     O                       OEAM40
     O                       OEAM41
     O                       OECD47
     O                       OEMO02
     O                       OEDY02
     O                       OECC02
     O                       OEYR02
      *
     OOEFTOLY   E            OETOLY
     O                       PO#
     O                       OPOLN
     O                       OECD47
     O                       OEMO02
     O                       OEDY02
     O                       OECC02
     O                       OEYR02
      *
     OIVFTTL    E            IVTTL
     O                       TRNO01
     O                       IVCD72
     O                       IVMO01
     O                       IVDY01
     O                       IVCC01
     O                       IVYR01
     OIVFTTLG   E            UPDTTL
     O                       IVCD72
      *
     OOEFTOLY   E            UDTOLY
     O                       OECD47
      *
     OOEFTOL    E            UPDTOL
     O                       OECD47
      *
   BVO*WOFTOL    E            UPDWOL
   BVO*                      PO#
   BVO*                      POL#
   BVO*                      WOMO02
   BVO*                      WODY02
   BVO*                      WOYR02
   BVO*                      WOCC02
   BVO*                      WONM01
BV   OWKFTMOV   E            UPDTMOV
BV   O                       BOSTATCDMP
BV   O                       TAGTRNNOMP
BV   O                       TAGTRNTPMP
BV   O                       DATTIMTMMP
      *
     OPOFTOH    E            XDUM1
     OAPFMVEN   E            XDUM2
     OPOFTOA    E            XDUM3
     OOEFTOAL   E            TOAL
     O                       OAPN01
     O                       OAPN05
     OOEFTOAD   E            UPDLOT
     O                       LOTPO
      *------------------------------------------------------------------------*
      *------------------- TABLE FILE CHANGE AREA -----------------------------*
      *------------------------------------------------------------------------*
** DOA Submit job for Direct Order Audit
SBMJOB JOB(DIRAUDIT) JOBD(HDJPACK) RQSDTA('CALL PGM(POR0010) PARM(''P'
' ''XXXXXXX'')') JOBPTY(4) LOG(0) MSGQ(*NONE)
