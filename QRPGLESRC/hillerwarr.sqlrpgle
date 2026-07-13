       //-------------------------------------------------------------------
       // PROGRAM NAME - HILLERWARR
       //
       //  Hiller No Charge Warranty Analysis
       //
       //-------------------------------------------------------------------
       // TASK       DATE   ID  DESCRIPTION
       //---------- ------ --- ---------------------------------------------
       // 6909      060420 CLP Initial pgm
¢A     // 6931      111020 CLP -Remove bad VndRtn and VRSts data when there
¢A     //                       is no claim#
¢A     //                      -Added logic to drop invoices and their
¢A     //                       related credit memos that are no chg lines
¢A     //                       that come to zero that have a paid vendor
¢A     //                       return
¢B     // 6933      112020 CLP Added HILLERNC file to store the resolved
¢B     //                       invoices that can be removed from the report
¢C     // 5052      111922 CLP -Corrected update SQLs to avoid issues with
¢C     //                        selection results having multiple rows
¢C     //                       -Deleted obsolete code for legibility
¢D     // 5103      070324 CLP  Updated SQLs to avoid CSID issues with
¢D     //                       CPYTOIMPF process
¢E     // 5133      021825 CLP  -Added sell branch to the report
¢E     //                       -Renamded ship branch from BRANCH to SHIPBR
¢F     // 3209      062426 JJF  -Removed QTEMP table, using HD1100pd version
       //-------------------------------------------------------------------
       CTL-OPT option(*srcstmt:*nodebugio) Debug(*yes);

       // Program Error Monitor error capture
       Dcl-Pr Log_Captured EXTPGM('UTRG9088'); //
              @PgmNme Char(10);
              @LinNum Char(8);
              @PgmLib Char(10);
              @Errmsg Char(10);
              @Job    Char(10);
              @User   Char(10);
              @JobNum Char(6);
              @EmlTyp Char(1);
       End-pr;

       Dcl-s EmlTyp     Char(1) Inz('S');    // Send email any time

       // Job Attributes
       Dcl-Ds PgmSDS PSDS Qualified;
          @@PgmNme      *PROC;                    // Procedure name
          @@LinNum      Char(8)   Pos(21);        // Pgm Line Num
          @@PgmLib      Char(10)  Pos(81);
          @@Errmsg      Char(70)  Pos(91);        // Error Menssage
          @@Job         Char(10)  Pos(244);       // Job Name
          @@User        Char(10)  Pos(254);       // Job User
          @@JobNum      Char(6)   Pos(264);       // Job Number (character
          @@CurrUser    Char(10)  Pos(358);       // Current User Profile
       End-Ds;

        //------------------------------------------------------------
        //  Main Process
        //------------------------------------------------------------

          Monitor;

       // Insert WARR invoices and OE CMs
¢C       Exec Sql
¢C         Insert into HILLERWAR1
¢C ¢E      //(Select h.oeno01,h.oeno01,h.oeno06,l.oeno16,h.oeno07,h.oecd04,
¢E           (Select h.oeno01,h.oeno01,h.oeno06,l.oeno16,l.oeno08,h.oeno07,
¢E             h.oecd04,
¢D             cast(digits(oemo01)||'/'||digits(oedy01)||'/'||digits(oeyr01)
¢D             as char(8)),
¢C             h.oefl31,h.oeno14,h.arno01,c.arnm01,i.ivno04,i.ivno07,i.ivdn01,
¢D             l.oeqy03,0,l.oeam38,l.oecd43,l.oeam05,h.oetl02,l.oeno69,
¢D             cast(' ' as char(10)),cast(' ' as char(10)),
¢D             cast('0' as dec(7,0)),cast(' ' as char(10)),cast(' ' as char(50))
¢C            From oeptohy h inner join oeptoly l on h.oeno01=l.oeno01
¢C             inner join arpmcus c on h.arno01=c.arno01
¢C             inner join ivpmstr i on l.ivno07=i.ivno07
¢C        Where h.arno01in ( 750503, 487413) and h.oeno06='WARR ' and
¢C             l.ivno07<>0 and
¢C             i.ivno05=14141 and (h.oecd08<>'C' or (h.oecd08='C' and
¢C             h.oefl31<>'Y'))
¢C            Order by h.oeno01,l.ivno07);

       // Insert RGA credit memos
¢C       Exec Sql
¢C         Insert into HILLERWAR1
¢C ¢E      //(Select h.oeno14,h.oeno01,h.oeno06,l.oeno16,h.oeno07,h.oecd04,
¢E           (Select h.oeno14,h.oeno01,h.oeno06,l.oeno16,l.oeno08,h.oeno07,
¢E             h.oecd04,
¢D             cast(digits(oemo01)||'/'||digits(oedy01)||'/'||digits(oeyr01)
¢D             as char(8)),
¢C             oefl31,h.oeno14,h.arno01,c.arnm01,i.ivno04,i.ivno07,i.ivdn01,
¢D             l.oeqy03,0,l.oeam38,l.oecd43,l.oeam05,h.oetl02,l.oeno69,
¢D             cast(' ' as char(10)),cast(' ' as char(10)),
¢D             cast('0' as dec(7,0)),cast(' ' as char(10)),cast(' ' as char(50))
¢C            From oeptohy h inner join oeptoly l on h.oeno01=l.oeno01
¢C             inner join arpmcus c on h.arno01=c.arno01
¢C             inner join ivpmstr i on l.ivno07=i.ivno07
¢C        Where h.arno01=in ( 750503, 487413) and h.oeno06='WARR ' and
¢C             l.ivno07<>0 and
¢C             i.ivno05=14141 and h.oecd08='C' and oefl31='Y'
¢C            Order by h.oeno01,l.ivno07);

       // Update claim# and status
