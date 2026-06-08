      *---------------------------------------------------------------------*
      * NAME : ARSINVSR                                                     *
      *---------------------------------------------------------------------*
      * Create ARS Invoices as .csv in IFS for Coupa integration            *
      *---------------------------------------------------------------------*
      * TASK       DATE   ID  DESCRIPTION                                   *
      * ---------- ------ --- ----------------------------------------------*
      * 5137       041425 CLP Initial pgm                                   *
¢A    * 5144       050825 CLP -Send 0 for PO line nbr and use edit code M   *
¢A    *                        for numeric fields                           *
¢A    *                       -Corrected issue to avoid resending invoices  *
¢A    *                        already pushed to Coupa                      *
¢B    * 5145       052225 CLP When place the negative sign on the left of   *
¢B    *                        qty and price if negative                    *
¢C    * 5149       052725 CLP -Corrected the edit code for amounts and qtys *
¢C    *                       -Default EA for UOM                           *
¢C    *                       -Added new Submit for Approval? column with   *
¢C    *                        Default Yes                                  *
¢D    * 5151       061825 CLP Removed Sibmit for Approval? column           *
¢E    * 5161       121625 CLP -Corrected invoice line nbr to be included    *
¢E    *                       -scan/replace " to avoid loading issues in    *
¢E    *                        Coupa                                        *
¢E    *                       -Added back the Submit For Approval column    *
¢F    * 3207       060526 JJF -Corrected sort order by invoice and PO seq   *
      *---------------------------------------------------------------------*
       CTL-OPT option(*srcstmt:*nodebugio) dftactgrp(*no)
           Debug(*yes);

       DCL-F OELTORY1 Disk
             keyed
             Usage(*Input);

      // --------------------------------------------------------------------
      // Program information
      // --------------------------------------------------------------------
         Dcl-ds psds PSDS qualified;
          @pgm char(10) pos(1);
          @parms *PARMS;
          @msgid char(4) pos(171);
          @job char(10) pos(244);
          @user char(10) pos(254);
          @job# zoned(6) pos(264);
         End-ds;

      // --------------------------------------------------------------------
      // Field definitions
      // --------------------------------------------------------------------

         Dcl-s Char4 char(4) inz;
         Dcl-s Mo packed(2:0) inz;
         Dcl-s Yr packed(2:0) inz;
         Dcl-s HstOeno04 char(7);
         Dcl-s HstMo packed(2:0) inz;
         Dcl-s HstDy packed(2:0) inz;
         Dcl-s HstYr packed(2:0) inz;
         Dcl-s FindIt char(8) inz;
         Dcl-s HandlingAmt$ packed(9:2) inz;
         Dcl-s HandlingAmt char(15) inz;
         Dcl-s InvoiceNbr char(7) inz;
         Dcl-s IsCreditNote char(3) inz;
         Dcl-s ItemDesc char(32) inz;
         Dcl-s MiscAmt$ packed(9:2) inz;
         Dcl-s MiscAmt char(15) inz;
         Dcl-s PONbr char(22) inz;
         Dcl-s Price char(15) inz;
