-- Direct SQL to Excel without intermediate table
-- Run with: RUNSQLSTM SRCFILE(QDDSSRC) SRCMBR(APCHKRPT2) COMMIT(*NONE)

SELECT SYSTOOLS.GENERATE_SPREADSHEET(
  'SELECT Check_Num AS "Check#", 
          CheckDate AS "Check Date",
          Vendor_Num AS "Vendor#", 
          Name AS "Name", 
          Amount AS "Amount"
   FROM (
     SELECT
       APNO14 AS Check_Num,
       a.APNO01 AS Vendor_Num,
       APNM02 AS Name,
       APCD27 AS CheckType,
       APAM11 AS Amount,
       
       CASE
         WHEN apmo08 BETWEEN 1 AND 12
          AND apdy08 BETWEEN 1 AND 31
          AND apyr08 BETWEEN 0 AND 99
         THEN INT(DATE(apcc08 CONCAT DIGITS(apyr08) CONCAT ''-'' 
                       CONCAT DIGITS(apmo08) CONCAT ''-'' 
                       CONCAT DIGITS(apdy08)))
         ELSE 0
       END AS CheckDate,
       
       CASE
         WHEN apmo13 BETWEEN 1 AND 12
          AND apdy13 BETWEEN 1 AND 31
          AND apyr13 BETWEEN 0 AND 99
         THEN INT(DATE(apcc13 CONCAT DIGITS(apyr13) CONCAT ''-'' 
                       CONCAT DIGITS(apmo13) CONCAT ''-'' 
                       CONCAT DIGITS(apdy13)))
         ELSE 0
       END AS VoidDate,
       
       CASE
         WHEN apmo09 BETWEEN 1 AND 12
          AND apdy09 BETWEEN 1 AND 31
          AND apyr09 BETWEEN 0 AND 99
         THEN INT(DATE(apcc09 CONCAT DIGITS(apyr09) CONCAT ''-'' 
                       CONCAT DIGITS(apmo09) CONCAT ''-'' 
                       CONCAT DIGITS(apdy09)))
         ELSE 0
       END AS ClearDate
       
     FROM APPHCK a
     JOIN APPMVEN b ON a.APNO01 = b.APNO01
     WHERE APCD27 <> ''A''
   ) AS SubQuery
   
   WHERE
     (CheckDate <= 20260331
      AND VoidDate > 20260331
      AND ClearDate <= VoidDate
      AND CheckType <> ''A'')
     
     OR (CheckDate <= 20260331
         AND ClearDate > 20260331
         AND CheckType <> ''A'')
     
     OR (CheckDate <= 20260331
         AND VoidDate = 0
         AND ClearDate = 0
         AND CheckType <> ''A'')
   
   ORDER BY Check_Num',
  '/tmp/APCHKRPT.xlsx'
)
FROM SYSIBM.SYSDUMMY1;
