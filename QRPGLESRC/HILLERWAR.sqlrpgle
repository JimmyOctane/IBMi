**FREE
//==============================================================================
// Program: HILLERWAR
// Description: Merged SQL insert for Hiller warranty data
// Created: 2026-05-21
//==============================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIo) Main(Main);

// Main processing
Dcl-Proc Main;
  
  // Execute merged insert statement with claim data
  Exec Sql
    Insert into HILLERWAR1
    (Select invoice, trans#, job, shipbr, sellbr, po, status, invdte,
            rga, ref#, customer, name, product, item, itmdsc, qty,
            cast(sum(qty) over(partition by invoice, item) as decimal(5,0)) as invsum,
            unitprc, nochg, lineext, sbtotal, rtnauth, claim#, claimsts,
            vndrtn, vrsts, notes
     From (
      Select
       cast(h.oeno01 as char(7)) as invoice,
       cast(h.oeno01 as char(7)) as trans#,
       cast(h.oeno06 as char(7)) as job,
       l.oeno16 as shipbr,
       l.oeno08 as sellbr,
       cast(h.oeno07 as char(22)) as po,
       cast(case h.oecd04
              when 'I' then 'Invoiced'
              when 'N' then 'Pending'
              when 'O' then 'Open'
              when 'R' then 'Reviewed'
              else h.oecd04
            end as char(10)) as status,
       cast(digits(oemo01)||'/'||digits(oedy01)||'/'||digits(oeyr01)
         as char(8)) as invdte,
       cast(h.oefl31 as char(1)) as rga,
       cast(h.oeno14 as char(7)) as ref#,
       h.arno01 as customer,
       cast(c.arnm01 as char(30)) as name,
       cast(i.ivno04 as char(15)) as product,
       i.ivno07 as item,
       cast(i.ivdn01 as char(32)) as itmdsc,
       l.oeqy03 as qty,
       l.oeam38 as unitprc,
       cast(l.oecd43 as char(1)) as nochg,
       l.oeam05 as lineext,
       h.oetl02 as sbtotal,
       cast(l.oeno69 as char(20)) as rtnauth,
       cast(coalesce(w.cmnoa2, ' ') as char(10)) as claim#,
       cast(coalesce(w.cmtx09, ' ') as char(10)) as claimsts,
       cast(coalesce(v.pono27, 0) as decimal(7,0)) as vndrtn,
       cast(case when coalesce(v.pono27, 0) <> 0
                 then case coalesce(inv.apcd11, v.pocd37, ' ')
                        when 'P' then 'Paid'
                        when 'S' then 'Shp Confrm'
                        else coalesce(inv.apcd11, v.pocd37, ' ')
                      end
                 else ' '
            end as char(10)) as vrsts,
       cast(' ' as char(50)) as notes
     From oeptohy h
       inner join oeptoly l on h.oeno01 = l.oeno01
       inner join arpmcus c on h.arno01 = c.arno01
       inner join ivpmstr i on l.ivno07 = i.ivno07
       left join lateral (
         Select cmnoa2, cmtx09 from oeptwch
         where opno28 = l.oeno69
         fetch first 1 rows only
       ) w on 1=1
       left join lateral (
         Select pono27, pocd37 from poptvrh
         where pono30 = w.cmnoa2 and pono30 <> ' '
         fetch first 1 rows only
       ) v on 1=1
       left join lateral (
         Select i.apcd11 from poptvrh h
         inner join apptinm vm on h.pono27 = vm.pono27
         inner join apptinh i on vm.apno20 = i.apno20
         where h.pono30 = w.cmnoa2 and v.pono27 is not null and v.pono27 <> 0
         fetch first 1 rows only
       ) inv on 1=1
     Where h.arno01 = 750503
       and h.oeno06 = 'WARR '
       and l.ivno07 <> 0
       and i.ivno05 = 14141
       and (h.oecd08 <> 'C' or (h.oecd08 = 'C' and h.oefl31 <> 'Y'))
     
     UNION ALL
     
     Select
       cast(h.oeno14 as char(7)) as invoice,
       cast(h.oeno01 as char(7)) as trans#,
       cast(h.oeno06 as char(7)) as job,
       l.oeno16 as shipbr,
       l.oeno08 as sellbr,
       cast(h.oeno07 as char(22)) as po,
       cast(case h.oecd04
              when 'I' then 'Invoiced'
              when 'N' then 'Pending'
              when 'O' then 'Open'
              when 'R' then 'Reviewed'
              else h.oecd04
            end as char(10)) as status,
       cast(digits(oemo01)||'/'||digits(oedy01)||'/'||digits(oeyr01)
         as char(8)) as invdte,
       cast(oefl31 as char(1)) as rga,
       cast(h.oeno14 as char(7)) as ref#,
       h.arno01 as customer,
       cast(c.arnm01 as char(30)) as name,
       cast(i.ivno04 as char(15)) as product,
       i.ivno07 as item,
       cast(i.ivdn01 as char(32)) as itmdsc,
       l.oeqy03 as qty,
       l.oeam38 as unitprc,
       cast(l.oecd43 as char(1)) as nochg,
       l.oeam05 as lineext,
       h.oetl02 as sbtotal,
       cast(l.oeno69 as char(20)) as rtnauth,
       cast(coalesce(w.cmnoa2, ' ') as char(10)) as claim#,
       cast(coalesce(w.cmtx09, ' ') as char(10)) as claimsts,
       cast(coalesce(v.pono27, 0) as decimal(7,0)) as vndrtn,
       cast(case when coalesce(v.pono27, 0) <> 0
                 then case coalesce(inv.apcd11, v.pocd37, ' ')
                        when 'P' then 'Paid'
                        when 'S' then 'Shp Confrm'
                        else coalesce(inv.apcd11, v.pocd37, ' ')
                      end
                 else ' '
            end as char(10)) as vrsts,
       cast(' ' as char(50)) as notes
     From oeptohy h
       inner join oeptoly l on h.oeno01 = l.oeno01
       inner join arpmcus c on h.arno01 = c.arno01
       inner join ivpmstr i on l.ivno07 = i.ivno07
       left join lateral (
         Select cmnoa2, cmtx09 from oeptwch
         where opno28 = l.oeno69
         fetch first 1 rows only
       ) w on 1=1
       left join lateral (
         Select pono27, pocd37 from poptvrh
         where pono30 = w.cmnoa2 and pono30 <> ' '
         fetch first 1 rows only
       ) v on 1=1
       left join lateral (
         Select i.apcd11 from poptvrh h
         inner join apptinm vm on h.pono27 = vm.pono27
         inner join apptinh i on vm.apno20 = i.apno20
         where h.pono30 = w.cmnoa2 and v.pono27 is not null and v.pono27 <> 0
         fetch first 1 rows only
       ) inv on 1=1
     Where h.arno01 = 750503
       and h.oeno06 = 'WARR '
       and l.ivno07 <> 0
       and i.ivno05 = 14141
       and h.oecd08 = 'C'
       and oefl31 = 'Y'
     ) subq
     Order by trans#, item);
  
  // Drop invoices and related credits that are no chg that come to zero and
  // have a paid vendor return
  
  // Delete the temporary tables
  Exec SQL
    Drop table qtemp/TmpInvSum;
  
  // Summarize invoices and credit memos
  Exec SQL
    Create table qtemp/TmpInvSum as
     (Select invoice, nochg,
      cast(0 as dec(11,2)) as sumext,
      cast(' ' as char(10)) as vrsts
      from HILLERWAR1)
    Definition only;
  
  Exec SQL
    Insert into Qtemp/TmpInvSum
      (Select invoice, nochg,
       cast(sum(lineext) as dec(11,2)), ' '
       from HILLERWAR1
       where nochg='Y' and status='Invoiced'
       group by invoice, nochg
       order by invoice, nochg);
  
  // Update the vendor status in the invoice summary file
  Exec SQL
    Update Qtemp/TmpInvSum q set vrsts='Paid'
    Where exists (Select * from HILLERWAR1 where invoice=q.invoice and
     vrsts='Paid');
  
  // Delete invoices and credit lines that do not come to zero or
  // have not been paid
  Exec SQL
    Delete from Qtemp/TmpInvSum
    Where sumext<>0 or vrsts<>'Paid';
  
  // Delete invoices and credit lines from the original list that have
  // been completed successfully
  Exec SQL
    Delete from HILLERWAR1 h
    Where exists (Select * from Qtemp/TmpInvSum
     where invoice=h.invoice);
  
  // Delete invoices and credit lines from the original list that have
  // been identified in HILLERNC as resolved
  Exec SQL
    Delete from HILLERWAR1 h
    Where exists (Select * from HILLERNC
     where invoice=h.invoice and trans#=h.trans# and
     item=h.item);
  
  // Generate the report
  Exec Sql
    Insert into HILLERWARR
     (Select * from HILLERWAR1
      Order by ShipBr, Item, Invoice, Trans#);
  
  *InLr = *On;
  Return;
  
End-Proc;
