 /*---------------------------------------------------------------------------*/
 /*   *N PROGRAM NAME - OEC2000                                               */
 /*---------------------------------------------------------------------------*/
 /*   *P COPYRIGHT MINCRON SBC CORP. 1983,1990,2006.                          */
 /*---------------------------------------------------------------------------*/
 /*   *D ORDER ENTRY/MAINTENANCE MENU                                         */
 /*---------------------------------------------------------------------------*/
 /*   *S PURPOSE:                                                             */
 /*   *S    ORDER ENTRY/MAINTENANCE MENU                                      */
 /*   *S                                                                      */
 /*   *S SPECIAL NOTES:                                                       */
 /*   *S                                                                      */
 /*   *M ---------------------------------------------------------------------*/
 /*   *M TASK       DATE   ID  DESCRIPTION                                    */
 /*   *M ---------- ------ --- -----------------------------------------------*/
 /*   *V 8000011000 013006 000 MINCRON MSS/HD RELEASE 11.0                    */
 /*AA *E 8000009966 022107 913 CHANGE S/O NUMBER TO 7 ALPHA                   */
/*AJ  *E 8000010162 060507 913 MINCRONIZE RGA FOR RELEASE NEXT                */
 /*AK *U 8000009570 122804 020 HD/WO INTERFACE                                */
