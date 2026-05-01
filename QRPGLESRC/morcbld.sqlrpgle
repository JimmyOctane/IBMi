     H OPTION(*SRCSTMT : *NODEBUGIO)
      **********************************************************************
      ******************                                  ******************
      ***************     EAST COAST METAL DISTRIBUTORS       **************
      ******************                                  ******************
      **********************************************************************
      *
      *   Program Name: MORCBLD
      *   Description:  Extract data files for WATSCO mobile app feed
      *
      **********************************************************************
      *
      *  Maintenance History:
      *
      *  Date   ID  ChgId Description --------------------------------------
      *
      *  011812 KSB 5710  Initial creation - SQL statements compliments of
      *                   Gemaire
¢a    *  041012 KSB 5739  Extend desc field
¢b    *  081612 KSB 5830  Send qty avail instead of qty onhand
¢c    *  062413 KSB 5923  Use new web desc file
¢d    *  090914 CLP 6259  -Rearranged and reformated data for new upload
¢d    *                    format
¢d    *                   -Added branch hours, fax nbr, after hours phone
¢d    *                    nbr, alternate phone nbr
¢e    *  012615 CLP 7024  Modified ARCD70 logic so it can be used to
¢e    *                   identify branches to upload to mobile app and also
¢e    *                   to merge consignment branch inventory for web
¢e    *                   services
¢f    *  050918 CLP 6709  Added item stock code to the end of the data
¢f    *                   feed
¢g    *  072018 CLP 6722  Added new Honeywell commercial vendor nbr
     F*====================MINCRON UPGRADE TO 12.1============================*/
¢h    *  082918 CLP 12.2  Modified to send all stocked items and non-stock
¢h    *                   items if there is qty available
¢i    *  040919 CLP 6793  Removed requirement for item to be on a price sheet
¢i    *                   to write the MEITM record
¢j    *  091720 KSB 8087  Add new versions of Item/Br & Item Master
¢k    *  101520 KSB 8101  Add sell UOM to new version Item/BR file
¢l    *  111220 KSB 8111  Add Avatax Code to Item/BR file
¢m    *  032822 APB 9275  Add the following fields: DNR, selling UOM, AVATAX
¢m    *                   code, superseded item to MEBITM file
¢n    *  051922 APB 9282  Modify mebitm to include items reguardless of QOH
¢n    *                   and item stocked code.
¢o    *  082422 APB 9294  Add supersede item numbers to Item Availability
¢o    *                   file, MEBITM, for Ecomm.
¢p    *  090622 APB 9298  Create new supersede file to replace MEBITM file
¢q    *  110122 APB 9310  Create new UOM file for Ecomm.
¢r    *  022823 CLP 5064  Added selection on IVCD91='Y' for MEUOM records
¢s    *  042926 JJF       Add new table to hold slow and excessive flags by item
      **********************************************************************
      * Indicators
      *
      * Ind   Function/Description
      * ---   --------------------------------------------------------------
      *
      **********************************************************************

      *== Display File/Primary File ========================================
      * None

      *== Input Only Files =================================================
      * All files are accessed via SQL

      *== Reports ==========================================================
      * None

      **********************************************************************

      *== Data Structures ==================================================
      * None

      *== Arrays/Tables ====================================================
      * None

      *== Constants ========================================================
      * None

      *== Work Fields ======================================================
¢s   D ESNO07          S              6P 0
¢s   D ESCD05          S              1A
¢s   D ESCD04          S              1A
¢s   D ESCLASS         S              2A
¢s   D item            S              6P 0
¢s   D slow            S              1A
¢s   D excess          S              1A
¢s   D class           S              2A
¢s   D csvLine         S            100A


       dcl-s ifsString varchar(256) inz;
       dcl-s tableName varchar(256) inz;

      /EJECT
      **********************************************************************
      * Mainline
      **********************************************************************

      * Populate the Branch Master
