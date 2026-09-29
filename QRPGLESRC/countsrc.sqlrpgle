        ctl-opt option(*srcstmt:*nodebugio) datfmt(*iso) extbinint(*yes);
        ctl-opt bnddir('QC2LE');

        //-------------------------------------------------------------
        // READ_QADBXREF - Example SQLRPGLE program to read QADBXREF
        //
        // Purpose:
        //   Open a cursor on QSYS.QADBXREF and read through the rows
        //   for the selected libraries.
        //
        // Query:
        //   select DBXlib, DBXFIL
        //     from qsys.QADBXREF
        //    where dbxtyp = 'S'
        //      and dbxlib in ('HD1100PS', 'RDOI_PM_S', 'RDOI_PC_S')
        //-------------------------------------------------------------

        dcl-s dbxLib      char(10);
        dcl-s dbxFil      char(10);
        dcl-s totalRecords packed(31:0);
        dcl-s recordCount packed(31:0);
        dcl-s msg         varchar(52);

        //-------------------------------------------------------------
        // Cursor for the requested SQL
        //-------------------------------------------------------------
        exec sql
           declare C1 cursor for
             select DBXlib,
                    DBXFIL
               from qsys.QADBXREF
              where dbxtyp = 'S'
                and dbxlib in ('HD1100PS', 'RDOI_PM_S', 'RDOI_PC_S')
              order by DBXlib, DBXFIL;

        //-------------------------------------------------------------
        // Main processing
        //-------------------------------------------------------------

        exec sql open C1;

        exec sql fetch C1 into :dbxLib, :dbxFil;
        dow SQLCODE = 0;

            recordCount = 0;

            exec sql
               select sum(NUMBER_ROWS)
                 into :recordCount
                 from QSYS2.SYSPARTITIONSTAT
                where TABLE_SCHEMA = :dbxLib
                  and TABLE_NAME = :dbxFil;

            totalRecords+=RecordCount;
            if SQLCODE = 0;
            endif;


            exec sql fetch C1 into :dbxLib, :dbxFil;
        enddo;

        exec sql close C1;

            dsply 'No more rows found';
             msg = 'ROWS=' + %char(totalRecords);
             dsply msg;

        *inlr = *on;
