     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - SDTEXT                                                 *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D sends text message(s)                                                 *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S   generic send text message process - example testing program         *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3162 080125 JJF created program                                 *
     F*M ----------------------------------------------------------------------*
     H DFTACTGRP(*No) BNDDIR('ECBIND') OPTION(*SRCSTMT: *NODEBUGIO)

        // SDTEXT - Send a text message

        dcl-s textErrorMessage char(80);

         /COPY qcpysrc,SNDTEXT_CP

         *inlr = *on;

         textList.Message = 'Some Type of Error occured.';

         // send to a specific phone number (10 digit alpha)
         textList.phoneNumber = '6305515440';

         // send the text message
         reset textErrorMessage;
         textErrorMessage = sendText(textList);



