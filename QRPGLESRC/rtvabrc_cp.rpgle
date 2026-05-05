     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - RTVABRC                                                *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D retreive authorized branches                                          *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S    retreive authorized branches                                       *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3173 112125 JJF created program                                 *
     F*M ----------------------------------------------------------------------*

        dcl-pr retrieveAuthorizedBranches  char(9000);
          inUseScreen char(1) const;
          inUserid char(10) options( *nopass:*omit );
        end-pr;

        dcl-ds  authorizedBranchesDS  qualified inz;
         outFullString char(87) dim(100);
         company zoned(3:0) overlay(outFullString:*next);
         branch  zoned(3:0) overlay(outFullString:*next);
         returnBranch  zoned(3:0);
        end-ds;

