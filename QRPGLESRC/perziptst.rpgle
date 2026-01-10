     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - ARRC104                                                *
     F*------------------------------------------------------------------------*
     F*P                                                                       *
     F*------------------------------------------------------------------------*
     F*D PER ZIP ADDRESS VALIDATION                                            *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V DCB   7331 072122 DCB ADD CALLABLE PROGRAM FOR PER ZIP VALIDATION     *
¢A   F*C DCB   7341 111152 DCB FIX 3 ADDRESS LINES ISSUE                       *
¢B   F*C CLP   5065 032223 CLP Add logic to skip Germany address               *
¢C   F*C DCB   7374 052124 DCB ADD SECOND PER ZIP VALIDATION FOR CITY,ST,ZIP   *
     F*M ----------------------------------------------------------------------*
      *  These arrays are used to return the data when multiple matches are found
¢C    *  These arrays are used in ML2194xx program

         dcl-ds multipleAddresses  dim(100) qualified;
          secAddr       char(64);    // MLT SEC ADDR
          delAddr       char(64);    // MLT DEL ADDR
          streetNum     char(10);    // MLT STR NO
          preDir        char(2);     // MLT PRE DIR
          streetName    char(28);    // MLT NTR NAME
          streetSfx     char(4);     // MLT STR SUFFIX
          postDir       char(2);     // MLT POST DIR
          aptType       char(4);     // MLT APT TYPE
          aptNum        char(8);     // MLT APT NUMBER
          cityName      char(28);    // MLT CITY NAME
          cityAbbrev    char(13);    // MLT CITY ABRV
          stateCode     char(2);     // MLT STATE CODE
          zip5          char(5);     // MLT ZIP CODE
          zip4          char(4);     // MLT ZIP+4
          lastLine      char(64);    // MLT LAST LINE
          carrierRoute  char(4);     // MLT CARRIER RTE
          delPoint      char(3);     // MLT DEL PT
          countyName    char(25);    // MLT COUNTY NAME
          countyStateCd char(2);     // MLT COUNTY STATE CD
          fipsState     char(2);     // MLT FIPS STATE #
          fipsCounty    char(3);     // MLT FIPS COUNTY #
          congDist      char(2);     // MLT CONG DIST #
          lacsInd       char(1);     // MLT LACS IND
          strMatchLvl   char(1);     // MLT STR MATCH LEV
          secAddrFlag   char(1);     // MLT SEC ADR FLAG
         end-ds;

¢C    *  These arrays are used in ML2182xx program
¢C   D ZC#82           S              1    DIM(30)                              ZIP CLASS ARRAY
¢C   D CT#82           S             28    DIM(30)                              CITY NAME ARRAY
¢C   D NA#82           S             13    DIM(30)                              CITY ABBREV ARRAY
¢C   D FC#82           S              1    DIM(30)                              FACILITY CODE ARRAY
¢C   D MI#82           S              1    DIM(30)                              MAIL NAME IND ARRAY
¢C   D PN#82           S             28    DIM(30)                              PREFD CTY NAME ARRAY
¢C   D CI#82           S              1    DIM(30)                              CITY DEL IND ARRAY
¢C   D ZI#82           S              1    DIM(30)                              AUTO ZONE IND ARRAY
¢C   D UI#82           S              1    DIM(30)                              UNI ZIP NM IND ARRAY
¢C   D FN#82           S              4    DIM(30)                              FINANCE NUMBER ARRAY
¢C   D ST#82           S              2    DIM(30)                              STATE CODE ARRAY
¢C   D CY#82           S              3    DIM(30)                              COUNTY NUMBER ARRAY
¢C   D CN#82           S             25    DIM(30)                              COUNTY NAME ARRAY
     D                 DS
     D  ZIPCODE                1     10
     D  POS1TO5                1      5
     D  POS6                   6      6
     D  POS6TO9                6      9
     D  POS7TO10               7     10
      *------------------------------------------------------------------------*
      * Declare parameter lists
      *------------------------------------------------------------------------*
     C     *ENTRY        PLIST
     C                   PARM                    INAME            30            Input address name
     C                   PARM                    IADDR1           30            Input Address line 1
     C                   PARM                    IADDR2           30            Input Address line 2
     C                   PARM                    IADDR3           30            Input Address line 3
     C                   PARM                    ICITY            25            Input City
     C                   PARM                    ISTATE            2            Input State
     C                   PARM                    IZIP             10            Input Zip
     C                   PARM                    OADDR1           30            Output Addres line 1
     C                   PARM                    OADDR2           30            Output Addres line 2
     C                   PARM                    OADDR3           30            Output Addres line 3
     C                   PARM                    OCITY            25            Output City
     C                   PARM                    OSTATE            2            Output State
     C                   PARM                    OZIP             10            Output Zip
     C                   PARM                    CASE              1            Address Case
     C                   PARM                    ERRCDE            3            Error Code
     C                   PARM                    ERRMSG           80            Error Message
     C                   PARM                    MAXADRL           2            Max Address Length
