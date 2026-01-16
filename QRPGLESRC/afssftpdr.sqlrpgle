         Ctl-Opt BndDir('ECBIND') ExtBinInt(*Yes) DecEdit('0.')
         Option(*NoDebugIO) Text('AFS Get Table');
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - AFSSFTPDR                                              *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D AFS - download daily AFS transactions                                 *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    load up daily table of AFS shipments for BI                        *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3176 010226 JJF created program                                 *
     F*M JJF   3176 011625 JJF optimized CSV date conversion - handle non-     *
     F*M                       padded dates, consolidated timestamp processing *
     F*M                       Removed redundant date/time parsing code and    *
     F*M                       moved all logic into convertCSVDateToTimestamp  *
     F*M                       Code reformatted using Roo code addon           *
     F*M ----------------------------------------------------------------------*

          // RUNCMND - run a command
          dcl-s ECBasePath varchar(100) inz('/Home/AFS/');
          dcl-s ECFullPath varchar(100) inz;
          dcl-s duplicateRecord ind inz(*off);
          dcl-s fromPath varchar(100) inz;
          dcl-s FTPFlag ind inz(*off);
          dcl-s i int(10:0) inz;
          dcl-s i2 int(10:0) inz;
          dcl-s inStr       varchar(50) inz;
          dcl-s maxItemLines int(10:0) inz(100);
          dcl-s maxItemLines2 int(10:0) inz(3000);
          dcl-s myPathName varchar(100) inz;
          dcl-s Q char(1) inz('''');
          dcl-s rowCount int(10:0) inz;
          dcl-s rowCount2 int(10:0) inz;
          dcl-s watscoBasePath varchar(100) inz('/Watsco/FromAFS/');

         /COPY qcpysrc,RUNCMND_CP

         // Date conversion procedure prototype
         dcl-pr convertCSVDateToTimestamp timestamp;
           dateTimeStr varchar(50) const;
         end-pr;

          dcl-ds c1 dim(100) qualified inz;
           fullPath varchar(100);
          end-ds c1;

          dcl-ds c2 dim(3000) qualified inz;
           branch zoned(3:0);
           shipid char(10);
           pronumber char(21);
           reference char(30);
           carrier char(40);
           scac char(4);
           destination char(40);
           address char(40);
           city char(21);
           state char(2);
           zip char(5);
           miles char(4);
           class char(4);
           pieces char(10);
           weight char(10);
           charge char(10);
           lineHaul char(10);
           FSC char(10);
           accessorial char(10);
           accessorialNote char(80);
           estimatedPickup char(30);
           actualPickup char(30);
           estimatedDelivery char(30);
           actualDelivery char(30);
          end-ds c2;

          dcl-ds AFSSHIPDds extname('AFSSHIPD')qualified inz;
          end-ds AFSSHIPDds;

          // -------------- *Plist --------------- Prototypes
          // Prototype for external program AFSPOPR //
          dcl-pr Main extpgm('AFSSFTPDR');
           inFTPFlag char(1);
          end-pr;

          // Procedure interface //
          dcl-pi Main;
           inFTPFlag char(1);
          end-pi;

          *inlr = *on;

          if %parms >= 1;
           if inFTPFlag = 'Y';
            FTPFlag = *on;
           endif;
          endif;

          exec sql
           create or replace
           table qtemp.afsdaily
           (outString CHAR(100) NOT NULL)
            on REPLACE DELETE ROWS;

           if  FTPFlag;
            // run command
            commandString = 'AFENDFTP';
            OutErrorDS = runIBMCommand(commandString);

            // run command
            commandString = 'AFSTRFTP SVRDFN(' + 'AFS' + ')';
            OutErrorDS = runIBMCommand(commandString);

            // change directory
            commandString = 'AFLIST PATH(' +Q+ %trim(watscoBasePath) +Q+
                            ') OUTPUT(*DBF) OBJECTS(*FILES)' +
                            ' TODBF(QTEMP/AFSDAILY)';
            OutErrorDS = runIBMCommand(commandString);
           // need to populate table qtemp.afsdaily with whatever in in:
           //
           else;
            reset myPathName;
            exec sql
             select path_name
               into :myPathName
               from table
                (qsys2.ifs_object_statistics(
                 start_path_name => '/home/afs'))
                 where object_type = '*STMF'
                 fetch first row only;
            if myPathName > *blanks;
             exec sql
              insert into qtemp.afsdaily (outstring)
                 values(:myPathName);
            endif;
           endif;

          exec SQL
           declare  WorkCursor scroll cursor for
            select outString from qtemp.afsDaily
           for read only;

          exec SQL open WorkCursor;
           exec sql
            fetch first from WorkCursor for :MaxItemLines
            rows into :C1;
            exec sql get diagnostics :RowCount = ROW_COUNT;

          for i = 1 to RowCount;
           fromPath = %trim(c1(i).fullPath);
           // grab the table
           //  AFGETIFS RMTPATH('/watsco/FromAFS/ProcessedShipments.csv')
           //           IFSPATH('/home/AFS/')

           if FTPFlag;
            ECFullPath = %trim(ECBasePath) + 'AFS_Detal_' +
             %trim(%char(%timestamp)) + '.csv';

            commandString = 'AFGETIFS RMTPATH(' +Q+ %trim(fromPath) +Q+
             ') IFSPATH(' +Q+ %trim(ECFullPath)  +Q+ ')';
            OutErrorDS = runIBMCommand(commandString);
           else;
            ECFullPath = myPathName;
           endif;

           // create our workTable
           exec sql
            create or replace table qtemp.afsshipp(
            clntname char(50) ccsid 37 default '',
            company char(20) ccsid 37 default '',
            shipid char(50) ccsid 37 default '',
            prono char(50) ccsid 37 default '',
            pono char(50) ccsid 37 default '',
            otvr char(50) ccsid 37 default '',
            rorflg char(10) ccsid 37 default '',
            custpo char(50) ccsid 37 default '',
            xferord char(50) ccsid 37 default '',
            ordno char(50) ccsid 37 default '',
            pkgref1 char(100) ccsid 37 default '',
            pkgref2 char(100) ccsid 37 default '',
            pkgref3 char(100) ccsid 37 default '',
            carrname char(100) ccsid 37 default '',
            carrscac char(10) ccsid 37 default '',
            mode char(20) ccsid 37 default '',
            chgtyp char(20) ccsid 37 default '',
            origname char(100) ccsid 37 default '',
            origadr1 char(100) ccsid 37 default '',
            origcity char(100) ccsid 37 default '',
            origst char(20) ccsid 37 default '',
            origzip char(20) ccsid 37 default '',
            destname char(100) ccsid 37 default '',
            destadr1 char(100) ccsid 37 default '',
            destcity char(100) ccsid 37 default '',
            destst char(20) ccsid 37 default '',
            destzip char(20) ccsid 37 default '',
            miles char(20) ccsid 37 default '',
            class char(20) ccsid 37 default '',
            dims char(50) ccsid 37 default '',
            pieces char(20) ccsid 37 default '',
            weight char(20) ccsid 37 default '',
            nmfc char(20) ccsid 37 default '',
            custchg char(20) ccsid 37 default '',
            linehaul char(20) ccsid 37 default '',
            fsc char(20) ccsid 37 default '',
            acctot char(20) ccsid 37 default '',
            totcost char(20) ccsid 37 default '',
            lccname char(100) ccsid 37 default '',
            lccscac char(20) ccsid 37 default '',
            lcclh char(20) ccsid 37 default '',
            lccloss char(20) ccsid 37 default '',
            accs char(500) ccsid 37 default '',
            bookdt char(20) ccsid 37 default '',
            estpu char(30) ccsid 37 default '',
            puappt char(30) ccsid 37 default '',
            actpu char(30) ccsid 37 default '',
            needdt char(30) ccsid 37 default '',
            estdel char(30) ccsid 37 default '',
            delappt char(30) ccsid 37 default '',
            actdel char(30) ccsid 37 default '',
            status char(20) ccsid 37 default '',
            eta char(30) ccsid 37 default '',
            crtby char(50) ccsid 37 default ''
            )
            on replace delete rows;

           // place the IFS table into this work table
           commandString = 'CPYFRMIMPF FROMSTMF(' +Q+
            %trim(ECFullPath) +Q+ ') TOFILE(QTEMP/AFSSHIPP) ' +
            ' MBROPT(*REPLACE) RCDDLM(*CRLF) ' +
            'DTAFMT(*DLM) STRDLM(' +Q+'"'+Q+ ') FLDDLM(' +Q+ ',' +Q+
            ')  RPLNULLVAL(*FLDDFT)';
           OutErrorDS = runIBMCommand(commandString);

           // remove *ALL - BUT East Coast records
           exec sql
            delete from qtemp.AFSSHIPP where substr(company,1,3) <> 'ECM';

           // ------------------------------------------------------
           // plow thru the records and write out to History table
           // find the ship record in the group

           exec SQL
            declare  WorkCursor2 scroll cursor for
             select
             dec(trim(substr(COMPANY,5,3)),3,0) branch, SHIPID,PRONO, OTVR,
             carrname, carrscac, destname,
             destadr1,  destcity, destst, destzip, miles, class,
             pieces, weight, custchg,linehaul,fsc,
             coalesce(acctot,'0') acctot,
             accs, estpu, actpu, estdel, actdel
             from qtemp.AFSSHIPP a
             where LINEHAUL =  LCCLH
            for read only;

           exec SQL open WorkCursor2;
            exec sql
             fetch first from WorkCursor2 for :MaxItemLines2
             rows into :C2;
             exec sql get diagnostics :RowCount2 = ROW_COUNT;

           for i2 = 1 to RowCount2;
            clear AFSSHIPDds;

            AFSSHIPDds.BRANCH = c2(i2).branch;
            AFSSHIPDds.SHIPID = %trim(c2(i2).shipid);
            AFSSHIPDds.PRONUMBER = %trim(c2(i2).pronumber);
            AFSSHIPDds.REFERENCE = %upper(%trim(c2(i2).reference));
            //
            AFSSHIPDds.TYPE = *blanks;

            AFSSHIPDds.CARRIER = c2(i2).carrier;
            AFSSHIPDds.SCACCODE = c2(i2).scac;
            AFSSHIPDds.DESTNAME  = c2(i2).destination;
            AFSSHIPDds.DESTADD1 = c2(i2).address;
            AFSSHIPDds.DESTCITY = c2(i2).city;
            AFSSHIPDds.DESTSTATE = c2(i2).state;
            AFSSHIPDds.DESTZIP = %dec(%trim(c2(i2).zip):5:0);
            AFSSHIPDds.MILEAGE = %dec(%trim(c2(i2).miles):7:2);
            if c2(i2).class = *blanks;
             c2(i2).class = *all'0';
            endif;
            AFSSHIPDds.CLASS  = %dec(%trim(c2(i2).class):3:0);
            AFSSHIPDds.PIECES = %dec(%trim(c2(i2).pieces):5:0);
            AFSSHIPDds.WEIGHT  = %dec(%trim(c2(i2).weight):7:2);
            AFSSHIPDds.CHARGE = %dec(%trim(c2(i2).charge):7:2);
            if c2(i2).lineHaul = *blanks;
             c2(i2).lineHaul = *all'0';
            endif;
            AFSSHIPDds.LINEHAUL =  %dec(%trim(c2(i2).lineHaul):7:2);
            AFSSHIPDds.FUELSURCHG = %dec(%trim(c2(i2).fsc):7:2);
            if c2(i2).accessorial = *blanks;
             c2(i2).accessorial = *all'0';
            endif;
            AFSSHIPDds.ADDEDCHRG = %dec(%trim(c2(i2).accessorial):7:2);
            AFSSHIPDds.ADDEDDESC = %trim(c2(i2).accessorialNote);

            // 2025-12-29-13.17.53.307000
            // 11/25/2025 2:46:00 PM
            // --- split date & time ---
            inStr = c2(i2).estimatedPickup;
            if inStr <> *blanks;
             AFSSHIPDds.ESTPICKUP = convertCSVDateToTimestamp(inStr);
            else;
             AFSSHIPDds.ESTPICKUP = *loval;
            endif;

            // 2025-12-29-13.17.53.307000
            // 11/25/2025 2:46:00 PM
            // --- split date & time ---
            inStr = c2(i2).actualPickup;
            if inStr <> *blanks;
             AFSSHIPDds.ACTPICKUP = convertCSVDateToTimestamp(inStr);
            else;
             AFSSHIPDds.ACTPICKUP = *loval;
            endif;

            // 2025-12-29-13.17.53.307000
            // 11/25/2025 2:46:00 PM
            // --- split date & time ---
            inStr = c2(i2).estimatedDelivery;
            if inStr <> *blanks;
             AFSSHIPDds.ESTDELIVER = convertCSVDateToTimestamp(inStr);
            else;
             AFSSHIPDds.ESTDELIVER = *loval;
            endif;

            // 2025-12-29-13.17.53.307000
            // 11/25/2025 2:46:00 PM
            // --- split date & time ---
            inStr = c2(i2).actualDelivery;
            if inStr <> *blanks;
             AFSSHIPDds.ACTDELIVER = convertCSVDateToTimestamp(inStr);
            else;
             AFSSHIPDds.ACTDELIVER = *loval;
            endif;

            AFSSHIPDds.ADDSTAMP = %timestamp();
            AFSSHIPDds.BASETABLE = ECFullPath;

            // write the record
            reset duplicateRecord;
            exec sql
               select 1
                 into :duplicateRecord
                 from AFSSHIPD
                where BRANCH = :AFSSHIPDds.BRANCH
                  and SHIPID = :AFSSHIPDds.SHIPID
                  and PRONUMBER = :AFSSHIPDds.PRONUMBER
                  and REFERENCE = :AFSSHIPDds.REFERENCE
                  and CHARGE = :AFSSHIPDds.CHARGE
                  fetch first 1 row only;

            if not(duplicateRecord);
             exec sql
              insert into AFSSHIPD
              values(:AFSSHIPDds);
            endif;


           endfor;
           exec SQL close WorkCursor2;

           // ------------------------------------------------------
           // move to archive folder
           // MOV OBJ('/home/afs/AFS_Detal_2025-12-26-15.38.55.473319.csv')
           //     TODIR('/home/afs/Archive')
           commandString = 'MOV OBJ('+Q+
            %trim(ECFullPath) +Q+ ') TODIR(' +Q+ '/home/afs/Archive' +Q+ ')';
            OutErrorDS = runIBMCommand(commandString);

          endfor;

          exec SQL close WorkCursor;

          // run command
          commandString = 'AFENDFTP';
          OutErrorDS = runIBMCommand(commandString);

         // Date and time conversion procedure implementation
         dcl-proc convertCSVDateToTimestamp;
           dcl-pi *n timestamp;
             dateTimeStr varchar(50) const;
           end-pi;
           
           dcl-s dateStr varchar(20);
           dcl-s timeStr varchar(20);
           dcl-s month varchar(2);
           dcl-s day varchar(2);
           dcl-s year varchar(4);
           dcl-s hour varchar(2);
           dcl-s min varchar(2);
           dcl-s sec varchar(2);
           dcl-s ampm varchar(2);
           dcl-s slashPos1 int(10);
           dcl-s slashPos2 int(10);
           dcl-s spacePos int(10);
           dcl-s colonPos1 int(10);
           dcl-s colonPos2 int(10);
           dcl-s ampmPos int(10);
           dcl-s isoTimestamp char(26);
           dcl-s hourInt int(10);
           
           monitor;
             // Find main separators
             spacePos = %scan(' ' : dateTimeStr);
             if spacePos = 0;
               return *loval; // Invalid format
             endif;
             
             dateStr = %subst(dateTimeStr : 1 : spacePos - 1);
             timeStr = %subst(dateTimeStr : spacePos + 1);
             
             // Parse date part (MM/DD/YYYY or M/D/YYYY)
             slashPos1 = %scan('/' : dateStr);
             slashPos2 = %scan('/' : dateStr : slashPos1 + 1);
             
             if slashPos1 = 0 or slashPos2 = 0;
               return *loval; // Invalid date format
             endif;
             
             month = %subst(dateStr : 1 : slashPos1 - 1);
             day = %subst(dateStr : slashPos1 + 1 : slashPos2 - slashPos1 - 1);
             year = %subst(dateStr : slashPos2 + 1);
             
             // Pad single digits
             if %len(%trim(month)) = 1;
               month = '0' + %trim(month);
             endif;
             if %len(%trim(day)) = 1;
               day = '0' + %trim(day);
             endif;
             
             // Parse time part (H:MM:SS AM/PM or HH:MM:SS AM/PM)
             colonPos1 = %scan(':' : timeStr);
             colonPos2 = %scan(':' : timeStr : colonPos1 + 1);
             ampmPos = %scan(' ' : timeStr : colonPos2 + 3);
             
             if colonPos1 = 0 or colonPos2 = 0 or ampmPos = 0;
               return *loval; // Invalid time format
             endif;
             
             hour = %trim(%subst(timeStr : 1 : colonPos1 - 1));
             min = %subst(timeStr : colonPos1 + 1 : 2);
             sec = %subst(timeStr : colonPos2 + 1 : 2);
             ampm = %subst(timeStr : ampmPos + 1 : 2);
             
             // Convert to 24-hour format
             hourInt = %int(hour);
             if %upper(ampm) = 'PM' and hourInt < 12;
               hourInt += 12;
             elseif %upper(ampm) = 'AM' and hourInt = 12;
               hourInt = 0;
             endif;
             
             // Pad hour to 2 digits
             if hourInt < 10;
               hour = '0' + %char(hourInt);
             else;
               hour = %char(hourInt);
             endif;
             
             // Pad minutes and seconds if needed
             if %len(%trim(min)) = 1;
               min = '0' + %trim(min);
             endif;
             if %len(%trim(sec)) = 1;
               sec = '0' + %trim(sec);
             endif;
             
             // Build ISO timestamp format (YYYY-MM-DD-HH.MM.SS.000000)
             isoTimestamp = %trim(year) + '-' + %trim(month) + '-' +
                            %trim(day) + '-' + %trim(hour) + '.' +
                            %trim(min) + '.' + %trim(sec) + '.000000';
             
             return %timestamp(isoTimestamp);
             
           on-error;
             return *loval; // Return low value on any error
           endmon;
           
         end-proc;

