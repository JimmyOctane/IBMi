¢A     CTL-OPT option(*srcstmt:*nodebugio) Debug(*yes) dftactgrp(*no);
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - BOALOCKBOX                                             *
     F*------------------------------------------------------------------------*
     F*P                                                                       *
     F*------------------------------------------------------------------------*
     F*D         Send daily receiver table                                     *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3060 012524 JJF Created program                                 *
     F*M ----------------------------------------------------------------------*

      *=======================================================================
     F********************************************************************
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
     d bigString       s          20000    inz varying
     d CR              c                   const(X'0d')
     d CRLF            c                   const(X'0d25')
     d emailAddress    s             50    inz
     d foundTable1     s               n   inz
     d i               s             10i 0 inz
     d maxItemLines    s              5P 0 inz(900)
     d mySQLStmt       s            500    inz
     d ObjectIFSPath   s            100    inz varying
     d ProdTest        s             10    inz
     d Q               s              1    inz('''')
     d rowcount        s             10i 0 inz
     d SQLIFSPath      s            100    inz
      ** ½¾
      *
       // -----------------------------------------------------------------
       // Entry parameter list prototype and declaration
       // -----------------------------------------------------------------
       // -------------- *Plist --------------- Prototypes
     d Main            pr                  extpgm('ARR1200')
       // ----------------------- Main procedure interface
     d Main            pi
       // --------------------- Prototypes --------------------

     d c1              ds                  dim(900) qualified
     d  bigField                    500

              exec sql  set option commit=*none,datfmt=*iso,
                            closqlcsr=*ENDMOD;

              *inlr = *on;

         exec SQL
          declare  C1 scroll cursor for
          SELECT Line FROM TABLE(QSYS2.IFS_READ(PATH_NAME =>
            '/home/nfi/in/945_Out_20240918095811170.JSON'))
           for read only;

         exec SQL open C1;
         exec sql fetch first from C1 for :maxItemLines rows into :C1;
         exec sql get diagnostics :rowCount = ROW_COUNT;

         dow rowCount <> 0;
          for i = 1 to rowCount;
             bigString += %trim(c1(i).bigField);
             bigString= %xlate('½':CR:bigString);
             bigString= %xlate('½¾':CRLF:bigString);
          endfor;
          exec SQL
          fetch next from C1 for :maxItemLines rows into :C1;
          exec sql get diagnostics :rowCount = ROW_COUNT;
         enddo;
         exec SQL close C1;


         exec sql drop table jflanary.json;

         exec sql
          create table jflanary.json
          (fullString CHAR(7000)  NOT NULL DEFAULT '');

         exec sql insert into jflanary.json
           values(:bigString);

