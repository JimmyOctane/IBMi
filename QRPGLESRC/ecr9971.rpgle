¢F   Hdebug option(*srcstmt:*nodebugio)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - ECR9971                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 1983, 1990, 1992, 1997.                   *
     F*------------------------------------------------------------------------*
     F*D determine if cust/item/job is on a contract profile for pricing       *
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
¢a   F*V KSB   5931 072413 000 add GMC outboarding                             *
¢c   F*V CLP   6236 060914 CLP corrected a looping problem when item           *
¢c   F*V                       is not priced in customer's job contract        *
¢c   F*V                       and there is no customer contract, flag         *
¢c   F*V                       for no customer contract pricing was not        *
¢c   F*V                       set to 'N' as expected by the loop              *
¢D   F*C DCB   7009 061214 DCB AMANA 22 GEORGIA                                *
¢e   F*C ksb   8011 092616 ksb don't check for amn and goodman spec itm        *
¢e   F*C                       instead verify that gmc or amn vendor           *
¢f   F*C ksb   8022 082217 ksb if gmc override price calc rebate back          *
¢f   F*C                       to default price if below .80                   *
¢f   F*C                       Add Daikin 26910 vendor to Rebate calc          *
¢G   F*C APB   9029 091417 APB Changed logical over ivpmstr                    *
     F*====================MINCRON UPGRADE TO 12.1============================*/
¢h   F*C ksb   8047 082018 ksb Calc special rebate for Motili cust             *
¢i   F*C ksb   8052 090919 ksb Calc special rebate for 234369 cust             *
¢J   F*C DCB   7220 021720 DCB GMC CONTRACT PROFILE PRICE CHANGE               *
¢k   F*C ksb   8156 010421 ksb Hiller cost change AMN G44 H14 -105             *
¢l   F*C ksb   8162 020122 ksb allow daikin cp cost outside of range .39/.48   *
¢m   F*C ksb   8179 122921 ksb remove mod 8156 for Hiller eff 1-1-23           *
     F*M ----------------------------------------------------------------------*
   ¢GF*VLMSTRH  IF   E           K DISK
¢G   FIVLMSTRK  IF   E           K DISK
     FPRLMCPD1  IF   E           K DISK
     FPRLMCPS7  IF   E           K DISK
¢e   FPRLMCPH2  IF   E           K DISK
      *----------------------------------------------------*
     IPRFMCPD
     I              IVNO07                      CNO7
     I              IVCD17                      CD17
     I              IVCD18                      CD18
     I              IVCD19                      CD19
      *----------------------------------------------------*
     C     CSHKY         KLIST
     C                   KFLD                    ARNO01
     C                   KFLD                    JOB#
     C                   KFLD                    CURSTS            1
      *----------------------------------------------------*
     C     DETKEY        KLIST                                                  CNT DET KEY
     C                   KFLD                    CNTL#                                      BER
     C                   KFLD                    PRCD73
     C                   KFLD                    SEC
     C                   KFLD                    GRP
     C                   KFLD                    CAT
     C                   KFLD                    ITEMNO
      *----------------------------------------------------*
     C     *ENTRY        PLIST
     C                   PARM                    IVNO07
     C                   PARM                    ARNO01
     C                   PARM                    JOBNO
     C                   PARM                    PRICE             8 2
     C                   PARM                    COST              7 2
¢D   C                   PARM                    SELLBR            3 0
     C                   PARM                    RESULT            1
      **********************************************************************
     C     *LIKE         DEFINE    ARNO06        JOBNO                          DETAIL RECORD
     C     *LIKE         DEFINE    ARNO06        JOB#                           DETAIL RECORD
     C     *LIKE         DEFINE    IVCD17        SEC                            DETAIL RECORD
     C     *LIKE         DEFINE    IVCD18        GRP                            DETAIL RECORD
     C     *LIKE         DEFINE    IVCD19        CAT                            DETAIL RECORD
     C     *LIKE         DEFINE    IVNO07        ITEMNO                         DETAIL RECORD
     C     *LIKE         DEFINE    PRNO12        CNTL#                          DETAIL RECORD
     C     *LIKE         DEFINE    PRNO12        SAVN12                         DETAIL RECORD
¢f   C     *LIKE         DEFINE    PRICE         DFTPRC                         DETAIL RECORD
¢f   C     *LIKE         DEFINE    PRICE         svprice                        DETAIL RECORD
¢f   C                   move      *blanks       lcutyp            1            DETAIL RECORD
     c
¢f   c                   eval      svprice = price
     c                   exsr      chksup

      *
     c
     C     IVNO07        CHAIN     IVFMSTR                            50

     C     *IN50         IFEQ      *OFF
     c                   move      ' '           result
      *
      * is it Amana item or Goodman item or Daikin item
      *
     c     ivno05        ifeq      23729
