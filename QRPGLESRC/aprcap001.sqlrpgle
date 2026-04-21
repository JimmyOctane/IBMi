     H OPTION(*SRCSTMT:*NODEBUGIO) dftactgrp(*NO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - APRCAP001                                              *
     F*------------------------------------------------------------------------*
     F*P                                                                       *
     F*------------------------------------------------------------------------*
     F*D    CAPTURIS HISTORY                                                   *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3030 111924 JJF Created program                                 *
     F*M ----------------------------------------------------------------------*
     F*========================================================================*
          dcl-f APDCAP001  WORKSTN INFDS(INFDS)
            SFILE(SUB01:RRN1) SFILE(SUB02:RRN2)
            SFILE(SUB03:RRN3) SFILE(SUB04:RRN4);
          dcl-f APLTINHG DISK(*EXT) KEYED USAGE(*INPUT);

          //
          //  Field Definitions.
          //
          dcl-s count packed(7:0) inz;
          dcl-s count2 packed(7:0) inz;
          dcl-s count3 packed(7:0) inz;
          dcl-s count4 packed(7:0) inz;
          dcl-s commandString char(5000) inz;
          dcl-s commandLength packed(15:5);
          dcl-s currentMonth zoned(9:2) inz;
          dcl-s emailAddress char(45) inz;
          dcl-s endScreen1 ind inz(*off);
          dcl-s endScreen2 ind inz(*off);
          dcl-s endScreen3 ind inz(*off);
          dcl-s endScreen4 ind inz(*off);
          dcl-s endScreen5 ind inz(*off);
          dcl-s i int(10:0) inz;
          dcl-s i2 int(10:0) inz;
          dcl-s i3 int(10:0) inz;
          dcl-s i4 int(10:0) inz;
          dcl-s invoiced ind inz(*off);
          dcl-s invoiceIsodate date inz;
          dcl-s isodate date inz;
          dcl-s lastInvoice char(22) inz;
          dcl-s lastLine# int(10:0) inz;
          dcl-s lenstr int(10:0) inz;
          dcl-s maxItemLines  packed(5:0)inz(999);
          dcl-s messagecsc int(10:0) inz;
          dcl-s messageData char(80) inz;
          dcl-s messagekey char(4) inz;
          dcl-s messageLen int(10:0) inz;
          dcl-s messageFile char(20) inz('ECMMSGF   *LIBL   ');
          dcl-s messageid char(7) inz;
          dcl-s myStart int(10:0) inz;
          dcl-s prodTest char(10) inz;
          dcl-s Q char(1) inz('''');
          dcl-s rowCount int(10:0) inz;
          dcl-s rowCount2 int(10:0) inz;
          dcl-s rowCount3 int(10:0) inz;
          dcl-s rowCount4 int(10:0) inz;
          dcl-s RRN1 like(SCRRN) inz;
          dcl-s RRN2 like(SCRRN) inz;
          dcl-s RRN3 like(SCRRN) inz;
          dcl-s RRN4 like(SCRRN) inz;
          dcl-s savRRN like(SCRRN) inz;
          dcl-s savRRN2 like(SCRRN) inz;
          dcl-s savRRN3 like(SCRRN) inz;
          dcl-s savRRN4 like(SCRRN) inz;
          dcl-s screenError ind inz;
          dcl-s screenError2 ind inz;
          dcl-s screenError3 ind inz;
          dcl-s screenError4 ind inz;
          dcl-s screenError5 ind inz;
          dcl-s screen3Date date inz;
          dcl-s serviceFromIsodate date inz;
          dcl-s serviceToIsodate date inz;
          dcl-s stringLength int(10:0) inz;
          dcl-s userID char(10) inz;
          dcl-s validAPVendor ind inz(*off);
          dcl-s validBranch ind inz(*off);
          dcl-s validCompany ind inz(*off);
          dcl-s validGLAccount ind inz(*off);
          dcl-s workInvoice like(c1invoice) inz;
          dcl-s workc2Vendor zoned(6:0);
          dcl-s workTitle char(40) inz;
          dcl-s workTitle25 char(25) inz;
          dcl-s ytdAmount zoned(9:2) inz;
          //  001-022-03-5040-001
          dcl-s workCompany zoned(3:0) inz;
          dcl-s workBranch zoned(3:0) inz;
          dcl-s workDepartment zoned(2:0) inz;
          dcl-s workError char(20) inz;
          dcl-s workMain zoned(4:0) inz;
          dcl-s workSub zoned(3:0) inz;


       // -----------------------------------------------------------------
       // Entry parameter list prototype and declaration
       // -----------------------------------------------------------------
       // -------------- *Plist --------------- Prototypes
          dcl-pr main extpgm('APRCAP001');
           P_invoice  Char(22)  Options(*nopass);
          end-pr;

          dcl-pi main;
           P_invoice  Char(22)  Options(*nopass);
          end-pi;

       // --------------------- Prototypes --------------------

          dcl-pr $command extpgm('QCMDEXC');
           command_ char(5000);
           Length_  packed(15:5);
          end-pr;

          dcl-pr $clearmsg extpgm('QMHRMVPM');
           messageq_  char(276) const;
           CallStack_   int(10:0) const;
           Messagekey_  char(4)   const;
           messagermv_  char(10)  const;
           ErrorCode_   like(apierror);
          end-pr;

          dcl-pr $sendmsg extpgm('QMHSNDPM');
           MessageID_  char(7) const;
           QualMsgF_  char(20) const;
           MsgData_ char(256) const;
           MsgDtaLen_ int(10:0) const;
           MsgType_  char(10) const;
           CallStkEnt_ char(10) const;
           CallStkCnt_ int(10:0) const;
           Messagekey_ char(4);
           ErrorCode_  like(apierror);
          end-pr;

          dcl-pr getEmailAddress extpgm('ECC9997');
           userName_  char(10);
           emailAddress_ char(45);
          end-pr;

          dcl-pr getSqlDiagnostics char(256);
          end-pr;

      // Stock Status Inquiry
          dcl-pr getStockStatus extpgm('IVR0420');
           item_   packed(6:0);
           branch_ packed(3:0);
           shipping_ char(1);
           AllowUpdate_  char(1);
          end-pr;

      // Security Porfile check
          dcl-pr securityProfile  extpgm('OPR0026');
           userID_  char(10);
           application_  char(2);
           level_ char(2);
           option_  char(2);
           authority_  char(1);
          end-pr;

      // Command Keys
          dcl-c Cmd01          const(x'31');    // Cmd-1
          dcl-c Cmd02          const(x'32');    // Cmd-2
          dcl-c LeaveProgram   const(x'33');    // Cmd-3
          dcl-c Prompt         const(x'34');    // Cmd-4
          dcl-c Refresh        const(x'35');    // Cmd-5
          dcl-c Print          const(x'36');    // Cmd-6
          dcl-c Cmd07          const(x'37');    // Cmd-7
          dcl-c Cmd08          const(x'38');    // Cmd-8
          dcl-c Cmd09          const(x'39');    // Cmd-9
          dcl-c Cmd10          const(x'3A');    // Cmd-10
          dcl-c Cmd11          const(x'3B');    // Cmd-11
          dcl-c Previous       const(x'3C');    // Cmd-12
          dcl-c Cmd13          const(x'B1');    // Cmd-13
          dcl-c Cmd14          const(x'B2');    // Cmd-14
          dcl-c Cmd15          const(x'B3');    // Cmd-15
          dcl-c Cmd16          const(x'B4');    // Cmd-16
          dcl-c Cmd17          const(x'B5');    // Cmd-17
          dcl-c Cmd18          const(x'B6');    // Cmd-18
          dcl-c Cmd19          const(x'B7');    // Cmd-19
          dcl-c Cmd20          const(x'B8');    // Cmd-20
          dcl-c Cmd21          const(x'B9');    // Cmd-21
          dcl-c Cmd22          const(x'BA');    // Cmd-22
          dcl-c Cmd23          const(x'BB');    // Cmd-23
          dcl-c Cmd24          const(x'BC');    // Cmd-24
          dcl-c EnterKey       const(x'F1');    //
          dcl-c PageDown       const(x'F5');    // Roll Up
          dcl-c PageUp         const(x'F4');    // Roll Down

      *
      * data structures

          dcl-ds psds PSDS qualified;
           program char(10) pos(1);
           procedureName *PROC;
           statusCode *STATUS;
           nbrPassedParms *PARMS;
           messageText char(80) pos(91);
           exceptionId char(4) pos(171);
           jobName char(10) pos(244);
           jobUser char(10) pos(254);
           number zoned(6) pos(264);
           jobnumber zoned(6) pos(264);
          end-ds;

          dcl-ds INFDS qualified;
           choice char(1) pos(369);
           cLocation char(2) pos(370);
           curRec int(5:0) pos(378);
          end-ds;

          dcl-ds ApiError;
           AeBytPro int(10:0) inz(%Size(ApiError));
           AeBytAvl int(10:0) inz;
           AeMsgId char(7);
           someField char(1);
           AeMsgDta char(128);
          end-ds;

          dcl-ds sqlDS;
           ReturnedSqlCode char(5);
           ReturnedSQLState char(5);
           MessageLength int(5:0);
           MessageText char(32740);
           MessageId1 char(10);
           MessageId2 varchar(7);
           MessageId3 varchar(7);
          end-ds;

          dcl-ds c1 dim(9999) qualified;
          APVendor char(15);
          apVendorName char(30);
          branch zoned(3:0);
          invoicedDate date;
          invoiceAmount zoned(9:2);
          serviceDateFrom date;
          serviceDateTo date;
          capturisInvoice char(30);
          serviceAccount char(30);
          serviceInvoice char(22);
          serviceDate char(30);
          siteName char(30);
          GLAccount char(20);
          serviceDescription char(30);
          addDate date;
         end-ds;

         dcl-ds c2 dim(9999) qualified;
          APVendor char(15);
          apVendorName char(30);
         end-ds;

         dcl-ds c3 dim(9999) qualified;
          invoice  char(22);
          date date(*iso);
          total zoned(9:2);
         end-ds;

         dcl-ds c4 dim(9999) qualified;
          branch zoned(3:0);
          name char(25);
         end-ds;

      *
      * title and headings set-up
      *
              exec sql  set option commit=*none,datfmt=*iso,
                            closqlcsr=*ENDMOD;

              *inlr = *on;

              PGMQ = psds.program;
              reset prodTest;
              exec sql
              select data_area_value
               into :prodTest
               from qsys2.data_area_info
                WHERE data_area_name = 'PRODTEST' and
                data_area_library = 'QGPL';

              reset emailAddress;
              getEmailAddress(psds.jobuser:emailAddress);

              // set 1st invoice
              if %parms >= 1;
               c1invoice = p_invoice;
              else;
               exec sql
                select APCAPINV
                into :c1invoice
                from APCAPHSTP
                where aprecstmp in
                (select max(aprecstmp)
                 from APCAPHSTP
                 fetch first row only)
                 fetch first row only;
              endif;
              stringLength = %len(%trim(c1invoice));
              if myStart > *zeros;
               myStart = (%len(c1Invoice) - stringLength)+1;
               reset workInvoice;
               %subst(workInvoice:myStart) = c1invoice;
               c1Invoice=workInvoice;
              endif;

              exsr $clearsfl;
              exsr $loadsfl;
              exsr $screen1;

        //----------------------------------------
        // $screen1 - show non-matched quantities
        //----------------------------------------
             begsr $screen1;

              workTitle = 'CAPTURIS - Transaction History';
              clear c1Title;
              LenStr =
              ((%len(workTitle) - %len(%trim(workTitle))) / 2) + 1;
              %subst(C1TITLE:LenStr) = %trim(workTitle);

              reset endscreen1;
              dow not(endScreen1);
               if ScreenError = *off;
                $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);
               endif;
               c1format = 'SUB01CTL';
               write FKEY01;
               write MSGCTL;
               exfmt SUB01CTL;
               reset ScreenError;
               $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);

               if infds.Currec <> *Zeros;
                RRN1  =  infds.Currec;
                SCRRN =  infds.Currec;
               endif;

               select;
                //
                // F3/F12 pressed leave program
                //
                when  infds.Choice = LeaveProgram or
                         infds.Choice = previous;
                 endscreen1 = *on;
                 //
                 // F5 = Refresh
                 //
                when  infds.Choice = refresh;
                 exsr $clearsfl;
                 exsr $loadsfl;

                 //
                 // Enter Key pressed
                 //
                when  infds.Choice = prompt;
                 exsr $prompt;
                 //
                 // Enter Key pressed
                 //
                 when  infds.Choice = enterKey;
                  if *in80;
                   exsr $validate;
                   if not(screenError);
                    exsr $clearsfl;
                    exsr $loadsfl;
                   endif;
                  else;
                   reset screenError;
                   exsr $process;
                  endif;

               endsl;
              enddo;

             endsr;

        //----------------------------------------
        // $validate - validate the dates entered
        //----------------------------------------
             begsr $validate;

              *in25 = *off;
              *in26 = *off;
              *in27 = *off;
              *in28 = *off;

              // validate branch
              reset validBranch;
              exec sql
               SELECT '1'
                into :validBranch
                from ARPMBCH
                 where (ARFL16 = ' ') and
                  ARNO16 = :c1branch or :c1branch = 0
                  fetch first row only with NC;

              if not(validBranch);
               *in25 = *on;
               screenerror = *on;
               messageid   = 'GEN0012';
               messagedata = %editc(c1Branch:'X');
               messagelen = %len(%trim(messagedata));
               exsr $sendmessage;
              endif;

              // date = C1INVDATE
              test(de) *mdy  C1INVDATE;
              if %error() and C1INVDATE <> *zeros;
               *in26 = *on;
               screenerror = *on;
               messageid   = 'GEN0010';
               messagedata = *blanks;
               messagelen = %len(%trim(messagedata));
               exsr $sendmessage;
              endif;

              // date = C1SRVCFROM
              test(de) *mdy  C1SRVCFROM;
              if %error() and C1SRVCFROM <> *zeros;
               *in27 = *on;
               screenerror = *on;
               messageid   = 'GEN0010';
               messagedata = *blanks;
               messagelen = %len(%trim(messagedata));
               exsr $sendmessage;
              endif;

              // date = C1SRVCTO
              test(de) *mdy  C1SRVCTO;
              if %error() and C1SRVCTO <> *zeros;
               *in28 = *on;
               screenerror = *on;
               messageid   = 'GEN0010';
               messagedata = *blanks;
               messagelen = %len(%trim(messagedata));
               exsr $sendmessage;
              endif;

             endsr;

        //----------------------------------------
        // $clearSfl - clear the subfile
        //   show bank records from TF
        //----------------------------------------
             begsr $clearSFL;

              // clear the subfile first
              *in31 = *Off;
              *in32 = *Off;
              *in30 = *On;
              write  SUB01CTL;
              *in31 = *On;
              *in32 = *On;
              *in30 = *Off;

              clear RRN1;
              clear SCRRN;
              clear SavRrn;

              *in33 = *Off;
              clear s1opt;

              reset lastInvoice;

             endsr;

        //----------------------------------------
        // $Loadsfl - page down & subfile records
        //----------------------------------------
             begsr $loadsfl;

              if SavRrn  > *Zeros;
               rrn1  = savrrn;
               scrrn = savrrn;
              endif;

              // set the invoice date back to *ISO
              if C1INVDATE <> *zeros;
               invoiceIsodate = %date(C1INVDATE:*mdy);
              endif;

              // set from and to service dates
              reset serviceFromIsodate;
              reset serviceToIsodate;
              if C1SRVCFROM <> *zeros;
               test(de) *mdy  C1SRVCFROM;
               if not(%error);
                serviceFromIsodate = %date(C1SRVCFROM:*mdy);
               endif;
              endif;
              if C1SRVCTO <> *zeros;
               test(de) *mdy  C1SRVCTO;
               if not(%error);
                serviceToIsodate = %date(C1SRVCTO:*mdy);
               endif;
              endif;

              exec SQL
              declare c1 scroll cursor for
               select APVENDOR, APVENDORNM,
                APBRSITE, APINVDAT,
                APSRVAMT,APSRVFRM,APSRVTO, APCAPINV,
                APVENDACCT,APVENDINV,APSRVDAT,APBRSITENM, APGLACCT,
                APSRVDESC, date(APRECSTMP)
               from APCAPHSTP
               where (:c1Invoice = ' ' or
                     trim(:c1invoice) = APCAPINV) and
                     (:c1vendor = ' ' or
                     cast(substr(:c1Vendor,1,6) as decimal(6,0))
                     = APVENDOR) and
                     (:c1vname = ' ' or upper(APVENDORNM)
                     like  '%' || trim(:c1vname) || '%')  and
                     (:c1branch = 0 or APBRSITE = :c1branch) and
                     (:c1invdate = 0 or APINVDAT = :invoiceIsodate) and
                     (:c1srvcfrom = 0 or APSRVFRM >= :serviceFromIsodate) and
                     (:c1srvcto = 0 or APSRVTO <= :serviceToIsodate)
                     order by APINVDAT desc, APCAPINV
              for read only;

              // C1SRVCFROM -> C1SRVCTO  (6:0)

              exec SQL open c1;

              exec sql
               fetch first from C1 for :maxItemLines rows into :C1;
              exec sql get diagnostics :rowCount = ROW_COUNT;
              dow rowCount <> 0;
               For i = 1 to rowCount;

                s1Apvendor = c1(i).APVendor;

                reset validAPVendor;
                exec sql
                 select '1'
                  into :validAPVendor
                    from appmven
                    where apno01 = dec(trim(:s1Apvendor),6,0);

                s1vname = c1(i).APVendorName;
                s1branch = c1(i).branch;

                // validate branch
                reset validBranch;
                exec sql
                 select '1'
                  into :validBranch
                    from arpmbch
                    where arno16 = dec(trim(:s1Branch),3,0);

                s1invdate = %dec(c1(i).invoicedDate:*mdy);
                s1Amount = c1(i).invoiceAmount;

                s1srvcfrom = %dec(c1(i).serviceDateFrom:*mdy);
                s1srvcto = %dec(c1(i).serviceDateTo:*mdy);

                // move to the right s1invoice = 20
                stringLength = %len(%trim(c1(i).capturisInvoice));
                myStart = (%len(s1Invoice) - stringLength)+1;

                clear s1Invoice;
                %subst(s1Invoice:myStart) = c1(i).capturisInvoice;

                // get status of the invoice - created/in error
                reset workerror;
                exec sql
                 select APTX07
                   into :workError
                   from APPWIAP
                   where trim(APNO11) = trim(:s1Invoice)
                   fetch first row only with NC;
                select;
                 when lastInvoice <> %trim(s1Invoice);
                  s1error = workError;
                  lastInvoice = %trim(s1Invoice);
                  // ready to invoice or invoiced
                  if s1error = *blanks;

                   reset invoiced;
                   setll s1Invoice APLTINHG;
                   if %equal;
                    s1error = 'Invoiced';
                   else;
                    s1error = 'Ready to Invoice';
                   endif;
                  endif;
                other;
                 s1error = *blanks;
                endsl;

                H1SRVACCT = c1(i).serviceAccount;
                H1SRVINV= c1(i).serviceInvoice;
                H1SDATES = c1(i).serviceDate;
                h1Site = c1(i).siteName;
                h1GLACCT = c1(i).GLAccount;
                H1SERVD = c1(i).serviceDescription;
                h1adddate = %char(c1(i).addDate);


                // validate the GL account number
                reset validGLAccount;

                workCompany = %dec(%xlate(' ':'0':%subst(h1GLACCT:1:3)):3:0);
                workBranch = %dec(%xlate(' ':'0':%subst(h1GLACCT:5:3)):3:0);
                workDepartment = %dec(%xlate(' ':'0':%subst(h1GLACCT:9:2)):2:0);
                workMain = %dec(%xlate(' ':'0':%subst(h1GLACCT:12:4)):4:0);
                workSub = %dec(%xlate(' ':'0':%subst(h1GLACCT:17:3)):3:0);

                exec sql
                 select '1'
                  into :validGLAccount
                  from GLPMSTR
                  where GLNO01 = :workCompany and
                        GLNO06 = :workBranch and
                        GLNO02 = :workDepartment and
                        GLNO03 = :workMain and
                        GLNO04 = :workSub
                  fetch first row only;


                if not(validGLAccount) or %len(%trim(h1GLACCT)) <> 19 or
                 %scan('-':h1GLACCT) = *zeros or not(validAPVendor) or
                 not(validBranch);
                 h1error = 'Y';
                 *in90 = *on;
                endif;

                // dont load more records than subfile can handle
                if rrn1 <= 9999;
                 rrn1+=1;
                 scrrn = rrn1;
                 write(e) sub01;
                endif;
                *in90 = *off;
                clear h1error;

               endfor;
               exec SQL
                fetch next from C1 for :maxItemLines rows into :C1;
               exec sql get diagnostics :rowCount = ROW_COUNT;
              enddo;
              exec SQL close C1;

              savrrn = scrrn;
              *in33 = *on;
              //
              //  If no records in subfile then do not disply the subfile.
              //

              if SavRrn  = *zeros;
               *in31 = *off;
              else;
               RRN1 = 1;
               SCRRN = 1;
              endif;

             endsr;

        //----------------------------------------
        // $process - company is valid continue process
        //----------------------------------------
             begsr $process;

              for count = 1 to SAVRRN;
               chain count SUB01;
               if %found();
                select;

                 when s1opt = '5';
                  exsr $screen5;
                endsl;

                s1opt = *blanks;
                if h1error = 'Y';
                 *in90 = *on;
                endif;

                update(e) SUB01;
                *in90 = *off;
               endif;
              endfor;

             endsr;

        //----------------------------------------
        // $screen2 - window lookup vendor
        //----------------------------------------
             begsr $screen2;

              exsr $clearsfl2;
              exsr $loadsfl2;

              workTitle25 = 'Vendor Lookup';
              clear w1Title;
              LenStr =
              ((%len(workTitle25) - %len(%trim(workTitle25))) / 2) + 1;
              %subst(w1TITLE:LenStr) = %trim(workTitle25);

              reset endscreen2;
              dow not(endScreen2);
               if ScreenError2 = *off;
                $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);
               endif;
               write WINDOWFMT1;
               write MSGCTL2;
               c2format = 'SUB02CTL';
               exfmt SUB02CTL;
               reset ScreenError2;
               $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);

               if infds.Currec <> *Zeros;
                RRN2  =  infds.Currec;
                SCRRN2 =  infds.Currec;
               endif;

               select;
                //
                // F3/F12 pressed leave program
                //
                when  infds.Choice = LeaveProgram or
                         infds.Choice = previous;
                 endscreen2 = *on;
                 //
                 // prompt
                 //
                when  infds.Choice = prompt;
                 exsr $prompt;

                 //
                 // Enter Key pressed
                 //
                 when  infds.Choice = enterKey;
                  if *in81;
                   exsr $clearsfl2;
                   exsr $loadsfl2;
                  else;
                   exsr $validate2;
                   if not(screenError2);
                    exsr $process2;
                   endif;
                  endif;

               endsl;
              enddo;

             endsr;

        //----------------------------------------
        // $validate2 - validate the vendor lookup
        //----------------------------------------
             begsr $validate2;
              reset screenError2;

             endsr;

        //----------------------------------------
        // $process2 - process Vendor Lookup
        //----------------------------------------
             begsr $process2;

              for count2 = 1 to SAVRRN2;
               chain count2 SUB02;
               if %found();
                select;
                 when s2opt = '1';
                  c1vendor = S2APVENDOR;
                  c1vname = s2vname;
                  exsr $clearsfl;
                  exsr $loadsfl;
                  endScreen2 = *on;
                  leave;
                endsl;

                s2opt = *blanks;

                update(e) SUB02;
               endif;
              endfor;

             endsr;

        //----------------------------------------
        // $setPosition - highlight last line used
        //----------------------------------------
             begsr $setPosition;

              // position to line
              if lastLine# <> count and
                 lastLine# > *zeros;
               chain lastLine# SUB01;
               if %found();
                *in72 = S1RvwdRed;
                *in90 = *off;
                update(e) SUB01;
               endif;
              else;
               *in90 = *on;
              endif;

             endsr;

        //----------------------------------------
        // $sendmessage - send the program message
        //----------------------------------------
             begsr $sendmessage;

              Messagefile = 'ECMMSGF   *LIBL   ';
              $sendmsg(messageID   :
                       messageFile :
                       messagedata :
                       messageLen  :
                       '*DIAG'     :
                       psds.program:
                       messagecsc  :
                       messagekey  :
                       APIError
                                   );
             endsr;

        //----------------------------------------
        // $clearSfl2 - clear the subfile
        //   lookup for vendor
        //----------------------------------------
             begsr $clearSFL2;

              // clear the subfile first
              *in35 = *Off;
              *in36 = *Off;
              *in34 = *On;
              write  SUB02CTL;
              *in35 = *On;
              *in36 = *On;
              *in34 = *Off;

              clear RRN2;
              clear SCRRN2;
              clear SavRrn2;

              *in37 = *Off;
              clear s2opt;

             endsr;

        //----------------------------------------
        // $Loadsfl2 - page down & subfile records
        //----------------------------------------
             begsr $loadsfl2;

              if SavRrn2 > *Zeros;
               rrn2  = savrrn2;
               scrrn2 = savrrn2;
              endif;

              reset workc2Vendor;
              if c2vendor <> *blanks and
                 %check(' 0123456789':c2vendor) = *zeros;
               workc2Vendor = %dec(%trim(c2vendor):6:0);
              endif;

              exec SQL
              declare c2 scroll cursor for
              select apno01, apnm01 from(
              select  a.apno01, a2.apnm01
              from APPMVEA a
              join APPMVEN a2
              on a.apno01 = a2.apno01
              where a.OPNM25 = 'AUTO_PAY' and a.OPTX20 = 'Y'
              union all
              select apvendor as apno01,
              apvendornm as apnm01
               from APCAPHSTP b
               where apvendor not in (
                select  apno01
              from APPMVEA v
              where v.OPNM25 = 'AUTO_PAY' and v.OPTX20 = 'Y')
               group by b.apvendor,b.apvendornm)
               where (:C2VENDOR = ' ' or  :c2vendor <> ' ' and
                :workc2Vendor  = apno01) and
                (:C2VNAME = ' ' or upper(apnm01)
                like  '%' || trim(:c2vname) || '%')
               order by apno01
              for read only;

              exec SQL open c2;

              exec sql
               fetch first from C2 for :maxItemLines rows into :C2;
              exec sql get diagnostics :rowCount2 = ROW_COUNT;
              dow rowCount2 <> 0;
               For i2 = 1 to rowCount2;
                s2Apvendor = c2(i2).APVendor;
                s2VName = c2(i2).apVendorName;
                rrn2+=1;
                scrrn2 = rrn2;
                write(e) sub02;

               endfor;
               exec SQL
                fetch next from C2 for :maxItemLines rows into :C2;
               exec sql get diagnostics :rowCount2 = ROW_COUNT;
              enddo;
              exec SQL close C2;

              savrrn2 = scrrn2;
              *in37 = *on;
              //
              //  If no records in subfile then do not disply the subfile.
              //
              if SavRrn2  = *zeros;
               *in35 = *off;
              else;
               RRN2 = 1;
               SCRRN2 = 1;
              endif;

             endsr;

        //----------------------------------------
        // $screen3 - window lookup capturis inv
        //----------------------------------------
             begsr $screen3;

              exsr $clearsfl3;
              exsr $loadsfl3;

              workTitle25 = 'Capturis INV Lookup';
              clear w1Title;
              LenStr =
              ((%len(workTitle25) - %len(%trim(workTitle25))) / 2) + 1;
              %subst(w1TITLE:LenStr) = %trim(workTitle25);

              reset endscreen3;
              dow not(endScreen3);
               if ScreenError3 = *off;
                $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);
               endif;
               write WINDOWFMT1;
               write MSGCTL2;
               c3format = 'SUB03CTL';
               exfmt SUB03CTL;
               reset ScreenError3;
               $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);

               if infds.Currec <> *Zeros;
                RRN3  =  infds.Currec;
                SCRRN3 =  infds.Currec;
               endif;

               select;
                //
                // F3/F12 pressed leave program
                //
                when  infds.Choice = LeaveProgram or
                         infds.Choice = previous;
                 endscreen3 = *on;
                 //
                 // prompt
                 //
                when  infds.Choice = prompt;
                 exsr $prompt;

                 //
                 // Enter Key pressed
                 //
                 when  infds.Choice = enterKey;
                  if *in83;
                   exsr $clearsfl3;
                   exsr $loadsfl3;
                  else;
                   exsr $validate3;
                   if not(screenError3);
                    exsr $process3;
                   endif;
                  endif;

               endsl;
              enddo;

             endsr;


        //----------------------------------------
        // $clearSfl3 - clear the subfile
        //   lookup for capturis invoice
        //----------------------------------------
             begsr $clearSFL3;

              // clear the subfile first
              *in39 = *Off;
              *in40 = *Off;
              *in38 = *On;
              write  SUB03CTL;
              *in39 = *On;
              *in40 = *On;
              *in38 = *Off;

              clear RRN3;
              clear SCRRN3;
              clear SavRrn3;

              *in41 = *Off;
              clear s3opt;

             endsr;

        //----------------------------------------
        // $Loadsfl3 - page down & subfile records
        //----------------------------------------
             begsr $loadsfl3;

              if SavRrn3 > *Zeros;
               rrn3  = savrrn3;
               scrrn3 = savrrn3;
              endif;

              reset screen3Date;
              test(de) *mdy  C3date;
              if %error() and C3date <> *zeros;
               screen3Date = %date(C3date:*mdy);
              endif;

              exec SQL
              declare c3 scroll cursor for
               select apcapinv , apinvdat, sum(APSRVAMT)
               from APCAPHSTP
               where (:c3date = 0 or :screen3Date = APINVDAT)
               group by apinvdat , apcapinv
               order by apinvdat desc, apcapinv
              for read only;

              exec SQL open c3;

              exec sql
               fetch first from C3 for :maxItemLines rows into :C3;
              exec sql get diagnostics :rowCount3 = ROW_COUNT;
              dow rowCount3 <> 0;
               For i3 = 1 to rowCount3;
                s3invoice = c3(i3).invoice;
                s3Date = %dec(c3(i3).date:*mdy);
                s3Total = c3(i3).total;
                rrn3+=1;
                scrrn3 = rrn3;
                write(e) sub03;

               endfor;
               exec SQL
                fetch next from C3 for :maxItemLines rows into :C3;
               exec sql get diagnostics :rowCount3 = ROW_COUNT;
              enddo;
              exec SQL close C3;

              savrrn3 = scrrn3;
              *in41 = *on;
              //
              //  If no records in subfile then do not disply the subfile.
              //
              if SavRrn3  = *zeros;
               *in39 = *off;
              else;
               RRN3 = 1;
               SCRRN3 = 1;
              endif;

             endsr;

        //----------------------------------------
        // $validate3 - validate the capturis inv
        //----------------------------------------
             begsr $validate3;
              reset screenError3;

             endsr;

        //----------------------------------------
        // $process3 - process Capturis Inv
        //----------------------------------------
             begsr $process3;

              for count3 = 1 to SAVRRN3;
               chain count3 SUB03;
               if %found();
                select;
                 when s3opt = '1';
                  c1invoice = S3INVOICE;
                  exsr $clearsfl;
                  exsr $loadsfl;
                  endScreen3 = *on;
                  leave;
                endsl;

                s3opt = *blanks;

                update(e) SUB03;
               endif;
              endfor;

             endsr;


        //----------------------------------------
        // $screen4 - window lookup branch
        //----------------------------------------
             begsr $screen4;

              exsr $clearsfl4;
              exsr $loadsfl4;

              workTitle25 = 'Capturis Branch Lookup';
              clear w4Title;
              LenStr =
              ((%len(workTitle25) - %len(%trim(workTitle25))) / 2) + 1;
              %subst(w4TITLE:LenStr) = %trim(workTitle25);

              reset endscreen4;
              dow not(endScreen4);
               if ScreenError4 = *off;
                $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);
               endif;
               write WINDOWFMT1;
               write MSGCTL2;
               c4format = 'SUB04CTL';
               exfmt SUB04CTL;
               reset ScreenError4;
               $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);

               if infds.Currec <> *Zeros;
                RRN4  =  infds.Currec;
                SCRRN4 =  infds.Currec;
               endif;

               select;
                //
                // F3/F12 pressed leave program
                //
                when  infds.Choice = LeaveProgram or
                         infds.Choice = previous;
                 endscreen4 = *on;
                 //
                 // prompt
                 //
                when  infds.Choice = prompt;
                 exsr $prompt;

                 //
                 // Enter Key pressed
                 //
                 when  infds.Choice = enterKey;
                //exsr $validate4;
                  if not(screenError4);
                   exsr $process4;
                  endif;

               endsl;
              enddo;

             endsr;


        //----------------------------------------
        // $clearSfl4 - clear the subfile
        //   lookup for branch
        //----------------------------------------
             begsr $clearSFL4;

              // clear the subfile first
              *in43 = *Off;
              *in44 = *Off;
              *in42 = *On;
              write  SUB04CTL;
              *in43 = *On;
              *in44 = *On;
              *in42 = *Off;

              clear RRN4;
              clear SCRRN4;
              clear SavRrn4;

              *in45 = *Off;
              clear s4opt;

             endsr;

        //----------------------------------------
        // $Loadsfl4 - page down & subfile records
        //----------------------------------------
             begsr $loadsfl4;

              if SavRrn4 > *Zeros;
               rrn4 = savrrn4;
               scrrn4 = savrrn4;
              endif;

              exec SQL
              declare c4 scroll cursor for
               select distinct(a.apbrsite), ARNM07
               from APCAPHSTP a
               join ARPMBCH  b
               on
               a.apbrsite = b.ARNO16
               order by apbrsite
              for read only;

              exec SQL open c4;

              exec sql
               fetch first from C4 for :maxItemLines rows into :C4;
              exec sql get diagnostics :rowCount4 = ROW_COUNT;
              dow rowCount4 <> 0;
               For i4 = 1 to rowCount4;
                s4branch = c4(i4).branch;
                s4bname = c4(i4).name;
                rrn4+=1;
                scrrn4 = rrn4;
                write(e) sub04;

               endfor;
               exec SQL
                fetch next from C4 for :maxItemLines rows into :C4;
               exec sql get diagnostics :rowCount4 = ROW_COUNT;
              enddo;
              exec SQL close C4;

              savrrn4 = scrrn4;
              *in45 = *on;
              //
              //  If no records in subfile then do not disply the subfile.
              //
              if SavRrn4  = *zeros;
               *in43 = *off;
              else;
               RRN4 = 1;
               SCRRN4 = 1;
              endif;

             endsr;

        //----------------------------------------
        // $process4 - process branch lookup
        //----------------------------------------
             begsr $process4;

              for count4 = 1 to SAVRRN4;
               chain count4 SUB04;
               if %found();
                select;
                 when s4opt = '1';
                  c1branch = s4branch;
                  exsr $clearsfl;
                  exsr $loadsfl;
                  endScreen4 = *on;
                endsl;

                s4opt = *blanks;
                update(e) SUB04;
               endif;
              endfor;

             endsr;



        //----------------------------------------
        // $screen5 - show detail information
        //----------------------------------------
             begsr $screen5;

              reset endScreen5;

              workTitle = 'Capturis Invoice Detail Inquiry';
              clear w2Title;
              LenStr =
              ((%len(workTitle) - %len(%trim(workTitle))) / 2) + 1;
              %subst(w2TITLE:LenStr) = %trim(workTitle);

              // grab all the fields

              W2VENDOR = S1APVENDOR;
              W2VNAME = S1VNAME;
              W2VENDACT = H1SRVACCT;
              W2INVOICE = H1SRVINV;
              W2SRVFROM = S1SRVCFROM;
              W2SRVTO = S1SRVCTO;
              W2SNAME = H1SERVD;
              W2SERVICE = H1SDATES;
              W2BRANCH = S1BRANCH;
              W2SITE = H1SITE;
              W2SERVICE$ = S1AMOUNT;
              W2GLACCT = h1GLACCT;
              W2INVDATE = S1INVDATE;
              IsoDate = %date(H1ADDDATE:*iso);
              W2DATERCV = %dec(IsoDate:*mdy);
              W2CAPINV# = %trim(S1INVOICE);

              // grab the current and YTD values for GL table
              // 001-022-03-5040-001

              workCompany = %dec(%xlate(' ':'0':%subst(W2GLACCT:1:3)):3:0);
              workBranch = %dec(%xlate(' ':'0':%subst(W2GLACCT:5:3)):3:0);
              workDepartment = %dec(%xlate(' ':'0':%subst(W2GLACCT:9:2)):2:0);
              workMain = %dec(%xlate(' ':'0':%subst(W2GLACCT:12:4)):4:0);
              workSub = %dec(%xlate(' ':'0':%subst(W2GLACCT:17:3)):3:0);


              reset currentMonth;
              reset ytdAmount;
              exec sql
               select GLAM01 as "CURRENT",
                       GLBL01 as YTD, GLDN03
                   into :currentMonth, :ytdAmount, :w2gname
                from GLPMSTR a
                where GLNO01 = : workCompany and
                      GLNO06 = : workBranch and
                      GLNO02 = : workDepartment and
                      GLNO03 = : workMain and
                      GLNO04 = : workSub;

              w2Total1 = currentMonth;
              w2Total2 = ytdAmount;
              w2Total3 = w2Total2/%dec(%subdt(%date():*months):2:0);

              reset w2Total4;
              exec sql
              select  dec(round(avg(GLAM01),10),9,2)
                into :w2Total4
                from GLPHSTR
                where GLNO01 = : workCompany and
                      GLNO06 = : workBranch and
                      GLNO02 = : workDepartment and
                      GLNO03 = : workMain and
                      GLNO04 = : workSub and
                 dec(digits(GLCC02) || digits(GLYR02),4,0) = year(current_date);

              reset w2Total5;
              exec sql
               select sum(GLAM01)
                into : w2Total5
                  from(
                  select GLNO06,GLNO02,GLNO03, GLNO04,GLAM01
                  from GLPPSTR a
                where GLNO01 = : workCompany and
                      GLNO06 = : workBranch and
                      GLNO02 = : workDepartment and
                      GLNO03 = : workMain and
                      GLNO04 = : workSub
                  union all
                  select GLNO06,GLNO02,GLNO03, GLNO04,GLAM01
                  from GLPHSTR b
                where GLNO01 = : workCompany and
                      GLNO06 = : workBranch and
                      GLNO02 = : workDepartment and
                      GLNO03 = : workMain and
                      GLNO04 = : workSub );

              exsr $screenError5;

              reset endscreen5;
              dow not(endScreen5);
               write WINDOWFMT2;
               write MSGCTL5;
               c4format = 'SUB04CTL';
               exfmt SCREEN1;
               reset screenError5;


               select;
                //
                // F3/F12 pressed leave program
                //
                when  infds.Choice = LeaveProgram or
                         infds.Choice = previous;
                 endscreen5 = *on;
                 //
                 // prompt
                 //
                when  infds.Choice = prompt;

                 //
                 // Enter Key pressed
                 //
                 when  infds.Choice = enterKey;

               endsl;
              enddo;



             endsr;

        //----------------------------------------
        // $screenError5 - process screen 5 errors
        //----------------------------------------
             begsr $screenError5;

              reset screenError5;
              *in60 = *off;
              *in61 = *off;
              *in62 = *off;


              // GL Account

              reset validGLAccount;

              exec sql
               select '1'
                into :validGLAccount
                from GLPMSTR
                where GLNO01 = :workCompany and
                      GLNO06 = :workBranch and
                      GLNO02 = :workDepartment and
                      GLNO03 = :workMain and
                      GLNO04 = :workSub
                fetch first row only;

              if not(validGLAccount) or %len(%trim(W2GLACCT)) <> 19 or
               %scan('-':W2GLACCT) = *zeros;
               *in62 = *on;
               screenerror5 = *on;
               messageid   = 'GEN0058';
               messagedata = *blanks;
               messagelen = %len(%trim(messagedata));
               exsr $sendmessage;
              endif;

              // validate vendor number
              reset validAPVendor;
              exec sql
               select '1'
                into :validAPVendor
                  from appmven
                  where apno01 = dec(trim(:s1Apvendor),6,0);

              if not(validAPVendor);
               *in60 = *on;
               screenerror5 = *on;
               messageid   = 'GEN0059';
               messagedata = *blanks;
               messagelen = %len(%trim(messagedata));
               exsr $sendmessage;
              endif;


              // validate branch
              reset validBranch;
              exec sql
               select '1'
                into :validBranch
                  from arpmbch
                  where arno16 = :workBranch;

              if not(validBranch);
               *in61 = *on;
               screenerror5 = *on;
               messageid   = 'GEN0060';
               messagedata = *blanks;
               messagelen = %len(%trim(messagedata));
               exsr $sendmessage;
              endif;


             endsr;

         //--------------------------------------------------------
         // $prompt - parameter screen
         //--------------------------------------------------------

             begsr $prompt;

              select;
               // vendor
               when #fld = 'C1VENDOR';
                exsr $screen2;
               // vendor Name
               when #fld = 'C1VNAME';
                exsr $screen2;
               // Capturis Invoice
               when #fld = 'C1INVOICE';
                exsr $screen3;
               // branch
               when #fld = 'C1BRANCH';
                exsr $screen4;
              endsl;

             endsr;

      *----------------------------------------------------------------
      *   getSqlDiagnostics - pull in the return data from SQL process
      *----------------------------------------------------------------
     p getSqlDiagnostics...
     p                 b                   Export
     d getSqlDiagnostics...
     d                 pi           256

          dcl-s reply char(10) inz;

               exec sql GET DIAGNOSTICS CONDITION 1
                        :ReturnedSqlCode = DB2_RETURNED_SQLCODE,
                        :ReturnedSQLState = RETURNED_SQLSTATE,
                        :MessageLength = MESSAGE_LENGTH,
                        :MessageText = MESSAGE_TEXT,
                        :MessageId1= DB2_MESSAGE_ID,
                        :MessageId2 = DB2_MESSAGE_ID1,
                        :MessageId3 = DB2_MESSAGE_ID2 ;

             Return  sqlDS;

     p getSqlDiagnostics...
     p                 e
         //--------------------------------------------------------
