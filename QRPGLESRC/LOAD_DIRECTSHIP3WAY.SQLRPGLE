**FREE
//==============================================================================
// Program: LOAD_DIRECTSHIP3WAY
// Description: Load DirectShip 3-way match CSV from IFS into DB2 table
// Source File: /HOME/JFLANARY/DirectShip_3Way_match_2026d.csv
// End Summary:
// - Reads /HOME/JFLANARY/DirectShip_3Way_match_2026d.csv with QSYS2.IFS_READ_UTF8()
// - Skips the header row and deletes/reloads JAMIEDEV.DIRECTSHIP3WAY
// - Parses each CSV row into the DirectShip 3-way match table
//==============================================================================

ctl-opt dftactgrp(*no) actgrp(*new) option(*nodebugio:*srcstmt) datfmt(*iso);

dcl-s filePath varchar(256) inz('/HOME/JFLANARY/DirectShip_3Way_match_2026d.csv');
dcl-s recordCount int(10) inz(0);
dcl-s line varchar(2000);
dcl-s rest varchar(2000);
dcl-s field varchar(500);
dcl-s msgText varchar(256);

dcl-s trnDte packed(6:0);
dcl-s apVendorNumber packed(5:0);
dcl-s apVendorsName varchar(60);
dcl-s apInvoiceNumber varchar(20);
dcl-s receivingRptNo packed(7:0);
dcl-s poNumber packed(7:0);
dcl-s varianceReason char(1);
dcl-s qtyStockingUom packed(15:4);
dcl-s unitPrice packed(15:4);
dcl-s matchedExtAmt packed(15:4);
dcl-s qtyRcvd packed(15:4);
dcl-s itemUnitCost packed(15:4);
dcl-s receivingExtAmt packed(15:4);
dcl-s diff packed(15:4);

// Create table if it does not already exist
exec sql
  create table JAMIEDEV.DIRECTSHIP3WAY (
      TRNDTE           decimal(6, 0)    not null,
      AP_VENDOR_NUMBER decimal(5, 0)    not null,
      AP_VENDORS_NAME  varchar(60)      not null,
      AP_INVOICE_NUMBER varchar(20)     not null,
      RECEIVING_RPT_NO  decimal(7, 0)    not null,
      PO_NUMBER         decimal(7, 0)    not null,
      VARIANCE_REASON   char(1),
      QTY_STOCKING_UOM  decimal(15, 4),
      UNIT_PRICE        decimal(15, 4),
      MATCHED_EXT_AMT   decimal(15, 4),
      QTY_RCVD          decimal(15, 4),
      ITEM_UNIT_COST    decimal(15, 4),
      RECEIVING_EXT_AMT decimal(15, 4),
      DIFF              decimal(15, 4),
      LOAD_TS           timestamp default current_timestamp,
      primary key (TRNDTE, AP_VENDOR_NUMBER, AP_INVOICE_NUMBER, RECEIVING_RPT_NO, PO_NUMBER)
  );

if sqlcode <> 0 and sqlcode <> -601;
  msgText = 'Error creating table: SQLCODE=' + %char(sqlcode);
  snd-msg *info %trim(msgText) %target(*pgmbdy:1);
endif;

exec sql delete from JAMIEDEV.DIRECTSHIP3WAY;

snd-msg *info 'Processing file: ' + %trim(filePath) %target(*pgmbdy:1);

exec sql declare c1 cursor for
  select line
    from table(QSYS2.IFS_READ_UTF8(PATH_NAME => :filePath)) as i
   where line_number > 1
     and trim(line) <> ''
   order by line_number;

exec sql open c1;

dow sqlcode = 0;
  exec sql fetch c1 into :line;
  if sqlcode = 0;
    rest = line;

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    trnDte = %dec(field : 6 : 0);
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    apVendorNumber = %dec(field : 5 : 0);
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    apVendorsName = field;
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    apInvoiceNumber = field;
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    receivingRptNo = %dec(field : 7 : 0);
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    poNumber = %dec(field : 7 : 0);
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    if %trim(field) = '';
      varianceReason = *blank;
    else;
      varianceReason = %subst(field : 1 : 1);
    endif;
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    qtyStockingUom = %dec(field : 15 : 4);
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    unitPrice = %dec(field : 15 : 4);
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    matchedExtAmt = %dec(field : 15 : 4);
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    qtyRcvd = %dec(field : 15 : 4);
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    itemUnitCost = %dec(field : 15 : 4);
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(%subst(rest : 1 : %scan(',' : rest) - 1));
    receivingExtAmt = %dec(field : 15 : 4);
    rest = %subst(rest : %scan(',' : rest) + 1);

    field = %trim(rest);
    diff = %dec(field : 15 : 4);

    exec sql
      insert into JAMIEDEV.DIRECTSHIP3WAY (
          TRNDTE,
          AP_VENDOR_NUMBER,
          AP_VENDORS_NAME,
          AP_INVOICE_NUMBER,
          RECEIVING_RPT_NO,
          PO_NUMBER,
          VARIANCE_REASON,
          QTY_STOCKING_UOM,
          UNIT_PRICE,
          MATCHED_EXT_AMT,
          QTY_RCVD,
          ITEM_UNIT_COST,
          RECEIVING_EXT_AMT,
          DIFF
      ) values (
          :trnDte,
          :apVendorNumber,
          :apVendorsName,
          :apInvoiceNumber,
          :receivingRptNo,
          :poNumber,
          :varianceReason,
          :qtyStockingUom,
          :unitPrice,
          :matchedExtAmt,
          :qtyRcvd,
          :itemUnitCost,
          :receivingExtAmt,
          :diff
      );

    if sqlcode = 0;
      recordCount += 1;
    endif;
  endif;
enddo;

exec sql close c1;

if sqlcode = 0;
  msgText = 'Successfully loaded ' + %char(recordCount) + ' records';
  snd-msg *info %trim(msgText) %target(*pgmbdy:1);
else;
  msgText = 'Error loading data: SQLCODE=' + %char(sqlcode);
  snd-msg *info %trim(msgText) %target(*pgmbdy:1);
endif;

*inlr = *on;
return;
