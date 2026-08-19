      /if defined(*srcstmt)
      /eof
      /endif

        ctl-opt dftactgrp(*no) actgrp(*new)
                bnddir('RXSBND':'ECBIND')
                option(*srcstmt:*nodebugio)
                decedit('0.')
                text('AFS Quote Shipment Update Driver');

      // ------------------------------------------------------------------------
      // PROGRAM NAME - AFSUSEREF
      // ------------------------------------------------------------------------
      // COPYRIGHT East Coast Metals
      // ------------------------------------------------------------------------
      // AFS - Update AFS Quote with Shipment Id by Sales Order Number
      // ------------------------------------------------------------------------
      // PURPOSE:
      // Read AFSQUOTE records, call the AFS API using ORDERNBR as reference,
      // and write the returned shipment id back to AFSSHIPID.
      //
      // ----------------------------------------------------------------------
      // TASK       DATE   ID  DESCRIPTION
      // ---------- ------ --- ------------------------------------------------
      // ----------------------------------------------------------------------

        /copy QCPYSRC,AFSGDTR_CP

        exec sql include sqlca;

        dcl-s OrderNbr    char(7);
        dcl-s ApiResult   char(8000);
        dcl-s UniqueID    zoned(15:0);
        dcl-s ShipId      char(10);

        // Process through SQL so the program does not depend on externally
        // described record-format fields in this source member.
        exec sql
          declare c1 cursor for
            select ORDERNBR
            from AFSQUOTE
           where AFSSHIPID = ' '
           for update of AFSSHIPID, SHIPID_TS;

        exec sql open c1;

        exec sql fetch c1 into :OrderNbr;

        dow SQLCODE <> 100;
          ApiResult = AFS_GetShipmentDetailsByReference(%trim(OrderNbr));
          AFS_ReturnDS.unique_Character = %dec(%trim(ApiResult):10:0);  
          UniqueID = AFS_ReturnDS.uniqueID;
          ShipId = *blanks;

          exec sql
            select SHIPID
              into :ShipId
              from AFSDRSP
             where UID = :UniqueID
             order by RSPTS desc
             fetch first 1 row only;

          if %trim(ShipId) <> *blanks;
            exec sql
              update AFSQUOTE
                 set AFSSHIPID = :ShipId,
                     SHIPID_TS = current timestamp
               where current of c1;
          endif;

          exec sql fetch c1 into :OrderNbr;
        enddo;

        exec sql close c1;

        *inlr = *on;
        return;
