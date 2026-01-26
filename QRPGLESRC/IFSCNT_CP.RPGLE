      F*------------------------------------------------------------------*
      F*N PROGRAM NAME - IFSCNT_CP                                        *
      F*------------------------------------------------------------------*
      F*P COPYRIGHT East Coast Metals                                    *
      F*------------------------------------------------------------------*
      F*D IFS Table Record Count Service Copy Member                     *
      F*------------------------------------------------------------------*
      F*S PURPOSE:                                                        *
      F*S    Get record count from IFS table files                       *
      F*S                                                                 *
      F*S SPECIAL NOTES:                                                 *
      F*S                                                                 *
      F*M ----------------------------------------------------------------*
      F*M TASK       DATE   ID  DESCRIPTION                              *
      F*M ---------- ------ --- -----------------------------------------*
      F*V JJF   3060 012325 JJF created copy member                      *
      F*M ----------------------------------------------------------------*

        // IFS Table Record Count Service
        dcl-pr getIFSTableCount int(10);
         directory varchar(256);
         tableName varchar(128);
        end-pr;

            dcl-ds IFSCountParmDS qualified;
             directory          varchar(256);  // IFS directory path
             tableName          varchar(128);  // Table file name
             recordCount        int(10);       // Number of records found
             errorCode          char(3);       // Error code
             errorMessage       varchar(80);   // Error message
            end-ds;