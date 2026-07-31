      F*------------------------------------------------------------------------*
      F*N PROGRAM NAME - GETSLSGP_CP                                           *
      F*------------------------------------------------------------------------*
      F*P COPYRIGHT East Coast Metals                                           *
      F*------------------------------------------------------------------------*
      F*D Copybook for GETSLSGP service program                                *
      F*------------------------------------------------------------------------*
      F*S PURPOSE:                                                              *
      F*S   Prototype and data structure for GetSlsGP procedure.               *
      F*S   Returns gross sales and gross profit totals for a salesperson       *
      F*S   over a caller-supplied ISO date range.                              *
      F*S                                                                       *
      F*S SPECIAL NOTES:                                                        *
      F*S                                                                       *
      F*M ----------------------------------------------------------------------*
      F*M TASK       DATE   ID  DESCRIPTION                                     *
      F*M ---------- ------ --- ------------------------------------------------*
      F*V JJF   3163 072826 JJF created program                                 *
      F*M ----------------------------------------------------------------------*

        // ------------------------------------------------------------------
        //  salesGP_ds - data structure returned by GetSlsGP
        //    GrossSales  - total qualifying sales dollars
        //    GrossProfit - total gross profit dollars
        //    SqlCode     - SQLCODE from the SELECT INTO
        //                   0   = success
        //                   100 = no rows matched
        //                  <0   = SQL error
        // ------------------------------------------------------------------
        dcl-ds salesGP_ds qualified template;
          GrossSales  packed(15:2);
          GrossProfit packed(15:2);
          SqlCode     int(10);
        end-ds;

        // ------------------------------------------------------------------
        //  Prototype for GetSlsGP
        //    inCompany   packed(15:5) - company number (converted to 3,0 internally)
        //    inSalesID   char(3)      - 3-character salesperson number
        //    inFromDate  date         - range start date (ISO *ISO format)
        //    inToDate    date         - range end   date (ISO *ISO format)
        // ------------------------------------------------------------------
        dcl-pr GetSlsGP likeds(salesGP_ds) extproc('GETSLSGP');
          inCompany   packed(15:5) const;
          inSalesID   char(3)      const;
          inFromDate  date         const;
          inToDate    date         const;
        end-pr;


