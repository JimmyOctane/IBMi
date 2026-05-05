     H NOMAIN EXPROPTS(*RESDECPOS)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - rtvabrc                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D retreive authorized branches                                          *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    retreive authorized branches                                       *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3173 112125 JJF created program                                 *
     F*M ----------------------------------------------------------------------*

           dcl-f RTVABRCD WORKSTN INFDS(INFDS) SFILE(SUB01:RRN1) usropn;

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

           dcl-s RRN1 like(SCRRN) inz;
           dcl-s savRRN like(scrrn ) inz;

           dcl-proc retrieveAuthorizedBranches export;
            dcl-pi *n char(9000);
             inUseScreen char(1) const;
             inUserid char(10) options( *nopass:*omit );
            end-pi;

         /COPY qcpysrc,RTVABRC_CP

            //***********************************************************/
            // Main Procedure                                           */
            //***********************************************************/
            dcl-s count int(10:0) inz;
            dcl-s branchName char(25) inz;
            dcl-s endScreen1 ind inz(*off);
            dcl-s i int(10:0) inz;
            dcl-s lenstr int(10:0) inz;
            dcl-s maxItemLines zoned(5:0) inz(10000);
            dcl-s messagecsc int(10:0) inz;
            dcl-s messageData char(80) inz;
            dcl-s messagekey char(4) inz;
            dcl-s messageLen int(10:0) inz;
            dcl-s messageFile char(20) inz('ECMMSGF   *LIBL   ');
            dcl-s messageid char(7) inz;
            dcl-s myIndex int(10:0) inz;
            dcl-s myTidsCompany zoned(3:0) inz;
            dcl-s myTidsBranch  zoned(3:0) inz;
            dcl-s myUserID char(10) inz;
            dcl-s returnedRows int(10) inz;
            dcl-s rowCount int(10:0) inz;
            dcl-s screenError ind inz;
            dcl-s updcmdlen int(10) inz;
            dcl-s workTitle char(30) inz;

            dcl-ds c1 dim(10000) qualified inz;
             company packed(3:0);
             branch packed(3:0);
            end-ds c1;

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

            exec sql  set option commit=*none,datfmt=*iso,
                          closqlcsr=*ENDMOD;

            if %open(RTVABRCD);
             close RTVABRCD;
            endif;

            if %parms >= 2;
             myUserId = inUserid;
            else;
             myUserId = psds.jobUser;
            endif;

           // grab the data and place into array
            exec SQL
            declare c1 scroll cursor for
             select distinct
               b.ARNO15 as COMPANY,b.ARNO16 as BRANCH
             from ARPMBCH b
             where b.ARFL16=' ' and b.ARFL23='Y' and(
              (exists(select 1 from OPPMSEC x
               where x.OPNO01=(values((select substr(t.TBNO03,1,7)
                from TBPMTBL t
                where t.TBNO01='UIDS'
                  and t.TBNO02=trim(substr(:myUserId,1,9))
                fetch first 1 row only)))
               group by x.OPNO01
            having count(*)=1 and max(x.OPNO02)='0' and max(x.OPNO03)='0')
              and exists(select 1 from GLPMHDR g
               where g.GLNO01=b.ARNO15 and g.GLFL03=' '))
             or exists(select 1 from OPPMSEC x
              where x.OPNO01=(values((select substr(t.TBNO03,1,7)
               from TBPMTBL t
               where t.TBNO01='UIDS'
                 and t.TBNO02=trim(substr(:myUserId,1,9))
              fetch first 1 row only)))
              and((x.OPNO03='0' and b.ARNO15=x.OPNO02)
           or(x.OPNO03<>'0' and b.ARNO15=x.OPNO02 and b.ARNO16=x.OPNO03))))
           order by COMPANY,BRANCH
            for read only;

            reset authorizedBranchesDS;
            reset myIndex;

            exec SQL open c1;
            //
            exec sql
             fetch first from C1 for :maxItemLines rows into :C1;
            exec sql get diagnostics :rowCount = ROW_COUNT;
            returnedRows = rowCount;
            dow rowCount <> 0;
             For i = 1 to rowCount;
              myIndex+=1;
              authorizedBranchesDS.company(myIndex) = c1(i).company;
              authorizedBranchesDS.branch(myIndex) = c1(i).branch;

             endfor;
             exec SQL
              fetch next from C1 for :maxItemLines rows into :C1;
               exec sql get diagnostics :rowCount = ROW_COUNT;
            enddo;
            exec SQL close C1;

            // check that TIDS is included in UIDS if not add IT.
            reset myTidsCompany;
            reset myTidsBranch;
            exec sql
             select
              substr(TBNO03,1,3) Branch,
              substr(TBNO03,4,3) Company
              into :myTidsBranch, :myTidsCompany
              from TBPMTBL
              where TBNO01 = 'TIDS' and TBNO02 = substr(:myUserId,1,9);

