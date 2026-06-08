     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - AFSGDTR_TS                                             *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D AFS - Get Shipment Details by Ref Number on AFS                       *
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

      /COPY QCPYSRC,AFSGDTR_CP

       Dcl-S RefNumber Char(20);

         RefNumber = '1491727';
         RefNumber = '1360148';
         RefNumber = '1401507';
         RefNumber = '1485585';
         RefNumber = '1513561';
         RefNumber = 'G784639';
         RefNumber = '1487223';
         RefNumber = '1491504';
         RefNumber = '1519728';
         // production
       //RefNumber = '1514406';
       //RefNumber = 'G893197';

       // Not using AFSRREQAC or AFSRREQRC currently

       AFS_ReturnDS  =  AFS_GetShipmentDetailsByReference(  RefNumber );

       *INLR = *On;
       return;
