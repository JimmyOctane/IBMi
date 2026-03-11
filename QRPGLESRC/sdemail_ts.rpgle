     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - SDEMAIL                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D sends HTML email(s)                                                   *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S   generic send email process - example testing program                *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3162 080125 JJF created program                                 *
     F*M ----------------------------------------------------------------------*
     H DFTACTGRP(*No) BNDDIR('ECBIND') OPTION(*SRCSTMT: *NODEBUGIO)

        // SDEMAIL - Send an email

        dcl-s emailErrorMessage char(80);

         /COPY qcpysrc,SDEMAIL_CP

         *inlr = *on;

         emailList.Subject = 'Some Type of Error occured.';
         emailList.Note =
          'There was a giant error and there is no time to panic.';

         // email ID to the body of the sent email
         emailList.bodyID = 1;

         // email list - up to 20 email addressed
         // email type 'P' = Primary, 'C' = Carbon Copy, 'B' = Blind Copy
         emailList.address(1) = 'jflanary@ecmdi.com';
         emailList.type(1) = 'P';
         emailList.address(2) = 'jflanary@ecmdi.com';
         emailList.type(2) = 'C';

         // attachments up to 10
         emailList.AttachmentName(1) = '/home/JFLANARY/' +
          'pizza.csv';

         // send the email
         reset emailErrorMessage;
         emailErrorMessage = sendEmail(EmailList);