¢C   C                   PARM                    ADDRTYPE          1            Address type M S

     C     PL_ML219403   PLIST
     C                   PARM                    CASE##            1            Case Control
     C                   PARM                    ADRL##            2            Max Address Length
     C                   PARM                    ECOD##            3            Error Code
     C                   PARM                    EMSG##           80            Error Message
     C                   PARM                    CASF##           10            CASS File Name
     C                   PARM      *BLANK        DBFL##            1            Database Flag
     C                   PARM                    URBN##           64            URB Name
     C                   PARM                    FIRM##           64            Firm Name
     C                   PARM                    SADR##           64            SEC Address
     C                   PARM                    DADR##           64            DEL Address
     C                   PARM                    LLIN##           64            Last Line
     C                   PARM                    STNO##           10            STR Number
     C                   PARM                    PRDR##            2            PRE DIR
     C                   PARM                    STNM##           28            STR Name
     C                   PARM                    STSF##            4            STR Suffix
     C                   PARM                    PSDR##            2            Post DIR
     C                   PARM                    SATP##            4            SEC Address Type
     C                   PARM                    SANO##            8            SEC Address Number
     C                   PARM                    S2TP##            4            SEC Address 2 Type
     C                   PARM                    S2NO##            8            SEC Address 2 Number
     C                   PARM                    EXTR##           64            Extraneous Info
     C                   PARM                    CITY##           64            City
     C                   PARM                    CABV##           13            City Abbreviation
     C                   PARM                    STAT##           64            State
     C                   PARM                    ZIPC##            5            Zip
     C                   PARM                    ZIP4##            4            Zip+4
     C                   PARM                    DPBC##            3            DEL Point
     C                   PARM                    CRID##            4            Carrier Rte
     C                   PARM                    CONM##           25            County Name
     C                   PARM                    COST##            2            County State Code
     C                   PARM                    FPCO##            3            FIPS County Number
     C                   PARM                    FPST##            2            FIPS State Number
     C                   PARM                    CNDS##            2            CONG Dist Number
     C                   PARM                    CNSC##            2            CONG Dist St Code
     C                   PARM                    EWSF##            1            EWS Flag
     C                   PARM                    LACS##            1            LACS Ind
     C                   PARM                    RTYP##            1            Record Type Code
     C                   PARM                    DFLT##            1            Default Flag
     C                   PARM                    PMBX##           12            PMB DES/NO
     C                   PARM                    SMLI##            1            STR Match LEV IND
     C                   PARM                    SAFL##            1            SEC Address Flag
     C                   PARM                    LOT###            4            ELOT Sequence Number
     C                   PARM                    LTAD##            1            ELOT A/D Code
     C                   PARM                    DPVI##            1            DPV Ind
     C                   PARM                    DPVC##            1            DPV CMRA Ind
     C                   PARM                    DPVF##            1            DPV F/P Ind
     C                   PARM                    DPVN##            6            DPV Foot Notes
     C                   PARM                    DPVO##            1            OCC Code
     C                   PARM                    DDPV##            1            DIR DPV Flag
     C                   PARM                    ICOD##            4            INTEL Code
     C                   PARM                    RDIN##            1            RDI Code
     C                   PARM                    BUSR##            1            BUS/RES Ind
     C                   PARM                    LIND##            1            LLK Ind
     C                   PARM                    LCOD##            2            LLK Return Code
     C                   PARM                    SIND##            1            SLK Ind
     C                   PARM                    SCOD##            2            SLK Return Code
     C                   PARM                    RTLL##            1            Return LAT/LON
     C                   PARM                    LLMQ##            1            L/L Match Qual
     C                   PARM                    LATI##            9            Latitude
     C                   PARM                    LONG##            9            Longitude
     C                   PARM                    MSA2##            4            2000 MSA Code
     C                   PARM                    MCD2##            5            2000 MCD Code
     C                   PARM                    CDP2##            5            2000 CDP Code
     C                   PARM                    CNTR##            6            Census Tract
     C                   PARM                    CBGP##            1            Census BLK Group
     C                   PARM                    MSAC##            5            CUR MSA Code
     C                   PARM                    MICR##            5            CUR MICR SA Code
     C                   PARM                    MDCC##            5            CUR MET DIV Code
     C                   PARM                    CSAC##            3            CUR CON SA Code
     C                   PARM                    ZCCL##            1            Zip Class
     C                   PARM                    TMZN##            1            Time Zone
     C                   PARM                    TAC1##            3            TEL A/C 1
     C                   PARM                    TAC2##            3            TEL A/C 2
     C                   PARM                    TAC3##            3            TEL A/C 3
     C                   PARM                    secAddr                        MLT SEC ADDR
     C                   PARM                    delAddr                        MLT DEL ADDR
     C                   PARM                    streetNum                      MLT STR NO
     C                   PARM                    preDir                         MLT PRE DIR
     C                   PARM                    streetName                     MLT NTR NAME
     C                   PARM                    streetSfx                      MLT STR SUFFIX
     C                   PARM                    postDir                        MLT POST DIR
     C                   PARM                    aptType                        MLT APT TYPE
     C                   PARM                    aptNum                         MLT APT NUMBER
     C                   PARM                    cityName                       MLT CITY NAME
     C                   PARM                    cityAbbrev                     MLT CITY ABRV
     C                   PARM                    stateCode                      MLT STATE CODE
     C                   PARM                    zip5                           MLT ZIP CODE
     C                   PARM                    zip4                           MLT ZIP+4
     C                   PARM                    lastLine                       MLT LAST LINE
     C                   PARM                    carrierRoute                   MLT CARRIER RTE
     C                   PARM                    delPoint                       MLT DEL PT
     C                   PARM                    countyName                     MLT COUNTY NAME
     C                   PARM                    countyStateCd                  MLT COUNTY STATE CD
     C                   PARM                    fipsState                      MLT FIPS STATE #
     C                   PARM                    fipsCounty                     MLT FIPS COUNTY #
     C                   PARM                    congDist                       MLT CONG DIST #
     C                   PARM                    lacsInd                        MLT LACS IND
     C                   PARM                    strMatchLvl                    MLT STR MATCH LEV
     C                   PARM                    secAddrFlag                    MLT SEC ADR FLAG

