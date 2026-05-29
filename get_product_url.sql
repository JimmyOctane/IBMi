-- =====================================================================
-- Procedure: GET_PRODUCT_URL
-- Description: Returns the product URL for a given item number
-- Parameter: P_ITEM_NBR - 6 numeric item number (PMNO07)
-- Returns: Product URL string or 'Item not found'
-- =====================================================================

CREATE OR REPLACE PROCEDURE GET_PRODUCT_URL (
    IN P_ITEM_NBR DECIMAL(6, 0),
    OUT P_PRODUCT_URL VARCHAR(500)
)
LANGUAGE SQL
SPECIFIC GET_PRODUCT_URL
BEGIN
    DECLARE V_IMAGE VARCHAR(255) DEFAULT '';
    DECLARE V_BASE_URL VARCHAR(255);
    DECLARE V_IMAGE_NO_EXT VARCHAR(255);
    DECLARE V_NOT_FOUND INTEGER DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET V_NOT_FOUND = 1;
    
    -- Set the base URL
    SET V_BASE_URL = 'https://resource.ecmdi.com/is/image/Watscocom/';
    
    -- Retrieve the image filename from PIMITEMCHK table
    SELECT COALESCE(TRIM(IMAGE), '')
    INTO V_IMAGE
    FROM PIMITEMCHK
    WHERE PMNO07 = P_ITEM_NBR;
    
    -- If item was not found in the table
    IF V_NOT_FOUND = 1 THEN
        SET P_PRODUCT_URL = 'Item not found';
        RETURN;
    END IF;
    
    -- Remove the file extension and build the URL
    IF V_IMAGE <> '' THEN
        SET V_IMAGE_NO_EXT = REGEXP_REPLACE(V_IMAGE, '\.[^.]*$', '');
        SET P_PRODUCT_URL = V_BASE_URL || V_IMAGE_NO_EXT;
    ELSE
        SET P_PRODUCT_URL = '';
    END IF;
    
END;

-- =====================================================================
-- Alternative Function Version (if you prefer a function)
-- =====================================================================

CREATE OR REPLACE FUNCTION GET_PRODUCT_URL_FN (
    P_ITEM_NBR DECIMAL(6, 0)
)
RETURNS VARCHAR(500)
LANGUAGE SQL
SPECIFIC GET_PRODUCT_URL_FN
NOT DETERMINISTIC
BEGIN
    DECLARE V_IMAGE VARCHAR(255) DEFAULT '';
    DECLARE V_BASE_URL VARCHAR(255);
    DECLARE V_PRODUCT_URL VARCHAR(500);
    DECLARE V_IMAGE_NO_EXT VARCHAR(255);
    DECLARE V_NOT_FOUND INTEGER DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET V_NOT_FOUND = 1;
    
    -- Set the base URL
    SET V_BASE_URL = 'https://resource.ecmdi.com/is/image/Watscocom/';
    
    -- Retrieve the image filename from PIMITEMCHK table
    SELECT COALESCE(TRIM(IMAGE), '')
    INTO V_IMAGE
    FROM PIMITEMCHK
    WHERE PMNO07 = P_ITEM_NBR;
    
    -- If item was not found in the table
    IF V_NOT_FOUND = 1 THEN
        RETURN 'Item not found';
    END IF;
    
    -- Remove the file extension and build the URL
    IF V_IMAGE <> '' THEN
        SET V_IMAGE_NO_EXT = REGEXP_REPLACE(V_IMAGE, '\.[^.]*$', '');
        SET V_PRODUCT_URL = V_BASE_URL || V_IMAGE_NO_EXT;
    ELSE
        SET V_PRODUCT_URL = '';
    END IF;
    
    RETURN V_PRODUCT_URL;
END;

-- =====================================================================
-- Usage Examples:
-- =====================================================================

-- Using the Procedure:
-- CALL GET_PRODUCT_URL(31293, ?);

-- Using the Function:
-- SELECT GET_PRODUCT_URL_FN(31293) AS PRODUCT_URL FROM SYSIBM.SYSDUMMY1;

-- Or in a query:
-- SELECT PMNO07, GET_PRODUCT_URL_FN(PMNO07) AS PRODUCT_URL 
-- FROM PIMITEMCHK 
-- WHERE PMNO07 = 31293;
