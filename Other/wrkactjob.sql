--------------------------------------------------------------------------
-- WRKACTJOB.SQL
--
-- SQL replacement for the WRKACTJOB (Work with Active Jobs) command,
-- using the QSYS2.ACTIVE_JOB_INFO table function.
--
-- Run this in ACS "Run SQL Scripts", DBeaver, or via RUNSQLSTM / STRSQL.
--------------------------------------------------------------------------

-- ============================================================
-- 1. Basic list - similar columns to WRKACTJOB main panel
-- ============================================================
SELECT
    SUBSYSTEM_DESCRIPTION_NAME AS SUBSYSTEM,
    JOB_NAME,
    JOB_USER,
    JOB_NUMBER,
    JOB_TYPE,
    JOB_STATUS,
    FUNCTION_TYPE,
    FUNCTION,
    CPU_TIME,
    TOTAL_DISK_IO_COUNT,
    ELAPSED_CPU_PERCENTAGE,
    THREAD_COUNT,
    JOB_ENTERED_SYSTEM_TIME
FROM TABLE (
    QSYS2.ACTIVE_JOB_INFO(
        SUBSYSTEM_LIST_FILTER    => '',   -- '' = all subsystems, or e.g. 'QINTER,QBATCH'
        JOB_NAME_FILTER          => '',   -- '' = all jobs, or e.g. 'QPADEV%'
        CURRENT_USER_LIST_FILTER => '',   -- '' = all users, or e.g. 'MYUSER'
        DETAILED_INFO            => 'NONE'
    )
) AS X
ORDER BY SUBSYSTEM_DESCRIPTION_NAME, JOB_NAME;


-- ============================================================
-- 2. Sorted like WRKACTJOB by CPU % descending (busiest jobs first)
-- ============================================================
SELECT
    SUBSYSTEM_DESCRIPTION_NAME AS SUBSYSTEM,
    JOB_NAME,
    JOB_USER,
    JOB_NUMBER,
    JOB_STATUS,
    FUNCTION,
    ELAPSED_CPU_PERCENTAGE AS CPU_PCT,
    CPU_TIME,
    TOTAL_DISK_IO_COUNT AS DISK_IO,
    THREAD_COUNT AS THREADS
FROM TABLE (
    QSYS2.ACTIVE_JOB_INFO(
        SUBSYSTEM_LIST_FILTER    => '',
        JOB_NAME_FILTER          => '',
        CURRENT_USER_LIST_FILTER => '',
        DETAILED_INFO            => 'ALL'
    )
) AS X
ORDER BY ELAPSED_CPU_PERCENTAGE DESC;


-- ============================================================
-- 3. Filter to a specific subsystem (e.g. QINTER) - like
--    WRKACTJOB SBS(QINTER)
-- ============================================================
SELECT
    JOB_NAME,
    JOB_USER,
    JOB_NUMBER,
    JOB_STATUS,
    FUNCTION,
    CPU_TIME,
    ELAPSED_CPU_PERCENTAGE
FROM TABLE (
    QSYS2.ACTIVE_JOB_INFO(
        SUBSYSTEM_LIST_FILTER => 'QINTER'
    )
) AS X
ORDER BY JOB_NAME;


-- ============================================================
-- 4. Filter to jobs owned by a specific user
-- ============================================================
SELECT
    JOB_NAME,
    JOB_USER,
    JOB_NUMBER,
    SUBSYSTEM_DESCRIPTION_NAME AS SUBSYSTEM,
    JOB_STATUS,
    FUNCTION,
    CPU_TIME
FROM TABLE (
    QSYS2.ACTIVE_JOB_INFO(
        CURRENT_USER_LIST_FILTER => 'MYUSER'   -- change to the user profile you want
    )
) AS X
ORDER BY JOB_NAME;


-- ============================================================
-- 5. Only jobs that are currently active (status ACTIVE) with
--    a percent CPU threshold - useful for spotting runaway jobs
-- ============================================================
SELECT
    JOB_NAME,
    JOB_USER,
    JOB_NUMBER,
    SUBSYSTEM_DESCRIPTION_NAME AS SUBSYSTEM,
    JOB_STATUS,
    FUNCTION,
    ELAPSED_CPU_PERCENTAGE AS CPU_PCT,
    CPU_TIME
FROM TABLE (
    QSYS2.ACTIVE_JOB_INFO(DETAILED_INFO => 'ALL')
) AS X
WHERE JOB_STATUS = 'ACTIVE'
  AND ELAPSED_CPU_PERCENTAGE > 5
ORDER BY ELAPSED_CPU_PERCENTAGE DESC;


-- ============================================================
-- 6. Search for a specific job name pattern (like F14=positioning
--    to a job name in WRKACTJOB)
-- ============================================================
SELECT
    JOB_NAME,
    JOB_USER,
    JOB_NUMBER,
    SUBSYSTEM_DESCRIPTION_NAME AS SUBSYSTEM,
    JOB_STATUS,
    FUNCTION
FROM TABLE (
    QSYS2.ACTIVE_JOB_INFO(
        JOB_NAME_FILTER => 'QPADEV%'   -- wildcard % supported
    )
) AS X
ORDER BY JOB_NAME;


-- ============================================================
-- 7. Locked-object / job wait detail (equivalent of WRKACTJOB
--    option 5 -> Work with job -> Display job -> Locks)
--    Requires ACTIVE_JOB_INFO DETAILED_INFO => 'ALL'
-- ============================================================
SELECT
    JOB_NAME,
    JOB_USER,
    JOB_NUMBER,
    JOB_STATUS,
    WAIT_STATUS,
    RUN_PRIORITY,
    TEMPORARY_STORAGE,
    THREAD_COUNT
FROM TABLE (
    QSYS2.ACTIVE_JOB_INFO(DETAILED_INFO => 'ALL')
) AS X
WHERE JOB_STATUS = 'ACTIVE'
ORDER BY TEMPORARY_STORAGE DESC;


--------------------------------------------------------------------------
-- Notes:
-- * QSYS2.ACTIVE_JOB_INFO is the modern, supported SQL replacement for
--   WRKACTJOB. It returns one row per job/thread and is much faster
--   than querying QSYS2.JOB_INFO for active-only jobs.
-- * DETAILED_INFO parameter values: 'NONE', 'ALL', 'JOBLOG',
--   'LOCK' (varies slightly by IBM i release - check your release's
--   SQL reference if a value is rejected).
-- * All filter parameters accept the SQL % and _ wildcards.
-- * Column list is not exhaustive - run:
--     SELECT * FROM TABLE(QSYS2.ACTIVE_JOB_INFO()) X LIMIT 1
--   to see every available column for your IBM i release/version.
--------------------------------------------------------------------------
