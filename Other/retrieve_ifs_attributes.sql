-- SQL to retrieve attributes from an IFS document
-- Path: /home/JFLANARY/Stuff/branchitem.txt
-- 
-- This query uses QSYS2.IFS_OBJECT_STATISTICS to get comprehensive file attributes
-- for the specified IFS document including size, timestamps, ownership, and permissions

SELECT
    PATH_NAME,                              -- Full IFS path name
    OBJECT_TYPE,                            -- Object type (*STMF for stream files)
    SYMBOLIC_LINK,                          -- Symbolic link indicator
    ASP_NUMBER,                             -- ASP number
    TEXT_DESCRIPTION,                       -- Text description
    FILE_IDENTIFIER_NUMBER,                 -- File identifier number
    GENERATION_IDENTIFIER,                  -- Generation identifier
    FILE_SYSTEM_IDENTIFIER,                 -- File system identifier
    FILE_IDENTIFIER,                        -- File identifier
    FILE_ACCESS,                            -- File access
    CREATE_TIMESTAMP,                       -- Creation timestamp
    ACCESS_TIMESTAMP,                       -- Last access timestamp
    DATA_CHANGE_TIMESTAMP,                  -- Data change timestamp
    OBJECT_CHANGE_TIMESTAMP,                -- Object change timestamp
    LAST_USED_TIMESTAMP,                   -- Last used timestamp
    DAYS_USED_COUNT,                       -- Number of days used
    LAST_RESET_TIMESTAMP,                  -- Last reset timestamp
    ALLOCATED_SIZE,                         -- Allocated space in bytes
    DATA_SIZE,                              -- File size in bytes
    CCSID,                                  -- Coded character set ID
    CODE_PAGE,                              -- Code page
    EXTENDED_ATTRIBUTE_COUNT,               -- Extended attribute count
    CRITICAL_EXTENDED_ATTRIBUTE_COUNT,      -- Critical extended attribute count
    EXTENDED_ATTRIBUTE_SIZE,                -- Extended attribute size
    HARD_LINK_COUNT,                        -- Hard link count
    OBJECT_READ_ONLY,                       -- Object read only
    OBJECT_HIDDEN,                          -- Object hidden
    TEMPORARY_OBJECT,                       -- Temporary object
    SYSTEM_FILE,                            -- System file
    SYSTEM_USAGE,                           -- System usage
    DEVICE_SPECIAL_FILE,                    -- Device special file
    OBJECT_OWNER,                           -- Object owner
    USER_ID_NUMBER,                         -- User ID number
    PRIMARY_GROUP,                          -- Primary group
    GROUP_ID_NUMBER,                        -- Group ID number
    AUTHORIZATION_LIST,                     -- Authorization list
    SET_EFFECTIVE_USER_ID,                  -- Set effective user ID
    SET_EFFECTIVE_GROUP_ID,                 -- Set effective group ID
    AUTHORITY_COLLECTION_VALUE,             -- Authority collection value
    OBJECT_AUDIT,                           -- Object audit
    OBJECT_AUDIT_CREATE,                    -- Object audit create
    JOURNALED,                              -- Journaled
    JOURNAL_LIBRARY,                        -- Journal library
    JOURNAL_NAME,                           -- Journal name
    JOURNAL_BEFORE_IMAGE,                   -- Journal before image
    JOURNAL_AFTER_IMAGE,                    -- Journal after image
    JOURNAL_IDENTIFIER,                     -- Journal identifier
    JOURNAL_START_TIMESTAMP,                -- Journal start timestamp
    JOURNAL_OPTIONAL_ENTRIES,               -- Journal optional entries
    JOURNAL_SUBTREE,                        -- Journal subtree
    PARTIAL_TRANSACTION,                    -- Partial transaction
    APPLY_STARTING_RECEIVER_LIBRARY,        -- Apply starting receiver library
    APPLY_STARTING_RECEIVER,                -- Apply starting receiver
    APPLY_STARTING_RECEIVER_ASP,            -- Apply starting receiver ASP
    OBJECT_SIGNED,                          -- Object signed
    SYSTEM_TRUSTED_SOURCE,                  -- System trusted source
    MULTIPLE_SIGNATURES,                    -- Multiple signatures
    OBJECT_DOMAIN,                          -- Object domain
    BLOCK_SIZE,                             -- Block size
    AUX_STORAGE_ALLOCATION,                 -- Auxiliary storage allocation
    AUX_STORAGE_OVERFLOW,                   -- Auxiliary storage overflow
    MAIN_STORAGE_ALLOCATION,                -- Main storage allocation
    STORAGE_FREED,                          -- Storage freed
    STORED_LOCAL,                           -- Stored local
    VIRTUAL_DISK_STORAGE,                   -- Virtual disk storage
    DIRECTORY_FORMAT,                       -- Directory format
    STREAM_FILE_FORMAT,                     -- Stream file format
    UDFS_FILE_FORMAT,                       -- UDFS file format
    UDFS_PREFERRED_STORAGE,                 -- UDFS preferred storage
    UDFS_TEMPORARY_OBJECT,                  -- UDFS temporary object
    CASE_SENSITIVE_FILE_SYSTEM,             -- Case sensitive file system
    RESTRICT_RENAME_AND_UNLINK,             -- Restrict rename and unlink
    PC_ARCHIVE,                             -- PC archive attribute
    SYSTEM_ARCHIVE,                         -- System archive
    ALLOW_SAVE,                             -- Allow save
    SYSTEM_RESTRICT_SAVE,                   -- System restrict save
    INHERIT_ALLOW_CHECKPOINT_WRITER,        -- Inherit allow checkpoint writer
    ALLOW_WRITE_DURING_SAVE,                -- Allow write during save
    EXIT_PROGRAM_OPEN_CLOSE,                -- Exit program open close
    EXIT_PROGRAM_OPEN_CLOSE_DIRECTORY,      -- Exit program open close directory
    EXIT_PROGRAM_SCAN,                      -- Exit program scan
    EXIT_PROGRAM_SCAN_DIRECTORY,            -- Exit program scan directory
    SCAN_STATUS,                            -- Scan status
    CCSID_SCAN,                             -- CCSID scan
    CCSID_SCAN_SUCCESS,                     -- CCSID scan success
    SCAN_SIGNATURES_DIFFERENT,              -- Scan signatures different
    BINARY_SCAN,                            -- Binary scan
    CHECKED_OUT,                            -- Checked out
    CHECKED_OUT_TIMESTAMP,                  -- Checked out timestamp
    CHECKED_OUT_USER                        -- Checked out user