/*AL  *E 8000010199 103107 913 INTELLIGENT MESSAGING                          */
/*AM  *E 8000012283 050316 001 NEW EVENT FOR C/O ORDERS NEEDING TO BE RELEASED*/
/*AN  *E 0840000376 102920 007 ADD DISCLAIMER TO PICK TICKETS                 */
/*AO  *E 1710001054 090821 404 ENHANCED LOST SALES TRACKING                   */
/*¢A  *E CLP        042721 CLP Added new opt #20, Work With reserved orders   */
/*¢B  *E CLP        012722 CLP Added new opt #21, Work With orders            */
 /*   *M ---------------------------------------------------------------------*/
             PGM        PARM(&BAROPT)
             DCLF       FILE(KIOSKD)
             DCL        VAR(&PGMNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(8) VALUE('OEC2000')
             DCL        VAR(&SCREEN) TYPE(*CHAR) LEN(8) VALUE(OEF2000)
             DCL        VAR(&RTNCDE) TYPE(*LGL)
             DCL        VAR(&FPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&APPL) TYPE(*CHAR) LEN(2) VALUE('OE')
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(2) VALUE('01')
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(2) VALUE('00')
             DCL        VAR(&AUTH) TYPE(*CHAR) LEN(1)
/*AJ  */     DCL        VAR(&PDDS)   TYPE(*CHAR) LEN(48)
/*AJ  */     DCL        VAR(&MENUPAGE) TYPE(*DEC) LEN(1 0)
             DCL        &BR        TYPE(*DEC) LEN(3)
             DCL        &ITM       TYPE(*DEC) LEN(7)
             DCL        VAR(&PTHOPT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMDOPT)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&BAROPT) TYPE(*DEC) LEN(2)
             DCL        VAR(&ONCE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CUST#) TYPE(*DEC) LEN(6)
/*AL  */     DCL        VAR(&NEWMQ)    TYPE(*DEC) LEN(3)
/*AL  */     DCL        VAR(&NEWUQ)    TYPE(*DEC) LEN(3)
/*AL  */     DCL        VAR(&NEWTQ)    TYPE(*DEC) LEN(3)
/*AL  */     DCL        VAR(&NEWM)     TYPE(*CHAR) LEN(20)
/*AL  */     DCL        VAR(&NEWU)     TYPE(*CHAR) LEN(20)
/*AL  */     DCL        VAR(&NEWT)     TYPE(*CHAR) LEN(20)
/*AL  */     DCL        VAR(&MCLR)     TYPE(*CHAR) LEN(1)

             MONMSG CPF0000 EXEC(GOTO ERROR) /*DISPLAY ERRMSG THAT +
                    USER IS NOT AUTHORIZED TO USE THIS MENU          */
             RTVJOBA    USER(&USER)
   DISPLAY:
     IF COND(&ONCE *EQ 'Y') THEN(DO)
       IF COND(&BAROPT *NE 00) THEN(DO)
         GOTO CMDLBL(ENDIT)
       ENDDO
     ENDDO
/*AL  */     CHGVAR     VAR(&IN51) VALUE('0')
/*AL  */     CHGVAR     VAR(&IN52) VALUE('0')
/*AL  */     CHGVAR     VAR(&IN53) VALUE('0')
/*AL  */     CHGVAR     VAR(&IN61) VALUE('0')
/*AL  */     CHGVAR     VAR(&IN62) VALUE('0')
/*AL  */     CHGVAR     VAR(&IN63) VALUE('0')
/*AL  */     CALL PGM(OPR2500) +
/*AL  */          PARM(&NEWM &NEWU &NEWT &NEWMQ &NEWUQ &NEWTQ &MCLR)
/*AL  */     IF         COND(&NEWMQ > 0) +
                         THEN(CHGVAR VAR(&IN61) VALUE('1'))
/*AL  */     IF         COND(&NEWUQ > 0) +
                         THEN(CHGVAR VAR(&IN62) VALUE('1'))
/*AL  */     IF         COND(&NEWTQ > 0) +
                         THEN(CHGVAR VAR(&IN63) VALUE('1'))
/*AL  */     IF         COND(&MCLR = '1') +
                         THEN(CHGVAR VAR(&IN51) VALUE('1'))
/*AL  */     IF         COND(&MCLR = '2') +
                         THEN(CHGVAR VAR(&IN52) VALUE('1'))
/*AL  */     IF         COND(&MCLR = '3') +
                         THEN(CHGVAR VAR(&IN53) VALUE('1'))
     CHGVAR VAR(&ONCE) VALUE('Y')
     IF COND(&BAROPT *EQ 00) THEN(DO)
/*AJ  */     IF         COND(&MENUPAGE *EQ 0) THEN(DO)
                SNDRCVF    RCDFMT(KIOSKD1)
             MONMSG     MSGID(CPF4100 +
                              CPF4200 +
                              CPF4300 +
                              CPF5100 +
                              CPF5200 +
                              CPF5300 +
                              CPF5500 +
                              CPF5600 +
                              CPF5700) EXEC(SIGNOFF *LIST)
 /*      THESE ARE DEVICE FAILURE MESSAGES MOST NOT RECOVERABLE   +
         SO FOR SIMPLICITY WE ARE GOING TO SIGNOFF AND LEAVE A LIST */
/*AJ  */ ENDDO
/*AJ  */     ELSE       CMD(DO)
/*AJ  */DISPLAYB:
/*AJ  */
/*AJ  */     SNDRCVF    RCDFMT(KIOSKD1)
/*AJ  */     MONMSG     MSGID(CPF4100 +
/*AJ  */                      CPF4200 +
/*AJ  */                      CPF4300 +
/*AJ  */                      CPF5100 +
/*AJ  */                      CPF5200 +
/*AJ  */                      CPF5300 +
/*AJ  */                      CPF5500 +
/*AJ  */                      CPF5600 +
/*AJ  */                      CPF5700) EXEC(SIGNOFF *LIST)
/*AJ  *//* THESE ARE DEVICE FAILURE MESSAGES MOST NOT RECOVERABLE */
/*AJ  *//* SO FOR SIMPLICITY WE ARE GOING TO SIGNOFF AND LEAVE A LIST*/
/*AJ  */
/*AJ  */ ENDDO
             IF        (&IN03 = '1') +
                 DO
                 TFRCTL PGM(OEC1000) PARM(&BAROPT)
                 ENDDO
             IF         COND(&IN16 = '1') THEN(RETURN)
             IF         (&IN25 = '1')  +
                 DO
                 CALL       PGM(HTR0010) PARM(&PROG &SCREEN)
                 GOTO DISPLAY
                 ENDDO
/*AJ  */ /*----------------------------------------------------------*/
/*AJ  */ /*      DETERMINES IF ROLL UP OR ROLL DOWN KEY WAS PRESSED  */
/*AJ  */ /*----------------------------------------------------------*/
/*AJ  */     IF         COND(&IN27 = '1') THEN(DO) /*ROLL UP  */
/*AJ  */     CHGVAR     VAR(&MENUPAGE) VALUE(1)
/*AJ  */         GOTO DISPLAY
/*AJ  */     ENDDO
/*AJ  */     IF      COND(&IN28 = '1') THEN(DO)
/*AJ  */     CHGVAR     VAR(&MENUPAGE) VALUE(0)
/*AJ  */         GOTO DISPLAY
/*AJ  */     ENDDO
/*AJ  */ /*----------------------------------------------------------*/
 /*                                                                  */
 /* IF NOTHING ENTERED ON COMMAND LINE, THEN REDISPLAY MENU          */
         IF   COND(&CMDLIN *EQ ' ') THEN(GOTO DISPLAY)
 /* CALL COMMAND LINE CHECK PROGRAM TO DETERMINE IF FAST PATH OR OPT */
         IF   COND(&CMDLIN *NE ' ') THEN(CALL PGM(OPR0075) +
              PARM(&CMDLIN &CMDOPT &PTHOPT))

         IF   COND(&PTHOPT *EQ 'E') THEN(DO)
              CHGVAR (&IN99) VALUE('1')
              CHGVAR (&IN92) VALUE('0')
              GOTO   CMDLBL(DISPLAY)
              ENDDO
 /*                                                                  */
 /* Fast Path                                                        */
 /*                                                                  */
       IF     COND(&PTHOPT = 'P') THEN(DO)
              CHGVAR &FPATH  VALUE(&CMDLIN)
             IF         COND(%SST(&FPATH 1 1) = '?') THEN(CALL +
                          PGM(OPR0105) PARM(&FPATH))
         IF   COND(&FPATH *EQ ' ') THEN(DO)
              GOTO       CMDLBL(DISPLAY)
         ENDDO
             IF         COND(&FPATH *NE ' ') THEN(DO)
               CALL       PGM(OPR0100) PARM(&FPATH &FPGM &RTNCDE)
               IF         COND(&RTNCDE) THEN(CHGVAR VAR(&IN92) +
                            VALUE('1'))
               ELSE       CMD(DO)
                 CHGVAR VAR(&BAROPT) VALUE(0)
                 TFRCTL PGM(&FPGM) PARM(&BAROPT)
               ENDDO
               GOTO       CMDLBL(DISPLAY)
             ENDDO
       ENDDO
 /*                                                                  */
 /*  CHECK SECURITY                                                  */
 /*                                                                  */
       IF     COND(&PTHOPT = 'O') THEN(DO)
         CHGVAR    VAR(&OPTION)  VALUE(&CMDOPT)
             CHGVAR     VAR(&AUTH) VALUE('Y')
             CHGVAR     VAR(&LVL) VALUE('01')
             CHGVAR     VAR(&OPT) VALUE(&OPTION)
             CALL       PGM(OPR0026) PARM(&USER &APPL &LVL &OPT +
                          &AUTH)
             IF         COND(&AUTH *EQ 'N') THEN(DO)

   /* CHECK FOR MENU OPTION ONLY */
             IF         COND(&OPT *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN92) VALUE('0')
             GOTO       CMDLBL(DISPLAY)
             ENDDO

             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO       CMDLBL(DISPLAY)
             ENDDO
       ENDDO
       ENDDO
   /* PLACE PASSED IN OPTION IN SCREEN FIELD  */
             IF COND(&BAROPT *NE 00) THEN(DO)
                CHGVAR VAR(&OPTION) VALUE(&BAROPT)
             ENDDO
 /*                                                              */
 /* ORDER ENTRY                                                  */
 /*                                                              */
             IF         COND(&OPTION = 1) THEN(DO)
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
                     CALL PGM(OEC2018)
                 GOTO DISPLAY
                 ENDDO
 /*                                                              */
 /* REVIEW ORDERS                                                */
 /*                                                              */
             IF         COND(&OPTION = 2) THEN(DO)
/*AK  */     CALL       PGM(OPC9990) PARM('3' 'WKPWREQ   ')
/*AK  */     OVRDBF     FILE(WKPWREQ) TOFILE(QTEMP/WKPWREQ)
/*AK  */     CALL       PGM(OPC9990) PARM('0' 'WKPWREQ   ')
                     CALL PGM(OER2050)
                 GOTO DISPLAY
                 ENDDO
 /*                                                              */
 /* SHORT/FAST REVIEW                                            */
 /*                                                              */
             IF         COND(&OPTION = 3) THEN(DO)
                     CALL PGM(OER2065)
                 GOTO DISPLAY
                 ENDDO
 /*                                                              */
 /* PENDING ORDERS                                               */
 /*                                                              */
             IF         COND(&OPTION = 4) THEN(DO)
           CHGVAR     VAR(&PGMNAM) VALUE(OER2090)
           CALL       PGM(OER5006) PARM(&PGMNAM)
                 GOTO DISPLAY
                 ENDDO
 /*                                                              */
 /* RESERVED ORDERS                                              */
 /*                                                              */
             IF         COND(&OPTION = 5) THEN(DO)
           CHGVAR     VAR(&PGMNAM) VALUE(OER2095)
           CALL       PGM(OER5006) PARM(&PGMNAM)
                 GOTO DISPLAY
                 ENDDO
 /*                                                              */
 /* REVIEW QUOTATIONS                                            */
 /*                                                              */
             IF         COND(&OPTION = 6) THEN(DO)
           CHGVAR     VAR(&PGMNAM) VALUE(OER2098)
           CALL       PGM(OER5006) PARM(&PGMNAM)
                 GOTO DISPLAY
                 ENDDO
 /*                                                              */
 /* STANDARD ORDER ENTRY/MAINTENANCE                             */
 /*                                                              */
             IF         COND(&OPTION = 7) THEN(DO)
             CHGVAR     VAR(&PGMNAM) VALUE('OER1050   ')
             CALL       PGM(ARR9001) PARM(&PGMNAM &CUST#)
             GOTO       CMDLBL(DISPLAY)
             ENDDO
/*                                                               */
/*  CONTRACT ORDER ENTRY                                         */
/*                                                               */
             IF         COND(&OPTION = 8) THEN(DO)
               CALL PGM(OEC0015)
               GOTO DISPLAY
             ENDDO
 /*                                                              */
 /* CONTRACT ORDER MAINTENANCE                                   */
 /*                                                              */
             IF         COND(&OPTION = 9) THEN(DO)
               CALL       PGM(OER0050) PARM('M')
               GOTO       CMDLBL(DISPLAY)
             ENDDO
 /*                                                              */
 /* C/O RELEASES                                                 */
 /*                                                              */
             IF         COND(&OPTION = 10) THEN(DO)
 /*  AA*//*    CALL       PGM(OER6085) PARM(X'0000000F')         */
 /*AAAM*//*    CALL       PGM(OER6085) PARM('0000000')           */
 /*AM  */     CALL       PGM(OER6085) PARM('0000000' 'N' 'A' 'Y')
               GOTO       CMDLBL(DISPLAY)
             ENDDO
 /*                                                              */
 /* CUSTOMER SELECTION (O/E & C/O)                               */
 /*                                                              */
             IF         COND(&OPTION = 11) THEN(DO)
               CALL       PGM(OER6100)
               GOTO       CMDLBL(DISPLAY)
             ENDDO
 /*                                                              */
 /* ITEM PRICE INQUIRY                                           */
 /*                                                              */
             IF         COND(&OPTION = 12) THEN(DO)
             CHGVAR     VAR(&PGMNAM) VALUE('PRR0750   ')
             CALL       PGM(ARR5700) PARM(&PGMNAM)
             GOTO       CMDLBL(DISPLAY)
             ENDDO
 /*                                                              */
 /* ITEM SEARCH                                                  */
 /*                                                              */
             IF         COND(&OPTION = 13) THEN(DO)
                     CALL PGM(IVR2000)
                 GOTO DISPLAY
                 ENDDO
 /*                                                              */
 /* STOCK STATUS                                                 */
 /*                                                              */
             IF         COND(&OPTION = 14) THEN(DO)
                     CALL PGM(IVR0420) PARM(&ITM &BR ' ' ' ')
                 GOTO DISPLAY
                 ENDDO

/*AJ  */  /*---------------------------------------------------------*/
/*AJ  */  /*           MENU CALLS FOR SECOND PAGE OF MENU            */
/*AJ  */  /*---------------------------------------------------------*/
/*AJ  */
/*AJ  */     CHGVAR     VAR(&MENUPAGE) VALUE(1)
/*AJ  *//* CUSTOMER RETURN                                                    */
/*AJ  */     IF         COND(&OPTION = 15) THEN(DO)
/*AJ  */     CHGVAR     VAR(&OPTION) VALUE(0)
/*AJ  */     CALL       PGM(OEC0450)
/*AJ  */     GOTO       DISPLAY
/*AJ  */     ENDDO
/*AN  *//* DISCLAIMER TEST ENTRY/MAINTENANCE                                  */
/*AN  */     IF         COND(&OPTION = 16) THEN(DO)
/*AN  */     CHGVAR     VAR(&OPTION) VALUE(0)
/*AN  */     CALL       PGM(OER2032)
/*AN  */     GOTO       DISPLAY
/*AN  */     ENDDO
/*AO  *//* ENHANCED LOST SALES TRANSACTION ENTRY                              */
/*AO  */     IF         COND(&OPTION = 17) THEN(DO)
/*AO  */     CHGVAR     VAR(&OPTION) VALUE(0)
/*AO  */     CALL       PGM(OER2190) PARM('MN' ' ' ' ' ' ' ' ')
/*AO  */     GOTO       DISPLAY
/*AO  */     ENDDO

/*¢A  *//* Work With Reserved Orders                                          */
/*¢A  */     IF         COND(&OPTION = 20) THEN(DO)
/*¢A  */     CHGVAR     VAR(&OPTION) VALUE(0)
/*¢A  */     CALL       PGM(OERC615)
/*¢A  */     GOTO       DISPLAY
/*¢A  */     ENDDO

/*¢B  *//* Work With Orders                                                   */
/*¢B  */     IF         COND(&OPTION = 21) THEN(DO)
/*¢B  */     CHGVAR     VAR(&OPTION) VALUE(0)
/*¢B  */     CALL       PGM(OERC620)
/*¢B  */     GOTO       DISPLAY
/*¢B  */     ENDDO

             GOTO  DISPLAY
/*                                                                   */
/*   DISPLAY MESSAGE THAT NOT AUTHORIZED TO THIS OPTION              */
/*                                                                   */
ERROR:       CHGVAR &IN99 '1'
             GOTO DISPLAY
ENDIT:       ENDPGM
