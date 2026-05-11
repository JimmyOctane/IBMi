     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - AFSGDTL_TS                                             *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D AFS - Get Shipment Details on AFS                                     *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S SPECIAL NOTES: program to test procedure                              *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*M ----------------------------------------------------------------------*
     H DFTACTGRP(*No) BNDDIR('ECBIND') OPTION(*SRCSTMT: *NODEBUGIO)
     H ACTGRP(*NEW)

       Dcl-F AFSDRSP Disk Usage(*Input) Keyed UsrOpn Qualified Alias;

       Dcl-Ds RSP LikeRec(AFSDRSP.RAFSDRSP:*All) Inz;

      /COPY QCPYSRC,AFSGDTL_CP
      /COPY QCPYSRC,AFSUQID_CP
      /COPY QCPYSRC,AFSTOKN_CP
      /COPY QRPGLECPY,RXSCB

       Dcl-S UniqueID Packed(15:0);
       Dcl-Ds ConfigDS LikeDS(AFS_ConfigDS_5) Inz(*LikeDS);

       Dcl-S ShipmentID Char(10);

       ShipmentID = 'SM03641054';

       // Not using AFSRREQAC or AFSRREQRC currently

       if AFS_GetShipmentDetails(UniqueId : ShipmentID );
         if not %Open(AFSDRSP);
           open AFSDRSP;
         endif;

         setll UniqueID AFSDRSP.RAFSDRSP;
         if not %Equal(AFSDRSP);
           // error, there should be at least one record
         else;
           // Read records in loop from AFSDRSP and child records
           //  in AFSDRSPAS, AFSDRSPCN, AFSDRSPET, AFSDRSPPC, AFSDRSPRF,
           //  and AFSDRSPST
         endif;

         if %Open(AFSDRSP);
           close(E) AFSDRSP;
         endif;
       else;
         // errors from the API are being written to AFSERR using
         //  the same UniqueID
       endif;

       *INLR = *On;
       return;