¢e   C/Exec SQL
¢e    + INSERT into MEBRN
¢e    + SELECT 'EC', 'EC', char(b.ARNO16), trim(b.ARNM07), b.ARAD10,
¢e    +   Trim(b.ARAD11|| ' ' ||b.ARAD12), b.ARCY04,b.ARST04,b.ARZP18,
¢e    +   '('||trim(char(b.ARNO17))||')'||' '||Digits(b.ARNO18)
¢e    +   ||'-'||Digits(b.ARNO19), char(c.latitude),char(c.longitude),
¢e    +   case when c.mhfaxarea=0 or c.mhfaxpref=0 or c.mhfaxsuff=0 then ' '
¢e    +   else '('||trim(char(c.mhfaxarea))||')'||' '||Digits(c.mhfaxpref)
¢e    +   ||'-'||Digits(c.mhfaxsuff) end,
¢e    +   trim(c.mhmonopen),trim(c.mhmonclose),
¢e    +   trim(c.mhtueopen),trim(c.mhtueclose),
¢e    +   trim(c.mhwedopen),trim(c.mhwedclose),
¢e    +   trim(c.mhthuopen),trim(c.mhthuclose),
¢e    +   trim(c.mhfriopen),trim(c.mhfriclose),
¢e    +   trim(c.mhsatopen),trim(c.mhsatclose),
¢e    +   trim(c.mhsunopen),trim(c.mhsunclose),
¢e    +   case when c.mhaftarea=0 or c.mhaftpref=0 or c.mhaftsuff=0 then ' '
¢e    +   else '('||trim(char(c.mhaftarea))||')'||' '||Digits(c.mhaftpref)
¢e    +   ||'-'||Digits(c.mhaftsuff) end,' ','1'
¢e    + FROM arpmbch b inner join arpmbrx c on (b.arno16 = c.arno16)
¢e    + WHERE b.ARFL16 <> 'C'
¢e    + ORDER BY b.arno16
¢e   C/End-Exec
¢d
¢d    * Populate the Branch Master Flat File with headings
¢d   C/Exec SQL
¢d    + INSERT into mebrnf
¢d    + SELECT
¢d    +  trim(hdg1)||','||trim(hdg2)||','||trim(hdg3)||','||trim(hdg4)||','||
¢d    +  trim(hdg5)||','||trim(hdg6)||','||trim(hdg7)||','||trim(hdg8)||','||
¢d    +  trim(hdg9)||','||trim(hdg10)||','||trim(hdg11)||','||trim(hdg12)||','||
¢d    +  trim(hdg13)||','||trim(hdg14)||','||trim(hdg15)||','||
¢d    +  trim(hdg16)||','||trim(hdg17)||','||trim(hdg18)||','||
¢d    +  trim(hdg19)||','||trim(hdg20)||','||trim(hdg21)||','||
¢d    +  trim(hdg22)||','||trim(hdg23)||','||trim(hdg24)||','||
¢d    +  trim(hdg25)||','||trim(hdg26)||','||trim(hdg27)||','||
¢d    +  trim(hdg28)
¢d    + FROM mebrnh
¢d   C/End-Exec
¢d
¢d    * Populate the Branch Master Flat File
¢d   C/Exec SQL
¢d    + INSERT into mebrnf
¢d    + SELECT
¢d    +  EBBNO||','||
¢d    +  translate(trim(EBNAME),'    ','/,;"''''')||','||
¢d    +  translate(trim(EBADD1),'    ','/,;"''''')||','||
¢d    +  translate(trim(EBADD2),'    ','/,;"''''')||','||
¢d    +  translate(trim(EBCITY),'    ','/,;"''''')||','||
¢d    +  trim(EBSTE)||','||trim(EBZIP)||','||
¢d    +  trim(EBPHONE)||','||
¢d    +  trim(ELATITUDE)||','||trim(ELONGITUDE)||','||
¢d    +  trim(EBFAX)||','||
¢d    +  case when EBMONOPEN=' ' then '00:00 '
¢d    +            else trim(EBMONOPEN) end||','||
¢d    +  case when EBMONCLOSE=' ' then '00:00 '
¢d    +            else trim(EBMONCLOSE) end||','||
¢d    +  case when EBTUEOPEN=' ' then '00:00 '
¢d    +            else trim(EBTUEOPEN) end||','||
¢d    +  case when EBTUECLOSE=' ' then '00:00 '
¢d    +            else trim(EBTUECLOSE) end||','||
¢d    +  case when EBWEDOPEN=' ' then '00:00 '
¢d    +            else trim(EBWEDOPEN) end||','||
¢d    +  case when EBWEDCLOSE=' ' then '00:00 '
¢d    +            else trim(EBWEDCLOSE) end||','||
¢d    +  case when EBTHUOPEN=' ' then '00:00 '
¢d    +            else trim(EBTHUOPEN) end||','||
¢d    +  case when EBTHUCLOSE=' ' then '00:00 '
¢d    +            else trim(EBTHUCLOSE) end||','||
¢d    +  case when EBFRIOPEN=' ' then '00:00 '
¢d    +            else trim(EBFRIOPEN) end||','||
¢d    +  case when EBFRICLOSE=' ' then '00:00 '
¢d    +            else trim(EBFRICLOSE) end||','||
¢d    +  case when EBSATOPEN=' ' then '00:00 '
¢d    +            else trim(EBSATOPEN) end||','||
¢d    +  case when EBSATCLOSE=' ' then '00:00 '
¢d    +            else trim(EBSATCLOSE) end||','||
¢d    +  case when EBSUNOPEN=' ' then '00:00 '
¢d    +            else trim(EBSUNOPEN) end||','||
¢d    +  case when EBSUNCLOSE=' ' then '00:00 '
¢d    +            else trim(EBSUNCLOSE) end||','||
¢d    +  trim(EBAFTPHONE)||','||trim(EBALTPHONE)||','||
¢d    +  EBFLG
¢d    + FROM mebrn
¢d   C/End-Exec

