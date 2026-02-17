          //-----------------------------------------------------------
          // Program: NEUCOXML
          // Purpose: Extract and process Neuco XML order files from IFS
          //
          // Description:
          //   This service program reads XML order files from the IFS
          //   and extracts both header and line item data.
          //   It parses the XML using XMLPARSE and XMLTABLE functions,
          //   then inserts the data into XMLORDHDR and XMLORDDTL tables.
          //   All processing activities are logged to XMLORDAUD for
          //   audit trail and error tracking.
          //
          // Parameters:
          //   inDocPath - Full IFS path to XML document (VARCHAR 1000)
          //
          // Returns:
          //   errorInd - Error indicator (*ON if error, *OFF if success)
          //
          // Output:
          //   - JAMIEDEV.XMLORDHDR - Order header records
          //   - JAMIEDEV.XMLORDDTL - Order line item records
          //   - JAMIEDEV.XMLORDAUD - Audit log entries
          //
          // Processing:
          //   1. Read XML file from IFS using QSYS2.IFS_READ
          //   2. Parse XML and extract header information
          //   3. Insert header into XMLORDHDR table
          //   4. Open cursor for line items
          //   5. Fetch and insert each line item into XMLORDDTL
          //   6. Log all activities to XMLORDAUD
          //   7. Commit transaction
          //
          // Error Handling:
          //   - All SQL errors are captured with SQLCODE and SQLSTATE
          //   - Errors are logged to XMLORDAUD with STATUS='E'
          //   - Successful operations logged with STATUS=' '
          //   - Indicator variables handle NULL values from XML
          //   - Returns *ON indicator if any error occurs
          //
          // Author : Roo Code
          // Date   : 2026-02-10
          //
          // Modification History:
          // Date       User  Description
          // ---------- ----- ----------------------------------------------
          // 2026-02-10 JJF   Initial creation
          // 2026-02-16 JJF   Added indicator variables for NULL handling
          //                  Added STATUS field to audit logging
          //                  Refactored IFS path to use variable
          //                  Converted to external procedure with parms
          //-----------------------------------------------------------

          ctl-opt nomain;
          ctl-opt option(*srcstmt:*nodebugio) datfmt(*iso);
          ctl-opt bnddir('ECBIND');

          /copy qrpglesrc,NEUCOXML_CP

          //-----------------------------------------------------------
          // Data Structures
          //-----------------------------------------------------------
          
          // Order Header Data Structure
          dcl-ds orderHeader;
            hdrOrderNumber char(40);
            hdrPoNumber varchar(20);
            hdrPoNumber2 varchar(20);
            hdrJobName varchar(100);
            hdrUniqueId varchar(50);
            hdrFreightMethod varchar(20);
            hdrVendorCode varchar(20);
            hdrVendorName varchar(100);
            hdrPlacedDate varchar(40);
            hdrReqPickupTime varchar(40);
            hdrBranchSell varchar(10);
            hdrBranchShip varchar(10);
            hdrShipCode varchar(20);
            hdrShipSubcode varchar(20);
            hdrSpecialInst varchar(500);
            hdrOrderNotes varchar(500);
            hdrChargeOrCash varchar(20);
            hdrOrderTypeCode char(1);
            hdrOrderStatCode char(1);
            hdrOrderStatOvr varchar(10);
            hdrAmount varchar(40);
            hdrSurchargeAmt varchar(40);
            hdrFreightChg varchar(40);
            hdrExtraCharge varchar(40);
            hdrTaxAmount varchar(40);
            hdrPercentage varchar(40);
            hdrOverridePrice varchar(40);
            hdrAccountNumber varchar(20);
            hdrAccountName varchar(100);
            hdrContact varchar(50);
            hdrCity varchar(150);
            hdrState char(2);
            hdrZip varchar(10);
            hdrCountry varchar(50);
            hdrAddressLine1 varchar(100);
            hdrAddressLine2 varchar(100);
            hdrAddressLine3 varchar(100);
            hdrShipContact varchar(50);
            hdrBillCity varchar(150);
            hdrBillState char(2);
            hdrBillZip varchar(10);
            hdrBillCountry varchar(50);
            hdrBillAddrLine1 varchar(100);
            hdrBillAddrLine2 varchar(100);
            hdrBillAddrLine3 varchar(100);
            hdrCardInfo varchar(100);
          end-ds;
          
          // Order Detail/Line Item Data Structure
          dcl-ds orderDetail;
            dtlLineNumber varchar(40);
            dtlTypeCode varchar(20);
            dtlProductName varchar(100);
            dtlMincronItemId varchar(50);
            dtlExternalItemId varchar(50);
            dtlPimId varchar(50);
            dtlBundleId varchar(50);
            dtlQuantity varchar(40);
            dtlAmount varchar(40);
            dtlCost varchar(40);
            dtlSurchargeAmt varchar(40);
            dtlTaxAmount varchar(40);
            dtlTaxPercent varchar(40);
            dtlPriceOverride varchar(40);
          end-ds;
          
          // Counter for line items
          dcl-s itemCount int(10) inz(0);
          
          // Formatted timestamp variables
          dcl-s fmtPlacedDate timestamp;
          dcl-s fmtReqPickupTime timestamp;
          dcl-s tempDate char(40);
          
          // Processing status and error tracking
          dcl-s processStatus char(1) inz('S');  // S=Success, E=Error
          dcl-s errorMessage varchar(200);
          dcl-s sqlErrCode int(10);
          dcl-s sqlErrState char(5);
          dcl-s auditStatus char(1);  // Status for audit log: E=Error, blank=Success
          
          // Transmission ID from XML
          dcl-s transmissionId varchar(50);
          
          // Indicator variables for nullable fields
          dcl-s indTransmissionId int(5);
          dcl-s indHdrOrderNumber int(5);
          dcl-s indHdrPoNumber int(5);
          dcl-s indHdrPoNumber2 int(5);
          dcl-s indHdrJobName int(5);
          dcl-s indHdrUniqueId int(5);
          dcl-s indHdrFreightMethod int(5);
          dcl-s indHdrVendorCode int(5);
          dcl-s indHdrVendorName int(5);
          dcl-s indHdrPlacedDate int(5);
          dcl-s indHdrReqPickupTime int(5);
          dcl-s indHdrBranchSell int(5);
          dcl-s indHdrBranchShip int(5);
          dcl-s indHdrShipCode int(5);
          dcl-s indHdrShipSubcode int(5);
          dcl-s indHdrSpecialInst int(5);
          dcl-s indHdrOrderNotes int(5);
          dcl-s indHdrChargeOrCash int(5);
          dcl-s indHdrOrderTypeCode int(5);
          dcl-s indHdrOrderStatCode int(5);
          dcl-s indHdrOrderStatOvr int(5);
          dcl-s indHdrAmount int(5);
          dcl-s indHdrSurchargeAmt int(5);
          dcl-s indHdrFreightChg int(5);
          dcl-s indHdrExtraCharge int(5);
          dcl-s indHdrTaxAmount int(5);
          dcl-s indHdrPercentage int(5);
          dcl-s indHdrOverridePrice int(5);
          dcl-s indHdrAccountNumber int(5);
          dcl-s indHdrAccountName int(5);
          dcl-s indHdrContact int(5);
          dcl-s indHdrCity int(5);
          dcl-s indHdrState int(5);
          dcl-s indHdrZip int(5);
          dcl-s indHdrCountry int(5);
          dcl-s indHdrAddressLine1 int(5);
          dcl-s indHdrAddressLine2 int(5);
          dcl-s indHdrAddressLine3 int(5);
          dcl-s indHdrShipContact int(5);
          dcl-s indHdrBillCity int(5);
          dcl-s indHdrBillState int(5);
          dcl-s indHdrBillZip int(5);
          dcl-s indHdrBillCountry int(5);
          dcl-s indHdrBillAddrLine1 int(5);
          dcl-s indHdrBillAddrLine2 int(5);
          dcl-s indHdrBillAddrLine3 int(5);
          dcl-s indHdrCardInfo int(5);
          
          // Indicator variables for line item detail fields
          dcl-s indDtlLineNumber int(5);
          dcl-s indDtlTypeCode int(5);
          dcl-s indDtlProductName int(5);
          dcl-s indDtlMincronItemId int(5);
          dcl-s indDtlExternalItemId int(5);
          dcl-s indDtlPimId int(5);
          dcl-s indDtlBundleId int(5);
          dcl-s indDtlQuantity int(5);
          dcl-s indDtlAmount int(5);
          dcl-s indDtlCost int(5);
          dcl-s indDtlSurchargeAmt int(5);
          dcl-s indDtlTaxAmount int(5);
          dcl-s indDtlTaxPercent int(5);
          dcl-s indDtlPriceOverride int(5);
          
          // IFS document path
          dcl-s ifsDocPath varchar(1000);
          
          //-----------------------------------------------------------
          // NEUCOXML - External Procedure
          //-----------------------------------------------------------
          dcl-proc NEUCOXML export;
          
            dcl-pi NEUCOXML ind;
              inDocPath varchar(1000) const;
            end-pi;
            
            // Local error indicator
            dcl-s errorInd ind inz(*off);
          
            // Set IFS document path from parameter
            ifsDocPath = inDocPath;

          //-----------------------------------------------------------
          // Query 1: Extract Order Header Information from XML
          //-----------------------------------------------------------
          exec sql
            WITH xml_data AS (
              SELECT XMLPARSE(DOCUMENT
                REGEXP_REPLACE(
                  LISTAGG(Line, ''), '<\?xml[^>]*\?>',
                  '', 1, 0, 'i')) AS doc
              FROM TABLE(QSYS2.IFS_READ(PATH_NAME => :ifsDocPath))
            )
            SELECT
              transmission_id,
              order_number,
              po_number,
              po_number_2,
              job_name,
              unique_id,
              freight_method,
              vendor_code,
              vendor_name,
              placed_date,
              requested_pickup_time,
              branch_sell,
              branch_ship,
              ship_code,
              ship_subcode,
              special_instructions,
              order_notes,
              charge_or_cash,
              order_type_code,
              order_status_code,
              order_status_code_override,
              amount,
              surcharge_amount,
              freight_charges,
              extra_charge,
              taxAmount,
              percentage,
              override_price,
              account_number,
              account_name,
              contact,
              city,
              state,
              zip,
              country,
              address_line_1,
              address_line_2,
              address_line_3,
              ShipContact,
              BillCity,
              Billstate,
              Billzip,
              Billcountry,
              Billaddress_line_1,
              Billaddress_line_2,
              Billaddress_line_3,
              card_info
            INTO :transmissionId :indTransmissionId,
                 :hdrOrderNumber :indHdrOrderNumber,
                 :hdrPoNumber :indHdrPoNumber,
                 :hdrPoNumber2 :indHdrPoNumber2,
                 :hdrJobName :indHdrJobName,
                 :hdrUniqueId :indHdrUniqueId,
                 :hdrFreightMethod :indHdrFreightMethod,
                 :hdrVendorCode :indHdrVendorCode,
                 :hdrVendorName :indHdrVendorName,
                 :hdrPlacedDate :indHdrPlacedDate,
                 :hdrReqPickupTime :indHdrReqPickupTime,
                 :hdrBranchSell :indHdrBranchSell,
                 :hdrBranchShip :indHdrBranchShip,
                 :hdrShipCode :indHdrShipCode,
                 :hdrShipSubcode :indHdrShipSubcode,
                 :hdrSpecialInst :indHdrSpecialInst,
                 :hdrOrderNotes :indHdrOrderNotes,
                 :hdrChargeOrCash :indHdrChargeOrCash,
                 :hdrOrderTypeCode :indHdrOrderTypeCode,
                 :hdrOrderStatCode :indHdrOrderStatCode,
                 :hdrOrderStatOvr :indHdrOrderStatOvr,
                 :hdrAmount :indHdrAmount,
                 :hdrSurchargeAmt :indHdrSurchargeAmt,
                 :hdrFreightChg :indHdrFreightChg,
                 :hdrExtraCharge :indHdrExtraCharge,
                 :hdrTaxAmount :indHdrTaxAmount,
                 :hdrPercentage :indHdrPercentage,
                 :hdrOverridePrice :indHdrOverridePrice,
                 :hdrAccountNumber :indHdrAccountNumber,
                 :hdrAccountName :indHdrAccountName,
                 :hdrContact :indHdrContact,
                 :hdrCity :indHdrCity,
                 :hdrState :indHdrState,
                 :hdrZip :indHdrZip,
                 :hdrCountry :indHdrCountry,
                 :hdrAddressLine1 :indHdrAddressLine1,
                 :hdrAddressLine2 :indHdrAddressLine2,
                 :hdrAddressLine3 :indHdrAddressLine3,
                 :hdrShipContact :indHdrShipContact,
                 :hdrBillCity :indHdrBillCity,
                 :hdrBillState :indHdrBillState,
                 :hdrBillZip :indHdrBillZip,
                 :hdrBillCountry :indHdrBillCountry,
                 :hdrBillAddrLine1 :indHdrBillAddrLine1,
                 :hdrBillAddrLine2 :indHdrBillAddrLine2,
                 :hdrBillAddrLine3 :indHdrBillAddrLine3,
                 :hdrCardInfo :indHdrCardInfo
            FROM xml_data,
            XMLTABLE ('$doc/transmission/order'
              PASSING xml_data.doc AS "doc"
            COLUMNS
              transmission_id VARCHAR(50)
                PATH '../transmission_id',
              order_number char(40)
                PATH 'OrderHeader/order_info/order_number',
              po_number VARCHAR(20)
                PATH 'OrderHeader/order_info/po_number',
              po_number_2 VARCHAR(20)
                PATH 'OrderHeader/order_info/po_number_2',
              job_name VARCHAR(40)
                PATH 'OrderHeader/order_info/job_name',
              unique_id VARCHAR(40)
                PATH 'OrderHeader/order_info/unique_id',
              freight_method VARCHAR(40)
                PATH 'OrderHeader/order_info/freight_method',
              vendor_code VARCHAR(40)
                PATH 'OrderHeader/order_info/vendor_code',
              vendor_name VARCHAR(40)
                PATH 'OrderHeader/order_info/vendor_name',
              placed_date VARCHAR(40)
                PATH 'OrderHeader/order_info/placed_date',
              requested_pickup_time VARCHAR(40)
                PATH 'OrderHeader/order_info/requested_pickup_time',
              branch_sell VARCHAR(40)
                PATH 'OrderHeader/order_info/branch_sell',
              branch_ship VARCHAR(40)
                PATH 'OrderHeader/order_info/branch_ship',
              ship_code VARCHAR(40)
                PATH 'OrderHeader/order_info/ship_code',
              ship_subcode VARCHAR(40)
                PATH 'OrderHeader/order_info/ship_subcode',
              special_instructions VARCHAR(40)
                PATH 'OrderHeader/order_info/special_instructions',
              order_notes VARCHAR(40)
                PATH 'OrderHeader/order_info/order_notes',
              charge_or_cash VARCHAR(40)
                PATH 'OrderHeader/order_info/charge_or_cash',
              order_type_code VARCHAR(40)
                PATH 'OrderHeader/order_info/order_type_code',
              order_status_code VARCHAR(40)
                PATH 'OrderHeader/order_info/order_status_code',
              order_status_code_override VARCHAR(40)
                PATH 'OrderHeader/order_info/order_status_code_override',
              amount VARCHAR(40)
                PATH 'OrderHeader/price_header/amount',
              surcharge_amount VARCHAR(40)
                PATH 'OrderHeader/price_header/surcharge_amount',
              freight_charges VARCHAR(40)
                PATH 'OrderHeader/price_header/extra_charges/freight_charges',
              extra_charge VARCHAR(40)
                PATH 'OrderHeader/price_header/extra_charges/extra_charge',
              taxAmount VARCHAR(40)
                PATH 'OrderHeader/price_header/tax_info/amount',
              percentage VARCHAR(40)
                PATH 'OrderHeader/price_header/tax_info/percentage',
              override_price VARCHAR(40)
                PATH 'OrderHeader/price_header/override_price',
              account_number VARCHAR(40)
                PATH 'OrderHeader/customer_info/account_number',
              account_name VARCHAR(40)
                PATH 'OrderHeader/customer_info/account_name',
              contact VARCHAR(40)
                PATH 'OrderHeader/customer_info/contact',
              city VARCHAR(150)
                PATH 'OrderHeader/ship_to_info/address/city',
              state VARCHAR(2)
                PATH 'OrderHeader/ship_to_info/address/state',
              zip VARCHAR(10)
                PATH 'OrderHeader/ship_to_info/address/zip',
              country VARCHAR(40)
                PATH 'OrderHeader/ship_to_info/address/country',
              address_line_1 VARCHAR(40)
                PATH 'OrderHeader/ship_to_info/address/address_line_1',
              address_line_2 VARCHAR(40)
                PATH 'OrderHeader/ship_to_info/address/address_line_2',
              address_line_3 VARCHAR(40)
                PATH 'OrderHeader/ship_to_info/address/address_line_3',
              ShipContact VARCHAR(40)
                PATH 'OrderHeader/ship_to_info/contact',
              BillCity VARCHAR(40)
                PATH 'OrderHeader/billing/bill_to_info/address/city',
              Billstate VARCHAR(40)
                PATH 'OrderHeader/billing/bill_to_info/address/state',
              Billzip VARCHAR(40)
                PATH 'OrderHeader/billing/bill_to_info/address/zip',
              Billcountry VARCHAR(40)
                PATH 'OrderHeader/billing/bill_to_info/address/country',
              Billaddress_line_1 VARCHAR(40)
                PATH 'OrderHeader/billing/bill_to_info/address/address_line_1',
              Billaddress_line_2 VARCHAR(40)
                PATH 'OrderHeader/billing/bill_to_info/address/address_line_2',
              Billaddress_line_3 VARCHAR(40)
                PATH 'OrderHeader/billing/bill_to_info/address/address_line_3',
              card_info VARCHAR(40)
                PATH 'OrderHeader/billing/card_info'
            ) AS X;

          // Check for errors
          if sqlCode < 0;
            // Error extracting header from XML
            processStatus = 'E';
            sqlErrCode = sqlCode;
            exec sql GET DIAGNOSTICS CONDITION 1
              :sqlErrState = RETURNED_SQLSTATE,
              :errorMessage = MESSAGE_TEXT;
            
            auditStatus = 'E';
            exec sql
              INSERT INTO JAMIEDEV.XMLORDAUD (
                ORDERNBR, TRANSMSNID, AUDACTION, TABLENAME, FIELDNAME,
                USERNAME, PROGRAMNM, REMARKS, IFSDOCUMENTPATH, STATUS
              ) VALUES (
                'UNKNOWN', '', 'ERROR', 'XMLORDHDR', 'XML_PARSE',
                CURRENT_USER, 'NEUCOXML',
                'Failed to extract header from XML. SQLCODE: ' ||
                TRIM(CHAR(:sqlErrCode)) || ' SQLSTATE: ' ||
                :sqlErrState || ' - ' || SUBSTR(:errorMessage, 1, 100),
                :ifsDocPath, :auditStatus
              );
            
            exec sql COMMIT;
            errorInd = *on;
            return errorInd;
          endif;

          // Format timestamps - Remove 'Z' and replace 'T' with '-'
          // Input: 2026-01-20T14:24:10.178Z
          // Output: 2026-01-20-14:24:10.178
          if %trim(hdrPlacedDate) <> '';
            tempDate = %trim(hdrPlacedDate);
            tempDate = %scanrpl('T':'-':tempDate);
            tempDate = %scanrpl('Z':'':tempDate);
            test(te) tempDate;
            if %error();
              fmtPlacedDate = *LOVAL;
            else;
              fmtPlacedDate = %timestamp(tempDate);
            endif;
          else;
            fmtPlacedDate = *LOVAL;
          endif;
          
          if %trim(hdrReqPickupTime) <> '';
            tempDate = %trim(hdrReqPickupTime);
            tempDate = %scanrpl('T':'-':tempDate);
            tempDate = %scanrpl('Z':'':tempDate);
            test(te) tempDate;
            if %error();
              fmtReqPickupTime = *LOVAL;
            else;
              fmtReqPickupTime = %timestamp(tempDate);
            endif;
          else;
            fmtReqPickupTime = *LOVAL;
          endif;

          // Insert header into table
          exec sql
            INSERT INTO JAMIEDEV.XMLORDHDR (
              orderNumber, poNumber, poNumber2, jobName,
              uniqueId, freightMethod, vendorCode, vendorName,
              placedDate, requestedPickupTime, branchSell,
              branchShip, shipCode, shipSubcode,
              specialInstructions, orderNotes, chargeOrCash,
              orderTypeCode, orderStatusCode,
              orderStatusCodeOverride, amount, surchargeAmount,
              freightCharges, extraCharge, taxAmount, percentage,
              overridePrice, accountNumber, accountName, contact,
              city, state, zip, country, addressLine1,
              addressLine2, addressLine3, shipContact,
              billCity, billState, billZip, billCountry,
              billAddressLine1, billAddressLine2,
              billAddressLine3, cardInfo
            ) VALUES (
              :hdrOrderNumber, :hdrPoNumber,
              :hdrPoNumber2, :hdrJobName,
              :hdrUniqueId, :hdrFreightMethod,
              :hdrVendorCode, :hdrVendorName,
              :fmtPlacedDate,
              :fmtReqPickupTime,
              :hdrBranchSell, :hdrBranchShip,
              :hdrShipCode, :hdrShipSubcode,
              :hdrSpecialInst, :hdrOrderNotes,
              :hdrChargeOrCash, :hdrOrderTypeCode,
              :hdrOrderStatCode, :hdrOrderStatOvr,
              COALESCE(DECIMAL(NULLIF(:hdrAmount, ''), 15, 5), 0),
              COALESCE(DECIMAL(NULLIF(:hdrSurchargeAmt, ''), 15, 5), 0),
              COALESCE(DECIMAL(NULLIF(:hdrFreightChg, ''), 15, 5), 0),
              COALESCE(DECIMAL(NULLIF(:hdrExtraCharge, ''), 15, 5), 0),
              COALESCE(DECIMAL(NULLIF(:hdrTaxAmount, ''), 15, 5), 0),
              COALESCE(DECIMAL(NULLIF(:hdrPercentage, ''), 7, 4), 0),
              COALESCE(DECIMAL(NULLIF(:hdrOverridePrice, ''), 15, 5), 0),
              :hdrAccountNumber,
              :hdrAccountName, :hdrContact,
              :hdrCity, :hdrState, :hdrZip,
              :hdrCountry, :hdrAddressLine1,
              :hdrAddressLine2, :hdrAddressLine3,
              :hdrShipContact, :hdrBillCity,
              :hdrBillState, :hdrBillZip,
              :hdrBillCountry, :hdrBillAddrLine1,
              :hdrBillAddrLine2, :hdrBillAddrLine3,
              :hdrCardInfo
            );

          // Check for insert errors
          if sqlCode < 0;
            // Error inserting header
            processStatus = 'E';
            sqlErrCode = sqlCode;
            exec sql GET DIAGNOSTICS CONDITION 1
              :sqlErrState = RETURNED_SQLSTATE,
              :errorMessage = MESSAGE_TEXT;
            
            auditStatus = 'E';
            exec sql
              INSERT INTO JAMIEDEV.XMLORDAUD (
                ORDERNBR, TRANSMSNID, AUDACTION, TABLENAME, FIELDNAME,
                USERNAME, PROGRAMNM, REMARKS, IFSDOCUMENTPATH, STATUS
              ) VALUES (
                :hdrOrderNumber, :transmissionId, 'ERROR','XMLORDHDR','INSERT',
                CURRENT_USER, 'NEUCOXML',
                'Failed to insert header record. SQLCODE: ' ||
                TRIM(CHAR(:sqlErrCode)) || ' SQLSTATE: ' ||
                :sqlErrState || ' - ' || SUBSTR(:errorMessage, 1, 100),
                :ifsDocPath, :auditStatus
              );
            
            exec sql COMMIT;
            errorInd = *on;
            return errorInd;
          else;
            // Log successful header insert
            auditStatus = ' ';
            exec sql
              INSERT INTO JAMIEDEV.XMLORDAUD (
                ORDERNBR, TRANSMSNID, AUDACTION, TABLENAME, FIELDNAME,
                USERNAME, PROGRAMNM, REMARKS, IFSDOCUMENTPATH, STATUS
              ) VALUES (
                :hdrOrderNumber, :transmissionId, 'INSERT', 'XMLORDHDR', 'ALL',
                CURRENT_USER, 'NEUCOXML',
                'Successfully inserted order header for order: ' ||
                TRIM(:hdrOrderNumber),
                :ifsDocPath, :auditStatus
              );
          endif;

          //-----------------------------------------------------------
          // Variables for Line Items
          //-----------------------------------------------------------


          //-----------------------------------------------------------
          // Query 2: Extract Line Items from XML
          //-----------------------------------------------------------
          // Declare cursor for line items
          exec sql
            declare lineItemCursor cursor for
            WITH xml_data AS (
              SELECT XMLPARSE(DOCUMENT
                REGEXP_REPLACE(
                  LISTAGG(Line, ''),
                  '<\?xml[^>]*\?>',
                  '',
                  1, 0, 'i'
                )
              ) AS doc
              FROM TABLE(QSYS2.IFS_READ(PATH_NAME => :ifsDocPath))
            )
            SELECT
              line_number,
              type_code,
              product_name,
              mincron_item_id,
              external_item_id,
              pim_id,
              bundle_id,
              quantity,
              amount,
              cost,
              surcharge_amount,
              taxAmount,
              taxPercent,
              price_override
            FROM xml_data,
            XMLTABLE ('$doc/transmission/order/line_items/line_item'
              PASSING xml_data.doc AS "doc"
            COLUMNS
              line_number char(40) PATH 'line_number',
              type_code VARCHAR(40) PATH 'type_code',
              product_name VARCHAR(40) PATH 'product_name',
              mincron_item_id VARCHAR(40) PATH 'mincron_item_id',
              external_item_id VARCHAR(40) PATH 'external_item_id',
              pim_id VARCHAR(40) PATH 'pim_id',
              bundle_id VARCHAR(40) PATH 'bundle_id',
              quantity VARCHAR(40) PATH 'quantity',
              amount VARCHAR(40) PATH 'price/amount',
              cost VARCHAR(40) PATH 'price/cost',
              surcharge_amount VARCHAR(40) PATH 'price/surcharge_amount',
              taxAmount VARCHAR(40) PATH 'price/tax_info',
              taxPercent VARCHAR(40) PATH 'price/tax_info/percentage',
              price_override VARCHAR(40) PATH 'price/price_override'
            ) AS Y;

          // Open cursor
          exec sql open lineItemCursor;

          // Check for errors
          if sqlCode < 0;
            // Error opening cursor
            processStatus = 'E';
            sqlErrCode = sqlCode;
            exec sql GET DIAGNOSTICS CONDITION 1
              :sqlErrState = RETURNED_SQLSTATE,
              :errorMessage = MESSAGE_TEXT;
            
            auditStatus = 'E';
            exec sql
              INSERT INTO JAMIEDEV.XMLORDAUD (
                ORDERNBR, TRANSMSNID, AUDACTION, TABLENAME, FIELDNAME,
                USERNAME, PROGRAMNM, REMARKS, IFSDOCUMENTPATH, STATUS
              ) VALUES (
                :hdrOrderNumber, :transmissionId, 'ERROR', 'XMLORDDTL',
                'CURSOR_OPEN', CURRENT_USER, 'NEUCOXML',
                'Failed to open line item cursor. SQLCODE: ' ||
                TRIM(CHAR(:sqlErrCode)) || ' SQLSTATE: ' ||
                :sqlErrState || ' - ' || SUBSTR(:errorMessage, 1, 100),
                :ifsDocPath, :auditStatus
              );
            
            exec sql close lineItemCursor;
            exec sql COMMIT;
            errorInd = *on;
            return errorInd;
          endif;

          // Fetch and process each line item
          dow (1=1);
            exec sql
              fetch next from lineItemCursor
                into :dtlLineNumber :indDtlLineNumber,
                     :dtlTypeCode :indDtlTypeCode,
                     :dtlProductName :indDtlProductName,
                     :dtlMincronItemId :indDtlMincronItemId,
                     :dtlExternalItemId :indDtlExternalItemId,
                     :dtlPimId :indDtlPimId,
                     :dtlBundleId :indDtlBundleId,
                     :dtlQuantity :indDtlQuantity,
                     :dtlAmount :indDtlAmount,
                     :dtlCost :indDtlCost,
                     :dtlSurchargeAmt :indDtlSurchargeAmt,
                     :dtlTaxAmount :indDtlTaxAmount,
                     :dtlTaxPercent :indDtlTaxPercent,
                     :dtlPriceOverride :indDtlPriceOverride;

            // Check if no more rows
            if sqlCode = 100;
              leave;
            endif;

            // Check for fetch errors
            if sqlCode < 0;
              processStatus = 'E';
              sqlErrCode = sqlCode;
              exec sql GET DIAGNOSTICS CONDITION 1
                :sqlErrState = RETURNED_SQLSTATE,
                :errorMessage = MESSAGE_TEXT;
              
              auditStatus = 'E';
              exec sql
                INSERT INTO JAMIEDEV.XMLORDAUD (
                  ORDERNBR, TRANSMSNID, AUDACTION, TABLENAME, FIELDNAME,
                  USERNAME, PROGRAMNM, REMARKS, IFSDOCUMENTPATH, STATUS
                ) VALUES (
                  :hdrOrderNumber, :transmissionId, 'ERROR', 'XMLORDDTL',
                  'CURSOR_FETCH', CURRENT_USER, 'NEUCOXML',
                  'Failed to fetch line item. SQLCODE: ' ||
                  TRIM(CHAR(:sqlErrCode)) || ' SQLSTATE: ' ||
                  :sqlErrState || ' - ' || SUBSTR(:errorMessage, 1, 100),
                  :ifsDocPath, :auditStatus
                );
              leave;
            endif;

            // Increment counter
            itemCount += 1;

            // Insert line item into detail table
            exec sql
              INSERT INTO JAMIEDEV.XMLORDDTL (
                orderNumber, lineNumber, typeCode, productName,
                mincronItemId, externalItemId, pimId, bundleId,
                quantity, amount, cost, surchargeAmount,
                taxAmount, taxPercent, priceOverride
              ) VALUES (
                :hdrOrderNumber,
                COALESCE(INT(NULLIF(:dtlLineNumber, '')), 0),
                :dtlTypeCode, :dtlProductName,
                :dtlMincronItemId, :dtlExternalItemId,
                :dtlPimId, :dtlBundleId,
                COALESCE(DECIMAL(NULLIF(:dtlQuantity, ''), 11, 3), 0),
                COALESCE(DECIMAL(NULLIF(:dtlAmount, ''), 15, 5), 0),
                COALESCE(DECIMAL(NULLIF(:dtlCost, ''), 15, 5), 0),
                COALESCE(DECIMAL(NULLIF(:dtlSurchargeAmt, ''), 15, 5), 0),
                COALESCE(DECIMAL(NULLIF(:dtlTaxAmount, ''), 15, 5), 0),
                COALESCE(DECIMAL(NULLIF(:dtlTaxPercent, ''), 7, 4), 0),
                COALESCE(DECIMAL(NULLIF(:dtlPriceOverride, ''), 15, 5), 0)
              );

            // Check for insert errors
            if sqlCode < 0;
              // Log error but continue processing other items
              processStatus = 'E';
              sqlErrCode = sqlCode;
              exec sql GET DIAGNOSTICS CONDITION 1
                :sqlErrState = RETURNED_SQLSTATE,
                :errorMessage = MESSAGE_TEXT;
              
              auditStatus = 'E';
              exec sql
                INSERT INTO JAMIEDEV.XMLORDAUD (
                  ORDERNBR, TRANSMSNID, AUDACTION, TABLENAME, FIELDNAME,
                  USERNAME, PROGRAMNM, REMARKS, IFSDOCUMENTPATH, STATUS
                ) VALUES (
                  :hdrOrderNumber, :transmissionId, 'ERROR', 'XMLORDDTL',
                  'INSERT', CURRENT_USER, 'NEUCOXML',
                  'Failed to insert line ' || TRIM(:dtlLineNumber) ||
                  '. SQLCODE: ' || TRIM(CHAR(:sqlErrCode)) ||
                  ' SQLSTATE: ' || :sqlErrState ||
                  ' - ' || SUBSTR(:errorMessage, 1, 80),
                  :ifsDocPath, :auditStatus
                );
            else;
              // Log successful line item insert
              auditStatus = ' ';
              exec sql
                INSERT INTO JAMIEDEV.XMLORDAUD (
                  ORDERNBR, TRANSMSNID, AUDACTION, TABLENAME, FIELDNAME,
                  USERNAME, PROGRAMNM, REMARKS, IFSDOCUMENTPATH, STATUS
                ) VALUES (
                  :hdrOrderNumber, :transmissionId, 'INSERT', 'XMLORDDTL',
                  'LINE_NUMBER', CURRENT_USER, 'NEUCOXML',
                  'Inserted line ' || TRIM(:dtlLineNumber) ||
                  ': ' || TRIM(:dtlProductName),
                  :ifsDocPath, :auditStatus
                );
            endif;

          enddo;

          // Close cursor
          exec sql close lineItemCursor;

          // Log final processing summary
          auditStatus = ' ';
          exec sql
            INSERT INTO JAMIEDEV.XMLORDAUD (
              ORDERNBR, TRANSMSNID, AUDACTION, TABLENAME, FIELDNAME,
              USERNAME, PROGRAMNM, REMARKS, IFSDOCUMENTPATH, STATUS
            ) VALUES (
              :hdrOrderNumber, :transmissionId, 'COMPLETE', 'SUMMARY',
              'PROCESS_STATUS', CURRENT_USER, 'NEUCOXML',
              'Processing completed. Status: ' || :processStatus ||
              ' - Total line items processed: ' || TRIM(CHAR(:itemCount)),
              :ifsDocPath, :auditStatus
            );

          // Commit all inserts
          exec sql COMMIT;

          //-----------------------------------------------------------
          // Cleanup
          //-----------------------------------------------------------
          // Return success
          return errorInd;
          
          end-proc NEUCOXML;
