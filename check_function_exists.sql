-- =====================================================================
-- Check what GET_PRODUCT_URL objects exist in JAMIEDEV schema
-- =====================================================================

-- Check for functions
SELECT ROUTINE_SCHEMA,
       ROUTINE_NAME,
       ROUTINE_TYPE,
       SPECIFIC_NAME
FROM QSYS2.SYSFUNCS
WHERE ROUTINE_SCHEMA = 'JAMIEDEV'
  AND ROUTINE_NAME LIKE '%PRODUCT%URL%';

-- Check for procedures
SELECT ROUTINE_SCHEMA,
       ROUTINE_NAME,
       ROUTINE_TYPE,
       SPECIFIC_NAME
FROM QSYS2.SYSPROCS
WHERE ROUTINE_SCHEMA = 'JAMIEDEV'
  AND ROUTINE_NAME LIKE '%PRODUCT%URL%';

-- Check all routines (functions and procedures)
SELECT ROUTINE_SCHEMA,
       ROUTINE_NAME,
       ROUTINE_TYPE,
       SPECIFIC_NAME,
       ROUTINE_DEFINITION
FROM QSYS2.SYSROUTINES
WHERE ROUTINE_SCHEMA = 'JAMIEDEV'
  AND ROUTINE_NAME LIKE '%PRODUCT%URL%';