¢E       Dcl-s ProdNbr char(15) inz;
¢E       Dcl-s Manf# char(30) inz;
         Dcl-s Quantity char(15) inz;
         Dcl-s Seq packed(5:0) inz;
         Dcl-s ShippingAmt$ packed(9:2) inz;
         Dcl-s ShippingAmt char(15) inz;
         Dcl-s TaxAmt char(15) inz;
         Dcl-s WorkYear zoned(4:0) inz;

         Dcl-s commandString char(5000) inz;
         Dcl-s commandLength packed(15:5) inz;
         Dcl-s createOrInsert char(1) inz;
         Dcl-s dq char(1) inz('"');
         Dcl-s errorCode char(7) inz;
         Dcl-s firstHeaderComplete ind inz(*off);
         Dcl-s fullPath varchar(256) inz;
         Dcl-s headingString varchar(2000) inz;
         Dcl-s isodate date inz;
         Dcl-s i int(10:0) inz;
         Dcl-s ifsString varchar(5000) inz;
         Dcl-s maxItemLines packed(5:0) inz(10000);
         Dcl-s rowcount int(10:0) inz;
         Dcl-s pageTitle varchar(100) inz;
         Dcl-s prodTest char(10) inz;
         Dcl-s Q char(1) inz('''');
         Dcl-s tabName varchar(50) inz;
         Dcl-s tableName varchar(100) inz;

         Dcl-c CR CONST(X'0d');
         Dcl-c CRLF CONST(X'0d25');

         Dcl-c LowerCase 'abcdefghijklmnopqrstuvwxyz';
         Dcl-c UpperCase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

         Dcl-c C_ChartOfAccts CONST('AMERICAN RESIDENTIAL SERVICES LLC');
         Dcl-c C_Country CONST('US');
         Dcl-c C_Currency CONST('USD');
         Dcl-c C_ImageScanURL CONST(' ');
         Dcl-c C_LineLvlTax CONST('No');
         Dcl-c C_OriginalInvoiceNbr CONST(' ');
         Dcl-c C_OriginalInvoiceDate CONST(' ');
         Dcl-c C_RmtToCde CONST('ACH');
         Dcl-c C_SupplierNbr CONST('3793200');
         Dcl-c C_SupplierName CONST('East Coast Metal Dist LLC');
         Dcl-c C_UNSPSC CONST(' ');

       // -----------------------------------------------------------------
       // Entry parameter list prototype and declaration
       // -----------------------------------------------------------------
          Dcl-pr main extpgm('ARSINVSR');
           prCo        Char(3);
           prYr        Char(2);
           prMo        Char(2);
           prInv       Char(7);
           prFtp       Char(1);
           prIFSFile   Char(40);
          End-pr;

          Dcl-pi main;
           piCo        Char(3);
           piYr        Char(2);
           piMo        Char(2);
           piInv       Char(7);
           piFtp       Char(1);
           piIFSFile   Char(40);
          End-pi;

       // -----------------------------------------------------------------
       // --------------------- Prototypes --------------------------------
       // -----------------------------------------------------------------
          Dcl-pr $command extpgm('QCMDEXC');
           command_ char(5000);
           Length_  packed(15:5);
          End-pr;

          Dcl-pr getSqlDiagnostics char(256);
          End-pr;

       // -----------------------------------------------------------------
       // --------------------- Data Structures ---------------------------
       // -----------------------------------------------------------------
          Dcl-ds infds;
           choice char(1) pos(369);
           cursorLocation char(2) pos(370);
           currec int(5:0) pos(378);
          End-ds;

          Dcl-ds sqlDS qualified;
           ReturnedSqlCode   char(5);
           ReturnedSQLState  char(5);
           MessageLength int(5:0);
           MessageText char(32740);
           MessageId1 char(10);
           MessageId2 varchar(7);
           MessageId3 varchar(7);
          End-ds;

       // Invoice data structure
          Dcl-Ds C1 dim(10000) Qualified Inz;
           oeno01 char(7);
           arsact char(6);
           oeno07 char(22);
           oeam04 packed(9:2);
           oetl03 packed(9:2);
           oetl01 packed(9:2);
           rmtad1 char(30);
           rmtad2 char(30);
           rmtad3 char(30);
           rmtcty char(25);
           rmtst char(2);
           rmtzp char(10);
           oead01 char(30);
           oead02 char(30);
           oead03 char(30);
           oecy01 char(25);
           oest01 char(2);
           oezp03 char(10);
           oemo01 packed(2:0);
           oedy01 packed(2:0);
           oecc01 packed(2:0);
           oeyr01 packed(2:0);
           invdte char(10);
           oeno22 packed(3:0);
           ivno07 packed(6:0);
           ivno04 char(15);
           ivno93 char(30);
           ivdn01 char(32);
           oeqy03 packed(7:0);
           ivdn02 char(3);
           oecd43 char(1);
           oeam01 packed(8:2);
         End-Ds;

       // -----------------------------------------------------------------
       // --------------------- Main Program ------------------------------
       // -----------------------------------------------------------------

          // Title and headings initialization
          exec sql  set option commit=*none,datfmt=*iso,
                            closqlcsr=*ENDMOD;

          reset prodTest;
          exec sql
          select data_area_value
           into :prodTest
           from qsys2.data_area_info
            WHERE data_area_name = 'PRODTEST' and
            data_area_library = 'QGPL';

          tablename = 'ARS Invs_' + %trim(%char(%timestamp())) + '.csv';
          fullpath = '/home/Coupa/ARS Invoices/' + %trim(tablename);

           // this creates the document on ifs notice "REPLACE"
           Reset headingString;
           exec sql
            CALL QSYS2.IFS_WRITE(:FullPath,
                                 :headingString,
                                 FILE_CCSID => 1208,
                                 OVERWRITE => 'REPLACE');

          tabName = 'ARS Invoices';
          pageTitle = '(ARS Invoices)';

   ¢E     // Define the first line of column headings
   ¢E   //HeadingString = 'Invoice,Invoice Number*,Supplier Name,' +
   ¢E   //'Supplier Number,Invoice Date*,Handling Amount,Misc Amount,' +
   ¢E   //'Shipping Amount,Line Level Taxation*,Tax Amount,' +
   ¢E   //'Chart of Accounts*,Currency,Image Scan URL,Ship To Attention,' +
   ¢E   //'Ship To Street1,Ship To Street2,Ship To City,Ship To State,' +
   ¢E   //'Ship To Postal Code,Ship To Location Code,' +
   ¢E   //'Remit To Address Street1,Remit To Address Street2,' +
   ¢E   //'Remit To Address City,Remit To Address State,' +
   ¢E   //'Remit To Address Postal Code,Remit To Address Country Code,' +
   ¢E   //'Remit To Code,Original Invoice number,Original invoice date,' +
   ¢C   //'Is Credit Note,Supplier Note';
¢C ¢D   //'Is Credit Note,Supplier Note,Submit For Approval?';
¢D ¢E   //'Is Credit Note,Supplier Note';

¢E        // Define the first line of column headings
¢E        HeadingString = 'Invoice,Invoice Number*,Supplier Name,' +
¢E        'Supplier Number,Invoice Date*,Submit For Approval?,' +
¢E        'Handling Amount,Misc Amount,Shipping Amount,Line Level Taxation*,' +
¢E        'Tax Amount,Chart of Accounts*,Currency,Image Scan URL,' +
¢E        'Ship To Attention,Ship To Street1,Ship To Street2,Ship To City,' +
¢E        'Ship To State,Ship To Postal Code,Ship To Location Code,' +
¢E        'Remit To Address Street1,Remit To Address Street2,' +
¢E        'Remit To Address City,Remit To Address State,' +
¢E        'Remit To Address Postal Code,Remit To Address Country Code,' +
¢E        'Remit To Code,Original Invoice number,Original invoice date,' +
¢E        'Is Credit Note,Supplier Note';

          exec sql
          CALL QSYS2.IFS_WRITE(:FullPath,
                               :headingString,
                               FILE_CCSID => 1208,
                               OVERWRITE => 'REPLACE');

          // Define the second line of column headings
          headingString = 'Invoice Line,Invoice Number*,Supplier Name,' +
           'Supplier Number,Line Number,Description*,Supplier Part Number,' +
           'Auxiliary Part Number,Price*,Quantity,Unit of Measure*,' +
           'PO Number,PO Line Number,UNSPSC';

          exec sql
           CALL QSYS2.IFS_WRITE(:FullPath,
                                :headingString,
                                FILE_CCSID => 1208,
                                OVERWRITE => 'APPEND');

          // Initialize variables if needed
          Select;
¢A         When piInv <> '       ';
            Yr = 0;
            Mo = 0;
           When piYr <> ' ' and piMo <> ' ';
            Yr = %Dec(piYr:2:0);
            Mo = %dec(piMo:2:0);
           Other;
            Mo = %dec(%subdt(%date():*months):2:0);
            WorkYear = %subdt(%date():*years);
            Char4 = %char(WorkYear);
            Yr = %dec(%subst(Char4:3:2):2:0);
          Endsl;

          // Delete the temporary invoice history table
          Exec SQL
           Drop table qtemp/TmpHistory;

          // Create a temporary list of invoices already pushed to ARS
            Exec SQL
              Create table qtemp/TmpHistory as
               (Select oeno04,yr,mo,dy
                From ARSINVSHST)
              Definition only;

          // Clear the temporary list
            Exec SQL
              Delete from qtemp/TmpHistory;

          // If processing all invoices for the year/mo, include the history
          // to pick up only the invoices that have not been pushed already
¢A        If piInv = '       ';
   ¢A    //Exec SQL
   ¢A    // Select * into qtemp/TmpHistory
   ¢A    //  From ARSINVSHST;
¢A         Exec SQL
¢A          Insert into qtemp/TmpHistory
¢A           (Select * from ARSINVSHST);
          Endif;

          // Pull in the invoice header and detail information
          // d.oeno22 is PO sequece.. we may just need to sort by this.
         exec SQL
          declare  C1 scroll cursor for
          Select h.oeno01,cast(m.arsact as char(6)),
           replace(h.oeno07,',',' '),
           h.oeam04,h.oetl03,h.oetl01,
           replace(b.arad07,',',' '),replace(b.arad08,',',' '),
           replace(b.arad09,',',' '),replace(b.arcy03,',',' '),
           b.arst03,b.arzp17,
           replace(a.oead01,',',' '),replace(a.oead02,',',' '),
           replace(a.oead03,',',' '),replace(a.oecy01,',',' '),
           a.oest01,a.oezp03,
           h.oemo01,h.oedy01,h.oecc01,h.oeyr01,
           digits(h.oemo01)||'/'||digits(h.oedy01)||'/'||digits(h.oecc01)||
¢A ¢E    //digits(h.oeyr01),0,
¢E         digits(h.oeyr01),d.oeno22,
           case when d.ivno07 is null then 0 else d.ivno07 end,
           case when i.ivno04 is null then ' ' else i.ivno04 end,
           case when i.ivno93 is null then ' ' else
            replace(i.ivno93,',',' ') end,
           case when i.ivdn01 is null then ' ' else
            replace(i.ivdn01,',',' ') end,
           case when d.oeqy03 is null then 0 else d.oeqy03 end,
           case when d.ivdn02 is null then ' ' else d.ivdn02 end,
           case when d.oecd43 is null then ' ' else d.oecd43 end,
           case when d.oeam01 is null then 0 else d.oeam01 end
          From ARSCUSTS m inner join oeptohy h on m.arno01=h.arno01
           exception join qtemp/TmpHistory x on h.oeno01=x.oeno04
           inner join arpmbch b on h.oeno16=b.arno16
           left join oeptoay a on h.oeno01=a.oeno01
           left join OEPTOLY d on h.oeno01=d.oeno01
           left join ivpmstr i on d.ivno07=i.ivno07
          Where ((:piInv <> '       ' and :piInv = h.oeno01) or
          (h.oemo08=:Mo and h.oeyr08=:Yr)) and
           (d.oecd09<>'C' or d.oecd09 is null) and
           (d.oeqy03<>0 or d.oeqy03 is null)
¢F        Order by h.oeno01,d.oeno22
          for read only;

         Exec SQL open C1;
         Exec sql fetch first from C1 for :maxItemLines rows into :C1;
         Exec sql get diagnostics :rowCount = ROW_COUNT;

         Dow rowCount <> 0;
          If piIFSFILE = *blanks;
           piIFSFILE = TableName;
          Endif;
          For i = 1 to rowCount;

           // Prepare and write new invoice header
           If C1(i).oeno01 <> InvoiceNbr;
            Clear Seq;
            Clear HandlingAmt$;
            Clear ShippingAmt$;
            Clear MiscAmt$;
            InvoiceNbr = C1(i).oeno01;

            If C1(i).oetl01<0;
             IsCreditNote = 'Yes';
            Else;
             Clear IsCreditNote;
            Endif;

            // If there are detail lines include the other charges in the
            // header
            If C1(i).oetl03 <> 0 and C1(i).ivno07 <> 0;
             Exsr OtherChargesHeader;
            Endif;

¢C           HandlingAmt = %editc(HandlingAmt$:'Q');

¢C           MiscAmt = %editc(MiscAmt$:'Q');

¢C           ShippingAmt = %editc(ShippingAmt$:'Q');

¢C           TaxAmt = %editc(C1(i).oeam04:'Q');

            // Build out invoice header row
            ifsString = 'Invoice' + ',' + InvoiceNbr + ',' +
             C_SupplierName + ',' + C_SupplierNbr + ',' +
             C1(i).InvDte + ',' +
¢E           'Yes' + ',' +
             %trim(HandlingAmt) + ',' +
             %trim(MiscAmt) + ',' +
             %trim(ShippingAmt) + ',' +
             C_LineLvlTax + ',' +
             %trim(TaxAmt) + ',' +
             C_ChartOfAccts + ',' +
             C_Currency + ',' +
             C_ImageScanURL + ',' +
             %trim(C1(i).oead01) + ',' + %trim(C1(i).oead02) + ',' +
             %trim(C1(i).oead03) + ',' +  %trim(C1(i).oecy01) + ',' +
             %trim(C1(i).oest01) + ',' + %trim(C1(i).oezp03) + ',' +
             %trim(C1(i).arsact) + ',' +
             %trim(C1(i).rmtad2) + ',' + %trim(C1(i).rmtad3) + ',' +
             %trim(C1(i).rmtcty) + ',' + %trim(C1(i).rmtst) + ',' +
             %trim(C1(i).rmtzp) + ',' + C_Country + ',' +
             C_RmtToCde + ',' + C_OriginalInvoiceNbr + ',' +
             C_OriginalInvoiceDate + ',' + %trim(IsCreditNote) + ',' +
   ¢C      //%trim(C1(i).oeno07);
¢C ¢D      //%trim(C1(i).oeno07) + ',' + 'Yes';
¢D           %trim(C1(i).oeno07);

            // Write invoice header row
            ifsString = %scanrpl(',,':', ,':ifsString);
            Exec sql
             CALL QSYS2.IFS_WRITE(:FullPath,
                                  :ifsString,
                                  FILE_CCSID => 1208,
                                  OVERWRITE => 'APPEND');

           // Capture the invoices that are being pushed in the history file
            If piFtp = 'Y';
             HstOeno04 = C1(i).oeno01;
             HstYr = C1(i).oeyr01;
             HstMo = C1(i).oemo01;
             HstDy = C1(i).oedy01;

             Exec sql
              Insert into ARSINVSHST
               values (:HstOeno04,:HstYr,:HstMo,:HstDy);

            Endif;

           Endif;

           // Remove ship to location code from PO Nbr if there
           PoNbr = C1(i).oeno07;
           If PoNbr <> ' ';
            FindIt = %trim(C1(i).arsact) + '-';
            PoNbr = %scanrpl(%trim(FindIt):' ':PoNbr);
            FindIt = %trim(C1(i).arsact) + ' -';
            PoNbr = %scanrpl(%trim(FindIt):' ':PoNbr);
           EndIf;

           // Build out invoice detail row if there is detail
           If C1(i).ivno07 <> 0;

¢C          Quantity = %editc(C1(i).oeqy03:'Q');

            If C1(i).oecd43 = 'Y';
¢C           Price = %editc(0:'N');
            Else;
¢C           Price = %editc(C1(i).oeam01:'Q');
            EndIf;

           // Replace problematic chars with blank
           FindIt = '"';
           ItemDesc = %scanrpl(%trim(FindIt):' ':C1(i).ivdn01);
¢E         ProdNbr = %scanrpl(%trim(FindIt):' ':C1(i).ivno04);
¢E         Manf# = %scanrpl(%trim(FindIt):' ':C1(i).ivno93);

           Seq+=1;
           ifsString = 'Invoice Line' + ',' + InvoiceNbr + ',' +
            C_SupplierName + ',' + C_SupplierNbr + ',' +
            %trim(%editc(Seq:'X')) + ',' +
   ¢E     //%trim(ItemDesc) + ',' +  %trim(C1(i).ivno04) + ',' +
   ¢E     //%trim(C1(i).ivno93) + ',' + %trim(Price) + ',' +
¢E          %trim(ItemDesc) + ',' +  %trim(ProdNbr) + ',' +
¢E          %trim(Manf#) + ',' + %trim(Price) + ',' +
¢B ¢C     //%trim(Quantity) + ',' + %trim(C1(i).ivdn02) + ',' +
¢C          %trim(Quantity) + ',' + 'EA' + ',' +
            %trim(PoNbr) + ',' + %trim(%editc(C1(i).oeno22:'X')) + ',' +
            %trim(C_UNSPSC);

           // Write invoice detail row
           ifsString = %scanrpl(',,':', ,':ifsString);
           Exec sql
            CALL QSYS2.IFS_WRITE(:FullPath,
                                 :ifsString,
                                 FILE_CCSID => 1208,
                                 OVERWRITE => 'APPEND');
           Else;
            // If there are no detail lines but only other charges, write the
            // other charges as detail lines
            Exsr OtherChargesDetail;

           // Build out invoice detail row if there is detail
           Endif;

          Endfor;

          Exec SQL
          Fetch next from C1 for :maxItemLines rows into :C1;
          Exec sql get diagnostics :rowCount = ROW_COUNT;

         Enddo;
         Exec SQL close C1;

         // Delete the temporary invoice history table
         Exec SQL
          Drop table qtemp/TmpHistory;

         *inlr = *on;

       // -----------------------------------------------------------------
       // --------------------- Subroutines -------------------------------
       // -----------------------------------------------------------------
        Begsr OtherChargesDetail;

          // Read through the other charges to write invoice detail records
          Setll (InvoiceNbr) OELTORY1;
          Reade (InvoiceNbr) OELTORY1;
          DoW not %eof;

           // Add the other charges to the appropriate column
           OEDN03 = %xlate(lowercase:uppercase:OEDN03);

           // Replace problematic chars with blank
           FindIt = '"';
           ItemDesc = %scanrpl(%trim(FindIt):' ':OEDN03);
           FindIt = ',';
           ItemDesc = %scanrpl(%trim(FindIt):' ':ItemDesc);
¢C         Price = %editc(oeam03:'Q');

           Seq+=1;
           ifsString = 'Invoice Line' + ',' + InvoiceNbr + ',' +
            C_SupplierName + ',' + C_SupplierNbr + ',' +
            %trim(%editc(Seq:'X')) + ',' +
            %trim(ItemDesc) + ',' +  ' ' + ',' + ' ' + ',' +
            %trim(Price) + ',' +
¢A          %trim(%editc(1:'Q')) + ',' + 'EA' + ',' +
            %trim(PoNbr) + ',' + ' ' + ',' +
            %trim(C_UNSPSC);

           // Write invoice detail row
           ifsString = %scanrpl(',,':', ,':ifsString);
           Exec sql
            CALL QSYS2.IFS_WRITE(:FullPath,
                                 :ifsString,
                                 FILE_CCSID => 1208,
                                 OVERWRITE => 'APPEND');

          Reade (InvoiceNbr) OELTORY1;

          EndDo;

        Endsr;

        Begsr OtherChargesHeader;

          // Read through the other charges for the invoice
          Setll (InvoiceNbr) OELTORY1;
          Reade (InvoiceNbr) OELTORY1;
          DoW not %eof;

           // Add the other charges to the appropriate column
           OEDN03 = %xlate(lowercase:uppercase:OEDN03);

           // If there are detail lines for the invoice, load the other
           // into the header fields instead of writing detail lines for them
           If c1(i).ivno07 <> 0;
            Select;
             When oedn03 = 'FREIGHT CHARGE' or oedn03 = 'DELIVERY CHARGE';
              ShippingAmt$ = ShippingAmt$ + oeam03;
             When oedn03 = 'HANDLING CHARGE';
              HandlingAmt$ = HandlingAmt$ + oeam03;
             Other;
              MiscAmt$ = MiscAmt$ + oeam03;
            Endsl;
           Endif;

          Reade (InvoiceNbr) OELTORY1;

          EndDo;

        Endsr;
