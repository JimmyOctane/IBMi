          //******************************************************************************
          // ARCHIVEIFS_CP - Copy Member for ARCHIVEIFS Service Program
          //
          // Purpose: Contains data structure definitions and prototypes for the
          //          ARCHIVEIFS document archiving service program
          //
          // Author: East Coast Metals Development Team
          // Date: 2026-02-10
          // Version: 1.0
          //
          //******************************************************************************

          // Return data structure for archive operation result
          dcl-ds returnArchiveDS qualified template;
            Success           ind;        // Archive operation successful
            ArchiveFolderCreated ind;     // Archive folder was created
            DocumentMoved     ind;        // Document was moved
            ErrorMessage      varchar(100); // Error description
            ArchivePath       varchar(150); // Full path to archive
          end-ds;

          // Procedure prototype for ARCHIVEIFS
          dcl-pr ARCHIVEIFS likeds(returnArchiveDS);
            inDocumentPath varchar(100) const; // Full path to document
          end-pr;