FROM TABLE(QSYS2.IFS_OBJECT_STATISTICS(
    START_PATH_NAME => '/home/JFLANARY/Stuff/branchitem.txt',
    SUBTREE_DIRECTORIES => 'NO'
))
WHERE PATH_NAME = '/home/JFLANARY/Stuff/branchitem.txt';

-- Alternative query for just the essential attributes
-- (Use this if you only need basic file information)

/*
SELECT 
    PATH_NAME,                    -- Full IFS path
    OBJECT_NAME,                  -- File name
    OBJECT_TYPE,                  -- Type (*STMF)
    DATA_SIZE,                    -- Size in bytes
    CREATE_TIMESTAMP,             -- Created
    MODIFY_TIMESTAMP,             -- Modified
    ACCESS_TIMESTAMP,             -- Accessed
    OWNER,                        -- Owner
    PRIMARY_GROUP                 -- Group

FROM TABLE(QSYS2.IFS_OBJECT_STATISTICS(
    START_PATH_NAME => '/home/JFLANARY/Stuff/branchitem.txt',
    SUBTREE_DIRECTORIES => 'NO'
))
WHERE PATH_NAME = '/home/JFLANARY/Stuff/branchitem.txt';
*/

-- To read the actual file content, use this additional query:

/*
SELECT 
    LINE_NUMBER,
    LINE
FROM TABLE(QSYS2.IFS_READ(
    PATH_NAME => '/home/JFLANARY/Stuff/branchitem.txt'
))
ORDER BY LINE_NUMBER;
*/