¢C   C     PL_ML218202   PLIST
¢C   C                   PARM                    ZIPC##82          5            ZIP CODE
¢C   C                   PARM                    CASE##82          1            CASE CONTROL
¢C   C                   PARM                    SIND##82         12            SEASONAL INDICATORS
¢C   C                   PARM                    ZC#82                          ZIP CLASS
¢C   C                   PARM                    CT#82                          CITY NAME
¢C   C                   PARM                    NA#82                          CITY NAME ABBREV
¢C   C                   PARM                    FC#82                          FACILITY CODE
¢C   C                   PARM                    MI#82                          MAILING NAME IND
¢C   C                   PARM                    PN#82                          PREFD CITY NAME
¢C   C                   PARM                    CI#82                          CITY DEL INDICATOR
¢C   C                   PARM                    ZI#82                          AUTO ZONE INDICATOR
¢C   C                   PARM                    UI#82                          UNIQUE ZIP NAME IND
¢C   C                   PARM                    FN#82                          FINANCE NUMBER
¢C   C                   PARM                    ST#82                          STATE CODE
¢C   C                   PARM                    CY#82                          COUNTY NUMBER
¢C   C                   PARM                    CN#82                          COUNTY NAME
¢C   C                   PARM      *BLANKS       ECOD##82          3            ERROR CODE
      *------------------------------------------------------------------------*
      * Clear parm fields
      *------------------------------------------------------------------------*
     C                   MOVE      *BLANKS       CASE##                         CASE CONTROL
     C                   MOVE      *BLANKS       ADRL##                         MAX ADDR LENG
     C                   MOVE      *BLANKS       ECOD##                         ERROR CODE
     C                   MOVE      *BLANKS       EMSG##                         ERROR MESSAGE
     C                   MOVE      *BLANKS       CASF##                         CASS FILE NAME
     C                   MOVE      *BLANKS       DBFL##                         DATABASE FLAG
     C                   MOVE      *BLANKS       URBN##                         URB NAME
     C                   MOVE      *BLANKS       FIRM##                         FIRM NAME
     C                   MOVE      *BLANKS       SADR##                         SEC ADDRESS
     C                   MOVE      *BLANKS       DADR##                         DEL ADDRESS
     C                   MOVE      *BLANKS       LLIN##                         LAST LINE
     C                   MOVE      *BLANKS       STNO##                         STR NUMBER
     C                   MOVE      *BLANKS       PRDR##                         PRE DIR
     C                   MOVE      *BLANKS       STNM##                         STR NAME
     C                   MOVE      *BLANKS       STSF##                         STR SUFFIX
     C                   MOVE      *BLANKS       PSDR##                         POST DIR
     C                   MOVE      *BLANKS       SATP##                         SEC ADR TYPE
     C                   MOVE      *BLANKS       SANO##                         SEC ADR NO
     C                   MOVE      *BLANKS       S2TP##                         SEC ADR 2 TYPE
     C                   MOVE      *BLANKS       S2NO##                         SEC ADR 2 NO
     C                   MOVE      *BLANKS       EXTR##                         EXTRANEOUS INFO
     C                   MOVE      *BLANKS       CITY##                         CITY
     C                   MOVE      *BLANKS       CABV##                         CITY ABRV
     C                   MOVE      *BLANKS       STAT##                         STATE
     C                   MOVE      *BLANKS       ZIPC##                         ZIP
     C                   MOVE      *BLANKS       ZIP4##                         ZIP+4
     C                   MOVE      *BLANKS       DPBC##                         DEL POINT
     C                   MOVE      *BLANKS       CRID##                         CARRIER RTE
     C                   MOVE      *BLANKS       CONM##                         COUNTY NAME
     C                   MOVE      *BLANKS       COST##                         COUNTY ST CODE
     C                   MOVE      *BLANKS       FPCO##                         FIPS COUNTY #
     C                   MOVE      *BLANKS       FPST##                         FIPS STATE #
     C                   MOVE      *BLANKS       CNDS##                         CONG DIST #
     C                   MOVE      *BLANKS       CNSC##                         CONG DIST ST CODE
     C                   MOVE      *BLANKS       EWSF##                         EWS FLAG
     C                   MOVE      *BLANKS       LACS##                         LACS IND
     C                   MOVE      *BLANKS       RTYP##                         REC TYPE CODE
     C                   MOVE      *BLANKS       DFLT##                         DEFAULT FLAG
     C                   MOVE      *BLANKS       PMBX##                         PMB DES/NO
     C                   MOVE      *BLANKS       SMLI##                         STR MATCH LEV IND
     C                   MOVE      *BLANKS       SAFL##                         SEC ADR FLAG
     C                   MOVE      *BLANKS       LOT###                         ELOT SEQ NO
     C                   MOVE      *BLANKS       LTAD##                         ELOT A/D CODE
     C                   MOVE      *BLANKS       DPVI##                         DVP IND
     C                   MOVE      *BLANKS       DPVC##                         DPV CMRA IND
     C                   MOVE      *BLANKS       DPVF##                         DPV F/P IND
     C                   MOVE      *BLANKS       DPVN##                         DPV FOOTNOTES
     C                   MOVE      *BLANKS       DPVO##                         OCC CODE
     C                   MOVE      *BLANKS       DDPV##                         DIR DPV FLAG
     C                   MOVE      *BLANKS       ICOD##                         INTEL CODE
     C                   MOVE      *BLANKS       RDIN##                         RDI CODE
     C                   MOVE      *BLANKS       BUSR##                         BUS/RES IND
     C                   MOVE      *BLANKS       LIND##                         LLK IND
     C                   MOVE      *BLANKS       LCOD##                         LLK RTN CODE
     C                   MOVE      *BLANKS       SIND##                         SLK IND
     C                   MOVE      *BLANKS       SCOD##                         SLK RTN CODE
     C                   MOVE      *BLANKS       RTLL##                         RETURN LAT/LON
     C                   MOVE      *BLANKS       LLMQ##                         L/L MATCH QUAL
     C                   MOVE      *BLANKS       LATI##                         LATITUDE
     C                   MOVE      *BLANKS       LONG##                         LONGITUDE
     C                   MOVE      *BLANKS       MSA2##                         2000 MSA CODE
     C                   MOVE      *BLANKS       MCD2##                         2000 MCD CODE
     C                   MOVE      *BLANKS       CDP2##                         2000 CDP CODE
     C                   MOVE      *BLANKS       CNTR##                         CENSUS TRACT
     C                   MOVE      *BLANKS       CBGP##                         CENSUS BLK GROUP
     C                   MOVE      *BLANKS       MSAC##                         CUR MSA CODE
     C                   MOVE      *BLANKS       MICR##                         CUR MICR SA CODE
     C                   MOVE      *BLANKS       MDCC##                         CUR MET DIV CODE
     C                   MOVE      *BLANKS       CSAC##                         CUR CON SA CODE
     C                   MOVE      *BLANKS       ZCCL##                         ZIP CLASS
     C                   MOVE      *BLANKS       TMZN##                         TIME ZONE
     C                   MOVE      *BLANKS       TAC1##                         TEL A/C 1
     C                   MOVE      *BLANKS       TAC2##                         TEL A/C 2
     C                   MOVE      *BLANKS       TAC3##                         TEL A/C 3

                         reset multipleAddresses;

     C                   MOVE      *BLANKS       OADDR1
     C                   MOVE      *BLANKS       OADDR2
     C                   MOVE      *BLANKS       OADDR3
     C                   MOVE      *BLANKS       OCITY
     C                   MOVE      *BLANKS       OSTATE
     C                   MOVE      *BLANKS       OZIP
     C                   MOVE      *BLANKS       ERRCDE
     C                   MOVE      *BLANKS       ERRMSG
