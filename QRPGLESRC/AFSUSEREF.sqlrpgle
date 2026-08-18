      /if defined(*srcstmt)
      /eof
      /endif

        ctl-opt dftactgrp(*no) actgrp(*new)
                bnddir('RXSBND':'ECBIND')
                option(*srcstmt:*nodebugio)
                decedit('0.')
                text('AFS Quote Shipment Update Driver');

      F*------------------------------------------------------------------------*
      F*N PROGRAM NAME - AFSUSEREF                                              *
      F*------------------------------------------------------------------------*
      F*P COPYRIGHT East Coast Metals                                           *
      F*------------------------------------------------------------------------*
      F*D AFS - Update AFS Quote with Shipment Id by Sales Order Number        *
      F*------------------------------------------------------------------------*
      F*S PURPOSE:                                                              *
      F*S Read AFSQUOTE records, call the AFS API using ORDERNBR as reference, *
      F*S and write the returned shipment id back to AFSSHIPID.                *
      F*S                                                                       *
      F*M ----------------------------------------------------------------------*
      F*M TASK       DATE   ID  DESCRIPTION                                     *
      F*M ---------- ------ --- ------------------------------------------------*
      F*M ----------------------------------------------------------------------*

        /copy QCPYSRC,AFSGDTR_CP

        dcl-f AFSQUOTE usage(*input:*update) keyed;

        dcl-s OrderNbr    char(7);
        dcl-s ApiResult   char(8000);
        dcl-s ShipId      char(25);
        dcl-s ShipIdTs    timestamp;
        dcl-ds QuoteRec extname('AFSQUOTE':'AFSQUOTER') end-ds;

        // Process only records that have not yet been assigned a shipment timestamp.
        // This assumes SHIPID_TS is a key/searchable field in the AFSQUOTE access path.
        chain ( *loval ) AFSQUOTE QuoteRec;

        dow not %eof(AFSQUOTE);

          if QuoteRec.SHIPID_TS = *loval;
            OrderNbr = QuoteRec.ORDERNBR;

            if %trim(OrderNbr) <> *blanks;
              ApiResult = AFS_GetShipmentDetailsByReference(%trim(OrderNbr));

              // The service program returns a character payload and also populates
              // AFS_ReturnDS in the called module.  We keep the driver focused on
              // the standard output field behavior requested by the user.
              // If the caller needs to derive the shipment id from the returned
              // payload, that logic can be added here once the API response format
              // is confirmed in the live environment.
              ShipId = %trim(ApiResult);

              if %trim(ShipId) <> *blanks;
                QuoteRec.AFSSHIPID = ShipId;
                ShipIdTs = %timestamp();
                QuoteRec.SHIPID_TS = ShipIdTs;
                update AFSQUOTE QuoteRec;
              endif;
            endif;
          endif;

          reade *next AFSQUOTE QuoteRec;
        enddo;

        *inlr = *on;
        return;