**FREE

     //****************************************************************************
     //* Program:      PERZIP - Address Validation Service Module
     //* Description:  NOMAIN service program for address validation using PERZIP
     //* Copyright:    East Coast Metals
     //* Author:       JJF
     //* Created:      010826
     //****************************************************************************

     // Control Options
     Ctl-Opt NoMain;                         // Service program (no main procedure)
     Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug, no I/O debug
     Ctl-Opt BndDir('QC2LE');                // Bind to C runtime library
     Ctl-Opt ExtBinInt(*Yes);                // Use binary integers efficiently
     Ctl-Opt DecEdit('0,');                  // Decimal editing with comma separator
     Ctl-Opt Copyright('East Coast Metals - Address Validation');
     F*------------------------------------------------------------------------*
     F*N PROGRAM NAME - PERZIP                                                 *
     F*------------------------------------------------------------------------*
     F*P COPYRIGHT East Coast Metals                                           *
     F*------------------------------------------------------------------------*
     F*D  address validation using PERZIP                                      *
     F*------------------------------------------------------------------------*
     F*S PURPOSE:                                                              *
     F*S     address validation using PERZIP                                   *
     F*S                                                                       *
     F*S SPECIAL NOTES:                                                        *
     F*S                                                                       *
     F*M ----------------------------------------------------------------------*
     F*M TASK       DATE   ID  DESCRIPTION                                     *
     F*M ---------- ------ --- ------------------------------------------------*
     F*V JJF   3182 010826 JJF created program                                 *
     F*M ----------------------------------------------------------------------*

           dcl-proc validateAddress export;
            dcl-pi *n char(10000);
            end-pi;

         /COPY qrpglesrc,PERZIP_CP
            //***********************************************************/
            // Main Procedure                                           */
            //***********************************************************/
            dcl-s foundIt int(10:0) inz;

            // Grouped MLT structure: 100 entries, each entry contains all MLT fields
            dcl-ds MltEntry qualified dim(100);
               mltSecAddr     char(64);   // A1#
               mltDelAddr     char(64);   // A2#
               mltStrNum      char(10);   // NO#
               mltPreDir      char(2);    // PR#
               mltStrName     char(28);   // NM#
               mltStrSfx      char(4);    // SF#
               mltPostDir     char(2);    // PS#
               mltAptType     char(4);    // AT#
               mltAptNum      char(8);    // AN#
               mltCityName    char(28);   // CT#
               mltCityAbbrev  char(13);   // CA#
               mltStateCode   char(2);    // ST#
               mltZip5        char(5);    // Z5#
               mltZip4        char(4);    // Z4#
               mltLastLine    char(64);   // LL#
               mltCarrierRt   char(4);    // CR#
               mltDelPoint    char(3);    // DP#
               mltCountyName  char(25);   // CO#
               mltCountyState char(2);    // CS#
               mltFipsState   char(2);    // FS#
               mltFipsCounty  char(3);    // FC#
               mltCongDist    char(2);    // CD#
               mltLacsInd     char(1);    // LC#
               mltStrMatch    char(1);    // SL#
               mltSecFlag     char(1);    // AF#
            end-ds;

            // Call to old\Zschool RPG program ML219403
            // Prototype matching the legacy PLIST for ML219403 (with MLT fields appended)
            // ML219403 - Address Validation Program Prototype
            dcl-pr ML219403 extpgm('ML219403');
               CaseControl char(1);                    // CASE##
               MaxAddressLength packed(2:0);           // ADRL##
               ErrorCode packed(3:0);                  // ECOD##
               ErrorMessage char(80);                  // EMSG##
               CassFileName char(10);                  // CASF##
               DatabaseFlag char(1);                   // DBFL##
               URBName char(64);                       // URBN##
               FirmName char(64);                      // FIRM##
               SecondaryAddress char(64);              // SADR##
               DeliveryAddress char(64);               // DADR##
               LastLine char(64);                      // LLIN##
               StreetNumber char(10);                  // STNO##
               PreDirection char(2);                   // PRDR##
               StreetName char(28);                    // STNM##
               StreetSuffix char(4);                   // STSF##
               PostDirection char(2);                  // PSDR##
               SecAddressType char(4);                 // SATP##
               SecAddressNumber char(8);               // SANO##
               Sec2AddressType char(4);                // S2TP##
               Sec2AddressNumber char(8);              // S2NO##
               ExtraneousInfo char(64);                // EXTR##
               City char(64);                          // CITY##
               CityAbbreviation char(13);              // CABV##
               State char(64);                         // STAT##
               ZipCode char(5);                        // ZIPC##
               Zip4 char(4);                           // ZIP4##
               DeliveryPoint char(3);                  // DPBC##
               CarrierRoute char(4);                   // CRID##
               CountyName char(25);                    // CONM##
               CountyStateCode char(2);                // COST##
               FIPSCountyNumber char(3);               // FPCO##
               FIPSStateNumber char(2);                // FPST##
               CongressionalDistNumber char(2);        // CNDS##
               CongressionalDistStateCode char(2);     // CNSC##
               EWSFlag char(1);                        // EWSF##
               LACSIndicator char(1);                  // LACS##
               RecordTypeCode char(1);                 // RTYP##
               DefaultFlag char(1);                    // DFLT##
               PMBDesignation char(12);                // PMBX##
               StreetMatchLevelInd char(1);            // SMLI##
               SecAddressFlag char(1);                 // SAFL##
               ELOTSequenceNumber char(4);             // LOT###
               ELOTAscDescCode char(1);                // LTAD##
               DPVIndicator char(1);                   // DPVI##
               DPVCMRAIndicator char(1);               // DPVC##
               DPVFootPrintInd char(1);                // DPVF##
               DPVFootNotes char(6);                   // DPVN##
               OccupancyCode char(1);                  // DPVO##
               DirectoryDPVFlag char(1);               // DDPV##
               IntelligenceCode char(4);               // ICOD##
               RDICode char(1);                        // RDIN##
               BusinessResidentialInd char(1);         // BUSR##
               LacsLinkIndicator char(1);              // LIND##
               LacsLinkReturnCode char(2);             // LCOD##
               SuiteLinkIndicator char(1);             // SIND##
               SuiteLinkReturnCode char(2);            // SCOD##
               ReturnLatLon char(1);                   // RTLL##
               LatLonMatchQuality char(1);             // LLMQ##
               Latitude char(9);                       // LATI##
               Longitude char(9);                      // LONG##
               MSA2000Code char(4);                    // MSA2##
               MCD2000Code char(5);                    // MCD2##
               CDP2000Code char(5);                    // CDP2##
               CensusTract char(6);                    // CNTR##
               CensusBlockGroup char(1);               // CBGP##
               CurrentMSACode char(5);                 // MSAC##
               CurrentMICRSACode char(5);              // MICR##
               CurrentMetDivCode char(5);              // MDCC##
               CurrentConSACode char(3);               // CSAC##
               ZipClass char(1);                       // ZCCL##
               TimeZone char(1);                       // TMZN##
               TelephoneAreaCode1 char(3);             // TAC1##
               TelephoneAreaCode2 char(3);             // TAC2##
               TelephoneAreaCode3 char(3);             // TAC3##
               MultSecAddr char(64);                   // A1#
               MultDelAddr char(64);                   // A2#
               MultStreetNo char(10);                  // NO#
               MultPreDir char(2);                     // PR#
               MultStreetName char(28);                // NM#
               MultStreetSuffix char(4);               // SF#
               MultPostDir char(2);                    // PS#
               MultAptType char(4);                    // AT#
               MultAptNumber char(8);                  // AN#
               MultCityName char(64);                  // CT#
               MultCityAbbr char(13);                  // CA#
               MultStateCode char(2);                  // ST#
               MultZipCode char(5);                    // Z5#
               MultZip4 char(4);                       // Z4#
               MultLastLine char(64);                  // LL#
               MultCarrierRte char(4);                 // CR#
               MultDelPoint char(3);                   // DP#
               MultCountyName char(25);                // CO#
               MultCountyStateCD char(2);              // CS#
               MultFIPSState char(2);                  // FS#
               MultFIPSCounty char(3);                 // FC#
               MultCongDist char(2);                   // CD#
               MultLACSInd char(1);                    // LC#
               MultStrMatchLev char(1);                // SL#
               MultSecAdrFlag char(1);                 // AF#
            end-pr;


             // Call to old\Zschool RPG program ML218202
            dcl-pr ML218202 extpgm('ML218202');
             zipCode        char(5);     // ZIPC##82
             caseCtl        char(1);     // CASE##82
             seasonalInd    char(12);    // SIND##82
             zipClass       char(1);     // ZC#82
             cityName       char(28);    // CT#82
             cityAbbrev     char(13);    // NA#82
             facilityCode   char(1);     // FC#82
             mailNameInd    char(1);     // MI#82
             prefCityName   char(28);    // PN#82
             cityDelInd     char(1);     // CI#82
             autoZoneInd    char(1);     // ZI#82
             uniqueZipInd   char(1);     // UI#82
             financeNum     char(6);     // FN#82
             stateCode      char(2);     // ST#82
             countyNum      char(3);     // CY#82
             countyName     char(25);    // CN#82
             errorCode      char(3);     // ECOD##82
            end-pr;

            // ML218202 Data Structure for easier parameter management
            dcl-ds ML218202_DS qualified;
             zipCode        char(5);     // ZIPC##82
             caseCtl        char(1);     // CASE##82
             seasonalInd    char(12);    // SIND##82
             zipClass       char(1);     // ZC#82
             cityName       char(28);    // CT#82
             cityAbbrev     char(13);    // NA#82
             facilityCode   char(1);     // FC#82
             mailNameInd    char(1);     // MI#82
             prefCityName   char(28);    // PN#82
             cityDelInd     char(1);     // CI#82
             autoZoneInd    char(1);     // ZI#82
             uniqueZipInd   char(1);     // UI#82
             financeNum     char(6);     // FN#82
             stateCode      char(2);     // ST#82
             countyNum      char(3);     // CY#82
             countyName     char(25);    // CN#82
             errorCode      char(3);     // ECOD##82
            end-ds;


            dcl-ds ML219403_DS qualified;
               CaseControl                 char(1);
               MaxAddressLength            packed(2:0);
               ErrorCode                   packed(3:0);
               ErrorMessage                char(80);
               CassFileName                char(10);
               DatabaseFlag                char(1);
               URBName                     char(64);
               FirmName                    char(64);
               SecondaryAddress            char(64);
               DeliveryAddress             char(64);
               LastLine                    char(64);
               StreetNumber                char(10);
               PreDirection                char(2);
               StreetName                  char(28);
               StreetSuffix                char(4);
               PostDirection               char(2);
               SecAddressType              char(4);
               SecAddressNumber            char(8);
               Sec2AddressType             char(4);
               Sec2AddressNumber           char(8);
               ExtraneousInfo              char(64);
               City                        char(64);
               CityAbbreviation            char(13);
               State                       char(64);
               ZipCode                     char(5);
               Zip4                        char(4);
               DeliveryPoint               char(3);
               CarrierRoute                char(4);
               CountyName                  char(25);
               CountyStateCode             char(2);
               FIPSCountyNumber            char(3);
               FIPSStateNumber             char(2);
               CongressionalDistNumber     char(2);
               CongressionalDistStateCode  char(2);
               EWSFlag                     char(1);
               LACSIndicator               char(1);
               RecordTypeCode              char(1);
               DefaultFlag                 char(1);
               PMBDesignation              char(12);
               StreetMatchLevelInd         char(1);
               SecAddressFlag              char(1);
               ELOTSequenceNumber          char(4);
               ELOTAscDescCode             char(1);
               DPVIndicator                char(1);
               DPVCMRAIndicator            char(1);
               DPVFootPrintInd             char(1);
               DPVFootNotes                char(6);
               OccupancyCode               char(1);
               DirectoryDPVFlag            char(1);
               IntelligenceCode            char(4);
               RDICode                     char(1);
               BusinessResidentialInd      char(1);
               LacsLinkIndicator           char(1);
               LacsLinkReturnCode          char(2);
               SuiteLinkIndicator          char(1);
               SuiteLinkReturnCode         char(2);
               ReturnLatLon                char(1);
               LatLonMatchQuality          char(1);
               Latitude                    char(9);
               Longitude                   char(9);
               MSA2000Code                 char(4);
               MCD2000Code                 char(5);
               CDP2000Code                 char(5);
               CensusTract                 char(6);
               CensusBlockGroup            char(1);
               CurrentMSACode              char(5);
               CurrentMICRSACode           char(5);
               CurrentMetDivCode           char(5);
               CurrentConSACode            char(3);
               ZipClass                    char(1);
               TimeZone                    char(1);
               TelephoneAreaCode1          char(3);
               TelephoneAreaCode2          char(3);
               TelephoneAreaCode3          char(3);

               // MLT appended fields
               MultSecAddr                 char(64);
               MultDelAddr                 char(64);
               MultStreetNo                char(10);
               MultPreDir                  char(2);
               MultStreetName              char(28);
               MultStreetSuffix            char(4);
               MultPostDir                 char(2);
               MultAptType                 char(4);
               MultAptNumber               char(8);
               MultCityName                char(64);
               MultCityAbbr                char(13);
               MultStateCode               char(2);
               MultZipCode                 char(5);
               MultZip4                    char(4);
               MultLastLine                char(64);
               MultCarrierRte              char(4);
               MultDelPoint                char(3);
               MultCountyName              char(25);
               MultCountyStateCD           char(2);
               MultFIPSState               char(2);
               MultFIPSCounty              char(3);
               MultCongDist                char(2);
               MultLACSInd                 char(1);
               MultStrMatchLev             char(1);
               MultSecAdrFlag              char(1);
            end-ds;


            clear ML219403_DS;
            clear ML218202_DS;



            return AddressParmDS;

         end-proc   validateAddress;

