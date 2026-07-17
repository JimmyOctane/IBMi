     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - SNDTEXT_CP                                             *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D sends text message(s)                                                 *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S   generic send text message process                                   *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3162 080125 JJF created program                                 *
     F*M ----------------------------------------------------------------------*
        // SNDTEXT - Send a text message
        dcl-pr sendText char(11005);
          inputString char(11005);
        end-pr;

        dcl-ds textList qualified;
          longString char(11005);
          message varchar(1000) overlay(longString);
          phoneNumber char(10) overlay(longString:*next);
          phoneList char(10) overlay(longString:*next);
        end-ds;


