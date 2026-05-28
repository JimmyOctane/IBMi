**FREE

// =====================================================================
// Program: GET_PRODUCT_URL_EXAMPLE
// Description: Example of calling GET_PRODUCT_URL procedure from SQLRPGLE
// =====================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIo);

// Declare variables
Dcl-S itemNumber Packed(6:0);
Dcl-S productUrl Varchar(500);

// Example 1: Call procedure with a specific item number
itemNumber = 5853;

Exec Sql
  CALL jamiedev.GET_PRODUCT_URL(:itemNumber, :productUrl);

// Check if SQL call was successful
If SqlCode = 0;
  // Product URL is now in productUrl variable
  Dsply ('Item: ' + %Char(itemNumber));
  Dsply ('URL: ' + %Trim(productUrl));
Else;
  Dsply ('SQL Error: ' + %Char(SqlCode));
EndIf;

// Example 2: Using the function version in a SELECT statement
Exec Sql
  SELECT jamiedev.GET_PRODUCT_URL_FN(:itemNumber)
  INTO :productUrl
  FROM SYSIBM.SYSDUMMY1;

If SqlCode = 0;
  Dsply ('Function Result: ' + %Trim(productUrl));
EndIf;

// Example 3: Using in a query to get multiple URLs
Dcl-Ds itemData ExtName('PIMITEMCHK') Qualified End-Ds;

Exec Sql
  DECLARE itemCursor CURSOR FOR
  SELECT PMNO07,
         jamiedev.GET_PRODUCT_URL_FN(PMNO07) AS PRODUCT_URL
  FROM PIMITEMCHK
  WHERE PMNO07 IN (5853, 31293)
  ORDER BY PMNO07;

Exec Sql OPEN itemCursor;

Exec Sql FETCH NEXT FROM itemCursor INTO :itemNumber, :productUrl;

Dow SqlCode = 0;
  Dsply ('Item: ' + %Char(itemNumber) + ' URL: ' + %Trim(productUrl));
  
  Exec Sql FETCH NEXT FROM itemCursor INTO :itemNumber, :productUrl;
EndDo;

Exec Sql CLOSE itemCursor;

*InLr = *On;
Return;
