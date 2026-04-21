     H   dftactgrp(*no)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - APRCAPINV                                              *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT MINCRON SBC CORP. 2018.                                     *
     F*------------------------------------------------------------------------*
     F*D Import A/P Invoices                                                   *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    importing A/P invoices. automated batch process for CAPTURIS       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF  3116 112924 JJF  Created program                                 *
     F*M ----------------------------------------------------------------------*
     FAPLTINHK  IF   E           K DISK
     F                                     RENAME(APFTINH:APFTINHK)
     FAPLWBTH1  IF   E           K DISK
     F                                     RENAME(APFWBTH:APFWBTH1)
     FAPLWINH1  IF   E           K DISK
     F                                     RENAME(APFWINH:APFWINH1)
      *------------------------------------------------------------------------*

       // -------------- *Plist --------------- Prototypes
     d Main            pr                  extpgm('APRCAPINV')
     d                              100         options( *nopass:*omit )
       // ----------------------- Main procedure interface
     d Main            pi
     d inPath                       100         options( *nopass:*omit )

      *--------------
      * Indicators...
      *--------------

      *----------------------
      * Stand alone fields...
      *----------------------

        dcl-s accountingCentury  zoned(2:0);
        dcl-s accountingMonth  zoned(2:0);
        dcl-s accountingYear  zoned(2:0);
        dcl-s accountingYearMonth  zoned(4:0);
        dcl-s badBody  char(1500) inz;
        dcl-s badBody2  char(1500) inz;
        dcl-s badSubject char(200) inz;
        dcl-s batchError ind inz(*off);
        dcl-s batchNumber zoned(7:0) inz;
        dcl-s body char(1000) inz;
        dcl-s breakMe int(10:0) inz;
        dcl-s capturisAccount zoned(3:0) inz;
        dcl-s capturisAccountError ind inz(*off);
        dcl-s capturisBadCompany ind inz(*off);
        dcl-s capturisInvoice char(30) inz;
        dcl-s capturisInvoiceDate char(8) inz;
        dcl-s capturisInvoiceDateError ind inz(*off);
        dcl-s capturisVendorError ind inz(*off);
        dcl-s char4 char(4) inz;
        dcl-s char30 char(30) inz;
        dcl-s characterCompany char(3) inz;
        dcl-s characterVendor char(6) inz;
        dcl-s commandString char(5000) inz;
        dcl-s commandLength packed(15:5) inz;
        dcl-s company zoned(3:0) inz;
        dcl-s controlNumber zoned(7:0) inz;
        dcl-s decimal23 packed(23:0) inz;
        dcl-s decimal8 zoned(8:0) inz;
        dcl-s defaultCompany zoned(3:0) inz(001);
        dcl-s defaultPath char(80) inz;
        dcl-s emailAddress char(100) inz;
        dcl-s firstOfMonth date inz;
        dcl-s GLCodeLength zoned(3:0) inz;
        dcl-s goodBody  char(500) inz;
        dcl-s goodSubject char(200) inz;
        dcl-s i int(10:0) inz;
        dcl-s i2 int(10:0) inz;
        dcl-s ifsPath char(100) inz;
        dcl-s ifsPathFront char(100) inz;
        dcl-s IFSPathLength int(10:0) inz;
        dcl-s ifsString char(500) inz;
        dcl-s invoiceTotal zoned(9:2) inz;
        dcl-s insertRecordCount int(10:0) inz;
        dcl-s isodate  date inz;
        dcl-s lastOfMonth date inz;
        dcl-s lengthAPNO11 int(10:0) inz;
        dcl-s lengthCapturisInvoice  int(10:0) inz;
        dcl-s maxAllowedLines zoned(4:0) inz(2000);
        dcl-s maxItemLines packed(5:0) inz(1000);
        dcl-s myBranch zoned(3:0) inz;
        dcl-s myCompany zoned(3:0) inz;
        dcl-s myCounter zoned(4:0) inz;
        dcl-s myDefaultBranch zoned(3:0) inz(098);
        dcl-s myDifference zoned(2:0) inz;
        dcl-s myError char(50) inz;
        dcl-s myReturnError char(100) inz;
        dcl-s myShortPath varchar(100) inz;
        dcl-s myTableName varchar(50) inz;
        dcl-s myVendor zoned(6:0) inz;
        dcl-s myWorkVendor zoned(6:0) inz;
        dcl-s negative ind inz(*off);
        dcl-s overMaxAllowedLines ind inz(*off);
        dcl-s outBatchNumber char(7) inz;
        dcl-S PLast Pointer;
        dcl-S PointerToWord Pointer;
        dcl-s pointerValue  pointer;
        dcl-s prodTest char(10) inz;
        dcl-s pruserid char(10) inz;
        dcl-s prUserEmail char(45) inz;
        dcl-s Q char(1) inz('''');
        dcl-s recordTotal zoned(9:2) inz;
        dcl-s rowcount int(10:0) inz;
        dcl-s rowcount2 int(10:0) inz;
        dcl-s start zoned(6:0) inz;
        dcl-s subject char(200) inz;
        dcl-s validCompany ind inz(*off);
        dcl-s vendorIsValid ind inz(*off);
        dcl-s word  varchar(100) inz;
        dcl-s workCapturisAccount zoned(3:0) inz;
        dcl-s workYear zoned(4:0) inz;
        dcl-s workDate zoned(8:0) inz;
        dcl-s workString varchar(80) inz;
        dcl-s vendorNumber zoned(6:0) inz(123456);

        dcl-c CRLF CONST(X'0d25');

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

        dcl-ds accountingPeriod inz;
         dateType zoned(1:0);
         date2 zoned(2:0);
         date4 zoned(4:0);
         date6 zoned(6:0);
         date8 zoned(8:0);
         century zoned(2:0);
         allData zoned(23) samepos(dateType);
        end-ds;

        dcl-ds capturisDS qualified inz;
         account char(15);
         vendor char(15);
         vendorName char(30);
         vendorAccount char(30);
         vendorInvoice char(22);
         capturisInvoice char(22);
         GLAccount char(20);
         serviceDates char(30);
         serviceDescription char(30);
         branchSite zoned(3:0);
         branchSiteName char(30);
         serviceAmount zoned(9:2);
         capturisInvoiceDate char(8);
         invoiceTotal zoned(9:2);
        end-ds;

        dcl-s dataAreaBatch packed(7:0) dtaara('APBTH');

        dcl-ds APPWIPLDS extname('APPWIPL') qualified inz;
        end-ds APPWIPLDS;

        dcl-ds APPWIAPDS extname('APPWIAP') qualified inz;
        end-ds APPWIAPDS;

        dcl-ds APCAPHSTPDS extname('APCAPHSTP') qualified inz;
        end-ds APCAPHSTPDS;

        dcl-ds c1 dim(1000) qualified;
         mypath char(100);
        end-ds c1;

        dcl-ds c2 dim(1000) qualified;
         ifsString char(500);
        end-ds c2;

        dcl-pr formatDate extpgm('OPR2000');
         dcl-parm decimal23 packed(23:0) const;
        end-pr;

        dcl-pr ImportInvoiceBatch extpgm('APR1131');
         dcl-parm invoiceBatch char(7) const;
        end-pr;

        dcl-pr StrTok Pointer ExtProc('strtok');
         iString Pointer Options(*String) Value;
         iSeps Pointer Options(*String) Value;
        end-pr;

        // Retrieve UserID
        Dcl-Pr ECC9996 EXTPGM('ECC9996');
         p_UserID  Char(10);
        End-pr;

        // Retrieve User Email
        dcl-pr ECC9997 EXTPGM('ECC9997');
         p_UserID    Char(10);
         p_UserEmail Char(45);
        end-pr;

        dcl-pr $command extpgm('QCMDEXC');
         command_ char(5000);
         Length_  packed(15:5);
        end-pr;

        *inlr = *on;

        reset insertRecordCount;
        reset myVendor;

        exec sql
        select substr(TBNO03,1,6)
        into :characterVendor
        from  tbpmtbl
        where tbno01 = 'CAPT' and TBNO02 = 'VENDORID';

        // verify that the table being sent is for US.
        // 1st column in table from capturis is our CAPTURIS account number
        // this should match the below or abort
        reset capturisAccount;
        exec sql
        select dec(substr(TBNO03,1,3),3,0)
        into :capturisAccount
        from  tbpmtbl
        where tbno01 = 'CAPT' and TBNO02 = 'CAPACCT';

        myVendor = %dec(%xlate(' ':'0':characterVendor):6:0);

        // pull system from dataarea
        // pull in production or test dataarea
        reset prodTest;
        exec sql
         select data_area_value
         into :prodTest
         from qsys2.data_area_info
          WHERE data_area_name = 'PRODTEST' and
          data_area_library = 'QGPL';

        ECC9996 (prUserId);
        ECC9997 (prUserId:prUserEmail);

        if inpath = *blanks;
         // read thru folder and pull in IFS document(s)
         // will have to move the tables from /home/capturis/in
         // to /home/capturis/in/Archive --or-- /home/capturis/in/Error
         exsr $listIFS;
        else;
         ifsPath = %trim(inPath);
         exsr $set8Fields;
         exsr $processTable;
        endif;

       //----------------------------------------
       // $processTable - process table
       //----------------------------------------

       begsr $processTable;

        reset recordTotal;
        reset invoiceTotal;
        reset capturisInvoice;
        reset capturisInvoiceDate;
        reset insertRecordCount;
        reset capturisAccountError;
        reset capturisVendorError;
        reset capturisBadCompany;
        reset overMaxAllowedLines;
        reset vendorIsValid;
        reset capturisInvoiceDateError;

        exec SQL
        declare  c2 scroll cursor for
         SELECT Line FROM TABLE(QSYS2.IFS_READ(PATH_NAME => trim( :ifsPath)))
        for read only;

        exec SQL open c2;
        //
        exec sql
         fetch first from C2 for :maxItemLines rows into :C2;
        exec sql get diagnostics :rowCount2 = ROW_COUNT;

        // mincron only allows 2000 items if greater than send error
        dow rowCount2 <> 0 and rowCount2 <= maxAllowedLines;
         For i2 = 1 to rowCount2;
          ifsString = c2(i2).ifsString;
          // skip header
          if i2>=2;
           exsr $breakCSV;
          endif;
         endfor;
         exec SQL
          fetch next from C2 for :maxItemLines rows into :C2;
           exec sql get diagnostics :rowCount2 = ROW_COUNT;
        enddo;
        exec SQL close C2;

        // if records written then process;
        select;
         when rowCount2 > maxAllowedLines;
          myError = %trim(%editc(rowCount2:'X')) + ' Greater than ' +
                    %trim(%editc(maxAllowedLines:'X'));
          overMaxAllowedLines = *on;
          exsr $sendMessage;
          reset myError;

         when capturisBadCompany;
          myError = '-Invalid Company in GL Account.';
          exsr $sendMessage;
          reset myError;

         when capturisVendorError;
          myError = '-Table contains invalid Vendor ID.';
          exsr $sendMessage;
          reset myError;

         when capturisAccountError;
          myError = '-ECMD Account Match Error';
          exsr $sendMessage;
          reset myError;

         when i2 > *zeros;

          exsr $writeAPPWIPL;

          if insertRecordCount > *zeros;
           outBatchNumber = %char(batchNumber);
           ImportInvoiceBatch(outBatchNumber);
           // set the control number in History
           reset controlNumber;
           exec sql
            select APNO20
            into :controlNumber
            from APPWIAP
            where APNO17 = :batchNumber
            fetch first row only with NC;

           exec sql
            update APCAPHSTP
             set APCONTROL = :controlNumber
             where APBATCH = :batchNumber;

           myError = *blanks;
           // if there was an issue with a GL account number write but send message
           exsr $sendMessage;
          endif;

        endsl;

       endsr;

       //----------------------------------------
       // $breakCSV - break CSV
       //----------------------------------------

       begsr $breakCSV;

        clear APPWIAPDS;
        // 14 rows on the .csv table
        reset myCounter;
        reset PLast;
        ifsString = %scanrpl(',,':', ,':ifsString);
        PointerToWord = StrTok(ifsString: ',');
        dow PointerToWord <> *Null;
         Word = %trim(%Str(PointerToWord));
         pointerToWord = strtok(*null: ',');

         // added to skip the heading
         myCounter+=1;
         select;
          when myCounter = 1;
           // need to verify that this matched our Table file entry
           // this is 15 *char - because we just dont know  capturisAccount
           capturisDS.account = Word;
           if %check(' 0123456789':
              %trim(%subst(capturisDS.account:1:3))) = *zeros;
            workCapturisAccount =
             %dec(%trim(%subst(capturisDS.account:1:3)):3:0);
            if workCapturisAccount <> capturisAccount;
             capturisAccountError = *on;
            endif;
           endif;

          when myCounter = 2;
           capturisDS.vendor = Word;
           // validate each vendor - char 15
           reset vendorIsValid;
           if %check(' 0123456789':%trim(capturisDS.vendor)) = *zeros;
            characterVendor = %trim(capturisDS.vendor);
            myWorkVendor = %dec(%trim(capturisDS.vendor):6:0);
           endif;
           exec sql
            select '1'
             into : vendorIsValid
            from APPMVEN
            where apno01 = :myWorkVendor and APCD01 = ' ';

            if not(vendorIsValid);
             capturisVendorError = *on;
            endif;
          when myCounter = 3;
           capturisDS.vendorName = Word;
          when myCounter = 4;
           capturisDS.vendorAccount = Word;
          when myCounter = 5;
           capturisDS.vendorInvoice = Word;
          when myCounter = 6;
           capturisDS.capturisInvoice = Word;
           if capturisInvoice = *blanks;
            capturisInvoice = capturisDS.capturisInvoice;
           endif;
          when myCounter = 7;
           capturisDS.GLAccount = Word;
           // validate the company (005-002-03-5040-001)
           reset validCompany;
           characterCompany = %subst(%trim(capturisDS.GLAccount):1:3);
           if %check('0123456789':characterCompany) = *zeros;
            company = %dec(%trim(characterCompany):3:0);
            exec sql
             select '1'
              into :validCompany
              from GLPMHDR
              where glno01 = :company;
           endif;
           if not(validCompany);
            capturisBadCompany = *on;
           endif;

          when myCounter = 8;
           capturisDS.serviceDates = Word;
          when myCounter = 9;
           capturisDS.serviceDescription = Word;

          // branch
          when myCounter = 10;
           char30 = Word;
           if %check(' 0123456789' :char30) = *zeros;
           myBranch =
            %dec(%xlate(' ':'0':%trim(char30)):3:0);
           else;
            reset myBranch;
           endif;

           capturisDS.branchSite = myBranch;

          when myCounter = 11;
           capturisDS.branchSiteName = Word;
          when myCounter = 12;
           workString = Word;
           reset negative;
           if %scan('-':workString) > *zeros;
            negative = *on;
            workString = %scanrpl('-':'':workString);
           endif;
           capturisDS.serviceAmount = %dec(workString:9:2);
           if negative;
            capturisDS.serviceAmount*=-1;
           endif;
           recordTotal+=capturisDS.serviceAmount;

          when myCounter = 13;
           capturisDS.capturisInvoiceDate = Word;
           if capturisInvoiceDate = *blanks;

            // 20241114  must be 11142024
            decimal8 = %dec(capturisDS.capturisInvoiceDate:8:0);

            test(de) *iso  decimal8;
            if not(%error);
             isodate = %date(decimal8:*iso);
             capturisInvoiceDate = %editc(%dec(isoDate:*usa):'X');
            else;
             capturisInvoiceDate = %editc(%dec(%date():*usa):'X');
             capturisInvoiceDateError= *on;
            endif;

           endif;
          when myCounter = 14;
           workString = Word;
           reset negative;
           if %scan('-':workString) > *zeros;
            negative = *on;
            workString = %scanrpl('-':'':workString);
           endif;
           capturisDS.invoiceTotal = %dec(workString:9:2);
           if negative;
            capturisDS.invoiceTotal*=-1;
           endif;

           if not(capturisAccountError) and
              not(capturisVendorError) and
              not(capturisBadCompany) and
              not(overMaxAllowedLines);
            if invoiceTotal = *zeros;
             invoiceTotal = capturisDS.invoiceTotal;
             exsr $writeAPPWIAP_I;
            endif;
            exsr $writeAPPWIAP_G;
            exsr $postHistory;
            insertRecordCount+=1;
           endif;

          endsl;
         enddo;

       endsr;
       //----------------------------------------
       // $writeAPPWIPL- write the record
       //----------------------------------------

       begsr $WriteAPPWIPL;

        clear APPWIPLDS;

        APPWIPLDS.PAPNO17 = batchNumber;
        // batch Date
        APPWIPLDS.PAPMO07 = apmo07;
        APPWIPLDS.PAPDY07 = apdy07;
        APPWIPLDS.PAPCC07 = apcc07;
        APPWIPLDS.PAPYR07 = apyr07;

        // company and branch
        APPWIPLDS.PAPNO15 = myCompany;
        APPWIPLDS.PAPNO16 = *zeros;

        // vendor
        APPWIPLDS.PAPNO01 = myVendor;

        APPWIPLDS.PAPCD26 = 'I';

        APPWIPLDS.PAPFL01 = 'Y';
        APPWIPLDS.PAPCD45 = *blanks;
        APPWIPLDS.PTDCO# = myCompany;
        APPWIPLDS.PTDBR# = myDefaultBranch;

        APPWIPLDS.PAPMO12 = accountingMonth;
        APPWIPLDS.PAPCC12 = accountingCentury;
        APPWIPLDS.PAPYR12 = accountingYear;

        exec sql insert into APPWIPL
          values(:APPWIPLDS);

       endsr;

       //----------------------------------------
       // $writeAPPWIAP_I - detail
       //----------------------------------------

       begsr $writeAPPWIAP_I;

        clear APPWIAPDS;

        // first write the 'I' record;
        APPWIAPDS.APCD80 = 'I';
        APPWIAPDS.APNO15 = myCompany;
        APPWIAPDS.APNO16 = myDefaultBranch;
        APPWIAPDS.APNO01 = myVendor;
        APPWIAPDS.APNO35 = *zeros;

        // invoice number 22 *char - needs to be right justified
        lengthCapturisInvoice = %len(%trim(CapturisInvoice));
        lengthAPNO11 = %len(APPWIAPDS.APNO11);
        myDifference = (lengthAPNO11 - lengthCapturisInvoice);
        myDifference+=1;

        if lengthCapturisInvoice > *zeros;
         %subst(APPWIAPDS.APNO11:myDifference:lengthCapturisInvoice) =
           %trim(capturisInvoice);
        endif;

        APPWIAPDS.APDT01 = capturisInvoiceDate;
        APPWIAPDS.APAM04 = invoiceTotal;
        APPWIAPDS.APAM13 = *zeros;
        APPWIAPDS.APAM26 = *zeros;

        select;
         when invoiceTotal > *zeros;
          APPWIAPDS.APCD26 = 'I';
         other;
          APPWIAPDS.APCD26 = 'C';
        endsl;

        // once there is a vendor this needs to follow terms
        APPWIAPDS.APDT02 = capturisInvoiceDate;

        APPWIAPDS.APPC01 = *zeros;
        APPWIAPDS.APCD16 = 'Y';

        // glcode needs to be "adjusted"
        APPWIAPDS.GLNO06 = *zeros;
        APPWIAPDS.GLNO02 = *zeros;
        APPWIAPDS.GLNO03 = *zeros;
        APPWIAPDS.GLNO04 = *zeros;

        APPWIAPDS.APFL01 = 'Y';
        // Notes
        APPWIAPDS.APTX01 = *blanks;

        APPWIAPDS.APNO17 = batchNumber;
        APPWIAPDS.APNO20 = *zeros;
        // process stamp this must be *blanks to be read in APDT03
        APPWIAPDS.APDT03 = *blanks;
        // update stamp
        APPWIAPDS.APDT04 = *blanks;
        APPWIAPDS.APTX07 = *blanks;

         exec sql insert into APPWIAP
           values(:APPWIAPDS);

       endsr;

       //----------------------------------------
       // $writeAPPWIAP_G - detail
       //----------------------------------------

       begsr $writeAPPWIAP_G;

        clear APPWIAPDS;

        // first write the 'G' record;
        APPWIAPDS.APCD80 = 'G';
        APPWIAPDS.APNO15 = *zeros;
        APPWIAPDS.APNO16 = *zeros;
        APPWIAPDS.APNO01 = *zeros;
        APPWIAPDS.APNO35 = *zeros;
        APPWIAPDS.APNO11 = *blanks;
        APPWIAPDS.APDT01 = *blanks;
        APPWIAPDS.APAM04 = capturisDS.serviceAmount;
        APPWIAPDS.APAM13 = *zeros;
        APPWIAPDS.APAM26 = *zeros;
        APPWIAPDS.APCD26 = *blanks;
        APPWIAPDS.APDT02 = *blanks;

        APPWIAPDS.APPC01 = *zeros;
        APPWIAPDS.APCD16 = 'Y';

        // 001-200-00-6020-000 --> capturisDS.GLAccount
        // Gl account breakDown - should be 19

        // invalid code -- set to *zeros so it fails
        GLCodeLength = %len(%trim(capturisDS.GLAccount));
        if GLCodeLength <> 19 or
           %scan('-':capturisDS.GLAccount) = *zeros;
         APPWIAPDS.GLNO06 = *zeros;
         APPWIAPDS.GLNO02 = *zeros;
         APPWIAPDS.GLNO03 = *zeros;
         APPWIAPDS.GLNO04 = *zeros;
        else;
         APPWIAPDS.GLNO06 =
          %dec(%xlate(' ':'0':%subst(capturisDS.GLAccount:5:3)):3:0);  //2

         APPWIAPDS.GLNO02 =
          %dec(%xlate(' ':'0':%subst(capturisDS.GLAccount:9:2)):2:0);  //2

         APPWIAPDS.GLNO03 =
          %dec(%xlate(' ':'0':%subst(capturisDS.GLAccount:12:4)):4:0); //4

         APPWIAPDS.GLNO04 =
          %dec(%xlate(' ':'0':%subst(capturisDS.GLAccount:17:3)):3:0); //3

        endif;

        APPWIAPDS.APFL01 = *blanks;
        // Notes
        APPWIAPDS.APTX01 = %trim(capturisDS.vendorName) + ' : ' +
                           %trim(capturisDS.serviceDates);

        APPWIAPDS.APNO17 = batchNumber;
        APPWIAPDS.APNO20 = *zeros;
        // process stamp
        APPWIAPDS.APDT03 = *blanks;
        // update stamp
        APPWIAPDS.APDT04 = *blanks;
        APPWIAPDS.APTX07 = *blanks;

         exec sql insert into APPWIAP
           values(:APPWIAPDS);

       endsr;

       //----------------------------------------
       // $set8Fields - set 8 fields
       //----------------------------------------
       begsr $set8Fields;

        // Batch Number
        reset batchNumber;
        in *lock dataAreaBatch;
        dou not %found();
         dataAreaBatch+=1;
         batchNumber = dataAreaBatch;
         setll (batchNumber) APLTINHK;
         if not %found(APLTINHK);
          setll (batchNumber) APLWINH1;
          if not %found(APLWINH1);
           setll (batchNumber) APLWBTH1;
           if not %found(APLWBTH1);
            out dataAreaBatch;
            leave;
           endif;
          endif;
         endif;
        enddo;

        isodate= %date();
        apdy07 = %subdt(isodate:*days);
        apmo07 = %subdt(isodate:*months);
        workYear = %subdt(isodate:*years);
        char4 = %char(workYear);
        apyr07 = %dec(%subst(char4:3:2):2:0);
        apcc07 = %dec(%subst(char4:1:2):2:0);

        // grab company
        reset characterCompany;
        exec sql
         select
         coalesce(substr(tbno03,4,3),' ')
         into :characterCompany
         from tbpmtbl
         where tbno01 = 'TIDS' and tbno02 = :psds.jobuser;
        if characterCompany <> *blanks;
         myCompany = %dec(characterCompany:3:0);
        else;
         myCompany = defaultCompany;
        endif;

        // Accounting MM/YY
        reset accountingMonth;
        reset accountingYear;
        reset accountingCentury;

        // verify that the apfl02 = *blanks (bank open)
        exec sql
         select apmo17, apyr17, apcc17
          into :accountingMonth, :accountingYear, :accountingCentury
          from APPMBNK
          where  APNO15  = :myCompany and APFL02 = 'N'
          fetch first row only with NC;

        if accountingMonth = *zeros;
        else;
         if accountingMonth = 12;
          accountingMonth = 1;
          accountingYear+=1;
         else;
          accountingMonth +=1;
         endif;
        endif;

        char4 = %editc(accountingYear:'X') +
                %editc(accountingMonth:'X');

        accountingYearMonth = %dec(char4:4:0);
        clear allData;
        date4 = accountingYearMonth;
        dateType = 3;
        decimal23 = allData;
        // PM2000 = 30024102024100000000020.
        formatDate(decimal23);
        allData = decimal23;

        // grab the IFS path
        // table file is always upper :(
        // /HOME/CAPTURIS/IN/
        reset ifsPathFront;
        exec sql
        select TBNO03
        into :ifsPathFront
        from  tbpmtbl
        where tbno01 = 'CAPT' and TBNO02 = 'IFSPATH';

        IFSPathLength = %len(%trim(ifsPathFront));

       endsr;

       //----------------------------------------
       // $listIFS - list IFS
       //----------------------------------------

       begsr $listIFS;

        exec SQL
        declare  c1 scroll cursor for
         sELECT char(PATH_NAME,100)
         FROM TABLE(QSYS2.IFS_OBJECT_STATISTICS(
         '/home/capturis/in/','NO','*ALLSTMF'))
        for read only;

        exec SQL open c1;
        //
        exec sql
         fetch first from C1 for :maxItemLines rows into :C1;
        exec sql get diagnostics :rowCount = ROW_COUNT;
        dow rowCount <> 0;
         For i = 1 to rowCount;
          ifsPath = c1(i).myPath;
          exsr $set8Fields;
          exsr $processTable;
         endfor;
         exec SQL
          fetch next from C1 for :maxItemLines rows into :C1;
           exec sql get diagnostics :rowCount = ROW_COUNT;
        enddo;
        exec SQL close C1;

       endsr;

       //---------------------------------------------
       // $postHistory - post history records
       //---------------------------------------------

       begsr $postHistory;

        reset APCAPHSTPDS;

        APCAPHSTPDS.APCAPINV   =  capturisDS.capturisInvoice;       // Capturis Invoice
        // Do not continue if this invoice is already written

        APCAPHSTPDS.APCAPACT = capturisDS.account;               // Capturis Account

        // vendor ID MINCRON = 6
        if %check(' 0123456789': capturisDS.vendor) = *zeros;
         capturisDS.vendor = %editc(%dec(%trim(capturisDS.vendor):6:0):'X');
        endif;
        APCAPHSTPDS.APVENDOR   =  capturisDS.vendor;                // Vendor Id

        APCAPHSTPDS.APVENDORNM =  capturisDS.vendorName;            // Vendor Name
        APCAPHSTPDS.APVENDACCT =  capturisDS.vendorAccount;         // Vendor Account
        APCAPHSTPDS.APVENDINV  =  capturisDS.vendorInvoice;         // Vendor Invoice

        APCAPHSTPDS.APGLACCT   =  capturisDS.GLAccount;             // Gl Account String

        // break these into from and to dates
        // 11/01/2024-11/30/2024
        APCAPHSTPDS.APSRVDAT   =  capturisDS.serviceDates;          // Service Dates
        char30 = %trim(APCAPHSTPDS.APSRVDAT);
        breakMe = %scan('-':char30);
        if breakMe > *zeros;
         workDate = %dec(%scanrpl('/':'':%subst(char30:1:breakme-1)):8:0);
         test(de) *usa  workDate;
         if not(%error);
          isoDate = %date(workDate:*usa);
          APCAPHSTPDS.APSRVFRM   =  isodate;          // Service Date From
         else;
          APCAPHSTPDS.APSRVFRM   = %date();           // Service Date From
         endif;

         workDate = %dec(%scanrpl('/':'':%subst(char30:breakme+1:10)):8:0);
         test(de) *usa  workDate;
         if not(%error);
          isoDate = %date(workDate:*usa);
          APCAPHSTPDS.APSRVTO = isodate;          // Service Date To
         else;
          APCAPHSTPDS.APSRVTO = %date();          // Service Date To
         endif;
        else;
         // set the dates to *Loval
          APCAPHSTPDS.APSRVFRM = *Loval;           // Service Date From
          APCAPHSTPDS.APSRVTO = *loval;            // Service Date To
        endif;

        APCAPHSTPDS.APSRVDESC  =  capturisDS.serviceDescription;    // Service Description

        // branch = 3
        APCAPHSTPDS.APBRSITE   =  capturisDS.branchSite;            // Branch Service

        APCAPHSTPDS.APBRSITENM =  capturisDS.branchSiteName;        // Branch Site/name
        APCAPHSTPDS.APSRVAMT   =  capturisDS.serviceAmount;         // Serice Amount

        // 20241114  must be 11142024
        decimal8 = %dec(capturisDS.capturisInvoiceDate:8:0);
        test(de) *iso  decimal8;
        if not(%error);
         isodate = %date(decimal8:*iso);
         APCAPHSTPDS.APINVDAT = isoDate;
        else;
         APCAPHSTPDS.APINVDAT = %date();
        endif;

        reset firstOfMonth;
        exec sql
         SET :firstOfMonth = FIRST_DAY(DATE(:APCAPHSTPDS.APINVDAT));

        reset lastOfMonth;
        exec sql
         SET :lastOfMonth = LAST_DAY(DATE(:APCAPHSTPDS.APINVDAT));

        APCAPHSTPDS.APINVTOTP  =  capturisDS.invoiceTotal;          // Invoice Total
        APCAPHSTPDS.APRECSTMP  =  %timestamp();                     // Receive Stamp

        APCAPHSTPDS.APCONTROL   = *zeros;                            // control Nbr from APPWIAP
        APCAPHSTPDS.APBATCH  = batchNumber;                          // batch  Number

        APCAPHSTPDS.APIFSLINK   = ifsPath;                           // IFS Table Name

        // stop date issues
        if APCAPHSTPDS.APSRVFRM = *loval;
         APCAPHSTPDS.APSRVFRM = firstOfMonth;
        endif;

        if APCAPHSTPDS.APSRVTO = *loval;
         APCAPHSTPDS.APSRVTO = lastOfMonth;
        endif;


        exec sql insert into APCAPHSTP
          values(:APCAPHSTPDS);

       endsr;

       //---------------------------------------------
       // $sendmessage - indicate process completion
       //---------------------------------------------

       begsr $sendMessage;


        reset controlNumber;
        exec sql
         select APNO20
           into :controlNumber
          from APPWIAP
          where APNO17 = :batchNumber
          and APNO20 <> 0;

        reset batchError;
        reset myReturnError;
        exec sql
         select '1', Aptx07
           into :batchError, : myReturnError
          from APPWIAP
          where APNO20 = :controlNumber
          and aptx07 <> ' ';
        if batchError;
         myError = myReturnError;
        endif;

        goodSubject =
         'Capturis AP Invoice Batch#:' +
          %editc(batchNumber:'X') + ' ' +
         'ready for your approval.';

        goodBody = 'The batch is ready for your review and subsequent posting.'+
        ' If you have any questions, please reach out to the IT Helpdesk at ' +
        'itdept@ecmdi.com';

        badSubject =
         'Capturis AP Invoice#:'       +
          %trim(capturisInvoice) + ' ' +
         'has ERRORS.';

        badBody =
         'Utilize menu APM Option 24 and enter M to maintain the invoice.' +
         ' Correct the error and press F10 to update.' +
         ' Then take option 23 Import Invoices and attempt the process again.' +
         ' Verify that the import worked by checking for AP Batch needing '+
         'to be posted or APM Opt 24 again and see if the invoice is still ' +
         'in error. ' + %trim(myError);


        badBody2 =
         'There has been an error processing this batch.  Please contact ' +
         'IT for next steps. ' + %trim(myError);

        // pull in production or test dataarea
        reset prodTest;
        exec sql
         select data_area_value
         into :prodTest
         from qsys2.data_area_info
          WHERE data_area_name = 'PRODTEST' and
          data_area_library = 'QGPL';

        select;
         when prodtest = 'PROD';
          emailAddress = 'apdept@ecmdi.com';
         when prodtest = 'TEST';
          emailAddress = prUserEmail;
          goodSubject = 'Test_' + %trim(goodSubject);
          badSubject = 'Test_' + %trim(badSubject);
        endsl;

        // check status of this import
        // control number APNO20
         // no error on this batch
         select;
          when batchError;
           subject = badSubject;
           body = badBody;
          when capturisAccountError or
               capturisVendorError or
               capturisBadCompany or
               overMaxAllowedLines;
           subject = badSubject;
           body = badBody2;
           batchError = *on;
          when not(batchError);
           subject = goodSubject;
           body = goodBody;

         endsl;


         // additional Global messages
         select;
          when capturisInvoiceDateError;
           body = %trim(Body) +
            ' *NOTE:Invalid Invoice date send/Changed to today.';
         endsl;


         commandString = 'MAILTOOL TOADDR(' + %trim(emailAddress) +
          ') FROMADDR(itdept@ecmdi.com)' +
          ' SUBJECT(' + Q + %trim(subject) +
          Q + ')' +
          ' MESSAGE(' + Q + %trim(body) + Q + ')' +
          ' ATTACH(' + Q + %trim(ifsPath) + Q + ')';
          commandLength = %len(%trim(commandString));
           monitor;
            $command(commandString: commandLength);
           on-error;
          endmon;

        // move the table
        // "/home/capturis/in/GLfifthTest_2024-11-29-11.19.05.113021.csv"
        // IFSPATHLENGTH = 17
        reset myTableName;
        if ifsPathLength > *zeros;
         myShortPath = %trim(%subst(IfsPath:1:ifsPathLength));
         myTableName = %trim(%subst(IfsPath:ifsPathLength+2));
        endif;

        // no error on this batch
        select;
         when batchError;
          myShortPath = %trim(myShortPath) + '/Error/' + %trim(myTableName);
         when not(batchError);
          myShortPath = %trim(myShortPath) + '/Archive/' + %trim(myTableName);
        endsl;

         // if table with same name delete prior to move
         // DEL OBJLNK('/home/capturis/test.csv')
         commandString = 'DEL  OBJLNK(' +Q+ %trim(myShortPath) +Q+ ')';
         commandLength = %len(%trim(commandString));
          monitor;
           $command(commandString: commandLength);
          on-error;
         endmon;


         // MOV OBJ(&FILEPATH) TOOBJ(&NEWFILEPATH)
         commandString = 'MOV  OBJ(' +Q+ %trim(IfsPath) +Q+ ') TOOBJ(' +Q+
          %trim(myShortPath) +Q+ ')';
         commandLength = %len(%trim(commandString));
          monitor;
           $command(commandString: commandLength);
          on-error;
         endmon;

       endsr;

       //----------------------------------------
