     H OPTION(*SRCSTMT : *NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - PRR1710                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                           *
     F*------------------------------------------------------------------------*
     F*D POPULATE PRICE BOOK FILE                                              *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    Populates price book file using the parameters entered from the    *
     F*S    price book request program.  The file will be used by the print    *
     F*S    program.                                                           *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                     *
AA   F*U 1090000332 031506 062 PRICE BOOK OVERLAY LAST PAGE/ITEM               *
AB   F*E 8000009966 013007 915 CHANGE S/O NUMBER TO 7 CHARS ALPHA              *
AF   F*E 8000010307 040108 915 INCREASE PRICE IN O/E FOR REL 12.0              *
AG   F*E 8000010162 042108 914 MINCRONIZE RGA FOR NEXT RELEASE
AH   F*E 8000010539 082508 127 CORRECT DATA DECIMAL ERROR
AJ   F*U 1420000160 041114 915 PRICE BOOK MISSING PRICES
AK   F*U 1430000523 041514 915 PRICE BOOK NOT PRINTING CONTRACTS
AN   F*U 1430000628 081721 035 USE LARGER PRAM56 INSTEAD OF PRAM17             *
¢A   F*C       5580 061611 DCB DISCOUNT SOURCE CODE                            *
¢b   F*C ksb   5899 032013 ksb add new fields                                  *
     F*M ----------------------------------------------------------------------*
¢B   Fprlmcpfg  IF   E           K DISK    PREFIX(DS_)
¢B   FprlmcpfO  IF   E           K DISK    PREFIX(DC_) rename(PRFMCPF:PRFMCPFO)
     FPRLPBRQ1  IF   E           K DISK    PREFIX(PR_)
     FPRLPRBK1  UF A E           K DISK    PREFIX(PB_)
     FARLMBCH4  IF   E           K DISK    PREFIX(BM_)
      * All items
     FIVLMSTR8  IF   E           K DISK    PREFIX(IM_)
      * Vendor
     FIVLMSTR9  IF   E           K DISK    RENAME(IVFMSTR:IVFMSTR9)
     F                                     PREFIX(IM_)
      * Counter book
     FIVLMSTRD  IF   E           K DISK    RENAME(IVFMSTR:IVFMSTRD)
     F                                     PREFIX(IM_)
      * Purchasing book
     FIVLMSTRE  IF   E           K DISK    RENAME(IVFMSTR:IVFMSTRE)
     F                                     PREFIX(IM_)
     FPRLMCPS2  IF   E           K DISK    PREFIX(CS_)
     FPRLMCPH2  IF   E           K DISK    PREFIX(CH_)
     FPRLMCPH1  IF   E           K DISK    RENAME(PRFMCPH:PRFMCPH1)
     F                                     PREFIX(CH_)
     FPRLMCPD1  IF   E           K DISK    PREFIX(CD_)
     FOELTOLYN  IF   E           K DISK    PREFIX(SH_)
AG   F                                     IGNORE(OEFTOL)
     FOELTOLY2  IF   E           K DISK    RENAME(OEFTOLY:OEFTOLY2)
     F                                     PREFIX(SH_)
     FOELTOLY3  IF   E           K DISK    RENAME(OEFTOLY:OEFTOLY3)
     F                                     PREFIX(SH_)
     FOELTOHY3  IF   E           K DISK    PREFIX(OH_)
     FOELTOHY1  IF   E           K DISK    RENAME(OEFTOHY:OEFTOHY1)
     F                                     PREFIX(OH_)
     FOELTOHYH  IF   E           K DISK    RENAME(OEFTOHY:OEFTOHYH)
     F                                     PREFIX(OH_)
     FIVLMALI5  IF   E           K DISK    PREFIX(AI_)
     FIVLMUOM1  IF   E           K DISK    PREFIX(UM_)
     FOEPWSVM   UF A E           K DISK    PREFIX(SV_)
¢B   Fivlmsbr2  IF   E           K DISK    PREFIX(BI_)
¢b   Fprlmpsd2  IF   E           K DISK    PREFIX(PS_)
     FPRP4950   O    E             DISK    USROPN
      * Contract profiles
     D PRF             S              5  0 DIM(99)                              ALIAS #S FROM  SF
      * Clear PRP4950
     D ARD             S              1    DIM(26) CTDATA PERRCD(26)
      * System Data Structure
     D                SDS
     D  PROG                   1      8
     D  WSNAME               244    252
     D  JOBNME               244    253
     D  USRNM                254    263
     D  JOBNBR               264    269
     D  DSPERR                91    160
      * Sales history date range
     D SALES_DATE      DS
     D  OH_OECC01
     D  OH_OEYR01
     D  OH_OEMO01
     D  OH_OEDY01

     D FROM_SDATE      DS
     D  PR_PRCC19
     D  PR_PRYR19
     D  PR_PRMO19
     D  PR_PRDY19

     D TO_SDATE        DS
     D  PR_PRCC20
     D  PR_PRYR20
     D  PR_PRMO20
     D  PR_PRDY20
      * Pricing data structure
   AHD*PRCDS           DS                  OCCURS(56)
AH   D PRCDS           DS                  OCCURS(400)
AH   D                                     INZ
AH   D  PRNO07                 1      6  0
AH   D  @RNO07                 1      6
AH   D  PRDN02                 7      9
AH   D  PRQY01                10     16  0
AH   D  PRTYP                 17     17
AH   D  PRAM01                18     25  2
AH   D  PRAM02                26     32  2
AH   D  PRDSC                 33     40
AH   D  PAM05                 41     49  2
AH   D  PRCSH#                50     56
AH   D  PC07                  57     59  1
AH   D  CD66                  60     60
AH   D  PRSHPB                61     63  0
AH   D  PRCSTS                64     64
AH   D  PRPRCS                65     65
AH   D  prWoNbr                       7s 0
¢A   D  PRDSCS                        1A
     D                 DS                  INZ
     D  DATA1                  1    256
     D  CSTPRC                 1      1
     D  CSTBAS                 2      2
     D  CSTVND                 3      8  0
     D  CSTSHT                 9     15
     D  CSTSTS                16     16

      * Workfields

     D Good_Item       S              1
     D Book_Customer   S                   LIKE(PR_ARNO01)
     D Elem            S              2  0 INZ(0)
     D Record_Type     S                   LIKE(CD_PRCD73) INZ('P')
     D KList_Sec       S                   LIKE(IM_IVCD17)
     D KList_Grp       S                   LIKE(IM_IVCD18)
     D KList_Cat       S                   LIKE(IM_IVCD19)
     D KList_Item      S                   LIKE(IM_IVNO07)
     D Disc_Prof       S                   LIKE(PR_PRNO24)
     D Disc_Prof_1     S                   LIKE(PR_PRNO24)
     D Disc_Prof_2     S                   LIKE(PR_PRNO25)
     D Disc_Prof_3     S                   LIKE(PR_PRNO26)
     D Email           S             45
¢B   D abc_item        S                   LIKE(bi_ivno07)
¢B   D abc_bran        S                   LIKE(bi_ivno10)
¢B   D invend2         S              6a
¢B   D invend3         S              6a
¢B   D dp_ivcd17       S                   LIKE(im_ivcd17)
¢B   D dp_ivcd18       S                   LIKE(im_ivcd18)
¢B   D dp_ivcd19       S                   LIKE(im_ivcd19)
¢B   D dp_ivno07       S                   LIKE(im_ivno07)

     C     *ENTRY        PLIST
     C                   PARM                    Profile           7
     C                   PARM                    Customer          6
     C                   PARM                    Disc_Prof_1
     C                   PARM                    Disc_Prof_2
     C                   PARM                    Disc_Prof_3
     C                   PARM                    Email
¢b   C                   PARM                    instocky          1
¢b   C                   PARM                    inabc             1
¢b   C                   PARM                    indiso            1
¢b   C                   PARM                    invend2           6
¢b   C                   PARM                    invend3           6
¢b   C                   testn                   invend2              69
¢b   C                   if        *in69
¢b   C                   move      invend2       wkvend2           6 0
¢b   C                   else
¢b   C                   z-add     0             wkvend2
¢b   c                   end
¢b   C                   testn                   invend3              69
¢b   C                   if        *in69
¢b   C                   move      invend3       wkvend3           6 0
¢b   C                   else
¢b   C                   z-add     0             wkvend3
¢b   c                   endif
¢b   C                   testn                   customer             69
¢b   C                   if        *in69
¢b   C                   move      customer      wkcust            6 0
¢b   C                   else
¢b   C                   z-add     0             wkcust
¢b   c                   endif
      *--------------------------------------------------------*
     C     PL4950        PLIST
     C                   PARM                    PRCDS
     C                   PARM                    PR_ARNO01
     C                   PARM                    WALKIN            1
     C                   PARM                    LSTTRD            1
     C                   PARM      'F'           PRCTYP            1
     C                   PARM                    BATM              2
     C                   PARM                    BATD              2
     C                   PARM                    BATC              2
     C                   PARM                    BATY              2
     C                   PARM                    BATN              5
     C                   PARM                    BRNNBR            3
     C                   PARM                    PR_ARNO06
     C                   PARM                    ORMO              2
     C                   PARM                    ORDY              2
     C                   PARM                    ORCC              2
     C                   PARM                    ORYR              2
     C                   PARM                    PB_PRNO03
     C                   PARM      'B'           BID               1
      *--------------------------------------------------------*
     C     PL0303        PLIST
     C                   PARM                    SYSID                          APPLICATION COD
     C                   PARM                    DOCNUM           12            DOCUMENT NUMBER
     C                   PARM                    EMAIL                          EMAIL ADDRS
     C                   PARM                    RQTIME            6            REQUESTED FAX TIME
     C                   PARM                    RQDATE            6            REQUESTED FAX DATE
   ABC*                  PARM                    TRNNUM            7 0          TRANSACTION REQUEST
AB   C                   PARM                    TRNNUM            7            TRANSACTION REQUEST
      *--------------------------------------------------------*
     C     SG_KEY        KLIST
     C                   KFLD                    PR_PRCD90
     C                   KFLD                    PR_PRCD91
      *--------------------------------------------------------*
¢b   C     BRI_KEY       KLIST
¢b   C                   KFLD                    im_ivno07
¢b   C                   KFLD                    PR_ARNO16
¢b    *--------------------------------------------------------*
¢b   C     ABC_KEY       KLIST
¢b   C                   KFLD                    abc_item
¢b   C                   KFLD                    abc_bran
¢b    *--------------------------------------------------------*
¢b   C     SGCI_KEY4     KLIST
¢b   C                   KFLD                    wkcust
¢b   C                   KFLD                    IM_ivcd17
¢b   C                   KFLD                    IM_ivcd18
¢b   C                   KFLD                    IM_ivcd19
¢b   C                   KFLD                    IM_ivno07
¢b   C     SGCI_KEY3     KLIST
¢b   C                   KFLD                    wkcust
¢b   C                   KFLD                    IM_ivcd17
¢b   C                   KFLD                    IM_ivcd18
¢b   C                   KFLD                    IM_ivcd19
¢b   C     SGCI_KEY2     KLIST
¢b   C                   KFLD                    wkcust
¢b   C                   KFLD                    IM_ivcd17
¢b   C                   KFLD                    IM_ivcd18
¢b   C     SGCI_KEY1     KLIST
¢b   C                   KFLD                    wkcust
¢b   C                   KFLD                    IM_ivcd17
      *--------------------------------------------------------*
     C     SGC_KEY       KLIST
     C                   KFLD                    PR_PRCD90
     C                   KFLD                    PR_PRCD91
     C                   KFLD                    PR_PRCD92
      *--------------------------------------------------------*
     C     TOHY_KEY      KLIST
     C                   KFLD                    Book_Customer
     C                   KFLD                    PR_PRCC20
     C                   KFLD                    PR_PRYR20
     C                   KFLD                    PR_PRMO20
     C                   KFLD                    PR_PRDY20
      *--------------------------------------------------------*
     C     TOHY1_KEY     KLIST
     C                   KFLD                    BM_ARNO15
     C                   KFLD                    PR_PRCC20
     C                   KFLD                    PR_PRYR20
     C                   KFLD                    PR_PRMO20
     C                   KFLD                    PR_PRDY20
      *--------------------------------------------------------*
     C     TOLY_KEY      KLIST
     C                   KFLD                    OH_OENO01
     C                   KFLD                    IM_IVNO07
      *--------------------------------------------------------*
     C     TOLY_KEY_2    KLIST
     C                   KFLD                    Book_Customer
     C                   KFLD                    IM_IVNO07
      *--------------------------------------------------------*
     C     MALI_KEY      KLIST
     C                   KFLD                    Book_Customer
     C                   KFLD                    IM_IVNO07
      *--------------------------------------------------------*
     C     MCPH_KEY      KLIST
     C                   KFLD                    PR_APNO25
     C                   KFLD                    PR_PRNO13
      *--------------------------------------------------------*
     C     PRBK_KEY      KLIST
     C                   KFLD                    PR_PRNO22
     C                   KFLD                    Book_Customer
     C                   KFLD                    Disc_Prof
     C                   KFLD                    IM_IVNO07
      *--------------------------------------------------------*
     C     MCPD_KEY      KLIST
     C                   KFLD                    CH_PRNO12
     C                   KFLD                    Record_Type
     C                   KFLD                    KList_Sec
     C                   KFLD                    KList_Grp
     C                   KFLD                    KList_Cat
     C                   KFLD                    KList_Item
      *--------------------------------------------------------*
     C     MUOM_KEY      KLIST
     C                   KFLD                    IM_IVNO07
     C                   KFLD                    UM_IVCD08
¢b   c     kpsheet       klist
¢b   c                   kfld                    im_ivno05
¢b   c                   kfld                    wk_status
¢b   c                   kfld                    im_ivno07
      *--------------------------------------------------------*
     C                   MOVEA     ARD           CMDC             26
     C                   Z-ADD     26            LEN              15 5
     C                   CALL      'QCMDEXC'                                    CLRPFM WORKFILE
     C                   PARM                    CMDC
     C                   PARM                    LEN


      * Retrieve profile price book information

     C                   MOVE      Profile       PR_PRNO22
     C     PR_PRNO22     CHAIN     PRFPBRQ
     C                   IF        %FOUND
      * Prepare file for pricing program
     C                   OPEN      PRP4950
     C                   EVAL      CSTBAS = PR_PRCDA6
     C                   EVAL      CSTSTS = PR_PRCDA1
     C                   MOVE      *BLANKS       KEY1
     C                   MOVE      *BLANKS       KEY2
     C                   MOVE      *BLANKS       KEY3
     C                   MOVEL     JOBNME        KEY1
     C                   MOVEL     USRNM         KEY2
     C                   MOVEL     JOBNBR        KEY3
     C                   WRITE     PRF4950
¢b   c                   move      'C'           wk_status         1
      * Branch Master
     C     PR_ARNO16     CHAIN     ARFMBCH

      * Subroutine by book type
     C                   IF        PR_PRCD96 = 'Y'
     C                   EXSR      All_Items
     C                   ELSE
     C     PR_PRCD89     CASEQ     'P'           Pur_Bok_Items
     C     PR_PRCD89     CASEQ     'C'           Cnt_Bok_Items
     C     PR_PRCD94     CASEQ     'Y'           Vnd_Spc_Items
     C     PR_PRCD93     CASEQ     'Y'           Sls_Hst_Items
     C     PR_PRCD95     CASEQ     'Y'           Alias_Items
     C     PR_PRCD97     CASEQ     'C'           On_Cntr_Items
     C     PR_PRCD97     CASEQ     'S'           Cnt_Spc_Items
     C     PR_PRCD97     CASEQ     'E'           Exc_Cnt_Items
¢B   C     instocky      CASEQ     'Y'           In_Stock_Branc
     C                   ENDCS

     C                   ENDIF

      * Call Email control

     C                   IF        EMAIL <> *BLANKS
     C                   MOVEL     PR_PRNO22     DOCNUM           12
     C                   MOVE      'PR01'        SYSID             4
     C                   MOVE      *BLANKS       RQTIME                         REQUESTED TIME
     C                   MOVE      *BLANKS       RQDATE                         REQUESTED DATE
     C                   MOVE      PR_PRNO22     TRNNUM                         TRANSFER NUMBER
     C                   CALL      'OPR0303'     PL0303
     C                   ENDIF

     C                   ENDIF
      *--------------------------------------------------------*
      * End of program
     C                   CLOSE     PRP4950
     C                   EVAL      *INLR = *ON

      *--------------------------------------------------------*
      * Subroutine All_Items will read/write all items in the  *
      * Item Master File.                                      *
      *--------------------------------------------------------*

     C     All_Items     BEGSR

     C                   READ      IVFMSTR                                60
     C                   DOW       *IN60 = *OFF
      * Omit deleted records
     C                   IF        IM_IVCD25 <> 'D'
     C                   EXSR      Write_Item
     C                   ENDIF

     C                   READ      IVFMSTR                                60
     C                   ENDDO

     C                   ENDSR

¢b    *--------------------------------------------------------*
¢b    * Subroutine In_Stock_Branc read/write all items in the  *
¢b    * Item Master File if stocking code = 'Y' (at branch)    *
¢b    *--------------------------------------------------------*
¢b
¢b   C     In_Stock_BrancBEGSR
¢b   C                   READ      IVFMSTR                                60
¢b   C                   DOW       *IN60 = *OFF
¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   c                   eval      Good_Item = 'Y'
¢b   C                   exsr      Item_Select
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 = 'Y'
¢b    * Omit deleted records
¢b   C                   IF        IM_IVCD25 <> 'D' and Good_Item = 'Y'
¢b   C                   EXSR      Write_Item
¢b   C                   ENDIF
¢b   c                   endif
¢b
¢b   C                   READ      IVFMSTR                                60
¢b   C                   ENDDO
¢b
¢b   C                   ENDSR

      *--------------------------------------------------------*
      * Subroutine Pur_Bok_Items reads Item Master by selected *
      * purchasing section, section and group, OR section,     *
      * group, category.                                       *
      *--------------------------------------------------------*

     C     Pur_Bok_Items BEGSR
      * Section/group/category
     C                   IF        PR_PRCD92 <> *BLANKS
     C     SGC_KEY       SETLL     IVFMSTRE
     C     SGC_KEY       READE     IVFMSTRE                               41
     C                   ELSE
      * Section/group
     C                   IF        PR_PRCD91 <> *BLANKS
     C     SG_KEY        SETLL     IVFMSTRE
     C     SG_KEY        READE     IVFMSTRE                               41
     C                   ELSE
      * Section
     C                   IF        PR_PRCD90 <> *BLANKS
     C     PR_PRCD90     SETLL     IVFMSTRE
     C     PR_PRCD90     READE     IVFMSTRE                               41
     C                   ELSE
      * All items on purchasing book
     C                   READ      IVFMSTRE                               41
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * DOW Loop
     C                   DOW       *IN41 = *OFF
¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 <> 'Y'
¢b   c                   goto      skipit
¢b   c                   endif
¢b   c                   if        not%found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'
¢b   c                   goto      skipit
¢b   c                   endif
      * Access code
     C                   IF        IM_IVCD32 = 'Y'

     C                   EVAL      Good_Item = 'Y'

      * Item selection criteria

     C                   EXSR      Item_Select
      * Write it
     C     Good_Item     CASEQ     'Y'           Write_Item
     C                   ENDCS
     C                   ENDIF

¢b   c     skipit        tag
      * Section/group/category
     C                   IF        PR_PRCD92 <> *BLANKS
     C     SGC_KEY       READE     IVFMSTRE                               41
     C                   ELSE
      * Section/group
     C                   IF        PR_PRCD91 <> *BLANKS
     C     SG_KEY        READE     IVFMSTRE                               41
     C                   ELSE
      * Section
     C                   IF        PR_PRCD90 <> *BLANKS
     C     PR_PRCD90     READE     IVFMSTRE                               41
     C                   ELSE
      * All items on purchasing book
     C                   READ      IVFMSTRE                               41
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C     End_Pur_Book  ENDSR

      *--------------------------------------------------------*
      * Subroutine Count_Book reads the Item Master by selected*
      * counter section, section and group, OR section, group, *
      * category.                                              *
      *--------------------------------------------------------*

     C     Cnt_Bok_Items BEGSR
      * Section/group/category
     C                   IF        PR_PRCD92 <> *BLANKS
     C     SGC_KEY       SETLL     IVFMSTRD
     C     SGC_KEY       READE     IVFMSTRD                               42
     C                   ELSE
      * Section/group
     C                   IF        PR_PRCD91 <> *BLANKS
     C     SG_KEY        SETLL     IVFMSTRD
     C     SG_KEY        READE     IVFMSTRD                               42
     C                   ELSE
      * Section
     C                   IF        PR_PRCD90 <> *BLANKS
     C     PR_PRCD90     SETLL     IVFMSTRD
     C     PR_PRCD90     READE     IVFMSTRD                               42
     C                   ELSE
      * All items on purchasing book
     C                   READ      IVFMSTRD                               42
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * DOW Loop
     C                   DOW       *IN42 = *OFF
¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 <> 'Y'
¢b   c                   goto      skipit2
¢b   c                   endif
¢b   c                   if        not%found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'
¢b   c                   goto      skipit2
¢b   c                   endif
      * Access code
     C                   IF        IM_IVCD27 = 'Y'

     C                   EVAL      Good_Item = 'Y'

      * Item selection criteria

     C                   EXSR      Item_Select
      * Write it
     C     Good_Item     CASEQ     'Y'           Write_Item
     C                   ENDCS
     C                   ENDIF

¢b   c     skipit2       tag
      * Section/group/category
     C                   IF        PR_PRCD92 <> *BLANKS
     C     SGC_KEY       READE     IVFMSTRD                               42
     C                   ELSE
      * Section/group
     C                   IF        PR_PRCD91 <> *BLANKS
     C     SG_KEY        READE     IVFMSTRD                               42
     C                   ELSE
      * Section
     C                   IF        PR_PRCD90 <> *BLANKS
     C     PR_PRCD90     READE     IVFMSTRD                               42
     C                   ELSE
      * All items on purchasing book
     C                   READ      IVFMSTRD                               42
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C     End_Cntr_book ENDSR

      *--------------------------------------------------------*
      * Subroutine Vnd_Spc_Items will read/write all items in  *
      * the Item Master File for a specific vendor.            *
      *--------------------------------------------------------*

     C     Vnd_Spc_Items BEGSR

     C     PR_APNO01     SETLL     IVFMSTR9
     C     PR_APNO01     READE     IVFMSTR9                               43
     C                   DOW       *IN43 = *OFF

¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 <> 'Y'
¢b   c                   goto      skipit_vnd
¢b   c                   endif
¢b   c                   if        not%found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'
¢b   c                   endif
¢b    * don't include if item not on a price sheet
¢b   c     kpsheet       chain     prlmpsd2
¢b   C                   if        not %found(prlmpsd2)
¢b   c                   move      'N'           Good_Item
¢b   c                   goto      skipit_vnd
¢b   C                   endif

     C                   EVAL      Good_Item = 'Y'

      * Check sales history
     C                   IF        PR_PRCD93 = 'Y'
     C                   EXSR      Sales_History
     C                   ENDIF
      * Check alias flag
     C                   IF        PR_PRCD95 = 'Y' AND Good_Item = 'Y'
     C                   EXSR      Chk_Ali_Item
     C                   ENDIF
      * Check if on contract
     C                   IF        PR_PRCD97 = 'C' AND Good_Item = 'Y'
     C                   EXSR      Item_On_Cntr
     C                   ENDIF
      * Check if on specific contract
     C                   IF        PR_PRCD97 = 'S' AND Good_Item = 'Y'
     C                   EXSR      Item_Spc_Cntr
     C                   ENDIF
      * Exclude item if on a contract
     C                   IF        PR_PRCD97 = 'E' AND Good_Item = 'Y'
     C                   EXSR      Item_Exc_Cntr
     C                   ENDIF

¢b    * Check if A B C item
¢b   C                   IF        inabc = 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_ABC
¢b   C                   ENDIF
¢b   C                   IF        indiso= 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_DISC
¢b   C                   ENDIF
¢b   C                   IF        Good_Item = 'Y'
¢b   C                   EXSR      chk_DONOTUSE
¢b   C                   ENDIF
     C                   IF        Good_Item = 'Y'
     C                   EXSR      Write_Item
     C                   ENDIF

¢b   c     skipit_vnd    tag
     C     PR_APNO01     READE     IVFMSTR9                               43
     C                   ENDDO

¢b   C                   if        invend2 <> *blanks
¢b   C                   exsr      vnd_spc_2
¢b   C                   endif
¢b   C                   if        invend3 <> *blanks
¢b   C                   exsr      vnd_spc_3
¢b   C                   endif
     C     End_Vendor    ENDSR

¢b    *--------------------------------------------------------*
¢b    * Subroutine vnd_spc_2                                   *
¢b    * Subroutine will read/write all items in                *
¢b    * the Item Master File for a specific vendor.            *
¢b    * Up to 3 specific vendors can be chosen by the user.    *
¢b    *--------------------------------------------------------*
¢b
¢b   C     vnd_spc_2     begsr
¢b   C                   MOVE      invend2       wkvendn           6 0
¢b   C     wkvendn       SETLL     IVFMSTR9
¢b   C     wkvendn       READE     IVFMSTR9                               43
¢b   C                   DOW       *IN43 = *OFF
¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 <> 'Y'
¢b   c                   goto      skipit_vnd2
¢b   c                   endif
¢b   c                   if        not%found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'
¢b   c                   goto      skipit_vnd2
¢b   c                   endif
¢b
¢b   C                   EVAL      Good_Item = 'Y'
¢b   C                   exsr      item_select
¢b   C                   IF        Good_Item = 'Y'
¢b   C                   EXSR      Write_Item
¢b   C                   ENDIF
¢b   c     skipit_vnd2   tag
¢b   C     wkvendn       READE     IVFMSTR9                               43
¢b   C                   ENDDO
¢b   C                   endsr
¢b
¢b
¢b    *--------------------------------------------------------*
¢b    * Subroutine vnd_spc_3                                   *
¢b    * Subroutine  will read/write all items in               *
¢b    * the Item Master File for a specific vendor.            *
¢b    * Up to 3 specific vendors can be chosen by the user.    *
¢b    *--------------------------------------------------------*
¢b
¢b   C     vnd_spc_3     begsr
¢b   C                   MOVE      invend3       wkvendn           6 0
¢b   C     wkvendn       SETLL     IVFMSTR9
¢b   C     wkvendn       READE     IVFMSTR9                               43
¢b   C                   DOW       *IN43 = *OFF
¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 <> 'Y'
¢b   c                   goto      skipit_vnd3
¢b   c                   endif
¢b   c                   if        not%found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'
¢b   c                   goto      skipit_vnd3
¢b   c                   endif
¢b
¢b   C                   EVAL      Good_Item = 'Y'
¢b   C                   exsr      item_select
¢b   C                   IF        Good_Item = 'Y'
¢b   C                   EXSR      Write_Item
¢b   C                   ENDIF
¢b   c     skipit_vnd3   tag
¢b   C     wkvendn       READE     IVFMSTR9                               43
¢b   C                   ENDDO
¢b
¢b   C                   endsr

      *--------------------------------------------------------*
      * Subroutine Sls_Hst_Items reads the entire Sales History*
      * file for the requested customer.  It will check the    *
      * invoice date if date range requested.                  *
      *--------------------------------------------------------*

     C     Sls_Hst_Items BEGSR
     C                   MOVE      Customer      Book_Customer
      * All sales within range by company
     C                   IF        Book_Customer = *ZEROS
     C     TOHY1_KEY     SETLL     OEFTOHY1
     C     BM_ARNO15     READE     OEFTOHY1                               90
     C                   ELSE
      * All sales within range by customer
     C     TOHY_KEY      SETLL     OEFTOHY
     C     Book_Customer READE     OEFTOHY                                90
     C                   ENDIF

     C                   DOW       *IN90 = *OFF
¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 <> 'Y'
¢b   c                   goto      skipit_sls
¢b   c                   endif
¢b   c                   if        not%found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'
¢b   c                   goto      skipit_sls
¢b   c                   endif
¢b    * don't include if item not on a price sheet
¢b   c     kpsheet       chain     prlmpsd2
¢b   C                   if        not %found(prlmpsd2)
¢b   c                   move      'N'           Good_Item
¢b   c                   goto      skipit_sls
¢b   C                   endif
      * Orders only
     C                   IF        OH_OECD08 = 'O'
      * Check date range
     C                   IF        SALES_DATE >= FROM_SDATE
     C                             AND SALES_DATE <= TO_SDATE
      * All items sold on order within range
     C     OH_OENO01     SETLL     OEFTOLY
     C     OH_OENO01     READE     OEFTOLY                                44
     C                   DOW       *IN44 = *OFF
      * Quantity shipped
     C                   IF        SH_OEQY03 > 0
      * Line item type
     C                   IF        SH_OECD09 <> 'N' AND SH_OECD09 <> 'C'
     C                             AND SH_OECD09 <> 'A' AND SH_OECD09 <> 'K'
     C                             AND SH_OECD09 <> 'X'

     C                   EVAL      Good_Item = 'N'
      * Check alias flag
     C     SH_IVNO07     CHAIN     IVFMSTR
     C                   IF        %FOUND AND IM_IVCD25 <> 'D'

     C                   EVAL      Good_Item = 'Y'

     C                   IF        PR_PRCD95 = 'Y'
     C                   EXSR      Chk_Ali_Item
     C                   ENDIF
      * Check if on contract
     C                   IF        PR_PRCD97 = 'C' AND Good_Item = 'Y'
     C                   EXSR      Item_On_Cntr
     C                   ENDIF
      * Check if on specific contract
     C                   IF        PR_PRCD97 = 'S' AND Good_Item = 'Y'
     C                   EXSR      Item_Spc_Cntr
     C                   ENDIF
      * Exclude item if on a contract
     C                   IF        PR_PRCD97 = 'E' AND Good_Item = 'Y'
     C                   EXSR      Item_Exc_Cntr
     C                   ENDIF
¢b    * Check if A B C item
¢b   C                   IF        inabc = 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_ABC
¢b   C                   ENDIF
¢b    * Check if discounted item
¢b   C                   IF        indiso= 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_Disc
¢b   C                   ENDIF
¢b
¢b    * Check if DONOTUSE item
¢b   C                   IF        Good_Item = 'Y'
¢b   C                   EXSR      chk_DONOTUSE
¢b   C                   ENDIF

     C                   IF        Good_Item = 'Y'
     C                   EXSR      Write_Item
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C     OH_OENO01     READE     OEFTOLY                                44
     C                   ENDDO

     C                   ENDIF
     C                   ENDIF
¢b   c     skipit_sls    tag
      * All sales within range by company
     C                   IF        Book_Customer = *ZEROS
     C     BM_ARNO15     READE     OEFTOHY1                               90
     C                   ELSE
      * All sales within range by customer
     C     Book_Customer READE     OEFTOHY                                90
     C                   ENDIF
      * Check if no longer in range
     C                   IF        SALES_DATE > TO_SDATE
     C                             OR SALES_DATE < FROM_SDATE
     C                   EVAL      *IN90 = *ON
     C                   ENDIF

     C                   ENDDO

     C     End_Sls_Hist  ENDSR

      *--------------------------------------------------------*
      * Subroutine Alias_Items will read/write all items that  *
      * have an alias attached to the processing customer.     *
      *--------------------------------------------------------*

     C     Alias_Items   BEGSR

     C                   MOVE      Customer      Book_Customer
     C     Book_Customer SETLL     IVFMALI
     C     Book_Customer READE     IVFMALI                                45
     C                   DOW       *IN45 = *OFF
¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 <> 'Y'
¢b   c                   goto      skipit_al
¢b   c                   endif
¢b   c                   if        not%found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'
¢b   c                   goto      skipit_al
¢b   c                   endif

     C                   EVAL      Good_Item = 'N'
     C     AI_IVNO07     CHAIN     IVFMSTR
     C                   IF        %FOUND AND IM_IVCD25 <> 'D'
     C                   EVAL      Good_Item = 'Y'
      * Check if on contract
     C                   IF        PR_PRCD97 = 'C'
     C                   EXSR      Item_On_Cntr
     C                   ENDIF
      * Check if on specific contract
     C                   IF        PR_PRCD97 = 'S'
     C                   EXSR      Item_Spc_Cntr
     C                   ENDIF
      * Exclude item if on a contract
     C                   IF        PR_PRCD97 = 'E'
     C                   EXSR      Item_Exc_Cntr
     C                   ENDIF
¢b    * Check if A B C item
¢b   C                   IF        inabc = 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_ABC
¢b   C                   ENDIF
¢b   C                   IF        indiso= 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_DISC
¢b   C                   ENDIF
¢b   C                   IF        Good_Item = 'Y'
¢b   C                   EXSR      chk_DONOTUSE
¢b   C                   ENDIF

     C                   IF        Good_Item = 'Y'
     C                   EXSR      Write_Item
     C                   ENDIF
     C                   ENDIF

¢b   c     skipit_al     tag
     C     Book_Customer READE     IVFMALI                                45
     C                   ENDDO

     C     End_Alias     ENDSR

      *--------------------------------------------------------*
      * Subroutine On_Cntr_Items will read those items attached*
      * to a current contract.                                 *
      *--------------------------------------------------------*

     C     On_Cntr_Items BEGSR
      * Customer attached to profile(s)
     C                   MOVE      Customer      Book_Customer
     C     Book_Customer SETLL     PRFMCPS
     C     Book_Customer READE     PRFMCPS                                46
     C                   DOW       *IN46 = *OFF
      * Current profile
     C     CS_PRNO12     CHAIN     PRFMCPH
     C                   IF        %FOUND AND CH_PRCD71 = 'C'
      * Profile's detail
     C     CH_PRNO12     SETLL     PRFMCPD
     C     CH_PRNO12     READE     PRFMCPD                                47
     C                   DOW       *IN47 = *OFF
      * Item level
     C                   IF        CD_IVNO07 <> 0
     C     CD_IVNO07     CHAIN     IVFMSTR
     C                   IF        %FOUND AND IM_IVCD25 <> 'D'
¢b    * Check if A B C item
¢b   C                   IF        inabc = 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_ABC
¢b   C                   ENDIF
¢b   C                   IF        indiso= 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_DISC
¢b   C                   ENDIF
¢b   C                   IF        Good_Item = 'Y'
¢b   C                   EXSR      chk_DONOTUSE
¢b   C                   ENDIF
¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 <> 'Y'
¢b   c                   goto      skipit_cntr
¢b   c                   endif
¢b   c                   if        not%found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'
¢b   c                   goto      skipit_cntr
¢b   c                   endif
¢b    * don't include if item not on a price sheet
¢b   c     kpsheet       chain     prlmpsd2
¢b   C                   if        not %found(prlmpsd2)
¢b   c                   move      'N'           Good_Item
¢b   c                   goto      skipit_cntr
¢b   C                   endif
     C                   EXSR      Write_Item
     C                   ENDIF
     C                   ELSE

      * Section/group/category
     C                   EVAL      PR_PRCD90 = CD_IVCD17
     C                   EVAL      PR_PRCD91 = CD_IVCD18
     C                   EVAL      PR_PRCD92 = CD_IVCD19

     C                   IF        PR_PRCD92 <> *BLANKS
     C     SGC_KEY       SETLL     IVFMSTRE
     C     SGC_KEY       READE     IVFMSTRE                               48
     C                   ELSE
      * Section/group
     C                   IF        PR_PRCD91 <> *BLANKS
     C     SG_KEY        SETLL     IVFMSTRE
     C     SG_KEY        READE     IVFMSTRE                               48
     C                   ELSE
      * Section
     C                   IF        PR_PRCD90 <> *BLANKS
     C     PR_PRCD90     SETLL     IVFMSTRE
     C     PR_PRCD90     READE     IVFMSTRE                               48
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * DOW Loop
     C                   DOW       *IN48 = *OFF
     C                   IF        IM_IVCD25 <> 'D'
¢b    * Check if A B C item
¢b   C                   IF        inabc = 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_ABC
¢b   C                   ENDIF
¢b   C                   IF        indiso= 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_DISC
¢b   C                   ENDIF
¢b   C                   IF        Good_Item = 'Y'
¢b   C                   EXSR      chk_DONOTUSE
¢b   C                   ENDIF
¢b    * don't include if item not on a price sheet
¢b   c     kpsheet       chain     prlmpsd2
¢b   C                   if        not %found(prlmpsd2)
¢b   c                   move      'N'           Good_Item
¢b   c                   goto      skipit_cntr
¢b   C                   endif

      * Write it
     C                   EXSR      Write_Item
     C                   ENDIF

¢b   c     skipit_cntr   tag
      * Section/group/category
     C                   IF        PR_PRCD92 <> *BLANKS
     C     SGC_KEY       READE     IVFMSTRE                               48
     C                   ELSE
      * Section/group
     C                   IF        PR_PRCD91 <> *BLANKS
     C     SG_KEY        READE     IVFMSTRE                               48
     C                   ELSE
      * Section
     C                   IF        PR_PRCD90 <> *BLANKS
     C     PR_PRCD90     READE     IVFMSTRE                               48
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO
     C
     C                   ENDIF

     C     CH_PRNO12     READE     PRFMCPD                                47
     C                   ENDDO

     C                   ENDIF

     C     Book_Customer READE     PRFMCPS                                46
     C                   ENDDO


     C                   ENDSR

      *--------------------------------------------------------*
      * Subroutine Cnt_Spc_Items will read those items attached*
      * to a specified contract.                               *
      *--------------------------------------------------------*

     C     Cnt_Spc_Items BEGSR

     C     MCPH_KEY      CHAIN     PRFMCPH1
     C                   IF        %FOUND AND CH_PRCD71 = 'C'
      * Profile's detail
     C     CH_PRNO12     SETLL     PRFMCPD
     C     CH_PRNO12     READE     PRFMCPD                                47
     C                   DOW       *IN47 = *OFF
      * Item level
     C                   IF        CD_IVNO07 <> 0
     C     CD_IVNO07     CHAIN     IVFMSTR
     C                   IF        %FOUND AND IM_IVCD25 <> 'D'
     C                   EXSR      Write_Item
     C                   ENDIF
     C                   ELSE

      * Section/group/category
     C                   EVAL      PR_PRCD90 = CD_IVCD17
     C                   EVAL      PR_PRCD91 = CD_IVCD18
     C                   EVAL      PR_PRCD92 = CD_IVCD19

     C                   IF        PR_PRCD92 <> *BLANKS
     C     SGC_KEY       SETLL     IVFMSTRE
     C     SGC_KEY       READE     IVFMSTRE                               48
     C                   ELSE
      * Section/group
     C                   IF        PR_PRCD91 <> *BLANKS
     C     SG_KEY        SETLL     IVFMSTRE
     C     SG_KEY        READE     IVFMSTRE                               48
     C                   ELSE
      * Section
     C                   IF        PR_PRCD90 <> *BLANKS
     C     PR_PRCD90     SETLL     IVFMSTRE
     C     PR_PRCD90     READE     IVFMSTRE                               48
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * DOW Loop
     C                   DOW       *IN48 = *OFF
¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 <> 'Y'
¢b   c                   goto      skipit_spc
¢b   c                   endif
¢b   c                   if        not%found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'
¢b   c                   goto      skipit_spc
¢b   c                   endif
¢b    * Check if A B C item
¢b   C                   IF        inabc = 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_ABC
¢b   C                   ENDIF
¢b   C                   IF        indiso= 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_DISC
¢b   C                   ENDIF
¢b   C                   IF        Good_Item = 'Y'
¢b   C                   EXSR      chk_DONOTUSE
¢b   C                   ENDIF
¢b    * don't include if item not on a price sheet
¢b   c     kpsheet       chain     prlmpsd2
¢b   C                   if        not %found(prlmpsd2)
¢b   c                   move      'N'           Good_Item
¢b   c                   goto      skipit_spc
¢b   C                   endif

     C                   IF        IM_IVCD25 <> 'D'
      * Write it
     C                   EXSR      Write_Item
     C                   ENDIF
¢b   c     skipit_spc    tag

      * Section/group/category
     C                   IF        PR_PRCD92 <> *BLANKS
     C     SGC_KEY       READE     IVFMSTRE                               48
     C                   ELSE
      * Section/group
     C                   IF        PR_PRCD91 <> *BLANKS
     C     SG_KEY        READE     IVFMSTRE                               48
     C                   ELSE
      * Section
     C                   IF        PR_PRCD90 <> *BLANKS
     C     PR_PRCD90     READE     IVFMSTRE                               48
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO
     C
     C                   ENDIF

     C     CH_PRNO12     READE     PRFMCPD                                47
     C                   ENDDO

     C                   ENDIF

     C     End_Cnt_Spc   ENDSR

      *--------------------------------------------------------*
      * Subroutine Exc_Cnt_Items will exclude items that are   *
      * attached to a current contract.                        *
      *--------------------------------------------------------*

     C     Exc_Cnt_Items BEGSR

     C                   EXSR      Bld_Cnt_Prf

     C                   READ      IVFMSTR                                60
     C                   DOW       *IN60 = *OFF
¢b   c* do not include if stocking code <> Y (ivcd11)
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'  and
¢b   c                             bi_ivcd11 <> 'Y'
¢b   c                   goto      skipit_cit
¢b   c                   endif
¢b   c                   if        not%found(ivlmsbr2) and
¢b   c                             instocky  = 'Y'
¢b   c                   goto      skipit_cit
¢b   c                   endif

     C                   EVAL      *IN46 = *OFF
     C                   EVAL      ELEM = 0

      * Omit deleted records
     C                   IF        IM_IVCD25 <> 'D'
     C                   EVAL      Good_Item = 'Y'
      * Read array
     C                   DOW       *IN46 = *OFF
     C                   EVAL      ELEM = ELEM + 1
     C                   IF        PRF(ELEM) <> *ZEROS
     C                   MOVEA     PRF(ELEM)     CH_PRNO12
      * Exclude item if found by s/g/c/i
     C                   EVAL      KList_Sec  = IM_IVCD17
     C                   EVAL      KList_Grp  = IM_IVCD18
     C                   EVAL      KList_Cat  = IM_IVCD19
     C                   EVAL      KList_Item = IM_IVNO07
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'N'
     C                   ENDIF
      * Exclude item if found by s/g/c
     C                   IF        Good_Item = 'Y'
     C                   EVAL      KList_Item = *ZEROS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'N'
     C                   ENDIF
     C                   ENDIF
      * Exclude item if found by s/g
     C                   IF        Good_Item = 'Y'
     C                   EVAL      KList_Cat = *BLANKS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'N'
     C                   ENDIF
     C                   ENDIF
      * Exclude item if found by section
     C                   IF        Good_Item = 'Y'
     C                   EVAL      KList_Grp = *BLANKS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   IF        Good_Item = 'N' OR PRF(ELEM) = *ZEROS
     C                   EVAL      *IN46 = *ON
     C                   ENDIF

     C                   ENDDO

     C                   IF        Good_Item = 'Y'
¢b    * Check if A B C item
¢b   C                   IF        inabc = 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_ABC
¢b   C                   ENDIF
¢b   C                   IF        indiso= 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_DISC
¢b   C                   ENDIF
¢b   C                   IF        Good_Item = 'Y'
¢b   C                   EXSR      chk_DONOTUSE
¢b   C                   ENDIF
     C                   EXSR      Write_Item
     C                   ENDIF

     C                   ENDIF

¢b   c     skipit_cit    tag
     C                   READ      IVFMSTR                                60
     C                   ENDDO

     C     End_Exclude   ENDSR

      *--------------------------------------------------------*
      * Subroutine Bld_Cnt_Prf will build an array of current  *
      * contract profiles for the requested customer.  This is *
      * eliminate reads.                                       *
      *--------------------------------------------------------*

     C     Bld_Cnt_Prf   BEGSR

      * Customer attached to profile(s)
     C                   MOVE      Customer      Book_Customer
     C     Book_Customer SETLL     PRFMCPS
     C     Book_Customer READE     PRFMCPS                                46
     C                   DOW       *IN46 = *OFF
      * Current profile
     C     CS_PRNO12     CHAIN     PRFMCPH
     C                   IF        %FOUND AND CH_PRCD71 = 'C'

      * Add to array
     C                   EVAL      ELEM = 1 + ELEM
     C                   MOVEA     CH_PRNO12     PRF(ELEM)
     C                   ENDIF

     C     Book_Customer READE     PRFMCPS                                46
     C                   ENDDO

     C     End_Bld_Prf   ENDSR

      *--------------------------------------------------------*
      * Subroutine Item_Selection will determine if product    *
      * is to be written to the data base file.                *
      *--------------------------------------------------------*

     C     Item_Select   BEGSR
      * Vendor specific
     C                   IF        PR_PRCD94 = 'Y'

¢b   C*                  IF        PR_APNO01 = IM_IVNO05
¢b   C                   IF        PR_APNO01 = IM_IVNO05 or
¢b   c                             IM_IVNO05 = wkvend2 or
¢b   c                             IM_IVNO05 = wkvend3
     C                   EVAL      Good_Item = 'Y'
     C                   ELSE
     C                   EVAL      Good_Item = 'N'
     C                   ENDIF

     C                   ENDIF
      * Check sales history
     C                   IF        PR_PRCD93 = 'Y' AND Good_Item = 'Y'
     C                   EXSR      Sales_History
     C                   ENDIF
      * Check alias flag
     C                   IF        PR_PRCD95 = 'Y' AND Good_Item = 'Y'
     C                   EXSR      Chk_Ali_Item
     C                   ENDIF
      * Check if on contract
     C                   IF        PR_PRCD97 = 'C' AND Good_Item = 'Y'
     C                   EXSR      Item_On_Cntr
     C                   ENDIF
      * Check if on specific contract
     C                   IF        PR_PRCD97 = 'S' AND Good_Item = 'Y'
     C                   EXSR      Item_Spc_Cntr
     C                   ENDIF
      * Exclude item if on a contract
     C                   IF        PR_PRCD97 = 'E' AND Good_Item = 'Y'
     C                   EXSR      Item_Exc_Cntr
     C                   ENDIF

¢b    * Check if A B C item
¢b   C                   IF        inabc = 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_ABC
¢b   C                   ENDIF
¢b    * Check if discounted item
¢b   C                   IF        indiso= 'Y' AND Good_Item = 'Y'
¢b   C                   EXSR      chk_Disc
¢b   C                   ENDIF
¢b
¢b    * Check if DONOTUSE item
¢b   C                   IF        Good_Item = 'Y'
¢b   C                   EXSR      chk_DONOTUSE
¢b   C                   ENDIF
¢b
¢b    * exclude if not on current pricesheet:
¢b   c                   if        Good_Item = 'Y'
¢b   c     kpsheet       chain     prlmpsd2
¢b   C                   if        not %found(prlmpsd2)
¢b   c                   move      'N'           Good_Item
¢b   C                   endif
¢b   c                   endif
¢b    * check for in_stock flag
¢b
¢b   c                   if        instocky =  'Y'
¢b   C     bri_key       chain     ivlmsbr2
¢b   c                   if        (%found(ivlmsbr2) and
¢b   c                             bi_ivcd11 <> 'Y') or
¢b   c                             not %found(ivlmsbr2)
¢b   c                   move      'N'           Good_Item
¢b   c                   endif
¢b   c                   endif
     C     Done_w_Item   ENDSR

      *--------------------------------------------------------*
      * Subroutine Sales_History will determine if item has    *
      * been sold within date range specified.                 *
      *    Logical File Omits the following:                   *
      *       OECD08 = 'C' Credit Memos and 'D' Debit Memos    *
      *       OECD09 = 'N' Nonstock, 'C' Comments,             *
      *                'A' Combination,                        *
      *                'K' Non-Stock Combination               *
      *                'X' Non-Stock Components                *
      *--------------------------------------------------------*

     C     Sales_History BEGSR

     C                   EVAL      Good_Item = 'N'

     C                   MOVE      Customer      Book_Customer
      * All sales within range by item
     C                   IF        Book_Customer = *ZEROS
     C     IM_IVNO07     SETLL     OEFTOLY3
     C     IM_IVNO07     READE     OEFTOLY3                               90
     C                   ELSE
      * All sales within range by customer
     C     TOLY_KEY_2    SETLL     OEFTOLY2
     C     TOLY_KEY_2    READE     OEFTOLY2                               90
     C                   ENDIF

     C                   DOW       *IN90 = *OFF
      * Orders only
     C                   IF        SH_OECD08 = 'O'
      * Line item type
     C                   IF        SH_OECD09 <> 'N' AND SH_OECD09 <> 'C'
     C                             AND SH_OECD09 <> 'A' AND SH_OECD09 <> 'K'
     C                             AND SH_OECD09 <> 'X'
      * Quantity shipped
     C                   IF        SH_OEQY03 > 0
      * Date range
     C     SH_OENO01     CHAIN     OEFTOHYH
     C                   IF        %FOUND AND SALES_DATE >= FROM_SDATE
     C                             AND SALES_DATE <= TO_SDATE

     C                   EVAL      Good_Item = 'Y'

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        Book_Customer = *ZEROS
     C     IM_IVNO07     READE     OEFTOLY3                               90
     C                   ELSE
     C     TOLY_KEY_2    READE     OEFTOLY2                               90
     C                   ENDIF

     C                   ENDDO

     C     End_Sales     ENDSR

      *--------------------------------------------------------*
      * Subroutine Item_On_Cntr will select the item if on a   *
      * contract for the requested customer.                   *
      *--------------------------------------------------------*

     C     Item_On_Cntr  BEGSR

     C                   EVAL      Good_Item = 'N'
     C                   MOVE      Customer      Book_Customer

      * Customer attached to profile(s)
     C     Book_Customer SETLL     PRFMCPS
     C     Book_Customer READE     PRFMCPS                                46
     C                   DOW       *IN46 = *OFF
      * Current profile
     C     CS_PRNO12     CHAIN     PRFMCPH
     C                   IF        %FOUND AND CH_PRCD71 = 'C'
      * Check if item is on contract (Purch s/g/c/i)
     C                   EVAL      KList_Sec  = IM_IVCD17
     C                   EVAL      KList_Grp  = IM_IVCD18
     C                   EVAL      KList_Cat  = IM_IVCD19
     C                   EVAL      KList_Item = IM_IVNO07
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'Y'
     C                   ELSE
      * Check if item is on contract (Purch s/g/c)
     C                   EVAL      KList_Item = *ZEROS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'Y'
     C                   ELSE
      * Check if item is on contract (Purch s/g)
     C                   EVAL      KList_Cat = *BLANKS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'Y'
     C                   ELSE
      * Check if item is on contract (Purch sec)
     C                   EVAL      KList_Grp = *BLANKS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'Y'

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        Good_Item = 'N'
     C     Book_Customer READE     PRFMCPS                                46
     C                   ELSE
     C                   EVAL      *IN46 = *ON
     C                   ENDIF
     C                   ENDDO

     C     End_Itm_Cntr  ENDSR

      *--------------------------------------------------------*
      * Subroutine Item_Spc_Cntr will select the item if on a  *
      * specific contract for the requested customer.          *
      *--------------------------------------------------------*

     C     Item_Spc_Cntr BEGSR

     C                   EVAL      Good_Item = 'N'

     C     MCPH_KEY      CHAIN     PRFMCPH1
     C                   IF        %FOUND AND CH_PRCD71 = 'C'
      * Check if item is on contract (Purch s/g/c/i)
     C                   EVAL      KList_Sec  = IM_IVCD17
     C                   EVAL      KList_Grp  = IM_IVCD18
     C                   EVAL      KList_Cat  = IM_IVCD19
     C                   EVAL      KList_Item = IM_IVNO07
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'Y'
     C                   ELSE
      * Check if item is on contract (Purch s/g/c)
     C                   EVAL      KList_Item = *ZEROS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'Y'
     C                   ELSE
      * Check if item is on contract (Purch s/g)
     C                   EVAL      KList_Cat = *BLANKS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'Y'
     C                   ELSE
      * Check if item is on contract (Purch sec)
     C                   EVAL      KList_Grp = *BLANKS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'Y'

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDIF

     C     End_Spc_Cntr  ENDSR

      *--------------------------------------------------------*
      * Subroutine Item_Exc_Cntr will select the item if not on*
      * a current contract for the requested customer.         *
      *--------------------------------------------------------*

     C     Item_Exc_Cntr BEGSR

     C                   EVAL      Good_Item = 'Y'
     C                   MOVE      Customer      Book_Customer
      * Customer attached to profile(s)
     C     Book_Customer SETLL     PRFMCPS
     C     Book_Customer READE     PRFMCPS                                46
     C                   DOW       *IN46 = *OFF
      * Current profile
     C     CS_PRNO12     CHAIN     PRFMCPH
     C                   IF        %FOUND AND CH_PRCD71 = 'C'
      * Exclude item if found by s/g/c/i
     C                   EVAL      KList_Sec  = IM_IVCD17
     C                   EVAL      KList_Grp  = IM_IVCD18
     C                   EVAL      KList_Cat  = IM_IVCD19
     C                   EVAL      KList_Item = IM_IVNO07
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'N'
     C                   ENDIF
      * Exclude item if found by s/g/c
     C                   IF        Good_Item = 'Y'
     C                   EVAL      KList_Item = *ZEROS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'N'
     C                   ENDIF
     C                   ENDIF
      * Exclude item if found by s/g
     C                   IF        Good_Item = 'Y'
     C                   EVAL      KList_Cat = *BLANKS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'N'
     C                   ENDIF
     C                   ENDIF
      * Exclude item if found by section
     C                   IF        Good_Item = 'Y'
     C                   EVAL      KList_Grp = *BLANKS
     C     MCPD_KEY      CHAIN     PRFMCPD
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   IF        Good_Item = 'N'
     C     Book_Customer READE     PRFMCPS                                46
     C                   ELSE
     C                   EVAL      *IN46 = *ON
     C                   ENDIF
     C                   ENDDO

     C     Good_Item     CASEQ     'Y'           Write_Item
     C                   ENDCS

     C     End_Exc_Cntr  ENDSR

¢b    *--------------------------------------------------------*
¢b    * Subroutine Chk_ABC       will select the item if it is *
¢b    * an A B C item in the branch-item master.               *
¢b    *--------------------------------------------------------*
¢b   C     Chk_ABC       BEGSR
¢b   C                   eval      Good_Item = 'N'
¢b   C                   eval      abc_item  = im_ivno07
¢b   C                   eval      abc_bran  = pr_arno16
¢b   C     abc_key       chain     ivlmsbr2
¢b   c                   if        %found(ivlmsbr2)
¢b   c                             and (bi_ivcd38 = 'A'
¢b   c                                 or bi_ivcd38 = 'B'
¢b   c                                 or bi_ivcd38 = 'C')
¢b   C                   move      'Y'           Good_Item
¢b   c                   endif
¢b   C                   ENDSR
¢b    *--------------------------------------------------------*
¢b    * Subroutine Chk_DISC      will check if   item       is *
¢b    * on a Customer, profile or contract discount.           *
¢b    *--------------------------------------------------------*
¢b   C     Chk_DISC      BEGSR
¢b   C                   eval      Good_Item = 'N'
¢b   C     sgci_key4     chain     prlmcpfO
¢b   c                   if        %found(prlmcpfO)
¢b   C                   move      'Y'           Good_Item
¢b   c                   else
¢b   C     sgci_key3     chain     prlmcpfO
¢b   c                   if        %found(prlmcpfO)
¢b   C                             and dc_ivno07 = 0
¢b   C                   move      'Y'           Good_Item
¢b   c                   else
¢b   C     sgci_key2     chain     prlmcpfO
¢b   c                   if        %found(prlmcpfO)
¢b   C                             and dc_ivno07 = 0
¢b   C                             and dc_ivcd19 = *blanks
¢b   C                   move      'Y'           Good_Item
¢b   c                   else
¢b   C     sgci_key1     chain     prlmcpfO
¢b   c                   if        %found(prlmcpfO)
¢b   C                             and dc_ivno07 = 0
¢b   C                             and dc_ivcd18 = *blanks
¢b   C                             and dc_ivcd19 = *blanks
¢b   C                   move      'Y'           Good_Item
¢b   c                   endif
¢b   c                   endif
¢b   c                   endif
¢b   c                   endif
¢b   c                   if        good_item = 'N'
¢b   c                   exsr      Item_On_Cntr
¢b   c                   endif
¢B   C                   ENDSR
¢b    *--------------------------------------------------------*
¢b    * Subroutine Chk_Donotuse  will check if   item       is *
¢b    * now obsolete                                           *
¢b    *--------------------------------------------------------*
¢b   C     Chk_Donotuse  BEGSR
¢b   C                   eval      Good_Item = 'N'
¢b   C                   If        %scan( 'DO NOT USE' : IM_IVDN01 ) = 0
¢b   C                   If        %scan( 'OBSOLETE' : IM_IVDN01 ) = 0
¢b   C*                  If        %scan( 'LABOR' : IM_IVDN01 ) = 0
¢b   c                   if        im_ivcd14 <> 'EXC'
¢b   c                   if        im_ivcd18 <> 'EMB'
¢b   c                   if        im_ivcd17 <> 'OBS'
¢b   c                   if        im_ivcd17 <> 'GMO'
¢b   C                   eval      Good_Item = 'Y'
¢b   c                   end
¢b   c                   end
¢b   c                   end
¢b   c                   end
¢b   c                   end
¢b   c                   end
¢B   C                   ENDSR
      *--------------------------------------------------------*
      * Subroutine Chk_Ali_Item will select the item if alias  *
      * is setup for the requested customer.                   *
      *--------------------------------------------------------*

     C     Chk_Ali_Item  BEGSR

     C                   EVAL      Good_Item = 'N'

     C                   EVAL      AI_IVNO41 = *BLANKS
     C                   EVAL      AI_ARNO01 = *ZEROS
      * Check customer
     C                   MOVE      Customer      Book_Customer
     C     MALI_KEY      CHAIN     IVFMALI
     C                   IF        %FOUND
     C                   EVAL      Good_Item = 'Y'
     C                   ENDIF

     C     End_Alias_Itm ENDSR

      *--------------------------------------------------------*
      * Subroutine Write_Item will write the items that met the*
      * selection criteria to the work file.  It will then     *
      * price the item.                                        *
      *--------------------------------------------------------*

     C     Write_Item    BEGSR
      * Pricing UOM
     C                   EVAL      UM_IVCD08 = 'P'
     C     MUOM_KEY      CHAIN     IVFMUOM

     C                   IF        Disc_Prof_1 = *BLANKS
     C                   MOVE      Customer      Book_Customer
      * Customer
     C     PRBK_KEY      CHAIN     PRFPRBK
     C                   IF        NOT %FOUND
     C                   EXSR      Write_Record
     C                   ENDIF

     C                   ELSE

      * Write one record per requested discount profile

     C                   EVAL      Disc_Prof = Disc_Prof_1
     C     PRBK_KEY      CHAIN     PRFPRBK
     C                   IF        NOT %FOUND
     C                   EXSR      Write_Record
     C                   ENDIF

     C                   IF        Disc_Prof_2 <> *BLANKS
     C                   EVAL      Disc_Prof = Disc_Prof_2
     C     PRBK_KEY      CHAIN     PRFPRBK
     C                   IF        NOT %FOUND
     C                   EXSR      Write_Record
     C                   ENDIF
     C                   ENDIF

     C                   IF        Disc_Prof_3 <> *BLANKS
     C                   EVAL      Disc_Prof = Disc_Prof_3
     C     PRBK_KEY      CHAIN     PRFPRBK
     C                   IF        NOT %FOUND
     C                   EXSR      Write_Record
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C     End_Write     ENDSR

      *--------------------------------------------------------*
      * Subroutine Write_Record will write the record to files *
      * (Bid files and Price Book File)                        *
      *--------------------------------------------------------*

     C     Write_Record  BEGSR

     C                   EVAL      SV_CNTLIN = 1
     C                   EVAL      SV_ORDQTY = 1
     C                   EVAL      SV_ORDITM = IM_IVNO04
     C                   EVAL      SV_ORDREL = 0
     C                   EVAL      SV_ORDSHP = 0
     C                   EVAL      SV_ORDBKO = 0
     C                   EVAL      SV_ORDDSC = IM_IVDN01
     C                   EVAL      SV_ORDAM1 = 0
     C                   EVAL      SV_ORDAM2 = 0
     C                   EVAL      SV_ORDPC1 = *BLANKS
     C                   EVAL      SV_ORDICT = 'P'
     C                   EVAL      SV_ORDDN2 = UM_IVDN21
     C                   EVAL      SV_ORDNO7 = IM_IVNO07
     C                   EVAL      SV_ORDN23 = 0
     C                   EVAL      SV_ORDC26 = ' '
     C                   EVAL      SV_ORDC27 = ' '
     C                   EVAL      SV_ORDC28 = ' '
     C                   EVAL      SV_ORDDN4 = IM_IVDN20
     C                   EVAL      SV_ORDAM5 = 0
     C                   EVAL      SV_DSEXT  = 'N'
     C                   EVAL      SV_ORDCMP = ' '
     C                   EVAL      SV_ORDCQY = 0
     C                   EVAL      SV_ORDALI = ' '
     C                   EVAL      SV_ORDOLN = 0
     C                   EVAL      SV_ORNSA  = ' '
     C                   EVAL      SV_ORSTK  = ' '
     C                   EVAL      SV_ORDSBR = PR_ARNO16
     C                   EVAL      SV_ORDDIR = ' '
     C                   EVAL      SV_ORDSEL = ' '
     C                   EVAL      SV_ORDT@H = 0
     C                   EVAL      SV_ORDPC4 = 0
     C                   EVAL      SV_ORDSVB = PR_ARNO16
     C                   EVAL      SV_ORDSVD = *BLANKS
     C                   EVAL      SV_ORDAM8 = 0
     C                   EVAL      SV_ORDN37 = *BLANKS
     C                   EVAL      SV_ORDGP@ = *BLANKS
     C                   EVAL      SV_ORDQY  = 0
     C                   EVAL      SV_ORDEXC = 0
     C                   EVAL      SV_ORDWAC = 0
     C                   EVAL      SV_ORDEXW = 0
     C                   EVAL      SV_ORGLIN = 0
     C                   EVAL      SV_ORDC31 = 'Y'
     C                   EVAL      SV_ORDRH  = ' '
     C                   EVAL      SV_PKG#   = *BLANKS
     C                   EVAL      SV_ORDN36 = 10
     C                   EVAL      SV_ORDDUP = ' '
     C                   EVAL      SV_OECD43 = ' '
     C                   EVAL      SV_ORDUAD = ' '
     C                   EVAL      SV_ORDSAC = *BLANKS
     C                   EVAL      SV_ORDCO$ = 0
     C                   EVAL      SV_ORSV31 = ' '
     C                   EVAL      SV_CHKCBK = ' '
     C                   EVAL      SV_ORDY17 = 1
     C                   EVAL      SV_ORDM38 = 0
     C                   EVAL      SV_ORDM39 = 0
     C                   EVAL      SV_ORDM40 = 0
     C                   EVAL      SV_ORDM41 = 0
     C                   EVAL      SV_ORDM42 = 0
     C                   EVAL      SV_ORDQ17 = 1
     C                   EVAL      SV_ORDSVU = IM_IVDN20
     C                   EVAL      SV_ORDPC7 = 0
     C                   EVAL      SV_ORDSV7 = 0
     C                   EVAL      SV_ORDC66 = ' '
     C                   EVAL      SV_OROFCT = 1.0
     C                   EVAL      SV_ORPFCT = UM_IVQY12
     C                   EVAL      SV_ORCSEQ = 0
   ABC*                  EVAL      SV_ORNO01 = 0
AB   C                   EVAL      SV_ORNO01 = *ZEROS
     C                   EVAL      SV_ORDP22 = 0
     C                   EVAL      SV_ORDP23 = 0
     C                   EVAL      SV_ORDP24 = 0
     C                   EVAL      SV_ORDP25 = 0
     C                   EVAL      SV_ORDC70 = *BLANKS
     C                   EVAL      SV_ORCREF = *BLANKS
     C                   EVAL      SV_ORDN52 = 0
     C                   EVAL      SV_ORDN53 = 0
     C                   EVAL      SV_ORDN54 = 0
     C                   EVAL      SV_ORDN55 = 0
     C                   EVAL      SV_ORSVPR = 0
     C                   EVAL      SV_ORDC84 = ' '
     C                   EVAL      SV_ORDC47 = ' '
     C                   EVAL      SV_ORDC72 = ' '
     C                   EVAL      SV_ORDC73 = *BLANKS
     C                   EVAL      SV_ORNO56 = 0
     C                   EVAL      SV_ORINV$ = 0
     C                   EVAL      SV_ORUNI$ = 0
     C                   EVAL      SV_ORDPO# = 0
     C                   EVAL      SV_ORDPN5 = 0
     C                   EVAL      SV_ORDVSC = *ZEROS
     C                   EVAL      SV_ORPRCH = ' '
     C                   EVAL      SV_ORWRFQ = ' '
     C                   EVAL      SV_ERNO22 = *BLANKS
     C                   EVAL      SV_ORDZZ@ = ' '
     C                   EVAL      SV_ORDSEC = '   '
     C                   EVAL      SV_ORDGRP = '   '
     C                   EVAL      SV_ORDCAT = '   '
     C                   WRITE     OEFWSVM
      * Price items
     C                   MOVE      PR_ARNO16     BRNNBR
AJ   C                   EVAL      PB_PRNO03 = Disc_Prof
AK   C                   move      Customer      PR_ARNO01
     C                   CALL      'PRR4950'     PL4950
     C                   EVAL      SV_CNTLIN = 1
     C     SV_CNTLIN     CHAIN     OEFWSVM
     C                   IF        %FOUND
      * Price book
     C                   EVAL      PB_PRNO22 = PR_PRNO22
     C                   EVAL      PB_ARNO01 = Book_Customer
     C                   EVAL      PB_IVNO07 = IM_IVNO07
     C                   EVAL      PB_PRNO03 = Disc_Prof
     C                   EVAL      PB_IVNO04 = IM_IVNO04
     C                   EVAL      PB_PRCD90 = *BLANKS
     C                   EVAL      PB_PRCD91 = *BLANKS
     C                   EVAL      PB_PRCD92 = *BLANKS
     C                   EVAL      PB_IVNO06 = 0
     C                   EVAL      PB_IVNO20 = 0
      * Update with request section/group/category
     C                   IF        PR_PRCD89 = 'P'
     C                   EVAL      PB_PRCD90 = IM_IVCD17
     C                   EVAL      PB_PRCD91 = IM_IVCD18
     C                   EVAL      PB_PRCD92 = IM_IVCD19
     C                   EVAL      PB_IVNO20 = IM_IVNO20
     C                   ENDIF
     C                   IF        PR_PRCD89 = 'C'
     C                   EVAL      PB_PRCD90 = IM_IVCD01
     C                   EVAL      PB_PRCD91 = IM_IVCD02
     C                   EVAL      PB_PRCD92 = IM_IVCD03
     C                   EVAL      PB_IVNO06 = IM_IVNO06
     C                   ENDIF

      * Always retrieve alias
     C                   EVAL      AI_IVNO41 = *blanks
     C                   MOVE      Customer      Book_Customer
     C     MALI_KEY      CHAIN     IVFMALI
     C                   EVAL      PB_IVNO41 = AI_IVNO41

   AFC*                  EVAL      PB_OEAM01 = SV_ORDAM1
AF ANC*                  EVAL      PB_PRAM17 = SV_ORDAM1
AN    * Use larger field PRAM56 instead of PRAM17
AN   C                   EVAL      PB_PRAM17 = 0
AN   C                   EVAL      PB_PRAM56 = SV_ORDAM1
   AA * Factor up if WAC
   AAC*                  IF        PR_PRCDA6 = 'W'
   AAC*                  EVAL      SV_ORDAM2 = SV_ORDAM2 * UM_IVQY12
   AAC*                  ENDIF
     C                   EVAL      PB_OEAM02 = SV_ORDAM2

     C                   EVAL      PB_OEPC01 = SV_ORDPC1
     C                   EVAL      PB_IVDN02 = UM_IVDN21
     C                   EVAL      PB_OEDN04 = IM_IVDN20
     C                   WRITE     PRFPRBK
      * Close/clean up
     C                   DELETE    OEFWSVM
     C                   ENDIF

     C     End_Rcd_Wrt   ENDSR
** ARD
CLRPFM FILE(QTEMP/PRP4950)
