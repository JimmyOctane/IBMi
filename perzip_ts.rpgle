     H DFTACTGRP(*No) BNDDIR('ECBIND') OPTION(*SRCSTMT: *NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - RUNCMND                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D run IBM i command from RPGLE programs                                 *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    run IBM i command from RPGLE programs                              *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3162 080125 JJF created program                                 *
     F*M ----------------------------------------------------------------------*

        // RUNCMND - run a command
            dcl-s someReturnField char(80) inz;

         /COPY qcpysrc,RUNCMND_CP

         *inlr = *on;

         // run command
         commandString = 'WRKACTJOB XUTPUT(*PRINT)';
         OutErrorDS = runIBMCommand(commandString);

