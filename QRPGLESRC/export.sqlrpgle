**FREE
//==============================================================================
// Program: EXPORT_IVPTADJ_XLS
// Description: Reads program info in batches of 1000 rows.
//==============================================================================

  ctl-opt option(*srcstmt: *nodebugio) debug(*yes) dftactgrp(*no)
   bnddir('SHBIND':'WMBIND':'HDBIND':'WKBIND':'MNBIND':'YAJL':'ECBIND');


//==============================================================================
// Prototypes / Parameters
//==============================================================================
dcl-pi *n;
  inLibrary char(10) const;
end-pi;

//==============================================================================
// Variables
//==============================================================================
dcl-s outFile varchar(256) inz('/home/sourceExport/');
dcl-s folderPath varchar(256);
dcl-s streamFilePath varchar(256);
dcl-s library varchar(10);
dcl-s sourceFile varchar(128);
dcl-s description varchar(100);
dcl-s foundSource ind inz(*Off);
dcl-s member varchar(128);
dcl-s sourceType varchar(20);
dcl-s textDescription varchar(100);
dcl-s lastSourceUpdateTimestamp timestamp;
dcl-s lastStamp varchar(256);
dcl-s workLastStamp timestamp;
dcl-s MyLastStamp char(26) dtaara('JAMIEDEV/EXPORTDS');
dcl-s rowCount1 int(10) inz(0);
dcl-s rowCount2 int(10) inz(0);
dcl-s maxItemLines packed(5:0) inz(10000);
dcl-s i1           int(10:0) inz;
dcl-s i2           int(10:0) inz;
dcl-s Q char(1) inz('''');

dcl-ds C1 dim(10000) qualified inz;
  library varchar(10);
  sourceFile varchar(128);
  description varchar(100);
end-ds;

dcl-ds C2 dim(10000) qualified inz;
  MEMBER varchar(128);
  SOURCE_TYPE varchar(20);
  LAST_SOURCE_UPDATE_TIMESTAMP timestamp;
end-ds;

/COPY qcpysrc,RUNCMND_CP

in *lock MyLastStamp;
workLastStamp = %timestamp(MyLastStamp);
MyLastStamp = %char(%timestamp());
out MyLastStamp;
unlock MyLastStamp;

exec sql declare c1 scroll cursor for
SELECT
    TABLE_SCHEMA AS LIBRARY,
    TABLE_NAME   AS SOURCE_FILE,
    TABLE_TEXT   AS DESCRIPTION
FROM QSYS2.SYSTABLES
WHERE TABLE_SCHEMA = :inLibrary
  AND FILE_TYPE = 'S'
ORDER BY TABLE_NAME;

exec sql declare c2 scroll cursor for
SELECT
    SYSTEM_TABLE_MEMBER AS MEMBER,
    SOURCE_TYPE,
    LAST_SOURCE_UPDATE_TIMESTAMP
    FROM QSYS2.SYSPARTITIONSTAT
WHERE SYSTEM_TABLE_SCHEMA = :library
  AND SYSTEM_TABLE_NAME   = :sourceFile
  AND LAST_SOURCE_UPDATE_TIMESTAMP > :workLastStamp
ORDER BY SYSTEM_TABLE_NAME;

//==============================================================================
// Main Processing
//==============================================================================
exec sql open c1;

Exec SQL fetch first from C1 for :maxItemLines rows into :C1;
Exec SQL get diagnostics :rowCount1 = ROW_COUNT;

Dow rowCount1 <> 0;
  For i1 = 1 to rowCount1;
    library = C1(i1).library;
    sourceFile = C1(i1).sourceFile;
    description = C1(i1).description;
    folderPath = %trim(outFile) + %trim(inLibrary) + '/' + %trim(sourceFile) + '/';

    // run command
    commandString = 'MD ' +Q+ %trim(outFile) + '/' + Q;
    OutErrorDS = runIBMCommand(commandString);
    commandString = 'MD ' +Q+ %trim(outFile) + %trim(inLibrary) + '/'+ Q;
    OutErrorDS = runIBMCommand(commandString);
    commandString = 'MD ' +Q+ folderPath + Q;
    OutErrorDS = runIBMCommand(commandString);

    exec sql open c2;

    Exec SQL fetch first from C2 for :maxItemLines rows into :C2;
    Exec SQL get diagnostics :rowCount2 = ROW_COUNT;

    Dow rowCount2 <> 0;
      For i2 = 1 to rowCount2;
        member = C2(i2).member;
        sourceType = C2(i2).source_type;

        lastSourceUpdateTimestamp = C2(i2).last_source_update_timestamp;
        streamFilePath = folderPath + %trim(member) + '.' + %trim(sourceType);

        // if working with base MINCRON library, skip anything that is in RDOI_PC_S
        reset foundSource;
        if inLibrary = 'HD1100PS';
         exec sql 
          SELECT  coalesce('1', '0')
          into : foundSource
          FROM QSYS2.SYSPARTITIONSTAT
           WHERE SYSTEM_TABLE_SCHEMA = 'RDOI_PM_S'
           AND SYSTEM_TABLE_MEMBER = : member
        endif; 
        
        if (inLibrary <> 'HD1100PS' or inLibrary = 'HD1100PS' and not(foundSource));
        commandString = 'CPYTOIMPF FROMFILE(' + %trim(inLibrary) + '/' +
                        %trim(sourceFile) + ' ' + %trim(member) + ')' +
                        ' TOSTMF(''' + streamFilePath + ''')' +
                        ' MBROPT(*REPLACE) STMFCCSID(1208) RCDDLM(*CRLF)' +
                        ' STRDLM(*NONE) STRESCCHR(*NONE) FLDDLM(*TAB)' +
                        ' DTAFMT(*DLM)';
        OutErrorDS = runIBMCommand(commandString);
      Endfor;

      Exec SQL fetch next from C2 for :maxItemLines rows into :C2;
      Exec SQL get diagnostics :rowCount2 = ROW_COUNT;

    Enddo;

    Exec SQL close C2;
  Endfor;


    Exec sql fetch next from C1 for :maxItemLines rows into :C1;
    Exec sql get diagnostics :rowCount1 = ROW_COUNT;

  Enddo;

Exec SQL close C1;

*inlr = *on;
return;