¢C          if %lookup(myTidsBranch : authorizedBranchesDS.branch) = *zeros;
             returnedRows +=1;
             authorizedBranchesDS.company(returnedRows) = myTidsCompany;
             authorizedBranchesDS.branch(returnedRows) = myTidsBranch;
            endif;

            if inUseScreen = 'Y';
             if not %open(RTVABRCD);
              PGMQ = '*';
              open RTVABRCD;
              exsr $clearsfl;
              // load from array
              exsr $loadsfl;
              exsr $screen1;
             endif;
            endif;

            return authorizedBranchesDS;

            if %open(RTVABRCD);
             close RTVABRCD;
            endif;

        //----------------------------------------
        // $screen1 - show non-matched quantities
        //----------------------------------------
             begsr $screen1;

              workTitle = 'Select/Return Branch';
              clear c1Title;
              LenStr =
              ((%len(workTitle) - %len(%trim(workTitle))) / 2) + 1;
              %subst(C1TITLE:LenStr) = %trim(workTitle);

              reset endscreen1;
              dow not(endScreen1);
               if ScreenError = *off;
                $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);
               endif;
               hdprogram = 'SUB01CTL';
               write WINDOWFMT1;
               write MSGCTL;
               exfmt SUB01CTL;
               reset ScreenError;
               $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);

               if infds.Currec <> *Zeros;
                RRN1  =  infds.Currec;
                scrrn  =  infds.Currec;
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
                 when  infds.Choice = enterKey;
                  exsr $process;

               endsl;
              enddo;

             endsr;

        //----------------------------------------
        // $process - select branch
        //----------------------------------------
             begsr $process;

              for count = 1 to SAVRRN;
               chain count SUB01;
               if %found();
                select;
                 when s1opt = '1';
                  // if interactive place selected branch into return value
                  authorizedBranchesDS.returnBranch = s1branch;

                  endscreen1 = *on;
                  s1opt = *blanks;
                  update(e) SUB01;
                  leaveSR;
                endsl;

               endif;
              endfor;

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
              clear scrrn ;
              clear SavRrn;

              *in33 = *Off;
              clear s1opt;

             endsr;

        //----------------------------------------
        // $Loadsfl - page down & subfile records
        //----------------------------------------
             begsr $loadsfl;

              if SavRrn  > *Zeros;
               rrn1  = savrrn;
               scrrn  = savrrn;
              endif;

               reset myIndex;
               For myIndex = 1 to returnedRows;

                s1Branch = authorizedBranchesDS.branch(myIndex);
                reset branchName;
                exec sql
                 select ARNM07
                  into :branchName
                  from ARPMBCH where ARNO16 = :s1Branch;
                s1Bname = branchName;

                // dont load more records than subfile can handle
                if rrn1 <= 9999;
                 rrn1+=1;
                 scrrn  = rrn1;
                 write(e) sub01;
                endif;

               endfor;

              savrrn = scrrn ;
              *in33 = *on;
              //
              //  If no records in subfile then do not disply the subfile.
              //

              if SavRrn  = *zeros;
               *in31 = *off;
              else;
               RRN1 = 1;
               scrrn  = 1;
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



         end-proc   retrieveAuthorizedBranches;
