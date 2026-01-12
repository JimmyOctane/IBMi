**free
// *===========================================================================
// * Program Name: PERZIP
// * Description:  Address validation using PERZIP service
// *===========================================================================
// * COPYRIGHT: East Coast Metals
// *===========================================================================
// * Purpose:
// *   Address validation service module using PERZIP
// *
// * Modification History:
// * Task  Date       ID   Description
// * 3182  2001-08-26 JJF  Initial program creation for address validation
// * --    2026-01-11 JJF  Modernized to free-format RPG
// *===========================================================================

ctl-opt nomain;
ctl-opt expropts(*resdecpos);
ctl-opt bnddir('QC2LE');

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
            dcl-pr ML219403 extpgm('ML219403');
               caseCtl        char(1);
               maxAddrLen     char(2);
               errCode        char(3);
               errMsg         char(80);
               cassFile       char(10);
               dbFlag         char(1);
               urbName        char(64);
               firmName       char(64);
               secAddr        char(64);
               delAddr        char(64);
               lastLine       char(64);
               streetNum      char(10);
               preDir         char(2);
               streetName     char(28);
               streetSfx      char(4);
               postDir        char(2);
               secAddrType    char(4);
               secAddrNum     char(8);
               sec2Type       char(4);
               sec2Num        char(8);
               extraneous     char(64);
               cityName       char(64);
               cityAbbrev     char(13);
               stateName      char(64);
               zip5           char(5);
               zip4           char(4);
               delPoint       char(3);
               carrierRoute   char(4);
               countyName     char(25);
               countyStateCd  char(2);
               fipsCounty     char(3);
               fipsState      char(2);
               congDist       char(2);
               congStateCd    char(2);
               ewsFlag        char(1);
               lacsInd        char(1);
               recType        char(1);
               defaultFlag    char(1);
               pmbx           char(12);
               strMatchLvl    char(1);
               secAddrFlag    char(1);
               elotSeq        char(4);
               elotAD         char(1);
               dpvInd         char(1);
               dpvCmra        char(1);
               dpvFP          char(1);
               dpvNotes       char(6);
               occCode        char(1);
               dirDpvFlag     char(1);
               intelCode      char(4);
               rdiCode        char(1);
               busResInd      char(1);
               llkInd         char(1);
               llkRetCode     char(2);
               slkInd         char(1);
               slkRetCode     char(2);
               retLatLon      char(1);
               llMatchQual    char(1);
               latitude       char(9);
               longitude      char(9);
               msa2000        char(4);
               mcd2000        char(5);
               cdp2000        char(5);
               censusTract    char(6);
               censusBlkGrp   char(1);
               msaCur         char(5);
               micrCur        char(5);
               metDivCur      char(5);
               conSaCur       char(3);
               zipClass       char(1);
               timeZone       char(1);
               telAC1         char(3);
               telAC2         char(3);
               telAC3         char(3);

               // MLT fields appended (single occurrence each)
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

            //INAME    inAdressname
            //IADDR1   inAddress1
            //IADDR2   inAddress2
            //IADDR3   inAddress3
            //ICITY    inCity
            //ISTATE   inState
            //IZIP     inzip
            //OADDR1   outAddress1
            //OADDR2   outAddress2
            //OADDR3   outAddress3
            //OCITY    outCity
            //OSTATE   outState
            //OZIP     outZip
            //CASE     returncase
            //ERRCDE   errorCode
            //ERRMSG   errorMessage
            //MAXADRL  maxadressLength
            //ADDRTYPE addressType



            return AddressParmDS;

         end-proc   validateAddress;

