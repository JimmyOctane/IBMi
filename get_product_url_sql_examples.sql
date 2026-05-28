-- =====================================================================
-- SQL Examples: Using GET_PRODUCT_URL function
-- =====================================================================

-- Example 1: Get URL for a single item number
SELECT jamiedev.GET_PRODUCT_URL(5853) AS PRODUCT_URL
FROM SYSIBM.SYSDUMMY1;

-- Example 2: Get URL for a specific item from the table
SELECT PMNO07 AS ITEM_NUMBER,
       jamiedev.GET_PRODUCT_URL(PMNO07) AS PRODUCT_URL
FROM PIMITEMCHK
WHERE PMNO07 = 5853;

-- Example 3: Get URLs for multiple items
SELECT PMNO07 AS ITEM_NUMBER,
       jamiedev.GET_PRODUCT_URL(PMNO07) AS PRODUCT_URL
FROM PIMITEMCHK
WHERE PMNO07 IN (5853, 31293);

-- Example 4: Get URLs for all items with images
SELECT PMNO07 AS ITEM_NUMBER,
       IMAGE AS IMAGE_FILENAME,
       jamiedev.GET_PRODUCT_URL(PMNO07) AS PRODUCT_URL
FROM PIMITEMCHK
WHERE IMAGE IS NOT NULL AND IMAGE <> ''
ORDER BY PMNO07;

-- Example 5: Get item details with URL
SELECT PMNO07 AS ITEM_NUMBER,
       "Our Product         Number" AS PRODUCT_NUMBER,
       "Manufacturer" AS MANUFACTURER,
       "Watsco              Description" AS DESCRIPTION,
       jamiedev.GET_PRODUCT_URL(PMNO07) AS PRODUCT_URL
FROM PIMITEMCHK
WHERE PMNO07 = 5853;

-- Example 6: Use in a WHERE clause to find items with URLs
SELECT PMNO07 AS ITEM_NUMBER,
       jamiedev.GET_PRODUCT_URL(PMNO07) AS PRODUCT_URL
FROM PIMITEMCHK
WHERE jamiedev.GET_PRODUCT_URL(PMNO07) <> ''
FETCH FIRST 10 ROWS ONLY;

-- Example 7: Simple inline query for quick testing
VALUES jamiedev.GET_PRODUCT_URL(5853);