¢C         Exec Sql
¢C           Update HILLERWAR1 l set (Claim#,ClaimSts)=
¢C            (Select cmnoa2,cmtx09 from oeptwch where opno28=l.RtnAuth
¢C            fetch first 1 rows only)
¢C           Where exists (Select * from oeptwch where opno28=l.RtnAuth);

¢A       Exec Sql
¢A         Update HILLERWAR1 l set
¢A          VndRtn=(Select pono27 from poptvrh where pono30=l.Claim# and
¢A          pono30<>' '
¢A          fetch first row only)
¢A         Where exists (Select * from poptvrh where pono30=l.Claim# and
¢A          pono30<>' ');


¢C       Exec Sql
¢C         Update HILLERWAR1 l set
¢C          VRSts=(Select pocd37 from poptvrh where pono30=l.Claim# and
¢C          l.Vndrtn<>'0'
¢C          fetch first row only)
¢C         Where exists (Select * from poptvrh where pono30=l.Claim# and
¢C          l.Vndrtn<>'0');

¢C       Exec Sql
¢C         Update HILLERWAR1 l set
¢C          VRSts=(Select i.apcd11 from poptvrh h inner join apptinm v
¢C          on h.pono27=v.pono27
¢C          inner join apptinh i
¢C          on v.apno20=i.apno20 where h.pono30=l.Claim# and
¢C          l.VndRtn<>'0'
¢C          fetch first row only)
¢C         Where exists (Select * from poptvrh h inner join apptinm v
¢C          on h.pono27=v.pono27
¢C          inner join apptinh i
¢C          on v.apno20=i.apno20 where h.pono30=l.Claim# and
¢C          l.VndRtn<>'0');

       // Update the various status fields
         Exec Sql
           Update HILLERWAR1 l set
            Status='Invoiced'
           Where status='I';

         Exec Sql
           Update HILLERWAR1 l set
            Status='Pending'
           Where status='N';

         Exec Sql
           Update HILLERWAR1 l set
            Status='Open'
           Where status='O';

         Exec Sql
           Update HILLERWAR1 l set
            Status='Reviewed'
           Where status='R';

         Exec Sql
           Update HILLERWAR1 l set
            VRSts='Paid'
           Where VRSts='P';

         Exec Sql
           Update HILLERWAR1 l set
            VRSts='Shp Confrm'
           Where VRSts='S';

       // Summarize item qtys by invoice
         Exec Sql
           Update HILLERWAR1 l set invsum=
            (Select sum(qty) from HILLERWAR1
              where invoice=l.invoice and item=l.item
              group by item,invoice
              order by item,invoice);
¢A
¢A     // Drop invoices and related credits that are no chg that come to zero and
¢A     //  have a paid vendor return
¢A
¢A       // Delete the temporary tables
¢A        // Exec SQL
¢A        //   Drop table qtemp/TmpInvSum;
¢F         Exec SQL
¢F          delete from TmpInvSum;
¢A
¢A ¢F      // Summarize invoices and credit memos
¢A ¢F      // Exec SQL
¢A ¢F      //   Create table qtemp/TmpInvSum as
¢A ¢F      //    (Select invoice,nochg,
¢A ¢F      //     cast(0 as dec(11,2)) as sumext,
¢A ¢F      //     cast(' ' as char(10)) as vrsts
¢A ¢F      //     from hillerwar1)
¢A ¢F      //   Definition only;
¢A
¢A         Exec SQL
¢A ¢F      //  Insert into Qtemp/TmpInvSum
¢F              Insert into TmpInvSum
¢A             (Select invoice,nochg,
¢A              cast(sum(lineext) as dec(11,2)),' '
¢A              from hillerwar1
¢A              where nochg='Y' and status='Invoiced'
¢A              group by invoice,nochg
¢A              order by invoice,nochg);
¢A
¢A       // Update the vendor status in the invoice summary file
¢A         Exec SQL
¢A ¢F      //Update Qtemp/TmpInvSum q set vrsts='Paid'
¢F          Update TmpInvSum q set vrsts='Paid'
¢A           Where exists (Select * from hillerwar1 where invoice=q.invoice and
¢A            vrsts='Paid');
¢A
¢A       // Delete invoices and credit lines that do not come to zero or
¢A       //  have not been paid
¢A         Exec SQL
¢A ¢F       //  Delete from Qtemp/TmpInvSum
¢F            Delete from TmpInvSum
¢A           Where sumext<>0 or vrsts<>'Paid';
¢A
¢A       // Delete invoices and credit lines from the original list that have
¢A       //  been completed successfully
¢A         Exec SQL
¢A          Delete from HILLERWAR1 h
¢A           Where exists (Select * from TmpInvSum
¢A            where invoice=h.invoice);
¢B
¢B       // Delete invoices and credit lines from the original list that have
¢B       //  been identified in HILLERNC as resolved
¢B         Exec SQL
¢B           Delete from HILLERWAR1 h
¢B           Where exists (Select * from HILLERNC
¢B            where invoice=h.invoice and trans#=h.trans# and
¢B            item=h.item);

       // Generate the report
         Exec Sql
           Insert into HILLERWARR
            (Select * from HILLERWAR1
             Order by ShipBr,Item,Invoice,Trans#);

          On-Error;

             Dump;

             Log_Captured (PgmSDS.@@PgmNme
                          :PgmSDS.@@LinNum
                          :PgmSDS.@@PgmLib
                          :PgmSDS.@@ErrMsg
                          :PgmSDS.@@Job
                          :PgmSDS.@@User
                          :PgmSDS.@@JobNum
                          :EmlTyp
                          );

           EndMon;

           *INLR = *On;
           Return;
