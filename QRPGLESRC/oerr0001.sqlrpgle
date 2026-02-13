     H   dftactgrp(*no)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - OERR0001                                               *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT EAST COAST METALS                                           *
     F*------------------------------------------------------------------------*
     F*D check for coupons/promo codes in orders and display warning           *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    check for coupons/promo codes in orders and display warning        *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF  3148 080525 JJF  Created program                                 *
     F*M ----------------------------------------------------------------------*

         dcl-f OEDR0001 workstn INFDS(INFDS)  sfile(SUB01:RRN1) ;

       // -------------- *Plist --------------- Prototypes
     d Main            pr                  extpgm('OERR0001')
     d                              700

     d Main            pi
     d inOrderNumbers               700

        dcl-ds parameterDS  qualified inz;
         list char(700) pos(1);
         orders char(7) dim(100) pos(1);
        end-ds parameterDS;

      *----------------------
      * Stand alone fields...
      *----------------------
        dcl-s count int(10:0) inz;
        dcl-s endscreen1 ind inz(*off);
        dcl-s i int(10:0) inz;
        dcl-s inOrderNumber char(7) inz;
        dcl-s lenstr int(10:0) inz;
        dcl-s maxItemLines packed(5:0) inz(9999);
        dcl-s messagecsc   int(10) inz;
        dcl-s messagedata  char(80) inz;
        dcl-s messagekey   char(4) inz;
        dcl-s messagelen   int(10) inz;
        dcl-s messageFile char(20) inz('ECMMSGF   *LIBL   ');
        dcl-s messageid    char(7)  inz;
        dcl-s myOrder char(7) inz;
        dcl-s Q char(1) inz('''');
        dcl-s rowcount int(10:0) inz;
        dcl-s savRRN like(SCRRN) inz;
        dcl-s screenError ind inz;
        dcl-s sqlString varchar(2000) inz;
        dcl-s RRN1 like(SCRRN) inz;
        dcl-s workTitle char(50) inz;

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

        dcl-ds c1 dim(9999) qualified;
         myOrder char(7);
         myItem zoned(6:0);
         myProduct char(15);
         myDescription char(30);
        end-ds c1;

       // --------------------- Prototypes --------------------

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

          dcl-ds INFDS qualified;
           choice char(1) pos(369);
           cLocation char(2) pos(370);
           currec int(5:0) pos(378);
          end-ds;

          dcl-ds ApiError;
           AeBytPro int(10:0) inz(%Size(ApiError));
           AeBytAvl int(10:0) inz;
           AeMsgId char(7);
           someField char(1);
           AeMsgDta char(128);
          end-ds;
          *inlr = *on;
          exsr $clearsfl;
          exsr $loadsfl;
          if RRN1 > *zeros;
           exsr $screen1;
          endif;

        //--------------------------------------------------------
        // $Screen1 - parameter screen
        //--------------------------------------------------------
             begsr $Screen1;

             PGMQ = psds.program;
             reset  EndScreen1;
              dow  EndScreen1 = *off;
               if ScreenError = *off;
                $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);
               endif;

               write FMT1;
               write MSGCTL;
               exfmt SUB01CTL;
               reset ScreenError;

               $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);
               reset ScreenError;
               if infds.Currec <> *Zeros;
                RRN1  =  infds.Currec;
                SCRRN =  infds.Currec;
               endif;
               select;
            //
            // Enter Key pressed
            //
                when  infds.choice  = LeaveProgram or
                      infds.choice  = Previous or
                      infds.choice  = enterKey;
                 endscreen1 = *on;
                endsl;
               enddo;
             endsr;

        //----------------------------------------
        // $clearSfl - clear the subfile
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
              *in98 = *Off;

              reset sqlString;
              parameterDS.List = inOrderNumbers;

              exec sql
               declare global temporary table tempOrder (
                   order char(7) not null
               ) with replace;

              for count = 1 to %elem(parameterDS.orders);
               if parameterDS.orders(count) <> *blanks;
                myOrder = parameterDS.orders(count);
                exec sql
                 insert into qtemp.tempOrder (order)
                 values (:myOrder);
               endif;
              endfor;

              // load all the tracking numbers for the receipt
              exec SQL
               declare c1 scroll cursor for
                select c.OENO01,
                b.ivno07, b.ivno04, b.ivdn01
               from
               ivpmglp a
               join IVPMSTR b
               on a.IVNO07 = b.ivno07
               join oeptoly c  on a.ivno07 = c.ivno07
               where GLCD48 = 'COUPON'
               and  c.oeno01 in (select order from
               qtemp.temporder)
               order by c.oeno01
               for read only with NC;

              exec SQL open c1;
              exec sql
               fetch first from c1 for :MaxItemLines
               rows into :C1;
               exec sql get diagnostics :RowCount = ROW_COUNT;
              exec SQL close c1;

              workTitle = 'Display Promo Codes in Order';
              LenStr =
              ((%len(workTitle) - %len(%trim(workTitle))) / 2) + 1;
              %subst(C1TITLE:LenStr) = %trim(workTitle);

             endsr;

        //----------------------------------------
        // $Loadsfl - page down & subfile records
        //----------------------------------------
             begsr $loadsfl;

              if SavRrn  > *Zeros;
               rrn1  = savrrn;
               scrrn = savrrn;
              endif;

              for count = 1 to  rowCount;
               s1Order = c1(count).myOrder;
               s1item = c1(count).myItem;
               s1product = c1(count).myProduct;
               s1desc = c1(count).myDescription;
               RRN1  +=1;
               SCRRN  = RRN1;
               write SUB01;
              endfor;

              savrrn = scrrn;
              *in33 = *on;
              //
              //  If no records in subfile then do not disply the subfile.
              //
              if SavRrn  = *zeros;
               *in31 = *off;
              else;
               RRN1  = 1;
               SCRRN  = 1;
              endif;
             endsr;

