-- Modified query to add sales and profit from the same table for month 1 and year 26
-- Original query enhanced to include additional month/year data (2026 vs 2025)

SELECT arno15, oeid02,
       arno01, mydate,
       totsls as jan2026_sales, totpft as jan2026_profit,
       totpct, firstDay, lastDay,
       -- Additional sales and profit for month 1, year 25 (January 2025)
       jan2025_sales, jan2025_profit,
       -- Profit increase logic: if 2026 sales > 0 and 2025 sales = 0, use JAN2026_PROFIT; if 2025 profit > 2026 profit then 0; otherwise calculate 2026 vs 2025 increase
       CASE
           WHEN totsls > 0 AND (jan2025_sales IS NULL OR jan2025_sales = 0)
           THEN totpft  -- JAN2026_PROFIT when 2026 sales > 0 and 2025 sales = 0
           WHEN jan2025_profit > totpft
           THEN 0  -- PROFIT_INCREASE = 0 when JAN2025_PROFIT > JAN2026_PROFIT
           WHEN jan2025_profit > 0 AND totpft > jan2025_profit
           THEN totpft - jan2025_profit
           ELSE NULL
       END as profit_increase
FROM (
    SELECT arno15, oeid02, arno01, mydate,
           totsls, (totpft-EXCPFT) as TOTPFT, totpct,
           '2026-01-01' firstDay,
           '2026-01-31' lastDay,
           -- Subquery to get sales and profit for month 1, year 25
           (SELECT totsls
            FROM sapcomc b
            WHERE b.arno01 = a.arno01
              AND b.oemo08 = 1
              AND b.oeyr08 = 25
            FETCH FIRST 1 ROW ONLY) as jan2025_sales,
           (SELECT (totpft-EXCPFT)
            FROM sapcomc b
            WHERE b.arno01 = a.arno01
              AND b.oemo08 = 1
              AND b.oeyr08 = 25
            FETCH FIRST 1 ROW ONLY) as jan2025_profit
   FROM (
        SELECT date(oecc08 || digits(oeyr08) ||'-'||
                    digits(oemo08) ||'-'|| '01') mydate, a.*
        FROM sapcomc a
        WHERE a.ARNO01 IN (
            240771, 240893, 240759, 240741, 206636, 240711, 13640, 240804, 240865, 240713,
            227657, 222928, 236950, 233431, 239061, 240868, 237914, 204230, 224988, 240777,
            240869, 240778, 237641, 210297, 178800, 235176, 227962, 237643, 215346, 237479,
            240825, 231697, 236561, 240735, 240900, 240796, 240888, 210468, 212630,
            240115, 225666, 240780, 229996, 237497, 240709, 489264, 239239, 200547, 240783,
            240814, 240784, 240162, 240467, 218265, 240876, 236539, 229786, 240725, 240756,
            240860, 217428, 240830, 203340, 240849, 240770
        )
        AND a.oeid02 = 'JEL'
    ) as a
) as X
WHERE mydate >= '2026-01-01' AND mydate <= '2026-01-31'
ORDER BY profit_increase DESC;