¢i    * Populate the Products w/Web Commerce Desc first
¢i   C/Exec SQL
¢i    + INSERT into meitm
¢i    + SELECT distinct
¢i    +    'EC', 'EC', Char(a.IVNO07),e.ivdscl,b.IVNO04, b.ivno93, 'Y'
¢i    + FROM ivpmsbr a
¢i    + INNER JOIN ivpmstr b on (a.ivno07 = b.ivno07)
¢i    + INNER JOIN arpmbch c on (a.IVNO10 = c.ARNO16)
¢i    + INNER JOIN ivpedsc e on (a.ivno07 = e.ivno07)
¢i    + WHERE b.ivcd25 <> 'D' and b.IVCDIN = 'Y' and ivdscl <> ' '
¢i    +    and b.ivcd17 not in ('FEE', 'GCP', 'ASA', 'OBS')
¢i    +    and b.ivcd18 not in ('EMB')
¢i    +    and b.ivcd14 not in ('MAN', 'MAU', 'TOL') and
¢i    +    b.ivdn01 not like '%DO NOT USE%' and
¢i    +    b.ivdn01 not like '%LABOR%' and
¢i    +    b.ivdn01 not like '%OBSO%' and  ivcdc8 = ' ' and
¢i    +    b.ivcd24 <> 'Y'
¢i    +    and char(a.IVNO10) in (select EBBNO from mebrn)
¢i   C/End-Exec

¢i    * Populate the Products w/Desc from Item Mst if no Web Desc
¢i   C/Exec SQL
¢i    + INSERT into meitm
¢i    + SELECT distinct
¢i    +    'EC', 'EC', Char(a.IVNO07),b.ivdn01,b.IVNO04, b.ivno93, 'Y'
¢i    + FROM ivpmsbr a
¢i    + INNER JOIN ivpmstr b on (a.ivno07 = b.ivno07)
¢i    + INNER JOIN arpmbch c on (a.IVNO10 = c.ARNO16)
¢i    + INNER JOIN ivpedsc e on (a.ivno07 = e.ivno07)
¢i    + WHERE b.ivcd25 <> 'D' and b.IVCDIN = 'Y' and ivdscl = ' '
¢i    +    and b.ivcd17 not in ('FEE', 'GCP', 'ASA', 'OBS')
¢i    +    and b.ivcd18 not in ('EMB')
¢i    +    and b.ivcd14 not in ('MAN', 'MAU', 'TOL') and
¢i    +    b.ivdn01 not like '%DO NOT USE%' and
¢i    +    b.ivdn01 not like '%LABOR%' and
¢i    +    b.ivdn01 not like '%OBSO%' and  ivcdc8 = ' ' and
¢i    +    b.ivcd24 <> 'Y'
¢i    +    and char(a.IVNO10) in (select EBBNO from mebrn)
¢i   C/End-Exec

      * Populate the Products with Malco Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'Malco ' || EIDSC where
      + EIDSC not like '%MALCO%' and EIDSC not like '%Malco%' and exists
      + (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 15731)
     C/End-Exec

      * Populate the Products with Goodman Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'Goodman ' || EIDSC where
      + EIDSC not like '%GOODMAN%' and EIDSC not like '%Goodman%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 14158)
     C/End-Exec

      * Populate the Products with Goodman Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'Goodman ' || EIDSC where
      + EIDSC not like '%GOODMAN%' and EIDSC not like '%Goodman%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 14141)
     C/End-Exec

      * Populate the Products with Amana Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'Amana ' || EIDSC where
      + EIDSC not like '%AMANA%' and EIDSC not like '%Amana%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 23729)
     C/End-Exec

      * Populate the Products with Amana Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'AMANA ' || EIDSC where
      + EIDSC not like '%AMANA%' and EIDSC not like '%Amana%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 22389)
     C/End-Exec

