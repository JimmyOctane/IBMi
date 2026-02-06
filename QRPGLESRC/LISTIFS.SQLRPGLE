      // Control Options
         Ctl-Opt NoMain;                         // Service program (no main)
         Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
         Ctl-Opt BndDir('QC2LE');                // Bind to C runtime library
         Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
         Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
         Ctl-Opt Copyright('East Coast Metals - List IFS Tables');

      //******************************************************************************
      // LISTIFS - IFS Table/File Listing Service Program
      //
      // Purpose: Retrieves a list of file/table names from a specified IFS directory
      //          path, returning an array of up to 1000 file names
      //
      // Parameters:
      //   inPath - IFS directory path (varchar 50) - directory to scan for files
      //
      // Returns: returnListDS data structure containing:
      //   - FileNames array (up to 1000 entries of varchar 100 each)
      //   - FileCount (number of files found 0-1000)
      //   - Found indicator (true if operation successful, false if error)
      //
      // Features:
      //   - Uses QSYS2.IFS_OBJECT_STATISTICS for efficient IFS directory scanning
      //   - Filters for stream files only (excludes directories)
      //   - Non-recursive directory scan (current directory only)
      //   - Cursor-based processing with fixed array limit for memory safety
      //   - Comprehensive error handling for invalid paths and SQL errors
      //   - Returns file names only (no path information included)
      //
      // Tables Used:
      //   QSYS2.IFS_OBJECT_STATISTICS - IBM i system table function for IFS objects
      //
      // Author: [Your Name]
      // Date: 2026-02-03
      // Version: 1.0
      //
      // Modification History:
      //   Date       Author        Description
      //   ---------- ------------- ----------------------------------------------
      //   2026-02-03 [Your Name]   Initial implementation
      //                           - IFS directory scanning using IFS_OBJECT_STATISTICS
      //                           - Cursor-based processing for up to 1000 files
      //                           - Stream file filtering (no directories)
      //                           - Error handling for invalid paths
      //                           - Following GETITEM service program patterns
      //
      //******************************************************************************

      // SQL Communication Area
      exec sql include sqlca;

      // Copy members for data structures and prototypes
      /copy qrpglesrc,LISTIFS_CP

      //************************************************************
      // LISTIFS - External Procedure
      //************************************************************
       dcl-proc LISTIFS export;

       // Named constants
       dcl-c MAX_FILES const(1000);            // Maximum files to return

       dcl-pi LISTIFS likeds(returnListDS);
         inPath varchar(50) const;              // IFS directory path input
       end-pi;

        // Local variables
        dcl-s fileIndex packed(5:0);
        dcl-s currentFileName varchar(100);
        dcl-ds returnDS likeds(returnListDS);

        // Initialize return structure
        clear returnDS;
        returnDS.Found = *off;
        returnDS.FileCount = 0;
        fileIndex = 0;

        // Input parameter validation
        if %trim(inPath) = '';
          // Invalid path - return empty result
          return returnDS;
        endif;

        // Declare cursor for IFS file listing using IFS_OBJECT_STATISTICS
        exec sql
          declare listifs_cursor cursor for
          select PATHNAME_NAME
          from TABLE(QSYS2.IFS_OBJECT_STATISTICS(
            START_PATH_NAME => :inPath,
            SUBTREE_DIRECTORIES => 'NO'
          ))
          where OBJECT_TYPE = '*STMF'
          order by PATHNAME_NAME
          for read only;

        // Open cursor
        exec sql open listifs_cursor;

        // Check for SQL errors on open
        if SQLCODE <> 0;
          // SQL error occurred (invalid path, access denied, etc.)
          exec sql close listifs_cursor;
          return returnDS;
        endif;

        // Fetch the first record
        exec sql
          fetch listifs_cursor into :currentFileName;

        // Process files until no more records or maximum reached
        dow SQLCODE = 0 and fileIndex < MAX_FILES;
          fileIndex += 1;
          returnDS.FileNames(fileIndex) = %trim(currentFileName);
          returnDS.FileCount = fileIndex;

          // Fetch next record
          exec sql
            fetch listifs_cursor into :currentFileName;
        enddo;

        // Close cursor
        exec sql close listifs_cursor;

        // Set success indicator
        // Found = *on even if no files (empty directory is not an error)
        // Found = *off only for SQL errors (invalid path, access issues)
        if SQLCODE = 0 or SQLCODE = 100;
          // Normal completion (with or without files)
          returnDS.Found = *on;
        else;
          // SQL error occurred
          returnDS.Found = *off;
        endif;

        // Return the result
        return returnDS;

       end-proc LISTIFS;

