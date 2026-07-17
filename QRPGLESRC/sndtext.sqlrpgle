     H NOMAIN EXPROPTS(*RESDECPOS)
     H BNDDIR('QC2LE')
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - SDTEXT                                                 *
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
        /COPY qcpysrc,SNDTEXT_CP
        /COPY qcpysrc,RUNCMND_CP

       // Beginning of procedure

        dcl-proc SendText export;
         dcl-pi SendText char(11005);
          inputString char(11005);
         end-pi;

         dcl-s dsplyMessage char(52) inz;
         dcl-s myMessage char(256) inz;
         dcl-s outString varchar(256) inz;
         dcl-s Q char(1) inz('''');

             textList.longString = inputString;

             myMessage = %trim(textList.message);

             // display using shorter 52 char variable
             dsplyMessage = %subst(myMessage:1:%min(52:%len(%trim(myMessage))));
             dsply dsplyMessage;

             // require a message - return error if not provided
             if textList.message = *blanks;
              outString = 'ERROR: message must be provided.';
              return outString;
             endif;

             // require either a phone number or phone list - return error if neither provided
             if textList.phoneNumber = *blanks and textList.phoneList = *blanks;
              outString = 'ERROR: phoneNumber or phoneList must be provided.';
              return outString;
             endif;

             // NOTE: ARPEGGIOL/ATSNDSMS command writes text message records
             //       to table ATMLO1P
             // use phone number if provided, otherwise use phone list name
             if textList.phoneNumber <> *blanks;
              commandString =
               'ARPEGGIOL/ATSNDSMS USRACT(ITDEPT) ' +
               'TOPHONE(' + %trim(textList.phoneNumber) + ') ' +
               'MESSAGE(' + Q + %trim(myMessage) + Q + ')';
             else;
              commandString =
               'ARPEGGIOL/ATSNDSMS USRACT(ITDEPT) ' +
               'PHONELIST(' + %trim(textList.phoneList) + ') ' +
               'MESSAGE(' + Q + %trim(myMessage) + Q + ')';
             endif;
             OutErrorDS = runIBMCommand(commandString);
             if OutErrorDS.messageID <> *blanks;
              outString = OutErrorDS.messageData;
             endif;

             return  outString;

          end-proc   sendText;