¢g   C/Exec SQL
¢g    + update meitm a set eidsc = 'Honeywell ' || EIDSC where
¢g    + EIDSC not like '%HONEYWELL%'
¢g    + and EIDSC not like '%Honeywell%' and exists
¢g    +  (select * from ivpmstr where ivno04 = a.eiprd and
¢g    +  (ivno05 = 20306 or ivno05 = 33965))
¢g   C/End-Exec

      * Populate the Products with White Rodgers Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'White Rodgers ' || EIDSC where
      + EIDSC not like '%WHITE RODGERS %'
      + and EIDSC not like '%White Rodgers%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 23460)
     C/End-Exec

      * Populate the Products with Ecobee Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'Ecobee ' || EIDSC where
      + EIDSC not like '%ECOBEE%'
      + and EIDSC not like '%Ecobee%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 30751)
     C/End-Exec

      * Populate the Products with Daikin Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'Daikin ' || EIDSC where
      + EIDSC not like '%DAIKIN%'
      + and EIDSC not like '%Daikin%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 26910)
     C/End-Exec

      * Populate the Products with Gree Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'Gree ' || EIDSC where
      + EIDSC not like '%GREE%'
      + and EIDSC not like '%Gree%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 26298)
     C/End-Exec

      * Populate the Products with Aprilaire Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'Aprilaire ' || EIDSC where
      + EIDSC not like '%APRILAIRE%'
      + and EIDSC not like '%Aprilaire%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 17361)
     C/End-Exec

      * Populate the Products with EWC Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'EWC ' || EIDSC where
      + EIDSC not like '%EWC %' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 23466)
     C/End-Exec

      * Populate the Products with Fieldpiece Descriptions
     C/Exec SQL
      + update meitm a set eidsc = 'Fieldpiece ' || EIDSC where
      + EIDSC not like '%FIELDPIECE%'
      + and EIDSC not like '%Fieldpiece%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 29915)
     C/End-Exec

      * Populate the Products with Owens Corning Description
     C/Exec SQL
      + update meitm a set eidsc = 'Owens Corning ' || EIDSC where
      + EIDSC not like '%OWENS CORNING%'
      + and EIDSC not like '%Owens Corning%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 26321)
     C/End-Exec

      * Populate the Products with Duro Dyne Description
     C/Exec SQL
      + update meitm a set eidsc = 'Duro Dyne ' || EIDSC where
      + EIDSC not like '%DURO DYNE%'
      + and EIDSC not like '%Duro Dyne%' and exists
      +  (select * from ivpmstr where ivno04 = a.eiprd and ivno05 = 13411)
     C/End-Exec

      * Populate the Products Master Flat File
     C/Exec SQL
      + insert into meitmf
      + SELECT ':`:'||eibsU||':`:,:`:'||eicno||':`:,:`:'||trim(eiitm)||
      + ':`:,:`:'||translate(trim(eidsc),'    ','/,;"''''')||':`:,:`:'||
      + translate(trim(eiprd),'    ','/,;"''''')||':`:,:`:'||
      + translate(TRIM(eiMFG),'    ','/,;"''''')||':`:,:`:'||
      + eiflg||':`:'
      + FROM meitm
     C/End-Exec

      * Populate the Aliases
     C/Exec SQL
      + INSERT into mealias
      + SELECT 'EC', 'EC',char(ivno07),IVNO41,'Y'
      + FROM ivpmali
      + WHERE IVNO07 in (select distinct EIITM from meitm)
     C/End-Exec

      * Delete the duplicate aliases
     C/Exec SQL
      + Delete from MEALIAS a
      + where rrn(a) > (select min(rrn(b))
      + FROM MEALIAS b
      + WHERE A.EAALI = B.EAALI and a.EAITM <> B.EAITM )
     C/End-Exec

      * Populate the Aliases Master Flat File
     C/Exec SQL
      + insert into mealiasf
      + SELECT ':`:'||eaBsU||':`:,:`:'||eacno||':`:,:`:'||trim(eaITM)||
      + ':`:,:`:'||translate(trim(eaali),'    ','/,;"''''')||':`:,:`:'||
      + eaflg||':`:'
      + FROM mealias
     C/End-Exec

      * Populate the Availability
