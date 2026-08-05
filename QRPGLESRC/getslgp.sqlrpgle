**FREE
// ------------------------------------------------------------------------
// N PROGRAM NAME - GETSLSGP
// ------------------------------------------------------------------------
// P COPYRIGHT East Coast Metals
// ------------------------------------------------------------------------
// D Returns Gross Sales and Gross Profit for a salesperson
//   over a specified date range.
// ------------------------------------------------------------------------
// S PURPOSE:
// S   Given a company number, 3-char salesperson ID and two ISO dates,
// S   execute the sales/GP summary query against OEPTOHY/OEPTOLY/
// S   IVPMSTR/IVPMGLP and return totals in a data structure.
// S
// S SPECIAL NOTES:
// S   Only invoiced orders (statusCode = 'I') are included.
// S   COUPON posting group lines are excluded.
// S
// M ----------------------------------------------------------------------
// M TASK       DATE   ID  DESCRIPTION
// M ---------- ------ --- ------------------------------------------------
// V JJF   3163 072826 JJF created program
// M ----------------------------------------------------------------------

ctl-opt nomain expropts(*resdecpos) bnddir('QC2LE');

/COPY qcpysrc,GETSLGP_CP

// -----------------------------------------------------------------------
//  GetSlsGP - Return gross sales and gross profit for a salesperson
//             over the supplied ISO date range.
//
//  Parms:
//    inCompany  packed(15:5) - company number (reserved for future use;
//                              OEPTOHY/OEPTOLY do not carry a company field)
//    inSalesID  char(3)      - 3-character salesperson ID
//    inFromDate date         - period start date (ISO)
//    inToDate   date         - period end date   (ISO)
//
//  Returns:  salesGP_ds data structure
//    GrossSales  packed(15:2)  - sum of SALES column (cents zeroed out)
//    GrossProfit packed(15:2)  - sum of GP column    (cents zeroed out)
//    SqlCode     int(10)       - last SQLCODE (0 = success, 100 = not found)
// -----------------------------------------------------------------------

dcl-proc GetGrossProfitBySalesperson export;
  dcl-pi GetGrossProfitBySalesperson likeds(salesGP_ds);
    inCompany   packed(15:5) const;
    inSalesID   char(3)      const;
    inFromDate  date         const;
    inToDate    date         const;
  end-pi;

  dcl-ds result likeds(salesGP_ds);
  dcl-s  wkSales    packed(15:2);  // SQL INTO work var for GrossSales
  dcl-s  wkProfit   packed(15:2);  // SQL INTO work var for GrossProfit

  // Initialize result
  clear result;
  result.GrossSales  = 0;
  result.GrossProfit = 0;
  result.SqlCode     = 0;

  // Execute the aggregate sales/GP query.
  // The inner query mirrors the full sales detail logic; the outer
  // query sums SALES and GP so we get a single-row answer.
  exec sql
    SELECT coalesce(sum(SALES), 0),
           coalesce(sum(GP)   , 0)
    INTO  :wkSales,
          :wkProfit
    FROM (
      SELECT
        a11.OEID02  AS Salesperson,
        a11.OECD04  AS statusCode,
        a11.OENO01  AS OrderID,
        OEAM05 AS ExtendedPrice,
        OECD43      AS noCharge,
        OEQY03      AS QuantityShipped,

        -- SALES: extended price where the line qualifies as a real sale
        CASE
          WHEN (OECD43 <> 'Y'
            AND OEQY03 <> 0
            AND (a13.IVCD17 NOT IN ('EXC','FEE','GCP')
                 OR A14.GLCD48 IN ('CLEARAN','WARNTYFEE')))
          THEN OEAM05
          ELSE 0
        END AS SALES,

        -- GP: extended price minus WAC for qualifying lines,
        --     plus WAC credit for no-charge lines
        (CASE
           WHEN (OECD43 <> 'Y'
             AND OEQY03 <> 0
             AND (a13.IVCD17 NOT IN ('EXC','FEE','GCP')
                  OR A14.GLCD48 IN ('CLEARAN','WARNTYFEE')))
           THEN (OEAM05 - OEAM17)
           ELSE 0
         END
         +
         CASE
           WHEN (OECD43 = 'Y'
             AND OEQY03 <> 0
             AND (a13.IVCD17 NOT IN ('EXC','FEE','GCP')
                  OR A14.GLCD48 IN ('CLEARAN','WARNTYFEE')))
           THEN (OEAM17 * -1)
           ELSE 0
         END) AS GP,

        -- WAC: cost for non-GCP lines
        CASE
          WHEN (a13.IVCD17 NOT IN ('GCP'))
          THEN OEAM17
          ELSE 0
        END AS WAC,

        coalesce(A14.GLCD48, '*NONE') AS postingGroup,

        DATE(A11.OECC01 || DIGITS(A11.OEYR01) || '-' ||
             DIGITS(A11.OEMO01) || '-' ||
             DIGITS(A11.OEDY01)) AS invoiced_date

      FROM OEPTOHY A11
      LEFT OUTER JOIN OEPTOLY A12
        ON  (A11.OENO01 = A12.OENO01)
      LEFT JOIN IVPMSTR A13
        ON  (A12.IVNO07 = A13.IVNO07)
      LEFT JOIN IVPMGLP A14
        ON   A14.IVCD17 = A13.IVCD17
        AND  A14.IVCD18 = A13.IVCD18
        AND  A14.IVCD19 = A13.IVCD19
        AND  A14.IVNO07 = A13.IVNO07
    )
    WHERE invoiced_date BETWEEN :inFromDate AND :inToDate
      AND Salesperson   = :inSalesID
      AND statusCode    = 'I'
      AND PostingGroup  <> 'COUPON';

  result.GrossSales  = %int(wkSales);
  result.GrossProfit = %inth(wkProfit);
  result.SqlCode     = SQLCODE;

  return result;

end-proc GetGrossProfitBySalesperson;

