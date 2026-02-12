          //******************************************************************************
          // LISTATTRIFS_CP - Copy Member for LISTATTRIFS Service Program
          //
          // Purpose: Contains data structure definitions and prototypes for the
          //          LISTATTRIFS IFS document attributes listing service program
          //
          // Author: East Coast Metals Development Team
          // Date: 2026-02-12
          // Version: 1.0
          //
          //******************************************************************************

          // IFS Document Attributes structure for individual file attributes
          dcl-ds ifsAttributes_t qualified template;
            PathName          varchar(1024);                  // Full IFS path name
            ObjectName        varchar(256);                   // File/object name only
            ObjectType        varchar(10);                    // Object type (*STMF, *DIR, etc.)
            DataSize          packed(15:0);                   // File size in bytes
            AllocatedSize     packed(15:0);                   // Allocated space in bytes
            CreateTimestamp   timestamp;                      // Creation timestamp
            ModifyTimestamp   timestamp;                      // Last modification timestamp
            AccessTimestamp   timestamp;                      // Last access timestamp
            Owner             varchar(10);                    // File owner
            GroupOwner        varchar(10);                    // Group owner
            FileMode          varchar(10);                    // File permissions/mode
            CodedCharSetID    packed(5:0);                    // Coded character set ID
            LastChanged       varchar(26);                    // Last changed date/time
            Authority         varchar(10);                    // Authority information
          end-ds;

          // Main return data structure for IFS attributes list
          dcl-ds returnIFSAttributesDS qualified;
            FileAttributes    likeds(ifsAttributes_t) dim(1000);  // Array of file attributes
            FileCount         packed(5:0);                        // Number of files found
            Found             ind;                                // Files found indicator
            ErrorMessage      varchar(256);                       // Error message if any
          end-ds;

          // Procedure prototype for LISTATTRIFS
          dcl-pr LISTATTRIFS likeds(returnIFSAttributesDS);
            inPath varchar(1024) const;                           // IFS path input (file or directory)
            inSubtree ind const;                                  // Include subdirectories (*on=YES, *off=NO)
            inFileFilter varchar(256) const options(*nopass);     // Optional file filter pattern (e.g., '%.XML')
          end-pr;