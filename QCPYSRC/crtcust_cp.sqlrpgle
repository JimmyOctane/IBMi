            //==============================================================
            //   CREATECUST_CP - Copy Member for CREATECUST Service Program
            //
            //   Purpose: Prototype for CreateCustomer procedure
            //
            //   Parameters:
            //     pGUID - 36-character GUID identifying BECCUSTP record
            //
            //   Description:
            //     Creates customer master records in AR system from BECCUSTP
            //     Performs validation, duplicate checking, and creates
            //     records in multiple AR tables
            //--------------------------------------------------------------

            Dcl-PR CreateCustomer ExtProc('CREATECUST');
            pGUID Char(36) Const;
            End-PR;

