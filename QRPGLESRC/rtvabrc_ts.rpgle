     H DFTACTGRP(*No) BNDDIR('ECBIND') OPTION(*SRCSTMT: *NODEBUGIO)
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - RTVABRC_TS                                             *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D list authorized branches                                              *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    list authorized branches                                           *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3173 112125 JJF created program                                 *
     F*M ----------------------------------------------------------------------*
         /COPY qcpysrc,RTVABRC_CP

         dcl-s OutUseScreen char(1) inz('Y');
         dcl-s reply char(1) inz;

         // run command
         outUseScreen = 'N';
         authorizedBranchesDS = retrieveAuthorizedBranches(OutUseScreen);
         outUseScreen = 'Y';
         authorizedBranchesDS = retrieveAuthorizedBranches(OutUseScreen);

         *inlr = *on;

