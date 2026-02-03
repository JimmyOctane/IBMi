       ctl-opt option(*srcstmt:*nodebugio) debug(*yes) dftactgrp(*no);

       //----------------------------------------------------------
       // PROGRAM NAME - READ_XML_IFS
       //----------------------------------------------------------
       //
       //----------------------------------------------------------
       // Read XML files from IFS folder /home/Nueco
       //----------------------------------------------------------
       // PURPOSE: Use SQL to read folder and pull XML table data
       //
       // SPECIAL NOTES: Based on @read_ifs.sqlrpgle pattern
       //
       //----------------------------------------------------------
       // TASK       DATE   ID  DESCRIPTION
       // ---------- ------ --- ----------------------------
       // JJF   3060 013025 JJF Created program to read XML
       //----------------------------------------------------------

       //=========================================================
       //
       // Program Info
       //
       dcl-ds programStatus psds qualified;
         pgmName *proc;
         parms int(10) pos(37);
         msgData char(80) pos(91);
         msgId char(4) pos(171);
         jobName char(10) pos(244);
         userId char(10) pos(254);
         jobNumber zoned(6) pos(264);
       end-ds;

       //
       // Field Definitions.
       //
       dcl-s fileName varchar(256);
       dcl-s filePath varchar(300);
       dcl-s xmlContent varchar(32000);
       dcl-c CR const(x'0d');
       dcl-c CRLF const(x'0d25');
       dcl-s i int(10);
       dcl-s maxLines packed(5) inz(2000);
       dcl-s rowCount int(10);
       dcl-s fileCount int(10);
       dcl-c Q const('''');

       // Data structures for file listing
       dcl-ds fileList qualified dim(100);
         name varchar(256);
       end-ds;

       // Data structure for reading file content
       dcl-ds xmlLines qualified dim(2000);
         line varchar(500);
       end-ds;

       exec sql set option commit=*none, datfmt=*iso,
                    closqlcsr=*ENDMOD;

       *inlr = *on;

       // First, get list of XML files in /home/Nueco directory
       exec sql
         declare filesCursor scroll cursor for
         select path_name
         from table(qsys2.ifs_object_statistics(
           start_path_name => '/home/Nueco',
           subtree_directories => 'YES',
           object_type_list => '*STMF'))
         where upper(path_name) like '%.XML'
         for read only;

       exec sql open filesCursor;
       exec sql fetch first from filesCursor for 100 rows into
         :fileList;
       exec sql get diagnostics :fileCount = row_count;

       // Process each XML file found
       dow fileCount <> 0;
         for i = 1 to fileCount;
           fileName = %trim(fileList(i).name);

           // Read entire XML file content in single operation
           exec sql
             select listagg(line, x'0A') within group(order by
               line_number)
             into :xmlContent
             from table(qsys2.ifs_read(path_name => :fileName));

           // Create/update table to store XML data (only once)
         endfor;

         exec sql fetch next from filesCursor for 100 rows into
           :fileList;
         exec sql get diagnostics :fileCount = row_count;
       enddo;

       exec sql close filesCursor;

       // Create tables for order header and line items
       monitor;
         exec sql drop table session.xml_order_header;
       on-error;
         // Table doesn't exist, continue
       endmon;

       monitor;
         exec sql drop table session.xml_line_items;
       on-error;
         // Table doesn't exist, continue
       endmon;

       // Create order header table
       exec sql
         create table session.xml_order_header
         (file_name varchar(256) not null,
          order_number char(40),
          po_number varchar(20),
          po_number_2 varchar(20),
          job_name varchar(40),
          unique_id varchar(40),
          freight_method varchar(40),
          vendor_code varchar(40),
          vendor_name varchar(40),
          placed_date varchar(40),
          requested_pickup_time varchar(40),
          branch_sell varchar(40),
          branch_ship varchar(40),
          ship_code varchar(40),
          ship_subcode varchar(40),
          special_instructions varchar(40),
          order_notes varchar(40),
          charge_or_cash varchar(40),
          order_type_code varchar(40),
          order_status_code varchar(40),
          order_status_code_override varchar(40),
          amount varchar(40),
          surcharge_amount varchar(40),
          freight_charges varchar(40),
          extra_charge varchar(40),
          tax_amount varchar(40),
          percentage varchar(40),
          override_price varchar(40),
          account_number varchar(40),
          account_name varchar(40),
          contact varchar(40),
          city varchar(150),
          state varchar(2),
          zip varchar(10),
          country varchar(40),
          address_line_1 varchar(40),
          address_line_2 varchar(40),
          address_line_3 varchar(40),
          ship_contact varchar(40),
          bill_city varchar(40),
          bill_state varchar(40),
          bill_zip varchar(40),
          bill_country varchar(40),
          bill_address_line_1 varchar(40),
          bill_address_line_2 varchar(40),
          bill_address_line_3 varchar(40),
          card_info varchar(40),
          processed_date timestamp default current_timestamp);

       // Create line items table
       exec sql
         create table session.xml_line_items
         (file_name varchar(256) not null,
          line_number char(40),
          type_code varchar(40),
          product_name varchar(40),
          mincron_item_id varchar(40),
          external_item_id varchar(40),
          pim_id varchar(40),
          bundle_id varchar(40),
          quantity varchar(40),
          amount varchar(40),
          cost varchar(40),
          surcharge_amount varchar(40),
          tax_amount varchar(40),
          tax_percent varchar(40),
          price_override varchar(40),
          processed_date timestamp default current_timestamp);

       // Re-process files to insert data
       exec sql
         declare filesCursor2 scroll cursor for
         select path_name
         from table(qsys2.ifs_object_statistics(
           start_path_name => '/home/Nueco',
           subtree_directories => 'YES',
           object_type_list => '*STMF'))
         where upper(path_name) like '%.XML'
         for read only;

       exec sql open filesCursor2;
       exec sql fetch first from filesCursor2 for 100 rows into
         :fileList;
       exec sql get diagnostics :fileCount = row_count;

       dow fileCount <> 0;
         for i = 1 to fileCount;
           fileName = %trim(fileList(i).name);

           // Read entire XML file content in single operation
           exec sql
             select listagg(line, x'0A') within group(order by
               line_number)
             into :xmlContent
             from table(qsys2.ifs_read(path_name => :fileName));

           // Parse XML into header and detail records
           filePath = fileName;
           
           // Insert order header data
           exec sql
             insert into session.xml_order_header
             select
               substr(:fileName, locate_in_string(:fileName,
                 '/', -1) + 1) as file_name,
               X.*
             from xmltable('$doc/transmission/order'
               passing xmlparse(document :xmlContent) as "doc"
               columns
                 order_number char(40) path
                   'OrderHeader/order_info/order_number',
                 po_number varchar(20) path
                   'OrderHeader/order_info/po_number',
                 po_number_2 varchar(20) path
                   'OrderHeader/order_info/po_number_2',
                 job_name varchar(40) path
                   'OrderHeader/order_info/job_name',
                 unique_id varchar(40) path
                   'OrderHeader/order_info/unique_id',
                 freight_method varchar(40) path
                   'OrderHeader/order_info/freight_method',
                 vendor_code varchar(40) path
                   'OrderHeader/order_info/vendor_code',
                 vendor_name varchar(40) path
                   'OrderHeader/order_info/vendor_name',
                 placed_date varchar(40) path
                   'OrderHeader/order_info/placed_date',
                 requested_pickup_time varchar(40) path
                   'OrderHeader/order_info/requested_pickup_time',
                 branch_sell varchar(40) path
                   'OrderHeader/order_info/branch_sell',
                 branch_ship varchar(40) path
                   'OrderHeader/order_info/branch_ship',
                 ship_code varchar(40) path
                   'OrderHeader/order_info/ship_code',
                 ship_subcode varchar(40) path
                   'OrderHeader/order_info/ship_subcode',
                 special_instructions varchar(40) path
                   'OrderHeader/order_info/special_instructions',
                 order_notes varchar(40) path
                   'OrderHeader/order_info/order_notes',
                 charge_or_cash varchar(40) path
                   'OrderHeader/order_info/charge_or_cash',
                 order_type_code varchar(40) path
                   'OrderHeader/order_info/order_type_code',
                 order_status_code varchar(40) path
                   'OrderHeader/order_info/order_status_code',
                 order_status_code_override varchar(40) path
                   'OrderHeader/order_info/order_status_code_override',
                 amount varchar(40) path
                   'OrderHeader/price_header/amount',
                 surcharge_amount varchar(40) path
                   'OrderHeader/price_header/surcharge_amount',
                 freight_charges varchar(40) path
                   'OrderHeader/price_header/extra_charges/freight_charges',
                 extra_charge varchar(40) path
                   'OrderHeader/price_header/extra_charges/extra_charge',
                 tax_amount varchar(40) path
                   'OrderHeader/price_header/tax_info/amount',
                 percentage varchar(40) path
                   'OrderHeader/price_header/tax_info/percentage',
                 override_price varchar(40) path
                   'OrderHeader/price_header/override_price',
                 account_number varchar(40) path
                   'OrderHeader/customer_info/account_number',
                 account_name varchar(40) path
                   'OrderHeader/customer_info/account_name',
                 contact varchar(40) path
                   'OrderHeader/customer_info/contact',
                 city varchar(150) path
                   'OrderHeader/ship_to_info/address/city',
                 state varchar(2) path
                   'OrderHeader/ship_to_info/address/state',
                 zip varchar(10) path
                   'OrderHeader/ship_to_info/address/zip',
                 country varchar(40) path
                   'OrderHeader/ship_to_info/address/country',
                 address_line_1 varchar(40) path
                   'OrderHeader/ship_to_info/address/address_line_1',
                 address_line_2 varchar(40) path
                   'OrderHeader/ship_to_info/address/address_line_2',
                 address_line_3 varchar(40) path
                   'OrderHeader/ship_to_info/address/address_line_3',
                 ship_contact varchar(40) path
                   'OrderHeader/ship_to_info/contact',
                 bill_city varchar(40) path
                   'OrderHeader/billing/bill_to_info/address/city',
                 bill_state varchar(40) path
                   'OrderHeader/billing/bill_to_info/address/state',
                 bill_zip varchar(40) path
                   'OrderHeader/billing/bill_to_info/address/zip',
                 bill_country varchar(40) path
                   'OrderHeader/billing/bill_to_info/address/country',
                 bill_address_line_1 varchar(40) path
                   'OrderHeader/billing/bill_to_info/address/address_line_1',
                 bill_address_line_2 varchar(40) path
                   'OrderHeader/billing/bill_to_info/address/address_line_2',
                 bill_address_line_3 varchar(40) path
                   'OrderHeader/billing/bill_to_info/address/address_line_3',
                 card_info varchar(40) path
                   'OrderHeader/billing/card_info'
             ) as X;

           // Insert line item detail data
           exec sql
             insert into session.xml_line_items
             select
               substr(:fileName, locate_in_string(:fileName,
                 '/', -1) + 1) as file_name,
               Y.*
             from xmltable('$doc/transmission/order/line_items/line_item'
               passing xmlparse(document :xmlContent) as "doc"
               columns
                 line_number char(40) path 'line_number',
                 type_code varchar(40) path 'type_code',
                 product_name varchar(40) path 'product_name',
                 mincron_item_id varchar(40) path 'mincron_item_id',
                 external_item_id varchar(40) path 'external_item_id',
                 pim_id varchar(40) path 'pim_id',
                 bundle_id varchar(40) path 'bundle_id',
                 quantity varchar(40) path 'quantity',
                 amount varchar(40) path 'price/amount',
                 cost varchar(40) path 'price/cost',
                 surcharge_amount varchar(40) path 'price/surcharge_amount',
                 tax_amount varchar(40) path 'price/tax_info/amount',
                 tax_percent varchar(40) path 'price/tax_info/percentage',
                 price_override varchar(40) path 'price/price_override'
             ) as Y;

           // Display processing results for debugging
           dsply 'File processed:';
           dsply %subst(%trim(fileName): 1: 50);
           
           // Get header count for this file
           exec sql
             select count(*) into :rowCount
             from session.xml_order_header
             where file_name = substr(:fileName,
               locate_in_string(:fileName, '/', -1) + 1);
           dsply ('Header records: ' + %char(rowCount));
           
           // Get line item count for this file
           exec sql
             select count(*) into :rowCount
             from session.xml_line_items
             where file_name = substr(:fileName,
               locate_in_string(:fileName, '/', -1) + 1);
           dsply ('Line item records: ' + %char(rowCount));
           
           // Show first line item details
           exec sql
             select product_name, quantity, amount into
               :fileName, :filePath, :xmlContent
             from session.xml_line_items
             where file_name = substr(:fileName,
               locate_in_string(:fileName, '/', -1) + 1)
               and line_number = '1';
           if sqlcode = 0;
             dsply 'First item:';
             dsply %subst(%trim(fileName): 1: 50);
             dsply ('Qty: ' + %subst(%trim(filePath): 1: 20));
             dsply ('Amt: ' + %subst(%trim(xmlContent): 1: 20));
           endif;

         endfor;

         exec sql fetch next from filesCursor2 for 100 rows into
           :fileList;
         exec sql get diagnostics :fileCount = row_count;
       enddo;

       exec sql close filesCursor2;

       // Note: XMLTABLE with PASSING not supported in older
       // DB2 versions. Use alternative XML parsing in separate
       // SQL scripts instead