¢b   c     ivno05        oreq      14141
¢b   c     ivno05        oreq      14158
¢f   c     ivno05        oreq      26910
¢f   c     ivcd17        andeq     'DAI'
     c                   movel     'P'           prcd73
     c
¢f    *    calc Daikin % of Mfg list
¢f    *    daikin doesn't require Pap's so no CP's exist
¢f    *    if Sell price / mfg list is < .49 and > .38
¢f    *    then rebate will generated
¢f    *
¢f   c     ivam01        ifne      0
¢f   c     ivcd17        andeq     'DAI'
¢f   c     price         div(h)    ivam01        daipct            4 3
¢f   c     daipct        ifge      .38
¢f   c     daipct        andle     .49
¢f   c                   movel     *blanks       result
¢f   c                   CALL      'ECR9970'
¢f   c                   parm                    IVNO07
¢f   c                   parm                    PRICE
¢f   c                   parm                    COST              7 2
¢f   C                   PARM                    SELLBR            3 0
¢i   C                   PARM                    ARNO01
¢f   c                   parm                    RESULT            1
¢J   C                   PARM                    JOBNO
¢f    *
¢f   c                   else
¢l    * if no contract profile for customer then plug mkt cost
¢f    *   if it's daikin and is greater than .49 or less than .38
¢f    *   cost should be market cost
¢l   c                   if        prcsup = 'N'
¢f   c                   z-add     ivam05        cost
¢f   c                   move      'Y'           result
¢l   c                   end
¢f   c                   end
      * still want to check for GMC and AMN items
¢f   c                   else
     c                   exsr      chkcnt
¢f   c                   end
     c                   end
      *
     c                   END

     C                   SETON                                        LR
      *******************************************************************
     C     CHKSUP        BEGSR
     C                   MOVE      'C'           CURSTS
     C                   MOVE      JOBNO         JOB#
      *
      * CURRENT CONTRACT FOR CUSTOMER AND JOB?
     C     JOB#          IFNE      *BLANKS
     C     CSHKY         SETLL     PRFMCPS                                31
     C     *IN31         IFEQ      '1'
     C                   MOVE      'Y'           PRCSUP            1
     C                   MOVE      'Y'           PRCJOB            1
     C                   END
     C                   MOVE      *BLANKS       JOB#                           BLANK JOB#
     C                   END

      * CURRENT CONTRACT FOR CUSTOMER?
     C     CSHKY         SETLL     PRFMCPS                                31
     C     *IN31         IFEQ      '1'
     C                   MOVE      'Y'           PRCSUP
     C                   MOVE      'Y'           PRCCUS            1
¢c   C                   ELSE
¢c   C                   MOVE      'N'           PRCCUS
     C                   END
      *
     C                   ENDSR
      *******************************************************************
     C     CPSBR         BEGSR
      *
     C                   MOVE      PRNO12        CNTL#                                      BER
¢e    * check to see if the CP vendor = the item vendor
¢e    * goodman and amana rebate for any item if customer has
¢e    * a valid cp even though the item doesn't have a special price
¢e    * on the cp
¢e   C     CNTL#         CHAIN     PRFMCPH                            51
¢e   C     *IN51         IFEQ      *OFF
¢e   c     ivno05        andeq     apno01

      * FOUND
     C     FND           TAG
      *

     c                   move      'Y'           prced             1
     c                   move      0             cost
      * some LCU items use the Goodman D table (Group start with D)
¢f   c     ivcd17        ifeq      'LCU'
¢f   c                   if        %subst(ivcd18:1:1) = 'D'
¢f   c                   eval      lcutyp = 'D'
¢f   c                   end
¢f   c                   end
¢f    *
¢f    * determine if user overrode price
¢f    *
¢f   c                   z-add     0             dftprc
¢f   c                   movel     *blanks       result
¢f   c                   CALL      'PRRC0002'
¢f   c                   parm                    IVNO07
¢f   c                   parm                    arno01
¢f   c                   parm                    jobno
¢f   c                   parm                    DFTPRC
¢f   C                   PARM                    SELLBR            3 0
¢f   c                   parm                    RESULT            1
¢f   c*
¢f   c* result = Y then it's a contract profile price
¢f   c* send the default contract profile price to rebate pgm
¢f   c     ivcd17        ifeq      'GMC'
¢f   c     dftprc        andne     price
¢f   c     ivcd17        oreq      'LCU'
¢f   c     lcutyp        andeq     'D'
¢f   c     dftprc        andne     price