¢h ¢m //C/Exec SQL
¢h ¢m // + INSERT into mebitm
¢h ¢m // + SELECT 'EC','EC',char(IVNO10),char(IVNO07),int(IVQY23),IVCD11
¢h ¢m // + FROM ivpmsbr
¢h ¢m // + WHERE IVNO07 in (select distinct EIITM from meitm)
¢h ¢m // +    and IVNO10 in (select EBBNO from mebrn)
¢h ¢m // +    and (IVCD11='Y' or IVQY23 > 0)
¢h ¢m //C/End-Exec

¢m ¢n //C/Exec SQL
¢m ¢n //+ INSERT into mebitm
¢m ¢n //+ SELECT 'EC','EC',char(a.IVNO10),char(a.IVNO07),
¢m ¢n //+  int(a.IVQY23),a.IVCD11,a.IMCD64,b.ivdn21,
¢m ¢n //+  case when c.optx20 is NULL then ' ' else c.optx20 end,
¢m ¢n //+  0
¢m ¢n //+ FROM ivpmsbr a
¢m ¢n //+ INNER JOIN ivpmuom b on (a.ivno07 = b.ivno07)
¢m ¢n //+ LEFT  join ivpmsta c on B.ivno07 = c.ivno07 and
¢m ¢n //+ 'ITMTAXCODE'=c.opnm25 and 'A'=c.opcd34
¢m ¢n //+ WHERE a.IVNO07 in (select distinct EIITM from meitm)
¢m ¢n //+    and a.IVNO10 in (select EBBNO from mebrn)
¢m ¢n //+    and b.ivcd08 = 'O'
¢m ¢n //+    and (a.IVCD11='Y' or a.IVQY23 > 0)
¢m ¢n //C/End-Exec

¢m ¢n //C/Exec SQL
¢m ¢n // + UPDATE mebitm
¢m ¢n // + SET eqsup = (select ivnob6 from ivpmrep t where eqbno = ivnob8
¢m ¢n // +   and eqitm = ivnob7 and ivcdg8='Y' and ivcdg7 <> 'Y')
¢m ¢n // + WHERE exists(select * from ivpmrep t where eqbno = ivnob8
¢m ¢n // +   and eqitm = ivnob7 and ivcdg8='Y' and ivcdg7 <> 'Y') and
¢m ¢n // +   eqdnr = 'Y'
¢m ¢n //C/End-Exec

¢n ¢o // C/Exec SQL
¢n ¢o //  + UPDATE mebitm
¢n ¢o //  + SET eqsup = (select ivnob6 from ivpmrep t where eqbno = ivnob8
¢n ¢o //  +   and eqitm = ivnob7 and ivcdg8='Y' and ivcdg7 <> 'Y')
¢n ¢o //  + WHERE exists(select * from ivpmrep t where eqbno = ivnob8
¢n ¢o //  + and eqitm = ivnob7 and ivcdg8='Y')
¢n ¢o // C/End-Exec

¢o ¢p // C/Exec SQL
¢o ¢p //  + UPDATE mebitm
¢o ¢p //  + SET eqsup = (select ivnob6 from ivpmrep t where eqbno = ivnob8
¢o ¢p //  +   and eqitm = ivnob7 and ivcdg8='Y' and ivcdg7 <> 'Y')
¢o ¢p //  + WHERE exists(select * from ivpmrep t where eqbno = ivnob8
¢o ¢p //  +   and eqitm = ivnob7 and ivcdg8='Y' and ivcdg7 <> 'Y')
¢o ¢p // C/End-Exec

      * Populate the Supersede File
