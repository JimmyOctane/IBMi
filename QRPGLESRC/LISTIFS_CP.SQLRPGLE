          //******************************************************************************
          // LISTIFS_CP - Copy Member for LISTIFS Service Program
          //
          // Purpose: Contains data structure definitions and prototypes for the
          //          LISTIFS IFS table listing service program
          //
          // Author: System Generated
          // Date: 2026-02-03
          // Version: 1.0
          //
          //******************************************************************************

          // File entry structure for individual file names
          dcl-ds fileEntry_t qualified template;
            FileName          varchar(100);                   // File/table name (no path)
          end-ds;

          // Main return data structure for IFS file list
          dcl-ds returnIFSDocumentsDS qualified;
            FileNames         likeds(fileEntry_t) dim(1000);  // Array of file names
            FileCount         packed(5:0);                    // Number of files found
            Found             ind;                            // Files found indicator
          end-ds;

          // Procedure prototype for LISTIFS
          dcl-pr LISTIFS likeds(returnIFSDocumentsDS);
            inPath varchar(50) const;                         // IFS directory path input
            inSubtree ind const;                              // Include subdirectories (*on=YES, *off=NO)
          end-pr;
