       //-------------------------------------------------------------------
       // PROGRAM NAME - SYSMONITOR
       //
       //  System Monitor Pgm - test
       //
       //-------------------------------------------------------------------
       // TASK       DATE   ID  DESCRIPTION
       //---------- ------ --- ---------------------------------------------
       // 3119      110124 JJF Initial pgm
       // 3133      042925 JJF Rewritten to add better process for jobqueues
       // 3133      050625 JJF Rewritten to reduce messages during backups
       // 3140      062525 JJF ReWritten to add in monitor flag for job scheduler
       //------------------------------------------------------------------------
         ctl-opt option(*srcstmt: *nodebugio) debug(*yes) dftactgrp(*no)
          bnddir('SHBIND':'WMBIND':'HDBIND':'WKBIND':'MNBIND':'YAJL');


         // Field Definitions.

        dcl-s commandString char(1000)inz;
        dcl-s commandLength packed(15:5) inz;
        dcl-s count int(10:0) inz;
        dcl-s index zoned(10:0) inz;
        dcl-s isoDate date inz;
        dcl-s lastStamp timestamp inz;
        dcl-s prodtest char(10) inz;
        dcl-s Q char(1) inz('''');
        dcl-s reply char(1) inz;
        dcl-s returned int(10) inz;
        dcl-s runProgram ind inz(*on);
        dcl-s sleepSeconds uns(10) inz(60);
        dcl-s sourceTarget char(10) inz;
        dcl-s systemName char(30) inz;
        //-------------------------------------------------------------------

        dcl-ds wvaluesPSDS psds qualified;
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

        dcl-ds ValuesDS  qualified inz;
          maxSpool zoned(4:0);
          jobQueueQuantity zoned(4:0);
          messageText char(200);
          shortMessageText char(200);
          heldMessage char(1);
          testOrProduction char(10);
          messageResendDelay zoned(3:0);
          overrideEmail char(40);
          maxMessageSeverity zoned(2:0);
          endOfDay time;
          startOfDay time;
          messageQsysopr char(30);
          runOutQueueChecks char(1);
          monitorJobScheduler char(1);
          SkipOutqueue char(10) dim(30);
          outqueue char(300) samepos(SkipOutqueue);
          helpDeskEmail char(30) dim(10);
          email char(300) samepos(helpDeskEmail);
          omitMSGWJobs char(10) dim(30);
          jobs char(300) samepos(omitMSGWJobs);
          omitWRKACTJOB char(10) dim(30);
          activejob char(300) samepos(omitWRKACTJOB);
          // skipJobQueueDS
          skipJobQueue char(10) dim(30);
          jobQueue char(300) samepos(skipJobQueue);
          // skip schedule job
          skipScheduled char(10) dim(150);
          scheduled char(1500) samepos(skipScheduled);
          // skip error messages
          skipErrorIDs char(7) dim(100);
          ErrorId char(700) samepos(skipErrorIDs);
          // skip jobNames
          skipJobNames char(10) dim(100);
          jobNames char(1000) samepos(skipJobNames);
        end-ds ValuesDS;

         // check the delay and make descision to send or not send message
         // message sending datastructure array
         dcl-ds messageTracker qualified dim(1000);
          message char(200);
          lastSent timestamp;
         end-ds messageTracker;


       // -------------- *Plist --------------- Prototypes
         dcl-pr main extpgm('SYSMONITOR');
          inparm_ char(10) options( *nopass:*omit );
         end-pr;

         dcl-pi main;
          inparm char(10) options( *nopass:*omit );
         end-pi;

         dcl-pr setProgramValues char(32740);
          inScreenData_  char(32740) value;
         end-pr;

         dcl-pr checkOutQueues char(32740);
          inScreenData_  char(32740) value;
         end-pr;

         dcl-pr checkwrkactjob char(32740);
          inScreenData_  char(32740) value;
         end-pr;

         dcl-pr checkjobqueues char(32740);
          inScreenData_  char(32740) value;
         end-pr;

         dcl-pr checkScheduledJobs char(32740);
          inScreenData_  char(32740) value;
         end-pr;

         dcl-pr checkQsysopr char(32740);
          inScreenData_  char(32740) value;
         end-pr;

         dcl-pr sendMessage char(32740);
          inScreenData_  char(32740) value;
         end-pr;

         dcl-pr sleep int(10) extproc('sleep');
          *n uns(10) value;
         end-pr ;

         dcl-pr $command extpgm('QCMDEXC');
          command_ char(1000);
          Length_  packed(15:5);
         end-pr;

         *inlr = *on;

         // pull in production or test dataarea
         reset prodTest;
         exec sql
          select data_area_value
          into :prodTest
          from qsys2.data_area_info
          WHERE data_area_name = 'PRODTEST' and
          data_area_library = 'QGPL';
         valuesDS.testOrProduction = prodTest;

         // source or target -  Production or DR?
         // ('SRC' or 'TGT')
         reset sourceTarget;
         exec sql
          select coalesce(data_area_value,' ')
           into :sourceTarget
           from qsys2.data_area_info
            where data_area_name = 'MXSYSROLE' and
                  data_area_library = 'MIMIXMSF';

         dow runProgram;

          valuesDS = setprogramValues(ValuesDS);
          select;
           when prodtest = 'TEST' or
               (prodTest = 'PROD' and sourceTarget = 'SRC');

            // only check outqueues during work hours
            if %time() >= valuesDS.startOfDay and
               %time() <= valuesDS.endOfDay and
               valuesDS.runOutQueueChecks = 'Y';
             valuesDS = checkOutQueues(ValuesDS);
            endif;

            valuesDS = checkwrkactjob(ValuesDS);
            valuesDS = checkjobqueues(ValuesDS);
            valuesDS = checkScheduledJobs(ValuesDS);
            valuesDS = checkQsysopr(ValuesDS);
           when prodTest = 'PROD' and sourceTarget = 'TGT';
            valuesDS = checkQsysopr(ValuesDS);
          endsl;

          // set last read time
          // CHGDTAARA DTAARA(SYSMONITOR *ALL)
          // VALUE('2025-03-07 16:46:08.000000')
          lastStamp = %timestamp - %minutes(5);
          commandString =
          'CHGDTAARA DTAARA(SYSMONITOR *ALL) ' +
          'VALUE(' +Q+ %trim(%char(lastStamp)) +Q+ ')';
          commandLength = %len(%trim(commandString));
          monitor;
           $command(commandString: commandLength);
          on-error;
          endmon;

          sleep(sleepSeconds);
         enddo;

      *----------------------------------------------------------------
      *   checkOutQueues  - process the out queue checks
      *----------------------------------------------------------------

         dcl-proc checkOutQueues export;

         dcl-pi *n char(32740);
          inValues char(32740) value;
         end-pi;

         dcl-s i int(10:0) inz;
         dcl-s ignorePrinter ind inz(*off);
         dcl-s maxItemLines   zoned(5:0) inz(10000);
         dcl-s Null_F1 int(5) ;
         dcl-s Null_F2 int(5) ;
         dcl-s Null_F3 int(5) ;
         dcl-s Null_F4 int(5) ;
         dcl-s Null_F5 int(5) ;
         dcl-s Null_F6 int(5) ;
         dcl-s Null_F7 int(5) ;
         dcl-s numberofSpooledFiles  zoned(10:0) inz;
         dcl-s outqueue char(10) inz;
         dcl-s outqueueLibrary  char(10) inz;
         dcl-s outqueueStatus char(8) inz;
         dcl-s rowCount int(10:0) inz;
         dcl-s writerStatus  char(4) inz;

         dcl-ds wValuesDS  qualified inz;
          maxSpool zoned(4:0);
          jobQueueQuantity zoned(4:0);
          messageText char(200);
          shortMessageText char(200);
          heldMessage char(1);
          testOrProduction char(10);
          messageResendDelay zoned(3:0);
          overrideEmail char(40);
          maxMessageSeverity zoned(2:0);
          endOfDay time;
          startOfDay time;
          messageQsysopr char(30);
          runOutQueueChecks char(1);
          monitorJobScheduler char(1);
          SkipOutqueue char(10) dim(30);
          outqueue char(300) samepos(SkipOutqueue);
          helpDeskEmail char(30) dim(10);
          email char(300) samepos(helpDeskEmail);
          omitMSGWJobs char(10) dim(30);
          jobs char(300) samepos(omitMSGWJobs);
          omitWRKACTJOB char(10) dim(30);
          activejob char(300) samepos(omitWRKACTJOB);
          // skipJobQueueDS
          skipJobQueue char(10) dim(30);
          jobQueue char(300) samepos(skipJobQueue);
          // skip schedule job
          skipScheduled char(10) dim(150);
          scheduled char(1500) samepos(skipScheduled);
          // skip error messages
          skipErrorIDs char(7) dim(100);
          ErrorId char(700) samepos(skipErrorIDs);
          // skip jobNames
          skipJobNames char(10) dim(100);
          jobNames char(1000) samepos(skipJobNames);
         end-ds wValuesDS;

        dcl-ds c1 dim(10000) qualified inz;
         outqueue char(10);
         int5_1 int(10:0);
         library char(10);
         int5_2 int(10:0);
         spooledFiles  int(10:0);
         int5_3 int(10:0);
         outqStatus char(8);
         int5_4 int(10:0);
         jobname char(10);
         int5_5 int(10:0);
         writerStatus char(10);
         int5_6 int(10:0);
         outqDescription char(50);
         int5_7 int(10:0);
        end-ds c1;

         wValuesDS = inValues;

         // grab the data and place into array
         exec SQL
          declare  WorkCursor scroll cursor for
          SELECT OUTPUT_QUEUE_NAME, :Null_F1,
                 OUTPUT_QUEUE_LIBRARY_NAME,:Null_F2,
                 NUMBER_OF_FILES, :Null_F3,
                 OUTPUT_QUEUE_STATUS,:Null_F4,
                 coalesce(WRITER_JOB_NAME,' '), :Null_F5,
                 coalesce(WRITER_JOB_STATUS,' '), :Null_F6,
                 coalesce(TEXT_DESCRIPTION,' '), :Null_F7
           FROM qsys2.OUTPUT_QUEUE_INFO a
          for read only;

          exec SQL open WorkCursor;
           exec sql
            fetch first from WorkCursor for :MaxItemLines
            rows into :C1;
            exec sql get diagnostics :RowCount = ROW_COUNT;
            exec SQL close WorkCursor;

          for i = 1 to RowCount;
           outqueue = c1(i).outqueue;
           outqueueLibrary = c1(i).library;
           outqueueStatus = c1(i).outqStatus;
           writerStatus = c1(i).writerStatus;
           numberofSpooledFiles = c1(i).spooledFiles;

           // Is this printer in the move spooled file table?
           reset ignorePrinter;
           exec sql
            select '1'
            into :ignorePrinter
            from oppprt
            where BADPRT = :outqueue;

           // for production check all outqueues for test
           // only test those in released status
           if %lookup(outqueue:ValuesDS.SkipOutqueue ) = *zeros and
              not(ignorePrinter);
            select;
             when writerStatus = 'HLD' and  wValuesDS.heldMessage = 'Y';
              valuesDS.messageText = 'Writer:' + %trim(outQueue);
              valuesDS.messageText = %trim(valuesDS.messageText) + '  ' +
                 'is HELD.';
              valuesDS.ShortMessageText = %trim(valuesDS.messageText);
              valuesDS = sendMessage(ValuesDS);

             when outqueueStatus = 'HELD' and  wValuesDS.heldMessage = 'Y';
              valuesDS.messageText = 'OutQueue:' + %trim(outQueue);
              valuesDS.messageText = %trim(valuesDS.messageText) + '  ' +
                 'is HELD.';
              valuesDS.ShortMessageText = %trim(valuesDS.messageText);
              valuesDS = sendMessage(ValuesDS);

             when numberofSpooledFiles  >= valuesDS.maxspool;
              valuesDS.messageText = 'OutQueue:' + %trim(outQueue);
              valuesDS.messageText = %trim(valuesDS.messageText) + '  ' +
                'has ' + %trim(%char(numberofSpooledFiles)) + ' spooled files.';
              valuesDS.ShortMessageText =
               'OutQueue:' + %trim(outQueue) + ' Too many Spooled Files';

              valuesDS = sendMessage(ValuesDS);
            endsl;
           endif;

          endfor;

          exec SQL close WorkCursor;

         Return  wValuesDS;

         end-proc checkOutQueues;

      *----------------------------------------------------------------
      *   checkwrkactjob  - process the wrkactjob messages
      *----------------------------------------------------------------

         dcl-proc checkwrkactjob export;

         dcl-pi *n char(32740);
          inValues char(32740) value;
         end-pi;

         dcl-s found int(10:0) inz;
         dcl-s i2 int(10:0) inz;
         dcl-s jobNameString char(30) inz;
         dcl-s maxItemLines2   zoned(5:0) inz(10000);
         dcl-s rowCount2 int(10:0) inz;
         dcl-s start int(10:0) inz;
         dcl-s workJobName char(10) inz;

         dcl-ds wValuesDS  qualified inz;
          maxSpool zoned(4:0);
          jobQueueQuantity zoned(4:0);
          messageText char(200);
          shortMessageText char(200);
          heldMessage char(1);
          testOrProduction char(10);
          messageResendDelay zoned(3:0);
          overrideEmail char(40);
          maxMessageSeverity zoned(2:0);
          endOfDay time;
          startOfDay time;
          messageQsysopr char(30);
          runOutQueueChecks char(1);
          monitorJobScheduler char(1);
          SkipOutqueue char(10) dim(30);
          outqueue char(300) samepos(SkipOutqueue);
          helpDeskEmail char(30) dim(10);
          email char(300) samepos(helpDeskEmail);
          omitMSGWJobs char(10) dim(30);
          jobs char(300) samepos(omitMSGWJobs);
          omitWRKACTJOB char(10) dim(30);
          activejob char(300) samepos(omitWRKACTJOB);
          // skipJobQueueDS
          skipJobQueue char(10) dim(30);
          jobQueue char(300) samepos(skipJobQueue);
          // skip schedule job
          skipScheduled char(10) dim(150);
          scheduled char(1500) samepos(skipScheduled);
          // skip error messages
          skipErrorIDs char(7) dim(100);
          ErrorId char(700) samepos(skipErrorIDs);
          // skip jobNames
          skipJobNames char(10) dim(100);
          jobNames char(1000) samepos(skipJobNames);
         end-ds wValuesDS;

        dcl-ds c2 dim(10000) qualified inz;
         jobnameLong  char(32);
         status  char(4);
         type char(3);
         authName char(10);
         runpriority int(10:0);
         subsystem char(10);
         subsystemLibrary char(10);
         CPU_Time zoned(20:0);
        end-ds c2;

        wValuesDS = inValues;

         // grab the data and place into array
         exec SQL
          declare  WorkCursor2 scroll cursor for
           select
            char(JOB_NAME,32), char(JOB_STATUS,4), char(JOB_TYPE,3),
            char(AUTHORIZATION_NAME,10), dec(RUN_PRIORITY,10,0),
            char(coalesce(SUBSYSTEM,' '),10) subsystem,
            char(coalesce(SUBSYSTEM_LIBRARY_NAME,' '),10),
            dec(CPU_TIME,20,0) CPU_Time
             FROM TABLE (QSYS2.ACTIVE_JOB_INFO()) V
             where (JOB_STATUS = 'MSGW'  or
             (JOB_STATUS = 'TIMW' and SUBSYSTEM = 'B2B_BATCH' and
             RUN_PRIORITY >= 600))
             order by SUBSYSTEM
          for read only;

          exec SQL open WorkCursor2;
           exec sql
            fetch first from WorkCursor2 for :MaxItemLines2
            rows into :C2;
            exec sql get diagnostics :RowCount2 = ROW_COUNT;
            exec SQL close WorkCursor2;

          for i2 = 1 to RowCount2;
           jobNameString = c2(i2).jobNameLong;
           start=1;
           dou found = *zeros;
            found = %scan('/':jobNameString:start);
            if found > *zeros;
             Start = found+1;
            endif;
           enddo;
           workJobName = %subst(jobNameString:start:10);

           // for production check all outqueues for test
           // only test those in released status
           if %lookup(workJobName:ValuesDS.omitMSGWJobs) = *zeros;
            if c2(i2).status = 'MSGW';
             valuesDS.messageText = 'Job:' + %trim(JobNameString );
             valuesDS.messageText = %trim(valuesDS.messageText) + '  ' +
                'is in *MSGW.';
             valuesDS.ShortMessageText = %trim(valuesDS.messageText);
             valuesDS = sendMessage(ValuesDS);
            endif;
            if c2(i2).status = 'TIMW';
             valuesDS.messageText = 'Job:' + %trim(JobNameString );
             valuesDS.messageText = %trim(valuesDS.messageText) + '  ' +
                'is in *TIMW longer than expected.';
             valuesDS.ShortMessageText = %trim(valuesDS.messageText);
             valuesDS = sendMessage(ValuesDS);
            endif;
           endif;

          endfor;

          exec SQL close WorkCursor2;

         Return  wValuesDS;

         end-proc checkwrkactjob;

      *----------------------------------------------------------------
      *   checkjobQueues  - check the job queues
      *----------------------------------------------------------------

         dcl-proc checkjobqueues export;

         dcl-pi *n char(32740);
          inValues char(32740) value;
         end-pi;

         dcl-s backupsAreRunning ind inz(*off);
         dcl-s nitJobsRunning ind inz(*off);
         dcl-s found int(10:0) inz;
         dcl-s i3 int(10:0) inz;
         dcl-s i3b int(10:0) inz;
         dcl-s maxItemLines3   zoned(5:0) inz(10000);
         dcl-s numberOfActiveJobs int(10:0);
         dcl-s rowCount3 int(10:0) inz;
         dcl-s rowCount3b int(10:0) inz;
         dcl-s start int(10:0) inz;
         dcl-s workJobName char(10) inz;
         dcl-s workJobQueue char(10) inz;

         dcl-ds wValuesDS  qualified inz;
          maxSpool zoned(4:0);
          jobQueueQuantity zoned(4:0);
          messageText char(200);
          shortMessageText char(200);
          heldMessage char(1);
          testOrProduction char(10);
          messageResendDelay zoned(3:0);
          overrideEmail char(40);
          maxMessageSeverity zoned(2:0);
          endOfDay time;
          startOfDay time;
          messageQsysopr char(30);
          runOutQueueChecks char(1);
          monitorJobScheduler char(1);
          SkipOutqueue char(10) dim(30);
          outqueue char(300) samepos(SkipOutqueue);
          helpDeskEmail char(30) dim(10);
          email char(300) samepos(helpDeskEmail);
          omitMSGWJobs char(10) dim(30);
          jobs char(300) samepos(omitMSGWJobs);
          omitWRKACTJOB char(10) dim(30);
          activejob char(300) samepos(omitWRKACTJOB);
          // skipJobQueueDS
          skipJobQueue char(10) dim(30);
          jobQueue char(300) samepos(skipJobQueue);
          // skip schedule job
          skipScheduled char(10) dim(150);
          scheduled char(1500) samepos(skipScheduled);
          // skip error messages
          skipErrorIDs char(7) dim(100);
          ErrorId char(700) samepos(skipErrorIDs);
          // skip jobNames
          skipJobNames char(10) dim(100);
          jobNames char(1000) samepos(skipJobNames);
         end-ds wValuesDS;

        dcl-ds c3 dim(10000) qualified inz;
         jobqueue  char(10);
         status  char(10);
         subsystem char(10);
         activeJobs int(10:0);
        end-ds c3;

        dcl-ds c3b dim(10000) qualified inz;
         username  char(10);
         jobnumber char(6);
         jobName char(10);
         status char(10);
        end-ds c3b;

        wValuesDS = inValues;

         // grab the data and place into array
         exec SQL
          declare  WorkCursor3 scroll cursor for
          SELECT JOB_QUEUE_NAME, JOB_QUEUE_STATUS,
          coalesce(SUBSYSTEM_NAME,'N/A'), NUMBER_OF_JOBS
              FROM QSYS2.JOB_QUEUE_INFO
          for read only;

          exec SQL open WorkCursor3;
           exec sql
            fetch first from WorkCursor3 for :MaxItemLines3
            rows into :C3;
            exec sql get diagnostics :RowCount3 = ROW_COUNT;
            exec sql close WorkCursor3;

            for i3 = 1 to RowCount3;
             // for production check all outqueues for test
             // only test those in released status

             if %lookup(c3(i3).JobQueue:wValuesDS.SkipJobqueue) = *zeros;

              workJobQueue = c3(i3).Jobqueue;
              //-------------------------------------------------
              // list all jobs by JobQueue
              exec SQL
               declare  WorkCursor3b scroll cursor for
                select SUBSTR(Two, 1, LOCATE('/', Two)-1  ) as myUser,
                  myJOb#,
                  substr(two, LOCATE('/', Two)+1 ) as myJobName,
                  job_queue_status
                  from(
                 SELECT SUBSTR(JOB_NAME, 1, LOCATE('/', JOB_NAME) - 1) myJOb#,
                  SUBSTR(JOB_NAME, LOCATE('/', JOB_NAME) + 1 ) as Two,
                  job_queue_status
                  FROM SYSTOOLS.JOB_QUEUE_ENTRIES a
                  WHERE JOB_QUEUE_LIBRARY = 'QGPL'
                  and JOB_QUEUE_NAME = :workJobQueue and
                  job_queue_status = 'RELEASED' )
               for read only;

               reset numberOfActiveJobs;
               exec SQL open WorkCursor3b;
                exec sql
                 fetch first from WorkCursor3b for :MaxItemLines3
                 rows into :C3b;
                 exec sql get diagnostics :RowCount3b = ROW_COUNT;
                 exec sql close WorkCursor3b;

                 for i3b = 1 to RowCount3b;
                  // is this a job to skip?
                  if %lookup(c3b(i3b).JobName:wValuesDS.SkipJobNames) = *zeros;
                   numberOfActiveJobs+=1;
                  endif;
                 endfor;

              //-------------------------------------------------

               reset backupsAreRunning;
               exec sql
                select '1'
                  into :backupsAreRunning
                  from table(qsys2.job_info(job_user_filter => '*ALL' ,
                       job_status_filter => '*ACTIVE') )
                    where job_name like '%BACKUP%';

               reset nitJobsRunning;
               exec sql
                select '1'
                  into :nitJobsRunning
                  from table(qsys2.job_info(job_user_filter => '*ALL' ,
                       job_status_filter => '*ACTIVE') )
                    where job_name like '%NITJOBS%';

               if c3(i3).status = 'HELD' and not(backupsAreRunning) and
                not(nitJobsRunning);
                valuesDS.messageText = 'JobQueue:' + %trim(c3(i3).jobQueue) +
                %trim(valuesDS.messageText) + '  ' +
                   'is *HELD.';
                valuesDS.ShortMessageText = %trim(valuesDS.messageText);
                valuesDS = sendMessage(ValuesDS);
                reset valuesDS.messageText;
               endif;


                // need to grab total jobs in this queue
               if numberOfActiveJobs >= wValuesDS.jobQueueQuantity
                   and not(backupsAreRunning) and not(nitJobsRunning);
                valuesDS.messageText = 'JobQueue:' + %trim(c3(i3).jobQueue) +
                %trim(valuesDS.messageText) + '  ' +
                   'has ' + %trim(%char(numberOfActiveJobs)) + ' jobs.';
                valuesDS.ShortMessageText =
                 'JobQueue:' + %trim(c3(i3).jobQueue) + ' too many Jobs.';
                valuesDS = sendMessage(ValuesDS);
                reset valuesDS.messageText;
               endif;

             endif;
            endfor;

         Return  wValuesDS;

         end-proc checkjobqueues;

      *----------------------------------------------------------------
      *   checkScheduledJobs - are scheduled jobs on hold
      *----------------------------------------------------------------

         dcl-proc checkScheduledJobs export;

         dcl-pi *n char(32740);
          inValues char(32740) value;
         end-pi;

         dcl-s found int(10:0) inz;
         dcl-s i4 int(10:0) inz;
         dcl-s jobNameString char(30) inz;
         dcl-s maxItemLines4   zoned(5:0) inz(10000);
         dcl-s skipJobScheduler char(1) inz;
         dcl-s rowCount4 int(10:0) inz;
         dcl-s start int(10:0) inz;
         dcl-s workJobScheduledName char(10) inz;

         dcl-ds wValuesDS  qualified inz;
          maxSpool zoned(4:0);
          jobQueueQuantity zoned(4:0);
          messageText char(200);
          shortMessageText char(200);
          heldMessage char(1);
          testOrProduction char(10);
          messageResendDelay zoned(3:0);
          overrideEmail char(40);
          maxMessageSeverity zoned(2:0);
          endOfDay time;
          startOfDay time;
          messageQsysopr char(30);
          runOutQueueChecks char(1);
          monitorJobScheduler char(1);
          SkipOutqueue char(10) dim(30);
          outqueue char(300) samepos(SkipOutqueue);
          helpDeskEmail char(30) dim(10);
          email char(300) samepos(helpDeskEmail);
          omitMSGWJobs char(10) dim(30);
          jobs char(300) samepos(omitMSGWJobs);
          omitWRKACTJOB char(10) dim(30);
          activejob char(300) samepos(omitWRKACTJOB);
          // skipJobQueueDS
          skipJobQueue char(10) dim(30);
          jobQueue char(300) samepos(skipJobQueue);
          // skip schedule job
          skipScheduled char(10) dim(150);
          scheduled char(1500) samepos(skipScheduled);
          // skip error messages
          skipErrorIDs char(7) dim(100);
          ErrorId char(700) samepos(skipErrorIDs);
          // skip jobNames
          skipJobNames char(10) dim(100);
          jobNames char(1000) samepos(skipJobNames);
         end-ds wValuesDS;

        dcl-ds c4 dim(10000) qualified inz;
         jobname  char(10);
         status  char(9);
         stamp timestamp;
        end-ds c4;

        wValuesDS = inValues;

         // grab the data and place into array
         exec SQL
          declare  WorkCursor4 scroll cursor for
           select SCDJOBNAME,STATUS,
             coalesce(SBMTIMSTMP,current_timestamp - 3 years)
             from  QSYS2.SCHEDULED_JOB_INFO a
             order by SCHEDULED_TIME
          for read only;

          exec SQL open WorkCursor4;
           exec sql
            fetch first from WorkCursor4 for :MaxItemLines4
            rows into :C4;
            exec sql get diagnostics :RowCount4 = ROW_COUNT;
            exec SQL close WorkCursor4;

          for i4 = 1 to RowCount4;
           workJobScheduledName = c4(i4).jobname;

            SkipJobScheduler = wValuesDS.monitorJobScheduler;

           // for production check all shcheduled jobs check if on HOLD
           if %lookup(workJobScheduledName:wvaluesDS.skipScheduled) = *zeros and
              c4(i4).status = 'HELD' and skipJobScheduler = 'N';
            valuesDS.messageText = 'Job Scheduled Entry:' +
            %trim(workJobScheduledName);
            valuesDS.messageText = %trim(valuesDS.messageText) + '  ' +
               'is on *HOLD.';
            valuesDS.ShortMessageText = %trim(valuesDS.messageText);
            valuesDS = sendMessage(ValuesDS);
           endif;

          endfor;

          exec SQL close WorkCursor4;

         Return  wValuesDS;

         end-proc checkScheduledJobs;

      *----------------------------------------------------------------
      *   checkQsysopr  - qsysopr check messages
      *----------------------------------------------------------------

         dcl-proc checkQsysopr export;

         dcl-pi *n char(32740);
          inValues char(32740) value;
         end-pi;

         dcl-s found int(10:0) inz;
         dcl-s i7 int(10:0) inz;
         dcl-s jobNameString char(30) inz;
         dcl-s lastRunStamp timestamp inz;
         dcl-s maxItemLines7 zoned(5:0) inz(10000);
         dcl-s messageStamp timestamp inz;
         dcl-s messageQsysopr char(30) inz;
         dcl-s myMaxMessageSeverity zoned(2:0) inz;
         dcl-s rowCount7 int(10:0) inz;
         dcl-s start int(10:0) inz;
         dcl-s thisJobsStatus char(10) inz;
         dcl-s workJobName char(10) inz;
         dcl-s workMessageId char(7) inz;

         dcl-ds wValuesDS  qualified inz;
          maxSpool zoned(4:0);
          jobQueueQuantity zoned(4:0);
          messageText char(200);
          shortMessageText char(200);
          heldMessage char(1);
          testOrProduction char(10);
          messageResendDelay zoned(3:0);
          overrideEmail char(40);
          maxMessageSeverity zoned(2:0);
          endOfDay time;
          startOfDay time;
          messageQsysopr char(30);
          runOutQueueChecks char(1);
          monitorJobScheduler char(1);
          SkipOutqueue char(10) dim(30);
          outqueue char(300) samepos(SkipOutqueue);
          helpDeskEmail char(30) dim(10);
          email char(300) samepos(helpDeskEmail);
          omitMSGWJobs char(10) dim(30);
          jobs char(300) samepos(omitMSGWJobs);
          omitWRKACTJOB char(10) dim(30);
          activejob char(300) samepos(omitWRKACTJOB);
          // skipJobQueueDS
          skipJobQueue char(10) dim(30);
          jobQueue char(300) samepos(skipJobQueue);
          // skip schedule job
          skipScheduled char(10) dim(150);
          scheduled char(1500) samepos(skipScheduled);
          // skip error messages
          skipErrorIDs char(7) dim(100);
          ErrorId char(700) samepos(skipErrorIDs);
          // skip jobNames
          skipJobNames char(10) dim(100);
          jobNames char(1000) samepos(skipJobNames);
         end-ds wValuesDS;

        dcl-ds c7 dim(10000) qualified inz;
         messageStamp timestamp;
         messageID char(7);
         messageQsysopr char(30);
         runOutQueueChecks char(1);
          monitorJobScheduler char(1);
         messageSeverity zoned(3:0);
         fromJob char(32);
         fromProgram char(10);
        end-ds c7;

        wValuesDS = inValues;
        // pull in last runstamp
        reset lastRunStamp;
        exec sql
         select data_area_value
         into :lastRunStamp
         from qsys2.data_area_info
         WHERE data_area_name = 'SYSMONITOR';

        myMaxMessageSeverity = wValuesDS.maxMessageSeverity;
         // grab the data and place into array
         exec SQL
          declare  WorkCursor7 scroll cursor for
           SELECT MSG_TIME AS TIME,coalesce(MSGID,'      ') AS MSGID,
                  CAST(MSG_TEXT AS CHAR(100) CCSID 37) AS TEXT,
                  SEVERITY,FROM_JOB,FROM_PGM
            FROM QSYS2.MESSAGE_QUEUE_INFO
            WHERE MSGQ_NAME = 'QSYSOPR' and
                  message_type <> 'REPLY' and
                  SEVERITY >= : myMaxMessageSeverity
            ORDER BY MSG_TIME DESC
           with NC
           for read only;

          exec SQL open WorkCursor7;
           exec sql
            fetch first from WorkCursor7 for :MaxItemLines7
            rows into :C7;
            exec sql get diagnostics :RowCount7 = ROW_COUNT;
            exec SQL close WorkCursor7;

          for i7 = 1 to RowCount7;

           jobNameString = c7(i7).fromJob;
           messageStamp = c7(i7).messageStamp;
           workMessageId = c7(i7).messageID;
           messageQsysopr = c7(i7).messageQsysopr;
           wValuesDS.messageQsysopr = messageQsysopr;

           // check to see if this is job is still *ACTIVE
           reset thisJobsStatus;
           exec sql
            SELECT JOB_STATUS
             into :thisJobsStatus
               FROM TABLE(QSYS2.JOB_INFO(JOB_USER_FILTER => '*ALL',
                                         JOB_TYPE_FILTER => '*ALL')) A
               WHERE job_name = trim(:jobNameString)
               fetch first row only;

           // check list of error messages to ignore
            if messageStamp  >= lastRunStamp and
              (%lookup(workMessageId:ValuesDS.skipErrorIDs) = *zeros or
               workMessageID = *blanks);
             select;
              when workMessageID = *blanks;
               valuesDS.messageText = wValuesDS.messageQsysopr;
              other;
               valuesDS.messageText = 'Job:' + %trim(JobNameString );
               valuesDS.messageText = %trim(valuesDS.messageText) + '  ' +
                                      'is in *MSGW.';
             endsl;
             valuesDS.ShortMessageText = %trim(valuesDS.messageText);
             valuesDS = sendMessage(ValuesDS);
            endif;

          endfor;

          exec SQL close WorkCursor7;

          Return  wValuesDS;

         end-proc checkQsysopr;

      *----------------------------------------------------------------
      *   sendMessage  - send message to users
      *----------------------------------------------------------------

         dcl-proc sendMessage export;

          dcl-pi *n char(32740);
           inValues char(32740) value;
          end-pi;

         dcl-s bigEmailString char(300)inz;
         dcl-s count int(10:0) inz;
         dcl-s emailAddress char(50) inz;
         dcl-s found  zoned(10:0) inz;
         dcl-s foundDot zoned(10:0) inz;
         dcl-s myMessage char(200) inz;
         dcl-s mySubject char(200) inz;
         dcl-s sendThisMessage ind inz(*off);
         dcl-s shortSystemName char(10) inz;


         dcl-ds wValuesDS  qualified inz;
          maxSpool zoned(4:0);
          jobQueueQuantity zoned(4:0);
          messageText char(200);
          shortMessageText char(200);
          heldMessage char(1);
          testOrProduction char(10);
          messageResendDelay zoned(3:0);
          overrideEmail char(40);
          maxMessageSeverity zoned(2:0);
          endOfDay time;
          startOfDay time;
          messageQsysopr char(30);
          runOutQueueChecks char(1);
          monitorJobScheduler char(1);
          SkipOutqueue char(10) dim(30);
          outqueue char(300) samepos(SkipOutqueue);
          helpDeskEmail char(30) dim(10);
          email char(300) samepos(helpDeskEmail);
          omitMSGWJobs char(10) dim(30);
          jobs char(300) samepos(omitMSGWJobs);
          omitWRKACTJOB char(10) dim(30);
          activejob char(300) samepos(omitWRKACTJOB);
          // skipJobQueueDS
          skipJobQueue char(10) dim(30);
          jobQueue char(300) samepos(skipJobQueue);
          // skip schedule job
          skipScheduled char(10) dim(150);
          scheduled char(1500) samepos(skipScheduled);
          // skip error messages
          skipErrorIDs char(7) dim(100);
          ErrorId char(700) samepos(skipErrorIDs);
          // skip jobNames
          skipJobNames char(10) dim(100);
          jobNames char(1000) samepos(skipJobNames);
         end-ds wValuesDS;
         wValuesDS = inValues;

         mySubject = 'SysMon';
         // grab system name
         reset systemName;
         exec sql
          select Local_Host_name
          into :systemName
          from TCPIP_INFO;

         reset shortSystemName;
         foundDot = %scan('.':systemName);
         shortSystemName = %trim(%subst(systemName:1:FoundDot-1));

          mySubject =  %trim(%upper(shortSystemName)) +
            '_' + %trim(mySubject);

         myMessage = wValuesDS.shortMessageText;

         // lookup the essage
         reset sendThisMessage;
         found = %lookup(myMessage:messageTracker(*).message);
         if found > *zeros;
          if %diff(%timeStamp:messageTracker(found).lastSent:*minutes) >=
             wValuesDS.messageResendDelay;
           sendThisMessage = *on;
           messageTracker(found).lastSent = %timeStamp();
          endif;
         else;
          index+=1;
          messageTracker(index).message = myMessage;
          messageTracker(index).lastSent = %timeStamp();
          sendThisMessage = *on;
         endif;

         if sendThisMessage;

          // WVALUESDS.HELPDESKEMAIL
          reset bigEmailString;
          for count = 1 to 10;
           bigEmailString = %trim(bigEmailString) +
            Q+ %trim(wValuesDS.helpDeskEmail(count)) +Q+ '^';
          endfor;

          bigEmailString = %xlate('^':' ':bigEmailString);

          // addlible MAILTOOL
          commandString =
          'ADDLIBLE MAILTOOL *LAST';
          commandLength = %len(%trim(commandString));
          monitor;
           $command(commandString: commandLength);
          on-error;
          endmon;

          myMessage = %trim(myMessage);

          commandString =
          'MAILTOOL TOADDR(' + %trim(bigEmailString) + ') ' +
          'FROMADDR(isdept@ecmdi.com) '  +
          'SUBJECT(' + Q + %trim(mySubject) + Q +
          ') MESSAGE(' + Q + %trim(myMessage) + Q + ')';
          commandLength = %len(%trim(commandString));
          monitor;
           $command(commandString: commandLength);
          on-error;
          endmon;
         endif;

         Return  wValuesDS;

        end-proc sendMessage;

      *----------------------------------------------------------------
      *   setProgramValues  - import program values
      *----------------------------------------------------------------

         dcl-proc setProgramValues export;

         dcl-pi *n char(32740);
          inValues char(32740) value;
         end-pi;

         dcl-s endOfDay6 zoned(6:0) inz;
         dcl-s EODKey  char(10) inz;
         dcl-s foundDataArea ind inz(*off);
         dcl-s checkOutqkey char(10) inz;
         dcl-s heldOutQueueKey char(10)  inz;
         dcl-s maxJobQueueQuantityKey char(10) inz;
         dcl-s maxOutQueueKey  char(10)  inz;
         dcl-s omitJobInMSGW char(10) inz;
         dcl-s runningSystem char(10)  inz;
         dcl-s skipJobQueueKey char(10) inz;
         dcl-s skipOutQueueKey char(10) inz;
         dcl-s skipErrorsIDKey char(10) inz;
         dcl-s messageResendDelayKey char(10) inz;
         dcl-s messageResendDelay char(40) inz;
         dcl-s maxMessageSeverityKey char(10) inz;
         dcl-s monitorJobSchedulerKey char(10)inz;
         dcl-s overrideEmailkey char(10) inz;
         dcl-s runOutqueueChecks char(1) inz;
         dcl-s skipJobKey char(10) inz;
         dcl-s skipErrorIdsKey char(10) inz;
         dcl-s skipScheduledKey char(10) inz;
         dcl-s SODKey  char(10) inz;
         dcl-s startOfDay6 zoned(6:0) inz;
         dcl-s overrideEmail char(40) inz;
         dcl-s char10  char(10) inz;
         dcl-s isodate  date inz;

         dcl-ds wValuesDS  qualified inz;
          maxSpool zoned(4:0);
          jobQueueQuantity zoned(4:0);
          messageText char(200);
          shortMessageText char(200);
          heldMessage char(1);
          testOrProduction char(10);
          messageResendDelay zoned(3:0);
          overrideEmail char(40);
          maxMessageSeverity zoned(2:0);
          endOfDay time;
          startOfDay time;
          messageQsysopr char(30);
          runOutQueueChecks char(1);
          monitorJobScheduler char(1);
          SkipOutqueue char(10) dim(30);
          outqueue char(300) samepos(SkipOutqueue);
          helpDeskEmail char(30) dim(10);
          email char(300) samepos(helpDeskEmail);
          omitMSGWJobs char(10) dim(30);
          jobs char(300) samepos(omitMSGWJobs);
          omitWRKACTJOB char(10) dim(30);
          activejob char(300) samepos(omitWRKACTJOB);
          // skipJobQueueDS
          skipJobQueue char(10) dim(30);
          jobQueue char(300) samepos(skipJobQueue);
          // skip schedule job
          skipScheduled char(10) dim(150);
          scheduled char(1500) samepos(skipScheduled);
          // skip error messages
          skipErrorIDs char(7) dim(100);
          ErrorId char(700) samepos(skipErrorIDs);
          // skip jobNames
          skipJobNames char(10) dim(100);
          jobNames char(1000) samepos(skipJobNames);
         end-ds wValuesDS;

         dcl-ds skipDS  qualified inz;
          list char(300) pos(1);
          listArray dim(30) pos(1);
          outqueue char(10) overlay (listArray: 1);
         end-ds skipDS;

         dcl-ds emailDS  qualified inz;
          list char(300) pos(1);
          listArray dim(10) pos(1);
          email char(30) overlay (listArray: 1);
         end-ds emailDS;

         dcl-ds omitDS  qualified inz;
          list char(300) pos(1);
          listArray dim(30) pos(1);
          jobname char(10) overlay (listArray: 1);
         end-ds omitDS;

         dcl-ds omitWRKACTJOBDS  qualified inz;
          list char(300) pos(1);
          listArray dim(30) pos(1);
          jobname char(10) overlay (listArray: 1);
         end-ds omitWRKACTJOBDS;

         dcl-ds skipJobQueueDS  qualified inz;
          list char(300) pos(1);
          listArray dim(30) pos(1);
          Jobqueue char(10) overlay (listArray: 1);
         end-ds skipJobQueueDS;

         dcl-ds skipScheduledDS  qualified inz;
          list char(1500) pos(1);
          listArray dim(150) pos(1);
          scheduledJob char(10) overlay (listArray: 1);
         end-ds skipScheduledDS;

         dcl-ds skipErrorIDsDS  qualified inz;
          list char(700) pos(1);
          listArray dim(100) pos(1);
          scheduledJob char(7) overlay (listArray: 1);
         end-ds skipErrorIDsDS;

         dcl-ds skipJobNamesDS  qualified inz;
          list char(1000) pos(1);
          listArray dim(100) pos(1);
          jobName char(10) overlay (listArray: 1);
         end-ds skipJobNamesDS;

           select;
            when prodtest = 'TEST';
             heldOutQueueKey = 'HELDOUTT';
             maxOutQueueKey = 'MAXSPOOLT';
             skipOutQueueKey = 'SKIPOUTQT';
             omitJobInMSGW = 'OMITJOBT';
             overrideEmailkey = 'OVEREMAILT';
             maxMessageSeverityKey = 'QSYSLVLT';
             skipJobQueueKey = 'SKIPJOBQT';
             maxJobQueueQuantityKey = 'JOBQQTYT';
             messageResendDelayKey = 'MSGDELAYT';
             skipScheduledKey = 'SKIPSCHDT';
             skipErrorsIdKey = 'SKIPMSGT';
             sodKey = 'SODTIMET';
             eodKey = 'EODTIMET';
             checkOutqKey = 'CHKOUTQT';
             skipJobKey = 'SKIPJOBNT';
             monitorJobSchedulerKey = 'SKIPJST';

            when prodtest = 'PROD';
             heldOutQueueKey = 'HELDOUTP';
             maxOutQueueKey = 'MAXSPOOLP';
             skipOutQueueKey = 'SKIPOUTQP';
             overrideEmailkey = 'OVEREMAILP';
             maxMessageSeverityKey = 'QSYSLVLP';
             omitJobInMSGW = 'OMITJOBP';
             skipJobQueueKey = 'SKIPJOBQP';
             maxJobQueueQuantityKey = 'JOBQQTYP';
             messageResendDelayKey = 'MSGDELAYP';
             skipScheduledKey = 'SKIPSCHDP';
             sodKey = 'SODTIMEP';
             eodKey = 'EODTIMEP';
             skipErrorsIdKey = 'SKIPMSGP';
             checkOutqKey = 'CHKOUTQP';
             skipJobKey = 'SKIPJOBNP';
             monitorJobSchedulerKey = 'SKIPJSP';
           endsl;

           wValuesDS = inValues;

           reset wValuesDS.monitorJobScheduler;
           exec sql
            select TBNO03
             into :wValuesDS.monitorJobScheduler
             from tbpmtbl
             where TBNO01 = 'SMON' and TBNO02 = :monitorJobSchedulerKey;

           reset wValuesDS.maxMessageSeverity;
           exec sql
            select TBNO03
             into :wValuesDS.maxMessageSeverity
             from tbpmtbl
             where TBNO01 = 'SMON' and TBNO02 = :maxMessageSeverityKey;

           reset wValuesDS.maxSpool;
           exec sql
            select TBNO03
             into :wValuesDS.maxSpool
             from tbpmtbl
             where TBNO01 = 'SMON' and TBNO02 = :maxOutQueueKey;

           reset wValuesDS.jobQueueQuantity;
           exec sql
            select dec(substr(TBNO03,1,4),4,0)
             into :wValuesDS.jobQueueQuantity
             from tbpmtbl
             where TBNO01 = 'SMON' and TBNO02 = :maxJobQueueQuantityKey;

           reset wValuesDS.messageResendDelay;
           exec sql
            select dec(substr(TBNO03,1,4),4,0)
             into :wValuesDS.messageResendDelay
             from tbpmtbl
             where TBNO01 = 'SMON' and TBNO02 = :messageResendDelayKey;

           reset wValuesDS.overrideEmail;
           exec sql
            select dec(substr(TBNO03,1,4),4,0)
             into :wValuesDS.overrideEmail
             from tbpmtbl
             where TBNO01 = 'SMON' and TBNO02 = :overrideEmailKey;

           reset wValuesDS.heldMessage;
           exec sql
            select TBNO03
             into :wValuesDS.heldMessage
             from tbpmtbl
             where TBNO01 = 'SMON' and TBNO02 = :heldOutQueueKey;

           // grab outqueues to omit
           exec sql
            select listagg(substr(a.TBNO03,1,10))
             within group (order by a.TBNO03) as List
             into : skipDS.list
             from tbpmtbl  as a
             where a.TBNO01 >= 'SMON' and a.tbno02 = :skipOutQueueKey;
           wValuesDS.outqueue = skipDS.list;

           // grab jobQueues to omit
           exec sql
            select listagg(substr(a.TBNO03,1,10))
             within group (order by a.TBNO03) as List
             into : skipJobQueueDS.list
             from tbpmtbl  as a
             where a.TBNO01 >= 'SMON' and a.tbno02 = :skipJobQueueKey;
           wValuesDS.jobQueue = skipJobQueueDS.list;

           // grab email addresses for messages
           exec sql
            select listagg(ONCALLTEXT)
             within group (order by a.ONCALLTEXT) as List
             into : emailDS.list
             from OPPONCALL  as a
             where ISONCALL = 'Y';

           wValuesDS.email = emailDS.list;

           // grab job names to omit
           exec sql
            select listagg(substr(a.TBNO03,1,10))
             within group (order by a.TBNO03) as List
             into : omitDS.list
             from tbpmtbl  as a
             where a.TBNO01 >= 'SMON' and a.tbno02 = :omitJobInMSGW;

           wValuesDS.omitMSGWJobs = omitDS.jobname;

           // grab job scheduled entries to skip
           exec sql
            select listagg(substr(a.TBNO03,1,10))
             within group (order by a.TBNO03) as List
             into : skipScheduledDS.list
             from tbpmtbl  as a
             where a.TBNO01 >= 'SMON' and a.tbno02 = :skipScheduledKey;

           // grab errorIDs to Skip
           exec sql
            select listagg(substr(a.TBNO03,1,7))
             within group (order by a.TBNO03) as List
             into : skipErrorIDsDS.list
             from tbpmtbl  as a
             where a.TBNO01 >= 'SMON' and a.tbno02 = :skipErrorsIdKey;
           wValuesDS.ErrorId  = skipErrorIDsDS.list;

           // check for data area SYSMONITOR create if not found
           reset foundDataArea;
           exec sql
            SELECT '1'
             into :foundDataArea
              FROM TABLE(QSYS2.OBJECT_STATISTICS
              ('*LIBL','DTAARA',OBJECT_NAME => 'SYSMONITOR')) A;

           // CRTDTAARA DTAARA(HD1100PO/SYSMONITOR)
           // TYPE(*CHAR) LEN(26)
           // TEXT('Last run stamp for error monitor')

           if not(foundDataArea);
            commandString =
            'CRTDTAARA DTAARA(HD1100PO/SYSMONITOR) ' +
            'TYPE(*CHAR) LEN(26) TEXT(' +Q+
            'Last run stamp for error monitor' +Q+ ')';
            commandLength = %len(%trim(commandString));
            monitor;
             $command(commandString: commandLength);
            on-error;
            endmon;
           endif;

           // get start of day time
           reset wValuesDS.startOfDay;
           reset startOfDay6;
           exec sql
            select dec(substr(TBNO03,1,6),6,0)
             into :startOfDay6
             from tbpmtbl
             where TBNO01 = 'SMON' and TBNO02 = :SODKey;
           wValuesDS.startOfDay = %time(endOfDay6:*HMS);

           // get end of day time
           reset wValuesDS.endOfDay;
           reset endOfDay6;
           exec sql
            select dec(substr(TBNO03,1,6),6,0)
             into :endOfDay6
             from tbpmtbl
             where TBNO01 = 'SMON' and TBNO02 = :EODKey;
           wValuesDS.endOfDay = %time(endOfDay6:*HMS);

           wValuesDS.scheduled = skipScheduledDS.list;

           reset runOutQueueChecks;
           exec sql
            select substr(TBNO03,1,1)
             into :runOutQueueChecks
             from tbpmtbl
             where TBNO01 = 'SMON' and TBNO02 = :checkOutqKey;
           wValuesDS.runOutQueueChecks = runOutQueueChecks;

           // grab job names to skip in jobq
           exec sql
            select listagg(substr(a.TBNO03,1,10))
             within group (order by a.TBNO03) as List
             into : skipJobNamesDS.list
             from tbpmtbl  as a
             where a.TBNO01 >= 'SMON' and a.tbno02 = :skipJobKey;
           wValuesDS.jobNames = skipJobNamesDS.list;

           Return  wValuesDS;

           end-proc setProgramValues;