¢C   C                   MOVE      *BLANKS       ZIPC##82                       ZIP CODE
¢C   C                   MOVE      *BLANKS       CASE##82                       CASE CONTROL
¢C   C                   MOVE      *BLANKS       SIND##82                       SEASONAL INDICATORS
¢C   C                   MOVE      *BLANKS       ZC#82                          ZIP CLASS
¢C   C                   MOVE      *BLANKS       CT#82                          CITY NAME
¢C   C                   MOVE      *BLANKS       NA#82                          CITY NAME ABBREV
¢C   C                   MOVE      *BLANKS       FC#82                          FACILITY CODE
¢C   C                   MOVE      *BLANKS       MI#82                          MAILING NAME IND
¢C   C                   MOVE      *BLANKS       PN#82                          PREFD CITY NAME
¢C   C                   MOVE      *BLANKS       CI#82                          CITY DEL INDICATOR
¢C   C                   MOVE      *BLANKS       ZI#82                          AUTO ZONE INDICATOR
¢C   C                   MOVE      *BLANKS       UI#82                          UNIQUE ZIP NAME IND
¢C   C                   MOVE      *BLANKS       FN#82                          FINANCE NUMBER
¢C   C                   MOVE      *BLANKS       ST#82                          STATE CODE
¢C   C                   MOVE      *BLANKS       CY#82                          COUNTY NUMBER
¢C   C                   MOVE      *BLANKS       CN#82                          COUNTY NAME
¢C   C                   MOVE      *BLANKS       ECOD##82          3            ERROR CODE
      *------------------------------------------------------------------------*
      * Check for Canadian address and leave if it is
      *------------------------------------------------------------------------*
     C                   CLEAR                   CANADA_POS        3 0
            CANADA_POS = %SCAN('Canada' : ICITY);
     C                   IF        CANADA_POS <> 0
     C                   GOTO      ENDPGM
     C                   ENDIF
            CANADA_POS = %SCAN('CANADA' : ICITY);
     C                   IF        CANADA_POS <> 0
     C                   GOTO      ENDPGM
     C                   ENDIF
            CANADA_POS = %SCAN('Ontario' : ICITY);
     C                   IF        CANADA_POS <> 0
     C                   GOTO      ENDPGM
     C                   ENDIF
            CANADA_POS = %SCAN('ONTARIO' : ICITY);
     C                   IF        CANADA_POS <> 0
     C                   GOTO      ENDPGM
     C                   ENDIF

