**FREE

// =====================================================================
// Program: GETPRDURL
// Description: Reads PIMITEMCHK table and calls GET_PRODUCT_URL
//              procedure for each item, returning the image URL.
// =====================================================================

Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIo);

// Declare variables
Dcl-S wItemNbr   Packed(6:0);
Dcl-S wImageUrl  Varchar(500);
Dcl-S wImageName Varchar(75);
Dcl-S wRowCount  Packed(10:0);
Dcl-S wDsplyMsg  Char(52);
Dcl-C BASE_URL   'https://resource.ecmdi.com/is/image/Watscocom/';

// ---------------------------------------------------------------
// Declare cursor to read all items from PIMITEMCHK
// ---------------------------------------------------------------
Exec Sql
  DECLARE itemCsr CURSOR FOR
    SELECT PMNO07
    FROM PIMITEMCHK
    WHERE PMNO07 > 0
    ORDER BY PMNO07;

// Open the cursor
Exec Sql
  OPEN itemCsr;

If SqlCode <> 0;
  wDsplyMsg = 'Error opening cursor: ' + %Char(SqlCode);
  Dsply wDsplyMsg;
  *InLr = *On;
  Return;
EndIf;

// Initialize row counter
wRowCount = 0;

// ---------------------------------------------------------------
// Loop through each item in PIMITEMCHK
// ---------------------------------------------------------------
Exec Sql
  FETCH NEXT FROM itemCsr INTO :wItemNbr;

Dow SqlCode = 0;

  // Call the GET_PRODUCT_URL procedure
  Exec Sql
    CALL GET_PRODUCT_URL(:wItemNbr, :wImageUrl);

  If SqlCode = 0;
    wRowCount += 1;

    // Display item number
    wDsplyMsg = 'Item: ' + %Char(wItemNbr);
    Dsply wDsplyMsg;

    // Display base URL
    wDsplyMsg = BASE_URL;
    Dsply wDsplyMsg;

    // Display image name portion
    If %Len(%Trim(wImageUrl)) > %Len(BASE_URL);
      wImageName = %Subst(%Trim(wImageUrl)
                   : %Len(BASE_URL) + 1);
      wDsplyMsg = %Trim(wImageName);
    Else;
      wDsplyMsg = %Trim(wImageUrl);
    EndIf;
    Dsply wDsplyMsg;
  Else;
    wDsplyMsg = 'SQL Err item ' + %Char(wItemNbr) +
                ': ' + %Char(SqlCode);
    Dsply wDsplyMsg;
  EndIf;

  // Fetch next row
  Exec Sql
    FETCH NEXT FROM itemCsr INTO :wItemNbr;

EndDo;

// ---------------------------------------------------------------
// Cleanup
// ---------------------------------------------------------------
Exec Sql
  CLOSE itemCsr;

wDsplyMsg = 'Total items processed: ' + %Char(wRowCount);
Dsply wDsplyMsg;

*InLr = *On;
Return;
