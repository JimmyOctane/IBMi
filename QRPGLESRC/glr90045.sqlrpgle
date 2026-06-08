     H dftactgrp(*no) OPTION(*NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - GLR90045                                               *
     F*------------------------------------------------------------------------*
     F*P                                                                       *
     F*------------------------------------------------------------------------*
     F*D    Cash Allocation JV                                                 *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3030 080723 JJF Created program                                 *
     F*M JJF   3067 030524 JJF Rewritten to add parm for return process flag   *
     F*M                       and company by branch                           *
¢A   F*M CLP   3079 060424 CLP Corrected the company nbr used in the SQL       *
¢A   F*M                       pulling in 098 data                             *
¢B   F*M KSB   8195 121224 KSB Send email to person running report             *
¢C   F*M JJF        060326 JJF Add timestamp to attachment filename            *
     F*M ----------------------------------------------------------------------*

      *=======================================================================
      //  Work fields
     d length          s             10i 0 inz
     F********************************************************************
     FGLD90045  cf   e             WORKSTN INFDS(INFDS)   usropn
     FGLP90045  o    e             printer oflind(*in66)  usropn
      *
      * Program Info
      *
     d                SDS
     d  @PGM                 001    010
     d  @PARMS               037    039  0
     d  @MSGDTA               91    170
     d  @MSGID               171    174
     d  @JOB                 244    253
     d  @USER                254    263
     d  @JOB#                264    269  0
      *
      *  Field Definitions.
      *
     d alphaAccount    s              4    inz
     d alphaBoth       s              5    inz
     d alphaBranch     s              3    inz
     d alphaSub        s              1    inz
     d attachment      s             60    inz
     d commandString   s           5000    inz
     d commandLength   s             15  5 inz
     d company         s              3
     d count           s             10i 0 inz
     d defaultCompany  s              3  0 inz(1)
     d defaultMonth    s              2  0 inz
     d defaultYear     s              2  0 inz
     d emailAddress    s             45    inz
     d endScreen1      s               n   inz
     d foundCompany2   s               n   inz(*off)
     d glmasterMonth   s              2  0 inz
     d glmasterYear    s              2  0 inz
     d fullYear        s              4  0 inz
     d i               s             10i 0 inz
     d i2              s             10i 0 inz
     d isoDate         s               d   inz
     d lenstr          s             10i 0 inz
     d maxItemLines    s              5P 0 inz(9999)
     d message         s             45    inz
     d messagecsc      s             10i 0
     d messagedata     s             80A
     d messagekey      s              4A
     d messagelen      s             10i 0
     d messagefile     s             20    inz('ECMMSGF   *LIBL   ')
     d messageid       s              7
     d myAccount       s              4    inz
     d myIndex         s             10i 0 inz
     d myReturnIndex   s             10i 0 inz
     d myTableName     s            100    inz
     d ObjectIFSPath   s            100    inz
     d outCashJV#      s              7    inz
     d printedHeader   s               n   inz(*Off)
     d printedRecords  s             10i 0 inz
     d prodTest        s             10    inz
     d Q               s              1    inz('''')
     d rowcount        s             10i 0 inz
     d rowcount2       s             10i 0 inz
     d recordChanged   s               n   inz(*on)
     d runningInteractive...
     d                 s               n   inz(*off)
     d screenError     s               n   inz
     d screenError2    s               n   inz
     d SQLBankName     s             10    inz
     d SQLBankNumber   s             19    inz
     d SQLBname        s             35    inz
     d SQLBranch       s              3  0 inz
     d SQLCompany      s              3  0 inz
     d SQLStatus1      s              1    inz
     d subject         s             45    inz
     d subsystemName   s             10    inz
     d toEmailAddress...
     d                 s             45    inz
     d totalAmount     s             15  2 inz
     d totalMonthNet   s             12  2 inz
     d validCompany    s               n   inz(*off)
     d workCashJV#     s              7  0 inz
     d worktitle       s             40    inz
      *
     d                 ds                        inz
     d STKCNT                        10i 0
     d DTALEN                        10i 0
     d ERRCOD                        10i 0
      *
       // -----------------------------------------------------------------
       // Entry parameter list prototype and declaration
       // -----------------------------------------------------------------
       // -------------- *Plist --------------- Prototypes
     d Main            pr                  extpgm('GLR90045')
     d                                1
     d                               15  5      options( *nopass:*omit )
     d                               15  5      options( *nopass:*omit )
     d                               15  5      options( *nopass:*omit )
       // ----------------------- Main procedure interface
     d Main            pi
     d outStatus                      1
     d inCompany                     15  5      options( *nopass:*omit )
     d inMonth                       15  5      options( *nopass:*omit )
     d inYear                        15  5      options( *nopass:*omit )

       // --------------------- Prototypes --------------------
     d $clearmsg       pr                  extpgm('QMHRMVPM')
     d   messageq_                  276a   const
     d   CallStack_                  10i 0 const
     d   Messagekey_                  4a   const
     d   messagermv_                 10a   const
     d   ErrorCode_                        like(apierror)

     d $command        pr                  extpgm('QCMDEXC')
     d   command                   5000
     d   Length                      15  5

     d $sendmsg        pr                  ExtPgm('QMHSNDPM')
     d   MessageID_                   7a   Const
     d   QualMsgF_                   20a   Const
     d   MsgData_                   256a   Const
     d   MsgDtaLen_                  10I 0 Const
     d   MsgType_                    10a   Const
     d   CallStkEnt_                 10a   Const
     d   CallStkCnt_                 10I 0 Const
     d   Messagekey_                  4a
     d   ErrorCode_                        like(apierror)

     d getEmailAddress...
     d                 pr                  extpgm('ECC9997')
     d userName_                     10
     d emailAddress_                 45

     d getSqlDiagnostics...
     d                 pr           256

      // Command Keys
     d Cmd01           c                   const(x'31')                         Cmd-1
     d Cmd02           c                   const(x'32')                         Cmd-2
     d LeaveProgram    c                   const(x'33')                         Cmd-3
     d Prompt          c                   const(x'34')                         Cmd-4
     d Refresh         c                   const(x'35')                         Cmd-5
     d Cmd06           c                   const(x'36')                         Cmd-6
     d Cmd07           c                   const(x'37')                         Cmd-7
     d Cmd08           c                   const(x'38')                         Cmd-8
     d Cmd09           c                   const(x'39')                         Cmd-9
     d submitJob       c                   const(x'3A')                         Cmd-10
     d deleteRecord    c                   const(x'3B')                         Cmd-11
     d Previous        c                   const(x'3C')                         Cmd-12
     d Cmd13           c                   const(x'B1')                         Cmd-13
     d Cmd14           c                   const(x'B2')                         Cmd-14
     d Cmd15           c                   const(x'B3')                         Cmd-15
     d Cmd16           c                   const(x'B4')                         Cmd-16
     d Cmd17           c                   const(x'B5')                         Cmd-17
     d Cmd18           c                   const(x'B6')                         Cmd-18
     d Cmd19           c                   const(x'B7')                         Cmd-19
     d Cmd20           c                   const(x'B8')                         Cmd-20
     d Cmd21           c                   const(x'B9')                         Cmd-21
     d Cmd22           c                   const(x'BA')                         Cmd-22
     d Cmd23           c                   const(x'BB')                         Cmd-23
     d Cmd24           c                   const(x'BC')                         Cmd-24
     d EnterKey        c                   const(x'F1')
     d PageDown        c                   const(x'F5')                         Roll Up
     d PageUp          c                   const(x'F4')                         Roll Down

     d Infds           ds                                                       INFDS data structure
     d Choice                369    369
     d cLocation             370    371B 0
     d Currec                378    379I 0
      *
     d ApiError        ds
     d  AeBytPro                     10i 0 Inz( %Size( ApiError ))
     d  AeBytAvl                     10i 0 Inz
     d  AeMsgId                       7a
     d                                1a
     d  AeMsgDta                    128a

     d sqlDS           ds
     d ReturnedSqlCode...
     d                                5
     d ReturnedSQLState...
     d                                5
     d MessageLength                  5i 0
     d MessageText                32740
     d MessageId1                    10
     d MessageId2                     7    varying
     d MessageId3                     7    varying
      *
     d c1              ds                  Dim(9999) Qualified inz
     d  branch                        3  0
     d  department                    2  0
     d  mainAccount                   4  0
     d  subAccount                    1  0
     d  currentMonthNet...
     d                               15  2
     d  YTDAccountBalance...
     d                               15  2
      *
     d c2              ds                  Dim(9999) Qualified inz
     d code                           2
     d reference                      7  0
     d account                       19
     d description                   25
     d amount                        13  2
     d period                         5

     d  GLPWTRNDS    e ds                           extname(GLPWTRN)
     d                                              qualified  inz

     d CashJVDS        DS                  DTAARA('CSHJV')
     d cashJV#                        7s 0

      // banks array
     d corp098DS       ds                  qualified inz
     d  allOfMe                      19    dim(50)
     d  account                       4    overlay(allOfMe:1)
     d  totalDollars                 15  2 overlay(allOfMe:5)

      *
      * title and headings set-up
      *
              exec sql  set option commit=*none,datfmt=*iso,
                            closqlcsr=*ENDMOD;

              *inlr = *on;

              PGMQ = @PGM;
              reset prodTest;
              exec sql
              select data_area_value
               into :prodTest
               from qsys2.data_area_info
                WHERE data_area_name = 'PRODTEST' and
                data_area_library = 'QGPL';

              reset emailAddress;
              getEmailAddress(@user:emailAddress);

              // batch or interactive
              reset subsystemName;
              exec sql
              select V_SBS_NAME
              into :subsystemName
              from table(QSYS2.GET_JOB_INFO('*'));

              reset runningInteractive;
              if subsystemName = 'QINTER';
               runningInteractive = *on;

               if not %open(GLD90045);
                open GLD90045;
               endif;
               exsr $screen1;
               if %open(GLD90045);
                close GLD90045;
               endif;

              else;
               if %parms >= 4;

                SQLCompany = inCompany;

                // grab the CashJV#
                 in *lock CashJVDS;
                 cashJV#+=1;
                 out CashJVDS;

                // clear out the array for our 098 corporate totals
                reset myIndex;
                reset myReturnIndex;
                clear corp098DS;
                exsr $writeGLPWTRN;
                exsr $printReport;


               endif;
              endif;

        //----------------------------------------
        // $screen1 - company selection/prompt
        //----------------------------------------
             begsr $screen1;

              workTitle = 'Cash Allocation JV';
              LenStr =
              ((%len(workTitle) - %len(%trim(workTitle))) / 2) + 1;
              %subst(W1TITLE:LenStr) = %trim(workTitle);

              // select the current month processing by grabbing the month and year

              s1company = defaultCompany;

              reset endscreen1;
              dow not(endScreen1);
               write windowfmt1;
               write MSGCTL;
               exfmt screen1;
               $clearmsg('*' : *zero : *Blanks : '*ALL' : APIError);

              // from the table GLPMSTR
              reset glmasterMonth;
              reset glmasterYear;
              exec sql
               select dec(substr(TBNO03,7,2),2,0) as GLMonth,
                dec(substr(TBNO03,11,2),2,0) as GLYear
                into :glmasterMonth, :glmasterYear
                from TBPMTBL
                where tbno01  ='GL03' and TBNO02 = digits(:s1Company)
                with NC;

               select;
                 //
                 // F3/F12 pressed leave program
                 //
                when  Choice = LeaveProgram or
                         Choice = previous;
                  endscreen1 = *on;
                  if %parms >= 1;
                   outStatus = 'E';
                  endif;
                 //
                 // delete the record from tablefile "BRBK"
                 //
                when  Choice = deleteRecord;
                 exsr $validate;
                 if not(screenError);
                 endif;
                 //
                 // F4 Pressed Prompt
                 //
                when  Choice = prompt;
                 exsr $prompt;

                 //
                 // F10 pressed - submit job
                 //
                when  Choice = submitJob;
                exsr $validate;
                if not(screenError);
                 exsr $submitToBatch;
                  if %parms >= 1;
                   outStatus = 'S';
                  endif;
                 endscreen1 = *on;
                endif;
                 //
                 // Enter Key pressed
                 //
                when  Choice = enterKey;
                exsr $validate;
               endsl;
              enddo;

             endsr;

        //----------------------------------------
        // $validate - validate the dates entered
        //----------------------------------------
             begsr $validate;

              *in25 = *off;
              reset screenError;

              // validate the company
              reset validCompany;
              exec sql
               select '1' into :validCompany
               from GLPMHDR
               where GLNO01 = :s1company and GLFL03 = ' ';
              if not(validCompany);
               *in25 = *on;
               screenerror = *on;
               messageid   = 'GEN0048';
               messagedata = *blanks;
               messagelen = %len(%trim(messagedata));
               exsr $sendmessage;
              endif;

             endsr;

         //--------------------------------------------------------
         // $prompt - parameter screen
         //--------------------------------------------------------
              begsr $prompt;


              endsr;

        //----------------------------------------
        // $writeGLPWTRN - do the work write cash
        //                 records
        //----------------------------------------
             begsr $writeGLPWTRN;

              exec SQL
               declare C1 scroll cursor for
                select a.GLNO06,a.GLNO02,a.GLNO03,a.GLNO04,
                 sum(a.GLAM01),sum(a.GLBL01),
                 digits(a.GLNO03),  digits(a.GLNO04)
                 from GLPMSTR  a
                 WHERE A.glno03 = 1021 and GLNO06 not in (098) and
                       a.GLNO01 = :SQLCompany
                 group by GLNO06, GLNO02, GLNO03, GLNO04
                 order by glno06
               for read only with NC;

              exec SQL open C1;
              exec sql fetch first from C1 for :maxItemLines rows into :C1;
              exec sql get diagnostics :rowCount = ROW_COUNT;

              reset totalMonthNet;
              dow rowCount <> 0;
               For i = 1 to rowCount;
                exsr $writeARecord;
               endfor;
               exec SQL
               fetch next from C1 for :maxItemLines rows into :C1;
               exec sql get diagnostics :rowCount = ROW_COUNT;
              enddo;
              exec SQL close C1;

              // finish up with 098 records for each
              // bankaccount - need to add in bank acount to
              // data and sum to write corporate 098 record
              exsr $writeBranch98;

             endsr;

        //----------------------------------------
        // $writeARecord - write 1 record to trans
        //                 table.
        //----------------------------------------
             begsr $writeARecord;

                reset GLPWTRNDS;
                if c1(i).currentMonthNet <> *zeros;

                 totalMonthNet += c1(i).currentMonthNet;
                 GLPWTRNDS.GLAM03  = (c1(i).currentMonthNet*-1);
                 GLPWTRNDS.GLCD13  = 'CT';
                 GLPWTRNDS.GLDN04  = 'CASH ALLOC';
                 GLPWTRNDS.GLNM02  = @USER;

                 SQLBranch = c1(i).branch;
                 GLPWTRNDS.GLNO01  = SQLCompany;
                 GLPWTRNDS.GLNO02  = c1(i).department;
                 GLPWTRNDS.GLNO03  = c1(i).mainAccount;
                 GLPWTRNDS.GLNO04  = c1(i).subAccount;
                 GLPWTRNDS.GLNO06  = c1(i).branch;
                 GLPWTRNDS.GLNO07  = %dec(inMonth:2:0);
                 GLPWTRNDS.GLNO08  = %dec(inYear:2:0);
                 GLPWTRNDS.GLNO27  = 20;
                 GLPWTRNDS.GLNO05  = cashJV#;
                 exec sql
                  insert into GLPWTRN
                   values(:GLPWTRNDS);

                 // find the bank for this record
                 alphaBranch=%editc(c1(i).branch:'X');
                 alphaSub =%editc(c1(i).subAccount:'X');
                 alphaBoth = alphaAccount + alphaSub;

                 clear myAccount;
                 exec sql
                 select account
                 into :myAccount
                 from
                 (select b.tbno01,
                   b.tbno02 as branch,
                   substr(a.tbno03,12,4) as account,
                   substr(b.tbno03,30,1) as subacct
                  from TBPMTBL a
                  inner join TBPMTBL b
                   on a.tbno03 = substr(b.tbno03,1,19)
                  join arpmbch c on b.tbno02 = digits(c.ARNO16)
                    where a.tbno01 = 'BANK'  and
                          a.tbno02 not in(' ', '*')
                  order by b.tbno02 )
                  where branch = :alphaBranch and subacct = :alphaSub;

                 myReturnIndex = %lookup(myAccount:Corp098DS.account);
                 if myReturnIndex > *zeros;
                  corp098DS.totalDollars(myReturnIndex) +=
                   c1(i).currentMonthNet;
                 else;
                  myIndex+=1;
                   corp098DS.totalDollars(myIndex) =
                   c1(i).currentMonthNet;
                   corp098DS.account(myIndex) = myAccount;
                 endif;

                endif;

             endsr;
        //----------------------------------------
        // $writeBranch98 - write all the 098 records
        //----------------------------------------
             begsr $writeBranch98;

               reset count;
              // read thru all previous written records and
              // create 1 098 record per  branch & subaccount
               for count = 1 to myIndex;

                reset GLPWTRNDS;
                if corp098DS.totalDollars(count) <> *zeros;
                 reset GLPWTRNDS;
                 GLPWTRNDS.GLAM03  = corp098DS.totalDollars(count);
                 GLPWTRNDS.GLCD13  = 'CT';
                 GLPWTRNDS.GLDN04  = 'CASH ALLOC';
                 GLPWTRNDS.GLNM02  = @USER;
   ¢A            //GLPWTRNDS.GLNO01  = SQLBranch;
¢A               GLPWTRNDS.GLNO01  = SQLCompany;
                 GLPWTRNDS.GLNO02  = 0;
                 GLPWTRNDS.GLNO03  = %dec(corp098DS.account(count):4:0);
                 GLPWTRNDS.GLNO04  = 000;
                 GLPWTRNDS.GLNO06  = 98;
                 GLPWTRNDS.GLNO07  = %dec(inMonth:2:0);
                 GLPWTRNDS.GLNO08  = %dec(inYear:2:0);
                 GLPWTRNDS.GLNO27  = 20;
                 GLPWTRNDS.GLNO05  = cashJV#;
                 exec sql
                  insert into GLPWTRN
                   values(:GLPWTRNDS);
                endif;
               endfor;

             endsr;

        //----------------------------------------
        // $printReport - Print the final report
        //----------------------------------------
             begsr $printReport;

              reset printedRecords;
              p1company = SQLCompany;
              p1month = %dec(inMonth:2:0);
              p1year = %dec(inYear:2:0);

¢B            //toEmailAddress = 'jstano@ecmdi.com';
¢B            toEmailAddress = emailAddress;
              subject = 'Cash Allocations Report';
¢C            attachment = 'CashAllocations_'
¢C                       + %char(%timestamp() : *ISO0)
¢C                       + '.pdf';
              message = 'Attached is the cash allocations report.';
              p1ref = cashJV#;

              if prodtest = 'TEST';
               toEmailAddress = emailAddress;
               subject = 'TEST_' + %trim(subject);
               attachment = 'TEST_' + %trim(attachment);
              endif;

              commandString = 'DEL ' + Q + '/tmp/' + %trim(attachment) +Q ;
              commandLength = %len(%trim(commandString));
              monitor;
               $command(commandString: commandLength);
              on-error;
              endmon;

              //
              // OVRPRTF   FILE(QSYSPRT) DEVTYPE(*AFPDS)
              //           TOSTMF('/home/user/mypdf.pdf') WSCST(*PDF)
              //
              commandString = 'OVRPRTF FILE(GLP90045) DEVTYPE(*AFPDS) ' +
                 'TOSTMF(' +Q+ '/tmp/' + %trim(attachment) +Q+') WSCST(*PDF)';
              commandLength = %len(%trim(commandString));
              monitor;
               $command(commandString: commandLength);
              on-error;
              endmon;

              if not %open(GLP90045);
               open GLP90045;
              endif;

              //
              // handle the query report here
              //
              exec SQL
               declare C2 scroll cursor for
               select a.GLCD13, a.glno05,
                digits(a.glno01) || '-' || digits(a.glno06)
                || '-' || digits(a.glno02)  || '-' ||
                digits(a.glno03) || '-' ||
               digits(a.glno04) as "ACCT" , b.GLDN03,
               a.GLAM03,
               digits(a.glno07) || '/' ||
               digits(a.glno08) as "YRPD"
                 from GLPWTRN  a
                join glpmstr b
                on a.GLNO01 = b.GLNO01 and
                   a.GLNO06 = b.GLNO06 and
                   a.GLNO02 = b.GLNO02 and
                   a.GLNO03 = b.GLNO03 and
                   a.GLNO04 = b.GLNO04
                where a.GLNO01 = :SQLCompany and a.GLCD13 = 'CT' and
                      a.GLNO05 = :cashJV#
                order by a.GLCD13,a.GLNO05, ACCT
               for read only with NC;

              exec SQL open C2;
              exec sql fetch first from C2 for :maxItemLines rows into :C2;
              exec sql get diagnostics :rowCount2 = ROW_COUNT;

              reset totalAmount;
              dow rowCount2 <> 0;
               For i2 = 1 to rowCount2;
                if not(printedHeader) or *in66;
                 write Header;
                 *in66 = *off;
                 printedHeader = *on;
                endif;

                P1CODE = c2(i2).code;
                P1REF = c2(i2).reference;
                P1ACCOUNT = c2(i2).account;
                P1DESC = c2(i2).description;
                P1AMOUNT = c2(i2).amount;
                P1PERIOD = c2(i2).period;

                totalAmount+= P1AMOUNT;

                printedRecords+=1;
                write detail;

               endfor;
               exec SQL
               fetch next from C2 for :maxItemLines rows into :C2;
               exec sql get diagnostics :rowCount2 = ROW_COUNT;
              enddo;
              exec SQL close C2;

              if printedRecords = *zeros;
               write header;
               write noRecords;
               write total;
               write endrpt;
              else;
               p1total = totalAmount;
               write total;
               write endrpt;
              endif;


              if %open(GLP90045);
               close GLP90045;
              endif;

              //  send email

              // addlible MAILTOOL
              commandString =
              'ADDLIBLE MAILTOOL';
              commandLength = %len(%trim(commandString));
              monitor;
               $command(commandString: commandLength);
              on-error;
              endmon;


              ObjectIFSPath = '/tmp/' + %trim(attachment);


              commandString =
               'MAILTOOL TOADDR(' + %trim(toEmailAddress) + ') ' +
               'FROMADDR(isdept@ecmdi.com) ATTACH(' +Q+
               %trim(ObjectIFSPath) +Q+
               ') SUBJECT(' + Q + %trim(Subject) + Q +
               ') MESSAGE(' + Q + %trim(message) + Q + ') ' +
               'ATTNAM(' + Q + %trim(attachment) + Q + ')';
               commandLength = %len(%trim(commandString));
               monitor;
                $command(commandString: commandLength);
               on-error;
               endmon;

             endsr;

        //----------------------------------------
        // $sendmessage - send the program message
        //----------------------------------------
             begsr $sendmessage;

              Messagefile = 'ECMMSGF   HD1100PD';
              $sendmsg(messageID   :
                       messageFile :
                       messagedata :
                       messageLen  :
                       '*DIAG'     :
                       @PGM        :
                       messagecsc  :
                       messagekey  :
                       APIError
                                   );
             endsr;

        //----------------------------------------
        // $submitToBatch - submit job to batch
        //----------------------------------------
             begsr $submitToBatch;

              // SBMJOB CMD(CALL PGM(GLR90045)
              // PARM((08) (23)))
              // JOB(CASH_ALLOC)
              //
              commandString =
              'SBMJOB CMD(CALL PGM(GLR90045) ' +
              'PARM((' +Q+ ' ' +Q+ ') (' + %editc(S1Company:'X') + ') ' +
              '('+ %editc(glmasterMonth:'X') + ') (' +
               %editc(glmasterYear:'X')+'))) JOB(CASH_ALLOC) ' +
              'LOG(4 *JOBD *SECLVL) LOGCLPGM(*YES)';
              commandLength = %len(%trim(commandString));
              monitor;
               $command(commandString: commandLength);
              on-error;
              endmon;

             endsr;

      *----------------------------------------------------------------
      *   getSqlDiagnostics - pull in the return data from SQL process
      *----------------------------------------------------------------
     p getSqlDiagnostics...
     p                 b                   Export
     d getSqlDiagnostics...
     d                 pi           256

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
