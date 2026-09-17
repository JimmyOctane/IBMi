¢I   H OPTION(*SRCSTMT : *NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - ECR9970                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983, 1990, 1992, 1997.                   *
     F*------------------------------------------------------------------------*
     F*D calculate cost based on input of item/price                           *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    custom for GMC and AMN                                             *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V KSB   5894 030613 000 Initial pgm                                     *
¢b   F*V KSB   5931 072413 000 add GMC outboarding                             *
¢c   F*V KSB   5936 080813 000 fix divide by zero                              *
¢d   F*V KSB   8000 033114 000 price round for GCO                             *
¢E   F*C DCB   7009 061214 DCB AMANA 22 GEORGIA                                *
¢F   F*C DCB   7045 031015 DCB ADD AMANA COST REBATE PERCENT                   *
¢G   F*C CLP   6303 040115 CLP Corrected div by 0 when IVAM01=0                *
¢H   F*C CLP   6312 041415 CLP Calculate cost rebate on selling price for      *
¢H   F*C                       manf AMHH8% items at 8%                         *
¢I   F*C CLP   6471 033116 CLP Automate default rebate logic based on values   *
¢I   F*C                       in their rebate table                           *
¢J   F*C CLP   6495 062116 CLP Update Amana margin from 3% to 2.9% and AMH80s  *
¢J   F*C                       margin from 8% to 7.6%                          *
¢K   F*C KSB   8011 090116 KSB upd gmc and amn table logic more dec            *
¢L   F*C KSB   8019 080417 KSB Omit Aspen Coils                                *
¢M   F*C CLP   6640 081517 CLP Direct Daikin DX and DZ LCUs to use the         *
¢M   F*C                       D table for rebate calculations                 *
¢N   F*C KSB   8022 082817 KSB Expand rebate table dec pos and remove          *
¢N   F*C                       code for old 'R' table. Add ductless table      *
¢M   F*C APB   9029 091417 APB Changed logical over ivpmstr                    *
¢o   F*C ksb   8052 091919 ksb special rebate calc for cust 234369             *
¢P   F*C CLP   6873 020420 CLP special rebate calc for cust 220222             *
     F*====================MINCRON UPGRADE TO 12.1=============================*
¢Q   F*C DCB   7220 021720 DCB GMC CONTRACT PROFILE PRICE CHANGE               *
¢R   F*C CLP   6880 022120 CLP special rebate calc for cust 229251             *
¢S   F*C JJF   3015 062623 JJF on "G" records we added new records below .45   *
¢S   F*C                       need to change this program to allow below .45  *
     F*M ----------------------------------------------------------------------*
¢M   FIVLMSTRK  IF   E           K DISK
¢F   FSAPAMNR   IF   E           K DISK
¢b   FSAPGMCOUT IF   E           K DISK

¢I   C     *LIKE         DEFINE    MU_PCT        MAX_MU_PCT
¢I   C     *LIKE         DEFINE    MU_PCT        MIN_MU_PCT
¢I   C     *LIKE         DEFINE    SELMUL        MAX_SELL_D
¢I   C     *LIKE         DEFINE    SELMUL        MIN_SELL_D
¢I   C     *LIKE         DEFINE    SELMUL        MAX_SELL_L
¢I   C     *LIKE         DEFINE    SELMUL        MIN_SELL_L
¢n   C     *LIKE         DEFINE    SELMUL        MAX_SELL_G
¢n   C     *LIKE         DEFINE    SELMUL        MIN_SELL_G
¢I   C     *LIKE         DEFINE    SELMUL        MAX_SELL
¢I   C     *LIKE         DEFINE    SELMUL        MIN_SELL
¢N   C     *LIKE         DEFINE    SELMUL        GMSELL
¢o   C     *LIKE         DEFINE    IVNO05        CUST

¢b   c
¢b   C     GMCKEY        KLIST                                                  TABLE FILE
¢b   C                   KFLD                    GMTYPE                         ENTRY 1
¢N   C                   KFLD                    GMSELL                         ENTRY 2
     C     *ENTRY        PLIST
     C                   PARM                    IVNO07                         item#
     C                   PARM                    OEAM01            8 2          price
     C                   PARM                    OEAM02            7 2          cost
¢E   C                   PARM                    SELLBR            3 0
¢o   C                   PARM                    CUST
     C                   PARM                    RESULT            1
¢Q   C                   PARM                    JOBNO             7
¢E ¢F *
¢E ¢F *
     c     ivno07        ifne      0
     C                   MOVE      ' '           result
     C                   z-add     0             oeam02
     C     IVNO07        CHAIN     IVFMSTR                            50
     C     *IN50         IFEQ      *OFF
¢R    * special code for cust 234369, 220222, and 229251 override
¢R    * AMN items to lookup rebate using GMC table instead of AMN table
¢o ¢Pc*    IVNO05        ifeq      23729
¢o ¢Pc*    CUST          andeq     234369
¢P ¢QC*                  If        IVNO05 = 23729 and
¢P ¢QC*                            (CUST = 234369 or CUST = 220222)
¢Q ¢RC*                  IF        IVNO05 = 23729 AND
¢Q ¢RC*                            CUST   = 234369 OR
¢Q ¢RC*                            IVNO05 = 23729 AND
¢Q ¢RC*                            CUST   = 220222 AND
¢Q ¢RC*                            JOBNO  = '14 SEER'
¢R   C                   If        IVNO05 = 23729 and
¢R   C                             (CUST = 234369 or CUST = 229251 or
¢R   C                             (CUST = 220222 and JOBNO = '14 SEER'))
¢o   c                   eval      ivno05 = 14158
¢o   c                   eval      ivcd17 = 'GMC'
¢o   c                   end
      ****************************************************************
      * AMANA
      ****************************************************************
     C     IVNO05        ifeq      23729
     c     oeam01        ifne      0
¢G   c     ivam01        andne     0

¢F    * Calculate item markup percent
¢K   C     OEAM01        DIV(H)    IVAM01        ITM_MU_PCT        4 3
¢I
¢I    * Determine maximum and minimum markup percents
¢I   C     MAX_MU_PCT    IFEQ      *ZEROS
¢I   C     MIN_MU_PCT    OREQ      *ZEROS
¢I   C                   EXSR      MINMAX_AMN
¢I   C                   ENDIF
¢I
¢I    * Check upper & lower limits
¢I   C     ITM_MU_PCT    ifgt      MAX_MU_PCT
¢I   C                   eval      ITM_MU_PCT = MAX_MU_PCT
¢I   C                   else
¢I   C     ITM_MU_PCT    iflt      MIN_MU_PCT
¢K    * Amana does not pay rebate on items less than the min mu
¢K   C                   goto      skip
¢I   C                   end
¢I   C                   end

¢F    * Use item markup percent to find rebate percent in file
¢F   C     ITM_MU_PCT    CHAIN     SAFAMNR
¢F   C                   IF        %FOUND
¢K    * reduce reb% by 5% since we get reduction on buy price
¢K   c     reb_pct       sub       .05           reb_pct
¢K   c     reb_pct       iflt      0
¢K   c                   z-add     0             reb_pct
¢K   c                   end

¢F    * Calculate cost rebate amount for manuf list
¢F   C     IVAM01        MULT(H)   REB_PCT       REB_AMT_LIST      7 2
¢F    * Calculate cost rebate amount for sell price
¢H   C                   IF        %subst(IVNO93:1:4) = 'AMH8'                  Manf Number
¢J   C     OEAM01        MULT(H)   .076          REB_AMT_SELL      7 2
¢H   C                   ELSE
¢J   C     OEAM01        MULT(H)   .029          REB_AMT_SELL      7 2
¢H   C                   ENDIF
¢F    * Calculate total rebate amount
¢F   C     REB_AMT_LIST  ADD       REB_AMT_SELL  REB_AMT           7 2
¢F    * Calculate item cost
¢F   C     IVAM34        SUB       REB_AMT       OEAM02
¢F   C                   MOVE      'Y'           RESULT
¢F   C                   ENDIF
     C                   end
     C                   end
¢K   c     skip          tag

      ****************************************************************
      * AMANA -  END
      ****************************************************************

¢b    ****************************************************************
¢b    * Goodman Begin
¢b    ****************************************************************
¢b   C     IVNO05        ifeq      14158
¢b   c     oeam01        andne     0
¢b   C     IVNO05        oreq      14141
¢b   c     oeam01        andne     0
¢n   C     IVNO05        oreq      26910
¢n   c     oeam01        andne     0
¢b
¢b ¢N * all of GMC EQP items are 'G'
¢b
¢b   c     ivcd17        ifeq      'GMC'
¢n   c                   eval      gmtype = 'G'
¢b   c                   end
¢b
¢b ¢N *  LCU items that have Cat that doesn't start with a D, use L
¢b ¢N *  table, otherwise they use G table
¢b   c     ivcd17        ifeq      'LCU'
¢M   c                   if        %subst(ivcd18:1:1) = 'D'
¢N   c                   eval      gmtype = 'G'
¢M   c                   else
¢b   c                   eval      gmtype = 'L'
¢M   c                   end
¢b   c                   end
¢b
¢n    * all of DAI Ductless are 'D'
¢n
¢n   c     ivcd17        ifeq      'DAI'
¢n   c                   eval      gmtype = 'D'
¢n   c                   end

¢L    * check to see if item is Aspen Coil - No Rebate
¢L
¢L   C     ivcd17        ifeq      'GMC'
¢L   C     ivcd19        andeq     'ASP'
¢L   c                   move      ' '           gmtype            1
¢L   c                   end
¢b
¢b    * only process if gmtype has a G or L or D
¢b
¢b   c     gmtype        ifne      ' '
¢c   c     ivam01        andne     0
¢b
¢b    * calc selling multplier Sell Price/Mfg List
¢b    * half adjust the amount
¢b
¢b   c     oeam01        div(h)    ivam01        gmsell
¢b
¢b    * GMTYPE 'L' have gmsell range of .80 - 1.09
¢b
¢I
¢I    * Determine GMTYPE 'L' Minimum and Maximum range
¢I   C     GMTYPE        IFEQ      'L'
¢I   C     MAX_SELL_L    IFEQ      *zeros
¢I   C                   EXSR      MINMAX_GMC
¢I   C                   EVAL      MAX_SELL_L = MAX_SELL
¢I   C                   EVAL      MIN_SELL_L = MIN_SELL
¢I   C                   ENDIF
¢I   C                   IF        GMSELL > MAX_SELL_L
¢I   C                   EVAL      GMSELL = MAX_SELL_L
¢I   C                   ELSE
¢I   C                   IF        GMSELL < MIN_SELL_L
¢I   C                   EVAL      GMSELL = MIN_SELL_L
¢I   C                   ENDIF
¢I   C                   ENDIF
¢I   C                   ENDIF
¢I
¢I    * Determine GMTYPE 'D' Minimum and Maximum range
¢I   C     GMTYPE        IFEQ      'D'
¢I   C     MAX_SELL_D    IFEQ      *zeros
¢I   C                   EXSR      MINMAX_GMC
¢I   C                   EVAL      MAX_SELL_D = MAX_SELL
¢I   C                   EVAL      MIN_SELL_D = MIN_SELL
¢I   C                   ENDIF
¢I   C                   IF        GMSELL > MAX_SELL_D
¢I   C                   EVAL      GMSELL = MAX_SELL_D
¢I   C                   ELSE
¢I   C                   IF        GMSELL < MIN_SELL_D
¢n   C                   EVAL      GMSELL = 0
¢I   C                   ENDIF
¢I   C                   ENDIF
¢I   C                   ENDIF
¢n    * Determine GMTYPE 'G' Minimum and Maximum range
¢n   C     GMTYPE        IFEQ      'G'
¢n   C     MAX_SELL_D    IFEQ      *zeros
¢n   C                   EXSR      MINMAX_GMC
¢n   C                   EVAL      MAX_SELL_G = MAX_SELL
¢n   C                   EVAL      MIN_SELL_G = MIN_SELL
¢n   C                   ENDIF
¢n   C                   IF        GMSELL > MAX_SELL_G
¢n   C                   EVAL      GMSELL = MAX_SELL_G
¢n   C                   ELSE
¢n   C                   IF        GMSELL < MIN_SELL_G
¢n¢S C*                            and gmsell >.45
¢n   C                   EVAL      GMSELL = MIN_SELL_G
¢n   C                   ENDIF
¢n   C                   ENDIF
¢n   C                   ENDIF
¢b
¢b   c     gmckey        chain     safgmcout                          50
¢b   C     *IN50         IFEQ      *OFF
¢b
¢b    * calc cost by retrieving the cost multiplier * mfg list price
¢b
¢K   c     1             sub       rebpct        cstmul            5 4
¢K   c     cstmul        mult(h)   ivam01        oeam02

¢b   c                   move      'Y'           result
¢b
¢b   c                   end
¢b    *
¢b    * end for GMTYPE
¢b   c                   end
¢b    * end for GMC Vendor
¢b   c                   end
¢b

     C                   END
     C                   END

     C                   SETON                                        LR
¢I
¢I    **********************************************************************
¢I    *  Get Amana Type Minimum and Maximum Percent Range
¢I    **********************************************************************
¢I   C     MINMAX_AMN    BEGSR
¢I
¢I    * Determine Maximum Percent
¢I   C     *HIVAL        SETGT     SAFAMNR
¢I   C                   READP     SAFAMNR
¢I   C                   IF        not %EOF
¢I   C                   EVAL      MAX_MU_PCT = MU_PCT
¢I   C                   ENDIF
¢I
¢I    * Determine Minimum Percent
¢I   C     *LOVAL        SETLL     SAFAMNR
¢I   C                   READ      SAFAMNR
¢I   C                   IF        not %EOF
¢I   C                   EVAL      MIN_MU_PCT = MU_PCT
¢I   C                   ENDIF
¢I
¢I   C                   ENDSR
¢I
¢I    **********************************************************************
¢I    *  Get GMC Type Minimum and Maximum Percent Range
¢I    **********************************************************************
¢I   C     MINMAX_GMC    BEGSR
¢I
¢I    * Determine Maximum Percent
¢I   C     GMTYPE        SETGT     SAFGMCOUT
¢I   C                   READP     SAFGMCOUT
¢I   C                   IF        not %EOF
¢I   C                   EVAL      MAX_SELL = SELMUL
¢I   C                   ELSE
¢I   C                   CLEAR                   MAX_SELL
¢I   C                   ENDIF
¢I
¢I    * Determine Minimum Percent
¢I   C     GMTYPE        SETLL     SAFGMCOUT
¢I   C                   READ      SAFGMCOUT
¢I   C                   IF        not %EOF
¢I   C                   EVAL      MIN_SELL = SELMUL
¢I   C                   ELSE
¢I   C                   CLEAR                   MIN_SELL
¢I   C                   ENDIF
¢I
¢I   C                   ENDSR
