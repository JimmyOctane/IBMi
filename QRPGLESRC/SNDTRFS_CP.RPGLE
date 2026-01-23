     F*------------------------------------------------------------------*
     F*N PROGRAM NAME - SNDTRFS_CP                                      *
     F*------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                    *
     F*------------------------------------------------------------------*
     F*D Transfer CSV Generation Service Copy Member                    *
     F*------------------------------------------------------------------*
     F*S PURPOSE:                                                        *
     F*S    Generate CSV files for transfer data                        *
     F*S                                                                 *
     F*S SPECIAL NOTES:                                                 *
     F*S                                                                 *
     F*M ----------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                              *
     F*M ---------- ------ --- -----------------------------------------*
     F*V JJF   3060 012325 JJF created copy member                      *
     F*M ----------------------------------------------------------------*

        // Transfer CSV Generation Service
        dcl-pr generateTransferCSV int(10);
         parmDate char(10) options(*nopass);
         csvPath varchar(100) options(*nopass);
         branchArray packed(3:0) dim(100) options(*nopass);
         tableName varchar(100) options(*nopass);
         includeHeaders char(1) options(*nopass);
        end-pr;

            dcl-ds TransferParmDS qualified;
             inputDate          char(8);       // Input date (YYYYMMDD)
             outputPath         varchar(100);  // Output file path
             recordCount        int(10);       // Number of records processed
             errorCode          char(3);       // Error code
             errorMessage       varchar(80);   // Error message
            end-ds;