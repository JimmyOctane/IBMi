-- =====================================================================
-- Create Function: GET_PRODUCT_URL
-- Description: Returns the product URL for a given item number
-- Parameter: P_ITEM_NBR - 6 numeric item number (PMNO07)
-- Returns: Product URL string (without .jpg extension)
-- =====================================================================

CREATE OR REPLACE FUNCTION jamiedev.GET_PRODUCT_URL (
    P_ITEM_NBR DECIMAL(6, 0)
)
RETURNS VARCHAR(500)
LANGUAGE SQL
DETERMINISTIC
BEGIN
    DECLARE V_IMAGE VARCHAR(255);
    DECLARE V_BASE_URL VARCHAR(255);
    DECLARE V_PRODUCT_URL VARCHAR(500);
    DECLARE V_IMAGE_NO_EXT VARCHAR(255);
    
    -- Set the base URL
    SET V_BASE_URL = 'https://resource.ecmdi.com/is/image/Watscocom/';
    
    -- Retrieve the image filename from PIMITEMCHK table
    SELECT COALESCE(TRIM(IMAGE), '')
    INTO V_IMAGE
    FROM PIMITEMCHK
    WHERE PMNO07 = P_ITEM_NBR;
    
    -- Remove the .jpg extension from the image filename
    IF V_IMAGE <> '' THEN
        -- Remove file extension (.jpg, .png, etc.)
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

-- Example 1: Simple query
-- SELECT jamiedev.GET_PRODUCT_URL(5853) AS PRODUCT_URL FROM SYSIBM.SYSDUMMY1;

-- Example 2: With item details
-- SELECT PMNO07, jamiedev.GET_PRODUCT_URL(PMNO07) AS PRODUCT_URL 
-- FROM PIMITEMCHK WHERE PMNO07 = 5853;
