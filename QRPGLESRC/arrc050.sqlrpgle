       //-------------------------------------------------------------------
       // PROGRAM NAME - ARRC050
       //
       //  Add Draw to Employees Designated to Receive Draw $$
       //
       //-------------------------------------------------------------------
       // TASK       DATE   ID  DESCRIPTION
       //---------- ------ --- ---------------------------------------------
       // 5152      070225 CLP Initial pgm
       //-------------------------------------------------------------------
       CTL-OPT option(*srcstmt:*nodebugio) Debug(*yes);

       DCL-F ARPCDRAWD Disk
             keyed
             Usage(*input);

       DCL-F ARPCDRAW$ Disk
             keyed
             Usage(*input:*output);

        //------------------------------------------------------------
        // Field definitions
        //------------------------------------------------------------
           Dcl-s Mo            packed(2:0) inz;
           Dcl-s CC            packed(2:0) inz;
           Dcl-s Yr            packed(2:0) inz;
           Dcl-s Co            packed(3:0) inz;
           Dcl-s i             int(10:0) inz;
           Dcl-s LastDrawPP    like(DRAWPP) inz;
           Dcl-s maxItemLines  packed(5:0) inz(10000);
           Dcl-s rowcount      int(10:0) inz;
           Dcl-s WorkDate      char(26) inz;
           Dcl-s Today         Date(*iso);

       // -----------------------------------------------------------------
       // Entry parameter list prototype and declaration
       // -----------------------------------------------------------------
          Dcl-pr main extpgm('ARRC050');
           prCo        Char(10);
           prDate      Char(10);
          End-pr;

          Dcl-pi main;
           piCo        Char(10);
           piDate      Char(10);
          End-pi;

       // -----------------------------------------------------------------
       // Data Structures
       // -----------------------------------------------------------------
          Dcl-ds sqlDS qualified;
           ReturnedSqlCode   char(5);
           ReturnedSQLState  char(5);
           MessageLength int(5:0);
           MessageText char(32740);
           MessageId1 char(10);
           MessageId2 varchar(7);
           MessageId3 varchar(7);
          End-ds;

       // Employee data structure
          Dcl-Ds C1 dim(10000) Qualified Inz;
           opno12     char(10);
          End-Ds;

        //------------------------------------------------------------
        //  Main Process
        //------------------------------------------------------------
          Co = %dec(piCo:3:0);

        // If a date is passed in use that date instead of today's date
        If piDate <> *blanks;
          Test(DE) *iso piDate;
          If %error;
            *inLR = *on;
            Return;
          Endif;
          Today = %date(piDate:*iso);
        Else;
          Today = %date();
        Endif;

        // Determine if today is a payroll draw date
          Chain (Today) ARPCDRAWD;
          If not %found;
            *inLR = *on;
            Return;
          Endif;

        // Extract month and year from the draw date
        Mo = %subdt(Today:*months);
        Yr = %dec(%subst(%Char(%subdt(Today:*years)):3:2):2:0);
        CC = %dec(%subst(%Char(%subdt(Today:*years)):1:2):2:0);
      //workYear = %subdt(Today:*years);
      //char4 = %char(workYear);

        // If today is a draw payroll date, add draw to active employees
        //  designated to receive draw dollars; otherwise, bail out

        Exec SQL close C1;
        Exec SQL
          Declare C1 scroll cursor for
          Select $.opno12
           From ARPCDRAW$ $ inner join ARPMSLX x on $.opno12 = x.opno12
            inner join ARPMSLS s on x.arid01=s.arid01
            inner join arpcdrawd d on :Today=d.drawdate
            Where $.arno15 = :Co and $.trantype = 'PPD MNT' and
             s.arfl15<>'C' and (x.cmmo13=0 or
             digits(x.cmcc13)||digits(x.cmyr13)||'-'||digits(x.cmmo13)||'-'||
             digits(x.cmdy13)>d.ppbegin) and
             not exists(Select * from ARPCDRAW$ where opno12=$.opno12 and
             trantype='PPD $$' and cast(trandate as date)=:Today)
            Group by $.opno12
            Order by $.opno12
            for read only;

          Exec SQL open C1;
          Exec sql fetch first from C1 for :maxItemLines rows into :C1;
          Exec sql get diagnostics :rowCount = ROW_COUNT;

          Dow rowCount <> 0;
           For i = 1 to rowCount;

          // Retrieve the last pay period draw amount for the employee
             Reset DRAWPP;
             Chain (Co:C1(i).opno12) ARPCDRAW$;

             // Add the new employee draw record
             If DRAWPP > 0;
               Clear ARID01;
               TRANTYPE = 'PPD $$';
               WorkDate = %char(Today) + '-06.00.00.000001';
               TRANDATE = %timestamp(WorkDate);

               If ARMO01 = Mo and ARYR01 = Yr;
                 DRAW$ = DRAW$ + DRAWPP;
               Else;
                 DRAW$ = DRAWPP;
               ENDIF;

               Clear COMM$;
               Clear COMMDUE;
               DRAWBAL = DRAWBAL + DRAWPP;
               ARMO01 = Mo;
               ARCC01 = CC;
               ARYR01 = Yr;
               Write ARFCDRAW$;
             Endif;

           Endfor;

           Exec SQL
           Fetch next from C1 for :maxItemLines rows into :C1;
           Exec sql get diagnostics :rowCount = ROW_COUNT;

          Enddo;
          Exec SQL close C1;

        *inlr = *On;
        Return;