¢B    *------------------------------------------------------------------------*
¢B    * Check for Germany address and leave if it is
¢B    *------------------------------------------------------------------------*
¢B   C                   CLEAR                   GERMANY_POS       3 0
¢B          GERMANY_POS = %SCAN('Germany' : ICITY);
¢B   C                   IF        GERMANY_POS <> 0
¢B   C                   GOTO      ENDPGM
¢B   C                   ENDIF
¢B          GERMANY_POS = %SCAN('GERMANY' : ICITY);
¢B   C                   IF        GERMANY_POS <> 0
¢B   C                   GOTO      ENDPGM
¢B   C                   ENDIF
      *------------------------------------------------------------------------*
      * Load parm fields
      *------------------------------------------------------------------------*
¢A    * First check address and squish if separated
¢A   C                   IF        IADDR1 <> *BLANKS and
¢A   C                             IADDR2 =  *BLANKS and
¢A   C                             IADDR3 <> *BLANKS
¢A   C                   MOVEL     IADDR1        IADDR2
¢A   C                   CLEAR                   IADDR1
¢A   C                   ENDIF
     C                   MOVEL     CASE          CASE##                         Case control
     C                   MOVEL     MAXADRL       ADRL##                         Max address Length
     C                   MOVEL     INAME         FIRM##                         Firm name
     C                   SELECT
     C     MAXADRL       WHENEQ    '60'
     C                   EVAL      DADR## = IADDR2 + IADDR3                     Use addr 2&3 as DEL
     C     MAXADRL       WHENNE    '60'
     C     IADDR3        ANDNE     *BLANKS
     C     IADDR2        ANDNE     *BLANKS
     C                   MOVEL     IADDR3        DADR##                         Use addr 3 as DEL
     C                   MOVEL     IADDR2        SADR##                         Use addr 2 as SEC
     C     MAXADRL       WHENNE    '60'
     C     IADDR3        ANDEQ     *BLANKS
     C     IADDR2        ANDNE     *BLANKS
     C     IADDR1        ANDNE     *BLANKS
     C                   MOVEL     IADDR2        DADR##                         Use addr 2 as DEL
     C                   MOVEL     IADDR1        SADR##                         Use addr 1 as SEC
     C     MAXADRL       WHENNE    '60'
     C     IADDR3        ANDEQ     *BLANKS
     C     IADDR2        ANDEQ     *BLANKS
     C     IADDR1        ANDNE     *BLANKS
     C                   MOVEL     IADDR1        DADR##                         Use addr 1 as DEL
     C     MAXADRL       WHENNE    '60'
     C     IADDR3        ANDNE     *BLANKS
     C     IADDR2        ANDEQ     *BLANKS
     C     IADDR1        ANDNE     *BLANKS
     C                   MOVEL     IADDR3        DADR##                         Use addr 3 as DEL
     C                   MOVEL     IADDR1        SADR##                         Use addr 1 as SEC
     C                   ENDSL
     C                   MOVEL     ICITY         CITY##                         CITY
     C                   MOVEL     ISTATE        STAT##                         STATE
     C                   MOVEL     IZIP          ZIPCODE
     C                   SELECT
     C     POS6          WHENEQ    '-'
     C     POS7TO10      ANDNE     *BLANKS
     C                   MOVEL     IZIP          ZIPC##                         ZIP
     C                   MOVE      IZIP          ZIP4##                         ZIP+4
     C     POS6          WHENEQ    '-'
     C     POS7TO10      ANDEQ     *BLANKS
     C                   MOVEL     IZIP          ZIPC##                         ZIP
     C     POS6          WHENNE    '-'
     C     POS6          ANDNE     ' '
     C                   MOVEL     IZIP          ZIPC##                         ZIP
     C                   MOVEL     POS6TO9       ZIP4##                         ZIP+4
     C     POS6          WHENEQ    ' '
     C     POS7TO10      ANDEQ     *BLANKS
     C                   MOVEL     IZIP          ZIPC##                         ZIP
     C                   ENDSL
      *------------------------------------------------------------------------*
      * CALL PER ZIP ADDRESS VALIDATION PROGRAM
      *------------------------------------------------------------------------*
     C                   CALL      'ML219403'    PL_ML219403
     C                   IF        ECOD## = 'BNR' OR ECOD## = 'LLK' OR
     C                             ECOD## = 'SLK' OR ECOD## = 'SIZ' OR
     C                             ECOD## = 'DPV' OR ECOD## = 'EWS' OR
     C                             ECOD## = 'ALT'
     C                   MOVE      *BLANKS       EMSG##
     C                   MOVE      *BLANKS       ECOD##
     C                   ENDIF
      *------------------------------------------------------------------------*
      * LOAD OUTPUT ADDRESS IF NO ERRORS
      *------------------------------------------------------------------------*
     C                   IF        ECOD## = *BLANKS
     C                   SELECT
     C     MAXADRL       WHENEQ    '60'
     C                   EVAL      OADDR3 = %SUBST(DADR##:31:30)
     C                   EVAL      OADDR2 = %SUBST(DADR##:01:30)
     C     MAXADRL       WHENNE    '60'
     C     SADR##        ANDNE     *BLANKS
¢A   C                   IF        IADDR1 = *BLANKS
     C                   EVAL      OADDR1 = %SUBST(SADR##:01:30)
     C                   EVAL      OADDR2 = %SUBST(DADR##:01:30)
¢A   C                   ELSE
¢A   C                   If        IADDR1 <> *blanks and
¢A   C                             IADDR2 <> *blanks and iaddr3 <>
¢A   c                             *blanks
¢A   C                   EVAL      OADDR1 = IADDR1
¢A   C                   EVAL      OADDR2 = %SUBST(SADR##:01:30)
¢A   C                   EVAL      OADDR3 = %SUBST(DADR##:01:30)
¢A   c                   else
¢A   c                   If        IADDR3 = *BLANKS AND IADDR2 <>
¢A   C                             *BLANKS AND IADDR1 <> *BLANKS
¢A   C                   EVAL      OADDR1 = %SUBST(SADR##:01:30)
¢A   C                   EVAL      OADDR2 = %SUBST(DADR##:01:30)
¢A   C                   ENDIF
¢A   C                   ENDIF
¢A   C                   ENDIF
     C     MAXADRL       WHENNE    '60'
     C     SADR##        ANDEQ     *BLANKS
     C                   EVAL      OADDR1 = %SUBST(DADR##:01:30)
     C                   ENDSL
     C                   EVAL      OCITY   = %SUBST(CITY##:01:25)
     C                   EVAL      OSTATE  = %SUBST(STAT##:01:02)
     C                   EVAL      ZIPCODE = *BLANKS
     C                   EVAL      POS1TO5 = ZIPC##
     C                   IF        ZIP4## <> *BLANKS
     C                   EVAL      POS6    = '-'
     C                   EVAL      POS7TO10 = ZIP4##
     C                   ENDIF
     C                   EVAL      OZIP = ZIPCODE
     C                   EVAL      CASE   = CASE##
     C                   ENDIF
     C                   EVAL      ERRCDE = ECOD##
     C                   EVAL      ERRMSG = EMSG##
¢C    * If verifying mailing address we need to stop verification at this point
¢C   C                   IF        ADDRTYPE = 'M'
¢C   C                   GOTO      ENDPGM
¢C   C                   ENDIF
¢C    *------------------------------------------------------------------------*
¢C    * CALL PER ZIP ADDRESS VALIDATION PROGRAM FOR CITY, STATE, ZIP
¢C    *------------------------------------------------------------------------*
¢C   C                   IF        ECOD## <> *BLANKS
¢C   C                   MOVEL     IZIP          ZIPC##82                       Zip code 5 digit
¢C   C                   MOVEL     CASE          CASE##82                       Case control
¢C   C                   CALL      'ML218202'    PL_ML218202
¢C   C                   IF        ECOD##82 = *BLANKS
¢C   C                   EVAL      OADDR1 = IADDR1
¢C   C                   EVAL      OADDR2 = IADDR2
¢C   C                   EVAL      OADDR3 = IADDR3
¢C   C                   Z-ADD     1             Q                 2 0
¢C   C     'P'           LOOKUP    FC#82(Q)                               62
¢C   C                   EVAL      OCITY  = CT#82(Q)
¢C   C                   EVAL      OSTATE = ST#82(Q)
¢C   C                   EVAL      OZIP   = IZIP
¢C   C                   ENDIF
¢C   C                   EVAL      ERRCDE = ECOD##82
¢C   C                   EVAL      ERRMSG = *BLANKS
¢C   C                   ENDIF
      *------------------------------------------------------------------------*
      * END OF JOB
      *------------------------------------------------------------------------*
     C     ENDPGM        TAG
      *
   ¢BC*                  IF        CANADA_POS <> 0
¢B   C                   IF        CANADA_POS <> 0 or GERMANY_POS <> 0
     C                   EVAL      OADDR1 = IADDR1
     C                   EVAL      OADDR2 = IADDR2
     C                   EVAL      OADDR3 = IADDR3
     C                   EVAL      OCITY  = ICITY
     C                   EVAL      OSTATE = ISTATE
     C                   EVAL      OZIP   = IZIP
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
