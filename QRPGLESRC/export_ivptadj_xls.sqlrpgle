**FREE
//==============================================================================
// Program: EXPORT_IVPTADJ_XLS
// Description: Runs the requested query and creates a real XLSX file on the IFS
//              using SYSTOOLS.GENERATE_SPREADSHEET.
//==============================================================================

ctl-opt dftactgrp(*no) actgrp(*new) option(*nodebugio:*srcstmt) alwnull(*usrctl);

/copy qcpysrc,SDEMAIL_CP

//==============================================================================
// Prototypes / Parameters
//==============================================================================
dcl-pi *n;
  inMonth packed(15:5) const;
  inYear packed(15:5) const;
  outPath varchar(256) const options(*nopass);
end-pi;

//==============================================================================
// Variables
//==============================================================================
dcl-s outFile varchar(256) inz('/home/jflanary/ivptadj_export');
dcl-s sqlMsg varchar(512);
dcl-s dispMsg varchar(52);
dcl-s spreadsheetQuery varchar(4000);
dcl-s sqlMonth packed(2:0);
dcl-s sqlYear packed(2:0);
dcl-s attachName varchar(256);

if %parms() >= 1 and %trim(outPath) <> '';
  outFile = %trim(outPath);
endif;

attachName = %trim(outFile) + '.xlsx';

sqlMonth = %int(inMonth);
sqlYear = %int(inYear);

spreadsheetQuery =
  'select a.ivno10, c.ivno04, c.ivno07, c.ivdn01, ' +
  'a.ivcd35, a.ivno40, a.ivqy24, a.ivamba, d.glam03 ' +
  'from IVPTADJ a ' +
  'join IVPMSBR b ' +
  'on a.IVNO07 = b.ivno07 ' +
  'and a.ivno10 = b.ivno10 ' +
  'join IVPMSTR c ' +
  'on a.IVNO07 = c.ivno07 ' +
  'join glptiad d ' +
  'on a.ivno40 = d.ivno40 ' +
  'where b.ivno10 = 500 ' +
  'and ivmo52 = ' + %trim(%char(sqlMonth)) + ' ' +
  'and ivyr52 = ' + %trim(%char(sqlYear)) + ' ' +
  'and glcd54 = ''IA1'' ' +
  'and GLNO03 = 1160';

//==============================================================================
// Main Processing
//==============================================================================
exec sql
  select systools.generate_spreadsheet(
    path_name => :outFile,
    spreadsheet_query => :spreadsheetQuery,
    spreadsheet_type => 'xlsx',
    column_headings => 'COLUMN'
  )
  into :sqlMsg
  from sysibm.sysdummy1;

if sqlcode <> 0;
  dsply 'Generate failed';
  dispMsg = 'SQLCODE=';
  dispMsg += %char(sqlcode);
  dsply dispMsg;
  *inlr = *on;
  return;
endif;

emailList.Subject = 'Adjustments';
emailList.Note = 'Adjustments by Month. ' + %trim(%char(sqlMonth));
emailList.bodyID = 1;
emailList.address(1) = 'jflanary@ecmdi.com';
emailList.type(1) = 'P';
emailList.AttachmentName(1) = %trim(attachName);
dispMsg = sendEmail(emailList);

dsply 'Spreadsheet ok';
*inlr = *on;
return;