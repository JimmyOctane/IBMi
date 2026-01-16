

            //****************************************************************************
            //* Program:      PERZIP - Address Validation Service Module
            //* Description:  NOMAIN service program for address validation using
            //*               PERZIP
            //* Copyright:    East Coast Metals
            //* Author:       JJF
            //* Created:      010826
            //****************************************************************************

            // Control Options
            Ctl-Opt NoMain;                         // Service program (no main)
            Ctl-Opt Option(*SrcStmt:*NoDebugIO);    // Source statements in debug
            Ctl-Opt BndDir('QC2LE');                // Bind to C runtime library
            Ctl-Opt ExtBinInt(*Yes);                // Use binary integers
            Ctl-Opt DecEdit('0,');                  // Decimal editing with comma
            Ctl-Opt Copyright('East Coast Metals - Address Validation');

            // SQL Communication Area
            Exec SQL Include SQLCA;

          /COPY qrpglesrc,PERZIP_CP
            

            // Non-US Address Detection Service
            dcl-pr isNonUSAddress ind;
             inCity char(25) const;
            end-pr;

           dcl-proc validateAddress export;
             dcl-pi *n likeds(AddressParmDS);
              pAddressDS likeds(AddressParmDS) const;
             end-pi;
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

               // MLT appended fields - Multiple address arrays (up to 30 matches)
               MultSecAddr                 char(64) dim(30);
               MultDelAddr                 char(64) dim(30);
               MultStreetNo                char(10) dim(30);
               MultPreDir                  char(2) dim(30);
               MultStreetName              char(28) dim(30);
               MultStreetSuffix            char(4) dim(30);
               MultPostDir                 char(2) dim(30);
               MultAptType                 char(4) dim(30);
               MultAptNumber               char(8) dim(30);
               MultCityName                char(64) dim(30);
               MultCityAbbr                char(13) dim(30);
               MultStateCode               char(2) dim(30);
               MultZipCode                 char(5) dim(30);
               MultZip4                    char(4) dim(30);
               MultLastLine                char(64) dim(30);
               MultCarrierRte              char(4) dim(30);
               MultDelPoint                char(3) dim(30);
               MultCountyName              char(25) dim(30);
               MultCountyStateCD           char(2) dim(30);
               MultFIPSState               char(2) dim(30);
               MultFIPSCounty              char(3) dim(30);
               MultCongDist                char(2) dim(30);
               MultLACSInd                 char(1) dim(30);
               MultStrMatchLev             char(1) dim(30);
               MultSecAdrFlag              char(1) dim(30);
            end-ds;

            // Call to old\Zschool RPG program ML219403
            // Prototype matching the legacy PLIST for ML219403 (with MLT fields
            // appended)
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
               MultSecAddr char(64) dim(30);           // A1#
               MultDelAddr char(64) dim(30);           // A2#
               MultStreetNo char(10) dim(30);          // NO#
               MultPreDir char(2) dim(30);             // PR#
               MultStreetName char(28) dim(30);        // NM#
               MultStreetSuffix char(4) dim(30);       // SF#
               MultPostDir char(2) dim(30);            // PS#
               MultAptType char(4) dim(30);            // AT#
               MultAptNumber char(8) dim(30);          // AN#
               MultCityName char(64) dim(30);          // CT#
               MultCityAbbr char(13) dim(30);          // CA#
               MultStateCode char(2) dim(30);          // ST#
               MultZipCode char(5) dim(30);            // Z5#
               MultZip4 char(4) dim(30);               // Z4#
               MultLastLine char(64) dim(30);          // LL#
               MultCarrierRte char(4) dim(30);         // CR#
               MultDelPoint char(3) dim(30);           // DP#
               MultCountyName char(25) dim(30);        // CO#
               MultCountyStateCD char(2) dim(30);      // CS#
               MultFIPSState char(2) dim(30);          // FS#
               MultFIPSCounty char(3) dim(30);         // FC#
               MultCongDist char(2) dim(30);           // CD#
               MultLACSInd char(1) dim(30);            // LC#
               MultStrMatchLev char(1) dim(30);        // SL#
               MultSecAdrFlag char(1) dim(30);         // AF#
            end-pr;


            // ML218202 - ZIP Code Lookup Service Program Prototype
            // Purpose: Retrieves detailed ZIP code information including city,
            // county, and classification
            // Legacy Program: old\Zschool RPG program ML218202
            dcl-pr ML218202 extpgm('ML218202');
             *n char(5) const;           // ZIP Code (5-digit) - Input
             *n char(1);                 // Case Control (U/L/M) - Input/Output
             *n char(12);                // Seasonal Indicator - Output
             *n char(1);                 // ZIP Class (P/U/S) - Output
             *n char(28);                // City Name - Output
             *n char(13);                // City Abbreviation - Output
             *n char(1);                 // Facility Code - Output
             *n char(1);                 // Mailing Name Indicator - Output
             *n char(28);                // Preferred City Name - Output
             *n char(1);                 // City Delivery Indicator - Output
             *n char(1);                 // Automated Zone Indicator - Output
             *n char(1);                 // Unique ZIP Indicator - Output
             *n char(6);                 // Finance Number - Output
             *n char(2);                 // State Code - Output
             *n char(3);                 // County Number - Output
             *n char(25);                // County Name - Output
             *n char(3);                 // Error Code (000=Success) - Output
            end-pr;

            // Local variable declaration
            dcl-ds localAddressDS likeds(AddressParmDS);
            
            clear ML219403_DS;
            clear ML218202_DS;

            // Map input parameters from pAddressDS to local variable
            localAddressDS = pAddressDS;

            // Check for non-US addresses and exit early if found
            if isNonUSAddress(localAddressDS.inCity);
                // Clear all output fields for international addresses
                clear localAddressDS.outAddress1;
                clear localAddressDS.outAddress2;
                clear localAddressDS.outAddress3;
                clear localAddressDS.outCity;
                clear localAddressDS.outState;
                clear localAddressDS.outZip;
                clear localAddressDS.errorCode;
                clear localAddressDS.errorMessage;
                clear localAddressDS.maxAddressLength;
                clear localAddressDS.addressType;
                return localAddressDS;
            endif;

            // Map localAddressDS fields to ML218202_DS for ML218202 call
            ML218202_DS.zipCode = localAddressDS.inzip;
            ML218202_DS.caseCtl = localAddressDS.returncase;
            ML218202_DS.cityName = localAddressDS.inCity;
            ML218202_DS.stateCode = localAddressDS.inState;

            // Call ML218202 to get zip code information
            ML218202(
                ML218202_DS.zipCode:
                ML218202_DS.caseCtl:
                ML218202_DS.seasonalInd:
                ML218202_DS.zipClass:
                ML218202_DS.cityName:
                ML218202_DS.cityAbbrev:
                ML218202_DS.facilityCode:
                ML218202_DS.mailNameInd:
                ML218202_DS.prefCityName:
                ML218202_DS.cityDelInd:
                ML218202_DS.autoZoneInd:
                ML218202_DS.uniqueZipInd:
                ML218202_DS.financeNum:
                ML218202_DS.stateCode:
                ML218202_DS.countyNum:
                ML218202_DS.countyName:
                ML218202_DS.errorCode
            );

            // Map ML218202_DS results back to localAddressDS only for successful lookup
            If ML218202_DSerrorCode = *blanks;
                localAddressDS.outCity = ML218202_DS.cityName;
                localAddressDS.outState = ML218202_DS.stateCode;
                localAddressDS.errorCode = ML218202_DS.errorCode;
            Else;
                // Keep original input values if ZIP lookup fails
                localAddressDS.outCity = localAddressDS.inCity;
                localAddressDS.outState = localAddressDS.inState;
                localAddressDS.errorCode = ML218202_DS.errorCode;
            EndIf;

            // Check and insert ZIP/City data into ECZIPCODE if needed
            If ML218202_DSerrorCode = *blanks; // Only if ZIP lookup successful
                checkAndInsertZipData(
                    %Trim(ML218202_DS.zipCode) :
                    %Trim(ML218202_DS.cityName) :
                    %Trim(ML218202_DS.stateCode)
                );
            EndIf;

            // Initialize all ML219403_DS fields before mapping
            clear ML219403_DS;
            
            // Map localAddressDS fields to ML219403_DS for ML219403 call
            ML219403_DS.CaseControl = localAddressDS.returncase;
            ML219403_DS.MaxAddressLength =
                %int(localAddressDS.maxAddressLength);
            ML219403_DS.FirmName = localAddressDS.inAddressname;
            ML219403_DS.SecondaryAddress = localAddressDS.inAddress2;
            ML219403_DS.DeliveryAddress = localAddressDS.inAddress1;
            ML219403_DS.LastLine = %trim(localAddressDS.inCity) + ' ' +
                                   %trim(localAddressDS.inState) + ' ' +
                                   %trim(localAddressDS.inZip);
            ML219403_DS.City = localAddressDS.inCity;
            ML219403_DS.State = localAddressDS.inState;
            ML219403_DS.ZipCode = %subst(localAddressDS.inZip:1:5);  // 5-digit ZIP
            
            // Call ML219403 to get address validation
            ML219403(
                ML219403_DS.CaseControl:
                ML219403_DS.MaxAddressLength:
                ML219403_DS.ErrorCode:
                ML219403_DS.ErrorMessage:
                ML219403_DS.CassFileName:
                ML219403_DS.DatabaseFlag:
                ML219403_DS.URBName:
                ML219403_DS.FirmName:
                ML219403_DS.SecondaryAddress:
                ML219403_DS.DeliveryAddress:
                ML219403_DS.LastLine:
                ML219403_DS.StreetNumber:
                ML219403_DS.PreDirection:
                ML219403_DS.StreetName:
                ML219403_DS.StreetSuffix:
                ML219403_DS.PostDirection:
                ML219403_DS.SecAddressType:
                ML219403_DS.SecAddressNumber:
                ML219403_DS.Sec2AddressType:
                ML219403_DS.Sec2AddressNumber:
                ML219403_DS.ExtraneousInfo:
                ML219403_DS.City:
                ML219403_DS.CityAbbreviation:
                ML219403_DS.State:
                ML219403_DS.ZipCode:
                ML219403_DS.Zip4:
                ML219403_DS.DeliveryPoint:
                ML219403_DS.CarrierRoute:
                ML219403_DS.CountyName:
                ML219403_DS.CountyStateCode:
                ML219403_DS.FIPSCountyNumber:
                ML219403_DS.FIPSStateNumber:
                ML219403_DS.CongressionalDistNumber:
                ML219403_DS.CongressionalDistStateCode:
                ML219403_DS.EWSFlag:
                ML219403_DS.LACSIndicator:
                ML219403_DS.RecordTypeCode:
                ML219403_DS.DefaultFlag:
                ML219403_DS.PMBDesignation:
                ML219403_DS.StreetMatchLevelInd:
                ML219403_DS.SecAddressFlag:
                ML219403_DS.ELOTSequenceNumber:
                ML219403_DS.ELOTAscDescCode:
                ML219403_DS.DPVIndicator:
                ML219403_DS.DPVCMRAIndicator:
                ML219403_DS.DPVFootPrintInd:
                ML219403_DS.DPVFootNotes:
                ML219403_DS.OccupancyCode:
                ML219403_DS.DirectoryDPVFlag:
                ML219403_DS.IntelligenceCode:
                ML219403_DS.RDICode:
                ML219403_DS.BusinessResidentialInd:
                ML219403_DS.LacsLinkIndicator:
                ML219403_DS.LacsLinkReturnCode:
                ML219403_DS.SuiteLinkIndicator:
                ML219403_DS.SuiteLinkReturnCode:
                ML219403_DS.ReturnLatLon:
                ML219403_DS.LatLonMatchQuality:
                ML219403_DS.Latitude:
                ML219403_DS.Longitude:
                ML219403_DS.MSA2000Code:
                ML219403_DS.MCD2000Code:
                ML219403_DS.CDP2000Code:
                ML219403_DS.CensusTract:
                ML219403_DS.CensusBlockGroup:
                ML219403_DS.CurrentMSACode:
                ML219403_DS.CurrentMICRSACode:
                ML219403_DS.CurrentMetDivCode:
                ML219403_DS.CurrentConSACode:
                ML219403_DS.ZipClass:
                ML219403_DS.TimeZone:
                ML219403_DS.TelephoneAreaCode1:
                ML219403_DS.TelephoneAreaCode2:
                ML219403_DS.TelephoneAreaCode3:
                ML219403_DS.MultSecAddr:
                ML219403_DS.MultDelAddr:
                ML219403_DS.MultStreetNo:
                ML219403_DS.MultPreDir:
                ML219403_DS.MultStreetName:
                ML219403_DS.MultStreetSuffix:
                ML219403_DS.MultPostDir:
                ML219403_DS.MultAptType:
                ML219403_DS.MultAptNumber:
                ML219403_DS.MultCityName:
                ML219403_DS.MultCityAbbr:
                ML219403_DS.MultStateCode:
                ML219403_DS.MultZipCode:
                ML219403_DS.MultZip4:
                ML219403_DS.MultLastLine:
                ML219403_DS.MultCarrierRte:
                ML219403_DS.MultDelPoint:
                ML219403_DS.MultCountyName:
                ML219403_DS.MultCountyStateCD:
                ML219403_DS.MultFIPSState:
                ML219403_DS.MultFIPSCounty:
                ML219403_DS.MultCongDist:
                ML219403_DS.MultLACSInd:
                ML219403_DS.MultStrMatchLev:
                ML219403_DS.MultSecAdrFlag
            );

            // Map ML219403_DS results back to localAddressDS (override if
            // validation successful)
            If ML219403_DS.ErrorCode = 0; // No errors from validation
                localAddressDS.outAddress1 =
                    %trim(ML219403_DS.SecondaryAddress);
                localAddressDS.outAddress2 =
                    %trim(ML219403_DS.DeliveryAddress);
                localAddressDS.outCity = %trim(ML219403_DS.City);
                localAddressDS.outState = %trim(ML219403_DS.State);
                localAddressDS.outZip = %trim(ML219403_DS.ZipCode);
                if ML219403_DS.Zip4 <> *blanks;
                    localAddressDS.outZip = %trim(localAddressDS.outZip) + '-'
                                          + %trim(ML219403_DS.Zip4);
                endif;
                localAddressDS.errorCode = *blanks;
                localAddressDS.errorMessage = *blanks;
            Else; // Use ML218202 results if ML219403 had errors
                // Preserve existing output values if they exist, otherwise use input
                if localAddressDS.outCity = *blanks;
                    localAddressDS.outCity = localAddressDS.inCity;
                endif;
                if localAddressDS.outState = *blanks;
                    localAddressDS.outState = localAddressDS.inState;
                endif;
                if localAddressDS.outZip = *blanks;
                    localAddressDS.outZip = localAddressDS.inZip;
                endif;
                localAddressDS.errorCode = %editc(ML219403_DS.ErrorCode:'Z');
                localAddressDS.errorMessage = %trim(ML219403_DS.ErrorMessage);
            EndIf;

            return localAddressDS;

          end-proc   validateAddress;

          // -----------------------------------------------------------------------
          // Procedure: checkAndInsertZipData - Check ECZIPCODE and insert if
          // missing
          //
          // Address Validation Error Codes Reference:
          // ADR - Insufficient address information
          // ANS - Address not on street
          // BNC - PO Box not found in city
          // BNR - Box missing or not found in RR/RC
          // DBE - USPS database exception
          // DPV - Address could not be DPV‑confirmed
          // ERR - No update from database
          // LLK - Address LACS‑Link converted
          // LLN - Insufficient last line
          // MLT - Multiple addresses found
          // NDR - Non‑delivery address
          // PGM - Program error
          // RNF - RR/HC not found in city
          // SNF - Street not found in city
          // STR - Street name not found
          // XST - ZIP+4 database member missing for state
          //
          // Informational Codes (Status, not errors):
          // ALT - Alternate address used
          // BNR - Box missing or not found in RR/RC (informational when DPV
          // still succeeds)
          // LLK - Address updated by LACSLink (conversion performed)
          // SLK - Address updated by SuiteLink (suite appended)
          // VAC - Address identified as vacant (not an error, just status)
          // CMZ - CMRA indicator set (Commercial Mail Receiving Agency)
          // NCO - Address updated by NCOALink (if enabled in PER modules)
          // -----------------------------------------------------------------------
          dcl-proc checkAndInsertZipData;
            dcl-pi *n;
              zipCode     char(5) const;
              cityName    char(28) const;
              stateCode   char(2) const;
            end-pi;

            dcl-s recordExists ind inz(*off);

            // Set SQL options
            Exec SQL Set Option Commit = *None, DatFmt = *ISO;

            // Check if ZIP/City combination exists - Improved version with
            // proper error handling
            Monitor;
              Exec SQL
                Select 1 Into :recordExists
                From ECZIPCODE
                Where ZIP = :zipCode
                  And UPPER(PRIMARY_CITY) = UPPER(:cityName)
                With UR;
                
              If SQLCODE = 0;
                recordExists = *On;
              ElseIf SQLCODE = 100; // No data found
                recordExists = *Off;
              Else; // SQL error occurred
                recordExists = *Off;
                // Log error - SQLCODE contains the error code
              EndIf;
              
            On-Error;
              recordExists = *Off;
              // Handle any other errors that might occur
            EndMon;

            // If record doesn't exist, insert it
            If Not recordExists;
              insertZipRecord(zipCode : cityName : stateCode);
            EndIf;

          end-proc;

          // -----------------------------------------------------------------------
          // Procedure: isNonUSAddress - Check if city indicates non-US address
          // Modern replacement for the old GOTO-based international detection
          // logic
          // Uses %list for clean, efficient array initialization
          // -----------------------------------------------------------------------
          dcl-proc isNonUSAddress;
            dcl-pi *n ind;
              inCity char(25) const;
            end-pi;
            
            // Array of international indicators - simple initialization
            dcl-s internationalIndicators char(10) dim(3);
            dcl-s cityUpper char(25);
            dcl-s i int(10);
            
            // Initialize array elements
            internationalIndicators(1) = 'CANADA';
            internationalIndicators(2) = 'ONTARIO';
            internationalIndicators(3) = 'GERMANY';
            
            // Convert city to uppercase for case-insensitive comparison
            cityUpper = %upper(%trim(inCity));
            
            // Check each international indicator using %scan for partial
            // matches
            for i = 1 to %elem(internationalIndicators);
              if %scan(%trim(internationalIndicators(i)) : cityUpper) > 0;
                return *on;  // Non-US address found
              endif;
            endfor;
            
            return *off;  // No international indicators found
          end-proc;

          // -----------------------------------------------------------------------
          // Procedure: insertZipRecord - Insert new ZIP code record into
          // ECZIPCODE
          // -----------------------------------------------------------------------
          dcl-proc insertZipRecord;
            dcl-pi *n;
              zipCode     char(5) const;
              cityName    char(28) const;
              stateCode   char(2) const;
            end-pi;

            Monitor;
              Exec SQL
                Insert Into ECZIPCODE (
                  ZIP,
                  TYPE,
                  PRIMARY_CITY,
                  STATE,
                  LATITUDE,
                  LONGITUDE,
                  COUNTRY
                ) Values (
                  :zipCode,
                  'STANDARD',
                  UPPER(:cityName),
                  UPPER(:stateCode),
                  0.00,
                  0.00,
                  'US'
                );

              // Log successful insert (optional - could be enhanced with
              // proper logging)
              // No action needed for successful insert
              
            On-Error;
              // Silently handle duplicate key or other insert errors
              // In production, you might want to log this to an error table
            EndMon;

          end-proc;