¢f    * calc % based on Mfg List using CP Price
¢f   c     ivam01        ifne      0
¢f   c     dftprc        div(h)    ivam01        gmsellcp          4 3
¢f    * calc % based on Mfg List using OE Price
¢f   c     price         div(h)    ivam01        gmselloe          4 3
¢f   c
      * These two scenarios require us to override price used for
      * rebate calc to be used from CP Price
      * if CP Price is < .80 and OE Price < .80 and OE Price < CP Price
      *      use CP Price
      * if CP Price is >= .80 and OE Price < .80, use CP Price

      * These scenarios use the OE Price
      * if CP Price is >= .80 and OE Price >= .80, then use OE Price
      * if CP Price is < .80 and OE Price < .80 and OE Price > CP Price
      *      use OE Price
      * if CP Price is < .80 and OE Price >= .80 use OE Price

¢f   c     gmselloe      iflt      .80
¢f   c     gmsellcp      andlt     .80
¢f   c     price         andlt     dftprc
¢f   c     gmsellcp      orge      .80
¢f   c     gmselloe      andlt     .80
¢f   c
¢f   c                   eval      price = dftprc
¢f   c
¢f   c                   end
¢f   c                   end
¢f   c                   end
¢f   c
     c
¢f   c                   movel     *blanks       result
¢q   c                   CALL      'ECR9970'
¢q   c                   parm                    IVNO07
¢q   c                   parm                    PRICE
¢q   c                   parm                    COST              7 2
¢D   C                   PARM                    SELLBR            3 0
¢i   C                   PARM                    ARNO01
¢q   c                   parm                    RESULT            1
¢J   C                   PARM                    JOBNO

¢k    * If Hiller and AMN and 14 Seer Pkg Units and Gas Packs, reduce
¢k    * cost by 105.  We will get that 105 back from Goodman spiff
¢k    * each quarter.  Pricing will reduce the price of these units
¢k    * by $150.

¢k ¢mC*    arno01        ifeq      750503
¢k ¢mc*    ivcd17        ifeq      'AMN'
¢k ¢mc*    ivcd19        ifeq      'G44'
¢k ¢mc*    ivcd19        oreq      'DFP'
¢k ¢mc*    ivcd19        oreq      'P14'
¢k ¢mc*    cost          sub       105           cost
¢k ¢mc*                  endif
¢k ¢mc*                  endif
¢k ¢mc*                  endif
¢h    * Motili cust gets 5% rebate for all gmc
¢h    *
¢h   c     arno01        ifeq      232699
¢h   c     ivam01        mult      .05           spcreb            7 2
¢h   c     ivam34        sub       spcreb        cost
¢h   c                   end
¢h    *
¢e   C                   else
¢e   C                   move      0             cost
¢e   C                   end
¢f   c                   eval      price = svprice
¢q   C     ENDCP         ENDSR


      *******************************************************************
      * TRY TO PRICE AND COST THIS ITEM WITH "CURRENT" CONTRACTS.
      * LOOP UNTIL PRICED AND COSTED, OR NO MORE "CURRENT" CONTRACTS.
      * USE JOB# WITH CUST# 1ST, THEN STRIP JOB# AND TRY AGAIN.
      *******************************************************************

     c     CHKCNT        BEGSR

     C     DONEWI        IFNE      'Y'

     C     PRCJOB        IFEQ      'Y'
     C                   MOVE      JOBNO         JOB#
     C     CSHKY         SETLL     PRFMCPS
     C                   ELSE
     C                   MOVE      *BLANKS       JOB#
     C     CSHKY         SETLL     PRFMCPS
     C                   END
      *
     C     DONEWI        DOUEQ     'Y'
     C     CSHKY         READE     PRFMCPS                                43
      *
      * IF END OF FILE - CONTRACT SUBHDRS

     C     *IN43         IFEQ      '1'

     C     PRCCUS        IFEQ      'N'
     C     PRCCUS        OREQ      'Y'
     C     JOB#          ANDEQ     *BLANKS
     C                   MOVE      'Y'           DONEWI            1
     C                   END

     C     DONEWI        IFNE      'Y'
     C     JOB#          ANDNE     *BLANKS
     C     PRCCUS        ANDEQ     'Y'
     C                   MOVE      *BLANKS       JOB#
     C     CSHKY         SETLL     PRFMCPS
     C                   END

     C                   ELSE
      *
     C     PRCED         IFNE      'Y'
     C                   MOVE      'P'           PRCD73
     C                   EXSR      CPSBR
     C                   ENDIF

     C                   END

     C     PRCED         IFEQ      'Y'
     C                   MOVE      'Y'           DONEWI
     C                   END

     C                   ENDDO
      *
      *
     C                   END
      *
¢q   C                   ENDSR
