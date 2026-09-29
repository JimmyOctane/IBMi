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

            totalRecords = 0;

            exec sql
               select sum(NUMBER_ROWS)
                 into :totalRecords
                 from QSYS2.SYSPARTITIONSTAT
                where TABLE_SCHEMA = :dbxLib
                  and TABLE_NAME = :dbxFil;

            msg = 'LIB=' + %trim(dbxLib) + ' FIL=' + %trim(dbxFil);
            dsply msg;

            if SQLCODE = 0;
                msg = 'ROWS=' + %char(totalRecords);
            else;
                msg = 'SQLCODE=' + %char(SQLCODE);
            endif;

            dsply msg;

            exec sql fetch C1 into :dbxLib, :dbxFil;
        enddo;

        exec sql close C1;

        if SQLCODE = 100;
            dsply 'No more rows found';
        else;
            dsply 'Cursor close/read error';
            msg = 'SQLCODE=' + %char(SQLCODE);
            dsply msg;
        endif;

        *inlr = *on;