¢p   C/Exec SQL
¢p    + INSERT into mebsup
¢p    + SELECT IVNOB8, IVNOB7, IVNOB6,
¢p    + case when c.optx20 is NULL then ' ' else c.optx20 end as taxcode
¢p    + FROM ivpmrep a
¢p    + LEFT  join ivpmsta c on a.ivnob7 = c.ivno07 and
¢p    + 'ITMTAXCODE'=c.opnm25 and 'A'=c.opcd34
¢p   C/End-Exec

      * Populate the Availability Flat File
   ¢p // C/Exec SQL
   ¢p //  + insert into mebitmf
   ¢p //  + SELECT
   ¢p //  + ':`:'||eqbsu||':`:,:`:'||eqcno||':`:,:`:'||eqbno||':`:,:`:'||
   ¢p //  + trim(eqITM)||':`:,:`:'||trim(eqavl)||':`:,:`:'||eqavc||':`:'
   ¢p //  + FROM mebitm
   ¢p // C/End-Exec

      * Populate the UPC Codes
     C/Exec SQL
      + INSERT into meupc
      + SELECT 'EC','EC',char(IVNO07), IVNO84,'Y'
      + FROM IVPMPCK
      + WHERE IVNO07 in (select distinct EIITM from meitm)
     C/End-Exec

      * Populate the UPC Flat File
     C/Exec SQL
      + insert into meupcf
      + SELECT ':`:'||eubsU||':`:,:`:'||eucno||':`:,:`:'||
      + trim(euitm)||':`:,:`:'||TRIM(euUPC)||':`:,:`:'||euflg||':`:'
      + FROM meupc
     C/End-Exec

      * Populate the Item/Br Availability NEW File

¢j   C/Exec SQL
¢k    + INSERT into mebitmn
¢k    + SELECT 'EC','EC',char(a.IVNO10),char(a.IVNO07),
¢k ¢l +  int(a.IVQY23),a.IVCD11,a.IMCD64,b.ivdn21,
¢l    +  case when c.optx20 is NULL then ' ' else c.optx20 end
¢k    + FROM ivpmsbr a
¢k    + INNER JOIN ivpmuom b on (a.ivno07 = b.ivno07)
¢l    + LEFT  join ivpmsta c on B.ivno07 = c.ivno07 and
¢l    + 'ITMTAXCODE'=c.opnm25 and 'A'=c.opcd34
¢k    + WHERE a.IVNO07 in (select distinct EIITM from meitm)
¢k    +    and a.IVNO10 in (select EBBNO from mebrn)
¢k    +    and b.ivcd08 = 'O'
¢k    +    and (a.IVCD11='Y' or a.IVQY23 > 0)
¢k   C/End-Exec


¢q    * Populate the Unit of Measure item file
¢q
¢q   C/Exec SQL
¢q    + INSERT into meuom
¢q    + SELECT distinct ivno07, IVDN21, IVQY12, tbno03
¢q    + FROM ivpmuom a
¢q    + inner join tbpmtbl b on ivdn21=tbno02 and tbno01='IV40'
¢r    + Where a.ivcd91='Y'
¢q    + order by ivno07, ivdn21, ivqy12, tbno03
¢q   C/End-Exec


¢s
¢s      // Create slow items CSV file with header
¢s      tableName = '/B2B/Out/slowItems.csv';
¢s      ifsString = 'Our Item,Slow Future,Excess Future,ESD Code';
¢s      exec sql
¢s        CALL QSYS2.IFS_WRITE(
¢s           :tableName,
¢s           :ifsString,
¢s          FILE_CCSID => 1208,
¢s          OVERWRITE  => 'REPLACE'
¢s        );
¢s
¢s      // Declare and open cursor for slow items
¢s      exec sql
¢s        DECLARE slowCur CURSOR FOR
¢s        SELECT ESNO07, ESCD05, ESCD04, ESCLASS
¢s        FROM ESDFILE;
¢s
¢s      exec sql OPEN slowCur;
¢s
¢s      // Fetch and write each row to CSV
¢s      dou SQLCOD <> 0;
¢s        exec sql FETCH slowCur INTO :item, :slow, :excess, :class;
¢s
¢s        if SQLCOD = 0;
¢s          ifsString = %trim(%editc(item:'X')) + ',' +
¢s                      %trim(slow) + ',' +
¢s                      %trim(excess) + ',' +
¢s                      %trim(class);
¢s
¢s          exec sql
¢s            CALL QSYS2.IFS_WRITE(
¢s              :tableName,
¢s              :ifsString,
¢s              FILE_CCSID => 1208,
¢s              OVERWRITE  => 'APPEND'
¢s            );
¢s        endif;
¢s      enddo;

¢s      // Close cursor
¢s      exec sql CLOSE slowCur;



     C                   EVAL      *InLR = *ON

      /EJECT
      **********************************************************************
      * *INZSR - Initialization Subroutine
      **********************************************************************

     C     *INZSR        BEGSR
     C                   ENDSR


